Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:45574 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752351AbZC0NRS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Mar 2009 09:17:18 -0400
Subject: [PATCH] rfkill-input: remove unused code
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 27 Mar 2009 14:16:44 +0100
Message-Id: <1238159804.4452.4.camel@johannes.local> (sfid-20090327_141721_928490_D07305F3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There's a lot of rfkill-input code that cannot ever be
compiled and is useless until somebody needs and tests
it -- therefore remove it.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/rfkill/rfkill-input.c |   69 ----------------------------------------------
 1 file changed, 69 deletions(-)

--- wireless-testing.orig/net/rfkill/rfkill-input.c	2009-03-27 13:14:54.000000000 +0100
+++ wireless-testing/net/rfkill/rfkill-input.c	2009-03-27 13:15:29.000000000 +0100
@@ -47,12 +47,6 @@ enum rfkill_global_sched_op {
 	RFKILL_GLOBAL_OP_UNBLOCK,
 };
 
-/*
- * Currently, the code marked with RFKILL_NEED_SWSET is inactive.
- * If handling of EV_SW SW_WLAN/WWAN/BLUETOOTH/etc is needed in the
- * future, when such events are added, that code will be necessary.
- */
-
 struct rfkill_task {
 	struct delayed_work dwork;
 
@@ -65,14 +59,6 @@ struct rfkill_task {
 	/* pending regular switch operations (1=pending) */
 	unsigned long sw_pending[BITS_TO_LONGS(RFKILL_TYPE_MAX)];
 
-#ifdef RFKILL_NEED_SWSET
-	/* set operation pending (1=pending) */
-	unsigned long sw_setpending[BITS_TO_LONGS(RFKILL_TYPE_MAX)];
-
-	/* desired state for pending set operation (1=unblock) */
-	unsigned long sw_newstate[BITS_TO_LONGS(RFKILL_TYPE_MAX)];
-#endif
-
 	/* should the state be complemented (1=yes) */
 	unsigned long sw_togglestate[BITS_TO_LONGS(RFKILL_TYPE_MAX)];
 
@@ -111,24 +97,6 @@ static void __rfkill_handle_global_op(en
 	}
 }
 
-#ifdef RFKILL_NEED_SWSET
-static void __rfkill_handle_normal_op(const enum rfkill_type type,
-			const bool sp, const bool s, const bool c)
-{
-	enum rfkill_state state;
-
-	if (sp)
-		state = (s) ? RFKILL_STATE_UNBLOCKED :
-			      RFKILL_STATE_SOFT_BLOCKED;
-	else
-		state = rfkill_get_global_state(type);
-
-	if (c)
-		state = rfkill_state_complement(state);
-
-	rfkill_switch_all(type, state);
-}
-#else
 static void __rfkill_handle_normal_op(const enum rfkill_type type,
 			const bool c)
 {
@@ -140,7 +108,6 @@ static void __rfkill_handle_normal_op(co
 
 	rfkill_switch_all(type, state);
 }
-#endif
 
 static void rfkill_task_handler(struct work_struct *work)
 {
@@ -171,21 +138,11 @@ static void rfkill_task_handler(struct w
 						i < RFKILL_TYPE_MAX) {
 				if (test_and_clear_bit(i, task->sw_pending)) {
 					bool c;
-#ifdef RFKILL_NEED_SWSET
-					bool sp, s;
-					sp = test_and_clear_bit(i,
-							task->sw_setpending);
-					s = test_bit(i, task->sw_newstate);
-#endif
 					c = test_and_clear_bit(i,
 							task->sw_togglestate);
 					spin_unlock_irq(&task->lock);
 
-#ifdef RFKILL_NEED_SWSET
-					__rfkill_handle_normal_op(i, sp, s, c);
-#else
 					__rfkill_handle_normal_op(i, c);
-#endif
 
 					spin_lock_irq(&task->lock);
 				}
@@ -238,32 +195,6 @@ static void rfkill_schedule_global_op(en
 	spin_unlock_irqrestore(&rfkill_task.lock, flags);
 }
 
-#ifdef RFKILL_NEED_SWSET
-/* Use this if you need to add EV_SW SW_WLAN/WWAN/BLUETOOTH/etc handling */
-
-static void rfkill_schedule_set(enum rfkill_type type,
-				enum rfkill_state desired_state)
-{
-	unsigned long flags;
-
-	if (rfkill_is_epo_lock_active())
-		return;
-
-	spin_lock_irqsave(&rfkill_task.lock, flags);
-	if (!rfkill_task.global_op_pending) {
-		set_bit(type, rfkill_task.sw_pending);
-		set_bit(type, rfkill_task.sw_setpending);
-		clear_bit(type, rfkill_task.sw_togglestate);
-		if (desired_state)
-			set_bit(type,  rfkill_task.sw_newstate);
-		else
-			clear_bit(type, rfkill_task.sw_newstate);
-		rfkill_schedule_ratelimited();
-	}
-	spin_unlock_irqrestore(&rfkill_task.lock, flags);
-}
-#endif
-
 static void rfkill_schedule_toggle(enum rfkill_type type)
 {
 	unsigned long flags;


