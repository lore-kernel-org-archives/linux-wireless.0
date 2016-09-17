Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from muru.com ([72.249.23.125]:42591 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753817AbcIQQGm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 17 Sep 2016 12:06:42 -0400
From: Tony Lindgren <tony@atomide.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Eyal Reizer <eyalr@ti.com>, Guy Mishol <guym@ti.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Maital Hahn <maitalm@ti.com>,
        Maxim Altshul <maxim.altshul@ti.com>,
        Shahar Patury <shaharp@ti.com>, linux-wireless@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: [PATCH 2/5] wlcore: sdio: Populate config firmware data
Date: Sat, 17 Sep 2016 09:06:30 -0700
Message-Id: <20160917160633.8767-3-tony@atomide.com> (sfid-20160917_180647_182241_9B624B65)
In-Reply-To: <20160917160633.8767-1-tony@atomide.com>
References: <20160917160633.8767-1-tony@atomide.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Configure the config firmware names and make it available
in platform data.

Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 drivers/net/wireless/ti/wlcore/sdio.c | 76 ++++++++++++++++++++++-------------
 1 file changed, 47 insertions(+), 29 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/sdio.c b/drivers/net/wireless/ti/wlcore/sdio.c
--- a/drivers/net/wireless/ti/wlcore/sdio.c
+++ b/drivers/net/wireless/ti/wlcore/sdio.c
@@ -216,17 +216,33 @@ static struct wl1271_if_operations sdio_ops = {
 };
 
 #ifdef CONFIG_OF
+
+static const struct wilink_family_data wl127x_data = {
+	.name = "wl127x",
+	.nvs_name = "ti-connectivity/wl127x-nvs.bin",
+};
+
+static const struct wilink_family_data wl128x_data = {
+	.name = "wl128x",
+	.nvs_name = "ti-connectivity/wl128x-nvs.bin",
+};
+
+static const struct wilink_family_data wl18xx_data = {
+	.name = "wl18xx",
+	.cfg_name = "ti-connectivity/wl18xx-conf.bin",
+};
+
 static const struct of_device_id wlcore_sdio_of_match_table[] = {
-	{ .compatible = "ti,wl1271" },
-	{ .compatible = "ti,wl1273" },
-	{ .compatible = "ti,wl1281" },
-	{ .compatible = "ti,wl1283" },
-	{ .compatible = "ti,wl1801" },
-	{ .compatible = "ti,wl1805" },
-	{ .compatible = "ti,wl1807" },
-	{ .compatible = "ti,wl1831" },
-	{ .compatible = "ti,wl1835" },
-	{ .compatible = "ti,wl1837" },
+	{ .compatible = "ti,wl1271", .data = &wl127x_data },
+	{ .compatible = "ti,wl1273", .data = &wl127x_data },
+	{ .compatible = "ti,wl1281", .data = &wl128x_data },
+	{ .compatible = "ti,wl1283", .data = &wl128x_data },
+	{ .compatible = "ti,wl1801", .data = &wl18xx_data },
+	{ .compatible = "ti,wl1805", .data = &wl18xx_data },
+	{ .compatible = "ti,wl1807", .data = &wl18xx_data },
+	{ .compatible = "ti,wl1831", .data = &wl18xx_data },
+	{ .compatible = "ti,wl1835", .data = &wl18xx_data },
+	{ .compatible = "ti,wl1837", .data = &wl18xx_data },
 	{ }
 };
 
@@ -234,9 +250,13 @@ static int wlcore_probe_of(struct device *dev, int *irq,
 			   struct wlcore_platdev_data *pdev_data)
 {
 	struct device_node *np = dev->of_node;
+	const struct of_device_id *of_id;
+
+	of_id = of_match_node(wlcore_sdio_of_match_table, np);
+	if (!of_id)
+		return -ENODEV;
 
-	if (!np || !of_match_node(wlcore_sdio_of_match_table, np))
-		return -ENODATA;
+	pdev_data->family = of_id->data;
 
 	*irq = irq_of_parse_and_map(np, 0);
 	if (!*irq) {
@@ -263,7 +283,7 @@ static int wlcore_probe_of(struct device *dev, int *irq,
 static int wl1271_probe(struct sdio_func *func,
 				  const struct sdio_device_id *id)
 {
-	struct wlcore_platdev_data pdev_data;
+	struct wlcore_platdev_data *pdev_data;
 	struct wl12xx_sdio_glue *glue;
 	struct resource res[1];
 	mmc_pm_flag_t mmcflags;
@@ -275,14 +295,15 @@ static int wl1271_probe(struct sdio_func *func,
 	if (func->num != 0x02)
 		return -ENODEV;
 
-	memset(&pdev_data, 0x00, sizeof(pdev_data));
-	pdev_data.if_ops = &sdio_ops;
+	pdev_data = devm_kzalloc(&func->dev, sizeof(*pdev_data), GFP_KERNEL);
+	if (!pdev_data)
+		return -ENOMEM;
 
-	glue = kzalloc(sizeof(*glue), GFP_KERNEL);
-	if (!glue) {
-		dev_err(&func->dev, "can't allocate glue\n");
-		goto out;
-	}
+	pdev_data->if_ops = &sdio_ops;
+
+	glue = devm_kzalloc(&func->dev, sizeof(*glue), GFP_KERNEL);
+	if (!glue)
+		return -ENOMEM;
 
 	glue->dev = &func->dev;
 
@@ -292,16 +313,16 @@ static int wl1271_probe(struct sdio_func *func,
 	/* Use block mode for transferring over one block size of data */
 	func->card->quirks |= MMC_QUIRK_BLKSZ_FOR_BYTE_MODE;
 
-	ret = wlcore_probe_of(&func->dev, &irq, &pdev_data);
+	ret = wlcore_probe_of(&func->dev, &irq, pdev_data);
 	if (ret)
-		goto out_free_glue;
+		goto out;
 
 	/* if sdio can keep power while host is suspended, enable wow */
 	mmcflags = sdio_get_host_pm_caps(func);
 	dev_dbg(glue->dev, "sdio PM caps = 0x%x\n", mmcflags);
 
 	if (mmcflags & MMC_PM_KEEP_POWER)
-		pdev_data.pwr_in_suspend = true;
+		pdev_data->pwr_in_suspend = true;
 
 	sdio_set_drvdata(func, glue);
 
@@ -323,7 +344,7 @@ static int wl1271_probe(struct sdio_func *func,
 	if (!glue->core) {
 		dev_err(glue->dev, "can't allocate platform_device");
 		ret = -ENOMEM;
-		goto out_free_glue;
+		goto out;
 	}
 
 	glue->core->dev.parent = &func->dev;
@@ -341,8 +362,8 @@ static int wl1271_probe(struct sdio_func *func,
 		goto out_dev_put;
 	}
 
-	ret = platform_device_add_data(glue->core, &pdev_data,
-				       sizeof(pdev_data));
+	ret = platform_device_add_data(glue->core, pdev_data,
+				       sizeof(*pdev_data));
 	if (ret) {
 		dev_err(glue->dev, "can't add platform data\n");
 		goto out_dev_put;
@@ -358,9 +379,6 @@ static int wl1271_probe(struct sdio_func *func,
 out_dev_put:
 	platform_device_put(glue->core);
 
-out_free_glue:
-	kfree(glue);
-
 out:
 	return ret;
 }
-- 
2.9.3
