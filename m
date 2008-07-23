Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:36995 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753082AbYGWBET (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jul 2008 21:04:19 -0400
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: linux-wireless@vger.kernel.org
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Ivo van Doorn <IvDoorn@gmail.com>,
	Dmitry Torokhov <dtor@mail.ru>
Subject: [PATCH] rfkill: rate-limit rfkill-input workqueue usage
Date: Tue, 22 Jul 2008 22:04:06 -0300
Message-Id: <1216775046-9506-7-git-send-email-hmh@hmh.eng.br> (sfid-20080723_030423_859491_C6E1A0D0)
In-Reply-To: <1216775046-9506-1-git-send-email-hmh@hmh.eng.br>
References: <1216775046-9506-1-git-send-email-hmh@hmh.eng.br>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Limit the number of rfkill-input global operations per second.  It lacked
the limiter that non-global operations (state changes) had.  This way, a
rogue input event generator cannot force rfkill-input to hog the workqueue
too much.

Rework the limiter code so that newer state change requests (rfkill input
events) will override older ones that haven't been acted upon yet.  It used
to ignore new ones that were past the rate limit.

The hardcoded limit is to process requests only once every 200ms.  Limits
are separate for each switch type and for the global operations (used by
the master switch).

Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Ivo van Doorn <IvDoorn@gmail.com>
Cc: Dmitry Torokhov <dtor@mail.ru>
---
 net/rfkill/rfkill-input.c |   43 ++++++++++++++++++++++++++++---------------
 1 files changed, 28 insertions(+), 15 deletions(-)

diff --git a/net/rfkill/rfkill-input.c b/net/rfkill/rfkill-input.c
index 8e6781d..be3edda 100644
--- a/net/rfkill/rfkill-input.c
+++ b/net/rfkill/rfkill-input.c
@@ -23,6 +23,9 @@ MODULE_AUTHOR("Dmitry Torokhov <dtor@mail.ru>");
 MODULE_DESCRIPTION("Input layer to RF switch connector");
 MODULE_LICENSE("GPL");
 
+/* Delay (in ms) between consecutive switch ops */
+#define	RFKILL_OPS_DELAY 200UL
+
 enum rfkill_input_master_mode {
 	RFKILL_INPUT_MASTER_DONOTHING = 0,
 	RFKILL_INPUT_MASTER_RESTORE = 1,
@@ -36,7 +39,7 @@ MODULE_PARM_DESC(master_switch_mode,
 	"SW_RFKILL_ALL ON should: 0=do nothing; 1=restore; 2=unblock all");
 
 struct rfkill_task {
-	struct work_struct work;
+	struct delayed_work dwork;
 	enum rfkill_type type;
 	struct mutex mutex; /* ensures that task is serialized */
 	spinlock_t lock; /* for accessing last and desired state */
@@ -52,17 +55,18 @@ enum rfkill_global_sched_op {
 };
 
 struct rfkill_global_task {
-	struct work_struct work;
+	struct delayed_work dwork;
 	struct mutex mutex; /* ensures that task is serialized */
 	spinlock_t lock;
+	unsigned long last; /* last schedule */
 	enum rfkill_global_sched_op op;
 	int op_count; /* avoid race window */
 };
 
 static void rfkill_global_task_handler(struct work_struct *work)
 {
-	struct rfkill_global_task *task =
-			container_of(work, struct rfkill_global_task, work);
+	struct rfkill_global_task *task = container_of(work,
+			struct rfkill_global_task, dwork.work);
 	enum rfkill_global_sched_op op;
 	unsigned int i;
 
@@ -100,12 +104,18 @@ static void rfkill_global_task_handler(struct work_struct *work)
 }
 
 static struct rfkill_global_task rfkill_global_task = {
-	.work = __WORK_INITIALIZER(rfkill_global_task.work,
+	.dwork = __DELAYED_WORK_INITIALIZER(rfkill_global_task.dwork,
 				rfkill_global_task_handler),
 	.mutex =  __MUTEX_INITIALIZER(rfkill_global_task.mutex),
 	.lock = __SPIN_LOCK_UNLOCKED(rfkill_global_task.lock),
 };
 
+static unsigned long rfkill_ratelimit(const unsigned long last)
+{
+	const unsigned long delay = msecs_to_jiffies(RFKILL_OPS_DELAY);
+	return (time_after(jiffies, last + delay)) ? 0 : delay;
+};
+
 static void rfkill_schedule_global_op(enum rfkill_global_sched_op op)
 {
 	unsigned long flags;
@@ -113,13 +123,18 @@ static void rfkill_schedule_global_op(enum rfkill_global_sched_op op)
 	spin_lock_irqsave(&rfkill_global_task.lock, flags);
 	rfkill_global_task.op = op;
 	rfkill_global_task.op_count = 1;
-	schedule_work(&rfkill_global_task.work);
+	if (likely(!delayed_work_pending(&rfkill_global_task.dwork))) {
+		schedule_delayed_work(&rfkill_global_task.dwork,
+				rfkill_ratelimit(rfkill_global_task.last));
+		rfkill_global_task.last = jiffies;
+	}
 	spin_unlock_irqrestore(&rfkill_global_task.lock, flags);
 }
 
 static void rfkill_task_handler(struct work_struct *work)
 {
-	struct rfkill_task *task = container_of(work, struct rfkill_task, work);
+	struct rfkill_task *task = container_of(work,
+					struct rfkill_task, dwork.work);
 
 	mutex_lock(&task->mutex);
 
@@ -132,24 +147,22 @@ static void rfkill_schedule_toggle(struct rfkill_task *task)
 {
 	unsigned long flags;
 
-	if (unlikely(work_pending(&rfkill_global_task.work)))
+	if (unlikely(delayed_work_pending(&rfkill_global_task.dwork)))
 		return;
 
 	spin_lock_irqsave(&task->lock, flags);
-
-	if (time_after(jiffies, task->last + msecs_to_jiffies(200))) {
-		task->desired_state =
-				rfkill_state_complement(task->desired_state);
+	task->desired_state = rfkill_state_complement(task->desired_state);
+	if (likely(!delayed_work_pending(&task->dwork))) {
+		schedule_delayed_work(&task->dwork,
+					rfkill_ratelimit(task->last));
 		task->last = jiffies;
-		schedule_work(&task->work);
 	}
-
 	spin_unlock_irqrestore(&task->lock, flags);
 }
 
 #define DEFINE_RFKILL_TASK(n, t)				\
 	struct rfkill_task n = {				\
-		.work = __WORK_INITIALIZER(n.work,		\
+		.dwork = __DELAYED_WORK_INITIALIZER(n.dwork,	\
 				rfkill_task_handler),		\
 		.type = t,					\
 		.mutex = __MUTEX_INITIALIZER(n.mutex),		\
-- 
1.5.6.2

