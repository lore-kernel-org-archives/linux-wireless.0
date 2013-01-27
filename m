Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f54.google.com ([209.85.214.54]:53609 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756045Ab3A0Nad (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Jan 2013 08:30:33 -0500
Received: by mail-bk0-f54.google.com with SMTP id w5so911589bku.13
        for <linux-wireless@vger.kernel.org>; Sun, 27 Jan 2013 05:30:32 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH][FIX] bcma: fix NAND flash validation
Date: Sun, 27 Jan 2013 14:30:29 +0100
Message-Id: <1359293429-14387-1-git-send-email-zajec5@gmail.com> (sfid-20130127_143038_656622_52A5406B)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
John: can we get this for 3.8?
---
 drivers/bcma/driver_chipcommon_nflash.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/bcma/driver_chipcommon_nflash.c b/drivers/bcma/driver_chipcommon_nflash.c
index dbda91e..1f0b83e 100644
--- a/drivers/bcma/driver_chipcommon_nflash.c
+++ b/drivers/bcma/driver_chipcommon_nflash.c
@@ -21,7 +21,7 @@ int bcma_nflash_init(struct bcma_drv_cc *cc)
 	struct bcma_bus *bus = cc->core->bus;
 
 	if (bus->chipinfo.id != BCMA_CHIP_ID_BCM4706 &&
-	    cc->core->id.rev != 0x38) {
+	    cc->core->id.rev != 38) {
 		bcma_err(bus, "NAND flash on unsupported board!\n");
 		return -ENOTSUPP;
 	}
-- 
1.7.7

