Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f43.google.com ([74.125.83.43]:43762 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755381AbaCTUJ0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Mar 2014 16:09:26 -0400
Received: by mail-ee0-f43.google.com with SMTP id e53so1075816eek.2
        for <linux-wireless@vger.kernel.org>; Thu, 20 Mar 2014 13:09:24 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] bcma: gpio: register 32 GPIOs on BCM5357
Date: Thu, 20 Mar 2014 21:09:07 +0100
Message-Id: <1395346147-10998-1-git-send-email-zajec5@gmail.com> (sfid-20140320_210929_791818_BD54A86F)
In-Reply-To: <1395180882-10950-1-git-send-email-zajec5@gmail.com>
References: <1395180882-10950-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some Broadcom boards have more GPIOs available. For example Linksys
E3200 home router is based on SoC id 0x5357, package 0x0A and uses GPIO
23 to reset internal USB WiFi (gpio23=wombo_reset).

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/bcma/driver_gpio.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/bcma/driver_gpio.c b/drivers/bcma/driver_gpio.c
index 25f9887..d7f81ad 100644
--- a/drivers/bcma/driver_gpio.c
+++ b/drivers/bcma/driver_gpio.c
@@ -218,7 +218,14 @@ int bcma_gpio_init(struct bcma_drv_cc *cc)
 #if IS_BUILTIN(CONFIG_BCMA_HOST_SOC)
 	chip->to_irq		= bcma_gpio_to_irq;
 #endif
-	chip->ngpio		= 16;
+	switch (cc->core->bus->chipinfo.id) {
+	case BCMA_CHIP_ID_BCM5357:
+		chip->ngpio	= 32;
+		break;
+	default:
+		chip->ngpio	= 16;
+	}
+
 	/* There is just one SoC in one device and its GPIO addresses should be
 	 * deterministic to address them more easily. The other buses could get
 	 * a random base number. */
-- 
1.8.4.5

