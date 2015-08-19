Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:34763 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752962AbbHSG7d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Aug 2015 02:59:33 -0400
Received: by paccq16 with SMTP id cq16so107269817pac.1
        for <linux-wireless@vger.kernel.org>; Tue, 18 Aug 2015 23:59:33 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, dean.lee@atmel.com,
	chris.park@atmel.com, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 06/13] staging: wilc1000: wilc_msgqueue.c: use ! operator instead of NULL comparison
Date: Wed, 19 Aug 2015 15:59:01 +0900
Message-Id: <1439967548-25876-6-git-send-email-chaehyun.lim@gmail.com> (sfid-20150819_085936_475865_A6A8D803)
In-Reply-To: <1439967548-25876-1-git-send-email-chaehyun.lim@gmail.com>
References: <1439967548-25876-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch uses ! operator instead of NULL comparison.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_msgqueue.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_msgqueue.c b/drivers/staging/wilc1000/wilc_msgqueue.c
index 53ce586..0770ff6 100644
--- a/drivers/staging/wilc1000/wilc_msgqueue.c
+++ b/drivers/staging/wilc1000/wilc_msgqueue.c
@@ -34,7 +34,7 @@ WILC_ErrNo WILC_MsgQueueDestroy(WILC_MsgQueueHandle *pHandle)
 		pHandle->u32ReceiversCount--;
 	}
 
-	while (pHandle->pstrMessageList != NULL) {
+	while (pHandle->pstrMessageList) {
 		Message *pstrMessge = pHandle->pstrMessageList->pstrNext;
 
 		kfree(pHandle->pstrMessageList);
@@ -57,7 +57,7 @@ WILC_ErrNo WILC_MsgQueueSend(WILC_MsgQueueHandle *pHandle,
 	unsigned long flags;
 	Message *pstrMessage = NULL;
 
-	if ((pHandle == NULL) || (u32SendBufferSize == 0) || (pvSendBuffer == NULL)) {
+	if ((!pHandle) || (u32SendBufferSize == 0) || (!pvSendBuffer)) {
 		WILC_ERRORREPORT(s32RetStatus, WILC_INVALID_ARGUMENT);
 	}
 
@@ -77,12 +77,12 @@ WILC_ErrNo WILC_MsgQueueSend(WILC_MsgQueueHandle *pHandle,
 	memcpy(pstrMessage->pvBuffer, pvSendBuffer, u32SendBufferSize);
 
 	/* add it to the message queue */
-	if (pHandle->pstrMessageList == NULL) {
+	if (!pHandle->pstrMessageList) {
 		pHandle->pstrMessageList  = pstrMessage;
 	} else {
 		Message *pstrTailMsg = pHandle->pstrMessageList;
 
-		while (pstrTailMsg->pstrNext != NULL)
+		while (pstrTailMsg->pstrNext)
 			pstrTailMsg = pstrTailMsg->pstrNext;
 
 		pstrTailMsg->pstrNext = pstrMessage;
@@ -95,8 +95,8 @@ WILC_ErrNo WILC_MsgQueueSend(WILC_MsgQueueHandle *pHandle,
 	WILC_CATCH(s32RetStatus)
 	{
 		/* error occured, free any allocations */
-		if (pstrMessage != NULL) {
-			if (pstrMessage->pvBuffer != NULL)
+		if (pstrMessage) {
+			if (pstrMessage->pvBuffer)
 				kfree(pstrMessage->pvBuffer);
 
 			kfree(pstrMessage);
@@ -120,8 +120,8 @@ WILC_ErrNo WILC_MsgQueueRecv(WILC_MsgQueueHandle *pHandle,
 	WILC_ErrNo s32RetStatus = WILC_SUCCESS;
 	unsigned long flags;
 
-	if ((pHandle == NULL) || (u32RecvBufferSize == 0)
-	    || (pvRecvBuffer == NULL) || (pu32ReceivedLength == NULL)) {
+	if ((!pHandle) || (u32RecvBufferSize == 0)
+	    || (!pvRecvBuffer) || (!pu32ReceivedLength)) {
 		WILC_ERRORREPORT(s32RetStatus, WILC_INVALID_ARGUMENT);
 	}
 
@@ -151,7 +151,7 @@ WILC_ErrNo WILC_MsgQueueRecv(WILC_MsgQueueHandle *pHandle,
 		spin_lock_irqsave(&pHandle->strCriticalSection, flags);
 
 		pstrMessage = pHandle->pstrMessageList;
-		if (pstrMessage == NULL) {
+		if (!pstrMessage) {
 			spin_unlock_irqrestore(&pHandle->strCriticalSection, flags);
 			WILC_ERRORREPORT(s32RetStatus, WILC_FAIL);
 		}
-- 
1.9.1

