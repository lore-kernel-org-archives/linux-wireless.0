Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:40287 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759279Ab3EOOTh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 May 2013 10:19:37 -0400
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCHv2 16/18] ath5k: add and use 5/10 MHz bitrate tables
Date: Wed, 15 May 2013 16:19:07 +0200
Message-Id: <1368627549-22518-17-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20130515_161947_127040_AC3E1D35)
In-Reply-To: <1368627549-22518-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1368627549-22518-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When a reduced bandwidth mode is enabled, the according bitrate tables
must be used instead of the standard tables. This patch adds these
bitrate tables and selects the appropriate table.

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
---
 drivers/net/wireless/ath/ath5k/ath5k.h |   10 +++-
 drivers/net/wireless/ath/ath5k/base.c  |   98 ++++++++++++++++++++++++++++----
 drivers/net/wireless/ath/ath5k/debug.c |   23 ++++++--
 drivers/net/wireless/ath/ath5k/pcu.c   |   30 ++++++++--
 drivers/net/wireless/ath/ath5k/qcu.c   |   23 +++++++-
 5 files changed, 160 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
index 2d691b8..1dee0c4 100644
--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -486,7 +486,9 @@ enum ath5k_bw_mode {
 	AR5K_BWMODE_DEFAULT	= 0,
 	AR5K_BWMODE_5MHZ	= 1,
 	AR5K_BWMODE_10MHZ	= 2,
-	AR5K_BWMODE_40MHZ	= 3
+	AR5K_BWMODE_40MHZ	= 3,
+	AR5K_BWMODE_MAX
+
 };
 
 
@@ -1264,8 +1266,10 @@ struct ath5k_hw {
 	struct ieee80211_hw	*hw;		/* IEEE 802.11 common */
 	struct ieee80211_supported_band sbands[IEEE80211_NUM_BANDS];
 	struct ieee80211_channel channels[ATH_CHAN_MAX];
-	struct ieee80211_rate	rates[IEEE80211_NUM_BANDS][AR5K_MAX_RATES];
-	s8			rate_idx[IEEE80211_NUM_BANDS][AR5K_MAX_RATES];
+	struct ieee80211_rate
+		rates[IEEE80211_NUM_BANDS][AR5K_BWMODE_MAX][AR5K_MAX_RATES];
+	s8
+		rate_idx[IEEE80211_NUM_BANDS][AR5K_BWMODE_MAX][AR5K_MAX_RATES];
 	enum nl80211_iftype	opmode;
 
 #ifdef CONFIG_ATH5K_DEBUG
diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 7f702fe..a4e0b4e 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -330,18 +330,50 @@ ath5k_setup_channels(struct ath5k_hw *ah, struct ieee80211_channel *channels,
 	return count;
 }
 
+static inline void
+ath5k_get_bitrates(int bwmode,
+		   struct ieee80211_supported_band *b,
+		   struct ieee80211_rate **bitrates,
+		   int *n_bitrates)
+{
+	switch (bwmode) {
+	case AR5K_BWMODE_40MHZ:
+		/* 40 MHz not supported in mac80211, fall through to default */
+	case AR5K_BWMODE_DEFAULT:
+		*bitrates = b->bitrates;
+		*n_bitrates = b->n_bitrates;
+		break;
+	case AR5K_BWMODE_5MHZ:
+		*bitrates = b->bitrates_quarter;
+		*n_bitrates = b->n_bitrates_quarter;
+		break;
+	case AR5K_BWMODE_10MHZ:
+		*bitrates = b->bitrates_half;
+		*n_bitrates = b->n_bitrates_half;
+		break;
+	default:
+		BUG_ON(1);
+	}
+}
+
 static void
 ath5k_setup_rate_idx(struct ath5k_hw *ah, struct ieee80211_supported_band *b)
 {
-	u8 i;
+	struct ieee80211_rate *bitrates;
+	int n_bitrates, bwmode;
+	u8 i, val_s;
 
-	for (i = 0; i < AR5K_MAX_RATES; i++)
-		ah->rate_idx[b->band][i] = -1;
+	for (bwmode = 0; bwmode < AR5K_BWMODE_MAX; bwmode++) {
+		for (i = 0; i < AR5K_MAX_RATES; i++)
+			ah->rate_idx[b->band][bwmode][i] = -1;
+		ath5k_get_bitrates(bwmode, b, &bitrates, &n_bitrates);
 
-	for (i = 0; i < b->n_bitrates; i++) {
-		ah->rate_idx[b->band][b->bitrates[i].hw_value] = i;
-		if (b->bitrates[i].hw_value_short)
-			ah->rate_idx[b->band][b->bitrates[i].hw_value_short] = i;
+		for (i = 0; i < n_bitrates; i++) {
+			ah->rate_idx[b->band][bwmode][bitrates[i].hw_value] = i;
+			val_s = bitrates[i].hw_value_short;
+			if (val_s)
+				ah->rate_idx[b->band][bwmode][val_s] = i;
+		}
 	}
 }
 
@@ -359,7 +391,12 @@ ath5k_setup_bands(struct ieee80211_hw *hw)
 	/* 2GHz band */
 	sband = &ah->sbands[IEEE80211_BAND_2GHZ];
 	sband->band = IEEE80211_BAND_2GHZ;
-	sband->bitrates = &ah->rates[IEEE80211_BAND_2GHZ][0];
+	sband->bitrates =
+		&ah->rates[IEEE80211_BAND_2GHZ][AR5K_BWMODE_DEFAULT][0];
+	sband->bitrates_half =
+		&ah->rates[IEEE80211_BAND_2GHZ][AR5K_BWMODE_10MHZ][0];
+	sband->bitrates_quarter =
+		&ah->rates[IEEE80211_BAND_2GHZ][AR5K_BWMODE_5MHZ][0];
 
 	if (test_bit(AR5K_MODE_11G, ah->ah_capabilities.cap_mode)) {
 		/* G mode */
@@ -367,6 +404,19 @@ ath5k_setup_bands(struct ieee80211_hw *hw)
 		       sizeof(struct ieee80211_rate) * 12);
 		sband->n_bitrates = 12;
 
+		memcpy(sband->bitrates_half, &ath5k_rates[4],
+		       sizeof(struct ieee80211_rate) * 8);
+		sband->n_bitrates_half = 8;
+		for (i = 0; i < sband->n_bitrates_half; i++)
+			sband->bitrates_half[i].bitrate /= 2;
+
+		memcpy(sband->bitrates_quarter, &ath5k_rates[4],
+		       sizeof(struct ieee80211_rate) * 8);
+		sband->n_bitrates_quarter = 8;
+		for (i = 0; i < sband->n_bitrates_quarter; i++)
+			sband->bitrates_quarter[i].bitrate /= 4;
+
+
 		sband->channels = ah->channels;
 		sband->n_channels = ath5k_setup_channels(ah, sband->channels,
 					AR5K_MODE_11G, max_c);
@@ -407,12 +457,29 @@ ath5k_setup_bands(struct ieee80211_hw *hw)
 	if (test_bit(AR5K_MODE_11A, ah->ah_capabilities.cap_mode)) {
 		sband = &ah->sbands[IEEE80211_BAND_5GHZ];
 		sband->band = IEEE80211_BAND_5GHZ;
-		sband->bitrates = &ah->rates[IEEE80211_BAND_5GHZ][0];
+		sband->bitrates =
+			&ah->rates[IEEE80211_BAND_5GHZ][AR5K_BWMODE_DEFAULT][0];
+		sband->bitrates_half =
+			&ah->rates[IEEE80211_BAND_5GHZ][AR5K_BWMODE_10MHZ][0];
+		sband->bitrates_quarter =
+			&ah->rates[IEEE80211_BAND_5GHZ][AR5K_BWMODE_5MHZ][0];
 
 		memcpy(sband->bitrates, &ath5k_rates[4],
 		       sizeof(struct ieee80211_rate) * 8);
 		sband->n_bitrates = 8;
 
+		memcpy(sband->bitrates_half, &ath5k_rates[4],
+		       sizeof(struct ieee80211_rate) * 8);
+		sband->n_bitrates_half = 8;
+		for (i = 0; i < sband->n_bitrates_half; i++)
+			sband->bitrates_half[i].bitrate /= 2;
+
+		memcpy(sband->bitrates_quarter, &ath5k_rates[4],
+		       sizeof(struct ieee80211_rate) * 8);
+		sband->n_bitrates_quarter = 8;
+		for (i = 0; i < sband->n_bitrates_quarter; i++)
+			sband->bitrates_quarter[i].bitrate /= 4;
+
 		sband->channels = &ah->channels[count_c];
 		sband->n_channels = ath5k_setup_channels(ah, sband->channels,
 					AR5K_MODE_11A, max_c);
@@ -556,7 +623,7 @@ ath5k_hw_to_driver_rix(struct ath5k_hw *ah, int hw_rix)
 			"hw_rix out of bounds: %x\n", hw_rix))
 		return 0;
 
-	rix = ah->rate_idx[ah->curchan->band][hw_rix];
+	rix = ah->rate_idx[ah->curchan->band][ah->ah_bwmode][hw_rix];
 	if (WARN(rix < 0, "invalid hw_rix: %x\n", hw_rix))
 		rix = 0;
 
@@ -1320,6 +1387,8 @@ ath5k_receive_frame(struct ath5k_hw *ah, struct sk_buff *skb,
 		    struct ath5k_rx_status *rs)
 {
 	struct ieee80211_rx_status *rxs;
+	struct ieee80211_rate *bitrates;
+	int n_bitrates;
 
 	ath5k_remove_padding(skb);
 
@@ -1356,8 +1425,10 @@ ath5k_receive_frame(struct ath5k_hw *ah, struct sk_buff *skb,
 	rxs->rate_idx = ath5k_hw_to_driver_rix(ah, rs->rs_rate);
 	rxs->flag |= ath5k_rx_decrypted(ah, skb, rs);
 
+	ath5k_get_bitrates(ah->ah_bwmode, &ah->sbands[ah->curchan->band],
+			   &bitrates, &n_bitrates);
 	if (rxs->rate_idx >= 0 && rs->rs_rate ==
-	    ah->sbands[ah->curchan->band].bitrates[rxs->rate_idx].hw_value_short)
+	    bitrates[rxs->rate_idx].hw_value_short)
 		rxs->flag |= RX_FLAG_SHORTPRE;
 
 	trace_ath5k_rx(ah, skb);
@@ -2513,6 +2584,11 @@ ath5k_init_ah(struct ath5k_hw *ah, const struct ath_bus_ops *bus_ops)
 					 AR5K_INIT_RETRY_LONG);
 	}
 
+	/* don't enable for the 11B only chips */
+	if (test_bit(AR5K_MODE_11G, ah->ah_capabilities.cap_mode) ||
+	    test_bit(AR5K_MODE_11A, ah->ah_capabilities.cap_mode))
+		hw->wiphy->flags |= WIPHY_FLAG_SUPPORTS_5_10_MHZ;
+
 	hw->vif_data_size = sizeof(struct ath5k_vif);
 
 	/* Finish private driver data initialization */
diff --git a/drivers/net/wireless/ath/ath5k/debug.c b/drivers/net/wireless/ath/ath5k/debug.c
index 9d00dab..cb6de88 100644
--- a/drivers/net/wireless/ath/ath5k/debug.c
+++ b/drivers/net/wireless/ath/ath5k/debug.c
@@ -961,10 +961,25 @@ ath5k_debug_dump_bands(struct ath5k_hw *ah)
 		printk(KERN_DEBUG " rates:\n");
 		for (i = 0; i < band->n_bitrates; i++)
 			printk(KERN_DEBUG "  %4d %.4x %.4x %.4x\n",
-					band->bitrates[i].bitrate,
-					band->bitrates[i].hw_value,
-					band->bitrates[i].flags,
-					band->bitrates[i].hw_value_short);
+			       band->bitrates[i].bitrate,
+			       band->bitrates[i].hw_value,
+			       band->bitrates[i].flags,
+			       band->bitrates[i].hw_value_short);
+		printk(KERN_DEBUG " 10 MHz rates:\n");
+		for (i = 0; i < band->n_bitrates_half; i++)
+			printk(KERN_DEBUG "  %4d %.4x %.4x %.4x\n",
+			       band->bitrates_half[i].bitrate,
+			       band->bitrates_half[i].hw_value,
+			       band->bitrates_half[i].flags,
+			       band->bitrates_half[i].hw_value_short);
+		printk(KERN_DEBUG " 5 MHz rates:\n");
+		for (i = 0; i < band->n_bitrates_quarter; i++)
+			printk(KERN_DEBUG "  %4d %.4x %.4x %.4x\n",
+			       band->bitrates_quarter[i].bitrate,
+			       band->bitrates_quarter[i].hw_value,
+			       band->bitrates_quarter[i].flags,
+			       band->bitrates_quarter[i].hw_value_short);
+
 	}
 }
 
diff --git a/drivers/net/wireless/ath/ath5k/pcu.c b/drivers/net/wireless/ath/ath5k/pcu.c
index 1f16b42..39d3f17 100644
--- a/drivers/net/wireless/ath/ath5k/pcu.c
+++ b/drivers/net/wireless/ath/ath5k/pcu.c
@@ -274,24 +274,44 @@ ath5k_hw_update_mib_counters(struct ath5k_hw *ah)
 static inline void
 ath5k_hw_write_rate_duration(struct ath5k_hw *ah)
 {
+	struct ieee80211_rate *bitrates;
 	struct ieee80211_rate *rate;
-	unsigned int i;
+	unsigned int i, n_bitrates;
 	/* 802.11g covers both OFDM and CCK */
 	u8 band = IEEE80211_BAND_2GHZ;
 
+	switch (ah->ah_bwmode) {
+	case AR5K_BWMODE_DEFAULT:
+	case AR5K_BWMODE_40MHZ:
+		bitrates = ah->sbands[band].bitrates;
+		n_bitrates = ah->sbands[band].n_bitrates;
+		break;
+	case AR5K_BWMODE_5MHZ:
+		bitrates = ah->sbands[band].bitrates_quarter;
+		n_bitrates = ah->sbands[band].n_bitrates_quarter;
+		break;
+	case AR5K_BWMODE_10MHZ:
+		bitrates = ah->sbands[band].bitrates_half;
+		n_bitrates = ah->sbands[band].n_bitrates_half;
+		break;
+	default:
+		WARN_ON(1);
+		return;
+	}
+
 	/* Write rate duration table */
-	for (i = 0; i < ah->sbands[band].n_bitrates; i++) {
+	for (i = 0; i < n_bitrates; i++) {
 		u32 reg;
 		u16 tx_time;
 
 		if (ah->ah_ack_bitrate_high)
-			rate = &ah->sbands[band].bitrates[ack_rates_high[i]];
+			rate = &bitrates[ack_rates_high[i]];
 		/* CCK -> 1Mb */
 		else if (i < 4)
-			rate = &ah->sbands[band].bitrates[0];
+			rate = &bitrates[0];
 		/* OFDM -> 6Mb */
 		else
-			rate = &ah->sbands[band].bitrates[4];
+			rate = &bitrates[4];
 
 		/* Set ACK timeout */
 		reg = AR5K_RATE_DUR(rate->hw_value);
diff --git a/drivers/net/wireless/ath/ath5k/qcu.c b/drivers/net/wireless/ath/ath5k/qcu.c
index 65fe929..2de20ae 100644
--- a/drivers/net/wireless/ath/ath5k/qcu.c
+++ b/drivers/net/wireless/ath/ath5k/qcu.c
@@ -567,6 +567,8 @@ int ath5k_hw_set_ifs_intervals(struct ath5k_hw *ah, unsigned int slot_time)
 	struct ieee80211_channel *channel = ah->ah_current_channel;
 	enum ieee80211_band band;
 	struct ieee80211_rate *rate;
+	struct ieee80211_rate *bitrates;
+	int n_bitrates;
 	u32 ack_tx_time, eifs, eifs_clock, sifs, sifs_clock;
 	u32 slot_time_clock = ath5k_hw_htoclock(ah, slot_time);
 
@@ -605,7 +607,26 @@ int ath5k_hw_set_ifs_intervals(struct ath5k_hw *ah, unsigned int slot_time)
 	else
 		band = IEEE80211_BAND_2GHZ;
 
-	rate = &ah->sbands[band].bitrates[0];
+	switch (ah->ah_bwmode) {
+	case AR5K_BWMODE_DEFAULT:
+	case AR5K_BWMODE_40MHZ:
+		bitrates = ah->sbands[band].bitrates;
+		n_bitrates = ah->sbands[band].n_bitrates;
+		break;
+	case AR5K_BWMODE_5MHZ:
+		bitrates = ah->sbands[band].bitrates_quarter;
+		n_bitrates = ah->sbands[band].n_bitrates_quarter;
+		break;
+	case AR5K_BWMODE_10MHZ:
+		bitrates = ah->sbands[band].bitrates_half;
+		n_bitrates = ah->sbands[band].n_bitrates_half;
+		break;
+	default:
+		WARN_ON(1);
+		return -EINVAL;
+	}
+
+	rate = &bitrates[0];
 	ack_tx_time = ath5k_hw_get_frame_duration(ah, band, 10, rate, false);
 
 	/* ack_tx_time includes an SIFS already */
-- 
1.7.10.4

