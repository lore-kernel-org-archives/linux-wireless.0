Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:53748 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751037AbXLPRTE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Dec 2007 12:19:04 -0500
Date: Sun, 16 Dec 2007 18:17:10 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <larry.finger@lwfinger.net>
Subject: [PATCH] b43legacy: Fix rfkill radio LED
Message-ID: <20071216181710.0763c186@morte> (sfid-20071216_171916_528733_F007822F)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From:	Larry Finger <Larry.Finger@lwfinger.net>

This fixes Bug #9414 for b43legacy. This patch is the equivalent of one
submitted earlier for b43.

Since addition of the rfkill callback, the LED associated with the off
switch on the radio has not worked for several reasons:

(1) Essential data in the rfkill structure were missing.
(2) The rfkill structure was initialized after the LED initialization.
(3) There was a minor memory leak if the radio LED structure was inited.

Once the above problems were fixed, additional difficulties were noted:

(4) The radio LED was in the wrong state at startup.
(5) The radio switch had to be manipulated twice for each state change.
(6) A circular mutex locking situation existed.
(7) If rfkill-input is built as a module, it is not automatically loaded.

This patch fixes all of the above and removes a couple of sparse warnings.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Stefano Brivio <stefano.brivio@polimi.it>
---

Index: wireless-2.6/drivers/net/wireless/b43legacy/rfkill.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43legacy/rfkill.c
+++ wireless-2.6/drivers/net/wireless/b43legacy/rfkill.c
@@ -26,6 +26,8 @@
 #include "radio.h"
 #include "b43legacy.h"
 
+#include <linux/kmod.h>
+
 
 /* Returns TRUE, if the radio is enabled in hardware. */
 static bool b43legacy_is_hw_radio_enabled(struct b43legacy_wldev *dev)
@@ -51,7 +53,10 @@ static void b43legacy_rfkill_poll(struct
 	bool report_change = 0;
 
 	mutex_lock(&wl->mutex);
-	B43legacy_WARN_ON(b43legacy_status(dev) <
B43legacy_STAT_INITIALIZED);
+	if (unlikely(b43legacy_status(dev) < B43legacy_STAT_INITIALIZED)) {
+		mutex_unlock(&wl->mutex);
+		return;
+	}
 	enabled = b43legacy_is_hw_radio_enabled(dev);
 	if (unlikely(enabled != dev->radio_hw_enable)) {
 		dev->radio_hw_enable = enabled;
@@ -61,8 +66,12 @@ static void b43legacy_rfkill_poll(struct
 	}
 	mutex_unlock(&wl->mutex);
 
-	if (unlikely(report_change))
-		input_report_key(poll_dev->input, KEY_WLAN, enabled);
+	/* send the radio switch event to the system - note both a key
press
+	 * and a release are required */
+	if (unlikely(report_change)) {
+		input_report_key(poll_dev->input, KEY_WLAN, 1);
+		input_report_key(poll_dev->input, KEY_WLAN, 0);
+	}
 }
 
 /* Called when the RFKILL toggled in software.
@@ -71,13 +80,15 @@ static int b43legacy_rfkill_soft_toggle(
 {
 	struct b43legacy_wldev *dev = data;
 	struct b43legacy_wl *wl = dev->wl;
-	int err = 0;
+	int err = -EBUSY;
 
 	if (!wl->rfkill.registered)
 		return 0;
 
 	mutex_lock(&wl->mutex);
-	B43legacy_WARN_ON(b43legacy_status(dev) <
B43legacy_STAT_INITIALIZED);
+	if (b43legacy_status(dev) < B43legacy_STAT_INITIALIZED)
+		goto out_unlock;
+	err = 0;
 	switch (state) {
 	case RFKILL_STATE_ON:
 		if (!dev->radio_hw_enable) {
@@ -103,11 +114,11 @@ out_unlock:
 
 char * b43legacy_rfkill_led_name(struct b43legacy_wldev *dev)
 {
-	struct b43legacy_wl *wl = dev->wl;
+	struct b43legacy_rfkill *rfk = &(dev->wl->rfkill);
 
-	if (!wl->rfkill.rfkill)
+	if (!rfk->registered)
 		return NULL;
-	return rfkill_get_led_name(wl->rfkill.rfkill);
+	return rfkill_get_led_name(rfk->rfkill);
 }
 
 void b43legacy_rfkill_init(struct b43legacy_wldev *dev)
@@ -116,53 +127,13 @@ void b43legacy_rfkill_init(struct b43leg
 	struct b43legacy_rfkill *rfk = &(wl->rfkill);
 	int err;
 
-	if (rfk->rfkill) {
-		err = rfkill_register(rfk->rfkill);
-		if (err) {
-			b43legacywarn(wl, "Failed to register RF-kill
button\n");
-			goto err_free_rfk;
-		}
-	}
-	if (rfk->poll_dev) {
-		err = input_register_polled_device(rfk->poll_dev);
-		if (err) {
-			b43legacywarn(wl, "Failed to register RF-kill
polldev\n");
-			goto err_free_polldev;
-		}
-	}
-
-	return;
-err_free_rfk:
-	rfkill_free(rfk->rfkill);
-	rfk->rfkill = NULL;
-err_free_polldev:
-	input_free_polled_device(rfk->poll_dev);
-	rfk->poll_dev = NULL;
-}
-
-void b43legacy_rfkill_exit(struct b43legacy_wldev *dev)
-{
-	struct b43legacy_rfkill *rfk = &(dev->wl->rfkill);
-
-	if (rfk->poll_dev)
-		input_unregister_polled_device(rfk->poll_dev);
-	if (rfk->rfkill)
-		rfkill_unregister(rfk->rfkill);
-}
-
-void b43legacy_rfkill_alloc(struct b43legacy_wldev *dev)
-{
-	struct b43legacy_wl *wl = dev->wl;
-	struct b43legacy_rfkill *rfk = &(wl->rfkill);
+	rfk->registered = 0;
 
+	rfk->rfkill = rfkill_allocate(dev->dev->dev, RFKILL_TYPE_WLAN);
+	if (!rfk->rfkill)
+		goto out_error;
 	snprintf(rfk->name, sizeof(rfk->name),
 		 "b43legacy-%s", wiphy_name(wl->hw->wiphy));
-
-	rfk->rfkill = rfkill_allocate(dev->dev->dev, RFKILL_TYPE_WLAN);
-	if (!rfk->rfkill) {
-		b43legacywarn(wl, "Failed to allocate RF-kill button\n");
-		return;
-	}
 	rfk->rfkill->name = rfk->name;
 	rfk->rfkill->state = RFKILL_STATE_ON;
 	rfk->rfkill->data = dev;
@@ -170,20 +141,64 @@ void b43legacy_rfkill_alloc(struct b43le
 	rfk->rfkill->user_claim_unsupported = 1;
 
 	rfk->poll_dev = input_allocate_polled_device();
-	if (rfk->poll_dev) {
-		rfk->poll_dev->private = dev;
-		rfk->poll_dev->poll = b43legacy_rfkill_poll;
-		rfk->poll_dev->poll_interval = 1000; /* msecs */
-	} else
-		b43legacywarn(wl, "Failed to allocate RF-kill polldev\n");
+	if (!rfk->poll_dev)
+		goto err_free_rfk;
+	rfk->poll_dev->private = dev;
+	rfk->poll_dev->poll = b43legacy_rfkill_poll;
+	rfk->poll_dev->poll_interval = 1000; /* msecs */
+
+	rfk->poll_dev->input->name = rfk->name;
+	rfk->poll_dev->input->id.bustype = BUS_HOST;
+	rfk->poll_dev->input->id.vendor = dev->dev->bus->boardinfo.vendor;
+	rfk->poll_dev->input->evbit[0] = BIT(EV_KEY);
+	set_bit(KEY_WLAN, rfk->poll_dev->input->keybit);
+
+	err = rfkill_register(rfk->rfkill);
+	if (err)
+		goto err_free_polldev;
+
+#ifdef CONFIG_RFKILL_INPUT_MODULE
+	/* B43legacy RF-kill isn't useful without the rfkill-input
subsystem.
+	 * Try to load the module. */
+	err = request_module("rfkill-input");
+	if (err)
+		b43legacywarn(wl, "Failed to load the rfkill-input module.
"
+			"The built-in radio LED will not work.\n");
+#endif /* CONFIG_RFKILL_INPUT */
+
+	err = input_register_polled_device(rfk->poll_dev);
+	if (err)
+		goto err_unreg_rfk;
+
+	rfk->registered = 1;
+
+	return;
+err_unreg_rfk:
+	rfkill_unregister(rfk->rfkill);
+err_free_polldev:
+	input_free_polled_device(rfk->poll_dev);
+	rfk->poll_dev = NULL;
+err_free_rfk:
+	rfkill_free(rfk->rfkill);
+	rfk->rfkill = NULL;
+out_error:
+	rfk->registered = 0;
+	b43legacywarn(wl, "RF-kill button init failed\n");
 }
 
-void b43legacy_rfkill_free(struct b43legacy_wldev *dev)
+void b43legacy_rfkill_exit(struct b43legacy_wldev *dev)
 {
 	struct b43legacy_rfkill *rfk = &(dev->wl->rfkill);
 
+	if (!rfk->registered)
+		return;
+	rfk->registered = 0;
+
+	input_unregister_polled_device(rfk->poll_dev);
+	rfkill_unregister(rfk->rfkill);
 	input_free_polled_device(rfk->poll_dev);
 	rfk->poll_dev = NULL;
 	rfkill_free(rfk->rfkill);
 	rfk->rfkill = NULL;
 }
+
Index: wireless-2.6/drivers/net/wireless/b43legacy/leds.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43legacy/leds.c
+++ wireless-2.6/drivers/net/wireless/b43legacy/leds.c
@@ -165,6 +165,9 @@ static void b43legacy_map_led(struct b43
 		b43legacy_register_led(dev, &dev->led_radio, name,
 				 b43legacy_rfkill_led_name(dev),
 				 led_index, activelow);
+		/* Sync the RF-kill LED state with the switch state. */
+		if (dev->radio_hw_enable)
+			b43legacy_led_turn_on(dev, led_index, activelow);
 		break;
 	case B43legacy_LED_WEIRD:
 	case B43legacy_LED_ASSOC:
@@ -234,4 +237,5 @@ void b43legacy_leds_exit(struct b43legac
 	b43legacy_unregister_led(&dev->led_tx);
 	b43legacy_unregister_led(&dev->led_rx);
 	b43legacy_unregister_led(&dev->led_assoc);
+	b43legacy_unregister_led(&dev->led_radio);
 }
Index: wireless-2.6/drivers/net/wireless/b43legacy/main.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43legacy/main.c
+++ wireless-2.6/drivers/net/wireless/b43legacy/main.c
@@ -1999,7 +1999,6 @@ static void b43legacy_mgmtframe_txantenn
 static void b43legacy_chip_exit(struct b43legacy_wldev *dev)
 {
 	b43legacy_radio_turn_off(dev, 1);
-	b43legacy_leds_exit(dev);
 	b43legacy_gpio_cleanup(dev);
 	/* firmware is released later */
 }
@@ -2029,11 +2028,10 @@ static int b43legacy_chip_init(struct b4
 	err = b43legacy_gpio_init(dev);
 	if (err)
 		goto out; /* firmware is released later */
-	b43legacy_leds_init(dev);
 
 	err = b43legacy_upload_initvals(dev);
 	if (err)
-		goto err_leds_exit;
+		goto err_gpio_clean;
 	b43legacy_radio_turn_on(dev);
 
 	b43legacy_write16(dev, 0x03E6, 0x0000);
@@ -2115,8 +2113,7 @@ out:
 
 err_radio_off:
 	b43legacy_radio_turn_off(dev, 1);
-err_leds_exit:
-	b43legacy_leds_exit(dev);
+err_gpio_clean:
 	b43legacy_gpio_cleanup(dev);
 	goto out;
 }
@@ -2973,10 +2970,7 @@ static void b43legacy_wireless_core_exit
 	cancel_work_sync(&dev->restart_work);
 	mutex_lock(&wl->mutex);
 
-	mutex_unlock(&dev->wl->mutex);
-	b43legacy_rfkill_exit(dev);
-	mutex_lock(&dev->wl->mutex);
-
+	b43legacy_leds_exit(dev);
 	b43legacy_rng_exit(dev->wl);
 	b43legacy_pio_free(dev);
 	b43legacy_dma_free(dev);
@@ -3142,11 +3136,11 @@ static int b43legacy_wireless_core_init(
 	memset(wl->mac_addr, 0, ETH_ALEN);
 	b43legacy_upload_card_macaddress(dev);
 	b43legacy_security_init(dev);
-	b43legacy_rfkill_init(dev);
 	b43legacy_rng_init(wl);
 
 	b43legacy_set_status(dev, B43legacy_STAT_INITIALIZED);
 
+	b43legacy_leds_init(dev);
 out:
 	return err;
 
@@ -3235,6 +3229,10 @@ static int b43legacy_op_start(struct iee
 	int did_init = 0;
 	int err = 0;
 
+	/* First register RFkill.
+	 * LEDs that are registered later depend on it. */
+	b43legacy_rfkill_init(dev);
+
 	mutex_lock(&wl->mutex);
 
 	if (b43legacy_status(dev) < B43legacy_STAT_INITIALIZED) {
@@ -3264,6 +3262,8 @@ static void b43legacy_op_stop(struct iee
 	struct b43legacy_wl *wl = hw_to_b43legacy_wl(hw);
 	struct b43legacy_wldev *dev = wl->current_dev;
 
+	b43legacy_rfkill_exit(dev);
+
 	mutex_lock(&wl->mutex);
 	if (b43legacy_status(dev) >= B43legacy_STAT_STARTED)
 		b43legacy_wireless_core_stop(dev);


-- 
Ciao
Stefano
