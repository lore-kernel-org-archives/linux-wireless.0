Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f180.google.com ([209.85.215.180]:45922 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288AbaBMRGi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Feb 2014 12:06:38 -0500
Received: by mail-ea0-f180.google.com with SMTP id o10so5196538eaj.25
        for <linux-wireless@vger.kernel.org>; Thu, 13 Feb 2014 09:06:37 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [3.14 FIX][PATCH] bcma: gpio: register all 32 GPIOs
Date: Thu, 13 Feb 2014 18:06:26 +0100
Message-Id: <1392311186-7805-1-git-send-email-zajec5@gmail.com> (sfid-20140213_180643_296986_41577AFC)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Broadcom boards have 32 GPIOs (not 16) and these higher ones are
actually used on some devices (for buttons, reset of WiFi devices).

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
Similar patch may be needed for ssb, however I didn't meet any ssb SoC
with GPIOs 16-31 connected to anything.
This is so trivial I hope it can go as a fix for 3.14. It allows support
for some devices that use these higher GPIOs.
---
 drivers/bcma/driver_gpio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/bcma/driver_gpio.c b/drivers/bcma/driver_gpio.c
index 25f9887..2f0ceac 100644
--- a/drivers/bcma/driver_gpio.c
+++ b/drivers/bcma/driver_gpio.c
@@ -218,7 +218,7 @@ int bcma_gpio_init(struct bcma_drv_cc *cc)
 #if IS_BUILTIN(CONFIG_BCMA_HOST_SOC)
 	chip->to_irq		= bcma_gpio_to_irq;
 #endif
-	chip->ngpio		= 16;
+	chip->ngpio		= 32;
 	/* There is just one SoC in one device and its GPIO addresses should be
 	 * deterministic to address them more easily. The other buses could get
 	 * a random base number. */
-- 
1.8.4.5

