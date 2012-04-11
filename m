Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog123.obsmtp.com ([74.125.149.149]:55648 "EHLO
	na3sys009aog123.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754175Ab2DKJiU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Apr 2012 05:38:20 -0400
Received: by lbao2 with SMTP id o2so540102lba.28
        for <linux-wireless@vger.kernel.org>; Wed, 11 Apr 2012 02:38:17 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: arik@wizery.com, linville@tuxdriver.com, coelho@ti.com
Subject: [PATCH 03/16] wl12xx/wlcore: spin out the wl12xx probe from wlcore to a new wl12xx
Date: Wed, 11 Apr 2012 12:37:50 +0300
Message-Id: <1334137083-13490-4-git-send-email-coelho@ti.com> (sfid-20120411_113831_051797_6FEA68F9)
In-Reply-To: <1334137083-13490-1-git-send-email-coelho@ti.com>
References: <1334137083-13490-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Create a new small wl12xx module that only contains the probe
functions and depends entirely on wlcore otherwise.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/Kconfig         |    3 ++
 drivers/net/wireless/ti/Makefile        |    3 +-
 drivers/net/wireless/ti/wl12xx/Kconfig  |    8 ++++
 drivers/net/wireless/ti/wl12xx/Makefile |    3 ++
 drivers/net/wireless/ti/wl12xx/main.c   |   56 +++++++++++++++++++++++++++++++
 drivers/net/wireless/ti/wlcore/Kconfig  |   45 ++++++++++--------------
 drivers/net/wireless/ti/wlcore/Makefile |   14 ++++----
 drivers/net/wireless/ti/wlcore/main.c   |   34 ++----------------
 drivers/net/wireless/ti/wlcore/wlcore.h |   28 +++++++++++++++
 9 files changed, 130 insertions(+), 64 deletions(-)
 create mode 100644 drivers/net/wireless/ti/wl12xx/Kconfig
 create mode 100644 drivers/net/wireless/ti/wl12xx/Makefile
 create mode 100644 drivers/net/wireless/ti/wl12xx/main.c
 create mode 100644 drivers/net/wireless/ti/wlcore/wlcore.h

diff --git a/drivers/net/wireless/ti/Kconfig b/drivers/net/wireless/ti/Kconfig
index 1e8d04b..1a72932 100644
--- a/drivers/net/wireless/ti/Kconfig
+++ b/drivers/net/wireless/ti/Kconfig
@@ -7,5 +7,8 @@ menuconfig WL_TI
 
 if WL_TI
 source "drivers/net/wireless/ti/wl1251/Kconfig"
+source "drivers/net/wireless/ti/wl12xx/Kconfig"
+
+# keep last for automatic dependencies
 source "drivers/net/wireless/ti/wlcore/Kconfig"
 endif # WL_TI
diff --git a/drivers/net/wireless/ti/Makefile b/drivers/net/wireless/ti/Makefile
index 10919db..0a56562 100644
--- a/drivers/net/wireless/ti/Makefile
+++ b/drivers/net/wireless/ti/Makefile
@@ -1,3 +1,4 @@
-obj-$(CONFIG_WL12XX)			+= wlcore/
+obj-$(CONFIG_WLCORE)			+= wlcore/
+obj-$(CONFIG_WL12XX)			+= wl12xx/
 obj-$(CONFIG_WL12XX_PLATFORM_DATA)	+= wlcore/
 obj-$(CONFIG_WL1251)			+= wl1251/
diff --git a/drivers/net/wireless/ti/wl12xx/Kconfig b/drivers/net/wireless/ti/wl12xx/Kconfig
new file mode 100644
index 0000000..5b92329
--- /dev/null
+++ b/drivers/net/wireless/ti/wl12xx/Kconfig
@@ -0,0 +1,8 @@
+config WL12XX
+       tristate "TI wl12xx support"
+       select WLCORE
+       ---help---
+	  This module adds support for wireless adapters based on TI wl1271,
+	  wl1273, wl1281 and wl1283 chipsets. This module does *not* include
+	  support for wl1251.  For wl1251 support, use the separate homonymous
+	   driver instead.
diff --git a/drivers/net/wireless/ti/wl12xx/Makefile b/drivers/net/wireless/ti/wl12xx/Makefile
new file mode 100644
index 0000000..1df22d5
--- /dev/null
+++ b/drivers/net/wireless/ti/wl12xx/Makefile
@@ -0,0 +1,3 @@
+wl12xx-objs	= main.o
+
+obj-$(CONFIG_WL12XX)		+= wl12xx.o
diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/ti/wl12xx/main.c
new file mode 100644
index 0000000..e6c3502
--- /dev/null
+++ b/drivers/net/wireless/ti/wl12xx/main.c
@@ -0,0 +1,56 @@
+/*
+ * This file is part of wl1271
+ *
+ * Copyright (C) 2008-2010 Nokia Corporation
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/platform_device.h>
+
+#include "../wlcore/wlcore.h"
+
+static const struct platform_device_id wl12xx_id_table[] __devinitconst = {
+	{ "wl12xx", 0 },
+	{  } /* Terminating Entry */
+};
+MODULE_DEVICE_TABLE(platform, wl12xx_id_table);
+
+static struct platform_driver wl12xx_driver = {
+	.probe		= wlcore_probe,
+	.remove		= __devexit_p(wlcore_remove),
+	.id_table	= wl12xx_id_table,
+	.driver = {
+		.name	= "wl12xx_driver",
+		.owner	= THIS_MODULE,
+	}
+};
+
+static int __init wl12xx_init(void)
+{
+	return platform_driver_register(&wl12xx_driver);
+}
+module_init(wl12xx_init);
+
+static void __exit wl12xx_exit(void)
+{
+	platform_driver_unregister(&wl12xx_driver);
+}
+module_exit(wl12xx_exit);
+
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("Luciano Coelho <coelho@ti.com>");
diff --git a/drivers/net/wireless/ti/wlcore/Kconfig b/drivers/net/wireless/ti/wlcore/Kconfig
index af08c86..9d04c38 100644
--- a/drivers/net/wireless/ti/wlcore/Kconfig
+++ b/drivers/net/wireless/ti/wlcore/Kconfig
@@ -1,48 +1,41 @@
-menuconfig WL12XX_MENU
-	tristate "TI wl12xx driver support"
-	depends on MAC80211 && EXPERIMENTAL
-	---help---
-	  This will enable TI wl12xx driver support for the following chips:
-	  wl1271, wl1273, wl1281 and wl1283.
-	  The drivers make use of the mac80211 stack.
-
-config WL12XX
-	tristate "TI wl12xx support"
-	depends on WL12XX_MENU && GENERIC_HARDIRQS
+config WLCORE
+	tristate "TI wlcore support"
+	depends on WL_TI && GENERIC_HARDIRQS
 	depends on INET
 	select FW_LOADER
 	---help---
-	  This module adds support for wireless adapters based on TI wl1271 and
-	  TI wl1273 chipsets. This module does *not* include support for wl1251.
-	  For wl1251 support, use the separate homonymous driver instead.
+	  This module contains the main code for TI WLAN chips.  It abstracts
+	  hardware-specific differences among different chipset families.
+	  Each chipset family needs to implement its own lower-level module
+	  that will depend on this module for the common code.
 
-	  If you choose to build a module, it will be called wl12xx. Say N if
+	  If you choose to build a module, it will be called wlcore. Say N if
 	  unsure.
 
-config WL12XX_SPI
-	tristate "TI wl12xx SPI support"
-	depends on WL12XX && SPI_MASTER
+config WLCORE_SPI
+	tristate "TI wlcore SPI support"
+	depends on WLCORE && SPI_MASTER
 	select CRC7
 	---help---
 	  This module adds support for the SPI interface of adapters using
-	  TI wl12xx chipsets.  Select this if your platform is using
+	  TI WLAN chipsets.  Select this if your platform is using
 	  the SPI bus.
 
-	  If you choose to build a module, it'll be called wl12xx_spi.
+	  If you choose to build a module, it'll be called wlcore_spi.
 	  Say N if unsure.
 
-config WL12XX_SDIO
-	tristate "TI wl12xx SDIO support"
-	depends on WL12XX && MMC
+config WLCORE_SDIO
+	tristate "TI wlcore SDIO support"
+	depends on WLCORE && MMC
 	---help---
 	  This module adds support for the SDIO interface of adapters using
-	  TI wl12xx chipsets.  Select this if your platform is using
+	  TI WLAN chipsets.  Select this if your platform is using
 	  the SDIO bus.
 
-	  If you choose to build a module, it'll be called wl12xx_sdio.
+	  If you choose to build a module, it'll be called wlcore_sdio.
 	  Say N if unsure.
 
 config WL12XX_PLATFORM_DATA
 	bool
-	depends on WL12XX_SDIO != n || WL1251_SDIO != n
+	depends on WLCORE_SDIO != n || WL1251_SDIO != n
 	default y
diff --git a/drivers/net/wireless/ti/wlcore/Makefile b/drivers/net/wireless/ti/wlcore/Makefile
index 98f289c..d9fba9e 100644
--- a/drivers/net/wireless/ti/wlcore/Makefile
+++ b/drivers/net/wireless/ti/wlcore/Makefile
@@ -1,13 +1,13 @@
-wl12xx-objs		= main.o cmd.o io.o event.o tx.o rx.o ps.o acx.o \
+wlcore-objs		= main.o cmd.o io.o event.o tx.o rx.o ps.o acx.o \
 			  boot.o init.o debugfs.o scan.o
 
-wl12xx_spi-objs 	= spi.o
-wl12xx_sdio-objs	= sdio.o
+wlcore_spi-objs 	= spi.o
+wlcore_sdio-objs	= sdio.o
 
-wl12xx-$(CONFIG_NL80211_TESTMODE)	+= testmode.o
-obj-$(CONFIG_WL12XX)			+= wl12xx.o
-obj-$(CONFIG_WL12XX_SPI)		+= wl12xx_spi.o
-obj-$(CONFIG_WL12XX_SDIO)		+= wl12xx_sdio.o
+wlcore-$(CONFIG_NL80211_TESTMODE)	+= testmode.o
+obj-$(CONFIG_WLCORE)			+= wlcore.o
+obj-$(CONFIG_WLCORE_SPI)		+= wlcore_spi.o
+obj-$(CONFIG_WLCORE_SDIO)		+= wlcore_sdio.o
 
 # small builtin driver bit
 obj-$(CONFIG_WL12XX_PLATFORM_DATA)	+= wl12xx_platform_data.o
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 96ca25a..651536e 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -5477,7 +5477,7 @@ static irqreturn_t wl12xx_hardirq(int irq, void *cookie)
 	return IRQ_WAKE_THREAD;
 }
 
-static int __devinit wl12xx_probe(struct platform_device *pdev)
+int __devinit wlcore_probe(struct platform_device *pdev)
 {
 	struct wl12xx_platform_data *pdata = pdev->dev.platform_data;
 	struct ieee80211_hw *hw;
@@ -5572,8 +5572,9 @@ out_free_hw:
 out:
 	return ret;
 }
+EXPORT_SYMBOL_GPL(wlcore_probe);
 
-static int __devexit wl12xx_remove(struct platform_device *pdev)
+int __devexit wlcore_remove(struct platform_device *pdev)
 {
 	struct wl1271 *wl = platform_get_drvdata(pdev);
 
@@ -5587,34 +5588,7 @@ static int __devexit wl12xx_remove(struct platform_device *pdev)
 
 	return 0;
 }
-
-static const struct platform_device_id wl12xx_id_table[] __devinitconst = {
-	{ "wl12xx", 0 },
-	{  } /* Terminating Entry */
-};
-MODULE_DEVICE_TABLE(platform, wl12xx_id_table);
-
-static struct platform_driver wl12xx_driver = {
-	.probe		= wl12xx_probe,
-	.remove		= __devexit_p(wl12xx_remove),
-	.id_table	= wl12xx_id_table,
-	.driver = {
-		.name	= "wl12xx_driver",
-		.owner	= THIS_MODULE,
-	}
-};
-
-static int __init wl12xx_init(void)
-{
-	return platform_driver_register(&wl12xx_driver);
-}
-module_init(wl12xx_init);
-
-static void __exit wl12xx_exit(void)
-{
-	platform_driver_unregister(&wl12xx_driver);
-}
-module_exit(wl12xx_exit);
+EXPORT_SYMBOL_GPL(wlcore_remove);
 
 u32 wl12xx_debug_level = DEBUG_NONE;
 EXPORT_SYMBOL_GPL(wl12xx_debug_level);
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
new file mode 100644
index 0000000..e0187d7
--- /dev/null
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -0,0 +1,28 @@
+/*
+ * This file is part of wlcore
+ *
+ * Copyright (C) 2011 Texas Instruments Inc.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#ifndef __WLCORE_H__
+#define __WLCORE_H__
+
+int __devinit wlcore_probe(struct platform_device *pdev);
+int __devexit wlcore_remove(struct platform_device *pdev);
+
+#endif /* __WLCORE_H__ */
-- 
1.7.5.4

