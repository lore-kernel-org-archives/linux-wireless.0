Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f178.google.com ([209.85.192.178]:33920 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752566AbbHQCFX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Aug 2015 22:05:23 -0400
Received: by pdbfa8 with SMTP id fa8so50079884pdb.1
        for <linux-wireless@vger.kernel.org>; Sun, 16 Aug 2015 19:05:22 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, dean.lee@atmel.com,
	chris.park@atmel.com, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 1/6] staging: wilc1000: use kmalloc instead of WILC_NEW
Date: Mon, 17 Aug 2015 11:05:10 +0900
Message-Id: <1439777115-25861-1-git-send-email-chaehyun.lim@gmail.com> (sfid-20150817_040526_845642_076C91F1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

WILC_NEW is replaced by kmallo with GFP_ATOMIC.
This kmalloc is inside a spin_lock_irqsave region.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_msgqueue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/wilc_msgqueue.c b/drivers/staging/wilc1000/wilc_msgqueue.c
index 81f584d..9783c15 100644
--- a/drivers/staging/wilc1000/wilc_msgqueue.c
+++ b/drivers/staging/wilc1000/wilc_msgqueue.c
@@ -71,7 +71,7 @@ WILC_ErrNo WILC_MsgQueueSend(WILC_MsgQueueHandle *pHandle,
 	spin_lock_irqsave(&pHandle->strCriticalSection, flags);
 
 	/* construct a new message */
-	pstrMessage = WILC_NEW(Message, 1);
+	pstrMessage = kmalloc(sizeof(Message), GFP_ATOMIC);
 	WILC_NULLCHECK(s32RetStatus, pstrMessage);
 	pstrMessage->u32Length = u32SendBufferSize;
 	pstrMessage->pstrNext = NULL;
-- 
1.9.1

