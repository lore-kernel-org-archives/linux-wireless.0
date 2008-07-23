Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:38543 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753166AbYGWBES (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jul 2008 21:04:18 -0400
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: linux-wireless@vger.kernel.org
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Ivo van Doorn <IvDoorn@gmail.com>
Subject: [PATCH] rfkill: add EPO lock to rfkill-input
Date: Tue, 22 Jul 2008 22:04:04 -0300
Message-Id: <1216775046-9506-5-git-send-email-hmh@hmh.eng.br> (sfid-20080723_030423_132944_86A78382)
In-Reply-To: <1216775046-9506-1-git-send-email-hmh@hmh.eng.br>
References: <1216775046-9506-1-git-send-email-hmh@hmh.eng.br>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add software-based sanity to rfkill-input so that it can reproduce what
hardware-based EPO switches do, and lock down any further attempts to
UNBLOCK radios until the switch is deactivated.

This makes rfkill and rfkill-input extend the operation of an existing
wireless master kill switch that issues EV_SW SW_RFKILL_ALL OFF events to
all wireless devices in the system, even those that are not under hardware
or firmware control.

Since this is the expected operational behaviour for the master switch, the
EPO lock functionality is not optional.

Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Ivo van Doorn <IvDoorn@gmail.com>
---
 net/rfkill/rfkill-input.c |   46 +++++++++++++-------------------------------
 net/rfkill/rfkill-input.h |    1 +
 net/rfkill/rfkill.c       |   36 ++++++++++++++++++++++++++++++++--
 3 files changed, 48 insertions(+), 35 deletions(-)

diff --git a/net/rfkill/rfkill-input.c b/net/rfkill/rfkill-input.c
index 273fb38..8e6781d 100644
--- a/net/rfkill/rfkill-input.c
+++ b/net/rfkill/rfkill-input.c
@@ -47,6 +47,8 @@ struct rfkill_task {
 enum rfkill_global_sched_op {
 	RFKILL_GLOBAL_OP_EPO = 0,
 	RFKILL_GLOBAL_OP_RESTORE,
+	RFKILL_GLOBAL_OP_UNLOCK,
+	RFKILL_GLOBAL_OP_UNBLOCK,
 };
 
 struct rfkill_global_task {
@@ -62,6 +64,7 @@ static void rfkill_global_task_handler(struct work_struct *work)
 	struct rfkill_global_task *task =
 			container_of(work, struct rfkill_global_task, work);
 	enum rfkill_global_sched_op op;
+	unsigned int i;
 
 	mutex_lock(&task->mutex);
 
@@ -78,6 +81,14 @@ static void rfkill_global_task_handler(struct work_struct *work)
 		case RFKILL_GLOBAL_OP_RESTORE:
 			rfkill_restore_states();
 			break;
+		case RFKILL_GLOBAL_OP_UNLOCK:
+			rfkill_set_state_lock(0);
+			break;
+		case RFKILL_GLOBAL_OP_UNBLOCK:
+			rfkill_set_state_lock(0);
+			for (i = 0; i < RFKILL_TYPE_MAX; i++)
+				rfkill_switch_all(i, RFKILL_STATE_UNBLOCKED);
+			break;
 		default:
 			BUG();
 		}
@@ -117,25 +128,6 @@ static void rfkill_task_handler(struct work_struct *work)
 	mutex_unlock(&task->mutex);
 }
 
-static void rfkill_schedule_set(struct rfkill_task *task,
-				enum rfkill_state desired_state)
-{
-	unsigned long flags;
-
-	if (unlikely(work_pending(&rfkill_global_task.work)))
-		return;
-
-	spin_lock_irqsave(&task->lock, flags);
-
-	if (time_after(jiffies, task->last + msecs_to_jiffies(200))) {
-		task->desired_state = desired_state;
-		task->last = jiffies;
-		schedule_work(&task->work);
-	}
-
-	spin_unlock_irqrestore(&task->lock, flags);
-}
-
 static void rfkill_schedule_toggle(struct rfkill_task *task)
 {
 	unsigned long flags;
@@ -169,30 +161,19 @@ static DEFINE_RFKILL_TASK(rfkill_wlan, RFKILL_TYPE_WLAN);
 static DEFINE_RFKILL_TASK(rfkill_bt, RFKILL_TYPE_BLUETOOTH);
 static DEFINE_RFKILL_TASK(rfkill_uwb, RFKILL_TYPE_UWB);
 static DEFINE_RFKILL_TASK(rfkill_wimax, RFKILL_TYPE_WIMAX);
-static DEFINE_RFKILL_TASK(rfkill_wwan, RFKILL_TYPE_WWAN);
 
 static void rfkill_schedule_evsw_rfkillall(int state)
 {
-	/* EVERY radio type. state != 0 means radios ON */
-	/* handle EPO (emergency power off) through shortcut */
 	if (state) {
 		switch (rfkill_master_switch_mode) {
 		case RFKILL_INPUT_MASTER_UNBLOCKALL:
-			rfkill_schedule_set(&rfkill_wwan,
-					    RFKILL_STATE_UNBLOCKED);
-			rfkill_schedule_set(&rfkill_wimax,
-					    RFKILL_STATE_UNBLOCKED);
-			rfkill_schedule_set(&rfkill_uwb,
-					    RFKILL_STATE_UNBLOCKED);
-			rfkill_schedule_set(&rfkill_bt,
-					    RFKILL_STATE_UNBLOCKED);
-			rfkill_schedule_set(&rfkill_wlan,
-					    RFKILL_STATE_UNBLOCKED);
+			rfkill_schedule_global_op(RFKILL_GLOBAL_OP_UNBLOCK);
 			break;
 		case RFKILL_INPUT_MASTER_RESTORE:
 			rfkill_schedule_global_op(RFKILL_GLOBAL_OP_RESTORE);
 			break;
 		case RFKILL_INPUT_MASTER_DONOTHING:
+			rfkill_schedule_global_op(RFKILL_GLOBAL_OP_UNLOCK);
 			break;
 		default:
 			printk(KERN_ERR
@@ -347,6 +328,7 @@ static void __exit rfkill_handler_exit(void)
 {
 	input_unregister_handler(&rfkill_handler);
 	flush_scheduled_work();
+	rfkill_set_state_lock(0);
 }
 
 module_init(rfkill_handler_init);
diff --git a/net/rfkill/rfkill-input.h b/net/rfkill/rfkill-input.h
index bbfa646..6a8c8a2 100644
--- a/net/rfkill/rfkill-input.h
+++ b/net/rfkill/rfkill-input.h
@@ -14,5 +14,6 @@
 void rfkill_switch_all(enum rfkill_type type, enum rfkill_state state);
 void rfkill_epo(void);
 void rfkill_restore_states(void);
+void rfkill_set_state_lock(int lock);
 
 #endif /* __RFKILL_INPUT_H */
diff --git a/net/rfkill/rfkill.c b/net/rfkill/rfkill.c
index eaaabbd..2265bc5 100644
--- a/net/rfkill/rfkill.c
+++ b/net/rfkill/rfkill.c
@@ -47,6 +47,7 @@ MODULE_PARM_DESC(default_state,
 static enum rfkill_state rfkill_states[RFKILL_TYPE_MAX];
 static enum rfkill_state rfkill_default_states[RFKILL_TYPE_MAX];
 static unsigned long rfkill_states_lockdflt[BITS_TO_LONGS(RFKILL_TYPE_MAX)];
+static int rfkill_state_lock;
 
 static BLOCKING_NOTIFIER_HEAD(rfkill_notifier_list);
 
@@ -232,11 +233,15 @@ static void __rfkill_switch_all(const enum rfkill_type type,
  *
  * Acquires rfkill_mutex and calls __rfkill_switch_all(@type, @state).
  * Please refer to __rfkill_switch_all() for details.
+ *
+ * Does nothing if rfkill_set_state_lock() was used to lock state
+ * changes.
  */
 void rfkill_switch_all(enum rfkill_type type, enum rfkill_state state)
 {
 	mutex_lock(&rfkill_mutex);
-	__rfkill_switch_all(type, state);
+	if (!rfkill_state_lock)
+		__rfkill_switch_all(type, state);
 	mutex_unlock(&rfkill_mutex);
 }
 EXPORT_SYMBOL(rfkill_switch_all);
@@ -256,6 +261,8 @@ void rfkill_epo(void)
 	int i;
 
 	mutex_lock(&rfkill_mutex);
+
+	rfkill_state_lock = 1;
 	list_for_each_entry(rfkill, &rfkill_list, node) {
 		mutex_lock(&rfkill->mutex);
 		rfkill_toggle_radio(rfkill, RFKILL_STATE_SOFT_BLOCKED, 1);
@@ -281,6 +288,8 @@ void rfkill_restore_states(void)
 	int i;
 
 	mutex_lock(&rfkill_mutex);
+
+	rfkill_state_lock = 0;
 	for (i = 0; i < RFKILL_TYPE_MAX; i++)
 		__rfkill_switch_all(i, rfkill_default_states[i]);
 	mutex_unlock(&rfkill_mutex);
@@ -288,6 +297,22 @@ void rfkill_restore_states(void)
 EXPORT_SYMBOL_GPL(rfkill_restore_states);
 
 /**
+ * rfkill_set_state_lock - lock or unlock state changes
+ * @lock: 0 unlocks, non-zero locks state changes
+ *
+ * Used by rfkill-input to set initial state of rfkill_state_lock,
+ * based on the initial state of input devices, and to manually
+ * unlock when unloaded.
+ */
+void rfkill_set_state_lock(int lock)
+{
+	mutex_lock(&rfkill_mutex);
+	rfkill_state_lock = !!lock;
+	mutex_unlock(&rfkill_mutex);
+}
+EXPORT_SYMBOL_GPL(rfkill_set_state_lock);
+
+/**
  * rfkill_force_state - Force the internal rfkill radio state
  * @rfkill: pointer to the rfkill class to modify.
  * @state: the current radio state the class should be forced to.
@@ -391,7 +416,12 @@ static ssize_t rfkill_state_store(struct device *dev,
 
 	if (mutex_lock_interruptible(&rfkill->mutex))
 		return -ERESTARTSYS;
-	error = rfkill_toggle_radio(rfkill, state, 0);
+
+	if (!rfkill_state_lock)
+		error = rfkill_toggle_radio(rfkill, state, 0);
+	else
+		error = -EPERM;
+
 	mutex_unlock(&rfkill->mutex);
 
 	return error ? error : count;
@@ -429,7 +459,7 @@ static ssize_t rfkill_claim_store(struct device *dev,
 		return error;
 
 	if (rfkill->user_claim != claim) {
-		if (!claim) {
+		if (!claim && !rfkill_state_lock) {
 			mutex_lock(&rfkill->mutex);
 			rfkill_toggle_radio(rfkill,
 					    rfkill_states[rfkill->type],
-- 
1.5.6.2

