Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:33105 "EHLO
	mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796AbcAUBUt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jan 2016 20:20:49 -0500
Received: by mail-pf0-f195.google.com with SMTP id e65so1068729pfe.0
        for <linux-wireless@vger.kernel.org>; Wed, 20 Jan 2016 17:20:49 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 03/27] staging: wilc1000: rename u32Length in struct message
Date: Thu, 21 Jan 2016 10:20:06 +0900
Message-Id: <1453339230-1377-3-git-send-email-chaehyun.lim@gmail.com> (sfid-20160121_022051_925124_312D6F7F)
In-Reply-To: <1453339230-1377-1-git-send-email-chaehyun.lim@gmail.com>
References: <1453339230-1377-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames u32Length to len to avoid camelcase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_msgqueue.c | 8 ++++----
 drivers/staging/wilc1000/wilc_msgqueue.h | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_msgqueue.c b/drivers/staging/wilc1000/wilc_msgqueue.c
index a4e612d..0e66a64 100644
--- a/drivers/staging/wilc1000/wilc_msgqueue.c
+++ b/drivers/staging/wilc1000/wilc_msgqueue.c
@@ -74,7 +74,7 @@ int wilc_mq_send(WILC_MsgQueueHandle *pHandle,
 	if (!pstrMessage)
 		return -ENOMEM;
 
-	pstrMessage->u32Length = u32SendBufferSize;
+	pstrMessage->len = u32SendBufferSize;
 	pstrMessage->pstrNext = NULL;
 	pstrMessage->buf = kmemdup(pvSendBuffer, u32SendBufferSize,
 				   GFP_ATOMIC);
@@ -142,7 +142,7 @@ int wilc_mq_recv(WILC_MsgQueueHandle *pHandle,
 		return -EFAULT;
 	}
 	/* check buffer size */
-	if (u32RecvBufferSize < pstrMessage->u32Length)	{
+	if (u32RecvBufferSize < pstrMessage->len) {
 		spin_unlock_irqrestore(&pHandle->strCriticalSection, flags);
 		up(&pHandle->hSem);
 		PRINT_ER("u32RecvBufferSize overflow\n");
@@ -151,8 +151,8 @@ int wilc_mq_recv(WILC_MsgQueueHandle *pHandle,
 
 	/* consume the message */
 	pHandle->u32ReceiversCount--;
-	memcpy(pvRecvBuffer, pstrMessage->buf, pstrMessage->u32Length);
-	*pu32ReceivedLength = pstrMessage->u32Length;
+	memcpy(pvRecvBuffer, pstrMessage->buf, pstrMessage->len);
+	*pu32ReceivedLength = pstrMessage->len;
 
 	pHandle->pstrMessageList = pstrMessage->pstrNext;
 
diff --git a/drivers/staging/wilc1000/wilc_msgqueue.h b/drivers/staging/wilc1000/wilc_msgqueue.h
index 848ed82..b0ccd1d 100644
--- a/drivers/staging/wilc1000/wilc_msgqueue.h
+++ b/drivers/staging/wilc1000/wilc_msgqueue.h
@@ -15,7 +15,7 @@
 /* Message Queue type is a structure */
 struct message {
 	void *buf;
-	u32 u32Length;
+	u32 len;
 	struct message *pstrNext;
 };
 
-- 
2.6.4

