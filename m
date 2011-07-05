Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:53661 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752885Ab1GEDLn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Jul 2011 23:11:43 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, ath5k-devel@lists.ath5k.org,
	mickflemm@gmail.com
Subject: [PATCH v2 2/8] ath5k: apply the synth voltage tweak only on AR5112 rev 2
Date: Tue,  5 Jul 2011 10:11:18 +0700
Message-Id: <1309835484-26653-2-git-send-email-nbd@openwrt.org> (sfid-20110705_051154_940864_20CCC043)
In-Reply-To: <1309835484-26653-1-git-send-email-nbd@openwrt.org>
References: <1309835484-26653-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Might fix some stability issues on newer chips

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Acked-by: Nick Kossifidis <mickflemm@gmail.com>
---
 drivers/net/wireless/ath/ath5k/phy.c |   19 +++++++++++--------
 1 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/phy.c b/drivers/net/wireless/ath/ath5k/phy.c
index d0bfcad..a28ef9e 100644
--- a/drivers/net/wireless/ath/ath5k/phy.c
+++ b/drivers/net/wireless/ath/ath5k/phy.c
@@ -970,17 +970,20 @@ static int ath5k_hw_rfregs_init(struct ath5k_hw *ah,
 			}
 
 			/* Lower synth voltage on Rev 2 */
-			ath5k_hw_rfb_op(ah, rf_regs, 2,
-					AR5K_RF_HIGH_VC_CP, true);
+			if (ah->ah_radio == AR5K_RF5112 &&
+			    (ah->ah_radio_5ghz_revision & AR5K_SREV_REV) > 0) {
+				ath5k_hw_rfb_op(ah, rf_regs, 2,
+						AR5K_RF_HIGH_VC_CP, true);
 
-			ath5k_hw_rfb_op(ah, rf_regs, 2,
-					AR5K_RF_MID_VC_CP, true);
+				ath5k_hw_rfb_op(ah, rf_regs, 2,
+						AR5K_RF_MID_VC_CP, true);
 
-			ath5k_hw_rfb_op(ah, rf_regs, 2,
-					AR5K_RF_LOW_VC_CP, true);
+				ath5k_hw_rfb_op(ah, rf_regs, 2,
+						AR5K_RF_LOW_VC_CP, true);
 
-			ath5k_hw_rfb_op(ah, rf_regs, 2,
-					AR5K_RF_PUSH_UP, true);
+				ath5k_hw_rfb_op(ah, rf_regs, 2,
+						AR5K_RF_PUSH_UP, true);
+			}
 
 			/* Decrease power consumption on 5213+ BaseBand */
 			if (ah->ah_phy_revision >= AR5K_SREV_PHY_5212A) {
-- 
1.7.3.2

