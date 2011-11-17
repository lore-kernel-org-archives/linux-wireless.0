Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:34321 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721Ab1KQWWQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Nov 2011 17:22:16 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	"Luis R. Rodriguez" <lrodriguez@qca.qualcomm.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH v2 4/4] compat-wireless: support RHEL6 as a build target
Date: Thu, 17 Nov 2011 17:21:11 -0500
Message-Id: <1321568471-23068-4-git-send-email-linville@tuxdriver.com> (sfid-20111117_232240_902446_D14254C1)
In-Reply-To: <1321568471-23068-1-git-send-email-linville@tuxdriver.com>
References: <1321568471-23068-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch enables compatibility with RHEL6 as a build target.  This
mostly includes changes to the configuration system.

Infrastructure is added to config.mk to provide a series of RHEL
compatibility definitions (e.g. CONFIG_COMPAT_RHEL_6_1).  A couple of
checks are added to set appropriate config options for RHEL6 kernels.
Finally, gen-compat-autoconf.sh is modified to correctly handle the
CONFIG_COMPAT_RHEL_* usage in config.mk.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 config.mk                      |   27 +++++++++++++++++++++++++--
 scripts/gen-compat-autoconf.sh |    4 ++--
 2 files changed, 27 insertions(+), 4 deletions(-)

diff --git a/config.mk b/config.mk
index 2ccca7a..19f8afb 100644
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
@@ -119,22 +127,37 @@ endif #CONFIG_COMPAT_KERNEL_2_6_27
 # because it gets passed-on through compat_autoconf.h.
 #
 ifdef CONFIG_COMPAT_KERNEL_2_6_33
+ifndef CONFIG_COMPAT_RHEL_6_1
 ifdef CONFIG_FW_LOADER
 CONFIG_COMPAT_FIRMWARE_CLASS=m
 endif #CONFIG_FW_LOADER
+endif #CONFIG_COMPAT_RHEL_6_1
 endif #CONFIG_COMPAT_KERNEL_2_6_33
 
 ifdef CONFIG_COMPAT_KERNEL_2_6_36
+ifndef CONFIG_COMPAT_RHEL_6_1
  CONFIG_COMPAT_KFIFO=y
+endif #CONFIG_COMPAT_RHEL_6_1
 endif #CONFIG_COMPAT_KERNEL_2_6_36
 
 #
-# CONFIG_COMPAT_BT_SOCK_CREATE_NEEDS_KERN definition has no leading
-# whitespace, because it gets passed-on through compat_autoconf.h.
+# CONFIG_COMPAT_BT_SOCK_CREATE_NEEDS_KERN definitions have no leading
+# whitespace, because they get passed-on through compat_autoconf.h.
 #
 ifndef CONFIG_COMPAT_KERNEL_2_6_33
 CONFIG_COMPAT_BT_SOCK_CREATE_NEEDS_KERN=y
 endif #CONFIG_COMPAT_KERNEL_2_6_33
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
 
 # Wireless subsystem stuff
 CONFIG_MAC80211=m
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

