Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:36738 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450AbbCOSnm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Mar 2015 14:43:42 -0400
Received: by wgra20 with SMTP id a20so24001664wgr.3
        for <linux-wireless@vger.kernel.org>; Sun, 15 Mar 2015 11:43:40 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] bcma: gpio: use predictable base for all BCM47XX buses
Date: Sun, 15 Mar 2015 19:43:14 +0100
Message-Id: <1426444994-21506-1-git-send-email-zajec5@gmail.com> (sfid-20150315_194348_357767_769EA588)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some BCM47XX SoC routers have LEDs connected to extra PCIe bcma buses.
Handling them in arch code requires predictable GPIO numbers.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/bcma/driver_gpio.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/drivers/bcma/driver_gpio.c b/drivers/bcma/driver_gpio.c
index dce34fb..74ccb02 100644
--- a/drivers/bcma/driver_gpio.c
+++ b/drivers/bcma/driver_gpio.c
@@ -17,6 +17,8 @@
 
 #include "bcma_private.h"
 
+#define BCMA_GPIO_MAX_PINS	32
+
 static inline struct bcma_drv_cc *bcma_gpio_get_cc(struct gpio_chip *chip)
 {
 	return container_of(chip, struct bcma_drv_cc, gpio);
@@ -204,6 +206,7 @@ static void bcma_gpio_irq_domain_exit(struct bcma_drv_cc *cc)
 
 int bcma_gpio_init(struct bcma_drv_cc *cc)
 {
+	struct bcma_bus *bus = cc->core->bus;
 	struct gpio_chip *chip = &cc->gpio;
 	int err;
 
@@ -222,7 +225,7 @@ int bcma_gpio_init(struct bcma_drv_cc *cc)
 	if (cc->core->bus->hosttype == BCMA_HOSTTYPE_SOC)
 		chip->of_node	= cc->core->dev.of_node;
 #endif
-	switch (cc->core->bus->chipinfo.id) {
+	switch (bus->chipinfo.id) {
 	case BCMA_CHIP_ID_BCM5357:
 	case BCMA_CHIP_ID_BCM53572:
 		chip->ngpio	= 32;
@@ -231,13 +234,17 @@ int bcma_gpio_init(struct bcma_drv_cc *cc)
 		chip->ngpio	= 16;
 	}
 
-	/* There is just one SoC in one device and its GPIO addresses should be
-	 * deterministic to address them more easily. The other buses could get
-	 * a random base number. */
-	if (cc->core->bus->hosttype == BCMA_HOSTTYPE_SOC)
-		chip->base		= 0;
-	else
-		chip->base		= -1;
+	/*
+	 * On MIPS we register GPIO devices (LEDs, buttons) using absolute GPIO
+	 * pin numbers. We don't have Device Tree there and we can't really use
+	 * relative (per chip) numbers.
+	 * So let's use predictable base for BCM47XX and "random" for all other.
+	 */
+#if IS_BUILTIN(CONFIG_BCM47XX)
+	chip->base		= bus->num * BCMA_GPIO_MAX_PINS;
+#else
+	chip->base		= -1;
+#endif
 
 	err = bcma_gpio_irq_domain_init(cc);
 	if (err)
-- 
1.8.4.5

