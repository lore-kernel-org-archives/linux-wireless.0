Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:45413 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755179AbXK1Xsn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2007 18:48:43 -0500
Date: Wed, 28 Nov 2007 17:48:40 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>
Cc: Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: [PATCH] b43: Fix radio LED problem
Message-ID: <474dfe58.85Rcj/BwOPxQm8eE%Larry.Finger@lwfinger.net> (sfid-20071128_234849_744954_A7B3B166)
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

This patch fixes all of the above.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John and Michael,

These changes are mostly obvious. The most complicated is the fixing of the
circular locking between the rfkill and wl_dev mutexes. This was acomplished
by moving the rfkill_init() call to the beginning of b43_op_start() and the
rfkill_exit() call to the end of b43_op_stop().

Techically, these changes are fixes for the radio LED regression between
bcm43xx and b43. It doesn't matter to me if they are pushed into 2.6.24, or
left for 2.6.25.

Larry
---

 leds.c   |    1 +
 main.c   |   25 +++++++++++++++----------
 rfkill.c |   14 ++++++++++++--
 3 files changed, 28 insertions(+), 12 deletions(-)


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
@@ -133,6 +137,12 @@ void b43_rfkill_init(struct b43_wldev *d
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
Index: wireless-2.6/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/main.c
+++ wireless-2.6/drivers/net/wireless/b43/main.c
@@ -2156,7 +2156,6 @@ static void b43_mgmtframe_txantenna(stru
 static void b43_chip_exit(struct b43_wldev *dev)
 {
 	b43_radio_turn_off(dev, 1);
-	b43_leds_exit(dev);
 	b43_gpio_cleanup(dev);
 	/* firmware is released later */
 }
@@ -2184,11 +2183,10 @@ static int b43_chip_init(struct b43_wlde
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
@@ -2267,8 +2265,7 @@ out:
 
 err_radio_off:
 	b43_radio_turn_off(dev, 1);
-err_leds_exit:
-	b43_leds_exit(dev);
+err_gpio_clean:
 	b43_gpio_cleanup(dev);
 	return err;
 }
@@ -2703,7 +2700,8 @@ static int b43_antenna_from_ieee80211(u8
 static int b43_op_config(struct ieee80211_hw *hw, struct ieee80211_conf *conf)
 {
 	struct b43_wl *wl = hw_to_b43_wl(hw);
-	struct b43_wldev *dev;
+	struct b43_rfkill *rfk = &(wl->rfkill);
+	struct b43_wldev *uninitialized_var(dev);
 	struct b43_phy *phy;
 	unsigned long flags;
 	unsigned int new_phymode = 0xFFFF;
@@ -2802,6 +2800,13 @@ static int b43_op_config(struct ieee8021
       out_unlock_mutex:
 	mutex_unlock(&wl->mutex);
 
+	/* if a LED is devoted to the radio and the switch is on, send
+	 * KEY_WLAN press/release keystrokes */
+	if (!err && dev->radio_hw_enable && &dev->led_radio) {
+		input_report_key(rfk->poll_dev->input, KEY_WLAN, 1);
+		input_report_key(rfk->poll_dev->input, KEY_WLAN, 0);
+	}
+
 	return err;
 }
 
@@ -3284,9 +3289,7 @@ static void b43_wireless_core_exit(struc
 		return;
 	b43_set_status(dev, B43_STAT_UNINIT);
 
-	mutex_unlock(&dev->wl->mutex);
-	b43_rfkill_exit(dev);
-	mutex_lock(&dev->wl->mutex);
+	b43_leds_exit(dev);
 
 	b43_rng_exit(dev->wl);
 	b43_pio_free(dev);
@@ -3409,8 +3412,8 @@ static int b43_wireless_core_init(struct
 	memset(wl->mac_addr, 0, ETH_ALEN);
 	b43_upload_card_macaddress(dev);
 	b43_security_init(dev);
-	b43_rfkill_init(dev);
 	b43_rng_init(wl);
+	b43_leds_init(dev);
 
 	b43_set_status(dev, B43_STAT_INITIALIZED);
 
@@ -3503,6 +3506,7 @@ static int b43_op_start(struct ieee80211
 	int did_init = 0;
 	int err = 0;
 
+	b43_rfkill_init(dev);
 	mutex_lock(&wl->mutex);
 
 	if (b43_status(dev) < B43_STAT_INITIALIZED) {
@@ -3537,6 +3541,7 @@ static void b43_op_stop(struct ieee80211
 		b43_wireless_core_stop(dev);
 	b43_wireless_core_exit(dev);
 	mutex_unlock(&wl->mutex);
+	b43_rfkill_exit(dev);
 }
 
 static int b43_op_set_retry_limit(struct ieee80211_hw *hw,
Index: wireless-2.6/drivers/net/wireless/b43/leds.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/leds.c
+++ wireless-2.6/drivers/net/wireless/b43/leds.c
@@ -232,4 +232,5 @@ void b43_leds_exit(struct b43_wldev *dev
 	b43_unregister_led(&dev->led_tx);
 	b43_unregister_led(&dev->led_rx);
 	b43_unregister_led(&dev->led_assoc);
+	b43_unregister_led(&dev->led_radio);
 }
