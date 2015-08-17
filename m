Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:33319 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753134AbbHQCF3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Aug 2015 22:05:29 -0400
Received: by pabyb7 with SMTP id yb7so97249378pab.0
        for <linux-wireless@vger.kernel.org>; Sun, 16 Aug 2015 19:05:29 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, dean.lee@atmel.com,
	chris.park@atmel.com, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 3/6] staging: wilc1000: remove unnecessary void pointer cast
Date: Mon, 17 Aug 2015 11:05:12 +0900
Message-Id: <1439777115-25861-3-git-send-email-chaehyun.lim@gmail.com> (sfid-20150817_040532_984563_C935FAC2)
In-Reply-To: <1439777115-25861-1-git-send-email-chaehyun.lim@gmail.com>
References: <1439777115-25861-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes unnecessary void pointer cast of WILC_MALLOC.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/coreconfigurator.c       | 12 ++--
 drivers/staging/wilc1000/host_interface.c         | 78 +++++++++++------------
 drivers/staging/wilc1000/linux_wlan.c             |  2 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 18 +++---
 4 files changed, 55 insertions(+), 55 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index c81c41d..7c129aa 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -674,7 +674,7 @@ s32 CoreConfiguratorInit(void)
 	sema_init(&SemHandleSendPkt, 1);
 	sema_init(&SemHandlePktResp, 0);
 
-	gps8ConfigPacket = (s8 *)WILC_MALLOC(MAX_PACKET_BUFF_SIZE);
+	gps8ConfigPacket = WILC_MALLOC(MAX_PACKET_BUFF_SIZE);
 	if (gps8ConfigPacket == NULL) {
 		PRINT_ER("failed in gps8ConfigPacket allocation\n");
 		s32Error = WILC_NO_MEM;
@@ -810,7 +810,7 @@ s32 ParseNetworkInfo(u8 *pu8MsgBuffer, tstrNetworkInfo **ppstrNetworkInfo)
 		u32 u32Tsf_Lo;
 		u32 u32Tsf_Hi;
 
-		pstrNetworkInfo = (tstrNetworkInfo *)WILC_MALLOC(sizeof(tstrNetworkInfo));
+		pstrNetworkInfo = WILC_MALLOC(sizeof(tstrNetworkInfo));
 		memset((void *)(pstrNetworkInfo), 0, sizeof(tstrNetworkInfo));
 
 		pstrNetworkInfo->s8rssi = pu8WidVal[0];
@@ -860,7 +860,7 @@ s32 ParseNetworkInfo(u8 *pu8MsgBuffer, tstrNetworkInfo **ppstrNetworkInfo)
 		u16IEsLen = u16RxLen - (MAC_HDR_LEN + TIME_STAMP_LEN + BEACON_INTERVAL_LEN + CAP_INFO_LEN);
 
 		if (u16IEsLen > 0) {
-			pstrNetworkInfo->pu8IEs = (u8 *)WILC_MALLOC(u16IEsLen);
+			pstrNetworkInfo->pu8IEs = WILC_MALLOC(u16IEsLen);
 			memset((void *)(pstrNetworkInfo->pu8IEs), 0, u16IEsLen);
 
 			memcpy(pstrNetworkInfo->pu8IEs, pu8IEs, u16IEsLen);
@@ -927,7 +927,7 @@ s32 ParseAssocRespInfo(u8 *pu8Buffer, u32 u32BufferLen,
 	u8 *pu8IEs = 0;
 	u16 u16IEsLen = 0;
 
-	pstrConnectRespInfo = (tstrConnectRespInfo *)WILC_MALLOC(sizeof(tstrConnectRespInfo));
+	pstrConnectRespInfo = WILC_MALLOC(sizeof(tstrConnectRespInfo));
 	memset((void *)(pstrConnectRespInfo), 0, sizeof(tstrConnectRespInfo));
 
 	/* u16AssocRespLen = pu8Buffer[0]; */
@@ -947,7 +947,7 @@ s32 ParseAssocRespInfo(u8 *pu8Buffer, u32 u32BufferLen,
 		pu8IEs = &pu8Buffer[CAP_INFO_LEN + STATUS_CODE_LEN + AID_LEN];
 		u16IEsLen = u16AssocRespLen - (CAP_INFO_LEN + STATUS_CODE_LEN + AID_LEN);
 
-		pstrConnectRespInfo->pu8RespIEs = (u8 *)WILC_MALLOC(u16IEsLen);
+		pstrConnectRespInfo->pu8RespIEs = WILC_MALLOC(u16IEsLen);
 		memset((void *)(pstrConnectRespInfo->pu8RespIEs), 0, u16IEsLen);
 
 		memcpy(pstrConnectRespInfo->pu8RespIEs, pu8IEs, u16IEsLen);
@@ -1016,7 +1016,7 @@ s32 ParseSurveyResults(u8 ppu8RcvdSiteSurveyResults[][MAX_SURVEY_RESULT_FRAG_SIZ
 		}
 	}
 
-	pstrSurveyResults = (wid_site_survey_reslts_s *)WILC_MALLOC(u32SurveyResultsCount * sizeof(wid_site_survey_reslts_s));
+	pstrSurveyResults = WILC_MALLOC(u32SurveyResultsCount * sizeof(wid_site_survey_reslts_s));
 	if (pstrSurveyResults == NULL) {
 		u32SurveyResultsCount = 0;
 		WILC_ERRORREPORT(s32Error, WILC_NO_MEM);
diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index bab5319..ae7316b 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -788,7 +788,7 @@ s32 Handle_get_IPAddress(tstrWILC_WFIDrv *drvHandler, u8 *pu8IPAddr, u8 idx)
 	/*prepare configuration packet*/
 	strWID.u16WIDid = (u16)WID_IP_ADDRESS;
 	strWID.enuWIDtype = WID_STR;
-	strWID.ps8WidVal = (u8 *)WILC_MALLOC(IP_ALEN);
+	strWID.ps8WidVal = WILC_MALLOC(IP_ALEN);
 	strWID.s32ValueSize = IP_ALEN;
 
 	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
@@ -837,7 +837,7 @@ static s32 Handle_SetMacAddress(tstrWILC_WFIDrv *drvHandler, tstrHostIfSetMacAdd
 	s32 s32Error = WILC_SUCCESS;
 	tstrWID	strWID;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
-	u8 *mac_buf = (u8 *)WILC_MALLOC(ETH_ALEN);
+	u8 *mac_buf = WILC_MALLOC(ETH_ALEN);
 
 	if (mac_buf == NULL) {
 		PRINT_ER("No buffer to send mac address\n");
@@ -1558,13 +1558,13 @@ static s32 Handle_Connect(tstrWILC_WFIDrv *drvHandler, tstrHostIFconnectAttr *ps
 		PRINT_INFO(HOSTINF_DBG, "Saving connection parameters in global structure\n");
 
 		if (pstrHostIFconnectAttr->pu8bssid != NULL) {
-			pstrWFIDrv->strWILC_UsrConnReq.pu8bssid = (u8 *)WILC_MALLOC(6);
+			pstrWFIDrv->strWILC_UsrConnReq.pu8bssid = WILC_MALLOC(6);
 			memcpy(pstrWFIDrv->strWILC_UsrConnReq.pu8bssid, pstrHostIFconnectAttr->pu8bssid, 6);
 		}
 
 		pstrWFIDrv->strWILC_UsrConnReq.ssidLen = pstrHostIFconnectAttr->ssidLen;
 		if (pstrHostIFconnectAttr->pu8ssid != NULL) {
-			pstrWFIDrv->strWILC_UsrConnReq.pu8ssid = (u8 *)WILC_MALLOC(pstrHostIFconnectAttr->ssidLen + 1);
+			pstrWFIDrv->strWILC_UsrConnReq.pu8ssid = WILC_MALLOC(pstrHostIFconnectAttr->ssidLen + 1);
 			memcpy(pstrWFIDrv->strWILC_UsrConnReq.pu8ssid, pstrHostIFconnectAttr->pu8ssid,
 				    pstrHostIFconnectAttr->ssidLen);
 			pstrWFIDrv->strWILC_UsrConnReq.pu8ssid[pstrHostIFconnectAttr->ssidLen] = '\0';
@@ -1572,7 +1572,7 @@ static s32 Handle_Connect(tstrWILC_WFIDrv *drvHandler, tstrHostIFconnectAttr *ps
 
 		pstrWFIDrv->strWILC_UsrConnReq.ConnReqIEsLen = pstrHostIFconnectAttr->IEsLen;
 		if (pstrHostIFconnectAttr->pu8IEs != NULL) {
-			pstrWFIDrv->strWILC_UsrConnReq.pu8ConnReqIEs = (u8 *)WILC_MALLOC(pstrHostIFconnectAttr->IEsLen);
+			pstrWFIDrv->strWILC_UsrConnReq.pu8ConnReqIEs = WILC_MALLOC(pstrHostIFconnectAttr->IEsLen);
 			memcpy(pstrWFIDrv->strWILC_UsrConnReq.pu8ConnReqIEs, pstrHostIFconnectAttr->pu8IEs,
 				    pstrHostIFconnectAttr->IEsLen);
 		}
@@ -1665,13 +1665,13 @@ static s32 Handle_Connect(tstrWILC_WFIDrv *drvHandler, tstrHostIFconnectAttr *ps
 	#endif /*WILC_PARSE_SCAN_IN_HOST*/
 
 	if (pstrHostIFconnectAttr->pu8bssid != NULL) {
-		pstrWFIDrv->strWILC_UsrConnReq.pu8bssid = (u8 *)WILC_MALLOC(6);
+		pstrWFIDrv->strWILC_UsrConnReq.pu8bssid = WILC_MALLOC(6);
 		memcpy(pstrWFIDrv->strWILC_UsrConnReq.pu8bssid, pstrHostIFconnectAttr->pu8bssid, 6);
 	}
 
 	pstrWFIDrv->strWILC_UsrConnReq.ssidLen = pstrHostIFconnectAttr->ssidLen;
 	if (pstrHostIFconnectAttr->pu8ssid != NULL) {
-		pstrWFIDrv->strWILC_UsrConnReq.pu8ssid = (u8 *)WILC_MALLOC(pstrHostIFconnectAttr->ssidLen + 1);
+		pstrWFIDrv->strWILC_UsrConnReq.pu8ssid = WILC_MALLOC(pstrHostIFconnectAttr->ssidLen + 1);
 		memcpy(pstrWFIDrv->strWILC_UsrConnReq.pu8ssid, pstrHostIFconnectAttr->pu8ssid,
 			    pstrHostIFconnectAttr->ssidLen);
 		pstrWFIDrv->strWILC_UsrConnReq.pu8ssid[pstrHostIFconnectAttr->ssidLen] = '\0';
@@ -1679,7 +1679,7 @@ static s32 Handle_Connect(tstrWILC_WFIDrv *drvHandler, tstrHostIFconnectAttr *ps
 
 	pstrWFIDrv->strWILC_UsrConnReq.ConnReqIEsLen = pstrHostIFconnectAttr->IEsLen;
 	if (pstrHostIFconnectAttr->pu8IEs != NULL) {
-		pstrWFIDrv->strWILC_UsrConnReq.pu8ConnReqIEs = (u8 *)WILC_MALLOC(pstrHostIFconnectAttr->IEsLen);
+		pstrWFIDrv->strWILC_UsrConnReq.pu8ConnReqIEs = WILC_MALLOC(pstrHostIFconnectAttr->IEsLen);
 		memcpy(pstrWFIDrv->strWILC_UsrConnReq.pu8ConnReqIEs, pstrHostIFconnectAttr->pu8IEs,
 			    pstrHostIFconnectAttr->IEsLen);
 	}
@@ -1978,7 +1978,7 @@ static s32 Handle_Connect(tstrWILC_WFIDrv *drvHandler, tstrHostIFconnectAttr *ps
 
 			if (pstrHostIFconnectAttr->pu8IEs != NULL) {
 				strConnectInfo.ReqIEsLen = pstrHostIFconnectAttr->IEsLen;
-				strConnectInfo.pu8ReqIEs = (u8 *)WILC_MALLOC(pstrHostIFconnectAttr->IEsLen);
+				strConnectInfo.pu8ReqIEs = WILC_MALLOC(pstrHostIFconnectAttr->IEsLen);
 				memcpy(strConnectInfo.pu8ReqIEs,
 					    pstrHostIFconnectAttr->pu8IEs,
 					    pstrHostIFconnectAttr->IEsLen);
@@ -2136,7 +2136,7 @@ static s32 Handle_ConnectTimeout(tstrWILC_WFIDrv *drvHandler)
 
 		if (pstrWFIDrv->strWILC_UsrConnReq.pu8ConnReqIEs != NULL) {
 			strConnectInfo.ReqIEsLen = pstrWFIDrv->strWILC_UsrConnReq.ConnReqIEsLen;
-			strConnectInfo.pu8ReqIEs = (u8 *)WILC_MALLOC(pstrWFIDrv->strWILC_UsrConnReq.ConnReqIEsLen);
+			strConnectInfo.pu8ReqIEs = WILC_MALLOC(pstrWFIDrv->strWILC_UsrConnReq.ConnReqIEsLen);
 			memcpy(strConnectInfo.pu8ReqIEs,
 				    pstrWFIDrv->strWILC_UsrConnReq.pu8ConnReqIEs,
 				    pstrWFIDrv->strWILC_UsrConnReq.ConnReqIEsLen);
@@ -2426,7 +2426,7 @@ static s32 Handle_RcvdGnrlAsyncInfo(tstrWILC_WFIDrv *drvHandler, tstrRcvdGnrlAsy
 								strConnectInfo.u16RespIEsLen = pstrConnectRespInfo->u16RespIEsLen;
 
 
-								strConnectInfo.pu8RespIEs = (u8 *)WILC_MALLOC(pstrConnectRespInfo->u16RespIEsLen);
+								strConnectInfo.pu8RespIEs = WILC_MALLOC(pstrConnectRespInfo->u16RespIEsLen);
 								memcpy(strConnectInfo.pu8RespIEs, pstrConnectRespInfo->pu8RespIEs,
 									    pstrConnectRespInfo->u16RespIEsLen);
 							}
@@ -2470,7 +2470,7 @@ static s32 Handle_RcvdGnrlAsyncInfo(tstrWILC_WFIDrv *drvHandler, tstrRcvdGnrlAsy
 
 			if (pstrWFIDrv->strWILC_UsrConnReq.pu8ConnReqIEs != NULL) {
 				strConnectInfo.ReqIEsLen = pstrWFIDrv->strWILC_UsrConnReq.ConnReqIEsLen;
-				strConnectInfo.pu8ReqIEs = (u8 *)WILC_MALLOC(pstrWFIDrv->strWILC_UsrConnReq.ConnReqIEsLen);
+				strConnectInfo.pu8ReqIEs = WILC_MALLOC(pstrWFIDrv->strWILC_UsrConnReq.ConnReqIEsLen);
 				memcpy(strConnectInfo.pu8ReqIEs,
 					    pstrWFIDrv->strWILC_UsrConnReq.pu8ConnReqIEs,
 					    pstrWFIDrv->strWILC_UsrConnReq.ConnReqIEsLen);
@@ -2705,7 +2705,7 @@ static int Handle_Key(tstrWILC_WFIDrv *drvHandler, tstrHostIFkeyAttr *pstrHostIF
 			strWIDList[2].s32ValueSize = sizeof(char);
 
 
-			pu8keybuf = (u8 *)WILC_MALLOC(pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwepAttr.u8WepKeylen);
+			pu8keybuf = WILC_MALLOC(pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwepAttr.u8WepKeylen);
 
 
 			if (pu8keybuf == NULL) {
@@ -2734,7 +2734,7 @@ static int Handle_Key(tstrWILC_WFIDrv *drvHandler, tstrHostIFkeyAttr *pstrHostIF
 
 		if (pstrHostIFkeyAttr->u8KeyAction & ADDKEY) {
 			PRINT_D(HOSTINF_DBG, "Handling WEP key\n");
-			pu8keybuf = (u8 *)WILC_MALLOC(pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwepAttr.u8WepKeylen + 2);
+			pu8keybuf = WILC_MALLOC(pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwepAttr.u8WepKeylen + 2);
 			if (pu8keybuf == NULL) {
 				PRINT_ER("No buffer to send Key\n");
 				return -1;
@@ -2782,7 +2782,7 @@ static int Handle_Key(tstrWILC_WFIDrv *drvHandler, tstrHostIFkeyAttr *pstrHostIF
 	case WPARxGtk:
 			#ifdef WILC_AP_EXTERNAL_MLME
 		if (pstrHostIFkeyAttr->u8KeyAction & ADDKEY_AP)	{
-			pu8keybuf = (u8 *)WILC_MALLOC(RX_MIC_KEY_MSG_LEN);
+			pu8keybuf = WILC_MALLOC(RX_MIC_KEY_MSG_LEN);
 			if (pu8keybuf == NULL) {
 				PRINT_ER("No buffer to send RxGTK Key\n");
 				ret = -1;
@@ -2833,7 +2833,7 @@ static int Handle_Key(tstrWILC_WFIDrv *drvHandler, tstrHostIFkeyAttr *pstrHostIF
 		if (pstrHostIFkeyAttr->u8KeyAction & ADDKEY) {
 			PRINT_D(HOSTINF_DBG, "Handling group key(Rx) function\n");
 
-			pu8keybuf = (u8 *)WILC_MALLOC(RX_MIC_KEY_MSG_LEN);
+			pu8keybuf = WILC_MALLOC(RX_MIC_KEY_MSG_LEN);
 			if (pu8keybuf == NULL) {
 				PRINT_ER("No buffer to send RxGTK Key\n");
 				ret = -1;
@@ -2887,7 +2887,7 @@ _WPARxGtk_end_case_:
 		if (pstrHostIFkeyAttr->u8KeyAction & ADDKEY_AP)	{
 
 
-			pu8keybuf = (u8 *)WILC_MALLOC(PTK_KEY_MSG_LEN + 1);
+			pu8keybuf = WILC_MALLOC(PTK_KEY_MSG_LEN + 1);
 
 
 
@@ -2934,7 +2934,7 @@ _WPARxGtk_end_case_:
 		if (pstrHostIFkeyAttr->u8KeyAction & ADDKEY) {
 
 
-			pu8keybuf = (u8 *)WILC_MALLOC(PTK_KEY_MSG_LEN);
+			pu8keybuf = WILC_MALLOC(PTK_KEY_MSG_LEN);
 
 
 
@@ -2984,7 +2984,7 @@ _WPAPtk_end_case_:
 
 		PRINT_D(HOSTINF_DBG, "Handling PMKSA key\n");
 
-		pu8keybuf = (u8 *)WILC_MALLOC((pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFpmkidAttr.numpmkid * PMKSA_KEY_LEN) + 1);
+		pu8keybuf = WILC_MALLOC((pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFpmkidAttr.numpmkid * PMKSA_KEY_LEN) + 1);
 		if (pu8keybuf == NULL) {
 			PRINT_ER("No buffer to send PMKSA Key\n");
 			return -1;
@@ -3373,7 +3373,7 @@ static s32 Handle_Get_InActiveTime(tstrWILC_WFIDrv *drvHandler, tstrHostIfStaIna
 	strWID.u16WIDid = (u16)WID_SET_STA_MAC_INACTIVE_TIME;
 	strWID.enuWIDtype = WID_STR;
 	strWID.s32ValueSize = ETH_ALEN;
-	strWID.ps8WidVal = (u8 *)WILC_MALLOC(strWID.s32ValueSize);
+	strWID.ps8WidVal = WILC_MALLOC(strWID.s32ValueSize);
 
 
 	stamac = strWID.ps8WidVal;
@@ -3833,7 +3833,7 @@ static int Handle_RemainOnChan(tstrWILC_WFIDrv *drvHandler, tstrHostIfRemainOnCh
 	strWID.u16WIDid	= (u16)WID_REMAIN_ON_CHAN;
 	strWID.enuWIDtype	= WID_STR;
 	strWID.s32ValueSize = 2;
-	strWID.ps8WidVal = (s8 *)WILC_MALLOC(strWID.s32ValueSize);
+	strWID.ps8WidVal = WILC_MALLOC(strWID.s32ValueSize);
 
 	if (strWID.ps8WidVal == NULL)
 		WILC_ERRORREPORT(s32Error, WILC_NO_MEM);
@@ -4126,7 +4126,7 @@ static s32 Handle_AddBASession(tstrWILC_WFIDrv *drvHandler, tstrHostIfBASessionI
 
 	strWID.u16WIDid = (u16)WID_11E_P_ACTION_REQ;
 	strWID.enuWIDtype = WID_STR;
-	strWID.ps8WidVal = (u8 *)WILC_MALLOC(BLOCK_ACK_REQ_SIZE);
+	strWID.ps8WidVal = WILC_MALLOC(BLOCK_ACK_REQ_SIZE);
 	strWID.s32ValueSize = BLOCK_ACK_REQ_SIZE;
 	ptr = strWID.ps8WidVal;
 	/* *ptr++ = 0x14; */
@@ -4211,7 +4211,7 @@ static s32 Handle_DelBASession(tstrWILC_WFIDrv *drvHandler, tstrHostIfBASessionI
 
 	strWID.u16WIDid = (u16)WID_11E_P_ACTION_REQ;
 	strWID.enuWIDtype = WID_STR;
-	strWID.ps8WidVal = (u8 *)WILC_MALLOC(BLOCK_ACK_REQ_SIZE);
+	strWID.ps8WidVal = WILC_MALLOC(BLOCK_ACK_REQ_SIZE);
 	strWID.s32ValueSize = BLOCK_ACK_REQ_SIZE;
 	ptr = strWID.ps8WidVal;
 	/* *ptr++ = 0x14; */
@@ -4281,7 +4281,7 @@ static s32 Handle_DelAllRxBASessions(tstrWILC_WFIDrv *drvHandler, tstrHostIfBASe
 
 	strWID.u16WIDid = (u16)WID_DEL_ALL_RX_BA;
 	strWID.enuWIDtype = WID_STR;
-	strWID.ps8WidVal = (u8 *)WILC_MALLOC(BLOCK_ACK_REQ_SIZE);
+	strWID.ps8WidVal = WILC_MALLOC(BLOCK_ACK_REQ_SIZE);
 	strWID.s32ValueSize = BLOCK_ACK_REQ_SIZE;
 	ptr = strWID.ps8WidVal;
 	*ptr++ = 0x14;
@@ -4740,7 +4740,7 @@ s32 host_int_add_wep_key_bss_sta(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8WepKey,
 
 
 	strHostIFmsg.uniHostIFmsgBody.strHostIFkeyAttr.
-	uniHostIFkeyAttr.strHostIFwepAttr.pu8WepKey = (u8 *)WILC_MALLOC(u8WepKeylen);
+	uniHostIFkeyAttr.strHostIFwepAttr.pu8WepKey = WILC_MALLOC(u8WepKeylen);
 
 	memcpy(strHostIFmsg.uniHostIFmsgBody.strHostIFkeyAttr.uniHostIFkeyAttr.strHostIFwepAttr.pu8WepKey,
 		    pu8WepKey, u8WepKeylen);
@@ -4809,7 +4809,7 @@ s32 host_int_add_wep_key_bss_ap(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8WepKey, u
 
 
 	strHostIFmsg.uniHostIFmsgBody.strHostIFkeyAttr.
-	uniHostIFkeyAttr.strHostIFwepAttr.pu8WepKey = (u8 *)WILC_MALLOC((u8WepKeylen));
+	uniHostIFkeyAttr.strHostIFwepAttr.pu8WepKey = WILC_MALLOC((u8WepKeylen));
 
 
 	memcpy(strHostIFmsg.uniHostIFmsgBody.strHostIFkeyAttr.uniHostIFkeyAttr.strHostIFwepAttr.pu8WepKey,
@@ -4892,7 +4892,7 @@ s32 host_int_add_ptk(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8Ptk, u8 u8PtkKeylen,
 
 
 	strHostIFmsg.uniHostIFmsgBody.strHostIFkeyAttr.
-	uniHostIFkeyAttr.strHostIFwpaAttr.pu8key = (u8 *)WILC_MALLOC(u8PtkKeylen);
+	uniHostIFkeyAttr.strHostIFwpaAttr.pu8key = WILC_MALLOC(u8PtkKeylen);
 
 
 	memcpy(strHostIFmsg.uniHostIFmsgBody.strHostIFkeyAttr.uniHostIFkeyAttr.strHostIFwpaAttr.pu8key,
@@ -4978,7 +4978,7 @@ s32 host_int_add_rx_gtk(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8RxGtk, u8 u8GtkKe
 		u8KeyLen += TX_MIC_KEY_LEN;
 	if (KeyRSC != NULL) {
 		strHostIFmsg.uniHostIFmsgBody.strHostIFkeyAttr.
-		uniHostIFkeyAttr.strHostIFwpaAttr.pu8seq = (u8 *)WILC_MALLOC(u32KeyRSClen);
+		uniHostIFkeyAttr.strHostIFwpaAttr.pu8seq = WILC_MALLOC(u32KeyRSClen);
 
 		memcpy(strHostIFmsg.uniHostIFmsgBody.strHostIFkeyAttr.uniHostIFkeyAttr.strHostIFwpaAttr.pu8seq,
 			    KeyRSC, u32KeyRSClen);
@@ -5000,7 +5000,7 @@ s32 host_int_add_rx_gtk(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8RxGtk, u8 u8GtkKe
 
 
 	strHostIFmsg.uniHostIFmsgBody.strHostIFkeyAttr.
-	uniHostIFkeyAttr.strHostIFwpaAttr.pu8key = (u8 *)WILC_MALLOC(u8KeyLen);
+	uniHostIFkeyAttr.strHostIFwpaAttr.pu8key = WILC_MALLOC(u8KeyLen);
 
 	memcpy(strHostIFmsg.uniHostIFmsgBody.strHostIFkeyAttr.uniHostIFkeyAttr.strHostIFwpaAttr.pu8key,
 		    pu8RxGtk, u8GtkKeylen);
@@ -5455,14 +5455,14 @@ s32 host_int_set_join_req(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8bssid,
 	strHostIFmsg.drvHandler = hWFIDrv;
 
 	if (pu8bssid != NULL) {
-		strHostIFmsg.uniHostIFmsgBody.strHostIFconnectAttr.pu8bssid = (u8 *)WILC_MALLOC(6); /* will be deallocated by the receiving thread */
+		strHostIFmsg.uniHostIFmsgBody.strHostIFconnectAttr.pu8bssid = WILC_MALLOC(6); /* will be deallocated by the receiving thread */
 		memcpy(strHostIFmsg.uniHostIFmsgBody.strHostIFconnectAttr.pu8bssid,
 			    pu8bssid, 6);
 	}
 
 	if (pu8ssid != NULL) {
 		strHostIFmsg.uniHostIFmsgBody.strHostIFconnectAttr.ssidLen = ssidLen;
-		strHostIFmsg.uniHostIFmsgBody.strHostIFconnectAttr.pu8ssid = (u8 *)WILC_MALLOC(ssidLen); /* will be deallocated by the receiving thread */
+		strHostIFmsg.uniHostIFmsgBody.strHostIFconnectAttr.pu8ssid = WILC_MALLOC(ssidLen); /* will be deallocated by the receiving thread */
 		memcpy(strHostIFmsg.uniHostIFmsgBody.strHostIFconnectAttr.pu8ssid,
 
 			    pu8ssid, ssidLen);
@@ -5470,7 +5470,7 @@ s32 host_int_set_join_req(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8bssid,
 
 	if (pu8IEs != NULL) {
 		strHostIFmsg.uniHostIFmsgBody.strHostIFconnectAttr.IEsLen = IEsLen;
-		strHostIFmsg.uniHostIFmsgBody.strHostIFconnectAttr.pu8IEs = (u8 *)WILC_MALLOC(IEsLen); /* will be deallocated by the receiving thread */
+		strHostIFmsg.uniHostIFmsgBody.strHostIFconnectAttr.pu8IEs = WILC_MALLOC(IEsLen); /* will be deallocated by the receiving thread */
 		memcpy(strHostIFmsg.uniHostIFmsgBody.strHostIFconnectAttr.pu8IEs,
 			    pu8IEs, IEsLen);
 	}
@@ -6202,12 +6202,12 @@ s32 host_int_scan(tstrWILC_WFIDrv *hWFIDrv, u8 u8ScanSource,
 	strHostIFmsg.uniHostIFmsgBody.strHostIFscanAttr.pvUserArg = pvUserArg;
 
 	strHostIFmsg.uniHostIFmsgBody.strHostIFscanAttr.u8ChnlListLen = u8ChnlListLen;
-	strHostIFmsg.uniHostIFmsgBody.strHostIFscanAttr.pu8ChnlFreqList = (u8 *)WILC_MALLOC(u8ChnlListLen);        /* will be deallocated by the receiving thread */
+	strHostIFmsg.uniHostIFmsgBody.strHostIFscanAttr.pu8ChnlFreqList = WILC_MALLOC(u8ChnlListLen);        /* will be deallocated by the receiving thread */
 	memcpy(strHostIFmsg.uniHostIFmsgBody.strHostIFscanAttr.pu8ChnlFreqList,
 		    pu8ChnlFreqList, u8ChnlListLen);
 
 	strHostIFmsg.uniHostIFmsgBody.strHostIFscanAttr.IEsLen = IEsLen;
-	strHostIFmsg.uniHostIFmsgBody.strHostIFscanAttr.pu8IEs = (u8 *)WILC_MALLOC(IEsLen);        /* will be deallocated by the receiving thread */
+	strHostIFmsg.uniHostIFmsgBody.strHostIFscanAttr.pu8IEs = WILC_MALLOC(IEsLen);        /* will be deallocated by the receiving thread */
 	memcpy(strHostIFmsg.uniHostIFmsgBody.strHostIFscanAttr.pu8IEs,
 		    pu8IEs, IEsLen);
 
@@ -6484,7 +6484,7 @@ s32 host_int_init(tstrWILC_WFIDrv **phWFIDrv)
 
 
 	/*Allocate host interface private structure*/
-	pstrWFIDrv  = (tstrWILC_WFIDrv *)WILC_MALLOC(sizeof(tstrWILC_WFIDrv));
+	pstrWFIDrv  = WILC_MALLOC(sizeof(tstrWILC_WFIDrv));
 	if (pstrWFIDrv == NULL) {
 		/* WILC_ERRORREPORT(s32Error,WILC_NO_MEM); */
 		s32Error = WILC_NO_MEM;
@@ -6771,7 +6771,7 @@ void NetworkInfoReceived(u8 *pu8Buffer, u32 u32Length)
 	strHostIFmsg.drvHandler = pstrWFIDrv;
 
 	strHostIFmsg.uniHostIFmsgBody.strRcvdNetworkInfo.u32Length = u32Length;
-	strHostIFmsg.uniHostIFmsgBody.strRcvdNetworkInfo.pu8Buffer = (u8 *)WILC_MALLOC(u32Length); /* will be deallocated by the receiving thread */
+	strHostIFmsg.uniHostIFmsgBody.strRcvdNetworkInfo.pu8Buffer = WILC_MALLOC(u32Length); /* will be deallocated by the receiving thread */
 	memcpy(strHostIFmsg.uniHostIFmsgBody.strRcvdNetworkInfo.pu8Buffer,
 		    pu8Buffer, u32Length);
 
@@ -6834,7 +6834,7 @@ void GnrlAsyncInfoReceived(u8 *pu8Buffer, u32 u32Length)
 
 
 	strHostIFmsg.uniHostIFmsgBody.strRcvdGnrlAsyncInfo.u32Length = u32Length;
-	strHostIFmsg.uniHostIFmsgBody.strRcvdGnrlAsyncInfo.pu8Buffer = (u8 *)WILC_MALLOC(u32Length); /* will be deallocated by the receiving thread */
+	strHostIFmsg.uniHostIFmsgBody.strRcvdGnrlAsyncInfo.pu8Buffer = WILC_MALLOC(u32Length); /* will be deallocated by the receiving thread */
 	memcpy(strHostIFmsg.uniHostIFmsgBody.strRcvdGnrlAsyncInfo.pu8Buffer,
 		    pu8Buffer, u32Length);
 
@@ -7081,7 +7081,7 @@ s32 host_int_add_beacon(tstrWILC_WFIDrv *hWFIDrv, u32 u32Interval,
 	pstrSetBeaconParam->u32Interval = u32Interval;
 	pstrSetBeaconParam->u32DTIMPeriod = u32DTIMPeriod;
 	pstrSetBeaconParam->u32HeadLen = u32HeadLen;
-	pstrSetBeaconParam->pu8Head = (u8 *)WILC_MALLOC(u32HeadLen);
+	pstrSetBeaconParam->pu8Head = WILC_MALLOC(u32HeadLen);
 	if (pstrSetBeaconParam->pu8Head == NULL)
 		WILC_ERRORREPORT(s32Error, WILC_NO_MEM);
 	memcpy(pstrSetBeaconParam->pu8Head, pu8Head, u32HeadLen);
@@ -7089,7 +7089,7 @@ s32 host_int_add_beacon(tstrWILC_WFIDrv *hWFIDrv, u32 u32Interval,
 
 	/* Bug 4599 : if tail length = 0 skip allocating & copying */
 	if (u32TailLen > 0) {
-		pstrSetBeaconParam->pu8Tail = (u8 *)WILC_MALLOC(u32TailLen);
+		pstrSetBeaconParam->pu8Tail = WILC_MALLOC(u32TailLen);
 		if (pstrSetBeaconParam->pu8Tail == NULL)
 			WILC_ERRORREPORT(s32Error, WILC_NO_MEM);
 		memcpy(pstrSetBeaconParam->pu8Tail, pu8Tail, u32TailLen);
diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 7eacc2f..ed71a9d 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -2465,7 +2465,7 @@ int wilc_netdev_init(void)
 	linux_wlan_init_lock("close_exit_sync", &close_exit_sync, 0);
 
 	/*create the common structure*/
-	g_linux_wlan = (linux_wlan_t *)WILC_MALLOC(sizeof(linux_wlan_t));
+	g_linux_wlan = WILC_MALLOC(sizeof(linux_wlan_t));
 	memset(g_linux_wlan, 0, sizeof(linux_wlan_t));
 
 	/*Reset interrupt count debug*/
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index c2f8d60..14886d2 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -336,7 +336,7 @@ void add_network_to_shadow(tstrNetworkInfo *pstrNetworkInfo, void *pUserVoid, vo
 	if (ap_found != -1)
 		kfree(astrLastScannedNtwrksShadow[ap_index].pu8IEs);
 	astrLastScannedNtwrksShadow[ap_index].pu8IEs =
-		(u8 *)WILC_MALLOC(pstrNetworkInfo->u16IEsLen);        /* will be deallocated by the WILC_WFI_CfgScan() function */
+		WILC_MALLOC(pstrNetworkInfo->u16IEsLen);        /* will be deallocated by the WILC_WFI_CfgScan() function */
 	memcpy(astrLastScannedNtwrksShadow[ap_index].pu8IEs,
 		    pstrNetworkInfo->pu8IEs, pstrNetworkInfo->u16IEsLen);
 
@@ -1190,13 +1190,13 @@ static int WILC_WFI_add_key(struct wiphy *wiphy, struct net_device *netdev, u8 k
 		if (priv->wdev->iftype == NL80211_IFTYPE_AP || priv->wdev->iftype == NL80211_IFTYPE_P2P_GO) {
 
 			if (priv->wilc_gtk[key_index] == NULL) {
-				priv->wilc_gtk[key_index] = (struct wilc_wfi_key *)WILC_MALLOC(sizeof(struct wilc_wfi_key));
+				priv->wilc_gtk[key_index] = WILC_MALLOC(sizeof(struct wilc_wfi_key));
 				priv->wilc_gtk[key_index]->key = NULL;
 				priv->wilc_gtk[key_index]->seq = NULL;
 
 			}
 			if (priv->wilc_ptk[key_index] == NULL) {
-				priv->wilc_ptk[key_index] = (struct wilc_wfi_key *)WILC_MALLOC(sizeof(struct wilc_wfi_key));
+				priv->wilc_ptk[key_index] = WILC_MALLOC(sizeof(struct wilc_wfi_key));
 				priv->wilc_ptk[key_index]->key = NULL;
 				priv->wilc_ptk[key_index]->seq = NULL;
 			}
@@ -1221,7 +1221,7 @@ static int WILC_WFI_add_key(struct wiphy *wiphy, struct net_device *netdev, u8 k
 				if (priv->wilc_gtk[key_index]->key)
 					kfree(priv->wilc_gtk[key_index]->key);
 
-				priv->wilc_gtk[key_index]->key = (u8 *)WILC_MALLOC(params->key_len);
+				priv->wilc_gtk[key_index]->key = WILC_MALLOC(params->key_len);
 				memcpy(priv->wilc_gtk[key_index]->key, params->key, params->key_len);
 
 				/* if there has been previous allocation for the same index through its seq, free that memory and allocate again*/
@@ -1229,7 +1229,7 @@ static int WILC_WFI_add_key(struct wiphy *wiphy, struct net_device *netdev, u8 k
 					kfree(priv->wilc_gtk[key_index]->seq);
 
 				if ((params->seq_len) > 0) {
-					priv->wilc_gtk[key_index]->seq = (u8 *)WILC_MALLOC(params->seq_len);
+					priv->wilc_gtk[key_index]->seq = WILC_MALLOC(params->seq_len);
 					memcpy(priv->wilc_gtk[key_index]->seq, params->seq, params->seq_len);
 				}
 
@@ -1267,13 +1267,13 @@ static int WILC_WFI_add_key(struct wiphy *wiphy, struct net_device *netdev, u8 k
 				if (priv->wilc_ptk[key_index]->key)
 					kfree(priv->wilc_ptk[key_index]->key);
 
-				priv->wilc_ptk[key_index]->key = (u8 *)WILC_MALLOC(params->key_len);
+				priv->wilc_ptk[key_index]->key = WILC_MALLOC(params->key_len);
 
 				if (priv->wilc_ptk[key_index]->seq)
 					kfree(priv->wilc_ptk[key_index]->seq);
 
 				if ((params->seq_len) > 0)
-					priv->wilc_ptk[key_index]->seq = (u8 *)WILC_MALLOC(params->seq_len);
+					priv->wilc_ptk[key_index]->seq = WILC_MALLOC(params->seq_len);
 
 				if (INFO) {
 					for (i = 0; i < params->key_len; i++)
@@ -2509,12 +2509,12 @@ int WILC_WFI_mgmt_tx(struct wiphy *wiphy,
 	if (ieee80211_is_mgmt(mgmt->frame_control)) {
 
 		/*mgmt frame allocation*/
-		mgmt_tx = (struct p2p_mgmt_data *)WILC_MALLOC(sizeof(struct p2p_mgmt_data));
+		mgmt_tx = WILC_MALLOC(sizeof(struct p2p_mgmt_data));
 		if (mgmt_tx == NULL) {
 			PRINT_ER("Failed to allocate memory for mgmt_tx structure\n");
 			return WILC_FAIL;
 		}
-		mgmt_tx->buff = (char *)WILC_MALLOC(buf_len);
+		mgmt_tx->buff = WILC_MALLOC(buf_len);
 		if (mgmt_tx->buff == NULL) {
 			PRINT_ER("Failed to allocate memory for mgmt_tx buff\n");
 			return WILC_FAIL;
-- 
1.9.1

