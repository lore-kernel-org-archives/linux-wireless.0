Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:36111 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759140Ab3EOOTe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 May 2013 10:19:34 -0400
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCHv2 04/18] mac80211: fix timing for 5 MHz and 10 MHz channels
Date: Wed, 15 May 2013 16:18:55 +0200
Message-Id: <1368627549-22518-5-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20130515_162020_096606_BE1D33E3)
In-Reply-To: <1368627549-22518-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1368627549-22518-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

according to IEEE 802.11-2012 section 18, various timings change
when using 5 MHz and 10 MHz. Reflect this by using a "divisor" when
calculating durations.

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
---
 net/mac80211/ieee80211_i.h         |   42 +++++++++++++++++++++++++++++++++++-
 net/mac80211/rc80211_minstrel.c    |   14 +++++++-----
 net/mac80211/rc80211_minstrel_ht.c |    8 ++++---
 net/mac80211/tx.c                  |   10 ++++++---
 net/mac80211/util.c                |   39 ++++++++++++++++++++++-----------
 5 files changed, 88 insertions(+), 25 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 158e6eb..0e8f2d0 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -793,6 +793,45 @@ ieee80211_get_sdata_band(struct ieee80211_sub_if_data *sdata)
 	return band;
 }
 
+static inline int
+ieee80211_vif_get_divisor(struct ieee80211_vif *vif)
+{
+	struct ieee80211_chanctx_conf *chanctx_conf;
+	int divisor = 1;
+
+	rcu_read_lock();
+	chanctx_conf = rcu_dereference(vif->chanctx_conf);
+	if (chanctx_conf) {
+		switch (chanctx_conf->def.width) {
+		case NL80211_CHAN_WIDTH_5:
+			divisor = 4;
+			break;
+		case NL80211_CHAN_WIDTH_10:
+			divisor = 2;
+			break;
+		default:
+			divisor = 1;
+			break;
+		}
+	}
+	rcu_read_unlock();
+
+	return divisor;
+}
+
+static inline int
+ieee80211_hw_get_divisor(struct ieee80211_hw *hw)
+{
+	switch (hw->conf.chandef.width) {
+	case NL80211_CHAN_WIDTH_5:
+		return 4;
+	case NL80211_CHAN_WIDTH_10:
+		return 2;
+	default:
+		return 1;
+	}
+}
+
 enum sdata_queue_type {
 	IEEE80211_SDATA_QUEUE_TYPE_FRAME	= 0,
 	IEEE80211_SDATA_QUEUE_AGG_START		= 1,
@@ -1448,7 +1487,8 @@ extern void *mac80211_wiphy_privid; /* for wiphy privid */
 u8 *ieee80211_get_bssid(struct ieee80211_hdr *hdr, size_t len,
 			enum nl80211_iftype type);
 int ieee80211_frame_duration(enum ieee80211_band band, size_t len,
-			     int rate, int erp, int short_preamble);
+			     int rate, int erp, int short_preamble,
+			     int divisor);
 void mac80211_ev_michael_mic_failure(struct ieee80211_sub_if_data *sdata, int keyidx,
 				     struct ieee80211_hdr *hdr, const u8 *tsc,
 				     gfp_t gfp);
diff --git a/net/mac80211/rc80211_minstrel.c b/net/mac80211/rc80211_minstrel.c
index ac7ef54..3fe134a 100644
--- a/net/mac80211/rc80211_minstrel.c
+++ b/net/mac80211/rc80211_minstrel.c
@@ -382,14 +382,17 @@ minstrel_get_rate(void *priv, struct ieee80211_sta *sta,
 static void
 calc_rate_durations(enum ieee80211_band band,
 		    struct minstrel_rate *d,
-		    struct ieee80211_rate *rate)
+		    struct ieee80211_rate *rate,
+		    struct minstrel_priv *mp)
 {
 	int erp = !!(rate->flags & IEEE80211_RATE_ERP_G);
 
 	d->perfect_tx_time = ieee80211_frame_duration(band, 1200,
-			rate->bitrate, erp, 1);
+			rate->bitrate, erp, 1,
+			ieee80211_hw_get_divisor(mp->hw));
 	d->ack_time = ieee80211_frame_duration(band, 10,
-			rate->bitrate, erp, 1);
+			rate->bitrate, erp, 1,
+			ieee80211_hw_get_divisor(mp->hw));
 }
 
 static void
@@ -430,7 +433,8 @@ minstrel_rate_init(void *priv, struct ieee80211_supported_band *sband,
 	ctl_rate = &sband->bitrates[mi->lowest_rix];
 	mi->sp_ack_dur = ieee80211_frame_duration(sband->band, 10,
 				ctl_rate->bitrate,
-				!!(ctl_rate->flags & IEEE80211_RATE_ERP_G), 1);
+				!!(ctl_rate->flags & IEEE80211_RATE_ERP_G), 1,
+				ieee80211_hw_get_divisor(mp->hw));
 
 	memset(mi->max_tp_rate, 0, sizeof(mi->max_tp_rate));
 	mi->max_prob_rate = 0;
@@ -448,7 +452,7 @@ minstrel_rate_init(void *priv, struct ieee80211_supported_band *sband,
 
 		mr->rix = i;
 		mr->bitrate = sband->bitrates[i].bitrate / 5;
-		calc_rate_durations(sband->band, mr, &sband->bitrates[i]);
+		calc_rate_durations(sband->band, mr, &sband->bitrates[i], mp);
 
 		/* calculate maximum number of retransmissions before
 		 * fallback (based on maximum segment size) */
diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index 5b2d301..f05eeff 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -844,7 +844,7 @@ minstrel_ht_update_caps(void *priv, struct ieee80211_supported_band *sband,
 	struct ieee80211_mcs_info *mcs = &sta->ht_cap.mcs;
 	u16 sta_cap = sta->ht_cap.cap;
 	int n_supported = 0;
-	int ack_dur;
+	int ack_dur, divisor;
 	int stbc;
 	int i;
 
@@ -861,8 +861,10 @@ minstrel_ht_update_caps(void *priv, struct ieee80211_supported_band *sband,
 	mi->sta = sta;
 	mi->stats_update = jiffies;
 
-	ack_dur = ieee80211_frame_duration(sband->band, 10, 60, 1, 1);
-	mi->overhead = ieee80211_frame_duration(sband->band, 0, 60, 1, 1) + ack_dur;
+	divisor = ieee80211_hw_get_divisor(mp->hw);
+	ack_dur = ieee80211_frame_duration(sband->band, 10, 60, 1, 1, divisor);
+	mi->overhead = ieee80211_frame_duration(sband->band, 0, 60, 1, 1,
+						divisor) + ack_dur;
 	mi->overhead_rtscts = mi->overhead + 2 * ack_dur;
 
 	mi->avg_ampdu_len = MINSTREL_FRAC(1, 1);
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 9972e07..e1f18a8 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -40,7 +40,7 @@ static __le16 ieee80211_duration(struct ieee80211_tx_data *tx,
 				 struct sk_buff *skb, int group_addr,
 				 int next_frag_len)
 {
-	int rate, mrate, erp, dur, i;
+	int rate, mrate, erp, dur, i, divisor;
 	struct ieee80211_rate *txrate;
 	struct ieee80211_local *local = tx->local;
 	struct ieee80211_supported_band *sband;
@@ -153,6 +153,8 @@ static __le16 ieee80211_duration(struct ieee80211_tx_data *tx,
 		rate = mrate;
 	}
 
+	divisor = ieee80211_vif_get_divisor(&tx->sdata->vif);
+
 	/* Don't calculate ACKs for QoS Frames with NoAck Policy set */
 	if (ieee80211_is_data_qos(hdr->frame_control) &&
 	    *(ieee80211_get_qos_ctl(hdr)) & IEEE80211_QOS_CTL_ACK_POLICY_NOACK)
@@ -162,7 +164,8 @@ static __le16 ieee80211_duration(struct ieee80211_tx_data *tx,
 		 * (10 bytes + 4-byte FCS = 112 bits) plus SIFS; rounded up
 		 * to closest integer */
 		dur = ieee80211_frame_duration(sband->band, 10, rate, erp,
-				tx->sdata->vif.bss_conf.use_short_preamble);
+				tx->sdata->vif.bss_conf.use_short_preamble,
+				divisor);
 
 	if (next_frag_len) {
 		/* Frame is fragmented: duration increases with time needed to
@@ -171,7 +174,8 @@ static __le16 ieee80211_duration(struct ieee80211_tx_data *tx,
 		/* next fragment */
 		dur += ieee80211_frame_duration(sband->band, next_frag_len,
 				txrate->bitrate, erp,
-				tx->sdata->vif.bss_conf.use_short_preamble);
+				tx->sdata->vif.bss_conf.use_short_preamble,
+				divisor);
 	}
 
 	return cpu_to_le16(dur);
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 3f87fa4..5496764 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -107,7 +107,8 @@ void ieee80211_tx_set_protected(struct ieee80211_tx_data *tx)
 }
 
 int ieee80211_frame_duration(enum ieee80211_band band, size_t len,
-			     int rate, int erp, int short_preamble)
+			     int rate, int erp, int short_preamble,
+			     int divisor)
 {
 	int dur;
 
@@ -118,6 +119,9 @@ int ieee80211_frame_duration(enum ieee80211_band band, size_t len,
 	 *
 	 * rate is in 100 kbps, so divident is multiplied by 10 in the
 	 * DIV_ROUND_UP() operations.
+	 *
+	 * divisor may be 4 for 5 MHz channels or 2 for 1 MHz channels, and
+	 * is assumed to be 1 otherwise.
 	 */
 
 	if (band == IEEE80211_BAND_5GHZ || erp) {
@@ -130,15 +134,21 @@ int ieee80211_frame_duration(enum ieee80211_band band, size_t len,
 		 * TXTIME = T_PREAMBLE + T_SIGNAL + T_SYM x N_SYM + Signal Ext
 		 *
 		 * T_SYM = 4 usec
-		 * 802.11a - 17.5.2: aSIFSTime = 16 usec
+		 * 802.11a - 18.5.2: aSIFSTime = 16 usec
 		 * 802.11g - 19.8.4: aSIFSTime = 10 usec +
 		 *	signal ext = 6 usec
 		 */
 		dur = 16; /* SIFS + signal ext */
-		dur += 16; /* 17.3.2.3: T_PREAMBLE = 16 usec */
-		dur += 4; /* 17.3.2.3: T_SIGNAL = 4 usec */
+		dur += 16; /* IEEE 802.11-2012 18.3.2.4: T_PREAMBLE = 16 usec */
+		dur += 4; /* IEEE 802.11-2012 18.3.2.4: T_SIGNAL = 4 usec */
 		dur += 4 * DIV_ROUND_UP((16 + 8 * (len + 4) + 6) * 10,
 					4 * rate); /* T_SYM x N_SYM */
+
+		/* IEEE 802.11-2012 18.3.2.4: all values above are:
+		 *  * times 4 for 5 MHz
+		 *  * times 2 for 10 MHz
+		 */
+		dur *= divisor;
 	} else {
 		/*
 		 * 802.11b or 802.11g with 802.11b compatibility:
@@ -168,7 +178,7 @@ __le16 ieee80211_generic_frame_duration(struct ieee80211_hw *hw,
 {
 	struct ieee80211_sub_if_data *sdata;
 	u16 dur;
-	int erp;
+	int erp, divisor = 1;
 	bool short_preamble = false;
 
 	erp = 0;
@@ -177,10 +187,11 @@ __le16 ieee80211_generic_frame_duration(struct ieee80211_hw *hw,
 		short_preamble = sdata->vif.bss_conf.use_short_preamble;
 		if (sdata->flags & IEEE80211_SDATA_OPERATING_GMODE)
 			erp = rate->flags & IEEE80211_RATE_ERP_G;
+		divisor = ieee80211_vif_get_divisor(vif);
 	}
 
 	dur = ieee80211_frame_duration(band, frame_len, rate->bitrate, erp,
-				       short_preamble);
+				       short_preamble, divisor);
 
 	return cpu_to_le16(dur);
 }
@@ -194,7 +205,7 @@ __le16 ieee80211_rts_duration(struct ieee80211_hw *hw,
 	struct ieee80211_rate *rate;
 	struct ieee80211_sub_if_data *sdata;
 	bool short_preamble;
-	int erp;
+	int erp, divisor = 1;
 	u16 dur;
 	struct ieee80211_supported_band *sband;
 
@@ -210,17 +221,18 @@ __le16 ieee80211_rts_duration(struct ieee80211_hw *hw,
 		short_preamble = sdata->vif.bss_conf.use_short_preamble;
 		if (sdata->flags & IEEE80211_SDATA_OPERATING_GMODE)
 			erp = rate->flags & IEEE80211_RATE_ERP_G;
+		divisor = ieee80211_vif_get_divisor(vif);
 	}
 
 	/* CTS duration */
 	dur = ieee80211_frame_duration(sband->band, 10, rate->bitrate,
-				       erp, short_preamble);
+				       erp, short_preamble, divisor);
 	/* Data frame duration */
 	dur += ieee80211_frame_duration(sband->band, frame_len, rate->bitrate,
-					erp, short_preamble);
+					erp, short_preamble, divisor);
 	/* ACK duration */
 	dur += ieee80211_frame_duration(sband->band, 10, rate->bitrate,
-					erp, short_preamble);
+					erp, short_preamble, divisor);
 
 	return cpu_to_le16(dur);
 }
@@ -235,7 +247,7 @@ __le16 ieee80211_ctstoself_duration(struct ieee80211_hw *hw,
 	struct ieee80211_rate *rate;
 	struct ieee80211_sub_if_data *sdata;
 	bool short_preamble;
-	int erp;
+	int erp, divisor = 1;
 	u16 dur;
 	struct ieee80211_supported_band *sband;
 
@@ -250,15 +262,16 @@ __le16 ieee80211_ctstoself_duration(struct ieee80211_hw *hw,
 		short_preamble = sdata->vif.bss_conf.use_short_preamble;
 		if (sdata->flags & IEEE80211_SDATA_OPERATING_GMODE)
 			erp = rate->flags & IEEE80211_RATE_ERP_G;
+		divisor = ieee80211_vif_get_divisor(vif);
 	}
 
 	/* Data frame duration */
 	dur = ieee80211_frame_duration(sband->band, frame_len, rate->bitrate,
-				       erp, short_preamble);
+				       erp, short_preamble, divisor);
 	if (!(frame_txctl->flags & IEEE80211_TX_CTL_NO_ACK)) {
 		/* ACK duration */
 		dur += ieee80211_frame_duration(sband->band, 10, rate->bitrate,
-						erp, short_preamble);
+						erp, short_preamble, divisor);
 	}
 
 	return cpu_to_le16(dur);
-- 
1.7.10.4

