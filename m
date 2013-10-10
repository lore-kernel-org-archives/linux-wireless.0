Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:37372 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751791Ab3JJMPV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Oct 2013 08:15:21 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Subject: [PATCH 03/10] ath9k_hw: remove IS_CHAN_B()
Date: Thu, 10 Oct 2013 14:15:05 +0200
Message-Id: <1381407312-72719-3-git-send-email-nbd@openwrt.org> (sfid-20131010_141531_320628_50105444)
In-Reply-To: <1381407312-72719-1-git-send-email-nbd@openwrt.org>
References: <1381407312-72719-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hardware 802.11b-only mode isn't supported by the driver (the device is
configured for 802.11n/g instead). Simplify the code by removing checks
for it.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar5008_phy.c   | 6 ++++--
 drivers/net/wireless/ath/ath9k/ar9002_calib.c | 7 ++-----
 drivers/net/wireless/ath/ath9k/ar9003_phy.c   | 6 ++++--
 drivers/net/wireless/ath/ath9k/hw.c           | 9 ++-------
 drivers/net/wireless/ath/ath9k/hw.h           | 1 -
 drivers/net/wireless/ath/ath9k/mac.c          | 6 +-----
 6 files changed, 13 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar5008_phy.c b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
index 2bfa6fb..b197bf2 100644
--- a/drivers/net/wireless/ath/ath9k/ar5008_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
@@ -794,8 +794,10 @@ static void ar5008_hw_set_rfmode(struct ath_hw *ah, struct ath9k_channel *chan)
 	if (chan == NULL)
 		return;
 
-	rfMode |= (IS_CHAN_B(chan) || IS_CHAN_G(chan))
-		? AR_PHY_MODE_DYNAMIC : AR_PHY_MODE_OFDM;
+	if (IS_CHAN_2GHZ(chan))
+		rfMode |= AR_PHY_MODE_DYNAMIC;
+	else
+		rfMode |= AR_PHY_MODE_OFDM;
 
 	if (!AR_SREV_9280_20_OR_LATER(ah))
 		rfMode |= (IS_CHAN_5GHZ(chan)) ?
diff --git a/drivers/net/wireless/ath/ath9k/ar9002_calib.c b/drivers/net/wireless/ath/ath9k/ar9002_calib.c
index 32376ad..cdc7400 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_calib.c
@@ -33,15 +33,12 @@ static bool ar9002_hw_is_cal_supported(struct ath_hw *ah,
 	bool supported = false;
 	switch (ah->supp_cals & cal_type) {
 	case IQ_MISMATCH_CAL:
-		/* Run IQ Mismatch for non-CCK only */
-		if (!IS_CHAN_B(chan))
-			supported = true;
+		supported = true;
 		break;
 	case ADC_GAIN_CAL:
 	case ADC_DC_CAL:
 		/* Run ADC Gain Cal for non-CCK & non 2GHz-HT20 only */
-		if (!IS_CHAN_B(chan) &&
-		    !((IS_CHAN_2GHZ(chan) || IS_CHAN_A_FAST_CLOCK(ah, chan)) &&
+		if (!((IS_CHAN_2GHZ(chan) || IS_CHAN_A_FAST_CLOCK(ah, chan)) &&
 		      IS_CHAN_HT20(chan)))
 			supported = true;
 		break;
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index 7249844..312c868 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -808,8 +808,10 @@ static void ar9003_hw_set_rfmode(struct ath_hw *ah,
 	if (chan == NULL)
 		return;
 
-	rfMode |= (IS_CHAN_B(chan) || IS_CHAN_G(chan))
-		? AR_PHY_MODE_DYNAMIC : AR_PHY_MODE_OFDM;
+	if (IS_CHAN_2GHZ(chan))
+		rfMode |= AR_PHY_MODE_DYNAMIC;
+	else
+		rfMode |= AR_PHY_MODE_OFDM;
 
 	if (IS_CHAN_A_FAST_CLOCK(ah, chan))
 		rfMode |= (AR_PHY_MODE_DYNAMIC | AR_PHY_MODE_DYN_CCK_DISABLE);
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 7c4d600..34c8e2e 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -190,10 +190,7 @@ EXPORT_SYMBOL(ath9k_hw_wait);
 void ath9k_hw_synth_delay(struct ath_hw *ah, struct ath9k_channel *chan,
 			  int hw_delay)
 {
-	if (IS_CHAN_B(chan))
-		hw_delay = (4 * hw_delay) / 22;
-	else
-		hw_delay /= 10;
+	hw_delay /= 10;
 
 	if (IS_CHAN_HALF_RATE(chan))
 		hw_delay *= 2;
@@ -1159,9 +1156,7 @@ u32 ath9k_regd_get_ctl(struct ath_regulatory *reg, struct ath9k_channel *chan)
 {
 	u32 ctl = ath_regd_get_band_ctl(reg, chan->chan->band);
 
-	if (IS_CHAN_B(chan))
-		ctl |= CTL_11B;
-	else if (IS_CHAN_G(chan))
+	if (IS_CHAN_G(chan))
 		ctl |= CTL_11G;
 	else
 		ctl |= CTL_11A;
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 102b3b6..eaaf98b 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -455,7 +455,6 @@ struct ath9k_channel {
 	 ((_ah)->caps.hw_caps & ATH9K_HW_CAP_FASTCLOCK))
 
 /* These macros check chanmode and not channelFlags */
-#define IS_CHAN_B(_c) ((_c)->chanmode == CHANNEL_B)
 #define IS_CHAN_HT20(_c) (((_c)->chanmode == CHANNEL_A_HT20) ||	\
 			  ((_c)->chanmode == CHANNEL_G_HT20))
 #define IS_CHAN_HT40(_c) (((_c)->chanmode == CHANNEL_A_HT40PLUS) ||	\
diff --git a/drivers/net/wireless/ath/ath9k/mac.c b/drivers/net/wireless/ath/ath9k/mac.c
index a3eff09..6a18f9d 100644
--- a/drivers/net/wireless/ath/ath9k/mac.c
+++ b/drivers/net/wireless/ath/ath9k/mac.c
@@ -374,7 +374,6 @@ EXPORT_SYMBOL(ath9k_hw_releasetxqueue);
 bool ath9k_hw_resettxqueue(struct ath_hw *ah, u32 q)
 {
 	struct ath_common *common = ath9k_hw_common(ah);
-	struct ath9k_channel *chan = ah->curchan;
 	struct ath9k_tx_queue_info *qi;
 	u32 cwMin, chanCwMin, value;
 
@@ -387,10 +386,7 @@ bool ath9k_hw_resettxqueue(struct ath_hw *ah, u32 q)
 	ath_dbg(common, QUEUE, "Reset TX queue: %u\n", q);
 
 	if (qi->tqi_cwmin == ATH9K_TXQ_USEDEFAULT) {
-		if (chan && IS_CHAN_B(chan))
-			chanCwMin = INIT_CWMIN_11B;
-		else
-			chanCwMin = INIT_CWMIN;
+		chanCwMin = INIT_CWMIN;
 
 		for (cwMin = 1; cwMin < chanCwMin; cwMin = (cwMin << 1) | 1);
 	} else
-- 
1.8.0.2

