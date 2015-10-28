Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:42608 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755152AbbJ1HCa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 03:02:30 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 49/80] staging: wilc1000: rename pfUserConnectResult of struct user_conn_req
Date: Wed, 28 Oct 2015 16:00:09 +0900
Message-ID: <1446015640-29398-49-git-send-email-glen.lee@atmel.com> (sfid-20151028_080233_040751_566E4E5C)
In-Reply-To: <1446015640-29398-1-git-send-email-glen.lee@atmel.com>
References: <1446015640-29398-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames pfUserConnectResult of struct user_conn_req to conn_result
to avoid CamelCase naming convention.
And, some comments modification that has been included
name 'pfUserConnectResult'.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 57 +++++++++++++++++--------------
 drivers/staging/wilc1000/host_interface.h |  2 +-
 2 files changed, 32 insertions(+), 27 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 148c82a..0b65504 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1029,7 +1029,7 @@ static s32 Handle_Connect(struct host_if_drv *hif_drv,
 
 	hif_drv->usr_conn_req.u8security = pstrHostIFconnectAttr->security;
 	hif_drv->usr_conn_req.tenuAuth_type = pstrHostIFconnectAttr->auth_type;
-	hif_drv->usr_conn_req.pfUserConnectResult = pstrHostIFconnectAttr->result;
+	hif_drv->usr_conn_req.conn_result = pstrHostIFconnectAttr->result;
 	hif_drv->usr_conn_req.u32UserConnectPvoid = pstrHostIFconnectAttr->arg;
 
 	strWIDList[u32WidsCount].id = WID_SUCCESS_FRAME_COUNT;
@@ -1333,7 +1333,7 @@ static s32 Handle_ConnectTimeout(struct host_if_drv *hif_drv)
 
 	memset(&strConnectInfo, 0, sizeof(tstrConnectInfo));
 
-	if (hif_drv->usr_conn_req.pfUserConnectResult) {
+	if (hif_drv->usr_conn_req.conn_result) {
 		if (hif_drv->usr_conn_req.pu8bssid) {
 			memcpy(strConnectInfo.au8bssid,
 			       hif_drv->usr_conn_req.pu8bssid, 6);
@@ -1347,11 +1347,11 @@ static s32 Handle_ConnectTimeout(struct host_if_drv *hif_drv)
 			       hif_drv->usr_conn_req.ies_len);
 		}
 
-		hif_drv->usr_conn_req.pfUserConnectResult(CONN_DISCONN_EVENT_CONN_RESP,
-							  &strConnectInfo,
-							  MAC_DISCONNECTED,
-							  NULL,
-							  hif_drv->usr_conn_req.u32UserConnectPvoid);
+		hif_drv->usr_conn_req.conn_result(CONN_DISCONN_EVENT_CONN_RESP,
+						  &strConnectInfo,
+						  MAC_DISCONNECTED,
+						  NULL,
+						  hif_drv->usr_conn_req.u32UserConnectPvoid);
 
 		kfree(strConnectInfo.pu8ReqIEs);
 		strConnectInfo.pu8ReqIEs = NULL;
@@ -1500,7 +1500,7 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct host_if_drv *hif_drv,
 	    (hif_drv->hif_state == HOST_IF_CONNECTED) ||
 	    hif_drv->usr_scan_req.scan_result) {
 		if (!pstrRcvdGnrlAsyncInfo->buffer ||
-		    !hif_drv->usr_conn_req.pfUserConnectResult) {
+		    !hif_drv->usr_conn_req.conn_result) {
 			PRINT_ER("driver is null\n");
 			return -EINVAL;
 		}
@@ -1595,11 +1595,11 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct host_if_drv *hif_drv,
 			}
 
 			del_timer(&hif_drv->connect_timer);
-			hif_drv->usr_conn_req.pfUserConnectResult(CONN_DISCONN_EVENT_CONN_RESP,
-								  &strConnectInfo,
-								  u8MacStatus,
-								  NULL,
-								  hif_drv->usr_conn_req.u32UserConnectPvoid);
+			hif_drv->usr_conn_req.conn_result(CONN_DISCONN_EVENT_CONN_RESP,
+							  &strConnectInfo,
+							  u8MacStatus,
+							  NULL,
+							  hif_drv->usr_conn_req.u32UserConnectPvoid);
 
 			if ((u8MacStatus == MAC_CONNECTED) &&
 			    (strConnectInfo.u16ConnectStatus == SUCCESSFUL_STATUSCODE))	{
@@ -1644,15 +1644,15 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct host_if_drv *hif_drv,
 			strDisconnectNotifInfo.ie = NULL;
 			strDisconnectNotifInfo.ie_len = 0;
 
-			if (hif_drv->usr_conn_req.pfUserConnectResult) {
+			if (hif_drv->usr_conn_req.conn_result) {
 				g_obtainingIP = false;
 				host_int_set_power_mgmt(hif_drv, 0, 0);
 
-				hif_drv->usr_conn_req.pfUserConnectResult(CONN_DISCONN_EVENT_DISCONN_NOTIF,
-									  NULL,
-									  0,
-									  &strDisconnectNotifInfo,
-									  hif_drv->usr_conn_req.u32UserConnectPvoid);
+				hif_drv->usr_conn_req.conn_result(CONN_DISCONN_EVENT_DISCONN_NOTIF,
+								  NULL,
+								  0,
+								  &strDisconnectNotifInfo,
+								  hif_drv->usr_conn_req.u32UserConnectPvoid);
 			} else {
 				PRINT_ER("Connect result callback function is NULL\n");
 			}
@@ -2001,21 +2001,26 @@ static void Handle_Disconnect(struct host_if_drv *hif_drv)
 
 		if (hif_drv->usr_scan_req.scan_result) {
 			del_timer(&hif_drv->scan_timer);
-			hif_drv->usr_scan_req.scan_result(SCAN_EVENT_ABORTED, NULL,
-							  hif_drv->usr_scan_req.arg, NULL);
+			hif_drv->usr_scan_req.scan_result(SCAN_EVENT_ABORTED,
+							  NULL,
+							  hif_drv->usr_scan_req.arg,
+							  NULL);
 			hif_drv->usr_scan_req.scan_result = NULL;
 		}
 
-		if (hif_drv->usr_conn_req.pfUserConnectResult) {
+		if (hif_drv->usr_conn_req.conn_result) {
 			if (hif_drv->hif_state == HOST_IF_WAITING_CONN_RESP) {
 				PRINT_D(HOSTINF_DBG, "Upper layer requested termination of connection\n");
 				del_timer(&hif_drv->connect_timer);
 			}
 
-			hif_drv->usr_conn_req.pfUserConnectResult(CONN_DISCONN_EVENT_DISCONN_NOTIF, NULL,
-								  0, &strDisconnectNotifInfo, hif_drv->usr_conn_req.u32UserConnectPvoid);
+			hif_drv->usr_conn_req.conn_result(CONN_DISCONN_EVENT_DISCONN_NOTIF,
+							  NULL,
+							  0,
+							  &strDisconnectNotifInfo,
+							  hif_drv->usr_conn_req.u32UserConnectPvoid);
 		} else {
-			PRINT_ER("usr_conn_req.pfUserConnectResult = NULL\n");
+			PRINT_ER("usr_conn_req.conn_result = NULL\n");
 		}
 
 		scan_while_connected = false;
@@ -4301,7 +4306,7 @@ void GnrlAsyncInfoReceived(u8 *pu8Buffer, u32 u32Length)
 		return;
 	}
 
-	if (!hif_drv->usr_conn_req.pfUserConnectResult) {
+	if (!hif_drv->usr_conn_req.conn_result) {
 		PRINT_ER("Received mac status is not needed when there is no current Connect Reques\n");
 		up(&hif_sema_deinit);
 		return;
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 96343f2..e5b0407 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -206,7 +206,7 @@ struct user_conn_req {
 	size_t ssid_len;
 	u8 *ies;
 	size_t ies_len;
-	wilc_connect_result pfUserConnectResult;
+	wilc_connect_result conn_result;
 	bool IsHTCapable;
 	void *u32UserConnectPvoid;
 };
-- 
1.9.1

