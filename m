Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f65.google.com ([209.85.220.65]:33300 "EHLO
	mail-pa0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754255AbcAUBV2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jan 2016 20:21:28 -0500
Received: by mail-pa0-f65.google.com with SMTP id pv5so1015003pac.0
        for <linux-wireless@vger.kernel.org>; Wed, 20 Jan 2016 17:21:28 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 16/27] staging: wilc1000: rename u32SendBufferSize in wilc_mq_send
Date: Thu, 21 Jan 2016 10:20:19 +0900
Message-Id: <1453339230-1377-16-git-send-email-chaehyun.lim@gmail.com> (sfid-20160121_023658_947858_532B4ED4)
In-Reply-To: <1453339230-1377-1-git-send-email-chaehyun.lim@gmail.com>
References: <1453339230-1377-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames u32SendBufferSize to send_buf_size to avoid
camelcase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_msgqueue.c | 8 ++++----
 drivers/staging/wilc1000/wilc_msgqueue.h | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_msgqueue.c b/drivers/staging/wilc1000/wilc_msgqueue.c
index 5feb87c..8e37cff0 100644
--- a/drivers/staging/wilc1000/wilc_msgqueue.c
+++ b/drivers/staging/wilc1000/wilc_msgqueue.c
@@ -54,12 +54,12 @@ int wilc_mq_destroy(struct message_queue *mq)
  *  @version		1.0
  */
 int wilc_mq_send(struct message_queue *mq,
-		 const void *send_buf, u32 u32SendBufferSize)
+		 const void *send_buf, u32 send_buf_size)
 {
 	unsigned long flags;
 	struct message *pstrMessage = NULL;
 
-	if ((!mq) || (u32SendBufferSize == 0) || (!send_buf)) {
+	if ((!mq) || (send_buf_size == 0) || (!send_buf)) {
 		PRINT_ER("mq or send_buf is null\n");
 		return -EFAULT;
 	}
@@ -74,9 +74,9 @@ int wilc_mq_send(struct message_queue *mq,
 	if (!pstrMessage)
 		return -ENOMEM;
 
-	pstrMessage->len = u32SendBufferSize;
+	pstrMessage->len = send_buf_size;
 	pstrMessage->next = NULL;
-	pstrMessage->buf = kmemdup(send_buf, u32SendBufferSize,
+	pstrMessage->buf = kmemdup(send_buf, send_buf_size,
 				   GFP_ATOMIC);
 	if (!pstrMessage->buf) {
 		kfree(pstrMessage);
diff --git a/drivers/staging/wilc1000/wilc_msgqueue.h b/drivers/staging/wilc1000/wilc_msgqueue.h
index 3adee90..70e1be1 100644
--- a/drivers/staging/wilc1000/wilc_msgqueue.h
+++ b/drivers/staging/wilc1000/wilc_msgqueue.h
@@ -58,7 +58,7 @@ int wilc_mq_create(struct message_queue *mq);
  *  @version		1.0
  */
 int wilc_mq_send(struct message_queue *mq,
-		 const void *send_buf, u32 u32SendBufferSize);
+		 const void *send_buf, u32 send_buf_size);
 
 /*!
  *  @brief		Receives a message
-- 
2.6.4

