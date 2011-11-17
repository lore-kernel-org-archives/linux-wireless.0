Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:45953 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932413Ab1KQQCe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Nov 2011 11:02:34 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	"Luis R. Rodriguez" <lrodriguez@qca.qualcomm.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] compat-wireless: support RHEL6 as a build target
Date: Thu, 17 Nov 2011 10:41:33 -0500
Message-Id: <1321544493-2238-1-git-send-email-linville@tuxdriver.com> (sfid-20111117_170238_109685_9CE2ACF5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch enables compatibility with RHEL6 as a build target.  This
mostly includes changes to the configuration system, as well as a
modification of an existing patch for the bluetooth subsystem.

Infrastructure is added to config.mk to provide a series of RHEL
compatibility definitions (e.g. CONFIG_COMPAT_RHEL_6_1).  Also, this
provides some new CONFIG_* definitions needed to provide for build
flexibility required to support RHEL6:

	CONFIG_COMPAT_KFIFO
	CONFIG_COMPAT_FIRMWARE_DATA_RW_NEEDS_FILP
	CONFIG_COMPAT_BT_SOCK_CREATE_NEEDS_KERN

Further, CONFIG_COMPAT_FIRMWARE_CLASS has it's leading space removed in
config.mk so that it will be reflected in compat_autoconf.h as required.
The latter two definitions also lack leading whitespace for the same
reason.

Finally, gen-compat-autoconf.sh is modified to correctly handle the
CONFIG_COMPAT_RHEL_* usage in config.mk.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 config.mk                      |   41 +++++++++++++++++++++++++++++++++++++++-
 patches/16-bluetooth.patch     |   20 +++++++++---------
 scripts/gen-compat-autoconf.sh |    4 +-
 3 files changed, 52 insertions(+), 13 deletions(-)

diff --git a/config.mk b/config.mk
index a71de4e..d0be96d 100644
--- a/config.mk
+++ b/config.mk
@@ -33,6 +33,14 @@ endif
 COMPAT_VERSIONS := $(shell I=$(COMPAT_LATEST_VERSION); while [ "$$I" -gt $(KERNEL_SUBLEVEL) ]; do echo $$I; I=$$(($$I - 1)); done)
 $(foreach ver,$(COMPAT_VERSIONS),$(eval CONFIG_COMPAT_KERNEL_3_$(ver)=y))
 
+RHEL_MAJOR := $(shell grep ^RHEL_MAJOR $(KLIB_BUILD)/Makefile | sed -n 's/.*= *\(.*\)/\1/p')
+
+ifneq ($(RHEL_MAJOR),)
+RHEL_MINOR := $(shell grep ^RHEL_MINOR $(KLIB_BUILD)/Makefile | sed -n 's/.*= *\(.*\)/\1/p')
+COMPAT_RHEL_VERSIONS := $(shell I=$(RHEL_MINOR); while [ "$$I" -ge 0 ]; do echo $$I; I=$$(($$I - 1)); done)
+$(foreach ver,$(COMPAT_RHEL_VERSIONS),$(eval CONFIG_COMPAT_RHEL_$(RHEL_MAJOR)_$(ver)=y))
+endif
+
 ifdef CONFIG_COMPAT_KERNEL_2_6_24
 $(error "ERROR: compat-wireless by default supports kernels >= 2.6.24, try enabling only one driver though")
 endif #CONFIG_COMPAT_KERNEL_2_6_24
@@ -114,12 +122,43 @@ else
 endif
 endif #CONFIG_COMPAT_KERNEL_2_6_27
 
+#
+# CONFIG_COMPAT_FIRMWARE_CLASS definition has no leading whitespace,
+# because it gets passed-on through compat_autoconf.h.
+#
 ifdef CONFIG_COMPAT_KERNEL_2_6_33
+ifndef CONFIG_COMPAT_RHEL_6_1
 ifdef CONFIG_FW_LOADER
- CONFIG_COMPAT_FIRMWARE_CLASS=m
+CONFIG_COMPAT_FIRMWARE_CLASS=m
 endif #CONFIG_FW_LOADER
+endif #CONFIG_COMPAT_RHEL_6_1
 endif #CONFIG_COMPAT_KERNEL_2_6_33
 
+ifdef CONFIG_COMPAT_KERNEL_2_6_36
+ifndef CONFIG_COMPAT_RHEL_6_1
+ CONFIG_COMPAT_KFIFO=y
+endif #CONFIG_COMPAT_RHEL_6_1
+endif #CONFIG_COMPAT_KERNEL_2_6_36
+
+#
+# CONFIG_COMPAT_BT_SOCK_CREATE_NEEDS_KERN definitions have no leading
+# whitespace, because they get passed-on through compat_autoconf.h.
+#
+ifdef CONFIG_COMPAT_KERNEL_2_6_32
+CONFIG_COMPAT_BT_SOCK_CREATE_NEEDS_KERN=y
+endif #CONFIG_COMPAT_KERNEL_2_6_32
+ifdef CONFIG_COMPAT_RHEL_6_0
+CONFIG_COMPAT_BT_SOCK_CREATE_NEEDS_KERN=y
+endif #CONFIG_COMPAT_RHEL_6_0
+
+#
+# CONFIG_COMPAT_FIRMWARE_DATA_RW_NEEDS_FILP definition has no leading
+# whitespace, because it gets passed-on through compat_autoconf.h.
+#
+ifdef CONFIG_COMPAT_RHEL_6_0
+CONFIG_COMPAT_FIRMWARE_DATA_RW_NEEDS_FILP=y
+endif #CONFIG_COMPAT_RHEL_6_0
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
diff --git a/scripts/gen-compat-autoconf.sh b/scripts/gen-compat-autoconf.sh
index fd38c99..0063478 100755
--- a/scripts/gen-compat-autoconf.sh
+++ b/scripts/gen-compat-autoconf.sh
@@ -148,11 +148,11 @@ kernel_version_req $OLDEST_KERNEL_SUPPORTED
 for i in $(egrep '^CONFIG_|^ifdef CONFIG_|^ifndef CONFIG_|^endif #CONFIG_|^else #CONFIG_' $COMPAT_CONFIG | sed 's/ /+/'); do
 	case $i in
 	'ifdef+CONFIG_'* )
-		echo "#$i" | sed -e 's/+/ /' -e 's/\(ifdef CONFIG_COMPAT_KERNEL_3_\)\([0-9]*\)/if (LINUX_VERSION_CODE < KERNEL_VERSION(3,\2,0))/' -e 's/\(ifdef CONFIG_COMPAT_KERNEL_2_6_\)\([0-9]*\)/if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,\2))/' -e 's/\(#ifdef \)\(CONFIG_[^:space:]*\)/#if defined(\2) || defined(\2_MODULE)/'
+		echo "#$i" | sed -e 's/+/ /' -e 's/\(ifdef CONFIG_COMPAT_KERNEL_3_\)\([0-9]*\)/if (LINUX_VERSION_CODE < KERNEL_VERSION(3,\2,0))/' -e 's/\(ifdef CONFIG_COMPAT_KERNEL_2_6_\)\([0-9]*\)/if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,\2))/' -e 's/\(ifdef CONFIG_COMPAT_RHEL_\)\([0-9]*\)_\([0-9]*\)/if (defined(RHEL_MAJOR) \&\& RHEL_MAJOR == \2 \&\& RHEL_MINOR >= \3)/' -e 's/\(#ifdef \)\(CONFIG_[^:space:]*\)/#if defined(\2) || defined(\2_MODULE)/'
 		continue
 		;;
 	'ifndef+CONFIG_'* )
-		echo "#$i" | sed -e 's/+/ /' -e 's/\(ifndef CONFIG_COMPAT_KERNEL_3_\)\([0-9]*\)/if (LINUX_VERSION_CODE >= KERNEL_VERSION(3,\2,0))/' -e 's/\(ifndef CONFIG_COMPAT_KERNEL_2_6_\)\([0-9]*\)/if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,\2))/' -e 's/\(#ifndef \)\(CONFIG_[^:space:]*\)/#if !defined(\2) && !defined(\2_MODULE)/'
+		echo "#$i" | sed -e 's/+/ /' -e 's/\(ifndef CONFIG_COMPAT_KERNEL_3_\)\([0-9]*\)/if (LINUX_VERSION_CODE >= KERNEL_VERSION(3,\2,0))/' -e 's/\(ifndef CONFIG_COMPAT_KERNEL_2_6_\)\([0-9]*\)/if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,\2))/' -e 's/\(ifndef CONFIG_COMPAT_RHEL_\)\([0-9]*\)_\([0-9]*\)/if (!defined(RHEL_MAJOR) || RHEL_MAJOR != \2 || RHEL_MINOR < \3)/' -e 's/\(#ifndef \)\(CONFIG_[^:space:]*\)/#if !defined(\2) && !defined(\2_MODULE)/'
 		continue
 		;;
 	'else+#CONFIG_'* | 'endif+#CONFIG_'* )
-- 
1.7.4.4

