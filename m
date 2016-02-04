Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:10602 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966103AbcBDJ1q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Feb 2016 04:27:46 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH RESEND 39/70] staging: wilc1000: wilc_msgqueue.c: removes debug print log
Date: Thu, 4 Feb 2016 18:15:56 +0900
Message-ID: <1454577387-509-40-git-send-email-glen.lee@atmel.com> (sfid-20160204_102753_577057_2E5522D0)
In-Reply-To: <1454577387-509-1-git-send-email-glen.lee@atmel.com>
References: <1454577387-509-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patches removes unnecessary debug print logs.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
---
 drivers/staging/wilc1000/wilc_msgqueue.c | 18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_msgqueue.c b/drivers/staging/wilc1000/wilc_msgqueue.c
index 5fe85eb..780ddd3 100644
--- a/drivers/staging/wilc1000/wilc_msgqueue.c
+++ b/drivers/staging/wilc1000/wilc_msgqueue.c
@@ -60,15 +60,11 @@ int wilc_mq_send(struct message_queue *mq,
 	unsigned long flags;
 	struct message *new_msg = NULL;
 
-	if ((!mq) || (send_buf_size == 0) || (!send_buf)) {
-		PRINT_ER("mq or send_buf is null\n");
+	if (!mq || (send_buf_size == 0) || !send_buf)
 		return -EINVAL;
-	}
 
-	if (mq->exiting) {
-		PRINT_ER("mq fail\n");
+	if (mq->exiting)
 		return -EFAULT;
-	}
 
 	/* construct a new message */
 	new_msg = kmalloc(sizeof(*new_msg), GFP_ATOMIC);
@@ -107,15 +103,11 @@ int wilc_mq_recv(struct message_queue *mq,
 	struct message *msg;
 	unsigned long flags;
 
-	if ((!mq) || (recv_buf_size == 0) || (!recv_buf) || (!recv_len)) {
-		PRINT_ER("mq or recv_buf is null\n");
+	if (!mq || (recv_buf_size == 0) || !recv_buf || !recv_len)
 		return -EINVAL;
-	}
 
-	if (mq->exiting) {
-		PRINT_ER("mq fail\n");
+	if (mq->exiting)
 		return -EFAULT;
-	}
 
 	spin_lock_irqsave(&mq->lock, flags);
 	mq->recv_count++;
@@ -127,7 +119,6 @@ int wilc_mq_recv(struct message_queue *mq,
 	if (list_empty(&mq->msg_list)) {
 		spin_unlock_irqrestore(&mq->lock, flags);
 		up(&mq->sem);
-		PRINT_ER("msg is null\n");
 		return -EFAULT;
 	}
 	/* check buffer size */
@@ -135,7 +126,6 @@ int wilc_mq_recv(struct message_queue *mq,
 	if (recv_buf_size < msg->len) {
 		spin_unlock_irqrestore(&mq->lock, flags);
 		up(&mq->sem);
-		PRINT_ER("recv_buf_size overflow\n");
 		return -EOVERFLOW;
 	}
 
-- 
1.9.1

