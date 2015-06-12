Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:7034 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044AbbFLFMh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Jun 2015 01:12:37 -0400
From: Dean Lee <dean.lee@atmel.com>
To: <gregkh@linuxfoundation.org>, <devel@driverdev.osuosl.org>,
	<linux-wireless@vger.kernel.org>
CC: <johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <dean.lee@atmel.com>
Subject: [PATCH v2] staging: wilc1000: change WILC_BOOL to bool
Date: Fri, 12 Jun 2015 14:11:44 +0900
Message-ID: <1434085904-23472-1-git-send-email-dean.lee@atmel.com> (sfid-20150612_071243_541484_E6FBAB05)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

change own data type(WILC_BOOL) to common data type(bool)
but that's contain true/false value. so change with them.

Signed-off-by: Dean Lee <dean.lee@atmel.com>
---
Change
 remove WILC_BOOL structure.
---
 drivers/staging/wilc1000/coreconfigurator.c       |  26 ++--
 drivers/staging/wilc1000/coreconfigurator.h       |   4 +-
 drivers/staging/wilc1000/fifo_buffer.c            |   2 +-
 drivers/staging/wilc1000/fifo_buffer.h            |   2 +-
 drivers/staging/wilc1000/host_interface.c         | 166 +++++++++++-----------
 drivers/staging/wilc1000/host_interface.h         |  20 +--
 drivers/staging/wilc1000/linux_mon.c              |   6 +-
 drivers/staging/wilc1000/linux_wlan.c             |  20 +--
 drivers/staging/wilc1000/wilc_msgqueue.c          |   8 +-
 drivers/staging/wilc1000/wilc_oswrapper.h         |   6 -
 drivers/staging/wilc1000/wilc_platform.h          |   2 +-
 drivers/staging/wilc1000/wilc_spi.c               |   1 -
 drivers/staging/wilc1000/wilc_timer.h             |   4 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 136 +++++++++---------
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.h |   2 +-
 drivers/staging/wilc1000/wilc_wfi_netdevice.c     |   2 +-
 drivers/staging/wilc1000/wilc_wfi_netdevice.h     |   8 +-
 drivers/staging/wilc1000/wilc_wlan.c              |  34 ++---
 drivers/staging/wilc1000/wilc_wlan_cfg.c          |   4 +-
 19 files changed, 223 insertions(+), 230 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index c9cc817..9abc73d 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -145,7 +145,7 @@ typedef struct {
 	WILC_Char *pcRespBuffer;
 	s32 s32MaxRespBuffLen;
 	s32 s32BytesRead;
-	WILC_Bool bRespRequired;
+	bool bRespRequired;
 } tstrConfigPktInfo;
 
 
@@ -1520,7 +1520,7 @@ void ProcessBinWid(WILC_Char *pcPacket, s32 *ps32PktLen,
 s32 further_process_response(u8 *resp,
 				     u16 u16WIDid,
 				     u16 cfg_len,
-				     WILC_Bool process_wid_num,
+				     bool process_wid_num,
 				     u32 cnt,
 				     tstrWID *pstrWIDresult)
 {
@@ -1693,7 +1693,7 @@ s32 ParseResponse(u8 *resp, tstrWID *pstrWIDcfgResult)
 	u16 u16WIDid  = 0;
 	u16 cfg_len  = 0;
 	tenuWIDtype enuWIDtype = WID_UNDEF;
-	WILC_Bool num_wid_processed = WILC_FALSE;
+	bool num_wid_processed = false;
 	u32 cnt = 0;
 	u32 idx = 0;
 	u32 ResCnt = 0;
@@ -1717,17 +1717,17 @@ s32 ParseResponse(u8 *resp, tstrWID *pstrWIDcfgResult)
 			idx++;
 		}
 		idx += 3;
-		if ((u16WIDid == g_wid_num) && (num_wid_processed == WILC_FALSE)) {
-			num_wid_processed = WILC_TRUE;
+		if ((u16WIDid == g_wid_num) && (num_wid_processed == false)) {
+			num_wid_processed = true;
 
-			if (-2 == further_process_response(&resp[idx], u16WIDid, cfg_len, WILC_TRUE, 0, &pstrWIDcfgResult[ResCnt])) {
+			if (-2 == further_process_response(&resp[idx], u16WIDid, cfg_len, true, 0, &pstrWIDcfgResult[ResCnt])) {
 				return -2;
 			}
 			ResCnt++;
 		} else {
 			for (cnt = 0; cnt < g_num_total_switches; cnt++) {
 				if (gastrWIDs[cnt].u16WIDid == u16WIDid) {
-					if (-2 == further_process_response(&resp[idx], u16WIDid, cfg_len, WILC_FALSE, cnt,
+					if (-2 == further_process_response(&resp[idx], u16WIDid, cfg_len, false, cnt,
 									   &pstrWIDcfgResult[ResCnt])) {
 						return -2;
 					}
@@ -1913,7 +1913,7 @@ s32 CreateConfigPacket(s8 *ps8packet, s32 *ps32PacketLength,
 }
 
 s32 ConfigWaitResponse(WILC_Char *pcRespBuffer, s32 s32MaxRespBuffLen, s32 *ps32BytesRead,
-			       WILC_Bool bRespRequired)
+			       bool bRespRequired)
 {
 	s32 s32Error = WILC_SUCCESS;
 	/*bug 3878*/
@@ -1923,7 +1923,7 @@ s32 ConfigWaitResponse(WILC_Char *pcRespBuffer, s32 s32MaxRespBuffLen, s32 *ps32
 	 * gstrConfigPktInfo.bRespRequired = bRespRequired;*/
 
 
-	if (gstrConfigPktInfo.bRespRequired == WILC_TRUE) {
+	if (gstrConfigPktInfo.bRespRequired == true) {
 		down(&SemHandlePktResp);
 
 		*ps32BytesRead = gstrConfigPktInfo.s32BytesRead;
@@ -1950,7 +1950,7 @@ s32 ConfigWaitResponse(WILC_Char *pcRespBuffer, s32 s32MaxRespBuffLen, s32 *ps32
  */
 #ifdef SIMULATION
 s32 SendConfigPkt(u8 u8Mode, tstrWID *pstrWIDs,
-			  u32 u32WIDsCount, WILC_Bool bRespRequired, u32 drvHandler)
+			  u32 u32WIDsCount, bool bRespRequired, u32 drvHandler)
 {
 	s32 s32Error = WILC_SUCCESS;
 	s32 err = WILC_SUCCESS;
@@ -1984,7 +1984,7 @@ s32 SendConfigPkt(u8 u8Mode, tstrWID *pstrWIDs,
 	ConfigWaitResponse(gps8ConfigPacket, MAX_PACKET_BUFF_SIZE, &s32RcvdRespLen, bRespRequired);
 
 
-	if (bRespRequired == WILC_TRUE)	{
+	if (bRespRequired == true)	{
 		/* If the operating Mode is GET, then we expect a response frame from */
 		/* the driver. Hence start listening to the port for response         */
 		if (g_oper_mode == GET_CFG) {
@@ -2021,7 +2021,7 @@ s32 ConfigProvideResponse(WILC_Char *pcRespBuffer, s32 s32RespLen)
 {
 	s32 s32Error = WILC_SUCCESS;
 
-	if (gstrConfigPktInfo.bRespRequired == WILC_TRUE) {
+	if (gstrConfigPktInfo.bRespRequired == true) {
 		if (s32RespLen <= gstrConfigPktInfo.s32MaxRespBuffLen) {
 			WILC_memcpy(gstrConfigPktInfo.pcRespBuffer, pcRespBuffer, s32RespLen);
 			gstrConfigPktInfo.s32BytesRead = s32RespLen;
@@ -2129,7 +2129,7 @@ extern wilc_wlan_oup_t *gpstrWlanOps;
  *  @version	1.0
  */
 s32 SendConfigPkt(u8 u8Mode, tstrWID *pstrWIDs,
-			  u32 u32WIDsCount, WILC_Bool bRespRequired, u32 drvHandler)
+			  u32 u32WIDsCount, bool bRespRequired, u32 drvHandler)
 {
 	s32 counter = 0, ret = 0;
 	if (gpstrWlanOps == NULL) {
diff --git a/drivers/staging/wilc1000/coreconfigurator.h b/drivers/staging/wilc1000/coreconfigurator.h
index 63db151..6ed82e2 100644
--- a/drivers/staging/wilc1000/coreconfigurator.h
+++ b/drivers/staging/wilc1000/coreconfigurator.h
@@ -418,7 +418,7 @@ typedef struct {
 	u8 u8channel;
 	unsigned long u32TimeRcvdInScanCached; /* of type unsigned long to be accepted by the linux kernel macro time_after() */
 	unsigned long u32TimeRcvdInScan;
-	WILC_Bool bNewNetwork;
+	bool bNewNetwork;
 #ifdef AGING_ALG
 	u8 u8Found;
 #endif
@@ -476,7 +476,7 @@ extern s32 CoreConfiguratorInit(void);
 extern s32 CoreConfiguratorDeInit(void);
 
 extern s32 SendConfigPkt(u8 u8Mode, tstrWID *pstrWIDs,
-				 u32 u32WIDsCount, WILC_Bool bRespRequired, u32 drvHandler);
+				 u32 u32WIDsCount, bool bRespRequired, u32 drvHandler);
 extern s32 ParseNetworkInfo(u8 *pu8MsgBuffer, tstrNetworkInfo **ppstrNetworkInfo);
 extern s32 DeallocateNetworkInfo(tstrNetworkInfo *pstrNetworkInfo);
 
diff --git a/drivers/staging/wilc1000/fifo_buffer.c b/drivers/staging/wilc1000/fifo_buffer.c
index 788398c..c801406 100644
--- a/drivers/staging/wilc1000/fifo_buffer.c
+++ b/drivers/staging/wilc1000/fifo_buffer.c
@@ -86,7 +86,7 @@ u32 FIFO_ReadBytes(tHANDLE hFifo, u8 *pu8Buffer, u32 u32BytesToRead, u32 *pu32By
 	return u32Error;
 }
 
-u32 FIFO_WriteBytes(tHANDLE hFifo, u8 *pu8Buffer, u32 u32BytesToWrite, WILC_Bool bForceOverWrite)
+u32 FIFO_WriteBytes(tHANDLE hFifo, u8 *pu8Buffer, u32 u32BytesToWrite, bool bForceOverWrite)
 {
 	u32 u32Error = 0;
 	tstrFifoHandler *pstrFifoHandler = (tstrFifoHandler *) hFifo;
diff --git a/drivers/staging/wilc1000/fifo_buffer.h b/drivers/staging/wilc1000/fifo_buffer.h
index 912a333..57f7732 100644
--- a/drivers/staging/wilc1000/fifo_buffer.h
+++ b/drivers/staging/wilc1000/fifo_buffer.h
@@ -20,4 +20,4 @@ extern u32 FIFO_DeInit(tHANDLE hFifo);
 extern u32 FIFO_ReadBytes(tHANDLE hFifo, u8 *pu8Buffer,
 				u32 u32BytesToRead, u32 *pu32BytesRead);
 extern u32 FIFO_WriteBytes(tHANDLE hFifo, u8 *pu8Buffer,
-				u32 u32BytesToWrite, WILC_Bool bForceOverWrite);
+				u32 u32BytesToWrite, bool bForceOverWrite);
diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 8ee71ee..17ab5cd 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -11,7 +11,7 @@ extern u8 connecting;
 extern WILC_TimerHandle hDuringIpTimer;
 #endif
 
-extern WILC_Bool bEnablePS;
+extern bool bEnablePS;
 /*BugID_5137*/
 extern u8 g_wilc_initialized;
 /*****************************************************************************/
@@ -318,7 +318,7 @@ typedef struct _tstrHostIFDelBeacon {
  */
 
 typedef struct {
-	WILC_Bool bIsEnabled;
+	bool bIsEnabled;
 	u32 u32count;
 } tstrHostIFSetMulti;
 
@@ -379,7 +379,7 @@ typedef struct _tstrTimerCb {
  */
 typedef struct {
 
-	WILC_Bool bIsEnabled;
+	bool bIsEnabled;
 	u32 u32Timeout;
 } tstrHostIfPowerMgmtParam;
 
@@ -496,7 +496,7 @@ typedef struct _tstrJoinBssParam {
 	u8 ht_capable;
 	u8 wmm_cap;
 	u8 uapsd_cap;
-	WILC_Bool rsn_found;
+	bool rsn_found;
 	u8 rsn_grp_policy;
 	u8 mode_802_11i;
 	u8 rsn_pcip_policy[3];
@@ -540,7 +540,7 @@ typedef enum {
 tstrWILC_WFIDrv *terminated_handle = NULL;
 tstrWILC_WFIDrv *gWFiDrvHandle = NULL;
 #ifdef DISABLE_PWRSAVE_AND_SCAN_DURING_IP
-WILC_Bool g_obtainingIP = WILC_FALSE;
+bool g_obtainingIP = false;
 #endif
 u8 P2P_LISTEN_STATE;
 static struct task_struct *HostIFthreadHandler;
@@ -562,7 +562,7 @@ static u8 gapu8RcvdSurveyResults[2][MAX_SURVEY_RESULT_FRAG_SIZE];
 
 static u8 gapu8RcvdAssocResp[MAX_ASSOC_RESP_FRAME_SIZE];
 
-WILC_Bool gbScanWhileConnected = WILC_FALSE;
+bool gbScanWhileConnected = false;
 
 static s8 gs8Rssi;
 static s8 gs8lnkspd;
@@ -622,7 +622,7 @@ static s32 Handle_SetChannel(void *drvHandler, tstrHostIFSetChan *pstrHostIFSetC
 
 	PRINT_D(HOSTINF_DBG, "Setting channel\n");
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, WILC_TRUE, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
 	if (s32Error) {
 		PRINT_ER("Failed to set channel\n");
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_STATE);
@@ -659,7 +659,7 @@ static s32 Handle_SetWfiDrvHandler(tstrHostIfSetDrvHandler *pstrHostIfSetDrvHand
 
 	/*Sending Cfg*/
 
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, WILC_TRUE, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
 
 
 	if ((pstrHostIfSetDrvHandler->u32Address) == (u32)NULL) {
@@ -705,7 +705,7 @@ static s32 Handle_SetOperationMode(void *drvHandler, tstrHostIfSetOperationMode
 	/*Sending Cfg*/
 	PRINT_INFO(HOSTINF_DBG, "pstrWFIDrv= %p \n", pstrWFIDrv);
 
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, WILC_TRUE, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
 
 
 	if ((pstrHostIfSetOperationMode->u32Mode) == (u32)NULL) {
@@ -755,7 +755,7 @@ s32 Handle_set_IPAddress(void *drvHandler, u8 *pu8IPAddr, u8 idx)
 	strWID.ps8WidVal = (u8 *)pu8IPAddr;
 	strWID.s32ValueSize = IP_ALEN;
 
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, WILC_TRUE, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
 
 
 
@@ -799,7 +799,7 @@ s32 Handle_get_IPAddress(void *drvHandler, u8 *pu8IPAddr, u8 idx)
 	strWID.ps8WidVal = (u8 *)WILC_MALLOC(IP_ALEN);
 	strWID.s32ValueSize = IP_ALEN;
 
-	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, WILC_TRUE, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
 
 	PRINT_INFO(HOSTINF_DBG, "%d.%d.%d.%d\n", (u8)(strWID.ps8WidVal[0]), (u8)(strWID.ps8WidVal[1]), (u8)(strWID.ps8WidVal[2]), (u8)(strWID.ps8WidVal[3]));
 
@@ -859,7 +859,7 @@ static s32 Handle_SetMacAddress(void *drvHandler, tstrHostIfSetMacAddress *pstrH
 	strWID.s32ValueSize = ETH_ALEN;
 	PRINT_D(GENERIC_DBG, "mac addr = :%x:%x:%x:%x:%x:%x\n", strWID.ps8WidVal[0], strWID.ps8WidVal[1], strWID.ps8WidVal[2], strWID.ps8WidVal[3], strWID.ps8WidVal[4], strWID.ps8WidVal[5]);
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, WILC_TRUE, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
 	if (s32Error) {
 		PRINT_ER("Failed to set mac address\n");
 		WILC_ERRORREPORT(s32Error, WILC_FAIL);
@@ -897,7 +897,7 @@ static s32 Handle_GetMacAddress(void *drvHandler, tstrHostIfGetMacAddress *pstrH
 	strWID.s32ValueSize = ETH_ALEN;
 
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, WILC_FALSE, (u32)drvHandler);
+	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, false, (u32)drvHandler);
 	if (s32Error) {
 		PRINT_ER("Failed to get mac address\n");
 		WILC_ERRORREPORT(s32Error, WILC_FAIL);
@@ -1205,7 +1205,7 @@ static s32 Handle_CfgParam(void *drvHandler, tstrHostIFCfgParamAttr *strHostIFCf
 		}
 		u8WidCnt++;
 	}
-	s32Error = SendConfigPkt(SET_CFG, strWIDList, u8WidCnt, WILC_FALSE, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, strWIDList, u8WidCnt, false, (u32)pstrWFIDrv);
 
 	if (s32Error) {
 		PRINT_ER("Error in setting CFG params\n");
@@ -1367,12 +1367,12 @@ static s32 Handle_Scan(void *drvHandler, tstrHostIFscanAttr *pstrHostIFscanAttr)
 	/* gWFiDrvHandle->enuHostIFstate = HOST_IF_SCANNING; */
 
 	if (pstrWFIDrv->enuHostIFstate == HOST_IF_CONNECTED) {
-		gbScanWhileConnected = WILC_TRUE;
+		gbScanWhileConnected = true;
 	} else if (pstrWFIDrv->enuHostIFstate == HOST_IF_IDLE)	  {
-		gbScanWhileConnected = WILC_FALSE;
+		gbScanWhileConnected = false;
 	}
 
-	s32Error = SendConfigPkt(SET_CFG, strWIDList, u32WidsCount, WILC_FALSE, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, strWIDList, u32WidsCount, false, (u32)pstrWFIDrv);
 
 	if (s32Error) {
 		PRINT_ER("Failed to send scan paramters config packet\n");
@@ -1450,7 +1450,7 @@ static s32 Handle_ScanDone(void *drvHandler, tenuScanEvent enuEvent)
 		strWID.s32ValueSize = sizeof(WILC_Char);
 
 		/*Sending Cfg*/
-		s32Error = SendConfigPkt(SET_CFG, &strWID, 1, WILC_TRUE, (u32)pstrWFIDrv);
+		s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
 		if (s32Error != WILC_SUCCESS) {
 			PRINT_ER("Failed to set abort running scan\n");
 			WILC_ERRORREPORT(s32Error, WILC_FAIL);
@@ -1649,7 +1649,7 @@ static s32 Handle_Connect(void *drvHandler, tstrHostIFconnectAttr *pstrHostIFcon
 		/* ////////////////////// */
 		#endif
 
-		s32Error = SendConfigPkt(SET_CFG, strWIDList, u32WidsCount, WILC_FALSE, (u32)pstrWFIDrv);
+		s32Error = SendConfigPkt(SET_CFG, strWIDList, u32WidsCount, false, (u32)pstrWFIDrv);
 		if (s32Error) {
 			PRINT_ER("Handle_Connect()] failed to send config packet\n");
 			WILC_ERRORREPORT(s32Error, WILC_INVALID_STATE);
@@ -1990,7 +1990,7 @@ static s32 Handle_Connect(void *drvHandler, tstrHostIFconnectAttr *pstrHostIFcon
 		PRINT_D(GENERIC_DBG, "save bssid = %x:%x:%x:%x:%x:%x\n", (u8ConnectedSSID[0]), (u8ConnectedSSID[1]), (u8ConnectedSSID[2]), (u8ConnectedSSID[3]), (u8ConnectedSSID[4]), (u8ConnectedSSID[5]));
 	}
 
-	s32Error = SendConfigPkt(SET_CFG, strWIDList, u32WidsCount, WILC_FALSE, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, strWIDList, u32WidsCount, false, (u32)pstrWFIDrv);
 	if (s32Error) {
 		PRINT_ER("Handle_Connect()] failed to send config packet\n");
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_STATE);
@@ -2121,7 +2121,7 @@ static s32 Handle_FlushConnect(void *drvHandler)
 
 	#endif
 
-	s32Error = SendConfigPkt(SET_CFG, strWIDList, u32WidsCount, WILC_FALSE, gu8FlushedJoinReqDrvHandler);
+	s32Error = SendConfigPkt(SET_CFG, strWIDList, u32WidsCount, false, gu8FlushedJoinReqDrvHandler);
 	if (s32Error) {
 		PRINT_ER("Handle_Flush_Connect()] failed to send config packet\n");
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_STATE);
@@ -2159,7 +2159,7 @@ static s32 Handle_ConnectTimeout(void *drvHandler)
 
 	pstrWFIDrv->enuHostIFstate = HOST_IF_IDLE;
 
-	gbScanWhileConnected = WILC_FALSE;
+	gbScanWhileConnected = false;
 
 
 	WILC_memset(&strConnectInfo, 0, sizeof(tstrConnectInfo));
@@ -2206,7 +2206,7 @@ static s32 Handle_ConnectTimeout(void *drvHandler)
 
 	PRINT_D(HOSTINF_DBG, "Sending disconnect request\n");
 
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, WILC_FALSE, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false, (u32)pstrWFIDrv);
 	if (s32Error) {
 		PRINT_ER("Failed to send dissconect config packet\n");
 	}
@@ -2256,7 +2256,7 @@ static s32 Handle_ConnectTimeout(void *drvHandler)
 static s32 Handle_RcvdNtwrkInfo(void *drvHandler, tstrRcvdNetworkInfo *pstrRcvdNetworkInfo)
 {
 	u32 i;
-	WILC_Bool bNewNtwrkFound;
+	bool bNewNtwrkFound;
 
 
 
@@ -2268,7 +2268,7 @@ static s32 Handle_RcvdNtwrkInfo(void *drvHandler, tstrRcvdNetworkInfo *pstrRcvdN
 
 
 
-	bNewNtwrkFound = WILC_TRUE;
+	bNewNtwrkFound = true;
 	PRINT_INFO(HOSTINF_DBG, "Handling received network info\n");
 
 	/*if there is a an ongoing scan request*/
@@ -2297,14 +2297,14 @@ static s32 Handle_RcvdNtwrkInfo(void *drvHandler, tstrRcvdNetworkInfo *pstrRcvdN
 						 *   the rssi for this cached network and send this updated network to the upper layer but
 						 *   don't add a new record for it */
 						pstrWFIDrv->strWILC_UsrScanReq.astrFoundNetworkInfo[i].s8rssi = pstrNetworkInfo->s8rssi;
-						bNewNtwrkFound = WILC_FALSE;
+						bNewNtwrkFound = false;
 						break;
 					}
 				}
 			}
 		}
 
-		if (bNewNtwrkFound == WILC_TRUE) {
+		if (bNewNtwrkFound == true) {
 			/* here it is confirmed that it is a new discovered network,
 			 * so add its record then call the User CallBack function */
 
@@ -2320,7 +2320,7 @@ static s32 Handle_RcvdNtwrkInfo(void *drvHandler, tstrRcvdNetworkInfo *pstrRcvdN
 
 					pstrWFIDrv->strWILC_UsrScanReq.u32RcvdChCount++;
 
-					pstrNetworkInfo->bNewNetwork = WILC_TRUE;
+					pstrNetworkInfo->bNewNetwork = true;
 					/*Bug4218: Parsing Join Param*/
 					/* add new BSS to JoinBssTable */
 				#ifdef WILC_PARSE_SCAN_IN_HOST
@@ -2337,7 +2337,7 @@ static s32 Handle_RcvdNtwrkInfo(void *drvHandler, tstrRcvdNetworkInfo *pstrRcvdN
 				PRINT_WRN(HOSTINF_DBG, "Discovered networks exceeded max. limit \n");
 			}
 		} else {
-			pstrNetworkInfo->bNewNetwork = WILC_FALSE;
+			pstrNetworkInfo->bNewNetwork = false;
 			/* just call the User CallBack function to send the same discovered network with its updated RSSI */
 			pstrWFIDrv->strWILC_UsrScanReq.pfUserScanResult(SCAN_EVENT_NETWORK_FOUND, pstrNetworkInfo,
 									pstrWFIDrv->strWILC_UsrScanReq.u32UserScanPvoid, NULL);
@@ -2541,7 +2541,7 @@ static s32 Handle_RcvdGnrlAsyncInfo(void *drvHandler, tstrRcvdGnrlAsyncInfo *pst
 
 				#ifdef DISABLE_PWRSAVE_AND_SCAN_DURING_IP
 				PRINT_D(GENERIC_DBG, "Obtaining an IP, Disable Scan\n");
-				g_obtainingIP = WILC_TRUE;
+				g_obtainingIP = true;
 				WILC_TimerStart(&hDuringIpTimer, 10000, NULL, NULL);
 				#endif
 
@@ -2556,7 +2556,7 @@ static s32 Handle_RcvdGnrlAsyncInfo(void *drvHandler, tstrRcvdGnrlAsyncInfo *pst
 			} else {
 				PRINT_D(HOSTINF_DBG, "MAC status : %d and Connect Status : %d\n", u8MacStatus, strConnectInfo.u16ConnectStatus);
 				pstrWFIDrv->enuHostIFstate = HOST_IF_IDLE;
-				gbScanWhileConnected = WILC_FALSE;
+				gbScanWhileConnected = false;
 			}
 
 			/* Deallocation */
@@ -2608,7 +2608,7 @@ static s32 Handle_RcvdGnrlAsyncInfo(void *drvHandler, tstrRcvdGnrlAsyncInfo *pst
 			if (pstrWFIDrv->strWILC_UsrConnReq.pfUserConnectResult != NULL)	{
 				#ifdef DISABLE_PWRSAVE_AND_SCAN_DURING_IP
 
-				g_obtainingIP = WILC_FALSE;
+				g_obtainingIP = false;
 				host_int_set_power_mgmt((WILC_WFIDrvHandle)pstrWFIDrv, 0, 0);
 				#endif
 
@@ -2667,7 +2667,7 @@ static s32 Handle_RcvdGnrlAsyncInfo(void *drvHandler, tstrRcvdGnrlAsyncInfo *pst
 			}
 
 			pstrWFIDrv->enuHostIFstate = HOST_IF_IDLE;
-			gbScanWhileConnected = WILC_FALSE;
+			gbScanWhileConnected = false;
 
 		} else if ((u8MacStatus == MAC_DISCONNECTED) &&
 			   (pstrWFIDrv->strWILC_UsrScanReq.pfUserScanResult != NULL)) {
@@ -2767,7 +2767,7 @@ static int Handle_Key(void *drvHandler, tstrHostIFkeyAttr *pstrHostIFkeyAttr)
 			strWIDList[3].ps8WidVal = (s8 *)pu8keybuf;
 
 
-			s32Error = SendConfigPkt(SET_CFG, strWIDList, 4, WILC_TRUE, (u32)pstrWFIDrv);
+			s32Error = SendConfigPkt(SET_CFG, strWIDList, 4, true, (u32)pstrWFIDrv);
 			WILC_FREE(pu8keybuf);
 
 
@@ -2795,7 +2795,7 @@ static int Handle_Key(void *drvHandler, tstrHostIFkeyAttr *pstrHostIFkeyAttr)
 			strWID.ps8WidVal	= (s8 *)pu8keybuf;
 			strWID.s32ValueSize = pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwepAttr.u8WepKeylen + 2;
 
-			s32Error = SendConfigPkt(SET_CFG, &strWID, 1, WILC_TRUE, (u32)pstrWFIDrv);
+			s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
 			WILC_FREE(pu8keybuf);
 		} else if (pstrHostIFkeyAttr->u8KeyAction & REMOVEKEY)	  {
 
@@ -2807,7 +2807,7 @@ static int Handle_Key(void *drvHandler, tstrHostIFkeyAttr *pstrHostIFkeyAttr)
 			strWID.ps8WidVal = s8idxarray;
 			strWID.s32ValueSize = 1;
 
-			s32Error = SendConfigPkt(SET_CFG, &strWID, 1, WILC_TRUE, (u32)pstrWFIDrv);
+			s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
 		} else {
 			strWID.u16WIDid	= (u16)WID_KEY_ID;
 			strWID.enuWIDtype	= WID_CHAR;
@@ -2816,7 +2816,7 @@ static int Handle_Key(void *drvHandler, tstrHostIFkeyAttr *pstrHostIFkeyAttr)
 
 			PRINT_D(HOSTINF_DBG, "Setting default key index\n");
 
-			s32Error = SendConfigPkt(SET_CFG, &strWID, 1, WILC_TRUE, (u32)pstrWFIDrv);
+			s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
 		}
 		up(&(pstrWFIDrv->hSemTestKeyBlock));
 		break;
@@ -2862,7 +2862,7 @@ static int Handle_Key(void *drvHandler, tstrHostIFkeyAttr *pstrHostIFkeyAttr)
 			strWIDList[1].ps8WidVal	= (s8 *)pu8keybuf;
 			strWIDList[1].s32ValueSize = RX_MIC_KEY_MSG_LEN;
 
-			s32Error = SendConfigPkt(SET_CFG, strWIDList, 2, WILC_TRUE, (u32)pstrWFIDrv);
+			s32Error = SendConfigPkt(SET_CFG, strWIDList, 2, true, (u32)pstrWFIDrv);
 
 			WILC_FREE(pu8keybuf);
 
@@ -2909,7 +2909,7 @@ static int Handle_Key(void *drvHandler, tstrHostIFkeyAttr *pstrHostIFkeyAttr)
 			strWID.ps8WidVal	= (s8 *)pu8keybuf;
 			strWID.s32ValueSize = RX_MIC_KEY_MSG_LEN;
 
-			s32Error = SendConfigPkt(SET_CFG, &strWID, 1, WILC_TRUE, (u32)pstrWFIDrv);
+			s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
 
 			WILC_FREE(pu8keybuf);
 
@@ -2966,7 +2966,7 @@ _WPARxGtk_end_case_:
 			strWIDList[1].ps8WidVal	= (s8 *)pu8keybuf;
 			strWIDList[1].s32ValueSize = PTK_KEY_MSG_LEN + 1;
 
-			s32Error = SendConfigPkt(SET_CFG, strWIDList, 2, WILC_TRUE, (u32)pstrWFIDrv);
+			s32Error = SendConfigPkt(SET_CFG, strWIDList, 2, true, (u32)pstrWFIDrv);
 			WILC_FREE(pu8keybuf);
 
 			/* ////////////////////////// */
@@ -3007,7 +3007,7 @@ _WPARxGtk_end_case_:
 			strWID.ps8WidVal	= (s8 *)pu8keybuf;
 			strWID.s32ValueSize = PTK_KEY_MSG_LEN;
 
-			s32Error = SendConfigPkt(SET_CFG, &strWID, 1, WILC_TRUE, (u32)pstrWFIDrv);
+			s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
 			WILC_FREE(pu8keybuf);
 
 			/* ////////////////////////// */
@@ -3046,7 +3046,7 @@ _WPAPtk_end_case_:
 		strWID.ps8WidVal = (s8 *)pu8keybuf;
 		strWID.s32ValueSize = (pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFpmkidAttr.numpmkid * PMKSA_KEY_LEN) + 1;
 
-		s32Error = SendConfigPkt(SET_CFG, &strWID, 1, WILC_TRUE, (u32)pstrWFIDrv);
+		s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
 
 		WILC_FREE(pu8keybuf);
 		break;
@@ -3089,13 +3089,13 @@ static void Handle_Disconnect(void *drvHandler)
 
 	#ifdef DISABLE_PWRSAVE_AND_SCAN_DURING_IP
 
-	g_obtainingIP = WILC_FALSE;
+	g_obtainingIP = false;
 	host_int_set_power_mgmt((WILC_WFIDrvHandle)pstrWFIDrv, 0, 0);
 	#endif
 
 	WILC_memset(u8ConnectedSSID, 0, ETH_ALEN);
 
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, WILC_FALSE, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false, (u32)pstrWFIDrv);
 
 	if (s32Error) {
 		PRINT_ER("Failed to send dissconect config packet\n");
@@ -3132,7 +3132,7 @@ static void Handle_Disconnect(void *drvHandler)
 			PRINT_ER("strWILC_UsrConnReq.pfUserConnectResult = NULL \n");
 		}
 
-		gbScanWhileConnected = WILC_FALSE;
+		gbScanWhileConnected = false;
 
 		pstrWFIDrv->enuHostIFstate = HOST_IF_IDLE;
 
@@ -3208,7 +3208,7 @@ static s32 Switch_Log_Terminal(void *drvHandler)
 	strWID.ps8WidVal = &dummy;
 	strWID.s32ValueSize = sizeof(WILC_Char);
 
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, WILC_TRUE, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
 
 
 	if (s32Error) {
@@ -3252,7 +3252,7 @@ static s32 Handle_GetChnl(void *drvHandler)
 
 	PRINT_D(HOSTINF_DBG, "Getting channel value\n");
 
-	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, WILC_TRUE, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
 	/*get the value by searching the local copy*/
 	if (s32Error) {
 		PRINT_ER("Failed to get channel number\n");
@@ -3296,7 +3296,7 @@ static void Handle_GetRssi(void *drvHandler)
 	/*Sending Cfg*/
 	PRINT_D(HOSTINF_DBG, "Getting RSSI value\n");
 
-	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, WILC_TRUE, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
 	if (s32Error) {
 		PRINT_ER("Failed to get RSSI value\n");
 		WILC_ERRORREPORT(s32Error, WILC_FAIL);
@@ -3327,7 +3327,7 @@ static void Handle_GetLinkspeed(void *drvHandler)
 	/*Sending Cfg*/
 	PRINT_D(HOSTINF_DBG, "Getting LINKSPEED value\n");
 
-	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, WILC_TRUE, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
 	if (s32Error) {
 		PRINT_ER("Failed to get LINKSPEED value\n");
 		WILC_ERRORREPORT(s32Error, WILC_FAIL);
@@ -3377,7 +3377,7 @@ s32 Handle_GetStatistics(void *drvHandler, tstrStatistics *pstrStatistics)
 	strWIDList[u32WidsCount].ps8WidVal = (s8 *)(&(pstrStatistics->u32TxFailureCount));
 	u32WidsCount++;
 
-	s32Error = SendConfigPkt(GET_CFG, strWIDList, u32WidsCount, WILC_FALSE, (u32)drvHandler);
+	s32Error = SendConfigPkt(GET_CFG, strWIDList, u32WidsCount, false, (u32)drvHandler);
 
 	if (s32Error) {
 		PRINT_ER("Failed to send scan paramters config packet\n");
@@ -3425,7 +3425,7 @@ static s32 Handle_Get_InActiveTime(void *drvHandler, tstrHostIfStaInactiveT *str
 	PRINT_D(CFG80211_DBG, "SETING STA inactive time\n");
 
 
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, WILC_TRUE, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
 	/*get the value by searching the local copy*/
 	if (s32Error) {
 		PRINT_ER("Failed to SET incative time\n");
@@ -3439,7 +3439,7 @@ static s32 Handle_Get_InActiveTime(void *drvHandler, tstrHostIfStaInactiveT *str
 	strWID.s32ValueSize = sizeof(u32);
 
 
-	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, WILC_TRUE, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
 	/*get the value by searching the local copy*/
 	if (s32Error) {
 		PRINT_ER("Failed to get incative time\n");
@@ -3520,7 +3520,7 @@ static void Handle_AddBeacon(void *drvHandler, tstrHostIFSetBeacon *pstrSetBeaco
 
 
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, WILC_FALSE, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false, (u32)pstrWFIDrv);
 	if (s32Error) {
 		PRINT_ER("Failed to send add beacon config packet\n");
 		WILC_ERRORREPORT(s32Error, WILC_FAIL);
@@ -3565,7 +3565,7 @@ static void Handle_DelBeacon(void *drvHandler, tstrHostIFDelBeacon *pstrDelBeaco
 	/* TODO: build del beacon message*/
 
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, WILC_FALSE, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false, (u32)pstrWFIDrv);
 	if (s32Error) {
 
 		PRINT_ER("Failed to send delete beacon config packet\n");
@@ -3662,7 +3662,7 @@ static void Handle_AddStation(void *drvHandler, tstrWILC_AddStaParam *pstrStatio
 	pu8CurrByte += WILC_HostIf_PackStaParam(pu8CurrByte, pstrStationParam);
 
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, WILC_FALSE, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false, (u32)pstrWFIDrv);
 	if (s32Error != WILC_SUCCESS) {
 
 		PRINT_ER("Failed to send add station config packet\n");
@@ -3718,7 +3718,7 @@ static void Handle_DelAllSta(void *drvHandler, tstrHostIFDelAllSta *pstrDelAllSt
 	}
 
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, WILC_TRUE, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
 	if (s32Error) {
 
 		PRINT_ER("Failed to send add station config packe\n");
@@ -3766,7 +3766,7 @@ static void Handle_DelStation(void *drvHandler, tstrHostIFDelSta *pstrDelStaPara
 	WILC_memcpy(pu8CurrByte, pstrDelStaParam->au8MacAddr, ETH_ALEN);
 
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, WILC_FALSE, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false, (u32)pstrWFIDrv);
 	if (s32Error) {
 
 		PRINT_ER("Failed to send add station config packe\n");
@@ -3810,7 +3810,7 @@ static void Handle_EditStation(void *drvHandler, tstrWILC_AddStaParam *pstrStati
 	pu8CurrByte += WILC_HostIf_PackStaParam(pu8CurrByte, pstrStationParam);
 
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, WILC_FALSE, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false, (u32)pstrWFIDrv);
 	if (s32Error) {
 
 		PRINT_ER("Failed to send edit station config packet\n");
@@ -3873,7 +3873,7 @@ static int Handle_RemainOnChan(void *drvHandler, tstrHostIfRemainOnChan *pstrHos
 
 	PRINT_D(HOSTINF_DBG, "Setting channel :%d\n", pstrHostIfRemainOnChan->u16Channel);
 
-	u8remain_on_chan_flag = WILC_TRUE;
+	u8remain_on_chan_flag = true;
 	strWID.u16WIDid	= (u16)WID_REMAIN_ON_CHAN;
 	strWID.enuWIDtype	= WID_STR;
 	strWID.s32ValueSize = 2;
@@ -3887,7 +3887,7 @@ static int Handle_RemainOnChan(void *drvHandler, tstrHostIfRemainOnChan *pstrHos
 	strWID.ps8WidVal[1] = (s8)pstrHostIfRemainOnChan->u16Channel;
 
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, WILC_TRUE, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
 	if (s32Error != WILC_SUCCESS) {
 		PRINT_ER("Failed to set remain on channel\n");
 	}
@@ -3945,7 +3945,7 @@ static int Handle_RegisterFrame(void *drvHandler, tstrHostIfRegisterFrame *pstrH
 
 
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, WILC_TRUE, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
 	if (s32Error) {
 		PRINT_ER("Failed to frame register config packet\n");
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_STATE);
@@ -3983,7 +3983,7 @@ static u32 Handle_ListenStateExpired(void *drvHandler, tstrHostIfRemainOnChan *p
 	/*Make sure we are already in listen state*/
 	/*This is to handle duplicate expiry messages (listen timer fired and supplicant called cancel_remain_on_channel())*/
 	if (P2P_LISTEN_STATE) {
-		u8remain_on_chan_flag = WILC_FALSE;
+		u8remain_on_chan_flag = false;
 		strWID.u16WIDid	= (u16)WID_REMAIN_ON_CHAN;
 		strWID.enuWIDtype	= WID_STR;
 		strWID.s32ValueSize = 2;
@@ -3997,7 +3997,7 @@ static u32 Handle_ListenStateExpired(void *drvHandler, tstrHostIfRemainOnChan *p
 		strWID.ps8WidVal[1] = FALSE_FRMWR_CHANNEL;
 
 		/*Sending Cfg*/
-		s32Error = SendConfigPkt(SET_CFG, &strWID, 1, WILC_TRUE, (u32)pstrWFIDrv);
+		s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
 		if (s32Error != WILC_SUCCESS) {
 			PRINT_ER("Failed to set remain on channel\n");
 			goto _done_;
@@ -4071,7 +4071,7 @@ static void Handle_PowerManagement(void *drvHandler, tstrHostIfPowerMgmtParam *s
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
 	strWID.u16WIDid = (u16)WID_POWER_MANAGEMENT;
 
-	if (strPowerMgmtParam->bIsEnabled == WILC_TRUE)	{
+	if (strPowerMgmtParam->bIsEnabled == true)	{
 		s8PowerMode = MIN_FAST_PS;
 	} else {
 		s8PowerMode = NO_POWERSAVE;
@@ -4083,7 +4083,7 @@ static void Handle_PowerManagement(void *drvHandler, tstrHostIfPowerMgmtParam *s
 	PRINT_D(HOSTINF_DBG, "Handling Power Management\n");
 
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, WILC_TRUE, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
 	if (s32Error) {
 		PRINT_ER("Failed to send power management config packet\n");
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_STATE);
@@ -4135,7 +4135,7 @@ static void Handle_SetMulticastFilter(void *drvHandler, tstrHostIFSetMulti *strH
 		memcpy(pu8CurrByte, gau8MulticastMacAddrList, ((strHostIfSetMulti->u32count) * ETH_ALEN));
 
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, WILC_FALSE, (u32)drvHandler);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false, (u32)drvHandler);
 	if (s32Error) {
 		PRINT_ER("Failed to send setup multicast config packet\n");
 		WILC_ERRORREPORT(s32Error, WILC_FAIL);
@@ -4203,7 +4203,7 @@ static s32 Handle_AddBASession(void *drvHandler, tstrHostIfBASessionInfo *strHos
 	/* Group Buffer Timeout */
 	*ptr++ = 0;
 
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, WILC_TRUE, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
 	if (s32Error)
 		PRINT_D(HOSTINF_DBG, "Couldn't open BA Session\n");
 
@@ -4227,7 +4227,7 @@ static s32 Handle_AddBASession(void *drvHandler, tstrHostIfBASessionInfo *strHos
 	*ptr++ = ((strHostIfBASessionInfo->u16SessionTimeout >> 16) & 0xFF);
 	/*Ack-Policy */
 	*ptr++ = 3;
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, WILC_TRUE, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
 
 	if (strWID.ps8WidVal != NULL)
 		WILC_FREE(strWID.ps8WidVal);
@@ -4277,7 +4277,7 @@ static s32 Handle_DelBASession(void *drvHandler, tstrHostIfBASessionInfo *strHos
 	/* Delba Reason */
 	*ptr++ = 32; /* Unspecific QOS reason */
 
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, WILC_TRUE, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
 	if (s32Error)
 		PRINT_D(HOSTINF_DBG, "Couldn't delete BA Session\n");
 
@@ -4295,7 +4295,7 @@ static s32 Handle_DelBASession(void *drvHandler, tstrHostIfBASessionInfo *strHos
 	/* TID*/
 	*ptr++ = strHostIfBASessionInfo->u8Ted;
 
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, WILC_TRUE, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
 
 	if (strWID.ps8WidVal != NULL)
 		WILC_FREE(strWID.ps8WidVal);
@@ -4346,7 +4346,7 @@ static s32 Handle_DelAllRxBASessions(void *drvHandler, tstrHostIfBASessionInfo *
 	/* Delba Reason */
 	*ptr++ = 32; /* Unspecific QOS reason */
 
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, WILC_TRUE, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
 	if (s32Error)
 		PRINT_D(HOSTINF_DBG, "Couldn't delete BA Session\n");
 
@@ -5443,7 +5443,7 @@ s32 host_int_get_site_survey_results(WILC_WFIDrvHandle hWFIDrv,
 	astrWIDList[1].ps8WidVal = ppu8RcvdSiteSurveyResults[1];
 	astrWIDList[1].s32ValueSize = u32MaxSiteSrvyFragLen;
 
-	s32Error = SendConfigPkt(GET_CFG, astrWIDList, 2, WILC_TRUE, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(GET_CFG, astrWIDList, 2, true, (u32)pstrWFIDrv);
 
 	/*get the value by searching the local copy*/
 	if (s32Error) {
@@ -5811,7 +5811,7 @@ s32 host_int_get_assoc_res_info(WILC_WFIDrvHandle hWFIDrv, u8 *pu8AssocRespInfo,
 
 
 	/* Sending Configuration packet */
-	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, WILC_TRUE, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
 	if (s32Error) {
 		PRINT_ER("Failed to send association response config packet\n");
 		*pu32RcvdAssocRespInfoLen = 0;
@@ -6062,7 +6062,7 @@ s32 host_int_test_set_int_wid(WILC_WFIDrvHandle hWFIDrv, u32 u32TestMemAddr)
 	strWID.s32ValueSize = sizeof(u32);
 
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, WILC_TRUE, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
 	if (s32Error) {
 		PRINT_ER("Test Function: Failed to set wid value\n");
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_STATE);
@@ -6154,7 +6154,7 @@ s32 host_int_test_get_int_wid(WILC_WFIDrvHandle hWFIDrv, u32 *pu32TestMemAddr)
 	strWID.ps8WidVal = (s8 *)pu32TestMemAddr;
 	strWID.s32ValueSize = sizeof(u32);
 
-	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, WILC_TRUE, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
 	/*get the value by searching the local copy*/
 	if (s32Error) {
 		PRINT_ER("Test Function: Failed to get wid value\n");
@@ -6531,7 +6531,7 @@ s32 hif_get_cfg(WILC_WFIDrvHandle hWFIDrv, u16 u16WID, u16 *pu16WID_Value)
  *  @version		1.0
  */
 void host_int_send_join_leave_info_to_host
-	(u16 assocId, u8 *stationAddr, WILC_Bool joining)
+	(u16 assocId, u8 *stationAddr, bool joining)
 {
 }
 /**
@@ -6607,7 +6607,7 @@ s32 host_int_init(WILC_WFIDrvHandle *phWFIDrv)
 	 * }	*/
 	PRINT_D(HOSTINF_DBG, "Initializing host interface for client %d\n", clients_count + 1);
 
-	gbScanWhileConnected = WILC_FALSE;
+	gbScanWhileConnected = false;
 
 	sema_init(&hWaitResponse, 0);
 
@@ -6628,7 +6628,7 @@ s32 host_int_init(WILC_WFIDrvHandle *phWFIDrv)
 
 	#ifdef DISABLE_PWRSAVE_AND_SCAN_DURING_IP
 
-	g_obtainingIP = WILC_FALSE;
+	g_obtainingIP = false;
 	#endif
 
 	PRINT_D(HOSTINF_DBG, "Global handle pointer value=%p\n", pstrWFIDrv);
@@ -6711,7 +6711,7 @@ s32 host_int_init(WILC_WFIDrvHandle *phWFIDrv)
 #endif
 
 	pstrWFIDrv->enuHostIFstate = HOST_IF_IDLE;
-	/* gWFiDrvHandle->bPendingConnRequest = WILC_FALSE; */
+	/* gWFiDrvHandle->bPendingConnRequest = false; */
 
 	/*Initialize CFG WIDS Defualt Values*/
 
@@ -6859,7 +6859,7 @@ s32 host_int_deinit(WILC_WFIDrvHandle hWFIDrv)
 
 	pstrWFIDrv->enuHostIFstate = HOST_IF_IDLE;
 
-	gbScanWhileConnected = WILC_FALSE;
+	gbScanWhileConnected = false;
 
 	WILC_memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
 
@@ -7174,7 +7174,7 @@ s32 host_int_ListenStateExpired(WILC_WFIDrvHandle hWFIDrv, u32 u32SessionID)
  *  @author
  *  @date
  *  @version		1.0*/
-s32 host_int_frame_register(WILC_WFIDrvHandle hWFIDrv, u16 u16FrameType, WILC_Bool bReg)
+s32 host_int_frame_register(WILC_WFIDrvHandle hWFIDrv, u16 u16FrameType, bool bReg)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
@@ -7542,7 +7542,7 @@ s32 host_int_edit_station(WILC_WFIDrvHandle hWFIDrv, tstrWILC_AddStaParam *pstrS
 #endif /*WILC_AP_EXTERNAL_MLME*/
 uint32_t wilc_get_chipid(uint8_t);
 
-s32 host_int_set_power_mgmt(WILC_WFIDrvHandle hWFIDrv, WILC_Bool bIsEnabled, u32 u32Timeout)
+s32 host_int_set_power_mgmt(WILC_WFIDrvHandle hWFIDrv, bool bIsEnabled, u32 u32Timeout)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
@@ -7578,7 +7578,7 @@ s32 host_int_set_power_mgmt(WILC_WFIDrvHandle hWFIDrv, WILC_Bool bIsEnabled, u32
 	return s32Error;
 }
 
-s32 host_int_setup_multicast_filter(WILC_WFIDrvHandle hWFIDrv, WILC_Bool bIsEnabled, u32 u32count)
+s32 host_int_setup_multicast_filter(WILC_WFIDrvHandle hWFIDrv, bool bIsEnabled, u32 u32count)
 {
 	s32 s32Error = WILC_SUCCESS;
 
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index afe9206..dcd1275 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -330,7 +330,7 @@ typedef struct {
 	size_t ConnReqIEsLen;
 	/* Connect user call back function */
 	tWILCpfConnectResult pfUserConnectResult;
-	WILC_Bool IsHTCapable;
+	bool IsHTCapable;
 	/* User specific parameter to be delivered through the Connect User Callback function */
 	void *u32UserConnectPvoid;
 } tstrWILC_UsrConnReq;
@@ -373,7 +373,7 @@ typedef struct {
 
 typedef struct {
 
-	WILC_Bool bReg;
+	bool bReg;
 	u16 u16FrameType;
 	u8 u8Regid;
 
@@ -412,7 +412,7 @@ typedef struct {
 
 	tenuHostIFstate enuHostIFstate;
 
-	/* WILC_Bool bPendingConnRequest; */
+	/* bool bPendingConnRequest; */
 
 	#ifndef CONNECT_DIRECT
 	u32 u32SurveyResultsCount;
@@ -437,7 +437,7 @@ typedef struct {
 	WILC_TimerHandle hRemainOnChannel;
 	#endif
 
-	WILC_Bool IFC_UP;
+	bool IFC_UP;
 } tstrWILC_WFIDrv;
 
 /*!
@@ -465,7 +465,7 @@ typedef struct {
 	u16 u16AssocID;
 	u8 u8NumRates;
 	const u8 *pu8Rates;
-	WILC_Bool bIsHTSupported;
+	bool bIsHTSupported;
 	u16 u16HTCapInfo;
 	u8 u8AmpduParams;
 	u8 au8SuppMCsSet[16];
@@ -1058,7 +1058,7 @@ s32 hif_get_cfg(WILC_WFIDrvHandle hWFIDrv, u16 u16WID, u16 *pu16WID_Value);
  *  @version		1.0
  */
 void host_int_send_join_leave_info_to_host
-	(u16 assocId, u8 *stationAddr, WILC_Bool joining);
+	(u16 assocId, u8 *stationAddr, bool joining);
 
 /**
  *  @brief              notifies host with stations found in scan
@@ -1202,7 +1202,7 @@ s32 host_int_del_station(WILC_WFIDrvHandle hWFIDrv, const u8 *pu8MacAddr);
 s32 host_int_edit_station(WILC_WFIDrvHandle hWFIDrv, tstrWILC_AddStaParam *pstrStaParams);
 
 /*!
- *  @fn		s32 host_int_set_power_mgmt(WILC_WFIDrvHandle hWFIDrv, WILC_Bool bIsEnabled, u32 u32Timeout)
+ *  @fn		s32 host_int_set_power_mgmt(WILC_WFIDrvHandle hWFIDrv, bool bIsEnabled, u32 u32Timeout)
  *  @brief		Set the power management mode to enabled or disabled
  *  @details
  *  @param[in,out]	hWFIDrv		handle to the wifi driver
@@ -1216,7 +1216,7 @@ s32 host_int_edit_station(WILC_WFIDrvHandle hWFIDrv, tstrWILC_AddStaParam *pstrS
  *  @date		24 November 2012
  *  @version		1.0 Description
  */
-s32 host_int_set_power_mgmt(WILC_WFIDrvHandle hWFIDrv, WILC_Bool bIsEnabled, u32 u32Timeout);
+s32 host_int_set_power_mgmt(WILC_WFIDrvHandle hWFIDrv, bool bIsEnabled, u32 u32Timeout);
 /*  @param[in,out]	hWFIDrv		handle to the wifi driver
  *  @param[in]	bIsEnabled	TRUE if enabled, FALSE otherwise
  *  @param[in]	u8count		count of mac address entries in the filter table
@@ -1228,7 +1228,7 @@ s32 host_int_set_power_mgmt(WILC_WFIDrvHandle hWFIDrv, WILC_Bool bIsEnabled, u32
  *  @date		24 November 2012
  *  @version		1.0 Description
  */
-s32 host_int_setup_multicast_filter(WILC_WFIDrvHandle hWFIDrv, WILC_Bool bIsEnabled, u32 u32count);
+s32 host_int_setup_multicast_filter(WILC_WFIDrvHandle hWFIDrv, bool bIsEnabled, u32 u32count);
 /**
  *  @brief           host_int_setup_ipaddress
  *  @details       set IP address on firmware
@@ -1312,7 +1312,7 @@ s32 host_int_ListenStateExpired(WILC_WFIDrvHandle hWFIDrv, u32 u32SessionID);
  *  @date
  *  @version	1.0
  */
-s32 host_int_frame_register(WILC_WFIDrvHandle hWFIDrv, u16 u16FrameType, WILC_Bool bReg);
+s32 host_int_frame_register(WILC_WFIDrvHandle hWFIDrv, u16 u16FrameType, bool bReg);
 #endif
 /**
  *  @brief           host_int_set_wfi_drv_handler
diff --git a/drivers/staging/wilc1000/linux_mon.c b/drivers/staging/wilc1000/linux_mon.c
index 708e321..d5860ce 100644
--- a/drivers/staging/wilc1000/linux_mon.c
+++ b/drivers/staging/wilc1000/linux_mon.c
@@ -274,7 +274,7 @@ static int mon_mgmt_tx(struct net_device *dev, const u8 *buf, size_t len)
 	memcpy((mgmt_tx->buff) + (len - sizeof(struct tx_complete_mon_data *)), &mgmt_tx, sizeof(struct tx_complete_mon_data *));
 
 	/* filter data frames to handle it's PS */
-	if (filter_monitor_data_frames((mgmt_tx->buff), len) == WILC_TRUE) {
+	if (filter_monitor_data_frames((mgmt_tx->buff), len) == true) {
 		return;
 	}
 
@@ -412,7 +412,7 @@ static const struct net_device_ops wilc_wfi_netdev_ops = {
  *  @date			9 May 2013
  *  @version		1.0
  */
-void WILC_mgm_HOSTAPD_ACK(void *priv, WILC_Bool bStatus)
+void WILC_mgm_HOSTAPD_ACK(void *priv, bool bStatus)
 {
 	struct sk_buff *skb;
 	struct wilc_wfi_radiotap_cb_hdr *cb_hdr;
@@ -452,7 +452,7 @@ void WILC_mgm_HOSTAPD_ACK(void *priv, WILC_Bool bStatus)
 		cb_hdr->rate = 5; /* txrate->bitrate / 5; */
 
 
-		if (WILC_TRUE == bStatus) {
+		if (true == bStatus) {
 			/* success */
 			cb_hdr->tx_flags = IEEE80211_RADIOTAP_F_TX_RTS;
 		} else {
diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 387d4ec..5f87148 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -65,9 +65,9 @@ unsigned char mac_add[] = {0x00, 0x80, 0xC2, 0x5E, 0xa2, 0xb2};
 #endif
 
 #ifdef DISABLE_PWRSAVE_AND_SCAN_DURING_IP
-extern WILC_Bool g_obtainingIP;
+extern bool g_obtainingIP;
 #endif
-extern u16 Set_machw_change_vir_if(WILC_Bool bValue);
+extern u16 Set_machw_change_vir_if(bool bValue);
 extern void resolve_disconnect_aberration(void *drvHandler);
 extern u8 gau8MulticastMacAddrList[WILC_MULTICAST_TABLE_SIZE][ETH_ALEN];
 void wilc1000_wlan_deinit(linux_wlan_t *nic);
@@ -178,7 +178,7 @@ static void wilc_set_multicast_list(struct net_device *dev);
  */
 linux_wlan_t *g_linux_wlan;
 wilc_wlan_oup_t *gpstrWlanOps;
-WILC_Bool bEnablePS = WILC_TRUE;
+bool bEnablePS = true;
 
 static const struct net_device_ops wilc_netdev_ops = {
 	.ndo_init = mac_init_fn,
@@ -302,14 +302,14 @@ static int dev_state_ev_handler(struct notifier_block *this, unsigned long event
 		/*If we are in station mode or client mode*/
 		if (nic->iftype == STATION_MODE || nic->iftype == CLIENT_MODE) {
 			pstrWFIDrv->IFC_UP = 1;
-			g_obtainingIP = WILC_FALSE;
+			g_obtainingIP = false;
 			WILC_TimerStop(&hDuringIpTimer, NULL);
 			PRINT_D(GENERIC_DBG, "IP obtained , enable scan\n");
 		}
 
 
 
-		if (bEnablePS	 == WILC_TRUE)
+		if (bEnablePS	 == true)
 			host_int_set_power_mgmt((WILC_WFIDrvHandle)pstrWFIDrv, 1, 0);
 
 		PRINT_D(GENERIC_DBG, "[%s] Up IP\n", dev_iface->ifa_label);
@@ -326,7 +326,7 @@ static int dev_state_ev_handler(struct notifier_block *this, unsigned long event
 		PRINT_INFO(GENERIC_DBG, "\n ============== IP Address Released ===============\n\n");
 		if (nic->iftype == STATION_MODE || nic->iftype == CLIENT_MODE) {
 			pstrWFIDrv->IFC_UP = 0;
-			g_obtainingIP = WILC_FALSE;
+			g_obtainingIP = false;
 		}
 
 		if (memcmp(dev_iface->ifa_label, wlan_dev_name, 5) == 0)
@@ -2090,7 +2090,7 @@ int mac_open(struct net_device *ndev)
 		return ret;
 	}
 
-	Set_machw_change_vir_if(WILC_FALSE);
+	Set_machw_change_vir_if(false);
 
 	host_int_get_MacAddress(priv->hWILCWFIDrv, mac_add);
 	PRINT_D(INIT_DBG, "Mac address: %x:%x:%x:%x:%x:%x\n", mac_add[0], mac_add[1], mac_add[2],
@@ -2187,14 +2187,14 @@ static void wilc_set_multicast_list(struct net_device *dev)
 	if ((dev->flags & IFF_ALLMULTI) || (dev->mc.count) > WILC_MULTICAST_TABLE_SIZE) {
 		PRINT_D(INIT_DBG, "Disable multicast filter, retrive all multicast packets\n");
 		/* get all multicast packets */
-		host_int_setup_multicast_filter((WILC_WFIDrvHandle)pstrWFIDrv, WILC_FALSE, 0);
+		host_int_setup_multicast_filter((WILC_WFIDrvHandle)pstrWFIDrv, false, 0);
 		return;
 	}
 
 	/* No multicast?  Just get our own stuff */
 	if ((dev->mc.count) == 0) {
 		PRINT_D(INIT_DBG, "Enable multicast filter, retrive directed packets only.\n");
-		host_int_setup_multicast_filter((WILC_WFIDrvHandle)pstrWFIDrv, WILC_TRUE, 0);
+		host_int_setup_multicast_filter((WILC_WFIDrvHandle)pstrWFIDrv, true, 0);
 		return;
 	}
 
@@ -2207,7 +2207,7 @@ static void wilc_set_multicast_list(struct net_device *dev)
 		i++;
 	}
 
-	host_int_setup_multicast_filter((WILC_WFIDrvHandle)pstrWFIDrv, WILC_TRUE, (dev->mc.count));
+	host_int_setup_multicast_filter((WILC_WFIDrvHandle)pstrWFIDrv, true, (dev->mc.count));
 
 	return;
 
diff --git a/drivers/staging/wilc1000/wilc_msgqueue.c b/drivers/staging/wilc1000/wilc_msgqueue.c
index 8531bf1..04fe5a5 100644
--- a/drivers/staging/wilc1000/wilc_msgqueue.c
+++ b/drivers/staging/wilc1000/wilc_msgqueue.c
@@ -15,7 +15,7 @@ WILC_ErrNo WILC_MsgQueueCreate(WILC_MsgQueueHandle *pHandle,
 	sema_init(&pHandle->hSem, 0);
 	pHandle->pstrMessageList = NULL;
 	pHandle->u32ReceiversCount = 0;
-	pHandle->bExiting = WILC_FALSE;
+	pHandle->bExiting = false;
 	return WILC_SUCCESS;
 }
 
@@ -29,7 +29,7 @@ WILC_ErrNo WILC_MsgQueueDestroy(WILC_MsgQueueHandle *pHandle,
 				tstrWILC_MsgQueueAttrs *pstrAttrs)
 {
 
-	pHandle->bExiting = WILC_TRUE;
+	pHandle->bExiting = true;
 
 	/* Release any waiting receiver thread. */
 	while (pHandle->u32ReceiversCount > 0) {
@@ -64,7 +64,7 @@ WILC_ErrNo WILC_MsgQueueSend(WILC_MsgQueueHandle *pHandle,
 		WILC_ERRORREPORT(s32RetStatus, WILC_INVALID_ARGUMENT);
 	}
 
-	if (pHandle->bExiting == WILC_TRUE) {
+	if (pHandle->bExiting == true) {
 		WILC_ERRORREPORT(s32RetStatus, WILC_FAIL);
 	}
 
@@ -131,7 +131,7 @@ WILC_ErrNo WILC_MsgQueueRecv(WILC_MsgQueueHandle *pHandle,
 		WILC_ERRORREPORT(s32RetStatus, WILC_INVALID_ARGUMENT);
 	}
 
-	if (pHandle->bExiting == WILC_TRUE) {
+	if (pHandle->bExiting == true) {
 		WILC_ERRORREPORT(s32RetStatus, WILC_FAIL);
 	}
 
diff --git a/drivers/staging/wilc1000/wilc_oswrapper.h b/drivers/staging/wilc1000/wilc_oswrapper.h
index 016f964..d5835d6 100644
--- a/drivers/staging/wilc1000/wilc_oswrapper.h
+++ b/drivers/staging/wilc1000/wilc_oswrapper.h
@@ -13,12 +13,6 @@
 /* OS Wrapper interface version */
 #define WILC_OSW_INTERFACE_VER 2
 
-/* Boolean type */
-typedef enum {
-	WILC_FALSE = 0,
-	WILC_TRUE = 1
-} WILC_Bool;
-
 /* Character types */
 typedef char WILC_Char;
 
diff --git a/drivers/staging/wilc1000/wilc_platform.h b/drivers/staging/wilc1000/wilc_platform.h
index e185eb3..7ddea83 100644
--- a/drivers/staging/wilc1000/wilc_platform.h
+++ b/drivers/staging/wilc1000/wilc_platform.h
@@ -30,7 +30,7 @@ typedef struct __Message_struct {
 typedef struct __MessageQueue_struct {
 	struct semaphore hSem;
 	spinlock_t strCriticalSection;
-	WILC_Bool bExiting;
+	bool bExiting;
 	u32 u32ReceiversCount;
 	Message *pstrMessageList;
 } WILC_MsgQueueHandle;
diff --git a/drivers/staging/wilc1000/wilc_spi.c b/drivers/staging/wilc1000/wilc_spi.c
index a43dc9b..ba9b30a 100644
--- a/drivers/staging/wilc1000/wilc_spi.c
+++ b/drivers/staging/wilc1000/wilc_spi.c
@@ -1472,4 +1472,3 @@ wilc_hif_func_t hif_spi = {
 	spi_max_bus_speed,
 	spi_default_bus_speed,
 };
-
diff --git a/drivers/staging/wilc1000/wilc_timer.h b/drivers/staging/wilc1000/wilc_timer.h
index 72efa85..a0f9154 100644
--- a/drivers/staging/wilc1000/wilc_timer.h
+++ b/drivers/staging/wilc1000/wilc_timer.h
@@ -82,8 +82,8 @@ WILC_ErrNo WILC_TimerDestroy(WILC_TimerHandle *pHandle,
  *  @details	This function will move the timer to the PENDING state until the
  *              given time expires (in msec) then the callback function will be
  *              executed (timer in EXECUTING state) after execution is dene the
- *              timer either goes to IDLE (if bPeriodicTimer==WILC_FALSE) or
- *              PENDING with same timeout value (if bPeriodicTimer==WILC_TRUE)
+ *              timer either goes to IDLE (if bPeriodicTimer==false) or
+ *              PENDING with same timeout value (if bPeriodicTimer==true)
  *  @param[in]	pHandle handle to the timer object
  *  @param[in]	u32Timeout timeout value in msec after witch the callback
  *              function will be executed. Timeout value of 0 is not allowed for
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index fde2a64..2293949 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -25,7 +25,7 @@
 extern void linux_wlan_free(void *vp);
 extern int linux_wlan_get_firmware(perInterface_wlan_t *p_nic);
 extern void linux_wlan_unlock(void *vp);
-extern u16 Set_machw_change_vir_if(WILC_Bool bValue);
+extern u16 Set_machw_change_vir_if(bool bValue);
 
 extern int mac_open(struct net_device *ndev);
 extern int mac_close(struct net_device *ndev);
@@ -43,7 +43,7 @@ extern u8 u8ConnectedSSID[6];
 u8 g_wilc_initialized = 1;
 extern linux_wlan_t *g_linux_wlan;
 #ifdef DISABLE_PWRSAVE_AND_SCAN_DURING_IP
-extern WILC_Bool g_obtainingIP;
+extern bool g_obtainingIP;
 #endif
 
 #define CHAN2G(_channel, _freq, _flags) {	 \
@@ -112,7 +112,7 @@ u8 u8P2P_oui[] = {0x50, 0x6f, 0x9A, 0x09};
 u8 u8P2Plocalrandom = 0x01;
 u8 u8P2Precvrandom = 0x00;
 u8 u8P2P_vendorspec[] = {0xdd, 0x05, 0x00, 0x08, 0x40, 0x03};
-WILC_Bool bWilc_ie = WILC_FALSE;
+bool bWilc_ie = false;
 #endif
 
 static struct ieee80211_supported_band WILC_WFI_band_2ghz = {
@@ -135,9 +135,9 @@ struct add_key_params g_add_ptk_key_params;
 struct wilc_wfi_key g_key_ptk_params;
 struct wilc_wfi_wep_key g_key_wep_params;
 u8 g_flushing_in_progress;
-WILC_Bool g_ptk_keys_saved = WILC_FALSE;
-WILC_Bool g_gtk_keys_saved = WILC_FALSE;
-WILC_Bool g_wep_keys_saved = WILC_FALSE;
+bool g_ptk_keys_saved = false;
+bool g_gtk_keys_saved = false;
+bool g_wep_keys_saved = false;
 
 #define AGING_TIME	(9 * 1000)
 #define duringIP_TIME 15000
@@ -178,7 +178,7 @@ uint32_t get_rssi_avg(tstrNetworkInfo *pstrNetworkInfo)
 	return rssi_v;
 }
 
-void refresh_scan(void *pUserVoid, uint8_t all, WILC_Bool bDirectScan)
+void refresh_scan(void *pUserVoid, uint8_t all, bool bDirectScan)
 {
 	struct WILC_WFI_priv *priv;
 	struct wiphy *wiphy;
@@ -275,7 +275,7 @@ void remove_network_from_shadow(void *pUserVoid)
 void clear_duringIP(void *pUserVoid)
 {
 	PRINT_D(GENERIC_DBG, "GO:IP Obtained , enable scan\n");
-	g_obtainingIP = WILC_FALSE;
+	g_obtainingIP = false;
 }
 #endif
 
@@ -386,7 +386,7 @@ static void CfgScanResult(tenuScanEvent enuScanEvent, tstrNetworkInfo *pstrNetwo
 	struct cfg80211_bss *bss = NULL;
 
 	priv = (struct WILC_WFI_priv *)pUserVoid;
-	if (priv->bCfgScanning == WILC_TRUE) {
+	if (priv->bCfgScanning == true) {
 		if (enuScanEvent == SCAN_EVENT_NETWORK_FOUND) {
 			wiphy = priv->dev->ieee80211_ptr->wiphy;
 			WILC_NULLCHECK(s32Error, wiphy);
@@ -409,7 +409,7 @@ static void CfgScanResult(tenuScanEvent enuScanEvent, tstrNetworkInfo *pstrNetwo
 					   "BeaconPeriod: %d \n", channel->center_freq, (((s32)pstrNetworkInfo->s8rssi) * 100),
 					   pstrNetworkInfo->u16CapInfo, pstrNetworkInfo->u16BeaconPeriod);
 
-				if (pstrNetworkInfo->bNewNetwork == WILC_TRUE) {
+				if (pstrNetworkInfo->bNewNetwork == true) {
 					if (priv->u32RcvdChCount < MAX_NUM_SCANNED_NETWORKS) { /* TODO: mostafa: to be replaced by */
 						/*               max_scan_ssids */
 						PRINT_D(CFG80211_DBG, "Network %s found\n", pstrNetworkInfo->au8ssid);
@@ -454,7 +454,7 @@ static void CfgScanResult(tenuScanEvent enuScanEvent, tstrNetworkInfo *pstrNetwo
 		} else if (enuScanEvent == SCAN_EVENT_DONE)    {
 			PRINT_D(CFG80211_DBG, "Scan Done[%p] \n", priv->dev);
 			PRINT_D(CFG80211_DBG, "Refreshing Scan ... \n");
-			refresh_scan(priv, 1, WILC_FALSE);
+			refresh_scan(priv, 1, false);
 
 			if (priv->u32RcvdChCount > 0) {
 				PRINT_D(CFG80211_DBG, "%d Network(s) found \n", priv->u32RcvdChCount);
@@ -465,9 +465,9 @@ static void CfgScanResult(tenuScanEvent enuScanEvent, tstrNetworkInfo *pstrNetwo
 			down(&(priv->hSemScanReq));
 
 			if (priv->pstrScanReq != NULL) {
-				cfg80211_scan_done(priv->pstrScanReq, WILC_FALSE);
+				cfg80211_scan_done(priv->pstrScanReq, false);
 				priv->u32RcvdChCount = 0;
-				priv->bCfgScanning = WILC_FALSE;
+				priv->bCfgScanning = false;
 				priv->pstrScanReq = NULL;
 			}
 			up(&(priv->hSemScanReq));
@@ -481,10 +481,10 @@ static void CfgScanResult(tenuScanEvent enuScanEvent, tstrNetworkInfo *pstrNetwo
 			if (priv->pstrScanReq != NULL) {
 
 				update_scan_time(priv);
-				refresh_scan(priv, 1, WILC_FALSE);
+				refresh_scan(priv, 1, false);
 
-				cfg80211_scan_done(priv->pstrScanReq, WILC_FALSE);
-				priv->bCfgScanning = WILC_FALSE;
+				cfg80211_scan_done(priv->pstrScanReq, false);
+				priv->bCfgScanning = false;
 				priv->pstrScanReq = NULL;
 			}
 			up(&(priv->hSemScanReq));
@@ -599,7 +599,7 @@ static void CfgConnectResult(tenuConnDisconnEvent enuConnDisconnEvent,
 		}
 
 		if (u16ConnectStatus == WLAN_STATUS_SUCCESS) {
-			WILC_Bool bNeedScanRefresh = WILC_FALSE;
+			bool bNeedScanRefresh = false;
 			u32 i;
 
 			PRINT_INFO(CFG80211_DBG, "Connection Successful:: BSSID: %x%x%x%x%x%x\n", pstrConnectInfo->au8bssid[0],
@@ -617,17 +617,17 @@ static void CfgConnectResult(tenuConnDisconnEvent enuConnDisconnEvent,
 
 					if (time_after(now,
 						       astrLastScannedNtwrksShadow[i].u32TimeRcvdInScanCached + (unsigned long)(nl80211_SCAN_RESULT_EXPIRE - (1 * HZ)))) {
-						bNeedScanRefresh = WILC_TRUE;
+						bNeedScanRefresh = true;
 					}
 
 					break;
 				}
 			}
 
-			if (bNeedScanRefresh == WILC_TRUE) {
+			if (bNeedScanRefresh == true) {
 				/*BugID_5418*/
 				/*Also, refrsh DIRECT- results if */
-				refresh_scan(priv, 1, WILC_TRUE);
+				refresh_scan(priv, 1, true);
 
 			}
 
@@ -645,13 +645,13 @@ static void CfgConnectResult(tenuConnDisconnEvent enuConnDisconnEvent,
 		/* be replaced by pstrConnectInfo->u16ConnectStatus */
 	} else if (enuConnDisconnEvent == CONN_DISCONN_EVENT_DISCONN_NOTIF)    {
 		#ifdef DISABLE_PWRSAVE_AND_SCAN_DURING_IP
-		g_obtainingIP = WILC_FALSE;
+		g_obtainingIP = false;
 		#endif
 		PRINT_ER("Received MAC_DISCONNECTED from firmware with reason %d on dev [%p]\n",
 			 pstrDisconnectNotifInfo->u16reason, priv->dev);
 		u8P2Plocalrandom = 0x01;
 		u8P2Precvrandom = 0x00;
-		bWilc_ie = WILC_FALSE;
+		bWilc_ie = false;
 		WILC_memset(priv->au8AssociatedBss, 0, ETH_ALEN);
 		linux_wlan_set_bssid(priv->dev, NullBssid);
 		WILC_memset(u8ConnectedSSID, 0, ETH_ALEN);
@@ -752,7 +752,7 @@ static int WILC_WFI_CfgScan(struct wiphy *wiphy, struct cfg80211_scan_request *r
 
 	reset_shadow_found(priv);
 
-	priv->bCfgScanning = WILC_TRUE;
+	priv->bCfgScanning = true;
 	if (request->n_channels <= MAX_NUM_SCANNED_NETWORKS) { /* TODO: mostafa: to be replaced by */
 		/*               max_scan_ssids */
 		for (i = 0; i < request->n_channels; i++) {
@@ -935,7 +935,7 @@ static int WILC_WFI_CfgConnect(struct wiphy *wiphy, struct net_device *dev,
 			g_key_wep_params.key = WILC_MALLOC(sme->key_len);
 			memcpy(g_key_wep_params.key, sme->key, sme->key_len);
 			g_key_wep_params.key_idx = sme->key_idx;
-			g_wep_keys_saved = WILC_TRUE;
+			g_wep_keys_saved = true;
 
 			host_int_set_WEPDefaultKeyID(priv->hWILCWFIDrv, sme->key_idx);
 			host_int_add_wep_key_bss_sta(priv->hWILCWFIDrv, sme->key, sme->key_len, sme->key_idx);
@@ -953,7 +953,7 @@ static int WILC_WFI_CfgConnect(struct wiphy *wiphy, struct net_device *dev,
 			g_key_wep_params.key = WILC_MALLOC(sme->key_len);
 			memcpy(g_key_wep_params.key, sme->key, sme->key_len);
 			g_key_wep_params.key_idx = sme->key_idx;
-			g_wep_keys_saved = WILC_TRUE;
+			g_wep_keys_saved = true;
 
 			host_int_set_WEPDefaultKeyID(priv->hWILCWFIDrv, sme->key_idx);
 			host_int_add_wep_key_bss_sta(priv->hWILCWFIDrv, sme->key, sme->key_len, sme->key_idx);
@@ -1101,7 +1101,7 @@ static int WILC_WFI_disconnect(struct wiphy *wiphy, struct net_device *dev, u16
 
 	u8P2Plocalrandom = 0x01;
 	u8P2Precvrandom = 0x00;
-	bWilc_ie = WILC_FALSE;
+	bWilc_ie = false;
 	#ifdef WILC_P2P
 	pstrWFIDrv->u64P2p_MgmtTimeout = 0;
 	#endif
@@ -1348,7 +1348,7 @@ static int WILC_WFI_add_key(struct wiphy *wiphy, struct net_device *netdev, u8 k
 					PRINT_D(CFG80211_DBG, "key %x %x %x\n", g_key_gtk_params.key[0],
 						g_key_gtk_params.key[1],
 						g_key_gtk_params.key[2]);
-					g_gtk_keys_saved = WILC_TRUE;
+					g_gtk_keys_saved = true;
 				}
 
 				host_int_add_rx_gtk(priv->hWILCWFIDrv, params->key, KeyLen,
@@ -1385,7 +1385,7 @@ static int WILC_WFI_add_key(struct wiphy *wiphy, struct net_device *netdev, u8 k
 					PRINT_D(CFG80211_DBG, "key %x %x %x\n", g_key_ptk_params.key[0],
 						g_key_ptk_params.key[1],
 						g_key_ptk_params.key[2]);
-					g_ptk_keys_saved = WILC_TRUE;
+					g_ptk_keys_saved = true;
 				}
 
 				host_int_add_ptk(priv->hWILCWFIDrv, params->key, KeyLen, mac_addr,
@@ -1431,9 +1431,9 @@ static int WILC_WFI_del_key(struct wiphy *wiphy, struct net_device *netdev,
 	/*BugID_5137*/
 	/*delete saved keys, if any*/
 	if (netdev == g_linux_wlan->strInterfaceInfo[0].wilc_netdev) {
-		g_ptk_keys_saved = WILC_FALSE;
-		g_gtk_keys_saved = WILC_FALSE;
-		g_wep_keys_saved = WILC_FALSE;
+		g_ptk_keys_saved = false;
+		g_gtk_keys_saved = false;
+		g_wep_keys_saved = false;
 
 		/*Delete saved WEP keys params, if any*/
 		if (g_key_wep_params.key != NULL) {
@@ -1499,7 +1499,7 @@ static int WILC_WFI_del_key(struct wiphy *wiphy, struct net_device *netdev,
 		}
 
 		/*Reset WILC_CHANGING_VIR_IF register to allow adding futrue keys to CE H/W*/
-		Set_machw_change_vir_if(WILC_FALSE);
+		Set_machw_change_vir_if(false);
 	}
 
 	if (key_index >= 0 && key_index <= 3) {
@@ -1702,9 +1702,9 @@ static int WILC_WFI_get_station(struct wiphy *wiphy, struct net_device *dev,
 
 #ifdef TCP_ENHANCEMENTS
 		if ((strStatistics.u8LinkSpeed > TCP_ACK_FILTER_LINK_SPEED_THRESH) && (strStatistics.u8LinkSpeed != DEFAULT_LINK_SPEED)) {
-			Enable_TCP_ACK_Filter(WILC_TRUE);
+			Enable_TCP_ACK_Filter(true);
 		} else if (strStatistics.u8LinkSpeed != DEFAULT_LINK_SPEED)   {
-			Enable_TCP_ACK_Filter(WILC_FALSE);
+			Enable_TCP_ACK_Filter(false);
 		}
 #endif
 
@@ -2032,7 +2032,7 @@ void WILC_WFI_CfgParseRxAction(u8 *buf, u32 len)
 	#ifdef USE_SUPPLICANT_GO_INTENT
 	u8 intent;
 	u8 tie_breaker;
-	WILC_Bool is_wilc_go = WILC_TRUE;
+	bool is_wilc_go = true;
 	#endif
 	u8 op_channel_attr_index = 0;
 	u8 channel_list_attr_index = 0;
@@ -2048,10 +2048,10 @@ void WILC_WFI_CfgParseRxAction(u8 *buf, u32 len)
 			if (intent > SUPPLICANT_GO_INTENT
 			    || (intent == SUPPLICANT_GO_INTENT && tie_breaker == 1)) {
 				PRINT_D(GENERIC_DBG, "WILC will be client (intent %d tie breaker %d)\n", intent, tie_breaker);
-				is_wilc_go = WILC_FALSE;
+				is_wilc_go = false;
 			} else {
 				PRINT_D(GENERIC_DBG, "WILC will be GO (intent %d tie breaker %d)\n", intent, tie_breaker);
-				is_wilc_go = WILC_TRUE;
+				is_wilc_go = true;
 			}
 
 			#else   /* USE_SUPPLICANT_GO_INTENT */
@@ -2070,7 +2070,7 @@ void WILC_WFI_CfgParseRxAction(u8 *buf, u32 len)
 			PRINT_D(GENERIC_DBG, "Group BSSID: %2x:%2x:%2x\n", buf[index + 3]
 				, buf[index + 4]
 				, buf[index + 5]);
-			is_wilc_go = WILC_FALSE;
+			is_wilc_go = false;
 		}
 		#endif  /* USE_SUPPLICANT_GO_INTENT */
 
@@ -2119,7 +2119,7 @@ void WILC_WFI_CfgParseRxAction(u8 *buf, u32 len)
  *  @date	12 DEC 2012
  *  @version
  */
-void WILC_WFI_CfgParseTxAction(u8 *buf, u32 len, WILC_Bool bOperChan, u8 iftype)
+void WILC_WFI_CfgParseTxAction(u8 *buf, u32 len, bool bOperChan, u8 iftype)
 {
 	u32 index = 0;
 	u32 i = 0, j = 0;
@@ -2127,7 +2127,7 @@ void WILC_WFI_CfgParseTxAction(u8 *buf, u32 len, WILC_Bool bOperChan, u8 iftype)
 	u8 op_channel_attr_index = 0;
 	u8 channel_list_attr_index = 0;
 	#ifdef USE_SUPPLICANT_GO_INTENT
-	WILC_Bool is_wilc_go = WILC_FALSE;
+	bool is_wilc_go = false;
 
 	/*BugID_5460*/
 	/*Case 1: If we are already p2p client, no need to modify channels attributes*/
@@ -2145,7 +2145,7 @@ void WILC_WFI_CfgParseTxAction(u8 *buf, u32 len, WILC_Bool bOperChan, u8 iftype)
 			PRINT_D(GENERIC_DBG, "Group BSSID: %2x:%2x:%2x\n", buf[index + 3]
 				, buf[index + 4]
 				, buf[index + 5]);
-			is_wilc_go = WILC_TRUE;
+			is_wilc_go = true;
 		}
 
 		#else   /* USE_SUPPLICANT_GO_INTENT */
@@ -2252,7 +2252,7 @@ void WILC_WFI_p2p_rx (struct net_device *dev, uint8_t *buff, uint32_t size)
 		if (ieee80211_is_action(buff[FRAME_TYPE_ID])) {
 			PRINT_D(GENERIC_DBG, "Rx Action Frame Type: %x %x\n", buff[ACTION_SUBTYPE_ID], buff[P2P_PUB_ACTION_SUBTYPE]);
 
-			if (priv->bCfgScanning == WILC_TRUE && time_after_eq(jiffies, (unsigned long)pstrWFIDrv->u64P2p_MgmtTimeout)) {
+			if (priv->bCfgScanning == true && time_after_eq(jiffies, (unsigned long)pstrWFIDrv->u64P2p_MgmtTimeout)) {
 				PRINT_D(GENERIC_DBG, "Receiving action frames from wrong channels\n");
 				return;
 			}
@@ -2276,7 +2276,7 @@ void WILC_WFI_p2p_rx (struct net_device *dev, uint8_t *buff, uint32_t size)
 								for (i = P2P_PUB_ACTION_SUBTYPE; i < size; i++)	{
 									if (!WILC_memcmp(u8P2P_vendorspec, &buff[i], 6)) {
 										u8P2Precvrandom = buff[i + 6];
-										bWilc_ie = WILC_TRUE;
+										bWilc_ie = true;
 										PRINT_D(GENERIC_DBG, "WILC Vendor specific IE:%02x\n", u8P2Precvrandom);
 										break;
 									}
@@ -2353,7 +2353,7 @@ static void WILC_WFI_RemainOnChannelReady(void *pUserVoid)
 
 	PRINT_D(HOSTINF_DBG, "Remain on channel ready \n");
 
-	priv->bInP2PlistenState = WILC_TRUE;
+	priv->bInP2PlistenState = true;
 
 	cfg80211_ready_on_channel(priv->wdev,
 				  priv->strRemainOnChanParams.u64ListenCookie,
@@ -2381,7 +2381,7 @@ static void WILC_WFI_RemainOnChannelExpired(void *pUserVoid, u32 u32SessionID)
 	if (u32SessionID == priv->strRemainOnChanParams.u32ListenSessionID) {
 		PRINT_D(GENERIC_DBG, "Remain on channel expired \n");
 
-		priv->bInP2PlistenState = WILC_FALSE;
+		priv->bInP2PlistenState = false;
 
 		/*Inform wpas of remain-on-channel expiration*/
 		cfg80211_remain_on_channel_expired(priv->wdev,
@@ -2498,7 +2498,7 @@ void WILC_WFI_add_wilcvendorspec(u8 *buff)
  *  @version
  */
 extern linux_wlan_t *g_linux_wlan;
-extern WILC_Bool bEnablePS;
+extern bool bEnablePS;
 int WILC_WFI_mgmt_tx(struct wiphy *wiphy,
 			struct wireless_dev *wdev,
 			struct cfg80211_mgmt_tx_params *params,
@@ -2602,14 +2602,14 @@ int WILC_WFI_mgmt_tx(struct wiphy *wiphy,
 								for (i = P2P_PUB_ACTION_SUBTYPE + 2; i < len; i++) {
 									if (buf[i] == P2PELEM_ATTR_ID && !(WILC_memcmp(u8P2P_oui, &buf[i + 2], 4))) {
 										if (buf[P2P_PUB_ACTION_SUBTYPE] == P2P_INV_REQ || buf[P2P_PUB_ACTION_SUBTYPE] == P2P_INV_RSP)
-											WILC_WFI_CfgParseTxAction(&mgmt_tx->buff[i + 6], len - (i + 6), WILC_TRUE, nic->iftype);
+											WILC_WFI_CfgParseTxAction(&mgmt_tx->buff[i + 6], len - (i + 6), true, nic->iftype);
 
 										/*BugID_5460*/
 										/*If using supplicant go intent, no need at all*/
 										/*to parse transmitted negotiation frames*/
 											#ifndef USE_SUPPLICANT_GO_INTENT
 										else
-											WILC_WFI_CfgParseTxAction(&mgmt_tx->buff[i + 6], len - (i + 6), WILC_FALSE, nic->iftype);
+											WILC_WFI_CfgParseTxAction(&mgmt_tx->buff[i + 6], len - (i + 6), false, nic->iftype);
 											#endif
 										break;
 									}
@@ -2667,7 +2667,7 @@ int   WILC_WFI_mgmt_tx_cancel_wait(struct wiphy *wiphy,
 	PRINT_D(GENERIC_DBG, "Tx Cancel wait :%lu\n", jiffies);
 	pstrWFIDrv->u64P2p_MgmtTimeout = jiffies;
 
-	if (priv->bInP2PlistenState == WILC_FALSE) {
+	if (priv->bInP2PlistenState == false) {
 		/* Bug 5504: This is just to avoid connection failure when getting stuck when the supplicant
 		 *                      considers the driver falsely that it is in Listen state */
 		cfg80211_remain_on_channel_expired(priv->wdev,
@@ -2817,7 +2817,7 @@ int WILC_WFI_set_power_mgmt(struct wiphy *wiphy, struct net_device *dev,
 		return -EIO;
 	}
 
-	if (bEnablePS	 == WILC_TRUE)
+	if (bEnablePS	 == true)
 		host_int_set_power_mgmt(priv->hWILCWFIDrv, enabled, timeout);
 
 
@@ -2858,17 +2858,17 @@ static int WILC_WFI_change_virt_intf(struct wiphy *wiphy, struct net_device *dev
 	u8P2Plocalrandom = 0x01;
 	u8P2Precvrandom = 0x00;
 
-	bWilc_ie = WILC_FALSE;
+	bWilc_ie = false;
 
 	#ifdef DISABLE_PWRSAVE_AND_SCAN_DURING_IP
-	g_obtainingIP = WILC_FALSE;
+	g_obtainingIP = false;
 	WILC_TimerStop(&hDuringIpTimer, NULL);
 	PRINT_D(GENERIC_DBG, "Changing virtual interface, enable scan\n");
 	#endif
 	/*BugID_5137*/
 	/*Set WILC_CHANGING_VIR_IF register to disallow adding futrue keys to CE H/W*/
 	if (g_ptk_keys_saved && g_gtk_keys_saved) {
-		Set_machw_change_vir_if(WILC_TRUE);
+		Set_machw_change_vir_if(true);
 	}
 
 	switch (type) {
@@ -2960,7 +2960,7 @@ static int WILC_WFI_change_virt_intf(struct wiphy *wiphy, struct net_device *dev
 				}
 			}
 
-			bEnablePS = WILC_TRUE;
+			bEnablePS = true;
 			host_int_set_power_mgmt(priv->hWILCWFIDrv, 1, 0);
 		}
 		#endif
@@ -2968,7 +2968,7 @@ static int WILC_WFI_change_virt_intf(struct wiphy *wiphy, struct net_device *dev
 		break;
 
 	case NL80211_IFTYPE_P2P_CLIENT:
-		bEnablePS = WILC_FALSE;
+		bEnablePS = false;
 		host_int_set_power_mgmt(priv->hWILCWFIDrv, 0, 0);
 		connecting = 0;
 		PRINT_D(HOSTAPD_DBG, "Interface type = NL80211_IFTYPE_P2P_CLIENT\n");
@@ -3037,8 +3037,8 @@ static int WILC_WFI_change_virt_intf(struct wiphy *wiphy, struct net_device *dev
 			}
 
 			/*Refresh scan, to refresh the scan results to the wpa_supplicant. Set MachHw to false to enable further key installments*/
-			refresh_scan(priv, 1, WILC_TRUE);
-			Set_machw_change_vir_if(WILC_FALSE);
+			refresh_scan(priv, 1, true);
+			Set_machw_change_vir_if(false);
 
 			/*BugID_4847: registered frames in firmware are now lost
 			 *  due to mac close. So re-register those frames */
@@ -3057,7 +3057,7 @@ static int WILC_WFI_change_virt_intf(struct wiphy *wiphy, struct net_device *dev
 		break;
 
 	case NL80211_IFTYPE_AP:
-		bEnablePS = WILC_FALSE;
+		bEnablePS = false;
 		PRINT_D(HOSTAPD_DBG, "Interface type = NL80211_IFTYPE_AP %d\n", type);
 		dev->ieee80211_ptr->iftype = type;
 		priv->wdev->iftype = type;
@@ -3093,7 +3093,7 @@ static int WILC_WFI_change_virt_intf(struct wiphy *wiphy, struct net_device *dev
 		PRINT_D(GENERIC_DBG, "start duringIP timer\n");
 
 		#ifdef DISABLE_PWRSAVE_AND_SCAN_DURING_IP
-		g_obtainingIP = WILC_TRUE;
+		g_obtainingIP = true;
 		WILC_TimerStart(&hDuringIpTimer, duringIP_TIME, NULL, NULL);
 		#endif
 		host_int_set_power_mgmt(priv->hWILCWFIDrv, 0, 0);
@@ -3103,7 +3103,7 @@ static int WILC_WFI_change_virt_intf(struct wiphy *wiphy, struct net_device *dev
 		/*hWaitResponse semaphore, which allows previous config*/
 		/*packets to actually take action on old FW*/
 		host_int_del_All_Rx_BASession(priv->hWILCWFIDrv, g_linux_wlan->strInterfaceInfo[0].aBSSID, TID);
-		bEnablePS = WILC_FALSE;
+		bEnablePS = false;
 		PRINT_D(HOSTAPD_DBG, "Interface type = NL80211_IFTYPE_GO\n");
 		dev->ieee80211_ptr->iftype = type;
 		priv->wdev->iftype = type;
@@ -3379,9 +3379,9 @@ static int  WILC_WFI_add_station(struct wiphy *wiphy, struct net_device *dev,
 		PRINT_D(HOSTAPD_DBG, "Number of supported rates = %d\n", strStaParams.u8NumRates);
 
 		if (params->ht_capa == NULL) {
-			strStaParams.bIsHTSupported = WILC_FALSE;
+			strStaParams.bIsHTSupported = false;
 		} else {
-			strStaParams.bIsHTSupported = WILC_TRUE;
+			strStaParams.bIsHTSupported = true;
 			strStaParams.u16HTCapInfo = params->ht_capa->cap_info;
 			strStaParams.u8AmpduParams = params->ht_capa->ampdu_params_info;
 			WILC_memcpy(strStaParams.au8SuppMCsSet, &params->ht_capa->mcs, WILC_SUPP_MCS_SET_SIZE);
@@ -3509,9 +3509,9 @@ static int WILC_WFI_change_station(struct wiphy *wiphy, struct net_device *dev,
 		PRINT_D(HOSTAPD_DBG, "Number of supported rates = %d\n", strStaParams.u8NumRates);
 
 		if (params->ht_capa == NULL) {
-			strStaParams.bIsHTSupported = WILC_FALSE;
+			strStaParams.bIsHTSupported = false;
 		} else {
-			strStaParams.bIsHTSupported = WILC_TRUE;
+			strStaParams.bIsHTSupported = true;
 			strStaParams.u16HTCapInfo = params->ht_capa->cap_info;
 			strStaParams.u8AmpduParams = params->ht_capa->ampdu_params_info;
 			WILC_memcpy(strStaParams.au8SuppMCsSet, &params->ht_capa->mcs, WILC_SUPP_MCS_SET_SIZE);
@@ -3867,9 +3867,9 @@ int WILC_WFI_InitHostInt(struct net_device *net)
 		return s32Error;
 	}
 
-	priv->gbAutoRateAdjusted = WILC_FALSE;
+	priv->gbAutoRateAdjusted = false;
 
-	priv->bInP2PlistenState = WILC_FALSE;
+	priv->bInP2PlistenState = false;
 
 	sema_init(&(priv->hSemScanReq), 1);
 	s32Error = host_int_init(&priv->hWILCWFIDrv);
@@ -3895,9 +3895,9 @@ int WILC_WFI_DeInitHostInt(struct net_device *net)
 	struct WILC_WFI_priv *priv;
 	priv = wdev_priv(net->ieee80211_ptr);
 
-	priv->gbAutoRateAdjusted = WILC_FALSE;
+	priv->gbAutoRateAdjusted = false;
 
-	priv->bInP2PlistenState = WILC_FALSE;
+	priv->bInP2PlistenState = false;
 
 	op_ifcs--;
 
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h
index f45a15f..c25350c 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h
@@ -123,7 +123,7 @@ struct net_device *WILC_WFI_init_mon_interface(const char *name, struct net_devi
 #ifdef TCP_ENHANCEMENTS
 #define TCP_ACK_FILTER_LINK_SPEED_THRESH 54
 #define DEFAULT_LINK_SPEED 72
-extern void Enable_TCP_ACK_Filter(WILC_Bool value);
+extern void Enable_TCP_ACK_Filter(bool value);
 #endif
 
 #endif
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.c b/drivers/staging/wilc1000/wilc_wfi_netdevice.c
index fbc4b85..f6974a6 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.c
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.c
@@ -931,7 +931,7 @@ int WILC_WFI_InitModule(void)
 		/*	priv[1]->monitor_flag = 1; */
 
 	}
-	priv[0]->bCfgScanning = WILC_FALSE;
+	priv[0]->bCfgScanning = false;
 	priv[0]->u32RcvdChCount = 0;
 
 	WILC_memset(priv[0]->au8AssociatedBss, 0xFF, ETH_ALEN);
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index 10e6b1a..2331a00 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -134,7 +134,7 @@ struct WILC_WFI_priv {
 
 	#endif
 
-	WILC_Bool bCfgScanning;
+	bool bCfgScanning;
 	u32 u32RcvdChCount;
 
 
@@ -168,15 +168,15 @@ struct WILC_WFI_priv {
 	struct semaphore SemHandleUpdateStats;
 	struct semaphore hSemScanReq;
 	/*  */
-	WILC_Bool gbAutoRateAdjusted;
+	bool gbAutoRateAdjusted;
 
-	WILC_Bool bInP2PlistenState;
+	bool bInP2PlistenState;
 
 };
 
 typedef struct {
 	u16 frame_type;
-	WILC_Bool reg;
+	bool reg;
 
 } struct_frame_reg;
 
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index a456d0d..762470c 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -27,7 +27,7 @@ extern void WILC_WFI_mgmt_rx(uint8_t *buff, uint32_t size);
 extern void frmw_to_linux(uint8_t *buff, uint32_t size);
 int sdio_xfer_cnt(void);
 uint32_t wilc_get_chipid(uint8_t update);
-u16 Set_machw_change_vir_if(WILC_Bool bValue);
+u16 Set_machw_change_vir_if(bool bValue);
 
 
 
@@ -487,14 +487,14 @@ static int wilc_wlan_txq_filter_dup_tcp_ack(void)
 #endif
 
 #ifdef TCP_ENHANCEMENTS
-WILC_Bool EnableTCPAckFilter = WILC_FALSE;
+bool EnableTCPAckFilter = false;
 
-void Enable_TCP_ACK_Filter(WILC_Bool value)
+void Enable_TCP_ACK_Filter(bool value)
 {
 	EnableTCPAckFilter = value;
 }
 
-WILC_Bool is_TCP_ACK_Filter_Enabled(void)
+bool is_TCP_ACK_Filter_Enabled(void)
 {
 	return EnableTCPAckFilter;
 }
@@ -559,7 +559,7 @@ static int wilc_wlan_txq_add_net_pkt(void *priv, uint8_t *buffer, uint32_t buffe
 #ifdef TCP_ACK_FILTER
 	tqe->tcp_PendingAck_index = NOT_TCP_ACK;
 #ifdef TCP_ENHANCEMENTS
-	if (is_TCP_ACK_Filter_Enabled() == WILC_TRUE)
+	if (is_TCP_ACK_Filter_Enabled() == true)
 #endif
 	tcp_process(tqe);
 #endif
@@ -738,12 +738,12 @@ INLINE void chip_wakeup(void)
 				WILC_Sleep(2);
 				/* Make sure chip is awake. This is an extra step that can be removed */
 				/* later to avoid the bus access overhead */
-				if ((wilc_get_chipid(WILC_TRUE) == 0)) {
+				if ((wilc_get_chipid(true) == 0)) {
 					wilc_debug(N_ERR, "Couldn't read chip id. Wake up failed\n");
 				}
-			} while ((wilc_get_chipid(WILC_TRUE) == 0) && ((++trials % 3) == 0));
+			} while ((wilc_get_chipid(true) == 0) && ((++trials % 3) == 0));
 
-		} while (wilc_get_chipid(WILC_TRUE) == 0);
+		} while (wilc_get_chipid(true) == 0);
 	} else if ((g_wlan.io_func.io_type & 0x1) == HIF_SDIO)	 {
 		g_wlan.hif_func.hif_read_reg(0xf0, &reg);
 		do {
@@ -782,7 +782,7 @@ INLINE void chip_wakeup(void)
 		reg &= ~(1 << 0);
 		g_wlan.hif_func.hif_write_reg(0x1C0C, reg);
 
-		if (wilc_get_chipid(WILC_FALSE) >= 0x1002b0) {
+		if (wilc_get_chipid(false) >= 0x1002b0) {
 			/* Enable PALDO back right after wakeup */
 			uint32_t val32;
 			g_wlan.hif_func.hif_read_reg(0x1e1c, &val32);
@@ -825,19 +825,19 @@ INLINE void chip_wakeup(void)
 
 			/* Make sure chip is awake. This is an extra step that can be removed */
 			/* later to avoid the bus access overhead */
-			if ((wilc_get_chipid(WILC_TRUE) == 0)) {
+			if ((wilc_get_chipid(true) == 0)) {
 				wilc_debug(N_ERR, "Couldn't read chip id. Wake up failed\n");
 			}
-		} while ((wilc_get_chipid(WILC_TRUE) == 0) && ((++trials % 3) == 0));
+		} while ((wilc_get_chipid(true) == 0) && ((++trials % 3) == 0));
 
-	} while (wilc_get_chipid(WILC_TRUE) == 0);
+	} while (wilc_get_chipid(true) == 0);
 
 	if (genuChipPSstate == CHIP_SLEEPING_MANUAL) {
 		g_wlan.hif_func.hif_read_reg(0x1C0C, &reg);
 		reg &= ~(1 << 0);
 		g_wlan.hif_func.hif_write_reg(0x1C0C, reg);
 
-		if (wilc_get_chipid(WILC_FALSE) >= 0x1002b0) {
+		if (wilc_get_chipid(false) >= 0x1002b0) {
 			/* Enable PALDO back right after wakeup */
 			uint32_t val32;
 			g_wlan.hif_func.hif_read_reg(0x1e1c, &val32);
@@ -1354,7 +1354,7 @@ static void wilc_pllupdate_isr_ext(uint32_t int_stats)
 	g_wlan.os_func.os_atomic_sleep(WILC_PLL_TO);
 
 	/* poll till read a valid data */
-	while (!(ISWILC1000(wilc_get_chipid(WILC_TRUE)) && --trials)) {
+	while (!(ISWILC1000(wilc_get_chipid(true)) && --trials)) {
 		PRINT_D(TX_DBG, "PLL update retrying\n");
 		g_wlan.os_func.os_atomic_sleep(1);
 	}
@@ -2012,7 +2012,7 @@ uint32_t init_chip(void)
 	acquire_bus(ACQUIRE_ONLY);
 #endif
 
-	chipid = wilc_get_chipid(WILC_TRUE);
+	chipid = wilc_get_chipid(true);
 
 
 
@@ -2325,7 +2325,7 @@ _fail_:
 }
 
 #define BIT31 (1 << 31)
-u16 Set_machw_change_vir_if(WILC_Bool bValue)
+u16 Set_machw_change_vir_if(bool bValue)
 {
 	u16 ret;
 	u32 reg;
@@ -2337,7 +2337,7 @@ u16 Set_machw_change_vir_if(WILC_Bool bValue)
 		PRINT_ER("Error while Reading reg WILC_CHANGING_VIR_IF\n");
 	}
 
-	if (bValue == WILC_TRUE) {
+	if (bValue == true) {
 		reg |= (BIT31);
 	} else {
 		reg &= ~(BIT31);
diff --git a/drivers/staging/wilc1000/wilc_wlan_cfg.c b/drivers/staging/wilc1000/wilc_wlan_cfg.c
index d7e7e925..9631b18 100644
--- a/drivers/staging/wilc1000/wilc_wlan_cfg.c
+++ b/drivers/staging/wilc1000/wilc_wlan_cfg.c
@@ -14,7 +14,7 @@
 
 #ifdef WILC_FULLY_HOSTING_AP
 #include "wilc_host_ap.h"
-void WILC_mgm_HOSTAPD_ACK(void *priv, WILC_Bool bStatus);
+void WILC_mgm_HOSTAPD_ACK(void *priv, bool bStatus);
 #endif
 
 /********************************************
@@ -542,7 +542,7 @@ static int wilc_wlan_cfg_indicate_rx(uint8_t *frame, int size, wilc_cfg_rsp_t *r
 	uint16_t msg_len;
 	#ifdef WILC_FULLY_HOSTING_AP
 	u32 *ptru32Frame;
-	WILC_Bool bStatus = frame[2];
+	bool bStatus = frame[2];
 
 	#ifdef BIG_ENDIAN
 	ptru32Frame = (frame[4] << 24) | (frame[5] << 16) | (frame[6] << 8) | frame[7];
-- 
2.4.3

