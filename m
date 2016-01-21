Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:34423 "EHLO
	mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965156AbcAULcW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jan 2016 06:32:22 -0500
Received: by mail-pf0-f195.google.com with SMTP id 65so1708038pfd.1
        for <linux-wireless@vger.kernel.org>; Thu, 21 Jan 2016 03:32:22 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH V2 12/27] staging: wilc1000: rename pHandle in wilc_mq_destroy
Date: Thu, 21 Jan 2016 20:30:42 +0900
Message-Id: <1453375857-20645-13-git-send-email-chaehyun.lim@gmail.com> (sfid-20160121_123655_909415_84EF59F5)
In-Reply-To: <1453375857-20645-1-git-send-email-chaehyun.lim@gmail.com>
References: <1453375857-20645-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames pHandle to mq to avoid camelcase

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_msgqueue.c | 18 +++++++++---------
 drivers/staging/wilc1000/wilc_msgqueue.h |  2 +-
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_msgqueue.c b/drivers/staging/wilc1000/wilc_msgqueue.c
index 453fa19..103fcfd 100644
--- a/drivers/staging/wilc1000/wilc_msgqueue.c
+++ b/drivers/staging/wilc1000/wilc_msgqueue.c
@@ -27,21 +27,21 @@ int wilc_mq_create(struct message_queue *mq)
  *  @note		copied from FLO glue implementatuion
  *  @version		1.0
  */
-int wilc_mq_destroy(struct message_queue *pHandle)
+int wilc_mq_destroy(struct message_queue *mq)
 {
-	pHandle->exiting = true;
+	mq->exiting = true;
 
 	/* Release any waiting receiver thread. */
-	while (pHandle->recv_count > 0) {
-		up(&pHandle->sem);
-		pHandle->recv_count--;
+	while (mq->recv_count > 0) {
+		up(&mq->sem);
+		mq->recv_count--;
 	}
 
-	while (pHandle->msg_list) {
-		struct message *pstrMessge = pHandle->msg_list->next;
+	while (mq->msg_list) {
+		struct message *pstrMessge = mq->msg_list->next;
 
-		kfree(pHandle->msg_list);
-		pHandle->msg_list = pstrMessge;
+		kfree(mq->msg_list);
+		mq->msg_list = pstrMessge;
 	}
 
 	return 0;
diff --git a/drivers/staging/wilc1000/wilc_msgqueue.h b/drivers/staging/wilc1000/wilc_msgqueue.h
index bfd2347..b91822e 100644
--- a/drivers/staging/wilc1000/wilc_msgqueue.h
+++ b/drivers/staging/wilc1000/wilc_msgqueue.h
@@ -89,6 +89,6 @@ int wilc_mq_recv(struct message_queue *pHandle,
  *  @date		30 Aug 2010
  *  @version		1.0
  */
-int wilc_mq_destroy(struct message_queue *pHandle);
+int wilc_mq_destroy(struct message_queue *mq);
 
 #endif
-- 
2.7.0

