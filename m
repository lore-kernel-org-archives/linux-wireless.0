Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from softlayer.compulab.co.il ([50.23.254.55]:40945 "EHLO
	compulab.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754817AbbL3NgF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Dec 2015 08:36:05 -0500
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
Subject: [PATCH v4 2/3] wlcore/wl12xx: spi: add device tree support
Date: Wed, 30 Dec 2015 15:35:32 +0200
Message-Id: <1451482533-8624-3-git-send-email-uri.mashiach@compulab.co.il> (sfid-20151230_143624_582689_54BE1703)
In-Reply-To: <1451482533-8624-1-git-send-email-uri.mashiach@compulab.co.il>
References: <1451482533-8624-1-git-send-email-uri.mashiach@compulab.co.il>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add DT support for the wl1271 SPI WiFi.

Add documentation file for the wl1271 SPI WiFi.

Signed-off-by: Uri Mashiach <uri.mashiach@compulab.co.il>
Acked-by: Rob Herring <robh@kernel.org>
---
v1 -> v2: update interrupt documentation.
          replace interrupts and interrupt-parent with interrupts-extended.
	  IRQ parameters retrieved from spi_device instead of DT.
	  remove redundant #ifdef CONFIG_OF
v2 -> v3: Add MODULE_DEVICE_TABLE.
          Remove #ifdef CONFIG_OF.
	  Make the Kconfig symbol to depend on OF.
	  Replace irqd_get_trigger_type() with irq_get_trigger_type().
v3 -> v4: replace interrupts-extended with interrupts and interrupt-parent. (revert v2 modification).
          According to Rob Herring and Documentation/devicetree/bindings/interrupt-controller/interrupts.txt,
	  interrupts-extended should only be used when a device has multiple interrupt parents.

 .../bindings/net/wireless/ti,wlcore,spi.txt        | 36 +++++++++++++++++
 drivers/net/wireless/ti/wlcore/Kconfig             |  2 +-
 drivers/net/wireless/ti/wlcore/spi.c               | 47 ++++++++++++++++++++--
 3 files changed, 80 insertions(+), 5 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/wireless/ti,wlcore,spi.txt

diff --git a/Documentation/devicetree/bindings/net/wireless/ti,wlcore,spi.txt b/Documentation/devicetree/bindings/net/wireless/ti,wlcore,spi.txt
new file mode 100644
index 0000000..9180724
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/wireless/ti,wlcore,spi.txt
@@ -0,0 +1,36 @@
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
+- interrupt-parent, interrupts :
+                        Should contain parameters for 1 interrupt line.
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
+		interrupt-parent = <&gpio3>;
+		interrupts = <8 IRQ_TYPE_LEVEL_HIGH>;
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
index dec1512..020ac1a 100644
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
@@ -392,6 +424,13 @@ static int wl1271_probe(struct spi_device *spi)
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
@@ -409,7 +448,7 @@ static int wl1271_probe(struct spi_device *spi)
 	memset(res, 0x00, sizeof(res));
 
 	res[0].start = spi->irq;
-	res[0].flags = IORESOURCE_IRQ;
+	res[0].flags = IORESOURCE_IRQ | irq_get_trigger_type(spi->irq);
 	res[0].name = "irq";
 
 	ret = platform_device_add_resources(glue->core, res, ARRAY_SIZE(res));
@@ -447,10 +486,10 @@ static int wl1271_remove(struct spi_device *spi)
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

