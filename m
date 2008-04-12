Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.177]:33308 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755106AbYDLTK6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Apr 2008 15:10:58 -0400
Received: by py-out-1112.google.com with SMTP id u52so1361935pyb.10
        for <linux-wireless@vger.kernel.org>; Sat, 12 Apr 2008 12:10:57 -0700 (PDT)
From: Filipus Klutiero <chealer@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: rt2x00: cleanup Kconfig help
Date: Sat, 12 Apr 2008 15:09:56 -0400
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200804121509.56291.chealer@gmail.com> (sfid-20080412_201103_691518_A27BB780)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Clarify in CONFIG_RT2500USB that proper RT2500 (PCI) is not supported. While at it, capitalize "rt" in Ralink chipsets names and "usb", "pci". Also clarify what RT61 and RT73 refers to. Finally, update CONFIG_RT2X00 now that this isn't just futureware.

Signed-off-by: Filipus Klutiero <chealer@gmail.com>
---

--- drivers/net/wireless/rt2x00/Kconfig	2008-01-24 17:58:37.000000000 -0500
+++ drivers/net/wireless/rt2x00/Kconfig.USB	2008-04-12 03:22:12.000000000 -0400
@@ -2,10 +2,10 @@
 	tristate "Ralink driver support"
 	depends on MAC80211 && WLAN_80211 && EXPERIMENTAL
 	---help---
-	  This will enable the experimental support for the Ralink drivers,
+	  This enables the experimental support for the Ralink drivers,
 	  developed in the rt2x00 project <http://rt2x00.serialmonkey.com>.
 
-	  These drivers will make use of the Devicescape ieee80211 stack.
+	  These drivers use the mac80211 stack.
 
 	  When building one of the individual drivers, the rt2x00 library
 	  will also be created. That library (when the driver is built as
@@ -38,12 +38,12 @@
 	select INPUT_POLLDEV
 
 config RT2400PCI
-	tristate "Ralink rt2400 pci/pcmcia support"
+	tristate "Ralink RT2400 (PCI/PCMCIA) support"
 	depends on RT2X00 && PCI
 	select RT2X00_LIB_PCI
 	select EEPROM_93CX6
 	---help---
-	  This is an experimental driver for the Ralink rt2400 wireless chip.
+	  This is an experimental driver for the Ralink RT2400 wireless chipset.
 
 	  When compiled as a module, this driver will be called "rt2400pci.ko".
 
@@ -52,17 +52,17 @@
 	depends on RT2400PCI
 	select RT2X00_LIB_RFKILL
 	---help---
-	  This adds support for integrated rt2400 devices that feature a
+	  This adds support for integrated RT2400 devices that feature a
 	  hardware button to control the radio state.
 	  This feature depends on the RF switch subsystem rfkill.
 
 config RT2500PCI
-	tristate "Ralink rt2500 pci/pcmcia support"
+	tristate "Ralink RT2500 PCI/PCMCIA support"
 	depends on RT2X00 && PCI
 	select RT2X00_LIB_PCI
 	select EEPROM_93CX6
 	---help---
-	  This is an experimental driver for the Ralink rt2500 wireless chip.
+	  This is an experimental driver for the Ralink RT2500 wireless chipset.
 
 	  When compiled as a module, this driver will be called "rt2500pci.ko".
 
@@ -71,18 +71,18 @@
 	depends on RT2500PCI
 	select RT2X00_LIB_RFKILL
 	---help---
-	  This adds support for integrated rt2500 devices that feature a
+	  This adds support for integrated RT2500 devices that feature a
 	  hardware button to control the radio state.
 	  This feature depends on the RF switch subsystem rfkill.
 
 config RT61PCI
-	tristate "Ralink rt61 pci/pcmcia support"
+	tristate "Ralink RT2561, RT2661 support"
 	depends on RT2X00 && PCI
 	select RT2X00_LIB_PCI
 	select RT2X00_LIB_FIRMWARE
 	select EEPROM_93CX6
 	---help---
-	  This is an experimental driver for the Ralink rt61 wireless chip.
+	  This is an experimental driver for the Ralink RT2600 and RT2501 [Turbo] (PCI) wireless chipsets.
 
 	  When compiled as a module, this driver will be called "rt61pci.ko".
 
@@ -91,26 +91,26 @@
 	depends on RT61PCI
 	select RT2X00_LIB_RFKILL
 	---help---
-	  This adds support for integrated rt61 devices that feature a
+	  This adds support for integrated RT2600 and RT2501 devices that feature a
 	  hardware button to control the radio state.
 	  This feature depends on the RF switch subsystem rfkill.
 
 config RT2500USB
-	tristate "Ralink rt2500 usb support"
+	tristate "Ralink RT2500USB support"
 	depends on RT2X00 && USB
 	select RT2X00_LIB_USB
 	---help---
-	  This is an experimental driver for the Ralink rt2500 wireless chip.
+	  This is an experimental driver for the Ralink RT2500USB wireless chipset.
 
 	  When compiled as a module, this driver will be called "rt2500usb.ko".
 
 config RT73USB
-	tristate "Ralink rt73 usb support"
+	tristate "Ralink RT2571W (USB) support"
 	depends on RT2X00 && USB
 	select RT2X00_LIB_USB
 	select RT2X00_LIB_FIRMWARE
 	---help---
-	  This is an experimental driver for the Ralink rt73 wireless chip.
+	  This is an experimental driver for the Ralink RT2501USB and RT5201USB wireless chipsets.
 
 	  When compiled as a module, this driver will be called "rt73usb.ko".
 
---
I wrote this against 2.6.24. This fixed #10440.
