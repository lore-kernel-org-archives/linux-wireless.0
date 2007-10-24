Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hoboe1bl1.telenet-ops.be ([195.130.137.72]:54947 "EHLO
	hoboe1bl1.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753686AbXJXAdy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Oct 2007 20:33:54 -0400
Message-ID: <471E92FC.1000305@telenet.be> (sfid-20071024_013358_895847_AB30330A)
Date: Wed, 24 Oct 2007 02:34:04 +0200
From: Ian Schram <ischram@telenet.be>
MIME-Version: 1.0
To: wireless <linux-wireless@vger.kernel.org>
Cc: Ipw3945-devel@lists.sourceforge.net
Subject: Re: [ipw3945-devel] [RFC][PATCH] iwlwifi using mac80211_leds
References: <47164DA9.3050001@telenet.be>
In-Reply-To: <47164DA9.3050001@telenet.be>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is the second version of this patch with a few several bugfixes,
please test this one instead. I also included a 4965 part to the patch
so people can just test it. The code there has never been executed so
you adventurous (and responsible ;-)) if you try it on your machine.

It shouldn't print any warnings anymore when unloading the driver.

I'm still to new to kernel code to fully understand the locking, so that's
probably not entirely right. But basically it works for me ..


Signed-of-by: Ian Schram<ischram@telenet.be>
---
diff --git a/drivers/net/wireless/iwlwifi/Kconfig b/drivers/net/wireless/iwlwifi/Kconfig
index 25cfc6c..8e8f835 100644
--- a/drivers/net/wireless/iwlwifi/Kconfig
+++ b/drivers/net/wireless/iwlwifi/Kconfig
@@ -126,3 +126,9 @@ config IWL3945
 	  inserted in and remvoed from the running kernel whenever you want),
 	  say M here and read <file:Documentation/modules.txt>.  The module
 	  will be called iwl3945.ko.
+config IWLWIFI_LEDS
+	bool	"IWLWIFI leds"
+	depends IWLWIFI && MAC80211_LEDS	
+	default y
+	---help---
+	This options enables the wireless led.	
diff --git a/drivers/net/wireless/iwlwifi/iwl-priv.h b/drivers/net/wireless/iwlwifi/iwl-priv.h
index 6b490d0..ad05513 100644
--- a/drivers/net/wireless/iwlwifi/iwl-priv.h
+++ b/drivers/net/wireless/iwlwifi/iwl-priv.h
@@ -127,11 +127,14 @@ struct iwl_priv {
 	struct iwl_init_alive_resp card_alive_init;
 	struct iwl_alive_resp card_alive;

-#ifdef LED
-	/* LED related variables */
-	struct iwl_activity_blink activity;
-	unsigned long led_packets;
-	int led_state;
+
+#ifdef CONFIG_IWLWIFI_LEDS
+	u8 led_state;
+	unsigned int rxtxpackets;
+	atomic_t ledtimer;
+	struct iwl_led tx_led;
+	struct iwl_led rx_led;
+	struct iwl_led assoc_led;
 #endif

 	u16 active_rate;
@@ -274,6 +277,7 @@ struct iwl_priv {
 	struct delayed_work gather_stats;
 	struct delayed_work scan_check;
 	struct delayed_work post_associate;
+	struct delayed_work update_led;

 #define IWL_DEFAULT_TX_POWER 0x0F
 	s8 user_txpower_limit;
diff --git a/drivers/net/wireless/iwlwifi/iwlwifi.h b/drivers/net/wireless/iwlwifi/iwlwifi.h
index 432ce88..06a2839 100644
--- a/drivers/net/wireless/iwlwifi/iwlwifi.h
+++ b/drivers/net/wireless/iwlwifi/iwlwifi.h
@@ -50,6 +50,9 @@ extern struct pci_device_id iwl_hw_card_ids[];

 #include "iwl-prph.h"

+#ifdef CONFIG_IWLWIFI_LEDS
+#include "iwl-leds.h"
+#endif
 /*
  * Driver implementation data structures, constants, inline
  * functions
diff --git a/drivers/net/wireless/iwlwifi/iwl-leds.h b/drivers/net/wireless/iwlwifi/iwl-leds.h
new file mode 100644
index 0000000..07a55f0
--- /dev/null
+++ b/drivers/net/wireless/iwlwifi/iwl-leds.h
@@ -0,0 +1,20 @@
+#ifndef __iwl_leds_h__
+#define __iwl_leds_h__
+
+
+#include <linux/leds.h>
+
+
+#define IWL_LED_ACTIVITY	(0<<1)
+#define IWL_LED_LINK 		(1<<1)
+#define IWL_LED_INTERVAL	__constant_cpu_to_le32(1000)
+#define IWL_LED_ACTIVITY_PERIOD msecs_to_jiffies(500)
+#define IWL_LED_MAX_NAME_LEN 	31
+
+struct iwl_led {
+	char name[IWL_LED_MAX_NAME_LEN + 1];
+	struct led_classdev cdev;
+};
+
+
+#endif
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 05e1135..4835ee0 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -6073,6 +6073,173 @@ static void iwl_init_alive_start(struct iwl_priv *priv)
 	queue_work(priv->workqueue, &priv->restart);
 }

+#ifdef CONFIG_IWLWIFI_LEDS
+static int iwl_led_cmd_callback(struct iwl_priv *priv,
+			     	struct iwl_cmd *cmd, struct sk_buff *skb)
+{
+	return 1;
+}
+
+static void iwl_bg_led_update(struct work_struct *data)
+{
+	struct iwl_priv *priv =
+	    container_of(data, struct iwl_priv, update_led.work);
+	struct iwl_led_cmd led_cmd = {
+		.id = IWL_LED_ACTIVITY,
+		.interval = IWL_LED_INTERVAL,
+	};
+	struct iwl_host_cmd cmd = {
+		.id = REPLY_LEDS_CMD,
+		.len = sizeof(struct iwl_led_cmd),
+		.data = &led_cmd,
+		.meta.flags = CMD_ASYNC,
+		.meta.u.callback = iwl_led_cmd_callback,
+	};
+	u8 on;
+	unsigned long flags;
+
+	if (test_bit(STATUS_EXIT_PENDING, &priv->status) ||
+	    !test_bit(STATUS_READY, &priv->status))
+		return;
+
+	spin_lock_irqsave(&priv->lock, flags);
+
+	if (priv->rxtxpackets) {
+		on = 25 + 230 / (1 + (priv->rxtxpackets >> 2));
+		priv->rxtxpackets = 0;
+		queue_delayed_work(priv->workqueue, &priv->update_led,
+			   	   IWL_LED_ACTIVITY_PERIOD);
+
+		if (on == priv->led_state)
+			goto exit_unlock;
+
+		led_cmd.on = led_cmd.off = on;
+		priv->led_state = on;
+
+	}
+	else {
+		atomic_set(&priv->ledtimer, 0);
+		led_cmd.on = led_cmd.off = 0;
+		priv->led_state = 0;
+	}
+
+	spin_unlock_irqrestore(&priv->lock, flags);
+	iwl_send_cmd(priv, &cmd);
+
+	return;
+
+exit_unlock:
+	spin_unlock_irqrestore(&priv->lock, flags);
+}
+
+static void iwl_led_set_rx(struct led_classdev *led_cdev,
+			   enum led_brightness value)
+{
+	struct iwl_priv *priv = container_of(led_cdev, struct iwl_priv,
+					     rx_led.cdev);
+	unsigned long flags;
+
+	if (test_bit(STATUS_EXIT_PENDING, &priv->status) ||
+	    !test_bit(STATUS_READY, &priv->status))
+		return;
+
+	spin_lock_irqsave(&priv->lock, flags);
+	priv->rxtxpackets += 2;
+	if (!atomic_xchg(&priv->ledtimer, 1))
+		queue_delayed_work(priv->workqueue, &priv->update_led,
+				   IWL_LED_ACTIVITY_PERIOD);
+	spin_unlock_irqrestore(&priv->lock, flags);
+
+}
+
+static void iwl_led_set_tx(struct led_classdev *led_cdev,
+			   enum led_brightness value)
+{
+	struct iwl_priv *priv = container_of(led_cdev, struct iwl_priv,
+					     tx_led.cdev);
+	unsigned long flags;
+
+	if (test_bit(STATUS_EXIT_PENDING, &priv->status) ||
+	    !test_bit(STATUS_READY, &priv->status))
+		return;
+
+	spin_lock_irqsave(&priv->lock, flags);
+	priv->rxtxpackets++;
+	if (!atomic_xchg(&priv->ledtimer, 1))
+		queue_delayed_work(priv->workqueue, &priv->update_led,
+				   IWL_LED_ACTIVITY_PERIOD);
+	spin_unlock_irqrestore(&priv->lock, flags);
+}
+
+static void iwl_led_set_assoc(struct led_classdev *led_cdev,
+			   enum led_brightness value)
+{
+	struct iwl_priv *priv = container_of(led_cdev, struct iwl_priv,
+					     assoc_led.cdev);
+	struct iwl_led_cmd led_cmd = {
+		.id = IWL_LED_LINK,
+		.interval = IWL_LED_INTERVAL,
+	};
+	struct iwl_host_cmd cmd = {
+		.id = REPLY_LEDS_CMD,
+		.len = sizeof(struct iwl_led_cmd),
+		.data = &led_cmd,
+		.meta.flags = CMD_ASYNC,
+		.meta.u.callback = iwl_led_cmd_callback
+	};
+
+	if (test_bit(STATUS_EXIT_PENDING, &priv->status) ||
+	    !test_bit(STATUS_READY, &priv->status))
+		return;
+
+	switch(value)
+	{
+		case LED_OFF:
+			led_cmd.off = 0;
+			led_cmd.on = 0;
+			break;
+		case LED_HALF:
+		case LED_FULL:
+			led_cmd.off = 0;
+			led_cmd.on = 40;
+	}
+	iwl_send_cmd(priv, &cmd);
+}
+
+
+static int iwl_register_led(struct iwl_priv *priv, struct iwl_led *led, char *ledname,
+			     char *triggername, void (*callback)
+			     (struct led_classdev *, enum led_brightness))
+{
+	snprintf(led->name, sizeof(led->name), ledname,
+		 wiphy_name(priv->hw->wiphy));
+	led->cdev.name = led->name;
+	led->cdev.brightness_set = callback;
+	led->cdev.default_trigger = triggername;
+
+	return led_classdev_register(&priv->pci_dev->dev, &led->cdev);
+}
+
+static void iwl_register_leds(struct iwl_priv *priv)
+{
+	iwl_register_led(priv, &priv->tx_led, "iwl-%s:tx",
+			 ieee80211_get_tx_led_name(priv->hw),
+			 iwl_led_set_tx);
+	iwl_register_led(priv, &priv->rx_led, "iwl-%s:rx",
+			 ieee80211_get_rx_led_name(priv->hw),
+			 iwl_led_set_rx);
+	iwl_register_led(priv, &priv->assoc_led, "iwl-%s:asoc",
+			 ieee80211_get_assoc_led_name(priv->hw),
+			 iwl_led_set_assoc);
+}
+
+static void iwl_unregister_leds(struct iwl_priv *priv)
+{
+	led_classdev_unregister(&priv->tx_led.cdev);
+	led_classdev_unregister(&priv->rx_led.cdev);
+	led_classdev_unregister(&priv->assoc_led.cdev);
+}
+#endif

 /**
  * iwl_alive_start - called after REPLY_ALIVE notification received
@@ -6148,6 +6315,9 @@ static void iwl_alive_start(struct iwl_priv *priv)
 	if (iwl_is_rfkill(priv))
 		return;

+#ifdef CONFIG_IWLWIFI_LEDS
+	atomic_set(&priv->ledtimer, 0);
+#endif
 	if (!priv->mac80211_registered) {
 		/* Unlock so any user space entry points can call back into
 		 * the driver without a deadlock... */
@@ -6166,6 +6336,9 @@ static void iwl_alive_start(struct iwl_priv *priv)
 		priv->mac80211_registered = 1;

 		iwl_reset_channel_flag(priv);
+#ifdef CONFIG_IWLWIFI_LEDS
+		iwl_register_leds(priv);
+#endif
 	} else
 		ieee80211_start_queues(priv->hw);

@@ -8206,7 +8379,9 @@ static void iwl_setup_deferred_work(struct iwl_priv *priv)
 	INIT_DELAYED_WORK(&priv->init_alive_start, iwl_bg_init_alive_start);
 	INIT_DELAYED_WORK(&priv->alive_start, iwl_bg_alive_start);
 	INIT_DELAYED_WORK(&priv->scan_check, iwl_bg_scan_check);
-
+#ifdef CONFIG_IWLWIFI_LEDS
+	INIT_DELAYED_WORK(&priv->update_led, iwl_bg_led_update);
+#endif
 	iwl_hw_setup_deferred_work(priv);

 	tasklet_init(&priv->irq_tasklet, (void (*)(unsigned long))
@@ -8217,6 +8392,9 @@ static void iwl_cancel_deferred_work(struct iwl_priv *priv)
 {
 	iwl_hw_cancel_deferred_work(priv);

+#ifdef CONFIG_IWLWIFI_LEDS
+	cancel_delayed_work(&priv->update_led);
+#endif
 	cancel_delayed_work(&priv->scan_check);
 	cancel_delayed_work(&priv->alive_start);
 	cancel_delayed_work(&priv->post_associate);
@@ -8539,6 +8717,9 @@ static void iwl_pci_remove(struct pci_dev *pdev)
 	iwl_clear_stations_table(priv);

 	if (priv->mac80211_registered) {
+#ifdef CONFIG_IWLWIFI_LEDS
+		iwl_unregister_leds(priv);
+#endif
 		ieee80211_unregister_hw(priv->hw);
 		iwl_rate_control_unregister(priv->hw);
 	}
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 90561bb..3d02e28 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -6449,6 +6449,174 @@ static void iwl_init_alive_start(struct iwl_priv *priv)
 	queue_work(priv->workqueue, &priv->restart);
 }

+#ifdef CONFIG_IWLWIFI_LEDS
+static int iwl_led_cmd_callback(struct iwl_priv *priv,
+			     	struct iwl_cmd *cmd, struct sk_buff *skb)
+{
+	return 1;
+}
+
+static void iwl_bg_led_update(struct work_struct *data)
+{
+	struct iwl_priv *priv =
+	    container_of(data, struct iwl_priv, update_led.work);
+	struct iwl_led_cmd led_cmd = {
+		.id = IWL_LED_ACTIVITY,
+		.interval = IWL_LED_INTERVAL,
+	};
+	struct iwl_host_cmd cmd = {
+		.id = REPLY_LEDS_CMD,
+		.len = sizeof(struct iwl_led_cmd),
+		.data = &led_cmd,
+		.meta.flags = CMD_ASYNC,
+		.meta.u.callback = iwl_led_cmd_callback,
+	};
+	u8 on;
+	unsigned long flags;
+
+	if (test_bit(STATUS_EXIT_PENDING, &priv->status) ||
+	    !test_bit(STATUS_READY, &priv->status))
+		return;
+
+	spin_lock_irqsave(&priv->lock, flags);
+
+	if (priv->rxtxpackets) {
+		on = 25 + 230 / (1 + (priv->rxtxpackets >> 2));
+		priv->rxtxpackets = 0;
+		queue_delayed_work(priv->workqueue, &priv->update_led,
+			   	   IWL_LED_ACTIVITY_PERIOD);
+
+		if (on == priv->led_state)
+			goto exit_unlock;
+
+		led_cmd.on = led_cmd.off = on;
+		priv->led_state = on;
+
+	}
+	else {
+		atomic_set(&priv->ledtimer, 0);
+		led_cmd.on = led_cmd.off = 0;
+		priv->led_state = 0;
+	}
+
+	spin_unlock_irqrestore(&priv->lock, flags);
+	iwl_send_cmd(priv, &cmd);
+
+	return;
+
+exit_unlock:
+	spin_unlock_irqrestore(&priv->lock, flags);
+}
+
+static void iwl_led_set_rx(struct led_classdev *led_cdev,
+			   enum led_brightness value)
+{
+	struct iwl_priv *priv = container_of(led_cdev, struct iwl_priv,
+					     rx_led.cdev);
+	unsigned long flags;
+
+	if (test_bit(STATUS_EXIT_PENDING, &priv->status) ||
+	    !test_bit(STATUS_READY, &priv->status))
+		return;
+
+	spin_lock_irqsave(&priv->lock, flags);
+	priv->rxtxpackets += 2;
+	if (!atomic_xchg(&priv->ledtimer, 1))
+		queue_delayed_work(priv->workqueue, &priv->update_led,
+				   IWL_LED_ACTIVITY_PERIOD);
+	spin_unlock_irqrestore(&priv->lock, flags);
+
+}
+
+static void iwl_led_set_tx(struct led_classdev *led_cdev,
+			   enum led_brightness value)
+{
+	struct iwl_priv *priv = container_of(led_cdev, struct iwl_priv,
+					     tx_led.cdev);
+	unsigned long flags;
+
+	if (test_bit(STATUS_EXIT_PENDING, &priv->status) ||
+	    !test_bit(STATUS_READY, &priv->status))
+		return;
+
+	spin_lock_irqsave(&priv->lock, flags);
+	priv->rxtxpackets++;
+	if (!atomic_xchg(&priv->ledtimer, 1))
+		queue_delayed_work(priv->workqueue, &priv->update_led,
+				   IWL_LED_ACTIVITY_PERIOD);
+	spin_unlock_irqrestore(&priv->lock, flags);
+}
+
+static void iwl_led_set_assoc(struct led_classdev *led_cdev,
+			   enum led_brightness value)
+{
+	struct iwl_priv *priv = container_of(led_cdev, struct iwl_priv,
+					     assoc_led.cdev);
+	struct iwl_led_cmd led_cmd = {
+		.id = IWL_LED_LINK,
+		.interval = IWL_LED_INTERVAL,
+	};
+	struct iwl_host_cmd cmd = {
+		.id = REPLY_LEDS_CMD,
+		.len = sizeof(struct iwl_led_cmd),
+		.data = &led_cmd,
+		.meta.flags = CMD_ASYNC,
+		.meta.u.callback = iwl_led_cmd_callback
+	};
+
+	if (test_bit(STATUS_EXIT_PENDING, &priv->status) ||
+	    !test_bit(STATUS_READY, &priv->status))
+		return;
+
+	switch(value)
+	{
+		case LED_OFF:
+			led_cmd.off = 0;
+			led_cmd.on = 0;
+			break;
+		case LED_HALF:
+		case LED_FULL:
+			led_cmd.off = 0;
+			led_cmd.on = 40;
+	}
+	iwl_send_cmd(priv, &cmd);
+}
+
+
+static int iwl_register_led(struct iwl_priv *priv, struct iwl_led *led, char *ledname,
+			     char *triggername, void (*callback)
+			     (struct led_classdev *, enum led_brightness))
+{
+	snprintf(led->name, sizeof(led->name), ledname,
+		 wiphy_name(priv->hw->wiphy));
+	led->cdev.name = led->name;
+	led->cdev.brightness_set = callback;
+	led->cdev.default_trigger = triggername;
+
+	return led_classdev_register(&priv->pci_dev->dev, &led->cdev);
+}
+
+static void iwl_register_leds(struct iwl_priv *priv)
+{
+	iwl_register_led(priv, &priv->tx_led, "iwl-%s:tx",
+			 ieee80211_get_tx_led_name(priv->hw),
+			 iwl_led_set_tx);
+	iwl_register_led(priv, &priv->rx_led, "iwl-%s:rx",
+			 ieee80211_get_rx_led_name(priv->hw),
+			 iwl_led_set_rx);
+	iwl_register_led(priv, &priv->assoc_led, "iwl-%s:asoc",
+			 ieee80211_get_assoc_led_name(priv->hw),
+			 iwl_led_set_assoc);
+}
+
+static void iwl_unregister_leds(struct iwl_priv *priv)
+{
+	led_classdev_unregister(&priv->tx_led.cdev);
+	led_classdev_unregister(&priv->rx_led.cdev);
+	led_classdev_unregister(&priv->assoc_led.cdev);
+}
+#endif
+

 /**
  * iwl_alive_start - called after REPLY_ALIVE notification received
@@ -6504,6 +6672,9 @@ static void iwl_alive_start(struct iwl_priv *priv)
 	if (iwl_is_rfkill(priv))
 		return;

+#ifdef CONFIG_IWLWIFI_LEDS
+	atomic_set(&priv->ledtimer, 0);
+#endif
 	if (!priv->mac80211_registered) {
 		/* Unlock so any user space entry points can call back into
 		 * the driver without a deadlock... */
@@ -6522,6 +6693,9 @@ static void iwl_alive_start(struct iwl_priv *priv)
 		priv->mac80211_registered = 1;

 		iwl_reset_channel_flag(priv);
+#ifdef CONFIG_IWLWIFI_LEDS
+		iwl_register_leds(priv);
+#endif
 	} else
 		ieee80211_start_queues(priv->hw);

@@ -8801,7 +8975,9 @@ static void iwl_setup_deferred_work(struct iwl_priv *priv)
 	INIT_DELAYED_WORK(&priv->init_alive_start, iwl_bg_init_alive_start);
 	INIT_DELAYED_WORK(&priv->alive_start, iwl_bg_alive_start);
 	INIT_DELAYED_WORK(&priv->scan_check, iwl_bg_scan_check);
-
+#ifdef CONFIG_IWLWIFI_LEDS
+	INIT_DELAYED_WORK(&priv->update_led, iwl_bg_led_update);
+#endif
 	iwl_hw_setup_deferred_work(priv);

 	tasklet_init(&priv->irq_tasklet, (void (*)(unsigned long))
@@ -8812,6 +8988,9 @@ static void iwl_cancel_deferred_work(struct iwl_priv *priv)
 {
 	iwl_hw_cancel_deferred_work(priv);

+#ifdef CONFIG_IWLWIFI_LEDS
+	cancel_delayed_work(&priv->update_led);
+#endif
 	cancel_delayed_work(&priv->scan_check);
 	cancel_delayed_work(&priv->alive_start);
 	cancel_delayed_work(&priv->post_associate);
@@ -9135,6 +9314,9 @@ static void iwl_pci_remove(struct pci_dev *pdev)
 	iwl_clear_stations_table(priv);

 	if (priv->mac80211_registered) {
+#ifdef CONFIG_IWLWIFI_LEDS
+		iwl_unregister_leds(priv);
+#endif
 		ieee80211_unregister_hw(priv->hw);
 		iwl_rate_control_unregister(priv->hw);
 	}
