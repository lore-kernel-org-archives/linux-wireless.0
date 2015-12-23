Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from softlayer.compulab.co.il ([50.23.254.55]:59230 "EHLO
	compulab.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755735AbbLWIfx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Dec 2015 03:35:53 -0500
From: Uri Mashiach <uri.mashiach@compulab.co.il>
To: Kalle Valo <kvalo@codeaurora.org>,
	Rob Herring <robh+dt@kernel.org>,
	Tony Lindgren <tony@atomide.com>
Cc: Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>, bcousson@baylibre.com,
	Igor Grinberg <grinberg@compulab.co.il>,
	Eliad Peller <eliad@wizery.com>, devicetree@vger.kernel.org,
	linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	Uri Mashiach <uri.mashiach@compulab.co.il>
Subject: [PATCH 2/3] wlcore/wl12xx: spi: add device tree support
Date: Wed, 23 Dec 2015 10:35:43 +0200
Message-Id: <1450859744-9948-3-git-send-email-uri.mashiach@compulab.co.il> (sfid-20151223_093622_673590_F3739D23)
In-Reply-To: <1450859744-9948-1-git-send-email-uri.mashiach@compulab.co.il>
References: <1450859744-9948-1-git-send-email-uri.mashiach@compulab.co.il>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add DT support for the wl1271 SPI WiFi.

Add documentation file for the wl1271 SPI WiFi.

Signed-off-by: Uri Mashiach <uri.mashiach@compulab.co.il>
Acked-by: Igor Grinberg <grinberg@compulab.co.il>
---
 .../bindings/net/wireless/ti,wlcore,spi.txt        | 35 +++++++++++
 drivers/net/wireless/ti/wlcore/spi.c               | 67 +++++++++++++++++++---
 2 files changed, 95 insertions(+), 7 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/wireless/ti,wlcore,spi.txt

diff --git a/Documentation/devicetree/bindings/net/wireless/ti,wlcore,spi.txt b/Documentation/devicetree/bindings/net/wireless/ti,wlcore,spi.txt
new file mode 100644
index 0000000..a3e7eb7
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/wireless/ti,wlcore,spi.txt
@@ -0,0 +1,35 @@
+* Texas Instruments wl1271 wireless lan controller
+
+The wl1271 chip can be connected via SPI or via SDIO. This
+document describes the binding for the SPI connected chip.
+
+Required properties:
+- compatible :          Should be "ti,wl1271"
+- reg :                 Chip select address of device
+- spi-max-frequency :   Maximum SPI clocking speed of device in Hz
+- ref-clock-frequency : Reference clock frequency
+- interrupts :          Should contain interrupt line and trigger type
+- interrupt-parent :    Should be the phandle for the interrupt controller
+                        that services interrupts for this device
+- vwlan-supply :        Point the node of the regulator that controls the wl1271 chip WLAN_EN pin
+
+Optional properties:
+- clock-xtal :          boolean, clock is generated from XTAL
+
+- Please consult Documentation/devicetree/bindings/spi/spi-bus.txt
+  for optional SPI connection related properties,
+
+Examples:
+
+&spi1 {
+	wl1271@1 {
+		compatible = "ti,wl1271";
+
+		reg = <1>;
+		spi-max-frequency = <48000000>;
+		clock-xtal;
+		interrupt-parent = <&gpio3>;
+		interrupts = <8 IRQ_TYPE_LEVEL_HIGH>;
+		wifi-supply = <&wifi_fixed>;
+	};
+};
diff --git a/drivers/net/wireless/ti/wlcore/spi.c b/drivers/net/wireless/ti/wlcore/spi.c
index d3a4bcb..7281f5a 100644
--- a/drivers/net/wireless/ti/wlcore/spi.c
+++ b/drivers/net/wireless/ti/wlcore/spi.c
@@ -30,6 +30,7 @@
 #include <linux/spi/spi.h>
 #include <linux/wl12xx.h>
 #include <linux/platform_device.h>
+#include <linux/of_irq.h>
 #include <linux/regulator/consumer.h>
 
 #include "wlcore.h"
@@ -357,6 +358,54 @@ static struct wl1271_if_operations spi_ops = {
 	.set_block_size = NULL,
 };
 
+#ifdef CONFIG_OF
+static const struct of_device_id wlcore_spi_of_match_table[] = {
+	{ .compatible = "ti,wl1271" },
+	{ }
+};
+
+/**
+ * wlcore_probe_of - DT node parsing.
+ * @spi: SPI slave device parameters.
+ * @res: resource parameters.
+ * @glue: wl12xx SPI bus to slave device glue parameters.
+ * @pdev_data: wlcore device parameters
+ */
+static int wlcore_probe_of(struct spi_device *spi, struct resource *res,
+			   struct wl12xx_spi_glue *glue,
+			   struct wlcore_platdev_data *pdev_data)
+{
+	struct device_node *dt_node = spi->dev.of_node;
+	int ret;
+
+	ret = of_irq_to_resource(dt_node, 0, &res[0]);
+	if (spi->irq != ret) {
+		dev_err(glue->dev, "can't get interrupt resource\n");
+		return -EINVAL;
+	}
+
+	if (of_find_property(dt_node, "clock-xtal", NULL))
+		pdev_data->ref_clock_xtal = true;
+
+	ret = of_property_read_u32(dt_node, "ref-clock-frequency",
+				   &pdev_data->ref_clock_freq);
+	if (IS_ERR_VALUE(ret)) {
+		dev_err(glue->dev,
+			"can't get reference clock frequency (%d)\n", ret);
+		return ret;
+	}
+
+	return 0;
+}
+#else /* CONFIG_OF */
+static int wlcore_probe_of(struct spi_device *spi, struct resource *res,
+			   struct wl12xx_spi_glue *glue,
+			   struct wlcore_platdev_data *pdev_data)
+{
+	return -ENODATA;
+}
+#endif /* CONFIG_OF */
+
 static int wl1271_probe(struct spi_device *spi)
 {
 	struct wl12xx_spi_glue *glue;
@@ -365,8 +414,7 @@ static int wl1271_probe(struct spi_device *spi)
 	int ret;
 
 	memset(&pdev_data, 0x00, sizeof(pdev_data));
-
-	/* TODO: add DT parsing when needed */
+	memset(res, 0x00, sizeof(res));
 
 	pdev_data.if_ops = &spi_ops;
 
@@ -390,6 +438,13 @@ static int wl1271_probe(struct spi_device *spi)
 		return PTR_ERR(glue->reg);
 	}
 
+	ret = wlcore_probe_of(spi, &res[0], glue, &pdev_data);
+	if (IS_ERR_VALUE(ret)) {
+		dev_err(glue->dev,
+			"can't get device tree parameters (%d)\n", ret);
+		return ret;
+	}
+
 	ret = spi_setup(spi);
 	if (ret < 0) {
 		dev_err(glue->dev, "spi_setup failed\n");
@@ -404,10 +459,6 @@ static int wl1271_probe(struct spi_device *spi)
 
 	glue->core->dev.parent = &spi->dev;
 
-	memset(res, 0x00, sizeof(res));
-
-	res[0].start = spi->irq;
-	res[0].flags = IORESOURCE_IRQ;
 	res[0].name = "irq";
 
 	ret = platform_device_add_resources(glue->core, res, ARRAY_SIZE(res));
@@ -445,10 +496,12 @@ static int wl1271_remove(struct spi_device *spi)
 	return 0;
 }
 
-
 static struct spi_driver wl1271_spi_driver = {
 	.driver = {
 		.name		= "wl1271_spi",
+#ifdef CONFIG_OF
+		.of_match_table = of_match_ptr(wlcore_spi_of_match_table),
+#endif /* CONFIG_OF */
 	},
 
 	.probe		= wl1271_probe,
-- 
2.5.0

