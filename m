Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42494 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757586Ab3CDRDE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Mar 2013 12:03:04 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: greearb@candelatech.com, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: provide race-free 64-bit traffic counters
Date: Mon,  4 Mar 2013 18:02:58 +0100
Message-Id: <1362416578-1672-1-git-send-email-johannes@sipsolutions.net> (sfid-20130304_180309_300167_9633E6E6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Make the TX bytes/packets counters race-free by keeping
them per AC so concurrent TX on queues can't cause lost
or wrong updates. This works since each station belongs
to a single interface. While at it also make the bytes
counters 64-bit.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c      | 22 ++++++++++++++--------
 net/mac80211/sta_info.h |  9 +++++----
 net/mac80211/tx.c       |  5 +++--
 3 files changed, 22 insertions(+), 14 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 8259a5b..1ff629a 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -445,12 +445,13 @@ static void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
 	struct ieee80211_local *local = sdata->local;
 	struct timespec uptime;
+	int ac;
 
 	sinfo->generation = sdata->local->sta_generation;
 
 	sinfo->filled = STATION_INFO_INACTIVE_TIME |
-			STATION_INFO_RX_BYTES |
-			STATION_INFO_TX_BYTES |
+			STATION_INFO_RX_BYTES64 |
+			STATION_INFO_TX_BYTES64 |
 			STATION_INFO_RX_PACKETS |
 			STATION_INFO_TX_PACKETS |
 			STATION_INFO_TX_RETRIES |
@@ -467,10 +468,14 @@ static void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 	sinfo->connected_time = uptime.tv_sec - sta->last_connected;
 
 	sinfo->inactive_time = jiffies_to_msecs(jiffies - sta->last_rx);
+	sinfo->tx_bytes = 0;
+	sinfo->tx_packets = 0;
+	for (ac = 0; ac < IEEE80211_NUM_ACS; ac++) {
+		sinfo->tx_bytes += sta->tx_bytes[ac];
+		sinfo->tx_packets += sta->tx_packets[ac];
+	}
 	sinfo->rx_bytes = sta->rx_bytes;
-	sinfo->tx_bytes = sta->tx_bytes;
 	sinfo->rx_packets = sta->rx_packets;
-	sinfo->tx_packets = sta->tx_packets;
 	sinfo->tx_retries = sta->tx_retry_count;
 	sinfo->tx_failed = sta->tx_retry_failed;
 	sinfo->rx_dropped_misc = sta->rx_dropped;
@@ -598,8 +603,8 @@ static void ieee80211_get_et_stats(struct wiphy *wiphy,
 		data[i++] += sta->rx_fragments;		\
 		data[i++] += sta->rx_dropped;		\
 							\
-		data[i++] += sta->tx_packets;		\
-		data[i++] += sta->tx_bytes;		\
+		data[i++] += sinfo.tx_packets;		\
+		data[i++] += sinfo.tx_bytes;		\
 		data[i++] += sta->tx_fragments;		\
 		data[i++] += sta->tx_filtered_count;	\
 		data[i++] += sta->tx_retry_failed;	\
@@ -621,13 +626,14 @@ static void ieee80211_get_et_stats(struct wiphy *wiphy,
 		if (!(sta && !WARN_ON(sta->sdata->dev != dev)))
 			goto do_survey;
 
+		sinfo.filled = 0;
+		sta_set_sinfo(sta, &sinfo);
+
 		i = 0;
 		ADD_STA_STATS(sta);
 
 		data[i++] = sta->sta_state;
 
-		sinfo.filled = 0;
-		sta_set_sinfo(sta, &sinfo);
 
 		if (sinfo.filled & STATION_INFO_TX_BITRATE)
 			data[i] = 100000 *
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index e5868c3..0d4fec3 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -333,7 +333,8 @@ struct sta_info {
 	unsigned long driver_buffered_tids;
 
 	/* Updated from RX path only, no locking requirements */
-	unsigned long rx_packets, rx_bytes;
+	unsigned long rx_packets;
+	u64 rx_bytes;
 	unsigned long wep_weak_iv_count;
 	unsigned long last_rx;
 	long last_connected;
@@ -353,9 +354,9 @@ struct sta_info {
 	unsigned int fail_avg;
 
 	/* Updated from TX path only, no locking requirements */
-	unsigned long tx_packets;
-	unsigned long tx_bytes;
-	unsigned long tx_fragments;
+	u32 tx_packets[IEEE80211_NUM_ACS];
+	u32 tx_fragments;
+	u64 tx_bytes[IEEE80211_NUM_ACS];
 	struct ieee80211_tx_rate last_tx_rate;
 	int last_rx_rate_idx;
 	u32 last_rx_rate_flag;
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index c79860f..6af7f60 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -991,14 +991,15 @@ static ieee80211_tx_result debug_noinline
 ieee80211_tx_h_stats(struct ieee80211_tx_data *tx)
 {
 	struct sk_buff *skb;
+	int ac = skb_get_queue_mapping(tx->skb);
 
 	if (!tx->sta)
 		return TX_CONTINUE;
 
-	tx->sta->tx_packets++;
+	tx->sta->tx_packets[ac]++;
 	skb_queue_walk(&tx->skbs, skb) {
 		tx->sta->tx_fragments++;
-		tx->sta->tx_bytes += skb->len;
+		tx->sta->tx_bytes[ac] += skb->len;
 	}
 
 	return TX_CONTINUE;
-- 
1.8.0

