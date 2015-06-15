Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:20113 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753011AbbFODAH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Jun 2015 23:00:07 -0400
From: Dean Lee <dean.lee@atmel.com>
To: <gregkh@linuxfoundation.org>, <devel@driverdev.osuosl.org>,
	<linux-wireless@vger.kernel.org>
CC: <johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <dean.lee@atmel.com>
Subject: [PATCH v2] staging: wilc1000: change WILC_Char to char
Date: Mon, 15 Jun 2015 11:58:57 +0900
Message-ID: <1434337137-25188-1-git-send-email-dean.lee@atmel.com> (sfid-20150615_050012_757087_8D6B2359)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

change own data type(WILC_Char) to common data type(char)

Signed-off-by: Dean Lee <dean.lee@atmel.com>
---
Change v2:
 replace data type s8 -> char
---
 drivers/staging/wilc1000/coreconfigurator.c       | 24 +++----
 drivers/staging/wilc1000/coreconfigurator.h       |  4 +-
 drivers/staging/wilc1000/host_interface.c         | 88 +++++++++++------------
 drivers/staging/wilc1000/wilc_memory.c            |  8 +--
 drivers/staging/wilc1000/wilc_memory.h            |  8 +--
 drivers/staging/wilc1000/wilc_oswrapper.h         |  3 -
 drivers/staging/wilc1000/wilc_strutils.c          |  6 +-
 drivers/staging/wilc1000/wilc_strutils.h          |  6 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c |  6 +-
 9 files changed, 75 insertions(+), 78 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index 792ba6d..bbb3231 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -141,7 +141,7 @@ typedef enum {
 
 
 typedef struct {
-	WILC_Char *pcRespBuffer;
+	char *pcRespBuffer;
 	s32 s32MaxRespBuffLen;
 	s32 s32BytesRead;
 	bool bRespRequired;
@@ -339,7 +339,7 @@ INLINE u8 get_hex_char(u8 inp)
 
 /* This function extracts the MAC address held in a string in standard format */
 /* into another buffer as integers.                                           */
-INLINE u16 extract_mac_addr(WILC_Char *str, u8 *buff)
+INLINE u16 extract_mac_addr(char *str, u8 *buff)
 {
 	*buff = 0;
 	while (*str != '\0') {
@@ -1095,7 +1095,7 @@ s32 DeallocateSurveyResults(wid_site_survey_reslts_s *pstrSurveyResults)
 /*                                                                           */
 /*****************************************************************************/
 
-void ProcessCharWid(WILC_Char *pcPacket, s32 *ps32PktLen,
+void ProcessCharWid(char *pcPacket, s32 *ps32PktLen,
 		    tstrWID *pstrWID, s8 *ps8WidVal)
 {
 	u8 *pu8val = (u8 *)ps8WidVal;
@@ -1149,7 +1149,7 @@ void ProcessCharWid(WILC_Char *pcPacket, s32 *ps32PktLen,
 /*                                                                           */
 /*****************************************************************************/
 
-void ProcessShortWid(WILC_Char *pcPacket, s32 *ps32PktLen,
+void ProcessShortWid(char *pcPacket, s32 *ps32PktLen,
 		     tstrWID *pstrWID, s8 *ps8WidVal)
 {
 	u16 *pu16val = (u16 *)ps8WidVal;
@@ -1204,7 +1204,7 @@ void ProcessShortWid(WILC_Char *pcPacket, s32 *ps32PktLen,
 /*                                                                           */
 /*****************************************************************************/
 
-void ProcessIntWid(WILC_Char *pcPacket, s32 *ps32PktLen,
+void ProcessIntWid(char *pcPacket, s32 *ps32PktLen,
 		   tstrWID *pstrWID, s8 *ps8WidVal)
 {
 	u32 *pu32val = (u32 *)ps8WidVal;
@@ -1262,7 +1262,7 @@ void ProcessIntWid(WILC_Char *pcPacket, s32 *ps32PktLen,
 /*                                                                           */
 /*****************************************************************************/
 
-void ProcessIPwid(WILC_Char *pcPacket, s32 *ps32PktLen,
+void ProcessIPwid(char *pcPacket, s32 *ps32PktLen,
 		  tstrWID *pstrWID, u8 *pu8ip)
 {
 	u32 u32val = 0;
@@ -1320,7 +1320,7 @@ void ProcessIPwid(WILC_Char *pcPacket, s32 *ps32PktLen,
 /*                                                                           */
 /*****************************************************************************/
 
-void ProcessStrWid(WILC_Char *pcPacket, s32 *ps32PktLen,
+void ProcessStrWid(char *pcPacket, s32 *ps32PktLen,
 		   tstrWID *pstrWID, u8 *pu8val, s32 s32ValueSize)
 {
 	u16 u16MsgLen = 0;
@@ -1377,7 +1377,7 @@ void ProcessStrWid(WILC_Char *pcPacket, s32 *ps32PktLen,
 /*                                                                           */
 /*****************************************************************************/
 
-void ProcessAdrWid(WILC_Char *pcPacket, s32 *ps32PktLen,
+void ProcessAdrWid(char *pcPacket, s32 *ps32PktLen,
 		   tstrWID *pstrWID, u8 *pu8val)
 {
 	u16 u16MsgLen = 0;
@@ -1441,7 +1441,7 @@ void ProcessAdrWid(WILC_Char *pcPacket, s32 *ps32PktLen,
 /*                                                                           */
 /*****************************************************************************/
 
-void ProcessBinWid(WILC_Char *pcPacket, s32 *ps32PktLen,
+void ProcessBinWid(char *pcPacket, s32 *ps32PktLen,
 		   tstrWID *pstrWID, u8 *pu8val, s32 s32ValueSize)
 {
 	/* WILC_ERROR("processing Binary WIDs is not supported\n"); */
@@ -1802,7 +1802,7 @@ s32 ParseWriteResponse(u8 *pu8RespBuffer)
  *  @version		1.0
  */
 
-s32 CreatePacketHeader(WILC_Char *pcpacket, s32 *ps32PacketLength)
+s32 CreatePacketHeader(char *pcpacket, s32 *ps32PacketLength)
 {
 	s32 s32Error = WILC_SUCCESS;
 	u16 u16MsgLen = (u16)(*ps32PacketLength);
@@ -1911,7 +1911,7 @@ s32 CreateConfigPacket(s8 *ps8packet, s32 *ps32PacketLength,
 	return s32Error;
 }
 
-s32 ConfigWaitResponse(WILC_Char *pcRespBuffer, s32 s32MaxRespBuffLen, s32 *ps32BytesRead,
+s32 ConfigWaitResponse(char *pcRespBuffer, s32 s32MaxRespBuffLen, s32 *ps32BytesRead,
 			       bool bRespRequired)
 {
 	s32 s32Error = WILC_SUCCESS;
@@ -2016,7 +2016,7 @@ End_ConfigPkt:
 	return s32Error;
 }
 #endif
-s32 ConfigProvideResponse(WILC_Char *pcRespBuffer, s32 s32RespLen)
+s32 ConfigProvideResponse(char *pcRespBuffer, s32 s32RespLen)
 {
 	s32 s32Error = WILC_SUCCESS;
 
diff --git a/drivers/staging/wilc1000/coreconfigurator.h b/drivers/staging/wilc1000/coreconfigurator.h
index 6ed82e2..6c1dad1 100644
--- a/drivers/staging/wilc1000/coreconfigurator.h
+++ b/drivers/staging/wilc1000/coreconfigurator.h
@@ -461,12 +461,12 @@ typedef struct {
 
 #ifndef CONNECT_DIRECT
 typedef struct wid_site_survey_reslts {
-	WILC_Char SSID[MAX_SSID_LEN];
+	char SSID[MAX_SSID_LEN];
 	u8 BssType;
 	u8 Channel;
 	u8 SecurityStatus;
 	u8 BSSID[6];
-	WILC_Char RxPower;
+	char RxPower;
 	u8 Reserved;
 
 } wid_site_survey_reslts_s;
diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 1e9a2f1..e091bbc 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -452,7 +452,7 @@ typedef union _tuniHostIFmsgBody {
 	tstrHostIfRemainOnChan strHostIfRemainOnChan;
 	tstrHostIfRegisterFrame strHostIfRegisterFrame;
 	#endif
-	WILC_Char *pUserData;
+	char *pUserData;
 	tstrHostIFDelAllSta strHostIFDelAllSta;
 } tuniHostIFmsgBody;
 
@@ -474,7 +474,7 @@ typedef struct _tstrHostIFmsg {
 
 #ifdef CONNECT_DIRECT
 typedef struct _tstrWidJoinReqExt {
-	WILC_Char SSID[MAX_SSID_LEN];
+	char SSID[MAX_SSID_LEN];
 	u8 u8channel;
 	u8 BSSID[6];
 } tstrWidJoinReqExt;
@@ -489,7 +489,7 @@ typedef struct _tstrJoinBssParam {
 	u16 beacon_period;
 	u16 cap_info;
 	u8 au8bssid[6];
-	WILC_Char ssid[MAX_SSID_LEN];
+	char ssid[MAX_SSID_LEN];
 	u8 ssidLen;
 	u8 supp_rates[MAX_RATES_SUPPORTED + 1];
 	u8 ht_capable;
@@ -616,8 +616,8 @@ static s32 Handle_SetChannel(void *drvHandler, tstrHostIFSetChan *pstrHostIFSetC
 	/*prepare configuration packet*/
 	strWID.u16WIDid = (u16)WID_CURRENT_CHANNEL;
 	strWID.enuWIDtype = WID_CHAR;
-	strWID.ps8WidVal = (WILC_Char *)&(pstrHostIFSetChan->u8SetChan);
-	strWID.s32ValueSize = sizeof(WILC_Char);
+	strWID.ps8WidVal = (char *)&(pstrHostIFSetChan->u8SetChan);
+	strWID.s32ValueSize = sizeof(char);
 
 	PRINT_D(HOSTINF_DBG, "Setting channel\n");
 	/*Sending Cfg*/
@@ -944,7 +944,7 @@ static s32 Handle_CfgParam(void *drvHandler, tstrHostIFCfgParamAttr *strHostIFCf
 			strWIDList[u8WidCnt].u16WIDid = WID_BSS_TYPE;
 			strWIDList[u8WidCnt].ps8WidVal = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.bss_type;
 			strWIDList[u8WidCnt].enuWIDtype = WID_CHAR;
-			strWIDList[u8WidCnt].s32ValueSize = sizeof(WILC_Char);
+			strWIDList[u8WidCnt].s32ValueSize = sizeof(char);
 			pstrWFIDrv->strCfgValues.bss_type = (u8)strHostIFCfgParamAttr->pstrCfgParamVal.bss_type;
 		} else {
 			WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
@@ -962,7 +962,7 @@ static s32 Handle_CfgParam(void *drvHandler, tstrHostIFCfgParamAttr *strHostIFCf
 			strWIDList[u8WidCnt].u16WIDid = WID_AUTH_TYPE;
 			strWIDList[u8WidCnt].ps8WidVal = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.auth_type;
 			strWIDList[u8WidCnt].enuWIDtype = WID_CHAR;
-			strWIDList[u8WidCnt].s32ValueSize = sizeof(WILC_Char);
+			strWIDList[u8WidCnt].s32ValueSize = sizeof(char);
 			pstrWFIDrv->strCfgValues.auth_type = (u8)strHostIFCfgParamAttr->pstrCfgParamVal.auth_type;
 		} else {
 			WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
@@ -994,7 +994,7 @@ static s32 Handle_CfgParam(void *drvHandler, tstrHostIFCfgParamAttr *strHostIFCf
 			strWIDList[u8WidCnt].u16WIDid = WID_POWER_MANAGEMENT;
 			strWIDList[u8WidCnt].ps8WidVal = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.power_mgmt_mode;
 			strWIDList[u8WidCnt].enuWIDtype = WID_CHAR;
-			strWIDList[u8WidCnt].s32ValueSize = sizeof(WILC_Char);
+			strWIDList[u8WidCnt].s32ValueSize = sizeof(char);
 			pstrWFIDrv->strCfgValues.power_mgmt_mode = (u8)strHostIFCfgParamAttr->pstrCfgParamVal.power_mgmt_mode;
 		} else {
 			WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
@@ -1064,7 +1064,7 @@ static s32 Handle_CfgParam(void *drvHandler, tstrHostIFCfgParamAttr *strHostIFCf
 			strWIDList[u8WidCnt].u16WIDid = WID_PREAMBLE;
 			strWIDList[u8WidCnt].ps8WidVal = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.preamble_type;
 			strWIDList[u8WidCnt].enuWIDtype = WID_CHAR;
-			strWIDList[u8WidCnt].s32ValueSize = sizeof(WILC_Char);
+			strWIDList[u8WidCnt].s32ValueSize = sizeof(char);
 			pstrWFIDrv->strCfgValues.preamble_type = strHostIFCfgParamAttr->pstrCfgParamVal.preamble_type;
 		} else {
 			WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
@@ -1076,7 +1076,7 @@ static s32 Handle_CfgParam(void *drvHandler, tstrHostIFCfgParamAttr *strHostIFCf
 			strWIDList[u8WidCnt].u16WIDid = WID_SHORT_SLOT_ALLOWED;
 			strWIDList[u8WidCnt].ps8WidVal = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.short_slot_allowed;
 			strWIDList[u8WidCnt].enuWIDtype = WID_CHAR;
-			strWIDList[u8WidCnt].s32ValueSize = sizeof(WILC_Char);
+			strWIDList[u8WidCnt].s32ValueSize = sizeof(char);
 			pstrWFIDrv->strCfgValues.short_slot_allowed = (u8)strHostIFCfgParamAttr->pstrCfgParamVal.short_slot_allowed;
 		} else {
 			WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
@@ -1092,7 +1092,7 @@ static s32 Handle_CfgParam(void *drvHandler, tstrHostIFCfgParamAttr *strHostIFCf
 			strWIDList[u8WidCnt].u16WIDid = WID_11N_TXOP_PROT_DISABLE;
 			strWIDList[u8WidCnt].ps8WidVal = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.txop_prot_disabled;
 			strWIDList[u8WidCnt].enuWIDtype = WID_CHAR;
-			strWIDList[u8WidCnt].s32ValueSize = sizeof(WILC_Char);
+			strWIDList[u8WidCnt].s32ValueSize = sizeof(char);
 			pstrWFIDrv->strCfgValues.txop_prot_disabled = (u8)strHostIFCfgParamAttr->pstrCfgParamVal.txop_prot_disabled;
 		} else {
 			WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
@@ -1118,7 +1118,7 @@ static s32 Handle_CfgParam(void *drvHandler, tstrHostIFCfgParamAttr *strHostIFCf
 			strWIDList[u8WidCnt].u16WIDid = WID_DTIM_PERIOD;
 			strWIDList[u8WidCnt].ps8WidVal = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.dtim_period;
 			strWIDList[u8WidCnt].enuWIDtype = WID_CHAR;
-			strWIDList[u8WidCnt].s32ValueSize = sizeof(WILC_Char);
+			strWIDList[u8WidCnt].s32ValueSize = sizeof(char);
 			pstrWFIDrv->strCfgValues.dtim_period = strHostIFCfgParamAttr->pstrCfgParamVal.dtim_period;
 		} else {
 			WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
@@ -1135,7 +1135,7 @@ static s32 Handle_CfgParam(void *drvHandler, tstrHostIFCfgParamAttr *strHostIFCf
 			strWIDList[u8WidCnt].u16WIDid = WID_SITE_SURVEY;
 			strWIDList[u8WidCnt].ps8WidVal = (s8 *)&strHostIFCfgParamAttr->pstrCfgParamVal.site_survey_enabled;
 			strWIDList[u8WidCnt].enuWIDtype = WID_CHAR;
-			strWIDList[u8WidCnt].s32ValueSize = sizeof(WILC_Char);
+			strWIDList[u8WidCnt].s32ValueSize = sizeof(char);
 			pstrWFIDrv->strCfgValues.site_survey_enabled = (u8)strHostIFCfgParamAttr->pstrCfgParamVal.site_survey_enabled;
 		} else {
 			WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
@@ -1332,7 +1332,7 @@ static s32 Handle_Scan(void *drvHandler, tstrHostIFscanAttr *pstrHostIFscanAttr)
 	/*Scan Type*/
 	strWIDList[u32WidsCount].u16WIDid = WID_SCAN_TYPE;
 	strWIDList[u32WidsCount].enuWIDtype = WID_CHAR;
-	strWIDList[u32WidsCount].s32ValueSize = sizeof(WILC_Char);
+	strWIDList[u32WidsCount].s32ValueSize = sizeof(char);
 	strWIDList[u32WidsCount].ps8WidVal = (s8 *)(&(pstrHostIFscanAttr->u8ScanType));
 	u32WidsCount++;
 
@@ -1358,7 +1358,7 @@ static s32 Handle_Scan(void *drvHandler, tstrHostIFscanAttr *pstrHostIFscanAttr)
 	/*Scan Request*/
 	strWIDList[u32WidsCount].u16WIDid = WID_START_SCAN_REQ;
 	strWIDList[u32WidsCount].enuWIDtype = WID_CHAR;
-	strWIDList[u32WidsCount].s32ValueSize = sizeof(WILC_Char);
+	strWIDList[u32WidsCount].s32ValueSize = sizeof(char);
 	strWIDList[u32WidsCount].ps8WidVal = (s8 *)(&(pstrHostIFscanAttr->u8ScanSource));
 	u32WidsCount++;
 
@@ -1446,7 +1446,7 @@ static s32 Handle_ScanDone(void *drvHandler, tenuScanEvent enuEvent)
 		strWID.u16WIDid	= (u16)WID_ABORT_RUNNING_SCAN;
 		strWID.enuWIDtype	= WID_CHAR;
 		strWID.ps8WidVal = (s8 *)&u8abort_running_scan;
-		strWID.s32ValueSize = sizeof(WILC_Char);
+		strWID.s32ValueSize = sizeof(char);
 
 		/*Sending Cfg*/
 		s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
@@ -1612,7 +1612,7 @@ static s32 Handle_Connect(void *drvHandler, tstrHostIFconnectAttr *pstrHostIFcon
 		}
 		strWIDList[u32WidsCount].u16WIDid = (u16)WID_11I_MODE;
 		strWIDList[u32WidsCount].enuWIDtype = WID_CHAR;
-		strWIDList[u32WidsCount].s32ValueSize = sizeof(WILC_Char);
+		strWIDList[u32WidsCount].s32ValueSize = sizeof(char);
 		strWIDList[u32WidsCount].ps8WidVal = (s8 *)(&(pstrWFIDrv->strWILC_UsrConnReq.u8security));
 		u32WidsCount++;
 
@@ -1620,7 +1620,7 @@ static s32 Handle_Connect(void *drvHandler, tstrHostIFconnectAttr *pstrHostIFcon
 
 		strWIDList[u32WidsCount].u16WIDid = (u16)WID_AUTH_TYPE;
 		strWIDList[u32WidsCount].enuWIDtype = WID_CHAR;
-		strWIDList[u32WidsCount].s32ValueSize = sizeof(WILC_Char);
+		strWIDList[u32WidsCount].s32ValueSize = sizeof(char);
 		strWIDList[u32WidsCount].ps8WidVal = (s8 *)(&pstrWFIDrv->strWILC_UsrConnReq.tenuAuth_type);
 		u32WidsCount++;
 
@@ -1635,7 +1635,7 @@ static s32 Handle_Connect(void *drvHandler, tstrHostIFconnectAttr *pstrHostIFcon
 
 		strWIDList[u32WidsCount].u16WIDid = (u16)WID_JOIN_REQ;
 		strWIDList[u32WidsCount].enuWIDtype = WID_CHAR;
-		strWIDList[u32WidsCount].s32ValueSize = sizeof(WILC_Char);
+		strWIDList[u32WidsCount].s32ValueSize = sizeof(char);
 		strWIDList[u32WidsCount].ps8WidVal = (s8 *)&u8bssDscListIndex;
 		u32WidsCount++;
 
@@ -1758,7 +1758,7 @@ static s32 Handle_Connect(void *drvHandler, tstrHostIFconnectAttr *pstrHostIFcon
 	}
 	strWIDList[u32WidsCount].u16WIDid = (u16)WID_11I_MODE;
 	strWIDList[u32WidsCount].enuWIDtype = WID_CHAR;
-	strWIDList[u32WidsCount].s32ValueSize = sizeof(WILC_Char);
+	strWIDList[u32WidsCount].s32ValueSize = sizeof(char);
 	strWIDList[u32WidsCount].ps8WidVal = (s8 *)(&(pstrWFIDrv->strWILC_UsrConnReq.u8security));
 	u32WidsCount++;
 
@@ -1771,7 +1771,7 @@ static s32 Handle_Connect(void *drvHandler, tstrHostIFconnectAttr *pstrHostIFcon
 
 	strWIDList[u32WidsCount].u16WIDid = (u16)WID_AUTH_TYPE;
 	strWIDList[u32WidsCount].enuWIDtype = WID_CHAR;
-	strWIDList[u32WidsCount].s32ValueSize = sizeof(WILC_Char);
+	strWIDList[u32WidsCount].s32ValueSize = sizeof(char);
 	strWIDList[u32WidsCount].ps8WidVal = (s8 *)(&pstrWFIDrv->strWILC_UsrConnReq.tenuAuth_type);
 	u32WidsCount++;
 
@@ -2093,7 +2093,7 @@ static s32 Handle_FlushConnect(void *drvHandler)
 
 	strWIDList[u32WidsCount].u16WIDid = (u16)WID_11I_MODE;
 	strWIDList[u32WidsCount].enuWIDtype = WID_CHAR;
-	strWIDList[u32WidsCount].s32ValueSize = sizeof(WILC_Char);
+	strWIDList[u32WidsCount].s32ValueSize = sizeof(char);
 	strWIDList[u32WidsCount].ps8WidVal = (s8 *)(&(gu8Flushed11iMode));
 	u32WidsCount++;
 
@@ -2101,7 +2101,7 @@ static s32 Handle_FlushConnect(void *drvHandler)
 
 	strWIDList[u32WidsCount].u16WIDid = (u16)WID_AUTH_TYPE;
 	strWIDList[u32WidsCount].enuWIDtype = WID_CHAR;
-	strWIDList[u32WidsCount].s32ValueSize = sizeof(WILC_Char);
+	strWIDList[u32WidsCount].s32ValueSize = sizeof(char);
 	strWIDList[u32WidsCount].ps8WidVal = (s8 *)(&gu8FlushedAuthType);
 	u32WidsCount++;
 
@@ -2201,7 +2201,7 @@ static s32 Handle_ConnectTimeout(void *drvHandler)
 	strWID.u16WIDid = (u16)WID_DISCONNECT;
 	strWID.enuWIDtype = WID_CHAR;
 	strWID.ps8WidVal = (s8 *)&u16DummyReasonCode;
-	strWID.s32ValueSize = sizeof(WILC_Char);
+	strWID.s32ValueSize = sizeof(char);
 
 	PRINT_D(HOSTINF_DBG, "Sending disconnect request\n");
 
@@ -2731,19 +2731,19 @@ static int Handle_Key(void *drvHandler, tstrHostIFkeyAttr *pstrHostIFkeyAttr)
 			PRINT_D(GENERIC_DBG, "ID Hostint is %d\n", (pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwepAttr.u8Wepidx));
 			strWIDList[0].u16WIDid = (u16)WID_11I_MODE;
 			strWIDList[0].enuWIDtype = WID_CHAR;
-			strWIDList[0].s32ValueSize = sizeof(WILC_Char);
+			strWIDList[0].s32ValueSize = sizeof(char);
 			strWIDList[0].ps8WidVal = (s8 *)(&(pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwepAttr.u8mode));
 
 			strWIDList[1].u16WIDid     = WID_AUTH_TYPE;
 			strWIDList[1].enuWIDtype  = WID_CHAR;
-			strWIDList[1].s32ValueSize = sizeof(WILC_Char);
+			strWIDList[1].s32ValueSize = sizeof(char);
 			strWIDList[1].ps8WidVal = (s8 *)(&(pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwepAttr.tenuAuth_type));
 
 			strWIDList[2].u16WIDid	= (u16)WID_KEY_ID;
 			strWIDList[2].enuWIDtype	= WID_CHAR;
 
 			strWIDList[2].ps8WidVal	= (s8 *)(&(pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwepAttr.u8Wepidx));
-			strWIDList[2].s32ValueSize = sizeof(WILC_Char);
+			strWIDList[2].s32ValueSize = sizeof(char);
 
 
 			pu8keybuf = (u8 *)WILC_MALLOC(pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwepAttr.u8WepKeylen);
@@ -2811,7 +2811,7 @@ static int Handle_Key(void *drvHandler, tstrHostIFkeyAttr *pstrHostIFkeyAttr)
 			strWID.u16WIDid	= (u16)WID_KEY_ID;
 			strWID.enuWIDtype	= WID_CHAR;
 			strWID.ps8WidVal	= (s8 *)(&(pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwepAttr.u8Wepidx));
-			strWID.s32ValueSize = sizeof(WILC_Char);
+			strWID.s32ValueSize = sizeof(char);
 
 			PRINT_D(HOSTINF_DBG, "Setting default key index\n");
 
@@ -2853,7 +2853,7 @@ static int Handle_Key(void *drvHandler, tstrHostIFkeyAttr *pstrHostIFkeyAttr)
 			/* pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwpaAttr.u8Ciphermode =  0X51; */
 			strWIDList[0].u16WIDid = (u16)WID_11I_MODE;
 			strWIDList[0].enuWIDtype = WID_CHAR;
-			strWIDList[0].s32ValueSize = sizeof(WILC_Char);
+			strWIDList[0].s32ValueSize = sizeof(char);
 			strWIDList[0].ps8WidVal = (s8 *)(&(pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwpaAttr.u8Ciphermode));
 
 			strWIDList[1].u16WIDid	= (u16)WID_ADD_RX_GTK;
@@ -2957,7 +2957,7 @@ _WPARxGtk_end_case_:
 
 			strWIDList[0].u16WIDid = (u16)WID_11I_MODE;
 			strWIDList[0].enuWIDtype = WID_CHAR;
-			strWIDList[0].s32ValueSize = sizeof(WILC_Char);
+			strWIDList[0].s32ValueSize = sizeof(char);
 			strWIDList[0].ps8WidVal = (s8 *)(&(pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwpaAttr.u8Ciphermode));
 
 			strWIDList[1].u16WIDid	= (u16)WID_ADD_PTK;
@@ -3080,7 +3080,7 @@ static void Handle_Disconnect(void *drvHandler)
 	strWID.u16WIDid = (u16)WID_DISCONNECT;
 	strWID.enuWIDtype = WID_CHAR;
 	strWID.ps8WidVal = (s8 *)&u16DummyReasonCode;
-	strWID.s32ValueSize = sizeof(WILC_Char);
+	strWID.s32ValueSize = sizeof(char);
 
 
 
@@ -3205,7 +3205,7 @@ static s32 Switch_Log_Terminal(void *drvHandler)
 	strWID.u16WIDid = (u16)WID_LOGTerminal_Switch;
 	strWID.enuWIDtype = WID_CHAR;
 	strWID.ps8WidVal = &dummy;
-	strWID.s32ValueSize = sizeof(WILC_Char);
+	strWID.s32ValueSize = sizeof(char);
 
 	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
 
@@ -3247,7 +3247,7 @@ static s32 Handle_GetChnl(void *drvHandler)
 	strWID.u16WIDid = (u16)WID_CURRENT_CHANNEL;
 	strWID.enuWIDtype = WID_CHAR;
 	strWID.ps8WidVal = (s8 *)&gu8Chnl;
-	strWID.s32ValueSize = sizeof(WILC_Char);
+	strWID.s32ValueSize = sizeof(char);
 
 	PRINT_D(HOSTINF_DBG, "Getting channel value\n");
 
@@ -3290,7 +3290,7 @@ static void Handle_GetRssi(void *drvHandler)
 	strWID.u16WIDid = (u16)WID_RSSI;
 	strWID.enuWIDtype = WID_CHAR;
 	strWID.ps8WidVal = &gs8Rssi;
-	strWID.s32ValueSize = sizeof(WILC_Char);
+	strWID.s32ValueSize = sizeof(char);
 
 	/*Sending Cfg*/
 	PRINT_D(HOSTINF_DBG, "Getting RSSI value\n");
@@ -3322,7 +3322,7 @@ static void Handle_GetLinkspeed(void *drvHandler)
 	strWID.u16WIDid = (u16)WID_LINKSPEED;
 	strWID.enuWIDtype = WID_CHAR;
 	strWID.ps8WidVal = &gs8lnkspd;
-	strWID.s32ValueSize = sizeof(WILC_Char);
+	strWID.s32ValueSize = sizeof(char);
 	/*Sending Cfg*/
 	PRINT_D(HOSTINF_DBG, "Getting LINKSPEED value\n");
 
@@ -3348,13 +3348,13 @@ s32 Handle_GetStatistics(void *drvHandler, tstrStatistics *pstrStatistics)
 
 	strWIDList[u32WidsCount].u16WIDid = WID_LINKSPEED;
 	strWIDList[u32WidsCount].enuWIDtype = WID_CHAR;
-	strWIDList[u32WidsCount].s32ValueSize = sizeof(WILC_Char);
+	strWIDList[u32WidsCount].s32ValueSize = sizeof(char);
 	strWIDList[u32WidsCount].ps8WidVal = (s8 *)(&(pstrStatistics->u8LinkSpeed));
 	u32WidsCount++;
 
 	strWIDList[u32WidsCount].u16WIDid = WID_RSSI;
 	strWIDList[u32WidsCount].enuWIDtype = WID_CHAR;
-	strWIDList[u32WidsCount].s32ValueSize = sizeof(WILC_Char);
+	strWIDList[u32WidsCount].s32ValueSize = sizeof(char);
 	strWIDList[u32WidsCount].ps8WidVal = (s8 *)(&(pstrStatistics->s8RSSI));
 	u32WidsCount++;
 
@@ -3551,7 +3551,7 @@ static void Handle_DelBeacon(void *drvHandler, tstrHostIFDelBeacon *pstrDelBeaco
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
 	strWID.u16WIDid = (u16)WID_DEL_BEACON;
 	strWID.enuWIDtype = WID_CHAR;
-	strWID.s32ValueSize = sizeof(WILC_Char);
+	strWID.s32ValueSize = sizeof(char);
 	strWID.ps8WidVal = &gu8DelBcn;
 
 	if (strWID.ps8WidVal == NULL) {
@@ -4077,7 +4077,7 @@ static void Handle_PowerManagement(void *drvHandler, tstrHostIfPowerMgmtParam *s
 	}
 	PRINT_D(HOSTINF_DBG, "Handling power mgmt to %d\n", s8PowerMode);
 	strWID.ps8WidVal = &s8PowerMode;
-	strWID.s32ValueSize = sizeof(WILC_Char);
+	strWID.s32ValueSize = sizeof(char);
 
 	PRINT_D(HOSTINF_DBG, "Handling Power Management\n");
 
@@ -5483,7 +5483,7 @@ s32 host_int_set_start_scan_req(WILC_WFIDrvHandle hWFIDrv, u8 scanSource)
 	strWID.u16WIDid = (u16)WID_START_SCAN_REQ;
 	strWID.enuWIDtype = WID_CHAR;
 	strWID.ps8WidVal = (s8 *)&scanSource;
-	strWID.s32ValueSize = sizeof(WILC_Char);
+	strWID.s32ValueSize = sizeof(char);
 
 	return s32Error;
 }
@@ -5513,7 +5513,7 @@ s32 host_int_get_start_scan_req(WILC_WFIDrvHandle hWFIDrv, u8 *pu8ScanSource)
 	strWID.u16WIDid = (u16)WID_START_SCAN_REQ;
 	strWID.enuWIDtype = WID_CHAR;
 	strWID.ps8WidVal = (s8 *)pu8ScanSource;
-	strWID.s32ValueSize = sizeof(WILC_Char);
+	strWID.s32ValueSize = sizeof(char);
 
 	return s32Error;
 }
@@ -5733,7 +5733,7 @@ s32 host_int_disconnect_station(WILC_WFIDrvHandle hWFIDrv, u8 assoc_id)
 	strWID.u16WIDid = (u16)WID_DISCONNECT;
 	strWID.enuWIDtype = WID_CHAR;
 	strWID.ps8WidVal = (s8 *)&assoc_id;
-	strWID.s32ValueSize = sizeof(WILC_Char);
+	strWID.s32ValueSize = sizeof(char);
 
 	return s32Error;
 }
@@ -6057,7 +6057,7 @@ s32 host_int_test_set_int_wid(WILC_WFIDrvHandle hWFIDrv, u32 u32TestMemAddr)
 	/*prepare configuration packet*/
 	strWID.u16WIDid = (u16)WID_MEMORY_ADDRESS;
 	strWID.enuWIDtype = WID_INT;
-	strWID.ps8WidVal = (WILC_Char *)&u32TestMemAddr;
+	strWID.ps8WidVal = (char *)&u32TestMemAddr;
 	strWID.s32ValueSize = sizeof(u32);
 
 	/*Sending Cfg*/
@@ -6266,7 +6266,7 @@ s32 host_int_get_statistics(WILC_WFIDrvHandle hWFIDrv, tstrStatistics *pstrStati
 	WILC_memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
 
 	strHostIFmsg.u16MsgId = HOST_IF_MSG_GET_STATISTICS;
-	strHostIFmsg.uniHostIFmsgBody.pUserData = (WILC_Char *)pstrStatistics;
+	strHostIFmsg.uniHostIFmsgBody.pUserData = (char *)pstrStatistics;
 	strHostIFmsg.drvHandler = hWFIDrv;
 	/* send the message */
 	s32Error =	WILC_MsgQueueSend(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg), NULL);
diff --git a/drivers/staging/wilc1000/wilc_memory.c b/drivers/staging/wilc1000/wilc_memory.c
index 2282951..5670b5a 100644
--- a/drivers/staging/wilc1000/wilc_memory.c
+++ b/drivers/staging/wilc1000/wilc_memory.c
@@ -7,7 +7,7 @@
  *  @version	1.0
  */
 void *WILC_MemoryAlloc(u32 u32Size, tstrWILC_MemoryAttrs *strAttrs,
-		       WILC_Char *pcFileName, u32 u32LineNo)
+		       char *pcFileName, u32 u32LineNo)
 {
 	if (u32Size > 0) {
 		return kmalloc(u32Size, GFP_ATOMIC);
@@ -22,7 +22,7 @@ void *WILC_MemoryAlloc(u32 u32Size, tstrWILC_MemoryAttrs *strAttrs,
  *  @version	1.0
  */
 void *WILC_MemoryCalloc(u32 u32Size, tstrWILC_MemoryAttrs *strAttrs,
-			WILC_Char *pcFileName, u32 u32LineNo)
+			char *pcFileName, u32 u32LineNo)
 {
 	return kcalloc(u32Size, 1, GFP_KERNEL);
 }
@@ -33,7 +33,7 @@ void *WILC_MemoryCalloc(u32 u32Size, tstrWILC_MemoryAttrs *strAttrs,
  *  @version	1.0
  */
 void *WILC_MemoryRealloc(void *pvOldBlock, u32 u32NewSize,
-			 tstrWILC_MemoryAttrs *strAttrs, WILC_Char *pcFileName, u32 u32LineNo)
+			 tstrWILC_MemoryAttrs *strAttrs, char *pcFileName, u32 u32LineNo)
 {
 	if (u32NewSize == 0) {
 		kfree(pvOldBlock);
@@ -52,7 +52,7 @@ void *WILC_MemoryRealloc(void *pvOldBlock, u32 u32NewSize,
  *  @version	1.0
  */
 void WILC_MemoryFree(const void *pvBlock, tstrWILC_MemoryAttrs *strAttrs,
-		     WILC_Char *pcFileName, u32 u32LineNo)
+		     char *pcFileName, u32 u32LineNo)
 {
 	kfree(pvBlock);
 }
diff --git a/drivers/staging/wilc1000/wilc_memory.h b/drivers/staging/wilc1000/wilc_memory.h
index 8a2be8a..1bc4b53 100644
--- a/drivers/staging/wilc1000/wilc_memory.h
+++ b/drivers/staging/wilc1000/wilc_memory.h
@@ -42,7 +42,7 @@ typedef struct {
  *  @version	1.0
  */
 void *WILC_MemoryAlloc(u32 u32Size, tstrWILC_MemoryAttrs *strAttrs,
-		       WILC_Char *pcFileName, u32 u32LineNo);
+		       char *pcFileName, u32 u32LineNo);
 
 /*!
  *  @brief	Allocates a given size of bytes and zero filling it
@@ -66,7 +66,7 @@ void *WILC_MemoryAlloc(u32 u32Size, tstrWILC_MemoryAttrs *strAttrs,
  *  @version	1.0
  */
 void *WILC_MemoryCalloc(u32 u32Size, tstrWILC_MemoryAttrs *strAttrs,
-			WILC_Char *pcFileName, u32 u32LineNo);
+			char *pcFileName, u32 u32LineNo);
 
 /*!
  *  @brief	Reallocates a given block to a new size
@@ -94,7 +94,7 @@ void *WILC_MemoryCalloc(u32 u32Size, tstrWILC_MemoryAttrs *strAttrs,
  *  @version	1.0
  */
 void *WILC_MemoryRealloc(void *pvOldBlock, u32 u32NewSize,
-			 tstrWILC_MemoryAttrs *strAttrs, WILC_Char *pcFileName, u32 u32LineNo);
+			 tstrWILC_MemoryAttrs *strAttrs, char *pcFileName, u32 u32LineNo);
 
 /*!
  *  @brief	Frees given block
@@ -114,7 +114,7 @@ void *WILC_MemoryRealloc(void *pvOldBlock, u32 u32NewSize,
  *  @version	1.0
  */
 void WILC_MemoryFree(const void *pvBlock, tstrWILC_MemoryAttrs *strAttrs,
-			WILC_Char *pcFileName, u32 u32LineNo);
+			char *pcFileName, u32 u32LineNo);
 
 /*!
  * @brief	standrad malloc wrapper with custom attributes
diff --git a/drivers/staging/wilc1000/wilc_oswrapper.h b/drivers/staging/wilc1000/wilc_oswrapper.h
index d5835d6..e97aa96 100644
--- a/drivers/staging/wilc1000/wilc_oswrapper.h
+++ b/drivers/staging/wilc1000/wilc_oswrapper.h
@@ -13,9 +13,6 @@
 /* OS Wrapper interface version */
 #define WILC_OSW_INTERFACE_VER 2
 
-/* Character types */
-typedef char WILC_Char;
-
 /* Os Configuration File */
 #include "wilc_osconfig.h"
 #include "wilc_platform.h"
diff --git a/drivers/staging/wilc1000/wilc_strutils.c b/drivers/staging/wilc1000/wilc_strutils.c
index e9f487a..ac9bb06 100644
--- a/drivers/staging/wilc1000/wilc_strutils.c
+++ b/drivers/staging/wilc1000/wilc_strutils.c
@@ -40,13 +40,13 @@ void *WILC_memset(void *pvTarget, u8 u8SetValue, u32 u32Count)
  *  @date	18 Aug 2010
  *  @version	1.0
  */
-WILC_Char *WILC_strncpy(WILC_Char *pcTarget, const WILC_Char *pcSource,
+char *WILC_strncpy(char *pcTarget, const char *pcSource,
 			u32 u32Count)
 {
 	return strncpy(pcTarget, pcSource, u32Count);
 }
 
-s32 WILC_strncmp(const WILC_Char *pcStr1, const WILC_Char *pcStr2,
+s32 WILC_strncmp(const char *pcStr1, const char *pcStr2,
 			 u32 u32Count)
 {
 	s32 s32Result;
@@ -74,7 +74,7 @@ s32 WILC_strncmp(const WILC_Char *pcStr1, const WILC_Char *pcStr2,
  *  @date	18 Aug 2010
  *  @version	1.0
  */
-u32 WILC_strlen(const WILC_Char *pcStr)
+u32 WILC_strlen(const char *pcStr)
 {
 	return (u32)strlen(pcStr);
 }
diff --git a/drivers/staging/wilc1000/wilc_strutils.h b/drivers/staging/wilc1000/wilc_strutils.h
index 75670a28..bb31bea 100644
--- a/drivers/staging/wilc1000/wilc_strutils.h
+++ b/drivers/staging/wilc1000/wilc_strutils.h
@@ -92,7 +92,7 @@ void *WILC_memset(void *pvTarget, u8 u8SetValue, u32 u32Count);
  *  @date	18 Aug 2010
  *  @version	1.0
  */
-WILC_Char *WILC_strncpy(WILC_Char *pcTarget, const WILC_Char *pcSource,
+char *WILC_strncpy(char *pcTarget, const char *pcSource,
 			u32 u32Count);
 
 /*!
@@ -113,7 +113,7 @@ WILC_Char *WILC_strncpy(WILC_Char *pcTarget, const WILC_Char *pcSource,
  *  @date	7 Dec 2010
  *  @version	1.0
  */
-s32 WILC_strncmp(const WILC_Char *pcStr1, const WILC_Char *pcStr2,
+s32 WILC_strncmp(const char *pcStr1, const char *pcStr2,
 			 u32 u32Count);
 
 /*!
@@ -125,6 +125,6 @@ s32 WILC_strncmp(const WILC_Char *pcStr1, const WILC_Char *pcStr2,
  *  @date	18 Aug 2010
  *  @version	1.0
  */
-u32 WILC_strlen(const WILC_Char *pcStr);
+u32 WILC_strlen(const char *pcStr);
 
 #endif
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 2293949..9dcb326 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -829,9 +829,9 @@ static int WILC_WFI_CfgConnect(struct wiphy *wiphy, struct net_device *dev,
 	u32 i;
 	u8 u8security = NO_ENCRYPT;
 	AUTHTYPE_T tenuAuth_type = ANY;
-	WILC_Char *pcgroup_encrypt_val = NULL;
-	WILC_Char *pccipher_group = NULL;
-	WILC_Char *pcwpa_version = NULL;
+	char *pcgroup_encrypt_val = NULL;
+	char *pccipher_group = NULL;
+	char *pcwpa_version = NULL;
 
 	struct WILC_WFI_priv *priv;
 	tstrWILC_WFIDrv *pstrWFIDrv;
-- 
2.4.3

