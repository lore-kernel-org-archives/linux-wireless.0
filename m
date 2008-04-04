Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:36093 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752592AbYDDXJ6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Apr 2008 19:09:58 -0400
To: mcgrof@gmail.com
Subject: [PATCH 5/5] p54: update Makefile and Kconfig
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	flamingice@sourmilk.net, johannes@sipsolutions.net
Message-Id: <E1Jhv2j-0006LQ-3j@debian64.daheim> (sfid-20080405_001019_189995_508C71E3)
From: Christian Lamparter <chunkeey@web.de>
Date: Sat, 05 Apr 2008 01:09:57 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
 drivers/net/wireless/Kconfig      |   65 --------------------------------------
 drivers/net/wireless/Makefile     |    4 --
 drivers/net/wireless/p54/Kconfig  |   63 ++++++++++++++++++++++++++++++++++++
 drivers/net/wireless/p54/Makefile |    3 +
 4 files changed, 68 insertions(+), 67 deletions(-)
 create mode 100644 drivers/net/wireless/p54/Kconfig
 create mode 100644 drivers/net/wireless/p54/Makefile

diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index 602beab..86323c8 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -681,70 +681,7 @@ config ADM8211
 
 	  Thanks to Infineon-ADMtek for their support of this driver.
 
-config P54_COMMON
-	tristate "Softmac Prism54 support"
-	depends on MAC80211 && WLAN_80211 && FW_LOADER && EXPERIMENTAL
-	---help---
-	  This is common code for isl38xx based cards.
-	  This module does nothing by itself - the USB/PCI frontends
-	  also need to be enabled in order to support any devices.
-
-	  These devices require softmac firmware which can be found at
-	  http://prism54.org/
-
-	  If you choose to build a module, it'll be called p54common.
-
-config P54_USB
-	tristate "Prism54 USB support"
-	depends on P54_COMMON && USB
-	select CRC32
-	---help---
-	  This driver is for USB isl38xx based wireless cards.
-	  These are USB based adapters found in devices such as:
-
-	  3COM 3CRWE254G72
-	  SMC 2862W-G
-	  Accton 802.11g WN4501 USB
-	  Siemens Gigaset USB
-	  Netgear WG121
-	  Netgear WG111
-	  Medion 40900, Roper Europe
-	  Shuttle PN15, Airvast WM168g, IOGear GWU513
-	  Linksys WUSB54G
-	  Linksys WUSB54G Portable
-	  DLink DWL-G120 Spinnaker
-	  DLink DWL-G122
-	  Belkin F5D7050 ver 1000
-	  Cohiba Proto board
-	  SMC 2862W-G version 2
-	  U.S. Robotics U5 802.11g Adapter
-	  FUJITSU E-5400 USB D1700
-	  Sagem XG703A
-	  DLink DWL-G120 Cohiba
-	  Spinnaker Proto board
-	  Linksys WUSB54AG
-	  Inventel UR054G
-	  Spinnaker DUT
-
-	  These devices require softmac firmware which can be found at
-	  http://prism54.org/
-
-	  If you choose to build a module, it'll be called p54usb.
-
-config P54_PCI
-	tristate "Prism54 PCI support"
-	depends on P54_COMMON && PCI
-	---help---
-	  This driver is for PCI isl38xx based wireless cards.
-	  This driver supports most devices that are supported by the
-	  fullmac prism54 driver plus many devices which are not
-	  supported by the fullmac driver/firmware.
-
-	  This driver requires softmac firmware which can be found at
-	  http://prism54.org/
-
-	  If you choose to build a module, it'll be called p54pci.
-
+source "drivers/net/wireless/p54/Kconfig"
 source "drivers/net/wireless/ath5k/Kconfig"
 source "drivers/net/wireless/iwlwifi/Kconfig"
 source "drivers/net/wireless/hostap/Kconfig"
diff --git a/drivers/net/wireless/Makefile b/drivers/net/wireless/Makefile
index 3af665d..300fc68 100644
--- a/drivers/net/wireless/Makefile
+++ b/drivers/net/wireless/Makefile
@@ -62,8 +62,6 @@ obj-$(CONFIG_IWL3945)	+= iwlwifi/
 obj-$(CONFIG_IWL4965)	+= iwlwifi/
 obj-$(CONFIG_RT2X00)	+= rt2x00/
 
-obj-$(CONFIG_P54_COMMON)	+= p54common.o
-obj-$(CONFIG_P54_USB)		+= p54usb.o
-obj-$(CONFIG_P54_PCI)		+= p54pci.o
+obj-$(CONFIG_P54_COMMON)	+= p54/
 
 obj-$(CONFIG_ATH5K)	+= ath5k/
diff --git a/drivers/net/wireless/p54/Kconfig b/drivers/net/wireless/p54/Kconfig
new file mode 100644
index 0000000..d3469d0
--- /dev/null
+++ b/drivers/net/wireless/p54/Kconfig
@@ -0,0 +1,63 @@
+config P54_COMMON
+	tristate "Softmac Prism54 support"
+	depends on MAC80211 && WLAN_80211 && FW_LOADER && EXPERIMENTAL
+	---help---
+	  This is common code for isl38xx based cards.
+	  This module does nothing by itself - the USB/PCI frontends
+	  also need to be enabled in order to support any devices.
+
+	  These devices require softmac firmware which can be found at
+	  http://prism54.org/
+
+	  If you choose to build a module, it'll be called p54common.
+
+config P54_USB
+	tristate "Prism54 USB support"
+	depends on P54_COMMON && USB
+	select CRC32
+	---help---
+	  This driver is for USB isl38xx based wireless cards.
+	  These are USB based adapters found in devices such as:
+
+	  3COM 3CRWE254G72
+	  SMC 2862W-G
+	  Accton 802.11g WN4501 USB
+	  Siemens Gigaset USB
+	  Netgear WG121
+	  Netgear WG111
+	  Medion 40900, Roper Europe
+	  Shuttle PN15, Airvast WM168g, IOGear GWU513
+	  Linksys WUSB54G
+	  Linksys WUSB54G Portable
+	  DLink DWL-G120 Spinnaker
+	  DLink DWL-G122
+	  Belkin F5D7050 ver 1000
+	  Cohiba Proto board
+	  SMC 2862W-G version 2
+	  U.S. Robotics U5 802.11g Adapter
+	  FUJITSU E-5400 USB D1700
+	  Sagem XG703A
+	  DLink DWL-G120 Cohiba
+	  Spinnaker Proto board
+	  Linksys WUSB54AG
+	  Inventel UR054G
+	  Spinnaker DUT
+
+	  These devices require softmac firmware which can be found at
+	  http://prism54.org/
+
+	  If you choose to build a module, it'll be called p54usb.
+
+config P54_PCI
+	tristate "Prism54 PCI support"
+	depends on P54_COMMON && PCI
+	---help---
+	  This driver is for PCI isl38xx based wireless cards.
+	  This driver supports most devices that are supported by the
+	  fullmac prism54 driver plus many devices which are not
+	  supported by the fullmac driver/firmware.
+
+	  This driver requires softmac firmware which can be found at
+	  http://prism54.org/
+
+	  If you choose to build a module, it'll be called p54pci.
diff --git a/drivers/net/wireless/p54/Makefile b/drivers/net/wireless/p54/Makefile
new file mode 100644
index 0000000..4fa9ce7
--- /dev/null
+++ b/drivers/net/wireless/p54/Makefile
@@ -0,0 +1,3 @@
+obj-$(CONFIG_P54_COMMON)	+= p54common.o
+obj-$(CONFIG_P54_USB)		+= p54usb.o
+obj-$(CONFIG_P54_PCI)		+= p54pci.o

