Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from softlayer.compulab.co.il ([50.23.254.55]:36084 "EHLO
	compulab.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751719AbbL1MDK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Dec 2015 07:03:10 -0500
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
Subject: [PATCH v3 2/3] wlcore/wl12xx: spi: add device tree support
Date: Mon, 28 Dec 2015 14:02:18 +0200
Message-Id: <1451304139-10899-3-git-send-email-uri.mashiach@compulab.co.il> (sfid-20151228_130315_622386_704EC9F7)
In-Reply-To: <1451304139-10899-1-git-send-email-uri.mashiach@compulab.co.il>
References: <1451304139-10899-1-git-send-email-uri.mashiach@compulab.co.il>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add DT support for the wl1271 SPI WiFi.

Add documentation file for the wl1271 SPI WiFi.

Signed-off-by: Uri Mashiach <uri.mashiach@compulab.co.il>
Acked-by: Igor Grinberg <grinberg@compulab.co.il>
---
v1 -> v2: update interrupt documentation.
          replace interrupts and interrupt-parent with interrupts-extended.
	  IRQ parameters retrieved from spi_device instead of DT.
	  remove redundant #ifdef CONFIG_OF
v2 -> v3: Add MODULE_DEVICE_TABLE.
          Remove #ifdef CONFIG_OF.
	  Make the Kconfig symbol to depend on OF.
	  Replace irqd_get_trigger_type() with irq_get_trigger_type().

 .../bindings/net/wireless/ti,wlcore,spi.txt        | 34 ++++++++++++++++
 drivers/net/wireless/ti/wlcore/Kconfig             |  2 +-
 drivers/net/wireless/ti/wlcore/spi.c               | 47 ++++++++++++++++++++--
 3 files changed, 78 insertions(+), 5 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/wireless/ti,wlcore,spi.txt

diff --git a/Documentation/devicetree/bindings/net/wireless/ti,wlcore,spi.txt b/Documentation/devicetree/bindings/net/wireless/ti,wlcore,spi.txt
new file mode 100644
index 0000000..502c27e
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/wireless/ti,wlcore,spi.txt
@@ -0,0 +1,34 @@
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
+- interrupts-extended : Should contain parameters for 1 interrupt line.
+                        Interrupt parameters: parent, line number, type.
+- vwlan-supply :        Point the node of the regulator that powers/enable the wl1271 chip
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
+		ref-clock-frequency = <38400000>;
+		interrupts-extended = <&gpio3 8 IRQ_TYPE_LEVEL_HIGH>;
+		vwlan-supply = <&vwlan_fixed>;
+	};
+};
diff --git a/drivers/net/wireless/ti/wlcore/Kconfig b/drivers/net/wireless/ti/wlcore/Kconfig
index 7c09954..5918080 100644
--- a/drivers/net/wireless/ti/wlcore/Kconfig
+++ b/drivers/net/wireless/ti/wlcore/Kconfig
@@ -13,7 +13,7 @@ config WLCORE
 
 config WLCORE_SPI
 	tristate "TI wlcore SPI support"
-	depends on WLCORE && SPI_MASTER
+	depends on WLCORE && SPI_MASTER && OF
 	select CRC7
 	---help---
 	  This module adds support for the SPI interface of adapters using
diff --git a/drivers/net/wireless/ti/wlcore/spi.c b/drivers/net/wireless/ti/wlcore/spi.c
index d3a4bcb..0f2fb50 100644
--- a/drivers/net/wireless/ti/wlcore/spi.c
+++ b/drivers/net/wireless/ti/wlcore/spi.c
@@ -30,6 +30,7 @@
 #include <linux/spi/spi.h>
 #include <linux/wl12xx.h>
 #include <linux/platform_device.h>
+#include <linux/of_irq.h>
 #include <linux/regulator/consumer.h>
 
 #include "wlcore.h"
@@ -357,6 +358,39 @@ static struct wl1271_if_operations spi_ops = {
 	.set_block_size = NULL,
 };
 
+static const struct of_device_id wlcore_spi_of_match_table[] = {
+	{ .compatible = "ti,wl1271" },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, wlcore_spi_of_match_table);
+
+/**
+ * wlcore_probe_of - DT node parsing.
+ * @spi: SPI slave device parameters.
+ * @res: resource parameters.
+ * @glue: wl12xx SPI bus to slave device glue parameters.
+ * @pdev_data: wlcore device parameters
+ */
+static int wlcore_probe_of(struct spi_device *spi, struct wl12xx_spi_glue *glue,
+			   struct wlcore_platdev_data *pdev_data)
+{
+	struct device_node *dt_node = spi->dev.of_node;
+	int ret;
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
+
 static int wl1271_probe(struct spi_device *spi)
 {
 	struct wl12xx_spi_glue *glue;
@@ -366,8 +400,6 @@ static int wl1271_probe(struct spi_device *spi)
 
 	memset(&pdev_data, 0x00, sizeof(pdev_data));
 
-	/* TODO: add DT parsing when needed */
-
 	pdev_data.if_ops = &spi_ops;
 
 	glue = devm_kzalloc(&spi->dev, sizeof(*glue), GFP_KERNEL);
@@ -390,6 +422,13 @@ static int wl1271_probe(struct spi_device *spi)
 		return PTR_ERR(glue->reg);
 	}
 
+	ret = wlcore_probe_of(spi, glue, &pdev_data);
+	if (IS_ERR_VALUE(ret)) {
+		dev_err(glue->dev,
+			"can't get device tree parameters (%d)\n", ret);
+		return ret;
+	}
+
 	ret = spi_setup(spi);
 	if (ret < 0) {
 		dev_err(glue->dev, "spi_setup failed\n");
@@ -407,7 +446,7 @@ static int wl1271_probe(struct spi_device *spi)
 	memset(res, 0x00, sizeof(res));
 
 	res[0].start = spi->irq;
-	res[0].flags = IORESOURCE_IRQ;
+	res[0].flags = IORESOURCE_IRQ | irq_get_trigger_type(spi->irq);
 	res[0].name = "irq";
 
 	ret = platform_device_add_resources(glue->core, res, ARRAY_SIZE(res));
@@ -445,10 +484,10 @@ static int wl1271_remove(struct spi_device *spi)
 	return 0;
 }
 
-
 static struct spi_driver wl1271_spi_driver = {
 	.driver = {
 		.name		= "wl1271_spi",
+		.of_match_table = of_match_ptr(wlcore_spi_of_match_table),
 	},
 
 	.probe		= wl1271_probe,
-- 
2.5.0

