Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:5495 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876AbbJSJDb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Oct 2015 05:03:31 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH V3] staging: wilc1000: wilc_msgqueue.c : add goto statement
Date: Mon, 19 Oct 2015 18:03:15 +0900
Message-ID: <1445245395-9976-1-git-send-email-tony.cho@atmel.com> (sfid-20151019_110335_174880_EDC60CAF)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch uses goto statement to separet error conditionals into release_lock
and mem_free in wilc_mq_send. If unexpected errors happen, this function
cannot up the semaphore, otherwise, if no errors, the semaphore should be
released, but freeing memory is not needed in this function.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
V3: use goto statement to seperate error types into release_lock and mem_free
---
 drivers/staging/wilc1000/wilc_msgqueue.c | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_msgqueue.c b/drivers/staging/wilc1000/wilc_msgqueue.c
index b13809a..bb4e93c 100644
--- a/drivers/staging/wilc1000/wilc_msgqueue.c
+++ b/drivers/staging/wilc1000/wilc_msgqueue.c
@@ -63,28 +63,31 @@ int wilc_mq_send(WILC_MsgQueueHandle *pHandle,
 	if ((!pHandle) || (u32SendBufferSize == 0) || (!pvSendBuffer)) {
 		PRINT_ER("pHandle or pvSendBuffer is null\n");
 		result = -EFAULT;
-		goto ERRORHANDLER;
+		goto out;
 	}
 
 	if (pHandle->bExiting) {
 		PRINT_ER("pHandle fail\n");
 		result = -EFAULT;
-		goto ERRORHANDLER;
+		goto out;
 	}
 
 	spin_lock_irqsave(&pHandle->strCriticalSection, flags);
 
 	/* construct a new message */
 	pstrMessage = kmalloc(sizeof(Message), GFP_ATOMIC);
-	if (!pstrMessage)
-		return -ENOMEM;
+	if (!pstrMessage) {
+		result = -ENOMEM;
+		goto release_lock;
+	}
+
 	pstrMessage->u32Length = u32SendBufferSize;
 	pstrMessage->pstrNext = NULL;
 	pstrMessage->pvBuffer = kmemdup(pvSendBuffer, u32SendBufferSize,
 					GFP_ATOMIC);
 	if (!pstrMessage->pvBuffer) {
 		result = -ENOMEM;
-		goto ERRORHANDLER;
+		goto mem_free;
 	}
 
 	/* add it to the message queue */
@@ -103,13 +106,13 @@ int wilc_mq_send(WILC_MsgQueueHandle *pHandle,
 
 	up(&pHandle->hSem);
 
-ERRORHANDLER:
-	/* error occured, free any allocations */
-	if (pstrMessage) {
-		kfree(pstrMessage->pvBuffer);
-		kfree(pstrMessage);
-	}
+	return 0;
 
+mem_free:
+	kfree(pstrMessage);
+release_lock:
+	spin_unlock_irqrestore(&pHandle->strCriticalSection, flags);
+out:
 	return result;
 }
 
-- 
1.9.1

