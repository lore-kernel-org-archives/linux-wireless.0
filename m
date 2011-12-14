Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:43930 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727Ab1LNOPY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Dec 2011 09:15:24 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: zajec5@gmail.com, "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] b43: avoid calling bcma_* if CONFIG_B43_BCMA is not set
Date: Wed, 14 Dec 2011 09:08:28 -0500
Message-Id: <1323871708-19852-1-git-send-email-linville@tuxdriver.com> (sfid-20111214_151528_022203_A48B706D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Avoids this:

ERROR: "bcma_chipco_pll_write" [drivers/net/wireless/b43/b43.ko] undefined!

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
It looks like phy_lcn.c could use some bits like this as well...

 drivers/net/wireless/b43/phy_n.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 6b95fd2..154f97d 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -4048,6 +4048,7 @@ int b43_phy_initn(struct b43_wldev *dev)
 /* http://bcm-v4.sipsolutions.net/802.11/PmuSpurAvoid */
 static void b43_nphy_pmu_spur_avoid(struct b43_wldev *dev, bool avoid)
 {
+#ifdef CONFIG_B43_BCMA
 	struct bcma_drv_cc *cc = &dev->dev->bdev->bus->drv_cc;
 	u32 pmu_ctl;
 	if (dev->dev->chip_id == 43224 || dev->dev->chip_id == 43225) {
@@ -4098,6 +4099,9 @@ static void b43_nphy_pmu_spur_avoid(struct b43_wldev *dev, bool avoid)
 		return;
 	}
 	bcma_cc_set32(cc, BCMA_CC_PMU_CTL, pmu_ctl);
+#else
+	return;
+#endif
 }
 
 /* http://bcm-v4.sipsolutions.net/802.11/PHY/N/ChanspecSetup */
-- 
1.7.4.4

