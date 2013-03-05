Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from icf.org.ru ([91.193.237.1]:45292 "EHLO icf.org.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751824Ab3CEKfG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Mar 2013 05:35:06 -0500
Date: Tue, 5 Mar 2013 14:35:00 +0400 (MSK)
From: Georgiewskiy Yuriy <bottleman@icf.org.ru>
To: Felix Fietkau <nbd@openwrt.org>
cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Subject: Re: [PATCH 1/2] mac80211/minstrel_ht: increase sampling frequency
 of some slower rates
In-Reply-To: <1362311392-83648-1-git-send-email-nbd@openwrt.org>
Message-ID: <alpine.DEB.2.02.1303051432550.23906@icf.org.ru> (sfid-20130305_113529_376817_02E8C7EB)
References: <1362311392-83648-1-git-send-email-nbd@openwrt.org>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1051000339-334958693-1362479700=:23906"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1051000339-334958693-1362479700=:23906
Content-Type: TEXT/PLAIN; charset=KOI8-R
Content-Transfer-Encoding: 8BIT

On 2013-03-03 12:49 +0100, Felix Fietkau wrote linux-wireless@vger.kernel.org:

Hi, in my case this two patches cause throughput drop, withous it i have 50-55Mbs
with it applied only 35-40.

FF>If a rate is below the max_tp_rate, sample it frequently if:
FF>- it is above max_tp_rate2, or
FF>- it is above max_prob_rate and is a candidate for max_prob_rate
FF>  (has fewer streams than max_tp_rate).
FF>This helps the retry chain recover more quickly from bad statistics
FF>caused by collisions or interference, and slightly reduces throughput
FF>fluctuations with higher rates.
FF>
FF>Signed-off-by: Felix Fietkau <nbd@openwrt.org>
FF>---
FF> net/mac80211/rc80211_minstrel_ht.c | 20 ++++++++++++--------
FF> net/mac80211/rc80211_minstrel_ht.h |  1 +
FF> 2 files changed, 13 insertions(+), 8 deletions(-)
FF>
FF>diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
FF>index 4d35bc5..1b69924 100644
FF>--- a/net/mac80211/rc80211_minstrel_ht.c
FF>+++ b/net/mac80211/rc80211_minstrel_ht.c
FF>@@ -246,7 +246,6 @@ minstrel_ht_update_stats(struct minstrel_priv *mp, struct minstrel_ht_sta *mi)
FF> 	struct minstrel_rate_stats *mr;
FF> 	int cur_prob, cur_prob_tp, cur_tp, cur_tp2;
FF> 	int group, i, index;
FF>-	int prob_max_streams = 1;
FF> 
FF> 	if (mi->ampdu_packets > 0) {
FF> 		mi->avg_ampdu_len = minstrel_ewma(mi->avg_ampdu_len,
FF>@@ -330,7 +329,7 @@ minstrel_ht_update_stats(struct minstrel_priv *mp, struct minstrel_ht_sta *mi)
FF> 			cur_tp2 = cur_tp;
FF> 			mi->max_tp_rate = mg->max_tp_rate;
FF> 			cur_tp = mr->cur_tp;
FF>-			prob_max_streams = minstrel_mcs_groups[group].streams - 1;
FF>+			mi->max_prob_streams = minstrel_mcs_groups[group].streams - 1;
FF> 		}
FF> 
FF> 		mr = minstrel_get_ratestats(mi, mg->max_tp_rate2);
FF>@@ -340,8 +339,8 @@ minstrel_ht_update_stats(struct minstrel_priv *mp, struct minstrel_ht_sta *mi)
FF> 		}
FF> 	}
FF> 
FF>-	if (prob_max_streams < 1)
FF>-		prob_max_streams = 1;
FF>+	if (mi->max_prob_streams < 1)
FF>+		mi->max_prob_streams = 1;
FF> 
FF> 	for (group = 0; group < ARRAY_SIZE(minstrel_mcs_groups); group++) {
FF> 		mg = &mi->groups[group];
FF>@@ -349,7 +348,7 @@ minstrel_ht_update_stats(struct minstrel_priv *mp, struct minstrel_ht_sta *mi)
FF> 			continue;
FF> 		mr = minstrel_get_ratestats(mi, mg->max_prob_rate);
FF> 		if (cur_prob_tp < mr->cur_tp &&
FF>-		    minstrel_mcs_groups[group].streams <= prob_max_streams) {
FF>+		    minstrel_mcs_groups[group].streams <= mi->max_prob_streams) {
FF> 			mi->max_prob_rate = mg->max_prob_rate;
FF> 			cur_prob = mr->cur_prob;
FF> 			cur_prob_tp = mr->cur_tp;
FF>@@ -630,6 +629,7 @@ minstrel_get_sample_rate(struct minstrel_priv *mp, struct minstrel_ht_sta *mi)
FF> {
FF> 	struct minstrel_rate_stats *mr;
FF> 	struct minstrel_mcs_group_data *mg;
FF>+	unsigned int sample_dur, sample_group;
FF> 	int sample_idx = 0;
FF> 
FF> 	if (mi->sample_wait > 0) {
FF>@@ -644,7 +644,8 @@ minstrel_get_sample_rate(struct minstrel_priv *mp, struct minstrel_ht_sta *mi)
FF> 	mg = &mi->groups[mi->sample_group];
FF> 	sample_idx = sample_table[mg->column][mg->index];
FF> 	mr = &mg->rates[sample_idx];
FF>-	sample_idx += mi->sample_group * MCS_GROUP_RATES;
FF>+	sample_group = mi->sample_group;
FF>+	sample_idx += sample_group * MCS_GROUP_RATES;
FF> 	minstrel_next_sample_idx(mi);
FF> 
FF> 	/*
FF>@@ -665,8 +666,11 @@ minstrel_get_sample_rate(struct minstrel_priv *mp, struct minstrel_ht_sta *mi)
FF> 	 * Make sure that lower rates get sampled only occasionally,
FF> 	 * if the link is working perfectly.
FF> 	 */
FF>-	if (minstrel_get_duration(sample_idx) >
FF>-	    minstrel_get_duration(mi->max_tp_rate)) {
FF>+	sample_dur = minstrel_get_duration(sample_idx);
FF>+	if (sample_dur >= minstrel_get_duration(mi->max_tp_rate2) &&
FF>+	    (mi->max_prob_streams <
FF>+	     minstrel_mcs_groups[sample_group].streams ||
FF>+	     sample_dur >= minstrel_get_duration(mi->max_prob_rate))) {
FF> 		if (mr->sample_skipped < 20)
FF> 			return -1;
FF> 
FF>diff --git a/net/mac80211/rc80211_minstrel_ht.h b/net/mac80211/rc80211_minstrel_ht.h
FF>index 302dbd5..c6d6a0d 100644
FF>--- a/net/mac80211/rc80211_minstrel_ht.h
FF>+++ b/net/mac80211/rc80211_minstrel_ht.h
FF>@@ -85,6 +85,7 @@ struct minstrel_ht_sta {
FF> 
FF> 	/* best probability rate */
FF> 	unsigned int max_prob_rate;
FF>+	unsigned int max_prob_streams;
FF> 
FF> 	/* time of last status update */
FF> 	unsigned long stats_update;
FF>

C уважением                       With Best Regards
Георгиевский Юрий.                Georgiewskiy Yuriy
+7 4872 711666                    +7 4872 711666
факс +7 4872 711143               fax +7 4872 711143
Компания ООО "Ай Ти Сервис"       IT Service Ltd
http://nkoort.ru                  http://nkoort.ru
JID: GHhost@icf.org.ru            JID: GHhost@icf.org.ru
YG129-RIPE                        YG129-RIPE
---1051000339-334958693-1362479700=:23906--
