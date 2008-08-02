Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:41840 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754167AbYHBSLO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Aug 2008 14:11:14 -0400
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: linux-wireless@vger.kernel.org
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Michael Buesch <mb@bu3sch.de>
Subject: [PATCH 7/8] rfkill: rename rfkill_mutex to rfkill_global_mutex
Date: Sat,  2 Aug 2008 15:11:03 -0300
Message-Id: <1217700664-20792-8-git-send-email-hmh@hmh.eng.br> (sfid-20080802_201120_770579_2459B0AD)
In-Reply-To: <1217700664-20792-1-git-send-email-hmh@hmh.eng.br>
References: <1217700664-20792-1-git-send-email-hmh@hmh.eng.br>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rfkill_mutex and rfkill->mutex are too easy to confuse with each other.

Rename rfkill_mutex to rfkill_global_mutex, so that they are easier to tell
apart with just one glance.

Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
Cc: Michael Buesch <mb@bu3sch.de>
---
 net/rfkill/rfkill.c |   38 ++++++++++++++++++++------------------
 1 files changed, 20 insertions(+), 18 deletions(-)

diff --git a/net/rfkill/rfkill.c b/net/rfkill/rfkill.c
index 88368c4..22da6e8 100644
--- a/net/rfkill/rfkill.c
+++ b/net/rfkill/rfkill.c
@@ -37,7 +37,7 @@ MODULE_DESCRIPTION("RF switch support");
 MODULE_LICENSE("GPL");
 
 static LIST_HEAD(rfkill_list);	/* list of registered rf switches */
-static DEFINE_MUTEX(rfkill_mutex);
+static DEFINE_MUTEX(rfkill_global_mutex);
 
 static unsigned int rfkill_default_state = RFKILL_STATE_UNBLOCKED;
 module_param_named(default_state, rfkill_default_state, uint, 0444);
@@ -234,7 +234,7 @@ static int rfkill_toggle_radio(struct rfkill *rfkill,
  * unless a specific switch is claimed by userspace (in which case,
  * that switch is left alone) or suspended.
  *
- * Caller must have acquired rfkill_mutex.
+ * Caller must have acquired rfkill_global_mutex.
  */
 static void __rfkill_switch_all(const enum rfkill_type type,
 				const enum rfkill_state state)
@@ -263,14 +263,14 @@ static void __rfkill_switch_all(const enum rfkill_type type,
  * @type: type of interfaces to be affected
  * @state: the new state
  *
- * Acquires rfkill_mutex and calls __rfkill_switch_all(@type, @state).
+ * Acquires rfkill_global_mutex and calls __rfkill_switch_all(@type, @state).
  * Please refer to __rfkill_switch_all() for details.
  */
 void rfkill_switch_all(enum rfkill_type type, enum rfkill_state state)
 {
-	mutex_lock(&rfkill_mutex);
+	mutex_lock(&rfkill_global_mutex);
 	__rfkill_switch_all(type, state);
-	mutex_unlock(&rfkill_mutex);
+	mutex_unlock(&rfkill_global_mutex);
 }
 EXPORT_SYMBOL(rfkill_switch_all);
 
@@ -278,7 +278,7 @@ EXPORT_SYMBOL(rfkill_switch_all);
  * rfkill_epo - emergency power off all transmitters
  *
  * This kicks all non-suspended rfkill devices to RFKILL_STATE_SOFT_BLOCKED,
- * ignoring everything in its path but rfkill_mutex and rfkill->mutex.
+ * ignoring everything in its path but rfkill_global_mutex and rfkill->mutex.
  *
  * The global state before the EPO is saved and can be restored later
  * using rfkill_restore_states().
@@ -288,7 +288,8 @@ void rfkill_epo(void)
 	struct rfkill *rfkill;
 	int i;
 
-	mutex_lock(&rfkill_mutex);
+	mutex_lock(&rfkill_global_mutex);
+
 	list_for_each_entry(rfkill, &rfkill_list, node) {
 		mutex_lock(&rfkill->mutex);
 		rfkill_toggle_radio(rfkill, RFKILL_STATE_SOFT_BLOCKED, 1);
@@ -300,7 +301,7 @@ void rfkill_epo(void)
 		rfkill_global_states[i].current_state =
 				RFKILL_STATE_SOFT_BLOCKED;
 	}
-	mutex_unlock(&rfkill_mutex);
+	mutex_unlock(&rfkill_global_mutex);
 }
 EXPORT_SYMBOL_GPL(rfkill_epo);
 
@@ -315,10 +316,11 @@ void rfkill_restore_states(void)
 {
 	int i;
 
-	mutex_lock(&rfkill_mutex);
+	mutex_lock(&rfkill_global_mutex);
+
 	for (i = 0; i < RFKILL_TYPE_MAX; i++)
 		__rfkill_switch_all(i, rfkill_global_states[i].default_state);
-	mutex_unlock(&rfkill_mutex);
+	mutex_unlock(&rfkill_global_mutex);
 }
 EXPORT_SYMBOL_GPL(rfkill_restore_states);
 
@@ -470,7 +472,7 @@ static ssize_t rfkill_claim_store(struct device *dev,
 	 * Take the global lock to make sure the kernel is not in
 	 * the middle of rfkill_switch_all
 	 */
-	error = mutex_lock_interruptible(&rfkill_mutex);
+	error = mutex_lock_interruptible(&rfkill_global_mutex);
 	if (error)
 		return error;
 
@@ -485,7 +487,7 @@ static ssize_t rfkill_claim_store(struct device *dev,
 		rfkill->user_claim = !!claim;
 	}
 
-	mutex_unlock(&rfkill_mutex);
+	mutex_unlock(&rfkill_global_mutex);
 
 	return error ? error : count;
 }
@@ -622,7 +624,7 @@ static int rfkill_add_switch(struct rfkill *rfkill)
 {
 	int error;
 
-	mutex_lock(&rfkill_mutex);
+	mutex_lock(&rfkill_global_mutex);
 
 	error = rfkill_check_duplicity(rfkill);
 	if (error < 0)
@@ -643,16 +645,16 @@ static int rfkill_add_switch(struct rfkill *rfkill)
 
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
@@ -845,7 +847,7 @@ int rfkill_set_default(enum rfkill_type type, enum rfkill_state state)
 		return -EINVAL;
 	}
 
-	mutex_lock(&rfkill_mutex);
+	mutex_lock(&rfkill_global_mutex);
 
 	if (!test_and_set_bit(type, rfkill_states_lockdflt)) {
 		rfkill_global_states[type].default_state = state;
@@ -853,7 +855,7 @@ int rfkill_set_default(enum rfkill_type type, enum rfkill_state state)
 	} else
 		error = -EPERM;
 
-	mutex_unlock(&rfkill_mutex);
+	mutex_unlock(&rfkill_global_mutex);
 	return error;
 }
 EXPORT_SYMBOL_GPL(rfkill_set_default);
-- 
1.5.6.3

