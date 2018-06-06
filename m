Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-eopbgr20124.outbound.protection.outlook.com ([40.107.2.124]:55648
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932509AbeFFI1J (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 6 Jun 2018 04:27:09 -0400
From: Omer Efrat <omer.efrat@tandemg.com>
To: linux-wireless@vger.kernel.org
Cc: Omer Efrat <omer.efrat@tandemg.com>
Subject: [PATCH 1/3] net: use BIT_ULL for NL80211_STA_INFO_* attribute types
Date: Wed,  6 Jun 2018 11:26:59 +0300
Message-Id: <1528273621-28116-1-git-send-email-omer.efrat@tandemg.com> (sfid-20180606_102723_958302_FE904769)
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

diff --git a/net/batman-adv/bat_v_elp.c b/net/batman-adv/bat_v_elp.c
index 71c20c1..71e6474 100644
--- a/net/batman-adv/bat_v_elp.c
+++ b/net/batman-adv/bat_v_elp.c
@@ -114,7 +114,7 @@ static u32 batadv_v_elp_get_throughput(struct batadv_hardif_neigh_node *neigh)
 		}
 		if (ret)
 			goto default_throughput;
-		if (!(sinfo.filled & BIT(NL80211_STA_INFO_EXPECTED_THROUGHPUT)))
+		if (!(sinfo.filled & BIT_ULL(NL80211_STA_INFO_EXPECTED_THROUGHPUT)))
 			goto default_throughput;
 
 		return sinfo.expected_throughput / 100;
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
 
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 07514ca..abe838f 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -4561,14 +4561,14 @@ static int nl80211_send_station(struct sk_buff *msg, u32 cmd, u32 portid,
 	PUT_SINFO(CONNECTED_TIME, connected_time, u32);
 	PUT_SINFO(INACTIVE_TIME, inactive_time, u32);
 
-	if (sinfo->filled & (BIT(NL80211_STA_INFO_RX_BYTES) |
-			     BIT(NL80211_STA_INFO_RX_BYTES64)) &&
+	if (sinfo->filled & (BIT_ULL(NL80211_STA_INFO_RX_BYTES) |
+			     BIT_ULL(NL80211_STA_INFO_RX_BYTES64)) &&
 	    nla_put_u32(msg, NL80211_STA_INFO_RX_BYTES,
 			(u32)sinfo->rx_bytes))
 		goto nla_put_failure;
 
-	if (sinfo->filled & (BIT(NL80211_STA_INFO_TX_BYTES) |
-			     BIT(NL80211_STA_INFO_TX_BYTES64)) &&
+	if (sinfo->filled & (BIT_ULL(NL80211_STA_INFO_TX_BYTES) |
+			     BIT_ULL(NL80211_STA_INFO_TX_BYTES64)) &&
 	    nla_put_u32(msg, NL80211_STA_INFO_TX_BYTES,
 			(u32)sinfo->tx_bytes))
 		goto nla_put_failure;
@@ -4588,24 +4588,24 @@ static int nl80211_send_station(struct sk_buff *msg, u32 cmd, u32 portid,
 	default:
 		break;
 	}
-	if (sinfo->filled & BIT(NL80211_STA_INFO_CHAIN_SIGNAL)) {
+	if (sinfo->filled & BIT_ULL(NL80211_STA_INFO_CHAIN_SIGNAL)) {
 		if (!nl80211_put_signal(msg, sinfo->chains,
 					sinfo->chain_signal,
 					NL80211_STA_INFO_CHAIN_SIGNAL))
 			goto nla_put_failure;
 	}
-	if (sinfo->filled & BIT(NL80211_STA_INFO_CHAIN_SIGNAL_AVG)) {
+	if (sinfo->filled & BIT_ULL(NL80211_STA_INFO_CHAIN_SIGNAL_AVG)) {
 		if (!nl80211_put_signal(msg, sinfo->chains,
 					sinfo->chain_signal_avg,
 					NL80211_STA_INFO_CHAIN_SIGNAL_AVG))
 			goto nla_put_failure;
 	}
-	if (sinfo->filled & BIT(NL80211_STA_INFO_TX_BITRATE)) {
+	if (sinfo->filled & BIT_ULL(NL80211_STA_INFO_TX_BITRATE)) {
 		if (!nl80211_put_sta_rate(msg, &sinfo->txrate,
 					  NL80211_STA_INFO_TX_BITRATE))
 			goto nla_put_failure;
 	}
-	if (sinfo->filled & BIT(NL80211_STA_INFO_RX_BITRATE)) {
+	if (sinfo->filled & BIT_ULL(NL80211_STA_INFO_RX_BITRATE)) {
 		if (!nl80211_put_sta_rate(msg, &sinfo->rxrate,
 					  NL80211_STA_INFO_RX_BITRATE))
 			goto nla_put_failure;
@@ -4621,7 +4621,7 @@ static int nl80211_send_station(struct sk_buff *msg, u32 cmd, u32 portid,
 	PUT_SINFO(PEER_PM, peer_pm, u32);
 	PUT_SINFO(NONPEER_PM, nonpeer_pm, u32);
 
-	if (sinfo->filled & BIT(NL80211_STA_INFO_BSS_PARAM)) {
+	if (sinfo->filled & BIT_ULL(NL80211_STA_INFO_BSS_PARAM)) {
 		bss_param = nla_nest_start(msg, NL80211_STA_INFO_BSS_PARAM);
 		if (!bss_param)
 			goto nla_put_failure;
@@ -4640,7 +4640,7 @@ static int nl80211_send_station(struct sk_buff *msg, u32 cmd, u32 portid,
 
 		nla_nest_end(msg, bss_param);
 	}
-	if ((sinfo->filled & BIT(NL80211_STA_INFO_STA_FLAGS)) &&
+	if ((sinfo->filled & BIT_ULL(NL80211_STA_INFO_STA_FLAGS)) &&
 	    nla_put(msg, NL80211_STA_INFO_STA_FLAGS,
 		    sizeof(struct nl80211_sta_flag_update),
 		    &sinfo->sta_flags))
@@ -10160,7 +10160,7 @@ static int cfg80211_cqm_rssi_update(struct cfg80211_registered_device *rdev,
 		if (err)
 			return err;
 
-		if (sinfo.filled & BIT(NL80211_STA_INFO_BEACON_SIGNAL_AVG))
+		if (sinfo.filled & BIT_ULL(NL80211_STA_INFO_BEACON_SIGNAL_AVG))
 			wdev->cqm_config->last_rssi_event_value =
 				(s8) sinfo.rx_beacon_signal_avg;
 	}
diff --git a/net/wireless/wext-compat.c b/net/wireless/wext-compat.c
index 05186a4..167f702 100644
--- a/net/wireless/wext-compat.c
+++ b/net/wireless/wext-compat.c
@@ -1278,7 +1278,7 @@ static int cfg80211_wext_giwrate(struct net_device *dev,
 	if (err)
 		return err;
 
-	if (!(sinfo.filled & BIT(NL80211_STA_INFO_TX_BITRATE)))
+	if (!(sinfo.filled & BIT_ULL(NL80211_STA_INFO_TX_BITRATE)))
 		return -EOPNOTSUPP;
 
 	rate->value = 100000 * cfg80211_calculate_bitrate(&sinfo.txrate);
@@ -1320,7 +1320,7 @@ static struct iw_statistics *cfg80211_wireless_stats(struct net_device *dev)
 
 	switch (rdev->wiphy.signal_type) {
 	case CFG80211_SIGNAL_TYPE_MBM:
-		if (sinfo.filled & BIT(NL80211_STA_INFO_SIGNAL)) {
+		if (sinfo.filled & BIT_ULL(NL80211_STA_INFO_SIGNAL)) {
 			int sig = sinfo.signal;
 			wstats.qual.updated |= IW_QUAL_LEVEL_UPDATED;
 			wstats.qual.updated |= IW_QUAL_QUAL_UPDATED;
@@ -1334,7 +1334,7 @@ static struct iw_statistics *cfg80211_wireless_stats(struct net_device *dev)
 			break;
 		}
 	case CFG80211_SIGNAL_TYPE_UNSPEC:
-		if (sinfo.filled & BIT(NL80211_STA_INFO_SIGNAL)) {
+		if (sinfo.filled & BIT_ULL(NL80211_STA_INFO_SIGNAL)) {
 			wstats.qual.updated |= IW_QUAL_LEVEL_UPDATED;
 			wstats.qual.updated |= IW_QUAL_QUAL_UPDATED;
 			wstats.qual.level = sinfo.signal;
@@ -1347,9 +1347,9 @@ static struct iw_statistics *cfg80211_wireless_stats(struct net_device *dev)
 	}
 
 	wstats.qual.updated |= IW_QUAL_NOISE_INVALID;
-	if (sinfo.filled & BIT(NL80211_STA_INFO_RX_DROP_MISC))
+	if (sinfo.filled & BIT_ULL(NL80211_STA_INFO_RX_DROP_MISC))
 		wstats.discard.misc = sinfo.rx_dropped_misc;
-	if (sinfo.filled & BIT(NL80211_STA_INFO_TX_FAILED))
+	if (sinfo.filled & BIT_ULL(NL80211_STA_INFO_TX_FAILED))
 		wstats.discard.retries = sinfo.tx_failed;
 
 	return &wstats;
-- 
2.7.4
