Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:48319 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845AbbJNFz7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Oct 2015 01:55:59 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH V2] staging: wilc1000: wilc_msgqueue.c : remove the goto ERRORHANDER
Date: Wed, 14 Oct 2015 14:55:43 +0900
Message-ID: <1444802143-6298-1-git-send-email-tony.cho@atmel.com> (sfid-20151014_075602_291416_4146E869)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch removes goto ERRORHANDER and the result variable in wilc_mq_send.
Then, the error type is directly returned. If normal operation, freeing memory
is not needed in this function.
If an error occurs, returns an error after releasing the spin lock.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
V2: add releasing spinlock before returnig an error when an error happens.
---
 drivers/staging/wilc1000/wilc_msgqueue.c | 28 ++++++++++++----------------
 1 file changed, 12 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_msgqueue.c b/drivers/staging/wilc1000/wilc_msgqueue.c
index b13809a..4dfd476 100644
--- a/drivers/staging/wilc1000/wilc_msgqueue.c
+++ b/drivers/staging/wilc1000/wilc_msgqueue.c
@@ -56,35 +56,38 @@ int wilc_mq_destroy(WILC_MsgQueueHandle *pHandle)
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
 
 	spin_lock_irqsave(&pHandle->strCriticalSection, flags);
 
 	/* construct a new message */
 	pstrMessage = kmalloc(sizeof(Message), GFP_ATOMIC);
-	if (!pstrMessage)
+
+	if (!pstrMessage) {
+		spin_unlock_irqrestore(&pHandle->strCriticalSection, flags);
 		return -ENOMEM;
+	}
+
 	pstrMessage->u32Length = u32SendBufferSize;
 	pstrMessage->pstrNext = NULL;
 	pstrMessage->pvBuffer = kmemdup(pvSendBuffer, u32SendBufferSize,
 					GFP_ATOMIC);
+
 	if (!pstrMessage->pvBuffer) {
-		result = -ENOMEM;
-		goto ERRORHANDLER;
+		spin_unlock_irqrestore(&pHandle->strCriticalSection, flags);
+		kfree(pstrMessage);
+		return -ENOMEM;
 	}
 
 	/* add it to the message queue */
@@ -103,14 +106,7 @@ int wilc_mq_send(WILC_MsgQueueHandle *pHandle,
 
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

