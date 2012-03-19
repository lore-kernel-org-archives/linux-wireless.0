Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:50221 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756344Ab2CTOkF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Mar 2012 10:40:05 -0400
From: Michal Kazior <michal.kazior@tieto.com>
Date: Mon, 19 Mar 2012 09:39:07 +0100
Subject: [RFC 03/12] mac80211: prepare ieee80211_frame_duration to per-vif
To: <linux-wireless@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Message-ID: <5bd587b9-bc1e-4b91-b4a7-37db67681946@FIVLA-EXHUB02.eu.tieto.com> (sfid-20120320_154013_005213_D7DD082B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In preparation for multi-channel operation.

Ath5k driver needs to be fixed. It uses
ieee80211_generic_frame_duration() through ath5k_hw_get_frame_duration()
which itself and it's parent callers have no access (except
bss_info_changed handler) to sdata pointer.

This requires us to preserve ieee80211_local pointer in the argument
list of ieee80211_generic_frame_duration.

I think we should get rid of ieee80211_local pointer eventually from
here, but to do that we need to deal with ath5k first.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 net/mac80211/ieee80211_i.h         |    3 ++-
 net/mac80211/rc80211_minstrel.c    |   12 +++++++-----
 net/mac80211/rc80211_minstrel_ht.c |    6 ++++--
 net/mac80211/tx.c                  |    4 ++--
 net/mac80211/util.c                |   29 ++++++++++++++++++-----------
 5 files changed, 33 insertions(+), 21 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 822dafd..0ffee10 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1383,7 +1383,8 @@ static inline int __ieee80211_resume(struct ieee80211_hw *hw)
 extern void *mac80211_wiphy_privid; /* for wiphy privid */
 u8 *ieee80211_get_bssid(struct ieee80211_hdr *hdr, size_t len,
 			enum nl80211_iftype type);
-int ieee80211_frame_duration(struct ieee80211_local *local, size_t len,
+int ieee80211_frame_duration(struct ieee80211_local *local,
+			     struct ieee80211_sub_if_data *sdata, size_t len,
 			     int rate, int erp, int short_preamble);
 void mac80211_ev_michael_mic_failure(struct ieee80211_sub_if_data *sdata, int keyidx,
 				     struct ieee80211_hdr *hdr, const u8 *tsc,
diff --git a/net/mac80211/rc80211_minstrel.c b/net/mac80211/rc80211_minstrel.c
index b39dda5..814ebd0 100644
--- a/net/mac80211/rc80211_minstrel.c
+++ b/net/mac80211/rc80211_minstrel.c
@@ -334,14 +334,14 @@ minstrel_get_rate(void *priv, struct ieee80211_sta *sta,
 
 
 static void
-calc_rate_durations(struct ieee80211_local *local, struct minstrel_rate *d,
+calc_rate_durations(struct ieee80211_sub_if_data *sdata, struct minstrel_rate *d,
 		    struct ieee80211_rate *rate)
 {
 	int erp = !!(rate->flags & IEEE80211_RATE_ERP_G);
 
-	d->perfect_tx_time = ieee80211_frame_duration(local, 1200,
+	d->perfect_tx_time = ieee80211_frame_duration(sdata->local, sdata, 1200,
 			rate->bitrate, erp, 1);
-	d->ack_time = ieee80211_frame_duration(local, 10,
+	d->ack_time = ieee80211_frame_duration(sdata->local, sdata, 10,
 			rate->bitrate, erp, 1);
 }
 
@@ -380,13 +380,15 @@ minstrel_rate_init(void *priv, struct ieee80211_supported_band *sband,
 	struct minstrel_sta_info *mi = priv_sta;
 	struct minstrel_priv *mp = priv;
 	struct ieee80211_local *local = hw_to_local(mp->hw);
+	struct ieee80211_sub_if_data *sdata =
+			container_of(sta, struct sta_info, sta)->sdata;
 	struct ieee80211_rate *ctl_rate;
 	unsigned int i, n = 0;
 	unsigned int t_slot = 9; /* FIXME: get real slot time */
 
 	mi->lowest_rix = rate_lowest_index(sband, sta);
 	ctl_rate = &sband->bitrates[mi->lowest_rix];
-	mi->sp_ack_dur = ieee80211_frame_duration(local, 10, ctl_rate->bitrate,
+	mi->sp_ack_dur = ieee80211_frame_duration(local, sdata, 10, ctl_rate->bitrate,
 				!!(ctl_rate->flags & IEEE80211_RATE_ERP_G), 1);
 
 	for (i = 0; i < sband->n_bitrates; i++) {
@@ -402,7 +404,7 @@ minstrel_rate_init(void *priv, struct ieee80211_supported_band *sband,
 
 		mr->rix = i;
 		mr->bitrate = sband->bitrates[i].bitrate / 5;
-		calc_rate_durations(local, mr, &sband->bitrates[i]);
+		calc_rate_durations(sdata, mr, &sband->bitrates[i]);
 
 		/* calculate maximum number of retransmissions before
 		 * fallback (based on maximum segment size) */
diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index 16e0b27..00355ef 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -694,6 +694,8 @@ minstrel_ht_update_caps(void *priv, struct ieee80211_supported_band *sband,
 	struct minstrel_ht_sta *mi = &msp->ht;
 	struct ieee80211_mcs_info *mcs = &sta->ht_cap.mcs;
 	struct ieee80211_local *local = hw_to_local(mp->hw);
+	struct ieee80211_sub_if_data *sdata =
+			container_of(sta, struct sta_info, sta)->sdata;
 	u16 sta_cap = sta->ht_cap.cap;
 	int n_supported = 0;
 	int ack_dur;
@@ -712,8 +714,8 @@ minstrel_ht_update_caps(void *priv, struct ieee80211_supported_band *sband,
 	memset(mi, 0, sizeof(*mi));
 	mi->stats_update = jiffies;
 
-	ack_dur = ieee80211_frame_duration(local, 10, 60, 1, 1);
-	mi->overhead = ieee80211_frame_duration(local, 0, 60, 1, 1) + ack_dur;
+	ack_dur = ieee80211_frame_duration(local, sdata, 10, 60, 1, 1);
+	mi->overhead = ieee80211_frame_duration(local, sdata, 0, 60, 1, 1) + ack_dur;
 	mi->overhead_rtscts = mi->overhead + 2 * ack_dur;
 
 	mi->avg_ampdu_len = MINSTREL_FRAC(1, 1);
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 782a601..d241d83 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -159,7 +159,7 @@ static __le16 ieee80211_duration(struct ieee80211_tx_data *tx,
 		/* Time needed to transmit ACK
 		 * (10 bytes + 4-byte FCS = 112 bits) plus SIFS; rounded up
 		 * to closest integer */
-		dur = ieee80211_frame_duration(local, 10, rate, erp,
+		dur = ieee80211_frame_duration(local, tx->sdata, 10, rate, erp,
 				tx->sdata->vif.bss_conf.use_short_preamble);
 
 	if (next_frag_len) {
@@ -167,7 +167,7 @@ static __le16 ieee80211_duration(struct ieee80211_tx_data *tx,
 		 * transmit next fragment plus ACK and 2 x SIFS. */
 		dur *= 2; /* ACK + SIFS */
 		/* next fragment */
-		dur += ieee80211_frame_duration(local, next_frag_len,
+		dur += ieee80211_frame_duration(local, tx->sdata, next_frag_len,
 				txrate->bitrate, erp,
 				tx->sdata->vif.bss_conf.use_short_preamble);
 	}
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 928721d..e8b6b31 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -106,7 +106,8 @@ void ieee80211_tx_set_protected(struct ieee80211_tx_data *tx)
 	}
 }
 
-int ieee80211_frame_duration(struct ieee80211_local *local, size_t len,
+int ieee80211_frame_duration(struct ieee80211_local *local,
+			     struct ieee80211_sub_if_data *sdata, size_t len,
 			     int rate, int erp, int short_preamble)
 {
 	int dur;
@@ -166,11 +167,13 @@ __le16 ieee80211_generic_frame_duration(struct ieee80211_hw *hw,
 					struct ieee80211_rate *rate)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
-	struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_sub_if_data *sdata = NULL;
 	u16 dur;
 	int erp;
 	bool short_preamble = false;
 
+	WARN_ON_ONCE(!vif); /* ath5k is known to trigger this */
+
 	erp = 0;
 	if (vif) {
 		sdata = vif_to_sdata(vif);
@@ -179,8 +182,8 @@ __le16 ieee80211_generic_frame_duration(struct ieee80211_hw *hw,
 			erp = rate->flags & IEEE80211_RATE_ERP_G;
 	}
 
-	dur = ieee80211_frame_duration(local, frame_len, rate->bitrate, erp,
-				       short_preamble);
+	dur = ieee80211_frame_duration(local, sdata, frame_len, rate->bitrate,
+				       erp, short_preamble);
 
 	return cpu_to_le16(dur);
 }
@@ -192,12 +195,14 @@ __le16 ieee80211_rts_duration(struct ieee80211_hw *hw,
 {
 	struct ieee80211_local *local = hw_to_local(hw);
 	struct ieee80211_rate *rate;
-	struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_sub_if_data *sdata = NULL;
 	bool short_preamble;
 	int erp;
 	u16 dur;
 	struct ieee80211_supported_band *sband;
 
+	WARN_ON_ONCE(!vif);
+
 	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
 
 	short_preamble = false;
@@ -213,13 +218,13 @@ __le16 ieee80211_rts_duration(struct ieee80211_hw *hw,
 	}
 
 	/* CTS duration */
-	dur = ieee80211_frame_duration(local, 10, rate->bitrate,
+	dur = ieee80211_frame_duration(local, sdata, 10, rate->bitrate,
 				       erp, short_preamble);
 	/* Data frame duration */
-	dur += ieee80211_frame_duration(local, frame_len, rate->bitrate,
+	dur += ieee80211_frame_duration(local, sdata, frame_len, rate->bitrate,
 					erp, short_preamble);
 	/* ACK duration */
-	dur += ieee80211_frame_duration(local, 10, rate->bitrate,
+	dur += ieee80211_frame_duration(local, sdata, 10, rate->bitrate,
 					erp, short_preamble);
 
 	return cpu_to_le16(dur);
@@ -233,12 +238,14 @@ __le16 ieee80211_ctstoself_duration(struct ieee80211_hw *hw,
 {
 	struct ieee80211_local *local = hw_to_local(hw);
 	struct ieee80211_rate *rate;
-	struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_sub_if_data *sdata = NULL;
 	bool short_preamble;
 	int erp;
 	u16 dur;
 	struct ieee80211_supported_band *sband;
 
+	WARN_ON_ONCE(!vif);
+
 	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
 
 	short_preamble = false;
@@ -253,11 +260,11 @@ __le16 ieee80211_ctstoself_duration(struct ieee80211_hw *hw,
 	}
 
 	/* Data frame duration */
-	dur = ieee80211_frame_duration(local, frame_len, rate->bitrate,
+	dur = ieee80211_frame_duration(local, sdata, frame_len, rate->bitrate,
 				       erp, short_preamble);
 	if (!(frame_txctl->flags & IEEE80211_TX_CTL_NO_ACK)) {
 		/* ACK duration */
-		dur += ieee80211_frame_duration(local, 10, rate->bitrate,
+		dur += ieee80211_frame_duration(local, sdata, 10, rate->bitrate,
 						erp, short_preamble);
 	}
 
-- 
1.7.0.4

