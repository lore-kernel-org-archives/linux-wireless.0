Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:54726 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754009AbZJSGdr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Oct 2009 02:33:47 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [RFT 10/15] ath9k_hw: use a callback for frequency change
Date: Mon, 19 Oct 2009 02:33:41 -0400
Message-Id: <1255934026-20686-11-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1255934026-20686-1-git-send-email-lrodriguez@atheros.com>
References: <1255934026-20686-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This avoids a branch on every channel change.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c |   15 ++++++---------
 drivers/net/wireless/ath/ath9k/hw.h |    4 +++-
 2 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index e27be74..e0d696d 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -951,8 +951,11 @@ int ath9k_hw_init(struct ath_hw *ah)
 	ath9k_hw_init_cal_settings(ah);
 
 	ah->ani_function = ATH9K_ANI_ALL;
-	if (AR_SREV_9280_10_OR_LATER(ah))
+	if (AR_SREV_9280_10_OR_LATER(ah)) {
 		ah->ani_function &= ~ATH9K_ANI_NOISE_IMMUNITY_LEVEL;
+		ah->ath9k_hw_rf_set_freq = &ath9k_hw_ar9280_set_channel;
+	} else
+		ah->ath9k_hw_rf_set_freq = &ath9k_hw_set_channel;
 
 	ath9k_hw_init_mode_regs(ah);
 
@@ -1888,10 +1891,7 @@ static bool ath9k_hw_channel_change(struct ath_hw *ah,
 
 	ath9k_hw_set_regs(ah, chan);
 
-	if (AR_SREV_9280_10_OR_LATER(ah))
-		r = ath9k_hw_ar9280_set_channel(ah, chan);
-	else
-		r = ath9k_hw_set_channel(ah, chan);
+	r = ah->ath9k_hw_rf_set_freq(ah, chan);
 	if (r) {
 		ath_print(common, ATH_DBG_FATAL,
 			  "Failed to set channel\n");
@@ -2533,10 +2533,7 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 
 	REG_WRITE(ah, AR_RSSI_THR, INIT_RSSI_THR);
 
-	if (AR_SREV_9280_10_OR_LATER(ah))
-		r = ath9k_hw_ar9280_set_channel(ah, chan);
-	else
-		r = ath9k_hw_set_channel(ah, chan);
+	r = ah->ath9k_hw_rf_set_freq(ah, chan);
 	if (r)
 		return r;
 
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index f9eb57b..7c97e5f 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -548,7 +548,9 @@ struct ath_hw {
 		DONT_USE_32KHZ,
 	} enable_32kHz_clock;
 
-	/* RF */
+	/* Callback for radio frequency change */
+	int (*ath9k_hw_rf_set_freq)(struct ath_hw *ah, struct ath9k_channel *chan);
+	/* Used to program the radio on non single-chip devices */
 	u32 *analogBank0Data;
 	u32 *analogBank1Data;
 	u32 *analogBank2Data;
-- 
1.6.0.4

