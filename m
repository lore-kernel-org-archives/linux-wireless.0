Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:59704 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754982Ab0LHROD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Dec 2010 12:14:03 -0500
Received: by mail-pw0-f46.google.com with SMTP id 3so322374pwj.19
        for <linux-wireless@vger.kernel.org>; Wed, 08 Dec 2010 09:14:03 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, chaoming_li@realsil.com.cn,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 11/22] rtl8192ce: Add files to rtlwifi - Part 11: Kconfig and Makefile
Date: Wed,  8 Dec 2010 11:12:41 -0600
Message-Id: <1291828372-25159-12-git-send-email-Larry.Finger@lwfinger.net>
In-Reply-To: <1291828372-25159-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1291828372-25159-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/rtlwifi/Kconfig  |   16 ++++++++++++++++
 drivers/net/wireless/rtlwifi/Makefile |   13 +++++++++++++
 2 files changed, 29 insertions(+), 0 deletions(-)
 create mode 100644 drivers/net/wireless/rtlwifi/Kconfig
 create mode 100644 drivers/net/wireless/rtlwifi/Makefile

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
-- 
1.7.1

