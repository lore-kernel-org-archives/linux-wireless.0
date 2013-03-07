Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f41.google.com ([74.125.83.41]:50335 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932407Ab3CGPrt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Mar 2013 10:47:49 -0500
Received: by mail-ee0-f41.google.com with SMTP id c13so458398eek.28
        for <linux-wireless@vger.kernel.org>; Thu, 07 Mar 2013 07:47:48 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 04/13] b43: HT-PHY: implement spurious tone avoidance
Date: Thu,  7 Mar 2013 16:47:18 +0100
Message-Id: <1362671247-10766-5-git-send-email-zajec5@gmail.com> (sfid-20130307_164752_586467_99A450F2)
In-Reply-To: <1362671247-10766-1-git-send-email-zajec5@gmail.com>
References: <1362671247-10766-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On N-PHY it's also done after TX power fix, so it was easy to spot.
Unfortunately the MMIO logs I have from ndsiwrapper include channels
1-12 only, so enabling code for 13 and 14 is just a N-PHY-based guess.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_ht.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/net/wireless/b43/phy_ht.c b/drivers/net/wireless/b43/phy_ht.c
index f7463aa..4ccd371 100644
--- a/drivers/net/wireless/b43/phy_ht.c
+++ b/drivers/net/wireless/b43/phy_ht.c
@@ -285,6 +285,24 @@ static void b43_phy_ht_tx_power_fix(struct b43_wldev *dev)
  * Channel switching ops.
  **************************************************/
 
+static void b43_phy_ht_spur_avoid(struct b43_wldev *dev,
+				  struct ieee80211_channel *new_channel)
+{
+	struct bcma_device *core = dev->dev->bdev;
+	int spuravoid = 0;
+
+	/* Check for 13 and 14 is just a guess, we don't have enough logs. */
+	if (new_channel->hw_value == 13 || new_channel->hw_value == 14)
+		spuravoid = 1;
+	bcma_core_pll_ctl(core, B43_BCMA_CLKCTLST_PHY_PLL_REQ, 0, false);
+	bcma_pmu_spuravoid_pllupdate(&core->bus->drv_cc, spuravoid);
+	bcma_core_pll_ctl(core,
+			  B43_BCMA_CLKCTLST_80211_PLL_REQ |
+			  B43_BCMA_CLKCTLST_PHY_PLL_REQ,
+			  B43_BCMA_CLKCTLST_80211_PLL_ST |
+			  B43_BCMA_CLKCTLST_PHY_PLL_ST, false);
+}
+
 static void b43_phy_ht_channel_setup(struct b43_wldev *dev,
 				const struct b43_phy_ht_channeltab_e_phy *e,
 				struct ieee80211_channel *new_channel)
@@ -318,6 +336,8 @@ static void b43_phy_ht_channel_setup(struct b43_wldev *dev,
 	if (1) /* TODO: On N it's for early devices only, what about HT? */
 		b43_phy_ht_tx_power_fix(dev);
 
+	b43_phy_ht_spur_avoid(dev, new_channel);
+
 	b43_phy_write(dev, 0x017e, 0x3830);
 }
 
-- 
1.7.10.4

