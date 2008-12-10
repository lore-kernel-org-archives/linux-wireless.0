Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cavan.codon.org.uk ([93.93.128.6]:50282 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949AbYLJPJk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Dec 2008 10:09:40 -0500
Date: Wed, 10 Dec 2008 15:09:35 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
Cc: hmh@hmh.eng.br
Subject: [RFC] b43: rework rfkill code
Message-ID: <20081210150935.GA10927@srcf.ucam.org> (sfid-20081210_160955_698729_A777A57C)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I've reworked the rfkill code in b43. This ought to be more consistent 
with the other drivers and it seems to work on the machines I've tested 
it on here, but it'd be good to get some feedback.

Firstly, I've replaced the polled input device. It's just some delayed 
work now. It polls the hardware every second to determine whether the 
radio has been hardware killed or not. If it has, it sets the rfkill 
state to HARD_BLOCKED. If the radio is enabled and the previous state 
was HARD_BLOCKED, it resets the state to UNBLOCKED. If the radio is 
enabled and the previous state was SOFT_BLOCKED, it leaves the state as 
is.

I also removed some of the complexity from the rfkill toggle function, 
since the rfkill core will handle the case of the user requesting a 
change from HARD_BLOCKED without the driver needing to care.

The final change is that I removed the code for changing the wireless 
state in response to the txpower configuration in mac80211. Right now, I 
can't see any way for this to work correctly - if the user disables the 
radio via rfkill, mac80211 doesn't flag the radio as disabled. As a 
result, the next time the configuration callback is called, b43 
reenables the radio again, even though the user has explicitly disabled 
it. I don't think any of the other drivers handle this case, so I'm not 
really sure what the best way to handle this in future is. The current 
situation certainly seems broken.

How does this look to people?

diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index c34c589..9231eea 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -3384,21 +3384,6 @@ static int b43_op_config(struct ieee80211_hw *hw, u32 changed)
 	    b43_is_mode(wl, NL80211_IFTYPE_MESH_POINT))
 		b43_set_beacon_int(dev, conf->beacon_int);
 
-	if (!!conf->radio_enabled != phy->radio_on) {
-		if (conf->radio_enabled) {
-			b43_software_rfkill(dev, RFKILL_STATE_UNBLOCKED);
-			b43info(dev->wl, "Radio turned on by software\n");
-			if (!dev->radio_hw_enable) {
-				b43info(dev->wl, "The hardware RF-kill button "
-					"still turns the radio physically off. "
-					"Press the button to turn it on.\n");
-			}
-		} else {
-			b43_software_rfkill(dev, RFKILL_STATE_SOFT_BLOCKED);
-			b43info(dev->wl, "Radio turned off by software\n");
-		}
-	}
-
 	spin_lock_irqsave(&wl->irq_lock, flags);
 	b43_interrupt_enable(dev, savedirqs);
 	mmiowb();
diff --git a/drivers/net/wireless/b43/rfkill.c b/drivers/net/wireless/b43/rfkill.c
index 7137537..4c2907f 100644
--- a/drivers/net/wireless/b43/rfkill.c
+++ b/drivers/net/wireless/b43/rfkill.c
@@ -28,7 +28,6 @@
 
 #include <linux/kmod.h>
 
-
 /* Returns TRUE, if the radio is enabled in hardware. */
 static bool b43_is_hw_radio_enabled(struct b43_wldev *dev)
 {
@@ -45,33 +44,43 @@ static bool b43_is_hw_radio_enabled(struct b43_wldev *dev)
 }
 
 /* The poll callback for the hardware button. */
-static void b43_rfkill_poll(struct input_polled_dev *poll_dev)
+static void b43_rfkill_poll(struct work_struct *work)
 {
-	struct b43_wldev *dev = poll_dev->private;
+	struct b43_rfkill *rfk = container_of(work, struct b43_rfkill,
+					      work.work);
+	struct b43_wldev *dev = rfk->rfkill->data;
 	struct b43_wl *wl = dev->wl;
 	bool enabled;
-	bool report_change = 0;
 
 	mutex_lock(&wl->mutex);
-	if (unlikely(b43_status(dev) < B43_STAT_INITIALIZED)) {
-		mutex_unlock(&wl->mutex);
-		return;
-	}
+
+	if (unlikely(b43_status(dev) < B43_STAT_INITIALIZED))
+		goto out_unlock;
+
 	enabled = b43_is_hw_radio_enabled(dev);
 	if (unlikely(enabled != dev->radio_hw_enable)) {
+		/*
+		 *  If the hardware is enabled and the state isn't
+		 *  hard blocked then we're soft blocked and shouldn't
+		 *  change the state
+		 */
+		if (enabled && rfk->rfkill->state != RFKILL_STATE_HARD_BLOCKED)
+			goto out_unlock;
+
 		dev->radio_hw_enable = enabled;
-		report_change = 1;
+
+		if (enabled)
+			rfkill_force_state(rfk->rfkill, RFKILL_STATE_UNBLOCKED);
+		else
+			rfkill_force_state(rfk->rfkill,
+					   RFKILL_STATE_HARD_BLOCKED);
+
 		b43info(wl, "Radio hardware status changed to %s\n",
 			enabled ? "ENABLED" : "DISABLED");
 	}
+out_unlock:
 	mutex_unlock(&wl->mutex);
-
-	/* send the radio switch event to the system - note both a key press
-	 * and a release are required */
-	if (unlikely(report_change)) {
-		input_report_key(poll_dev->input, KEY_WLAN, 1);
-		input_report_key(poll_dev->input, KEY_WLAN, 0);
-	}
+	schedule_delayed_work(&rfk->work, msecs_to_jiffies(1000));
 }
 
 /* Called when the RFKILL toggled in software. */
@@ -87,26 +96,9 @@ static int b43_rfkill_soft_toggle(void *data, enum rfkill_state state)
 	mutex_lock(&wl->mutex);
 	if (b43_status(dev) < B43_STAT_INITIALIZED)
 		goto out_unlock;
+
 	err = 0;
-	switch (state) {
-	case RFKILL_STATE_UNBLOCKED:
-		if (!dev->radio_hw_enable) {
-			/* No luck. We can't toggle the hardware RF-kill
-			 * button from software. */
-			err = -EBUSY;
-			goto out_unlock;
-		}
-		if (!dev->phy.radio_on)
-			b43_software_rfkill(dev, state);
-		break;
-	case RFKILL_STATE_SOFT_BLOCKED:
-		if (dev->phy.radio_on)
-			b43_software_rfkill(dev, state);
-		break;
-	default:
-		b43warn(wl, "Received unexpected rfkill state %d.\n", state);
-		break;
-	}
+	b43_software_rfkill(dev, state);
 out_unlock:
 	mutex_unlock(&wl->mutex);
 
@@ -141,52 +133,17 @@ void b43_rfkill_init(struct b43_wldev *dev)
 	rfk->rfkill->toggle_radio = b43_rfkill_soft_toggle;
 	rfk->rfkill->user_claim_unsupported = 1;
 
-	rfk->poll_dev = input_allocate_polled_device();
-	if (!rfk->poll_dev) {
-		rfkill_free(rfk->rfkill);
-		goto err_freed_rfk;
-	}
-
-	rfk->poll_dev->private = dev;
-	rfk->poll_dev->poll = b43_rfkill_poll;
-	rfk->poll_dev->poll_interval = 1000; /* msecs */
-
-	rfk->poll_dev->input->name = rfk->name;
-	rfk->poll_dev->input->id.bustype = BUS_HOST;
-	rfk->poll_dev->input->id.vendor = dev->dev->bus->boardinfo.vendor;
-	rfk->poll_dev->input->evbit[0] = BIT(EV_KEY);
-	set_bit(KEY_WLAN, rfk->poll_dev->input->keybit);
-
 	err = rfkill_register(rfk->rfkill);
-	if (err)
-		goto err_free_polldev;
 
-#ifdef CONFIG_RFKILL_INPUT_MODULE
-	/* B43 RF-kill isn't useful without the rfkill-input subsystem.
-	 * Try to load the module. */
-	err = request_module("rfkill-input");
 	if (err)
-		b43warn(wl, "Failed to load the rfkill-input module. "
-			"The built-in radio LED will not work.\n");
-#endif /* CONFIG_RFKILL_INPUT */
-
-#if !defined(CONFIG_RFKILL_INPUT) && !defined(CONFIG_RFKILL_INPUT_MODULE)
-	b43warn(wl, "The rfkill-input subsystem is not available. "
-		"The built-in radio LED will not work.\n");
-#endif
-
-	err = input_register_polled_device(rfk->poll_dev);
-	if (err)
-		goto err_unreg_rfk;
+		goto err_freed_rfk;
 
 	rfk->registered = 1;
 
+	INIT_DELAYED_WORK(&rfk->work, b43_rfkill_poll);
+	schedule_delayed_work(&rfk->work, msecs_to_jiffies(1000));
+
 	return;
-err_unreg_rfk:
-	rfkill_unregister(rfk->rfkill);
-err_free_polldev:
-	input_free_polled_device(rfk->poll_dev);
-	rfk->poll_dev = NULL;
 err_freed_rfk:
 	rfk->rfkill = NULL;
 out_error:
@@ -202,9 +159,8 @@ void b43_rfkill_exit(struct b43_wldev *dev)
 		return;
 	rfk->registered = 0;
 
-	input_unregister_polled_device(rfk->poll_dev);
+	cancel_delayed_work_sync(&rfk->work);
+
 	rfkill_unregister(rfk->rfkill);
-	input_free_polled_device(rfk->poll_dev);
-	rfk->poll_dev = NULL;
 	rfk->rfkill = NULL;
 }
diff --git a/drivers/net/wireless/b43/rfkill.h b/drivers/net/wireless/b43/rfkill.h
index adacf93..4efdb4a 100644
--- a/drivers/net/wireless/b43/rfkill.h
+++ b/drivers/net/wireless/b43/rfkill.h
@@ -13,8 +13,8 @@ struct b43_wldev;
 struct b43_rfkill {
 	/* The RFKILL subsystem data structure */
 	struct rfkill *rfkill;
-	/* The poll device for the RFKILL input button */
-	struct input_polled_dev *poll_dev;
+	/* The work queue for the RFKILL input button */
+	struct delayed_work work;
 	/* Did initialization succeed? Used for freeing. */
 	bool registered;
 	/* The unique name of this rfkill switch */


-- 
Matthew Garrett | mjg59@srcf.ucam.org
