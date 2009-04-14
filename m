Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:57540 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751330AbZDNQvv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Apr 2009 12:51:51 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] [compat-2.6] Reflect changes in wireless-testing.
Date: Tue, 14 Apr 2009 18:51:42 +0200
Message-Id: <1239727902-11866-1-git-send-email-hauke@hauke-m.de> (sfid-20090414_185159_083164_30D75C02)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Change the location of ath5k, ath9k and ar9170.
* modify some scripts to work with recent version of wireless-testing.
  * ath9k will be loaded if madwifi is deactivated.
  * Broadcoms wl.ko will be deactivated if b43 or b43legacy are loaded.
  * Many modules were added or chanced their name in the last months.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 Makefile                |   78 +++++++++++++++++++++++++++++++---------------
 compat/compat.diff      |   10 +++---
 config.mk               |    6 +++
 scripts/admin-update.sh |    7 ++--
 scripts/athenable       |    4 ++
 scripts/athload         |    5 +++
 scripts/b43enable       |   11 ++++++-
 scripts/load.sh         |    6 ++-
 scripts/modlib.sh       |    2 +-
 scripts/unload.sh       |   23 ++++++++------
 10 files changed, 104 insertions(+), 48 deletions(-)

diff --git a/Makefile b/Makefile
index 4b0a7e5..234db25 100644
--- a/Makefile
+++ b/Makefile
@@ -104,39 +104,52 @@ install: uninstall modules
 	@$(MODPROBE) -l cfg80211
 	@$(MODPROBE) -l lib80211
 	@$(MODPROBE) -l adm8211
+	@$(MODPROBE) -l ar9170usb
 	@$(MODPROBE) -l at76c50x-usb
+	@$(MODPROBE) -l ath
 	@$(MODPROBE) -l ath5k
 	@$(MODPROBE) -l ath9k
 	@$(MODPROBE) -l b43
 	@$(MODPROBE) -l b43legacy
 	@$(MODPROBE) -l b44
-	@$(MODPROBE) -l ssb
-	@$(MODPROBE) -l rc80211_simple
-	@$(MODPROBE) -l iwlcore
-	@$(MODPROBE) -l iwl3945
-	@$(MODPROBE) -l iwlagn
+	@$(MODPROBE) -l cdc_ether
+	@$(MODPROBE) -l eeprom_93cx6
 	@$(MODPROBE) -l ipw2100
 	@$(MODPROBE) -l ipw2200
-	@$(MODPROBE) -l libipw
-	@$(MODPROBE) -l lib80211
-	@$(MODPROBE) -l lib80211_crypt
+	@$(MODPROBE) -l iwl3945
+	@$(MODPROBE) -l iwlagn
+	@$(MODPROBE) -l iwlcore
+	@$(MODPROBE) -l lib80211_crypt_ccmp
+	@$(MODPROBE) -l lib80211_crypt_tkip
+	@$(MODPROBE) -l lib80211_crypt_wep
+	@$(MODPROBE) -l libertas
 	@$(MODPROBE) -l libertas_cs
+	@$(MODPROBE) -l libertas_sdio
+	@$(MODPROBE) -l libertas_spi
 	@$(MODPROBE) -l libertas_tf
 	@$(MODPROBE) -l libertas_tf_usb
-	@$(MODPROBE) -l ub8xxx
+	@$(MODPROBE) -l libipw
+	@$(MODPROBE) -l mac80211_hwsim
+	@$(MODPROBE) -l mwl8k
+	@$(MODPROBE) -l p54common
 	@$(MODPROBE) -l p54pci
+	@$(MODPROBE) -l p54spi
 	@$(MODPROBE) -l p54usb
+	@$(MODPROBE) -l rndis_host
+	@$(MODPROBE) -l rndis_wlan
 	@$(MODPROBE) -l rt2400pci
 	@$(MODPROBE) -l rt2500pci
 	@$(MODPROBE) -l rt2500usb
+	@$(MODPROBE) -l rt2x00lib
+	@$(MODPROBE) -l rt2x00pci
+	@$(MODPROBE) -l rt2x00usb
 	@$(MODPROBE) -l rt61pci
 	@$(MODPROBE) -l rt73usb
-	@$(MODPROBE) -l usbnet
-	@$(MODPROBE) -l cdc_ether
-	@$(MODPROBE) -l rndis_host
-	@$(MODPROBE) -l rndis_wlan
 	@$(MODPROBE) -l rtl8180
 	@$(MODPROBE) -l rtl8187
+	@$(MODPROBE) -l ssb
+	@$(MODPROBE) -l usb8xxx
+	@$(MODPROBE) -l usbnet
 	@$(MODPROBE) -l zd1211rw
 	@echo 
 	@echo Now run:
@@ -166,39 +179,52 @@ uninstall:
 	@$(MODPROBE) -l cfg80211
 	@$(MODPROBE) -l lib80211
 	@$(MODPROBE) -l adm8211
+	@$(MODPROBE) -l ar9170usb
 	@$(MODPROBE) -l at76c50x-usb
+	@$(MODPROBE) -l ath
 	@$(MODPROBE) -l ath5k
 	@$(MODPROBE) -l ath9k
 	@$(MODPROBE) -l b43
 	@$(MODPROBE) -l b43legacy
 	@$(MODPROBE) -l b44
-	@$(MODPROBE) -l ssb
-	@$(MODPROBE) -l rc80211_simple
-	@$(MODPROBE) -l iwlcore
-	@$(MODPROBE) -l iwl3945
-	@$(MODPROBE) -l iwlagn
+	@$(MODPROBE) -l cdc_ether
+	@$(MODPROBE) -l eeprom_93cx6
 	@$(MODPROBE) -l ipw2100
 	@$(MODPROBE) -l ipw2200
-	@$(MODPROBE) -l libipw
-	@$(MODPROBE) -l lib80211
-	@$(MODPROBE) -l lib80211_crypt
+	@$(MODPROBE) -l iwl3945
+	@$(MODPROBE) -l iwlagn
+	@$(MODPROBE) -l iwlcore
+	@$(MODPROBE) -l lib80211_crypt_ccmp
+	@$(MODPROBE) -l lib80211_crypt_tkip
+	@$(MODPROBE) -l lib80211_crypt_wep
+	@$(MODPROBE) -l libertas
 	@$(MODPROBE) -l libertas_cs
+	@$(MODPROBE) -l libertas_sdio
+	@$(MODPROBE) -l libertas_spi
 	@$(MODPROBE) -l libertas_tf
 	@$(MODPROBE) -l libertas_tf_usb
-	@$(MODPROBE) -l ub8xxx
+	@$(MODPROBE) -l libipw
+	@$(MODPROBE) -l mac80211_hwsim
+	@$(MODPROBE) -l mwl8k
+	@$(MODPROBE) -l p54common
 	@$(MODPROBE) -l p54pci
+	@$(MODPROBE) -l p54spi
 	@$(MODPROBE) -l p54usb
+	@$(MODPROBE) -l rndis_host
+	@$(MODPROBE) -l rndis_wlan
 	@$(MODPROBE) -l rt2400pci
 	@$(MODPROBE) -l rt2500pci
 	@$(MODPROBE) -l rt2500usb
+	@$(MODPROBE) -l rt2x00lib
+	@$(MODPROBE) -l rt2x00pci
+	@$(MODPROBE) -l rt2x00usb
 	@$(MODPROBE) -l rt61pci
 	@$(MODPROBE) -l rt73usb
-	@$(MODPROBE) -l usbnet
-	@$(MODPROBE) -l cdc_ether
-	@$(MODPROBE) -l rndis_host
-	@$(MODPROBE) -l rndis_wlan
 	@$(MODPROBE) -l rtl8180
 	@$(MODPROBE) -l rtl8187
+	@$(MODPROBE) -l ssb
+	@$(MODPROBE) -l usb8xxx
+	@$(MODPROBE) -l usbnet
 	@$(MODPROBE) -l zd1211rw
 	@
 	@echo 
diff --git a/compat/compat.diff b/compat/compat.diff
index 9476083..d227f66 100644
--- a/compat/compat.diff
+++ b/compat/compat.diff
@@ -429,7 +429,7 @@
  	dev->tx_queue_len = 0;
 --- a/drivers/net/wireless/rndis_wlan.c
 +++ b/drivers/net/wireless/rndis_wlan.c
-@@ -2524,6 +2524,7 @@ static int bcm4320_early_init(struct usbnet *usbdev)
+@@ -2381,6 +2381,7 @@ static int bcm4320_early_init(struct usbnet *usbdev)
  	return 0;
  }
  
@@ -437,7 +437,7 @@
  /* same as rndis_netdev_ops but with local multicast handler */
  static const struct net_device_ops rndis_wext_netdev_ops = {
  	.ndo_open		= usbnet_open,
-@@ -2534,6 +2535,7 @@ static const struct net_device_ops rndis_wext_netdev_ops = {
+@@ -2391,6 +2392,7 @@ static const struct net_device_ops rndis_wext_netdev_ops = {
  	.ndo_validate_addr	= eth_validate_addr,
  	.ndo_set_multicast_list	= rndis_wext_set_multicast_list,
  };
@@ -445,7 +445,7 @@
  
  
  static int rndis_wext_bind(struct usbnet *usbdev, struct usb_interface *intf)
-@@ -2570,7 +2572,11 @@ static int rndis_wext_bind(struct usbnet *usbdev, struct usb_interface *intf)
+@@ -2435,7 +2437,11 @@ static int rndis_wext_bind(struct usbnet *usbdev, struct usb_interface *intf)
  	 * rndis_host wants to avoid all OID as much as possible
  	 * so do promisc/multicast handling in rndis_wext.
  	 */
@@ -553,7 +553,7 @@
  
  #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
  	if (net_ratelimit())
-@@ -811,6 +813,7 @@ struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
+@@ -797,6 +799,7 @@ struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
  }
  EXPORT_SYMBOL(ieee80211_alloc_hw);
  
@@ -561,7 +561,7 @@
  static const struct net_device_ops ieee80211_master_ops = {
  	.ndo_start_xmit = ieee80211_master_start_xmit,
  	.ndo_open = ieee80211_master_open,
-@@ -818,12 +821,22 @@ static const struct net_device_ops ieee80211_master_ops = {
+@@ -804,12 +807,22 @@ static const struct net_device_ops ieee80211_master_ops = {
  	.ndo_set_multicast_list = ieee80211_master_set_multicast_list,
  	.ndo_select_queue = ieee80211_select_queue,
  };
diff --git a/config.mk b/config.mk
index 2cab9d2..08719f9 100644
--- a/config.mk
+++ b/config.mk
@@ -138,6 +138,7 @@ CONFIG_IWL3945_SPECTRUM_MEASUREMENT=y
 
 
 CONFIG_B43=m
+CONFIG_B43_HWRNG=y
 CONFIG_B43_PCI_AUTOSELECT=y
 CONFIG_B43_PCICORE_AUTOSELECT=y
 CONFIG_B43_PCMCIA=y
@@ -148,6 +149,7 @@ CONFIG_B43_LEDS=y
 # CONFIG_B43_FORCE_PIO=y
 
 CONFIG_B43LEGACY=m
+CONFIG_B43LEGACY_HWRNG=y
 CONFIG_B43LEGACY_PCI_AUTOSELECT=y
 CONFIG_B43LEGACY_PCICORE_AUTOSELECT=y
 CONFIG_B43LEGACY_LEDS=y
@@ -294,6 +296,10 @@ endif
 
 # p54
 CONFIG_P54_COMMON=m
+CONFIG_P54_LEDS=y
+
+# Atheros
+CONFIG_ATH_COMMON=m
 
 
 # Sonics Silicon Backplane
diff --git a/scripts/admin-update.sh b/scripts/admin-update.sh
index 881db66..46ba4d5 100755
--- a/scripts/admin-update.sh
+++ b/scripts/admin-update.sh
@@ -46,8 +46,10 @@ else
 	echo "You said your wireless-testing git tree is: $GIT_TREE"
 fi
 # Drivers that have their own directory
-DRIVERS="drivers/net/wireless/ath5k"
-DRIVERS="$DRIVERS drivers/net/wireless/ath9k"
+DRIVERS="drivers/net/wireless/ath"
+DRIVERS="$DRIVERS drivers/net/wireless/ath/ar9170"
+DRIVERS="$DRIVERS drivers/net/wireless/ath/ath5k"
+DRIVERS="$DRIVERS drivers/net/wireless/ath/ath9k"
 DRIVERS="$DRIVERS drivers/ssb"
 DRIVERS="$DRIVERS drivers/net/wireless/b43"
 DRIVERS="$DRIVERS drivers/net/wireless/b43legacy"
@@ -59,7 +61,6 @@ DRIVERS="$DRIVERS drivers/net/wireless/p54"
 DRIVERS="$DRIVERS drivers/net/wireless/rtl818x"
 DRIVERS="$DRIVERS drivers/net/wireless/libertas_tf"
 DRIVERS="$DRIVERS drivers/net/wireless/ipw2x00"
-DRIVERS="$DRIVERS drivers/net/wireless/ar9170"
 
 # Drivers that belong the the wireless directory
 DRIVER_FILES="adm8211.c  adm8211.h"
diff --git a/scripts/athenable b/scripts/athenable
index 176e320..c9b67a0 100755
--- a/scripts/athenable
+++ b/scripts/athenable
@@ -13,6 +13,7 @@ if [[ $UID -ne 0 ]]; then
 fi
 
 ATH5K="ath5k"
+ATH9K="ath9k"
 MADWIFI="ath_pci"
 # Appended to module file at the end when we want to ignore one
 IGNORE_SUFFIX=".ignore"
@@ -23,6 +24,7 @@ USAGE="Usage: $0 [ ath5k | madwifi ]"
 if [ $# -eq 0 ]; then
 	module_disable $MADWIFI
 	module_enable $ATH5K
+	module_enable $ATH9K
 	exit
 elif [ $# -ne 1 ]; then
 	echo "$USAGE"
@@ -33,8 +35,10 @@ MODULE=$1
 if [ "$MODULE" == "ath5k" ]; then
 	module_disable $MADWIFI
 	module_enable $ATH5K
+	module_enable $ATH9K
 elif [ "$MODULE" == "madwifi" ]; then
 	module_disable $ATH5K
+	module_disable $ATH9K
 	module_enable $MADWIFI
 else
 	echo "$USAGE"
diff --git a/scripts/athload b/scripts/athload
index 84b5103..01b3072 100755
--- a/scripts/athload
+++ b/scripts/athload
@@ -31,6 +31,11 @@ if [ "$MODULE" == "ath5k" ]; then
 	if [ ! -z $CHECK ]; then
 		echo "ath5k loaded successfully"
 	fi
+	modprobe ath9k
+	CHECK=`modprobe -l ath9k`
+	if [ ! -z $CHECK ]; then
+		echo "ath9k loaded successfully"
+	fi
 elif [ "$MODULE" == "madwifi" ]; then
 	CHECK=`modprobe -l ath5k`
 	if [ ! -z $CHECK ]; then
diff --git a/scripts/b43enable b/scripts/b43enable
index 5ecf65a..b0b9851 100755
--- a/scripts/b43enable
+++ b/scripts/b43enable
@@ -15,12 +15,14 @@ fi
 
 B43S="b43 b43legacy"
 B43_OLD="bcm43xx"
+B43_PROP="wl"
 
 # Appended to module file at the end when we want to ignore one
-USAGE="Usage: $0 [ b43 | bcm43xx ]"
+USAGE="Usage: $0 [ b43 | bcm43xx | wl ]"
 
 function enable_b43 {
 	module_disable $B43_OLD
+	module_disable $B43_PROP
 	for i in $B43S; do
 		module_enable $i
 	done
@@ -41,7 +43,14 @@ if [ "$MODULE" == "bcm43xx" ]; then
 	for i in $B43S; do
 		module_disable $i
 	done
+	module_disable $B43_PROP
 	module_enable $B43_OLD
+elif [ "$MODULE" == "wl" ]; then
+	for i in $B43S; do
+		module_disable $i
+	done
+	module_disable $B43_OLD
+	module_enable $B43_PROP
 elif [ "$MODULE" == "b43" ]; then
 	enable_b43
 else
diff --git a/scripts/load.sh b/scripts/load.sh
index 4c694ee..7bc8fae 100755
--- a/scripts/load.sh
+++ b/scripts/load.sh
@@ -4,12 +4,14 @@ MODULES="$MODULES p54pci p54usb"
 MODULES="$MODULES adm8211 zd1211rw"
 MODULES="$MODULES rtl8180 rtl8187"
 MODULES="$MODULES p54pci p54usb"
-MODULES="$MODULES iwl3945 iwl4965"
-MODULES="$MODULES rtl8180 rtl8187"
+MODULES="$MODULES iwl3945 iwlagn"
+MODULES="$MODULES ath ar9170usb"
 MODULES="$MODULES rtl8180 rtl8187"
 MODULES="$MODULES rt2400pci rt2500pci rt61pci"
 MODULES="$MODULES rt2500usb rt73usb"
 MODULES="$MODULES rndis_wlan at76_usb"
+MODULES="$MODULES mwl8k mac80211_hwsim"
+MODULES="$MODULES at76c50x_usb"
 for i in $MODULES; do
 	echo Loading $i...
 	modprobe $i
diff --git a/scripts/modlib.sh b/scripts/modlib.sh
index 4f072b3..5140949 100755
--- a/scripts/modlib.sh
+++ b/scripts/modlib.sh
@@ -38,7 +38,7 @@ function module_disable {
 		else
 			echo -en "Disabling $MODULE ..."
 		fi
-		mv -f $CHECK ${CHECK}${IGNORE_SUFFIX}
+		mv -f /lib/modules/$VER/$CHECK /lib/modules/$VER/${CHECK}${IGNORE_SUFFIX}
 		depmod -ae
 		CHECK_AGAIN=`modprobe -l $MODULE`
 		if [ "$CHECK" != "$CHECK_AGAIN" ]; then
diff --git a/scripts/unload.sh b/scripts/unload.sh
index 2210c66..75bbfc9 100755
--- a/scripts/unload.sh
+++ b/scripts/unload.sh
@@ -3,27 +3,30 @@
 # The old stack drivers and the mac80211 rc80211_simple modules 
 # which is no longer on recent kernels (its internal)
 OLD_MODULES="iwlwifi_mac80211 rc80211_simple zd1211rw-mac80211"
-OLD_MODULES="$OLD_MODULES bcm43xx rndis_wext"
+OLD_MODULES="$OLD_MODULES ieee80211_crypt_tkip ieee80211_crypt_ccmp"
+OLD_MODULES="$OLD_MODULES ieee80211softmac ieee80211_crypt ieee80211"
+OLD_MODULES="$OLD_MODULES bcm43xx rndis_wext iwl4965"
 MODULES="$OLD_MODULES"
-MODULES="$MODULES ipw2100 ipw2200"
-MODULES="$MODULES libertas_cs usb8xxx libertas"
-MODULES="$MODULES ieee80211_crypt_tkip ieee80211_crypt_ccmp"
-MODULES="$MODULES ieee80211softmac ieee80211_crypt ieee80211"
+MODULES="$MODULES ipw2100 ipw2200 libipw"
+MODULES="$MODULES libertas_cs usb8xxx libertas libertas_sdio libertas_spi"
+MODULES="$MODULES libertas_tf libertas_tf_usb"
 MODULES="$MODULES adm8211 zd1211rw"
 MODULES="$MODULES b43 b43legacy ssb"
-MODULES="$MODULES iwl3945 iwl4965 iwlagn iwlcore"
-MODULES="$MODULES ath9k ath5k"
-MODULES="$MODULES p54pci p54usb p54common"
+MODULES="$MODULES iwl3945 iwlagn iwlcore"
+MODULES="$MODULES ath9k ath5k ar9170usb ath"
+MODULES="$MODULES p54pci p54usb p54spi p54common"
 MODULES="$MODULES rt2400pci rt2500pci rt61pci"
 MODULES="$MODULES rt2500usb rt73usb"
 MODULES="$MODULES rt2x00usb rt2x00lib"
 MODULES="$MODULES rtl8180 rtl8187"
-MODULES="$MODULES at76_usb"
+MODULES="$MODULES mwl8k mac80211_hwsim"
+MODULES="$MODULES at76c50x_usb at76_usb"
 MODULES="$MODULES rndis_wlan rndis_host cdc_ether usbnet"
 # eeprom_93cx6 is used by rt2x00 (rt61pci, rt2500pci, rt2400pci) 
 # and Realtek drivers ( rtl8187, rtl8180)
 MODULES="$MODULES eeprom_93cx6"
-MODULES="$MODULES mac80211 cfg80211"
+MODULES="$MODULES lib80211_crypt_ccmp lib80211_crypt_tkip lib80211_crypt_wep"
+MODULES="$MODULES mac80211 cfg80211 lib80211"
 MADWIFI_MODULES="ath_pci ath_rate_sample wlan_scan_sta wlan ath_hal"
 IPW3945D="/sbin/ipw3945d-`uname -r`"
 
-- 
1.6.2.1

