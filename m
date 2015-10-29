Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:5062 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756195AbbJ2C7B (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 22:59:01 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 27/64] staging: wilc1000: rename pfUserScanResult of struct user_scan_req
Date: Thu, 29 Oct 2015 11:58:50 +0900
Message-ID: <1446087567-16728-27-git-send-email-glen.lee@atmel.com> (sfid-20151029_041658_175184_2483DF58)
In-Reply-To: <1446087567-16728-1-git-send-email-glen.lee@atmel.com>
References: <1446087567-16728-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames pfUserScanResult of struct user_scan_req to scan_result
to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 56 +++++++++++++++----------------
 drivers/staging/wilc1000/host_interface.h |  2 +-
 2 files changed, 28 insertions(+), 30 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 5bc85dd..a1437e2 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -822,7 +822,7 @@ static s32 Handle_Scan(struct host_if_drv *hif_drv,
 	PRINT_D(HOSTINF_DBG, "Setting SCAN params\n");
 	PRINT_D(HOSTINF_DBG, "Scanning: In [%d] state\n", hif_drv->hif_state);
 
-	hif_drv->usr_scan_req.pfUserScanResult = pstrHostIFscanAttr->result;
+	hif_drv->usr_scan_req.scan_result = pstrHostIFscanAttr->result;
 	hif_drv->usr_scan_req.u32UserScanPvoid = pstrHostIFscanAttr->arg;
 
 	if ((hif_drv->hif_state >= HOST_IF_SCANNING) &&
@@ -969,10 +969,10 @@ static s32 Handle_ScanDone(struct host_if_drv *hif_drv,
 		return result;
 	}
 
-	if (hif_drv->usr_scan_req.pfUserScanResult) {
-		hif_drv->usr_scan_req.pfUserScanResult(enuEvent, NULL,
-						       hif_drv->usr_scan_req.u32UserScanPvoid, NULL);
-		hif_drv->usr_scan_req.pfUserScanResult = NULL;
+	if (hif_drv->usr_scan_req.scan_result) {
+		hif_drv->usr_scan_req.scan_result(enuEvent, NULL,
+						  hif_drv->usr_scan_req.u32UserScanPvoid, NULL);
+		hif_drv->usr_scan_req.scan_result = NULL;
 	}
 
 	return result;
@@ -1404,11 +1404,11 @@ static s32 Handle_RcvdNtwrkInfo(struct host_if_drv *hif_drv,
 	bNewNtwrkFound = true;
 	PRINT_INFO(HOSTINF_DBG, "Handling received network info\n");
 
-	if (hif_drv->usr_scan_req.pfUserScanResult) {
+	if (hif_drv->usr_scan_req.scan_result) {
 		PRINT_D(HOSTINF_DBG, "State: Scanning, parsing network information received\n");
 		parse_network_info(pstrRcvdNetworkInfo->buffer, &pstrNetworkInfo);
 		if ((!pstrNetworkInfo) ||
-		    (!hif_drv->usr_scan_req.pfUserScanResult)) {
+		    (!hif_drv->usr_scan_req.scan_result)) {
 			PRINT_ER("driver is null\n");
 			result = -EINVAL;
 			goto done;
@@ -1447,17 +1447,17 @@ static s32 Handle_RcvdNtwrkInfo(struct host_if_drv *hif_drv,
 					pstrNetworkInfo->bNewNetwork = true;
 					pJoinParams = host_int_ParseJoinBssParam(pstrNetworkInfo);
 
-					hif_drv->usr_scan_req.pfUserScanResult(SCAN_EVENT_NETWORK_FOUND, pstrNetworkInfo,
-									       hif_drv->usr_scan_req.u32UserScanPvoid,
-									       pJoinParams);
+					hif_drv->usr_scan_req.scan_result(SCAN_EVENT_NETWORK_FOUND, pstrNetworkInfo,
+									  hif_drv->usr_scan_req.u32UserScanPvoid,
+									  pJoinParams);
 				}
 			} else {
 				PRINT_WRN(HOSTINF_DBG, "Discovered networks exceeded max. limit\n");
 			}
 		} else {
 			pstrNetworkInfo->bNewNetwork = false;
-			hif_drv->usr_scan_req.pfUserScanResult(SCAN_EVENT_NETWORK_FOUND, pstrNetworkInfo,
-							       hif_drv->usr_scan_req.u32UserScanPvoid, NULL);
+			hif_drv->usr_scan_req.scan_result(SCAN_EVENT_NETWORK_FOUND, pstrNetworkInfo,
+							  hif_drv->usr_scan_req.u32UserScanPvoid, NULL);
 		}
 	}
 
@@ -1498,7 +1498,7 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct host_if_drv *hif_drv,
 
 	if ((hif_drv->hif_state == HOST_IF_WAITING_CONN_RESP) ||
 	    (hif_drv->hif_state == HOST_IF_CONNECTED) ||
-	    hif_drv->usr_scan_req.pfUserScanResult) {
+	    hif_drv->usr_scan_req.scan_result) {
 		if (!pstrRcvdGnrlAsyncInfo->buffer ||
 		    !hif_drv->usr_conn_req.pfUserConnectResult) {
 			PRINT_ER("driver is null\n");
@@ -1634,7 +1634,7 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct host_if_drv *hif_drv,
 
 			memset(&strDisconnectNotifInfo, 0, sizeof(tstrDisconnectNotifInfo));
 
-			if (hif_drv->usr_scan_req.pfUserScanResult) {
+			if (hif_drv->usr_scan_req.scan_result) {
 				PRINT_D(HOSTINF_DBG, "\n\n<< Abort the running OBSS Scan >>\n\n");
 				del_timer(&hif_drv->scan_timer);
 				Handle_ScanDone((void *)hif_drv, SCAN_EVENT_ABORTED);
@@ -1679,12 +1679,12 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct host_if_drv *hif_drv,
 			scan_while_connected = false;
 
 		} else if ((u8MacStatus == MAC_DISCONNECTED) &&
-			   (hif_drv->usr_scan_req.pfUserScanResult)) {
+			   (hif_drv->usr_scan_req.scan_result)) {
 			PRINT_D(HOSTINF_DBG, "Received MAC_DISCONNECTED from the FW while scanning\n");
 			PRINT_D(HOSTINF_DBG, "\n\n<< Abort the running Scan >>\n\n");
 
 			del_timer(&hif_drv->scan_timer);
-			if (hif_drv->usr_scan_req.pfUserScanResult)
+			if (hif_drv->usr_scan_req.scan_result)
 				Handle_ScanDone(hif_drv, SCAN_EVENT_ABORTED);
 		}
 	}
@@ -1998,12 +1998,11 @@ static void Handle_Disconnect(struct host_if_drv *hif_drv)
 		strDisconnectNotifInfo.ie = NULL;
 		strDisconnectNotifInfo.ie_len = 0;
 
-		if (hif_drv->usr_scan_req.pfUserScanResult) {
+		if (hif_drv->usr_scan_req.scan_result) {
 			del_timer(&hif_drv->scan_timer);
-			hif_drv->usr_scan_req.pfUserScanResult(SCAN_EVENT_ABORTED, NULL,
-							       hif_drv->usr_scan_req.u32UserScanPvoid, NULL);
-
-			hif_drv->usr_scan_req.pfUserScanResult = NULL;
+			hif_drv->usr_scan_req.scan_result(SCAN_EVENT_ABORTED, NULL,
+							  hif_drv->usr_scan_req.u32UserScanPvoid, NULL);
+			hif_drv->usr_scan_req.scan_result = NULL;
 		}
 
 		if (hif_drv->usr_conn_req.pfUserConnectResult) {
@@ -2489,7 +2488,7 @@ static int Handle_RemainOnChan(struct host_if_drv *hif_drv,
 		pstrHostIfRemainOnChan->ch = hif_drv->remain_on_ch.ch;
 	}
 
-	if (hif_drv->usr_scan_req.pfUserScanResult) {
+	if (hif_drv->usr_scan_req.scan_result) {
 		PRINT_INFO(GENERIC_DBG, "Required to remain on chan while scanning return\n");
 		hif_drv->remain_on_ch_pending = 1;
 		result = -EBUSY;
@@ -2833,7 +2832,7 @@ static int hostIFthread(void *pvArg)
 		}
 
 		if (msg.id == HOST_IF_MSG_CONNECT &&
-		    hif_drv->usr_scan_req.pfUserScanResult) {
+		    hif_drv->usr_scan_req.scan_result) {
 			PRINT_D(HOSTINF_DBG, "Requeue connect request till scan done received\n");
 			wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 			usleep_range(2 * 1000, 2 * 1000);
@@ -4209,11 +4208,10 @@ s32 host_int_deinit(struct host_if_drv *hif_drv)
 	host_int_set_wfi_drv_handler(NULL);
 	down(&hif_sema_driver);
 
-	if (hif_drv->usr_scan_req.pfUserScanResult) {
-		hif_drv->usr_scan_req.pfUserScanResult(SCAN_EVENT_ABORTED, NULL,
-						       hif_drv->usr_scan_req.u32UserScanPvoid, NULL);
-
-		hif_drv->usr_scan_req.pfUserScanResult = NULL;
+	if (hif_drv->usr_scan_req.scan_result) {
+		hif_drv->usr_scan_req.scan_result(SCAN_EVENT_ABORTED, NULL,
+						  hif_drv->usr_scan_req.u32UserScanPvoid, NULL);
+		hif_drv->usr_scan_req.scan_result = NULL;
 	}
 
 	hif_drv->hif_state = HOST_IF_IDLE;
@@ -4337,7 +4335,7 @@ void host_int_ScanCompleteReceived(u8 *pu8Buffer, u32 u32Length)
 	if (!hif_drv || hif_drv == terminated_handle)
 		return;
 
-	if (hif_drv->usr_scan_req.pfUserScanResult) {
+	if (hif_drv->usr_scan_req.scan_result) {
 		memset(&msg, 0, sizeof(struct host_if_msg));
 
 		msg.id = HOST_IF_MSG_RCVD_SCAN_COMPLETE;
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 486c647..b90d9d2 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -192,7 +192,7 @@ struct hidden_network {
 };
 
 struct user_scan_req {
-	wilc_scan_result pfUserScanResult;
+	wilc_scan_result scan_result;
 	void *u32UserScanPvoid;
 
 	u32 u32RcvdChCount;
-- 
1.9.1

