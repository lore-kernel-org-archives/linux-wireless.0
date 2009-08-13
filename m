Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:41500 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755454AbZHMTbu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2009 15:31:50 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 15/20] wireless: organize group drivers alphabetically
Date: Thu, 13 Aug 2009 15:31:44 -0400
Message-Id: <1250191909-21682-16-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1250191909-21682-1-git-send-email-lrodriguez@atheros.com>
References: <1250191909-21682-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/Kconfig |  337 +++++++++++++++++++++---------------------
 1 files changed, 170 insertions(+), 167 deletions(-)

diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index d3b31f9..513739a 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -110,77 +110,101 @@ menuconfig WLAN_80211
 	  This option does not affect the kernel build, it only
 	  lets you choose drivers.
 
-menuconfig MARVELL_80211
-	bool "Marvell Wireless Cards"
-	depends on WLAN_80211
-	---help---
-	  This will enable the support for Marvell wireless drivers. This includes
-	  the drivers: libertas, libertas_tf, and mwl8k.
+source "drivers/net/wireless/ath/Kconfig"
 
-if MARVELL_80211
-config LIBERTAS
-	tristate "Marvell 8xxx Libertas WLAN driver support"
+menuconfig ATMEL_80211
+	bool "Atmel Wireless Cards"
 	depends on WLAN_80211
-	select WIRELESS_EXT
-	select LIB80211
-	select FW_LOADER
 	---help---
-	  A library for Marvell Libertas 8xxx devices.
+	  This will enable the support for Atmel wireless drivers.
 
-config LIBERTAS_USB
-	tristate "Marvell Libertas 8388 USB 802.11b/g cards"
-	depends on LIBERTAS && USB
-	---help---
-	  A driver for Marvell Libertas 8388 USB devices.
+if ATMEL_80211
 
-config LIBERTAS_CS
-	tristate "Marvell Libertas 8385 CompactFlash 802.11b/g cards"
-	depends on LIBERTAS && PCMCIA
+config ATMEL
+      tristate "Atmel at76c50x chipset  802.11b support"
+      depends on (PCI || PCMCIA) && WLAN_80211
+      select WIRELESS_EXT
+      select FW_LOADER
+      select CRC32
+       ---help---
+        A driver 802.11b wireless cards based on the Atmel fast-vnet
+        chips. This driver supports standard Linux wireless extensions.
+
+        Many  cards based on this chipset do not have flash memory
+        and need their firmware loaded at start-up. If yours is
+        one of these, you will need to provide a firmware image
+        to be loaded into the card by the driver. The Atmel
+        firmware package can be downloaded from
+        <http://www.thekelleys.org.uk/atmel>
+
+config PCI_ATMEL
+      tristate "Atmel at76c506 PCI cards"
+      depends on ATMEL && PCI
+       ---help---
+        Enable support for PCI and mini-PCI cards containing the
+        Atmel at76c506 chip.
+
+config PCMCIA_ATMEL
+	tristate "Atmel at76c502/at76c504 PCMCIA cards"
+	depends on ATMEL && PCMCIA
+	select WIRELESS_EXT
 	select FW_LOADER
+	select CRC32
 	---help---
-	  A driver for Marvell Libertas 8385 CompactFlash devices.
+	  Enable support for PCMCIA cards containing the
+	  Atmel at76c502 and at76c504 chips.
 
-config LIBERTAS_SDIO
-	tristate "Marvell Libertas 8385/8686/8688 SDIO 802.11b/g cards"
-	depends on LIBERTAS && MMC
-	---help---
-	  A driver for Marvell Libertas 8385/8686/8688 SDIO devices.
+config AT76C50X_USB
+        tristate "Atmel at76c503/at76c505/at76c505a USB cards"
+        depends on MAC80211 && WLAN_80211 && USB
+        select FW_LOADER
+        ---help---
+          Enable support for USB Wireless devices using Atmel at76c503,
+          at76c505 or at76c505a chips.
 
-config LIBERTAS_SPI
-	tristate "Marvell Libertas 8686 SPI 802.11b/g cards"
-	depends on LIBERTAS && SPI
-	---help---
-	  A driver for Marvell Libertas 8686 SPI devices.
+endif # ATMEL_80211
 
-config LIBERTAS_DEBUG
-	bool "Enable full debugging output in the Libertas module."
-	depends on LIBERTAS
+menuconfig BROADCOM_80211
+	bool "Broadcom Wireless Cards"
+	depends on WLAN_80211
 	---help---
-	  Debugging support.
+	  This will enable the support for Broadcom wireless drivers. This
+	  includes b43 driver, b43legacy driver and the rndis_wlan driver.
 
-config LIBERTAS_THINFIRM
-	tristate "Marvell 8xxx Libertas WLAN driver support with thin firmware"
-	depends on WLAN_80211 && MAC80211
-	select FW_LOADER
-	---help---
-	  A library for Marvell Libertas 8xxx devices using thinfirm.
+if BROADCOM_80211
+source "drivers/net/wireless/b43/Kconfig"
+source "drivers/net/wireless/b43legacy/Kconfig"
 
-config LIBERTAS_THINFIRM_USB
-	tristate "Marvell Libertas 8388 USB 802.11b/g cards with thin firmware"
-	depends on LIBERTAS_THINFIRM && USB
+config USB_NET_RNDIS_WLAN
+	tristate "Wireless RNDIS USB support"
+	depends on USB && WLAN_80211 && EXPERIMENTAL
+	depends on CFG80211
+	select USB_USBNET
+	select USB_NET_CDCETHER
+	select USB_NET_RNDIS_HOST
+	select WIRELESS_EXT
 	---help---
-	  A driver for Marvell Libertas 8388 USB devices using thinfirm.
+	  This is a driver for wireless RNDIS devices.
+	  These are USB based adapters found in devices such as:
 
-config MWL8K
-	tristate "Marvell 88W8xxx PCI/PCIe Wireless support"
-	depends on MAC80211 && PCI && WLAN_80211 && EXPERIMENTAL
-	---help---
-	  This driver supports Marvell TOPDOG 802.11 wireless cards.
+	  Buffalo WLI-U2-KG125S
+	  U.S. Robotics USR5421
+	  Belkin F5D7051
+	  Linksys WUSB54GSv2
+	  Linksys WUSB54GSC
+	  Asus WL169gE
+	  Eminent EM4045
+	  BT Voyager 1055
+	  Linksys WUSB54GSv1
+	  U.S. Robotics USR5420
+	  BUFFALO WLI-USB-G54
 
-	  To compile this driver as a module, choose M here: the module
-	  will be called mwl8k.  If unsure, say N.
+	  All of these devices are based on Broadcom 4320 chip which is the
+	  only wireless RNDIS chip known to date.
 
-endif # MARVELL_80211
+	  If you choose to build a module, it'll be called rndis_wlan.
+
+endif # BROADCOM_80211
 
 menuconfig CISCO_80211
 	bool "Cisco Wireless Cards"
@@ -232,57 +256,18 @@ config AIRO_CS
 
 endif # CISCO_80211
 
-menuconfig ATMEL_80211
-	bool "Atmel Wireless Cards"
+menuconfig INTEL_80211
+	bool "Intel Wireless Cards"
 	depends on WLAN_80211
 	---help---
-	  This will enable the support for Atmel wireless drivers.
-
-if ATMEL_80211
-
-config ATMEL
-      tristate "Atmel at76c50x chipset  802.11b support"
-      depends on (PCI || PCMCIA) && WLAN_80211
-      select WIRELESS_EXT
-      select FW_LOADER
-      select CRC32
-       ---help---
-        A driver 802.11b wireless cards based on the Atmel fast-vnet
-        chips. This driver supports standard Linux wireless extensions.
-
-        Many  cards based on this chipset do not have flash memory
-        and need their firmware loaded at start-up. If yours is
-        one of these, you will need to provide a firmware image
-        to be loaded into the card by the driver. The Atmel
-        firmware package can be downloaded from
-        <http://www.thekelleys.org.uk/atmel>
-
-config PCI_ATMEL
-      tristate "Atmel at76c506 PCI cards"
-      depends on ATMEL && PCI
-       ---help---
-        Enable support for PCI and mini-PCI cards containing the
-        Atmel at76c506 chip.
-
-config PCMCIA_ATMEL
-	tristate "Atmel at76c502/at76c504 PCMCIA cards"
-	depends on ATMEL && PCMCIA
-	select WIRELESS_EXT
-	select FW_LOADER
-	select CRC32
-	---help---
-	  Enable support for PCMCIA cards containing the
-	  Atmel at76c502 and at76c504 chips.
-
-config AT76C50X_USB
-        tristate "Atmel at76c503/at76c505/at76c505a USB cards"
-        depends on MAC80211 && WLAN_80211 && USB
-        select FW_LOADER
-        ---help---
-          Enable support for USB Wireless devices using Atmel at76c503,
-          at76c505 or at76c505a chips.
+	  This will enable the support for Intel wireless drivers. This
+	  includes ipw2100, ipw2200, iwl3945, iwlagn, and iwmc3200wifi
 
-endif # ATMEL_80211
+if INTEL_80211
+source "drivers/net/wireless/ipw2x00/Kconfig"
+source "drivers/net/wireless/iwlwifi/Kconfig"
+source "drivers/net/wireless/iwmc3200wifi/Kconfig"
+endif # INTEL_80211
 
 menuconfig CONEXANT_ST_80211
 	bool "Intersil / Conexant / STEricsson Wireless Cards"
@@ -347,78 +332,79 @@ config PRISM54
 
 endif # CONEXANT_ST_80211
 
-menuconfig ZYDAS_80211
-	bool "ZyDAS 802.11bg Wireless Cards"
+menuconfig MARVELL_80211
+	bool "Marvell Wireless Cards"
 	depends on WLAN_80211
 	---help---
-	  This will enable the support for ZyDAS wireless drivers. This includes
-	  the 802.11g zd1211rw usb driver and the older 802.11b zd1201 usb driver.
-
-if ZYDAS_80211
-
-source "drivers/net/wireless/zd1211rw/Kconfig"
+	  This will enable the support for Marvell wireless drivers. This includes
+	  the drivers: libertas, libertas_tf, and mwl8k.
 
-config USB_ZD1201
-	tristate "USB ZD1201 based Wireless device support"
-	depends on USB && WLAN_80211
+if MARVELL_80211
+config LIBERTAS
+	tristate "Marvell 8xxx Libertas WLAN driver support"
+	depends on WLAN_80211
 	select WIRELESS_EXT
+	select LIB80211
 	select FW_LOADER
 	---help---
-	  Say Y if you want to use wireless LAN adapters based on the ZyDAS
-	  ZD1201 chip.
+	  A library for Marvell Libertas 8xxx devices.
 
-	  This driver makes the adapter appear as a normal Ethernet interface,
-	  typically on wlan0.
+config LIBERTAS_USB
+	tristate "Marvell Libertas 8388 USB 802.11b/g cards"
+	depends on LIBERTAS && USB
+	---help---
+	  A driver for Marvell Libertas 8388 USB devices.
 
-	  The zd1201 device requires external firmware to be loaded.
-	  This can be found at http://linux-lc100020.sourceforge.net/
+config LIBERTAS_CS
+	tristate "Marvell Libertas 8385 CompactFlash 802.11b/g cards"
+	depends on LIBERTAS && PCMCIA
+	select FW_LOADER
+	---help---
+	  A driver for Marvell Libertas 8385 CompactFlash devices.
 
-	  To compile this driver as a module, choose M here: the
-	  module will be called zd1201.
+config LIBERTAS_SDIO
+	tristate "Marvell Libertas 8385/8686/8688 SDIO 802.11b/g cards"
+	depends on LIBERTAS && MMC
+	---help---
+	  A driver for Marvell Libertas 8385/8686/8688 SDIO devices.
 
-endif # ZYDAS_80211
+config LIBERTAS_SPI
+	tristate "Marvell Libertas 8686 SPI 802.11b/g cards"
+	depends on LIBERTAS && SPI
+	---help---
+	  A driver for Marvell Libertas 8686 SPI devices.
 
-menuconfig BROADCOM_80211
-	bool "Broadcom Wireless Cards"
-	depends on WLAN_80211
+config LIBERTAS_DEBUG
+	bool "Enable full debugging output in the Libertas module."
+	depends on LIBERTAS
 	---help---
-	  This will enable the support for Broadcom wireless drivers. This
-	  includes b43 driver, b43legacy driver and the rndis_wlan driver.
+	  Debugging support.
 
-if BROADCOM_80211
-source "drivers/net/wireless/b43/Kconfig"
-source "drivers/net/wireless/b43legacy/Kconfig"
+config LIBERTAS_THINFIRM
+	tristate "Marvell 8xxx Libertas WLAN driver support with thin firmware"
+	depends on WLAN_80211 && MAC80211
+	select FW_LOADER
+	---help---
+	  A library for Marvell Libertas 8xxx devices using thinfirm.
 
-config USB_NET_RNDIS_WLAN
-	tristate "Wireless RNDIS USB support"
-	depends on USB && WLAN_80211 && EXPERIMENTAL
-	depends on CFG80211
-	select USB_USBNET
-	select USB_NET_CDCETHER
-	select USB_NET_RNDIS_HOST
-	select WIRELESS_EXT
+config LIBERTAS_THINFIRM_USB
+	tristate "Marvell Libertas 8388 USB 802.11b/g cards with thin firmware"
+	depends on LIBERTAS_THINFIRM && USB
 	---help---
-	  This is a driver for wireless RNDIS devices.
-	  These are USB based adapters found in devices such as:
+	  A driver for Marvell Libertas 8388 USB devices using thinfirm.
 
-	  Buffalo WLI-U2-KG125S
-	  U.S. Robotics USR5421
-	  Belkin F5D7051
-	  Linksys WUSB54GSv2
-	  Linksys WUSB54GSC
-	  Asus WL169gE
-	  Eminent EM4045
-	  BT Voyager 1055
-	  Linksys WUSB54GSv1
-	  U.S. Robotics USR5420
-	  BUFFALO WLI-USB-G54
+config MWL8K
+	tristate "Marvell 88W8xxx PCI/PCIe Wireless support"
+	depends on MAC80211 && PCI && WLAN_80211 && EXPERIMENTAL
+	---help---
+	  This driver supports Marvell TOPDOG 802.11 wireless cards.
 
-	  All of these devices are based on Broadcom 4320 chip which is the
-	  only wireless RNDIS chip known to date.
+	  To compile this driver as a module, choose M here: the module
+	  will be called mwl8k.  If unsure, say N.
 
-	  If you choose to build a module, it'll be called rndis_wlan.
+endif # MARVELL_80211
 
-endif # BROADCOM_80211
+source "drivers/net/wireless/rt2x00/Kconfig"
 
 menuconfig REALTEK_80211
 	bool "Realtek Wireless Cards"
@@ -516,22 +502,39 @@ config RTL8187_LEDS
 
 endif # REALTEK_80211
 
-menuconfig INTEL_80211
-	bool "Intel Wireless Cards"
+source "drivers/net/wireless/wl12xx/Kconfig"
+
+menuconfig ZYDAS_80211
+	bool "ZyDAS 802.11bg Wireless Cards"
 	depends on WLAN_80211
 	---help---
-	  This will enable the support for Intel wireless drivers. This
-	  includes ipw2100, ipw2200, iwl3945, iwlagn, and iwmc3200wifi
+	  This will enable the support for ZyDAS wireless drivers. This includes
+	  the 802.11g zd1211rw usb driver and the older 802.11b zd1201 usb driver.
 
-if INTEL_80211
-source "drivers/net/wireless/ipw2x00/Kconfig"
-source "drivers/net/wireless/iwlwifi/Kconfig"
-source "drivers/net/wireless/iwmc3200wifi/Kconfig"
-endif # INTEL_80211
+if ZYDAS_80211
+
+source "drivers/net/wireless/zd1211rw/Kconfig"
+
+config USB_ZD1201
+	tristate "USB ZD1201 based Wireless device support"
+	depends on USB && WLAN_80211
+	select WIRELESS_EXT
+	select FW_LOADER
+	---help---
+	  Say Y if you want to use wireless LAN adapters based on the ZyDAS
+	  ZD1201 chip.
+
+	  This driver makes the adapter appear as a normal Ethernet interface,
+	  typically on wlan0.
+
+	  The zd1201 device requires external firmware to be loaded.
+	  This can be found at http://linux-lc100020.sourceforge.net/
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called zd1201.
+
+endif # ZYDAS_80211
 
-source "drivers/net/wireless/ath/Kconfig"
-source "drivers/net/wireless/rt2x00/Kconfig"
-source "drivers/net/wireless/wl12xx/Kconfig"
 
 config PCMCIA_RAYCS
 	tristate "Aviator/Raytheon 2.4GHz wireless support"
-- 
1.6.2.5

