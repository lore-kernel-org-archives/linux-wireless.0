Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:61077 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084Ab1LKBO5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Dec 2011 20:14:57 -0500
Received: by mail-ee0-f46.google.com with SMTP id c4so976078eek.19
        for <linux-wireless@vger.kernel.org>; Sat, 10 Dec 2011 17:14:56 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 7/7] b43: N-PHY: implement spurious tone avoidance
Date: Sun, 11 Dec 2011 02:55:35 +0100
Message-Id: <1323568535-2816-8-git-send-email-zajec5@gmail.com> (sfid-20111211_021459_811648_AC4E09FD)
In-Reply-To: <1323568535-2816-1-git-send-email-zajec5@gmail.com>
References: <1323568535-2816-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_n.c |   90 +++++++++++++++++++++++++++++++++++++-
 1 files changed, 88 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 114c413..6e776d0 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -4023,6 +4023,58 @@ int b43_phy_initn(struct b43_wldev *dev)
 	return 0;
 }
 
+static void b43_nphy_pmu_spur_avoid(struct b43_wldev *dev, bool avoid)
+{
+	struct bcma_drv_cc *cc = &dev->dev->bdev->bus->drv_cc;
+	u32 pmu_ctl;
+	if (dev->dev->chip_id == 43224 || dev->dev->chip_id == 43225) {
+		if (avoid) {
+			bcma_chipco_pll_write(cc, 0x0, 0x11500010);
+			bcma_chipco_pll_write(cc, 0x1, 0x000C0C06);
+			bcma_chipco_pll_write(cc, 0x2, 0x0F600a08);
+			bcma_chipco_pll_write(cc, 0x3, 0x00000000);
+			bcma_chipco_pll_write(cc, 0x4, 0x2001E920);
+			bcma_chipco_pll_write(cc, 0x5, 0x88888815);
+		} else {
+			bcma_chipco_pll_write(cc, 0x0, 0x11100010);
+			bcma_chipco_pll_write(cc, 0x1, 0x000c0c06);
+			bcma_chipco_pll_write(cc, 0x2, 0x03000a08);
+			bcma_chipco_pll_write(cc, 0x3, 0x00000000);
+			bcma_chipco_pll_write(cc, 0x4, 0x200005c0);
+			bcma_chipco_pll_write(cc, 0x5, 0x88888815);
+		}
+		pmu_ctl = BCMA_CC_PMU_CTL_PLL_UPD;
+	} else if (dev->dev->chip_id == 0x4716) {
+		if (avoid) {
+			bcma_chipco_pll_write(cc, 0x0, 0x11500060);
+			bcma_chipco_pll_write(cc, 0x1, 0x080C0C06);
+			bcma_chipco_pll_write(cc, 0x2, 0x0F600000);
+			bcma_chipco_pll_write(cc, 0x3, 0x00000000);
+			bcma_chipco_pll_write(cc, 0x4, 0x2001E924);
+			bcma_chipco_pll_write(cc, 0x5, 0x88888815);
+		} else {
+			bcma_chipco_pll_write(cc, 0x0, 0x11100060);
+			bcma_chipco_pll_write(cc, 0x1, 0x080c0c06);
+			bcma_chipco_pll_write(cc, 0x2, 0x03000000);
+			bcma_chipco_pll_write(cc, 0x3, 0x00000000);
+			bcma_chipco_pll_write(cc, 0x4, 0x200005c0);
+			bcma_chipco_pll_write(cc, 0x5, 0x88888815);
+		}
+		pmu_ctl = BCMA_CC_PMU_CTL_PLL_UPD | BCMA_CC_PMU_CTL_NOILPONW;
+	} else if (dev->dev->chip_id == 0x4322 || dev->dev->chip_id == 0x4340 ||
+		   dev->dev->chip_id == 0x4341) {
+		bcma_chipco_pll_write(cc, 0x0, 0x11100070);
+		bcma_chipco_pll_write(cc, 0x1, 0x1014140a);
+		bcma_chipco_pll_write(cc, 0x5, 0x88888854);
+		if (avoid)
+			bcma_chipco_pll_write(cc, 0x2, 0x05201828);
+		else
+			bcma_chipco_pll_write(cc, 0x2, 0x05001828);
+		pmu_ctl = BCMA_CC_PMU_CTL_PLL_UPD;
+	}
+	bcma_cc_set32(cc, BCMA_CC_PMU_CTL, pmu_ctl);
+}
+
 /* http://bcm-v4.sipsolutions.net/802.11/PHY/N/ChanspecSetup */
 static void b43_nphy_channel_setup(struct b43_wldev *dev,
 				const struct b43_phy_n_sfo_cfg *e,
@@ -4030,6 +4082,7 @@ static void b43_nphy_channel_setup(struct b43_wldev *dev,
 {
 	struct b43_phy *phy = &dev->phy;
 	struct b43_phy_n *nphy = dev->phy.n;
+	int ch = new_channel->hw_value;
 
 	u16 old_band_5ghz;
 	u32 tmp32;
@@ -4069,8 +4122,41 @@ static void b43_nphy_channel_setup(struct b43_wldev *dev,
 
 	b43_nphy_tx_lp_fbw(dev);
 
-	if (dev->phy.rev >= 3 && 0) {
-		/* TODO */
+	if (dev->phy.rev >= 3 &&
+	    dev->phy.n->spur_avoid != B43_SPUR_AVOID_DISABLE) {
+		bool avoid = false;
+		if (dev->phy.n->spur_avoid == B43_SPUR_AVOID_FORCE) {
+			avoid = true;
+		} else if (!b43_channel_type_is_40mhz(phy->channel_type)) {
+			if ((ch >= 5 && ch <= 8) || ch == 13 || ch == 14)
+				avoid = true;
+		} else { /* 40MHz */
+			if (nphy->aband_spurwar_en &&
+			    (ch == 38 || ch == 102 || ch == 118))
+				avoid = dev->dev->chip_id == 0x4716;
+		}
+
+		b43_nphy_pmu_spur_avoid(dev, avoid);
+
+		if (dev->dev->chip_id == 43222 || dev->dev->chip_id == 43224 ||
+		    dev->dev->chip_id == 43225) {
+			b43_write16(dev, B43_MMIO_TSF_CLK_FRAC_LOW,
+				    avoid ? 0x5341 : 0x8889);
+			b43_write16(dev, B43_MMIO_TSF_CLK_FRAC_HIGH, 0x8);
+		}
+
+		if (dev->phy.rev == 3 || dev->phy.rev == 4)
+			; /* TODO: reset PLL */
+
+		if (avoid)
+			b43_phy_set(dev, B43_NPHY_BBCFG, B43_NPHY_BBCFG_RSTRX);
+		else
+			b43_phy_mask(dev, B43_NPHY_BBCFG,
+				     ~B43_NPHY_BBCFG_RSTRX & 0xFFFF);
+
+		b43_nphy_reset_cca(dev);
+
+		/* wl sets useless phy_isspuravoid here */
 	}
 
 	b43_phy_write(dev, B43_NPHY_NDATAT_DUP40, 0x3830);
-- 
1.7.3.4

