Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:24856 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757390Ab2BYBwX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Feb 2012 20:52:23 -0500
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
To: <linux-wireless@vger.kernel.org>
CC: <hauke@hauke-m.de>, <nbd@nbd.name>, <linville@tuxdriver.com>,
	"Luis R. Rodriguez" <mcgrof@frijolero.org>
Subject: [PATCH 4/5] compat-wireless: start using CONFIG_COMPAT_KERNEL_ in code
Date: Fri, 24 Feb 2012 17:52:05 -0800
Message-ID: <1330134726-1634-5-git-send-email-rodrigue@qca.qualcomm.com> (sfid-20120225_025227_467112_831632A0)
In-Reply-To: <1330134726-1634-1-git-send-email-rodrigue@qca.qualcomm.com>
References: <1330134726-1634-1-git-send-email-rodrigue@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luis R. Rodriguez <mcgrof@frijolero.org>

This lets use the defined CONFIG_COMPAT_KERNEL_* in C code and
header files. Next step is to remove the Makefile hackery to
defines CONFIG_COMPAT_KERNEL_* stuff as we have a generated
file for us now.

Signed-off-by: Luis R. Rodriguez <mcgrof@frijolero.org>
---
 Makefile                       |   14 +++++++++-----
 scripts/check_config.sh        |    9 +++++----
 scripts/gen-compat-autoconf.sh |   13 +++++++------
 3 files changed, 21 insertions(+), 15 deletions(-)

diff --git a/Makefile b/Makefile
index 4149d8d..b5423ee 100644
--- a/Makefile
+++ b/Makefile
@@ -8,6 +8,7 @@ endif
 export KLIB_BUILD ?=	$(KLIB)/build
 # Sometimes not available in the path
 MODPROBE := /sbin/modprobe
+export MAKE
 
 ifneq ($(wildcard $(MODPROBE)),)
 MADWIFI=$(shell $(MODPROBE) -l ath_pci)
@@ -66,14 +67,16 @@ CFLAGS += \
 
 # These exported as they are used by the scripts
 # to check config and compat autoconf
-export COMPAT_CONFIG=config.mk
-export CONFIG_CHECK=.$(COMPAT_CONFIG)_md5sum.txt
+export COMPAT_CONFIG_CW=config.mk
+export COMPAT_CONFIG=.config
+export CONFIG_CHECK=.$(COMPAT_CONFIG_CW)_md5sum.txt
 export COMPAT_AUTOCONF=include/linux/compat_autoconf.h
 export CREL=$(shell cat $(PWD)/compat_version)
 export CREL_PRE:=.compat_autoconf_
 export CREL_CHECK:=$(CREL_PRE)$(CREL)
 
-include $(PWD)/$(COMPAT_CONFIG)
+include $(PWD)/$(COMPAT_CONFIG_CW)
+-include $(PWD)/$(COMPAT_CONFIG)
 
 all: modules
 
@@ -92,10 +95,11 @@ bt: $(CREL_CHECK)
 # $(COMPAT_CONFIG) file
 $(CREL_CHECK):
 	@# Force to regenerate compat autoconf
+	@./compat/scripts/gen-compat-config.sh > $(PWD)/$(COMPAT_CONFIG)
 	@rm -f $(CONFIG_CHECK)
 	@./scripts/check_config.sh
 	@touch $@
-	@md5sum $(COMPAT_CONFIG) > $(CONFIG_CHECK)
+	@md5sum $(COMPAT_CONFIG_CW) > $(CONFIG_CHECK)
 
 btinstall: btuninstall bt-install-modules
 
@@ -234,4 +238,4 @@ wlunload:
 endif
 
 clean-files += Module.symvers Module.markers modules modules.order
-clean-files += $(CREL_CHECK) $(CONFIG_CHECK)
+clean-files += $(CREL_CHECK) $(CONFIG_CHECK) $(COMPAT_CONFIG)
diff --git a/scripts/check_config.sh b/scripts/check_config.sh
index 1ac9620..1804976 100755
--- a/scripts/check_config.sh
+++ b/scripts/check_config.sh
@@ -3,14 +3,15 @@
 # regenerates the compat_autoconf header.
 
 # These variables are expected to be exported:
-#COMPAT_CONFIG="config"
+#COMPAT_CONFIG=".config"
+#COMPAT_CONFIG_CW="config"
 #CONFIG_CHECK=".${COMPAT_CONFIG}.md5"
 #COMPAT_AUTOCONF="include/linux/compat_autoconf.h"
 
 function gen_compat_autoconf {
-	echo "./scripts/gen-compat-autoconf.sh $COMPAT_CONFIG > $COMPAT_AUTOCONF"
-	./scripts/gen-compat-autoconf.sh $COMPAT_CONFIG > $COMPAT_AUTOCONF
-	md5sum $COMPAT_CONFIG > $CONFIG_CHECK
+	echo "./scripts/gen-compat-autoconf.sh $COMPAT_CONFIG $COMPAT_CONFIG_CW > $COMPAT_AUTOCONF"
+	./scripts/gen-compat-autoconf.sh $COMPAT_CONFIG $COMPAT_CONFIG_CW > $COMPAT_AUTOCONF
+	md5sum $COMPAT_CONFIG $COMPAT_CONFIG_CW > $CONFIG_CHECK
 }
 
 which md5sum 2>&1 > /dev/null
diff --git a/scripts/gen-compat-autoconf.sh b/scripts/gen-compat-autoconf.sh
index 28ed25a..58a1c51 100755
--- a/scripts/gen-compat-autoconf.sh
+++ b/scripts/gen-compat-autoconf.sh
@@ -16,15 +16,16 @@ COMPAT_RELEASE="compat_version"
 KERNEL_RELEASE="compat_base_tree_version"
 MULT_DEP_FILE=".compat_pivot_dep"
 
-if [ $# -ne 1 ]; then
-	echo "Usage $0 config-file"
+if [ $# -ne 2 ]; then
+	echo "Usage $0 <generic-compat-config-file> <compat-wireless-config-file>"
 	exit
 fi
 
-COMPAT_CONFIG="$1"
+COMPAT_CONFIG_1="$1"
+COMPAT_CONFIG_2="$2"
 
-if [ ! -f $COMPAT_CONFIG ]; then
-	echo "File $1 is not a file"
+if [[ ! -f $COMPAT_CONFIG_1 || ! -f $COMPAT_CONFIG_2 ]]; then
+	echo "File $COMPAT_CONFIG_1 and $COMPAT_CONFIG_2 files must be present"
 	exit
 fi
 
@@ -145,7 +146,7 @@ EOF
 kernel_version_req $OLDEST_KERNEL_SUPPORTED
 
 # For each CONFIG_FOO=x option
-for i in $(egrep '^CONFIG_|^ifdef CONFIG_|^ifndef CONFIG_|^endif #CONFIG_|^else #CONFIG_' $COMPAT_CONFIG | sed 's/ /+/'); do
+for i in $(egrep -h '^CONFIG_|^ifdef CONFIG_|^ifndef CONFIG_|^endif #CONFIG_|^else #CONFIG_' $COMPAT_CONFIG_1 $COMPAT_CONFIG_2 | sed 's/ /+/'); do
 	case $i in
 	'ifdef+CONFIG_'* )
 		echo "#$i" | sed -e 's/+/ /' -e 's/\(ifdef CONFIG_COMPAT_KERNEL_3_\)\([0-9]*\)/if (LINUX_VERSION_CODE < KERNEL_VERSION(3,\2,0))/' -e 's/\(ifdef CONFIG_COMPAT_KERNEL_2_6_\)\([0-9]*\)/if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,\2))/' -e 's/\(ifdef CONFIG_COMPAT_RHEL_\)\([0-9]*\)_\([0-9]*\)/if (defined(RHEL_MAJOR) \&\& RHEL_MAJOR == \2 \&\& RHEL_MINOR >= \3)/' -e 's/\(#ifdef \)\(CONFIG_[^:space:]*\)/#if defined(\2) || defined(\2_MODULE)/'
-- 
1.7.4.15.g7811d

