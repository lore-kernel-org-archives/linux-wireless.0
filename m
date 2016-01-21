Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f68.google.com ([209.85.220.68]:35636 "EHLO
	mail-pa0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781AbcAUBVT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jan 2016 20:21:19 -0500
Received: by mail-pa0-f68.google.com with SMTP id gi1so1022480pac.2
        for <linux-wireless@vger.kernel.org>; Wed, 20 Jan 2016 17:21:19 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 13/27] staging: wilc1000: rename pstrMessge in wilc_mq_destroy
Date: Thu, 21 Jan 2016 10:20:16 +0900
Message-Id: <1453339230-1377-13-git-send-email-chaehyun.lim@gmail.com> (sfid-20160121_023659_271755_A61DA32A)
In-Reply-To: <1453339230-1377-1-git-send-email-chaehyun.lim@gmail.com>
References: <1453339230-1377-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames pstrMessge to msg to avoid camelcase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_msgqueue.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_msgqueue.c b/drivers/staging/wilc1000/wilc_msgqueue.c
index 103fcfd..a01420a 100644
--- a/drivers/staging/wilc1000/wilc_msgqueue.c
+++ b/drivers/staging/wilc1000/wilc_msgqueue.c
@@ -38,10 +38,10 @@ int wilc_mq_destroy(struct message_queue *mq)
 	}
 
 	while (mq->msg_list) {
-		struct message *pstrMessge = mq->msg_list->next;
+		struct message *msg = mq->msg_list->next;
 
 		kfree(mq->msg_list);
-		mq->msg_list = pstrMessge;
+		mq->msg_list = msg;
 	}
 
 	return 0;
-- 
2.6.4

