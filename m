Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f170.google.com ([209.85.217.170]:35224 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933098AbbGUVEx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jul 2015 17:04:53 -0400
Received: by lblf12 with SMTP id f12so124057736lbl.2
        for <linux-wireless@vger.kernel.org>; Tue, 21 Jul 2015 14:04:51 -0700 (PDT)
From: Linus Walleij <linus.walleij@linaro.org>
To: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
	Felix Fietkau <nbd@openwrt.org>,
	Kalle Valo <kvalo@codeaurora.org>,
	Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org,
	Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] bcma: switch GPIO portions to use GPIOLIB_IRQCHIP
Date: Tue, 21 Jul 2015 23:04:37 +0200
Message-Id: <1437512677-6153-1-git-send-email-linus.walleij@linaro.org> (sfid-20150721_230459_475886_C1E02BCF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This switches the BCMA GPIO driver to use GPIOLIB_IRQCHIP to
handle its interrupts instead of rolling its own copy of the
irqdomain handling etc.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
Hi BCMA people,

if we can figure this out it would be great if you can test this
and merge it through whatever GIT tree handles BCMA patches.
Alternatively I can merge it into the GPIO tree with your ACK.

This is not even compiled, I don't have the right cross compilers
but the conversion is done like all other GPIOLIB_IRQCHIP conversions
I've done, so it shouldn't be very far off. Maybe you can get it
in shape in accordance with my idea if I screwed up? Thanks.
---
 drivers/bcma/Kconfig                        |  2 +-
 drivers/bcma/driver_gpio.c                  | 88 +++++++++--------------------
 include/linux/bcma/bcma_driver_chipcommon.h |  1 -
 3 files changed, 28 insertions(+), 63 deletions(-)

diff --git a/drivers/bcma/Kconfig b/drivers/bcma/Kconfig
index be5fffb6da24..023d448ed3fa 100644
--- a/drivers/bcma/Kconfig
+++ b/drivers/bcma/Kconfig
@@ -92,7 +92,7 @@ config BCMA_DRIVER_GMAC_CMN
 config BCMA_DRIVER_GPIO
 	bool "BCMA GPIO driver"
 	depends on BCMA && GPIOLIB
-	select IRQ_DOMAIN if BCMA_HOST_SOC
+	select GPIOLIB_IRQCHIP if BCMA_HOST_SOC
 	help
 	  Driver to provide access to the GPIO pins of the bcma bus.
 
diff --git a/drivers/bcma/driver_gpio.c b/drivers/bcma/driver_gpio.c
index 5f6018e7cd4c..f436fb5b429c 100644
--- a/drivers/bcma/driver_gpio.c
+++ b/drivers/bcma/driver_gpio.c
@@ -8,10 +8,8 @@
  * Licensed under the GNU/GPL. See COPYING for details.
  */
 
-#include <linux/gpio.h>
-#include <linux/irq.h>
+#include <linux/gpio/driver.h>
 #include <linux/interrupt.h>
-#include <linux/irqdomain.h>
 #include <linux/export.h>
 #include <linux/bcma/bcma.h>
 
@@ -79,19 +77,11 @@ static void bcma_gpio_free(struct gpio_chip *chip, unsigned gpio)
 }
 
 #if IS_BUILTIN(CONFIG_BCM47XX) || IS_BUILTIN(CONFIG_ARCH_BCM_5301X)
-static int bcma_gpio_to_irq(struct gpio_chip *chip, unsigned gpio)
-{
-	struct bcma_drv_cc *cc = bcma_gpio_get_cc(chip);
-
-	if (cc->core->bus->hosttype == BCMA_HOSTTYPE_SOC)
-		return irq_find_mapping(cc->irq_domain, gpio);
-	else
-		return -EINVAL;
-}
 
 static void bcma_gpio_irq_unmask(struct irq_data *d)
 {
-	struct bcma_drv_cc *cc = irq_data_get_irq_chip_data(d);
+	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
+	struct bcma_drv_cc *cc = bcma_gpio_get_cc(gc);
 	int gpio = irqd_to_hwirq(d);
 	u32 val = bcma_chipco_gpio_in(cc, BIT(gpio));
 
@@ -101,7 +91,8 @@ static void bcma_gpio_irq_unmask(struct irq_data *d)
 
 static void bcma_gpio_irq_mask(struct irq_data *d)
 {
-	struct bcma_drv_cc *cc = irq_data_get_irq_chip_data(d);
+	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
+	struct bcma_drv_cc *cc = bcma_gpio_get_cc(gc);
 	int gpio = irqd_to_hwirq(d);
 
 	bcma_chipco_gpio_intmask(cc, BIT(gpio), 0);
@@ -116,6 +107,7 @@ static struct irq_chip bcma_gpio_irq_chip = {
 static irqreturn_t bcma_gpio_irq_handler(int irq, void *dev_id)
 {
 	struct bcma_drv_cc *cc = dev_id;
+	struct gpio_chip *gc = &cc->gpio;
 	u32 val = bcma_cc_read32(cc, BCMA_CC_GPIOIN);
 	u32 mask = bcma_cc_read32(cc, BCMA_CC_GPIOIRQ);
 	u32 pol = bcma_cc_read32(cc, BCMA_CC_GPIOPOL);
@@ -125,14 +117,14 @@ static irqreturn_t bcma_gpio_irq_handler(int irq, void *dev_id)
 	if (!irqs)
 		return IRQ_NONE;
 
-	for_each_set_bit(gpio, &irqs, cc->gpio.ngpio)
-		generic_handle_irq(bcma_gpio_to_irq(&cc->gpio, gpio));
+	for_each_set_bit(gpio, &irqs, gc->ngpio)
+		generic_handle_irq(irq_find_mapping(gc->irq_domain, gpio));
 	bcma_chipco_gpio_polarity(cc, irqs, val & irqs);
 
 	return IRQ_HANDLED;
 }
 
-static int bcma_gpio_irq_domain_init(struct bcma_drv_cc *cc)
+static int bcma_gpio_irq_init(struct bcma_drv_cc *cc)
 {
 	struct gpio_chip *chip = &cc->gpio;
 	int gpio, hwirq, err;
@@ -140,66 +132,43 @@ static int bcma_gpio_irq_domain_init(struct bcma_drv_cc *cc)
 	if (cc->core->bus->hosttype != BCMA_HOSTTYPE_SOC)
 		return 0;
 
-	cc->irq_domain = irq_domain_add_linear(NULL, chip->ngpio,
-					       &irq_domain_simple_ops, cc);
-	if (!cc->irq_domain) {
-		err = -ENODEV;
-		goto err_irq_domain;
-	}
-	for (gpio = 0; gpio < chip->ngpio; gpio++) {
-		int irq = irq_create_mapping(cc->irq_domain, gpio);
-
-		irq_set_chip_data(irq, cc);
-		irq_set_chip_and_handler(irq, &bcma_gpio_irq_chip,
-					 handle_simple_irq);
-	}
-
 	hwirq = bcma_core_irq(cc->core, 0);
 	err = request_irq(hwirq, bcma_gpio_irq_handler, IRQF_SHARED, "gpio",
 			  cc);
 	if (err)
-		goto err_req_irq;
+		return err;
 
 	bcma_chipco_gpio_intmask(cc, ~0, 0);
 	bcma_cc_set32(cc, BCMA_CC_IRQMASK, BCMA_CC_IRQ_GPIO);
 
-	return 0;
-
-err_req_irq:
-	for (gpio = 0; gpio < chip->ngpio; gpio++) {
-		int irq = irq_find_mapping(cc->irq_domain, gpio);
-
-		irq_dispose_mapping(irq);
+	err =  gpiochip_irqchip_add(chip,
+				    &bcma_gpio_irq_chip,
+				    0,
+				    handle_simple_irq,
+				    IRQ_TYPE_NONE);
+	if (err) {
+		free_irq(hwirq);
+		return err;
 	}
-	irq_domain_remove(cc->irq_domain);
-err_irq_domain:
-	return err;
+
+	return 0;
 }
 
-static void bcma_gpio_irq_domain_exit(struct bcma_drv_cc *cc)
+static void bcma_gpio_irq_exit(struct bcma_drv_cc *cc)
 {
-	struct gpio_chip *chip = &cc->gpio;
-	int gpio;
-
 	if (cc->core->bus->hosttype != BCMA_HOSTTYPE_SOC)
 		return;
 
 	bcma_cc_mask32(cc, BCMA_CC_IRQMASK, ~BCMA_CC_IRQ_GPIO);
 	free_irq(bcma_core_irq(cc->core, 0), cc);
-	for (gpio = 0; gpio < chip->ngpio; gpio++) {
-		int irq = irq_find_mapping(cc->irq_domain, gpio);
-
-		irq_dispose_mapping(irq);
-	}
-	irq_domain_remove(cc->irq_domain);
 }
 #else
-static int bcma_gpio_irq_domain_init(struct bcma_drv_cc *cc)
+static int bcma_gpio_irq_init(struct bcma_drv_cc *cc)
 {
 	return 0;
 }
 
-static void bcma_gpio_irq_domain_exit(struct bcma_drv_cc *cc)
+static void bcma_gpio_irq_exit(struct bcma_drv_cc *cc)
 {
 }
 #endif
@@ -218,9 +187,6 @@ int bcma_gpio_init(struct bcma_drv_cc *cc)
 	chip->set		= bcma_gpio_set_value;
 	chip->direction_input	= bcma_gpio_direction_input;
 	chip->direction_output	= bcma_gpio_direction_output;
-#if IS_BUILTIN(CONFIG_BCM47XX) || IS_BUILTIN(CONFIG_ARCH_BCM_5301X)
-	chip->to_irq		= bcma_gpio_to_irq;
-#endif
 #if IS_BUILTIN(CONFIG_OF)
 	if (cc->core->bus->hosttype == BCMA_HOSTTYPE_SOC)
 		chip->of_node	= cc->core->dev.of_node;
@@ -248,13 +214,13 @@ int bcma_gpio_init(struct bcma_drv_cc *cc)
 	else
 		chip->base		= -1;
 
-	err = bcma_gpio_irq_domain_init(cc);
+	err = gpiochip_add(chip);
 	if (err)
 		return err;
 
-	err = gpiochip_add(chip);
+	err = bcma_gpio_irq_init(cc);
 	if (err) {
-		bcma_gpio_irq_domain_exit(cc);
+		gpiochip_remove(chip);
 		return err;
 	}
 
@@ -263,7 +229,7 @@ int bcma_gpio_init(struct bcma_drv_cc *cc)
 
 int bcma_gpio_unregister(struct bcma_drv_cc *cc)
 {
-	bcma_gpio_irq_domain_exit(cc);
+	bcma_gpio_irq_exit(cc);
 	gpiochip_remove(&cc->gpio);
 	return 0;
 }
diff --git a/include/linux/bcma/bcma_driver_chipcommon.h b/include/linux/bcma/bcma_driver_chipcommon.h
index 6cceedf65ca2..cf038431a5cc 100644
--- a/include/linux/bcma/bcma_driver_chipcommon.h
+++ b/include/linux/bcma/bcma_driver_chipcommon.h
@@ -640,7 +640,6 @@ struct bcma_drv_cc {
 	spinlock_t gpio_lock;
 #ifdef CONFIG_BCMA_DRIVER_GPIO
 	struct gpio_chip gpio;
-	struct irq_domain *irq_domain;
 #endif
 };
 
-- 
2.4.3

