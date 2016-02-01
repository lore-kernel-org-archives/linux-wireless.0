Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:47443 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933526AbcBACN4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 Jan 2016 21:13:56 -0500
From: Leo Kim <leo.kim@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 2/7] staging: wilc1000: wilc_msgqueue.c: removes debug print log
Date: Mon, 1 Feb 2016 11:11:20 +0900
Message-ID: <1454292685-12294-2-git-send-email-leo.kim@atmel.com> (sfid-20160201_031401_247830_47FA0A72)
In-Reply-To: <1454292685-12294-1-git-send-email-leo.kim@atmel.com>
References: <1454292685-12294-1-git-send-email-leo.kim@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patches removes unnecessary debug print logs.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
---
 drivers/staging/wilc1000/wilc_msgqueue.c | 24 ++++++------------------
 1 file changed, 6 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_msgqueue.c b/drivers/staging/wilc1000/wilc_msgqueue.c
index 098390c..5c09cab 100644
--- a/drivers/staging/wilc1000/wilc_msgqueue.c
+++ b/drivers/staging/wilc1000/wilc_msgqueue.c
@@ -59,15 +59,11 @@ int wilc_mq_send(WILC_MsgQueueHandle *pHandle,
 	unsigned long flags;
 	Message *pstrMessage = NULL;
 
-	if ((!pHandle) || (u32SendBufferSize == 0) || (!pvSendBuffer)) {
-		PRINT_ER("pHandle or pvSendBuffer is null\n");
+	if (!pHandle || (u32SendBufferSize == 0) || !pvSendBuffer)
 		return -EFAULT;
-	}
 
-	if (pHandle->bExiting) {
-		PRINT_ER("pHandle fail\n");
+	if (pHandle->bExiting)
 		return -EFAULT;
-	}
 
 	/* construct a new message */
 	pstrMessage = kmalloc(sizeof(Message), GFP_ATOMIC);
@@ -117,16 +113,12 @@ int wilc_mq_recv(WILC_MsgQueueHandle *pHandle,
 	Message *pstrMessage;
 	unsigned long flags;
 
-	if ((!pHandle) || (u32RecvBufferSize == 0)
-	    || (!pvRecvBuffer) || (!pu32ReceivedLength)) {
-		PRINT_ER("pHandle or pvRecvBuffer is null\n");
+	if (!pHandle || (u32RecvBufferSize == 0) || !pvRecvBuffer ||
+	    !pu32ReceivedLength)
 		return -EINVAL;
-	}
 
-	if (pHandle->bExiting) {
-		PRINT_ER("pHandle fail\n");
+	if (pHandle->bExiting)
 		return -EFAULT;
-	}
 
 	spin_lock_irqsave(&pHandle->strCriticalSection, flags);
 	pHandle->u32ReceiversCount++;
@@ -134,24 +126,20 @@ int wilc_mq_recv(WILC_MsgQueueHandle *pHandle,
 
 	down(&pHandle->hSem);
 
-	if (pHandle->bExiting) {
-		PRINT_ER("pHandle fail\n");
+	if (pHandle->bExiting)
 		return -EFAULT;
-	}
 
 	spin_lock_irqsave(&pHandle->strCriticalSection, flags);
 
 	pstrMessage = pHandle->pstrMessageList;
 	if (!pstrMessage) {
 		spin_unlock_irqrestore(&pHandle->strCriticalSection, flags);
-		PRINT_ER("pstrMessage is null\n");
 		return -EFAULT;
 	}
 	/* check buffer size */
 	if (u32RecvBufferSize < pstrMessage->u32Length)	{
 		spin_unlock_irqrestore(&pHandle->strCriticalSection, flags);
 		up(&pHandle->hSem);
-		PRINT_ER("u32RecvBufferSize overflow\n");
 		return -EOVERFLOW;
 	}
 
-- 
1.9.1

