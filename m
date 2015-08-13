Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:38037 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372AbbHMEmA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2015 00:42:00 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <jude.lee@atmel.com>, <robin.hwang@atmel.com>
Subject: [PATCH 3/5] staging: wilc1000: clarify the argument type
Date: Thu, 13 Aug 2015 13:41:21 +0900
Message-ID: <1439440883-16061-4-git-send-email-tony.cho@atmel.com> (sfid-20150813_064204_379384_309EAEFC)
In-Reply-To: <1439440883-16061-1-git-send-email-tony.cho@atmel.com>
References: <1439440883-16061-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johnny Kim <johnny.kim@atmel.com>

This patch replaces the void pointer type in the host interface
functions which process the message from host thread by the real data
type, tstrWILC_WFIDrv because the void pointer type as the arguments
is not clear and concise. In addition, typecasting to the void pointer
type is removed becasue it is not necessary.

Signed-off-by: Johnny Kim <johnny.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 78 +++++++++++++++----------------
 drivers/staging/wilc1000/host_interface.h |  4 +-
 2 files changed, 41 insertions(+), 41 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index b5afc82..1c2d924 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -601,7 +601,7 @@ extern int linux_wlan_get_num_conn_ifcs(void);
  *  @date
  *  @version	1.0
  */
-static s32 Handle_SetChannel(void *drvHandler, tstrHostIFSetChan *pstrHostIFSetChan)
+static s32 Handle_SetChannel(tstrWILC_WFIDrv *drvHandler, tstrHostIFSetChan *pstrHostIFSetChan)
 {
 
 	s32 s32Error = WILC_SUCCESS;
@@ -681,7 +681,7 @@ static s32 Handle_SetWfiDrvHandler(tstrHostIfSetDrvHandler *pstrHostIfSetDrvHand
  *  @date
  *  @version	1.0
  */
-static s32 Handle_SetOperationMode(void *drvHandler, tstrHostIfSetOperationMode *pstrHostIfSetOperationMode)
+static s32 Handle_SetOperationMode(tstrWILC_WFIDrv *drvHandler, tstrHostIfSetOperationMode *pstrHostIfSetOperationMode)
 {
 
 	s32 s32Error = WILC_SUCCESS;
@@ -726,7 +726,7 @@ static s32 Handle_SetOperationMode(void *drvHandler, tstrHostIfSetOperationMode
  *  @date
  *  @version	1.0
  */
-s32 Handle_set_IPAddress(void *drvHandler, u8 *pu8IPAddr, u8 idx)
+s32 Handle_set_IPAddress(tstrWILC_WFIDrv *drvHandler, u8 *pu8IPAddr, u8 idx)
 {
 
 	s32 s32Error = WILC_SUCCESS;
@@ -778,7 +778,7 @@ s32 Handle_set_IPAddress(void *drvHandler, u8 *pu8IPAddr, u8 idx)
  *  @date
  *  @version	1.0
  */
-s32 Handle_get_IPAddress(void *drvHandler, u8 *pu8IPAddr, u8 idx)
+s32 Handle_get_IPAddress(tstrWILC_WFIDrv *drvHandler, u8 *pu8IPAddr, u8 idx)
 {
 
 	s32 s32Error = WILC_SUCCESS;
@@ -831,7 +831,7 @@ s32 Handle_get_IPAddress(void *drvHandler, u8 *pu8IPAddr, u8 idx)
  *  @date		November 2013
  *  @version	7.0
  */
-static s32 Handle_SetMacAddress(void *drvHandler, tstrHostIfSetMacAddress *pstrHostIfSetMacAddress)
+static s32 Handle_SetMacAddress(tstrWILC_WFIDrv *drvHandler, tstrHostIfSetMacAddress *pstrHostIfSetMacAddress)
 {
 
 	s32 s32Error = WILC_SUCCESS;
@@ -877,7 +877,7 @@ static s32 Handle_SetMacAddress(void *drvHandler, tstrHostIfSetMacAddress *pstrH
  *  @date		JAN 2013
  *  @version	8.0
  */
-static s32 Handle_GetMacAddress(void *drvHandler, tstrHostIfGetMacAddress *pstrHostIfGetMacAddress)
+static s32 Handle_GetMacAddress(tstrWILC_WFIDrv *drvHandler, tstrHostIfGetMacAddress *pstrHostIfGetMacAddress)
 {
 
 	s32 s32Error = WILC_SUCCESS;
@@ -914,7 +914,7 @@ static s32 Handle_GetMacAddress(void *drvHandler, tstrHostIfGetMacAddress *pstrH
  *  @date
  *  @version	1.0
  */
-static s32 Handle_CfgParam(void *drvHandler, tstrHostIFCfgParamAttr *strHostIFCfgParamAttr)
+static s32 Handle_CfgParam(tstrWILC_WFIDrv *drvHandler, tstrHostIFCfgParamAttr *strHostIFCfgParamAttr)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWID strWIDList[32];
@@ -1238,7 +1238,7 @@ static s32 Handle_wait_msg_q_empty(void)
  *  @date
  *  @version	1.0
  */
-static s32 Handle_Scan(void *drvHandler, tstrHostIFscanAttr *pstrHostIFscanAttr)
+static s32 Handle_Scan(tstrWILC_WFIDrv *drvHandler, tstrHostIFscanAttr *pstrHostIFscanAttr)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWID strWIDList[5];
@@ -1408,7 +1408,7 @@ static s32 Handle_Scan(void *drvHandler, tstrHostIFscanAttr *pstrHostIFscanAttr)
  *  @date
  *  @version	1.0
  */
-static s32 Handle_ScanDone(void *drvHandler, tenuScanEvent enuEvent)
+static s32 Handle_ScanDone(tstrWILC_WFIDrv *drvHandler, tenuScanEvent enuEvent)
 {
 	s32 s32Error = WILC_SUCCESS;
 
@@ -1468,7 +1468,7 @@ static s32 Handle_ScanDone(void *drvHandler, tenuScanEvent enuEvent)
  *  @version	1.0
  */
 u8 u8ConnectedSSID[6] = {0};
-static s32 Handle_Connect(void *drvHandler, tstrHostIFconnectAttr *pstrHostIFconnectAttr)
+static s32 Handle_Connect(tstrWILC_WFIDrv *drvHandler, tstrHostIFconnectAttr *pstrHostIFconnectAttr)
 {
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *) drvHandler;
 	s32 s32Error = WILC_SUCCESS;
@@ -2037,7 +2037,7 @@ static s32 Handle_Connect(void *drvHandler, tstrHostIFconnectAttr *pstrHostIFcon
  *  @version		8.0
  */
 
-static s32 Handle_FlushConnect(void *drvHandler)
+static s32 Handle_FlushConnect(tstrWILC_WFIDrv *drvHandler)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWID strWIDList[5];
@@ -2104,7 +2104,7 @@ static s32 Handle_FlushConnect(void *drvHandler)
  *  @date
  *  @version	1.0
  */
-static s32 Handle_ConnectTimeout(void *drvHandler)
+static s32 Handle_ConnectTimeout(tstrWILC_WFIDrv *drvHandler)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrConnectInfo strConnectInfo;
@@ -2212,7 +2212,7 @@ static s32 Handle_ConnectTimeout(void *drvHandler)
  *  @date
  *  @version	1.0
  */
-static s32 Handle_RcvdNtwrkInfo(void *drvHandler, tstrRcvdNetworkInfo *pstrRcvdNetworkInfo)
+static s32 Handle_RcvdNtwrkInfo(tstrWILC_WFIDrv *drvHandler, tstrRcvdNetworkInfo *pstrRcvdNetworkInfo)
 {
 	u32 i;
 	bool bNewNtwrkFound;
@@ -2334,7 +2334,7 @@ done:
  *  @date
  *  @version	1.0
  */
-static s32 Handle_RcvdGnrlAsyncInfo(void *drvHandler, tstrRcvdGnrlAsyncInfo *pstrRcvdGnrlAsyncInfo)
+static s32 Handle_RcvdGnrlAsyncInfo(tstrWILC_WFIDrv *drvHandler, tstrRcvdGnrlAsyncInfo *pstrRcvdGnrlAsyncInfo)
 {
 	/* TODO: mostafa: till now, this function just handles only the received mac status msg, */
 	/*				 which carries only 1 WID which have WID ID = WID_STATUS */
@@ -2635,7 +2635,7 @@ static s32 Handle_RcvdGnrlAsyncInfo(void *drvHandler, tstrRcvdGnrlAsyncInfo *pst
 			/*Abort the running scan*/
 			WILC_TimerStop(&(pstrWFIDrv->hScanTimer), NULL);
 			if (pstrWFIDrv->strWILC_UsrScanReq.pfUserScanResult)
-				Handle_ScanDone((void *)pstrWFIDrv, SCAN_EVENT_ABORTED);
+				Handle_ScanDone(pstrWFIDrv, SCAN_EVENT_ABORTED);
 
 		}
 
@@ -2664,7 +2664,7 @@ static s32 Handle_RcvdGnrlAsyncInfo(void *drvHandler, tstrRcvdGnrlAsyncInfo *pst
  *  @date
  *  @version	1.0
  */
-static int Handle_Key(void *drvHandler, tstrHostIFkeyAttr *pstrHostIFkeyAttr)
+static int Handle_Key(tstrWILC_WFIDrv *drvHandler, tstrHostIFkeyAttr *pstrHostIFkeyAttr)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWID strWID;
@@ -3026,7 +3026,7 @@ _WPAPtk_end_case_:
  *  @date
  *  @version	1.0
  */
-static void Handle_Disconnect(void *drvHandler)
+static void Handle_Disconnect(tstrWILC_WFIDrv *drvHandler)
 {
 	tstrWID strWID;
 
@@ -3139,7 +3139,7 @@ static void Handle_Disconnect(void *drvHandler)
 }
 
 
-void resolve_disconnect_aberration(void *drvHandler)
+void resolve_disconnect_aberration(tstrWILC_WFIDrv *drvHandler)
 {
 	tstrWILC_WFIDrv *pstrWFIDrv;
 
@@ -3151,7 +3151,7 @@ void resolve_disconnect_aberration(void *drvHandler)
 		host_int_disconnect(pstrWFIDrv, 1);
 	}
 }
-static s32 Switch_Log_Terminal(void *drvHandler)
+static s32 Switch_Log_Terminal(tstrWILC_WFIDrv *drvHandler)
 {
 
 
@@ -3195,7 +3195,7 @@ static s32 Switch_Log_Terminal(void *drvHandler)
  *  @date
  *  @version	1.0
  */
-static s32 Handle_GetChnl(void *drvHandler)
+static s32 Handle_GetChnl(tstrWILC_WFIDrv *drvHandler)
 {
 
 	s32 s32Error = WILC_SUCCESS;
@@ -3240,7 +3240,7 @@ static s32 Handle_GetChnl(void *drvHandler)
  *  @date
  *  @version	1.0
  */
-static void Handle_GetRssi(void *drvHandler)
+static void Handle_GetRssi(tstrWILC_WFIDrv *drvHandler)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWID strWID;
@@ -3270,7 +3270,7 @@ static void Handle_GetRssi(void *drvHandler)
 }
 
 
-static void Handle_GetLinkspeed(void *drvHandler)
+static void Handle_GetLinkspeed(tstrWILC_WFIDrv *drvHandler)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWID strWID;
@@ -3300,7 +3300,7 @@ static void Handle_GetLinkspeed(void *drvHandler)
 
 }
 
-s32 Handle_GetStatistics(void *drvHandler, tstrStatistics *pstrStatistics)
+s32 Handle_GetStatistics(tstrWILC_WFIDrv *drvHandler, tstrStatistics *pstrStatistics)
 {
 	tstrWID strWIDList[5];
 	uint32_t u32WidsCount = 0, s32Error = 0;
@@ -3361,7 +3361,7 @@ s32 Handle_GetStatistics(void *drvHandler, tstrStatistics *pstrStatistics)
  *  @date
  *  @version	1.0
  */
-static s32 Handle_Get_InActiveTime(void *drvHandler, tstrHostIfStaInactiveT *strHostIfStaInactiveT)
+static s32 Handle_Get_InActiveTime(tstrWILC_WFIDrv *drvHandler, tstrHostIfStaInactiveT *strHostIfStaInactiveT)
 {
 
 	s32 s32Error = WILC_SUCCESS;
@@ -3430,7 +3430,7 @@ static s32 Handle_Get_InActiveTime(void *drvHandler, tstrHostIfStaInactiveT *str
  *  @date
  *  @version	1.0
  */
-static void Handle_AddBeacon(void *drvHandler, tstrHostIFSetBeacon *pstrSetBeaconParam)
+static void Handle_AddBeacon(tstrWILC_WFIDrv *drvHandler, tstrHostIFSetBeacon *pstrSetBeaconParam)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWID strWID;
@@ -3502,7 +3502,7 @@ static void Handle_AddBeacon(void *drvHandler, tstrHostIFSetBeacon *pstrSetBeaco
  *  @date
  *  @version	1.0
  */
-static void Handle_DelBeacon(void *drvHandler, tstrHostIFDelBeacon *pstrDelBeacon)
+static void Handle_DelBeacon(tstrWILC_WFIDrv *drvHandler, tstrHostIFDelBeacon *pstrDelBeacon)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWID strWID;
@@ -3599,7 +3599,7 @@ static u32 WILC_HostIf_PackStaParam(u8 *pu8Buffer, tstrWILC_AddStaParam *pstrSta
  *  @date
  *  @version	1.0
  */
-static void Handle_AddStation(void *drvHandler, tstrWILC_AddStaParam *pstrStationParam)
+static void Handle_AddStation(tstrWILC_WFIDrv *drvHandler, tstrWILC_AddStaParam *pstrStationParam)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWID strWID;
@@ -3642,7 +3642,7 @@ static void Handle_AddStation(void *drvHandler, tstrWILC_AddStaParam *pstrStatio
  *  @date
  *  @version	1.0
  */
-static void Handle_DelAllSta(void *drvHandler, tstrHostIFDelAllSta *pstrDelAllStaParam)
+static void Handle_DelAllSta(tstrWILC_WFIDrv *drvHandler, tstrHostIFDelAllSta *pstrDelAllStaParam)
 {
 	s32 s32Error = WILC_SUCCESS;
 
@@ -3701,7 +3701,7 @@ static void Handle_DelAllSta(void *drvHandler, tstrHostIFDelAllSta *pstrDelAllSt
  *  @date
  *  @version	1.0
  */
-static void Handle_DelStation(void *drvHandler, tstrHostIFDelSta *pstrDelStaParam)
+static void Handle_DelStation(tstrWILC_WFIDrv *drvHandler, tstrHostIFDelSta *pstrDelStaParam)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWID strWID;
@@ -3746,7 +3746,7 @@ static void Handle_DelStation(void *drvHandler, tstrHostIFDelSta *pstrDelStaPara
  *  @date
  *  @version	1.0
  */
-static void Handle_EditStation(void *drvHandler, tstrWILC_AddStaParam *pstrStationParam)
+static void Handle_EditStation(tstrWILC_WFIDrv *drvHandler, tstrWILC_AddStaParam *pstrStationParam)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWID strWID;
@@ -3791,7 +3791,7 @@ static void Handle_EditStation(void *drvHandler, tstrWILC_AddStaParam *pstrStati
  *  @date
  *  @version	1.0
  */
-static int Handle_RemainOnChan(void *drvHandler, tstrHostIfRemainOnChan *pstrHostIfRemainOnChan)
+static int Handle_RemainOnChan(tstrWILC_WFIDrv *drvHandler, tstrHostIfRemainOnChan *pstrHostIfRemainOnChan)
 {
 	s32 s32Error = WILC_SUCCESS;
 	u8 u8remain_on_chan_flag;
@@ -3870,7 +3870,7 @@ static int Handle_RemainOnChan(void *drvHandler, tstrHostIfRemainOnChan *pstrHos
  *  @date
  *  @version	1.0
  */
-static int Handle_RegisterFrame(void *drvHandler, tstrHostIfRegisterFrame *pstrHostIfRegisterFrame)
+static int Handle_RegisterFrame(tstrWILC_WFIDrv *drvHandler, tstrHostIfRegisterFrame *pstrHostIfRegisterFrame)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWID strWID;
@@ -3922,7 +3922,7 @@ static int Handle_RegisterFrame(void *drvHandler, tstrHostIfRegisterFrame *pstrH
  *  @version		1.0
  */
 #define FALSE_FRMWR_CHANNEL 100
-static u32 Handle_ListenStateExpired(void *drvHandler, tstrHostIfRemainOnChan *pstrHostIfRemainOnChan)
+static u32 Handle_ListenStateExpired(tstrWILC_WFIDrv *drvHandler, tstrHostIfRemainOnChan *pstrHostIfRemainOnChan)
 {
 	u8 u8remain_on_chan_flag;
 	tstrWID strWID;
@@ -4013,7 +4013,7 @@ static void ListenTimerCB(void *pvArg)
  *  @date
  *  @version	1.0
  */
-static void Handle_PowerManagement(void *drvHandler, tstrHostIfPowerMgmtParam *strPowerMgmtParam)
+static void Handle_PowerManagement(tstrWILC_WFIDrv *drvHandler, tstrHostIfPowerMgmtParam *strPowerMgmtParam)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWID strWID;
@@ -4054,7 +4054,7 @@ static void Handle_PowerManagement(void *drvHandler, tstrHostIfPowerMgmtParam *s
  *  @date
  *  @version	1.0
  */
-static void Handle_SetMulticastFilter(void *drvHandler, tstrHostIFSetMulti *strHostIfSetMulti)
+static void Handle_SetMulticastFilter(tstrWILC_WFIDrv *drvHandler, tstrHostIFSetMulti *strHostIfSetMulti)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWID strWID;
@@ -4108,7 +4108,7 @@ static void Handle_SetMulticastFilter(void *drvHandler, tstrHostIFSetMulti *strH
  *  @date			Feb. 2014
  *  @version		9.0
  */
-static s32 Handle_AddBASession(void *drvHandler, tstrHostIfBASessionInfo *strHostIfBASessionInfo)
+static s32 Handle_AddBASession(tstrWILC_WFIDrv *drvHandler, tstrHostIfBASessionInfo *strHostIfBASessionInfo)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWID strWID;
@@ -4196,7 +4196,7 @@ static s32 Handle_AddBASession(void *drvHandler, tstrHostIfBASessionInfo *strHos
  *  @date			Feb. 2013
  *  @version		9.0
  */
-static s32 Handle_DelBASession(void *drvHandler, tstrHostIfBASessionInfo *strHostIfBASessionInfo)
+static s32 Handle_DelBASession(tstrWILC_WFIDrv *drvHandler, tstrHostIfBASessionInfo *strHostIfBASessionInfo)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWID strWID;
@@ -4266,7 +4266,7 @@ static s32 Handle_DelBASession(void *drvHandler, tstrHostIfBASessionInfo *strHos
  *  @date			Feb. 2013
  *  @version		9.0
  */
-static s32 Handle_DelAllRxBASessions(void *drvHandler, tstrHostIfBASessionInfo *strHostIfBASessionInfo)
+static s32 Handle_DelAllRxBASessions(tstrWILC_WFIDrv *drvHandler, tstrHostIfBASessionInfo *strHostIfBASessionInfo)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWID strWID;
@@ -7678,7 +7678,7 @@ void host_int_freeJoinParams(void *pJoinParams)
  *  @date
  *  @version		1.0**/
 
-static int host_int_addBASession(WILC_WFIDrvHandle hWFIDrv, char *pBSSID, char TID, short int BufferSize,
+static int host_int_addBASession(tstrWILC_WFIDrv *hWFIDrv, char *pBSSID, char TID, short int BufferSize,
 				 short int SessionTimeout, void *drvHandler)
 {
 	s32 s32Error = WILC_SUCCESS;
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 2d97e9f..5ac5563 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -1262,9 +1262,9 @@ s32 host_int_frame_register(tstrWILC_WFIDrv *hWFIDrv, u16 u16FrameType, bool bRe
 s32 host_int_set_wfi_drv_handler(tstrWILC_WFIDrv *u32address);
 s32 host_int_set_operation_mode(tstrWILC_WFIDrv *hWFIDrv, u32 u32mode);
 
-static s32 Handle_ScanDone(void *drvHandler, tenuScanEvent enuEvent);
+static s32 Handle_ScanDone(tstrWILC_WFIDrv *drvHandler, tenuScanEvent enuEvent);
 
-static int host_int_addBASession(WILC_WFIDrvHandle hWFIDrv, char *pBSSID, char TID, short int BufferSize,
+static int host_int_addBASession(tstrWILC_WFIDrv *hWFIDrv, char *pBSSID, char TID, short int BufferSize,
 				 short int SessionTimeout, void *drvHandler);
 
 
-- 
1.9.1

