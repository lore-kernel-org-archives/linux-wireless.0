Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static.88-198-24-112.clients.your-server.de ([88.198.24.112]:60744
	"EHLO nbd.name" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753557AbbDONIA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Apr 2015 09:08:00 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, zajec5@gmail.com, hauke@hauke-m.de
Subject: [PATCH 2/2] bcma: enable 32 GPIO pins for BCM4707
Date: Wed, 15 Apr 2015 15:07:53 +0200
Message-Id: <1429103273-89272-2-git-send-email-nbd@openwrt.org> (sfid-20150415_150806_043364_C61C17F3)
In-Reply-To: <1429103273-89272-1-git-send-email-nbd@openwrt.org>
References: <1429103273-89272-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/bcma/driver_gpio.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/bcma/driver_gpio.c b/drivers/bcma/driver_gpio.c
index 9b8d9bf..5f6018e 100644
--- a/drivers/bcma/driver_gpio.c
+++ b/drivers/bcma/driver_gpio.c
@@ -226,6 +226,7 @@ int bcma_gpio_init(struct bcma_drv_cc *cc)
 		chip->of_node	= cc->core->dev.of_node;
 #endif
 	switch (bus->chipinfo.id) {
+	case BCMA_CHIP_ID_BCM4707:
 	case BCMA_CHIP_ID_BCM5357:
 	case BCMA_CHIP_ID_BCM53572:
 		chip->ngpio	= 32;
-- 
2.2.2

