Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-eopbgr20124.outbound.protection.outlook.com ([40.107.2.124]:55648
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932590AbeFFI1M (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 6 Jun 2018 04:27:12 -0400
From: Omer Efrat <omer.efrat@tandemg.com>
To: linux-wireless@vger.kernel.org
Cc: Omer Efrat <omer.efrat@tandemg.com>
Subject: [PATCH 2/3] wireless-drivers: use BIT_ULL for NL80211_STA_INFO_* attribute types
Date: Wed,  6 Jun 2018 11:27:00 +0300
Message-Id: <1528273621-28116-2-git-send-email-omer.efrat@tandemg.com> (sfid-20180606_102724_829134_F16EC0C1)
In-Reply-To: <1528273621-28116-1-git-send-email-omer.efrat@tandemg.com>
References: <1528273621-28116-1-git-send-email-omer.efrat@tandemg.com>
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

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 2ba8cf3..360c8d1 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -1811,20 +1811,20 @@ static int ath6kl_get_station(struct wiphy *wiphy, struct net_device *dev,
 
 	if (vif->target_stats.rx_byte) {
 		sinfo->rx_bytes = vif->target_stats.rx_byte;
-		sinfo->filled |= BIT(NL80211_STA_INFO_RX_BYTES64);
+		sinfo->filled |= BIT_ULL(NL80211_STA_INFO_RX_BYTES64);
 		sinfo->rx_packets = vif->target_stats.rx_pkt;
-		sinfo->filled |= BIT(NL80211_STA_INFO_RX_PACKETS);
+		sinfo->filled |= BIT_ULL(NL80211_STA_INFO_RX_PACKETS);
 	}
 
 	if (vif->target_stats.tx_byte) {
 		sinfo->tx_bytes = vif->target_stats.tx_byte;
-		sinfo->filled |= BIT(NL80211_STA_INFO_TX_BYTES64);
+		sinfo->filled |= BIT_ULL(NL80211_STA_INFO_TX_BYTES64);
 		sinfo->tx_packets = vif->target_stats.tx_pkt;
-		sinfo->filled |= BIT(NL80211_STA_INFO_TX_PACKETS);
+		sinfo->filled |= BIT_ULL(NL80211_STA_INFO_TX_PACKETS);
 	}
 
 	sinfo->signal = vif->target_stats.cs_rssi;
-	sinfo->filled |= BIT(NL80211_STA_INFO_SIGNAL);
+	sinfo->filled |= BIT_ULL(NL80211_STA_INFO_SIGNAL);
 
 	rate = vif->target_stats.tx_ucast_rate;
 
@@ -1857,12 +1857,12 @@ static int ath6kl_get_station(struct wiphy *wiphy, struct net_device *dev,
 		return 0;
 	}
 
-	sinfo->filled |= BIT(NL80211_STA_INFO_TX_BITRATE);
+	sinfo->filled |= BIT_ULL(NL80211_STA_INFO_TX_BITRATE);
 
 	if (test_bit(CONNECTED, &vif->flags) &&
 	    test_bit(DTIM_PERIOD_AVAIL, &vif->flags) &&
 	    vif->nw_type == INFRA_NETWORK) {
-		sinfo->filled |= BIT(NL80211_STA_INFO_BSS_PARAM);
+		sinfo->filled |= BIT_ULL(NL80211_STA_INFO_BSS_PARAM);
 		sinfo->bss_param.flags = 0;
 		sinfo->bss_param.dtim_period = vif->assoc_bss_dtim_period;
 		sinfo->bss_param.beacon_interval = vif->assoc_bss_beacon_int;
diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index 78946f2..013d056 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -302,14 +302,14 @@ int wil_cid_fill_sinfo(struct wil6210_vif *vif, int cid,
 
 	sinfo->generation = wil->sinfo_gen;
 
-	sinfo->filled = BIT(NL80211_STA_INFO_RX_BYTES) |
-			BIT(NL80211_STA_INFO_TX_BYTES) |
-			BIT(NL80211_STA_INFO_RX_PACKETS) |
-			BIT(NL80211_STA_INFO_TX_PACKETS) |
-			BIT(NL80211_STA_INFO_RX_BITRATE) |
-			BIT(NL80211_STA_INFO_TX_BITRATE) |
-			BIT(NL80211_STA_INFO_RX_DROP_MISC) |
-			BIT(NL80211_STA_INFO_TX_FAILED);
+	sinfo->filled = BIT_ULL(NL80211_STA_INFO_RX_BYTES) |
+			BIT_ULL(NL80211_STA_INFO_TX_BYTES) |
+			BIT_ULL(NL80211_STA_INFO_RX_PACKETS) |
+			BIT_ULL(NL80211_STA_INFO_TX_PACKETS) |
+			BIT_ULL(NL80211_STA_INFO_RX_BITRATE) |
+			BIT_ULL(NL80211_STA_INFO_TX_BITRATE) |
+			BIT_ULL(NL80211_STA_INFO_RX_DROP_MISC) |
+			BIT_ULL(NL80211_STA_INFO_TX_FAILED);
 
 	sinfo->txrate.flags = RATE_INFO_FLAGS_60G;
 	sinfo->txrate.mcs = le16_to_cpu(reply.evt.bf_mcs);
@@ -322,7 +322,7 @@ int wil_cid_fill_sinfo(struct wil6210_vif *vif, int cid,
 	sinfo->tx_failed = stats->tx_errors;
 
 	if (test_bit(wil_vif_fwconnected, vif->status)) {
-		sinfo->filled |= BIT(NL80211_STA_INFO_SIGNAL);
+		sinfo->filled |= BIT_ULL(NL80211_STA_INFO_SIGNAL);
 		if (test_bit(WMI_FW_CAPABILITY_RSSI_REPORTING,
 			     wil->fw_capabilities))
 			sinfo->signal = reply.evt.rssi;
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index b6122aa..24c4e18 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -2434,7 +2434,7 @@ static void brcmf_convert_sta_flags(u32 fw_sta_flags, struct station_info *si)
 	struct nl80211_sta_flag_update *sfu;
 
 	brcmf_dbg(TRACE, "flags %08x\n", fw_sta_flags);
-	si->filled |= BIT(NL80211_STA_INFO_STA_FLAGS);
+	si->filled |= BIT_ULL(NL80211_STA_INFO_STA_FLAGS);
 	sfu = &si->sta_flags;
 	sfu->mask = BIT(NL80211_STA_FLAG_WME) |
 		    BIT(NL80211_STA_FLAG_AUTHENTICATED) |
@@ -2470,7 +2470,7 @@ static void brcmf_fill_bss_param(struct brcmf_if *ifp, struct station_info *si)
 		brcmf_err("Failed to get bss info (%d)\n", err);
 		goto out_kfree;
 	}
-	si->filled |= BIT(NL80211_STA_INFO_BSS_PARAM);
+	si->filled |= BIT_ULL(NL80211_STA_INFO_BSS_PARAM);
 	si->bss_param.beacon_interval = le16_to_cpu(buf->bss_le.beacon_period);
 	si->bss_param.dtim_period = buf->bss_le.dtim_period;
 	capability = le16_to_cpu(buf->bss_le.capability);
@@ -2501,7 +2501,7 @@ brcmf_cfg80211_get_station_ibss(struct brcmf_if *ifp,
 		brcmf_err("BRCMF_C_GET_RATE error (%d)\n", err);
 		return err;
 	}
-	sinfo->filled |= BIT(NL80211_STA_INFO_TX_BITRATE);
+	sinfo->filled |= BIT_ULL(NL80211_STA_INFO_TX_BITRATE);
 	sinfo->txrate.legacy = rate * 5;
 
 	memset(&scbval, 0, sizeof(scbval));
@@ -2512,7 +2512,7 @@ brcmf_cfg80211_get_station_ibss(struct brcmf_if *ifp,
 		return err;
 	}
 	rssi = le32_to_cpu(scbval.val);
-	sinfo->filled |= BIT(NL80211_STA_INFO_SIGNAL);
+	sinfo->filled |= BIT_ULL(NL80211_STA_INFO_SIGNAL);
 	sinfo->signal = rssi;
 
 	err = brcmf_fil_cmd_data_get(ifp, BRCMF_C_GET_GET_PKTCNTS, &pktcnt,
@@ -2521,10 +2521,10 @@ brcmf_cfg80211_get_station_ibss(struct brcmf_if *ifp,
 		brcmf_err("BRCMF_C_GET_GET_PKTCNTS error (%d)\n", err);
 		return err;
 	}
-	sinfo->filled |= BIT(NL80211_STA_INFO_RX_PACKETS) |
-			 BIT(NL80211_STA_INFO_RX_DROP_MISC) |
-			 BIT(NL80211_STA_INFO_TX_PACKETS) |
-			 BIT(NL80211_STA_INFO_TX_FAILED);
+	sinfo->filled |= BIT_ULL(NL80211_STA_INFO_RX_PACKETS) |
+			 BIT_ULL(NL80211_STA_INFO_RX_DROP_MISC) |
+			 BIT_ULL(NL80211_STA_INFO_TX_PACKETS) |
+			 BIT_ULL(NL80211_STA_INFO_TX_FAILED);
 	sinfo->rx_packets = le32_to_cpu(pktcnt.rx_good_pkt);
 	sinfo->rx_dropped_misc = le32_to_cpu(pktcnt.rx_bad_pkt);
 	sinfo->tx_packets = le32_to_cpu(pktcnt.tx_good_pkt);
@@ -2571,7 +2571,7 @@ brcmf_cfg80211_get_station(struct wiphy *wiphy, struct net_device *ndev,
 		}
 	}
 	brcmf_dbg(TRACE, "version %d\n", le16_to_cpu(sta_info_le.ver));
-	sinfo->filled = BIT(NL80211_STA_INFO_INACTIVE_TIME);
+	sinfo->filled = BIT_ULL(NL80211_STA_INFO_INACTIVE_TIME);
 	sinfo->inactive_time = le32_to_cpu(sta_info_le.idle) * 1000;
 	sta_flags = le32_to_cpu(sta_info_le.flags);
 	brcmf_convert_sta_flags(sta_flags, sinfo);
@@ -2581,33 +2581,33 @@ brcmf_cfg80211_get_station(struct wiphy *wiphy, struct net_device *ndev,
 	else
 		sinfo->sta_flags.set &= ~BIT(NL80211_STA_FLAG_TDLS_PEER);
 	if (sta_flags & BRCMF_STA_ASSOC) {
-		sinfo->filled |= BIT(NL80211_STA_INFO_CONNECTED_TIME);
+		sinfo->filled |= BIT_ULL(NL80211_STA_INFO_CONNECTED_TIME);
 		sinfo->connected_time = le32_to_cpu(sta_info_le.in);
 		brcmf_fill_bss_param(ifp, sinfo);
 	}
 	if (sta_flags & BRCMF_STA_SCBSTATS) {
-		sinfo->filled |= BIT(NL80211_STA_INFO_TX_FAILED);
+		sinfo->filled |= BIT_ULL(NL80211_STA_INFO_TX_FAILED);
 		sinfo->tx_failed = le32_to_cpu(sta_info_le.tx_failures);
-		sinfo->filled |= BIT(NL80211_STA_INFO_TX_PACKETS);
+		sinfo->filled |= BIT_ULL(NL80211_STA_INFO_TX_PACKETS);
 		sinfo->tx_packets = le32_to_cpu(sta_info_le.tx_pkts);
 		sinfo->tx_packets += le32_to_cpu(sta_info_le.tx_mcast_pkts);
-		sinfo->filled |= BIT(NL80211_STA_INFO_RX_PACKETS);
+		sinfo->filled |= BIT_ULL(NL80211_STA_INFO_RX_PACKETS);
 		sinfo->rx_packets = le32_to_cpu(sta_info_le.rx_ucast_pkts);
 		sinfo->rx_packets += le32_to_cpu(sta_info_le.rx_mcast_pkts);
 		if (sinfo->tx_packets) {
-			sinfo->filled |= BIT(NL80211_STA_INFO_TX_BITRATE);
+			sinfo->filled |= BIT_ULL(NL80211_STA_INFO_TX_BITRATE);
 			sinfo->txrate.legacy =
 				le32_to_cpu(sta_info_le.tx_rate) / 100;
 		}
 		if (sinfo->rx_packets) {
-			sinfo->filled |= BIT(NL80211_STA_INFO_RX_BITRATE);
+			sinfo->filled |= BIT_ULL(NL80211_STA_INFO_RX_BITRATE);
 			sinfo->rxrate.legacy =
 				le32_to_cpu(sta_info_le.rx_rate) / 100;
 		}
 		if (le16_to_cpu(sta_info_le.ver) >= 4) {
-			sinfo->filled |= BIT(NL80211_STA_INFO_TX_BYTES);
+			sinfo->filled |= BIT_ULL(NL80211_STA_INFO_TX_BYTES);
 			sinfo->tx_bytes = le64_to_cpu(sta_info_le.tx_tot_bytes);
-			sinfo->filled |= BIT(NL80211_STA_INFO_RX_BYTES);
+			sinfo->filled |= BIT_ULL(NL80211_STA_INFO_RX_BYTES);
 			sinfo->rx_bytes = le64_to_cpu(sta_info_le.rx_tot_bytes);
 		}
 		total_rssi = 0;
@@ -2623,10 +2623,10 @@ brcmf_cfg80211_get_station(struct wiphy *wiphy, struct net_device *ndev,
 			}
 		}
 		if (count_rssi) {
-			sinfo->filled |= BIT(NL80211_STA_INFO_CHAIN_SIGNAL);
+			sinfo->filled |= BIT_ULL(NL80211_STA_INFO_CHAIN_SIGNAL);
 			sinfo->chains = count_rssi;
 
-			sinfo->filled |= BIT(NL80211_STA_INFO_SIGNAL);
+			sinfo->filled |= BIT_ULL(NL80211_STA_INFO_SIGNAL);
 			total_rssi /= count_rssi;
 			sinfo->signal = total_rssi;
 		} else if (test_bit(BRCMF_VIF_STATUS_CONNECTED,
@@ -2639,7 +2639,7 @@ brcmf_cfg80211_get_station(struct wiphy *wiphy, struct net_device *ndev,
 				goto done;
 			} else {
 				rssi = le32_to_cpu(scb_val.val);
-				sinfo->filled |= BIT(NL80211_STA_INFO_SIGNAL);
+				sinfo->filled |= BIT_ULL(NL80211_STA_INFO_SIGNAL);
 				sinfo->signal = rssi;
 				brcmf_dbg(CONN, "RSSI %d dBm\n", rssi);
 			}
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 94202e2..d73f86c 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -4217,7 +4217,7 @@ static void iwl_mvm_mac_sta_statistics(struct ieee80211_hw *hw,
 
 	if (mvmsta->avg_energy) {
 		sinfo->signal_avg = mvmsta->avg_energy;
-		sinfo->filled |= BIT(NL80211_STA_INFO_SIGNAL_AVG);
+		sinfo->filled |= BIT_ULL(NL80211_STA_INFO_SIGNAL_AVG);
 	}
 
 	if (!fw_has_capa(&mvm->fw->ucode_capa,
@@ -4241,11 +4241,11 @@ static void iwl_mvm_mac_sta_statistics(struct ieee80211_hw *hw,
 
 	sinfo->rx_beacon = mvmvif->beacon_stats.num_beacons +
 			   mvmvif->beacon_stats.accu_num_beacons;
-	sinfo->filled |= BIT(NL80211_STA_INFO_BEACON_RX);
+	sinfo->filled |= BIT_ULL(NL80211_STA_INFO_BEACON_RX);
 	if (mvmvif->beacon_stats.avg_signal) {
 		/* firmware only reports a value after RXing a few beacons */
 		sinfo->rx_beacon_signal_avg = mvmvif->beacon_stats.avg_signal;
-		sinfo->filled |= BIT(NL80211_STA_INFO_BEACON_SIGNAL_AVG);
+		sinfo->filled |= BIT_ULL(NL80211_STA_INFO_BEACON_SIGNAL_AVG);
 	}
  unlock:
 	mutex_unlock(&mvm->mutex);
diff --git a/drivers/net/wireless/marvell/libertas/cfg.c b/drivers/net/wireless/marvell/libertas/cfg.c
index f99031c..57edfad 100644
--- a/drivers/net/wireless/marvell/libertas/cfg.c
+++ b/drivers/net/wireless/marvell/libertas/cfg.c
@@ -1559,10 +1559,10 @@ static int lbs_cfg_get_station(struct wiphy *wiphy, struct net_device *dev,
 	int ret;
 	size_t i;
 
-	sinfo->filled |= BIT(NL80211_STA_INFO_TX_BYTES) |
-			 BIT(NL80211_STA_INFO_TX_PACKETS) |
-			 BIT(NL80211_STA_INFO_RX_BYTES) |
-			 BIT(NL80211_STA_INFO_RX_PACKETS);
+	sinfo->filled |= BIT_ULL(NL80211_STA_INFO_TX_BYTES) |
+			 BIT_ULL(NL80211_STA_INFO_TX_PACKETS) |
+			 BIT_ULL(NL80211_STA_INFO_RX_BYTES) |
+			 BIT_ULL(NL80211_STA_INFO_RX_PACKETS);
 	sinfo->tx_bytes = priv->dev->stats.tx_bytes;
 	sinfo->tx_packets = priv->dev->stats.tx_packets;
 	sinfo->rx_bytes = priv->dev->stats.rx_bytes;
@@ -1572,14 +1572,14 @@ static int lbs_cfg_get_station(struct wiphy *wiphy, struct net_device *dev,
 	ret = lbs_get_rssi(priv, &signal, &noise);
 	if (ret == 0) {
 		sinfo->signal = signal;
-		sinfo->filled |= BIT(NL80211_STA_INFO_SIGNAL);
+		sinfo->filled |= BIT_ULL(NL80211_STA_INFO_SIGNAL);
 	}
 
 	/* Convert priv->cur_rate from hw_value to NL80211 value */
 	for (i = 0; i < ARRAY_SIZE(lbs_rates); i++) {
 		if (priv->cur_rate == lbs_rates[i].hw_value) {
 			sinfo->txrate.legacy = lbs_rates[i].bitrate;
-			sinfo->filled |= BIT(NL80211_STA_INFO_TX_BITRATE);
+			sinfo->filled |= BIT_ULL(NL80211_STA_INFO_TX_BITRATE);
 			break;
 		}
 	}
diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
index a67e2d6..d39f34d 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -1353,17 +1353,17 @@ mwifiex_dump_station_info(struct mwifiex_private *priv,
 {
 	u32 rate;
 
-	sinfo->filled = BIT(NL80211_STA_INFO_RX_BYTES) | BIT(NL80211_STA_INFO_TX_BYTES) |
-			BIT(NL80211_STA_INFO_RX_PACKETS) | BIT(NL80211_STA_INFO_TX_PACKETS) |
-			BIT(NL80211_STA_INFO_TX_BITRATE) |
-			BIT(NL80211_STA_INFO_SIGNAL) | BIT(NL80211_STA_INFO_SIGNAL_AVG);
+	sinfo->filled = BIT_ULL(NL80211_STA_INFO_RX_BYTES) | BIT_ULL(NL80211_STA_INFO_TX_BYTES) |
+			BIT_ULL(NL80211_STA_INFO_RX_PACKETS) | BIT_ULL(NL80211_STA_INFO_TX_PACKETS) |
+			BIT_ULL(NL80211_STA_INFO_TX_BITRATE) |
+			BIT_ULL(NL80211_STA_INFO_SIGNAL) | BIT_ULL(NL80211_STA_INFO_SIGNAL_AVG);
 
 	if (GET_BSS_ROLE(priv) == MWIFIEX_BSS_ROLE_UAP) {
 		if (!node)
 			return -ENOENT;
 
-		sinfo->filled |= BIT(NL80211_STA_INFO_INACTIVE_TIME) |
-				BIT(NL80211_STA_INFO_TX_FAILED);
+		sinfo->filled |= BIT_ULL(NL80211_STA_INFO_INACTIVE_TIME) |
+				BIT_ULL(NL80211_STA_INFO_TX_FAILED);
 		sinfo->inactive_time =
 			jiffies_to_msecs(jiffies - node->stats.last_rx);
 
@@ -1413,7 +1413,7 @@ mwifiex_dump_station_info(struct mwifiex_private *priv,
 	sinfo->txrate.legacy = rate * 5;
 
 	if (priv->bss_mode == NL80211_IFTYPE_STATION) {
-		sinfo->filled |= BIT(NL80211_STA_INFO_BSS_PARAM);
+		sinfo->filled |= BIT_ULL(NL80211_STA_INFO_BSS_PARAM);
 		sinfo->bss_param.flags = 0;
 		if (priv->curr_bss_params.bss_descriptor.cap_info_bitmap &
 						WLAN_CAPABILITY_SHORT_PREAMBLE)
diff --git a/drivers/net/wireless/quantenna/qtnfmac/commands.c b/drivers/net/wireless/quantenna/qtnfmac/commands.c
index 5eb1436..4c9c431 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/commands.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/commands.c
@@ -640,83 +640,83 @@ qtnf_cmd_sta_info_parse(struct station_info *sinfo,
 		return;
 
 	if (qtnf_sta_stat_avail(inactive_time, QLINK_STA_INFO_INACTIVE_TIME)) {
-		sinfo->filled |= BIT(NL80211_STA_INFO_INACTIVE_TIME);
+		sinfo->filled |= BIT_ULL(NL80211_STA_INFO_INACTIVE_TIME);
 		sinfo->inactive_time = le32_to_cpu(stats->inactive_time);
 	}
 
 	if (qtnf_sta_stat_avail(connected_time,
 				QLINK_STA_INFO_CONNECTED_TIME)) {
-		sinfo->filled |= BIT(NL80211_STA_INFO_CONNECTED_TIME);
+		sinfo->filled |= BIT_ULL(NL80211_STA_INFO_CONNECTED_TIME);
 		sinfo->connected_time = le32_to_cpu(stats->connected_time);
 	}
 
 	if (qtnf_sta_stat_avail(signal, QLINK_STA_INFO_SIGNAL)) {
-		sinfo->filled |= BIT(NL80211_STA_INFO_SIGNAL);
+		sinfo->filled |= BIT_ULL(NL80211_STA_INFO_SIGNAL);
 		sinfo->signal = stats->signal - QLINK_RSSI_OFFSET;
 	}
 
 	if (qtnf_sta_stat_avail(signal_avg, QLINK_STA_INFO_SIGNAL_AVG)) {
-		sinfo->filled |= BIT(NL80211_STA_INFO_SIGNAL_AVG);
+		sinfo->filled |= BIT_ULL(NL80211_STA_INFO_SIGNAL_AVG);
 		sinfo->signal_avg = stats->signal_avg - QLINK_RSSI_OFFSET;
 	}
 
 	if (qtnf_sta_stat_avail(rxrate, QLINK_STA_INFO_RX_BITRATE)) {
-		sinfo->filled |= BIT(NL80211_STA_INFO_RX_BITRATE);
+		sinfo->filled |= BIT_ULL(NL80211_STA_INFO_RX_BITRATE);
 		qtnf_sta_info_parse_rate(&sinfo->rxrate, &stats->rxrate);
 	}
 
 	if (qtnf_sta_stat_avail(txrate, QLINK_STA_INFO_TX_BITRATE)) {
-		sinfo->filled |= BIT(NL80211_STA_INFO_TX_BITRATE);
+		sinfo->filled |= BIT_ULL(NL80211_STA_INFO_TX_BITRATE);
 		qtnf_sta_info_parse_rate(&sinfo->txrate, &stats->txrate);
 	}
 
 	if (qtnf_sta_stat_avail(sta_flags, QLINK_STA_INFO_STA_FLAGS)) {
-		sinfo->filled |= BIT(NL80211_STA_INFO_STA_FLAGS);
+		sinfo->filled |= BIT_ULL(NL80211_STA_INFO_STA_FLAGS);
 		qtnf_sta_info_parse_flags(&sinfo->sta_flags, &stats->sta_flags);
 	}
 
 	if (qtnf_sta_stat_avail(rx_bytes, QLINK_STA_INFO_RX_BYTES)) {
-		sinfo->filled |= BIT(NL80211_STA_INFO_RX_BYTES);
+		sinfo->filled |= BIT_ULL(NL80211_STA_INFO_RX_BYTES);
 		sinfo->rx_bytes = le64_to_cpu(stats->rx_bytes);
 	}
 
 	if (qtnf_sta_stat_avail(tx_bytes, QLINK_STA_INFO_TX_BYTES)) {
-		sinfo->filled |= BIT(NL80211_STA_INFO_TX_BYTES);
+		sinfo->filled |= BIT_ULL(NL80211_STA_INFO_TX_BYTES);
 		sinfo->tx_bytes = le64_to_cpu(stats->tx_bytes);
 	}
 
 	if (qtnf_sta_stat_avail(rx_bytes, QLINK_STA_INFO_RX_BYTES64)) {
-		sinfo->filled |= BIT(NL80211_STA_INFO_RX_BYTES64);
+		sinfo->filled |= BIT_ULL(NL80211_STA_INFO_RX_BYTES64);
 		sinfo->rx_bytes = le64_to_cpu(stats->rx_bytes);
 	}
 
 	if (qtnf_sta_stat_avail(tx_bytes, QLINK_STA_INFO_TX_BYTES64)) {
-		sinfo->filled |= BIT(NL80211_STA_INFO_TX_BYTES64);
+		sinfo->filled |= BIT_ULL(NL80211_STA_INFO_TX_BYTES64);
 		sinfo->tx_bytes = le64_to_cpu(stats->tx_bytes);
 	}
 
 	if (qtnf_sta_stat_avail(rx_packets, QLINK_STA_INFO_RX_PACKETS)) {
-		sinfo->filled |= BIT(NL80211_STA_INFO_RX_PACKETS);
+		sinfo->filled |= BIT_ULL(NL80211_STA_INFO_RX_PACKETS);
 		sinfo->rx_packets = le32_to_cpu(stats->rx_packets);
 	}
 
 	if (qtnf_sta_stat_avail(tx_packets, QLINK_STA_INFO_TX_PACKETS)) {
-		sinfo->filled |= BIT(NL80211_STA_INFO_TX_PACKETS);
+		sinfo->filled |= BIT_ULL(NL80211_STA_INFO_TX_PACKETS);
 		sinfo->tx_packets = le32_to_cpu(stats->tx_packets);
 	}
 
 	if (qtnf_sta_stat_avail(rx_beacon, QLINK_STA_INFO_BEACON_RX)) {
-		sinfo->filled |= BIT(NL80211_STA_INFO_BEACON_RX);
+		sinfo->filled |= BIT_ULL(NL80211_STA_INFO_BEACON_RX);
 		sinfo->rx_beacon = le64_to_cpu(stats->rx_beacon);
 	}
 
 	if (qtnf_sta_stat_avail(rx_dropped_misc, QLINK_STA_INFO_RX_DROP_MISC)) {
-		sinfo->filled |= BIT(NL80211_STA_INFO_RX_DROP_MISC);
+		sinfo->filled |= BIT_ULL(NL80211_STA_INFO_RX_DROP_MISC);
 		sinfo->rx_dropped_misc = le32_to_cpu(stats->rx_dropped_misc);
 	}
 
 	if (qtnf_sta_stat_avail(tx_failed, QLINK_STA_INFO_TX_FAILED)) {
-		sinfo->filled |= BIT(NL80211_STA_INFO_TX_FAILED);
+		sinfo->filled |= BIT_ULL(NL80211_STA_INFO_TX_FAILED);
 		sinfo->tx_failed = le32_to_cpu(stats->tx_failed);
 	}
 
diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index 9935bd0..1650df6 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -2480,7 +2480,7 @@ static void rndis_fill_station_info(struct usbnet *usbdev,
 	ret = rndis_query_oid(usbdev, RNDIS_OID_GEN_LINK_SPEED, &linkspeed, &len);
 	if (ret == 0) {
 		sinfo->txrate.legacy = le32_to_cpu(linkspeed) / 1000;
-		sinfo->filled |= BIT(NL80211_STA_INFO_TX_BITRATE);
+		sinfo->filled |= BIT_ULL(NL80211_STA_INFO_TX_BITRATE);
 	}
 
 	len = sizeof(rssi);
@@ -2488,7 +2488,7 @@ static void rndis_fill_station_info(struct usbnet *usbdev,
 			      &rssi, &len);
 	if (ret == 0) {
 		sinfo->signal = level_to_qual(le32_to_cpu(rssi));
-		sinfo->filled |= BIT(NL80211_STA_INFO_SIGNAL);
+		sinfo->filled |= BIT_ULL(NL80211_STA_INFO_SIGNAL);
 	}
 }
 
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 3a51ab1..2c727f6 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -5727,7 +5727,7 @@ static void wlcore_op_sta_statistics(struct ieee80211_hw *hw,
 	if (ret < 0)
 		goto out_sleep;
 
-	sinfo->filled |= BIT(NL80211_STA_INFO_SIGNAL);
+	sinfo->filled |= BIT_ULL(NL80211_STA_INFO_SIGNAL);
 	sinfo->signal = rssi_dbm;
 
 out_sleep:
-- 
2.7.4
