Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:47145 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755245AbbI3J4c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Sep 2015 05:56:32 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 32/32] staging: wilc1000: fix kernel fail after ifconfig wlan0 up
Date: Wed, 30 Sep 2015 18:55:14 +0900
Message-ID: <1443606914-25563-10-git-send-email-tony.cho@atmel.com> (sfid-20150930_115643_939242_B45E302E)
In-Reply-To: <1443606914-25563-1-git-send-email-tony.cho@atmel.com>
References: <1443606914-25563-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch fix kernel fail after ifconfig wlan0 up.
 - if normal operation, kfree functions don't execute.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/wilc_msgqueue.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_msgqueue.c b/drivers/staging/wilc1000/wilc_msgqueue.c
index d5ebd6d..f412121 100644
--- a/drivers/staging/wilc1000/wilc_msgqueue.c
+++ b/drivers/staging/wilc1000/wilc_msgqueue.c
@@ -76,8 +76,10 @@ int wilc_mq_send(WILC_MsgQueueHandle *pHandle,
 
 	/* construct a new message */
 	pstrMessage = kmalloc(sizeof(Message), GFP_ATOMIC);
-	if (!pstrMessage)
-		return -ENOMEM;
+	if (!pstrMessage) {
+		result = -ENOMEM;
+		goto ERRORHANDLER;
+	}
 	pstrMessage->u32Length = u32SendBufferSize;
 	pstrMessage->pstrNext = NULL;
 	pstrMessage->pvBuffer = kmalloc(u32SendBufferSize, GFP_ATOMIC);
@@ -104,10 +106,12 @@ int wilc_mq_send(WILC_MsgQueueHandle *pHandle,
 	up(&pHandle->hSem);
 
 ERRORHANDLER:
-	/* error occured, free any allocations */
-	if (pstrMessage) {
-		kfree(pstrMessage->pvBuffer);
-		kfree(pstrMessage);
+	if (result) {
+		/* error occured, free any allocations */
+		if (pstrMessage) {
+			kfree(pstrMessage->pvBuffer);
+			kfree(pstrMessage);
+		}
 	}
 
 	return result;
-- 
1.9.1

