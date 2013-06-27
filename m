Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:45138 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752723Ab3F0Moi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Jun 2013 08:44:38 -0400
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCHv4 03/18] mac80211: fix timing for 5 MHz and 10 MHz channels
Date: Thu, 27 Jun 2013 14:44:09 +0200
Message-Id: <1372337064-19254-4-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20130627_144446_777774_B1896592)
In-Reply-To: <1372337064-19254-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1372337064-19254-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

according to IEEE 802.11-2012 section 18, various timings change
when using 5 MHz and 10 MHz. Reflect this by using a "divisor" when
calculating durations.

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
---
Changes to PATCHv3:
 * don't use hw.conf
 * remove net/mac80211/rc80211_minstrel_ht.c modifications
---
 net/mac80211/ieee80211_i.h         |   40 +++++++++++++++++++++++++++++++++++-
 net/mac80211/rc80211_minstrel.c    |   30 +++++++++++++++++++++------
 net/mac80211/rc80211_minstrel_ht.c |    5 +++--
 net/mac80211/tx.c                  |   10 ++++++---
 net/mac80211/util.c                |   39 +++++++++++++++++++++++------------
 5 files changed, 99 insertions(+), 25 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 0ccaaeb..83c248a 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -808,6 +808,43 @@ ieee80211_get_sdata_band(struct ieee80211_sub_if_data *sdata)
 	return band;
 }
 
+static inline int
+ieee80211_chandef_get_divisor(struct cfg80211_chan_def *chandef)
+{
+	switch (local->hw.conf.chandef.width) {
+	case NL80211_CHAN_WIDTH_5:
+		return 4;
+	case NL80211_CHAN_WIDTH_10:
+		return 2;
+	default:
+		return 1;
+	}
+}
+
+static inline int
+ieee80211_vif_get_divisor(struct ieee80211_vif *vif)
+{
+	struct ieee80211_chanctx_conf *chanctx_conf;
+	int divisor = 1;
+
+	rcu_read_lock();
+	chanctx_conf = rcu_dereference(vif->chanctx_conf);
+	if (chanctx_conf)
+		divisor = ieee80211_chandef_get_divisor(&chanctx_conf->def);
+	rcu_read_unlock();
+
+	return divisor;
+}
+
+static inline int
+ieee80211_local_get_divisor(struct ieee80211_local *local)
+{
+	if (local->use_chanctx)
+		return 1;
+
+	return ieee80211_chandef_get_divisor(&local->hw.conf.chandef);
+}
+
 enum sdata_queue_type {
 	IEEE80211_SDATA_QUEUE_TYPE_FRAME	= 0,
 	IEEE80211_SDATA_QUEUE_AGG_START		= 1,
@@ -1464,7 +1501,8 @@ extern void *mac80211_wiphy_privid; /* for wiphy privid */
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
index 5b25966..30a5578 100644
--- a/net/mac80211/rc80211_minstrel.c
+++ b/net/mac80211/rc80211_minstrel.c
@@ -382,14 +382,18 @@ minstrel_get_rate(void *priv, struct ieee80211_sta *sta,
 static void
 calc_rate_durations(enum ieee80211_band band,
 		    struct minstrel_rate *d,
-		    struct ieee80211_rate *rate)
+		    struct ieee80211_rate *rate,
+		    struct cfg80211_chan_def *chandef)
 {
 	int erp = !!(rate->flags & IEEE80211_RATE_ERP_G);
+	int divisor = ieee80211_chandef_get_divisor(chandef);
 
 	d->perfect_tx_time = ieee80211_frame_duration(band, 1200,
-			rate->bitrate, erp, 1);
+			DIV_ROUND_UP(rate->bitrate, divisor), erp, 1,
+			divisor);
 	d->ack_time = ieee80211_frame_duration(band, 10,
-			rate->bitrate, erp, 1);
+			DIV_ROUND_UP(rate->bitrate, divisor), erp, 1,
+			divisor);
 }
 
 static void
@@ -425,14 +429,17 @@ minstrel_rate_init(void *priv, struct ieee80211_supported_band *sband,
 	struct ieee80211_rate *ctl_rate;
 	unsigned int i, n = 0;
 	unsigned int t_slot = 9; /* FIXME: get real slot time */
+	u32 rate_flags;
 
 	mi->sta = sta;
 	mi->lowest_rix = rate_lowest_index(sband, sta);
 	ctl_rate = &sband->bitrates[mi->lowest_rix];
 	mi->sp_ack_dur = ieee80211_frame_duration(sband->band, 10,
 				ctl_rate->bitrate,
-				!!(ctl_rate->flags & IEEE80211_RATE_ERP_G), 1);
+				!!(ctl_rate->flags & IEEE80211_RATE_ERP_G), 1,
+				ieee80211_chandef_get_divisor(chandef));
 
+	rate_flags = ieee80211_chandef_rate_flags(&mp->hw->conf.chandef);
 	memset(mi->max_tp_rate, 0, sizeof(mi->max_tp_rate));
 	mi->max_prob_rate = 0;
 
@@ -441,15 +448,22 @@ minstrel_rate_init(void *priv, struct ieee80211_supported_band *sband,
 		unsigned int tx_time = 0, tx_time_cts = 0, tx_time_rtscts = 0;
 		unsigned int tx_time_single;
 		unsigned int cw = mp->cw_min;
+		int divisor;
 
 		if (!rate_supported(sta, sband->band, i))
 			continue;
+		if ((rate_flags & sband->bitrates[i].flags) != rate_flags)
+			continue;
+
 		n++;
 		memset(mr, 0, sizeof(*mr));
 
 		mr->rix = i;
-		mr->bitrate = sband->bitrates[i].bitrate / 5;
-		calc_rate_durations(sband->band, mr, &sband->bitrates[i]);
+		divisor = ieee80211_chandef_get_divisor(chandef);
+		mr->bitrate = DIV_ROUND_UP(sband->bitrates[i].bitrate,
+					   divisor * 5);
+		calc_rate_durations(sband->band, mr, &sband->bitrates[i],
+				    chandef);
 
 		/* calculate maximum number of retransmissions before
 		 * fallback (based on maximum segment size) */
@@ -547,6 +561,7 @@ minstrel_init_cck_rates(struct minstrel_priv *mp)
 {
 	static const int bitrates[4] = { 10, 20, 55, 110 };
 	struct ieee80211_supported_band *sband;
+	u32 rate_flags = ieee80211_chandef_rate_flags(&mp->hw->conf.chandef);
 	int i, j;
 
 	sband = mp->hw->wiphy->bands[IEEE80211_BAND_2GHZ];
@@ -559,6 +574,9 @@ minstrel_init_cck_rates(struct minstrel_priv *mp)
 		if (rate->flags & IEEE80211_RATE_ERP_G)
 			continue;
 
+		if ((rate_flags & sband->bitrates[i].flags) != rate_flags)
+			continue;
+
 		for (j = 0; j < ARRAY_SIZE(bitrates); j++) {
 			if (rate->bitrate != bitrates[j])
 				continue;
diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index 5256297..ffb5ee8 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -862,8 +862,9 @@ minstrel_ht_update_caps(void *priv, struct ieee80211_supported_band *sband,
 	mi->sta = sta;
 	mi->stats_update = jiffies;
 
-	ack_dur = ieee80211_frame_duration(sband->band, 10, 60, 1, 1);
-	mi->overhead = ieee80211_frame_duration(sband->band, 0, 60, 1, 1) + ack_dur;
+	ack_dur = ieee80211_frame_duration(sband->band, 10, 60, 1, 1, 1);
+	mi->overhead = ieee80211_frame_duration(sband->band, 0, 60, 1, 1, 1);
+	mi->overhead += ack_dur;
 	mi->overhead_rtscts = mi->overhead + 2 * ack_dur;
 
 	mi->avg_ampdu_len = MINSTREL_FRAC(1, 1);
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 4105d0c..69f3363 100644
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
index 2265445..978c15e 100644
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

