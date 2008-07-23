Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:52870 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751856AbYGWBEU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jul 2008 21:04:20 -0400
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: linux-wireless@vger.kernel.org
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Ivo van Doorn <IvDoorn@gmail.com>,
	Michael Buesch <mb@bu3sch.de>
Subject: [PATCH] rfkill: rename rfkill_mutex to rfkill_global_mutex
Date: Tue, 22 Jul 2008 22:04:05 -0300
Message-Id: <1216775046-9506-6-git-send-email-hmh@hmh.eng.br> (sfid-20080723_030424_889093_57567AAB)
In-Reply-To: <1216775046-9506-1-git-send-email-hmh@hmh.eng.br>
References: <1216775046-9506-1-git-send-email-hmh@hmh.eng.br>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rfkill_mutex and rfkill->mutex are too easy to confuse with each other.

Rename rfkill_mutex to rfkill_global_mutex, so that they are easier to tell
apart with just one glance.

Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Ivo van Doorn <IvDoorn@gmail.com>
Cc: Michael Buesch <mb@bu3sch.de>
---
 net/rfkill/rfkill.c |   40 ++++++++++++++++++++--------------------
 1 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/net/rfkill/rfkill.c b/net/rfkill/rfkill.c
index 2265bc5..d6e16e1 100644
--- a/net/rfkill/rfkill.c
+++ b/net/rfkill/rfkill.c
@@ -37,7 +37,7 @@ MODULE_DESCRIPTION("RF switch support");
 MODULE_LICENSE("GPL");
 
 static LIST_HEAD(rfkill_list);	/* list of registered rf switches */
-static DEFINE_MUTEX(rfkill_mutex);
+static DEFINE_MUTEX(rfkill_global_mutex);
 
 static unsigned int rfkill_default_state = RFKILL_STATE_UNBLOCKED;
 module_param_named(default_state, rfkill_default_state, uint, 0444);
@@ -209,7 +209,7 @@ static int rfkill_toggle_radio(struct rfkill *rfkill,
  * unless a specific switch is claimed by userspace (in which case,
  * that switch is left alone).
  *
- * Caller must have acquired rfkill_mutex.
+ * Caller must have acquired rfkill_global_mutex.
  */
 static void __rfkill_switch_all(const enum rfkill_type type,
 				const enum rfkill_state state)
@@ -231,7 +231,7 @@ static void __rfkill_switch_all(const enum rfkill_type type,
  * @type: type of interfaces to be affected
  * @state: the new state
  *
- * Acquires rfkill_mutex and calls __rfkill_switch_all(@type, @state).
+ * Acquires rfkill_global_mutex and calls __rfkill_switch_all(@type, @state).
  * Please refer to __rfkill_switch_all() for details.
  *
  * Does nothing if rfkill_set_state_lock() was used to lock state
@@ -239,10 +239,10 @@ static void __rfkill_switch_all(const enum rfkill_type type,
  */
 void rfkill_switch_all(enum rfkill_type type, enum rfkill_state state)
 {
-	mutex_lock(&rfkill_mutex);
+	mutex_lock(&rfkill_global_mutex);
 	if (!rfkill_state_lock)
 		__rfkill_switch_all(type, state);
-	mutex_unlock(&rfkill_mutex);
+	mutex_unlock(&rfkill_global_mutex);
 }
 EXPORT_SYMBOL(rfkill_switch_all);
 
@@ -250,7 +250,7 @@ EXPORT_SYMBOL(rfkill_switch_all);
  * rfkill_epo - emergency power off all transmitters
  *
  * This kicks all rfkill devices to RFKILL_STATE_SOFT_BLOCKED, ignoring
- * everything in its path but rfkill_mutex and rfkill->mutex.
+ * everything in its path but rfkill_global_mutex and rfkill->mutex.
  *
  * The global state before the EPO is saved and can be restored later
  * using rfkill_restore_states().
@@ -260,7 +260,7 @@ void rfkill_epo(void)
 	struct rfkill *rfkill;
 	int i;
 
-	mutex_lock(&rfkill_mutex);
+	mutex_lock(&rfkill_global_mutex);
 
 	rfkill_state_lock = 1;
 	list_for_each_entry(rfkill, &rfkill_list, node) {
@@ -272,7 +272,7 @@ void rfkill_epo(void)
 		rfkill_default_states[i] = rfkill_states[i];
 		rfkill_states[i] = RFKILL_STATE_SOFT_BLOCKED;
 	}
-	mutex_unlock(&rfkill_mutex);
+	mutex_unlock(&rfkill_global_mutex);
 }
 EXPORT_SYMBOL_GPL(rfkill_epo);
 
@@ -287,12 +287,12 @@ void rfkill_restore_states(void)
 {
 	int i;
 
-	mutex_lock(&rfkill_mutex);
+	mutex_lock(&rfkill_global_mutex);
 
 	rfkill_state_lock = 0;
 	for (i = 0; i < RFKILL_TYPE_MAX; i++)
 		__rfkill_switch_all(i, rfkill_default_states[i]);
-	mutex_unlock(&rfkill_mutex);
+	mutex_unlock(&rfkill_global_mutex);
 }
 EXPORT_SYMBOL_GPL(rfkill_restore_states);
 
@@ -306,9 +306,9 @@ EXPORT_SYMBOL_GPL(rfkill_restore_states);
  */
 void rfkill_set_state_lock(int lock)
 {
-	mutex_lock(&rfkill_mutex);
+	mutex_lock(&rfkill_global_mutex);
 	rfkill_state_lock = !!lock;
-	mutex_unlock(&rfkill_mutex);
+	mutex_unlock(&rfkill_global_mutex);
 }
 EXPORT_SYMBOL_GPL(rfkill_set_state_lock);
 
@@ -454,7 +454,7 @@ static ssize_t rfkill_claim_store(struct device *dev,
 	 * Take the global lock to make sure the kernel is not in
 	 * the middle of rfkill_switch_all
 	 */
-	error = mutex_lock_interruptible(&rfkill_mutex);
+	error = mutex_lock_interruptible(&rfkill_global_mutex);
 	if (error)
 		return error;
 
@@ -469,7 +469,7 @@ static ssize_t rfkill_claim_store(struct device *dev,
 		rfkill->user_claim = claim;
 	}
 
-	mutex_unlock(&rfkill_mutex);
+	mutex_unlock(&rfkill_global_mutex);
 
 	return error ? error : count;
 }
@@ -601,7 +601,7 @@ static int rfkill_add_switch(struct rfkill *rfkill)
 {
 	int error;
 
-	mutex_lock(&rfkill_mutex);
+	mutex_lock(&rfkill_global_mutex);
 
 	error = rfkill_check_duplicity(rfkill);
 	if (error < 0)
@@ -620,16 +620,16 @@ static int rfkill_add_switch(struct rfkill *rfkill)
 
 	error = 0;
 unlock_out:
-	mutex_unlock(&rfkill_mutex);
+	mutex_unlock(&rfkill_global_mutex);
 
 	return error;
 }
 
 static void rfkill_remove_switch(struct rfkill *rfkill)
 {
-	mutex_lock(&rfkill_mutex);
+	mutex_lock(&rfkill_global_mutex);
 	list_del_init(&rfkill->node);
-	mutex_unlock(&rfkill_mutex);
+	mutex_unlock(&rfkill_global_mutex);
 
 	mutex_lock(&rfkill->mutex);
 	rfkill_toggle_radio(rfkill, RFKILL_STATE_SOFT_BLOCKED, 1);
@@ -797,7 +797,7 @@ int rfkill_set_default(enum rfkill_type type, enum rfkill_state state)
 	     state != RFKILL_STATE_UNBLOCKED))
 		return -EINVAL;
 
-	mutex_lock(&rfkill_mutex);
+	mutex_lock(&rfkill_global_mutex);
 
 	if (!test_and_set_bit(type, &rfkill_states_lockdflt)) {
 		rfkill_default_states[type] = state;
@@ -805,7 +805,7 @@ int rfkill_set_default(enum rfkill_type type, enum rfkill_state state)
 	} else
 		error = -EPERM;
 
-	mutex_unlock(&rfkill_mutex);
+	mutex_unlock(&rfkill_global_mutex);
 	return error;
 }
 EXPORT_SYMBOL_GPL(rfkill_set_default);
-- 
1.5.6.2

