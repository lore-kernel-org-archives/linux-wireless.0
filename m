Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:51344 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758006Ab1FJUML (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jun 2011 16:12:11 -0400
Date: Fri, 10 Jun 2011 15:12:10 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: chaoming_li@realsil.com.cn, linux-wireless@vger.kernel.org
Subject: [PATCH 13/13] rtlwifi: rtl8192de: Modify Kconfig and Makefile
 routines for new driver
Message-ID: <4df27a9a.i9QQpVu5kNVxD31J%Larry.Finger@lwfinger.net> (sfid-20110610_221214_951216_E50DB994)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Chaoming Li <chaoming_li@realsil.com.cn>

Set up Kconfig and Makefile for new driver for RTL8192DE.

Signed-off-by: Chaoming_Li <chaoming_li@realsil.com.cn>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Index: wireless-testing-new/drivers/net/wireless/rtlwifi/Kconfig
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/Kconfig
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/Kconfig
@@ -21,6 +21,17 @@ config RTL8192SE
 
 	If you choose to build it as a module, it will be called rtl8192se
 
+config RTL8192DE
+	tristate "Realtek RTL8192DE/RTL8188DE PCIe Wireless Network Adapter"
+	depends on MAC80211 && EXPERIMENTAL
+	select FW_LOADER
+	select RTLWIFI
+	---help---
+	This is the driver for Realtek RTL8192DE/RTL8188DE 802.11n PCIe
+	wireless network adapters.
+
+	If you choose to build it as a module, it will be called rtl8192de
+
 config RTL8192CU
 	tristate "Realtek RTL8192CU/RTL8188CU USB Wireless Network Adapter"
 	depends on MAC80211 && USB && EXPERIMENTAL
@@ -35,10 +46,10 @@ config RTL8192CU
 
 config RTLWIFI
 	tristate
-	depends on RTL8192CE || RTL8192CU || RTL8192SE
+	depends on RTL8192CE || RTL8192CU || RTL8192SE || RTL8192DE
 	default m
 
 config RTL8192C_COMMON
 	tristate
-	depends on RTL8192CE || RTL8192CU || RTL8192SE
+	depends on RTL8192CE || RTL8192CU
 	default m
Index: wireless-testing-new/drivers/net/wireless/rtlwifi/Makefile
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/Makefile
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/Makefile
@@ -23,5 +23,6 @@ obj-$(CONFIG_RTL8192C_COMMON)	+= rtl8192
 obj-$(CONFIG_RTL8192CE)		+= rtl8192ce/
 obj-$(CONFIG_RTL8192CU)		+= rtl8192cu/
 obj-$(CONFIG_RTL8192SE)		+= rtl8192se/
+obj-$(CONFIG_RTL8192DE)		+= rtl8192de/
 
 ccflags-y += -D__CHECK_ENDIAN__
Index: wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192de/Makefile
===================================================================
--- /dev/null
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192de/Makefile
@@ -0,0 +1,15 @@
+rtl8192de-objs :=		\
+		dm.o		\
+		fw.o		\
+		hw.o		\
+		led.o		\
+		phy.o		\
+		rf.o		\
+		sw.o		\
+		table.o		\
+		trx.o
+
+obj-$(CONFIG_RTL8192DE) += rtl8192de.o
+
+ccflags-y += -D__CHECK_ENDIAN__
+
