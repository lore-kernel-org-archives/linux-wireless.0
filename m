Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:55730 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751283AbZLVPVX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Dec 2009 10:21:23 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/3] compat-wireless: Activate ssb and libertas
Date: Tue, 22 Dec 2009 16:20:01 +0100
Message-Id: <1261495204-28966-3-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1261495204-28966-1-git-send-email-hauke@hauke-m.de>
References: <1261495204-28966-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pcmcia is backported now. So activate ssb and libertas again.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 Makefile                          |    4 +---
 config.mk                         |    2 +-
 patches/99-change-makefiles.patch |   13 +++++--------
 scripts/admin-update.sh           |    8 ++++----
 4 files changed, 11 insertions(+), 16 deletions(-)

diff --git a/Makefile b/Makefile
index d197202..0e352d7 100644
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
 
diff --git a/config.mk b/config.mk
index 726130f..873660d 100644
--- a/config.mk
+++ b/config.mk
@@ -45,7 +45,7 @@ endif
 # as I suspect all users of this package want 802.11e (WME) and
 # 802.11n (HT) support.
 ifneq ($(wildcard $(KLIB_BUILD)/Makefile),)
-COMPAT_LATEST_VERSION = 32
+COMPAT_LATEST_VERSION = 33
 KERNEL_SUBLEVEL := $(shell $(MAKE) -C $(KLIB_BUILD) kernelversion | sed -n 's/^2\.6\.\([0-9]\+\).*/\1/p')
 COMPAT_VERSIONS := $(shell I=$(COMPAT_LATEST_VERSION); while [ "$$I" -gt $(KERNEL_SUBLEVEL) ]; do echo $$I; I=$$(($$I - 1)); done)
 $(foreach ver,$(COMPAT_VERSIONS),$(eval CONFIG_COMPAT_KERNEL_$(ver)=y))
diff --git a/patches/99-change-makefiles.patch b/patches/99-change-makefiles.patch
index 35beaa8..3185040 100644
--- a/patches/99-change-makefiles.patch
+++ b/patches/99-change-makefiles.patch
@@ -40,7 +40,7 @@ only the wireless stuff.
  
 --- a/drivers/net/wireless/Makefile	2009-12-10 22:57:15.000000000 -0800
 +++ b/drivers/net/wireless/Makefile	2009-12-10 22:57:16.000000000 -0800
-@@ -5,36 +5,14 @@
+@@ -5,33 +5,16 @@
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
@@ -71,12 +71,9 @@ only the wireless stuff.
  obj-$(CONFIG_USB_NET_RNDIS_WLAN)	+= rndis_wlan.o
  
 -obj-$(CONFIG_USB_ZD1201)	+= zd1201.o
--obj-$(CONFIG_LIBERTAS)		+= libertas/
--
--obj-$(CONFIG_LIBERTAS_THINFIRM)	+= libertas_tf/
- 
- obj-$(CONFIG_ADM8211)	+= adm8211.o
+ obj-$(CONFIG_LIBERTAS)		+= libertas/
  
+ obj-$(CONFIG_LIBERTAS_THINFIRM)	+= libertas_tf/
 --- a/net/wireless/Makefile	2009-10-06 13:00:59.000000000 -0400
 +++ b/net/wireless/Makefile	2009-10-06 13:00:59.000000000 -0400
 @@ -4,11 +4,6 @@
diff --git a/scripts/admin-update.sh b/scripts/admin-update.sh
index 500fe07..9f0278b 100755
--- a/scripts/admin-update.sh
+++ b/scripts/admin-update.sh
@@ -98,9 +98,9 @@ DRIVERS="$DRIVERS drivers/net/wireless/wl12xx"
 DRIVERS="$DRIVERS drivers/net/wireless/iwmc3200wifi"
 
 # Ethernet drivers
-DRIVERS="$DRIVERS drivers/net/atl1c/"
-DRIVERS="$DRIVERS drivers/net/atl1e/"
-DRIVERS="$DRIVERS drivers/net/atlx/"
+DRIVERS="$DRIVERS drivers/net/atl1c"
+DRIVERS="$DRIVERS drivers/net/atl1e"
+DRIVERS="$DRIVERS drivers/net/atlx"
 
 # Bluetooth drivers
 DRIVERS_BT="drivers/bluetooth"
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

