Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:52000 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755595Ab1HRLpO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Aug 2011 07:45:14 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, lists@wildgooses.com,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] compat-wireless: fix building with CONFIG_CFG80211_INTERNAL_REGDB
Date: Thu, 18 Aug 2011 13:45:04 +0200
Message-Id: <1313667904-15188-1-git-send-email-hauke@hauke-m.de> (sfid-20110818_134518_552157_E1038699)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When building with CONFIG_CFG80211_INTERNAL_REGDB set there is a db.txt
and genregdb.awk needed. $(srctree) contains the position of the kernel
source and not the position of the compat-wireless root directory.

Reported-by: Ed W <lists@wildgooses.com>
Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 config.mk                              |    1 +
 patches/35-fix-makefile-includes.patch |   10 ++++++++++
 scripts/admin-update.sh                |    4 ++++
 3 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/config.mk b/config.mk
index e2bffeb..7c6bc3b 100644
--- a/config.mk
+++ b/config.mk
@@ -158,6 +158,7 @@ CONFIG_CFG80211_DEFAULT_PS=y
 # CONFIG_NL80211_TESTMODE=y
 # CONFIG_CFG80211_DEVELOPER_WARNINGS=y
 # CONFIG_CFG80211_REG_DEBUG=y
+# CONFIG_CFG80211_INTERNAL_REGDB=y
 # See below for wext stuff
 
 CONFIG_LIB80211=m
diff --git a/patches/35-fix-makefile-includes.patch b/patches/35-fix-makefile-includes.patch
index 3211c71..aa3dd92 100644
--- a/patches/35-fix-makefile-includes.patch
+++ b/patches/35-fix-makefile-includes.patch
@@ -59,3 +59,13 @@ path the make process will search in the kernel tree for the headers.
  
  BRCMUTIL_OFILES := \
  	utils.o \
+--- a/net/wireless/Makefile
++++ b/net/wireless/Makefile
+@@ -18,6 +18,6 @@ cfg80211-$(CONFIG_CFG80211_INTERNAL_REGD
+ ccflags-y += -D__CHECK_ENDIAN__
+ 
+ $(obj)/regdb.c: $(src)/db.txt $(src)/genregdb.awk
+-	@$(AWK) -f $(srctree)/$(src)/genregdb.awk < $< > $@
++	@$(AWK) -f $(src)/genregdb.awk < $< > $@
+ 
+ clean-files := regdb.c
diff --git a/scripts/admin-update.sh b/scripts/admin-update.sh
index edd45d4..061748c 100755
--- a/scripts/admin-update.sh
+++ b/scripts/admin-update.sh
@@ -328,6 +328,10 @@ for i in $NET_DIRS; do
 	rm -f net/$i/*.mod.c
 done
 
+# Copy files needed for statically compiled regulatory rules database
+cp $GIT_TREE/net/wireless/db.txt net/wireless/
+cp $GIT_TREE/net/wireless/genregdb.awk net/wireless/
+
 # net/bluetooth
 for i in $NET_BT_DIRS; do
 	mkdir -p net/$i
-- 
1.7.4.1

