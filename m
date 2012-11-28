Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail022-1.exch022.serverdata.net ([64.78.22.98]:36295 "EHLO
	mail022-1.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754963Ab2K1M7n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2012 07:59:43 -0500
Message-ID: <50B60ABA.2070005@posedge.com> (sfid-20121128_135946_829870_2910D6F4)
Date: Wed, 28 Nov 2012 18:29:38 +0530
From: Saravana <saravanad@posedge.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: re-organize the rx rate calculation logic
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

currently the logic to calculate the rx rate is accessible 
only in the cfg.c.The rx rate calculation might be needed
by other files(modules) of mac80211(possibly debugfs).
So grouping the rx rate calculation logic to a separate
function which can be accessed from other files. This change 
will make the rx rate calculation implementation similar to tx rate.

Signed-off-by: Saravana <saravanad@posedge.com>
---
 net/mac80211/cfg.c      |   60 ++++++++++++++++++++++++++--------------------
 net/mac80211/sta_info.h |    2 +
 2 files changed, 36 insertions(+), 26 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 5d30e5f..3459443 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -398,6 +398,39 @@ void sta_set_rate_info_tx(struct sta_info *sta,
 		rinfo->flags |= RATE_INFO_FLAGS_SHORT_GI;
 }
 
+void sta_set_rate_info_rx(struct sta_info *sta,
+			struct rate_info *rinfo)
+{
+	rinfo->flags = 0;
+	if (sta->last_rx_rate_flag & RX_FLAG_HT) {
+		rinfo->flags |= RATE_INFO_FLAGS_MCS;
+		rinfo->mcs = sta->last_rx_rate_idx;
+	} else if (sta->last_rx_rate_flag & RX_FLAG_VHT) {
+		rinfo->flags |= RATE_INFO_FLAGS_VHT_MCS;
+		rinfo->nss = sta->last_rx_rate_vht_nss;
+		rinfo->mcs = sta->last_rx_rate_idx;
+	} else {
+		struct ieee80211_supported_band *sband;
+
+		sband = sta->local->hw.wiphy->bands[
+				ieee80211_get_sdata_band(sta->sdata)];
+		rinfo->legacy =
+			sband->bitrates[sta->last_rx_rate_idx].bitrate;
+	}
+
+	if (sta->last_rx_rate_flag & RX_FLAG_40MHZ)
+		rinfo->flags |= RATE_INFO_FLAGS_40_MHZ_WIDTH;
+	if (sta->last_rx_rate_flag & RX_FLAG_SHORT_GI)
+		rinfo->flags |= RATE_INFO_FLAGS_SHORT_GI;
+	if (sta->last_rx_rate_flag & RX_FLAG_80MHZ)
+		rinfo->flags |= RATE_INFO_FLAGS_80_MHZ_WIDTH;
+	if (sta->last_rx_rate_flag & RX_FLAG_80P80MHZ)
+		rinfo->flags |= RATE_INFO_FLAGS_80P80_MHZ_WIDTH;
+	if (sta->last_rx_rate_flag & RX_FLAG_160MHZ)
+		rinfo->flags |= RATE_INFO_FLAGS_160_MHZ_WIDTH;
+
+}
+
 static void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 {
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
@@ -445,33 +478,8 @@ static void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 
 	sta_set_rate_info_tx(sta, &sta->last_tx_rate, &sinfo->txrate);
 
-	sinfo->rxrate.flags = 0;
-	if (sta->last_rx_rate_flag & RX_FLAG_HT) {
-		sinfo->rxrate.flags |= RATE_INFO_FLAGS_MCS;
-		sinfo->rxrate.mcs = sta->last_rx_rate_idx;
-	} else if (sta->last_rx_rate_flag & RX_FLAG_VHT) {
-		sinfo->rxrate.flags |= RATE_INFO_FLAGS_VHT_MCS;
-		sinfo->rxrate.nss = sta->last_rx_rate_vht_nss;
-		sinfo->rxrate.mcs = sta->last_rx_rate_idx;
-	} else {
-		struct ieee80211_supported_band *sband;
-
-		sband = sta->local->hw.wiphy->bands[
-				ieee80211_get_sdata_band(sta->sdata)];
-		sinfo->rxrate.legacy =
-			sband->bitrates[sta->last_rx_rate_idx].bitrate;
-	}
+	sta_set_rate_info_rx(sta, &sinfo->rxrate);
 
-	if (sta->last_rx_rate_flag & RX_FLAG_40MHZ)
-		sinfo->rxrate.flags |= RATE_INFO_FLAGS_40_MHZ_WIDTH;
-	if (sta->last_rx_rate_flag & RX_FLAG_SHORT_GI)
-		sinfo->rxrate.flags |= RATE_INFO_FLAGS_SHORT_GI;
-	if (sta->last_rx_rate_flag & RX_FLAG_80MHZ)
-		sinfo->rxrate.flags |= RATE_INFO_FLAGS_80_MHZ_WIDTH;
-	if (sta->last_rx_rate_flag & RX_FLAG_80P80MHZ)
-		sinfo->rxrate.flags |= RATE_INFO_FLAGS_80P80_MHZ_WIDTH;
-	if (sta->last_rx_rate_flag & RX_FLAG_160MHZ)
-		sinfo->rxrate.flags |= RATE_INFO_FLAGS_160_MHZ_WIDTH;
 
 	if (ieee80211_vif_is_mesh(&sdata->vif)) {
 #ifdef CONFIG_MAC80211_MESH
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 6835cea..fd69419 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -552,6 +552,8 @@ int sta_info_flush(struct ieee80211_local *local,
 void sta_set_rate_info_tx(struct sta_info *sta,
 			  const struct ieee80211_tx_rate *rate,
 			  struct rate_info *rinfo);
+void sta_set_rate_info_rx(struct sta_info *sta,
+			struct rate_info *rinfo);
 void ieee80211_sta_expire(struct ieee80211_sub_if_data *sdata,
 			  unsigned long exp_time);
