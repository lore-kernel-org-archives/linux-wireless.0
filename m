Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:11946 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347AbbJLH4k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Oct 2015 03:56:40 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 02/41] staging: wilc1000: rename the member variable, drvHandler of host_if_msg
Date: Mon, 12 Oct 2015 16:55:36 +0900
Message-ID: <1444636575-2486-2-git-send-email-tony.cho@atmel.com> (sfid-20151012_095643_751703_90291D3A)
In-Reply-To: <1444636575-2486-1-git-send-email-tony.cho@atmel.com>
References: <1444636575-2486-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames drvHandler of struct host_if_msg to drv.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 168 +++++++++++++++---------------
 1 file changed, 84 insertions(+), 84 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index e9df5a4..667eb4f 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -403,7 +403,7 @@ union message_body {
 struct host_if_msg {
 	u16 id;                                           /*!< Message ID */
 	union message_body body;             /*!< Message body */
-	struct host_if_drv *drvHandler;
+	struct host_if_drv *drv;
 };
 
 typedef struct _tstrWidJoinReqExt {
@@ -3656,7 +3656,7 @@ static void ListenTimerCB(unsigned long arg)
 	/* prepare the Timer Callback message */
 	memset(&msg, 0, sizeof(struct host_if_msg));
 	msg.id = HOST_IF_MSG_LISTEN_TIMER_FIRED;
-	msg.drvHandler = pstrWFIDrv;
+	msg.drv = pstrWFIDrv;
 	msg.body.remain_on_ch.u32ListenSessionID = pstrWFIDrv->strHostIfRemainOnChan.u32ListenSessionID;
 
 	/* send the message */
@@ -3914,7 +3914,7 @@ static int hostIFthread(void *pvArg)
 
 	while (1) {
 		wilc_mq_recv(&gMsgQHostIF, &msg, sizeof(struct host_if_msg), &u32Ret);
-		pstrWFIDrv = (struct host_if_drv *)msg.drvHandler;
+		pstrWFIDrv = (struct host_if_drv *)msg.drv;
 		if (msg.id == HOST_IF_MSG_EXIT) {
 			PRINT_D(GENERIC_DBG, "THREAD: Exiting HostIfThread\n");
 			break;
@@ -3942,40 +3942,40 @@ static int hostIFthread(void *pvArg)
 			break;
 
 		case HOST_IF_MSG_SCAN:
-			Handle_Scan(msg.drvHandler, &msg.body.scan_info);
+			Handle_Scan(msg.drv, &msg.body.scan_info);
 			break;
 
 		case HOST_IF_MSG_CONNECT:
-			Handle_Connect(msg.drvHandler, &msg.body.con_info);
+			Handle_Connect(msg.drv, &msg.body.con_info);
 			break;
 
 		case HOST_IF_MSG_FLUSH_CONNECT:
-			Handle_FlushConnect(msg.drvHandler);
+			Handle_FlushConnect(msg.drv);
 			break;
 
 		case HOST_IF_MSG_RCVD_NTWRK_INFO:
-			Handle_RcvdNtwrkInfo(msg.drvHandler, &msg.body.net_info);
+			Handle_RcvdNtwrkInfo(msg.drv, &msg.body.net_info);
 			break;
 
 		case HOST_IF_MSG_RCVD_GNRL_ASYNC_INFO:
-			Handle_RcvdGnrlAsyncInfo(msg.drvHandler, &msg.body.async_info);
+			Handle_RcvdGnrlAsyncInfo(msg.drv, &msg.body.async_info);
 			break;
 
 		case HOST_IF_MSG_KEY:
-			Handle_Key(msg.drvHandler, &msg.body.key_info);
+			Handle_Key(msg.drv, &msg.body.key_info);
 			break;
 
 		case HOST_IF_MSG_CFG_PARAMS:
 
-			Handle_CfgParam(msg.drvHandler, &msg.body.cfg_info);
+			Handle_CfgParam(msg.drv, &msg.body.cfg_info);
 			break;
 
 		case HOST_IF_MSG_SET_CHANNEL:
-			Handle_SetChannel(msg.drvHandler, &msg.body.channel_info);
+			Handle_SetChannel(msg.drv, &msg.body.channel_info);
 			break;
 
 		case HOST_IF_MSG_DISCONNECT:
-			Handle_Disconnect(msg.drvHandler);
+			Handle_Disconnect(msg.drv);
 			break;
 
 		case HOST_IF_MSG_RCVD_SCAN_COMPLETE:
@@ -3986,124 +3986,124 @@ static int hostIFthread(void *pvArg)
 			if (!linux_wlan_get_num_conn_ifcs())
 				chip_sleep_manually(INFINITE_SLEEP_TIME);
 
-			Handle_ScanDone(msg.drvHandler, SCAN_EVENT_DONE);
+			Handle_ScanDone(msg.drv, SCAN_EVENT_DONE);
 
 			if (pstrWFIDrv->u8RemainOnChan_pendingreq)
-				Handle_RemainOnChan(msg.drvHandler, &msg.body.remain_on_ch);
+				Handle_RemainOnChan(msg.drv, &msg.body.remain_on_ch);
 
 			break;
 
 		case HOST_IF_MSG_GET_RSSI:
-			Handle_GetRssi(msg.drvHandler);
+			Handle_GetRssi(msg.drv);
 			break;
 
 		case HOST_IF_MSG_GET_LINKSPEED:
-			Handle_GetLinkspeed(msg.drvHandler);
+			Handle_GetLinkspeed(msg.drv);
 			break;
 
 		case HOST_IF_MSG_GET_STATISTICS:
-			Handle_GetStatistics(msg.drvHandler, (tstrStatistics *)msg.body.data);
+			Handle_GetStatistics(msg.drv, (tstrStatistics *)msg.body.data);
 			break;
 
 		case HOST_IF_MSG_GET_CHNL:
-			Handle_GetChnl(msg.drvHandler);
+			Handle_GetChnl(msg.drv);
 			break;
 
 		case HOST_IF_MSG_ADD_BEACON:
-			Handle_AddBeacon(msg.drvHandler, &msg.body.beacon_info);
+			Handle_AddBeacon(msg.drv, &msg.body.beacon_info);
 			break;
 
 		case HOST_IF_MSG_DEL_BEACON:
-			Handle_DelBeacon(msg.drvHandler);
+			Handle_DelBeacon(msg.drv);
 			break;
 
 		case HOST_IF_MSG_ADD_STATION:
-			Handle_AddStation(msg.drvHandler, &msg.body.add_sta_info);
+			Handle_AddStation(msg.drv, &msg.body.add_sta_info);
 			break;
 
 		case HOST_IF_MSG_DEL_STATION:
-			Handle_DelStation(msg.drvHandler, &msg.body.del_sta_info);
+			Handle_DelStation(msg.drv, &msg.body.del_sta_info);
 			break;
 
 		case HOST_IF_MSG_EDIT_STATION:
-			Handle_EditStation(msg.drvHandler, &msg.body.edit_sta_info);
+			Handle_EditStation(msg.drv, &msg.body.edit_sta_info);
 			break;
 
 		case HOST_IF_MSG_GET_INACTIVETIME:
-			Handle_Get_InActiveTime(msg.drvHandler, &msg.body.mac_info);
+			Handle_Get_InActiveTime(msg.drv, &msg.body.mac_info);
 			break;
 
 		case HOST_IF_MSG_SCAN_TIMER_FIRED:
 			PRINT_D(HOSTINF_DBG, "Scan Timeout\n");
 
-			Handle_ScanDone(msg.drvHandler, SCAN_EVENT_ABORTED);
+			Handle_ScanDone(msg.drv, SCAN_EVENT_ABORTED);
 			break;
 
 		case HOST_IF_MSG_CONNECT_TIMER_FIRED:
 			PRINT_D(HOSTINF_DBG, "Connect Timeout\n");
-			Handle_ConnectTimeout(msg.drvHandler);
+			Handle_ConnectTimeout(msg.drv);
 			break;
 
 		case HOST_IF_MSG_POWER_MGMT:
-			Handle_PowerManagement(msg.drvHandler, &msg.body.pwr_mgmt_info);
+			Handle_PowerManagement(msg.drv, &msg.body.pwr_mgmt_info);
 			break;
 
 		case HOST_IF_MSG_SET_WFIDRV_HANDLER:
-			Handle_SetWfiDrvHandler(msg.drvHandler,
+			Handle_SetWfiDrvHandler(msg.drv,
 						&msg.body.drv);
 			break;
 
 		case HOST_IF_MSG_SET_OPERATION_MODE:
-			Handle_SetOperationMode(msg.drvHandler, &msg.body.mode);
+			Handle_SetOperationMode(msg.drv, &msg.body.mode);
 			break;
 
 		case HOST_IF_MSG_SET_IPADDRESS:
 			PRINT_D(HOSTINF_DBG, "HOST_IF_MSG_SET_IPADDRESS\n");
-			Handle_set_IPAddress(msg.drvHandler, msg.body.ip_info.au8IPAddr, msg.body.ip_info.idx);
+			Handle_set_IPAddress(msg.drv, msg.body.ip_info.au8IPAddr, msg.body.ip_info.idx);
 			break;
 
 		case HOST_IF_MSG_GET_IPADDRESS:
 			PRINT_D(HOSTINF_DBG, "HOST_IF_MSG_SET_IPADDRESS\n");
-			Handle_get_IPAddress(msg.drvHandler, msg.body.ip_info.au8IPAddr, msg.body.ip_info.idx);
+			Handle_get_IPAddress(msg.drv, msg.body.ip_info.au8IPAddr, msg.body.ip_info.idx);
 			break;
 
 		case HOST_IF_MSG_SET_MAC_ADDRESS:
-			Handle_SetMacAddress(msg.drvHandler, &msg.body.set_mac_info);
+			Handle_SetMacAddress(msg.drv, &msg.body.set_mac_info);
 			break;
 
 		case HOST_IF_MSG_GET_MAC_ADDRESS:
-			Handle_GetMacAddress(msg.drvHandler, &msg.body.get_mac_info);
+			Handle_GetMacAddress(msg.drv, &msg.body.get_mac_info);
 			break;
 
 		case HOST_IF_MSG_REMAIN_ON_CHAN:
 			PRINT_D(HOSTINF_DBG, "HOST_IF_MSG_REMAIN_ON_CHAN\n");
-			Handle_RemainOnChan(msg.drvHandler, &msg.body.remain_on_ch);
+			Handle_RemainOnChan(msg.drv, &msg.body.remain_on_ch);
 			break;
 
 		case HOST_IF_MSG_REGISTER_FRAME:
 			PRINT_D(HOSTINF_DBG, "HOST_IF_MSG_REGISTER_FRAME\n");
-			Handle_RegisterFrame(msg.drvHandler, &msg.body.reg_frame);
+			Handle_RegisterFrame(msg.drv, &msg.body.reg_frame);
 			break;
 
 		case HOST_IF_MSG_LISTEN_TIMER_FIRED:
-			Handle_ListenStateExpired(msg.drvHandler, &msg.body.remain_on_ch);
+			Handle_ListenStateExpired(msg.drv, &msg.body.remain_on_ch);
 			break;
 
 		case HOST_IF_MSG_SET_MULTICAST_FILTER:
 			PRINT_D(HOSTINF_DBG, "HOST_IF_MSG_SET_MULTICAST_FILTER\n");
-			Handle_SetMulticastFilter(msg.drvHandler, &msg.body.multicast_info);
+			Handle_SetMulticastFilter(msg.drv, &msg.body.multicast_info);
 			break;
 
 		case HOST_IF_MSG_ADD_BA_SESSION:
-			Handle_AddBASession(msg.drvHandler, &msg.body.session_info);
+			Handle_AddBASession(msg.drv, &msg.body.session_info);
 			break;
 
 		case HOST_IF_MSG_DEL_ALL_RX_BA_SESSIONS:
-			Handle_DelAllRxBASessions(msg.drvHandler, &msg.body.session_info);
+			Handle_DelAllRxBASessions(msg.drv, &msg.body.session_info);
 			break;
 
 		case HOST_IF_MSG_DEL_ALL_STA:
-			Handle_DelAllSta(msg.drvHandler, &msg.body.del_all_sta_info);
+			Handle_DelAllSta(msg.drv, &msg.body.del_all_sta_info);
 			break;
 
 		default:
@@ -4124,7 +4124,7 @@ static void TimerCB_Scan(unsigned long arg)
 
 	/* prepare the Timer Callback message */
 	memset(&msg, 0, sizeof(struct host_if_msg));
-	msg.drvHandler = pvArg;
+	msg.drv = pvArg;
 	msg.id = HOST_IF_MSG_SCAN_TIMER_FIRED;
 
 	/* send the message */
@@ -4138,7 +4138,7 @@ static void TimerCB_Connect(unsigned long arg)
 
 	/* prepare the Timer Callback message */
 	memset(&msg, 0, sizeof(struct host_if_msg));
-	msg.drvHandler = pvArg;
+	msg.drv = pvArg;
 	msg.id = HOST_IF_MSG_CONNECT_TIMER_FIRED;
 
 	/* send the message */
@@ -4204,7 +4204,7 @@ int host_int_remove_wep_key(struct host_if_drv *wfi_drv, u8 index)
 	msg.id = HOST_IF_MSG_KEY;
 	msg.body.key_info.enuKeyType = WEP;
 	msg.body.key_info.u8KeyAction = REMOVEKEY;
-	msg.drvHandler = wfi_drv;
+	msg.drv = wfi_drv;
 
 	msg.body.key_info.
 	uniHostIFkeyAttr.strHostIFwepAttr.u8Wepidx = index;
@@ -4250,7 +4250,7 @@ s32 host_int_set_WEPDefaultKeyID(struct host_if_drv *hWFIDrv, u8 u8Index)
 	msg.id = HOST_IF_MSG_KEY;
 	msg.body.key_info.enuKeyType = WEP;
 	msg.body.key_info.u8KeyAction = DEFAULTKEY;
-	msg.drvHandler = hWFIDrv;
+	msg.drv = hWFIDrv;
 
 
 	msg.body.key_info.
@@ -4304,7 +4304,7 @@ s32 host_int_add_wep_key_bss_sta(struct host_if_drv *hWFIDrv, const u8 *pu8WepKe
 	msg.id = HOST_IF_MSG_KEY;
 	msg.body.key_info.enuKeyType = WEP;
 	msg.body.key_info.u8KeyAction = ADDKEY;
-	msg.drvHandler = hWFIDrv;
+	msg.drv = hWFIDrv;
 
 
 	msg.body.key_info.
@@ -4370,7 +4370,7 @@ s32 host_int_add_wep_key_bss_ap(struct host_if_drv *hWFIDrv, const u8 *pu8WepKey
 	msg.id = HOST_IF_MSG_KEY;
 	msg.body.key_info.enuKeyType = WEP;
 	msg.body.key_info.u8KeyAction = ADDKEY_AP;
-	msg.drvHandler = hWFIDrv;
+	msg.drv = hWFIDrv;
 
 
 	msg.body.key_info.
@@ -4486,7 +4486,7 @@ s32 host_int_add_ptk(struct host_if_drv *hWFIDrv, const u8 *pu8Ptk, u8 u8PtkKeyl
 	uniHostIFkeyAttr.strHostIFwpaAttr.u8Ciphermode = u8Ciphermode;
 	msg.body.key_info.
 	uniHostIFkeyAttr.strHostIFwpaAttr.pu8macaddr = mac_addr;
-	msg.drvHandler = hWFIDrv;
+	msg.drv = hWFIDrv;
 
 	/* send the message */
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
@@ -4547,7 +4547,7 @@ s32 host_int_add_rx_gtk(struct host_if_drv *hWFIDrv, const u8 *pu8RxGtk, u8 u8Gt
 
 	msg.id = HOST_IF_MSG_KEY;
 	msg.body.key_info.enuKeyType = WPARxGtk;
-	msg.drvHandler = hWFIDrv;
+	msg.drv = hWFIDrv;
 
 	if (mode == AP_MODE) {
 		msg.body.key_info.u8KeyAction = ADDKEY_AP;
@@ -4637,7 +4637,7 @@ s32 host_int_set_pmkid_info(struct host_if_drv *hWFIDrv, struct host_if_pmkid_at
 	msg.id = HOST_IF_MSG_KEY;
 	msg.body.key_info.enuKeyType = PMKSA;
 	msg.body.key_info.u8KeyAction = ADDKEY;
-	msg.drvHandler = hWFIDrv;
+	msg.drv = hWFIDrv;
 
 	for (i = 0; i < pu8PmkidInfoArray->numpmkid; i++) {
 
@@ -4743,7 +4743,7 @@ s32 host_int_get_MacAddress(struct host_if_drv *hWFIDrv, u8 *pu8MacAddress)
 
 	msg.id = HOST_IF_MSG_GET_MAC_ADDRESS;
 	msg.body.get_mac_info.u8MacAddress = pu8MacAddress;
-	msg.drvHandler = hWFIDrv;
+	msg.drv = hWFIDrv;
 	/* send the message */
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 	if (s32Error) {
@@ -4777,7 +4777,7 @@ s32 host_int_set_MacAddress(struct host_if_drv *hWFIDrv, u8 *pu8MacAddress)
 	memset(&msg, 0, sizeof(struct host_if_msg));
 	msg.id = HOST_IF_MSG_SET_MAC_ADDRESS;
 	memcpy(msg.body.set_mac_info.u8MacAddress, pu8MacAddress, ETH_ALEN);
-	msg.drvHandler = hWFIDrv;
+	msg.drv = hWFIDrv;
 
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 	if (s32Error)
@@ -4923,7 +4923,7 @@ s32 host_int_set_join_req(struct host_if_drv *hWFIDrv, u8 *pu8bssid,
 	msg.body.con_info.pfConnectResult = pfConnectResult;
 	msg.body.con_info.pvUserArg = pvUserArg;
 	msg.body.con_info.pJoinParams = pJoinParams;
-	msg.drvHandler = hWFIDrv;
+	msg.drv = hWFIDrv;
 
 	if (pu8bssid != NULL) {
 		msg.body.con_info.pu8bssid = kmalloc(6, GFP_KERNEL); /* will be deallocated by the receiving thread */
@@ -4995,7 +4995,7 @@ s32 host_int_flush_join_req(struct host_if_drv *hWFIDrv)
 	}
 
 	msg.id = HOST_IF_MSG_FLUSH_CONNECT;
-	msg.drvHandler = hWFIDrv;
+	msg.drv = hWFIDrv;
 
 	/* send the message */
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
@@ -5033,7 +5033,7 @@ s32 host_int_disconnect(struct host_if_drv *hWFIDrv, u16 u16ReasonCode)
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
 	msg.id = HOST_IF_MSG_DISCONNECT;
-	msg.drvHandler = hWFIDrv;
+	msg.drv = hWFIDrv;
 
 	/* send the message */
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
@@ -5213,7 +5213,7 @@ int host_int_set_mac_chnl_num(struct host_if_drv *wfi_drv, u8 channel)
 	memset(&msg, 0, sizeof(struct host_if_msg));
 	msg.id = HOST_IF_MSG_SET_CHANNEL;
 	msg.body.channel_info.u8SetChan = channel;
-	msg.drvHandler = wfi_drv;
+	msg.drv = wfi_drv;
 
 	result = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 	if (result) {
@@ -5257,7 +5257,7 @@ int host_int_set_wfi_drv_handler(struct host_if_drv *address)
 	memset(&msg, 0, sizeof(struct host_if_msg));
 	msg.id = HOST_IF_MSG_SET_WFIDRV_HANDLER;
 	msg.body.drv.u32Address = get_id_from_handler(address);
-	msg.drvHandler = address;
+	msg.drv = address;
 
 	result = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 	if (result) {
@@ -5279,7 +5279,7 @@ int host_int_set_operation_mode(struct host_if_drv *wfi_drv, u32 mode)
 	memset(&msg, 0, sizeof(struct host_if_msg));
 	msg.id = HOST_IF_MSG_SET_OPERATION_MODE;
 	msg.body.mode.u32Mode = mode;
-	msg.drvHandler = wfi_drv;
+	msg.drv = wfi_drv;
 
 	result = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 	if (result) {
@@ -5320,7 +5320,7 @@ s32 host_int_get_host_chnl_num(struct host_if_drv *hWFIDrv, u8 *pu8ChNo)
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
 	msg.id = HOST_IF_MSG_GET_CHNL;
-	msg.drvHandler = hWFIDrv;
+	msg.drv = hWFIDrv;
 
 	/* send the message */
 	s32Error =	wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
@@ -5365,7 +5365,7 @@ s32 host_int_get_inactive_time(struct host_if_drv *hWFIDrv, const u8 *mac, u32 *
 		    mac, ETH_ALEN);
 
 	msg.id = HOST_IF_MSG_GET_INACTIVETIME;
-	msg.drvHandler = hWFIDrv;
+	msg.drv = hWFIDrv;
 
 	/* send the message */
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
@@ -5446,7 +5446,7 @@ s32 host_int_get_rssi(struct host_if_drv *hWFIDrv, s8 *ps8Rssi)
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
 	msg.id = HOST_IF_MSG_GET_RSSI;
-	msg.drvHandler = hWFIDrv;
+	msg.drv = hWFIDrv;
 
 	/* send the message */
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
@@ -5483,7 +5483,7 @@ s32 host_int_get_link_speed(struct host_if_drv *hWFIDrv, s8 *ps8lnkspd)
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
 	msg.id = HOST_IF_MSG_GET_LINKSPEED;
-	msg.drvHandler = hWFIDrv;
+	msg.drv = hWFIDrv;
 
 	/* send the message */
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
@@ -5518,7 +5518,7 @@ s32 host_int_get_statistics(struct host_if_drv *hWFIDrv, tstrStatistics *pstrSta
 
 	msg.id = HOST_IF_MSG_GET_STATISTICS;
 	msg.body.data = (char *)pstrStatistics;
-	msg.drvHandler = hWFIDrv;
+	msg.drv = hWFIDrv;
 	/* send the message */
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 	if (s32Error) {
@@ -5576,7 +5576,7 @@ s32 host_int_scan(struct host_if_drv *hWFIDrv, u8 u8ScanSource,
 	} else
 		PRINT_D(HOSTINF_DBG, "pstrHiddenNetwork IS EQUAL TO NULL\n");
 
-	msg.drvHandler = hWFIDrv;
+	msg.drv = hWFIDrv;
 	msg.body.scan_info.u8ScanSource = u8ScanSource;
 	msg.body.scan_info.u8ScanType = u8ScanType;
 	msg.body.scan_info.pfScanResult = ScanResult;
@@ -5636,7 +5636,7 @@ s32 hif_set_cfg(struct host_if_drv *hWFIDrv, struct cfg_param_val *pstrCfgParamV
 	memset(&msg, 0, sizeof(struct host_if_msg));
 	msg.id = HOST_IF_MSG_CFG_PARAMS;
 	msg.body.cfg_info.pstrCfgParamVal = *pstrCfgParamVal;
-	msg.drvHandler = hWFIDrv;
+	msg.drv = hWFIDrv;
 
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 
@@ -5807,7 +5807,7 @@ static void GetPeriodicRSSI(unsigned long arg)
 		memset(&msg, 0, sizeof(struct host_if_msg));
 
 		msg.id = HOST_IF_MSG_GET_RSSI;
-		msg.drvHandler = pstrWFIDrv;
+		msg.drv = pstrWFIDrv;
 
 		/* send the message */
 		s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
@@ -6015,7 +6015,7 @@ s32 host_int_deinit(struct host_if_drv *hWFIDrv)
 			/* msleep(HOST_IF_CONNECT_TIMEOUT+1000); */
 		}
 		msg.id = HOST_IF_MSG_EXIT;
-		msg.drvHandler = hWFIDrv;
+		msg.drv = hWFIDrv;
 
 
 		s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
@@ -6081,7 +6081,7 @@ void NetworkInfoReceived(u8 *pu8Buffer, u32 u32Length)
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
 	msg.id = HOST_IF_MSG_RCVD_NTWRK_INFO;
-	msg.drvHandler = pstrWFIDrv;
+	msg.drv = pstrWFIDrv;
 
 	msg.body.net_info.u32Length = u32Length;
 	msg.body.net_info.pu8Buffer = kmalloc(u32Length, GFP_KERNEL); /* will be deallocated by the receiving thread */
@@ -6137,7 +6137,7 @@ void GnrlAsyncInfoReceived(u8 *pu8Buffer, u32 u32Length)
 
 
 	msg.id = HOST_IF_MSG_RCVD_GNRL_ASYNC_INFO;
-	msg.drvHandler = pstrWFIDrv;
+	msg.drv = pstrWFIDrv;
 
 
 	msg.body.async_info.u32Length = u32Length;
@@ -6184,7 +6184,7 @@ void host_int_ScanCompleteReceived(u8 *pu8Buffer, u32 u32Length)
 		memset(&msg, 0, sizeof(struct host_if_msg));
 
 		msg.id = HOST_IF_MSG_RCVD_SCAN_COMPLETE;
-		msg.drvHandler = pstrWFIDrv;
+		msg.drv = pstrWFIDrv;
 
 
 		/* will be deallocated by the receiving thread */
@@ -6242,7 +6242,7 @@ s32 host_int_remain_on_channel(struct host_if_drv *hWFIDrv, u32 u32SessionID, u3
 	msg.body.remain_on_ch.pVoid = pvUserArg;
 	msg.body.remain_on_ch.u32duration = u32duration;
 	msg.body.remain_on_ch.u32ListenSessionID = u32SessionID;
-	msg.drvHandler = hWFIDrv;
+	msg.drv = hWFIDrv;
 
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 	if (s32Error)
@@ -6282,7 +6282,7 @@ s32 host_int_ListenStateExpired(struct host_if_drv *hWFIDrv, u32 u32SessionID)
 	/* prepare the timer fire Message */
 	memset(&msg, 0, sizeof(struct host_if_msg));
 	msg.id = HOST_IF_MSG_LISTEN_TIMER_FIRED;
-	msg.drvHandler = hWFIDrv;
+	msg.drv = hWFIDrv;
 	msg.body.remain_on_ch.u32ListenSessionID = u32SessionID;
 
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
@@ -6332,7 +6332,7 @@ s32 host_int_frame_register(struct host_if_drv *hWFIDrv, u16 u16FrameType, bool
 	}
 	msg.body.reg_frame.u16FrameType = u16FrameType;
 	msg.body.reg_frame.bReg = bReg;
-	msg.drvHandler = hWFIDrv;
+	msg.drv = hWFIDrv;
 
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 	if (s32Error)
@@ -6376,7 +6376,7 @@ s32 host_int_add_beacon(struct host_if_drv *hWFIDrv, u32 u32Interval,
 
 	/* prepare the WiphyParams Message */
 	msg.id = HOST_IF_MSG_ADD_BEACON;
-	msg.drvHandler = hWFIDrv;
+	msg.drv = hWFIDrv;
 	pstrSetBeaconParam->u32Interval = u32Interval;
 	pstrSetBeaconParam->u32DTIMPeriod = u32DTIMPeriod;
 	pstrSetBeaconParam->u32HeadLen = u32HeadLen;
@@ -6439,7 +6439,7 @@ s32 host_int_del_beacon(struct host_if_drv *hWFIDrv)
 
 	/* prepare the WiphyParams Message */
 	msg.id = HOST_IF_MSG_DEL_BEACON;
-	msg.drvHandler = hWFIDrv;
+	msg.drv = hWFIDrv;
 	PRINT_D(HOSTINF_DBG, "Setting deleting beacon message queue params\n");
 
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
@@ -6480,7 +6480,7 @@ s32 host_int_add_station(struct host_if_drv *hWFIDrv,
 
 	/* prepare the WiphyParams Message */
 	msg.id = HOST_IF_MSG_ADD_STATION;
-	msg.drvHandler = hWFIDrv;
+	msg.drv = hWFIDrv;
 
 	memcpy(pstrAddStationMsg, pstrStaParams, sizeof(struct add_sta_param));
 	if (pstrAddStationMsg->u8NumRates > 0) {
@@ -6529,7 +6529,7 @@ s32 host_int_del_station(struct host_if_drv *hWFIDrv, const u8 *pu8MacAddr)
 
 	/* prepare the WiphyParams Message */
 	msg.id = HOST_IF_MSG_DEL_STATION;
-	msg.drvHandler = hWFIDrv;
+	msg.drv = hWFIDrv;
 
 	if (pu8MacAddr == NULL)
 		memset(pstrDelStationMsg->au8MacAddr, 255, ETH_ALEN);
@@ -6573,7 +6573,7 @@ s32 host_int_del_allstation(struct host_if_drv *hWFIDrv,
 
 	/* prepare the WiphyParams Message */
 	msg.id = HOST_IF_MSG_DEL_ALL_STA;
-	msg.drvHandler = hWFIDrv;
+	msg.drv = hWFIDrv;
 
 	/* Handling situation of deauthenticing all associated stations*/
 	for (i = 0; i < MAX_NUM_STA; i++) {
@@ -6631,7 +6631,7 @@ s32 host_int_edit_station(struct host_if_drv *hWFIDrv,
 
 	/* prepare the WiphyParams Message */
 	msg.id = HOST_IF_MSG_EDIT_STATION;
-	msg.drvHandler = hWFIDrv;
+	msg.drv = hWFIDrv;
 
 	memcpy(pstrAddStationMsg, pstrStaParams, sizeof(struct add_sta_param));
 	if (pstrAddStationMsg->u8NumRates > 0) {
@@ -6672,7 +6672,7 @@ s32 host_int_set_power_mgmt(struct host_if_drv *hWFIDrv, bool bIsEnabled, u32 u3
 
 	/* prepare the WiphyParams Message */
 	msg.id = HOST_IF_MSG_POWER_MGMT;
-	msg.drvHandler = hWFIDrv;
+	msg.drv = hWFIDrv;
 
 	pstrPowerMgmtParam->bIsEnabled = bIsEnabled;
 	pstrPowerMgmtParam->u32Timeout = u32Timeout;
@@ -6705,7 +6705,7 @@ s32 host_int_setup_multicast_filter(struct host_if_drv *hWFIDrv, bool bIsEnabled
 
 	/* prepare the WiphyParams Message */
 	msg.id = HOST_IF_MSG_SET_MULTICAST_FILTER;
-	msg.drvHandler = hWFIDrv;
+	msg.drv = hWFIDrv;
 
 	pstrMulticastFilterParam->bIsEnabled = bIsEnabled;
 	pstrMulticastFilterParam->u32count = u32count;
@@ -6953,7 +6953,7 @@ s32 host_int_delBASession(struct host_if_drv *hWFIDrv, char *pBSSID, char TID)
 
 	memcpy(pBASessionInfo->au8Bssid, pBSSID, ETH_ALEN);
 	pBASessionInfo->u8Ted = TID;
-	msg.drvHandler = hWFIDrv;
+	msg.drv = hWFIDrv;
 
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 	if (s32Error)
@@ -6983,7 +6983,7 @@ s32 host_int_del_All_Rx_BASession(struct host_if_drv *hWFIDrv, char *pBSSID, cha
 
 	memcpy(pBASessionInfo->au8Bssid, pBSSID, ETH_ALEN);
 	pBASessionInfo->u8Ted = TID;
-	msg.drvHandler = hWFIDrv;
+	msg.drv = hWFIDrv;
 
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 	if (s32Error)
@@ -7022,7 +7022,7 @@ s32 host_int_setup_ipaddress(struct host_if_drv *hWFIDrv, u8 *u16ipadd, u8 idx)
 	msg.id = HOST_IF_MSG_SET_IPADDRESS;
 
 	msg.body.ip_info.au8IPAddr = u16ipadd;
-	msg.drvHandler = hWFIDrv;
+	msg.drv = hWFIDrv;
 	msg.body.ip_info.idx = idx;
 
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
@@ -7059,7 +7059,7 @@ s32 host_int_get_ipaddress(struct host_if_drv *hWFIDrv, u8 *u16ipadd, u8 idx)
 	msg.id = HOST_IF_MSG_GET_IPADDRESS;
 
 	msg.body.ip_info.au8IPAddr = u16ipadd;
-	msg.drvHandler = hWFIDrv;
+	msg.drv = hWFIDrv;
 	msg.body.ip_info.idx = idx;
 
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
-- 
1.9.1

