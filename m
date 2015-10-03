Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f68.google.com ([209.85.220.68]:35757 "EHLO
	mail-pa0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894AbbJCJ2e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 Oct 2015 05:28:34 -0400
From: Chandra S Gorentla <csgorentla@gmail.com>
To: gregkh@linuxfoundation.org
Cc: dan.carpenter@oracle.com, johnny.kim@atmel.com,
	rachel.kim@atmel.com, chris.park@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org,
	Chandra S Gorentla <csgorentla@gmail.com>
Subject: [PATCH 1/2] drivers: staging: wilc1000: Move spin lock to the start of critical section
Date: Sat,  3 Oct 2015 14:57:29 +0530
Message-Id: <1443864450-18167-1-git-send-email-csgorentla@gmail.com> (sfid-20151003_112910_728823_C708F2AF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The spin_lock_irqsave is moved to just beginning of critical section.
This change moves a couple of return statements out of the lock.

Signed-off-by: Chandra S Gorentla <csgorentla@gmail.com>
---
 drivers/staging/wilc1000/wilc_msgqueue.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_msgqueue.c b/drivers/staging/wilc1000/wilc_msgqueue.c
index d5ebd6d..284a3f5 100644
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
@@ -87,6 +85,8 @@ int wilc_mq_send(WILC_MsgQueueHandle *pHandle,
 	}
 	memcpy(pstrMessage->pvBuffer, pvSendBuffer, u32SendBufferSize);
 
+	spin_lock_irqsave(&pHandle->strCriticalSection, flags);
+
 	/* add it to the message queue */
 	if (!pHandle->pstrMessageList) {
 		pHandle->pstrMessageList  = pstrMessage;
-- 
2.1.4

