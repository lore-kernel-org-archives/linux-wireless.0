Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:5661 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932650AbZJFOcn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Oct 2009 10:32:43 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] libertas: separate libertas' Kconfig in it's own file
Date: Tue, 6 Oct 2009 16:31:20 +0200
Cc: John W Linville <linville@tuxdriver.com>,
	Dan Williams <dcbw@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200910061631.20976.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Also sorts all "source" lines in the wireless/Kconfig.

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

Index: linux-wl/drivers/net/wireless/Kconfig
===================================================================
--- linux-wl.orig/drivers/net/wireless/Kconfig	2009-10-06 07:55:26.000000000 +0200
+++ linux-wl/drivers/net/wireless/Kconfig	2009-10-06 07:58:05.000000000 +0200
@@ -139,47 +139,6 @@ config PCMCIA_RAYCS
 	  To compile this driver as a module, choose M here: the module will be
 	  called ray_cs.  If unsure, say N.
 
-config LIBERTAS
-	tristate "Marvell 8xxx Libertas WLAN driver support"
-	depends on WLAN_80211
-	select WIRELESS_EXT
-	select WEXT_SPY
-	select LIB80211
-	select FW_LOADER
-	---help---
-	  A library for Marvell Libertas 8xxx devices.
-
-config LIBERTAS_USB
-	tristate "Marvell Libertas 8388 USB 802.11b/g cards"
-	depends on LIBERTAS && USB
-	---help---
-	  A driver for Marvell Libertas 8388 USB devices.
-
-config LIBERTAS_CS
-	tristate "Marvell Libertas 8385 CompactFlash 802.11b/g cards"
-	depends on LIBERTAS && PCMCIA
-	select FW_LOADER
-	---help---
-	  A driver for Marvell Libertas 8385 CompactFlash devices.
-
-config LIBERTAS_SDIO
-	tristate "Marvell Libertas 8385/8686/8688 SDIO 802.11b/g cards"
-	depends on LIBERTAS && MMC
-	---help---
-	  A driver for Marvell Libertas 8385/8686/8688 SDIO devices.
-
-config LIBERTAS_SPI
-	tristate "Marvell Libertas 8686 SPI 802.11b/g cards"
-	depends on LIBERTAS && SPI
-	---help---
-	  A driver for Marvell Libertas 8686 SPI devices.
-
-config LIBERTAS_DEBUG
-	bool "Enable full debugging output in the Libertas module."
-	depends on LIBERTAS
-	---help---
-	  Debugging support.
-
 config LIBERTAS_THINFIRM
 	tristate "Marvell 8xxx Libertas WLAN driver support with thin firmware"
 	depends on WLAN_80211 && MAC80211
@@ -491,17 +450,18 @@ config MWL8K
 	  To compile this driver as a module, choose M here: the module
 	  will be called mwl8k.  If unsure, say N.
 
-source "drivers/net/wireless/p54/Kconfig"
 source "drivers/net/wireless/ath/Kconfig"
-source "drivers/net/wireless/ipw2x00/Kconfig"
-source "drivers/net/wireless/iwlwifi/Kconfig"
-source "drivers/net/wireless/hostap/Kconfig"
 source "drivers/net/wireless/b43/Kconfig"
 source "drivers/net/wireless/b43legacy/Kconfig"
-source "drivers/net/wireless/zd1211rw/Kconfig"
-source "drivers/net/wireless/rt2x00/Kconfig"
+source "drivers/net/wireless/hostap/Kconfig"
+source "drivers/net/wireless/ipw2x00/Kconfig"
+source "drivers/net/wireless/iwlwifi/Kconfig"
+source "drivers/net/wireless/iwmc3200wifi/Kconfig"
+source "drivers/net/wireless/libertas/Kconfig"
 source "drivers/net/wireless/orinoco/Kconfig"
+source "drivers/net/wireless/p54/Kconfig"
+source "drivers/net/wireless/rt2x00/Kconfig"
 source "drivers/net/wireless/wl12xx/Kconfig"
-source "drivers/net/wireless/iwmc3200wifi/Kconfig"
+source "drivers/net/wireless/zd1211rw/Kconfig"
 
 endif # WLAN
Index: linux-wl/drivers/net/wireless/libertas/Makefile
===================================================================
--- linux-wl.orig/drivers/net/wireless/libertas/Makefile	2009-10-06 07:55:26.000000000 +0200
+++ linux-wl/drivers/net/wireless/libertas/Makefile	2009-10-06 07:58:25.000000000 +0200
@@ -1,5 +1,15 @@
-libertas-objs := main.o wext.o rx.o tx.o cmd.o cmdresp.o scan.o 11d.o	\
-		 debugfs.o persistcfg.o ethtool.o assoc.o
+libertas-y += 11d.o
+libertas-y += assoc.o
+libertas-y += cmd.o
+libertas-y += cmdresp.o
+libertas-y += debugfs.o
+libertas-y += ethtool.o
+libertas-y += main.o
+libertas-y += persistcfg.o
+libertas-y += rx.o
+libertas-y += scan.o
+libertas-y += tx.o
+libertas-y += wext.o
 
 usb8xxx-objs += if_usb.o
 libertas_cs-objs += if_cs.o
Index: linux-wl/drivers/net/wireless/libertas/Kconfig
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-wl/drivers/net/wireless/libertas/Kconfig	2009-10-06 07:58:15.000000000 +0200
@@ -0,0 +1,40 @@
+config LIBERTAS
+	tristate "Marvell 8xxx Libertas WLAN driver support"
+	depends on WLAN_80211
+	select WIRELESS_EXT
+	select WEXT_SPY
+	select LIB80211
+	select FW_LOADER
+	---help---
+	  A library for Marvell Libertas 8xxx devices.
+
+config LIBERTAS_USB
+	tristate "Marvell Libertas 8388 USB 802.11b/g cards"
+	depends on LIBERTAS && USB
+	---help---
+	  A driver for Marvell Libertas 8388 USB devices.
+
+config LIBERTAS_CS
+	tristate "Marvell Libertas 8385 CompactFlash 802.11b/g cards"
+	depends on LIBERTAS && PCMCIA
+	select FW_LOADER
+	---help---
+	  A driver for Marvell Libertas 8385 CompactFlash devices.
+
+config LIBERTAS_SDIO
+	tristate "Marvell Libertas 8385/8686/8688 SDIO 802.11b/g cards"
+	depends on LIBERTAS && MMC
+	---help---
+	  A driver for Marvell Libertas 8385/8686/8688 SDIO devices.
+
+config LIBERTAS_SPI
+	tristate "Marvell Libertas 8686 SPI 802.11b/g cards"
+	depends on LIBERTAS && SPI
+	---help---
+	  A driver for Marvell Libertas 8686 SPI devices.
+
+config LIBERTAS_DEBUG
+	bool "Enable full debugging output in the Libertas module."
+	depends on LIBERTAS
+	---help---
+	  Debugging support.

-- 
http://www.holgerschurig.de
