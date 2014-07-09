Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:33555 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753786AbaGIJb4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jul 2014 05:31:56 -0400
Received: by mail-wg0-f50.google.com with SMTP id n12so213782wgh.9
        for <linux-wireless@vger.kernel.org>; Wed, 09 Jul 2014 02:31:55 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: <linux-wireless@vger.kernel.org>, <devicetree@vger.kernel.org>
Subject: [PATCH] wlcore: add basic device-tree support
Date: Wed,  9 Jul 2014 12:31:45 +0300
Message-Id: <1404898305-15588-1-git-send-email-eliad@wizery.com> (sfid-20140709_113204_252898_03460BDD)
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
 .../devicetree/bindings/net/wireless/ti,wlcore.txt | 31 ++++++++++
 drivers/net/wireless/ti/wlcore/sdio.c              | 67 ++++++++++++++++++++--
 2 files changed, 92 insertions(+), 6 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/wireless/ti,wlcore.txt

diff --git a/Documentation/devicetree/bindings/net/wireless/ti,wlcore.txt b/Documentation/devicetree/bindings/net/wireless/ti,wlcore.txt
new file mode 100644
index 0000000..df9af48
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/wireless/ti,wlcore.txt
@@ -0,0 +1,31 @@
+TI Wilink (wlcore) SDIO devices
+
+This node provides properties for controlling the wilink wireless device. The
+node is expected to be specified as a child node to the SDIO controller that
+connects the device to the system.
+
+Required properties:
+
+ - compatible : Should be "ti,wlcore".
+ - interrupt-parent : the phandle for the interrupt controller to which the
+	device interrupts are connected.
+ - interrupts : specifies attributes for the out-of-band interrupt.
+
+Example:
+
+&mmc3 {
+	status = "okay";
+	vmmc-supply = <&wlan_en_reg>;
+	bus-width = <4>;
+	cap-power-off-card;
+	keep-power-in-suspend;
+
+	#address-cells = <1>;
+	#size-cells = <0>;
+	wlcore: wlcore@0 {
+		compatible = "ti,wlcore";
+		reg = <2>;
+		interrupt-parent = <&gpio0>;
+		interrupts = <19 IRQ_TYPE_NONE>;
+	};
+};
diff --git a/drivers/net/wireless/ti/wlcore/sdio.c b/drivers/net/wireless/ti/wlcore/sdio.c
index d3dd7bf..8e1e1a6 100644
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
@@ -214,6 +216,56 @@ static struct wl1271_if_operations sdio_ops = {
 	.set_block_size = wl1271_sdio_set_block_size,
 };
 
+#ifdef CONFIG_OF
+static struct wl12xx_platform_data *wlcore_probe_of(struct device *dev)
+{
+	struct device_node *np = dev->of_node;
+	struct wl12xx_platform_data *pdata;
+
+	if (!np || !of_device_is_compatible(np, "ti,wlcore")) {
+		dev_err(dev, "No platform data set\n");
+		return NULL;
+	}
+
+	pdata = kzalloc(sizeof(*pdata), GFP_KERNEL);
+	if (!pdata) {
+		dev_err(dev, "Can't allocate platform data\n");
+		return NULL;
+	}
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
+	pdata = wl12xx_get_platform_data();
+	if (!IS_ERR(pdata))
+		return kmemdup(pdata, sizeof(*pdata), GFP_KERNEL);
+
+	return wlcore_probe_of(dev);
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
@@ -245,12 +297,9 @@ static int wl1271_probe(struct sdio_func *func,
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
@@ -279,7 +328,7 @@ static int wl1271_probe(struct sdio_func *func,
 	if (!glue->core) {
 		dev_err(glue->dev, "can't allocate platform_device");
 		ret = -ENOMEM;
-		goto out_free_glue;
+		goto out_free_pdata;
 	}
 
 	glue->core->dev.parent = &func->dev;
@@ -313,6 +362,9 @@ static int wl1271_probe(struct sdio_func *func,
 out_dev_put:
 	platform_device_put(glue->core);
 
+out_free_pdata:
+	wlcore_del_platform_data(pdev_data.pdata);
+
 out_free_glue:
 	kfree(glue);
 
@@ -323,11 +375,14 @@ out:
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

