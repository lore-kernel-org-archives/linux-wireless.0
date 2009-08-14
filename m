Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:45305 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756516AbZHNAnE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2009 20:43:04 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v2 16/25] wireless: organize group drivers alphabetically
Date: Thu, 13 Aug 2009 20:42:55 -0400
Message-Id: <1250210584-13374-17-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1250210584-13374-1-git-send-email-lrodriguez@atheros.com>
References: <1250210584-13374-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/Kconfig |  286 +++++++++++++++++++++---------------------
 1 files changed, 144 insertions(+), 142 deletions(-)

diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index 4ed50f6..a267887 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -110,77 +110,73 @@ menuconfig WLAN_80211
 	  This option does not affect the kernel build, it only
 	  lets you choose drivers.
 
-menuconfig MARVELL_80211
-	bool "Marvell"
-	depends on WLAN_80211
-	---help---
-	  This will enable the support for Marvell wireless drivers. This includes
-	  the drivers: libertas, libertas_tf, and mwl8k.
+source "drivers/net/wireless/ath/Kconfig"
 
-if MARVELL_80211
-config LIBERTAS
-	tristate "Marvell 8xxx Libertas WLAN driver support"
+config ATMEL_80211
+	bool "Atmel"
 	depends on WLAN_80211
-	select WIRELESS_EXT
-	select LIB80211
-	select FW_LOADER
 	---help---
-	  A library for Marvell Libertas 8xxx devices.
-
-config LIBERTAS_USB
-	tristate "Marvell Libertas 8388 USB 802.11b/g cards"
-	depends on LIBERTAS && USB
-	---help---
-	  A driver for Marvell Libertas 8388 USB devices.
+	  This will enable the support for Atmel wireless drivers.
 
-config LIBERTAS_CS
-	tristate "Marvell Libertas 8385 CompactFlash 802.11b/g cards"
-	depends on LIBERTAS && PCMCIA
-	select FW_LOADER
-	---help---
-	  A driver for Marvell Libertas 8385 CompactFlash devices.
+if ATMEL_80211
 
-config LIBERTAS_SDIO
-	tristate "Marvell Libertas 8385/8686/8688 SDIO 802.11b/g cards"
-	depends on LIBERTAS && MMC
-	---help---
-	  A driver for Marvell Libertas 8385/8686/8688 SDIO devices.
+config ATMEL
+      tristate "Atmel at76c50x chipset  802.11b support"
+      depends on (PCI || PCMCIA) && WLAN_80211
+      select WIRELESS_EXT
+      select FW_LOADER
+      select CRC32
+       ---help---
+        A driver 802.11b wireless cards based on the Atmel fast-vnet
+        chips. This driver supports standard Linux wireless extensions.
 
-config LIBERTAS_SPI
-	tristate "Marvell Libertas 8686 SPI 802.11b/g cards"
-	depends on LIBERTAS && SPI
-	---help---
-	  A driver for Marvell Libertas 8686 SPI devices.
+        Many  cards based on this chipset do not have flash memory
+        and need their firmware loaded at start-up. If yours is
+        one of these, you will need to provide a firmware image
+        to be loaded into the card by the driver. The Atmel
+        firmware package can be downloaded from
+        <http://www.thekelleys.org.uk/atmel>
 
-config LIBERTAS_DEBUG
-	bool "Enable full debugging output in the Libertas module."
-	depends on LIBERTAS
-	---help---
-	  Debugging support.
+config PCI_ATMEL
+      tristate "Atmel at76c506 PCI cards"
+      depends on ATMEL && PCI
+       ---help---
+        Enable support for PCI and mini-PCI cards containing the
+        Atmel at76c506 chip.
 
-config LIBERTAS_THINFIRM
-	tristate "Marvell 8xxx Libertas WLAN driver support with thin firmware"
-	depends on WLAN_80211 && MAC80211
+config PCMCIA_ATMEL
+	tristate "Atmel at76c502/at76c504 PCMCIA cards"
+	depends on ATMEL && PCMCIA
+	select WIRELESS_EXT
 	select FW_LOADER
+	select CRC32
 	---help---
-	  A library for Marvell Libertas 8xxx devices using thinfirm.
+	  Enable support for PCMCIA cards containing the
+	  Atmel at76c502 and at76c504 chips.
 
-config LIBERTAS_THINFIRM_USB
-	tristate "Marvell Libertas 8388 USB 802.11b/g cards with thin firmware"
-	depends on LIBERTAS_THINFIRM && USB
-	---help---
-	  A driver for Marvell Libertas 8388 USB devices using thinfirm.
+config AT76C50X_USB
+        tristate "Atmel at76c503/at76c505/at76c505a USB cards"
+        depends on MAC80211 && WLAN_80211 && USB
+        select FW_LOADER
+        ---help---
+          Enable support for USB Wireless devices using Atmel at76c503,
+          at76c505 or at76c505a chips.
 
-config MWL8K
-	tristate "Marvell 88W8xxx PCI/PCIe Wireless support"
-	depends on MAC80211 && PCI && WLAN_80211 && EXPERIMENTAL
+endif # ATMEL_80211
+
+config BROADCOM_80211
+	bool "Broadcom wireless driver support"
+	depends on WLAN_80211
 	---help---
-	  This driver supports Marvell TOPDOG 802.11 wireless cards.
+	  This will enable the support for Broadcom wireless drivers. This
+	  includes b43 driver and the b43legacy driver.
 
-	  To compile this driver as a module, choose M here: the module
-	  will be called mwl8k.  If unsure, say N.
+if BROADCOM_80211
 
-endif # MARVELL_80211
+source "drivers/net/wireless/b43/Kconfig"
+source "drivers/net/wireless/b43legacy/Kconfig"
+
+endif # BROADCOM_80211
 
 config CISCO_80211
 	bool "Cisco"
@@ -232,57 +228,20 @@ config AIRO_CS
 
 endif # CISCO_80211
 
-config ATMEL_80211
-	bool "Atmel"
+menuconfig INTEL_80211
+	bool "Intel"
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
+	  This will enable the support for Intel wireless drivers. This
+	  includes ipw2100, ipw2200, iwl3945, iwlagn, and iwmc3200wifi
 
-config PCMCIA_ATMEL
-	tristate "Atmel at76c502/at76c504 PCMCIA cards"
-	depends on ATMEL && PCMCIA
-	select WIRELESS_EXT
-	select FW_LOADER
-	select CRC32
-	---help---
-	  Enable support for PCMCIA cards containing the
-	  Atmel at76c502 and at76c504 chips.
+if INTEL_80211
 
-config AT76C50X_USB
-        tristate "Atmel at76c503/at76c505/at76c505a USB cards"
-        depends on MAC80211 && WLAN_80211 && USB
-        select FW_LOADER
-        ---help---
-          Enable support for USB Wireless devices using Atmel at76c503,
-          at76c505 or at76c505a chips.
+source "drivers/net/wireless/ipw2x00/Kconfig"
+source "drivers/net/wireless/iwlwifi/Kconfig"
+source "drivers/net/wireless/iwmc3200wifi/Kconfig"
 
-endif # ATMEL_80211
+endif # INTEL_80211
 
 config CONEXANT_ST_80211
 	bool "Intersil / Conexant / STEricsson"
@@ -347,50 +306,79 @@ config PRISM54
 
 endif # CONEXANT_ST_80211
 
-config ZYDAS_80211
-	bool "ZyDAS"
+menuconfig MARVELL_80211
+	bool "Marvell"
 	depends on WLAN_80211
 	---help---
-	  This will enable the support for ZyDAS wireless drivers. This includes
-	  the 802.11g zd1211rw usb driver and the older 802.11b zd1201 usb driver.
+	  This will enable the support for Marvell wireless drivers. This includes
+	  the drivers: libertas, libertas_tf, and mwl8k.
 
-if ZYDAS_80211
+if MARVELL_80211
+config LIBERTAS
+	tristate "Marvell 8xxx Libertas WLAN driver support"
+	depends on WLAN_80211
+	select WIRELESS_EXT
+	select LIB80211
+	select FW_LOADER
+	---help---
+	  A library for Marvell Libertas 8xxx devices.
 
-source "drivers/net/wireless/zd1211rw/Kconfig"
+config LIBERTAS_USB
+	tristate "Marvell Libertas 8388 USB 802.11b/g cards"
+	depends on LIBERTAS && USB
+	---help---
+	  A driver for Marvell Libertas 8388 USB devices.
 
-config USB_ZD1201
-	tristate "USB ZD1201 based Wireless device support"
-	depends on USB && WLAN_80211
-	select WIRELESS_EXT
+config LIBERTAS_CS
+	tristate "Marvell Libertas 8385 CompactFlash 802.11b/g cards"
+	depends on LIBERTAS && PCMCIA
 	select FW_LOADER
 	---help---
-	  Say Y if you want to use wireless LAN adapters based on the ZyDAS
-	  ZD1201 chip.
+	  A driver for Marvell Libertas 8385 CompactFlash devices.
 
-	  This driver makes the adapter appear as a normal Ethernet interface,
-	  typically on wlan0.
+config LIBERTAS_SDIO
+	tristate "Marvell Libertas 8385/8686/8688 SDIO 802.11b/g cards"
+	depends on LIBERTAS && MMC
+	---help---
+	  A driver for Marvell Libertas 8385/8686/8688 SDIO devices.
 
-	  The zd1201 device requires external firmware to be loaded.
-	  This can be found at http://linux-lc100020.sourceforge.net/
+config LIBERTAS_SPI
+	tristate "Marvell Libertas 8686 SPI 802.11b/g cards"
+	depends on LIBERTAS && SPI
+	---help---
+	  A driver for Marvell Libertas 8686 SPI devices.
 
-	  To compile this driver as a module, choose M here: the
-	  module will be called zd1201.
+config LIBERTAS_DEBUG
+	bool "Enable full debugging output in the Libertas module."
+	depends on LIBERTAS
+	---help---
+	  Debugging support.
 
-endif # ZYDAS_80211
+config LIBERTAS_THINFIRM
+	tristate "Marvell 8xxx Libertas WLAN driver support with thin firmware"
+	depends on WLAN_80211 && MAC80211
+	select FW_LOADER
+	---help---
+	  A library for Marvell Libertas 8xxx devices using thinfirm.
 
-config BROADCOM_80211
-	bool "Broadcom"
-	depends on WLAN_80211
+config LIBERTAS_THINFIRM_USB
+	tristate "Marvell Libertas 8388 USB 802.11b/g cards with thin firmware"
+	depends on LIBERTAS_THINFIRM && USB
 	---help---
-	  This will enable the support for Broadcom wireless drivers. This
-	  includes b43 driver, b43legacy driver and the rndis_wlan driver.
+	  A driver for Marvell Libertas 8388 USB devices using thinfirm.
 
-if BROADCOM_80211
+config MWL8K
+	tristate "Marvell 88W8xxx PCI/PCIe Wireless support"
+	depends on MAC80211 && PCI && WLAN_80211 && EXPERIMENTAL
+	---help---
+	  This driver supports Marvell TOPDOG 802.11 wireless cards.
 
-source "drivers/net/wireless/b43/Kconfig"
-source "drivers/net/wireless/b43legacy/Kconfig"
+	  To compile this driver as a module, choose M here: the module
+	  will be called mwl8k.  If unsure, say N.
 
-endif # BROADCOM_80211
+endif # MARVELL_80211
+
+source "drivers/net/wireless/rt2x00/Kconfig"
 
 config REALTEK_80211
 	bool "Realtek"
@@ -488,24 +476,38 @@ config RTL8187_LEDS
 
 endif # REALTEK_80211
 
-menuconfig INTEL_80211
-	bool "Intel"
+source "drivers/net/wireless/wl12xx/Kconfig
+
+config ZYDAS_80211
+	bool "ZyDAS"
 	depends on WLAN_80211
 	---help---
-	  This will enable the support for Intel wireless drivers. This
-	  includes ipw2100, ipw2200, iwl3945, iwlagn, and iwmc3200wifi
+	  This will enable the support for ZyDAS wireless drivers. This includes
+	  the 802.11g zd1211rw usb driver and the older 802.11b zd1201 usb driver.
 
-if INTEL_80211
+if ZYDAS_80211
 
-source "drivers/net/wireless/ipw2x00/Kconfig"
-source "drivers/net/wireless/iwlwifi/Kconfig"
-source "drivers/net/wireless/iwmc3200wifi/Kconfig"
+source "drivers/net/wireless/zd1211rw/Kconfig"
 
-endif # INTEL_80211
+config USB_ZD1201
+	tristate "USB ZD1201 based Wireless device support"
+	depends on USB && WLAN_80211
+	select WIRELESS_EXT
+	select FW_LOADER
+	---help---
+	  Say Y if you want to use wireless LAN adapters based on the ZyDAS
+	  ZD1201 chip.
 
-source "drivers/net/wireless/ath/Kconfig"
-source "drivers/net/wireless/rt2x00/Kconfig"
-source "drivers/net/wireless/wl12xx/Kconfig"
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
 
 config PCMCIA_RAYCS
 	tristate "Aviator/Raytheon 2.4GHz wireless support"
-- 
1.6.2.5

