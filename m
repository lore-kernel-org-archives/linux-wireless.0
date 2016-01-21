Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f68.google.com ([209.85.220.68]:35717 "EHLO
	mail-pa0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755620AbcAUBVz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jan 2016 20:21:55 -0500
Received: by mail-pa0-f68.google.com with SMTP id gi1so1023009pac.2
        for <linux-wireless@vger.kernel.org>; Wed, 20 Jan 2016 17:21:55 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 25/27] staging: wilc1000: fix coding style of kmalloc usage
Date: Thu, 21 Jan 2016 10:20:28 +0900
Message-Id: <1453339230-1377-25-git-send-email-chaehyun.lim@gmail.com> (sfid-20160121_023657_692282_5177BFDE)
In-Reply-To: <1453339230-1377-1-git-send-email-chaehyun.lim@gmail.com>
References: <1453339230-1377-1-git-send-email-chaehyun.lim@gmail.com>
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
2.6.4

