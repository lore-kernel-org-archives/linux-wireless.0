Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.190]:17476 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753676AbYGDMpg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Jul 2008 08:45:36 -0400
Received: by nf-out-0910.google.com with SMTP id d3so364763nfc.21
        for <linux-wireless@vger.kernel.org>; Fri, 04 Jul 2008 05:45:35 -0700 (PDT)
To: linville@tuxdriver.com
Subject: [PATCH 1/4 v2] rt2x00: Remove input_polldev requirements for rfkill
Date: Fri, 4 Jul 2008 14:51:39 +0200
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	rt2400-devel@lists.sourceforge.net
References: <200807041341.26003.IvDoorn@gmail.com>
In-Reply-To: <200807041341.26003.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200807041451.39442.IvDoorn@gmail.com> (sfid-20080704_144549_752450_FE125C43)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rt2x00: Remove input_polldev requirements for rfkill

With the new rfkill interface there is no longer a need
for the input_polldev. Create a delayed_work structure
which we can put on the mac80211 workqueue and poll the
hardware every 1000ms.

v2: Decrease poll frequency from 100ms to 1000ms

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
diff --git a/drivers/net/wireless/rt2x00/Kconfig b/drivers/net/wireless/rt2x00/Kconfig
index 3a9b1d7..d485a86 100644
--- a/drivers/net/wireless/rt2x00/Kconfig
+++ b/drivers/net/wireless/rt2x00/Kconfig
@@ -36,9 +36,7 @@ config RT2X00_LIB_FIRMWARE
 config RT2X00_LIB_RFKILL
 	boolean
 	depends on RT2X00_LIB
-	depends on INPUT
 	select RFKILL
-	select INPUT_POLLDEV
 
 config RT2X00_LIB_LEDS
 	boolean
@@ -57,7 +55,7 @@ config RT2400PCI
 
 config RT2400PCI_RFKILL
 	bool "Ralink rt2400 rfkill support"
-	depends on RT2400PCI && INPUT
+	depends on RT2400PCI
 	select RT2X00_LIB_RFKILL
 	---help---
 	  This adds support for integrated rt2400 hardware that features a
@@ -85,7 +83,7 @@ config RT2500PCI
 
 config RT2500PCI_RFKILL
 	bool "Ralink rt2500 rfkill support"
-	depends on RT2500PCI && INPUT
+	depends on RT2500PCI
 	select RT2X00_LIB_RFKILL
 	---help---
 	  This adds support for integrated rt2500 hardware that features a
@@ -115,7 +113,7 @@ config RT61PCI
 
 config RT61PCI_RFKILL
 	bool "Ralink rt2501/rt61 rfkill support"
-	depends on RT61PCI && INPUT
+	depends on RT61PCI
 	select RT2X00_LIB_RFKILL
 	---help---
 	  This adds support for integrated rt61 hardware that features a
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 6842464..1b28dad 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -649,7 +649,7 @@ struct rt2x00_dev {
 #define RFKILL_STATE_ALLOCATED		1
 #define RFKILL_STATE_REGISTERED		2
 	struct rfkill *rfkill;
-	struct input_polled_dev *poll_dev;
+	struct delayed_work rfkill_work;
 #endif /* CONFIG_RT2X00_LIB_RFKILL */
 
 	/*
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index ae8ab71..41b3289 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -1179,7 +1179,6 @@ int rt2x00lib_suspend(struct rt2x00_dev *rt2x00dev, pm_message_t state)
 	 * Suspend/disable extra components.
 	 */
 	rt2x00leds_suspend(rt2x00dev);
-	rt2x00rfkill_suspend(rt2x00dev);
 	rt2x00debug_deregister(rt2x00dev);
 
 exit:
@@ -1235,7 +1234,6 @@ int rt2x00lib_resume(struct rt2x00_dev *rt2x00dev)
 	 * Restore/enable extra components.
 	 */
 	rt2x00debug_register(rt2x00dev);
-	rt2x00rfkill_resume(rt2x00dev);
 	rt2x00leds_resume(rt2x00dev);
 
 	/*
diff --git a/drivers/net/wireless/rt2x00/rt2x00lib.h b/drivers/net/wireless/rt2x00/rt2x00lib.h
index 1d1f074..eae5ce1 100644
--- a/drivers/net/wireless/rt2x00/rt2x00lib.h
+++ b/drivers/net/wireless/rt2x00/rt2x00lib.h
@@ -33,7 +33,7 @@
  * Both the link tuner as the rfkill will be called once per second.
  */
 #define LINK_TUNE_INTERVAL	( round_jiffies_relative(HZ) )
-#define RFKILL_POLL_INTERVAL	( 1000 )
+#define RFKILL_POLL_INTERVAL	( round_jiffies_relative(HZ) )
 
 /*
  * rt2x00_rate: Per rate device information
@@ -204,8 +204,6 @@ void rt2x00rfkill_register(struct rt2x00_dev *rt2x00dev);
 void rt2x00rfkill_unregister(struct rt2x00_dev *rt2x00dev);
 void rt2x00rfkill_allocate(struct rt2x00_dev *rt2x00dev);
 void rt2x00rfkill_free(struct rt2x00_dev *rt2x00dev);
-void rt2x00rfkill_suspend(struct rt2x00_dev *rt2x00dev);
-void rt2x00rfkill_resume(struct rt2x00_dev *rt2x00dev);
 #else
 static inline void rt2x00rfkill_register(struct rt2x00_dev *rt2x00dev)
 {
@@ -222,14 +220,6 @@ static inline void rt2x00rfkill_allocate(struct rt2x00_dev *rt2x00dev)
 static inline void rt2x00rfkill_free(struct rt2x00_dev *rt2x00dev)
 {
 }
-
-static inline void rt2x00rfkill_suspend(struct rt2x00_dev *rt2x00dev)
-{
-}
-
-static inline void rt2x00rfkill_resume(struct rt2x00_dev *rt2x00dev)
-{
-}
 #endif /* CONFIG_RT2X00_LIB_RFKILL */
 
 /*
diff --git a/drivers/net/wireless/rt2x00/rt2x00rfkill.c b/drivers/net/wireless/rt2x00/rt2x00rfkill.c
index 207281c..04b2971 100644
--- a/drivers/net/wireless/rt2x00/rt2x00rfkill.c
+++ b/drivers/net/wireless/rt2x00/rt2x00rfkill.c
@@ -23,7 +23,6 @@
 	Abstract: rt2x00 rfkill routines.
  */
 
-#include <linux/input-polldev.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/rfkill.h>
@@ -61,15 +60,35 @@ static int rt2x00rfkill_toggle_radio(void *data, enum rfkill_state state)
 	return retval;
 }
 
-static void rt2x00rfkill_poll(struct input_polled_dev *poll_dev)
+static int rt2x00rfkill_get_state(void *data, enum rfkill_state *state)
 {
-	struct rt2x00_dev *rt2x00dev = poll_dev->private;
-	int state = rt2x00dev->ops->lib->rfkill_poll(rt2x00dev);
+	struct rt2x00_dev *rt2x00dev = data;
 
-	if (rt2x00dev->rfkill->state != state) {
-		input_report_key(poll_dev->input, KEY_WLAN, 1);
-		input_report_key(poll_dev->input, KEY_WLAN, 0);
-	}
+	*state = rt2x00dev->rfkill->state;
+
+	return 0;
+}
+
+static void rt2x00rfkill_poll(struct work_struct *work)
+{
+	struct rt2x00_dev *rt2x00dev =
+	    container_of(work, struct rt2x00_dev, rfkill_work.work);
+	int state;
+
+	if (!test_bit(RFKILL_STATE_REGISTERED, &rt2x00dev->rfkill_state))
+		return;
+
+	/*
+	 * rfkill_poll reports 1 when the key has been pressed and the
+	 * radio should be blocked.
+	 */
+	state = !rt2x00dev->ops->lib->rfkill_poll(rt2x00dev) ?
+	    RFKILL_STATE_UNBLOCKED : RFKILL_STATE_SOFT_BLOCKED;
+
+	rfkill_force_state(rt2x00dev->rfkill, state);
+
+	queue_delayed_work(rt2x00dev->hw->workqueue,
+			   &rt2x00dev->rfkill_work, RFKILL_POLL_INTERVAL);
 }
 
 void rt2x00rfkill_register(struct rt2x00_dev *rt2x00dev)
@@ -83,12 +102,6 @@ void rt2x00rfkill_register(struct rt2x00_dev *rt2x00dev)
 		return;
 	}
 
-	if (input_register_polled_device(rt2x00dev->poll_dev)) {
-		ERROR(rt2x00dev, "Failed to register polled device.\n");
-		rfkill_unregister(rt2x00dev->rfkill);
-		return;
-	}
-
 	__set_bit(RFKILL_STATE_REGISTERED, &rt2x00dev->rfkill_state);
 
 	/*
@@ -96,7 +109,7 @@ void rt2x00rfkill_register(struct rt2x00_dev *rt2x00dev)
 	 * and correctly sends the signal to the rfkill layer about this
 	 * state.
 	 */
-	rt2x00rfkill_poll(rt2x00dev->poll_dev);
+	rt2x00rfkill_poll(&rt2x00dev->rfkill_work.work);
 }
 
 void rt2x00rfkill_unregister(struct rt2x00_dev *rt2x00dev)
@@ -105,38 +118,13 @@ void rt2x00rfkill_unregister(struct rt2x00_dev *rt2x00dev)
 	    !test_bit(RFKILL_STATE_REGISTERED, &rt2x00dev->rfkill_state))
 		return;
 
-	input_unregister_polled_device(rt2x00dev->poll_dev);
+	cancel_delayed_work_sync(&rt2x00dev->rfkill_work);
+
 	rfkill_unregister(rt2x00dev->rfkill);
 
 	__clear_bit(RFKILL_STATE_REGISTERED, &rt2x00dev->rfkill_state);
 }
 
-static struct input_polled_dev *
-rt2x00rfkill_allocate_polldev(struct rt2x00_dev *rt2x00dev)
-{
-	struct input_polled_dev *poll_dev;
-
-	poll_dev = input_allocate_polled_device();
-	if (!poll_dev)
-		return NULL;
-
-	poll_dev->private = rt2x00dev;
-	poll_dev->poll = rt2x00rfkill_poll;
-	poll_dev->poll_interval = RFKILL_POLL_INTERVAL;
-
-	poll_dev->input->name = rt2x00dev->ops->name;
-	poll_dev->input->phys = wiphy_name(rt2x00dev->hw->wiphy);
-	poll_dev->input->id.bustype = BUS_HOST;
-	poll_dev->input->id.vendor = 0x1814;
-	poll_dev->input->id.product = rt2x00dev->chip.rt;
-	poll_dev->input->id.version = rt2x00dev->chip.rev;
-	poll_dev->input->dev.parent = wiphy_dev(rt2x00dev->hw->wiphy);
-	poll_dev->input->evbit[0] = BIT(EV_KEY);
-	set_bit(KEY_WLAN, poll_dev->input->keybit);
-
-	return poll_dev;
-}
-
 void rt2x00rfkill_allocate(struct rt2x00_dev *rt2x00dev)
 {
 	if (!test_bit(CONFIG_SUPPORT_HW_BUTTON, &rt2x00dev->flags))
@@ -153,14 +141,9 @@ void rt2x00rfkill_allocate(struct rt2x00_dev *rt2x00dev)
 	rt2x00dev->rfkill->data = rt2x00dev;
 	rt2x00dev->rfkill->state = -1;
 	rt2x00dev->rfkill->toggle_radio = rt2x00rfkill_toggle_radio;
+	rt2x00dev->rfkill->get_state = rt2x00rfkill_get_state;
 
-	rt2x00dev->poll_dev = rt2x00rfkill_allocate_polldev(rt2x00dev);
-	if (!rt2x00dev->poll_dev) {
-		ERROR(rt2x00dev, "Failed to allocate polled device.\n");
-		rfkill_free(rt2x00dev->rfkill);
-		rt2x00dev->rfkill = NULL;
-		return;
-	}
+	INIT_DELAYED_WORK(&rt2x00dev->rfkill_work, rt2x00rfkill_poll);
 
 	return;
 }
@@ -171,32 +154,8 @@ void rt2x00rfkill_free(struct rt2x00_dev *rt2x00dev)
 	    !test_bit(RFKILL_STATE_ALLOCATED, &rt2x00dev->rfkill_state))
 		return;
 
-	input_free_polled_device(rt2x00dev->poll_dev);
-	rt2x00dev->poll_dev = NULL;
+	cancel_delayed_work_sync(&rt2x00dev->rfkill_work);
 
 	rfkill_free(rt2x00dev->rfkill);
 	rt2x00dev->rfkill = NULL;
 }
-
-void rt2x00rfkill_suspend(struct rt2x00_dev *rt2x00dev)
-{
-	if (!test_bit(CONFIG_SUPPORT_HW_BUTTON, &rt2x00dev->flags) ||
-	    !test_bit(RFKILL_STATE_ALLOCATED, &rt2x00dev->rfkill_state))
-		return;
-
-	input_free_polled_device(rt2x00dev->poll_dev);
-	rt2x00dev->poll_dev = NULL;
-}
-
-void rt2x00rfkill_resume(struct rt2x00_dev *rt2x00dev)
-{
-	if (!test_bit(CONFIG_SUPPORT_HW_BUTTON, &rt2x00dev->flags) ||
-	    !test_bit(RFKILL_STATE_ALLOCATED, &rt2x00dev->rfkill_state))
-		return;
-
-	rt2x00dev->poll_dev = rt2x00rfkill_allocate_polldev(rt2x00dev);
-	if (!rt2x00dev->poll_dev) {
-		ERROR(rt2x00dev, "Failed to allocate polled device.\n");
-		return;
-	}
-}
