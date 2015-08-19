Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:36504 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752904AbbHSG7a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Aug 2015 02:59:30 -0400
Received: by pawq9 with SMTP id q9so54084424paw.3
        for <linux-wireless@vger.kernel.org>; Tue, 18 Aug 2015 23:59:30 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, dean.lee@atmel.com,
	chris.park@atmel.com, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 05/13] staging: wilc1000: wilc_msgqueue.c: remove unnecessary parentheses
Date: Wed, 19 Aug 2015 15:59:00 +0900
Message-Id: <1439967548-25876-5-git-send-email-chaehyun.lim@gmail.com> (sfid-20150819_085933_457761_6F9974B1)
In-Reply-To: <1439967548-25876-1-git-send-email-chaehyun.lim@gmail.com>
References: <1439967548-25876-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch remove unnecessary parentheses found by checkpatch.pl
CHECK: Unnecessary parentheses around pHandle->hSem

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_msgqueue.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_msgqueue.c b/drivers/staging/wilc1000/wilc_msgqueue.c
index 8cb74d1..53ce586 100644
--- a/drivers/staging/wilc1000/wilc_msgqueue.c
+++ b/drivers/staging/wilc1000/wilc_msgqueue.c
@@ -30,7 +30,7 @@ WILC_ErrNo WILC_MsgQueueDestroy(WILC_MsgQueueHandle *pHandle)
 
 	/* Release any waiting receiver thread. */
 	while (pHandle->u32ReceiversCount > 0) {
-		up(&(pHandle->hSem));
+		up(&pHandle->hSem);
 		pHandle->u32ReceiversCount--;
 	}
 
@@ -133,7 +133,7 @@ WILC_ErrNo WILC_MsgQueueRecv(WILC_MsgQueueHandle *pHandle,
 	pHandle->u32ReceiversCount++;
 	spin_unlock_irqrestore(&pHandle->strCriticalSection, flags);
 
-	down(&(pHandle->hSem));
+	down(&pHandle->hSem);
 
 	if (s32RetStatus == WILC_TIMEOUT) {
 		/* timed out, just exit without consumeing the message */
-- 
1.9.1

