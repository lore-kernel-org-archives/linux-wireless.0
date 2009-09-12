Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.153]:19928 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752404AbZILKa7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Sep 2009 06:30:59 -0400
Received: by fg-out-1718.google.com with SMTP id 22so563613fge.1
        for <linux-wireless@vger.kernel.org>; Sat, 12 Sep 2009 03:31:01 -0700 (PDT)
From: Natanael Copa <natanael.copa@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>
Cc: linux-wireless@vger.kernel.org,
	Natanael Copa <natanael.copa@gmail.com>
Subject: [PATCH] compat-2.6: Make it possible to build without running depmod
Date: Sat, 12 Sep 2009 10:31:48 +0000
Message-Id: <1252751508-4390-1-git-send-email-natanael.copa@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When building binary packages you normally don't want to run depmod
for the running kernel. This patch allows packagers override depmod.

 make DEPMOD=: ...

The patch also address the issue in the scripts called from Makefile
and it should be compatible with current behaviour.
---
 Makefile             |    3 ++-
 scripts/check_depmod |    2 +-
 scripts/modlib.sh    |    5 +++--
 3 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/Makefile b/Makefile
index ab97de0..7c796ec 100644
--- a/Makefile
+++ b/Makefile
@@ -8,6 +8,7 @@ endif
 export KLIB_BUILD ?=	$(KLIB)/build
 # Sometimes not available in the path
 MODPROBE := /sbin/modprobe
+DEPMOD := /sbin/depmod
 MADWIFI=$(shell $(MODPROBE) -l ath_pci)
 OLD_IWL=$(shell $(MODPROBE) -l iwl4965)
 
@@ -182,7 +183,7 @@ uninstall:
 	@rm -f $(KLIB)/$(KMODDIR)/drivers/misc/eeprom/eeprom_93cx6.ko*
 	@rm -f $(KLIB)/$(KMODDIR)/drivers/misc/eeprom_93cx6.ko*
 	@rm -f $(KLIB)/$(KMODDIR)/drivers/net/b44.ko*
-	@/sbin/depmod -ae
+	@$(DEPMOD) -ae
 	@echo
 	@echo "Your old wireless subsystem modules were left intact:"
 	@echo 
diff --git a/scripts/check_depmod b/scripts/check_depmod
index f127a6a..0b81573 100755
--- a/scripts/check_depmod
+++ b/scripts/check_depmod
@@ -12,7 +12,7 @@ DEPMOD_DIR="/etc/depmod.d/"
 COMPAT_DEPMOD_FILE=compat-wireless.conf
 GREP_REGEX_UPDATES="^[[:space:]]*search.*[[:space:]]updates\([[:space:]]\|$\)"
 GREP_REGEX_SEARCH="^[[:space:]]*search[[:space:]].\+$"
-DEPMOD_CMD="depmod"
+DEPMOD_CMD="${DEPMOD:-depmod}"
 
 function add_compat_depmod_conf {
 	echo "NOTE: Your distribution lacks an $DEPMOD_DIR directory with "
diff --git a/scripts/modlib.sh b/scripts/modlib.sh
index 91e53f1..76d5b01 100755
--- a/scripts/modlib.sh
+++ b/scripts/modlib.sh
@@ -10,6 +10,7 @@ PATH=$PATH:/usr/sbin:/sbin
 # Appended to module file at the end when we want to ignore one
 IGNORE_SUFFIX=".ignore"
 VER=`uname -r`
+DEPMOD_CMD=${DEPMOD:-depmod}
 
 # If 'module' is found, its renamed to 'module.ignore'
 function module_disable {
@@ -39,7 +40,7 @@ function module_disable {
 			echo -en "Disabling $MODULE ..."
 		fi
 		mv -f $i ${i}${IGNORE_SUFFIX}
-		depmod -ae
+		${DEPMOD_CMD} -ae
 		CHECK_AGAIN=`modprobe -l $MODULE`
 		if [ "$CHECK" != "$CHECK_AGAIN" ]; then
 			echo -e "\t[OK]\tModule disabled:"
@@ -65,7 +66,7 @@ function module_enable {
 		echo -en "Enabling $MODULE ..."
 		DIR=`dirname $i`
 		mv $i $DIR/$MODULE_KO
-		depmod -ae
+		${DEPMOD_CMD} -ae
 		CHECK=`modprobe -l $MODULE`
 		if [ "$DIR/$MODULE_KO" != $CHECK ]; then
 			if [ -z $CHECK ]; then
-- 
1.6.4.2

