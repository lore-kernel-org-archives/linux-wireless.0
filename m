Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f67.google.com ([209.85.220.67]:36077 "EHLO
	mail-pa0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755461AbcAUBVw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jan 2016 20:21:52 -0500
Received: by mail-pa0-f67.google.com with SMTP id a20so1010467pag.3
        for <linux-wireless@vger.kernel.org>; Wed, 20 Jan 2016 17:21:52 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 24/27] staging: wilc1000: rename pstrMessage in wilc_mq_recv
Date: Thu, 21 Jan 2016 10:20:27 +0900
Message-Id: <1453339230-1377-24-git-send-email-chaehyun.lim@gmail.com> (sfid-20160121_023657_379529_F762E0B2)
In-Reply-To: <1453339230-1377-1-git-send-email-chaehyun.lim@gmail.com>
References: <1453339230-1377-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames pstrMessage to msg to avoid camelcase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_msgqueue.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_msgqueue.c b/drivers/staging/wilc1000/wilc_msgqueue.c
index 5601de8..7107715 100644
--- a/drivers/staging/wilc1000/wilc_msgqueue.c
+++ b/drivers/staging/wilc1000/wilc_msgqueue.c
@@ -112,7 +112,7 @@ int wilc_mq_send(struct message_queue *mq,
 int wilc_mq_recv(struct message_queue *mq,
 		 void *recv_buf, u32 recv_buf_size, u32 *recv_len)
 {
-	struct message *pstrMessage;
+	struct message *msg;
 	unsigned long flags;
 
 	if ((!mq) || (recv_buf_size == 0)
@@ -133,14 +133,14 @@ int wilc_mq_recv(struct message_queue *mq,
 	down(&mq->sem);
 	spin_lock_irqsave(&mq->lock, flags);
 
-	pstrMessage = mq->msg_list;
-	if (!pstrMessage) {
+	msg = mq->msg_list;
+	if (!msg) {
 		spin_unlock_irqrestore(&mq->lock, flags);
-		PRINT_ER("pstrMessage is null\n");
+		PRINT_ER("msg is null\n");
 		return -EFAULT;
 	}
 	/* check buffer size */
-	if (recv_buf_size < pstrMessage->len) {
+	if (recv_buf_size < msg->len) {
 		spin_unlock_irqrestore(&mq->lock, flags);
 		up(&mq->sem);
 		PRINT_ER("recv_buf_size overflow\n");
@@ -149,13 +149,13 @@ int wilc_mq_recv(struct message_queue *mq,
 
 	/* consume the message */
 	mq->recv_count--;
-	memcpy(recv_buf, pstrMessage->buf, pstrMessage->len);
-	*recv_len = pstrMessage->len;
+	memcpy(recv_buf, msg->buf, msg->len);
+	*recv_len = msg->len;
 
-	mq->msg_list = pstrMessage->next;
+	mq->msg_list = msg->next;
 
-	kfree(pstrMessage->buf);
-	kfree(pstrMessage);
+	kfree(msg->buf);
+	kfree(msg);
 
 	spin_unlock_irqrestore(&mq->lock, flags);
 
-- 
2.6.4

