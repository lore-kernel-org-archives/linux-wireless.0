Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:36463 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1429851AbdDYSkp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Apr 2017 14:40:45 -0400
From: Mark Greer <mgreer@animalcreek.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-wireless@vger.kernel.org, linux-nfc@lists.01.org,
        devicetree@vger.kernel.org, Mark Greer <mgreer@animalcreek.com>
Subject: [PATCH v4 8/9] NFC: trf7970a: Convert to descriptor based GPIO interface
Date: Tue, 25 Apr 2017 11:40:35 -0700
Message-Id: <20170425184036.1212-9-mgreer@animalcreek.com> (sfid-20170425_204114_612343_096D1A85)
In-Reply-To: <20170425184036.1212-1-mgreer@animalcreek.com>
References: <20170425184036.1212-1-mgreer@animalcreek.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The trf7970a driver uses the deprecated integer-based GPIO consumer
interface so convert it to use the new descriptor-based GPIO
consumer interface.

Signed-off-by: Mark Greer <mgreer@animalcreek.com>
---
 drivers/nfc/Kconfig    |  2 +-
 drivers/nfc/trf7970a.c | 61 +++++++++++++++++++++-----------------------------
 2 files changed, 26 insertions(+), 37 deletions(-)

diff --git a/drivers/nfc/Kconfig b/drivers/nfc/Kconfig
index c4208487fadc..b065eb605215 100644
--- a/drivers/nfc/Kconfig
+++ b/drivers/nfc/Kconfig
@@ -7,7 +7,7 @@ menu "Near Field Communication (NFC) devices"
 
 config NFC_TRF7970A
 	tristate "Texas Instruments TRF7970a NFC driver"
-	depends on SPI && NFC_DIGITAL
+	depends on SPI && NFC_DIGITAL && GPIOLIB
 	help
 	  This option enables the NFC driver for Texas Instruments' TRF7970a
 	  device. Such device supports 5 different protocols: ISO14443A,
diff --git a/drivers/nfc/trf7970a.c b/drivers/nfc/trf7970a.c
index 5827ad111942..bb777f50b4fb 100644
--- a/drivers/nfc/trf7970a.c
+++ b/drivers/nfc/trf7970a.c
@@ -20,9 +20,8 @@
 #include <linux/nfc.h>
 #include <linux/skbuff.h>
 #include <linux/delay.h>
-#include <linux/gpio.h>
+#include <linux/gpio/consumer.h>
 #include <linux/of.h>
-#include <linux/of_gpio.h>
 #include <linux/spi/spi.h>
 #include <linux/regulator/consumer.h>
 
@@ -452,8 +451,8 @@ struct trf7970a {
 	u8				tx_cmd;
 	bool				issue_eof;
 	bool				adjust_resp_len;
-	int				en2_gpio;
-	int				en_gpio;
+	struct gpio_desc		*en_gpiod;
+	struct gpio_desc		*en2_gpiod;
 	struct mutex			lock;
 	unsigned int			timeout;
 	bool				ignore_timeout;
@@ -1908,14 +1907,13 @@ static int trf7970a_power_up(struct trf7970a *trf)
 
 	usleep_range(5000, 6000);
 
-	if (!(trf->quirks & TRF7970A_QUIRK_EN2_MUST_STAY_LOW)) {
-		if (gpio_is_valid(trf->en2_gpio)) {
-			gpio_set_value(trf->en2_gpio, 1);
-			usleep_range(1000, 2000);
-		}
+	if (trf->en2_gpiod &&
+	    !(trf->quirks & TRF7970A_QUIRK_EN2_MUST_STAY_LOW)) {
+		gpiod_set_value_cansleep(trf->en2_gpiod, 1);
+		usleep_range(1000, 2000);
 	}
 
-	gpio_set_value(trf->en_gpio, 1);
+	gpiod_set_value_cansleep(trf->en_gpiod, 1);
 
 	usleep_range(20000, 21000);
 
@@ -1939,11 +1937,11 @@ static int trf7970a_power_down(struct trf7970a *trf)
 		return -EBUSY;
 	}
 
-	gpio_set_value(trf->en_gpio, 0);
+	gpiod_set_value_cansleep(trf->en_gpiod, 0);
 
-	if (!(trf->quirks & TRF7970A_QUIRK_EN2_MUST_STAY_LOW))
-		if (gpio_is_valid(trf->en2_gpio))
-			gpio_set_value(trf->en2_gpio, 0);
+	if (trf->en2_gpiod &&
+	    !(trf->quirks & TRF7970A_QUIRK_EN2_MUST_STAY_LOW))
+		gpiod_set_value_cansleep(trf->en2_gpiod, 0);
 
 	ret = regulator_disable(trf->regulator);
 	if (ret)
@@ -2041,32 +2039,23 @@ static int trf7970a_probe(struct spi_device *spi)
 		trf->quirks |= TRF7970A_QUIRK_IRQ_STATUS_READ;
 
 	/* There are two enable pins - only EN must be present in the DT */
-	trf->en_gpio = of_get_named_gpio(np, "ti,enable-gpios", 0);
-	if (!gpio_is_valid(trf->en_gpio)) {
+	trf->en_gpiod = devm_gpiod_get_index(trf->dev, "ti,enable", 0,
+					     GPIOD_OUT_LOW);
+	if (IS_ERR(trf->en_gpiod)) {
 		dev_err(trf->dev, "No EN GPIO property\n");
-		return trf->en_gpio;
-	}
-
-	ret = devm_gpio_request_one(trf->dev, trf->en_gpio,
-			GPIOF_DIR_OUT | GPIOF_INIT_LOW, "trf7970a EN");
-	if (ret) {
-		dev_err(trf->dev, "Can't request EN GPIO: %d\n", ret);
-		return ret;
+		return PTR_ERR(trf->en_gpiod);
 	}
 
-	trf->en2_gpio = of_get_named_gpio(np, "ti,enable-gpios", 1);
-	if (!gpio_is_valid(trf->en2_gpio)) {
+	trf->en2_gpiod = devm_gpiod_get_index_optional(trf->dev, "ti,enable", 1,
+						       GPIOD_OUT_LOW);
+	if (!trf->en2_gpiod) {
 		dev_info(trf->dev, "No EN2 GPIO property\n");
-	} else {
-		ret = devm_gpio_request_one(trf->dev, trf->en2_gpio,
-				GPIOF_DIR_OUT | GPIOF_INIT_LOW, "trf7970a EN2");
-		if (ret) {
-			dev_err(trf->dev, "Can't request EN2 GPIO: %d\n", ret);
-			return ret;
-		}
-
-		if (of_property_read_bool(np, "en2-rf-quirk"))
-			trf->quirks |= TRF7970A_QUIRK_EN2_MUST_STAY_LOW;
+	} else if (IS_ERR(trf->en2_gpiod)) {
+		dev_err(trf->dev, "Error getting EN2 GPIO property: %ld\n",
+			PTR_ERR(trf->en2_gpiod));
+		return PTR_ERR(trf->en2_gpiod);
+	} else if (of_property_read_bool(np, "en2-rf-quirk")) {
+		trf->quirks |= TRF7970A_QUIRK_EN2_MUST_STAY_LOW;
 	}
 
 	of_property_read_u32(np, "clock-frequency", &clk_freq);
-- 
2.12.0
