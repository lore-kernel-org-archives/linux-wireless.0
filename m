Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:36794 "EHLO
	mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752561AbcAUBVq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jan 2016 20:21:46 -0500
Received: by mail-pf0-f195.google.com with SMTP id n128so1047088pfn.3
        for <linux-wireless@vger.kernel.org>; Wed, 20 Jan 2016 17:21:46 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 22/27] staging: wilc1000: rename u32RecvBufferSize in wilc_mq_recv
Date: Thu, 21 Jan 2016 10:20:25 +0900
Message-Id: <1453339230-1377-22-git-send-email-chaehyun.lim@gmail.com> (sfid-20160121_023658_002399_F5FB2F4B)
In-Reply-To: <1453339230-1377-1-git-send-email-chaehyun.lim@gmail.com>
References: <1453339230-1377-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames u32RecvBufferSize to recv_buf_size to avoid
camelcase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_msgqueue.c | 8 ++++----
 drivers/staging/wilc1000/wilc_msgqueue.h | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_msgqueue.c b/drivers/staging/wilc1000/wilc_msgqueue.c
index b836b2e..c86bd7c 100644
--- a/drivers/staging/wilc1000/wilc_msgqueue.c
+++ b/drivers/staging/wilc1000/wilc_msgqueue.c
@@ -110,13 +110,13 @@ int wilc_mq_send(struct message_queue *mq,
  *  @version		1.0
  */
 int wilc_mq_recv(struct message_queue *mq,
-		 void *recv_buf, u32 u32RecvBufferSize,
+		 void *recv_buf, u32 recv_buf_size,
 		 u32 *pu32ReceivedLength)
 {
 	struct message *pstrMessage;
 	unsigned long flags;
 
-	if ((!mq) || (u32RecvBufferSize == 0)
+	if ((!mq) || (recv_buf_size == 0)
 	    || (!recv_buf) || (!pu32ReceivedLength)) {
 		PRINT_ER("mq or recv_buf is null\n");
 		return -EINVAL;
@@ -141,10 +141,10 @@ int wilc_mq_recv(struct message_queue *mq,
 		return -EFAULT;
 	}
 	/* check buffer size */
-	if (u32RecvBufferSize < pstrMessage->len) {
+	if (recv_buf_size < pstrMessage->len) {
 		spin_unlock_irqrestore(&mq->lock, flags);
 		up(&mq->sem);
-		PRINT_ER("u32RecvBufferSize overflow\n");
+		PRINT_ER("recv_buf_size overflow\n");
 		return -EOVERFLOW;
 	}
 
diff --git a/drivers/staging/wilc1000/wilc_msgqueue.h b/drivers/staging/wilc1000/wilc_msgqueue.h
index 81b51dd..3804b3b 100644
--- a/drivers/staging/wilc1000/wilc_msgqueue.h
+++ b/drivers/staging/wilc1000/wilc_msgqueue.h
@@ -77,7 +77,7 @@ int wilc_mq_send(struct message_queue *mq,
  *  @version		1.0
  */
 int wilc_mq_recv(struct message_queue *mq,
-		 void *recv_buf, u32 u32RecvBufferSize,
+		 void *recv_buf, u32 recv_buf_size,
 		 u32 *pu32ReceivedLength);
 
 /*!
-- 
2.6.4

