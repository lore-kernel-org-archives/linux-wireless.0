Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:36828 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751193AbaLQN6J (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Dec 2014 08:58:09 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 7/9] cfg80211: remove enum station_info_flags
Date: Wed, 17 Dec 2014 14:57:57 +0100
Message-Id: <1418824679-31530-8-git-send-email-johannes@sipsolutions.net> (sfid-20141217_145822_645460_E899DBA1)
In-Reply-To: <1418824679-31530-1-git-send-email-johannes@sipsolutions.net>
References: <1418824679-31530-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This is really just duplicating the list of information that's
already available in the nl80211 attribute, so remove the list.
Two small changes are needed:
 * remove STATION_INFO_ASSOC_REQ_IES complete, but the length
   (assoc_req_ies_len) can be used instead
 * add NL80211_STA_INFO_RX_DROP_MISC which exists internally
   but not in nl80211 yet

This gets rid of the duplicate maintenance of the two lists.

Change-Id: I1031fd79dd3d4a1c9118f7b9db650570add2607b
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c         |  14 +--
 drivers/net/wireless/ath/ath6kl/main.c             |   1 -
 drivers/net/wireless/ath/wil6210/cfg80211.c        |  18 +--
 drivers/net/wireless/ath/wil6210/wmi.c             |   1 -
 drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c |  11 +-
 drivers/net/wireless/libertas/cfg.c                |  12 +-
 drivers/net/wireless/mwifiex/cfg80211.c            |  10 +-
 drivers/net/wireless/mwifiex/uap_event.c           |   1 -
 drivers/net/wireless/rndis_wlan.c                  |   4 +-
 drivers/net/wireless/ti/wlcore/main.c              |   2 +-
 drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c  |   9 +-
 drivers/staging/wlan-ng/cfg80211.c                 |   4 +-
 include/net/cfg80211.h                             |  77 +-----------
 include/uapi/linux/nl80211.h                       |   3 +
 net/mac80211/ethtool.c                             |   6 +-
 net/mac80211/sta_info.c                            |  80 ++++++-------
 net/wireless/nl80211.c                             | 133 ++++++++-------------
 17 files changed, 137 insertions(+), 249 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 7a5337877a0c..44dd6ef923cd 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -1799,20 +1799,20 @@ static int ath6kl_get_station(struct wiphy *wiphy, struct net_device *dev,
 
 	if (vif->target_stats.rx_byte) {
 		sinfo->rx_bytes = vif->target_stats.rx_byte;
-		sinfo->filled |= STATION_INFO_RX_BYTES64;
+		sinfo->filled |= BIT(NL80211_STA_INFO_RX_BYTES64);
 		sinfo->rx_packets = vif->target_stats.rx_pkt;
-		sinfo->filled |= STATION_INFO_RX_PACKETS;
+		sinfo->filled |= BIT(NL80211_STA_INFO_RX_PACKETS);
 	}
 
 	if (vif->target_stats.tx_byte) {
 		sinfo->tx_bytes = vif->target_stats.tx_byte;
-		sinfo->filled |= STATION_INFO_TX_BYTES64;
+		sinfo->filled |= BIT(NL80211_STA_INFO_TX_BYTES64);
 		sinfo->tx_packets = vif->target_stats.tx_pkt;
-		sinfo->filled |= STATION_INFO_TX_PACKETS;
+		sinfo->filled |= BIT(NL80211_STA_INFO_TX_PACKETS);
 	}
 
 	sinfo->signal = vif->target_stats.cs_rssi;
-	sinfo->filled |= STATION_INFO_SIGNAL;
+	sinfo->filled |= BIT(NL80211_STA_INFO_SIGNAL);
 
 	rate = vif->target_stats.tx_ucast_rate;
 
@@ -1844,12 +1844,12 @@ static int ath6kl_get_station(struct wiphy *wiphy, struct net_device *dev,
 		return 0;
 	}
 
-	sinfo->filled |= STATION_INFO_TX_BITRATE;
+	sinfo->filled |= BIT(NL80211_STA_INFO_TX_BITRATE);
 
 	if (test_bit(CONNECTED, &vif->flags) &&
 	    test_bit(DTIM_PERIOD_AVAIL, &vif->flags) &&
 	    vif->nw_type == INFRA_NETWORK) {
-		sinfo->filled |= STATION_INFO_BSS_PARAM;
+		sinfo->filled |= BIT(NL80211_STA_INFO_BSS_PARAM);
 		sinfo->bss_param.flags = 0;
 		sinfo->bss_param.dtim_period = vif->assoc_bss_dtim_period;
 		sinfo->bss_param.beacon_interval = vif->assoc_bss_beacon_int;
diff --git a/drivers/net/wireless/ath/ath6kl/main.c b/drivers/net/wireless/ath/ath6kl/main.c
index 933aef025698..b42ba46b5030 100644
--- a/drivers/net/wireless/ath/ath6kl/main.c
+++ b/drivers/net/wireless/ath/ath6kl/main.c
@@ -488,7 +488,6 @@ void ath6kl_connect_ap_mode_sta(struct ath6kl_vif *vif, u16 aid, u8 *mac_addr,
 
 	sinfo.assoc_req_ies = ies;
 	sinfo.assoc_req_ies_len = ies_len;
-	sinfo.filled |= STATION_INFO_ASSOC_REQ_IES;
 
 	cfg80211_new_sta(vif->ndev, mac_addr, &sinfo, GFP_KERNEL);
 
diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index 38332a6dfb3a..e72a95d1ced6 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -142,14 +142,14 @@ int wil_cid_fill_sinfo(struct wil6210_priv *wil, int cid,
 
 	sinfo->generation = wil->sinfo_gen;
 
-	sinfo->filled = STATION_INFO_RX_BYTES |
-			STATION_INFO_TX_BYTES |
-			STATION_INFO_RX_PACKETS |
-			STATION_INFO_TX_PACKETS |
-			STATION_INFO_RX_BITRATE |
-			STATION_INFO_TX_BITRATE |
-			STATION_INFO_RX_DROP_MISC |
-			STATION_INFO_TX_FAILED;
+	sinfo->filled = BIT(NL80211_STA_INFO_RX_BYTES) |
+			BIT(NL80211_STA_INFO_TX_BYTES) |
+			BIT(NL80211_STA_INFO_RX_PACKETS) |
+			BIT(NL80211_STA_INFO_TX_PACKETS) |
+			BIT(NL80211_STA_INFO_RX_BITRATE) |
+			BIT(NL80211_STA_INFO_TX_BITRATE) |
+			BIT(NL80211_STA_INFO_RX_DROP_MISC) |
+			BIT(NL80211_STA_INFO_TX_FAILED);
 
 	sinfo->txrate.flags = RATE_INFO_FLAGS_MCS | RATE_INFO_FLAGS_60G;
 	sinfo->txrate.mcs = le16_to_cpu(reply.evt.bf_mcs);
@@ -163,7 +163,7 @@ int wil_cid_fill_sinfo(struct wil6210_priv *wil, int cid,
 	sinfo->tx_failed = stats->tx_errors;
 
 	if (test_bit(wil_status_fwconnected, &wil->status)) {
-		sinfo->filled |= STATION_INFO_SIGNAL;
+		sinfo->filled |= BIT(NL80211_STA_INFO_SIGNAL);
 		sinfo->signal = reply.evt.sqi;
 	}
 
diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index 63476c86cd0e..899754920955 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -457,7 +457,6 @@ static void wmi_evt_connect(struct wil6210_priv *wil, int id, void *d, int len)
 		if (assoc_req_ie) {
 			sinfo.assoc_req_ies = assoc_req_ie;
 			sinfo.assoc_req_ies_len = assoc_req_ielen;
-			sinfo.filled |= STATION_INFO_ASSOC_REQ_IES;
 		}
 
 		cfg80211_new_sta(ndev, evt->bssid, &sinfo, GFP_KERNEL);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
index 3aecc5f48719..4a88b2381a68 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
@@ -2333,10 +2333,10 @@ brcmf_cfg80211_get_station(struct wiphy *wiphy, struct net_device *ndev,
 			brcmf_err("GET STA INFO failed, %d\n", err);
 			goto done;
 		}
-		sinfo->filled = STATION_INFO_INACTIVE_TIME;
+		sinfo->filled = BIT(NL80211_STA_INFO_INACTIVE_TIME);
 		sinfo->inactive_time = le32_to_cpu(sta_info_le.idle) * 1000;
 		if (le32_to_cpu(sta_info_le.flags) & BRCMF_STA_ASSOC) {
-			sinfo->filled |= STATION_INFO_CONNECTED_TIME;
+			sinfo->filled |= BIT(NL80211_STA_INFO_CONNECTED_TIME);
 			sinfo->connected_time = le32_to_cpu(sta_info_le.in);
 		}
 		brcmf_dbg(TRACE, "STA idle time : %d ms, connected time :%d sec\n",
@@ -2354,7 +2354,7 @@ brcmf_cfg80211_get_station(struct wiphy *wiphy, struct net_device *ndev,
 			brcmf_err("Could not get rate (%d)\n", err);
 			goto done;
 		} else {
-			sinfo->filled |= STATION_INFO_TX_BITRATE;
+			sinfo->filled |= BIT(NL80211_STA_INFO_TX_BITRATE);
 			sinfo->txrate.legacy = rate * 5;
 			brcmf_dbg(CONN, "Rate %d Mbps\n", rate / 2);
 		}
@@ -2369,7 +2369,7 @@ brcmf_cfg80211_get_station(struct wiphy *wiphy, struct net_device *ndev,
 				goto done;
 			} else {
 				rssi = le32_to_cpu(scb_val.val);
-				sinfo->filled |= STATION_INFO_SIGNAL;
+				sinfo->filled |= BIT(NL80211_STA_INFO_SIGNAL);
 				sinfo->signal = rssi;
 				brcmf_dbg(CONN, "RSSI %d dBm\n", rssi);
 			}
@@ -2396,7 +2396,7 @@ brcmf_cfg80211_get_station(struct wiphy *wiphy, struct net_device *ndev,
 				brcmf_dbg(CONN, "DTIM peroid %d\n",
 					  dtim_period);
 			}
-			sinfo->filled |= STATION_INFO_BSS_PARAM;
+			sinfo->filled |= BIT(NL80211_STA_INFO_BSS_PARAM);
 		}
 	} else
 		err = -EPERM;
@@ -4778,7 +4778,6 @@ brcmf_notify_connect_status_ap(struct brcmf_cfg80211_info *cfg,
 	if (((event == BRCMF_E_ASSOC_IND) || (event == BRCMF_E_REASSOC_IND)) &&
 	    (reason == BRCMF_E_STATUS_SUCCESS)) {
 		memset(&sinfo, 0, sizeof(sinfo));
-		sinfo.filled = STATION_INFO_ASSOC_REQ_IES;
 		if (!data) {
 			brcmf_err("No IEs present in ASSOC/REASSOC_IND");
 			return -EINVAL;
diff --git a/drivers/net/wireless/libertas/cfg.c b/drivers/net/wireless/libertas/cfg.c
index 34f09ef90bb3..a92985a6ea21 100644
--- a/drivers/net/wireless/libertas/cfg.c
+++ b/drivers/net/wireless/libertas/cfg.c
@@ -1616,10 +1616,10 @@ static int lbs_cfg_get_station(struct wiphy *wiphy, struct net_device *dev,
 
 	lbs_deb_enter(LBS_DEB_CFG80211);
 
-	sinfo->filled |= STATION_INFO_TX_BYTES |
-			 STATION_INFO_TX_PACKETS |
-			 STATION_INFO_RX_BYTES |
-			 STATION_INFO_RX_PACKETS;
+	sinfo->filled |= BIT(NL80211_STA_INFO_TX_BYTES) |
+			 BIT(NL80211_STA_INFO_TX_PACKETS) |
+			 BIT(NL80211_STA_INFO_RX_BYTES) |
+			 BIT(NL80211_STA_INFO_RX_PACKETS);
 	sinfo->tx_bytes = priv->dev->stats.tx_bytes;
 	sinfo->tx_packets = priv->dev->stats.tx_packets;
 	sinfo->rx_bytes = priv->dev->stats.rx_bytes;
@@ -1629,14 +1629,14 @@ static int lbs_cfg_get_station(struct wiphy *wiphy, struct net_device *dev,
 	ret = lbs_get_rssi(priv, &signal, &noise);
 	if (ret == 0) {
 		sinfo->signal = signal;
-		sinfo->filled |= STATION_INFO_SIGNAL;
+		sinfo->filled |= BIT(NL80211_STA_INFO_SIGNAL);
 	}
 
 	/* Convert priv->cur_rate from hw_value to NL80211 value */
 	for (i = 0; i < ARRAY_SIZE(lbs_rates); i++) {
 		if (priv->cur_rate == lbs_rates[i].hw_value) {
 			sinfo->txrate.legacy = lbs_rates[i].bitrate;
-			sinfo->filled |= STATION_INFO_TX_BITRATE;
+			sinfo->filled |= BIT(NL80211_STA_INFO_TX_BITRATE);
 			break;
 		}
 	}
diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 8bd446b69658..71312ff52703 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -910,10 +910,10 @@ mwifiex_dump_station_info(struct mwifiex_private *priv,
 {
 	u32 rate;
 
-	sinfo->filled = STATION_INFO_RX_BYTES | STATION_INFO_TX_BYTES |
-			STATION_INFO_RX_PACKETS | STATION_INFO_TX_PACKETS |
-			STATION_INFO_TX_BITRATE |
-			STATION_INFO_SIGNAL | STATION_INFO_SIGNAL_AVG;
+	sinfo->filled = BIT(NL80211_STA_INFO_RX_BYTES) | BIT(NL80211_STA_INFO_TX_BYTES) |
+			BIT(NL80211_STA_INFO_RX_PACKETS) | BIT(NL80211_STA_INFO_TX_PACKETS) |
+			BIT(NL80211_STA_INFO_TX_BITRATE) |
+			BIT(NL80211_STA_INFO_SIGNAL) | BIT(NL80211_STA_INFO_SIGNAL_AVG);
 
 	/* Get signal information from the firmware */
 	if (mwifiex_send_cmd(priv, HostCmd_CMD_RSSI_INFO,
@@ -944,7 +944,7 @@ mwifiex_dump_station_info(struct mwifiex_private *priv,
 	sinfo->txrate.legacy = rate * 5;
 
 	if (priv->bss_mode == NL80211_IFTYPE_STATION) {
-		sinfo->filled |= STATION_INFO_BSS_PARAM;
+		sinfo->filled |= BIT(NL80211_STA_INFO_BSS_PARAM);
 		sinfo->bss_param.flags = 0;
 		if (priv->curr_bss_params.bss_descriptor.cap_info_bitmap &
 						WLAN_CAPABILITY_SHORT_PREAMBLE)
diff --git a/drivers/net/wireless/mwifiex/uap_event.c b/drivers/net/wireless/mwifiex/uap_event.c
index c54a537e31fb..3b3a970e2086 100644
--- a/drivers/net/wireless/mwifiex/uap_event.c
+++ b/drivers/net/wireless/mwifiex/uap_event.c
@@ -68,7 +68,6 @@ int mwifiex_process_uap_event(struct mwifiex_private *priv)
 				len = ETH_ALEN;
 
 			if (len != -1) {
-				sinfo.filled = STATION_INFO_ASSOC_REQ_IES;
 				sinfo.assoc_req_ies = &event->data[len];
 				len = (u8 *)sinfo.assoc_req_ies -
 				      (u8 *)&event->frame_control;
diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index 1a4facd1fbf3..60d44ce9c017 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -2478,7 +2478,7 @@ static void rndis_fill_station_info(struct usbnet *usbdev,
 	ret = rndis_query_oid(usbdev, RNDIS_OID_GEN_LINK_SPEED, &linkspeed, &len);
 	if (ret == 0) {
 		sinfo->txrate.legacy = le32_to_cpu(linkspeed) / 1000;
-		sinfo->filled |= STATION_INFO_TX_BITRATE;
+		sinfo->filled |= BIT(NL80211_STA_INFO_TX_BITRATE);
 	}
 
 	len = sizeof(rssi);
@@ -2486,7 +2486,7 @@ static void rndis_fill_station_info(struct usbnet *usbdev,
 			      &rssi, &len);
 	if (ret == 0) {
 		sinfo->signal = level_to_qual(le32_to_cpu(rssi));
-		sinfo->filled |= STATION_INFO_SIGNAL;
+		sinfo->filled |= BIT(NL80211_STA_INFO_SIGNAL);
 	}
 }
 
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 8d11b0ca412c..a2133b1fd631 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -5401,7 +5401,7 @@ static void wlcore_op_sta_statistics(struct ieee80211_hw *hw,
 	if (ret < 0)
 		goto out_sleep;
 
-	sinfo->filled |= STATION_INFO_SIGNAL;
+	sinfo->filled |= BIT(NL80211_STA_INFO_SIGNAL);
 	sinfo->signal = rssi_dbm;
 
 out_sleep:
diff --git a/drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c b/drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c
index 3d26955da724..c76874d72a22 100644
--- a/drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c
+++ b/drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c
@@ -1092,17 +1092,17 @@ static int cfg80211_rtw_get_station(struct wiphy *wiphy,
 			goto exit;
 		}
 
-		sinfo->filled |= STATION_INFO_SIGNAL;
+		sinfo->filled |= BIT(NL80211_STA_INFO_SIGNAL);
 		sinfo->signal = translate_percentage_to_dbm(padapter->recvpriv.
 							    signal_strength);
 
-		sinfo->filled |= STATION_INFO_TX_BITRATE;
+		sinfo->filled |= BIT(NL80211_STA_INFO_TX_BITRATE);
 		sinfo->txrate.legacy = rtw_get_cur_max_rate(padapter);
 
-		sinfo->filled |= STATION_INFO_RX_PACKETS;
+		sinfo->filled |= BIT(NL80211_STA_INFO_RX_PACKETS);
 		sinfo->rx_packets = sta_rx_data_pkts(psta);
 
-		sinfo->filled |= STATION_INFO_TX_PACKETS;
+		sinfo->filled |= BIT(NL80211_STA_INFO_TX_PACKETS);
 		sinfo->tx_packets = psta->sta_stats.tx_pkts;
 	}
 
@@ -2365,7 +2365,6 @@ void rtw_cfg80211_indicate_sta_assoc(struct rtw_adapter *padapter,
 					     u.reassoc_req.variable);
 
 		sinfo.filled = 0;
-		sinfo.filled = STATION_INFO_ASSOC_REQ_IES;
 		sinfo.assoc_req_ies = pmgmt_frame + ie_offset;
 		sinfo.assoc_req_ies_len = frame_len - ie_offset;
 		cfg80211_new_sta(ndev, hdr->addr2, &sinfo, GFP_ATOMIC);
diff --git a/drivers/staging/wlan-ng/cfg80211.c b/drivers/staging/wlan-ng/cfg80211.c
index 8942dcb44180..7c87aecf4744 100644
--- a/drivers/staging/wlan-ng/cfg80211.c
+++ b/drivers/staging/wlan-ng/cfg80211.c
@@ -325,9 +325,9 @@ static int prism2_get_station(struct wiphy *wiphy, struct net_device *dev,
 
 	if (result == 0) {
 		sinfo->txrate.legacy = quality.txrate.data;
-		sinfo->filled |= STATION_INFO_TX_BITRATE;
+		sinfo->filled |= BIT(NL80211_STA_INFO_TX_BITRATE);
 		sinfo->signal = quality.level.data;
-		sinfo->filled |= STATION_INFO_SIGNAL;
+		sinfo->filled |= BIT(NL80211_STA_INFO_SIGNAL);
 	}
 
 	return result;
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 8909a3fb6b35..4f5aa80edcf1 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -865,75 +865,6 @@ int cfg80211_check_station_change(struct wiphy *wiphy,
 				  enum cfg80211_station_type statype);
 
 /**
- * enum station_info_flags - station information flags
- *
- * Used by the driver to indicate which info in &struct station_info
- * it has filled in during get_station() or dump_station().
- *
- * @STATION_INFO_INACTIVE_TIME: @inactive_time filled
- * @STATION_INFO_RX_BYTES: @rx_bytes filled
- * @STATION_INFO_TX_BYTES: @tx_bytes filled
- * @STATION_INFO_RX_BYTES64: @rx_bytes filled with 64-bit value
- * @STATION_INFO_TX_BYTES64: @tx_bytes filled with 64-bit value
- * @STATION_INFO_LLID: @llid filled
- * @STATION_INFO_PLID: @plid filled
- * @STATION_INFO_PLINK_STATE: @plink_state filled
- * @STATION_INFO_SIGNAL: @signal filled
- * @STATION_INFO_TX_BITRATE: @txrate fields are filled
- *	(tx_bitrate, tx_bitrate_flags and tx_bitrate_mcs)
- * @STATION_INFO_RX_PACKETS: @rx_packets filled with 32-bit value
- * @STATION_INFO_TX_PACKETS: @tx_packets filled with 32-bit value
- * @STATION_INFO_TX_RETRIES: @tx_retries filled
- * @STATION_INFO_TX_FAILED: @tx_failed filled
- * @STATION_INFO_RX_DROP_MISC: @rx_dropped_misc filled
- * @STATION_INFO_SIGNAL_AVG: @signal_avg filled
- * @STATION_INFO_RX_BITRATE: @rxrate fields are filled
- * @STATION_INFO_BSS_PARAM: @bss_param filled
- * @STATION_INFO_CONNECTED_TIME: @connected_time filled
- * @STATION_INFO_ASSOC_REQ_IES: @assoc_req_ies filled
- * @STATION_INFO_STA_FLAGS: @sta_flags filled
- * @STATION_INFO_BEACON_LOSS_COUNT: @beacon_loss_count filled
- * @STATION_INFO_T_OFFSET: @t_offset filled
- * @STATION_INFO_LOCAL_PM: @local_pm filled
- * @STATION_INFO_PEER_PM: @peer_pm filled
- * @STATION_INFO_NONPEER_PM: @nonpeer_pm filled
- * @STATION_INFO_CHAIN_SIGNAL: @chain_signal filled
- * @STATION_INFO_CHAIN_SIGNAL_AVG: @chain_signal_avg filled
- * @STATION_INFO_EXPECTED_THROUGHPUT: @expected_throughput filled
- */
-enum station_info_flags {
-	STATION_INFO_INACTIVE_TIME		= BIT(0),
-	STATION_INFO_RX_BYTES			= BIT(1),
-	STATION_INFO_TX_BYTES			= BIT(2),
-	STATION_INFO_LLID			= BIT(3),
-	STATION_INFO_PLID			= BIT(4),
-	STATION_INFO_PLINK_STATE		= BIT(5),
-	STATION_INFO_SIGNAL			= BIT(6),
-	STATION_INFO_TX_BITRATE			= BIT(7),
-	STATION_INFO_RX_PACKETS			= BIT(8),
-	STATION_INFO_TX_PACKETS			= BIT(9),
-	STATION_INFO_TX_RETRIES			= BIT(10),
-	STATION_INFO_TX_FAILED			= BIT(11),
-	STATION_INFO_RX_DROP_MISC		= BIT(12),
-	STATION_INFO_SIGNAL_AVG			= BIT(13),
-	STATION_INFO_RX_BITRATE			= BIT(14),
-	STATION_INFO_BSS_PARAM			= BIT(15),
-	STATION_INFO_CONNECTED_TIME		= BIT(16),
-	STATION_INFO_ASSOC_REQ_IES		= BIT(17),
-	STATION_INFO_STA_FLAGS			= BIT(18),
-	STATION_INFO_BEACON_LOSS_COUNT		= BIT(19),
-	STATION_INFO_T_OFFSET			= BIT(20),
-	STATION_INFO_LOCAL_PM			= BIT(21),
-	STATION_INFO_PEER_PM			= BIT(22),
-	STATION_INFO_NONPEER_PM			= BIT(23),
-	STATION_INFO_RX_BYTES64			= BIT(24),
-	STATION_INFO_TX_BYTES64			= BIT(25),
-	STATION_INFO_CHAIN_SIGNAL		= BIT(26),
-	STATION_INFO_CHAIN_SIGNAL_AVG		= BIT(27),
-	STATION_INFO_EXPECTED_THROUGHPUT	= BIT(28),
-};
-
-/**
  * enum station_info_rate_flags - bitrate info flags
  *
  * Used by the driver to indicate the specific rate transmission
@@ -1014,7 +945,8 @@ struct sta_bss_parameters {
  *
  * Station information filled by driver for get_station() and dump_station.
  *
- * @filled: bitflag of flags from &enum station_info_flags
+ * @filled: bitflag of flags using the bits of &enum nl80211_sta_info to
+ *	indicate the relevant values in this struct for them
  * @connected_time: time(in secs) since a station is last connected
  * @inactive_time: time since last station activity (tx/rx) in milliseconds
  * @rx_bytes: bytes received from this station
@@ -1093,11 +1025,6 @@ struct station_info {
 	enum nl80211_mesh_power_mode nonpeer_pm;
 
 	u32 expected_throughput;
-
-	/*
-	 * Note: Add a new enum station_info_flags value for each new field and
-	 * use it to check which fields are initialized.
-	 */
 };
 
 /**
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 1ddd067d19ed..c747657b035a 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -2354,6 +2354,8 @@ enum nl80211_sta_bss_param {
  *	Same format as NL80211_STA_INFO_CHAIN_SIGNAL.
  * @NL80211_STA_EXPECTED_THROUGHPUT: expected throughput considering also the
  *	802.11 header (u32, kbps)
+ * @NL80211_STA_INFO_RX_DROP_MISC: RX packets dropped for unspecified reasons
+ *	(u64)
  * @__NL80211_STA_INFO_AFTER_LAST: internal
  * @NL80211_STA_INFO_MAX: highest possible station info attribute
  */
@@ -2386,6 +2388,7 @@ enum nl80211_sta_info {
 	NL80211_STA_INFO_CHAIN_SIGNAL,
 	NL80211_STA_INFO_CHAIN_SIGNAL_AVG,
 	NL80211_STA_INFO_EXPECTED_THROUGHPUT,
+	NL80211_STA_INFO_RX_DROP_MISC,
 
 	/* keep last */
 	__NL80211_STA_INFO_AFTER_LAST,
diff --git a/net/mac80211/ethtool.c b/net/mac80211/ethtool.c
index eea742710c0a..52bcea6ad9e8 100644
--- a/net/mac80211/ethtool.c
+++ b/net/mac80211/ethtool.c
@@ -117,16 +117,16 @@ static void ieee80211_get_stats(struct net_device *dev,
 		data[i++] = sta->sta_state;
 
 
-		if (sinfo.filled & STATION_INFO_TX_BITRATE)
+		if (sinfo.filled & BIT(NL80211_STA_INFO_TX_BITRATE))
 			data[i] = 100000 *
 				cfg80211_calculate_bitrate(&sinfo.txrate);
 		i++;
-		if (sinfo.filled & STATION_INFO_RX_BITRATE)
+		if (sinfo.filled & BIT(NL80211_STA_INFO_RX_BITRATE))
 			data[i] = 100000 *
 				cfg80211_calculate_bitrate(&sinfo.rxrate);
 		i++;
 
-		if (sinfo.filled & STATION_INFO_SIGNAL_AVG)
+		if (sinfo.filled & BIT(NL80211_STA_INFO_SIGNAL_AVG))
 			data[i] = (u8)sinfo.signal_avg;
 		i++;
 	} else {
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 967b42eae5c2..64b53b943d98 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -1756,51 +1756,51 @@ void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 
 	drv_sta_statistics(local, sdata, &sta->sta, sinfo);
 
-	sinfo->filled |= STATION_INFO_INACTIVE_TIME |
-			 STATION_INFO_STA_FLAGS |
-			 STATION_INFO_BSS_PARAM |
-			 STATION_INFO_CONNECTED_TIME |
-			 STATION_INFO_RX_DROP_MISC |
-			 STATION_INFO_BEACON_LOSS_COUNT;
+	sinfo->filled |= BIT(NL80211_STA_INFO_INACTIVE_TIME) |
+			 BIT(NL80211_STA_INFO_STA_FLAGS) |
+			 BIT(NL80211_STA_INFO_BSS_PARAM) |
+			 BIT(NL80211_STA_INFO_CONNECTED_TIME) |
+			 BIT(NL80211_STA_INFO_RX_DROP_MISC) |
+			 BIT(NL80211_STA_INFO_BEACON_LOSS);
 
 	ktime_get_ts(&uptime);
 	sinfo->connected_time = uptime.tv_sec - sta->last_connected;
 	sinfo->inactive_time = jiffies_to_msecs(jiffies - sta->last_rx);
 
-	if (!(sinfo->filled & (STATION_INFO_TX_BYTES64 |
-			       STATION_INFO_TX_BYTES))) {
+	if (!(sinfo->filled & (BIT(NL80211_STA_INFO_TX_BYTES64) |
+			       BIT(NL80211_STA_INFO_TX_BYTES)))) {
 		sinfo->tx_bytes = 0;
 		for (ac = 0; ac < IEEE80211_NUM_ACS; ac++)
 			sinfo->tx_bytes += sta->tx_bytes[ac];
-		sinfo->filled |= STATION_INFO_TX_BYTES64;
+		sinfo->filled |= BIT(NL80211_STA_INFO_TX_BYTES64);
 	}
 
-	if (!(sinfo->filled & STATION_INFO_TX_PACKETS)) {
+	if (!(sinfo->filled & BIT(NL80211_STA_INFO_TX_PACKETS))) {
 		sinfo->tx_packets = 0;
 		for (ac = 0; ac < IEEE80211_NUM_ACS; ac++)
 			sinfo->tx_packets += sta->tx_packets[ac];
-		sinfo->filled |= STATION_INFO_TX_PACKETS;
+		sinfo->filled |= BIT(NL80211_STA_INFO_TX_PACKETS);
 	}
 
-	if (!(sinfo->filled & (STATION_INFO_RX_BYTES64 |
-			       STATION_INFO_RX_BYTES))) {
+	if (!(sinfo->filled & (BIT(NL80211_STA_INFO_RX_BYTES64) |
+			       BIT(NL80211_STA_INFO_RX_BYTES)))) {
 		sinfo->rx_bytes = sta->rx_bytes;
-		sinfo->filled |= STATION_INFO_RX_BYTES64;
+		sinfo->filled |= BIT(NL80211_STA_INFO_RX_BYTES64);
 	}
 
-	if (!(sinfo->filled & STATION_INFO_RX_PACKETS)) {
+	if (!(sinfo->filled & BIT(NL80211_STA_INFO_RX_PACKETS))) {
 		sinfo->rx_packets = sta->rx_packets;
-		sinfo->filled |= STATION_INFO_RX_PACKETS;
+		sinfo->filled |= BIT(NL80211_STA_INFO_RX_PACKETS);
 	}
 
-	if (!(sinfo->filled & STATION_INFO_TX_RETRIES)) {
+	if (!(sinfo->filled & BIT(NL80211_STA_INFO_TX_RETRIES))) {
 		sinfo->tx_retries = sta->tx_retry_count;
-		sinfo->filled |= STATION_INFO_TX_RETRIES;
+		sinfo->filled |= BIT(NL80211_STA_INFO_TX_RETRIES);
 	}
 
-	if (!(sinfo->filled & STATION_INFO_TX_FAILED)) {
+	if (!(sinfo->filled & BIT(NL80211_STA_INFO_TX_FAILED))) {
 		sinfo->tx_failed = sta->tx_retry_failed;
-		sinfo->filled |= STATION_INFO_TX_FAILED;
+		sinfo->filled |= BIT(NL80211_STA_INFO_TX_FAILED);
 	}
 
 	sinfo->rx_dropped_misc = sta->rx_dropped;
@@ -1808,22 +1808,22 @@ void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 
 	if ((sta->local->hw.flags & IEEE80211_HW_SIGNAL_DBM) ||
 	    (sta->local->hw.flags & IEEE80211_HW_SIGNAL_UNSPEC)) {
-		if (!(sinfo->filled & STATION_INFO_SIGNAL)) {
+		if (!(sinfo->filled & BIT(NL80211_STA_INFO_SIGNAL))) {
 			sinfo->signal = (s8)sta->last_signal;
-			sinfo->filled |= STATION_INFO_SIGNAL;
+			sinfo->filled |= BIT(NL80211_STA_INFO_SIGNAL);
 		}
 
-		if (!(sinfo->filled & STATION_INFO_SIGNAL_AVG)) {
+		if (!(sinfo->filled & BIT(NL80211_STA_INFO_SIGNAL_AVG))) {
 			sinfo->signal_avg = (s8) -ewma_read(&sta->avg_signal);
-			sinfo->filled |= STATION_INFO_SIGNAL_AVG;
+			sinfo->filled |= BIT(NL80211_STA_INFO_SIGNAL_AVG);
 		}
 	}
 
 	if (sta->chains &&
-	    !(sinfo->filled & (STATION_INFO_CHAIN_SIGNAL |
-			       STATION_INFO_CHAIN_SIGNAL_AVG))) {
-		sinfo->filled |= STATION_INFO_CHAIN_SIGNAL |
-				 STATION_INFO_CHAIN_SIGNAL_AVG;
+	    !(sinfo->filled & (BIT(NL80211_STA_INFO_CHAIN_SIGNAL) |
+			       BIT(NL80211_STA_INFO_CHAIN_SIGNAL_AVG)))) {
+		sinfo->filled |= BIT(NL80211_STA_INFO_CHAIN_SIGNAL) |
+				 BIT(NL80211_STA_INFO_CHAIN_SIGNAL_AVG);
 
 		sinfo->chains = sta->chains;
 		for (i = 0; i < ARRAY_SIZE(sinfo->chain_signal); i++) {
@@ -1833,30 +1833,30 @@ void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 		}
 	}
 
-	if (!(sinfo->filled & STATION_INFO_TX_BITRATE)) {
+	if (!(sinfo->filled & BIT(NL80211_STA_INFO_TX_BITRATE))) {
 		sta_set_rate_info_tx(sta, &sta->last_tx_rate, &sinfo->txrate);
-		sinfo->filled |= STATION_INFO_TX_BITRATE;
+		sinfo->filled |= BIT(NL80211_STA_INFO_TX_BITRATE);
 	}
 
-	if (!(sinfo->filled & STATION_INFO_RX_BITRATE)) {
+	if (!(sinfo->filled & BIT(NL80211_STA_INFO_RX_BITRATE))) {
 		sta_set_rate_info_rx(sta, &sinfo->rxrate);
-		sinfo->filled |= STATION_INFO_RX_BITRATE;
+		sinfo->filled |= BIT(NL80211_STA_INFO_RX_BITRATE);
 	}
 
 	if (ieee80211_vif_is_mesh(&sdata->vif)) {
 #ifdef CONFIG_MAC80211_MESH
-		sinfo->filled |= STATION_INFO_LLID |
-				 STATION_INFO_PLID |
-				 STATION_INFO_PLINK_STATE |
-				 STATION_INFO_LOCAL_PM |
-				 STATION_INFO_PEER_PM |
-				 STATION_INFO_NONPEER_PM;
+		sinfo->filled |= BIT(NL80211_STA_INFO_LLID) |
+				 BIT(NL80211_STA_INFO_PLID) |
+				 BIT(NL80211_STA_INFO_PLINK_STATE) |
+				 BIT(NL80211_STA_INFO_LOCAL_PM) |
+				 BIT(NL80211_STA_INFO_PEER_PM) |
+				 BIT(NL80211_STA_INFO_NONPEER_PM);
 
 		sinfo->llid = sta->llid;
 		sinfo->plid = sta->plid;
 		sinfo->plink_state = sta->plink_state;
 		if (test_sta_flag(sta, WLAN_STA_TOFFSET_KNOWN)) {
-			sinfo->filled |= STATION_INFO_T_OFFSET;
+			sinfo->filled |= BIT(NL80211_STA_INFO_T_OFFSET);
 			sinfo->t_offset = sta->t_offset;
 		}
 		sinfo->local_pm = sta->local_pm;
@@ -1905,7 +1905,7 @@ void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 		thr = drv_get_expected_throughput(local, &sta->sta);
 
 	if (thr != 0) {
-		sinfo->filled |= STATION_INFO_EXPECTED_THROUGHPUT;
+		sinfo->filled |= BIT(NL80211_STA_INFO_EXPECTED_THROUGHPUT);
 		sinfo->expected_throughput = thr;
 	}
 }
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index c34a66e9e5a5..906f9384a7cf 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3666,115 +3666,77 @@ static int nl80211_send_station(struct sk_buff *msg, u32 cmd, u32 portid,
 	sinfoattr = nla_nest_start(msg, NL80211_ATTR_STA_INFO);
 	if (!sinfoattr)
 		goto nla_put_failure;
-	if ((sinfo->filled & STATION_INFO_CONNECTED_TIME) &&
-	    nla_put_u32(msg, NL80211_STA_INFO_CONNECTED_TIME,
-			sinfo->connected_time))
-		goto nla_put_failure;
-	if ((sinfo->filled & STATION_INFO_INACTIVE_TIME) &&
-	    nla_put_u32(msg, NL80211_STA_INFO_INACTIVE_TIME,
-			sinfo->inactive_time))
-		goto nla_put_failure;
-	if ((sinfo->filled & (STATION_INFO_RX_BYTES |
-			      STATION_INFO_RX_BYTES64)) &&
+
+#define PUT_SINFO(attr, memb, type) do {				\
+	if (sinfo->filled & BIT(NL80211_STA_INFO_ ## attr) &&		\
+	    nla_put_ ## type(msg, NL80211_STA_INFO_ ## attr,		\
+			     sinfo->memb))				\
+		goto nla_put_failure;					\
+	} while (0)
+
+	PUT_SINFO(CONNECTED_TIME, connected_time, u32);
+	PUT_SINFO(INACTIVE_TIME, inactive_time, u32);
+
+	if (sinfo->filled & (BIT(NL80211_STA_INFO_RX_BYTES) |
+			     BIT(NL80211_STA_INFO_RX_BYTES64)) &&
 	    nla_put_u32(msg, NL80211_STA_INFO_RX_BYTES,
 			(u32)sinfo->rx_bytes))
 		goto nla_put_failure;
-	if ((sinfo->filled & (STATION_INFO_TX_BYTES |
-			      STATION_INFO_TX_BYTES64)) &&
+
+	if (sinfo->filled & (BIT(NL80211_STA_INFO_TX_BYTES) |
+			     BIT(NL80211_STA_INFO_TX_BYTES64)) &&
 	    nla_put_u32(msg, NL80211_STA_INFO_TX_BYTES,
 			(u32)sinfo->tx_bytes))
 		goto nla_put_failure;
-	if ((sinfo->filled & STATION_INFO_RX_BYTES64) &&
-	    nla_put_u64(msg, NL80211_STA_INFO_RX_BYTES64,
-			sinfo->rx_bytes))
-		goto nla_put_failure;
-	if ((sinfo->filled & STATION_INFO_TX_BYTES64) &&
-	    nla_put_u64(msg, NL80211_STA_INFO_TX_BYTES64,
-			sinfo->tx_bytes))
-		goto nla_put_failure;
-	if ((sinfo->filled & STATION_INFO_LLID) &&
-	    nla_put_u16(msg, NL80211_STA_INFO_LLID, sinfo->llid))
-		goto nla_put_failure;
-	if ((sinfo->filled & STATION_INFO_PLID) &&
-	    nla_put_u16(msg, NL80211_STA_INFO_PLID, sinfo->plid))
-		goto nla_put_failure;
-	if ((sinfo->filled & STATION_INFO_PLINK_STATE) &&
-	    nla_put_u8(msg, NL80211_STA_INFO_PLINK_STATE,
-		       sinfo->plink_state))
-		goto nla_put_failure;
+
+	PUT_SINFO(RX_BYTES64, rx_bytes, u64);
+	PUT_SINFO(TX_BYTES64, tx_bytes, u64);
+	PUT_SINFO(LLID, llid, u16);
+	PUT_SINFO(PLID, plid, u16);
+	PUT_SINFO(PLINK_STATE, plink_state, u8);
+
 	switch (rdev->wiphy.signal_type) {
 	case CFG80211_SIGNAL_TYPE_MBM:
-		if ((sinfo->filled & STATION_INFO_SIGNAL) &&
-		    nla_put_u8(msg, NL80211_STA_INFO_SIGNAL,
-			       sinfo->signal))
-			goto nla_put_failure;
-		if ((sinfo->filled & STATION_INFO_SIGNAL_AVG) &&
-		    nla_put_u8(msg, NL80211_STA_INFO_SIGNAL_AVG,
-			       sinfo->signal_avg))
-			goto nla_put_failure;
+		PUT_SINFO(SIGNAL, signal, u8);
+		PUT_SINFO(SIGNAL_AVG, signal_avg, u8);
 		break;
 	default:
 		break;
 	}
-	if (sinfo->filled & STATION_INFO_CHAIN_SIGNAL) {
+	if (sinfo->filled & BIT(NL80211_STA_INFO_CHAIN_SIGNAL)) {
 		if (!nl80211_put_signal(msg, sinfo->chains,
 					sinfo->chain_signal,
 					NL80211_STA_INFO_CHAIN_SIGNAL))
 			goto nla_put_failure;
 	}
-	if (sinfo->filled & STATION_INFO_CHAIN_SIGNAL_AVG) {
+	if (sinfo->filled & BIT(NL80211_STA_INFO_CHAIN_SIGNAL_AVG)) {
 		if (!nl80211_put_signal(msg, sinfo->chains,
 					sinfo->chain_signal_avg,
 					NL80211_STA_INFO_CHAIN_SIGNAL_AVG))
 			goto nla_put_failure;
 	}
-	if (sinfo->filled & STATION_INFO_TX_BITRATE) {
+	if (sinfo->filled & BIT(NL80211_STA_INFO_TX_BITRATE)) {
 		if (!nl80211_put_sta_rate(msg, &sinfo->txrate,
 					  NL80211_STA_INFO_TX_BITRATE))
 			goto nla_put_failure;
 	}
-	if (sinfo->filled & STATION_INFO_RX_BITRATE) {
+	if (sinfo->filled & BIT(NL80211_STA_INFO_RX_BITRATE)) {
 		if (!nl80211_put_sta_rate(msg, &sinfo->rxrate,
 					  NL80211_STA_INFO_RX_BITRATE))
 			goto nla_put_failure;
 	}
-	if ((sinfo->filled & STATION_INFO_RX_PACKETS) &&
-	    nla_put_u32(msg, NL80211_STA_INFO_RX_PACKETS,
-			sinfo->rx_packets))
-		goto nla_put_failure;
-	if ((sinfo->filled & STATION_INFO_TX_PACKETS) &&
-	    nla_put_u32(msg, NL80211_STA_INFO_TX_PACKETS,
-			sinfo->tx_packets))
-		goto nla_put_failure;
-	if ((sinfo->filled & STATION_INFO_TX_RETRIES) &&
-	    nla_put_u32(msg, NL80211_STA_INFO_TX_RETRIES,
-			sinfo->tx_retries))
-		goto nla_put_failure;
-	if ((sinfo->filled & STATION_INFO_TX_FAILED) &&
-	    nla_put_u32(msg, NL80211_STA_INFO_TX_FAILED,
-			sinfo->tx_failed))
-		goto nla_put_failure;
-	if ((sinfo->filled & STATION_INFO_EXPECTED_THROUGHPUT) &&
-	    nla_put_u32(msg, NL80211_STA_INFO_EXPECTED_THROUGHPUT,
-			sinfo->expected_throughput))
-		goto nla_put_failure;
-	if ((sinfo->filled & STATION_INFO_BEACON_LOSS_COUNT) &&
-	    nla_put_u32(msg, NL80211_STA_INFO_BEACON_LOSS,
-			sinfo->beacon_loss_count))
-		goto nla_put_failure;
-	if ((sinfo->filled & STATION_INFO_LOCAL_PM) &&
-	    nla_put_u32(msg, NL80211_STA_INFO_LOCAL_PM,
-			sinfo->local_pm))
-		goto nla_put_failure;
-	if ((sinfo->filled & STATION_INFO_PEER_PM) &&
-	    nla_put_u32(msg, NL80211_STA_INFO_PEER_PM,
-			sinfo->peer_pm))
-		goto nla_put_failure;
-	if ((sinfo->filled & STATION_INFO_NONPEER_PM) &&
-	    nla_put_u32(msg, NL80211_STA_INFO_NONPEER_PM,
-			sinfo->nonpeer_pm))
-		goto nla_put_failure;
-	if (sinfo->filled & STATION_INFO_BSS_PARAM) {
+
+	PUT_SINFO(RX_PACKETS, rx_packets, u32);
+	PUT_SINFO(TX_PACKETS, tx_packets, u32);
+	PUT_SINFO(TX_RETRIES, tx_retries, u32);
+	PUT_SINFO(TX_FAILED, tx_failed, u32);
+	PUT_SINFO(EXPECTED_THROUGHPUT, expected_throughput, u32);
+	PUT_SINFO(BEACON_LOSS, beacon_loss_count, u32);
+	PUT_SINFO(LOCAL_PM, local_pm, u32);
+	PUT_SINFO(PEER_PM, peer_pm, u32);
+	PUT_SINFO(NONPEER_PM, nonpeer_pm, u32);
+
+	if (sinfo->filled & BIT(NL80211_STA_INFO_BSS_PARAM)) {
 		bss_param = nla_nest_start(msg, NL80211_STA_INFO_BSS_PARAM);
 		if (!bss_param)
 			goto nla_put_failure;
@@ -3793,18 +3755,19 @@ static int nl80211_send_station(struct sk_buff *msg, u32 cmd, u32 portid,
 
 		nla_nest_end(msg, bss_param);
 	}
-	if ((sinfo->filled & STATION_INFO_STA_FLAGS) &&
+	if ((sinfo->filled & BIT(NL80211_STA_INFO_STA_FLAGS)) &&
 	    nla_put(msg, NL80211_STA_INFO_STA_FLAGS,
 		    sizeof(struct nl80211_sta_flag_update),
 		    &sinfo->sta_flags))
 		goto nla_put_failure;
-	if ((sinfo->filled & STATION_INFO_T_OFFSET) &&
-		nla_put_u64(msg, NL80211_STA_INFO_T_OFFSET,
-			    sinfo->t_offset))
-		goto nla_put_failure;
+
+	PUT_SINFO(T_OFFSET, t_offset, u64);
+	PUT_SINFO(RX_DROP_MISC, rx_dropped_misc, u64);
+
+#undef PUT_SINFO
 	nla_nest_end(msg, sinfoattr);
 
-	if ((sinfo->filled & STATION_INFO_ASSOC_REQ_IES) &&
+	if (sinfo->assoc_req_ies_len &&
 	    nla_put(msg, NL80211_ATTR_IE, sinfo->assoc_req_ies_len,
 		    sinfo->assoc_req_ies))
 		goto nla_put_failure;
-- 
2.1.1

