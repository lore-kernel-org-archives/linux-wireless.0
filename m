Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f213.google.com ([209.85.218.213]:48769 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752663AbZFHKPD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jun 2009 06:15:03 -0400
Received: by bwz9 with SMTP id 9so2923304bwz.37
        for <linux-wireless@vger.kernel.org>; Mon, 08 Jun 2009 03:15:04 -0700 (PDT)
Message-ID: <4A2CE4A2.2090308@tuffmail.co.uk>
Date: Mon, 08 Jun 2009 11:14:58 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Marcel Holtmann <marcel@holtmann.org>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: [RFC] rfkill: remove set_global_sw_state()
References: <1243885494.3015.29.camel@localhost.localdomain>	 <4A24559D.7010201@tuffmail.co.uk>	 <1243928308.3192.38.camel@localhost.localdomain>	 <1243929706.20064.7.camel@johannes.local>	 <1243930703.3192.59.camel@localhost.localdomain>	 <20090603040315.GA10464@khazad-dum.debian.net>	 <1244008652.4145.7.camel@localhost.localdomain>	 <20090603213340.GB22809@khazad-dum.debian.net>	 <1244088806.4145.24.camel@localhost.localdomain>	 <9b2b86520906070538s7def28f0nb269914e03207228@mail.gmail.com>	 <20090607125715.GC3340@khazad-dum.debian.net> <1244394963.12956.1.camel@johannes.local> <4A2BF833.1050906@tuffmail.co.uk>
In-Reply-To: <4A2BF833.1050906@tuffmail.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rfkill_set_global_sw_state() (previously rfkill_set_default()) will no
longer be exported by the rewritten rfkill core.

Instead, platform drivers which can provide persistent soft-rfkill state
across power-down/reboot should indicate their initial state by calling
rfkill_set_sw_state() before registration.  Otherwise, they will be
initialized to a default value during registration by a set_block call.

We remove existing calls to rfkill_set_sw_state() which happen before
registration, since these had no effect in the old model.  If these
drivers do have persistent state, the calls can be put back (subject
to testing :-).  This affects hp-wmi and acer-wmi.


Drivers with persistent state will affect the global state only if
rfkill-input is enabled.  This is required, otherwise booting with
wireless soft-blocked and pressing the wireless-toggle key once would
have no apparent effect.  This special case will be removed in future
along with rfkill-input, in favour of a more flexible userspace daemon
(see Documentation/feature-removal-schedule.txt).


Now rfkill_global_states[n].def is only used to preserve global states
over EPO, it is renamed to ".sav".

Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
---
 drivers/platform/x86/acer-wmi.c      |    3 -
 drivers/platform/x86/eeepc-laptop.c  |    8 ++--
 drivers/platform/x86/hp-wmi.c        |    4 --
 drivers/platform/x86/thinkpad_acpi.c |   31 ++++++-------
 include/linux/rfkill.h               |   23 +++------
 net/rfkill/core.c                    |   81 ++++++++++++---------------------
 6 files changed, 56 insertions(+), 94 deletions(-)

diff --git a/drivers/platform/x86/acer-wmi.c b/drivers/platform/x86/acer-wmi.c
index b618fa5..09a503e 100644
--- a/drivers/platform/x86/acer-wmi.c
+++ b/drivers/platform/x86/acer-wmi.c
@@ -988,7 +988,6 @@ static struct rfkill *acer_rfkill_register(struct device *dev,
 					   char *name, u32 cap)
 {
 	int err;
-	u32 state;
 	struct rfkill *rfkill_dev;
 
 	rfkill_dev = rfkill_alloc(name, dev, type,
@@ -996,8 +995,6 @@ static struct rfkill *acer_rfkill_register(struct device *dev,
 				  (void *)(unsigned long)cap);
 	if (!rfkill_dev)
 		return ERR_PTR(-ENOMEM);
-	get_u32(&state, cap);
-	rfkill_set_sw_state(rfkill_dev, !state);
 
 	err = rfkill_register(rfkill_dev);
 	if (err) {
diff --git a/drivers/platform/x86/eeepc-laptop.c b/drivers/platform/x86/eeepc-laptop.c
index 1208d0c..03bf522 100644
--- a/drivers/platform/x86/eeepc-laptop.c
+++ b/drivers/platform/x86/eeepc-laptop.c
@@ -675,8 +675,8 @@ static int eeepc_hotk_add(struct acpi_device *device)
 		if (!ehotk->eeepc_wlan_rfkill)
 			goto wlan_fail;
 
-		rfkill_set_global_sw_state(RFKILL_TYPE_WLAN,
-					   get_acpi(CM_ASL_WLAN) != 1);
+		rfkill_set_sw_state(ehotk->eeepc_wlan_rfkill,
+				    get_acpi(CM_ASL_WLAN) != 1);
 		result = rfkill_register(ehotk->eeepc_wlan_rfkill);
 		if (result)
 			goto wlan_fail;
@@ -693,8 +693,8 @@ static int eeepc_hotk_add(struct acpi_device *device)
 		if (!ehotk->eeepc_bluetooth_rfkill)
 			goto bluetooth_fail;
 
-		rfkill_set_global_sw_state(RFKILL_TYPE_BLUETOOTH,
-					   get_acpi(CM_ASL_BLUETOOTH) != 1);
+		rfkill_set_sw_state(ehotk->eeepc_bluetooth_rfkill,
+				    get_acpi(CM_ASL_BLUETOOTH) != 1);
 		result = rfkill_register(ehotk->eeepc_bluetooth_rfkill);
 		if (result)
 			goto bluetooth_fail;
diff --git a/drivers/platform/x86/hp-wmi.c b/drivers/platform/x86/hp-wmi.c
index 8d93114..16fffe4 100644
--- a/drivers/platform/x86/hp-wmi.c
+++ b/drivers/platform/x86/hp-wmi.c
@@ -422,7 +422,6 @@ static int __init hp_wmi_bios_setup(struct platform_device *device)
 					   RFKILL_TYPE_WLAN,
 					   &hp_wmi_rfkill_ops,
 					   (void *) 0);
-		rfkill_set_sw_state(wifi_rfkill, hp_wmi_wifi_state());
 		err = rfkill_register(wifi_rfkill);
 		if (err)
 			goto register_wifi_error;
@@ -433,8 +432,6 @@ static int __init hp_wmi_bios_setup(struct platform_device *device)
 						RFKILL_TYPE_BLUETOOTH,
 						&hp_wmi_rfkill_ops,
 						(void *) 1);
-		rfkill_set_sw_state(bluetooth_rfkill,
-				    hp_wmi_bluetooth_state());
 		err = rfkill_register(bluetooth_rfkill);
 		if (err)
 			goto register_bluetooth_error;
@@ -445,7 +442,6 @@ static int __init hp_wmi_bios_setup(struct platform_device *device)
 					   RFKILL_TYPE_WWAN,
 					   &hp_wmi_rfkill_ops,
 					   (void *) 2);
-		rfkill_set_sw_state(wwan_rfkill, hp_wmi_wwan_state());
 		err = rfkill_register(wwan_rfkill);
 		if (err)
 			goto register_wwan_err;
diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index cfcafa4..ab6968a 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -1168,21 +1168,6 @@ static int __init tpacpi_new_rfkill(const enum tpacpi_rfk_id id,
 
 	BUG_ON(id >= TPACPI_RFK_SW_MAX || tpacpi_rfkill_switches[id]);
 
-	initial_sw_status = (tp_rfkops->get_status)();
-	if (initial_sw_status < 0) {
-		printk(TPACPI_ERR
-			"failed to read initial state for %s, error %d; "
-			"will turn radio off\n", name, initial_sw_status);
-	} else {
-		initial_sw_state = (initial_sw_status == TPACPI_RFK_RADIO_OFF);
-		if (set_default) {
-			/* try to set the initial state as the default for the
-			 * rfkill type, since we ask the firmware to preserve
-			 * it across S5 in NVRAM */
-			rfkill_set_global_sw_state(rfktype, initial_sw_state);
-		}
-	}
-
 	atp_rfk = kzalloc(sizeof(struct tpacpi_rfk), GFP_KERNEL);
 	if (atp_rfk)
 		atp_rfk->rfkill = rfkill_alloc(name,
@@ -1200,8 +1185,20 @@ static int __init tpacpi_new_rfkill(const enum tpacpi_rfk_id id,
 	atp_rfk->id = id;
 	atp_rfk->ops = tp_rfkops;
 
-	rfkill_set_states(atp_rfk->rfkill, initial_sw_state,
-				tpacpi_rfk_check_hwblock_state());
+	initial_sw_status = (tp_rfkops->get_status)();
+	if (initial_sw_status < 0) {
+		printk(TPACPI_ERR
+			"failed to read initial state for %s, error %d; "
+			"will turn radio off\n", name, initial_sw_status);
+	} else {
+		initial_sw_state = (initial_sw_status == TPACPI_RFK_RADIO_OFF);
+		if (set_default) {
+			/* try to keep the initial state, since we ask the
+			 * firmware to preserve it across S5 in NVRAM */
+			rfkill_set_sw_state(atp_rfk->rfkill, initial_sw_state);
+		}
+	}
+	rfkill_set_hw_state(atp_rfk->rfkill, tpacpi_rfk_check_hwblock_state());
 
 	res = rfkill_register(atp_rfk->rfkill);
 	if (res < 0) {
diff --git a/include/linux/rfkill.h b/include/linux/rfkill.h
index ee3edde..f8852bb 100644
--- a/include/linux/rfkill.h
+++ b/include/linux/rfkill.h
@@ -156,8 +156,14 @@ struct rfkill * __must_check rfkill_alloc(const char *name,
  * @rfkill: rfkill structure to be registered
  *
  * This function should be called by the transmitter driver to register
- * the rfkill structure needs to be registered. Before calling this function
- * the driver needs to be ready to service method calls from rfkill.
+ * the rfkill structure. Before calling this function the driver needs
+ * to be ready to service method calls from rfkill.
+ *
+ * If the software blocked state is not set before registration,
+ * set_block will be called to initialize it to a default value.
+ *
+ * If the hardware blocked state is not set before registration,
+ * it is assumed to be unblocked.
  */
 int __must_check rfkill_register(struct rfkill *rfkill);
 
@@ -250,19 +256,6 @@ bool rfkill_set_sw_state(struct rfkill *rfkill, bool blocked);
 void rfkill_set_states(struct rfkill *rfkill, bool sw, bool hw);
 
 /**
- * rfkill_set_global_sw_state - set global sw block default
- * @type: rfkill type to set default for
- * @blocked: default to set
- *
- * This function sets the global default -- use at boot if your platform has
- * an rfkill switch. If not early enough this call may be ignored.
- *
- * XXX: instead of ignoring -- how about just updating all currently
- *	registered drivers?
- */
-void rfkill_set_global_sw_state(const enum rfkill_type type, bool blocked);
-
-/**
  * rfkill_blocked - query rfkill block
  *
  * @rfkill: rfkill struct to query
diff --git a/net/rfkill/core.c b/net/rfkill/core.c
index 11b7314..d14493f 100644
--- a/net/rfkill/core.c
+++ b/net/rfkill/core.c
@@ -57,6 +57,7 @@ struct rfkill {
 
 	bool			registered;
 	bool			suspended;
+	bool			persistent;
 
 	const struct rfkill_ops	*ops;
 	void			*data;
@@ -116,11 +117,9 @@ MODULE_PARM_DESC(default_state,
 		 "Default initial state for all radio types, 0 = radio off");
 
 static struct {
-	bool cur, def;
+	bool cur, sav;
 } rfkill_global_states[NUM_RFKILL_TYPES];
 
-static unsigned long rfkill_states_default_locked;
-
 static bool rfkill_epo_lock_active;
 
 
@@ -392,7 +391,7 @@ void rfkill_epo(void)
 		rfkill_set_block(rfkill, true);
 
 	for (i = 0; i < NUM_RFKILL_TYPES; i++) {
-		rfkill_global_states[i].def = rfkill_global_states[i].cur;
+		rfkill_global_states[i].sav = rfkill_global_states[i].cur;
 		rfkill_global_states[i].cur = true;
 	}
 
@@ -417,7 +416,7 @@ void rfkill_restore_states(void)
 
 	rfkill_epo_lock_active = false;
 	for (i = 0; i < NUM_RFKILL_TYPES; i++)
-		__rfkill_switch_all(i, rfkill_global_states[i].def);
+		__rfkill_switch_all(i, rfkill_global_states[i].sav);
 	mutex_unlock(&rfkill_global_mutex);
 }
 
@@ -464,29 +463,6 @@ bool rfkill_get_global_sw_state(const enum rfkill_type type)
 }
 #endif
 
-void rfkill_set_global_sw_state(const enum rfkill_type type, bool blocked)
-{
-	BUG_ON(type == RFKILL_TYPE_ALL);
-
-	mutex_lock(&rfkill_global_mutex);
-
-	/* don't allow unblock when epo */
-	if (rfkill_epo_lock_active && !blocked)
-		goto out;
-
-	/* too late */
-	if (rfkill_states_default_locked & BIT(type))
-		goto out;
-
-	rfkill_states_default_locked |= BIT(type);
-
-	rfkill_global_states[type].cur = blocked;
-	rfkill_global_states[type].def = blocked;
- out:
-	mutex_unlock(&rfkill_global_mutex);
-}
-EXPORT_SYMBOL(rfkill_set_global_sw_state);
-
 
 bool rfkill_set_hw_state(struct rfkill *rfkill, bool blocked)
 {
@@ -532,13 +508,14 @@ bool rfkill_set_sw_state(struct rfkill *rfkill, bool blocked)
 	blocked = blocked || hwblock;
 	spin_unlock_irqrestore(&rfkill->lock, flags);
 
-	if (!rfkill->registered)
-		return blocked;
+	if (!rfkill->registered) {
+		rfkill->persistent = true;
+	} else {
+		if (prev != blocked && !hwblock)
+			schedule_work(&rfkill->uevent_work);
 
-	if (prev != blocked && !hwblock)
-		schedule_work(&rfkill->uevent_work);
-
-	rfkill_led_trigger_event(rfkill);
+		rfkill_led_trigger_event(rfkill);
+	}
 
 	return blocked;
 }
@@ -563,13 +540,14 @@ void rfkill_set_states(struct rfkill *rfkill, bool sw, bool hw)
 
 	spin_unlock_irqrestore(&rfkill->lock, flags);
 
-	if (!rfkill->registered)
-		return;
-
-	if (swprev != sw || hwprev != hw)
-		schedule_work(&rfkill->uevent_work);
+	if (!rfkill->registered) {
+		rfkill->persistent = true;
+	} else {
+		if (swprev != sw || hwprev != hw)
+			schedule_work(&rfkill->uevent_work);
 
-	rfkill_led_trigger_event(rfkill);
+		rfkill_led_trigger_event(rfkill);
+	}
 }
 EXPORT_SYMBOL(rfkill_set_states);
 
@@ -888,15 +866,6 @@ int __must_check rfkill_register(struct rfkill *rfkill)
 	dev_set_name(dev, "rfkill%lu", rfkill_no);
 	rfkill_no++;
 
-	if (!(rfkill_states_default_locked & BIT(rfkill->type))) {
-		/* first of its kind */
-		BUILD_BUG_ON(NUM_RFKILL_TYPES >
-			sizeof(rfkill_states_default_locked) * 8);
-		rfkill_states_default_locked |= BIT(rfkill->type);
-		rfkill_global_states[rfkill->type].cur =
-			rfkill_global_states[rfkill->type].def;
-	}
-
 	list_add_tail(&rfkill->node, &rfkill_list);
 
 	error = device_add(dev);
@@ -916,7 +885,17 @@ int __must_check rfkill_register(struct rfkill *rfkill)
 	if (rfkill->ops->poll)
 		schedule_delayed_work(&rfkill->poll_work,
 			round_jiffies_relative(POLL_INTERVAL));
-	schedule_work(&rfkill->sync_work);
+
+	if (!rfkill->persistent || rfkill_epo_lock_active) {
+		schedule_work(&rfkill->sync_work);
+	} else {
+#ifdef CONFIG_RFKILL_INPUT
+		bool soft_blocked = !!(rfkill->state & RFKILL_BLOCK_SW);
+
+		if (!atomic_read(&rfkill_input_disabled))
+			__rfkill_switch_all(rfkill->type, soft_blocked);
+#endif
+	}
 
 	rfkill_send_events(rfkill, RFKILL_OP_ADD);
 
@@ -1191,7 +1170,7 @@ static int __init rfkill_init(void)
 	int i;
 
 	for (i = 0; i < NUM_RFKILL_TYPES; i++)
-		rfkill_global_states[i].def = !rfkill_default_state;
+		rfkill_global_states[i].cur = !rfkill_default_state;
 
 	error = class_register(&rfkill_class);
 	if (error)


