Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f210.google.com ([209.85.219.210]:51453 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754249AbZFPNxk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jun 2009 09:53:40 -0400
Received: by mail-ew0-f210.google.com with SMTP id 6so6028523ewy.37
        for <linux-wireless@vger.kernel.org>; Tue, 16 Jun 2009 06:53:42 -0700 (PDT)
Message-ID: <4A37A3E1.8060606@tuffmail.co.uk>
Date: Tue, 16 Jun 2009 14:53:37 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Marcel Holtmann <marcel@holtmann.org>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/4] rfkill: don't restore software blocked state on persistent
 devices
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The setting of the "persistent" flag is also made more explicit using
a new rfkill_init_sw_state() function, instead of special-casing
rfkill_set_sw_state() when it is called before registration.

Suspend is a bit of a corner case so we try to get away without adding
another hack to rfkill-input - it's going to be removed soon.
If the state does change over suspend, users will simply have to prod
rfkill-input twice in order to toggle the state.

Userspace policy agents will be able to implement a more consistent user
experience.  For example, they can avoid the above problem if they
toggle devices individually.  Then there would be no "global state"
to get out of sync.

Currently there are only two rfkill drivers with persistent soft-blocked
state.  thinkpad-acpi already checks the software state on resume.
eeepc-laptop will require modification.

Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
CC: Marcel Holtmann <marcel@holtmann.org>
---
 drivers/platform/x86/eeepc-laptop.c  |    8 +++---
 drivers/platform/x86/thinkpad_acpi.c |   14 ++++++------
 include/linux/rfkill.h               |   28 +++++++++++++++++++----
 net/rfkill/core.c                    |   40 +++++++++++++++++++++------------
 4 files changed, 59 insertions(+), 31 deletions(-)

diff --git a/drivers/platform/x86/eeepc-laptop.c b/drivers/platform/x86/eeepc-laptop.c
index 03bf522..01682ec 100644
--- a/drivers/platform/x86/eeepc-laptop.c
+++ b/drivers/platform/x86/eeepc-laptop.c
@@ -675,8 +675,8 @@ static int eeepc_hotk_add(struct acpi_device *device)
 		if (!ehotk->eeepc_wlan_rfkill)
 			goto wlan_fail;
 
-		rfkill_set_sw_state(ehotk->eeepc_wlan_rfkill,
-				    get_acpi(CM_ASL_WLAN) != 1);
+		rfkill_init_sw_state(ehotk->eeepc_wlan_rfkill,
+				     get_acpi(CM_ASL_WLAN) != 1);
 		result = rfkill_register(ehotk->eeepc_wlan_rfkill);
 		if (result)
 			goto wlan_fail;
@@ -693,8 +693,8 @@ static int eeepc_hotk_add(struct acpi_device *device)
 		if (!ehotk->eeepc_bluetooth_rfkill)
 			goto bluetooth_fail;
 
-		rfkill_set_sw_state(ehotk->eeepc_bluetooth_rfkill,
-				    get_acpi(CM_ASL_BLUETOOTH) != 1);
+		rfkill_init_sw_state(ehotk->eeepc_bluetooth_rfkill,
+				     get_acpi(CM_ASL_BLUETOOTH) != 1);
 		result = rfkill_register(ehotk->eeepc_bluetooth_rfkill);
 		if (result)
 			goto bluetooth_fail;
diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index 86e9585..40d64c0 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -1163,8 +1163,8 @@ static int __init tpacpi_new_rfkill(const enum tpacpi_rfk_id id,
 {
 	struct tpacpi_rfk *atp_rfk;
 	int res;
-	bool initial_sw_state = false;
-	int initial_sw_status;
+	bool sw_state = false;
+	int sw_status;
 
 	BUG_ON(id >= TPACPI_RFK_SW_MAX || tpacpi_rfkill_switches[id]);
 
@@ -1185,17 +1185,17 @@ static int __init tpacpi_new_rfkill(const enum tpacpi_rfk_id id,
 	atp_rfk->id = id;
 	atp_rfk->ops = tp_rfkops;
 
-	initial_sw_status = (tp_rfkops->get_status)();
-	if (initial_sw_status < 0) {
+	sw_status = (tp_rfkops->get_status)();
+	if (sw_status < 0) {
 		printk(TPACPI_ERR
 			"failed to read initial state for %s, error %d\n",
-			name, initial_sw_status);
+			name, sw_status);
 	} else {
-		initial_sw_state = (initial_sw_status == TPACPI_RFK_RADIO_OFF);
+		sw_state = (sw_status == TPACPI_RFK_RADIO_OFF);
 		if (set_default) {
 			/* try to keep the initial state, since we ask the
 			 * firmware to preserve it across S5 in NVRAM */
-			rfkill_set_sw_state(atp_rfk->rfkill, initial_sw_state);
+			rfkill_init_sw_state(atp_rfk->rfkill, sw_state);
 		}
 	}
 	rfkill_set_hw_state(atp_rfk->rfkill, tpacpi_rfk_check_hwblock_state());
diff --git a/include/linux/rfkill.h b/include/linux/rfkill.h
index 16e39c7..84b6b9c 100644
--- a/include/linux/rfkill.h
+++ b/include/linux/rfkill.h
@@ -160,8 +160,9 @@ struct rfkill * __must_check rfkill_alloc(const char *name,
  * the rfkill structure. Before calling this function the driver needs
  * to be ready to service method calls from rfkill.
  *
- * If the software blocked state is not set before registration,
- * set_block will be called to initialize it to a default value.
+ * If rfkill_init_sw_state() is not called before registration,
+ * set_block() will be called to initialize the software blocked state
+ * to a default value.
  *
  * If the hardware blocked state is not set before registration,
  * it is assumed to be unblocked.
@@ -234,9 +235,11 @@ bool __must_check rfkill_set_hw_state(struct rfkill *rfkill, bool blocked);
  * rfkill drivers that get events when the soft-blocked state changes
  * (yes, some platforms directly act on input but allow changing again)
  * use this function to notify the rfkill core (and through that also
- * userspace) of the current state.  It is not necessary to notify on
- * resume; since hibernation can always change the soft-blocked state,
- * the rfkill core will unconditionally restore the previous state.
+ * userspace) of the current state.
+ *
+ * Drivers should also call this function after resume if the state has
+ * been changed by the user.  This only makes sense for "persistent"
+ * devices (see rfkill_init_sw_state()).
  *
  * This function can be called in any context, even from within rfkill
  * callbacks.
@@ -247,6 +250,21 @@ bool __must_check rfkill_set_hw_state(struct rfkill *rfkill, bool blocked);
 bool rfkill_set_sw_state(struct rfkill *rfkill, bool blocked);
 
 /**
+ * rfkill_init_sw_state - Initialize persistent software block state
+ * @rfkill: pointer to the rfkill class to modify.
+ * @state: the current software block state to set
+ *
+ * rfkill drivers that preserve their software block state over power off
+ * use this function to notify the rfkill core (and through that also
+ * userspace) of their initial state.  It should only be used before
+ * registration.
+ *
+ * In addition, it marks the device as "persistent".  Persistent devices
+ * are expected to preserve preserve their own state when suspended.
+ */
+void rfkill_init_sw_state(struct rfkill *rfkill, bool blocked);
+
+/**
  * rfkill_set_states - Set the internal rfkill block states
  * @rfkill: pointer to the rfkill class to modify.
  * @sw: the current software block state to set
diff --git a/net/rfkill/core.c b/net/rfkill/core.c
index 868d79f..dcf8df7 100644
--- a/net/rfkill/core.c
+++ b/net/rfkill/core.c
@@ -56,7 +56,6 @@ struct rfkill {
 	u32			idx;
 
 	bool			registered;
-	bool			suspended;
 	bool			persistent;
 
 	const struct rfkill_ops	*ops;
@@ -224,7 +223,7 @@ static void rfkill_send_events(struct rfkill *rfkill, enum rfkill_operation op)
 
 static void rfkill_event(struct rfkill *rfkill)
 {
-	if (!rfkill->registered || rfkill->suspended)
+	if (!rfkill->registered)
 		return;
 
 	kobject_uevent(&rfkill->dev.kobj, KOBJ_CHANGE);
@@ -508,19 +507,32 @@ bool rfkill_set_sw_state(struct rfkill *rfkill, bool blocked)
 	blocked = blocked || hwblock;
 	spin_unlock_irqrestore(&rfkill->lock, flags);
 
-	if (!rfkill->registered) {
-		rfkill->persistent = true;
-	} else {
-		if (prev != blocked && !hwblock)
-			schedule_work(&rfkill->uevent_work);
+	if (!rfkill->registered)
+		return blocked;
 
-		rfkill_led_trigger_event(rfkill);
-	}
+	if (prev != blocked && !hwblock)
+		schedule_work(&rfkill->uevent_work);
+
+	rfkill_led_trigger_event(rfkill);
 
 	return blocked;
 }
 EXPORT_SYMBOL(rfkill_set_sw_state);
 
+void rfkill_init_sw_state(struct rfkill *rfkill, bool blocked)
+{
+	unsigned long flags;
+
+	BUG_ON(!rfkill);
+	BUG_ON(rfkill->registered);
+
+	spin_lock_irqsave(&rfkill->lock, flags);
+	__rfkill_set_sw_state(rfkill, blocked);
+	rfkill->persistent = true;
+	spin_unlock_irqrestore(&rfkill->lock, flags);
+}
+EXPORT_SYMBOL(rfkill_init_sw_state);
+
 void rfkill_set_states(struct rfkill *rfkill, bool sw, bool hw)
 {
 	unsigned long flags;
@@ -718,8 +730,6 @@ static int rfkill_suspend(struct device *dev, pm_message_t state)
 
 	rfkill_pause_polling(rfkill);
 
-	rfkill->suspended = true;
-
 	return 0;
 }
 
@@ -728,10 +738,10 @@ static int rfkill_resume(struct device *dev)
 	struct rfkill *rfkill = to_rfkill(dev);
 	bool cur;
 
-	cur = !!(rfkill->state & RFKILL_BLOCK_SW);
-	rfkill_set_block(rfkill, cur);
-
-	rfkill->suspended = false;
+	if (!rfkill->persistent) {
+		cur = !!(rfkill->state & RFKILL_BLOCK_SW);
+		rfkill_set_block(rfkill, cur);
+	}
 
 	rfkill_resume_polling(rfkill);
 


