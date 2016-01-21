Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f68.google.com ([209.85.220.68]:34831 "EHLO
	mail-pa0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965022AbcAULcH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jan 2016 06:32:07 -0500
Received: by mail-pa0-f68.google.com with SMTP id gi1so1651078pac.2
        for <linux-wireless@vger.kernel.org>; Thu, 21 Jan 2016 03:32:06 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH V2 07/27] staging: wilc1000: rename strCriticalSection in struct message_queue
Date: Thu, 21 Jan 2016 20:30:37 +0900
Message-Id: <1453375857-20645-8-git-send-email-chaehyun.lim@gmail.com> (sfid-20160121_123210_112669_DA685F6D)
In-Reply-To: <1453375857-20645-1-git-send-email-chaehyun.lim@gmail.com>
References: <1453375857-20645-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames strCriticalSection to lock to avoid camelcase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_msgqueue.c | 18 +++++++++---------
 drivers/staging/wilc1000/wilc_msgqueue.h |  2 +-
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_msgqueue.c b/drivers/staging/wilc1000/wilc_msgqueue.c
index b996c47..67bf147 100644
--- a/drivers/staging/wilc1000/wilc_msgqueue.c
+++ b/drivers/staging/wilc1000/wilc_msgqueue.c
@@ -13,7 +13,7 @@
  */
 int wilc_mq_create(struct message_queue *pHandle)
 {
-	spin_lock_init(&pHandle->strCriticalSection);
+	spin_lock_init(&pHandle->lock);
 	sema_init(&pHandle->sem, 0);
 	pHandle->pstrMessageList = NULL;
 	pHandle->u32ReceiversCount = 0;
@@ -83,7 +83,7 @@ int wilc_mq_send(struct message_queue *pHandle,
 		return -ENOMEM;
 	}
 
-	spin_lock_irqsave(&pHandle->strCriticalSection, flags);
+	spin_lock_irqsave(&pHandle->lock, flags);
 
 	/* add it to the message queue */
 	if (!pHandle->pstrMessageList) {
@@ -97,7 +97,7 @@ int wilc_mq_send(struct message_queue *pHandle,
 		pstrTailMsg->next = pstrMessage;
 	}
 
-	spin_unlock_irqrestore(&pHandle->strCriticalSection, flags);
+	spin_unlock_irqrestore(&pHandle->lock, flags);
 
 	up(&pHandle->sem);
 
@@ -128,22 +128,22 @@ int wilc_mq_recv(struct message_queue *pHandle,
 		return -EFAULT;
 	}
 
-	spin_lock_irqsave(&pHandle->strCriticalSection, flags);
+	spin_lock_irqsave(&pHandle->lock, flags);
 	pHandle->u32ReceiversCount++;
-	spin_unlock_irqrestore(&pHandle->strCriticalSection, flags);
+	spin_unlock_irqrestore(&pHandle->lock, flags);
 
 	down(&pHandle->sem);
-	spin_lock_irqsave(&pHandle->strCriticalSection, flags);
+	spin_lock_irqsave(&pHandle->lock, flags);
 
 	pstrMessage = pHandle->pstrMessageList;
 	if (!pstrMessage) {
-		spin_unlock_irqrestore(&pHandle->strCriticalSection, flags);
+		spin_unlock_irqrestore(&pHandle->lock, flags);
 		PRINT_ER("pstrMessage is null\n");
 		return -EFAULT;
 	}
 	/* check buffer size */
 	if (u32RecvBufferSize < pstrMessage->len) {
-		spin_unlock_irqrestore(&pHandle->strCriticalSection, flags);
+		spin_unlock_irqrestore(&pHandle->lock, flags);
 		up(&pHandle->sem);
 		PRINT_ER("u32RecvBufferSize overflow\n");
 		return -EOVERFLOW;
@@ -159,7 +159,7 @@ int wilc_mq_recv(struct message_queue *pHandle,
 	kfree(pstrMessage->buf);
 	kfree(pstrMessage);
 
-	spin_unlock_irqrestore(&pHandle->strCriticalSection, flags);
+	spin_unlock_irqrestore(&pHandle->lock, flags);
 
 	return 0;
 }
diff --git a/drivers/staging/wilc1000/wilc_msgqueue.h b/drivers/staging/wilc1000/wilc_msgqueue.h
index 3ea4068..6cdebbf 100644
--- a/drivers/staging/wilc1000/wilc_msgqueue.h
+++ b/drivers/staging/wilc1000/wilc_msgqueue.h
@@ -21,7 +21,7 @@ struct message {
 
 struct message_queue {
 	struct semaphore sem;
-	spinlock_t strCriticalSection;
+	spinlock_t lock;
 	bool bExiting;
 	u32 u32ReceiversCount;
 	struct message *pstrMessageList;
-- 
2.7.0

