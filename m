Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f65.google.com ([209.85.220.65]:33514 "EHLO
	mail-pa0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894AbbJCJ2j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 Oct 2015 05:28:39 -0400
From: Chandra S Gorentla <csgorentla@gmail.com>
To: gregkh@linuxfoundation.org
Cc: dan.carpenter@oracle.com, johnny.kim@atmel.com,
	rachel.kim@atmel.com, chris.park@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org,
	Chandra S Gorentla <csgorentla@gmail.com>
Subject: [PATCH 2/2] drivers: staging: wilc1000: Call kfree only for error cases
Date: Sat,  3 Oct 2015 14:57:30 +0530
Message-Id: <1443864450-18167-2-git-send-email-csgorentla@gmail.com> (sfid-20151003_112858_718291_B12CD46F)
In-Reply-To: <1443864450-18167-1-git-send-email-csgorentla@gmail.com>
References: <1443864450-18167-1-git-send-email-csgorentla@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 - kfree is being called for the members of the queue without
   de-queuing them; they are just inserted within this function;
   they are supposed to be de-queued and freed in a function
   for receiving the queue items
 - goto statements are removed
 - After kfree correction, there is no need for target block
   of goto statement; hence it is removed

Signed-off-by: Chandra S Gorentla <csgorentla@gmail.com>
---
 drivers/staging/wilc1000/wilc_msgqueue.c | 22 ++++++----------------
 1 file changed, 6 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_msgqueue.c b/drivers/staging/wilc1000/wilc_msgqueue.c
index 284a3f5..eae90be 100644
--- a/drivers/staging/wilc1000/wilc_msgqueue.c
+++ b/drivers/staging/wilc1000/wilc_msgqueue.c
@@ -56,32 +56,30 @@ int wilc_mq_destroy(WILC_MsgQueueHandle *pHandle)
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
 
 	/* construct a new message */
 	pstrMessage = kmalloc(sizeof(Message), GFP_ATOMIC);
 	if (!pstrMessage)
 		return -ENOMEM;
+
 	pstrMessage->u32Length = u32SendBufferSize;
 	pstrMessage->pstrNext = NULL;
 	pstrMessage->pvBuffer = kmalloc(u32SendBufferSize, GFP_ATOMIC);
 	if (!pstrMessage->pvBuffer) {
-		result = -ENOMEM;
-		goto ERRORHANDLER;
+		kfree(pstrMessage);
+		return -ENOMEM;
 	}
 	memcpy(pstrMessage->pvBuffer, pvSendBuffer, u32SendBufferSize);
 
@@ -102,15 +100,7 @@ int wilc_mq_send(WILC_MsgQueueHandle *pHandle,
 	spin_unlock_irqrestore(&pHandle->strCriticalSection, flags);
 
 	up(&pHandle->hSem);
-
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
2.1.4

