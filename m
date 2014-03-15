Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:34833 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756647AbaCOWRz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Mar 2014 18:17:55 -0400
Received: by mail-pa0-f41.google.com with SMTP id fa1so4160737pad.0
        for <linux-wireless@vger.kernel.org>; Sat, 15 Mar 2014 15:17:55 -0700 (PDT)
From: Fariya Fatima <fariyaf@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Fariya Fatima <fariyaf@gmail.com>
Subject: [PATCH v5 11/11] rsi: Adding Makefile and Kconfig.
Date: Sun, 16 Mar 2014 03:47:12 +0530
Message-Id: <1394921832-4056-12-git-send-email-fariyaf@gmail.com> (sfid-20140315_231814_352667_F369271C)
In-Reply-To: <1394921832-4056-1-git-send-email-fariyaf@gmail.com>
References: <1394921832-4056-1-git-send-email-fariyaf@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Fariya Fatima <fariyaf@gmail.com>

This patch contains changes/additions related to Makefile and Kconfig.

Signed-off-by: Fariya Fatima <fariyaf@gmail.com>
---
 drivers/net/wireless/Kconfig      |    1 +
 drivers/net/wireless/Makefile     |    1 +
 drivers/net/wireless/rsi/Kconfig  |   30 ++++++++++++++++++++++++++++++
 drivers/net/wireless/rsi/Makefile |   12 ++++++++++++
 4 files changed, 44 insertions(+), 0 deletions(-)
 create mode 100644 drivers/net/wireless/rsi/Kconfig
 create mode 100644 drivers/net/wireless/rsi/Makefile

diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index 200020e..784d66e 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -281,5 +281,6 @@ source "drivers/net/wireless/ti/Kconfig"
 source "drivers/net/wireless/zd1211rw/Kconfig"
 source "drivers/net/wireless/mwifiex/Kconfig"
 source "drivers/net/wireless/cw1200/Kconfig"
+source "drivers/net/wireless/rsi/Kconfig"
 
 endif # WLAN
diff --git a/drivers/net/wireless/Makefile b/drivers/net/wireless/Makefile
index 0fab227..0c88916 100644
--- a/drivers/net/wireless/Makefile
+++ b/drivers/net/wireless/Makefile
@@ -59,3 +59,4 @@ obj-$(CONFIG_BRCMFMAC)	+= brcm80211/
 obj-$(CONFIG_BRCMSMAC)	+= brcm80211/
 
 obj-$(CONFIG_CW1200)	+= cw1200/
+obj-$(CONFIG_RSI_91X)	+= rsi/
diff --git a/drivers/net/wireless/rsi/Kconfig b/drivers/net/wireless/rsi/Kconfig
new file mode 100644
index 0000000..d0551c4
--- /dev/null
+++ b/drivers/net/wireless/rsi/Kconfig
@@ -0,0 +1,30 @@
+config RSI_91X
+	tristate "Redpine Signals Inc 91x WLAN driver support"
+	depends on MAC80211
+	---help---
+	  This option enabes support for RSI 1x1 devices.
+	  Select M (recommended), if you have a RSI 1x1 wireless module.
+
+config RSI_DEBUGFS
+	bool "Redpine Signals Inc debug support"
+	depends on RSI_91X
+	default y
+	---help---
+	 Say Y, if you would like to enable debug support. This option
+	 creates debugfs entries 
+
+config RSI_SDIO
+	tristate "Redpine Signals SDIO bus support"
+	depends on MMC && RSI_91X
+	default m
+	---help---
+	  This option enables the SDIO bus support in rsi drivers.
+	  Select M (recommended), if you have a RSI 1x1 wireless module.
+
+config RSI_USB
+	tristate "Redpine Signals USB bus support"
+	depends on USB && RSI_91X
+	default m
+	---help---
+	  This option enables the USB bus support in rsi drivers.
+	  Select M (recommended), if you have a RSI 1x1 wireless module.
diff --git a/drivers/net/wireless/rsi/Makefile b/drivers/net/wireless/rsi/Makefile
new file mode 100644
index 0000000..93553fd
--- /dev/null
+++ b/drivers/net/wireless/rsi/Makefile
@@ -0,0 +1,12 @@
+rsi_91x-y			+= rsi_91x_main.o 
+rsi_91x-y			+= rsi_91x_core.o
+rsi_91x-y			+= rsi_91x_mac80211.o
+rsi_91x-y			+= rsi_91x_mgmt.o
+rsi_91x-y			+= rsi_91x_pkt.o
+rsi_91x-$(CONFIG_RSI_DEBUGFS)	+= rsi_91x_debugfs.o
+
+rsi_usb-y			+= rsi_91x_usb.o rsi_91x_usb_ops.o
+rsi_sdio-y			+= rsi_91x_sdio.o rsi_91x_sdio_ops.o
+obj-$(CONFIG_RSI_91X) 		+= rsi_91x.o
+obj-$(CONFIG_RSI_SDIO)		+= rsi_sdio.o
+obj-$(CONFIG_RSI_USB)		+= rsi_usb.o
-- 
1.7.5.4

