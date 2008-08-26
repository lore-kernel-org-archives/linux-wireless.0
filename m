Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:52753 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754775AbYHZO6H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Aug 2008 10:58:07 -0400
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Ivo van Doorn <IvDoorn@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH 3/5] rfkill: add WARN and BUG_ON paranoia (v2)
Date: Tue, 26 Aug 2008 11:57:59 -0300
Message-Id: <1219762681-26911-4-git-send-email-hmh@hmh.eng.br> (sfid-20080826_165817_782383_F6BC4D3F)
In-Reply-To: <1219762681-26911-1-git-send-email-hmh@hmh.eng.br>
References: <1219762681-26911-1-git-send-email-hmh@hmh.eng.br>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

BUG_ON() and WARN() the heck out of buggy drivers calling into the rfkill
subsystem.

Also switch from WARN_ON(1) to the new descriptive WARN().

Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Ivo van Doorn <IvDoorn@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
---
 net/rfkill/rfkill.c |   50 +++++++++++++++++++++++++++++++++++++-------------
 1 files changed, 37 insertions(+), 13 deletions(-)

diff --git a/net/rfkill/rfkill.c b/net/rfkill/rfkill.c
index b630f35..910699c 100644
--- a/net/rfkill/rfkill.c
+++ b/net/rfkill/rfkill.c
@@ -76,6 +76,7 @@ static BLOCKING_NOTIFIER_HEAD(rfkill_notifier_list);
  */
 int register_rfkill_notifier(struct notifier_block *nb)
 {
+	BUG_ON(!nb);
 	return blocking_notifier_chain_register(&rfkill_notifier_list, nb);
 }
 EXPORT_SYMBOL_GPL(register_rfkill_notifier);
@@ -91,6 +92,7 @@ EXPORT_SYMBOL_GPL(register_rfkill_notifier);
  */
 int unregister_rfkill_notifier(struct notifier_block *nb)
 {
+	BUG_ON(!nb);
 	return blocking_notifier_chain_unregister(&rfkill_notifier_list, nb);
 }
 EXPORT_SYMBOL_GPL(unregister_rfkill_notifier);
@@ -202,6 +204,9 @@ static int rfkill_toggle_radio(struct rfkill *rfkill,
 		 * RFKILL_STATE_HARD_BLOCKED */
 		break;
 	default:
+		WARN(1, KERN_WARNING
+			"rfkill: illegal state %d passed as parameter "
+			"to rfkill_toggle_radio\n", state);
 		return -EINVAL;
 	}
 
@@ -236,7 +241,11 @@ static void __rfkill_switch_all(const enum rfkill_type type,
 {
 	struct rfkill *rfkill;
 
-	if (unlikely(state >= RFKILL_STATE_MAX))
+	if (WARN((state >= RFKILL_STATE_MAX || type >= RFKILL_TYPE_MAX),
+			KERN_WARNING
+			"rfkill: illegal state %d or type %d "
+			"passed as parameter to __rfkill_switch_all\n",
+			state, type))
 		return;
 
 	rfkill_global_states[type].current_state = state;
@@ -334,7 +343,11 @@ int rfkill_force_state(struct rfkill *rfkill, enum rfkill_state state)
 {
 	enum rfkill_state oldstate;
 
-	if (unlikely(state >= RFKILL_STATE_MAX))
+	BUG_ON(!rfkill);
+	if (WARN((state >= RFKILL_STATE_MAX),
+			KERN_WARNING
+			"rfkill: illegal state %d passed as parameter "
+			"to rfkill_force_state\n", state))
 		return -EINVAL;
 
 	mutex_lock(&rfkill->mutex);
@@ -593,10 +606,10 @@ static int rfkill_check_duplicity(const struct rfkill *rfkill)
 	memset(seen, 0, sizeof(seen));
 
 	list_for_each_entry(p, &rfkill_list, node) {
-		if (p == rfkill) {
-			WARN_ON(1);
+		if (WARN((p == rfkill), KERN_WARNING
+				"rfkill: illegal attempt to register "
+				"an already registered rfkill struct\n"))
 			return -EEXIST;
-		}
 		set_bit(p->type, seen);
 	}
 
@@ -664,6 +677,12 @@ struct rfkill * __must_check rfkill_allocate(struct device *parent,
 	struct rfkill *rfkill;
 	struct device *dev;
 
+	if (WARN((type >= RFKILL_TYPE_MAX),
+			KERN_WARNING
+			"rfkill: illegal type %d passed as parameter "
+			"to rfkill_allocate\n", type))
+		return NULL;
+
 	rfkill = kzalloc(sizeof(struct rfkill), GFP_KERNEL);
 	if (!rfkill)
 		return NULL;
@@ -736,11 +755,12 @@ int __must_check rfkill_register(struct rfkill *rfkill)
 	struct device *dev = &rfkill->dev;
 	int error;
 
-	if (!rfkill->toggle_radio)
-		return -EINVAL;
-	if (rfkill->type >= RFKILL_TYPE_MAX)
-		return -EINVAL;
-	if (rfkill->state >= RFKILL_STATE_MAX)
+	if (WARN((!rfkill || !rfkill->toggle_radio ||
+			rfkill->type >= RFKILL_TYPE_MAX ||
+			rfkill->state >= RFKILL_STATE_MAX),
+			KERN_WARNING
+			"rfkill: attempt to register a "
+			"badly initialized rfkill struct\n"))
 		return -EINVAL;
 
 	snprintf(dev->bus_id, sizeof(dev->bus_id),
@@ -775,6 +795,7 @@ EXPORT_SYMBOL(rfkill_register);
  */
 void rfkill_unregister(struct rfkill *rfkill)
 {
+	BUG_ON(!rfkill);
 	device_del(&rfkill->dev);
 	rfkill_remove_switch(rfkill);
 	rfkill_led_trigger_unregister(rfkill);
@@ -811,9 +832,12 @@ int rfkill_set_default(enum rfkill_type type, enum rfkill_state state)
 {
 	int error;
 
-	if (type >= RFKILL_TYPE_MAX ||
-	    (state != RFKILL_STATE_SOFT_BLOCKED &&
-	     state != RFKILL_STATE_UNBLOCKED))
+	if (WARN((type >= RFKILL_TYPE_MAX ||
+			(state != RFKILL_STATE_SOFT_BLOCKED &&
+			 state != RFKILL_STATE_UNBLOCKED)),
+			KERN_WARNING
+			"rfkill: illegal state %d or type %d passed as "
+			"parameter to rfkill_set_default\n", state, type))
 		return -EINVAL;
 
 	mutex_lock(&rfkill_mutex);
-- 
1.5.6.3

