Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:35471 "EHLO
	mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752511AbcAUBVk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jan 2016 20:21:40 -0500
Received: by mail-pf0-f195.google.com with SMTP id 65so1055590pff.2
        for <linux-wireless@vger.kernel.org>; Wed, 20 Jan 2016 17:21:40 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 20/27] staging: wilc1000: rename pHandle in wilc_mq_recv
Date: Thu, 21 Jan 2016 10:20:23 +0900
Message-Id: <1453339230-1377-20-git-send-email-chaehyun.lim@gmail.com> (sfid-20160121_023654_507463_F4A58F82)
In-Reply-To: <1453339230-1377-1-git-send-email-chaehyun.lim@gmail.com>
References: <1453339230-1377-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames pHandle to mq to avoid camelcase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_msgqueue.c | 34 ++++++++++++++++----------------
 drivers/staging/wilc1000/wilc_msgqueue.h |  2 +-
 2 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_msgqueue.c b/drivers/staging/wilc1000/wilc_msgqueue.c
index 361ca8f..d2df179 100644
--- a/drivers/staging/wilc1000/wilc_msgqueue.c
+++ b/drivers/staging/wilc1000/wilc_msgqueue.c
@@ -109,56 +109,56 @@ int wilc_mq_send(struct message_queue *mq,
  *  @note		copied from FLO glue implementatuion
  *  @version		1.0
  */
-int wilc_mq_recv(struct message_queue *pHandle,
+int wilc_mq_recv(struct message_queue *mq,
 		 void *pvRecvBuffer, u32 u32RecvBufferSize,
 		 u32 *pu32ReceivedLength)
 {
 	struct message *pstrMessage;
 	unsigned long flags;
 
-	if ((!pHandle) || (u32RecvBufferSize == 0)
+	if ((!mq) || (u32RecvBufferSize == 0)
 	    || (!pvRecvBuffer) || (!pu32ReceivedLength)) {
-		PRINT_ER("pHandle or pvRecvBuffer is null\n");
+		PRINT_ER("mq or pvRecvBuffer is null\n");
 		return -EINVAL;
 	}
 
-	if (pHandle->exiting) {
-		PRINT_ER("pHandle fail\n");
+	if (mq->exiting) {
+		PRINT_ER("mq fail\n");
 		return -EFAULT;
 	}
 
-	spin_lock_irqsave(&pHandle->lock, flags);
-	pHandle->recv_count++;
-	spin_unlock_irqrestore(&pHandle->lock, flags);
+	spin_lock_irqsave(&mq->lock, flags);
+	mq->recv_count++;
+	spin_unlock_irqrestore(&mq->lock, flags);
 
-	down(&pHandle->sem);
-	spin_lock_irqsave(&pHandle->lock, flags);
+	down(&mq->sem);
+	spin_lock_irqsave(&mq->lock, flags);
 
-	pstrMessage = pHandle->msg_list;
+	pstrMessage = mq->msg_list;
 	if (!pstrMessage) {
-		spin_unlock_irqrestore(&pHandle->lock, flags);
+		spin_unlock_irqrestore(&mq->lock, flags);
 		PRINT_ER("pstrMessage is null\n");
 		return -EFAULT;
 	}
 	/* check buffer size */
 	if (u32RecvBufferSize < pstrMessage->len) {
-		spin_unlock_irqrestore(&pHandle->lock, flags);
-		up(&pHandle->sem);
+		spin_unlock_irqrestore(&mq->lock, flags);
+		up(&mq->sem);
 		PRINT_ER("u32RecvBufferSize overflow\n");
 		return -EOVERFLOW;
 	}
 
 	/* consume the message */
-	pHandle->recv_count--;
+	mq->recv_count--;
 	memcpy(pvRecvBuffer, pstrMessage->buf, pstrMessage->len);
 	*pu32ReceivedLength = pstrMessage->len;
 
-	pHandle->msg_list = pstrMessage->next;
+	mq->msg_list = pstrMessage->next;
 
 	kfree(pstrMessage->buf);
 	kfree(pstrMessage);
 
-	spin_unlock_irqrestore(&pHandle->lock, flags);
+	spin_unlock_irqrestore(&mq->lock, flags);
 
 	return 0;
 }
diff --git a/drivers/staging/wilc1000/wilc_msgqueue.h b/drivers/staging/wilc1000/wilc_msgqueue.h
index 70e1be1..0c1eead 100644
--- a/drivers/staging/wilc1000/wilc_msgqueue.h
+++ b/drivers/staging/wilc1000/wilc_msgqueue.h
@@ -76,7 +76,7 @@ int wilc_mq_send(struct message_queue *mq,
  *  @date		30 Aug 2010
  *  @version		1.0
  */
-int wilc_mq_recv(struct message_queue *pHandle,
+int wilc_mq_recv(struct message_queue *mq,
 		 void *pvRecvBuffer, u32 u32RecvBufferSize,
 		 u32 *pu32ReceivedLength);
 
-- 
2.6.4

