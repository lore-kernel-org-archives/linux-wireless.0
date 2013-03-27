Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:37128 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753695Ab3C0QXd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Mar 2013 12:23:33 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: zajec5@gmail.com, linux-wireless@vger.kernel.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/4] bcma: use BCMA_CC_PMU_CTL_* constants
Date: Wed, 27 Mar 2013 17:23:09 +0100
Message-Id: <1364401392-30360-2-git-send-email-hauke@hauke-m.de> (sfid-20130327_172405_627523_095E6E83)
In-Reply-To: <1364401392-30360-1-git-send-email-hauke@hauke-m.de>
References: <1364401392-30360-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Instead of hard coding these values use the existing constants.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/bcma/driver_chipcommon_pmu.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/bcma/driver_chipcommon_pmu.c b/drivers/bcma/driver_chipcommon_pmu.c
index 932b101..7e88fff 100644
--- a/drivers/bcma/driver_chipcommon_pmu.c
+++ b/drivers/bcma/driver_chipcommon_pmu.c
@@ -373,7 +373,7 @@ void bcma_pmu_spuravoid_pllupdate(struct bcma_drv_cc *cc, int spuravoid)
 		tmp |= (bcm5357_bcm43236_ndiv[spuravoid]) << BCMA_CC_PMU1_PLL0_PC2_NDIV_INT_SHIFT;
 		bcma_cc_write32(cc, BCMA_CC_PLLCTL_DATA, tmp);
 
-		tmp = 1 << 10;
+		tmp = BCMA_CC_PMU_CTL_PLL_UPD;
 		break;
 
 	case BCMA_CHIP_ID_BCM4331:
@@ -394,7 +394,7 @@ void bcma_pmu_spuravoid_pllupdate(struct bcma_drv_cc *cc, int spuravoid)
 			bcma_pmu_spuravoid_pll_write(cc, BCMA_CC_PMU_PLL_CTL2,
 						     0x03000a08);
 		}
-		tmp = 1 << 10;
+		tmp = BCMA_CC_PMU_CTL_PLL_UPD;
 		break;
 
 	case BCMA_CHIP_ID_BCM43224:
@@ -427,7 +427,7 @@ void bcma_pmu_spuravoid_pllupdate(struct bcma_drv_cc *cc, int spuravoid)
 			bcma_pmu_spuravoid_pll_write(cc, BCMA_CC_PMU_PLL_CTL5,
 						     0x88888815);
 		}
-		tmp = 1 << 10;
+		tmp = BCMA_CC_PMU_CTL_PLL_UPD;
 		break;
 
 	case BCMA_CHIP_ID_BCM4716:
@@ -461,7 +461,7 @@ void bcma_pmu_spuravoid_pllupdate(struct bcma_drv_cc *cc, int spuravoid)
 						     0x88888815);
 		}
 
-		tmp = 3 << 9;
+		tmp = BCMA_CC_PMU_CTL_PLL_UPD | BCMA_CC_PMU_CTL_NOILPONW;
 		break;
 
 	case BCMA_CHIP_ID_BCM43227:
@@ -497,7 +497,7 @@ void bcma_pmu_spuravoid_pllupdate(struct bcma_drv_cc *cc, int spuravoid)
 			bcma_pmu_spuravoid_pll_write(cc, BCMA_CC_PMU_PLL_CTL5,
 						     0x88888815);
 		}
-		tmp = 1 << 10;
+		tmp = BCMA_CC_PMU_CTL_PLL_UPD;
 		break;
 	default:
 		bcma_err(bus, "Unknown spuravoidance settings for chip 0x%04X, not changing PLL\n",
-- 
1.7.10.4

