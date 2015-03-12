Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:33122 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754227AbbCLMJj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2015 08:09:39 -0400
Received: by widfb4 with SMTP id fb4so3367036wid.0
        for <linux-wireless@vger.kernel.org>; Thu, 12 Mar 2015 05:09:38 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: <linux-wireless@vger.kernel.org>, <devicetree@vger.kernel.org>,
	<linux-omap@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>,
	=?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>,
	Tony Lindgren <tony@atomide.com>,
	Enric Balletbo i Serra <eballetbo@gmail.com>,
	Javier Martinez Canillas <javier@dowhile0.org>,
	Sekhar Nori <nsekhar@ti.com>,
	Kevin Hilman <khilman@deeprootsystems.com>,
	Ido Yariv <ido@wizery.com>
Subject: [PATCH v6 4/6] wlcore: add device-tree support
Date: Thu, 12 Mar 2015 14:09:12 +0200
Message-Id: <1426162154-8716-5-git-send-email-eliad@wizery.com> (sfid-20150312_130951_242943_334C65F8)
In-Reply-To: <1426162154-8716-1-git-send-email-eliad@wizery.com>
References: <1426162154-8716-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When running with device-tree, we no longer have a board file
that can set up the platform data for wlcore.
Allow this data to be passed from DT.

Signed-off-by: Ido Yariv <ido@wizery.com>
Signed-off-by: Eliad Peller <eliad@wizery.com>
---
v6: parse frequency properties, add wl12xx compatible strings

 drivers/net/wireless/ti/wlcore/sdio.c | 93 ++++++++++++++++++++++++++++++++---
 1 file changed, 87 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/sdio.c b/drivers/net/wireless/ti/wlcore/sdio.c
index 2bce00a..b55dc0e 100644
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
@@ -214,6 +216,82 @@ static struct wl1271_if_operations sdio_ops = {
 	.set_block_size = wl1271_sdio_set_block_size,
 };
 
+#ifdef CONFIG_OF
+static const struct of_device_id wlcore_sdio_of_match_table[] = {
+	{ .compatible = "ti,wl1271" },
+	{ .compatible = "ti,wl1273" },
+	{ .compatible = "ti,wl1281" },
+	{ .compatible = "ti,wl1283" },
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
+	pdata->irq_trigger =
+		irqd_get_trigger_type(irq_get_irq_data(pdata->irq));
+
+	/* optional clock frequency params */
+	of_property_read_u32(np, "ref-clock-frequency",
+			     &pdata->ref_clock_freq);
+	of_property_read_u32(np, "tcxo-clock-frequency",
+			     &pdata->tcxo_clock_freq);
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
@@ -245,12 +323,9 @@ static int wl1271_probe(struct sdio_func *func,
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
@@ -279,7 +354,7 @@ static int wl1271_probe(struct sdio_func *func,
 	if (!glue->core) {
 		dev_err(glue->dev, "can't allocate platform_device");
 		ret = -ENOMEM;
-		goto out_free_glue;
+		goto out_free_pdata;
 	}
 
 	glue->core->dev.parent = &func->dev;
@@ -313,6 +388,9 @@ static int wl1271_probe(struct sdio_func *func,
 out_dev_put:
 	platform_device_put(glue->core);
 
+out_free_pdata:
+	wlcore_del_platform_data(pdev_data.pdata);
+
 out_free_glue:
 	kfree(glue);
 
@@ -323,11 +401,14 @@ out:
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

