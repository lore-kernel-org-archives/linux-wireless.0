Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:51405 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbbIIHHw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Sep 2015 03:07:52 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 1/4] staging: wilc1000: remove kmalloc wrapper
Date: Wed, 9 Sep 2015 16:08:10 +0900
Message-ID: <1441782493-11338-1-git-send-email-tony.cho@atmel.com> (sfid-20150909_090756_715955_CF89B84C)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Glen Lee <glen.lee@atmel.com>

Call kmalloc directly. No need to wrap kmalloc.
Only one function, wilc_mq_send which use WILC_MALLOC, can be running in
interrupt context or process context. In this case, We call in_interrupt to
decide the flag, GFP_ATOMIC or GFP_KERNEL, for kmalloc properly. Additionally,
there is one kmalloc which flag is always GFP_ATOMIC. This also changed
together.
Others are not holding a spin lock or in interrupt context. So use GFP_KERNEL
flag for kmalloc.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c         | 110 +++++++++++-----------
 drivers/staging/wilc1000/linux_wlan.c             |   2 +-
 drivers/staging/wilc1000/wilc_msgqueue.c          |  10 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c |  38 ++++----
 4 files changed, 83 insertions(+), 77 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 8033205..59a1a9d 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -841,7 +841,7 @@ s32 Handle_get_IPAddress(tstrWILC_WFIDrv *drvHandler, u8 *pu8IPAddr, u8 idx)
 	/*prepare configuration packet*/
 	strWID.u16WIDid = (u16)WID_IP_ADDRESS;
 	strWID.enuWIDtype = WID_STR;
-	strWID.ps8WidVal = WILC_MALLOC(IP_ALEN);
+	strWID.ps8WidVal = kmalloc(IP_ALEN, GFP_KERNEL);
 	strWID.s32ValueSize = IP_ALEN;
 
 	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, true,
@@ -891,7 +891,7 @@ static s32 Handle_SetMacAddress(tstrWILC_WFIDrv *drvHandler, tstrHostIfSetMacAdd
 	s32 s32Error = WILC_SUCCESS;
 	tstrWID	strWID;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
-	u8 *mac_buf = WILC_MALLOC(ETH_ALEN);
+	u8 *mac_buf = kmalloc(ETH_ALEN, GFP_KERNEL);
 
 	if (mac_buf == NULL) {
 		PRINT_ER("No buffer to send mac address\n");
@@ -1339,7 +1339,7 @@ static s32 Handle_Scan(tstrWILC_WFIDrv *drvHandler, tstrHostIFscanAttr *pstrHost
 
 	for (i = 0; i < pstrHostIFscanAttr->strHiddenNetwork.u8ssidnum; i++)
 		valuesize += ((pstrHostIFscanAttr->strHiddenNetwork.pstrHiddenNetworkInfo[i].u8ssidlen) + 1);
-	pu8HdnNtwrksWidVal = WILC_MALLOC(valuesize + 1);
+	pu8HdnNtwrksWidVal = kmalloc(valuesize + 1, GFP_KERNEL);
 	strWIDList[u32WidsCount].ps8WidVal = pu8HdnNtwrksWidVal;
 	if (strWIDList[u32WidsCount].ps8WidVal != NULL) {
 		pu8Buffer = strWIDList[u32WidsCount].ps8WidVal;
@@ -1616,13 +1616,13 @@ static s32 Handle_Connect(tstrWILC_WFIDrv *drvHandler, tstrHostIFconnectAttr *ps
 		PRINT_INFO(HOSTINF_DBG, "Saving connection parameters in global structure\n");
 
 		if (pstrHostIFconnectAttr->pu8bssid != NULL) {
-			pstrWFIDrv->strWILC_UsrConnReq.pu8bssid = WILC_MALLOC(6);
+			pstrWFIDrv->strWILC_UsrConnReq.pu8bssid = kmalloc(6, GFP_KERNEL);
 			memcpy(pstrWFIDrv->strWILC_UsrConnReq.pu8bssid, pstrHostIFconnectAttr->pu8bssid, 6);
 		}
 
 		pstrWFIDrv->strWILC_UsrConnReq.ssidLen = pstrHostIFconnectAttr->ssidLen;
 		if (pstrHostIFconnectAttr->pu8ssid != NULL) {
-			pstrWFIDrv->strWILC_UsrConnReq.pu8ssid = WILC_MALLOC(pstrHostIFconnectAttr->ssidLen + 1);
+			pstrWFIDrv->strWILC_UsrConnReq.pu8ssid = kmalloc(pstrHostIFconnectAttr->ssidLen + 1, GFP_KERNEL);
 			memcpy(pstrWFIDrv->strWILC_UsrConnReq.pu8ssid, pstrHostIFconnectAttr->pu8ssid,
 				    pstrHostIFconnectAttr->ssidLen);
 			pstrWFIDrv->strWILC_UsrConnReq.pu8ssid[pstrHostIFconnectAttr->ssidLen] = '\0';
@@ -1630,7 +1630,7 @@ static s32 Handle_Connect(tstrWILC_WFIDrv *drvHandler, tstrHostIFconnectAttr *ps
 
 		pstrWFIDrv->strWILC_UsrConnReq.ConnReqIEsLen = pstrHostIFconnectAttr->IEsLen;
 		if (pstrHostIFconnectAttr->pu8IEs != NULL) {
-			pstrWFIDrv->strWILC_UsrConnReq.pu8ConnReqIEs = WILC_MALLOC(pstrHostIFconnectAttr->IEsLen);
+			pstrWFIDrv->strWILC_UsrConnReq.pu8ConnReqIEs = kmalloc(pstrHostIFconnectAttr->IEsLen, GFP_KERNEL);
 			memcpy(pstrWFIDrv->strWILC_UsrConnReq.pu8ConnReqIEs, pstrHostIFconnectAttr->pu8IEs,
 				    pstrHostIFconnectAttr->IEsLen);
 		}
@@ -1724,13 +1724,13 @@ static s32 Handle_Connect(tstrWILC_WFIDrv *drvHandler, tstrHostIFconnectAttr *ps
 	#endif /*WILC_PARSE_SCAN_IN_HOST*/
 
 	if (pstrHostIFconnectAttr->pu8bssid != NULL) {
-		pstrWFIDrv->strWILC_UsrConnReq.pu8bssid = WILC_MALLOC(6);
+		pstrWFIDrv->strWILC_UsrConnReq.pu8bssid = kmalloc(6, GFP_KERNEL);
 		memcpy(pstrWFIDrv->strWILC_UsrConnReq.pu8bssid, pstrHostIFconnectAttr->pu8bssid, 6);
 	}
 
 	pstrWFIDrv->strWILC_UsrConnReq.ssidLen = pstrHostIFconnectAttr->ssidLen;
 	if (pstrHostIFconnectAttr->pu8ssid != NULL) {
-		pstrWFIDrv->strWILC_UsrConnReq.pu8ssid = WILC_MALLOC(pstrHostIFconnectAttr->ssidLen + 1);
+		pstrWFIDrv->strWILC_UsrConnReq.pu8ssid = kmalloc(pstrHostIFconnectAttr->ssidLen + 1, GFP_KERNEL);
 		memcpy(pstrWFIDrv->strWILC_UsrConnReq.pu8ssid, pstrHostIFconnectAttr->pu8ssid,
 			    pstrHostIFconnectAttr->ssidLen);
 		pstrWFIDrv->strWILC_UsrConnReq.pu8ssid[pstrHostIFconnectAttr->ssidLen] = '\0';
@@ -1738,7 +1738,7 @@ static s32 Handle_Connect(tstrWILC_WFIDrv *drvHandler, tstrHostIFconnectAttr *ps
 
 	pstrWFIDrv->strWILC_UsrConnReq.ConnReqIEsLen = pstrHostIFconnectAttr->IEsLen;
 	if (pstrHostIFconnectAttr->pu8IEs != NULL) {
-		pstrWFIDrv->strWILC_UsrConnReq.pu8ConnReqIEs = WILC_MALLOC(pstrHostIFconnectAttr->IEsLen);
+		pstrWFIDrv->strWILC_UsrConnReq.pu8ConnReqIEs = kmalloc(pstrHostIFconnectAttr->IEsLen, GFP_KERNEL);
 		memcpy(pstrWFIDrv->strWILC_UsrConnReq.pu8ConnReqIEs, pstrHostIFconnectAttr->pu8IEs,
 			    pstrHostIFconnectAttr->IEsLen);
 	}
@@ -1780,7 +1780,7 @@ static s32 Handle_Connect(tstrWILC_WFIDrv *drvHandler, tstrHostIFconnectAttr *ps
 		if (memcmp("DIRECT-", pstrHostIFconnectAttr->pu8ssid, 7)) {
 
 			gu32FlushedInfoElemAsocSize = pstrWFIDrv->strWILC_UsrConnReq.ConnReqIEsLen;
-			gu8FlushedInfoElemAsoc =  WILC_MALLOC(gu32FlushedInfoElemAsocSize);
+			gu8FlushedInfoElemAsoc =  kmalloc(gu32FlushedInfoElemAsocSize, GFP_KERNEL);
 			memcpy(gu8FlushedInfoElemAsoc, pstrWFIDrv->strWILC_UsrConnReq.pu8ConnReqIEs,
 			       gu32FlushedInfoElemAsocSize);
 		}
@@ -1825,7 +1825,7 @@ static s32 Handle_Connect(tstrWILC_WFIDrv *drvHandler, tstrHostIFconnectAttr *ps
 	strWIDList[u32WidsCount].u16WIDid = (u16)WID_JOIN_REQ_EXTENDED;
 	strWIDList[u32WidsCount].enuWIDtype = WID_STR;
 	strWIDList[u32WidsCount].s32ValueSize = MAX_SSID_LEN + 7;
-	strWIDList[u32WidsCount].ps8WidVal = WILC_MALLOC(strWIDList[u32WidsCount].s32ValueSize);
+	strWIDList[u32WidsCount].ps8WidVal = kmalloc(strWIDList[u32WidsCount].s32ValueSize, GFP_KERNEL);
 
 	if (strWIDList[u32WidsCount].ps8WidVal == NULL)
 		WILC_ERRORREPORT(s32Error, WILC_NO_MEM);
@@ -1857,12 +1857,12 @@ static s32 Handle_Connect(tstrWILC_WFIDrv *drvHandler, tstrHostIFconnectAttr *ps
 
 	/*Sending NoA attributes during connection*/
 	strWIDList[u32WidsCount].s32ValueSize = 112; /* 79; */
-	strWIDList[u32WidsCount].ps8WidVal = WILC_MALLOC(strWIDList[u32WidsCount].s32ValueSize);
+	strWIDList[u32WidsCount].ps8WidVal = kmalloc(strWIDList[u32WidsCount].s32ValueSize, GFP_KERNEL);
 
 	/*BugID_5137*/
 	if (memcmp("DIRECT-", pstrHostIFconnectAttr->pu8ssid, 7)) {
 		gu32FlushedJoinReqSize = strWIDList[u32WidsCount].s32ValueSize;
-		gu8FlushedJoinReq = WILC_MALLOC(gu32FlushedJoinReqSize);
+		gu8FlushedJoinReq = kmalloc(gu32FlushedJoinReqSize, GFP_KERNEL);
 	}
 	if (strWIDList[u32WidsCount].ps8WidVal == NULL)
 		WILC_ERRORREPORT(s32Error, WILC_NO_MEM);
@@ -2038,7 +2038,7 @@ static s32 Handle_Connect(tstrWILC_WFIDrv *drvHandler, tstrHostIFconnectAttr *ps
 
 			if (pstrHostIFconnectAttr->pu8IEs != NULL) {
 				strConnectInfo.ReqIEsLen = pstrHostIFconnectAttr->IEsLen;
-				strConnectInfo.pu8ReqIEs = WILC_MALLOC(pstrHostIFconnectAttr->IEsLen);
+				strConnectInfo.pu8ReqIEs = kmalloc(pstrHostIFconnectAttr->IEsLen, GFP_KERNEL);
 				memcpy(strConnectInfo.pu8ReqIEs,
 					    pstrHostIFconnectAttr->pu8IEs,
 					    pstrHostIFconnectAttr->IEsLen);
@@ -2197,7 +2197,7 @@ static s32 Handle_ConnectTimeout(tstrWILC_WFIDrv *drvHandler)
 
 		if (pstrWFIDrv->strWILC_UsrConnReq.pu8ConnReqIEs != NULL) {
 			strConnectInfo.ReqIEsLen = pstrWFIDrv->strWILC_UsrConnReq.ConnReqIEsLen;
-			strConnectInfo.pu8ReqIEs = WILC_MALLOC(pstrWFIDrv->strWILC_UsrConnReq.ConnReqIEsLen);
+			strConnectInfo.pu8ReqIEs = kmalloc(pstrWFIDrv->strWILC_UsrConnReq.ConnReqIEsLen, GFP_KERNEL);
 			memcpy(strConnectInfo.pu8ReqIEs,
 				    pstrWFIDrv->strWILC_UsrConnReq.pu8ConnReqIEs,
 				    pstrWFIDrv->strWILC_UsrConnReq.ConnReqIEsLen);
@@ -2488,7 +2488,7 @@ static s32 Handle_RcvdGnrlAsyncInfo(tstrWILC_WFIDrv *drvHandler, tstrRcvdGnrlAsy
 								strConnectInfo.u16RespIEsLen = pstrConnectRespInfo->u16RespIEsLen;
 
 
-								strConnectInfo.pu8RespIEs = WILC_MALLOC(pstrConnectRespInfo->u16RespIEsLen);
+								strConnectInfo.pu8RespIEs = kmalloc(pstrConnectRespInfo->u16RespIEsLen, GFP_KERNEL);
 								memcpy(strConnectInfo.pu8RespIEs, pstrConnectRespInfo->pu8RespIEs,
 									    pstrConnectRespInfo->u16RespIEsLen);
 							}
@@ -2532,7 +2532,7 @@ static s32 Handle_RcvdGnrlAsyncInfo(tstrWILC_WFIDrv *drvHandler, tstrRcvdGnrlAsy
 
 			if (pstrWFIDrv->strWILC_UsrConnReq.pu8ConnReqIEs != NULL) {
 				strConnectInfo.ReqIEsLen = pstrWFIDrv->strWILC_UsrConnReq.ConnReqIEsLen;
-				strConnectInfo.pu8ReqIEs = WILC_MALLOC(pstrWFIDrv->strWILC_UsrConnReq.ConnReqIEsLen);
+				strConnectInfo.pu8ReqIEs = kmalloc(pstrWFIDrv->strWILC_UsrConnReq.ConnReqIEsLen, GFP_KERNEL);
 				memcpy(strConnectInfo.pu8ReqIEs,
 					    pstrWFIDrv->strWILC_UsrConnReq.pu8ConnReqIEs,
 					    pstrWFIDrv->strWILC_UsrConnReq.ConnReqIEsLen);
@@ -2768,7 +2768,7 @@ static int Handle_Key(tstrWILC_WFIDrv *drvHandler, tstrHostIFkeyAttr *pstrHostIF
 			strWIDList[2].s32ValueSize = sizeof(char);
 
 
-			pu8keybuf = WILC_MALLOC(pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwepAttr.u8WepKeylen);
+			pu8keybuf = kmalloc(pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwepAttr.u8WepKeylen, GFP_KERNEL);
 
 
 			if (pu8keybuf == NULL) {
@@ -2798,7 +2798,7 @@ static int Handle_Key(tstrWILC_WFIDrv *drvHandler, tstrHostIFkeyAttr *pstrHostIF
 
 		if (pstrHostIFkeyAttr->u8KeyAction & ADDKEY) {
 			PRINT_D(HOSTINF_DBG, "Handling WEP key\n");
-			pu8keybuf = WILC_MALLOC(pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwepAttr.u8WepKeylen + 2);
+			pu8keybuf = kmalloc(pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwepAttr.u8WepKeylen + 2, GFP_KERNEL);
 			if (pu8keybuf == NULL) {
 				PRINT_ER("No buffer to send Key\n");
 				return -1;
@@ -2849,7 +2849,7 @@ static int Handle_Key(tstrWILC_WFIDrv *drvHandler, tstrHostIFkeyAttr *pstrHostIF
 	case WPARxGtk:
 			#ifdef WILC_AP_EXTERNAL_MLME
 		if (pstrHostIFkeyAttr->u8KeyAction & ADDKEY_AP)	{
-			pu8keybuf = WILC_MALLOC(RX_MIC_KEY_MSG_LEN);
+			pu8keybuf = kmalloc(RX_MIC_KEY_MSG_LEN, GFP_KERNEL);
 			if (pu8keybuf == NULL) {
 				PRINT_ER("No buffer to send RxGTK Key\n");
 				ret = -1;
@@ -2901,7 +2901,7 @@ static int Handle_Key(tstrWILC_WFIDrv *drvHandler, tstrHostIFkeyAttr *pstrHostIF
 		if (pstrHostIFkeyAttr->u8KeyAction & ADDKEY) {
 			PRINT_D(HOSTINF_DBG, "Handling group key(Rx) function\n");
 
-			pu8keybuf = WILC_MALLOC(RX_MIC_KEY_MSG_LEN);
+			pu8keybuf = kmalloc(RX_MIC_KEY_MSG_LEN, GFP_KERNEL);
 			if (pu8keybuf == NULL) {
 				PRINT_ER("No buffer to send RxGTK Key\n");
 				ret = -1;
@@ -2956,7 +2956,7 @@ _WPARxGtk_end_case_:
 		if (pstrHostIFkeyAttr->u8KeyAction & ADDKEY_AP)	{
 
 
-			pu8keybuf = WILC_MALLOC(PTK_KEY_MSG_LEN + 1);
+			pu8keybuf = kmalloc(PTK_KEY_MSG_LEN + 1, GFP_KERNEL);
 
 
 
@@ -3004,7 +3004,7 @@ _WPARxGtk_end_case_:
 		if (pstrHostIFkeyAttr->u8KeyAction & ADDKEY) {
 
 
-			pu8keybuf = WILC_MALLOC(PTK_KEY_MSG_LEN);
+			pu8keybuf = kmalloc(PTK_KEY_MSG_LEN, GFP_KERNEL);
 
 
 
@@ -3055,7 +3055,7 @@ _WPAPtk_end_case_:
 
 		PRINT_D(HOSTINF_DBG, "Handling PMKSA key\n");
 
-		pu8keybuf = WILC_MALLOC((pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFpmkidAttr.numpmkid * PMKSA_KEY_LEN) + 1);
+		pu8keybuf = kmalloc((pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFpmkidAttr.numpmkid * PMKSA_KEY_LEN) + 1, GFP_KERNEL);
 		if (pu8keybuf == NULL) {
 			PRINT_ER("No buffer to send PMKSA Key\n");
 			return -1;
@@ -3451,7 +3451,7 @@ static s32 Handle_Get_InActiveTime(tstrWILC_WFIDrv *drvHandler, tstrHostIfStaIna
 	strWID.u16WIDid = (u16)WID_SET_STA_MAC_INACTIVE_TIME;
 	strWID.enuWIDtype = WID_STR;
 	strWID.s32ValueSize = ETH_ALEN;
-	strWID.ps8WidVal = WILC_MALLOC(strWID.s32ValueSize);
+	strWID.ps8WidVal = kmalloc(strWID.s32ValueSize, GFP_KERNEL);
 
 
 	stamac = strWID.ps8WidVal;
@@ -3522,7 +3522,7 @@ static void Handle_AddBeacon(tstrWILC_WFIDrv *drvHandler, tstrHostIFSetBeacon *p
 	strWID.u16WIDid = (u16)WID_ADD_BEACON;
 	strWID.enuWIDtype = WID_BIN;
 	strWID.s32ValueSize = pstrSetBeaconParam->u32HeadLen + pstrSetBeaconParam->u32TailLen + 16;
-	strWID.ps8WidVal = WILC_MALLOC(strWID.s32ValueSize);
+	strWID.ps8WidVal = kmalloc(strWID.s32ValueSize, GFP_KERNEL);
 	if (strWID.ps8WidVal == NULL)
 		WILC_ERRORREPORT(s32Error, WILC_NO_MEM);
 
@@ -3693,7 +3693,7 @@ static void Handle_AddStation(tstrWILC_WFIDrv *drvHandler, tstrWILC_AddStaParam
 	strWID.enuWIDtype = WID_BIN;
 	strWID.s32ValueSize = WILC_ADD_STA_LENGTH + pstrStationParam->u8NumRates;
 
-	strWID.ps8WidVal = WILC_MALLOC(strWID.s32ValueSize);
+	strWID.ps8WidVal = kmalloc(strWID.s32ValueSize, GFP_KERNEL);
 	if (strWID.ps8WidVal == NULL)
 		WILC_ERRORREPORT(s32Error, WILC_NO_MEM);
 
@@ -3741,7 +3741,7 @@ static void Handle_DelAllSta(tstrWILC_WFIDrv *drvHandler, tstrHostIFDelAllSta *p
 
 	PRINT_D(HOSTINF_DBG, "Handling delete station\n");
 
-	strWID.ps8WidVal = WILC_MALLOC((pstrDelAllStaParam->u8Num_AssocSta * ETH_ALEN) + 1);
+	strWID.ps8WidVal = kmalloc((pstrDelAllStaParam->u8Num_AssocSta * ETH_ALEN) + 1, GFP_KERNEL);
 	if (strWID.ps8WidVal == NULL)
 		WILC_ERRORREPORT(s32Error, WILC_NO_MEM);
 
@@ -3798,7 +3798,7 @@ static void Handle_DelStation(tstrWILC_WFIDrv *drvHandler, tstrHostIFDelSta *pst
 
 	PRINT_D(HOSTINF_DBG, "Handling delete station\n");
 
-	strWID.ps8WidVal = WILC_MALLOC(strWID.s32ValueSize);
+	strWID.ps8WidVal = kmalloc(strWID.s32ValueSize, GFP_KERNEL);
 	if (strWID.ps8WidVal == NULL)
 		WILC_ERRORREPORT(s32Error, WILC_NO_MEM);
 
@@ -3843,7 +3843,7 @@ static void Handle_EditStation(tstrWILC_WFIDrv *drvHandler, tstrWILC_AddStaParam
 	strWID.s32ValueSize = WILC_ADD_STA_LENGTH + pstrStationParam->u8NumRates;
 
 	PRINT_D(HOSTINF_DBG, "Handling edit station\n");
-	strWID.ps8WidVal = WILC_MALLOC(strWID.s32ValueSize);
+	strWID.ps8WidVal = kmalloc(strWID.s32ValueSize, GFP_KERNEL);
 	if (strWID.ps8WidVal == NULL)
 		WILC_ERRORREPORT(s32Error, WILC_NO_MEM);
 
@@ -3919,7 +3919,7 @@ static int Handle_RemainOnChan(tstrWILC_WFIDrv *drvHandler, tstrHostIfRemainOnCh
 	strWID.u16WIDid	= (u16)WID_REMAIN_ON_CHAN;
 	strWID.enuWIDtype	= WID_STR;
 	strWID.s32ValueSize = 2;
-	strWID.ps8WidVal = WILC_MALLOC(strWID.s32ValueSize);
+	strWID.ps8WidVal = kmalloc(strWID.s32ValueSize, GFP_KERNEL);
 
 	if (strWID.ps8WidVal == NULL)
 		WILC_ERRORREPORT(s32Error, WILC_NO_MEM);
@@ -3972,7 +3972,7 @@ static int Handle_RegisterFrame(tstrWILC_WFIDrv *drvHandler, tstrHostIfRegisterF
 	/*prepare configuration packet*/
 	strWID.u16WIDid = (u16)WID_REGISTER_FRAME;
 	strWID.enuWIDtype = WID_STR;
-	strWID.ps8WidVal = WILC_MALLOC(sizeof(u16) + 2);
+	strWID.ps8WidVal = kmalloc(sizeof(u16) + 2, GFP_KERNEL);
 	if (strWID.ps8WidVal == NULL)
 		WILC_ERRORREPORT(s32Error, WILC_NO_MEM);
 
@@ -4030,7 +4030,7 @@ static u32 Handle_ListenStateExpired(tstrWILC_WFIDrv *drvHandler, tstrHostIfRema
 		strWID.u16WIDid	= (u16)WID_REMAIN_ON_CHAN;
 		strWID.enuWIDtype	= WID_STR;
 		strWID.s32ValueSize = 2;
-		strWID.ps8WidVal = WILC_MALLOC(strWID.s32ValueSize);
+		strWID.ps8WidVal = kmalloc(strWID.s32ValueSize, GFP_KERNEL);
 
 		if (strWID.ps8WidVal == NULL)
 			PRINT_ER("Failed to allocate memory\n");
@@ -4158,7 +4158,7 @@ static void Handle_SetMulticastFilter(tstrWILC_WFIDrv *drvHandler, tstrHostIFSet
 	strWID.u16WIDid = (u16)WID_SETUP_MULTICAST_FILTER;
 	strWID.enuWIDtype = WID_BIN;
 	strWID.s32ValueSize = sizeof(tstrHostIFSetMulti) + ((strHostIfSetMulti->u32count) * ETH_ALEN);
-	strWID.ps8WidVal = WILC_MALLOC(strWID.s32ValueSize);
+	strWID.ps8WidVal = kmalloc(strWID.s32ValueSize, GFP_KERNEL);
 	if (strWID.ps8WidVal == NULL)
 		WILC_ERRORREPORT(s32Error, WILC_NO_MEM);
 
@@ -4220,7 +4220,7 @@ static s32 Handle_AddBASession(tstrWILC_WFIDrv *drvHandler, tstrHostIfBASessionI
 
 	strWID.u16WIDid = (u16)WID_11E_P_ACTION_REQ;
 	strWID.enuWIDtype = WID_STR;
-	strWID.ps8WidVal = WILC_MALLOC(BLOCK_ACK_REQ_SIZE);
+	strWID.ps8WidVal = kmalloc(BLOCK_ACK_REQ_SIZE, GFP_KERNEL);
 	strWID.s32ValueSize = BLOCK_ACK_REQ_SIZE;
 	ptr = strWID.ps8WidVal;
 	/* *ptr++ = 0x14; */
@@ -4307,7 +4307,7 @@ static s32 Handle_DelBASession(tstrWILC_WFIDrv *drvHandler, tstrHostIfBASessionI
 
 	strWID.u16WIDid = (u16)WID_11E_P_ACTION_REQ;
 	strWID.enuWIDtype = WID_STR;
-	strWID.ps8WidVal = WILC_MALLOC(BLOCK_ACK_REQ_SIZE);
+	strWID.ps8WidVal = kmalloc(BLOCK_ACK_REQ_SIZE, GFP_KERNEL);
 	strWID.s32ValueSize = BLOCK_ACK_REQ_SIZE;
 	ptr = strWID.ps8WidVal;
 	/* *ptr++ = 0x14; */
@@ -4379,7 +4379,7 @@ static s32 Handle_DelAllRxBASessions(tstrWILC_WFIDrv *drvHandler, tstrHostIfBASe
 
 	strWID.u16WIDid = (u16)WID_DEL_ALL_RX_BA;
 	strWID.enuWIDtype = WID_STR;
-	strWID.ps8WidVal = WILC_MALLOC(BLOCK_ACK_REQ_SIZE);
+	strWID.ps8WidVal = kmalloc(BLOCK_ACK_REQ_SIZE, GFP_KERNEL);
 	strWID.s32ValueSize = BLOCK_ACK_REQ_SIZE;
 	ptr = strWID.ps8WidVal;
 	*ptr++ = 0x14;
@@ -4840,7 +4840,7 @@ s32 host_int_add_wep_key_bss_sta(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8WepKey,
 
 
 	strHostIFmsg.uniHostIFmsgBody.strHostIFkeyAttr.
-	uniHostIFkeyAttr.strHostIFwepAttr.pu8WepKey = WILC_MALLOC(u8WepKeylen);
+	uniHostIFkeyAttr.strHostIFwepAttr.pu8WepKey = kmalloc(u8WepKeylen, GFP_KERNEL);
 
 	memcpy(strHostIFmsg.uniHostIFmsgBody.strHostIFkeyAttr.uniHostIFkeyAttr.strHostIFwepAttr.pu8WepKey,
 		    pu8WepKey, u8WepKeylen);
@@ -4909,7 +4909,7 @@ s32 host_int_add_wep_key_bss_ap(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8WepKey, u
 
 
 	strHostIFmsg.uniHostIFmsgBody.strHostIFkeyAttr.
-	uniHostIFkeyAttr.strHostIFwepAttr.pu8WepKey = WILC_MALLOC((u8WepKeylen));
+	uniHostIFkeyAttr.strHostIFwepAttr.pu8WepKey = kmalloc(u8WepKeylen, GFP_KERNEL);
 
 
 	memcpy(strHostIFmsg.uniHostIFmsgBody.strHostIFkeyAttr.uniHostIFkeyAttr.strHostIFwepAttr.pu8WepKey,
@@ -4992,7 +4992,7 @@ s32 host_int_add_ptk(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8Ptk, u8 u8PtkKeylen,
 
 
 	strHostIFmsg.uniHostIFmsgBody.strHostIFkeyAttr.
-	uniHostIFkeyAttr.strHostIFwpaAttr.pu8key = WILC_MALLOC(u8PtkKeylen);
+	uniHostIFkeyAttr.strHostIFwpaAttr.pu8key = kmalloc(u8PtkKeylen, GFP_KERNEL);
 
 
 	memcpy(strHostIFmsg.uniHostIFmsgBody.strHostIFkeyAttr.uniHostIFkeyAttr.strHostIFwpaAttr.pu8key,
@@ -5078,7 +5078,7 @@ s32 host_int_add_rx_gtk(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8RxGtk, u8 u8GtkKe
 		u8KeyLen += TX_MIC_KEY_LEN;
 	if (KeyRSC != NULL) {
 		strHostIFmsg.uniHostIFmsgBody.strHostIFkeyAttr.
-		uniHostIFkeyAttr.strHostIFwpaAttr.pu8seq = WILC_MALLOC(u32KeyRSClen);
+		uniHostIFkeyAttr.strHostIFwpaAttr.pu8seq = kmalloc(u32KeyRSClen, GFP_KERNEL);
 
 		memcpy(strHostIFmsg.uniHostIFmsgBody.strHostIFkeyAttr.uniHostIFkeyAttr.strHostIFwpaAttr.pu8seq,
 			    KeyRSC, u32KeyRSClen);
@@ -5100,7 +5100,7 @@ s32 host_int_add_rx_gtk(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8RxGtk, u8 u8GtkKe
 
 
 	strHostIFmsg.uniHostIFmsgBody.strHostIFkeyAttr.
-	uniHostIFkeyAttr.strHostIFwpaAttr.pu8key = WILC_MALLOC(u8KeyLen);
+	uniHostIFkeyAttr.strHostIFwpaAttr.pu8key = kmalloc(u8KeyLen, GFP_KERNEL);
 
 	memcpy(strHostIFmsg.uniHostIFmsgBody.strHostIFkeyAttr.uniHostIFkeyAttr.strHostIFwpaAttr.pu8key,
 		    pu8RxGtk, u8GtkKeylen);
@@ -5556,14 +5556,14 @@ s32 host_int_set_join_req(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8bssid,
 	strHostIFmsg.drvHandler = hWFIDrv;
 
 	if (pu8bssid != NULL) {
-		strHostIFmsg.uniHostIFmsgBody.strHostIFconnectAttr.pu8bssid = WILC_MALLOC(6); /* will be deallocated by the receiving thread */
+		strHostIFmsg.uniHostIFmsgBody.strHostIFconnectAttr.pu8bssid = kmalloc(6, GFP_KERNEL); /* will be deallocated by the receiving thread */
 		memcpy(strHostIFmsg.uniHostIFmsgBody.strHostIFconnectAttr.pu8bssid,
 			    pu8bssid, 6);
 	}
 
 	if (pu8ssid != NULL) {
 		strHostIFmsg.uniHostIFmsgBody.strHostIFconnectAttr.ssidLen = ssidLen;
-		strHostIFmsg.uniHostIFmsgBody.strHostIFconnectAttr.pu8ssid = WILC_MALLOC(ssidLen); /* will be deallocated by the receiving thread */
+		strHostIFmsg.uniHostIFmsgBody.strHostIFconnectAttr.pu8ssid = kmalloc(ssidLen, GFP_KERNEL); /* will be deallocated by the receiving thread */
 		memcpy(strHostIFmsg.uniHostIFmsgBody.strHostIFconnectAttr.pu8ssid,
 
 			    pu8ssid, ssidLen);
@@ -5571,7 +5571,7 @@ s32 host_int_set_join_req(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8bssid,
 
 	if (pu8IEs != NULL) {
 		strHostIFmsg.uniHostIFmsgBody.strHostIFconnectAttr.IEsLen = IEsLen;
-		strHostIFmsg.uniHostIFmsgBody.strHostIFconnectAttr.pu8IEs = WILC_MALLOC(IEsLen); /* will be deallocated by the receiving thread */
+		strHostIFmsg.uniHostIFmsgBody.strHostIFconnectAttr.pu8IEs = kmalloc(IEsLen, GFP_KERNEL); /* will be deallocated by the receiving thread */
 		memcpy(strHostIFmsg.uniHostIFmsgBody.strHostIFconnectAttr.pu8IEs,
 			    pu8IEs, IEsLen);
 	}
@@ -6308,12 +6308,12 @@ s32 host_int_scan(tstrWILC_WFIDrv *hWFIDrv, u8 u8ScanSource,
 	strHostIFmsg.uniHostIFmsgBody.strHostIFscanAttr.pvUserArg = pvUserArg;
 
 	strHostIFmsg.uniHostIFmsgBody.strHostIFscanAttr.u8ChnlListLen = u8ChnlListLen;
-	strHostIFmsg.uniHostIFmsgBody.strHostIFscanAttr.pu8ChnlFreqList = WILC_MALLOC(u8ChnlListLen);        /* will be deallocated by the receiving thread */
+	strHostIFmsg.uniHostIFmsgBody.strHostIFscanAttr.pu8ChnlFreqList = kmalloc(u8ChnlListLen, GFP_KERNEL);        /* will be deallocated by the receiving thread */
 	memcpy(strHostIFmsg.uniHostIFmsgBody.strHostIFscanAttr.pu8ChnlFreqList,
 		    pu8ChnlFreqList, u8ChnlListLen);
 
 	strHostIFmsg.uniHostIFmsgBody.strHostIFscanAttr.IEsLen = IEsLen;
-	strHostIFmsg.uniHostIFmsgBody.strHostIFscanAttr.pu8IEs = WILC_MALLOC(IEsLen);        /* will be deallocated by the receiving thread */
+	strHostIFmsg.uniHostIFmsgBody.strHostIFscanAttr.pu8IEs = kmalloc(IEsLen, GFP_KERNEL);        /* will be deallocated by the receiving thread */
 	memcpy(strHostIFmsg.uniHostIFmsgBody.strHostIFscanAttr.pu8IEs,
 		    pu8IEs, IEsLen);
 
@@ -6593,7 +6593,7 @@ s32 host_int_init(tstrWILC_WFIDrv **phWFIDrv)
 
 
 	/*Allocate host interface private structure*/
-	pstrWFIDrv  = WILC_MALLOC(sizeof(tstrWILC_WFIDrv));
+	pstrWFIDrv  = kmalloc(sizeof(tstrWILC_WFIDrv), GFP_KERNEL);
 	if (pstrWFIDrv == NULL) {
 		/* WILC_ERRORREPORT(s32Error,WILC_NO_MEM); */
 		s32Error = WILC_NO_MEM;
@@ -6885,7 +6885,7 @@ void NetworkInfoReceived(u8 *pu8Buffer, u32 u32Length)
 	strHostIFmsg.drvHandler = pstrWFIDrv;
 
 	strHostIFmsg.uniHostIFmsgBody.strRcvdNetworkInfo.u32Length = u32Length;
-	strHostIFmsg.uniHostIFmsgBody.strRcvdNetworkInfo.pu8Buffer = WILC_MALLOC(u32Length); /* will be deallocated by the receiving thread */
+	strHostIFmsg.uniHostIFmsgBody.strRcvdNetworkInfo.pu8Buffer = kmalloc(u32Length, GFP_KERNEL); /* will be deallocated by the receiving thread */
 	memcpy(strHostIFmsg.uniHostIFmsgBody.strRcvdNetworkInfo.pu8Buffer,
 		    pu8Buffer, u32Length);
 
@@ -6945,7 +6945,7 @@ void GnrlAsyncInfoReceived(u8 *pu8Buffer, u32 u32Length)
 
 
 	strHostIFmsg.uniHostIFmsgBody.strRcvdGnrlAsyncInfo.u32Length = u32Length;
-	strHostIFmsg.uniHostIFmsgBody.strRcvdGnrlAsyncInfo.pu8Buffer = WILC_MALLOC(u32Length); /* will be deallocated by the receiving thread */
+	strHostIFmsg.uniHostIFmsgBody.strRcvdGnrlAsyncInfo.pu8Buffer = kmalloc(u32Length, GFP_KERNEL); /* will be deallocated by the receiving thread */
 	memcpy(strHostIFmsg.uniHostIFmsgBody.strRcvdGnrlAsyncInfo.pu8Buffer,
 		    pu8Buffer, u32Length);
 
@@ -7191,7 +7191,7 @@ s32 host_int_add_beacon(tstrWILC_WFIDrv *hWFIDrv, u32 u32Interval,
 	pstrSetBeaconParam->u32Interval = u32Interval;
 	pstrSetBeaconParam->u32DTIMPeriod = u32DTIMPeriod;
 	pstrSetBeaconParam->u32HeadLen = u32HeadLen;
-	pstrSetBeaconParam->pu8Head = WILC_MALLOC(u32HeadLen);
+	pstrSetBeaconParam->pu8Head = kmalloc(u32HeadLen, GFP_KERNEL);
 	if (pstrSetBeaconParam->pu8Head == NULL)
 		WILC_ERRORREPORT(s32Error, WILC_NO_MEM);
 	memcpy(pstrSetBeaconParam->pu8Head, pu8Head, u32HeadLen);
@@ -7199,7 +7199,7 @@ s32 host_int_add_beacon(tstrWILC_WFIDrv *hWFIDrv, u32 u32Interval,
 
 	/* Bug 4599 : if tail length = 0 skip allocating & copying */
 	if (u32TailLen > 0) {
-		pstrSetBeaconParam->pu8Tail = WILC_MALLOC(u32TailLen);
+		pstrSetBeaconParam->pu8Tail = kmalloc(u32TailLen, GFP_KERNEL);
 		if (pstrSetBeaconParam->pu8Tail == NULL)
 			WILC_ERRORREPORT(s32Error, WILC_NO_MEM);
 		memcpy(pstrSetBeaconParam->pu8Tail, pu8Tail, u32TailLen);
@@ -7289,7 +7289,7 @@ s32 host_int_add_station(tstrWILC_WFIDrv *hWFIDrv, tstrWILC_AddStaParam *pstrSta
 
 	memcpy(pstrAddStationMsg, pstrStaParams, sizeof(tstrWILC_AddStaParam));
 	if (pstrAddStationMsg->u8NumRates > 0) {
-		u8 *rates = WILC_MALLOC(pstrAddStationMsg->u8NumRates);
+		u8 *rates = kmalloc(pstrAddStationMsg->u8NumRates, GFP_KERNEL);
 
 		WILC_NULLCHECK(s32Error, rates);
 
@@ -7444,7 +7444,7 @@ s32 host_int_edit_station(tstrWILC_WFIDrv *hWFIDrv, tstrWILC_AddStaParam *pstrSt
 
 	memcpy(pstrAddStationMsg, pstrStaParams, sizeof(tstrWILC_AddStaParam));
 	if (pstrAddStationMsg->u8NumRates > 0) {
-		u8 *rates = WILC_MALLOC(pstrAddStationMsg->u8NumRates);
+		u8 *rates = kmalloc(pstrAddStationMsg->u8NumRates, GFP_KERNEL);
 
 		WILC_NULLCHECK(s32Error, rates);
 		memcpy(rates, pstrStaParams->pu8Rates, pstrAddStationMsg->u8NumRates);
@@ -7561,7 +7561,7 @@ static void *host_int_ParseJoinBssParam(tstrNetworkInfo *ptstrNetworkInfo)
 	pu8IEs = ptstrNetworkInfo->pu8IEs;
 	u16IEsLen = ptstrNetworkInfo->u16IEsLen;
 
-	pNewJoinBssParam = WILC_MALLOC(sizeof(tstrJoinBssParam));
+	pNewJoinBssParam = kmalloc(sizeof(tstrJoinBssParam), GFP_KERNEL);
 	if (pNewJoinBssParam != NULL) {
 		memset(pNewJoinBssParam, 0, sizeof(tstrJoinBssParam));
 		pNewJoinBssParam->dtim_period = ptstrNetworkInfo->u8DtimPeriod;
diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 70a9450..c0bbf56 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -2181,7 +2181,7 @@ int wilc_netdev_init(void)
 	sema_init(&close_exit_sync, 0);
 
 	/*create the common structure*/
-	g_linux_wlan = WILC_MALLOC(sizeof(linux_wlan_t));
+	g_linux_wlan = kmalloc(sizeof(linux_wlan_t), GFP_KERNEL);
 	memset(g_linux_wlan, 0, sizeof(linux_wlan_t));
 
 	/*Reset interrupt count debug*/
diff --git a/drivers/staging/wilc1000/wilc_msgqueue.c b/drivers/staging/wilc1000/wilc_msgqueue.c
index 76d2e63..0a49cbe 100644
--- a/drivers/staging/wilc1000/wilc_msgqueue.c
+++ b/drivers/staging/wilc1000/wilc_msgqueue.c
@@ -68,11 +68,17 @@ int wilc_mq_send(WILC_MsgQueueHandle *pHandle,
 	spin_lock_irqsave(&pHandle->strCriticalSection, flags);
 
 	/* construct a new message */
-	pstrMessage = kmalloc(sizeof(Message), GFP_ATOMIC);
+	if (in_interrupt())
+		pstrMessage = kmalloc(sizeof(Message), GFP_ATOMIC);
+	else
+		pstrMessage = kmalloc(sizeof(Message), GFP_KERNEL);
 	WILC_NULLCHECK(s32RetStatus, pstrMessage);
 	pstrMessage->u32Length = u32SendBufferSize;
 	pstrMessage->pstrNext = NULL;
-	pstrMessage->pvBuffer = WILC_MALLOC(u32SendBufferSize);
+	if (in_interrupt())
+		pstrMessage->pvBuffer = kmalloc(u32SendBufferSize, GFP_ATOMIC);
+	else
+		pstrMessage->pvBuffer = kmalloc(u32SendBufferSize, GFP_KERNEL);
 	WILC_NULLCHECK(s32RetStatus, pstrMessage->pvBuffer);
 	memcpy(pstrMessage->pvBuffer, pvSendBuffer, u32SendBufferSize);
 
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index cf76a33..26412a5 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -342,7 +342,7 @@ void add_network_to_shadow(tstrNetworkInfo *pstrNetworkInfo, void *pUserVoid, vo
 	if (ap_found != -1)
 		kfree(astrLastScannedNtwrksShadow[ap_index].pu8IEs);
 	astrLastScannedNtwrksShadow[ap_index].pu8IEs =
-		WILC_MALLOC(pstrNetworkInfo->u16IEsLen);        /* will be deallocated by the WILC_WFI_CfgScan() function */
+		kmalloc(pstrNetworkInfo->u16IEsLen, GFP_KERNEL);        /* will be deallocated by the WILC_WFI_CfgScan() function */
 	memcpy(astrLastScannedNtwrksShadow[ap_index].pu8IEs,
 		    pstrNetworkInfo->pu8IEs, pstrNetworkInfo->u16IEsLen);
 
@@ -763,7 +763,7 @@ static int WILC_WFI_CfgScan(struct wiphy *wiphy, struct cfg80211_scan_request *r
 		if (request->n_ssids >= 1) {
 
 
-			strHiddenNetwork.pstrHiddenNetworkInfo = WILC_MALLOC(request->n_ssids * sizeof(tstrHiddenNetwork));
+			strHiddenNetwork.pstrHiddenNetworkInfo = kmalloc(request->n_ssids * sizeof(tstrHiddenNetwork), GFP_KERNEL);
 			strHiddenNetwork.u8ssidnum = request->n_ssids;
 
 
@@ -771,7 +771,7 @@ static int WILC_WFI_CfgScan(struct wiphy *wiphy, struct cfg80211_scan_request *r
 			for (i = 0; i < request->n_ssids; i++) {
 
 				if (request->ssids[i].ssid != NULL && request->ssids[i].ssid_len != 0) {
-					strHiddenNetwork.pstrHiddenNetworkInfo[i].pu8ssid = WILC_MALLOC(request->ssids[i].ssid_len);
+					strHiddenNetwork.pstrHiddenNetworkInfo[i].pu8ssid = kmalloc(request->ssids[i].ssid_len, GFP_KERNEL);
 					memcpy(strHiddenNetwork.pstrHiddenNetworkInfo[i].pu8ssid, request->ssids[i].ssid, request->ssids[i].ssid_len);
 					strHiddenNetwork.pstrHiddenNetworkInfo[i].u8ssidlen = request->ssids[i].ssid_len;
 				} else {
@@ -927,7 +927,7 @@ static int WILC_WFI_CfgConnect(struct wiphy *wiphy, struct net_device *dev,
 
 			/*BugID_5137*/
 			g_key_wep_params.key_len = sme->key_len;
-			g_key_wep_params.key = WILC_MALLOC(sme->key_len);
+			g_key_wep_params.key = kmalloc(sme->key_len, GFP_KERNEL);
 			memcpy(g_key_wep_params.key, sme->key, sme->key_len);
 			g_key_wep_params.key_idx = sme->key_idx;
 			g_wep_keys_saved = true;
@@ -945,7 +945,7 @@ static int WILC_WFI_CfgConnect(struct wiphy *wiphy, struct net_device *dev,
 
 			/*BugID_5137*/
 			g_key_wep_params.key_len = sme->key_len;
-			g_key_wep_params.key = WILC_MALLOC(sme->key_len);
+			g_key_wep_params.key = kmalloc(sme->key_len, GFP_KERNEL);
 			memcpy(g_key_wep_params.key, sme->key, sme->key_len);
 			g_key_wep_params.key_idx = sme->key_idx;
 			g_wep_keys_saved = true;
@@ -1199,13 +1199,13 @@ static int WILC_WFI_add_key(struct wiphy *wiphy, struct net_device *netdev, u8 k
 		if (priv->wdev->iftype == NL80211_IFTYPE_AP || priv->wdev->iftype == NL80211_IFTYPE_P2P_GO) {
 
 			if (priv->wilc_gtk[key_index] == NULL) {
-				priv->wilc_gtk[key_index] = WILC_MALLOC(sizeof(struct wilc_wfi_key));
+				priv->wilc_gtk[key_index] = kmalloc(sizeof(struct wilc_wfi_key), GFP_KERNEL);
 				priv->wilc_gtk[key_index]->key = NULL;
 				priv->wilc_gtk[key_index]->seq = NULL;
 
 			}
 			if (priv->wilc_ptk[key_index] == NULL) {
-				priv->wilc_ptk[key_index] = WILC_MALLOC(sizeof(struct wilc_wfi_key));
+				priv->wilc_ptk[key_index] = kmalloc(sizeof(struct wilc_wfi_key), GFP_KERNEL);
 				priv->wilc_ptk[key_index]->key = NULL;
 				priv->wilc_ptk[key_index]->seq = NULL;
 			}
@@ -1230,7 +1230,7 @@ static int WILC_WFI_add_key(struct wiphy *wiphy, struct net_device *netdev, u8 k
 				if (priv->wilc_gtk[key_index]->key)
 					kfree(priv->wilc_gtk[key_index]->key);
 
-				priv->wilc_gtk[key_index]->key = WILC_MALLOC(params->key_len);
+				priv->wilc_gtk[key_index]->key = kmalloc(params->key_len, GFP_KERNEL);
 				memcpy(priv->wilc_gtk[key_index]->key, params->key, params->key_len);
 
 				/* if there has been previous allocation for the same index through its seq, free that memory and allocate again*/
@@ -1238,7 +1238,7 @@ static int WILC_WFI_add_key(struct wiphy *wiphy, struct net_device *netdev, u8 k
 					kfree(priv->wilc_gtk[key_index]->seq);
 
 				if ((params->seq_len) > 0) {
-					priv->wilc_gtk[key_index]->seq = WILC_MALLOC(params->seq_len);
+					priv->wilc_gtk[key_index]->seq = kmalloc(params->seq_len, GFP_KERNEL);
 					memcpy(priv->wilc_gtk[key_index]->seq, params->seq, params->seq_len);
 				}
 
@@ -1276,13 +1276,13 @@ static int WILC_WFI_add_key(struct wiphy *wiphy, struct net_device *netdev, u8 k
 				if (priv->wilc_ptk[key_index]->key)
 					kfree(priv->wilc_ptk[key_index]->key);
 
-				priv->wilc_ptk[key_index]->key = WILC_MALLOC(params->key_len);
+				priv->wilc_ptk[key_index]->key = kmalloc(params->key_len, GFP_KERNEL);
 
 				if (priv->wilc_ptk[key_index]->seq)
 					kfree(priv->wilc_ptk[key_index]->seq);
 
 				if ((params->seq_len) > 0)
-					priv->wilc_ptk[key_index]->seq = WILC_MALLOC(params->seq_len);
+					priv->wilc_ptk[key_index]->seq = kmalloc(params->seq_len, GFP_KERNEL);
 
 				if (INFO) {
 					for (i = 0; i < params->key_len; i++)
@@ -1326,15 +1326,15 @@ static int WILC_WFI_add_key(struct wiphy *wiphy, struct net_device *netdev, u8 k
 					if (!mac_addr) {
 						g_add_gtk_key_params.mac_addr = NULL;
 					} else {
-						g_add_gtk_key_params.mac_addr = WILC_MALLOC(ETH_ALEN);
+						g_add_gtk_key_params.mac_addr = kmalloc(ETH_ALEN, GFP_KERNEL);
 						memcpy(g_add_gtk_key_params.mac_addr, mac_addr, ETH_ALEN);
 					}
 					g_key_gtk_params.key_len = params->key_len;
 					g_key_gtk_params.seq_len = params->seq_len;
-					g_key_gtk_params.key =  WILC_MALLOC(params->key_len);
+					g_key_gtk_params.key =  kmalloc(params->key_len, GFP_KERNEL);
 					memcpy(g_key_gtk_params.key, params->key, params->key_len);
 					if (params->seq_len > 0) {
-						g_key_gtk_params.seq =  WILC_MALLOC(params->seq_len);
+						g_key_gtk_params.seq =  kmalloc(params->seq_len, GFP_KERNEL);
 						memcpy(g_key_gtk_params.seq, params->seq, params->seq_len);
 					}
 					g_key_gtk_params.cipher = params->cipher;
@@ -1363,15 +1363,15 @@ static int WILC_WFI_add_key(struct wiphy *wiphy, struct net_device *netdev, u8 k
 					if (!mac_addr) {
 						g_add_ptk_key_params.mac_addr = NULL;
 					} else {
-						g_add_ptk_key_params.mac_addr = WILC_MALLOC(ETH_ALEN);
+						g_add_ptk_key_params.mac_addr = kmalloc(ETH_ALEN, GFP_KERNEL);
 						memcpy(g_add_ptk_key_params.mac_addr, mac_addr, ETH_ALEN);
 					}
 					g_key_ptk_params.key_len = params->key_len;
 					g_key_ptk_params.seq_len = params->seq_len;
-					g_key_ptk_params.key =  WILC_MALLOC(params->key_len);
+					g_key_ptk_params.key =  kmalloc(params->key_len, GFP_KERNEL);
 					memcpy(g_key_ptk_params.key, params->key, params->key_len);
 					if (params->seq_len > 0) {
-						g_key_ptk_params.seq =  WILC_MALLOC(params->seq_len);
+						g_key_ptk_params.seq =  kmalloc(params->seq_len, GFP_KERNEL);
 						memcpy(g_key_ptk_params.seq, params->seq, params->seq_len);
 					}
 					g_key_ptk_params.cipher = params->cipher;
@@ -2525,12 +2525,12 @@ int WILC_WFI_mgmt_tx(struct wiphy *wiphy,
 	if (ieee80211_is_mgmt(mgmt->frame_control)) {
 
 		/*mgmt frame allocation*/
-		mgmt_tx = WILC_MALLOC(sizeof(struct p2p_mgmt_data));
+		mgmt_tx = kmalloc(sizeof(struct p2p_mgmt_data), GFP_KERNEL);
 		if (mgmt_tx == NULL) {
 			PRINT_ER("Failed to allocate memory for mgmt_tx structure\n");
 			return WILC_FAIL;
 		}
-		mgmt_tx->buff = WILC_MALLOC(buf_len);
+		mgmt_tx->buff = kmalloc(buf_len, GFP_KERNEL);
 		if (mgmt_tx->buff == NULL) {
 			PRINT_ER("Failed to allocate memory for mgmt_tx buff\n");
 			kfree(mgmt_tx);
-- 
1.9.1

