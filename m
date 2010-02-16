Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:61637 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757036Ab0BPR4x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Feb 2010 12:56:53 -0500
Date: Tue, 16 Feb 2010 11:56:50 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Bernhard Schiffner <bernhard@schiffner-limbach.de>
Subject: [PATCH 3/5] rtl8187se: Modify Kconfig
Message-ID: <4b7adc62.wTpAwUAB+btMnNY6%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move the rtl818x configuration into the rtl818x directory, and add RTL8187SE
to the configuration.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

 Kconfig         |   85 -------------------------------------------------
 rtl818x/Kconfig |   97 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 98 insertions(+), 84 deletions(-)

Index: wireless-testing/drivers/net/wireless/Kconfig
===================================================================
--- wireless-testing.orig/drivers/net/wireless/Kconfig
+++ wireless-testing/drivers/net/wireless/Kconfig
@@ -210,90 +210,7 @@ config USB_NET_RNDIS_WLAN
 
 	  If you choose to build a module, it'll be called rndis_wlan.
 
-config RTL8180
-	tristate "Realtek 8180/8185 PCI support"
-	depends on MAC80211 && PCI && EXPERIMENTAL
-	select EEPROM_93CX6
-	---help---
-	  This is a driver for RTL8180 and RTL8185 based cards.
-	  These are PCI based chips found in cards such as:
-
-	  (RTL8185 802.11g)
-	  A-Link WL54PC
-
-	  (RTL8180 802.11b)
-	  Belkin F5D6020 v3
-	  Belkin F5D6020 v3
-	  Dlink DWL-610
-	  Dlink DWL-510
-	  Netgear MA521
-	  Level-One WPC-0101
-	  Acer Aspire 1357 LMi
-	  VCTnet PC-11B1
-	  Ovislink AirLive WL-1120PCM
-	  Mentor WL-PCI
-	  Linksys WPC11 v4
-	  TrendNET TEW-288PI
-	  D-Link DWL-520 Rev D
-	  Repotec RP-WP7126
-	  TP-Link TL-WN250/251
-	  Zonet ZEW1000
-	  Longshine LCS-8031-R
-	  HomeLine HLW-PCC200
-	  GigaFast WF721-AEX
-	  Planet WL-3553
-	  Encore ENLWI-PCI1-NT
-	  TrendNET TEW-266PC
-	  Gigabyte GN-WLMR101
-	  Siemens-fujitsu Amilo D1840W
-	  Edimax EW-7126
-	  PheeNet WL-11PCIR
-	  Tonze PC-2100T
-	  Planet WL-8303
-	  Dlink DWL-650 v M1
-	  Edimax EW-7106
-	  Q-Tec 770WC
-	  Topcom Skyr@cer 4011b
-	  Roper FreeLan 802.11b (edition 2004)
-	  Wistron Neweb Corp CB-200B
-	  Pentagram HorNET
-	  QTec 775WC
-	  TwinMOS Booming B Series
-	  Micronet SP906BB
-	  Sweex LC700010
-	  Surecom EP-9428
-	  Safecom SWLCR-1100
-
-	  Thanks to Realtek for their support!
-
-config RTL8187
-	tristate "Realtek 8187 and 8187B USB support"
-	depends on MAC80211 && USB
-	select EEPROM_93CX6
-	---help---
-	  This is a driver for RTL8187 and RTL8187B based cards.
-	  These are USB based chips found in devices such as:
-
-	  Netgear WG111v2
-	  Level 1 WNC-0301USB
-	  Micronet SP907GK V5
-	  Encore ENUWI-G2
-	  Trendnet TEW-424UB
-	  ASUS P5B Deluxe/P5K Premium motherboards
-	  Toshiba Satellite Pro series of laptops
-	  Asus Wireless Link
-	  Linksys WUSB54GC-EU v2
-	    (v1 = rt73usb; v3 is rt2070-based,
-	     use staging/rt3070 or try rt2800usb)
-
-	  Thanks to Realtek for their support!
-
-# If possible, automatically enable LEDs for RTL8187.
-
-config RTL8187_LEDS
-	bool
-	depends on RTL8187 && MAC80211_LEDS && (LEDS_CLASS = y || LEDS_CLASS = RTL8187)
-	default y
+source "drivers/net/wireless/rtl818x/Kconfig"
 
 config ADM8211
 	tristate "ADMtek ADM8211 support"
Index: wireless-testing/drivers/net/wireless/rtl818x/Kconfig
===================================================================
--- /dev/null
+++ wireless-testing/drivers/net/wireless/rtl818x/Kconfig
@@ -0,0 +1,97 @@
+#
+# RTL818X Wireless LAN device configuration
+#
+config RTL8180
+	tristate "Realtek 8180/8185 PCI support"
+	depends on MAC80211 && PCI && EXPERIMENTAL
+	select EEPROM_93CX6
+	---help---
+	  This is a driver for RTL8180 and RTL8185 based cards.
+	  These are PCI based chips found in cards such as:
+
+	  (RTL8185 802.11g)
+	  A-Link WL54PC
+
+	  (RTL8180 802.11b)
+	  Belkin F5D6020 v3
+	  Belkin F5D6020 v3
+	  Dlink DWL-610
+	  Dlink DWL-510
+	  Netgear MA521
+	  Level-One WPC-0101
+	  Acer Aspire 1357 LMi
+	  VCTnet PC-11B1
+	  Ovislink AirLive WL-1120PCM
+	  Mentor WL-PCI
+	  Linksys WPC11 v4
+	  TrendNET TEW-288PI
+	  D-Link DWL-520 Rev D
+	  Repotec RP-WP7126
+	  TP-Link TL-WN250/251
+	  Zonet ZEW1000
+	  Longshine LCS-8031-R
+	  HomeLine HLW-PCC200
+	  GigaFast WF721-AEX
+	  Planet WL-3553
+	  Encore ENLWI-PCI1-NT
+	  TrendNET TEW-266PC
+	  Gigabyte GN-WLMR101
+	  Siemens-fujitsu Amilo D1840W
+	  Edimax EW-7126
+	  PheeNet WL-11PCIR
+	  Tonze PC-2100T
+	  Planet WL-8303
+	  Dlink DWL-650 v M1
+	  Edimax EW-7106
+	  Q-Tec 770WC
+	  Topcom Skyr@cer 4011b
+	  Roper FreeLan 802.11b (edition 2004)
+	  Wistron Neweb Corp CB-200B
+	  Pentagram HorNET
+	  QTec 775WC
+	  TwinMOS Booming B Series
+	  Micronet SP906BB
+	  Sweex LC700010
+	  Surecom EP-9428
+	  Safecom SWLCR-1100
+
+	  Thanks to Realtek for their support!
+
+config RTL8187
+	tristate "Realtek 8187 and 8187B USB support"
+	depends on MAC80211 && USB
+	select EEPROM_93CX6
+	---help---
+	  This is a driver for RTL8187 and RTL8187B based cards.
+	  These are USB based chips found in devices such as:
+
+	  Netgear WG111v2
+	  Level 1 WNC-0301USB
+	  Micronet SP907GK V5
+	  Encore ENUWI-G2
+	  Trendnet TEW-424UB
+	  ASUS P5B Deluxe/P5K Premium motherboards
+	  Toshiba Satellite Pro series of laptops
+	  Asus Wireless Link
+	  Linksys WUSB54GC-EU v2
+	    (v1 = rt73usb; v3 is rt2070-based,
+	     use staging/rt3070 or try rt2800usb)
+
+	  Thanks to Realtek for their support!
+
+# If possible, automatically enable LEDs for RTL8187.
+
+config RTL8187_LEDS
+	bool
+	depends on RTL8187 && MAC80211_LEDS && (LEDS_CLASS = y || LEDS_CLASS = RTL8187)
+	default y
+
+config RTL8187SE
+	tristate "Realtek 8187SE PCI support"
+	depends on MAC80211 && PCI && EXPERIMENTAL
+	select EEPROM_93CX6
+	---help---
+	  This is a driver for RTL8187SE PCI-based cards. If built as a
+	  module, it will be named rtl8187se.
+
+
