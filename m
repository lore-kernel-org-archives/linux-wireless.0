Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:35013 "EHLO
	mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934244AbcAULcA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jan 2016 06:32:00 -0500
Received: by mail-pf0-f194.google.com with SMTP id 65so1704407pff.2
        for <linux-wireless@vger.kernel.org>; Thu, 21 Jan 2016 03:32:00 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH V2 05/27] staging: wilc1000: rename struct WILC_MsgQueueHandle
Date: Thu, 21 Jan 2016 20:30:35 +0900
Message-Id: <1453375857-20645-6-git-send-email-chaehyun.lim@gmail.com> (sfid-20160121_123205_264597_C4B44A4B)
In-Reply-To: <1453375857-20645-1-git-send-email-chaehyun.lim@gmail.com>
References: <1453375857-20645-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes typedef from struct WILC_MsgQueueHandle and renames
it to struct message_queue.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c |  2 +-
 drivers/staging/wilc1000/wilc_msgqueue.c  | 14 +++++++-------
 drivers/staging/wilc1000/wilc_msgqueue.h  | 18 +++++++++---------
 3 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 5fac516..98627a6 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -229,7 +229,7 @@ struct host_if_drv *terminated_handle;
 bool wilc_optaining_ip;
 static u8 P2P_LISTEN_STATE;
 static struct task_struct *hif_thread_handler;
-static WILC_MsgQueueHandle hif_msg_q;
+static struct message_queue hif_msg_q;
 static struct semaphore hif_sema_thread;
 static struct semaphore hif_sema_driver;
 static struct semaphore hif_sema_wait_response;
diff --git a/drivers/staging/wilc1000/wilc_msgqueue.c b/drivers/staging/wilc1000/wilc_msgqueue.c
index 4d79a31..907bae1 100644
--- a/drivers/staging/wilc1000/wilc_msgqueue.c
+++ b/drivers/staging/wilc1000/wilc_msgqueue.c
@@ -11,7 +11,7 @@
  *  @note		copied from FLO glue implementatuion
  *  @version		1.0
  */
-int wilc_mq_create(WILC_MsgQueueHandle *pHandle)
+int wilc_mq_create(struct message_queue *pHandle)
 {
 	spin_lock_init(&pHandle->strCriticalSection);
 	sema_init(&pHandle->hSem, 0);
@@ -27,7 +27,7 @@ int wilc_mq_create(WILC_MsgQueueHandle *pHandle)
  *  @note		copied from FLO glue implementatuion
  *  @version		1.0
  */
-int wilc_mq_destroy(WILC_MsgQueueHandle *pHandle)
+int wilc_mq_destroy(struct message_queue *pHandle)
 {
 	pHandle->bExiting = true;
 
@@ -53,8 +53,8 @@ int wilc_mq_destroy(WILC_MsgQueueHandle *pHandle)
  *  @note		copied from FLO glue implementatuion
  *  @version		1.0
  */
-int wilc_mq_send(WILC_MsgQueueHandle *pHandle,
-			     const void *pvSendBuffer, u32 u32SendBufferSize)
+int wilc_mq_send(struct message_queue *pHandle,
+		 const void *pvSendBuffer, u32 u32SendBufferSize)
 {
 	unsigned long flags;
 	struct message *pstrMessage = NULL;
@@ -110,9 +110,9 @@ int wilc_mq_send(WILC_MsgQueueHandle *pHandle,
  *  @note		copied from FLO glue implementatuion
  *  @version		1.0
  */
-int wilc_mq_recv(WILC_MsgQueueHandle *pHandle,
-			     void *pvRecvBuffer, u32 u32RecvBufferSize,
-			     u32 *pu32ReceivedLength)
+int wilc_mq_recv(struct message_queue *pHandle,
+		 void *pvRecvBuffer, u32 u32RecvBufferSize,
+		 u32 *pu32ReceivedLength)
 {
 	struct message *pstrMessage;
 	unsigned long flags;
diff --git a/drivers/staging/wilc1000/wilc_msgqueue.h b/drivers/staging/wilc1000/wilc_msgqueue.h
index ec503c3..111be46 100644
--- a/drivers/staging/wilc1000/wilc_msgqueue.h
+++ b/drivers/staging/wilc1000/wilc_msgqueue.h
@@ -19,13 +19,13 @@ struct message {
 	struct message *next;
 };
 
-typedef struct __MessageQueue_struct {
+struct message_queue {
 	struct semaphore hSem;
 	spinlock_t strCriticalSection;
 	bool bExiting;
 	u32 u32ReceiversCount;
 	struct message *pstrMessageList;
-} WILC_MsgQueueHandle;
+};
 
 /*!
  *  @brief		Creates a new Message queue
@@ -40,7 +40,7 @@ typedef struct __MessageQueue_struct {
  *  @date		30 Aug 2010
  *  @version		1.0
  */
-int wilc_mq_create(WILC_MsgQueueHandle *pHandle);
+int wilc_mq_create(struct message_queue *pHandle);
 
 /*!
  *  @brief		Sends a message
@@ -57,8 +57,8 @@ int wilc_mq_create(WILC_MsgQueueHandle *pHandle);
  *  @date		30 Aug 2010
  *  @version		1.0
  */
-int wilc_mq_send(WILC_MsgQueueHandle *pHandle,
-			     const void *pvSendBuffer, u32 u32SendBufferSize);
+int wilc_mq_send(struct message_queue *pHandle,
+		 const void *pvSendBuffer, u32 u32SendBufferSize);
 
 /*!
  *  @brief		Receives a message
@@ -76,9 +76,9 @@ int wilc_mq_send(WILC_MsgQueueHandle *pHandle,
  *  @date		30 Aug 2010
  *  @version		1.0
  */
-int wilc_mq_recv(WILC_MsgQueueHandle *pHandle,
-			     void *pvRecvBuffer, u32 u32RecvBufferSize,
-			     u32 *pu32ReceivedLength);
+int wilc_mq_recv(struct message_queue *pHandle,
+		 void *pvRecvBuffer, u32 u32RecvBufferSize,
+		 u32 *pu32ReceivedLength);
 
 /*!
  *  @brief		Destroys an existing  Message queue
@@ -89,6 +89,6 @@ int wilc_mq_recv(WILC_MsgQueueHandle *pHandle,
  *  @date		30 Aug 2010
  *  @version		1.0
  */
-int wilc_mq_destroy(WILC_MsgQueueHandle *pHandle);
+int wilc_mq_destroy(struct message_queue *pHandle);
 
 #endif
-- 
2.7.0

