Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:33789 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761455AbZAPVeS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jan 2009 16:34:18 -0500
From: Christian Lamparter <chunkeey@web.de>
To: Kalle Valo <kalle.valo@iki.fi>
Subject: [PATCH] p54spi: remove arch specific dependencies
Date: Fri, 16 Jan 2009 22:34:15 +0100
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless" <linux-wireless@vger.kernel.org>
References: <E1LNgyq-0006iZ-0M@sipsolutions.net> <200901161929.30204.chunkeey@web.de> <87k58vxcyw.fsf@litku.valot.fi>
In-Reply-To: <87k58vxcyw.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200901162234.15946.chunkeey@web.de> (sfid-20090116_223435_792090_E880D81C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 16 January 2009 20:33:43 Kalle Valo wrote:
> N800 and N810 support is not on mainline yet, for stlc45xx I decided
> to add module parameters for the gpio numbers. Here's the commit from
> stlc45xx repo:
> 
> http://gitorious.org/projects/stlc45xx/repos/mainline/commits/35afc5df0027d02d49e6f5bf986dcc4deb4ee6cf

This is the same patch for p54spi.
It removes all N800/N810 specific code from p54spi, so the driver can be used on
other architectures, or configurations as well.

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
All in favour with these changes?
---
diff --git a/drivers/net/wireless/p54/p54spi.c b/drivers/net/wireless/p54/p54spi.c
index b8dede7..7fde243 100644
--- a/drivers/net/wireless/p54/p54spi.c
+++ b/drivers/net/wireless/p54/p54spi.c
@@ -39,6 +39,20 @@
 MODULE_FIRMWARE("3826.arm");
 MODULE_ALIAS("stlc45xx");
 
+/*
+ * gpios should be handled in board files and provided via platform data,
+ * but because it's currently impossible for p54spi to have a header file
+ * in include/linux, let's use module paramaters for now
+ */
+
+static int p54spi_gpio_power = 97;
+module_param(p54spi_gpio_power, int, 0444);
+MODULE_PARM_DESC(p54spi_gpio_power, "gpio number for power line");
+
+static int p54spi_gpio_irq = 87;
+module_param(p54spi_gpio_irq, int, 0444);
+MODULE_PARM_DESC(p54spi_gpio_irq, "gpio number for irq line");
+
 static void p54spi_spi_read(struct p54s_priv *priv, u8 address,
 			      void *buf, size_t len)
 {
@@ -283,14 +297,14 @@ static int p54spi_upload_firmware(struct ieee80211_hw *dev)
 
 static void p54spi_power_off(struct p54s_priv *priv)
 {
-	disable_irq(gpio_to_irq(priv->config->irq_gpio));
-	gpio_set_value(priv->config->power_gpio, 0);
+	disable_irq(gpio_to_irq(p54spi_gpio_irq));
+	gpio_set_value(p54spi_gpio_power, 0);
 }
 
 static void p54spi_power_on(struct p54s_priv *priv)
 {
-	gpio_set_value(priv->config->power_gpio, 1);
-	enable_irq(gpio_to_irq(priv->config->irq_gpio));
+	gpio_set_value(p54spi_gpio_power, 1);
+	enable_irq(gpio_to_irq(p54spi_gpio_irq));
 
 	/*
 	 * need to wait a while before device can be accessed, the lenght
@@ -626,9 +640,6 @@ static int __devinit p54spi_probe(struct spi_device *spi)
 	dev_set_drvdata(&spi->dev, priv);
 	priv->spi = spi;
 
-	priv->config = omap_get_config(OMAP_TAG_WLAN_CX3110X,
-				       struct omap_wlan_cx3110x_config);
-
 	spi->bits_per_word = 16;
 	spi->max_speed_hz = 24000000;
 
@@ -638,22 +649,22 @@ static int __devinit p54spi_probe(struct spi_device *spi)
 		goto err_free_common;
 	}
 
-	ret = gpio_request(priv->config->power_gpio, "p54spi power");
+	ret = gpio_request(p54spi_gpio_power, "p54spi power");
 	if (ret < 0) {
 		dev_err(&priv->spi->dev, "power GPIO request failed: %d", ret);
 		goto err_free_common;
 	}
 
-	ret = gpio_request(priv->config->irq_gpio, "p54spi irq");
+	ret = gpio_request(p54spi_gpio_irq, "p54spi irq");
 	if (ret < 0) {
 		dev_err(&priv->spi->dev, "irq GPIO request failed: %d", ret);
 		goto err_free_common;
 	}
 
-	gpio_direction_output(priv->config->power_gpio, 0);
-	gpio_direction_input(priv->config->irq_gpio);
+	gpio_direction_output(p54spi_gpio_power, 0);
+	gpio_direction_input(p54spi_gpio_irq);
 
-	ret = request_irq(OMAP_GPIO_IRQ(priv->config->irq_gpio),
+	ret = request_irq(gpio_to_irq(p54spi_gpio_irq),
 			  p54spi_interrupt, IRQF_DISABLED, "p54spi",
 			  priv->spi);
 	if (ret < 0) {
@@ -661,10 +672,10 @@ static int __devinit p54spi_probe(struct spi_device *spi)
 		goto err_free_common;
 	}
 
-	set_irq_type(gpio_to_irq(priv->config->irq_gpio),
+	set_irq_type(gpio_to_irq(p54spi_gpio_irq),
 		     IRQ_TYPE_EDGE_RISING);
 
-	disable_irq(gpio_to_irq(priv->config->irq_gpio));
+	disable_irq(gpio_to_irq(p54spi_gpio_irq));
 
 	INIT_WORK(&priv->work, p54spi_work);
 	init_completion(&priv->fw_comp);
@@ -705,10 +716,10 @@ static int __devexit p54spi_remove(struct spi_device *spi)
 
 	ieee80211_unregister_hw(priv->hw);
 
-	free_irq(gpio_to_irq(priv->config->irq_gpio), spi);
+	free_irq(gpio_to_irq(p54spi_gpio_irq), spi);
 
-	gpio_free(priv->config->power_gpio);
-	gpio_free(priv->config->irq_gpio);
+	gpio_free(p54spi_gpio_power);
+	gpio_free(p54spi_gpio_irq);
 	release_firmware(priv->firmware);
 
 	mutex_destroy(&priv->mutex);
diff --git a/drivers/net/wireless/p54/p54spi.h b/drivers/net/wireless/p54/p54spi.h
index 5013ebc..7fbe8d8 100644
--- a/drivers/net/wireless/p54/p54spi.h
+++ b/drivers/net/wireless/p54/p54spi.h
@@ -25,7 +25,6 @@
 #include <linux/mutex.h>
 #include <linux/list.h>
 #include <net/mac80211.h>
-#include <mach/board.h>
 
 #include "p54.h"
 
@@ -108,7 +107,6 @@ struct p54s_priv {
 	struct p54_common common;
 	struct ieee80211_hw *hw;
 	struct spi_device *spi;
-	const struct omap_wlan_cx3110x_config *config;
 
 	struct work_struct work;
 

