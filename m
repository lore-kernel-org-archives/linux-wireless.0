Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:58993 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757358Ab2I2SeA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Sep 2012 14:34:00 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, zajec5@gmail.com,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/5] bcma: mark pflash as present when available
Date: Sat, 29 Sep 2012 20:33:49 +0200
Message-Id: <1348943633-22800-2-git-send-email-hauke@hauke-m.de> (sfid-20120929_203404_208967_4FE14111)
In-Reply-To: <1348943633-22800-1-git-send-email-hauke@hauke-m.de>
References: <1348943633-22800-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/bcma/driver_mips.c                  |    1 +
 include/linux/bcma/bcma_driver_chipcommon.h |    1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/bcma/driver_mips.c b/drivers/bcma/driver_mips.c
index cc65b45..2786bc1 100644
--- a/drivers/bcma/driver_mips.c
+++ b/drivers/bcma/driver_mips.c
@@ -190,6 +190,7 @@ static void bcma_core_mips_flash_detect(struct bcma_drv_mips *mcore)
 		break;
 	case BCMA_CC_FLASHT_PARA:
 		bcma_debug(bus, "Found parallel flash\n");
+		bus->drv_cc.pflash.present = true;
 		bus->drv_cc.pflash.window = 0x1c000000;
 		bus->drv_cc.pflash.window_size = 0x02000000;
 
diff --git a/include/linux/bcma/bcma_driver_chipcommon.h b/include/linux/bcma/bcma_driver_chipcommon.h
index 6ba45d2..b9d7eeb 100644
--- a/include/linux/bcma/bcma_driver_chipcommon.h
+++ b/include/linux/bcma/bcma_driver_chipcommon.h
@@ -510,6 +510,7 @@ struct bcma_chipcommon_pmu {
 
 #ifdef CONFIG_BCMA_DRIVER_MIPS
 struct bcma_pflash {
+	bool present;
 	u8 buswidth;
 	u32 window;
 	u32 window_size;
-- 
1.7.9.5

