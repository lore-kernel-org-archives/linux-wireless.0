Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:10302 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752475AbbK0GrY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Nov 2015 01:47:24 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 2/3] staging: wilc1000: change vif to pointer to refence real private data
Date: Fri, 27 Nov 2015 15:50:32 +0900
Message-ID: <1448607033-25354-3-git-send-email-glen.lee@atmel.com> (sfid-20151127_074727_349562_B0AF4489)
In-Reply-To: <1448607033-25354-1-git-send-email-glen.lee@atmel.com>
References: <1448607033-25354-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

vif of struct has it's own memory which is not necessary because we have
allocated vif from netdev_priv.
Change vif to pointer type and assign vif which is netdev private data.
Change it's operator on related codes as well.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c             | 65 ++++++++++----------
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 72 +++++++++++------------
 drivers/staging/wilc1000/wilc_wfi_netdevice.h     |  2 +-
 3 files changed, 70 insertions(+), 69 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 263d9d8..810d7ce 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -289,9 +289,9 @@ static struct net_device *get_if_handler(struct wilc *wilc, u8 *mac_header)
 	bssid1 = mac_header + 4;
 
 	for (i = 0; i < wilc->vif_num; i++)
-		if (!memcmp(bssid1, wilc->vif[i].bssid, ETH_ALEN) ||
-		    !memcmp(bssid, wilc->vif[i].bssid, ETH_ALEN))
-			return wilc->vif[i].ndev;
+		if (!memcmp(bssid1, wilc->vif[i]->bssid, ETH_ALEN) ||
+		    !memcmp(bssid, wilc->vif[i]->bssid, ETH_ALEN))
+			return wilc->vif[i]->ndev;
 
 	PRINT_INFO(INIT_DBG, "Invalide handle\n");
 	for (i = 0; i < 25; i++)
@@ -299,9 +299,9 @@ static struct net_device *get_if_handler(struct wilc *wilc, u8 *mac_header)
 	bssid = mac_header + 18;
 	bssid1 = mac_header + 12;
 	for (i = 0; i < wilc->vif_num; i++)
-		if (!memcmp(bssid1, wilc->vif[i].bssid, ETH_ALEN) ||
-		    !memcmp(bssid, wilc->vif[i].bssid, ETH_ALEN))
-			return wilc->vif[i].ndev;
+		if (!memcmp(bssid1, wilc->vif[i]->bssid, ETH_ALEN) ||
+		    !memcmp(bssid, wilc->vif[i]->bssid, ETH_ALEN))
+			return wilc->vif[i]->ndev;
 
 	PRINT_INFO(INIT_DBG, "\n");
 	return NULL;
@@ -318,8 +318,8 @@ int wilc_wlan_set_bssid(struct net_device *wilc_netdev, u8 *bssid)
 	wilc = vif->wilc;
 
 	for (i = 0; i < wilc->vif_num; i++)
-		if (wilc->vif[i].ndev == wilc_netdev) {
-			memcpy(wilc->vif[i].bssid, bssid, 6);
+		if (wilc->vif[i]->ndev == wilc_netdev) {
+			memcpy(wilc->vif[i]->bssid, bssid, 6);
 			ret = 0;
 			break;
 		}
@@ -334,7 +334,7 @@ int wilc_wlan_get_num_conn_ifcs(struct wilc *wilc)
 	u8 ret_val = 0;
 
 	for (i = 0; i < wilc->vif_num; i++)
-		if (memcmp(wilc->vif[i].bssid, null_bssid, 6))
+		if (memcmp(wilc->vif[i]->bssid, null_bssid, 6))
 			ret_val++;
 
 	return ret_val;
@@ -384,10 +384,10 @@ static int linux_wlan_txq_task(void *vp)
 			if (txq_count < FLOW_CONTROL_LOWER_THRESHOLD) {
 				PRINT_D(TX_DBG, "Waking up queue\n");
 
-				if (netif_queue_stopped(wl->vif[0].ndev))
-					netif_wake_queue(wl->vif[0].ndev);
-				if (netif_queue_stopped(wl->vif[1].ndev))
-					netif_wake_queue(wl->vif[1].ndev);
+				if (netif_queue_stopped(wl->vif[0]->ndev))
+					netif_wake_queue(wl->vif[0]->ndev);
+				if (netif_queue_stopped(wl->vif[1]->ndev))
+					netif_wake_queue(wl->vif[1]->ndev);
 			}
 
 			if (ret == WILC_TX_ERR_NO_BUF) {
@@ -1034,14 +1034,14 @@ int wilc_mac_open(struct net_device *ndev)
 	PRINT_D(INIT_DBG, "Mac address: %pM\n", mac_add);
 
 	for (i = 0; i < wl->vif_num; i++) {
-		if (ndev == wl->vif[i].ndev) {
-			memcpy(wl->vif[i].src_addr, mac_add, ETH_ALEN);
-			wl->vif[i].hif_drv = priv->hWILCWFIDrv;
+		if (ndev == wl->vif[i]->ndev) {
+			memcpy(wl->vif[i]->src_addr, mac_add, ETH_ALEN);
+			wl->vif[i]->hif_drv = priv->hWILCWFIDrv;
 			break;
 		}
 	}
 
-	memcpy(ndev->dev_addr, wl->vif[i].src_addr, ETH_ALEN);
+	memcpy(ndev->dev_addr, wl->vif[i]->src_addr, ETH_ALEN);
 
 	if (!is_valid_ether_addr(ndev->dev_addr)) {
 		PRINT_ER("Error: Wrong MAC address\n");
@@ -1182,14 +1182,14 @@ int wilc_mac_xmit(struct sk_buff *skb, struct net_device *ndev)
 	PRINT_D(TX_DBG, "Adding tx packet to TX Queue\n");
 	vif->netstats.tx_packets++;
 	vif->netstats.tx_bytes += tx_data->size;
-	tx_data->pBssid = wilc->vif[vif->u8IfIdx].bssid;
+	tx_data->pBssid = wilc->vif[vif->u8IfIdx]->bssid;
 	queue_count = wilc_wlan_txq_add_net_pkt(ndev, (void *)tx_data,
 						tx_data->buff, tx_data->size,
 						linux_wlan_tx_complete);
 
 	if (queue_count > FLOW_CONTROL_UPPER_THRESHOLD) {
-		netif_stop_queue(wilc->vif[0].ndev);
-		netif_stop_queue(wilc->vif[1].ndev);
+		netif_stop_queue(wilc->vif[0]->ndev);
+		netif_stop_queue(wilc->vif[1]->ndev);
 	}
 
 	return 0;
@@ -1373,17 +1373,17 @@ void WILC_WFI_mgmt_rx(struct wilc *wilc, u8 *buff, u32 size)
 	struct wilc_vif *vif;
 
 	for (i = 0; i < wilc->vif_num; i++) {
-		vif = netdev_priv(wilc->vif[i].ndev);
+		vif = netdev_priv(wilc->vif[i]->ndev);
 		if (vif->monitor_flag) {
 			WILC_WFI_monitor_rx(buff, size);
 			return;
 		}
 	}
 
-	vif = netdev_priv(wilc->vif[1].ndev);
+	vif = netdev_priv(wilc->vif[1]->ndev);
 	if ((buff[0] == vif->g_struct_frame_reg[0].frame_type && vif->g_struct_frame_reg[0].reg) ||
 	    (buff[0] == vif->g_struct_frame_reg[1].frame_type && vif->g_struct_frame_reg[1].reg))
-		WILC_WFI_p2p_rx(wilc->vif[1].ndev, buff, size);
+		WILC_WFI_p2p_rx(wilc->vif[1]->ndev, buff, size);
 }
 
 void wilc_netdev_cleanup(struct wilc *wilc)
@@ -1391,28 +1391,28 @@ void wilc_netdev_cleanup(struct wilc *wilc)
 	int i = 0;
 	struct wilc_vif *vif[NUM_CONCURRENT_IFC];
 
-	if (wilc && (wilc->vif[0].ndev || wilc->vif[1].ndev)) {
+	if (wilc && (wilc->vif[0]->ndev || wilc->vif[1]->ndev)) {
 		unregister_inetaddr_notifier(&g_dev_notifier);
 
 		for (i = 0; i < NUM_CONCURRENT_IFC; i++)
-			vif[i] = netdev_priv(wilc->vif[i].ndev);
+			vif[i] = netdev_priv(wilc->vif[i]->ndev);
 	}
 
 	if (wilc && wilc->firmware)
 		release_firmware(wilc->firmware);
 
-	if (wilc && (wilc->vif[0].ndev || wilc->vif[1].ndev)) {
+	if (wilc && (wilc->vif[0]->ndev || wilc->vif[1]->ndev)) {
 		wilc_lock_timeout(wilc, &close_exit_sync, 12 * 1000);
 
 		for (i = 0; i < NUM_CONCURRENT_IFC; i++)
-			if (wilc->vif[i].ndev)
+			if (wilc->vif[i]->ndev)
 				if (vif[i]->mac_opened)
-					wilc_mac_close(wilc->vif[i].ndev);
+					wilc_mac_close(wilc->vif[i]->ndev);
 
 		for (i = 0; i < NUM_CONCURRENT_IFC; i++) {
-			unregister_netdev(wilc->vif[i].ndev);
-			wilc_free_wiphy(wilc->vif[i].ndev);
-			free_netdev(wilc->vif[i].ndev);
+			unregister_netdev(wilc->vif[i]->ndev);
+			wilc_free_wiphy(wilc->vif[i]->ndev);
+			free_netdev(wilc->vif[i]->ndev);
 		}
 	}
 
@@ -1459,7 +1459,8 @@ int wilc_netdev_init(struct wilc **wilc, struct device *dev, int io_type,
 		vif->u8IfIdx = wl->vif_num;
 		vif->wilc_netdev = ndev;
 		vif->wilc = *wilc;
-		wl->vif[wl->vif_num].ndev = ndev;
+		wl->vif[i] = vif;
+		wl->vif[wl->vif_num]->ndev = ndev;
 		wl->vif_num++;
 		ndev->netdev_ops = &wilc_netdev_ops;
 
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 8ec12f8..d128fb6 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -578,9 +578,9 @@ static void CfgConnectResult(enum conn_event enuConnDisconnEvent,
 
 		if (!pstrWFIDrv->p2p_connect)
 			wlan_channel = INVALID_CHANNEL;
-		if ((pstrWFIDrv->IFC_UP) && (dev == wl->vif[1].ndev)) {
+		if ((pstrWFIDrv->IFC_UP) && (dev == wl->vif[1]->ndev)) {
 			pstrDisconnectNotifInfo->u16reason = 3;
-		} else if ((!pstrWFIDrv->IFC_UP) && (dev == wl->vif[1].ndev)) {
+		} else if ((!pstrWFIDrv->IFC_UP) && (dev == wl->vif[1]->ndev)) {
 			pstrDisconnectNotifInfo->u16reason = 1;
 		}
 		cfg80211_disconnected(dev, pstrDisconnectNotifInfo->u16reason, pstrDisconnectNotifInfo->ie,
@@ -1118,7 +1118,7 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 					KeyLen = params->key_len - 16;
 				}
 
-				if (!g_gtk_keys_saved && netdev == wl->vif[0].ndev) {
+				if (!g_gtk_keys_saved && netdev == wl->vif[0]->ndev) {
 					g_add_gtk_key_params.key_idx = key_index;
 					g_add_gtk_key_params.pairwise = pairwise;
 					if (!mac_addr) {
@@ -1152,7 +1152,7 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 					KeyLen = params->key_len - 16;
 				}
 
-				if (!g_ptk_keys_saved && netdev == wl->vif[0].ndev) {
+				if (!g_ptk_keys_saved && netdev == wl->vif[0]->ndev) {
 					g_add_ptk_key_params.key_idx = key_index;
 					g_add_ptk_key_params.pairwise = pairwise;
 					if (!mac_addr) {
@@ -1209,7 +1209,7 @@ static int del_key(struct wiphy *wiphy, struct net_device *netdev,
 	vif = netdev_priv(netdev);
 	wl = vif->wilc;
 
-	if (netdev == wl->vif[0].ndev) {
+	if (netdev == wl->vif[0]->ndev) {
 		g_ptk_keys_saved = false;
 		g_gtk_keys_saved = false;
 		g_wep_keys_saved = false;
@@ -2097,7 +2097,7 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 
 		if (wl->initialized) {
 			wilc_del_all_rx_ba_session(priv->hWILCWFIDrv,
-						   wl->vif[0].bssid, TID);
+						   wl->vif[0]->bssid, TID);
 			wilc_wait_msg_queue_idle();
 
 			up(&wl->cfg_event);
@@ -2107,15 +2107,15 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 			wilc_initialized = 1;
 			vif->iftype = interface_type;
 
-			wilc_set_wfi_drv_handler(wl->vif[0].hif_drv);
-			wilc_set_mac_address(wl->vif[0].hif_drv,
-						wl->vif[0].src_addr);
+			wilc_set_wfi_drv_handler(wl->vif[0]->hif_drv);
+			wilc_set_mac_address(wl->vif[0]->hif_drv,
+						wl->vif[0]->src_addr);
 			wilc_set_operation_mode(priv->hWILCWFIDrv, STATION_MODE);
 
 			if (g_wep_keys_saved) {
-				wilc_set_wep_default_keyid(wl->vif[0].hif_drv,
+				wilc_set_wep_default_keyid(wl->vif[0]->hif_drv,
 							     g_key_wep_params.key_idx);
-				wilc_add_wep_key_bss_sta(wl->vif[0].hif_drv,
+				wilc_add_wep_key_bss_sta(wl->vif[0]->hif_drv,
 							     g_key_wep_params.key,
 							     g_key_wep_params.key_len,
 							     g_key_wep_params.key_idx);
@@ -2130,15 +2130,15 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 				PRINT_D(CFG80211_DBG, "gtk %x %x %x\n", g_key_gtk_params.key[0],
 					g_key_gtk_params.key[1],
 					g_key_gtk_params.key[2]);
-				add_key(wl->vif[0].ndev->ieee80211_ptr->wiphy,
-					wl->vif[0].ndev,
+				add_key(wl->vif[0]->ndev->ieee80211_ptr->wiphy,
+					wl->vif[0]->ndev,
 					g_add_ptk_key_params.key_idx,
 					g_add_ptk_key_params.pairwise,
 					g_add_ptk_key_params.mac_addr,
 					(struct key_params *)(&g_key_ptk_params));
 
-				add_key(wl->vif[0].ndev->ieee80211_ptr->wiphy,
-					wl->vif[0].ndev,
+				add_key(wl->vif[0]->ndev->ieee80211_ptr->wiphy,
+					wl->vif[0]->ndev,
 					g_add_gtk_key_params.key_idx,
 					g_add_gtk_key_params.pairwise,
 					g_add_gtk_key_params.mac_addr,
@@ -2167,7 +2167,7 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 		PRINT_D(HOSTAPD_DBG, "Interface type = NL80211_IFTYPE_P2P_CLIENT\n");
 
 		wilc_del_all_rx_ba_session(priv->hWILCWFIDrv,
-					   wl->vif[0].bssid, TID);
+					   wl->vif[0]->bssid, TID);
 
 		dev->ieee80211_ptr->iftype = type;
 		priv->wdev->iftype = type;
@@ -2184,15 +2184,15 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 			wilc1000_wlan_init(dev, vif);
 			wilc_initialized = 1;
 
-			wilc_set_wfi_drv_handler(wl->vif[0].hif_drv);
-			wilc_set_mac_address(wl->vif[0].hif_drv,
-						wl->vif[0].src_addr);
+			wilc_set_wfi_drv_handler(wl->vif[0]->hif_drv);
+			wilc_set_mac_address(wl->vif[0]->hif_drv,
+						wl->vif[0]->src_addr);
 			wilc_set_operation_mode(priv->hWILCWFIDrv, STATION_MODE);
 
 			if (g_wep_keys_saved) {
-				wilc_set_wep_default_keyid(wl->vif[0].hif_drv,
+				wilc_set_wep_default_keyid(wl->vif[0]->hif_drv,
 							   g_key_wep_params.key_idx);
-				wilc_add_wep_key_bss_sta(wl->vif[0].hif_drv,
+				wilc_add_wep_key_bss_sta(wl->vif[0]->hif_drv,
 							 g_key_wep_params.key,
 							 g_key_wep_params.key_len,
 							 g_key_wep_params.key_idx);
@@ -2207,15 +2207,15 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 				PRINT_D(CFG80211_DBG, "gtk %x %x %x\n", g_key_gtk_params.key[0],
 					g_key_gtk_params.key[1],
 					g_key_gtk_params.key[2]);
-				add_key(wl->vif[0].ndev->ieee80211_ptr->wiphy,
-					wl->vif[0].ndev,
+				add_key(wl->vif[0]->ndev->ieee80211_ptr->wiphy,
+					wl->vif[0]->ndev,
 					g_add_ptk_key_params.key_idx,
 					g_add_ptk_key_params.pairwise,
 					g_add_ptk_key_params.mac_addr,
 					(struct key_params *)(&g_key_ptk_params));
 
-				add_key(wl->vif[0].ndev->ieee80211_ptr->wiphy,
-					wl->vif[0].ndev,
+				add_key(wl->vif[0]->ndev->ieee80211_ptr->wiphy,
+					wl->vif[0]->ndev,
 					g_add_gtk_key_params.key_idx,
 					g_add_gtk_key_params.pairwise,
 					g_add_gtk_key_params.mac_addr,
@@ -2271,7 +2271,7 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 			  jiffies + msecs_to_jiffies(during_ip_time));
 		wilc_set_power_mgmt(priv->hWILCWFIDrv, 0, 0);
 		wilc_del_all_rx_ba_session(priv->hWILCWFIDrv,
-					   wl->vif[0].bssid, TID);
+					   wl->vif[0]->bssid, TID);
 		wilc_enable_ps = false;
 		PRINT_D(HOSTAPD_DBG, "Interface type = NL80211_IFTYPE_GO\n");
 		dev->ieee80211_ptr->iftype = type;
@@ -2289,15 +2289,15 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 		wilc1000_wlan_init(dev, vif);
 		wilc_initialized = 1;
 
-		wilc_set_wfi_drv_handler(wl->vif[0].hif_drv);
-		wilc_set_mac_address(wl->vif[0].hif_drv,
-				     wl->vif[0].src_addr);
+		wilc_set_wfi_drv_handler(wl->vif[0]->hif_drv);
+		wilc_set_mac_address(wl->vif[0]->hif_drv,
+				     wl->vif[0]->src_addr);
 		wilc_set_operation_mode(priv->hWILCWFIDrv, AP_MODE);
 
 		if (g_wep_keys_saved) {
-			wilc_set_wep_default_keyid(wl->vif[0].hif_drv,
+			wilc_set_wep_default_keyid(wl->vif[0]->hif_drv,
 						   g_key_wep_params.key_idx);
-			wilc_add_wep_key_bss_sta(wl->vif[0].hif_drv,
+			wilc_add_wep_key_bss_sta(wl->vif[0]->hif_drv,
 						     g_key_wep_params.key,
 						     g_key_wep_params.key_len,
 						     g_key_wep_params.key_idx);
@@ -2314,15 +2314,15 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 				g_key_gtk_params.key[1],
 				g_key_gtk_params.key[2],
 				g_key_gtk_params.cipher);
-			add_key(wl->vif[0].ndev->ieee80211_ptr->wiphy,
-				wl->vif[0].ndev,
+			add_key(wl->vif[0]->ndev->ieee80211_ptr->wiphy,
+				wl->vif[0]->ndev,
 				g_add_ptk_key_params.key_idx,
 				g_add_ptk_key_params.pairwise,
 				g_add_ptk_key_params.mac_addr,
 				(struct key_params *)(&g_key_ptk_params));
 
-			add_key(wl->vif[0].ndev->ieee80211_ptr->wiphy,
-				wl->vif[0].ndev,
+			add_key(wl->vif[0]->ndev->ieee80211_ptr->wiphy,
+				wl->vif[0]->ndev,
 				g_add_gtk_key_params.key_idx,
 				g_add_gtk_key_params.pairwise,
 				g_add_gtk_key_params.mac_addr,
@@ -2370,7 +2370,7 @@ static int start_ap(struct wiphy *wiphy, struct net_device *dev,
 	if (s32Error != 0)
 		PRINT_ER("Error in setting channel\n");
 
-	wilc_wlan_set_bssid(dev, wl->vif[0].src_addr);
+	wilc_wlan_set_bssid(dev, wl->vif[0]->src_addr);
 
 	s32Error = wilc_add_beacon(priv->hWILCWFIDrv,
 					settings->beacon_interval,
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index 0d04497..9f5eac8 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -172,7 +172,7 @@ struct wilc {
 	int dev_irq_num;
 	int close;
 	u8 vif_num;
-	struct wilc_vif vif[NUM_CONCURRENT_IFC];
+	struct wilc_vif *vif[NUM_CONCURRENT_IFC];
 	u8 open_ifcs;
 
 	struct semaphore txq_add_to_head_cs;
-- 
1.9.1

