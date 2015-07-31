Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:44130 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994AbbGaHjL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2015 03:39:11 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <austin.shin@atmel.com>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<jude.lee@atmel.com>, <robin.hwang@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 02/28] staging: wilc1000: change void type of argument with WILC_WFIDrvHandle
Date: Fri, 31 Jul 2015 16:38:10 +0900
Message-ID: <1438328316-30197-3-git-send-email-tony.cho@atmel.com> (sfid-20150731_093915_003180_4FB29232)
In-Reply-To: <1438328316-30197-1-git-send-email-tony.cho@atmel.com>
References: <1438328316-30197-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: glen lee <glen.lee@atmel.com>

This patch changes void pointer type of parameter with WILC_WFIDrvHandle type
in all functions which take drvHandler in tstrHostIFmsg as a function argument
since the type of drvHandler in tstrHostIFmsg was changed with WILC_WFIDrvHandle.

Signed-off-by: glen lee <glen.lee@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 74 +++++++++++++++----------------
 drivers/staging/wilc1000/host_interface.h |  2 +-
 2 files changed, 38 insertions(+), 38 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index fb4194a..68762d2 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -602,7 +602,7 @@ extern int linux_wlan_get_num_conn_ifcs(void);
  *  @date
  *  @version	1.0
  */
-static s32 Handle_SetChannel(void *drvHandler, tstrHostIFSetChan *pstrHostIFSetChan)
+static s32 Handle_SetChannel(WILC_WFIDrvHandle drvHandler, tstrHostIFSetChan *pstrHostIFSetChan)
 {
 
 	s32 s32Error = WILC_SUCCESS;
@@ -682,7 +682,7 @@ static s32 Handle_SetWfiDrvHandler(tstrHostIfSetDrvHandler *pstrHostIfSetDrvHand
  *  @date
  *  @version	1.0
  */
-static s32 Handle_SetOperationMode(void *drvHandler, tstrHostIfSetOperationMode *pstrHostIfSetOperationMode)
+static s32 Handle_SetOperationMode(WILC_WFIDrvHandle drvHandler, tstrHostIfSetOperationMode *pstrHostIfSetOperationMode)
 {
 
 	s32 s32Error = WILC_SUCCESS;
@@ -727,7 +727,7 @@ static s32 Handle_SetOperationMode(void *drvHandler, tstrHostIfSetOperationMode
  *  @date
  *  @version	1.0
  */
-s32 Handle_set_IPAddress(void *drvHandler, u8 *pu8IPAddr, u8 idx)
+s32 Handle_set_IPAddress(WILC_WFIDrvHandle drvHandler, u8 *pu8IPAddr, u8 idx)
 {
 
 	s32 s32Error = WILC_SUCCESS;
@@ -779,7 +779,7 @@ s32 Handle_set_IPAddress(void *drvHandler, u8 *pu8IPAddr, u8 idx)
  *  @date
  *  @version	1.0
  */
-s32 Handle_get_IPAddress(void *drvHandler, u8 *pu8IPAddr, u8 idx)
+s32 Handle_get_IPAddress(WILC_WFIDrvHandle drvHandler, u8 *pu8IPAddr, u8 idx)
 {
 
 	s32 s32Error = WILC_SUCCESS;
@@ -832,7 +832,7 @@ s32 Handle_get_IPAddress(void *drvHandler, u8 *pu8IPAddr, u8 idx)
  *  @date		November 2013
  *  @version	7.0
  */
-static s32 Handle_SetMacAddress(void *drvHandler, tstrHostIfSetMacAddress *pstrHostIfSetMacAddress)
+static s32 Handle_SetMacAddress(WILC_WFIDrvHandle drvHandler, tstrHostIfSetMacAddress *pstrHostIfSetMacAddress)
 {
 
 	s32 s32Error = WILC_SUCCESS;
@@ -878,7 +878,7 @@ static s32 Handle_SetMacAddress(void *drvHandler, tstrHostIfSetMacAddress *pstrH
  *  @date		JAN 2013
  *  @version	8.0
  */
-static s32 Handle_GetMacAddress(void *drvHandler, tstrHostIfGetMacAddress *pstrHostIfGetMacAddress)
+static s32 Handle_GetMacAddress(WILC_WFIDrvHandle drvHandler, tstrHostIfGetMacAddress *pstrHostIfGetMacAddress)
 {
 
 	s32 s32Error = WILC_SUCCESS;
@@ -915,7 +915,7 @@ static s32 Handle_GetMacAddress(void *drvHandler, tstrHostIfGetMacAddress *pstrH
  *  @date
  *  @version	1.0
  */
-static s32 Handle_CfgParam(void *drvHandler, tstrHostIFCfgParamAttr *strHostIFCfgParamAttr)
+static s32 Handle_CfgParam(WILC_WFIDrvHandle drvHandler, tstrHostIFCfgParamAttr *strHostIFCfgParamAttr)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWID strWIDList[32];
@@ -1239,7 +1239,7 @@ static s32 Handle_wait_msg_q_empty(void)
  *  @date
  *  @version	1.0
  */
-static s32 Handle_Scan(void *drvHandler, tstrHostIFscanAttr *pstrHostIFscanAttr)
+static s32 Handle_Scan(WILC_WFIDrvHandle drvHandler, tstrHostIFscanAttr *pstrHostIFscanAttr)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWID strWIDList[5];
@@ -1410,7 +1410,7 @@ static s32 Handle_Scan(void *drvHandler, tstrHostIFscanAttr *pstrHostIFscanAttr)
  *  @date
  *  @version	1.0
  */
-static s32 Handle_ScanDone(void *drvHandler, tenuScanEvent enuEvent)
+static s32 Handle_ScanDone(WILC_WFIDrvHandle drvHandler, tenuScanEvent enuEvent)
 {
 	s32 s32Error = WILC_SUCCESS;
 
@@ -1470,7 +1470,7 @@ static s32 Handle_ScanDone(void *drvHandler, tenuScanEvent enuEvent)
  *  @version	1.0
  */
 u8 u8ConnectedSSID[6] = {0};
-static s32 Handle_Connect(void *drvHandler, tstrHostIFconnectAttr *pstrHostIFconnectAttr)
+static s32 Handle_Connect(WILC_WFIDrvHandle drvHandler, tstrHostIFconnectAttr *pstrHostIFconnectAttr)
 {
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *) drvHandler;
 	s32 s32Error = WILC_SUCCESS;
@@ -2039,7 +2039,7 @@ static s32 Handle_Connect(void *drvHandler, tstrHostIFconnectAttr *pstrHostIFcon
  *  @version		8.0
  */
 
-static s32 Handle_FlushConnect(void *drvHandler)
+static s32 Handle_FlushConnect(WILC_WFIDrvHandle drvHandler)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWID strWIDList[5];
@@ -2106,7 +2106,7 @@ static s32 Handle_FlushConnect(void *drvHandler)
  *  @date
  *  @version	1.0
  */
-static s32 Handle_ConnectTimeout(void *drvHandler)
+static s32 Handle_ConnectTimeout(WILC_WFIDrvHandle drvHandler)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrConnectInfo strConnectInfo;
@@ -2214,7 +2214,7 @@ static s32 Handle_ConnectTimeout(void *drvHandler)
  *  @date
  *  @version	1.0
  */
-static s32 Handle_RcvdNtwrkInfo(void *drvHandler, tstrRcvdNetworkInfo *pstrRcvdNetworkInfo)
+static s32 Handle_RcvdNtwrkInfo(WILC_WFIDrvHandle drvHandler, tstrRcvdNetworkInfo *pstrRcvdNetworkInfo)
 {
 	u32 i;
 	bool bNewNtwrkFound;
@@ -2336,7 +2336,7 @@ done:
  *  @date
  *  @version	1.0
  */
-static s32 Handle_RcvdGnrlAsyncInfo(void *drvHandler, tstrRcvdGnrlAsyncInfo *pstrRcvdGnrlAsyncInfo)
+static s32 Handle_RcvdGnrlAsyncInfo(WILC_WFIDrvHandle drvHandler, tstrRcvdGnrlAsyncInfo *pstrRcvdGnrlAsyncInfo)
 {
 	/* TODO: mostafa: till now, this function just handles only the received mac status msg, */
 	/*				 which carries only 1 WID which have WID ID = WID_STATUS */
@@ -2666,7 +2666,7 @@ static s32 Handle_RcvdGnrlAsyncInfo(void *drvHandler, tstrRcvdGnrlAsyncInfo *pst
  *  @date
  *  @version	1.0
  */
-static int Handle_Key(void *drvHandler, tstrHostIFkeyAttr *pstrHostIFkeyAttr)
+static int Handle_Key(WILC_WFIDrvHandle drvHandler, tstrHostIFkeyAttr *pstrHostIFkeyAttr)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWID strWID;
@@ -3029,7 +3029,7 @@ _WPAPtk_end_case_:
  *  @date
  *  @version	1.0
  */
-static void Handle_Disconnect(void *drvHandler)
+static void Handle_Disconnect(WILC_WFIDrvHandle drvHandler)
 {
 	tstrWID strWID;
 
@@ -3142,7 +3142,7 @@ static void Handle_Disconnect(void *drvHandler)
 }
 
 
-void resolve_disconnect_aberration(void *drvHandler)
+void resolve_disconnect_aberration(WILC_WFIDrvHandle drvHandler)
 {
 	tstrWILC_WFIDrv *pstrWFIDrv;
 
@@ -3154,7 +3154,7 @@ void resolve_disconnect_aberration(void *drvHandler)
 		host_int_disconnect((WILC_WFIDrvHandle)pstrWFIDrv, 1);
 	}
 }
-static s32 Switch_Log_Terminal(void *drvHandler)
+static s32 Switch_Log_Terminal(WILC_WFIDrvHandle drvHandler)
 {
 
 
@@ -3198,7 +3198,7 @@ static s32 Switch_Log_Terminal(void *drvHandler)
  *  @date
  *  @version	1.0
  */
-static s32 Handle_GetChnl(void *drvHandler)
+static s32 Handle_GetChnl(WILC_WFIDrvHandle drvHandler)
 {
 
 	s32 s32Error = WILC_SUCCESS;
@@ -3243,7 +3243,7 @@ static s32 Handle_GetChnl(void *drvHandler)
  *  @date
  *  @version	1.0
  */
-static void Handle_GetRssi(void *drvHandler)
+static void Handle_GetRssi(WILC_WFIDrvHandle drvHandler)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWID strWID;
@@ -3273,7 +3273,7 @@ static void Handle_GetRssi(void *drvHandler)
 }
 
 
-static void Handle_GetLinkspeed(void *drvHandler)
+static void Handle_GetLinkspeed(WILC_WFIDrvHandle drvHandler)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWID strWID;
@@ -3303,7 +3303,7 @@ static void Handle_GetLinkspeed(void *drvHandler)
 
 }
 
-s32 Handle_GetStatistics(void *drvHandler, tstrStatistics *pstrStatistics)
+s32 Handle_GetStatistics(WILC_WFIDrvHandle drvHandler, tstrStatistics *pstrStatistics)
 {
 	tstrWID strWIDList[5];
 	uint32_t u32WidsCount = 0, s32Error = 0;
@@ -3364,7 +3364,7 @@ s32 Handle_GetStatistics(void *drvHandler, tstrStatistics *pstrStatistics)
  *  @date
  *  @version	1.0
  */
-static s32 Handle_Get_InActiveTime(void *drvHandler, tstrHostIfStaInactiveT *strHostIfStaInactiveT)
+static s32 Handle_Get_InActiveTime(WILC_WFIDrvHandle drvHandler, tstrHostIfStaInactiveT *strHostIfStaInactiveT)
 {
 
 	s32 s32Error = WILC_SUCCESS;
@@ -3433,7 +3433,7 @@ static s32 Handle_Get_InActiveTime(void *drvHandler, tstrHostIfStaInactiveT *str
  *  @date
  *  @version	1.0
  */
-static void Handle_AddBeacon(void *drvHandler, tstrHostIFSetBeacon *pstrSetBeaconParam)
+static void Handle_AddBeacon(WILC_WFIDrvHandle drvHandler, tstrHostIFSetBeacon *pstrSetBeaconParam)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWID strWID;
@@ -3505,7 +3505,7 @@ static void Handle_AddBeacon(void *drvHandler, tstrHostIFSetBeacon *pstrSetBeaco
  *  @date
  *  @version	1.0
  */
-static void Handle_DelBeacon(void *drvHandler, tstrHostIFDelBeacon *pstrDelBeacon)
+static void Handle_DelBeacon(WILC_WFIDrvHandle drvHandler, tstrHostIFDelBeacon *pstrDelBeacon)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWID strWID;
@@ -3602,7 +3602,7 @@ static u32 WILC_HostIf_PackStaParam(u8 *pu8Buffer, tstrWILC_AddStaParam *pstrSta
  *  @date
  *  @version	1.0
  */
-static void Handle_AddStation(void *drvHandler, tstrWILC_AddStaParam *pstrStationParam)
+static void Handle_AddStation(WILC_WFIDrvHandle drvHandler, tstrWILC_AddStaParam *pstrStationParam)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWID strWID;
@@ -3645,7 +3645,7 @@ static void Handle_AddStation(void *drvHandler, tstrWILC_AddStaParam *pstrStatio
  *  @date
  *  @version	1.0
  */
-static void Handle_DelAllSta(void *drvHandler, tstrHostIFDelAllSta *pstrDelAllStaParam)
+static void Handle_DelAllSta(WILC_WFIDrvHandle drvHandler, tstrHostIFDelAllSta *pstrDelAllStaParam)
 {
 	s32 s32Error = WILC_SUCCESS;
 
@@ -3704,7 +3704,7 @@ static void Handle_DelAllSta(void *drvHandler, tstrHostIFDelAllSta *pstrDelAllSt
  *  @date
  *  @version	1.0
  */
-static void Handle_DelStation(void *drvHandler, tstrHostIFDelSta *pstrDelStaParam)
+static void Handle_DelStation(WILC_WFIDrvHandle drvHandler, tstrHostIFDelSta *pstrDelStaParam)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWID strWID;
@@ -3749,7 +3749,7 @@ static void Handle_DelStation(void *drvHandler, tstrHostIFDelSta *pstrDelStaPara
  *  @date
  *  @version	1.0
  */
-static void Handle_EditStation(void *drvHandler, tstrWILC_AddStaParam *pstrStationParam)
+static void Handle_EditStation(WILC_WFIDrvHandle drvHandler, tstrWILC_AddStaParam *pstrStationParam)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWID strWID;
@@ -3794,7 +3794,7 @@ static void Handle_EditStation(void *drvHandler, tstrWILC_AddStaParam *pstrStati
  *  @date
  *  @version	1.0
  */
-static int Handle_RemainOnChan(void *drvHandler, tstrHostIfRemainOnChan *pstrHostIfRemainOnChan)
+static int Handle_RemainOnChan(WILC_WFIDrvHandle drvHandler, tstrHostIfRemainOnChan *pstrHostIfRemainOnChan)
 {
 	s32 s32Error = WILC_SUCCESS;
 	u8 u8remain_on_chan_flag;
@@ -3873,7 +3873,7 @@ static int Handle_RemainOnChan(void *drvHandler, tstrHostIfRemainOnChan *pstrHos
  *  @date
  *  @version	1.0
  */
-static int Handle_RegisterFrame(void *drvHandler, tstrHostIfRegisterFrame *pstrHostIfRegisterFrame)
+static int Handle_RegisterFrame(WILC_WFIDrvHandle drvHandler, tstrHostIfRegisterFrame *pstrHostIfRegisterFrame)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWID strWID;
@@ -3925,7 +3925,7 @@ static int Handle_RegisterFrame(void *drvHandler, tstrHostIfRegisterFrame *pstrH
  *  @version		1.0
  */
 #define FALSE_FRMWR_CHANNEL 100
-static u32 Handle_ListenStateExpired(void *drvHandler, tstrHostIfRemainOnChan *pstrHostIfRemainOnChan)
+static u32 Handle_ListenStateExpired(WILC_WFIDrvHandle drvHandler, tstrHostIfRemainOnChan *pstrHostIfRemainOnChan)
 {
 	u8 u8remain_on_chan_flag;
 	tstrWID strWID;
@@ -4016,7 +4016,7 @@ static void ListenTimerCB(void *pvArg)
  *  @date
  *  @version	1.0
  */
-static void Handle_PowerManagement(void *drvHandler, tstrHostIfPowerMgmtParam *strPowerMgmtParam)
+static void Handle_PowerManagement(WILC_WFIDrvHandle drvHandler, tstrHostIfPowerMgmtParam *strPowerMgmtParam)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWID strWID;
@@ -4058,7 +4058,7 @@ static void Handle_PowerManagement(void *drvHandler, tstrHostIfPowerMgmtParam *s
  *  @date
  *  @version	1.0
  */
-static void Handle_SetMulticastFilter(void *drvHandler, tstrHostIFSetMulti *strHostIfSetMulti)
+static void Handle_SetMulticastFilter(WILC_WFIDrvHandle drvHandler, tstrHostIFSetMulti *strHostIfSetMulti)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWID strWID;
@@ -4112,7 +4112,7 @@ static void Handle_SetMulticastFilter(void *drvHandler, tstrHostIFSetMulti *strH
  *  @date			Feb. 2014
  *  @version		9.0
  */
-static s32 Handle_AddBASession(void *drvHandler, tstrHostIfBASessionInfo *strHostIfBASessionInfo)
+static s32 Handle_AddBASession(WILC_WFIDrvHandle drvHandler, tstrHostIfBASessionInfo *strHostIfBASessionInfo)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWID strWID;
@@ -4200,7 +4200,7 @@ static s32 Handle_AddBASession(void *drvHandler, tstrHostIfBASessionInfo *strHos
  *  @date			Feb. 2013
  *  @version		9.0
  */
-static s32 Handle_DelBASession(void *drvHandler, tstrHostIfBASessionInfo *strHostIfBASessionInfo)
+static s32 Handle_DelBASession(WILC_WFIDrvHandle drvHandler, tstrHostIfBASessionInfo *strHostIfBASessionInfo)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWID strWID;
@@ -4270,7 +4270,7 @@ static s32 Handle_DelBASession(void *drvHandler, tstrHostIfBASessionInfo *strHos
  *  @date			Feb. 2013
  *  @version		9.0
  */
-static s32 Handle_DelAllRxBASessions(void *drvHandler, tstrHostIfBASessionInfo *strHostIfBASessionInfo)
+static s32 Handle_DelAllRxBASessions(WILC_WFIDrvHandle drvHandler, tstrHostIfBASessionInfo *strHostIfBASessionInfo)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWID strWID;
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index cdfb43a..7699650 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -1262,7 +1262,7 @@ s32 host_int_frame_register(WILC_WFIDrvHandle hWFIDrv, u16 u16FrameType, bool bR
 s32 host_int_set_wfi_drv_handler(u32 u32address);
 s32 host_int_set_operation_mode(WILC_WFIDrvHandle hWFIDrv, u32 u32mode);
 
-static s32 Handle_ScanDone(void *drvHandler, tenuScanEvent enuEvent);
+static s32 Handle_ScanDone(WILC_WFIDrvHandle drvHandler, tenuScanEvent enuEvent);
 
 static int host_int_addBASession(WILC_WFIDrvHandle hWFIDrv, char *pBSSID, char TID, short int BufferSize,
 				 short int SessionTimeout, void *drvHandler);
-- 
1.9.1

