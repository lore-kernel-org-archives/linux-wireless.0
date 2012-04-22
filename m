Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:51665 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752500Ab2DVWDk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Apr 2012 18:03:40 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com
Cc: lf_driver_backport@lists.linux-foundation.org,
	linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 5/7] compat-wireless: deactivate CONFIG_BT_RFCOMM_TTY for old kernel versions.
Date: Mon, 23 Apr 2012 00:03:17 +0200
Message-Id: <1335132199-21320-5-git-send-email-hauke@hauke-m.de> (sfid-20120423_000343_558872_4D691BF3)
In-Reply-To: <1335132199-21320-1-git-send-email-hauke@hauke-m.de>
References: <1335132199-21320-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

net/bluetooth/rfcomm/tty.c does not build on older kernel versions.
---
 config.mk                              |    4 +++-
 patches/08-rename-config-options.patch |   30 ++++++++++++++++++++++++++++++
 2 files changed, 33 insertions(+), 1 deletion(-)

diff --git a/config.mk b/config.mk
index a718257..584189b 100644
--- a/config.mk
+++ b/config.mk
@@ -194,7 +194,9 @@ export CONFIG_LIB80211_CRYPT_TKIP=m
 
 export CONFIG_BT=m
 export CONFIG_BT_RFCOMM=m
-export CONFIG_BT_RFCOMM_TTY=y
+ifndef CONFIG_COMPAT_KERNEL_2_6_33
+export CONFIG_COMPAT_BT_RFCOMM_TTY=y
+endif #CONFIG_COMPAT_KERNEL_2_6_33
 export CONFIG_BT_BNEP=m
 export CONFIG_BT_BNEP_MC_FILTER=y
 export CONFIG_BT_BNEP_PROTO_FILTER=y
diff --git a/patches/08-rename-config-options.patch b/patches/08-rename-config-options.patch
index da63989..bb24d7f 100644
--- a/patches/08-rename-config-options.patch
+++ b/patches/08-rename-config-options.patch
@@ -133,3 +133,33 @@ CONFIG_BT_HIDP does not build with older kernel versions.
  int ath_rate_control_register(void);
  void ath_rate_control_unregister(void);
  #else
+--- a/net/bluetooth/rfcomm/Makefile
++++ b/net/bluetooth/rfcomm/Makefile
+@@ -5,4 +5,4 @@
+ obj-$(CONFIG_BT_RFCOMM) += rfcomm.o
+ 
+ rfcomm-y			:= core.o sock.o
+-rfcomm-$(CONFIG_BT_RFCOMM_TTY)	+= tty.o
++rfcomm-$(CONFIG_COMPAT_BT_RFCOMM_TTY)	+= tty.o
+--- a/include/net/bluetooth/rfcomm.h
++++ b/include/net/bluetooth/rfcomm.h
+@@ -357,7 +357,7 @@ struct rfcomm_dev_list_req {
+ 
+ int  rfcomm_dev_ioctl(struct sock *sk, unsigned int cmd, void __user *arg);
+ 
+-#ifdef CONFIG_BT_RFCOMM_TTY
++#ifdef CONFIG_COMPAT_BT_RFCOMM_TTY
+ int  rfcomm_init_ttys(void);
+ void rfcomm_cleanup_ttys(void);
+ #else
+--- a/net/bluetooth/rfcomm/sock.c
++++ b/net/bluetooth/rfcomm/sock.c
+@@ -873,7 +873,7 @@ static int rfcomm_sock_ioctl(struct sock
+ 	err = bt_sock_ioctl(sock, cmd, arg);
+ 
+ 	if (err == -ENOIOCTLCMD) {
+-#ifdef CONFIG_BT_RFCOMM_TTY
++#ifdef CONFIG_COMPAT_BT_RFCOMM_TTY
+ 		lock_sock(sk);
+ 		err = rfcomm_dev_ioctl(sk, cmd, (void __user *) arg);
+ 		release_sock(sk);
-- 
1.7.9.5

