Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f65.google.com ([209.85.220.65]:36720 "EHLO
	mail-pa0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759324AbcAULbs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jan 2016 06:31:48 -0500
Received: by mail-pa0-f65.google.com with SMTP id a20so1630844pag.3
        for <linux-wireless@vger.kernel.org>; Thu, 21 Jan 2016 03:31:48 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH V2 01/27] staging: wilc1000: rename struct __Message_struct
Date: Thu, 21 Jan 2016 20:30:31 +0900
Message-Id: <1453375857-20645-2-git-send-email-chaehyun.lim@gmail.com> (sfid-20160121_123151_894703_49ED2361)
In-Reply-To: <1453375857-20645-1-git-send-email-chaehyun.lim@gmail.com>
References: <1453375857-20645-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames typedef from struct __Message_struct and renames it
to struct message.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_msgqueue.c | 10 +++++-----
 drivers/staging/wilc1000/wilc_msgqueue.h |  8 ++++----
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_msgqueue.c b/drivers/staging/wilc1000/wilc_msgqueue.c
index abc780c..9b78fcd 100644
--- a/drivers/staging/wilc1000/wilc_msgqueue.c
+++ b/drivers/staging/wilc1000/wilc_msgqueue.c
@@ -38,7 +38,7 @@ int wilc_mq_destroy(WILC_MsgQueueHandle *pHandle)
 	}
 
 	while (pHandle->pstrMessageList) {
-		Message *pstrMessge = pHandle->pstrMessageList->pstrNext;
+		struct message *pstrMessge = pHandle->pstrMessageList->pstrNext;
 
 		kfree(pHandle->pstrMessageList);
 		pHandle->pstrMessageList = pstrMessge;
@@ -57,7 +57,7 @@ int wilc_mq_send(WILC_MsgQueueHandle *pHandle,
 			     const void *pvSendBuffer, u32 u32SendBufferSize)
 {
 	unsigned long flags;
-	Message *pstrMessage = NULL;
+	struct message *pstrMessage = NULL;
 
 	if ((!pHandle) || (u32SendBufferSize == 0) || (!pvSendBuffer)) {
 		PRINT_ER("pHandle or pvSendBuffer is null\n");
@@ -70,7 +70,7 @@ int wilc_mq_send(WILC_MsgQueueHandle *pHandle,
 	}
 
 	/* construct a new message */
-	pstrMessage = kmalloc(sizeof(Message), GFP_ATOMIC);
+	pstrMessage = kmalloc(sizeof(struct message), GFP_ATOMIC);
 	if (!pstrMessage)
 		return -ENOMEM;
 
@@ -89,7 +89,7 @@ int wilc_mq_send(WILC_MsgQueueHandle *pHandle,
 	if (!pHandle->pstrMessageList) {
 		pHandle->pstrMessageList  = pstrMessage;
 	} else {
-		Message *pstrTailMsg = pHandle->pstrMessageList;
+		struct message *pstrTailMsg = pHandle->pstrMessageList;
 
 		while (pstrTailMsg->pstrNext)
 			pstrTailMsg = pstrTailMsg->pstrNext;
@@ -114,7 +114,7 @@ int wilc_mq_recv(WILC_MsgQueueHandle *pHandle,
 			     void *pvRecvBuffer, u32 u32RecvBufferSize,
 			     u32 *pu32ReceivedLength)
 {
-	Message *pstrMessage;
+	struct message *pstrMessage;
 	unsigned long flags;
 
 	if ((!pHandle) || (u32RecvBufferSize == 0)
diff --git a/drivers/staging/wilc1000/wilc_msgqueue.h b/drivers/staging/wilc1000/wilc_msgqueue.h
index d7e0328..1a7c652 100644
--- a/drivers/staging/wilc1000/wilc_msgqueue.h
+++ b/drivers/staging/wilc1000/wilc_msgqueue.h
@@ -13,18 +13,18 @@
 #include <linux/semaphore.h>
 
 /* Message Queue type is a structure */
-typedef struct __Message_struct {
+struct message {
 	void *pvBuffer;
 	u32 u32Length;
-	struct __Message_struct *pstrNext;
-} Message;
+	struct message *pstrNext;
+};
 
 typedef struct __MessageQueue_struct {
 	struct semaphore hSem;
 	spinlock_t strCriticalSection;
 	bool bExiting;
 	u32 u32ReceiversCount;
-	Message *pstrMessageList;
+	struct message *pstrMessageList;
 } WILC_MsgQueueHandle;
 
 /*!
-- 
2.7.0

