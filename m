Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:22634 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750807AbeAPOCr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 Jan 2018 09:02:47 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 01/13] staging: wilc1000: rename elements of wilc_priv struct to avoid using camelCase
Date: Tue, 16 Jan 2018 19:32:19 +0530
Message-ID: <1516111351-5353-2-git-send-email-ajay.kathat@microchip.com> (sfid-20180116_150252_585444_94153D4A)
In-Reply-To: <1516111351-5353-1-git-send-email-ajay.kathat@microchip.com>
References: <1516111351-5353-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is cleanup patch, to avoid the use of camelCase for "wilc_priv"
structure member variables.
The changes fix the camelCase issue reported by checkpatch.pl script.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 90 +++++++++++------------
 drivers/staging/wilc1000/wilc_wfi_netdevice.h     | 16 ++--
 2 files changed, 53 insertions(+), 53 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 028da1d..175c64f 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -379,7 +379,7 @@ static void CfgScanResult(enum scan_event scan_event,
 	struct cfg80211_bss *bss = NULL;
 
 	priv = user_void;
-	if (priv->bCfgScanning) {
+	if (priv->cfg_scanning) {
 		if (scan_event == SCAN_EVENT_NETWORK_FOUND) {
 			wiphy = priv->dev->ieee80211_ptr->wiphy;
 
@@ -399,8 +399,8 @@ static void CfgScanResult(enum scan_event scan_event,
 					return;
 
 				if (network_info->new_network) {
-					if (priv->u32RcvdChCount < MAX_NUM_SCANNED_NETWORKS) {
-						priv->u32RcvdChCount++;
+					if (priv->rcvd_ch_cnt < MAX_NUM_SCANNED_NETWORKS) {
+						priv->rcvd_ch_cnt++;
 
 						add_network_to_shadow(network_info, priv, join_params);
 
@@ -422,7 +422,7 @@ static void CfgScanResult(enum scan_event scan_event,
 				} else {
 					u32 i;
 
-					for (i = 0; i < priv->u32RcvdChCount; i++) {
+					for (i = 0; i < priv->rcvd_ch_cnt; i++) {
 						if (memcmp(last_scanned_shadow[i].bssid, network_info->bssid, 6) == 0) {
 							last_scanned_shadow[i].rssi = network_info->rssi;
 							last_scanned_shadow[i].time_scan = jiffies;
@@ -436,21 +436,21 @@ static void CfgScanResult(enum scan_event scan_event,
 
 			mutex_lock(&priv->scan_req_lock);
 
-			if (priv->pstrScanReq) {
+			if (priv->scan_req) {
 				struct cfg80211_scan_info info = {
 					.aborted = false,
 				};
 
-				cfg80211_scan_done(priv->pstrScanReq, &info);
-				priv->u32RcvdChCount = 0;
-				priv->bCfgScanning = false;
-				priv->pstrScanReq = NULL;
+				cfg80211_scan_done(priv->scan_req, &info);
+				priv->rcvd_ch_cnt = 0;
+				priv->cfg_scanning = false;
+				priv->scan_req = NULL;
 			}
 			mutex_unlock(&priv->scan_req_lock);
 		} else if (scan_event == SCAN_EVENT_ABORTED) {
 			mutex_lock(&priv->scan_req_lock);
 
-			if (priv->pstrScanReq) {
+			if (priv->scan_req) {
 				struct cfg80211_scan_info info = {
 					.aborted = false,
 				};
@@ -458,9 +458,9 @@ static void CfgScanResult(enum scan_event scan_event,
 				update_scan_time();
 				refresh_scan(priv, false);
 
-				cfg80211_scan_done(priv->pstrScanReq, &info);
-				priv->bCfgScanning = false;
-				priv->pstrScanReq = NULL;
+				cfg80211_scan_done(priv->scan_req, &info);
+				priv->cfg_scanning = false;
+				priv->scan_req = NULL;
 			}
 			mutex_unlock(&priv->scan_req_lock);
 		}
@@ -512,7 +512,7 @@ static void CfgConnectResult(enum conn_event enuConnDisconnEvent,
 			bool bNeedScanRefresh = false;
 			u32 i;
 
-			memcpy(priv->au8AssociatedBss, pstrConnectInfo->bssid, ETH_ALEN);
+			memcpy(priv->associated_bss, pstrConnectInfo->bssid, ETH_ALEN);
 
 			for (i = 0; i < last_scanned_cnt; i++) {
 				if (memcmp(last_scanned_shadow[i].bssid,
@@ -542,7 +542,7 @@ static void CfgConnectResult(enum conn_event enuConnDisconnEvent,
 		p2p_local_random = 0x01;
 		p2p_recv_random = 0x00;
 		wilc_ie = false;
-		eth_zero_addr(priv->au8AssociatedBss);
+		eth_zero_addr(priv->associated_bss);
 		wilc_wlan_set_bssid(priv->dev, NullBssid, STATION_MODE);
 		eth_zero_addr(wilc_connected_ssid);
 
@@ -593,13 +593,13 @@ static int scan(struct wiphy *wiphy, struct cfg80211_scan_request *request)
 	priv = wiphy_priv(wiphy);
 	vif = netdev_priv(priv->dev);
 
-	priv->pstrScanReq = request;
+	priv->scan_req = request;
 
-	priv->u32RcvdChCount = 0;
+	priv->rcvd_ch_cnt = 0;
 
 	reset_shadow_found();
 
-	priv->bCfgScanning = true;
+	priv->cfg_scanning = true;
 	if (request->n_channels <= MAX_NUM_SCANNED_NETWORKS) {
 		for (i = 0; i < request->n_channels; i++)
 			au8ScanChanList[i] = (u8)ieee80211_frequency_to_channel(request->channels[i]->center_freq);
@@ -1438,20 +1438,20 @@ void WILC_WFI_p2p_rx(struct net_device *dev, u8 *buff, u32 size)
 
 	if (pkt_offset & IS_MANAGMEMENT_CALLBACK) {
 		if (buff[FRAME_TYPE_ID] == IEEE80211_STYPE_PROBE_RESP) {
-			cfg80211_mgmt_tx_status(priv->wdev, priv->u64tx_cookie, buff, size, true, GFP_KERNEL);
+			cfg80211_mgmt_tx_status(priv->wdev, priv->tx_cookie, buff, size, true, GFP_KERNEL);
 			return;
 		} else {
 			if (pkt_offset & IS_MGMT_STATUS_SUCCES)
-				cfg80211_mgmt_tx_status(priv->wdev, priv->u64tx_cookie, buff, size, true, GFP_KERNEL);
+				cfg80211_mgmt_tx_status(priv->wdev, priv->tx_cookie, buff, size, true, GFP_KERNEL);
 			else
-				cfg80211_mgmt_tx_status(priv->wdev, priv->u64tx_cookie, buff, size, false, GFP_KERNEL);
+				cfg80211_mgmt_tx_status(priv->wdev, priv->tx_cookie, buff, size, false, GFP_KERNEL);
 			return;
 		}
 	} else {
 		s32Freq = ieee80211_channel_to_frequency(curr_channel, NL80211_BAND_2GHZ);
 
 		if (ieee80211_is_action(buff[FRAME_TYPE_ID])) {
-			if (priv->bCfgScanning && time_after_eq(jiffies, (unsigned long)pstrWFIDrv->p2p_timeout)) {
+			if (priv->cfg_scanning && time_after_eq(jiffies, (unsigned long)pstrWFIDrv->p2p_timeout)) {
 				netdev_dbg(dev, "Receiving action wrong ch\n");
 				return;
 			}
@@ -1522,12 +1522,12 @@ static void WILC_WFI_RemainOnChannelReady(void *pUserVoid)
 
 	priv = pUserVoid;
 
-	priv->bInP2PlistenState = true;
+	priv->p2p_listen_state = true;
 
 	cfg80211_ready_on_channel(priv->wdev,
-				  priv->strRemainOnChanParams.u64ListenCookie,
-				  priv->strRemainOnChanParams.pstrListenChan,
-				  priv->strRemainOnChanParams.u32ListenDuration,
+				  priv->remain_on_ch_params.u64ListenCookie,
+				  priv->remain_on_ch_params.pstrListenChan,
+				  priv->remain_on_ch_params.u32ListenDuration,
 				  GFP_KERNEL);
 }
 
@@ -1537,12 +1537,12 @@ static void WILC_WFI_RemainOnChannelExpired(void *pUserVoid, u32 u32SessionID)
 
 	priv = pUserVoid;
 
-	if (u32SessionID == priv->strRemainOnChanParams.u32ListenSessionID) {
-		priv->bInP2PlistenState = false;
+	if (u32SessionID == priv->remain_on_ch_params.u32ListenSessionID) {
+		priv->p2p_listen_state = false;
 
 		cfg80211_remain_on_channel_expired(priv->wdev,
-						   priv->strRemainOnChanParams.u64ListenCookie,
-						   priv->strRemainOnChanParams.pstrListenChan,
+						   priv->remain_on_ch_params.u64ListenCookie,
+						   priv->remain_on_ch_params.pstrListenChan,
 						   GFP_KERNEL);
 	}
 }
@@ -1566,13 +1566,13 @@ static int remain_on_channel(struct wiphy *wiphy,
 
 	curr_channel = chan->hw_value;
 
-	priv->strRemainOnChanParams.pstrListenChan = chan;
-	priv->strRemainOnChanParams.u64ListenCookie = *cookie;
-	priv->strRemainOnChanParams.u32ListenDuration = duration;
-	priv->strRemainOnChanParams.u32ListenSessionID++;
+	priv->remain_on_ch_params.pstrListenChan = chan;
+	priv->remain_on_ch_params.u64ListenCookie = *cookie;
+	priv->remain_on_ch_params.u32ListenDuration = duration;
+	priv->remain_on_ch_params.u32ListenSessionID++;
 
 	return wilc_remain_on_channel(vif,
-				priv->strRemainOnChanParams.u32ListenSessionID,
+				priv->remain_on_ch_params.u32ListenSessionID,
 				duration, chan->hw_value,
 				WILC_WFI_RemainOnChannelExpired,
 				WILC_WFI_RemainOnChannelReady, (void *)priv);
@@ -1589,7 +1589,7 @@ static int cancel_remain_on_channel(struct wiphy *wiphy,
 	vif = netdev_priv(priv->dev);
 
 	return wilc_listen_state_expired(vif,
-			priv->strRemainOnChanParams.u32ListenSessionID);
+			priv->remain_on_ch_params.u32ListenSessionID);
 }
 
 static int mgmt_tx(struct wiphy *wiphy,
@@ -1614,7 +1614,7 @@ static int mgmt_tx(struct wiphy *wiphy,
 	pstrWFIDrv = (struct host_if_drv *)priv->hif_drv;
 
 	*cookie = (unsigned long)buf;
-	priv->u64tx_cookie = *cookie;
+	priv->tx_cookie = *cookie;
 	mgmt = (const struct ieee80211_mgmt *)buf;
 
 	if (ieee80211_is_mgmt(mgmt->frame_control)) {
@@ -1716,10 +1716,10 @@ static int mgmt_tx_cancel_wait(struct wiphy *wiphy,
 	pstrWFIDrv = (struct host_if_drv *)priv->hif_drv;
 	pstrWFIDrv->p2p_timeout = jiffies;
 
-	if (!priv->bInP2PlistenState) {
+	if (!priv->p2p_listen_state) {
 		cfg80211_remain_on_channel_expired(priv->wdev,
-						   priv->strRemainOnChanParams.u64ListenCookie,
-						   priv->strRemainOnChanParams.pstrListenChan,
+						   priv->remain_on_ch_params.u64ListenCookie,
+						   priv->remain_on_ch_params.pstrListenChan,
 						   GFP_KERNEL);
 	}
 
@@ -1788,7 +1788,7 @@ static int dump_station(struct wiphy *wiphy, struct net_device *dev,
 
 	wilc_get_rssi(vif, &sinfo->signal);
 
-	memcpy(mac, priv->au8AssociatedBss, ETH_ALEN);
+	memcpy(mac, priv->associated_bss, ETH_ALEN);
 	return 0;
 }
 
@@ -2283,9 +2283,9 @@ int wilc_init_host_int(struct net_device *net)
 	}
 	op_ifcs++;
 
-	priv->gbAutoRateAdjusted = false;
+	priv->auto_rate_adjusted = false;
 
-	priv->bInP2PlistenState = false;
+	priv->p2p_listen_state = false;
 
 	mutex_init(&priv->scan_req_lock);
 	s32Error = wilc_init(net, &priv->hif_drv);
@@ -2304,9 +2304,9 @@ int wilc_deinit_host_int(struct net_device *net)
 	priv = wdev_priv(net->ieee80211_ptr);
 	vif = netdev_priv(priv->dev);
 
-	priv->gbAutoRateAdjusted = false;
+	priv->auto_rate_adjusted = false;
 
-	priv->bInP2PlistenState = false;
+	priv->p2p_listen_state = false;
 
 	op_ifcs--;
 
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index e6f4d84..2046bb9 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -100,15 +100,15 @@ struct wilc_wfi_p2pListenParams {
 
 struct wilc_priv {
 	struct wireless_dev *wdev;
-	struct cfg80211_scan_request *pstrScanReq;
+	struct cfg80211_scan_request *scan_req;
 
-	struct wilc_wfi_p2pListenParams strRemainOnChanParams;
-	u64 u64tx_cookie;
+	struct wilc_wfi_p2pListenParams remain_on_ch_params;
+	u64 tx_cookie;
 
-	bool bCfgScanning;
-	u32 u32RcvdChCount;
+	bool cfg_scanning;
+	u32 rcvd_ch_cnt;
 
-	u8 au8AssociatedBss[ETH_ALEN];
+	u8 associated_bss[ETH_ALEN];
 	struct sta_info assoc_stainfo;
 	struct net_device_stats stats;
 	u8 monitor_flag;
@@ -135,9 +135,9 @@ struct wilc_priv {
 	/* mutexes */
 	struct mutex scan_req_lock;
 	/*  */
-	bool gbAutoRateAdjusted;
+	bool auto_rate_adjusted;
 
-	bool bInP2PlistenState;
+	bool p2p_listen_state;
 
 };
 
-- 
2.7.4
