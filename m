Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:6403 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103AbbJOE2h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Oct 2015 00:28:37 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 28/40] staging: wilc1000: rename variable gu8FlushedJoinReq
Date: Thu, 15 Oct 2015 13:25:09 +0900
Message-ID: <1444883121-31757-28-git-send-email-tony.cho@atmel.com> (sfid-20151015_064657_265916_786D827E)
In-Reply-To: <1444883121-31757-1-git-send-email-tony.cho@atmel.com>
References: <1444883121-31757-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames variable gu8FlushedJoinReq to join_req
to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 31a8266..38ce396 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -261,7 +261,7 @@ static u8 get_ip[2][4];
 static u32 inactive_time;
 static u8 del_beacon;
 
-u8 *gu8FlushedJoinReq;
+u8 *join_req;
 u8 *gu8FlushedInfoElemAsoc;
 u8 gu8Flushed11iMode;
 u8 gu8FlushedAuthType;
@@ -1113,7 +1113,7 @@ static s32 Handle_Connect(struct host_if_drv *hif_drv,
 
 	if (memcmp("DIRECT-", pstrHostIFconnectAttr->ssid, 7)) {
 		gu32FlushedJoinReqSize = strWIDList[u32WidsCount].size;
-		gu8FlushedJoinReq = kmalloc(gu32FlushedJoinReqSize, GFP_KERNEL);
+		join_req = kmalloc(gu32FlushedJoinReqSize, GFP_KERNEL);
 	}
 	if (strWIDList[u32WidsCount].val == NULL) {
 		s32Error = -EFAULT;
@@ -1210,7 +1210,7 @@ static s32 Handle_Connect(struct host_if_drv *hif_drv,
 	u32WidsCount++;
 
 	if (memcmp("DIRECT-", pstrHostIFconnectAttr->ssid, 7)) {
-		memcpy(gu8FlushedJoinReq, pu8CurrByte, gu32FlushedJoinReqSize);
+		memcpy(join_req, pu8CurrByte, gu32FlushedJoinReqSize);
 		gu8FlushedJoinReqDrvHandler = hif_drv;
 	}
 
@@ -1323,7 +1323,7 @@ static s32 Handle_FlushConnect(struct host_if_drv *hif_drv)
 	strWIDList[u32WidsCount].id = (u16)WID_JOIN_REQ_EXTENDED;
 	strWIDList[u32WidsCount].type = WID_STR;
 	strWIDList[u32WidsCount].size = gu32FlushedJoinReqSize;
-	strWIDList[u32WidsCount].val = (s8 *)gu8FlushedJoinReq;
+	strWIDList[u32WidsCount].val = (s8 *)join_req;
 	pu8CurrByte = strWIDList[u32WidsCount].val;
 
 	pu8CurrByte += FLUSHED_BYTE_POS;
@@ -1407,9 +1407,9 @@ static s32 Handle_ConnectTimeout(struct host_if_drv *hif_drv)
 
 	eth_zero_addr(u8ConnectedSSID);
 
-	if (gu8FlushedJoinReq != NULL && gu8FlushedJoinReqDrvHandler == hif_drv) {
-		kfree(gu8FlushedJoinReq);
-		gu8FlushedJoinReq = NULL;
+	if (join_req != NULL && gu8FlushedJoinReqDrvHandler == hif_drv) {
+		kfree(join_req);
+		join_req = NULL;
 	}
 	if (gu8FlushedInfoElemAsoc != NULL && gu8FlushedJoinReqDrvHandler == hif_drv) {
 		kfree(gu8FlushedInfoElemAsoc);
@@ -1710,9 +1710,9 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct host_if_drv *hif_drv,
 			hif_drv->strWILC_UsrConnReq.ConnReqIEsLen = 0;
 			kfree(hif_drv->strWILC_UsrConnReq.pu8ConnReqIEs);
 
-			if (gu8FlushedJoinReq != NULL && gu8FlushedJoinReqDrvHandler == hif_drv) {
-				kfree(gu8FlushedJoinReq);
-				gu8FlushedJoinReq = NULL;
+			if (join_req != NULL && gu8FlushedJoinReqDrvHandler == hif_drv) {
+				kfree(join_req);
+				join_req = NULL;
 			}
 			if (gu8FlushedInfoElemAsoc != NULL && gu8FlushedJoinReqDrvHandler == hif_drv) {
 				kfree(gu8FlushedInfoElemAsoc);
@@ -2102,9 +2102,9 @@ static void Handle_Disconnect(struct host_if_drv *hif_drv)
 		hif_drv->strWILC_UsrConnReq.ConnReqIEsLen = 0;
 		kfree(hif_drv->strWILC_UsrConnReq.pu8ConnReqIEs);
 
-		if (gu8FlushedJoinReq != NULL && gu8FlushedJoinReqDrvHandler == hif_drv) {
-			kfree(gu8FlushedJoinReq);
-			gu8FlushedJoinReq = NULL;
+		if (join_req != NULL && gu8FlushedJoinReqDrvHandler == hif_drv) {
+			kfree(join_req);
+			join_req = NULL;
 		}
 		if (gu8FlushedInfoElemAsoc != NULL && gu8FlushedJoinReqDrvHandler == hif_drv) {
 			kfree(gu8FlushedInfoElemAsoc);
@@ -3634,7 +3634,7 @@ s32 host_int_flush_join_req(struct host_if_drv *hif_drv)
 	s32 s32Error = 0;
 	struct host_if_msg msg;
 
-	if (!gu8FlushedJoinReq)	{
+	if (!join_req) {
 		s32Error = -EFAULT;
 		return s32Error;
 	}
-- 
1.9.1

