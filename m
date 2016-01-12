Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:52660 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933315AbcALHhL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jan 2016 02:37:11 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 15/26] staging: wilc1000: wilc_set_wfi_drv_handler: add mac index
Date: Tue, 12 Jan 2016 16:39:44 +0900
Message-ID: <1452584395-24910-16-git-send-email-glen.lee@atmel.com> (sfid-20160112_083721_457113_A7486968)
In-Reply-To: <1452584395-24910-1-git-send-email-glen.lee@atmel.com>
References: <1452584395-24910-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Firmware supports sta/ap concurrency so mac index will be passed to wilc.
Remove wilc_set_wfi_drv_handler in scan and connect functions, and call
the function in ndo_open which is wilc_mac_open.
WID_SET_DRV_HANDLER value has been changed as well.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c         | 11 ++++++-----
 drivers/staging/wilc1000/host_interface.h         |  3 ++-
 drivers/staging/wilc1000/linux_wlan.c             | 19 +++++++++++++++++++
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c |  6 ++----
 drivers/staging/wilc1000/wilc_wlan_if.h           |  2 +-
 5 files changed, 30 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 8c77520..9ffed32 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -319,9 +319,9 @@ static s32 handle_set_wfi_drv_handler(struct wilc_vif *vif,
 	struct wid wid;
 
 	wid.id = (u16)WID_SET_DRV_HANDLER;
-	wid.type = WID_INT;
-	wid.val = (s8 *)&hif_drv_handler->handler;
-	wid.size = sizeof(u32);
+	wid.type = WID_STR;
+	wid.val = (s8 *)hif_drv_handler;
+	wid.size = sizeof(*hif_drv_handler);
 
 	result = wilc_send_config_pkt(vif->wilc, SET_CFG, &wid, 1,
 				      hif_drv_handler->handler);
@@ -3558,7 +3558,7 @@ int wilc_wait_msg_queue_idle(void)
 	return result;
 }
 
-int wilc_set_wfi_drv_handler(struct wilc_vif *vif, int index)
+int wilc_set_wfi_drv_handler(struct wilc_vif *vif, int index, u8 mac_idx)
 {
 	int result = 0;
 	struct host_if_msg msg;
@@ -3566,6 +3566,7 @@ int wilc_set_wfi_drv_handler(struct wilc_vif *vif, int index)
 	memset(&msg, 0, sizeof(struct host_if_msg));
 	msg.id = HOST_IF_MSG_SET_WFIDRV_HANDLER;
 	msg.body.drv.handler = index;
+	msg.body.drv.mac_idx = mac_idx;
 	msg.vif = vif;
 
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
@@ -3906,7 +3907,7 @@ s32 wilc_deinit(struct wilc_vif *vif)
 
 	del_timer_sync(&hif_drv->remain_on_ch_timer);
 
-	wilc_set_wfi_drv_handler(vif, 0);
+	wilc_set_wfi_drv_handler(vif, 0, 0);
 	down(&hif_sema_driver);
 
 	if (hif_drv->usr_scan_req.scan_result) {
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 8faac27..5794246 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -217,6 +217,7 @@ struct user_conn_req {
 
 struct drv_handler {
 	u32 handler;
+	u8 mac_idx;
 };
 
 struct op_mode {
@@ -366,7 +367,7 @@ s32 wilc_remain_on_channel(struct wilc_vif *vif, u32 u32SessionID,
 			   void *pvUserArg);
 s32 wilc_listen_state_expired(struct wilc_vif *vif, u32 u32SessionID);
 s32 wilc_frame_register(struct wilc_vif *vif, u16 u16FrameType, bool bReg);
-int wilc_set_wfi_drv_handler(struct wilc_vif *vif, int index);
+int wilc_set_wfi_drv_handler(struct wilc_vif *vif, int index, u8 mac_idx);
 int wilc_set_operation_mode(struct wilc_vif *vif, u32 mode);
 
 void wilc_free_join_params(void *pJoinParams);
diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 68a50e6..9dd59da 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1024,6 +1024,25 @@ int wilc_mac_open(struct net_device *ndev)
 	for (i = 0; i < wl->vif_num; i++) {
 		if (ndev == wl->vif[i]->ndev) {
 			memcpy(wl->vif[i]->src_addr, mac_add, ETH_ALEN);
+			if (vif->iftype == AP_MODE) {
+				wilc_set_wfi_drv_handler(vif,
+							 wilc_get_vif_idx(vif),
+							 0);
+			} else if (!wilc_wlan_get_num_conn_ifcs(wilc)) {
+				wilc_set_wfi_drv_handler(vif,
+							 wilc_get_vif_idx(vif),
+							 wilc->open_ifcs);
+			} else {
+				if (memcmp(wilc->vif[i^1]->bssid,
+					   wilc->vif[i^1]->src_addr, 6))
+					wilc_set_wfi_drv_handler(vif,
+							 wilc_get_vif_idx(vif),
+							 0);
+				else
+					wilc_set_wfi_drv_handler(vif,
+							 wilc_get_vif_idx(vif),
+							 1);
+			}
 			wilc_set_operation_mode(vif, vif->iftype);
 			break;
 		}
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index c399326..fe99a13 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -633,7 +633,6 @@ static int scan(struct wiphy *wiphy, struct cfg80211_scan_request *request)
 
 	priv->u32RcvdChCount = 0;
 
-	wilc_set_wfi_drv_handler(vif, wilc_get_vif_idx(vif));
 	reset_shadow_found();
 
 	priv->bCfgScanning = true;
@@ -714,8 +713,6 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
 	vif = netdev_priv(priv->dev);
 	pstrWFIDrv = (struct host_if_drv *)(priv->hWILCWFIDrv);
 
-	wilc_set_wfi_drv_handler(vif, wilc_get_vif_idx(vif));
-
 	PRINT_D(CFG80211_DBG, "Connecting to SSID [%s] on netdev [%p] host if [%p]\n", sme->ssid, dev, priv->hWILCWFIDrv);
 	if (!(strncmp(sme->ssid, "DIRECT-", 7))) {
 		PRINT_D(CFG80211_DBG, "Connected to Direct network,OBSS disabled\n");
@@ -2152,7 +2149,8 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 		vif->iftype = AP_MODE;
 
 		if (wl->initialized) {
-			wilc_set_wfi_drv_handler(vif, wilc_get_vif_idx(vif));
+			wilc_set_wfi_drv_handler(vif, wilc_get_vif_idx(vif),
+						 0);
 			wilc_set_operation_mode(vif, AP_MODE);
 			wilc_set_power_mgmt(vif, 0, 0);
 		}
diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
index 618903c..d306ec1a 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -832,7 +832,6 @@ typedef enum {
 
 	/* Custom Integer WID list */
 	WID_GET_INACTIVE_TIME		= 0x2084,
-	WID_SET_DRV_HANDLER		= 0X2085,
 	WID_SET_OPERATION_MODE		= 0X2086,
 	/* EMAC String WID list */
 	WID_SSID			= 0x3000,
@@ -865,6 +864,7 @@ typedef enum {
 	WID_MODEL_NAME			= 0x3027, /*Added for CAPI tool */
 	WID_MODEL_NUM			= 0x3028, /*Added for CAPI tool */
 	WID_DEVICE_NAME			= 0x3029, /*Added for CAPI tool */
+	WID_SET_DRV_HANDLER		= 0x3030,
 
 	/* NMAC String WID list */
 	WID_11N_P_ACTION_REQ		= 0x3080,
-- 
1.9.1

