Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:60819 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933388Ab1IOMXN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Sep 2011 08:23:13 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.atheros.com
Subject: [PATCH 4/4] ath9k_hw: remove ar9100_hw_compute_pll_control
Date: Thu, 15 Sep 2011 14:22:57 +0200
Message-Id: <1316089377-86019-4-git-send-email-nbd@openwrt.org> (sfid-20110915_142318_369176_1AE15F7B)
In-Reply-To: <1316089377-86019-3-git-send-email-nbd@openwrt.org>
References: <1316089377-86019-1-git-send-email-nbd@openwrt.org>
 <1316089377-86019-2-git-send-email-nbd@openwrt.org>
 <1316089377-86019-3-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

AR913x uses the same PLL register layout as AR9160 and later.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar5008_phy.c |   12 +-----------
 1 files changed, 1 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar5008_phy.c b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
index 794a2d9..0a749c8 100644
--- a/drivers/net/wireless/ath/ath9k/ar5008_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
@@ -1010,14 +1010,6 @@ static void ar5008_restore_chainmask(struct ath_hw *ah)
 	}
 }
 
-static u32 ar9100_hw_compute_pll_control(struct ath_hw *ah,
-					 struct ath9k_channel *chan)
-{
-	if (chan && IS_CHAN_5GHZ(chan))
-		return 0x1450;
-	return 0x1458;
-}
-
 static u32 ar9160_hw_compute_pll_control(struct ath_hw *ah,
 					 struct ath9k_channel *chan)
 {
@@ -1656,9 +1648,7 @@ void ar5008_hw_attach_phy_ops(struct ath_hw *ah)
 	} else
 		priv_ops->ani_control = ar5008_hw_ani_control_old;
 
-	if (AR_SREV_9100(ah))
-		priv_ops->compute_pll_control = ar9100_hw_compute_pll_control;
-	else if (AR_SREV_9160_10_OR_LATER(ah))
+	if (AR_SREV_9100(ah) || AR_SREV_9160_10_OR_LATER(ah))
 		priv_ops->compute_pll_control = ar9160_hw_compute_pll_control;
 	else
 		priv_ops->compute_pll_control = ar5008_hw_compute_pll_control;
-- 
1.7.3.2

