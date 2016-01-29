Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:34306 "EHLO
	mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756438AbcA2Ovo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jan 2016 09:51:44 -0500
Received: by mail-pf0-f195.google.com with SMTP id 65so3888952pfd.1
        for <linux-wireless@vger.kernel.org>; Fri, 29 Jan 2016 06:51:44 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 2/2] staging: wilc1000: wilc_msgqueue: release semaphore in error path
Date: Fri, 29 Jan 2016 23:51:33 +0900
Message-Id: <1454079093-7011-2-git-send-email-chaehyun.lim@gmail.com> (sfid-20160129_155157_075506_B3B0D91D)
In-Reply-To: <1454079093-7011-1-git-send-email-chaehyun.lim@gmail.com>
References: <1454079093-7011-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It should be called up(&mq->sem) to release semaphore before returning
error codes as -EFAULT when list is empty.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_msgqueue.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/wilc1000/wilc_msgqueue.c b/drivers/staging/wilc1000/wilc_msgqueue.c
index f57e4ec..5fe85eb 100644
--- a/drivers/staging/wilc1000/wilc_msgqueue.c
+++ b/drivers/staging/wilc1000/wilc_msgqueue.c
@@ -126,6 +126,7 @@ int wilc_mq_recv(struct message_queue *mq,
 
 	if (list_empty(&mq->msg_list)) {
 		spin_unlock_irqrestore(&mq->lock, flags);
+		up(&mq->sem);
 		PRINT_ER("msg is null\n");
 		return -EFAULT;
 	}
-- 
2.7.0

