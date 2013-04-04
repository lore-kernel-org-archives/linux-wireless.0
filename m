Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ht2.myhostedexchange.com ([69.50.2.38]:20908 "EHLO
	ht1.hostedexchange.local" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1763426Ab3DDUDt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Apr 2013 16:03:49 -0400
From: Antonio Quartulli <antonio@open-mesh.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	Antonio Quartulli <antonio@open-mesh.com>
Subject: [PATCH 2/3] mac80211: add rate_control_ops::get_max_tp() and implement it
Date: Thu, 4 Apr 2013 21:57:21 +0200
Message-ID: <1365105442-31876-2-git-send-email-antonio@open-mesh.com> (sfid-20130404_220352_639950_DB9A3C91)
In-Reply-To: <1365105442-31876-1-git-send-email-antonio@open-mesh.com>
References: <1365105442-31876-1-git-send-email-antonio@open-mesh.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This new API is aimed to return the maximum throughput
estimated by a rate control algorithm towards a given peer.

The API is implemented for minstrel and minstrel_ht.

Signed-off-by: Antonio Quartulli <antonio@open-mesh.com>
---
 include/net/mac80211.h             |  2 ++
 net/mac80211/rc80211_minstrel.c    |  9 +++++++++
 net/mac80211/rc80211_minstrel_ht.c | 21 +++++++++++++++++++++
 3 files changed, 32 insertions(+)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 64faf01..5a1b7c2 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -4147,6 +4147,8 @@ struct rate_control_ops {
 	void (*add_sta_debugfs)(void *priv, void *priv_sta,
 				struct dentry *dir);
 	void (*remove_sta_debugfs)(void *priv, void *priv_sta);
+
+	void (*get_max_tp)(void *priv_sta, u32 *tp);
 };
 
 static inline int rate_supported(struct ieee80211_sta *sta,
diff --git a/net/mac80211/rc80211_minstrel.c b/net/mac80211/rc80211_minstrel.c
index 1c36c9b..7af6884 100644
--- a/net/mac80211/rc80211_minstrel.c
+++ b/net/mac80211/rc80211_minstrel.c
@@ -604,6 +604,14 @@ minstrel_free(void *priv)
 	kfree(priv);
 }
 
+static void minstrel_get_max_tp(void *priv_sta, u32 *tp)
+{
+	struct minstrel_sta_info *mi = priv_sta;
+	int idx = mi->max_tp_rate[0];
+
+	*tp = MINSTREL_TRUNC(mi->r[idx].cur_tp / 10);
+}
+
 struct rate_control_ops mac80211_minstrel = {
 	.name = "minstrel",
 	.tx_status = minstrel_tx_status,
@@ -617,6 +625,7 @@ struct rate_control_ops mac80211_minstrel = {
 	.add_sta_debugfs = minstrel_add_sta_debugfs,
 	.remove_sta_debugfs = minstrel_remove_sta_debugfs,
 #endif
+	.get_max_tp = minstrel_get_max_tp,
 };
 
 int __init
diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index d2b264d..421c770 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -960,6 +960,26 @@ error:
 	return NULL;
 }
 
+static void minstrel_ht_get_max_tp(void *priv_sta, u32 *tp)
+{
+	struct minstrel_ht_sta_priv *msp = priv_sta;
+	struct minstrel_ht_sta *mi = &msp->ht;
+	struct minstrel_rate_stats *mr;
+	int i, j;
+
+	if (!msp->is_ht) {
+		mac80211_minstrel.get_max_tp(priv_sta, tp);
+		return;
+	}
+
+	i = mi->max_tp_rate / MCS_GROUP_RATES;
+	j = mi->max_tp_rate % MCS_GROUP_RATES;
+
+	mr = &mi->groups[i].rates[j];
+
+	*tp = mr->cur_tp / 10;
+}
+
 static void
 minstrel_ht_free_sta(void *priv, struct ieee80211_sta *sta, void *priv_sta)
 {
@@ -996,6 +1016,7 @@ static struct rate_control_ops mac80211_minstrel_ht = {
 	.add_sta_debugfs = minstrel_ht_add_sta_debugfs,
 	.remove_sta_debugfs = minstrel_ht_remove_sta_debugfs,
 #endif
+	.get_max_tp = minstrel_ht_get_max_tp,
 };
 
 
-- 
1.8.1.5

