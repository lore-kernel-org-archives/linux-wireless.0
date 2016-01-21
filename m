Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f66.google.com ([209.85.220.66]:36036 "EHLO
	mail-pa0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754640AbcAUBVe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jan 2016 20:21:34 -0500
Received: by mail-pa0-f66.google.com with SMTP id a20so1010180pag.3
        for <linux-wireless@vger.kernel.org>; Wed, 20 Jan 2016 17:21:34 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 18/27] staging: wilc1000: rename tail_msg in wilc_mq_send
Date: Thu, 21 Jan 2016 10:20:21 +0900
Message-Id: <1453339230-1377-18-git-send-email-chaehyun.lim@gmail.com> (sfid-20160121_023658_307709_3464CEA4)
In-Reply-To: <1453339230-1377-1-git-send-email-chaehyun.lim@gmail.com>
References: <1453339230-1377-1-git-send-email-chaehyun.lim@gmail.com>
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
2.6.4

