Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f182.google.com ([209.85.217.182]:34499 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083AbcBLJQA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Feb 2016 04:16:00 -0500
Received: by mail-lb0-f182.google.com with SMTP id uq3so6002909lbc.1
        for <linux-wireless@vger.kernel.org>; Fri, 12 Feb 2016 01:15:59 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 3/3] bcma: move flash detection code to ChipCommon core driver
Date: Fri, 12 Feb 2016 10:15:45 +0100
Message-Id: <1455268545-11667-3-git-send-email-zajec5@gmail.com> (sfid-20160212_101605_287351_BBA2D48E)
In-Reply-To: <1455268545-11667-1-git-send-email-zajec5@gmail.com>
References: <1455268545-11667-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Flashes are attached and accessible through ChipCommon core, they aren't
connected to MIPS one. Moreover some new ARM devices (e.g. BCM47189) may
have serial flash accessibility using ChipCommon registers as well. To
support them we can't keep this code in MIPS core driver.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/bcma/driver_chipcommon.c | 30 ++++++++++++++++++++++++++++++
 drivers/bcma/driver_mips.c       | 27 ++-------------------------
 2 files changed, 32 insertions(+), 25 deletions(-)

diff --git a/drivers/bcma/driver_chipcommon.c b/drivers/bcma/driver_chipcommon.c
index b0f44a2..921ce18 100644
--- a/drivers/bcma/driver_chipcommon.c
+++ b/drivers/bcma/driver_chipcommon.c
@@ -115,6 +115,33 @@ int bcma_chipco_watchdog_register(struct bcma_drv_cc *cc)
 	return 0;
 }
 
+static void bcma_core_chipcommon_flash_detect(struct bcma_drv_cc *cc)
+{
+	struct bcma_bus *bus = cc->core->bus;
+
+	switch (cc->capabilities & BCMA_CC_CAP_FLASHT) {
+	case BCMA_CC_FLASHT_STSER:
+	case BCMA_CC_FLASHT_ATSER:
+		bcma_debug(bus, "Found serial flash\n");
+		bcma_sflash_init(cc);
+		break;
+	case BCMA_CC_FLASHT_PARA:
+		bcma_debug(bus, "Found parallel flash\n");
+		bcma_pflash_init(cc);
+		break;
+	default:
+		bcma_err(bus, "Flash type not supported\n");
+	}
+
+	if (cc->core->id.rev == 38 ||
+	    bus->chipinfo.id == BCMA_CHIP_ID_BCM4706) {
+		if (cc->capabilities & BCMA_CC_CAP_NFLASH) {
+			bcma_debug(bus, "Found NAND flash\n");
+			bcma_nflash_init(cc);
+		}
+	}
+}
+
 void bcma_core_chipcommon_early_init(struct bcma_drv_cc *cc)
 {
 	struct bcma_bus *bus = cc->core->bus;
@@ -136,6 +163,9 @@ void bcma_core_chipcommon_early_init(struct bcma_drv_cc *cc)
 	if (IS_BUILTIN(CONFIG_BCM47XX) && bus->hosttype == BCMA_HOSTTYPE_SOC)
 		bcma_chipco_serial_init(cc);
 
+	if (bus->hosttype == BCMA_HOSTTYPE_SOC)
+		bcma_core_chipcommon_flash_detect(cc);
+
 	cc->early_setup_done = true;
 }
 
diff --git a/drivers/bcma/driver_mips.c b/drivers/bcma/driver_mips.c
index 967b0e8..96f1713 100644
--- a/drivers/bcma/driver_mips.c
+++ b/drivers/bcma/driver_mips.c
@@ -250,34 +250,11 @@ static enum bcma_boot_dev bcma_boot_dev(struct bcma_bus *bus)
 	return BCMA_BOOT_DEV_SERIAL;
 }
 
-static void bcma_core_mips_flash_detect(struct bcma_drv_mips *mcore)
+static void bcma_core_mips_nvram_init(struct bcma_drv_mips *mcore)
 {
 	struct bcma_bus *bus = mcore->core->bus;
-	struct bcma_drv_cc *cc = &bus->drv_cc;
 	enum bcma_boot_dev boot_dev;
 
-	switch (cc->capabilities & BCMA_CC_CAP_FLASHT) {
-	case BCMA_CC_FLASHT_STSER:
-	case BCMA_CC_FLASHT_ATSER:
-		bcma_debug(bus, "Found serial flash\n");
-		bcma_sflash_init(cc);
-		break;
-	case BCMA_CC_FLASHT_PARA:
-		bcma_debug(bus, "Found parallel flash\n");
-		bcma_pflash_init(cc);
-		break;
-	default:
-		bcma_err(bus, "Flash type not supported\n");
-	}
-
-	if (cc->core->id.rev == 38 ||
-	    bus->chipinfo.id == BCMA_CHIP_ID_BCM4706) {
-		if (cc->capabilities & BCMA_CC_CAP_NFLASH) {
-			bcma_debug(bus, "Found NAND flash\n");
-			bcma_nflash_init(cc);
-		}
-	}
-
 	/* Determine flash type this SoC boots from */
 	boot_dev = bcma_boot_dev(bus);
 	switch (boot_dev) {
@@ -304,7 +281,7 @@ void bcma_core_mips_early_init(struct bcma_drv_mips *mcore)
 	if (mcore->early_setup_done)
 		return;
 
-	bcma_core_mips_flash_detect(mcore);
+	bcma_core_mips_nvram_init(mcore);
 
 	mcore->early_setup_done = true;
 }
-- 
1.8.4.5

