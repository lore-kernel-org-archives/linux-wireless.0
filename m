Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:34514 "EHLO
	mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965191AbcAULcu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jan 2016 06:32:50 -0500
Received: by mail-pf0-f194.google.com with SMTP id 65so1708593pfd.1
        for <linux-wireless@vger.kernel.org>; Thu, 21 Jan 2016 03:32:49 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH V2 21/27] staging: wilc1000: rename pvRecvBuffer in wilc_mq_recv
Date: Thu, 21 Jan 2016 20:30:51 +0900
Message-Id: <1453375857-20645-22-git-send-email-chaehyun.lim@gmail.com> (sfid-20160121_123656_396274_9A352642)
In-Reply-To: <1453375857-20645-1-git-send-email-chaehyun.lim@gmail.com>
References: <1453375857-20645-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames pvRecvBuffer to recv_buf to avoid camelcase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_msgqueue.c | 8 ++++----
 drivers/staging/wilc1000/wilc_msgqueue.h | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_msgqueue.c b/drivers/staging/wilc1000/wilc_msgqueue.c
index d2df179..b836b2e 100644
--- a/drivers/staging/wilc1000/wilc_msgqueue.c
+++ b/drivers/staging/wilc1000/wilc_msgqueue.c
@@ -110,15 +110,15 @@ int wilc_mq_send(struct message_queue *mq,
  *  @version		1.0
  */
 int wilc_mq_recv(struct message_queue *mq,
-		 void *pvRecvBuffer, u32 u32RecvBufferSize,
+		 void *recv_buf, u32 u32RecvBufferSize,
 		 u32 *pu32ReceivedLength)
 {
 	struct message *pstrMessage;
 	unsigned long flags;
 
 	if ((!mq) || (u32RecvBufferSize == 0)
-	    || (!pvRecvBuffer) || (!pu32ReceivedLength)) {
-		PRINT_ER("mq or pvRecvBuffer is null\n");
+	    || (!recv_buf) || (!pu32ReceivedLength)) {
+		PRINT_ER("mq or recv_buf is null\n");
 		return -EINVAL;
 	}
 
@@ -150,7 +150,7 @@ int wilc_mq_recv(struct message_queue *mq,
 
 	/* consume the message */
 	mq->recv_count--;
-	memcpy(pvRecvBuffer, pstrMessage->buf, pstrMessage->len);
+	memcpy(recv_buf, pstrMessage->buf, pstrMessage->len);
 	*pu32ReceivedLength = pstrMessage->len;
 
 	mq->msg_list = pstrMessage->next;
diff --git a/drivers/staging/wilc1000/wilc_msgqueue.h b/drivers/staging/wilc1000/wilc_msgqueue.h
index 0c1eead..81b51dd 100644
--- a/drivers/staging/wilc1000/wilc_msgqueue.h
+++ b/drivers/staging/wilc1000/wilc_msgqueue.h
@@ -77,7 +77,7 @@ int wilc_mq_send(struct message_queue *mq,
  *  @version		1.0
  */
 int wilc_mq_recv(struct message_queue *mq,
-		 void *pvRecvBuffer, u32 u32RecvBufferSize,
+		 void *recv_buf, u32 u32RecvBufferSize,
 		 u32 *pu32ReceivedLength);
 
 /*!
-- 
2.7.0

