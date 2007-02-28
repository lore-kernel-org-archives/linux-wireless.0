Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.190]:51404 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932222AbXB1S0o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Feb 2007 13:26:44 -0500
Received: by nf-out-0910.google.com with SMTP id o25so636708nfa
        for <linux-wireless@vger.kernel.org>; Wed, 28 Feb 2007 10:26:42 -0800 (PST)
To: "John Linville" <linville@tuxdriver.com>
Subject: [PATCH] rt2x00: split RT2X00 option
Date: Wed, 28 Feb 2007 19:26:38 +0100
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200702281926.38820.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch will split the RT2X00 config option and adds the
(for the user) invisible RT2X00_LIB config option that will be
selected by the drivers.
Make the debug(fs) config options depend on this new
config option.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>

---

diff --git a/drivers/net/wireless/mac80211/rt2x00/Kconfig b/drivers/net/wireless/mac80211/rt2x00/Kconfig
index 1010a72..ec107e7 100644
--- a/drivers/net/wireless/mac80211/rt2x00/Kconfig
+++ b/drivers/net/wireless/mac80211/rt2x00/Kconfig
@@ -7,13 +7,18 @@ config RT2X00
 
 	These drivers will make use of the Devicescape ieee80211 stack.
 
-	This option will build the rt2x00 library which is required by
-	each individual driver, when compiled as a module,
-	this library will be called "rt2x00lib.ko".
+	When building one of the individual drivers, the rt2x00 library
+	will also be created. That library (when the driver is built as
+	a module) will be called "rt2x00lib.ko".
+
+config RT2X00_LIB
+	tristate
+	depends on RT2X00
 
 config RT2400PCI
 	tristate "Ralink rt2400 pci/pcmcia support"
 	depends on RT2X00 && PCI
+	select RT2X00_LIB
 	select EEPROM_93CX6
 	---help---
 	This is an experimental driver for the Ralink rt2400 wireless chip.
@@ -23,6 +28,7 @@ config RT2400PCI
 config RT2500PCI
 	tristate "Ralink rt2500 pci/pcmcia support"
 	depends on RT2X00 && PCI
+	select RT2X00_LIB
 	select EEPROM_93CX6
 	---help---
 	This is an experimental driver for the Ralink rt2500 wireless chip.
@@ -32,6 +38,7 @@ config RT2500PCI
 config RT61PCI
 	tristate "Ralink rt61 pci/pcmcia support"
 	depends on RT2X00 && FW_LOADER && PCI
+	select RT2X00_LIB
 	select CRC_ITU_T
 	select EEPROM_93CX6
 	---help---
@@ -42,6 +49,7 @@ config RT61PCI
 config RT2500USB
 	tristate "Ralink rt2500 usb support"
 	depends on RT2X00 && USB
+	select RT2X00_LIB
 	---help---
 	This is an experimental driver for the Ralink rt2500 wireless chip.
 
@@ -50,6 +58,7 @@ config RT2500USB
 config RT73USB
 	tristate "Ralink rt73 usb support"
 	depends on RT2X00 && FW_LOADER && USB
+	select RT2X00_LIB
 	select CRC_ITU_T
 	---help---
 	This is an experimental driver for the Ralink rt73 wireless chip.
@@ -58,7 +67,7 @@ config RT73USB
 
 config RT2X00_DEBUGFS
 	tristate "Ralink debugfs support"
-	depends on RT2X00 && DEBUG_FS
+	depends on RT2X00 && RT2X00_LIB && DEBUG_FS
 	---help---
 	Enable creation of debugfs files for the rt2x00 drivers.
 	These debugfs files support both reading and writing of the
@@ -66,6 +75,6 @@ config RT2X00_DEBUGFS
 
 config RT2X00_DEBUG
 	bool "Ralink debug output"
-	depends on RT2X00
+	depends on RT2X00 && RT2X00_LIB
 	---help---
 	Enable debugging output for all rt2x00 modules
diff --git a/drivers/net/wireless/mac80211/rt2x00/Makefile b/drivers/net/wireless/mac80211/rt2x00/Makefile
index 24837d5..10c7d9a 100644
--- a/drivers/net/wireless/mac80211/rt2x00/Makefile
+++ b/drivers/net/wireless/mac80211/rt2x00/Makefile
@@ -1,4 +1,4 @@
-obj-$(CONFIG_RT2X00)		+= rt2x00lib.o
+obj-$(CONFIG_RT2X00_LIB)	+= rt2x00lib.o
 obj-$(CONFIG_RT2400PCI)		+= rt2400pci.o
 obj-$(CONFIG_RT2500PCI)		+= rt2500pci.o
 obj-$(CONFIG_RT61PCI)		+= rt61pci.o
