Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:39318 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932813AbZHNU17 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Aug 2009 16:27:59 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v4 15/34] wireless: move group drivers together
Date: Fri, 14 Aug 2009 16:25:40 -0400
Message-Id: <1250281559-13041-16-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1250281559-13041-1-git-send-email-lrodriguez@atheros.com>
References: <1250281559-13041-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The group drivers are now above, individual drivers below.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/Kconfig |  157 +++++++++++++++++++++---------------------
 1 files changed, 78 insertions(+), 79 deletions(-)

diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index 82a617d..325d14d 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -110,19 +110,6 @@ menuconfig WLAN_80211
 	  This option does not affect the kernel build, it only
 	  lets you choose drivers.
 
-config PCMCIA_RAYCS
-	tristate "Aviator/Raytheon 2.4GHz wireless support"
-	depends on PCMCIA && WLAN_80211
-	select WIRELESS_EXT
-	---help---
-	  Say Y here if you intend to attach an Aviator/Raytheon PCMCIA
-	  (PC-card) wireless Ethernet networking card to your computer.
-	  Please read the file <file:Documentation/networking/ray_cs.txt> for
-	  details.
-
-	  To compile this driver as a module, choose M here: the module will be
-	  called ray_cs.  If unsure, say N.
-
 menuconfig MARVELL_80211
 	bool "Marvell"
 	depends on WLAN_80211
@@ -297,15 +284,6 @@ config AT76C50X_USB
 
 endif # ATMEL_80211
 
-config PCMCIA_WL3501
-      tristate "Planet WL3501 PCMCIA cards"
-      depends on EXPERIMENTAL && PCMCIA && WLAN_80211
-      select WIRELESS_EXT
-       ---help---
-         A driver for WL3501 PCMCIA 802.11 wireless cards made by Planet.
-	 It has basic support for Linux wireless extensions and initial
-	 micro support for ethtool.
-
 config CONEXANT_ST_80211
 	bool "Intersil / Conexant / STEricsson"
 	depends on WLAN_80211
@@ -400,37 +378,19 @@ config USB_ZD1201
 
 endif # ZYDAS_80211
 
-config USB_NET_RNDIS_WLAN
-	tristate "Wireless RNDIS USB support"
-	depends on USB && WLAN_80211 && EXPERIMENTAL
-	depends on CFG80211
-	select USB_USBNET
-	select USB_NET_CDCETHER
-	select USB_NET_RNDIS_HOST
-	select WIRELESS_EXT
+config BROADCOM_80211
+	bool "Broadcom"
+	depends on WLAN_80211
 	---help---
-	  This is a driver for wireless RNDIS devices.
-	  These are USB based adapters found in devices such as:
+	  This will enable the support for Broadcom wireless drivers. This
+	  includes b43 driver, b43legacy driver and the rndis_wlan driver.
 
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
+if BROADCOM_80211
 
-	  All of these devices are based on Broadcom 4320 chip which is the
-	  only wireless RNDIS chip known to date. Technically RNDIS follows
-	  a Microsoft specification, and although only Broadcom currently
-	  supports this, other vendors could technically follow the
-	  implementation as well.
+source "drivers/net/wireless/b43/Kconfig"
+source "drivers/net/wireless/b43legacy/Kconfig"
 
-	  If you choose to build a module, it'll be called rndis_wlan.
+endif # BROADCOM_80211
 
 config REALTEK_80211
 	bool "Realtek"
@@ -528,6 +488,47 @@ config RTL8187_LEDS
 
 endif # REALTEK_80211
 
+menuconfig INTEL_80211
+	bool "Intel"
+	depends on WLAN_80211
+	---help---
+	  This will enable the support for Intel wireless drivers. This
+	  includes ipw2100, ipw2200, iwl3945, iwlagn, and iwmc3200wifi
+
+if INTEL_80211
+
+source "drivers/net/wireless/ipw2x00/Kconfig"
+source "drivers/net/wireless/iwlwifi/Kconfig"
+source "drivers/net/wireless/iwmc3200wifi/Kconfig"
+
+endif # INTEL_80211
+
+source "drivers/net/wireless/ath/Kconfig"
+source "drivers/net/wireless/rt2x00/Kconfig"
+source "drivers/net/wireless/wl12xx/Kconfig"
+
+config PCMCIA_RAYCS
+	tristate "Aviator/Raytheon 2.4GHz wireless support"
+	depends on PCMCIA && WLAN_80211
+	select WIRELESS_EXT
+	---help---
+	  Say Y here if you intend to attach an Aviator/Raytheon PCMCIA
+	  (PC-card) wireless Ethernet networking card to your computer.
+	  Please read the file <file:Documentation/networking/ray_cs.txt> for
+	  details.
+
+	  To compile this driver as a module, choose M here: the module will be
+	  called ray_cs.  If unsure, say N.
+
+config PCMCIA_WL3501
+      tristate "Planet WL3501 PCMCIA cards"
+      depends on EXPERIMENTAL && PCMCIA && WLAN_80211
+      select WIRELESS_EXT
+       ---help---
+         A driver for WL3501 PCMCIA 802.11 wireless cards made by Planet.
+	 It has basic support for Linux wireless extensions and initial
+	 micro support for ethtool.
+
 config ADM8211
 	tristate "ADMtek ADM8211 support"
 	depends on MAC80211 && PCI && WLAN_80211 && EXPERIMENTAL
@@ -568,41 +569,39 @@ config MAC80211_HWSIM
 	  To compile this driver as a module, choose M here: the module will be
 	  called mac80211_hwsim.  If unsure, say N.
 
-source "drivers/net/wireless/ath/Kconfig"
-
-menuconfig INTEL_80211
-	bool "Intel"
-	depends on WLAN_80211
-	---help---
-	  This will enable the support for Intel wireless drivers. This
-	  includes ipw2100, ipw2200, iwl3945, iwlagn, and iwmc3200wifi
-
-if INTEL_80211
-
-source "drivers/net/wireless/ipw2x00/Kconfig"
-source "drivers/net/wireless/iwlwifi/Kconfig"
-source "drivers/net/wireless/iwmc3200wifi/Kconfig"
-
-endif # INTEL_80211
-
 source "drivers/net/wireless/hostap/Kconfig"
+source "drivers/net/wireless/orinoco/Kconfig"
 
-config BROADCOM_80211
-	bool "Broadcom"
-	depends on WLAN_80211
+config USB_NET_RNDIS_WLAN
+	tristate "Wireless RNDIS USB support"
+	depends on USB && WLAN_80211 && EXPERIMENTAL
+	depends on CFG80211
+	select USB_USBNET
+	select USB_NET_CDCETHER
+	select USB_NET_RNDIS_HOST
+	select WIRELESS_EXT
 	---help---
-	  This will enable the support for Broadcom wireless drivers. This
-	  includes b43 driver, b43legacy driver and the rndis_wlan driver.
-
-if BROADCOM_80211
+	  This is a driver for wireless RNDIS devices.
+	  These are USB based adapters found in devices such as:
 
-source "drivers/net/wireless/b43/Kconfig"
-source "drivers/net/wireless/b43legacy/Kconfig"
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
 
-endif # BROADCOM_80211
+	  All of these devices are based on Broadcom 4320 chip which is the
+	  only wireless RNDIS chip known to date. Technically RNDIS follows
+	  a Microsoft specification, and although only Broadcom currently
+	  supports this, other vendors could technically follow the
+	  implementation as well.
 
-source "drivers/net/wireless/rt2x00/Kconfig"
-source "drivers/net/wireless/orinoco/Kconfig"
-source "drivers/net/wireless/wl12xx/Kconfig"
+	  If you choose to build a module, it'll be called rndis_wlan.
 
 endmenu
-- 
1.6.2.5

