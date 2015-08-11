Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f176.google.com ([209.85.192.176]:36075 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933448AbbHKBdG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Aug 2015 21:33:06 -0400
Received: by pdco4 with SMTP id o4so77440585pdc.3
        for <linux-wireless@vger.kernel.org>; Mon, 10 Aug 2015 18:33:05 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, dean.lee@atmel.com,
	chris.park@atmel.com, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 3/4] staging: wilc1000: use kfree instead of WILC_FREE
Date: Tue, 11 Aug 2015 10:32:41 +0900
Message-Id: <1439256762-16711-3-git-send-email-chaehyun.lim@gmail.com> (sfid-20150811_033314_737003_7BF34D68)
In-Reply-To: <1439256762-16711-1-git-send-email-chaehyun.lim@gmail.com>
References: <1439256762-16711-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use kfree instead of WILC_FREE.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/coreconfigurator.c       |  12 +--
 drivers/staging/wilc1000/host_interface.c         | 112 +++++++++++-----------
 drivers/staging/wilc1000/linux_wlan.c             |   2 +-
 drivers/staging/wilc1000/wilc_msgqueue.c          |  10 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c |  36 +++----
 5 files changed, 86 insertions(+), 86 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index 72ff7d4..9484827 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -891,13 +891,13 @@ s32 DeallocateNetworkInfo(tstrNetworkInfo *pstrNetworkInfo)
 
 	if (pstrNetworkInfo != NULL) {
 		if (pstrNetworkInfo->pu8IEs != NULL) {
-			WILC_FREE(pstrNetworkInfo->pu8IEs);
+			kfree(pstrNetworkInfo->pu8IEs);
 			pstrNetworkInfo->pu8IEs = NULL;
 		} else {
 			s32Error = WILC_FAIL;
 		}
 
-		WILC_FREE(pstrNetworkInfo);
+		kfree(pstrNetworkInfo);
 		pstrNetworkInfo = NULL;
 
 	} else {
@@ -976,13 +976,13 @@ s32 DeallocateAssocRespInfo(tstrConnectRespInfo *pstrConnectRespInfo)
 
 	if (pstrConnectRespInfo != NULL) {
 		if (pstrConnectRespInfo->pu8RespIEs != NULL) {
-			WILC_FREE(pstrConnectRespInfo->pu8RespIEs);
+			kfree(pstrConnectRespInfo->pu8RespIEs);
 			pstrConnectRespInfo->pu8RespIEs = NULL;
 		} else {
 			s32Error = WILC_FAIL;
 		}
 
-		WILC_FREE(pstrConnectRespInfo);
+		kfree(pstrConnectRespInfo);
 		pstrConnectRespInfo = NULL;
 
 	} else {
@@ -1056,7 +1056,7 @@ s32 DeallocateSurveyResults(wid_site_survey_reslts_s *pstrSurveyResults)
 	s32 s32Error = WILC_SUCCESS;
 
 	if (pstrSurveyResults != NULL) {
-		WILC_FREE(pstrSurveyResults);
+		kfree(pstrSurveyResults);
 	}
 
 	return s32Error;
@@ -1959,7 +1959,7 @@ s32 CoreConfiguratorDeInit(void)
 
 	if (gps8ConfigPacket != NULL) {
 
-		WILC_FREE(gps8ConfigPacket);
+		kfree(gps8ConfigPacket);
 		gps8ConfigPacket = NULL;
 	}
 
diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index cc549c2..bc5ddc8 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -798,7 +798,7 @@ s32 Handle_get_IPAddress(void *drvHandler, u8 *pu8IPAddr, u8 idx)
 	WILC_memcpy(gs8GetIP[idx], strWID.ps8WidVal, IP_ALEN);
 
 	/*get the value by searching the local copy*/
-	WILC_FREE(strWID.ps8WidVal);
+	kfree(strWID.ps8WidVal);
 
 	if (memcmp(gs8GetIP[idx], gs8SetIP[idx], IP_ALEN) != 0)
 		host_int_setup_ipaddress((WILC_WFIDrvHandle)pstrWFIDrv, gs8SetIP[idx], idx);
@@ -862,7 +862,7 @@ static s32 Handle_SetMacAddress(void *drvHandler, tstrHostIfSetMacAddress *pstrH
 	{
 
 	}
-	WILC_FREE(mac_buf);
+	kfree(mac_buf);
 	return s32Error;
 }
 
@@ -1373,28 +1373,28 @@ static s32 Handle_Scan(void *drvHandler, tstrHostIFscanAttr *pstrHostIFscanAttr)
 
 	/* Deallocate pstrHostIFscanAttr->u8ChnlListLen which was prevoisuly allocated by the sending thread */
 	if (pstrHostIFscanAttr->pu8ChnlFreqList != NULL) {
-		WILC_FREE(pstrHostIFscanAttr->pu8ChnlFreqList);
+		kfree(pstrHostIFscanAttr->pu8ChnlFreqList);
 		pstrHostIFscanAttr->pu8ChnlFreqList = NULL;
 	}
 
 	/* Deallocate pstrHostIFscanAttr->pu8IEs which was previously allocated by the sending thread */
 	if (pstrHostIFscanAttr->pu8IEs != NULL)	{
-		WILC_FREE(pstrHostIFscanAttr->pu8IEs);
+		kfree(pstrHostIFscanAttr->pu8IEs);
 		pstrHostIFscanAttr->pu8IEs = NULL;
 	}
 	if (pstrHostIFscanAttr->strHiddenNetwork.pstrHiddenNetworkInfo != NULL)	{
-		WILC_FREE(pstrHostIFscanAttr->strHiddenNetwork.pstrHiddenNetworkInfo);
+		kfree(pstrHostIFscanAttr->strHiddenNetwork.pstrHiddenNetworkInfo);
 		pstrHostIFscanAttr->strHiddenNetwork.pstrHiddenNetworkInfo = NULL;
 	}
 
 	/* Deallocate pstrHostIFscanAttr->u8ChnlListLen which was prevoisuly allocated by the sending thread */
 	if (pstrHostIFscanAttr->pu8ChnlFreqList != NULL) {
-		WILC_FREE(pstrHostIFscanAttr->pu8ChnlFreqList);
+		kfree(pstrHostIFscanAttr->pu8ChnlFreqList);
 		pstrHostIFscanAttr->pu8ChnlFreqList = NULL;
 	}
 
 	if (pu8HdnNtwrksWidVal != NULL)
-		WILC_FREE(pu8HdnNtwrksWidVal);
+		kfree(pu8HdnNtwrksWidVal);
 
 	return s32Error;
 }
@@ -1993,7 +1993,7 @@ static s32 Handle_Connect(void *drvHandler, tstrHostIFconnectAttr *pstrHostIFcon
 			pstrWFIDrv->enuHostIFstate = HOST_IF_IDLE;
 			/* Deallocation */
 			if (strConnectInfo.pu8ReqIEs != NULL) {
-				WILC_FREE(strConnectInfo.pu8ReqIEs);
+				kfree(strConnectInfo.pu8ReqIEs);
 				strConnectInfo.pu8ReqIEs = NULL;
 			}
 
@@ -2005,24 +2005,24 @@ static s32 Handle_Connect(void *drvHandler, tstrHostIFconnectAttr *pstrHostIFcon
 	PRINT_D(HOSTINF_DBG, "Deallocating connection parameters\n");
 	/* Deallocate pstrHostIFconnectAttr->pu8bssid which was prevoisuly allocated by the sending thread */
 	if (pstrHostIFconnectAttr->pu8bssid != NULL) {
-		WILC_FREE(pstrHostIFconnectAttr->pu8bssid);
+		kfree(pstrHostIFconnectAttr->pu8bssid);
 		pstrHostIFconnectAttr->pu8bssid = NULL;
 	}
 
 	/* Deallocate pstrHostIFconnectAttr->pu8ssid which was prevoisuly allocated by the sending thread */
 	if (pstrHostIFconnectAttr->pu8ssid != NULL) {
-		WILC_FREE(pstrHostIFconnectAttr->pu8ssid);
+		kfree(pstrHostIFconnectAttr->pu8ssid);
 		pstrHostIFconnectAttr->pu8ssid = NULL;
 	}
 
 	/* Deallocate pstrHostIFconnectAttr->pu8IEs which was prevoisuly allocated by the sending thread */
 	if (pstrHostIFconnectAttr->pu8IEs != NULL) {
-		WILC_FREE(pstrHostIFconnectAttr->pu8IEs);
+		kfree(pstrHostIFconnectAttr->pu8IEs);
 		pstrHostIFconnectAttr->pu8IEs = NULL;
 	}
 
 	if (pu8CurrByte != NULL)
-		WILC_FREE(pu8CurrByte);
+		kfree(pu8CurrByte);
 	return s32Error;
 }
 
@@ -2150,7 +2150,7 @@ static s32 Handle_ConnectTimeout(void *drvHandler)
 
 		/* Deallocation of strConnectInfo.pu8ReqIEs */
 		if (strConnectInfo.pu8ReqIEs != NULL) {
-			WILC_FREE(strConnectInfo.pu8ReqIEs);
+			kfree(strConnectInfo.pu8ReqIEs);
 			strConnectInfo.pu8ReqIEs = NULL;
 		}
 	} else {
@@ -2173,18 +2173,18 @@ static s32 Handle_ConnectTimeout(void *drvHandler)
 	/* Deallocation of the Saved Connect Request in the global Handle */
 	pstrWFIDrv->strWILC_UsrConnReq.ssidLen = 0;
 	if (pstrWFIDrv->strWILC_UsrConnReq.pu8ssid != NULL) {
-		WILC_FREE(pstrWFIDrv->strWILC_UsrConnReq.pu8ssid);
+		kfree(pstrWFIDrv->strWILC_UsrConnReq.pu8ssid);
 		pstrWFIDrv->strWILC_UsrConnReq.pu8ssid = NULL;
 	}
 
 	if (pstrWFIDrv->strWILC_UsrConnReq.pu8bssid != NULL) {
-		WILC_FREE(pstrWFIDrv->strWILC_UsrConnReq.pu8bssid);
+		kfree(pstrWFIDrv->strWILC_UsrConnReq.pu8bssid);
 		pstrWFIDrv->strWILC_UsrConnReq.pu8bssid = NULL;
 	}
 
 	pstrWFIDrv->strWILC_UsrConnReq.ConnReqIEsLen = 0;
 	if (pstrWFIDrv->strWILC_UsrConnReq.pu8ConnReqIEs != NULL) {
-		WILC_FREE(pstrWFIDrv->strWILC_UsrConnReq.pu8ConnReqIEs);
+		kfree(pstrWFIDrv->strWILC_UsrConnReq.pu8ConnReqIEs);
 		pstrWFIDrv->strWILC_UsrConnReq.pu8ConnReqIEs = NULL;
 	}
 
@@ -2192,11 +2192,11 @@ static s32 Handle_ConnectTimeout(void *drvHandler)
 	/*BugID_5213*/
 	/*Freeing flushed join request params on connect timeout*/
 	if (gu8FlushedJoinReq != NULL && gu8FlushedJoinReqDrvHandler == (u32)drvHandler) {
-		WILC_FREE(gu8FlushedJoinReq);
+		kfree(gu8FlushedJoinReq);
 		gu8FlushedJoinReq = NULL;
 	}
 	if (gu8FlushedInfoElemAsoc != NULL && gu8FlushedJoinReqDrvHandler == (u32)drvHandler) {
-		WILC_FREE(gu8FlushedInfoElemAsoc);
+		kfree(gu8FlushedInfoElemAsoc);
 		gu8FlushedInfoElemAsoc = NULL;
 	}
 
@@ -2312,7 +2312,7 @@ static s32 Handle_RcvdNtwrkInfo(void *drvHandler, tstrRcvdNetworkInfo *pstrRcvdN
 done:
 	/* Deallocate pstrRcvdNetworkInfo->pu8Buffer which was prevoisuly allocated by the sending thread */
 	if (pstrRcvdNetworkInfo->pu8Buffer != NULL) {
-		WILC_FREE(pstrRcvdNetworkInfo->pu8Buffer);
+		kfree(pstrRcvdNetworkInfo->pu8Buffer);
 		pstrRcvdNetworkInfo->pu8Buffer = NULL;
 	}
 
@@ -2520,30 +2520,30 @@ static s32 Handle_RcvdGnrlAsyncInfo(void *drvHandler, tstrRcvdGnrlAsyncInfo *pst
 
 			/* Deallocation */
 			if (strConnectInfo.pu8RespIEs != NULL) {
-				WILC_FREE(strConnectInfo.pu8RespIEs);
+				kfree(strConnectInfo.pu8RespIEs);
 				strConnectInfo.pu8RespIEs = NULL;
 			}
 
 			if (strConnectInfo.pu8ReqIEs != NULL) {
-				WILC_FREE(strConnectInfo.pu8ReqIEs);
+				kfree(strConnectInfo.pu8ReqIEs);
 				strConnectInfo.pu8ReqIEs = NULL;
 			}
 
 
 			pstrWFIDrv->strWILC_UsrConnReq.ssidLen = 0;
 			if (pstrWFIDrv->strWILC_UsrConnReq.pu8ssid != NULL) {
-				WILC_FREE(pstrWFIDrv->strWILC_UsrConnReq.pu8ssid);
+				kfree(pstrWFIDrv->strWILC_UsrConnReq.pu8ssid);
 				pstrWFIDrv->strWILC_UsrConnReq.pu8ssid = NULL;
 			}
 
 			if (pstrWFIDrv->strWILC_UsrConnReq.pu8bssid != NULL) {
-				WILC_FREE(pstrWFIDrv->strWILC_UsrConnReq.pu8bssid);
+				kfree(pstrWFIDrv->strWILC_UsrConnReq.pu8bssid);
 				pstrWFIDrv->strWILC_UsrConnReq.pu8bssid = NULL;
 			}
 
 			pstrWFIDrv->strWILC_UsrConnReq.ConnReqIEsLen = 0;
 			if (pstrWFIDrv->strWILC_UsrConnReq.pu8ConnReqIEs != NULL) {
-				WILC_FREE(pstrWFIDrv->strWILC_UsrConnReq.pu8ConnReqIEs);
+				kfree(pstrWFIDrv->strWILC_UsrConnReq.pu8ConnReqIEs);
 				pstrWFIDrv->strWILC_UsrConnReq.pu8ConnReqIEs = NULL;
 			}
 
@@ -2591,25 +2591,25 @@ static s32 Handle_RcvdGnrlAsyncInfo(void *drvHandler, tstrRcvdGnrlAsyncInfo *pst
 			/*
 			 * if(strDisconnectNotifInfo.ie != NULL)
 			 * {
-			 *      WILC_FREE(strDisconnectNotifInfo.ie);
+			 *      kfree(strDisconnectNotifInfo.ie);
 			 *      strDisconnectNotifInfo.ie = NULL;
 			 * }
 			 */
 
 			pstrWFIDrv->strWILC_UsrConnReq.ssidLen = 0;
 			if (pstrWFIDrv->strWILC_UsrConnReq.pu8ssid != NULL) {
-				WILC_FREE(pstrWFIDrv->strWILC_UsrConnReq.pu8ssid);
+				kfree(pstrWFIDrv->strWILC_UsrConnReq.pu8ssid);
 				pstrWFIDrv->strWILC_UsrConnReq.pu8ssid = NULL;
 			}
 
 			if (pstrWFIDrv->strWILC_UsrConnReq.pu8bssid != NULL) {
-				WILC_FREE(pstrWFIDrv->strWILC_UsrConnReq.pu8bssid);
+				kfree(pstrWFIDrv->strWILC_UsrConnReq.pu8bssid);
 				pstrWFIDrv->strWILC_UsrConnReq.pu8bssid = NULL;
 			}
 
 			pstrWFIDrv->strWILC_UsrConnReq.ConnReqIEsLen = 0;
 			if (pstrWFIDrv->strWILC_UsrConnReq.pu8ConnReqIEs != NULL) {
-				WILC_FREE(pstrWFIDrv->strWILC_UsrConnReq.pu8ConnReqIEs);
+				kfree(pstrWFIDrv->strWILC_UsrConnReq.pu8ConnReqIEs);
 				pstrWFIDrv->strWILC_UsrConnReq.pu8ConnReqIEs = NULL;
 			}
 
@@ -2617,11 +2617,11 @@ static s32 Handle_RcvdGnrlAsyncInfo(void *drvHandler, tstrRcvdGnrlAsyncInfo *pst
 			/*Freeing flushed join request params on receiving*/
 			/*MAC_DISCONNECTED while connected*/
 			if (gu8FlushedJoinReq != NULL && gu8FlushedJoinReqDrvHandler == (u32)drvHandler) {
-				WILC_FREE(gu8FlushedJoinReq);
+				kfree(gu8FlushedJoinReq);
 				gu8FlushedJoinReq = NULL;
 			}
 			if (gu8FlushedInfoElemAsoc != NULL && gu8FlushedJoinReqDrvHandler == (u32)drvHandler) {
-				WILC_FREE(gu8FlushedInfoElemAsoc);
+				kfree(gu8FlushedInfoElemAsoc);
 				gu8FlushedInfoElemAsoc = NULL;
 			}
 
@@ -2648,7 +2648,7 @@ static s32 Handle_RcvdGnrlAsyncInfo(void *drvHandler, tstrRcvdGnrlAsyncInfo *pst
 
 	/* Deallocate pstrRcvdGnrlAsyncInfo->pu8Buffer which was prevoisuly allocated by the sending thread */
 	if (pstrRcvdGnrlAsyncInfo->pu8Buffer != NULL) {
-		WILC_FREE(pstrRcvdGnrlAsyncInfo->pu8Buffer);
+		kfree(pstrRcvdGnrlAsyncInfo->pu8Buffer);
 		pstrRcvdGnrlAsyncInfo->pu8Buffer = NULL;
 	}
 
@@ -2717,7 +2717,7 @@ static int Handle_Key(void *drvHandler, tstrHostIFkeyAttr *pstrHostIFkeyAttr)
 				    pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwepAttr.u8WepKeylen);
 
 
-			WILC_FREE(pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwepAttr.pu8WepKey);
+			kfree(pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwepAttr.pu8WepKey);
 
 			strWIDList[3].u16WIDid = (u16)WID_WEP_KEY_VALUE;
 			strWIDList[3].enuWIDtype = WID_STR;
@@ -2726,7 +2726,7 @@ static int Handle_Key(void *drvHandler, tstrHostIFkeyAttr *pstrHostIFkeyAttr)
 
 
 			s32Error = SendConfigPkt(SET_CFG, strWIDList, 4, true, (u32)pstrWFIDrv);
-			WILC_FREE(pu8keybuf);
+			kfree(pu8keybuf);
 
 
 		}
@@ -2746,7 +2746,7 @@ static int Handle_Key(void *drvHandler, tstrHostIFkeyAttr *pstrHostIFkeyAttr)
 			WILC_memcpy(pu8keybuf + 2, pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwepAttr.pu8WepKey,
 				    pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwepAttr.u8WepKeylen);
 
-			WILC_FREE(pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwepAttr.pu8WepKey);
+			kfree(pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwepAttr.pu8WepKey);
 
 			strWID.u16WIDid	= (u16)WID_ADD_WEP_KEY;
 			strWID.enuWIDtype	= WID_STR;
@@ -2754,7 +2754,7 @@ static int Handle_Key(void *drvHandler, tstrHostIFkeyAttr *pstrHostIFkeyAttr)
 			strWID.s32ValueSize = pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwepAttr.u8WepKeylen + 2;
 
 			s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
-			WILC_FREE(pu8keybuf);
+			kfree(pu8keybuf);
 		} else if (pstrHostIFkeyAttr->u8KeyAction & REMOVEKEY)	  {
 
 			PRINT_D(HOSTINF_DBG, "Removing key\n");
@@ -2822,7 +2822,7 @@ static int Handle_Key(void *drvHandler, tstrHostIFkeyAttr *pstrHostIFkeyAttr)
 
 			s32Error = SendConfigPkt(SET_CFG, strWIDList, 2, true, (u32)pstrWFIDrv);
 
-			WILC_FREE(pu8keybuf);
+			kfree(pu8keybuf);
 
 			/* ////////////////////////// */
 			up(&(pstrWFIDrv->hSemTestKeyBlock));
@@ -2868,15 +2868,15 @@ static int Handle_Key(void *drvHandler, tstrHostIFkeyAttr *pstrHostIFkeyAttr)
 
 			s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
 
-			WILC_FREE(pu8keybuf);
+			kfree(pu8keybuf);
 
 			/* ////////////////////////// */
 			up(&(pstrWFIDrv->hSemTestKeyBlock));
 			/* ///////////////////////// */
 		}
 _WPARxGtk_end_case_:
-		WILC_FREE(pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwpaAttr.pu8key);
-		WILC_FREE(pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwpaAttr.pu8seq);
+		kfree(pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwpaAttr.pu8key);
+		kfree(pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwpaAttr.pu8seq);
 		if (ret == -1)
 			return ret;
 
@@ -2924,7 +2924,7 @@ _WPARxGtk_end_case_:
 			strWIDList[1].s32ValueSize = PTK_KEY_MSG_LEN + 1;
 
 			s32Error = SendConfigPkt(SET_CFG, strWIDList, 2, true, (u32)pstrWFIDrv);
-			WILC_FREE(pu8keybuf);
+			kfree(pu8keybuf);
 
 			/* ////////////////////////// */
 			up(&(pstrWFIDrv->hSemTestKeyBlock));
@@ -2965,7 +2965,7 @@ _WPARxGtk_end_case_:
 			strWID.s32ValueSize = PTK_KEY_MSG_LEN;
 
 			s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
-			WILC_FREE(pu8keybuf);
+			kfree(pu8keybuf);
 
 			/* ////////////////////////// */
 			up(&(pstrWFIDrv->hSemTestKeyBlock));
@@ -2973,7 +2973,7 @@ _WPARxGtk_end_case_:
 		}
 
 _WPAPtk_end_case_:
-		WILC_FREE(pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwpaAttr.pu8key);
+		kfree(pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwpaAttr.pu8key);
 		if (ret == -1)
 			return ret;
 
@@ -3005,7 +3005,7 @@ _WPAPtk_end_case_:
 
 		s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
 
-		WILC_FREE(pu8keybuf);
+		kfree(pu8keybuf);
 		break;
 	}
 
@@ -3099,29 +3099,29 @@ static void Handle_Disconnect(void *drvHandler)
 		/* Deallocation */
 		pstrWFIDrv->strWILC_UsrConnReq.ssidLen = 0;
 		if (pstrWFIDrv->strWILC_UsrConnReq.pu8ssid != NULL) {
-			WILC_FREE(pstrWFIDrv->strWILC_UsrConnReq.pu8ssid);
+			kfree(pstrWFIDrv->strWILC_UsrConnReq.pu8ssid);
 			pstrWFIDrv->strWILC_UsrConnReq.pu8ssid = NULL;
 		}
 
 		if (pstrWFIDrv->strWILC_UsrConnReq.pu8bssid != NULL) {
-			WILC_FREE(pstrWFIDrv->strWILC_UsrConnReq.pu8bssid);
+			kfree(pstrWFIDrv->strWILC_UsrConnReq.pu8bssid);
 			pstrWFIDrv->strWILC_UsrConnReq.pu8bssid = NULL;
 		}
 
 		pstrWFIDrv->strWILC_UsrConnReq.ConnReqIEsLen = 0;
 		if (pstrWFIDrv->strWILC_UsrConnReq.pu8ConnReqIEs != NULL) {
-			WILC_FREE(pstrWFIDrv->strWILC_UsrConnReq.pu8ConnReqIEs);
+			kfree(pstrWFIDrv->strWILC_UsrConnReq.pu8ConnReqIEs);
 			pstrWFIDrv->strWILC_UsrConnReq.pu8ConnReqIEs = NULL;
 		}
 
 
 		/*BugID_5137*/
 		if (gu8FlushedJoinReq != NULL && gu8FlushedJoinReqDrvHandler == (u32)drvHandler) {
-			WILC_FREE(gu8FlushedJoinReq);
+			kfree(gu8FlushedJoinReq);
 			gu8FlushedJoinReq = NULL;
 		}
 		if (gu8FlushedInfoElemAsoc != NULL && gu8FlushedJoinReqDrvHandler == (u32)drvHandler) {
-			WILC_FREE(gu8FlushedInfoElemAsoc);
+			kfree(gu8FlushedInfoElemAsoc);
 			gu8FlushedInfoElemAsoc = NULL;
 		}
 
@@ -4179,7 +4179,7 @@ static s32 Handle_AddBASession(void *drvHandler, tstrHostIfBASessionInfo *strHos
 	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
 
 	if (strWID.ps8WidVal != NULL)
-		WILC_FREE(strWID.ps8WidVal);
+		kfree(strWID.ps8WidVal);
 
 	return s32Error;
 
@@ -4247,7 +4247,7 @@ static s32 Handle_DelBASession(void *drvHandler, tstrHostIfBASessionInfo *strHos
 	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
 
 	if (strWID.ps8WidVal != NULL)
-		WILC_FREE(strWID.ps8WidVal);
+		kfree(strWID.ps8WidVal);
 
 	/*BugID_5222*/
 	up(&hWaitResponse);
@@ -4301,7 +4301,7 @@ static s32 Handle_DelAllRxBASessions(void *drvHandler, tstrHostIfBASessionInfo *
 
 
 	if (strWID.ps8WidVal != NULL)
-		WILC_FREE(strWID.ps8WidVal);
+		kfree(strWID.ps8WidVal);
 
 	/*BugID_5222*/
 	up(&hWaitResponse);
@@ -6619,7 +6619,7 @@ s32 host_int_init(WILC_WFIDrvHandle *phWFIDrv)
 
 _fail_mem_:
 	if (pstrWFIDrv != NULL)
-		WILC_FREE(pstrWFIDrv);
+		kfree(pstrWFIDrv);
 #ifdef WILC_P2P
 _fail_timer_3:
 	WILC_TimerDestroy(&(pstrWFIDrv->hRemainOnChannel), NULL);
@@ -6745,7 +6745,7 @@ s32 host_int_deinit(WILC_WFIDrvHandle hWFIDrv)
 	u32Intialized = 0;
 	/* gWFiDrvHandle = NULL; */
 	if (pstrWFIDrv != NULL) {
-		WILC_FREE(pstrWFIDrv);
+		kfree(pstrWFIDrv);
 		/* pstrWFIDrv=NULL; */
 
 	}
@@ -7126,10 +7126,10 @@ s32 host_int_add_beacon(WILC_WFIDrvHandle hWFIDrv, u32 u32Interval,
 	WILC_CATCH(s32Error)
 	{
 		if (pstrSetBeaconParam->pu8Head != NULL)
-			WILC_FREE(pstrSetBeaconParam->pu8Head);
+			kfree(pstrSetBeaconParam->pu8Head);
 
 		if (pstrSetBeaconParam->pu8Tail != NULL)
-			WILC_FREE(pstrSetBeaconParam->pu8Tail);
+			kfree(pstrSetBeaconParam->pu8Tail);
 	}
 
 	return s32Error;
@@ -7662,7 +7662,7 @@ static void *host_int_ParseJoinBssParam(tstrNetworkInfo *ptstrNetworkInfo)
 void host_int_freeJoinParams(void *pJoinParams)
 {
 	if ((tstrJoinBssParam *)pJoinParams != NULL)
-		WILC_FREE((tstrJoinBssParam *)pJoinParams);
+		kfree((tstrJoinBssParam *)pJoinParams);
 	else
 		PRINT_ER("Unable to FREE null pointer\n");
 }
diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 1384846..30f9c1a 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -2661,7 +2661,7 @@ static void __exit exit_wilc_driver(void)
 
 		linux_wlan_deinit_lock(&close_exit_sync);
 		if (g_linux_wlan != NULL) {
-			WILC_FREE(g_linux_wlan);
+			kfree(g_linux_wlan);
 			g_linux_wlan = NULL;
 		}
 		printk("Module_exit Done.\n");
diff --git a/drivers/staging/wilc1000/wilc_msgqueue.c b/drivers/staging/wilc1000/wilc_msgqueue.c
index 16bcef4..b6b515d 100644
--- a/drivers/staging/wilc1000/wilc_msgqueue.c
+++ b/drivers/staging/wilc1000/wilc_msgqueue.c
@@ -39,7 +39,7 @@ WILC_ErrNo WILC_MsgQueueDestroy(WILC_MsgQueueHandle *pHandle,
 
 	while (pHandle->pstrMessageList != NULL) {
 		Message *pstrMessge = pHandle->pstrMessageList->pstrNext;
-		WILC_FREE(pHandle->pstrMessageList);
+		kfree(pHandle->pstrMessageList);
 		pHandle->pstrMessageList = pstrMessge;
 	}
 
@@ -100,9 +100,9 @@ WILC_ErrNo WILC_MsgQueueSend(WILC_MsgQueueHandle *pHandle,
 		/* error occured, free any allocations */
 		if (pstrMessage != NULL) {
 			if (pstrMessage->pvBuffer != NULL) {
-				WILC_FREE(pstrMessage->pvBuffer);
+				kfree(pstrMessage->pvBuffer);
 			}
-			WILC_FREE(pstrMessage);
+			kfree(pstrMessage);
 		}
 	}
 
@@ -175,8 +175,8 @@ WILC_ErrNo WILC_MsgQueueRecv(WILC_MsgQueueHandle *pHandle,
 
 		pHandle->pstrMessageList = pstrMessage->pstrNext;
 
-		WILC_FREE(pstrMessage->pvBuffer);
-		WILC_FREE(pstrMessage);
+		kfree(pstrMessage->pvBuffer);
+		kfree(pstrMessage);
 
 		spin_unlock_irqrestore(&pHandle->strCriticalSection, flags);
 
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 5c45967..8d9a0a8 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -150,7 +150,7 @@ void clear_shadow_scan(void *pUserVoid)
 
 		for (i = 0; i < u32LastScannedNtwrksCountShadow; i++) {
 			if (astrLastScannedNtwrksShadow[u32LastScannedNtwrksCountShadow].pu8IEs != NULL) {
-				WILC_FREE(astrLastScannedNtwrksShadow[i].pu8IEs);
+				kfree(astrLastScannedNtwrksShadow[i].pu8IEs);
 				astrLastScannedNtwrksShadow[u32LastScannedNtwrksCountShadow].pu8IEs = NULL;
 			}
 
@@ -242,7 +242,7 @@ void remove_network_from_shadow(void *pUserVoid)
 			PRINT_D(CFG80211_DBG, "Network expired in ScanShadow: %s\n", astrLastScannedNtwrksShadow[i].au8ssid);
 
 			if (astrLastScannedNtwrksShadow[i].pu8IEs != NULL) {
-				WILC_FREE(astrLastScannedNtwrksShadow[i].pu8IEs);
+				kfree(astrLastScannedNtwrksShadow[i].pu8IEs);
 				astrLastScannedNtwrksShadow[i].pu8IEs = NULL;
 			}
 
@@ -334,7 +334,7 @@ void add_network_to_shadow(tstrNetworkInfo *pstrNetworkInfo, void *pUserVoid, vo
 	astrLastScannedNtwrksShadow[ap_index].u16IEsLen = pstrNetworkInfo->u16IEsLen;
 	astrLastScannedNtwrksShadow[ap_index].u64Tsf = pstrNetworkInfo->u64Tsf;
 	if (ap_found != -1)
-		WILC_FREE(astrLastScannedNtwrksShadow[ap_index].pu8IEs);
+		kfree(astrLastScannedNtwrksShadow[ap_index].pu8IEs);
 	astrLastScannedNtwrksShadow[ap_index].pu8IEs =
 		(u8 *)WILC_MALLOC(pstrNetworkInfo->u16IEsLen);        /* will be deallocated by the WILC_WFI_CfgScan() function */
 	WILC_memcpy(astrLastScannedNtwrksShadow[ap_index].pu8IEs,
@@ -1219,14 +1219,14 @@ static int WILC_WFI_add_key(struct wiphy *wiphy, struct net_device *netdev, u8 k
 				}
 				/* if there has been previous allocation for the same index through its key, free that memory and allocate again*/
 				if (priv->wilc_gtk[key_index]->key)
-					WILC_FREE(priv->wilc_gtk[key_index]->key);
+					kfree(priv->wilc_gtk[key_index]->key);
 
 				priv->wilc_gtk[key_index]->key = (u8 *)WILC_MALLOC(params->key_len);
 				WILC_memcpy(priv->wilc_gtk[key_index]->key, params->key, params->key_len);
 
 				/* if there has been previous allocation for the same index through its seq, free that memory and allocate again*/
 				if (priv->wilc_gtk[key_index]->seq)
-					WILC_FREE(priv->wilc_gtk[key_index]->seq);
+					kfree(priv->wilc_gtk[key_index]->seq);
 
 				if ((params->seq_len) > 0) {
 					priv->wilc_gtk[key_index]->seq = (u8 *)WILC_MALLOC(params->seq_len);
@@ -1265,12 +1265,12 @@ static int WILC_WFI_add_key(struct wiphy *wiphy, struct net_device *netdev, u8 k
 				}
 
 				if (priv->wilc_ptk[key_index]->key)
-					WILC_FREE(priv->wilc_ptk[key_index]->key);
+					kfree(priv->wilc_ptk[key_index]->key);
 
 				priv->wilc_ptk[key_index]->key = (u8 *)WILC_MALLOC(params->key_len);
 
 				if (priv->wilc_ptk[key_index]->seq)
-					WILC_FREE(priv->wilc_ptk[key_index]->seq);
+					kfree(priv->wilc_ptk[key_index]->seq);
 
 				if ((params->seq_len) > 0)
 					priv->wilc_ptk[key_index]->seq = (u8 *)WILC_MALLOC(params->seq_len);
@@ -1422,7 +1422,7 @@ static int WILC_WFI_del_key(struct wiphy *wiphy, struct net_device *netdev,
 
 		/*Delete saved WEP keys params, if any*/
 		if (g_key_wep_params.key != NULL) {
-			WILC_FREE(g_key_wep_params.key);
+			kfree(g_key_wep_params.key);
 			g_key_wep_params.key = NULL;
 		}
 
@@ -1433,16 +1433,16 @@ static int WILC_WFI_del_key(struct wiphy *wiphy, struct net_device *netdev,
 
 			if (priv->wilc_gtk[key_index]->key != NULL) {
 
-				WILC_FREE(priv->wilc_gtk[key_index]->key);
+				kfree(priv->wilc_gtk[key_index]->key);
 				priv->wilc_gtk[key_index]->key = NULL;
 			}
 			if (priv->wilc_gtk[key_index]->seq) {
 
-				WILC_FREE(priv->wilc_gtk[key_index]->seq);
+				kfree(priv->wilc_gtk[key_index]->seq);
 				priv->wilc_gtk[key_index]->seq = NULL;
 			}
 
-			WILC_FREE(priv->wilc_gtk[key_index]);
+			kfree(priv->wilc_gtk[key_index]);
 			priv->wilc_gtk[key_index] = NULL;
 
 		}
@@ -1451,35 +1451,35 @@ static int WILC_WFI_del_key(struct wiphy *wiphy, struct net_device *netdev,
 
 			if (priv->wilc_ptk[key_index]->key) {
 
-				WILC_FREE(priv->wilc_ptk[key_index]->key);
+				kfree(priv->wilc_ptk[key_index]->key);
 				priv->wilc_ptk[key_index]->key = NULL;
 			}
 			if (priv->wilc_ptk[key_index]->seq) {
 
-				WILC_FREE(priv->wilc_ptk[key_index]->seq);
+				kfree(priv->wilc_ptk[key_index]->seq);
 				priv->wilc_ptk[key_index]->seq = NULL;
 			}
-			WILC_FREE(priv->wilc_ptk[key_index]);
+			kfree(priv->wilc_ptk[key_index]);
 			priv->wilc_ptk[key_index] = NULL;
 		}
 	#endif
 
 		/*Delete saved PTK and GTK keys params, if any*/
 		if (g_key_ptk_params.key != NULL) {
-			WILC_FREE(g_key_ptk_params.key);
+			kfree(g_key_ptk_params.key);
 			g_key_ptk_params.key = NULL;
 		}
 		if (g_key_ptk_params.seq != NULL) {
-			WILC_FREE(g_key_ptk_params.seq);
+			kfree(g_key_ptk_params.seq);
 			g_key_ptk_params.seq = NULL;
 		}
 
 		if (g_key_gtk_params.key != NULL) {
-			WILC_FREE(g_key_gtk_params.key);
+			kfree(g_key_gtk_params.key);
 			g_key_gtk_params.key = NULL;
 		}
 		if (g_key_gtk_params.seq != NULL) {
-			WILC_FREE(g_key_gtk_params.seq);
+			kfree(g_key_gtk_params.seq);
 			g_key_gtk_params.seq = NULL;
 		}
 
-- 
1.9.1

