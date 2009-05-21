Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:33669 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754216AbZEUDEd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 May 2009 23:04:33 -0400
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: [PATCH 3/3] thinkpad-acpi: convert to new rfkill API
Date: Thu, 21 May 2009 00:04:19 -0300
Message-Id: <1242875059-9627-4-git-send-email-hmh@hmh.eng.br>
In-Reply-To: <1242875059-9627-1-git-send-email-hmh@hmh.eng.br>
References: <1242875059-9627-1-git-send-email-hmh@hmh.eng.br>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Convert thinkpad-acpi to the new rfkill API.  This is anything
but simple and staightforward...

Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
---
 drivers/platform/x86/thinkpad_acpi.c |  870 ++++++++++++++++++----------------
 1 files changed, 449 insertions(+), 421 deletions(-)

diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index 912be65..531dbf8 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -166,13 +166,6 @@ enum {
 
 #define TPACPI_MAX_ACPI_ARGS 3
 
-/* rfkill switches */
-enum {
-	TPACPI_RFK_BLUETOOTH_SW_ID = 0,
-	TPACPI_RFK_WWAN_SW_ID,
-	TPACPI_RFK_UWB_SW_ID,
-};
-
 /* printk headers */
 #define TPACPI_LOG TPACPI_FILE ": "
 #define TPACPI_EMERG	KERN_EMERG	TPACPI_LOG
@@ -1005,67 +998,234 @@ static int __init tpacpi_check_std_acpi_brightness_support(void)
 	return 0;
 }
 
-static int __init tpacpi_new_rfkill(const unsigned int id,
-			struct rfkill **rfk,
+static void printk_deprecated_attribute(const char * const what,
+					const char * const details)
+{
+	tpacpi_log_usertask("deprecated sysfs attribute");
+	printk(TPACPI_WARN "WARNING: sysfs attribute %s is deprecated and "
+		"will be removed. %s\n",
+		what, details);
+}
+
+/*************************************************************************
+ * rfkill and radio control support helpers
+ */
+
+/*
+ * ThinkPad-ACPI firmware handling model:
+ *
+ * WLSW (master wireless switch) is event-driven, and is common to all
+ * firmware-controlled radios.  It cannot be controlled, just monitored,
+ * as expected.  It overrides all radio state in firmware
+ *
+ * The kernel, a masked-off hotkey, and WLSW can change the radio state
+ * (TODO: verify how WLSW interacts with the returned radio state).
+ *
+ * The only time there are shadow radio state changes, is when
+ * masked-off hotkeys are used.
+ */
+
+/*
+ * Internal driver API for radio state:
+ *
+ * int: < 0 = error, otherwise enum tpacpi_rfkill_state
+ * bool: true means radio blocked (off)
+ */
+enum tpacpi_rfkill_state {
+	TPACPI_RFK_RADIO_OFF = 0,
+	TPACPI_RFK_RADIO_ON
+};
+
+/* rfkill switches */
+enum tpacpi_rfk_id {
+	TPACPI_RFK_BLUETOOTH_SW_ID = 0,
+	TPACPI_RFK_WWAN_SW_ID,
+	TPACPI_RFK_UWB_SW_ID,
+	TPACPI_RFK_SW_MAX
+};
+
+static const char *tpacpi_rfkill_names[] = {
+	[TPACPI_RFK_BLUETOOTH_SW_ID] = "bluetooth",
+	[TPACPI_RFK_WWAN_SW_ID] = "wwan",
+	[TPACPI_RFK_UWB_SW_ID] = "uwb",
+	[TPACPI_RFK_SW_MAX] = NULL
+};
+
+/* ThinkPad-ACPI rfkill subdriver */
+struct tpacpi_rfk {
+	struct rfkill *rfkill;
+	enum tpacpi_rfk_id id;
+	const struct tpacpi_rfk_ops *ops;
+};
+
+struct tpacpi_rfk_ops {
+	/* firmware interface */
+	int (*get_status)(void);
+	int (*set_status)(const enum tpacpi_rfkill_state);
+};
+
+static struct tpacpi_rfk *tpacpi_rfkill_switches[TPACPI_RFK_SW_MAX];
+
+/* Query FW and update rfkill sw state for a given rfkill switch */
+static int tpacpi_rfk_update_swstate(const struct tpacpi_rfk *tp_rfk)
+{
+	int status;
+
+	if (!tp_rfk)
+		return -ENODEV;
+
+	status = (tp_rfk->ops->get_status)();
+	if (status < 0)
+		return status;
+
+	rfkill_set_sw_state(tp_rfk->rfkill,
+			    (status == TPACPI_RFK_RADIO_OFF));
+
+	return status;
+}
+
+/* Query FW and update rfkill sw state for all rfkill switches */
+static void tpacpi_rfk_update_swstate_all(void)
+{
+	unsigned int i;
+
+	for (i = 0; i < TPACPI_RFK_SW_MAX; i++)
+		tpacpi_rfk_update_swstate(tpacpi_rfkill_switches[i]);
+}
+
+/*
+ * Sync the HW-blocking state of all rfkill switches,
+ * do notice it causes the rfkill core to schedule uevents
+ */
+static void tpacpi_rfk_update_hwblock_state(bool blocked)
+{
+	unsigned int i;
+	struct tpacpi_rfk *tp_rfk;
+
+	for (i = 0; i < TPACPI_RFK_SW_MAX; i++) {
+		tp_rfk = tpacpi_rfkill_switches[i];
+		if (tp_rfk)
+			(void) rfkill_set_hw_state(tp_rfk->rfkill,
+						   blocked);
+	}
+}
+
+/* Call to get the WLSW state from the firmware */
+static int hotkey_get_wlsw(void);
+
+/* Call to query WLSW state and update all rfkill switches */
+static bool tpacpi_rfk_check_hwblock_state(void)
+{
+	int res = hotkey_get_wlsw();
+	int hw_blocked;
+
+	/* When unknown or unsupported, we have to assume it is unblocked */
+	if (res < 0)
+		return false;
+
+	hw_blocked = (res == TPACPI_RFK_RADIO_OFF);
+	tpacpi_rfk_update_hwblock_state(hw_blocked);
+
+	return hw_blocked;
+}
+
+static int tpacpi_rfk_hook_set_block(void *data, bool blocked)
+{
+	struct tpacpi_rfk *tp_rfk = data;
+	int res;
+
+	dbg_printk(TPACPI_DBG_RFKILL,
+		   "request to change radio state to %s\n",
+		   blocked ? "blocked" : "unblocked");
+
+	/* try to set radio state */
+	res = (tp_rfk->ops->set_status)(blocked ?
+				TPACPI_RFK_RADIO_OFF : TPACPI_RFK_RADIO_ON);
+
+	/* and update the rfkill core with whatever the FW really did */
+	tpacpi_rfk_update_swstate(tp_rfk);
+
+	return (res < 0) ? res : 0;
+}
+
+static const struct rfkill_ops tpacpi_rfk_rfkill_ops = {
+	.set_block = tpacpi_rfk_hook_set_block,
+};
+
+static int __init tpacpi_new_rfkill(const enum tpacpi_rfk_id id,
+			const struct tpacpi_rfk_ops *tp_rfkops,
 			const enum rfkill_type rfktype,
 			const char *name,
-			const bool set_default,
-			int (*toggle_radio)(void *, enum rfkill_state),
-			int (*get_state)(void *, enum rfkill_state *))
+			const bool set_default)
 {
+	struct tpacpi_rfk *atp_rfk;
 	int res;
-	enum rfkill_state initial_state = RFKILL_STATE_SOFT_BLOCKED;
+	bool initial_sw_state = false;
+	int initial_sw_status;
 
-	res = get_state(NULL, &initial_state);
-	if (res < 0) {
+	BUG_ON(id >= TPACPI_RFK_SW_MAX || tpacpi_rfkill_switches[id]);
+
+	initial_sw_status = (tp_rfkops->get_status)();
+	if (initial_sw_status < 0) {
 		printk(TPACPI_ERR
 			"failed to read initial state for %s, error %d; "
-			"will turn radio off\n", name, res);
-	} else if (set_default) {
-		/* try to set the initial state as the default for the rfkill
-		 * type, since we ask the firmware to preserve it across S5 in
-		 * NVRAM */
-		if (rfkill_set_default(rfktype,
-				(initial_state == RFKILL_STATE_UNBLOCKED) ?
-					RFKILL_STATE_UNBLOCKED :
-					RFKILL_STATE_SOFT_BLOCKED) == -EPERM)
-			vdbg_printk(TPACPI_DBG_RFKILL,
-				    "Default state for %s cannot be changed\n",
-				    name);
-	}
-
-	*rfk = rfkill_allocate(&tpacpi_pdev->dev, rfktype);
-	if (!*rfk) {
+			"will turn radio off\n", name, initial_sw_status);
+	} else {
+		initial_sw_state = (initial_sw_status == TPACPI_RFK_RADIO_OFF);
+		if (set_default) {
+			/* try to set the initial state as the default for the
+			 * rfkill type, since we ask the firmware to preserve
+			 * it across S5 in NVRAM */
+			rfkill_set_global_sw_state(rfktype, initial_sw_state);
+		}
+	}
+
+	atp_rfk = kzalloc(sizeof(struct tpacpi_rfk), GFP_KERNEL);
+	if (atp_rfk)
+		atp_rfk->rfkill = rfkill_alloc(name,
+						&tpacpi_pdev->dev,
+						rfktype,
+						&tpacpi_rfk_rfkill_ops,
+						atp_rfk);
+	if (!atp_rfk || !atp_rfk->rfkill) {
 		printk(TPACPI_ERR
 			"failed to allocate memory for rfkill class\n");
+		kfree(atp_rfk);
 		return -ENOMEM;
 	}
 
-	(*rfk)->name = name;
-	(*rfk)->get_state = get_state;
-	(*rfk)->toggle_radio = toggle_radio;
-	(*rfk)->state = initial_state;
+	atp_rfk->id = id;
+	atp_rfk->ops = tp_rfkops;
 
-	res = rfkill_register(*rfk);
+	rfkill_set_states(atp_rfk->rfkill, initial_sw_state,
+				tpacpi_rfk_check_hwblock_state());
+
+	res = rfkill_register(atp_rfk->rfkill);
 	if (res < 0) {
 		printk(TPACPI_ERR
 			"failed to register %s rfkill switch: %d\n",
 			name, res);
-		rfkill_free(*rfk);
-		*rfk = NULL;
+		rfkill_destroy(atp_rfk->rfkill);
+		kfree(atp_rfk);
 		return res;
 	}
 
+	tpacpi_rfkill_switches[id] = atp_rfk;
 	return 0;
 }
 
-static void printk_deprecated_attribute(const char * const what,
-					const char * const details)
+static void tpacpi_destroy_rfkill(const enum tpacpi_rfk_id id)
 {
-	tpacpi_log_usertask("deprecated sysfs attribute");
-	printk(TPACPI_WARN "WARNING: sysfs attribute %s is deprecated and "
-		"will be removed. %s\n",
-		what, details);
+	struct tpacpi_rfk *tp_rfk;
+
+	BUG_ON(id >= TPACPI_RFK_SW_MAX);
+
+	tp_rfk = tpacpi_rfkill_switches[id];
+	if (tp_rfk) {
+		rfkill_unregister(tp_rfk->rfkill);
+		tpacpi_rfkill_switches[id] = NULL;
+		kfree(tp_rfk);
+	}
 }
 
 static void printk_deprecated_rfkill_attribute(const char * const what)
@@ -1074,6 +1234,112 @@ static void printk_deprecated_rfkill_attribute(const char * const what)
 			"Please switch to generic rfkill before year 2010");
 }
 
+/* sysfs <radio> enable ------------------------------------------------ */
+static ssize_t tpacpi_rfk_sysfs_enable_show(const enum tpacpi_rfk_id id,
+					    struct device_attribute *attr,
+					    char *buf)
+{
+	int status;
+
+	printk_deprecated_rfkill_attribute(attr->attr.name);
+
+	/* This is in the ABI... */
+	if (tpacpi_rfk_check_hwblock_state()) {
+		status = TPACPI_RFK_RADIO_OFF;
+	} else {
+		status = tpacpi_rfk_update_swstate(tpacpi_rfkill_switches[id]);
+		if (status < 0)
+			return status;
+	}
+
+	return snprintf(buf, PAGE_SIZE, "%d\n",
+			(status == TPACPI_RFK_RADIO_ON) ? 1 : 0);
+}
+
+static ssize_t tpacpi_rfk_sysfs_enable_store(const enum tpacpi_rfk_id id,
+			    struct device_attribute *attr,
+			    const char *buf, size_t count)
+{
+	unsigned long t;
+	int res;
+
+	printk_deprecated_rfkill_attribute(attr->attr.name);
+
+	if (parse_strtoul(buf, 1, &t))
+		return -EINVAL;
+
+	tpacpi_disclose_usertask(attr->attr.name, "set to %ld\n", t);
+
+	/* This is in the ABI... */
+	if (tpacpi_rfk_check_hwblock_state() && !!t)
+		return -EPERM;
+
+	res = tpacpi_rfkill_switches[id]->ops->set_status((!!t) ?
+				TPACPI_RFK_RADIO_ON : TPACPI_RFK_RADIO_OFF);
+	tpacpi_rfk_update_swstate(tpacpi_rfkill_switches[id]);
+
+	return (res < 0) ? res : count;
+}
+
+/* procfs -------------------------------------------------------------- */
+static int tpacpi_rfk_procfs_read(const enum tpacpi_rfk_id id, char *p)
+{
+	int len = 0;
+
+	if (id >= TPACPI_RFK_SW_MAX)
+		len += sprintf(p + len, "status:\t\tnot supported\n");
+	else {
+		int status;
+
+		/* This is in the ABI... */
+		if (tpacpi_rfk_check_hwblock_state()) {
+			status = TPACPI_RFK_RADIO_OFF;
+		} else {
+			status = tpacpi_rfk_update_swstate(
+						tpacpi_rfkill_switches[id]);
+			if (status < 0)
+				return status;
+		}
+
+		len += sprintf(p + len, "status:\t\t%s\n",
+				(status == TPACPI_RFK_RADIO_ON) ?
+					"enabled" : "disabled");
+		len += sprintf(p + len, "commands:\tenable, disable\n");
+	}
+
+	return len;
+}
+
+static int tpacpi_rfk_procfs_write(const enum tpacpi_rfk_id id, char *buf)
+{
+	char *cmd;
+	int status = -1;
+	int res = 0;
+
+	if (id >= TPACPI_RFK_SW_MAX)
+		return -ENODEV;
+
+	while ((cmd = next_cmd(&buf))) {
+		if (strlencmp(cmd, "enable") == 0)
+			status = TPACPI_RFK_RADIO_ON;
+		else if (strlencmp(cmd, "disable") == 0)
+			status = TPACPI_RFK_RADIO_OFF;
+		else
+			return -EINVAL;
+	}
+
+	if (status != -1) {
+		tpacpi_disclose_usertask("procfs", "attempt to %s %s\n",
+				(status == TPACPI_RFK_RADIO_ON) ?
+						"enable" : "disable",
+				tpacpi_rfkill_names[id]);
+		res = (tpacpi_rfkill_switches[id]->ops->set_status)(status);
+		tpacpi_rfk_update_swstate(tpacpi_rfkill_switches[id]);
+	}
+
+	return res;
+}
+
 /*************************************************************************
  * thinkpad-acpi driver attributes
  */
@@ -1127,8 +1393,6 @@ static DRIVER_ATTR(version, S_IRUGO,
 
 #ifdef CONFIG_THINKPAD_ACPI_DEBUGFACILITIES
 
-static void tpacpi_send_radiosw_update(void);
-
 /* wlsw_emulstate ------------------------------------------------------ */
 static ssize_t tpacpi_driver_wlsw_emulstate_show(struct device_driver *drv,
 						char *buf)
@@ -1144,11 +1408,10 @@ static ssize_t tpacpi_driver_wlsw_emulstate_store(struct device_driver *drv,
 	if (parse_strtoul(buf, 1, &t))
 		return -EINVAL;
 
-	if (tpacpi_wlsw_emulstate != t) {
-		tpacpi_wlsw_emulstate = !!t;
-		tpacpi_send_radiosw_update();
-	} else
+	if (tpacpi_wlsw_emulstate != !!t) {
 		tpacpi_wlsw_emulstate = !!t;
+		tpacpi_rfk_update_hwblock_state(!t);	/* negative logic */
+	}
 
 	return count;
 }
@@ -1463,17 +1726,23 @@ static struct attribute_set *hotkey_dev_attributes;
 /* HKEY.MHKG() return bits */
 #define TP_HOTKEY_TABLET_MASK (1 << 3)
 
-static int hotkey_get_wlsw(int *status)
+static int hotkey_get_wlsw(void)
 {
+	int status;
+
+	if (!tp_features.hotkey_wlsw)
+		return -ENODEV;
+
 #ifdef CONFIG_THINKPAD_ACPI_DEBUGFACILITIES
-	if (dbg_wlswemul) {
-		*status = !!tpacpi_wlsw_emulstate;
-		return 0;
-	}
+	if (dbg_wlswemul)
+		return (tpacpi_wlsw_emulstate) ?
+				TPACPI_RFK_RADIO_ON : TPACPI_RFK_RADIO_OFF;
 #endif
-	if (!acpi_evalf(hkey_handle, status, "WLSW", "d"))
+
+	if (!acpi_evalf(hkey_handle, &status, "WLSW", "d"))
 		return -EIO;
-	return 0;
+
+	return (status) ? TPACPI_RFK_RADIO_ON : TPACPI_RFK_RADIO_OFF;
 }
 
 static int hotkey_get_tablet_mode(int *status)
@@ -2107,12 +2376,16 @@ static ssize_t hotkey_radio_sw_show(struct device *dev,
 			   struct device_attribute *attr,
 			   char *buf)
 {
-	int res, s;
-	res = hotkey_get_wlsw(&s);
+	int res;
+	res = hotkey_get_wlsw();
 	if (res < 0)
 		return res;
 
-	return snprintf(buf, PAGE_SIZE, "%d\n", !!s);
+	/* Opportunistic update */
+	tpacpi_rfk_update_hwblock_state((res == TPACPI_RFK_RADIO_OFF));
+
+	return snprintf(buf, PAGE_SIZE, "%d\n",
+			(res == TPACPI_RFK_RADIO_OFF) ? 0 : 1);
 }
 
 static struct device_attribute dev_attr_hotkey_radio_sw =
@@ -2223,30 +2496,52 @@ static struct attribute *hotkey_mask_attributes[] __initdata = {
 	&dev_attr_hotkey_wakeup_hotunplug_complete.attr,
 };
 
-static void bluetooth_update_rfk(void);
-static void wan_update_rfk(void);
-static void uwb_update_rfk(void);
+/*
+ * Sync both the hw and sw blocking state of all switches
+ */
 static void tpacpi_send_radiosw_update(void)
 {
 	int wlsw;
 
-	/* Sync these BEFORE sending any rfkill events */
-	if (tp_features.bluetooth)
-		bluetooth_update_rfk();
-	if (tp_features.wan)
-		wan_update_rfk();
-	if (tp_features.uwb)
-		uwb_update_rfk();
+	/*
+	 * We must sync all rfkill controllers *before* issuing any
+	 * rfkill input events, or we will race the rfkill core input
+	 * handler.
+	 *
+	 * tpacpi_inputdev_send_mutex works as a syncronization point
+	 * for the above.
+	 *
+	 * We optimize to avoid numerous calls to hotkey_get_wlsw.
+	 */
 
-	if (tp_features.hotkey_wlsw && !hotkey_get_wlsw(&wlsw)) {
+	wlsw = hotkey_get_wlsw();
+
+	/* Sync hw blocking state first if it is hw-blocked */
+	if (wlsw == TPACPI_RFK_RADIO_OFF)
+		tpacpi_rfk_update_hwblock_state(true);
+
+	/* Sync sw blocking state */
+	tpacpi_rfk_update_swstate_all();
+
+	/* Sync hw blocking state last if it is hw-unblocked */
+	if (wlsw == TPACPI_RFK_RADIO_ON)
+		tpacpi_rfk_update_hwblock_state(false);
+
+	/* Issue rfkill input event for WLSW switch */
+	if (!(wlsw < 0)) {
 		mutex_lock(&tpacpi_inputdev_send_mutex);
 
 		input_report_switch(tpacpi_inputdev,
-				    SW_RFKILL_ALL, !!wlsw);
+				    SW_RFKILL_ALL, (wlsw > 0));
 		input_sync(tpacpi_inputdev);
 
 		mutex_unlock(&tpacpi_inputdev_send_mutex);
 	}
+
+	/*
+	 * this can be unconditional, as we will poll state again
+	 * if userspace uses the notify to read data
+	 */
 	hotkey_radio_sw_notify_change();
 }
 
@@ -3056,8 +3351,6 @@ enum {
 
 #define TPACPI_RFK_BLUETOOTH_SW_NAME	"tpacpi_bluetooth_sw"
 
-static struct rfkill *tpacpi_bluetooth_rfkill;
-
 static void bluetooth_suspend(pm_message_t state)
 {
 	/* Try to make sure radio will resume powered off */
@@ -3067,83 +3360,47 @@ static void bluetooth_suspend(pm_message_t state)
 			"bluetooth power down on resume request failed\n");
 }
 
-static int bluetooth_get_radiosw(void)
+static int bluetooth_get_status(void)
 {
 	int status;
 
-	if (!tp_features.bluetooth)
-		return -ENODEV;
-
-	/* WLSW overrides bluetooth in firmware/hardware, reflect that */
-	if (tp_features.hotkey_wlsw && !hotkey_get_wlsw(&status) && !status)
-		return RFKILL_STATE_HARD_BLOCKED;
-
 #ifdef CONFIG_THINKPAD_ACPI_DEBUGFACILITIES
 	if (dbg_bluetoothemul)
 		return (tpacpi_bluetooth_emulstate) ?
-			RFKILL_STATE_UNBLOCKED : RFKILL_STATE_SOFT_BLOCKED;
+		       TPACPI_RFK_RADIO_ON : TPACPI_RFK_RADIO_OFF;
 #endif
 
 	if (!acpi_evalf(hkey_handle, &status, "GBDC", "d"))
 		return -EIO;
 
 	return ((status & TP_ACPI_BLUETOOTH_RADIOSSW) != 0) ?
-		RFKILL_STATE_UNBLOCKED : RFKILL_STATE_SOFT_BLOCKED;
-}
-
-static void bluetooth_update_rfk(void)
-{
-	int status;
-
-	if (!tpacpi_bluetooth_rfkill)
-		return;
-
-	status = bluetooth_get_radiosw();
-	if (status < 0)
-		return;
-	rfkill_force_state(tpacpi_bluetooth_rfkill, status);
-
-	vdbg_printk(TPACPI_DBG_RFKILL,
-		"forced rfkill state to %d\n",
-		status);
+			TPACPI_RFK_RADIO_ON : TPACPI_RFK_RADIO_OFF;
 }
 
-static int bluetooth_set_radiosw(int radio_on, int update_rfk)
+static int bluetooth_set_status(enum tpacpi_rfkill_state state)
 {
 	int status;
 
-	if (!tp_features.bluetooth)
-		return -ENODEV;
-
-	/* WLSW overrides bluetooth in firmware/hardware, but there is no
-	 * reason to risk weird behaviour. */
-	if (tp_features.hotkey_wlsw && !hotkey_get_wlsw(&status) && !status
-	    && radio_on)
-		return -EPERM;
-
 	vdbg_printk(TPACPI_DBG_RFKILL,
-		"will %s bluetooth\n", radio_on ? "enable" : "disable");
+		"will attempt to %s bluetooth\n",
+		(state == TPACPI_RFK_RADIO_ON) ? "enable" : "disable");
 
 #ifdef CONFIG_THINKPAD_ACPI_DEBUGFACILITIES
 	if (dbg_bluetoothemul) {
-		tpacpi_bluetooth_emulstate = !!radio_on;
-		if (update_rfk)
-			bluetooth_update_rfk();
+		tpacpi_bluetooth_emulstate = (state == TPACPI_RFK_RADIO_ON);
 		return 0;
 	}
 #endif
 
 	/* We make sure to keep TP_ACPI_BLUETOOTH_RESUMECTRL off */
-	if (radio_on)
+	if (state == TPACPI_RFK_RADIO_ON)
 		status = TP_ACPI_BLUETOOTH_RADIOSSW;
 	else
 		status = 0;
+
 	if (!acpi_evalf(hkey_handle, NULL, "SBDC", "vd", status))
 		return -EIO;
 
-	if (update_rfk)
-		bluetooth_update_rfk();
-
 	return 0;
 }
 
@@ -3152,35 +3409,16 @@ static ssize_t bluetooth_enable_show(struct device *dev,
 			   struct device_attribute *attr,
 			   char *buf)
 {
-	int status;
-
-	printk_deprecated_rfkill_attribute("bluetooth_enable");
-
-	status = bluetooth_get_radiosw();
-	if (status < 0)
-		return status;
-
-	return snprintf(buf, PAGE_SIZE, "%d\n",
-			(status == RFKILL_STATE_UNBLOCKED) ? 1 : 0);
+	return tpacpi_rfk_sysfs_enable_show(TPACPI_RFK_BLUETOOTH_SW_ID,
+			attr, buf);
 }
 
 static ssize_t bluetooth_enable_store(struct device *dev,
 			    struct device_attribute *attr,
 			    const char *buf, size_t count)
 {
-	unsigned long t;
-	int res;
-
-	printk_deprecated_rfkill_attribute("bluetooth_enable");
-
-	if (parse_strtoul(buf, 1, &t))
-		return -EINVAL;
-
-	tpacpi_disclose_usertask("bluetooth_enable", "set to %ld\n", t);
-
-	res = bluetooth_set_radiosw(t, 1);
-
-	return (res) ? res : count;
+	return tpacpi_rfk_sysfs_enable_store(TPACPI_RFK_BLUETOOTH_SW_ID,
+				attr, buf, count);
 }
 
 static struct device_attribute dev_attr_bluetooth_enable =
@@ -3198,23 +3436,10 @@ static const struct attribute_group bluetooth_attr_group = {
 	.attrs = bluetooth_attributes,
 };
 
-static int tpacpi_bluetooth_rfk_get(void *data, enum rfkill_state *state)
-{
-	int bts = bluetooth_get_radiosw();
-
-	if (bts < 0)
-		return bts;
-
-	*state = bts;
-	return 0;
-}
-
-static int tpacpi_bluetooth_rfk_set(void *data, enum rfkill_state state)
-{
-	dbg_printk(TPACPI_DBG_RFKILL,
-		   "request to change radio state to %d\n", state);
-	return bluetooth_set_radiosw((state == RFKILL_STATE_UNBLOCKED), 0);
-}
+static const struct tpacpi_rfk_ops bluetooth_tprfk_ops = {
+	.get_status = bluetooth_get_status,
+	.set_status = bluetooth_set_status,
+};
 
 static void bluetooth_shutdown(void)
 {
@@ -3230,13 +3455,12 @@ static void bluetooth_shutdown(void)
 
 static void bluetooth_exit(void)
 {
-	bluetooth_shutdown();
-
-	if (tpacpi_bluetooth_rfkill)
-		rfkill_unregister(tpacpi_bluetooth_rfkill);
-
 	sysfs_remove_group(&tpacpi_pdev->dev.kobj,
 			&bluetooth_attr_group);
+
+	tpacpi_destroy_rfkill(TPACPI_RFK_BLUETOOTH_SW_ID);
+
+	bluetooth_shutdown();
 }
 
 static int __init bluetooth_init(struct ibm_init_struct *iibm)
@@ -3277,20 +3501,18 @@ static int __init bluetooth_init(struct ibm_init_struct *iibm)
 	if (!tp_features.bluetooth)
 		return 1;
 
-	res = sysfs_create_group(&tpacpi_pdev->dev.kobj,
-				&bluetooth_attr_group);
-	if (res)
-		return res;
-
 	res = tpacpi_new_rfkill(TPACPI_RFK_BLUETOOTH_SW_ID,
-				&tpacpi_bluetooth_rfkill,
+				&bluetooth_tprfk_ops,
 				RFKILL_TYPE_BLUETOOTH,
 				TPACPI_RFK_BLUETOOTH_SW_NAME,
-				true,
-				tpacpi_bluetooth_rfk_set,
-				tpacpi_bluetooth_rfk_get);
+				true);
+	if (res)
+		return res;
+
+	res = sysfs_create_group(&tpacpi_pdev->dev.kobj,
+				&bluetooth_attr_group);
 	if (res) {
-		bluetooth_exit();
+		tpacpi_destroy_rfkill(TPACPI_RFK_BLUETOOTH_SW_ID);
 		return res;
 	}
 
@@ -3300,46 +3522,12 @@ static int __init bluetooth_init(struct ibm_init_struct *iibm)
 /* procfs -------------------------------------------------------------- */
 static int bluetooth_read(char *p)
 {
-	int len = 0;
-	int status = bluetooth_get_radiosw();
-
-	if (!tp_features.bluetooth)
-		len += sprintf(p + len, "status:\t\tnot supported\n");
-	else {
-		len += sprintf(p + len, "status:\t\t%s\n",
-				(status == RFKILL_STATE_UNBLOCKED) ?
-					"enabled" : "disabled");
-		len += sprintf(p + len, "commands:\tenable, disable\n");
-	}
-
-	return len;
+	return tpacpi_rfk_procfs_read(TPACPI_RFK_BLUETOOTH_SW_ID, p);
 }
 
 static int bluetooth_write(char *buf)
 {
-	char *cmd;
-	int state = -1;
-
-	if (!tp_features.bluetooth)
-		return -ENODEV;
-
-	while ((cmd = next_cmd(&buf))) {
-		if (strlencmp(cmd, "enable") == 0) {
-			state = 1;
-		} else if (strlencmp(cmd, "disable") == 0) {
-			state = 0;
-		} else
-			return -EINVAL;
-	}
-
-	if (state != -1) {
-		tpacpi_disclose_usertask("procfs bluetooth",
-			"attempt to %s\n",
-			state ? "enable" : "disable");
-		bluetooth_set_radiosw(state, 1);
-	}
-
-	return 0;
+	return tpacpi_rfk_procfs_write(TPACPI_RFK_BLUETOOTH_SW_ID, buf);
 }
 
 static struct ibm_struct bluetooth_driver_data = {
@@ -3365,8 +3553,6 @@ enum {
 
 #define TPACPI_RFK_WWAN_SW_NAME		"tpacpi_wwan_sw"
 
-static struct rfkill *tpacpi_wan_rfkill;
-
 static void wan_suspend(pm_message_t state)
 {
 	/* Try to make sure radio will resume powered off */
@@ -3376,83 +3562,47 @@ static void wan_suspend(pm_message_t state)
 			"WWAN power down on resume request failed\n");
 }
 
-static int wan_get_radiosw(void)
+static int wan_get_status(void)
 {
 	int status;
 
-	if (!tp_features.wan)
-		return -ENODEV;
-
-	/* WLSW overrides WWAN in firmware/hardware, reflect that */
-	if (tp_features.hotkey_wlsw && !hotkey_get_wlsw(&status) && !status)
-		return RFKILL_STATE_HARD_BLOCKED;
-
 #ifdef CONFIG_THINKPAD_ACPI_DEBUGFACILITIES
 	if (dbg_wwanemul)
 		return (tpacpi_wwan_emulstate) ?
-			RFKILL_STATE_UNBLOCKED : RFKILL_STATE_SOFT_BLOCKED;
+		       TPACPI_RFK_RADIO_ON : TPACPI_RFK_RADIO_OFF;
 #endif
 
 	if (!acpi_evalf(hkey_handle, &status, "GWAN", "d"))
 		return -EIO;
 
 	return ((status & TP_ACPI_WANCARD_RADIOSSW) != 0) ?
-		RFKILL_STATE_UNBLOCKED : RFKILL_STATE_SOFT_BLOCKED;
-}
-
-static void wan_update_rfk(void)
-{
-	int status;
-
-	if (!tpacpi_wan_rfkill)
-		return;
-
-	status = wan_get_radiosw();
-	if (status < 0)
-		return;
-	rfkill_force_state(tpacpi_wan_rfkill, status);
-
-	vdbg_printk(TPACPI_DBG_RFKILL,
-		"forced rfkill state to %d\n",
-		status);
+			TPACPI_RFK_RADIO_ON : TPACPI_RFK_RADIO_OFF;
 }
 
-static int wan_set_radiosw(int radio_on, int update_rfk)
+static int wan_set_status(enum tpacpi_rfkill_state state)
 {
 	int status;
 
-	if (!tp_features.wan)
-		return -ENODEV;
-
-	/* WLSW overrides bluetooth in firmware/hardware, but there is no
-	 * reason to risk weird behaviour. */
-	if (tp_features.hotkey_wlsw && !hotkey_get_wlsw(&status) && !status
-	    && radio_on)
-		return -EPERM;
-
 	vdbg_printk(TPACPI_DBG_RFKILL,
-		"will %s WWAN\n", radio_on ? "enable" : "disable");
+		"will attempt to %s wwan\n",
+		(state == TPACPI_RFK_RADIO_ON) ? "enable" : "disable");
 
 #ifdef CONFIG_THINKPAD_ACPI_DEBUGFACILITIES
 	if (dbg_wwanemul) {
-		tpacpi_wwan_emulstate = !!radio_on;
-		if (update_rfk)
-			wan_update_rfk();
+		tpacpi_wwan_emulstate = (state == TPACPI_RFK_RADIO_ON);
 		return 0;
 	}
 #endif
 
 	/* We make sure to keep TP_ACPI_WANCARD_RESUMECTRL off */
-	if (radio_on)
+	if (state == TPACPI_RFK_RADIO_ON)
 		status = TP_ACPI_WANCARD_RADIOSSW;
 	else
 		status = 0;
+
 	if (!acpi_evalf(hkey_handle, NULL, "SWAN", "vd", status))
 		return -EIO;
 
-	if (update_rfk)
-		wan_update_rfk();
-
 	return 0;
 }
 
@@ -3461,35 +3611,16 @@ static ssize_t wan_enable_show(struct device *dev,
 			   struct device_attribute *attr,
 			   char *buf)
 {
-	int status;
-
-	printk_deprecated_rfkill_attribute("wwan_enable");
-
-	status = wan_get_radiosw();
-	if (status < 0)
-		return status;
-
-	return snprintf(buf, PAGE_SIZE, "%d\n",
-			(status == RFKILL_STATE_UNBLOCKED) ? 1 : 0);
+	return tpacpi_rfk_sysfs_enable_show(TPACPI_RFK_WWAN_SW_ID,
+			attr, buf);
 }
 
 static ssize_t wan_enable_store(struct device *dev,
 			    struct device_attribute *attr,
 			    const char *buf, size_t count)
 {
-	unsigned long t;
-	int res;
-
-	printk_deprecated_rfkill_attribute("wwan_enable");
-
-	if (parse_strtoul(buf, 1, &t))
-		return -EINVAL;
-
-	tpacpi_disclose_usertask("wwan_enable", "set to %ld\n", t);
-
-	res = wan_set_radiosw(t, 1);
-
-	return (res) ? res : count;
+	return tpacpi_rfk_sysfs_enable_store(TPACPI_RFK_WWAN_SW_ID,
+			attr, buf, count);
 }
 
 static struct device_attribute dev_attr_wan_enable =
@@ -3507,23 +3638,10 @@ static const struct attribute_group wan_attr_group = {
 	.attrs = wan_attributes,
 };
 
-static int tpacpi_wan_rfk_get(void *data, enum rfkill_state *state)
-{
-	int wans = wan_get_radiosw();
-
-	if (wans < 0)
-		return wans;
-
-	*state = wans;
-	return 0;
-}
-
-static int tpacpi_wan_rfk_set(void *data, enum rfkill_state state)
-{
-	dbg_printk(TPACPI_DBG_RFKILL,
-		   "request to change radio state to %d\n", state);
-	return wan_set_radiosw((state == RFKILL_STATE_UNBLOCKED), 0);
-}
+static const struct tpacpi_rfk_ops wan_tprfk_ops = {
+	.get_status = wan_get_status,
+	.set_status = wan_set_status,
+};
 
 static void wan_shutdown(void)
 {
@@ -3539,13 +3657,12 @@ static void wan_shutdown(void)
 
 static void wan_exit(void)
 {
-	wan_shutdown();
-
-	if (tpacpi_wan_rfkill)
-		rfkill_unregister(tpacpi_wan_rfkill);
-
 	sysfs_remove_group(&tpacpi_pdev->dev.kobj,
 		&wan_attr_group);
+
+	tpacpi_destroy_rfkill(TPACPI_RFK_WWAN_SW_ID);
+
+	wan_shutdown();
 }
 
 static int __init wan_init(struct ibm_init_struct *iibm)
@@ -3584,20 +3701,19 @@ static int __init wan_init(struct ibm_init_struct *iibm)
 	if (!tp_features.wan)
 		return 1;
 
-	res = sysfs_create_group(&tpacpi_pdev->dev.kobj,
-				&wan_attr_group);
-	if (res)
-		return res;
-
 	res = tpacpi_new_rfkill(TPACPI_RFK_WWAN_SW_ID,
-				&tpacpi_wan_rfkill,
+				&wan_tprfk_ops,
 				RFKILL_TYPE_WWAN,
 				TPACPI_RFK_WWAN_SW_NAME,
-				true,
-				tpacpi_wan_rfk_set,
-				tpacpi_wan_rfk_get);
+				true);
+	if (res)
+		return res;
+
+	res = sysfs_create_group(&tpacpi_pdev->dev.kobj,
+				&wan_attr_group);
+
 	if (res) {
-		wan_exit();
+		tpacpi_destroy_rfkill(TPACPI_RFK_WWAN_SW_ID);
 		return res;
 	}
 
@@ -3607,48 +3723,12 @@ static int __init wan_init(struct ibm_init_struct *iibm)
 /* procfs -------------------------------------------------------------- */
 static int wan_read(char *p)
 {
-	int len = 0;
-	int status = wan_get_radiosw();
-
-	tpacpi_disclose_usertask("procfs wan", "read");
-
-	if (!tp_features.wan)
-		len += sprintf(p + len, "status:\t\tnot supported\n");
-	else {
-		len += sprintf(p + len, "status:\t\t%s\n",
-				(status == RFKILL_STATE_UNBLOCKED) ?
-					"enabled" : "disabled");
-		len += sprintf(p + len, "commands:\tenable, disable\n");
-	}
-
-	return len;
+	return tpacpi_rfk_procfs_read(TPACPI_RFK_WWAN_SW_ID, p);
 }
 
 static int wan_write(char *buf)
 {
-	char *cmd;
-	int state = -1;
-
-	if (!tp_features.wan)
-		return -ENODEV;
-
-	while ((cmd = next_cmd(&buf))) {
-		if (strlencmp(cmd, "enable") == 0) {
-			state = 1;
-		} else if (strlencmp(cmd, "disable") == 0) {
-			state = 0;
-		} else
-			return -EINVAL;
-	}
-
-	if (state != -1) {
-		tpacpi_disclose_usertask("procfs wan",
-			"attempt to %s\n",
-			state ? "enable" : "disable");
-		wan_set_radiosw(state, 1);
-	}
-
-	return 0;
+	return tpacpi_rfk_procfs_write(TPACPI_RFK_WWAN_SW_ID, buf);
 }
 
 static struct ibm_struct wan_driver_data = {
@@ -3672,108 +3752,59 @@ enum {
 
 #define TPACPI_RFK_UWB_SW_NAME	"tpacpi_uwb_sw"
 
-static struct rfkill *tpacpi_uwb_rfkill;
-
-static int uwb_get_radiosw(void)
+static int uwb_get_status(void)
 {
 	int status;
 
-	if (!tp_features.uwb)
-		return -ENODEV;
-
-	/* WLSW overrides UWB in firmware/hardware, reflect that */
-	if (tp_features.hotkey_wlsw && !hotkey_get_wlsw(&status) && !status)
-		return RFKILL_STATE_HARD_BLOCKED;
-
 #ifdef CONFIG_THINKPAD_ACPI_DEBUGFACILITIES
 	if (dbg_uwbemul)
 		return (tpacpi_uwb_emulstate) ?
-			RFKILL_STATE_UNBLOCKED : RFKILL_STATE_SOFT_BLOCKED;
+		       TPACPI_RFK_RADIO_ON : TPACPI_RFK_RADIO_OFF;
 #endif
 
 	if (!acpi_evalf(hkey_handle, &status, "GUWB", "d"))
 		return -EIO;
 
 	return ((status & TP_ACPI_UWB_RADIOSSW) != 0) ?
-		RFKILL_STATE_UNBLOCKED : RFKILL_STATE_SOFT_BLOCKED;
+			TPACPI_RFK_RADIO_ON : TPACPI_RFK_RADIO_OFF;
 }
 
-static void uwb_update_rfk(void)
+static int uwb_set_status(enum tpacpi_rfkill_state state)
 {
 	int status;
 
-	if (!tpacpi_uwb_rfkill)
-		return;
-
-	status = uwb_get_radiosw();
-	if (status < 0)
-		return;
-	rfkill_force_state(tpacpi_uwb_rfkill, status);
-
 	vdbg_printk(TPACPI_DBG_RFKILL,
-		"forced rfkill state to %d\n",
-		status);
-}
-
-static int uwb_set_radiosw(int radio_on, int update_rfk)
-{
-	int status;
-
-	if (!tp_features.uwb)
-		return -ENODEV;
-
-	/* WLSW overrides UWB in firmware/hardware, but there is no
-	 * reason to risk weird behaviour. */
-	if (tp_features.hotkey_wlsw && !hotkey_get_wlsw(&status) && !status
-	    && radio_on)
-		return -EPERM;
-
-	vdbg_printk(TPACPI_DBG_RFKILL,
-			"will %s UWB\n", radio_on ? "enable" : "disable");
+		"will attempt to %s UWB\n",
+		(state == TPACPI_RFK_RADIO_ON) ? "enable" : "disable");
 
 #ifdef CONFIG_THINKPAD_ACPI_DEBUGFACILITIES
 	if (dbg_uwbemul) {
-		tpacpi_uwb_emulstate = !!radio_on;
-		if (update_rfk)
-			uwb_update_rfk();
+		tpacpi_uwb_emulstate = (state == TPACPI_RFK_RADIO_ON);
 		return 0;
 	}
 #endif
 
-	status = (radio_on) ? TP_ACPI_UWB_RADIOSSW : 0;
+	if (state == TPACPI_RFK_RADIO_ON)
+		status = TP_ACPI_UWB_RADIOSSW;
+	else
+		status = 0;
+
 	if (!acpi_evalf(hkey_handle, NULL, "SUWB", "vd", status))
 		return -EIO;
 
-	if (update_rfk)
-		uwb_update_rfk();
-
 	return 0;
 }
 
 /* --------------------------------------------------------------------- */
 
-static int tpacpi_uwb_rfk_get(void *data, enum rfkill_state *state)
-{
-	int uwbs = uwb_get_radiosw();
-
-	if (uwbs < 0)
-		return uwbs;
-
-	*state = uwbs;
-	return 0;
-}
-
-static int tpacpi_uwb_rfk_set(void *data, enum rfkill_state state)
-{
-	dbg_printk(TPACPI_DBG_RFKILL,
-		   "request to change radio state to %d\n", state);
-	return uwb_set_radiosw((state == RFKILL_STATE_UNBLOCKED), 0);
-}
+static const struct tpacpi_rfk_ops uwb_tprfk_ops = {
+	.get_status = uwb_get_status,
+	.set_status = uwb_set_status,
+};
 
 static void uwb_exit(void)
 {
-	if (tpacpi_uwb_rfkill)
-		rfkill_unregister(tpacpi_uwb_rfkill);
+	tpacpi_destroy_rfkill(TPACPI_RFK_UWB_SW_ID);
 }
 
 static int __init uwb_init(struct ibm_init_struct *iibm)
@@ -3813,13 +3844,10 @@ static int __init uwb_init(struct ibm_init_struct *iibm)
 		return 1;
 
 	res = tpacpi_new_rfkill(TPACPI_RFK_UWB_SW_ID,
-				&tpacpi_uwb_rfkill,
+				&uwb_tprfk_ops,
 				RFKILL_TYPE_UWB,
 				TPACPI_RFK_UWB_SW_NAME,
-				false,
-				tpacpi_uwb_rfk_set,
-				tpacpi_uwb_rfk_get);
-
+				false);
 	return res;
 }
 
-- 
1.6.3.1

