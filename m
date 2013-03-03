Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:56821 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753277Ab3CCLtz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Mar 2013 06:49:55 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH 1/2] mac80211/minstrel_ht: increase sampling frequency of some slower rates
Date: Sun,  3 Mar 2013 12:49:51 +0100
Message-Id: <1362311392-83648-1-git-send-email-nbd@openwrt.org> (sfid-20130303_125004_774796_2DABCAF2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If a rate is below the max_tp_rate, sample it frequently if:
- it is above max_tp_rate2, or
- it is above max_prob_rate and is a candidate for max_prob_rate
  (has fewer streams than max_tp_rate).
This helps the retry chain recover more quickly from bad statistics
caused by collisions or interference, and slightly reduces throughput
fluctuations with higher rates.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 net/mac80211/rc80211_minstrel_ht.c | 20 ++++++++++++--------
 net/mac80211/rc80211_minstrel_ht.h |  1 +
 2 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index 4d35bc5..1b69924 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -246,7 +246,6 @@ minstrel_ht_update_stats(struct minstrel_priv *mp, struct minstrel_ht_sta *mi)
 	struct minstrel_rate_stats *mr;
 	int cur_prob, cur_prob_tp, cur_tp, cur_tp2;
 	int group, i, index;
-	int prob_max_streams = 1;
 
 	if (mi->ampdu_packets > 0) {
 		mi->avg_ampdu_len = minstrel_ewma(mi->avg_ampdu_len,
@@ -330,7 +329,7 @@ minstrel_ht_update_stats(struct minstrel_priv *mp, struct minstrel_ht_sta *mi)
 			cur_tp2 = cur_tp;
 			mi->max_tp_rate = mg->max_tp_rate;
 			cur_tp = mr->cur_tp;
-			prob_max_streams = minstrel_mcs_groups[group].streams - 1;
+			mi->max_prob_streams = minstrel_mcs_groups[group].streams - 1;
 		}
 
 		mr = minstrel_get_ratestats(mi, mg->max_tp_rate2);
@@ -340,8 +339,8 @@ minstrel_ht_update_stats(struct minstrel_priv *mp, struct minstrel_ht_sta *mi)
 		}
 	}
 
-	if (prob_max_streams < 1)
-		prob_max_streams = 1;
+	if (mi->max_prob_streams < 1)
+		mi->max_prob_streams = 1;
 
 	for (group = 0; group < ARRAY_SIZE(minstrel_mcs_groups); group++) {
 		mg = &mi->groups[group];
@@ -349,7 +348,7 @@ minstrel_ht_update_stats(struct minstrel_priv *mp, struct minstrel_ht_sta *mi)
 			continue;
 		mr = minstrel_get_ratestats(mi, mg->max_prob_rate);
 		if (cur_prob_tp < mr->cur_tp &&
-		    minstrel_mcs_groups[group].streams <= prob_max_streams) {
+		    minstrel_mcs_groups[group].streams <= mi->max_prob_streams) {
 			mi->max_prob_rate = mg->max_prob_rate;
 			cur_prob = mr->cur_prob;
 			cur_prob_tp = mr->cur_tp;
@@ -630,6 +629,7 @@ minstrel_get_sample_rate(struct minstrel_priv *mp, struct minstrel_ht_sta *mi)
 {
 	struct minstrel_rate_stats *mr;
 	struct minstrel_mcs_group_data *mg;
+	unsigned int sample_dur, sample_group;
 	int sample_idx = 0;
 
 	if (mi->sample_wait > 0) {
@@ -644,7 +644,8 @@ minstrel_get_sample_rate(struct minstrel_priv *mp, struct minstrel_ht_sta *mi)
 	mg = &mi->groups[mi->sample_group];
 	sample_idx = sample_table[mg->column][mg->index];
 	mr = &mg->rates[sample_idx];
-	sample_idx += mi->sample_group * MCS_GROUP_RATES;
+	sample_group = mi->sample_group;
+	sample_idx += sample_group * MCS_GROUP_RATES;
 	minstrel_next_sample_idx(mi);
 
 	/*
@@ -665,8 +666,11 @@ minstrel_get_sample_rate(struct minstrel_priv *mp, struct minstrel_ht_sta *mi)
 	 * Make sure that lower rates get sampled only occasionally,
 	 * if the link is working perfectly.
 	 */
-	if (minstrel_get_duration(sample_idx) >
-	    minstrel_get_duration(mi->max_tp_rate)) {
+	sample_dur = minstrel_get_duration(sample_idx);
+	if (sample_dur >= minstrel_get_duration(mi->max_tp_rate2) &&
+	    (mi->max_prob_streams <
+	     minstrel_mcs_groups[sample_group].streams ||
+	     sample_dur >= minstrel_get_duration(mi->max_prob_rate))) {
 		if (mr->sample_skipped < 20)
 			return -1;
 
diff --git a/net/mac80211/rc80211_minstrel_ht.h b/net/mac80211/rc80211_minstrel_ht.h
index 302dbd5..c6d6a0d 100644
--- a/net/mac80211/rc80211_minstrel_ht.h
+++ b/net/mac80211/rc80211_minstrel_ht.h
@@ -85,6 +85,7 @@ struct minstrel_ht_sta {
 
 	/* best probability rate */
 	unsigned int max_prob_rate;
+	unsigned int max_prob_streams;
 
 	/* time of last status update */
 	unsigned long stats_update;
-- 
1.8.0.2

