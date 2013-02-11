Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:40134 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757110Ab3BKNgK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Feb 2013 08:36:10 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH v2 3/3] mac80211/minstrel_ht: add support for using CCK rates
Date: Mon, 11 Feb 2013 14:36:05 +0100
Message-Id: <1360589765-58642-3-git-send-email-nbd@openwrt.org> (sfid-20130211_143621_309912_F721DBB3)
In-Reply-To: <1360589765-58642-2-git-send-email-nbd@openwrt.org>
References: <1360589765-58642-1-git-send-email-nbd@openwrt.org>
 <1360589765-58642-2-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When MCS rates start to get bad in 2.4 GHz because of long range or
strong interference, CCK rates can be a lot more robust.

This patch adds a pseudo MCS group containing CCK rates (long preamble
in the lower 4 slots, short preamble in the upper slots).

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 net/mac80211/rc80211_minstrel.c            |  29 ++++++
 net/mac80211/rc80211_minstrel.h            |   2 +
 net/mac80211/rc80211_minstrel_ht.c         | 152 +++++++++++++++++++++++++----
 net/mac80211/rc80211_minstrel_ht.h         |   5 +-
 net/mac80211/rc80211_minstrel_ht_debugfs.c | 109 +++++++++++++--------
 5 files changed, 237 insertions(+), 60 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel.c b/net/mac80211/rc80211_minstrel.c
index 8c5acdc..eea45a2 100644
--- a/net/mac80211/rc80211_minstrel.c
+++ b/net/mac80211/rc80211_minstrel.c
@@ -494,6 +494,33 @@ minstrel_free_sta(void *priv, struct ieee80211_sta *sta, void *priv_sta)
 	kfree(mi);
 }
 
+static void
+minstrel_init_cck_rates(struct minstrel_priv *mp)
+{
+	static const int bitrates[4] = { 10, 20, 55, 110 };
+	struct ieee80211_supported_band *sband;
+	int i, j;
+
+	sband = mp->hw->wiphy->bands[IEEE80211_BAND_2GHZ];
+	if (!sband)
+		return;
+
+	for (i = 0, j = 0; i < sband->n_bitrates; i++) {
+		struct ieee80211_rate *rate = &sband->bitrates[i];
+
+		if (rate->flags & IEEE80211_RATE_ERP_G)
+			continue;
+
+		for (j = 0; j < ARRAY_SIZE(bitrates); j++) {
+			if (rate->bitrate != bitrates[j])
+				continue;
+
+			mp->cck_rates[j] = i;
+			break;
+		}
+	}
+}
+
 static void *
 minstrel_alloc(struct ieee80211_hw *hw, struct dentry *debugfsdir)
 {
@@ -539,6 +566,8 @@ minstrel_alloc(struct ieee80211_hw *hw, struct dentry *debugfsdir)
 			S_IRUGO | S_IWUGO, debugfsdir, &mp->fixed_rate_idx);
 #endif
 
+	minstrel_init_cck_rates(mp);
+
 	return mp;
 }
 
diff --git a/net/mac80211/rc80211_minstrel.h b/net/mac80211/rc80211_minstrel.h
index 5d278ec..5ecf757 100644
--- a/net/mac80211/rc80211_minstrel.h
+++ b/net/mac80211/rc80211_minstrel.h
@@ -79,6 +79,8 @@ struct minstrel_priv {
 	unsigned int lookaround_rate;
 	unsigned int lookaround_rate_mrr;
 
+	u8 cck_rates[4];
+
 #ifdef CONFIG_MAC80211_DEBUGFS
 	/*
 	 * enable fixed rate processing per RC
diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index 5bb316a..ff65539 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (C) 2010 Felix Fietkau <nbd@openwrt.org>
+ * Copyright (C) 2010-2013 Felix Fietkau <nbd@openwrt.org>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -63,6 +63,30 @@
 	}								\
 }
 
+#define CCK_DURATION(_bitrate, _short, _len)		\
+	(10 /* SIFS */ +				\
+	 (_short ? 72 + 24 : 144 + 48 ) +		\
+	 (8 * (_len + 4) * 10) / (_bitrate))
+
+#define CCK_ACK_DURATION(_bitrate, _short)			\
+	(CCK_DURATION((_bitrate > 10 ? 20 : 10), false, 60) +	\
+	 CCK_DURATION(_bitrate, _short, AVG_PKT_SIZE))
+
+#define CCK_DURATION_LIST(_short)			\
+	CCK_ACK_DURATION(10, _short),			\
+	CCK_ACK_DURATION(20, _short),			\
+	CCK_ACK_DURATION(55, _short),			\
+	CCK_ACK_DURATION(110, _short)
+
+#define CCK_GROUP					\
+	{						\
+		.streams = 0,				\
+		.duration = {				\
+			CCK_DURATION_LIST(false),	\
+			CCK_DURATION_LIST(true)		\
+		}					\
+	}
+
 /*
  * To enable sufficiently targeted rate sampling, MCS rates are divided into
  * groups, based on the number of streams and flags (HT40, SGI) that they
@@ -95,8 +119,13 @@ const struct mcs_group minstrel_mcs_groups[] = {
 #if MINSTREL_MAX_STREAMS >= 3
 	MCS_GROUP(3, 1, 1),
 #endif
+
+	/* must be last */
+	CCK_GROUP
 };
 
+#define MINSTREL_CCK_GROUP	(ARRAY_SIZE(minstrel_mcs_groups) - 1)
+
 static u8 sample_table[SAMPLE_COLUMNS][MCS_GROUP_RATES];
 
 /*
@@ -119,6 +148,29 @@ minstrel_ht_get_group_idx(struct ieee80211_tx_rate *rate)
 			 !!(rate->flags & IEEE80211_TX_RC_40_MHZ_WIDTH));
 }
 
+struct minstrel_rate_stats *
+minstrel_ht_get_stats(struct minstrel_priv *mp, struct minstrel_ht_sta *mi,
+		      struct ieee80211_tx_rate *rate)
+{
+	int group, idx;
+
+	if (rate->flags & IEEE80211_TX_RC_MCS) {
+		group = minstrel_ht_get_group_idx(rate);
+		idx = rate->idx % MCS_GROUP_RATES;
+	} else {
+		group = MINSTREL_CCK_GROUP;
+
+		for (idx = 0; idx <= ARRAY_SIZE(mp->cck_rates); idx++)
+			if (rate->idx == mp->cck_rates[idx])
+				break;
+
+		/* short preamble */
+		if (!(mi->groups[group].supported & BIT(idx)))
+			idx += 4;
+	}
+	return &mi->groups[group].rates[idx];
+}
+
 static inline struct minstrel_rate_stats *
 minstrel_get_ratestats(struct minstrel_ht_sta *mi, int index)
 {
@@ -159,7 +211,7 @@ static void
 minstrel_ht_calc_tp(struct minstrel_ht_sta *mi, int group, int rate)
 {
 	struct minstrel_rate_stats *mr;
-	unsigned int usecs;
+	unsigned int usecs = 0;
 
 	mr = &mi->groups[group].rates[rate];
 
@@ -168,7 +220,9 @@ minstrel_ht_calc_tp(struct minstrel_ht_sta *mi, int group, int rate)
 		return;
 	}
 
-	usecs = mi->overhead / MINSTREL_TRUNC(mi->avg_ampdu_len);
+	if (group != MINSTREL_CCK_GROUP)
+		usecs = mi->overhead / MINSTREL_TRUNC(mi->avg_ampdu_len);
+
 	usecs += minstrel_mcs_groups[group].duration[rate];
 	mr->cur_tp = MINSTREL_TRUNC((1000000 / usecs) * mr->probability);
 }
@@ -293,7 +347,7 @@ minstrel_ht_update_stats(struct minstrel_priv *mp, struct minstrel_ht_sta *mi)
 }
 
 static bool
-minstrel_ht_txstat_valid(struct ieee80211_tx_rate *rate)
+minstrel_ht_txstat_valid(struct minstrel_priv *mp, struct ieee80211_tx_rate *rate)
 {
 	if (rate->idx < 0)
 		return false;
@@ -301,7 +355,13 @@ minstrel_ht_txstat_valid(struct ieee80211_tx_rate *rate)
 	if (!rate->count)
 		return false;
 
-	return !!(rate->flags & IEEE80211_TX_RC_MCS);
+	if (rate->flags & IEEE80211_TX_RC_MCS);
+		return true;
+
+	return rate->idx == mp->cck_rates[0] ||
+	       rate->idx == mp->cck_rates[1] ||
+	       rate->idx == mp->cck_rates[2] ||
+	       rate->idx == mp->cck_rates[3];
 }
 
 static void
@@ -386,7 +446,6 @@ minstrel_ht_tx_status(void *priv, struct ieee80211_supported_band *sband,
 	struct minstrel_rate_stats *rate, *rate2;
 	struct minstrel_priv *mp = priv;
 	bool last;
-	int group;
 	int i;
 
 	if (!msp->is_ht)
@@ -415,13 +474,12 @@ minstrel_ht_tx_status(void *priv, struct ieee80211_supported_band *sband,
 	if (info->flags & IEEE80211_TX_CTL_RATE_CTRL_PROBE)
 		mi->sample_packets += info->status.ampdu_len;
 
-	last = !minstrel_ht_txstat_valid(&ar[0]);
+	last = !minstrel_ht_txstat_valid(mp, &ar[0]);
 	for (i = 0; !last; i++) {
 		last = (i == IEEE80211_TX_MAX_RATES - 1) ||
-		       !minstrel_ht_txstat_valid(&ar[i + 1]);
+		       !minstrel_ht_txstat_valid(mp, &ar[i + 1]);
 
-		group = minstrel_ht_get_group_idx(&ar[i]);
-		rate = &mi->groups[group].rates[ar[i].idx % 8];
+		rate = minstrel_ht_get_stats(mp, mi, &ar[i]);
 
 		if (last)
 			rate->success += info->status.ampdu_ack_len;
@@ -447,7 +505,8 @@ minstrel_ht_tx_status(void *priv, struct ieee80211_supported_band *sband,
 
 	if (time_after(jiffies, mi->stats_update + (mp->update_interval / 2 * HZ) / 1000)) {
 		minstrel_ht_update_stats(mp, mi);
-		if (!(info->flags & IEEE80211_TX_CTL_AMPDU))
+		if (!(info->flags & IEEE80211_TX_CTL_AMPDU) &&
+		    mi->max_prob_rate / MCS_GROUP_RATES != MINSTREL_CCK_GROUP)
 			minstrel_aggr_check(sta, skb);
 	}
 }
@@ -463,6 +522,7 @@ minstrel_calc_retransmit(struct minstrel_priv *mp, struct minstrel_ht_sta *mi,
 	unsigned int ctime = 0;
 	unsigned int t_slot = 9; /* FIXME */
 	unsigned int ampdu_len = MINSTREL_TRUNC(mi->avg_ampdu_len);
+	unsigned int overhead = 0, overhead_rtscts = 0;
 
 	mr = minstrel_get_ratestats(mi, index);
 	if (mr->probability < MINSTREL_FRAC(1, 10)) {
@@ -484,9 +544,14 @@ minstrel_calc_retransmit(struct minstrel_priv *mp, struct minstrel_ht_sta *mi,
 	ctime += (t_slot * cw) >> 1;
 	cw = min((cw << 1) | 1, mp->cw_max);
 
+	if (index / MCS_GROUP_RATES != MINSTREL_CCK_GROUP) {
+		overhead = mi->overhead;
+		overhead_rtscts = mi->overhead_rtscts;
+	}
+
 	/* Total TX time for data and Contention after first 2 tries */
-	tx_time = ctime + 2 * (mi->overhead + tx_time_data);
-	tx_time_rtscts = ctime + 2 * (mi->overhead_rtscts + tx_time_data);
+	tx_time = ctime + 2 * (overhead + tx_time_data);
+	tx_time_rtscts = ctime + 2 * (overhead_rtscts + tx_time_data);
 
 	/* See how many more tries we can fit inside segment size */
 	do {
@@ -495,8 +560,8 @@ minstrel_calc_retransmit(struct minstrel_priv *mp, struct minstrel_ht_sta *mi,
 		cw = min((cw << 1) | 1, mp->cw_max);
 
 		/* Total TX time after this try */
-		tx_time += ctime + mi->overhead + tx_time_data;
-		tx_time_rtscts += ctime + mi->overhead_rtscts + tx_time_data;
+		tx_time += ctime + overhead + tx_time_data;
+		tx_time_rtscts += ctime + overhead_rtscts + tx_time_data;
 
 		if (tx_time_rtscts < mp->segment_size)
 			mr->retry_count_rtscts++;
@@ -526,9 +591,16 @@ minstrel_ht_set_rate(struct minstrel_priv *mp, struct minstrel_ht_sta *mi,
 	else
 		rate->count = mr->retry_count;
 
-	rate->flags = IEEE80211_TX_RC_MCS | group->flags;
+	rate->flags = 0;
 	if (rtscts)
 		rate->flags |= IEEE80211_TX_RC_USE_RTS_CTS;
+
+	if (index / MCS_GROUP_RATES == MINSTREL_CCK_GROUP) {
+		rate->idx = mp->cck_rates[index % ARRAY_SIZE(mp->cck_rates)];
+		return;
+	}
+
+	rate->flags |= IEEE80211_TX_RC_MCS | group->flags;
 	rate->idx = index % MCS_GROUP_RATES + (group->streams - 1) * MCS_GROUP_RATES;
 }
 
@@ -592,6 +664,22 @@ minstrel_get_sample_rate(struct minstrel_priv *mp, struct minstrel_ht_sta *mi)
 }
 
 static void
+minstrel_ht_check_cck_shortpreamble(struct minstrel_priv *mp,
+				    struct minstrel_ht_sta *mi, bool val)
+{
+	u8 supported = mi->groups[MINSTREL_CCK_GROUP].supported;
+
+	if (!supported || !mi->cck_supported_short)
+		return;
+
+	if (supported & (mi->cck_supported_short << (val * 4)))
+		return;
+
+	supported ^= mi->cck_supported_short | (mi->cck_supported_short << 4);
+	mi->groups[MINSTREL_CCK_GROUP].supported = supported;
+}
+
+static void
 minstrel_ht_get_rate(void *priv, struct ieee80211_sta *sta, void *priv_sta,
                      struct ieee80211_tx_rate_control *txrc)
 {
@@ -610,6 +698,7 @@ minstrel_ht_get_rate(void *priv, struct ieee80211_sta *sta, void *priv_sta,
 		return mac80211_minstrel.get_rate(priv, sta, &msp->legacy, txrc);
 
 	info->flags |= mi->tx_flags;
+	minstrel_ht_check_cck_shortpreamble(mp, mi, txrc->short_preamble);
 
 	/* Don't use EAPOL frames for sampling on non-mrr hw */
 	if (mp->hw->max_rates == 1 &&
@@ -683,6 +772,30 @@ minstrel_ht_get_rate(void *priv, struct ieee80211_sta *sta, void *priv_sta,
 }
 
 static void
+minstrel_ht_update_cck(struct minstrel_priv *mp, struct minstrel_ht_sta *mi,
+		       struct ieee80211_supported_band *sband,
+		       struct ieee80211_sta *sta)
+{
+	int i;
+
+	if (sband->band != IEEE80211_BAND_2GHZ)
+		return;
+
+	mi->cck_supported = 0;
+	mi->cck_supported_short = 0;
+	for (i = 0; i < 4; i++) {
+		if (!rate_supported(sta, sband->band, mp->cck_rates[i]))
+			continue;
+
+		mi->cck_supported |= BIT(i);
+		if (sband->bitrates[i].flags & IEEE80211_RATE_SHORT_PREAMBLE)
+			mi->cck_supported_short |= BIT(i);
+	}
+
+	mi->groups[MINSTREL_CCK_GROUP].supported = mi->cck_supported;
+}
+
+static void
 minstrel_ht_update_caps(void *priv, struct ieee80211_supported_band *sband,
                         struct ieee80211_sta *sta, void *priv_sta)
 {
@@ -702,7 +815,7 @@ minstrel_ht_update_caps(void *priv, struct ieee80211_supported_band *sband,
 		goto use_legacy;
 
 	BUILD_BUG_ON(ARRAY_SIZE(minstrel_mcs_groups) !=
-		MINSTREL_MAX_STREAMS * MINSTREL_STREAM_GROUPS);
+		MINSTREL_MAX_STREAMS * MINSTREL_STREAM_GROUPS + 1);
 
 	msp->is_ht = true;
 	memset(mi, 0, sizeof(*mi));
@@ -738,6 +851,11 @@ minstrel_ht_update_caps(void *priv, struct ieee80211_supported_band *sband,
 		u16 req = 0;
 
 		mi->groups[i].supported = 0;
+		if (i == MINSTREL_CCK_GROUP) {
+			minstrel_ht_update_cck(mp, mi, sband, sta);
+			continue;
+		}
+
 		if (minstrel_mcs_groups[i].flags & IEEE80211_TX_RC_SHORT_GI) {
 			if (minstrel_mcs_groups[i].flags & IEEE80211_TX_RC_40_MHZ_WIDTH)
 				req |= IEEE80211_HT_CAP_SGI_40;
diff --git a/net/mac80211/rc80211_minstrel_ht.h b/net/mac80211/rc80211_minstrel_ht.h
index 462d2b2..302dbd5 100644
--- a/net/mac80211/rc80211_minstrel_ht.h
+++ b/net/mac80211/rc80211_minstrel_ht.h
@@ -107,8 +107,11 @@ struct minstrel_ht_sta {
 	/* current MCS group to be sampled */
 	u8 sample_group;
 
+	u8 cck_supported;
+	u8 cck_supported_short;
+
 	/* MCS rate group info and statistics */
-	struct minstrel_mcs_group_data groups[MINSTREL_MAX_STREAMS * MINSTREL_STREAM_GROUPS];
+	struct minstrel_mcs_group_data groups[MINSTREL_MAX_STREAMS * MINSTREL_STREAM_GROUPS + 1];
 };
 
 struct minstrel_ht_sta_priv {
diff --git a/net/mac80211/rc80211_minstrel_ht_debugfs.c b/net/mac80211/rc80211_minstrel_ht_debugfs.c
index f2b7d26..df44a5a 100644
--- a/net/mac80211/rc80211_minstrel_ht_debugfs.c
+++ b/net/mac80211/rc80211_minstrel_ht_debugfs.c
@@ -15,13 +15,76 @@
 #include "rc80211_minstrel.h"
 #include "rc80211_minstrel_ht.h"
 
+static char *
+minstrel_ht_stats_dump(struct minstrel_ht_sta *mi, int i, char *p)
+{
+	unsigned int max_mcs = MINSTREL_MAX_STREAMS * MINSTREL_STREAM_GROUPS;
+	const struct mcs_group *mg;
+	unsigned int j, tp, prob, eprob;
+	char htmode = '2';
+	char gimode = 'L';
+
+	if (!mi->groups[i].supported)
+		return p;
+
+	mg = &minstrel_mcs_groups[i];
+	if (mg->flags & IEEE80211_TX_RC_40_MHZ_WIDTH)
+		htmode = '4';
+	if (mg->flags & IEEE80211_TX_RC_SHORT_GI)
+		gimode = 'S';
+
+	for (j = 0; j < MCS_GROUP_RATES; j++) {
+		struct minstrel_rate_stats *mr = &mi->groups[i].rates[j];
+		static const int bitrates[4] = { 10, 20, 55, 110 };
+		int idx = i * MCS_GROUP_RATES + j;
+
+		if (!(mi->groups[i].supported & BIT(j)))
+			continue;
+
+		if (i == max_mcs)
+			p += sprintf(p, "CCK/%cP   ", j < 4 ? 'L' : 'S');
+		else
+			p += sprintf(p, "HT%c0/%cGI ", htmode, gimode);
+
+		*(p++) = (idx == mi->max_tp_rate) ? 'T' : ' ';
+		*(p++) = (idx == mi->max_tp_rate2) ? 't' : ' ';
+		*(p++) = (idx == mi->max_prob_rate) ? 'P' : ' ';
+
+		if (i == max_mcs) {
+			int r = bitrates[j % 4];
+			p += sprintf(p, " %2u.%1uM", r / 10, r % 10);
+		} else {
+			p += sprintf(p, " MCS%-2u", (mg->streams - 1) *
+					 MCS_GROUP_RATES + j);
+		}
+
+		tp = mr->cur_tp / 10;
+		prob = MINSTREL_TRUNC(mr->cur_prob * 1000);
+		eprob = MINSTREL_TRUNC(mr->probability * 1000);
+
+		p += sprintf(p, "      %6u.%1u   %6u.%1u    %6u.%1u    "
+				"%3u            %3u(%3u)  %8llu    %8llu\n",
+				tp / 10, tp % 10,
+				eprob / 10, eprob % 10,
+				prob / 10, prob % 10,
+				mr->retry_count,
+				mr->last_success,
+				mr->last_attempts,
+				(unsigned long long)mr->succ_hist,
+				(unsigned long long)mr->att_hist);
+	}
+
+	return p;
+}
+
 static int
 minstrel_ht_stats_open(struct inode *inode, struct file *file)
 {
 	struct minstrel_ht_sta_priv *msp = inode->i_private;
 	struct minstrel_ht_sta *mi = &msp->ht;
 	struct minstrel_debugfs_info *ms;
-	unsigned int i, j, tp, prob, eprob;
+	unsigned int i;
+	unsigned int max_mcs = MINSTREL_MAX_STREAMS * MINSTREL_STREAM_GROUPS;
 	char *p;
 	int ret;
 
@@ -40,49 +103,11 @@ minstrel_ht_stats_open(struct inode *inode, struct file *file)
 	p = ms->buf;
 	p += sprintf(p, "type         rate     throughput  ewma prob   this prob  "
 			"retry   this succ/attempt   success    attempts\n");
-	for (i = 0; i < MINSTREL_MAX_STREAMS * MINSTREL_STREAM_GROUPS; i++) {
-		char htmode = '2';
-		char gimode = 'L';
-
-		if (!mi->groups[i].supported)
-			continue;
-
-		if (minstrel_mcs_groups[i].flags & IEEE80211_TX_RC_40_MHZ_WIDTH)
-			htmode = '4';
-		if (minstrel_mcs_groups[i].flags & IEEE80211_TX_RC_SHORT_GI)
-			gimode = 'S';
 
-		for (j = 0; j < MCS_GROUP_RATES; j++) {
-			struct minstrel_rate_stats *mr = &mi->groups[i].rates[j];
-			int idx = i * MCS_GROUP_RATES + j;
+	p = minstrel_ht_stats_dump(mi, max_mcs, p);
+	for (i = 0; i < max_mcs; i++)
+		p = minstrel_ht_stats_dump(mi, i, p);
 
-			if (!(mi->groups[i].supported & BIT(j)))
-				continue;
-
-			p += sprintf(p, "HT%c0/%cGI ", htmode, gimode);
-
-			*(p++) = (idx == mi->max_tp_rate) ? 'T' : ' ';
-			*(p++) = (idx == mi->max_tp_rate2) ? 't' : ' ';
-			*(p++) = (idx == mi->max_prob_rate) ? 'P' : ' ';
-			p += sprintf(p, " MCS%-2u", (minstrel_mcs_groups[i].streams - 1) *
-					MCS_GROUP_RATES + j);
-
-			tp = mr->cur_tp / 10;
-			prob = MINSTREL_TRUNC(mr->cur_prob * 1000);
-			eprob = MINSTREL_TRUNC(mr->probability * 1000);
-
-			p += sprintf(p, "      %6u.%1u   %6u.%1u    %6u.%1u    "
-					"%3u            %3u(%3u)  %8llu    %8llu\n",
-					tp / 10, tp % 10,
-					eprob / 10, eprob % 10,
-					prob / 10, prob % 10,
-					mr->retry_count,
-					mr->last_success,
-					mr->last_attempts,
-					(unsigned long long)mr->succ_hist,
-					(unsigned long long)mr->att_hist);
-		}
-	}
 	p += sprintf(p, "\nTotal packet count::    ideal %d      "
 			"lookaround %d\n",
 			max(0, (int) mi->total_packets - (int) mi->sample_packets),
-- 
1.8.0.2

