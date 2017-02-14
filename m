Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:35996 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751604AbdBNWD7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Feb 2017 17:03:59 -0500
Received: by mail-lf0-f66.google.com with SMTP id h65so12009865lfi.3
        for <linux-wireless@vger.kernel.org>; Tue, 14 Feb 2017 14:03:58 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH] bcma: gpio: set of_node regardless of the host type
Date: Tue, 14 Feb 2017 23:03:46 +0100
Message-Id: <20170214220346.10479-1-zajec5@gmail.com> (sfid-20170214_230402_424841_64D71DAB)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Rafał Miłecki <rafal@milecki.pl>

DT allows describing many device types, not only platform ones. If e.g.
bcma is hosted on PCI(e) and it has its of_node, let's pass it to the
GPIO subsystem. This allows GPIO code to handle more hardware details
not only for bcma on a SoC.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
 drivers/bcma/driver_gpio.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/bcma/driver_gpio.c b/drivers/bcma/driver_gpio.c
index 771a2a253440..7bde8d7a2816 100644
--- a/drivers/bcma/driver_gpio.c
+++ b/drivers/bcma/driver_gpio.c
@@ -185,8 +185,7 @@ int bcma_gpio_init(struct bcma_drv_cc *cc)
 	chip->owner		= THIS_MODULE;
 	chip->parent		= bcma_bus_get_host_dev(bus);
 #if IS_BUILTIN(CONFIG_OF)
-	if (cc->core->bus->hosttype == BCMA_HOSTTYPE_SOC)
-		chip->of_node	= cc->core->dev.of_node;
+	chip->of_node		= cc->core->dev.of_node;
 #endif
 	switch (bus->chipinfo.id) {
 	case BCMA_CHIP_ID_BCM4707:
-- 
2.11.0
