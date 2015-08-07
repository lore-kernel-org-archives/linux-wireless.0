Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:34529 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752822AbbHGACV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Aug 2015 20:02:21 -0400
Received: by pawu10 with SMTP id u10so74103383paw.1
        for <linux-wireless@vger.kernel.org>; Thu, 06 Aug 2015 17:02:21 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, dean.lee@atmel.com,
	chris.park@atmel.com, devel@driverdev.osuosl.org,
	linux-wireless@vger.kernel.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 1/4] staging: wilc1000: use memset instead of WILC_memset
Date: Fri,  7 Aug 2015 09:02:01 +0900
Message-Id: <1438905724-26810-1-git-send-email-chaehyun.lim@gmail.com> (sfid-20150807_020226_750128_7263D7FB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use memset instead of WILC_memset.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/coreconfigurator.c       |  16 +--
 drivers/staging/wilc1000/host_interface.c         | 134 +++++++++++-----------
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c |  16 +--
 3 files changed, 83 insertions(+), 83 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index 342a336..93942b2 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -681,9 +681,9 @@ s32 CoreConfiguratorInit(void)
 		goto _fail_;
 	}
 
-	WILC_memset((void *)gps8ConfigPacket, 0, MAX_PACKET_BUFF_SIZE);
+	memset((void *)gps8ConfigPacket, 0, MAX_PACKET_BUFF_SIZE);
 
-	WILC_memset((void *)(&gstrConfigPktInfo), 0, sizeof(tstrConfigPktInfo));
+	memset((void *)(&gstrConfigPktInfo), 0, sizeof(tstrConfigPktInfo));
 _fail_:
 	return s32Error;
 }
@@ -812,7 +812,7 @@ s32 ParseNetworkInfo(u8 *pu8MsgBuffer, tstrNetworkInfo **ppstrNetworkInfo)
 		u32 u32Tsf_Hi;
 
 		pstrNetworkInfo = (tstrNetworkInfo *)WILC_MALLOC(sizeof(tstrNetworkInfo));
-		WILC_memset((void *)(pstrNetworkInfo), 0, sizeof(tstrNetworkInfo));
+		memset((void *)(pstrNetworkInfo), 0, sizeof(tstrNetworkInfo));
 
 		pstrNetworkInfo->s8rssi = pu8WidVal[0];
 
@@ -862,7 +862,7 @@ s32 ParseNetworkInfo(u8 *pu8MsgBuffer, tstrNetworkInfo **ppstrNetworkInfo)
 
 		if (u16IEsLen > 0) {
 			pstrNetworkInfo->pu8IEs = (u8 *)WILC_MALLOC(u16IEsLen);
-			WILC_memset((void *)(pstrNetworkInfo->pu8IEs), 0, u16IEsLen);
+			memset((void *)(pstrNetworkInfo->pu8IEs), 0, u16IEsLen);
 
 			WILC_memcpy(pstrNetworkInfo->pu8IEs, pu8IEs, u16IEsLen);
 		}
@@ -929,7 +929,7 @@ s32 ParseAssocRespInfo(u8 *pu8Buffer, u32 u32BufferLen,
 	u16 u16IEsLen = 0;
 
 	pstrConnectRespInfo = (tstrConnectRespInfo *)WILC_MALLOC(sizeof(tstrConnectRespInfo));
-	WILC_memset((void *)(pstrConnectRespInfo), 0, sizeof(tstrConnectRespInfo));
+	memset((void *)(pstrConnectRespInfo), 0, sizeof(tstrConnectRespInfo));
 
 	/* u16AssocRespLen = pu8Buffer[0]; */
 	u16AssocRespLen = (u16)u32BufferLen;
@@ -949,7 +949,7 @@ s32 ParseAssocRespInfo(u8 *pu8Buffer, u32 u32BufferLen,
 		u16IEsLen = u16AssocRespLen - (CAP_INFO_LEN + STATUS_CODE_LEN + AID_LEN);
 
 		pstrConnectRespInfo->pu8RespIEs = (u8 *)WILC_MALLOC(u16IEsLen);
-		WILC_memset((void *)(pstrConnectRespInfo->pu8RespIEs), 0, u16IEsLen);
+		memset((void *)(pstrConnectRespInfo->pu8RespIEs), 0, u16IEsLen);
 
 		WILC_memcpy(pstrConnectRespInfo->pu8RespIEs, pu8IEs, u16IEsLen);
 		pstrConnectRespInfo->u16RespIEsLen = u16IEsLen;
@@ -1023,7 +1023,7 @@ s32 ParseSurveyResults(u8 ppu8RcvdSiteSurveyResults[][MAX_SURVEY_RESULT_FRAG_SIZ
 		WILC_ERRORREPORT(s32Error, WILC_NO_MEM);
 	}
 
-	WILC_memset((void *)(pstrSurveyResults), 0, u32SurveyResultsCount * sizeof(wid_site_survey_reslts_s));
+	memset((void *)(pstrSurveyResults), 0, u32SurveyResultsCount * sizeof(wid_site_survey_reslts_s));
 
 	u32SurveyResultsCount = 0;
 
@@ -1871,7 +1871,7 @@ s32 ConfigWaitResponse(char *pcRespBuffer, s32 s32MaxRespBuffLen, s32 *ps32Bytes
 		*ps32BytesRead = gstrConfigPktInfo.s32BytesRead;
 	}
 
-	WILC_memset((void *)(&gstrConfigPktInfo), 0, sizeof(tstrConfigPktInfo));
+	memset((void *)(&gstrConfigPktInfo), 0, sizeof(tstrConfigPktInfo));
 
 	return s32Error;
 }
diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 02aaf39..0c06ac2 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1494,8 +1494,8 @@ static s32 Handle_Connect(void *drvHandler, tstrHostIFconnectAttr *pstrHostIFcon
 	PRINT_D(GENERIC_DBG, "Handling connect request\n");
 
 	#ifndef CONNECT_DIRECT
-	WILC_memset(gapu8RcvdSurveyResults[0], 0, MAX_SURVEY_RESULT_FRAG_SIZE);
-	WILC_memset(gapu8RcvdSurveyResults[1], 0, MAX_SURVEY_RESULT_FRAG_SIZE);
+	memset(gapu8RcvdSurveyResults[0], 0, MAX_SURVEY_RESULT_FRAG_SIZE);
+	memset(gapu8RcvdSurveyResults[1], 0, MAX_SURVEY_RESULT_FRAG_SIZE);
 
 
 	PRINT_D(HOSTINF_DBG, "Getting site survey results\n");
@@ -1972,7 +1972,7 @@ static s32 Handle_Connect(void *drvHandler, tstrHostIFconnectAttr *pstrHostIFcon
 
 		PRINT_D(HOSTINF_DBG, "could not start connecting to the required network\n");
 
-		WILC_memset(&strConnectInfo, 0, sizeof(tstrConnectInfo));
+		memset(&strConnectInfo, 0, sizeof(tstrConnectInfo));
 
 		if (pstrHostIFconnectAttr->pfConnectResult != NULL) {
 			if (pstrHostIFconnectAttr->pu8bssid != NULL)
@@ -2124,7 +2124,7 @@ static s32 Handle_ConnectTimeout(void *drvHandler)
 	gbScanWhileConnected = false;
 
 
-	WILC_memset(&strConnectInfo, 0, sizeof(tstrConnectInfo));
+	memset(&strConnectInfo, 0, sizeof(tstrConnectInfo));
 
 
 	/* First, we will notify the upper layer with the Connection failure {through the Connect Callback function},
@@ -2190,7 +2190,7 @@ static s32 Handle_ConnectTimeout(void *drvHandler)
 		pstrWFIDrv->strWILC_UsrConnReq.pu8ConnReqIEs = NULL;
 	}
 
-	WILC_memset(u8ConnectedSSID, 0, ETH_ALEN);
+	memset(u8ConnectedSSID, 0, ETH_ALEN);
 	/*BugID_5213*/
 	/*Freeing flushed join request params on connect timeout*/
 	if (gu8FlushedJoinReq != NULL && gu8FlushedJoinReqDrvHandler == (u32)drvHandler) {
@@ -2399,10 +2399,10 @@ static s32 Handle_RcvdGnrlAsyncInfo(void *drvHandler, tstrRcvdGnrlAsyncInfo *pst
 
 			PRINT_D(HOSTINF_DBG, "Recieved MAC status = %d with Reason = %d , Code = %d\n", u8MacStatus, u8MacStatusReasonCode, u8MacStatusAdditionalInfo);
 
-			WILC_memset(&strConnectInfo, 0, sizeof(tstrConnectInfo));
+			memset(&strConnectInfo, 0, sizeof(tstrConnectInfo));
 
 			if (u8MacStatus == MAC_CONNECTED) {
-				WILC_memset(gapu8RcvdAssocResp, 0, MAX_ASSOC_RESP_FRAME_SIZE);
+				memset(gapu8RcvdAssocResp, 0, MAX_ASSOC_RESP_FRAME_SIZE);
 
 				host_int_get_assoc_res_info((WILC_WFIDrvHandle)pstrWFIDrv,
 							    gapu8RcvdAssocResp,
@@ -2449,11 +2449,11 @@ static s32 Handle_RcvdGnrlAsyncInfo(void *drvHandler, tstrRcvdGnrlAsyncInfo *pst
 			if ((u8MacStatus == MAC_CONNECTED) &&
 			    (strConnectInfo.u16ConnectStatus != SUCCESSFUL_STATUSCODE))	{
 				PRINT_ER("Received MAC status is MAC_CONNECTED while the received status code in Asoc Resp is not SUCCESSFUL_STATUSCODE\n");
-				WILC_memset(u8ConnectedSSID, 0, ETH_ALEN);
+				memset(u8ConnectedSSID, 0, ETH_ALEN);
 
 			} else if (u8MacStatus == MAC_DISCONNECTED)    {
 				PRINT_ER("Received MAC status is MAC_DISCONNECTED\n");
-				WILC_memset(u8ConnectedSSID, 0, ETH_ALEN);
+				memset(u8ConnectedSSID, 0, ETH_ALEN);
 			}
 
 			/* TODO: mostafa: correct BSSID should be retrieved from actual BSSID received from AP */
@@ -2554,7 +2554,7 @@ static s32 Handle_RcvdGnrlAsyncInfo(void *drvHandler, tstrRcvdGnrlAsyncInfo *pst
 			/* Disassociation or Deauthentication frame has been received */
 			PRINT_D(HOSTINF_DBG, "Received MAC_DISCONNECTED from the FW\n");
 
-			WILC_memset(&strDisconnectNotifInfo, 0, sizeof(tstrDisconnectNotifInfo));
+			memset(&strDisconnectNotifInfo, 0, sizeof(tstrDisconnectNotifInfo));
 
 			if (pstrWFIDrv->strWILC_UsrScanReq.pfUserScanResult) {
 				PRINT_D(HOSTINF_DBG, "\n\n<< Abort the running OBSS Scan >>\n\n");
@@ -2583,7 +2583,7 @@ static s32 Handle_RcvdGnrlAsyncInfo(void *drvHandler, tstrRcvdGnrlAsyncInfo *pst
 				PRINT_ER("Connect result callback function is NULL\n");
 			}
 
-			WILC_memset(pstrWFIDrv->au8AssociatedBSSID, 0, ETH_ALEN);
+			memset(pstrWFIDrv->au8AssociatedBSSID, 0, ETH_ALEN);
 
 
 			/* Deallocation */
@@ -2791,7 +2791,7 @@ static int Handle_Key(void *drvHandler, tstrHostIFkeyAttr *pstrHostIFkeyAttr)
 				goto _WPARxGtk_end_case_;
 			}
 
-			WILC_memset(pu8keybuf, 0, RX_MIC_KEY_MSG_LEN);
+			memset(pu8keybuf, 0, RX_MIC_KEY_MSG_LEN);
 
 
 			/*|----------------------------------------------------------------------------|
@@ -2842,7 +2842,7 @@ static int Handle_Key(void *drvHandler, tstrHostIFkeyAttr *pstrHostIFkeyAttr)
 				goto _WPARxGtk_end_case_;
 			}
 
-			WILC_memset(pu8keybuf, 0, RX_MIC_KEY_MSG_LEN);
+			memset(pu8keybuf, 0, RX_MIC_KEY_MSG_LEN);
 
 
 			/*|----------------------------------------------------------------------------|
@@ -3053,7 +3053,7 @@ static void Handle_Disconnect(void *drvHandler)
 	host_int_set_power_mgmt((WILC_WFIDrvHandle)pstrWFIDrv, 0, 0);
 	#endif
 
-	WILC_memset(u8ConnectedSSID, 0, ETH_ALEN);
+	memset(u8ConnectedSSID, 0, ETH_ALEN);
 
 	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false, (u32)pstrWFIDrv);
 
@@ -3063,7 +3063,7 @@ static void Handle_Disconnect(void *drvHandler)
 	} else {
 		tstrDisconnectNotifInfo strDisconnectNotifInfo;
 
-		WILC_memset(&strDisconnectNotifInfo, 0, sizeof(tstrDisconnectNotifInfo));
+		memset(&strDisconnectNotifInfo, 0, sizeof(tstrDisconnectNotifInfo));
 
 		strDisconnectNotifInfo.u16reason = 0;
 		strDisconnectNotifInfo.ie = NULL;
@@ -3096,7 +3096,7 @@ static void Handle_Disconnect(void *drvHandler)
 
 		pstrWFIDrv->enuHostIFstate = HOST_IF_IDLE;
 
-		WILC_memset(pstrWFIDrv->au8AssociatedBSSID, 0, ETH_ALEN);
+		memset(pstrWFIDrv->au8AssociatedBSSID, 0, ETH_ALEN);
 
 
 		/* Deallocation */
@@ -3990,7 +3990,7 @@ static void ListenTimerCB(void *pvArg)
 	WILC_TimerStop(&(pstrWFIDrv->hRemainOnChannel), NULL);
 
 	/* prepare the Timer Callback message */
-	WILC_memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
+	memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
 	strHostIFmsg.u16MsgId = HOST_IF_MSG_LISTEN_TIMER_FIRED;
 	strHostIFmsg.drvHandler = pstrWFIDrv;
 	strHostIFmsg.uniHostIFmsgBody.strHostIfRemainOnChan.u32ListenSessionID = pstrWFIDrv->strHostIfRemainOnChan.u32ListenSessionID;
@@ -4329,7 +4329,7 @@ static int hostIFthread(void *pvArg)
 	tstrHostIFmsg strHostIFmsg;
 	tstrWILC_WFIDrv *pstrWFIDrv;
 
-	WILC_memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
+	memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
 
 	while (1) {
 		WILC_MsgQueueRecv(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg), &u32Ret, NULL);
@@ -4551,7 +4551,7 @@ static void TimerCB_Scan(void *pvArg)
 	tstrHostIFmsg strHostIFmsg;
 
 	/* prepare the Timer Callback message */
-	WILC_memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
+	memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
 	strHostIFmsg.drvHandler = pvArg;
 	strHostIFmsg.u16MsgId = HOST_IF_MSG_SCAN_TIMER_FIRED;
 
@@ -4564,7 +4564,7 @@ static void TimerCB_Connect(void *pvArg)
 	tstrHostIFmsg strHostIFmsg;
 
 	/* prepare the Timer Callback message */
-	WILC_memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
+	memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
 	strHostIFmsg.drvHandler = pvArg;
 	strHostIFmsg.u16MsgId = HOST_IF_MSG_CONNECT_TIMER_FIRED;
 
@@ -4626,7 +4626,7 @@ s32 host_int_remove_wep_key(WILC_WFIDrvHandle hWFIDrv, u8 u8keyIdx)
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
 
 	/* prepare the Remove Wep Key Message */
-	WILC_memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
+	memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
 
 
 	strHostIFmsg.u16MsgId = HOST_IF_MSG_KEY;
@@ -4675,7 +4675,7 @@ s32 host_int_set_WEPDefaultKeyID(WILC_WFIDrvHandle hWFIDrv, u8 u8Index)
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
 
 	/* prepare the Key Message */
-	WILC_memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
+	memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
 
 
 	strHostIFmsg.u16MsgId = HOST_IF_MSG_KEY;
@@ -4732,7 +4732,7 @@ s32 host_int_add_wep_key_bss_sta(WILC_WFIDrvHandle hWFIDrv, const u8 *pu8WepKey,
 
 
 	/* prepare the Key Message */
-	WILC_memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
+	memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
 
 
 	strHostIFmsg.u16MsgId = HOST_IF_MSG_KEY;
@@ -4798,7 +4798,7 @@ s32 host_int_add_wep_key_bss_ap(WILC_WFIDrvHandle hWFIDrv, const u8 *pu8WepKey,
 
 
 	/* prepare the Key Message */
-	WILC_memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
+	memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
 
 	if (INFO) {
 		for (i = 0; i < u8WepKeylen; i++)
@@ -4877,7 +4877,7 @@ s32 host_int_add_ptk(WILC_WFIDrvHandle hWFIDrv, const u8 *pu8Ptk, u8 u8PtkKeylen
 		u8KeyLen += TX_MIC_KEY_LEN;
 
 	/* prepare the Key Message */
-	WILC_memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
+	memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
 
 
 	strHostIFmsg.u16MsgId = HOST_IF_MSG_KEY;
@@ -4972,7 +4972,7 @@ s32 host_int_add_rx_gtk(WILC_WFIDrvHandle hWFIDrv, const u8 *pu8RxGtk, u8 u8GtkK
 	if (pstrWFIDrv == NULL)
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
 	/* prepare the Key Message */
-	WILC_memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
+	memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
 
 
 	if (pu8RxMic != NULL)
@@ -5079,7 +5079,7 @@ s32 host_int_set_pmkid_info(WILC_WFIDrvHandle hWFIDrv, tstrHostIFpmkidAttr *pu8P
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
 
 	/* prepare the Key Message */
-	WILC_memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
+	memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
 
 	strHostIFmsg.u16MsgId = HOST_IF_MSG_KEY;
 	strHostIFmsg.uniHostIFmsgBody.strHostIFkeyAttr.enuKeyType = PMKSA;
@@ -5194,7 +5194,7 @@ s32 host_int_get_MacAddress(WILC_WFIDrvHandle hWFIDrv, u8 *pu8MacAddress)
 
 
 	/* prepare the Message */
-	WILC_memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
+	memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
 
 	strHostIFmsg.u16MsgId = HOST_IF_MSG_GET_MAC_ADDRESS;
 	strHostIFmsg.uniHostIFmsgBody.strHostIfGetMacAddress.u8MacAddress = pu8MacAddress;
@@ -5229,7 +5229,7 @@ s32 host_int_set_MacAddress(WILC_WFIDrvHandle hWFIDrv, u8 *pu8MacAddress)
 	PRINT_D(GENERIC_DBG, "mac addr = %x:%x:%x\n", pu8MacAddress[0], pu8MacAddress[1], pu8MacAddress[2]);
 
 	/* prepare setting mac address message */
-	WILC_memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
+	memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
 	strHostIFmsg.u16MsgId = HOST_IF_MSG_SET_MAC_ADDRESS;
 	WILC_memcpy(strHostIFmsg.uniHostIFmsgBody.strHostIfSetMacAddress.u8MacAddress, pu8MacAddress, ETH_ALEN);
 	strHostIFmsg.drvHandler = hWFIDrv;
@@ -5448,7 +5448,7 @@ s32 host_int_set_join_req(WILC_WFIDrvHandle hWFIDrv, u8 *pu8bssid,
  *      }
  */
 	/* prepare the Connect Message */
-	WILC_memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
+	memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
 
 	strHostIFmsg.u16MsgId = HOST_IF_MSG_CONNECT;
 
@@ -5575,7 +5575,7 @@ s32 host_int_disconnect(WILC_WFIDrvHandle hWFIDrv, u16 u16ReasonCode)
 	}
 
 	/* prepare the Disconnect Message */
-	WILC_memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
+	memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
 
 	strHostIFmsg.u16MsgId = HOST_IF_MSG_DISCONNECT;
 	strHostIFmsg.drvHandler = hWFIDrv;
@@ -5765,7 +5765,7 @@ s32 host_int_set_mac_chnl_num(WILC_WFIDrvHandle hWFIDrv, u8 u8ChNum)
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
 
 	/* prepare the set channel message */
-	WILC_memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
+	memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
 	strHostIFmsg.u16MsgId = HOST_IF_MSG_SET_CHANNEL;
 	strHostIFmsg.uniHostIFmsgBody.strHostIFSetChan.u8SetChan = u8ChNum;
 	strHostIFmsg.drvHandler = hWFIDrv;
@@ -5790,7 +5790,7 @@ s32 host_int_wait_msg_queue_idle(void)
 
 	/* prepare the set driver handler message */
 
-	WILC_memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
+	memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
 	strHostIFmsg.u16MsgId = HOST_IF_MSG_Q_IDLE;
 	s32Error = WILC_MsgQueueSend(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg), NULL);
 	if (s32Error)
@@ -5816,7 +5816,7 @@ s32 host_int_set_wfi_drv_handler(u32 u32address)
 
 	/* prepare the set driver handler message */
 
-	WILC_memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
+	memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
 	strHostIFmsg.u16MsgId = HOST_IF_MSG_SET_WFIDRV_HANDLER;
 	strHostIFmsg.uniHostIFmsgBody.strHostIfSetDrvHandler.u32Address = u32address;
 	/* strHostIFmsg.drvHandler=hWFIDrv; */
@@ -5843,7 +5843,7 @@ s32 host_int_set_operation_mode(WILC_WFIDrvHandle hWFIDrv, u32 u32mode)
 
 	/* prepare the set driver handler message */
 
-	WILC_memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
+	memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
 	strHostIFmsg.u16MsgId = HOST_IF_MSG_SET_OPERATION_MODE;
 	strHostIFmsg.uniHostIFmsgBody.strHostIfSetOperationMode.u32Mode = u32mode;
 	strHostIFmsg.drvHandler = hWFIDrv;
@@ -5886,7 +5886,7 @@ s32 host_int_get_host_chnl_num(WILC_WFIDrvHandle hWFIDrv, u8 *pu8ChNo)
 	}
 
 	/* prepare the Get Channel Message */
-	WILC_memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
+	memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
 
 	strHostIFmsg.u16MsgId = HOST_IF_MSG_GET_CHNL;
 	strHostIFmsg.drvHandler = hWFIDrv;
@@ -5978,7 +5978,7 @@ s32 host_int_get_inactive_time(WILC_WFIDrvHandle hWFIDrv, const u8 *mac, u32 *pu
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
 	}
 
-	WILC_memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
+	memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
 
 
 	WILC_memcpy(strHostIFmsg.uniHostIFmsgBody.strHostIfStaInactiveT.mac,
@@ -6070,7 +6070,7 @@ s32 host_int_get_rssi(WILC_WFIDrvHandle hWFIDrv, s8 *ps8Rssi)
 
 
 	/* prepare the Get RSSI Message */
-	WILC_memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
+	memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
 
 	strHostIFmsg.u16MsgId = HOST_IF_MSG_GET_RSSI;
 	strHostIFmsg.drvHandler = hWFIDrv;
@@ -6107,7 +6107,7 @@ s32 host_int_get_link_speed(WILC_WFIDrvHandle hWFIDrv, s8 *ps8lnkspd)
 
 
 	/* prepare the Get LINKSPEED Message */
-	WILC_memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
+	memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
 
 	strHostIFmsg.u16MsgId = HOST_IF_MSG_GET_LINKSPEED;
 	strHostIFmsg.drvHandler = hWFIDrv;
@@ -6141,7 +6141,7 @@ s32 host_int_get_statistics(WILC_WFIDrvHandle hWFIDrv, tstrStatistics *pstrStati
 
 
 	/* prepare the Get RSSI Message */
-	WILC_memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
+	memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
 
 	strHostIFmsg.u16MsgId = HOST_IF_MSG_GET_STATISTICS;
 	strHostIFmsg.uniHostIFmsgBody.pUserData = (char *)pstrStatistics;
@@ -6190,7 +6190,7 @@ s32 host_int_scan(WILC_WFIDrvHandle hWFIDrv, u8 u8ScanSource,
 
 
 	/* prepare the Scan Message */
-	WILC_memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
+	memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
 
 	strHostIFmsg.u16MsgId = HOST_IF_MSG_SCAN;
 
@@ -6259,7 +6259,7 @@ s32 hif_set_cfg(WILC_WFIDrvHandle hWFIDrv, tstrCfgParamVal *pstrCfgParamVal)
 	if (pstrWFIDrv == NULL)
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
 	/* prepare the WiphyParams Message */
-	WILC_memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
+	memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
 	strHostIFmsg.u16MsgId = HOST_IF_MSG_CFG_PARAMS;
 	strHostIFmsg.uniHostIFmsgBody.strHostIFCfgParamAttr.pstrCfgParamVal = *pstrCfgParamVal;
 	strHostIFmsg.drvHandler = hWFIDrv;
@@ -6437,7 +6437,7 @@ void GetPeriodicRSSI(void *pvArg)
 		tstrHostIFmsg strHostIFmsg;
 
 		/* prepare the Get RSSI Message */
-		WILC_memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
+		memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
 
 		strHostIFmsg.u16MsgId = HOST_IF_MSG_GET_RSSI;
 		strHostIFmsg.drvHandler = pstrWFIDrv;
@@ -6497,7 +6497,7 @@ s32 host_int_init(WILC_WFIDrvHandle *phWFIDrv)
 		PRINT_ER("Failed to allocate memory\n");
 		goto _fail_timer_2;
 	}
-	WILC_memset(pstrWFIDrv, 0, sizeof(tstrWILC_WFIDrv));
+	memset(pstrWFIDrv, 0, sizeof(tstrWILC_WFIDrv));
 	/*return driver handle to user*/
 	*phWFIDrv = (WILC_WFIDrvHandle)pstrWFIDrv;
 	/*save into globl handle*/
@@ -6720,7 +6720,7 @@ s32 host_int_deinit(WILC_WFIDrvHandle hWFIDrv)
 
 	gbScanWhileConnected = false;
 
-	WILC_memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
+	memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
 
 	if (clients_count == 1)	{
 		if (WILC_TimerDestroy(&g_hPeriodicRSSI, NULL)) {
@@ -6791,7 +6791,7 @@ void NetworkInfoReceived(u8 *pu8Buffer, u32 u32Length)
 	}
 
 	/* prepare the Asynchronous Network Info message */
-	WILC_memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
+	memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
 
 	strHostIFmsg.u16MsgId = HOST_IF_MSG_RCVD_NTWRK_INFO;
 	strHostIFmsg.drvHandler = pstrWFIDrv;
@@ -6852,7 +6852,7 @@ void GnrlAsyncInfoReceived(u8 *pu8Buffer, u32 u32Length)
 	}
 
 	/* prepare the General Asynchronous Info message */
-	WILC_memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
+	memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
 
 
 	strHostIFmsg.u16MsgId = HOST_IF_MSG_RCVD_GNRL_ASYNC_INFO;
@@ -6902,7 +6902,7 @@ void host_int_ScanCompleteReceived(u8 *pu8Buffer, u32 u32Length)
 	/*if there is an ongoing scan request*/
 	if (pstrWFIDrv->strWILC_UsrScanReq.pfUserScanResult) {
 		/* prepare theScan Done message */
-		WILC_memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
+		memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
 
 		strHostIFmsg.u16MsgId = HOST_IF_MSG_RCVD_SCAN_COMPLETE;
 		strHostIFmsg.drvHandler = pstrWFIDrv;
@@ -6952,7 +6952,7 @@ s32 host_int_remain_on_channel(WILC_WFIDrvHandle hWFIDrv, u32 u32SessionID, u32
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
 
 	/* prepare the remainonchan Message */
-	WILC_memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
+	memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
 
 	/* prepare the WiphyParams Message */
 	strHostIFmsg.u16MsgId = HOST_IF_MSG_REMAIN_ON_CHAN;
@@ -7002,7 +7002,7 @@ s32 host_int_ListenStateExpired(WILC_WFIDrvHandle hWFIDrv, u32 u32SessionID)
 	WILC_TimerStop(&(pstrWFIDrv->hRemainOnChannel), NULL);
 
 	/* prepare the timer fire Message */
-	WILC_memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
+	memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
 	strHostIFmsg.u16MsgId = HOST_IF_MSG_LISTEN_TIMER_FIRED;
 	strHostIFmsg.drvHandler = hWFIDrv;
 	strHostIFmsg.uniHostIFmsgBody.strHostIfRemainOnChan.u32ListenSessionID = u32SessionID;
@@ -7034,7 +7034,7 @@ s32 host_int_frame_register(WILC_WFIDrvHandle hWFIDrv, u16 u16FrameType, bool bR
 	if (pstrWFIDrv == NULL)
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
 
-	WILC_memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
+	memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
 
 	/* prepare the WiphyParams Message */
 	strHostIFmsg.u16MsgId = HOST_IF_MSG_REGISTER_FRAME;
@@ -7096,7 +7096,7 @@ s32 host_int_add_beacon(WILC_WFIDrvHandle hWFIDrv, u32 u32Interval,
 	if (pstrWFIDrv == NULL)
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
 
-	WILC_memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
+	memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
 
 	PRINT_D(HOSTINF_DBG, "Setting adding beacon message queue params\n");
 
@@ -7194,7 +7194,7 @@ s32 host_int_add_station(WILC_WFIDrvHandle hWFIDrv, tstrWILC_AddStaParam *pstrSt
 	if (pstrWFIDrv == NULL)
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
 
-	WILC_memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
+	memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
 
 	PRINT_D(HOSTINF_DBG, "Setting adding station message queue params\n");
 
@@ -7243,7 +7243,7 @@ s32 host_int_del_station(WILC_WFIDrvHandle hWFIDrv, const u8 *pu8MacAddr)
 	if (pstrWFIDrv == NULL)
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
 
-	WILC_memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
+	memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
 
 	PRINT_D(HOSTINF_DBG, "Setting deleting station message queue params\n");
 
@@ -7255,7 +7255,7 @@ s32 host_int_del_station(WILC_WFIDrvHandle hWFIDrv, const u8 *pu8MacAddr)
 
 	/*BugID_4795: Handling situation of deleting all stations*/
 	if (pu8MacAddr == NULL)
-		WILC_memset(pstrDelStationMsg->au8MacAddr, 255, ETH_ALEN);
+		memset(pstrDelStationMsg->au8MacAddr, 255, ETH_ALEN);
 	else
 		WILC_memcpy(pstrDelStationMsg->au8MacAddr, pu8MacAddr, ETH_ALEN);
 
@@ -7291,7 +7291,7 @@ s32 host_int_del_allstation(WILC_WFIDrvHandle hWFIDrv, u8 pu8MacAddr[][ETH_ALEN]
 	if (pstrWFIDrv == NULL)
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
 
-	WILC_memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
+	memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
 
 	PRINT_D(HOSTINF_DBG, "Setting deauthenticating station message queue params\n");
 
@@ -7351,7 +7351,7 @@ s32 host_int_edit_station(WILC_WFIDrvHandle hWFIDrv, tstrWILC_AddStaParam *pstrS
 
 	PRINT_D(HOSTINF_DBG, "Setting editing station message queue params\n");
 
-	WILC_memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
+	memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
 
 
 	/* prepare the WiphyParams Message */
@@ -7392,7 +7392,7 @@ s32 host_int_set_power_mgmt(WILC_WFIDrvHandle hWFIDrv, bool bIsEnabled, u32 u32T
 
 	PRINT_D(HOSTINF_DBG, "Setting Power management message queue params\n");
 
-	WILC_memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
+	memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
 
 
 	/* prepare the WiphyParams Message */
@@ -7426,7 +7426,7 @@ s32 host_int_setup_multicast_filter(WILC_WFIDrvHandle hWFIDrv, bool bIsEnabled,
 
 	PRINT_D(HOSTINF_DBG, "Setting Multicast Filter params\n");
 
-	WILC_memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
+	memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
 
 
 	/* prepare the WiphyParams Message */
@@ -7479,7 +7479,7 @@ static void *host_int_ParseJoinBssParam(tstrNetworkInfo *ptstrNetworkInfo)
 
 	pNewJoinBssParam = WILC_MALLOC(sizeof(tstrJoinBssParam));
 	if (pNewJoinBssParam != NULL) {
-		WILC_memset(pNewJoinBssParam, 0, sizeof(tstrJoinBssParam));
+		memset(pNewJoinBssParam, 0, sizeof(tstrJoinBssParam));
 		pNewJoinBssParam->dtim_period = ptstrNetworkInfo->u8DtimPeriod;
 		pNewJoinBssParam->beacon_period = ptstrNetworkInfo->u16BeaconPeriod;
 		pNewJoinBssParam->cap_info = ptstrNetworkInfo->u16CapInfo;
@@ -7488,8 +7488,8 @@ static void *host_int_ParseJoinBssParam(tstrNetworkInfo *ptstrNetworkInfo)
 		 *      PRINT_D(HOSTINF_DBG,"%c",pNewJoinBssParam->au8bssid[i]);*/
 		WILC_memcpy((u8 *)pNewJoinBssParam->ssid, ptstrNetworkInfo->au8ssid, ptstrNetworkInfo->u8SsidLen + 1);
 		pNewJoinBssParam->ssidLen = ptstrNetworkInfo->u8SsidLen;
-		WILC_memset(pNewJoinBssParam->rsn_pcip_policy, 0xFF, 3);
-		WILC_memset(pNewJoinBssParam->rsn_auth_policy, 0xFF, 3);
+		memset(pNewJoinBssParam->rsn_pcip_policy, 0xFF, 3);
+		memset(pNewJoinBssParam->rsn_auth_policy, 0xFF, 3);
 		/*for(i=0; i<pNewJoinBssParam->ssidLen;i++)
 		 *      PRINT_D(HOSTINF_DBG,"%c",pNewJoinBssParam->ssid[i]);*/
 
@@ -7693,7 +7693,7 @@ static int host_int_addBASession(WILC_WFIDrvHandle hWFIDrv, char *pBSSID, char T
 	if (pstrWFIDrv == NULL)
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
 
-	WILC_memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
+	memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
 
 	/* prepare the WiphyParams Message */
 	strHostIFmsg.u16MsgId = HOST_IF_MSG_ADD_BA_SESSION;
@@ -7726,7 +7726,7 @@ s32 host_int_delBASession(WILC_WFIDrvHandle hWFIDrv, char *pBSSID, char TID)
 	if (pstrWFIDrv == NULL)
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
 
-	WILC_memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
+	memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
 
 	/* prepare the WiphyParams Message */
 	strHostIFmsg.u16MsgId = HOST_IF_MSG_DEL_BA_SESSION;
@@ -7759,7 +7759,7 @@ s32 host_int_del_All_Rx_BASession(WILC_WFIDrvHandle hWFIDrv, char *pBSSID, char
 	if (pstrWFIDrv == NULL)
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
 
-	WILC_memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
+	memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
 
 	/* prepare the WiphyParams Message */
 	strHostIFmsg.u16MsgId = HOST_IF_MSG_DEL_ALL_RX_BA_SESSIONS;
@@ -7802,7 +7802,7 @@ s32 host_int_setup_ipaddress(WILC_WFIDrvHandle hWFIDrv, u8 *u16ipadd, u8 idx)
 	if (pstrWFIDrv == NULL)
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
 
-	WILC_memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
+	memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
 
 	/* prepare the WiphyParams Message */
 	strHostIFmsg.u16MsgId = HOST_IF_MSG_SET_IPADDRESS;
@@ -7841,7 +7841,7 @@ s32 host_int_get_ipaddress(WILC_WFIDrvHandle hWFIDrv, u8 *u16ipadd, u8 idx)
 	if (pstrWFIDrv == NULL)
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
 
-	WILC_memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
+	memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
 
 	/* prepare the WiphyParams Message */
 	strHostIFmsg.u16MsgId = HOST_IF_MSG_GET_IPADDRESS;
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 2c0789e..e38aad0 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -574,7 +574,7 @@ static void CfgConnectResult(tenuConnDisconnEvent enuConnDisconnEvent,
 			 *  = SUCCESSFUL_STATUSCODE, while mac status is MAC_DISCONNECTED (which means something wrong happened) */
 			u16ConnectStatus = WLAN_STATUS_UNSPECIFIED_FAILURE;
 			linux_wlan_set_bssid(priv->dev, NullBssid);
-			WILC_memset(u8ConnectedSSID, 0, ETH_ALEN);
+			memset(u8ConnectedSSID, 0, ETH_ALEN);
 
 			/*BugID_5457*/
 			/*Invalidate u8WLANChannel value on wlan0 disconnect*/
@@ -640,9 +640,9 @@ static void CfgConnectResult(tenuConnDisconnEvent enuConnDisconnEvent,
 		u8P2Plocalrandom = 0x01;
 		u8P2Precvrandom = 0x00;
 		bWilc_ie = false;
-		WILC_memset(priv->au8AssociatedBss, 0, ETH_ALEN);
+		memset(priv->au8AssociatedBss, 0, ETH_ALEN);
 		linux_wlan_set_bssid(priv->dev, NullBssid);
-		WILC_memset(u8ConnectedSSID, 0, ETH_ALEN);
+		memset(u8ConnectedSSID, 0, ETH_ALEN);
 
 		/*BugID_5457*/
 		/*Invalidate u8WLANChannel value on wlan0 disconnect*/
@@ -887,8 +887,8 @@ static int WILC_WFI_CfgConnect(struct wiphy *wiphy, struct net_device *dev,
 	}
 
 	priv->WILC_WFI_wep_default = 0;
-	WILC_memset(priv->WILC_WFI_wep_key, 0, sizeof(priv->WILC_WFI_wep_key));
-	WILC_memset(priv->WILC_WFI_wep_key_len, 0, sizeof(priv->WILC_WFI_wep_key_len));
+	memset(priv->WILC_WFI_wep_key, 0, sizeof(priv->WILC_WFI_wep_key));
+	memset(priv->WILC_WFI_wep_key_len, 0, sizeof(priv->WILC_WFI_wep_key_len));
 
 	PRINT_INFO(CFG80211_DBG, "sme->crypto.wpa_versions=%x\n", sme->crypto.wpa_versions);
 	PRINT_INFO(CFG80211_DBG, "sme->crypto.cipher_group=%x\n", sme->crypto.cipher_group);
@@ -1490,7 +1490,7 @@ static int WILC_WFI_del_key(struct wiphy *wiphy, struct net_device *netdev,
 	}
 
 	if (key_index >= 0 && key_index <= 3) {
-		WILC_memset(priv->WILC_WFI_wep_key[key_index], 0, priv->WILC_WFI_wep_key_len[key_index]);
+		memset(priv->WILC_WFI_wep_key[key_index], 0, priv->WILC_WFI_wep_key_len[key_index]);
 		priv->WILC_WFI_wep_key_len[key_index] = 0;
 
 		PRINT_D(CFG80211_DBG, "Removing WEP key with index = %d\n", key_index);
@@ -1950,7 +1950,7 @@ static int WILC_WFI_del_pmksa(struct wiphy *wiphy, struct net_device *netdev,
 				 ETH_ALEN)) {
 			/*If bssid is found, reset the values*/
 			PRINT_D(CFG80211_DBG, "Reseting PMKID values\n");
-			WILC_memset(&priv->pmkid_list.pmkidlist[i], 0, sizeof(tstrHostIFpmkid));
+			memset(&priv->pmkid_list.pmkidlist[i], 0, sizeof(tstrHostIFpmkid));
 			flag = PMKID_FOUND;
 			break;
 		}
@@ -1989,7 +1989,7 @@ static int  WILC_WFI_flush_pmksa(struct wiphy *wiphy, struct net_device *netdev)
 	PRINT_D(CFG80211_DBG,  "Flushing  PMKID key values\n");
 
 	/*Get cashed Pmkids and set all with zeros*/
-	WILC_memset(&priv->pmkid_list, 0, sizeof(tstrHostIFpmkidAttr));
+	memset(&priv->pmkid_list, 0, sizeof(tstrHostIFpmkidAttr));
 
 	return 0;
 }
-- 
1.9.1

