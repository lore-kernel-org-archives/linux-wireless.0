Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f68.google.com ([209.85.220.68]:32982 "EHLO
	mail-pa0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932741AbcATHpR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jan 2016 02:45:17 -0500
Received: by mail-pa0-f68.google.com with SMTP id pv5so41054pac.0
        for <linux-wireless@vger.kernel.org>; Tue, 19 Jan 2016 23:45:17 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH] staging: wilc1000: remove redundant check in wilc_mq_recv
Date: Wed, 20 Jan 2016 16:44:57 +0900
Message-Id: <1453275897-13395-1-git-send-email-chaehyun.lim@gmail.com> (sfid-20160120_084521_611779_216D1953)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

At the beginning of wilc_mq_recv, it is checked if pHandle->bExiting is
false or true. There is no need to check it again at the middle of this
function. So just remove it.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_msgqueue.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_msgqueue.c b/drivers/staging/wilc1000/wilc_msgqueue.c
index 098390c..abc780c 100644
--- a/drivers/staging/wilc1000/wilc_msgqueue.c
+++ b/drivers/staging/wilc1000/wilc_msgqueue.c
@@ -133,12 +133,6 @@ int wilc_mq_recv(WILC_MsgQueueHandle *pHandle,
 	spin_unlock_irqrestore(&pHandle->strCriticalSection, flags);
 
 	down(&pHandle->hSem);
-
-	if (pHandle->bExiting) {
-		PRINT_ER("pHandle fail\n");
-		return -EFAULT;
-	}
-
 	spin_lock_irqsave(&pHandle->strCriticalSection, flags);
 
 	pstrMessage = pHandle->pstrMessageList;
-- 
2.6.4

