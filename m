Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:36622 "EHLO
	mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756418AbcA2Ovl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jan 2016 09:51:41 -0500
Received: by mail-pf0-f194.google.com with SMTP id n128so3868138pfn.3
        for <linux-wireless@vger.kernel.org>; Fri, 29 Jan 2016 06:51:41 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 1/2] staging: wilc1000: wilc_msgqueue: use standard struct list_head
Date: Fri, 29 Jan 2016 23:51:32 +0900
Message-Id: <1454079093-7011-1-git-send-email-chaehyun.lim@gmail.com> (sfid-20160129_155156_491562_D1104C98)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch uses standard struct list_head in struct message and
message_queue instead of custom linked list.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_msgqueue.c | 32 ++++++++++++--------------------
 drivers/staging/wilc1000/wilc_msgqueue.h |  5 +++--
 2 files changed, 15 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_msgqueue.c b/drivers/staging/wilc1000/wilc_msgqueue.c
index 4493ca9..f57e4ec 100644
--- a/drivers/staging/wilc1000/wilc_msgqueue.c
+++ b/drivers/staging/wilc1000/wilc_msgqueue.c
@@ -15,7 +15,7 @@ int wilc_mq_create(struct message_queue *mq)
 {
 	spin_lock_init(&mq->lock);
 	sema_init(&mq->sem, 0);
-	mq->msg_list = NULL;
+	INIT_LIST_HEAD(&mq->msg_list);
 	mq->recv_count = 0;
 	mq->exiting = false;
 	return 0;
@@ -29,6 +29,8 @@ int wilc_mq_create(struct message_queue *mq)
  */
 int wilc_mq_destroy(struct message_queue *mq)
 {
+	struct message *msg;
+
 	mq->exiting = true;
 
 	/* Release any waiting receiver thread. */
@@ -37,11 +39,10 @@ int wilc_mq_destroy(struct message_queue *mq)
 		mq->recv_count--;
 	}
 
-	while (mq->msg_list) {
-		struct message *msg = mq->msg_list->next;
-
-		kfree(mq->msg_list);
-		mq->msg_list = msg;
+	while (!list_empty(&mq->msg_list)) {
+		msg = list_first_entry(&mq->msg_list, struct message, list);
+		list_del(&msg->list);
+		kfree(msg->buf);
 	}
 
 	return 0;
@@ -75,7 +76,7 @@ int wilc_mq_send(struct message_queue *mq,
 		return -ENOMEM;
 
 	new_msg->len = send_buf_size;
-	new_msg->next = NULL;
+	INIT_LIST_HEAD(&new_msg->list);
 	new_msg->buf = kmemdup(send_buf, send_buf_size, GFP_ATOMIC);
 	if (!new_msg->buf) {
 		kfree(new_msg);
@@ -85,16 +86,7 @@ int wilc_mq_send(struct message_queue *mq,
 	spin_lock_irqsave(&mq->lock, flags);
 
 	/* add it to the message queue */
-	if (!mq->msg_list) {
-		mq->msg_list  = new_msg;
-	} else {
-		struct message *tail_msg = mq->msg_list;
-
-		while (tail_msg->next)
-			tail_msg = tail_msg->next;
-
-		tail_msg->next = new_msg;
-	}
+	list_add_tail(&new_msg->list, &mq->msg_list);
 
 	spin_unlock_irqrestore(&mq->lock, flags);
 
@@ -132,13 +124,13 @@ int wilc_mq_recv(struct message_queue *mq,
 	down(&mq->sem);
 	spin_lock_irqsave(&mq->lock, flags);
 
-	msg = mq->msg_list;
-	if (!msg) {
+	if (list_empty(&mq->msg_list)) {
 		spin_unlock_irqrestore(&mq->lock, flags);
 		PRINT_ER("msg is null\n");
 		return -EFAULT;
 	}
 	/* check buffer size */
+	msg = list_first_entry(&mq->msg_list, struct message, list);
 	if (recv_buf_size < msg->len) {
 		spin_unlock_irqrestore(&mq->lock, flags);
 		up(&mq->sem);
@@ -151,7 +143,7 @@ int wilc_mq_recv(struct message_queue *mq,
 	memcpy(recv_buf, msg->buf, msg->len);
 	*recv_len = msg->len;
 
-	mq->msg_list = msg->next;
+	list_del(&msg->list);
 
 	kfree(msg->buf);
 	kfree(msg);
diff --git a/drivers/staging/wilc1000/wilc_msgqueue.h b/drivers/staging/wilc1000/wilc_msgqueue.h
index ddd09843..846a484 100644
--- a/drivers/staging/wilc1000/wilc_msgqueue.h
+++ b/drivers/staging/wilc1000/wilc_msgqueue.h
@@ -2,11 +2,12 @@
 #define __WILC_MSG_QUEUE_H__
 
 #include <linux/semaphore.h>
+#include <linux/list.h>
 
 struct message {
 	void *buf;
 	u32 len;
-	struct message *next;
+	struct list_head list;
 };
 
 struct message_queue {
@@ -14,7 +15,7 @@ struct message_queue {
 	spinlock_t lock;
 	bool exiting;
 	u32 recv_count;
-	struct message *msg_list;
+	struct list_head msg_list;
 };
 
 int wilc_mq_create(struct message_queue *mq);
-- 
2.7.0

