Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:34002 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753785AbbITGwR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Sep 2015 02:52:17 -0400
Received: by padhy16 with SMTP id hy16so87436655pad.1
        for <linux-wireless@vger.kernel.org>; Sat, 19 Sep 2015 23:52:16 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 13/18] staging: wilc1000: wilc_msgqueue.c: replace s32RetStatus with result
Date: Sun, 20 Sep 2015 15:51:20 +0900
Message-Id: <1442731885-4344-13-git-send-email-chaehyun.lim@gmail.com> (sfid-20150920_091654_851444_D3E70D8C)
In-Reply-To: <1442731885-4344-1-git-send-email-chaehyun.lim@gmail.com>
References: <1442731885-4344-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces s32RetStatus with result to avoid CamelCase in
wilc_msgqueue.c

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_msgqueue.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_msgqueue.c b/drivers/staging/wilc1000/wilc_msgqueue.c
index 225bb99..869736a 100644
--- a/drivers/staging/wilc1000/wilc_msgqueue.c
+++ b/drivers/staging/wilc1000/wilc_msgqueue.c
@@ -55,19 +55,19 @@ int wilc_mq_destroy(WILC_MsgQueueHandle *pHandle)
 int wilc_mq_send(WILC_MsgQueueHandle *pHandle,
 			     const void *pvSendBuffer, u32 u32SendBufferSize)
 {
-	int s32RetStatus = 0;
+	int result = 0;
 	unsigned long flags;
 	Message *pstrMessage = NULL;
 
 	if ((!pHandle) || (u32SendBufferSize == 0) || (!pvSendBuffer)) {
 		PRINT_ER("pHandle or pvSendBuffer is null\n");
-		s32RetStatus = -EFAULT;
+		result = -EFAULT;
 		goto ERRORHANDLER;
 	}
 
 	if (pHandle->bExiting) {
 		PRINT_ER("pHandle fail\n");
-		s32RetStatus = -EFAULT;
+		result = -EFAULT;
 		goto ERRORHANDLER;
 	}
 
@@ -81,7 +81,7 @@ int wilc_mq_send(WILC_MsgQueueHandle *pHandle,
 	pstrMessage->pstrNext = NULL;
 	pstrMessage->pvBuffer = kmalloc(u32SendBufferSize, GFP_ATOMIC);
 	if (!pstrMessage->pvBuffer) {
-		s32RetStatus = -ENOMEM;
+		result = -ENOMEM;
 		goto ERRORHANDLER;
 	}
 	memcpy(pstrMessage->pvBuffer, pvSendBuffer, u32SendBufferSize);
@@ -109,7 +109,7 @@ ERRORHANDLER:
 		kfree(pstrMessage);
 	}
 
-	return s32RetStatus;
+	return result;
 }
 
 /*!
@@ -123,7 +123,7 @@ int wilc_mq_recv(WILC_MsgQueueHandle *pHandle,
 			     u32 *pu32ReceivedLength)
 {
 	Message *pstrMessage;
-	int s32RetStatus = 0;
+	int result = 0;
 	unsigned long flags;
 
 	if ((!pHandle) || (u32RecvBufferSize == 0)
@@ -144,9 +144,9 @@ int wilc_mq_recv(WILC_MsgQueueHandle *pHandle,
 	down(&pHandle->hSem);
 
 	/* other non-timeout scenarios */
-	if (s32RetStatus) {
+	if (result) {
 		PRINT_ER("Non-timeout\n");
-		return s32RetStatus;
+		return result;
 	}
 
 	if (pHandle->bExiting) {
@@ -182,5 +182,5 @@ int wilc_mq_recv(WILC_MsgQueueHandle *pHandle,
 
 	spin_unlock_irqrestore(&pHandle->strCriticalSection, flags);
 
-	return s32RetStatus;
+	return result;
 }
-- 
2.5.1

