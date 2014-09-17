Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f178.google.com ([74.125.82.178]:54120 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756219AbaIQVvI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Sep 2014 17:51:08 -0400
Received: by mail-we0-f178.google.com with SMTP id q58so2115412wes.37
        for <linux-wireless@vger.kernel.org>; Wed, 17 Sep 2014 14:51:07 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] bcma: print chip ID in a more user-friendly form
Date: Wed, 17 Sep 2014 23:50:55 +0200
Message-Id: <1410990655-2884-1-git-send-email-zajec5@gmail.com> (sfid-20140917_235115_343244_753F2EA7)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some chip IDs are easier to read/understand when printed in a decimal
form. For example on my bcm53xx arch router this patch replaces:
Found chip with id 0xCF12, rev 0x00 and package 0x02
with a:
Found chip with id 53010, rev 0x00 and package 0x02

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/bcma/scan.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/bcma/scan.c b/drivers/bcma/scan.c
index b3a403c..14b5656 100644
--- a/drivers/bcma/scan.c
+++ b/drivers/bcma/scan.c
@@ -439,6 +439,7 @@ void bcma_init_bus(struct bcma_bus *bus)
 {
 	s32 tmp;
 	struct bcma_chipinfo *chipinfo = &(bus->chipinfo);
+	char chip_id[8];
 
 	INIT_LIST_HEAD(&bus->cores);
 	bus->nr_cores = 0;
@@ -449,8 +450,11 @@ void bcma_init_bus(struct bcma_bus *bus)
 	chipinfo->id = (tmp & BCMA_CC_ID_ID) >> BCMA_CC_ID_ID_SHIFT;
 	chipinfo->rev = (tmp & BCMA_CC_ID_REV) >> BCMA_CC_ID_REV_SHIFT;
 	chipinfo->pkg = (tmp & BCMA_CC_ID_PKG) >> BCMA_CC_ID_PKG_SHIFT;
-	bcma_info(bus, "Found chip with id 0x%04X, rev 0x%02X and package 0x%02X\n",
-		  chipinfo->id, chipinfo->rev, chipinfo->pkg);
+
+	snprintf(chip_id, ARRAY_SIZE(chip_id),
+		 (chipinfo->id > 0x9999) ? "%d" : "0x%04X", chipinfo->id);
+	bcma_info(bus, "Found chip with id %s, rev 0x%02X and package 0x%02X\n",
+		  chip_id, chipinfo->rev, chipinfo->pkg);
 }
 
 int bcma_bus_scan(struct bcma_bus *bus)
-- 
1.8.4.5

