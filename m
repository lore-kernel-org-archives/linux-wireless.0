Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:59399 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752277Ab3CBUUT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Mar 2013 15:20:19 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH 2/3] mac80211/minstrel_ht: improve max_prob_rate selection
Date: Sat,  2 Mar 2013 21:20:13 +0100
Message-Id: <1362255614-30859-2-git-send-email-nbd@openwrt.org> (sfid-20130302_212024_786403_D1C88073)
In-Reply-To: <1362255614-30859-1-git-send-email-nbd@openwrt.org>
References: <1362255614-30859-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

max_prob_rate should be selected to be very reliable, however limiting
it to single-stream on 3-stream devices is a bit much.
Allow max_prob_rate to use one stream less than the max_tp_rate.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 net/mac80211/rc80211_minstrel_ht.c | 27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index 0b5cdd9..6c735e0 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -246,6 +246,7 @@ minstrel_ht_update_stats(struct minstrel_priv *mp, struct minstrel_ht_sta *mi)
 	struct minstrel_rate_stats *mr;
 	int cur_prob, cur_prob_tp, cur_tp, cur_tp2;
 	int group, i, index;
+	int prob_max_streams = 1;
 
 	if (mi->ampdu_packets > 0) {
 		mi->avg_ampdu_len = minstrel_ewma(mi->avg_ampdu_len,
@@ -323,20 +324,13 @@ minstrel_ht_update_stats(struct minstrel_priv *mp, struct minstrel_ht_sta *mi)
 		if (!mg->supported)
 			continue;
 
-		mr = minstrel_get_ratestats(mi, mg->max_prob_rate);
-		if (cur_prob_tp < mr->cur_tp &&
-		    minstrel_mcs_groups[group].streams == 1) {
-			mi->max_prob_rate = mg->max_prob_rate;
-			cur_prob = mr->cur_prob;
-			cur_prob_tp = mr->cur_tp;
-		}
-
 		mr = minstrel_get_ratestats(mi, mg->max_tp_rate);
 		if (cur_tp < mr->cur_tp) {
 			mi->max_tp_rate2 = mi->max_tp_rate;
 			cur_tp2 = cur_tp;
 			mi->max_tp_rate = mg->max_tp_rate;
 			cur_tp = mr->cur_tp;
+			prob_max_streams = minstrel_mcs_groups[group].streams - 1;
 		}
 
 		mr = minstrel_get_ratestats(mi, mg->max_tp_rate2);
@@ -346,6 +340,23 @@ minstrel_ht_update_stats(struct minstrel_priv *mp, struct minstrel_ht_sta *mi)
 		}
 	}
 
+	if (prob_max_streams < 1)
+		prob_max_streams = 1;
+
+	for (group = 0; group < ARRAY_SIZE(minstrel_mcs_groups); group++) {
+		mg = &mi->groups[group];
+		if (!mg->supported)
+			continue;
+		mr = minstrel_get_ratestats(mi, mg->max_prob_rate);
+		if (cur_prob_tp < mr->cur_tp &&
+		    minstrel_mcs_groups[group].streams <= prob_max_streams) {
+			mi->max_prob_rate = mg->max_prob_rate;
+			cur_prob = mr->cur_prob;
+			cur_prob_tp = mr->cur_tp;
+		}
+	}
+
+
 	mi->stats_update = jiffies;
 }
 
-- 
1.8.0.2

