Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f65.google.com ([209.85.220.65]:34823 "EHLO
	mail-pa0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965022AbcAULcD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jan 2016 06:32:03 -0500
Received: by mail-pa0-f65.google.com with SMTP id gi1so1651020pac.2
        for <linux-wireless@vger.kernel.org>; Thu, 21 Jan 2016 03:32:03 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH V2 06/27] staging: wilc1000: rename hSem in struct message_queue
Date: Thu, 21 Jan 2016 20:30:36 +0900
Message-Id: <1453375857-20645-7-git-send-email-chaehyun.lim@gmail.com> (sfid-20160121_123207_444112_690E36DD)
In-Reply-To: <1453375857-20645-1-git-send-email-chaehyun.lim@gmail.com>
References: <1453375857-20645-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames hSem to sem to avoid camelcase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_msgqueue.c | 10 +++++-----
 drivers/staging/wilc1000/wilc_msgqueue.h |  2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_msgqueue.c b/drivers/staging/wilc1000/wilc_msgqueue.c
index 907bae1..b996c47 100644
--- a/drivers/staging/wilc1000/wilc_msgqueue.c
+++ b/drivers/staging/wilc1000/wilc_msgqueue.c
@@ -14,7 +14,7 @@
 int wilc_mq_create(struct message_queue *pHandle)
 {
 	spin_lock_init(&pHandle->strCriticalSection);
-	sema_init(&pHandle->hSem, 0);
+	sema_init(&pHandle->sem, 0);
 	pHandle->pstrMessageList = NULL;
 	pHandle->u32ReceiversCount = 0;
 	pHandle->bExiting = false;
@@ -33,7 +33,7 @@ int wilc_mq_destroy(struct message_queue *pHandle)
 
 	/* Release any waiting receiver thread. */
 	while (pHandle->u32ReceiversCount > 0) {
-		up(&pHandle->hSem);
+		up(&pHandle->sem);
 		pHandle->u32ReceiversCount--;
 	}
 
@@ -99,7 +99,7 @@ int wilc_mq_send(struct message_queue *pHandle,
 
 	spin_unlock_irqrestore(&pHandle->strCriticalSection, flags);
 
-	up(&pHandle->hSem);
+	up(&pHandle->sem);
 
 	return 0;
 }
@@ -132,7 +132,7 @@ int wilc_mq_recv(struct message_queue *pHandle,
 	pHandle->u32ReceiversCount++;
 	spin_unlock_irqrestore(&pHandle->strCriticalSection, flags);
 
-	down(&pHandle->hSem);
+	down(&pHandle->sem);
 	spin_lock_irqsave(&pHandle->strCriticalSection, flags);
 
 	pstrMessage = pHandle->pstrMessageList;
@@ -144,7 +144,7 @@ int wilc_mq_recv(struct message_queue *pHandle,
 	/* check buffer size */
 	if (u32RecvBufferSize < pstrMessage->len) {
 		spin_unlock_irqrestore(&pHandle->strCriticalSection, flags);
-		up(&pHandle->hSem);
+		up(&pHandle->sem);
 		PRINT_ER("u32RecvBufferSize overflow\n");
 		return -EOVERFLOW;
 	}
diff --git a/drivers/staging/wilc1000/wilc_msgqueue.h b/drivers/staging/wilc1000/wilc_msgqueue.h
index 111be46..3ea4068 100644
--- a/drivers/staging/wilc1000/wilc_msgqueue.h
+++ b/drivers/staging/wilc1000/wilc_msgqueue.h
@@ -20,7 +20,7 @@ struct message {
 };
 
 struct message_queue {
-	struct semaphore hSem;
+	struct semaphore sem;
 	spinlock_t strCriticalSection;
 	bool bExiting;
 	u32 u32ReceiversCount;
-- 
2.7.0

