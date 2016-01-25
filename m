Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:41012 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932100AbcAYHn3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jan 2016 02:43:29 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 13/26] staging: wilc1000: change_virtual_intf: change codes for unified firmware
Date: Mon, 25 Jan 2016 16:35:17 +0900
Message-ID: <1453707330-13526-14-git-send-email-glen.lee@atmel.com> (sfid-20160125_084332_386947_D149B7C9)
In-Reply-To: <1453707330-13526-1-git-send-email-glen.lee@atmel.com>
References: <1453707330-13526-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In previous patch, we use unified firmware on wilc, which means we do not need
to download firmware again to change virtual interfaces.
There are a lot of codes to change interface and they are needless now, so
remove them except wilc_set_operation_mode function which change the mode and
wilc_set_power_mgmt which control power save.
There will be unused functions and they will be removed in later patch.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 220 ++--------------------
 1 file changed, 11 insertions(+), 209 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 2db023f..4c18932 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -2098,9 +2098,6 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 {
 	struct wilc_priv *priv;
 	struct wilc_vif *vif;
-	u8 interface_type;
-	u16 TID = 0;
-	u8 i;
 	struct wilc *wl;
 
 	vif = netdev_priv(dev);
@@ -2125,74 +2122,12 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 		priv->wdev->iftype = type;
 		vif->monitor_flag = 0;
 		vif->iftype = STATION_MODE;
+		wilc_set_operation_mode(vif, STATION_MODE);
 
 		memset(priv->assoc_stainfo.au8Sta_AssociatedBss, 0, MAX_NUM_STA * ETH_ALEN);
-		interface_type = vif->iftype;
-		vif->iftype = STATION_MODE;
-
-		if (wl->initialized) {
-			wilc_del_all_rx_ba_session(vif, wl->vif[0]->bssid,
-						   TID);
-			wilc_wait_msg_queue_idle();
-
-			up(&wl->cfg_event);
-
-			wilc1000_wlan_deinit(dev);
-			wilc1000_wlan_init(dev, vif);
-			wilc_initialized = 1;
-			vif->iftype = interface_type;
-
-			wilc_set_wfi_drv_handler(vif,
-						 wilc_get_vif_idx(wl->vif[0]));
-			wilc_set_mac_address(wl->vif[0], wl->vif[0]->src_addr);
-			wilc_set_operation_mode(vif, STATION_MODE);
-
-			if (g_wep_keys_saved) {
-				wilc_set_wep_default_keyid(wl->vif[0],
-						g_key_wep_params.key_idx);
-				wilc_add_wep_key_bss_sta(wl->vif[0],
-						g_key_wep_params.key,
-						g_key_wep_params.key_len,
-						g_key_wep_params.key_idx);
-			}
-
-			wilc_flush_join_req(vif);
-
-			if (g_ptk_keys_saved && g_gtk_keys_saved) {
-				PRINT_D(CFG80211_DBG, "ptk %x %x %x\n", g_key_ptk_params.key[0],
-					g_key_ptk_params.key[1],
-					g_key_ptk_params.key[2]);
-				PRINT_D(CFG80211_DBG, "gtk %x %x %x\n", g_key_gtk_params.key[0],
-					g_key_gtk_params.key[1],
-					g_key_gtk_params.key[2]);
-				add_key(wl->vif[0]->ndev->ieee80211_ptr->wiphy,
-					wl->vif[0]->ndev,
-					g_add_ptk_key_params.key_idx,
-					g_add_ptk_key_params.pairwise,
-					g_add_ptk_key_params.mac_addr,
-					(struct key_params *)(&g_key_ptk_params));
-
-				add_key(wl->vif[0]->ndev->ieee80211_ptr->wiphy,
-					wl->vif[0]->ndev,
-					g_add_gtk_key_params.key_idx,
-					g_add_gtk_key_params.pairwise,
-					g_add_gtk_key_params.mac_addr,
-					(struct key_params *)(&g_key_gtk_params));
-			}
-
-			if (wl->initialized)	{
-				for (i = 0; i < num_reg_frame; i++) {
-					PRINT_D(INIT_DBG, "Frame registering Type: %x - Reg: %d\n", vif->g_struct_frame_reg[i].frame_type,
-						vif->g_struct_frame_reg[i].reg);
-					wilc_frame_register(vif,
-								vif->g_struct_frame_reg[i].frame_type,
-								vif->g_struct_frame_reg[i].reg);
-				}
-			}
 
-			wilc_enable_ps = true;
-			wilc_set_power_mgmt(vif, 1, 0);
-		}
+		wilc_enable_ps = true;
+		wilc_set_power_mgmt(vif, 1, 0);
 		break;
 
 	case NL80211_IFTYPE_P2P_CLIENT:
@@ -2201,73 +2136,11 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 		wilc_connecting = 0;
 		PRINT_D(HOSTAPD_DBG, "Interface type = NL80211_IFTYPE_P2P_CLIENT\n");
 
-		wilc_del_all_rx_ba_session(vif, wl->vif[0]->bssid, TID);
-
 		dev->ieee80211_ptr->iftype = type;
 		priv->wdev->iftype = type;
 		vif->monitor_flag = 0;
-
-		PRINT_D(HOSTAPD_DBG, "Downloading P2P_CONCURRENCY_FIRMWARE\n");
 		vif->iftype = CLIENT_MODE;
-
-
-		if (wl->initialized)	{
-			wilc_wait_msg_queue_idle();
-
-			wilc1000_wlan_deinit(dev);
-			wilc1000_wlan_init(dev, vif);
-			wilc_initialized = 1;
-
-			wilc_set_wfi_drv_handler(vif,
-						 wilc_get_vif_idx(wl->vif[0]));
-			wilc_set_mac_address(wl->vif[0], wl->vif[0]->src_addr);
-			wilc_set_operation_mode(vif, STATION_MODE);
-
-			if (g_wep_keys_saved) {
-				wilc_set_wep_default_keyid(wl->vif[0],
-						g_key_wep_params.key_idx);
-				wilc_add_wep_key_bss_sta(wl->vif[0],
-						g_key_wep_params.key,
-						g_key_wep_params.key_len,
-						g_key_wep_params.key_idx);
-			}
-
-			wilc_flush_join_req(vif);
-
-			if (g_ptk_keys_saved && g_gtk_keys_saved) {
-				PRINT_D(CFG80211_DBG, "ptk %x %x %x\n", g_key_ptk_params.key[0],
-					g_key_ptk_params.key[1],
-					g_key_ptk_params.key[2]);
-				PRINT_D(CFG80211_DBG, "gtk %x %x %x\n", g_key_gtk_params.key[0],
-					g_key_gtk_params.key[1],
-					g_key_gtk_params.key[2]);
-				add_key(wl->vif[0]->ndev->ieee80211_ptr->wiphy,
-					wl->vif[0]->ndev,
-					g_add_ptk_key_params.key_idx,
-					g_add_ptk_key_params.pairwise,
-					g_add_ptk_key_params.mac_addr,
-					(struct key_params *)(&g_key_ptk_params));
-
-				add_key(wl->vif[0]->ndev->ieee80211_ptr->wiphy,
-					wl->vif[0]->ndev,
-					g_add_gtk_key_params.key_idx,
-					g_add_gtk_key_params.pairwise,
-					g_add_gtk_key_params.mac_addr,
-					(struct key_params *)(&g_key_gtk_params));
-			}
-
-			refresh_scan(priv, 1, true);
-
-			if (wl->initialized)	{
-				for (i = 0; i < num_reg_frame; i++) {
-					PRINT_D(INIT_DBG, "Frame registering Type: %x - Reg: %d\n", vif->g_struct_frame_reg[i].frame_type,
-						vif->g_struct_frame_reg[i].reg);
-					wilc_frame_register(vif,
-								vif->g_struct_frame_reg[i].frame_type,
-								vif->g_struct_frame_reg[i].reg);
-				}
-			}
-		}
+		wilc_set_operation_mode(vif, STATION_MODE);
 		break;
 
 	case NL80211_IFTYPE_AP:
@@ -2276,23 +2149,11 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 		dev->ieee80211_ptr->iftype = type;
 		priv->wdev->iftype = type;
 		vif->iftype = AP_MODE;
-		PRINT_D(CORECONFIG_DBG, "priv->hWILCWFIDrv[%p]\n", priv->hWILCWFIDrv);
-
-		PRINT_D(HOSTAPD_DBG, "Downloading AP firmware\n");
-		wilc_wlan_get_firmware(dev);
-
-		if (wl->initialized)	{
-			vif->iftype = AP_MODE;
-			wilc_mac_close(dev);
-			wilc_mac_open(dev);
-
-			for (i = 0; i < num_reg_frame; i++) {
-				PRINT_D(INIT_DBG, "Frame registering Type: %x - Reg: %d\n", vif->g_struct_frame_reg[i].frame_type,
-					vif->g_struct_frame_reg[i].reg);
-				wilc_frame_register(vif,
-							vif->g_struct_frame_reg[i].frame_type,
-							vif->g_struct_frame_reg[i].reg);
-			}
+
+		if (wl->initialized) {
+			wilc_set_wfi_drv_handler(vif, wilc_get_vif_idx(vif));
+			wilc_set_operation_mode(vif, AP_MODE);
+			wilc_set_power_mgmt(vif, 0, 0);
 		}
 		break;
 
@@ -2303,72 +2164,13 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 		mod_timer(&wilc_during_ip_timer,
 			  jiffies + msecs_to_jiffies(during_ip_time));
 		wilc_set_power_mgmt(vif, 0, 0);
-		wilc_del_all_rx_ba_session(vif, wl->vif[0]->bssid, TID);
 		wilc_enable_ps = false;
 		PRINT_D(HOSTAPD_DBG, "Interface type = NL80211_IFTYPE_GO\n");
+
+		wilc_set_operation_mode(vif, AP_MODE);
 		dev->ieee80211_ptr->iftype = type;
 		priv->wdev->iftype = type;
-
-		PRINT_D(CORECONFIG_DBG, "priv->hWILCWFIDrv[%p]\n", priv->hWILCWFIDrv);
-
-		PRINT_D(HOSTAPD_DBG, "Downloading P2P_CONCURRENCY_FIRMWARE\n");
-
-
 		vif->iftype = GO_MODE;
-
-		wilc_wait_msg_queue_idle();
-		wilc1000_wlan_deinit(dev);
-		wilc1000_wlan_init(dev, vif);
-		wilc_initialized = 1;
-
-		wilc_set_wfi_drv_handler(vif, wilc_get_vif_idx(wl->vif[0]));
-		wilc_set_mac_address(wl->vif[0], wl->vif[0]->src_addr);
-		wilc_set_operation_mode(vif, AP_MODE);
-
-		if (g_wep_keys_saved) {
-			wilc_set_wep_default_keyid(wl->vif[0],
-						   g_key_wep_params.key_idx);
-			wilc_add_wep_key_bss_sta(wl->vif[0],
-						 g_key_wep_params.key,
-						 g_key_wep_params.key_len,
-						 g_key_wep_params.key_idx);
-		}
-
-		wilc_flush_join_req(vif);
-
-		if (g_ptk_keys_saved && g_gtk_keys_saved) {
-			PRINT_D(CFG80211_DBG, "ptk %x %x %x cipher %x\n", g_key_ptk_params.key[0],
-				g_key_ptk_params.key[1],
-				g_key_ptk_params.key[2],
-				g_key_ptk_params.cipher);
-			PRINT_D(CFG80211_DBG, "gtk %x %x %x cipher %x\n", g_key_gtk_params.key[0],
-				g_key_gtk_params.key[1],
-				g_key_gtk_params.key[2],
-				g_key_gtk_params.cipher);
-			add_key(wl->vif[0]->ndev->ieee80211_ptr->wiphy,
-				wl->vif[0]->ndev,
-				g_add_ptk_key_params.key_idx,
-				g_add_ptk_key_params.pairwise,
-				g_add_ptk_key_params.mac_addr,
-				(struct key_params *)(&g_key_ptk_params));
-
-			add_key(wl->vif[0]->ndev->ieee80211_ptr->wiphy,
-				wl->vif[0]->ndev,
-				g_add_gtk_key_params.key_idx,
-				g_add_gtk_key_params.pairwise,
-				g_add_gtk_key_params.mac_addr,
-				(struct key_params *)(&g_key_gtk_params));
-		}
-
-		if (wl->initialized)	{
-			for (i = 0; i < num_reg_frame; i++) {
-				PRINT_D(INIT_DBG, "Frame registering Type: %x - Reg: %d\n", vif->g_struct_frame_reg[i].frame_type,
-					vif->g_struct_frame_reg[i].reg);
-				wilc_frame_register(vif,
-							vif->g_struct_frame_reg[i].frame_type,
-							vif->g_struct_frame_reg[i].reg);
-			}
-		}
 		break;
 
 	default:
-- 
1.9.1

