Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from muru.com ([72.249.23.125]:42595 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753870AbcIQQGn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 17 Sep 2016 12:06:43 -0400
From: Tony Lindgren <tony@atomide.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Eyal Reizer <eyalr@ti.com>, Guy Mishol <guym@ti.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Maital Hahn <maitalm@ti.com>,
        Maxim Altshul <maxim.altshul@ti.com>,
        Shahar Patury <shaharp@ti.com>, linux-wireless@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: [PATCH 3/5] wlcore: spi: Populate config firmware data
Date: Sat, 17 Sep 2016 09:06:31 -0700
Message-Id: <20160917160633.8767-4-tony@atomide.com> (sfid-20160917_180650_926360_03F4586C)
In-Reply-To: <20160917160633.8767-1-tony@atomide.com>
References: <20160917160633.8767-1-tony@atomide.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Configure the config firmware names and make it available
in platform data.

Let's also fix the order of the struct wilink_family_data
while at it.

Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 drivers/net/wireless/ti/wlcore/spi.c | 42 ++++++++++++++++++++----------------
 1 file changed, 24 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/spi.c b/drivers/net/wireless/ti/wlcore/spi.c
--- a/drivers/net/wireless/ti/wlcore/spi.c
+++ b/drivers/net/wireless/ti/wlcore/spi.c
@@ -79,15 +79,19 @@
 #define WSPI_MAX_NUM_OF_CHUNKS \
 	((SPI_AGGR_BUFFER_SIZE / WSPI_MAX_CHUNK_SIZE) + 1)
 
+static const struct wilink_family_data wl127x_data = {
+	.name = "wl127x",
+	.nvs_name = "ti-connectivity/wl127x-nvs.bin",
+};
 
-static const struct wilink_family_data *wilink_data;
+static const struct wilink_family_data wl128x_data = {
+	.name = "wl128x",
+	.nvs_name = "ti-connectivity/wl128x-nvs.bin",
+};
 
 static const struct wilink_family_data wl18xx_data = {
 	.name = "wl18xx",
-};
-
-static const struct wilink_family_data wl12xx_data = {
-	.name = "wl12xx",
+	.cfg_name = "ti-connectivity/wl18xx-conf.bin",
 };
 
 struct wl12xx_spi_glue {
@@ -425,10 +429,10 @@ static struct wl1271_if_operations spi_ops = {
 };
 
 static const struct of_device_id wlcore_spi_of_match_table[] = {
-	{ .compatible = "ti,wl1271", .data = &wl12xx_data},
-	{ .compatible = "ti,wl1273", .data = &wl12xx_data},
-	{ .compatible = "ti,wl1281", .data = &wl12xx_data},
-	{ .compatible = "ti,wl1283", .data = &wl12xx_data},
+	{ .compatible = "ti,wl1271", .data = &wl127x_data},
+	{ .compatible = "ti,wl1273", .data = &wl127x_data},
+	{ .compatible = "ti,wl1281", .data = &wl128x_data},
+	{ .compatible = "ti,wl1283", .data = &wl128x_data},
 	{ .compatible = "ti,wl1801", .data = &wl18xx_data},
 	{ .compatible = "ti,wl1805", .data = &wl18xx_data},
 	{ .compatible = "ti,wl1807", .data = &wl18xx_data},
@@ -456,9 +460,9 @@ static int wlcore_probe_of(struct spi_device *spi, struct wl12xx_spi_glue *glue,
 	if (!of_id)
 		return -ENODEV;
 
-	wilink_data = of_id->data;
+	pdev_data->family = of_id->data;
 	dev_info(&spi->dev, "selected chip family is %s\n",
-		 wilink_data->name);
+		 pdev_data->family->name);
 
 	if (of_find_property(dt_node, "clock-xtal", NULL))
 		pdev_data->ref_clock_xtal = true;
@@ -475,13 +479,15 @@ static int wlcore_probe_of(struct spi_device *spi, struct wl12xx_spi_glue *glue,
 static int wl1271_probe(struct spi_device *spi)
 {
 	struct wl12xx_spi_glue *glue;
-	struct wlcore_platdev_data pdev_data;
+	struct wlcore_platdev_data *pdev_data;
 	struct resource res[1];
 	int ret;
 
-	memset(&pdev_data, 0x00, sizeof(pdev_data));
+	pdev_data = devm_kzalloc(&spi->dev, sizeof(*pdev_data), GFP_KERNEL);
+	if (!pdev_data)
+		return -ENOMEM;
 
-	pdev_data.if_ops = &spi_ops;
+	pdev_data->if_ops = &spi_ops;
 
 	glue = devm_kzalloc(&spi->dev, sizeof(*glue), GFP_KERNEL);
 	if (!glue) {
@@ -505,7 +511,7 @@ static int wl1271_probe(struct spi_device *spi)
 		return PTR_ERR(glue->reg);
 	}
 
-	ret = wlcore_probe_of(spi, glue, &pdev_data);
+	ret = wlcore_probe_of(spi, glue, pdev_data);
 	if (ret) {
 		dev_err(glue->dev,
 			"can't get device tree parameters (%d)\n", ret);
@@ -518,7 +524,7 @@ static int wl1271_probe(struct spi_device *spi)
 		return ret;
 	}
 
-	glue->core = platform_device_alloc(wilink_data->name,
+	glue->core = platform_device_alloc(pdev_data->family->name,
 					   PLATFORM_DEVID_AUTO);
 	if (!glue->core) {
 		dev_err(glue->dev, "can't allocate platform_device\n");
@@ -539,8 +545,8 @@ static int wl1271_probe(struct spi_device *spi)
 		goto out_dev_put;
 	}
 
-	ret = platform_device_add_data(glue->core, &pdev_data,
-				       sizeof(pdev_data));
+	ret = platform_device_add_data(glue->core, pdev_data,
+				       sizeof(*pdev_data));
 	if (ret) {
 		dev_err(glue->dev, "can't add platform data\n");
 		goto out_dev_put;
-- 
2.9.3
