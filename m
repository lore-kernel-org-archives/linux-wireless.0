Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:34817 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753780AbbIGPgx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Sep 2015 11:36:53 -0400
Received: by pacfv12 with SMTP id fv12so102007727pac.2
        for <linux-wireless@vger.kernel.org>; Mon, 07 Sep 2015 08:36:53 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 3/5] staging: wilc1000: remove commented codes
Date: Tue,  8 Sep 2015 00:36:37 +0900
Message-Id: <1441640199-1507-3-git-send-email-chaehyun.lim@gmail.com> (sfid-20150907_173704_063722_9C7A4204)
In-Reply-To: <1441640199-1507-1-git-send-email-chaehyun.lim@gmail.com>
References: <1441640199-1507-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes commented codes.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/coreconfigurator.c |  7 ---
 drivers/staging/wilc1000/host_interface.c   | 88 -----------------------------
 drivers/staging/wilc1000/linux_mon.c        | 61 --------------------
 drivers/staging/wilc1000/linux_wlan.c       | 28 ---------
 drivers/staging/wilc1000/wilc_sdio.c        |  4 --
 drivers/staging/wilc1000/wilc_wlan.c        |  3 -
 drivers/staging/wilc1000/wilc_wlan_cfg.c    |  3 -
 drivers/staging/wilc1000/wilc_wlan_if.h     |  3 -
 8 files changed, 197 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index 1889195..f9a46d5 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -1463,7 +1463,6 @@ void ProcessBinWid(char *pcPacket, s32 *ps32PktLen,
 		u16MsgLen = (u16)s32ValueSize;
 
 		/* Length */
-		/* pcPacket[s32PktLen++] = (u8)u16MsgLen; */
 		pcPacket[s32PktLen++] = (u8)(u16MsgLen  & 0xFF);
 		pcPacket[s32PktLen++] = (u8)((u16MsgLen >> 8) & 0xFF);
 
@@ -1548,7 +1547,6 @@ s32 further_process_response(u8 *resp,
 
 		cfg_sht = MAKE_WORD16(resp[idx], resp[idx + 1]);
 		/*Set local copy of WID*/
-		/* pstrWIDresult->ps8WidVal = (s8*)(s32)cfg_sht; */
 		*pu16val = cfg_sht;
 		break;
 	}
@@ -1562,14 +1560,12 @@ s32 further_process_response(u8 *resp,
 				MAKE_WORD16(resp[idx + 2], resp[idx + 3])
 				);
 		/*Set local copy of WID*/
-		/* pstrWIDresult->ps8WidVal = (s8*)cfg_int; */
 		*pu32val = cfg_int;
 		break;
 	}
 
 	case WID_STR:
 		memcpy(cfg_str, resp + idx, cfg_len);
-		/* cfg_str[cfg_len] = '\0'; //mostafa: no need currently for NULL termination */
 		if (pstrWIDresult->s32ValueSize >= cfg_len) {
 			memcpy(pstrWIDresult->ps8WidVal, cfg_str, cfg_len); /* mostafa: no need currently for the extra NULL byte */
 			pstrWIDresult->s32ValueSize = cfg_len;
@@ -1863,9 +1859,6 @@ s32 ConfigWaitResponse(char *pcRespBuffer, s32 s32MaxRespBuffLen, s32 *ps32Bytes
 	s32 s32Error = WILC_SUCCESS;
 	/*bug 3878*/
 	/*removed to caller function*/
-	/*gstrConfigPktInfo.pcRespBuffer = pcRespBuffer;
-	 * gstrConfigPktInfo.s32MaxRespBuffLen = s32MaxRespBuffLen;
-	 * gstrConfigPktInfo.bRespRequired = bRespRequired;*/
 
 
 	if (gstrConfigPktInfo.bRespRequired) {
diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 8458d8d..e09508e 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1405,7 +1405,6 @@ static s32 Handle_Scan(tstrWILC_WFIDrv *drvHandler, tstrHostIFscanAttr *pstrHost
 	u32WidsCount++;
 
 	/*keep the state as is , no need to change it*/
-	/* gWFiDrvHandle->enuHostIFstate = HOST_IF_SCANNING; */
 
 	if (pstrWFIDrv->enuHostIFstate == HOST_IF_CONNECTED)
 		gbScanWhileConnected = true;
@@ -1641,8 +1640,6 @@ static s32 Handle_Connect(tstrWILC_WFIDrv *drvHandler, tstrHostIFconnectAttr *ps
 		pstrWFIDrv->strWILC_UsrConnReq.u32UserConnectPvoid = pstrHostIFconnectAttr->pvUserArg;
 
 
-		/* if((gWFiDrvHandle->strWILC_UsrConnReq.pu8ConnReqIEs != NULL) && */
-		/* (gWFiDrvHandle->strWILC_UsrConnReq.ConnReqIEsLen != 0)) */
 		{
 			/* IEs to be inserted in Association Request */
 			strWIDList[u32WidsCount].u16WIDid = WID_INFO_ELEMENT_ASSOCIATE;
@@ -1666,13 +1663,6 @@ static s32 Handle_Connect(tstrWILC_WFIDrv *drvHandler, tstrHostIFconnectAttr *ps
 		u32WidsCount++;
 
 		PRINT_INFO(HOSTINF_DBG, "Authentication Type = %x\n", pstrWFIDrv->strWILC_UsrConnReq.tenuAuth_type);
-		/*
-		 * strWIDList[u32WidsCount].u16WIDid = (u16)WID_11I_PSK;
-		 * strWIDList[u32WidsCount].enuWIDtype = WID_STR;
-		 * strWIDList[u32WidsCount].s32ValueSize = sizeof(passphrase);
-		 * strWIDList[u32WidsCount].ps8WidVal = (s8*)(passphrase);
-		 * u32WidsCount++;
-		 */
 
 		strWIDList[u32WidsCount].u16WIDid = (u16)WID_JOIN_REQ;
 		strWIDList[u32WidsCount].enuWIDtype = WID_CHAR;
@@ -1766,8 +1756,6 @@ static s32 Handle_Connect(tstrWILC_WFIDrv *drvHandler, tstrHostIFconnectAttr *ps
 	strWIDList[u32WidsCount].ps8WidVal = (s8 *)(&(dummyval));
 	u32WidsCount++;
 
-	/* if((gWFiDrvHandle->strWILC_UsrConnReq.pu8ConnReqIEs != NULL) && */
-	/* (gWFiDrvHandle->strWILC_UsrConnReq.ConnReqIEsLen != 0)) */
 	{
 		/* IEs to be inserted in Association Request */
 		strWIDList[u32WidsCount].u16WIDid = WID_INFO_ELEMENT_ASSOCIATE;
@@ -1809,13 +1797,6 @@ static s32 Handle_Connect(tstrWILC_WFIDrv *drvHandler, tstrHostIFconnectAttr *ps
 		gu8FlushedAuthType = (u8)pstrWFIDrv->strWILC_UsrConnReq.tenuAuth_type;
 
 	PRINT_INFO(HOSTINF_DBG, "Authentication Type = %x\n", pstrWFIDrv->strWILC_UsrConnReq.tenuAuth_type);
-	/*
-	 * strWIDList[u32WidsCount].u16WIDid = (u16)WID_11I_PSK;
-	 * strWIDList[u32WidsCount].enuWIDtype = WID_STR;
-	 * strWIDList[u32WidsCount].s32ValueSize = sizeof(passphrase);
-	 * strWIDList[u32WidsCount].ps8WidVal = (s8*)(passphrase);
-	 * u32WidsCount++;
-	 */
 
 	PRINT_D(HOSTINF_DBG, "Connecting to network of SSID %s on channel %d\n",
 		pstrWFIDrv->strWILC_UsrConnReq.pu8ssid, pstrHostIFconnectAttr->u8channel);
@@ -2568,13 +2549,9 @@ static s32 Handle_RcvdGnrlAsyncInfo(tstrWILC_WFIDrv *drvHandler, tstrRcvdGnrlAsy
 				#endif
 
 				#ifdef WILC_PARSE_SCAN_IN_HOST
-				/* open a BA session if possible */
-				/* if(pstrWFIDrv->strWILC_UsrConnReq.IsHTCapable) */
 
 				#endif
 
-				/* host_int_addBASession(pstrWFIDrv->strWILC_UsrConnReq.pu8bssid,0, */
-				/* BA_SESSION_DEFAULT_BUFFER_SIZE,BA_SESSION_DEFAULT_TIMEOUT); */
 			} else {
 				PRINT_D(HOSTINF_DBG, "MAC status : %d and Connect Status : %d\n", u8MacStatus, strConnectInfo.u16ConnectStatus);
 				pstrWFIDrv->enuHostIFstate = HOST_IF_IDLE;
@@ -2651,13 +2628,6 @@ static s32 Handle_RcvdGnrlAsyncInfo(tstrWILC_WFIDrv *drvHandler, tstrRcvdGnrlAsy
 
 			/* if Information Elements were retrieved from the Received deauth/disassoc frame, then they
 			 *  should be deallocated here */
-			/*
-			 * if(strDisconnectNotifInfo.ie != NULL)
-			 * {
-			 *      kfree(strDisconnectNotifInfo.ie);
-			 *      strDisconnectNotifInfo.ie = NULL;
-			 * }
-			 */
 
 			pstrWFIDrv->strWILC_UsrConnReq.ssidLen = 0;
 			if (pstrWFIDrv->strWILC_UsrConnReq.pu8ssid != NULL) {
@@ -2876,7 +2846,6 @@ static int Handle_Key(tstrWILC_WFIDrv *drvHandler, tstrHostIFkeyAttr *pstrHostIF
 
 			memcpy(pu8keybuf + 16, pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwpaAttr.pu8key,
 				    pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwpaAttr.u8Keylen);
-			/* pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwpaAttr.u8Ciphermode =  0X51; */
 			strWIDList[0].u16WIDid = (u16)WID_11I_MODE;
 			strWIDList[0].enuWIDtype = WID_CHAR;
 			strWIDList[0].s32ValueSize = sizeof(char);
@@ -3274,7 +3243,6 @@ static s32 Handle_GetChnl(tstrWILC_WFIDrv *drvHandler)
 
 	s32 s32Error = WILC_SUCCESS;
 	tstrWID	strWID;
-	/* tstrWILC_WFIDrv * pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv; */
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
 
 	strWID.u16WIDid = (u16)WID_CURRENT_CHANNEL;
@@ -3417,7 +3385,6 @@ s32 Handle_GetStatistics(tstrWILC_WFIDrv *drvHandler, tstrStatistics *pstrStatis
 
 	if (s32Error) {
 		PRINT_ER("Failed to send scan paramters config packet\n");
-		/* WILC_ERRORREPORT(s32Error, s32Error); */
 	}
 	up(&hWaitResponse);
 	return 0;
@@ -4223,7 +4190,6 @@ static s32 Handle_AddBASession(tstrWILC_WFIDrv *drvHandler, tstrHostIfBASessionI
 	strWID.ps8WidVal = WILC_MALLOC(BLOCK_ACK_REQ_SIZE);
 	strWID.s32ValueSize = BLOCK_ACK_REQ_SIZE;
 	ptr = strWID.ps8WidVal;
-	/* *ptr++ = 0x14; */
 	*ptr++ = 0x14;
 	*ptr++ = 0x3;
 	*ptr++ = 0x0;
@@ -4256,7 +4222,6 @@ static s32 Handle_AddBASession(tstrWILC_WFIDrv *drvHandler, tstrHostIfBASessionI
 	strWID.enuWIDtype = WID_STR;
 	strWID.s32ValueSize = 15;
 	ptr = strWID.ps8WidVal;
-	/* *ptr++ = 0x14; */
 	*ptr++ = 15;
 	*ptr++ = 7;
 	*ptr++ = 0x2;
@@ -4310,7 +4275,6 @@ static s32 Handle_DelBASession(tstrWILC_WFIDrv *drvHandler, tstrHostIfBASessionI
 	strWID.ps8WidVal = WILC_MALLOC(BLOCK_ACK_REQ_SIZE);
 	strWID.s32ValueSize = BLOCK_ACK_REQ_SIZE;
 	ptr = strWID.ps8WidVal;
-	/* *ptr++ = 0x14; */
 	*ptr++ = 0x14;
 	*ptr++ = 0x3;
 	*ptr++ = 0x2;
@@ -4332,7 +4296,6 @@ static s32 Handle_DelBASession(tstrWILC_WFIDrv *drvHandler, tstrHostIfBASessionI
 	strWID.enuWIDtype = WID_STR;
 	strWID.s32ValueSize = 15;
 	ptr = strWID.ps8WidVal;
-	/* *ptr++ = 0x14; */
 	*ptr++ = 15;
 	*ptr++ = 7;
 	*ptr++ = 0x3;
@@ -4688,7 +4651,6 @@ s32 host_int_remove_key(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8StaAddress)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWID strWID;
-	/* tstrWILC_WFIDrv * pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv; */
 
 	strWID.u16WIDid	= (u16)WID_REMOVE_KEY;
 	strWID.enuWIDtype	= WID_STR;
@@ -5230,7 +5192,6 @@ s32 host_int_get_pmkid_info(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8PmkidInfoArray,
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWID strWID;
-	/* tstrWILC_WFIDrv * pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv; */
 
 	strWID.u16WIDid	= (u16)WID_PMKID_INFO;
 	strWID.enuWIDtype	= WID_STR;
@@ -5361,7 +5322,6 @@ s32 host_int_get_RSNAConfigPSKPassPhrase(tstrWILC_WFIDrv *hWFIDrv,
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWID strWID;
-	/* tstrWILC_WFIDrv * pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv; */
 
 	strWID.u16WIDid	= (u16)WID_11I_PSK;
 	strWID.enuWIDtype	= WID_STR;
@@ -5458,7 +5418,6 @@ s32 host_int_set_start_scan_req(tstrWILC_WFIDrv *hWFIDrv, u8 scanSource)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWID strWID;
-	/* tstrWILC_WFIDrv * pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv; */
 
 	strWID.u16WIDid = (u16)WID_START_SCAN_REQ;
 	strWID.enuWIDtype = WID_CHAR;
@@ -5535,13 +5494,6 @@ s32 host_int_set_join_req(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8bssid,
 		WILC_ERRORREPORT(s32Error, WILC_FAIL);
 
 	}
-/*
- *      if(gWFiDrvHandle->strWILC_UsrScanReq.u32RcvdChCount == 0)
- *      {
- *              PRINT_ER("No scan results exist: Scanning should be done\n");
- *              WILC_ERRORREPORT(s32Error, WILC_FAIL);
- *      }
- */
 	/* prepare the Connect Message */
 	memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
 
@@ -5749,7 +5701,6 @@ s32 host_int_get_assoc_req_info(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8AssocReqInfo,
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWID strWID;
-	/* tstrWILC_WFIDrv * pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv; */
 
 	strWID.u16WIDid = (u16)WID_ASSOC_REQ_INFO;
 	strWID.enuWIDtype = WID_STR;
@@ -5827,7 +5778,6 @@ s32 host_int_get_rx_power_level(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8RxPowerLevel,
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWID strWID;
-	/* tstrWILC_WFIDrv * pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv; */
 
 	strWID.u16WIDid = (u16)WID_RX_POWER_LEVEL;
 	strWID.enuWIDtype = WID_STR;
@@ -6578,12 +6528,6 @@ s32 host_int_init(tstrWILC_WFIDrv **phWFIDrv)
 	tstrWILC_WFIDrv *pstrWFIDrv;
 	int err;
 
-	/*if(u32Intialized == 1)
-	 * {
-	 *      PRINT_D(HOSTINF_DBG,"Host interface is previously initialized\n");
-	 * *phWFIDrv = (WILC_WFIDrvHandle)gWFiDrvHandle; //Will be adjusted later for P2P
-	 *      return 0;
-	 * }	*/
 	PRINT_D(HOSTINF_DBG, "Initializing host interface for client %d\n", clients_count + 1);
 
 	gbScanWhileConnected = false;
@@ -6595,7 +6539,6 @@ s32 host_int_init(tstrWILC_WFIDrv **phWFIDrv)
 	/*Allocate host interface private structure*/
 	pstrWFIDrv  = WILC_MALLOC(sizeof(tstrWILC_WFIDrv));
 	if (pstrWFIDrv == NULL) {
-		/* WILC_ERRORREPORT(s32Error,WILC_NO_MEM); */
 		s32Error = WILC_NO_MEM;
 		PRINT_ER("Failed to allocate memory\n");
 		goto _fail_timer_2;
@@ -6670,7 +6613,6 @@ s32 host_int_init(tstrWILC_WFIDrv **phWFIDrv)
 	down(&(pstrWFIDrv->gtOsCfgValuesSem));
 
 	pstrWFIDrv->enuHostIFstate = HOST_IF_IDLE;
-	/* gWFiDrvHandle->bPendingConnRequest = false; */
 
 	/*Initialize CFG WIDS Defualt Values*/
 
@@ -6746,11 +6688,6 @@ s32 host_int_deinit(tstrWILC_WFIDrv *hWFIDrv)
 
 	/*obtain driver handle*/
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
-	/*if(u32Intialized == 0)
-	 * {
-	 *      PRINT_ER("Host Interface is not initialized\n");
-	 *      return 0;
-	 * }*/
 
 	/*BugID_5348*/
 
@@ -6811,7 +6748,6 @@ s32 host_int_deinit(tstrWILC_WFIDrv *hWFIDrv)
 	if (clients_count == 1)	{
 		if (del_timer_sync(&g_hPeriodicRSSI)) {
 			PRINT_D(HOSTINF_DBG, ">> Connect timer is active\n");
-			/* msleep(HOST_IF_CONNECT_TIMEOUT+1000); */
 		}
 		strHostIFmsg.u16MsgId = HOST_IF_MSG_EXIT;
 		strHostIFmsg.drvHandler = hWFIDrv;
@@ -6831,14 +6767,12 @@ s32 host_int_deinit(tstrWILC_WFIDrv *hWFIDrv)
 
 	/*Setting the gloabl driver handler with NULL*/
 	u32Intialized = 0;
-	/* gWFiDrvHandle = NULL; */
 	ret = remove_handler_in_list(pstrWFIDrv);
 	if (ret)
 		s32Error = WILC_NOT_FOUND;
 
 	if (pstrWFIDrv != NULL) {
 		kfree(pstrWFIDrv);
-		/* pstrWFIDrv=NULL; */
 
 	}
 
@@ -6995,10 +6929,6 @@ void host_int_ScanCompleteReceived(u8 *pu8Buffer, u32 u32Length)
 		/* will be deallocated by the receiving thread */
 		/*no need to send message body*/
 
-		/*strHostIFmsg.uniHostIFmsgBody.strScanComplete.u32Length = u32Length;
-		 * strHostIFmsg.uniHostIFmsgBody.strScanComplete.pu8Buffer  = (u8*)WILC_MALLOC(u32Length);
-		 * memcpy(strHostIFmsg.uniHostIFmsgBody.strScanComplete.pu8Buffer,
-		 *                        pu8Buffer, u32Length); */
 
 		/* send the message */
 		s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
@@ -7568,34 +7498,27 @@ static void *host_int_ParseJoinBssParam(tstrNetworkInfo *ptstrNetworkInfo)
 		pNewJoinBssParam->beacon_period = ptstrNetworkInfo->u16BeaconPeriod;
 		pNewJoinBssParam->cap_info = ptstrNetworkInfo->u16CapInfo;
 		memcpy(pNewJoinBssParam->au8bssid, ptstrNetworkInfo->au8bssid, 6);
-		/*for(i=0; i<6;i++)
-		 *      PRINT_D(HOSTINF_DBG,"%c",pNewJoinBssParam->au8bssid[i]);*/
 		memcpy((u8 *)pNewJoinBssParam->ssid, ptstrNetworkInfo->au8ssid, ptstrNetworkInfo->u8SsidLen + 1);
 		pNewJoinBssParam->ssidLen = ptstrNetworkInfo->u8SsidLen;
 		memset(pNewJoinBssParam->rsn_pcip_policy, 0xFF, 3);
 		memset(pNewJoinBssParam->rsn_auth_policy, 0xFF, 3);
-		/*for(i=0; i<pNewJoinBssParam->ssidLen;i++)
-		 *      PRINT_D(HOSTINF_DBG,"%c",pNewJoinBssParam->ssid[i]);*/
 
 		/* parse supported rates: */
 		while (index < u16IEsLen) {
 			/* supportedRates IE */
 			if (pu8IEs[index] == SUPP_RATES_IE) {
-				/* PRINT_D(HOSTINF_DBG, "Supported Rates\n"); */
 				suppRatesNo = pu8IEs[index + 1];
 				pNewJoinBssParam->supp_rates[0] = suppRatesNo;
 				index += 2; /* skipping ID and length bytes; */
 
 				for (i = 0; i < suppRatesNo; i++) {
 					pNewJoinBssParam->supp_rates[i + 1] = pu8IEs[index + i];
-					/* PRINT_D(HOSTINF_DBG,"%0x ",pNewJoinBssParam->supp_rates[i+1]); */
 				}
 				index += suppRatesNo;
 				continue;
 			}
 			/* Ext SupportedRates IE */
 			else if (pu8IEs[index] == EXT_SUPP_RATES_IE) {
-				/* PRINT_D(HOSTINF_DBG, "Extended Supported Rates\n"); */
 				/* checking if no of ext. supp and supp rates < max limit */
 				extSuppRatesNo = pu8IEs[index + 1];
 				if (extSuppRatesNo > (MAX_RATES_SUPPORTED - suppRatesNo))
@@ -7606,7 +7529,6 @@ static void *host_int_ParseJoinBssParam(tstrNetworkInfo *ptstrNetworkInfo)
 				/* pNewJoinBssParam.supp_rates[0] contains now old number not the ext. no */
 				for (i = 0; i < (pNewJoinBssParam->supp_rates[0] - suppRatesNo); i++) {
 					pNewJoinBssParam->supp_rates[suppRatesNo + i + 1] = pu8IEs[index + i];
-					/* PRINT_D(HOSTINF_DBG,"%0x ",pNewJoinBssParam->supp_rates[suppRatesNo+i+1]); */
 				}
 				index += extSuppRatesNo;
 				continue;
@@ -7616,7 +7538,6 @@ static void *host_int_ParseJoinBssParam(tstrNetworkInfo *ptstrNetworkInfo)
 				/* if IE found set the flag */
 				pNewJoinBssParam->ht_capable = true;
 				index += pu8IEs[index + 1] + 2; /* ID,Length bytes and IE body */
-				/* PRINT_D(HOSTINF_DBG,"HT_CAPABALE\n"); */
 				continue;
 			} else if ((pu8IEs[index] == WMM_IE) && /* WMM Element ID */
 				   (pu8IEs[index + 2] == 0x00) && (pu8IEs[index + 3] == 0x50) &&
@@ -7676,24 +7597,16 @@ static void *host_int_ParseJoinBssParam(tstrNetworkInfo *ptstrNetworkInfo)
 				  (pu8IEs[index + 3] == 0x50) && (pu8IEs[index + 4] == 0xF2) &&
 				  (pu8IEs[index + 5] == 0x01)))	{
 				u16 rsnIndex = index;
-				/*PRINT_D(HOSTINF_DBG,"RSN IE Length:%d\n",pu8IEs[rsnIndex+1]);
-				 * for(i=0; i<pu8IEs[rsnIndex+1]; i++)
-				 * {
-				 *      PRINT_D(HOSTINF_DBG,"%0x ",pu8IEs[rsnIndex+2+i]);
-				 * }*/
 				if (pu8IEs[rsnIndex] == RSN_IE)	{
 					pNewJoinBssParam->mode_802_11i = 2;
-					/* PRINT_D(HOSTINF_DBG,"\nRSN_IE\n"); */
 				} else { /* check if rsn was previously parsed */
 					if (pNewJoinBssParam->mode_802_11i == 0)
 						pNewJoinBssParam->mode_802_11i = 1;
-					/* PRINT_D(HOSTINF_DBG,"\nWPA_IE\n"); */
 					rsnIndex += 4;
 				}
 				rsnIndex += 7; /* skipping id, length, version(2B) and first 3 bytes of gcipher */
 				pNewJoinBssParam->rsn_grp_policy = pu8IEs[rsnIndex];
 				rsnIndex++;
-				/* PRINT_D(HOSTINF_DBG,"Group Policy: %0x\n",pNewJoinBssParam->rsn_grp_policy); */
 				/* initialize policies with invalid values */
 
 				jumpOffset = pu8IEs[rsnIndex] * 4; /* total no.of bytes of pcipher field (count*4) */
@@ -7708,7 +7621,6 @@ static void *host_int_ParseJoinBssParam(tstrNetworkInfo *ptstrNetworkInfo)
 				for (i = pcipherTotalCount, j = 0; i < pcipherCount + pcipherTotalCount && i < 3; i++, j++) {
 					/* each count corresponds to 4 bytes, only last byte is saved */
 					pNewJoinBssParam->rsn_pcip_policy[i] = pu8IEs[rsnIndex + ((j + 1) * 4) - 1];
-					/* PRINT_D(HOSTINF_DBG,"PAIR policy = [%0x,%0x]\n",pNewJoinBssParam->rsn_pcip_policy[i],i); */
 				}
 				pcipherTotalCount += pcipherCount;
 				rsnIndex += jumpOffset;
diff --git a/drivers/staging/wilc1000/linux_mon.c b/drivers/staging/wilc1000/linux_mon.c
index b8d7d04..8d0ad06 100644
--- a/drivers/staging/wilc1000/linux_mon.c
+++ b/drivers/staging/wilc1000/linux_mon.c
@@ -19,7 +19,6 @@
 struct wilc_wfi_radiotap_hdr {
 	struct ieee80211_radiotap_header hdr;
 	u8 rate;
-	/* u32 channel; */
 } __attribute__((packed));
 
 struct wilc_wfi_radiotap_cb_hdr {
@@ -27,7 +26,6 @@ struct wilc_wfi_radiotap_cb_hdr {
 	u8 rate;
 	u8 dump;
 	u16 tx_flags;
-	/* u32 channel; */
 } __attribute__((packed));
 
 extern linux_wlan_t *g_linux_wlan;
@@ -68,9 +66,7 @@ void WILC_WFI_monitor_rx(uint8_t *buff, uint32_t size)
 
 	PRINT_INFO(HOSTAPD_DBG, "In monitor interface receive function\n");
 
-	/*   struct WILC_WFI_priv *priv = netdev_priv(dev); */
 
-	/*   priv = wiphy_priv(priv->dev->ieee80211_ptr->wiphy); */
 
 	/* Bug 4601 */
 	if (wilc_wfi_mon == NULL)
@@ -129,30 +125,20 @@ void WILC_WFI_monitor_rx(uint8_t *buff, uint32_t size)
 			return;
 		}
 
-		/* skb = skb_copy_expand(tx_skb, sizeof(*hdr), 0, GFP_ATOMIC); */
-		/* if (skb == NULL) */
-		/*      return; */
 
 		memcpy(skb_put(skb, size), buff, size);
 		hdr = (struct wilc_wfi_radiotap_hdr *) skb_push(skb, sizeof(*hdr));
 		memset(hdr, 0, sizeof(struct wilc_wfi_radiotap_hdr));
 		hdr->hdr.it_version = 0; /* PKTHDR_RADIOTAP_VERSION; */
-		/* hdr->hdr.it_pad = 0; */
 		hdr->hdr.it_len = cpu_to_le16(sizeof(struct wilc_wfi_radiotap_hdr));
 		PRINT_INFO(HOSTAPD_DBG, "Radiotap len %d\n", hdr->hdr.it_len);
 		hdr->hdr.it_present = cpu_to_le32
 				(1 << IEEE80211_RADIOTAP_RATE);                   /* | */
-		/* (1 << IEEE80211_RADIOTAP_CHANNEL)); */
 		PRINT_INFO(HOSTAPD_DBG, "Presentflags %d\n", hdr->hdr.it_present);
 		hdr->rate = 5; /* txrate->bitrate / 5; */
 
 	}
 
-/*	if(INFO || if(skb->data[9] == 0x00 || skb->data[9] == 0xb0))
- *      {
- *              for(i=0;i<skb->len;i++)
- *                      PRINT_INFO(HOSTAPD_DBG,"Mon RxData[%d] = %02x\n",i,skb->data[i]);
- *      }*/
 
 
 	skb->dev = wilc_wfi_mon;
@@ -175,8 +161,6 @@ struct tx_complete_mon_data {
 static void mgmt_tx_complete(void *priv, int status)
 {
 
-	/* struct sk_buff *skb2; */
-	/* struct wilc_wfi_radiotap_cb_hdr *cb_hdr; */
 
 	struct tx_complete_mon_data *pv_data = (struct tx_complete_mon_data *)priv;
 	u8 *buf =  pv_data->buff;
@@ -191,35 +175,6 @@ static void mgmt_tx_complete(void *priv, int status)
 	}
 
 
-/*			//(skb->data[9] == 0x00 || skb->data[9] == 0xb0 || skb->data[9] == 0x40 ||  skb->data[9] == 0xd0 )
- *      {
- *              skb2 = dev_alloc_skb(pv_data->size+sizeof(struct wilc_wfi_radiotap_cb_hdr));
- *
- *              memcpy(skb_put(skb2,pv_data->size),pv_data->buff, pv_data->size);
- *
- *              cb_hdr = (struct wilc_wfi_radiotap_cb_hdr *) skb_push(skb2, sizeof(*cb_hdr));
- *              memset(cb_hdr, 0, sizeof(struct wilc_wfi_radiotap_cb_hdr));
- *
- *               cb_hdr->hdr.it_version = 0;//PKTHDR_RADIOTAP_VERSION;
- *
- *              cb_hdr->hdr.it_len = cpu_to_le16(sizeof(struct wilc_wfi_radiotap_cb_hdr));
- *
- *       cb_hdr->hdr.it_present = cpu_to_le32(
- *                                        (1 << IEEE80211_RADIOTAP_RATE) |
- *                                       (1 << IEEE80211_RADIOTAP_TX_FLAGS));
- *
- *              cb_hdr->rate = 5;//txrate->bitrate / 5;
- *              cb_hdr->tx_flags = 0x0004;
- *
- *              skb2->dev = wilc_wfi_mon;
- *              skb_set_mac_header(skb2, 0);
- *              skb2->ip_summed = CHECKSUM_UNNECESSARY;
- *              skb2->pkt_type = PACKET_OTHERHOST;
- *              skb2->protocol = htons(ETH_P_802_2);
- *              memset(skb2->cb, 0, sizeof(skb2->cb));
- *
- *              netif_rx(skb2);
- *      }*/
 
 	/* incase of fully hosting mode, the freeing will be done in response to the cfg packet */
 	#ifndef WILC_FULLY_HOSTING_AP
@@ -299,7 +254,6 @@ static netdev_tx_t WILC_WFI_mon_xmit(struct sk_buff *skb,
 	if (wilc_wfi_mon == NULL)
 		return WILC_FAIL;
 
-	/* if(skb->data[3] == 0x10 || skb->data[3] == 0xb0) */
 
 	mon_priv = netdev_priv(wilc_wfi_mon);
 
@@ -411,15 +365,6 @@ void WILC_mgm_HOSTAPD_ACK(void *priv, bool bStatus)
 	u16 u16len = (pv_data->size) - sizeof(struct tx_complete_mon_data *);
 
 
-	/*if(bStatus == 1){
-	 *      if(INFO || buf[0] == 0x10 || buf[0] == 0xb0)
-	 *      PRINT_D(HOSTAPD_DBG,"Packet sent successfully - Size = %d - Address = %p.\n",u16len,pv_data->buff);
-	 * }else{
-	 *              PRINT_D(HOSTAPD_DBG,"Couldn't send packet - Size = %d - Address = %p.\n",u16len,pv_data->buff);
-	 *      }
-	 */
-
-	/* (skb->data[9] == 0x00 || skb->data[9] == 0xb0 || skb->data[9] == 0x40 ||  skb->data[9] == 0xd0 ) */
 	{
 		skb = dev_alloc_skb(u16len + sizeof(struct wilc_wfi_radiotap_cb_hdr));
 
@@ -486,12 +431,7 @@ static void WILC_WFI_mon_setup(struct net_device *dev)
 
 	#ifdef USE_WIRELESS
 	{
-		/* u8 * mac_add; */
 		unsigned char mac_add[] = {0x00, 0x50, 0xc2, 0x5e, 0x10, 0x8f};
-		/* priv = wiphy_priv(priv->dev->ieee80211_ptr->wiphy); */
-		/* mac_add = (u8*)WILC_MALLOC(ETH_ALEN); */
-		/* status = host_int_get_MacAddress(priv->hWILCWFIDrv,mac_add); */
-		/* mac_add[ETH_ALEN-1]+=1; */
 		memcpy(dev->dev_addr, mac_add, ETH_ALEN);
 	}
 	#else
@@ -571,7 +511,6 @@ int WILC_WFI_deinit_mon_interface(void)
 		}
 		PRINT_D(HOSTAPD_DBG, "Unregister netdev\n");
 		unregister_netdev(wilc_wfi_mon);
-		/* free_netdev(wilc_wfi_mon); */
 
 		if (rollback_lock) {
 			rtnl_lock();
diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 76c48a4..b9459a5 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -640,7 +640,6 @@ static int linux_wlan_rxq_task(void *vp)
 	up(&g_linux_wlan->rxq_thread_started);
 	while (1) {
 		down(&g_linux_wlan->rxq_event);
-		/* wait_for_completion(&g_linux_wlan->rxq_event); */
 
 		if (g_linux_wlan->close) {
 			/*Unlock the mutex in the mac_close function to indicate the exiting of the RX thread */
@@ -680,7 +679,6 @@ static int linux_wlan_txq_task(void *vp)
 
 		PRINT_D(TX_DBG, "txq_task Taking a nap :)\n");
 		down(&g_linux_wlan->txq_event);
-		/* wait_for_completion(&pd->txq_event); */
 		PRINT_D(TX_DBG, "txq_task Who waked me up :$\n");
 
 		if (g_linux_wlan->close) {
@@ -701,7 +699,6 @@ static int linux_wlan_txq_task(void *vp)
 			ret = g_linux_wlan->oup.wlan_handle_tx_que(&txq_count);
 			if (txq_count < FLOW_CONTROL_LOWER_THRESHOLD /* && netif_queue_stopped(pd->wilc_netdev)*/) {
 				PRINT_D(TX_DBG, "Waking up queue\n");
-				/* netif_wake_queue(pd->wilc_netdev); */
 				if (netif_queue_stopped(g_linux_wlan->strInterfaceInfo[0].wilc_netdev))
 					netif_wake_queue(g_linux_wlan->strInterfaceInfo[0].wilc_netdev);
 				if (netif_queue_stopped(g_linux_wlan->strInterfaceInfo[1].wilc_netdev))
@@ -712,8 +709,6 @@ static int linux_wlan_txq_task(void *vp)
 				do {
 					/* Back off from sending packets for some time. */
 					/* schedule_timeout will allow RX task to run and free buffers.*/
-					/* set_current_state(TASK_UNINTERRUPTIBLE); */
-					/* timeout = schedule_timeout(timeout); */
 					msleep(TX_BACKOFF_WEIGHT_UNIT_MS << backoff_weight);
 				} while (/*timeout*/ 0);
 				backoff_weight += TX_BACKOFF_WEIGHT_INCR_STEP;
@@ -909,7 +904,6 @@ static int linux_wlan_init_test_config(struct net_device *dev, linux_wlan_t *p_n
 	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_BSS_TYPE, c_val, 1, 0, 0))
 		goto _fail_;
 
-	/* c_val[0] = RATE_AUTO; / * bug 4275: Enable autorate and limit it to 24Mbps * / */
 	c_val[0] = RATE_AUTO;
 	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_CURRENT_TX_RATE, c_val, 1, 0, 0))
 		goto _fail_;
@@ -1189,8 +1183,6 @@ void wilc1000_wlan_deinit(linux_wlan_t *nic)
 			flush_work(&g_linux_wlan->rx_work_queue);
 
 	#elif (RX_BH_TYPE == RX_BH_KTHREAD)
-		/* if(&nic->rx_sem != NULL) */
-		/* up(&nic->rx_sem); */
 	#endif
 
 		PRINT_D(INIT_DBG, "Deinitializing Threads\n");
@@ -1558,7 +1550,6 @@ int repeat_power_cycle(perInterface_wlan_t *nic)
 
 	sdio_register_driver(&wilc_bus);
 
-	/* msleep(1000); */
 	while (!probe)
 		msleep(100);
 	probe = 0;
@@ -1853,7 +1844,6 @@ int mac_open(struct net_device *ndev)
 	/* Start the network interface queue for this device */
 	PRINT_D(INIT_DBG, "Starting netifQ\n");
 	netif_start_queue(ndev);
-/*	down(&close_exit_sync); */
 	return 0;
 }
 #endif
@@ -2083,7 +2073,6 @@ int mac_ioctl(struct net_device *ndev, struct ifreq *req, int cmd)
 	struct WILC_WFI_priv *priv;
 	s32 s32Error = WILC_SUCCESS;
 
-	/* struct iwreq *wrq = (struct iwreq *) req;	// tony moved to case SIOCSIWPRIV */
 	#ifdef USE_WIRELESS
 	nic = netdev_priv(ndev);
 
@@ -2189,27 +2178,13 @@ void frmw_to_linux(uint8_t *buff, uint32_t size, uint32_t pkt_offset)
 		if (skb->dev == NULL)
 			PRINT_ER("skb->dev is NULL\n");
 
-		/*
-		 * for(i=0;i<40;i++)
-		 * {
-		 *      if(i<frame_len)
-		 *              WILC_PRINTF("buff_to_send[%d]=%2x\n",i,buff_to_send[i]);
-		 *
-		 * }*/
 
 		/* skb_put(skb, frame_len); */
 		memcpy(skb_put(skb, frame_len), buff_to_send, frame_len);
 
-		/* WILC_PRINTF("After MEM_CPY\n"); */
 
-		/* nic = netdev_priv(wilc_netdev); */
 
 #ifdef USE_WIRELESS
-		/*	if(nic->monitor_flag)
-		 *      {
-		 *              WILC_WFI_monitor_rx(nic->wilc_netdev,skb);
-		 *              return;
-		 *      }*/
 #endif
 		skb->protocol = eth_type_trans(skb, wilc_netdev);
 			#ifndef TCP_ENHANCEMENTS
@@ -2448,12 +2423,9 @@ static void __exit exit_wilc_driver(void)
 
 #ifdef USE_WIRELESS
 #ifdef WILC_AP_EXTERNAL_MLME
-	/* Bug 4600 : WILC_WFI_deinit_mon_interface was already called at mac_close */
-	/* WILC_WFI_deinit_mon_interface(); */
 #endif
 #endif
 
-	/* if(g_linux_wlan->open_ifcs==0) */
 	{
 	#ifndef WILC_SDIO
 		PRINT_D(INIT_DBG, "SPI unregsiter...\n");
diff --git a/drivers/staging/wilc1000/wilc_sdio.c b/drivers/staging/wilc1000/wilc_sdio.c
index 5a18148..11371a8 100644
--- a/drivers/staging/wilc1000/wilc_sdio.c
+++ b/drivers/staging/wilc1000/wilc_sdio.c
@@ -158,7 +158,6 @@ _fail_:
 static int sdio_clear_int(void)
 {
 #ifndef WILC_SDIO_IRQ_GPIO
-	/* uint32_t sts; */
 	sdio_cmd52_t cmd;
 
 	cmd.read_write = 0;
@@ -732,9 +731,6 @@ static int sdio_read_size(uint32_t *size)
 	g_sdio.sdio_cmd52(&cmd);
 	tmp = cmd.data;
 
-	/* cmd.read_write = 0; */
-	/* cmd.function = 0; */
-	/* cmd.raw = 0; */
 	cmd.address = 0xf3;
 	cmd.data = 0;
 	g_sdio.sdio_cmd52(&cmd);
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 4b37de5..7e67fee 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -911,8 +911,6 @@ static int wilc_wlan_handle_txq(uint32_t *pu32TxqCount)
 		i = 0;
 		sum = 0;
 		do {
-			/* if ((tqe != NULL) && (i < (8)) && */
-			/* if ((tqe != NULL) && (i < (WILC_VMM_TBL_SIZE-1)) && */
 			if ((tqe != NULL) && (i < (WILC_VMM_TBL_SIZE - 1)) /* reserve last entry to 0 */) {
 
 				if (tqe->type == WILC_CFG_PKT) {
@@ -1045,7 +1043,6 @@ static int wilc_wlan_handle_txq(uint32_t *pu32TxqCount)
 					 *      Get the entries
 					 **/
 					entries = ((reg >> 3) & 0x3f);
-					/* entries = ((reg>>3)&0x2f); */
 					break;
 				} else {
 					release_bus(RELEASE_ALLOW_SLEEP);
diff --git a/drivers/staging/wilc1000/wilc_wlan_cfg.c b/drivers/staging/wilc1000/wilc_wlan_cfg.c
index c3f3aaf..6c502ec 100644
--- a/drivers/staging/wilc1000/wilc_wlan_cfg.c
+++ b/drivers/staging/wilc1000/wilc_wlan_cfg.c
@@ -142,7 +142,6 @@ static wilc_cfg_str_t g_cfg_str[] = {
 	{WID_BSSID, g_mac.bssid},	/* 6 bytes */
 	{WID_WEP_KEY_VALUE, g_mac.wep_key},	/* 27 bytes */
 	{WID_11I_PSK, g_mac.i_psk},	/* 65 bytes */
-	/* {WID_11E_P_ACTION_REQ, g_mac.action_req}, */
 	{WID_HARDWARE_VERSION, g_mac.hardwareProductVersion},
 	{WID_MAC_ADDR, g_mac.mac_address},
 	{WID_PHY_VERSION, g_mac.phyversion},
@@ -150,10 +149,8 @@ static wilc_cfg_str_t g_cfg_str[] = {
 	{WID_SUPP_PASSWORD, g_mac.supp_password},
 	{WID_SITE_SURVEY_RESULTS, g_mac.scan_result},
 	{WID_SITE_SURVEY_RESULTS, g_mac.scan_result1},
-	/* {WID_RX_POWER_LEVEL, g_mac.channel_rssi}, */
 	{WID_ASSOC_REQ_INFO, g_mac.assoc_req},
 	{WID_ASSOC_RES_INFO, g_mac.assoc_rsp},
-	/* {WID_11N_P_ACTION_REQ, g_mac.action_req}, */
 	{WID_FIRMWARE_INFO, g_mac.firmware_version},
 	{WID_IP_ADDRESS, g_mac.ip_address},
 	{WID_NIL, NULL}
diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
index 021a2aa..a4fd8ff 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -15,9 +15,6 @@
 #define WILC_AP_EXTERNAL_MLME
 #define WILC_P2P
 #define TCP_ENHANCEMENTS
-/* #define MEMORY_STATIC */
-/* #define WILC_FULLY_HOSTING_AP */
-/* #define USE_OLD_SPI_SW */
 
 
 #include "wilc_oswrapper.h"
-- 
2.5.1

