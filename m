Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f182.google.com ([209.85.192.182]:33958 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524AbbHSG7U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Aug 2015 02:59:20 -0400
Received: by pdbfa8 with SMTP id fa8so77332400pdb.1
        for <linux-wireless@vger.kernel.org>; Tue, 18 Aug 2015 23:59:19 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, dean.lee@atmel.com,
	chris.park@atmel.com, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 01/13] staging: wilc1000: wilc_msgqueue.c: remove braces for single statement
Date: Wed, 19 Aug 2015 15:58:56 +0900
Message-Id: <1439967548-25876-1-git-send-email-chaehyun.lim@gmail.com> (sfid-20150819_085923_933878_91239283)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes braces for single statement blocks.
WARNING: braces {} are not necessary for single statement blocks

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_msgqueue.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_msgqueue.c b/drivers/staging/wilc1000/wilc_msgqueue.c
index f047d62..fcf3a29 100644
--- a/drivers/staging/wilc1000/wilc_msgqueue.c
+++ b/drivers/staging/wilc1000/wilc_msgqueue.c
@@ -84,9 +84,9 @@ WILC_ErrNo WILC_MsgQueueSend(WILC_MsgQueueHandle *pHandle,
 	} else {
 		Message *pstrTailMsg = pHandle->pstrMessageList;
 
-		while (pstrTailMsg->pstrNext != NULL) {
+		while (pstrTailMsg->pstrNext != NULL)
 			pstrTailMsg = pstrTailMsg->pstrNext;
-		}
+
 		pstrTailMsg->pstrNext = pstrMessage;
 	}
 
@@ -98,9 +98,9 @@ WILC_ErrNo WILC_MsgQueueSend(WILC_MsgQueueHandle *pHandle,
 	{
 		/* error occured, free any allocations */
 		if (pstrMessage != NULL) {
-			if (pstrMessage->pvBuffer != NULL) {
+			if (pstrMessage->pvBuffer != NULL)
 				kfree(pstrMessage->pvBuffer);
-			}
+
 			kfree(pstrMessage);
 		}
 	}
-- 
1.9.1

