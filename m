Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:39504 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030298AbbDXJV3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Apr 2015 05:21:29 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 2/2] mac80211: make LED triggering depend on activation
Date: Fri, 24 Apr 2015 11:21:25 +0200
Message-Id: <1429867285-18325-2-git-send-email-johannes@sipsolutions.net> (sfid-20150424_112137_234152_E48DB894)
In-Reply-To: <1429867285-18325-1-git-send-email-johannes@sipsolutions.net>
References: <1429867285-18325-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When LED triggers are compiled in, but not used, mac80211 will still
call them to update the status. This isn't really a problem for the
assoc and radio ones, but the TX/RX (and to a certain extend TPT)
ones can be called very frequently (for every packet.)

In order to avoid that when they're not used, track their activation
and call the corresponding trigger (and in the TPT case, account for
throughput) only when the trigger is actually used by an LED.

Additionally, make those trigger functions inlines since theyre only
used once in the remaining code.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ieee80211_i.h |   7 +-
 net/mac80211/led.c         | 239 +++++++++++++++++++++++++++++----------------
 net/mac80211/led.h         |  44 ++++++---
 net/mac80211/main.c        |   4 +-
 4 files changed, 194 insertions(+), 100 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 95ac2eb25f31..ece16d6d6d31 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1266,10 +1266,11 @@ struct ieee80211_local {
 	struct mutex chanctx_mtx;
 
 #ifdef CONFIG_MAC80211_LEDS
-	struct led_trigger *tx_led, *rx_led, *assoc_led, *radio_led;
+	struct led_trigger tx_led, rx_led, assoc_led, radio_led;
+	struct led_trigger tpt_led;
+	atomic_t tx_led_active, rx_led_active, assoc_led_active;
+	atomic_t radio_led_active, tpt_led_active;
 	struct tpt_led_trigger *tpt_led_trigger;
-	char tx_led_name[32], rx_led_name[32],
-	     assoc_led_name[32], radio_led_name[32];
 #endif
 
 #ifdef CONFIG_MAC80211_DEBUG_COUNTERS
diff --git a/net/mac80211/led.c b/net/mac80211/led.c
index 3e13eb86f85d..38f05565eaac 100644
--- a/net/mac80211/led.c
+++ b/net/mac80211/led.c
@@ -12,96 +12,175 @@
 #include <linux/export.h>
 #include "led.h"
 
-#define MAC80211_BLINK_DELAY 50 /* ms */
-
-void ieee80211_led_rx(struct ieee80211_local *local)
-{
-	unsigned long led_delay = MAC80211_BLINK_DELAY;
-	if (unlikely(!local->rx_led))
-		return;
-	led_trigger_blink_oneshot(local->rx_led, &led_delay, &led_delay, 0);
-}
-
-void ieee80211_led_tx(struct ieee80211_local *local)
-{
-	unsigned long led_delay = MAC80211_BLINK_DELAY;
-	if (unlikely(!local->tx_led))
-		return;
-	led_trigger_blink_oneshot(local->tx_led, &led_delay, &led_delay, 0);
-}
-
 void ieee80211_led_assoc(struct ieee80211_local *local, bool associated)
 {
-	if (unlikely(!local->assoc_led))
+	if (!atomic_read(&local->assoc_led_active))
 		return;
 	if (associated)
-		led_trigger_event(local->assoc_led, LED_FULL);
+		led_trigger_event(&local->assoc_led, LED_FULL);
 	else
-		led_trigger_event(local->assoc_led, LED_OFF);
+		led_trigger_event(&local->assoc_led, LED_OFF);
 }
 
 void ieee80211_led_radio(struct ieee80211_local *local, bool enabled)
 {
-	if (unlikely(!local->radio_led))
+	if (!atomic_read(&local->radio_led_active))
 		return;
 	if (enabled)
-		led_trigger_event(local->radio_led, LED_FULL);
+		led_trigger_event(&local->radio_led, LED_FULL);
 	else
-		led_trigger_event(local->radio_led, LED_OFF);
+		led_trigger_event(&local->radio_led, LED_OFF);
+}
+
+void ieee80211_alloc_led_names(struct ieee80211_local *local)
+{
+	local->rx_led.name = kasprintf(GFP_KERNEL, "%srx",
+				       wiphy_name(local->hw.wiphy));
+	local->tx_led.name = kasprintf(GFP_KERNEL, "%stx",
+				       wiphy_name(local->hw.wiphy));
+	local->assoc_led.name = kasprintf(GFP_KERNEL, "%sassoc",
+					  wiphy_name(local->hw.wiphy));
+	local->radio_led.name = kasprintf(GFP_KERNEL, "%sradio",
+					  wiphy_name(local->hw.wiphy));
+}
+
+void ieee80211_free_led_names(struct ieee80211_local *local)
+{
+	kfree(local->rx_led.name);
+	kfree(local->tx_led.name);
+	kfree(local->assoc_led.name);
+	kfree(local->radio_led.name);
+}
+
+static void ieee80211_tx_led_activate(struct led_classdev *led_cdev)
+{
+	struct ieee80211_local *local = container_of(led_cdev->trigger,
+						     struct ieee80211_local,
+						     tx_led);
+
+	atomic_inc(&local->tx_led_active);
+}
+
+static void ieee80211_tx_led_deactivate(struct led_classdev *led_cdev)
+{
+	struct ieee80211_local *local = container_of(led_cdev->trigger,
+						     struct ieee80211_local,
+						     tx_led);
+
+	atomic_dec(&local->tx_led_active);
+}
+
+static void ieee80211_rx_led_activate(struct led_classdev *led_cdev)
+{
+	struct ieee80211_local *local = container_of(led_cdev->trigger,
+						     struct ieee80211_local,
+						     rx_led);
+
+	atomic_inc(&local->rx_led_active);
+}
+
+static void ieee80211_rx_led_deactivate(struct led_classdev *led_cdev)
+{
+	struct ieee80211_local *local = container_of(led_cdev->trigger,
+						     struct ieee80211_local,
+						     rx_led);
+
+	atomic_dec(&local->rx_led_active);
+}
+
+static void ieee80211_assoc_led_activate(struct led_classdev *led_cdev)
+{
+	struct ieee80211_local *local = container_of(led_cdev->trigger,
+						     struct ieee80211_local,
+						     assoc_led);
+
+	atomic_inc(&local->assoc_led_active);
+}
+
+static void ieee80211_assoc_led_deactivate(struct led_classdev *led_cdev)
+{
+	struct ieee80211_local *local = container_of(led_cdev->trigger,
+						     struct ieee80211_local,
+						     assoc_led);
+
+	atomic_dec(&local->assoc_led_active);
+}
+
+static void ieee80211_radio_led_activate(struct led_classdev *led_cdev)
+{
+	struct ieee80211_local *local = container_of(led_cdev->trigger,
+						     struct ieee80211_local,
+						     radio_led);
+
+	atomic_inc(&local->radio_led_active);
+}
+
+static void ieee80211_radio_led_deactivate(struct led_classdev *led_cdev)
+{
+	struct ieee80211_local *local = container_of(led_cdev->trigger,
+						     struct ieee80211_local,
+						     radio_led);
+
+	atomic_dec(&local->radio_led_active);
+}
+
+static void ieee80211_tpt_led_activate(struct led_classdev *led_cdev)
+{
+	struct ieee80211_local *local = container_of(led_cdev->trigger,
+						     struct ieee80211_local,
+						     tpt_led);
+
+	atomic_inc(&local->tpt_led_active);
 }
 
-void ieee80211_led_names(struct ieee80211_local *local)
+static void ieee80211_tpt_led_deactivate(struct led_classdev *led_cdev)
 {
-	snprintf(local->rx_led_name, sizeof(local->rx_led_name),
-		 "%srx", wiphy_name(local->hw.wiphy));
-	snprintf(local->tx_led_name, sizeof(local->tx_led_name),
-		 "%stx", wiphy_name(local->hw.wiphy));
-	snprintf(local->assoc_led_name, sizeof(local->assoc_led_name),
-		 "%sassoc", wiphy_name(local->hw.wiphy));
-	snprintf(local->radio_led_name, sizeof(local->radio_led_name),
-		 "%sradio", wiphy_name(local->hw.wiphy));
+	struct ieee80211_local *local = container_of(led_cdev->trigger,
+						     struct ieee80211_local,
+						     tpt_led);
+
+	atomic_dec(&local->tpt_led_active);
 }
 
 void ieee80211_led_init(struct ieee80211_local *local)
 {
-	local->rx_led = kzalloc(sizeof(struct led_trigger), GFP_KERNEL);
-	if (local->rx_led) {
-		local->rx_led->name = local->rx_led_name;
-		if (led_trigger_register(local->rx_led)) {
-			kfree(local->rx_led);
-			local->rx_led = NULL;
-		}
+	atomic_set(&local->rx_led_active, 0);
+	local->rx_led.activate = ieee80211_rx_led_activate;
+	local->rx_led.deactivate = ieee80211_rx_led_deactivate;
+	if (local->rx_led.name && led_trigger_register(&local->rx_led)) {
+		kfree(local->rx_led.name);
+		local->rx_led.name = NULL;
 	}
 
-	local->tx_led = kzalloc(sizeof(struct led_trigger), GFP_KERNEL);
-	if (local->tx_led) {
-		local->tx_led->name = local->tx_led_name;
-		if (led_trigger_register(local->tx_led)) {
-			kfree(local->tx_led);
-			local->tx_led = NULL;
-		}
+	atomic_set(&local->tx_led_active, 0);
+	local->tx_led.activate = ieee80211_tx_led_activate;
+	local->tx_led.deactivate = ieee80211_tx_led_deactivate;
+	if (local->tx_led.name && led_trigger_register(&local->tx_led)) {
+		kfree(local->tx_led.name);
+		local->tx_led.name = NULL;
 	}
 
-	local->assoc_led = kzalloc(sizeof(struct led_trigger), GFP_KERNEL);
-	if (local->assoc_led) {
-		local->assoc_led->name = local->assoc_led_name;
-		if (led_trigger_register(local->assoc_led)) {
-			kfree(local->assoc_led);
-			local->assoc_led = NULL;
-		}
+	atomic_set(&local->assoc_led_active, 0);
+	local->assoc_led.activate = ieee80211_assoc_led_activate;
+	local->assoc_led.deactivate = ieee80211_assoc_led_deactivate;
+	if (local->assoc_led.name && led_trigger_register(&local->assoc_led)) {
+		kfree(local->assoc_led.name);
+		local->assoc_led.name = NULL;
 	}
 
-	local->radio_led = kzalloc(sizeof(struct led_trigger), GFP_KERNEL);
-	if (local->radio_led) {
-		local->radio_led->name = local->radio_led_name;
-		if (led_trigger_register(local->radio_led)) {
-			kfree(local->radio_led);
-			local->radio_led = NULL;
-		}
+	atomic_set(&local->radio_led_active, 0);
+	local->radio_led.activate = ieee80211_radio_led_activate;
+	local->radio_led.deactivate = ieee80211_radio_led_deactivate;
+	if (local->radio_led.name && led_trigger_register(&local->radio_led)) {
+		kfree(local->radio_led.name);
+		local->radio_led.name = NULL;
 	}
 
+	atomic_set(&local->tpt_led_active, 0);
 	if (local->tpt_led_trigger) {
-		if (led_trigger_register(&local->tpt_led_trigger->trig)) {
+		local->tpt_led.activate = ieee80211_tpt_led_activate;
+		local->tpt_led.deactivate = ieee80211_tpt_led_deactivate;
+		if (led_trigger_register(&local->tpt_led)) {
 			kfree(local->tpt_led_trigger);
 			local->tpt_led_trigger = NULL;
 		}
@@ -110,25 +189,17 @@ void ieee80211_led_init(struct ieee80211_local *local)
 
 void ieee80211_led_exit(struct ieee80211_local *local)
 {
-	if (local->radio_led) {
-		led_trigger_unregister(local->radio_led);
-		kfree(local->radio_led);
-	}
-	if (local->assoc_led) {
-		led_trigger_unregister(local->assoc_led);
-		kfree(local->assoc_led);
-	}
-	if (local->tx_led) {
-		led_trigger_unregister(local->tx_led);
-		kfree(local->tx_led);
-	}
-	if (local->rx_led) {
-		led_trigger_unregister(local->rx_led);
-		kfree(local->rx_led);
-	}
+	if (local->radio_led.name)
+		led_trigger_unregister(&local->radio_led);
+	if (local->assoc_led.name)
+		led_trigger_unregister(&local->assoc_led);
+	if (local->tx_led.name)
+		led_trigger_unregister(&local->tx_led);
+	if (local->rx_led.name)
+		led_trigger_unregister(&local->rx_led);
 
 	if (local->tpt_led_trigger) {
-		led_trigger_unregister(&local->tpt_led_trigger->trig);
+		led_trigger_unregister(&local->tpt_led);
 		kfree(local->tpt_led_trigger);
 	}
 }
@@ -137,7 +208,7 @@ const char *__ieee80211_get_radio_led_name(struct ieee80211_hw *hw)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
 
-	return local->radio_led_name;
+	return local->radio_led.name;
 }
 EXPORT_SYMBOL(__ieee80211_get_radio_led_name);
 
@@ -145,7 +216,7 @@ const char *__ieee80211_get_assoc_led_name(struct ieee80211_hw *hw)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
 
-	return local->assoc_led_name;
+	return local->assoc_led.name;
 }
 EXPORT_SYMBOL(__ieee80211_get_assoc_led_name);
 
@@ -153,7 +224,7 @@ const char *__ieee80211_get_tx_led_name(struct ieee80211_hw *hw)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
 
-	return local->tx_led_name;
+	return local->tx_led.name;
 }
 EXPORT_SYMBOL(__ieee80211_get_tx_led_name);
 
@@ -161,7 +232,7 @@ const char *__ieee80211_get_rx_led_name(struct ieee80211_hw *hw)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
 
-	return local->rx_led_name;
+	return local->rx_led.name;
 }
 EXPORT_SYMBOL(__ieee80211_get_rx_led_name);
 
@@ -230,7 +301,7 @@ __ieee80211_create_tpt_led_trigger(struct ieee80211_hw *hw,
 	snprintf(tpt_trig->name, sizeof(tpt_trig->name),
 		 "%stpt", wiphy_name(local->hw.wiphy));
 
-	tpt_trig->trig.name = tpt_trig->name;
+	local->tpt_led.name = tpt_trig->name;
 
 	tpt_trig->blink_table = blink_table;
 	tpt_trig->blink_table_len = blink_table_len;
diff --git a/net/mac80211/led.h b/net/mac80211/led.h
index 89f4344f13b9..a7893a1ac98b 100644
--- a/net/mac80211/led.h
+++ b/net/mac80211/led.h
@@ -11,25 +11,42 @@
 #include <linux/leds.h>
 #include "ieee80211_i.h"
 
+#define MAC80211_BLINK_DELAY 50 /* ms */
+
+static inline void ieee80211_led_rx(struct ieee80211_local *local)
+{
+#ifdef CONFIG_MAC80211_LEDS
+	unsigned long led_delay = MAC80211_BLINK_DELAY;
+
+	if (!atomic_read(&local->rx_led_active))
+		return;
+	led_trigger_blink_oneshot(&local->rx_led, &led_delay, &led_delay, 0);
+#endif
+}
+
+static inline void ieee80211_led_tx(struct ieee80211_local *local)
+{
+#ifdef CONFIG_MAC80211_LEDS
+	unsigned long led_delay = MAC80211_BLINK_DELAY;
+
+	if (!atomic_read(&local->tx_led_active))
+		return;
+	led_trigger_blink_oneshot(&local->tx_led, &led_delay, &led_delay, 0);
+#endif
+}
+
 #ifdef CONFIG_MAC80211_LEDS
-void ieee80211_led_rx(struct ieee80211_local *local);
-void ieee80211_led_tx(struct ieee80211_local *local);
 void ieee80211_led_assoc(struct ieee80211_local *local,
 			 bool associated);
 void ieee80211_led_radio(struct ieee80211_local *local,
 			 bool enabled);
-void ieee80211_led_names(struct ieee80211_local *local);
+void ieee80211_alloc_led_names(struct ieee80211_local *local);
+void ieee80211_free_led_names(struct ieee80211_local *local);
 void ieee80211_led_init(struct ieee80211_local *local);
 void ieee80211_led_exit(struct ieee80211_local *local);
 void ieee80211_mod_tpt_led_trig(struct ieee80211_local *local,
 				unsigned int types_on, unsigned int types_off);
 #else
-static inline void ieee80211_led_rx(struct ieee80211_local *local)
-{
-}
-static inline void ieee80211_led_tx(struct ieee80211_local *local)
-{
-}
 static inline void ieee80211_led_assoc(struct ieee80211_local *local,
 				       bool associated)
 {
@@ -38,7 +55,10 @@ static inline void ieee80211_led_radio(struct ieee80211_local *local,
 				       bool enabled)
 {
 }
-static inline void ieee80211_led_names(struct ieee80211_local *local)
+static inline void ieee80211_alloc_led_names(struct ieee80211_local *local)
+{
+}
+static inline void ieee80211_free_led_names(struct ieee80211_local *local)
 {
 }
 static inline void ieee80211_led_init(struct ieee80211_local *local)
@@ -58,7 +78,7 @@ static inline void
 ieee80211_tpt_led_trig_tx(struct ieee80211_local *local, __le16 fc, int bytes)
 {
 #ifdef CONFIG_MAC80211_LEDS
-	if (local->tpt_led_trigger && ieee80211_is_data(fc))
+	if (ieee80211_is_data(fc) && atomic_read(&local->tpt_led_active))
 		local->tpt_led_trigger->tx_bytes += bytes;
 #endif
 }
@@ -67,7 +87,7 @@ static inline void
 ieee80211_tpt_led_trig_rx(struct ieee80211_local *local, __le16 fc, int bytes)
 {
 #ifdef CONFIG_MAC80211_LEDS
-	if (local->tpt_led_trigger && ieee80211_is_data(fc))
+	if (ieee80211_is_data(fc) && atomic_read(&local->tpt_led_active))
 		local->tpt_led_trigger->rx_bytes += bytes;
 #endif
 }
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 5c2ce0322f04..b4e29f9c73c8 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -643,7 +643,7 @@ struct ieee80211_hw *ieee80211_alloc_hw_nm(size_t priv_data_len,
 	skb_queue_head_init(&local->skb_queue);
 	skb_queue_head_init(&local->skb_queue_unreliable);
 
-	ieee80211_led_names(local);
+	ieee80211_alloc_led_names(local);
 
 	ieee80211_roc_setup(local);
 
@@ -1205,6 +1205,8 @@ void ieee80211_free_hw(struct ieee80211_hw *hw)
 
 	sta_info_stop(local);
 
+	ieee80211_free_led_names(local);
+
 	wiphy_free(local->hw.wiphy);
 }
 EXPORT_SYMBOL(ieee80211_free_hw);
-- 
2.1.4

