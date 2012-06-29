Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:52521 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755446Ab2F2XqT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jun 2012 19:46:19 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: zajec5@gmail.com, b43-dev@lists.infradead.org, arend@broadcom.com,
	linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH v2 6/9] bcma: remove bcma_pmu_{pll,swreg}_init()
Date: Sat, 30 Jun 2012 01:44:42 +0200
Message-Id: <1341013486-2520-7-git-send-email-hauke@hauke-m.de> (sfid-20120630_014623_954144_7E1373AA)
In-Reply-To: <1341013486-2520-1-git-send-email-hauke@hauke-m.de>
References: <1341013486-2520-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These functions are doing nothing in the current code.

I do not think we will need these function in the future as the
corresponding functions in the Broadcom SDK are just doing something
useful on chips supported by ssb or fullmac chips.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/bcma/driver_chipcommon_pmu.c |   34 ----------------------------------
 1 file changed, 34 deletions(-)

diff --git a/drivers/bcma/driver_chipcommon_pmu.c b/drivers/bcma/driver_chipcommon_pmu.c
index a8fcdf0..069fca7 100644
--- a/drivers/bcma/driver_chipcommon_pmu.c
+++ b/drivers/bcma/driver_chipcommon_pmu.c
@@ -54,22 +54,6 @@ void bcma_chipco_regctl_maskset(struct bcma_drv_cc *cc, u32 offset, u32 mask,
 }
 EXPORT_SYMBOL_GPL(bcma_chipco_regctl_maskset);
 
-static void bcma_pmu_pll_init(struct bcma_drv_cc *cc)
-{
-	struct bcma_bus *bus = cc->core->bus;
-
-	switch (bus->chipinfo.id) {
-	case BCMA_CHIP_ID_BCM4313:
-	case BCMA_CHIP_ID_BCM4331:
-	case BCMA_CHIP_ID_BCM43224:
-	case BCMA_CHIP_ID_BCM43225:
-		break;
-	default:
-		pr_err("PLL init unknown for device 0x%04X\n",
-			bus->chipinfo.id);
-	}
-}
-
 static void bcma_pmu_resources_init(struct bcma_drv_cc *cc)
 {
 	struct bcma_bus *bus = cc->core->bus;
@@ -96,22 +80,6 @@ static void bcma_pmu_resources_init(struct bcma_drv_cc *cc)
 		bcma_cc_write32(cc, BCMA_CC_PMU_MAXRES_MSK, max_msk);
 }
 
-void bcma_pmu_swreg_init(struct bcma_drv_cc *cc)
-{
-	struct bcma_bus *bus = cc->core->bus;
-
-	switch (bus->chipinfo.id) {
-	case BCMA_CHIP_ID_BCM4313:
-	case BCMA_CHIP_ID_BCM4331:
-	case BCMA_CHIP_ID_BCM43224:
-	case BCMA_CHIP_ID_BCM43225:
-		break;
-	default:
-		pr_err("PMU switch/regulators init unknown for device "
-			"0x%04X\n", bus->chipinfo.id);
-	}
-}
-
 /* Disable to allow reading SPROM. Don't know the adventages of enabling it. */
 void bcma_chipco_bcm4331_ext_pa_lines_ctl(struct bcma_drv_cc *cc, bool enable)
 {
@@ -192,9 +160,7 @@ void bcma_pmu_init(struct bcma_drv_cc *cc)
 		bcma_cc_set32(cc, BCMA_CC_PMU_CTL,
 			     BCMA_CC_PMU_CTL_NOILPONW);
 
-	bcma_pmu_pll_init(cc);
 	bcma_pmu_resources_init(cc);
-	bcma_pmu_swreg_init(cc);
 	bcma_pmu_workarounds(cc);
 }
 
-- 
1.7.9.5

