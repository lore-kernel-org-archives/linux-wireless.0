Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38488 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751883AbbESHXG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 May 2015 03:23:06 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?=
	<u.kleine-koenig@pengutronix.de>
To: Samuel Ortiz <sameo@linux.intel.com>,
	Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>
Cc: Robert Dolca <robert.dolca@intel.com>,
	linux-wireless@vger.kernel.org, kernel@pengutronix.de,
	Linus Walleij <linus.walleij@linaro.org>,
	Alexandre Courbot <gnurou@gmail.com>
Subject: [PATCH] NFC: PN544: use flags argument of devm_gpiod_get to set direction
Date: Tue, 19 May 2015 09:22:56 +0200
Message-Id: <1432020176-17343-1-git-send-email-u.kleine-koenig@pengutronix.de> (sfid-20150519_092316_803005_F7E069D8)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since 39b2bbe3d715 (gpio: add flags argument to gpiod_get*() functions)
which appeared in v3.17-rc1, the gpiod_get* functions take an additional
parameter that allows to specify direction and initial value for output.

Use this to simplify the driver. Furthermore this is one caller less
that stops us making the flags argument to gpiod_get*() mandatory.

While touching this also do some minor coding style fixes.

Fixes: 0a5942c8e148 ("NFC: Add ACPI support for NXP PN544")
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/nfc/pn544/i2c.c | 43 +++++++++++--------------------------------
 1 file changed, 11 insertions(+), 32 deletions(-)

diff --git a/drivers/nfc/pn544/i2c.c b/drivers/nfc/pn544/i2c.c
index 6fd986f5ac3e..fa75c53f3fa5 100644
--- a/drivers/nfc/pn544/i2c.c
+++ b/drivers/nfc/pn544/i2c.c
@@ -895,56 +895,35 @@ static int pn544_hci_i2c_acpi_request_resources(struct i2c_client *client)
 		return -ENODEV;
 
 	/* Get EN GPIO from ACPI */
-	gpiod_en = devm_gpiod_get_index(dev, PN544_GPIO_NAME_EN, 1);
+	gpiod_en = devm_gpiod_get_index(dev, PN544_GPIO_NAME_EN, 1,
+					GPIOD_OUT_LOW);
 	if (IS_ERR(gpiod_en)) {
-		nfc_err(dev,
-			"Unable to get EN GPIO\n");
+		nfc_err(dev, "Unable to get EN GPIO\n");
 		return -ENODEV;
 	}
 
-	phy->gpio_en  = desc_to_gpio(gpiod_en);
-
-	/* Configuration EN GPIO */
-	ret = gpiod_direction_output(gpiod_en, 0);
-	if (ret) {
-		nfc_err(dev, "Fail EN pin direction\n");
-		return ret;
-	}
+	phy->gpio_en = desc_to_gpio(gpiod_en);
 
 	/* Get FW GPIO from ACPI */
-	gpiod_fw = devm_gpiod_get_index(dev, PN544_GPIO_NAME_FW, 2);
+	gpiod_fw = devm_gpiod_get_index(dev, PN544_GPIO_NAME_FW, 2,
+					GPIOD_OUT_LOW);
 	if (IS_ERR(gpiod_fw)) {
-		nfc_err(dev,
-			"Unable to get FW GPIO\n");
+		nfc_err(dev, "Unable to get FW GPIO\n");
 		return -ENODEV;
 	}
 
-	phy->gpio_fw  = desc_to_gpio(gpiod_fw);
-
-	/* Configuration FW GPIO */
-	ret = gpiod_direction_output(gpiod_fw, 0);
-	if (ret) {
-		nfc_err(dev, "Fail FW pin direction\n");
-		return ret;
-	}
+	phy->gpio_fw = desc_to_gpio(gpiod_fw);
 
 	/* Get IRQ GPIO */
-	gpiod_irq = devm_gpiod_get_index(dev, PN544_GPIO_NAME_IRQ, 0);
+	gpiod_irq = devm_gpiod_get_index(dev, PN544_GPIO_NAME_IRQ, 0,
+					 GPIOD_IN);
 	if (IS_ERR(gpiod_irq)) {
-		nfc_err(dev,
-			"Unable to get IRQ GPIO\n");
+		nfc_err(dev, "Unable to get IRQ GPIO\n");
 		return -ENODEV;
 	}
 
 	phy->gpio_irq = desc_to_gpio(gpiod_irq);
 
-	/* Configure IRQ GPIO */
-	ret = gpiod_direction_input(gpiod_irq);
-	if (ret) {
-		nfc_err(dev, "Fail IRQ pin direction\n");
-		return ret;
-	}
-
 	/* Map the pin to an IRQ */
 	ret = gpiod_to_irq(gpiod_irq);
 	if (ret < 0) {
-- 
2.1.4

