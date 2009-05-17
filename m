Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:57266 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752380AbZEQMrz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 May 2009 08:47:55 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, stecklum@tls-tautenburg.de,
	me@bobcopeland.com, breusshe@hotmail.com,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 4/4] compat-2.6: Fixed module_disable function with old module-init-tools.
Date: Sun, 17 May 2009 14:47:43 +0200
Message-Id: <1242564463-9120-4-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1242564463-9120-1-git-send-email-hauke@hauke-m.de>
References: <1242564463-9120-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The behavior of modprobe -l chanched. Old versions are returning
the full path and new versions only return the relative path
to the modules directory of the kernel.

Corrected some typos iwl-enable.

Thanks Brett D. Ussher for your help.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 scripts/iwl-enable |    4 ++--
 scripts/modlib.sh  |    5 ++---
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/scripts/iwl-enable b/scripts/iwl-enable
index 1236deb..765195b 100755
--- a/scripts/iwl-enable
+++ b/scripts/iwl-enable
@@ -17,7 +17,7 @@ IWL_NEW="iwlagn"
 IWL_OLD="iwl4965"
 
 # Appended to module file at the end when we want to ignore one
-USAGE="Usage: $0 [ $IWL | $IWL_OLD ]"
+USAGE="Usage: $0 [ $IWL_NEW | $IWL_OLD ]"
 
 function enable_iwlagn {
 	module_disable $IWL_OLD
@@ -36,7 +36,7 @@ elif [ $# -ne 1 ]; then
 fi
 
 MODULE=$1
-if [ "$MODULE" == "iwl4954" ]; then
+if [ "$MODULE" == "iwl4965" ]; then
 	module_disable $IWL_NEW
 	module_enable $IWL_OLD
 elif [ "$MODULE" == "iwlagn" ]; then
diff --git a/scripts/modlib.sh b/scripts/modlib.sh
index 5140949..91e53f1 100755
--- a/scripts/modlib.sh
+++ b/scripts/modlib.sh
@@ -28,7 +28,7 @@ function module_disable {
 	ALL_MODULES=`find /lib/modules/$VER/ -name $MODULE_KO`
 	COUNT=1
 	CHECK=`modprobe -l $MODULE`
-	while  [ ! -z $CHECK ]; do
+	for i in $ALL_MODULES; do
 		if [[ $MODULE_COUNT -gt 1 ]]; then
 			if [[ $COUNT -eq 1 ]]; then
 				echo -en "$MODULE_COUNT $MODULE modules found "
@@ -38,7 +38,7 @@ function module_disable {
 		else
 			echo -en "Disabling $MODULE ..."
 		fi
-		mv -f /lib/modules/$VER/$CHECK /lib/modules/$VER/${CHECK}${IGNORE_SUFFIX}
+		mv -f $i ${i}${IGNORE_SUFFIX}
 		depmod -ae
 		CHECK_AGAIN=`modprobe -l $MODULE`
 		if [ "$CHECK" != "$CHECK_AGAIN" ]; then
@@ -49,7 +49,6 @@ function module_disable {
 			echo "$CHECK"
 		fi
 		let COUNT=$COUNT+1
-		CHECK=$CHECK_AGAIN
 	done
 }
 
-- 
1.6.2.1

