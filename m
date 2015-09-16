Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:26932 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648AbbIPJgn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Sep 2015 05:36:43 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH v2 5/6] staging: wilc1000: replace wilc error types with the generic error types
Date: Wed, 16 Sep 2015 18:36:03 +0900
Message-ID: <1442396164-18728-6-git-send-email-tony.cho@atmel.com> (sfid-20150916_113647_796551_901D9B80)
In-Reply-To: <1442396164-18728-1-git-send-email-tony.cho@atmel.com>
References: <1442396164-18728-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch replaces the error types defined by wilc driver with the
generic error types provided by the Linux kernel.
- WILC_SUCCESS			0
- WILC_FAIL				-EFAULT
- WILC_BUSY				-EBUSY
- WILC_INVALID_ARGUMENT		-EINVAL
- WILC_INVALID_STATE		-EINVAL
- WILC_BUFFER_OVERFLOW		-EOVERFLOW
- WILC_NULL_PTR			-EFAULT
- WILC_TIMEOUT			-ETIMEDOUT
- WILC_NOT_FOUND			-ENOENT
- WILC_NO_MEM			-ENOMEM

After then removes all wilc definitions.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/coreconfigurator.c       |  24 +--
 drivers/staging/wilc1000/host_interface.c         | 238 +++++++++++-----------
 drivers/staging/wilc1000/linux_mon.c              |  14 +-
 drivers/staging/wilc1000/linux_wlan.c             |   2 +-
 drivers/staging/wilc1000/wilc_errorsupport.h      |  14 --
 drivers/staging/wilc1000/wilc_msgqueue.c          |   8 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c |  76 +++----
 7 files changed, 181 insertions(+), 195 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index 96358a9..aecaa03 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -340,7 +340,7 @@ INLINE u16 get_asoc_id(u8 *data)
 
 s32 CoreConfiguratorInit(void)
 {
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 
 	PRINT_D(CORECONFIG_DBG, "CoreConfiguratorInit()\n");
 
@@ -415,7 +415,7 @@ u8 get_current_channel(u8 *pu8msa, u16 u16RxLen)
  */
 s32 ParseNetworkInfo(u8 *pu8MsgBuffer, tstrNetworkInfo **ppstrNetworkInfo)
 {
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 	tstrNetworkInfo *pstrNetworkInfo = NULL;
 	u8 u8MsgType = 0;
 	u8 u8MsgID = 0;
@@ -541,21 +541,21 @@ s32 ParseNetworkInfo(u8 *pu8MsgBuffer, tstrNetworkInfo **ppstrNetworkInfo)
  */
 s32 DeallocateNetworkInfo(tstrNetworkInfo *pstrNetworkInfo)
 {
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 
 	if (pstrNetworkInfo != NULL) {
 		if (pstrNetworkInfo->pu8IEs != NULL) {
 			kfree(pstrNetworkInfo->pu8IEs);
 			pstrNetworkInfo->pu8IEs = NULL;
 		} else {
-			s32Error = WILC_FAIL;
+			s32Error = -EFAULT;
 		}
 
 		kfree(pstrNetworkInfo);
 		pstrNetworkInfo = NULL;
 
 	} else {
-		s32Error = WILC_FAIL;
+		s32Error = -EFAULT;
 	}
 
 	return s32Error;
@@ -575,7 +575,7 @@ s32 DeallocateNetworkInfo(tstrNetworkInfo *pstrNetworkInfo)
 s32 ParseAssocRespInfo(u8 *pu8Buffer, u32 u32BufferLen,
 			       tstrConnectRespInfo **ppstrConnectRespInfo)
 {
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 	tstrConnectRespInfo *pstrConnectRespInfo = NULL;
 	u16 u16AssocRespLen = 0;
 	u8 *pu8IEs = NULL;
@@ -632,21 +632,21 @@ s32 ParseAssocRespInfo(u8 *pu8Buffer, u32 u32BufferLen,
  */
 s32 DeallocateAssocRespInfo(tstrConnectRespInfo *pstrConnectRespInfo)
 {
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 
 	if (pstrConnectRespInfo != NULL) {
 		if (pstrConnectRespInfo->pu8RespIEs != NULL) {
 			kfree(pstrConnectRespInfo->pu8RespIEs);
 			pstrConnectRespInfo->pu8RespIEs = NULL;
 		} else {
-			s32Error = WILC_FAIL;
+			s32Error = -EFAULT;
 		}
 
 		kfree(pstrConnectRespInfo);
 		pstrConnectRespInfo = NULL;
 
 	} else {
-		s32Error = WILC_FAIL;
+		s32Error = -EFAULT;
 	}
 
 	return s32Error;
@@ -657,7 +657,7 @@ s32 ParseSurveyResults(u8 ppu8RcvdSiteSurveyResults[][MAX_SURVEY_RESULT_FRAG_SIZ
 			       wid_site_survey_reslts_s **ppstrSurveyResults,
 			       u32 *pu32SurveyResultsCount)
 {
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 	wid_site_survey_reslts_s *pstrSurveyResults = NULL;
 	u32 u32SurveyResultsCount = 0;
 	u32 u32SurveyBytesLength = 0;
@@ -712,7 +712,7 @@ ERRORHANDLER:
 
 s32 DeallocateSurveyResults(wid_site_survey_reslts_s *pstrSurveyResults)
 {
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 
 	if (pstrSurveyResults != NULL) {
 		kfree(pstrSurveyResults);
@@ -734,7 +734,7 @@ s32 DeallocateSurveyResults(wid_site_survey_reslts_s *pstrSurveyResults)
 
 s32 CoreConfiguratorDeInit(void)
 {
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 
 	PRINT_D(CORECONFIG_DBG, "CoreConfiguratorDeInit()\n");
 
diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 8c6de42..8d7a639 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -652,7 +652,7 @@ static tstrWILC_WFIDrv *get_handler_from_id(int id)
 static s32 Handle_SetChannel(tstrWILC_WFIDrv *drvHandler, tstrHostIFSetChan *pstrHostIFSetChan)
 {
 
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 	tstrWID	strWID;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
 
@@ -686,7 +686,7 @@ static s32 Handle_SetWfiDrvHandler(tstrWILC_WFIDrv *drvHandler,
 				   tstrHostIfSetDrvHandler *pstrHostIfSetDrvHandler)
 {
 
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 	tstrWID	strWID;
 	tstrWILC_WFIDrv *pstrWFIDrv = drvHandler;
 
@@ -726,7 +726,7 @@ static s32 Handle_SetWfiDrvHandler(tstrWILC_WFIDrv *drvHandler,
 static s32 Handle_SetOperationMode(tstrWILC_WFIDrv *drvHandler, tstrHostIfSetOperationMode *pstrHostIfSetOperationMode)
 {
 
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 	tstrWID	strWID;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
 
@@ -768,7 +768,7 @@ static s32 Handle_SetOperationMode(tstrWILC_WFIDrv *drvHandler, tstrHostIfSetOpe
 s32 Handle_set_IPAddress(tstrWILC_WFIDrv *drvHandler, u8 *pu8IPAddr, u8 idx)
 {
 
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 	tstrWID strWID;
 	char firmwareIPAddress[4] = {0};
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
@@ -815,7 +815,7 @@ s32 Handle_set_IPAddress(tstrWILC_WFIDrv *drvHandler, u8 *pu8IPAddr, u8 idx)
 s32 Handle_get_IPAddress(tstrWILC_WFIDrv *drvHandler, u8 *pu8IPAddr, u8 idx)
 {
 
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 	tstrWID strWID;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
 
@@ -838,7 +838,7 @@ s32 Handle_get_IPAddress(tstrWILC_WFIDrv *drvHandler, u8 *pu8IPAddr, u8 idx)
 	if (memcmp(gs8GetIP[idx], gs8SetIP[idx], IP_ALEN) != 0)
 		host_int_setup_ipaddress(pstrWFIDrv, gs8SetIP[idx], idx);
 
-	if (s32Error != WILC_SUCCESS) {
+	if (s32Error != 0) {
 		PRINT_ER("Failed to get IP address\n");
 		return -EINVAL;
 	}
@@ -864,14 +864,14 @@ s32 Handle_get_IPAddress(tstrWILC_WFIDrv *drvHandler, u8 *pu8IPAddr, u8 idx)
 static s32 Handle_SetMacAddress(tstrWILC_WFIDrv *drvHandler, tstrHostIfSetMacAddress *pstrHostIfSetMacAddress)
 {
 
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 	tstrWID	strWID;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
 	u8 *mac_buf = kmalloc(ETH_ALEN, GFP_KERNEL);
 
 	if (mac_buf == NULL) {
 		PRINT_ER("No buffer to send mac address\n");
-		return WILC_FAIL;
+		return -EFAULT;
 	}
 	memcpy(mac_buf, pstrHostIfSetMacAddress->u8MacAddress, ETH_ALEN);
 
@@ -907,7 +907,7 @@ static s32 Handle_SetMacAddress(tstrWILC_WFIDrv *drvHandler, tstrHostIfSetMacAdd
 static s32 Handle_GetMacAddress(tstrWILC_WFIDrv *drvHandler, tstrHostIfGetMacAddress *pstrHostIfGetMacAddress)
 {
 
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 	tstrWID	strWID;
 
 	/*prepare configuration packet*/
@@ -940,7 +940,7 @@ static s32 Handle_GetMacAddress(tstrWILC_WFIDrv *drvHandler, tstrHostIfGetMacAdd
  */
 static s32 Handle_CfgParam(tstrWILC_WFIDrv *drvHandler, tstrHostIFCfgParamAttr *strHostIFCfgParamAttr)
 {
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 	tstrWID strWIDList[32];
 	u8 u8WidCnt = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
@@ -1281,7 +1281,7 @@ ERRORHANDLER:
  */
 static s32 Handle_wait_msg_q_empty(void)
 {
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 
 	g_wilc_initialized = 0;
 	up(&hWaitResponse);
@@ -1299,7 +1299,7 @@ static s32 Handle_wait_msg_q_empty(void)
  */
 static s32 Handle_Scan(tstrWILC_WFIDrv *drvHandler, tstrHostIFscanAttr *pstrHostIFscanAttr)
 {
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 	tstrWID strWIDList[5];
 	u32 u32WidsCount = 0;
 	u32 i;
@@ -1472,7 +1472,7 @@ ERRORHANDLER:
  */
 static s32 Handle_ScanDone(tstrWILC_WFIDrv *drvHandler, tenuScanEvent enuEvent)
 {
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
 
@@ -1531,12 +1531,12 @@ u8 u8ConnectedSSID[6] = {0};
 static s32 Handle_Connect(tstrWILC_WFIDrv *drvHandler, tstrHostIFconnectAttr *pstrHostIFconnectAttr)
 {
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *) drvHandler;
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 	tstrWID strWIDList[8];
 	u32 u32WidsCount = 0, dummyval = 0;
 	/* char passphrase[] = "12345678"; */
 	#ifndef CONNECT_DIRECT
-	s32 s32Err = WILC_SUCCESS;
+	s32 s32Err = 0;
 	u32 i;
 	u8 u8bssDscListIndex;
 	wid_site_survey_reslts_s *pstrSurveyResults = NULL;
@@ -1568,7 +1568,7 @@ static s32 Handle_Connect(tstrWILC_WFIDrv *drvHandler, tstrHostIFconnectAttr *ps
 				    &pstrWFIDrv->u32SurveyResultsCount);
 
 
-	if (s32Err == WILC_SUCCESS) {
+	if (s32Err == 0) {
 		/* use the parsed info in pstrSurveyResults, then deallocate it */
 		PRINT_D(HOSTINF_DBG, "Copying site survey results in global structure, then deallocate\n");
 		for (i = 0; i < pstrWFIDrv->u32SurveyResultsCount; i++)	{
@@ -1711,7 +1711,7 @@ static s32 Handle_Connect(tstrWILC_WFIDrv *drvHandler, tstrHostIFconnectAttr *ps
 
 	if (memcmp(pstrHostIFconnectAttr->pu8bssid, u8ConnectedSSID, ETH_ALEN) == 0) {
 
-		s32Error = WILC_SUCCESS;
+		s32Error = 0;
 		PRINT_ER("Trying to connect to an already connected AP, Discard connect request\n");
 		return s32Error;
 	}
@@ -2109,7 +2109,7 @@ ERRORHANDLER:
 
 static s32 Handle_FlushConnect(tstrWILC_WFIDrv *drvHandler)
 {
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 	tstrWID strWIDList[5];
 	u32 u32WidsCount = 0;
 	u8 *pu8CurrByte = NULL;
@@ -2172,7 +2172,7 @@ static s32 Handle_FlushConnect(tstrWILC_WFIDrv *drvHandler)
  */
 static s32 Handle_ConnectTimeout(tstrWILC_WFIDrv *drvHandler)
 {
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 	tstrConnectInfo strConnectInfo;
 	tstrWID strWID;
 	u16 u16DummyReasonCode = 0;
@@ -2286,7 +2286,7 @@ static s32 Handle_RcvdNtwrkInfo(tstrWILC_WFIDrv *drvHandler, tstrRcvdNetworkInfo
 
 
 
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 	tstrNetworkInfo *pstrNetworkInfo = NULL;
 	void *pJoinParams = NULL;
 
@@ -2401,7 +2401,7 @@ static s32 Handle_RcvdGnrlAsyncInfo(tstrWILC_WFIDrv *drvHandler, tstrRcvdGnrlAsy
 {
 	/* TODO: mostafa: till now, this function just handles only the received mac status msg, */
 	/*				 which carries only 1 WID which have WID ID = WID_STATUS */
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 	u8 u8MsgType = 0;
 	u8 u8MsgID = 0;
 	u16 u16MsgLen = 0;
@@ -2412,7 +2412,7 @@ static s32 Handle_RcvdGnrlAsyncInfo(tstrWILC_WFIDrv *drvHandler, tstrRcvdGnrlAsy
 	u8 u8MacStatusAdditionalInfo;
 	tstrConnectInfo strConnectInfo;
 	tstrDisconnectNotifInfo strDisconnectNotifInfo;
-	s32 s32Err = WILC_SUCCESS;
+	s32 s32Err = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *) drvHandler;
 
 	if (pstrWFIDrv == NULL)
@@ -2726,7 +2726,7 @@ static s32 Handle_RcvdGnrlAsyncInfo(tstrWILC_WFIDrv *drvHandler, tstrRcvdGnrlAsy
  */
 static int Handle_Key(tstrWILC_WFIDrv *drvHandler, tstrHostIFkeyAttr *pstrHostIFkeyAttr)
 {
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 	tstrWID strWID;
 	#ifdef WILC_AP_EXTERNAL_MLME
 	tstrWID strWIDList[5];
@@ -3099,7 +3099,7 @@ static void Handle_Disconnect(tstrWILC_WFIDrv *drvHandler)
 {
 	tstrWID strWID;
 
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 	u16 u16DummyReasonCode = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
 
@@ -3219,7 +3219,7 @@ static s32 Switch_Log_Terminal(tstrWILC_WFIDrv *drvHandler)
 {
 
 
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 	tstrWID strWID;
 	static char dummy = 9;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
@@ -3257,7 +3257,7 @@ static s32 Switch_Log_Terminal(tstrWILC_WFIDrv *drvHandler)
 static s32 Handle_GetChnl(tstrWILC_WFIDrv *drvHandler)
 {
 
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 	tstrWID	strWID;
 	/* tstrWILC_WFIDrv * pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv; */
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
@@ -3297,7 +3297,7 @@ static s32 Handle_GetChnl(tstrWILC_WFIDrv *drvHandler)
  */
 static void Handle_GetRssi(tstrWILC_WFIDrv *drvHandler)
 {
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 	tstrWID strWID;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
 
@@ -3324,7 +3324,7 @@ static void Handle_GetRssi(tstrWILC_WFIDrv *drvHandler)
 
 static void Handle_GetLinkspeed(tstrWILC_WFIDrv *drvHandler)
 {
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 	tstrWID strWID;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
 
@@ -3413,7 +3413,7 @@ s32 Handle_GetStatistics(tstrWILC_WFIDrv *drvHandler, tstrStatistics *pstrStatis
 static s32 Handle_Get_InActiveTime(tstrWILC_WFIDrv *drvHandler, tstrHostIfStaInactiveT *strHostIfStaInactiveT)
 {
 
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 	u8 *stamac;
 	tstrWID	strWID;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
@@ -3478,7 +3478,7 @@ static s32 Handle_Get_InActiveTime(tstrWILC_WFIDrv *drvHandler, tstrHostIfStaIna
  */
 static void Handle_AddBeacon(tstrWILC_WFIDrv *drvHandler, tstrHostIFSetBeacon *pstrSetBeaconParam)
 {
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 	tstrWID strWID;
 	u8 *pu8CurrByte;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
@@ -3547,7 +3547,7 @@ ERRORHANDLER:
  */
 static void Handle_DelBeacon(tstrWILC_WFIDrv *drvHandler, tstrHostIFDelBeacon *pstrDelBeacon)
 {
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 	tstrWID strWID;
 	u8 *pu8CurrByte;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
@@ -3638,7 +3638,7 @@ static u32 WILC_HostIf_PackStaParam(u8 *pu8Buffer, tstrWILC_AddStaParam *pstrSta
  */
 static void Handle_AddStation(tstrWILC_WFIDrv *drvHandler, tstrWILC_AddStaParam *pstrStationParam)
 {
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 	tstrWID strWID;
 	u8 *pu8CurrByte;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
@@ -3658,7 +3658,7 @@ static void Handle_AddStation(tstrWILC_WFIDrv *drvHandler, tstrWILC_AddStaParam
 	/*Sending Cfg*/
 	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false,
 				 get_id_from_handler(pstrWFIDrv));
-	if (s32Error != WILC_SUCCESS)
+	if (s32Error != 0)
 		PRINT_ER("Failed to send add station config packet\n");
 
 ERRORHANDLER:
@@ -3677,7 +3677,7 @@ ERRORHANDLER:
  */
 static void Handle_DelAllSta(tstrWILC_WFIDrv *drvHandler, tstrHostIFDelAllSta *pstrDelAllStaParam)
 {
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 
 	tstrWID strWID;
 	u8 *pu8CurrByte;
@@ -3732,7 +3732,7 @@ ERRORHANDLER:
  */
 static void Handle_DelStation(tstrWILC_WFIDrv *drvHandler, tstrHostIFDelSta *pstrDelStaParam)
 {
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 	tstrWID strWID;
 	u8 *pu8CurrByte;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
@@ -3773,7 +3773,7 @@ ERRORHANDLER:
  */
 static void Handle_EditStation(tstrWILC_WFIDrv *drvHandler, tstrWILC_AddStaParam *pstrStationParam)
 {
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 	tstrWID strWID;
 	u8 *pu8CurrByte;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
@@ -3814,7 +3814,7 @@ ERRORHANDLER:
  */
 static int Handle_RemainOnChan(tstrWILC_WFIDrv *drvHandler, tstrHostIfRemainOnChan *pstrHostIfRemainOnChan)
 {
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 	u8 u8remain_on_chan_flag;
 	tstrWID strWID;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *) drvHandler;
@@ -3870,7 +3870,7 @@ static int Handle_RemainOnChan(tstrWILC_WFIDrv *drvHandler, tstrHostIfRemainOnCh
 	/*Sending Cfg*/
 	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true,
 				 get_id_from_handler(pstrWFIDrv));
-	if (s32Error != WILC_SUCCESS)
+	if (s32Error != 0)
 		PRINT_ER("Failed to set remain on channel\n");
 
 ERRORHANDLER:
@@ -3902,7 +3902,7 @@ ERRORHANDLER:
  */
 static int Handle_RegisterFrame(tstrWILC_WFIDrv *drvHandler, tstrHostIfRegisterFrame *pstrHostIfRegisterFrame)
 {
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 	tstrWID strWID;
 	u8 *pu8CurrByte;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
@@ -3952,7 +3952,7 @@ static u32 Handle_ListenStateExpired(tstrWILC_WFIDrv *drvHandler, tstrHostIfRema
 {
 	u8 u8remain_on_chan_flag;
 	tstrWID strWID;
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *) drvHandler;
 
 	PRINT_D(HOSTINF_DBG, "CANCEL REMAIN ON CHAN\n");
@@ -3976,7 +3976,7 @@ static u32 Handle_ListenStateExpired(tstrWILC_WFIDrv *drvHandler, tstrHostIfRema
 		/*Sending Cfg*/
 		s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true,
 					 get_id_from_handler(pstrWFIDrv));
-		if (s32Error != WILC_SUCCESS) {
+		if (s32Error != 0) {
 			PRINT_ER("Failed to set remain on channel\n");
 			goto _done_;
 		}
@@ -3988,7 +3988,7 @@ static u32 Handle_ListenStateExpired(tstrWILC_WFIDrv *drvHandler, tstrHostIfRema
 		P2P_LISTEN_STATE = 0;
 	} else {
 		PRINT_D(GENERIC_DBG, "Not in listen state\n");
-		s32Error = WILC_FAIL;
+		s32Error = -EFAULT;
 	}
 
 _done_:
@@ -4007,7 +4007,7 @@ _done_:
  */
 static void ListenTimerCB(unsigned long arg)
 {
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 	tstrHostIFmsg strHostIFmsg;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)arg;
 	/*Stopping remain-on-channel timer*/
@@ -4038,7 +4038,7 @@ static void ListenTimerCB(unsigned long arg)
  */
 static void Handle_PowerManagement(tstrWILC_WFIDrv *drvHandler, tstrHostIfPowerMgmtParam *strPowerMgmtParam)
 {
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 	tstrWID strWID;
 	s8 s8PowerMode;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
@@ -4073,7 +4073,7 @@ static void Handle_PowerManagement(tstrWILC_WFIDrv *drvHandler, tstrHostIfPowerM
  */
 static void Handle_SetMulticastFilter(tstrWILC_WFIDrv *drvHandler, tstrHostIFSetMulti *strHostIfSetMulti)
 {
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 	tstrWID strWID;
 	u8 *pu8CurrByte;
 
@@ -4124,7 +4124,7 @@ ERRORHANDLER:
  */
 static s32 Handle_AddBASession(tstrWILC_WFIDrv *drvHandler, tstrHostIfBASessionInfo *strHostIfBASessionInfo)
 {
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 	tstrWID strWID;
 	int AddbaTimeout = 100;
 	char *ptr = NULL;
@@ -4214,7 +4214,7 @@ static s32 Handle_AddBASession(tstrWILC_WFIDrv *drvHandler, tstrHostIfBASessionI
  */
 static s32 Handle_DelBASession(tstrWILC_WFIDrv *drvHandler, tstrHostIfBASessionInfo *strHostIfBASessionInfo)
 {
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 	tstrWID strWID;
 	char *ptr = NULL;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
@@ -4286,7 +4286,7 @@ static s32 Handle_DelBASession(tstrWILC_WFIDrv *drvHandler, tstrHostIfBASessionI
  */
 static s32 Handle_DelAllRxBASessions(tstrWILC_WFIDrv *drvHandler, tstrHostIfBASessionInfo *strHostIfBASessionInfo)
 {
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 	tstrWID strWID;
 	char *ptr = NULL;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
@@ -4606,7 +4606,7 @@ static void TimerCB_Connect(unsigned long arg)
 /* Check implementation in core adding 9 bytes to the input! */
 s32 host_int_remove_key(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8StaAddress)
 {
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 	tstrWID strWID;
 	/* tstrWILC_WFIDrv * pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv; */
 
@@ -4635,7 +4635,7 @@ s32 host_int_remove_key(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8StaAddress)
  */
 s32 host_int_remove_wep_key(tstrWILC_WFIDrv *hWFIDrv, u8 u8keyIdx)
 {
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	tstrHostIFmsg strHostIFmsg;
 
@@ -4683,7 +4683,7 @@ s32 host_int_remove_wep_key(tstrWILC_WFIDrv *hWFIDrv, u8 u8keyIdx)
  */
 s32 host_int_set_WEPDefaultKeyID(tstrWILC_WFIDrv *hWFIDrv, u8 u8Index)
 {
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	tstrHostIFmsg strHostIFmsg;
 
@@ -4738,7 +4738,7 @@ s32 host_int_set_WEPDefaultKeyID(tstrWILC_WFIDrv *hWFIDrv, u8 u8Index)
 s32 host_int_add_wep_key_bss_sta(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8WepKey, u8 u8WepKeylen, u8 u8Keyidx)
 {
 
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	tstrHostIFmsg strHostIFmsg;
 
@@ -4801,7 +4801,7 @@ s32 host_int_add_wep_key_bss_sta(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8WepKey,
 s32 host_int_add_wep_key_bss_ap(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8WepKey, u8 u8WepKeylen, u8 u8Keyidx, u8 u8mode, AUTHTYPE_T tenuAuth_type)
 {
 
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	tstrHostIFmsg strHostIFmsg;
 	u8 i;
@@ -4874,7 +4874,7 @@ s32 host_int_add_wep_key_bss_ap(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8WepKey, u
 s32 host_int_add_ptk(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8Ptk, u8 u8PtkKeylen,
 			     const u8 *mac_addr, const u8 *pu8RxMic, const u8 *pu8TxMic, u8 mode, u8 u8Ciphermode, u8 u8Idx)
 {
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	tstrHostIFmsg strHostIFmsg;
 	u8 u8KeyLen = u8PtkKeylen;
@@ -4972,7 +4972,7 @@ s32 host_int_add_rx_gtk(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8RxGtk, u8 u8GtkKe
 				u8 u8KeyIdx, u32 u32KeyRSClen, const u8 *KeyRSC,
 				const u8 *pu8RxMic, const u8 *pu8TxMic, u8 mode, u8 u8Ciphermode)
 {
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	tstrHostIFmsg strHostIFmsg;
 	u8 u8KeyLen = u8GtkKeylen;
@@ -5075,7 +5075,7 @@ s32 host_int_add_rx_gtk(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8RxGtk, u8 u8GtkKe
  */
 s32 host_int_set_pmkid_info(tstrWILC_WFIDrv *hWFIDrv, tstrHostIFpmkidAttr *pu8PmkidInfoArray)
 {
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	tstrHostIFmsg strHostIFmsg;
 	u32 i;
@@ -5136,7 +5136,7 @@ s32 host_int_set_pmkid_info(tstrWILC_WFIDrv *hWFIDrv, tstrHostIFpmkidAttr *pu8Pm
 s32 host_int_get_pmkid_info(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8PmkidInfoArray,
 				    u32 u32PmkidInfoLen)
 {
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 	tstrWID strWID;
 	/* tstrWILC_WFIDrv * pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv; */
 
@@ -5165,7 +5165,7 @@ s32 host_int_get_pmkid_info(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8PmkidInfoArray,
 s32 host_int_set_RSNAConfigPSKPassPhrase(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8PassPhrase,
 						 u8 u8Psklength)
 {
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 	tstrWID strWID;
 
 	/*validating psk length*/
@@ -5191,7 +5191,7 @@ s32 host_int_set_RSNAConfigPSKPassPhrase(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8PassPh
  */
 s32 host_int_get_MacAddress(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8MacAddress)
 {
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 	tstrHostIFmsg strHostIFmsg;
 
 
@@ -5205,7 +5205,7 @@ s32 host_int_get_MacAddress(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8MacAddress)
 	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
 	if (s32Error) {
 		PRINT_ER("Failed to send get mac address\n");
-		return WILC_FAIL;
+		return -EFAULT;
 	}
 
 	down(&hWaitResponse);
@@ -5225,7 +5225,7 @@ s32 host_int_get_MacAddress(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8MacAddress)
  */
 s32 host_int_set_MacAddress(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8MacAddress)
 {
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 	tstrHostIFmsg strHostIFmsg;
 
 	PRINT_D(GENERIC_DBG, "mac addr = %x:%x:%x\n", pu8MacAddress[0], pu8MacAddress[1], pu8MacAddress[2]);
@@ -5261,7 +5261,7 @@ s32 host_int_set_MacAddress(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8MacAddress)
 s32 host_int_get_RSNAConfigPSKPassPhrase(tstrWILC_WFIDrv *hWFIDrv,
 						 u8 *pu8PassPhrase, u8 u8Psklength)
 {
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 	tstrWID strWID;
 	/* tstrWILC_WFIDrv * pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv; */
 
@@ -5309,7 +5309,7 @@ s32 host_int_get_site_survey_results(tstrWILC_WFIDrv *hWFIDrv,
 					     u8 ppu8RcvdSiteSurveyResults[][MAX_SURVEY_RESULT_FRAG_SIZE],
 					     u32 u32MaxSiteSrvyFragLen)
 {
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 	tstrWID astrWIDList[2];
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 
@@ -5353,7 +5353,7 @@ s32 host_int_get_site_survey_results(tstrWILC_WFIDrv *hWFIDrv,
  */
 s32 host_int_set_start_scan_req(tstrWILC_WFIDrv *hWFIDrv, u8 scanSource)
 {
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 	tstrWID strWID;
 	/* tstrWILC_WFIDrv * pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv; */
 
@@ -5383,7 +5383,7 @@ s32 host_int_set_start_scan_req(tstrWILC_WFIDrv *hWFIDrv, u8 scanSource)
 
 s32 host_int_get_start_scan_req(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8ScanSource)
 {
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 	tstrWID strWID;
 	/* tstrWILC_WFIDrv * pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv; */
 
@@ -5414,7 +5414,7 @@ s32 host_int_set_join_req(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8bssid,
 				  u8 u8channel,
 				  void *pJoinParams)
 {
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	tstrHostIFmsg strHostIFmsg;
 	tenuScanConnTimer enuScanConnTimer;
@@ -5502,11 +5502,11 @@ s32 host_int_set_join_req(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8bssid,
 
 s32 host_int_flush_join_req(tstrWILC_WFIDrv *hWFIDrv)
 {
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 	tstrHostIFmsg strHostIFmsg;
 
 	if (!gu8FlushedJoinReq)	{
-		s32Error = WILC_FAIL;
+		s32Error = -EFAULT;
 		return s32Error;
 	}
 
@@ -5543,7 +5543,7 @@ s32 host_int_flush_join_req(tstrWILC_WFIDrv *hWFIDrv)
  */
 s32 host_int_disconnect(tstrWILC_WFIDrv *hWFIDrv, u16 u16ReasonCode)
 {
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 	tstrHostIFmsg strHostIFmsg;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 
@@ -5582,7 +5582,7 @@ s32 host_int_disconnect(tstrWILC_WFIDrv *hWFIDrv, u16 u16ReasonCode)
  */
 s32 host_int_disconnect_station(tstrWILC_WFIDrv *hWFIDrv, u8 assoc_id)
 {
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 	tstrWID strWID;
 	/* tstrWILC_WFIDrv * pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv; */
 
@@ -5623,7 +5623,7 @@ s32 host_int_disconnect_station(tstrWILC_WFIDrv *hWFIDrv, u8 assoc_id)
 s32 host_int_get_assoc_req_info(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8AssocReqInfo,
 					u32 u32AssocReqInfoLen)
 {
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 	tstrWID strWID;
 	/* tstrWILC_WFIDrv * pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv; */
 
@@ -5650,7 +5650,7 @@ s32 host_int_get_assoc_req_info(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8AssocReqInfo,
 s32 host_int_get_assoc_res_info(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8AssocRespInfo,
 					u32 u32MaxAssocRespInfoLen, u32 *pu32RcvdAssocRespInfoLen)
 {
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 	tstrWID strWID;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 
@@ -5697,7 +5697,7 @@ s32 host_int_get_assoc_res_info(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8AssocRespInfo,
 s32 host_int_get_rx_power_level(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8RxPowerLevel,
 					u32 u32RxPowerLevelLen)
 {
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 	tstrWID strWID;
 	/* tstrWILC_WFIDrv * pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv; */
 
@@ -5727,7 +5727,7 @@ s32 host_int_get_rx_power_level(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8RxPowerLevel,
  */
 s32 host_int_set_mac_chnl_num(tstrWILC_WFIDrv *hWFIDrv, u8 u8ChNum)
 {
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	tstrHostIFmsg strHostIFmsg;
 
@@ -5754,7 +5754,7 @@ s32 host_int_set_mac_chnl_num(tstrWILC_WFIDrv *hWFIDrv, u8 u8ChNum)
 
 s32 host_int_wait_msg_queue_idle(void)
 {
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 
 	tstrHostIFmsg strHostIFmsg;
 
@@ -5777,7 +5777,7 @@ s32 host_int_wait_msg_queue_idle(void)
 
 s32 host_int_set_wfi_drv_handler(tstrWILC_WFIDrv *u32address)
 {
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 
 	tstrHostIFmsg strHostIFmsg;
 
@@ -5802,7 +5802,7 @@ s32 host_int_set_wfi_drv_handler(tstrWILC_WFIDrv *u32address)
 
 s32 host_int_set_operation_mode(tstrWILC_WFIDrv *hWFIDrv, u32 u32mode)
 {
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 
 	tstrHostIFmsg strHostIFmsg;
 
@@ -5840,7 +5840,7 @@ s32 host_int_set_operation_mode(tstrWILC_WFIDrv *hWFIDrv, u32 u32mode)
  */
 s32 host_int_get_host_chnl_num(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8ChNo)
 {
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	tstrHostIFmsg strHostIFmsg;
 
@@ -5882,7 +5882,7 @@ s32 host_int_get_host_chnl_num(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8ChNo)
  */
 s32 host_int_test_set_int_wid(tstrWILC_WFIDrv *hWFIDrv, u32 u32TestMemAddr)
 {
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 	tstrWID	strWID;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 
@@ -5926,7 +5926,7 @@ s32 host_int_test_set_int_wid(tstrWILC_WFIDrv *hWFIDrv, u32 u32TestMemAddr)
  */
 s32 host_int_get_inactive_time(tstrWILC_WFIDrv *hWFIDrv, const u8 *mac, u32 *pu32InactiveTime)
 {
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	tstrHostIFmsg strHostIFmsg;
 
@@ -5969,7 +5969,7 @@ s32 host_int_get_inactive_time(tstrWILC_WFIDrv *hWFIDrv, const u8 *mac, u32 *pu3
 s32 host_int_test_get_int_wid(tstrWILC_WFIDrv *hWFIDrv, u32 *pu32TestMemAddr)
 {
 
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 	tstrWID	strWID;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 
@@ -6014,7 +6014,7 @@ s32 host_int_test_get_int_wid(tstrWILC_WFIDrv *hWFIDrv, u32 *pu32TestMemAddr)
  */
 s32 host_int_get_rssi(tstrWILC_WFIDrv *hWFIDrv, s8 *ps8Rssi)
 {
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 	tstrHostIFmsg strHostIFmsg;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 
@@ -6029,7 +6029,7 @@ s32 host_int_get_rssi(tstrWILC_WFIDrv *hWFIDrv, s8 *ps8Rssi)
 	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
 	if (s32Error) {
 		PRINT_ER("Failed to send get host channel param's message queue ");
-		return WILC_FAIL;
+		return -EFAULT;
 	}
 
 	down(&(pstrWFIDrv->hSemGetRSSI));
@@ -6037,7 +6037,7 @@ s32 host_int_get_rssi(tstrWILC_WFIDrv *hWFIDrv, s8 *ps8Rssi)
 
 	if (ps8Rssi == NULL) {
 		PRINT_ER("RSS pointer value is null");
-		return WILC_FAIL;
+		return -EFAULT;
 	}
 
 
@@ -6050,7 +6050,7 @@ s32 host_int_get_rssi(tstrWILC_WFIDrv *hWFIDrv, s8 *ps8Rssi)
 s32 host_int_get_link_speed(tstrWILC_WFIDrv *hWFIDrv, s8 *ps8lnkspd)
 {
 	tstrHostIFmsg strHostIFmsg;
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 
@@ -6066,7 +6066,7 @@ s32 host_int_get_link_speed(tstrWILC_WFIDrv *hWFIDrv, s8 *ps8lnkspd)
 	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
 	if (s32Error) {
 		PRINT_ER("Failed to send GET_LINKSPEED to message queue ");
-		return WILC_FAIL;
+		return -EFAULT;
 	}
 
 	down(&(pstrWFIDrv->hSemGetLINKSPEED));
@@ -6074,7 +6074,7 @@ s32 host_int_get_link_speed(tstrWILC_WFIDrv *hWFIDrv, s8 *ps8lnkspd)
 
 	if (ps8lnkspd == NULL) {
 		PRINT_ER("LINKSPEED pointer value is null");
-		return WILC_FAIL;
+		return -EFAULT;
 	}
 
 
@@ -6086,7 +6086,7 @@ s32 host_int_get_link_speed(tstrWILC_WFIDrv *hWFIDrv, s8 *ps8lnkspd)
 
 s32 host_int_get_statistics(tstrWILC_WFIDrv *hWFIDrv, tstrStatistics *pstrStatistics)
 {
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 	tstrHostIFmsg strHostIFmsg;
 
 
@@ -6100,7 +6100,7 @@ s32 host_int_get_statistics(tstrWILC_WFIDrv *hWFIDrv, tstrStatistics *pstrStatis
 	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
 	if (s32Error) {
 		PRINT_ER("Failed to send get host channel param's message queue ");
-		return WILC_FAIL;
+		return -EFAULT;
 	}
 
 	down(&hWaitResponse);
@@ -6130,7 +6130,7 @@ s32 host_int_scan(tstrWILC_WFIDrv *hWFIDrv, u8 u8ScanSource,
 			  size_t IEsLen, tWILCpfScanResult ScanResult,
 			  void *pvUserArg, tstrHiddenNetwork  *pstrHiddenNetwork)
 {
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	tstrHostIFmsg strHostIFmsg;
 	tenuScanConnTimer enuScanConnTimer;
@@ -6198,7 +6198,7 @@ s32 host_int_scan(tstrWILC_WFIDrv *hWFIDrv, u8 u8ScanSource,
 s32 hif_set_cfg(tstrWILC_WFIDrv *hWFIDrv, tstrCfgParamVal *pstrCfgParamVal)
 {
 
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 
 	tstrHostIFmsg strHostIFmsg;
@@ -6236,7 +6236,7 @@ s32 hif_set_cfg(tstrWILC_WFIDrv *hWFIDrv, tstrCfgParamVal *pstrCfgParamVal)
  */
 s32 hif_get_cfg(tstrWILC_WFIDrv *hWFIDrv, u16 u16WID, u16 *pu16WID_Value)
 {
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 
 	down(&(pstrWFIDrv->gtOsCfgValuesSem));
@@ -6376,7 +6376,7 @@ static void GetPeriodicRSSI(unsigned long arg)
 	}
 
 	if (pstrWFIDrv->enuHostIFstate == HOST_IF_CONNECTED) {
-		s32 s32Error = WILC_SUCCESS;
+		s32 s32Error = 0;
 		tstrHostIFmsg strHostIFmsg;
 
 		/* prepare the Get RSSI Message */
@@ -6416,7 +6416,7 @@ static u32 clients_count;
 
 s32 host_int_init(tstrWILC_WFIDrv **phWFIDrv)
 {
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv;
 	int err;
 
@@ -6437,7 +6437,7 @@ s32 host_int_init(tstrWILC_WFIDrv **phWFIDrv)
 	/*Allocate host interface private structure*/
 	pstrWFIDrv  = kmalloc(sizeof(tstrWILC_WFIDrv), GFP_KERNEL);
 	if (pstrWFIDrv == NULL) {
-		s32Error = WILC_NO_MEM;
+		s32Error = -ENOMEM;
 		PRINT_ER("Failed to allocate memory\n");
 		goto _fail_timer_2;
 	}
@@ -6447,7 +6447,7 @@ s32 host_int_init(tstrWILC_WFIDrv **phWFIDrv)
 	/*save into globl handle*/
 	err = add_handler_in_list(pstrWFIDrv);
 	if (err) {
-		s32Error = WILC_FAIL;
+		s32Error = -EFAULT;
 		goto _fail_timer_2;
 	}
 
@@ -6489,7 +6489,7 @@ s32 host_int_init(tstrWILC_WFIDrv **phWFIDrv)
 		HostIFthreadHandler = kthread_run(hostIFthread, NULL, "WILC_kthread");
 		if (IS_ERR(HostIFthreadHandler)) {
 			PRINT_ER("Failed to creat Thread\n");
-			s32Error = WILC_FAIL;
+			s32Error = -EFAULT;
 			goto _fail_mq_;
 		}
 		setup_timer(&g_hPeriodicRSSI, GetPeriodicRSSI,
@@ -6581,7 +6581,7 @@ _fail_:
 
 s32 host_int_deinit(tstrWILC_WFIDrv *hWFIDrv)
 {
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 	tstrHostIFmsg strHostIFmsg;
 	int ret;
 
@@ -6659,7 +6659,7 @@ s32 host_int_deinit(tstrWILC_WFIDrv *hWFIDrv)
 
 
 		s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
-		if (s32Error != WILC_SUCCESS)
+		if (s32Error != 0)
 			PRINT_ER("Error in sending deinit's message queue message function: Error(%d)\n", s32Error);
 
 		down(&hSemHostIFthrdEnd);
@@ -6675,7 +6675,7 @@ s32 host_int_deinit(tstrWILC_WFIDrv *hWFIDrv)
 	/* gWFiDrvHandle = NULL; */
 	ret = remove_handler_in_list(pstrWFIDrv);
 	if (ret)
-		s32Error = WILC_NOT_FOUND;
+		s32Error = -ENOENT;
 
 	if (pstrWFIDrv != NULL) {
 		kfree(pstrWFIDrv);
@@ -6703,7 +6703,7 @@ s32 host_int_deinit(tstrWILC_WFIDrv *hWFIDrv)
  */
 void NetworkInfoReceived(u8 *pu8Buffer, u32 u32Length)
 {
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 	tstrHostIFmsg strHostIFmsg;
 	int id;
 	tstrWILC_WFIDrv *pstrWFIDrv = NULL;
@@ -6749,7 +6749,7 @@ void NetworkInfoReceived(u8 *pu8Buffer, u32 u32Length)
  */
 void GnrlAsyncInfoReceived(u8 *pu8Buffer, u32 u32Length)
 {
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 	tstrHostIFmsg strHostIFmsg;
 	int id;
 	tstrWILC_WFIDrv *pstrWFIDrv = NULL;
@@ -6810,7 +6810,7 @@ void GnrlAsyncInfoReceived(u8 *pu8Buffer, u32 u32Length)
  */
 void host_int_ScanCompleteReceived(u8 *pu8Buffer, u32 u32Length)
 {
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 	tstrHostIFmsg strHostIFmsg;
 	int id;
 	tstrWILC_WFIDrv *pstrWFIDrv = NULL;
@@ -6869,7 +6869,7 @@ void host_int_ScanCompleteReceived(u8 *pu8Buffer, u32 u32Length)
  */
 s32 host_int_remain_on_channel(tstrWILC_WFIDrv *hWFIDrv, u32 u32SessionID, u32 u32duration, u16 chan, tWILCpfRemainOnChanExpired RemainOnChanExpired, tWILCpfRemainOnChanReady RemainOnChanReady, void *pvUserArg)
 {
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	tstrHostIFmsg strHostIFmsg;
 
@@ -6914,7 +6914,7 @@ s32 host_int_remain_on_channel(tstrWILC_WFIDrv *hWFIDrv, u32 u32SessionID, u32 u
  */
 s32 host_int_ListenStateExpired(tstrWILC_WFIDrv *hWFIDrv, u32 u32SessionID)
 {
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	tstrHostIFmsg strHostIFmsg;
 
@@ -6949,7 +6949,7 @@ s32 host_int_ListenStateExpired(tstrWILC_WFIDrv *hWFIDrv, u32 u32SessionID)
  *  @version		1.0*/
 s32 host_int_frame_register(tstrWILC_WFIDrv *hWFIDrv, u16 u16FrameType, bool bReg)
 {
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	tstrHostIFmsg strHostIFmsg;
 
@@ -7008,7 +7008,7 @@ s32 host_int_add_beacon(tstrWILC_WFIDrv *hWFIDrv, u32 u32Interval,
 				u32 u32HeadLen, u8 *pu8Head,
 				u32 u32TailLen, u8 *pu8Tail)
 {
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	tstrHostIFmsg strHostIFmsg;
 	tstrHostIFSetBeacon *pstrSetBeaconParam = &strHostIFmsg.uniHostIFmsgBody.strHostIFSetBeacon;
@@ -7078,7 +7078,7 @@ ERRORHANDLER:
  */
 s32 host_int_del_beacon(tstrWILC_WFIDrv *hWFIDrv)
 {
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	tstrHostIFmsg strHostIFmsg;
 
@@ -7111,7 +7111,7 @@ s32 host_int_del_beacon(tstrWILC_WFIDrv *hWFIDrv)
  */
 s32 host_int_add_station(tstrWILC_WFIDrv *hWFIDrv, tstrWILC_AddStaParam *pstrStaParams)
 {
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	tstrHostIFmsg strHostIFmsg;
 	tstrWILC_AddStaParam *pstrAddStationMsg = &strHostIFmsg.uniHostIFmsgBody.strAddStaParam;
@@ -7160,7 +7160,7 @@ s32 host_int_add_station(tstrWILC_WFIDrv *hWFIDrv, tstrWILC_AddStaParam *pstrSta
  */
 s32 host_int_del_station(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8MacAddr)
 {
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	tstrHostIFmsg strHostIFmsg;
 	tstrHostIFDelSta *pstrDelStationMsg = &strHostIFmsg.uniHostIFmsgBody.strDelStaParam;
@@ -7202,7 +7202,7 @@ s32 host_int_del_station(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8MacAddr)
  */
 s32 host_int_del_allstation(tstrWILC_WFIDrv *hWFIDrv, u8 pu8MacAddr[][ETH_ALEN])
 {
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	tstrHostIFmsg strHostIFmsg;
 	tstrHostIFDelAllSta *pstrDelAllStationMsg = &strHostIFmsg.uniHostIFmsgBody.strHostIFDelAllSta;
@@ -7262,7 +7262,7 @@ s32 host_int_del_allstation(tstrWILC_WFIDrv *hWFIDrv, u8 pu8MacAddr[][ETH_ALEN])
  */
 s32 host_int_edit_station(tstrWILC_WFIDrv *hWFIDrv, tstrWILC_AddStaParam *pstrStaParams)
 {
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	tstrHostIFmsg strHostIFmsg;
 	tstrWILC_AddStaParam *pstrAddStationMsg = &strHostIFmsg.uniHostIFmsgBody.strAddStaParam;
@@ -7303,7 +7303,7 @@ u32 wilc_get_chipid(u8);
 
 s32 host_int_set_power_mgmt(tstrWILC_WFIDrv *hWFIDrv, bool bIsEnabled, u32 u32Timeout)
 {
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	tstrHostIFmsg strHostIFmsg;
 	tstrHostIfPowerMgmtParam *pstrPowerMgmtParam = &strHostIFmsg.uniHostIFmsgBody.strPowerMgmtparam;
@@ -7336,7 +7336,7 @@ s32 host_int_set_power_mgmt(tstrWILC_WFIDrv *hWFIDrv, bool bIsEnabled, u32 u32Ti
 
 s32 host_int_setup_multicast_filter(tstrWILC_WFIDrv *hWFIDrv, bool bIsEnabled, u32 u32count)
 {
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	tstrHostIFmsg strHostIFmsg;
@@ -7606,7 +7606,7 @@ void host_int_freeJoinParams(void *pJoinParams)
 static int host_int_addBASession(tstrWILC_WFIDrv *hWFIDrv, char *pBSSID, char TID, short int BufferSize,
 				 short int SessionTimeout, void *drvHandler)
 {
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	tstrHostIFmsg strHostIFmsg;
 	tstrHostIfBASessionInfo *pBASessionInfo = &strHostIFmsg.uniHostIFmsgBody.strHostIfBASessionInfo;
@@ -7637,7 +7637,7 @@ static int host_int_addBASession(tstrWILC_WFIDrv *hWFIDrv, char *pBSSID, char TI
 
 s32 host_int_delBASession(tstrWILC_WFIDrv *hWFIDrv, char *pBSSID, char TID)
 {
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	tstrHostIFmsg strHostIFmsg;
 	tstrHostIfBASessionInfo *pBASessionInfo = &strHostIFmsg.uniHostIFmsgBody.strHostIfBASessionInfo;
@@ -7668,7 +7668,7 @@ s32 host_int_delBASession(tstrWILC_WFIDrv *hWFIDrv, char *pBSSID, char TID)
 
 s32 host_int_del_All_Rx_BASession(tstrWILC_WFIDrv *hWFIDrv, char *pBSSID, char TID)
 {
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	tstrHostIFmsg strHostIFmsg;
 	tstrHostIfBASessionInfo *pBASessionInfo = &strHostIFmsg.uniHostIFmsgBody.strHostIfBASessionInfo;
@@ -7707,7 +7707,7 @@ s32 host_int_del_All_Rx_BASession(tstrWILC_WFIDrv *hWFIDrv, char *pBSSID, char T
  *  @version		1.0*/
 s32 host_int_setup_ipaddress(tstrWILC_WFIDrv *hWFIDrv, u8 *u16ipadd, u8 idx)
 {
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	tstrHostIFmsg strHostIFmsg;
 
@@ -7747,7 +7747,7 @@ s32 host_int_setup_ipaddress(tstrWILC_WFIDrv *hWFIDrv, u8 *u16ipadd, u8 idx)
  *  @version		1.0*/
 s32 host_int_get_ipaddress(tstrWILC_WFIDrv *hWFIDrv, u8 *u16ipadd, u8 idx)
 {
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	tstrHostIFmsg strHostIFmsg;
 
diff --git a/drivers/staging/wilc1000/linux_mon.c b/drivers/staging/wilc1000/linux_mon.c
index 6a27d5c..af5d0f5 100644
--- a/drivers/staging/wilc1000/linux_mon.c
+++ b/drivers/staging/wilc1000/linux_mon.c
@@ -178,21 +178,21 @@ static int mon_mgmt_tx(struct net_device *dev, const u8 *buf, size_t len)
 
 	if (dev == NULL) {
 		PRINT_D(HOSTAPD_DBG, "ERROR: dev == NULL\n");
-		return WILC_FAIL;
+		return -EFAULT;
 	}
 
 	netif_stop_queue(dev);
 	mgmt_tx = kmalloc(sizeof(struct tx_complete_mon_data), GFP_ATOMIC);
 	if (mgmt_tx == NULL) {
 		PRINT_ER("Failed to allocate memory for mgmt_tx structure\n");
-		return WILC_FAIL;
+		return -EFAULT;
 	}
 
 	mgmt_tx->buff = kmalloc(len, GFP_ATOMIC);
 	if (mgmt_tx->buff == NULL) {
 		PRINT_ER("Failed to allocate memory for mgmt_tx buff\n");
 		kfree(mgmt_tx);
-		return WILC_FAIL;
+		return -EFAULT;
 
 	}
 
@@ -225,13 +225,13 @@ static netdev_tx_t WILC_WFI_mon_xmit(struct sk_buff *skb,
 
 	/* Bug 4601 */
 	if (wilc_wfi_mon == NULL)
-		return WILC_FAIL;
+		return -EFAULT;
 
 	mon_priv = netdev_priv(wilc_wfi_mon);
 
 	if (mon_priv == NULL) {
 		PRINT_ER("Monitor interface private structure is NULL\n");
-		return WILC_FAIL;
+		return -EFAULT;
 	}
 
 
@@ -351,7 +351,7 @@ struct net_device *WILC_WFI_init_mon_interface(const char *name, struct net_devi
 {
 
 
-	u32 ret = WILC_SUCCESS;
+	u32 ret = 0;
 	struct WILC_WFI_mon_priv *priv;
 
 	/*If monitor interface is already initialized, return it*/
@@ -416,7 +416,7 @@ int WILC_WFI_deinit_mon_interface(void)
 		}
 		wilc_wfi_mon = NULL;
 	}
-	return WILC_SUCCESS;
+	return 0;
 
 }
 #endif /* WILC_AP_EXTERNAL_MLME */
diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index bd77eb3..3477e09 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1905,7 +1905,7 @@ int mac_ioctl(struct net_device *ndev, struct ifreq *req, int cmd)
 	u32 size = 0, length = 0;
 	perInterface_wlan_t *nic;
 	struct wilc_priv *priv;
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 
 	/* struct iwreq *wrq = (struct iwreq *) req;	// tony moved to case SIOCSIWPRIV */
 	nic = netdev_priv(ndev);
diff --git a/drivers/staging/wilc1000/wilc_errorsupport.h b/drivers/staging/wilc1000/wilc_errorsupport.h
index 054ed76..b0babbd 100644
--- a/drivers/staging/wilc1000/wilc_errorsupport.h
+++ b/drivers/staging/wilc1000/wilc_errorsupport.h
@@ -12,18 +12,4 @@
 
 #include "linux_wlan_common.h"
 
-/* Generic success will return 0 */
-#define WILC_SUCCESS	0       /** Generic success */
-
-/* Negative numbers to indicate failures */
-#define WILC_FAIL			-100 /** Generic Fail */
-#define WILC_BUSY			-101 /** Busy with another operation*/
-#define WILC_INVALID_ARGUMENT		-102 /** A given argument is invalid*/
-#define WILC_INVALID_STATE		-103 /** An API request would violate the Driver state machine (i.e. to start PID while not camped)*/
-#define WILC_BUFFER_OVERFLOW		-104 /** In copy operations if the copied data is larger than the allocated buffer*/
-#define WILC_NULL_PTR			-105 /** null pointer is passed or used */
-#define WILC_TIMEOUT			-109
-#define WILC_NOT_FOUND			-113 /** Cant find the file to load */
-#define WILC_NO_MEM			-114
-
 #endif
diff --git a/drivers/staging/wilc1000/wilc_msgqueue.c b/drivers/staging/wilc1000/wilc_msgqueue.c
index 01fd94b..94a2d3d 100644
--- a/drivers/staging/wilc1000/wilc_msgqueue.c
+++ b/drivers/staging/wilc1000/wilc_msgqueue.c
@@ -16,7 +16,7 @@ int wilc_mq_create(WILC_MsgQueueHandle *pHandle)
 	pHandle->pstrMessageList = NULL;
 	pHandle->u32ReceiversCount = 0;
 	pHandle->bExiting = false;
-	return WILC_SUCCESS;
+	return 0;
 }
 
 /*!
@@ -42,7 +42,7 @@ int wilc_mq_destroy(WILC_MsgQueueHandle *pHandle)
 		pHandle->pstrMessageList = pstrMessge;
 	}
 
-	return WILC_SUCCESS;
+	return 0;
 }
 
 /*!
@@ -54,7 +54,7 @@ int wilc_mq_destroy(WILC_MsgQueueHandle *pHandle)
 int wilc_mq_send(WILC_MsgQueueHandle *pHandle,
 			     const void *pvSendBuffer, u32 u32SendBufferSize)
 {
-	int s32RetStatus = WILC_SUCCESS;
+	int s32RetStatus = 0;
 	unsigned long flags;
 	Message *pstrMessage = NULL;
 
@@ -122,7 +122,7 @@ int wilc_mq_recv(WILC_MsgQueueHandle *pHandle,
 			     u32 *pu32ReceivedLength)
 {
 	Message *pstrMessage;
-	int s32RetStatus = WILC_SUCCESS;
+	int s32RetStatus = 0;
 	unsigned long flags;
 
 	if ((!pHandle) || (u32RecvBufferSize == 0)
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 48def8c..f01260f 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -500,7 +500,7 @@ static void CfgScanResult(tenuScanEvent enuScanEvent, tstrNetworkInfo *pstrNetwo
 int WILC_WFI_Set_PMKSA(u8 *bssid, struct wilc_priv *priv)
 {
 	u32 i;
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 
 
 	for (i = 0; i < priv->pmkid_list.numpmkid; i++)	{
@@ -512,7 +512,7 @@ int WILC_WFI_Set_PMKSA(u8 *bssid, struct wilc_priv *priv)
 			/*If bssid is found, set the values*/
 			s32Error = host_int_set_pmkid_info(priv->hWILCWFIDrv, &priv->pmkid_list);
 
-			if (s32Error != WILC_SUCCESS)
+			if (s32Error != 0)
 				PRINT_ER("Error in pmkid\n");
 
 			break;
@@ -693,7 +693,7 @@ static int set_channel(struct wiphy *wiphy,
 
 	u32 channelnum = 0;
 	struct wilc_priv *priv;
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 
 	priv = wiphy_priv(wiphy);
 
@@ -703,7 +703,7 @@ static int set_channel(struct wiphy *wiphy,
 	u8CurrChannel = channelnum;
 	s32Error   = host_int_set_mac_chnl_num(priv->hWILCWFIDrv, channelnum);
 
-	if (s32Error != WILC_SUCCESS)
+	if (s32Error != 0)
 		PRINT_ER("Error in setting channel %d\n", channelnum);
 
 	return s32Error;
@@ -730,7 +730,7 @@ static int scan(struct wiphy *wiphy, struct cfg80211_scan_request *request)
 {
 	struct wilc_priv *priv;
 	u32 i;
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 	u8 au8ScanChanList[MAX_NUM_SCANNED_NETWORKS];
 	tstrHiddenNetwork strHiddenNetwork;
 
@@ -795,7 +795,7 @@ static int scan(struct wiphy *wiphy, struct cfg80211_scan_request *request)
 			 " channels\n");
 	}
 
-	if (s32Error != WILC_SUCCESS) {
+	if (s32Error != 0) {
 		s32Error = -EBUSY;
 		PRINT_WRN(CFG80211_DBG, "Device is busy: Error(%d)\n", s32Error);
 	}
@@ -818,7 +818,7 @@ static int scan(struct wiphy *wiphy, struct cfg80211_scan_request *request)
 static int connect(struct wiphy *wiphy, struct net_device *dev,
 		   struct cfg80211_connect_params *sme)
 {
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 	u32 i;
 	u8 u8security = NO_ENCRYPT;
 	AUTHTYPE_T tenuAuth_type = ANY;
@@ -1049,7 +1049,7 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
 					 CfgConnectResult, (void *)priv, u8security,
 					 tenuAuth_type, pstrNetworkInfo->u8channel,
 					 pstrNetworkInfo->pJoinParams);
-	if (s32Error != WILC_SUCCESS) {
+	if (s32Error != 0) {
 		PRINT_ER("host_int_set_join_req(): Error(%d)\n", s32Error);
 		s32Error = -ENOENT;
 		goto done;
@@ -1072,7 +1072,7 @@ done:
  */
 static int disconnect(struct wiphy *wiphy, struct net_device *dev, u16 reason_code)
 {
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 	struct wilc_priv *priv;
 	#ifdef WILC_P2P
 	tstrWILC_WFIDrv *pstrWFIDrv;
@@ -1101,7 +1101,7 @@ static int disconnect(struct wiphy *wiphy, struct net_device *dev, u16 reason_co
 	#endif
 
 	s32Error = host_int_disconnect(priv->hWILCWFIDrv, reason_code);
-	if (s32Error != WILC_SUCCESS) {
+	if (s32Error != 0) {
 		PRINT_ER("Error in disconnecting: Error(%d)\n", s32Error);
 		s32Error = -EINVAL;
 	}
@@ -1124,7 +1124,7 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 		   const u8 *mac_addr, struct key_params *params)
 
 {
-	s32 s32Error = WILC_SUCCESS, KeyLen = params->key_len;
+	s32 s32Error = 0, KeyLen = params->key_len;
 	u32 i;
 	struct wilc_priv *priv;
 	const u8 *pu8RxMic = NULL;
@@ -1416,7 +1416,7 @@ static int del_key(struct wiphy *wiphy, struct net_device *netdev,
 		   const u8 *mac_addr)
 {
 	struct wilc_priv *priv;
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 
 	priv = wiphy_priv(wiphy);
 
@@ -1526,7 +1526,7 @@ static int get_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 		   const u8 *mac_addr, void *cookie, void (*callback)(void *cookie, struct key_params *))
 {
 
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 
 	struct wilc_priv *priv;
 	struct  key_params key_params;
@@ -1575,7 +1575,7 @@ static int get_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 static int set_default_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 			   bool unicast, bool multicast)
 {
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 	struct wilc_priv *priv;
 
 
@@ -1603,7 +1603,7 @@ static int set_default_key(struct wiphy *wiphy, struct net_device *netdev, u8 ke
 static int WILC_WFI_dump_survey(struct wiphy *wiphy, struct net_device *netdev,
 				int idx, struct survey_info *info)
 {
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 
 
 	if (idx != 0) {
@@ -1629,7 +1629,7 @@ static int WILC_WFI_dump_survey(struct wiphy *wiphy, struct net_device *netdev,
 static int get_station(struct wiphy *wiphy, struct net_device *dev,
 		       const u8 *mac, struct station_info *sinfo)
 {
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 	struct wilc_priv *priv;
 	perInterface_wlan_t *nic;
 	#ifdef WILC_AP_EXTERNAL_MLME
@@ -1811,7 +1811,7 @@ static int  WILC_WFI_disassoc(struct wiphy *wiphy, struct net_device *dev,
  */
 static int set_wiphy_params(struct wiphy *wiphy, u32 changed)
 {
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 	tstrCfgParamVal pstrCfgParamVal;
 	struct wilc_priv *priv;
 
@@ -1870,7 +1870,7 @@ static int WILC_WFI_set_bitrate_mask(struct wiphy *wiphy,
 				     struct net_device *dev, const u8 *peer,
 				     const struct cfg80211_bitrate_mask *mask)
 {
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 
 	PRINT_D(CFG80211_DBG, "Setting Bitrate mask function\n");
 	return s32Error;
@@ -1892,7 +1892,7 @@ static int set_pmksa(struct wiphy *wiphy, struct net_device *netdev,
 		     struct cfg80211_pmksa *pmksa)
 {
 	u32 i;
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 	u8 flag = 0;
 
 	struct wilc_priv *priv = wiphy_priv(wiphy);
@@ -1944,7 +1944,7 @@ static int del_pmksa(struct wiphy *wiphy, struct net_device *netdev,
 
 	u32 i;
 	u8 flag = 0;
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 
 	struct wilc_priv *priv = wiphy_priv(wiphy);
 
@@ -2334,7 +2334,7 @@ static int remain_on_channel(struct wiphy *wiphy,
 			     struct ieee80211_channel *chan,
 			     unsigned int duration, u64 *cookie)
 {
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 	struct wilc_priv *priv;
 
 	priv = wiphy_priv(wiphy);
@@ -2386,7 +2386,7 @@ static int cancel_remain_on_channel(struct wiphy *wiphy,
 				    struct wireless_dev *wdev,
 				    u64 cookie)
 {
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 	struct wilc_priv *priv;
 
 	priv = wiphy_priv(wiphy);
@@ -2434,7 +2434,7 @@ int mgmt_tx(struct wiphy *wiphy,
 	const struct ieee80211_mgmt *mgmt;
 	struct p2p_mgmt_data *mgmt_tx;
 	struct wilc_priv *priv;
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv;
 	u32 i;
 	perInterface_wlan_t *nic;
@@ -2454,13 +2454,13 @@ int mgmt_tx(struct wiphy *wiphy,
 		mgmt_tx = kmalloc(sizeof(struct p2p_mgmt_data), GFP_KERNEL);
 		if (mgmt_tx == NULL) {
 			PRINT_ER("Failed to allocate memory for mgmt_tx structure\n");
-			return WILC_FAIL;
+			return -EFAULT;
 		}
 		mgmt_tx->buff = kmalloc(buf_len, GFP_KERNEL);
 		if (mgmt_tx->buff == NULL) {
 			PRINT_ER("Failed to allocate memory for mgmt_tx buff\n");
 			kfree(mgmt_tx);
-			return WILC_FAIL;
+			return -EFAULT;
 		}
 		memcpy(mgmt_tx->buff, buf, len);
 		mgmt_tx->size = len;
@@ -2746,7 +2746,7 @@ int WILC_WFI_set_power_mgmt(struct wiphy *wiphy, struct net_device *dev,
 		host_int_set_power_mgmt(priv->hWILCWFIDrv, enabled, timeout);
 
 
-	return WILC_SUCCESS;
+	return 0;
 
 }
 #ifdef WILC_AP_EXTERNAL_MLME
@@ -2766,7 +2766,7 @@ int wilc1000_wlan_init(struct net_device *dev, perInterface_wlan_t *p_nic);
 static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 			       enum nl80211_iftype type, u32 *flags, struct vif_params *params)
 {
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 	struct wilc_priv *priv;
 	perInterface_wlan_t *nic;
 	u8 interface_type;
@@ -3146,7 +3146,7 @@ static int start_ap(struct wiphy *wiphy, struct net_device *dev,
 {
 	struct cfg80211_beacon_data *beacon = &(settings->beacon);
 	struct wilc_priv *priv;
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 
 	priv = wiphy_priv(wiphy);
 	PRINT_D(HOSTAPD_DBG, "Starting ap\n");
@@ -3156,7 +3156,7 @@ static int start_ap(struct wiphy *wiphy, struct net_device *dev,
 
 	s32Error = set_channel(wiphy, &settings->chandef);
 
-	if (s32Error != WILC_SUCCESS)
+	if (s32Error != 0)
 		PRINT_ER("Error in setting channel\n");
 
 	linux_wlan_set_bssid(dev, g_linux_wlan->strInterfaceInfo[0].aSrcAddress);
@@ -3186,7 +3186,7 @@ static int change_beacon(struct wiphy *wiphy, struct net_device *dev,
 			 struct cfg80211_beacon_data *beacon)
 {
 	struct wilc_priv *priv;
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 
 	priv = wiphy_priv(wiphy);
 	PRINT_D(HOSTAPD_DBG, "Setting beacon\n");
@@ -3212,7 +3212,7 @@ static int change_beacon(struct wiphy *wiphy, struct net_device *dev,
  */
 static int stop_ap(struct wiphy *wiphy, struct net_device *dev)
 {
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 	struct wilc_priv *priv;
 	u8 NullBssid[ETH_ALEN] = {0};
 
@@ -3246,7 +3246,7 @@ static int stop_ap(struct wiphy *wiphy, struct net_device *dev)
 static int add_station(struct wiphy *wiphy, struct net_device *dev,
 		       const u8 *mac, struct station_parameters *params)
 {
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 	struct wilc_priv *priv;
 	tstrWILC_AddStaParam strStaParams = { {0} };
 	perInterface_wlan_t *nic;
@@ -3316,7 +3316,7 @@ static int del_station(struct wiphy *wiphy, struct net_device *dev,
 		       struct station_del_parameters *params)
 {
 	const u8 *mac = params->mac;
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 	struct wilc_priv *priv;
 	perInterface_wlan_t *nic;
 
@@ -3357,7 +3357,7 @@ static int del_station(struct wiphy *wiphy, struct net_device *dev,
 static int change_station(struct wiphy *wiphy, struct net_device *dev,
 			  const u8 *mac, struct station_parameters *params)
 {
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 	struct wilc_priv *priv;
 	tstrWILC_AddStaParam strStaParams = { {0} };
 	perInterface_wlan_t *nic;
@@ -3468,7 +3468,7 @@ struct wireless_dev *add_virtual_intf(struct wiphy *wiphy, const char *name,
 int del_virtual_intf(struct wiphy *wiphy, struct wireless_dev *wdev)      /* tony for v3.8 support */
 {
 	PRINT_D(HOSTAPD_DBG, "Deleting virtual interface\n");
-	return WILC_SUCCESS;
+	return 0;
 }
 
 
@@ -3627,7 +3627,7 @@ struct wireless_dev *WILC_WFI_WiphyRegister(struct net_device *net)
 {
 	struct wilc_priv *priv;
 	struct wireless_dev *wdev;
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 
 	PRINT_D(CFG80211_DBG, "Registering wifi device\n");
 
@@ -3709,7 +3709,7 @@ struct wireless_dev *WILC_WFI_WiphyRegister(struct net_device *net)
 int WILC_WFI_InitHostInt(struct net_device *net)
 {
 
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 
 	struct wilc_priv *priv;
 
@@ -3750,7 +3750,7 @@ int WILC_WFI_InitHostInt(struct net_device *net)
  */
 int WILC_WFI_DeInitHostInt(struct net_device *net)
 {
-	s32 s32Error = WILC_SUCCESS;
+	s32 s32Error = 0;
 
 	struct wilc_priv *priv;
 
-- 
1.9.1

