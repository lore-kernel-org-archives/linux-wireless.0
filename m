Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:48029 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752390AbXCAN0H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Mar 2007 08:26:07 -0500
Received: from [84.135.246.90] (helo=johannes.berg)
	by sipsolutions.net with esmtpsa (TLS-1.0:RSA_ARCFOUR_MD5:16)
	(Exim 4.63)
	(envelope-from <johannes@sipsolutions.net>)
	id 1HMlDz-0006ei-PT
	for linux-wireless@vger.kernel.org; Thu, 01 Mar 2007 13:21:36 +0000
Subject: [TRIAL BALLOON] rework wireless Kconfig
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 01 Mar 2007 14:25:37 +0100
Message-Id: <1172755537.11911.50.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch
 * kills NET_RADIO
 * adds two new wireless driver menus for pre-802.11 and 802.11
 * makes WIRELESS_EXT visible (to avoid the arguments we had in
   commit c1783454a31e05b94774951b0b5d1eb9075ebfb4)
 * changes everything that depended on NET_RADIO to select WIRELESS_EXT

By removing NET_RADIO, these changes pave the way to making wireless
extensions optional when cfg80211 can fully take over for some drivers
and you don't have any older drivers that still require wext.

These conflict with other changesets (notable Ivo's) but they should be
easy to respin once those get in. This also depends on removing wext
netlink, but it's trivial to do them w/o removing netlink wext of
course. Though I think that the rtnetlink wext option shouldn't be under
drivers so I'd move it in the case we don't want to remove it.

johannes

---
 drivers/net/Makefile                           |    2 
 drivers/net/wireless/Kconfig                   |  100 +++++++++----------------
 drivers/net/wireless/bcm43xx/Kconfig           |    3 
 drivers/net/wireless/hostap/Kconfig            |    2 
 drivers/net/wireless/mac80211/adm8211/Kconfig  |    2 
 drivers/net/wireless/mac80211/bcm43xx/Kconfig  |    2 
 drivers/net/wireless/mac80211/p54/Kconfig      |    2 
 drivers/net/wireless/mac80211/rt2x00/Kconfig   |    2 
 drivers/net/wireless/mac80211/rtl818x/Kconfig  |    2 
 drivers/net/wireless/mac80211/zd1211rw/Kconfig |    2 
 drivers/net/wireless/zd1211rw/Kconfig          |    3 
 net/Kconfig                                    |   11 +-
 net/ieee80211/Kconfig                          |    3 
 net/wireless/Kconfig                           |    8 ++
 14 files changed, 67 insertions(+), 77 deletions(-)

--- wireless-dev.orig/drivers/net/wireless/Kconfig	2007-03-01 14:18:50.604246483 +0100
+++ wireless-dev/drivers/net/wireless/Kconfig	2007-03-01 14:19:19.594246483 +0100
@@ -2,37 +2,13 @@
 # Wireless LAN device configuration
 #
 
-menu "Wireless LAN (non-hamradio)"
+menu "Wireless LAN (pre-802.11)"
 	depends on NETDEVICES
 
-config NET_RADIO
-	bool "Wireless LAN drivers (non-hamradio) & Wireless Extensions"
-	select WIRELESS_EXT
-	---help---
-	  Support for wireless LANs and everything having to do with radio,
-	  but not with amateur radio or FM broadcasting.
-
-	  Saying Y here also enables the Wireless Extensions (creates
-	  /proc/net/wireless and enables iwconfig access). The Wireless
-	  Extension is a generic API allowing a driver to expose to the user
-	  space configuration and statistics specific to common Wireless LANs.
-	  The beauty of it is that a single set of tool can support all the
-	  variations of Wireless LANs, regardless of their type (as long as
-	  the driver supports Wireless Extension). Another advantage is that
-	  these parameters may be changed on the fly without restarting the
-	  driver (or Linux). If you wish to use Wireless Extensions with
-	  wireless PCMCIA (PC-) cards, you need to say Y here; you can fetch
-	  the tools from
-	  <http://www.hpl.hp.com/personal/Jean_Tourrilhes/Linux/Tools.html>.
-
-# Note : the cards are obsolete (can't buy them anymore), but the drivers
-# are not, as people are still using them...
-comment "Obsolete Wireless cards support (pre-802.11)"
-	depends on NET_RADIO && (INET || ISA || PCMCIA)
-
 config STRIP
 	tristate "STRIP (Metricom starmode radio IP)"
-	depends on NET_RADIO && INET
+	depends on INET
+	select WIRELESS_EXT
 	---help---
 	  Say Y if you have a Metricom radio and intend to use Starmode Radio
 	  IP. STRIP is a radio protocol developed for the MosquitoNet project
@@ -55,7 +31,8 @@ config STRIP
 
 config ARLAN
 	tristate "Aironet Arlan 655 & IC2200 DS support"
-	depends on NET_RADIO && ISA && !64BIT
+	depends on ISA && !64BIT
+	select WIRELESS_EXT
 	---help---
 	  Aironet makes Arlan, a class of wireless LAN adapters. These use the
 	  www.Telxon.com chip, which is also used on several similar cards.
@@ -70,7 +47,8 @@ config ARLAN
 
 config WAVELAN
 	tristate "AT&T/Lucent old WaveLAN & DEC RoamAbout DS ISA support"
-	depends on NET_RADIO && ISA
+	depends on ISA
+	select WIRELESS_EXT
 	---help---
 	  The Lucent WaveLAN (formerly NCR and AT&T; or DEC RoamAbout DS) is
 	  a Radio LAN (wireless Ethernet-like Local Area Network) using the
@@ -97,7 +75,8 @@ config WAVELAN
 
 config PCMCIA_WAVELAN
 	tristate "AT&T/Lucent old WaveLAN Pcmcia wireless support"
-	depends on NET_RADIO && PCMCIA
+	depends on PCMCIA
+	select WIRELESS_EXT
 	help
 	  Say Y here if you intend to attach an AT&T/Lucent Wavelan PCMCIA
 	  (PC-card) wireless Ethernet networking card to your computer.  This
@@ -108,7 +87,8 @@ config PCMCIA_WAVELAN
 
 config PCMCIA_NETWAVE
 	tristate "Xircom Netwave AirSurfer Pcmcia wireless support"
-	depends on NET_RADIO && PCMCIA
+	depends on PCMCIA
+	select WIRELESS_EXT
 	help
 	  Say Y here if you intend to attach this type of PCMCIA (PC-card)
 	  wireless Ethernet networking card to your computer.
@@ -116,12 +96,15 @@ config PCMCIA_NETWAVE
 	  To compile this driver as a module, choose M here: the module will be
 	  called netwave_cs.  If unsure, say N.
 
-comment "Wireless 802.11 Frequency Hopping cards support"
-	depends on NET_RADIO && PCMCIA
+endmenu
+
+menu "Wireless LAN (IEEE 802.11)"
+	depends on NETDEVICES
 
 config PCMCIA_RAYCS
 	tristate "Aviator/Raytheon 2.4MHz wireless support"
-	depends on NET_RADIO && PCMCIA
+	depends on PCMCIA
+	select WIRELESS_EXT
 	---help---
 	  Say Y here if you intend to attach an Aviator/Raytheon PCMCIA
 	  (PC-card) wireless Ethernet networking card to your computer.
@@ -131,12 +114,10 @@ config PCMCIA_RAYCS
 	  To compile this driver as a module, choose M here: the module will be
 	  called ray_cs.  If unsure, say N.
 
-comment "Wireless 802.11b ISA/PCI cards support"
-	depends on NET_RADIO && (ISA || PCI || PPC_PMAC || PCMCIA)
-
 config IPW2100
 	tristate "Intel PRO/Wireless 2100 Network Connection"
-	depends on NET_RADIO && PCI
+	depends on PCI
+	select WIRELESS_EXT
 	select FW_LOADER
 	select IEEE80211
 	---help---
@@ -190,7 +171,8 @@ config IPW2100_DEBUG
 
 config IPW2200
 	tristate "Intel PRO/Wireless 2200BG and 2915ABG Network Connection"
-	depends on NET_RADIO && PCI
+	depends on PCI
+	select WIRELESS_EXT
 	select FW_LOADER
 	select IEEE80211
 	---help---
@@ -272,7 +254,8 @@ config IPW2200_DEBUG
 
 config AIRO
 	tristate "Cisco/Aironet 34X/35X/4500/4800 ISA and PCI cards"
- 	depends on NET_RADIO && ISA_DMA_API && (PCI || BROKEN)
+ 	depends on ISA_DMA_API && (PCI || BROKEN)
+	select WIRELESS_EXT
 	select CRYPTO
 	---help---
 	  This is the standard Linux driver to support Cisco/Aironet ISA and
@@ -289,7 +272,8 @@ config AIRO
 
 config HERMES
 	tristate "Hermes chipset 802.11b support (Orinoco/Prism2/Symbol)"
-	depends on NET_RADIO && (PPC_PMAC || PCI || PCMCIA)
+	depends on (PPC_PMAC || PCI || PCMCIA)
+	select WIRELESS_EXT
 	---help---
 	  A driver for 802.11b wireless cards based on the "Hermes" or
 	  Intersil HFA384x (Prism 2) MAC controller.  This includes the vast
@@ -363,7 +347,8 @@ config PCI_HERMES
 
 config ATMEL
       tristate "Atmel at76c50x chipset  802.11b support"
-      depends on NET_RADIO && (PCI || PCMCIA)
+      depends on (PCI || PCMCIA)
+      select WIRELESS_EXT
       select FW_LOADER
       select CRC32
        ---help---
@@ -384,13 +369,9 @@ config PCI_ATMEL
         Enable support for PCI and mini-PCI cards containing the
         Atmel at76c506 chip.
 
-# If Pcmcia is compiled in, offer Pcmcia cards...
-comment "Wireless 802.11b Pcmcia/Cardbus cards support"
-	depends on NET_RADIO && PCMCIA
-
 config PCMCIA_HERMES
 	tristate "Hermes PCMCIA card support"
-	depends on NET_RADIO && PCMCIA && HERMES
+	depends on PCMCIA && HERMES
 	---help---
 	  A driver for "Hermes" chipset based PCMCIA wireless adaptors, such
 	  as the Lucent WavelanIEEE/Orinoco cards and their OEM (Cabletron/
@@ -410,7 +391,7 @@ config PCMCIA_HERMES
 
 config PCMCIA_SPECTRUM
 	tristate "Symbol Spectrum24 Trilogy PCMCIA card support"
-	depends on NET_RADIO && PCMCIA && HERMES
+	depends on PCMCIA && HERMES
 	select FW_LOADER
 	---help---
 
@@ -424,7 +405,8 @@ config PCMCIA_SPECTRUM
 
 config AIRO_CS
 	tristate "Cisco/Aironet 34X/35X/4500/4800 PCMCIA cards"
-	depends on NET_RADIO && PCMCIA && (BROKEN || !M32R)
+	depends on PCMCIA && (BROKEN || !M32R)
+	select WIRELESS_EXT
 	select CRYPTO
 	select CRYPTO_AES
 	---help---
@@ -448,7 +430,8 @@ config AIRO_CS
 
 config PCMCIA_ATMEL
 	tristate "Atmel at76c502/at76c504 PCMCIA cards"
-	depends on NET_RADIO && ATMEL && PCMCIA
+	depends on ATMEL && PCMCIA
+	select WIRELESS_EXT
 	select FW_LOADER
 	select CRC32
 	---help---
@@ -457,17 +440,17 @@ config PCMCIA_ATMEL
 
 config PCMCIA_WL3501
       tristate "Planet WL3501 PCMCIA cards"
-      depends on NET_RADIO && EXPERIMENTAL && PCMCIA
+      depends on EXPERIMENTAL && PCMCIA
+      select WIRELESS_EXT
        ---help---
          A driver for WL3501 PCMCIA 802.11 wireless cards made by Planet.
 	 It has basic support for Linux wireless extensions and initial
 	 micro support for ethtool.
 
-comment "Prism GT/Duette 802.11(a/b/g) PCI/Cardbus support"
-	depends on NET_RADIO && PCI
 config PRISM54
 	tristate 'Intersil Prism GT/Duette/Indigo PCI/Cardbus' 
-	depends on PCI && NET_RADIO && EXPERIMENTAL
+	depends on PCI && EXPERIMENTAL
+	select WIRELESS_EXT
 	select FW_LOADER
 	---help---
 	  Enable PCI and Cardbus support for the following chipset based cards:
@@ -513,7 +496,8 @@ config PRISM54
 
 config USB_ZD1201
 	tristate "USB ZD1201 based Wireless device support"
-	depends on USB && NET_RADIO
+	depends on USB
+	select WIRELESS_EXT
 	select FW_LOADER
 	---help---
 	  Say Y if you want to use wireless LAN adapters based on the ZyDAS
@@ -534,11 +518,5 @@ source "drivers/net/wireless/zd1211rw/Kc
 
 source "drivers/net/wireless/mac80211/Kconfig"
 
-# yes, this works even when no drivers are selected
-config NET_WIRELESS
-	bool
-	depends on NET_RADIO && (ISA || PCI || PPC_PMAC || PCMCIA)
-	default y
-
 endmenu
 
--- wireless-dev.orig/net/Kconfig	2007-03-01 14:18:51.744246483 +0100
+++ wireless-dev/net/Kconfig	2007-03-01 14:19:19.614246483 +0100
@@ -219,16 +219,17 @@ endmenu
 source "net/ax25/Kconfig"
 source "net/irda/Kconfig"
 source "net/bluetooth/Kconfig"
-source "net/mac80211/Kconfig"
-source "net/ieee80211/Kconfig"
-
-config WIRELESS_EXT
-	bool
 
 config FIB_RULES
 	bool
 
+menu "Wireless"
+
 source "net/wireless/Kconfig"
+source "net/mac80211/Kconfig"
+source "net/ieee80211/Kconfig"
+
+endmenu
 
 endif   # if NET
 endmenu # Networking
--- wireless-dev.orig/net/wireless/Kconfig	2007-03-01 14:18:51.854246483 +0100
+++ wireless-dev/net/wireless/Kconfig	2007-03-01 14:19:19.614246483 +0100
@@ -29,3 +29,11 @@ config NL80211
 
          If unsure, say Y.
 
+config WIRELESS_EXT
+	bool "Wireless extensions"
+	default n
+	---help---
+	  This compiles code for the wireless extensions.
+
+	  Say N if you can unless you have external modules
+	  that rely on it.
--- wireless-dev.orig/drivers/net/Makefile	2007-03-01 14:18:51.714246483 +0100
+++ wireless-dev/drivers/net/Makefile	2007-03-01 14:19:19.614246483 +0100
@@ -206,7 +206,7 @@ obj-$(CONFIG_TR) += tokenring/
 obj-$(CONFIG_WAN) += wan/
 obj-$(CONFIG_ARCNET) += arcnet/
 obj-$(CONFIG_NET_PCMCIA) += pcmcia/
-obj-$(CONFIG_NET_RADIO) += wireless/
+obj-y += wireless/
 obj-$(CONFIG_NET_TULIP) += tulip/
 obj-$(CONFIG_HAMRADIO) += hamradio/
 obj-$(CONFIG_IRDA) += irda/
--- wireless-dev.orig/net/ieee80211/Kconfig	2007-03-01 14:18:51.964246483 +0100
+++ wireless-dev/net/ieee80211/Kconfig	2007-03-01 14:19:19.664246483 +0100
@@ -56,7 +56,8 @@ config IEEE80211_CRYPT_CCMP
 
 config IEEE80211_CRYPT_TKIP
 	tristate "IEEE 802.11i TKIP encryption"
-	depends on IEEE80211 && NET_RADIO
+	depends on IEEE80211
+	select WIRELESS_EXT
 	select CRYPTO
 	select CRYPTO_MICHAEL_MIC
 	select CRYPTO_ECB
--- wireless-dev.orig/drivers/net/wireless/bcm43xx/Kconfig	2007-03-01 14:18:50.744246483 +0100
+++ wireless-dev/drivers/net/wireless/bcm43xx/Kconfig	2007-03-01 14:19:19.664246483 +0100
@@ -1,6 +1,7 @@
 config BCM43XX
 	tristate "Broadcom BCM43xx wireless support"
-	depends on PCI && IEEE80211 && IEEE80211_SOFTMAC && NET_RADIO && EXPERIMENTAL
+	depends on PCI && IEEE80211 && IEEE80211_SOFTMAC && EXPERIMENTAL
+	select WIRELESS_EXT
 	select FW_LOADER
 	select HW_RANDOM
 	---help---
--- wireless-dev.orig/drivers/net/wireless/hostap/Kconfig	2007-03-01 14:18:50.844246483 +0100
+++ wireless-dev/drivers/net/wireless/hostap/Kconfig	2007-03-01 14:19:19.734246483 +0100
@@ -1,6 +1,6 @@
 config HOSTAP
 	tristate "IEEE 802.11 for Host AP (Prism2/2.5/3 and WEP/TKIP/CCMP)"
-	depends on NET_RADIO
+	select WIRELESS_EXT
 	select IEEE80211
 	select IEEE80211_CRYPT_WEP
 	---help---
--- wireless-dev.orig/drivers/net/wireless/mac80211/adm8211/Kconfig	2007-03-01 14:18:50.944246483 +0100
+++ wireless-dev/drivers/net/wireless/mac80211/adm8211/Kconfig	2007-03-01 14:19:19.774246483 +0100
@@ -1,6 +1,6 @@
 config ADM8211
 	tristate "ADMtek ADM8211 support"
-	depends on NET_RADIO && PCI && MAC80211 && EXPERIMENTAL
+	depends on PCI && MAC80211 && EXPERIMENTAL
 	---help---
 	  This driver is for ADM8211A, ADM8211B, and ADM8211C based cards.
 	  These are PCI/mini-PCI/Cardbus 802.11b chips found in cards such as:
--- wireless-dev.orig/drivers/net/wireless/mac80211/bcm43xx/Kconfig	2007-03-01 14:18:51.104246483 +0100
+++ wireless-dev/drivers/net/wireless/mac80211/bcm43xx/Kconfig	2007-03-01 14:19:19.774246483 +0100
@@ -1,6 +1,6 @@
 config BCM43XX_MAC80211
 	tristate "Broadcom BCM43xx wireless support (DeviceScape stack)"
-	depends on MAC80211 && NET_RADIO && EXPERIMENTAL
+	depends on MAC80211 && EXPERIMENTAL
 	select FW_LOADER
 	select SSB
 	---help---
--- wireless-dev.orig/drivers/net/wireless/mac80211/p54/Kconfig	2007-03-01 14:18:51.184246483 +0100
+++ wireless-dev/drivers/net/wireless/mac80211/p54/Kconfig	2007-03-01 14:19:19.774246483 +0100
@@ -1,6 +1,6 @@
 config P54_COMMON
 	tristate "Softmac Prism54 support"
-	depends on NET_RADIO && MAC80211 && FW_LOADER && EXPERIMENTAL
+	depends on MAC80211 && FW_LOADER && EXPERIMENTAL
 config P54_USB
 	tristate "Prism54 USB support"
 	depends on P54_COMMON && USB
--- wireless-dev.orig/drivers/net/wireless/mac80211/rt2x00/Kconfig	2007-03-01 14:18:51.314246483 +0100
+++ wireless-dev/drivers/net/wireless/mac80211/rt2x00/Kconfig	2007-03-01 14:19:19.784246483 +0100
@@ -1,6 +1,6 @@
 config RT2X00
 	bool "Ralink driver support"
-	depends on NET_RADIO && MAC80211 && EXPERIMENTAL
+	depends on MAC80211 && EXPERIMENTAL
 	---help---
 	This will enable the experimental support for the Ralink drivers,
 	developed in the rt2x00 project <http://rt2x00.serialmonkey.com>.
--- wireless-dev.orig/drivers/net/wireless/mac80211/rtl818x/Kconfig	2007-03-01 14:18:51.394246483 +0100
+++ wireless-dev/drivers/net/wireless/mac80211/rtl818x/Kconfig	2007-03-01 14:19:19.804246483 +0100
@@ -4,5 +4,5 @@ config RTL818X
 
 config RTL8187
 	tristate "Realtek 8187 USB support"
-	depends on NET_RADIO && MAC80211 && USB && EXPERIMENTAL
+	depends on MAC80211 && USB && EXPERIMENTAL
 	select RTL818X
--- wireless-dev.orig/drivers/net/wireless/mac80211/zd1211rw/Kconfig	2007-03-01 14:18:51.534246483 +0100
+++ wireless-dev/drivers/net/wireless/mac80211/zd1211rw/Kconfig	2007-03-01 14:19:19.814246483 +0100
@@ -1,6 +1,6 @@
 config ZD1211RW_MAC80211
 	tristate "ZyDAS ZD1211/ZD1211B USB-wireless support (DeviceScape stack)"
-	depends on USB && MAC80211 && NET_RADIO && EXPERIMENTAL
+	depends on USB && MAC80211 && EXPERIMENTAL
 	select FW_LOADER
 	---help---
 	  This is an experimental driver for the ZyDAS ZD1211/ZD1211B wireless
--- wireless-dev.orig/drivers/net/wireless/zd1211rw/Kconfig	2007-03-01 14:18:51.624246483 +0100
+++ wireless-dev/drivers/net/wireless/zd1211rw/Kconfig	2007-03-01 14:19:19.824246483 +0100
@@ -1,6 +1,7 @@
 config ZD1211RW
 	tristate "ZyDAS ZD1211/ZD1211B USB-wireless support"
-	depends on USB && IEEE80211 && IEEE80211_SOFTMAC && NET_RADIO && EXPERIMENTAL
+	depends on USB && IEEE80211 && IEEE80211_SOFTMAC && EXPERIMENTAL
+	select WIRELESS_EXT
 	select FW_LOADER
 	---help---
 	  This is an experimental driver for the ZyDAS ZD1211/ZD1211B wireless


