# golang-s2i
FROM registry.access.redhat.com/devtools/go-toolset-rhel7

ENV BUILDER_VERSION 1.0
ENV HOME /opt/app-root
ENV GOPATH $HOME/gopath
ENV PATH $PATH:$GOROOT/bin:$GOBIN

LABEL io.k8s.description="Platform for building go based programs" \
      io.k8s.display-name="gobuilder 0.0.1" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="gobuilder,0.0.1" \
      io.openshift.s2i.scripts-url="image:///usr/local/s2i" \
      io.openshift.s2i.destination="/opt/app-root/destination"

# This base image does not allow yum install without subscription manager on the host
# Other variants might
#RUN yum clean all && \
#    yum install -y epel-release && \
#    yum install -y golang glide && \
#    yum clean all && rm -rf /var/cache/yum/*

COPY ./s2i/bin/ /usr/local/s2i
#RUN useradd -u 1001 -r -g 0 -d ${HOME} -s /sbin/nologin -c "Default Application User" default && \
RUN  mkdir -p /opt/app-root/destination/{src,artifacts} && \ 
    chown -R 1001:0 $HOME && \
    chmod -R og+rwx ${HOME}

WORKDIR ${HOME}
USER 1001
EXPOSE 8080
