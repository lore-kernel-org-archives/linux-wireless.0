Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:49730 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755826AbZC0PoT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Mar 2009 11:44:19 -0400
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Ivo van Doorn <IvDoorn@gmail.com>
Subject: [PATCH 3/4] rfkill: defensive use of test_bit
Date: Fri, 27 Mar 2009 12:44:10 -0300
Message-Id: <1238168651-28891-4-git-send-email-hmh@hmh.eng.br> (sfid-20090327_164422_966061_BFD779BB)
In-Reply-To: <1238168651-28891-1-git-send-email-hmh@hmh.eng.br>
References: <1238168651-28891-1-git-send-email-hmh@hmh.eng.br>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

test_bit can return negative values for true, not just 0 or 1.  This
has already caused a bug in rfkill once, so it is best to take a more
defensive position in its use.

While at it, also make some booleans more explicit.

This change is for future-proofing, the code works as-is.

Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Ivo van Doorn <IvDoorn@gmail.com>
---
 net/rfkill/rfkill-input.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/rfkill/rfkill-input.c b/net/rfkill/rfkill-input.c
index 84efde9..d8a9b70 100644
--- a/net/rfkill/rfkill-input.c
+++ b/net/rfkill/rfkill-input.c
@@ -173,11 +173,11 @@ static void rfkill_task_handler(struct work_struct *work)
 					bool c;
 #ifdef RFKILL_NEED_SWSET
 					bool sp, s;
-					sp = test_and_clear_bit(i,
+					sp = !!test_and_clear_bit(i,
 							task->sw_setpending);
-					s = test_bit(i, task->sw_newstate);
+					s = !!test_bit(i, task->sw_newstate);
 #endif
-					c = test_and_clear_bit(i,
+					c = !!test_and_clear_bit(i,
 							task->sw_togglestate);
 					spin_unlock_irq(&task->lock);
 
@@ -280,7 +280,7 @@ static void rfkill_schedule_toggle(enum rfkill_type type)
 	spin_unlock_irqrestore(&rfkill_task.lock, flags);
 }
 
-static void rfkill_schedule_evsw_rfkillall(int state)
+static void rfkill_schedule_evsw_rfkillall(bool state)
 {
 	if (state) {
 		switch (rfkill_master_switch_mode) {
@@ -332,7 +332,7 @@ static void rfkill_event(struct input_handle *handle, unsigned int type,
 	} else if (type == EV_SW) {
 		switch (code) {
 		case SW_RFKILL_ALL:
-			rfkill_schedule_evsw_rfkillall(data);
+			rfkill_schedule_evsw_rfkillall(!!data);
 			return;
 		default:
 			return;
@@ -381,7 +381,7 @@ static void rfkill_start(struct input_handle *handle)
 
 	if (test_bit(EV_SW, handle->dev->evbit)) {
 		if (test_bit(SW_RFKILL_ALL, handle->dev->swbit))
-			rfkill_schedule_evsw_rfkillall(test_bit(SW_RFKILL_ALL,
+			rfkill_schedule_evsw_rfkillall(!!test_bit(SW_RFKILL_ALL,
 							handle->dev->sw));
 		/* add resync for further EV_SW events here */
 	}
-- 
1.6.2.1

