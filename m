Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 162-17-110-37-static.hfc.comcastbusiness.net ([162.17.110.37]:44229
	"EHLO stuffed.shaftnet.org" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751921Ab3FBNxL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Jun 2013 09:53:11 -0400
From: Solomon Peachy <pizza@shaftnet.org>
To: linux-wireless@vger.kernel.org
Cc: Solomon Peachy <pizza@shaftnet.org>
Subject: [PATCH -next 3/3] cw1200:  Replace use of 'struct resource' with 'int' for GPIO fields.
Date: Sun,  2 Jun 2013 09:53:03 -0400
Message-Id: <1370181183-11424-3-git-send-email-pizza@shaftnet.org> (sfid-20130602_155329_253840_3CFDA451)
In-Reply-To: <1370181183-11424-1-git-send-email-pizza@shaftnet.org>
References: <1370181183-11424-1-git-send-email-pizza@shaftnet.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The only advantage of 'struct resource' is that it lets us assign names
as part of the platform data.  Unfortunately since we are using platform
data, we are already limited to a single instance of each driver,
rendering this moot.

So, replace the struct resources with ints, resulting in cleaner code.

This was based on a suggestion from Arnd Bergmann.

Signed-off-by: Solomon Peachy <pizza@shaftnet.org>
---
 drivers/net/wireless/cw1200/cw1200_sagrad.c   | 49 +++-----------------------
 drivers/net/wireless/cw1200/cw1200_sdio.c     | 50 ++++++++++++---------------
 drivers/net/wireless/cw1200/cw1200_spi.c      | 33 ++++++++----------
 include/linux/platform_data/cw1200_platform.h | 12 +++----
 4 files changed, 47 insertions(+), 97 deletions(-)

diff --git a/drivers/net/wireless/cw1200/cw1200_sagrad.c b/drivers/net/wireless/cw1200/cw1200_sagrad.c
index 14c2a18..3f884ac 100644
--- a/drivers/net/wireless/cw1200/cw1200_sagrad.c
+++ b/drivers/net/wireless/cw1200/cw1200_sagrad.c
@@ -21,29 +21,6 @@ MODULE_LICENSE("GPL");
 /* #define SAGRAD_1091_1098_EVK_SPI */
 
 #ifdef SAGRAD_1091_1098_EVK_SDIO
-#if 0
-static struct resource cw1200_href_resources[] = {
-	{
-		.start = 215,  /* fix me as appropriate */
-		.end = 215,    /* ditto */
-		.flags = IORESOURCE_IO,
-		.name = "cw1200_wlan_reset",
-	},
-	{
-		.start = 216,  /* fix me as appropriate */
-		.end = 216,    /* ditto */
-		.flags = IORESOURCE_IO,
-		.name = "cw1200_wlan_powerup",
-	},
-	{
-		.start = NOMADIK_GPIO_TO_IRQ(216), /* fix me as appropriate */
-		.end = NOMADIK_GPIO_TO_IRQ(216),   /* ditto */
-		.flags = IORESOURCE_IRQ,
-		.name = "cw1200_wlan_irq",
-	},
-};
-#endif
-
 static int cw1200_power_ctrl(const struct cw1200_platform_data_sdio *pdata,
 			     bool enable)
 {
@@ -68,9 +45,9 @@ static struct cw1200_platform_data_sdio cw1200_platform_data = {
 	.ref_clk = 38400,
 	.have_5ghz = false,
 #if 0
-	.reset = &cw1200_href_resources[0],
-	.powerup = &cw1200_href_resources[1],
-	.irq = &cw1200_href_resources[2],
+	.reset = GPIO_RF_RESET, /* Replace as appropriate */
+	.powerup = GPIO_RF_POWERUP, /* Replace as appropriate */
+	.irq = GPIO_TO_IRQ(GPIO_RF_IRQ), /* Replace as appropriate */
 #endif
 	.power_ctrl = cw1200_power_ctrl,
 	.clk_ctrl = cw1200_clk_ctrl,
@@ -80,22 +57,6 @@ static struct cw1200_platform_data_sdio cw1200_platform_data = {
 #endif
 
 #ifdef SAGRAD_1091_1098_EVK_SPI
-/* Note that this is an example of integrating into your board support file */
-static struct resource cw1200_href_resources[] = {
-	{
-		.start = GPIO_RF_RESET,
-		.end = GPIO_RF_RESET,
-		.flags = IORESOURCE_IO,
-		.name = "cw1200_wlan_reset",
-	},
-	{
-		.start = GPIO_RF_POWERUP,
-		.end = GPIO_RF_POWERUP,
-		.flags = IORESOURCE_IO,
-		.name = "cw1200_wlan_powerup",
-	},
-};
-
 static int cw1200_power_ctrl(const struct cw1200_platform_data_spi *pdata,
 			     bool enable)
 {
@@ -118,8 +79,8 @@ static int cw1200_clk_ctrl(const struct cw1200_platform_data_spi *pdata,
 static struct cw1200_platform_data_spi cw1200_platform_data = {
 	.ref_clk = 38400,
 	.spi_bits_per_word = 16,
-	.reset = &cw1200_href_resources[0],
-	.powerup = &cw1200_href_resources[1],
+	.reset = GPIO_RF_RESET, /* Replace as appropriate */
+	.powerup = GPIO_RF_POWERUP, /* Replace as appropriate */
 	.power_ctrl = cw1200_power_ctrl,
 	.clk_ctrl = cw1200_clk_ctrl,
 /*	.macaddr = ??? */
diff --git a/drivers/net/wireless/cw1200/cw1200_sdio.c b/drivers/net/wireless/cw1200/cw1200_sdio.c
index a725693..e78bb37 100644
--- a/drivers/net/wireless/cw1200/cw1200_sdio.c
+++ b/drivers/net/wireless/cw1200/cw1200_sdio.c
@@ -106,7 +106,6 @@ static irqreturn_t cw1200_gpio_irq(int irq, void *dev_id)
 static int cw1200_request_irq(struct hwbus_priv *self)
 {
 	int ret;
-	const struct resource *irq = self->pdata->irq;
 	u8 cccr;
 
 	cccr = sdio_f0_readb(self->func, SDIO_CCCR_IENx, &ret);
@@ -123,15 +122,15 @@ static int cw1200_request_irq(struct hwbus_priv *self)
 	if (WARN_ON(ret))
 		goto err;
 
-	ret = enable_irq_wake(irq->start);
+	ret = enable_irq_wake(self->pdata->irq);
 	if (WARN_ON(ret))
 		goto err;
 
 	/* Request the IRQ */
-	ret =  request_threaded_irq(irq->start, cw1200_gpio_hardirq,
+	ret =  request_threaded_irq(self->pdata->irq, cw1200_gpio_hardirq,
 				    cw1200_gpio_irq,
 				    IRQF_TRIGGER_HIGH | IRQF_ONESHOT,
-				    irq->name, self);
+				    "cw1200_wlan_irq", self);
 	if (WARN_ON(ret))
 		goto err;
 
@@ -163,8 +162,8 @@ static int cw1200_sdio_irq_unsubscribe(struct hwbus_priv *self)
 	pr_debug("SW IRQ unsubscribe\n");
 
 	if (self->pdata->irq) {
-		disable_irq_wake(self->pdata->irq->start);
-		free_irq(self->pdata->irq->start, self);
+		disable_irq_wake(self->pdata->irq);
+		free_irq(self->pdata->irq, self);
 	} else {
 		sdio_claim_host(self->func);
 		ret = sdio_release_irq(self->func);
@@ -175,12 +174,10 @@ static int cw1200_sdio_irq_unsubscribe(struct hwbus_priv *self)
 
 static int cw1200_sdio_off(const struct cw1200_platform_data_sdio *pdata)
 {
-	const struct resource *reset = pdata->reset;
-
-	if (reset) {
-		gpio_set_value(reset->start, 0);
+	if (pdata->reset) {
+		gpio_set_value(pdata->reset, 0);
 		msleep(30); /* Min is 2 * CLK32K cycles */
-		gpio_free(reset->start);
+		gpio_free(pdata->reset);
 	}
 
 	if (pdata->power_ctrl)
@@ -193,20 +190,17 @@ static int cw1200_sdio_off(const struct cw1200_platform_data_sdio *pdata)
 
 static int cw1200_sdio_on(const struct cw1200_platform_data_sdio *pdata)
 {
-	const struct resource *reset = pdata->reset;
-	const struct resource *powerup = pdata->powerup;
-
 	/* Ensure I/Os are pulled low */
-	if (reset) {
-		gpio_request(reset->start, reset->name);
-		gpio_direction_output(reset->start, 0);
+	if (pdata->reset) {
+		gpio_request(pdata->reset, "cw1200_wlan_reset");
+		gpio_direction_output(pdata->reset, 0);
 	}
-	if (powerup) {
-		gpio_request(powerup->start, powerup->name);
-		gpio_direction_output(powerup->start, 0);
+	if (pdata->powerup) {
+		gpio_request(pdata->powerup, "cw1200_wlan_powerup");
+		gpio_direction_output(pdata->powerup, 0);
 	}
-	if (reset || powerup)
-		msleep(50); /* Settle time */
+	if (pdata->reset || pdata->powerup)
+		msleep(10); /* Settle time? */
 
 	/* Enable 3v3 and 1v8 to hardware */
 	if (pdata->power_ctrl) {
@@ -226,13 +220,13 @@ static int cw1200_sdio_on(const struct cw1200_platform_data_sdio *pdata)
 	}
 
 	/* Enable POWERUP signal */
-	if (powerup) {
-		gpio_set_value(powerup->start, 1);
+	if (pdata->powerup) {
+		gpio_set_value(pdata->powerup, 1);
 		msleep(250); /* or more..? */
 	}
 	/* Enable RSTn signal */
-	if (reset) {
-		gpio_set_value(reset->start, 1);
+	if (pdata->reset) {
+		gpio_set_value(pdata->reset, 1);
 		msleep(50); /* Or more..? */
 	}
 	return 0;
@@ -253,7 +247,7 @@ static int cw1200_sdio_pm(struct hwbus_priv *self, bool suspend)
 	int ret = 0;
 
 	if (self->pdata->irq)
-		ret = irq_set_irq_wake(self->pdata->irq->start, suspend);
+		ret = irq_set_irq_wake(self->pdata->irq, suspend);
 	return ret;
 }
 
@@ -275,7 +269,7 @@ static int cw1200_sdio_probe(struct sdio_func *func,
 
 	pr_info("cw1200_wlan_sdio: Probe called\n");
 
-       /* We are only able to handle the wlan function */
+	/* We are only able to handle the wlan function */
 	if (func->num != 0x01)
 		return -ENODEV;
 
diff --git a/drivers/net/wireless/cw1200/cw1200_spi.c b/drivers/net/wireless/cw1200/cw1200_spi.c
index c4ddee8..5eacf9e 100644
--- a/drivers/net/wireless/cw1200/cw1200_spi.c
+++ b/drivers/net/wireless/cw1200/cw1200_spi.c
@@ -267,12 +267,10 @@ static int cw1200_spi_irq_unsubscribe(struct hwbus_priv *self)
 
 static int cw1200_spi_off(const struct cw1200_platform_data_spi *pdata)
 {
-	const struct resource *reset = pdata->reset;
-
-	if (reset) {
-		gpio_set_value(reset->start, 0);
+	if (pdata->reset) {
+		gpio_set_value(pdata->reset, 0);
 		msleep(30); /* Min is 2 * CLK32K cycles */
-		gpio_free(reset->start);
+		gpio_free(pdata->reset);
 	}
 
 	if (pdata->power_ctrl)
@@ -285,19 +283,16 @@ static int cw1200_spi_off(const struct cw1200_platform_data_spi *pdata)
 
 static int cw1200_spi_on(const struct cw1200_platform_data_spi *pdata)
 {
-	const struct resource *reset = pdata->reset;
-	const struct resource *powerup = pdata->powerup;
-
 	/* Ensure I/Os are pulled low */
-	if (reset) {
-		gpio_request(reset->start, reset->name);
-		gpio_direction_output(reset->start, 0);
+	if (pdata->reset) {
+		gpio_request(pdata->reset, "cw1200_wlan_reset");
+		gpio_direction_output(pdata->reset, 0);
 	}
-	if (powerup) {
-		gpio_request(powerup->start, powerup->name);
-		gpio_direction_output(powerup->start, 0);
+	if (pdata->powerup) {
+		gpio_request(pdata->powerup, "cw1200_wlan_powerup");
+		gpio_direction_output(pdata->powerup, 0);
 	}
-	if (reset || powerup)
+	if (pdata->reset || pdata->powerup)
 		msleep(10); /* Settle time? */
 
 	/* Enable 3v3 and 1v8 to hardware */
@@ -318,13 +313,13 @@ static int cw1200_spi_on(const struct cw1200_platform_data_spi *pdata)
 	}
 
 	/* Enable POWERUP signal */
-	if (powerup) {
-		gpio_set_value(powerup->start, 1);
+	if (pdata->powerup) {
+		gpio_set_value(pdata->powerup, 1);
 		msleep(250); /* or more..? */
 	}
 	/* Enable RSTn signal */
-	if (reset) {
-		gpio_set_value(reset->start, 1);
+	if (pdata->reset) {
+		gpio_set_value(pdata->reset, 1);
 		msleep(50); /* Or more..? */
 	}
 	return 0;
diff --git a/include/linux/platform_data/cw1200_platform.h b/include/linux/platform_data/cw1200_platform.h
index c168fa5..4454c16 100644
--- a/include/linux/platform_data/cw1200_platform.h
+++ b/include/linux/platform_data/cw1200_platform.h
@@ -14,8 +14,8 @@ struct cw1200_platform_data_spi {
 
 	/* All others are optional */
 	bool have_5ghz;
-	const struct resource *reset;   /* GPIO to RSTn signal */
-	const struct resource *powerup; /* GPIO to POWERUP signal */
+	int reset;                     /* GPIO to RSTn signal (0 disables) */
+	int powerup;                   /* GPIO to POWERUP signal (0 disables) */
 	int (*power_ctrl)(const struct cw1200_platform_data_spi *pdata,
 			  bool enable); /* Control 3v3 / 1v8 supply */
 	int (*clk_ctrl)(const struct cw1200_platform_data_spi *pdata,
@@ -28,11 +28,11 @@ struct cw1200_platform_data_sdio {
 	u16 ref_clk;                    /* REQUIRED (in KHz) */
 
 	/* All others are optional */
-	const struct resource *irq;     /* if using GPIO for IRQ */
 	bool have_5ghz;
-	bool no_nptb;                   /* SDIO hardware does not support non-power-of-2-blocksizes */
-	const struct resource *reset;   /* GPIO to RSTn signal */
-	const struct resource *powerup; /* GPIO to POWERUP signal */
+	bool no_nptb;       /* SDIO hardware does not support non-power-of-2-blocksizes */
+	int reset;          /* GPIO to RSTn signal (0 disables) */
+	int powerup;        /* GPIO to POWERUP signal (0 disables) */
+	int irq;            /* IRQ line or 0 to use SDIO IRQ */
 	int (*power_ctrl)(const struct cw1200_platform_data_sdio *pdata,
 			  bool enable); /* Control 3v3 / 1v8 supply */
 	int (*clk_ctrl)(const struct cw1200_platform_data_sdio *pdata,
-- 
1.8.2.1

