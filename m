Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:38542 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753994AbbBTKt0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Feb 2015 05:49:26 -0500
Received: by mail-wi0-f182.google.com with SMTP id l15so2015810wiw.3
        for <linux-wireless@vger.kernel.org>; Fri, 20 Feb 2015 02:49:25 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] bcma: gpio: enable GPIO IRQ domain on BCM5301X
Date: Fri, 20 Feb 2015 11:49:05 +0100
Message-Id: <1424429345-20128-1-git-send-email-zajec5@gmail.com> (sfid-20150220_114932_511356_0D6A6F41)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Just like on BCM47XX arch, BCM5301X also has ChipCommon with IRQ for
GPIOs. Now we have interrupts working on BCM5301X we can finally make
use of it. This has been successfully tested on 5 different devices
(Buffalo, Luxul, Netgear).

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/bcma/driver_gpio.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/bcma/driver_gpio.c b/drivers/bcma/driver_gpio.c
index 598a6cd..dce34fb 100644
--- a/drivers/bcma/driver_gpio.c
+++ b/drivers/bcma/driver_gpio.c
@@ -76,7 +76,7 @@ static void bcma_gpio_free(struct gpio_chip *chip, unsigned gpio)
 	bcma_chipco_gpio_pullup(cc, 1 << gpio, 0);
 }
 
-#if IS_BUILTIN(CONFIG_BCM47XX)
+#if IS_BUILTIN(CONFIG_BCM47XX) || IS_BUILTIN(CONFIG_ARCH_BCM_5301X)
 static int bcma_gpio_to_irq(struct gpio_chip *chip, unsigned gpio)
 {
 	struct bcma_drv_cc *cc = bcma_gpio_get_cc(chip);
@@ -215,7 +215,7 @@ int bcma_gpio_init(struct bcma_drv_cc *cc)
 	chip->set		= bcma_gpio_set_value;
 	chip->direction_input	= bcma_gpio_direction_input;
 	chip->direction_output	= bcma_gpio_direction_output;
-#if IS_BUILTIN(CONFIG_BCM47XX)
+#if IS_BUILTIN(CONFIG_BCM47XX) || IS_BUILTIN(CONFIG_ARCH_BCM_5301X)
 	chip->to_irq		= bcma_gpio_to_irq;
 #endif
 #if IS_BUILTIN(CONFIG_OF)
-- 
1.8.4.5

