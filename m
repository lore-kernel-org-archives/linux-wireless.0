Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:59006 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757358Ab2I2SeC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Sep 2012 14:34:02 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, zajec5@gmail.com,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/5] bcma: add and use constants for the flash windows
Date: Sat, 29 Sep 2012 20:33:50 +0200
Message-Id: <1348943633-22800-3-git-send-email-hauke@hauke-m.de> (sfid-20120929_203406_951759_70878FB6)
In-Reply-To: <1348943633-22800-1-git-send-email-hauke@hauke-m.de>
References: <1348943633-22800-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/bcma/driver_chipcommon_sflash.c |    4 ++--
 drivers/bcma/driver_mips.c              |    4 ++--
 include/linux/bcma/bcma_regs.h          |    5 ++++-
 3 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/bcma/driver_chipcommon_sflash.c b/drivers/bcma/driver_chipcommon_sflash.c
index 2c4eec2..a0993fc 100644
--- a/drivers/bcma/driver_chipcommon_sflash.c
+++ b/drivers/bcma/driver_chipcommon_sflash.c
@@ -12,7 +12,7 @@
 
 static struct resource bcma_sflash_resource = {
 	.name	= "bcma_sflash",
-	.start	= BCMA_SFLASH,
+	.start	= BCMA_SOC_FLASH2,
 	.end	= 0,
 	.flags  = IORESOURCE_MEM | IORESOURCE_READONLY,
 };
@@ -116,7 +116,7 @@ int bcma_sflash_init(struct bcma_drv_cc *cc)
 		return -ENOTSUPP;
 	}
 
-	sflash->window = BCMA_SFLASH;
+	sflash->window = BCMA_SOC_FLASH2;
 	sflash->blocksize = e->blocksize;
 	sflash->numblocks = e->numblocks;
 	sflash->size = sflash->blocksize * sflash->numblocks;
diff --git a/drivers/bcma/driver_mips.c b/drivers/bcma/driver_mips.c
index 2786bc1..8470192 100644
--- a/drivers/bcma/driver_mips.c
+++ b/drivers/bcma/driver_mips.c
@@ -191,8 +191,8 @@ static void bcma_core_mips_flash_detect(struct bcma_drv_mips *mcore)
 	case BCMA_CC_FLASHT_PARA:
 		bcma_debug(bus, "Found parallel flash\n");
 		bus->drv_cc.pflash.present = true;
-		bus->drv_cc.pflash.window = 0x1c000000;
-		bus->drv_cc.pflash.window_size = 0x02000000;
+		bus->drv_cc.pflash.window = BCMA_SOC_FLASH2;
+		bus->drv_cc.pflash.window_size = BCMA_SOC_FLASH2_SZ;
 
 		if ((bcma_read32(bus->drv_cc.core, BCMA_CC_FLASH_CFG) &
 		     BCMA_CC_FLASH_CFG_DS) == 0)
diff --git a/include/linux/bcma/bcma_regs.h b/include/linux/bcma/bcma_regs.h
index 6c9cb93..7e8104b 100644
--- a/include/linux/bcma/bcma_regs.h
+++ b/include/linux/bcma/bcma_regs.h
@@ -85,6 +85,9 @@
 							 * (2 ZettaBytes), high 32 bits
 							 */
 
-#define BCMA_SFLASH			0x1c000000
+#define BCMA_SOC_FLASH1			0x1fc00000	/* MIPS Flash Region 1 */
+#define BCMA_SOC_FLASH1_SZ		0x00400000	/* MIPS Size of Flash Region 1 */
+#define BCMA_SOC_FLASH2			0x1c000000	/* Flash Region 2 (region 1 shadowed here) */
+#define BCMA_SOC_FLASH2_SZ		0x02000000	/* Size of Flash Region 2 */
 
 #endif /* LINUX_BCMA_REGS_H_ */
-- 
1.7.9.5

