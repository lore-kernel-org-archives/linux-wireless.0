Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:45060 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702AbbIRJM3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Sep 2015 05:12:29 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 06/34] staging: wilc1000: rename uniHostIFmsgBody
Date: Fri, 18 Sep 2015 18:11:08 +0900
Message-ID: <1442567496-29331-6-git-send-email-tony.cho@atmel.com> (sfid-20150918_111234_286464_49E9895B)
In-Reply-To: <1442567496-29331-1-git-send-email-tony.cho@atmel.com>
References: <1442567496-29331-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes the camelcase notation, uniHostIFmsgBody which is a member
variable of structure host_if_msg to body in order to comply with the Linux
coding style.

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 296 +++++++++++++++---------------
 1 file changed, 148 insertions(+), 148 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 6cb35aa..8b1aa2f 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -461,7 +461,7 @@ union message_body {
  */
 struct host_if_msg {
 	u16 id;                                           /*!< Message ID */
-	union message_body uniHostIFmsgBody;             /*!< Message body */
+	union message_body body;             /*!< Message body */
 	tstrWILC_WFIDrv *drvHandler;
 };
 
@@ -3993,7 +3993,7 @@ static void ListenTimerCB(unsigned long arg)
 	memset(&msg, 0, sizeof(struct host_if_msg));
 	msg.id = HOST_IF_MSG_LISTEN_TIMER_FIRED;
 	msg.drvHandler = pstrWFIDrv;
-	msg.uniHostIFmsgBody.strHostIfRemainOnChan.u32ListenSessionID = pstrWFIDrv->strHostIfRemainOnChan.u32ListenSessionID;
+	msg.body.strHostIfRemainOnChan.u32ListenSessionID = pstrWFIDrv->strHostIfRemainOnChan.u32ListenSessionID;
 
 	/* send the message */
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
@@ -4350,11 +4350,11 @@ static int hostIFthread(void *pvArg)
 			break;
 
 		case HOST_IF_MSG_SCAN:
-			Handle_Scan(msg.drvHandler, &msg.uniHostIFmsgBody.strHostIFscanAttr);
+			Handle_Scan(msg.drvHandler, &msg.body.strHostIFscanAttr);
 			break;
 
 		case HOST_IF_MSG_CONNECT:
-			Handle_Connect(msg.drvHandler, &msg.uniHostIFmsgBody.strHostIFconnectAttr);
+			Handle_Connect(msg.drvHandler, &msg.body.strHostIFconnectAttr);
 			break;
 
 		/*BugID_5137*/
@@ -4363,24 +4363,24 @@ static int hostIFthread(void *pvArg)
 			break;
 
 		case HOST_IF_MSG_RCVD_NTWRK_INFO:
-			Handle_RcvdNtwrkInfo(msg.drvHandler, &msg.uniHostIFmsgBody.strRcvdNetworkInfo);
+			Handle_RcvdNtwrkInfo(msg.drvHandler, &msg.body.strRcvdNetworkInfo);
 			break;
 
 		case HOST_IF_MSG_RCVD_GNRL_ASYNC_INFO:
-			Handle_RcvdGnrlAsyncInfo(msg.drvHandler, &msg.uniHostIFmsgBody.strRcvdGnrlAsyncInfo);
+			Handle_RcvdGnrlAsyncInfo(msg.drvHandler, &msg.body.strRcvdGnrlAsyncInfo);
 			break;
 
 		case HOST_IF_MSG_KEY:
-			Handle_Key(msg.drvHandler, &msg.uniHostIFmsgBody.strHostIFkeyAttr);
+			Handle_Key(msg.drvHandler, &msg.body.strHostIFkeyAttr);
 			break;
 
 		case HOST_IF_MSG_CFG_PARAMS:
 
-			Handle_CfgParam(msg.drvHandler, &msg.uniHostIFmsgBody.strHostIFCfgParamAttr);
+			Handle_CfgParam(msg.drvHandler, &msg.body.strHostIFCfgParamAttr);
 			break;
 
 		case HOST_IF_MSG_SET_CHANNEL:
-			Handle_SetChannel(msg.drvHandler, &msg.uniHostIFmsgBody.strHostIFSetChan);
+			Handle_SetChannel(msg.drvHandler, &msg.body.strHostIFSetChan);
 			break;
 
 		case HOST_IF_MSG_DISCONNECT:
@@ -4399,7 +4399,7 @@ static int hostIFthread(void *pvArg)
 			Handle_ScanDone(msg.drvHandler, SCAN_EVENT_DONE);
 
 			if (pstrWFIDrv->u8RemainOnChan_pendingreq)
-				Handle_RemainOnChan(msg.drvHandler, &msg.uniHostIFmsgBody.strHostIfRemainOnChan);
+				Handle_RemainOnChan(msg.drvHandler, &msg.body.strHostIfRemainOnChan);
 
 			break;
 
@@ -4412,7 +4412,7 @@ static int hostIFthread(void *pvArg)
 			break;
 
 		case HOST_IF_MSG_GET_STATISTICS:
-			Handle_GetStatistics(msg.drvHandler, (tstrStatistics *)msg.uniHostIFmsgBody.pUserData);
+			Handle_GetStatistics(msg.drvHandler, (tstrStatistics *)msg.body.pUserData);
 			break;
 
 		case HOST_IF_MSG_GET_CHNL:
@@ -4420,27 +4420,27 @@ static int hostIFthread(void *pvArg)
 			break;
 
 		case HOST_IF_MSG_ADD_BEACON:
-			Handle_AddBeacon(msg.drvHandler, &msg.uniHostIFmsgBody.strHostIFSetBeacon);
+			Handle_AddBeacon(msg.drvHandler, &msg.body.strHostIFSetBeacon);
 			break;
 
 		case HOST_IF_MSG_DEL_BEACON:
-			Handle_DelBeacon(msg.drvHandler, &msg.uniHostIFmsgBody.strHostIFDelBeacon);
+			Handle_DelBeacon(msg.drvHandler, &msg.body.strHostIFDelBeacon);
 			break;
 
 		case HOST_IF_MSG_ADD_STATION:
-			Handle_AddStation(msg.drvHandler, &msg.uniHostIFmsgBody.strAddStaParam);
+			Handle_AddStation(msg.drvHandler, &msg.body.strAddStaParam);
 			break;
 
 		case HOST_IF_MSG_DEL_STATION:
-			Handle_DelStation(msg.drvHandler, &msg.uniHostIFmsgBody.strDelStaParam);
+			Handle_DelStation(msg.drvHandler, &msg.body.strDelStaParam);
 			break;
 
 		case HOST_IF_MSG_EDIT_STATION:
-			Handle_EditStation(msg.drvHandler, &msg.uniHostIFmsgBody.strEditStaParam);
+			Handle_EditStation(msg.drvHandler, &msg.body.strEditStaParam);
 			break;
 
 		case HOST_IF_MSG_GET_INACTIVETIME:
-			Handle_Get_InActiveTime(msg.drvHandler, &msg.uniHostIFmsgBody.strHostIfStaInactiveT);
+			Handle_Get_InActiveTime(msg.drvHandler, &msg.body.strHostIfStaInactiveT);
 			break;
 
 		case HOST_IF_MSG_SCAN_TIMER_FIRED:
@@ -4455,68 +4455,68 @@ static int hostIFthread(void *pvArg)
 			break;
 
 		case HOST_IF_MSG_POWER_MGMT:
-			Handle_PowerManagement(msg.drvHandler, &msg.uniHostIFmsgBody.strPowerMgmtparam);
+			Handle_PowerManagement(msg.drvHandler, &msg.body.strPowerMgmtparam);
 			break;
 
 		case HOST_IF_MSG_SET_WFIDRV_HANDLER:
 			Handle_SetWfiDrvHandler(msg.drvHandler,
-						&msg.uniHostIFmsgBody.strHostIfSetDrvHandler);
+						&msg.body.strHostIfSetDrvHandler);
 			break;
 
 		case HOST_IF_MSG_SET_OPERATION_MODE:
-			Handle_SetOperationMode(msg.drvHandler, &msg.uniHostIFmsgBody.strHostIfSetOperationMode);
+			Handle_SetOperationMode(msg.drvHandler, &msg.body.strHostIfSetOperationMode);
 			break;
 
 		case HOST_IF_MSG_SET_IPADDRESS:
 			PRINT_D(HOSTINF_DBG, "HOST_IF_MSG_SET_IPADDRESS\n");
-			Handle_set_IPAddress(msg.drvHandler, msg.uniHostIFmsgBody.strHostIfSetIP.au8IPAddr, msg.uniHostIFmsgBody.strHostIfSetIP.idx);
+			Handle_set_IPAddress(msg.drvHandler, msg.body.strHostIfSetIP.au8IPAddr, msg.body.strHostIfSetIP.idx);
 			break;
 
 		case HOST_IF_MSG_GET_IPADDRESS:
 			PRINT_D(HOSTINF_DBG, "HOST_IF_MSG_SET_IPADDRESS\n");
-			Handle_get_IPAddress(msg.drvHandler, msg.uniHostIFmsgBody.strHostIfSetIP.au8IPAddr, msg.uniHostIFmsgBody.strHostIfSetIP.idx);
+			Handle_get_IPAddress(msg.drvHandler, msg.body.strHostIfSetIP.au8IPAddr, msg.body.strHostIfSetIP.idx);
 			break;
 
 		/*BugID_5077*/
 		case HOST_IF_MSG_SET_MAC_ADDRESS:
-			Handle_SetMacAddress(msg.drvHandler, &msg.uniHostIFmsgBody.strHostIfSetMacAddress);
+			Handle_SetMacAddress(msg.drvHandler, &msg.body.strHostIfSetMacAddress);
 			break;
 
 		/*BugID_5213*/
 		case HOST_IF_MSG_GET_MAC_ADDRESS:
-			Handle_GetMacAddress(msg.drvHandler, &msg.uniHostIFmsgBody.strHostIfGetMacAddress);
+			Handle_GetMacAddress(msg.drvHandler, &msg.body.strHostIfGetMacAddress);
 			break;
 
 		case HOST_IF_MSG_REMAIN_ON_CHAN:
 			PRINT_D(HOSTINF_DBG, "HOST_IF_MSG_REMAIN_ON_CHAN\n");
-			Handle_RemainOnChan(msg.drvHandler, &msg.uniHostIFmsgBody.strHostIfRemainOnChan);
+			Handle_RemainOnChan(msg.drvHandler, &msg.body.strHostIfRemainOnChan);
 			break;
 
 		case HOST_IF_MSG_REGISTER_FRAME:
 			PRINT_D(HOSTINF_DBG, "HOST_IF_MSG_REGISTER_FRAME\n");
-			Handle_RegisterFrame(msg.drvHandler, &msg.uniHostIFmsgBody.strHostIfRegisterFrame);
+			Handle_RegisterFrame(msg.drvHandler, &msg.body.strHostIfRegisterFrame);
 			break;
 
 		case HOST_IF_MSG_LISTEN_TIMER_FIRED:
-			Handle_ListenStateExpired(msg.drvHandler, &msg.uniHostIFmsgBody.strHostIfRemainOnChan);
+			Handle_ListenStateExpired(msg.drvHandler, &msg.body.strHostIfRemainOnChan);
 			break;
 
 		case HOST_IF_MSG_SET_MULTICAST_FILTER:
 			PRINT_D(HOSTINF_DBG, "HOST_IF_MSG_SET_MULTICAST_FILTER\n");
-			Handle_SetMulticastFilter(msg.drvHandler, &msg.uniHostIFmsgBody.strHostIfSetMulti);
+			Handle_SetMulticastFilter(msg.drvHandler, &msg.body.strHostIfSetMulti);
 			break;
 
 		/*BugID_5222*/
 		case HOST_IF_MSG_ADD_BA_SESSION:
-			Handle_AddBASession(msg.drvHandler, &msg.uniHostIFmsgBody.strHostIfBASessionInfo);
+			Handle_AddBASession(msg.drvHandler, &msg.body.strHostIfBASessionInfo);
 			break;
 
 		case HOST_IF_MSG_DEL_ALL_RX_BA_SESSIONS:
-			Handle_DelAllRxBASessions(msg.drvHandler, &msg.uniHostIFmsgBody.strHostIfBASessionInfo);
+			Handle_DelAllRxBASessions(msg.drvHandler, &msg.body.strHostIfBASessionInfo);
 			break;
 
 		case HOST_IF_MSG_DEL_ALL_STA:
-			Handle_DelAllSta(msg.drvHandler, &msg.uniHostIFmsgBody.strHostIFDelAllSta);
+			Handle_DelAllSta(msg.drvHandler, &msg.body.strHostIFDelAllSta);
 			break;
 
 		default:
@@ -4619,13 +4619,13 @@ s32 host_int_remove_wep_key(tstrWILC_WFIDrv *hWFIDrv, u8 u8keyIdx)
 
 
 	msg.id = HOST_IF_MSG_KEY;
-	msg.uniHostIFmsgBody.strHostIFkeyAttr.enuKeyType = WEP;
-	msg.uniHostIFmsgBody.strHostIFkeyAttr.u8KeyAction = REMOVEKEY;
+	msg.body.strHostIFkeyAttr.enuKeyType = WEP;
+	msg.body.strHostIFkeyAttr.u8KeyAction = REMOVEKEY;
 	msg.drvHandler = hWFIDrv;
 
 
 
-	msg.uniHostIFmsgBody.strHostIFkeyAttr.
+	msg.body.strHostIFkeyAttr.
 	uniHostIFkeyAttr.strHostIFwepAttr.u8Wepidx = u8keyIdx;
 
 	/* send the message */
@@ -4667,12 +4667,12 @@ s32 host_int_set_WEPDefaultKeyID(tstrWILC_WFIDrv *hWFIDrv, u8 u8Index)
 
 
 	msg.id = HOST_IF_MSG_KEY;
-	msg.uniHostIFmsgBody.strHostIFkeyAttr.enuKeyType = WEP;
-	msg.uniHostIFmsgBody.strHostIFkeyAttr.u8KeyAction = DEFAULTKEY;
+	msg.body.strHostIFkeyAttr.enuKeyType = WEP;
+	msg.body.strHostIFkeyAttr.u8KeyAction = DEFAULTKEY;
 	msg.drvHandler = hWFIDrv;
 
 
-	msg.uniHostIFmsgBody.strHostIFkeyAttr.
+	msg.body.strHostIFkeyAttr.
 	uniHostIFkeyAttr.strHostIFwepAttr.u8Wepidx = u8Index;
 
 	/* send the message */
@@ -4721,22 +4721,22 @@ s32 host_int_add_wep_key_bss_sta(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8WepKey,
 
 
 	msg.id = HOST_IF_MSG_KEY;
-	msg.uniHostIFmsgBody.strHostIFkeyAttr.enuKeyType = WEP;
-	msg.uniHostIFmsgBody.strHostIFkeyAttr.u8KeyAction = ADDKEY;
+	msg.body.strHostIFkeyAttr.enuKeyType = WEP;
+	msg.body.strHostIFkeyAttr.u8KeyAction = ADDKEY;
 	msg.drvHandler = hWFIDrv;
 
 
-	msg.uniHostIFmsgBody.strHostIFkeyAttr.
+	msg.body.strHostIFkeyAttr.
 	uniHostIFkeyAttr.strHostIFwepAttr.pu8WepKey = kmalloc(u8WepKeylen, GFP_KERNEL);
 
-	memcpy(msg.uniHostIFmsgBody.strHostIFkeyAttr.uniHostIFkeyAttr.strHostIFwepAttr.pu8WepKey,
+	memcpy(msg.body.strHostIFkeyAttr.uniHostIFkeyAttr.strHostIFwepAttr.pu8WepKey,
 		    pu8WepKey, u8WepKeylen);
 
 
-	msg.uniHostIFmsgBody.strHostIFkeyAttr.
+	msg.body.strHostIFkeyAttr.
 	uniHostIFkeyAttr.strHostIFwepAttr.u8WepKeylen = (u8WepKeylen);
 
-	msg.uniHostIFmsgBody.strHostIFkeyAttr.
+	msg.body.strHostIFkeyAttr.
 	uniHostIFkeyAttr.strHostIFwepAttr.u8Wepidx = u8Keyidx;
 
 	/* send the message */
@@ -4787,29 +4787,29 @@ s32 host_int_add_wep_key_bss_ap(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8WepKey, u
 			PRINT_INFO(HOSTAPD_DBG, "KEY is %x\n", pu8WepKey[i]);
 	}
 	msg.id = HOST_IF_MSG_KEY;
-	msg.uniHostIFmsgBody.strHostIFkeyAttr.enuKeyType = WEP;
-	msg.uniHostIFmsgBody.strHostIFkeyAttr.u8KeyAction = ADDKEY_AP;
+	msg.body.strHostIFkeyAttr.enuKeyType = WEP;
+	msg.body.strHostIFkeyAttr.u8KeyAction = ADDKEY_AP;
 	msg.drvHandler = hWFIDrv;
 
 
-	msg.uniHostIFmsgBody.strHostIFkeyAttr.
+	msg.body.strHostIFkeyAttr.
 	uniHostIFkeyAttr.strHostIFwepAttr.pu8WepKey = kmalloc(u8WepKeylen, GFP_KERNEL);
 
 
-	memcpy(msg.uniHostIFmsgBody.strHostIFkeyAttr.uniHostIFkeyAttr.strHostIFwepAttr.pu8WepKey,
+	memcpy(msg.body.strHostIFkeyAttr.uniHostIFkeyAttr.strHostIFwepAttr.pu8WepKey,
 		    pu8WepKey, (u8WepKeylen));
 
 
-	msg.uniHostIFmsgBody.strHostIFkeyAttr.
+	msg.body.strHostIFkeyAttr.
 	uniHostIFkeyAttr.strHostIFwepAttr.u8WepKeylen = (u8WepKeylen);
 
-	msg.uniHostIFmsgBody.strHostIFkeyAttr.
+	msg.body.strHostIFkeyAttr.
 	uniHostIFkeyAttr.strHostIFwepAttr.u8Wepidx = u8Keyidx;
 
-	msg.uniHostIFmsgBody.strHostIFkeyAttr.
+	msg.body.strHostIFkeyAttr.
 	uniHostIFkeyAttr.strHostIFwepAttr.u8mode = u8mode;
 
-	msg.uniHostIFmsgBody.strHostIFkeyAttr.
+	msg.body.strHostIFkeyAttr.
 	uniHostIFkeyAttr.strHostIFwepAttr.tenuAuth_type = tenuAuth_type;
 	/* send the message */
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
@@ -4862,26 +4862,26 @@ s32 host_int_add_ptk(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8Ptk, u8 u8PtkKeylen,
 
 
 	msg.id = HOST_IF_MSG_KEY;
-	msg.uniHostIFmsgBody.strHostIFkeyAttr.enuKeyType = WPAPtk;
+	msg.body.strHostIFkeyAttr.enuKeyType = WPAPtk;
 	if (mode == AP_MODE) {
-		msg.uniHostIFmsgBody.strHostIFkeyAttr.u8KeyAction = ADDKEY_AP;
-		msg.uniHostIFmsgBody.strHostIFkeyAttr.
+		msg.body.strHostIFkeyAttr.u8KeyAction = ADDKEY_AP;
+		msg.body.strHostIFkeyAttr.
 		uniHostIFkeyAttr.strHostIFwpaAttr.u8keyidx = u8Idx;
 	}
 	if (mode == STATION_MODE)
-		msg.uniHostIFmsgBody.strHostIFkeyAttr.u8KeyAction = ADDKEY;
+		msg.body.strHostIFkeyAttr.u8KeyAction = ADDKEY;
 
 
-	msg.uniHostIFmsgBody.strHostIFkeyAttr.
+	msg.body.strHostIFkeyAttr.
 	uniHostIFkeyAttr.strHostIFwpaAttr.pu8key = kmalloc(u8PtkKeylen, GFP_KERNEL);
 
 
-	memcpy(msg.uniHostIFmsgBody.strHostIFkeyAttr.uniHostIFkeyAttr.strHostIFwpaAttr.pu8key,
+	memcpy(msg.body.strHostIFkeyAttr.uniHostIFkeyAttr.strHostIFwpaAttr.pu8key,
 		    pu8Ptk, u8PtkKeylen);
 
 	if (pu8RxMic != NULL) {
 
-		memcpy(msg.uniHostIFmsgBody.strHostIFkeyAttr.uniHostIFkeyAttr.strHostIFwpaAttr.pu8key + 16,
+		memcpy(msg.body.strHostIFkeyAttr.uniHostIFkeyAttr.strHostIFwpaAttr.pu8key + 16,
 			    pu8RxMic, RX_MIC_KEY_LEN);
 		if (INFO) {
 			for (i = 0; i < RX_MIC_KEY_LEN; i++)
@@ -4890,7 +4890,7 @@ s32 host_int_add_ptk(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8Ptk, u8 u8PtkKeylen,
 	}
 	if (pu8TxMic != NULL) {
 
-		memcpy(msg.uniHostIFmsgBody.strHostIFkeyAttr.uniHostIFkeyAttr.strHostIFwpaAttr.pu8key + 24,
+		memcpy(msg.body.strHostIFkeyAttr.uniHostIFkeyAttr.strHostIFwpaAttr.pu8key + 24,
 			    pu8TxMic, TX_MIC_KEY_LEN);
 		if (INFO) {
 			for (i = 0; i < TX_MIC_KEY_LEN; i++)
@@ -4898,12 +4898,12 @@ s32 host_int_add_ptk(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8Ptk, u8 u8PtkKeylen,
 		}
 	}
 
-	msg.uniHostIFmsgBody.strHostIFkeyAttr.
+	msg.body.strHostIFkeyAttr.
 	uniHostIFkeyAttr.strHostIFwpaAttr.u8Keylen = u8KeyLen;
 
-	msg.uniHostIFmsgBody.strHostIFkeyAttr.
+	msg.body.strHostIFkeyAttr.
 	uniHostIFkeyAttr.strHostIFwpaAttr.u8Ciphermode = u8Ciphermode;
-	msg.uniHostIFmsgBody.strHostIFkeyAttr.
+	msg.body.strHostIFkeyAttr.
 	uniHostIFkeyAttr.strHostIFwpaAttr.pu8macaddr = mac_addr;
 	msg.drvHandler = hWFIDrv;
 
@@ -4956,51 +4956,51 @@ s32 host_int_add_rx_gtk(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8RxGtk, u8 u8GtkKe
 	if (pu8TxMic != NULL)
 		u8KeyLen += TX_MIC_KEY_LEN;
 	if (KeyRSC != NULL) {
-		msg.uniHostIFmsgBody.strHostIFkeyAttr.
+		msg.body.strHostIFkeyAttr.
 		uniHostIFkeyAttr.strHostIFwpaAttr.pu8seq = kmalloc(u32KeyRSClen, GFP_KERNEL);
 
-		memcpy(msg.uniHostIFmsgBody.strHostIFkeyAttr.uniHostIFkeyAttr.strHostIFwpaAttr.pu8seq,
+		memcpy(msg.body.strHostIFkeyAttr.uniHostIFkeyAttr.strHostIFwpaAttr.pu8seq,
 			    KeyRSC, u32KeyRSClen);
 	}
 
 
 	msg.id = HOST_IF_MSG_KEY;
-	msg.uniHostIFmsgBody.strHostIFkeyAttr.enuKeyType = WPARxGtk;
+	msg.body.strHostIFkeyAttr.enuKeyType = WPARxGtk;
 	msg.drvHandler = hWFIDrv;
 
 	if (mode == AP_MODE) {
-		msg.uniHostIFmsgBody.strHostIFkeyAttr.u8KeyAction = ADDKEY_AP;
-		msg.uniHostIFmsgBody.strHostIFkeyAttr.uniHostIFkeyAttr.strHostIFwpaAttr.u8Ciphermode = u8Ciphermode;
+		msg.body.strHostIFkeyAttr.u8KeyAction = ADDKEY_AP;
+		msg.body.strHostIFkeyAttr.uniHostIFkeyAttr.strHostIFwpaAttr.u8Ciphermode = u8Ciphermode;
 	}
 	if (mode == STATION_MODE)
-		msg.uniHostIFmsgBody.strHostIFkeyAttr.u8KeyAction = ADDKEY;
+		msg.body.strHostIFkeyAttr.u8KeyAction = ADDKEY;
 
 
-	msg.uniHostIFmsgBody.strHostIFkeyAttr.
+	msg.body.strHostIFkeyAttr.
 	uniHostIFkeyAttr.strHostIFwpaAttr.pu8key = kmalloc(u8KeyLen, GFP_KERNEL);
 
-	memcpy(msg.uniHostIFmsgBody.strHostIFkeyAttr.uniHostIFkeyAttr.strHostIFwpaAttr.pu8key,
+	memcpy(msg.body.strHostIFkeyAttr.uniHostIFkeyAttr.strHostIFwpaAttr.pu8key,
 		    pu8RxGtk, u8GtkKeylen);
 
 	if (pu8RxMic != NULL) {
 
-		memcpy(msg.uniHostIFmsgBody.strHostIFkeyAttr.uniHostIFkeyAttr.strHostIFwpaAttr.pu8key + 16,
+		memcpy(msg.body.strHostIFkeyAttr.uniHostIFkeyAttr.strHostIFwpaAttr.pu8key + 16,
 			    pu8RxMic, RX_MIC_KEY_LEN);
 
 	}
 	if (pu8TxMic != NULL) {
 
-		memcpy(msg.uniHostIFmsgBody.strHostIFkeyAttr.uniHostIFkeyAttr.strHostIFwpaAttr.pu8key + 24,
+		memcpy(msg.body.strHostIFkeyAttr.uniHostIFkeyAttr.strHostIFwpaAttr.pu8key + 24,
 			    pu8TxMic, TX_MIC_KEY_LEN);
 
 	}
 
-	msg.uniHostIFmsgBody.strHostIFkeyAttr.
+	msg.body.strHostIFkeyAttr.
 	uniHostIFkeyAttr.strHostIFwpaAttr.u8keyidx = u8KeyIdx;
-	msg.uniHostIFmsgBody.strHostIFkeyAttr.
+	msg.body.strHostIFkeyAttr.
 	uniHostIFkeyAttr.strHostIFwpaAttr.u8Keylen = u8KeyLen;
 
-	msg.uniHostIFmsgBody.strHostIFkeyAttr.
+	msg.body.strHostIFkeyAttr.
 	uniHostIFkeyAttr.strHostIFwpaAttr.u8seqlen = u32KeyRSClen;
 
 
@@ -5054,16 +5054,16 @@ s32 host_int_set_pmkid_info(tstrWILC_WFIDrv *hWFIDrv, tstrHostIFpmkidAttr *pu8Pm
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
 	msg.id = HOST_IF_MSG_KEY;
-	msg.uniHostIFmsgBody.strHostIFkeyAttr.enuKeyType = PMKSA;
-	msg.uniHostIFmsgBody.strHostIFkeyAttr.u8KeyAction = ADDKEY;
+	msg.body.strHostIFkeyAttr.enuKeyType = PMKSA;
+	msg.body.strHostIFkeyAttr.u8KeyAction = ADDKEY;
 	msg.drvHandler = hWFIDrv;
 
 	for (i = 0; i < pu8PmkidInfoArray->numpmkid; i++) {
 
-		memcpy(msg.uniHostIFmsgBody.strHostIFkeyAttr.uniHostIFkeyAttr.strHostIFpmkidAttr.pmkidlist[i].bssid, &pu8PmkidInfoArray->pmkidlist[i].bssid,
+		memcpy(msg.body.strHostIFkeyAttr.uniHostIFkeyAttr.strHostIFpmkidAttr.pmkidlist[i].bssid, &pu8PmkidInfoArray->pmkidlist[i].bssid,
 			    ETH_ALEN);
 
-		memcpy(msg.uniHostIFmsgBody.strHostIFkeyAttr.uniHostIFkeyAttr.strHostIFpmkidAttr.pmkidlist[i].pmkid, &pu8PmkidInfoArray->pmkidlist[i].pmkid,
+		memcpy(msg.body.strHostIFkeyAttr.uniHostIFkeyAttr.strHostIFpmkidAttr.pmkidlist[i].pmkid, &pu8PmkidInfoArray->pmkidlist[i].pmkid,
 			    PMKID_LEN);
 	}
 
@@ -5162,7 +5162,7 @@ s32 host_int_get_MacAddress(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8MacAddress)
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
 	msg.id = HOST_IF_MSG_GET_MAC_ADDRESS;
-	msg.uniHostIFmsgBody.strHostIfGetMacAddress.u8MacAddress = pu8MacAddress;
+	msg.body.strHostIfGetMacAddress.u8MacAddress = pu8MacAddress;
 	msg.drvHandler = hWFIDrv;
 	/* send the message */
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
@@ -5196,7 +5196,7 @@ s32 host_int_set_MacAddress(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8MacAddress)
 	/* prepare setting mac address message */
 	memset(&msg, 0, sizeof(struct host_if_msg));
 	msg.id = HOST_IF_MSG_SET_MAC_ADDRESS;
-	memcpy(msg.uniHostIFmsgBody.strHostIfSetMacAddress.u8MacAddress, pu8MacAddress, ETH_ALEN);
+	memcpy(msg.body.strHostIfSetMacAddress.u8MacAddress, pu8MacAddress, ETH_ALEN);
 	msg.drvHandler = hWFIDrv;
 
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
@@ -5403,32 +5403,32 @@ s32 host_int_set_join_req(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8bssid,
 
 	msg.id = HOST_IF_MSG_CONNECT;
 
-	msg.uniHostIFmsgBody.strHostIFconnectAttr.u8security = u8security;
-	msg.uniHostIFmsgBody.strHostIFconnectAttr.tenuAuth_type = tenuAuth_type;
-	msg.uniHostIFmsgBody.strHostIFconnectAttr.u8channel = u8channel;
-	msg.uniHostIFmsgBody.strHostIFconnectAttr.pfConnectResult = pfConnectResult;
-	msg.uniHostIFmsgBody.strHostIFconnectAttr.pvUserArg = pvUserArg;
-	msg.uniHostIFmsgBody.strHostIFconnectAttr.pJoinParams = pJoinParams;
+	msg.body.strHostIFconnectAttr.u8security = u8security;
+	msg.body.strHostIFconnectAttr.tenuAuth_type = tenuAuth_type;
+	msg.body.strHostIFconnectAttr.u8channel = u8channel;
+	msg.body.strHostIFconnectAttr.pfConnectResult = pfConnectResult;
+	msg.body.strHostIFconnectAttr.pvUserArg = pvUserArg;
+	msg.body.strHostIFconnectAttr.pJoinParams = pJoinParams;
 	msg.drvHandler = hWFIDrv;
 
 	if (pu8bssid != NULL) {
-		msg.uniHostIFmsgBody.strHostIFconnectAttr.pu8bssid = kmalloc(6, GFP_KERNEL); /* will be deallocated by the receiving thread */
-		memcpy(msg.uniHostIFmsgBody.strHostIFconnectAttr.pu8bssid,
+		msg.body.strHostIFconnectAttr.pu8bssid = kmalloc(6, GFP_KERNEL); /* will be deallocated by the receiving thread */
+		memcpy(msg.body.strHostIFconnectAttr.pu8bssid,
 			    pu8bssid, 6);
 	}
 
 	if (pu8ssid != NULL) {
-		msg.uniHostIFmsgBody.strHostIFconnectAttr.ssidLen = ssidLen;
-		msg.uniHostIFmsgBody.strHostIFconnectAttr.pu8ssid = kmalloc(ssidLen, GFP_KERNEL); /* will be deallocated by the receiving thread */
-		memcpy(msg.uniHostIFmsgBody.strHostIFconnectAttr.pu8ssid,
+		msg.body.strHostIFconnectAttr.ssidLen = ssidLen;
+		msg.body.strHostIFconnectAttr.pu8ssid = kmalloc(ssidLen, GFP_KERNEL); /* will be deallocated by the receiving thread */
+		memcpy(msg.body.strHostIFconnectAttr.pu8ssid,
 
 			    pu8ssid, ssidLen);
 	}
 
 	if (pu8IEs != NULL) {
-		msg.uniHostIFmsgBody.strHostIFconnectAttr.IEsLen = IEsLen;
-		msg.uniHostIFmsgBody.strHostIFconnectAttr.pu8IEs = kmalloc(IEsLen, GFP_KERNEL); /* will be deallocated by the receiving thread */
-		memcpy(msg.uniHostIFmsgBody.strHostIFconnectAttr.pu8IEs,
+		msg.body.strHostIFconnectAttr.IEsLen = IEsLen;
+		msg.body.strHostIFconnectAttr.pu8IEs = kmalloc(IEsLen, GFP_KERNEL); /* will be deallocated by the receiving thread */
+		memcpy(msg.body.strHostIFconnectAttr.pu8IEs,
 			    pu8IEs, IEsLen);
 	}
 	if (pstrWFIDrv->enuHostIFstate < HOST_IF_CONNECTING)
@@ -5702,7 +5702,7 @@ s32 host_int_set_mac_chnl_num(tstrWILC_WFIDrv *hWFIDrv, u8 u8ChNum)
 	/* prepare the set channel message */
 	memset(&msg, 0, sizeof(struct host_if_msg));
 	msg.id = HOST_IF_MSG_SET_CHANNEL;
-	msg.uniHostIFmsgBody.strHostIFSetChan.u8SetChan = u8ChNum;
+	msg.body.strHostIFSetChan.u8SetChan = u8ChNum;
 	msg.drvHandler = hWFIDrv;
 
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
@@ -5749,7 +5749,7 @@ s32 host_int_set_wfi_drv_handler(tstrWILC_WFIDrv *u32address)
 
 	memset(&msg, 0, sizeof(struct host_if_msg));
 	msg.id = HOST_IF_MSG_SET_WFIDRV_HANDLER;
-	msg.uniHostIFmsgBody.strHostIfSetDrvHandler.u32Address = get_id_from_handler(u32address);
+	msg.body.strHostIfSetDrvHandler.u32Address = get_id_from_handler(u32address);
 	msg.drvHandler = u32address;
 
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
@@ -5774,7 +5774,7 @@ s32 host_int_set_operation_mode(tstrWILC_WFIDrv *hWFIDrv, u32 u32mode)
 
 	memset(&msg, 0, sizeof(struct host_if_msg));
 	msg.id = HOST_IF_MSG_SET_OPERATION_MODE;
-	msg.uniHostIFmsgBody.strHostIfSetOperationMode.u32Mode = u32mode;
+	msg.body.strHostIfSetOperationMode.u32Mode = u32mode;
 	msg.drvHandler = hWFIDrv;
 
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
@@ -5900,7 +5900,7 @@ s32 host_int_get_inactive_time(tstrWILC_WFIDrv *hWFIDrv, const u8 *mac, u32 *pu3
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
 
-	memcpy(msg.uniHostIFmsgBody.strHostIfStaInactiveT.mac,
+	memcpy(msg.body.strHostIfStaInactiveT.mac,
 		    mac, ETH_ALEN);
 
 	msg.id = HOST_IF_MSG_GET_INACTIVETIME;
@@ -6056,7 +6056,7 @@ s32 host_int_get_statistics(tstrWILC_WFIDrv *hWFIDrv, tstrStatistics *pstrStatis
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
 	msg.id = HOST_IF_MSG_GET_STATISTICS;
-	msg.uniHostIFmsgBody.pUserData = (char *)pstrStatistics;
+	msg.body.pUserData = (char *)pstrStatistics;
 	msg.drvHandler = hWFIDrv;
 	/* send the message */
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
@@ -6108,26 +6108,26 @@ s32 host_int_scan(tstrWILC_WFIDrv *hWFIDrv, u8 u8ScanSource,
 	msg.id = HOST_IF_MSG_SCAN;
 
 	if (pstrHiddenNetwork != NULL) {
-		msg.uniHostIFmsgBody.strHostIFscanAttr.strHiddenNetwork.pstrHiddenNetworkInfo = pstrHiddenNetwork->pstrHiddenNetworkInfo;
-		msg.uniHostIFmsgBody.strHostIFscanAttr.strHiddenNetwork.u8ssidnum = pstrHiddenNetwork->u8ssidnum;
+		msg.body.strHostIFscanAttr.strHiddenNetwork.pstrHiddenNetworkInfo = pstrHiddenNetwork->pstrHiddenNetworkInfo;
+		msg.body.strHostIFscanAttr.strHiddenNetwork.u8ssidnum = pstrHiddenNetwork->u8ssidnum;
 
 	} else
 		PRINT_D(HOSTINF_DBG, "pstrHiddenNetwork IS EQUAL TO NULL\n");
 
 	msg.drvHandler = hWFIDrv;
-	msg.uniHostIFmsgBody.strHostIFscanAttr.u8ScanSource = u8ScanSource;
-	msg.uniHostIFmsgBody.strHostIFscanAttr.u8ScanType = u8ScanType;
-	msg.uniHostIFmsgBody.strHostIFscanAttr.pfScanResult = ScanResult;
-	msg.uniHostIFmsgBody.strHostIFscanAttr.pvUserArg = pvUserArg;
-
-	msg.uniHostIFmsgBody.strHostIFscanAttr.u8ChnlListLen = u8ChnlListLen;
-	msg.uniHostIFmsgBody.strHostIFscanAttr.pu8ChnlFreqList = kmalloc(u8ChnlListLen, GFP_KERNEL);        /* will be deallocated by the receiving thread */
-	memcpy(msg.uniHostIFmsgBody.strHostIFscanAttr.pu8ChnlFreqList,
+	msg.body.strHostIFscanAttr.u8ScanSource = u8ScanSource;
+	msg.body.strHostIFscanAttr.u8ScanType = u8ScanType;
+	msg.body.strHostIFscanAttr.pfScanResult = ScanResult;
+	msg.body.strHostIFscanAttr.pvUserArg = pvUserArg;
+
+	msg.body.strHostIFscanAttr.u8ChnlListLen = u8ChnlListLen;
+	msg.body.strHostIFscanAttr.pu8ChnlFreqList = kmalloc(u8ChnlListLen, GFP_KERNEL);        /* will be deallocated by the receiving thread */
+	memcpy(msg.body.strHostIFscanAttr.pu8ChnlFreqList,
 		    pu8ChnlFreqList, u8ChnlListLen);
 
-	msg.uniHostIFmsgBody.strHostIFscanAttr.IEsLen = IEsLen;
-	msg.uniHostIFmsgBody.strHostIFscanAttr.pu8IEs = kmalloc(IEsLen, GFP_KERNEL);        /* will be deallocated by the receiving thread */
-	memcpy(msg.uniHostIFmsgBody.strHostIFscanAttr.pu8IEs,
+	msg.body.strHostIFscanAttr.IEsLen = IEsLen;
+	msg.body.strHostIFscanAttr.pu8IEs = kmalloc(IEsLen, GFP_KERNEL);        /* will be deallocated by the receiving thread */
+	memcpy(msg.body.strHostIFscanAttr.pu8IEs,
 		    pu8IEs, IEsLen);
 
 	/* send the message */
@@ -6173,7 +6173,7 @@ s32 hif_set_cfg(tstrWILC_WFIDrv *hWFIDrv, tstrCfgParamVal *pstrCfgParamVal)
 	/* prepare the WiphyParams Message */
 	memset(&msg, 0, sizeof(struct host_if_msg));
 	msg.id = HOST_IF_MSG_CFG_PARAMS;
-	msg.uniHostIFmsgBody.strHostIFCfgParamAttr.pstrCfgParamVal = *pstrCfgParamVal;
+	msg.body.strHostIFCfgParamAttr.pstrCfgParamVal = *pstrCfgParamVal;
 	msg.drvHandler = hWFIDrv;
 
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
@@ -6676,9 +6676,9 @@ void NetworkInfoReceived(u8 *pu8Buffer, u32 u32Length)
 	msg.id = HOST_IF_MSG_RCVD_NTWRK_INFO;
 	msg.drvHandler = pstrWFIDrv;
 
-	msg.uniHostIFmsgBody.strRcvdNetworkInfo.u32Length = u32Length;
-	msg.uniHostIFmsgBody.strRcvdNetworkInfo.pu8Buffer = kmalloc(u32Length, GFP_KERNEL); /* will be deallocated by the receiving thread */
-	memcpy(msg.uniHostIFmsgBody.strRcvdNetworkInfo.pu8Buffer,
+	msg.body.strRcvdNetworkInfo.u32Length = u32Length;
+	msg.body.strRcvdNetworkInfo.pu8Buffer = kmalloc(u32Length, GFP_KERNEL); /* will be deallocated by the receiving thread */
+	memcpy(msg.body.strRcvdNetworkInfo.pu8Buffer,
 		    pu8Buffer, u32Length);
 
 	/* send the message */
@@ -6736,9 +6736,9 @@ void GnrlAsyncInfoReceived(u8 *pu8Buffer, u32 u32Length)
 	msg.drvHandler = pstrWFIDrv;
 
 
-	msg.uniHostIFmsgBody.strRcvdGnrlAsyncInfo.u32Length = u32Length;
-	msg.uniHostIFmsgBody.strRcvdGnrlAsyncInfo.pu8Buffer = kmalloc(u32Length, GFP_KERNEL); /* will be deallocated by the receiving thread */
-	memcpy(msg.uniHostIFmsgBody.strRcvdGnrlAsyncInfo.pu8Buffer,
+	msg.body.strRcvdGnrlAsyncInfo.u32Length = u32Length;
+	msg.body.strRcvdGnrlAsyncInfo.pu8Buffer = kmalloc(u32Length, GFP_KERNEL); /* will be deallocated by the receiving thread */
+	memcpy(msg.body.strRcvdGnrlAsyncInfo.pu8Buffer,
 		    pu8Buffer, u32Length);
 
 	/* send the message */
@@ -6787,9 +6787,9 @@ void host_int_ScanCompleteReceived(u8 *pu8Buffer, u32 u32Length)
 		/* will be deallocated by the receiving thread */
 		/*no need to send message body*/
 
-		/*msg.uniHostIFmsgBody.strScanComplete.u32Length = u32Length;
-		 * msg.uniHostIFmsgBody.strScanComplete.pu8Buffer  = (u8*)WILC_MALLOC(u32Length);
-		 * memcpy(msg.uniHostIFmsgBody.strScanComplete.pu8Buffer,
+		/*msg.body.strScanComplete.u32Length = u32Length;
+		 * msg.body.strScanComplete.pu8Buffer  = (u8*)WILC_MALLOC(u32Length);
+		 * memcpy(msg.body.strScanComplete.pu8Buffer,
 		 *                        pu8Buffer, u32Length); */
 
 		/* send the message */
@@ -6833,12 +6833,12 @@ s32 host_int_remain_on_channel(tstrWILC_WFIDrv *hWFIDrv, u32 u32SessionID, u32 u
 
 	/* prepare the WiphyParams Message */
 	msg.id = HOST_IF_MSG_REMAIN_ON_CHAN;
-	msg.uniHostIFmsgBody.strHostIfRemainOnChan.u16Channel = chan;
-	msg.uniHostIFmsgBody.strHostIfRemainOnChan.pRemainOnChanExpired = RemainOnChanExpired;
-	msg.uniHostIFmsgBody.strHostIfRemainOnChan.pRemainOnChanReady = RemainOnChanReady;
-	msg.uniHostIFmsgBody.strHostIfRemainOnChan.pVoid = pvUserArg;
-	msg.uniHostIFmsgBody.strHostIfRemainOnChan.u32duration = u32duration;
-	msg.uniHostIFmsgBody.strHostIfRemainOnChan.u32ListenSessionID = u32SessionID;
+	msg.body.strHostIfRemainOnChan.u16Channel = chan;
+	msg.body.strHostIfRemainOnChan.pRemainOnChanExpired = RemainOnChanExpired;
+	msg.body.strHostIfRemainOnChan.pRemainOnChanReady = RemainOnChanReady;
+	msg.body.strHostIfRemainOnChan.pVoid = pvUserArg;
+	msg.body.strHostIfRemainOnChan.u32duration = u32duration;
+	msg.body.strHostIfRemainOnChan.u32ListenSessionID = u32SessionID;
 	msg.drvHandler = hWFIDrv;
 
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
@@ -6880,7 +6880,7 @@ s32 host_int_ListenStateExpired(tstrWILC_WFIDrv *hWFIDrv, u32 u32SessionID)
 	memset(&msg, 0, sizeof(struct host_if_msg));
 	msg.id = HOST_IF_MSG_LISTEN_TIMER_FIRED;
 	msg.drvHandler = hWFIDrv;
-	msg.uniHostIFmsgBody.strHostIfRemainOnChan.u32ListenSessionID = u32SessionID;
+	msg.body.strHostIfRemainOnChan.u32ListenSessionID = u32SessionID;
 
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 	if (s32Error)
@@ -6915,20 +6915,20 @@ s32 host_int_frame_register(tstrWILC_WFIDrv *hWFIDrv, u16 u16FrameType, bool bRe
 	switch (u16FrameType) {
 	case ACTION:
 		PRINT_D(HOSTINF_DBG, "ACTION\n");
-		msg.uniHostIFmsgBody.strHostIfRegisterFrame.u8Regid = ACTION_FRM_IDX;
+		msg.body.strHostIfRegisterFrame.u8Regid = ACTION_FRM_IDX;
 		break;
 
 	case PROBE_REQ:
 		PRINT_D(HOSTINF_DBG, "PROBE REQ\n");
-		msg.uniHostIFmsgBody.strHostIfRegisterFrame.u8Regid = PROBE_REQ_IDX;
+		msg.body.strHostIfRegisterFrame.u8Regid = PROBE_REQ_IDX;
 		break;
 
 	default:
 		PRINT_D(HOSTINF_DBG, "Not valid frame type\n");
 		break;
 	}
-	msg.uniHostIFmsgBody.strHostIfRegisterFrame.u16FrameType = u16FrameType;
-	msg.uniHostIFmsgBody.strHostIfRegisterFrame.bReg = bReg;
+	msg.body.strHostIfRegisterFrame.u16FrameType = u16FrameType;
+	msg.body.strHostIfRegisterFrame.bReg = bReg;
 	msg.drvHandler = hWFIDrv;
 
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
@@ -6959,7 +6959,7 @@ s32 host_int_add_beacon(tstrWILC_WFIDrv *hWFIDrv, u32 u32Interval,
 	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	struct host_if_msg msg;
-	tstrHostIFSetBeacon *pstrSetBeaconParam = &msg.uniHostIFmsgBody.strHostIFSetBeacon;
+	tstrHostIFSetBeacon *pstrSetBeaconParam = &msg.body.strHostIFSetBeacon;
 
 	if (pstrWFIDrv == NULL) {
 		PRINT_ER("driver is null\n");
@@ -7062,7 +7062,7 @@ s32 host_int_add_station(tstrWILC_WFIDrv *hWFIDrv, tstrWILC_AddStaParam *pstrSta
 	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	struct host_if_msg msg;
-	tstrWILC_AddStaParam *pstrAddStationMsg = &msg.uniHostIFmsgBody.strAddStaParam;
+	tstrWILC_AddStaParam *pstrAddStationMsg = &msg.body.strAddStaParam;
 
 
 	if (pstrWFIDrv == NULL) {
@@ -7111,7 +7111,7 @@ s32 host_int_del_station(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8MacAddr)
 	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	struct host_if_msg msg;
-	tstrHostIFDelSta *pstrDelStationMsg = &msg.uniHostIFmsgBody.strDelStaParam;
+	tstrHostIFDelSta *pstrDelStationMsg = &msg.body.strDelStaParam;
 
 	if (pstrWFIDrv == NULL) {
 		PRINT_ER("driver is null\n");
@@ -7153,7 +7153,7 @@ s32 host_int_del_allstation(tstrWILC_WFIDrv *hWFIDrv, u8 pu8MacAddr[][ETH_ALEN])
 	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	struct host_if_msg msg;
-	tstrHostIFDelAllSta *pstrDelAllStationMsg = &msg.uniHostIFmsgBody.strHostIFDelAllSta;
+	tstrHostIFDelAllSta *pstrDelAllStationMsg = &msg.body.strHostIFDelAllSta;
 	u8 au8Zero_Buff[ETH_ALEN] = {0};
 	u32 i;
 	u8 u8AssocNumb = 0;
@@ -7213,7 +7213,7 @@ s32 host_int_edit_station(tstrWILC_WFIDrv *hWFIDrv, tstrWILC_AddStaParam *pstrSt
 	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	struct host_if_msg msg;
-	tstrWILC_AddStaParam *pstrAddStationMsg = &msg.uniHostIFmsgBody.strAddStaParam;
+	tstrWILC_AddStaParam *pstrAddStationMsg = &msg.body.strAddStaParam;
 
 	if (pstrWFIDrv == NULL) {
 		PRINT_ER("driver is null\n");
@@ -7254,7 +7254,7 @@ s32 host_int_set_power_mgmt(tstrWILC_WFIDrv *hWFIDrv, bool bIsEnabled, u32 u32Ti
 	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	struct host_if_msg msg;
-	tstrHostIfPowerMgmtParam *pstrPowerMgmtParam = &msg.uniHostIFmsgBody.strPowerMgmtparam;
+	tstrHostIfPowerMgmtParam *pstrPowerMgmtParam = &msg.body.strPowerMgmtparam;
 
 	PRINT_INFO(HOSTINF_DBG, "\n\n>> Setting PS to %d <<\n\n", bIsEnabled);
 
@@ -7288,7 +7288,7 @@ s32 host_int_setup_multicast_filter(tstrWILC_WFIDrv *hWFIDrv, bool bIsEnabled, u
 
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	struct host_if_msg msg;
-	tstrHostIFSetMulti *pstrMulticastFilterParam = &msg.uniHostIFmsgBody.strHostIfSetMulti;
+	tstrHostIFSetMulti *pstrMulticastFilterParam = &msg.body.strHostIfSetMulti;
 
 
 	if (pstrWFIDrv == NULL) {
@@ -7555,7 +7555,7 @@ static int host_int_addBASession(tstrWILC_WFIDrv *hWFIDrv, char *pBSSID, char TI
 	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	struct host_if_msg msg;
-	tstrHostIfBASessionInfo *pBASessionInfo = &msg.uniHostIFmsgBody.strHostIfBASessionInfo;
+	tstrHostIfBASessionInfo *pBASessionInfo = &msg.body.strHostIfBASessionInfo;
 
 	if (pstrWFIDrv == NULL) {
 		PRINT_ER("driver is null\n");
@@ -7586,7 +7586,7 @@ s32 host_int_delBASession(tstrWILC_WFIDrv *hWFIDrv, char *pBSSID, char TID)
 	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	struct host_if_msg msg;
-	tstrHostIfBASessionInfo *pBASessionInfo = &msg.uniHostIFmsgBody.strHostIfBASessionInfo;
+	tstrHostIfBASessionInfo *pBASessionInfo = &msg.body.strHostIfBASessionInfo;
 
 	if (pstrWFIDrv == NULL) {
 		PRINT_ER("driver is null\n");
@@ -7617,7 +7617,7 @@ s32 host_int_del_All_Rx_BASession(tstrWILC_WFIDrv *hWFIDrv, char *pBSSID, char T
 	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	struct host_if_msg msg;
-	tstrHostIfBASessionInfo *pBASessionInfo = &msg.uniHostIFmsgBody.strHostIfBASessionInfo;
+	tstrHostIfBASessionInfo *pBASessionInfo = &msg.body.strHostIfBASessionInfo;
 
 	if (pstrWFIDrv == NULL) {
 		PRINT_ER("driver is null\n");
@@ -7670,9 +7670,9 @@ s32 host_int_setup_ipaddress(tstrWILC_WFIDrv *hWFIDrv, u8 *u16ipadd, u8 idx)
 	/* prepare the WiphyParams Message */
 	msg.id = HOST_IF_MSG_SET_IPADDRESS;
 
-	msg.uniHostIFmsgBody.strHostIfSetIP.au8IPAddr = u16ipadd;
+	msg.body.strHostIfSetIP.au8IPAddr = u16ipadd;
 	msg.drvHandler = hWFIDrv;
-	msg.uniHostIFmsgBody.strHostIfSetIP.idx = idx;
+	msg.body.strHostIfSetIP.idx = idx;
 
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 	if (s32Error)
@@ -7707,9 +7707,9 @@ s32 host_int_get_ipaddress(tstrWILC_WFIDrv *hWFIDrv, u8 *u16ipadd, u8 idx)
 	/* prepare the WiphyParams Message */
 	msg.id = HOST_IF_MSG_GET_IPADDRESS;
 
-	msg.uniHostIFmsgBody.strHostIfSetIP.au8IPAddr = u16ipadd;
+	msg.body.strHostIfSetIP.au8IPAddr = u16ipadd;
 	msg.drvHandler = hWFIDrv;
-	msg.uniHostIFmsgBody.strHostIfSetIP.idx = idx;
+	msg.body.strHostIfSetIP.idx = idx;
 
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 	if (s32Error)
-- 
1.9.1

