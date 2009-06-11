Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:1645 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761563AbZFKCDq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jun 2009 22:03:46 -0400
From: Bob Copeland <me@bobcopeland.com>
To: linux-wireless@vger.kernel.org, pierre@ossman.eu
Cc: kalle.valo@iki.fi, san@google.com,
	Bob Copeland <me@bobcopeland.com>
Subject: [PATCH/RFC 7/7] wl12xx: add sdio support
Date: Wed, 10 Jun 2009 22:03:00 -0400
Message-Id: <1244685780-28930-8-git-send-email-me@bobcopeland.com>
In-Reply-To: <1244685780-28930-1-git-send-email-me@bobcopeland.com>
References: <1244685780-28930-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds the wl12xx_sdio module, enabling the SDIO interface for
wl12xx, as used by the Google G1 phone and others.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/wl12xx/Kconfig  |   11 ++
 drivers/net/wireless/wl12xx/Makefile |    2 +
 drivers/net/wireless/wl12xx/sdio.c   |  250 ++++++++++++++++++++++++++++++++++
 3 files changed, 263 insertions(+), 0 deletions(-)
 create mode 100644 drivers/net/wireless/wl12xx/sdio.c

diff --git a/drivers/net/wireless/wl12xx/Kconfig b/drivers/net/wireless/wl12xx/Kconfig
index 9575d16..c4af50a 100644
--- a/drivers/net/wireless/wl12xx/Kconfig
+++ b/drivers/net/wireless/wl12xx/Kconfig
@@ -20,3 +20,14 @@ config WL12XX_SPI
 
 	  If you choose to build a module, it'll be called wl12xx_spi. Say N if
 	  unsure.
+
+config WL12XX_SDIO
+	tristate "TI wl1251/wl1271 SDIO support"
+	depends on WL12XX && MMC
+	---help---
+	  This module adds support for the SDIO interface of adapters using
+	  TI wl1251/wl1271 chipsets.  Select this if your platform is using
+	  the SDIO bus.
+
+	  If you choose to build a module, it'll be called wl12xx_sdio. Say N if
+	  unsure.
diff --git a/drivers/net/wireless/wl12xx/Makefile b/drivers/net/wireless/wl12xx/Makefile
index ffd5664..25df712 100644
--- a/drivers/net/wireless/wl12xx/Makefile
+++ b/drivers/net/wireless/wl12xx/Makefile
@@ -3,6 +3,8 @@ wl12xx-objs		= main.o event.o tx.o rx.o \
 			  debugfs.o io.o
 
 wl12xx_spi-objs		+= spi.o
+wl12xx_sdio-objs	+= sdio.o
 
 obj-$(CONFIG_WL12XX)	+= wl12xx.o
 obj-$(CONFIG_WL12XX_SPI)	+= wl12xx_spi.o
+obj-$(CONFIG_WL12XX_SDIO)	+= wl12xx_sdio.o
diff --git a/drivers/net/wireless/wl12xx/sdio.c b/drivers/net/wireless/wl12xx/sdio.c
new file mode 100644
index 0000000..9aae632
--- /dev/null
+++ b/drivers/net/wireless/wl12xx/sdio.c
@@ -0,0 +1,250 @@
+/*
+ * wl12xx SDIO routines
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
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
+ * Copyright (C) 2005 Texas Instruments Incorporated
+ * Copyright (C) 2008 Google Inc
+ * Copyright (C) 2009 Bob Copeland (me@bobcopeland.com)
+ */
+#include <linux/module.h>
+#include <linux/crc7.h>
+#include <linux/mod_devicetable.h>
+#include <linux/irq.h>
+#include <linux/mmc/sdio_func.h>
+#include <linux/mmc/sdio_ids.h>
+#include <linux/platform_device.h>
+
+#include "wl12xx.h"
+#include "wl12xx_80211.h"
+#include "reg.h"
+#include "ps.h"
+#include "io.h"
+#include "tx.h"
+#include "debugfs.h"
+
+#define SDIO_VENDOR_ID_TI		0x104c
+#define SDIO_DEVICE_ID_WL1251		0x9066
+
+static struct sdio_func *wl_to_func(struct wl12xx *wl)
+{
+	return wl->if_priv;
+}
+
+static void wl12xx_sdio_interrupt(struct sdio_func *func)
+{
+	wl12xx_irq(0, sdio_get_drvdata(func));
+}
+
+/* FIXME use wl12xx_platform_data instead of msm-specific wifi_XXX */
+#if 1
+#include <linux/wifi_tiwlan.h>
+static int wifi_probe(struct platform_device *pdev)
+{
+	struct wifi_platform_data *wifi_ctrl =
+		(struct wifi_platform_data *)(pdev->dev.platform_data);
+
+	if (!wifi_ctrl)
+		return -ENODEV;
+
+	wifi_ctrl->set_power(1);	/* Power On */
+	wifi_ctrl->set_reset(0);	/* Reset clear */
+	wifi_ctrl->set_carddetect(1);	/* CardDetect (0->1) */
+
+	return 0;
+}
+
+static int wifi_remove(struct platform_device *pdev)
+{
+	struct wifi_platform_data *wifi_ctrl =
+		(struct wifi_platform_data *)(pdev->dev.platform_data);
+
+	if (!wifi_ctrl)
+		return -ENODEV;
+
+	wifi_ctrl->set_carddetect(0);	/* CardDetect (1->0) */
+	wifi_ctrl->set_reset(1);	/* Reset active */
+	wifi_ctrl->set_power(0);	/* Power Off */
+
+	return 0;
+}
+
+static struct platform_driver wifi_device = {
+	.probe		= wifi_probe,
+	.remove		= wifi_remove,
+	.driver		= {
+		.name   = "msm_wifi",
+	},
+};
+
+static int wifi_add_dev(void)
+{
+	return platform_driver_register(&wifi_device);
+}
+
+static void wifi_del_dev(void)
+{
+	platform_driver_unregister(&wifi_device);
+}
+#else
+static int wifi_add_dev(void)
+{
+	return 0;
+}
+
+static void wifi_del_dev(void)
+{
+}
+#endif
+
+static const struct sdio_device_id wl12xx_devices[] = {
+	{ SDIO_DEVICE(SDIO_VENDOR_ID_TI, SDIO_DEVICE_ID_WL1251) },
+	{}
+};
+MODULE_DEVICE_TABLE(sdio, wl12xx_devices);
+
+
+void wl12xx_sdio_read(struct wl12xx *wl, int addr, void *buf, size_t len)
+{
+	int ret;
+	struct sdio_func *func = wl_to_func(wl);
+
+	sdio_claim_host(func);
+	ret = sdio_memcpy_fromio(func, buf, addr, len);
+	if (ret)
+		wl12xx_error("sdio read failed (%d)", ret);
+	sdio_release_host(func);
+}
+
+void wl12xx_sdio_write(struct wl12xx *wl, int addr, void *buf, size_t len)
+{
+	int ret;
+	struct sdio_func *func = wl_to_func(wl);
+
+	sdio_claim_host(func);
+	ret = sdio_memcpy_toio(func, addr, buf, len);
+	if (ret)
+		wl12xx_error("sdio write failed (%d)", ret);
+	sdio_release_host(func);
+}
+
+void wl12xx_sdio_reset(struct wl12xx *wl)
+{
+}
+
+void wl12xx_sdio_set_power(bool enable)
+{
+}
+
+struct wl12xx_if_operations wl12xx_sdio_ops = {
+	.read = wl12xx_sdio_read,
+	.write = wl12xx_sdio_write,
+	.reset = wl12xx_sdio_reset,
+};
+
+int wl12xx_sdio_probe(struct sdio_func *func, const struct sdio_device_id *id)
+{
+	int ret;
+	struct wl12xx *wl;
+	struct ieee80211_hw *hw;
+
+	hw = wl12xx_alloc_hw();
+	if (IS_ERR(hw))
+		return PTR_ERR(hw);
+
+	wl = hw->priv;
+
+	sdio_claim_host(func);
+	ret = sdio_enable_func(func);
+	if (ret)
+		goto release;
+
+	sdio_set_block_size(func, 512);
+
+	SET_IEEE80211_DEV(hw, &func->dev);
+	wl->if_priv = func;
+	wl->if_ops = &wl12xx_sdio_ops;
+	wl->set_power = wl12xx_sdio_set_power;
+
+	sdio_release_host(func);
+	ret = wl12xx_init_ieee80211(wl);
+	sdio_claim_host(func);
+	if (ret)
+		goto disable;
+
+	ret = sdio_claim_irq(func, wl12xx_sdio_interrupt);
+	if (ret)
+		goto no_irq;
+
+	sdio_release_host(func);
+	sdio_set_drvdata(func, wl);
+	return ret;
+
+no_irq:
+	wl12xx_free_hw(wl);
+disable:
+	sdio_disable_func(func);
+release:
+	sdio_release_host(func);
+	return ret;
+}
+
+static void __devexit wl12xx_sdio_remove(struct sdio_func *func)
+{
+	struct wl12xx *wl = sdio_get_drvdata(func);
+
+	sdio_claim_host(func);
+	sdio_release_irq(func);
+	sdio_disable_func(func);
+	sdio_release_host(func);
+
+	wl12xx_free_hw(wl);
+}
+
+static struct sdio_driver wl12xx_sdio_driver = {
+	.name		= "wl12xx_sdio",
+	.id_table	= wl12xx_devices,
+	.probe		= wl12xx_sdio_probe,
+	.remove		= __devexit_p(wl12xx_sdio_remove),
+};
+
+static int __init wl12xx_sdio_init(void)
+{
+	int err;
+
+	err = wifi_add_dev();
+	if (err)
+		goto out;
+
+	err = sdio_register_driver(&wl12xx_sdio_driver);
+out:
+	if (err)
+		wl12xx_error("failed to register sdio driver: %d", ret);
+	return err;
+}
+
+static void __exit wl12xx_sdio_exit(void)
+{
+	wifi_del_dev();
+	sdio_unregister_driver(&wl12xx_sdio_driver);
+	wl12xx_notice("unloaded");
+}
+
+module_init(wl12xx_sdio_init);
+module_exit(wl12xx_sdio_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Kalle Valo <Kalle.Valo@nokia.com>");
+MODULE_AUTHOR("Luciano Coelho <luciano.coelho@nokia.com>");
-- 
1.6.0.6


