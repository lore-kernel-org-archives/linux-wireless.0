Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:34319 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398Ab1KQWWP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Nov 2011 17:22:15 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	"Luis R. Rodriguez" <lrodriguez@qca.qualcomm.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH v2 3/4] compat-wireless: add CONFIG_COMPAT_BT_SOCK_CREATE_NEEDS_KERN
Date: Thu, 17 Nov 2011 17:21:10 -0500
Message-Id: <1321568471-23068-3-git-send-email-linville@tuxdriver.com> (sfid-20111117_232235_442451_21779C47)
In-Reply-To: <1321568471-23068-1-git-send-email-linville@tuxdriver.com>
References: <1321568471-23068-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

An API change in the 2.6.33 timeframe made a number of bluetooth
functions require an extra parameter.  Some kernels (e.g. RHEL6)
backport that API change, and this allow us to accommodate them.

This adds CONFIG_COMPAT_BT_SOCK_CREATE_NEEDS_KERN to config.mk and
modifies an existing patch for the Bluetooth subsystem.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
The original RHEL6 patch included a slightly different (and incorrect)
check for setting CONFIG_COMPAT_BT_SOCK_CREATE_NEEDS_KERN on non-RHEL6
kernels.  I believe this one is correct, as verified by manually
checking the output of gen-compat-autoconf.sh.

 config.mk                  |    8 ++++++++
 patches/16-bluetooth.patch |   20 ++++++++++----------
 2 files changed, 18 insertions(+), 10 deletions(-)

diff --git a/config.mk b/config.mk
index 7116206..2ccca7a 100644
--- a/config.mk
+++ b/config.mk
@@ -128,6 +128,14 @@ ifdef CONFIG_COMPAT_KERNEL_2_6_36
  CONFIG_COMPAT_KFIFO=y
 endif #CONFIG_COMPAT_KERNEL_2_6_36
 
+#
+# CONFIG_COMPAT_BT_SOCK_CREATE_NEEDS_KERN definition has no leading
+# whitespace, because it gets passed-on through compat_autoconf.h.
+#
+ifndef CONFIG_COMPAT_KERNEL_2_6_33
+CONFIG_COMPAT_BT_SOCK_CREATE_NEEDS_KERN=y
+endif #CONFIG_COMPAT_KERNEL_2_6_33
+
 # Wireless subsystem stuff
 CONFIG_MAC80211=m
 
diff --git a/patches/16-bluetooth.patch b/patches/16-bluetooth.patch
index 00bf613..9a87c43 100644
--- a/patches/16-bluetooth.patch
+++ b/patches/16-bluetooth.patch
@@ -45,7 +45,7 @@ here still, but for now we keep this here.
  }
  EXPORT_SYMBOL(bt_sock_unregister);
  
-+#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,32))
++#if defined(CONFIG_COMPAT_BT_SOCK_CREATE_NEEDS_KERN)
  static int bt_sock_create(struct net *net, struct socket *sock, int proto,
  			  int kern)
 +#else
@@ -58,7 +58,7 @@ here still, but for now we keep this here.
  	read_lock(&bt_proto_lock);
  
  	if (bt_proto[proto] && try_module_get(bt_proto[proto]->owner)) {
-+#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,32))
++#if defined(CONFIG_COMPAT_BT_SOCK_CREATE_NEEDS_KERN)
  		err = bt_proto[proto]->create(net, sock, proto, kern);
 +#else
 +		err = bt_proto[proto]->create(net, sock, proto);
@@ -110,7 +110,7 @@ here still, but for now we keep this here.
  	.obj_size	= sizeof(struct hci_pinfo)
  };
  
-+#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,32))
++#if defined(CONFIG_COMPAT_BT_SOCK_CREATE_NEEDS_KERN)
  static int hci_sock_create(struct net *net, struct socket *sock, int protocol,
  			   int kern)
 +#else
@@ -163,7 +163,7 @@ here still, but for now we keep this here.
  	return -EIO;
  }
  
-+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,34))
++#if defined(CONFIG_COMPAT_BT_SOCK_CREATE_NEEDS_KERN)
  static int hidp_output_raw_report(struct hid_device *hid, unsigned char *data, size_t count,
  		unsigned char report_type)
  {
@@ -431,7 +431,7 @@ here still, but for now we keep this here.
  	return sk;
  }
  
-+#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,32))
++#if defined(CONFIG_COMPAT_BT_SOCK_CREATE_NEEDS_KERN)
  static int rfcomm_sock_create(struct net *net, struct socket *sock,
  			      int protocol, int kern)
 +#else
@@ -522,7 +522,7 @@ here still, but for now we keep this here.
  	return sk;
  }
  
-+#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,32))
++#if defined(CONFIG_COMPAT_BT_SOCK_CREATE_NEEDS_KERN)
  static int sco_sock_create(struct net *net, struct socket *sock, int protocol,
  			   int kern)
 +#else
@@ -549,7 +549,7 @@ here still, but for now we keep this here.
  	.obj_size	= sizeof(struct bt_sock)
  };
  
-+#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,32))
++#if defined(CONFIG_COMPAT_BT_SOCK_CREATE_NEEDS_KERN)
  static int bnep_sock_create(struct net *net, struct socket *sock, int protocol,
  			    int kern)
 +#else
@@ -564,7 +564,7 @@ here still, but for now we keep this here.
  	.obj_size	= sizeof(struct bt_sock)
  };
  
-+#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,32))
++#if defined(CONFIG_COMPAT_BT_SOCK_CREATE_NEEDS_KERN)
  static int cmtp_sock_create(struct net *net, struct socket *sock, int protocol,
  			    int kern)
 +#else
@@ -579,7 +579,7 @@ here still, but for now we keep this here.
  	.obj_size	= sizeof(struct bt_sock)
  };
  
-+#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,32))
++#if defined(CONFIG_COMPAT_BT_SOCK_CREATE_NEEDS_KERN)
  static int hidp_sock_create(struct net *net, struct socket *sock, int protocol,
  			    int kern)
 +#else
@@ -609,7 +609,7 @@ here still, but for now we keep this here.
  	return sk;
  }
  
-+#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,32))
++#if defined(CONFIG_COMPAT_BT_SOCK_CREATE_NEEDS_KERN)
  static int l2cap_sock_create(struct net *net, struct socket *sock, int protocol,
  			     int kern)
 +#else
-- 
1.7.4.4

