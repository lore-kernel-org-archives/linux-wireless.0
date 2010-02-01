Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:34880 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753324Ab0BAWdN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Feb 2010 17:33:13 -0500
From: y@hauke-m.de
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/3] compat-wireless-stable-2.6.33.y: Activate ssb
Date: Mon,  1 Feb 2010 23:25:31 +0100
Message-Id: <1265063133-29682-1-git-send-email-y>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hauke Mehrtens <hauke@hauke-m.de>

This is a backport of compat-wireless commit 67228098e77852a0cf50c7c6c413fa601bd6f5b1

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 Makefile                          |    4 +---
 patches/99-change-makefiles.patch |    6 +++---
 scripts/admin-update.sh           |    2 +-
 3 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/Makefile b/Makefile
index 11d5fcc..8fb031f 100644
--- a/Makefile
+++ b/Makefile
@@ -30,9 +30,7 @@ obj-$(CONFIG_COMPAT_BLUETOOTH) += net/bluetooth/
 obj-$(CONFIG_COMPAT_BLUETOOTH_MODULES) += drivers/bluetooth/
 
 obj-$(CONFIG_COMPAT_NETWORK_MODULES) += drivers/net/
-obj-$(CONFIG_COMPAT_VAR_MODULES) +=  drivers/misc/eeprom/
-# Sorry ssb requires pcmica backport for 2.6.33 which is not done yet
-#					drivers/ssb/
+obj-$(CONFIG_COMPAT_VAR_MODULES) +=  drivers/ssb/ drivers/misc/eeprom/
 
 else
 
diff --git a/patches/99-change-makefiles.patch b/patches/99-change-makefiles.patch
index 0b7246c..ea19a86 100644
--- a/patches/99-change-makefiles.patch
+++ b/patches/99-change-makefiles.patch
@@ -40,7 +40,7 @@ only the wireless stuff.
  
 --- a/drivers/net/wireless/Makefile
 +++ b/drivers/net/wireless/Makefile
-@@ -5,36 +5,14 @@
+@@ -5,36 +5,16 @@
  obj-$(CONFIG_IPW2100) += ipw2x00/
  obj-$(CONFIG_IPW2200) += ipw2x00/
  
@@ -58,8 +58,8 @@ only the wireless stuff.
 -obj-$(CONFIG_PRISM54)		+= prism54/
 -
 -obj-$(CONFIG_HOSTAP)		+= hostap/
--obj-$(CONFIG_B43)		+= b43/
--obj-$(CONFIG_B43LEGACY)		+= b43legacy/
+ obj-$(CONFIG_B43)		+= b43/
+ obj-$(CONFIG_B43LEGACY)		+= b43legacy/
  obj-$(CONFIG_ZD1211RW)		+= zd1211rw/
  obj-$(CONFIG_RTL8180)		+= rtl818x/
  obj-$(CONFIG_RTL8187)		+= rtl818x/
diff --git a/scripts/admin-update.sh b/scripts/admin-update.sh
index 3582592..04c080c 100755
--- a/scripts/admin-update.sh
+++ b/scripts/admin-update.sh
@@ -203,7 +203,7 @@ DIR="drivers/net"
 echo > $DIR/Makefile
 cp $GIT_TREE/$DIR/b44.[ch] $DIR
 # Not yet
-#echo "obj-\$(CONFIG_B44) += b44.o" >> $DIR/Makefile
+echo "obj-\$(CONFIG_B44) += b44.o" >> $DIR/Makefile
 echo "obj-\$(CONFIG_ATL1) += atlx/" >> $DIR/Makefile
 echo "obj-\$(CONFIG_ATL2) += atlx/" >> $DIR/Makefile
 echo "obj-\$(CONFIG_ATL1E) += atl1e/" >> $DIR/Makefile
-- 
1.6.3.3

