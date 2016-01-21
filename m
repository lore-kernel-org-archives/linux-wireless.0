Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:33158 "EHLO
	mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781AbcAUBVN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jan 2016 20:21:13 -0500
Received: by mail-pf0-f196.google.com with SMTP id e65so1069061pfe.0
        for <linux-wireless@vger.kernel.org>; Wed, 20 Jan 2016 17:21:13 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 11/27] staging: wilc1000: rename pHandle in wilc_mq_create
Date: Thu, 21 Jan 2016 10:20:14 +0900
Message-Id: <1453339230-1377-11-git-send-email-chaehyun.lim@gmail.com> (sfid-20160121_023655_207681_E21E5358)
In-Reply-To: <1453339230-1377-1-git-send-email-chaehyun.lim@gmail.com>
References: <1453339230-1377-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames pHandle to mq to avoid camelcase

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_msgqueue.c | 12 ++++++------
 drivers/staging/wilc1000/wilc_msgqueue.h |  2 +-
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_msgqueue.c b/drivers/staging/wilc1000/wilc_msgqueue.c
index d13c9a7..453fa19 100644
--- a/drivers/staging/wilc1000/wilc_msgqueue.c
+++ b/drivers/staging/wilc1000/wilc_msgqueue.c
@@ -11,13 +11,13 @@
  *  @note		copied from FLO glue implementatuion
  *  @version		1.0
  */
-int wilc_mq_create(struct message_queue *pHandle)
+int wilc_mq_create(struct message_queue *mq)
 {
-	spin_lock_init(&pHandle->lock);
-	sema_init(&pHandle->sem, 0);
-	pHandle->msg_list = NULL;
-	pHandle->recv_count = 0;
-	pHandle->exiting = false;
+	spin_lock_init(&mq->lock);
+	sema_init(&mq->sem, 0);
+	mq->msg_list = NULL;
+	mq->recv_count = 0;
+	mq->exiting = false;
 	return 0;
 }
 
diff --git a/drivers/staging/wilc1000/wilc_msgqueue.h b/drivers/staging/wilc1000/wilc_msgqueue.h
index 7e7ec06..bfd2347 100644
--- a/drivers/staging/wilc1000/wilc_msgqueue.h
+++ b/drivers/staging/wilc1000/wilc_msgqueue.h
@@ -40,7 +40,7 @@ struct message_queue {
  *  @date		30 Aug 2010
  *  @version		1.0
  */
-int wilc_mq_create(struct message_queue *pHandle);
+int wilc_mq_create(struct message_queue *mq);
 
 /*!
  *  @brief		Sends a message
-- 
2.6.4

