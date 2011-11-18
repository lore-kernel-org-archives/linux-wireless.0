Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:46705 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753864Ab1KRToV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Nov 2011 14:44:21 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, mcgrof@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 3/3] compat-wireless: fetch crc8.c and cordic.c from kernel
Date: Fri, 18 Nov 2011 20:44:06 +0100
Message-Id: <1321645446-22527-3-git-send-email-hauke@hauke-m.de> (sfid-20111118_204423_295908_DA0C5882)
In-Reply-To: <1321645446-22527-1-git-send-email-hauke@hauke-m.de>
References: <1321645446-22527-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

crc8.c and cordic.c are not provided by compat any more, now the
generation script will fetch them from the kernel image.
They are used in the build process only when there is not version of
this library already in the kernel.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 Makefile                           |    1 +
 config.mk                          |    8 ++++++++
 patches/44-use-compat-header.patch |   32 ++++++++++++++++++++++++++++++++
 scripts/admin-clean.sh             |    1 +
 scripts/admin-update.sh            |   16 +++++++++++++++-
 5 files changed, 57 insertions(+), 1 deletions(-)
 create mode 100644 patches/44-use-compat-header.patch

diff --git a/Makefile b/Makefile
index d3a9d93..fd8783d 100644
--- a/Makefile
+++ b/Makefile
@@ -35,6 +35,7 @@ obj-$(CONFIG_COMPAT_NETWORK_MODULES) += drivers/net/ethernet/broadcom/
 obj-$(CONFIG_COMPAT_VAR_MODULES) += drivers/ssb/
 obj-$(CONFIG_COMPAT_VAR_MODULES) += drivers/bcma/
 obj-$(CONFIG_COMPAT_VAR_MODULES) += drivers/misc/eeprom/
+obj-$(CONFIG_COMPAT_VAR_MODULES) += lib/
 
 ifeq ($(CONFIG_STAGING_EXCLUDE_BUILD),)
 endif
diff --git a/config.mk b/config.mk
index 0e964a5..c57e8cc 100644
--- a/config.mk
+++ b/config.mk
@@ -657,6 +657,14 @@ endif #CONFIG_CRC7
 
 CONFIG_MWIFIEX=m
 
+ifndef CONFIG_CORDIC
+CONFIG_COMPAT_CORDIC=m
+endif #CONFIG_CORDIC
+
+ifndef CONFIG_CRC8
+CONFIG_COMPAT_CRC8=m
+endif #CONFIG_CRC8
+
 ifdef CONFIG_COMPAT_KERNEL_2_6_27
 CONFIG_LIBERTAS=n
 else #CONFIG_COMPAT_KERNEL_2_6_27
diff --git a/patches/44-use-compat-header.patch b/patches/44-use-compat-header.patch
new file mode 100644
index 0000000..bd2a114
--- /dev/null
+++ b/patches/44-use-compat-header.patch
@@ -0,0 +1,32 @@
+Make the build use the headers from compat only when the library from 
+compat is used and otherwise the headers in the kernel from which the 
+library is used.
+
+--- a/include/linux/cordic.h
++++ b/include/linux/cordic.h
+@@ -1,3 +1,6 @@
++#ifndef CONFIG_COMPAT_CORDIC
++#include_next <linux/cordic.h>
++#else
+ /*
+  * Copyright (c) 2011 Broadcom Corporation
+  *
+@@ -46,3 +49,4 @@ struct cordic_iq {
+ struct cordic_iq cordic_calc_iq(s32 theta);
+ 
+ #endif /* __CORDIC_H_ */
++#endif /* CONFIG_COMPAT_CORDIC */
+--- a/include/linux/crc8.h
++++ b/include/linux/crc8.h
+@@ -1,3 +1,6 @@
++#ifndef CONFIG_COMPAT_CRC8
++#include_next <linux/crc8.h>
++#else
+ /*
+  * Copyright (c) 2011 Broadcom Corporation
+  *
+@@ -99,3 +102,4 @@ void crc8_populate_msb(u8 table[CRC8_TAB
+ u8 crc8(const u8 table[CRC8_TABLE_SIZE], u8 *pdata, size_t nbytes, u8 crc);
+ 
+ #endif /* __CRC8_H_ */
++#endif /* CONFIG_COMPAT_CRC8 */
diff --git a/scripts/admin-clean.sh b/scripts/admin-clean.sh
index 86d5460..9f3241f 100755
--- a/scripts/admin-clean.sh
+++ b/scripts/admin-clean.sh
@@ -4,6 +4,7 @@ if [ -d net ] ; then
 fi
 rm -rf net
 rm -rf drivers
+rm -rf lib
 rm -rf include
 rm -rf compat
 rm -rf udev
diff --git a/scripts/admin-update.sh b/scripts/admin-update.sh
index 3e63e51..927c0b4 100755
--- a/scripts/admin-update.sh
+++ b/scripts/admin-update.sh
@@ -25,6 +25,8 @@ INCLUDE_LINUX="ieee80211.h nl80211.h"
 INCLUDE_LINUX="$INCLUDE_LINUX pci_ids.h eeprom_93cx6.h"
 INCLUDE_LINUX="$INCLUDE_LINUX ath9k_platform.h"
 INCLUDE_LINUX="$INCLUDE_LINUX wl12xx.h"
+INCLUDE_LINUX="$INCLUDE_LINUX crc8.h"
+INCLUDE_LINUX="$INCLUDE_LINUX cordic.h"
 
 # For rndis_wext
 INCLUDE_LINUX_USB="usbnet.h rndis_host.h"
@@ -272,6 +274,8 @@ DRIVER_FILES="$DRIVER_FILES mac80211_hwsim.c mac80211_hwsim.h"
 DRIVER_FILES="$DRIVER_FILES at76c50x-usb.c at76c50x-usb.h"
 DRIVER_FILES="$DRIVER_FILES mwl8k.c"
 
+LIB_FILES="crc8.c cordic.c"
+
 rm -rf drivers/
 
 mkdir -p include/linux/ include/net/ include/linux/usb \
@@ -287,7 +291,8 @@ mkdir -p include/linux/ include/net/ include/linux/usb \
 	drivers/net/usb/ \
 	drivers/net/wireless/ \
 	drivers/net/ethernet/atheros \
-	drivers/net/ethernet/broadcom
+	drivers/net/ethernet/broadcom \
+	lib
 mkdir -p include/net/bluetooth/
 
 # include/linux
@@ -409,6 +414,15 @@ done
 # Top level wireless driver Makefile
 cp $GIT_TREE/$DIR/Makefile $DIR
 
+DIR="lib"
+# Drivers part of the wireless directory
+for i in $LIB_FILES; do
+	echo "Copying $GIT_TREE/$DIR/$i"
+	cp $GIT_TREE/$DIR/$i $DIR/
+done
+echo "obj-\$(CONFIG_COMPAT_CORDIC) += cordic.o" >> $DIR/Makefile
+echo "obj-\$(CONFIG_COMPAT_CRC8) += crc8.o" >> $DIR/Makefile
+
 # Compat stuff
 COMPAT="compat"
 mkdir -p $COMPAT
-- 
1.7.4.1

