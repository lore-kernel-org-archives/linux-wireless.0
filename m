Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f67.google.com ([209.85.220.67]:34838 "EHLO
	mail-pa0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965022AbcAULcK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jan 2016 06:32:10 -0500
Received: by mail-pa0-f67.google.com with SMTP id gi1so1651120pac.2
        for <linux-wireless@vger.kernel.org>; Thu, 21 Jan 2016 03:32:09 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH V2 08/27] staging: wilc1000: rename bExiting in struct message_queue
Date: Thu, 21 Jan 2016 20:30:38 +0900
Message-Id: <1453375857-20645-9-git-send-email-chaehyun.lim@gmail.com> (sfid-20160121_123213_847100_A76544BF)
In-Reply-To: <1453375857-20645-1-git-send-email-chaehyun.lim@gmail.com>
References: <1453375857-20645-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames bExiting to exiting to avoid camelcase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_msgqueue.c | 8 ++++----
 drivers/staging/wilc1000/wilc_msgqueue.h | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_msgqueue.c b/drivers/staging/wilc1000/wilc_msgqueue.c
index 67bf147..47ba256 100644
--- a/drivers/staging/wilc1000/wilc_msgqueue.c
+++ b/drivers/staging/wilc1000/wilc_msgqueue.c
@@ -17,7 +17,7 @@ int wilc_mq_create(struct message_queue *pHandle)
 	sema_init(&pHandle->sem, 0);
 	pHandle->pstrMessageList = NULL;
 	pHandle->u32ReceiversCount = 0;
-	pHandle->bExiting = false;
+	pHandle->exiting = false;
 	return 0;
 }
 
@@ -29,7 +29,7 @@ int wilc_mq_create(struct message_queue *pHandle)
  */
 int wilc_mq_destroy(struct message_queue *pHandle)
 {
-	pHandle->bExiting = true;
+	pHandle->exiting = true;
 
 	/* Release any waiting receiver thread. */
 	while (pHandle->u32ReceiversCount > 0) {
@@ -64,7 +64,7 @@ int wilc_mq_send(struct message_queue *pHandle,
 		return -EFAULT;
 	}
 
-	if (pHandle->bExiting) {
+	if (pHandle->exiting) {
 		PRINT_ER("pHandle fail\n");
 		return -EFAULT;
 	}
@@ -123,7 +123,7 @@ int wilc_mq_recv(struct message_queue *pHandle,
 		return -EINVAL;
 	}
 
-	if (pHandle->bExiting) {
+	if (pHandle->exiting) {
 		PRINT_ER("pHandle fail\n");
 		return -EFAULT;
 	}
diff --git a/drivers/staging/wilc1000/wilc_msgqueue.h b/drivers/staging/wilc1000/wilc_msgqueue.h
index 6cdebbf..2c21b3e 100644
--- a/drivers/staging/wilc1000/wilc_msgqueue.h
+++ b/drivers/staging/wilc1000/wilc_msgqueue.h
@@ -22,7 +22,7 @@ struct message {
 struct message_queue {
 	struct semaphore sem;
 	spinlock_t lock;
-	bool bExiting;
+	bool exiting;
 	u32 u32ReceiversCount;
 	struct message *pstrMessageList;
 };
-- 
2.7.0

