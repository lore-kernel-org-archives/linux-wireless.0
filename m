Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:6511 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714AbbJOE3R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Oct 2015 00:29:17 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 34/40] staging: wilc1000: rename variable gu8FlushedJoinReqDrvHandler
Date: Thu, 15 Oct 2015 13:25:15 +0900
Message-ID: <1444883121-31757-34-git-send-email-tony.cho@atmel.com> (sfid-20151015_064658_368424_C31FD400)
In-Reply-To: <1444883121-31757-1-git-send-email-tony.cho@atmel.com>
References: <1444883121-31757-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames variable gu8FlushedJoinReqDrvHandler to join_req_drv
to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 961e853..704419f 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -267,7 +267,7 @@ u8 mode_11i;
 u8 auth_type;
 u32 join_req_size;
 u32 info_element_size;
-struct host_if_drv *gu8FlushedJoinReqDrvHandler;
+struct host_if_drv *join_req_drv;
 #define REAL_JOIN_REQ 0
 #define FLUSHED_JOIN_REQ 1
 #define FLUSHED_BYTE_POS 79
@@ -1210,7 +1210,7 @@ static s32 Handle_Connect(struct host_if_drv *hif_drv,
 
 	if (memcmp("DIRECT-", pstrHostIFconnectAttr->ssid, 7)) {
 		memcpy(join_req, pu8CurrByte, join_req_size);
-		gu8FlushedJoinReqDrvHandler = hif_drv;
+		join_req_drv = hif_drv;
 	}
 
 	PRINT_D(GENERIC_DBG, "send HOST_IF_WAITING_CONN_RESP\n");
@@ -1331,7 +1331,7 @@ static s32 Handle_FlushConnect(struct host_if_drv *hif_drv)
 	u32WidsCount++;
 
 	s32Error = send_config_pkt(SET_CFG, strWIDList, u32WidsCount,
-				   get_id_from_handler(gu8FlushedJoinReqDrvHandler));
+				   get_id_from_handler(join_req_drv));
 	if (s32Error) {
 		PRINT_ER("failed to send config packet\n");
 		s32Error = -EINVAL;
@@ -1406,12 +1406,12 @@ static s32 Handle_ConnectTimeout(struct host_if_drv *hif_drv)
 
 	eth_zero_addr(u8ConnectedSSID);
 
-	if (join_req != NULL && gu8FlushedJoinReqDrvHandler == hif_drv) {
+	if (join_req != NULL && join_req_drv == hif_drv) {
 		kfree(join_req);
 		join_req = NULL;
 	}
 
-	if (info_element != NULL && gu8FlushedJoinReqDrvHandler == hif_drv) {
+	if (info_element != NULL && join_req_drv == hif_drv) {
 		kfree(info_element);
 		info_element = NULL;
 	}
@@ -1710,12 +1710,12 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct host_if_drv *hif_drv,
 			hif_drv->strWILC_UsrConnReq.ConnReqIEsLen = 0;
 			kfree(hif_drv->strWILC_UsrConnReq.pu8ConnReqIEs);
 
-			if (join_req != NULL && gu8FlushedJoinReqDrvHandler == hif_drv) {
+			if (join_req != NULL && join_req_drv == hif_drv) {
 				kfree(join_req);
 				join_req = NULL;
 			}
 
-			if (info_element != NULL && gu8FlushedJoinReqDrvHandler == hif_drv) {
+			if (info_element != NULL && join_req_drv == hif_drv) {
 				kfree(info_element);
 				info_element = NULL;
 			}
@@ -2103,12 +2103,12 @@ static void Handle_Disconnect(struct host_if_drv *hif_drv)
 		hif_drv->strWILC_UsrConnReq.ConnReqIEsLen = 0;
 		kfree(hif_drv->strWILC_UsrConnReq.pu8ConnReqIEs);
 
-		if (join_req != NULL && gu8FlushedJoinReqDrvHandler == hif_drv) {
+		if (join_req != NULL && join_req_drv == hif_drv) {
 			kfree(join_req);
 			join_req = NULL;
 		}
 
-		if (info_element != NULL && gu8FlushedJoinReqDrvHandler == hif_drv) {
+		if (info_element != NULL && join_req_drv == hif_drv) {
 			kfree(info_element);
 			info_element = NULL;
 		}
-- 
1.9.1

