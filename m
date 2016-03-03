Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:38562 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758479AbcCCWZp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Mar 2016 17:25:45 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH] mac80211: minstrel_ht: improve sample rate skip logic
Date: Thu,  3 Mar 2016 23:25:42 +0100
Message-Id: <1457043942-88115-1-git-send-email-nbd@openwrt.org> (sfid-20160303_232554_781623_7CA22405)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There were a few issues that were slowing down the process of finding
the optimal rate, especially on devices with multi-rate retry
limitations:

When max_tp_rate[0] was slower than max_tp_rate[1], the code did not
sample max_tp_rate[1], which would often allow it to switch places with
max_tp_rate[0] (e.g. if only the first sampling attempts were bad, but the
rate is otherwise good).

Also, sample attempts of rates between max_tp_rate[0] and [1] were being
ignored in this case, because the code only checked if the rate was
slower than [1].

Fix this by checking against the fastest / second fastest max_tp_rate
instead of assuming a specific order between the two.

In my tests this patch significantly reduces the time until minstrel_ht
finds the optimal rate right after assoc

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 net/mac80211/rc80211_minstrel_ht.c | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index 3928dbd..9197191 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -923,6 +923,7 @@ minstrel_get_sample_rate(struct minstrel_priv *mp, struct minstrel_ht_sta *mi)
 	struct minstrel_rate_stats *mrs;
 	struct minstrel_mcs_group_data *mg;
 	unsigned int sample_dur, sample_group, cur_max_tp_streams;
+	int tp_rate1, tp_rate2;
 	int sample_idx = 0;
 
 	if (mi->sample_wait > 0) {
@@ -944,14 +945,22 @@ minstrel_get_sample_rate(struct minstrel_priv *mp, struct minstrel_ht_sta *mi)
 	mrs = &mg->rates[sample_idx];
 	sample_idx += sample_group * MCS_GROUP_RATES;
 
+	/* Set tp_rate1, tp_rate2 to the highest / second highest max_tp_rate */
+	if (minstrel_get_duration(mi->max_tp_rate[0]) >
+	    minstrel_get_duration(mi->max_tp_rate[1])) {
+		tp_rate1 = mi->max_tp_rate[1];
+		tp_rate2 = mi->max_tp_rate[0];
+	} else {
+		tp_rate1 = mi->max_tp_rate[0];
+		tp_rate2 = mi->max_tp_rate[1];
+	}
+
 	/*
 	 * Sampling might add some overhead (RTS, no aggregation)
-	 * to the frame. Hence, don't use sampling for the currently
-	 * used rates.
+	 * to the frame. Hence, don't use sampling for the highest currently
+	 * used highest throughput or probability rate.
 	 */
-	if (sample_idx == mi->max_tp_rate[0] ||
-	    sample_idx == mi->max_tp_rate[1] ||
-	    sample_idx == mi->max_prob_rate)
+	if (sample_idx == mi->max_tp_rate[0] || sample_idx == mi->max_prob_rate)
 		return -1;
 
 	/*
@@ -966,10 +975,10 @@ minstrel_get_sample_rate(struct minstrel_priv *mp, struct minstrel_ht_sta *mi)
 	 * if the link is working perfectly.
 	 */
 
-	cur_max_tp_streams = minstrel_mcs_groups[mi->max_tp_rate[0] /
+	cur_max_tp_streams = minstrel_mcs_groups[tp_rate1 /
 		MCS_GROUP_RATES].streams;
 	sample_dur = minstrel_get_duration(sample_idx);
-	if (sample_dur >= minstrel_get_duration(mi->max_tp_rate[1]) &&
+	if (sample_dur >= minstrel_get_duration(tp_rate2) &&
 	    (cur_max_tp_streams - 1 <
 	     minstrel_mcs_groups[sample_group].streams ||
 	     sample_dur >= minstrel_get_duration(mi->max_prob_rate))) {
-- 
2.2.2

