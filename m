Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:22465 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751901Ab0BVGlP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Feb 2010 01:41:15 -0500
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
Subject: [PATCH 01/22] wl1271: Moved module basics to wl1271_spi.c
Date: Mon, 22 Feb 2010 08:38:21 +0200
Message-Id: <1266820722-20202-2-git-send-email-juuso.oikarinen@nokia.com>
In-Reply-To: <1266820722-20202-1-git-send-email-juuso.oikarinen@nokia.com>
References: <1266820722-20202-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>

Moved wl1271 drivers probe, remove etc. functions and structres to
wl1271_spi.c from wl1271_main.c in preparation of implementing SDIO interface.

Signed-off-by: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
Reviewed-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_io.h   |    8 ++
 drivers/net/wireless/wl12xx/wl1271_main.c |  191 +----------------------------
 drivers/net/wireless/wl12xx/wl1271_spi.c  |  180 +++++++++++++++++++++++++++
 3 files changed, 193 insertions(+), 186 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_io.h b/drivers/net/wireless/wl12xx/wl1271_io.h
index fa9a0b3..38fce4c 100644
--- a/drivers/net/wireless/wl12xx/wl1271_io.h
+++ b/drivers/net/wireless/wl12xx/wl1271_io.h
@@ -65,4 +65,12 @@ static inline void wl1271_raw_write32(struct wl1271 *wl, int addr, u32 val)
 	wl1271_raw_write(wl, addr, &wl->buffer_32,
 			     sizeof(wl->buffer_32), false);
 }
+
+/* Functions from wl1271_main.c */
+
+int wl1271_register_hw(struct wl1271 *wl);
+int wl1271_init_ieee80211(struct wl1271 *wl);
+struct ieee80211_hw *wl1271_alloc_hw(void);
+int wl1271_free_hw(struct wl1271 *wl);
+
 #endif
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 2a864b2..66319aa 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -22,16 +22,12 @@
  */
 
 #include <linux/module.h>
-#include <linux/platform_device.h>
-#include <linux/interrupt.h>
 #include <linux/firmware.h>
 #include <linux/delay.h>
-#include <linux/irq.h>
 #include <linux/spi/spi.h>
 #include <linux/crc32.h>
 #include <linux/etherdevice.h>
 #include <linux/vmalloc.h>
-#include <linux/spi/wl12xx.h>
 #include <linux/inetdevice.h>
 
 #include "wl1271.h"
@@ -484,28 +480,6 @@ out:
 	mutex_unlock(&wl->mutex);
 }
 
-static irqreturn_t wl1271_irq(int irq, void *cookie)
-{
-	struct wl1271 *wl;
-	unsigned long flags;
-
-	wl1271_debug(DEBUG_IRQ, "IRQ");
-
-	wl = cookie;
-
-	/* complete the ELP completion */
-	spin_lock_irqsave(&wl->wl_lock, flags);
-	if (wl->elp_compl) {
-		complete(wl->elp_compl);
-		wl->elp_compl = NULL;
-	}
-
-	ieee80211_queue_work(wl->hw, &wl->irq_work);
-	spin_unlock_irqrestore(&wl->wl_lock, flags);
-
-	return IRQ_HANDLED;
-}
-
 static int wl1271_fetch_firmware(struct wl1271 *wl)
 {
 	const struct firmware *fw;
@@ -1959,7 +1933,7 @@ static const struct ieee80211_ops wl1271_ops = {
 	CFG80211_TESTMODE_CMD(wl1271_tm_cmd)
 };
 
-static int wl1271_register_hw(struct wl1271 *wl)
+int wl1271_register_hw(struct wl1271 *wl)
 {
 	int ret;
 
@@ -1981,7 +1955,7 @@ static int wl1271_register_hw(struct wl1271 *wl)
 	return 0;
 }
 
-static int wl1271_init_ieee80211(struct wl1271 *wl)
+int wl1271_init_ieee80211(struct wl1271 *wl)
 {
 	/* The tx descriptor buffer and the TKIP space. */
 	wl->hw->extra_tx_headroom = WL1271_TKIP_IV_SPACE +
@@ -2009,24 +1983,9 @@ static int wl1271_init_ieee80211(struct wl1271 *wl)
 	return 0;
 }
 
-static void wl1271_device_release(struct device *dev)
-{
-
-}
-
-static struct platform_device wl1271_device = {
-	.name           = "wl1271",
-	.id             = -1,
-
-	/* device model insists to have a release function */
-	.dev            = {
-		.release = wl1271_device_release,
-	},
-};
-
 #define WL1271_DEFAULT_CHANNEL 0
 
-static struct ieee80211_hw *wl1271_alloc_hw(void)
+struct ieee80211_hw *wl1271_alloc_hw(void)
 {
 	struct ieee80211_hw *hw;
 	struct wl1271 *wl;
@@ -2073,6 +2032,8 @@ static struct ieee80211_hw *wl1271_alloc_hw(void)
 	/* Apply default driver configuration. */
 	wl1271_conf_init(wl);
 
+	wl1271_debugfs_init(wl);
+
 	return hw;
 }
 
@@ -2095,145 +2056,3 @@ int wl1271_free_hw(struct wl1271 *wl)
 
 	return 0;
 }
-
-static int __devinit wl1271_probe(struct spi_device *spi)
-{
-	struct wl12xx_platform_data *pdata;
-	struct ieee80211_hw *hw;
-	struct wl1271 *wl;
-	int ret;
-
-	pdata = spi->dev.platform_data;
-	if (!pdata) {
-		wl1271_error("no platform data");
-		return -ENODEV;
-	}
-
-	hw = wl1271_alloc_hw();
-	if (IS_ERR(hw))
-		return PTR_ERR(hw);
-
-	wl = hw->priv;
-
-	dev_set_drvdata(&spi->dev, wl);
-	wl->spi = spi;
-
-	/* This is the only SPI value that we need to set here, the rest
-	 * comes from the board-peripherals file */
-	spi->bits_per_word = 32;
-
-	ret = spi_setup(spi);
-	if (ret < 0) {
-		wl1271_error("spi_setup failed");
-		goto out_free;
-	}
-
-	wl->set_power = pdata->set_power;
-	if (!wl->set_power) {
-		wl1271_error("set power function missing in platform data");
-		ret = -ENODEV;
-		goto out_free;
-	}
-
-	wl->irq = spi->irq;
-	if (wl->irq < 0) {
-		wl1271_error("irq missing in platform data");
-		ret = -ENODEV;
-		goto out_free;
-	}
-
-	ret = request_irq(wl->irq, wl1271_irq, 0, DRIVER_NAME, wl);
-	if (ret < 0) {
-		wl1271_error("request_irq() failed: %d", ret);
-		goto out_free;
-	}
-
-	set_irq_type(wl->irq, IRQ_TYPE_EDGE_RISING);
-
-	disable_irq(wl->irq);
-
-	ret = platform_device_register(&wl1271_device);
-	if (ret) {
-		wl1271_error("couldn't register platform device");
-		goto out_irq;
-	}
-	dev_set_drvdata(&wl1271_device.dev, wl);
-
-	ret = wl1271_init_ieee80211(wl);
-	if (ret)
-		goto out_platform;
-
-	ret = wl1271_register_hw(wl);
-	if (ret)
-		goto out_platform;
-
-	wl1271_debugfs_init(wl);
-
-	wl1271_notice("initialized");
-
-	return 0;
-
- out_platform:
-	platform_device_unregister(&wl1271_device);
-
- out_irq:
-	free_irq(wl->irq, wl);
-
- out_free:
-	ieee80211_free_hw(hw);
-
-	return ret;
-}
-
-static int __devexit wl1271_remove(struct spi_device *spi)
-{
-	struct wl1271 *wl = dev_get_drvdata(&spi->dev);
-
-	platform_device_unregister(&wl1271_device);
-	free_irq(wl->irq, wl);
-
-	wl1271_free_hw(wl);
-
-	return 0;
-}
-
-
-static struct spi_driver wl1271_spi_driver = {
-	.driver = {
-		.name		= "wl1271",
-		.bus		= &spi_bus_type,
-		.owner		= THIS_MODULE,
-	},
-
-	.probe		= wl1271_probe,
-	.remove		= __devexit_p(wl1271_remove),
-};
-
-static int __init wl1271_init(void)
-{
-	int ret;
-
-	ret = spi_register_driver(&wl1271_spi_driver);
-	if (ret < 0) {
-		wl1271_error("failed to register spi driver: %d", ret);
-		goto out;
-	}
-
-out:
-	return ret;
-}
-
-static void __exit wl1271_exit(void)
-{
-	spi_unregister_driver(&wl1271_spi_driver);
-
-	wl1271_notice("unloaded");
-}
-
-module_init(wl1271_init);
-module_exit(wl1271_exit);
-
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Luciano Coelho <luciano.coelho@nokia.com>");
-MODULE_AUTHOR("Juuso Oikarinen <juuso.oikarinen@nokia.com>");
-MODULE_FIRMWARE(WL1271_FW_NAME);
diff --git a/drivers/net/wireless/wl12xx/wl1271_spi.c b/drivers/net/wireless/wl12xx/wl1271_spi.c
index 67a8293..c26726a 100644
--- a/drivers/net/wireless/wl12xx/wl1271_spi.c
+++ b/drivers/net/wireless/wl12xx/wl1271_spi.c
@@ -21,14 +21,17 @@
  *
  */
 
+#include <linux/irq.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/crc7.h>
 #include <linux/spi/spi.h>
+#include <linux/spi/wl12xx.h>
 
 #include "wl1271.h"
 #include "wl12xx_80211.h"
 #include "wl1271_spi.h"
+#include "wl1271_io.h"
 
 
 void wl1271_spi_reset(struct wl1271 *wl)
@@ -255,3 +258,180 @@ void wl1271_spi_raw_write(struct wl1271 *wl, int addr, void *buf,
 	wl1271_dump(DEBUG_SPI, "spi_write cmd -> ", cmd, sizeof(*cmd));
 	wl1271_dump(DEBUG_SPI, "spi_write buf -> ", buf, len);
 }
+
+static irqreturn_t wl1271_irq(int irq, void *cookie)
+{
+	struct wl1271 *wl;
+	unsigned long flags;
+
+	wl1271_debug(DEBUG_IRQ, "IRQ");
+
+	wl = cookie;
+
+	/* complete the ELP completion */
+	spin_lock_irqsave(&wl->wl_lock, flags);
+	if (wl->elp_compl) {
+		complete(wl->elp_compl);
+		wl->elp_compl = NULL;
+	}
+
+	ieee80211_queue_work(wl->hw, &wl->irq_work);
+	spin_unlock_irqrestore(&wl->wl_lock, flags);
+
+	return IRQ_HANDLED;
+}
+
+static void wl1271_device_release(struct device *dev)
+{
+
+}
+
+static struct platform_device wl1271_device = {
+	.name           = "wl1271",
+	.id             = -1,
+
+	/* device model insists to have a release function */
+	.dev            = {
+		.release = wl1271_device_release,
+	},
+};
+
+static int __devinit wl1271_probe(struct spi_device *spi)
+{
+	struct wl12xx_platform_data *pdata;
+	struct ieee80211_hw *hw;
+	struct wl1271 *wl;
+	int ret;
+
+	pdata = spi->dev.platform_data;
+	if (!pdata) {
+		wl1271_error("no platform data");
+		return -ENODEV;
+	}
+
+	hw = wl1271_alloc_hw();
+	if (IS_ERR(hw))
+		return PTR_ERR(hw);
+
+	wl = hw->priv;
+
+	dev_set_drvdata(&spi->dev, wl);
+	wl->spi = spi;
+
+	/* This is the only SPI value that we need to set here, the rest
+	 * comes from the board-peripherals file */
+	spi->bits_per_word = 32;
+
+	ret = spi_setup(spi);
+	if (ret < 0) {
+		wl1271_error("spi_setup failed");
+		goto out_free;
+	}
+
+	wl->set_power = pdata->set_power;
+	if (!wl->set_power) {
+		wl1271_error("set power function missing in platform data");
+		ret = -ENODEV;
+		goto out_free;
+	}
+
+	wl->irq = spi->irq;
+	if (wl->irq < 0) {
+		wl1271_error("irq missing in platform data");
+		ret = -ENODEV;
+		goto out_free;
+	}
+
+	ret = request_irq(wl->irq, wl1271_irq, 0, DRIVER_NAME, wl);
+	if (ret < 0) {
+		wl1271_error("request_irq() failed: %d", ret);
+		goto out_free;
+	}
+
+	set_irq_type(wl->irq, IRQ_TYPE_EDGE_RISING);
+
+	disable_irq(wl->irq);
+
+	ret = platform_device_register(&wl1271_device);
+	if (ret) {
+		wl1271_error("couldn't register platform device");
+		goto out_irq;
+	}
+	dev_set_drvdata(&wl1271_device.dev, wl);
+
+	ret = wl1271_init_ieee80211(wl);
+	if (ret)
+		goto out_platform;
+
+	ret = wl1271_register_hw(wl);
+	if (ret)
+		goto out_platform;
+
+	wl1271_notice("initialized");
+
+	return 0;
+
+ out_platform:
+	platform_device_unregister(&wl1271_device);
+
+ out_irq:
+	free_irq(wl->irq, wl);
+
+ out_free:
+	ieee80211_free_hw(hw);
+
+	return ret;
+}
+
+static int __devexit wl1271_remove(struct spi_device *spi)
+{
+	struct wl1271 *wl = dev_get_drvdata(&spi->dev);
+
+	platform_device_unregister(&wl1271_device);
+	free_irq(wl->irq, wl);
+
+	wl1271_free_hw(wl);
+
+	return 0;
+}
+
+
+static struct spi_driver wl1271_spi_driver = {
+	.driver = {
+		.name		= "wl1271",
+		.bus		= &spi_bus_type,
+		.owner		= THIS_MODULE,
+	},
+
+	.probe		= wl1271_probe,
+	.remove		= __devexit_p(wl1271_remove),
+};
+
+static int __init wl1271_init(void)
+{
+	int ret;
+
+	ret = spi_register_driver(&wl1271_spi_driver);
+	if (ret < 0) {
+		wl1271_error("failed to register spi driver: %d", ret);
+		goto out;
+	}
+
+out:
+	return ret;
+}
+
+static void __exit wl1271_exit(void)
+{
+	spi_unregister_driver(&wl1271_spi_driver);
+
+	wl1271_notice("unloaded");
+}
+
+module_init(wl1271_init);
+module_exit(wl1271_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Luciano Coelho <luciano.coelho@nokia.com>");
+MODULE_AUTHOR("Juuso Oikarinen <juuso.oikarinen@nokia.com>");
+MODULE_FIRMWARE(WL1271_FW_NAME);
-- 
1.6.3.3

