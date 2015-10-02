Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f66.google.com ([209.85.220.66]:34086 "EHLO
	mail-pa0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018AbbJBNSe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Oct 2015 09:18:34 -0400
From: Chandra S Gorentla <csgorentla@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org, dan.carpenter@oracle.com,
	Chandra S Gorentla <csgorentla@gmail.com>
Subject: [PATCH 3/3] drivers: staging: wilc1000: Do not return from function with lock is on
Date: Fri,  2 Oct 2015 18:47:37 +0530
Message-Id: <1443791857-7837-3-git-send-email-csgorentla@gmail.com> (sfid-20151002_151853_081375_EFF80280)
In-Reply-To: <1443791857-7837-2-git-send-email-csgorentla@gmail.com>
References: <1443791857-7837-1-git-send-email-csgorentla@gmail.com>
 <1443791857-7837-2-git-send-email-csgorentla@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There are a couple of return statements before unlock.  Lock is moved
to a location just before queue manipulation.

Signed-off-by: Chandra S Gorentla <csgorentla@gmail.com>
---
 drivers/staging/wilc1000/wilc_msgqueue.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_msgqueue.c b/drivers/staging/wilc1000/wilc_msgqueue.c
index a9c28ad..2fa3792 100644
--- a/drivers/staging/wilc1000/wilc_msgqueue.c
+++ b/drivers/staging/wilc1000/wilc_msgqueue.c
@@ -72,8 +72,6 @@ int wilc_mq_send(WILC_MsgQueueHandle *pHandle,
 		goto ERRORHANDLER;
 	}
 
-	spin_lock_irqsave(&pHandle->strCriticalSection, flags);
-
 	/* construct a new message */
 	pstrMessage = kmalloc(sizeof(Message), GFP_ATOMIC);
 	if (!pstrMessage)
@@ -88,6 +86,8 @@ int wilc_mq_send(WILC_MsgQueueHandle *pHandle,
 	memcpy(pstrMessage->pvBuffer, pvSendBuffer, u32SendBufferSize);
 
 	/* add it to the message queue */
+	spin_lock_irqsave(&pHandle->strCriticalSection, flags);
+
 	if (!pHandle->pstrMessageList) {
 		pHandle->pstrMessageList  = pstrMessage;
 	} else {
-- 
2.1.4

