Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:34028 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752637AbbHJCdw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Aug 2015 22:33:52 -0400
Received: by pawu10 with SMTP id u10so129141866paw.1
        for <linux-wireless@vger.kernel.org>; Sun, 09 Aug 2015 19:33:51 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, dean.lee@atmel.com,
	chris.park@atmel.com, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 08/11] staging: wilc1000: use memcpy instead of WILC_memcpy
Date: Mon, 10 Aug 2015 11:33:19 +0900
Message-Id: <1439174002-7365-8-git-send-email-chaehyun.lim@gmail.com> (sfid-20150810_043402_445129_A73EAD84)
In-Reply-To: <1439174002-7365-1-git-send-email-chaehyun.lim@gmail.com>
References: <1439174002-7365-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use memcpy instead of WILC_memcpy that is a custom function.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/coreconfigurator.c       |  22 +--
 drivers/staging/wilc1000/host_interface.c         | 200 +++++++++++-----------
 drivers/staging/wilc1000/linux_wlan.c             |   2 +-
 drivers/staging/wilc1000/wilc_msgqueue.c          |   4 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c |  52 +++---
 5 files changed, 140 insertions(+), 140 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index a950d40..5bb1b15 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -544,21 +544,21 @@ INLINE u8 get_from_ds(u8 *header)
 /* header and updates the MAC Address in the allocated 'addr' variable.      */
 INLINE void get_address1(u8 *pu8msa, u8 *addr)
 {
-	WILC_memcpy(addr, pu8msa + 4, 6);
+	memcpy(addr, pu8msa + 4, 6);
 }
 
 /* This function extracts the MAC Address in 'address2' field of the MAC     */
 /* header and updates the MAC Address in the allocated 'addr' variable.      */
 INLINE void get_address2(u8 *pu8msa, u8 *addr)
 {
-	WILC_memcpy(addr, pu8msa + 10, 6);
+	memcpy(addr, pu8msa + 10, 6);
 }
 
 /* This function extracts the MAC Address in 'address3' field of the MAC     */
 /* header and updates the MAC Address in the allocated 'addr' variable.      */
 INLINE void get_address3(u8 *pu8msa, u8 *addr)
 {
-	WILC_memcpy(addr, pu8msa + 16, 6);
+	memcpy(addr, pu8msa + 16, 6);
 }
 
 /* This function extracts the BSSID from the incoming WLAN packet based on   */
@@ -863,7 +863,7 @@ s32 ParseNetworkInfo(u8 *pu8MsgBuffer, tstrNetworkInfo **ppstrNetworkInfo)
 			pstrNetworkInfo->pu8IEs = (u8 *)WILC_MALLOC(u16IEsLen);
 			memset((void *)(pstrNetworkInfo->pu8IEs), 0, u16IEsLen);
 
-			WILC_memcpy(pstrNetworkInfo->pu8IEs, pu8IEs, u16IEsLen);
+			memcpy(pstrNetworkInfo->pu8IEs, pu8IEs, u16IEsLen);
 		}
 		pstrNetworkInfo->u16IEsLen = u16IEsLen;
 
@@ -950,7 +950,7 @@ s32 ParseAssocRespInfo(u8 *pu8Buffer, u32 u32BufferLen,
 		pstrConnectRespInfo->pu8RespIEs = (u8 *)WILC_MALLOC(u16IEsLen);
 		memset((void *)(pstrConnectRespInfo->pu8RespIEs), 0, u16IEsLen);
 
-		WILC_memcpy(pstrConnectRespInfo->pu8RespIEs, pu8IEs, u16IEsLen);
+		memcpy(pstrConnectRespInfo->pu8RespIEs, pu8IEs, u16IEsLen);
 		pstrConnectRespInfo->u16RespIEsLen = u16IEsLen;
 	}
 
@@ -1037,7 +1037,7 @@ s32 ParseSurveyResults(u8 ppu8RcvdSiteSurveyResults[][MAX_SURVEY_RESULT_FRAG_SIZ
 		pu8BufferPtr += 2;
 
 		for (j = 0; j < u32SurveyBytesLength; j += SURVEY_RESULT_LENGTH) {
-			WILC_memcpy(&pstrSurveyResults[u32SurveyResultsCount], pu8BufferPtr, SURVEY_RESULT_LENGTH);
+			memcpy(&pstrSurveyResults[u32SurveyResultsCount], pu8BufferPtr, SURVEY_RESULT_LENGTH);
 			pu8BufferPtr += SURVEY_RESULT_LENGTH;
 			u32SurveyResultsCount++;
 		}
@@ -1562,10 +1562,10 @@ s32 further_process_response(u8 *resp,
 	}
 
 	case WID_STR:
-		WILC_memcpy(cfg_str, resp + idx, cfg_len);
+		memcpy(cfg_str, resp + idx, cfg_len);
 		/* cfg_str[cfg_len] = '\0'; //mostafa: no need currently for NULL termination */
 		if (pstrWIDresult->s32ValueSize >= cfg_len) {
-			WILC_memcpy(pstrWIDresult->ps8WidVal, cfg_str, cfg_len); /* mostafa: no need currently for the extra NULL byte */
+			memcpy(pstrWIDresult->ps8WidVal, cfg_str, cfg_len); /* mostafa: no need currently for the extra NULL byte */
 			pstrWIDresult->s32ValueSize = cfg_len;
 		} else {
 			PRINT_ER("allocated WID buffer length is smaller than the received WID Length\n");
@@ -1591,7 +1591,7 @@ s32 further_process_response(u8 *resp,
 
 	case WID_BIN_DATA:
 		if (pstrWIDresult->s32ValueSize >= cfg_len) {
-			WILC_memcpy(pstrWIDresult->ps8WidVal, resp + idx, cfg_len);
+			memcpy(pstrWIDresult->ps8WidVal, resp + idx, cfg_len);
 			pstrWIDresult->s32ValueSize = cfg_len;
 		} else {
 			PRINT_ER("Allocated WID buffer length is smaller than the received WID Length Err(%d)\n", retval);
@@ -1879,10 +1879,10 @@ s32 ConfigProvideResponse(char *pcRespBuffer, s32 s32RespLen)
 
 	if (gstrConfigPktInfo.bRespRequired) {
 		if (s32RespLen <= gstrConfigPktInfo.s32MaxRespBuffLen) {
-			WILC_memcpy(gstrConfigPktInfo.pcRespBuffer, pcRespBuffer, s32RespLen);
+			memcpy(gstrConfigPktInfo.pcRespBuffer, pcRespBuffer, s32RespLen);
 			gstrConfigPktInfo.s32BytesRead = s32RespLen;
 		} else {
-			WILC_memcpy(gstrConfigPktInfo.pcRespBuffer, pcRespBuffer, gstrConfigPktInfo.s32MaxRespBuffLen);
+			memcpy(gstrConfigPktInfo.pcRespBuffer, pcRespBuffer, gstrConfigPktInfo.s32MaxRespBuffLen);
 			gstrConfigPktInfo.s32BytesRead = gstrConfigPktInfo.s32MaxRespBuffLen;
 			PRINT_ER("BusProvideResponse() Response greater than the prepared Buffer Size\n");
 		}
diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 31790a3d..dedba7f 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -739,7 +739,7 @@ s32 Handle_set_IPAddress(void *drvHandler, u8 *pu8IPAddr, u8 idx)
 
 	PRINT_INFO(HOSTINF_DBG, "Indx = %d, Handling set  IP = %pI4\n", idx, pu8IPAddr);
 
-	WILC_memcpy(gs8SetIP[idx], pu8IPAddr, IP_ALEN);
+	memcpy(gs8SetIP[idx], pu8IPAddr, IP_ALEN);
 
 	/*prepare configuration packet*/
 	strWID.u16WIDid = (u16)WID_IP_ADDRESS;
@@ -795,7 +795,7 @@ s32 Handle_get_IPAddress(void *drvHandler, u8 *pu8IPAddr, u8 idx)
 
 	PRINT_INFO(HOSTINF_DBG, "%pI4\n", strWID.ps8WidVal);
 
-	WILC_memcpy(gs8GetIP[idx], strWID.ps8WidVal, IP_ALEN);
+	memcpy(gs8GetIP[idx], strWID.ps8WidVal, IP_ALEN);
 
 	/*get the value by searching the local copy*/
 	WILC_FREE(strWID.ps8WidVal);
@@ -843,7 +843,7 @@ static s32 Handle_SetMacAddress(void *drvHandler, tstrHostIfSetMacAddress *pstrH
 		PRINT_ER("No buffer to send mac address\n");
 		return WILC_FAIL;
 	}
-	WILC_memcpy(mac_buf, pstrHostIfSetMacAddress->u8MacAddress, ETH_ALEN);
+	memcpy(mac_buf, pstrHostIfSetMacAddress->u8MacAddress, ETH_ALEN);
 
 	/*prepare configuration packet*/
 	strWID.u16WIDid = (u16)WID_MAC_ADDR;
@@ -1293,7 +1293,7 @@ static s32 Handle_Scan(void *drvHandler, tstrHostIFscanAttr *pstrHostIFscanAttr)
 
 		for (i = 0; i < pstrHostIFscanAttr->strHiddenNetwork.u8ssidnum; i++) {
 			*pu8Buffer++ = pstrHostIFscanAttr->strHiddenNetwork.pstrHiddenNetworkInfo[i].u8ssidlen;
-			WILC_memcpy(pu8Buffer, pstrHostIFscanAttr->strHiddenNetwork.pstrHiddenNetworkInfo[i].pu8ssid, pstrHostIFscanAttr->strHiddenNetwork.pstrHiddenNetworkInfo[i].u8ssidlen);
+			memcpy(pu8Buffer, pstrHostIFscanAttr->strHiddenNetwork.pstrHiddenNetworkInfo[i].pu8ssid, pstrHostIFscanAttr->strHiddenNetwork.pstrHiddenNetworkInfo[i].u8ssidlen);
 			pu8Buffer += pstrHostIFscanAttr->strHiddenNetwork.pstrHiddenNetworkInfo[i].u8ssidlen;
 		}
 
@@ -1513,7 +1513,7 @@ static s32 Handle_Connect(void *drvHandler, tstrHostIFconnectAttr *pstrHostIFcon
 		/* use the parsed info in pstrSurveyResults, then deallocate it */
 		PRINT_D(HOSTINF_DBG, "Copying site survey results in global structure, then deallocate\n");
 		for (i = 0; i < pstrWFIDrv->u32SurveyResultsCount; i++)	{
-			WILC_memcpy(&pstrWFIDrv->astrSurveyResults[i], &pstrSurveyResults[i],
+			memcpy(&pstrWFIDrv->astrSurveyResults[i], &pstrSurveyResults[i],
 				    sizeof(wid_site_survey_reslts_s));
 		}
 
@@ -1559,13 +1559,13 @@ static s32 Handle_Connect(void *drvHandler, tstrHostIFconnectAttr *pstrHostIFcon
 
 		if (pstrHostIFconnectAttr->pu8bssid != NULL) {
 			pstrWFIDrv->strWILC_UsrConnReq.pu8bssid = (u8 *)WILC_MALLOC(6);
-			WILC_memcpy(pstrWFIDrv->strWILC_UsrConnReq.pu8bssid, pstrHostIFconnectAttr->pu8bssid, 6);
+			memcpy(pstrWFIDrv->strWILC_UsrConnReq.pu8bssid, pstrHostIFconnectAttr->pu8bssid, 6);
 		}
 
 		pstrWFIDrv->strWILC_UsrConnReq.ssidLen = pstrHostIFconnectAttr->ssidLen;
 		if (pstrHostIFconnectAttr->pu8ssid != NULL) {
 			pstrWFIDrv->strWILC_UsrConnReq.pu8ssid = (u8 *)WILC_MALLOC(pstrHostIFconnectAttr->ssidLen + 1);
-			WILC_memcpy(pstrWFIDrv->strWILC_UsrConnReq.pu8ssid, pstrHostIFconnectAttr->pu8ssid,
+			memcpy(pstrWFIDrv->strWILC_UsrConnReq.pu8ssid, pstrHostIFconnectAttr->pu8ssid,
 				    pstrHostIFconnectAttr->ssidLen);
 			pstrWFIDrv->strWILC_UsrConnReq.pu8ssid[pstrHostIFconnectAttr->ssidLen] = '\0';
 		}
@@ -1573,7 +1573,7 @@ static s32 Handle_Connect(void *drvHandler, tstrHostIFconnectAttr *pstrHostIFcon
 		pstrWFIDrv->strWILC_UsrConnReq.ConnReqIEsLen = pstrHostIFconnectAttr->IEsLen;
 		if (pstrHostIFconnectAttr->pu8IEs != NULL) {
 			pstrWFIDrv->strWILC_UsrConnReq.pu8ConnReqIEs = (u8 *)WILC_MALLOC(pstrHostIFconnectAttr->IEsLen);
-			WILC_memcpy(pstrWFIDrv->strWILC_UsrConnReq.pu8ConnReqIEs, pstrHostIFconnectAttr->pu8IEs,
+			memcpy(pstrWFIDrv->strWILC_UsrConnReq.pu8ConnReqIEs, pstrHostIFconnectAttr->pu8IEs,
 				    pstrHostIFconnectAttr->IEsLen);
 		}
 
@@ -1666,13 +1666,13 @@ static s32 Handle_Connect(void *drvHandler, tstrHostIFconnectAttr *pstrHostIFcon
 
 	if (pstrHostIFconnectAttr->pu8bssid != NULL) {
 		pstrWFIDrv->strWILC_UsrConnReq.pu8bssid = (u8 *)WILC_MALLOC(6);
-		WILC_memcpy(pstrWFIDrv->strWILC_UsrConnReq.pu8bssid, pstrHostIFconnectAttr->pu8bssid, 6);
+		memcpy(pstrWFIDrv->strWILC_UsrConnReq.pu8bssid, pstrHostIFconnectAttr->pu8bssid, 6);
 	}
 
 	pstrWFIDrv->strWILC_UsrConnReq.ssidLen = pstrHostIFconnectAttr->ssidLen;
 	if (pstrHostIFconnectAttr->pu8ssid != NULL) {
 		pstrWFIDrv->strWILC_UsrConnReq.pu8ssid = (u8 *)WILC_MALLOC(pstrHostIFconnectAttr->ssidLen + 1);
-		WILC_memcpy(pstrWFIDrv->strWILC_UsrConnReq.pu8ssid, pstrHostIFconnectAttr->pu8ssid,
+		memcpy(pstrWFIDrv->strWILC_UsrConnReq.pu8ssid, pstrHostIFconnectAttr->pu8ssid,
 			    pstrHostIFconnectAttr->ssidLen);
 		pstrWFIDrv->strWILC_UsrConnReq.pu8ssid[pstrHostIFconnectAttr->ssidLen] = '\0';
 	}
@@ -1680,7 +1680,7 @@ static s32 Handle_Connect(void *drvHandler, tstrHostIFconnectAttr *pstrHostIFcon
 	pstrWFIDrv->strWILC_UsrConnReq.ConnReqIEsLen = pstrHostIFconnectAttr->IEsLen;
 	if (pstrHostIFconnectAttr->pu8IEs != NULL) {
 		pstrWFIDrv->strWILC_UsrConnReq.pu8ConnReqIEs = (u8 *)WILC_MALLOC(pstrHostIFconnectAttr->IEsLen);
-		WILC_memcpy(pstrWFIDrv->strWILC_UsrConnReq.pu8ConnReqIEs, pstrHostIFconnectAttr->pu8IEs,
+		memcpy(pstrWFIDrv->strWILC_UsrConnReq.pu8ConnReqIEs, pstrHostIFconnectAttr->pu8IEs,
 			    pstrHostIFconnectAttr->IEsLen);
 	}
 
@@ -1774,7 +1774,7 @@ static s32 Handle_Connect(void *drvHandler, tstrHostIFconnectAttr *pstrHostIFcon
 	pu8CurrByte = strWIDList[u32WidsCount].ps8WidVal;
 
 	if (pstrHostIFconnectAttr->pu8ssid != NULL) {
-		WILC_memcpy(pu8CurrByte, pstrHostIFconnectAttr->pu8ssid, pstrHostIFconnectAttr->ssidLen);
+		memcpy(pu8CurrByte, pstrHostIFconnectAttr->pu8ssid, pstrHostIFconnectAttr->ssidLen);
 		pu8CurrByte[pstrHostIFconnectAttr->ssidLen] = '\0';
 	}
 	pu8CurrByte += MAX_SSID_LEN;
@@ -1785,7 +1785,7 @@ static s32 Handle_Connect(void *drvHandler, tstrHostIFconnectAttr *pstrHostIFcon
 		*(pu8CurrByte++) = 0xFF;
 	}
 	if (pstrHostIFconnectAttr->pu8bssid != NULL)
-		WILC_memcpy(pu8CurrByte, pstrHostIFconnectAttr->pu8bssid, 6);
+		memcpy(pu8CurrByte, pstrHostIFconnectAttr->pu8bssid, 6);
 	pu8CurrByte += 6;
 
 	/* keep the buffer at the start of the allocated pointer to use it with the free*/
@@ -1812,7 +1812,7 @@ static s32 Handle_Connect(void *drvHandler, tstrHostIFconnectAttr *pstrHostIFcon
 
 
 	if (pstrHostIFconnectAttr->pu8ssid != NULL) {
-		WILC_memcpy(pu8CurrByte, pstrHostIFconnectAttr->pu8ssid, pstrHostIFconnectAttr->ssidLen);
+		memcpy(pu8CurrByte, pstrHostIFconnectAttr->pu8ssid, pstrHostIFconnectAttr->ssidLen);
 		pu8CurrByte[pstrHostIFconnectAttr->ssidLen] = '\0';
 	}
 	pu8CurrByte += MAX_SSID_LEN;
@@ -1833,12 +1833,12 @@ static s32 Handle_Connect(void *drvHandler, tstrHostIFconnectAttr *pstrHostIFcon
 
 	/* sa*/
 	if (pstrHostIFconnectAttr->pu8bssid != NULL)
-		WILC_memcpy(pu8CurrByte, pstrHostIFconnectAttr->pu8bssid, 6);
+		memcpy(pu8CurrByte, pstrHostIFconnectAttr->pu8bssid, 6);
 	pu8CurrByte += 6;
 
 	/* bssid*/
 	if (pstrHostIFconnectAttr->pu8bssid != NULL)
-		WILC_memcpy(pu8CurrByte, pstrHostIFconnectAttr->pu8bssid, 6);
+		memcpy(pu8CurrByte, pstrHostIFconnectAttr->pu8bssid, 6);
 	pu8CurrByte += 6;
 
 	/* Beacon Period*/
@@ -1849,7 +1849,7 @@ static s32 Handle_Connect(void *drvHandler, tstrHostIFconnectAttr *pstrHostIFcon
 	*(pu8CurrByte++)  =  ptstrJoinBssParam->dtim_period;
 	PRINT_D(HOSTINF_DBG, "* DTIM Period %d*\n", (*(pu8CurrByte - 1)));
 	/* Supported rates*/
-	WILC_memcpy(pu8CurrByte, ptstrJoinBssParam->supp_rates, MAX_RATES_SUPPORTED + 1);
+	memcpy(pu8CurrByte, ptstrJoinBssParam->supp_rates, MAX_RATES_SUPPORTED + 1);
 	pu8CurrByte += (MAX_RATES_SUPPORTED + 1);
 
 	/* wmm cap*/
@@ -1873,15 +1873,15 @@ static s32 Handle_Connect(void *drvHandler, tstrHostIFconnectAttr *pstrHostIFcon
 	*(pu8CurrByte++) =  ptstrJoinBssParam->mode_802_11i;
 	PRINT_D(HOSTINF_DBG, "* mode_802_11i %d*\n", (*(pu8CurrByte - 1)));
 	/* rsn pcip policy*/
-	WILC_memcpy(pu8CurrByte, ptstrJoinBssParam->rsn_pcip_policy, sizeof(ptstrJoinBssParam->rsn_pcip_policy));
+	memcpy(pu8CurrByte, ptstrJoinBssParam->rsn_pcip_policy, sizeof(ptstrJoinBssParam->rsn_pcip_policy));
 	pu8CurrByte += sizeof(ptstrJoinBssParam->rsn_pcip_policy);
 
 	/* rsn auth policy*/
-	WILC_memcpy(pu8CurrByte, ptstrJoinBssParam->rsn_auth_policy, sizeof(ptstrJoinBssParam->rsn_auth_policy));
+	memcpy(pu8CurrByte, ptstrJoinBssParam->rsn_auth_policy, sizeof(ptstrJoinBssParam->rsn_auth_policy));
 	pu8CurrByte += sizeof(ptstrJoinBssParam->rsn_auth_policy);
 
 	/* rsn auth policy*/
-	WILC_memcpy(pu8CurrByte, ptstrJoinBssParam->rsn_cap, sizeof(ptstrJoinBssParam->rsn_cap));
+	memcpy(pu8CurrByte, ptstrJoinBssParam->rsn_cap, sizeof(ptstrJoinBssParam->rsn_cap));
 	pu8CurrByte += sizeof(ptstrJoinBssParam->rsn_cap);
 
 	/*BugID_5137*/
@@ -1906,15 +1906,15 @@ static s32 Handle_Connect(void *drvHandler, tstrHostIFconnectAttr *pstrHostIFcon
 
 		*(pu8CurrByte++) = ptstrJoinBssParam->u8Count;
 
-		WILC_memcpy(pu8CurrByte, ptstrJoinBssParam->au8Duration, sizeof(ptstrJoinBssParam->au8Duration));
+		memcpy(pu8CurrByte, ptstrJoinBssParam->au8Duration, sizeof(ptstrJoinBssParam->au8Duration));
 
 		pu8CurrByte += sizeof(ptstrJoinBssParam->au8Duration);
 
-		WILC_memcpy(pu8CurrByte, ptstrJoinBssParam->au8Interval, sizeof(ptstrJoinBssParam->au8Interval));
+		memcpy(pu8CurrByte, ptstrJoinBssParam->au8Interval, sizeof(ptstrJoinBssParam->au8Interval));
 
 		pu8CurrByte += sizeof(ptstrJoinBssParam->au8Interval);
 
-		WILC_memcpy(pu8CurrByte, ptstrJoinBssParam->au8StartTime, sizeof(ptstrJoinBssParam->au8StartTime));
+		memcpy(pu8CurrByte, ptstrJoinBssParam->au8StartTime, sizeof(ptstrJoinBssParam->au8StartTime));
 
 		pu8CurrByte += sizeof(ptstrJoinBssParam->au8StartTime);
 
@@ -1946,7 +1946,7 @@ static s32 Handle_Connect(void *drvHandler, tstrHostIFconnectAttr *pstrHostIFcon
 	PRINT_D(GENERIC_DBG, "send HOST_IF_WAITING_CONN_RESP\n");
 
 	if (pstrHostIFconnectAttr->pu8bssid != NULL) {
-		WILC_memcpy(u8ConnectedSSID, pstrHostIFconnectAttr->pu8bssid, ETH_ALEN);
+		memcpy(u8ConnectedSSID, pstrHostIFconnectAttr->pu8bssid, ETH_ALEN);
 
 		PRINT_D(GENERIC_DBG, "save Bssid = %x:%x:%x:%x:%x:%x\n", (pstrHostIFconnectAttr->pu8bssid[0]), (pstrHostIFconnectAttr->pu8bssid[1]), (pstrHostIFconnectAttr->pu8bssid[2]), (pstrHostIFconnectAttr->pu8bssid[3]), (pstrHostIFconnectAttr->pu8bssid[4]), (pstrHostIFconnectAttr->pu8bssid[5]));
 		PRINT_D(GENERIC_DBG, "save bssid = %x:%x:%x:%x:%x:%x\n", (u8ConnectedSSID[0]), (u8ConnectedSSID[1]), (u8ConnectedSSID[2]), (u8ConnectedSSID[3]), (u8ConnectedSSID[4]), (u8ConnectedSSID[5]));
@@ -1974,12 +1974,12 @@ static s32 Handle_Connect(void *drvHandler, tstrHostIFconnectAttr *pstrHostIFcon
 
 		if (pstrHostIFconnectAttr->pfConnectResult != NULL) {
 			if (pstrHostIFconnectAttr->pu8bssid != NULL)
-				WILC_memcpy(strConnectInfo.au8bssid, pstrHostIFconnectAttr->pu8bssid, 6);
+				memcpy(strConnectInfo.au8bssid, pstrHostIFconnectAttr->pu8bssid, 6);
 
 			if (pstrHostIFconnectAttr->pu8IEs != NULL) {
 				strConnectInfo.ReqIEsLen = pstrHostIFconnectAttr->IEsLen;
 				strConnectInfo.pu8ReqIEs = (u8 *)WILC_MALLOC(pstrHostIFconnectAttr->IEsLen);
-				WILC_memcpy(strConnectInfo.pu8ReqIEs,
+				memcpy(strConnectInfo.pu8ReqIEs,
 					    pstrHostIFconnectAttr->pu8IEs,
 					    pstrHostIFconnectAttr->IEsLen);
 			}
@@ -2130,14 +2130,14 @@ static s32 Handle_ConnectTimeout(void *drvHandler)
 	 *   WID_DISCONNECT} */
 	if (pstrWFIDrv->strWILC_UsrConnReq.pfUserConnectResult != NULL)	{
 		if (pstrWFIDrv->strWILC_UsrConnReq.pu8bssid != NULL) {
-			WILC_memcpy(strConnectInfo.au8bssid,
+			memcpy(strConnectInfo.au8bssid,
 				    pstrWFIDrv->strWILC_UsrConnReq.pu8bssid, 6);
 		}
 
 		if (pstrWFIDrv->strWILC_UsrConnReq.pu8ConnReqIEs != NULL) {
 			strConnectInfo.ReqIEsLen = pstrWFIDrv->strWILC_UsrConnReq.ConnReqIEsLen;
 			strConnectInfo.pu8ReqIEs = (u8 *)WILC_MALLOC(pstrWFIDrv->strWILC_UsrConnReq.ConnReqIEsLen);
-			WILC_memcpy(strConnectInfo.pu8ReqIEs,
+			memcpy(strConnectInfo.pu8ReqIEs,
 				    pstrWFIDrv->strWILC_UsrConnReq.pu8ConnReqIEs,
 				    pstrWFIDrv->strWILC_UsrConnReq.ConnReqIEsLen);
 		}
@@ -2274,7 +2274,7 @@ static s32 Handle_RcvdNtwrkInfo(void *drvHandler, tstrRcvdNetworkInfo *pstrRcvdN
 
 				if ((pstrWFIDrv->strWILC_UsrScanReq.astrFoundNetworkInfo[pstrWFIDrv->strWILC_UsrScanReq.u32RcvdChCount].au8bssid != NULL)
 				    && (pstrNetworkInfo->au8bssid != NULL)) {
-					WILC_memcpy(pstrWFIDrv->strWILC_UsrScanReq.astrFoundNetworkInfo[pstrWFIDrv->strWILC_UsrScanReq.u32RcvdChCount].au8bssid,
+					memcpy(pstrWFIDrv->strWILC_UsrScanReq.astrFoundNetworkInfo[pstrWFIDrv->strWILC_UsrScanReq.u32RcvdChCount].au8bssid,
 						    pstrNetworkInfo->au8bssid, 6);
 
 					pstrWFIDrv->strWILC_UsrScanReq.u32RcvdChCount++;
@@ -2427,7 +2427,7 @@ static s32 Handle_RcvdGnrlAsyncInfo(void *drvHandler, tstrRcvdGnrlAsyncInfo *pst
 
 
 								strConnectInfo.pu8RespIEs = (u8 *)WILC_MALLOC(pstrConnectRespInfo->u16RespIEsLen);
-								WILC_memcpy(strConnectInfo.pu8RespIEs, pstrConnectRespInfo->pu8RespIEs,
+								memcpy(strConnectInfo.pu8RespIEs, pstrConnectRespInfo->pu8RespIEs,
 									    pstrConnectRespInfo->u16RespIEsLen);
 							}
 						}
@@ -2458,11 +2458,11 @@ static s32 Handle_RcvdGnrlAsyncInfo(void *drvHandler, tstrRcvdGnrlAsyncInfo *pst
 			/*               through a structure of type tstrConnectRespInfo */
 			if (pstrWFIDrv->strWILC_UsrConnReq.pu8bssid != NULL) {
 				PRINT_D(HOSTINF_DBG, "Retrieving actual BSSID from AP\n");
-				WILC_memcpy(strConnectInfo.au8bssid, pstrWFIDrv->strWILC_UsrConnReq.pu8bssid, 6);
+				memcpy(strConnectInfo.au8bssid, pstrWFIDrv->strWILC_UsrConnReq.pu8bssid, 6);
 
 				if ((u8MacStatus == MAC_CONNECTED) &&
 				    (strConnectInfo.u16ConnectStatus == SUCCESSFUL_STATUSCODE))	{
-					WILC_memcpy(pstrWFIDrv->au8AssociatedBSSID,
+					memcpy(pstrWFIDrv->au8AssociatedBSSID,
 						    pstrWFIDrv->strWILC_UsrConnReq.pu8bssid, ETH_ALEN);
 				}
 			}
@@ -2471,7 +2471,7 @@ static s32 Handle_RcvdGnrlAsyncInfo(void *drvHandler, tstrRcvdGnrlAsyncInfo *pst
 			if (pstrWFIDrv->strWILC_UsrConnReq.pu8ConnReqIEs != NULL) {
 				strConnectInfo.ReqIEsLen = pstrWFIDrv->strWILC_UsrConnReq.ConnReqIEsLen;
 				strConnectInfo.pu8ReqIEs = (u8 *)WILC_MALLOC(pstrWFIDrv->strWILC_UsrConnReq.ConnReqIEsLen);
-				WILC_memcpy(strConnectInfo.pu8ReqIEs,
+				memcpy(strConnectInfo.pu8ReqIEs,
 					    pstrWFIDrv->strWILC_UsrConnReq.pu8ConnReqIEs,
 					    pstrWFIDrv->strWILC_UsrConnReq.ConnReqIEsLen);
 			}
@@ -2713,7 +2713,7 @@ static int Handle_Key(void *drvHandler, tstrHostIFkeyAttr *pstrHostIFkeyAttr)
 				return -1;
 			}
 
-			WILC_memcpy(pu8keybuf, pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwepAttr.pu8WepKey,
+			memcpy(pu8keybuf, pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwepAttr.pu8WepKey,
 				    pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwepAttr.u8WepKeylen);
 
 
@@ -2741,9 +2741,9 @@ static int Handle_Key(void *drvHandler, tstrHostIFkeyAttr *pstrHostIFkeyAttr)
 			}
 			pu8keybuf[0] = pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwepAttr.u8Wepidx;
 
-			WILC_memcpy(pu8keybuf + 1, &pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwepAttr.u8WepKeylen, 1);
+			memcpy(pu8keybuf + 1, &pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwepAttr.u8WepKeylen, 1);
 
-			WILC_memcpy(pu8keybuf + 2, pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwepAttr.pu8WepKey,
+			memcpy(pu8keybuf + 2, pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwepAttr.pu8WepKey,
 				    pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwepAttr.u8WepKeylen);
 
 			WILC_FREE(pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwepAttr.pu8WepKey);
@@ -2800,14 +2800,14 @@ static int Handle_Key(void *drvHandler, tstrHostIFkeyAttr *pstrHostIFkeyAttr)
 
 
 			if (pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwpaAttr.pu8seq != NULL)
-				WILC_memcpy(pu8keybuf + 6, pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwpaAttr.pu8seq, 8);
+				memcpy(pu8keybuf + 6, pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwpaAttr.pu8seq, 8);
 
 
-			WILC_memcpy(pu8keybuf + 14, &pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwpaAttr.u8keyidx, 1);
+			memcpy(pu8keybuf + 14, &pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwpaAttr.u8keyidx, 1);
 
-			WILC_memcpy(pu8keybuf + 15, &pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwpaAttr.u8Keylen, 1);
+			memcpy(pu8keybuf + 15, &pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwpaAttr.u8Keylen, 1);
 
-			WILC_memcpy(pu8keybuf + 16, pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwpaAttr.pu8key,
+			memcpy(pu8keybuf + 16, pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwpaAttr.pu8key,
 				    pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwpaAttr.u8Keylen);
 			/* pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwpaAttr.u8Ciphermode =  0X51; */
 			strWIDList[0].u16WIDid = (u16)WID_11I_MODE;
@@ -2849,16 +2849,16 @@ static int Handle_Key(void *drvHandler, tstrHostIFkeyAttr *pstrHostIFkeyAttr)
 			 |	6 bytes	 | 8 byte  |1 byte |  1 byte	|   16 bytes	|	  8 bytes	 |*/
 
 			if (pstrWFIDrv->enuHostIFstate == HOST_IF_CONNECTED)
-				WILC_memcpy(pu8keybuf, pstrWFIDrv->au8AssociatedBSSID, ETH_ALEN);
+				memcpy(pu8keybuf, pstrWFIDrv->au8AssociatedBSSID, ETH_ALEN);
 			else
 				PRINT_ER("Couldn't handle WPARxGtk while enuHostIFstate is not HOST_IF_CONNECTED\n");
 
-			WILC_memcpy(pu8keybuf + 6, pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwpaAttr.pu8seq, 8);
+			memcpy(pu8keybuf + 6, pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwpaAttr.pu8seq, 8);
 
-			WILC_memcpy(pu8keybuf + 14, &pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwpaAttr.u8keyidx, 1);
+			memcpy(pu8keybuf + 14, &pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwpaAttr.u8keyidx, 1);
 
-			WILC_memcpy(pu8keybuf + 15, &pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwpaAttr.u8Keylen, 1);
-			WILC_memcpy(pu8keybuf + 16, pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwpaAttr.pu8key,
+			memcpy(pu8keybuf + 15, &pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwpaAttr.u8Keylen, 1);
+			memcpy(pu8keybuf + 16, pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwpaAttr.pu8key,
 				    pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwpaAttr.u8Keylen);
 
 			strWID.u16WIDid	= (u16)WID_ADD_RX_GTK;
@@ -2904,12 +2904,12 @@ _WPARxGtk_end_case_:
 			 |	6 bytes    |	1 byte    |   1byte	 |   16 bytes	 |	  8 bytes	  |	   8 bytes	  |
 			 |-----------------------------------------------------------------------------|*/
 
-			WILC_memcpy(pu8keybuf, pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwpaAttr.pu8macaddr, 6);  /*1 bytes Key Length */
+			memcpy(pu8keybuf, pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwpaAttr.pu8macaddr, 6);  /*1 bytes Key Length */
 
-			WILC_memcpy(pu8keybuf + 6, &pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwpaAttr.u8keyidx, 1);
-			WILC_memcpy(pu8keybuf + 7, &pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwpaAttr.u8Keylen, 1);
+			memcpy(pu8keybuf + 6, &pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwpaAttr.u8keyidx, 1);
+			memcpy(pu8keybuf + 7, &pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwpaAttr.u8Keylen, 1);
 			/*16 byte TK*/
-			WILC_memcpy(pu8keybuf + 8, pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwpaAttr.pu8key,
+			memcpy(pu8keybuf + 8, pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwpaAttr.pu8key,
 				    pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwpaAttr.u8Keylen);
 
 
@@ -2951,11 +2951,11 @@ _WPARxGtk_end_case_:
 			 |	6 bytes		 |	1byte	  |   16 bytes	 |	  8 bytes	  |	   8 bytes	  |
 			 |-----------------------------------------------------------------------------|*/
 
-			WILC_memcpy(pu8keybuf, pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwpaAttr.pu8macaddr, 6);  /*1 bytes Key Length */
+			memcpy(pu8keybuf, pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwpaAttr.pu8macaddr, 6);  /*1 bytes Key Length */
 
-			WILC_memcpy(pu8keybuf + 6, &pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwpaAttr.u8Keylen, 1);
+			memcpy(pu8keybuf + 6, &pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwpaAttr.u8Keylen, 1);
 			/*16 byte TK*/
-			WILC_memcpy(pu8keybuf + 7, pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwpaAttr.pu8key,
+			memcpy(pu8keybuf + 7, pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwpaAttr.pu8key,
 				    pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwpaAttr.u8Keylen);
 
 
@@ -2994,8 +2994,8 @@ _WPAPtk_end_case_:
 
 		for (i = 0; i < pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFpmkidAttr.numpmkid; i++) {
 
-			WILC_memcpy(pu8keybuf + ((PMKSA_KEY_LEN * i) + 1), pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFpmkidAttr.pmkidlist[i].bssid, ETH_ALEN);
-			WILC_memcpy(pu8keybuf + ((PMKSA_KEY_LEN * i) + ETH_ALEN + 1), pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFpmkidAttr.pmkidlist[i].pmkid, PMKID_LEN);
+			memcpy(pu8keybuf + ((PMKSA_KEY_LEN * i) + 1), pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFpmkidAttr.pmkidlist[i].bssid, ETH_ALEN);
+			memcpy(pu8keybuf + ((PMKSA_KEY_LEN * i) + ETH_ALEN + 1), pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFpmkidAttr.pmkidlist[i].pmkid, PMKID_LEN);
 		}
 
 		strWID.u16WIDid	= (u16)WID_PMKID_INFO;
@@ -3377,7 +3377,7 @@ static s32 Handle_Get_InActiveTime(void *drvHandler, tstrHostIfStaInactiveT *str
 
 
 	stamac = strWID.ps8WidVal;
-	WILC_memcpy(stamac, strHostIfStaInactiveT->mac, ETH_ALEN);
+	memcpy(stamac, strHostIfStaInactiveT->mac, ETH_ALEN);
 
 
 	PRINT_D(CFG80211_DBG, "SETING STA inactive time\n");
@@ -3552,7 +3552,7 @@ static u32 WILC_HostIf_PackStaParam(u8 *pu8Buffer, tstrWILC_AddStaParam *pstrSta
 	pu8CurrByte = pu8Buffer;
 
 	PRINT_D(HOSTINF_DBG, "Packing STA params\n");
-	WILC_memcpy(pu8CurrByte, pstrStationParam->au8BSSID, ETH_ALEN);
+	memcpy(pu8CurrByte, pstrStationParam->au8BSSID, ETH_ALEN);
 	pu8CurrByte +=  ETH_ALEN;
 
 	*pu8CurrByte++ = pstrStationParam->u16AssocID & 0xFF;
@@ -3560,7 +3560,7 @@ static u32 WILC_HostIf_PackStaParam(u8 *pu8Buffer, tstrWILC_AddStaParam *pstrSta
 
 	*pu8CurrByte++ = pstrStationParam->u8NumRates;
 	if (pstrStationParam->u8NumRates > 0)
-		WILC_memcpy(pu8CurrByte, pstrStationParam->pu8Rates, pstrStationParam->u8NumRates);
+		memcpy(pu8CurrByte, pstrStationParam->pu8Rates, pstrStationParam->u8NumRates);
 	pu8CurrByte += pstrStationParam->u8NumRates;
 
 	*pu8CurrByte++ = pstrStationParam->bIsHTSupported;
@@ -3568,7 +3568,7 @@ static u32 WILC_HostIf_PackStaParam(u8 *pu8Buffer, tstrWILC_AddStaParam *pstrSta
 	*pu8CurrByte++ = (pstrStationParam->u16HTCapInfo >> 8) & 0xFF;
 
 	*pu8CurrByte++ = pstrStationParam->u8AmpduParams;
-	WILC_memcpy(pu8CurrByte, pstrStationParam->au8SuppMCsSet, WILC_SUPP_MCS_SET_SIZE);
+	memcpy(pu8CurrByte, pstrStationParam->au8SuppMCsSet, WILC_SUPP_MCS_SET_SIZE);
 	pu8CurrByte += WILC_SUPP_MCS_SET_SIZE;
 
 	*pu8CurrByte++ = pstrStationParam->u16HTExtParams & 0xFF;
@@ -3668,7 +3668,7 @@ static void Handle_DelAllSta(void *drvHandler, tstrHostIFDelAllSta *pstrDelAllSt
 
 	for (i = 0; i < MAX_NUM_STA; i++) {
 		if (memcmp(pstrDelAllStaParam->au8Sta_DelAllSta[i], au8Zero_Buff, ETH_ALEN))
-			WILC_memcpy(pu8CurrByte, pstrDelAllStaParam->au8Sta_DelAllSta[i], ETH_ALEN);
+			memcpy(pu8CurrByte, pstrDelAllStaParam->au8Sta_DelAllSta[i], ETH_ALEN);
 		else
 			continue;
 
@@ -3720,7 +3720,7 @@ static void Handle_DelStation(void *drvHandler, tstrHostIFDelSta *pstrDelStaPara
 
 	pu8CurrByte = strWID.ps8WidVal;
 
-	WILC_memcpy(pu8CurrByte, pstrDelStaParam->au8MacAddr, ETH_ALEN);
+	memcpy(pu8CurrByte, pstrDelStaParam->au8MacAddr, ETH_ALEN);
 
 	/*Sending Cfg*/
 	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false, (u32)pstrWFIDrv);
@@ -3890,7 +3890,7 @@ static int Handle_RegisterFrame(void *drvHandler, tstrHostIfRegisterFrame *pstrH
 
 	*pu8CurrByte++ = pstrHostIfRegisterFrame->bReg;
 	*pu8CurrByte++ = pstrHostIfRegisterFrame->u8Regid;
-	WILC_memcpy(pu8CurrByte, &(pstrHostIfRegisterFrame->u16FrameType), sizeof(u16));
+	memcpy(pu8CurrByte, &(pstrHostIfRegisterFrame->u16FrameType), sizeof(u16));
 
 
 	strWID.s32ValueSize = sizeof(u16) + 2;
@@ -4133,7 +4133,7 @@ static s32 Handle_AddBASession(void *drvHandler, tstrHostIfBASessionInfo *strHos
 	*ptr++ = 0x14;
 	*ptr++ = 0x3;
 	*ptr++ = 0x0;
-	WILC_memcpy(ptr, strHostIfBASessionInfo->au8Bssid, ETH_ALEN);
+	memcpy(ptr, strHostIfBASessionInfo->au8Bssid, ETH_ALEN);
 	ptr += ETH_ALEN;
 	*ptr++ = strHostIfBASessionInfo->u8Ted;
 	/* BA Policy*/
@@ -4165,7 +4165,7 @@ static s32 Handle_AddBASession(void *drvHandler, tstrHostIfBASessionInfo *strHos
 	*ptr++ = 15;
 	*ptr++ = 7;
 	*ptr++ = 0x2;
-	WILC_memcpy(ptr, strHostIfBASessionInfo->au8Bssid, ETH_ALEN);
+	memcpy(ptr, strHostIfBASessionInfo->au8Bssid, ETH_ALEN);
 	ptr += ETH_ALEN;
 	/* TID*/
 	*ptr++ = strHostIfBASessionInfo->u8Ted;
@@ -4218,7 +4218,7 @@ static s32 Handle_DelBASession(void *drvHandler, tstrHostIfBASessionInfo *strHos
 	*ptr++ = 0x14;
 	*ptr++ = 0x3;
 	*ptr++ = 0x2;
-	WILC_memcpy(ptr, strHostIfBASessionInfo->au8Bssid, ETH_ALEN);
+	memcpy(ptr, strHostIfBASessionInfo->au8Bssid, ETH_ALEN);
 	ptr += ETH_ALEN;
 	*ptr++ = strHostIfBASessionInfo->u8Ted;
 	/* BA direction = recipent*/
@@ -4239,7 +4239,7 @@ static s32 Handle_DelBASession(void *drvHandler, tstrHostIfBASessionInfo *strHos
 	*ptr++ = 15;
 	*ptr++ = 7;
 	*ptr++ = 0x3;
-	WILC_memcpy(ptr, strHostIfBASessionInfo->au8Bssid, ETH_ALEN);
+	memcpy(ptr, strHostIfBASessionInfo->au8Bssid, ETH_ALEN);
 	ptr += ETH_ALEN;
 	/* TID*/
 	*ptr++ = strHostIfBASessionInfo->u8Ted;
@@ -4287,7 +4287,7 @@ static s32 Handle_DelAllRxBASessions(void *drvHandler, tstrHostIfBASessionInfo *
 	*ptr++ = 0x14;
 	*ptr++ = 0x3;
 	*ptr++ = 0x2;
-	WILC_memcpy(ptr, strHostIfBASessionInfo->au8Bssid, ETH_ALEN);
+	memcpy(ptr, strHostIfBASessionInfo->au8Bssid, ETH_ALEN);
 	ptr += ETH_ALEN;
 	*ptr++ = strHostIfBASessionInfo->u8Ted;
 	/* BA direction = recipent*/
@@ -4740,7 +4740,7 @@ s32 host_int_add_wep_key_bss_sta(WILC_WFIDrvHandle hWFIDrv, const u8 *pu8WepKey,
 	strHostIFmsg.uniHostIFmsgBody.strHostIFkeyAttr.
 	uniHostIFkeyAttr.strHostIFwepAttr.pu8WepKey = (u8 *)WILC_MALLOC(u8WepKeylen);
 
-	WILC_memcpy(strHostIFmsg.uniHostIFmsgBody.strHostIFkeyAttr.uniHostIFkeyAttr.strHostIFwepAttr.pu8WepKey,
+	memcpy(strHostIFmsg.uniHostIFmsgBody.strHostIFkeyAttr.uniHostIFkeyAttr.strHostIFwepAttr.pu8WepKey,
 		    pu8WepKey, u8WepKeylen);
 
 
@@ -4810,7 +4810,7 @@ s32 host_int_add_wep_key_bss_ap(WILC_WFIDrvHandle hWFIDrv, const u8 *pu8WepKey,
 	uniHostIFkeyAttr.strHostIFwepAttr.pu8WepKey = (u8 *)WILC_MALLOC((u8WepKeylen));
 
 
-	WILC_memcpy(strHostIFmsg.uniHostIFmsgBody.strHostIFkeyAttr.uniHostIFkeyAttr.strHostIFwepAttr.pu8WepKey,
+	memcpy(strHostIFmsg.uniHostIFmsgBody.strHostIFkeyAttr.uniHostIFkeyAttr.strHostIFwepAttr.pu8WepKey,
 		    pu8WepKey, (u8WepKeylen));
 
 
@@ -4893,12 +4893,12 @@ s32 host_int_add_ptk(WILC_WFIDrvHandle hWFIDrv, const u8 *pu8Ptk, u8 u8PtkKeylen
 	uniHostIFkeyAttr.strHostIFwpaAttr.pu8key = (u8 *)WILC_MALLOC(u8PtkKeylen);
 
 
-	WILC_memcpy(strHostIFmsg.uniHostIFmsgBody.strHostIFkeyAttr.uniHostIFkeyAttr.strHostIFwpaAttr.pu8key,
+	memcpy(strHostIFmsg.uniHostIFmsgBody.strHostIFkeyAttr.uniHostIFkeyAttr.strHostIFwpaAttr.pu8key,
 		    pu8Ptk, u8PtkKeylen);
 
 	if (pu8RxMic != NULL) {
 
-		WILC_memcpy(strHostIFmsg.uniHostIFmsgBody.strHostIFkeyAttr.uniHostIFkeyAttr.strHostIFwpaAttr.pu8key + 16,
+		memcpy(strHostIFmsg.uniHostIFmsgBody.strHostIFkeyAttr.uniHostIFkeyAttr.strHostIFwpaAttr.pu8key + 16,
 			    pu8RxMic, RX_MIC_KEY_LEN);
 		if (INFO) {
 			for (i = 0; i < RX_MIC_KEY_LEN; i++)
@@ -4907,7 +4907,7 @@ s32 host_int_add_ptk(WILC_WFIDrvHandle hWFIDrv, const u8 *pu8Ptk, u8 u8PtkKeylen
 	}
 	if (pu8TxMic != NULL) {
 
-		WILC_memcpy(strHostIFmsg.uniHostIFmsgBody.strHostIFkeyAttr.uniHostIFkeyAttr.strHostIFwpaAttr.pu8key + 24,
+		memcpy(strHostIFmsg.uniHostIFmsgBody.strHostIFkeyAttr.uniHostIFkeyAttr.strHostIFwpaAttr.pu8key + 24,
 			    pu8TxMic, TX_MIC_KEY_LEN);
 		if (INFO) {
 			for (i = 0; i < TX_MIC_KEY_LEN; i++)
@@ -4979,7 +4979,7 @@ s32 host_int_add_rx_gtk(WILC_WFIDrvHandle hWFIDrv, const u8 *pu8RxGtk, u8 u8GtkK
 		strHostIFmsg.uniHostIFmsgBody.strHostIFkeyAttr.
 		uniHostIFkeyAttr.strHostIFwpaAttr.pu8seq = (u8 *)WILC_MALLOC(u32KeyRSClen);
 
-		WILC_memcpy(strHostIFmsg.uniHostIFmsgBody.strHostIFkeyAttr.uniHostIFkeyAttr.strHostIFwpaAttr.pu8seq,
+		memcpy(strHostIFmsg.uniHostIFmsgBody.strHostIFkeyAttr.uniHostIFkeyAttr.strHostIFwpaAttr.pu8seq,
 			    KeyRSC, u32KeyRSClen);
 	}
 
@@ -5001,18 +5001,18 @@ s32 host_int_add_rx_gtk(WILC_WFIDrvHandle hWFIDrv, const u8 *pu8RxGtk, u8 u8GtkK
 	strHostIFmsg.uniHostIFmsgBody.strHostIFkeyAttr.
 	uniHostIFkeyAttr.strHostIFwpaAttr.pu8key = (u8 *)WILC_MALLOC(u8KeyLen);
 
-	WILC_memcpy(strHostIFmsg.uniHostIFmsgBody.strHostIFkeyAttr.uniHostIFkeyAttr.strHostIFwpaAttr.pu8key,
+	memcpy(strHostIFmsg.uniHostIFmsgBody.strHostIFkeyAttr.uniHostIFkeyAttr.strHostIFwpaAttr.pu8key,
 		    pu8RxGtk, u8GtkKeylen);
 
 	if (pu8RxMic != NULL) {
 
-		WILC_memcpy(strHostIFmsg.uniHostIFmsgBody.strHostIFkeyAttr.uniHostIFkeyAttr.strHostIFwpaAttr.pu8key + 16,
+		memcpy(strHostIFmsg.uniHostIFmsgBody.strHostIFkeyAttr.uniHostIFkeyAttr.strHostIFwpaAttr.pu8key + 16,
 			    pu8RxMic, RX_MIC_KEY_LEN);
 
 	}
 	if (pu8TxMic != NULL) {
 
-		WILC_memcpy(strHostIFmsg.uniHostIFmsgBody.strHostIFkeyAttr.uniHostIFkeyAttr.strHostIFwpaAttr.pu8key + 24,
+		memcpy(strHostIFmsg.uniHostIFmsgBody.strHostIFkeyAttr.uniHostIFkeyAttr.strHostIFwpaAttr.pu8key + 24,
 			    pu8TxMic, TX_MIC_KEY_LEN);
 
 	}
@@ -5084,10 +5084,10 @@ s32 host_int_set_pmkid_info(WILC_WFIDrvHandle hWFIDrv, tstrHostIFpmkidAttr *pu8P
 
 	for (i = 0; i < pu8PmkidInfoArray->numpmkid; i++) {
 
-		WILC_memcpy(strHostIFmsg.uniHostIFmsgBody.strHostIFkeyAttr.uniHostIFkeyAttr.strHostIFpmkidAttr.pmkidlist[i].bssid, &pu8PmkidInfoArray->pmkidlist[i].bssid,
+		memcpy(strHostIFmsg.uniHostIFmsgBody.strHostIFkeyAttr.uniHostIFkeyAttr.strHostIFpmkidAttr.pmkidlist[i].bssid, &pu8PmkidInfoArray->pmkidlist[i].bssid,
 			    ETH_ALEN);
 
-		WILC_memcpy(strHostIFmsg.uniHostIFmsgBody.strHostIFkeyAttr.uniHostIFkeyAttr.strHostIFpmkidAttr.pmkidlist[i].pmkid, &pu8PmkidInfoArray->pmkidlist[i].pmkid,
+		memcpy(strHostIFmsg.uniHostIFmsgBody.strHostIFkeyAttr.uniHostIFkeyAttr.strHostIFpmkidAttr.pmkidlist[i].pmkid, &pu8PmkidInfoArray->pmkidlist[i].pmkid,
 			    PMKID_LEN);
 	}
 
@@ -5225,7 +5225,7 @@ s32 host_int_set_MacAddress(WILC_WFIDrvHandle hWFIDrv, u8 *pu8MacAddress)
 	/* prepare setting mac address message */
 	memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
 	strHostIFmsg.u16MsgId = HOST_IF_MSG_SET_MAC_ADDRESS;
-	WILC_memcpy(strHostIFmsg.uniHostIFmsgBody.strHostIfSetMacAddress.u8MacAddress, pu8MacAddress, ETH_ALEN);
+	memcpy(strHostIFmsg.uniHostIFmsgBody.strHostIfSetMacAddress.u8MacAddress, pu8MacAddress, ETH_ALEN);
 	strHostIFmsg.drvHandler = hWFIDrv;
 
 	s32Error = WILC_MsgQueueSend(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg), NULL);
@@ -5456,14 +5456,14 @@ s32 host_int_set_join_req(WILC_WFIDrvHandle hWFIDrv, u8 *pu8bssid,
 
 	if (pu8bssid != NULL) {
 		strHostIFmsg.uniHostIFmsgBody.strHostIFconnectAttr.pu8bssid = (u8 *)WILC_MALLOC(6); /* will be deallocated by the receiving thread */
-		WILC_memcpy(strHostIFmsg.uniHostIFmsgBody.strHostIFconnectAttr.pu8bssid,
+		memcpy(strHostIFmsg.uniHostIFmsgBody.strHostIFconnectAttr.pu8bssid,
 			    pu8bssid, 6);
 	}
 
 	if (pu8ssid != NULL) {
 		strHostIFmsg.uniHostIFmsgBody.strHostIFconnectAttr.ssidLen = ssidLen;
 		strHostIFmsg.uniHostIFmsgBody.strHostIFconnectAttr.pu8ssid = (u8 *)WILC_MALLOC(ssidLen); /* will be deallocated by the receiving thread */
-		WILC_memcpy(strHostIFmsg.uniHostIFmsgBody.strHostIFconnectAttr.pu8ssid,
+		memcpy(strHostIFmsg.uniHostIFmsgBody.strHostIFconnectAttr.pu8ssid,
 
 			    pu8ssid, ssidLen);
 	}
@@ -5471,7 +5471,7 @@ s32 host_int_set_join_req(WILC_WFIDrvHandle hWFIDrv, u8 *pu8bssid,
 	if (pu8IEs != NULL) {
 		strHostIFmsg.uniHostIFmsgBody.strHostIFconnectAttr.IEsLen = IEsLen;
 		strHostIFmsg.uniHostIFmsgBody.strHostIFconnectAttr.pu8IEs = (u8 *)WILC_MALLOC(IEsLen); /* will be deallocated by the receiving thread */
-		WILC_memcpy(strHostIFmsg.uniHostIFmsgBody.strHostIFconnectAttr.pu8IEs,
+		memcpy(strHostIFmsg.uniHostIFmsgBody.strHostIFconnectAttr.pu8IEs,
 			    pu8IEs, IEsLen);
 	}
 	if (pstrWFIDrv->enuHostIFstate < HOST_IF_CONNECTING)
@@ -5975,7 +5975,7 @@ s32 host_int_get_inactive_time(WILC_WFIDrvHandle hWFIDrv, const u8 *mac, u32 *pu
 	memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
 
 
-	WILC_memcpy(strHostIFmsg.uniHostIFmsgBody.strHostIfStaInactiveT.mac,
+	memcpy(strHostIFmsg.uniHostIFmsgBody.strHostIfStaInactiveT.mac,
 		    mac, ETH_ALEN);
 
 	strHostIFmsg.u16MsgId = HOST_IF_MSG_GET_INACTIVETIME;
@@ -6203,12 +6203,12 @@ s32 host_int_scan(WILC_WFIDrvHandle hWFIDrv, u8 u8ScanSource,
 
 	strHostIFmsg.uniHostIFmsgBody.strHostIFscanAttr.u8ChnlListLen = u8ChnlListLen;
 	strHostIFmsg.uniHostIFmsgBody.strHostIFscanAttr.pu8ChnlFreqList = (u8 *)WILC_MALLOC(u8ChnlListLen);        /* will be deallocated by the receiving thread */
-	WILC_memcpy(strHostIFmsg.uniHostIFmsgBody.strHostIFscanAttr.pu8ChnlFreqList,
+	memcpy(strHostIFmsg.uniHostIFmsgBody.strHostIFscanAttr.pu8ChnlFreqList,
 		    pu8ChnlFreqList, u8ChnlListLen);
 
 	strHostIFmsg.uniHostIFmsgBody.strHostIFscanAttr.IEsLen = IEsLen;
 	strHostIFmsg.uniHostIFmsgBody.strHostIFscanAttr.pu8IEs = (u8 *)WILC_MALLOC(IEsLen);        /* will be deallocated by the receiving thread */
-	WILC_memcpy(strHostIFmsg.uniHostIFmsgBody.strHostIFscanAttr.pu8IEs,
+	memcpy(strHostIFmsg.uniHostIFmsgBody.strHostIFscanAttr.pu8IEs,
 		    pu8IEs, IEsLen);
 
 	/* send the message */
@@ -6792,7 +6792,7 @@ void NetworkInfoReceived(u8 *pu8Buffer, u32 u32Length)
 
 	strHostIFmsg.uniHostIFmsgBody.strRcvdNetworkInfo.u32Length = u32Length;
 	strHostIFmsg.uniHostIFmsgBody.strRcvdNetworkInfo.pu8Buffer = (u8 *)WILC_MALLOC(u32Length); /* will be deallocated by the receiving thread */
-	WILC_memcpy(strHostIFmsg.uniHostIFmsgBody.strRcvdNetworkInfo.pu8Buffer,
+	memcpy(strHostIFmsg.uniHostIFmsgBody.strRcvdNetworkInfo.pu8Buffer,
 		    pu8Buffer, u32Length);
 
 	/* send the message */
@@ -6855,7 +6855,7 @@ void GnrlAsyncInfoReceived(u8 *pu8Buffer, u32 u32Length)
 
 	strHostIFmsg.uniHostIFmsgBody.strRcvdGnrlAsyncInfo.u32Length = u32Length;
 	strHostIFmsg.uniHostIFmsgBody.strRcvdGnrlAsyncInfo.pu8Buffer = (u8 *)WILC_MALLOC(u32Length); /* will be deallocated by the receiving thread */
-	WILC_memcpy(strHostIFmsg.uniHostIFmsgBody.strRcvdGnrlAsyncInfo.pu8Buffer,
+	memcpy(strHostIFmsg.uniHostIFmsgBody.strRcvdGnrlAsyncInfo.pu8Buffer,
 		    pu8Buffer, u32Length);
 
 	/* send the message */
@@ -6907,7 +6907,7 @@ void host_int_ScanCompleteReceived(u8 *pu8Buffer, u32 u32Length)
 
 		/*strHostIFmsg.uniHostIFmsgBody.strScanComplete.u32Length = u32Length;
 		 * strHostIFmsg.uniHostIFmsgBody.strScanComplete.pu8Buffer  = (u8*)WILC_MALLOC(u32Length);
-		 * WILC_memcpy(strHostIFmsg.uniHostIFmsgBody.strScanComplete.pu8Buffer,
+		 * memcpy(strHostIFmsg.uniHostIFmsgBody.strScanComplete.pu8Buffer,
 		 *                        pu8Buffer, u32Length); */
 
 		/* send the message */
@@ -7104,7 +7104,7 @@ s32 host_int_add_beacon(WILC_WFIDrvHandle hWFIDrv, u32 u32Interval,
 	pstrSetBeaconParam->pu8Head = (u8 *)WILC_MALLOC(u32HeadLen);
 	if (pstrSetBeaconParam->pu8Head == NULL)
 		WILC_ERRORREPORT(s32Error, WILC_NO_MEM);
-	WILC_memcpy(pstrSetBeaconParam->pu8Head, pu8Head, u32HeadLen);
+	memcpy(pstrSetBeaconParam->pu8Head, pu8Head, u32HeadLen);
 	pstrSetBeaconParam->u32TailLen = u32TailLen;
 
 	/* Bug 4599 : if tail length = 0 skip allocating & copying */
@@ -7112,7 +7112,7 @@ s32 host_int_add_beacon(WILC_WFIDrvHandle hWFIDrv, u32 u32Interval,
 		pstrSetBeaconParam->pu8Tail = (u8 *)WILC_MALLOC(u32TailLen);
 		if (pstrSetBeaconParam->pu8Tail == NULL)
 			WILC_ERRORREPORT(s32Error, WILC_NO_MEM);
-		WILC_memcpy(pstrSetBeaconParam->pu8Tail, pu8Tail, u32TailLen);
+		memcpy(pstrSetBeaconParam->pu8Tail, pu8Tail, u32TailLen);
 	} else {
 		pstrSetBeaconParam->pu8Tail = NULL;
 	}
@@ -7197,13 +7197,13 @@ s32 host_int_add_station(WILC_WFIDrvHandle hWFIDrv, tstrWILC_AddStaParam *pstrSt
 	strHostIFmsg.u16MsgId = HOST_IF_MSG_ADD_STATION;
 	strHostIFmsg.drvHandler = hWFIDrv;
 
-	WILC_memcpy(pstrAddStationMsg, pstrStaParams, sizeof(tstrWILC_AddStaParam));
+	memcpy(pstrAddStationMsg, pstrStaParams, sizeof(tstrWILC_AddStaParam));
 	if (pstrAddStationMsg->u8NumRates > 0) {
 		u8 *rates = WILC_MALLOC(pstrAddStationMsg->u8NumRates);
 
 		WILC_NULLCHECK(s32Error, rates);
 
-		WILC_memcpy(rates, pstrStaParams->pu8Rates, pstrAddStationMsg->u8NumRates);
+		memcpy(rates, pstrStaParams->pu8Rates, pstrAddStationMsg->u8NumRates);
 		pstrAddStationMsg->pu8Rates = rates;
 	}
 
@@ -7251,7 +7251,7 @@ s32 host_int_del_station(WILC_WFIDrvHandle hWFIDrv, const u8 *pu8MacAddr)
 	if (pu8MacAddr == NULL)
 		memset(pstrDelStationMsg->au8MacAddr, 255, ETH_ALEN);
 	else
-		WILC_memcpy(pstrDelStationMsg->au8MacAddr, pu8MacAddr, ETH_ALEN);
+		memcpy(pstrDelStationMsg->au8MacAddr, pu8MacAddr, ETH_ALEN);
 
 	s32Error = WILC_MsgQueueSend(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg), NULL);
 	if (s32Error)
@@ -7296,7 +7296,7 @@ s32 host_int_del_allstation(WILC_WFIDrvHandle hWFIDrv, u8 pu8MacAddr[][ETH_ALEN]
 	/* Handling situation of deauthenticing all associated stations*/
 	for (i = 0; i < MAX_NUM_STA; i++) {
 		if (memcmp(pu8MacAddr[i], au8Zero_Buff, ETH_ALEN)) {
-			WILC_memcpy(pstrDelAllStationMsg->au8Sta_DelAllSta[i], pu8MacAddr[i], ETH_ALEN);
+			memcpy(pstrDelAllStationMsg->au8Sta_DelAllSta[i], pu8MacAddr[i], ETH_ALEN);
 			PRINT_D(CFG80211_DBG, "BSSID = %x%x%x%x%x%x\n", pstrDelAllStationMsg->au8Sta_DelAllSta[i][0], pstrDelAllStationMsg->au8Sta_DelAllSta[i][1], pstrDelAllStationMsg->au8Sta_DelAllSta[i][2], pstrDelAllStationMsg->au8Sta_DelAllSta[i][3], pstrDelAllStationMsg->au8Sta_DelAllSta[i][4],
 				pstrDelAllStationMsg->au8Sta_DelAllSta[i][5]);
 			u8AssocNumb++;
@@ -7352,12 +7352,12 @@ s32 host_int_edit_station(WILC_WFIDrvHandle hWFIDrv, tstrWILC_AddStaParam *pstrS
 	strHostIFmsg.u16MsgId = HOST_IF_MSG_EDIT_STATION;
 	strHostIFmsg.drvHandler = hWFIDrv;
 
-	WILC_memcpy(pstrAddStationMsg, pstrStaParams, sizeof(tstrWILC_AddStaParam));
+	memcpy(pstrAddStationMsg, pstrStaParams, sizeof(tstrWILC_AddStaParam));
 	if (pstrAddStationMsg->u8NumRates > 0) {
 		u8 *rates = WILC_MALLOC(pstrAddStationMsg->u8NumRates);
 
 		WILC_NULLCHECK(s32Error, rates);
-		WILC_memcpy(rates, pstrStaParams->pu8Rates, pstrAddStationMsg->u8NumRates);
+		memcpy(rates, pstrStaParams->pu8Rates, pstrAddStationMsg->u8NumRates);
 		pstrAddStationMsg->pu8Rates = rates;
 	}
 
@@ -7477,10 +7477,10 @@ static void *host_int_ParseJoinBssParam(tstrNetworkInfo *ptstrNetworkInfo)
 		pNewJoinBssParam->dtim_period = ptstrNetworkInfo->u8DtimPeriod;
 		pNewJoinBssParam->beacon_period = ptstrNetworkInfo->u16BeaconPeriod;
 		pNewJoinBssParam->cap_info = ptstrNetworkInfo->u16CapInfo;
-		WILC_memcpy(pNewJoinBssParam->au8bssid, ptstrNetworkInfo->au8bssid, 6);
+		memcpy(pNewJoinBssParam->au8bssid, ptstrNetworkInfo->au8bssid, 6);
 		/*for(i=0; i<6;i++)
 		 *      PRINT_D(HOSTINF_DBG,"%c",pNewJoinBssParam->au8bssid[i]);*/
-		WILC_memcpy((u8 *)pNewJoinBssParam->ssid, ptstrNetworkInfo->au8ssid, ptstrNetworkInfo->u8SsidLen + 1);
+		memcpy((u8 *)pNewJoinBssParam->ssid, ptstrNetworkInfo->au8ssid, ptstrNetworkInfo->u8SsidLen + 1);
 		pNewJoinBssParam->ssidLen = ptstrNetworkInfo->u8SsidLen;
 		memset(pNewJoinBssParam->rsn_pcip_policy, 0xFF, 3);
 		memset(pNewJoinBssParam->rsn_auth_policy, 0xFF, 3);
@@ -7568,13 +7568,13 @@ static void *host_int_ParseJoinBssParam(tstrNetworkInfo *ptstrNetworkInfo)
 				pNewJoinBssParam->u8Count = pu8IEs[index + 11];
 				u16P2P_count = index + 12;
 
-				WILC_memcpy(pNewJoinBssParam->au8Duration, pu8IEs + u16P2P_count, 4);
+				memcpy(pNewJoinBssParam->au8Duration, pu8IEs + u16P2P_count, 4);
 				u16P2P_count += 4;
 
-				WILC_memcpy(pNewJoinBssParam->au8Interval, pu8IEs + u16P2P_count, 4);
+				memcpy(pNewJoinBssParam->au8Interval, pu8IEs + u16P2P_count, 4);
 				u16P2P_count += 4;
 
-				WILC_memcpy(pNewJoinBssParam->au8StartTime, pu8IEs + u16P2P_count, 4);
+				memcpy(pNewJoinBssParam->au8StartTime, pu8IEs + u16P2P_count, 4);
 
 				index += pu8IEs[index + 1] + 2;
 				continue;
diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 1384846..4b5e5b2 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -2105,7 +2105,7 @@ static void wilc_set_multicast_list(struct net_device *dev)
 	/* Store all of the multicast addresses in the hardware filter */
 	netdev_for_each_mc_addr(ha, dev)
 	{
-		WILC_memcpy(gau8MulticastMacAddrList[i], ha->addr, ETH_ALEN);
+		memcpy(gau8MulticastMacAddrList[i], ha->addr, ETH_ALEN);
 		PRINT_D(INIT_DBG, "Entry[%d]: %x:%x:%x:%x:%x:%x\n", i,
 			gau8MulticastMacAddrList[i][0], gau8MulticastMacAddrList[i][1], gau8MulticastMacAddrList[i][2], gau8MulticastMacAddrList[i][3], gau8MulticastMacAddrList[i][4], gau8MulticastMacAddrList[i][5]);
 		i++;
diff --git a/drivers/staging/wilc1000/wilc_msgqueue.c b/drivers/staging/wilc1000/wilc_msgqueue.c
index 16bcef4..2b08352 100644
--- a/drivers/staging/wilc1000/wilc_msgqueue.c
+++ b/drivers/staging/wilc1000/wilc_msgqueue.c
@@ -77,7 +77,7 @@ WILC_ErrNo WILC_MsgQueueSend(WILC_MsgQueueHandle *pHandle,
 	pstrMessage->pstrNext = NULL;
 	pstrMessage->pvBuffer = WILC_MALLOC(u32SendBufferSize);
 	WILC_NULLCHECK(s32RetStatus, pstrMessage->pvBuffer);
-	WILC_memcpy(pstrMessage->pvBuffer, pvSendBuffer, u32SendBufferSize);
+	memcpy(pstrMessage->pvBuffer, pvSendBuffer, u32SendBufferSize);
 
 
 	/* add it to the message queue */
@@ -170,7 +170,7 @@ WILC_ErrNo WILC_MsgQueueRecv(WILC_MsgQueueHandle *pHandle,
 
 		/* consume the message */
 		pHandle->u32ReceiversCount--;
-		WILC_memcpy(pvRecvBuffer, pstrMessage->pvBuffer, pstrMessage->u32Length);
+		memcpy(pvRecvBuffer, pstrMessage->pvBuffer, pstrMessage->u32Length);
 		*pu32ReceivedLength = pstrMessage->u32Length;
 
 		pHandle->pstrMessageList = pstrMessage->pstrNext;
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 9e589a0..99d859d 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -321,10 +321,10 @@ void add_network_to_shadow(tstrNetworkInfo *pstrNetworkInfo, void *pUserVoid, vo
 	astrLastScannedNtwrksShadow[ap_index].u16CapInfo = pstrNetworkInfo->u16CapInfo;
 
 	astrLastScannedNtwrksShadow[ap_index].u8SsidLen = pstrNetworkInfo->u8SsidLen;
-	WILC_memcpy(astrLastScannedNtwrksShadow[ap_index].au8ssid,
+	memcpy(astrLastScannedNtwrksShadow[ap_index].au8ssid,
 		    pstrNetworkInfo->au8ssid, pstrNetworkInfo->u8SsidLen);
 
-	WILC_memcpy(astrLastScannedNtwrksShadow[ap_index].au8bssid,
+	memcpy(astrLastScannedNtwrksShadow[ap_index].au8bssid,
 		    pstrNetworkInfo->au8bssid, ETH_ALEN);
 
 	astrLastScannedNtwrksShadow[ap_index].u16BeaconPeriod = pstrNetworkInfo->u16BeaconPeriod;
@@ -337,7 +337,7 @@ void add_network_to_shadow(tstrNetworkInfo *pstrNetworkInfo, void *pUserVoid, vo
 		WILC_FREE(astrLastScannedNtwrksShadow[ap_index].pu8IEs);
 	astrLastScannedNtwrksShadow[ap_index].pu8IEs =
 		(u8 *)WILC_MALLOC(pstrNetworkInfo->u16IEsLen);        /* will be deallocated by the WILC_WFI_CfgScan() function */
-	WILC_memcpy(astrLastScannedNtwrksShadow[ap_index].pu8IEs,
+	memcpy(astrLastScannedNtwrksShadow[ap_index].pu8IEs,
 		    pstrNetworkInfo->pu8IEs, pstrNetworkInfo->u16IEsLen);
 
 	astrLastScannedNtwrksShadow[ap_index].u32TimeRcvdInScan = jiffies;
@@ -590,7 +590,7 @@ static void CfgConnectResult(tenuConnDisconnEvent enuConnDisconnEvent,
 
 			PRINT_INFO(CFG80211_DBG, "Connection Successful:: BSSID: %x%x%x%x%x%x\n", pstrConnectInfo->au8bssid[0],
 				   pstrConnectInfo->au8bssid[1], pstrConnectInfo->au8bssid[2], pstrConnectInfo->au8bssid[3], pstrConnectInfo->au8bssid[4], pstrConnectInfo->au8bssid[5]);
-			WILC_memcpy(priv->au8AssociatedBss, pstrConnectInfo->au8bssid, ETH_ALEN);
+			memcpy(priv->au8AssociatedBss, pstrConnectInfo->au8bssid, ETH_ALEN);
 
 			/* BugID_4209: if this network has expired in the scan results in the above nl80211 layer, refresh them here by calling
 			 *  cfg80211_inform_bss() with the last Scan results before calling cfg80211_connect_result() to avoid
@@ -764,7 +764,7 @@ static int WILC_WFI_CfgScan(struct wiphy *wiphy, struct cfg80211_scan_request *r
 
 				if (request->ssids[i].ssid != NULL && request->ssids[i].ssid_len != 0) {
 					strHiddenNetwork.pstrHiddenNetworkInfo[i].pu8ssid = WILC_MALLOC(request->ssids[i].ssid_len);
-					WILC_memcpy(strHiddenNetwork.pstrHiddenNetworkInfo[i].pu8ssid, request->ssids[i].ssid, request->ssids[i].ssid_len);
+					memcpy(strHiddenNetwork.pstrHiddenNetworkInfo[i].pu8ssid, request->ssids[i].ssid, request->ssids[i].ssid_len);
 					strHiddenNetwork.pstrHiddenNetworkInfo[i].u8ssidlen = request->ssids[i].ssid_len;
 				} else {
 					PRINT_D(CFG80211_DBG, "Received one NULL SSID\n");
@@ -915,7 +915,7 @@ static int WILC_WFI_CfgConnect(struct wiphy *wiphy, struct net_device *dev,
 			}
 			priv->WILC_WFI_wep_default = sme->key_idx;
 			priv->WILC_WFI_wep_key_len[sme->key_idx] = sme->key_len;
-			WILC_memcpy(priv->WILC_WFI_wep_key[sme->key_idx], sme->key, sme->key_len);
+			memcpy(priv->WILC_WFI_wep_key[sme->key_idx], sme->key, sme->key_len);
 
 			/*BugID_5137*/
 			g_key_wep_params.key_len = sme->key_len;
@@ -933,7 +933,7 @@ static int WILC_WFI_CfgConnect(struct wiphy *wiphy, struct net_device *dev,
 
 			priv->WILC_WFI_wep_default = sme->key_idx;
 			priv->WILC_WFI_wep_key_len[sme->key_idx] = sme->key_len;
-			WILC_memcpy(priv->WILC_WFI_wep_key[sme->key_idx], sme->key, sme->key_len);
+			memcpy(priv->WILC_WFI_wep_key[sme->key_idx], sme->key, sme->key_len);
 
 			/*BugID_5137*/
 			g_key_wep_params.key_len = sme->key_len;
@@ -1149,7 +1149,7 @@ static int WILC_WFI_add_key(struct wiphy *wiphy, struct net_device *netdev, u8 k
 
 			priv->WILC_WFI_wep_default = key_index;
 			priv->WILC_WFI_wep_key_len[key_index] = params->key_len;
-			WILC_memcpy(priv->WILC_WFI_wep_key[key_index], params->key, params->key_len);
+			memcpy(priv->WILC_WFI_wep_key[key_index], params->key, params->key_len);
 
 			PRINT_D(CFG80211_DBG, "Adding AP WEP Default key Idx = %d\n", key_index);
 			PRINT_D(CFG80211_DBG, "Adding AP WEP Key len= %d\n", params->key_len);
@@ -1171,7 +1171,7 @@ static int WILC_WFI_add_key(struct wiphy *wiphy, struct net_device *netdev, u8 k
 		if (memcmp(params->key, priv->WILC_WFI_wep_key[key_index], params->key_len)) {
 			priv->WILC_WFI_wep_default = key_index;
 			priv->WILC_WFI_wep_key_len[key_index] = params->key_len;
-			WILC_memcpy(priv->WILC_WFI_wep_key[key_index], params->key, params->key_len);
+			memcpy(priv->WILC_WFI_wep_key[key_index], params->key, params->key_len);
 
 			PRINT_D(CFG80211_DBG, "Adding WEP Default key Idx = %d\n", key_index);
 			PRINT_D(CFG80211_DBG, "Adding WEP Key length = %d\n", params->key_len);
@@ -1222,7 +1222,7 @@ static int WILC_WFI_add_key(struct wiphy *wiphy, struct net_device *netdev, u8 k
 					WILC_FREE(priv->wilc_gtk[key_index]->key);
 
 				priv->wilc_gtk[key_index]->key = (u8 *)WILC_MALLOC(params->key_len);
-				WILC_memcpy(priv->wilc_gtk[key_index]->key, params->key, params->key_len);
+				memcpy(priv->wilc_gtk[key_index]->key, params->key, params->key_len);
 
 				/* if there has been previous allocation for the same index through its seq, free that memory and allocate again*/
 				if (priv->wilc_gtk[key_index]->seq)
@@ -1230,7 +1230,7 @@ static int WILC_WFI_add_key(struct wiphy *wiphy, struct net_device *netdev, u8 k
 
 				if ((params->seq_len) > 0) {
 					priv->wilc_gtk[key_index]->seq = (u8 *)WILC_MALLOC(params->seq_len);
-					WILC_memcpy(priv->wilc_gtk[key_index]->seq, params->seq, params->seq_len);
+					memcpy(priv->wilc_gtk[key_index]->seq, params->seq, params->seq_len);
 				}
 
 				priv->wilc_gtk[key_index]->cipher = params->cipher;
@@ -1283,10 +1283,10 @@ static int WILC_WFI_add_key(struct wiphy *wiphy, struct net_device *netdev, u8 k
 						PRINT_INFO(CFG80211_DBG, "Adding group seq value[%d] = %x\n", i, params->seq[i]);
 				}
 
-				WILC_memcpy(priv->wilc_ptk[key_index]->key, params->key, params->key_len);
+				memcpy(priv->wilc_ptk[key_index]->key, params->key, params->key_len);
 
 				if ((params->seq_len) > 0)
-					WILC_memcpy(priv->wilc_ptk[key_index]->seq, params->seq, params->seq_len);
+					memcpy(priv->wilc_ptk[key_index]->seq, params->seq, params->seq_len);
 
 				priv->wilc_ptk[key_index]->cipher = params->cipher;
 				priv->wilc_ptk[key_index]->key_len = params->key_len;
@@ -1902,9 +1902,9 @@ static int WILC_WFI_set_pmksa(struct wiphy *wiphy, struct net_device *netdev,
 	}
 	if (i < WILC_MAX_NUM_PMKIDS) {
 		PRINT_D(CFG80211_DBG, "Setting PMKID in private structure\n");
-		WILC_memcpy(priv->pmkid_list.pmkidlist[i].bssid, pmksa->bssid,
+		memcpy(priv->pmkid_list.pmkidlist[i].bssid, pmksa->bssid,
 			    ETH_ALEN);
-		WILC_memcpy(priv->pmkid_list.pmkidlist[i].pmkid, pmksa->pmkid,
+		memcpy(priv->pmkid_list.pmkidlist[i].pmkid, pmksa->pmkid,
 			    PMKID_LEN);
 		if (!(flag == PMKID_FOUND))
 			priv->pmkid_list.numpmkid++;
@@ -1954,10 +1954,10 @@ static int WILC_WFI_del_pmksa(struct wiphy *wiphy, struct net_device *netdev,
 
 	if (i < priv->pmkid_list.numpmkid && priv->pmkid_list.numpmkid > 0) {
 		for (; i < (priv->pmkid_list.numpmkid - 1); i++) {
-			WILC_memcpy(priv->pmkid_list.pmkidlist[i].bssid,
+			memcpy(priv->pmkid_list.pmkidlist[i].bssid,
 				    priv->pmkid_list.pmkidlist[i + 1].bssid,
 				    ETH_ALEN);
-			WILC_memcpy(priv->pmkid_list.pmkidlist[i].pmkid,
+			memcpy(priv->pmkid_list.pmkidlist[i].pmkid,
 				    priv->pmkid_list.pmkidlist[i].pmkid,
 				    PMKID_LEN);
 		}
@@ -2199,7 +2199,7 @@ void WILC_WFI_p2p_rx (struct net_device *dev, uint8_t *buff, uint32_t size)
 	pstrWFIDrv = (tstrWILC_WFIDrv *)priv->hWILCWFIDrv;
 
 	/* Get WILC header */
-	WILC_memcpy(&header, (buff - HOST_HDR_OFFSET), HOST_HDR_OFFSET);
+	memcpy(&header, (buff - HOST_HDR_OFFSET), HOST_HDR_OFFSET);
 
 	/* The packet offset field conain info about what type of managment frame */
 	/* we are dealing with and ack status */
@@ -2466,7 +2466,7 @@ static int   WILC_WFI_cancel_remain_on_channel(struct wiphy *wiphy,
  */
 void WILC_WFI_add_wilcvendorspec(u8 *buff)
 {
-	WILC_memcpy(buff, u8P2P_vendorspec, sizeof(u8P2P_vendorspec));
+	memcpy(buff, u8P2P_vendorspec, sizeof(u8P2P_vendorspec));
 }
 /**
  *  @brief      WILC_WFI_mgmt_tx_frame
@@ -2519,7 +2519,7 @@ int WILC_WFI_mgmt_tx(struct wiphy *wiphy,
 			PRINT_ER("Failed to allocate memory for mgmt_tx buff\n");
 			return WILC_FAIL;
 		}
-		WILC_memcpy(mgmt_tx->buff, buf, len);
+		memcpy(mgmt_tx->buff, buf, len);
 		mgmt_tx->size = len;
 
 
@@ -3338,8 +3338,8 @@ static int  WILC_WFI_add_station(struct wiphy *wiphy, struct net_device *dev,
 	if (nic->iftype == AP_MODE || nic->iftype == GO_MODE) {
 		#ifndef WILC_FULLY_HOSTING_AP
 
-		WILC_memcpy(strStaParams.au8BSSID, mac, ETH_ALEN);
-		WILC_memcpy(priv->assoc_stainfo.au8Sta_AssociatedBss[params->aid], mac, ETH_ALEN);
+		memcpy(strStaParams.au8BSSID, mac, ETH_ALEN);
+		memcpy(priv->assoc_stainfo.au8Sta_AssociatedBss[params->aid], mac, ETH_ALEN);
 		strStaParams.u16AssocID = params->aid;
 		strStaParams.u8NumRates = params->supported_rates_len;
 		strStaParams.pu8Rates = params->supported_rates;
@@ -3357,7 +3357,7 @@ static int  WILC_WFI_add_station(struct wiphy *wiphy, struct net_device *dev,
 			strStaParams.bIsHTSupported = true;
 			strStaParams.u16HTCapInfo = params->ht_capa->cap_info;
 			strStaParams.u8AmpduParams = params->ht_capa->ampdu_params_info;
-			WILC_memcpy(strStaParams.au8SuppMCsSet, &params->ht_capa->mcs, WILC_SUPP_MCS_SET_SIZE);
+			memcpy(strStaParams.au8SuppMCsSet, &params->ht_capa->mcs, WILC_SUPP_MCS_SET_SIZE);
 			strStaParams.u16HTExtParams = params->ht_capa->extended_ht_cap_info;
 			strStaParams.u32TxBeamformingCap = params->ht_capa->tx_BF_cap_info;
 			strStaParams.u8ASELCap = params->ht_capa->antenna_selection_info;
@@ -3380,7 +3380,7 @@ static int  WILC_WFI_add_station(struct wiphy *wiphy, struct net_device *dev,
 
 		#else
 		PRINT_D(CFG80211_DBG, "Adding station parameters %d\n", params->aid);
-		WILC_memcpy(priv->assoc_stainfo.au8Sta_AssociatedBss[params->aid], mac, ETH_ALEN);
+		memcpy(priv->assoc_stainfo.au8Sta_AssociatedBss[params->aid], mac, ETH_ALEN);
 
 		PRINT_D(CFG80211_DBG, "BSSID = %x%x%x%x%x%x\n", priv->assoc_stainfo.au8Sta_AssociatedBss[params->aid][0], priv->assoc_stainfo.au8Sta_AssociatedBss[params->aid][1], priv->assoc_stainfo.au8Sta_AssociatedBss[params->aid][2], priv->assoc_stainfo.au8Sta_AssociatedBss[params->aid][3], priv->assoc_stainfo.au8Sta_AssociatedBss[params->aid][4],
 			priv->assoc_stainfo.au8Sta_AssociatedBss[params->aid][5]);
@@ -3471,7 +3471,7 @@ static int WILC_WFI_change_station(struct wiphy *wiphy, struct net_device *dev,
 	if (nic->iftype == AP_MODE || nic->iftype == GO_MODE) {
 		#ifndef WILC_FULLY_HOSTING_AP
 
-		WILC_memcpy(strStaParams.au8BSSID, mac, ETH_ALEN);
+		memcpy(strStaParams.au8BSSID, mac, ETH_ALEN);
 		strStaParams.u16AssocID = params->aid;
 		strStaParams.u8NumRates = params->supported_rates_len;
 		strStaParams.pu8Rates = params->supported_rates;
@@ -3487,7 +3487,7 @@ static int WILC_WFI_change_station(struct wiphy *wiphy, struct net_device *dev,
 			strStaParams.bIsHTSupported = true;
 			strStaParams.u16HTCapInfo = params->ht_capa->cap_info;
 			strStaParams.u8AmpduParams = params->ht_capa->ampdu_params_info;
-			WILC_memcpy(strStaParams.au8SuppMCsSet, &params->ht_capa->mcs, WILC_SUPP_MCS_SET_SIZE);
+			memcpy(strStaParams.au8SuppMCsSet, &params->ht_capa->mcs, WILC_SUPP_MCS_SET_SIZE);
 			strStaParams.u16HTExtParams = params->ht_capa->extended_ht_cap_info;
 			strStaParams.u32TxBeamformingCap = params->ht_capa->tx_BF_cap_info;
 			strStaParams.u8ASELCap = params->ht_capa->antenna_selection_info;
-- 
1.9.1

