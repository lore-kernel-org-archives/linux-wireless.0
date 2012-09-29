Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:59020 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757358Ab2I2SeG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Sep 2012 14:34:06 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, zajec5@gmail.com,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 4/5] bcma: extract drv_cc in bcma_core_mips_flash_detect()
Date: Sat, 29 Sep 2012 20:33:52 +0200
Message-Id: <1348943633-22800-5-git-send-email-hauke@hauke-m.de> (sfid-20120929_203412_182976_8DF04967)
In-Reply-To: <1348943633-22800-1-git-send-email-hauke@hauke-m.de>
References: <1348943633-22800-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This makes the code more readable

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/bcma/driver_mips.c |   23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/bcma/driver_mips.c b/drivers/bcma/driver_mips.c
index 8470192..584a506 100644
--- a/drivers/bcma/driver_mips.c
+++ b/drivers/bcma/driver_mips.c
@@ -181,34 +181,35 @@ EXPORT_SYMBOL(bcma_cpu_clock);
 static void bcma_core_mips_flash_detect(struct bcma_drv_mips *mcore)
 {
 	struct bcma_bus *bus = mcore->core->bus;
+	struct bcma_drv_cc *cc = &bus->drv_cc;
 
-	switch (bus->drv_cc.capabilities & BCMA_CC_CAP_FLASHT) {
+	switch (cc->capabilities & BCMA_CC_CAP_FLASHT) {
 	case BCMA_CC_FLASHT_STSER:
 	case BCMA_CC_FLASHT_ATSER:
 		bcma_debug(bus, "Found serial flash\n");
-		bcma_sflash_init(&bus->drv_cc);
+		bcma_sflash_init(cc);
 		break;
 	case BCMA_CC_FLASHT_PARA:
 		bcma_debug(bus, "Found parallel flash\n");
-		bus->drv_cc.pflash.present = true;
-		bus->drv_cc.pflash.window = BCMA_SOC_FLASH2;
-		bus->drv_cc.pflash.window_size = BCMA_SOC_FLASH2_SZ;
+		cc->pflash.present = true;
+		cc->pflash.window = BCMA_SOC_FLASH2;
+		cc->pflash.window_size = BCMA_SOC_FLASH2_SZ;
 
-		if ((bcma_read32(bus->drv_cc.core, BCMA_CC_FLASH_CFG) &
+		if ((bcma_read32(cc->core, BCMA_CC_FLASH_CFG) &
 		     BCMA_CC_FLASH_CFG_DS) == 0)
-			bus->drv_cc.pflash.buswidth = 1;
+			cc->pflash.buswidth = 1;
 		else
-			bus->drv_cc.pflash.buswidth = 2;
+			cc->pflash.buswidth = 2;
 		break;
 	default:
 		bcma_err(bus, "Flash type not supported\n");
 	}
 
-	if (bus->drv_cc.core->id.rev == 38 ||
+	if (cc->core->id.rev == 38 ||
 	    bus->chipinfo.id == BCMA_CHIP_ID_BCM4706) {
-		if (bus->drv_cc.capabilities & BCMA_CC_CAP_NFLASH) {
+		if (cc->capabilities & BCMA_CC_CAP_NFLASH) {
 			bcma_debug(bus, "Found NAND flash\n");
-			bcma_nflash_init(&bus->drv_cc);
+			bcma_nflash_init(cc);
 		}
 	}
 }
-- 
1.7.9.5

