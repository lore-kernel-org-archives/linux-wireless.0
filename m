Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.155]:50371 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859AbYAFNKc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Jan 2008 08:10:32 -0500
Received: by fg-out-1718.google.com with SMTP id e21so4049711fga.17
        for <linux-wireless@vger.kernel.org>; Sun, 06 Jan 2008 05:10:28 -0800 (PST)
To: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: Add radio led trigger
Date: Sun, 6 Jan 2008 14:10:12 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200801061410.12862.IvDoorn@gmail.com> (sfid-20080106_131041_396455_F5E6FC83)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some devices have a seperate LED which indicates if the radio is
enabled or not. This adds a LED trigger to mac80211 where drivers
can hook into when they are interested in radio status changes.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>

---
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 1d3d4f3..42499f6 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1173,6 +1173,7 @@ int ieee80211_register_hw(struct ieee80211_hw *hw);
 extern char *__ieee80211_get_tx_led_name(struct ieee80211_hw *hw);
 extern char *__ieee80211_get_rx_led_name(struct ieee80211_hw *hw);
 extern char *__ieee80211_get_assoc_led_name(struct ieee80211_hw *hw);
+extern char *__ieee80211_get_radio_led_name(struct ieee80211_hw *hw);
 #endif
 /**
  * ieee80211_get_tx_led_name - get name of TX LED
@@ -1212,6 +1213,16 @@ static inline char *ieee80211_get_rx_led_name(struct ieee80211_hw *hw)
 #endif
 }
 
+/**
+ * ieee80211_get_assoc_led_name - get name of association LED
+ *
+ * mac80211 creates a association LED trigger for each wireless hardware
+ * that can be used to drive LEDs if your driver registers a LED device.
+ * This function returns the name (or %NULL if not configured for LEDs)
+ * of the trigger so you can automatically link the LED device.
+ *
+ * @hw: the hardware to get the LED trigger name for
+ */
 static inline char *ieee80211_get_assoc_led_name(struct ieee80211_hw *hw)
 {
 #ifdef CONFIG_MAC80211_LEDS
@@ -1221,6 +1232,24 @@ static inline char *ieee80211_get_assoc_led_name(struct ieee80211_hw *hw)
 #endif
 }
 
+/**
+ * ieee80211_get_radio_led_name - get name of radio LED
+ *
+ * mac80211 creates a radio change LED trigger for each wireless hardware
+ * that can be used to drive LEDs if your driver registers a LED device.
+ * This function returns the name (or %NULL if not configured for LEDs)
+ * of the trigger so you can automatically link the LED device.
+ *
+ * @hw: the hardware to get the LED trigger name for
+ */
+static inline char *ieee80211_get_radio_led_name(struct ieee80211_hw *hw)
+{
+#ifdef CONFIG_MAC80211_LEDS
+	return __ieee80211_get_radio_led_name(hw);
+#else
+	return NULL;
+#endif
+}
 
 /* Register a new hardware PHYMODE capability to the stack. */
 int ieee80211_register_hwmode(struct ieee80211_hw *hw,
diff --git a/net/mac80211/ieee80211.c b/net/mac80211/ieee80211.c
index 5aa9c2d..df64b6e 100644
--- a/net/mac80211/ieee80211.c
+++ b/net/mac80211/ieee80211.c
@@ -219,6 +219,7 @@ static int ieee80211_open(struct net_device *dev)
 		if (res)
 			return res;
 		ieee80211_hw_config(local);
+		ieee80211_led_radio(local, 1);
 	}
 
 	switch (sdata->vif.type) {
@@ -390,6 +391,8 @@ static int ieee80211_stop(struct net_device *dev)
 		if (local->ops->stop)
 			local->ops->stop(local_to_hw(local));
 
+		ieee80211_led_radio(local, 0);
+
 		tasklet_disable(&local->tx_pending_tasklet);
 		tasklet_disable(&local->tasklet);
 	}
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 083c432..e4d2f66 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -513,8 +513,9 @@ struct ieee80211_local {
 
 #ifdef CONFIG_MAC80211_LEDS
 	int tx_led_counter, rx_led_counter;
-	struct led_trigger *tx_led, *rx_led, *assoc_led;
-	char tx_led_name[32], rx_led_name[32], assoc_led_name[32];
+	struct led_trigger *tx_led, *rx_led, *assoc_led, *radio_led;
+	char tx_led_name[32], rx_led_name[32],
+	     assoc_led_name[32], radio_led_name[32];
 #endif
 
 	u32 channel_use;
diff --git a/net/mac80211/ieee80211_ioctl.c b/net/mac80211/ieee80211_ioctl.c
index be80f44..b28eb8f 100644
--- a/net/mac80211/ieee80211_ioctl.c
+++ b/net/mac80211/ieee80211_ioctl.c
@@ -21,6 +21,7 @@
 
 #include <net/mac80211.h>
 #include "ieee80211_i.h"
+#include "ieee80211_led.h"
 #include "ieee80211_rate.h"
 #include "wpa.h"
 #include "aes_ccm.h"
@@ -651,6 +652,7 @@ static int ieee80211_ioctl_siwtxpower(struct net_device *dev,
 	if (local->hw.conf.radio_enabled != !(data->txpower.disabled)) {
 		local->hw.conf.radio_enabled = !(data->txpower.disabled);
 		need_reconfig = 1;
+		ieee80211_led_radio(local, local->hw.conf.radio_enabled);
 	}
 
 	if (need_reconfig) {
diff --git a/net/mac80211/ieee80211_led.c b/net/mac80211/ieee80211_led.c
index 4cf89af..f401484 100644
--- a/net/mac80211/ieee80211_led.c
+++ b/net/mac80211/ieee80211_led.c
@@ -43,6 +43,16 @@ void ieee80211_led_assoc(struct ieee80211_local *local, bool associated)
 		led_trigger_event(local->assoc_led, LED_OFF);
 }
 
+void ieee80211_led_radio(struct ieee80211_local *local, bool enabled)
+{
+	if (unlikely(!local->radio_led))
+		return;
+	if (enabled)
+		led_trigger_event(local->radio_led, LED_FULL);
+	else
+		led_trigger_event(local->radio_led, LED_OFF);
+}
+
 void ieee80211_led_init(struct ieee80211_local *local)
 {
 	local->rx_led = kzalloc(sizeof(struct led_trigger), GFP_KERNEL);
@@ -77,10 +87,25 @@ void ieee80211_led_init(struct ieee80211_local *local)
 			local->assoc_led = NULL;
 		}
 	}
+
+	local->radio_led = kzalloc(sizeof(struct led_trigger), GFP_KERNEL);
+	if (local->radio_led) {
+		snprintf(local->radio_led_name, sizeof(local->radio_led_name),
+			 "%sradio", wiphy_name(local->hw.wiphy));
+		local->radio_led->name = local->radio_led_name;
+		if (led_trigger_register(local->radio_led)) {
+			kfree(local->radio_led);
+			local->radio_led = NULL;
+		}
+	}
 }
 
 void ieee80211_led_exit(struct ieee80211_local *local)
 {
+	if (local->radio_led) {
+		led_trigger_unregister(local->radio_led);
+		kfree(local->radio_led);
+	}
 	if (local->assoc_led) {
 		led_trigger_unregister(local->assoc_led);
 		kfree(local->assoc_led);
@@ -95,6 +120,16 @@ void ieee80211_led_exit(struct ieee80211_local *local)
 	}
 }
 
+char *__ieee80211_get_radio_led_name(struct ieee80211_hw *hw)
+{
+	struct ieee80211_local *local = hw_to_local(hw);
+
+	if (local->radio_led)
+		return local->radio_led_name;
+	return NULL;
+}
+EXPORT_SYMBOL(__ieee80211_get_radio_led_name);
+
 char *__ieee80211_get_assoc_led_name(struct ieee80211_hw *hw)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
diff --git a/net/mac80211/ieee80211_led.h b/net/mac80211/ieee80211_led.h
index 0feb226..77b1e1b 100644
--- a/net/mac80211/ieee80211_led.h
+++ b/net/mac80211/ieee80211_led.h
@@ -16,6 +16,8 @@ extern void ieee80211_led_rx(struct ieee80211_local *local);
 extern void ieee80211_led_tx(struct ieee80211_local *local, int q);
 extern void ieee80211_led_assoc(struct ieee80211_local *local,
 				bool associated);
+extern void ieee80211_led_radio(struct ieee80211_local *local,
+				bool enabled);
 extern void ieee80211_led_init(struct ieee80211_local *local);
 extern void ieee80211_led_exit(struct ieee80211_local *local);
 #else
@@ -29,6 +31,10 @@ static inline void ieee80211_led_assoc(struct ieee80211_local *local,
 				       bool associated)
 {
 }
+static inline void ieee80211_led_radio(struct ieee80211_local *local,
+				       bool enabled)
+{
+}
 static inline void ieee80211_led_init(struct ieee80211_local *local)
 {
 }
