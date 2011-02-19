Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:44813 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754556Ab1BSW3y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Feb 2011 17:29:54 -0500
Date: Sat, 19 Feb 2011 16:29:52 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: george0505@realtek.com, chaoming_li@realsil.com.cn,
	linux-wireless@vger.kernel.org
Subject: [PATCH V2 14/16] rtlwifi: Modify buiild system for rtl8192cu
Message-ID: <4d604460.x0GwTyd3ViaXkuEd%Larry.Finger@lwfinger.net>
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
-	tristate "Realtek RTL8192CE/RTL8188SE Wireless Network Adapter"
-	depends on MAC80211 && EXPERIMENTAL
+	tristate "Realtek RTL8192CE/RTL8188CE Wireless Network Adapter"
+	depends on MAC80211 && PCI && EXPERIMENTAL
 	select FW_LOADER
 	select RTLWIFI
 	---help---
@@ -9,7 +9,18 @@ config RTL8192CE
 
 	If you choose to build it as a module, it will be called rtl8192ce
 
+config RTL8192CU
+	tristate "Realtek RTL8192CU/RTL8188CU USB Wireless Network Adapter"
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
@@ -12,3 +12,7 @@ rtlwifi-objs	:=		\
 		usb.o
 
 obj-$(CONFIG_RTL8192CE)		+= rtl8192ce/
+obj-$(CONFIG_RTL8192CU)		+= rtl8192cu/
+
+ccflags-y += -D__CHECK_ENDIAN__
+
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192cu/Makefile
===================================================================
--- /dev/null
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192cu/Makefile
@@ -0,0 +1,15 @@
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
+ccflags-y += -D__CHECK_ENDIAN__
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/Makefile
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192ce/Makefile
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/Makefile
@@ -10,3 +10,5 @@ rtl8192ce-objs :=		\
 		trx.o
 
 obj-$(CONFIG_RTL8192CE) += rtl8192ce.o
+
+ccflags-y += -D__CHECK_ENDIAN__
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/reg.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192ce/reg.h
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/reg.h
@@ -1077,6 +1077,7 @@
 #define _RARF_RC8(x)				(((x) & 0x1F) << 24)
 
 #define AC_PARAM_TXOP_LIMIT_OFFSET		16
+#define AC_PARAM_TXOP_OFFSET			16
 #define AC_PARAM_ECW_MAX_OFFSET			12
 #define AC_PARAM_ECW_MIN_OFFSET			8
 #define AC_PARAM_AIFS_OFFSET			0
