Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:59012 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757448Ab2I2SeD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Sep 2012 14:34:03 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, zajec5@gmail.com,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 3/5] bcma: mark nflash if it is the boot flash
Date: Sat, 29 Sep 2012 20:33:51 +0200
Message-Id: <1348943633-22800-4-git-send-email-hauke@hauke-m.de> (sfid-20120929_203409_891212_640D9479)
In-Reply-To: <1348943633-22800-1-git-send-email-hauke@hauke-m.de>
References: <1348943633-22800-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There are some devices which are able to boot from nand flash and other
are using a serial flash for booting. Add a bool to indicate that the
device is booted from that flash chip and not from some other chip also
connected to the SoC. This is needed to find the nvram, as it is stored
on the flash the devices booted from.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/bcma/driver_chipcommon_nflash.c     |    3 +++
 include/linux/bcma/bcma_driver_chipcommon.h |    1 +
 2 files changed, 4 insertions(+)

diff --git a/drivers/bcma/driver_chipcommon_nflash.c b/drivers/bcma/driver_chipcommon_nflash.c
index 9042781..dbda91e 100644
--- a/drivers/bcma/driver_chipcommon_nflash.c
+++ b/drivers/bcma/driver_chipcommon_nflash.c
@@ -32,6 +32,9 @@ int bcma_nflash_init(struct bcma_drv_cc *cc)
 	}
 
 	cc->nflash.present = true;
+	if (cc->core->id.rev == 38 &&
+	    (cc->status & BCMA_CC_CHIPST_5357_NAND_BOOT))
+		cc->nflash.boot = true;
 
 	/* Prepare platform device, but don't register it yet. It's too early,
 	 * malloc (required by device_private_init) is not available yet. */
diff --git a/include/linux/bcma/bcma_driver_chipcommon.h b/include/linux/bcma/bcma_driver_chipcommon.h
index b9d7eeb..175d0a0 100644
--- a/include/linux/bcma/bcma_driver_chipcommon.h
+++ b/include/linux/bcma/bcma_driver_chipcommon.h
@@ -531,6 +531,7 @@ struct mtd_info;
 
 struct bcma_nflash {
 	bool present;
+	bool boot;		/* This is the flash the SoC boots from */
 
 	struct mtd_info *mtd;
 };
-- 
1.7.9.5

