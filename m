Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f66.google.com ([209.85.220.66]:33135 "EHLO
	mail-pa0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965156AbcAULcQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jan 2016 06:32:16 -0500
Received: by mail-pa0-f66.google.com with SMTP id pv5so1635555pac.0
        for <linux-wireless@vger.kernel.org>; Thu, 21 Jan 2016 03:32:16 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH V2 10/27] staging: wilc1000: rename pstrMessageList in struct message_queue
Date: Thu, 21 Jan 2016 20:30:40 +0900
Message-Id: <1453375857-20645-11-git-send-email-chaehyun.lim@gmail.com> (sfid-20160121_123654_984833_967B4A5C)
In-Reply-To: <1453375857-20645-1-git-send-email-chaehyun.lim@gmail.com>
References: <1453375857-20645-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames pstrMessageList to msg_list to avoid camelcase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_msgqueue.c | 20 ++++++++++----------
 drivers/staging/wilc1000/wilc_msgqueue.h |  2 +-
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_msgqueue.c b/drivers/staging/wilc1000/wilc_msgqueue.c
index 363e003..d13c9a7 100644
--- a/drivers/staging/wilc1000/wilc_msgqueue.c
+++ b/drivers/staging/wilc1000/wilc_msgqueue.c
@@ -15,7 +15,7 @@ int wilc_mq_create(struct message_queue *pHandle)
 {
 	spin_lock_init(&pHandle->lock);
 	sema_init(&pHandle->sem, 0);
-	pHandle->pstrMessageList = NULL;
+	pHandle->msg_list = NULL;
 	pHandle->recv_count = 0;
 	pHandle->exiting = false;
 	return 0;
@@ -37,11 +37,11 @@ int wilc_mq_destroy(struct message_queue *pHandle)
 		pHandle->recv_count--;
 	}
 
-	while (pHandle->pstrMessageList) {
-		struct message *pstrMessge = pHandle->pstrMessageList->next;
+	while (pHandle->msg_list) {
+		struct message *pstrMessge = pHandle->msg_list->next;
 
-		kfree(pHandle->pstrMessageList);
-		pHandle->pstrMessageList = pstrMessge;
+		kfree(pHandle->msg_list);
+		pHandle->msg_list = pstrMessge;
 	}
 
 	return 0;
@@ -86,10 +86,10 @@ int wilc_mq_send(struct message_queue *pHandle,
 	spin_lock_irqsave(&pHandle->lock, flags);
 
 	/* add it to the message queue */
-	if (!pHandle->pstrMessageList) {
-		pHandle->pstrMessageList  = pstrMessage;
+	if (!pHandle->msg_list) {
+		pHandle->msg_list  = pstrMessage;
 	} else {
-		struct message *pstrTailMsg = pHandle->pstrMessageList;
+		struct message *pstrTailMsg = pHandle->msg_list;
 
 		while (pstrTailMsg->next)
 			pstrTailMsg = pstrTailMsg->next;
@@ -135,7 +135,7 @@ int wilc_mq_recv(struct message_queue *pHandle,
 	down(&pHandle->sem);
 	spin_lock_irqsave(&pHandle->lock, flags);
 
-	pstrMessage = pHandle->pstrMessageList;
+	pstrMessage = pHandle->msg_list;
 	if (!pstrMessage) {
 		spin_unlock_irqrestore(&pHandle->lock, flags);
 		PRINT_ER("pstrMessage is null\n");
@@ -154,7 +154,7 @@ int wilc_mq_recv(struct message_queue *pHandle,
 	memcpy(pvRecvBuffer, pstrMessage->buf, pstrMessage->len);
 	*pu32ReceivedLength = pstrMessage->len;
 
-	pHandle->pstrMessageList = pstrMessage->next;
+	pHandle->msg_list = pstrMessage->next;
 
 	kfree(pstrMessage->buf);
 	kfree(pstrMessage);
diff --git a/drivers/staging/wilc1000/wilc_msgqueue.h b/drivers/staging/wilc1000/wilc_msgqueue.h
index dcf54ea..7e7ec06 100644
--- a/drivers/staging/wilc1000/wilc_msgqueue.h
+++ b/drivers/staging/wilc1000/wilc_msgqueue.h
@@ -24,7 +24,7 @@ struct message_queue {
 	spinlock_t lock;
 	bool exiting;
 	u32 recv_count;
-	struct message *pstrMessageList;
+	struct message *msg_list;
 };
 
 /*!
-- 
2.7.0

