Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.neomailbox.net ([178.209.62.157]:35342 "EHLO
	s3.neomailbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754508AbaDNOEF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Apr 2014 10:04:05 -0400
From: Antonio Quartulli <antonio@meshcoding.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: b.a.t.m.a.n@lists.open-mesh.org, linux-wireless@vger.kernel.org,
	devel@lists.open80211s.org,
	Antonio Quartulli <antonio@open-mesh.com>
Subject: [PATCH 4/7] mac80211: export expected throughput in set_sta_info()
Date: Mon, 14 Apr 2014 16:03:22 +0200
Message-Id: <1397484205-20905-4-git-send-email-antonio@meshcoding.com> (sfid-20140414_160426_602739_59B04594)
In-Reply-To: <1397484205-20905-1-git-send-email-antonio@meshcoding.com>
References: <1397484205-20905-1-git-send-email-antonio@meshcoding.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Antonio Quartulli <antonio@open-mesh.com>

If either the driver or the SW RC algorithm implements the
get_expected_throughput() API fill the related member in the
station_info object when dumping a station.

Signed-off-by: Antonio Quartulli <antonio@open-mesh.com>
---
 net/mac80211/cfg.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index aa39381..31d1955 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -472,8 +472,12 @@ static void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 {
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
 	struct ieee80211_local *local = sdata->local;
+	struct rate_control_ref *ref = local->rate_ctrl;
+	struct ieee80211_supported_band *sband;
+	enum ieee80211_band band;
 	struct timespec uptime;
 	u64 packets = 0;
+	u32 thr = 0;
 	int i, ac;
 
 	sinfo->generation = sdata->local->sta_generation;
@@ -587,6 +591,23 @@ static void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 		sinfo->sta_flags.set |= BIT(NL80211_STA_FLAG_ASSOCIATED);
 	if (test_sta_flag(sta, WLAN_STA_TDLS_PEER))
 		sinfo->sta_flags.set |= BIT(NL80211_STA_FLAG_TDLS_PEER);
+
+	/* check if the driver has a SW RC implementation */
+	if (ref && ref->ops->get_expected_throughput) {
+		band = ieee80211_get_sdata_band(sta->sdata);
+		sband = sta->local->hw.wiphy->bands[band];
+
+		thr = ref->ops->get_expected_throughput(ref->priv,
+							sta->rate_ctrl_priv,
+							sband);
+	} else {
+		thr = drv_get_expected_throughput(local, &sta->sta);
+	}
+
+	if (thr != 0) {
+		sinfo->filled |= STATION_INFO_EXPECTED_THROUGHPUT;
+		sinfo->expected_throughput = thr;
+	}
 }
 
 static const char ieee80211_gstrings_sta_stats[][ETH_GSTRING_LEN] = {
-- 
1.8.3.2

