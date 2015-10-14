Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33133 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751533AbbJNQug (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Oct 2015 12:50:36 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: move sta_set_rate_info_rx() and make it static
Date: Wed, 14 Oct 2015 18:50:32 +0200
Message-Id: <1444841432-23366-1-git-send-email-johannes@sipsolutions.net> (sfid-20151014_185039_787806_F20BFF9B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's only a single caller of this function, so it can
be moved to the same file and made static.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c      | 39 ---------------------------------------
 net/mac80211/sta_info.c | 39 +++++++++++++++++++++++++++++++++++++++
 net/mac80211/sta_info.h |  2 --
 3 files changed, 39 insertions(+), 41 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 276b57243298..61c841aeff60 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -469,45 +469,6 @@ void sta_set_rate_info_tx(struct sta_info *sta,
 		rinfo->flags |= RATE_INFO_FLAGS_SHORT_GI;
 }
 
-void sta_set_rate_info_rx(struct sta_info *sta, struct rate_info *rinfo)
-{
-	rinfo->flags = 0;
-
-	if (sta->last_rx_rate_flag & RX_FLAG_HT) {
-		rinfo->flags |= RATE_INFO_FLAGS_MCS;
-		rinfo->mcs = sta->last_rx_rate_idx;
-	} else if (sta->last_rx_rate_flag & RX_FLAG_VHT) {
-		rinfo->flags |= RATE_INFO_FLAGS_VHT_MCS;
-		rinfo->nss = sta->last_rx_rate_vht_nss;
-		rinfo->mcs = sta->last_rx_rate_idx;
-	} else {
-		struct ieee80211_supported_band *sband;
-		int shift = ieee80211_vif_get_shift(&sta->sdata->vif);
-		u16 brate;
-
-		sband = sta->local->hw.wiphy->bands[
-				ieee80211_get_sdata_band(sta->sdata)];
-		brate = sband->bitrates[sta->last_rx_rate_idx].bitrate;
-		rinfo->legacy = DIV_ROUND_UP(brate, 1 << shift);
-	}
-
-	if (sta->last_rx_rate_flag & RX_FLAG_SHORT_GI)
-		rinfo->flags |= RATE_INFO_FLAGS_SHORT_GI;
-
-	if (sta->last_rx_rate_flag & RX_FLAG_5MHZ)
-		rinfo->bw = RATE_INFO_BW_5;
-	else if (sta->last_rx_rate_flag & RX_FLAG_10MHZ)
-		rinfo->bw = RATE_INFO_BW_10;
-	else if (sta->last_rx_rate_flag & RX_FLAG_40MHZ)
-		rinfo->bw = RATE_INFO_BW_40;
-	else if (sta->last_rx_rate_vht_flag & RX_VHT_FLAG_80MHZ)
-		rinfo->bw = RATE_INFO_BW_80;
-	else if (sta->last_rx_rate_vht_flag & RX_VHT_FLAG_160MHZ)
-		rinfo->bw = RATE_INFO_BW_160;
-	else
-		rinfo->bw = RATE_INFO_BW_20;
-}
-
 static int ieee80211_dump_station(struct wiphy *wiphy, struct net_device *dev,
 				  int idx, u8 *mac, struct station_info *sinfo)
 {
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index c3644458e2ee..7f2c4f2acadf 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -1806,6 +1806,45 @@ u8 sta_info_tx_streams(struct sta_info *sta)
 			>> IEEE80211_HT_MCS_TX_MAX_STREAMS_SHIFT) + 1;
 }
 
+static void sta_set_rate_info_rx(struct sta_info *sta, struct rate_info *rinfo)
+{
+	rinfo->flags = 0;
+
+	if (sta->last_rx_rate_flag & RX_FLAG_HT) {
+		rinfo->flags |= RATE_INFO_FLAGS_MCS;
+		rinfo->mcs = sta->last_rx_rate_idx;
+	} else if (sta->last_rx_rate_flag & RX_FLAG_VHT) {
+		rinfo->flags |= RATE_INFO_FLAGS_VHT_MCS;
+		rinfo->nss = sta->last_rx_rate_vht_nss;
+		rinfo->mcs = sta->last_rx_rate_idx;
+	} else {
+		struct ieee80211_supported_band *sband;
+		int shift = ieee80211_vif_get_shift(&sta->sdata->vif);
+		u16 brate;
+
+		sband = sta->local->hw.wiphy->bands[
+				ieee80211_get_sdata_band(sta->sdata)];
+		brate = sband->bitrates[sta->last_rx_rate_idx].bitrate;
+		rinfo->legacy = DIV_ROUND_UP(brate, 1 << shift);
+	}
+
+	if (sta->last_rx_rate_flag & RX_FLAG_SHORT_GI)
+		rinfo->flags |= RATE_INFO_FLAGS_SHORT_GI;
+
+	if (sta->last_rx_rate_flag & RX_FLAG_5MHZ)
+		rinfo->bw = RATE_INFO_BW_5;
+	else if (sta->last_rx_rate_flag & RX_FLAG_10MHZ)
+		rinfo->bw = RATE_INFO_BW_10;
+	else if (sta->last_rx_rate_flag & RX_FLAG_40MHZ)
+		rinfo->bw = RATE_INFO_BW_40;
+	else if (sta->last_rx_rate_vht_flag & RX_VHT_FLAG_80MHZ)
+		rinfo->bw = RATE_INFO_BW_80;
+	else if (sta->last_rx_rate_vht_flag & RX_VHT_FLAG_160MHZ)
+		rinfo->bw = RATE_INFO_BW_160;
+	else
+		rinfo->bw = RATE_INFO_BW_20;
+}
+
 void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 {
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index d5ded8749ac4..ce4271406692 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -688,8 +688,6 @@ static inline int sta_info_flush(struct ieee80211_sub_if_data *sdata)
 void sta_set_rate_info_tx(struct sta_info *sta,
 			  const struct ieee80211_tx_rate *rate,
 			  struct rate_info *rinfo);
-void sta_set_rate_info_rx(struct sta_info *sta,
-			  struct rate_info *rinfo);
 void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo);
 
 void ieee80211_sta_expire(struct ieee80211_sub_if_data *sdata,
-- 
2.5.1

