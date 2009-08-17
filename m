Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:53138 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757774AbZHQR1c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2009 13:27:32 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v5 21/33] wireless: simplify WLAN_80211 entries
Date: Mon, 17 Aug 2009 13:27:20 -0400
Message-Id: <1250530052-14783-22-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1250530052-14783-1-git-send-email-lrodriguez@atheros.com>
References: <1250530052-14783-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We do simplify them by ifdef'ing on WLAN_80211 for
the WLAN_80211 drivers, this removes the need to depend
on WLAN_80211 on each individual driver.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/Kconfig              |   41 ++++++++++++----------------
 drivers/net/wireless/ath/Kconfig          |    1 -
 drivers/net/wireless/ath/ar9170/Kconfig   |    2 +-
 drivers/net/wireless/ath/ath5k/Kconfig    |    2 +-
 drivers/net/wireless/ath/ath9k/Kconfig    |    2 +-
 drivers/net/wireless/b43/Kconfig          |    2 +-
 drivers/net/wireless/b43legacy/Kconfig    |    2 +-
 drivers/net/wireless/hostap/Kconfig       |    1 -
 drivers/net/wireless/ipw2x00/Kconfig      |    6 ++--
 drivers/net/wireless/iwlwifi/Kconfig      |    2 +-
 drivers/net/wireless/iwmc3200wifi/Kconfig |    2 +-
 drivers/net/wireless/orinoco/Kconfig      |    2 +-
 drivers/net/wireless/p54/Kconfig          |    2 +-
 drivers/net/wireless/rt2x00/Kconfig       |    2 +-
 drivers/net/wireless/wl12xx/Kconfig       |    2 +-
 drivers/net/wireless/zd1211rw/Kconfig     |    2 +-
 16 files changed, 33 insertions(+), 40 deletions(-)

diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index b6d0ae7..e783246 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -113,11 +113,12 @@ menuconfig WLAN_80211
 	  This option does not affect the kernel build, it only
 	  lets you choose drivers.
 
+if WLAN_80211
+
 source "drivers/net/wireless/ath/Kconfig"
 
 config ATMEL_80211
 	bool "Atmel"
-	depends on WLAN_80211
 	---help---
 	  This will enable the support for Atmel wireless drivers.
 
@@ -125,7 +126,7 @@ if ATMEL_80211
 
 config ATMEL
       tristate "Atmel at76c50x chipset  802.11b support"
-      depends on (PCI || PCMCIA) && WLAN_80211
+      depends on (PCI || PCMCIA)
       select WIRELESS_EXT
       select FW_LOADER
       select CRC32
@@ -159,7 +160,7 @@ config PCMCIA_ATMEL
 
 config AT76C50X_USB
         tristate "Atmel at76c503/at76c505/at76c505a USB cards"
-        depends on MAC80211 && WLAN_80211 && USB
+        depends on MAC80211 && USB
         select FW_LOADER
         ---help---
           Enable support for USB Wireless devices using Atmel at76c503,
@@ -169,7 +170,6 @@ endif # ATMEL_80211
 
 config BROADCOM_80211
 	bool "Broadcom wireless driver support"
-	depends on WLAN_80211
 	---help---
 	  This will enable the support for Broadcom wireless drivers. This
 	  includes the b43 driver and the b43legacy driver.
@@ -183,7 +183,6 @@ endif # BROADCOM_80211
 
 config CISCO_80211
 	bool "Cisco"
-	depends on WLAN_80211
 	---help---
 	  This will enable the support for Cisco wireless drivers. This
 	  includes the Cisco Aironet ISA and PCI drivers and the Cisco
@@ -193,7 +192,7 @@ if CISCO_80211
 
 config AIRO
 	tristate "Cisco/Aironet 34X/35X/4500/4800 ISA and PCI cards"
-	depends on ISA_DMA_API && WLAN_80211 && (PCI || BROKEN)
+	depends on ISA_DMA_API && (PCI || BROKEN)
 	select WIRELESS_EXT
 	select CRYPTO
 	---help---
@@ -211,7 +210,7 @@ config AIRO
 
 config AIRO_CS
 	tristate "Cisco/Aironet 34X/35X/4500/4800 PCMCIA cards"
-	depends on PCMCIA && (BROKEN || !M32R) && WLAN_80211
+	depends on PCMCIA && (BROKEN || !M32R)
 	select WIRELESS_EXT
 	select CRYPTO
 	select CRYPTO_AES
@@ -233,7 +232,6 @@ endif # CISCO_80211
 
 menuconfig INTEL_80211
 	bool "Intel"
-	depends on WLAN_80211
 	---help---
 	  This will enable the support for Intel wireless drivers. This
 	  includes ipw2100, ipw2200, iwl3945, iwlagn, and iwmc3200wifi
@@ -248,7 +246,6 @@ endif # INTEL_80211
 
 config CONEXANT_ST_80211
 	bool "Intersil / Conexant / STEricsson"
-	depends on WLAN_80211
 	---help---
 	  This will enable the support for Intersil / Conexant and STEricsson
 	  wireless drivers. All these companies have sell wireless cards which
@@ -262,7 +259,7 @@ source "drivers/net/wireless/p54/Kconfig"
 
 config PRISM54
 	tristate 'Intersil Prism GT/Duette/Indigo PCI/Cardbus' 
-	depends on PCI && EXPERIMENTAL && WLAN_80211
+	depends on PCI && EXPERIMENTAL
 	select WIRELESS_EXT
 	select FW_LOADER
 	---help---
@@ -311,7 +308,6 @@ endif # CONEXANT_ST_80211
 
 menuconfig MARVELL_80211
 	bool "Marvell"
-	depends on WLAN_80211
 	---help---
 	  This will enable the support for Marvell wireless drivers. This includes
 	  the drivers: libertas, libertas_tf, and mwl8k.
@@ -319,7 +315,6 @@ menuconfig MARVELL_80211
 if MARVELL_80211
 config LIBERTAS
 	tristate "Marvell 8xxx Libertas WLAN driver support"
-	depends on WLAN_80211
 	select WIRELESS_EXT
 	select LIB80211
 	select FW_LOADER
@@ -359,7 +354,7 @@ config LIBERTAS_DEBUG
 
 config LIBERTAS_THINFIRM
 	tristate "Marvell 8xxx Libertas WLAN driver support with thin firmware"
-	depends on WLAN_80211 && MAC80211
+	depends on MAC80211
 	select FW_LOADER
 	---help---
 	  A library for Marvell Libertas 8xxx devices using thinfirm.
@@ -372,7 +367,7 @@ config LIBERTAS_THINFIRM_USB
 
 config MWL8K
 	tristate "Marvell 88W8xxx PCI/PCIe Wireless support"
-	depends on MAC80211 && PCI && WLAN_80211 && EXPERIMENTAL
+	depends on MAC80211 && PCI && EXPERIMENTAL
 	---help---
 	  This driver supports Marvell TOPDOG 802.11 wireless cards.
 
@@ -385,7 +380,6 @@ source "drivers/net/wireless/rt2x00/Kconfig"
 
 config REALTEK_80211
 	bool "Realtek"
-	depends on WLAN_80211
 	---help---
 	  This will enable the support for Realtek wireless drivers. This includes
 	  the PCI rtl8180 driver and the USB rtl8187 driver.
@@ -394,7 +388,7 @@ if REALTEK_80211
 
 config RTL8180
 	tristate "Realtek 8180/8185 PCI support"
-	depends on MAC80211 && PCI && WLAN_80211 && EXPERIMENTAL
+	depends on MAC80211 && PCI && EXPERIMENTAL
 	select EEPROM_93CX6
 	---help---
 	  This is a driver for RTL8180 and RTL8185 based cards.
@@ -450,7 +444,7 @@ config RTL8180
 
 config RTL8187
 	tristate "Realtek 8187 and 8187B USB support"
-	depends on MAC80211 && USB && WLAN_80211
+	depends on MAC80211 && USB
 	select EEPROM_93CX6
 	---help---
 	  This is a driver for RTL8187 and RTL8187B based cards.
@@ -483,7 +477,6 @@ source "drivers/net/wireless/wl12xx/Kconfig"
 
 config ZYDAS_80211
 	bool "ZyDAS"
-	depends on WLAN_80211
 	---help---
 	  This will enable the support for ZyDAS wireless drivers. This includes
 	  the 802.11g zd1211rw usb driver and the older 802.11b zd1201 usb driver.
@@ -494,7 +487,7 @@ source "drivers/net/wireless/zd1211rw/Kconfig"
 
 config USB_ZD1201
 	tristate "USB ZD1201 based Wireless device support"
-	depends on USB && WLAN_80211
+	depends on USB
 	select WIRELESS_EXT
 	select FW_LOADER
 	---help---
@@ -514,7 +507,7 @@ endif # ZYDAS_80211
 
 config ADM8211
 	tristate "ADMtek ADM8211 support"
-	depends on MAC80211 && PCI && WLAN_80211 && EXPERIMENTAL
+	depends on MAC80211 && PCI && EXPERIMENTAL
 	select CRC32
 	select EEPROM_93CX6
 	---help---
@@ -541,7 +534,7 @@ config ADM8211
 
 config PCMCIA_RAYCS
 	tristate "Aviator/Raytheon 2.4GHz wireless support"
-	depends on PCMCIA && WLAN_80211
+	depends on PCMCIA
 	select WIRELESS_EXT
 	---help---
 	  Say Y here if you intend to attach an Aviator/Raytheon PCMCIA
@@ -557,7 +550,7 @@ source "drivers/net/wireless/hostap/Kconfig"
 
 config PCMCIA_WL3501
       tristate "Planet WL3501 PCMCIA cards"
-      depends on EXPERIMENTAL && PCMCIA && WLAN_80211
+      depends on EXPERIMENTAL && PCMCIA
       select WIRELESS_EXT
        ---help---
          A driver for WL3501 PCMCIA 802.11 wireless cards made by Planet.
@@ -566,7 +559,7 @@ config PCMCIA_WL3501
 
 config USB_NET_RNDIS_WLAN
 	tristate "Wireless RNDIS USB support"
-	depends on USB && WLAN_80211 && EXPERIMENTAL
+	depends on USB && EXPERIMENTAL
 	depends on CFG80211
 	select USB_USBNET
 	select USB_NET_CDCETHER
@@ -596,6 +589,8 @@ config USB_NET_RNDIS_WLAN
 
 	  If you choose to build a module, it'll be called rndis_wlan.
 
+endif # WLAN_80211
+
 config MAC80211_HWSIM
 	tristate "Simulated radio testing tool for mac80211"
 	depends on MAC80211
diff --git a/drivers/net/wireless/ath/Kconfig b/drivers/net/wireless/ath/Kconfig
index 11ded15..9bfa909 100644
--- a/drivers/net/wireless/ath/Kconfig
+++ b/drivers/net/wireless/ath/Kconfig
@@ -1,6 +1,5 @@
 menuconfig ATH_COMMON
 	tristate "Atheros Wireless Cards"
-	depends on WLAN_80211
 	depends on CFG80211
 	---help---
 	  This will enable the support for the Atheros wireless drivers.
diff --git a/drivers/net/wireless/ath/ar9170/Kconfig b/drivers/net/wireless/ath/ar9170/Kconfig
index 05918f1..d7a4799 100644
--- a/drivers/net/wireless/ath/ar9170/Kconfig
+++ b/drivers/net/wireless/ath/ar9170/Kconfig
@@ -1,6 +1,6 @@
 config AR9170_USB
 	tristate "Atheros AR9170 802.11n USB support"
-	depends on USB && MAC80211 && WLAN_80211
+	depends on USB && MAC80211
 	select FW_LOADER
 	help
 	  This is a driver for the Atheros "otus" 802.11n USB devices.
diff --git a/drivers/net/wireless/ath/ath5k/Kconfig b/drivers/net/wireless/ath/ath5k/Kconfig
index 06d0066..eb83b7b 100644
--- a/drivers/net/wireless/ath/ath5k/Kconfig
+++ b/drivers/net/wireless/ath/ath5k/Kconfig
@@ -1,6 +1,6 @@
 config ATH5K
 	tristate "Atheros 5xxx wireless cards support"
-	depends on PCI && MAC80211 && WLAN_80211
+	depends on PCI && MAC80211
 	select MAC80211_LEDS
 	select LEDS_CLASS
 	select NEW_LEDS
diff --git a/drivers/net/wireless/ath/ath9k/Kconfig b/drivers/net/wireless/ath/ath9k/Kconfig
index ef5f59c..b9cb095 100644
--- a/drivers/net/wireless/ath/ath9k/Kconfig
+++ b/drivers/net/wireless/ath/ath9k/Kconfig
@@ -1,6 +1,6 @@
 config ATH9K
 	tristate "Atheros 802.11n wireless cards support"
-	depends on PCI && MAC80211 && WLAN_80211
+	depends on PCI && MAC80211
 	select MAC80211_LEDS
 	select LEDS_CLASS
 	select NEW_LEDS
diff --git a/drivers/net/wireless/b43/Kconfig b/drivers/net/wireless/b43/Kconfig
index 67f564e..79f2fac 100644
--- a/drivers/net/wireless/b43/Kconfig
+++ b/drivers/net/wireless/b43/Kconfig
@@ -1,6 +1,6 @@
 config B43
 	tristate "Broadcom 43xx wireless support (mac80211 stack)"
-	depends on SSB_POSSIBLE && MAC80211 && WLAN_80211 && HAS_DMA
+	depends on SSB_POSSIBLE && MAC80211 && HAS_DMA
 	select SSB
 	select FW_LOADER
 	---help---
diff --git a/drivers/net/wireless/b43legacy/Kconfig b/drivers/net/wireless/b43legacy/Kconfig
index 94a4634..1ffa288 100644
--- a/drivers/net/wireless/b43legacy/Kconfig
+++ b/drivers/net/wireless/b43legacy/Kconfig
@@ -1,6 +1,6 @@
 config B43LEGACY
 	tristate "Broadcom 43xx-legacy wireless support (mac80211 stack)"
-	depends on SSB_POSSIBLE && MAC80211 && WLAN_80211 && HAS_DMA
+	depends on SSB_POSSIBLE && MAC80211 && HAS_DMA
 	select SSB
 	select FW_LOADER
 	---help---
diff --git a/drivers/net/wireless/hostap/Kconfig b/drivers/net/wireless/hostap/Kconfig
index 13d074e..f5f9ace 100644
--- a/drivers/net/wireless/hostap/Kconfig
+++ b/drivers/net/wireless/hostap/Kconfig
@@ -1,6 +1,5 @@
 config HOSTAP
 	tristate "Host AP (Prism2/2.5/3 and WEP/TKIP/CCMP)"
-	depends on WLAN_80211
 	select WIRELESS_EXT
 	select CRYPTO
 	select CRYPTO_ARC4
diff --git a/drivers/net/wireless/ipw2x00/Kconfig b/drivers/net/wireless/ipw2x00/Kconfig
index 85cc799..2e65af9 100644
--- a/drivers/net/wireless/ipw2x00/Kconfig
+++ b/drivers/net/wireless/ipw2x00/Kconfig
@@ -4,7 +4,7 @@
 
 config IPW2100
 	tristate "Intel PRO/Wireless 2100 Network Connection"
-	depends on PCI && WLAN_80211
+	depends on PCI
 	select WIRELESS_EXT
 	select FW_LOADER
 	select LIB80211
@@ -63,7 +63,7 @@ config IPW2100_DEBUG
 
 config IPW2200
 	tristate "Intel PRO/Wireless 2200BG and 2915ABG Network Connection"
-	depends on PCI && WLAN_80211
+	depends on PCI
 	select WIRELESS_EXT
 	select FW_LOADER
 	select LIB80211
@@ -150,7 +150,7 @@ config IPW2200_DEBUG
 
 config LIBIPW
 	tristate
-	depends on PCI && WLAN_80211
+	depends on PCI
 	select WIRELESS_EXT
 	select CRYPTO
 	select CRYPTO_ARC4
diff --git a/drivers/net/wireless/iwlwifi/Kconfig b/drivers/net/wireless/iwlwifi/Kconfig
index 99310c0..1fff4bd 100644
--- a/drivers/net/wireless/iwlwifi/Kconfig
+++ b/drivers/net/wireless/iwlwifi/Kconfig
@@ -1,6 +1,6 @@
 config IWLWIFI
 	tristate "Intel Wireless Wifi"
-	depends on PCI && MAC80211 && WLAN_80211 && EXPERIMENTAL
+	depends on PCI && MAC80211 && EXPERIMENTAL
 	select LIB80211
 	select FW_LOADER
 	select MAC80211_LEDS if IWLWIFI_LEDS
diff --git a/drivers/net/wireless/iwmc3200wifi/Kconfig b/drivers/net/wireless/iwmc3200wifi/Kconfig
index c62da43..c2ea4cb 100644
--- a/drivers/net/wireless/iwmc3200wifi/Kconfig
+++ b/drivers/net/wireless/iwmc3200wifi/Kconfig
@@ -1,6 +1,6 @@
 config IWM
 	tristate "Intel Wireless Multicomm 3200 WiFi driver"
-	depends on MMC && WLAN_80211 && EXPERIMENTAL
+	depends on MMC && EXPERIMENTAL
 	depends on CFG80211
 	select FW_LOADER
 	help
diff --git a/drivers/net/wireless/orinoco/Kconfig b/drivers/net/wireless/orinoco/Kconfig
index 83b635f..13378e0 100644
--- a/drivers/net/wireless/orinoco/Kconfig
+++ b/drivers/net/wireless/orinoco/Kconfig
@@ -1,6 +1,6 @@
 config HERMES
 	tristate "Hermes chipset 802.11b support (Orinoco/Prism2/Symbol)"
-	depends on (PPC_PMAC || PCI || PCMCIA) && WLAN_80211
+	depends on (PPC_PMAC || PCI || PCMCIA)
 	depends on CFG80211
 	select WIRELESS_EXT
 	select FW_LOADER
diff --git a/drivers/net/wireless/p54/Kconfig b/drivers/net/wireless/p54/Kconfig
index b45d6a4..b0342a5 100644
--- a/drivers/net/wireless/p54/Kconfig
+++ b/drivers/net/wireless/p54/Kconfig
@@ -1,6 +1,6 @@
 config P54_COMMON
 	tristate "Softmac Prism54 support"
-	depends on MAC80211 && WLAN_80211 && EXPERIMENTAL
+	depends on MAC80211 && EXPERIMENTAL
 	select FW_LOADER
 	---help---
 	  This is common code for isl38xx/stlc45xx based modules.
diff --git a/drivers/net/wireless/rt2x00/Kconfig b/drivers/net/wireless/rt2x00/Kconfig
index ed1f997..0944854 100644
--- a/drivers/net/wireless/rt2x00/Kconfig
+++ b/drivers/net/wireless/rt2x00/Kconfig
@@ -1,6 +1,6 @@
 menuconfig RT2X00
 	tristate "Ralink driver support"
-	depends on MAC80211 && WLAN_80211
+	depends on MAC80211
 	---help---
 	  This will enable the support for the Ralink drivers,
 	  developed in the rt2x00 project <http://rt2x00.serialmonkey.com>.
diff --git a/drivers/net/wireless/wl12xx/Kconfig b/drivers/net/wireless/wl12xx/Kconfig
index 7b14d5b..1818e45 100644
--- a/drivers/net/wireless/wl12xx/Kconfig
+++ b/drivers/net/wireless/wl12xx/Kconfig
@@ -1,6 +1,6 @@
 menuconfig WL12XX
 	boolean "TI wl12xx driver support"
-	depends on MAC80211 && WLAN_80211 && EXPERIMENTAL
+	depends on MAC80211 && EXPERIMENTAL
 	---help---
 	  This will enable TI wl12xx driver support. The drivers make
 	  use of the mac80211 stack.
diff --git a/drivers/net/wireless/zd1211rw/Kconfig b/drivers/net/wireless/zd1211rw/Kconfig
index 74b31ea..5f80969 100644
--- a/drivers/net/wireless/zd1211rw/Kconfig
+++ b/drivers/net/wireless/zd1211rw/Kconfig
@@ -1,6 +1,6 @@
 config ZD1211RW
 	tristate "ZyDAS ZD1211/ZD1211B USB-wireless support"
-	depends on USB && MAC80211 && WLAN_80211 && EXPERIMENTAL
+	depends on USB && MAC80211 && EXPERIMENTAL
 	select FW_LOADER
 	---help---
 	  This is an experimental driver for the ZyDAS ZD1211/ZD1211B wireless
-- 
1.6.2.5

