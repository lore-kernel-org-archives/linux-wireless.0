Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-he1eur01on0105.outbound.protection.outlook.com ([104.47.0.105]:13274
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754986AbeFNKLV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Jun 2018 06:11:21 -0400
From: Omer Efrat <omer.efrat@tandemg.com>
To: linux-wireless@vger.kernel.org
Cc: Omer Efrat <omer.efrat@tandemg.com>
Subject: [PATCH v2 2/5] mac80211: use BIT_ULL for NL80211_STA_INFO_* attribute types
Date: Thu, 14 Jun 2018 13:11:13 +0300
Message-Id: <1528971073-349-1-git-send-email-omer.efrat@tandemg.com> (sfid-20180614_121125_842548_E3DF065D)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since 'filled' member in station_info changed to u64, BIT_ULL macro
should be used with NL80211_STA_INFO_* attribute types instead of BIT.

The BIT macro uses unsigned long type which some architectures handle as 32bit
and this results in compilation warnings such as:

net/mac80211/sta_info.c:2223:2: warning: left shift count >= width of type
  sinfo->filled |= BIT(NL80211_STA_INFO_TID_STATS);
  ^

Signed-off-by: Omer Efrat <omer.efrat@tandemg.com>
---
 net/mac80211/ethtool.c  |  6 ++--
 net/mac80211/sta_info.c | 84 ++++++++++++++++++++++++-------------------------
 2 files changed, 45 insertions(+), 45 deletions(-)

diff --git a/net/mac80211/ethtool.c b/net/mac80211/ethtool.c
index 690c142..5ac7438 100644
--- a/net/mac80211/ethtool.c
+++ b/net/mac80211/ethtool.c
@@ -116,16 +116,16 @@ static void ieee80211_get_stats(struct net_device *dev,
 		data[i++] = sta->sta_state;
 
 
-		if (sinfo.filled & BIT(NL80211_STA_INFO_TX_BITRATE))
+		if (sinfo.filled & BIT_ULL(NL80211_STA_INFO_TX_BITRATE))
 			data[i] = 100000ULL *
 				cfg80211_calculate_bitrate(&sinfo.txrate);
 		i++;
-		if (sinfo.filled & BIT(NL80211_STA_INFO_RX_BITRATE))
+		if (sinfo.filled & BIT_ULL(NL80211_STA_INFO_RX_BITRATE))
 			data[i] = 100000ULL *
 				cfg80211_calculate_bitrate(&sinfo.rxrate);
 		i++;
 
-		if (sinfo.filled & BIT(NL80211_STA_INFO_SIGNAL_AVG))
+		if (sinfo.filled & BIT_ULL(NL80211_STA_INFO_SIGNAL_AVG))
 			data[i] = (u8)sinfo.signal_avg;
 		i++;
 	} else {
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 6428f1a..656a838 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -2101,38 +2101,38 @@ void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo,
 
 	drv_sta_statistics(local, sdata, &sta->sta, sinfo);
 
-	sinfo->filled |= BIT(NL80211_STA_INFO_INACTIVE_TIME) |
-			 BIT(NL80211_STA_INFO_STA_FLAGS) |
-			 BIT(NL80211_STA_INFO_BSS_PARAM) |
-			 BIT(NL80211_STA_INFO_CONNECTED_TIME) |
-			 BIT(NL80211_STA_INFO_RX_DROP_MISC);
+	sinfo->filled |= BIT_ULL(NL80211_STA_INFO_INACTIVE_TIME) |
+			 BIT_ULL(NL80211_STA_INFO_STA_FLAGS) |
+			 BIT_ULL(NL80211_STA_INFO_BSS_PARAM) |
+			 BIT_ULL(NL80211_STA_INFO_CONNECTED_TIME) |
+			 BIT_ULL(NL80211_STA_INFO_RX_DROP_MISC);
 
 	if (sdata->vif.type == NL80211_IFTYPE_STATION) {
 		sinfo->beacon_loss_count = sdata->u.mgd.beacon_loss_count;
-		sinfo->filled |= BIT(NL80211_STA_INFO_BEACON_LOSS);
+		sinfo->filled |= BIT_ULL(NL80211_STA_INFO_BEACON_LOSS);
 	}
 
 	sinfo->connected_time = ktime_get_seconds() - sta->last_connected;
 	sinfo->inactive_time =
 		jiffies_to_msecs(jiffies - ieee80211_sta_last_active(sta));
 
-	if (!(sinfo->filled & (BIT(NL80211_STA_INFO_TX_BYTES64) |
-			       BIT(NL80211_STA_INFO_TX_BYTES)))) {
+	if (!(sinfo->filled & (BIT_ULL(NL80211_STA_INFO_TX_BYTES64) |
+			       BIT_ULL(NL80211_STA_INFO_TX_BYTES)))) {
 		sinfo->tx_bytes = 0;
 		for (ac = 0; ac < IEEE80211_NUM_ACS; ac++)
 			sinfo->tx_bytes += sta->tx_stats.bytes[ac];
-		sinfo->filled |= BIT(NL80211_STA_INFO_TX_BYTES64);
+		sinfo->filled |= BIT_ULL(NL80211_STA_INFO_TX_BYTES64);
 	}
 
-	if (!(sinfo->filled & BIT(NL80211_STA_INFO_TX_PACKETS))) {
+	if (!(sinfo->filled & BIT_ULL(NL80211_STA_INFO_TX_PACKETS))) {
 		sinfo->tx_packets = 0;
 		for (ac = 0; ac < IEEE80211_NUM_ACS; ac++)
 			sinfo->tx_packets += sta->tx_stats.packets[ac];
-		sinfo->filled |= BIT(NL80211_STA_INFO_TX_PACKETS);
+		sinfo->filled |= BIT_ULL(NL80211_STA_INFO_TX_PACKETS);
 	}
 
-	if (!(sinfo->filled & (BIT(NL80211_STA_INFO_RX_BYTES64) |
-			       BIT(NL80211_STA_INFO_RX_BYTES)))) {
+	if (!(sinfo->filled & (BIT_ULL(NL80211_STA_INFO_RX_BYTES64) |
+			       BIT_ULL(NL80211_STA_INFO_RX_BYTES)))) {
 		sinfo->rx_bytes += sta_get_stats_bytes(&sta->rx_stats);
 
 		if (sta->pcpu_rx_stats) {
@@ -2144,10 +2144,10 @@ void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo,
 			}
 		}
 
-		sinfo->filled |= BIT(NL80211_STA_INFO_RX_BYTES64);
+		sinfo->filled |= BIT_ULL(NL80211_STA_INFO_RX_BYTES64);
 	}
 
-	if (!(sinfo->filled & BIT(NL80211_STA_INFO_RX_PACKETS))) {
+	if (!(sinfo->filled & BIT_ULL(NL80211_STA_INFO_RX_PACKETS))) {
 		sinfo->rx_packets = sta->rx_stats.packets;
 		if (sta->pcpu_rx_stats) {
 			for_each_possible_cpu(cpu) {
@@ -2157,17 +2157,17 @@ void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo,
 				sinfo->rx_packets += cpurxs->packets;
 			}
 		}
-		sinfo->filled |= BIT(NL80211_STA_INFO_RX_PACKETS);
+		sinfo->filled |= BIT_ULL(NL80211_STA_INFO_RX_PACKETS);
 	}
 
-	if (!(sinfo->filled & BIT(NL80211_STA_INFO_TX_RETRIES))) {
+	if (!(sinfo->filled & BIT_ULL(NL80211_STA_INFO_TX_RETRIES))) {
 		sinfo->tx_retries = sta->status_stats.retry_count;
-		sinfo->filled |= BIT(NL80211_STA_INFO_TX_RETRIES);
+		sinfo->filled |= BIT_ULL(NL80211_STA_INFO_TX_RETRIES);
 	}
 
-	if (!(sinfo->filled & BIT(NL80211_STA_INFO_TX_FAILED))) {
+	if (!(sinfo->filled & BIT_ULL(NL80211_STA_INFO_TX_FAILED))) {
 		sinfo->tx_failed = sta->status_stats.retry_failed;
-		sinfo->filled |= BIT(NL80211_STA_INFO_TX_FAILED);
+		sinfo->filled |= BIT_ULL(NL80211_STA_INFO_TX_FAILED);
 	}
 
 	sinfo->rx_dropped_misc = sta->rx_stats.dropped;
@@ -2182,23 +2182,23 @@ void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo,
 
 	if (sdata->vif.type == NL80211_IFTYPE_STATION &&
 	    !(sdata->vif.driver_flags & IEEE80211_VIF_BEACON_FILTER)) {
-		sinfo->filled |= BIT(NL80211_STA_INFO_BEACON_RX) |
-				 BIT(NL80211_STA_INFO_BEACON_SIGNAL_AVG);
+		sinfo->filled |= BIT_ULL(NL80211_STA_INFO_BEACON_RX) |
+				 BIT_ULL(NL80211_STA_INFO_BEACON_SIGNAL_AVG);
 		sinfo->rx_beacon_signal_avg = ieee80211_ave_rssi(&sdata->vif);
 	}
 
 	if (ieee80211_hw_check(&sta->local->hw, SIGNAL_DBM) ||
 	    ieee80211_hw_check(&sta->local->hw, SIGNAL_UNSPEC)) {
-		if (!(sinfo->filled & BIT(NL80211_STA_INFO_SIGNAL))) {
+		if (!(sinfo->filled & BIT_ULL(NL80211_STA_INFO_SIGNAL))) {
 			sinfo->signal = (s8)last_rxstats->last_signal;
-			sinfo->filled |= BIT(NL80211_STA_INFO_SIGNAL);
+			sinfo->filled |= BIT_ULL(NL80211_STA_INFO_SIGNAL);
 		}
 
 		if (!sta->pcpu_rx_stats &&
-		    !(sinfo->filled & BIT(NL80211_STA_INFO_SIGNAL_AVG))) {
+		    !(sinfo->filled & BIT_ULL(NL80211_STA_INFO_SIGNAL_AVG))) {
 			sinfo->signal_avg =
 				-ewma_signal_read(&sta->rx_stats_avg.signal);
-			sinfo->filled |= BIT(NL80211_STA_INFO_SIGNAL_AVG);
+			sinfo->filled |= BIT_ULL(NL80211_STA_INFO_SIGNAL_AVG);
 		}
 	}
 
@@ -2207,11 +2207,11 @@ void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo,
 	 * pcpu statistics
 	 */
 	if (last_rxstats->chains &&
-	    !(sinfo->filled & (BIT(NL80211_STA_INFO_CHAIN_SIGNAL) |
-			       BIT(NL80211_STA_INFO_CHAIN_SIGNAL_AVG)))) {
-		sinfo->filled |= BIT(NL80211_STA_INFO_CHAIN_SIGNAL);
+	    !(sinfo->filled & (BIT_ULL(NL80211_STA_INFO_CHAIN_SIGNAL) |
+			       BIT_ULL(NL80211_STA_INFO_CHAIN_SIGNAL_AVG)))) {
+		sinfo->filled |= BIT_ULL(NL80211_STA_INFO_CHAIN_SIGNAL);
 		if (!sta->pcpu_rx_stats)
-			sinfo->filled |= BIT(NL80211_STA_INFO_CHAIN_SIGNAL_AVG);
+			sinfo->filled |= BIT_ULL(NL80211_STA_INFO_CHAIN_SIGNAL_AVG);
 
 		sinfo->chains = last_rxstats->chains;
 
@@ -2223,15 +2223,15 @@ void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo,
 		}
 	}
 
-	if (!(sinfo->filled & BIT(NL80211_STA_INFO_TX_BITRATE))) {
+	if (!(sinfo->filled & BIT_ULL(NL80211_STA_INFO_TX_BITRATE))) {
 		sta_set_rate_info_tx(sta, &sta->tx_stats.last_rate,
 				     &sinfo->txrate);
-		sinfo->filled |= BIT(NL80211_STA_INFO_TX_BITRATE);
+		sinfo->filled |= BIT_ULL(NL80211_STA_INFO_TX_BITRATE);
 	}
 
-	if (!(sinfo->filled & BIT(NL80211_STA_INFO_RX_BITRATE))) {
+	if (!(sinfo->filled & BIT_ULL(NL80211_STA_INFO_RX_BITRATE))) {
 		if (sta_set_rate_info_rx(sta, &sinfo->rxrate) == 0)
-			sinfo->filled |= BIT(NL80211_STA_INFO_RX_BITRATE);
+			sinfo->filled |= BIT_ULL(NL80211_STA_INFO_RX_BITRATE);
 	}
 
 	if (tidstats && !cfg80211_sinfo_alloc_tid_stats(sinfo, GFP_KERNEL)) {
@@ -2244,18 +2244,18 @@ void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo,
 
 	if (ieee80211_vif_is_mesh(&sdata->vif)) {
 #ifdef CONFIG_MAC80211_MESH
-		sinfo->filled |= BIT(NL80211_STA_INFO_LLID) |
-				 BIT(NL80211_STA_INFO_PLID) |
-				 BIT(NL80211_STA_INFO_PLINK_STATE) |
-				 BIT(NL80211_STA_INFO_LOCAL_PM) |
-				 BIT(NL80211_STA_INFO_PEER_PM) |
-				 BIT(NL80211_STA_INFO_NONPEER_PM);
+		sinfo->filled |= BIT_ULL(NL80211_STA_INFO_LLID) |
+				 BIT_ULL(NL80211_STA_INFO_PLID) |
+				 BIT_ULL(NL80211_STA_INFO_PLINK_STATE) |
+				 BIT_ULL(NL80211_STA_INFO_LOCAL_PM) |
+				 BIT_ULL(NL80211_STA_INFO_PEER_PM) |
+				 BIT_ULL(NL80211_STA_INFO_NONPEER_PM);
 
 		sinfo->llid = sta->mesh->llid;
 		sinfo->plid = sta->mesh->plid;
 		sinfo->plink_state = sta->mesh->plink_state;
 		if (test_sta_flag(sta, WLAN_STA_TOFFSET_KNOWN)) {
-			sinfo->filled |= BIT(NL80211_STA_INFO_T_OFFSET);
+			sinfo->filled |= BIT_ULL(NL80211_STA_INFO_T_OFFSET);
 			sinfo->t_offset = sta->mesh->t_offset;
 		}
 		sinfo->local_pm = sta->mesh->local_pm;
@@ -2300,7 +2300,7 @@ void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo,
 	thr = sta_get_expected_throughput(sta);
 
 	if (thr != 0) {
-		sinfo->filled |= BIT(NL80211_STA_INFO_EXPECTED_THROUGHPUT);
+		sinfo->filled |= BIT_ULL(NL80211_STA_INFO_EXPECTED_THROUGHPUT);
 		sinfo->expected_throughput = thr;
 	}
 
-- 
2.7.4
