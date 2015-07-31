Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:44446 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534AbbGaHku (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2015 03:40:50 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <austin.shin@atmel.com>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<jude.lee@atmel.com>, <robin.hwang@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 17/28] staging: wilc1000: fix comparison between different type warning
Date: Fri, 31 Jul 2015 16:38:25 +0900
Message-ID: <1438328316-30197-18-git-send-email-tony.cho@atmel.com> (sfid-20150731_094052_568170_AE7E3CB5)
In-Reply-To: <1438328316-30197-1-git-send-email-tony.cho@atmel.com>
References: <1438328316-30197-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: glen lee <glen.lee@atmel.com>

This patch removes casting (u32) which makes compile warnings.
The type of gu8FlushedJoinReqDrvHandler was changed with WILC_WFIDrvHandle same as
drvHandler.

drivers/staging/wilc1000/host_interface.c:2197:68: warning: comparison between
pointer and integer [enabled by default]
  if (gu8FlushedInfoElemAsoc != NULL && gu8FlushedJoinReqDrvHandler == (u32)drvHandler) {

Signed-off-by: glen lee <glen.lee@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index d5bd23d..7962f06 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -2190,11 +2190,11 @@ static s32 Handle_ConnectTimeout(WILC_WFIDrvHandle drvHandler)
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
@@ -2615,11 +2615,11 @@ static s32 Handle_RcvdGnrlAsyncInfo(WILC_WFIDrvHandle drvHandler, tstrRcvdGnrlAs
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
@@ -3116,11 +3116,11 @@ static void Handle_Disconnect(WILC_WFIDrvHandle drvHandler)
 
 
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

