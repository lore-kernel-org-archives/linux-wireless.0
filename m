Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:59064 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754671AbXJKDsT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Oct 2007 23:48:19 -0400
Date: Wed, 10 Oct 2007 22:48:17 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John Linville <linville@tuxdriver.com>
Cc: Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: [PATCH] b43legacy: Use input-polldev for the rfkill switch
Message-ID: <470d9d01.UuxzOJMBx/yAlBlD%Larry.Finger@lwfinger.net> (sfid-20071011_044821_831028_251ED741)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This removes the direct call to rfkill on an rfkill event
and replaces it with an input device. This way userspace is also
notified about the event.

This patch is the port to b43legacy of a patch for b43 by Michael Buesch
<mb@bu3sch.de>.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

As with the two previous LED-related patches, this is meant to be applied to
the everything branch of wireless-2.6.

Larry
---

 drivers/net/wireless/b43legacy/Kconfig  |    2
 drivers/net/wireless/b43legacy/main.c   |   49 ++---------
 drivers/net/wireless/b43legacy/rfkill.c |  135 +++++++++++++++++++-------------
 drivers/net/wireless/b43legacy/rfkill.h |   26 ++++--
 4 files changed, 109 insertions(+), 103 deletions(-)

Index: wireless-2.6/drivers/net/wireless/b43legacy/Kconfig
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43legacy/Kconfig
+++ wireless-2.6/drivers/net/wireless/b43legacy/Kconfig
@@ -43,7 +43,7 @@ config B43LEGACY_LEDS
 # RFKILL support
 config B43LEGACY_RFKILL
 	bool
-	depends on B43LEGACY && RFKILL
+	depends on B43LEGACY && RFKILL && RFKILL_INPUT && INPUT_POLLDEV
 	default y
 
 config B43LEGACY_DEBUG
Index: wireless-2.6/drivers/net/wireless/b43legacy/main.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43legacy/main.c
+++ wireless-2.6/drivers/net/wireless/b43legacy/main.c
@@ -1975,21 +1975,6 @@ static void b43legacy_mgmtframe_txantenn
 			      B43legacy_SHM_SH_PRPHYCTL, tmp);
 }
 
-/* Returns TRUE, if the radio is enabled in hardware. */
-static bool b43legacy_is_hw_radio_enabled(struct b43legacy_wldev *dev)
-{
-	if (dev->phy.rev >= 3) {
-		if (!(b43legacy_read32(dev, B43legacy_MMIO_RADIO_HWENABLED_HI)
-		      & B43legacy_MMIO_RADIO_HWENABLED_HI_MASK))
-			return 1;
-	} else {
-		if (b43legacy_read16(dev, B43legacy_MMIO_RADIO_HWENABLED_LO)
-		    & B43legacy_MMIO_RADIO_HWENABLED_LO_MASK)
-			return 1;
-	}
-	return 0;
-}
-
 /* This is the opposite of b43legacy_chip_init() */
 static void b43legacy_chip_exit(struct b43legacy_wldev *dev)
 {
@@ -2146,32 +2131,18 @@ static void b43legacy_periodic_every15se
 	b43legacy_phy_xmitpower(dev); /* FIXME: unless scanning? */
 }
 
-static void b43legacy_periodic_every1sec(struct b43legacy_wldev *dev)
-{
-	bool radio_hw_enable;
-
-	/* check if radio hardware enabled status changed */
-	radio_hw_enable = b43legacy_is_hw_radio_enabled(dev);
-	if (unlikely(dev->radio_hw_enable != radio_hw_enable)) {
-		dev->radio_hw_enable = radio_hw_enable;
-		b43legacy_rfkill_toggled(dev, radio_hw_enable);
-	}
-}
-
 static void do_periodic_work(struct b43legacy_wldev *dev)
 {
 	unsigned int state;
 
 	state = dev->periodic_state;
-	if (state % 120 == 0)
+	if (state % 8 == 0)
 		b43legacy_periodic_every120sec(dev);
-	if (state % 60 == 0)
+	if (state % 4 == 0)
 		b43legacy_periodic_every60sec(dev);
-	if (state % 30 == 0)
+	if (state % 2 == 0)
 		b43legacy_periodic_every30sec(dev);
-	if (state % 15 == 0)
-		b43legacy_periodic_every15sec(dev);
-	b43legacy_periodic_every1sec(dev);
+	b43legacy_periodic_every15sec(dev);
 }
 
 /* Estimate a "Badness" value based on the periodic work
@@ -2182,13 +2153,11 @@ static int estimate_periodic_work_badnes
 {
 	int badness = 0;
 
-	if (state % 120 == 0) /* every 120 sec */
+	if (state % 8 == 0)	/* every 120 sec */
 		badness += 10;
-	if (state % 60 == 0) /* every 60 sec */
+	if (state % 4 == 0)	/* every 60 sec */
 		badness += 5;
-	if (state % 30 == 0) /* every 30 sec */
-		badness += 1;
-	if (state % 15 == 0) /* every 15 sec */
+	if (state % 2 == 0)	/* every 30 sec */
 		badness += 1;
 
 #define BADNESS_LIMIT	4
@@ -2246,7 +2215,7 @@ out_requeue:
 	if (b43legacy_debug(dev, B43legacy_DBG_PWORK_FAST))
 		delay = msecs_to_jiffies(50);
 	else
-		delay = round_jiffies(HZ);
+		delay = round_jiffies(HZ * 15);
 	queue_delayed_work(dev->wl->hw->workqueue,
 			   &dev->periodic_work, delay);
 out:
@@ -3445,6 +3414,7 @@ static int b43legacy_setup_modes(struct 
 
 static void b43legacy_wireless_core_detach(struct b43legacy_wldev *dev)
 {
+	b43legacy_rfkill_free(dev);
 	/* We release firmware that late to not be required to re-request
 	 * is all the time when we reinit the core. */
 	b43legacy_release_firmware(dev);
@@ -3526,6 +3496,7 @@ static int b43legacy_wireless_core_attac
 	if (!wl->current_dev)
 		wl->current_dev = dev;
 	INIT_WORK(&dev->restart_work, b43legacy_chip_reset);
+	b43legacy_rfkill_alloc(dev);
 
 	b43legacy_radio_turn_off(dev, 1);
 	b43legacy_switch_analog(dev, 0);
Index: wireless-2.6/drivers/net/wireless/b43legacy/rfkill.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43legacy/rfkill.c
+++ wireless-2.6/drivers/net/wireless/b43legacy/rfkill.c
@@ -1,6 +1,6 @@
 /*
 
-  Broadcom B43legacy wireless driver
+  Broadcom B43 wireless driver
   RFKILL support
 
   Copyright (c) 2007 Michael Buesch <mb@bu3sch.de>
@@ -27,48 +27,39 @@
 #include "b43legacy.h"
 
 
-static void b43legacy_notify_rfkill_press(struct work_struct *work)
+/* Returns TRUE, if the radio is enabled in hardware. */
+static bool b43legacy_is_hw_radio_enabled(struct b43legacy_wldev *dev)
 {
-	struct b43legacy_rfkill *rfk = container_of(work,
-						    struct b43legacy_rfkill,
-						    notify_work);
-	struct b43legacy_wl *wl = container_of(rfk, struct b43legacy_wl,
-				  rfkill);
-	struct b43legacy_wldev *dev;
-	enum rfkill_state state;
-
-	mutex_lock(&wl->mutex);
-	dev = wl->current_dev;
-	if (b43legacy_status(dev) < B43legacy_STAT_INITIALIZED) {
-		mutex_unlock(&wl->mutex);
-		return;
-	}
-	if (dev->radio_hw_enable)
-		state = RFKILL_STATE_ON;
-	else
-		state = RFKILL_STATE_OFF;
-	b43legacyinfo(wl, "Radio hardware status changed to %s\n",
-		dev->radio_hw_enable ? "ENABLED" : "DISABLED");
-	mutex_unlock(&wl->mutex);
-
-	if (rfk->rfkill) {
-		/* Be careful. This calls back into the software toggle
-		 * routines. So we must unlock before calling. */
-		rfkill_switch_all(rfk->rfkill->type, state);
+	if (dev->phy.rev >= 3) {
+		if (!(b43legacy_read32(dev, B43legacy_MMIO_RADIO_HWENABLED_HI)
+		      & B43legacy_MMIO_RADIO_HWENABLED_HI_MASK))
+			return 1;
+	} else {
+		if (b43legacy_read16(dev, B43legacy_MMIO_RADIO_HWENABLED_LO)
+		    & B43legacy_MMIO_RADIO_HWENABLED_LO_MASK)
+			return 1;
 	}
+	return 0;
 }
 
-/* Called when the RFKILL toggled in hardware.
- * This is called with the mutex locked. */
-void b43legacy_rfkill_toggled(struct b43legacy_wldev *dev, bool on)
+/* The poll callback for the hardware button. */
+static void b43legacy_rfkill_poll(struct input_polled_dev *poll_dev)
 {
+	struct b43legacy_wldev *dev = poll_dev->private;
 	struct b43legacy_wl *wl = dev->wl;
+	bool enabled;
 
+	mutex_lock(&wl->mutex);
 	B43legacy_WARN_ON(b43legacy_status(dev) < B43legacy_STAT_INITIALIZED);
-	/* Update the RF status asynchronously, as rfkill will
-	 * call back into the software toggle handler.
-	 * This would deadlock if done synchronously. */
-	queue_work(wl->hw->workqueue, &wl->rfkill.notify_work);
+	enabled = b43legacy_is_hw_radio_enabled(dev);
+	if (unlikely(enabled != dev->radio_hw_enable)) {
+		dev->radio_hw_enable = enabled;
+		b43legacyinfo(wl, "Radio hardware status changed to %s\n",
+			enabled ? "ENABLED" : "DISABLED");
+		mutex_unlock(&wl->mutex);
+		input_report_key(poll_dev->input, KEY_WLAN, enabled);
+	} else
+		mutex_unlock(&wl->mutex);
 }
 
 /* Called when the RFKILL toggled in software.
@@ -106,7 +97,7 @@ out_unlock:
 	return err;
 }
 
-char *b43legacy_rfkill_led_name(struct b43legacy_wldev *dev)
+char * b43legacy_rfkill_led_name(struct b43legacy_wldev *dev)
 {
 	struct b43legacy_wl *wl = dev->wl;
 
@@ -121,38 +112,74 @@ void b43legacy_rfkill_init(struct b43leg
 	struct b43legacy_rfkill *rfk = &(wl->rfkill);
 	int err;
 
+	if (rfk->rfkill) {
+		err = rfkill_register(rfk->rfkill);
+		if (err) {
+			b43legacywarn(wl, "Failed to register RF-kill button\n");
+			goto err_free_rfk;
+		}
+	}
+	if (rfk->poll_dev) {
+		err = input_register_polled_device(rfk->poll_dev);
+		if (err) {
+			b43legacywarn(wl, "Failed to register RF-kill polldev\n");
+			goto err_free_polldev;
+		}
+	}
+
+	return;
+err_free_rfk:
+	rfkill_free(rfk->rfkill);
+	rfk->rfkill = NULL;
+err_free_polldev:
+	input_free_polled_device(rfk->poll_dev);
+	rfk->poll_dev = NULL;
+}
+
+void b43legacy_rfkill_exit(struct b43legacy_wldev *dev)
+{
+	struct b43legacy_rfkill *rfk = &(dev->wl->rfkill);
+
+	if (rfk->poll_dev)
+		input_unregister_polled_device(rfk->poll_dev);
+	if (rfk->rfkill)
+		rfkill_unregister(rfk->rfkill);
+}
+
+void b43legacy_rfkill_alloc(struct b43legacy_wldev *dev)
+{
+	struct b43legacy_wl *wl = dev->wl;
+	struct b43legacy_rfkill *rfk = &(wl->rfkill);
+
 	snprintf(rfk->name, sizeof(rfk->name),
 		 "b43legacy-%s", wiphy_name(wl->hw->wiphy));
+
 	rfk->rfkill = rfkill_allocate(dev->dev->dev, RFKILL_TYPE_WLAN);
-	if (!rfk->rfkill)
-		goto error;
+	if (!rfk->rfkill) {
+		b43legacywarn(wl, "Failed to allocate RF-kill button\n");
+		return;
+	}
 	rfk->rfkill->name = rfk->name;
 	rfk->rfkill->state = RFKILL_STATE_ON;
 	rfk->rfkill->data = dev;
 	rfk->rfkill->toggle_radio = b43legacy_rfkill_soft_toggle;
 	rfk->rfkill->user_claim_unsupported = 1;
 
-	INIT_WORK(&rfk->notify_work, b43legacy_notify_rfkill_press);
-
-	err = rfkill_register(rfk->rfkill);
-	if (err)
-		goto error;
-
-	return;
-error:
-	b43legacywarn(dev->wl, "Failed to initialize the RF-kill button\n");
-	rfkill_free(rfk->rfkill);
-	rfk->rfkill = NULL;
+	rfk->poll_dev = input_allocate_polled_device();
+	if (rfk->poll_dev) {
+		rfk->poll_dev->private = dev;
+		rfk->poll_dev->poll = b43legacy_rfkill_poll;
+		rfk->poll_dev->poll_interval = 1000; /* msecs */
+	} else
+		b43legacywarn(wl, "Failed to allocate RF-kill polldev\n");
 }
 
-void b43legacy_rfkill_exit(struct b43legacy_wldev *dev)
+void b43legacy_rfkill_free(struct b43legacy_wldev *dev)
 {
 	struct b43legacy_rfkill *rfk = &(dev->wl->rfkill);
 
-	if (!rfk->rfkill)
-		return;
-	cancel_work_sync(&rfk->notify_work);
-	rfkill_unregister(rfk->rfkill);
+	input_free_polled_device(rfk->poll_dev);
+	rfk->poll_dev = NULL;
 	rfkill_free(rfk->rfkill);
 	rfk->rfkill = NULL;
 }
Index: wireless-2.6/drivers/net/wireless/b43legacy/rfkill.h
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43legacy/rfkill.h
+++ wireless-2.6/drivers/net/wireless/b43legacy/rfkill.h
@@ -7,21 +7,27 @@ struct b43legacy_wldev;
 
 #include <linux/rfkill.h>
 #include <linux/workqueue.h>
+#include <linux/input-polldev.h>
+
 
 
 struct b43legacy_rfkill {
 	/* The RFKILL subsystem data structure */
 	struct rfkill *rfkill;
+	/* The poll device for the RFKILL input button */
+	struct input_polled_dev *poll_dev;
 	/* The unique name of this rfkill switch */
 	char name[32];
-	/* Workqueue for asynchronous notification. */
-	struct work_struct notify_work;
 };
 
+/* All the init functions return void, because we are not interested
+ * in failing the b43 init process when rfkill init failed. */
+void b43legacy_rfkill_alloc(struct b43legacy_wldev *dev);
+void b43legacy_rfkill_free(struct b43legacy_wldev *dev);
 void b43legacy_rfkill_init(struct b43legacy_wldev *dev);
 void b43legacy_rfkill_exit(struct b43legacy_wldev *dev);
-void b43legacy_rfkill_toggled(struct b43legacy_wldev *dev, bool on);
-char *b43legacy_rfkill_led_name(struct b43legacy_wldev *dev);
+
+char * b43legacy_rfkill_led_name(struct b43legacy_wldev *dev);
 
 
 #else /* CONFIG_B43LEGACY_RFKILL */
@@ -31,17 +37,19 @@ struct b43legacy_rfkill {
 	/* empty */
 };
 
-static inline void b43legacy_rfkill_init(struct b43legacy_wldev *dev)
+static inline void b43legacy_rfkill_alloc(struct b43legacy_wldev *dev)
 {
 }
-static inline void b43legacy_rfkill_exit(struct b43legacy_wldev *dev)
+static inline void b43legacy_rfkill_free(struct b43legacy_wldev *dev)
 {
 }
-static inline void b43legacy_rfkill_toggled(struct b43legacy_wldev *dev,
-					    bool on)
+static inline void b43legacy_rfkill_init(struct b43legacy_wldev *dev)
+{
+}
+static inline void b43legacy_rfkill_exit(struct b43legacy_wldev *dev)
 {
 }
-static inline char *b43legacy_rfkill_led_name(struct b43legacy_wldev *dev)
+static inline char * b43legacy_rfkill_led_name(struct b43legacy_wldev *dev)
 {
 	return NULL;
 }
