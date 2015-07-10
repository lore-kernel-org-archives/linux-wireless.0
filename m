Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:44364 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726AbbGJF4w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jul 2015 01:56:52 -0400
From: Johnny Kim <johnny.kim@atmel.com>
To: <gregkh@linuxfoundation.org>, <devel@driverdev.osuosl.org>,
	<linux-wireless@vger.kernel.org>, <chris.park@atmel.com>
CC: <johnny.kim@atmel.com>, <rachel.kim@atmel.com>,
	<tony.cho@atmel.com>, <Nicolas.FERRE@atmel.com>,
	<dean.lee@atmel.com>, <austin.shin@atmel.com>
Subject: [PATCH 5/5] staging: wilc1000: change variable of limited 32bit size to pointer
Date: Fri, 10 Jul 2015 14:55:59 +0900
Message-ID: <37f5391e38d4b53ae61e6bec05cb7cda73e8811c.1436504598.git.johnny.kim@atmel.com> (sfid-20150710_075655_310732_052D1D36)
In-Reply-To: <5398ffb63f5799c0fbab0c2fe1416bb09c4bae6b.1436504598.git.johnny.kim@atmel.com>
References: <5398ffb63f5799c0fbab0c2fe1416bb09c4bae6b.1436504598.git.johnny.kim@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

gu8FlushedJoinReqDrvHandler variable is be using to save structure pointer.
But because that is restricted to 32bit and has needless casting,
the varibale should be changed to pointer of same type.

Signed-off-by: Johnny Kim <johnny.kim@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index dfd8e01..a82e0a8 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -581,7 +581,7 @@ u8 gu8Flushed11iMode;
 u8 gu8FlushedAuthType;
 u32 gu32FlushedJoinReqSize;
 u32 gu32FlushedInfoElemAsocSize;
-u32 gu8FlushedJoinReqDrvHandler;
+tstrWILC_WFIDrv *gu8FlushedJoinReqDrvHandler;
 #define REAL_JOIN_REQ 0
 #define FLUSHED_JOIN_REQ 1
 #define FLUSHED_BYTE_POS 79     /* Position the byte indicating flushing in the flushed request */
@@ -1948,7 +1948,7 @@ static s32 Handle_Connect(void *drvHandler, tstrHostIFconnectAttr *pstrHostIFcon
 	/*BugID_5137*/
 	if (WILC_memcmp("DIRECT-", pstrHostIFconnectAttr->pu8ssid, 7)) {
 		memcpy(gu8FlushedJoinReq, pu8CurrByte, gu32FlushedJoinReqSize);
-		gu8FlushedJoinReqDrvHandler = (u32)pstrWFIDrv;
+		gu8FlushedJoinReqDrvHandler = pstrWFIDrv;
 	}
 
 	PRINT_D(GENERIC_DBG, "send HOST_IF_WAITING_CONN_RESP\n");
@@ -2199,11 +2199,11 @@ static s32 Handle_ConnectTimeout(void *drvHandler)
 	WILC_memset(u8ConnectedSSID, 0, ETH_ALEN);
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
@@ -2624,11 +2624,11 @@ static s32 Handle_RcvdGnrlAsyncInfo(void *drvHandler, tstrRcvdGnrlAsyncInfo *pst
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
@@ -3125,11 +3125,11 @@ static void Handle_Disconnect(void *drvHandler)
 
 
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

