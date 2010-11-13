Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:47304 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756242Ab0KMSOM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Nov 2010 13:14:12 -0500
Received: by mail-ey0-f174.google.com with SMTP id 27so2445882eye.19
        for <linux-wireless@vger.kernel.org>; Sat, 13 Nov 2010 10:14:11 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 3/9] rt2x00: Clean up Kconfig for RT2800 devices.
Date: Sat, 13 Nov 2010 19:10:10 +0100
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201011131908.15595.IvDoorn@gmail.com> <201011131909.50885.IvDoorn@gmail.com>
In-Reply-To: <201011131909.50885.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201011131910.11947.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gertjan van Wingerde <gwingerde@gmail.com>

General clean up of the Kconfig part for RT28XX devices.
Also remove the indications of non functional support for rt27xx/rt28xx/rt30xx
devices, as this is no longer true. They just work fine.
Finally, remove the experimental indications for rt27xx/rt28xx/rt30xx devices
as that is no longer true. Keep the experimental indications for rt33xx/rt35xx
devices, though.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
Acked-by: Helmut Schaa <helmut.schaa@googlemail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/Kconfig |   47 ++++++++++++++--------------------
 1 files changed, 19 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/Kconfig b/drivers/net/wireless/rt2x00/Kconfig
index f0f0152..f2be1d3 100644
--- a/drivers/net/wireless/rt2x00/Kconfig
+++ b/drivers/net/wireless/rt2x00/Kconfig
@@ -64,8 +64,8 @@ config RT2800PCI_SOC
 	default y
 
 config RT2800PCI
-	tristate "Ralink rt28xx/rt30xx/rt35xx (PCI/PCIe/PCMCIA) support (EXPERIMENTAL)"
-	depends on (RT2800PCI_PCI || RT2800PCI_SOC) && EXPERIMENTAL
+	tristate "Ralink rt27xx/rt28xx (PCI/PCIe/PCMCIA) support"
+	depends on RT2800PCI_PCI || RT2800PCI_SOC
 	select RT2800_LIB
 	select RT2X00_LIB_PCI if RT2800PCI_PCI
 	select RT2X00_LIB_SOC if RT2800PCI_SOC
@@ -75,29 +75,24 @@ config RT2800PCI
 	select CRC_CCITT
 	select EEPROM_93CX6
 	---help---
-	  This adds support for rt2800/rt3000/rt3500 wireless chipset family.
+	  This adds support for rt27xx/rt28xx wireless chipset family.
 	  Supported chips: RT2760, RT2790, RT2860, RT2880, RT2890 & RT3052
 
-	  This driver is non-functional at the moment and is intended for
-	  developers.
-
 	  When compiled as a module, this driver will be called "rt2800pci.ko".
 
 if RT2800PCI
 
 config RT2800PCI_RT30XX
-	bool "rt2800pci - Include support for rt30xx (PCI/PCIe/PCMCIA) devices"
+	bool "rt2800pci - Include support for rt30xx devices"
 	default y
 	---help---
 	  This adds support for rt30xx wireless chipset family to the
 	  rt2800pci driver.
 	  Supported chips: RT3090, RT3091 & RT3092
 
-	  Support for these devices is non-functional at the moment and is
-	  intended for testers and developers.
-
 config RT2800PCI_RT33XX
-	bool "rt2800pci - Include support for rt33xx (PCI/PCIe/PCMCIA) devices"
+	bool "rt2800pci - Include support for rt33xx devices (EXPERIMENTAL)"
+	depends on EXPERIMENTAL
 	default n
 	---help---
 	  This adds support for rt33xx wireless chipset family to the
@@ -108,7 +103,8 @@ config RT2800PCI_RT33XX
 	  intended for testers and developers.
 
 config RT2800PCI_RT35XX
-	bool "rt2800pci - Include support for rt35xx (PCI/PCIe/PCMCIA) devices"
+	bool "rt2800pci - Include support for rt35xx devices (EXPERIMENTAL)"
+	depends on EXPERIMENTAL
 	default n
 	---help---
 	  This adds support for rt35xx wireless chipset family to the
@@ -145,8 +141,8 @@ config RT73USB
 	  When compiled as a module, this driver will be called rt73usb.
 
 config RT2800USB
-	tristate "Ralink rt2800 (USB) support (EXPERIMENTAL)"
-	depends on USB && EXPERIMENTAL
+	tristate "Ralink rt27xx/rt28xx (USB) support"
+	depends on USB
 	select RT2800_LIB
 	select RT2X00_LIB_USB
 	select RT2X00_LIB_HT
@@ -154,30 +150,24 @@ config RT2800USB
 	select RT2X00_LIB_CRYPTO
 	select CRC_CCITT
 	---help---
-	  This adds experimental support for rt2800 wireless chipset family.
+	  This adds support for rt27xx/rt28xx wireless chipset family.
 	  Supported chips: RT2770, RT2870 & RT3070.
 
-	  Known issues:
-	  - support for RT2870 chips doesn't work with 802.11n APs yet
-	  - support for RT3070 chips is non-functional at the moment
-
 	  When compiled as a module, this driver will be called "rt2800usb.ko".
 
 if RT2800USB
 
 config RT2800USB_RT30XX
-	bool "rt2800usb - Include support for rt30xx (USB) devices"
+	bool "rt2800usb - Include support for rt30xx devices"
 	default y
 	---help---
 	  This adds support for rt30xx wireless chipset family to the
 	  rt2800usb driver.
 	  Supported chips: RT3070, RT3071 & RT3072
 
-	  Support for these devices is non-functional at the moment and is
-	  intended for testers and developers.
-
 config RT2800USB_RT33XX
-	bool "rt2800usb - Include support for rt33xx (USB) devices"
+	bool "rt2800usb - Include support for rt33xx devices (EXPERIMENTAL)"
+	depends on EXPERIMENTAL
 	default n
 	---help---
 	  This adds support for rt33xx wireless chipset family to the
@@ -188,7 +178,8 @@ config RT2800USB_RT33XX
 	  intended for testers and developers.
 
 config RT2800USB_RT35XX
-	bool "rt2800usb - Include support for rt35xx (USB) devices"
+	bool "rt2800usb - Include support for rt35xx devices (EXPERIMENTAL)"
+	depends on EXPERIMENTAL
 	default n
 	---help---
 	  This adds support for rt35xx wireless chipset family to the
@@ -202,9 +193,9 @@ config RT2800USB_UNKNOWN
 	bool "rt2800usb - Include support for unknown (USB) devices"
 	default n
 	---help---
-	  This adds support for rt2800 family devices that are known to
-	  have a rt2800 family chipset, but for which the exact chipset
-	  is unknown.
+	  This adds support for rt2800usb devices that are known to
+	  have a rt28xx family compatible chipset, but for which the exact
+	  chipset is unknown.
 
 	  Support status for these devices is unknown, and enabling these
 	  devices may or may not work.
-- 
1.7.2.3

