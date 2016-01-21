Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:36767 "EHLO
	mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752511AbcAUBVh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jan 2016 20:21:37 -0500
Received: by mail-pf0-f196.google.com with SMTP id n128so1046919pfn.3
        for <linux-wireless@vger.kernel.org>; Wed, 20 Jan 2016 17:21:37 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 19/27] staging: wilc1000: fix return error code
Date: Thu, 21 Jan 2016 10:20:22 +0900
Message-Id: <1453339230-1377-19-git-send-email-chaehyun.lim@gmail.com> (sfid-20160121_023656_216900_EE1008A3)
In-Reply-To: <1453339230-1377-1-git-send-email-chaehyun.lim@gmail.com>
References: <1453339230-1377-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Three argument are checked at the beginning of wilc_mq_send whether
they are valid arguments or not. It is correct to use return error code
as -EINVAL, not -EFAULT.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_msgqueue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/wilc_msgqueue.c b/drivers/staging/wilc1000/wilc_msgqueue.c
index 764723f..361ca8f 100644
--- a/drivers/staging/wilc1000/wilc_msgqueue.c
+++ b/drivers/staging/wilc1000/wilc_msgqueue.c
@@ -61,7 +61,7 @@ int wilc_mq_send(struct message_queue *mq,
 
 	if ((!mq) || (send_buf_size == 0) || (!send_buf)) {
 		PRINT_ER("mq or send_buf is null\n");
-		return -EFAULT;
+		return -EINVAL;
 	}
 
 	if (mq->exiting) {
-- 
2.6.4

