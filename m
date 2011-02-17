Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:63258 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758045Ab1BQVTM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Feb 2011 16:19:12 -0500
Date: Thu, 17 Feb 2011 15:19:10 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: george0505@realtek.com, chaoming_li@realsil.com.cn,
	linux-wireless@vger.kernel.org
Subject: [PATCH 14/14] rtlwifi: Modify buiild system for rtl8192cu
Message-ID: <4d5d90ce.Q1zVxPLIvJiajY/8%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Modify Kconfig and Makefile to build rtl8192cu.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Index: wireless-testing/drivers/net/wireless/rtlwifi/Kconfig
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/Kconfig
+++ wireless-testing/drivers/net/wireless/rtlwifi/Kconfig
@@ -1,6 +1,6 @@
 config RTL8192CE
 	tristate "Realtek RTL8192CE/RTL8188SE Wireless Network Adapter"
-	depends on MAC80211 && EXPERIMENTAL
+	depends on MAC80211 && PCI && EXPERIMENTAL
 	select FW_LOADER
 	select RTLWIFI
 	---help---
@@ -9,7 +9,18 @@ config RTL8192CE
 
 	If you choose to build it as a module, it will be called rtl8192ce
 
+config RTL8192CU
+	tristate "Realtek RTL8192CU/RTL8188SU USB Wireless Network Adapter"
+	depends on MAC80211 && USB && EXPERIMENTAL
+	select FW_LOADER
+	select RTLWIFI
+	---help---
+	This is the driver for Realtek RTL8192CU/RTL8188CU 802.11n USB
+	wireless network adapters.
+
+	If you choose to build it as a module, it will be called rtl8192cu
+
 config RTLWIFI
 	tristate
-	depends on RTL8192CE
+	depends on RTL8192CE || RTL8192CU
 	default m
Index: wireless-testing/drivers/net/wireless/rtlwifi/Makefile
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/Makefile
+++ wireless-testing/drivers/net/wireless/rtlwifi/Makefile
@@ -12,3 +12,4 @@ rtlwifi-objs	:=		\
 		usb.o
 
 obj-$(CONFIG_RTL8192CE)		+= rtl8192ce/
+obj-$(CONFIG_RTL8192CU)		+= rtl8192cu/
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192cu/Makefile
===================================================================
--- /dev/null
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192cu/Makefile
@@ -0,0 +1,14 @@
+rtl8192cu-objs :=		\
+		dm.o		\
+		fw.o		\
+		hw.o		\
+		led.o		\
+		mac.o		\
+		phy.o		\
+		rf.o		\
+		sw.o		\
+		table.o		\
+		trx.o
+
+obj-$(CONFIG_RTL8192CU) += rtl8192cu.o
+

