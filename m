Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f48.google.com ([74.125.83.48]:39781 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754953Ab3DRLzp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Apr 2013 07:55:45 -0400
Received: by mail-ee0-f48.google.com with SMTP id b15so1263459eek.21
        for <linux-wireless@vger.kernel.org>; Thu, 18 Apr 2013 04:55:44 -0700 (PDT)
From: Karl Beldan <karl.beldan@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@gmail.com>,
	Karl Beldan <karl.beldan@rivierawaves.com>,
	Felix Fietkau <nbd@openwrt.org>
Subject: [PATCH 1/2] mac80211: minstrel_ht: pick only supported rates for sta and group max*rates
Date: Thu, 18 Apr 2013 13:51:26 +0200
Message-Id: <1366285887-23416-1-git-send-email-karl.beldan@gmail.com> (sfid-20130418_135549_997406_1DBB4D08)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Karl Beldan <karl.beldan@rivierawaves.com>

minstrel_ht initializes max_tp_rate max_tp_rate2 and max_prob_rate to
zero both for minstrel_ht_sta and minstrel_mcs_group_data.
This is wrong since there is no guarantee that the 1st rate of any
group is supported.

Signed-off-by: Karl Beldan <karl.beldan@rivierawaves.com>
---
 net/mac80211/rc80211_minstrel_ht.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index d2b264d..eb6dc3f 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -244,6 +244,7 @@ minstrel_ht_update_stats(struct minstrel_priv *mp, struct minstrel_ht_sta *mi)
 	struct minstrel_rate_stats *mr;
 	int cur_prob, cur_prob_tp, cur_tp, cur_tp2;
 	int group, i, index;
+	bool mi_rates_valid = false;
 
 	if (mi->ampdu_packets > 0) {
 		mi->avg_ampdu_len = minstrel_ewma(mi->avg_ampdu_len,
@@ -254,11 +255,10 @@ minstrel_ht_update_stats(struct minstrel_priv *mp, struct minstrel_ht_sta *mi)
 
 	mi->sample_slow = 0;
 	mi->sample_count = 0;
-	mi->max_tp_rate = 0;
-	mi->max_tp_rate2 = 0;
-	mi->max_prob_rate = 0;
 
 	for (group = 0; group < ARRAY_SIZE(minstrel_mcs_groups); group++) {
+		bool mg_rates_valid = false;
+
 		cur_prob = 0;
 		cur_prob_tp = 0;
 		cur_tp = 0;
@@ -268,15 +268,24 @@ minstrel_ht_update_stats(struct minstrel_priv *mp, struct minstrel_ht_sta *mi)
 		if (!mg->supported)
 			continue;
 
-		mg->max_tp_rate = 0;
-		mg->max_tp_rate2 = 0;
-		mg->max_prob_rate = 0;
 		mi->sample_count++;
 
 		for (i = 0; i < MCS_GROUP_RATES; i++) {
 			if (!(mg->supported & BIT(i)))
 				continue;
 
+			// initialize {mg,mi}->max_rates indexes
+			if (!mg_rates_valid) {
+				mg->max_tp_rate = mg->max_tp_rate2 =
+					mg->max_prob_rate = i;
+				if (!mi_rates_valid) {
+					mi->max_tp_rate = mi->max_tp_rate2 =
+						mi->max_prob_rate = i;
+					mi_rates_valid = true;
+				}
+				mg_rates_valid = true;
+			}
+
 			mr = &mg->rates[i];
 			mr->retry_updated = false;
 			index = MCS_GROUP_RATES * group + i;
-- 
1.8.2

