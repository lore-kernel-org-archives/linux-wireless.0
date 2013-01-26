Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:34168 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754120Ab3AZUke (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Jan 2013 15:40:34 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, zajec5@gmail.com,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH v2] bcma: add gpio_to_irq
Date: Sat, 26 Jan 2013 21:39:44 +0100
Message-Id: <1359232784-15832-1-git-send-email-hauke@hauke-m.de> (sfid-20130126_214038_262235_17B32086)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The old bcm47xx gpio code had support for gpio_to_irq, but the new
code did not provide this function, but returned -ENXIO all the time.
This patch adds the missing function.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/bcma/driver_gpio.c            |   11 +++++++++++
 include/linux/bcma/bcma_driver_mips.h |    9 +++++++--
 2 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/bcma/driver_gpio.c b/drivers/bcma/driver_gpio.c
index 9a6f585..0b5df53 100644
--- a/drivers/bcma/driver_gpio.c
+++ b/drivers/bcma/driver_gpio.c
@@ -73,6 +73,16 @@ static void bcma_gpio_free(struct gpio_chip *chip, unsigned gpio)
 	bcma_chipco_gpio_pullup(cc, 1 << gpio, 0);
 }
 
+static int bcma_gpio_to_irq(struct gpio_chip *chip, unsigned gpio)
+{
+	struct bcma_drv_cc *cc = bcma_gpio_get_cc(chip);
+
+	if (cc->core->bus->hosttype == BCMA_HOSTTYPE_SOC)
+		return bcma_core_irq(cc->core);
+	else
+		return -EINVAL;
+}
+
 int bcma_gpio_init(struct bcma_drv_cc *cc)
 {
 	struct gpio_chip *chip = &cc->gpio;
@@ -85,6 +95,7 @@ int bcma_gpio_init(struct bcma_drv_cc *cc)
 	chip->set		= bcma_gpio_set_value;
 	chip->direction_input	= bcma_gpio_direction_input;
 	chip->direction_output	= bcma_gpio_direction_output;
+	chip->to_irq		= bcma_gpio_to_irq;
 	chip->ngpio		= 16;
 	/* There is just one SoC in one device and its GPIO addresses should be
 	 * deterministic to address them more easily. The other buses could get
diff --git a/include/linux/bcma/bcma_driver_mips.h b/include/linux/bcma/bcma_driver_mips.h
index 0d1ea29..fb61f3f 100644
--- a/include/linux/bcma/bcma_driver_mips.h
+++ b/include/linux/bcma/bcma_driver_mips.h
@@ -42,13 +42,18 @@ struct bcma_drv_mips {
 #ifdef CONFIG_BCMA_DRIVER_MIPS
 extern void bcma_core_mips_init(struct bcma_drv_mips *mcore);
 extern void bcma_core_mips_early_init(struct bcma_drv_mips *mcore);
+
+extern unsigned int bcma_core_irq(struct bcma_device *core);
 #else
 static inline void bcma_core_mips_init(struct bcma_drv_mips *mcore) { }
 static inline void bcma_core_mips_early_init(struct bcma_drv_mips *mcore) { }
+
+static inline unsigned int bcma_core_irq(struct bcma_device *core)
+{
+	return 0;
+}
 #endif
 
 extern u32 bcma_cpu_clock(struct bcma_drv_mips *mcore);
 
-extern unsigned int bcma_core_irq(struct bcma_device *core);
-
 #endif /* LINUX_BCMA_DRIVER_MIPS_H_ */
-- 
1.7.10.4

