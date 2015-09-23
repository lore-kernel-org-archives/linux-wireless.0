Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:18669 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622AbbIWHJC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Sep 2015 03:09:02 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 4/4] staging: wilc1000: remove define CONNECT_DIRECT
Date: Wed, 23 Sep 2015 16:10:55 +0900
Message-ID: <1442992255-23005-4-git-send-email-glen.lee@atmel.com> (sfid-20150923_090906_467286_1F63146E)
In-Reply-To: <1442992255-23005-1-git-send-email-glen.lee@atmel.com>
References: <1442992255-23005-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The driver use CONNECT_DIRECT define as always. No need to provide as feature.
This patch removes ifdef/ifndef CONNECT_DIRECT line and it's related codes
inside ifndef CONNECT_DIRECT.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/Makefile           |   2 +-
 drivers/staging/wilc1000/coreconfigurator.c |  70 ---------
 drivers/staging/wilc1000/coreconfigurator.h |  20 ---
 drivers/staging/wilc1000/host_interface.c   | 233 ----------------------------
 drivers/staging/wilc1000/host_interface.h   |  40 -----
 5 files changed, 1 insertion(+), 364 deletions(-)

diff --git a/drivers/staging/wilc1000/Makefile b/drivers/staging/wilc1000/Makefile
index ac15e5a..e965df9 100644
--- a/drivers/staging/wilc1000/Makefile
+++ b/drivers/staging/wilc1000/Makefile
@@ -9,7 +9,7 @@ ccflags-y += -DSTA_FIRMWARE=\"atmel/wilc1000_fw.bin\" \
 		-DP2P_CONCURRENCY_FIRMWARE=\"atmel/wilc1000_p2p_fw.bin\"
 
 ccflags-y += -I$(src)/ -D__CHECK_ENDIAN__ -DWILC_ASIC_A0 \
-		-DPLL_WORKAROUND -DCONNECT_DIRECT  -DAGING_ALG \
+		-DPLL_WORKAROUND -DAGING_ALG \
 		-Wno-unused-function -DWILC_DEBUGFS
 #ccflags-y += -DTCP_ACK_FILTER
 
diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index 14e8efc..3e89c16 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -649,76 +649,6 @@ s32 DeallocateAssocRespInfo(tstrConnectRespInfo *pstrConnectRespInfo)
 	return s32Error;
 }
 
-#ifndef CONNECT_DIRECT
-s32 ParseSurveyResults(u8 ppu8RcvdSiteSurveyResults[][MAX_SURVEY_RESULT_FRAG_SIZE],
-			       wid_site_survey_reslts_s **ppstrSurveyResults,
-			       u32 *pu32SurveyResultsCount)
-{
-	s32 s32Error = 0;
-	wid_site_survey_reslts_s *pstrSurveyResults = NULL;
-	u32 u32SurveyResultsCount = 0;
-	u32 u32SurveyBytesLength = 0;
-	u8 *pu8BufferPtr;
-	u32 u32RcvdSurveyResultsNum = 2;
-	u8 u8ReadSurveyResFragNum;
-	u32 i;
-	u32 j;
-
-	for (i = 0; i < u32RcvdSurveyResultsNum; i++) {
-		u32SurveyBytesLength = ppu8RcvdSiteSurveyResults[i][0];
-
-
-		for (j = 0; j < u32SurveyBytesLength; j += SURVEY_RESULT_LENGTH) {
-			u32SurveyResultsCount++;
-		}
-	}
-
-	pstrSurveyResults = kmalloc_array(u32SurveyResultsCount,
-				sizeof(wid_site_survey_reslts_s), GFP_KERNEL);
-	if (!pstrSurveyResults)
-		return -ENOMEM;
-
-	memset((void *)(pstrSurveyResults), 0, u32SurveyResultsCount * sizeof(wid_site_survey_reslts_s));
-
-	u32SurveyResultsCount = 0;
-
-	for (i = 0; i < u32RcvdSurveyResultsNum; i++) {
-		pu8BufferPtr = ppu8RcvdSiteSurveyResults[i];
-
-		u32SurveyBytesLength = pu8BufferPtr[0];
-
-		/* TODO: mostafa: pu8BufferPtr[1] contains the fragment num */
-		u8ReadSurveyResFragNum = pu8BufferPtr[1];
-
-		pu8BufferPtr += 2;
-
-		for (j = 0; j < u32SurveyBytesLength; j += SURVEY_RESULT_LENGTH) {
-			memcpy(&pstrSurveyResults[u32SurveyResultsCount], pu8BufferPtr, SURVEY_RESULT_LENGTH);
-			pu8BufferPtr += SURVEY_RESULT_LENGTH;
-			u32SurveyResultsCount++;
-		}
-	}
-
-ERRORHANDLER:
-	*ppstrSurveyResults = pstrSurveyResults;
-	*pu32SurveyResultsCount = u32SurveyResultsCount;
-
-	return s32Error;
-}
-
-
-s32 DeallocateSurveyResults(wid_site_survey_reslts_s *pstrSurveyResults)
-{
-	s32 s32Error = 0;
-
-	if (pstrSurveyResults != NULL) {
-		kfree(pstrSurveyResults);
-	}
-
-	return s32Error;
-}
-#endif
-
 /**
  *  @brief              Deinitializes the Core Configurator
  *  @details
diff --git a/drivers/staging/wilc1000/coreconfigurator.h b/drivers/staging/wilc1000/coreconfigurator.h
index 8439066..0cecd0c 100644
--- a/drivers/staging/wilc1000/coreconfigurator.h
+++ b/drivers/staging/wilc1000/coreconfigurator.h
@@ -143,19 +143,6 @@ typedef struct {
 	size_t ie_len;
 } tstrDisconnectNotifInfo;
 
-#ifndef CONNECT_DIRECT
-typedef struct wid_site_survey_reslts {
-	char SSID[MAX_SSID_LEN];
-	u8 BssType;
-	u8 Channel;
-	u8 SecurityStatus;
-	u8 BSSID[6];
-	char RxPower;
-	u8 Reserved;
-
-} wid_site_survey_reslts_s;
-#endif
-
 s32 CoreConfiguratorInit(void);
 s32 CoreConfiguratorDeInit(void);
 
@@ -168,13 +155,6 @@ s32 ParseAssocRespInfo(u8 *pu8Buffer, u32 u32BufferLen,
 		       tstrConnectRespInfo **ppstrConnectRespInfo);
 s32 DeallocateAssocRespInfo(tstrConnectRespInfo *pstrConnectRespInfo);
 
-#ifndef CONNECT_DIRECT
-s32 ParseSurveyResults(u8 ppu8RcvdSiteSurveyResults[][MAX_SURVEY_RESULT_FRAG_SIZE],
-		       wid_site_survey_reslts_s **ppstrSurveyResults,
-		       u32 *pu32SurveyResultsCount);
-s32 DeallocateSurveyResults(wid_site_survey_reslts_s *pstrSurveyResults);
-#endif
-
 void NetworkInfoReceived(u8 *pu8Buffer, u32 u32Length);
 void GnrlAsyncInfoReceived(u8 *pu8Buffer, u32 u32Length);
 void host_int_ScanCompleteReceived(u8 *pu8Buffer, u32 u32Length);
diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 98a99d6..706cb17 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -454,13 +454,11 @@ struct host_if_msg {
 	tstrWILC_WFIDrv *drvHandler;
 };
 
-#ifdef CONNECT_DIRECT
 typedef struct _tstrWidJoinReqExt {
 	char SSID[MAX_SSID_LEN];
 	u8 u8channel;
 	u8 BSSID[6];
 } tstrWidJoinReqExt;
-#endif
 
 /*Struct containg joinParam of each AP*/
 typedef struct _tstrJoinBssParam {
@@ -529,10 +527,6 @@ struct timer_list g_hPeriodicRSSI;
 
 u8 gau8MulticastMacAddrList[WILC_MULTICAST_TABLE_SIZE][ETH_ALEN];
 
-#ifndef CONNECT_DIRECT
-static u8 gapu8RcvdSurveyResults[2][MAX_SURVEY_RESULT_FRAG_SIZE];
-#endif
-
 static u8 gapu8RcvdAssocResp[MAX_ASSOC_RESP_FRAME_SIZE];
 
 bool gbScanWhileConnected = false;
@@ -1505,174 +1499,11 @@ static s32 Handle_Connect(tstrWILC_WFIDrv *drvHandler,
 	tstrWID strWIDList[8];
 	u32 u32WidsCount = 0, dummyval = 0;
 	/* char passphrase[] = "12345678"; */
-	#ifndef CONNECT_DIRECT
-	s32 s32Err = 0;
-	u32 i;
-	u8 u8bssDscListIndex;
-	wid_site_survey_reslts_s *pstrSurveyResults = NULL;
-	#else
 	u8 *pu8CurrByte = NULL;
 	tstrJoinBssParam *ptstrJoinBssParam;
-	#endif
 
 	PRINT_D(GENERIC_DBG, "Handling connect request\n");
 
-	#ifndef CONNECT_DIRECT
-	memset(gapu8RcvdSurveyResults, 0, sizeof(gapu8RcvdSurveyResults));
-
-
-	PRINT_D(HOSTINF_DBG, "Getting site survey results\n");
-	s32Err = host_int_get_site_survey_results(pstrWFIDrv,
-						  gapu8RcvdSurveyResults,
-						  MAX_SURVEY_RESULT_FRAG_SIZE);
-	if (s32Err) {
-		PRINT_ER("Failed to get site survey results\n");
-		s32Error = -EFAULT;
-		goto ERRORHANDLER;
-	}
-	s32Err = ParseSurveyResults(gapu8RcvdSurveyResults, &pstrSurveyResults,
-				    &pstrWFIDrv->u32SurveyResultsCount);
-
-
-	if (s32Err == 0) {
-		/* use the parsed info in pstrSurveyResults, then deallocate it */
-		PRINT_D(HOSTINF_DBG, "Copying site survey results in global structure, then deallocate\n");
-		for (i = 0; i < pstrWFIDrv->u32SurveyResultsCount; i++)	{
-			memcpy(&pstrWFIDrv->astrSurveyResults[i], &pstrSurveyResults[i],
-				    sizeof(wid_site_survey_reslts_s));
-		}
-
-		DeallocateSurveyResults(pstrSurveyResults);
-	} else {
-		PRINT_ER("ParseSurveyResults() Error\n");
-		s32Error = -EFAULT;
-		goto ERRORHANDLER;
-	}
-
-
-	for (i = 0; i < pstrWFIDrv->u32SurveyResultsCount; i++)	{
-		if (memcmp(pstrWFIDrv->astrSurveyResults[i].SSID,
-				pstrHostIFconnectAttr->pu8ssid,
-				pstrHostIFconnectAttr->ssidLen) == 0) {
-			PRINT_INFO(HOSTINF_DBG, "Network with required SSID is found %s\n", pstrHostIFconnectAttr->pu8ssid);
-			if (pstrHostIFconnectAttr->pu8bssid == NULL) {
-				/* BSSID is not passed from the user, so decision of matching
-				 * is done by SSID only */
-				PRINT_INFO(HOSTINF_DBG, "BSSID is not passed from the user\n");
-				break;
-			} else {
-				/* BSSID is also passed from the user, so decision of matching
-				 * should consider also this passed BSSID */
-
-				if (memcmp(pstrWFIDrv->astrSurveyResults[i].BSSID,
-						pstrHostIFconnectAttr->pu8bssid,
-						6) == 0) {
-					PRINT_INFO(HOSTINF_DBG, "BSSID is passed from the user and matched\n");
-					break;
-				}
-			}
-		}
-	}
-
-	if (i < pstrWFIDrv->u32SurveyResultsCount) {
-		u8bssDscListIndex = i;
-
-		PRINT_INFO(HOSTINF_DBG, "Connecting to network of Bss Idx%d and SSID %s and channel%d\n",
-			   u8bssDscListIndex, pstrWFIDrv->astrSurveyResults[u8bssDscListIndex].SSID,
-			   pstrWFIDrv->astrSurveyResults[u8bssDscListIndex].Channel);
-
-		PRINT_INFO(HOSTINF_DBG, "Saving connection parameters in global structure\n");
-
-		if (pstrHostIFconnectAttr->pu8bssid != NULL) {
-			pstrWFIDrv->strWILC_UsrConnReq.pu8bssid = kmalloc(6, GFP_KERNEL);
-			memcpy(pstrWFIDrv->strWILC_UsrConnReq.pu8bssid, pstrHostIFconnectAttr->pu8bssid, 6);
-		}
-
-		pstrWFIDrv->strWILC_UsrConnReq.ssidLen = pstrHostIFconnectAttr->ssidLen;
-		if (pstrHostIFconnectAttr->pu8ssid != NULL) {
-			pstrWFIDrv->strWILC_UsrConnReq.pu8ssid = kmalloc(pstrHostIFconnectAttr->ssidLen + 1, GFP_KERNEL);
-			memcpy(pstrWFIDrv->strWILC_UsrConnReq.pu8ssid, pstrHostIFconnectAttr->pu8ssid,
-				    pstrHostIFconnectAttr->ssidLen);
-			pstrWFIDrv->strWILC_UsrConnReq.pu8ssid[pstrHostIFconnectAttr->ssidLen] = '\0';
-		}
-
-		pstrWFIDrv->strWILC_UsrConnReq.ConnReqIEsLen = pstrHostIFconnectAttr->IEsLen;
-		if (pstrHostIFconnectAttr->pu8IEs != NULL) {
-			pstrWFIDrv->strWILC_UsrConnReq.pu8ConnReqIEs = kmalloc(pstrHostIFconnectAttr->IEsLen, GFP_KERNEL);
-			memcpy(pstrWFIDrv->strWILC_UsrConnReq.pu8ConnReqIEs, pstrHostIFconnectAttr->pu8IEs,
-				    pstrHostIFconnectAttr->IEsLen);
-		}
-
-		pstrWFIDrv->strWILC_UsrConnReq.u8security = pstrHostIFconnectAttr->u8security;
-		pstrWFIDrv->strWILC_UsrConnReq.tenuAuth_type = pstrHostIFconnectAttr->tenuAuth_type;
-		pstrWFIDrv->strWILC_UsrConnReq.pfUserConnectResult = pstrHostIFconnectAttr->pfConnectResult;
-		pstrWFIDrv->strWILC_UsrConnReq.u32UserConnectPvoid = pstrHostIFconnectAttr->pvUserArg;
-
-
-		/* if((gWFiDrvHandle->strWILC_UsrConnReq.pu8ConnReqIEs != NULL) && */
-		/* (gWFiDrvHandle->strWILC_UsrConnReq.ConnReqIEsLen != 0)) */
-		{
-			/* IEs to be inserted in Association Request */
-			strWIDList[u32WidsCount].u16WIDid = WID_INFO_ELEMENT_ASSOCIATE;
-			strWIDList[u32WidsCount].enuWIDtype = WID_BIN_DATA;
-			strWIDList[u32WidsCount].ps8WidVal = pstrWFIDrv->strWILC_UsrConnReq.pu8ConnReqIEs;
-			strWIDList[u32WidsCount].s32ValueSize = pstrWFIDrv->strWILC_UsrConnReq.ConnReqIEsLen;
-			u32WidsCount++;
-		}
-		strWIDList[u32WidsCount].u16WIDid = (u16)WID_11I_MODE;
-		strWIDList[u32WidsCount].enuWIDtype = WID_CHAR;
-		strWIDList[u32WidsCount].s32ValueSize = sizeof(char);
-		strWIDList[u32WidsCount].ps8WidVal = (s8 *)(&(pstrWFIDrv->strWILC_UsrConnReq.u8security));
-		u32WidsCount++;
-
-		PRINT_INFO(HOSTINF_DBG, "Encrypt Mode = %x\n", pstrWFIDrv->strWILC_UsrConnReq.u8security);
-
-		strWIDList[u32WidsCount].u16WIDid = (u16)WID_AUTH_TYPE;
-		strWIDList[u32WidsCount].enuWIDtype = WID_CHAR;
-		strWIDList[u32WidsCount].s32ValueSize = sizeof(char);
-		strWIDList[u32WidsCount].ps8WidVal = (s8 *)(&pstrWFIDrv->strWILC_UsrConnReq.tenuAuth_type);
-		u32WidsCount++;
-
-		PRINT_INFO(HOSTINF_DBG, "Authentication Type = %x\n", pstrWFIDrv->strWILC_UsrConnReq.tenuAuth_type);
-		/*
-		 * strWIDList[u32WidsCount].u16WIDid = (u16)WID_11I_PSK;
-		 * strWIDList[u32WidsCount].enuWIDtype = WID_STR;
-		 * strWIDList[u32WidsCount].s32ValueSize = sizeof(passphrase);
-		 * strWIDList[u32WidsCount].ps8WidVal = (s8*)(passphrase);
-		 * u32WidsCount++;
-		 */
-
-		strWIDList[u32WidsCount].u16WIDid = (u16)WID_JOIN_REQ;
-		strWIDList[u32WidsCount].enuWIDtype = WID_CHAR;
-		strWIDList[u32WidsCount].s32ValueSize = sizeof(char);
-		strWIDList[u32WidsCount].ps8WidVal = (s8 *)&u8bssDscListIndex;
-		u32WidsCount++;
-
-		/* A temporary workaround to avoid handling the misleading MAC_DISCONNECTED raised from the
-		 *   firmware at chip reset when processing the WIDs of the Connect Request.
-		 *   (This workaround should be removed in the future when the Chip reset of the Connect WIDs is disabled) */
-		/* ////////////////////// */
-		gu32WidConnRstHack = 0;
-		/* ////////////////////// */
-
-		s32Error = SendConfigPkt(SET_CFG, strWIDList, u32WidsCount, false,
-					 get_id_from_handler(pstrWFIDrv));
-		if (s32Error) {
-			PRINT_ER("failed to send config packet\n");
-			s32Error = -EINVAL;
-			goto ERRORHANDLER;
-		} else {
-			pstrWFIDrv->enuHostIFstate = HOST_IF_WAITING_CONN_RESP;
-		}
-
-	} else {
-		PRINT_ER("Required BSSID not found\n");
-		s32Error = -ENOENT;
-		goto ERRORHANDLER;
-	}
-
-	#else
-
 	/* if we try to connect to an already connected AP then discard the request */
 
 	if (memcmp(pstrHostIFconnectAttr->pu8bssid, u8ConnectedSSID, ETH_ALEN) == 0) {
@@ -1947,7 +1778,6 @@ static s32 Handle_Connect(tstrWILC_WFIDrv *drvHandler,
 		PRINT_D(GENERIC_DBG, "set HOST_IF_WAITING_CONN_RESP\n");
 		pstrWFIDrv->enuHostIFstate = HOST_IF_WAITING_CONN_RESP;
 	}
-	#endif
 
 ERRORHANDLER:
 	if (s32Error) {
@@ -5146,69 +4976,6 @@ s32 host_int_get_RSNAConfigPSKPassPhrase(tstrWILC_WFIDrv *hWFIDrv,
 }
 
 /**
- *  @brief                      host_int_get_site_survey_results
- *  @details            gets the site survey results
- *  @param[in,out] handle to the wifi driver,
- *                                Message containing  site survey results in the
- *                                following format
- *|---------------------------------------------------|
- | MsgLength | fragNo.	| MsgBodyLength	| MsgBody	|
- ||-----------|-----------|---------------|-----------|
- |	 1		|	  1		|		1		|	 1		|
- | -----------------------------------------	 |  ----------------
- |
- ||---------------------------------------|
- | Network1 | Netweork2 | ... | Network5 |
- ||---------------------------------------|
- |	44	   |	44	   | ... |	 44		|
- | -------------------------- | ---------------------------------------
- |
- ||---------------------------------------------------------------------|
- | SSID | BSS Type | Channel | Security Status| BSSID | RSSI |Reserved |
- |
- |
- ||------|----------|---------|----------------|-------|------|---------|
- |  33  |	 1	  |	  1		|		1		 |	  6	 |	 1	|	 1	  |
- ||---------------------------------------------------------------------|
- *  @return             Error code indicating success/failure
- *  @note
- *  @author		zsalah
- *  @date		8 March 2012
- *  @version		1.0
- */
-#ifndef CONNECT_DIRECT
-s32 host_int_get_site_survey_results(tstrWILC_WFIDrv *hWFIDrv,
-					     u8 ppu8RcvdSiteSurveyResults[][MAX_SURVEY_RESULT_FRAG_SIZE],
-					     u32 u32MaxSiteSrvyFragLen)
-{
-	s32 s32Error = 0;
-	tstrWID astrWIDList[2];
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
-
-	astrWIDList[0].u16WIDid = (u16)WID_SITE_SURVEY_RESULTS;
-	astrWIDList[0].enuWIDtype = WID_STR;
-	astrWIDList[0].ps8WidVal = ppu8RcvdSiteSurveyResults[0];
-	astrWIDList[0].s32ValueSize = u32MaxSiteSrvyFragLen;
-
-	astrWIDList[1].u16WIDid = (u16)WID_SITE_SURVEY_RESULTS;
-	astrWIDList[1].enuWIDtype = WID_STR;
-	astrWIDList[1].ps8WidVal = ppu8RcvdSiteSurveyResults[1];
-	astrWIDList[1].s32ValueSize = u32MaxSiteSrvyFragLen;
-
-	s32Error = SendConfigPkt(GET_CFG, astrWIDList, 2, true,
-				 get_id_from_handler(pstrWFIDrv));
-
-	/*get the value by searching the local copy*/
-	if (s32Error) {
-		PRINT_ER("Failed to send config packet to get survey results\n");
-		s32Error = -EINVAL;
-	}
-
-	return s32Error;
-}
-#endif
-
-/**
  *  @brief              sets a start scan request
  *  @details
  *  @param[in,out] handle to the wifi driver,
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index c96fff9..67c657d 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -322,11 +322,6 @@ typedef struct {
 
 	tenuHostIFstate enuHostIFstate;
 
-	#ifndef CONNECT_DIRECT
-	u32 u32SurveyResultsCount;
-	wid_site_survey_reslts_s astrSurveyResults[MAX_NUM_SCANNED_NETWORKS];
-	#endif
-
 	u8 au8AssociatedBSSID[ETH_ALEN];
 	tstrCfgParamVal strCfgValues;
 /* semaphores */
@@ -659,41 +654,6 @@ s32 host_int_set_MacAddress(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8MacAddress);
 s32 host_int_wait_msg_queue_idle(void);
 
 /**
- *  @brief              gets the site survey results
- *  @details
- *  @param[in,out] handle to the wifi driver,
- *                                Message containing  site survey results in the
- *                                following formate
- *|---------------------------------------------------|
- | MsgLength | fragNo.	| MsgBodyLength	| MsgBody	|
- ||-----------|-----------|---------------|-----------|
- |	 1		|	  1		|		1		|	 1		|
- | -----------------------------------------	 |  ----------------
- |
- ||---------------------------------------|
- | Network1 | Netweork2 | ... | Network5 |
- ||---------------------------------------|
- |	44	   |	44	   | ... |	 44		|
- | -------------------------- | ---------------------------------------
- |
- ||---------------------------------------------------------------------|
- | SSID | BSS Type | Channel | Security Status| BSSID | RSSI |Reserved |
- ||------|----------|---------|----------------|-------|------|---------|
- |  33  |	 1	  |	  1		|		1		 |	  6	 |	 1	|	 1	  |
- ||---------------------------------------------------------------------|
- *  @return             Error code indicating success/failure
- *  @note
- *  @author		zsalah
- *  @date		8 March 2012
- *  @version		1.0
- */
-#ifndef CONNECT_DIRECT
-s32 host_int_get_site_survey_results(tstrWILC_WFIDrv *hWFIDrv,
-					     u8 ppu8RcvdSiteSurveyResults[][MAX_SURVEY_RESULT_FRAG_SIZE],
-					     u32 u32MaxSiteSrvyFragLen);
-#endif
-
-/**
  *  @brief              sets a start scan request
  *  @details
  *  @param[in,out] handle to the wifi driver,
-- 
1.9.1

