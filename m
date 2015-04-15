Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static.88-198-24-112.clients.your-server.de ([88.198.24.112]:60745
	"EHLO nbd.name" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753515AbbDONIA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Apr 2015 09:08:00 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, zajec5@gmail.com, hauke@hauke-m.de
Subject: [PATCH 1/2] bcma: use absolute base for SoC GPIO pins
Date: Wed, 15 Apr 2015 15:07:52 +0200
Message-Id: <1429103273-89272-1-git-send-email-nbd@openwrt.org> (sfid-20150415_150807_186179_F371DE6B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On some BCM5301x ARM devices, user space still needs to control some
system GPIO pins for which no driver exists. This is a lot easier to do
with a predictable GPIO base.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/bcma/driver_gpio.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/bcma/driver_gpio.c b/drivers/bcma/driver_gpio.c
index 74ccb02..9b8d9bf 100644
--- a/drivers/bcma/driver_gpio.c
+++ b/drivers/bcma/driver_gpio.c
@@ -235,16 +235,17 @@ int bcma_gpio_init(struct bcma_drv_cc *cc)
 	}
 
 	/*
-	 * On MIPS we register GPIO devices (LEDs, buttons) using absolute GPIO
-	 * pin numbers. We don't have Device Tree there and we can't really use
-	 * relative (per chip) numbers.
-	 * So let's use predictable base for BCM47XX and "random" for all other.
+	 * Register SoC GPIO devices with absolute GPIO pin base.
+	 * On MIPS, we don't have Device Tree and we can't use relative (per chip)
+	 * GPIO numbers.
+	 * On some ARM devices, user space may want to access some system GPIO
+	 * pins directly, which is easier to do with a predictable GPIO base.
 	 */
-#if IS_BUILTIN(CONFIG_BCM47XX)
-	chip->base		= bus->num * BCMA_GPIO_MAX_PINS;
-#else
-	chip->base		= -1;
-#endif
+	if (IS_BUILTIN(CONFIG_BCM47XX) ||
+	    cc->core->bus->hosttype == BCMA_HOSTTYPE_SOC)
+		chip->base		= bus->num * BCMA_GPIO_MAX_PINS;
+	else
+		chip->base		= -1;
 
 	err = bcma_gpio_irq_domain_init(cc);
 	if (err)
-- 
2.2.2

