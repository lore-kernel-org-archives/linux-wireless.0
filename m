Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:37041 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752447AbbJEK2j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Oct 2015 06:28:39 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 2/6] staging: wilc1000: rename the member variable, drvHandler of host_if_msg
Date: Mon, 5 Oct 2015 19:28:10 +0900
Message-ID: <1444040894-18709-2-git-send-email-tony.cho@atmel.com> (sfid-20151005_122842_882364_73CFDCD7)
In-Reply-To: <1444040894-18709-1-git-send-email-tony.cho@atmel.com>
References: <1444040894-18709-1-git-send-email-tony.cho@atmel.com>
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
index 66c37ef..d59fcaa 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -402,7 +402,7 @@ union message_body {
 struct host_if_msg {
 	u16 id;                                           /*!< Message ID */
 	union message_body body;             /*!< Message body */
-	struct host_if_drv *drvHandler;
+	struct host_if_drv *drv;
 };
 
 typedef struct _tstrWidJoinReqExt {
@@ -3655,7 +3655,7 @@ static void ListenTimerCB(unsigned long arg)
 	/* prepare the Timer Callback message */
 	memset(&msg, 0, sizeof(struct host_if_msg));
 	msg.id = HOST_IF_MSG_LISTEN_TIMER_FIRED;
-	msg.drvHandler = pstrWFIDrv;
+	msg.drv = pstrWFIDrv;
 	msg.body.remain_on_ch.u32ListenSessionID = pstrWFIDrv->strHostIfRemainOnChan.u32ListenSessionID;
 
 	/* send the message */
@@ -3913,7 +3913,7 @@ static int hostIFthread(void *pvArg)
 
 	while (1) {
 		wilc_mq_recv(&gMsgQHostIF, &msg, sizeof(struct host_if_msg), &u32Ret);
-		pstrWFIDrv = (struct host_if_drv *)msg.drvHandler;
+		pstrWFIDrv = (struct host_if_drv *)msg.drv;
 		if (msg.id == HOST_IF_MSG_EXIT) {
 			PRINT_D(GENERIC_DBG, "THREAD: Exiting HostIfThread\n");
 			break;
@@ -3941,40 +3941,40 @@ static int hostIFthread(void *pvArg)
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
@@ -3985,124 +3985,124 @@ static int hostIFthread(void *pvArg)
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
@@ -4123,7 +4123,7 @@ static void TimerCB_Scan(unsigned long arg)
 
 	/* prepare the Timer Callback message */
 	memset(&msg, 0, sizeof(struct host_if_msg));
-	msg.drvHandler = pvArg;
+	msg.drv = pvArg;
 	msg.id = HOST_IF_MSG_SCAN_TIMER_FIRED;
 
 	/* send the message */
@@ -4137,7 +4137,7 @@ static void TimerCB_Connect(unsigned long arg)
 
 	/* prepare the Timer Callback message */
 	memset(&msg, 0, sizeof(struct host_if_msg));
-	msg.drvHandler = pvArg;
+	msg.drv = pvArg;
 	msg.id = HOST_IF_MSG_CONNECT_TIMER_FIRED;
 
 	/* send the message */
@@ -4206,7 +4206,7 @@ s32 host_int_remove_wep_key(struct host_if_drv *hWFIDrv, u8 u8keyIdx)
 	msg.id = HOST_IF_MSG_KEY;
 	msg.body.key_info.enuKeyType = WEP;
 	msg.body.key_info.u8KeyAction = REMOVEKEY;
-	msg.drvHandler = hWFIDrv;
+	msg.drv = hWFIDrv;
 
 
 
@@ -4254,7 +4254,7 @@ s32 host_int_set_WEPDefaultKeyID(struct host_if_drv *hWFIDrv, u8 u8Index)
 	msg.id = HOST_IF_MSG_KEY;
 	msg.body.key_info.enuKeyType = WEP;
 	msg.body.key_info.u8KeyAction = DEFAULTKEY;
-	msg.drvHandler = hWFIDrv;
+	msg.drv = hWFIDrv;
 
 
 	msg.body.key_info.
@@ -4308,7 +4308,7 @@ s32 host_int_add_wep_key_bss_sta(struct host_if_drv *hWFIDrv, const u8 *pu8WepKe
 	msg.id = HOST_IF_MSG_KEY;
 	msg.body.key_info.enuKeyType = WEP;
 	msg.body.key_info.u8KeyAction = ADDKEY;
-	msg.drvHandler = hWFIDrv;
+	msg.drv = hWFIDrv;
 
 
 	msg.body.key_info.
@@ -4374,7 +4374,7 @@ s32 host_int_add_wep_key_bss_ap(struct host_if_drv *hWFIDrv, const u8 *pu8WepKey
 	msg.id = HOST_IF_MSG_KEY;
 	msg.body.key_info.enuKeyType = WEP;
 	msg.body.key_info.u8KeyAction = ADDKEY_AP;
-	msg.drvHandler = hWFIDrv;
+	msg.drv = hWFIDrv;
 
 
 	msg.body.key_info.
@@ -4490,7 +4490,7 @@ s32 host_int_add_ptk(struct host_if_drv *hWFIDrv, const u8 *pu8Ptk, u8 u8PtkKeyl
 	uniHostIFkeyAttr.strHostIFwpaAttr.u8Ciphermode = u8Ciphermode;
 	msg.body.key_info.
 	uniHostIFkeyAttr.strHostIFwpaAttr.pu8macaddr = mac_addr;
-	msg.drvHandler = hWFIDrv;
+	msg.drv = hWFIDrv;
 
 	/* send the message */
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
@@ -4551,7 +4551,7 @@ s32 host_int_add_rx_gtk(struct host_if_drv *hWFIDrv, const u8 *pu8RxGtk, u8 u8Gt
 
 	msg.id = HOST_IF_MSG_KEY;
 	msg.body.key_info.enuKeyType = WPARxGtk;
-	msg.drvHandler = hWFIDrv;
+	msg.drv = hWFIDrv;
 
 	if (mode == AP_MODE) {
 		msg.body.key_info.u8KeyAction = ADDKEY_AP;
@@ -4641,7 +4641,7 @@ s32 host_int_set_pmkid_info(struct host_if_drv *hWFIDrv, struct host_if_pmkid_at
 	msg.id = HOST_IF_MSG_KEY;
 	msg.body.key_info.enuKeyType = PMKSA;
 	msg.body.key_info.u8KeyAction = ADDKEY;
-	msg.drvHandler = hWFIDrv;
+	msg.drv = hWFIDrv;
 
 	for (i = 0; i < pu8PmkidInfoArray->numpmkid; i++) {
 
@@ -4747,7 +4747,7 @@ s32 host_int_get_MacAddress(struct host_if_drv *hWFIDrv, u8 *pu8MacAddress)
 
 	msg.id = HOST_IF_MSG_GET_MAC_ADDRESS;
 	msg.body.get_mac_info.u8MacAddress = pu8MacAddress;
-	msg.drvHandler = hWFIDrv;
+	msg.drv = hWFIDrv;
 	/* send the message */
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 	if (s32Error) {
@@ -4781,7 +4781,7 @@ s32 host_int_set_MacAddress(struct host_if_drv *hWFIDrv, u8 *pu8MacAddress)
 	memset(&msg, 0, sizeof(struct host_if_msg));
 	msg.id = HOST_IF_MSG_SET_MAC_ADDRESS;
 	memcpy(msg.body.set_mac_info.u8MacAddress, pu8MacAddress, ETH_ALEN);
-	msg.drvHandler = hWFIDrv;
+	msg.drv = hWFIDrv;
 
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 	if (s32Error)
@@ -4927,7 +4927,7 @@ s32 host_int_set_join_req(struct host_if_drv *hWFIDrv, u8 *pu8bssid,
 	msg.body.con_info.pfConnectResult = pfConnectResult;
 	msg.body.con_info.pvUserArg = pvUserArg;
 	msg.body.con_info.pJoinParams = pJoinParams;
-	msg.drvHandler = hWFIDrv;
+	msg.drv = hWFIDrv;
 
 	if (pu8bssid != NULL) {
 		msg.body.con_info.pu8bssid = kmalloc(6, GFP_KERNEL); /* will be deallocated by the receiving thread */
@@ -4999,7 +4999,7 @@ s32 host_int_flush_join_req(struct host_if_drv *hWFIDrv)
 	}
 
 	msg.id = HOST_IF_MSG_FLUSH_CONNECT;
-	msg.drvHandler = hWFIDrv;
+	msg.drv = hWFIDrv;
 
 	/* send the message */
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
@@ -5037,7 +5037,7 @@ s32 host_int_disconnect(struct host_if_drv *hWFIDrv, u16 u16ReasonCode)
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
 	msg.id = HOST_IF_MSG_DISCONNECT;
-	msg.drvHandler = hWFIDrv;
+	msg.drv = hWFIDrv;
 
 	/* send the message */
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
@@ -5218,7 +5218,7 @@ int host_int_set_mac_chnl_num(struct host_if_drv *wfi_drv, u8 channel)
 	memset(&msg, 0, sizeof(struct host_if_msg));
 	msg.id = HOST_IF_MSG_SET_CHANNEL;
 	msg.body.channel_info.u8SetChan = channel;
-	msg.drvHandler = wfi_drv;
+	msg.drv = wfi_drv;
 
 	result = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 	if (result) {
@@ -5264,7 +5264,7 @@ s32 host_int_set_wfi_drv_handler(struct host_if_drv *u32address)
 	memset(&msg, 0, sizeof(struct host_if_msg));
 	msg.id = HOST_IF_MSG_SET_WFIDRV_HANDLER;
 	msg.body.drv.u32Address = get_id_from_handler(u32address);
-	msg.drvHandler = u32address;
+	msg.drv = u32address;
 
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 	if (s32Error) {
@@ -5289,7 +5289,7 @@ s32 host_int_set_operation_mode(struct host_if_drv *hWFIDrv, u32 u32mode)
 	memset(&msg, 0, sizeof(struct host_if_msg));
 	msg.id = HOST_IF_MSG_SET_OPERATION_MODE;
 	msg.body.mode.u32Mode = u32mode;
-	msg.drvHandler = hWFIDrv;
+	msg.drv = hWFIDrv;
 
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 	if (s32Error) {
@@ -5330,7 +5330,7 @@ s32 host_int_get_host_chnl_num(struct host_if_drv *hWFIDrv, u8 *pu8ChNo)
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
 	msg.id = HOST_IF_MSG_GET_CHNL;
-	msg.drvHandler = hWFIDrv;
+	msg.drv = hWFIDrv;
 
 	/* send the message */
 	s32Error =	wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
@@ -5418,7 +5418,7 @@ s32 host_int_get_inactive_time(struct host_if_drv *hWFIDrv, const u8 *mac, u32 *
 		    mac, ETH_ALEN);
 
 	msg.id = HOST_IF_MSG_GET_INACTIVETIME;
-	msg.drvHandler = hWFIDrv;
+	msg.drv = hWFIDrv;
 
 	/* send the message */
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
@@ -5499,7 +5499,7 @@ s32 host_int_get_rssi(struct host_if_drv *hWFIDrv, s8 *ps8Rssi)
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
 	msg.id = HOST_IF_MSG_GET_RSSI;
-	msg.drvHandler = hWFIDrv;
+	msg.drv = hWFIDrv;
 
 	/* send the message */
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
@@ -5536,7 +5536,7 @@ s32 host_int_get_link_speed(struct host_if_drv *hWFIDrv, s8 *ps8lnkspd)
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
 	msg.id = HOST_IF_MSG_GET_LINKSPEED;
-	msg.drvHandler = hWFIDrv;
+	msg.drv = hWFIDrv;
 
 	/* send the message */
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
@@ -5571,7 +5571,7 @@ s32 host_int_get_statistics(struct host_if_drv *hWFIDrv, tstrStatistics *pstrSta
 
 	msg.id = HOST_IF_MSG_GET_STATISTICS;
 	msg.body.data = (char *)pstrStatistics;
-	msg.drvHandler = hWFIDrv;
+	msg.drv = hWFIDrv;
 	/* send the message */
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 	if (s32Error) {
@@ -5629,7 +5629,7 @@ s32 host_int_scan(struct host_if_drv *hWFIDrv, u8 u8ScanSource,
 	} else
 		PRINT_D(HOSTINF_DBG, "pstrHiddenNetwork IS EQUAL TO NULL\n");
 
-	msg.drvHandler = hWFIDrv;
+	msg.drv = hWFIDrv;
 	msg.body.scan_info.u8ScanSource = u8ScanSource;
 	msg.body.scan_info.u8ScanType = u8ScanType;
 	msg.body.scan_info.pfScanResult = ScanResult;
@@ -5689,7 +5689,7 @@ s32 hif_set_cfg(struct host_if_drv *hWFIDrv, struct cfg_param_val *pstrCfgParamV
 	memset(&msg, 0, sizeof(struct host_if_msg));
 	msg.id = HOST_IF_MSG_CFG_PARAMS;
 	msg.body.cfg_info.pstrCfgParamVal = *pstrCfgParamVal;
-	msg.drvHandler = hWFIDrv;
+	msg.drv = hWFIDrv;
 
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 
@@ -5860,7 +5860,7 @@ static void GetPeriodicRSSI(unsigned long arg)
 		memset(&msg, 0, sizeof(struct host_if_msg));
 
 		msg.id = HOST_IF_MSG_GET_RSSI;
-		msg.drvHandler = pstrWFIDrv;
+		msg.drv = pstrWFIDrv;
 
 		/* send the message */
 		s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
@@ -6068,7 +6068,7 @@ s32 host_int_deinit(struct host_if_drv *hWFIDrv)
 			/* msleep(HOST_IF_CONNECT_TIMEOUT+1000); */
 		}
 		msg.id = HOST_IF_MSG_EXIT;
-		msg.drvHandler = hWFIDrv;
+		msg.drv = hWFIDrv;
 
 
 		s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
@@ -6134,7 +6134,7 @@ void NetworkInfoReceived(u8 *pu8Buffer, u32 u32Length)
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
 	msg.id = HOST_IF_MSG_RCVD_NTWRK_INFO;
-	msg.drvHandler = pstrWFIDrv;
+	msg.drv = pstrWFIDrv;
 
 	msg.body.net_info.u32Length = u32Length;
 	msg.body.net_info.pu8Buffer = kmalloc(u32Length, GFP_KERNEL); /* will be deallocated by the receiving thread */
@@ -6190,7 +6190,7 @@ void GnrlAsyncInfoReceived(u8 *pu8Buffer, u32 u32Length)
 
 
 	msg.id = HOST_IF_MSG_RCVD_GNRL_ASYNC_INFO;
-	msg.drvHandler = pstrWFIDrv;
+	msg.drv = pstrWFIDrv;
 
 
 	msg.body.async_info.u32Length = u32Length;
@@ -6237,7 +6237,7 @@ void host_int_ScanCompleteReceived(u8 *pu8Buffer, u32 u32Length)
 		memset(&msg, 0, sizeof(struct host_if_msg));
 
 		msg.id = HOST_IF_MSG_RCVD_SCAN_COMPLETE;
-		msg.drvHandler = pstrWFIDrv;
+		msg.drv = pstrWFIDrv;
 
 
 		/* will be deallocated by the receiving thread */
@@ -6295,7 +6295,7 @@ s32 host_int_remain_on_channel(struct host_if_drv *hWFIDrv, u32 u32SessionID, u3
 	msg.body.remain_on_ch.pVoid = pvUserArg;
 	msg.body.remain_on_ch.u32duration = u32duration;
 	msg.body.remain_on_ch.u32ListenSessionID = u32SessionID;
-	msg.drvHandler = hWFIDrv;
+	msg.drv = hWFIDrv;
 
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 	if (s32Error)
@@ -6335,7 +6335,7 @@ s32 host_int_ListenStateExpired(struct host_if_drv *hWFIDrv, u32 u32SessionID)
 	/* prepare the timer fire Message */
 	memset(&msg, 0, sizeof(struct host_if_msg));
 	msg.id = HOST_IF_MSG_LISTEN_TIMER_FIRED;
-	msg.drvHandler = hWFIDrv;
+	msg.drv = hWFIDrv;
 	msg.body.remain_on_ch.u32ListenSessionID = u32SessionID;
 
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
@@ -6385,7 +6385,7 @@ s32 host_int_frame_register(struct host_if_drv *hWFIDrv, u16 u16FrameType, bool
 	}
 	msg.body.reg_frame.u16FrameType = u16FrameType;
 	msg.body.reg_frame.bReg = bReg;
-	msg.drvHandler = hWFIDrv;
+	msg.drv = hWFIDrv;
 
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 	if (s32Error)
@@ -6429,7 +6429,7 @@ s32 host_int_add_beacon(struct host_if_drv *hWFIDrv, u32 u32Interval,
 
 	/* prepare the WiphyParams Message */
 	msg.id = HOST_IF_MSG_ADD_BEACON;
-	msg.drvHandler = hWFIDrv;
+	msg.drv = hWFIDrv;
 	pstrSetBeaconParam->u32Interval = u32Interval;
 	pstrSetBeaconParam->u32DTIMPeriod = u32DTIMPeriod;
 	pstrSetBeaconParam->u32HeadLen = u32HeadLen;
@@ -6492,7 +6492,7 @@ s32 host_int_del_beacon(struct host_if_drv *hWFIDrv)
 
 	/* prepare the WiphyParams Message */
 	msg.id = HOST_IF_MSG_DEL_BEACON;
-	msg.drvHandler = hWFIDrv;
+	msg.drv = hWFIDrv;
 	PRINT_D(HOSTINF_DBG, "Setting deleting beacon message queue params\n");
 
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
@@ -6533,7 +6533,7 @@ s32 host_int_add_station(struct host_if_drv *hWFIDrv,
 
 	/* prepare the WiphyParams Message */
 	msg.id = HOST_IF_MSG_ADD_STATION;
-	msg.drvHandler = hWFIDrv;
+	msg.drv = hWFIDrv;
 
 	memcpy(pstrAddStationMsg, pstrStaParams, sizeof(struct add_sta_param));
 	if (pstrAddStationMsg->u8NumRates > 0) {
@@ -6582,7 +6582,7 @@ s32 host_int_del_station(struct host_if_drv *hWFIDrv, const u8 *pu8MacAddr)
 
 	/* prepare the WiphyParams Message */
 	msg.id = HOST_IF_MSG_DEL_STATION;
-	msg.drvHandler = hWFIDrv;
+	msg.drv = hWFIDrv;
 
 	if (pu8MacAddr == NULL)
 		memset(pstrDelStationMsg->au8MacAddr, 255, ETH_ALEN);
@@ -6626,7 +6626,7 @@ s32 host_int_del_allstation(struct host_if_drv *hWFIDrv,
 
 	/* prepare the WiphyParams Message */
 	msg.id = HOST_IF_MSG_DEL_ALL_STA;
-	msg.drvHandler = hWFIDrv;
+	msg.drv = hWFIDrv;
 
 	/* Handling situation of deauthenticing all associated stations*/
 	for (i = 0; i < MAX_NUM_STA; i++) {
@@ -6684,7 +6684,7 @@ s32 host_int_edit_station(struct host_if_drv *hWFIDrv,
 
 	/* prepare the WiphyParams Message */
 	msg.id = HOST_IF_MSG_EDIT_STATION;
-	msg.drvHandler = hWFIDrv;
+	msg.drv = hWFIDrv;
 
 	memcpy(pstrAddStationMsg, pstrStaParams, sizeof(struct add_sta_param));
 	if (pstrAddStationMsg->u8NumRates > 0) {
@@ -6725,7 +6725,7 @@ s32 host_int_set_power_mgmt(struct host_if_drv *hWFIDrv, bool bIsEnabled, u32 u3
 
 	/* prepare the WiphyParams Message */
 	msg.id = HOST_IF_MSG_POWER_MGMT;
-	msg.drvHandler = hWFIDrv;
+	msg.drv = hWFIDrv;
 
 	pstrPowerMgmtParam->bIsEnabled = bIsEnabled;
 	pstrPowerMgmtParam->u32Timeout = u32Timeout;
@@ -6758,7 +6758,7 @@ s32 host_int_setup_multicast_filter(struct host_if_drv *hWFIDrv, bool bIsEnabled
 
 	/* prepare the WiphyParams Message */
 	msg.id = HOST_IF_MSG_SET_MULTICAST_FILTER;
-	msg.drvHandler = hWFIDrv;
+	msg.drv = hWFIDrv;
 
 	pstrMulticastFilterParam->bIsEnabled = bIsEnabled;
 	pstrMulticastFilterParam->u32count = u32count;
@@ -7006,7 +7006,7 @@ s32 host_int_delBASession(struct host_if_drv *hWFIDrv, char *pBSSID, char TID)
 
 	memcpy(pBASessionInfo->au8Bssid, pBSSID, ETH_ALEN);
 	pBASessionInfo->u8Ted = TID;
-	msg.drvHandler = hWFIDrv;
+	msg.drv = hWFIDrv;
 
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 	if (s32Error)
@@ -7036,7 +7036,7 @@ s32 host_int_del_All_Rx_BASession(struct host_if_drv *hWFIDrv, char *pBSSID, cha
 
 	memcpy(pBASessionInfo->au8Bssid, pBSSID, ETH_ALEN);
 	pBASessionInfo->u8Ted = TID;
-	msg.drvHandler = hWFIDrv;
+	msg.drv = hWFIDrv;
 
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 	if (s32Error)
@@ -7075,7 +7075,7 @@ s32 host_int_setup_ipaddress(struct host_if_drv *hWFIDrv, u8 *u16ipadd, u8 idx)
 	msg.id = HOST_IF_MSG_SET_IPADDRESS;
 
 	msg.body.ip_info.au8IPAddr = u16ipadd;
-	msg.drvHandler = hWFIDrv;
+	msg.drv = hWFIDrv;
 	msg.body.ip_info.idx = idx;
 
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
@@ -7112,7 +7112,7 @@ s32 host_int_get_ipaddress(struct host_if_drv *hWFIDrv, u8 *u16ipadd, u8 idx)
 	msg.id = HOST_IF_MSG_GET_IPADDRESS;
 
 	msg.body.ip_info.au8IPAddr = u16ipadd;
-	msg.drvHandler = hWFIDrv;
+	msg.drv = hWFIDrv;
 	msg.body.ip_info.idx = idx;
 
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
-- 
1.9.1

