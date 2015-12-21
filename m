Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:11762 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993AbbLUFSt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Dec 2015 00:18:49 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH RESEND 37/46] staging: wilc1000: take vif instead of drv in hostIFthread
Date: Mon, 21 Dec 2015 14:18:41 +0900
Message-ID: <1450675130-17866-38-git-send-email-glen.lee@atmel.com> (sfid-20151221_063106_219797_D9429B32)
In-Reply-To: <1450675130-17866-1-git-send-email-glen.lee@atmel.com>
References: <1450675130-17866-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In the first patch, we sent vif to hostIFthread. we can use vif instead of
drv in the all functions which handle the commands from cfg operations.
Change first argument host_if_drv with wilc_vif and use hif_drv of wilc_vif.
Pass vif to the functions as well.
In case of timer callback functions, set vif to the data and use vif instead
of hif_drv.
Lastly, initialize u32RcvdAssocRespInfoLen since changing hif_drv with vif
causes one uninitialied build warning.
Now we have vif that currently being used so we can use interface index of
wilc_vif to send to wilc device.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 238 +++++++++++++++++-------------
 1 file changed, 135 insertions(+), 103 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 421ce0d..007b9a0 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -316,11 +316,12 @@ static struct host_if_drv *get_handler_from_id(int id)
 	return wfidrv_list[id];
 }
 
-static s32 handle_set_channel(struct host_if_drv *hif_drv,
+static s32 handle_set_channel(struct wilc_vif *vif,
 			      struct channel_attr *hif_set_ch)
 {
 	s32 result = 0;
 	struct wid wid;
+	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	wid.id = (u16)WID_CURRENT_CHANNEL;
 	wid.type = WID_CHAR;
@@ -340,11 +341,12 @@ static s32 handle_set_channel(struct host_if_drv *hif_drv,
 	return result;
 }
 
-static s32 handle_set_wfi_drv_handler(struct host_if_drv *hif_drv,
+static s32 handle_set_wfi_drv_handler(struct wilc_vif *vif,
 				      struct drv_handler *hif_drv_handler)
 {
 	s32 result = 0;
 	struct wid wid;
+	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	wid.id = (u16)WID_SET_DRV_HANDLER;
 	wid.type = WID_INT;
@@ -365,11 +367,12 @@ static s32 handle_set_wfi_drv_handler(struct host_if_drv *hif_drv,
 	return result;
 }
 
-static s32 handle_set_operation_mode(struct host_if_drv *hif_drv,
+static s32 handle_set_operation_mode(struct wilc_vif *vif,
 				     struct op_mode *hif_op_mode)
 {
 	s32 result = 0;
 	struct wid wid;
+	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	wid.id = (u16)WID_SET_OPERATION_MODE;
 	wid.type = WID_INT;
@@ -394,13 +397,12 @@ static s32 host_int_get_ipaddress(struct wilc_vif *vif,
 				  struct host_if_drv *hif_drv,
 				  u8 *u16ipadd, u8 idx);
 
-static s32 handle_set_ip_address(struct wilc_vif *vif,
-				 struct host_if_drv *hif_drv, u8 *ip_addr,
-				 u8 idx)
+static s32 handle_set_ip_address(struct wilc_vif *vif, u8 *ip_addr, u8 idx)
 {
 	s32 result = 0;
 	struct wid wid;
 	char firmware_ip_addr[4] = {0};
+	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	if (ip_addr[0] < 192)
 		ip_addr[0] = 0;
@@ -430,11 +432,11 @@ static s32 handle_set_ip_address(struct wilc_vif *vif,
 	return result;
 }
 
-static s32 handle_get_ip_address(struct wilc_vif *vif,
-				 struct host_if_drv *hif_drv, u8 idx)
+static s32 handle_get_ip_address(struct wilc_vif *vif, u8 idx)
 {
 	s32 result = 0;
 	struct wid wid;
+	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	wid.id = (u16)WID_IP_ADDRESS;
 	wid.type = WID_STR;
@@ -465,11 +467,12 @@ static s32 handle_get_ip_address(struct wilc_vif *vif,
 	return result;
 }
 
-static s32 handle_set_mac_address(struct host_if_drv *hif_drv,
+static s32 handle_set_mac_address(struct wilc_vif *vif,
 				  struct set_mac_addr *set_mac_addr)
 {
 	s32 result = 0;
 	struct wid wid;
+	struct host_if_drv *hif_drv = vif->hif_drv;
 	u8 *mac_buf = kmalloc(ETH_ALEN, GFP_KERNEL);
 
 	if (!mac_buf) {
@@ -495,11 +498,12 @@ static s32 handle_set_mac_address(struct host_if_drv *hif_drv,
 	return result;
 }
 
-static s32 handle_get_mac_address(struct host_if_drv *hif_drv,
+static s32 handle_get_mac_address(struct wilc_vif *vif,
 				  struct get_mac_addr *get_mac_addr)
 {
 	s32 result = 0;
 	struct wid wid;
+	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	wid.id = (u16)WID_MAC_ADDR;
 	wid.type = WID_STR;
@@ -518,11 +522,12 @@ static s32 handle_get_mac_address(struct host_if_drv *hif_drv,
 	return result;
 }
 
-static s32 handle_cfg_param(struct host_if_drv *hif_drv,
+static s32 handle_cfg_param(struct wilc_vif *vif,
 			    struct cfg_param_attr *cfg_param_attr)
 {
 	s32 result = 0;
 	struct wid wid_list[32];
+	struct host_if_drv *hif_drv = vif->hif_drv;
 	u8 wid_cnt = 0;
 
 	down(&hif_drv->sem_cfg_values);
@@ -818,10 +823,10 @@ static void Handle_wait_msg_q_empty(void)
 	up(&hif_sema_wait_response);
 }
 
-static s32 Handle_ScanDone(struct host_if_drv *hif_drv,
+static s32 Handle_ScanDone(struct wilc_vif *vif,
 			   enum scan_event enuEvent);
 
-static s32 Handle_Scan(struct host_if_drv *hif_drv,
+static s32 Handle_Scan(struct wilc_vif *vif,
 		       struct scan_attr *pstrHostIFscanAttr)
 {
 	s32 result = 0;
@@ -831,6 +836,7 @@ static s32 Handle_Scan(struct host_if_drv *hif_drv,
 	u8 *pu8Buffer;
 	u8 valuesize = 0;
 	u8 *pu8HdnNtwrksWidVal = NULL;
+	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	PRINT_D(HOSTINF_DBG, "Setting SCAN params\n");
 	PRINT_D(HOSTINF_DBG, "Scanning: In [%d] state\n", hif_drv->hif_state);
@@ -936,7 +942,7 @@ static s32 Handle_Scan(struct host_if_drv *hif_drv,
 ERRORHANDLER:
 	if (result) {
 		del_timer(&hif_drv->scan_timer);
-		Handle_ScanDone(hif_drv, SCAN_EVENT_ABORTED);
+		Handle_ScanDone(vif, SCAN_EVENT_ABORTED);
 	}
 
 	kfree(pstrHostIFscanAttr->ch_freq_list);
@@ -952,12 +958,13 @@ ERRORHANDLER:
 	return result;
 }
 
-static s32 Handle_ScanDone(struct host_if_drv *hif_drv,
+static s32 Handle_ScanDone(struct wilc_vif *vif,
 			   enum scan_event enuEvent)
 {
 	s32 result = 0;
 	u8 u8abort_running_scan;
 	struct wid wid;
+	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	PRINT_D(HOSTINF_DBG, "in Handle_ScanDone()\n");
 
@@ -993,7 +1000,7 @@ static s32 Handle_ScanDone(struct host_if_drv *hif_drv,
 }
 
 u8 wilc_connected_ssid[6] = {0};
-static s32 Handle_Connect(struct host_if_drv *hif_drv,
+static s32 Handle_Connect(struct wilc_vif *vif,
 			  struct connect_attr *pstrHostIFconnectAttr)
 {
 	s32 result = 0;
@@ -1001,6 +1008,7 @@ static s32 Handle_Connect(struct host_if_drv *hif_drv,
 	u32 u32WidsCount = 0, dummyval = 0;
 	u8 *pu8CurrByte = NULL;
 	struct join_bss_param *ptstrJoinBssParam;
+	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	PRINT_D(GENERIC_DBG, "Handling connect request\n");
 
@@ -1286,12 +1294,13 @@ ERRORHANDLER:
 	return result;
 }
 
-static s32 Handle_FlushConnect(struct host_if_drv *hif_drv)
+static s32 Handle_FlushConnect(struct wilc_vif *vif)
 {
 	s32 result = 0;
 	struct wid strWIDList[5];
 	u32 u32WidsCount = 0;
 	u8 *pu8CurrByte = NULL;
+	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	strWIDList[u32WidsCount].id = WID_INFO_ELEMENT_ASSOCIATE;
 	strWIDList[u32WidsCount].type = WID_BIN_DATA;
@@ -1333,12 +1342,13 @@ static s32 Handle_FlushConnect(struct host_if_drv *hif_drv)
 	return result;
 }
 
-static s32 Handle_ConnectTimeout(struct host_if_drv *hif_drv)
+static s32 Handle_ConnectTimeout(struct wilc_vif *vif)
 {
 	s32 result = 0;
 	tstrConnectInfo strConnectInfo;
 	struct wid wid;
 	u16 u16DummyReasonCode = 0;
+	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	if (!hif_drv) {
 		PRINT_ER("Driver handler is NULL\n");
@@ -1413,7 +1423,7 @@ static s32 Handle_ConnectTimeout(struct host_if_drv *hif_drv)
 	return result;
 }
 
-static s32 Handle_RcvdNtwrkInfo(struct host_if_drv *hif_drv,
+static s32 Handle_RcvdNtwrkInfo(struct wilc_vif *vif,
 				struct rcvd_net_info *pstrRcvdNetworkInfo)
 {
 	u32 i;
@@ -1421,6 +1431,7 @@ static s32 Handle_RcvdNtwrkInfo(struct host_if_drv *hif_drv,
 	s32 result = 0;
 	tstrNetworkInfo *pstrNetworkInfo = NULL;
 	void *pJoinParams = NULL;
+	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	bNewNtwrkFound = true;
 	PRINT_INFO(HOSTINF_DBG, "Handling received network info\n");
@@ -1494,13 +1505,12 @@ done:
 	return result;
 }
 
-static s32 host_int_get_assoc_res_info(struct host_if_drv *hif_drv,
+static s32 host_int_get_assoc_res_info(struct wilc_vif *vif,
 				       u8 *pu8AssocRespInfo,
 				       u32 u32MaxAssocRespInfoLen,
 				       u32 *pu32RcvdAssocRespInfoLen);
 
 static s32 Handle_RcvdGnrlAsyncInfo(struct wilc_vif *vif,
-				    struct host_if_drv *hif_drv,
 				    struct rcvd_async_info *pstrRcvdGnrlAsyncInfo)
 {
 	s32 result = 0;
@@ -1515,6 +1525,7 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct wilc_vif *vif,
 	tstrConnectInfo strConnectInfo;
 	tstrDisconnectNotifInfo strDisconnectNotifInfo;
 	s32 s32Err = 0;
+	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	if (!hif_drv) {
 		PRINT_ER("Driver handler is NULL\n");
@@ -1548,7 +1559,7 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct wilc_vif *vif,
 		u8MacStatusAdditionalInfo = pstrRcvdGnrlAsyncInfo->buffer[9];
 		PRINT_INFO(HOSTINF_DBG, "Recieved MAC status = %d with Reason = %d , Info = %d\n", u8MacStatus, u8MacStatusReasonCode, u8MacStatusAdditionalInfo);
 		if (hif_drv->hif_state == HOST_IF_WAITING_CONN_RESP) {
-			u32 u32RcvdAssocRespInfoLen;
+			u32 u32RcvdAssocRespInfoLen = 0;
 			tstrConnectRespInfo *pstrConnectRespInfo = NULL;
 
 			PRINT_D(HOSTINF_DBG, "Recieved MAC status = %d with Reason = %d , Code = %d\n", u8MacStatus, u8MacStatusReasonCode, u8MacStatusAdditionalInfo);
@@ -1558,7 +1569,7 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct wilc_vif *vif,
 			if (u8MacStatus == MAC_CONNECTED) {
 				memset(rcv_assoc_resp, 0, MAX_ASSOC_RESP_FRAME_SIZE);
 
-				host_int_get_assoc_res_info(hif_drv,
+				host_int_get_assoc_res_info(vif,
 							    rcv_assoc_resp,
 							    MAX_ASSOC_RESP_FRAME_SIZE,
 							    &u32RcvdAssocRespInfoLen);
@@ -1666,7 +1677,7 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct wilc_vif *vif,
 			if (hif_drv->usr_scan_req.scan_result) {
 				PRINT_D(HOSTINF_DBG, "\n\n<< Abort the running OBSS Scan >>\n\n");
 				del_timer(&hif_drv->scan_timer);
-				Handle_ScanDone((void *)hif_drv, SCAN_EVENT_ABORTED);
+				Handle_ScanDone(vif, SCAN_EVENT_ABORTED);
 			}
 
 			strDisconnectNotifInfo.u16reason = 0;
@@ -1717,7 +1728,7 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct wilc_vif *vif,
 
 			del_timer(&hif_drv->scan_timer);
 			if (hif_drv->usr_scan_req.scan_result)
-				Handle_ScanDone(hif_drv, SCAN_EVENT_ABORTED);
+				Handle_ScanDone(vif, SCAN_EVENT_ABORTED);
 		}
 	}
 
@@ -1727,7 +1738,7 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct wilc_vif *vif,
 	return result;
 }
 
-static int Handle_Key(struct host_if_drv *hif_drv,
+static int Handle_Key(struct wilc_vif *vif,
 		      struct key_attr *pstrHostIFkeyAttr)
 {
 	s32 result = 0;
@@ -1737,6 +1748,7 @@ static int Handle_Key(struct host_if_drv *hif_drv,
 	u8 *pu8keybuf;
 	s8 s8idxarray[1];
 	s8 ret = 0;
+	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	switch (pstrHostIFkeyAttr->type) {
 	case WEP:
@@ -2000,10 +2012,10 @@ _WPAPtk_end_case_:
 	return result;
 }
 
-static void Handle_Disconnect(struct wilc_vif *vif,
-			      struct host_if_drv *hif_drv)
+static void Handle_Disconnect(struct wilc_vif *vif)
 {
 	struct wid wid;
+	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	s32 result = 0;
 	u16 u16DummyReasonCode = 0;
@@ -2098,10 +2110,11 @@ void wilc_resolve_disconnect_aberration(struct wilc_vif *vif)
 	}
 }
 
-static s32 Handle_GetChnl(struct host_if_drv *hif_drv)
+static s32 Handle_GetChnl(struct wilc_vif *vif)
 {
 	s32 result = 0;
 	struct wid wid;
+	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	wid.id = (u16)WID_CURRENT_CHANNEL;
 	wid.type = WID_CHAR;
@@ -2123,7 +2136,7 @@ static s32 Handle_GetChnl(struct host_if_drv *hif_drv)
 	return result;
 }
 
-static void Handle_GetRssi(struct host_if_drv *hif_drv)
+static void Handle_GetRssi(struct wilc_vif *vif)
 {
 	s32 result = 0;
 	struct wid wid;
@@ -2135,20 +2148,21 @@ static void Handle_GetRssi(struct host_if_drv *hif_drv)
 
 	PRINT_D(HOSTINF_DBG, "Getting RSSI value\n");
 
-	result = wilc_send_config_pkt(hif_drv->wilc, GET_CFG, &wid, 1,
-				 get_id_from_handler(hif_drv));
+	result = wilc_send_config_pkt(vif->hif_drv->wilc, GET_CFG, &wid, 1,
+				 get_id_from_handler(vif->hif_drv));
 	if (result) {
 		PRINT_ER("Failed to get RSSI value\n");
 		result = -EFAULT;
 	}
 
-	up(&hif_drv->sem_get_rssi);
+	up(&vif->hif_drv->sem_get_rssi);
 }
 
-static void Handle_GetLinkspeed(struct host_if_drv *hif_drv)
+static void Handle_GetLinkspeed(struct wilc_vif *vif)
 {
 	s32 result = 0;
 	struct wid wid;
+	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	link_speed = 0;
 
@@ -2169,10 +2183,12 @@ static void Handle_GetLinkspeed(struct host_if_drv *hif_drv)
 	up(&hif_drv->sem_get_link_speed);
 }
 
-static s32 Handle_GetStatistics(struct host_if_drv *hif_drv, struct rf_info *pstrStatistics)
+static s32 Handle_GetStatistics(struct wilc_vif *vif,
+				struct rf_info *pstrStatistics)
 {
 	struct wid strWIDList[5];
 	u32 u32WidsCount = 0, result = 0;
+	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	strWIDList[u32WidsCount].id = WID_LINKSPEED;
 	strWIDList[u32WidsCount].type = WID_CHAR;
@@ -2215,12 +2231,13 @@ static s32 Handle_GetStatistics(struct host_if_drv *hif_drv, struct rf_info *pst
 	return 0;
 }
 
-static s32 Handle_Get_InActiveTime(struct host_if_drv *hif_drv,
+static s32 Handle_Get_InActiveTime(struct wilc_vif *vif,
 				   struct sta_inactive_t *strHostIfStaInactiveT)
 {
 	s32 result = 0;
 	u8 *stamac;
 	struct wid wid;
+	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	wid.id = (u16)WID_SET_STA_MAC_INACTIVE_TIME;
 	wid.type = WID_STR;
@@ -2260,12 +2277,13 @@ static s32 Handle_Get_InActiveTime(struct host_if_drv *hif_drv,
 	return result;
 }
 
-static void Handle_AddBeacon(struct host_if_drv *hif_drv,
+static void Handle_AddBeacon(struct wilc_vif *vif,
 			     struct beacon_attr *pstrSetBeaconParam)
 {
 	s32 result = 0;
 	struct wid wid;
 	u8 *pu8CurrByte;
+	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	PRINT_D(HOSTINF_DBG, "Adding BEACON\n");
 
@@ -2315,11 +2333,12 @@ ERRORHANDLER:
 	kfree(pstrSetBeaconParam->tail);
 }
 
-static void Handle_DelBeacon(struct host_if_drv *hif_drv)
+static void Handle_DelBeacon(struct wilc_vif *vif)
 {
 	s32 result = 0;
 	struct wid wid;
 	u8 *pu8CurrByte;
+	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	wid.id = (u16)WID_DEL_BEACON;
 	wid.type = WID_CHAR;
@@ -2387,12 +2406,13 @@ static u32 WILC_HostIf_PackStaParam(u8 *pu8Buffer,
 	return pu8CurrByte - pu8Buffer;
 }
 
-static void Handle_AddStation(struct host_if_drv *hif_drv,
+static void Handle_AddStation(struct wilc_vif *vif,
 			      struct add_sta_param *pstrStationParam)
 {
 	s32 result = 0;
 	struct wid wid;
 	u8 *pu8CurrByte;
+	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	PRINT_D(HOSTINF_DBG, "Handling add station\n");
 	wid.id = (u16)WID_ADD_STA;
@@ -2416,7 +2436,7 @@ ERRORHANDLER:
 	kfree(wid.val);
 }
 
-static void Handle_DelAllSta(struct host_if_drv *hif_drv,
+static void Handle_DelAllSta(struct wilc_vif *vif,
 			     struct del_all_sta *pstrDelAllStaParam)
 {
 	s32 result = 0;
@@ -2424,6 +2444,7 @@ static void Handle_DelAllSta(struct host_if_drv *hif_drv,
 	u8 *pu8CurrByte;
 	u8 i;
 	u8 au8Zero_Buff[6] = {0};
+	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	wid.id = (u16)WID_DEL_ALL_STA;
 	wid.type = WID_STR;
@@ -2459,12 +2480,13 @@ ERRORHANDLER:
 	up(&hif_sema_wait_response);
 }
 
-static void Handle_DelStation(struct host_if_drv *hif_drv,
+static void Handle_DelStation(struct wilc_vif *vif,
 			      struct del_sta *pstrDelStaParam)
 {
 	s32 result = 0;
 	struct wid wid;
 	u8 *pu8CurrByte;
+	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	wid.id = (u16)WID_REMOVE_STA;
 	wid.type = WID_BIN;
@@ -2489,12 +2511,13 @@ ERRORHANDLER:
 	kfree(wid.val);
 }
 
-static void Handle_EditStation(struct host_if_drv *hif_drv,
+static void Handle_EditStation(struct wilc_vif *vif,
 			       struct add_sta_param *pstrStationParam)
 {
 	s32 result = 0;
 	struct wid wid;
 	u8 *pu8CurrByte;
+	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	wid.id = (u16)WID_EDIT_STA;
 	wid.type = WID_BIN;
@@ -2518,12 +2541,13 @@ ERRORHANDLER:
 	kfree(wid.val);
 }
 
-static int Handle_RemainOnChan(struct host_if_drv *hif_drv,
+static int Handle_RemainOnChan(struct wilc_vif *vif,
 			       struct remain_ch *pstrHostIfRemainOnChan)
 {
 	s32 result = 0;
 	u8 u8remain_on_chan_flag;
 	struct wid wid;
+	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	if (!hif_drv->remain_on_ch_pending) {
 		hif_drv->remain_on_ch.arg = pstrHostIfRemainOnChan->arg;
@@ -2577,7 +2601,7 @@ static int Handle_RemainOnChan(struct host_if_drv *hif_drv,
 ERRORHANDLER:
 	{
 		P2P_LISTEN_STATE = 1;
-		hif_drv->remain_on_ch_timer.data = (unsigned long)hif_drv;
+		hif_drv->remain_on_ch_timer.data = (unsigned long)vif;
 		mod_timer(&hif_drv->remain_on_ch_timer,
 			  jiffies +
 			  msecs_to_jiffies(pstrHostIfRemainOnChan->u32duration));
@@ -2592,12 +2616,13 @@ ERRORHANDLER:
 	return result;
 }
 
-static int Handle_RegisterFrame(struct host_if_drv *hif_drv,
+static int Handle_RegisterFrame(struct wilc_vif *vif,
 				struct reg_frame *pstrHostIfRegisterFrame)
 {
 	s32 result = 0;
 	struct wid wid;
 	u8 *pu8CurrByte;
+	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	PRINT_D(HOSTINF_DBG, "Handling frame register : %d FrameType: %d\n",
 		pstrHostIfRegisterFrame->reg,
@@ -2627,12 +2652,13 @@ static int Handle_RegisterFrame(struct host_if_drv *hif_drv,
 	return result;
 }
 
-static u32 Handle_ListenStateExpired(struct host_if_drv *hif_drv,
+static u32 Handle_ListenStateExpired(struct wilc_vif *vif,
 				     struct remain_ch *pstrHostIfRemainOnChan)
 {
 	u8 u8remain_on_chan_flag;
 	struct wid wid;
 	s32 result = 0;
+	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	PRINT_D(HOSTINF_DBG, "CANCEL REMAIN ON CHAN\n");
 
@@ -2676,26 +2702,27 @@ static void ListenTimerCB(unsigned long arg)
 {
 	s32 result = 0;
 	struct host_if_msg msg;
-	struct host_if_drv *hif_drv = (struct host_if_drv *)arg;
+	struct wilc_vif *vif = (struct wilc_vif *)arg;
 
-	del_timer(&hif_drv->remain_on_ch_timer);
+	del_timer(&vif->hif_drv->remain_on_ch_timer);
 
 	memset(&msg, 0, sizeof(struct host_if_msg));
 	msg.id = HOST_IF_MSG_LISTEN_TIMER_FIRED;
-	msg.drv = hif_drv;
-	msg.body.remain_on_ch.id = hif_drv->remain_on_ch.id;
+	msg.vif = vif;
+	msg.body.remain_on_ch.id = vif->hif_drv->remain_on_ch.id;
 
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 	if (result)
 		PRINT_ER("wilc_mq_send fail\n");
 }
 
-static void Handle_PowerManagement(struct host_if_drv *hif_drv,
+static void Handle_PowerManagement(struct wilc_vif *vif,
 				   struct power_mgmt_param *strPowerMgmtParam)
 {
 	s32 result = 0;
 	struct wid wid;
 	s8 s8PowerMode;
+	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	wid.id = (u16)WID_POWER_MANAGEMENT;
 
@@ -2715,12 +2742,13 @@ static void Handle_PowerManagement(struct host_if_drv *hif_drv,
 		PRINT_ER("Failed to send power management config packet\n");
 }
 
-static void Handle_SetMulticastFilter(struct host_if_drv *hif_drv,
+static void Handle_SetMulticastFilter(struct wilc_vif *vif,
 				      struct set_multicast *strHostIfSetMulti)
 {
 	s32 result = 0;
 	struct wid wid;
 	u8 *pu8CurrByte;
+	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	PRINT_D(HOSTINF_DBG, "Setup Multicast Filter\n");
 
@@ -2755,12 +2783,13 @@ ERRORHANDLER:
 	kfree(wid.val);
 }
 
-static s32 Handle_DelAllRxBASessions(struct host_if_drv *hif_drv,
+static s32 Handle_DelAllRxBASessions(struct wilc_vif *vif,
 				     struct ba_session_info *strHostIfBASessionInfo)
 {
 	s32 result = 0;
 	struct wid wid;
 	char *ptr = NULL;
+	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	PRINT_D(GENERIC_DBG, "Delete Block Ack session with\nBSSID = %.2x:%.2x:%.2x\nTID=%d\n",
 		strHostIfBASessionInfo->bssid[0],
@@ -2834,40 +2863,40 @@ static int hostIFthread(void *pvArg)
 			break;
 
 		case HOST_IF_MSG_SCAN:
-			Handle_Scan(msg.drv, &msg.body.scan_info);
+			Handle_Scan(msg.vif, &msg.body.scan_info);
 			break;
 
 		case HOST_IF_MSG_CONNECT:
-			Handle_Connect(msg.drv, &msg.body.con_info);
+			Handle_Connect(msg.vif, &msg.body.con_info);
 			break;
 
 		case HOST_IF_MSG_FLUSH_CONNECT:
-			Handle_FlushConnect(msg.drv);
+			Handle_FlushConnect(msg.vif);
 			break;
 
 		case HOST_IF_MSG_RCVD_NTWRK_INFO:
-			Handle_RcvdNtwrkInfo(msg.drv, &msg.body.net_info);
+			Handle_RcvdNtwrkInfo(msg.vif, &msg.body.net_info);
 			break;
 
 		case HOST_IF_MSG_RCVD_GNRL_ASYNC_INFO:
-			Handle_RcvdGnrlAsyncInfo(vif, msg.drv,
+			Handle_RcvdGnrlAsyncInfo(vif,
 						 &msg.body.async_info);
 			break;
 
 		case HOST_IF_MSG_KEY:
-			Handle_Key(msg.drv, &msg.body.key_info);
+			Handle_Key(msg.vif, &msg.body.key_info);
 			break;
 
 		case HOST_IF_MSG_CFG_PARAMS:
-			handle_cfg_param(msg.drv, &msg.body.cfg_info);
+			handle_cfg_param(msg.vif, &msg.body.cfg_info);
 			break;
 
 		case HOST_IF_MSG_SET_CHANNEL:
-			handle_set_channel(msg.drv, &msg.body.channel_info);
+			handle_set_channel(msg.vif, &msg.body.channel_info);
 			break;
 
 		case HOST_IF_MSG_DISCONNECT:
-			Handle_Disconnect(vif, msg.drv);
+			Handle_Disconnect(msg.vif);
 			break;
 
 		case HOST_IF_MSG_RCVD_SCAN_COMPLETE:
@@ -2877,124 +2906,126 @@ static int hostIFthread(void *pvArg)
 			if (!wilc_wlan_get_num_conn_ifcs(wilc))
 				wilc_chip_sleep_manually(wilc);
 
-			Handle_ScanDone(msg.drv, SCAN_EVENT_DONE);
+			Handle_ScanDone(msg.vif, SCAN_EVENT_DONE);
 
 			if (hif_drv->remain_on_ch_pending)
-				Handle_RemainOnChan(msg.drv, &msg.body.remain_on_ch);
+				Handle_RemainOnChan(msg.vif,
+						    &msg.body.remain_on_ch);
 
 			break;
 
 		case HOST_IF_MSG_GET_RSSI:
-			Handle_GetRssi(msg.drv);
+			Handle_GetRssi(msg.vif);
 			break;
 
 		case HOST_IF_MSG_GET_LINKSPEED:
-			Handle_GetLinkspeed(msg.drv);
+			Handle_GetLinkspeed(msg.vif);
 			break;
 
 		case HOST_IF_MSG_GET_STATISTICS:
-			Handle_GetStatistics(msg.drv, (struct rf_info *)msg.body.data);
+			Handle_GetStatistics(msg.vif,
+					     (struct rf_info *)msg.body.data);
 			break;
 
 		case HOST_IF_MSG_GET_CHNL:
-			Handle_GetChnl(msg.drv);
+			Handle_GetChnl(msg.vif);
 			break;
 
 		case HOST_IF_MSG_ADD_BEACON:
-			Handle_AddBeacon(msg.drv, &msg.body.beacon_info);
+			Handle_AddBeacon(msg.vif, &msg.body.beacon_info);
 			break;
 
 		case HOST_IF_MSG_DEL_BEACON:
-			Handle_DelBeacon(msg.drv);
+			Handle_DelBeacon(msg.vif);
 			break;
 
 		case HOST_IF_MSG_ADD_STATION:
-			Handle_AddStation(msg.drv, &msg.body.add_sta_info);
+			Handle_AddStation(msg.vif, &msg.body.add_sta_info);
 			break;
 
 		case HOST_IF_MSG_DEL_STATION:
-			Handle_DelStation(msg.drv, &msg.body.del_sta_info);
+			Handle_DelStation(msg.vif, &msg.body.del_sta_info);
 			break;
 
 		case HOST_IF_MSG_EDIT_STATION:
-			Handle_EditStation(msg.drv, &msg.body.edit_sta_info);
+			Handle_EditStation(msg.vif, &msg.body.edit_sta_info);
 			break;
 
 		case HOST_IF_MSG_GET_INACTIVETIME:
-			Handle_Get_InActiveTime(msg.drv, &msg.body.mac_info);
+			Handle_Get_InActiveTime(msg.vif, &msg.body.mac_info);
 			break;
 
 		case HOST_IF_MSG_SCAN_TIMER_FIRED:
 			PRINT_D(HOSTINF_DBG, "Scan Timeout\n");
 
-			Handle_ScanDone(msg.drv, SCAN_EVENT_ABORTED);
+			Handle_ScanDone(msg.vif, SCAN_EVENT_ABORTED);
 			break;
 
 		case HOST_IF_MSG_CONNECT_TIMER_FIRED:
 			PRINT_D(HOSTINF_DBG, "Connect Timeout\n");
-			Handle_ConnectTimeout(msg.drv);
+			Handle_ConnectTimeout(msg.vif);
 			break;
 
 		case HOST_IF_MSG_POWER_MGMT:
-			Handle_PowerManagement(msg.drv, &msg.body.pwr_mgmt_info);
+			Handle_PowerManagement(msg.vif,
+					       &msg.body.pwr_mgmt_info);
 			break;
 
 		case HOST_IF_MSG_SET_WFIDRV_HANDLER:
-			handle_set_wfi_drv_handler(msg.drv, &msg.body.drv);
+			handle_set_wfi_drv_handler(msg.vif, &msg.body.drv);
 			break;
 
 		case HOST_IF_MSG_SET_OPERATION_MODE:
-			handle_set_operation_mode(msg.drv, &msg.body.mode);
+			handle_set_operation_mode(msg.vif, &msg.body.mode);
 			break;
 
 		case HOST_IF_MSG_SET_IPADDRESS:
 			PRINT_D(HOSTINF_DBG, "HOST_IF_MSG_SET_IPADDRESS\n");
-			handle_set_ip_address(vif, msg.drv,
+			handle_set_ip_address(vif,
 					      msg.body.ip_info.ip_addr,
 					      msg.body.ip_info.idx);
 			break;
 
 		case HOST_IF_MSG_GET_IPADDRESS:
 			PRINT_D(HOSTINF_DBG, "HOST_IF_MSG_SET_IPADDRESS\n");
-			handle_get_ip_address(vif, msg.drv,
-					      msg.body.ip_info.idx);
+			handle_get_ip_address(vif, msg.body.ip_info.idx);
 			break;
 
 		case HOST_IF_MSG_SET_MAC_ADDRESS:
-			handle_set_mac_address(msg.drv,
+			handle_set_mac_address(msg.vif,
 					       &msg.body.set_mac_info);
 			break;
 
 		case HOST_IF_MSG_GET_MAC_ADDRESS:
-			handle_get_mac_address(msg.drv,
+			handle_get_mac_address(msg.vif,
 					       &msg.body.get_mac_info);
 			break;
 
 		case HOST_IF_MSG_REMAIN_ON_CHAN:
 			PRINT_D(HOSTINF_DBG, "HOST_IF_MSG_REMAIN_ON_CHAN\n");
-			Handle_RemainOnChan(msg.drv, &msg.body.remain_on_ch);
+			Handle_RemainOnChan(msg.vif, &msg.body.remain_on_ch);
 			break;
 
 		case HOST_IF_MSG_REGISTER_FRAME:
 			PRINT_D(HOSTINF_DBG, "HOST_IF_MSG_REGISTER_FRAME\n");
-			Handle_RegisterFrame(msg.drv, &msg.body.reg_frame);
+			Handle_RegisterFrame(msg.vif, &msg.body.reg_frame);
 			break;
 
 		case HOST_IF_MSG_LISTEN_TIMER_FIRED:
-			Handle_ListenStateExpired(msg.drv, &msg.body.remain_on_ch);
+			Handle_ListenStateExpired(msg.vif, &msg.body.remain_on_ch);
 			break;
 
 		case HOST_IF_MSG_SET_MULTICAST_FILTER:
 			PRINT_D(HOSTINF_DBG, "HOST_IF_MSG_SET_MULTICAST_FILTER\n");
-			Handle_SetMulticastFilter(msg.drv, &msg.body.multicast_info);
+			Handle_SetMulticastFilter(msg.vif, &msg.body.multicast_info);
 			break;
 
 		case HOST_IF_MSG_DEL_ALL_RX_BA_SESSIONS:
-			Handle_DelAllRxBASessions(msg.drv, &msg.body.session_info);
+			Handle_DelAllRxBASessions(msg.vif, &msg.body.session_info);
 			break;
 
 		case HOST_IF_MSG_DEL_ALL_STA:
-			Handle_DelAllSta(msg.drv, &msg.body.del_all_sta_info);
+			Handle_DelAllSta(msg.vif, &msg.body.del_all_sta_info);
 			break;
 
 		default:
@@ -3010,11 +3041,11 @@ static int hostIFthread(void *pvArg)
 
 static void TimerCB_Scan(unsigned long arg)
 {
-	void *pvArg = (void *)arg;
+	struct wilc_vif *vif = (struct wilc_vif *)arg;
 	struct host_if_msg msg;
 
 	memset(&msg, 0, sizeof(struct host_if_msg));
-	msg.drv = pvArg;
+	msg.vif = vif;
 	msg.id = HOST_IF_MSG_SCAN_TIMER_FIRED;
 
 	wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
@@ -3022,11 +3053,11 @@ static void TimerCB_Scan(unsigned long arg)
 
 static void TimerCB_Connect(unsigned long arg)
 {
-	void *pvArg = (void *)arg;
+	struct wilc_vif *vif = (struct wilc_vif *)arg;
 	struct host_if_msg msg;
 
 	memset(&msg, 0, sizeof(struct host_if_msg));
-	msg.drv = pvArg;
+	msg.vif = vif;
 	msg.id = HOST_IF_MSG_CONNECT_TIMER_FIRED;
 
 	wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
@@ -3454,7 +3485,7 @@ s32 wilc_set_join_req(struct wilc_vif *vif, u8 *pu8bssid, const u8 *pu8ssid,
 		return -EFAULT;
 	}
 
-	hif_drv->connect_timer.data = (unsigned long)hif_drv;
+	hif_drv->connect_timer.data = (unsigned long)vif;
 	mod_timer(&hif_drv->connect_timer,
 		  jiffies + msecs_to_jiffies(HOST_IF_CONNECT_TIMEOUT));
 
@@ -3514,13 +3545,14 @@ s32 wilc_disconnect(struct wilc_vif *vif, u16 u16ReasonCode)
 	return result;
 }
 
-static s32 host_int_get_assoc_res_info(struct host_if_drv *hif_drv,
+static s32 host_int_get_assoc_res_info(struct wilc_vif *vif,
 				       u8 *pu8AssocRespInfo,
 				       u32 u32MaxAssocRespInfoLen,
 				       u32 *pu32RcvdAssocRespInfoLen)
 {
 	s32 result = 0;
 	struct wid wid;
+	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	if (!hif_drv) {
 		PRINT_ER("Driver is null\n");
@@ -3758,7 +3790,7 @@ s32 wilc_scan(struct wilc_vif *vif, u8 u8ScanSource, u8 u8ScanType,
 	}
 
 	PRINT_D(HOSTINF_DBG, ">> Starting the SCAN timer\n");
-	hif_drv->scan_timer.data = (unsigned long)hif_drv;
+	hif_drv->scan_timer.data = (unsigned long)vif;
 	mod_timer(&hif_drv->scan_timer,
 		  jiffies + msecs_to_jiffies(HOST_IF_SCAN_TIMEOUT));
 
@@ -3790,21 +3822,21 @@ s32 wilc_hif_set_cfg(struct wilc_vif *vif,
 
 static void GetPeriodicRSSI(unsigned long arg)
 {
-	struct host_if_drv *hif_drv = (struct host_if_drv *)arg;
+	struct wilc_vif *vif = (struct wilc_vif *)arg;
 
-	if (!hif_drv)	{
+	if (!vif->hif_drv) {
 		PRINT_ER("Driver handler is NULL\n");
 		return;
 	}
 
-	if (hif_drv->hif_state == HOST_IF_CONNECTED) {
+	if (vif->hif_drv->hif_state == HOST_IF_CONNECTED) {
 		s32 result = 0;
 		struct host_if_msg msg;
 
 		memset(&msg, 0, sizeof(struct host_if_msg));
 
 		msg.id = HOST_IF_MSG_GET_RSSI;
-		msg.drv = hif_drv;
+		msg.vif = vif;
 
 		result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 		if (result) {
@@ -3812,7 +3844,7 @@ static void GetPeriodicRSSI(unsigned long arg)
 			return;
 		}
 	}
-	periodic_rssi.data = (unsigned long)hif_drv;
+	periodic_rssi.data = (unsigned long)vif;
 	mod_timer(&periodic_rssi, jiffies + msecs_to_jiffies(5000));
 }
 
@@ -3881,7 +3913,7 @@ s32 wilc_init(struct net_device *dev, struct host_if_drv **hif_drv_handler)
 			goto _fail_mq_;
 		}
 		setup_timer(&periodic_rssi, GetPeriodicRSSI,
-			    (unsigned long)hif_drv);
+			    (unsigned long)vif);
 		mod_timer(&periodic_rssi, jiffies + msecs_to_jiffies(5000));
 	}
 
-- 
1.9.1

