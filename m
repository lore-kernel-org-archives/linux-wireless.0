Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:36771 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750893Ab1BJP0w (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Feb 2011 10:26:52 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com
Cc: lrodriguez@atheros.com, linux-wireless@vger.kernel.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/4] compat-wireless: make patches apply again
Date: Thu, 10 Feb 2011 16:26:27 +0100
Message-Id: <1297351590-24019-2-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1297351590-24019-1-git-send-email-hauke@hauke-m.de>
References: <1297351590-24019-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/16-bluetooth.patch               |   32 +++++++++++++++---------------
 patches/31-backport-sk_add_backlog.patch |    6 ++--
 patches/35-fix-makefile-includes.patch   |   14 ++++++------
 3 files changed, 26 insertions(+), 26 deletions(-)

diff --git a/patches/16-bluetooth.patch b/patches/16-bluetooth.patch
index c94528a..d54e517 100644
--- a/patches/16-bluetooth.patch
+++ b/patches/16-bluetooth.patch
@@ -547,9 +547,21 @@ here still, but for now we keep this here.
  {
  	struct sock *sk;
  
---- a/net/bluetooth/l2cap.c
-+++ b/net/bluetooth/l2cap.c
-@@ -982,8 +982,12 @@ static struct sock *l2cap_sock_alloc(str
+--- a/net/bluetooth/l2cap_sock.c
++++ b/net/bluetooth/l2cap_sock.c
+@@ -520,7 +520,11 @@ static int l2cap_sock_getsockopt(struct
+ 	return err;
+ }
+ 
++#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,31))
+ static int l2cap_sock_setsockopt_old(struct socket *sock, int optname, char __user *optval, unsigned int optlen)
++#else
++static int l2cap_sock_setsockopt(struct socket *sock, int level, int optname, char __user *optval, int optlen)
++#endif
+ {
+ 	struct sock *sk = sock->sk;
+ 	struct l2cap_options opts;
+@@ -1067,8 +1071,12 @@ struct sock *l2cap_sock_alloc(struct net
  	return sk;
  }
  
@@ -562,7 +574,7 @@ here still, but for now we keep this here.
  {
  	struct sock *sk;
  
-@@ -995,7 +999,11 @@ static int l2cap_sock_create(struct net
+@@ -1080,7 +1088,11 @@ static int l2cap_sock_create(struct net
  			sock->type != SOCK_DGRAM && sock->type != SOCK_RAW)
  		return -ESOCKTNOSUPPORT;
  
@@ -574,15 +586,3 @@ here still, but for now we keep this here.
  		return -EPERM;
  
  	sock->ops = &l2cap_sock_ops;
-@@ -2043,7 +2051,11 @@ static int l2cap_sock_setsockopt_old(str
- 	return err;
- }
- 
-+#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,31))
- static int l2cap_sock_setsockopt(struct socket *sock, int level, int optname, char __user *optval, unsigned int optlen)
-+#else
-+static int l2cap_sock_setsockopt(struct socket *sock, int level, int optname, char __user *optval, int optlen)
-+#endif
- {
- 	struct sock *sk = sock->sk;
- 	struct bt_security sec;
diff --git a/patches/31-backport-sk_add_backlog.patch b/patches/31-backport-sk_add_backlog.patch
index 704c7c6..916d31f 100644
--- a/patches/31-backport-sk_add_backlog.patch
+++ b/patches/31-backport-sk_add_backlog.patch
@@ -7,9 +7,9 @@ limitted caller via a3a858ff. The older kernels don't have a
 size and as such always are successfull when adding to the
 backlog.
 
---- a/net/bluetooth/l2cap.c
-+++ b/net/bluetooth/l2cap.c
-@@ -4449,8 +4449,12 @@ static inline int l2cap_data_channel(str
+--- a/net/bluetooth/l2cap_core.c
++++ b/net/bluetooth/l2cap_core.c
+@@ -3368,8 +3368,12 @@ static inline int l2cap_data_channel(str
  		if (!sock_owned_by_user(sk)) {
  			l2cap_ertm_data_rcv(sk, skb);
  		} else {
diff --git a/patches/35-fix-makefile-includes.patch b/patches/35-fix-makefile-includes.patch
index 2142da2..ea5b41d 100644
--- a/patches/35-fix-makefile-includes.patch
+++ b/patches/35-fix-makefile-includes.patch
@@ -20,11 +20,11 @@ path the make process will search in the kernel tree for the headers.
 +ccflags-y += -I$(obj)/..
 --- a/drivers/staging/brcm80211/brcmfmac/Makefile
 +++ b/drivers/staging/brcm80211/brcmfmac/Makefile
-@@ -32,9 +32,9 @@ ccflags-y :=			\
- 	-DPKT_FILTER_SUPPORT	\
- 	-DSHOW_EVENTS		\
- 	-DTOE			\
--	-Idrivers/staging/brcm80211/brcmfmac		\
+@@ -35,9 +35,9 @@ ccflags-y :=			\
+ ccflags-$(CONFIG_BRCMDBG)	+= -DDHD_DEBUG
+ 
+ ccflags-y += \
+-	-Idrivers/staging/brcm80211/brcmfmac	\
 -	-Idrivers/staging/brcm80211/include		\
 -	-Idrivers/staging/brcm80211/util
 +	-I$(obj)		\
@@ -35,9 +35,9 @@ path the make process will search in the kernel tree for the headers.
  	wl_cfg80211.o \
 --- a/drivers/staging/brcm80211/brcmsmac/Makefile
 +++ b/drivers/staging/brcm80211/brcmsmac/Makefile
-@@ -24,10 +24,10 @@ ccflags-y :=					\
+@@ -23,10 +23,10 @@ ccflags-y :=				\
+ 	-DWL11N					\
  	-DDBAND					\
- 	-DBCMDMA32				\
  	-DBCMNVRAMR				\
 -	-Idrivers/staging/brcm80211/brcmsmac \
 -	-Idrivers/staging/brcm80211/brcmsmac/phy \
-- 
1.7.1

