Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:50259 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759270Ab2HIUiR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Aug 2012 16:38:17 -0400
Received: by weyx8 with SMTP id x8so549553wey.19
        for <linux-wireless@vger.kernel.org>; Thu, 09 Aug 2012 13:38:15 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH wireless?] bcma: keep info about parallel flash presentence
Date: Thu,  9 Aug 2012 22:38:10 +0200
Message-Id: <1344544690-11280-1-git-send-email-zajec5@gmail.com> (sfid-20120809_223820_704825_3474E6EF)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This allows drivers to access flash conditionally and stop crashing some
devices.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
Acked-by: Hauke Mehrtens <hauke@hauke-m.de>
---
John: I suggest taking it for wirelesss, AKA fix
---
 drivers/bcma/driver_mips.c                  |    2 +-
 include/linux/bcma/bcma_driver_chipcommon.h |    1 +
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/bcma/driver_mips.c b/drivers/bcma/driver_mips.c
index cc65b45..55acba9 100644
--- a/drivers/bcma/driver_mips.c
+++ b/drivers/bcma/driver_mips.c
@@ -192,12 +192,12 @@ static void bcma_core_mips_flash_detect(struct bcma_drv_mips *mcore)
 		bcma_debug(bus, "Found parallel flash\n");
 		bus->drv_cc.pflash.window = 0x1c000000;
 		bus->drv_cc.pflash.window_size = 0x02000000;
-
 		if ((bcma_read32(bus->drv_cc.core, BCMA_CC_FLASH_CFG) &
 		     BCMA_CC_FLASH_CFG_DS) == 0)
 			bus->drv_cc.pflash.buswidth = 1;
 		else
 			bus->drv_cc.pflash.buswidth = 2;
+		bus->drv_cc.pflash.present = true;
 		break;
 	default:
 		bcma_err(bus, "Flash type not supported\n");
diff --git a/include/linux/bcma/bcma_driver_chipcommon.h b/include/linux/bcma/bcma_driver_chipcommon.h
index 3fb8bba..16c266c 100644
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
1.7.7

