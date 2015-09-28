Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f68.google.com ([209.85.220.68]:36154 "EHLO
	mail-pa0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752247AbbI1SOU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Sep 2015 14:14:20 -0400
From: Chandra S Gorentla <csgorentla@gmail.com>
To: gregkh@linuxfoundation.org
Cc: dan.carpenter@oracle.com, johnny.kim@atmel.com,
	rachel.kim@atmel.com, dean.lee@atmel.com, chris.park@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org, sudipm.mukherjee@gmail.com,
	Chandra S Gorentla <csgorentla@gmail.com>
Subject: [PATCH 1/2] drivers: staging: wilc1000: Replace message queue with standard Linux lists
Date: Mon, 28 Sep 2015 23:43:55 +0530
Message-Id: <1443464037-3591-1-git-send-email-csgorentla@gmail.com> (sfid-20150928_201524_801474_B779BF40)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 - The message queue is replaced with standard Linux linked list
 - kmem_cache is used for list members
 - A check for return value of receive method is added
 - GFP_ATOMIC is changed to GFP_KERNEL
 - A few other related minor changes

Signed-off-by: Chandra S Gorentla <csgorentla@gmail.com>
---
 - Comments of Dan Carpenter are taken care
   - If receive method return value not checked, case statement for previous
     message may get executed if not done
   - Indication of usage of 'kmem_cache' is added to the description
   - Memory allocation donw outside spin_lock; GFP_ATOMIC replaced
     with GFP_KERNEL
   - spin_lock, spin_unlock are matched
   - goto statements removed
   - Unrelated changes moved to a different patch
   - PRINT_ERR can be taken up in a seperate patch

 drivers/staging/wilc1000/host_interface.c |  7 ++-
 drivers/staging/wilc1000/wilc_msgqueue.c  | 73 +++++++++++++------------------
 drivers/staging/wilc1000/wilc_platform.h  |  5 ++-
 3 files changed, 40 insertions(+), 45 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 62f4a8a..954656d 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -4304,11 +4304,16 @@ static int hostIFthread(void *pvArg)
 	u32 u32Ret;
 	struct host_if_msg msg;
 	tstrWILC_WFIDrv *pstrWFIDrv;
+	int ret;
 
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
 	while (1) {
-		wilc_mq_recv(&gMsgQHostIF, &msg, sizeof(struct host_if_msg), &u32Ret);
+		ret = wilc_mq_recv(&gMsgQHostIF, &msg,
+					sizeof(struct host_if_msg), &u32Ret);
+		if (ret)
+			continue;
+
 		pstrWFIDrv = (tstrWILC_WFIDrv *)msg.drvHandler;
 		if (msg.id == HOST_IF_MSG_EXIT) {
 			PRINT_D(GENERIC_DBG, "THREAD: Exiting HostIfThread\n");
diff --git a/drivers/staging/wilc1000/wilc_msgqueue.c b/drivers/staging/wilc1000/wilc_msgqueue.c
index 869736a..a01ada4 100644
--- a/drivers/staging/wilc1000/wilc_msgqueue.c
+++ b/drivers/staging/wilc1000/wilc_msgqueue.c
@@ -12,9 +12,15 @@
  */
 int wilc_mq_create(WILC_MsgQueueHandle *pHandle)
 {
+	pHandle->msg_cache = kmem_cache_create("wilc_message_queue",
+						sizeof(Message),
+						0, SLAB_POISON, NULL);
+	if (!pHandle->msg_cache)
+		return -ENOMEM;
+
 	spin_lock_init(&pHandle->strCriticalSection);
 	sema_init(&pHandle->hSem, 0);
-	pHandle->pstrMessageList = NULL;
+	INIT_LIST_HEAD(&pHandle->msg_list_head);
 	pHandle->u32ReceiversCount = 0;
 	pHandle->bExiting = false;
 	return 0;
@@ -28,6 +34,7 @@ int wilc_mq_create(WILC_MsgQueueHandle *pHandle)
  */
 int wilc_mq_destroy(WILC_MsgQueueHandle *pHandle)
 {
+	Message *msg;
 	pHandle->bExiting = true;
 
 	/* Release any waiting receiver thread. */
@@ -36,13 +43,16 @@ int wilc_mq_destroy(WILC_MsgQueueHandle *pHandle)
 		pHandle->u32ReceiversCount--;
 	}
 
-	while (pHandle->pstrMessageList) {
-		Message *pstrMessge = pHandle->pstrMessageList->pstrNext;
-
-		kfree(pHandle->pstrMessageList);
-		pHandle->pstrMessageList = pstrMessge;
+	while (!list_empty(&pHandle->msg_list_head)) {
+		msg = list_first_entry(&pHandle->msg_list_head,
+					Message, link);
+		list_del(&msg->link);
+		kfree(msg->pvBuffer);
+		kmem_cache_free(pHandle->msg_cache, msg);
 	}
 
+	kmem_cache_destroy(pHandle->msg_cache);
+
 	return 0;
 }
 
@@ -55,61 +65,40 @@ int wilc_mq_destroy(WILC_MsgQueueHandle *pHandle)
 int wilc_mq_send(WILC_MsgQueueHandle *pHandle,
 			     const void *pvSendBuffer, u32 u32SendBufferSize)
 {
-	int result = 0;
 	unsigned long flags;
 	Message *pstrMessage = NULL;
 
 	if ((!pHandle) || (u32SendBufferSize == 0) || (!pvSendBuffer)) {
 		PRINT_ER("pHandle or pvSendBuffer is null\n");
-		result = -EFAULT;
-		goto ERRORHANDLER;
+		return -EFAULT;
 	}
 
 	if (pHandle->bExiting) {
 		PRINT_ER("pHandle fail\n");
-		result = -EFAULT;
-		goto ERRORHANDLER;
+		return -EFAULT;
 	}
 
-	spin_lock_irqsave(&pHandle->strCriticalSection, flags);
-
 	/* construct a new message */
-	pstrMessage = kmalloc(sizeof(Message), GFP_ATOMIC);
+	pstrMessage = kmem_cache_zalloc(pHandle->msg_cache, GFP_KERNEL);
 	if (!pstrMessage)
 		return -ENOMEM;
+
 	pstrMessage->u32Length = u32SendBufferSize;
-	pstrMessage->pstrNext = NULL;
-	pstrMessage->pvBuffer = kmalloc(u32SendBufferSize, GFP_ATOMIC);
+	pstrMessage->pvBuffer = kmalloc(u32SendBufferSize, GFP_KERNEL);
 	if (!pstrMessage->pvBuffer) {
-		result = -ENOMEM;
-		goto ERRORHANDLER;
+		kmem_cache_free(pHandle->msg_cache, pstrMessage);
+		return -ENOMEM;
 	}
 	memcpy(pstrMessage->pvBuffer, pvSendBuffer, u32SendBufferSize);
 
 	/* add it to the message queue */
-	if (!pHandle->pstrMessageList) {
-		pHandle->pstrMessageList  = pstrMessage;
-	} else {
-		Message *pstrTailMsg = pHandle->pstrMessageList;
-
-		while (pstrTailMsg->pstrNext)
-			pstrTailMsg = pstrTailMsg->pstrNext;
-
-		pstrTailMsg->pstrNext = pstrMessage;
-	}
-
+	spin_lock_irqsave(&pHandle->strCriticalSection, flags);
+	list_add_tail(&pstrMessage->link, &pHandle->msg_list_head);
 	spin_unlock_irqrestore(&pHandle->strCriticalSection, flags);
 
 	up(&pHandle->hSem);
 
-ERRORHANDLER:
-	/* error occured, free any allocations */
-	if (pstrMessage) {
-		kfree(pstrMessage->pvBuffer);
-		kfree(pstrMessage);
-	}
-
-	return result;
+	return 0;
 }
 
 /*!
@@ -156,12 +145,13 @@ int wilc_mq_recv(WILC_MsgQueueHandle *pHandle,
 
 	spin_lock_irqsave(&pHandle->strCriticalSection, flags);
 
-	pstrMessage = pHandle->pstrMessageList;
-	if (!pstrMessage) {
+	if (list_empty(&pHandle->msg_list_head)) {
 		spin_unlock_irqrestore(&pHandle->strCriticalSection, flags);
 		PRINT_ER("pstrMessage is null\n");
 		return -EFAULT;
 	}
+
+	pstrMessage = list_first_entry(&pHandle->msg_list_head, Message, link);
 	/* check buffer size */
 	if (u32RecvBufferSize < pstrMessage->u32Length)	{
 		spin_unlock_irqrestore(&pHandle->strCriticalSection, flags);
@@ -175,10 +165,9 @@ int wilc_mq_recv(WILC_MsgQueueHandle *pHandle,
 	memcpy(pvRecvBuffer, pstrMessage->pvBuffer, pstrMessage->u32Length);
 	*pu32ReceivedLength = pstrMessage->u32Length;
 
-	pHandle->pstrMessageList = pstrMessage->pstrNext;
-
+	list_del(&pstrMessage->link);
 	kfree(pstrMessage->pvBuffer);
-	kfree(pstrMessage);
+	kmem_cache_free(pHandle->msg_cache, pstrMessage);
 
 	spin_unlock_irqrestore(&pHandle->strCriticalSection, flags);
 
diff --git a/drivers/staging/wilc1000/wilc_platform.h b/drivers/staging/wilc1000/wilc_platform.h
index b763616..3871658 100644
--- a/drivers/staging/wilc1000/wilc_platform.h
+++ b/drivers/staging/wilc1000/wilc_platform.h
@@ -20,7 +20,7 @@
 typedef struct __Message_struct {
 	void *pvBuffer;
 	u32 u32Length;
-	struct __Message_struct *pstrNext;
+	struct list_head link;
 } Message;
 
 typedef struct __MessageQueue_struct {
@@ -28,7 +28,8 @@ typedef struct __MessageQueue_struct {
 	spinlock_t strCriticalSection;
 	bool bExiting;
 	u32 u32ReceiversCount;
-	Message *pstrMessageList;
+	struct list_head msg_list_head;
+	struct kmem_cache *msg_cache;
 } WILC_MsgQueueHandle;
 
 
-- 
2.1.4

