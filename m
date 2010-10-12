Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web56805.mail.re3.yahoo.com ([66.196.97.79]:36140 "HELO
	web56805.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754251Ab0JLTo5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Oct 2010 15:44:57 -0400
Message-ID: <45257.13862.qm@web56805.mail.re3.yahoo.com>
Date: Tue, 12 Oct 2010 12:44:55 -0700 (PDT)
From: Walter Goldens <goldenstranger@yahoo.com>
Subject: [PATCH] compat-wireless: update unload/wlunload scripts
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Added: carl9170, brcm80211, aht6kl and orinoco to wlunload.sh and unload.sh
Added: atlxx ethernet drivers to unload.sh


Signed-off-by: Walter Goldens <goldenstranger@yahoo.com>
---

--- a/scripts/wlunload.sh
+++ b/scripts/wlunload.sh
@@ -10,10 +10,11 @@ MODULES="$OLD_MODULES"
 MODULES="$MODULES ipw2100 ipw2200 libipw"
 MODULES="$MODULES libertas_cs usb8xxx libertas libertas_sdio libertas_spi"
 MODULES="$MODULES libertas_tf libertas_tf_usb"
-MODULES="$MODULES adm8211 zd1211rw"
-MODULES="$MODULES b43 b43legacy ssb"
+MODULES="$MODULES adm8211 zd1211rw orinoco"
+MODULES="$MODULES b43 b43legacy brcm80211 ssb"
 MODULES="$MODULES iwl3945 iwlagn iwlcore"
-MODULES="$MODULES ath9k ath5k ar9170usb ath"
+MODULES="$MODULES ath9k ath9k_htc ath9k_common ath9k_hw "
+MODULES="$MODULES ath5k ath ath6kl ar9170usb carl9170"
 MODULES="$MODULES p54pci p54usb p54spi p54common"
 MODULES="$MODULES rt2400pci rt2500pci rt61pci"
 MODULES="$MODULES rt2500usb rt73usb"
--- a/scripts/unload.sh
+++ b/scripts/unload.sh	
@@ -10,11 +10,11 @@ MODULES="$OLD_MODULES"
 MODULES="$MODULES ipw2100 ipw2200 libipw"
 MODULES="$MODULES libertas_cs usb8xxx libertas libertas_sdio libertas_spi"
 MODULES="$MODULES libertas_tf libertas_tf_usb"
-MODULES="$MODULES adm8211 zd1211rw"
-MODULES="$MODULES b43 b43legacy ssb"
+MODULES="$MODULES adm8211 zd1211rw orinoco"
+MODULES="$MODULES b43 b43legacy brcm80211 ssb"
 MODULES="$MODULES iwl3945 iwlagn iwlcore"
 MODULES="$MODULES ath9k ath9k_htc ath9k_common ath9k_hw "
-MODULES="$MODULES ath5k ar9170usb ath"
+MODULES="$MODULES ath5k ath ath6kl ar9170usb carl9170"
 MODULES="$MODULES p54pci p54usb p54spi p54common"
 MODULES="$MODULES rt2400pci rt2500pci rt61pci"
 MODULES="$MODULES rt2500usb rt73usb"
@@ -24,6 +24,7 @@ MODULES="$MODULES rtl8180 rtl8187"
 MODULES="$MODULES mwl8k mac80211_hwsim"
 MODULES="$MODULES at76c50x_usb at76_usb"
 MODULES="$MODULES rndis_wlan rndis_host cdc_ether usbnet"
+MODULES="$MODULES atl1 atl2 atl1e atl1c"
 # eeprom_93cx6 is used by rt2x00 (rt61pci, rt2500pci, rt2400pci) 
 # and Realtek drivers ( rtl8187, rtl8180)
 MODULES="$MODULES eeprom_93cx6"


      
