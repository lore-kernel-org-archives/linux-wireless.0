Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:36642 "EHLO
	mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965022AbcAULcN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jan 2016 06:32:13 -0500
Received: by mail-pf0-f195.google.com with SMTP id n128so1693721pfn.3
        for <linux-wireless@vger.kernel.org>; Thu, 21 Jan 2016 03:32:13 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH V2 09/27] staging: wilc1000: rename u32ReceiversCount in struct message_queue
Date: Thu, 21 Jan 2016 20:30:39 +0900
Message-Id: <1453375857-20645-10-git-send-email-chaehyun.lim@gmail.com> (sfid-20160121_123216_742618_17B3F405)
In-Reply-To: <1453375857-20645-1-git-send-email-chaehyun.lim@gmail.com>
References: <1453375857-20645-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames u32ReceiversCount to recv_count to avoid camelcase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_msgqueue.c | 10 +++++-----
 drivers/staging/wilc1000/wilc_msgqueue.h |  2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_msgqueue.c b/drivers/staging/wilc1000/wilc_msgqueue.c
index 47ba256..363e003 100644
--- a/drivers/staging/wilc1000/wilc_msgqueue.c
+++ b/drivers/staging/wilc1000/wilc_msgqueue.c
@@ -16,7 +16,7 @@ int wilc_mq_create(struct message_queue *pHandle)
 	spin_lock_init(&pHandle->lock);
 	sema_init(&pHandle->sem, 0);
 	pHandle->pstrMessageList = NULL;
-	pHandle->u32ReceiversCount = 0;
+	pHandle->recv_count = 0;
 	pHandle->exiting = false;
 	return 0;
 }
@@ -32,9 +32,9 @@ int wilc_mq_destroy(struct message_queue *pHandle)
 	pHandle->exiting = true;
 
 	/* Release any waiting receiver thread. */
-	while (pHandle->u32ReceiversCount > 0) {
+	while (pHandle->recv_count > 0) {
 		up(&pHandle->sem);
-		pHandle->u32ReceiversCount--;
+		pHandle->recv_count--;
 	}
 
 	while (pHandle->pstrMessageList) {
@@ -129,7 +129,7 @@ int wilc_mq_recv(struct message_queue *pHandle,
 	}
 
 	spin_lock_irqsave(&pHandle->lock, flags);
-	pHandle->u32ReceiversCount++;
+	pHandle->recv_count++;
 	spin_unlock_irqrestore(&pHandle->lock, flags);
 
 	down(&pHandle->sem);
@@ -150,7 +150,7 @@ int wilc_mq_recv(struct message_queue *pHandle,
 	}
 
 	/* consume the message */
-	pHandle->u32ReceiversCount--;
+	pHandle->recv_count--;
 	memcpy(pvRecvBuffer, pstrMessage->buf, pstrMessage->len);
 	*pu32ReceivedLength = pstrMessage->len;
 
diff --git a/drivers/staging/wilc1000/wilc_msgqueue.h b/drivers/staging/wilc1000/wilc_msgqueue.h
index 2c21b3e..dcf54ea 100644
--- a/drivers/staging/wilc1000/wilc_msgqueue.h
+++ b/drivers/staging/wilc1000/wilc_msgqueue.h
@@ -23,7 +23,7 @@ struct message_queue {
 	struct semaphore sem;
 	spinlock_t lock;
 	bool exiting;
-	u32 u32ReceiversCount;
+	u32 recv_count;
 	struct message *pstrMessageList;
 };
 
-- 
2.7.0

