Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:28863 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756093Ab0KVPAa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Nov 2010 10:00:30 -0500
From: luciano.coelho@nokia.com
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 1/1] compat-wireless: apply changes needed after wl1271->wl12xx renaming
Date: Mon, 22 Nov 2010 17:00:27 +0200
Message-Id: <1290438027-20179-2-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1290438027-20179-1-git-send-email-luciano.coelho@nokia.com>
References: <1290438027-20179-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@nokia.com>

This patch changes the occurrences of wl1271 in the Makefile, README and in
the scripts to wl12xx, since the driver has been renamed.

Also remove the wl1271_ prefix from the filenames.

Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 Makefile                             |    4 ++--
 README                               |    2 +-
 patches/06-header-changes.patch      |    4 ++--
 patches/25-multicast-list_head.patch |    4 ++--
 scripts/driver-select                |    6 +++---
 scripts/unload.sh                    |    2 +-
 scripts/wlunload.sh                  |    2 +-
 7 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/Makefile b/Makefile
index db9c836..aab3cdf 100644
--- a/Makefile
+++ b/Makefile
@@ -276,7 +276,7 @@ install-scripts:
 	@$(MODPROBE) -l usb8xxx
 	@$(MODPROBE) -l usbnet
 	@$(MODPROBE) -l wl1251
-	@$(MODPROBE) -l wl1271
+	@$(MODPROBE) -l wl12xx
 	@$(MODPROBE) -l zd1211rw
 	@echo
 	@echo "Currently detected ethernet subsystem modules:"
@@ -405,7 +405,7 @@ uninstall:
 	@$(MODPROBE) -l usb8xxx
 	@$(MODPROBE) -l usbnet
 	@$(MODPROBE) -l wl1251
-	@$(MODPROBE) -l wl1271
+	@$(MODPROBE) -l wl12xx
 	@$(MODPROBE) -l zd1211rw
 	@echo
 	@echo "Your old ethernet subsystem modules are left intact:"
diff --git a/README b/README
index d537290..d1c7884 100644
--- a/README
+++ b/README
@@ -162,7 +162,7 @@ rtl8187
 spectrum_cs
 ssb
 wl1251
-wl1271
+wl12xx
 zd1211rw
 
 This package also provides more drivers which may be documented here
diff --git a/patches/06-header-changes.patch b/patches/06-header-changes.patch
index 1ab2b27..8d06c91 100644
--- a/patches/06-header-changes.patch
+++ b/patches/06-header-changes.patch
@@ -50,8 +50,8 @@ cases.
  #include <linux/spi/spi.h>
  #include <linux/wl12xx.h>
  
---- a/drivers/net/wireless/wl12xx/wl1271_boot.c
-+++ b/drivers/net/wireless/wl12xx/wl1271_boot.c
+--- a/drivers/net/wireless/wl12xx/boot.c
++++ b/drivers/net/wireless/wl12xx/boot.c
 @@ -21,7 +21,6 @@
   *
   */
diff --git a/patches/25-multicast-list_head.patch b/patches/25-multicast-list_head.patch
index aa6fc2a..f84da2c 100644
--- a/patches/25-multicast-list_head.patch
+++ b/patches/25-multicast-list_head.patch
@@ -499,8 +499,8 @@ This also backport commit 2f787b0b76bf5de2eaa3ca3a29d89123ae03c856
  }
  
  static void rtl8187_configure_filter(struct ieee80211_hw *dev,
---- a/drivers/net/wireless/wl12xx/wl1271_main.c
-+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
+--- a/drivers/net/wireless/wl12xx/main.c
++++ b/drivers/net/wireless/wl12xx/main.c
 @@ -1410,11 +1410,20 @@ struct wl1271_filter_params {
  	u8 mc_list[ACX_MC_ADDRESS_GROUP_MAX][ETH_ALEN];
  };
diff --git a/scripts/driver-select b/scripts/driver-select
index ef2b9a7..611e6e1 100755
--- a/scripts/driver-select
+++ b/scripts/driver-select
@@ -30,7 +30,7 @@ PURPLE="\033[35m"
 CYAN="\033[36m"
 UNDERLINE="\033[02m"
 
-SUPPORTED_80211_DRIVERS="ath5k ath9k ath9k_htc carl9170 b43 zd1211rw rt2x00 wl1251 wl1271"
+SUPPORTED_80211_DRIVERS="ath5k ath9k ath9k_htc carl9170 b43 zd1211rw rt2x00 wl1251 wl12xx"
 
 if [ -d drivers/staging/ath6kl ]; then
 	SUPPORTED_80211_DRIVERS="$SUPPORTED_80211_DRIVERS ath6kl"
@@ -60,7 +60,7 @@ function usage {
 	echo -e "\t${CYAN}intel${NORMAL} < ${PURPLE} iwl3945 iwlagn ipw2100 ipw2200 ${NORMAL}>"
 	echo -e "\t${CYAN}iwlwifi${NORMAL} < ${PURPLE} iwl3945 iwlagn ${NORMAL}>"
 	echo -e "\t${CYAN}rtl818x${NORMAL} < ${PURPLE} rtl8180 rtl8187 ${NORMAL}>"
-	echo -e "\t${CYAN}wl12xx${NORMAL} < ${PURPLE} wl1251 wl1271 (SPI and SDIO)${NORMAL}>"
+	echo -e "\t${CYAN}wl12xx${NORMAL} < ${PURPLE} wl1251 wl12xx (SPI and SDIO)${NORMAL}>"
 	
 	echo -e "\nSupported group drivers: Bluetooth & Ethernet:"
 	echo -e "\t${BLUE}atlxx${NORMAL} < ${PURPLE} atl1 atl2 atl1e atl1c ${NORMAL}>"
@@ -398,7 +398,7 @@ case $1 in
 		disable_staging
 		disable_var_01
 		;;
-	wl1271)
+	wl12xx)
 		select_drivers		CONFIG_WL12XX
 		disable_staging
 		disable_var_01
diff --git a/scripts/unload.sh b/scripts/unload.sh
index b7fd8cb..52ad551 100755
--- a/scripts/unload.sh
+++ b/scripts/unload.sh
@@ -8,7 +8,7 @@ OLD_MODULES="$OLD_MODULES ieee80211softmac ieee80211_crypt ieee80211"
 OLD_MODULES="$OLD_MODULES bcm43xx rndis_wext iwl4965"
 MODULES="$OLD_MODULES"
 MODULES="$MODULES ipw2100 ipw2200 libipw"
-MODULES="$MODULES wl1251 wl1271 iwmc3200wifi"
+MODULES="$MODULES wl1251 wl12xx iwmc3200wifi"
 MODULES="$MODULES libertas_cs usb8xxx libertas libertas_sdio libertas_spi"
 MODULES="$MODULES libertas_tf libertas_tf_usb"
 MODULES="$MODULES adm8211 zd1211rw"
diff --git a/scripts/wlunload.sh b/scripts/wlunload.sh
index 8add614..ca7e429 100755
--- a/scripts/wlunload.sh
+++ b/scripts/wlunload.sh
@@ -8,7 +8,7 @@ OLD_MODULES="$OLD_MODULES ieee80211softmac ieee80211_crypt ieee80211"
 OLD_MODULES="$OLD_MODULES bcm43xx rndis_wext iwl4965"
 MODULES="$OLD_MODULES"
 MODULES="$MODULES ipw2100 ipw2200 libipw"
-MODULES="$MODULES wl1251 wl1271 iwmc3200wifi"
+MODULES="$MODULES wl1251 wl12xx iwmc3200wifi"
 MODULES="$MODULES libertas_cs usb8xxx libertas libertas_sdio libertas_spi"
 MODULES="$MODULES libertas_tf libertas_tf_usb"
 MODULES="$MODULES adm8211 zd1211rw"
-- 
1.7.0.4

