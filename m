Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:36709 "EHLO
	mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965191AbcAULck (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jan 2016 06:32:40 -0500
Received: by mail-pf0-f193.google.com with SMTP id n128so1694186pfn.3
        for <linux-wireless@vger.kernel.org>; Thu, 21 Jan 2016 03:32:40 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH V2 18/27] staging: wilc1000: rename pstrTailMsg in wilc_mq_send
Date: Thu, 21 Jan 2016 20:30:48 +0900
Message-Id: <1453375857-20645-19-git-send-email-chaehyun.lim@gmail.com> (sfid-20160121_123654_247293_ED5E9FBD)
In-Reply-To: <1453375857-20645-1-git-send-email-chaehyun.lim@gmail.com>
References: <1453375857-20645-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames pstrTailMsg to tail_msg to avoid camelcase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_msgqueue.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_msgqueue.c b/drivers/staging/wilc1000/wilc_msgqueue.c
index 9a80fe6..764723f 100644
--- a/drivers/staging/wilc1000/wilc_msgqueue.c
+++ b/drivers/staging/wilc1000/wilc_msgqueue.c
@@ -88,12 +88,12 @@ int wilc_mq_send(struct message_queue *mq,
 	if (!mq->msg_list) {
 		mq->msg_list  = new_msg;
 	} else {
-		struct message *pstrTailMsg = mq->msg_list;
+		struct message *tail_msg = mq->msg_list;
 
-		while (pstrTailMsg->next)
-			pstrTailMsg = pstrTailMsg->next;
+		while (tail_msg->next)
+			tail_msg = tail_msg->next;
 
-		pstrTailMsg->next = new_msg;
+		tail_msg->next = new_msg;
 	}
 
 	spin_unlock_irqrestore(&mq->lock, flags);
-- 
2.7.0

