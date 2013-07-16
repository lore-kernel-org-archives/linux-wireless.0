Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:60922 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175Ab3GPGgu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jul 2013 02:36:50 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 6/6] ath9k: Release the RF bus after setting board values
Date: Tue, 16 Jul 2013 12:03:22 +0530
Message-Id: <1373956402-22169-6-git-send-email-sujith@msujith.org> (sfid-20130716_083655_103161_26CFF01E)
In-Reply-To: <1373956402-22169-1-git-send-email-sujith@msujith.org>
References: <1373956402-22169-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/hw.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 1dac46d..ebc9f53 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1498,7 +1498,7 @@ static bool ath9k_hw_channel_change(struct ath_hw *ah,
 	struct ath_common *common = ath9k_hw_common(ah);
 	struct ath9k_hw_capabilities *pCap = &ah->caps;
 	bool band_switch = false, mode_diff = false;
-	u8 ini_reloaded;
+	u8 ini_reloaded = 0;
 	u32 qnum;
 	int r;
 
@@ -1544,22 +1544,21 @@ static bool ath9k_hw_channel_change(struct ath_hw *ah,
 	}
 	ath9k_hw_set_clockrate(ah);
 	ath9k_hw_apply_txpower(ah, chan, false);
-	ath9k_hw_rfbus_done(ah);
 
 	if (IS_CHAN_OFDM(chan) || IS_CHAN_HT(chan))
 		ath9k_hw_set_delta_slope(ah, chan);
 
 	ath9k_hw_spur_mitigate_freq(ah, chan);
 
-	if (band_switch || mode_diff) {
-		ah->ah_flags |= AH_FASTCC;
-		if (band_switch || ini_reloaded)
-			ah->eep_ops->set_board_values(ah, chan);
+	if (band_switch || ini_reloaded)
+		ah->eep_ops->set_board_values(ah, chan);
 
-		ath9k_hw_init_bb(ah, chan);
+	ath9k_hw_init_bb(ah, chan);
+	ath9k_hw_rfbus_done(ah);
 
-		if (band_switch || ini_reloaded)
-			ath9k_hw_init_cal(ah, chan);
+	if (band_switch || ini_reloaded) {
+		ah->ah_flags |= AH_FASTCC;
+		ath9k_hw_init_cal(ah, chan);
 		ah->ah_flags &= ~AH_FASTCC;
 	}
 
-- 
1.8.3.2

