Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.neomailbox.net ([178.209.62.157]:24716 "EHLO
	s3.neomailbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754099AbaAULLK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jan 2014 06:11:10 -0500
From: Antonio Quartulli <antonio@meshcoding.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Antonio Quartulli <antonio@open-mesh.com>
Subject: [RFC 4/5] mac80211: minstrel_ht - implement get_minstrel_best_rate() API
Date: Tue, 21 Jan 2014 12:09:50 +0100
Message-Id: <1390302591-3352-5-git-send-email-antonio@meshcoding.com> (sfid-20140121_121115_860278_B21B674A)
In-Reply-To: <1390302591-3352-1-git-send-email-antonio@meshcoding.com>
References: <1390302591-3352-1-git-send-email-antonio@meshcoding.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Antonio Quartulli <antonio@open-mesh.com>

Signed-off-by: Antonio Quartulli <antonio@open-mesh.com>
---
 net/mac80211/rc80211_minstrel_ht.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index c1b5b73..f7b1de2 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -1031,6 +1031,35 @@ minstrel_ht_free(void *priv)
 	mac80211_minstrel.free(priv);
 }
 
+static void
+minstrel_ht_get_minstrel_best_rate(void *priv, void *priv_sta,
+				   struct ieee80211_minstrel_rate_info *info)
+{
+	struct minstrel_ht_sta_priv *msp = priv_sta;
+	struct minstrel_ht_sta *mi = &msp->ht;
+	struct ieee80211_sta_rates ratetbl;
+	struct minstrel_priv *mp = priv;
+	struct minstrel_rate_stats *mr;
+	int i, j;
+
+	if (!msp->is_ht) {
+		mac80211_minstrel.get_minstrel_best_rate(priv, priv_sta, info);
+		return;
+	}
+
+	i = mi->max_tp_rate / MCS_GROUP_RATES;
+	j = mi->max_tp_rate % MCS_GROUP_RATES;
+
+	mr = &mi->groups[i].rates[j];
+
+	minstrel_ht_set_rate(mp, mi, &ratetbl, 0, mi->max_tp_rate);
+
+	info->rate.idx = ratetbl.rate[0].idx;
+	info->rate.count = ratetbl.rate[0].count;
+	info->rate.flags = ratetbl.rate[0].flags;
+	info->prob = MINSTREL_TRUNC(mr->probability * 1000);
+}
+
 static struct rate_control_ops mac80211_minstrel_ht = {
 	.name = "minstrel_ht",
 	.tx_status = minstrel_ht_tx_status,
@@ -1045,6 +1074,7 @@ static struct rate_control_ops mac80211_minstrel_ht = {
 	.add_sta_debugfs = minstrel_ht_add_sta_debugfs,
 	.remove_sta_debugfs = minstrel_ht_remove_sta_debugfs,
 #endif
+	.get_minstrel_best_rate = minstrel_ht_get_minstrel_best_rate,
 };
 
 
-- 
1.8.5.3

