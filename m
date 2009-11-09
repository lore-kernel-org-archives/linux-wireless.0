Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:54735 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754240AbZKIXbR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Nov 2009 18:31:17 -0500
Date: Mon, 09 Nov 2009 17:31:22 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: bzolnier@gmail.com,
	Bernhard Schiffner <bernhard@schiffner-limbach.de>,
	linux-wireless@vger.kernel.org
Subject: [RFT 6/6] rtl8187se: Modify Kconfig and Makefile
Message-ID: <4af8a64a.OAu73X3xIXLBXo18%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Modify configuration and builod system for rtl8187se.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Index: wireless-testing/drivers/net/wireless/Kconfig
===================================================================
--- wireless-testing.orig/drivers/net/wireless/Kconfig
+++ wireless-testing/drivers/net/wireless/Kconfig
@@ -294,6 +294,16 @@ config RTL8187_LEDS
 	depends on RTL8187 && MAC80211_LEDS && (LEDS_CLASS = y || LEDS_CLASS = RTL8187)
 	default y
 
+config RTL8187SE
+	tristate "Realtek 8187SE PCI support"
+	depends on MAC80211 && PCI && WLAN_80211 && EXPERIMENTAL
+	select EEPROM_93CX6
+	---help---
+	  This is a driver for RTL8187SE PCI-based cards. If built as a
+	  module, it will be named rtl8187se.
+
+	  Thanks to Realtek for their support!
+
 config ADM8211
 	tristate "ADMtek ADM8211 support"
 	depends on MAC80211 && PCI && EXPERIMENTAL
Index: wireless-testing/drivers/net/wireless/Makefile
===================================================================
--- wireless-testing.orig/drivers/net/wireless/Makefile
+++ wireless-testing/drivers/net/wireless/Makefile
@@ -24,6 +24,7 @@ obj-$(CONFIG_B43LEGACY)		+= b43legacy/
 obj-$(CONFIG_ZD1211RW)		+= zd1211rw/
 obj-$(CONFIG_RTL8180)		+= rtl818x/
 obj-$(CONFIG_RTL8187)		+= rtl818x/
+obj-$(CONFIG_RTL8187SE)		+= rtl818x/
 
 # 16-bit wireless PCMCIA client drivers
 obj-$(CONFIG_PCMCIA_RAYCS)	+= ray_cs.o
Index: wireless-testing/drivers/net/wireless/rtl818x/Makefile
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtl818x/Makefile
+++ wireless-testing/drivers/net/wireless/rtl818x/Makefile
@@ -1,7 +1,9 @@
 rtl8180-objs		:= rtl8180_dev.o rtl8180_rtl8225.o rtl8180_sa2400.o rtl8180_max2820.o rtl8180_grf5101.o
 rtl8187-objs		:= rtl8187_dev.o rtl8187_rtl8225.o rtl8187_leds.o rtl8187_rfkill.o
+rtl8187se-objs		:= rtl8187se_dev.o rtl8187se_rtl8225.o
 
 obj-$(CONFIG_RTL8180)	+= rtl8180.o
 obj-$(CONFIG_RTL8187)	+= rtl8187.o
+obj-$(CONFIG_RTL8187SE)	+= rtl8187se.o
 
 
