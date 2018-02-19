Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:36608 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753167AbeBSPai (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Feb 2018 10:30:38 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <Adham.Abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 09/14] staging: wilc1000: rename functions starting with Handle_ to avoid camelCase
Date: Mon, 19 Feb 2018 20:59:39 +0530
Message-ID: <1519054184-14301-10-git-send-email-ajay.kathat@microchip.com> (sfid-20180219_163047_903035_FE058633)
In-Reply-To: <1519054184-14301-1-git-send-email-ajay.kathat@microchip.com>
References: <1519054184-14301-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix "Avoid camelCase" issue found by checkpatch.pl script.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 98 +++++++++++++++----------------
 1 file changed, 49 insertions(+), 49 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 24c9a36..b861c95 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -902,7 +902,7 @@ static s32 handle_scan_done(struct wilc_vif *vif,
 }
 
 u8 wilc_connected_ssid[6] = {0};
-static s32 Handle_Connect(struct wilc_vif *vif,
+static s32 handle_connect(struct wilc_vif *vif,
 			  struct connect_attr *pstrHostIFconnectAttr)
 {
 	s32 result = 0;
@@ -1244,8 +1244,8 @@ static s32 handle_connect_timeout(struct wilc_vif *vif)
 	return result;
 }
 
-static s32 Handle_RcvdNtwrkInfo(struct wilc_vif *vif,
-				struct rcvd_net_info *rcvd_info)
+static s32 handle_rcvd_ntwrk_info(struct wilc_vif *vif,
+				  struct rcvd_net_info *rcvd_info)
 {
 	u32 i;
 	bool bNewNtwrkFound;
@@ -1318,8 +1318,8 @@ static s32 host_int_get_assoc_res_info(struct wilc_vif *vif,
 				       u32 max_assoc_resp_info_len,
 				       u32 *rcvd_assoc_resp_info_len);
 
-static s32 Handle_RcvdGnrlAsyncInfo(struct wilc_vif *vif,
-				    struct rcvd_async_info *rcvd_info)
+static s32 handle_rcvd_gnrl_async_info(struct wilc_vif *vif,
+				       struct rcvd_async_info *rcvd_info)
 {
 	s32 result = 0;
 	u8 u8MsgType = 0;
@@ -1777,7 +1777,7 @@ static int handle_key(struct wilc_vif *vif,
 	return result;
 }
 
-static void Handle_Disconnect(struct wilc_vif *vif)
+static void handle_disconnect(struct wilc_vif *vif)
 {
 	struct wid wid;
 	struct host_if_drv *hif_drv = vif->hif_drv;
@@ -1869,7 +1869,7 @@ void wilc_resolve_disconnect_aberration(struct wilc_vif *vif)
 		wilc_disconnect(vif, 1);
 }
 
-static void Handle_GetRssi(struct wilc_vif *vif)
+static void handle_get_rssi(struct wilc_vif *vif)
 {
 	s32 result = 0;
 	struct wid wid;
@@ -1889,8 +1889,8 @@ static void Handle_GetRssi(struct wilc_vif *vif)
 	complete(&vif->hif_drv->comp_get_rssi);
 }
 
-static s32 Handle_GetStatistics(struct wilc_vif *vif,
-				struct rf_info *pstrStatistics)
+static s32 handle_get_statistics(struct wilc_vif *vif,
+				 struct rf_info *pstrStatistics)
 {
 	struct wid wid_list[5];
 	u32 wid_cnt = 0, result = 0;
@@ -1943,8 +1943,8 @@ static s32 Handle_GetStatistics(struct wilc_vif *vif,
 	return 0;
 }
 
-static s32 Handle_Get_InActiveTime(struct wilc_vif *vif,
-				   struct sta_inactive_t *hif_sta_inactive)
+static s32 handle_get_inactive_time(struct wilc_vif *vif,
+				    struct sta_inactive_t *hif_sta_inactive)
 {
 	s32 result = 0;
 	u8 *stamac;
@@ -1987,8 +1987,8 @@ static s32 Handle_Get_InActiveTime(struct wilc_vif *vif,
 	return result;
 }
 
-static void Handle_AddBeacon(struct wilc_vif *vif,
-			     struct beacon_attr *pstrSetBeaconParam)
+static void handle_add_beacon(struct wilc_vif *vif,
+			      struct beacon_attr *pstrSetBeaconParam)
 {
 	s32 result = 0;
 	struct wid wid;
@@ -2040,7 +2040,7 @@ static void Handle_AddBeacon(struct wilc_vif *vif,
 	kfree(pstrSetBeaconParam->tail);
 }
 
-static void Handle_DelBeacon(struct wilc_vif *vif)
+static void handle_del_beacon(struct wilc_vif *vif)
 {
 	s32 result = 0;
 	struct wid wid;
@@ -2095,8 +2095,8 @@ static u32 WILC_HostIf_PackStaParam(u8 *pu8Buffer,
 	return cur_byte - pu8Buffer;
 }
 
-static void Handle_AddStation(struct wilc_vif *vif,
-			      struct add_sta_param *pstrStationParam)
+static void handle_add_station(struct wilc_vif *vif,
+			       struct add_sta_param *pstrStationParam)
 {
 	s32 result = 0;
 	struct wid wid;
@@ -2164,8 +2164,8 @@ static void handle_del_all_sta(struct wilc_vif *vif,
 	complete(&hif_wait_response);
 }
 
-static void Handle_DelStation(struct wilc_vif *vif,
-			      struct del_sta *pstrDelStaParam)
+static void handle_del_station(struct wilc_vif *vif,
+			       struct del_sta *pstrDelStaParam)
 {
 	s32 result = 0;
 	struct wid wid;
@@ -2192,8 +2192,8 @@ static void Handle_DelStation(struct wilc_vif *vif,
 	kfree(wid.val);
 }
 
-static void Handle_EditStation(struct wilc_vif *vif,
-			       struct add_sta_param *pstrStationParam)
+static void handle_edit_station(struct wilc_vif *vif,
+				struct add_sta_param *pstrStationParam)
 {
 	s32 result = 0;
 	struct wid wid;
@@ -2220,8 +2220,8 @@ static void Handle_EditStation(struct wilc_vif *vif,
 	kfree(wid.val);
 }
 
-static int Handle_RemainOnChan(struct wilc_vif *vif,
-			       struct remain_ch *hif_remain_ch)
+static int handle_remain_on_chan(struct wilc_vif *vif,
+				 struct remain_ch *hif_remain_ch)
 {
 	s32 result = 0;
 	u8 u8remain_on_chan_flag;
@@ -2289,8 +2289,8 @@ static int Handle_RemainOnChan(struct wilc_vif *vif,
 	return result;
 }
 
-static int Handle_RegisterFrame(struct wilc_vif *vif,
-				struct reg_frame *hif_reg_frame)
+static int handle_register_frame(struct wilc_vif *vif,
+				 struct reg_frame *hif_reg_frame)
 {
 	s32 result = 0;
 	struct wid wid;
@@ -2320,8 +2320,8 @@ static int Handle_RegisterFrame(struct wilc_vif *vif,
 	return result;
 }
 
-static u32 Handle_ListenStateExpired(struct wilc_vif *vif,
-				     struct remain_ch *hif_remain_ch)
+static u32 handle_listen_state_expired(struct wilc_vif *vif,
+				       struct remain_ch *hif_remain_ch)
 {
 	u8 u8remain_on_chan_flag;
 	struct wid wid;
@@ -2382,8 +2382,8 @@ static void ListenTimerCB(struct timer_list *t)
 		netdev_err(vif->ndev, "wilc_mq_send fail\n");
 }
 
-static void Handle_PowerManagement(struct wilc_vif *vif,
-				   struct power_mgmt_param *pm_param)
+static void handle_power_management(struct wilc_vif *vif,
+				    struct power_mgmt_param *pm_param)
 {
 	s32 result = 0;
 	struct wid wid;
@@ -2498,16 +2498,16 @@ static void host_if_work(struct work_struct *work)
 		break;
 
 	case HOST_IF_MSG_CONNECT:
-		Handle_Connect(msg->vif, &msg->body.con_info);
+		handle_connect(msg->vif, &msg->body.con_info);
 		break;
 
 	case HOST_IF_MSG_RCVD_NTWRK_INFO:
-		Handle_RcvdNtwrkInfo(msg->vif, &msg->body.net_info);
+		handle_rcvd_ntwrk_info(msg->vif, &msg->body.net_info);
 		break;
 
 	case HOST_IF_MSG_RCVD_GNRL_ASYNC_INFO:
-		Handle_RcvdGnrlAsyncInfo(msg->vif,
-					 &msg->body.async_info);
+		handle_rcvd_gnrl_async_info(msg->vif,
+					    &msg->body.async_info);
 		break;
 
 	case HOST_IF_MSG_KEY:
@@ -2523,7 +2523,7 @@ static void host_if_work(struct work_struct *work)
 		break;
 
 	case HOST_IF_MSG_DISCONNECT:
-		Handle_Disconnect(msg->vif);
+		handle_disconnect(msg->vif);
 		break;
 
 	case HOST_IF_MSG_RCVD_SCAN_COMPLETE:
@@ -2535,42 +2535,42 @@ static void host_if_work(struct work_struct *work)
 		handle_scan_done(msg->vif, SCAN_EVENT_DONE);
 
 		if (msg->vif->hif_drv->remain_on_ch_pending)
-			Handle_RemainOnChan(msg->vif,
-					    &msg->body.remain_on_ch);
+			handle_remain_on_chan(msg->vif,
+					      &msg->body.remain_on_ch);
 
 		break;
 
 	case HOST_IF_MSG_GET_RSSI:
-		Handle_GetRssi(msg->vif);
+		handle_get_rssi(msg->vif);
 		break;
 
 	case HOST_IF_MSG_GET_STATISTICS:
-		Handle_GetStatistics(msg->vif,
-				     (struct rf_info *)msg->body.data);
+		handle_get_statistics(msg->vif,
+				      (struct rf_info *)msg->body.data);
 		break;
 
 	case HOST_IF_MSG_ADD_BEACON:
-		Handle_AddBeacon(msg->vif, &msg->body.beacon_info);
+		handle_add_beacon(msg->vif, &msg->body.beacon_info);
 		break;
 
 	case HOST_IF_MSG_DEL_BEACON:
-		Handle_DelBeacon(msg->vif);
+		handle_del_beacon(msg->vif);
 		break;
 
 	case HOST_IF_MSG_ADD_STATION:
-		Handle_AddStation(msg->vif, &msg->body.add_sta_info);
+		handle_add_station(msg->vif, &msg->body.add_sta_info);
 		break;
 
 	case HOST_IF_MSG_DEL_STATION:
-		Handle_DelStation(msg->vif, &msg->body.del_sta_info);
+		handle_del_station(msg->vif, &msg->body.del_sta_info);
 		break;
 
 	case HOST_IF_MSG_EDIT_STATION:
-		Handle_EditStation(msg->vif, &msg->body.edit_sta_info);
+		handle_edit_station(msg->vif, &msg->body.edit_sta_info);
 		break;
 
 	case HOST_IF_MSG_GET_INACTIVETIME:
-		Handle_Get_InActiveTime(msg->vif, &msg->body.mac_info);
+		handle_get_inactive_time(msg->vif, &msg->body.mac_info);
 		break;
 
 	case HOST_IF_MSG_SCAN_TIMER_FIRED:
@@ -2582,8 +2582,8 @@ static void host_if_work(struct work_struct *work)
 		break;
 
 	case HOST_IF_MSG_POWER_MGMT:
-		Handle_PowerManagement(msg->vif,
-				       &msg->body.pwr_mgmt_info);
+		handle_power_management(msg->vif,
+					&msg->body.pwr_mgmt_info);
 		break;
 
 	case HOST_IF_MSG_SET_WFIDRV_HANDLER:
@@ -2610,15 +2610,15 @@ static void host_if_work(struct work_struct *work)
 		break;
 
 	case HOST_IF_MSG_REMAIN_ON_CHAN:
-		Handle_RemainOnChan(msg->vif, &msg->body.remain_on_ch);
+		handle_remain_on_chan(msg->vif, &msg->body.remain_on_ch);
 		break;
 
 	case HOST_IF_MSG_REGISTER_FRAME:
-		Handle_RegisterFrame(msg->vif, &msg->body.reg_frame);
+		handle_register_frame(msg->vif, &msg->body.reg_frame);
 		break;
 
 	case HOST_IF_MSG_LISTEN_TIMER_FIRED:
-		Handle_ListenStateExpired(msg->vif, &msg->body.remain_on_ch);
+		handle_listen_state_expired(msg->vif, &msg->body.remain_on_ch);
 		break;
 
 	case HOST_IF_MSG_SET_MULTICAST_FILTER:
-- 
2.7.4
