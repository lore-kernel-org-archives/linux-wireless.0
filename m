Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hauke-m.de ([5.39.93.123]:39006 "EHLO hauke-m.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751270AbbHBSAZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Aug 2015 14:00:25 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linus.walleij@linaro.org, kvalo@codeaurora.org
Cc: zajec5@gmail.com, nbd@openwrt.org, linux-wireless@vger.kernel.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH v2] bcma: switch GPIO portions to use GPIOLIB_IRQCHIP
Date: Sun,  2 Aug 2015 20:00:05 +0200
Message-Id: <1438538405-9133-1-git-send-email-hauke@hauke-m.de> (sfid-20150802_200029_436457_05BF0523)
In-Reply-To: <1437512677-6153-1-git-send-email-linus.walleij@linaro.org>
References: <1437512677-6153-1-git-send-email-linus.walleij@linaro.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Linus Walleij <linus.walleij@linaro.org>

This switches the BCMA GPIO driver to use GPIOLIB_IRQCHIP to
handle its interrupts instead of rolling its own copy of the
irqdomain handling etc.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---

I fixed some bugs in the original patch, some of them are compile 
errors and others caused some runtime problems. This patch worked on my 
BCM4708 based device, I was able to receive an IRQ for a GPIO change 
(button press).

I think this should go through the wireless tree.

@Linus could you please check if the changes I did are correct?

 drivers/bcma/Kconfig                        |   2 +-
 drivers/bcma/driver_gpio.c                  | 105 ++++++++++++----------------
 include/linux/bcma/bcma_driver_chipcommon.h |   1 -
 3 files changed, 44 insertions(+), 64 deletions(-)

diff --git a/drivers/bcma/Kconfig b/drivers/bcma/Kconfig
index be5fffb..023d448 100644
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
index 5f6018e..6715090 100644
--- a/drivers/bcma/driver_gpio.c
+++ b/drivers/bcma/driver_gpio.c
@@ -8,12 +8,13 @@
  * Licensed under the GNU/GPL. See COPYING for details.
  */
 
-#include <linux/gpio.h>
-#include <linux/irq.h>
+#include <linux/gpio/driver.h>
 #include <linux/interrupt.h>
-#include <linux/irqdomain.h>
 #include <linux/export.h>
 #include <linux/bcma/bcma.h>
+#include <linux/mmc/sdio_func.h>
+#include <linux/platform_device.h>
+#include <linux/pci.h>
 
 #include "bcma_private.h"
 
@@ -79,19 +80,11 @@ static void bcma_gpio_free(struct gpio_chip *chip, unsigned gpio)
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
 
@@ -101,7 +94,8 @@ static void bcma_gpio_irq_unmask(struct irq_data *d)
 
 static void bcma_gpio_irq_mask(struct irq_data *d)
 {
-	struct bcma_drv_cc *cc = irq_data_get_irq_chip_data(d);
+	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
+	struct bcma_drv_cc *cc = bcma_gpio_get_cc(gc);
 	int gpio = irqd_to_hwirq(d);
 
 	bcma_chipco_gpio_intmask(cc, BIT(gpio), 0);
@@ -116,6 +110,7 @@ static struct irq_chip bcma_gpio_irq_chip = {
 static irqreturn_t bcma_gpio_irq_handler(int irq, void *dev_id)
 {
 	struct bcma_drv_cc *cc = dev_id;
+	struct gpio_chip *gc = &cc->gpio;
 	u32 val = bcma_cc_read32(cc, BCMA_CC_GPIOIN);
 	u32 mask = bcma_cc_read32(cc, BCMA_CC_GPIOIRQ);
 	u32 pol = bcma_cc_read32(cc, BCMA_CC_GPIOPOL);
@@ -125,81 +120,58 @@ static irqreturn_t bcma_gpio_irq_handler(int irq, void *dev_id)
 	if (!irqs)
 		return IRQ_NONE;
 
-	for_each_set_bit(gpio, &irqs, cc->gpio.ngpio)
-		generic_handle_irq(bcma_gpio_to_irq(&cc->gpio, gpio));
+	for_each_set_bit(gpio, &irqs, gc->ngpio)
+		generic_handle_irq(irq_find_mapping(gc->irqdomain, gpio));
 	bcma_chipco_gpio_polarity(cc, irqs, val & irqs);
 
 	return IRQ_HANDLED;
 }
 
-static int bcma_gpio_irq_domain_init(struct bcma_drv_cc *cc)
+static int bcma_gpio_irq_init(struct bcma_drv_cc *cc)
 {
 	struct gpio_chip *chip = &cc->gpio;
-	int gpio, hwirq, err;
+	int hwirq, err;
 
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
+		free_irq(hwirq, cc);
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
@@ -218,9 +190,18 @@ int bcma_gpio_init(struct bcma_drv_cc *cc)
 	chip->set		= bcma_gpio_set_value;
 	chip->direction_input	= bcma_gpio_direction_input;
 	chip->direction_output	= bcma_gpio_direction_output;
-#if IS_BUILTIN(CONFIG_BCM47XX) || IS_BUILTIN(CONFIG_ARCH_BCM_5301X)
-	chip->to_irq		= bcma_gpio_to_irq;
-#endif
+	chip->owner		= THIS_MODULE;
+	switch (bus->hosttype) {
+	case BCMA_HOSTTYPE_PCI:
+		chip->dev	= &bus->host_pci->dev;
+		break;
+	case BCMA_HOSTTYPE_SOC:
+		chip->dev	= &bus->host_pdev->dev;
+		break;
+	case BCMA_HOSTTYPE_SDIO:
+		chip->dev	= &bus->host_sdio->dev;
+		break;
+	}
 #if IS_BUILTIN(CONFIG_OF)
 	if (cc->core->bus->hosttype == BCMA_HOSTTYPE_SOC)
 		chip->of_node	= cc->core->dev.of_node;
@@ -248,13 +229,13 @@ int bcma_gpio_init(struct bcma_drv_cc *cc)
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
 
@@ -263,7 +244,7 @@ int bcma_gpio_init(struct bcma_drv_cc *cc)
 
 int bcma_gpio_unregister(struct bcma_drv_cc *cc)
 {
-	bcma_gpio_irq_domain_exit(cc);
+	bcma_gpio_irq_exit(cc);
 	gpiochip_remove(&cc->gpio);
 	return 0;
 }
diff --git a/include/linux/bcma/bcma_driver_chipcommon.h b/include/linux/bcma/bcma_driver_chipcommon.h
index 6cceedf..cf03843 100644
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
2.1.4

