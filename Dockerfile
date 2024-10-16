FROM centos:7
MAINTAINER SUGOIC0DER-JCHAN

# Update repo list
RUN sed -i 's|mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=os|#mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=os|' /etc/yum.repos.d/CentOS-Base.repo \
    && sed -i 's|mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=updates|#mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=updates|' /etc/yum.repos.d/CentOS-Base.repo \
    && sed -i 's|mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=extras|#mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=extras|' /etc/yum.repos.d/CentOS-Base.repo \
    && sed -i 's|#baseurl=http://mirror.centos.org/centos/$releasever/os/$basearch/|baseurl=http://vault.centos.org/7.9.2009/os/x86_64/|' /etc/yum.repos.d/CentOS-Base.repo \
    && sed -i 's|#baseurl=http://mirror.centos.org/centos/$releasever/updates/$basearch/|baseurl=http://vault.centos.org/7.9.2009/updates/x86_64/|' /etc/yum.repos.d/CentOS-Base.repo \
    && sed -i 's|#baseurl=http://mirror.centos.org/centos/$releasever/extras/$basearch/|baseurl=http://vault.centos.org/7.9.2009/extras/x86_64/|' /etc/yum.repos.d/CentOS-Base.repo \
    && yum clean all

# Import missing GPG key
RUN rpm --import http://vault.centos.org/7.9.2009/os/x86_64/RPM-GPG-KEY-CentOS-7

# Install required packages and update CA certificates
RUN yum install -y epel-release \
    && yum install -y ImageMagick ImageMagick-devel python3-pip ca-certificates \
    && yum clean all

# Copy application
COPY ./app /app
WORKDIR /app

# Updated to install pip3 with --trusted-host to avoid SSL verification issues
RUN pip3 install --trusted-host pypi.python.org --trusted-host pypi.org --trusted-host files.pythonhosted.org -r requirements.txt

# Expose port 8080
EXPOSE 8080

# Start the app with python3
CMD ["python3", "app.py"]
