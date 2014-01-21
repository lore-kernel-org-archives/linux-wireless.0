Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.neomailbox.net ([178.209.62.157]:44135 "EHLO
	s3.neomailbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754122AbaAULLI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jan 2014 06:11:08 -0500
From: Antonio Quartulli <antonio@meshcoding.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Antonio Quartulli <antonio@open-mesh.com>
Subject: [RFC 2/5] mac80211: export minstrel best rate information in set_sta_info()
Date: Tue, 21 Jan 2014 12:09:48 +0100
Message-Id: <1390302591-3352-3-git-send-email-antonio@meshcoding.com> (sfid-20140121_121121_799860_6D00BFB8)
In-Reply-To: <1390302591-3352-1-git-send-email-antonio@meshcoding.com>
References: <1390302591-3352-1-git-send-email-antonio@meshcoding.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Antonio Quartulli <antonio@open-mesh.com>

Add the get_minstrel_best_rate() RC API in order to retrieve
the rate having the highest throughput. If the RC algorithm
implements such API, then fill the related field in
station_info when dumping a station.

This API is supposed to be implemented by Minstrel only.

Signed-off-by: Antonio Quartulli <antonio@open-mesh.com>
---
 include/net/mac80211.h | 15 +++++++++++++++
 net/mac80211/cfg.c     | 15 +++++++++++++++
 2 files changed, 30 insertions(+)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index df1004b..9ed56f8 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -4452,6 +4452,17 @@ struct ieee80211_tx_rate_control {
 	bool bss;
 };
 
+/**
+ * struct ieee80211_minstrel_rate_info - rate information extracted from
+ *  the Minstrel RC algorithm
+ * @rate: the reported bitrate
+ * @prob: probability of success of rate computed by Minstrel
+ */
+struct ieee80211_minstrel_rate_info {
+	struct ieee80211_tx_rate rate;
+	u32 prob;
+};
+
 struct rate_control_ops {
 	struct module *module;
 	const char *name;
@@ -4478,6 +4489,10 @@ struct rate_control_ops {
 	void (*add_sta_debugfs)(void *priv, void *priv_sta,
 				struct dentry *dir);
 	void (*remove_sta_debugfs)(void *priv, void *priv_sta);
+
+	void (*get_minstrel_best_rate)
+		(void *priv, void *priv_sta,
+		 struct ieee80211_minstrel_rate_info *info);
 };
 
 static inline int rate_supported(struct ieee80211_sta *sta,
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 032081c..c0d394c 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -463,6 +463,9 @@ static void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 {
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
 	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_minstrel_rate_info info;
+	struct rate_control_ref *ref = local->rate_ctrl;
+	struct rate_info rinfo;
 	struct timespec uptime;
 	u64 packets = 0;
 	int i, ac;
@@ -578,6 +581,18 @@ static void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 		sinfo->sta_flags.set |= BIT(NL80211_STA_FLAG_ASSOCIATED);
 	if (test_sta_flag(sta, WLAN_STA_TDLS_PEER))
 		sinfo->sta_flags.set |= BIT(NL80211_STA_FLAG_TDLS_PEER);
+
+	if (!ref->ops->get_minstrel_best_rate)
+		return;
+
+	sinfo->filled |= STATION_INFO_MINSTREL_BEST_RATE;
+
+	ref->ops->get_minstrel_best_rate(ref->priv, sta->rate_ctrl_priv, &info);
+
+	sta_set_rate_info_tx(sta, &info.rate, &rinfo);
+
+	sinfo->minstrel_best_rate.bitrate = cfg80211_calculate_bitrate(&rinfo);
+	sinfo->minstrel_best_rate.prob = info.prob;
 }
 
 static const char ieee80211_gstrings_sta_stats[][ETH_GSTRING_LEN] = {
-- 
1.8.5.3

