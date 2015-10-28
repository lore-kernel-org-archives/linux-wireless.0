Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:41718 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755443AbbJ1G64 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 02:58:56 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 13/80] staging: wilc1000: rename strWILC_UsrScanReq of struct host_if_drv
Date: Wed, 28 Oct 2015 15:59:33 +0900
Message-ID: <1446015640-29398-13-git-send-email-glen.lee@atmel.com> (sfid-20151028_081701_624254_142A9014)
In-Reply-To: <1446015640-29398-1-git-send-email-glen.lee@atmel.com>
References: <1446015640-29398-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames strWILC_UsrScanReq of struct host_if_drv to usr_scan_req
to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 78 +++++++++++++++----------------
 drivers/staging/wilc1000/host_interface.h |  2 +-
 2 files changed, 40 insertions(+), 40 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index ab1617f..2df22e2 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -822,8 +822,8 @@ static s32 Handle_Scan(struct host_if_drv *hif_drv,
 	PRINT_D(HOSTINF_DBG, "Setting SCAN params\n");
 	PRINT_D(HOSTINF_DBG, "Scanning: In [%d] state\n", hif_drv->enuHostIFstate);
 
-	hif_drv->strWILC_UsrScanReq.pfUserScanResult = pstrHostIFscanAttr->result;
-	hif_drv->strWILC_UsrScanReq.u32UserScanPvoid = pstrHostIFscanAttr->arg;
+	hif_drv->usr_scan_req.pfUserScanResult = pstrHostIFscanAttr->result;
+	hif_drv->usr_scan_req.u32UserScanPvoid = pstrHostIFscanAttr->arg;
 
 	if ((hif_drv->enuHostIFstate >= HOST_IF_SCANNING) && (hif_drv->enuHostIFstate < HOST_IF_CONNECTED)) {
 		PRINT_D(GENERIC_DBG, "Don't scan we are already in [%d] state\n", hif_drv->enuHostIFstate);
@@ -841,7 +841,7 @@ static s32 Handle_Scan(struct host_if_drv *hif_drv,
 
 	PRINT_D(HOSTINF_DBG, "Setting SCAN params\n");
 
-	hif_drv->strWILC_UsrScanReq.u32RcvdChCount = 0;
+	hif_drv->usr_scan_req.u32RcvdChCount = 0;
 
 	strWIDList[u32WidsCount].id = (u16)WID_SSID_PROBE_REQ;
 	strWIDList[u32WidsCount].type = WID_STR;
@@ -967,10 +967,10 @@ static s32 Handle_ScanDone(struct host_if_drv *hif_drv,
 		return result;
 	}
 
-	if (hif_drv->strWILC_UsrScanReq.pfUserScanResult) {
-		hif_drv->strWILC_UsrScanReq.pfUserScanResult(enuEvent, NULL,
-								hif_drv->strWILC_UsrScanReq.u32UserScanPvoid, NULL);
-		hif_drv->strWILC_UsrScanReq.pfUserScanResult = NULL;
+	if (hif_drv->usr_scan_req.pfUserScanResult) {
+		hif_drv->usr_scan_req.pfUserScanResult(enuEvent, NULL,
+						       hif_drv->usr_scan_req.u32UserScanPvoid, NULL);
+		hif_drv->usr_scan_req.pfUserScanResult = NULL;
 	}
 
 	return result;
@@ -1402,26 +1402,26 @@ static s32 Handle_RcvdNtwrkInfo(struct host_if_drv *hif_drv,
 	bNewNtwrkFound = true;
 	PRINT_INFO(HOSTINF_DBG, "Handling received network info\n");
 
-	if (hif_drv->strWILC_UsrScanReq.pfUserScanResult) {
+	if (hif_drv->usr_scan_req.pfUserScanResult) {
 		PRINT_D(HOSTINF_DBG, "State: Scanning, parsing network information received\n");
 		parse_network_info(pstrRcvdNetworkInfo->buffer, &pstrNetworkInfo);
 		if ((!pstrNetworkInfo) ||
-		    (!hif_drv->strWILC_UsrScanReq.pfUserScanResult)) {
+		    (!hif_drv->usr_scan_req.pfUserScanResult)) {
 			PRINT_ER("driver is null\n");
 			result = -EINVAL;
 			goto done;
 		}
 
-		for (i = 0; i < hif_drv->strWILC_UsrScanReq.u32RcvdChCount; i++) {
-			if ((hif_drv->strWILC_UsrScanReq.astrFoundNetworkInfo[i].au8bssid) &&
+		for (i = 0; i < hif_drv->usr_scan_req.u32RcvdChCount; i++) {
+			if ((hif_drv->usr_scan_req.astrFoundNetworkInfo[i].au8bssid) &&
 			    (pstrNetworkInfo->au8bssid)) {
-				if (memcmp(hif_drv->strWILC_UsrScanReq.astrFoundNetworkInfo[i].au8bssid,
+				if (memcmp(hif_drv->usr_scan_req.astrFoundNetworkInfo[i].au8bssid,
 					   pstrNetworkInfo->au8bssid, 6) == 0) {
-					if (pstrNetworkInfo->s8rssi <= hif_drv->strWILC_UsrScanReq.astrFoundNetworkInfo[i].s8rssi) {
+					if (pstrNetworkInfo->s8rssi <= hif_drv->usr_scan_req.astrFoundNetworkInfo[i].s8rssi) {
 						PRINT_D(HOSTINF_DBG, "Network previously discovered\n");
 						goto done;
 					} else {
-						hif_drv->strWILC_UsrScanReq.astrFoundNetworkInfo[i].s8rssi = pstrNetworkInfo->s8rssi;
+						hif_drv->usr_scan_req.astrFoundNetworkInfo[i].s8rssi = pstrNetworkInfo->s8rssi;
 						bNewNtwrkFound = false;
 						break;
 					}
@@ -1432,30 +1432,30 @@ static s32 Handle_RcvdNtwrkInfo(struct host_if_drv *hif_drv,
 		if (bNewNtwrkFound) {
 			PRINT_D(HOSTINF_DBG, "New network found\n");
 
-			if (hif_drv->strWILC_UsrScanReq.u32RcvdChCount < MAX_NUM_SCANNED_NETWORKS) {
-				hif_drv->strWILC_UsrScanReq.astrFoundNetworkInfo[hif_drv->strWILC_UsrScanReq.u32RcvdChCount].s8rssi = pstrNetworkInfo->s8rssi;
+			if (hif_drv->usr_scan_req.u32RcvdChCount < MAX_NUM_SCANNED_NETWORKS) {
+				hif_drv->usr_scan_req.astrFoundNetworkInfo[hif_drv->usr_scan_req.u32RcvdChCount].s8rssi = pstrNetworkInfo->s8rssi;
 
-				if (hif_drv->strWILC_UsrScanReq.astrFoundNetworkInfo[hif_drv->strWILC_UsrScanReq.u32RcvdChCount].au8bssid &&
+				if (hif_drv->usr_scan_req.astrFoundNetworkInfo[hif_drv->usr_scan_req.u32RcvdChCount].au8bssid &&
 				    pstrNetworkInfo->au8bssid) {
-					memcpy(hif_drv->strWILC_UsrScanReq.astrFoundNetworkInfo[hif_drv->strWILC_UsrScanReq.u32RcvdChCount].au8bssid,
+					memcpy(hif_drv->usr_scan_req.astrFoundNetworkInfo[hif_drv->usr_scan_req.u32RcvdChCount].au8bssid,
 					       pstrNetworkInfo->au8bssid, 6);
 
-					hif_drv->strWILC_UsrScanReq.u32RcvdChCount++;
+					hif_drv->usr_scan_req.u32RcvdChCount++;
 
 					pstrNetworkInfo->bNewNetwork = true;
 					pJoinParams = host_int_ParseJoinBssParam(pstrNetworkInfo);
 
-					hif_drv->strWILC_UsrScanReq.pfUserScanResult(SCAN_EVENT_NETWORK_FOUND, pstrNetworkInfo,
-											hif_drv->strWILC_UsrScanReq.u32UserScanPvoid,
-											pJoinParams);
+					hif_drv->usr_scan_req.pfUserScanResult(SCAN_EVENT_NETWORK_FOUND, pstrNetworkInfo,
+									       hif_drv->usr_scan_req.u32UserScanPvoid,
+									       pJoinParams);
 				}
 			} else {
 				PRINT_WRN(HOSTINF_DBG, "Discovered networks exceeded max. limit\n");
 			}
 		} else {
 			pstrNetworkInfo->bNewNetwork = false;
-			hif_drv->strWILC_UsrScanReq.pfUserScanResult(SCAN_EVENT_NETWORK_FOUND, pstrNetworkInfo,
-									hif_drv->strWILC_UsrScanReq.u32UserScanPvoid, NULL);
+			hif_drv->usr_scan_req.pfUserScanResult(SCAN_EVENT_NETWORK_FOUND, pstrNetworkInfo,
+							       hif_drv->usr_scan_req.u32UserScanPvoid, NULL);
 		}
 	}
 
@@ -1496,7 +1496,7 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct host_if_drv *hif_drv,
 
 	if ((hif_drv->enuHostIFstate == HOST_IF_WAITING_CONN_RESP) ||
 	    (hif_drv->enuHostIFstate == HOST_IF_CONNECTED) ||
-	    hif_drv->strWILC_UsrScanReq.pfUserScanResult) {
+	    hif_drv->usr_scan_req.pfUserScanResult) {
 		if (!pstrRcvdGnrlAsyncInfo->buffer ||
 		    !hif_drv->strWILC_UsrConnReq.pfUserConnectResult) {
 			PRINT_ER("driver is null\n");
@@ -1632,7 +1632,7 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct host_if_drv *hif_drv,
 
 			memset(&strDisconnectNotifInfo, 0, sizeof(tstrDisconnectNotifInfo));
 
-			if (hif_drv->strWILC_UsrScanReq.pfUserScanResult) {
+			if (hif_drv->usr_scan_req.pfUserScanResult) {
 				PRINT_D(HOSTINF_DBG, "\n\n<< Abort the running OBSS Scan >>\n\n");
 				del_timer(&hif_drv->hScanTimer);
 				Handle_ScanDone((void *)hif_drv, SCAN_EVENT_ABORTED);
@@ -1678,12 +1678,12 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct host_if_drv *hif_drv,
 			scan_while_connected = false;
 
 		} else if ((u8MacStatus == MAC_DISCONNECTED) &&
-			   (hif_drv->strWILC_UsrScanReq.pfUserScanResult)) {
+			   (hif_drv->usr_scan_req.pfUserScanResult)) {
 			PRINT_D(HOSTINF_DBG, "Received MAC_DISCONNECTED from the FW while scanning\n");
 			PRINT_D(HOSTINF_DBG, "\n\n<< Abort the running Scan >>\n\n");
 
 			del_timer(&hif_drv->hScanTimer);
-			if (hif_drv->strWILC_UsrScanReq.pfUserScanResult)
+			if (hif_drv->usr_scan_req.pfUserScanResult)
 				Handle_ScanDone(hif_drv, SCAN_EVENT_ABORTED);
 		}
 	}
@@ -1997,12 +1997,12 @@ static void Handle_Disconnect(struct host_if_drv *hif_drv)
 		strDisconnectNotifInfo.ie = NULL;
 		strDisconnectNotifInfo.ie_len = 0;
 
-		if (hif_drv->strWILC_UsrScanReq.pfUserScanResult) {
+		if (hif_drv->usr_scan_req.pfUserScanResult) {
 			del_timer(&hif_drv->hScanTimer);
-			hif_drv->strWILC_UsrScanReq.pfUserScanResult(SCAN_EVENT_ABORTED, NULL,
-									hif_drv->strWILC_UsrScanReq.u32UserScanPvoid, NULL);
+			hif_drv->usr_scan_req.pfUserScanResult(SCAN_EVENT_ABORTED, NULL,
+							       hif_drv->usr_scan_req.u32UserScanPvoid, NULL);
 
-			hif_drv->strWILC_UsrScanReq.pfUserScanResult = NULL;
+			hif_drv->usr_scan_req.pfUserScanResult = NULL;
 		}
 
 		if (hif_drv->strWILC_UsrConnReq.pfUserConnectResult) {
@@ -2487,7 +2487,7 @@ static int Handle_RemainOnChan(struct host_if_drv *hif_drv,
 		pstrHostIfRemainOnChan->u16Channel = hif_drv->strHostIfRemainOnChan.u16Channel;
 	}
 
-	if (hif_drv->strWILC_UsrScanReq.pfUserScanResult) {
+	if (hif_drv->usr_scan_req.pfUserScanResult) {
 		PRINT_INFO(GENERIC_DBG, "Required to remain on chan while scanning return\n");
 		hif_drv->u8RemainOnChan_pendingreq = 1;
 		result = -EBUSY;
@@ -2829,7 +2829,7 @@ static int hostIFthread(void *pvArg)
 		}
 
 		if (msg.id == HOST_IF_MSG_CONNECT &&
-		    hif_drv->strWILC_UsrScanReq.pfUserScanResult) {
+		    hif_drv->usr_scan_req.pfUserScanResult) {
 			PRINT_D(HOSTINF_DBG, "Requeue connect request till scan done received\n");
 			wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 			usleep_range(2 * 1000, 2 * 1000);
@@ -4201,11 +4201,11 @@ s32 host_int_deinit(struct host_if_drv *hif_drv)
 	host_int_set_wfi_drv_handler(NULL);
 	down(&hif_sema_driver);
 
-	if (hif_drv->strWILC_UsrScanReq.pfUserScanResult) {
-		hif_drv->strWILC_UsrScanReq.pfUserScanResult(SCAN_EVENT_ABORTED, NULL,
-								hif_drv->strWILC_UsrScanReq.u32UserScanPvoid, NULL);
+	if (hif_drv->usr_scan_req.pfUserScanResult) {
+		hif_drv->usr_scan_req.pfUserScanResult(SCAN_EVENT_ABORTED, NULL,
+						       hif_drv->usr_scan_req.u32UserScanPvoid, NULL);
 
-		hif_drv->strWILC_UsrScanReq.pfUserScanResult = NULL;
+		hif_drv->usr_scan_req.pfUserScanResult = NULL;
 	}
 
 	hif_drv->enuHostIFstate = HOST_IF_IDLE;
@@ -4329,7 +4329,7 @@ void host_int_ScanCompleteReceived(u8 *pu8Buffer, u32 u32Length)
 	if (!hif_drv || hif_drv == terminated_handle)
 		return;
 
-	if (hif_drv->strWILC_UsrScanReq.pfUserScanResult) {
+	if (hif_drv->usr_scan_req.pfUserScanResult) {
 		memset(&msg, 0, sizeof(struct host_if_msg));
 
 		msg.id = HOST_IF_MSG_RCVD_SCAN_COMPLETE;
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 7fb1551..fc9e96c 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -292,7 +292,7 @@ enum p2p_listen_state {
 };
 
 struct host_if_drv {
-	struct user_scan_req strWILC_UsrScanReq;
+	struct user_scan_req usr_scan_req;
 	struct user_conn_req strWILC_UsrConnReq;
 
 	/*Remain on channel struvture*/
-- 
1.9.1

