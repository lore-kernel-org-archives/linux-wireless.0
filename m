Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:53844 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753690AbYCIVvS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Mar 2008 17:51:18 -0400
Received: by fg-out-1718.google.com with SMTP id e21so1676623fga.17
        for <linux-wireless@vger.kernel.org>; Sun, 09 Mar 2008 14:51:17 -0700 (PDT)
To: "John W. Linville" <linville@redhat.com>
Subject: [PATCH 17/24] rt2x00: Add suspend/resume handlers to rt2x00rfkill
Date: Sun, 9 Mar 2008 22:46:45 +0100
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	rt2400-devel@lists.sourceforge.net
References: <200803092237.43451.IvDoorn@gmail.com>
In-Reply-To: <200803092237.43451.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200803092246.45852.IvDoorn@gmail.com> (sfid-20080309_215501_468778_A9B97E0E)
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
 drivers/net/wireless/rt2x00/rt2x00.h       |    4 +
 drivers/net/wireless/rt2x00/rt2x00dev.c    |   43 ++++-------
 drivers/net/wireless/rt2x00/rt2x00lib.h    |   15 ++--
 drivers/net/wireless/rt2x00/rt2x00rfkill.c |  116 ++++++++++++++++++----------
 4 files changed, 102 insertions(+), 76 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index a324ff3..d71b3c4 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -671,6 +671,10 @@ struct rt2x00_dev {
 	 * This will only be compiled in when required.
 	 */
 #ifdef CONFIG_RT2X00_LIB_RFKILL
+	unsigned long rfkill_state;
+#define RFKILL_STATE_ALLOCATED		1
+#define RFKILL_STATE_REGISTERED		2
+
 	struct rfkill *rfkill;
 	struct input_polled_dev *poll_dev;
 #endif /* CONFIG_RT2X00_LIB_RFKILL */
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index d6b1278..eeb39e8 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -999,7 +999,7 @@ static void rt2x00lib_uninitialize(struct rt2x00_dev *rt2x00dev)
 		return;
 
 	/*
-	 * Unregister rfkill.
+	 * Unregister extra components.
 	 */
 	rt2x00rfkill_unregister(rt2x00dev);
 
@@ -1038,11 +1038,9 @@ static int rt2x00lib_initialize(struct rt2x00_dev *rt2x00dev)
 	__set_bit(DEVICE_INITIALIZED, &rt2x00dev->flags);
 
 	/*
-	 * Register the rfkill handler.
+	 * Register the extra components.
 	 */
-	status = rt2x00rfkill_register(rt2x00dev);
-	if (status)
-		goto exit;
+	rt2x00rfkill_register(rt2x00dev);
 
 	return 0;
 
@@ -1156,20 +1154,10 @@ int rt2x00lib_probe_dev(struct rt2x00_dev *rt2x00dev)
 	}
 
 	/*
-	 * Register LED.
+	 * Register extra components.
 	 */
 	rt2x00leds_register(rt2x00dev);
-
-	/*
-	 * Allocatie rfkill.
-	 */
-	retval = rt2x00rfkill_allocate(rt2x00dev);
-	if (retval)
-		goto exit;
-
-	/*
-	 * Open the debugfs entry.
-	 */
+	rt2x00rfkill_allocate(rt2x00dev);
 	rt2x00debug_register(rt2x00dev);
 
 	__set_bit(DEVICE_PRESENT, &rt2x00dev->flags);
@@ -1198,18 +1186,10 @@ void rt2x00lib_remove_dev(struct rt2x00_dev *rt2x00dev)
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
-
-	/*
-	 * Free LED.
-	 */
 	rt2x00leds_unregister(rt2x00dev);
 
 	/*
@@ -1248,12 +1228,16 @@ int rt2x00lib_suspend(struct rt2x00_dev *rt2x00dev, pm_message_t state)
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
 	rt2x00leds_suspend(rt2x00dev);
+	rt2x00rfkill_suspend(rt2x00dev);
 	rt2x00debug_deregister(rt2x00dev);
 
 exit:
@@ -1297,9 +1281,10 @@ int rt2x00lib_resume(struct rt2x00_dev *rt2x00dev)
 	NOTICE(rt2x00dev, "Waking up.\n");
 
 	/*
-	 * Open the debugfs entry and restore led handling.
+	 * Restore/enable extra components.
 	 */
 	rt2x00debug_register(rt2x00dev);
+	rt2x00rfkill_resume(rt2x00dev);
 	rt2x00leds_resume(rt2x00dev);
 
 	/*
diff --git a/drivers/net/wireless/rt2x00/rt2x00lib.h b/drivers/net/wireless/rt2x00/rt2x00lib.h
index 6bd5a01..b9d7e0e 100644
--- a/drivers/net/wireless/rt2x00/rt2x00lib.h
+++ b/drivers/net/wireless/rt2x00/rt2x00lib.h
@@ -160,28 +160,31 @@ static inline void rt2x00debug_dump_frame(struct rt2x00_dev *rt2x00dev,
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
+static inline void rt2x00rfkill_suspend(struct rt2x00_dev *rt2x00dev);
+static inline void rt2x00rfkill_resume(struct rt2x00_dev *rt2x00dev);
 #endif /* CONFIG_RT2X00_LIB_RFKILL */
 
 /*
diff --git a/drivers/net/wireless/rt2x00/rt2x00rfkill.c b/drivers/net/wireless/rt2x00/rt2x00rfkill.c
index 6712142..fcef988 100644
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
-- 
1.5.4.3

