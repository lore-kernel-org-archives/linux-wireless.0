Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:44189 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752073AbeAPODE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 Jan 2018 09:03:04 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 06/13] staging: wilc1000: rename CfgConnectResult() and its local variable names
Date: Tue, 16 Jan 2018 19:32:24 +0530
Message-ID: <1516111351-5353-7-git-send-email-ajay.kathat@microchip.com> (sfid-20180116_150350_048090_165E21BD)
In-Reply-To: <1516111351-5353-1-git-send-email-ajay.kathat@microchip.com>
References: <1516111351-5353-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is cleanup patch,to avoid use of camelCase for variable name
and function names in CfgConnectResult().

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 74 +++++++++++------------
 1 file changed, 37 insertions(+), 37 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 2ca703c..15d7e14 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -469,92 +469,92 @@ static void CfgScanResult(enum scan_event scan_event,
 
 int wilc_connecting;
 
-static void CfgConnectResult(enum conn_event enuConnDisconnEvent,
-			     struct connect_info *pstrConnectInfo,
-			     u8 u8MacStatus,
-			     struct disconnect_info *pstrDisconnectNotifInfo,
-			     void *pUserVoid)
+static void cfg_connect_result(enum conn_event conn_disconn_evt,
+			     struct connect_info *conn_info,
+			     u8 mac_status,
+			     struct disconnect_info *disconn_info,
+			     void *priv_data)
 {
 	struct wilc_priv *priv;
 	struct net_device *dev;
-	struct host_if_drv *pstrWFIDrv;
-	u8 NullBssid[ETH_ALEN] = {0};
+	struct host_if_drv *wfi_drv;
+	u8 null_bssid[ETH_ALEN] = {0};
 	struct wilc *wl;
 	struct wilc_vif *vif;
 
 	wilc_connecting = 0;
 
-	priv = pUserVoid;
+	priv = priv_data;
 	dev = priv->dev;
 	vif = netdev_priv(dev);
 	wl = vif->wilc;
-	pstrWFIDrv = (struct host_if_drv *)priv->hif_drv;
+	wfi_drv = (struct host_if_drv *)priv->hif_drv;
 
-	if (enuConnDisconnEvent == CONN_DISCONN_EVENT_CONN_RESP) {
-		u16 u16ConnectStatus;
+	if (conn_disconn_evt == CONN_DISCONN_EVENT_CONN_RESP) {
+		u16 connect_status;
 
-		u16ConnectStatus = pstrConnectInfo->status;
+		connect_status = conn_info->status;
 
-		if ((u8MacStatus == MAC_DISCONNECTED) &&
-		    (pstrConnectInfo->status == SUCCESSFUL_STATUSCODE)) {
-			u16ConnectStatus = WLAN_STATUS_UNSPECIFIED_FAILURE;
-			wilc_wlan_set_bssid(priv->dev, NullBssid,
+		if ((mac_status == MAC_DISCONNECTED) &&
+		    (conn_info->status == SUCCESSFUL_STATUSCODE)) {
+			connect_status = WLAN_STATUS_UNSPECIFIED_FAILURE;
+			wilc_wlan_set_bssid(priv->dev, null_bssid,
 					    STATION_MODE);
 			eth_zero_addr(wilc_connected_ssid);
 
-			if (!pstrWFIDrv->p2p_connect)
+			if (!wfi_drv->p2p_connect)
 				wlan_channel = INVALID_CHANNEL;
 
 			netdev_err(dev, "Unspecified failure\n");
 		}
 
-		if (u16ConnectStatus == WLAN_STATUS_SUCCESS) {
-			bool bNeedScanRefresh = false;
+		if (connect_status == WLAN_STATUS_SUCCESS) {
+			bool scan_refresh = false;
 			u32 i;
 
-			memcpy(priv->associated_bss, pstrConnectInfo->bssid, ETH_ALEN);
+			memcpy(priv->associated_bss, conn_info->bssid, ETH_ALEN);
 
 			for (i = 0; i < last_scanned_cnt; i++) {
 				if (memcmp(last_scanned_shadow[i].bssid,
-					   pstrConnectInfo->bssid,
+					   conn_info->bssid,
 					   ETH_ALEN) == 0) {
 					unsigned long now = jiffies;
 
 					if (time_after(now,
 						       last_scanned_shadow[i].time_scan_cached +
 						       (unsigned long)(nl80211_SCAN_RESULT_EXPIRE - (1 * HZ))))
-						bNeedScanRefresh = true;
+						scan_refresh = true;
 
 					break;
 				}
 			}
 
-			if (bNeedScanRefresh)
+			if (scan_refresh)
 				refresh_scan(priv, true);
 		}
 
-		cfg80211_connect_result(dev, pstrConnectInfo->bssid,
-					pstrConnectInfo->req_ies, pstrConnectInfo->req_ies_len,
-					pstrConnectInfo->resp_ies, pstrConnectInfo->resp_ies_len,
-					u16ConnectStatus, GFP_KERNEL);
-	} else if (enuConnDisconnEvent == CONN_DISCONN_EVENT_DISCONN_NOTIF)    {
+		cfg80211_connect_result(dev, conn_info->bssid,
+					conn_info->req_ies, conn_info->req_ies_len,
+					conn_info->resp_ies, conn_info->resp_ies_len,
+					connect_status, GFP_KERNEL);
+	} else if (conn_disconn_evt == CONN_DISCONN_EVENT_DISCONN_NOTIF)    {
 		wilc_optaining_ip = false;
 		p2p_local_random = 0x01;
 		p2p_recv_random = 0x00;
 		wilc_ie = false;
 		eth_zero_addr(priv->associated_bss);
-		wilc_wlan_set_bssid(priv->dev, NullBssid, STATION_MODE);
+		wilc_wlan_set_bssid(priv->dev, null_bssid, STATION_MODE);
 		eth_zero_addr(wilc_connected_ssid);
 
-		if (!pstrWFIDrv->p2p_connect)
+		if (!wfi_drv->p2p_connect)
 			wlan_channel = INVALID_CHANNEL;
-		if ((pstrWFIDrv->IFC_UP) && (dev == wl->vif[1]->ndev))
-			pstrDisconnectNotifInfo->reason = 3;
-		else if ((!pstrWFIDrv->IFC_UP) && (dev == wl->vif[1]->ndev))
-			pstrDisconnectNotifInfo->reason = 1;
+		if ((wfi_drv->IFC_UP) && (dev == wl->vif[1]->ndev))
+			disconn_info->reason = 3;
+		else if ((!wfi_drv->IFC_UP) && (dev == wl->vif[1]->ndev))
+			disconn_info->reason = 1;
 
-		cfg80211_disconnected(dev, pstrDisconnectNotifInfo->reason, pstrDisconnectNotifInfo->ie,
-				      pstrDisconnectNotifInfo->ie_len, false,
+		cfg80211_disconnected(dev, disconn_info->reason, disconn_info->ie,
+				      disconn_info->ie_len, false,
 				      GFP_KERNEL);
 	}
 }
@@ -794,7 +794,7 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
 
 	ret = wilc_set_join_req(vif, pstrNetworkInfo->bssid, sme->ssid,
 				     sme->ssid_len, sme->ie, sme->ie_len,
-				     CfgConnectResult, (void *)priv,
+				     cfg_connect_result, (void *)priv,
 				     u8security, tenuAuth_type,
 				     pstrNetworkInfo->ch,
 				     pstrNetworkInfo->join_params);
-- 
2.7.4
