Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.186]:51964 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756843AbYDURAK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Apr 2008 13:00:10 -0400
Received: by mu-out-0910.google.com with SMTP id i10so1525656mue.1
        for <linux-wireless@vger.kernel.org>; Mon, 21 Apr 2008 10:00:07 -0700 (PDT)
To: linville@tuxdriver.com
Subject: [PATCH 6/9] rt2x00: Clarify supported chipsets in Kconfig
Date: Mon, 21 Apr 2008 19:01:40 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200804211858.46659.IvDoorn@gmail.com>
In-Reply-To: <200804211858.46659.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200804211901.40523.IvDoorn@gmail.com> (sfid-20080421_190104_895845_13041FA0)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As reported by Filipus Klutiero <chealer@gmail.com>,
the rt2x00 Kconfig entries should be updated with
specific chipset notifications.

This cleans up Kconfig by explicitly mentioning the
supported chipsets for each drivers, and uses the
same chipset family names as mentioned on the Ralink website.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/Kconfig |   55 ++++++++++++++++++++--------------
 1 files changed, 32 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/Kconfig b/drivers/net/wireless/rt2x00/Kconfig
index a1e3938..8dfc6e0 100644
--- a/drivers/net/wireless/rt2x00/Kconfig
+++ b/drivers/net/wireless/rt2x00/Kconfig
@@ -5,12 +5,16 @@ config RT2X00
 	  This will enable the experimental support for the Ralink drivers,
 	  developed in the rt2x00 project <http://rt2x00.serialmonkey.com>.
 
-	  These drivers will make use of the mac80211 stack.
+	  These drivers make use of the mac80211 stack.
 
 	  When building one of the individual drivers, the rt2x00 library
 	  will also be created. That library (when the driver is built as
 	  a module) will be called "rt2x00lib.ko".
 
+	  Additionally PCI and USB libraries will also be build depending
+	  on the types of drivers being selected, these libraries will be
+	  called "rt2x00pci.ko" and "rt2x00usb.ko".
+
 if RT2X00
 
 config RT2X00_LIB
@@ -40,114 +44,119 @@ config RT2X00_LIB_LEDS
 	depends on RT2X00_LIB
 
 config RT2400PCI
-	tristate "Ralink rt2400 pci/pcmcia support"
+	tristate "Ralink rt2400 (PCI/PCMCIA) support"
 	depends on PCI
 	select RT2X00_LIB_PCI
 	select EEPROM_93CX6
 	---help---
-	  This is an experimental driver for the Ralink rt2400 wireless chip.
+	  This adds support for rt2400 wireless chipset family.
+	  Supported chips: RT2460.
 
 	  When compiled as a module, this driver will be called "rt2400pci.ko".
 
 config RT2400PCI_RFKILL
-	bool "RT2400 rfkill support"
+	bool "Ralink rt2400 rfkill support"
 	depends on RT2400PCI
 	select RT2X00_LIB_RFKILL
 	---help---
-	  This adds support for integrated rt2400 devices that feature a
+	  This adds support for integrated rt2400 hardware that features a
 	  hardware button to control the radio state.
 	  This feature depends on the RF switch subsystem rfkill.
 
 config RT2400PCI_LEDS
-	bool "RT2400 leds support"
+	bool "Ralink rt2400 leds support"
 	depends on RT2400PCI && LEDS_CLASS
 	select RT2X00_LIB_LEDS
 	---help---
 	  This adds support for led triggers provided my mac80211.
 
 config RT2500PCI
-	tristate "Ralink rt2500 pci/pcmcia support"
+	tristate "Ralink rt2500 (PCI/PCMCIA) support"
 	depends on PCI
 	select RT2X00_LIB_PCI
 	select EEPROM_93CX6
 	---help---
-	  This is an experimental driver for the Ralink rt2500 wireless chip.
+	  This adds support for rt2500 wireless chipset family.
+	  Supported chips: RT2560.
 
 	  When compiled as a module, this driver will be called "rt2500pci.ko".
 
 config RT2500PCI_RFKILL
-	bool "RT2500 rfkill support"
+	bool "Ralink rt2500 rfkill support"
 	depends on RT2500PCI
 	select RT2X00_LIB_RFKILL
 	---help---
-	  This adds support for integrated rt2500 devices that feature a
+	  This adds support for integrated rt2500 hardware that features a
 	  hardware button to control the radio state.
 	  This feature depends on the RF switch subsystem rfkill.
 
 config RT2500PCI_LEDS
-	bool "RT2500 leds support"
+	bool "Ralink rt2500 leds support"
 	depends on RT2500PCI && LEDS_CLASS
 	select RT2X00_LIB_LEDS
 	---help---
 	  This adds support for led triggers provided my mac80211.
 
 config RT61PCI
-	tristate "Ralink rt61 pci/pcmcia support"
+	tristate "Ralink rt2501/rt61 (PCI/PCMCIA) support"
 	depends on PCI
 	select RT2X00_LIB_PCI
 	select RT2X00_LIB_FIRMWARE
 	select CRC_ITU_T
 	select EEPROM_93CX6
 	---help---
-	  This is an experimental driver for the Ralink rt61 wireless chip.
+	  This adds support for rt2501 wireless chipset family.
+	  Supported chips: RT2561, RT2561S & RT2661.
 
 	  When compiled as a module, this driver will be called "rt61pci.ko".
 
 config RT61PCI_RFKILL
-	bool "RT61 rfkill support"
+	bool "Ralink rt2501/rt61 rfkill support"
 	depends on RT61PCI
 	select RT2X00_LIB_RFKILL
 	---help---
-	  This adds support for integrated rt61 devices that feature a
+	  This adds support for integrated rt61 hardware that features a
 	  hardware button to control the radio state.
 	  This feature depends on the RF switch subsystem rfkill.
 
 config RT61PCI_LEDS
-	bool "RT61 leds support"
+	bool "Ralink rt2501/rt61 leds support"
 	depends on RT61PCI && LEDS_CLASS
 	select RT2X00_LIB_LEDS
 	---help---
 	  This adds support for led triggers provided my mac80211.
 
 config RT2500USB
-	tristate "Ralink rt2500 usb support"
+	tristate "Ralink rt2500 (USB) support"
 	depends on USB
 	select RT2X00_LIB_USB
 	---help---
-	  This is an experimental driver for the Ralink rt2500 wireless chip.
+	  This adds support for rt2500 wireless chipset family.
+	  Supported chips: RT2571 & RT2572.
 
 	  When compiled as a module, this driver will be called "rt2500usb.ko".
 
 config RT2500USB_LEDS
-	bool "RT2500 leds support"
+	bool "Ralink rt2500 leds support"
 	depends on RT2500USB && LEDS_CLASS
 	select RT2X00_LIB_LEDS
 	---help---
 	  This adds support for led triggers provided my mac80211.
 
 config RT73USB
-	tristate "Ralink rt73 usb support"
+	tristate "Ralink rt2501/rt73 (USB) support"
 	depends on USB
 	select RT2X00_LIB_USB
 	select RT2X00_LIB_FIRMWARE
 	select CRC_ITU_T
 	---help---
-	  This is an experimental driver for the Ralink rt73 wireless chip.
+	  This adds support for rt2501 wireless chipset family.
+	  Supported chips: RT2571W, RT2573 & RT2671.
 
 	  When compiled as a module, this driver will be called "rt73usb.ko".
 
 config RT73USB_LEDS
-	bool "RT73 leds support"
+	bool "Ralink rt2501/rt73 leds support"
 	depends on RT73USB && LEDS_CLASS
 	select RT2X00_LIB_LEDS
 	---help---
@@ -159,7 +168,7 @@ config RT2X00_LIB_DEBUGFS
 	---help---
 	  Enable creation of debugfs files for the rt2x00 drivers.
 	  These debugfs files support both reading and writing of the
-	  most important register types of the rt2x00 devices.
+	  most important register types of the rt2x00 hardware.
 
 config RT2X00_DEBUG
 	bool "Ralink debug output"
-- 
1.5.4.5

