Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f41.google.com ([209.85.215.41]:35837 "EHLO
	mail-lf0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754148AbbLINoA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Dec 2015 08:44:00 -0500
Received: by lfdl133 with SMTP id l133so34346573lfd.2
        for <linux-wireless@vger.kernel.org>; Wed, 09 Dec 2015 05:43:58 -0800 (PST)
From: Linus Walleij <linus.walleij@linaro.org>
To: linux-gpio@vger.kernel.org, Johan Hovold <johan@kernel.org>,
	Alexandre Courbot <acourbot@nvidia.com>,
	Michael Welling <mwelling@ieee.org>,
	Markus Pargmann <mpa@pengutronix.de>, zajec5@gmail.com,
	Hauke Mehrtens <hauke@hauke-m.de>,
	Kalle Valo <kvalo@codeaurora.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 153/182] bcma: gpio: use gpiochip data pointer
Date: Wed,  9 Dec 2015 14:43:53 +0100
Message-Id: <1449668633-5547-1-git-send-email-linus.walleij@linaro.org> (sfid-20151209_144405_773671_FD818325)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This makes the driver use the data pointer added to the gpio_chip
to store a pointer to the state container instead of relying on
container_of().

Cc: Rafał Miłecki <zajec5@gmail.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
BCMA maintainers: please ACK this so I can take it through the
GPIO tree.
---
 drivers/bcma/driver_gpio.c | 23 +++++++++--------------
 1 file changed, 9 insertions(+), 14 deletions(-)

diff --git a/drivers/bcma/driver_gpio.c b/drivers/bcma/driver_gpio.c
index 949754427ce2..98067f757fb0 100644
--- a/drivers/bcma/driver_gpio.c
+++ b/drivers/bcma/driver_gpio.c
@@ -17,14 +17,9 @@
 
 #define BCMA_GPIO_MAX_PINS	32
 
-static inline struct bcma_drv_cc *bcma_gpio_get_cc(struct gpio_chip *chip)
-{
-	return container_of(chip, struct bcma_drv_cc, gpio);
-}
-
 static int bcma_gpio_get_value(struct gpio_chip *chip, unsigned gpio)
 {
-	struct bcma_drv_cc *cc = bcma_gpio_get_cc(chip);
+	struct bcma_drv_cc *cc = gpiochip_get_data(chip);
 
 	return !!bcma_chipco_gpio_in(cc, 1 << gpio);
 }
@@ -32,14 +27,14 @@ static int bcma_gpio_get_value(struct gpio_chip *chip, unsigned gpio)
 static void bcma_gpio_set_value(struct gpio_chip *chip, unsigned gpio,
 				int value)
 {
-	struct bcma_drv_cc *cc = bcma_gpio_get_cc(chip);
+	struct bcma_drv_cc *cc = gpiochip_get_data(chip);
 
 	bcma_chipco_gpio_out(cc, 1 << gpio, value ? 1 << gpio : 0);
 }
 
 static int bcma_gpio_direction_input(struct gpio_chip *chip, unsigned gpio)
 {
-	struct bcma_drv_cc *cc = bcma_gpio_get_cc(chip);
+	struct bcma_drv_cc *cc = gpiochip_get_data(chip);
 
 	bcma_chipco_gpio_outen(cc, 1 << gpio, 0);
 	return 0;
@@ -48,7 +43,7 @@ static int bcma_gpio_direction_input(struct gpio_chip *chip, unsigned gpio)
 static int bcma_gpio_direction_output(struct gpio_chip *chip, unsigned gpio,
 				      int value)
 {
-	struct bcma_drv_cc *cc = bcma_gpio_get_cc(chip);
+	struct bcma_drv_cc *cc = gpiochip_get_data(chip);
 
 	bcma_chipco_gpio_outen(cc, 1 << gpio, 1 << gpio);
 	bcma_chipco_gpio_out(cc, 1 << gpio, value ? 1 << gpio : 0);
@@ -57,7 +52,7 @@ static int bcma_gpio_direction_output(struct gpio_chip *chip, unsigned gpio,
 
 static int bcma_gpio_request(struct gpio_chip *chip, unsigned gpio)
 {
-	struct bcma_drv_cc *cc = bcma_gpio_get_cc(chip);
+	struct bcma_drv_cc *cc = gpiochip_get_data(chip);
 
 	bcma_chipco_gpio_control(cc, 1 << gpio, 0);
 	/* clear pulldown */
@@ -70,7 +65,7 @@ static int bcma_gpio_request(struct gpio_chip *chip, unsigned gpio)
 
 static void bcma_gpio_free(struct gpio_chip *chip, unsigned gpio)
 {
-	struct bcma_drv_cc *cc = bcma_gpio_get_cc(chip);
+	struct bcma_drv_cc *cc = gpiochip_get_data(chip);
 
 	/* clear pullup */
 	bcma_chipco_gpio_pullup(cc, 1 << gpio, 0);
@@ -81,7 +76,7 @@ static void bcma_gpio_free(struct gpio_chip *chip, unsigned gpio)
 static void bcma_gpio_irq_unmask(struct irq_data *d)
 {
 	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
-	struct bcma_drv_cc *cc = bcma_gpio_get_cc(gc);
+	struct bcma_drv_cc *cc = gpiochip_get_data(gc);
 	int gpio = irqd_to_hwirq(d);
 	u32 val = bcma_chipco_gpio_in(cc, BIT(gpio));
 
@@ -92,7 +87,7 @@ static void bcma_gpio_irq_unmask(struct irq_data *d)
 static void bcma_gpio_irq_mask(struct irq_data *d)
 {
 	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
-	struct bcma_drv_cc *cc = bcma_gpio_get_cc(gc);
+	struct bcma_drv_cc *cc = gpiochip_get_data(gc);
 	int gpio = irqd_to_hwirq(d);
 
 	bcma_chipco_gpio_intmask(cc, BIT(gpio), 0);
@@ -216,7 +211,7 @@ int bcma_gpio_init(struct bcma_drv_cc *cc)
 	else
 		chip->base		= -1;
 
-	err = gpiochip_add(chip);
+	err = gpiochip_add_data(chip, cc);
 	if (err)
 		return err;
 
-- 
2.4.3

