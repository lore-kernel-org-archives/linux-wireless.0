Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:52653 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754902Ab3AYJ6o (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jan 2013 04:58:44 -0500
Received: from dlelxv30.itg.ti.com ([172.17.2.17])
	by arroyo.ext.ti.com (8.13.7/8.13.7) with ESMTP id r0P9wim9005548
	for <linux-wireless@vger.kernel.org>; Fri, 25 Jan 2013 03:58:44 -0600
Received: from DFLE73.ent.ti.com (dfle73.ent.ti.com [128.247.5.110])
	by dlelxv30.itg.ti.com (8.13.8/8.13.8) with ESMTP id r0P9wipA019708
	for <linux-wireless@vger.kernel.org>; Fri, 25 Jan 2013 03:58:44 -0600
From: Luciano Coelho <coelho@ti.com>
To: <linux-wireless@vger.kernel.org>
CC: <coelho@ti.com>, <balbi@ti.com>
Subject: [PATCH v2 2/5] wlcore: remove if_ops from platform_data
Date: Fri, 25 Jan 2013 11:57:48 +0200
Message-ID: <1359107868-18245-1-git-send-email-coelho@ti.com> (sfid-20130125_105850_281067_67A0C0E3)
In-Reply-To: <1358952038-5982-3-git-send-email-coelho@ti.com>
References: <1358952038-5982-3-git-send-email-coelho@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We can't pass pointers from the platform data to the modules, because
with DT it cannot be done.  Those pointers are not set by the board
files anyway.  It's the bus modules that set them, so they can be
safely removed from the platform data without changing any board
files.

Create a new structure that the bus modules pass to wlcore.  This
structure contains the if_ops pointers and a pointer to the actual
platform data.

Signed-off-by: Luciano Coelho <coelho@ti.com>
Reviewed-by: Felipe Balbi <balbi@ti.com>
---

In v2: fix wl12xx/main.c which was still using the old structure

 drivers/net/wireless/ti/wl12xx/main.c     |    3 ++-
 drivers/net/wireless/ti/wlcore/main.c     |    5 +++--
 drivers/net/wireless/ti/wlcore/sdio.c     |   22 +++++++++++++++++-----
 drivers/net/wireless/ti/wlcore/spi.c      |   20 +++++++++++++++++---
 drivers/net/wireless/ti/wlcore/wlcore_i.h |    5 +++++
 include/linux/wl12xx.h                    |    2 --
 6 files changed, 44 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/ti/wl12xx/main.c
index e5f5f8f..ae02d25 100644
--- a/drivers/net/wireless/ti/wl12xx/main.c
+++ b/drivers/net/wireless/ti/wl12xx/main.c
@@ -1636,7 +1636,8 @@ static struct ieee80211_sta_ht_cap wl12xx_ht_cap = {
 static int wl12xx_setup(struct wl1271 *wl)
 {
 	struct wl12xx_priv *priv = wl->priv;
-	struct wl12xx_platform_data *pdata = wl->pdev->dev.platform_data;
+	struct wlcore_platdev_data *pdev_data = wl->pdev->dev.platform_data;
+	struct wl12xx_platform_data *pdata = pdev_data->pdata;
 
 	wl->rtable = wl12xx_rtable;
 	wl->num_tx_desc = WL12XX_NUM_TX_DESCRIPTORS;
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 6eba5a0..6509ff0 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -5538,7 +5538,8 @@ static void wlcore_nvs_cb(const struct firmware *fw, void *context)
 {
 	struct wl1271 *wl = context;
 	struct platform_device *pdev = wl->pdev;
-	struct wl12xx_platform_data *pdata = pdev->dev.platform_data;
+	struct wlcore_platdev_data *pdev_data = pdev->dev.platform_data;
+	struct wl12xx_platform_data *pdata = pdev_data->pdata;
 	unsigned long irqflags;
 	int ret;
 
@@ -5567,7 +5568,7 @@ static void wlcore_nvs_cb(const struct firmware *fw, void *context)
 
 	wl->irq = platform_get_irq(pdev, 0);
 	wl->platform_quirks = pdata->platform_quirks;
-	wl->if_ops = pdata->ops;
+	wl->if_ops = pdev_data->if_ops;
 
 	if (wl->platform_quirks & WL12XX_PLATFORM_QUIRK_EDGE_IRQ)
 		irqflags = IRQF_TRIGGER_RISING;
diff --git a/drivers/net/wireless/ti/wlcore/sdio.c b/drivers/net/wireless/ti/wlcore/sdio.c
index 646f703..1471b79 100644
--- a/drivers/net/wireless/ti/wlcore/sdio.c
+++ b/drivers/net/wireless/ti/wlcore/sdio.c
@@ -218,6 +218,7 @@ static int wl1271_probe(struct sdio_func *func,
 				  const struct sdio_device_id *id)
 {
 	struct wl12xx_platform_data *wlan_data;
+	struct wlcore_platdev_data *pdev_data;
 	struct wl12xx_sdio_glue *glue;
 	struct resource res[1];
 	mmc_pm_flag_t mmcflags;
@@ -228,10 +229,18 @@ static int wl1271_probe(struct sdio_func *func,
 	if (func->num != 0x02)
 		return -ENODEV;
 
+	pdev_data = kzalloc(sizeof(*pdev_data), GFP_KERNEL);
+	if (!pdev_data) {
+		dev_err(&func->dev, "can't allocate platdev_data\n");
+		goto out;
+	}
+
+	pdev_data->if_ops = &sdio_ops;
+
 	glue = kzalloc(sizeof(*glue), GFP_KERNEL);
 	if (!glue) {
 		dev_err(&func->dev, "can't allocate glue\n");
-		goto out;
+		goto out_free_pdev_data;
 	}
 
 	glue->dev = &func->dev;
@@ -256,8 +265,6 @@ static int wl1271_probe(struct sdio_func *func,
 	if (mmcflags & MMC_PM_KEEP_POWER)
 		wlan_data->pwr_in_suspend = true;
 
-	wlan_data->ops = &sdio_ops;
-
 	sdio_set_drvdata(func, glue);
 
 	/* Tell PM core that we don't need the card to be powered now */
@@ -295,8 +302,10 @@ static int wl1271_probe(struct sdio_func *func,
 		goto out_dev_put;
 	}
 
-	ret = platform_device_add_data(glue->core, wlan_data,
-				       sizeof(*wlan_data));
+	pdev_data->pdata = wlan_data;
+
+	ret = platform_device_add_data(glue->core, pdev_data,
+				       sizeof(*pdev_data));
 	if (ret) {
 		dev_err(glue->dev, "can't add platform data\n");
 		goto out_dev_put;
@@ -315,6 +324,9 @@ out_dev_put:
 out_free_glue:
 	kfree(glue);
 
+out_free_pdev_data:
+	kfree(pdev_data);
+
 out:
 	return ret;
 }
diff --git a/drivers/net/wireless/ti/wlcore/spi.c b/drivers/net/wireless/ti/wlcore/spi.c
index f06f477..e17b46d 100644
--- a/drivers/net/wireless/ti/wlcore/spi.c
+++ b/drivers/net/wireless/ti/wlcore/spi.c
@@ -328,6 +328,7 @@ static int wl1271_probe(struct spi_device *spi)
 {
 	struct wl12xx_spi_glue *glue;
 	struct wl12xx_platform_data *pdata;
+	struct wlcore_platdev_data *pdev_data;
 	struct resource res[1];
 	int ret = -ENOMEM;
 
@@ -337,12 +338,18 @@ static int wl1271_probe(struct spi_device *spi)
 		return -ENODEV;
 	}
 
-	pdata->ops = &spi_ops;
+	pdev_data = kzalloc(sizeof(*pdev_data), GFP_KERNEL);
+	if (!pdev_data) {
+		dev_err(&spi->dev, "can't allocate platdev_data\n");
+		goto out;
+	}
+
+	pdev_data->if_ops = &spi_ops;
 
 	glue = kzalloc(sizeof(*glue), GFP_KERNEL);
 	if (!glue) {
 		dev_err(&spi->dev, "can't allocate glue\n");
-		goto out;
+		goto out_free_pdev_data;
 	}
 
 	glue->dev = &spi->dev;
@@ -380,7 +387,10 @@ static int wl1271_probe(struct spi_device *spi)
 		goto out_dev_put;
 	}
 
-	ret = platform_device_add_data(glue->core, pdata, sizeof(*pdata));
+	pdev_data->pdata = pdata;
+
+	ret = platform_device_add_data(glue->core, pdev_data,
+				       sizeof(*pdev_data));
 	if (ret) {
 		dev_err(glue->dev, "can't add platform data\n");
 		goto out_dev_put;
@@ -399,6 +409,10 @@ out_dev_put:
 
 out_free_glue:
 	kfree(glue);
+
+out_free_pdev_data:
+	kfree(pdev_data);
+
 out:
 	return ret;
 }
diff --git a/drivers/net/wireless/ti/wlcore/wlcore_i.h b/drivers/net/wireless/ti/wlcore/wlcore_i.h
index 6678d4b..702c0b6 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore_i.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore_i.h
@@ -214,6 +214,11 @@ struct wl1271_if_operations {
 	void (*set_block_size) (struct device *child, unsigned int blksz);
 };
 
+struct wlcore_platdev_data {
+	struct wl12xx_platform_data *pdata;
+	struct wl1271_if_operations *if_ops;
+};
+
 #define MAX_NUM_KEYS 14
 #define MAX_KEY_SIZE 32
 
diff --git a/include/linux/wl12xx.h b/include/linux/wl12xx.h
index 0d63731..360c9bc 100644
--- a/include/linux/wl12xx.h
+++ b/include/linux/wl12xx.h
@@ -55,8 +55,6 @@ struct wl12xx_platform_data {
 	int board_tcxo_clock;
 	unsigned long platform_quirks;
 	bool pwr_in_suspend;
-
-	struct wl1271_if_operations *ops;
 };
 
 /* Platform does not support level trigger interrupts */
-- 
1.7.10.4

