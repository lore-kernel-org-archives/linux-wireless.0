Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:54205 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756514AbcLNTrM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Dec 2016 14:47:12 -0500
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, thomas.huehn@evernet-eg.de
Subject: [PATCH 01/10] mac80211: minstrel_ht: move supported bitrate mask out of group data
Date: Wed, 14 Dec 2016 20:46:54 +0100
Message-Id: <20161214194703.33429-1-nbd@nbd.name> (sfid-20161214_204753_937248_15130A76)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Improves dcache footprint by ensuring that fewer cache lines need to be
touched.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 net/mac80211/rc80211_minstrel_ht.c         | 30 +++++++++++++++---------------
 net/mac80211/rc80211_minstrel_ht.h         |  6 +++---
 net/mac80211/rc80211_minstrel_ht_debugfs.c |  8 ++++----
 3 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index 30fbabf..ed8a34d 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -301,7 +301,7 @@ minstrel_ht_get_stats(struct minstrel_priv *mp, struct minstrel_ht_sta *mi,
 				break;
 
 		/* short preamble */
-		if (!(mi->groups[group].supported & BIT(idx)))
+		if (!(mi->supported[group] & BIT(idx)))
 			idx += 4;
 	}
 	return &mi->groups[group].rates[idx];
@@ -486,7 +486,7 @@ minstrel_ht_prob_rate_reduce_streams(struct minstrel_ht_sta *mi)
 			  MCS_GROUP_RATES].streams;
 	for (group = 0; group < ARRAY_SIZE(minstrel_mcs_groups); group++) {
 		mg = &mi->groups[group];
-		if (!mg->supported || group == MINSTREL_CCK_GROUP)
+		if (!mi->supported[group] || group == MINSTREL_CCK_GROUP)
 			continue;
 
 		tmp_idx = mg->max_group_prob_rate % MCS_GROUP_RATES;
@@ -540,7 +540,7 @@ minstrel_ht_update_stats(struct minstrel_priv *mp, struct minstrel_ht_sta *mi)
 	for (group = 0; group < ARRAY_SIZE(minstrel_mcs_groups); group++) {
 
 		mg = &mi->groups[group];
-		if (!mg->supported)
+		if (!mi->supported[group])
 			continue;
 
 		mi->sample_count++;
@@ -550,7 +550,7 @@ minstrel_ht_update_stats(struct minstrel_priv *mp, struct minstrel_ht_sta *mi)
 			tmp_group_tp_rate[j] = group;
 
 		for (i = 0; i < MCS_GROUP_RATES; i++) {
-			if (!(mg->supported & BIT(i)))
+			if (!(mi->supported[group] & BIT(i)))
 				continue;
 
 			index = MCS_GROUP_RATES * group + i;
@@ -636,7 +636,7 @@ minstrel_set_next_sample_idx(struct minstrel_ht_sta *mi)
 		mi->sample_group %= ARRAY_SIZE(minstrel_mcs_groups);
 		mg = &mi->groups[mi->sample_group];
 
-		if (!mg->supported)
+		if (!mi->supported[mi->sample_group])
 			continue;
 
 		if (++mg->index >= MCS_GROUP_RATES) {
@@ -657,7 +657,7 @@ minstrel_downgrade_rate(struct minstrel_ht_sta *mi, u16 *idx, bool primary)
 	while (group > 0) {
 		group--;
 
-		if (!mi->groups[group].supported)
+		if (!mi->supported[group])
 			continue;
 
 		if (minstrel_mcs_groups[group].streams >
@@ -994,7 +994,7 @@ minstrel_get_sample_rate(struct minstrel_priv *mp, struct minstrel_ht_sta *mi)
 	sample_idx = sample_table[mg->column][mg->index];
 	minstrel_set_next_sample_idx(mi);
 
-	if (!(mg->supported & BIT(sample_idx)))
+	if (!(mi->supported[sample_group] & BIT(sample_idx)))
 		return -1;
 
 	mrs = &mg->rates[sample_idx];
@@ -1052,7 +1052,7 @@ static void
 minstrel_ht_check_cck_shortpreamble(struct minstrel_priv *mp,
 				    struct minstrel_ht_sta *mi, bool val)
 {
-	u8 supported = mi->groups[MINSTREL_CCK_GROUP].supported;
+	u8 supported = mi->supported[MINSTREL_CCK_GROUP];
 
 	if (!supported || !mi->cck_supported_short)
 		return;
@@ -1061,7 +1061,7 @@ minstrel_ht_check_cck_shortpreamble(struct minstrel_priv *mp,
 		return;
 
 	supported ^= mi->cck_supported_short | (mi->cck_supported_short << 4);
-	mi->groups[MINSTREL_CCK_GROUP].supported = supported;
+	mi->supported[MINSTREL_CCK_GROUP] = supported;
 }
 
 static void
@@ -1154,7 +1154,7 @@ minstrel_ht_update_cck(struct minstrel_priv *mp, struct minstrel_ht_sta *mi,
 			mi->cck_supported_short |= BIT(i);
 	}
 
-	mi->groups[MINSTREL_CCK_GROUP].supported = mi->cck_supported;
+	mi->supported[MINSTREL_CCK_GROUP] = mi->cck_supported;
 }
 
 static void
@@ -1224,7 +1224,7 @@ minstrel_ht_update_caps(void *priv, struct ieee80211_supported_band *sband,
 		u32 gflags = minstrel_mcs_groups[i].flags;
 		int bw, nss;
 
-		mi->groups[i].supported = 0;
+		mi->supported[i] = 0;
 		if (i == MINSTREL_CCK_GROUP) {
 			minstrel_ht_update_cck(mp, mi, sband, sta);
 			continue;
@@ -1256,8 +1256,8 @@ minstrel_ht_update_caps(void *priv, struct ieee80211_supported_band *sband,
 			if (use_vht && minstrel_vht_only)
 				continue;
 #endif
-			mi->groups[i].supported = mcs->rx_mask[nss - 1];
-			if (mi->groups[i].supported)
+			mi->supported[i] = mcs->rx_mask[nss - 1];
+			if (mi->supported[i])
 				n_supported++;
 			continue;
 		}
@@ -1283,10 +1283,10 @@ minstrel_ht_update_caps(void *priv, struct ieee80211_supported_band *sband,
 		else
 			bw = BW_20;
 
-		mi->groups[i].supported = minstrel_get_valid_vht_rates(bw, nss,
+		mi->supported[i] = minstrel_get_valid_vht_rates(bw, nss,
 				vht_cap->vht_mcs.tx_mcs_map);
 
-		if (mi->groups[i].supported)
+		if (mi->supported[i])
 			n_supported++;
 	}
 
diff --git a/net/mac80211/rc80211_minstrel_ht.h b/net/mac80211/rc80211_minstrel_ht.h
index e8b52a9..de1646c 100644
--- a/net/mac80211/rc80211_minstrel_ht.h
+++ b/net/mac80211/rc80211_minstrel_ht.h
@@ -52,9 +52,6 @@ struct minstrel_mcs_group_data {
 	u8 index;
 	u8 column;
 
-	/* bitfield of supported MCS rates of this group */
-	u16 supported;
-
 	/* sorted rate set within a MCS group*/
 	u16 max_group_tp_rate[MAX_THR_RATES];
 	u16 max_group_prob_rate;
@@ -101,6 +98,9 @@ struct minstrel_ht_sta {
 	u8 cck_supported;
 	u8 cck_supported_short;
 
+	/* Bitfield of supported MCS rates of all groups */
+	u16 supported[MINSTREL_GROUPS_NB];
+
 	/* MCS rate group info and statistics */
 	struct minstrel_mcs_group_data groups[MINSTREL_GROUPS_NB];
 };
diff --git a/net/mac80211/rc80211_minstrel_ht_debugfs.c b/net/mac80211/rc80211_minstrel_ht_debugfs.c
index 5320e35..1942d4b 100644
--- a/net/mac80211/rc80211_minstrel_ht_debugfs.c
+++ b/net/mac80211/rc80211_minstrel_ht_debugfs.c
@@ -24,7 +24,7 @@ minstrel_ht_stats_dump(struct minstrel_ht_sta *mi, int i, char *p)
 	char gimode = 'L';
 	u32 gflags;
 
-	if (!mi->groups[i].supported)
+	if (!mi->supported[i])
 		return p;
 
 	mg = &minstrel_mcs_groups[i];
@@ -42,7 +42,7 @@ minstrel_ht_stats_dump(struct minstrel_ht_sta *mi, int i, char *p)
 		static const int bitrates[4] = { 10, 20, 55, 110 };
 		int idx = i * MCS_GROUP_RATES + j;
 
-		if (!(mi->groups[i].supported & BIT(j)))
+		if (!(mi->supported[i] & BIT(j)))
 			continue;
 
 		if (gflags & IEEE80211_TX_RC_MCS) {
@@ -170,7 +170,7 @@ minstrel_ht_stats_csv_dump(struct minstrel_ht_sta *mi, int i, char *p)
 	char gimode = 'L';
 	u32 gflags;
 
-	if (!mi->groups[i].supported)
+	if (!mi->supported[i])
 		return p;
 
 	mg = &minstrel_mcs_groups[i];
@@ -188,7 +188,7 @@ minstrel_ht_stats_csv_dump(struct minstrel_ht_sta *mi, int i, char *p)
 		static const int bitrates[4] = { 10, 20, 55, 110 };
 		int idx = i * MCS_GROUP_RATES + j;
 
-		if (!(mi->groups[i].supported & BIT(j)))
+		if (!(mi->supported[i] & BIT(j)))
 			continue;
 
 		if (gflags & IEEE80211_TX_RC_MCS) {
-- 
2.10.1
