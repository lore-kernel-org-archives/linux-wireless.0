Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f65.google.com ([209.85.220.65]:33812 "EHLO
	mail-pa0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965238AbcAULdC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jan 2016 06:33:02 -0500
Received: by mail-pa0-f65.google.com with SMTP id yy13so1622790pab.1
        for <linux-wireless@vger.kernel.org>; Thu, 21 Jan 2016 03:33:02 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH V2 25/27] staging: wilc1000: fix coding style of kmalloc usage
Date: Thu, 21 Jan 2016 20:30:55 +0900
Message-Id: <1453375857-20645-26-git-send-email-chaehyun.lim@gmail.com> (sfid-20160121_123307_853073_C5703BB8)
In-Reply-To: <1453375857-20645-1-git-send-email-chaehyun.lim@gmail.com>
References: <1453375857-20645-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes coding style of kmalloc usage found by checkpatch.
CHECK: Prefer kmalloc(sizeof(*new_msg)...) over kmalloc(sizeof(struct message)...)

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_msgqueue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/wilc_msgqueue.c b/drivers/staging/wilc1000/wilc_msgqueue.c
index 7107715..c7a60f4 100644
--- a/drivers/staging/wilc1000/wilc_msgqueue.c
+++ b/drivers/staging/wilc1000/wilc_msgqueue.c
@@ -70,7 +70,7 @@ int wilc_mq_send(struct message_queue *mq,
 	}
 
 	/* construct a new message */
-	new_msg = kmalloc(sizeof(struct message), GFP_ATOMIC);
+	new_msg = kmalloc(sizeof(*new_msg), GFP_ATOMIC);
 	if (!new_msg)
 		return -ENOMEM;
 
-- 
2.7.0

