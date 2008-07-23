Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:52874 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752994AbYGWBER (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jul 2008 21:04:17 -0400
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: linux-wireless@vger.kernel.org
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Ivo van Doorn <IvDoorn@gmail.com>
Subject: [PATCH] rfkill: add master_switch_mode functionality
Date: Tue, 22 Jul 2008 22:04:03 -0300
Message-Id: <1216775046-9506-4-git-send-email-hmh@hmh.eng.br> (sfid-20080723_030421_764577_852E65A6)
In-Reply-To: <1216775046-9506-1-git-send-email-hmh@hmh.eng.br>
References: <1216775046-9506-1-git-send-email-hmh@hmh.eng.br>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Let the user configure what rfkill-input should do upon EV_SW SW_RFKILL_ALL
ON.

The mode of operation can be set through the master_switch_mode parameter.
master_switch_mode 0 does nothing.  1 tries to restore the state before the
last EV_SW SW_RFKILL_ALL OFF, or the default states of the switches if no
EV_SW SW_RFKILL_ALL OFF ever happened.  2 tries to unblock all switches
(default).

Note that the default mode of operation is unchanged.

Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Ivo van Doorn <IvDoorn@gmail.com>
---
 net/rfkill/rfkill-input.c |  129 +++++++++++++++++++++++++++++++++++++--------
 1 files changed, 107 insertions(+), 22 deletions(-)

diff --git a/net/rfkill/rfkill-input.c b/net/rfkill/rfkill-input.c
index 827f178..273fb38 100644
--- a/net/rfkill/rfkill-input.c
+++ b/net/rfkill/rfkill-input.c
@@ -23,6 +23,18 @@ MODULE_AUTHOR("Dmitry Torokhov <dtor@mail.ru>");
 MODULE_DESCRIPTION("Input layer to RF switch connector");
 MODULE_LICENSE("GPL");
 
+enum rfkill_input_master_mode {
+	RFKILL_INPUT_MASTER_DONOTHING = 0,
+	RFKILL_INPUT_MASTER_RESTORE = 1,
+	RFKILL_INPUT_MASTER_UNBLOCKALL = 2,
+};
+
+static enum rfkill_input_master_mode rfkill_master_switch_mode =
+					RFKILL_INPUT_MASTER_UNBLOCKALL;
+module_param_named(master_switch_mode, rfkill_master_switch_mode, uint, 0);
+MODULE_PARM_DESC(master_switch_mode,
+	"SW_RFKILL_ALL ON should: 0=do nothing; 1=restore; 2=unblock all");
+
 struct rfkill_task {
 	struct work_struct work;
 	enum rfkill_type type;
@@ -32,27 +44,77 @@ struct rfkill_task {
 	enum rfkill_state desired_state; /* on/off */
 };
 
-static void rfkill_task_handler(struct work_struct *work)
+enum rfkill_global_sched_op {
+	RFKILL_GLOBAL_OP_EPO = 0,
+	RFKILL_GLOBAL_OP_RESTORE,
+};
+
+struct rfkill_global_task {
+	struct work_struct work;
+	struct mutex mutex; /* ensures that task is serialized */
+	spinlock_t lock;
+	enum rfkill_global_sched_op op;
+	int op_count; /* avoid race window */
+};
+
+static void rfkill_global_task_handler(struct work_struct *work)
 {
-	struct rfkill_task *task = container_of(work, struct rfkill_task, work);
+	struct rfkill_global_task *task =
+			container_of(work, struct rfkill_global_task, work);
+	enum rfkill_global_sched_op op;
 
 	mutex_lock(&task->mutex);
 
-	rfkill_switch_all(task->type, task->desired_state);
+	spin_lock_irq(&task->lock);
+	if (task->op_count) {
+		op = task->op;
+		task->op_count = 0;
+		spin_unlock_irq(&task->lock);
+
+		switch (op) {
+		case RFKILL_GLOBAL_OP_EPO:
+			rfkill_epo();
+			break;
+		case RFKILL_GLOBAL_OP_RESTORE:
+			rfkill_restore_states();
+			break;
+		default:
+			BUG();
+		}
+	} else
+		/* got scheduled on race window, nothing to do */
+		spin_unlock_irq(&task->lock);
 
 	mutex_unlock(&task->mutex);
 }
 
-static void rfkill_task_epo_handler(struct work_struct *work)
+static struct rfkill_global_task rfkill_global_task = {
+	.work = __WORK_INITIALIZER(rfkill_global_task.work,
+				rfkill_global_task_handler),
+	.mutex =  __MUTEX_INITIALIZER(rfkill_global_task.mutex),
+	.lock = __SPIN_LOCK_UNLOCKED(rfkill_global_task.lock),
+};
+
+static void rfkill_schedule_global_op(enum rfkill_global_sched_op op)
 {
-	rfkill_epo();
-}
+	unsigned long flags;
 
-static DECLARE_WORK(epo_work, rfkill_task_epo_handler);
+	spin_lock_irqsave(&rfkill_global_task.lock, flags);
+	rfkill_global_task.op = op;
+	rfkill_global_task.op_count = 1;
+	schedule_work(&rfkill_global_task.work);
+	spin_unlock_irqrestore(&rfkill_global_task.lock, flags);
+}
 
-static void rfkill_schedule_epo(void)
+static void rfkill_task_handler(struct work_struct *work)
 {
-	schedule_work(&epo_work);
+	struct rfkill_task *task = container_of(work, struct rfkill_task, work);
+
+	mutex_lock(&task->mutex);
+
+	rfkill_switch_all(task->type, task->desired_state);
+
+	mutex_unlock(&task->mutex);
 }
 
 static void rfkill_schedule_set(struct rfkill_task *task,
@@ -60,7 +122,7 @@ static void rfkill_schedule_set(struct rfkill_task *task,
 {
 	unsigned long flags;
 
-	if (unlikely(work_pending(&epo_work)))
+	if (unlikely(work_pending(&rfkill_global_task.work)))
 		return;
 
 	spin_lock_irqsave(&task->lock, flags);
@@ -78,7 +140,7 @@ static void rfkill_schedule_toggle(struct rfkill_task *task)
 {
 	unsigned long flags;
 
-	if (unlikely(work_pending(&epo_work)))
+	if (unlikely(work_pending(&rfkill_global_task.work)))
 		return;
 
 	spin_lock_irqsave(&task->lock, flags);
@@ -114,18 +176,33 @@ static void rfkill_schedule_evsw_rfkillall(int state)
 	/* EVERY radio type. state != 0 means radios ON */
 	/* handle EPO (emergency power off) through shortcut */
 	if (state) {
-		rfkill_schedule_set(&rfkill_wwan,
-				    RFKILL_STATE_UNBLOCKED);
-		rfkill_schedule_set(&rfkill_wimax,
-				    RFKILL_STATE_UNBLOCKED);
-		rfkill_schedule_set(&rfkill_uwb,
-				    RFKILL_STATE_UNBLOCKED);
-		rfkill_schedule_set(&rfkill_bt,
-				    RFKILL_STATE_UNBLOCKED);
-		rfkill_schedule_set(&rfkill_wlan,
-				    RFKILL_STATE_UNBLOCKED);
+		switch (rfkill_master_switch_mode) {
+		case RFKILL_INPUT_MASTER_UNBLOCKALL:
+			rfkill_schedule_set(&rfkill_wwan,
+					    RFKILL_STATE_UNBLOCKED);
+			rfkill_schedule_set(&rfkill_wimax,
+					    RFKILL_STATE_UNBLOCKED);
+			rfkill_schedule_set(&rfkill_uwb,
+					    RFKILL_STATE_UNBLOCKED);
+			rfkill_schedule_set(&rfkill_bt,
+					    RFKILL_STATE_UNBLOCKED);
+			rfkill_schedule_set(&rfkill_wlan,
+					    RFKILL_STATE_UNBLOCKED);
+			break;
+		case RFKILL_INPUT_MASTER_RESTORE:
+			rfkill_schedule_global_op(RFKILL_GLOBAL_OP_RESTORE);
+			break;
+		case RFKILL_INPUT_MASTER_DONOTHING:
+			break;
+		default:
+			printk(KERN_ERR
+				"rfkill-input: Illegal value for "
+				"master_switch_mode parameter: %d\n",
+				rfkill_master_switch_mode);
+			break;
+		}
 	} else
-		rfkill_schedule_epo();
+		rfkill_schedule_global_op(RFKILL_GLOBAL_OP_EPO);
 }
 
 static void rfkill_event(struct input_handle *handle, unsigned int type,
@@ -255,6 +332,14 @@ static struct input_handler rfkill_handler = {
 
 static int __init rfkill_handler_init(void)
 {
+	switch (rfkill_master_switch_mode) {
+	case RFKILL_INPUT_MASTER_DONOTHING:
+	case RFKILL_INPUT_MASTER_RESTORE:
+	case RFKILL_INPUT_MASTER_UNBLOCKALL:
+		break;
+	default:
+		return -EINVAL;
+	}
 	return input_register_handler(&rfkill_handler);
 }
 
-- 
1.5.6.2

