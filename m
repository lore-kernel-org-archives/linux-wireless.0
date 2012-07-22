Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:37532 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752118Ab2GVQvR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Jul 2012 12:51:17 -0400
Received: by wgbfm10 with SMTP id fm10so1852159wgb.1
        for <linux-wireless@vger.kernel.org>; Sun, 22 Jul 2012 09:51:16 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Cc: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [RFT][PATCH 1/3] ssb: update defines
Date: Sun, 22 Jul 2012 18:51:27 +0200
Message-Id: <1342975889-32687-2-git-send-email-zajec5@gmail.com> (sfid-20120722_185121_134921_A0180F7B)
In-Reply-To: <1342975889-32687-1-git-send-email-zajec5@gmail.com>
References: <1342975889-32687-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/ssb/driver_mipscore.c             |    8 ++++----
 include/linux/ssb/ssb_driver_chipcommon.h |    4 +++-
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/ssb/driver_mipscore.c b/drivers/ssb/driver_mipscore.c
index 7e2ddc0..f8813f8 100644
--- a/drivers/ssb/driver_mipscore.c
+++ b/drivers/ssb/driver_mipscore.c
@@ -192,14 +192,14 @@ static void ssb_mips_flash_detect(struct ssb_mipscore *mcore)
 
 	mcore->flash_buswidth = 2;
 	if (bus->chipco.dev) {
-		mcore->flash_window = 0x1c000000;
-		mcore->flash_window_size = 0x02000000;
+		mcore->flash_window = SSB_FLASH2;
+		mcore->flash_window_size = SSB_FLASH2_SZ;
 		if ((ssb_read32(bus->chipco.dev, SSB_CHIPCO_FLASH_CFG)
 		               & SSB_CHIPCO_CFG_DS16) == 0)
 			mcore->flash_buswidth = 1;
 	} else {
-		mcore->flash_window = 0x1fc00000;
-		mcore->flash_window_size = 0x00400000;
+		mcore->flash_window = SSB_FLASH1;
+		mcore->flash_window_size = SSB_FLASH1_SZ;
 	}
 }
 
diff --git a/include/linux/ssb/ssb_driver_chipcommon.h b/include/linux/ssb/ssb_driver_chipcommon.h
index 1a6b004..c2b02a5 100644
--- a/include/linux/ssb/ssb_driver_chipcommon.h
+++ b/include/linux/ssb/ssb_driver_chipcommon.h
@@ -504,7 +504,9 @@
 #define SSB_CHIPCO_FLASHCTL_ST_SE	0x02D8		/* Sector Erase */
 #define SSB_CHIPCO_FLASHCTL_ST_BE	0x00C7		/* Bulk Erase */
 #define SSB_CHIPCO_FLASHCTL_ST_DP	0x00B9		/* Deep Power-down */
-#define SSB_CHIPCO_FLASHCTL_ST_RSIG	0x03AB		/* Read Electronic Signature */
+#define SSB_CHIPCO_FLASHCTL_ST_RES	0x03AB		/* Read Electronic Signature */
+#define SSB_CHIPCO_FLASHCTL_ST_CSA	0x1000		/* Keep chip select asserted */
+#define SSB_CHIPCO_FLASHCTL_ST_SSE	0x0220		/* Sub-sector Erase */
 
 /* Status register bits for ST flashes */
 #define SSB_CHIPCO_FLASHSTA_ST_WIP	0x01		/* Write In Progress */
-- 
1.7.7

