Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:35120 "EHLO
	mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965191AbcAULch (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jan 2016 06:32:37 -0500
Received: by mail-pf0-f193.google.com with SMTP id 65so1705199pff.2
        for <linux-wireless@vger.kernel.org>; Thu, 21 Jan 2016 03:32:37 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH V2 17/27] staging: wilc1000: rename pstrMessage in wilc_mq_send
Date: Thu, 21 Jan 2016 20:30:47 +0900
Message-Id: <1453375857-20645-18-git-send-email-chaehyun.lim@gmail.com> (sfid-20160121_123655_694409_D1BEF6C2)
In-Reply-To: <1453375857-20645-1-git-send-email-chaehyun.lim@gmail.com>
References: <1453375857-20645-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames pstrMessage to new_msg to avoid camelcase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_msgqueue.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_msgqueue.c b/drivers/staging/wilc1000/wilc_msgqueue.c
index 8e37cff0..9a80fe6 100644
--- a/drivers/staging/wilc1000/wilc_msgqueue.c
+++ b/drivers/staging/wilc1000/wilc_msgqueue.c
@@ -57,7 +57,7 @@ int wilc_mq_send(struct message_queue *mq,
 		 const void *send_buf, u32 send_buf_size)
 {
 	unsigned long flags;
-	struct message *pstrMessage = NULL;
+	struct message *new_msg = NULL;
 
 	if ((!mq) || (send_buf_size == 0) || (!send_buf)) {
 		PRINT_ER("mq or send_buf is null\n");
@@ -70,16 +70,15 @@ int wilc_mq_send(struct message_queue *mq,
 	}
 
 	/* construct a new message */
-	pstrMessage = kmalloc(sizeof(struct message), GFP_ATOMIC);
-	if (!pstrMessage)
+	new_msg = kmalloc(sizeof(struct message), GFP_ATOMIC);
+	if (!new_msg)
 		return -ENOMEM;
 
-	pstrMessage->len = send_buf_size;
-	pstrMessage->next = NULL;
-	pstrMessage->buf = kmemdup(send_buf, send_buf_size,
-				   GFP_ATOMIC);
-	if (!pstrMessage->buf) {
-		kfree(pstrMessage);
+	new_msg->len = send_buf_size;
+	new_msg->next = NULL;
+	new_msg->buf = kmemdup(send_buf, send_buf_size, GFP_ATOMIC);
+	if (!new_msg->buf) {
+		kfree(new_msg);
 		return -ENOMEM;
 	}
 
@@ -87,14 +86,14 @@ int wilc_mq_send(struct message_queue *mq,
 
 	/* add it to the message queue */
 	if (!mq->msg_list) {
-		mq->msg_list  = pstrMessage;
+		mq->msg_list  = new_msg;
 	} else {
 		struct message *pstrTailMsg = mq->msg_list;
 
 		while (pstrTailMsg->next)
 			pstrTailMsg = pstrTailMsg->next;
 
-		pstrTailMsg->next = pstrMessage;
+		pstrTailMsg->next = new_msg;
 	}
 
 	spin_unlock_irqrestore(&mq->lock, flags);
-- 
2.7.0

