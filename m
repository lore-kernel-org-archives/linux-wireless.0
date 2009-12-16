Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:42986 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761383AbZLPLCk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Dec 2009 06:02:40 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 16 Dec 2009 03:02:40 -0800
Date: Wed, 16 Dec 2009 16:32:33 +0530
From: Bala Shanmugam <sbalashanmugam@atheros.com>
To: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	<mcgrof@bombadil.infradead.org>
CC: Jothikumar Mothilal <Jothikumar.Mothilal@Atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH] compat-wireless: Fixed bluetooth modules compilation issues
Message-ID: <20091216110233.GA1771@atheros-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


>From 6861ae1d8f44a9327fe5c7ccd8bfa83e69ceca51 Mon Sep 17 00:00:00 2001
From: Bala Shanmugam <sbalashanmugam@atheros.com>
Date: Tue, 15 Dec 2009 18:13:49 +0530
Subject: [PATCH] Fixed bluetooth modules compilation issues.

 Signed-off-by: Bala Shanmugam <sbalashanmugam@atheros.com>

---
 Makefile                   |    2 +-
 patches/16-bluetooth.patch |  195 ++++++++++++++++++++++++++++++++++++++++++++
 scripts/admin-update.sh    |    9 +-
 3 files changed, 200 insertions(+), 6 deletions(-)

diff --git a/Makefile b/Makefile
index 66790f2..ddaa656 100644
--- a/Makefile
+++ b/Makefile
@@ -28,7 +28,7 @@ obj-$(CONFIG_COMPAT_WIRELESS_MODULES) += drivers/net/wireless/
 
 obj-$(CONFIG_COMPAT_NET_USB_MODULES) += drivers/net/usb/
 
-obj-$(CONFIG_COMPAT_BT) += net/bluetooth/
+obj-$(CONFIG_COMPAT_BLUETOOTH) += net/bluetooth/
 obj-$(CONFIG_COMPAT_BLUETOOTH_MODULES) += drivers/bluetooth/
 
 obj-$(CONFIG_COMPAT_NETWORK_MODULES) += drivers/net/
diff --git a/patches/16-bluetooth.patch b/patches/16-bluetooth.patch
index 32529a0..47e9d0e 100644
--- a/patches/16-bluetooth.patch
+++ b/patches/16-bluetooth.patch
@@ -446,3 +446,198 @@ diff -Nur a/net/bluetooth/rfcomm/tty.c b/net/bluetooth/rfcomm/tty.c
  {
  	struct sock *sk = sock->sk;
  	int err = 0;
+diff -Nur orig_bt/net/bluetooth/af_bluetooth.c mod_bt/net/bluetooth/af_bluetooth.c
+--- orig_bt/net/bluetooth/af_bluetooth.c	2009-12-15 16:40:20.000000000 +0530
++++ mod_bt/net/bluetooth/af_bluetooth.c	2009-12-15 16:46:50.000000000 +0530
+@@ -126,8 +126,12 @@
+ }
+ EXPORT_SYMBOL(bt_sock_unregister);
+
++#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,32))
+ static int bt_sock_create(struct net *net, struct socket *sock, int proto,
+			  int kern)
++#else
++static int bt_sock_create(struct net *net, struct socket *sock, int proto)
++#endif
+ {
+	int err;
+
+@@ -145,7 +149,11 @@
+	read_lock(&bt_proto_lock);
+
+	if (bt_proto[proto] && try_module_get(bt_proto[proto]->owner)) {
++#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,32))
+		err = bt_proto[proto]->create(net, sock, proto, kern);
++#else
++		err = bt_proto[proto]->create(net, sock, proto);
++#endif
+		bt_sock_reclassify_lock(sock, proto);
+		module_put(bt_proto[proto]->owner);
+	}
+@@ -258,7 +266,11 @@
+	skb_reset_transport_header(skb);
+	err = skb_copy_datagram_iovec(skb, 0, msg->msg_iov, copied);
+	if (err == 0)
++#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,32))
+		sock_recv_ts_and_drops(msg, sk, skb);
++#else
++	  sock_recv_timestamp(msg, sk, skb);
++#endif
+
+	skb_free_datagram(sk, skb);
+
+diff -Nur orig_bt/net/bluetooth/bnep/sock.c mod_bt/net/bluetooth/bnep/sock.c
+--- orig_bt/net/bluetooth/bnep/sock.c	2009-12-15 16:40:59.000000000 +0530
++++ mod_bt/net/bluetooth/bnep/sock.c	2009-12-15 16:48:19.000000000 +0530
+@@ -195,8 +195,12 @@
+	.obj_size	= sizeof(struct bt_sock)
+ };
+
++#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,32))
+ static int bnep_sock_create(struct net *net, struct socket *sock, int protocol,
+			    int kern)
++#else
++static int bnep_sock_create(struct net *net, struct socket *sock, int protocol)
++#endif
+ {
+	struct sock *sk;
+
+diff -Nur orig_bt/net/bluetooth/cmtp/sock.c mod_bt/net/bluetooth/cmtp/sock.c
+--- orig_bt/net/bluetooth/cmtp/sock.c	2009-12-15 16:41:29.000000000 +0530
++++ mod_bt/net/bluetooth/cmtp/sock.c	2009-12-15 16:48:31.000000000 +0530
+@@ -190,8 +190,12 @@
+	.obj_size	= sizeof(struct bt_sock)
+ };
+
++#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,32))
+ static int cmtp_sock_create(struct net *net, struct socket *sock, int protocol,
+			    int kern)
++#else
++static int cmtp_sock_create(struct net *net, struct socket *sock, int protocol)
++#endif
+ {
+	struct sock *sk;
+
+diff -Nur orig_bt/net/bluetooth/hci_sock.c mod_bt/net/bluetooth/hci_sock.c
+--- orig_bt/net/bluetooth/hci_sock.c	2009-12-15 16:40:20.000000000 +0530
++++ mod_bt/net/bluetooth/hci_sock.c	2009-12-15 16:47:47.000000000 +0530
+@@ -630,8 +630,12 @@
+	.obj_size	= sizeof(struct hci_pinfo)
+ };
+
++#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,32))
+ static int hci_sock_create(struct net *net, struct socket *sock, int protocol,
+			   int kern)
++#else
++static int hci_sock_create(struct net *net, struct socket *sock, int protocol)
++#endif
+ {
+	struct sock *sk;
+
+diff -Nur orig_bt/net/bluetooth/hidp/core.c mod_bt/net/bluetooth/hidp/core.c
+--- orig_bt/net/bluetooth/hidp/core.c	2009-12-15 16:41:45.000000000 +0530
++++ mod_bt/net/bluetooth/hidp/core.c	2009-12-15 16:48:45.000000000 +0530
+@@ -280,12 +280,14 @@
+	return hidp_queue_report(session, buf, rsize);
+ }
+
++#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,27))
+ static int hidp_output_raw_report(struct hid_device *hid, unsigned char *data, size_t count)
+ {
+	if (hidp_queue_report(hid->driver_data, data, count))
+		return -ENOMEM;
+	return count;
+ }
++#endif
+
+ static void hidp_idle_timeout(unsigned long arg)
+ {
+diff -Nur orig_bt/net/bluetooth/hidp/sock.c mod_bt/net/bluetooth/hidp/sock.c
+--- orig_bt/net/bluetooth/hidp/sock.c	2009-12-15 16:41:45.000000000 +0530
++++ mod_bt/net/bluetooth/hidp/sock.c	2009-12-15 16:48:51.000000000 +0530
+@@ -241,8 +241,12 @@
+	.obj_size	= sizeof(struct bt_sock)
+ };
+
++#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,32))
+ static int hidp_sock_create(struct net *net, struct socket *sock, int protocol,
+			    int kern)
++#else
++static int hidp_sock_create(struct net *net, struct socket *sock, int protocol)
++#endif
+ {
+	struct sock *sk;
+
+diff -Nur orig_bt/net/bluetooth/l2cap.c mod_bt/net/bluetooth/l2cap.c
+--- orig_bt/net/bluetooth/l2cap.c	2009-12-15 16:40:20.000000000 +0530
++++ mod_bt/net/bluetooth/l2cap.c	2009-12-15 16:46:56.000000000 +0530
+@@ -822,8 +822,12 @@
+	return sk;
+ }
+
++#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,32))
+ static int l2cap_sock_create(struct net *net, struct socket *sock, int protocol,
+			     int kern)
++#else
++static int l2cap_sock_create(struct net *net, struct socket *sock, int protocol)
++#endif
+ {
+	struct sock *sk;
+
+@@ -835,7 +839,11 @@
+			sock->type != SOCK_DGRAM && sock->type != SOCK_RAW)
+		return -ESOCKTNOSUPPORT;
+
++#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,32))
+	if (sock->type == SOCK_RAW && !kern && !capable(CAP_NET_RAW))
++#else
++	if (sock->type == SOCK_RAW && !capable(CAP_NET_RAW))
++#endif
+		return -EPERM;
+
+	sock->ops = &l2cap_sock_ops;
+diff -Nur orig_bt/net/bluetooth/rfcomm/sock.c mod_bt/net/bluetooth/rfcomm/sock.c
+--- orig_bt/net/bluetooth/rfcomm/sock.c	2009-12-15 16:42:14.000000000 +0530
++++ mod_bt/net/bluetooth/rfcomm/sock.c	2009-12-15 16:49:07.000000000 +0530
+@@ -323,8 +323,13 @@
+	return sk;
+ }
+
++#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,32))
+ static int rfcomm_sock_create(struct net *net, struct socket *sock,
+			      int protocol, int kern)
++#else
++static int rfcomm_sock_create(struct net *net, struct socket *sock,
++			      int protocol)
++#endif
+ {
+	struct sock *sk;
+
+@@ -704,7 +709,11 @@
+		copied += chunk;
+		size   -= chunk;
+
++#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,32))
+		sock_recv_ts_and_drops(msg, sk, skb);
++#else
++		sock_recv_timestamp(msg, sk, skb);
++#endif
+
+		if (!(flags & MSG_PEEK)) {
+			atomic_sub(chunk, &sk->sk_rmem_alloc);
+diff -Nur orig_bt/net/bluetooth/sco.c mod_bt/net/bluetooth/sco.c
+--- orig_bt/net/bluetooth/sco.c	2009-12-15 16:40:20.000000000 +0530
++++ mod_bt/net/bluetooth/sco.c	2009-12-15 16:47:04.000000000 +0530
+@@ -430,8 +430,12 @@
+	return sk;
+ }
+
++#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,32))
+ static int sco_sock_create(struct net *net, struct socket *sock, int protocol,
+			   int kern)
++#else
++static int sco_sock_create(struct net *net, struct socket *sock, int protocol)
++#endif
+ {
+	struct sock *sk;
+
diff --git a/scripts/admin-update.sh b/scripts/admin-update.sh
index 78652d2..500fe07 100755
--- a/scripts/admin-update.sh
+++ b/scripts/admin-update.sh
@@ -15,8 +15,7 @@
 # 
 # for example
 #
-GIT_URL="git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-testing.git"
-GIT_BT_URL="git://git.kernel.org/pub/scm/linux/kernel/git/holtmann/bluetooth-testing.git"
+GIT_URL="git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git"
 GIT_COMPAT_URL="git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat.git"
 
 INCLUDE_NET_BT="hci_core.h l2cap.h bluetooth.h rfcomm.h hci.h"
@@ -48,12 +47,12 @@ UNDERLINE="\033[02m"
 NET_DIRS="wireless mac80211 rfkill"
 # User exported this variable
 if [ -z $GIT_TREE ]; then
-	GIT_TREE="/home/$USER/wireless-testing/"
+	GIT_TREE="/home/$USER/linux-next/"
 	if [ ! -d $GIT_TREE ]; then
-		echo "Please tell me where your wireless-testing git tree is."
+		echo "Please tell me where your linux-next git tree is."
 		echo "You can do this by exporting its location as follows:"
 		echo
-		echo "  export GIT_TREE=/home/$USER/wireless-testing/"
+		echo "  export GIT_TREE=/home/$USER/linux-next/"
 		echo
 		echo "If you do not have one you can clone the repository:"
 		echo "  git-clone $GIT_URL"
-- 
1.6.0.4

