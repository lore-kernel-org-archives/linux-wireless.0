Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:62022 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287Ab1LONQV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Dec 2011 08:16:21 -0500
Received: by eekc4 with SMTP id c4so2047873eek.19
        for <linux-wireless@vger.kernel.org>; Thu, 15 Dec 2011 05:16:20 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] b43: N-PHY: check for bustype before touching BCMA CC PLLs
Date: Thu, 15 Dec 2011 14:17:21 +0100
Message-Id: <1323955041-23950-1-git-send-email-zajec5@gmail.com> (sfid-20111215_141624_834143_AA89636F)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Reported-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_n.c |  107 +++++++++++++++++++++----------------
 1 files changed, 61 insertions(+), 46 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 6b95fd2..c8fa2cd 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -4048,56 +4048,71 @@ int b43_phy_initn(struct b43_wldev *dev)
 /* http://bcm-v4.sipsolutions.net/802.11/PmuSpurAvoid */
 static void b43_nphy_pmu_spur_avoid(struct b43_wldev *dev, bool avoid)
 {
-	struct bcma_drv_cc *cc = &dev->dev->bdev->bus->drv_cc;
+	struct bcma_drv_cc *cc;
 	u32 pmu_ctl;
-	if (dev->dev->chip_id == 43224 || dev->dev->chip_id == 43225) {
-		if (avoid) {
-			bcma_chipco_pll_write(cc, 0x0, 0x11500010);
-			bcma_chipco_pll_write(cc, 0x1, 0x000C0C06);
-			bcma_chipco_pll_write(cc, 0x2, 0x0F600a08);
-			bcma_chipco_pll_write(cc, 0x3, 0x00000000);
-			bcma_chipco_pll_write(cc, 0x4, 0x2001E920);
-			bcma_chipco_pll_write(cc, 0x5, 0x88888815);
-		} else {
-			bcma_chipco_pll_write(cc, 0x0, 0x11100010);
-			bcma_chipco_pll_write(cc, 0x1, 0x000c0c06);
-			bcma_chipco_pll_write(cc, 0x2, 0x03000a08);
-			bcma_chipco_pll_write(cc, 0x3, 0x00000000);
-			bcma_chipco_pll_write(cc, 0x4, 0x200005c0);
-			bcma_chipco_pll_write(cc, 0x5, 0x88888815);
-		}
-		pmu_ctl = BCMA_CC_PMU_CTL_PLL_UPD;
-	} else if (dev->dev->chip_id == 0x4716) {
-		if (avoid) {
-			bcma_chipco_pll_write(cc, 0x0, 0x11500060);
-			bcma_chipco_pll_write(cc, 0x1, 0x080C0C06);
-			bcma_chipco_pll_write(cc, 0x2, 0x0F600000);
-			bcma_chipco_pll_write(cc, 0x3, 0x00000000);
-			bcma_chipco_pll_write(cc, 0x4, 0x2001E924);
-			bcma_chipco_pll_write(cc, 0x5, 0x88888815);
+
+	switch (dev->dev->bus_type) {
+#ifdef CONFIG_B43_BCMA
+	case B43_BUS_BCMA:
+		cc = &dev->dev->bdev->bus->drv_cc;
+		if (dev->dev->chip_id == 43224 || dev->dev->chip_id == 43225) {
+			if (avoid) {
+				bcma_chipco_pll_write(cc, 0x0, 0x11500010);
+				bcma_chipco_pll_write(cc, 0x1, 0x000C0C06);
+				bcma_chipco_pll_write(cc, 0x2, 0x0F600a08);
+				bcma_chipco_pll_write(cc, 0x3, 0x00000000);
+				bcma_chipco_pll_write(cc, 0x4, 0x2001E920);
+				bcma_chipco_pll_write(cc, 0x5, 0x88888815);
+			} else {
+				bcma_chipco_pll_write(cc, 0x0, 0x11100010);
+				bcma_chipco_pll_write(cc, 0x1, 0x000c0c06);
+				bcma_chipco_pll_write(cc, 0x2, 0x03000a08);
+				bcma_chipco_pll_write(cc, 0x3, 0x00000000);
+				bcma_chipco_pll_write(cc, 0x4, 0x200005c0);
+				bcma_chipco_pll_write(cc, 0x5, 0x88888815);
+			}
+			pmu_ctl = BCMA_CC_PMU_CTL_PLL_UPD;
+		} else if (dev->dev->chip_id == 0x4716) {
+			if (avoid) {
+				bcma_chipco_pll_write(cc, 0x0, 0x11500060);
+				bcma_chipco_pll_write(cc, 0x1, 0x080C0C06);
+				bcma_chipco_pll_write(cc, 0x2, 0x0F600000);
+				bcma_chipco_pll_write(cc, 0x3, 0x00000000);
+				bcma_chipco_pll_write(cc, 0x4, 0x2001E924);
+				bcma_chipco_pll_write(cc, 0x5, 0x88888815);
+			} else {
+				bcma_chipco_pll_write(cc, 0x0, 0x11100060);
+				bcma_chipco_pll_write(cc, 0x1, 0x080c0c06);
+				bcma_chipco_pll_write(cc, 0x2, 0x03000000);
+				bcma_chipco_pll_write(cc, 0x3, 0x00000000);
+				bcma_chipco_pll_write(cc, 0x4, 0x200005c0);
+				bcma_chipco_pll_write(cc, 0x5, 0x88888815);
+			}
+			pmu_ctl = BCMA_CC_PMU_CTL_PLL_UPD |
+				  BCMA_CC_PMU_CTL_NOILPONW;
+		} else if (dev->dev->chip_id == 0x4322 ||
+			   dev->dev->chip_id == 0x4340 ||
+			   dev->dev->chip_id == 0x4341) {
+			bcma_chipco_pll_write(cc, 0x0, 0x11100070);
+			bcma_chipco_pll_write(cc, 0x1, 0x1014140a);
+			bcma_chipco_pll_write(cc, 0x5, 0x88888854);
+			if (avoid)
+				bcma_chipco_pll_write(cc, 0x2, 0x05201828);
+			else
+				bcma_chipco_pll_write(cc, 0x2, 0x05001828);
+			pmu_ctl = BCMA_CC_PMU_CTL_PLL_UPD;
 		} else {
-			bcma_chipco_pll_write(cc, 0x0, 0x11100060);
-			bcma_chipco_pll_write(cc, 0x1, 0x080c0c06);
-			bcma_chipco_pll_write(cc, 0x2, 0x03000000);
-			bcma_chipco_pll_write(cc, 0x3, 0x00000000);
-			bcma_chipco_pll_write(cc, 0x4, 0x200005c0);
-			bcma_chipco_pll_write(cc, 0x5, 0x88888815);
+			return;
 		}
-		pmu_ctl = BCMA_CC_PMU_CTL_PLL_UPD | BCMA_CC_PMU_CTL_NOILPONW;
-	} else if (dev->dev->chip_id == 0x4322 || dev->dev->chip_id == 0x4340 ||
-		   dev->dev->chip_id == 0x4341) {
-		bcma_chipco_pll_write(cc, 0x0, 0x11100070);
-		bcma_chipco_pll_write(cc, 0x1, 0x1014140a);
-		bcma_chipco_pll_write(cc, 0x5, 0x88888854);
-		if (avoid)
-			bcma_chipco_pll_write(cc, 0x2, 0x05201828);
-		else
-			bcma_chipco_pll_write(cc, 0x2, 0x05001828);
-		pmu_ctl = BCMA_CC_PMU_CTL_PLL_UPD;
-	} else {
-		return;
+		bcma_cc_set32(cc, BCMA_CC_PMU_CTL, pmu_ctl);
+		break;
+#endif
+#ifdef CONFIG_B43_SSB
+	case B43_BUS_SSB:
+		/* FIXME */
+		break;
+#endif
 	}
-	bcma_cc_set32(cc, BCMA_CC_PMU_CTL, pmu_ctl);
 }
 
 /* http://bcm-v4.sipsolutions.net/802.11/PHY/N/ChanspecSetup */
-- 
1.7.7

