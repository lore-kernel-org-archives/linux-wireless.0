Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f174.google.com ([209.85.192.174]:34958 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753014AbbHSG7g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Aug 2015 02:59:36 -0400
Received: by pdob1 with SMTP id b1so21900537pdo.2
        for <linux-wireless@vger.kernel.org>; Tue, 18 Aug 2015 23:59:36 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, dean.lee@atmel.com,
	chris.park@atmel.com, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 07/13] staging: wilc1000: wilc_msgqueue.c: remove kfree NULL check
Date: Wed, 19 Aug 2015 15:59:02 +0900
Message-Id: <1439967548-25876-7-git-send-email-chaehyun.lim@gmail.com> (sfid-20150819_085939_357717_6E354DFB)
In-Reply-To: <1439967548-25876-1-git-send-email-chaehyun.lim@gmail.com>
References: <1439967548-25876-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes kfree NULL check.
WARNING: kfree(NULL) is safe and this check is probably not required.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_msgqueue.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_msgqueue.c b/drivers/staging/wilc1000/wilc_msgqueue.c
index 0770ff6..d97dd70 100644
--- a/drivers/staging/wilc1000/wilc_msgqueue.c
+++ b/drivers/staging/wilc1000/wilc_msgqueue.c
@@ -96,9 +96,7 @@ WILC_ErrNo WILC_MsgQueueSend(WILC_MsgQueueHandle *pHandle,
 	{
 		/* error occured, free any allocations */
 		if (pstrMessage) {
-			if (pstrMessage->pvBuffer)
-				kfree(pstrMessage->pvBuffer);
-
+			kfree(pstrMessage->pvBuffer);
 			kfree(pstrMessage);
 		}
 	}
-- 
1.9.1

