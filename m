Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:34841 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753798AbbIGPg4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Sep 2015 11:36:56 -0400
Received: by pacfv12 with SMTP id fv12so102008362pac.2
        for <linux-wireless@vger.kernel.org>; Mon, 07 Sep 2015 08:36:55 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 4/5] staging: wilc1000: wilc_msgqueue.c: use kmalloc with GFP_ATOMIC
Date: Tue,  8 Sep 2015 00:36:38 +0900
Message-Id: <1441640199-1507-4-git-send-email-chaehyun.lim@gmail.com> (sfid-20150907_173701_069567_D2BD0DFE)
In-Reply-To: <1441640199-1507-1-git-send-email-chaehyun.lim@gmail.com>
References: <1441640199-1507-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch use kmalloc with GFP_ATOMIC instead of WILC_MALLOC.
It is inside the spin lock region.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_msgqueue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/wilc_msgqueue.c b/drivers/staging/wilc1000/wilc_msgqueue.c
index 76d2e63..41244ce 100644
--- a/drivers/staging/wilc1000/wilc_msgqueue.c
+++ b/drivers/staging/wilc1000/wilc_msgqueue.c
@@ -72,7 +72,7 @@ int wilc_mq_send(WILC_MsgQueueHandle *pHandle,
 	WILC_NULLCHECK(s32RetStatus, pstrMessage);
 	pstrMessage->u32Length = u32SendBufferSize;
 	pstrMessage->pstrNext = NULL;
-	pstrMessage->pvBuffer = WILC_MALLOC(u32SendBufferSize);
+	pstrMessage->pvBuffer = kmalloc(u32SendBufferSize, GFP_ATOMIC);
 	WILC_NULLCHECK(s32RetStatus, pstrMessage->pvBuffer);
 	memcpy(pstrMessage->pvBuffer, pvSendBuffer, u32SendBufferSize);
 
-- 
2.5.1

