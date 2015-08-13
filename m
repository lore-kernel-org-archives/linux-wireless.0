Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:38052 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372AbbHMEmH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2015 00:42:07 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <jude.lee@atmel.com>, <robin.hwang@atmel.com>
Subject: [PATCH 4/5] staging: wilc1000: use the real data type
Date: Thu, 13 Aug 2015 13:41:22 +0900
Message-ID: <1439440883-16061-5-git-send-email-tony.cho@atmel.com> (sfid-20150813_064212_476602_C22DB52C)
In-Reply-To: <1439440883-16061-1-git-send-email-tony.cho@atmel.com>
References: <1439440883-16061-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johnny Kim <johnny.kim@atmel.com>

This patch changes the type of gu8FlushedJoinReqDrvHandler with his real
data type becasue typecasting is not necessary. In result, typecasting
which is not necessary and some building warnings is removed.

Signed-off-by: Johnny Kim <johnny.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 1c2d924..c4e27c7 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -578,7 +578,7 @@ u8 gu8Flushed11iMode;
 u8 gu8FlushedAuthType;
 u32 gu32FlushedJoinReqSize;
 u32 gu32FlushedInfoElemAsocSize;
-u32 gu8FlushedJoinReqDrvHandler;
+tstrWILC_WFIDrv *gu8FlushedJoinReqDrvHandler;
 #define REAL_JOIN_REQ 0
 #define FLUSHED_JOIN_REQ 1
 #define FLUSHED_BYTE_POS 79     /* Position the byte indicating flushing in the flushed request */
@@ -1940,7 +1940,7 @@ static s32 Handle_Connect(tstrWILC_WFIDrv *drvHandler, tstrHostIFconnectAttr *ps
 	/*BugID_5137*/
 	if (memcmp("DIRECT-", pstrHostIFconnectAttr->pu8ssid, 7)) {
 		memcpy(gu8FlushedJoinReq, pu8CurrByte, gu32FlushedJoinReqSize);
-		gu8FlushedJoinReqDrvHandler = (u32)pstrWFIDrv;
+		gu8FlushedJoinReqDrvHandler = pstrWFIDrv;
 	}
 
 	PRINT_D(GENERIC_DBG, "send HOST_IF_WAITING_CONN_RESP\n");
@@ -2191,11 +2191,11 @@ static s32 Handle_ConnectTimeout(tstrWILC_WFIDrv *drvHandler)
 	memset(u8ConnectedSSID, 0, ETH_ALEN);
 	/*BugID_5213*/
 	/*Freeing flushed join request params on connect timeout*/
-	if (gu8FlushedJoinReq != NULL && gu8FlushedJoinReqDrvHandler == (u32)drvHandler) {
+	if (gu8FlushedJoinReq != NULL && gu8FlushedJoinReqDrvHandler == drvHandler) {
 		WILC_FREE(gu8FlushedJoinReq);
 		gu8FlushedJoinReq = NULL;
 	}
-	if (gu8FlushedInfoElemAsoc != NULL && gu8FlushedJoinReqDrvHandler == (u32)drvHandler) {
+	if (gu8FlushedInfoElemAsoc != NULL && gu8FlushedJoinReqDrvHandler == drvHandler) {
 		WILC_FREE(gu8FlushedInfoElemAsoc);
 		gu8FlushedInfoElemAsoc = NULL;
 	}
@@ -2616,11 +2616,11 @@ static s32 Handle_RcvdGnrlAsyncInfo(tstrWILC_WFIDrv *drvHandler, tstrRcvdGnrlAsy
 			/*BugID_5213*/
 			/*Freeing flushed join request params on receiving*/
 			/*MAC_DISCONNECTED while connected*/
-			if (gu8FlushedJoinReq != NULL && gu8FlushedJoinReqDrvHandler == (u32)drvHandler) {
+			if (gu8FlushedJoinReq != NULL && gu8FlushedJoinReqDrvHandler == drvHandler) {
 				WILC_FREE(gu8FlushedJoinReq);
 				gu8FlushedJoinReq = NULL;
 			}
-			if (gu8FlushedInfoElemAsoc != NULL && gu8FlushedJoinReqDrvHandler == (u32)drvHandler) {
+			if (gu8FlushedInfoElemAsoc != NULL && gu8FlushedJoinReqDrvHandler == drvHandler) {
 				WILC_FREE(gu8FlushedInfoElemAsoc);
 				gu8FlushedInfoElemAsoc = NULL;
 			}
@@ -3116,11 +3116,11 @@ static void Handle_Disconnect(tstrWILC_WFIDrv *drvHandler)
 
 
 		/*BugID_5137*/
-		if (gu8FlushedJoinReq != NULL && gu8FlushedJoinReqDrvHandler == (u32)drvHandler) {
+		if (gu8FlushedJoinReq != NULL && gu8FlushedJoinReqDrvHandler == drvHandler) {
 			WILC_FREE(gu8FlushedJoinReq);
 			gu8FlushedJoinReq = NULL;
 		}
-		if (gu8FlushedInfoElemAsoc != NULL && gu8FlushedJoinReqDrvHandler == (u32)drvHandler) {
+		if (gu8FlushedInfoElemAsoc != NULL && gu8FlushedJoinReqDrvHandler == drvHandler) {
 			WILC_FREE(gu8FlushedInfoElemAsoc);
 			gu8FlushedInfoElemAsoc = NULL;
 		}
-- 
1.9.1

