Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:55087 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750951AbYGWBEQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jul 2008 21:04:16 -0400
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: linux-wireless@vger.kernel.org
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Ivo van Doorn <IvDoorn@gmail.com>
Subject: [PATCH] rfkill: add default global states
Date: Tue, 22 Jul 2008 22:04:02 -0300
Message-Id: <1216775046-9506-3-git-send-email-hmh@hmh.eng.br> (sfid-20080723_030421_163257_BB2FCE6D)
In-Reply-To: <1216775046-9506-1-git-send-email-hmh@hmh.eng.br>
References: <1216775046-9506-1-git-send-email-hmh@hmh.eng.br>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add a second set of global states, "rfkill_default_states", to track the
state that will be used when the first rfkill class of a given type is
registered, and also to save "undo" information when rfkill_epo is called.

Add a new exported function, rfkill_set_default(), which can be used by
platform drivers to restore radio state saved by the platform across
reboots or shutdown.

Also, fix rfkill_epo to properly update rfkill_states, but still preserve a
copy of the state so that we can undo the effect of rfkill_epo later if we
want to.  Add rfkill_restore_states() to restore rfkill_states from the
copy.

Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Ivo van Doorn <IvDoorn@gmail.com>
---
 include/linux/rfkill.h    |    1 +
 net/rfkill/rfkill-input.h |    1 +
 net/rfkill/rfkill.c       |  105 ++++++++++++++++++++++++++++++++++++++++++---
 3 files changed, 100 insertions(+), 7 deletions(-)

diff --git a/include/linux/rfkill.h b/include/linux/rfkill.h
index 741d1a6..aa3c7d5 100644
--- a/include/linux/rfkill.h
+++ b/include/linux/rfkill.h
@@ -116,6 +116,7 @@ int rfkill_register(struct rfkill *rfkill);
 void rfkill_unregister(struct rfkill *rfkill);
 
 int rfkill_force_state(struct rfkill *rfkill, enum rfkill_state state);
+int rfkill_set_default(enum rfkill_type type, enum rfkill_state state);
 
 /**
  * rfkill_state_complement - return complementar state
diff --git a/net/rfkill/rfkill-input.h b/net/rfkill/rfkill-input.h
index f63d050..bbfa646 100644
--- a/net/rfkill/rfkill-input.h
+++ b/net/rfkill/rfkill-input.h
@@ -13,5 +13,6 @@
 
 void rfkill_switch_all(enum rfkill_type type, enum rfkill_state state);
 void rfkill_epo(void);
+void rfkill_restore_states(void);
 
 #endif /* __RFKILL_INPUT_H */
diff --git a/net/rfkill/rfkill.c b/net/rfkill/rfkill.c
index 0a78e32..eaaabbd 100644
--- a/net/rfkill/rfkill.c
+++ b/net/rfkill/rfkill.c
@@ -45,6 +45,8 @@ MODULE_PARM_DESC(default_state,
 		 "Default initial state for all radio types, 0 = radio off");
 
 static enum rfkill_state rfkill_states[RFKILL_TYPE_MAX];
+static enum rfkill_state rfkill_default_states[RFKILL_TYPE_MAX];
+static unsigned long rfkill_states_lockdflt[BITS_TO_LONGS(RFKILL_TYPE_MAX)];
 
 static BLOCKING_NOTIFIER_HEAD(rfkill_notifier_list);
 
@@ -198,22 +200,22 @@ static int rfkill_toggle_radio(struct rfkill *rfkill,
 }
 
 /**
- * rfkill_switch_all - Toggle state of all switches of given type
+ * __rfkill_switch_all - Toggle state of all switches of given type
  * @type: type of interfaces to be affected
  * @state: the new state
  *
  * This function toggles the state of all switches of given type,
  * unless a specific switch is claimed by userspace (in which case,
  * that switch is left alone).
+ *
+ * Caller must have acquired rfkill_mutex.
  */
-void rfkill_switch_all(enum rfkill_type type, enum rfkill_state state)
+static void __rfkill_switch_all(const enum rfkill_type type,
+				const enum rfkill_state state)
 {
 	struct rfkill *rfkill;
 
-	mutex_lock(&rfkill_mutex);
-
 	rfkill_states[type] = state;
-
 	list_for_each_entry(rfkill, &rfkill_list, node) {
 		if ((!rfkill->user_claim) && (rfkill->type == type)) {
 			mutex_lock(&rfkill->mutex);
@@ -221,7 +223,20 @@ void rfkill_switch_all(enum rfkill_type type, enum rfkill_state state)
 			mutex_unlock(&rfkill->mutex);
 		}
 	}
+}
 
+/**
+ * rfkill_switch_all - Toggle state of all switches of given type
+ * @type: type of interfaces to be affected
+ * @state: the new state
+ *
+ * Acquires rfkill_mutex and calls __rfkill_switch_all(@type, @state).
+ * Please refer to __rfkill_switch_all() for details.
+ */
+void rfkill_switch_all(enum rfkill_type type, enum rfkill_state state)
+{
+	mutex_lock(&rfkill_mutex);
+	__rfkill_switch_all(type, state);
 	mutex_unlock(&rfkill_mutex);
 }
 EXPORT_SYMBOL(rfkill_switch_all);
@@ -231,10 +246,14 @@ EXPORT_SYMBOL(rfkill_switch_all);
  *
  * This kicks all rfkill devices to RFKILL_STATE_SOFT_BLOCKED, ignoring
  * everything in its path but rfkill_mutex and rfkill->mutex.
+ *
+ * The global state before the EPO is saved and can be restored later
+ * using rfkill_restore_states().
  */
 void rfkill_epo(void)
 {
 	struct rfkill *rfkill;
+	int i;
 
 	mutex_lock(&rfkill_mutex);
 	list_for_each_entry(rfkill, &rfkill_list, node) {
@@ -242,11 +261,33 @@ void rfkill_epo(void)
 		rfkill_toggle_radio(rfkill, RFKILL_STATE_SOFT_BLOCKED, 1);
 		mutex_unlock(&rfkill->mutex);
 	}
+	for (i = 0; i < RFKILL_TYPE_MAX; i++) {
+		rfkill_default_states[i] = rfkill_states[i];
+		rfkill_states[i] = RFKILL_STATE_SOFT_BLOCKED;
+	}
 	mutex_unlock(&rfkill_mutex);
 }
 EXPORT_SYMBOL_GPL(rfkill_epo);
 
 /**
+ * rfkill_restore_states - restore global states
+ *
+ * Restore (and sync switches to) the global state from the
+ * states in rfkill_default_states.  This can undo the effects of
+ * a call to rfkill_epo().
+ */
+void rfkill_restore_states(void)
+{
+	int i;
+
+	mutex_lock(&rfkill_mutex);
+	for (i = 0; i < RFKILL_TYPE_MAX; i++)
+		__rfkill_switch_all(i, rfkill_default_states[i]);
+	mutex_unlock(&rfkill_mutex);
+}
+EXPORT_SYMBOL_GPL(rfkill_restore_states);
+
+/**
  * rfkill_force_state - Force the internal rfkill radio state
  * @rfkill: pointer to the rfkill class to modify.
  * @state: the current radio state the class should be forced to.
@@ -536,6 +577,13 @@ static int rfkill_add_switch(struct rfkill *rfkill)
 	if (error < 0)
 		goto unlock_out;
 
+	if (!error) {
+		/* lock default after first use */
+		set_bit(rfkill->type, &rfkill_states_lockdflt);
+		rfkill_states[rfkill->type] =
+				rfkill_default_states[rfkill->type];
+	}
+
 	rfkill_toggle_radio(rfkill, rfkill_states[rfkill->type], 0);
 
 	list_add_tail(&rfkill->node, &rfkill_list);
@@ -689,6 +737,49 @@ void rfkill_unregister(struct rfkill *rfkill)
 }
 EXPORT_SYMBOL(rfkill_unregister);
 
+/**
+ * rfkill_set_default - set initial value for a switch type
+ * @type - the type of switch to set the default state of
+ * @state - the new default state for that group of switches
+ *
+ * Sets the initial state rfkill should use for a given type.  Only "soft"
+ * states are allowed, i.e. RFKILL_STATE_SOFT_BLOCKED and
+ * RFKILL_STATE_UNBLOCKED.
+ *
+ * This function is meant to be used by platform drivers for platforms that
+ * can save switch state across power down/reboot.
+ *
+ * The default state for each switch type can be changed exactly once.
+ * After a switch of that type is registered, the default state cannot be
+ * changed anymore.
+ *
+ * Returns -EPERM if the state has already been set once or is in use,
+ * so drivers likely want to ignore -EPERM returns from this function.
+ *
+ * Returns 0 if the state was set, or another error if it was not set.
+ */
+int rfkill_set_default(enum rfkill_type type, enum rfkill_state state)
+{
+	int error;
+
+	if (type >= RFKILL_TYPE_MAX ||
+	    (state != RFKILL_STATE_SOFT_BLOCKED &&
+	     state != RFKILL_STATE_UNBLOCKED))
+		return -EINVAL;
+
+	mutex_lock(&rfkill_mutex);
+
+	if (!test_and_set_bit(type, &rfkill_states_lockdflt)) {
+		rfkill_default_states[type] = state;
+		error = 0;
+	} else
+		error = -EPERM;
+
+	mutex_unlock(&rfkill_mutex);
+	return error;
+}
+EXPORT_SYMBOL_GPL(rfkill_set_default);
+
 /*
  * Rfkill module initialization/deinitialization.
  */
@@ -702,8 +793,8 @@ static int __init rfkill_init(void)
 	    rfkill_default_state != RFKILL_STATE_UNBLOCKED)
 		return -EINVAL;
 
-	for (i = 0; i < ARRAY_SIZE(rfkill_states); i++)
-		rfkill_states[i] = rfkill_default_state;
+	for (i = 0; i < ARRAY_SIZE(rfkill_default_states); i++)
+		rfkill_default_states[i] = rfkill_default_state;
 
 	error = class_register(&rfkill_class);
 	if (error) {
-- 
1.5.6.2

