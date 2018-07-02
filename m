Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:53047 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752769AbeGBUGJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 2 Jul 2018 16:06:09 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?=
        <u.kleine-koenig@pengutronix.de>
To: Jacek Anaszewski <jacek.anaszewski@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>, kernel@pengutronix.de,
        linux-leds@vger.kernel.org, kernel-patch-test@lists.linaro.org,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-bluetooth@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v7 02/16] leds: triggers: let struct led_trigger::activate() return an error code
Date: Mon,  2 Jul 2018 22:05:21 +0200
Message-Id: <20180702200535.1337-2-u.kleine-koenig@pengutronix.de> (sfid-20180702_220615_249923_E7612A44)
In-Reply-To: <a9b3548b-09c4-fae4-1bce-abf3392b9ceb@gmail.com>
References: <a9b3548b-09c4-fae4-1bce-abf3392b9ceb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Given that activating a trigger can fail, let the callback return an
indication. This prevents to have a trigger active according to the
"trigger" sysfs attribute but not functional.

All users are changed accordingly to return 0 for now. There is no intended
change in behaviour.

Acked-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/leds/led-triggers.c               | 24 ++++++++++++++++++++---
 drivers/leds/trigger/ledtrig-activity.c   |  8 +++++---
 drivers/leds/trigger/ledtrig-backlight.c  |  8 +++++---
 drivers/leds/trigger/ledtrig-default-on.c |  3 ++-
 drivers/leds/trigger/ledtrig-gpio.c       |  8 +++++---
 drivers/leds/trigger/ledtrig-heartbeat.c  |  8 +++++---
 drivers/leds/trigger/ledtrig-netdev.c     |  8 +++++---
 drivers/leds/trigger/ledtrig-oneshot.c    |  8 +++++---
 drivers/leds/trigger/ledtrig-timer.c      |  8 +++++---
 drivers/leds/trigger/ledtrig-transient.c  |  8 +++++---
 drivers/tty/vt/keyboard.c                 |  4 +++-
 drivers/usb/core/ledtrig-usbport.c        |  7 ++++---
 include/linux/leds.h                      | 14 ++++++++-----
 net/bluetooth/leds.c                      |  6 ++++--
 net/mac80211/led.c                        | 20 ++++++++++++++-----
 net/rfkill/core.c                         |  4 +++-
 16 files changed, 101 insertions(+), 45 deletions(-)

diff --git a/drivers/leds/led-triggers.c b/drivers/leds/led-triggers.c
index 431123b048a2..a8786f4b3453 100644
--- a/drivers/leds/led-triggers.c
+++ b/drivers/leds/led-triggers.c
@@ -103,15 +103,16 @@ ssize_t led_trigger_show(struct device *dev, struct device_attribute *attr,
 EXPORT_SYMBOL_GPL(led_trigger_show);
 
 /* Caller must ensure led_cdev->trigger_lock held */
-void led_trigger_set(struct led_classdev *led_cdev, struct led_trigger *trig)
+int led_trigger_set(struct led_classdev *led_cdev, struct led_trigger *trig)
 {
 	unsigned long flags;
 	char *event = NULL;
 	char *envp[2];
 	const char *name;
+	int ret;
 
 	if (!led_cdev->trigger && !trig)
-		return;
+		return 0;
 
 	name = trig ? trig->name : "none";
 	event = kasprintf(GFP_KERNEL, "TRIGGER=%s", name);
@@ -134,8 +135,14 @@ void led_trigger_set(struct led_classdev *led_cdev, struct led_trigger *trig)
 		list_add_tail(&led_cdev->trig_list, &trig->led_cdevs);
 		write_unlock_irqrestore(&trig->leddev_list_lock, flags);
 		led_cdev->trigger = trig;
+
 		if (trig->activate)
-			trig->activate(led_cdev);
+			ret = trig->activate(led_cdev);
+		else
+			ret = 0;
+
+		if (ret)
+			goto err_activate;
 	}
 
 	if (event) {
@@ -146,6 +153,17 @@ void led_trigger_set(struct led_classdev *led_cdev, struct led_trigger *trig)
 				"%s: Error sending uevent\n", __func__);
 		kfree(event);
 	}
+
+	return 0;
+
+err_activate:
+	led_cdev->trigger = NULL;
+	write_lock_irqsave(&led_cdev->trigger->leddev_list_lock, flags);
+	list_del(&led_cdev->trig_list);
+	write_unlock_irqrestore(&led_cdev->trigger->leddev_list_lock, flags);
+	led_set_brightness(led_cdev, LED_OFF);
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(led_trigger_set);
 
diff --git a/drivers/leds/trigger/ledtrig-activity.c b/drivers/leds/trigger/ledtrig-activity.c
index b39e1bb9a9ec..2fc065fb1754 100644
--- a/drivers/leds/trigger/ledtrig-activity.c
+++ b/drivers/leds/trigger/ledtrig-activity.c
@@ -178,20 +178,20 @@ static ssize_t led_invert_store(struct device *dev,
 
 static DEVICE_ATTR(invert, 0644, led_invert_show, led_invert_store);
 
-static void activity_activate(struct led_classdev *led_cdev)
+static int activity_activate(struct led_classdev *led_cdev)
 {
 	struct activity_data *activity_data;
 	int rc;
 
 	activity_data = kzalloc(sizeof(*activity_data), GFP_KERNEL);
 	if (!activity_data)
-		return;
+		return 0;
 
 	led_cdev->trigger_data = activity_data;
 	rc = device_create_file(led_cdev->dev, &dev_attr_invert);
 	if (rc) {
 		kfree(led_cdev->trigger_data);
-		return;
+		return 0;
 	}
 
 	activity_data->led_cdev = led_cdev;
@@ -201,6 +201,8 @@ static void activity_activate(struct led_classdev *led_cdev)
 	led_activity_function(&activity_data->timer);
 	set_bit(LED_BLINK_SW, &led_cdev->work_flags);
 	led_cdev->activated = true;
+
+	return 0;
 }
 
 static void activity_deactivate(struct led_classdev *led_cdev)
diff --git a/drivers/leds/trigger/ledtrig-backlight.c b/drivers/leds/trigger/ledtrig-backlight.c
index 1ca1f1608f76..84512960d630 100644
--- a/drivers/leds/trigger/ledtrig-backlight.c
+++ b/drivers/leds/trigger/ledtrig-backlight.c
@@ -97,7 +97,7 @@ static ssize_t bl_trig_invert_store(struct device *dev,
 }
 static DEVICE_ATTR(inverted, 0644, bl_trig_invert_show, bl_trig_invert_store);
 
-static void bl_trig_activate(struct led_classdev *led)
+static int bl_trig_activate(struct led_classdev *led)
 {
 	int ret;
 
@@ -107,7 +107,7 @@ static void bl_trig_activate(struct led_classdev *led)
 	led->trigger_data = n;
 	if (!n) {
 		dev_err(led->dev, "unable to allocate backlight trigger\n");
-		return;
+		return 0;
 	}
 
 	ret = device_create_file(led->dev, &dev_attr_inverted);
@@ -124,11 +124,13 @@ static void bl_trig_activate(struct led_classdev *led)
 		dev_err(led->dev, "unable to register backlight trigger\n");
 	led->activated = true;
 
-	return;
+	return 0;
 
 err_invert:
 	led->trigger_data = NULL;
 	kfree(n);
+
+	return 0;
 }
 
 static void bl_trig_deactivate(struct led_classdev *led)
diff --git a/drivers/leds/trigger/ledtrig-default-on.c b/drivers/leds/trigger/ledtrig-default-on.c
index 4ccea04b7a6b..2996fe672198 100644
--- a/drivers/leds/trigger/ledtrig-default-on.c
+++ b/drivers/leds/trigger/ledtrig-default-on.c
@@ -16,9 +16,10 @@
 #include <linux/leds.h>
 #include "../leds.h"
 
-static void defon_trig_activate(struct led_classdev *led_cdev)
+static int defon_trig_activate(struct led_classdev *led_cdev)
 {
 	led_set_brightness_nosleep(led_cdev, led_cdev->max_brightness);
+	return 0;
 }
 
 static struct led_trigger defon_led_trigger = {
diff --git a/drivers/leds/trigger/ledtrig-gpio.c b/drivers/leds/trigger/ledtrig-gpio.c
index 93906a17a4b6..f5358c40d03f 100644
--- a/drivers/leds/trigger/ledtrig-gpio.c
+++ b/drivers/leds/trigger/ledtrig-gpio.c
@@ -162,14 +162,14 @@ static ssize_t gpio_trig_gpio_store(struct device *dev,
 }
 static DEVICE_ATTR(gpio, 0644, gpio_trig_gpio_show, gpio_trig_gpio_store);
 
-static void gpio_trig_activate(struct led_classdev *led)
+static int gpio_trig_activate(struct led_classdev *led)
 {
 	struct gpio_trig_data *gpio_data;
 	int ret;
 
 	gpio_data = kzalloc(sizeof(*gpio_data), GFP_KERNEL);
 	if (!gpio_data)
-		return;
+		return 0;
 
 	ret = device_create_file(led->dev, &dev_attr_gpio);
 	if (ret)
@@ -187,7 +187,7 @@ static void gpio_trig_activate(struct led_classdev *led)
 	led->trigger_data = gpio_data;
 	led->activated = true;
 
-	return;
+	return 0;
 
 err_brightness:
 	device_remove_file(led->dev, &dev_attr_inverted);
@@ -197,6 +197,8 @@ static void gpio_trig_activate(struct led_classdev *led)
 
 err_gpio:
 	kfree(gpio_data);
+
+	return 0;
 }
 
 static void gpio_trig_deactivate(struct led_classdev *led)
diff --git a/drivers/leds/trigger/ledtrig-heartbeat.c b/drivers/leds/trigger/ledtrig-heartbeat.c
index 304b929edb8e..03a8dfce8fb9 100644
--- a/drivers/leds/trigger/ledtrig-heartbeat.c
+++ b/drivers/leds/trigger/ledtrig-heartbeat.c
@@ -121,21 +121,21 @@ static ssize_t led_invert_store(struct device *dev,
 
 static DEVICE_ATTR(invert, 0644, led_invert_show, led_invert_store);
 
-static void heartbeat_trig_activate(struct led_classdev *led_cdev)
+static int heartbeat_trig_activate(struct led_classdev *led_cdev)
 {
 	struct heartbeat_trig_data *heartbeat_data;
 	int rc;
 
 	heartbeat_data = kzalloc(sizeof(*heartbeat_data), GFP_KERNEL);
 	if (!heartbeat_data)
-		return;
+		return 0;
 
 	led_cdev->trigger_data = heartbeat_data;
 	heartbeat_data->led_cdev = led_cdev;
 	rc = device_create_file(led_cdev->dev, &dev_attr_invert);
 	if (rc) {
 		kfree(led_cdev->trigger_data);
-		return;
+		return 0;
 	}
 
 	timer_setup(&heartbeat_data->timer, led_heartbeat_function, 0);
@@ -145,6 +145,8 @@ static void heartbeat_trig_activate(struct led_classdev *led_cdev)
 	led_heartbeat_function(&heartbeat_data->timer);
 	set_bit(LED_BLINK_SW, &led_cdev->work_flags);
 	led_cdev->activated = true;
+
+	return 0;
 }
 
 static void heartbeat_trig_deactivate(struct led_classdev *led_cdev)
diff --git a/drivers/leds/trigger/ledtrig-netdev.c b/drivers/leds/trigger/ledtrig-netdev.c
index 6df4781a6308..bb05937255de 100644
--- a/drivers/leds/trigger/ledtrig-netdev.c
+++ b/drivers/leds/trigger/ledtrig-netdev.c
@@ -388,14 +388,14 @@ static void netdev_trig_work(struct work_struct *work)
 			(atomic_read(&trigger_data->interval)*2));
 }
 
-static void netdev_trig_activate(struct led_classdev *led_cdev)
+static int netdev_trig_activate(struct led_classdev *led_cdev)
 {
 	struct led_netdev_data *trigger_data;
 	int rc;
 
 	trigger_data = kzalloc(sizeof(struct led_netdev_data), GFP_KERNEL);
 	if (!trigger_data)
-		return;
+		return 0;
 
 	spin_lock_init(&trigger_data->lock);
 
@@ -432,7 +432,7 @@ static void netdev_trig_activate(struct led_classdev *led_cdev)
 	rc = register_netdevice_notifier(&trigger_data->notifier);
 	if (rc)
 		goto err_out_interval;
-	return;
+	return 0;
 
 err_out_interval:
 	device_remove_file(led_cdev->dev, &dev_attr_interval);
@@ -447,6 +447,8 @@ static void netdev_trig_activate(struct led_classdev *led_cdev)
 err_out:
 	led_cdev->trigger_data = NULL;
 	kfree(trigger_data);
+
+	return 0;
 }
 
 static void netdev_trig_deactivate(struct led_classdev *led_cdev)
diff --git a/drivers/leds/trigger/ledtrig-oneshot.c b/drivers/leds/trigger/ledtrig-oneshot.c
index b8ea9f0f1e19..7bbf92bd7f80 100644
--- a/drivers/leds/trigger/ledtrig-oneshot.c
+++ b/drivers/leds/trigger/ledtrig-oneshot.c
@@ -122,14 +122,14 @@ static DEVICE_ATTR(delay_off, 0644, led_delay_off_show, led_delay_off_store);
 static DEVICE_ATTR(invert, 0644, led_invert_show, led_invert_store);
 static DEVICE_ATTR(shot, 0200, NULL, led_shot);
 
-static void oneshot_trig_activate(struct led_classdev *led_cdev)
+static int oneshot_trig_activate(struct led_classdev *led_cdev)
 {
 	struct oneshot_trig_data *oneshot_data;
 	int rc;
 
 	oneshot_data = kzalloc(sizeof(*oneshot_data), GFP_KERNEL);
 	if (!oneshot_data)
-		return;
+		return 0;
 
 	led_cdev->trigger_data = oneshot_data;
 
@@ -151,7 +151,7 @@ static void oneshot_trig_activate(struct led_classdev *led_cdev)
 
 	led_cdev->activated = true;
 
-	return;
+	return 0;
 
 err_out_invert:
 	device_remove_file(led_cdev->dev, &dev_attr_invert);
@@ -161,6 +161,8 @@ static void oneshot_trig_activate(struct led_classdev *led_cdev)
 	device_remove_file(led_cdev->dev, &dev_attr_delay_on);
 err_out_trig_data:
 	kfree(led_cdev->trigger_data);
+
+	return 0;
 }
 
 static void oneshot_trig_deactivate(struct led_classdev *led_cdev)
diff --git a/drivers/leds/trigger/ledtrig-timer.c b/drivers/leds/trigger/ledtrig-timer.c
index 10fc0966b0e3..527055d815ad 100644
--- a/drivers/leds/trigger/ledtrig-timer.c
+++ b/drivers/leds/trigger/ledtrig-timer.c
@@ -70,7 +70,7 @@ static ssize_t led_delay_off_store(struct device *dev,
 static DEVICE_ATTR(delay_on, 0644, led_delay_on_show, led_delay_on_store);
 static DEVICE_ATTR(delay_off, 0644, led_delay_off_show, led_delay_off_store);
 
-static void timer_trig_activate(struct led_classdev *led_cdev)
+static int timer_trig_activate(struct led_classdev *led_cdev)
 {
 	int rc;
 
@@ -78,7 +78,7 @@ static void timer_trig_activate(struct led_classdev *led_cdev)
 
 	rc = device_create_file(led_cdev->dev, &dev_attr_delay_on);
 	if (rc)
-		return;
+		return 0;
 	rc = device_create_file(led_cdev->dev, &dev_attr_delay_off);
 	if (rc)
 		goto err_out_delayon;
@@ -87,10 +87,12 @@ static void timer_trig_activate(struct led_classdev *led_cdev)
 		      &led_cdev->blink_delay_off);
 	led_cdev->activated = true;
 
-	return;
+	return 0;
 
 err_out_delayon:
 	device_remove_file(led_cdev->dev, &dev_attr_delay_on);
+
+	return 0;
 }
 
 static void timer_trig_deactivate(struct led_classdev *led_cdev)
diff --git a/drivers/leds/trigger/ledtrig-transient.c b/drivers/leds/trigger/ledtrig-transient.c
index 9d1769073562..a55fc58179a9 100644
--- a/drivers/leds/trigger/ledtrig-transient.c
+++ b/drivers/leds/trigger/ledtrig-transient.c
@@ -152,7 +152,7 @@ static DEVICE_ATTR(duration, 0644, transient_duration_show,
 		   transient_duration_store);
 static DEVICE_ATTR(state, 0644, transient_state_show, transient_state_store);
 
-static void transient_trig_activate(struct led_classdev *led_cdev)
+static int transient_trig_activate(struct led_classdev *led_cdev)
 {
 	int rc;
 	struct transient_trig_data *tdata;
@@ -161,7 +161,7 @@ static void transient_trig_activate(struct led_classdev *led_cdev)
 	if (!tdata) {
 		dev_err(led_cdev->dev,
 			"unable to allocate transient trigger\n");
-		return;
+		return 0;
 	}
 	led_cdev->trigger_data = tdata;
 	tdata->led_cdev = led_cdev;
@@ -181,7 +181,7 @@ static void transient_trig_activate(struct led_classdev *led_cdev)
 	timer_setup(&tdata->timer, transient_timer_function, 0);
 	led_cdev->activated = true;
 
-	return;
+	return 0;
 
 err_out_state:
 	device_remove_file(led_cdev->dev, &dev_attr_duration);
@@ -191,6 +191,8 @@ static void transient_trig_activate(struct led_classdev *led_cdev)
 	dev_err(led_cdev->dev, "unable to register transient trigger\n");
 	led_cdev->trigger_data = NULL;
 	kfree(tdata);
+
+	return 0;
 }
 
 static void transient_trig_deactivate(struct led_classdev *led_cdev)
diff --git a/drivers/tty/vt/keyboard.c b/drivers/tty/vt/keyboard.c
index d5b4a2b44ab8..de310621b8e7 100644
--- a/drivers/tty/vt/keyboard.c
+++ b/drivers/tty/vt/keyboard.c
@@ -959,7 +959,7 @@ struct kbd_led_trigger {
 	unsigned int mask;
 };
 
-static void kbd_led_trigger_activate(struct led_classdev *cdev)
+static int kbd_led_trigger_activate(struct led_classdev *cdev)
 {
 	struct kbd_led_trigger *trigger =
 		container_of(cdev->trigger, struct kbd_led_trigger, trigger);
@@ -970,6 +970,8 @@ static void kbd_led_trigger_activate(struct led_classdev *cdev)
 				  ledstate & trigger->mask ?
 					LED_FULL : LED_OFF);
 	tasklet_enable(&keyboard_tasklet);
+
+	return 0;
 }
 
 #define KBD_LED_TRIGGER(_led_bit, _name) {			\
diff --git a/drivers/usb/core/ledtrig-usbport.c b/drivers/usb/core/ledtrig-usbport.c
index d775ffea20c3..aa1d51458da7 100644
--- a/drivers/usb/core/ledtrig-usbport.c
+++ b/drivers/usb/core/ledtrig-usbport.c
@@ -298,14 +298,14 @@ static int usbport_trig_notify(struct notifier_block *nb, unsigned long action,
 	return NOTIFY_DONE;
 }
 
-static void usbport_trig_activate(struct led_classdev *led_cdev)
+static int usbport_trig_activate(struct led_classdev *led_cdev)
 {
 	struct usbport_trig_data *usbport_data;
 	int err;
 
 	usbport_data = kzalloc(sizeof(*usbport_data), GFP_KERNEL);
 	if (!usbport_data)
-		return;
+		return 0;
 	usbport_data->led_cdev = led_cdev;
 
 	/* List of ports */
@@ -322,10 +322,11 @@ static void usbport_trig_activate(struct led_classdev *led_cdev)
 	usb_register_notify(&usbport_data->nb);
 
 	led_cdev->activated = true;
-	return;
+	return 0;
 
 err_free:
 	kfree(usbport_data);
+	return 0;
 }
 
 static void usbport_trig_deactivate(struct led_classdev *led_cdev)
diff --git a/include/linux/leds.h b/include/linux/leds.h
index b7e82550e655..ba5baaaa43bf 100644
--- a/include/linux/leds.h
+++ b/include/linux/leds.h
@@ -253,7 +253,7 @@ static inline bool led_sysfs_is_disabled(struct led_classdev *led_cdev)
 struct led_trigger {
 	/* Trigger Properties */
 	const char	 *name;
-	void		(*activate)(struct led_classdev *led_cdev);
+	int		(*activate)(struct led_classdev *led_cdev);
 	void		(*deactivate)(struct led_classdev *led_cdev);
 
 	/* LEDs under control by this trigger (for simple triggers) */
@@ -288,8 +288,8 @@ extern void led_trigger_blink_oneshot(struct led_trigger *trigger,
 				      unsigned long *delay_off,
 				      int invert);
 extern void led_trigger_set_default(struct led_classdev *led_cdev);
-extern void led_trigger_set(struct led_classdev *led_cdev,
-			struct led_trigger *trigger);
+extern int led_trigger_set(struct led_classdev *led_cdev,
+			   struct led_trigger *trigger);
 extern void led_trigger_remove(struct led_classdev *led_cdev);
 
 static inline void *led_get_trigger_data(struct led_classdev *led_cdev)
@@ -334,8 +334,12 @@ static inline void led_trigger_blink_oneshot(struct led_trigger *trigger,
 				      unsigned long *delay_off,
 				      int invert) {}
 static inline void led_trigger_set_default(struct led_classdev *led_cdev) {}
-static inline void led_trigger_set(struct led_classdev *led_cdev,
-				struct led_trigger *trigger) {}
+static inline int led_trigger_set(struct led_classdev *led_cdev,
+				  struct led_trigger *trigger)
+{
+	return 0;
+}
+
 static inline void led_trigger_remove(struct led_classdev *led_cdev) {}
 static inline void *led_get_trigger_data(struct led_classdev *led_cdev)
 {
diff --git a/net/bluetooth/leds.c b/net/bluetooth/leds.c
index cb670b5594eb..6d59a5023231 100644
--- a/net/bluetooth/leds.c
+++ b/net/bluetooth/leds.c
@@ -43,7 +43,7 @@ void hci_leds_update_powered(struct hci_dev *hdev, bool enabled)
 	led_trigger_event(bt_power_led_trigger, enabled ? LED_FULL : LED_OFF);
 }
 
-static void power_activate(struct led_classdev *led_cdev)
+static int power_activate(struct led_classdev *led_cdev)
 {
 	struct hci_basic_led_trigger *htrig;
 	bool powered;
@@ -52,10 +52,12 @@ static void power_activate(struct led_classdev *led_cdev)
 	powered = test_bit(HCI_UP, &htrig->hdev->flags);
 
 	led_trigger_event(led_cdev->trigger, powered ? LED_FULL : LED_OFF);
+
+	return 0;
 }
 
 static struct led_trigger *led_allocate_basic(struct hci_dev *hdev,
-			void (*activate)(struct led_classdev *led_cdev),
+			int (*activate)(struct led_classdev *led_cdev),
 			const char *name)
 {
 	struct hci_basic_led_trigger *htrig;
diff --git a/net/mac80211/led.c b/net/mac80211/led.c
index ba0b507ea691..469a531e8d24 100644
--- a/net/mac80211/led.c
+++ b/net/mac80211/led.c
@@ -52,13 +52,15 @@ void ieee80211_free_led_names(struct ieee80211_local *local)
 	kfree(local->radio_led.name);
 }
 
-static void ieee80211_tx_led_activate(struct led_classdev *led_cdev)
+static int ieee80211_tx_led_activate(struct led_classdev *led_cdev)
 {
 	struct ieee80211_local *local = container_of(led_cdev->trigger,
 						     struct ieee80211_local,
 						     tx_led);
 
 	atomic_inc(&local->tx_led_active);
+
+	return 0
 }
 
 static void ieee80211_tx_led_deactivate(struct led_classdev *led_cdev)
@@ -70,13 +72,15 @@ static void ieee80211_tx_led_deactivate(struct led_classdev *led_cdev)
 	atomic_dec(&local->tx_led_active);
 }
 
-static void ieee80211_rx_led_activate(struct led_classdev *led_cdev)
+static int ieee80211_rx_led_activate(struct led_classdev *led_cdev)
 {
 	struct ieee80211_local *local = container_of(led_cdev->trigger,
 						     struct ieee80211_local,
 						     rx_led);
 
 	atomic_inc(&local->rx_led_active);
+
+	return 0;
 }
 
 static void ieee80211_rx_led_deactivate(struct led_classdev *led_cdev)
@@ -88,13 +92,15 @@ static void ieee80211_rx_led_deactivate(struct led_classdev *led_cdev)
 	atomic_dec(&local->rx_led_active);
 }
 
-static void ieee80211_assoc_led_activate(struct led_classdev *led_cdev)
+static int ieee80211_assoc_led_activate(struct led_classdev *led_cdev)
 {
 	struct ieee80211_local *local = container_of(led_cdev->trigger,
 						     struct ieee80211_local,
 						     assoc_led);
 
 	atomic_inc(&local->assoc_led_active);
+
+	return 0;
 }
 
 static void ieee80211_assoc_led_deactivate(struct led_classdev *led_cdev)
@@ -106,13 +112,15 @@ static void ieee80211_assoc_led_deactivate(struct led_classdev *led_cdev)
 	atomic_dec(&local->assoc_led_active);
 }
 
-static void ieee80211_radio_led_activate(struct led_classdev *led_cdev)
+static int ieee80211_radio_led_activate(struct led_classdev *led_cdev)
 {
 	struct ieee80211_local *local = container_of(led_cdev->trigger,
 						     struct ieee80211_local,
 						     radio_led);
 
 	atomic_inc(&local->radio_led_active);
+
+	return 0;
 }
 
 static void ieee80211_radio_led_deactivate(struct led_classdev *led_cdev)
@@ -124,13 +132,15 @@ static void ieee80211_radio_led_deactivate(struct led_classdev *led_cdev)
 	atomic_dec(&local->radio_led_active);
 }
 
-static void ieee80211_tpt_led_activate(struct led_classdev *led_cdev)
+static int ieee80211_tpt_led_activate(struct led_classdev *led_cdev)
 {
 	struct ieee80211_local *local = container_of(led_cdev->trigger,
 						     struct ieee80211_local,
 						     tpt_led);
 
 	atomic_inc(&local->tpt_led_active);
+
+	return 0;
 }
 
 static void ieee80211_tpt_led_deactivate(struct led_classdev *led_cdev)
diff --git a/net/rfkill/core.c b/net/rfkill/core.c
index a7a4e6ff9be2..1355f5ca8d22 100644
--- a/net/rfkill/core.c
+++ b/net/rfkill/core.c
@@ -141,13 +141,15 @@ static void rfkill_led_trigger_event(struct rfkill *rfkill)
 		led_trigger_event(trigger, LED_FULL);
 }
 
-static void rfkill_led_trigger_activate(struct led_classdev *led)
+static int rfkill_led_trigger_activate(struct led_classdev *led)
 {
 	struct rfkill *rfkill;
 
 	rfkill = container_of(led->trigger, struct rfkill, led_trigger);
 
 	rfkill_led_trigger_event(rfkill);
+
+	return 0;
 }
 
 const char *rfkill_get_led_trigger_name(struct rfkill *rfkill)
-- 
2.18.0
