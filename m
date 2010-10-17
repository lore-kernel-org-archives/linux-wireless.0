Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web56801.mail.re3.yahoo.com ([66.196.97.75]:46073 "HELO
	web56801.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757380Ab0JQRmN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Oct 2010 13:42:13 -0400
Message-ID: <983671.73519.qm@web56801.mail.re3.yahoo.com>
Date: Sun, 17 Oct 2010 10:42:12 -0700 (PDT)
From: Walter Goldens <goldenstranger@yahoo.com>
Subject: [PATCH] compat-wireless: update Makefile modules
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <756358.10174.qm@web56802.mail.re3.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

update "modprobe -l X" list in Makefile


Signed-off-by: Walter Goldens <goldenstranger@yahoo.com>
---

--- a/Makefile
+++ b/Makefile
@@ -194,10 +194,14 @@ install-scripts:
 	@$(MODPROBE) -l at76c50x-usb
 	@$(MODPROBE) -l ath
 	@$(MODPROBE) -l ath5k
+	@$(MODPROBE) -l ath6kl
 	@$(MODPROBE) -l ath9k
+	@$(MODPROBE) -l ath9k_htc
 	@$(MODPROBE) -l b43
 	@$(MODPROBE) -l b43legacy
 	@$(MODPROBE) -l b44
+	@$(MODPROBE) -l carl9170
+	@$(MODPROBE) -l brcm80211
 	@$(MODPROBE) -l cdc_ether
 	@$(MODPROBE) -l eeprom_93cx6
 	@$(MODPROBE) -l ipw2100
@@ -205,6 +209,7 @@ install-scripts:
 	@$(MODPROBE) -l iwl3945
 	@$(MODPROBE) -l iwlagn
 	@$(MODPROBE) -l iwlcore
+	@$(MODPROBE) -l iwmc3200wifi
 	@$(MODPROBE) -l lib80211_crypt_ccmp
 	@$(MODPROBE) -l lib80211_crypt_tkip
 	@$(MODPROBE) -l lib80211_crypt_wep
@@ -217,6 +222,13 @@ install-scripts:
 	@$(MODPROBE) -l libipw
 	@$(MODPROBE) -l mac80211_hwsim
 	@$(MODPROBE) -l mwl8k
+	@$(MODPROBE) -l orinoco_cs
+	@$(MODPROBE) -l orinoco_nortel
+	@$(MODPROBE) -l orinoco_pci
+	@$(MODPROBE) -l orinoco_plx
+	@$(MODPROBE) -l orinoco_tld
+	@$(MODPROBE) -l orinoco_usb
+	@$(MODPROBE) -l orinoco
 	@$(MODPROBE) -l p54common
 	@$(MODPROBE) -l p54pci
 	@$(MODPROBE) -l p54spi
@@ -226,6 +238,8 @@ install-scripts:
 	@$(MODPROBE) -l rt2400pci
 	@$(MODPROBE) -l rt2500pci
 	@$(MODPROBE) -l rt2500usb
+	@$(MODPROBE) -l rt2800pci
+	@$(MODPROBE) -l rt2800usb
 	@$(MODPROBE) -l rt2x00lib
 	@$(MODPROBE) -l rt2x00pci
 	@$(MODPROBE) -l rt2x00usb
@@ -233,9 +247,12 @@ install-scripts:
 	@$(MODPROBE) -l rt73usb
 	@$(MODPROBE) -l rtl8180
 	@$(MODPROBE) -l rtl8187
+	@$(MODPROBE) -l spectrum_cs
 	@$(MODPROBE) -l ssb
 	@$(MODPROBE) -l usb8xxx
 	@$(MODPROBE) -l usbnet
+	@$(MODPROBE) -l wl1251
+	@$(MODPROBE) -l wl1271
 	@$(MODPROBE) -l zd1211rw
 	@echo
 	@echo "Currently detected bluetooth subsystem modules:"
@@ -284,10 +301,14 @@ uninstall:
 	@$(MODPROBE) -l at76c50x-usb
 	@$(MODPROBE) -l ath
 	@$(MODPROBE) -l ath5k
+	@$(MODPROBE) -l ath6kl
 	@$(MODPROBE) -l ath9k
+	@$(MODPROBE) -l ath9k_htc
 	@$(MODPROBE) -l b43
 	@$(MODPROBE) -l b43legacy
 	@$(MODPROBE) -l b44
+	@$(MODPROBE) -l carl9170
+	@$(MODPROBE) -l brcm80211
 	@$(MODPROBE) -l cdc_ether
 	@$(MODPROBE) -l eeprom_93cx6
 	@$(MODPROBE) -l ipw2100
@@ -295,6 +316,7 @@ uninstall:
 	@$(MODPROBE) -l iwl3945
 	@$(MODPROBE) -l iwlagn
 	@$(MODPROBE) -l iwlcore
+	@$(MODPROBE) -l iwmc3200wifi
 	@$(MODPROBE) -l lib80211_crypt_ccmp
 	@$(MODPROBE) -l lib80211_crypt_tkip
 	@$(MODPROBE) -l lib80211_crypt_wep
@@ -307,6 +329,13 @@ uninstall:
 	@$(MODPROBE) -l libipw
 	@$(MODPROBE) -l mac80211_hwsim
 	@$(MODPROBE) -l mwl8k
+	@$(MODPROBE) -l orinoco_cs
+	@$(MODPROBE) -l orinoco_nortel
+	@$(MODPROBE) -l orinoco_pci
+	@$(MODPROBE) -l orinoco_plx
+	@$(MODPROBE) -l orinoco_tld
+	@$(MODPROBE) -l orinoco_usb
+	@$(MODPROBE) -l orinoco
 	@$(MODPROBE) -l p54common
 	@$(MODPROBE) -l p54pci
 	@$(MODPROBE) -l p54spi
@@ -316,6 +345,8 @@ uninstall:
 	@$(MODPROBE) -l rt2400pci
 	@$(MODPROBE) -l rt2500pci
 	@$(MODPROBE) -l rt2500usb
+	@$(MODPROBE) -l rt2800pci
+	@$(MODPROBE) -l rt2800usb
 	@$(MODPROBE) -l rt2x00lib
 	@$(MODPROBE) -l rt2x00pci
 	@$(MODPROBE) -l rt2x00usb
@@ -323,9 +354,12 @@ uninstall:
 	@$(MODPROBE) -l rt73usb
 	@$(MODPROBE) -l rtl8180
 	@$(MODPROBE) -l rtl8187
+	@$(MODPROBE) -l spectrum_cs
 	@$(MODPROBE) -l ssb
 	@$(MODPROBE) -l usb8xxx
 	@$(MODPROBE) -l usbnet
+	@$(MODPROBE) -l wl1251
+	@$(MODPROBE) -l wl1271
 	@$(MODPROBE) -l zd1211rw
 	@echo
 	@echo "Your old bluetooth subsystem modules were left intact:"


      
