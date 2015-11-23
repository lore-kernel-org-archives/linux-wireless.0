Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:36656 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753562AbbKWNlE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Nov 2015 08:41:04 -0500
Received: by pacdm15 with SMTP id dm15so191721362pac.3
        for <linux-wireless@vger.kernel.org>; Mon, 23 Nov 2015 05:41:02 -0800 (PST)
From: Masanari Iida <standby24x7@gmail.com>
To: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
	rdunlap@infradead.org, chris.park@atmel.com, austin.shin@atmel.com,
	johnny.kim@atmel.com, linux-wireless@vger.kernel.org
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH 4/4] staging: wilc1000: Fix typo in wilc_wfi_cfgoperations.c
Date: Mon, 23 Nov 2015 22:41:20 +0900
Message-Id: <1448286080-14787-4-git-send-email-standby24x7@gmail.com> (sfid-20151123_144115_307069_2892298C)
In-Reply-To: <1448286080-14787-1-git-send-email-standby24x7@gmail.com>
References: <1448286080-14787-1-git-send-email-standby24x7@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fix some spelling typo in wilc_wfi_cfgoperations.c

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 34 +++++++++++------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 6f40522..ee09d56 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -590,7 +590,7 @@ static void CfgConnectResult(enum conn_event enuConnDisconnEvent,
 			}
 
 			if (bNeedScanRefresh) {
-				/*Also, refrsh DIRECT- results if */
+				/*Also, refresh DIRECT- results if */
 				refresh_scan(priv, 1, true);
 
 			}
@@ -1407,7 +1407,7 @@ static int del_key(struct wiphy *wiphy, struct net_device *netdev,
 		kfree(g_key_gtk_params.seq);
 		g_key_gtk_params.seq = NULL;
 
-		/*Reset WILC_CHANGING_VIR_IF register to allow adding futrue keys to CE H/W*/
+		/*Reset WILC_CHANGING_VIR_IF register to allow adding future keys to CE H/W*/
 		set_machw_change_vir_if(netdev, false);
 	}
 
@@ -1605,7 +1605,7 @@ static int get_station(struct wiphy *wiphy, struct net_device *dev,
 static int change_bss(struct wiphy *wiphy, struct net_device *dev,
 		      struct bss_parameters *params)
 {
-	PRINT_D(CFG80211_DBG, "Changing Bss parametrs\n");
+	PRINT_D(CFG80211_DBG, "Changing Bss parameters\n");
 	return 0;
 }
 
@@ -1743,7 +1743,7 @@ static int del_pmksa(struct wiphy *wiphy, struct net_device *netdev,
 		if (!memcmp(pmksa->bssid, priv->pmkid_list.pmkidlist[i].bssid,
 				 ETH_ALEN)) {
 			/*If bssid is found, reset the values*/
-			PRINT_D(CFG80211_DBG, "Reseting PMKID values\n");
+			PRINT_D(CFG80211_DBG, "Resetting PMKID values\n");
 			memset(&priv->pmkid_list.pmkidlist[i], 0, sizeof(struct host_if_pmkid));
 			break;
 		}
@@ -1923,7 +1923,7 @@ void WILC_WFI_p2p_rx (struct net_device *dev, u8 *buff, u32 size)
 	/* Get WILC header */
 	memcpy(&header, (buff - HOST_HDR_OFFSET), HOST_HDR_OFFSET);
 
-	/* The packet offset field conain info about what type of managment frame */
+	/* The packet offset field contain info about what type of management frame */
 	/* we are dealing with and ack status */
 	pkt_offset = GET_PKT_OFFSET(header);
 
@@ -2001,7 +2001,7 @@ void WILC_WFI_p2p_rx (struct net_device *dev, u8 *buff, u32 size)
 
 
 					if ((buff[P2P_PUB_ACTION_SUBTYPE] == GO_NEG_REQ || buff[P2P_PUB_ACTION_SUBTYPE] == GO_NEG_RSP) && (bWilc_ie))	{
-						PRINT_D(GENERIC_DBG, "Sending P2P to host without extra elemnt\n");
+						PRINT_D(GENERIC_DBG, "Sending P2P to host without extra element\n");
 						/* extra attribute for sig_dbm: signal strength in mBm, or 0 if unknown */
 						cfg80211_rx_mgmt(priv->wdev, s32Freq, 0, buff, size - 7, 0);
 						return;
@@ -2283,7 +2283,7 @@ static int mgmt_tx(struct wiphy *wiphy,
 							if (u8P2Plocalrandom > u8P2Precvrandom)	{
 								PRINT_D(GENERIC_DBG, "LOCAL WILL BE GO LocaRand=%02x RecvRand %02x\n", u8P2Plocalrandom, u8P2Precvrandom);
 
-								/*Search for the p2p information information element , after the Public action subtype theres a byte for teh dialog token, skip that*/
+								/*Search for the p2p information information element , after the Public action subtype theres a byte for the dialog token, skip that*/
 								for (i = P2P_PUB_ACTION_SUBTYPE + 2; i < len; i++) {
 									if (buf[i] == P2PELEM_ATTR_ID && !(memcmp(u8P2P_oui, &buf[i + 2], 4))) {
 										if (buf[P2P_PUB_ACTION_SUBTYPE] == P2P_INV_REQ || buf[P2P_PUB_ACTION_SUBTYPE] == P2P_INV_RSP)
@@ -2546,7 +2546,7 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 	g_obtainingIP = false;
 	del_timer(&hDuringIpTimer);
 	PRINT_D(GENERIC_DBG, "Changing virtual interface, enable scan\n");
-	/*Set WILC_CHANGING_VIR_IF register to disallow adding futrue keys to CE H/W*/
+	/*Set WILC_CHANGING_VIR_IF register to disallow adding future keys to CE H/W*/
 	if (g_ptk_keys_saved && g_gtk_keys_saved) {
 		set_machw_change_vir_if(dev, true);
 	}
@@ -2564,7 +2564,7 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 		nic->monitor_flag = 0;
 		nic->iftype = STATION_MODE;
 
-		/*Remove the enteries of the previously connected clients*/
+		/*Remove the entries of the previously connected clients*/
 		memset(priv->assoc_stainfo.au8Sta_AssociatedBss, 0, MAX_NUM_STA * ETH_ALEN);
 		interface_type = nic->iftype;
 		nic->iftype = STATION_MODE;
@@ -2599,7 +2599,7 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 							     g_key_wep_params.key_idx);
 			}
 
-			/*No matter the driver handler passed here, it will be overwriiten*/
+			/*No matter the driver handler passed here, it will be overwritten*/
 			/*in Handle_FlushConnect() with gu8FlushedJoinReqDrvHandler*/
 			host_int_flush_join_req(priv->hWILCWFIDrv);
 
@@ -2681,7 +2681,7 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 							     g_key_wep_params.key_idx);
 			}
 
-			/*No matter the driver handler passed here, it will be overwriiten*/
+			/*No matter the driver handler passed here, it will be overwritten*/
 			/*in Handle_FlushConnect() with gu8FlushedJoinReqDrvHandler*/
 			host_int_flush_join_req(priv->hWILCWFIDrv);
 
@@ -2797,7 +2797,7 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 						     g_key_wep_params.key_idx);
 		}
 
-		/*No matter the driver handler passed here, it will be overwriiten*/
+		/*No matter the driver handler passed here, it will be overwritten*/
 		/*in Handle_FlushConnect() with gu8FlushedJoinReqDrvHandler*/
 		host_int_flush_join_req(priv->hWILCWFIDrv);
 
@@ -3107,7 +3107,7 @@ static int change_station(struct wiphy *wiphy, struct net_device *dev,
 	perInterface_wlan_t *nic;
 
 
-	PRINT_D(HOSTAPD_DBG, "Change station paramters\n");
+	PRINT_D(HOSTAPD_DBG, "Change station parameters\n");
 
 	if (!wiphy)
 		return -EFAULT;
@@ -3403,14 +3403,14 @@ struct wireless_dev *wilc_create_wiphy(struct net_device *net)
 	/*signal strength in mBm (100*dBm) */
 	wdev->wiphy->signal_type = CFG80211_SIGNAL_TYPE_MBM;
 
-	/*Set the availaible cipher suites*/
+	/*Set the available cipher suites*/
 	wdev->wiphy->cipher_suites = cipher_suites;
 	wdev->wiphy->n_cipher_suites = ARRAY_SIZE(cipher_suites);
-	/*Setting default managment types: for register action frame:  */
+	/*Setting default management types: for register action frame:  */
 	wdev->wiphy->mgmt_stypes = wilc_wfi_cfg80211_mgmt_types;
 
 	wdev->wiphy->max_remain_on_channel_duration = 500;
-	/*Setting the wiphy interfcae mode and type before registering the wiphy*/
+	/*Setting the wiphy interface mode and type before registering the wiphy*/
 	wdev->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION) | BIT(NL80211_IFTYPE_AP) | BIT(NL80211_IFTYPE_MONITOR) | BIT(NL80211_IFTYPE_P2P_GO) |
 		BIT(NL80211_IFTYPE_P2P_CLIENT);
 	wdev->wiphy->flags |= WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL;
@@ -3464,7 +3464,7 @@ int wilc_init_host_int(struct net_device *net)
 	}
 	op_ifcs++;
 	if (s32Error < 0) {
-		PRINT_ER("Failed to creat refresh Timer\n");
+		PRINT_ER("Failed to create refresh Timer\n");
 		return s32Error;
 	}
 
-- 
2.6.3.379.g0c83680

