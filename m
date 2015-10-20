Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:16983 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753501AbbJTIOu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Oct 2015 04:14:50 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 06/13] staging: wilc1000: chage_virtual_intf: use netdev private wilc
Date: Tue, 20 Oct 2015 17:13:56 +0900
Message-ID: <1445328843-32247-6-git-send-email-tony.cho@atmel.com> (sfid-20151020_101454_268566_BBBBB223)
In-Reply-To: <1445328843-32247-1-git-send-email-tony.cho@atmel.com>
References: <1445328843-32247-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Glen Lee <glen.lee@atmel.com>

Use netdev private data member wilc instead of global variable g_linux_wlan.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 85 ++++++++++++-----------
 1 file changed, 45 insertions(+), 40 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 264fcb9..422d462 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -2534,9 +2534,11 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 	u8 interface_type;
 	u16 TID = 0;
 	u8 i;
+	struct wilc *wl;
 
 	nic = netdev_priv(dev);
 	priv = wiphy_priv(wiphy);
+	wl = nic->wilc;
 
 	PRINT_D(HOSTAPD_DBG, "In Change virtual interface function\n");
 	PRINT_D(HOSTAPD_DBG, "Wireless interface name =%s\n", dev->name);
@@ -2571,30 +2573,31 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 		interface_type = nic->iftype;
 		nic->iftype = STATION_MODE;
 
-		if (g_linux_wlan->initialized) {
-			host_int_del_All_Rx_BASession(priv->hWILCWFIDrv, g_linux_wlan->vif[0].bssid, TID);
+		if (wl->initialized) {
+			host_int_del_All_Rx_BASession(priv->hWILCWFIDrv,
+						      wl->vif[0].bssid, TID);
 			/* ensure that the message Q is empty */
 			host_int_wait_msg_queue_idle();
 
 			/*Eliminate host interface blocking state*/
-			up(&g_linux_wlan->cfg_event);
+			up(&wl->cfg_event);
 
-			wilc1000_wlan_deinit(g_linux_wlan);
+			wilc1000_wlan_deinit(wl);
 			wilc1000_wlan_init(dev, nic);
 			g_wilc_initialized = 1;
 			nic->iftype = interface_type;
 
 			/*Setting interface 1 drv handler and mac address in newly downloaded FW*/
-			host_int_set_wfi_drv_handler(g_linux_wlan->vif[0].hif_drv);
-			host_int_set_MacAddress(g_linux_wlan->vif[0].hif_drv,
-						g_linux_wlan->vif[0].src_addr);
+			host_int_set_wfi_drv_handler(wl->vif[0].hif_drv);
+			host_int_set_MacAddress(wl->vif[0].hif_drv,
+						wl->vif[0].src_addr);
 			host_int_set_operation_mode(priv->hWILCWFIDrv, STATION_MODE);
 
 			/*Add saved WEP keys, if any*/
 			if (g_wep_keys_saved) {
-				host_int_set_WEPDefaultKeyID(g_linux_wlan->vif[0].hif_drv,
+				host_int_set_WEPDefaultKeyID(wl->vif[0].hif_drv,
 							     g_key_wep_params.key_idx);
-				host_int_add_wep_key_bss_sta(g_linux_wlan->vif[0].hif_drv,
+				host_int_add_wep_key_bss_sta(wl->vif[0].hif_drv,
 							     g_key_wep_params.key,
 							     g_key_wep_params.key_len,
 							     g_key_wep_params.key_idx);
@@ -2612,22 +2615,22 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 				PRINT_D(CFG80211_DBG, "gtk %x %x %x\n", g_key_gtk_params.key[0],
 					g_key_gtk_params.key[1],
 					g_key_gtk_params.key[2]);
-				add_key(g_linux_wlan->vif[0].ndev->ieee80211_ptr->wiphy,
-					g_linux_wlan->vif[0].ndev,
+				add_key(wl->vif[0].ndev->ieee80211_ptr->wiphy,
+					wl->vif[0].ndev,
 					g_add_ptk_key_params.key_idx,
 					g_add_ptk_key_params.pairwise,
 					g_add_ptk_key_params.mac_addr,
 					(struct key_params *)(&g_key_ptk_params));
 
-				add_key(g_linux_wlan->vif[0].ndev->ieee80211_ptr->wiphy,
-					g_linux_wlan->vif[0].ndev,
+				add_key(wl->vif[0].ndev->ieee80211_ptr->wiphy,
+					wl->vif[0].ndev,
 					g_add_gtk_key_params.key_idx,
 					g_add_gtk_key_params.pairwise,
 					g_add_gtk_key_params.mac_addr,
 					(struct key_params *)(&g_key_gtk_params));
 			}
 
-			if (g_linux_wlan->initialized)	{
+			if (wl->initialized)	{
 				for (i = 0; i < num_reg_frame; i++) {
 					PRINT_D(INIT_DBG, "Frame registering Type: %x - Reg: %d\n", nic->g_struct_frame_reg[i].frame_type,
 						nic->g_struct_frame_reg[i].reg);
@@ -2648,7 +2651,8 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 		connecting = 0;
 		PRINT_D(HOSTAPD_DBG, "Interface type = NL80211_IFTYPE_P2P_CLIENT\n");
 
-		host_int_del_All_Rx_BASession(priv->hWILCWFIDrv, g_linux_wlan->vif[0].bssid, TID);
+		host_int_del_All_Rx_BASession(priv->hWILCWFIDrv,
+					      wl->vif[0].bssid, TID);
 
 		dev->ieee80211_ptr->iftype = type;
 		priv->wdev->iftype = type;
@@ -2658,24 +2662,24 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 		nic->iftype = CLIENT_MODE;
 
 
-		if (g_linux_wlan->initialized)	{
+		if (wl->initialized)	{
 			/* ensure that the message Q is empty */
 			host_int_wait_msg_queue_idle();
 
-			wilc1000_wlan_deinit(g_linux_wlan);
+			wilc1000_wlan_deinit(wl);
 			wilc1000_wlan_init(dev, nic);
 			g_wilc_initialized = 1;
 
-			host_int_set_wfi_drv_handler(g_linux_wlan->vif[0].hif_drv);
-			host_int_set_MacAddress(g_linux_wlan->vif[0].hif_drv,
-						g_linux_wlan->vif[0].src_addr);
+			host_int_set_wfi_drv_handler(wl->vif[0].hif_drv);
+			host_int_set_MacAddress(wl->vif[0].hif_drv,
+						wl->vif[0].src_addr);
 			host_int_set_operation_mode(priv->hWILCWFIDrv, STATION_MODE);
 
 			/*Add saved WEP keys, if any*/
 			if (g_wep_keys_saved) {
-				host_int_set_WEPDefaultKeyID(g_linux_wlan->vif[0].hif_drv,
+				host_int_set_WEPDefaultKeyID(wl->vif[0].hif_drv,
 							     g_key_wep_params.key_idx);
-				host_int_add_wep_key_bss_sta(g_linux_wlan->vif[0].hif_drv,
+				host_int_add_wep_key_bss_sta(wl->vif[0].hif_drv,
 							     g_key_wep_params.key,
 							     g_key_wep_params.key_len,
 							     g_key_wep_params.key_idx);
@@ -2693,15 +2697,15 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 				PRINT_D(CFG80211_DBG, "gtk %x %x %x\n", g_key_gtk_params.key[0],
 					g_key_gtk_params.key[1],
 					g_key_gtk_params.key[2]);
-				add_key(g_linux_wlan->vif[0].ndev->ieee80211_ptr->wiphy,
-					g_linux_wlan->vif[0].ndev,
+				add_key(wl->vif[0].ndev->ieee80211_ptr->wiphy,
+					wl->vif[0].ndev,
 					g_add_ptk_key_params.key_idx,
 					g_add_ptk_key_params.pairwise,
 					g_add_ptk_key_params.mac_addr,
 					(struct key_params *)(&g_key_ptk_params));
 
-				add_key(g_linux_wlan->vif[0].ndev->ieee80211_ptr->wiphy,
-					g_linux_wlan->vif[0].ndev,
+				add_key(wl->vif[0].ndev->ieee80211_ptr->wiphy,
+					wl->vif[0].ndev,
 					g_add_gtk_key_params.key_idx,
 					g_add_gtk_key_params.pairwise,
 					g_add_gtk_key_params.mac_addr,
@@ -2712,7 +2716,7 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 			refresh_scan(priv, 1, true);
 			Set_machw_change_vir_if(false);
 
-			if (g_linux_wlan->initialized)	{
+			if (wl->initialized)	{
 				for (i = 0; i < num_reg_frame; i++) {
 					PRINT_D(INIT_DBG, "Frame registering Type: %x - Reg: %d\n", nic->g_struct_frame_reg[i].frame_type,
 						nic->g_struct_frame_reg[i].reg);
@@ -2735,7 +2739,7 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 		PRINT_D(HOSTAPD_DBG, "Downloading AP firmware\n");
 		linux_wlan_get_firmware(nic);
 		/*If wilc is running, then close-open to actually get new firmware running (serves P2P)*/
-		if (g_linux_wlan->initialized)	{
+		if (wl->initialized)	{
 			nic->iftype = AP_MODE;
 			mac_close(dev);
 			mac_open(dev);
@@ -2760,7 +2764,8 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 		/*sent before downloading new FW. This is because it blocks on*/
 		/*hWaitResponse semaphore, which allows previous config*/
 		/*packets to actually take action on old FW*/
-		host_int_del_All_Rx_BASession(priv->hWILCWFIDrv, g_linux_wlan->vif[0].bssid, TID);
+		host_int_del_All_Rx_BASession(priv->hWILCWFIDrv,
+					      wl->vif[0].bssid, TID);
 		bEnablePS = false;
 		PRINT_D(HOSTAPD_DBG, "Interface type = NL80211_IFTYPE_GO\n");
 		dev->ieee80211_ptr->iftype = type;
@@ -2775,22 +2780,22 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 
 		/* ensure that the message Q is empty */
 		host_int_wait_msg_queue_idle();
-		wilc1000_wlan_deinit(g_linux_wlan);
+		wilc1000_wlan_deinit(wl);
 		wilc1000_wlan_init(dev, nic);
 		g_wilc_initialized = 1;
 
 
 		/*Setting interface 1 drv handler and mac address in newly downloaded FW*/
-		host_int_set_wfi_drv_handler(g_linux_wlan->vif[0].hif_drv);
-		host_int_set_MacAddress(g_linux_wlan->vif[0].hif_drv,
-					g_linux_wlan->vif[0].src_addr);
+		host_int_set_wfi_drv_handler(wl->vif[0].hif_drv);
+		host_int_set_MacAddress(wl->vif[0].hif_drv,
+					wl->vif[0].src_addr);
 		host_int_set_operation_mode(priv->hWILCWFIDrv, AP_MODE);
 
 		/*Add saved WEP keys, if any*/
 		if (g_wep_keys_saved) {
-			host_int_set_WEPDefaultKeyID(g_linux_wlan->vif[0].hif_drv,
+			host_int_set_WEPDefaultKeyID(wl->vif[0].hif_drv,
 						     g_key_wep_params.key_idx);
-			host_int_add_wep_key_bss_sta(g_linux_wlan->vif[0].hif_drv,
+			host_int_add_wep_key_bss_sta(wl->vif[0].hif_drv,
 						     g_key_wep_params.key,
 						     g_key_wep_params.key_len,
 						     g_key_wep_params.key_idx);
@@ -2810,22 +2815,22 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 				g_key_gtk_params.key[1],
 				g_key_gtk_params.key[2],
 				g_key_gtk_params.cipher);
-			add_key(g_linux_wlan->vif[0].ndev->ieee80211_ptr->wiphy,
-				g_linux_wlan->vif[0].ndev,
+			add_key(wl->vif[0].ndev->ieee80211_ptr->wiphy,
+				wl->vif[0].ndev,
 				g_add_ptk_key_params.key_idx,
 				g_add_ptk_key_params.pairwise,
 				g_add_ptk_key_params.mac_addr,
 				(struct key_params *)(&g_key_ptk_params));
 
-			add_key(g_linux_wlan->vif[0].ndev->ieee80211_ptr->wiphy,
-				g_linux_wlan->vif[0].ndev,
+			add_key(wl->vif[0].ndev->ieee80211_ptr->wiphy,
+				wl->vif[0].ndev,
 				g_add_gtk_key_params.key_idx,
 				g_add_gtk_key_params.pairwise,
 				g_add_gtk_key_params.mac_addr,
 				(struct key_params *)(&g_key_gtk_params));
 		}
 
-		if (g_linux_wlan->initialized)	{
+		if (wl->initialized)	{
 			for (i = 0; i < num_reg_frame; i++) {
 				PRINT_D(INIT_DBG, "Frame registering Type: %x - Reg: %d\n", nic->g_struct_frame_reg[i].frame_type,
 					nic->g_struct_frame_reg[i].reg);
-- 
1.9.1

