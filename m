Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60663 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753404Ab0K0TDA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Nov 2010 14:03:00 -0500
Subject: [PATCH 1/2] mac80211: make LED trigger names available early
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 27 Nov 2010 20:02:59 +0100
Message-ID: <1290884579.3700.2.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The throughput trigger will require doing LED
classdev/trigger handling before register_hw(),
so drivers should have access to the trigger
names before it. If trigger registration fails,
this will still make the trigger name available,
but that's not a big problem since the default
trigger will the simply not be found.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/led.c  |   36 ++++++++++++++++--------------------
 net/mac80211/led.h  |    4 ++++
 net/mac80211/main.c |    2 ++
 3 files changed, 22 insertions(+), 20 deletions(-)

--- wireless-testing.orig/net/mac80211/led.c	2010-11-27 19:02:30.000000000 +0100
+++ wireless-testing/net/mac80211/led.c	2010-11-27 19:32:27.000000000 +0100
@@ -54,12 +54,22 @@ void ieee80211_led_radio(struct ieee8021
 		led_trigger_event(local->radio_led, LED_OFF);
 }
 
+void ieee80211_led_names(struct ieee80211_local *local)
+{
+	snprintf(local->rx_led_name, sizeof(local->rx_led_name),
+		 "%srx", wiphy_name(local->hw.wiphy));
+	snprintf(local->tx_led_name, sizeof(local->tx_led_name),
+		 "%stx", wiphy_name(local->hw.wiphy));
+	snprintf(local->assoc_led_name, sizeof(local->assoc_led_name),
+		 "%sassoc", wiphy_name(local->hw.wiphy));
+	snprintf(local->radio_led_name, sizeof(local->radio_led_name),
+		 "%sradio", wiphy_name(local->hw.wiphy));
+}
+
 void ieee80211_led_init(struct ieee80211_local *local)
 {
 	local->rx_led = kzalloc(sizeof(struct led_trigger), GFP_KERNEL);
 	if (local->rx_led) {
-		snprintf(local->rx_led_name, sizeof(local->rx_led_name),
-			 "%srx", wiphy_name(local->hw.wiphy));
 		local->rx_led->name = local->rx_led_name;
 		if (led_trigger_register(local->rx_led)) {
 			kfree(local->rx_led);
@@ -69,8 +79,6 @@ void ieee80211_led_init(struct ieee80211
 
 	local->tx_led = kzalloc(sizeof(struct led_trigger), GFP_KERNEL);
 	if (local->tx_led) {
-		snprintf(local->tx_led_name, sizeof(local->tx_led_name),
-			 "%stx", wiphy_name(local->hw.wiphy));
 		local->tx_led->name = local->tx_led_name;
 		if (led_trigger_register(local->tx_led)) {
 			kfree(local->tx_led);
@@ -80,8 +88,6 @@ void ieee80211_led_init(struct ieee80211
 
 	local->assoc_led = kzalloc(sizeof(struct led_trigger), GFP_KERNEL);
 	if (local->assoc_led) {
-		snprintf(local->assoc_led_name, sizeof(local->assoc_led_name),
-			 "%sassoc", wiphy_name(local->hw.wiphy));
 		local->assoc_led->name = local->assoc_led_name;
 		if (led_trigger_register(local->assoc_led)) {
 			kfree(local->assoc_led);
@@ -91,8 +97,6 @@ void ieee80211_led_init(struct ieee80211
 
 	local->radio_led = kzalloc(sizeof(struct led_trigger), GFP_KERNEL);
 	if (local->radio_led) {
-		snprintf(local->radio_led_name, sizeof(local->radio_led_name),
-			 "%sradio", wiphy_name(local->hw.wiphy));
 		local->radio_led->name = local->radio_led_name;
 		if (led_trigger_register(local->radio_led)) {
 			kfree(local->radio_led);
@@ -125,9 +129,7 @@ char *__ieee80211_get_radio_led_name(str
 {
 	struct ieee80211_local *local = hw_to_local(hw);
 
-	if (local->radio_led)
-		return local->radio_led_name;
-	return NULL;
+	return local->radio_led_name;
 }
 EXPORT_SYMBOL(__ieee80211_get_radio_led_name);
 
@@ -135,9 +137,7 @@ char *__ieee80211_get_assoc_led_name(str
 {
 	struct ieee80211_local *local = hw_to_local(hw);
 
-	if (local->assoc_led)
-		return local->assoc_led_name;
-	return NULL;
+	return local->assoc_led_name;
 }
 EXPORT_SYMBOL(__ieee80211_get_assoc_led_name);
 
@@ -145,9 +145,7 @@ char *__ieee80211_get_tx_led_name(struct
 {
 	struct ieee80211_local *local = hw_to_local(hw);
 
-	if (local->tx_led)
-		return local->tx_led_name;
-	return NULL;
+	return local->tx_led_name;
 }
 EXPORT_SYMBOL(__ieee80211_get_tx_led_name);
 
@@ -155,8 +153,6 @@ char *__ieee80211_get_rx_led_name(struct
 {
 	struct ieee80211_local *local = hw_to_local(hw);
 
-	if (local->rx_led)
-		return local->rx_led_name;
-	return NULL;
+	return local->rx_led_name;
 }
 EXPORT_SYMBOL(__ieee80211_get_rx_led_name);
--- wireless-testing.orig/net/mac80211/led.h	2010-11-27 19:05:41.000000000 +0100
+++ wireless-testing/net/mac80211/led.h	2010-11-27 19:32:27.000000000 +0100
@@ -18,6 +18,7 @@ extern void ieee80211_led_assoc(struct i
 				bool associated);
 extern void ieee80211_led_radio(struct ieee80211_local *local,
 				bool enabled);
+extern void ieee80211_led_names(struct ieee80211_local *local);
 extern void ieee80211_led_init(struct ieee80211_local *local);
 extern void ieee80211_led_exit(struct ieee80211_local *local);
 #else
@@ -35,6 +36,9 @@ static inline void ieee80211_led_radio(s
 				       bool enabled)
 {
 }
+static inline void ieee80211_led_names(struct ieee80211_local *local)
+{
+}
 static inline void ieee80211_led_init(struct ieee80211_local *local)
 {
 }
--- wireless-testing.orig/net/mac80211/main.c	2010-11-27 19:06:12.000000000 +0100
+++ wireless-testing/net/mac80211/main.c	2010-11-27 19:06:32.000000000 +0100
@@ -593,6 +593,8 @@ struct ieee80211_hw *ieee80211_alloc_hw(
 	/* init dummy netdev for use w/ NAPI */
 	init_dummy_netdev(&local->napi_dev);
 
+	ieee80211_led_names(local);
+
 	return local_to_hw(local);
 }
 EXPORT_SYMBOL(ieee80211_alloc_hw);


