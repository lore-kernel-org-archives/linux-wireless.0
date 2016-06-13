Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:36780 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422740AbcFMKid (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jun 2016 06:38:33 -0400
Received: by mail-pa0-f47.google.com with SMTP id b5so44694363pas.3
        for <linux-wireless@vger.kernel.org>; Mon, 13 Jun 2016 03:38:33 -0700 (PDT)
From: Binoy Jayan <binoy.jayan@linaro.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Johnny Kim <johnny.kim@atmel.com>,
	Austin Shin <austin.shin@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Tony Cho <tony.cho@atmel.com>, Glen Lee <glen.lee@atmel.com>,
	Leo Kim <leo.kim@atmel.com>, devel@driverdev.osuosl.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	Binoy Jayan <binoy.jayan@linaro.org>
Subject: [PATCH 6/7] staging: wilc1000: message_queue: Replace semaphore sem with completion
Date: Mon, 13 Jun 2016 16:07:38 +0530
Message-Id: <1465814259-3009-7-git-send-email-binoy.jayan@linaro.org> (sfid-20160613_123902_075690_D8FAFAB8)
In-Reply-To: <1465814259-3009-1-git-send-email-binoy.jayan@linaro.org>
References: <1465814259-3009-1-git-send-email-binoy.jayan@linaro.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The semaphore 'sem' is used as completion, so convert it to a
struct completion type.

Signed-off-by: Binoy Jayan <binoy.jayan@linaro.org>
---
 drivers/staging/wilc1000/wilc_msgqueue.c | 13 +++++++------
 drivers/staging/wilc1000/wilc_msgqueue.h |  4 ++--
 2 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_msgqueue.c b/drivers/staging/wilc1000/wilc_msgqueue.c
index 6cb894e..80c9631 100644
--- a/drivers/staging/wilc1000/wilc_msgqueue.c
+++ b/drivers/staging/wilc1000/wilc_msgqueue.c
@@ -3,6 +3,7 @@
 #include <linux/spinlock.h>
 #include <linux/errno.h>
 #include <linux/slab.h>
+#include <linux/completion.h>
 
 /*!
  *  @author		syounan
@@ -13,7 +14,7 @@
 int wilc_mq_create(struct message_queue *mq)
 {
 	spin_lock_init(&mq->lock);
-	sema_init(&mq->sem, 0);
+	init_completion(&mq->comp);
 	INIT_LIST_HEAD(&mq->msg_list);
 	mq->recv_count = 0;
 	mq->exiting = false;
@@ -34,7 +35,7 @@ int wilc_mq_destroy(struct message_queue *mq)
 
 	/* Release any waiting receiver thread. */
 	while (mq->recv_count > 0) {
-		up(&mq->sem);
+		complete(&mq->comp);
 		mq->recv_count--;
 	}
 
@@ -85,7 +86,7 @@ int wilc_mq_send(struct message_queue *mq,
 
 	spin_unlock_irqrestore(&mq->lock, flags);
 
-	up(&mq->sem);
+	complete(&mq->comp);
 
 	return 0;
 }
@@ -112,19 +113,19 @@ int wilc_mq_recv(struct message_queue *mq,
 	mq->recv_count++;
 	spin_unlock_irqrestore(&mq->lock, flags);
 
-	down(&mq->sem);
+	wait_for_completion(&mq->comp);
 	spin_lock_irqsave(&mq->lock, flags);
 
 	if (list_empty(&mq->msg_list)) {
 		spin_unlock_irqrestore(&mq->lock, flags);
-		up(&mq->sem);
+		complete(&mq->comp);
 		return -EFAULT;
 	}
 	/* check buffer size */
 	msg = list_first_entry(&mq->msg_list, struct message, list);
 	if (recv_buf_size < msg->len) {
 		spin_unlock_irqrestore(&mq->lock, flags);
-		up(&mq->sem);
+		complete(&mq->comp);
 		return -EOVERFLOW;
 	}
 
diff --git a/drivers/staging/wilc1000/wilc_msgqueue.h b/drivers/staging/wilc1000/wilc_msgqueue.h
index 846a484..a7a2e55 100644
--- a/drivers/staging/wilc1000/wilc_msgqueue.h
+++ b/drivers/staging/wilc1000/wilc_msgqueue.h
@@ -1,7 +1,7 @@
 #ifndef __WILC_MSG_QUEUE_H__
 #define __WILC_MSG_QUEUE_H__
 
-#include <linux/semaphore.h>
+#include <linux/completion.h>
 #include <linux/list.h>
 
 struct message {
@@ -11,7 +11,7 @@ struct message {
 };
 
 struct message_queue {
-	struct semaphore sem;
+	struct completion comp;
 	spinlock_t lock;
 	bool exiting;
 	u32 recv_count;
-- 
2.7.4

