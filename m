Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:46522 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754030Ab2LLBRt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Dec 2012 20:17:49 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: john@phrozen.org, ralf@linux-mips.org
Cc: linux-mips@linux-mips.org, linux-wireless@vger.kernel.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/2] bcma: add gpio_to_irq again
Date: Wed, 12 Dec 2012 02:17:10 +0100
Message-Id: <1355275031-19297-1-git-send-email-hauke@hauke-m.de> (sfid-20121212_021755_346854_1D22B161)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The old code had support for gpio_to_irq, but the new code did not
provide this function, but returned -ENXIO all the time. This patch
adds the missing function.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/bcma/driver_gpio.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/bcma/driver_gpio.c b/drivers/bcma/driver_gpio.c
index 9a6f585..212fda6 100644
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
+		return bcma_core_mips_irq(cc->core) + 2;
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
-- 
1.7.10.4

