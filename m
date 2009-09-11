Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:58470 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752637AbZIKUaW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Sep 2009 16:30:22 -0400
From: Michael Buesch <mb@bu3sch.de>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] b43: Rewrite suspend/resume code
Date: Fri, 11 Sep 2009 21:44:05 +0200
Cc: Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	"linux-wireless" <linux-wireless@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200909112144.05347.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This removes most of the b43 suspend/resume code (it's handled by mac80211)
and moves the registration of devices to the attachment phase. This is
required, because we must not register/unregister devices on suspend/resume.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

Nobody replied to my RFT request, so I guess it's OK.

John, this patch needs to be applied in front of some other patches
that I already sent. See this series file, if you have problems applying
the patches: http://bu3sch.de/patches/wireless-testing/20090911-2143/patches/series


Index: wireless-testing/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/main.c	2009-09-11 21:29:20.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/main.c	2009-09-11 21:29:22.000000000 +0200
@@ -3006,14 +3006,18 @@ static void b43_security_init(struct b43
 static int b43_rng_read(struct hwrng *rng, u32 *data)
 {
 	struct b43_wl *wl = (struct b43_wl *)rng->priv;
+	struct b43_wldev *dev;
+	int count = -ENODEV;
 
-	/* FIXME: We need to take wl->mutex here to make sure the device
-	 * is not going away from under our ass. However it could deadlock
-	 * with hwrng internal locking. */
-
-	*data = b43_read16(wl->current_dev, B43_MMIO_RNG);
+	mutex_lock(&wl->mutex);
+	dev = wl->current_dev;
+	if (likely(dev && b43_status(dev) >= B43_STAT_INITIALIZED)) {
+		*data = b43_read16(dev, B43_MMIO_RNG);
+		count = sizeof(u16);
+	}
+	mutex_unlock(&wl->mutex);
 
-	return (sizeof(u16));
+	return count;
 }
 #endif /* CONFIG_B43_HWRNG */
 
@@ -3855,6 +3859,7 @@ redo:
 
 	b43_mac_suspend(dev);
 	free_irq(dev->dev->irq, dev);
+	b43_leds_exit(dev);
 	b43dbg(wl, "Wireless interface stopped\n");
 
 	return dev;
@@ -3886,8 +3891,10 @@ static int b43_wireless_core_start(struc
 	/* Start maintainance work */
 	b43_periodic_tasks_setup(dev);
 
+	b43_leds_init(dev);
+
 	b43dbg(dev->wl, "Wireless interface started\n");
-      out:
+out:
 	return err;
 }
 
@@ -4164,10 +4171,6 @@ static void b43_wireless_core_exit(struc
 	macctl |= B43_MACCTL_PSM_JMP0;
 	b43_write32(dev, B43_MMIO_MACCTL, macctl);
 
-	if (!dev->suspend_in_progress) {
-		b43_leds_exit(dev);
-		b43_rng_exit(dev->wl);
-	}
 	b43_dma_free(dev);
 	b43_pio_free(dev);
 	b43_chip_exit(dev);
@@ -4184,7 +4187,6 @@ static void b43_wireless_core_exit(struc
 /* Initialize a wireless core */
 static int b43_wireless_core_init(struct b43_wldev *dev)
 {
-	struct b43_wl *wl = dev->wl;
 	struct ssb_bus *bus = dev->dev->bus;
 	struct ssb_sprom *sprom = &bus->sprom;
 	struct b43_phy *phy = &dev->phy;
@@ -4284,13 +4286,9 @@ static int b43_wireless_core_init(struct
 	ssb_bus_powerup(bus, !(sprom->boardflags_lo & B43_BFL_XTAL_NOSLOW));
 	b43_upload_card_macaddress(dev);
 	b43_security_init(dev);
-	if (!dev->suspend_in_progress)
-		b43_rng_init(wl);
 
 	b43_set_status(dev, B43_STAT_INITIALIZED);
 
-	if (!dev->suspend_in_progress)
-		b43_leds_init(dev);
 out:
 	return err;
 
@@ -4839,7 +4837,6 @@ static int b43_wireless_init(struct ssb_
 
 	/* Initialize struct b43_wl */
 	wl->hw = hw;
-	spin_lock_init(&wl->leds_lock);
 	mutex_init(&wl->mutex);
 	spin_lock_init(&wl->hardirq_lock);
 	INIT_LIST_HEAD(&wl->devlist);
@@ -4880,6 +4877,8 @@ static int b43_probe(struct ssb_device *
 		err = ieee80211_register_hw(wl->hw);
 		if (err)
 			goto err_one_core_detach;
+		b43_leds_register(wl->current_dev);
+		b43_rng_init(wl);
 	}
 
       out:
@@ -4908,12 +4907,16 @@ static void b43_remove(struct ssb_device
 		 * might have modified it. Restoring is important, so the networking
 		 * stack can properly free resources. */
 		wl->hw->queues = wl->mac80211_initially_registered_queues;
+		wl->current_dev = NULL;
+		cancel_work_sync(&wl->leds.work);
 		ieee80211_unregister_hw(wl->hw);
 	}
 
 	b43_one_core_detach(dev);
 
 	if (list_empty(&wl->devlist)) {
+		b43_rng_exit(wl);
+		b43_leds_unregister(wldev);
 		/* Last core on the chip unregistered.
 		 * We can destroy common struct b43_wl.
 		 */
@@ -4931,74 +4934,11 @@ void b43_controller_restart(struct b43_w
 	ieee80211_queue_work(dev->wl->hw, &dev->restart_work);
 }
 
-#ifdef CONFIG_PM
-
-static int b43_suspend(struct ssb_device *dev, pm_message_t state)
-{
-	struct b43_wldev *wldev = ssb_get_drvdata(dev);
-	struct b43_wl *wl = wldev->wl;
-
-	b43dbg(wl, "Suspending...\n");
-
-	mutex_lock(&wl->mutex);
-	wldev->suspend_in_progress = true;
-	wldev->suspend_init_status = b43_status(wldev);
-	if (wldev->suspend_init_status >= B43_STAT_STARTED)
-		wldev = b43_wireless_core_stop(wldev);
-	if (wldev && wldev->suspend_init_status >= B43_STAT_INITIALIZED)
-		b43_wireless_core_exit(wldev);
-	mutex_unlock(&wl->mutex);
-
-	b43dbg(wl, "Device suspended.\n");
-
-	return 0;
-}
-
-static int b43_resume(struct ssb_device *dev)
-{
-	struct b43_wldev *wldev = ssb_get_drvdata(dev);
-	struct b43_wl *wl = wldev->wl;
-	int err = 0;
-
-	b43dbg(wl, "Resuming...\n");
-
-	mutex_lock(&wl->mutex);
-	if (wldev->suspend_init_status >= B43_STAT_INITIALIZED) {
-		err = b43_wireless_core_init(wldev);
-		if (err) {
-			b43err(wl, "Resume failed at core init\n");
-			goto out;
-		}
-	}
-	if (wldev->suspend_init_status >= B43_STAT_STARTED) {
-		err = b43_wireless_core_start(wldev);
-		if (err) {
-			b43_leds_exit(wldev);
-			b43_rng_exit(wldev->wl);
-			b43_wireless_core_exit(wldev);
-			b43err(wl, "Resume failed at core start\n");
-			goto out;
-		}
-	}
-	b43dbg(wl, "Device resumed.\n");
- out:
-	wldev->suspend_in_progress = false;
-	mutex_unlock(&wl->mutex);
-	return err;
-}
-
-#else /* CONFIG_PM */
-# define b43_suspend	NULL
-# define b43_resume	NULL
-#endif /* CONFIG_PM */
-
 static struct ssb_driver b43_ssb_driver = {
 	.name		= KBUILD_MODNAME,
 	.id_table	= b43_ssb_tbl,
 	.probe		= b43_probe,
 	.remove		= b43_remove,
-	.suspend	= b43_suspend,
-	.resume		= b43_resume,
 };
 
 static void b43_print_driverinfo(void)
Index: wireless-testing/drivers/net/wireless/b43/b43.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/b43.h	2009-09-11 21:29:20.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/b43.h	2009-09-11 21:29:22.000000000 +0200
@@ -629,13 +629,6 @@ struct b43_wl {
 	 * from the mac80211 subsystem. */
 	u16 mac80211_initially_registered_queues;
 
-	/* R/W lock for data transmission.
-	 * Transmissions on 2+ queues can run concurrently, but somebody else
-	 * might sync with TX by write_lock_irqsave()'ing. */
-	rwlock_t tx_lock;
-	/* Lock for LEDs access. */
-	spinlock_t leds_lock;
-
 	/* We can only have one operating interface (802.11 core)
 	 * at a time. General information about this interface follows.
 	 */
@@ -686,6 +679,9 @@ struct b43_wl {
 	struct work_struct tx_work;
 	/* Queue of packets to be transmitted. */
 	struct sk_buff_head tx_queue;
+
+	/* The device LEDs. */
+	struct b43_leds leds;
 };
 
 /* The type of the firmware file. */
@@ -768,13 +764,10 @@ struct b43_wldev {
 	/* The device initialization status.
 	 * Use b43_status() to query. */
 	atomic_t __init_status;
-	/* Saved init status for handling suspend. */
-	int suspend_init_status;
 
 	bool bad_frames_preempt;	/* Use "Bad Frames Preemption" (default off) */
 	bool dfq_valid;		/* Directed frame queue valid (IBSS PS mode, ATIM) */
 	bool radio_hw_enable;	/* saved state of radio hardware enabled state */
-	bool suspend_in_progress;	/* TRUE, if we are in a suspend/resume cycle */
 	bool qos_enabled;		/* TRUE, if QoS is used. */
 	bool hwcrypto_enabled;		/* TRUE, if HW crypto acceleration is enabled. */
 
@@ -794,12 +787,6 @@ struct b43_wldev {
 	/* Various statistics about the physical device. */
 	struct b43_stats stats;
 
-	/* The device LEDs. */
-	struct b43_led led_tx;
-	struct b43_led led_rx;
-	struct b43_led led_assoc;
-	struct b43_led led_radio;
-
 	/* Reason code of the last interrupt. */
 	u32 irq_reason;
 	u32 dma_reason[6];
Index: wireless-testing/drivers/net/wireless/b43/leds.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/leds.c	2009-09-11 21:29:20.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/leds.c	2009-09-11 21:29:22.000000000 +0200
@@ -34,57 +34,91 @@
 static void b43_led_turn_on(struct b43_wldev *dev, u8 led_index,
 			    bool activelow)
 {
-	struct b43_wl *wl = dev->wl;
-	unsigned long flags;
 	u16 ctl;
 
-	spin_lock_irqsave(&wl->leds_lock, flags);
 	ctl = b43_read16(dev, B43_MMIO_GPIO_CONTROL);
 	if (activelow)
 		ctl &= ~(1 << led_index);
 	else
 		ctl |= (1 << led_index);
 	b43_write16(dev, B43_MMIO_GPIO_CONTROL, ctl);
-	spin_unlock_irqrestore(&wl->leds_lock, flags);
 }
 
 static void b43_led_turn_off(struct b43_wldev *dev, u8 led_index,
 			     bool activelow)
 {
-	struct b43_wl *wl = dev->wl;
-	unsigned long flags;
 	u16 ctl;
 
-	spin_lock_irqsave(&wl->leds_lock, flags);
 	ctl = b43_read16(dev, B43_MMIO_GPIO_CONTROL);
 	if (activelow)
 		ctl |= (1 << led_index);
 	else
 		ctl &= ~(1 << led_index);
 	b43_write16(dev, B43_MMIO_GPIO_CONTROL, ctl);
-	spin_unlock_irqrestore(&wl->leds_lock, flags);
 }
 
-/* Callback from the LED subsystem. */
-static void b43_led_brightness_set(struct led_classdev *led_dev,
-				   enum led_brightness brightness)
+static void b43_led_update(struct b43_wldev *dev,
+			   struct b43_led *led)
 {
-	struct b43_led *led = container_of(led_dev, struct b43_led, led_dev);
-	struct b43_wldev *dev = led->dev;
 	bool radio_enabled;
+	bool turn_on;
 
-	if (unlikely(b43_status(dev) < B43_STAT_INITIALIZED))
+	if (!led->wl)
 		return;
 
-	/* Checking the radio-enabled status here is slightly racy,
-	 * but we want to avoid the locking overhead and we don't care
-	 * whether the LED has the wrong state for a second. */
 	radio_enabled = (dev->phy.radio_on && dev->radio_hw_enable);
 
-	if (brightness == LED_OFF || !radio_enabled)
-		b43_led_turn_off(dev, led->index, led->activelow);
+	/* The led->state read is racy, but we don't care. In case we raced
+	 * with the brightness_set handler, we will be called again soon
+	 * to fixup our state. */
+	if (radio_enabled)
+		turn_on = atomic_read(&led->state) != LED_OFF;
 	else
+		turn_on = 0;
+	if (turn_on == led->hw_state)
+		return;
+	led->hw_state = turn_on;
+
+	if (turn_on)
 		b43_led_turn_on(dev, led->index, led->activelow);
+	else
+		b43_led_turn_off(dev, led->index, led->activelow);
+}
+
+static void b43_leds_work(struct work_struct *work)
+{
+	struct b43_leds *leds = container_of(work, struct b43_leds, work);
+	struct b43_wl *wl = container_of(leds, struct b43_wl, leds);
+	struct b43_wldev *dev;
+
+	mutex_lock(&wl->mutex);
+	dev = wl->current_dev;
+	if (unlikely(!dev || b43_status(dev) < B43_STAT_STARTED))
+		goto out_unlock;
+
+	b43_led_update(dev, &wl->leds.led_tx);
+	b43_led_update(dev, &wl->leds.led_rx);
+	b43_led_update(dev, &wl->leds.led_radio);
+	b43_led_update(dev, &wl->leds.led_assoc);
+
+out_unlock:
+	mutex_unlock(&wl->mutex);
+}
+
+/* Callback from the LED subsystem. */
+static void b43_led_brightness_set(struct led_classdev *led_dev,
+				   enum led_brightness brightness)
+{
+	struct b43_led *led = container_of(led_dev, struct b43_led, led_dev);
+	struct b43_wl *wl = led->wl;
+
+	/* The check for current_dev is only needed while unregistering,
+	 * so it is sequencial and does not race. But we must not dereference
+	 * current_dev here. */
+	if (likely(wl->current_dev)) {
+		atomic_set(&led->state, brightness);
+		ieee80211_queue_work(wl->hw, &wl->leds.work);
+	}
 }
 
 static int b43_register_led(struct b43_wldev *dev, struct b43_led *led,
@@ -93,15 +127,15 @@ static int b43_register_led(struct b43_w
 {
 	int err;
 
-	b43_led_turn_off(dev, led_index, activelow);
-	if (led->dev)
+	if (led->wl)
 		return -EEXIST;
 	if (!default_trigger)
 		return -EINVAL;
-	led->dev = dev;
+	led->wl = dev->wl;
 	led->index = led_index;
 	led->activelow = activelow;
 	strncpy(led->name, name, sizeof(led->name));
+	atomic_set(&led->state, 0);
 
 	led->led_dev.name = led->name;
 	led->led_dev.default_trigger = default_trigger;
@@ -110,19 +144,19 @@ static int b43_register_led(struct b43_w
 	err = led_classdev_register(dev->dev->dev, &led->led_dev);
 	if (err) {
 		b43warn(dev->wl, "LEDs: Failed to register %s\n", name);
-		led->dev = NULL;
+		led->wl = NULL;
 		return err;
 	}
+
 	return 0;
 }
 
 static void b43_unregister_led(struct b43_led *led)
 {
-	if (!led->dev)
+	if (!led->wl)
 		return;
 	led_classdev_unregister(&led->led_dev);
-	b43_led_turn_off(led->dev, led->index, led->activelow);
-	led->dev = NULL;
+	led->wl = NULL;
 }
 
 static void b43_map_led(struct b43_wldev *dev,
@@ -137,24 +171,20 @@ static void b43_map_led(struct b43_wldev
 	 * generic LED triggers. */
 	switch (behaviour) {
 	case B43_LED_INACTIVE:
-		break;
 	case B43_LED_OFF:
-		b43_led_turn_off(dev, led_index, activelow);
-		break;
 	case B43_LED_ON:
-		b43_led_turn_on(dev, led_index, activelow);
 		break;
 	case B43_LED_ACTIVITY:
 	case B43_LED_TRANSFER:
 	case B43_LED_APTRANSFER:
 		snprintf(name, sizeof(name),
 			 "b43-%s::tx", wiphy_name(hw->wiphy));
-		b43_register_led(dev, &dev->led_tx, name,
+		b43_register_led(dev, &dev->wl->leds.led_tx, name,
 				 ieee80211_get_tx_led_name(hw),
 				 led_index, activelow);
 		snprintf(name, sizeof(name),
 			 "b43-%s::rx", wiphy_name(hw->wiphy));
-		b43_register_led(dev, &dev->led_rx, name,
+		b43_register_led(dev, &dev->wl->leds.led_rx, name,
 				 ieee80211_get_rx_led_name(hw),
 				 led_index, activelow);
 		break;
@@ -164,18 +194,15 @@ static void b43_map_led(struct b43_wldev
 	case B43_LED_MODE_BG:
 		snprintf(name, sizeof(name),
 			 "b43-%s::radio", wiphy_name(hw->wiphy));
-		b43_register_led(dev, &dev->led_radio, name,
+		b43_register_led(dev, &dev->wl->leds.led_radio, name,
 				 ieee80211_get_radio_led_name(hw),
 				 led_index, activelow);
-		/* Sync the RF-kill LED state with radio and switch states. */
-		if (dev->phy.radio_on && b43_is_hw_radio_enabled(dev))
-			b43_led_turn_on(dev, led_index, activelow);
 		break;
 	case B43_LED_WEIRD:
 	case B43_LED_ASSOC:
 		snprintf(name, sizeof(name),
 			 "b43-%s::assoc", wiphy_name(hw->wiphy));
-		b43_register_led(dev, &dev->led_assoc, name,
+		b43_register_led(dev, &dev->wl->leds.led_assoc, name,
 				 ieee80211_get_assoc_led_name(hw),
 				 led_index, activelow);
 		break;
@@ -186,58 +213,140 @@ static void b43_map_led(struct b43_wldev
 	}
 }
 
-void b43_leds_init(struct b43_wldev *dev)
+static void b43_led_get_sprominfo(struct b43_wldev *dev,
+				  unsigned int led_index,
+				  enum b43_led_behaviour *behaviour,
+				  bool *activelow)
 {
 	struct ssb_bus *bus = dev->dev->bus;
 	u8 sprom[4];
-	int i;
-	enum b43_led_behaviour behaviour;
-	bool activelow;
 
 	sprom[0] = bus->sprom.gpio0;
 	sprom[1] = bus->sprom.gpio1;
 	sprom[2] = bus->sprom.gpio2;
 	sprom[3] = bus->sprom.gpio3;
 
-	for (i = 0; i < 4; i++) {
-		if (sprom[i] == 0xFF) {
-			/* There is no LED information in the SPROM
-			 * for this LED. Hardcode it here. */
-			activelow = 0;
-			switch (i) {
-			case 0:
-				behaviour = B43_LED_ACTIVITY;
-				activelow = 1;
-				if (bus->boardinfo.vendor == PCI_VENDOR_ID_COMPAQ)
-					behaviour = B43_LED_RADIO_ALL;
-				break;
-			case 1:
-				behaviour = B43_LED_RADIO_B;
-				if (bus->boardinfo.vendor == PCI_VENDOR_ID_ASUSTEK)
-					behaviour = B43_LED_ASSOC;
-				break;
-			case 2:
-				behaviour = B43_LED_RADIO_A;
-				break;
-			case 3:
-				behaviour = B43_LED_OFF;
-				break;
-			default:
-				B43_WARN_ON(1);
-				return;
-			}
+	if (sprom[led_index] == 0xFF) {
+		/* There is no LED information in the SPROM
+		 * for this LED. Hardcode it here. */
+		*activelow = 0;
+		switch (led_index) {
+		case 0:
+			*behaviour = B43_LED_ACTIVITY;
+			*activelow = 1;
+			if (bus->boardinfo.vendor == PCI_VENDOR_ID_COMPAQ)
+				*behaviour = B43_LED_RADIO_ALL;
+			break;
+		case 1:
+			*behaviour = B43_LED_RADIO_B;
+			if (bus->boardinfo.vendor == PCI_VENDOR_ID_ASUSTEK)
+				*behaviour = B43_LED_ASSOC;
+			break;
+		case 2:
+			*behaviour = B43_LED_RADIO_A;
+			break;
+		case 3:
+			*behaviour = B43_LED_OFF;
+			break;
+		default:
+			B43_WARN_ON(1);
+			return;
+		}
+	} else {
+		*behaviour = sprom[led_index] & B43_LED_BEHAVIOUR;
+		*activelow = !!(sprom[led_index] & B43_LED_ACTIVELOW);
+	}
+}
+
+void b43_leds_init(struct b43_wldev *dev)
+{
+	struct b43_led *led;
+	unsigned int i;
+	enum b43_led_behaviour behaviour;
+	bool activelow;
+
+	/* Sync the RF-kill LED state (if we have one) with radio and switch states. */
+	led = &dev->wl->leds.led_radio;
+	if (led->wl) {
+		if (dev->phy.radio_on && b43_is_hw_radio_enabled(dev)) {
+			b43_led_turn_on(dev, led->index, led->activelow);
+			led->hw_state = 1;
+			atomic_set(&led->state, 1);
 		} else {
-			behaviour = sprom[i] & B43_LED_BEHAVIOUR;
-			activelow = !!(sprom[i] & B43_LED_ACTIVELOW);
+			b43_led_turn_off(dev, led->index, led->activelow);
+			led->hw_state = 0;
+			atomic_set(&led->state, 0);
+		}
+	}
+
+	/* Initialize TX/RX/ASSOC leds */
+	led = &dev->wl->leds.led_tx;
+	if (led->wl) {
+		b43_led_turn_off(dev, led->index, led->activelow);
+		led->hw_state = 0;
+		atomic_set(&led->state, 0);
+	}
+	led = &dev->wl->leds.led_rx;
+	if (led->wl) {
+		b43_led_turn_off(dev, led->index, led->activelow);
+		led->hw_state = 0;
+		atomic_set(&led->state, 0);
+	}
+	led = &dev->wl->leds.led_assoc;
+	if (led->wl) {
+		b43_led_turn_off(dev, led->index, led->activelow);
+		led->hw_state = 0;
+		atomic_set(&led->state, 0);
+	}
+
+	/* Initialize other LED states. */
+	for (i = 0; i < B43_MAX_NR_LEDS; i++) {
+		b43_led_get_sprominfo(dev, i, &behaviour, &activelow);
+		switch (behaviour) {
+		case B43_LED_OFF:
+			b43_led_turn_off(dev, i, activelow);
+			break;
+		case B43_LED_ON:
+			b43_led_turn_on(dev, i, activelow);
+			break;
+		default:
+			/* Leave others as-is. */
+			break;
 		}
-		b43_map_led(dev, i, behaviour, activelow);
 	}
 }
 
 void b43_leds_exit(struct b43_wldev *dev)
 {
-	b43_unregister_led(&dev->led_tx);
-	b43_unregister_led(&dev->led_rx);
-	b43_unregister_led(&dev->led_assoc);
-	b43_unregister_led(&dev->led_radio);
+	struct b43_leds *leds = &dev->wl->leds;
+
+	b43_led_turn_off(dev, leds->led_tx.index, leds->led_tx.activelow);
+	b43_led_turn_off(dev, leds->led_rx.index, leds->led_rx.activelow);
+	b43_led_turn_off(dev, leds->led_assoc.index, leds->led_assoc.activelow);
+	b43_led_turn_off(dev, leds->led_radio.index, leds->led_radio.activelow);
+}
+
+void b43_leds_register(struct b43_wldev *dev)
+{
+	unsigned int i;
+	enum b43_led_behaviour behaviour;
+	bool activelow;
+
+	INIT_WORK(&dev->wl->leds.work, b43_leds_work);
+
+	/* Register the LEDs to the LED subsystem. */
+	for (i = 0; i < B43_MAX_NR_LEDS; i++) {
+		b43_led_get_sprominfo(dev, i, &behaviour, &activelow);
+		b43_map_led(dev, i, behaviour, activelow);
+	}
+}
+
+void b43_leds_unregister(struct b43_wldev *dev)
+{
+	struct b43_leds *leds = &dev->wl->leds;
+
+	b43_unregister_led(&leds->led_tx);
+	b43_unregister_led(&leds->led_rx);
+	b43_unregister_led(&leds->led_assoc);
+	b43_unregister_led(&leds->led_radio);
 }
Index: wireless-testing/drivers/net/wireless/b43/leds.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/leds.h	2009-09-11 21:29:20.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/leds.h	2009-09-11 21:29:22.000000000 +0200
@@ -7,12 +7,13 @@ struct b43_wldev;
 
 #include <linux/types.h>
 #include <linux/leds.h>
+#include <linux/workqueue.h>
 
 
 #define B43_LED_MAX_NAME_LEN	31
 
 struct b43_led {
-	struct b43_wldev *dev;
+	struct b43_wl *wl;
 	/* The LED class device */
 	struct led_classdev led_dev;
 	/* The index number of the LED. */
@@ -22,8 +23,23 @@ struct b43_led {
 	bool activelow;
 	/* The unique name string for this LED device. */
 	char name[B43_LED_MAX_NAME_LEN + 1];
+	/* The current status of the LED. This is updated locklessly. */
+	atomic_t state;
+	/* The active state in hardware. */
+	bool hw_state;
 };
 
+struct b43_leds {
+	struct b43_led led_tx;
+	struct b43_led led_rx;
+	struct b43_led led_radio;
+	struct b43_led led_assoc;
+
+	struct work_struct work;
+};
+
+#define B43_MAX_NR_LEDS			4
+
 #define B43_LED_BEHAVIOUR		0x7F
 #define B43_LED_ACTIVELOW		0x80
 /* LED behaviour values */
@@ -42,6 +58,8 @@ enum b43_led_behaviour {
 	B43_LED_INACTIVE,
 };
 
+void b43_leds_register(struct b43_wldev *dev);
+void b43_leds_unregister(struct b43_wldev *dev);
 void b43_leds_init(struct b43_wldev *dev);
 void b43_leds_exit(struct b43_wldev *dev);
 
@@ -49,10 +67,16 @@ void b43_leds_exit(struct b43_wldev *dev
 #else /* CONFIG_B43_LEDS */
 /* LED support disabled */
 
-struct b43_led {
+struct b43_leds {
 	/* empty */
 };
 
+static inline void b43_leds_register(struct b43_wldev *dev)
+{
+}
+static inline void b43_leds_unregister(struct b43_wldev *dev)
+{
+}
 static inline void b43_leds_init(struct b43_wldev *dev)
 {
 }

-- 
Greetings, Michael.
