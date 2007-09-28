Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:52714
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751726AbXI1MXP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Sep 2007 08:23:15 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] b43: Use input-polldev for the rfkill switch
Date: Fri, 28 Sep 2007 14:22:33 +0200
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200709281422.34434.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This removes the direct call to rfkill on an rfkill event
and replaces it with an input device. This way userspace is also
notified about the event.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

Index: wireless-2.6/drivers/net/wireless/b43/Kconfig
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/Kconfig	2007-09-27 21:31:15.000000000 +0200
+++ wireless-2.6/drivers/net/wireless/b43/Kconfig	2007-09-28 12:34:23.000000000 +0200
@@ -70,7 +70,7 @@ config B43_LEDS
 # RFKILL support
 config B43_RFKILL
 	bool
-	depends on B43 && RFKILL
+	depends on B43 && RFKILL && RFKILL_INPUT && INPUT_POLLDEV
 	default y
 
 config B43_DEBUG
Index: wireless-2.6/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/main.c	2007-09-27 21:31:22.000000000 +0200
+++ wireless-2.6/drivers/net/wireless/b43/main.c	2007-09-28 14:11:11.000000000 +0200
@@ -2183,21 +2183,6 @@ static void b43_mgmtframe_txantenna(stru
 	b43_shm_write16(dev, B43_SHM_SHARED, B43_SHM_SH_PRPHYCTL, tmp);
 }
 
-/* Returns TRUE, if the radio is enabled in hardware. */
-static bool b43_is_hw_radio_enabled(struct b43_wldev *dev)
-{
-	if (dev->phy.rev >= 3) {
-		if (!(b43_read32(dev, B43_MMIO_RADIO_HWENABLED_HI)
-		      & B43_MMIO_RADIO_HWENABLED_HI_MASK))
-			return 1;
-	} else {
-		if (b43_read16(dev, B43_MMIO_RADIO_HWENABLED_LO)
-		    & B43_MMIO_RADIO_HWENABLED_LO_MASK)
-			return 1;
-	}
-	return 0;
-}
-
 /* This is the opposite of b43_chip_init() */
 static void b43_chip_exit(struct b43_wldev *dev)
 {
@@ -2393,32 +2378,18 @@ static void b43_periodic_every15sec(stru
 	//TODO for APHY (temperature?)
 }
 
-static void b43_periodic_every1sec(struct b43_wldev *dev)
-{
-	bool radio_hw_enable;
-
-	/* check if radio hardware enabled status changed */
-	radio_hw_enable = b43_is_hw_radio_enabled(dev);
-	if (unlikely(dev->radio_hw_enable != radio_hw_enable)) {
-		dev->radio_hw_enable = radio_hw_enable;
-		b43_rfkill_toggled(dev, radio_hw_enable);
-	}
-}
-
 static void do_periodic_work(struct b43_wldev *dev)
 {
 	unsigned int state;
 
 	state = dev->periodic_state;
-	if (state % 120 == 0)
+	if (state % 8 == 0)
 		b43_periodic_every120sec(dev);
-	if (state % 60 == 0)
+	if (state % 4 == 0)
 		b43_periodic_every60sec(dev);
-	if (state % 30 == 0)
+	if (state % 2 == 0)
 		b43_periodic_every30sec(dev);
-	if (state % 15 == 0)
-		b43_periodic_every15sec(dev);
-	b43_periodic_every1sec(dev);
+	b43_periodic_every15sec(dev);
 }
 
 /* Estimate a "Badness" value based on the periodic work
@@ -2429,13 +2400,11 @@ static int estimate_periodic_work_badnes
 {
 	int badness = 0;
 
-	if (state % 120 == 0)	/* every 120 sec */
+	if (state % 8 == 0)	/* every 120 sec */
 		badness += 10;
-	if (state % 60 == 0)	/* every 60 sec */
+	if (state % 4 == 0)	/* every 60 sec */
 		badness += 5;
-	if (state % 30 == 0)	/* every 30 sec */
-		badness += 1;
-	if (state % 15 == 0)	/* every 15 sec */
+	if (state % 2 == 0)	/* every 30 sec */
 		badness += 1;
 
 #define BADNESS_LIMIT	4
@@ -2486,13 +2455,13 @@ static void b43_periodic_work_handler(st
 		spin_unlock_irqrestore(&dev->wl->irq_lock, flags);
 	}
 	dev->periodic_state++;
-      out_requeue:
+out_requeue:
 	if (b43_debug(dev, B43_DBG_PWORK_FAST))
 		delay = msecs_to_jiffies(50);
 	else
-		delay = round_jiffies(HZ);
+		delay = round_jiffies(HZ * 15);
 	queue_delayed_work(dev->wl->hw->workqueue, &dev->periodic_work, delay);
-      out:
+out:
 	mutex_unlock(&dev->wl->mutex);
 }
 
@@ -3721,6 +3690,7 @@ static int b43_setup_modes(struct b43_wl
 
 static void b43_wireless_core_detach(struct b43_wldev *dev)
 {
+	b43_rfkill_free(dev);
 	/* We release firmware that late to not be required to re-request
 	 * is all the time when we reinit the core. */
 	b43_release_firmware(dev);
@@ -3806,6 +3776,7 @@ static int b43_wireless_core_attach(stru
 	if (!wl->current_dev)
 		wl->current_dev = dev;
 	INIT_WORK(&dev->restart_work, b43_chip_reset);
+	b43_rfkill_alloc(dev);
 
 	b43_radio_turn_off(dev, 1);
 	b43_switch_analog(dev, 0);
Index: wireless-2.6/drivers/net/wireless/b43/rfkill.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/rfkill.c	2007-09-27 21:31:15.000000000 +0200
+++ wireless-2.6/drivers/net/wireless/b43/rfkill.c	2007-09-28 14:06:37.000000000 +0200
@@ -26,46 +26,39 @@
 #include "b43.h"
 
 
-static void b43_notify_rfkill_press(struct work_struct *work)
+/* Returns TRUE, if the radio is enabled in hardware. */
+static bool b43_is_hw_radio_enabled(struct b43_wldev *dev)
 {
-	struct b43_rfkill *rfk = container_of(work, struct b43_rfkill,
-					      notify_work);
-	struct b43_wl *wl = container_of(rfk, struct b43_wl, rfkill);
-	struct b43_wldev *dev;
-	enum rfkill_state state;
-
-	mutex_lock(&wl->mutex);
-	dev = wl->current_dev;
-	if (b43_status(dev) < B43_STAT_INITIALIZED) {
-		mutex_unlock(&wl->mutex);
-		return;
-	}
-	if (dev->radio_hw_enable)
-		state = RFKILL_STATE_ON;
-	else
-		state = RFKILL_STATE_OFF;
-	b43info(wl, "Radio hardware status changed to %s\n",
-		dev->radio_hw_enable ? "ENABLED" : "DISABLED");
-	mutex_unlock(&wl->mutex);
-
-	if (rfk->rfkill) {
-		/* Be careful. This calls back into the software toggle routines.
-		 * So we must unlock before calling. */
-		rfkill_switch_all(rfk->rfkill->type, state);
+	if (dev->phy.rev >= 3) {
+		if (!(b43_read32(dev, B43_MMIO_RADIO_HWENABLED_HI)
+		      & B43_MMIO_RADIO_HWENABLED_HI_MASK))
+			return 1;
+	} else {
+		if (b43_read16(dev, B43_MMIO_RADIO_HWENABLED_LO)
+		    & B43_MMIO_RADIO_HWENABLED_LO_MASK)
+			return 1;
 	}
+	return 0;
 }
 
-/* Called when the RFKILL toggled in hardware.
- * This is called with the mutex locked. */
-void b43_rfkill_toggled(struct b43_wldev *dev, bool on)
+/* The poll callback for the hardware button. */
+static void b43_rfkill_poll(struct input_polled_dev *poll_dev)
 {
+	struct b43_wldev *dev = poll_dev->private;
 	struct b43_wl *wl = dev->wl;
+	bool enabled;
 
+	mutex_lock(&wl->mutex);
 	B43_WARN_ON(b43_status(dev) < B43_STAT_INITIALIZED);
-	/* Update the RF status asynchronously, as rfkill will
-	 * call back into the software toggle handler.
-	 * This would deadlock if done synchronously. */
-	queue_work(wl->hw->workqueue, &wl->rfkill.notify_work);
+	enabled = b43_is_hw_radio_enabled(dev);
+	if (unlikely(enabled != dev->radio_hw_enable)) {
+		dev->radio_hw_enable = enabled;
+		b43info(wl, "Radio hardware status changed to %s\n",
+			enabled ? "ENABLED" : "DISABLED");
+		mutex_unlock(&wl->mutex);
+		input_report_key(poll_dev->input, KEY_WLAN, enabled);
+	} else
+		mutex_unlock(&wl->mutex);
 }
 
 /* Called when the RFKILL toggled in software.
@@ -118,38 +111,74 @@ void b43_rfkill_init(struct b43_wldev *d
 	struct b43_rfkill *rfk = &(wl->rfkill);
 	int err;
 
+	if (rfk->rfkill) {
+		err = rfkill_register(rfk->rfkill);
+		if (err) {
+			b43warn(wl, "Failed to register RF-kill button\n");
+			goto err_free_rfk;
+		}
+	}
+	if (rfk->poll_dev) {
+		err = input_register_polled_device(rfk->poll_dev);
+		if (err) {
+			b43warn(wl, "Failed to register RF-kill polldev\n");
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
+void b43_rfkill_exit(struct b43_wldev *dev)
+{
+	struct b43_rfkill *rfk = &(dev->wl->rfkill);
+
+	if (rfk->poll_dev)
+		input_unregister_polled_device(rfk->poll_dev);
+	if (rfk->rfkill)
+		rfkill_unregister(rfk->rfkill);
+}
+
+void b43_rfkill_alloc(struct b43_wldev *dev)
+{
+	struct b43_wl *wl = dev->wl;
+	struct b43_rfkill *rfk = &(wl->rfkill);
+
 	snprintf(rfk->name, sizeof(rfk->name),
 		 "b43-%s", wiphy_name(wl->hw->wiphy));
+
 	rfk->rfkill = rfkill_allocate(dev->dev->dev, RFKILL_TYPE_WLAN);
-	if (!rfk->rfkill)
-		goto error;
+	if (!rfk->rfkill) {
+		b43warn(wl, "Failed to allocate RF-kill button\n");
+		return;
+	}
 	rfk->rfkill->name = rfk->name;
 	rfk->rfkill->state = RFKILL_STATE_ON;
 	rfk->rfkill->data = dev;
 	rfk->rfkill->toggle_radio = b43_rfkill_soft_toggle;
 	rfk->rfkill->user_claim_unsupported = 1;
 
-	INIT_WORK(&rfk->notify_work, b43_notify_rfkill_press);
-
-	err = rfkill_register(rfk->rfkill);
-	if (err)
-		goto error;
-
-	return;
-error:
-	b43warn(dev->wl, "Failed to initialize the RF-kill button\n");
-	rfkill_free(rfk->rfkill);
-	rfk->rfkill = NULL;
+	rfk->poll_dev = input_allocate_polled_device();
+	if (rfk->poll_dev) {
+		rfk->poll_dev->private = dev;
+		rfk->poll_dev->poll = b43_rfkill_poll;
+		rfk->poll_dev->poll_interval = 1000; /* msecs */
+	} else
+		b43warn(wl, "Failed to allocate RF-kill polldev\n");
 }
 
-void b43_rfkill_exit(struct b43_wldev *dev)
+void b43_rfkill_free(struct b43_wldev *dev)
 {
 	struct b43_rfkill *rfk = &(dev->wl->rfkill);
 
-	if (!rfk->rfkill)
-		return;
-	cancel_work_sync(&rfk->notify_work);
-	rfkill_unregister(rfk->rfkill);
+	input_free_polled_device(rfk->poll_dev);
+	rfk->poll_dev = NULL;
 	rfkill_free(rfk->rfkill);
 	rfk->rfkill = NULL;
 }
Index: wireless-2.6/drivers/net/wireless/b43/rfkill.h
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/rfkill.h	2007-09-27 21:31:15.000000000 +0200
+++ wireless-2.6/drivers/net/wireless/b43/rfkill.h	2007-09-28 13:52:04.000000000 +0200
@@ -7,19 +7,25 @@ struct b43_wldev;
 #ifdef CONFIG_B43_RFKILL
 
 #include <linux/rfkill.h>
+#include <linux/input-polldev.h>
+
 
 struct b43_rfkill {
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
+void b43_rfkill_alloc(struct b43_wldev *dev);
+void b43_rfkill_free(struct b43_wldev *dev);
 void b43_rfkill_init(struct b43_wldev *dev);
 void b43_rfkill_exit(struct b43_wldev *dev);
-void b43_rfkill_toggled(struct b43_wldev *dev, bool on);
+
 char * b43_rfkill_led_name(struct b43_wldev *dev);
 
 
@@ -30,13 +36,16 @@ struct b43_rfkill {
 	/* empty */
 };
 
-static inline void b43_rfkill_init(struct b43_wldev *dev)
+static inline void b43_rfkill_alloc(struct b43_wldev *dev)
 {
 }
-static inline void b43_rfkill_exit(struct b43_wldev *dev)
+static inline void b43_rfkill_free(struct b43_wldev *dev)
 {
 }
-static inline void b43_rfkill_toggled(struct b43_wldev *dev, bool on)
+static inline void b43_rfkill_init(struct b43_wldev *dev)
+{
+}
+static inline void b43_rfkill_exit(struct b43_wldev *dev)
 {
 }
 static inline char * b43_rfkill_led_name(struct b43_wldev *dev)
