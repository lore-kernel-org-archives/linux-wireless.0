Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:43589 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932524AbbJNLrt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Oct 2015 07:47:49 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 07/16] staging: wilc1000: rename strInterfaceInfo in the struct wilc
Date: Wed, 14 Oct 2015 20:46:35 +0900
Message-ID: <1444823204-16736-7-git-send-email-tony.cho@atmel.com> (sfid-20151014_134753_869860_5E0127DE)
In-Reply-To: <1444823204-16736-1-git-send-email-tony.cho@atmel.com>
References: <1444823204-16736-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames strInterfaceInfo in the struct wilc to the vif.

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c             | 74 +++++++++++------------
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 74 +++++++++++------------
 drivers/staging/wilc1000/wilc_wfi_netdevice.h     |  2 +-
 3 files changed, 72 insertions(+), 78 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 51c21dd..43c3763 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -367,9 +367,9 @@ struct net_device *GetIfHandler(u8 *pMacHeader)
 	Bssid1 = pMacHeader + 4;
 
 	for (i = 0; i < wl->vif_num; i++)
-		if (!memcmp(Bssid1, wl->strInterfaceInfo[i].aBSSID, ETH_ALEN) ||
-		    !memcmp(Bssid, wl->strInterfaceInfo[i].aBSSID, ETH_ALEN))
-			return wl->strInterfaceInfo[i].wilc_netdev;
+		if (!memcmp(Bssid1, wl->vif[i].aBSSID, ETH_ALEN) ||
+		    !memcmp(Bssid, wl->vif[i].aBSSID, ETH_ALEN))
+			return wl->vif[i].wilc_netdev;
 
 	PRINT_INFO(INIT_DBG, "Invalide handle\n");
 	for (i = 0; i < 25; i++)
@@ -377,9 +377,9 @@ struct net_device *GetIfHandler(u8 *pMacHeader)
 	Bssid  = pMacHeader + 18;
 	Bssid1 = pMacHeader + 12;
 	for (i = 0; i < wl->vif_num; i++)
-		if (!memcmp(Bssid1, wl->strInterfaceInfo[i].aBSSID, ETH_ALEN) ||
-		    !memcmp(Bssid, wl->strInterfaceInfo[i].aBSSID, ETH_ALEN))
-			return wl->strInterfaceInfo[i].wilc_netdev;
+		if (!memcmp(Bssid1, wl->vif[i].aBSSID, ETH_ALEN) ||
+		    !memcmp(Bssid, wl->vif[i].aBSSID, ETH_ALEN))
+			return wl->vif[i].wilc_netdev;
 
 	PRINT_INFO(INIT_DBG, "\n");
 	return NULL;
@@ -392,8 +392,8 @@ int linux_wlan_set_bssid(struct net_device *wilc_netdev, u8 *pBSSID)
 
 	PRINT_D(INIT_DBG, "set bssid on[%p]\n", wilc_netdev);
 	for (i = 0; i < wl->vif_num; i++)
-		if (wl->strInterfaceInfo[i].wilc_netdev == wilc_netdev) {
-			memcpy(wl->strInterfaceInfo[i].aBSSID, pBSSID, 6);
+		if (wl->vif[i].wilc_netdev == wilc_netdev) {
+			memcpy(wl->vif[i].aBSSID, pBSSID, 6);
 			ret = 0;
 			break;
 		}
@@ -409,7 +409,7 @@ int linux_wlan_get_num_conn_ifcs(void)
 	u8 ret_val = 0;
 
 	for (i = 0; i < wl->vif_num; i++)
-		if (memcmp(wl->strInterfaceInfo[i].aBSSID, null_bssid, 6))
+		if (memcmp(wl->vif[i].aBSSID, null_bssid, 6))
 			ret_val++;
 
 	return ret_val;
@@ -458,10 +458,10 @@ static int linux_wlan_txq_task(void *vp)
 			if (txq_count < FLOW_CONTROL_LOWER_THRESHOLD /* && netif_queue_stopped(pd->wilc_netdev)*/) {
 				PRINT_D(TX_DBG, "Waking up queue\n");
 				/* netif_wake_queue(pd->wilc_netdev); */
-				if (netif_queue_stopped(wl->strInterfaceInfo[0].wilc_netdev))
-					netif_wake_queue(wl->strInterfaceInfo[0].wilc_netdev);
-				if (netif_queue_stopped(wl->strInterfaceInfo[1].wilc_netdev))
-					netif_wake_queue(wl->strInterfaceInfo[1].wilc_netdev);
+				if (netif_queue_stopped(wl->vif[0].wilc_netdev))
+					netif_wake_queue(wl->vif[0].wilc_netdev);
+				if (netif_queue_stopped(wl->vif[1].wilc_netdev))
+					netif_wake_queue(wl->vif[1].wilc_netdev);
 			}
 
 			if (ret == WILC_TX_ERR_NO_BUF) { /* failed to allocate buffers in chip. */
@@ -1311,14 +1311,14 @@ int mac_open(struct net_device *ndev)
 
 	/* loop through the NUM of supported devices and set the MAC address */
 	for (i = 0; i < wl->vif_num; i++)
-		if (ndev == wl->strInterfaceInfo[i].wilc_netdev) {
-			memcpy(wl->strInterfaceInfo[i].aSrcAddress, mac_add, ETH_ALEN);
-			wl->strInterfaceInfo[i].drvHandler = priv->hWILCWFIDrv;
+		if (ndev == wl->vif[i].wilc_netdev) {
+			memcpy(wl->vif[i].aSrcAddress, mac_add, ETH_ALEN);
+			wl->vif[i].drvHandler = priv->hWILCWFIDrv;
 			break;
 		}
 
 	/* TODO: get MAC address whenever the source is EPROM - hardcoded and copy it to ndev*/
-	memcpy(ndev->dev_addr, wl->strInterfaceInfo[i].aSrcAddress, ETH_ALEN);
+	memcpy(ndev->dev_addr, wl->vif[i].aSrcAddress, ETH_ALEN);
 
 	if (!is_valid_ether_addr(ndev->dev_addr)) {
 		PRINT_ER("Error: Wrong MAC address\n");
@@ -1470,14 +1470,14 @@ int mac_xmit(struct sk_buff *skb, struct net_device *ndev)
 	PRINT_D(TX_DBG, "Adding tx packet to TX Queue\n");
 	nic->netstats.tx_packets++;
 	nic->netstats.tx_bytes += tx_data->size;
-	tx_data->pBssid = wl->strInterfaceInfo[nic->u8IfIdx].aBSSID;
+	tx_data->pBssid = wl->vif[nic->u8IfIdx].aBSSID;
 	QueueCount = wilc_wlan_txq_add_net_pkt((void *)tx_data, tx_data->buff,
 					       tx_data->size,
 					       linux_wlan_tx_complete);
 
 	if (QueueCount > FLOW_CONTROL_UPPER_THRESHOLD) {
-		netif_stop_queue(wl->strInterfaceInfo[0].wilc_netdev);
-		netif_stop_queue(wl->strInterfaceInfo[1].wilc_netdev);
+		netif_stop_queue(wl->vif[0].wilc_netdev);
+		netif_stop_queue(wl->vif[1].wilc_netdev);
 	}
 
 	return 0;
@@ -1681,17 +1681,17 @@ void WILC_WFI_mgmt_rx(u8 *buff, u32 size)
 	/*Pass the frame on the monitor interface, if any.*/
 	/*Otherwise, pass it on p2p0 netdev, if registered on it*/
 	for (i = 0; i < wl->vif_num; i++) {
-		nic = netdev_priv(wl->strInterfaceInfo[i].wilc_netdev);
+		nic = netdev_priv(wl->vif[i].wilc_netdev);
 		if (nic->monitor_flag) {
 			WILC_WFI_monitor_rx(buff, size);
 			return;
 		}
 	}
 
-	nic = netdev_priv(wl->strInterfaceInfo[1].wilc_netdev); /* p2p0 */
+	nic = netdev_priv(wl->vif[1].wilc_netdev); /* p2p0 */
 	if ((buff[0] == nic->g_struct_frame_reg[0].frame_type && nic->g_struct_frame_reg[0].reg) ||
 	    (buff[0] == nic->g_struct_frame_reg[1].frame_type && nic->g_struct_frame_reg[1].reg))
-		WILC_WFI_p2p_rx(wl->strInterfaceInfo[1].wilc_netdev, buff, size);
+		WILC_WFI_p2p_rx(wl->vif[1].wilc_netdev, buff, size);
 }
 
 int wilc_netdev_init(void)
@@ -1735,7 +1735,7 @@ int wilc_netdev_init(void)
 
 		nic->u8IfIdx = wl->vif_num;
 		nic->wilc_netdev = ndev;
-		wl->strInterfaceInfo[wl->vif_num].wilc_netdev = ndev;
+		wl->vif[wl->vif_num].wilc_netdev = ndev;
 		wl->vif_num++;
 		ndev->netdev_ops = &wilc_netdev_ops;
 
@@ -1830,12 +1830,11 @@ static void __exit exit_wilc_driver(void)
 	perInterface_wlan_t *nic[NUM_CONCURRENT_IFC] = {NULL,};
 	#define CLOSE_TIMEOUT (12 * 1000)
 
-	if (wl && (wl->strInterfaceInfo[0].wilc_netdev ||
-	    wl->strInterfaceInfo[1].wilc_netdev)) {
+	if (wl && (wl->vif[0].wilc_netdev || wl->vif[1].wilc_netdev)) {
 		unregister_inetaddr_notifier(&g_dev_notifier);
 
 		for (i = 0; i < NUM_CONCURRENT_IFC; i++)
-			nic[i] = netdev_priv(wl->strInterfaceInfo[i].wilc_netdev);
+			nic[i] = netdev_priv(wl->vif[i].wilc_netdev);
 	}
 
 	if (wl && wl->wilc_firmware) {
@@ -1843,8 +1842,7 @@ static void __exit exit_wilc_driver(void)
 		wl->wilc_firmware = NULL;
 	}
 
-	if (wl && (wl->strInterfaceInfo[0].wilc_netdev ||
-	    wl->strInterfaceInfo[1].wilc_netdev)) {
+	if (wl && (wl->vif[0].wilc_netdev || wl->vif[1].wilc_netdev)) {
 		PRINT_D(INIT_DBG, "Waiting for mac_close ....\n");
 
 		if (linux_wlan_lock_timeout(&close_exit_sync, CLOSE_TIMEOUT) < 0)
@@ -1852,20 +1850,18 @@ static void __exit exit_wilc_driver(void)
 		else
 			PRINT_D(INIT_DBG, "mac_closed\n");
 
-		for (i = 0; i < NUM_CONCURRENT_IFC; i++) {
-			/* close all opened interfaces */
-			if (wl->strInterfaceInfo[i].wilc_netdev) {
+		for (i = 0; i < NUM_CONCURRENT_IFC; i++)
+			if (wl->vif[i].wilc_netdev)
 				if (nic[i]->mac_opened)
-					mac_close(wl->strInterfaceInfo[i].wilc_netdev);
-			}
-		}
+					mac_close(wl->vif[i].wilc_netdev);
+
 		for (i = 0; i < NUM_CONCURRENT_IFC; i++) {
-			PRINT_D(INIT_DBG, "Unregistering netdev %p\n", wl->strInterfaceInfo[i].wilc_netdev);
-			unregister_netdev(wl->strInterfaceInfo[i].wilc_netdev);
+			PRINT_D(INIT_DBG, "Unregistering netdev %p\n", wl->vif[i].wilc_netdev);
+			unregister_netdev(wl->vif[i].wilc_netdev);
 			PRINT_D(INIT_DBG, "Freeing Wiphy...\n");
-			wilc_free_wiphy(wl->strInterfaceInfo[i].wilc_netdev);
+			wilc_free_wiphy(wl->vif[i].wilc_netdev);
 			PRINT_D(INIT_DBG, "Freeing netdev...\n");
-			free_netdev(wl->strInterfaceInfo[i].wilc_netdev);
+			free_netdev(wl->vif[i].wilc_netdev);
 		}
 	}
 
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index b26caa8..b1267e9 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -624,11 +624,9 @@ static void CfgConnectResult(enum conn_event enuConnDisconnEvent,
 			u8WLANChannel = INVALID_CHANNEL;
 		/*Incase "P2P CLIENT Connected" send deauthentication reason by 3 to force the WPA_SUPPLICANT to directly change
 		 *      virtual interface to station*/
-		if (pstrWFIDrv->IFC_UP &&
-		   (dev == wl->strInterfaceInfo[1].wilc_netdev))
+		if (pstrWFIDrv->IFC_UP && (dev == wl->vif[1].wilc_netdev))
 			pstrDisconnectNotifInfo->u16reason = 3;
-		else if (!pstrWFIDrv->IFC_UP &&
-			(dev == wl->strInterfaceInfo[1].wilc_netdev))
+		else if (!pstrWFIDrv->IFC_UP && (dev == wl->vif[1].wilc_netdev))
 			pstrDisconnectNotifInfo->u16reason = 1;
 
 		cfg80211_disconnected(dev, pstrDisconnectNotifInfo->u16reason, pstrDisconnectNotifInfo->ie,
@@ -1255,7 +1253,7 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 
 				/*save keys only on interface 0 (wifi interface)*/
 				if (!g_gtk_keys_saved &&
-				    netdev == wl->strInterfaceInfo[0].wilc_netdev) {
+				    netdev == wl->vif[0].wilc_netdev) {
 					g_add_gtk_key_params.key_idx = key_index;
 					g_add_gtk_key_params.pairwise = pairwise;
 					if (!mac_addr) {
@@ -1292,7 +1290,7 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 
 				/*save keys only on interface 0 (wifi interface)*/
 				if (!g_ptk_keys_saved &&
-				    netdev == wl->strInterfaceInfo[0].wilc_netdev) {
+				    netdev == wl->vif[0].wilc_netdev) {
 					g_add_ptk_key_params.key_idx = key_index;
 					g_add_ptk_key_params.pairwise = pairwise;
 					if (!mac_addr) {
@@ -1357,7 +1355,7 @@ static int del_key(struct wiphy *wiphy, struct net_device *netdev,
 	priv = wiphy_priv(wiphy);
 
 	/*delete saved keys, if any*/
-	if (netdev == wl->strInterfaceInfo[0].wilc_netdev) {
+	if (netdev == wl->vif[0].wilc_netdev) {
 		g_ptk_keys_saved = false;
 		g_gtk_keys_saved = false;
 		g_wep_keys_saved = false;
@@ -2574,7 +2572,7 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 
 		if (wl->initialized) {
 			host_int_del_All_Rx_BASession(priv->hWILCWFIDrv,
-						      wl->strInterfaceInfo[0].aBSSID,
+						      wl->vif[0].aBSSID,
 						      TID);
 			/* ensure that the message Q is empty */
 			host_int_wait_msg_queue_idle();
@@ -2588,16 +2586,16 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 			nic->iftype = interface_type;
 
 			/*Setting interface 1 drv handler and mac address in newly downloaded FW*/
-			host_int_set_wfi_drv_handler(wl->strInterfaceInfo[0].drvHandler);
-			host_int_set_MacAddress(wl->strInterfaceInfo[0].drvHandler,
-						wl->strInterfaceInfo[0].aSrcAddress);
+			host_int_set_wfi_drv_handler(wl->vif[0].drvHandler);
+			host_int_set_MacAddress(wl->vif[0].drvHandler,
+						wl->vif[0].aSrcAddress);
 			host_int_set_operation_mode(priv->hWILCWFIDrv, STATION_MODE);
 
 			/*Add saved WEP keys, if any*/
 			if (g_wep_keys_saved) {
-				host_int_set_WEPDefaultKeyID(wl->strInterfaceInfo[0].drvHandler,
+				host_int_set_WEPDefaultKeyID(wl->vif[0].drvHandler,
 							     g_key_wep_params.key_idx);
-				host_int_add_wep_key_bss_sta(wl->strInterfaceInfo[0].drvHandler,
+				host_int_add_wep_key_bss_sta(wl->vif[0].drvHandler,
 							     g_key_wep_params.key,
 							     g_key_wep_params.key_len,
 							     g_key_wep_params.key_idx);
@@ -2615,15 +2613,15 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 				PRINT_D(CFG80211_DBG, "gtk %x %x %x\n", g_key_gtk_params.key[0],
 					g_key_gtk_params.key[1],
 					g_key_gtk_params.key[2]);
-				add_key(wl->strInterfaceInfo[0].wilc_netdev->ieee80211_ptr->wiphy,
-					wl->strInterfaceInfo[0].wilc_netdev,
+				add_key(wl->vif[0].wilc_netdev->ieee80211_ptr->wiphy,
+					wl->vif[0].wilc_netdev,
 					g_add_ptk_key_params.key_idx,
 					g_add_ptk_key_params.pairwise,
 					g_add_ptk_key_params.mac_addr,
 					(struct key_params *)(&g_key_ptk_params));
 
-				add_key(wl->strInterfaceInfo[0].wilc_netdev->ieee80211_ptr->wiphy,
-					wl->strInterfaceInfo[0].wilc_netdev,
+				add_key(wl->vif[0].wilc_netdev->ieee80211_ptr->wiphy,
+					wl->vif[0].wilc_netdev,
 					g_add_gtk_key_params.key_idx,
 					g_add_gtk_key_params.pairwise,
 					g_add_gtk_key_params.mac_addr,
@@ -2651,7 +2649,7 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 		PRINT_D(HOSTAPD_DBG, "Interface type = NL80211_IFTYPE_P2P_CLIENT\n");
 
 		host_int_del_All_Rx_BASession(priv->hWILCWFIDrv,
-					      wl->strInterfaceInfo[0].aBSSID, TID);
+					      wl->vif[0].aBSSID, TID);
 
 		dev->ieee80211_ptr->iftype = type;
 		priv->wdev->iftype = type;
@@ -2668,16 +2666,16 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 			wilc1000_wlan_init(dev, nic);
 			g_wilc_initialized = 1;
 
-			host_int_set_wfi_drv_handler(wl->strInterfaceInfo[0].drvHandler);
-			host_int_set_MacAddress(wl->strInterfaceInfo[0].drvHandler,
-						wl->strInterfaceInfo[0].aSrcAddress);
+			host_int_set_wfi_drv_handler(wl->vif[0].drvHandler);
+			host_int_set_MacAddress(wl->vif[0].drvHandler,
+						wl->vif[0].aSrcAddress);
 			host_int_set_operation_mode(priv->hWILCWFIDrv, STATION_MODE);
 
 			/*Add saved WEP keys, if any*/
 			if (g_wep_keys_saved) {
-				host_int_set_WEPDefaultKeyID(wl->strInterfaceInfo[0].drvHandler,
+				host_int_set_WEPDefaultKeyID(wl->vif[0].drvHandler,
 							     g_key_wep_params.key_idx);
-				host_int_add_wep_key_bss_sta(wl->strInterfaceInfo[0].drvHandler,
+				host_int_add_wep_key_bss_sta(wl->vif[0].drvHandler,
 							     g_key_wep_params.key,
 							     g_key_wep_params.key_len,
 							     g_key_wep_params.key_idx);
@@ -2695,15 +2693,15 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 				PRINT_D(CFG80211_DBG, "gtk %x %x %x\n", g_key_gtk_params.key[0],
 					g_key_gtk_params.key[1],
 					g_key_gtk_params.key[2]);
-				add_key(wl->strInterfaceInfo[0].wilc_netdev->ieee80211_ptr->wiphy,
-					wl->strInterfaceInfo[0].wilc_netdev,
+				add_key(wl->vif[0].wilc_netdev->ieee80211_ptr->wiphy,
+					wl->vif[0].wilc_netdev,
 					g_add_ptk_key_params.key_idx,
 					g_add_ptk_key_params.pairwise,
 					g_add_ptk_key_params.mac_addr,
 					(struct key_params *)(&g_key_ptk_params));
 
-				add_key(wl->strInterfaceInfo[0].wilc_netdev->ieee80211_ptr->wiphy,
-					wl->strInterfaceInfo[0].wilc_netdev,
+				add_key(wl->vif[0].wilc_netdev->ieee80211_ptr->wiphy,
+					wl->vif[0].wilc_netdev,
 					g_add_gtk_key_params.key_idx,
 					g_add_gtk_key_params.pairwise,
 					g_add_gtk_key_params.mac_addr,
@@ -2762,7 +2760,7 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 		/*hWaitResponse semaphore, which allows previous config*/
 		/*packets to actually take action on old FW*/
 		host_int_del_All_Rx_BASession(priv->hWILCWFIDrv,
-					      wl->strInterfaceInfo[0].aBSSID,
+					      wl->vif[0].aBSSID,
 					      TID);
 		bEnablePS = false;
 		PRINT_D(HOSTAPD_DBG, "Interface type = NL80211_IFTYPE_GO\n");
@@ -2784,16 +2782,16 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 
 
 		/*Setting interface 1 drv handler and mac address in newly downloaded FW*/
-		host_int_set_wfi_drv_handler(wl->strInterfaceInfo[0].drvHandler);
-		host_int_set_MacAddress(wl->strInterfaceInfo[0].drvHandler,
-					wl->strInterfaceInfo[0].aSrcAddress);
+		host_int_set_wfi_drv_handler(wl->vif[0].drvHandler);
+		host_int_set_MacAddress(wl->vif[0].drvHandler,
+					wl->vif[0].aSrcAddress);
 		host_int_set_operation_mode(priv->hWILCWFIDrv, AP_MODE);
 
 		/*Add saved WEP keys, if any*/
 		if (g_wep_keys_saved) {
-			host_int_set_WEPDefaultKeyID(wl->strInterfaceInfo[0].drvHandler,
+			host_int_set_WEPDefaultKeyID(wl->vif[0].drvHandler,
 						     g_key_wep_params.key_idx);
-			host_int_add_wep_key_bss_sta(wl->strInterfaceInfo[0].drvHandler,
+			host_int_add_wep_key_bss_sta(wl->vif[0].drvHandler,
 						     g_key_wep_params.key,
 						     g_key_wep_params.key_len,
 						     g_key_wep_params.key_idx);
@@ -2813,15 +2811,15 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 				g_key_gtk_params.key[1],
 				g_key_gtk_params.key[2],
 				g_key_gtk_params.cipher);
-			add_key(wl->strInterfaceInfo[0].wilc_netdev->ieee80211_ptr->wiphy,
-				wl->strInterfaceInfo[0].wilc_netdev,
+			add_key(wl->vif[0].wilc_netdev->ieee80211_ptr->wiphy,
+				wl->vif[0].wilc_netdev,
 				g_add_ptk_key_params.key_idx,
 				g_add_ptk_key_params.pairwise,
 				g_add_ptk_key_params.mac_addr,
 				(struct key_params *)(&g_key_ptk_params));
 
-			add_key(wl->strInterfaceInfo[0].wilc_netdev->ieee80211_ptr->wiphy,
-				wl->strInterfaceInfo[0].wilc_netdev,
+			add_key(wl->vif[0].wilc_netdev->ieee80211_ptr->wiphy,
+				wl->vif[0].wilc_netdev,
 				g_add_gtk_key_params.key_idx,
 				g_add_gtk_key_params.pairwise,
 				g_add_gtk_key_params.mac_addr,
@@ -2890,7 +2888,7 @@ static int start_ap(struct wiphy *wiphy, struct net_device *dev,
 	if (s32Error != 0)
 		PRINT_ER("Error in setting channel\n");
 
-	linux_wlan_set_bssid(dev, wl->strInterfaceInfo[0].aSrcAddress);
+	linux_wlan_set_bssid(dev, wl->vif[0].aSrcAddress);
 
 	s32Error = host_int_add_beacon(priv->hWILCWFIDrv,
 					settings->beacon_interval,
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index bd82d78..c903664 100644
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

