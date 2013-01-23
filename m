Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:56429 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754737Ab3AWOlg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jan 2013 09:41:36 -0500
Received: from dlelxv30.itg.ti.com ([172.17.2.17])
	by bear.ext.ti.com (8.13.7/8.13.7) with ESMTP id r0NEfart004222
	for <linux-wireless@vger.kernel.org>; Wed, 23 Jan 2013 08:41:36 -0600
Received: from DFLE73.ent.ti.com (dfle73.ent.ti.com [128.247.5.110])
	by dlelxv30.itg.ti.com (8.13.8/8.13.8) with ESMTP id r0NEfapl025932
	for <linux-wireless@vger.kernel.org>; Wed, 23 Jan 2013 08:41:36 -0600
From: Luciano Coelho <coelho@ti.com>
To: <linux-wireless@vger.kernel.org>
CC: <coelho@ti.com>
Subject: [PATCH 3/5] wlcore: use wl12xx_platform_data pointer from wlcore_pdev_data
Date: Wed, 23 Jan 2013 16:40:36 +0200
Message-ID: <1358952038-5982-4-git-send-email-coelho@ti.com> (sfid-20130123_154141_218012_9E6EB260)
In-Reply-To: <1358952038-5982-1-git-send-email-coelho@ti.com>
References: <1358952038-5982-1-git-send-email-coelho@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Just a small cleanup to use the pointer provided by wlcore_pdev_data
instead of using a separate pointer then copying.

Reviewed-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wlcore/sdio.c |   13 +++++--------
 drivers/net/wireless/ti/wlcore/spi.c  |   16 +++++++---------
 2 files changed, 12 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/sdio.c b/drivers/net/wireless/ti/wlcore/sdio.c
index 1f6f6e3..6d2884f 100644
--- a/drivers/net/wireless/ti/wlcore/sdio.c
+++ b/drivers/net/wireless/ti/wlcore/sdio.c
@@ -217,7 +217,6 @@ static struct wl1271_if_operations sdio_ops = {
 static int wl1271_probe(struct sdio_func *func,
 				  const struct sdio_device_id *id)
 {
-	struct wl12xx_platform_data *wlan_data;
 	struct wlcore_platdev_data *pdev_data;
 	struct wl12xx_sdio_glue *glue;
 	struct resource res[1];
@@ -251,9 +250,9 @@ static int wl1271_probe(struct sdio_func *func,
 	/* Use block mode for transferring over one block size of data */
 	func->card->quirks |= MMC_QUIRK_BLKSZ_FOR_BYTE_MODE;
 
-	wlan_data = wl12xx_get_platform_data();
-	if (IS_ERR(wlan_data)) {
-		ret = PTR_ERR(wlan_data);
+	pdev_data->pdata = wl12xx_get_platform_data();
+	if (IS_ERR(pdev_data->pdata)) {
+		ret = PTR_ERR(pdev_data->pdata);
 		dev_err(glue->dev, "missing wlan platform data: %d\n", ret);
 		goto out_free_glue;
 	}
@@ -263,7 +262,7 @@ static int wl1271_probe(struct sdio_func *func,
 	dev_dbg(glue->dev, "sdio PM caps = 0x%x\n", mmcflags);
 
 	if (mmcflags & MMC_PM_KEEP_POWER)
-		wlan_data->pwr_in_suspend = true;
+		pdev_data->pdata->pwr_in_suspend = true;
 
 	sdio_set_drvdata(func, glue);
 
@@ -292,7 +291,7 @@ static int wl1271_probe(struct sdio_func *func,
 
 	memset(res, 0x00, sizeof(res));
 
-	res[0].start = wlan_data->irq;
+	res[0].start = pdev_data->pdata->irq;
 	res[0].flags = IORESOURCE_IRQ;
 	res[0].name = "irq";
 
@@ -302,8 +301,6 @@ static int wl1271_probe(struct sdio_func *func,
 		goto out_dev_put;
 	}
 
-	pdev_data->pdata = wlan_data;
-
 	ret = platform_device_add_data(glue->core, pdev_data,
 				       sizeof(*pdev_data));
 	if (ret) {
diff --git a/drivers/net/wireless/ti/wlcore/spi.c b/drivers/net/wireless/ti/wlcore/spi.c
index d437f4d..d62a20b 100644
--- a/drivers/net/wireless/ti/wlcore/spi.c
+++ b/drivers/net/wireless/ti/wlcore/spi.c
@@ -327,23 +327,23 @@ static struct wl1271_if_operations spi_ops = {
 static int wl1271_probe(struct spi_device *spi)
 {
 	struct wl12xx_spi_glue *glue;
-	struct wl12xx_platform_data *pdata;
 	struct wlcore_platdev_data *pdev_data;
 	struct resource res[1];
 	int ret = -ENOMEM;
 
-	pdata = spi->dev.platform_data;
-	if (!pdata) {
-		dev_err(&spi->dev, "no platform data\n");
-		return -ENODEV;
-	}
-
 	pdev_data = kzalloc(sizeof(*pdev_data), GFP_KERNEL);
 	if (!pdev_data) {
 		dev_err(&spi->dev, "can't allocate platdev_data\n");
 		goto out;
 	}
 
+	pdev_data->pdata = spi->dev.platform_data;
+	if (!pdev_data->pdata) {
+		dev_err(&spi->dev, "no platform data\n");
+		ret = -ENODEV;
+		goto out_free_pdev_data;
+	}
+
 	pdev_data->if_ops = &spi_ops;
 
 	glue = kzalloc(sizeof(*glue), GFP_KERNEL);
@@ -387,8 +387,6 @@ static int wl1271_probe(struct spi_device *spi)
 		goto out_dev_put;
 	}
 
-	pdev_data->pdata = pdata;
-
 	ret = platform_device_add_data(glue->core, pdev_data,
 				       sizeof(*pdev_data));
 	if (ret) {
-- 
1.7.10.4

