Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:52996
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755773AbXI0NNX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Sep 2007 09:13:23 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] mac80211: Add association LED trigger
Date: Thu, 27 Sep 2007 15:10:44 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200709271510.45121.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Many devices have LEDs to indicate the link status.
Export this functionality to drivers.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

Index: wireless-2.6/include/net/mac80211.h
===================================================================
--- wireless-2.6.orig/include/net/mac80211.h	2007-09-26 20:31:04.000000000 +0200
+++ wireless-2.6/include/net/mac80211.h	2007-09-27 12:02:26.000000000 +0200
@@ -926,6 +926,7 @@ int ieee80211_register_hw(struct ieee802
 #ifdef CONFIG_MAC80211_LEDS
 extern char *__ieee80211_get_tx_led_name(struct ieee80211_hw *hw);
 extern char *__ieee80211_get_rx_led_name(struct ieee80211_hw *hw);
+extern char *__ieee80211_get_assoc_led_name(struct ieee80211_hw *hw);
 #endif
 static inline char *ieee80211_get_tx_led_name(struct ieee80211_hw *hw)
 {
@@ -945,6 +946,16 @@ static inline char *ieee80211_get_rx_led
 #endif
 }
 
+static inline char *ieee80211_get_assoc_led_name(struct ieee80211_hw *hw)
+{
+#ifdef CONFIG_MAC80211_LEDS
+	return __ieee80211_get_assoc_led_name(hw);
+#else
+	return NULL;
+#endif
+}
+
+
 /* Register a new hardware PHYMODE capability to the stack. */
 int ieee80211_register_hwmode(struct ieee80211_hw *hw,
 			      struct ieee80211_hw_mode *mode);
Index: wireless-2.6/net/mac80211/ieee80211_i.h
===================================================================
--- wireless-2.6.orig/net/mac80211/ieee80211_i.h	2007-09-26 23:28:42.000000000 +0200
+++ wireless-2.6/net/mac80211/ieee80211_i.h	2007-09-27 12:03:32.000000000 +0200
@@ -510,8 +510,8 @@ struct ieee80211_local {
 
 #ifdef CONFIG_MAC80211_LEDS
 	int tx_led_counter, rx_led_counter;
-	struct led_trigger *tx_led, *rx_led;
-	char tx_led_name[32], rx_led_name[32];
+	struct led_trigger *tx_led, *rx_led, *assoc_led;
+	char tx_led_name[32], rx_led_name[32], assoc_led_name[32];
 #endif
 
 	u32 channel_use;
Index: wireless-2.6/net/mac80211/ieee80211_led.c
===================================================================
--- wireless-2.6.orig/net/mac80211/ieee80211_led.c	2007-09-26 17:22:49.000000000 +0200
+++ wireless-2.6/net/mac80211/ieee80211_led.c	2007-09-27 12:16:41.000000000 +0200
@@ -33,33 +33,58 @@ void ieee80211_led_tx(struct ieee80211_l
 		led_trigger_event(local->tx_led, LED_FULL);
 }
 
+void ieee80211_led_assoc(struct ieee80211_local *local, bool associated)
+{
+	if (unlikely(!local->assoc_led))
+		return;
+	if (associated)
+		led_trigger_event(local->assoc_led, LED_FULL);
+	else
+		led_trigger_event(local->assoc_led, LED_OFF);
+}
+
 void ieee80211_led_init(struct ieee80211_local *local)
 {
 	local->rx_led = kzalloc(sizeof(struct led_trigger), GFP_KERNEL);
-	if (!local->rx_led)
-		return;
-	snprintf(local->rx_led_name, sizeof(local->rx_led_name),
-		 "%srx", wiphy_name(local->hw.wiphy));
-	local->rx_led->name = local->rx_led_name;
-	if (led_trigger_register(local->rx_led)) {
-		kfree(local->rx_led);
-		local->rx_led = NULL;
+	if (local->rx_led) {
+		snprintf(local->rx_led_name, sizeof(local->rx_led_name),
+			 "%srx", wiphy_name(local->hw.wiphy));
+		local->rx_led->name = local->rx_led_name;
+		if (led_trigger_register(local->rx_led)) {
+			kfree(local->rx_led);
+			local->rx_led = NULL;
+		}
 	}
 
 	local->tx_led = kzalloc(sizeof(struct led_trigger), GFP_KERNEL);
-	if (!local->tx_led)
-		return;
-	snprintf(local->tx_led_name, sizeof(local->tx_led_name),
-		 "%stx", wiphy_name(local->hw.wiphy));
-	local->tx_led->name = local->tx_led_name;
-	if (led_trigger_register(local->tx_led)) {
-		kfree(local->tx_led);
-		local->tx_led = NULL;
+	if (local->tx_led) {
+		snprintf(local->tx_led_name, sizeof(local->tx_led_name),
+			 "%stx", wiphy_name(local->hw.wiphy));
+		local->tx_led->name = local->tx_led_name;
+		if (led_trigger_register(local->tx_led)) {
+			kfree(local->tx_led);
+			local->tx_led = NULL;
+		}
+	}
+
+	local->assoc_led = kzalloc(sizeof(struct led_trigger), GFP_KERNEL);
+	if (local->assoc_led) {
+		snprintf(local->assoc_led_name, sizeof(local->assoc_led_name),
+			 "%sassoc", wiphy_name(local->hw.wiphy));
+		local->assoc_led->name = local->assoc_led_name;
+		if (led_trigger_register(local->assoc_led)) {
+			kfree(local->assoc_led);
+			local->assoc_led = NULL;
+		}
 	}
 }
 
 void ieee80211_led_exit(struct ieee80211_local *local)
 {
+	if (local->assoc_led) {
+		led_trigger_unregister(local->assoc_led);
+		kfree(local->assoc_led);
+	}
 	if (local->tx_led) {
 		led_trigger_unregister(local->tx_led);
 		kfree(local->tx_led);
@@ -70,6 +95,16 @@ void ieee80211_led_exit(struct ieee80211
 	}
 }
 
+char *__ieee80211_get_assoc_led_name(struct ieee80211_hw *hw)
+{
+	struct ieee80211_local *local = hw_to_local(hw);
+
+	if (local->assoc_led)
+		return local->assoc_led_name;
+	return NULL;
+}
+EXPORT_SYMBOL(__ieee80211_get_assoc_led_name);
+
 char *__ieee80211_get_tx_led_name(struct ieee80211_hw *hw)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
Index: wireless-2.6/net/mac80211/ieee80211_led.h
===================================================================
--- wireless-2.6.orig/net/mac80211/ieee80211_led.h	2007-09-26 17:22:49.000000000 +0200
+++ wireless-2.6/net/mac80211/ieee80211_led.h	2007-09-27 12:18:02.000000000 +0200
@@ -14,6 +14,8 @@
 #ifdef CONFIG_MAC80211_LEDS
 extern void ieee80211_led_rx(struct ieee80211_local *local);
 extern void ieee80211_led_tx(struct ieee80211_local *local, int q);
+extern void ieee80211_led_assoc(struct ieee80211_local *local,
+				bool associated);
 extern void ieee80211_led_init(struct ieee80211_local *local);
 extern void ieee80211_led_exit(struct ieee80211_local *local);
 #else
@@ -23,6 +25,10 @@ static inline void ieee80211_led_rx(stru
 static inline void ieee80211_led_tx(struct ieee80211_local *local, int q)
 {
 }
+static inline void ieee80211_led_assoc(struct ieee80211_local *local,
+				       bool associated)
+{
+}
 static inline void ieee80211_led_init(struct ieee80211_local *local)
 {
 }
Index: wireless-2.6/net/mac80211/ieee80211_sta.c
===================================================================
--- wireless-2.6.orig/net/mac80211/ieee80211_sta.c	2007-09-26 20:31:04.000000000 +0200
+++ wireless-2.6/net/mac80211/ieee80211_sta.c	2007-09-27 12:27:04.000000000 +0200
@@ -31,6 +31,7 @@
 #include <net/mac80211.h>
 #include "ieee80211_i.h"
 #include "ieee80211_rate.h"
+#include "ieee80211_led.h"
 #include "hostapd_ioctl.h"
 
 #define IEEE80211_AUTH_TIMEOUT (HZ / 5)
@@ -408,8 +409,9 @@ static void ieee80211_sta_send_associnfo
 
 static void ieee80211_set_associated(struct net_device *dev,
 				     struct ieee80211_if_sta *ifsta,
-				     unsigned int assoc)
+				     bool assoc)
 {
+	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	union iwreq_data wrqu;
 
 	if (!!(ifsta->flags & IEEE80211_STA_ASSOCIATED) == assoc)
@@ -447,6 +449,7 @@ static void ieee80211_set_associated(str
 	wrqu.ap_addr.sa_family = ARPHRD_ETHER;
 	wireless_send_event(dev, SIOCGIWAP, &wrqu, NULL);
 	ifsta->last_probe = jiffies;
+	ieee80211_led_assoc(local, assoc);
 }
 
 static void ieee80211_set_disassoc(struct net_device *dev,
