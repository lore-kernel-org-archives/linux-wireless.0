Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lvs00-fl-n22.ftl.affinity.com ([216.219.253.20]:50506 "EHLO
	lvs00-fl-n22.ftl.affinity.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750830AbXLMF14 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2007 00:27:56 -0500
Received: from [24.234.206.24] ([24.234.206.24]:12190 "HELO localhost")
	by ams022.ftl.affinity.com with SMTP id S673446AbXLMF1x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2007 00:27:53 -0500
Date: Wed, 12 Dec 2007 21:27:33 -0800
From: Larry Finger <Larry.Finger@lwfinger.net>
To: Michael@ams022.ftl.affinity.com
Cc: Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: [PATCH] b43: Fix rfkill radio LED
Message-ID: <4760c2c5.asZDAI81Pdjz49hX%Larry.Finger@lwfinger.net> (sfid-20071213_052805_056116_2A91895B)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael,

I finally found the problem. It turned out that b43_rfkill_soft_toggle()
was returning -EBUSY even when there was no error. I also changed the
logic in the request_module("rfkill-input") section. Now, the code is
only compiled if rfkill-input is not built-in.

AFAIK, it is ready for John, and should be pushed into Linus's tree as
well.

Larry
---

From:	Larry Finger <Larry.Finger@lwfinger.net>

This fixes Bug #9414

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

This patch fixes all of the above.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Michael Buesch <mb@bu3sch.de>

Index: wireless-2.6/drivers/net/wireless/b43/rfkill.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/rfkill.c
+++ wireless-2.6/drivers/net/wireless/b43/rfkill.c
@@ -25,6 +25,8 @@
 #include "rfkill.h"
 #include "b43.h"
 
+#include <linux/kmod.h>
+
 
 /* Returns TRUE, if the radio is enabled in hardware. */
 static bool b43_is_hw_radio_enabled(struct b43_wldev *dev)
@@ -50,7 +52,10 @@ static void b43_rfkill_poll(struct input
 	bool report_change = 0;
 
 	mutex_lock(&wl->mutex);
-	B43_WARN_ON(b43_status(dev) < B43_STAT_INITIALIZED);
+	if (unlikely(b43_status(dev) < B43_STAT_INITIALIZED)) {
+		mutex_unlock(&wl->mutex);
+		return;
+	}
 	enabled = b43_is_hw_radio_enabled(dev);
 	if (unlikely(enabled != dev->radio_hw_enable)) {
 		dev->radio_hw_enable = enabled;
@@ -60,8 +65,12 @@ static void b43_rfkill_poll(struct input
 	}
 	mutex_unlock(&wl->mutex);
 
-	if (unlikely(report_change))
-		input_report_key(poll_dev->input, KEY_WLAN, enabled);
+	/* send the radio switch event to the system - note both a key press
+	 * and a release are required */
+	if (unlikely(report_change)) {
+		input_report_key(poll_dev->input, KEY_WLAN, 1);
+		input_report_key(poll_dev->input, KEY_WLAN, 0);
+	}
 }
 
 /* Called when the RFKILL toggled in software. */
@@ -69,13 +78,15 @@ static int b43_rfkill_soft_toggle(void *
 {
 	struct b43_wldev *dev = data;
 	struct b43_wl *wl = dev->wl;
-	int err = 0;
+	int err = -EBUSY;
 
 	if (!wl->rfkill.registered)
 		return 0;
 
 	mutex_lock(&wl->mutex);
-	B43_WARN_ON(b43_status(dev) < B43_STAT_INITIALIZED);
+	if (b43_status(dev) < B43_STAT_INITIALIZED)
+		goto out_unlock;
+	err = 0;
 	switch (state) {
 	case RFKILL_STATE_ON:
 		if (!dev->radio_hw_enable) {
@@ -133,9 +144,25 @@ void b43_rfkill_init(struct b43_wldev *d
 	rfk->poll_dev->poll = b43_rfkill_poll;
 	rfk->poll_dev->poll_interval = 1000; /* msecs */
 
+	rfk->poll_dev->input->name = rfk->name;
+	rfk->poll_dev->input->id.bustype = BUS_HOST;
+	rfk->poll_dev->input->id.vendor = dev->dev->bus->boardinfo.vendor;
+	rfk->poll_dev->input->evbit[0] = BIT(EV_KEY);
+	set_bit(KEY_WLAN, rfk->poll_dev->input->keybit);
+
 	err = rfkill_register(rfk->rfkill);
 	if (err)
 		goto err_free_polldev;
+
+#ifndef CONFIG_RFKILL_INPUT
+	/* B43 RF-kill isn't useful without the rfkill-input subsystem.
+	 * Try to load the module. */
+	err = request_module("rfkill-input");
+	if (err)
+		b43warn(wl, "Failed to load the rfkill-input module. "
+			"The built-in radio LED will not work.\n");
+#endif /* CONFIG_RFKILL_INPUT */
+
 	err = input_register_polled_device(rfk->poll_dev);
 	if (err)
 		goto err_unreg_rfk;
Index: wireless-2.6/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/main.c
+++ wireless-2.6/drivers/net/wireless/b43/main.c
@@ -2165,7 +2165,6 @@ static void b43_mgmtframe_txantenna(stru
 static void b43_chip_exit(struct b43_wldev *dev)
 {
 	b43_radio_turn_off(dev, 1);
-	b43_leds_exit(dev);
 	b43_gpio_cleanup(dev);
 	/* firmware is released later */
 }
@@ -2193,11 +2192,10 @@ static int b43_chip_init(struct b43_wlde
 	err = b43_gpio_init(dev);
 	if (err)
 		goto out;	/* firmware is released later */
-	b43_leds_init(dev);
 
 	err = b43_upload_initvals(dev);
 	if (err)
-		goto err_leds_exit;
+		goto err_gpio_clean;
 	b43_radio_turn_on(dev);
 
 	b43_write16(dev, 0x03E6, 0x0000);
@@ -2273,8 +2271,7 @@ out:
 
 err_radio_off:
 	b43_radio_turn_off(dev, 1);
-err_leds_exit:
-	b43_leds_exit(dev);
+err_gpio_clean:
 	b43_gpio_cleanup(dev);
 	return err;
 }
@@ -3301,10 +3298,7 @@ static void b43_wireless_core_exit(struc
 		return;
 	b43_set_status(dev, B43_STAT_UNINIT);
 
-	mutex_unlock(&dev->wl->mutex);
-	b43_rfkill_exit(dev);
-	mutex_lock(&dev->wl->mutex);
-
+	b43_leds_exit(dev);
 	b43_rng_exit(dev->wl);
 	b43_pio_free(dev);
 	b43_dma_free(dev);
@@ -3426,12 +3420,12 @@ static int b43_wireless_core_init(struct
 	memset(wl->mac_addr, 0, ETH_ALEN);
 	b43_upload_card_macaddress(dev);
 	b43_security_init(dev);
-	b43_rfkill_init(dev);
 	b43_rng_init(wl);
 
 	b43_set_status(dev, B43_STAT_INITIALIZED);
 
-      out:
+	b43_leds_init(dev);
+out:
 	return err;
 
       err_chip_exit:
@@ -3520,6 +3514,10 @@ static int b43_op_start(struct ieee80211
 	int did_init = 0;
 	int err = 0;
 
+	/* First register RFkill.
+	 * LEDs that are registered later depend on it. */
+	b43_rfkill_init(dev);
+
 	mutex_lock(&wl->mutex);
 
 	if (b43_status(dev) < B43_STAT_INITIALIZED) {
@@ -3549,6 +3547,8 @@ static void b43_op_stop(struct ieee80211
 	struct b43_wl *wl = hw_to_b43_wl(hw);
 	struct b43_wldev *dev = wl->current_dev;
 
+	b43_rfkill_exit(dev);
+
 	mutex_lock(&wl->mutex);
 	if (b43_status(dev) >= B43_STAT_STARTED)
 		b43_wireless_core_stop(dev);
Index: wireless-2.6/drivers/net/wireless/b43/leds.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/leds.c
+++ wireless-2.6/drivers/net/wireless/b43/leds.c
@@ -163,6 +163,9 @@ static void b43_map_led(struct b43_wldev
 		b43_register_led(dev, &dev->led_radio, name,
 				 b43_rfkill_led_name(dev),
 				 led_index, activelow);
+		/* Sync the RF-kill LED state with the switch state. */
+		if (dev->radio_hw_enable)
+			b43_led_turn_on(dev, led_index, activelow);
 		break;
 	case B43_LED_WEIRD:
 	case B43_LED_ASSOC:
@@ -232,4 +235,5 @@ void b43_leds_exit(struct b43_wldev *dev
 	b43_unregister_led(&dev->led_tx);
 	b43_unregister_led(&dev->led_rx);
 	b43_unregister_led(&dev->led_assoc);
+	b43_unregister_led(&dev->led_radio);
 }
