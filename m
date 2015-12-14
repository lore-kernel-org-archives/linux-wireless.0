Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:13735 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119AbbLNFn4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Dec 2015 00:43:56 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 06/12] staging: wilc1000: wilc_set_wfi_drv_handler: pass vif index
Date: Mon, 14 Dec 2015 14:46:57 +0900
Message-ID: <1450072023-13013-7-git-send-email-glen.lee@atmel.com> (sfid-20151214_064402_282837_FA20C966)
In-Reply-To: <1450072023-13013-1-git-send-email-glen.lee@atmel.com>
References: <1450072023-13013-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pass index of vif instead of hif_drv. wilc_get_vif_idx is used to get correct
index of vif.
In the handler function handle_set_wfi_drv_handler, use vif instead of hif_drv,
and use hif_drv_handler->handler instead of hif_drv when deinitialize wilc
device.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c         | 14 ++++++--------
 drivers/staging/wilc1000/host_interface.h         |  3 ++-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 12 +++++++-----
 3 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 0893331..840253b 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -313,7 +313,7 @@ static int get_id_from_handler(struct host_if_drv *handler)
  * special purpose in wilc device, so we add 1 to the index to starts from 1.
  * As a result, the returned index will be 1 to NUM_CONCURRENT_IFC.
  */
-static int wilc_get_vif_idx(struct wilc_vif *vif)
+int wilc_get_vif_idx(struct wilc_vif *vif)
 {
 	return vif->u8IfIdx + 1;
 }
@@ -363,17 +363,16 @@ static s32 handle_set_wfi_drv_handler(struct wilc_vif *vif,
 {
 	s32 result = 0;
 	struct wid wid;
-	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	wid.id = (u16)WID_SET_DRV_HANDLER;
 	wid.type = WID_INT;
 	wid.val = (s8 *)&hif_drv_handler->handler;
 	wid.size = sizeof(u32);
 
-	result = wilc_send_config_pkt(hif_drv->wilc, SET_CFG, &wid, 1,
+	result = wilc_send_config_pkt(vif->wilc, SET_CFG, &wid, 1,
 				      hif_drv_handler->handler);
 
-	if (!hif_drv)
+	if (!hif_drv_handler->handler)
 		up(&hif_sema_driver);
 
 	if (result) {
@@ -3631,15 +3630,14 @@ int wilc_wait_msg_queue_idle(void)
 	return result;
 }
 
-int wilc_set_wfi_drv_handler(struct wilc_vif *vif, struct host_if_drv *hif_drv)
+int wilc_set_wfi_drv_handler(struct wilc_vif *vif, int index)
 {
 	int result = 0;
 	struct host_if_msg msg;
 
 	memset(&msg, 0, sizeof(struct host_if_msg));
 	msg.id = HOST_IF_MSG_SET_WFIDRV_HANDLER;
-	msg.body.drv.handler = get_id_from_handler(hif_drv);
-	msg.drv = hif_drv;
+	msg.body.drv.handler = index;
 	msg.vif = vif;
 
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
@@ -3994,7 +3992,7 @@ s32 wilc_deinit(struct wilc_vif *vif)
 
 	del_timer_sync(&hif_drv->remain_on_ch_timer);
 
-	wilc_set_wfi_drv_handler(vif, NULL);
+	wilc_set_wfi_drv_handler(vif, 0);
 	down(&hif_sema_driver);
 
 	if (hif_drv->usr_scan_req.scan_result) {
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 9716bc8..8922f29 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -367,13 +367,14 @@ s32 wilc_remain_on_channel(struct wilc_vif *vif, u32 u32SessionID,
 			   void *pvUserArg);
 s32 wilc_listen_state_expired(struct wilc_vif *vif, u32 u32SessionID);
 s32 wilc_frame_register(struct wilc_vif *vif, u16 u16FrameType, bool bReg);
-int wilc_set_wfi_drv_handler(struct wilc_vif *vif, struct host_if_drv *hif_drv);
+int wilc_set_wfi_drv_handler(struct wilc_vif *vif, int index);
 int wilc_set_operation_mode(struct wilc_vif *vif, u32 mode);
 
 void wilc_free_join_params(void *pJoinParams);
 
 s32 wilc_get_statistics(struct wilc_vif *vif, struct rf_info *pstrStatistics);
 void wilc_resolve_disconnect_aberration(struct wilc_vif *vif);
+int wilc_get_vif_idx(struct wilc_vif *vif);
 
 extern bool wilc_optaining_ip;
 extern u8 wilc_connected_ssid[6];
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index da4c4ad..53fb2d4 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -628,7 +628,7 @@ static int scan(struct wiphy *wiphy, struct cfg80211_scan_request *request)
 
 	priv->u32RcvdChCount = 0;
 
-	wilc_set_wfi_drv_handler(vif, priv->hWILCWFIDrv);
+	wilc_set_wfi_drv_handler(vif, wilc_get_vif_idx(vif));
 	reset_shadow_found();
 
 	priv->bCfgScanning = true;
@@ -709,7 +709,7 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
 	vif = netdev_priv(priv->dev);
 	pstrWFIDrv = (struct host_if_drv *)(priv->hWILCWFIDrv);
 
-	wilc_set_wfi_drv_handler(vif, priv->hWILCWFIDrv);
+	wilc_set_wfi_drv_handler(vif, wilc_get_vif_idx(vif));
 
 	PRINT_D(CFG80211_DBG, "Connecting to SSID [%s] on netdev [%p] host if [%p]\n", sme->ssid, dev, priv->hWILCWFIDrv);
 	if (!(strncmp(sme->ssid, "DIRECT-", 7))) {
@@ -2142,7 +2142,8 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 			wilc_initialized = 1;
 			vif->iftype = interface_type;
 
-			wilc_set_wfi_drv_handler(vif, wl->vif[0]->hif_drv);
+			wilc_set_wfi_drv_handler(vif,
+						 wilc_get_vif_idx(wl->vif[0]));
 			wilc_set_mac_address(wl->vif[0], wl->vif[0]->src_addr);
 			wilc_set_operation_mode(vif, STATION_MODE);
 
@@ -2217,7 +2218,8 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 			wilc1000_wlan_init(dev, vif);
 			wilc_initialized = 1;
 
-			wilc_set_wfi_drv_handler(vif, wl->vif[0]->hif_drv);
+			wilc_set_wfi_drv_handler(vif,
+						 wilc_get_vif_idx(wl->vif[0]));
 			wilc_set_mac_address(wl->vif[0], wl->vif[0]->src_addr);
 			wilc_set_operation_mode(vif, STATION_MODE);
 
@@ -2320,7 +2322,7 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 		wilc1000_wlan_init(dev, vif);
 		wilc_initialized = 1;
 
-		wilc_set_wfi_drv_handler(vif, wl->vif[0]->hif_drv);
+		wilc_set_wfi_drv_handler(vif, wilc_get_vif_idx(wl->vif[0]));
 		wilc_set_mac_address(wl->vif[0], wl->vif[0]->src_addr);
 		wilc_set_operation_mode(vif, AP_MODE);
 
-- 
1.9.1

