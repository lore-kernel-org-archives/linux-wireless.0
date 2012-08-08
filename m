Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:44331 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758805Ab2HHRhI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Aug 2012 13:37:08 -0400
Received: by wibhm11 with SMTP id hm11so4109078wib.1
        for <linux-wireless@vger.kernel.org>; Wed, 08 Aug 2012 10:37:06 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] ssb: check for flash presentence
Date: Wed,  8 Aug 2012 19:37:04 +0200
Message-Id: <1344447424-30020-1-git-send-email-zajec5@gmail.com> (sfid-20120808_193713_079234_F1F0CA69)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We can not assume parallel flash is always present, there are boards
with *serial* flash and probably some without flash at all.
Define some bits by the way.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/ssb/driver_mipscore.c             |   28 +++++++++++++++++++++-------
 include/linux/ssb/ssb_driver_chipcommon.h |    4 +++-
 2 files changed, 24 insertions(+), 8 deletions(-)

diff --git a/drivers/ssb/driver_mipscore.c b/drivers/ssb/driver_mipscore.c
index 7e2ddc0..c625086 100644
--- a/drivers/ssb/driver_mipscore.c
+++ b/drivers/ssb/driver_mipscore.c
@@ -190,16 +190,30 @@ static void ssb_mips_flash_detect(struct ssb_mipscore *mcore)
 {
 	struct ssb_bus *bus = mcore->dev->bus;
 
-	mcore->flash_buswidth = 2;
-	if (bus->chipco.dev) {
-		mcore->flash_window = 0x1c000000;
-		mcore->flash_window_size = 0x02000000;
+	/* When there is no chipcommon on the bus there is 4MB flash */
+	if (!bus->chipco.dev) {
+		mcore->flash_buswidth = 2;
+		mcore->flash_window = SSB_FLASH1;
+		mcore->flash_window_size = SSB_FLASH1_SZ;
+		return;
+	}
+
+	/* There is ChipCommon, so use it to read info about flash */
+	switch (bus->chipco.capabilities & SSB_CHIPCO_CAP_FLASHT) {
+	case SSB_CHIPCO_FLASHT_STSER:
+	case SSB_CHIPCO_FLASHT_ATSER:
+		pr_err("Serial flash not supported\n");
+		break;
+	case SSB_CHIPCO_FLASHT_PARA:
+		pr_debug("Found parallel flash\n");
+		mcore->flash_window = SSB_FLASH2;
+		mcore->flash_window_size = SSB_FLASH2_SZ;
 		if ((ssb_read32(bus->chipco.dev, SSB_CHIPCO_FLASH_CFG)
 		               & SSB_CHIPCO_CFG_DS16) == 0)
 			mcore->flash_buswidth = 1;
-	} else {
-		mcore->flash_window = 0x1fc00000;
-		mcore->flash_window_size = 0x00400000;
+		else
+			mcore->flash_buswidth = 2;
+		break;
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

