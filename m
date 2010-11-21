Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:43396 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152Ab0KUCZy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Nov 2010 21:25:54 -0500
Date: Sat, 20 Nov 2010 20:25:46 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: chaoming_li@realsil.com.cn, linux-wireless@vger.kernel.org
Subject: [RFC PATCH 22/22] rtl8192ce: Introduce new driver
Message-ID: <4ce8832a.DZz4FWAYDhgfWaf3%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From 0f120e9532e3362141a39b20a09a1ce39847c7f2 Mon Sep 17 00:00:00 2001
From: Larry Finger <Larry.Finger@lwfinger.net>
Date: Sat, 20 Nov 2010 19:09:13 -0600
Subject: [PATCH 22/23] rtl8192ce: rtlwifi: Add files to rtl8192ce.ko Part 12

Add files rtl8192c/Makefile, Makefile, and Kconfig

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/rtlwifi/Kconfig           |   16 ++++++++++++++++
 drivers/net/wireless/rtlwifi/Makefile          |   13 +++++++++++++
 drivers/net/wireless/rtlwifi/rtl8192c/Makefile |   12 ++++++++++++
 3 files changed, 41 insertions(+), 0 deletions(-)
 create mode 100644 drivers/net/wireless/rtlwifi/Kconfig
 create mode 100644 drivers/net/wireless/rtlwifi/Makefile
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192c/Makefile

diff --git a/drivers/net/wireless/rtlwifi/Kconfig b/drivers/net/wireless/rtlwifi/Kconfig
new file mode 100644
index 0000000..9ff3081
--- /dev/null
+++ b/drivers/net/wireless/rtlwifi/Kconfig
@@ -0,0 +1,16 @@
+config RTL8192CE
+	tristate "Realtek RTL8192CE/RTL8188SE Wireless Network Adapter"
+	depends on MAC80211 && EXPERIMENTAL
+	select FW_LOADER
+	select RTLWIFI
+	---help---
+	This is the driver for Realtek RTL8192CE/RTL8188CE 802.11n PCIe
+	wireless network adapters.
+
+	If you choose to build it as a module, it will be calledrtl8192ce.
+
+config RTLWIFI
+	tristate
+	depends on RTL8192CE
+	default m
+
diff --git a/drivers/net/wireless/rtlwifi/Makefile b/drivers/net/wireless/rtlwifi/Makefile
new file mode 100644
index 0000000..cd2fb60
--- /dev/null
+++ b/drivers/net/wireless/rtlwifi/Makefile
@@ -0,0 +1,13 @@
+obj-$(CONFIG_RTLWIFI) 		+= rtlwifi.o
+rtlwifi-objs	:=		\
+		base.o		\
+		cam.o		\
+		core.o		\
+		debug.o		\
+		efuse.o		\
+		pci.o		\
+		ps.o		\
+		rc.o		\
+		regd.o
+
+obj-$(CONFIG_RTL8192CE)		+= rtl8192c/
diff --git a/drivers/net/wireless/rtlwifi/rtl8192c/Makefile b/drivers/net/wireless/rtlwifi/rtl8192c/Makefile
new file mode 100644
index 0000000..f3d7682
--- /dev/null
+++ b/drivers/net/wireless/rtlwifi/rtl8192c/Makefile
@@ -0,0 +1,12 @@
+rtl8192ce-objs :=		\
+	rtl8192c-dm.o		\
+	rtl8192c-fw.o		\
+	rtl8192c-hw.o		\
+	rtl8192c-led.o		\
+	rtl8192c-phy.o		\
+	rtl8192c-rf.o		\
+	rtl8192c-sw.o		\
+	rtl8192c-table.o	\
+	rtl8192c-trx.o
+
+obj-$(CONFIG_RTL8192CE) += rtl8192ce.o
-- 
1.7.1

