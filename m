Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ik-out-1112.google.com ([66.249.90.181]:54472 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651AbZACS4X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 Jan 2009 13:56:23 -0500
Received: by ik-out-1112.google.com with SMTP id c29so1419663ika.5
        for <linux-wireless@vger.kernel.org>; Sat, 03 Jan 2009 10:56:19 -0800 (PST)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] rt2x00: Replace RFKILL with INPUT
Date: Sat, 3 Jan 2009 19:56:02 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net,
	"Seif Mazareeb" <seif.mazareeb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200901031956.03065.IvDoorn@gmail.com> (sfid-20090103_195628_326701_F347A7C9)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As discussed on linux-wireless rt2x00 does not offer a true RFKILL key,
for that reason RFKILL support should be entirely removed.

The key which is attached to the hardware should be treated as normal
input device instead. Implement input_poll_dev support to poll the device
frequently. When the key status has changed report it as a SW event.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
diff --git a/drivers/net/wireless/rt2x00/Kconfig b/drivers/net/wireless/rt2x00/Kconfig
index 923d3d4..48acfae 100644
--- a/drivers/net/wireless/rt2x00/Kconfig
+++ b/drivers/net/wireless/rt2x00/Kconfig
@@ -129,10 +129,11 @@ config RT2X00_LIB_CRYPTO
 
 config RT2X00_LIB_RFKILL
 	boolean
-	default y if (RT2X00_LIB=y && RFKILL=y) || (RT2X00_LIB=m && RFKILL!=n)
+	default y if (RT2X00_LIB=y && INPUT=y) || (RT2X00_LIB=m && INPUT!=n)
+	select INPUT_POLLDEV
 
-comment "rt2x00 rfkill support disabled due to modularized RFKILL and built-in rt2x00"
-	depends on RT2X00_LIB=y && RFKILL=m
+comment "rt2x00 rfkill support disabled due to modularized INPUT and built-in rt2x00"
+	depends on RT2X00_LIB=y && INPUT=m
 
 config RT2X00_LIB_LEDS
 	boolean
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 60a0e9e..55d217b 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -33,6 +33,7 @@
 #include <linux/leds.h>
 #include <linux/mutex.h>
 #include <linux/etherdevice.h>
+#include <linux/input-polldev.h>
 
 #include <net/mac80211.h>
 
@@ -648,8 +649,8 @@ struct rt2x00_dev {
 	unsigned long rfkill_state;
 #define RFKILL_STATE_ALLOCATED		1
 #define RFKILL_STATE_REGISTERED		2
-	struct rfkill *rfkill;
-	struct delayed_work rfkill_work;
+#define RFKILL_STATE_BLOCKED		3
+	struct input_polled_dev *rfkill_poll_dev;
 #endif /* CONFIG_RT2X00_LIB_RFKILL */
 
 	/*
diff --git a/drivers/net/wireless/rt2x00/rt2x00lib.h b/drivers/net/wireless/rt2x00/rt2x00lib.h
index dd5c521..e6a8db2 100644
--- a/drivers/net/wireless/rt2x00/rt2x00lib.h
+++ b/drivers/net/wireless/rt2x00/rt2x00lib.h
@@ -33,7 +33,7 @@
  * Both the link tuner as the rfkill will be called once per second.
  */
 #define LINK_TUNE_INTERVAL	( round_jiffies_relative(HZ) )
-#define RFKILL_POLL_INTERVAL	( round_jiffies_relative(HZ) )
+#define RFKILL_POLL_INTERVAL	( 1000 )
 
 /*
  * rt2x00_rate: Per rate device information
diff --git a/drivers/net/wireless/rt2x00/rt2x00rfkill.c b/drivers/net/wireless/rt2x00/rt2x00rfkill.c
index c3f53a9..5024e3d 100644
--- a/drivers/net/wireless/rt2x00/rt2x00rfkill.c
+++ b/drivers/net/wireless/rt2x00/rt2x00rfkill.c
@@ -25,73 +25,30 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/rfkill.h>
 
 #include "rt2x00.h"
 #include "rt2x00lib.h"
 
-static int rt2x00rfkill_toggle_radio(void *data, enum rfkill_state state)
+static void rt2x00rfkill_poll(struct input_polled_dev *poll_dev)
 {
-	struct rt2x00_dev *rt2x00dev = data;
-	int retval = 0;
-
-	if (unlikely(!rt2x00dev))
-		return 0;
-
-	/*
-	 * Only continue if there are enabled interfaces.
-	 */
-	if (!test_bit(DEVICE_STATE_STARTED, &rt2x00dev->flags))
-		return 0;
-
-	if (state == RFKILL_STATE_UNBLOCKED) {
-		INFO(rt2x00dev, "RFKILL event: enabling radio.\n");
-		clear_bit(DEVICE_STATE_DISABLED_RADIO_HW, &rt2x00dev->flags);
-		retval = rt2x00lib_enable_radio(rt2x00dev);
-	} else if (state == RFKILL_STATE_SOFT_BLOCKED) {
-		INFO(rt2x00dev, "RFKILL event: disabling radio.\n");
-		set_bit(DEVICE_STATE_DISABLED_RADIO_HW, &rt2x00dev->flags);
-		rt2x00lib_disable_radio(rt2x00dev);
-	} else {
-		WARNING(rt2x00dev, "RFKILL event: unknown state %d.\n", state);
-	}
-
-	return retval;
-}
-
-static int rt2x00rfkill_get_state(void *data, enum rfkill_state *state)
-{
-	struct rt2x00_dev *rt2x00dev = data;
-
-	/*
-	 * rfkill_poll reports 1 when the key has been pressed and the
-	 * radio should be blocked.
-	 */
-	*state = rt2x00dev->ops->lib->rfkill_poll(rt2x00dev) ?
-	    RFKILL_STATE_SOFT_BLOCKED : RFKILL_STATE_UNBLOCKED;
-
-	return 0;
-}
-
-static void rt2x00rfkill_poll(struct work_struct *work)
-{
-	struct rt2x00_dev *rt2x00dev =
-	    container_of(work, struct rt2x00_dev, rfkill_work.work);
-	enum rfkill_state state;
+	struct rt2x00_dev *rt2x00dev = poll_dev->private;
+	int state, old_state;
 
 	if (!test_bit(RFKILL_STATE_REGISTERED, &rt2x00dev->rfkill_state) ||
 	    !test_bit(CONFIG_SUPPORT_HW_BUTTON, &rt2x00dev->flags))
 		return;
 
 	/*
-	 * Poll latest state and report it to rfkill who should sort
-	 * out if the state should be toggled or not.
+	 * Poll latest state, if the state is different then the previous state,
+	 * we should generate an input event.
 	 */
-	if (!rt2x00rfkill_get_state(rt2x00dev, &state))
-		rfkill_force_state(rt2x00dev->rfkill, state);
+	state = !!rt2x00dev->ops->lib->rfkill_poll(rt2x00dev);
+	old_state = !!test_bit(RFKILL_STATE_BLOCKED, &rt2x00dev->rfkill_state);
 
-	queue_delayed_work(rt2x00dev->hw->workqueue,
-			   &rt2x00dev->rfkill_work, RFKILL_POLL_INTERVAL);
+	if (old_state != state) {
+		input_report_switch(poll_dev->input, SW_RFKILL_ALL, state);
+		change_bit(RFKILL_STATE_BLOCKED, &rt2x00dev->rfkill_state);
+	}
 }
 
 void rt2x00rfkill_register(struct rt2x00_dev *rt2x00dev)
@@ -100,8 +57,8 @@ void rt2x00rfkill_register(struct rt2x00_dev *rt2x00dev)
 	    test_bit(RFKILL_STATE_REGISTERED, &rt2x00dev->rfkill_state))
 		return;
 
-	if (rfkill_register(rt2x00dev->rfkill)) {
-		ERROR(rt2x00dev, "Failed to register rfkill handler.\n");
+	if (input_register_polled_device(rt2x00dev->rfkill_poll_dev)) {
+		ERROR(rt2x00dev, "Failed to register polled device.\n");
 		return;
 	}
 
@@ -109,10 +66,10 @@ void rt2x00rfkill_register(struct rt2x00_dev *rt2x00dev)
 
 	/*
 	 * Force initial poll which will detect the initial device state,
-	 * and correctly sends the signal to the rfkill layer about this
+	 * and correctly sends the signal to the input layer about this
 	 * state.
 	 */
-	rt2x00rfkill_poll(&rt2x00dev->rfkill_work.work);
+	rt2x00rfkill_poll(rt2x00dev->rfkill_poll_dev);
 }
 
 void rt2x00rfkill_unregister(struct rt2x00_dev *rt2x00dev)
@@ -121,52 +78,48 @@ void rt2x00rfkill_unregister(struct rt2x00_dev *rt2x00dev)
 	    !test_bit(RFKILL_STATE_REGISTERED, &rt2x00dev->rfkill_state))
 		return;
 
-	cancel_delayed_work_sync(&rt2x00dev->rfkill_work);
-
-	rfkill_unregister(rt2x00dev->rfkill);
+	input_unregister_polled_device(rt2x00dev->rfkill_poll_dev);
 
 	__clear_bit(RFKILL_STATE_REGISTERED, &rt2x00dev->rfkill_state);
 }
 
 void rt2x00rfkill_allocate(struct rt2x00_dev *rt2x00dev)
 {
-	struct device *dev = wiphy_dev(rt2x00dev->hw->wiphy);
+	struct input_polled_dev *poll_dev;
 
 	if (test_bit(RFKILL_STATE_ALLOCATED, &rt2x00dev->rfkill_state))
 		return;
 
-	rt2x00dev->rfkill = rfkill_allocate(dev, RFKILL_TYPE_WLAN);
-	if (!rt2x00dev->rfkill) {
-		ERROR(rt2x00dev, "Failed to allocate rfkill handler.\n");
+	poll_dev = input_allocate_polled_device();
+	if (!poll_dev) {
+		ERROR(rt2x00dev, "Failed to allocate polled device.\n");
 		return;
 	}
 
-	__set_bit(RFKILL_STATE_ALLOCATED, &rt2x00dev->rfkill_state);
+	poll_dev->private = rt2x00dev;
+	poll_dev->poll = rt2x00rfkill_poll;
+	poll_dev->poll_interval = RFKILL_POLL_INTERVAL;
 
-	rt2x00dev->rfkill->name = rt2x00dev->ops->name;
-	rt2x00dev->rfkill->data = rt2x00dev;
-	rt2x00dev->rfkill->toggle_radio = rt2x00rfkill_toggle_radio;
-	if (test_bit(CONFIG_SUPPORT_HW_BUTTON, &rt2x00dev->flags)) {
-		rt2x00dev->rfkill->get_state = rt2x00rfkill_get_state;
-		rt2x00dev->rfkill->state =
-			rt2x00dev->ops->lib->rfkill_poll(rt2x00dev) ?
-			    RFKILL_STATE_SOFT_BLOCKED : RFKILL_STATE_UNBLOCKED;
-	} else {
-		rt2x00dev->rfkill->state = RFKILL_STATE_UNBLOCKED;
-	}
+	poll_dev->input->name = rt2x00dev->ops->name;
+	poll_dev->input->phys = wiphy_name(rt2x00dev->hw->wiphy);
+	poll_dev->input->id.bustype = BUS_HOST;
+	poll_dev->input->id.vendor = 0x1814;
+	poll_dev->input->id.product = rt2x00dev->chip.rt;
+	poll_dev->input->id.version = rt2x00dev->chip.rev;
+	poll_dev->input->dev.parent = wiphy_dev(rt2x00dev->hw->wiphy);
+	poll_dev->input->evbit[0] = BIT(EV_SW);
+	poll_dev->input->swbit[0] = BIT(SW_RFKILL_ALL);
 
-	INIT_DELAYED_WORK(&rt2x00dev->rfkill_work, rt2x00rfkill_poll);
+	rt2x00dev->rfkill_poll_dev = poll_dev;
 
-	return;
+	__set_bit(RFKILL_STATE_ALLOCATED, &rt2x00dev->rfkill_state);
 }
 
 void rt2x00rfkill_free(struct rt2x00_dev *rt2x00dev)
 {
-	if (!test_bit(RFKILL_STATE_ALLOCATED, &rt2x00dev->flags))
+	if (!__test_and_clear_bit(RFKILL_STATE_ALLOCATED, &rt2x00dev->flags))
 		return;
 
-	cancel_delayed_work_sync(&rt2x00dev->rfkill_work);
-
-	rfkill_free(rt2x00dev->rfkill);
-	rt2x00dev->rfkill = NULL;
+	input_free_polled_device(rt2x00dev->rfkill_poll_dev);
+	rt2x00dev->rfkill_poll_dev = NULL;
 }
