Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:11486 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750825AbeAPOC7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 Jan 2018 09:02:59 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 05/13] staging: wilc1000: rename s32Error variable to avoid camelCase notation
Date: Tue, 16 Jan 2018 19:32:23 +0530
Message-ID: <1516111351-5353-6-git-send-email-ajay.kathat@microchip.com> (sfid-20180116_150316_867367_DE60AFB2)
In-Reply-To: <1516111351-5353-1-git-send-email-ajay.kathat@microchip.com>
References: <1516111351-5353-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is cleanup patch, rename "s32Error" to fix
"Avoid CamelCase: <s32Error>" found by checkpatch.pl script.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 138 +++++++++++-----------
 1 file changed, 69 insertions(+), 69 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 7dfb230..2ca703c 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -585,7 +585,7 @@ static int scan(struct wiphy *wiphy, struct cfg80211_scan_request *request)
 {
 	struct wilc_priv *priv;
 	u32 i;
-	s32 s32Error = 0;
+	s32 ret = 0;
 	u8 au8ScanChanList[MAX_NUM_SCANNED_NETWORKS];
 	struct hidden_network strHiddenNetwork;
 	struct wilc_vif *vif;
@@ -622,14 +622,14 @@ static int scan(struct wiphy *wiphy, struct cfg80211_scan_request *request)
 					strHiddenNetwork.n_ssids -= 1;
 				}
 			}
-			s32Error = wilc_scan(vif, USER_SCAN, ACTIVE_SCAN,
+			ret = wilc_scan(vif, USER_SCAN, ACTIVE_SCAN,
 					     au8ScanChanList,
 					     request->n_channels,
 					     (const u8 *)request->ie,
 					     request->ie_len, CfgScanResult,
 					     (void *)priv, &strHiddenNetwork);
 		} else {
-			s32Error = wilc_scan(vif, USER_SCAN, ACTIVE_SCAN,
+			ret = wilc_scan(vif, USER_SCAN, ACTIVE_SCAN,
 					     au8ScanChanList,
 					     request->n_channels,
 					     (const u8 *)request->ie,
@@ -640,16 +640,16 @@ static int scan(struct wiphy *wiphy, struct cfg80211_scan_request *request)
 		netdev_err(priv->dev, "Requested scanned channels over\n");
 	}
 
-	if (s32Error != 0)
-		s32Error = -EBUSY;
+	if (ret != 0)
+		ret = -EBUSY;
 
-	return s32Error;
+	return ret;
 }
 
 static int connect(struct wiphy *wiphy, struct net_device *dev,
 		   struct cfg80211_connect_params *sme)
 {
-	s32 s32Error = 0;
+	s32 ret = 0;
 	u32 i;
 	u32 sel_bssi_idx = UINT_MAX;
 	u8 u8security = NO_ENCRYPT;
@@ -694,9 +694,9 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
 	if (sel_bssi_idx < last_scanned_cnt) {
 		pstrNetworkInfo = &last_scanned_shadow[sel_bssi_idx];
 	} else {
-		s32Error = -ENOENT;
+		ret = -ENOENT;
 		wilc_connecting = 0;
-		return s32Error;
+		return ret;
 	}
 
 	memset(priv->WILC_WFI_wep_key, 0, sizeof(priv->WILC_WFI_wep_key));
@@ -744,10 +744,10 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
 			else
 				u8security = ENCRYPT_ENABLED | WPA | AES;
 		} else {
-			s32Error = -ENOTSUPP;
+			ret = -ENOTSUPP;
 			netdev_err(dev, "Not supported cipher\n");
 			wilc_connecting = 0;
-			return s32Error;
+			return ret;
 		}
 	}
 
@@ -792,25 +792,25 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
 
 	wilc_wlan_set_bssid(dev, pstrNetworkInfo->bssid, STATION_MODE);
 
-	s32Error = wilc_set_join_req(vif, pstrNetworkInfo->bssid, sme->ssid,
+	ret = wilc_set_join_req(vif, pstrNetworkInfo->bssid, sme->ssid,
 				     sme->ssid_len, sme->ie, sme->ie_len,
 				     CfgConnectResult, (void *)priv,
 				     u8security, tenuAuth_type,
 				     pstrNetworkInfo->ch,
 				     pstrNetworkInfo->join_params);
-	if (s32Error != 0) {
+	if (ret != 0) {
 		netdev_err(dev, "wilc_set_join_req(): Error\n");
-		s32Error = -ENOENT;
+		ret = -ENOENT;
 		wilc_connecting = 0;
-		return s32Error;
+		return ret;
 	}
 
-	return s32Error;
+	return ret;
 }
 
 static int disconnect(struct wiphy *wiphy, struct net_device *dev, u16 reason_code)
 {
-	s32 s32Error = 0;
+	s32 ret = 0;
 	struct wilc_priv *priv;
 	struct host_if_drv *pstrWFIDrv;
 	struct wilc_vif *vif;
@@ -841,13 +841,13 @@ static int disconnect(struct wiphy *wiphy, struct net_device *dev, u16 reason_co
 	wilc_ie = false;
 	pstrWFIDrv->p2p_timeout = 0;
 
-	s32Error = wilc_disconnect(vif, reason_code);
-	if (s32Error != 0) {
+	ret = wilc_disconnect(vif, reason_code);
+	if (ret != 0) {
 		netdev_err(priv->dev, "Error in disconnecting\n");
-		s32Error = -EINVAL;
+		ret = -EINVAL;
 	}
 
-	return s32Error;
+	return ret;
 }
 
 static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
@@ -855,7 +855,7 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 		   const u8 *mac_addr, struct key_params *params)
 
 {
-	s32 s32Error = 0, KeyLen = params->key_len;
+	s32 ret = 0, KeyLen = params->key_len;
 	struct wilc_priv *priv;
 	const u8 *pu8RxMic = NULL;
 	const u8 *pu8TxMic = NULL;
@@ -1055,10 +1055,10 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 
 	default:
 		netdev_err(netdev, "Not supported cipher\n");
-		s32Error = -ENOTSUPP;
+		ret = -ENOTSUPP;
 	}
 
-	return s32Error;
+	return ret;
 }
 
 static int del_key(struct wiphy *wiphy, struct net_device *netdev,
@@ -1233,7 +1233,7 @@ static int change_bss(struct wiphy *wiphy, struct net_device *dev,
 
 static int set_wiphy_params(struct wiphy *wiphy, u32 changed)
 {
-	s32 s32Error = 0;
+	s32 ret = 0;
 	struct cfg_param_attr pstrCfgParamVal;
 	struct wilc_priv *priv;
 	struct wilc_vif *vif;
@@ -1261,18 +1261,18 @@ static int set_wiphy_params(struct wiphy *wiphy, u32 changed)
 		pstrCfgParamVal.rts_threshold = priv->dev->ieee80211_ptr->wiphy->rts_threshold;
 	}
 
-	s32Error = wilc_hif_set_cfg(vif, &pstrCfgParamVal);
-	if (s32Error)
+	ret = wilc_hif_set_cfg(vif, &pstrCfgParamVal);
+	if (ret)
 		netdev_err(priv->dev, "Error in setting WIPHY PARAMS\n");
 
-	return s32Error;
+	return ret;
 }
 
 static int set_pmksa(struct wiphy *wiphy, struct net_device *netdev,
 		     struct cfg80211_pmksa *pmksa)
 {
 	u32 i;
-	s32 s32Error = 0;
+	s32 ret = 0;
 	u8 flag = 0;
 	struct wilc_vif *vif;
 	struct wilc_priv *priv = wiphy_priv(wiphy);
@@ -1295,20 +1295,20 @@ static int set_pmksa(struct wiphy *wiphy, struct net_device *netdev,
 			priv->pmkid_list.numpmkid++;
 	} else {
 		netdev_err(netdev, "Invalid PMKID index\n");
-		s32Error = -EINVAL;
+		ret = -EINVAL;
 	}
 
-	if (!s32Error)
-		s32Error = wilc_set_pmkid_info(vif, &priv->pmkid_list);
+	if (!ret)
+		ret = wilc_set_pmkid_info(vif, &priv->pmkid_list);
 
-	return s32Error;
+	return ret;
 }
 
 static int del_pmksa(struct wiphy *wiphy, struct net_device *netdev,
 		     struct cfg80211_pmksa *pmksa)
 {
 	u32 i;
-	s32 s32Error = 0;
+	s32 ret = 0;
 
 	struct wilc_priv *priv = wiphy_priv(wiphy);
 
@@ -1331,10 +1331,10 @@ static int del_pmksa(struct wiphy *wiphy, struct net_device *netdev,
 		}
 		priv->pmkid_list.numpmkid--;
 	} else {
-		s32Error = -EINVAL;
+		ret = -EINVAL;
 	}
 
-	return s32Error;
+	return ret;
 }
 
 static int flush_pmksa(struct wiphy *wiphy, struct net_device *netdev)
@@ -1552,7 +1552,7 @@ static int remain_on_channel(struct wiphy *wiphy,
 			     struct ieee80211_channel *chan,
 			     unsigned int duration, u64 *cookie)
 {
-	s32 s32Error = 0;
+	s32 ret = 0;
 	struct wilc_priv *priv;
 	struct wilc_vif *vif;
 
@@ -1561,7 +1561,7 @@ static int remain_on_channel(struct wiphy *wiphy,
 
 	if (wdev->iftype == NL80211_IFTYPE_AP) {
 		netdev_dbg(vif->ndev, "Required while in AP mode\n");
-		return s32Error;
+		return ret;
 	}
 
 	curr_channel = chan->hw_value;
@@ -1895,7 +1895,7 @@ static int start_ap(struct wiphy *wiphy, struct net_device *dev,
 {
 	struct cfg80211_beacon_data *beacon = &(settings->beacon);
 	struct wilc_priv *priv;
-	s32 s32Error = 0;
+	s32 ret = 0;
 	struct wilc *wl;
 	struct wilc_vif *vif;
 
@@ -1903,9 +1903,9 @@ static int start_ap(struct wiphy *wiphy, struct net_device *dev,
 	vif = netdev_priv(dev);
 	wl = vif->wilc;
 
-	s32Error = set_channel(wiphy, &settings->chandef);
+	ret = set_channel(wiphy, &settings->chandef);
 
-	if (s32Error != 0)
+	if (ret != 0)
 		netdev_err(dev, "Error in setting channel\n");
 
 	wilc_wlan_set_bssid(dev, wl->vif[vif->idx]->src_addr, AP_MODE);
@@ -1933,7 +1933,7 @@ static int change_beacon(struct wiphy *wiphy, struct net_device *dev,
 
 static int stop_ap(struct wiphy *wiphy, struct net_device *dev)
 {
-	s32 s32Error = 0;
+	s32 ret = 0;
 	struct wilc_priv *priv;
 	struct wilc_vif *vif;
 	u8 NullBssid[ETH_ALEN] = {0};
@@ -1946,18 +1946,18 @@ static int stop_ap(struct wiphy *wiphy, struct net_device *dev)
 
 	wilc_wlan_set_bssid(dev, NullBssid, AP_MODE);
 
-	s32Error = wilc_del_beacon(vif);
+	ret = wilc_del_beacon(vif);
 
-	if (s32Error)
+	if (ret)
 		netdev_err(dev, "Host delete beacon fail\n");
 
-	return s32Error;
+	return ret;
 }
 
 static int add_station(struct wiphy *wiphy, struct net_device *dev,
 		       const u8 *mac, struct station_parameters *params)
 {
-	s32 s32Error = 0;
+	s32 ret = 0;
 	struct wilc_priv *priv;
 	struct add_sta_param strStaParams = { {0} };
 	struct wilc_vif *vif;
@@ -1985,19 +1985,19 @@ static int add_station(struct wiphy *wiphy, struct net_device *dev,
 		strStaParams.flags_mask = params->sta_flags_mask;
 		strStaParams.flags_set = params->sta_flags_set;
 
-		s32Error = wilc_add_station(vif, &strStaParams);
-		if (s32Error)
+		ret = wilc_add_station(vif, &strStaParams);
+		if (ret)
 			netdev_err(dev, "Host add station fail\n");
 	}
 
-	return s32Error;
+	return ret;
 }
 
 static int del_station(struct wiphy *wiphy, struct net_device *dev,
 		       struct station_del_parameters *params)
 {
 	const u8 *mac = params->mac;
-	s32 s32Error = 0;
+	s32 ret = 0;
 	struct wilc_priv *priv;
 	struct wilc_vif *vif;
 
@@ -2009,21 +2009,21 @@ static int del_station(struct wiphy *wiphy, struct net_device *dev,
 
 	if (vif->iftype == AP_MODE || vif->iftype == GO_MODE) {
 		if (!mac)
-			s32Error = wilc_del_allstation(vif,
+			ret = wilc_del_allstation(vif,
 				     priv->assoc_stainfo.sta_associated_bss);
 
-		s32Error = wilc_del_station(vif, mac);
+		ret = wilc_del_station(vif, mac);
 
-		if (s32Error)
+		if (ret)
 			netdev_err(dev, "Host delete station fail\n");
 	}
-	return s32Error;
+	return ret;
 }
 
 static int change_station(struct wiphy *wiphy, struct net_device *dev,
 			  const u8 *mac, struct station_parameters *params)
 {
-	s32 s32Error = 0;
+	s32 ret = 0;
 	struct wilc_priv *priv;
 	struct add_sta_param strStaParams = { {0} };
 	struct wilc_vif *vif;
@@ -2050,11 +2050,11 @@ static int change_station(struct wiphy *wiphy, struct net_device *dev,
 		strStaParams.flags_mask = params->sta_flags_mask;
 		strStaParams.flags_set = params->sta_flags_set;
 
-		s32Error = wilc_edit_station(vif, &strStaParams);
-		if (s32Error)
+		ret = wilc_edit_station(vif, &strStaParams);
+		if (ret)
 			netdev_err(dev, "Host edit station fail\n");
 	}
-	return s32Error;
+	return ret;
 }
 
 static struct wireless_dev *add_virtual_intf(struct wiphy *wiphy,
@@ -2230,7 +2230,7 @@ struct wireless_dev *wilc_create_wiphy(struct net_device *net, struct device *de
 {
 	struct wilc_priv *priv;
 	struct wireless_dev *wdev;
-	s32 s32Error = 0;
+	s32 ret = 0;
 
 	wdev = WILC_WFI_CfgAlloc();
 	if (!wdev) {
@@ -2262,8 +2262,8 @@ struct wireless_dev *wilc_create_wiphy(struct net_device *net, struct device *de
 
 	set_wiphy_dev(wdev->wiphy, dev);
 
-	s32Error = wiphy_register(wdev->wiphy);
-	if (s32Error)
+	ret = wiphy_register(wdev->wiphy);
+	if (ret)
 		netdev_err(net, "Cannot register wiphy device\n");
 
 	priv->dev = net;
@@ -2272,7 +2272,7 @@ struct wireless_dev *wilc_create_wiphy(struct net_device *net, struct device *de
 
 int wilc_init_host_int(struct net_device *net)
 {
-	int s32Error = 0;
+	int ret = 0;
 
 	struct wilc_priv *priv;
 
@@ -2288,16 +2288,16 @@ int wilc_init_host_int(struct net_device *net)
 	priv->p2p_listen_state = false;
 
 	mutex_init(&priv->scan_req_lock);
-	s32Error = wilc_init(net, &priv->hif_drv);
-	if (s32Error)
+	ret = wilc_init(net, &priv->hif_drv);
+	if (ret)
 		netdev_err(net, "Error while initializing hostinterface\n");
 
-	return s32Error;
+	return ret;
 }
 
 int wilc_deinit_host_int(struct net_device *net)
 {
-	int s32Error = 0;
+	int ret = 0;
 	struct wilc_vif *vif;
 	struct wilc_priv *priv;
 
@@ -2310,16 +2310,16 @@ int wilc_deinit_host_int(struct net_device *net)
 
 	op_ifcs--;
 
-	s32Error = wilc_deinit(vif);
+	ret = wilc_deinit(vif);
 
 	clear_shadow_scan();
 	if (op_ifcs == 0)
 		del_timer_sync(&wilc_during_ip_timer);
 
-	if (s32Error)
+	if (ret)
 		netdev_err(net, "Error while deinitializing host interface\n");
 
-	return s32Error;
+	return ret;
 }
 
 void wilc_free_wiphy(struct net_device *net)
-- 
2.7.4
