Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:22954 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194AbbJTF2D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Oct 2015 01:28:03 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 07/12] staging: wilc1000: rename wilc_netdev in the struct wilc_vif
Date: Tue, 20 Oct 2015 14:26:51 +0900
Message-ID: <1445318816-21686-8-git-send-email-tony.cho@atmel.com> (sfid-20151020_072807_148203_56850554)
In-Reply-To: <1445318816-21686-1-git-send-email-tony.cho@atmel.com>
References: <1445318816-21686-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames wilc_netdev in the struct wilc_vif to the ndev.

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c             | 50 +++++++++++------------
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 34 +++++++--------
 drivers/staging/wilc1000/wilc_wfi_netdevice.h     |  2 +-
 3 files changed, 43 insertions(+), 43 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 11e26fb..41a2f09 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -369,7 +369,7 @@ struct net_device *GetIfHandler(u8 *pMacHeader)
 	for (i = 0; i < g_linux_wlan->vif_num; i++)
 		if (!memcmp(Bssid1, g_linux_wlan->vif[i].bssid, ETH_ALEN) ||
 		    !memcmp(Bssid, g_linux_wlan->vif[i].bssid, ETH_ALEN))
-			return g_linux_wlan->vif[i].wilc_netdev;
+			return g_linux_wlan->vif[i].ndev;
 
 	PRINT_INFO(INIT_DBG, "Invalide handle\n");
 	for (i = 0; i < 25; i++)
@@ -379,7 +379,7 @@ struct net_device *GetIfHandler(u8 *pMacHeader)
 	for (i = 0; i < g_linux_wlan->vif_num; i++)
 		if (!memcmp(Bssid1, g_linux_wlan->vif[i].bssid, ETH_ALEN) ||
 		    !memcmp(Bssid, g_linux_wlan->vif[i].bssid, ETH_ALEN))
-			return g_linux_wlan->vif[i].wilc_netdev;
+			return g_linux_wlan->vif[i].ndev;
 
 	PRINT_INFO(INIT_DBG, "\n");
 	return NULL;
@@ -391,7 +391,7 @@ int linux_wlan_set_bssid(struct net_device *wilc_netdev, u8 *pBSSID)
 	int ret = -1;
 
 	for (i = 0; i < g_linux_wlan->vif_num; i++)
-		if (g_linux_wlan->vif[i].wilc_netdev == wilc_netdev) {
+		if (g_linux_wlan->vif[i].ndev == wilc_netdev) {
 			memcpy(g_linux_wlan->vif[i].bssid, pBSSID, 6);
 			ret = 0;
 			break;
@@ -457,10 +457,10 @@ static int linux_wlan_txq_task(void *vp)
 			if (txq_count < FLOW_CONTROL_LOWER_THRESHOLD /* && netif_queue_stopped(pd->wilc_netdev)*/) {
 				PRINT_D(TX_DBG, "Waking up queue\n");
 				/* netif_wake_queue(pd->wilc_netdev); */
-				if (netif_queue_stopped(g_linux_wlan->vif[0].wilc_netdev))
-					netif_wake_queue(g_linux_wlan->vif[0].wilc_netdev);
-				if (netif_queue_stopped(g_linux_wlan->vif[1].wilc_netdev))
-					netif_wake_queue(g_linux_wlan->vif[1].wilc_netdev);
+				if (netif_queue_stopped(g_linux_wlan->vif[0].ndev))
+					netif_wake_queue(g_linux_wlan->vif[0].ndev);
+				if (netif_queue_stopped(g_linux_wlan->vif[1].ndev))
+					netif_wake_queue(g_linux_wlan->vif[1].ndev);
 			}
 
 			if (ret == WILC_TX_ERR_NO_BUF) { /* failed to allocate buffers in chip. */
@@ -1312,7 +1312,7 @@ int mac_open(struct net_device *ndev)
 
 	/* loop through the NUM of supported devices and set the MAC address */
 	for (i = 0; i < g_linux_wlan->vif_num; i++) {
-		if (ndev == g_linux_wlan->vif[i].wilc_netdev) {
+		if (ndev == g_linux_wlan->vif[i].ndev) {
 			memcpy(g_linux_wlan->vif[i].src_addr, mac_add, ETH_ALEN);
 			g_linux_wlan->vif[i].hif_drv = priv->hWILCWFIDrv;
 			break;
@@ -1478,8 +1478,8 @@ int mac_xmit(struct sk_buff *skb, struct net_device *ndev)
 					       linux_wlan_tx_complete);
 
 	if (QueueCount > FLOW_CONTROL_UPPER_THRESHOLD) {
-		netif_stop_queue(g_linux_wlan->vif[0].wilc_netdev);
-		netif_stop_queue(g_linux_wlan->vif[1].wilc_netdev);
+		netif_stop_queue(g_linux_wlan->vif[0].ndev);
+		netif_stop_queue(g_linux_wlan->vif[1].ndev);
 	}
 
 	return 0;
@@ -1683,17 +1683,17 @@ void WILC_WFI_mgmt_rx(u8 *buff, u32 size)
 	/*Pass the frame on the monitor interface, if any.*/
 	/*Otherwise, pass it on p2p0 netdev, if registered on it*/
 	for (i = 0; i < g_linux_wlan->vif_num; i++) {
-		nic = netdev_priv(g_linux_wlan->vif[i].wilc_netdev);
+		nic = netdev_priv(g_linux_wlan->vif[i].ndev);
 		if (nic->monitor_flag) {
 			WILC_WFI_monitor_rx(buff, size);
 			return;
 		}
 	}
 
-	nic = netdev_priv(g_linux_wlan->vif[1].wilc_netdev); /* p2p0 */
+	nic = netdev_priv(g_linux_wlan->vif[1].ndev); /* p2p0 */
 	if ((buff[0] == nic->g_struct_frame_reg[0].frame_type && nic->g_struct_frame_reg[0].reg) ||
 	    (buff[0] == nic->g_struct_frame_reg[1].frame_type && nic->g_struct_frame_reg[1].reg))
-		WILC_WFI_p2p_rx(g_linux_wlan->vif[1].wilc_netdev, buff, size);
+		WILC_WFI_p2p_rx(g_linux_wlan->vif[1].ndev, buff, size);
 }
 
 int wilc_netdev_init(void)
@@ -1737,7 +1737,7 @@ int wilc_netdev_init(void)
 
 		nic->u8IfIdx = g_linux_wlan->vif_num;
 		nic->wilc_netdev = ndev;
-		g_linux_wlan->vif[g_linux_wlan->vif_num].wilc_netdev = ndev;
+		g_linux_wlan->vif[g_linux_wlan->vif_num].ndev = ndev;
 		g_linux_wlan->vif_num++;
 		ndev->netdev_ops = &wilc_netdev_ops;
 
@@ -1832,12 +1832,12 @@ static void __exit exit_wilc_driver(void)
 	perInterface_wlan_t *nic[NUM_CONCURRENT_IFC] = {NULL,};
 	#define CLOSE_TIMEOUT (12 * 1000)
 
-	if ((g_linux_wlan != NULL) && (((g_linux_wlan->vif[0].wilc_netdev) != NULL)
-				       || ((g_linux_wlan->vif[1].wilc_netdev) != NULL))) {
+	if ((g_linux_wlan != NULL) && (((g_linux_wlan->vif[0].ndev) != NULL)
+				       || ((g_linux_wlan->vif[1].ndev) != NULL))) {
 		unregister_inetaddr_notifier(&g_dev_notifier);
 
 		for (i = 0; i < NUM_CONCURRENT_IFC; i++)
-			nic[i] = netdev_priv(g_linux_wlan->vif[i].wilc_netdev);
+			nic[i] = netdev_priv(g_linux_wlan->vif[i].ndev);
 	}
 
 	if ((g_linux_wlan != NULL) && g_linux_wlan->wilc_firmware != NULL) {
@@ -1845,8 +1845,8 @@ static void __exit exit_wilc_driver(void)
 		g_linux_wlan->wilc_firmware = NULL;
 	}
 
-	if ((g_linux_wlan != NULL) && (((g_linux_wlan->vif[0].wilc_netdev) != NULL)
-				       || ((g_linux_wlan->vif[1].wilc_netdev) != NULL))) {
+	if ((g_linux_wlan != NULL) && (((g_linux_wlan->vif[0].ndev) != NULL)
+				       || ((g_linux_wlan->vif[1].ndev) != NULL))) {
 		PRINT_D(INIT_DBG, "Waiting for mac_close ....\n");
 
 		if (linux_wlan_lock_timeout(&close_exit_sync, CLOSE_TIMEOUT) < 0)
@@ -1856,18 +1856,18 @@ static void __exit exit_wilc_driver(void)
 
 		for (i = 0; i < NUM_CONCURRENT_IFC; i++) {
 			/* close all opened interfaces */
-			if (g_linux_wlan->vif[i].wilc_netdev != NULL) {
+			if (g_linux_wlan->vif[i].ndev != NULL) {
 				if (nic[i]->mac_opened)
-					mac_close(g_linux_wlan->vif[i].wilc_netdev);
+					mac_close(g_linux_wlan->vif[i].ndev);
 			}
 		}
 		for (i = 0; i < NUM_CONCURRENT_IFC; i++) {
-			PRINT_D(INIT_DBG, "Unregistering netdev %p\n", g_linux_wlan->vif[i].wilc_netdev);
-			unregister_netdev(g_linux_wlan->vif[i].wilc_netdev);
+			PRINT_D(INIT_DBG, "Unregistering netdev %p\n", g_linux_wlan->vif[i].ndev);
+			unregister_netdev(g_linux_wlan->vif[i].ndev);
 			PRINT_D(INIT_DBG, "Freeing Wiphy...\n");
-			wilc_free_wiphy(g_linux_wlan->vif[i].wilc_netdev);
+			wilc_free_wiphy(g_linux_wlan->vif[i].ndev);
 			PRINT_D(INIT_DBG, "Freeing netdev...\n");
-			free_netdev(g_linux_wlan->vif[i].wilc_netdev);
+			free_netdev(g_linux_wlan->vif[i].ndev);
 		}
 	}
 
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 2dfc0fd..264fcb9 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -624,12 +624,12 @@ static void CfgConnectResult(enum conn_event enuConnDisconnEvent,
 			u8WLANChannel = INVALID_CHANNEL;
 		/*Incase "P2P CLIENT Connected" send deauthentication reason by 3 to force the WPA_SUPPLICANT to directly change
 		 *      virtual interface to station*/
-		if ((pstrWFIDrv->IFC_UP) && (dev == g_linux_wlan->vif[1].wilc_netdev)) {
+		if ((pstrWFIDrv->IFC_UP) && (dev == g_linux_wlan->vif[1].ndev)) {
 			pstrDisconnectNotifInfo->u16reason = 3;
 		}
 		/*Incase "P2P CLIENT during connection(not connected)" send deauthentication reason by 1 to force the WPA_SUPPLICANT
 		 *      to scan again and retry the connection*/
-		else if ((!pstrWFIDrv->IFC_UP) && (dev == g_linux_wlan->vif[1].wilc_netdev)) {
+		else if ((!pstrWFIDrv->IFC_UP) && (dev == g_linux_wlan->vif[1].ndev)) {
 			pstrDisconnectNotifInfo->u16reason = 1;
 		}
 		cfg80211_disconnected(dev, pstrDisconnectNotifInfo->u16reason, pstrDisconnectNotifInfo->ie,
@@ -1255,7 +1255,7 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 				}
 
 				/*save keys only on interface 0 (wifi interface)*/
-				if (!g_gtk_keys_saved && netdev == g_linux_wlan->vif[0].wilc_netdev) {
+				if (!g_gtk_keys_saved && netdev == g_linux_wlan->vif[0].ndev) {
 					g_add_gtk_key_params.key_idx = key_index;
 					g_add_gtk_key_params.pairwise = pairwise;
 					if (!mac_addr) {
@@ -1291,7 +1291,7 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 				}
 
 				/*save keys only on interface 0 (wifi interface)*/
-				if (!g_ptk_keys_saved && netdev == g_linux_wlan->vif[0].wilc_netdev) {
+				if (!g_ptk_keys_saved && netdev == g_linux_wlan->vif[0].ndev) {
 					g_add_ptk_key_params.key_idx = key_index;
 					g_add_ptk_key_params.pairwise = pairwise;
 					if (!mac_addr) {
@@ -1356,7 +1356,7 @@ static int del_key(struct wiphy *wiphy, struct net_device *netdev,
 	priv = wiphy_priv(wiphy);
 
 	/*delete saved keys, if any*/
-	if (netdev == g_linux_wlan->vif[0].wilc_netdev) {
+	if (netdev == g_linux_wlan->vif[0].ndev) {
 		g_ptk_keys_saved = false;
 		g_gtk_keys_saved = false;
 		g_wep_keys_saved = false;
@@ -2612,15 +2612,15 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 				PRINT_D(CFG80211_DBG, "gtk %x %x %x\n", g_key_gtk_params.key[0],
 					g_key_gtk_params.key[1],
 					g_key_gtk_params.key[2]);
-				add_key(g_linux_wlan->vif[0].wilc_netdev->ieee80211_ptr->wiphy,
-					g_linux_wlan->vif[0].wilc_netdev,
+				add_key(g_linux_wlan->vif[0].ndev->ieee80211_ptr->wiphy,
+					g_linux_wlan->vif[0].ndev,
 					g_add_ptk_key_params.key_idx,
 					g_add_ptk_key_params.pairwise,
 					g_add_ptk_key_params.mac_addr,
 					(struct key_params *)(&g_key_ptk_params));
 
-				add_key(g_linux_wlan->vif[0].wilc_netdev->ieee80211_ptr->wiphy,
-					g_linux_wlan->vif[0].wilc_netdev,
+				add_key(g_linux_wlan->vif[0].ndev->ieee80211_ptr->wiphy,
+					g_linux_wlan->vif[0].ndev,
 					g_add_gtk_key_params.key_idx,
 					g_add_gtk_key_params.pairwise,
 					g_add_gtk_key_params.mac_addr,
@@ -2693,15 +2693,15 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 				PRINT_D(CFG80211_DBG, "gtk %x %x %x\n", g_key_gtk_params.key[0],
 					g_key_gtk_params.key[1],
 					g_key_gtk_params.key[2]);
-				add_key(g_linux_wlan->vif[0].wilc_netdev->ieee80211_ptr->wiphy,
-					g_linux_wlan->vif[0].wilc_netdev,
+				add_key(g_linux_wlan->vif[0].ndev->ieee80211_ptr->wiphy,
+					g_linux_wlan->vif[0].ndev,
 					g_add_ptk_key_params.key_idx,
 					g_add_ptk_key_params.pairwise,
 					g_add_ptk_key_params.mac_addr,
 					(struct key_params *)(&g_key_ptk_params));
 
-				add_key(g_linux_wlan->vif[0].wilc_netdev->ieee80211_ptr->wiphy,
-					g_linux_wlan->vif[0].wilc_netdev,
+				add_key(g_linux_wlan->vif[0].ndev->ieee80211_ptr->wiphy,
+					g_linux_wlan->vif[0].ndev,
 					g_add_gtk_key_params.key_idx,
 					g_add_gtk_key_params.pairwise,
 					g_add_gtk_key_params.mac_addr,
@@ -2810,15 +2810,15 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 				g_key_gtk_params.key[1],
 				g_key_gtk_params.key[2],
 				g_key_gtk_params.cipher);
-			add_key(g_linux_wlan->vif[0].wilc_netdev->ieee80211_ptr->wiphy,
-				g_linux_wlan->vif[0].wilc_netdev,
+			add_key(g_linux_wlan->vif[0].ndev->ieee80211_ptr->wiphy,
+				g_linux_wlan->vif[0].ndev,
 				g_add_ptk_key_params.key_idx,
 				g_add_ptk_key_params.pairwise,
 				g_add_ptk_key_params.mac_addr,
 				(struct key_params *)(&g_key_ptk_params));
 
-			add_key(g_linux_wlan->vif[0].wilc_netdev->ieee80211_ptr->wiphy,
-				g_linux_wlan->vif[0].wilc_netdev,
+			add_key(g_linux_wlan->vif[0].ndev->ieee80211_ptr->wiphy,
+				g_linux_wlan->vif[0].ndev,
 				g_add_gtk_key_params.key_idx,
 				g_add_gtk_key_params.pairwise,
 				g_add_gtk_key_params.mac_addr,
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index 521d3cb..429b654 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -152,7 +152,7 @@ struct wilc_vif {
 	u8 src_addr[ETH_ALEN];
 	u8 bssid[ETH_ALEN];
 	struct host_if_drv *hif_drv;
-	struct net_device *wilc_netdev;
+	struct net_device *ndev;
 };
 
 struct wilc {
-- 
1.9.1

