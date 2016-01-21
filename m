Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f66.google.com ([209.85.220.66]:35818 "EHLO
	mail-pa0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759324AbcAULbv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jan 2016 06:31:51 -0500
Received: by mail-pa0-f66.google.com with SMTP id gi1so1650809pac.2
        for <linux-wireless@vger.kernel.org>; Thu, 21 Jan 2016 03:31:51 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH V2 02/27] staging: wilc1000: rename pvBuffer in struct message
Date: Thu, 21 Jan 2016 20:30:32 +0900
Message-Id: <1453375857-20645-3-git-send-email-chaehyun.lim@gmail.com> (sfid-20160121_123154_332446_0C5C50BF)
In-Reply-To: <1453375857-20645-1-git-send-email-chaehyun.lim@gmail.com>
References: <1453375857-20645-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames pvBuffer to buf to avoid camelcase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_msgqueue.c | 10 +++++-----
 drivers/staging/wilc1000/wilc_msgqueue.h |  2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_msgqueue.c b/drivers/staging/wilc1000/wilc_msgqueue.c
index 9b78fcd..a4e612d 100644
--- a/drivers/staging/wilc1000/wilc_msgqueue.c
+++ b/drivers/staging/wilc1000/wilc_msgqueue.c
@@ -76,9 +76,9 @@ int wilc_mq_send(WILC_MsgQueueHandle *pHandle,
 
 	pstrMessage->u32Length = u32SendBufferSize;
 	pstrMessage->pstrNext = NULL;
-	pstrMessage->pvBuffer = kmemdup(pvSendBuffer, u32SendBufferSize,
-					GFP_ATOMIC);
-	if (!pstrMessage->pvBuffer) {
+	pstrMessage->buf = kmemdup(pvSendBuffer, u32SendBufferSize,
+				   GFP_ATOMIC);
+	if (!pstrMessage->buf) {
 		kfree(pstrMessage);
 		return -ENOMEM;
 	}
@@ -151,12 +151,12 @@ int wilc_mq_recv(WILC_MsgQueueHandle *pHandle,
 
 	/* consume the message */
 	pHandle->u32ReceiversCount--;
-	memcpy(pvRecvBuffer, pstrMessage->pvBuffer, pstrMessage->u32Length);
+	memcpy(pvRecvBuffer, pstrMessage->buf, pstrMessage->u32Length);
 	*pu32ReceivedLength = pstrMessage->u32Length;
 
 	pHandle->pstrMessageList = pstrMessage->pstrNext;
 
-	kfree(pstrMessage->pvBuffer);
+	kfree(pstrMessage->buf);
 	kfree(pstrMessage);
 
 	spin_unlock_irqrestore(&pHandle->strCriticalSection, flags);
diff --git a/drivers/staging/wilc1000/wilc_msgqueue.h b/drivers/staging/wilc1000/wilc_msgqueue.h
index 1a7c652..848ed82 100644
--- a/drivers/staging/wilc1000/wilc_msgqueue.h
+++ b/drivers/staging/wilc1000/wilc_msgqueue.h
@@ -14,7 +14,7 @@
 
 /* Message Queue type is a structure */
 struct message {
-	void *pvBuffer;
+	void *buf;
 	u32 u32Length;
 	struct message *pstrNext;
 };
-- 
2.7.0

