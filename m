Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:43684 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932465AbbJNLsR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Oct 2015 07:48:17 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 11/16] staging: wilc1000: rename wilc_netdev in the struct wilc_vif
Date: Wed, 14 Oct 2015 20:46:39 +0900
Message-ID: <1444823204-16736-11-git-send-email-tony.cho@atmel.com> (sfid-20151014_134824_279512_36AA48EB)
In-Reply-To: <1444823204-16736-1-git-send-email-tony.cho@atmel.com>
References: <1444823204-16736-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames wilc_netdev in the struct wilc_vif to the ndev.

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c             | 45 +++++++++++------------
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 34 ++++++++---------
 drivers/staging/wilc1000/wilc_wfi_netdevice.h     |  2 +-
 3 files changed, 40 insertions(+), 41 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 6e21825..3d02ae7 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -369,7 +369,7 @@ struct net_device *GetIfHandler(u8 *pMacHeader)
 	for (i = 0; i < wl->vif_num; i++)
 		if (!memcmp(Bssid1, wl->vif[i].bssid, ETH_ALEN) ||
 		    !memcmp(Bssid, wl->vif[i].bssid, ETH_ALEN))
-			return wl->vif[i].wilc_netdev;
+			return wl->vif[i].ndev;
 
 	PRINT_INFO(INIT_DBG, "Invalide handle\n");
 	for (i = 0; i < 25; i++)
@@ -379,7 +379,7 @@ struct net_device *GetIfHandler(u8 *pMacHeader)
 	for (i = 0; i < wl->vif_num; i++)
 		if (!memcmp(Bssid1, wl->vif[i].bssid, ETH_ALEN) ||
 		    !memcmp(Bssid, wl->vif[i].bssid, ETH_ALEN))
-			return wl->vif[i].wilc_netdev;
+			return wl->vif[i].ndev;
 
 	PRINT_INFO(INIT_DBG, "\n");
 	return NULL;
@@ -392,7 +392,7 @@ int linux_wlan_set_bssid(struct net_device *wilc_netdev, u8 *pBSSID)
 
 	PRINT_D(INIT_DBG, "set bssid on[%p]\n", wilc_netdev);
 	for (i = 0; i < wl->vif_num; i++)
-		if (wl->vif[i].wilc_netdev == wilc_netdev) {
+		if (wl->vif[i].ndev == wilc_netdev) {
 			memcpy(wl->vif[i].bssid, pBSSID, 6);
 			ret = 0;
 			break;
@@ -458,10 +458,10 @@ static int linux_wlan_txq_task(void *vp)
 			if (txq_count < FLOW_CONTROL_LOWER_THRESHOLD /* && netif_queue_stopped(pd->wilc_netdev)*/) {
 				PRINT_D(TX_DBG, "Waking up queue\n");
 				/* netif_wake_queue(pd->wilc_netdev); */
-				if (netif_queue_stopped(wl->vif[0].wilc_netdev))
-					netif_wake_queue(wl->vif[0].wilc_netdev);
-				if (netif_queue_stopped(wl->vif[1].wilc_netdev))
-					netif_wake_queue(wl->vif[1].wilc_netdev);
+				if (netif_queue_stopped(wl->vif[0].ndev))
+					netif_wake_queue(wl->vif[0].ndev);
+				if (netif_queue_stopped(wl->vif[1].ndev))
+					netif_wake_queue(wl->vif[1].ndev);
 			}
 
 			if (ret == WILC_TX_ERR_NO_BUF) { /* failed to allocate buffers in chip. */
@@ -1311,7 +1311,7 @@ int mac_open(struct net_device *ndev)
 
 	/* loop through the NUM of supported devices and set the MAC address */
 	for (i = 0; i < wl->vif_num; i++)
-		if (ndev == wl->vif[i].wilc_netdev) {
+		if (ndev == wl->vif[i].ndev) {
 			memcpy(wl->vif[i].src_addr, mac_add, ETH_ALEN);
 			wl->vif[i].hif_drv = priv->hWILCWFIDrv;
 			break;
@@ -1476,8 +1476,8 @@ int mac_xmit(struct sk_buff *skb, struct net_device *ndev)
 					       linux_wlan_tx_complete);
 
 	if (QueueCount > FLOW_CONTROL_UPPER_THRESHOLD) {
-		netif_stop_queue(wl->vif[0].wilc_netdev);
-		netif_stop_queue(wl->vif[1].wilc_netdev);
+		netif_stop_queue(wl->vif[0].ndev);
+		netif_stop_queue(wl->vif[1].ndev);
 	}
 
 	return 0;
@@ -1681,17 +1681,17 @@ void WILC_WFI_mgmt_rx(u8 *buff, u32 size)
 	/*Pass the frame on the monitor interface, if any.*/
 	/*Otherwise, pass it on p2p0 netdev, if registered on it*/
 	for (i = 0; i < wl->vif_num; i++) {
-		nic = netdev_priv(wl->vif[i].wilc_netdev);
+		nic = netdev_priv(wl->vif[i].ndev);
 		if (nic->monitor_flag) {
 			WILC_WFI_monitor_rx(buff, size);
 			return;
 		}
 	}
 
-	nic = netdev_priv(wl->vif[1].wilc_netdev); /* p2p0 */
+	nic = netdev_priv(wl->vif[1].ndev); /* p2p0 */
 	if ((buff[0] == nic->g_struct_frame_reg[0].frame_type && nic->g_struct_frame_reg[0].reg) ||
 	    (buff[0] == nic->g_struct_frame_reg[1].frame_type && nic->g_struct_frame_reg[1].reg))
-		WILC_WFI_p2p_rx(wl->vif[1].wilc_netdev, buff, size);
+		WILC_WFI_p2p_rx(wl->vif[1].ndev, buff, size);
 }
 
 int wilc_netdev_init(void)
@@ -1735,7 +1735,7 @@ int wilc_netdev_init(void)
 
 		nic->u8IfIdx = wl->vif_num;
 		nic->wilc_netdev = ndev;
-		wl->vif[wl->vif_num].wilc_netdev = ndev;
+		wl->vif[wl->vif_num].ndev = ndev;
 		wl->vif_num++;
 		ndev->netdev_ops = &wilc_netdev_ops;
 
@@ -1830,11 +1830,11 @@ static void __exit exit_wilc_driver(void)
 	perInterface_wlan_t *nic[NUM_CONCURRENT_IFC] = {NULL,};
 	#define CLOSE_TIMEOUT (12 * 1000)
 
-	if (wl && (wl->vif[0].wilc_netdev || wl->vif[1].wilc_netdev)) {
+	if (wl && (wl->vif[0].ndev || wl->vif[1].ndev)) {
 		unregister_inetaddr_notifier(&g_dev_notifier);
 
 		for (i = 0; i < NUM_CONCURRENT_IFC; i++)
-			nic[i] = netdev_priv(wl->vif[i].wilc_netdev);
+			nic[i] = netdev_priv(wl->vif[i].ndev);
 	}
 
 	if (wl && wl->wilc_firmware) {
@@ -1842,7 +1842,7 @@ static void __exit exit_wilc_driver(void)
 		wl->wilc_firmware = NULL;
 	}
 
-	if (wl && (wl->vif[0].wilc_netdev || wl->vif[1].wilc_netdev)) {
+	if (wl && (wl->vif[0].ndev || wl->vif[1].ndev)) {
 		PRINT_D(INIT_DBG, "Waiting for mac_close ....\n");
 
 		if (linux_wlan_lock_timeout(&close_exit_sync, CLOSE_TIMEOUT) < 0)
@@ -1851,17 +1851,16 @@ static void __exit exit_wilc_driver(void)
 			PRINT_D(INIT_DBG, "mac_closed\n");
 
 		for (i = 0; i < NUM_CONCURRENT_IFC; i++)
-			if (wl->vif[i].wilc_netdev)
+			if (wl->vif[i].ndev)
 				if (nic[i]->mac_opened)
-					mac_close(wl->vif[i].wilc_netdev);
+					mac_close(wl->vif[i].ndev);
 
 		for (i = 0; i < NUM_CONCURRENT_IFC; i++) {
-			PRINT_D(INIT_DBG, "Unregistering netdev %p\n", wl->vif[i].wilc_netdev);
-			unregister_netdev(wl->vif[i].wilc_netdev);
+			unregister_netdev(wl->vif[i].ndev);
 			PRINT_D(INIT_DBG, "Freeing Wiphy...\n");
-			wilc_free_wiphy(wl->vif[i].wilc_netdev);
+			wilc_free_wiphy(wl->vif[i].ndev);
 			PRINT_D(INIT_DBG, "Freeing netdev...\n");
-			free_netdev(wl->vif[i].wilc_netdev);
+			free_netdev(wl->vif[i].ndev);
 		}
 	}
 
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index d7c9279..ebba9d4 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -624,9 +624,9 @@ static void CfgConnectResult(enum conn_event enuConnDisconnEvent,
 			u8WLANChannel = INVALID_CHANNEL;
 		/*Incase "P2P CLIENT Connected" send deauthentication reason by 3 to force the WPA_SUPPLICANT to directly change
 		 *      virtual interface to station*/
-		if (pstrWFIDrv->IFC_UP && (dev == wl->vif[1].wilc_netdev))
+		if (pstrWFIDrv->IFC_UP && (dev == wl->vif[1].ndev))
 			pstrDisconnectNotifInfo->u16reason = 3;
-		else if (!pstrWFIDrv->IFC_UP && (dev == wl->vif[1].wilc_netdev))
+		else if (!pstrWFIDrv->IFC_UP && (dev == wl->vif[1].ndev))
 			pstrDisconnectNotifInfo->u16reason = 1;
 
 		cfg80211_disconnected(dev, pstrDisconnectNotifInfo->u16reason, pstrDisconnectNotifInfo->ie,
@@ -1253,7 +1253,7 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 
 				/*save keys only on interface 0 (wifi interface)*/
 				if (!g_gtk_keys_saved &&
-				    netdev == wl->vif[0].wilc_netdev) {
+				    netdev == wl->vif[0].ndev) {
 					g_add_gtk_key_params.key_idx = key_index;
 					g_add_gtk_key_params.pairwise = pairwise;
 					if (!mac_addr) {
@@ -1290,7 +1290,7 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 
 				/*save keys only on interface 0 (wifi interface)*/
 				if (!g_ptk_keys_saved &&
-				    netdev == wl->vif[0].wilc_netdev) {
+				    netdev == wl->vif[0].ndev) {
 					g_add_ptk_key_params.key_idx = key_index;
 					g_add_ptk_key_params.pairwise = pairwise;
 					if (!mac_addr) {
@@ -1355,7 +1355,7 @@ static int del_key(struct wiphy *wiphy, struct net_device *netdev,
 	priv = wiphy_priv(wiphy);
 
 	/*delete saved keys, if any*/
-	if (netdev == wl->vif[0].wilc_netdev) {
+	if (netdev == wl->vif[0].ndev) {
 		g_ptk_keys_saved = false;
 		g_gtk_keys_saved = false;
 		g_wep_keys_saved = false;
@@ -2613,15 +2613,15 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 				PRINT_D(CFG80211_DBG, "gtk %x %x %x\n", g_key_gtk_params.key[0],
 					g_key_gtk_params.key[1],
 					g_key_gtk_params.key[2]);
-				add_key(wl->vif[0].wilc_netdev->ieee80211_ptr->wiphy,
-					wl->vif[0].wilc_netdev,
+				add_key(wl->vif[0].ndev->ieee80211_ptr->wiphy,
+					wl->vif[0].ndev,
 					g_add_ptk_key_params.key_idx,
 					g_add_ptk_key_params.pairwise,
 					g_add_ptk_key_params.mac_addr,
 					(struct key_params *)(&g_key_ptk_params));
 
-				add_key(wl->vif[0].wilc_netdev->ieee80211_ptr->wiphy,
-					wl->vif[0].wilc_netdev,
+				add_key(wl->vif[0].ndev->ieee80211_ptr->wiphy,
+					wl->vif[0].ndev,
 					g_add_gtk_key_params.key_idx,
 					g_add_gtk_key_params.pairwise,
 					g_add_gtk_key_params.mac_addr,
@@ -2693,15 +2693,15 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 				PRINT_D(CFG80211_DBG, "gtk %x %x %x\n", g_key_gtk_params.key[0],
 					g_key_gtk_params.key[1],
 					g_key_gtk_params.key[2]);
-				add_key(wl->vif[0].wilc_netdev->ieee80211_ptr->wiphy,
-					wl->vif[0].wilc_netdev,
+				add_key(wl->vif[0].ndev->ieee80211_ptr->wiphy,
+					wl->vif[0].ndev,
 					g_add_ptk_key_params.key_idx,
 					g_add_ptk_key_params.pairwise,
 					g_add_ptk_key_params.mac_addr,
 					(struct key_params *)(&g_key_ptk_params));
 
-				add_key(wl->vif[0].wilc_netdev->ieee80211_ptr->wiphy,
-					wl->vif[0].wilc_netdev,
+				add_key(wl->vif[0].ndev->ieee80211_ptr->wiphy,
+					wl->vif[0].ndev,
 					g_add_gtk_key_params.key_idx,
 					g_add_gtk_key_params.pairwise,
 					g_add_gtk_key_params.mac_addr,
@@ -2811,15 +2811,15 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 				g_key_gtk_params.key[1],
 				g_key_gtk_params.key[2],
 				g_key_gtk_params.cipher);
-			add_key(wl->vif[0].wilc_netdev->ieee80211_ptr->wiphy,
-				wl->vif[0].wilc_netdev,
+			add_key(wl->vif[0].ndev->ieee80211_ptr->wiphy,
+				wl->vif[0].ndev,
 				g_add_ptk_key_params.key_idx,
 				g_add_ptk_key_params.pairwise,
 				g_add_ptk_key_params.mac_addr,
 				(struct key_params *)(&g_key_ptk_params));
 
-			add_key(wl->vif[0].wilc_netdev->ieee80211_ptr->wiphy,
-				wl->vif[0].wilc_netdev,
+			add_key(wl->vif[0].ndev->ieee80211_ptr->wiphy,
+				wl->vif[0].ndev,
 				g_add_gtk_key_params.key_idx,
 				g_add_gtk_key_params.pairwise,
 				g_add_gtk_key_params.mac_addr,
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index 64b931b..54b6039 100644
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

