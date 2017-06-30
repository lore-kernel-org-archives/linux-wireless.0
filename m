Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:36836 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751072AbdF3TDM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 30 Jun 2017 15:03:12 -0400
From: Florian Fainelli <f.fainelli@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Florian Fainelli <f.fainelli@gmail.com>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
        linux-wireless@vger.kernel.org (open list:BROADCOM SPECIFIC AMBA DRIVER
        (BCMA))
Subject: [PATCH] bcma: gpio: Correct number of GPIOs for BCM53573
Date: Fri, 30 Jun 2017 12:02:57 -0700
Message-Id: <20170630190257.15016-1-f.fainelli@gmail.com> (sfid-20170630_210350_099540_1D95F051)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Broadcom BCM53573 SoCs actually have 32 GPIOs, and not 16.

Fixes: 3f37ec79dd21 ("bcma: support BCM53573 series of wireless SoCs")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/bcma/driver_gpio.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/bcma/driver_gpio.c b/drivers/bcma/driver_gpio.c
index 7bde8d7a2816..982d5781d3ce 100644
--- a/drivers/bcma/driver_gpio.c
+++ b/drivers/bcma/driver_gpio.c
@@ -191,6 +191,7 @@ int bcma_gpio_init(struct bcma_drv_cc *cc)
 	case BCMA_CHIP_ID_BCM4707:
 	case BCMA_CHIP_ID_BCM5357:
 	case BCMA_CHIP_ID_BCM53572:
+	case BCMA_CHIP_ID_BCM53573:
 	case BCMA_CHIP_ID_BCM47094:
 		chip->ngpio	= 32;
 		break;
-- 
2.9.3
