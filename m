Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:42141 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757383AbcCaREV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Mar 2016 13:04:21 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 07/10] mac80211: fix last RX rate data consistency
Date: Thu, 31 Mar 2016 20:02:08 +0300
Message-Id: <1459443731-4614-7-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160331_190424_225633_1FD26BA3)
In-Reply-To: <1459443731-4614-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1459443731-4614-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When storing the last_rate_* values in the RX code, there's nothing
to guarantee consistency, so a concurrent reader could see, e.g.
last_rate_idx on the new value, but last_rate_flag still on the old,
getting completely bogus values in the end.

To fix this, I lifted the sta_stats_encode_rate() function from my
old rate statistics code, which encodes the entire rate data into a
single 16-bit value, avoiding the consistency issue.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/rx.c       | 21 +++++------------
 net/mac80211/sta_info.c | 60 ++++++++++++++++++++++++++-----------------------
 net/mac80211/sta_info.h | 45 ++++++++++++++++++++++++++++++++-----
 3 files changed, 77 insertions(+), 49 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 4ae3bf8..40981f8 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1421,16 +1421,9 @@ ieee80211_rx_h_sta_process(struct ieee80211_rx_data *rx)
 		    test_sta_flag(sta, WLAN_STA_AUTHORIZED)) {
 			sta->rx_stats.last_rx = jiffies;
 			if (ieee80211_is_data(hdr->frame_control) &&
-			    !is_multicast_ether_addr(hdr->addr1)) {
-				sta->rx_stats.last_rate_idx =
-					status->rate_idx;
-				sta->rx_stats.last_rate_flag =
-					status->flag;
-				sta->rx_stats.last_rate_vht_flag =
-					status->vht_flag;
-				sta->rx_stats.last_rate_vht_nss =
-					status->vht_nss;
-			}
+			    !is_multicast_ether_addr(hdr->addr1))
+				sta->rx_stats.last_rate =
+					sta_stats_encode_rate(status);
 		}
 	} else if (rx->sdata->vif.type == NL80211_IFTYPE_OCB) {
 		sta->rx_stats.last_rx = jiffies;
@@ -1440,12 +1433,8 @@ ieee80211_rx_h_sta_process(struct ieee80211_rx_data *rx)
 		 * match the current local configuration when processed.
 		 */
 		sta->rx_stats.last_rx = jiffies;
-		if (ieee80211_is_data(hdr->frame_control)) {
-			sta->rx_stats.last_rate_idx = status->rate_idx;
-			sta->rx_stats.last_rate_flag = status->flag;
-			sta->rx_stats.last_rate_vht_flag = status->vht_flag;
-			sta->rx_stats.last_rate_vht_nss = status->vht_nss;
-		}
+		if (ieee80211_is_data(hdr->frame_control))
+			sta->rx_stats.last_rate = sta_stats_encode_rate(status);
 	}
 
 	if (rx->sdata->vif.type == NL80211_IFTYPE_STATION)
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index b49e2fb..81f1d6c 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -1928,43 +1928,47 @@ u8 sta_info_tx_streams(struct sta_info *sta)
 			>> IEEE80211_HT_MCS_TX_MAX_STREAMS_SHIFT) + 1;
 }
 
-static void sta_set_rate_info_rx(struct sta_info *sta, struct rate_info *rinfo)
+static void sta_stats_decode_rate(struct ieee80211_local *local, u16 rate,
+				  struct rate_info *rinfo)
 {
-	rinfo->flags = 0;
-
-	if (sta->rx_stats.last_rate_flag & RX_FLAG_HT) {
-		rinfo->flags |= RATE_INFO_FLAGS_MCS;
-		rinfo->mcs = sta->rx_stats.last_rate_idx;
-	} else if (sta->rx_stats.last_rate_flag & RX_FLAG_VHT) {
-		rinfo->flags |= RATE_INFO_FLAGS_VHT_MCS;
-		rinfo->nss = sta->rx_stats.last_rate_vht_nss;
-		rinfo->mcs = sta->rx_stats.last_rate_idx;
-	} else {
+	rinfo->bw = (rate & STA_STATS_RATE_BW_MASK) >>
+		STA_STATS_RATE_BW_SHIFT;
+
+	if (rate & STA_STATS_RATE_VHT) {
+		rinfo->flags = RATE_INFO_FLAGS_VHT_MCS;
+		rinfo->mcs = rate & 0xf;
+		rinfo->nss = (rate & 0xf0) >> 4;
+	} else if (rate & STA_STATS_RATE_HT) {
+		rinfo->flags = RATE_INFO_FLAGS_MCS;
+		rinfo->mcs = rate & 0xff;
+	} else if (rate & STA_STATS_RATE_LEGACY) {
 		struct ieee80211_supported_band *sband;
-		int shift = ieee80211_vif_get_shift(&sta->sdata->vif);
 		u16 brate;
-
-		sband = sta->local->hw.wiphy->bands[
-				ieee80211_get_sdata_band(sta->sdata)];
-		brate = sband->bitrates[sta->rx_stats.last_rate_idx].bitrate;
+		unsigned int shift;
+
+		sband = local->hw.wiphy->bands[(rate >> 4) & 0xf];
+		brate = sband->bitrates[rate & 0xf].bitrate;
+		if (rinfo->bw == RATE_INFO_BW_5)
+			shift = 2;
+		else if (rinfo->bw == RATE_INFO_BW_10)
+			shift = 1;
+		else
+			shift = 0;
 		rinfo->legacy = DIV_ROUND_UP(brate, 1 << shift);
 	}
 
-	if (sta->rx_stats.last_rate_flag & RX_FLAG_SHORT_GI)
+	if (rate & STA_STATS_RATE_SGI)
 		rinfo->flags |= RATE_INFO_FLAGS_SHORT_GI;
+}
+
+static void sta_set_rate_info_rx(struct sta_info *sta, struct rate_info *rinfo)
+{
+	u16 rate = ACCESS_ONCE(sta->rx_stats.last_rate);
 
-	if (sta->rx_stats.last_rate_flag & RX_FLAG_5MHZ)
-		rinfo->bw = RATE_INFO_BW_5;
-	else if (sta->rx_stats.last_rate_flag & RX_FLAG_10MHZ)
-		rinfo->bw = RATE_INFO_BW_10;
-	else if (sta->rx_stats.last_rate_flag & RX_FLAG_40MHZ)
-		rinfo->bw = RATE_INFO_BW_40;
-	else if (sta->rx_stats.last_rate_vht_flag & RX_VHT_FLAG_80MHZ)
-		rinfo->bw = RATE_INFO_BW_80;
-	else if (sta->rx_stats.last_rate_vht_flag & RX_VHT_FLAG_160MHZ)
-		rinfo->bw = RATE_INFO_BW_160;
+	if (rate == STA_STATS_RATE_INVALID)
+		rinfo->flags = 0;
 	else
-		rinfo->bw = RATE_INFO_BW_20;
+		sta_stats_decode_rate(sta->local, rate, rinfo);
 }
 
 void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 0ad9a67..f36f560 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -1,7 +1,7 @@
 /*
  * Copyright 2002-2005, Devicescape Software, Inc.
  * Copyright 2013-2014  Intel Mobile Communications GmbH
- * Copyright(c) 2015 Intel Deutschland GmbH
+ * Copyright(c) 2015-2016 Intel Deutschland GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -452,10 +452,7 @@ struct sta_info {
 		int last_signal;
 		u8 chains;
 		s8 chain_signal_last[IEEE80211_MAX_CHAINS];
-		int last_rate_idx;
-		u32 last_rate_flag;
-		u32 last_rate_vht_flag;
-		u8 last_rate_vht_nss;
+		u16 last_rate;
 		u64 msdu[IEEE80211_NUM_TIDS + 1];
 	} rx_stats;
 	struct {
@@ -686,4 +683,42 @@ void ieee80211_sta_ps_deliver_uapsd(struct sta_info *sta);
 
 unsigned long ieee80211_sta_last_active(struct sta_info *sta);
 
+#define STA_STATS_RATE_INVALID		0
+#define STA_STATS_RATE_VHT		0x8000
+#define STA_STATS_RATE_HT		0x4000
+#define STA_STATS_RATE_LEGACY		0x2000
+#define STA_STATS_RATE_SGI		0x1000
+#define STA_STATS_RATE_BW_SHIFT		9
+#define STA_STATS_RATE_BW_MASK		(0x7 << STA_STATS_RATE_BW_SHIFT)
+
+static inline u16 sta_stats_encode_rate(struct ieee80211_rx_status *s)
+{
+	u16 r = s->rate_idx;
+
+	if (s->vht_flag & RX_VHT_FLAG_80MHZ)
+		r |= RATE_INFO_BW_80 << STA_STATS_RATE_BW_SHIFT;
+	else if (s->vht_flag & RX_VHT_FLAG_160MHZ)
+		r |= RATE_INFO_BW_160 << STA_STATS_RATE_BW_SHIFT;
+	else if (s->flag & RX_FLAG_40MHZ)
+		r |= RATE_INFO_BW_40 << STA_STATS_RATE_BW_SHIFT;
+	else if (s->flag & RX_FLAG_10MHZ)
+		r |= RATE_INFO_BW_10 << STA_STATS_RATE_BW_SHIFT;
+	else if (s->flag & RX_FLAG_5MHZ)
+		r |= RATE_INFO_BW_5 << STA_STATS_RATE_BW_SHIFT;
+	else
+		r |= RATE_INFO_BW_20 << STA_STATS_RATE_BW_SHIFT;
+
+	if (s->flag & RX_FLAG_SHORT_GI)
+		r |= STA_STATS_RATE_SGI;
+
+	if (s->flag & RX_FLAG_VHT)
+		r |= STA_STATS_RATE_VHT | (s->vht_nss << 4);
+	else if (s->flag & RX_FLAG_HT)
+		r |= STA_STATS_RATE_HT;
+	else
+		r |= STA_STATS_RATE_LEGACY | (s->band << 4);
+
+	return r;
+}
+
 #endif /* STA_INFO_H */
-- 
2.5.0

