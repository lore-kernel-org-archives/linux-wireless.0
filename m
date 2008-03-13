Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.191]:31933 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752789AbYCMOiv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Mar 2008 10:38:51 -0400
Received: by mu-out-0910.google.com with SMTP id i10so8956807mue.5
        for <linux-wireless@vger.kernel.org>; Thu, 13 Mar 2008 07:38:49 -0700 (PDT)
To: "John W. Linville" <linville@redhat.com>
Subject: [PATCH] rt2x00: Add suspend/resume handlers to rt2x00rfkill
Date: Thu, 13 Mar 2008 15:38:03 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200803131538.03520.IvDoorn@gmail.com> (sfid-20080313_143900_411302_F239B775)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add suspend/resume handlers to rt2x00rfkill to have it stop
the input-polldev and prevent it from calling rt2x00 during
suspend period. This could lead to a NULL pointer fault when
rt2x00 suspended, but polldev send a request, because
the csr_addr is NULL.

Also don't let the rfkill allocation/registration block
the initialization of the entire device. Just print a warning
and continue as if nothing happened.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
John, this patch was send as part of the rt2x00 2.1.4 release for the 2.6.26 kernel.
Kernel bug [9585] however indicates this patch is also needed for 2.6.25 to fix
a segmentation fault during resume.

Due to the presence of LED classes in rt2x00 2.1.*,
the original patch won't apply cleanly against the 2.6.25 tree,
so this is an updated patch for 2.6.25 only.

diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 05927b9..6c72542 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -620,6 +620,9 @@ struct rt2x00_dev {
 	 * This will only be compiled in when required.
 	 */
 #ifdef CONFIG_RT2X00_LIB_RFKILL
+unsigned long rfkill_state;
+#define RFKILL_STATE_ALLOCATED		1
+#define RFKILL_STATE_REGISTERED		2
 	struct rfkill *rfkill;
 	struct input_polled_dev *poll_dev;
 #endif /* CONFIG_RT2X00_LIB_RFKILL */
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 0d51f47..bc846ba 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -1098,7 +1098,7 @@ static void rt2x00lib_uninitialize(struct rt2x00_dev *rt2x00dev)
 		return;
 
 	/*
-	 * Unregister rfkill.
+	 * Unregister extra components.
 	 */
 	rt2x00rfkill_unregister(rt2x00dev);
 
@@ -1139,11 +1139,9 @@ static int rt2x00lib_initialize(struct rt2x00_dev *rt2x00dev)
 	__set_bit(DEVICE_INITIALIZED, &rt2x00dev->flags);
 
 	/*
-	 * Register the rfkill handler.
+	 * Register the extra components.
 	 */
-	status = rt2x00rfkill_register(rt2x00dev);
-	if (status)
-		goto exit_unitialize;
+	rt2x00rfkill_register(rt2x00dev);
 
 	return 0;
 
@@ -1313,15 +1311,9 @@ int rt2x00lib_probe_dev(struct rt2x00_dev *rt2x00dev)
 	}
 
 	/*
-	 * Allocatie rfkill.
-	 */
-	retval = rt2x00rfkill_allocate(rt2x00dev);
-	if (retval)
-		goto exit;
-
-	/*
-	 * Open the debugfs entry.
+	 * Register extra components.
 	 */
+	rt2x00rfkill_allocate(rt2x00dev);
 	rt2x00debug_register(rt2x00dev);
 
 	__set_bit(DEVICE_PRESENT, &rt2x00dev->flags);
@@ -1350,13 +1342,9 @@ void rt2x00lib_remove_dev(struct rt2x00_dev *rt2x00dev)
 	rt2x00lib_uninitialize(rt2x00dev);
 
 	/*
-	 * Close debugfs entry.
+	 * Free extra components
 	 */
 	rt2x00debug_deregister(rt2x00dev);
-
-	/*
-	 * Free rfkill
-	 */
 	rt2x00rfkill_free(rt2x00dev);
 
 	/*
@@ -1395,11 +1383,15 @@ int rt2x00lib_suspend(struct rt2x00_dev *rt2x00dev, pm_message_t state)
 	__set_bit(DEVICE_STARTED_SUSPEND, &rt2x00dev->flags);
 
 	/*
-	 * Disable radio and unitialize all items
-	 * that must be recreated on resume.
+	 * Disable radio.
 	 */
 	rt2x00lib_stop(rt2x00dev);
 	rt2x00lib_uninitialize(rt2x00dev);
+
+	/*
+	 * Suspend/disable extra components.
+	 */
+	rt2x00rfkill_suspend(rt2x00dev);
 	rt2x00debug_deregister(rt2x00dev);
 
 exit:
@@ -1422,9 +1414,10 @@ int rt2x00lib_resume(struct rt2x00_dev *rt2x00dev)
 	NOTICE(rt2x00dev, "Waking up.\n");
 
 	/*
-	 * Open the debugfs entry.
+	 * Restore/enable extra components.
 	 */
 	rt2x00debug_register(rt2x00dev);
+	rt2x00rfkill_resume(rt2x00dev);
 
 	/*
 	 * Only continue if mac80211 had open interfaces.
diff --git a/drivers/net/wireless/rt2x00/rt2x00lib.h b/drivers/net/wireless/rt2x00/rt2x00lib.h
index 1adbd28..ce58c65 100644
--- a/drivers/net/wireless/rt2x00/rt2x00lib.h
+++ b/drivers/net/wireless/rt2x00/rt2x00lib.h
@@ -100,28 +100,36 @@ static inline void rt2x00debug_dump_frame(struct rt2x00_dev *rt2x00dev,
  * RFkill handlers.
  */
 #ifdef CONFIG_RT2X00_LIB_RFKILL
-int rt2x00rfkill_register(struct rt2x00_dev *rt2x00dev);
+void rt2x00rfkill_register(struct rt2x00_dev *rt2x00dev);
 void rt2x00rfkill_unregister(struct rt2x00_dev *rt2x00dev);
-int rt2x00rfkill_allocate(struct rt2x00_dev *rt2x00dev);
+void rt2x00rfkill_allocate(struct rt2x00_dev *rt2x00dev);
 void rt2x00rfkill_free(struct rt2x00_dev *rt2x00dev);
+void rt2x00rfkill_suspend(struct rt2x00_dev *rt2x00dev);
+void rt2x00rfkill_resume(struct rt2x00_dev *rt2x00dev);
 #else
-static inline int rt2x00rfkill_register(struct rt2x00_dev *rt2x00dev)
+static inline void rt2x00rfkill_register(struct rt2x00_dev *rt2x00dev)
 {
-	return 0;
 }
 
 static inline void rt2x00rfkill_unregister(struct rt2x00_dev *rt2x00dev)
 {
 }
 
-static inline int rt2x00rfkill_allocate(struct rt2x00_dev *rt2x00dev)
+static inline void rt2x00rfkill_allocate(struct rt2x00_dev *rt2x00dev)
 {
-	return 0;
 }
 
 static inline void rt2x00rfkill_free(struct rt2x00_dev *rt2x00dev)
 {
 }
+
+static inline void rt2x00rfkill_suspend(struct rt2x00_dev *rt2x00dev)
+{
+}
+
+static inline void rt2x00rfkill_resume(struct rt2x00_dev *rt2x00dev)
+{
+}
 #endif /* CONFIG_RT2X00_LIB_RFKILL */
 
 #endif /* RT2X00LIB_H */
diff --git a/drivers/net/wireless/rt2x00/rt2x00rfkill.c b/drivers/net/wireless/rt2x00/rt2x00rfkill.c
index 34a96d4..f955775 100644
--- a/drivers/net/wireless/rt2x00/rt2x00rfkill.c
+++ b/drivers/net/wireless/rt2x00/rt2x00rfkill.c
@@ -69,56 +69,81 @@ static void rt2x00rfkill_poll(struct input_polled_dev *poll_dev)
 	}
 }
 
-int rt2x00rfkill_register(struct rt2x00_dev *rt2x00dev)
+void rt2x00rfkill_register(struct rt2x00_dev *rt2x00dev)
 {
-	int retval;
-
-	if (!test_bit(CONFIG_SUPPORT_HW_BUTTON, &rt2x00dev->flags))
-		return 0;
+	if (!test_bit(CONFIG_SUPPORT_HW_BUTTON, &rt2x00dev->flags) ||
+	    !test_bit(RFKILL_STATE_ALLOCATED, &rt2x00dev->rfkill_state))
+		return;
 
-	retval = rfkill_register(rt2x00dev->rfkill);
-	if (retval) {
+	if (rfkill_register(rt2x00dev->rfkill)) {
 		ERROR(rt2x00dev, "Failed to register rfkill handler.\n");
-		return retval;
+		return;
 	}
 
-	retval = input_register_polled_device(rt2x00dev->poll_dev);
-	if (retval) {
+	if (input_register_polled_device(rt2x00dev->poll_dev)) {
 		ERROR(rt2x00dev, "Failed to register polled device.\n");
 		rfkill_unregister(rt2x00dev->rfkill);
-		return retval;
+		return;
 	}
 
+	__set_bit(RFKILL_STATE_REGISTERED, &rt2x00dev->rfkill_state);
+
 	/*
 	 * Force initial poll which will detect the initial device state,
 	 * and correctly sends the signal to the rfkill layer about this
 	 * state.
 	 */
 	rt2x00rfkill_poll(rt2x00dev->poll_dev);
-
-	return 0;
 }
 
 void rt2x00rfkill_unregister(struct rt2x00_dev *rt2x00dev)
 {
-	if (!test_bit(CONFIG_SUPPORT_HW_BUTTON, &rt2x00dev->flags))
+	if (!test_bit(CONFIG_SUPPORT_HW_BUTTON, &rt2x00dev->flags) ||
+	    !test_bit(RFKILL_STATE_REGISTERED, &rt2x00dev->rfkill_state))
 		return;
 
 	input_unregister_polled_device(rt2x00dev->poll_dev);
 	rfkill_unregister(rt2x00dev->rfkill);
+
+	__clear_bit(RFKILL_STATE_REGISTERED, &rt2x00dev->rfkill_state);
 }
 
-int rt2x00rfkill_allocate(struct rt2x00_dev *rt2x00dev)
+static struct input_polled_dev *
+rt2x00rfkill_allocate_polldev(struct rt2x00_dev *rt2x00dev)
 {
-	struct device *device = wiphy_dev(rt2x00dev->hw->wiphy);
+	struct input_polled_dev *poll_dev;
+
+	poll_dev = input_allocate_polled_device();
+	if (!poll_dev)
+		return NULL;
+
+	poll_dev->private = rt2x00dev;
+	poll_dev->poll = rt2x00rfkill_poll;
+	poll_dev->poll_interval = RFKILL_POLL_INTERVAL;
+
+	poll_dev->input->name = rt2x00dev->ops->name;
+	poll_dev->input->phys = wiphy_name(rt2x00dev->hw->wiphy);
+	poll_dev->input->id.bustype = BUS_HOST;
+	poll_dev->input->id.vendor = 0x1814;
+	poll_dev->input->id.product = rt2x00dev->chip.rt;
+	poll_dev->input->id.version = rt2x00dev->chip.rev;
+	poll_dev->input->dev.parent = wiphy_dev(rt2x00dev->hw->wiphy);
+	poll_dev->input->evbit[0] = BIT(EV_KEY);
+	set_bit(KEY_WLAN, poll_dev->input->keybit);
+
+	return poll_dev;
+}
 
+void rt2x00rfkill_allocate(struct rt2x00_dev *rt2x00dev)
+{
 	if (!test_bit(CONFIG_SUPPORT_HW_BUTTON, &rt2x00dev->flags))
-		return 0;
+		return;
 
-	rt2x00dev->rfkill = rfkill_allocate(device, RFKILL_TYPE_WLAN);
+	rt2x00dev->rfkill =
+	    rfkill_allocate(wiphy_dev(rt2x00dev->hw->wiphy), RFKILL_TYPE_WLAN);
 	if (!rt2x00dev->rfkill) {
 		ERROR(rt2x00dev, "Failed to allocate rfkill handler.\n");
-		goto exit;
+		return;
 	}
 
 	rt2x00dev->rfkill->name = rt2x00dev->ops->name;
@@ -126,40 +151,49 @@ int rt2x00rfkill_allocate(struct rt2x00_dev *rt2x00dev)
 	rt2x00dev->rfkill->state = -1;
 	rt2x00dev->rfkill->toggle_radio = rt2x00rfkill_toggle_radio;
 
-	rt2x00dev->poll_dev = input_allocate_polled_device();
+	rt2x00dev->poll_dev = rt2x00rfkill_allocate_polldev(rt2x00dev);
 	if (!rt2x00dev->poll_dev) {
 		ERROR(rt2x00dev, "Failed to allocate polled device.\n");
-		goto exit_free_rfkill;
+		rfkill_free(rt2x00dev->rfkill);
+		rt2x00dev->rfkill = NULL;
+		return;
 	}
 
-	rt2x00dev->poll_dev->private = rt2x00dev;
-	rt2x00dev->poll_dev->poll = rt2x00rfkill_poll;
-	rt2x00dev->poll_dev->poll_interval = RFKILL_POLL_INTERVAL;
+	return;
+}
 
-	rt2x00dev->poll_dev->input->name = rt2x00dev->ops->name;
-	rt2x00dev->poll_dev->input->phys = wiphy_name(rt2x00dev->hw->wiphy);
-	rt2x00dev->poll_dev->input->id.bustype = BUS_HOST;
-	rt2x00dev->poll_dev->input->id.vendor = 0x1814;
-	rt2x00dev->poll_dev->input->id.product = rt2x00dev->chip.rt;
-	rt2x00dev->poll_dev->input->id.version = rt2x00dev->chip.rev;
-	rt2x00dev->poll_dev->input->dev.parent = device;
-	rt2x00dev->poll_dev->input->evbit[0] = BIT(EV_KEY);
-	set_bit(KEY_WLAN, rt2x00dev->poll_dev->input->keybit);
+void rt2x00rfkill_free(struct rt2x00_dev *rt2x00dev)
+{
+	if (!test_bit(CONFIG_SUPPORT_HW_BUTTON, &rt2x00dev->flags) ||
+	    !test_bit(RFKILL_STATE_ALLOCATED, &rt2x00dev->rfkill_state))
+		return;
 
-	return 0;
+	input_free_polled_device(rt2x00dev->poll_dev);
+	rt2x00dev->poll_dev = NULL;
 
-exit_free_rfkill:
 	rfkill_free(rt2x00dev->rfkill);
-
-exit:
-	return -ENOMEM;
+	rt2x00dev->rfkill = NULL;
 }
 
-void rt2x00rfkill_free(struct rt2x00_dev *rt2x00dev)
+void rt2x00rfkill_suspend(struct rt2x00_dev *rt2x00dev)
 {
-	if (!test_bit(CONFIG_SUPPORT_HW_BUTTON, &rt2x00dev->flags))
+	if (!test_bit(CONFIG_SUPPORT_HW_BUTTON, &rt2x00dev->flags) ||
+	    !test_bit(RFKILL_STATE_ALLOCATED, &rt2x00dev->rfkill_state))
 		return;
 
 	input_free_polled_device(rt2x00dev->poll_dev);
-	rfkill_free(rt2x00dev->rfkill);
+	rt2x00dev->poll_dev = NULL;
+}
+
+void rt2x00rfkill_resume(struct rt2x00_dev *rt2x00dev)
+{
+	if (!test_bit(CONFIG_SUPPORT_HW_BUTTON, &rt2x00dev->flags) ||
+	    !test_bit(RFKILL_STATE_ALLOCATED, &rt2x00dev->rfkill_state))
+		return;
+
+	rt2x00dev->poll_dev = rt2x00rfkill_allocate_polldev(rt2x00dev);
+	if (!rt2x00dev->poll_dev) {
+		ERROR(rt2x00dev, "Failed to allocate polled device.\n");
+		return;
+	}
 }
