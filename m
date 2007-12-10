Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lvs00-fl-n18.ftl.affinity.com ([216.219.253.56]:44095 "EHLO
	lvs00-fl-n18.ftl.affinity.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753231AbXLJTRl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2007 14:17:41 -0500
Received: from [24.234.206.24] ([24.234.206.24]:4250 "HELO localhost")
	by ams018.ftl.affinity.com with SMTP id S450715AbXLJTRh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2007 14:17:37 -0500
Date: Mon, 10 Dec 2007 11:17:34 -0800
From: Larry Finger <Larry.Finger@lwfinger.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: [RFC V3] b43: Fix rfkill radio LED
Message-ID: <475d90ce.sPlOhTt+8EwSo+ue%Larry.Finger@lwfinger.net> (sfid-20071210_191745_606550_C974D52E)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

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
---

Michael,

This material is intended for wireless-2.6; however, it is a fix for Bug #9414
reported for 2.6.24. Once you clear up the locking situation, this patch should
be pushed into mainline. Note: In mainline, the patch has offsets and one hunk
has some fuzz, but it applies correctly.

Larry
---

 leds.c   |    3 ++-
 leds.h   |    2 ++
 main.c   |   24 +++++++++++++++---------
 rfkill.c |   21 +++++++++++++++++++--
 4 files changed, 38 insertions(+), 12 deletions(-)

---
Index: wireless-2.6/drivers/net/wireless/b43/rfkill.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/rfkill.c
+++ wireless-2.6/drivers/net/wireless/b43/rfkill.c
@@ -60,8 +60,12 @@ static void b43_rfkill_poll(struct input
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
@@ -133,9 +137,22 @@ void b43_rfkill_init(struct b43_wldev *d
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
+	/* This code doesn't work without rfkill-input - if it is a module, be
+	 * sure it is loaded here. If built-in or not available, an error will
+	 * result. Just log an appropriate message */
+	err = request_module("rfkill-input");
+	if (err)
+		printk(KERN_INFO "b43: rfkill-input is not available as a"
+		       "module. If not built-in, the radio LED will fail\n");
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
@@ -2279,8 +2277,7 @@ out:
 
 err_radio_off:
 	b43_radio_turn_off(dev, 1);
-err_leds_exit:
-	b43_leds_exit(dev);
+err_gpio_clean:
 	b43_gpio_cleanup(dev);
 	return err;
 }
@@ -2718,7 +2715,7 @@ static int b43_antenna_from_ieee80211(u8
 static int b43_op_config(struct ieee80211_hw *hw, struct ieee80211_conf *conf)
 {
 	struct b43_wl *wl = hw_to_b43_wl(hw);
-	struct b43_wldev *dev;
+	struct b43_wldev *uninitialized_var(dev);
 	struct b43_phy *phy;
 	unsigned long flags;
 	unsigned int new_phymode = 0xFFFF;
@@ -3305,6 +3302,7 @@ static void b43_wireless_core_exit(struc
 	b43_rfkill_exit(dev);
 	mutex_lock(&dev->wl->mutex);
 
+	b43_leds_exit(dev);
 	b43_rng_exit(dev->wl);
 	b43_pio_free(dev);
 	b43_dma_free(dev);
@@ -3426,12 +3424,20 @@ static int b43_wireless_core_init(struct
 	memset(wl->mac_addr, 0, ETH_ALEN);
 	b43_upload_card_macaddress(dev);
 	b43_security_init(dev);
-	b43_rfkill_init(dev);
 	b43_rng_init(wl);
-
 	b43_set_status(dev, B43_STAT_INITIALIZED);
 
-      out:
+	mutex_unlock(&dev->wl->mutex);
+	b43_rfkill_init(dev);
+	mutex_lock(&dev->wl->mutex);
+	b43_leds_init(dev);
+	/* if an LED is associated with the rfkill switch,
+	 * and the hardware radio enable switch is on, now is the
+	 * time to turn that LED on */
+	if (dev->led_radio.dev && dev->radio_hw_enable)
+		b43_led_turn_on(dev, dev->led_radio.index,
+				dev->led_radio.activelow);
+out:
 	return err;
 
       err_chip_exit:
Index: wireless-2.6/drivers/net/wireless/b43/leds.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/leds.c
+++ wireless-2.6/drivers/net/wireless/b43/leds.c
@@ -30,7 +30,7 @@
 #include "leds.h"
 
 
-static void b43_led_turn_on(struct b43_wldev *dev, u8 led_index,
+void b43_led_turn_on(struct b43_wldev *dev, u8 led_index,
 			    bool activelow)
 {
 	struct b43_wl *wl = dev->wl;
@@ -232,4 +232,5 @@ void b43_leds_exit(struct b43_wldev *dev
 	b43_unregister_led(&dev->led_tx);
 	b43_unregister_led(&dev->led_rx);
 	b43_unregister_led(&dev->led_assoc);
+	b43_unregister_led(&dev->led_radio);
 }
Index: wireless-2.6/drivers/net/wireless/b43/leds.h
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/leds.h
+++ wireless-2.6/drivers/net/wireless/b43/leds.h
@@ -44,6 +44,8 @@ enum b43_led_behaviour {
 
 void b43_leds_init(struct b43_wldev *dev);
 void b43_leds_exit(struct b43_wldev *dev);
+void b43_led_turn_on(struct b43_wldev *dev, u8 led_index,
+			    bool activelow);
 
 
 #else /* CONFIG_B43_LEDS */
