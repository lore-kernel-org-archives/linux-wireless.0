Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:52568 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757729Ab2C1LGl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Mar 2012 07:06:41 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH] mac80211: remove hw.conf.channel usage where possible
Date: Wed, 28 Mar 2012 12:54:24 +0200
Message-ID: <1332932064-13758-1-git-send-email-michal.kazior@tieto.com> (sfid-20120328_130644_688037_989F7FF1)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Removes hw.conf.channel usage from the following functions:
 * ieee80211_mandatory_rates
 * ieee80211_sta_get_rates
 * ieee80211_frame_duration

This is in preparation for multi-channel operation.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath5k/ath5k.h |    1 +
 drivers/net/wireless/ath/ath5k/pcu.c   |    9 +++++--
 drivers/net/wireless/ath/ath5k/qcu.c   |    8 ++++--
 include/net/mac80211.h                 |    1 +
 net/mac80211/ieee80211_i.h             |    2 +-
 net/mac80211/rc80211_minstrel.c        |   11 +++++----
 net/mac80211/rc80211_minstrel_ht.c     |    4 +-
 net/mac80211/tx.c                      |    4 +-
 net/mac80211/util.c                    |   34 ++++++++++++++-----------------
 9 files changed, 39 insertions(+), 35 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
index 8d434b8..2a4371d 100644
--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -1525,6 +1525,7 @@ void ath5k_eeprom_detach(struct ath5k_hw *ah);
 /* Protocol Control Unit Functions */
 /* Helpers */
 int ath5k_hw_get_frame_duration(struct ath5k_hw *ah,
+		struct ieee80211_supported_band *sband,
 		int len, struct ieee80211_rate *rate, bool shortpre);
 unsigned int ath5k_hw_get_default_slottime(struct ath5k_hw *ah);
 unsigned int ath5k_hw_get_default_sifs(struct ath5k_hw *ah);
diff --git a/drivers/net/wireless/ath/ath5k/pcu.c b/drivers/net/wireless/ath/ath5k/pcu.c
index cebfd6f..1220273 100644
--- a/drivers/net/wireless/ath/ath5k/pcu.c
+++ b/drivers/net/wireless/ath/ath5k/pcu.c
@@ -111,6 +111,7 @@ static const unsigned int ack_rates_high[] =
  */
 int
 ath5k_hw_get_frame_duration(struct ath5k_hw *ah,
+		struct ieee80211_supported_band *sband,
 		int len, struct ieee80211_rate *rate, bool shortpre)
 {
 	int sifs, preamble, plcp_bits, sym_time;
@@ -120,7 +121,7 @@ ath5k_hw_get_frame_duration(struct ath5k_hw *ah,
 	/* Fallback */
 	if (!ah->ah_bwmode) {
 		__le16 raw_dur = ieee80211_generic_frame_duration(ah->hw,
-					NULL, len, rate);
+					NULL, sband, len, rate);
 
 		/* subtract difference between long and short preamble */
 		dur = le16_to_cpu(raw_dur);
@@ -302,14 +303,16 @@ ath5k_hw_write_rate_duration(struct ath5k_hw *ah)
 		 * actual rate for this rate. See mac80211 tx.c
 		 * ieee80211_duration() for a brief description of
 		 * what rate we should choose to TX ACKs. */
-		tx_time = ath5k_hw_get_frame_duration(ah, 10, rate, false);
+		tx_time = ath5k_hw_get_frame_duration(ah, &ah->sbands[band], 10,
+					rate, false);
 
 		ath5k_hw_reg_write(ah, tx_time, reg);
 
 		if (!(rate->flags & IEEE80211_RATE_SHORT_PREAMBLE))
 			continue;
 
-		tx_time = ath5k_hw_get_frame_duration(ah, 10, rate, true);
+		tx_time = ath5k_hw_get_frame_duration(ah, &ah->sbands[band],
+				10, rate, true);
 		ath5k_hw_reg_write(ah, tx_time,
 			reg + (AR5K_SET_SHORT_PREAMBLE << 2));
 	}
diff --git a/drivers/net/wireless/ath/ath5k/qcu.c b/drivers/net/wireless/ath/ath5k/qcu.c
index 30b50f9..81d463b 100644
--- a/drivers/net/wireless/ath/ath5k/qcu.c
+++ b/drivers/net/wireless/ath/ath5k/qcu.c
@@ -563,6 +563,7 @@ ath5k_hw_reset_tx_queue(struct ath5k_hw *ah, unsigned int queue)
 int ath5k_hw_set_ifs_intervals(struct ath5k_hw *ah, unsigned int slot_time)
 {
 	struct ieee80211_channel *channel = ah->ah_current_channel;
+	struct ieee80211_supported_band *sband;
 	struct ieee80211_rate *rate;
 	u32 ack_tx_time, eifs, eifs_clock, sifs, sifs_clock;
 	u32 slot_time_clock = ath5k_hw_htoclock(ah, slot_time);
@@ -598,11 +599,12 @@ int ath5k_hw_set_ifs_intervals(struct ath5k_hw *ah, unsigned int slot_time)
 	 * Also we have different lowest rate for 802.11a
 	 */
 	if (channel->band == IEEE80211_BAND_5GHZ)
-		rate = &ah->sbands[IEEE80211_BAND_5GHZ].bitrates[0];
+		sband = &ah->sbands[IEEE80211_BAND_5GHZ];
 	else
-		rate = &ah->sbands[IEEE80211_BAND_2GHZ].bitrates[0];
+		sband = &ah->sbands[IEEE80211_BAND_2GHZ];
 
-	ack_tx_time = ath5k_hw_get_frame_duration(ah, 10, rate, false);
+	rate = &sband->bitrates[0];
+	ack_tx_time = ath5k_hw_get_frame_duration(ah, sband, 10, rate, false);
 
 	/* ack_tx_time includes an SIFS already */
 	eifs = ack_tx_time + sifs + 2 * slot_time;
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 9a012be..12116d3 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2842,6 +2842,7 @@ __le16 ieee80211_ctstoself_duration(struct ieee80211_hw *hw,
  */
 __le16 ieee80211_generic_frame_duration(struct ieee80211_hw *hw,
 					struct ieee80211_vif *vif,
+					struct ieee80211_supported_band *sband,
 					size_t frame_len,
 					struct ieee80211_rate *rate);
 
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index d9798a3..a3c4eae 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1383,7 +1383,7 @@ static inline int __ieee80211_resume(struct ieee80211_hw *hw)
 extern void *mac80211_wiphy_privid; /* for wiphy privid */
 u8 *ieee80211_get_bssid(struct ieee80211_hdr *hdr, size_t len,
 			enum nl80211_iftype type);
-int ieee80211_frame_duration(struct ieee80211_local *local, size_t len,
+int ieee80211_frame_duration(struct ieee80211_supported_band *sband, size_t len,
 			     int rate, int erp, int short_preamble);
 void mac80211_ev_michael_mic_failure(struct ieee80211_sub_if_data *sdata, int keyidx,
 				     struct ieee80211_hdr *hdr, const u8 *tsc,
diff --git a/net/mac80211/rc80211_minstrel.c b/net/mac80211/rc80211_minstrel.c
index b39dda5..a146ef7 100644
--- a/net/mac80211/rc80211_minstrel.c
+++ b/net/mac80211/rc80211_minstrel.c
@@ -334,14 +334,15 @@ minstrel_get_rate(void *priv, struct ieee80211_sta *sta,
 
 
 static void
-calc_rate_durations(struct ieee80211_local *local, struct minstrel_rate *d,
+calc_rate_durations(struct ieee80211_supported_band *sband,
+		    struct minstrel_rate *d,
 		    struct ieee80211_rate *rate)
 {
 	int erp = !!(rate->flags & IEEE80211_RATE_ERP_G);
 
-	d->perfect_tx_time = ieee80211_frame_duration(local, 1200,
+	d->perfect_tx_time = ieee80211_frame_duration(sband, 1200,
 			rate->bitrate, erp, 1);
-	d->ack_time = ieee80211_frame_duration(local, 10,
+	d->ack_time = ieee80211_frame_duration(sband, 10,
 			rate->bitrate, erp, 1);
 }
 
@@ -386,7 +387,7 @@ minstrel_rate_init(void *priv, struct ieee80211_supported_band *sband,
 
 	mi->lowest_rix = rate_lowest_index(sband, sta);
 	ctl_rate = &sband->bitrates[mi->lowest_rix];
-	mi->sp_ack_dur = ieee80211_frame_duration(local, 10, ctl_rate->bitrate,
+	mi->sp_ack_dur = ieee80211_frame_duration(sband, 10, ctl_rate->bitrate,
 				!!(ctl_rate->flags & IEEE80211_RATE_ERP_G), 1);
 
 	for (i = 0; i < sband->n_bitrates; i++) {
@@ -402,7 +403,7 @@ minstrel_rate_init(void *priv, struct ieee80211_supported_band *sband,
 
 		mr->rix = i;
 		mr->bitrate = sband->bitrates[i].bitrate / 5;
-		calc_rate_durations(local, mr, &sband->bitrates[i]);
+		calc_rate_durations(sband, mr, &sband->bitrates[i]);
 
 		/* calculate maximum number of retransmissions before
 		 * fallback (based on maximum segment size) */
diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index 16e0b27..c222ff4 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -712,8 +712,8 @@ minstrel_ht_update_caps(void *priv, struct ieee80211_supported_band *sband,
 	memset(mi, 0, sizeof(*mi));
 	mi->stats_update = jiffies;
 
-	ack_dur = ieee80211_frame_duration(local, 10, 60, 1, 1);
-	mi->overhead = ieee80211_frame_duration(local, 0, 60, 1, 1) + ack_dur;
+	ack_dur = ieee80211_frame_duration(sband, 10, 60, 1, 1);
+	mi->overhead = ieee80211_frame_duration(sband, 0, 60, 1, 1) + ack_dur;
 	mi->overhead_rtscts = mi->overhead + 2 * ack_dur;
 
 	mi->avg_ampdu_len = MINSTREL_FRAC(1, 1);
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 782a601..bedffc6 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -159,7 +159,7 @@ static __le16 ieee80211_duration(struct ieee80211_tx_data *tx,
 		/* Time needed to transmit ACK
 		 * (10 bytes + 4-byte FCS = 112 bits) plus SIFS; rounded up
 		 * to closest integer */
-		dur = ieee80211_frame_duration(local, 10, rate, erp,
+		dur = ieee80211_frame_duration(sband, 10, rate, erp,
 				tx->sdata->vif.bss_conf.use_short_preamble);
 
 	if (next_frag_len) {
@@ -167,7 +167,7 @@ static __le16 ieee80211_duration(struct ieee80211_tx_data *tx,
 		 * transmit next fragment plus ACK and 2 x SIFS. */
 		dur *= 2; /* ACK + SIFS */
 		/* next fragment */
-		dur += ieee80211_frame_duration(local, next_frag_len,
+		dur += ieee80211_frame_duration(sband, next_frag_len,
 				txrate->bitrate, erp,
 				tx->sdata->vif.bss_conf.use_short_preamble);
 	}
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 32f7a3b..f713a37 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -106,7 +106,7 @@ void ieee80211_tx_set_protected(struct ieee80211_tx_data *tx)
 	}
 }
 
-int ieee80211_frame_duration(struct ieee80211_local *local, size_t len,
+int ieee80211_frame_duration(struct ieee80211_supported_band *sband, size_t len,
 			     int rate, int erp, int short_preamble)
 {
 	int dur;
@@ -120,7 +120,7 @@ int ieee80211_frame_duration(struct ieee80211_local *local, size_t len,
 	 * DIV_ROUND_UP() operations.
 	 */
 
-	if (local->hw.conf.channel->band == IEEE80211_BAND_5GHZ || erp) {
+	if (!WARN_ON(!sband) && sband->band == IEEE80211_BAND_5GHZ || erp) {
 		/*
 		 * OFDM:
 		 *
@@ -162,10 +162,10 @@ int ieee80211_frame_duration(struct ieee80211_local *local, size_t len,
 /* Exported duration function for driver use */
 __le16 ieee80211_generic_frame_duration(struct ieee80211_hw *hw,
 					struct ieee80211_vif *vif,
+					struct ieee80211_supported_band *sband,
 					size_t frame_len,
 					struct ieee80211_rate *rate)
 {
-	struct ieee80211_local *local = hw_to_local(hw);
 	struct ieee80211_sub_if_data *sdata;
 	u16 dur;
 	int erp;
@@ -179,7 +179,7 @@ __le16 ieee80211_generic_frame_duration(struct ieee80211_hw *hw,
 			erp = rate->flags & IEEE80211_RATE_ERP_G;
 	}
 
-	dur = ieee80211_frame_duration(local, frame_len, rate->bitrate, erp,
+	dur = ieee80211_frame_duration(sband, frame_len, rate->bitrate, erp,
 				       short_preamble);
 
 	return cpu_to_le16(dur);
@@ -198,7 +198,7 @@ __le16 ieee80211_rts_duration(struct ieee80211_hw *hw,
 	u16 dur;
 	struct ieee80211_supported_band *sband;
 
-	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
+	sband = local->hw.wiphy->bands[frame_txctl->band];
 
 	short_preamble = false;
 
@@ -213,13 +213,13 @@ __le16 ieee80211_rts_duration(struct ieee80211_hw *hw,
 	}
 
 	/* CTS duration */
-	dur = ieee80211_frame_duration(local, 10, rate->bitrate,
+	dur = ieee80211_frame_duration(sband, 10, rate->bitrate,
 				       erp, short_preamble);
 	/* Data frame duration */
-	dur += ieee80211_frame_duration(local, frame_len, rate->bitrate,
+	dur += ieee80211_frame_duration(sband, frame_len, rate->bitrate,
 					erp, short_preamble);
 	/* ACK duration */
-	dur += ieee80211_frame_duration(local, 10, rate->bitrate,
+	dur += ieee80211_frame_duration(sband, 10, rate->bitrate,
 					erp, short_preamble);
 
 	return cpu_to_le16(dur);
@@ -239,7 +239,7 @@ __le16 ieee80211_ctstoself_duration(struct ieee80211_hw *hw,
 	u16 dur;
 	struct ieee80211_supported_band *sband;
 
-	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
+	sband = local->hw.wiphy->bands[frame_txctl->band];
 
 	short_preamble = false;
 
@@ -253,11 +253,11 @@ __le16 ieee80211_ctstoself_duration(struct ieee80211_hw *hw,
 	}
 
 	/* Data frame duration */
-	dur = ieee80211_frame_duration(local, frame_len, rate->bitrate,
+	dur = ieee80211_frame_duration(sband, frame_len, rate->bitrate,
 				       erp, short_preamble);
 	if (!(frame_txctl->flags & IEEE80211_TX_CTL_NO_ACK)) {
 		/* ACK duration */
-		dur += ieee80211_frame_duration(local, 10, rate->bitrate,
+		dur += ieee80211_frame_duration(sband, 10, rate->bitrate,
 						erp, short_preamble);
 	}
 
@@ -878,10 +878,8 @@ u32 ieee80211_mandatory_rates(struct ieee80211_local *local,
 	int i;
 
 	sband = local->hw.wiphy->bands[band];
-	if (!sband) {
-		WARN_ON(1);
-		sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
-	}
+	if (WARN_ON(!sband))
+		return 1;
 
 	if (band == IEEE80211_BAND_2GHZ)
 		mandatory_flag = IEEE80211_RATE_MANDATORY_B;
@@ -1115,10 +1113,8 @@ u32 ieee80211_sta_get_rates(struct ieee80211_local *local,
 	int i, j;
 	sband = local->hw.wiphy->bands[band];
 
-	if (!sband) {
-		WARN_ON(1);
-		sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
-	}
+	if (WARN_ON(!sband))
+		return 1;
 
 	bitrates = sband->bitrates;
 	num_rates = sband->n_bitrates;
-- 
1.7.0.4

