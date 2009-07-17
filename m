Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:54946 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201AbZGQS4Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jul 2009 14:56:16 -0400
From: Kalle Valo <kalle.valo@iki.fi>
Subject: [RFC PATCH v2 6/8] wl1251: move module probe methods into spi.c
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 17 Jul 2009 21:48:28 +0300
Message-ID: <20090717184827.25883.44200.stgit@tikku>
In-Reply-To: <20090717184643.25883.95065.stgit@tikku>
References: <20090717184643.25883.95065.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Bob Copeland <me@bobcopeland.com>

This change moves all of the spi specific code from main.c into
spi.c.  The module initialization code also moves, but common
code for initializing mac80211 etc. stays in main.c, as this will
eventually form a common library module also used by wl1251_sdio.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---

 drivers/net/wireless/wl12xx/wl1251.h      |    7 +
 drivers/net/wireless/wl12xx/wl1251_acx.c  |    1 
 drivers/net/wireless/wl12xx/wl1251_cmd.c  |    1 
 drivers/net/wireless/wl12xx/wl1251_main.c |  148 ++++-------------------------
 drivers/net/wireless/wl12xx/wl1251_spi.c  |  125 ++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/wl1251_tx.c   |    1 
 6 files changed, 151 insertions(+), 132 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1251.h b/drivers/net/wireless/wl12xx/wl1251.h
index 284bb50..df4c06d 100644
--- a/drivers/net/wireless/wl12xx/wl1251.h
+++ b/drivers/net/wireless/wl12xx/wl1251.h
@@ -292,7 +292,7 @@ struct wl1251 {
 	bool mac80211_registered;
 
 	struct spi_device *spi;
-	struct wl1251_if_operations *if_ops;
+	const struct wl1251_if_operations *if_ops;
 
 	void (*set_power)(bool enable);
 	int irq;
@@ -404,6 +404,11 @@ struct wl1251 {
 int wl1251_plt_start(struct wl1251 *wl);
 int wl1251_plt_stop(struct wl1251 *wl);
 
+irqreturn_t wl1251_irq(int irq, void *cookie);
+struct ieee80211_hw *wl1251_alloc_hw(void);
+int wl1251_free_hw(struct wl1251 *wl);
+int wl1251_init_ieee80211(struct wl1251 *wl);
+
 #define DEFAULT_HW_GEN_MODULATION_TYPE    CCK_LONG /* Long Preamble */
 #define DEFAULT_HW_GEN_TX_RATE          RATE_2MBPS
 #define JOIN_TIMEOUT 5000 /* 5000 milliseconds to join */
diff --git a/drivers/net/wireless/wl12xx/wl1251_acx.c b/drivers/net/wireless/wl12xx/wl1251_acx.c
index b89fa23..b07747d 100644
--- a/drivers/net/wireless/wl12xx/wl1251_acx.c
+++ b/drivers/net/wireless/wl12xx/wl1251_acx.c
@@ -2,7 +2,6 @@
 
 #include <linux/module.h>
 #include <linux/crc7.h>
-#include <linux/spi/spi.h>
 
 #include "wl1251.h"
 #include "reg.h"
diff --git a/drivers/net/wireless/wl12xx/wl1251_cmd.c b/drivers/net/wireless/wl12xx/wl1251_cmd.c
index 2c30c70..dfbf681 100644
--- a/drivers/net/wireless/wl12xx/wl1251_cmd.c
+++ b/drivers/net/wireless/wl12xx/wl1251_cmd.c
@@ -2,7 +2,6 @@
 
 #include <linux/module.h>
 #include <linux/crc7.h>
-#include <linux/spi/spi.h>
 
 #include "wl1251.h"
 #include "reg.h"
diff --git a/drivers/net/wireless/wl12xx/wl1251_main.c b/drivers/net/wireless/wl12xx/wl1251_main.c
index 238b4a8..62b84fc 100644
--- a/drivers/net/wireless/wl12xx/wl1251_main.c
+++ b/drivers/net/wireless/wl12xx/wl1251_main.c
@@ -26,17 +26,15 @@
 #include <linux/firmware.h>
 #include <linux/delay.h>
 #include <linux/irq.h>
-#include <linux/spi/spi.h>
 #include <linux/crc32.h>
 #include <linux/etherdevice.h>
-#include <linux/spi/wl12xx.h>
 
 #include "wl1251.h"
 #include "wl12xx_80211.h"
 #include "reg.h"
 #include "wl1251_ops.h"
 #include "wl1251_io.h"
-#include "wl1251_spi.h"
+#include "wl1251_cmd.h"
 #include "wl1251_event.h"
 #include "wl1251_tx.h"
 #include "wl1251_rx.h"
@@ -59,7 +57,7 @@ static void wl1251_power_on(struct wl1251 *wl)
 	wl->set_power(true);
 }
 
-static irqreturn_t wl1251_irq(int irq, void *cookie)
+irqreturn_t wl1251_irq(int irq, void *cookie)
 {
 	struct wl1251 *wl;
 
@@ -1224,8 +1222,10 @@ static int wl1251_register_hw(struct wl1251 *wl)
 	return 0;
 }
 
-static int wl1251_init_ieee80211(struct wl1251 *wl)
+int wl1251_init_ieee80211(struct wl1251 *wl)
 {
+	int ret;
+
 	/* The tx descriptor buffer and the TKIP space */
 	wl->hw->extra_tx_headroom = sizeof(struct tx_double_buffer_desc)
 		+ WL1251_TKIP_IV_SPACE;
@@ -1241,41 +1241,37 @@ static int wl1251_init_ieee80211(struct wl1251 *wl)
 	wl->hw->wiphy->max_scan_ssids = 1;
 	wl->hw->wiphy->bands[IEEE80211_BAND_2GHZ] = &wl1251_band_2ghz;
 
-	SET_IEEE80211_DEV(wl->hw, &wl->spi->dev);
+	ret = wl1251_register_hw(wl);
+	if (ret)
+		goto out;
 
-	return 0;
-}
+	wl1251_debugfs_init(wl);
+	wl1251_notice("initialized");
 
-extern struct wl1251_if_operations wl1251_spi_ops;
+	ret = 0;
+
+out:
+	return ret;
+}
 
 #define WL1251_DEFAULT_CHANNEL 1
-static int __devinit wl1251_probe(struct spi_device *spi)
+struct ieee80211_hw *wl1251_alloc_hw(void)
 {
-	struct wl12xx_platform_data *pdata;
 	struct ieee80211_hw *hw;
 	struct wl1251 *wl;
-	int ret, i;
+	int i;
 	static const u8 nokia_oui[3] = {0x00, 0x1f, 0xdf};
 
-	pdata = spi->dev.platform_data;
-	if (!pdata) {
-		wl1251_error("no platform data");
-		return -ENODEV;
-	}
-
 	hw = ieee80211_alloc_hw(sizeof(*wl), &wl1251_ops);
 	if (!hw) {
 		wl1251_error("could not alloc ieee80211_hw");
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 	}
 
 	wl = hw->priv;
 	memset(wl, 0, sizeof(*wl));
 
 	wl->hw = hw;
-	dev_set_drvdata(&spi->dev, wl);
-	wl->spi = spi;
-	wl->if_ops = &wl1251_spi_ops;
 
 	wl->data_in_count = 0;
 
@@ -1323,74 +1319,15 @@ static int __devinit wl1251_probe(struct spi_device *spi)
 	wl->rx_descriptor = kmalloc(sizeof(*wl->rx_descriptor), GFP_KERNEL);
 	if (!wl->rx_descriptor) {
 		wl1251_error("could not allocate memory for rx descriptor");
-		ret = -ENOMEM;
-		goto out_free;
+		ieee80211_free_hw(hw);
+		return ERR_PTR(-ENOMEM);
 	}
 
-	/* This is the only SPI value that we need to set here, the rest
-	 * comes from the board-peripherals file */
-	spi->bits_per_word = 32;
-
-	ret = spi_setup(spi);
-	if (ret < 0) {
-		wl1251_error("spi_setup failed");
-		goto out_free;
-	}
-
-	wl->set_power = pdata->set_power;
-	if (!wl->set_power) {
-		wl1251_error("set power function missing in platform data");
-		ret = -ENODEV;
-		goto out_free;
-	}
-
-	wl->irq = spi->irq;
-	if (wl->irq < 0) {
-		wl1251_error("irq missing in platform data");
-		ret = -ENODEV;
-		goto out_free;
-	}
-
-	ret = request_irq(wl->irq, wl1251_irq, 0, DRIVER_NAME, wl);
-	if (ret < 0) {
-		wl1251_error("request_irq() failed: %d", ret);
-		goto out_free;
-	}
-
-	set_irq_type(wl->irq, IRQ_TYPE_EDGE_RISING);
-
-	disable_irq(wl->irq);
-
-	ret = wl1251_init_ieee80211(wl);
-	if (ret)
-		goto out_irq;
-
-	ret = wl1251_register_hw(wl);
-	if (ret)
-		goto out_irq;
-
-	wl1251_debugfs_init(wl);
-
-	wl1251_notice("initialized");
-
-	return 0;
-
- out_irq:
-	free_irq(wl->irq, wl);
-
- out_free:
-	kfree(wl->rx_descriptor);
-	wl->rx_descriptor = NULL;
-
-	ieee80211_free_hw(hw);
-
-	return ret;
+	return hw;
 }
 
-static int __devexit wl1251_remove(struct spi_device *spi)
+int wl1251_free_hw(struct wl1251 *wl)
 {
-	struct wl1251 *wl = dev_get_drvdata(&spi->dev);
-
 	ieee80211_unregister_hw(wl->hw);
 
 	wl1251_debugfs_exit(wl);
@@ -1410,44 +1347,3 @@ static int __devexit wl1251_remove(struct spi_device *spi)
 
 	return 0;
 }
-
-
-static struct spi_driver wl1251_spi_driver = {
-	.driver = {
-		/* FIXME: use wl12xx name to not break the user space */
-		.name		= "wl12xx",
-		.bus		= &spi_bus_type,
-		.owner		= THIS_MODULE,
-	},
-
-	.probe		= wl1251_probe,
-	.remove		= __devexit_p(wl1251_remove),
-};
-
-static int __init wl1251_init(void)
-{
-	int ret;
-
-	ret = spi_register_driver(&wl1251_spi_driver);
-	if (ret < 0) {
-		wl1251_error("failed to register spi driver: %d", ret);
-		goto out;
-	}
-
-out:
-	return ret;
-}
-
-static void __exit wl1251_exit(void)
-{
-	spi_unregister_driver(&wl1251_spi_driver);
-
-	wl1251_notice("unloaded");
-}
-
-module_init(wl1251_init);
-module_exit(wl1251_exit);
-
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Kalle Valo <Kalle.Valo@nokia.com>, "
-		"Luciano Coelho <luciano.coelho@nokia.com>");
diff --git a/drivers/net/wireless/wl12xx/wl1251_spi.c b/drivers/net/wireless/wl12xx/wl1251_spi.c
index ceb237b..13e7a72 100644
--- a/drivers/net/wireless/wl12xx/wl1251_spi.c
+++ b/drivers/net/wireless/wl12xx/wl1251_spi.c
@@ -21,9 +21,11 @@
  *
  */
 
+#include <linux/irq.h>
 #include <linux/module.h>
 #include <linux/crc7.h>
 #include <linux/spi/spi.h>
+#include <linux/spi/wl12xx.h>
 
 #include "wl1251.h"
 #include "reg.h"
@@ -55,7 +57,7 @@ static void wl1251_spi_reset(struct wl1251 *wl)
 	wl1251_dump(DEBUG_SPI, "spi reset -> ", cmd, WSPI_INIT_CMD_LEN);
 }
 
-static void wl1251_spi_init(struct wl1251 *wl)
+static void wl1251_spi_wake(struct wl1251 *wl)
 {
 	u8 crc[WSPI_INIT_CMD_CRC_LEN], *cmd;
 	struct spi_transfer t;
@@ -112,7 +114,7 @@ static void wl1251_spi_init(struct wl1251 *wl)
 static void wl1251_spi_reset_wake(struct wl1251 *wl)
 {
 	wl1251_spi_reset(wl);
-	wl1251_spi_init(wl);
+	wl1251_spi_wake(wl);
 }
 
 static void wl1251_spi_read(struct wl1251 *wl, int addr, void *buf,
@@ -191,3 +193,122 @@ const struct wl1251_if_operations wl1251_spi_ops = {
 	.write = wl1251_spi_write,
 	.reset = wl1251_spi_reset_wake,
 };
+
+static int __devinit wl1251_spi_probe(struct spi_device *spi)
+{
+	struct wl12xx_platform_data *pdata;
+	struct ieee80211_hw *hw;
+	struct wl1251 *wl;
+	int ret;
+
+	pdata = spi->dev.platform_data;
+	if (!pdata) {
+		wl1251_error("no platform data");
+		return -ENODEV;
+	}
+
+	hw = wl1251_alloc_hw();
+	if (IS_ERR(hw))
+		return PTR_ERR(hw);
+
+	wl = hw->priv;
+
+	SET_IEEE80211_DEV(hw, &spi->dev);
+	dev_set_drvdata(&spi->dev, wl);
+	wl->spi = spi;
+	wl->if_ops = &wl1251_spi_ops;
+
+	/* This is the only SPI value that we need to set here, the rest
+	 * comes from the board-peripherals file */
+	spi->bits_per_word = 32;
+
+	ret = spi_setup(spi);
+	if (ret < 0) {
+		wl1251_error("spi_setup failed");
+		goto out_free;
+	}
+
+	wl->set_power = pdata->set_power;
+	if (!wl->set_power) {
+		wl1251_error("set power function missing in platform data");
+		return -ENODEV;
+	}
+
+	wl->irq = spi->irq;
+	if (wl->irq < 0) {
+		wl1251_error("irq missing in platform data");
+		return -ENODEV;
+	}
+
+	ret = request_irq(wl->irq, wl1251_irq, 0, DRIVER_NAME, wl);
+	if (ret < 0) {
+		wl1251_error("request_irq() failed: %d", ret);
+		goto out_free;
+	}
+
+	set_irq_type(wl->irq, IRQ_TYPE_EDGE_RISING);
+
+	disable_irq(wl->irq);
+
+	ret = wl1251_init_ieee80211(wl);
+	if (ret)
+		goto out_irq;
+
+	return 0;
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
+static int __devexit wl1251_spi_remove(struct spi_device *spi)
+{
+	struct wl1251 *wl = dev_get_drvdata(&spi->dev);
+
+	wl1251_free_hw(wl);
+
+	return 0;
+}
+
+static struct spi_driver wl1251_spi_driver = {
+	.driver = {
+		.name		= "wl12xx",
+		.bus		= &spi_bus_type,
+		.owner		= THIS_MODULE,
+	},
+
+	.probe		= wl1251_spi_probe,
+	.remove		= __devexit_p(wl1251_spi_remove),
+};
+
+static int __init wl1251_spi_init(void)
+{
+	int ret;
+
+	ret = spi_register_driver(&wl1251_spi_driver);
+	if (ret < 0) {
+		wl1251_error("failed to register spi driver: %d", ret);
+		goto out;
+	}
+
+out:
+	return ret;
+}
+
+static void __exit wl1251_spi_exit(void)
+{
+	spi_unregister_driver(&wl1251_spi_driver);
+
+	wl1251_notice("unloaded");
+}
+
+module_init(wl1251_spi_init);
+module_exit(wl1251_spi_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Kalle Valo <Kalle.Valo@nokia.com>");
+MODULE_AUTHOR("Luciano Coelho <luciano.coelho@nokia.com>");
diff --git a/drivers/net/wireless/wl12xx/wl1251_tx.c b/drivers/net/wireless/wl12xx/wl1251_tx.c
index 7ddc9a3..f20bab6 100644
--- a/drivers/net/wireless/wl12xx/wl1251_tx.c
+++ b/drivers/net/wireless/wl12xx/wl1251_tx.c
@@ -27,7 +27,6 @@
 
 #include "wl1251.h"
 #include "reg.h"
-#include "wl1251_spi.h"
 #include "wl1251_tx.h"
 #include "wl1251_ps.h"
 #include "wl1251_io.h"

