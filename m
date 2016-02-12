Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f179.google.com ([209.85.217.179]:33568 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083AbcBLJP4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Feb 2016 04:15:56 -0500
Received: by mail-lb0-f179.google.com with SMTP id x4so42207105lbm.0
        for <linux-wireless@vger.kernel.org>; Fri, 12 Feb 2016 01:15:55 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 1/3] bcma: drop unneeded fields from bcma_pflash struct
Date: Fri, 12 Feb 2016 10:15:43 +0100
Message-Id: <1455268545-11667-1-git-send-email-zajec5@gmail.com> (sfid-20160212_101602_758077_84EF5332)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Most of info stored in this struct wasn't really used anywhere as we put
all that data in platform data & resource as well.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/bcma/driver_mips.c                  | 11 ++++-------
 include/linux/bcma/bcma_driver_chipcommon.h |  3 ---
 2 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/bcma/driver_mips.c b/drivers/bcma/driver_mips.c
index a40a203..20c134c 100644
--- a/drivers/bcma/driver_mips.c
+++ b/drivers/bcma/driver_mips.c
@@ -288,18 +288,15 @@ static void bcma_core_mips_flash_detect(struct bcma_drv_mips *mcore)
 	case BCMA_CC_FLASHT_PARA:
 		bcma_debug(bus, "Found parallel flash\n");
 		pflash->present = true;
-		pflash->window = BCMA_SOC_FLASH2;
-		pflash->window_size = BCMA_SOC_FLASH2_SZ;
 
 		if ((bcma_read32(cc->core, BCMA_CC_FLASH_CFG) &
 		     BCMA_CC_FLASH_CFG_DS) == 0)
-			pflash->buswidth = 1;
+			bcma_pflash_data.width = 1;
 		else
-			pflash->buswidth = 2;
+			bcma_pflash_data.width = 2;
 
-		bcma_pflash_data.width = pflash->buswidth;
-		bcma_pflash_resource.start = pflash->window;
-		bcma_pflash_resource.end = pflash->window + pflash->window_size;
+		bcma_pflash_resource.start = BCMA_SOC_FLASH2;
+		bcma_pflash_resource.end = BCMA_SOC_FLASH2 + BCMA_SOC_FLASH2_SZ;
 
 		break;
 	default:
diff --git a/include/linux/bcma/bcma_driver_chipcommon.h b/include/linux/bcma/bcma_driver_chipcommon.h
index 700d0c6..16eaaad 100644
--- a/include/linux/bcma/bcma_driver_chipcommon.h
+++ b/include/linux/bcma/bcma_driver_chipcommon.h
@@ -579,9 +579,6 @@ struct bcma_chipcommon_pmu {
 #ifdef CONFIG_BCMA_DRIVER_MIPS
 struct bcma_pflash {
 	bool present;
-	u8 buswidth;
-	u32 window;
-	u32 window_size;
 };
 
 #ifdef CONFIG_BCMA_SFLASH
-- 
1.8.4.5

