Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:44274 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752623AbbCHN22 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Mar 2015 09:28:28 -0400
Received: by wghl18 with SMTP id l18so15309541wgh.11
        for <linux-wireless@vger.kernel.org>; Sun, 08 Mar 2015 06:28:26 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: <linux-wireless@vger.kernel.org>, <devicetree@vger.kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Ido Yariv <ido@wizery.com>
Subject: [PATCH v4 2/2] wl18xx: add basic device-tree support
Date: Sun,  8 Mar 2015 15:28:17 +0200
Message-Id: <1425821297-3134-2-git-send-email-eliad@wizery.com> (sfid-20150308_142837_505209_5EBEC9F8)
In-Reply-To: <1425821297-3134-1-git-send-email-eliad@wizery.com>
References: <1425821297-3134-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When running with device-tree, we no longer have a board file
that can set up the platform data for wlcore.
Allow this data to be passed from DT.

For now, parse only the irq used. Other (optional) properties
can be added later on.

Signed-off-by: Ido Yariv <ido@wizery.com>
Signed-off-by: Eliad Peller <eliad@wizery.com>
---
v4: use specific models, look for DT first (Arnd)

 drivers/net/wireless/ti/wlcore/sdio.c | 80 ++++++++++++++++++++++++++++++++---
 1 file changed, 74 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/sdio.c b/drivers/net/wireless/ti/wlcore/sdio.c
index d3dd7bf..ee556ac 100644
--- a/drivers/net/wireless/ti/wlcore/sdio.c
+++ b/drivers/net/wireless/ti/wlcore/sdio.c
@@ -34,6 +34,8 @@
 #include <linux/wl12xx.h>
 #include <linux/pm_runtime.h>
 #include <linux/printk.h>
+#include <linux/of.h>
+#include <linux/of_irq.h>
 
 #include "wlcore.h"
 #include "wl12xx_80211.h"
@@ -214,6 +216,69 @@ static struct wl1271_if_operations sdio_ops = {
 	.set_block_size = wl1271_sdio_set_block_size,
 };
 
+#ifdef CONFIG_OF
+static const struct of_device_id wlcore_sdio_of_match_table[] = {
+	{ .compatible = "ti,wl1801" },
+	{ .compatible = "ti,wl1805" },
+	{ .compatible = "ti,wl1807" },
+	{ .compatible = "ti,wl1831" },
+	{ .compatible = "ti,wl1835" },
+	{ .compatible = "ti,wl1837" },
+	{ }
+};
+
+static struct wl12xx_platform_data *wlcore_probe_of(struct device *dev)
+{
+	struct device_node *np = dev->of_node;
+	struct wl12xx_platform_data *pdata;
+
+	if (!np || !of_match_node(wlcore_sdio_of_match_table, np))
+		return NULL;
+
+	pdata = kzalloc(sizeof(*pdata), GFP_KERNEL);
+	if (!pdata)
+		return NULL;
+
+	pdata->irq = irq_of_parse_and_map(np, 0);
+	if (!pdata->irq) {
+		dev_err(dev, "No irq in platform data\n");
+		kfree(pdata);
+		return NULL;
+	}
+
+	return pdata;
+}
+#else
+static struct wl12xx_platform_data *wlcore_probe_of(struct device *dev)
+{
+	return NULL;
+}
+#endif
+
+static struct wl12xx_platform_data *
+wlcore_get_platform_data(struct device *dev)
+{
+	struct wl12xx_platform_data *pdata;
+
+	/* first, look for DT data */
+	pdata = wlcore_probe_of(dev);
+	if (pdata)
+		return pdata;
+
+	/* if not found - fallback to static platform data */
+	pdata = wl12xx_get_platform_data();
+	if (!IS_ERR(pdata))
+		return kmemdup(pdata, sizeof(*pdata), GFP_KERNEL);
+
+	dev_err(dev, "No platform data set\n");
+	return NULL;
+}
+
+static void wlcore_del_platform_data(struct wl12xx_platform_data *pdata)
+{
+	kfree(pdata);
+}
+
 static int wl1271_probe(struct sdio_func *func,
 				  const struct sdio_device_id *id)
 {
@@ -245,12 +310,9 @@ static int wl1271_probe(struct sdio_func *func,
 	/* Use block mode for transferring over one block size of data */
 	func->card->quirks |= MMC_QUIRK_BLKSZ_FOR_BYTE_MODE;
 
-	pdev_data.pdata = wl12xx_get_platform_data();
-	if (IS_ERR(pdev_data.pdata)) {
-		ret = PTR_ERR(pdev_data.pdata);
-		dev_err(glue->dev, "missing wlan platform data: %d\n", ret);
+	pdev_data.pdata = wlcore_get_platform_data(&func->dev);
+	if (!pdev_data.pdata)
 		goto out_free_glue;
-	}
 
 	/* if sdio can keep power while host is suspended, enable wow */
 	mmcflags = sdio_get_host_pm_caps(func);
@@ -279,7 +341,7 @@ static int wl1271_probe(struct sdio_func *func,
 	if (!glue->core) {
 		dev_err(glue->dev, "can't allocate platform_device");
 		ret = -ENOMEM;
-		goto out_free_glue;
+		goto out_free_pdata;
 	}
 
 	glue->core->dev.parent = &func->dev;
@@ -313,6 +375,9 @@ static int wl1271_probe(struct sdio_func *func,
 out_dev_put:
 	platform_device_put(glue->core);
 
+out_free_pdata:
+	wlcore_del_platform_data(pdev_data.pdata);
+
 out_free_glue:
 	kfree(glue);
 
@@ -323,11 +388,14 @@ out:
 static void wl1271_remove(struct sdio_func *func)
 {
 	struct wl12xx_sdio_glue *glue = sdio_get_drvdata(func);
+	struct wlcore_platdev_data *pdev_data = glue->core->dev.platform_data;
+	struct wl12xx_platform_data *pdata = pdev_data->pdata;
 
 	/* Undo decrement done above in wl1271_probe */
 	pm_runtime_get_noresume(&func->dev);
 
 	platform_device_unregister(glue->core);
+	wlcore_del_platform_data(pdata);
 	kfree(glue);
 }
 
-- 
1.8.5.2.229.g4448466.dirty

