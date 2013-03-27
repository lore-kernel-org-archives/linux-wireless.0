Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:37134 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753777Ab3C0QXe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Mar 2013 12:23:34 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: zajec5@gmail.com, linux-wireless@vger.kernel.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/4] bcma: handle more devices in bcma_pmu_get_alp_clock()
Date: Wed, 27 Mar 2013 17:23:10 +0100
Message-Id: <1364401392-30360-3-git-send-email-hauke@hauke-m.de> (sfid-20130327_172355_974261_8985840E)
In-Reply-To: <1364401392-30360-1-git-send-email-hauke@hauke-m.de>
References: <1364401392-30360-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add some more chip IDs to bcma_pmu_get_alp_clock()

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/bcma/driver_chipcommon_pmu.c        |   24 ++++++++++++++++++++----
 include/linux/bcma/bcma_driver_chipcommon.h |    1 +
 2 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/drivers/bcma/driver_chipcommon_pmu.c b/drivers/bcma/driver_chipcommon_pmu.c
index 7e88fff..edca73a 100644
--- a/drivers/bcma/driver_chipcommon_pmu.c
+++ b/drivers/bcma/driver_chipcommon_pmu.c
@@ -174,19 +174,35 @@ u32 bcma_pmu_get_alp_clock(struct bcma_drv_cc *cc)
 	struct bcma_bus *bus = cc->core->bus;
 
 	switch (bus->chipinfo.id) {
+	case BCMA_CHIP_ID_BCM4313:
+	case BCMA_CHIP_ID_BCM43224:
+	case BCMA_CHIP_ID_BCM43225:
+	case BCMA_CHIP_ID_BCM43227:
+	case BCMA_CHIP_ID_BCM43228:
+	case BCMA_CHIP_ID_BCM4331:
+	case BCMA_CHIP_ID_BCM43421:
+	case BCMA_CHIP_ID_BCM43428:
+	case BCMA_CHIP_ID_BCM43431:
 	case BCMA_CHIP_ID_BCM4716:
-	case BCMA_CHIP_ID_BCM4748:
 	case BCMA_CHIP_ID_BCM47162:
-	case BCMA_CHIP_ID_BCM4313:
-	case BCMA_CHIP_ID_BCM5357:
+	case BCMA_CHIP_ID_BCM4748:
 	case BCMA_CHIP_ID_BCM4749:
+	case BCMA_CHIP_ID_BCM5357:
 	case BCMA_CHIP_ID_BCM53572:
+	case BCMA_CHIP_ID_BCM6362:
 		/* always 20Mhz */
 		return 20000 * 1000;
-	case BCMA_CHIP_ID_BCM5356:
 	case BCMA_CHIP_ID_BCM4706:
+	case BCMA_CHIP_ID_BCM5356:
 		/* always 25Mhz */
 		return 25000 * 1000;
+	case BCMA_CHIP_ID_BCM43460:
+	case BCMA_CHIP_ID_BCM4352:
+	case BCMA_CHIP_ID_BCM4360:
+		if (cc->status & BCMA_CC_CHIPST_4360_XTAL_40MZ)
+			return 40000 * 1000;
+		else
+			return 20000 * 1000;
 	default:
 		bcma_warn(bus, "No ALP clock specified for %04X device, pmu rev. %d, using default %d Hz\n",
 			  bus->chipinfo.id, cc->pmu.rev, BCMA_CC_PMU_ALP_CLOCK);
diff --git a/include/linux/bcma/bcma_driver_chipcommon.h b/include/linux/bcma/bcma_driver_chipcommon.h
index 8390c47..1db4c6d 100644
--- a/include/linux/bcma/bcma_driver_chipcommon.h
+++ b/include/linux/bcma/bcma_driver_chipcommon.h
@@ -104,6 +104,7 @@
 #define  BCMA_CC_CHIPST_4706_MIPS_BENDIAN	BIT(3) /* 0: little, 1: big endian */
 #define  BCMA_CC_CHIPST_4706_PCIE1_DISABLE	BIT(5) /* PCIE1 enable strap pin */
 #define  BCMA_CC_CHIPST_5357_NAND_BOOT		BIT(4) /* NAND boot, valid for CC rev 38 and/or BCM5357 */
+#define  BCMA_CC_CHIPST_4360_XTAL_40MZ		0x00000001
 #define BCMA_CC_JCMD			0x0030		/* Rev >= 10 only */
 #define  BCMA_CC_JCMD_START		0x80000000
 #define  BCMA_CC_JCMD_BUSY		0x80000000
-- 
1.7.10.4

