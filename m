Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:37563 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752827AbbFZOiW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Jun 2015 10:38:22 -0400
Date: Fri, 26 Jun 2015 16:44:24 +0200
From: Luis de Bethencourt <luis@debethencourt.com>
To: linux-kernel@vger.kernel.org
Cc: Johnny Kim <johnny.kim@atmel.com>,
	Rachel Kim <rachel.kim@atmel.com>,
	Dean Lee <dean.lee@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [PATCH 1/4] staging: wilc1000: remove unnecessary braces
Message-ID: <20150626144420.GA29929@goodgumbo.baconseed.org> (sfid-20150626_163844_103721_6C8C3DCE)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Removing all checkpatch.pl warnings:
WARNING: braces {} are not necessary for single statement blocks

Signed-off-by: Luis de Bethencourt <luis@debethencourt.com>
---
 drivers/staging/wilc1000/host_interface.c | 276 ++++++++++--------------------
 1 file changed, 92 insertions(+), 184 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index d1fe73d..bf183b2 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -659,9 +659,8 @@ static s32 Handle_SetWfiDrvHandler(tstrHostIfSetDrvHandler *pstrHostIfSetDrvHand
 	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
 
 
-	if ((pstrHostIfSetDrvHandler->u32Address) == (u32)NULL) {
+	if ((pstrHostIfSetDrvHandler->u32Address) == (u32)NULL)
 		up(&hSemDeinitDrvHandle);
-	}
 
 
 	if (s32Error) {
@@ -705,9 +704,8 @@ static s32 Handle_SetOperationMode(void *drvHandler, tstrHostIfSetOperationMode
 	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
 
 
-	if ((pstrHostIfSetOperationMode->u32Mode) == (u32)NULL) {
+	if ((pstrHostIfSetOperationMode->u32Mode) == (u32)NULL)
 		up(&hSemDeinitDrvHandle);
-	}
 
 
 	if (s32Error) {
@@ -1204,10 +1202,9 @@ static s32 Handle_CfgParam(void *drvHandler, tstrHostIFCfgParamAttr *strHostIFCf
 	}
 	s32Error = SendConfigPkt(SET_CFG, strWIDList, u8WidCnt, false, (u32)pstrWFIDrv);
 
-	if (s32Error) {
+	if (s32Error)
 		PRINT_ER("Error in setting CFG params\n");
 
-	}
 	WILC_CATCH(s32Error)
 	{
 	}
@@ -1284,9 +1281,8 @@ static s32 Handle_Scan(void *drvHandler, tstrHostIFscanAttr *pstrHostIFscanAttr)
 	strWIDList[u32WidsCount].u16WIDid = (u16)WID_SSID_PROBE_REQ;
 	strWIDList[u32WidsCount].enuWIDtype = WID_STR;
 
-	for (i = 0; i < pstrHostIFscanAttr->strHiddenNetwork.u8ssidnum; i++) {
+	for (i = 0; i < pstrHostIFscanAttr->strHiddenNetwork.u8ssidnum; i++)
 		valuesize += ((pstrHostIFscanAttr->strHiddenNetwork.pstrHiddenNetworkInfo[i].u8ssidlen) + 1);
-	}
 	pu8HdnNtwrksWidVal = WILC_MALLOC(valuesize + 1);
 	strWIDList[u32WidsCount].ps8WidVal = pu8HdnNtwrksWidVal;
 	if (strWIDList[u32WidsCount].ps8WidVal != NULL) {
@@ -1336,9 +1332,8 @@ static s32 Handle_Scan(void *drvHandler, tstrHostIFscanAttr *pstrHostIFscanAttr)
 		int i;
 
 		for (i = 0; i < pstrHostIFscanAttr->u8ChnlListLen; i++)	{
-			if (pstrHostIFscanAttr->pu8ChnlFreqList[i] > 0) {
+			if (pstrHostIFscanAttr->pu8ChnlFreqList[i] > 0)
 				pstrHostIFscanAttr->pu8ChnlFreqList[i] = pstrHostIFscanAttr->pu8ChnlFreqList[i] - 1;
-			}
 		}
 	}
 
@@ -1400,9 +1395,8 @@ static s32 Handle_Scan(void *drvHandler, tstrHostIFscanAttr *pstrHostIFscanAttr)
 		pstrHostIFscanAttr->pu8ChnlFreqList = NULL;
 	}
 
-	if (pu8HdnNtwrksWidVal != NULL)	{
+	if (pu8HdnNtwrksWidVal != NULL)
 		WILC_FREE(pu8HdnNtwrksWidVal);
-	}
 
 	return s32Error;
 }
@@ -1778,9 +1772,8 @@ static s32 Handle_Connect(void *drvHandler, tstrHostIFconnectAttr *pstrHostIFcon
 	strWIDList[u32WidsCount].s32ValueSize = MAX_SSID_LEN + 7;
 	strWIDList[u32WidsCount].ps8WidVal = WILC_MALLOC(strWIDList[u32WidsCount].s32ValueSize);
 
-	if (strWIDList[u32WidsCount].ps8WidVal == NULL) {
+	if (strWIDList[u32WidsCount].ps8WidVal == NULL)
 		WILC_ERRORREPORT(s32Error, WILC_NO_MEM);
-	}
 
 	pu8CurrByte = strWIDList[u32WidsCount].ps8WidVal;
 
@@ -1795,9 +1788,8 @@ static s32 Handle_Connect(void *drvHandler, tstrHostIFconnectAttr *pstrHostIFcon
 		PRINT_ER("Channel out of range\n");
 		*(pu8CurrByte++) = 0xFF;
 	}
-	if (pstrHostIFconnectAttr->pu8bssid != NULL) {
+	if (pstrHostIFconnectAttr->pu8bssid != NULL)
 		WILC_memcpy(pu8CurrByte, pstrHostIFconnectAttr->pu8bssid, 6);
-	}
 	pu8CurrByte += 6;
 
 	/* keep the buffer at the start of the allocated pointer to use it with the free*/
@@ -1817,9 +1809,8 @@ static s32 Handle_Connect(void *drvHandler, tstrHostIFconnectAttr *pstrHostIFcon
 		gu32FlushedJoinReqSize = strWIDList[u32WidsCount].s32ValueSize;
 		gu8FlushedJoinReq = WILC_MALLOC(gu32FlushedJoinReqSize);
 	}
-	if (strWIDList[u32WidsCount].ps8WidVal == NULL) {
+	if (strWIDList[u32WidsCount].ps8WidVal == NULL)
 		WILC_ERRORREPORT(s32Error, WILC_NO_MEM);
-	}
 
 	pu8CurrByte = strWIDList[u32WidsCount].ps8WidVal;
 
@@ -1845,15 +1836,13 @@ static s32 Handle_Connect(void *drvHandler, tstrHostIFconnectAttr *pstrHostIFcon
 	PRINT_D(HOSTINF_DBG, "* Cap Info %0x*\n", (*(pu8CurrByte - 2) | ((*(pu8CurrByte - 1)) << 8)));
 
 	/* sa*/
-	if (pstrHostIFconnectAttr->pu8bssid != NULL) {
+	if (pstrHostIFconnectAttr->pu8bssid != NULL)
 		WILC_memcpy(pu8CurrByte, pstrHostIFconnectAttr->pu8bssid, 6);
-	}
 	pu8CurrByte += 6;
 
 	/* bssid*/
-	if (pstrHostIFconnectAttr->pu8bssid != NULL) {
+	if (pstrHostIFconnectAttr->pu8bssid != NULL)
 		WILC_memcpy(pu8CurrByte, pstrHostIFconnectAttr->pu8bssid, 6);
-	}
 	pu8CurrByte += 6;
 
 	/* Beacon Period*/
@@ -1990,9 +1979,8 @@ static s32 Handle_Connect(void *drvHandler, tstrHostIFconnectAttr *pstrHostIFcon
 		WILC_memset(&strConnectInfo, 0, sizeof(tstrConnectInfo));
 
 		if (pstrHostIFconnectAttr->pfConnectResult != NULL) {
-			if (pstrHostIFconnectAttr->pu8bssid != NULL) {
+			if (pstrHostIFconnectAttr->pu8bssid != NULL)
 				WILC_memcpy(strConnectInfo.au8bssid, pstrHostIFconnectAttr->pu8bssid, 6);
-			}
 
 			if (pstrHostIFconnectAttr->pu8IEs != NULL) {
 				strConnectInfo.ReqIEsLen = pstrHostIFconnectAttr->IEsLen;
@@ -2039,9 +2027,8 @@ static s32 Handle_Connect(void *drvHandler, tstrHostIFconnectAttr *pstrHostIFcon
 		pstrHostIFconnectAttr->pu8IEs = NULL;
 	}
 
-	if (pu8CurrByte != NULL) {
+	if (pu8CurrByte != NULL)
 		WILC_FREE(pu8CurrByte);
-	}
 	return s32Error;
 }
 
@@ -2186,9 +2173,8 @@ static s32 Handle_ConnectTimeout(void *drvHandler)
 	PRINT_D(HOSTINF_DBG, "Sending disconnect request\n");
 
 	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false, (u32)pstrWFIDrv);
-	if (s32Error) {
+	if (s32Error)
 		PRINT_ER("Failed to send dissconect config packet\n");
-	}
 
 	/* Deallocation of the Saved Connect Request in the global Handle */
 	pstrWFIDrv->strWILC_UsrConnReq.ssidLen = 0;
@@ -2371,9 +2357,8 @@ static s32 Handle_RcvdGnrlAsyncInfo(void *drvHandler, tstrRcvdGnrlAsyncInfo *pst
 	tstrDisconnectNotifInfo strDisconnectNotifInfo;
 	s32 s32Err = WILC_SUCCESS;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *) drvHandler;
-	if (pstrWFIDrv == NULL)	{
+	if (pstrWFIDrv == NULL)
 		PRINT_ER("Driver handler is NULL\n");
-	}
 	PRINT_D(GENERIC_DBG, "Current State = %d,Received state = %d\n", pstrWFIDrv->enuHostIFstate,
 		pstrRcvdGnrlAsyncInfo->pu8Buffer[7]);
 
@@ -2654,10 +2639,9 @@ static s32 Handle_RcvdGnrlAsyncInfo(void *drvHandler, tstrRcvdGnrlAsyncInfo *pst
 			PRINT_D(HOSTINF_DBG, "\n\n<< Abort the running Scan >> \n\n");
 			/*Abort the running scan*/
 			WILC_TimerStop(&(pstrWFIDrv->hScanTimer), NULL);
-			if (pstrWFIDrv->strWILC_UsrScanReq.pfUserScanResult) {
+			if (pstrWFIDrv->strWILC_UsrScanReq.pfUserScanResult)
 				Handle_ScanDone((void *)pstrWFIDrv, SCAN_EVENT_ABORTED);
 
-			}
 		}
 
 	}
@@ -3463,9 +3447,8 @@ static void Handle_AddBeacon(void *drvHandler, tstrHostIFSetBeacon *pstrSetBeaco
 	strWID.enuWIDtype = WID_BIN;
 	strWID.s32ValueSize = pstrSetBeaconParam->u32HeadLen + pstrSetBeaconParam->u32TailLen + 16;
 	strWID.ps8WidVal = WILC_MALLOC(strWID.s32ValueSize);
-	if (strWID.ps8WidVal == NULL) {
+	if (strWID.ps8WidVal == NULL)
 		WILC_ERRORREPORT(s32Error, WILC_NO_MEM);
-	}
 
 	pu8CurrByte = strWID.ps8WidVal;
 	*pu8CurrByte++ = (pstrSetBeaconParam->u32Interval & 0xFF);
@@ -3534,9 +3517,8 @@ static void Handle_DelBeacon(void *drvHandler, tstrHostIFDelBeacon *pstrDelBeaco
 	strWID.s32ValueSize = sizeof(char);
 	strWID.ps8WidVal = &gu8DelBcn;
 
-	if (strWID.ps8WidVal == NULL) {
+	if (strWID.ps8WidVal == NULL)
 		WILC_ERRORREPORT(s32Error, WILC_NO_MEM);
-	}
 
 	pu8CurrByte = strWID.ps8WidVal;
 
@@ -3580,9 +3562,8 @@ static u32 WILC_HostIf_PackStaParam(u8 *pu8Buffer, tstrWILC_AddStaParam *pstrSta
 	*pu8CurrByte++ = (pstrStationParam->u16AssocID >> 8) & 0xFF;
 
 	*pu8CurrByte++ = pstrStationParam->u8NumRates;
-	if (pstrStationParam->u8NumRates > 0) {
+	if (pstrStationParam->u8NumRates > 0)
 		WILC_memcpy(pu8CurrByte, pstrStationParam->pu8Rates, pstrStationParam->u8NumRates);
-	}
 	pu8CurrByte += pstrStationParam->u8NumRates;
 
 	*pu8CurrByte++ = pstrStationParam->bIsHTSupported;
@@ -3633,9 +3614,8 @@ static void Handle_AddStation(void *drvHandler, tstrWILC_AddStaParam *pstrStatio
 	strWID.s32ValueSize = WILC_ADD_STA_LENGTH + pstrStationParam->u8NumRates;
 
 	strWID.ps8WidVal = WILC_MALLOC(strWID.s32ValueSize);
-	if (strWID.ps8WidVal == NULL) {
+	if (strWID.ps8WidVal == NULL)
 		WILC_ERRORREPORT(s32Error, WILC_NO_MEM);
-	}
 
 	pu8CurrByte = strWID.ps8WidVal;
 	pu8CurrByte += WILC_HostIf_PackStaParam(pu8CurrByte, pstrStationParam);
@@ -3679,9 +3659,8 @@ static void Handle_DelAllSta(void *drvHandler, tstrHostIFDelAllSta *pstrDelAllSt
 	PRINT_D(HOSTINF_DBG, "Handling delete station \n");
 
 	strWID.ps8WidVal = WILC_MALLOC((pstrDelAllStaParam->u8Num_AssocSta * ETH_ALEN) + 1);
-	if (strWID.ps8WidVal == NULL) {
+	if (strWID.ps8WidVal == NULL)
 		WILC_ERRORREPORT(s32Error, WILC_NO_MEM);
-	}
 
 	pu8CurrByte = strWID.ps8WidVal;
 
@@ -3736,9 +3715,8 @@ static void Handle_DelStation(void *drvHandler, tstrHostIFDelSta *pstrDelStaPara
 	PRINT_D(HOSTINF_DBG, "Handling delete station \n");
 
 	strWID.ps8WidVal = WILC_MALLOC(strWID.s32ValueSize);
-	if (strWID.ps8WidVal == NULL) {
+	if (strWID.ps8WidVal == NULL)
 		WILC_ERRORREPORT(s32Error, WILC_NO_MEM);
-	}
 
 	pu8CurrByte = strWID.ps8WidVal;
 
@@ -3781,9 +3759,8 @@ static void Handle_EditStation(void *drvHandler, tstrWILC_AddStaParam *pstrStati
 
 	PRINT_D(HOSTINF_DBG, "Handling edit station\n");
 	strWID.ps8WidVal = WILC_MALLOC(strWID.s32ValueSize);
-	if (strWID.ps8WidVal == NULL) {
+	if (strWID.ps8WidVal == NULL)
 		WILC_ERRORREPORT(s32Error, WILC_NO_MEM);
-	}
 
 	pu8CurrByte = strWID.ps8WidVal;
 	pu8CurrByte += WILC_HostIf_PackStaParam(pu8CurrByte, pstrStationParam);
@@ -3858,18 +3835,16 @@ static int Handle_RemainOnChan(void *drvHandler, tstrHostIfRemainOnChan *pstrHos
 	strWID.s32ValueSize = 2;
 	strWID.ps8WidVal = (s8 *)WILC_MALLOC(strWID.s32ValueSize);
 
-	if (strWID.ps8WidVal == NULL) {
+	if (strWID.ps8WidVal == NULL)
 		WILC_ERRORREPORT(s32Error, WILC_NO_MEM);
-	}
 
 	strWID.ps8WidVal[0] = u8remain_on_chan_flag;
 	strWID.ps8WidVal[1] = (s8)pstrHostIfRemainOnChan->u16Channel;
 
 	/*Sending Cfg*/
 	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
-	if (s32Error != WILC_SUCCESS) {
+	if (s32Error != WILC_SUCCESS)
 		PRINT_ER("Failed to set remain on channel\n");
-	}
 
 	WILC_CATCH(-1)
 	{
@@ -3877,9 +3852,8 @@ static int Handle_RemainOnChan(void *drvHandler, tstrHostIfRemainOnChan *pstrHos
 		WILC_TimerStart(&(pstrWFIDrv->hRemainOnChannel), pstrHostIfRemainOnChan->u32duration, (void *)pstrWFIDrv, NULL);
 
 		/*Calling CFG ready_on_channel*/
-		if (pstrWFIDrv->strHostIfRemainOnChan.pRemainOnChanReady) {
+		if (pstrWFIDrv->strHostIfRemainOnChan.pRemainOnChanReady)
 			pstrWFIDrv->strHostIfRemainOnChan.pRemainOnChanReady(pstrWFIDrv->strHostIfRemainOnChan.pVoid);
-		}
 
 		if (pstrWFIDrv->u8RemainOnChan_pendingreq)
 			pstrWFIDrv->u8RemainOnChan_pendingreq = 0;
@@ -3909,9 +3883,8 @@ static int Handle_RegisterFrame(void *drvHandler, tstrHostIfRegisterFrame *pstrH
 	strWID.u16WIDid = (u16)WID_REGISTER_FRAME;
 	strWID.enuWIDtype = WID_STR;
 	strWID.ps8WidVal = WILC_MALLOC(sizeof(u16) + 2);
-	if (strWID.ps8WidVal == NULL) {
+	if (strWID.ps8WidVal == NULL)
 		WILC_ERRORREPORT(s32Error, WILC_NO_MEM);
-	}
 
 	pu8CurrByte = strWID.ps8WidVal;
 
@@ -3968,9 +3941,8 @@ static u32 Handle_ListenStateExpired(void *drvHandler, tstrHostIfRemainOnChan *p
 		strWID.s32ValueSize = 2;
 		strWID.ps8WidVal = WILC_MALLOC(strWID.s32ValueSize);
 
-		if (strWID.ps8WidVal == NULL) {
+		if (strWID.ps8WidVal == NULL)
 			PRINT_ER("Failed to allocate memory\n");
-		}
 
 		strWID.ps8WidVal[0] = u8remain_on_chan_flag;
 		strWID.ps8WidVal[1] = FALSE_FRMWR_CHANNEL;
@@ -4022,9 +3994,8 @@ static void ListenTimerCB(void *pvArg)
 
 	/* send the message */
 	s32Error = WILC_MsgQueueSend(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg), NULL);
-	if (s32Error) {
+	if (s32Error)
 		WILC_ERRORREPORT(s32Error, s32Error);
-	}
 	WILC_CATCH(s32Error)
 	{
 
@@ -4095,9 +4066,8 @@ static void Handle_SetMulticastFilter(void *drvHandler, tstrHostIFSetMulti *strH
 	strWID.enuWIDtype = WID_BIN;
 	strWID.s32ValueSize = sizeof(tstrHostIFSetMulti) + ((strHostIfSetMulti->u32count) * ETH_ALEN);
 	strWID.ps8WidVal = WILC_MALLOC(strWID.s32ValueSize);
-	if (strWID.ps8WidVal == NULL) {
+	if (strWID.ps8WidVal == NULL)
 		WILC_ERRORREPORT(s32Error, WILC_NO_MEM);
-	}
 
 	pu8CurrByte = strWID.ps8WidVal;
 	*pu8CurrByte++ = (strHostIfSetMulti->bIsEnabled & 0xFF);
@@ -4430,9 +4400,8 @@ static int hostIFthread(void *pvArg)
 
 			/*BugID_5213*/
 			/*Allow chip sleep, only if both interfaces are not connected*/
-			if (!linux_wlan_get_num_conn_ifcs()) {
+			if (!linux_wlan_get_num_conn_ifcs())
 				chip_sleep_manually(INFINITE_SLEEP_TIME);
-			}
 
 			Handle_ScanDone(strHostIFmsg.drvHandler, SCAN_EVENT_DONE);
 
@@ -4649,9 +4618,8 @@ s32 host_int_remove_wep_key(WILC_WFIDrvHandle hWFIDrv, u8 u8keyIdx)
 	tstrHostIFmsg strHostIFmsg;
 
 
-	if (pstrWFIDrv == NULL) {
+	if (pstrWFIDrv == NULL)
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
-	}
 
 	/* prepare the Remove Wep Key Message */
 	WILC_memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
@@ -4699,9 +4667,8 @@ s32 host_int_set_WEPDefaultKeyID(WILC_WFIDrvHandle hWFIDrv, u8 u8Index)
 	tstrHostIFmsg strHostIFmsg;
 
 
-	if (pstrWFIDrv == NULL) {
+	if (pstrWFIDrv == NULL)
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
-	}
 
 	/* prepare the Key Message */
 	WILC_memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
@@ -4756,10 +4723,9 @@ s32 host_int_add_wep_key_bss_sta(WILC_WFIDrvHandle hWFIDrv, const u8 *pu8WepKey,
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	tstrHostIFmsg strHostIFmsg;
 
-	if (pstrWFIDrv == NULL) {
+	if (pstrWFIDrv == NULL)
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
 
-	}
 
 	/* prepare the Key Message */
 	WILC_memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
@@ -4823,10 +4789,9 @@ s32 host_int_add_wep_key_bss_ap(WILC_WFIDrvHandle hWFIDrv, const u8 *pu8WepKey,
 	tstrHostIFmsg strHostIFmsg;
 	u8 i;
 
-	if (pstrWFIDrv == NULL) {
+	if (pstrWFIDrv == NULL)
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
 
-	}
 
 	/* prepare the Key Message */
 	WILC_memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
@@ -4899,15 +4864,12 @@ s32 host_int_add_ptk(WILC_WFIDrvHandle hWFIDrv, const u8 *pu8Ptk, u8 u8PtkKeylen
 	tstrHostIFmsg strHostIFmsg;
 	u8 u8KeyLen = u8PtkKeylen;
 	u32 i;
-	if (pstrWFIDrv == NULL) {
+	if (pstrWFIDrv == NULL)
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
-	}
-	if (pu8RxMic != NULL) {
+	if (pu8RxMic != NULL)
 		u8KeyLen += RX_MIC_KEY_LEN;
-	}
-	if (pu8TxMic != NULL) {
+	if (pu8TxMic != NULL)
 		u8KeyLen += TX_MIC_KEY_LEN;
-	}
 
 	/* prepare the Key Message */
 	WILC_memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
@@ -5002,19 +4964,16 @@ s32 host_int_add_rx_gtk(WILC_WFIDrvHandle hWFIDrv, const u8 *pu8RxGtk, u8 u8GtkK
 	tstrHostIFmsg strHostIFmsg;
 	u8 u8KeyLen = u8GtkKeylen;
 
-	if (pstrWFIDrv == NULL) {
+	if (pstrWFIDrv == NULL)
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
-	}
 	/* prepare the Key Message */
 	WILC_memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
 
 
-	if (pu8RxMic != NULL) {
+	if (pu8RxMic != NULL)
 		u8KeyLen += RX_MIC_KEY_LEN;
-	}
-	if (pu8TxMic != NULL) {
+	if (pu8TxMic != NULL)
 		u8KeyLen += TX_MIC_KEY_LEN;
-	}
 	if (KeyRSC != NULL) {
 		strHostIFmsg.uniHostIFmsgBody.strHostIFkeyAttr.
 		uniHostIFkeyAttr.strHostIFwpaAttr.pu8seq = (u8 *)WILC_MALLOC(u32KeyRSClen);
@@ -5111,9 +5070,8 @@ s32 host_int_set_pmkid_info(WILC_WFIDrvHandle hWFIDrv, tstrHostIFpmkidAttr *pu8P
 	u32 i;
 
 
-	if (pstrWFIDrv == NULL) {
+	if (pstrWFIDrv == NULL)
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
-	}
 
 	/* prepare the Key Message */
 	WILC_memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
@@ -5464,9 +5422,8 @@ s32 host_int_set_join_req(WILC_WFIDrvHandle hWFIDrv, u8 *pu8bssid,
 	tstrHostIFmsg strHostIFmsg;
 	tenuScanConnTimer enuScanConnTimer;
 
-	if (pstrWFIDrv == NULL || pfConnectResult == NULL) {
+	if (pstrWFIDrv == NULL || pfConnectResult == NULL)
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
-	}
 
 	if (hWFIDrv == NULL) {
 		PRINT_ER("Driver not initialized: gWFiDrvHandle = NULL\n");
@@ -5564,9 +5521,8 @@ s32 host_int_flush_join_req(WILC_WFIDrvHandle hWFIDrv)
 	}
 
 
-	if (hWFIDrv  == NULL) {
+	if (hWFIDrv  == NULL)
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
-	}
 
 
 	strHostIFmsg.u16MsgId = HOST_IF_MSG_FLUSH_CONNECT;
@@ -5800,9 +5756,8 @@ s32 host_int_set_mac_chnl_num(WILC_WFIDrvHandle hWFIDrv, u8 u8ChNum)
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	tstrHostIFmsg strHostIFmsg;
 
-	if (pstrWFIDrv == NULL) {
+	if (pstrWFIDrv == NULL)
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
-	}
 
 	/* prepare the set channel message */
 	WILC_memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
@@ -5811,9 +5766,8 @@ s32 host_int_set_mac_chnl_num(WILC_WFIDrvHandle hWFIDrv, u8 u8ChNum)
 	strHostIFmsg.drvHandler = hWFIDrv;
 
 	s32Error = WILC_MsgQueueSend(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg), NULL);
-	if (s32Error) {
+	if (s32Error)
 		WILC_ERRORREPORT(s32Error, s32Error);
-	}
 	WILC_CATCH(s32Error)
 	{
 
@@ -5834,9 +5788,8 @@ s32 host_int_wait_msg_queue_idle(void)
 	WILC_memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
 	strHostIFmsg.u16MsgId = HOST_IF_MSG_Q_IDLE;
 	s32Error = WILC_MsgQueueSend(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg), NULL);
-	if (s32Error) {
+	if (s32Error)
 		WILC_ERRORREPORT(s32Error, s32Error);
-	}
 	WILC_CATCH(s32Error)
 	{
 
@@ -5864,9 +5817,8 @@ s32 host_int_set_wfi_drv_handler(u32 u32address)
 	/* strHostIFmsg.drvHandler=hWFIDrv; */
 
 	s32Error = WILC_MsgQueueSend(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg), NULL);
-	if (s32Error) {
+	if (s32Error)
 		WILC_ERRORREPORT(s32Error, s32Error);
-	}
 	WILC_CATCH(s32Error)
 	{
 
@@ -5892,9 +5844,8 @@ s32 host_int_set_operation_mode(WILC_WFIDrvHandle hWFIDrv, u32 u32mode)
 	strHostIFmsg.drvHandler = hWFIDrv;
 
 	s32Error = WILC_MsgQueueSend(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg), NULL);
-	if (s32Error) {
+	if (s32Error)
 		WILC_ERRORREPORT(s32Error, s32Error);
-	}
 	WILC_CATCH(s32Error)
 	{
 
@@ -6229,9 +6180,8 @@ s32 host_int_scan(WILC_WFIDrvHandle hWFIDrv, u8 u8ScanSource,
 	tstrHostIFmsg strHostIFmsg;
 	tenuScanConnTimer enuScanConnTimer;
 
-	if (pstrWFIDrv == NULL || ScanResult == NULL)	{
+	if (pstrWFIDrv == NULL || ScanResult == NULL)
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
-	}
 
 
 	/* prepare the Scan Message */
@@ -6301,9 +6251,8 @@ s32 hif_set_cfg(WILC_WFIDrvHandle hWFIDrv, tstrCfgParamVal *pstrCfgParamVal)
 	tstrHostIFmsg strHostIFmsg;
 
 
-	if (pstrWFIDrv == NULL) {
+	if (pstrWFIDrv == NULL)
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
-	}
 	/* prepare the WiphyParams Message */
 	WILC_memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
 	strHostIFmsg.u16MsgId = HOST_IF_MSG_CFG_PARAMS;
@@ -6794,9 +6743,8 @@ s32 host_int_deinit(WILC_WFIDrvHandle hWFIDrv)
 
 
 		s32Error = WILC_MsgQueueSend(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg), NULL);
-		if (s32Error != WILC_SUCCESS) {
+		if (s32Error != WILC_SUCCESS)
 			PRINT_ER("Error in sending deinit's message queue message function: Error(%d)\n", s32Error);
-		}
 
 		down(&hSemHostIFthrdEnd);
 
@@ -6866,9 +6814,8 @@ void NetworkInfoReceived(u8 *pu8Buffer, u32 u32Length)
 
 	/* send the message */
 	s32Error = WILC_MsgQueueSend(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg), NULL);
-	if (s32Error) {
+	if (s32Error)
 		PRINT_ER("Error in sending network info message queue message parameters: Error(%d)\n", s32Error);
-	}
 
 
 	return;
@@ -6930,9 +6877,8 @@ void GnrlAsyncInfoReceived(u8 *pu8Buffer, u32 u32Length)
 
 	/* send the message */
 	s32Error = WILC_MsgQueueSend(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg), NULL);
-	if (s32Error) {
+	if (s32Error)
 		PRINT_ER("Error in sending message queue asynchronous message info: Error(%d)\n", s32Error);
-	}
 
 	/*BugID_5348*/
 	up(&hSemHostIntDeinit);
@@ -6960,9 +6906,8 @@ void host_int_ScanCompleteReceived(u8 *pu8Buffer, u32 u32Length)
 
 	PRINT_D(GENERIC_DBG, "Scan notification received %p\n", pstrWFIDrv);
 
-	if (pstrWFIDrv == NULL || pstrWFIDrv == terminated_handle) {
+	if (pstrWFIDrv == NULL || pstrWFIDrv == terminated_handle)
 		return;
-	}
 
 	/*if there is an ongoing scan request*/
 	if (pstrWFIDrv->strWILC_UsrScanReq.pfUserScanResult) {
@@ -6983,9 +6928,8 @@ void host_int_ScanCompleteReceived(u8 *pu8Buffer, u32 u32Length)
 
 		/* send the message */
 		s32Error = WILC_MsgQueueSend(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg), NULL);
-		if (s32Error) {
+		if (s32Error)
 			PRINT_ER("Error in sending message queue scan complete parameters: Error(%d)\n", s32Error);
-		}
 	}
 
 
@@ -7014,9 +6958,8 @@ s32 host_int_remain_on_channel(WILC_WFIDrvHandle hWFIDrv, u32 u32SessionID, u32
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	tstrHostIFmsg strHostIFmsg;
 
-	if (pstrWFIDrv == NULL) {
+	if (pstrWFIDrv == NULL)
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
-	}
 
 	/* prepare the remainonchan Message */
 	WILC_memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
@@ -7032,9 +6975,8 @@ s32 host_int_remain_on_channel(WILC_WFIDrvHandle hWFIDrv, u32 u32SessionID, u32
 	strHostIFmsg.drvHandler = hWFIDrv;
 
 	s32Error = WILC_MsgQueueSend(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg), NULL);
-	if (s32Error) {
+	if (s32Error)
 		WILC_ERRORREPORT(s32Error, s32Error);
-	}
 	WILC_CATCH(s32Error)
 	{
 
@@ -7063,9 +7005,8 @@ s32 host_int_ListenStateExpired(WILC_WFIDrvHandle hWFIDrv, u32 u32SessionID)
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	tstrHostIFmsg strHostIFmsg;
 
-	if (pstrWFIDrv == NULL) {
+	if (pstrWFIDrv == NULL)
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
-	}
 
 	/*Stopping remain-on-channel timer*/
 	WILC_TimerStop(&(pstrWFIDrv->hRemainOnChannel), NULL);
@@ -7077,9 +7018,8 @@ s32 host_int_ListenStateExpired(WILC_WFIDrvHandle hWFIDrv, u32 u32SessionID)
 	strHostIFmsg.uniHostIFmsgBody.strHostIfRemainOnChan.u32ListenSessionID = u32SessionID;
 
 	s32Error = WILC_MsgQueueSend(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg), NULL);
-	if (s32Error) {
+	if (s32Error)
 		WILC_ERRORREPORT(s32Error, s32Error);
-	}
 	WILC_CATCH(s32Error)
 	{
 
@@ -7101,9 +7041,8 @@ s32 host_int_frame_register(WILC_WFIDrvHandle hWFIDrv, u16 u16FrameType, bool bR
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	tstrHostIFmsg strHostIFmsg;
 
-	if (pstrWFIDrv == NULL) {
+	if (pstrWFIDrv == NULL)
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
-	}
 
 	WILC_memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
 
@@ -7129,9 +7068,8 @@ s32 host_int_frame_register(WILC_WFIDrvHandle hWFIDrv, u16 u16FrameType, bool bR
 	strHostIFmsg.drvHandler = hWFIDrv;
 
 	s32Error = WILC_MsgQueueSend(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg), NULL);
-	if (s32Error) {
+	if (s32Error)
 		WILC_ERRORREPORT(s32Error, s32Error);
-	}
 	WILC_CATCH(s32Error)
 	{
 
@@ -7165,9 +7103,8 @@ s32 host_int_add_beacon(WILC_WFIDrvHandle hWFIDrv, u32 u32Interval,
 	tstrHostIFmsg strHostIFmsg;
 	tstrHostIFSetBeacon *pstrSetBeaconParam = &strHostIFmsg.uniHostIFmsgBody.strHostIFSetBeacon;
 
-	if (pstrWFIDrv == NULL) {
+	if (pstrWFIDrv == NULL)
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
-	}
 
 	WILC_memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
 
@@ -7181,37 +7118,32 @@ s32 host_int_add_beacon(WILC_WFIDrvHandle hWFIDrv, u32 u32Interval,
 	pstrSetBeaconParam->u32DTIMPeriod = u32DTIMPeriod;
 	pstrSetBeaconParam->u32HeadLen = u32HeadLen;
 	pstrSetBeaconParam->pu8Head = (u8 *)WILC_MALLOC(u32HeadLen);
-	if (pstrSetBeaconParam->pu8Head == NULL) {
+	if (pstrSetBeaconParam->pu8Head == NULL)
 		WILC_ERRORREPORT(s32Error, WILC_NO_MEM);
-	}
 	WILC_memcpy(pstrSetBeaconParam->pu8Head, pu8Head, u32HeadLen);
 	pstrSetBeaconParam->u32TailLen = u32TailLen;
 
 	/* Bug 4599 : if tail length = 0 skip allocating & copying */
 	if (u32TailLen > 0) {
 		pstrSetBeaconParam->pu8Tail = (u8 *)WILC_MALLOC(u32TailLen);
-		if (pstrSetBeaconParam->pu8Tail == NULL) {
+		if (pstrSetBeaconParam->pu8Tail == NULL)
 			WILC_ERRORREPORT(s32Error, WILC_NO_MEM);
-		}
 		WILC_memcpy(pstrSetBeaconParam->pu8Tail, pu8Tail, u32TailLen);
 	} else {
 		pstrSetBeaconParam->pu8Tail = NULL;
 	}
 
 	s32Error = WILC_MsgQueueSend(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg), NULL);
-	if (s32Error) {
+	if (s32Error)
 		WILC_ERRORREPORT(s32Error, s32Error);
-	}
 
 	WILC_CATCH(s32Error)
 	{
-		if (pstrSetBeaconParam->pu8Head != NULL) {
+		if (pstrSetBeaconParam->pu8Head != NULL)
 			WILC_FREE(pstrSetBeaconParam->pu8Head);
-		}
 
-		if (pstrSetBeaconParam->pu8Tail != NULL) {
+		if (pstrSetBeaconParam->pu8Tail != NULL)
 			WILC_FREE(pstrSetBeaconParam->pu8Tail);
-		}
 	}
 
 	return s32Error;
@@ -7234,9 +7166,8 @@ s32 host_int_del_beacon(WILC_WFIDrvHandle hWFIDrv)
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	tstrHostIFmsg strHostIFmsg;
 
-	if (pstrWFIDrv == NULL) {
+	if (pstrWFIDrv == NULL)
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
-	}
 
 	/* prepare the WiphyParams Message */
 	strHostIFmsg.u16MsgId = HOST_IF_MSG_DEL_BEACON;
@@ -7270,9 +7201,8 @@ s32 host_int_add_station(WILC_WFIDrvHandle hWFIDrv, tstrWILC_AddStaParam *pstrSt
 	tstrWILC_AddStaParam *pstrAddStationMsg = &strHostIFmsg.uniHostIFmsgBody.strAddStaParam;
 
 
-	if (pstrWFIDrv == NULL) {
+	if (pstrWFIDrv == NULL)
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
-	}
 
 	WILC_memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
 
@@ -7294,9 +7224,8 @@ s32 host_int_add_station(WILC_WFIDrvHandle hWFIDrv, tstrWILC_AddStaParam *pstrSt
 
 
 	s32Error = WILC_MsgQueueSend(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg), NULL);
-	if (s32Error) {
+	if (s32Error)
 		WILC_ERRORREPORT(s32Error, s32Error);
-	}
 
 	WILC_CATCH(s32Error)
 	{
@@ -7320,9 +7249,8 @@ s32 host_int_del_station(WILC_WFIDrvHandle hWFIDrv, const u8 *pu8MacAddr)
 	tstrHostIFmsg strHostIFmsg;
 	tstrHostIFDelSta *pstrDelStationMsg = &strHostIFmsg.uniHostIFmsgBody.strDelStaParam;
 
-	if (pstrWFIDrv == NULL) {
+	if (pstrWFIDrv == NULL)
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
-	}
 
 	WILC_memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
 
@@ -7341,9 +7269,8 @@ s32 host_int_del_station(WILC_WFIDrvHandle hWFIDrv, const u8 *pu8MacAddr)
 		WILC_memcpy(pstrDelStationMsg->au8MacAddr, pu8MacAddr, ETH_ALEN);
 
 	s32Error = WILC_MsgQueueSend(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg), NULL);
-	if (s32Error) {
+	if (s32Error)
 		WILC_ERRORREPORT(s32Error, s32Error);
-	}
 
 	WILC_CATCH(s32Error)
 	{
@@ -7370,9 +7297,8 @@ s32 host_int_del_allstation(WILC_WFIDrvHandle hWFIDrv, u8 pu8MacAddr[][ETH_ALEN]
 	u8 u8AssocNumb = 0;
 
 
-	if (pstrWFIDrv == NULL) {
+	if (pstrWFIDrv == NULL)
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
-	}
 
 	WILC_memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
 
@@ -7400,10 +7326,9 @@ s32 host_int_del_allstation(WILC_WFIDrvHandle hWFIDrv, u8 pu8MacAddr[][ETH_ALEN]
 	s32Error = WILC_MsgQueueSend(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg), NULL);
 
 
-	if (s32Error) {
+	if (s32Error)
 		WILC_ERRORREPORT(s32Error, s32Error);
 
-	}
 	WILC_CATCH(s32Error)
 	{
 
@@ -7430,9 +7355,8 @@ s32 host_int_edit_station(WILC_WFIDrvHandle hWFIDrv, tstrWILC_AddStaParam *pstrS
 	tstrHostIFmsg strHostIFmsg;
 	tstrWILC_AddStaParam *pstrAddStationMsg = &strHostIFmsg.uniHostIFmsgBody.strAddStaParam;
 
-	if (pstrWFIDrv == NULL) {
+	if (pstrWFIDrv == NULL)
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
-	}
 
 	PRINT_D(HOSTINF_DBG, "Setting editing station message queue params\n");
 
@@ -7452,9 +7376,8 @@ s32 host_int_edit_station(WILC_WFIDrvHandle hWFIDrv, tstrWILC_AddStaParam *pstrS
 	}
 
 	s32Error = WILC_MsgQueueSend(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg), NULL);
-	if (s32Error) {
+	if (s32Error)
 		WILC_ERRORREPORT(s32Error, s32Error);
-	}
 	WILC_CATCH(s32Error)
 	{
 	}
@@ -7472,9 +7395,8 @@ s32 host_int_set_power_mgmt(WILC_WFIDrvHandle hWFIDrv, bool bIsEnabled, u32 u32T
 
 	PRINT_INFO(HOSTINF_DBG, "\n\n>> Setting PS to %d << \n\n", bIsEnabled);
 
-	if (pstrWFIDrv == NULL) {
+	if (pstrWFIDrv == NULL)
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
-	}
 
 	PRINT_D(HOSTINF_DBG, "Setting Power management message queue params\n");
 
@@ -7490,9 +7412,8 @@ s32 host_int_set_power_mgmt(WILC_WFIDrvHandle hWFIDrv, bool bIsEnabled, u32 u32T
 
 
 	s32Error = WILC_MsgQueueSend(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg), NULL);
-	if (s32Error) {
+	if (s32Error)
 		WILC_ERRORREPORT(s32Error, s32Error);
-	}
 	WILC_CATCH(s32Error)
 	{
 	}
@@ -7508,9 +7429,8 @@ s32 host_int_setup_multicast_filter(WILC_WFIDrvHandle hWFIDrv, bool bIsEnabled,
 	tstrHostIFSetMulti *pstrMulticastFilterParam = &strHostIFmsg.uniHostIFmsgBody.strHostIfSetMulti;
 
 
-	if (pstrWFIDrv == NULL) {
+	if (pstrWFIDrv == NULL)
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
-	}
 
 	PRINT_D(HOSTINF_DBG, "Setting Multicast Filter params\n");
 
@@ -7525,9 +7445,8 @@ s32 host_int_setup_multicast_filter(WILC_WFIDrvHandle hWFIDrv, bool bIsEnabled,
 	pstrMulticastFilterParam->u32count = u32count;
 
 	s32Error = WILC_MsgQueueSend(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg), NULL);
-	if (s32Error) {
+	if (s32Error)
 		WILC_ERRORREPORT(s32Error, s32Error);
-	}
 	WILC_CATCH(s32Error)
 	{
 	}
@@ -7633,9 +7552,8 @@ static void *host_int_ParseJoinBssParam(tstrNetworkInfo *ptstrNetworkInfo)
 				pNewJoinBssParam->wmm_cap = true;
 
 				/* Check if Bit 7 is set indicating U-APSD capability */
-				if (pu8IEs[index + 8] & (1 << 7)) {
+				if (pu8IEs[index + 8] & (1 << 7))
 					pNewJoinBssParam->uapsd_cap = true;
-				}
 				index += pu8IEs[index + 1] + 2;
 				continue;
 			}
@@ -7779,9 +7697,8 @@ static int host_int_addBASession(WILC_WFIDrvHandle hWFIDrv, char *pBSSID, char T
 	tstrHostIFmsg strHostIFmsg;
 	tstrHostIfBASessionInfo *pBASessionInfo = &strHostIFmsg.uniHostIFmsgBody.strHostIfBASessionInfo;
 
-	if (pstrWFIDrv == NULL) {
+	if (pstrWFIDrv == NULL)
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
-	}
 
 	WILC_memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
 
@@ -7795,9 +7712,8 @@ static int host_int_addBASession(WILC_WFIDrvHandle hWFIDrv, char *pBSSID, char T
 	strHostIFmsg.drvHandler = hWFIDrv;
 
 	s32Error = WILC_MsgQueueSend(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg), NULL);
-	if (s32Error) {
+	if (s32Error)
 		WILC_ERRORREPORT(s32Error, s32Error);
-	}
 	WILC_CATCH(s32Error)
 	{
 
@@ -7814,9 +7730,8 @@ s32 host_int_delBASession(WILC_WFIDrvHandle hWFIDrv, char *pBSSID, char TID)
 	tstrHostIFmsg strHostIFmsg;
 	tstrHostIfBASessionInfo *pBASessionInfo = &strHostIFmsg.uniHostIFmsgBody.strHostIfBASessionInfo;
 
-	if (pstrWFIDrv == NULL) {
+	if (pstrWFIDrv == NULL)
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
-	}
 
 	WILC_memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
 
@@ -7828,9 +7743,8 @@ s32 host_int_delBASession(WILC_WFIDrvHandle hWFIDrv, char *pBSSID, char TID)
 	strHostIFmsg.drvHandler = hWFIDrv;
 
 	s32Error = WILC_MsgQueueSend(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg), NULL);
-	if (s32Error) {
+	if (s32Error)
 		WILC_ERRORREPORT(s32Error, s32Error);
-	}
 	WILC_CATCH(s32Error)
 	{
 
@@ -7849,9 +7763,8 @@ s32 host_int_del_All_Rx_BASession(WILC_WFIDrvHandle hWFIDrv, char *pBSSID, char
 	tstrHostIFmsg strHostIFmsg;
 	tstrHostIfBASessionInfo *pBASessionInfo = &strHostIFmsg.uniHostIFmsgBody.strHostIfBASessionInfo;
 
-	if (pstrWFIDrv == NULL) {
+	if (pstrWFIDrv == NULL)
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
-	}
 
 	WILC_memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
 
@@ -7863,9 +7776,8 @@ s32 host_int_del_All_Rx_BASession(WILC_WFIDrvHandle hWFIDrv, char *pBSSID, char
 	strHostIFmsg.drvHandler = hWFIDrv;
 
 	s32Error = WILC_MsgQueueSend(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg), NULL);
-	if (s32Error) {
+	if (s32Error)
 		WILC_ERRORREPORT(s32Error, s32Error);
-	}
 	WILC_CATCH(s32Error)
 	{
 
@@ -7894,9 +7806,8 @@ s32 host_int_setup_ipaddress(WILC_WFIDrvHandle hWFIDrv, u8 *u16ipadd, u8 idx)
 	/* TODO: Enable This feature on softap firmware */
 	return 0;
 
-	if (pstrWFIDrv == NULL) {
+	if (pstrWFIDrv == NULL)
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
-	}
 
 	WILC_memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
 
@@ -7908,9 +7819,8 @@ s32 host_int_setup_ipaddress(WILC_WFIDrvHandle hWFIDrv, u8 *u16ipadd, u8 idx)
 	strHostIFmsg.uniHostIFmsgBody.strHostIfSetIP.idx = idx;
 
 	s32Error = WILC_MsgQueueSend(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg), NULL);
-	if (s32Error) {
+	if (s32Error)
 		WILC_ERRORREPORT(s32Error, s32Error);
-	}
 	WILC_CATCH(s32Error)
 	{
 
@@ -7935,9 +7845,8 @@ s32 host_int_get_ipaddress(WILC_WFIDrvHandle hWFIDrv, u8 *u16ipadd, u8 idx)
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	tstrHostIFmsg strHostIFmsg;
 
-	if (pstrWFIDrv == NULL) {
+	if (pstrWFIDrv == NULL)
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
-	}
 
 	WILC_memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
 
@@ -7949,9 +7858,8 @@ s32 host_int_get_ipaddress(WILC_WFIDrvHandle hWFIDrv, u8 *u16ipadd, u8 idx)
 	strHostIFmsg.uniHostIFmsgBody.strHostIfSetIP.idx = idx;
 
 	s32Error = WILC_MsgQueueSend(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg), NULL);
-	if (s32Error) {
+	if (s32Error)
 		WILC_ERRORREPORT(s32Error, s32Error);
-	}
 	WILC_CATCH(s32Error)
 	{
 
-- 
2.1.4

