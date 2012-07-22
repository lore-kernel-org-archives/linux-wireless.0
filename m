Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:38766 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752118Ab2GVQvV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Jul 2012 12:51:21 -0400
Received: by weyx8 with SMTP id x8so3745193wey.19
        for <linux-wireless@vger.kernel.org>; Sun, 22 Jul 2012 09:51:20 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Cc: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [RFT][PATCH 3/3] ssb: check for flash presentence
Date: Sun, 22 Jul 2012 18:51:29 +0200
Message-Id: <1342975889-32687-4-git-send-email-zajec5@gmail.com> (sfid-20120722_185125_944941_DD8D3C68)
In-Reply-To: <1342975889-32687-1-git-send-email-zajec5@gmail.com>
References: <1342975889-32687-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We can not assume parallel flash is always present, there are boards
with *serial* flash and probably some without flash at all.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/ssb/driver_mipscore.c |   28 ++++++++++++++++++++++------
 1 files changed, 22 insertions(+), 6 deletions(-)

diff --git a/drivers/ssb/driver_mipscore.c b/drivers/ssb/driver_mipscore.c
index 873bc0a..266a4c8 100644
--- a/drivers/ssb/driver_mipscore.c
+++ b/drivers/ssb/driver_mipscore.c
@@ -190,16 +190,32 @@ static void ssb_mips_flash_detect(struct ssb_mipscore *mcore)
 {
 	struct ssb_bus *bus = mcore->dev->bus;
 
-	bus->chipco.pflash.buswidth = 2;
-	if (bus->chipco.dev) {
+	/* When there is no chipcommon on the bus there is 4MB flash */
+	if (!bus->chipco.dev) {
+		bus->chipco.pflash.buswidth = 2;
+		bus->chipco.pflash.window = SSB_FLASH1;
+		bus->chipco.pflash.window_size = SSB_FLASH1_SZ;
+		return;
+	}
+
+	/* Read info about flash from the ChipCommon */
+	switch (bus->chipco.capabilities & SSB_CHIPCO_CAP_FLASHT) {
+	case SSB_CHIPCO_FLASHT_STSER:
+	case SSB_CHIPCO_FLASHT_ATSER:
+		pr_err("Serial flash not supported\n");
+		break;
+	case SSB_CHIPCO_FLASHT_PARA:
+		pr_info("Found parallel flash\n");
 		bus->chipco.pflash.window = SSB_FLASH2;
 		bus->chipco.pflash.window_size = SSB_FLASH2_SZ;
 		if ((ssb_read32(bus->chipco.dev, SSB_CHIPCO_FLASH_CFG)
-		               & SSB_CHIPCO_CFG_DS16) == 0)
+		     & SSB_CHIPCO_CFG_DS16) == 0)
 			bus->chipco.pflash.buswidth = 1;
-	} else {
-		bus->chipco.pflash.window = SSB_FLASH1;
-		bus->chipco.pflash.window_size = SSB_FLASH1_SZ;
+		else
+			bus->chipco.pflash.buswidth = 2;
+		break;
+	default:
+		pr_err("Flash type not supported\n");
 	}
 }
 
-- 
1.7.7

