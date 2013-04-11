Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:48117 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750950Ab3DKMjZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Apr 2013 08:39:25 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: zajec5@gmail.com, linux-wireless@vger.kernel.org,
	b43-dev@lists.infradead.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] b43: use bcma_pmu_spuravoid_pllupdate()
Date: Thu, 11 Apr 2013 14:39:13 +0200
Message-Id: <1365683953-3430-1-git-send-email-hauke@hauke-m.de> (sfid-20130411_143929_113631_43624BD6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Do not implement this in b43, but use bcma_pmu_spuravoid_pllupdate().

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/net/wireless/b43/phy_n.c |   86 +++++++-------------------------------
 1 file changed, 14 insertions(+), 72 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 7b557ad..05945da 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -5097,77 +5097,6 @@ static void b43_chantab_phy_upload(struct b43_wldev *dev,
 	b43_phy_write(dev, B43_NPHY_BW6, e->phy_bw6);
 }
 
-/* http://bcm-v4.sipsolutions.net/802.11/PmuSpurAvoid */
-static void b43_nphy_pmu_spur_avoid(struct b43_wldev *dev, bool avoid)
-{
-	struct bcma_drv_cc __maybe_unused *cc;
-	u32 __maybe_unused pmu_ctl;
-
-	switch (dev->dev->bus_type) {
-#ifdef CONFIG_B43_BCMA
-	case B43_BUS_BCMA:
-		cc = &dev->dev->bdev->bus->drv_cc;
-		if (dev->dev->chip_id == 43224 || dev->dev->chip_id == 43225) {
-			if (avoid) {
-				bcma_chipco_pll_write(cc, 0x0, 0x11500010);
-				bcma_chipco_pll_write(cc, 0x1, 0x000C0C06);
-				bcma_chipco_pll_write(cc, 0x2, 0x0F600a08);
-				bcma_chipco_pll_write(cc, 0x3, 0x00000000);
-				bcma_chipco_pll_write(cc, 0x4, 0x2001E920);
-				bcma_chipco_pll_write(cc, 0x5, 0x88888815);
-			} else {
-				bcma_chipco_pll_write(cc, 0x0, 0x11100010);
-				bcma_chipco_pll_write(cc, 0x1, 0x000c0c06);
-				bcma_chipco_pll_write(cc, 0x2, 0x03000a08);
-				bcma_chipco_pll_write(cc, 0x3, 0x00000000);
-				bcma_chipco_pll_write(cc, 0x4, 0x200005c0);
-				bcma_chipco_pll_write(cc, 0x5, 0x88888815);
-			}
-			pmu_ctl = BCMA_CC_PMU_CTL_PLL_UPD;
-		} else if (dev->dev->chip_id == 0x4716) {
-			if (avoid) {
-				bcma_chipco_pll_write(cc, 0x0, 0x11500060);
-				bcma_chipco_pll_write(cc, 0x1, 0x080C0C06);
-				bcma_chipco_pll_write(cc, 0x2, 0x0F600000);
-				bcma_chipco_pll_write(cc, 0x3, 0x00000000);
-				bcma_chipco_pll_write(cc, 0x4, 0x2001E924);
-				bcma_chipco_pll_write(cc, 0x5, 0x88888815);
-			} else {
-				bcma_chipco_pll_write(cc, 0x0, 0x11100060);
-				bcma_chipco_pll_write(cc, 0x1, 0x080c0c06);
-				bcma_chipco_pll_write(cc, 0x2, 0x03000000);
-				bcma_chipco_pll_write(cc, 0x3, 0x00000000);
-				bcma_chipco_pll_write(cc, 0x4, 0x200005c0);
-				bcma_chipco_pll_write(cc, 0x5, 0x88888815);
-			}
-			pmu_ctl = BCMA_CC_PMU_CTL_PLL_UPD |
-				  BCMA_CC_PMU_CTL_NOILPONW;
-		} else if (dev->dev->chip_id == 0x4322 ||
-			   dev->dev->chip_id == 0x4340 ||
-			   dev->dev->chip_id == 0x4341) {
-			bcma_chipco_pll_write(cc, 0x0, 0x11100070);
-			bcma_chipco_pll_write(cc, 0x1, 0x1014140a);
-			bcma_chipco_pll_write(cc, 0x5, 0x88888854);
-			if (avoid)
-				bcma_chipco_pll_write(cc, 0x2, 0x05201828);
-			else
-				bcma_chipco_pll_write(cc, 0x2, 0x05001828);
-			pmu_ctl = BCMA_CC_PMU_CTL_PLL_UPD;
-		} else {
-			return;
-		}
-		bcma_cc_set32(cc, BCMA_CC_PMU_CTL, pmu_ctl);
-		break;
-#endif
-#ifdef CONFIG_B43_SSB
-	case B43_BUS_SSB:
-		ssb_pmu_spuravoid_pllupdate(&dev->dev->sdev->bus->chipco,
-					    avoid);
-		break;
-#endif
-	}
-}
-
 /* http://bcm-v4.sipsolutions.net/802.11/PHY/N/ChanspecSetup */
 static void b43_nphy_channel_setup(struct b43_wldev *dev,
 				const struct b43_phy_n_sfo_cfg *e,
@@ -5229,7 +5158,20 @@ static void b43_nphy_channel_setup(struct b43_wldev *dev,
 				avoid = dev->dev->chip_id == 0x4716;
 		}
 
-		b43_nphy_pmu_spur_avoid(dev, avoid);
+		switch (dev->dev->bus_type) {
+#ifdef CONFIG_B43_BCMA
+		case B43_BUS_BCMA:
+			bcma_pmu_spuravoid_pllupdate(&dev->dev->bdev->bus->drv_cc,
+						     avoid);
+			break;
+#endif
+#ifdef CONFIG_B43_SSB
+		case B43_BUS_SSB:
+			ssb_pmu_spuravoid_pllupdate(&dev->dev->sdev->bus->chipco,
+						    avoid);
+			break;
+#endif
+		}
 
 		if (dev->dev->chip_id == 43222 || dev->dev->chip_id == 43224 ||
 		    dev->dev->chip_id == 43225) {
-- 
1.7.10.4

