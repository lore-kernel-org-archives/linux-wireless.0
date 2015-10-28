Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:37320 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290AbbJ1GYY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 02:24:24 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH V5] staging: wilc1000: wilc_msgqueue.c : remove goto statement
Date: Wed, 28 Oct 2015 15:27:21 +0900
Message-ID: <1446013641-4918-1-git-send-email-glen.lee@atmel.com> (sfid-20151028_072428_071574_A3294C54)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch removes goto statement and moves the spin lock position.
If a memory allocation fails, directly returns an error.
The spin lock actually protects the pHandle. Therefore, call spin lock just
before pHandle is used.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
Changes in v5:
 - fix typo 'Signee-eff-by: Lee Kim <leo.kim@atmel.com>'

 drivers/staging/wilc1000/wilc_msgqueue.c | 25 ++++++++-----------------
 1 file changed, 8 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_msgqueue.c b/drivers/staging/wilc1000/wilc_msgqueue.c
index b13809a..0eff121 100644
--- a/drivers/staging/wilc1000/wilc_msgqueue.c
+++ b/drivers/staging/wilc1000/wilc_msgqueue.c
@@ -56,37 +56,35 @@ int wilc_mq_destroy(WILC_MsgQueueHandle *pHandle)
 int wilc_mq_send(WILC_MsgQueueHandle *pHandle,
 			     const void *pvSendBuffer, u32 u32SendBufferSize)
 {
-	int result = 0;
 	unsigned long flags;
 	Message *pstrMessage = NULL;
 
 	if ((!pHandle) || (u32SendBufferSize == 0) || (!pvSendBuffer)) {
 		PRINT_ER("pHandle or pvSendBuffer is null\n");
-		result = -EFAULT;
-		goto ERRORHANDLER;
+		return -EFAULT;
 	}
 
 	if (pHandle->bExiting) {
 		PRINT_ER("pHandle fail\n");
-		result = -EFAULT;
-		goto ERRORHANDLER;
+		return -EFAULT;
 	}
 
-	spin_lock_irqsave(&pHandle->strCriticalSection, flags);
-
 	/* construct a new message */
 	pstrMessage = kmalloc(sizeof(Message), GFP_ATOMIC);
 	if (!pstrMessage)
 		return -ENOMEM;
+
 	pstrMessage->u32Length = u32SendBufferSize;
 	pstrMessage->pstrNext = NULL;
 	pstrMessage->pvBuffer = kmemdup(pvSendBuffer, u32SendBufferSize,
 					GFP_ATOMIC);
 	if (!pstrMessage->pvBuffer) {
-		result = -ENOMEM;
-		goto ERRORHANDLER;
+		kfree(pstrMessage);
+		return -ENOMEM;
 	}
 
+	spin_lock_irqsave(&pHandle->strCriticalSection, flags);
+
 	/* add it to the message queue */
 	if (!pHandle->pstrMessageList) {
 		pHandle->pstrMessageList  = pstrMessage;
@@ -103,14 +101,7 @@ int wilc_mq_send(WILC_MsgQueueHandle *pHandle,
 
 	up(&pHandle->hSem);
 
-ERRORHANDLER:
-	/* error occured, free any allocations */
-	if (pstrMessage) {
-		kfree(pstrMessage->pvBuffer);
-		kfree(pstrMessage);
-	}
-
-	return result;
+	return 0;
 }
 
 /*!
-- 
1.9.1

