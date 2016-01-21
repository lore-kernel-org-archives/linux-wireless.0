Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:36802 "EHLO
	mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755461AbcAUBVt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jan 2016 20:21:49 -0500
Received: by mail-pf0-f193.google.com with SMTP id n128so1047124pfn.3
        for <linux-wireless@vger.kernel.org>; Wed, 20 Jan 2016 17:21:49 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 23/27] staging: wilc1000: rename pu32ReceivedLength in wilc_mq_recv
Date: Thu, 21 Jan 2016 10:20:26 +0900
Message-Id: <1453339230-1377-23-git-send-email-chaehyun.lim@gmail.com> (sfid-20160121_023653_663353_D4CC57AC)
In-Reply-To: <1453339230-1377-1-git-send-email-chaehyun.lim@gmail.com>
References: <1453339230-1377-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames pu32ReceivedLength to recv_len to avoid camelcase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_msgqueue.c | 7 +++----
 drivers/staging/wilc1000/wilc_msgqueue.h | 3 +--
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_msgqueue.c b/drivers/staging/wilc1000/wilc_msgqueue.c
index c86bd7c..5601de8 100644
--- a/drivers/staging/wilc1000/wilc_msgqueue.c
+++ b/drivers/staging/wilc1000/wilc_msgqueue.c
@@ -110,14 +110,13 @@ int wilc_mq_send(struct message_queue *mq,
  *  @version		1.0
  */
 int wilc_mq_recv(struct message_queue *mq,
-		 void *recv_buf, u32 recv_buf_size,
-		 u32 *pu32ReceivedLength)
+		 void *recv_buf, u32 recv_buf_size, u32 *recv_len)
 {
 	struct message *pstrMessage;
 	unsigned long flags;
 
 	if ((!mq) || (recv_buf_size == 0)
-	    || (!recv_buf) || (!pu32ReceivedLength)) {
+	    || (!recv_buf) || (!recv_len)) {
 		PRINT_ER("mq or recv_buf is null\n");
 		return -EINVAL;
 	}
@@ -151,7 +150,7 @@ int wilc_mq_recv(struct message_queue *mq,
 	/* consume the message */
 	mq->recv_count--;
 	memcpy(recv_buf, pstrMessage->buf, pstrMessage->len);
-	*pu32ReceivedLength = pstrMessage->len;
+	*recv_len = pstrMessage->len;
 
 	mq->msg_list = pstrMessage->next;
 
diff --git a/drivers/staging/wilc1000/wilc_msgqueue.h b/drivers/staging/wilc1000/wilc_msgqueue.h
index 3804b3b..4f79ead 100644
--- a/drivers/staging/wilc1000/wilc_msgqueue.h
+++ b/drivers/staging/wilc1000/wilc_msgqueue.h
@@ -77,8 +77,7 @@ int wilc_mq_send(struct message_queue *mq,
  *  @version		1.0
  */
 int wilc_mq_recv(struct message_queue *mq,
-		 void *recv_buf, u32 recv_buf_size,
-		 u32 *pu32ReceivedLength);
+		 void *recv_buf, u32 recv_buf_size, u32 *recv_len);
 
 /*!
  *  @brief		Destroys an existing  Message queue
-- 
2.6.4

