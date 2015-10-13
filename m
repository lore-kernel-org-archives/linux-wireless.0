Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:4917 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932102AbbJMLDT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Oct 2015 07:03:19 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 54/54] staging: wilc1000: wilc_msgqueue.c : remove the goto ERRORHANDER
Date: Tue, 13 Oct 2015 20:02:12 +0900
Message-ID: <1444734132-17858-9-git-send-email-tony.cho@atmel.com> (sfid-20151013_130324_648816_E99A18FC)
In-Reply-To: <1444734132-17858-1-git-send-email-tony.cho@atmel.com>
References: <1444734132-17858-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch removes goto ERRORHANDER and the result variable in wilc_mq_send.
Then, the error type is directly returned. If normal operation, freeing memory
is not needed in this function.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/wilc_msgqueue.c | 20 +++++---------------
 1 file changed, 5 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_msgqueue.c b/drivers/staging/wilc1000/wilc_msgqueue.c
index b13809a..60539aa 100644
--- a/drivers/staging/wilc1000/wilc_msgqueue.c
+++ b/drivers/staging/wilc1000/wilc_msgqueue.c
@@ -56,20 +56,17 @@ int wilc_mq_destroy(WILC_MsgQueueHandle *pHandle)
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
 
 	spin_lock_irqsave(&pHandle->strCriticalSection, flags);
@@ -83,8 +80,8 @@ int wilc_mq_send(WILC_MsgQueueHandle *pHandle,
 	pstrMessage->pvBuffer = kmemdup(pvSendBuffer, u32SendBufferSize,
 					GFP_ATOMIC);
 	if (!pstrMessage->pvBuffer) {
-		result = -ENOMEM;
-		goto ERRORHANDLER;
+		kfree(pstrMessage);
+		return -ENOMEM;
 	}
 
 	/* add it to the message queue */
@@ -103,14 +100,7 @@ int wilc_mq_send(WILC_MsgQueueHandle *pHandle,
 
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
-- 
1.9.1

