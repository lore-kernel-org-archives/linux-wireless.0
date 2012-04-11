Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:64998 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750744Ab2DKGug (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Apr 2012 02:50:36 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <linville@tuxdriver.com>
CC: <johannes@sipsolutions.net>, <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2] mac80211: remove hw.conf.channel usage where possible
Date: Wed, 11 Apr 2012 08:47:56 +0200
Message-ID: <1334126876-19157-1-git-send-email-michal.kazior@tieto.com> (sfid-20120411_085040_609096_286D1186)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Removes hw.conf.channel usage from the following functions:
 * ieee80211_mandatory_rates
 * ieee80211_sta_get_rates
 * ieee80211_frame_duration
 * ieee80211_rts_duration
 * ieee80211_ctstoself_duration

This is in preparation for multi-channel operation.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
v2: fix users of ieee80211_generic_frame_duration()

 drivers/net/wireless/ath/ath5k/ath5k.h     |    2 +-
 drivers/net/wireless/ath/ath5k/pcu.c       |    9 ++++---
 drivers/net/wireless/ath/ath5k/qcu.c       |    8 ++++--
 drivers/net/wireless/b43/xmit.c            |    3 +-
 drivers/net/wireless/b43legacy/main.c      |    2 +
 drivers/net/wireless/b43legacy/xmit.c      |    1 +
 drivers/net/wireless/rtl818x/rtl8187/dev.c |    1 +
 include/net/mac80211.h                     |    1 +
 net/mac80211/ieee80211_i.h                 |    2 +-
 net/mac80211/rc80211_minstrel.c            |   13 +++++-----
 net/mac80211/rc80211_minstrel_ht.c         |    5 +--
 net/mac80211/tx.c                          |    4 +-
 net/mac80211/util.c                        |   34 ++++++++++++---------------
 13 files changed, 45 insertions(+), 40 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
index 8d434b8..727f2e5 100644
--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -1524,7 +1524,7 @@ void ath5k_eeprom_detach(struct ath5k_hw *ah);
 
 /* Protocol Control Unit Functions */
 /* Helpers */
-int ath5k_hw_get_frame_duration(struct ath5k_hw *ah,
+int ath5k_hw_get_frame_duration(struct ath5k_hw *ah, enum ieee80211_band band,
 		int len, struct ieee80211_rate *rate, bool shortpre);
 unsigned int ath5k_hw_get_default_slottime(struct ath5k_hw *ah);
 unsigned int ath5k_hw_get_default_sifs(struct ath5k_hw *ah);
diff --git a/drivers/net/wireless/ath/ath5k/pcu.c b/drivers/net/wireless/ath/ath5k/pcu.c
index cebfd6f..1f16b42 100644
--- a/drivers/net/wireless/ath/ath5k/pcu.c
+++ b/drivers/net/wireless/ath/ath5k/pcu.c
@@ -110,7 +110,7 @@ static const unsigned int ack_rates_high[] =
  * bwmodes.
  */
 int
-ath5k_hw_get_frame_duration(struct ath5k_hw *ah,
+ath5k_hw_get_frame_duration(struct ath5k_hw *ah, enum ieee80211_band band,
 		int len, struct ieee80211_rate *rate, bool shortpre)
 {
 	int sifs, preamble, plcp_bits, sym_time;
@@ -120,7 +120,7 @@ ath5k_hw_get_frame_duration(struct ath5k_hw *ah,
 	/* Fallback */
 	if (!ah->ah_bwmode) {
 		__le16 raw_dur = ieee80211_generic_frame_duration(ah->hw,
-					NULL, len, rate);
+					NULL, band, len, rate);
 
 		/* subtract difference between long and short preamble */
 		dur = le16_to_cpu(raw_dur);
@@ -302,14 +302,15 @@ ath5k_hw_write_rate_duration(struct ath5k_hw *ah)
 		 * actual rate for this rate. See mac80211 tx.c
 		 * ieee80211_duration() for a brief description of
 		 * what rate we should choose to TX ACKs. */
-		tx_time = ath5k_hw_get_frame_duration(ah, 10, rate, false);
+		tx_time = ath5k_hw_get_frame_duration(ah, band, 10,
+					rate, false);
 
 		ath5k_hw_reg_write(ah, tx_time, reg);
 
 		if (!(rate->flags & IEEE80211_RATE_SHORT_PREAMBLE))
 			continue;
 
-		tx_time = ath5k_hw_get_frame_duration(ah, 10, rate, true);
+		tx_time = ath5k_hw_get_frame_duration(ah, band, 10, rate, true);
 		ath5k_hw_reg_write(ah, tx_time,
 			reg + (AR5K_SET_SHORT_PREAMBLE << 2));
 	}
diff --git a/drivers/net/wireless/ath/ath5k/qcu.c b/drivers/net/wireless/ath/ath5k/qcu.c
index 30b50f9..1f9677a 100644
--- a/drivers/net/wireless/ath/ath5k/qcu.c
+++ b/drivers/net/wireless/ath/ath5k/qcu.c
@@ -563,6 +563,7 @@ ath5k_hw_reset_tx_queue(struct ath5k_hw *ah, unsigned int queue)
 int ath5k_hw_set_ifs_intervals(struct ath5k_hw *ah, unsigned int slot_time)
 {
 	struct ieee80211_channel *channel = ah->ah_current_channel;
+	enum ieee80211_band band;
 	struct ieee80211_rate *rate;
 	u32 ack_tx_time, eifs, eifs_clock, sifs, sifs_clock;
 	u32 slot_time_clock = ath5k_hw_htoclock(ah, slot_time);
@@ -598,11 +599,12 @@ int ath5k_hw_set_ifs_intervals(struct ath5k_hw *ah, unsigned int slot_time)
 	 * Also we have different lowest rate for 802.11a
 	 */
 	if (channel->band == IEEE80211_BAND_5GHZ)
-		rate = &ah->sbands[IEEE80211_BAND_5GHZ].bitrates[0];
+		band = IEEE80211_BAND_5GHZ;
 	else
-		rate = &ah->sbands[IEEE80211_BAND_2GHZ].bitrates[0];
+		band = IEEE80211_BAND_2GHZ;
 
-	ack_tx_time = ath5k_hw_get_frame_duration(ah, 10, rate, false);
+	rate = &ah->sbands[band].bitrates[0];
+	ack_tx_time = ath5k_hw_get_frame_duration(ah, band, 10, rate, false);
 
 	/* ack_tx_time includes an SIFS already */
 	eifs = ack_tx_time + sifs + 2 * slot_time;
diff --git a/drivers/net/wireless/b43/xmit.c b/drivers/net/wireless/b43/xmit.c
index 2c53678..6e8bf31 100644
--- a/drivers/net/wireless/b43/xmit.c
+++ b/drivers/net/wireless/b43/xmit.c
@@ -290,7 +290,8 @@ int b43_generate_txhdr(struct b43_wldev *dev,
 		txhdr->dur_fb = wlhdr->duration_id;
 	} else {
 		txhdr->dur_fb = ieee80211_generic_frame_duration(
-			dev->wl->hw, info->control.vif, fragment_len, fbrate);
+			dev->wl->hw, info->control.vif, info->band,
+			fragment_len, fbrate);
 	}
 
 	plcp_fragment_len = fragment_len + FCS_LEN;
diff --git a/drivers/net/wireless/b43legacy/main.c b/drivers/net/wireless/b43legacy/main.c
index df7e16d..1be214b 100644
--- a/drivers/net/wireless/b43legacy/main.c
+++ b/drivers/net/wireless/b43legacy/main.c
@@ -1056,6 +1056,7 @@ static void b43legacy_write_probe_resp_plcp(struct b43legacy_wldev *dev,
 	b43legacy_generate_plcp_hdr(&plcp, size + FCS_LEN, rate->hw_value);
 	dur = ieee80211_generic_frame_duration(dev->wl->hw,
 					       dev->wl->vif,
+					       IEEE80211_BAND_2GHZ,
 					       size,
 					       rate);
 	/* Write PLCP in two parts and timing for packet transfer */
@@ -1121,6 +1122,7 @@ static const u8 *b43legacy_generate_probe_resp(struct b43legacy_wldev *dev,
 					 IEEE80211_STYPE_PROBE_RESP);
 	dur = ieee80211_generic_frame_duration(dev->wl->hw,
 					       dev->wl->vif,
+					       IEEE80211_BAND_2GHZ,
 					       *dest_size,
 					       rate);
 	hdr->duration_id = dur;
diff --git a/drivers/net/wireless/b43legacy/xmit.c b/drivers/net/wireless/b43legacy/xmit.c
index 5188fab..238490b 100644
--- a/drivers/net/wireless/b43legacy/xmit.c
+++ b/drivers/net/wireless/b43legacy/xmit.c
@@ -228,6 +228,7 @@ static int generate_txhdr_fw3(struct b43legacy_wldev *dev,
 	} else {
 		txhdr->dur_fb = ieee80211_generic_frame_duration(dev->wl->hw,
 							 info->control.vif,
+							 info->band,
 							 fragment_len,
 							 rate_fb);
 	}
diff --git a/drivers/net/wireless/rtl818x/rtl8187/dev.c b/drivers/net/wireless/rtl818x/rtl8187/dev.c
index cf53ac9..d811496 100644
--- a/drivers/net/wireless/rtl818x/rtl8187/dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8187/dev.c
@@ -294,6 +294,7 @@ static void rtl8187_tx(struct ieee80211_hw *dev, struct sk_buff *skb)
 		hdr->retry = cpu_to_le32((info->control.rates[0].count - 1) << 8);
 		hdr->tx_duration =
 			ieee80211_generic_frame_duration(dev, priv->vif,
+							 info->band,
 							 skb->len, txrate);
 		buf = hdr;
 
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 9a012be..ee7a38b 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2842,6 +2842,7 @@ __le16 ieee80211_ctstoself_duration(struct ieee80211_hw *hw,
  */
 __le16 ieee80211_generic_frame_duration(struct ieee80211_hw *hw,
 					struct ieee80211_vif *vif,
+					enum ieee80211_band band,
 					size_t frame_len,
 					struct ieee80211_rate *rate);
 
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index d9798a3..c5c6ab0 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1383,7 +1383,7 @@ static inline int __ieee80211_resume(struct ieee80211_hw *hw)
 extern void *mac80211_wiphy_privid; /* for wiphy privid */
 u8 *ieee80211_get_bssid(struct ieee80211_hdr *hdr, size_t len,
 			enum nl80211_iftype type);
-int ieee80211_frame_duration(struct ieee80211_local *local, size_t len,
+int ieee80211_frame_duration(enum ieee80211_band band, size_t len,
 			     int rate, int erp, int short_preamble);
 void mac80211_ev_michael_mic_failure(struct ieee80211_sub_if_data *sdata, int keyidx,
 				     struct ieee80211_hdr *hdr, const u8 *tsc,
diff --git a/net/mac80211/rc80211_minstrel.c b/net/mac80211/rc80211_minstrel.c
index b39dda5..79633ae 100644
--- a/net/mac80211/rc80211_minstrel.c
+++ b/net/mac80211/rc80211_minstrel.c
@@ -334,14 +334,15 @@ minstrel_get_rate(void *priv, struct ieee80211_sta *sta,
 
 
 static void
-calc_rate_durations(struct ieee80211_local *local, struct minstrel_rate *d,
+calc_rate_durations(enum ieee80211_band band,
+		    struct minstrel_rate *d,
 		    struct ieee80211_rate *rate)
 {
 	int erp = !!(rate->flags & IEEE80211_RATE_ERP_G);
 
-	d->perfect_tx_time = ieee80211_frame_duration(local, 1200,
+	d->perfect_tx_time = ieee80211_frame_duration(band, 1200,
 			rate->bitrate, erp, 1);
-	d->ack_time = ieee80211_frame_duration(local, 10,
+	d->ack_time = ieee80211_frame_duration(band, 10,
 			rate->bitrate, erp, 1);
 }
 
@@ -379,14 +380,14 @@ minstrel_rate_init(void *priv, struct ieee80211_supported_band *sband,
 {
 	struct minstrel_sta_info *mi = priv_sta;
 	struct minstrel_priv *mp = priv;
-	struct ieee80211_local *local = hw_to_local(mp->hw);
 	struct ieee80211_rate *ctl_rate;
 	unsigned int i, n = 0;
 	unsigned int t_slot = 9; /* FIXME: get real slot time */
 
 	mi->lowest_rix = rate_lowest_index(sband, sta);
 	ctl_rate = &sband->bitrates[mi->lowest_rix];
-	mi->sp_ack_dur = ieee80211_frame_duration(local, 10, ctl_rate->bitrate,
+	mi->sp_ack_dur = ieee80211_frame_duration(sband->band, 10,
+				ctl_rate->bitrate,
 				!!(ctl_rate->flags & IEEE80211_RATE_ERP_G), 1);
 
 	for (i = 0; i < sband->n_bitrates; i++) {
@@ -402,7 +403,7 @@ minstrel_rate_init(void *priv, struct ieee80211_supported_band *sband,
 
 		mr->rix = i;
 		mr->bitrate = sband->bitrates[i].bitrate / 5;
-		calc_rate_durations(local, mr, &sband->bitrates[i]);
+		calc_rate_durations(sband->band, mr, &sband->bitrates[i]);
 
 		/* calculate maximum number of retransmissions before
 		 * fallback (based on maximum segment size) */
diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index 16e0b27..08048fc 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -693,7 +693,6 @@ minstrel_ht_update_caps(void *priv, struct ieee80211_supported_band *sband,
 	struct minstrel_ht_sta_priv *msp = priv_sta;
 	struct minstrel_ht_sta *mi = &msp->ht;
 	struct ieee80211_mcs_info *mcs = &sta->ht_cap.mcs;
-	struct ieee80211_local *local = hw_to_local(mp->hw);
 	u16 sta_cap = sta->ht_cap.cap;
 	int n_supported = 0;
 	int ack_dur;
@@ -712,8 +711,8 @@ minstrel_ht_update_caps(void *priv, struct ieee80211_supported_band *sband,
 	memset(mi, 0, sizeof(*mi));
 	mi->stats_update = jiffies;
 
-	ack_dur = ieee80211_frame_duration(local, 10, 60, 1, 1);
-	mi->overhead = ieee80211_frame_duration(local, 0, 60, 1, 1) + ack_dur;
+	ack_dur = ieee80211_frame_duration(sband->band, 10, 60, 1, 1);
+	mi->overhead = ieee80211_frame_duration(sband->band, 0, 60, 1, 1) + ack_dur;
 	mi->overhead_rtscts = mi->overhead + 2 * ack_dur;
 
 	mi->avg_ampdu_len = MINSTREL_FRAC(1, 1);
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 782a601..1a0732d 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -159,7 +159,7 @@ static __le16 ieee80211_duration(struct ieee80211_tx_data *tx,
 		/* Time needed to transmit ACK
 		 * (10 bytes + 4-byte FCS = 112 bits) plus SIFS; rounded up
 		 * to closest integer */
-		dur = ieee80211_frame_duration(local, 10, rate, erp,
+		dur = ieee80211_frame_duration(sband->band, 10, rate, erp,
 				tx->sdata->vif.bss_conf.use_short_preamble);
 
 	if (next_frag_len) {
@@ -167,7 +167,7 @@ static __le16 ieee80211_duration(struct ieee80211_tx_data *tx,
 		 * transmit next fragment plus ACK and 2 x SIFS. */
 		dur *= 2; /* ACK + SIFS */
 		/* next fragment */
-		dur += ieee80211_frame_duration(local, next_frag_len,
+		dur += ieee80211_frame_duration(sband->band, next_frag_len,
 				txrate->bitrate, erp,
 				tx->sdata->vif.bss_conf.use_short_preamble);
 	}
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 32f7a3b..cae3dc4 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -106,7 +106,7 @@ void ieee80211_tx_set_protected(struct ieee80211_tx_data *tx)
 	}
 }
 
-int ieee80211_frame_duration(struct ieee80211_local *local, size_t len,
+int ieee80211_frame_duration(enum ieee80211_band band, size_t len,
 			     int rate, int erp, int short_preamble)
 {
 	int dur;
@@ -120,7 +120,7 @@ int ieee80211_frame_duration(struct ieee80211_local *local, size_t len,
 	 * DIV_ROUND_UP() operations.
 	 */
 
-	if (local->hw.conf.channel->band == IEEE80211_BAND_5GHZ || erp) {
+	if (band == IEEE80211_BAND_5GHZ || erp) {
 		/*
 		 * OFDM:
 		 *
@@ -162,10 +162,10 @@ int ieee80211_frame_duration(struct ieee80211_local *local, size_t len,
 /* Exported duration function for driver use */
 __le16 ieee80211_generic_frame_duration(struct ieee80211_hw *hw,
 					struct ieee80211_vif *vif,
+					enum ieee80211_band band,
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
+	dur = ieee80211_frame_duration(band, frame_len, rate->bitrate, erp,
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
+	dur = ieee80211_frame_duration(sband->band, 10, rate->bitrate,
 				       erp, short_preamble);
 	/* Data frame duration */
-	dur += ieee80211_frame_duration(local, frame_len, rate->bitrate,
+	dur += ieee80211_frame_duration(sband->band, frame_len, rate->bitrate,
 					erp, short_preamble);
 	/* ACK duration */
-	dur += ieee80211_frame_duration(local, 10, rate->bitrate,
+	dur += ieee80211_frame_duration(sband->band, 10, rate->bitrate,
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
+	dur = ieee80211_frame_duration(sband->band, frame_len, rate->bitrate,
 				       erp, short_preamble);
 	if (!(frame_txctl->flags & IEEE80211_TX_CTL_NO_ACK)) {
 		/* ACK duration */
-		dur += ieee80211_frame_duration(local, 10, rate->bitrate,
+		dur += ieee80211_frame_duration(sband->band, 10, rate->bitrate,
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

