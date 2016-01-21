Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f65.google.com ([209.85.220.65]:36013 "EHLO
	mail-pa0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781AbcAUBVZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jan 2016 20:21:25 -0500
Received: by mail-pa0-f65.google.com with SMTP id a20so1010030pag.3
        for <linux-wireless@vger.kernel.org>; Wed, 20 Jan 2016 17:21:25 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 15/27] staging: wilc1000: rename pvSendBuffer in wilc_mq_send
Date: Thu, 21 Jan 2016 10:20:18 +0900
Message-Id: <1453339230-1377-15-git-send-email-chaehyun.lim@gmail.com> (sfid-20160121_023658_621122_9EE76D5D)
In-Reply-To: <1453339230-1377-1-git-send-email-chaehyun.lim@gmail.com>
References: <1453339230-1377-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames pvSendBuffer to send_buf to avoid camelcase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_msgqueue.c | 8 ++++----
 drivers/staging/wilc1000/wilc_msgqueue.h | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_msgqueue.c b/drivers/staging/wilc1000/wilc_msgqueue.c
index 71ce1f5..5feb87c 100644
--- a/drivers/staging/wilc1000/wilc_msgqueue.c
+++ b/drivers/staging/wilc1000/wilc_msgqueue.c
@@ -54,13 +54,13 @@ int wilc_mq_destroy(struct message_queue *mq)
  *  @version		1.0
  */
 int wilc_mq_send(struct message_queue *mq,
-		 const void *pvSendBuffer, u32 u32SendBufferSize)
+		 const void *send_buf, u32 u32SendBufferSize)
 {
 	unsigned long flags;
 	struct message *pstrMessage = NULL;
 
-	if ((!mq) || (u32SendBufferSize == 0) || (!pvSendBuffer)) {
-		PRINT_ER("mq or pvSendBuffer is null\n");
+	if ((!mq) || (u32SendBufferSize == 0) || (!send_buf)) {
+		PRINT_ER("mq or send_buf is null\n");
 		return -EFAULT;
 	}
 
@@ -76,7 +76,7 @@ int wilc_mq_send(struct message_queue *mq,
 
 	pstrMessage->len = u32SendBufferSize;
 	pstrMessage->next = NULL;
-	pstrMessage->buf = kmemdup(pvSendBuffer, u32SendBufferSize,
+	pstrMessage->buf = kmemdup(send_buf, u32SendBufferSize,
 				   GFP_ATOMIC);
 	if (!pstrMessage->buf) {
 		kfree(pstrMessage);
diff --git a/drivers/staging/wilc1000/wilc_msgqueue.h b/drivers/staging/wilc1000/wilc_msgqueue.h
index e6cdc10..3adee90 100644
--- a/drivers/staging/wilc1000/wilc_msgqueue.h
+++ b/drivers/staging/wilc1000/wilc_msgqueue.h
@@ -58,7 +58,7 @@ int wilc_mq_create(struct message_queue *mq);
  *  @version		1.0
  */
 int wilc_mq_send(struct message_queue *mq,
-		 const void *pvSendBuffer, u32 u32SendBufferSize);
+		 const void *send_buf, u32 u32SendBufferSize);
 
 /*!
  *  @brief		Receives a message
-- 
2.6.4

