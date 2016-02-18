Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:30158 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1425347AbcBRLen (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Feb 2016 06:34:43 -0500
From: Leo Kim <leo.kim@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>,
	Chris Park <chris.park@atmel.com>
Subject: [PATCH V2 12/24] staging: wilc1000: wilc_wfi_cfgoperations.c: removes unnecessary log messages
Date: Thu, 18 Feb 2016 20:30:12 +0900
Message-ID: <1455795024-26978-12-git-send-email-leo.kim@atmel.com> (sfid-20160218_123448_525940_6D898DF6)
In-Reply-To: <1455795024-26978-1-git-send-email-leo.kim@atmel.com>
References: <1455795024-26978-1-git-send-email-leo.kim@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Chris Park <chris.park@atmel.com>

This patch removes unnecessary log messages and relate variables.

Signed-off-by: Chris Park <chris.park@atmel.com>
Signed-off-by: Leo Kim <leo.kim@atmel.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 233 +---------------------
 1 file changed, 11 insertions(+), 222 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 0794f93..be7d835 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -290,9 +290,6 @@ static void remove_network_from_shadow(unsigned long arg)
 	for (i = 0; i < last_scanned_cnt; i++) {
 		if (time_after(now, last_scanned_shadow[i].time_scan +
 			       (unsigned long)(SCAN_RESULT_EXPIRE))) {
-			PRINT_D(CFG80211_DBG, "Network expired ScanShadow:%s\n",
-				last_scanned_shadow[i].ssid);
-
 			kfree(last_scanned_shadow[i].ies);
 			last_scanned_shadow[i].ies = NULL;
 
@@ -305,13 +302,9 @@ static void remove_network_from_shadow(unsigned long arg)
 		}
 	}
 
-	PRINT_D(CFG80211_DBG, "Number of cached networks: %d\n",
-		last_scanned_cnt);
 	if (last_scanned_cnt != 0) {
 		hAgingTimer.data = arg;
 		mod_timer(&hAgingTimer, jiffies + msecs_to_jiffies(AGING_TIME));
-	} else {
-		PRINT_D(CFG80211_DBG, "No need to restart Aging timer\n");
 	}
 }
 
@@ -327,7 +320,6 @@ static int is_network_in_shadow(struct network_info *pstrNetworkInfo,
 	int i;
 
 	if (last_scanned_cnt == 0) {
-		PRINT_D(CFG80211_DBG, "Starting Aging timer\n");
 		hAgingTimer.data = (unsigned long)user_void;
 		mod_timer(&hAgingTimer, jiffies + msecs_to_jiffies(AGING_TIME));
 		state = -1;
@@ -350,10 +342,9 @@ static void add_network_to_shadow(struct network_info *pstrNetworkInfo,
 	u32 ap_index = 0;
 	u8 rssi_index = 0;
 
-	if (last_scanned_cnt >= MAX_NUM_SCANNED_NETWORKS_SHADOW) {
-		PRINT_D(CFG80211_DBG, "Shadow network reached its maximum limit\n");
+	if (last_scanned_cnt >= MAX_NUM_SCANNED_NETWORKS_SHADOW)
 		return;
-	}
+
 	if (ap_found == -1) {
 		ap_index = last_scanned_cnt;
 		last_scanned_cnt++;
@@ -424,21 +415,8 @@ static void CfgScanResult(enum scan_event scan_event,
 				if (!channel)
 					return;
 
-				PRINT_INFO(CFG80211_DBG, "Network Info::"
-					   "CHANNEL Frequency: %d,"
-					   "RSSI: %d,"
-					   "Capability Info: %d,"
-					   "Beacon Period: %d\n",
-					   channel->center_freq,
-					   (s32)network_info->rssi * 100,
-					   network_info->cap_info,
-					   network_info->beacon_period);
-
 				if (network_info->new_network) {
 					if (priv->u32RcvdChCount < MAX_NUM_SCANNED_NETWORKS) {
-						PRINT_D(CFG80211_DBG,
-							"Network %s found\n",
-							network_info->ssid);
 						priv->u32RcvdChCount++;
 
 						add_network_to_shadow(network_info, priv, join_params);
@@ -463,8 +441,6 @@ static void CfgScanResult(enum scan_event scan_event,
 
 					for (i = 0; i < priv->u32RcvdChCount; i++) {
 						if (memcmp(last_scanned_shadow[i].bssid, network_info->bssid, 6) == 0) {
-							PRINT_D(CFG80211_DBG, "Update RSSI of %s\n", last_scanned_shadow[i].ssid);
-
 							last_scanned_shadow[i].rssi = network_info->rssi;
 							last_scanned_shadow[i].time_scan = jiffies;
 							break;
@@ -473,15 +449,8 @@ static void CfgScanResult(enum scan_event scan_event,
 				}
 			}
 		} else if (scan_event == SCAN_EVENT_DONE) {
-			PRINT_D(CFG80211_DBG, "Scan Done[%p]\n", priv->dev);
-			PRINT_D(CFG80211_DBG, "Refreshing Scan ...\n");
 			refresh_scan(priv, 1, false);
 
-			if (priv->u32RcvdChCount > 0)
-				PRINT_D(CFG80211_DBG, "%d Network(s) found\n", priv->u32RcvdChCount);
-			else
-				PRINT_D(CFG80211_DBG, "No networks found\n");
-
 			down(&(priv->hSemScanReq));
 
 			if (priv->pstrScanReq) {
@@ -494,7 +463,6 @@ static void CfgScanResult(enum scan_event scan_event,
 		} else if (scan_event == SCAN_EVENT_ABORTED) {
 			down(&(priv->hSemScanReq));
 
-			PRINT_D(CFG80211_DBG, "Scan Aborted\n");
 			if (priv->pstrScanReq) {
 				update_scan_time();
 				refresh_scan(priv, 1, false);
@@ -536,8 +504,6 @@ static void CfgConnectResult(enum conn_event enuConnDisconnEvent,
 
 		u16ConnectStatus = pstrConnectInfo->u16ConnectStatus;
 
-		PRINT_D(CFG80211_DBG, " Connection response received = %d\n", u8MacStatus);
-
 		if ((u8MacStatus == MAC_DISCONNECTED) &&
 		    (pstrConnectInfo->u16ConnectStatus == SUCCESSFUL_STATUSCODE)) {
 			u16ConnectStatus = WLAN_STATUS_UNSPECIFIED_FAILURE;
@@ -555,8 +521,6 @@ static void CfgConnectResult(enum conn_event enuConnDisconnEvent,
 			bool bNeedScanRefresh = false;
 			u32 i;
 
-			PRINT_INFO(CFG80211_DBG, "Connection Successful:: BSSID: %x%x%x%x%x%x\n", pstrConnectInfo->au8bssid[0],
-				   pstrConnectInfo->au8bssid[1], pstrConnectInfo->au8bssid[2], pstrConnectInfo->au8bssid[3], pstrConnectInfo->au8bssid[4], pstrConnectInfo->au8bssid[5]);
 			memcpy(priv->au8AssociatedBss, pstrConnectInfo->au8bssid, ETH_ALEN);
 
 
@@ -579,11 +543,6 @@ static void CfgConnectResult(enum conn_event enuConnDisconnEvent,
 				refresh_scan(priv, 1, true);
 		}
 
-
-		PRINT_D(CFG80211_DBG, "Association request info elements length = %zu\n", pstrConnectInfo->ReqIEsLen);
-
-		PRINT_D(CFG80211_DBG, "Association response info elements length = %d\n", pstrConnectInfo->u16RespIEsLen);
-
 		cfg80211_connect_result(dev, pstrConnectInfo->au8bssid,
 					pstrConnectInfo->pu8ReqIEs, pstrConnectInfo->ReqIEsLen,
 					pstrConnectInfo->pu8RespIEs, pstrConnectInfo->u16RespIEsLen,
@@ -622,7 +581,6 @@ static int set_channel(struct wiphy *wiphy,
 	vif = netdev_priv(priv->dev);
 
 	channelnum = ieee80211_frequency_to_channel(chandef->chan->center_freq);
-	PRINT_D(CFG80211_DBG, "Setting channel %d with frequency %d\n", channelnum, chandef->chan->center_freq);
 
 	curr_channel = channelnum;
 	result = wilc_set_mac_chnl_num(vif, channelnum);
@@ -653,15 +611,8 @@ static int scan(struct wiphy *wiphy, struct cfg80211_scan_request *request)
 
 	priv->bCfgScanning = true;
 	if (request->n_channels <= MAX_NUM_SCANNED_NETWORKS) {
-		for (i = 0; i < request->n_channels; i++) {
+		for (i = 0; i < request->n_channels; i++)
 			au8ScanChanList[i] = (u8)ieee80211_frequency_to_channel(request->channels[i]->center_freq);
-			PRINT_INFO(CFG80211_DBG, "ScanChannel List[%d] = %d,", i, au8ScanChanList[i]);
-		}
-
-		PRINT_D(CFG80211_DBG, "Requested num of scan channel %d\n", request->n_channels);
-		PRINT_D(CFG80211_DBG, "Scan Request IE len =  %zu\n", request->ie_len);
-
-		PRINT_D(CFG80211_DBG, "Number of SSIDs %d\n", request->n_ssids);
 
 		if (request->n_ssids >= 1) {
 			strHiddenNetwork.net_info = kmalloc(request->n_ssids * sizeof(struct hidden_network), GFP_KERNEL);
@@ -677,11 +628,9 @@ static int scan(struct wiphy *wiphy, struct cfg80211_scan_request *request)
 					memcpy(strHiddenNetwork.net_info[i].ssid, request->ssids[i].ssid, request->ssids[i].ssid_len);
 					strHiddenNetwork.net_info[i].ssid_len = request->ssids[i].ssid_len;
 				} else {
-					PRINT_D(CFG80211_DBG, "Received one NULL SSID\n");
 					strHiddenNetwork.n_ssids -= 1;
 				}
 			}
-			PRINT_D(CFG80211_DBG, "Trigger Scan Request\n");
 			s32Error = wilc_scan(vif, USER_SCAN, ACTIVE_SCAN,
 					     au8ScanChanList,
 					     request->n_channels,
@@ -689,7 +638,6 @@ static int scan(struct wiphy *wiphy, struct cfg80211_scan_request *request)
 					     request->ie_len, CfgScanResult,
 					     (void *)priv, &strHiddenNetwork);
 		} else {
-			PRINT_D(CFG80211_DBG, "Trigger Scan Request\n");
 			s32Error = wilc_scan(vif, USER_SCAN, ACTIVE_SCAN,
 					     au8ScanChanList,
 					     request->n_channels,
@@ -701,10 +649,8 @@ static int scan(struct wiphy *wiphy, struct cfg80211_scan_request *request)
 		netdev_err(priv->dev, "Requested scanned channels over\n");
 	}
 
-	if (s32Error != 0) {
+	if (s32Error != 0)
 		s32Error = -EBUSY;
-		PRINT_WRN(CFG80211_DBG, "Device is busy: Error(%d)\n", s32Error);
-	}
 
 	return s32Error;
 }
@@ -730,53 +676,30 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
 	vif = netdev_priv(priv->dev);
 	pstrWFIDrv = (struct host_if_drv *)priv->hif_drv;
 
-	PRINT_D(CFG80211_DBG,
-		"Connecting to SSID [%s] on netdev [%p] host if [%p]\n",
-		sme->ssid, dev, priv->hif_drv);
-	if (!(strncmp(sme->ssid, "DIRECT-", 7))) {
-		PRINT_D(CFG80211_DBG, "Connected to Direct network,OBSS disabled\n");
+	if (!(strncmp(sme->ssid, "DIRECT-", 7)))
 		pstrWFIDrv->p2p_connect = 1;
-	} else {
+	else
 		pstrWFIDrv->p2p_connect = 0;
-	}
-	PRINT_INFO(CFG80211_DBG, "Required SSID = %s\n , AuthType = %d\n", sme->ssid, sme->auth_type);
 
 	for (i = 0; i < last_scanned_cnt; i++) {
 		if ((sme->ssid_len == last_scanned_shadow[i].ssid_len) &&
 		    memcmp(last_scanned_shadow[i].ssid,
 			   sme->ssid,
 			   sme->ssid_len) == 0) {
-			PRINT_INFO(CFG80211_DBG, "Network with required SSID is found %s\n", sme->ssid);
-			if (!sme->bssid) {
-				PRINT_INFO(CFG80211_DBG, "BSSID is not passed from the user\n");
+			if (!sme->bssid)
 				break;
-			} else {
+			else
 				if (memcmp(last_scanned_shadow[i].bssid,
 					   sme->bssid,
-					   ETH_ALEN) == 0) {
-					PRINT_INFO(CFG80211_DBG, "BSSID is passed from the user and matched\n");
+					   ETH_ALEN) == 0)
 					break;
-				}
-			}
 		}
 	}
 
 	if (i < last_scanned_cnt) {
-		PRINT_D(CFG80211_DBG, "Required bss is in scan results\n");
-
 		pstrNetworkInfo = &last_scanned_shadow[i];
-
-		PRINT_INFO(CFG80211_DBG, "network BSSID to be associated:"
-			   "%x%x%x%x%x%x\n",
-			   pstrNetworkInfo->bssid[0], pstrNetworkInfo->bssid[1],
-			   pstrNetworkInfo->bssid[2], pstrNetworkInfo->bssid[3],
-			   pstrNetworkInfo->bssid[4], pstrNetworkInfo->bssid[5]);
 	} else {
 		s32Error = -ENOENT;
-		if (last_scanned_cnt == 0)
-			PRINT_D(CFG80211_DBG, "No Scan results yet\n");
-		else
-			PRINT_D(CFG80211_DBG, "Required bss not in scan results: Error(%d)\n", s32Error);
 		wilc_connecting = 0;
 		return s32Error;
 	}
@@ -784,18 +707,12 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
 	memset(priv->WILC_WFI_wep_key, 0, sizeof(priv->WILC_WFI_wep_key));
 	memset(priv->WILC_WFI_wep_key_len, 0, sizeof(priv->WILC_WFI_wep_key_len));
 
-	PRINT_INFO(CFG80211_DBG, "sme->crypto.wpa_versions=%x\n", sme->crypto.wpa_versions);
-	PRINT_INFO(CFG80211_DBG, "sme->crypto.cipher_group=%x\n", sme->crypto.cipher_group);
-
-	PRINT_INFO(CFG80211_DBG, "sme->crypto.n_ciphers_pairwise=%d\n", sme->crypto.n_ciphers_pairwise);
-
 	if (sme->crypto.cipher_group != NO_ENCRYPT) {
 		pcwpa_version = "Default";
 		if (sme->crypto.cipher_group == WLAN_CIPHER_SUITE_WEP40) {
 			u8security = ENCRYPT_ENABLED | WEP;
 			pcgroup_encrypt_val = "WEP40";
 			pccipher_group = "WLAN_CIPHER_SUITE_WEP40";
-			PRINT_INFO(CFG80211_DBG, "WEP Default Key Idx = %d\n", sme->key_idx);
 
 			priv->WILC_WFI_wep_key_len[sme->key_idx] = sme->key_len;
 			memcpy(priv->WILC_WFI_wep_key[sme->key_idx], sme->key, sme->key_len);
@@ -868,18 +785,13 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
 		}
 	}
 
-	PRINT_D(CFG80211_DBG, "Adding key with cipher group = %x\n", sme->crypto.cipher_group);
-
-	PRINT_D(CFG80211_DBG, "Authentication Type = %d\n", sme->auth_type);
 	switch (sme->auth_type)	{
 	case NL80211_AUTHTYPE_OPEN_SYSTEM:
-		PRINT_D(CFG80211_DBG, "In OPEN SYSTEM\n");
 		tenuAuth_type = OPEN_SYSTEM;
 		break;
 
 	case NL80211_AUTHTYPE_SHARED_KEY:
 		tenuAuth_type = SHARED_KEY;
-		PRINT_D(CFG80211_DBG, "In SHARED KEY\n");
 		break;
 
 	default:
@@ -897,12 +809,6 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
 		}
 	}
 
-
-	PRINT_INFO(CFG80211_DBG, "Required Ch = %d\n", pstrNetworkInfo->ch);
-
-	PRINT_INFO(CFG80211_DBG, "Group encryption value = %s\n Cipher Group = %s\n WPA version = %s\n",
-		   pcgroup_encrypt_val, pccipher_group, pcwpa_version);
-
 	curr_channel = pstrNetworkInfo->ch;
 
 	if (!pstrWFIDrv->p2p_connect)
@@ -943,8 +849,6 @@ static int disconnect(struct wiphy *wiphy, struct net_device *dev, u16 reason_co
 		wlan_channel = INVALID_CHANNEL;
 	wilc_wlan_set_bssid(priv->dev, NullBssid, STATION_MODE);
 
-	PRINT_D(CFG80211_DBG, "Disconnecting with reason code(%d)\n", reason_code);
-
 	p2p_local_random = 0x01;
 	p2p_recv_random = 0x00;
 	wilc_ie = false;
@@ -965,7 +869,6 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 
 {
 	s32 s32Error = 0, KeyLen = params->key_len;
-	u32 i;
 	struct wilc_priv *priv;
 	const u8 *pu8RxMic = NULL;
 	const u8 *pu8TxMic = NULL;
@@ -980,15 +883,6 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 	vif = netdev_priv(netdev);
 	wl = vif->wilc;
 
-	PRINT_D(CFG80211_DBG, "Adding key with cipher suite = %x\n", params->cipher);
-
-	PRINT_D(CFG80211_DBG, "%p %p %d\n", wiphy, netdev, key_index);
-
-	PRINT_D(CFG80211_DBG, "key %x %x %x\n", params->key[0],
-		params->key[1],
-		params->key[2]);
-
-
 	switch (params->cipher)	{
 	case WLAN_CIPHER_SUITE_WEP40:
 	case WLAN_CIPHER_SUITE_WEP104:
@@ -996,12 +890,6 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 			priv->WILC_WFI_wep_key_len[key_index] = params->key_len;
 			memcpy(priv->WILC_WFI_wep_key[key_index], params->key, params->key_len);
 
-			PRINT_D(CFG80211_DBG, "Adding AP WEP Default key Idx = %d\n", key_index);
-			PRINT_D(CFG80211_DBG, "Adding AP WEP Key len= %d\n", params->key_len);
-
-			for (i = 0; i < params->key_len; i++)
-				PRINT_D(CFG80211_DBG, "WEP AP key val[%d] = %x\n", i, params->key[i]);
-
 			tenuAuth_type = OPEN_SYSTEM;
 
 			if (params->cipher == WLAN_CIPHER_SUITE_WEP40)
@@ -1018,12 +906,6 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 			priv->WILC_WFI_wep_key_len[key_index] = params->key_len;
 			memcpy(priv->WILC_WFI_wep_key[key_index], params->key, params->key_len);
 
-			PRINT_D(CFG80211_DBG, "Adding WEP Default key Idx = %d\n", key_index);
-			PRINT_D(CFG80211_DBG, "Adding WEP Key length = %d\n", params->key_len);
-			if (INFO) {
-				for (i = 0; i < params->key_len; i++)
-					PRINT_INFO(CFG80211_DBG, "WEP key value[%d] = %d\n", i, params->key[i]);
-			}
 			wilc_add_wep_key_bss_sta(vif, params->key,
 						 params->key_len, key_index);
 		}
@@ -1074,22 +956,12 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 				priv->wilc_gtk[key_index]->key_len = params->key_len;
 				priv->wilc_gtk[key_index]->seq_len = params->seq_len;
 
-				if (INFO) {
-					for (i = 0; i < params->key_len; i++)
-						PRINT_INFO(CFG80211_DBG, "Adding group key value[%d] = %x\n", i, params->key[i]);
-					for (i = 0; i < params->seq_len; i++)
-						PRINT_INFO(CFG80211_DBG, "Adding group seq value[%d] = %x\n", i, params->seq[i]);
-				}
-
-
 				wilc_add_rx_gtk(vif, params->key, KeyLen,
 						key_index, params->seq_len,
 						params->seq, pu8RxMic,
 						pu8TxMic, AP_MODE, u8gmode);
 
 			} else {
-				PRINT_INFO(CFG80211_DBG, "STA Address: %x%x%x%x%x\n", mac_addr[0], mac_addr[1], mac_addr[2], mac_addr[3], mac_addr[4]);
-
 				if (params->cipher == WLAN_CIPHER_SUITE_TKIP)
 					u8pmode = ENCRYPT_ENABLED | WPA | TKIP;
 				else
@@ -1111,14 +983,6 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 				if ((params->seq_len) > 0)
 					priv->wilc_ptk[key_index]->seq = kmalloc(params->seq_len, GFP_KERNEL);
 
-				if (INFO) {
-					for (i = 0; i < params->key_len; i++)
-						PRINT_INFO(CFG80211_DBG, "Adding pairwise key value[%d] = %x\n", i, params->key[i]);
-
-					for (i = 0; i < params->seq_len; i++)
-						PRINT_INFO(CFG80211_DBG, "Adding group seq value[%d] = %x\n", i, params->seq[i]);
-				}
-
 				memcpy(priv->wilc_ptk[key_index]->key, params->key, params->key_len);
 
 				if ((params->seq_len) > 0)
@@ -1162,10 +1026,6 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 						memcpy(g_key_gtk_params.seq, params->seq, params->seq_len);
 					}
 					g_key_gtk_params.cipher = params->cipher;
-
-					PRINT_D(CFG80211_DBG, "key %x %x %x\n", g_key_gtk_params.key[0],
-						g_key_gtk_params.key[1],
-						g_key_gtk_params.key[2]);
 					g_gtk_keys_saved = true;
 				}
 
@@ -1199,21 +1059,12 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 						memcpy(g_key_ptk_params.seq, params->seq, params->seq_len);
 					}
 					g_key_ptk_params.cipher = params->cipher;
-
-					PRINT_D(CFG80211_DBG, "key %x %x %x\n", g_key_ptk_params.key[0],
-						g_key_ptk_params.key[1],
-						g_key_ptk_params.key[2]);
 					g_ptk_keys_saved = true;
 				}
 
 				wilc_add_ptk(vif, params->key, KeyLen,
 					     mac_addr, pu8RxMic, pu8TxMic,
 					     STATION_MODE, u8mode, key_index);
-				PRINT_D(CFG80211_DBG, "Adding pairwise key\n");
-				if (INFO) {
-					for (i = 0; i < params->key_len; i++)
-						PRINT_INFO(CFG80211_DBG, "Adding pairwise key value[%d] = %d\n", i, params->key[i]);
-				}
 			}
 		}
 		break;
@@ -1281,11 +1132,8 @@ static int del_key(struct wiphy *wiphy, struct net_device *netdev,
 	if (key_index >= 0 && key_index <= 3) {
 		memset(priv->WILC_WFI_wep_key[key_index], 0, priv->WILC_WFI_wep_key_len[key_index]);
 		priv->WILC_WFI_wep_key_len[key_index] = 0;
-
-		PRINT_D(CFG80211_DBG, "Removing WEP key with index = %d\n", key_index);
 		wilc_remove_wep_key(vif, key_index);
 	} else {
-		PRINT_D(CFG80211_DBG, "Removing all installed keys\n");
 		wilc_remove_key(priv->hif_drv, mac_addr);
 	}
 
@@ -1298,26 +1146,17 @@ static int get_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 {
 	struct wilc_priv *priv;
 	struct  key_params key_params;
-	u32 i;
 
 	priv = wiphy_priv(wiphy);
 
 
 	if (!pairwise) {
-		PRINT_D(CFG80211_DBG, "Getting group key idx: %x\n", key_index);
-
 		key_params.key = priv->wilc_gtk[key_index]->key;
 		key_params.cipher = priv->wilc_gtk[key_index]->cipher;
 		key_params.key_len = priv->wilc_gtk[key_index]->key_len;
 		key_params.seq = priv->wilc_gtk[key_index]->seq;
 		key_params.seq_len = priv->wilc_gtk[key_index]->seq_len;
-		if (INFO) {
-			for (i = 0; i < key_params.key_len; i++)
-				PRINT_INFO(CFG80211_DBG, "Retrieved key value %x\n", key_params.key[i]);
-		}
 	} else {
-		PRINT_D(CFG80211_DBG, "Getting pairwise  key\n");
-
 		key_params.key = priv->wilc_ptk[key_index]->key;
 		key_params.cipher = priv->wilc_ptk[key_index]->cipher;
 		key_params.key_len = priv->wilc_ptk[key_index]->key_len;
@@ -1339,8 +1178,6 @@ static int set_default_key(struct wiphy *wiphy, struct net_device *netdev, u8 ke
 	priv = wiphy_priv(wiphy);
 	vif = netdev_priv(priv->dev);
 
-	PRINT_D(CFG80211_DBG, "Setting default key with idx = %d\n", key_index);
-
 	wilc_set_wep_default_keyid(vif, key_index);
 
 	return 0;
@@ -1374,7 +1211,6 @@ static int get_station(struct wiphy *wiphy, struct net_device *dev,
 
 		wilc_get_inactive_time(vif, mac, &inactive_time);
 		sinfo->inactive_time = 1000 * inactive_time;
-		PRINT_D(CFG80211_DBG, "Inactive time %d\n", sinfo->inactive_time);
 	}
 
 	if (vif->iftype == STATION_MODE) {
@@ -1406,7 +1242,6 @@ static int get_station(struct wiphy *wiphy, struct net_device *dev,
 static int change_bss(struct wiphy *wiphy, struct net_device *dev,
 		      struct bss_parameters *params)
 {
-	PRINT_D(CFG80211_DBG, "Changing Bss parametrs\n");
 	return 0;
 }
 
@@ -1421,33 +1256,25 @@ static int set_wiphy_params(struct wiphy *wiphy, u32 changed)
 	vif = netdev_priv(priv->dev);
 
 	pstrCfgParamVal.flag = 0;
-	PRINT_D(CFG80211_DBG, "Setting Wiphy params\n");
 
 	if (changed & WIPHY_PARAM_RETRY_SHORT) {
-		PRINT_D(CFG80211_DBG, "Setting WIPHY_PARAM_RETRY_SHORT %d\n",
-			priv->dev->ieee80211_ptr->wiphy->retry_short);
 		pstrCfgParamVal.flag  |= RETRY_SHORT;
 		pstrCfgParamVal.short_retry_limit = priv->dev->ieee80211_ptr->wiphy->retry_short;
 	}
 	if (changed & WIPHY_PARAM_RETRY_LONG) {
-		PRINT_D(CFG80211_DBG, "Setting WIPHY_PARAM_RETRY_LONG %d\n", priv->dev->ieee80211_ptr->wiphy->retry_long);
 		pstrCfgParamVal.flag |= RETRY_LONG;
 		pstrCfgParamVal.long_retry_limit = priv->dev->ieee80211_ptr->wiphy->retry_long;
 	}
 	if (changed & WIPHY_PARAM_FRAG_THRESHOLD) {
-		PRINT_D(CFG80211_DBG, "Setting WIPHY_PARAM_FRAG_THRESHOLD %d\n", priv->dev->ieee80211_ptr->wiphy->frag_threshold);
 		pstrCfgParamVal.flag |= FRAG_THRESHOLD;
 		pstrCfgParamVal.frag_threshold = priv->dev->ieee80211_ptr->wiphy->frag_threshold;
 	}
 
 	if (changed & WIPHY_PARAM_RTS_THRESHOLD) {
-		PRINT_D(CFG80211_DBG, "Setting WIPHY_PARAM_RTS_THRESHOLD %d\n", priv->dev->ieee80211_ptr->wiphy->rts_threshold);
-
 		pstrCfgParamVal.flag |= RTS_THRESHOLD;
 		pstrCfgParamVal.rts_threshold = priv->dev->ieee80211_ptr->wiphy->rts_threshold;
 	}
 
-	PRINT_D(CFG80211_DBG, "Setting CFG params in the host interface\n");
 	s32Error = wilc_hif_set_cfg(vif, &pstrCfgParamVal);
 	if (s32Error)
 		netdev_err(priv->dev, "Error in setting WIPHY PARAMS\n");
@@ -1465,19 +1292,16 @@ static int set_pmksa(struct wiphy *wiphy, struct net_device *netdev,
 	struct wilc_priv *priv = wiphy_priv(wiphy);
 
 	vif = netdev_priv(priv->dev);
-	PRINT_D(CFG80211_DBG, "Setting PMKSA\n");
 
 
 	for (i = 0; i < priv->pmkid_list.numpmkid; i++)	{
 		if (!memcmp(pmksa->bssid, priv->pmkid_list.pmkidlist[i].bssid,
 				 ETH_ALEN)) {
 			flag = PMKID_FOUND;
-			PRINT_D(CFG80211_DBG, "PMKID already exists\n");
 			break;
 		}
 	}
 	if (i < WILC_MAX_NUM_PMKIDS) {
-		PRINT_D(CFG80211_DBG, "Setting PMKID in private structure\n");
 		memcpy(priv->pmkid_list.pmkidlist[i].bssid, pmksa->bssid,
 			    ETH_ALEN);
 		memcpy(priv->pmkid_list.pmkidlist[i].pmkid, pmksa->pmkid,
@@ -1489,10 +1313,9 @@ static int set_pmksa(struct wiphy *wiphy, struct net_device *netdev,
 		s32Error = -EINVAL;
 	}
 
-	if (!s32Error) {
-		PRINT_D(CFG80211_DBG, "Setting pmkid in the host interface\n");
+	if (!s32Error)
 		s32Error = wilc_set_pmkid_info(vif, &priv->pmkid_list);
-	}
+
 	return s32Error;
 }
 
@@ -1504,12 +1327,9 @@ static int del_pmksa(struct wiphy *wiphy, struct net_device *netdev,
 
 	struct wilc_priv *priv = wiphy_priv(wiphy);
 
-	PRINT_D(CFG80211_DBG, "Deleting PMKSA keys\n");
-
 	for (i = 0; i < priv->pmkid_list.numpmkid; i++)	{
 		if (!memcmp(pmksa->bssid, priv->pmkid_list.pmkidlist[i].bssid,
 				 ETH_ALEN)) {
-			PRINT_D(CFG80211_DBG, "Reseting PMKID values\n");
 			memset(&priv->pmkid_list.pmkidlist[i], 0, sizeof(struct host_if_pmkid));
 			break;
 		}
@@ -1536,8 +1356,6 @@ static int flush_pmksa(struct wiphy *wiphy, struct net_device *netdev)
 {
 	struct wilc_priv *priv = wiphy_priv(wiphy);
 
-	PRINT_D(CFG80211_DBG,  "Flushing  PMKID key values\n");
-
 	memset(&priv->pmkid_list, 0, sizeof(struct host_if_pmkid_attr));
 
 	return 0;
@@ -1793,8 +1611,6 @@ static int cancel_remain_on_channel(struct wiphy *wiphy,
 	priv = wiphy_priv(wiphy);
 	vif = netdev_priv(priv->dev);
 
-	PRINT_D(CFG80211_DBG, "Cancel remain on channel\n");
-
 	s32Error = wilc_listen_state_expired(vif, priv->strRemainOnChanParams.u32ListenSessionID);
 	return s32Error;
 }
@@ -1977,7 +1793,6 @@ void wilc_mgmt_frame_register(struct wiphy *wiphy, struct wireless_dev *wdev,
 static int set_cqm_rssi_config(struct wiphy *wiphy, struct net_device *dev,
 			       s32 rssi_thold, u32 rssi_hyst)
 {
-	PRINT_D(CFG80211_DBG, "Setting CQM RSSi Function\n");
 	return 0;
 }
 
@@ -1987,8 +1802,6 @@ static int dump_station(struct wiphy *wiphy, struct net_device *dev,
 	struct wilc_priv *priv;
 	struct wilc_vif *vif;
 
-	PRINT_D(CFG80211_DBG, "Dumping station information\n");
-
 	if (idx != 0)
 		return -ENOENT;
 
@@ -2008,8 +1821,6 @@ static int set_power_mgmt(struct wiphy *wiphy, struct net_device *dev,
 	struct wilc_priv *priv;
 	struct wilc_vif *vif;
 
-	PRINT_D(CFG80211_DBG, " Power save Enabled= %d , TimeOut = %d\n", enabled, timeout);
-
 	if (!wiphy)
 		return -ENOENT;
 
@@ -2193,11 +2004,6 @@ static int add_station(struct wiphy *wiphy, struct net_device *dev,
 		strStaParams.rates_len = params->supported_rates_len;
 		strStaParams.rates = params->supported_rates;
 
-		PRINT_D(CFG80211_DBG, "Adding station parameters %d\n", params->aid);
-
-		PRINT_D(CFG80211_DBG, "BSSID = %x%x%x%x%x%x\n", priv->assoc_stainfo.au8Sta_AssociatedBss[params->aid][0], priv->assoc_stainfo.au8Sta_AssociatedBss[params->aid][1], priv->assoc_stainfo.au8Sta_AssociatedBss[params->aid][2], priv->assoc_stainfo.au8Sta_AssociatedBss[params->aid][3], priv->assoc_stainfo.au8Sta_AssociatedBss[params->aid][4],
-			priv->assoc_stainfo.au8Sta_AssociatedBss[params->aid][5]);
-
 		if (!params->ht_capa) {
 			strStaParams.ht_supported = false;
 		} else {
@@ -2463,9 +2269,6 @@ static struct wireless_dev *WILC_WFI_CfgAlloc(void)
 {
 	struct wireless_dev *wdev;
 
-
-	PRINT_D(CFG80211_DBG, "Allocating wireless device\n");
-
 	wdev = kzalloc(sizeof(struct wireless_dev), GFP_KERNEL);
 	if (!wdev)
 		goto _fail_;
@@ -2496,8 +2299,6 @@ struct wireless_dev *wilc_create_wiphy(struct net_device *net, struct device *de
 	struct wireless_dev *wdev;
 	s32 s32Error = 0;
 
-	PRINT_D(CFG80211_DBG, "Registering wifi device\n");
-
 	wdev = WILC_WFI_CfgAlloc();
 	if (!wdev) {
 		netdev_err(net, "wiphy new allocate failed\n");
@@ -2512,8 +2313,6 @@ struct wireless_dev *wilc_create_wiphy(struct net_device *net, struct device *de
 	wdev->wiphy->wowlan = &wowlan_support;
 #endif
 	wdev->wiphy->max_num_pmkids = WILC_MAX_NUM_PMKIDS;
-	PRINT_INFO(CFG80211_DBG, "Max number of PMKIDs = %d\n", wdev->wiphy->max_num_pmkids);
-
 	wdev->wiphy->max_scan_ie_len = 1000;
 	wdev->wiphy->signal_type = CFG80211_SIGNAL_TYPE_MBM;
 	wdev->wiphy->cipher_suites = cipher_suites;
@@ -2526,19 +2325,11 @@ struct wireless_dev *wilc_create_wiphy(struct net_device *net, struct device *de
 	wdev->wiphy->flags |= WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL;
 	wdev->iftype = NL80211_IFTYPE_STATION;
 
-
-
-	PRINT_INFO(CFG80211_DBG, "Max scan ids = %d,Max scan IE len = %d,Signal Type = %d,Interface Modes = %d,Interface Type = %d\n",
-		   wdev->wiphy->max_scan_ssids, wdev->wiphy->max_scan_ie_len, wdev->wiphy->signal_type,
-		   wdev->wiphy->interface_modes, wdev->iftype);
-
 	set_wiphy_dev(wdev->wiphy, dev);
 
 	s32Error = wiphy_register(wdev->wiphy);
 	if (s32Error)
 		netdev_err(net, "Cannot register wiphy device\n");
-	else
-		PRINT_D(CFG80211_DBG, "Successful Registering\n");
 
 	priv->dev = net;
 	return wdev;
@@ -2599,8 +2390,6 @@ int wilc_deinit_host_int(struct net_device *net)
 
 void wilc_free_wiphy(struct net_device *net)
 {
-	PRINT_D(CFG80211_DBG, "Unregistering wiphy\n");
-
 	if (!net) {
 		PRINT_D(INIT_DBG, "net_device is NULL\n");
 		return;
-- 
1.9.1

