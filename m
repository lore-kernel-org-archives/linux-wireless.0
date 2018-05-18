Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:39380 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752291AbeERJrr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 May 2018 05:47:47 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 1/2] mac80211: allocate and fill tidstats only when needed
Date: Fri, 18 May 2018 11:47:41 +0200
Message-Id: <20180518094742.10669-1-johannes@sipsolutions.net> (sfid-20180518_114804_604981_D379B065)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This fixes memory leaks in the case where we just have the
station info on the stack for internal usage without sending
it to cfg80211.

Fixes: 8689c051a201 ("cfg80211: dynamically allocate per-tid stats for station info")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c      | 4 ++--
 net/mac80211/ethtool.c  | 4 ++--
 net/mac80211/sta_info.c | 7 ++++---
 net/mac80211/sta_info.h | 3 ++-
 4 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 5ce9d121af2b..bdf6fa78d0d2 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -695,7 +695,7 @@ static int ieee80211_dump_station(struct wiphy *wiphy, struct net_device *dev,
 	if (sta) {
 		ret = 0;
 		memcpy(mac, sta->sta.addr, ETH_ALEN);
-		sta_set_sinfo(sta, sinfo);
+		sta_set_sinfo(sta, sinfo, true);
 	}
 
 	mutex_unlock(&local->sta_mtx);
@@ -724,7 +724,7 @@ static int ieee80211_get_station(struct wiphy *wiphy, struct net_device *dev,
 	sta = sta_info_get_bss(sdata, mac);
 	if (sta) {
 		ret = 0;
-		sta_set_sinfo(sta, sinfo);
+		sta_set_sinfo(sta, sinfo, true);
 	}
 
 	mutex_unlock(&local->sta_mtx);
diff --git a/net/mac80211/ethtool.c b/net/mac80211/ethtool.c
index 2ba5686cbcab..690c142a7a44 100644
--- a/net/mac80211/ethtool.c
+++ b/net/mac80211/ethtool.c
@@ -108,7 +108,7 @@ static void ieee80211_get_stats(struct net_device *dev,
 			goto do_survey;
 
 		memset(&sinfo, 0, sizeof(sinfo));
-		sta_set_sinfo(sta, &sinfo);
+		sta_set_sinfo(sta, &sinfo, false);
 
 		i = 0;
 		ADD_STA_STATS(sta);
@@ -135,7 +135,7 @@ static void ieee80211_get_stats(struct net_device *dev,
 				continue;
 
 			memset(&sinfo, 0, sizeof(sinfo));
-			sta_set_sinfo(sta, &sinfo);
+			sta_set_sinfo(sta, &sinfo, false);
 			i = 0;
 			ADD_STA_STATS(sta);
 		}
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 04d47689b557..6428f1ac37b6 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -1008,7 +1008,7 @@ static void __sta_info_destroy_part2(struct sta_info *sta)
 
 	sinfo = kzalloc(sizeof(*sinfo), GFP_KERNEL);
 	if (sinfo)
-		sta_set_sinfo(sta, sinfo);
+		sta_set_sinfo(sta, sinfo, true);
 	cfg80211_del_sta_sinfo(sdata->dev, sta->sta.addr, sinfo, GFP_KERNEL);
 	kfree(sinfo);
 
@@ -2079,7 +2079,8 @@ static inline u64 sta_get_stats_bytes(struct ieee80211_sta_rx_stats *rxstats)
 	return value;
 }
 
-void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
+void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo,
+		   bool tidstats)
 {
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
 	struct ieee80211_local *local = sdata->local;
@@ -2233,7 +2234,7 @@ void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 			sinfo->filled |= BIT(NL80211_STA_INFO_RX_BITRATE);
 	}
 
-	if (!cfg80211_sinfo_alloc_tid_stats(sinfo, GFP_KERNEL)) {
+	if (tidstats && !cfg80211_sinfo_alloc_tid_stats(sinfo, GFP_KERNEL)) {
 		for (i = 0; i < IEEE80211_NUM_TIDS + 1; i++) {
 			struct cfg80211_tid_stats *tidstats = &sinfo->pertid[i];
 
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index d79bd6eeb549..81b35f623792 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -744,7 +744,8 @@ static inline int sta_info_flush(struct ieee80211_sub_if_data *sdata)
 void sta_set_rate_info_tx(struct sta_info *sta,
 			  const struct ieee80211_tx_rate *rate,
 			  struct rate_info *rinfo);
-void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo);
+void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo,
+		   bool tidstats);
 
 u32 sta_get_expected_throughput(struct sta_info *sta);
 
-- 
2.14.3
