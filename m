Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:55171 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757314Ab3DXTbG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Apr 2013 15:31:06 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: zajec5@gmail.com, linux-wireless@vger.kernel.org,
	b43-dev@lists.infradead.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH v2] ssb: implement ssb spuravoid for chipid BCM43222
Date: Wed, 24 Apr 2013 21:30:54 +0200
Message-Id: <1366831854-19634-1-git-send-email-hauke@hauke-m.de> (sfid-20130424_213110_962625_4AD65392)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
Acked-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/ssb/driver_chipcommon_pmu.c |   19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/ssb/driver_chipcommon_pmu.c b/drivers/ssb/driver_chipcommon_pmu.c
index 23c5dbf..1173a09 100644
--- a/drivers/ssb/driver_chipcommon_pmu.c
+++ b/drivers/ssb/driver_chipcommon_pmu.c
@@ -687,8 +687,23 @@ void ssb_pmu_spuravoid_pllupdate(struct ssb_chipcommon *cc, int spuravoid)
 		pmu_ctl = SSB_CHIPCO_PMU_CTL_PLL_UPD;
 		break;
 	case 43222:
-		/* TODO: BCM43222 requires updating PLLs too */
-		return;
+		if (spuravoid == 1) {
+			ssb_chipco_pll_write(cc, SSB_PMU1_PLLCTL0, 0x11500008);
+			ssb_chipco_pll_write(cc, SSB_PMU1_PLLCTL1, 0x0C000C06);
+			ssb_chipco_pll_write(cc, SSB_PMU1_PLLCTL2, 0x0F600a08);
+			ssb_chipco_pll_write(cc, SSB_PMU1_PLLCTL3, 0x00000000);
+			ssb_chipco_pll_write(cc, SSB_PMU1_PLLCTL4, 0x2001E920);
+			ssb_chipco_pll_write(cc, SSB_PMU1_PLLCTL5, 0x88888815);
+		} else {
+			ssb_chipco_pll_write(cc, SSB_PMU1_PLLCTL0, 0x11100008);
+			ssb_chipco_pll_write(cc, SSB_PMU1_PLLCTL1, 0x0c000c06);
+			ssb_chipco_pll_write(cc, SSB_PMU1_PLLCTL2, 0x03000a08);
+			ssb_chipco_pll_write(cc, SSB_PMU1_PLLCTL3, 0x00000000);
+			ssb_chipco_pll_write(cc, SSB_PMU1_PLLCTL4, 0x200005c0);
+			ssb_chipco_pll_write(cc, SSB_PMU1_PLLCTL5, 0x88888855);
+		}
+		pmu_ctl = SSB_CHIPCO_PMU_CTL_PLL_UPD;
+		break;
 	default:
 		ssb_printk(KERN_ERR PFX
 			   "Unknown spuravoidance settings for chip 0x%04X, not changing PLL\n",
-- 
1.7.10.4

