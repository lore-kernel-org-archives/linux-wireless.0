Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:33790 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752561AbbI3C46 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Sep 2015 22:56:58 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH RESEND 1/2] staging: wilc1000: remove define WILC_PARSE_SCAN_IN_HOST
Date: Wed, 30 Sep 2015 11:59:23 +0900
Message-ID: <1443581964-31505-1-git-send-email-glen.lee@atmel.com> (sfid-20150930_045702_337190_BF90C4E8)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The define WILC_PARSE_SCAN_IN_HOST is always used in the driver, so just
delete ifdef WILC_PARSE_SCAN_IN_HOST line, ifndef WILC_PARSE_SCAN_IN_HOST
line and it's related codes. Finally, remove define in Makefile.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/Makefile         |  1 -
 drivers/staging/wilc1000/host_interface.c | 62 -------------------------------
 drivers/staging/wilc1000/wilc_wlan_if.h   |  3 +-
 3 files changed, 1 insertion(+), 65 deletions(-)

diff --git a/drivers/staging/wilc1000/Makefile b/drivers/staging/wilc1000/Makefile
index afae7d6..ac15e5a 100644
--- a/drivers/staging/wilc1000/Makefile
+++ b/drivers/staging/wilc1000/Makefile
@@ -10,7 +10,6 @@ ccflags-y += -DSTA_FIRMWARE=\"atmel/wilc1000_fw.bin\" \
 
 ccflags-y += -I$(src)/ -D__CHECK_ENDIAN__ -DWILC_ASIC_A0 \
 		-DPLL_WORKAROUND -DCONNECT_DIRECT  -DAGING_ALG \
-		-DWILC_PARSE_SCAN_IN_HOST \
 		-Wno-unused-function -DWILC_DEBUGFS
 #ccflags-y += -DTCP_ACK_FILTER
 
diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 99de804..ab16bf6 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -463,7 +463,6 @@ typedef struct _tstrWidJoinReqExt {
 } tstrWidJoinReqExt;
 #endif
 
-#ifdef WILC_PARSE_SCAN_IN_HOST
 /*Struct containg joinParam of each AP*/
 typedef struct _tstrJoinBssParam {
 	BSSTYPE_T bss_type;
@@ -500,7 +499,6 @@ typedef struct _tstrBssTable {
 	tstrJoinBssParam *head;
 	tstrJoinBssParam *tail;
 } tstrBssTable;
-#endif /*WILC_PARSE_SCAN_IN_HOST*/
 
 typedef enum {
 	SCAN_TIMER = 0,
@@ -560,9 +558,7 @@ tstrWILC_WFIDrv *gu8FlushedJoinReqDrvHandler;
 #define FLUSHED_JOIN_REQ 1
 #define FLUSHED_BYTE_POS 79     /* Position the byte indicating flushing in the flushed request */
 
-#ifdef WILC_PARSE_SCAN_IN_HOST
 static void *host_int_ParseJoinBssParam(tstrNetworkInfo *ptstrNetworkInfo);
-#endif /*WILC_PARSE_SCAN_IN_HOST*/
 
 extern void chip_sleep_manually(u32 u32SleepTime);
 extern int linux_wlan_get_num_conn_ifcs(void);
@@ -1517,10 +1513,7 @@ static s32 Handle_Connect(tstrWILC_WFIDrv *drvHandler,
 	wid_site_survey_reslts_s *pstrSurveyResults = NULL;
 	#else
 	u8 *pu8CurrByte = NULL;
-	#ifdef WILC_PARSE_SCAN_IN_HOST
 	tstrJoinBssParam *ptstrJoinBssParam;
-	#endif /*WILC_PARSE_SCAN_IN_HOST*/
-
 	#endif
 
 	PRINT_D(GENERIC_DBG, "Handling connect request\n");
@@ -1692,14 +1685,12 @@ static s32 Handle_Connect(tstrWILC_WFIDrv *drvHandler,
 
 	PRINT_INFO(HOSTINF_DBG, "Saving connection parameters in global structure\n");
 
-	#ifdef WILC_PARSE_SCAN_IN_HOST
 	ptstrJoinBssParam = (tstrJoinBssParam *)pstrHostIFconnectAttr->pJoinParams;
 	if (ptstrJoinBssParam == NULL) {
 		PRINT_ER("Required BSSID not found\n");
 		s32Error = -ENOENT;
 		goto ERRORHANDLER;
 	}
-	#endif /*WILC_PARSE_SCAN_IN_HOST*/
 
 	if (pstrHostIFconnectAttr->pu8bssid != NULL) {
 		pstrWFIDrv->strWILC_UsrConnReq.pu8bssid = kmalloc(6, GFP_KERNEL);
@@ -1795,40 +1786,6 @@ static s32 Handle_Connect(tstrWILC_WFIDrv *drvHandler,
 	PRINT_D(HOSTINF_DBG, "Connecting to network of SSID %s on channel %d\n",
 		pstrWFIDrv->strWILC_UsrConnReq.pu8ssid, pstrHostIFconnectAttr->u8channel);
 
-
-#ifndef WILC_PARSE_SCAN_IN_HOST
-	strWIDList[u32WidsCount].u16WIDid = (u16)WID_JOIN_REQ_EXTENDED;
-	strWIDList[u32WidsCount].enuWIDtype = WID_STR;
-	strWIDList[u32WidsCount].s32ValueSize = MAX_SSID_LEN + 7;
-	strWIDList[u32WidsCount].ps8WidVal = kmalloc(strWIDList[u32WidsCount].s32ValueSize, GFP_KERNEL);
-
-	if (strWIDList[u32WidsCount].ps8WidVal == NULL) {
-		s32Error = -EFAULT;
-		goto ERRORHANDLER;
-	}
-
-	pu8CurrByte = strWIDList[u32WidsCount].ps8WidVal;
-
-	if (pstrHostIFconnectAttr->pu8ssid != NULL) {
-		memcpy(pu8CurrByte, pstrHostIFconnectAttr->pu8ssid, pstrHostIFconnectAttr->ssidLen);
-		pu8CurrByte[pstrHostIFconnectAttr->ssidLen] = '\0';
-	}
-	pu8CurrByte += MAX_SSID_LEN;
-	if ((pstrHostIFconnectAttr->u8channel >= 1) && (pstrHostIFconnectAttr->u8channel <= 14)) {
-		*(pu8CurrByte++) = pstrHostIFconnectAttr->u8channel;
-	} else {
-		PRINT_ER("Channel out of range\n");
-		*(pu8CurrByte++) = 0xFF;
-	}
-	if (pstrHostIFconnectAttr->pu8bssid != NULL)
-		memcpy(pu8CurrByte, pstrHostIFconnectAttr->pu8bssid, 6);
-	pu8CurrByte += 6;
-
-	/* keep the buffer at the start of the allocated pointer to use it with the free*/
-	pu8CurrByte = strWIDList[u32WidsCount].ps8WidVal;
-
-	#else
-
 	strWIDList[u32WidsCount].u16WIDid = (u16)WID_JOIN_REQ_EXTENDED;
 	strWIDList[u32WidsCount].enuWIDtype = WID_STR;
 
@@ -1958,9 +1915,6 @@ static s32 Handle_Connect(tstrWILC_WFIDrv *drvHandler,
 
 	/* keep the buffer at the start of the allocated pointer to use it with the free*/
 	pu8CurrByte = strWIDList[u32WidsCount].ps8WidVal;
-
-
-	#endif /* #ifdef WILC_PARSE_SCAN_IN_HOST*/
 	u32WidsCount++;
 
 	/* A temporary workaround to avoid handling the misleading MAC_DISCONNECTED raised from the
@@ -2100,8 +2054,6 @@ static s32 Handle_FlushConnect(tstrWILC_WFIDrv *drvHandler)
 	strWIDList[u32WidsCount].ps8WidVal = (s8 *)(&gu8FlushedAuthType);
 	u32WidsCount++;
 
-
-	#ifdef WILC_PARSE_SCAN_IN_HOST
 	strWIDList[u32WidsCount].u16WIDid = (u16)WID_JOIN_REQ_EXTENDED;
 	strWIDList[u32WidsCount].enuWIDtype = WID_STR;
 	strWIDList[u32WidsCount].s32ValueSize = gu32FlushedJoinReqSize;
@@ -2113,8 +2065,6 @@ static s32 Handle_FlushConnect(tstrWILC_WFIDrv *drvHandler)
 
 	u32WidsCount++;
 
-	#endif
-
 	s32Error = send_config_pkt(SET_CFG, strWIDList, u32WidsCount, false,
 				   get_id_from_handler(gu8FlushedJoinReqDrvHandler));
 	if (s32Error) {
@@ -2314,9 +2264,7 @@ static s32 Handle_RcvdNtwrkInfo(tstrWILC_WFIDrv *drvHandler,
 
 					pstrNetworkInfo->bNewNetwork = true;
 					/* add new BSS to JoinBssTable */
-				#ifdef WILC_PARSE_SCAN_IN_HOST
 					pJoinParams = host_int_ParseJoinBssParam(pstrNetworkInfo);
-				#endif /*WILC_PARSE_SCAN_IN_HOST*/
 
 					pstrWFIDrv->strWILC_UsrScanReq.pfUserScanResult(SCAN_EVENT_NETWORK_FOUND, pstrNetworkInfo,
 											pstrWFIDrv->strWILC_UsrScanReq.u32UserScanPvoid,
@@ -2530,12 +2478,8 @@ static s32 Handle_RcvdGnrlAsyncInfo(tstrWILC_WFIDrv *drvHandler,
 				mod_timer(&hDuringIpTimer,
 					  jiffies + msecs_to_jiffies(10000));
 
-				#ifdef WILC_PARSE_SCAN_IN_HOST
 				/* open a BA session if possible */
 				/* if(pstrWFIDrv->strWILC_UsrConnReq.IsHTCapable) */
-
-				#endif
-
 				/* host_int_addBASession(pstrWFIDrv->strWILC_UsrConnReq.pu8bssid,0, */
 				/* BA_SESSION_DEFAULT_BUFFER_SIZE,BA_SESSION_DEFAULT_TIMEOUT); */
 			} else {
@@ -7219,10 +7163,6 @@ s32 host_int_setup_multicast_filter(tstrWILC_WFIDrv *hWFIDrv, bool bIsEnabled, u
 	return s32Error;
 }
 
-
-
-#ifdef WILC_PARSE_SCAN_IN_HOST
-
 /**
  *  @brief              host_int_ParseJoinBssParam
  *  @details            Parse Needed Join Parameters and save it in a new JoinBssParam entry
@@ -7440,8 +7380,6 @@ void host_int_freeJoinParams(void *pJoinParams)
 	else
 		PRINT_ER("Unable to FREE null pointer\n");
 }
-#endif  /*WILC_PARSE_SCAN_IN_HOST*/
-
 
 /**
  *  @brief              host_int_addBASession
diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
index 2d6e0ce..19a23d3 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -147,7 +147,6 @@ typedef struct {
 
 #define INFINITE_SLEEP_TIME	((u32)0xFFFFFFFF)
 
-#ifdef WILC_PARSE_SCAN_IN_HOST
 typedef enum {
 	SUPP_RATES_IE		= 1,
 	EXT_SUPP_RATES_IE	= 50,
@@ -157,7 +156,7 @@ typedef enum {
 	WMM_IE			= 221,
 	P2P_IE			= 221,
 } BEACON_IE;
-#endif
+
 typedef enum {
 	INFRASTRUCTURE		= 0,
 	INDEPENDENT,
-- 
1.9.1

