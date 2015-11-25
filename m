Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:10141 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755298AbbKYC4i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Nov 2015 21:56:38 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 03/10] staging: wilc1000: fixes blank lines aren't necessary brace
Date: Wed, 25 Nov 2015 11:59:42 +0900
Message-ID: <1448420389-4192-3-git-send-email-glen.lee@atmel.com> (sfid-20151125_035641_081581_8FE5DACB)
In-Reply-To: <1448420389-4192-1-git-send-email-glen.lee@atmel.com>
References: <1448420389-4192-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch fixes the checks reported by checkpatch.pl
for Blank lines aren't necessary after an open brace '{' and
Blank lines aren't necessary before a close brace '}'.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 50 -----------------------
 1 file changed, 50 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index bfef022..71038b1 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -201,7 +201,6 @@ static void clear_shadow_scan(void)
 		}
 		last_scanned_cnt = 0;
 	}
-
 }
 
 static u32 get_rssi_avg(tstrNetworkInfo *network_info)
@@ -250,10 +249,8 @@ static void refresh_scan(void *user_void, u8 all, bool direct_scan)
 					cfg80211_put_bss(wiphy, bss);
 				}
 			}
-
 		}
 	}
-
 }
 
 static void reset_shadow_found(void)
@@ -347,7 +344,6 @@ static void add_network_to_shadow(tstrNetworkInfo *pstrNetworkInfo,
 	if (ap_found == -1) {
 		ap_index = last_scanned_cnt;
 		last_scanned_cnt++;
-
 	} else {
 		ap_index = ap_found;
 	}
@@ -590,9 +586,7 @@ static void CfgConnectResult(enum conn_event enuConnDisconnEvent,
 		cfg80211_disconnected(dev, pstrDisconnectNotifInfo->u16reason, pstrDisconnectNotifInfo->ie,
 				      pstrDisconnectNotifInfo->ie_len, false,
 				      GFP_KERNEL);
-
 	}
-
 }
 
 static int set_channel(struct wiphy *wiphy,
@@ -646,14 +640,11 @@ static int scan(struct wiphy *wiphy, struct cfg80211_scan_request *request)
 		PRINT_D(CFG80211_DBG, "Number of SSIDs %d\n", request->n_ssids);
 
 		if (request->n_ssids >= 1) {
-
-
 			strHiddenNetwork.pstrHiddenNetworkInfo = kmalloc(request->n_ssids * sizeof(struct hidden_network), GFP_KERNEL);
 			strHiddenNetwork.u8ssidnum = request->n_ssids;
 
 
 			for (i = 0; i < request->n_ssids; i++) {
-
 				if (request->ssids[i].ssid != NULL && request->ssids[i].ssid_len != 0) {
 					strHiddenNetwork.pstrHiddenNetworkInfo[i].pu8ssid = kmalloc(request->ssids[i].ssid_len, GFP_KERNEL);
 					memcpy(strHiddenNetwork.pstrHiddenNetworkInfo[i].pu8ssid, request->ssids[i].ssid, request->ssids[i].ssid_len);
@@ -675,7 +666,6 @@ static int scan(struct wiphy *wiphy, struct cfg80211_scan_request *request)
 						 (const u8 *)request->ie, request->ie_len,
 						 CfgScanResult, (void *)priv, NULL);
 		}
-
 	} else {
 		PRINT_ER("Requested num of scanned channels is greater than the max, supported"
 			 " channels\n");
@@ -835,7 +825,6 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
 				u8security = ENCRYPT_ENABLED | WPA | AES;
 				pcgroup_encrypt_val = "WPA_AES";
 				pccipher_group = "AES";
-
 			}
 			pcwpa_version = "WPA_VERSION_1";
 
@@ -845,7 +834,6 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
 
 			goto done;
 		}
-
 	}
 
 	if ((sme->crypto.wpa_versions & NL80211_WPA_VERSION_1)
@@ -982,7 +970,6 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 	case WLAN_CIPHER_SUITE_WEP40:
 	case WLAN_CIPHER_SUITE_WEP104:
 		if (priv->wdev->iftype == NL80211_IFTYPE_AP) {
-
 			priv->WILC_WFI_wep_default = key_index;
 			priv->WILC_WFI_wep_key_len[key_index] = params->key_len;
 			memcpy(priv->WILC_WFI_wep_key[key_index], params->key, params->key_len);
@@ -1022,12 +1009,10 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 	case WLAN_CIPHER_SUITE_TKIP:
 	case WLAN_CIPHER_SUITE_CCMP:
 		if (priv->wdev->iftype == NL80211_IFTYPE_AP || priv->wdev->iftype == NL80211_IFTYPE_P2P_GO) {
-
 			if (priv->wilc_gtk[key_index] == NULL) {
 				priv->wilc_gtk[key_index] = kmalloc(sizeof(struct wilc_wfi_key), GFP_KERNEL);
 				priv->wilc_gtk[key_index]->key = NULL;
 				priv->wilc_gtk[key_index]->seq = NULL;
-
 			}
 			if (priv->wilc_ptk[key_index] == NULL) {
 				priv->wilc_ptk[key_index] = kmalloc(sizeof(struct wilc_wfi_key), GFP_KERNEL);
@@ -1046,7 +1031,6 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 				priv->wilc_groupkey = u8gmode;
 
 				if (params->key_len > 16 && params->cipher == WLAN_CIPHER_SUITE_TKIP) {
-
 					pu8TxMic = params->key + 24;
 					pu8RxMic = params->key + 16;
 					KeyLen = params->key_len - 16;
@@ -1087,7 +1071,6 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 
 
 				if (params->key_len > 16 && params->cipher == WLAN_CIPHER_SUITE_TKIP) {
-
 					pu8TxMic = params->key + 24;
 					pu8RxMic = params->key + 16;
 					KeyLen = params->key_len - 16;
@@ -1207,7 +1190,6 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 	default:
 		PRINT_ER("Not supported cipher: Error(%d)\n", s32Error);
 		s32Error = -ENOTSUPP;
-
 	}
 
 	return s32Error;
@@ -1235,7 +1217,6 @@ static int del_key(struct wiphy *wiphy, struct net_device *netdev,
 		g_key_wep_params.key = NULL;
 
 		if ((priv->wilc_gtk[key_index]) != NULL) {
-
 			kfree(priv->wilc_gtk[key_index]->key);
 			priv->wilc_gtk[key_index]->key = NULL;
 			kfree(priv->wilc_gtk[key_index]->seq);
@@ -1243,11 +1224,9 @@ static int del_key(struct wiphy *wiphy, struct net_device *netdev,
 
 			kfree(priv->wilc_gtk[key_index]);
 			priv->wilc_gtk[key_index] = NULL;
-
 		}
 
 		if ((priv->wilc_ptk[key_index]) != NULL) {
-
 			kfree(priv->wilc_ptk[key_index]->key);
 			priv->wilc_ptk[key_index]->key = NULL;
 			kfree(priv->wilc_ptk[key_index]->seq);
@@ -1332,7 +1311,6 @@ static int set_default_key(struct wiphy *wiphy, struct net_device *netdev, u8 ke
 	PRINT_D(CFG80211_DBG, "Setting default key with idx = %d\n", key_index);
 
 	if (key_index != priv->WILC_WFI_wep_default) {
-
 		wilc_set_wep_default_keyid(priv->hWILCWFIDrv, key_index);
 	}
 
@@ -1356,12 +1334,10 @@ static int get_station(struct wiphy *wiphy, struct net_device *dev,
 		PRINT_INFO(HOSTAPD_DBG, ": %x%x%x%x%x\n", mac[0], mac[1], mac[2], mac[3], mac[4]);
 
 		for (i = 0; i < NUM_STA_ASSOCIATED; i++) {
-
 			if (!(memcmp(mac, priv->assoc_stainfo.au8Sta_AssociatedBss[i], ETH_ALEN))) {
 				associatedsta = i;
 				break;
 			}
-
 		}
 
 		if (associatedsta == -1) {
@@ -1374,7 +1350,6 @@ static int get_station(struct wiphy *wiphy, struct net_device *dev,
 		wilc_get_inactive_time(priv->hWILCWFIDrv, mac, &(inactive_time));
 		sinfo->inactive_time = 1000 * inactive_time;
 		PRINT_D(CFG80211_DBG, "Inactive time %d\n", sinfo->inactive_time);
-
 	}
 
 	if (nic->iftype == STATION_MODE) {
@@ -1431,17 +1406,14 @@ static int set_wiphy_params(struct wiphy *wiphy, u32 changed)
 		pstrCfgParamVal.short_retry_limit = priv->dev->ieee80211_ptr->wiphy->retry_short;
 	}
 	if (changed & WIPHY_PARAM_RETRY_LONG) {
-
 		PRINT_D(CFG80211_DBG, "Setting WIPHY_PARAM_RETRY_LONG %d\n", priv->dev->ieee80211_ptr->wiphy->retry_long);
 		pstrCfgParamVal.flag |= RETRY_LONG;
 		pstrCfgParamVal.long_retry_limit = priv->dev->ieee80211_ptr->wiphy->retry_long;
-
 	}
 	if (changed & WIPHY_PARAM_FRAG_THRESHOLD) {
 		PRINT_D(CFG80211_DBG, "Setting WIPHY_PARAM_FRAG_THRESHOLD %d\n", priv->dev->ieee80211_ptr->wiphy->frag_threshold);
 		pstrCfgParamVal.flag |= FRAG_THRESHOLD;
 		pstrCfgParamVal.frag_threshold = priv->dev->ieee80211_ptr->wiphy->frag_threshold;
-
 	}
 
 	if (changed & WIPHY_PARAM_RTS_THRESHOLD) {
@@ -1449,7 +1421,6 @@ static int set_wiphy_params(struct wiphy *wiphy, u32 changed)
 
 		pstrCfgParamVal.flag |= RTS_THRESHOLD;
 		pstrCfgParamVal.rts_threshold = priv->dev->ieee80211_ptr->wiphy->rts_threshold;
-
 	}
 
 	PRINT_D(CFG80211_DBG, "Setting CFG params in the host interface\n");
@@ -1504,7 +1475,6 @@ static int set_pmksa(struct wiphy *wiphy, struct net_device *netdev,
 static int del_pmksa(struct wiphy *wiphy, struct net_device *netdev,
 		     struct cfg80211_pmksa *pmksa)
 {
-
 	u32 i;
 	s32 s32Error = 0;
 
@@ -1633,7 +1603,6 @@ static void WILC_WFI_CfgParseTxAction(u8 *buf, u32 len, bool bOperChan, u8 iftyp
 
 void WILC_WFI_p2p_rx (struct net_device *dev, u8 *buff, u32 size)
 {
-
 	struct wilc_priv *priv;
 	u32 header, pkt_offset;
 	struct host_if_drv *pstrWFIDrv;
@@ -1665,7 +1634,6 @@ void WILC_WFI_p2p_rx (struct net_device *dev, u8 *buff, u32 size)
 			return;
 		}
 	} else {
-
 		PRINT_D(GENERIC_DBG, "Rx Frame Type:%x\n", buff[FRAME_TYPE_ID]);
 
 		s32Freq = ieee80211_channel_to_frequency(curr_channel, IEEE80211_BAND_2GHZ);
@@ -1678,7 +1646,6 @@ void WILC_WFI_p2p_rx (struct net_device *dev, u8 *buff, u32 size)
 				return;
 			}
 			if (buff[ACTION_CAT_ID] == PUB_ACTION_ATTR_ID) {
-
 				switch (buff[ACTION_SUBTYPE_ID]) {
 				case GAS_INTIAL_REQ:
 					PRINT_D(GENERIC_DBG, "GAS INITIAL REQ %x\n", buff[ACTION_SUBTYPE_ID]);
@@ -1952,7 +1919,6 @@ static int mgmt_tx(struct wiphy *wiphy,
 					break;
 				}
 				}
-
 			}
 
 			PRINT_D(GENERIC_DBG, "TX: ACTION FRAME Type:%x : Chan:%d\n", buf[ACTION_SUBTYPE_ID], chan->hw_value);
@@ -1998,7 +1964,6 @@ static int mgmt_tx_cancel_wait(struct wiphy *wiphy,
 void wilc_mgmt_frame_register(struct wiphy *wiphy, struct wireless_dev *wdev,
 			      u16 frame_type, bool reg)
 {
-
 	struct wilc_priv *priv;
 	perInterface_wlan_t *nic;
 	struct wilc *wl;
@@ -2030,7 +1995,6 @@ void wilc_mgmt_frame_register(struct wiphy *wiphy, struct wireless_dev *wdev,
 	{
 		break;
 	}
-
 	}
 
 	if (!wl->initialized) {
@@ -2038,8 +2002,6 @@ void wilc_mgmt_frame_register(struct wiphy *wiphy, struct wireless_dev *wdev,
 		return;
 	}
 	wilc_frame_register(priv->hWILCWFIDrv, frame_type, reg);
-
-
 }
 
 static int set_cqm_rssi_config(struct wiphy *wiphy, struct net_device *dev,
@@ -2047,7 +2009,6 @@ static int set_cqm_rssi_config(struct wiphy *wiphy, struct net_device *dev,
 {
 	PRINT_D(CFG80211_DBG, "Setting CQM RSSi Function\n");
 	return 0;
-
 }
 
 static int dump_station(struct wiphy *wiphy, struct net_device *dev,
@@ -2067,7 +2028,6 @@ static int dump_station(struct wiphy *wiphy, struct net_device *dev,
 	wilc_get_rssi(priv->hWILCWFIDrv, &(sinfo->signal));
 
 	return 0;
-
 }
 
 static int set_power_mgmt(struct wiphy *wiphy, struct net_device *dev,
@@ -2091,7 +2051,6 @@ static int set_power_mgmt(struct wiphy *wiphy, struct net_device *dev,
 
 
 	return 0;
-
 }
 
 static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
@@ -2680,7 +2639,6 @@ static int del_virtual_intf(struct wiphy *wiphy, struct wireless_dev *wdev)
 }
 
 static struct cfg80211_ops wilc_cfg80211_ops = {
-
 	.set_monitor_channel = set_channel,
 	.scan = scan,
 	.connect = connect,
@@ -2719,12 +2677,10 @@ static struct cfg80211_ops wilc_cfg80211_ops = {
 
 int WILC_WFI_update_stats(struct wiphy *wiphy, u32 pktlen, u8 changed)
 {
-
 	struct wilc_priv *priv;
 
 	priv = wiphy_priv(wiphy);
 	switch (changed) {
-
 	case WILC_WFI_RX_PKT:
 	{
 		priv->netstats.rx_packets++;
@@ -2750,7 +2706,6 @@ int WILC_WFI_update_stats(struct wiphy *wiphy, u32 pktlen, u8 changed)
 
 static struct wireless_dev *WILC_WFI_CfgAlloc(void)
 {
-
 	struct wireless_dev *wdev;
 
 
@@ -2766,7 +2721,6 @@ static struct wireless_dev *WILC_WFI_CfgAlloc(void)
 	if (!wdev->wiphy) {
 		PRINT_ER("Cannot allocate wiphy\n");
 		goto _fail_mem_;
-
 	}
 
 	WILC_WFI_band_2ghz.ht_cap.ht_supported = 1;
@@ -2783,7 +2737,6 @@ _fail_mem_:
 	kfree(wdev);
 _fail_:
 	return NULL;
-
 }
 
 struct wireless_dev *wilc_create_wiphy(struct net_device *net, struct device *dev)
@@ -2836,13 +2789,10 @@ struct wireless_dev *wilc_create_wiphy(struct net_device *net, struct device *de
 
 	priv->dev = net;
 	return wdev;
-
-
 }
 
 int wilc_init_host_int(struct net_device *net)
 {
-
 	int s32Error = 0;
 
 	struct wilc_priv *priv;
-- 
1.9.1

