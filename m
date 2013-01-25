Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f173.google.com ([74.125.82.173]:57019 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756156Ab3AYKgi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jan 2013 05:36:38 -0500
Received: by mail-we0-f173.google.com with SMTP id r5so103580wey.18
        for <linux-wireless@vger.kernel.org>; Fri, 25 Jan 2013 02:36:36 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH RESEND 1/2] ssb: trivial: use pflash helper variable
Date: Fri, 25 Jan 2013 11:36:25 +0100
Message-Id: <1359110186-30526-1-git-send-email-zajec5@gmail.com> (sfid-20130125_113701_712951_1B8491C8)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
RESEND just for sure, as earlier I asked to drop patch 0002
---
 drivers/ssb/driver_mipscore.c |   19 ++++++++++---------
 1 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/ssb/driver_mipscore.c b/drivers/ssb/driver_mipscore.c
index 2a7684c..77bc8d4 100644
--- a/drivers/ssb/driver_mipscore.c
+++ b/drivers/ssb/driver_mipscore.c
@@ -189,13 +189,14 @@ static void ssb_mips_serial_init(struct ssb_mipscore *mcore)
 static void ssb_mips_flash_detect(struct ssb_mipscore *mcore)
 {
 	struct ssb_bus *bus = mcore->dev->bus;
+	struct ssb_pflash *pflash = &mcore->pflash;
 
 	/* When there is no chipcommon on the bus there is 4MB flash */
 	if (!ssb_chipco_available(&bus->chipco)) {
-		mcore->pflash.present = true;
-		mcore->pflash.buswidth = 2;
-		mcore->pflash.window = SSB_FLASH1;
-		mcore->pflash.window_size = SSB_FLASH1_SZ;
+		pflash->present = true;
+		pflash->buswidth = 2;
+		pflash->window = SSB_FLASH1;
+		pflash->window_size = SSB_FLASH1_SZ;
 		return;
 	}
 
@@ -208,14 +209,14 @@ static void ssb_mips_flash_detect(struct ssb_mipscore *mcore)
 		break;
 	case SSB_CHIPCO_FLASHT_PARA:
 		pr_debug("Found parallel flash\n");
-		mcore->pflash.present = true;
-		mcore->pflash.window = SSB_FLASH2;
-		mcore->pflash.window_size = SSB_FLASH2_SZ;
+		pflash->present = true;
+		pflash->window = SSB_FLASH2;
+		pflash->window_size = SSB_FLASH2_SZ;
 		if ((ssb_read32(bus->chipco.dev, SSB_CHIPCO_FLASH_CFG)
 		               & SSB_CHIPCO_CFG_DS16) == 0)
-			mcore->pflash.buswidth = 1;
+			pflash->buswidth = 1;
 		else
-			mcore->pflash.buswidth = 2;
+			pflash->buswidth = 2;
 		break;
 	}
 }
-- 
1.7.7

