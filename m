Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f66.google.com ([209.85.220.66]:36821 "EHLO
	mail-pa0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965184AbcAULc2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jan 2016 06:32:28 -0500
Received: by mail-pa0-f66.google.com with SMTP id a20so1631533pag.3
        for <linux-wireless@vger.kernel.org>; Thu, 21 Jan 2016 03:32:28 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH V2 14/27] staging: wilc1000: rename pHandle in wilc_mq_send
Date: Thu, 21 Jan 2016 20:30:44 +0900
Message-Id: <1453375857-20645-15-git-send-email-chaehyun.lim@gmail.com> (sfid-20160121_123656_679924_4192EA9E)
In-Reply-To: <1453375857-20645-1-git-send-email-chaehyun.lim@gmail.com>
References: <1453375857-20645-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames pHandle to mq to avoid camelcase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_msgqueue.c | 22 +++++++++++-----------
 drivers/staging/wilc1000/wilc_msgqueue.h |  2 +-
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_msgqueue.c b/drivers/staging/wilc1000/wilc_msgqueue.c
index a01420a..71ce1f5 100644
--- a/drivers/staging/wilc1000/wilc_msgqueue.c
+++ b/drivers/staging/wilc1000/wilc_msgqueue.c
@@ -53,19 +53,19 @@ int wilc_mq_destroy(struct message_queue *mq)
  *  @note		copied from FLO glue implementatuion
  *  @version		1.0
  */
-int wilc_mq_send(struct message_queue *pHandle,
+int wilc_mq_send(struct message_queue *mq,
 		 const void *pvSendBuffer, u32 u32SendBufferSize)
 {
 	unsigned long flags;
 	struct message *pstrMessage = NULL;
 
-	if ((!pHandle) || (u32SendBufferSize == 0) || (!pvSendBuffer)) {
-		PRINT_ER("pHandle or pvSendBuffer is null\n");
+	if ((!mq) || (u32SendBufferSize == 0) || (!pvSendBuffer)) {
+		PRINT_ER("mq or pvSendBuffer is null\n");
 		return -EFAULT;
 	}
 
-	if (pHandle->exiting) {
-		PRINT_ER("pHandle fail\n");
+	if (mq->exiting) {
+		PRINT_ER("mq fail\n");
 		return -EFAULT;
 	}
 
@@ -83,13 +83,13 @@ int wilc_mq_send(struct message_queue *pHandle,
 		return -ENOMEM;
 	}
 
-	spin_lock_irqsave(&pHandle->lock, flags);
+	spin_lock_irqsave(&mq->lock, flags);
 
 	/* add it to the message queue */
-	if (!pHandle->msg_list) {
-		pHandle->msg_list  = pstrMessage;
+	if (!mq->msg_list) {
+		mq->msg_list  = pstrMessage;
 	} else {
-		struct message *pstrTailMsg = pHandle->msg_list;
+		struct message *pstrTailMsg = mq->msg_list;
 
 		while (pstrTailMsg->next)
 			pstrTailMsg = pstrTailMsg->next;
@@ -97,9 +97,9 @@ int wilc_mq_send(struct message_queue *pHandle,
 		pstrTailMsg->next = pstrMessage;
 	}
 
-	spin_unlock_irqrestore(&pHandle->lock, flags);
+	spin_unlock_irqrestore(&mq->lock, flags);
 
-	up(&pHandle->sem);
+	up(&mq->sem);
 
 	return 0;
 }
diff --git a/drivers/staging/wilc1000/wilc_msgqueue.h b/drivers/staging/wilc1000/wilc_msgqueue.h
index b91822e..e6cdc10 100644
--- a/drivers/staging/wilc1000/wilc_msgqueue.h
+++ b/drivers/staging/wilc1000/wilc_msgqueue.h
@@ -57,7 +57,7 @@ int wilc_mq_create(struct message_queue *mq);
  *  @date		30 Aug 2010
  *  @version		1.0
  */
-int wilc_mq_send(struct message_queue *pHandle,
+int wilc_mq_send(struct message_queue *mq,
 		 const void *pvSendBuffer, u32 u32SendBufferSize);
 
 /*!
-- 
2.7.0

