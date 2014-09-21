Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f178.google.com ([74.125.82.178]:57889 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678AbaIUSpb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Sep 2014 14:45:31 -0400
Received: by mail-we0-f178.google.com with SMTP id t60so1899563wes.37
        for <linux-wireless@vger.kernel.org>; Sun, 21 Sep 2014 11:45:30 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] bcma: gpio: use ChipCommon GPIO IRQ on BCM47XX arch only
Date: Sun, 21 Sep 2014 20:45:13 +0200
Message-Id: <1411325113-8764-1-git-send-email-zajec5@gmail.com> (sfid-20140921_204538_260546_0E1A90EB)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

GPIOs can be also used on bcm53xx, however this arch requires different
implementation of IRQ support. It uses different IRQ number (117) and
different masks & acking.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/bcma/driver_gpio.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/bcma/driver_gpio.c b/drivers/bcma/driver_gpio.c
index aec9f85..8ea497c 100644
--- a/drivers/bcma/driver_gpio.c
+++ b/drivers/bcma/driver_gpio.c
@@ -76,7 +76,7 @@ static void bcma_gpio_free(struct gpio_chip *chip, unsigned gpio)
 	bcma_chipco_gpio_pullup(cc, 1 << gpio, 0);
 }
 
-#if IS_BUILTIN(CONFIG_BCMA_HOST_SOC)
+#if IS_BUILTIN(CONFIG_BCM47XX)
 static int bcma_gpio_to_irq(struct gpio_chip *chip, unsigned gpio)
 {
 	struct bcma_drv_cc *cc = bcma_gpio_get_cc(chip);
@@ -215,7 +215,7 @@ int bcma_gpio_init(struct bcma_drv_cc *cc)
 	chip->set		= bcma_gpio_set_value;
 	chip->direction_input	= bcma_gpio_direction_input;
 	chip->direction_output	= bcma_gpio_direction_output;
-#if IS_BUILTIN(CONFIG_BCMA_HOST_SOC)
+#if IS_BUILTIN(CONFIG_BCM47XX)
 	chip->to_irq		= bcma_gpio_to_irq;
 #endif
 	switch (cc->core->bus->chipinfo.id) {
-- 
1.8.4.5

