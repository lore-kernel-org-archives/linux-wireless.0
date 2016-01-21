Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:33115 "EHLO
	mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796AbcAUBUw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jan 2016 20:20:52 -0500
Received: by mail-pf0-f194.google.com with SMTP id e65so1068807pfe.0
        for <linux-wireless@vger.kernel.org>; Wed, 20 Jan 2016 17:20:51 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 04/27] staging: wilc1000: rename pstrNext in struct message
Date: Thu, 21 Jan 2016 10:20:07 +0900
Message-Id: <1453339230-1377-4-git-send-email-chaehyun.lim@gmail.com> (sfid-20160121_022054_926294_2208D399)
In-Reply-To: <1453339230-1377-1-git-send-email-chaehyun.lim@gmail.com>
References: <1453339230-1377-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames pstrNext to next to avoid camelcase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_msgqueue.c | 12 ++++++------
 drivers/staging/wilc1000/wilc_msgqueue.h |  2 +-
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_msgqueue.c b/drivers/staging/wilc1000/wilc_msgqueue.c
index 0e66a64..4d79a31 100644
--- a/drivers/staging/wilc1000/wilc_msgqueue.c
+++ b/drivers/staging/wilc1000/wilc_msgqueue.c
@@ -38,7 +38,7 @@ int wilc_mq_destroy(WILC_MsgQueueHandle *pHandle)
 	}
 
 	while (pHandle->pstrMessageList) {
-		struct message *pstrMessge = pHandle->pstrMessageList->pstrNext;
+		struct message *pstrMessge = pHandle->pstrMessageList->next;
 
 		kfree(pHandle->pstrMessageList);
 		pHandle->pstrMessageList = pstrMessge;
@@ -75,7 +75,7 @@ int wilc_mq_send(WILC_MsgQueueHandle *pHandle,
 		return -ENOMEM;
 
 	pstrMessage->len = u32SendBufferSize;
-	pstrMessage->pstrNext = NULL;
+	pstrMessage->next = NULL;
 	pstrMessage->buf = kmemdup(pvSendBuffer, u32SendBufferSize,
 				   GFP_ATOMIC);
 	if (!pstrMessage->buf) {
@@ -91,10 +91,10 @@ int wilc_mq_send(WILC_MsgQueueHandle *pHandle,
 	} else {
 		struct message *pstrTailMsg = pHandle->pstrMessageList;
 
-		while (pstrTailMsg->pstrNext)
-			pstrTailMsg = pstrTailMsg->pstrNext;
+		while (pstrTailMsg->next)
+			pstrTailMsg = pstrTailMsg->next;
 
-		pstrTailMsg->pstrNext = pstrMessage;
+		pstrTailMsg->next = pstrMessage;
 	}
 
 	spin_unlock_irqrestore(&pHandle->strCriticalSection, flags);
@@ -154,7 +154,7 @@ int wilc_mq_recv(WILC_MsgQueueHandle *pHandle,
 	memcpy(pvRecvBuffer, pstrMessage->buf, pstrMessage->len);
 	*pu32ReceivedLength = pstrMessage->len;
 
-	pHandle->pstrMessageList = pstrMessage->pstrNext;
+	pHandle->pstrMessageList = pstrMessage->next;
 
 	kfree(pstrMessage->buf);
 	kfree(pstrMessage);
diff --git a/drivers/staging/wilc1000/wilc_msgqueue.h b/drivers/staging/wilc1000/wilc_msgqueue.h
index b0ccd1d..ec503c3 100644
--- a/drivers/staging/wilc1000/wilc_msgqueue.h
+++ b/drivers/staging/wilc1000/wilc_msgqueue.h
@@ -16,7 +16,7 @@
 struct message {
 	void *buf;
 	u32 len;
-	struct message *pstrNext;
+	struct message *next;
 };
 
 typedef struct __MessageQueue_struct {
-- 
2.6.4

