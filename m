Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:47423 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933526AbcBACNt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 Jan 2016 21:13:49 -0500
From: Leo Kim <leo.kim@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 1/7] staging: wilc1000: wilc_wfi_cfgoperations.c: replaces PRINT_ER with netdev_err
Date: Mon, 1 Feb 2016 11:11:19 +0900
Message-ID: <1454292685-12294-1-git-send-email-leo.kim@atmel.com> (sfid-20160201_031359_466077_5ADBFFF7)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patches replaces PRINT_ER with netdev_err.
Removes unnecessary debug logs as well.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 86 ++++++++---------------
 1 file changed, 31 insertions(+), 55 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index ccfd26a..8e15534 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -405,10 +405,8 @@ static void CfgScanResult(enum scan_event scan_event,
 
 			if (wiphy->signal_type == CFG80211_SIGNAL_TYPE_UNSPEC &&
 			    (((s32)network_info->s8rssi * 100) < 0 ||
-			    ((s32)network_info->s8rssi * 100) > 100)) {
-				PRINT_ER("wiphy signal type fial\n");
+			    ((s32)network_info->s8rssi * 100) > 100))
 				return;
-			}
 
 			if (network_info) {
 				s32Freq = ieee80211_channel_to_frequency((s32)network_info->u8channel, IEEE80211_BAND_2GHZ);
@@ -436,10 +434,6 @@ static void CfgScanResult(enum scan_event scan_event,
 										  (size_t)network_info->u16IEsLen, (((s32)network_info->s8rssi) * 100), GFP_KERNEL);
 							cfg80211_put_bss(wiphy, bss);
 						}
-
-
-					} else {
-						PRINT_ER("Discovered networks exceeded the max limit\n");
 					}
 				} else {
 					u32 i;
@@ -531,7 +525,7 @@ static void CfgConnectResult(enum conn_event enuConnDisconnEvent,
 			if (!pstrWFIDrv->p2p_connect)
 				wlan_channel = INVALID_CHANNEL;
 
-			PRINT_ER("Unspecified failure: Connection status %d : MAC status = %d\n", u16ConnectStatus, u8MacStatus);
+			netdev_err(dev, "Unspecified failure\n");
 		}
 
 		if (u16ConnectStatus == WLAN_STATUS_SUCCESS) {
@@ -572,8 +566,6 @@ static void CfgConnectResult(enum conn_event enuConnDisconnEvent,
 					u16ConnectStatus, GFP_KERNEL);
 	} else if (enuConnDisconnEvent == CONN_DISCONN_EVENT_DISCONN_NOTIF)    {
 		wilc_optaining_ip = false;
-		PRINT_ER("Received MAC_DISCONNECTED from firmware with reason %d on dev [%p]\n",
-			 pstrDisconnectNotifInfo->u16reason, priv->dev);
 		p2p_local_random = 0x01;
 		p2p_recv_random = 0x00;
 		wilc_ie = false;
@@ -612,7 +604,7 @@ static int set_channel(struct wiphy *wiphy,
 	result = wilc_set_mac_chnl_num(vif, channelnum);
 
 	if (result != 0)
-		PRINT_ER("Error in setting channel %d\n", channelnum);
+		netdev_err(priv->dev, "Error in setting channel\n");
 
 	return result;
 }
@@ -680,8 +672,7 @@ static int scan(struct wiphy *wiphy, struct cfg80211_scan_request *request)
 					     (void *)priv, NULL);
 		}
 	} else {
-		PRINT_ER("Requested num of scanned channels is greater than the max, supported"
-			 " channels\n");
+		netdev_err(priv->dev, "Requested scanned channels over\n");
 	}
 
 	if (s32Error != 0) {
@@ -843,7 +834,7 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
 
 		} else {
 			s32Error = -ENOTSUPP;
-			PRINT_ER("Not supported cipher: Error(%d)\n", s32Error);
+			netdev_err(dev, "Not supported cipher\n");
 			wilc_connecting = 0;
 			return s32Error;
 		}
@@ -909,7 +900,7 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
 				     pstrNetworkInfo->u8channel,
 				     pstrNetworkInfo->pJoinParams);
 	if (s32Error != 0) {
-		PRINT_ER("wilc_set_join_req(): Error(%d)\n", s32Error);
+		netdev_err(dev, "wilc_set_join_req(): Error\n");
 		s32Error = -ENOENT;
 		wilc_connecting = 0;
 		return s32Error;
@@ -944,7 +935,7 @@ static int disconnect(struct wiphy *wiphy, struct net_device *dev, u16 reason_co
 
 	s32Error = wilc_disconnect(vif, reason_code);
 	if (s32Error != 0) {
-		PRINT_ER("Error in disconnecting: Error(%d)\n", s32Error);
+		netdev_err(priv->dev, "Error in disconnecting\n");
 		s32Error = -EINVAL;
 	}
 
@@ -1211,7 +1202,7 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 		break;
 
 	default:
-		PRINT_ER("Not supported cipher: Error(%d)\n", s32Error);
+		netdev_err(netdev, "Not supported cipher\n");
 		s32Error = -ENOTSUPP;
 	}
 
@@ -1362,7 +1353,7 @@ static int get_station(struct wiphy *wiphy, struct net_device *dev,
 		}
 
 		if (associatedsta == -1) {
-			PRINT_ER("Station required is not associated\n");
+			netdev_err(dev, "sta required is not associated\n");
 			return -ENOENT;
 		}
 
@@ -1449,8 +1440,7 @@ static int set_wiphy_params(struct wiphy *wiphy, u32 changed)
 	PRINT_D(CFG80211_DBG, "Setting CFG params in the host interface\n");
 	s32Error = wilc_hif_set_cfg(vif, &pstrCfgParamVal);
 	if (s32Error)
-		PRINT_ER("Error in setting WIPHY PARAMS\n");
-
+		netdev_err(priv->dev, "Error in setting WIPHY PARAMS\n");
 
 	return s32Error;
 }
@@ -1485,7 +1475,7 @@ static int set_pmksa(struct wiphy *wiphy, struct net_device *netdev,
 		if (!(flag == PMKID_FOUND))
 			priv->pmkid_list.numpmkid++;
 	} else {
-		PRINT_ER("Invalid PMKID index\n");
+		netdev_err(netdev, "Invalid PMKID index\n");
 		s32Error = -EINVAL;
 	}
 
@@ -1854,16 +1844,14 @@ static int mgmt_tx(struct wiphy *wiphy,
 
 	if (ieee80211_is_mgmt(mgmt->frame_control)) {
 		mgmt_tx = kmalloc(sizeof(struct p2p_mgmt_data), GFP_KERNEL);
-		if (!mgmt_tx) {
-			PRINT_ER("Failed to allocate memory for mgmt_tx structure\n");
+		if (!mgmt_tx)
 			return -EFAULT;
-		}
+
 		mgmt_tx->buff = kmalloc(buf_len, GFP_KERNEL);
-		if (!mgmt_tx->buff) {
-			PRINT_ER("Failed to allocate memory for mgmt_tx buff\n");
+		if (!mgmt_tx->buff)
 			kfree(mgmt_tx);
 			return -EFAULT;
-		}
+
 		memcpy(mgmt_tx->buff, buf, len);
 		mgmt_tx->size = len;
 
@@ -2072,10 +2060,8 @@ static int set_power_mgmt(struct wiphy *wiphy, struct net_device *dev,
 
 	priv = wiphy_priv(wiphy);
 	vif = netdev_priv(priv->dev);
-	if (!priv->hif_drv) {
-		PRINT_ER("Driver is NULL\n");
+	if (!priv->hif_drv)
 		return -EIO;
-	}
 
 	if (wilc_enable_ps)
 		wilc_set_power_mgmt(vif, enabled, timeout);
@@ -2168,7 +2154,7 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 		break;
 
 	default:
-		PRINT_ER("Unknown interface type= %d\n", type);
+		netdev_err(dev, "Unknown interface type= %d\n", type);
 		return -EINVAL;
 	}
 
@@ -2195,7 +2181,7 @@ static int start_ap(struct wiphy *wiphy, struct net_device *dev,
 	s32Error = set_channel(wiphy, &settings->chandef);
 
 	if (s32Error != 0)
-		PRINT_ER("Error in setting channel\n");
+		netdev_err(dev, "Error in setting channel\n");
 
 	wilc_wlan_set_bssid(dev, wl->vif[vif->idx]->src_addr, AP_MODE);
 	wilc_set_power_mgmt(vif, 0, 0);
@@ -2247,7 +2233,7 @@ static int stop_ap(struct wiphy *wiphy, struct net_device *dev)
 	s32Error = wilc_del_beacon(vif);
 
 	if (s32Error)
-		PRINT_ER("Host delete beacon fail\n");
+		netdev_err(dev, "Host delete beacon fail\n");
 
 	return s32Error;
 }
@@ -2317,7 +2303,7 @@ static int add_station(struct wiphy *wiphy, struct net_device *dev,
 
 		s32Error = wilc_add_station(vif, &strStaParams);
 		if (s32Error)
-			PRINT_ER("Host add station fail\n");
+			netdev_err(dev, "Host add station fail\n");
 	}
 
 	return s32Error;
@@ -2352,7 +2338,7 @@ static int del_station(struct wiphy *wiphy, struct net_device *dev,
 		s32Error = wilc_del_station(vif, mac);
 
 		if (s32Error)
-			PRINT_ER("Host delete station fail\n");
+			netdev_err(dev, "Host delete station fail\n");
 	}
 	return s32Error;
 }
@@ -2424,7 +2410,7 @@ static int change_station(struct wiphy *wiphy, struct net_device *dev,
 
 		s32Error = wilc_edit_station(vif, &strStaParams);
 		if (s32Error)
-			PRINT_ER("Host edit station fail\n");
+			netdev_err(dev, "Host edit station fail\n");
 	}
 	return s32Error;
 }
@@ -2457,8 +2443,7 @@ static struct wireless_dev *add_virtual_intf(struct wiphy *wiphy,
 			PRINT_D(HOSTAPD_DBG, "Setting monitor flag in private structure\n");
 			vif = netdev_priv(priv->wdev->netdev);
 			vif->monitor_flag = 1;
-		} else
-			PRINT_ER("Error in initializing monitor interface\n ");
+		}
 	}
 	return priv->wdev;
 }
@@ -2612,16 +2597,12 @@ static struct wireless_dev *WILC_WFI_CfgAlloc(void)
 	PRINT_D(CFG80211_DBG, "Allocating wireless device\n");
 
 	wdev = kzalloc(sizeof(struct wireless_dev), GFP_KERNEL);
-	if (!wdev) {
-		PRINT_ER("Cannot allocate wireless device\n");
+	if (!wdev)
 		goto _fail_;
-	}
 
 	wdev->wiphy = wiphy_new(&wilc_cfg80211_ops, sizeof(struct wilc_priv));
-	if (!wdev->wiphy) {
-		PRINT_ER("Cannot allocate wiphy\n");
+	if (!wdev->wiphy)
 		goto _fail_mem_;
-	}
 
 	WILC_WFI_band_2ghz.ht_cap.ht_supported = 1;
 	WILC_WFI_band_2ghz.ht_cap.cap |= (1 << IEEE80211_HT_CAP_RX_STBC_SHIFT);
@@ -2649,7 +2630,7 @@ struct wireless_dev *wilc_create_wiphy(struct net_device *net, struct device *de
 
 	wdev = WILC_WFI_CfgAlloc();
 	if (!wdev) {
-		PRINT_ER("CfgAlloc Failed\n");
+		netdev_err(net, "wiphy new allocate failed\n");
 		return NULL;
 	}
 
@@ -2682,11 +2663,10 @@ struct wireless_dev *wilc_create_wiphy(struct net_device *net, struct device *de
 	set_wiphy_dev(wdev->wiphy, dev);
 
 	s32Error = wiphy_register(wdev->wiphy);
-	if (s32Error) {
-		PRINT_ER("Cannot register wiphy device\n");
-	} else {
+	if (s32Error)
+		netdev_err(net, "Cannot register wiphy device\n");
+	else
 		PRINT_D(CFG80211_DBG, "Successful Registering\n");
-	}
 
 	priv->dev = net;
 	return wdev;
@@ -2705,10 +2685,6 @@ int wilc_init_host_int(struct net_device *net)
 		setup_timer(&wilc_during_ip_timer, clear_duringIP, 0);
 	}
 	op_ifcs++;
-	if (s32Error < 0) {
-		PRINT_ER("Failed to creat refresh Timer\n");
-		return s32Error;
-	}
 
 	priv->gbAutoRateAdjusted = false;
 
@@ -2717,7 +2693,7 @@ int wilc_init_host_int(struct net_device *net)
 	sema_init(&(priv->hSemScanReq), 1);
 	s32Error = wilc_init(net, &priv->hif_drv);
 	if (s32Error)
-		PRINT_ER("Error while initializing hostinterface\n");
+		netdev_err(net, "Error while initializing hostinterface\n");
 
 	return s32Error;
 }
@@ -2746,7 +2722,7 @@ int wilc_deinit_host_int(struct net_device *net)
 	}
 
 	if (s32Error)
-		PRINT_ER("Error while deintializing host interface\n");
+		netdev_err(net, "Error while deintializing host interface\n");
 
 	return s32Error;
 }
-- 
1.9.1

