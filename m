Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:22895 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701AbbJTF1i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Oct 2015 01:27:38 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 03/12] staging: wilc1000: rename strInterfaceInfo in the sturct wilc
Date: Tue, 20 Oct 2015 14:26:47 +0900
Message-ID: <1445318816-21686-4-git-send-email-tony.cho@atmel.com> (sfid-20151020_072741_114339_6BB08E70)
In-Reply-To: <1445318816-21686-1-git-send-email-tony.cho@atmel.com>
References: <1445318816-21686-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames strInterfaceInfo in the struct wilc to the vif. In
addition, unnecessary print statements around it are removed in this patch.

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c             | 91 +++++++++++------------
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 72 +++++++++---------
 drivers/staging/wilc1000/wilc_wfi_netdevice.h     |  2 +-
 3 files changed, 80 insertions(+), 85 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 2bea103..971b99a 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -366,24 +366,21 @@ struct net_device *GetIfHandler(u8 *pMacHeader)
 	Bssid  = pMacHeader + 10;
 	Bssid1 = pMacHeader + 4;
 
-	for (i = 0; i < g_linux_wlan->vif_num; i++) {
-		if (!memcmp(Bssid1, g_linux_wlan->strInterfaceInfo[i].aBSSID, ETH_ALEN) ||
-		    !memcmp(Bssid, g_linux_wlan->strInterfaceInfo[i].aBSSID, ETH_ALEN))	{
-			return g_linux_wlan->strInterfaceInfo[i].wilc_netdev;
-		}
-	}
+	for (i = 0; i < g_linux_wlan->vif_num; i++)
+		if (!memcmp(Bssid1, g_linux_wlan->vif[i].aBSSID, ETH_ALEN) ||
+		    !memcmp(Bssid, g_linux_wlan->vif[i].aBSSID, ETH_ALEN))
+			return g_linux_wlan->vif[i].wilc_netdev;
+
 	PRINT_INFO(INIT_DBG, "Invalide handle\n");
 	for (i = 0; i < 25; i++)
 		PRINT_D(INIT_DBG, "%02x ", pMacHeader[i]);
 	Bssid  = pMacHeader + 18;
 	Bssid1 = pMacHeader + 12;
-	for (i = 0; i < g_linux_wlan->vif_num; i++) {
-		if (!memcmp(Bssid1, g_linux_wlan->strInterfaceInfo[i].aBSSID, ETH_ALEN) ||
-		    !memcmp(Bssid, g_linux_wlan->strInterfaceInfo[i].aBSSID, ETH_ALEN))	{
-			PRINT_D(INIT_DBG, "Ctx [%p]\n", g_linux_wlan->strInterfaceInfo[i].wilc_netdev);
-			return g_linux_wlan->strInterfaceInfo[i].wilc_netdev;
-		}
-	}
+	for (i = 0; i < g_linux_wlan->vif_num; i++)
+		if (!memcmp(Bssid1, g_linux_wlan->vif[i].aBSSID, ETH_ALEN) ||
+		    !memcmp(Bssid, g_linux_wlan->vif[i].aBSSID, ETH_ALEN))
+			return g_linux_wlan->vif[i].wilc_netdev;
+
 	PRINT_INFO(INIT_DBG, "\n");
 	return NULL;
 }
@@ -393,15 +390,13 @@ int linux_wlan_set_bssid(struct net_device *wilc_netdev, u8 *pBSSID)
 	int i = 0;
 	int ret = -1;
 
-	PRINT_D(INIT_DBG, "set bssid on[%p]\n", wilc_netdev);
-	for (i = 0; i < g_linux_wlan->vif_num; i++) {
-		if (g_linux_wlan->strInterfaceInfo[i].wilc_netdev == wilc_netdev) {
-			PRINT_D(INIT_DBG, "set bssid [%x][%x][%x]\n", pBSSID[0], pBSSID[1], pBSSID[2]);
-			memcpy(g_linux_wlan->strInterfaceInfo[i].aBSSID, pBSSID, 6);
+	for (i = 0; i < g_linux_wlan->vif_num; i++)
+		if (g_linux_wlan->vif[i].wilc_netdev == wilc_netdev) {
+			memcpy(g_linux_wlan->vif[i].aBSSID, pBSSID, 6);
 			ret = 0;
 			break;
 		}
-	}
+
 	return ret;
 }
 
@@ -412,10 +407,10 @@ int linux_wlan_get_num_conn_ifcs(void)
 	u8 null_bssid[6] = {0};
 	u8 ret_val = 0;
 
-	for (i = 0; i < g_linux_wlan->vif_num; i++) {
-		if (memcmp(g_linux_wlan->strInterfaceInfo[i].aBSSID, null_bssid, 6))
+	for (i = 0; i < g_linux_wlan->vif_num; i++)
+		if (memcmp(g_linux_wlan->vif[i].aBSSID, null_bssid, 6))
 			ret_val++;
-	}
+
 	return ret_val;
 }
 
@@ -462,10 +457,10 @@ static int linux_wlan_txq_task(void *vp)
 			if (txq_count < FLOW_CONTROL_LOWER_THRESHOLD /* && netif_queue_stopped(pd->wilc_netdev)*/) {
 				PRINT_D(TX_DBG, "Waking up queue\n");
 				/* netif_wake_queue(pd->wilc_netdev); */
-				if (netif_queue_stopped(g_linux_wlan->strInterfaceInfo[0].wilc_netdev))
-					netif_wake_queue(g_linux_wlan->strInterfaceInfo[0].wilc_netdev);
-				if (netif_queue_stopped(g_linux_wlan->strInterfaceInfo[1].wilc_netdev))
-					netif_wake_queue(g_linux_wlan->strInterfaceInfo[1].wilc_netdev);
+				if (netif_queue_stopped(g_linux_wlan->vif[0].wilc_netdev))
+					netif_wake_queue(g_linux_wlan->vif[0].wilc_netdev);
+				if (netif_queue_stopped(g_linux_wlan->vif[1].wilc_netdev))
+					netif_wake_queue(g_linux_wlan->vif[1].wilc_netdev);
 			}
 
 			if (ret == WILC_TX_ERR_NO_BUF) { /* failed to allocate buffers in chip. */
@@ -1317,15 +1312,15 @@ int mac_open(struct net_device *ndev)
 
 	/* loop through the NUM of supported devices and set the MAC address */
 	for (i = 0; i < g_linux_wlan->vif_num; i++) {
-		if (ndev == g_linux_wlan->strInterfaceInfo[i].wilc_netdev) {
-			memcpy(g_linux_wlan->strInterfaceInfo[i].aSrcAddress, mac_add, ETH_ALEN);
-			g_linux_wlan->strInterfaceInfo[i].drvHandler = priv->hWILCWFIDrv;
+		if (ndev == g_linux_wlan->vif[i].wilc_netdev) {
+			memcpy(g_linux_wlan->vif[i].aSrcAddress, mac_add, ETH_ALEN);
+			g_linux_wlan->vif[i].drvHandler = priv->hWILCWFIDrv;
 			break;
 		}
 	}
 
 	/* TODO: get MAC address whenever the source is EPROM - hardcoded and copy it to ndev*/
-	memcpy(ndev->dev_addr, g_linux_wlan->strInterfaceInfo[i].aSrcAddress, ETH_ALEN);
+	memcpy(ndev->dev_addr, g_linux_wlan->vif[i].aSrcAddress, ETH_ALEN);
 
 	if (!is_valid_ether_addr(ndev->dev_addr)) {
 		PRINT_ER("Error: Wrong MAC address\n");
@@ -1477,14 +1472,14 @@ int mac_xmit(struct sk_buff *skb, struct net_device *ndev)
 	PRINT_D(TX_DBG, "Adding tx packet to TX Queue\n");
 	nic->netstats.tx_packets++;
 	nic->netstats.tx_bytes += tx_data->size;
-	tx_data->pBssid = g_linux_wlan->strInterfaceInfo[nic->u8IfIdx].aBSSID;
+	tx_data->pBssid = g_linux_wlan->vif[nic->u8IfIdx].aBSSID;
 	QueueCount = wilc_wlan_txq_add_net_pkt((void *)tx_data, tx_data->buff,
 					       tx_data->size,
 					       linux_wlan_tx_complete);
 
 	if (QueueCount > FLOW_CONTROL_UPPER_THRESHOLD) {
-		netif_stop_queue(g_linux_wlan->strInterfaceInfo[0].wilc_netdev);
-		netif_stop_queue(g_linux_wlan->strInterfaceInfo[1].wilc_netdev);
+		netif_stop_queue(g_linux_wlan->vif[0].wilc_netdev);
+		netif_stop_queue(g_linux_wlan->vif[1].wilc_netdev);
 	}
 
 	return 0;
@@ -1688,17 +1683,17 @@ void WILC_WFI_mgmt_rx(u8 *buff, u32 size)
 	/*Pass the frame on the monitor interface, if any.*/
 	/*Otherwise, pass it on p2p0 netdev, if registered on it*/
 	for (i = 0; i < g_linux_wlan->vif_num; i++) {
-		nic = netdev_priv(g_linux_wlan->strInterfaceInfo[i].wilc_netdev);
+		nic = netdev_priv(g_linux_wlan->vif[i].wilc_netdev);
 		if (nic->monitor_flag) {
 			WILC_WFI_monitor_rx(buff, size);
 			return;
 		}
 	}
 
-	nic = netdev_priv(g_linux_wlan->strInterfaceInfo[1].wilc_netdev); /* p2p0 */
+	nic = netdev_priv(g_linux_wlan->vif[1].wilc_netdev); /* p2p0 */
 	if ((buff[0] == nic->g_struct_frame_reg[0].frame_type && nic->g_struct_frame_reg[0].reg) ||
 	    (buff[0] == nic->g_struct_frame_reg[1].frame_type && nic->g_struct_frame_reg[1].reg))
-		WILC_WFI_p2p_rx(g_linux_wlan->strInterfaceInfo[1].wilc_netdev, buff, size);
+		WILC_WFI_p2p_rx(g_linux_wlan->vif[1].wilc_netdev, buff, size);
 }
 
 int wilc_netdev_init(void)
@@ -1742,7 +1737,7 @@ int wilc_netdev_init(void)
 
 		nic->u8IfIdx = g_linux_wlan->vif_num;
 		nic->wilc_netdev = ndev;
-		g_linux_wlan->strInterfaceInfo[g_linux_wlan->vif_num].wilc_netdev = ndev;
+		g_linux_wlan->vif[g_linux_wlan->vif_num].wilc_netdev = ndev;
 		g_linux_wlan->vif_num++;
 		ndev->netdev_ops = &wilc_netdev_ops;
 
@@ -1837,12 +1832,12 @@ static void __exit exit_wilc_driver(void)
 	perInterface_wlan_t *nic[NUM_CONCURRENT_IFC] = {NULL,};
 	#define CLOSE_TIMEOUT (12 * 1000)
 
-	if ((g_linux_wlan != NULL) && (((g_linux_wlan->strInterfaceInfo[0].wilc_netdev) != NULL)
-				       || ((g_linux_wlan->strInterfaceInfo[1].wilc_netdev) != NULL))) {
+	if ((g_linux_wlan != NULL) && (((g_linux_wlan->vif[0].wilc_netdev) != NULL)
+				       || ((g_linux_wlan->vif[1].wilc_netdev) != NULL))) {
 		unregister_inetaddr_notifier(&g_dev_notifier);
 
 		for (i = 0; i < NUM_CONCURRENT_IFC; i++)
-			nic[i] = netdev_priv(g_linux_wlan->strInterfaceInfo[i].wilc_netdev);
+			nic[i] = netdev_priv(g_linux_wlan->vif[i].wilc_netdev);
 	}
 
 	if ((g_linux_wlan != NULL) && g_linux_wlan->wilc_firmware != NULL) {
@@ -1850,8 +1845,8 @@ static void __exit exit_wilc_driver(void)
 		g_linux_wlan->wilc_firmware = NULL;
 	}
 
-	if ((g_linux_wlan != NULL) && (((g_linux_wlan->strInterfaceInfo[0].wilc_netdev) != NULL)
-				       || ((g_linux_wlan->strInterfaceInfo[1].wilc_netdev) != NULL))) {
+	if ((g_linux_wlan != NULL) && (((g_linux_wlan->vif[0].wilc_netdev) != NULL)
+				       || ((g_linux_wlan->vif[1].wilc_netdev) != NULL))) {
 		PRINT_D(INIT_DBG, "Waiting for mac_close ....\n");
 
 		if (linux_wlan_lock_timeout(&close_exit_sync, CLOSE_TIMEOUT) < 0)
@@ -1861,18 +1856,18 @@ static void __exit exit_wilc_driver(void)
 
 		for (i = 0; i < NUM_CONCURRENT_IFC; i++) {
 			/* close all opened interfaces */
-			if (g_linux_wlan->strInterfaceInfo[i].wilc_netdev != NULL) {
+			if (g_linux_wlan->vif[i].wilc_netdev != NULL) {
 				if (nic[i]->mac_opened)
-					mac_close(g_linux_wlan->strInterfaceInfo[i].wilc_netdev);
+					mac_close(g_linux_wlan->vif[i].wilc_netdev);
 			}
 		}
 		for (i = 0; i < NUM_CONCURRENT_IFC; i++) {
-			PRINT_D(INIT_DBG, "Unregistering netdev %p\n", g_linux_wlan->strInterfaceInfo[i].wilc_netdev);
-			unregister_netdev(g_linux_wlan->strInterfaceInfo[i].wilc_netdev);
+			PRINT_D(INIT_DBG, "Unregistering netdev %p\n", g_linux_wlan->vif[i].wilc_netdev);
+			unregister_netdev(g_linux_wlan->vif[i].wilc_netdev);
 			PRINT_D(INIT_DBG, "Freeing Wiphy...\n");
-			wilc_free_wiphy(g_linux_wlan->strInterfaceInfo[i].wilc_netdev);
+			wilc_free_wiphy(g_linux_wlan->vif[i].wilc_netdev);
 			PRINT_D(INIT_DBG, "Freeing netdev...\n");
-			free_netdev(g_linux_wlan->strInterfaceInfo[i].wilc_netdev);
+			free_netdev(g_linux_wlan->vif[i].wilc_netdev);
 		}
 	}
 
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index e463090..f2c8a45 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -624,12 +624,12 @@ static void CfgConnectResult(enum conn_event enuConnDisconnEvent,
 			u8WLANChannel = INVALID_CHANNEL;
 		/*Incase "P2P CLIENT Connected" send deauthentication reason by 3 to force the WPA_SUPPLICANT to directly change
 		 *      virtual interface to station*/
-		if ((pstrWFIDrv->IFC_UP) && (dev == g_linux_wlan->strInterfaceInfo[1].wilc_netdev)) {
+		if ((pstrWFIDrv->IFC_UP) && (dev == g_linux_wlan->vif[1].wilc_netdev)) {
 			pstrDisconnectNotifInfo->u16reason = 3;
 		}
 		/*Incase "P2P CLIENT during connection(not connected)" send deauthentication reason by 1 to force the WPA_SUPPLICANT
 		 *      to scan again and retry the connection*/
-		else if ((!pstrWFIDrv->IFC_UP) && (dev == g_linux_wlan->strInterfaceInfo[1].wilc_netdev)) {
+		else if ((!pstrWFIDrv->IFC_UP) && (dev == g_linux_wlan->vif[1].wilc_netdev)) {
 			pstrDisconnectNotifInfo->u16reason = 1;
 		}
 		cfg80211_disconnected(dev, pstrDisconnectNotifInfo->u16reason, pstrDisconnectNotifInfo->ie,
@@ -1255,7 +1255,7 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 				}
 
 				/*save keys only on interface 0 (wifi interface)*/
-				if (!g_gtk_keys_saved && netdev == g_linux_wlan->strInterfaceInfo[0].wilc_netdev) {
+				if (!g_gtk_keys_saved && netdev == g_linux_wlan->vif[0].wilc_netdev) {
 					g_add_gtk_key_params.key_idx = key_index;
 					g_add_gtk_key_params.pairwise = pairwise;
 					if (!mac_addr) {
@@ -1291,7 +1291,7 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 				}
 
 				/*save keys only on interface 0 (wifi interface)*/
-				if (!g_ptk_keys_saved && netdev == g_linux_wlan->strInterfaceInfo[0].wilc_netdev) {
+				if (!g_ptk_keys_saved && netdev == g_linux_wlan->vif[0].wilc_netdev) {
 					g_add_ptk_key_params.key_idx = key_index;
 					g_add_ptk_key_params.pairwise = pairwise;
 					if (!mac_addr) {
@@ -1356,7 +1356,7 @@ static int del_key(struct wiphy *wiphy, struct net_device *netdev,
 	priv = wiphy_priv(wiphy);
 
 	/*delete saved keys, if any*/
-	if (netdev == g_linux_wlan->strInterfaceInfo[0].wilc_netdev) {
+	if (netdev == g_linux_wlan->vif[0].wilc_netdev) {
 		g_ptk_keys_saved = false;
 		g_gtk_keys_saved = false;
 		g_wep_keys_saved = false;
@@ -2572,7 +2572,7 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 		nic->iftype = STATION_MODE;
 
 		if (g_linux_wlan->initialized) {
-			host_int_del_All_Rx_BASession(priv->hWILCWFIDrv, g_linux_wlan->strInterfaceInfo[0].aBSSID, TID);
+			host_int_del_All_Rx_BASession(priv->hWILCWFIDrv, g_linux_wlan->vif[0].aBSSID, TID);
 			/* ensure that the message Q is empty */
 			host_int_wait_msg_queue_idle();
 
@@ -2585,16 +2585,16 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 			nic->iftype = interface_type;
 
 			/*Setting interface 1 drv handler and mac address in newly downloaded FW*/
-			host_int_set_wfi_drv_handler(g_linux_wlan->strInterfaceInfo[0].drvHandler);
-			host_int_set_MacAddress(g_linux_wlan->strInterfaceInfo[0].drvHandler,
-						g_linux_wlan->strInterfaceInfo[0].aSrcAddress);
+			host_int_set_wfi_drv_handler(g_linux_wlan->vif[0].drvHandler);
+			host_int_set_MacAddress(g_linux_wlan->vif[0].drvHandler,
+						g_linux_wlan->vif[0].aSrcAddress);
 			host_int_set_operation_mode(priv->hWILCWFIDrv, STATION_MODE);
 
 			/*Add saved WEP keys, if any*/
 			if (g_wep_keys_saved) {
-				host_int_set_WEPDefaultKeyID(g_linux_wlan->strInterfaceInfo[0].drvHandler,
+				host_int_set_WEPDefaultKeyID(g_linux_wlan->vif[0].drvHandler,
 							     g_key_wep_params.key_idx);
-				host_int_add_wep_key_bss_sta(g_linux_wlan->strInterfaceInfo[0].drvHandler,
+				host_int_add_wep_key_bss_sta(g_linux_wlan->vif[0].drvHandler,
 							     g_key_wep_params.key,
 							     g_key_wep_params.key_len,
 							     g_key_wep_params.key_idx);
@@ -2612,15 +2612,15 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 				PRINT_D(CFG80211_DBG, "gtk %x %x %x\n", g_key_gtk_params.key[0],
 					g_key_gtk_params.key[1],
 					g_key_gtk_params.key[2]);
-				add_key(g_linux_wlan->strInterfaceInfo[0].wilc_netdev->ieee80211_ptr->wiphy,
-					g_linux_wlan->strInterfaceInfo[0].wilc_netdev,
+				add_key(g_linux_wlan->vif[0].wilc_netdev->ieee80211_ptr->wiphy,
+					g_linux_wlan->vif[0].wilc_netdev,
 					g_add_ptk_key_params.key_idx,
 					g_add_ptk_key_params.pairwise,
 					g_add_ptk_key_params.mac_addr,
 					(struct key_params *)(&g_key_ptk_params));
 
-				add_key(g_linux_wlan->strInterfaceInfo[0].wilc_netdev->ieee80211_ptr->wiphy,
-					g_linux_wlan->strInterfaceInfo[0].wilc_netdev,
+				add_key(g_linux_wlan->vif[0].wilc_netdev->ieee80211_ptr->wiphy,
+					g_linux_wlan->vif[0].wilc_netdev,
 					g_add_gtk_key_params.key_idx,
 					g_add_gtk_key_params.pairwise,
 					g_add_gtk_key_params.mac_addr,
@@ -2648,7 +2648,7 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 		connecting = 0;
 		PRINT_D(HOSTAPD_DBG, "Interface type = NL80211_IFTYPE_P2P_CLIENT\n");
 
-		host_int_del_All_Rx_BASession(priv->hWILCWFIDrv, g_linux_wlan->strInterfaceInfo[0].aBSSID, TID);
+		host_int_del_All_Rx_BASession(priv->hWILCWFIDrv, g_linux_wlan->vif[0].aBSSID, TID);
 
 		dev->ieee80211_ptr->iftype = type;
 		priv->wdev->iftype = type;
@@ -2666,16 +2666,16 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 			wilc1000_wlan_init(dev, nic);
 			g_wilc_initialized = 1;
 
-			host_int_set_wfi_drv_handler(g_linux_wlan->strInterfaceInfo[0].drvHandler);
-			host_int_set_MacAddress(g_linux_wlan->strInterfaceInfo[0].drvHandler,
-						g_linux_wlan->strInterfaceInfo[0].aSrcAddress);
+			host_int_set_wfi_drv_handler(g_linux_wlan->vif[0].drvHandler);
+			host_int_set_MacAddress(g_linux_wlan->vif[0].drvHandler,
+						g_linux_wlan->vif[0].aSrcAddress);
 			host_int_set_operation_mode(priv->hWILCWFIDrv, STATION_MODE);
 
 			/*Add saved WEP keys, if any*/
 			if (g_wep_keys_saved) {
-				host_int_set_WEPDefaultKeyID(g_linux_wlan->strInterfaceInfo[0].drvHandler,
+				host_int_set_WEPDefaultKeyID(g_linux_wlan->vif[0].drvHandler,
 							     g_key_wep_params.key_idx);
-				host_int_add_wep_key_bss_sta(g_linux_wlan->strInterfaceInfo[0].drvHandler,
+				host_int_add_wep_key_bss_sta(g_linux_wlan->vif[0].drvHandler,
 							     g_key_wep_params.key,
 							     g_key_wep_params.key_len,
 							     g_key_wep_params.key_idx);
@@ -2693,15 +2693,15 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 				PRINT_D(CFG80211_DBG, "gtk %x %x %x\n", g_key_gtk_params.key[0],
 					g_key_gtk_params.key[1],
 					g_key_gtk_params.key[2]);
-				add_key(g_linux_wlan->strInterfaceInfo[0].wilc_netdev->ieee80211_ptr->wiphy,
-					g_linux_wlan->strInterfaceInfo[0].wilc_netdev,
+				add_key(g_linux_wlan->vif[0].wilc_netdev->ieee80211_ptr->wiphy,
+					g_linux_wlan->vif[0].wilc_netdev,
 					g_add_ptk_key_params.key_idx,
 					g_add_ptk_key_params.pairwise,
 					g_add_ptk_key_params.mac_addr,
 					(struct key_params *)(&g_key_ptk_params));
 
-				add_key(g_linux_wlan->strInterfaceInfo[0].wilc_netdev->ieee80211_ptr->wiphy,
-					g_linux_wlan->strInterfaceInfo[0].wilc_netdev,
+				add_key(g_linux_wlan->vif[0].wilc_netdev->ieee80211_ptr->wiphy,
+					g_linux_wlan->vif[0].wilc_netdev,
 					g_add_gtk_key_params.key_idx,
 					g_add_gtk_key_params.pairwise,
 					g_add_gtk_key_params.mac_addr,
@@ -2760,7 +2760,7 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 		/*sent before downloading new FW. This is because it blocks on*/
 		/*hWaitResponse semaphore, which allows previous config*/
 		/*packets to actually take action on old FW*/
-		host_int_del_All_Rx_BASession(priv->hWILCWFIDrv, g_linux_wlan->strInterfaceInfo[0].aBSSID, TID);
+		host_int_del_All_Rx_BASession(priv->hWILCWFIDrv, g_linux_wlan->vif[0].aBSSID, TID);
 		bEnablePS = false;
 		PRINT_D(HOSTAPD_DBG, "Interface type = NL80211_IFTYPE_GO\n");
 		dev->ieee80211_ptr->iftype = type;
@@ -2781,16 +2781,16 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 
 
 		/*Setting interface 1 drv handler and mac address in newly downloaded FW*/
-		host_int_set_wfi_drv_handler(g_linux_wlan->strInterfaceInfo[0].drvHandler);
-		host_int_set_MacAddress(g_linux_wlan->strInterfaceInfo[0].drvHandler,
-					g_linux_wlan->strInterfaceInfo[0].aSrcAddress);
+		host_int_set_wfi_drv_handler(g_linux_wlan->vif[0].drvHandler);
+		host_int_set_MacAddress(g_linux_wlan->vif[0].drvHandler,
+					g_linux_wlan->vif[0].aSrcAddress);
 		host_int_set_operation_mode(priv->hWILCWFIDrv, AP_MODE);
 
 		/*Add saved WEP keys, if any*/
 		if (g_wep_keys_saved) {
-			host_int_set_WEPDefaultKeyID(g_linux_wlan->strInterfaceInfo[0].drvHandler,
+			host_int_set_WEPDefaultKeyID(g_linux_wlan->vif[0].drvHandler,
 						     g_key_wep_params.key_idx);
-			host_int_add_wep_key_bss_sta(g_linux_wlan->strInterfaceInfo[0].drvHandler,
+			host_int_add_wep_key_bss_sta(g_linux_wlan->vif[0].drvHandler,
 						     g_key_wep_params.key,
 						     g_key_wep_params.key_len,
 						     g_key_wep_params.key_idx);
@@ -2810,15 +2810,15 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 				g_key_gtk_params.key[1],
 				g_key_gtk_params.key[2],
 				g_key_gtk_params.cipher);
-			add_key(g_linux_wlan->strInterfaceInfo[0].wilc_netdev->ieee80211_ptr->wiphy,
-				g_linux_wlan->strInterfaceInfo[0].wilc_netdev,
+			add_key(g_linux_wlan->vif[0].wilc_netdev->ieee80211_ptr->wiphy,
+				g_linux_wlan->vif[0].wilc_netdev,
 				g_add_ptk_key_params.key_idx,
 				g_add_ptk_key_params.pairwise,
 				g_add_ptk_key_params.mac_addr,
 				(struct key_params *)(&g_key_ptk_params));
 
-			add_key(g_linux_wlan->strInterfaceInfo[0].wilc_netdev->ieee80211_ptr->wiphy,
-				g_linux_wlan->strInterfaceInfo[0].wilc_netdev,
+			add_key(g_linux_wlan->vif[0].wilc_netdev->ieee80211_ptr->wiphy,
+				g_linux_wlan->vif[0].wilc_netdev,
 				g_add_gtk_key_params.key_idx,
 				g_add_gtk_key_params.pairwise,
 				g_add_gtk_key_params.mac_addr,
@@ -2888,7 +2888,7 @@ static int start_ap(struct wiphy *wiphy, struct net_device *dev,
 	if (s32Error != 0)
 		PRINT_ER("Error in setting channel\n");
 
-	linux_wlan_set_bssid(dev, g_linux_wlan->strInterfaceInfo[0].aSrcAddress);
+	linux_wlan_set_bssid(dev, g_linux_wlan->vif[0].aSrcAddress);
 
 	s32Error = host_int_add_beacon(priv->hWILCWFIDrv,
 					settings->beacon_interval,
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index a3f18b5..71cd3de 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -163,7 +163,7 @@ struct wilc {
 	#endif
 	int close;
 	u8 vif_num;
-	struct wilc_vif strInterfaceInfo[NUM_CONCURRENT_IFC];
+	struct wilc_vif vif[NUM_CONCURRENT_IFC];
 	u8 open_ifcs;
 
 	struct semaphore txq_add_to_head_cs;
-- 
1.9.1

