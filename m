Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:54701 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754246AbZJSGdm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Oct 2009 02:33:42 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [RFT 12/15] ath9k_hw: make spur mitigation a callback
Date: Mon, 19 Oct 2009 02:33:43 -0400
Message-Id: <1255934026-20686-13-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1255934026-20686-1-git-send-email-lrodriguez@atheros.com>
References: <1255934026-20686-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This only differs between single-chip solutions and non single-chip
solutions.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c |   17 ++++++-----------
 drivers/net/wireless/ath/ath9k/hw.h |    5 +++++
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 68f5bbc..65c106b 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -952,8 +952,11 @@ int ath9k_hw_init(struct ath_hw *ah)
 	if (AR_SREV_9280_10_OR_LATER(ah)) {
 		ah->ani_function &= ~ATH9K_ANI_NOISE_IMMUNITY_LEVEL;
 		ah->ath9k_hw_rf_set_freq = &ath9k_hw_ar9280_set_channel;
-	} else
+		ah->ath9k_hw_spur_mitigate_freq = &ath9k_hw_9280_spur_mitigate;
+	} else {
 		ah->ath9k_hw_rf_set_freq = &ath9k_hw_set_channel;
+		ah->ath9k_hw_spur_mitigate_freq = &ath9k_hw_spur_mitigate;
+	}
 
 	ath9k_hw_init_mode_regs(ah);
 
@@ -1916,10 +1919,7 @@ static bool ath9k_hw_channel_change(struct ath_hw *ah,
 	if (IS_CHAN_OFDM(chan) || IS_CHAN_HT(chan))
 		ath9k_hw_set_delta_slope(ah, chan);
 
-	if (AR_SREV_9280_10_OR_LATER(ah))
-		ath9k_hw_9280_spur_mitigate(ah, chan);
-	else
-		ath9k_hw_spur_mitigate(ah, chan);
+	ah->ath9k_hw_spur_mitigate_freq(ah, chan);
 
 	if (!chan->oneTimeCalsDone)
 		chan->oneTimeCalsDone = true;
@@ -2052,13 +2052,8 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 	if (IS_CHAN_OFDM(chan) || IS_CHAN_HT(chan))
 		ath9k_hw_set_delta_slope(ah, chan);
 
-	if (AR_SREV_9280_10_OR_LATER(ah))
-		ath9k_hw_9280_spur_mitigate(ah, chan);
-	else
-		ath9k_hw_spur_mitigate(ah, chan);
-
+	ah->ath9k_hw_spur_mitigate_freq(ah, chan);
 	ah->eep_ops->set_board_values(ah, chan);
-
 	ath9k_hw_decrease_chain_power(ah, chan);
 
 	REG_WRITE(ah, AR_STA_ID0, get_unaligned_le32(common->macaddr));
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 7c97e5f..936ef5b 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -550,6 +550,11 @@ struct ath_hw {
 
 	/* Callback for radio frequency change */
 	int (*ath9k_hw_rf_set_freq)(struct ath_hw *ah, struct ath9k_channel *chan);
+
+	/* Callback for baseband spur frequency */
+	void (*ath9k_hw_spur_mitigate_freq)(struct ath_hw *ah,
+					    struct ath9k_channel *chan);
+
 	/* Used to program the radio on non single-chip devices */
 	u32 *analogBank0Data;
 	u32 *analogBank1Data;
-- 
1.6.0.4

