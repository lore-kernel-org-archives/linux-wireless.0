Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:39502 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030227AbbDXJV3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Apr 2015 05:21:29 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 1/2] mac80211: make LED trigger names const
Date: Fri, 24 Apr 2015 11:21:24 +0200
Message-Id: <1429867285-18325-1-git-send-email-johannes@sipsolutions.net> (sfid-20150424_112134_672491_6C84C122)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This is just a code cleanup, make the LED trigger names const
as they're not expected to be modified by drivers.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/ath/ath5k/led.c    |  2 +-
 drivers/net/wireless/ath/carl9170/led.c |  2 +-
 drivers/net/wireless/p54/led.c          |  2 +-
 include/net/mac80211.h                  | 27 ++++++++++++++-------------
 net/mac80211/led.c                      | 17 +++++++++--------
 5 files changed, 26 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/led.c b/drivers/net/wireless/ath/ath5k/led.c
index ca4b7ccd697f..803030fd17d3 100644
--- a/drivers/net/wireless/ath/ath5k/led.c
+++ b/drivers/net/wireless/ath/ath5k/led.c
@@ -124,7 +124,7 @@ ath5k_led_brightness_set(struct led_classdev *led_dev,
 
 static int
 ath5k_register_led(struct ath5k_hw *ah, struct ath5k_led *led,
-		   const char *name, char *trigger)
+		   const char *name, const char *trigger)
 {
 	int err;
 
diff --git a/drivers/net/wireless/ath/carl9170/led.c b/drivers/net/wireless/ath/carl9170/led.c
index 78dadc797558..2c74425f5059 100644
--- a/drivers/net/wireless/ath/carl9170/led.c
+++ b/drivers/net/wireless/ath/carl9170/led.c
@@ -122,7 +122,7 @@ static void carl9170_led_set_brightness(struct led_classdev *led,
 }
 
 static int carl9170_led_register_led(struct ar9170 *ar, int i, char *name,
-				     char *trigger)
+				     const char *trigger)
 {
 	int err;
 
diff --git a/drivers/net/wireless/p54/led.c b/drivers/net/wireless/p54/led.c
index 1f6fd5ff5531..9a8fedd3c0f5 100644
--- a/drivers/net/wireless/p54/led.c
+++ b/drivers/net/wireless/p54/led.c
@@ -83,7 +83,7 @@ static void p54_led_brightness_set(struct led_classdev *led_dev,
 
 static int p54_register_led(struct p54_common *priv,
 			    unsigned int led_index,
-			    char *name, char *trigger)
+			    char *name, const char *trigger)
 {
 	struct p54_led_dev *led = &priv->leds[led_index];
 	int err;
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 6775245beb91..1e3cf98619ff 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -3474,14 +3474,15 @@ enum ieee80211_tpt_led_trigger_flags {
 };
 
 #ifdef CONFIG_MAC80211_LEDS
-char *__ieee80211_get_tx_led_name(struct ieee80211_hw *hw);
-char *__ieee80211_get_rx_led_name(struct ieee80211_hw *hw);
-char *__ieee80211_get_assoc_led_name(struct ieee80211_hw *hw);
-char *__ieee80211_get_radio_led_name(struct ieee80211_hw *hw);
-char *__ieee80211_create_tpt_led_trigger(struct ieee80211_hw *hw,
-					 unsigned int flags,
-					 const struct ieee80211_tpt_blink *blink_table,
-					 unsigned int blink_table_len);
+const char *__ieee80211_get_tx_led_name(struct ieee80211_hw *hw);
+const char *__ieee80211_get_rx_led_name(struct ieee80211_hw *hw);
+const char *__ieee80211_get_assoc_led_name(struct ieee80211_hw *hw);
+const char *__ieee80211_get_radio_led_name(struct ieee80211_hw *hw);
+const char *
+__ieee80211_create_tpt_led_trigger(struct ieee80211_hw *hw,
+				   unsigned int flags,
+				   const struct ieee80211_tpt_blink *blink_table,
+				   unsigned int blink_table_len);
 #endif
 /**
  * ieee80211_get_tx_led_name - get name of TX LED
@@ -3495,7 +3496,7 @@ char *__ieee80211_create_tpt_led_trigger(struct ieee80211_hw *hw,
  *
  * Return: The name of the LED trigger. %NULL if not configured for LEDs.
  */
-static inline char *ieee80211_get_tx_led_name(struct ieee80211_hw *hw)
+static inline const char *ieee80211_get_tx_led_name(struct ieee80211_hw *hw)
 {
 #ifdef CONFIG_MAC80211_LEDS
 	return __ieee80211_get_tx_led_name(hw);
@@ -3516,7 +3517,7 @@ static inline char *ieee80211_get_tx_led_name(struct ieee80211_hw *hw)
  *
  * Return: The name of the LED trigger. %NULL if not configured for LEDs.
  */
-static inline char *ieee80211_get_rx_led_name(struct ieee80211_hw *hw)
+static inline const char *ieee80211_get_rx_led_name(struct ieee80211_hw *hw)
 {
 #ifdef CONFIG_MAC80211_LEDS
 	return __ieee80211_get_rx_led_name(hw);
@@ -3537,7 +3538,7 @@ static inline char *ieee80211_get_rx_led_name(struct ieee80211_hw *hw)
  *
  * Return: The name of the LED trigger. %NULL if not configured for LEDs.
  */
-static inline char *ieee80211_get_assoc_led_name(struct ieee80211_hw *hw)
+static inline const char *ieee80211_get_assoc_led_name(struct ieee80211_hw *hw)
 {
 #ifdef CONFIG_MAC80211_LEDS
 	return __ieee80211_get_assoc_led_name(hw);
@@ -3558,7 +3559,7 @@ static inline char *ieee80211_get_assoc_led_name(struct ieee80211_hw *hw)
  *
  * Return: The name of the LED trigger. %NULL if not configured for LEDs.
  */
-static inline char *ieee80211_get_radio_led_name(struct ieee80211_hw *hw)
+static inline const char *ieee80211_get_radio_led_name(struct ieee80211_hw *hw)
 {
 #ifdef CONFIG_MAC80211_LEDS
 	return __ieee80211_get_radio_led_name(hw);
@@ -3579,7 +3580,7 @@ static inline char *ieee80211_get_radio_led_name(struct ieee80211_hw *hw)
  *
  * Note: This function must be called before ieee80211_register_hw().
  */
-static inline char *
+static inline const char *
 ieee80211_create_tpt_led_trigger(struct ieee80211_hw *hw, unsigned int flags,
 				 const struct ieee80211_tpt_blink *blink_table,
 				 unsigned int blink_table_len)
diff --git a/net/mac80211/led.c b/net/mac80211/led.c
index e2b836446af3..3e13eb86f85d 100644
--- a/net/mac80211/led.c
+++ b/net/mac80211/led.c
@@ -133,7 +133,7 @@ void ieee80211_led_exit(struct ieee80211_local *local)
 	}
 }
 
-char *__ieee80211_get_radio_led_name(struct ieee80211_hw *hw)
+const char *__ieee80211_get_radio_led_name(struct ieee80211_hw *hw)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
 
@@ -141,7 +141,7 @@ char *__ieee80211_get_radio_led_name(struct ieee80211_hw *hw)
 }
 EXPORT_SYMBOL(__ieee80211_get_radio_led_name);
 
-char *__ieee80211_get_assoc_led_name(struct ieee80211_hw *hw)
+const char *__ieee80211_get_assoc_led_name(struct ieee80211_hw *hw)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
 
@@ -149,7 +149,7 @@ char *__ieee80211_get_assoc_led_name(struct ieee80211_hw *hw)
 }
 EXPORT_SYMBOL(__ieee80211_get_assoc_led_name);
 
-char *__ieee80211_get_tx_led_name(struct ieee80211_hw *hw)
+const char *__ieee80211_get_tx_led_name(struct ieee80211_hw *hw)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
 
@@ -157,7 +157,7 @@ char *__ieee80211_get_tx_led_name(struct ieee80211_hw *hw)
 }
 EXPORT_SYMBOL(__ieee80211_get_tx_led_name);
 
-char *__ieee80211_get_rx_led_name(struct ieee80211_hw *hw)
+const char *__ieee80211_get_rx_led_name(struct ieee80211_hw *hw)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
 
@@ -211,10 +211,11 @@ static void tpt_trig_timer(unsigned long data)
 	read_unlock(&tpt_trig->trig.leddev_list_lock);
 }
 
-char *__ieee80211_create_tpt_led_trigger(struct ieee80211_hw *hw,
-				unsigned int flags,
-				const struct ieee80211_tpt_blink *blink_table,
-				unsigned int blink_table_len)
+const char *
+__ieee80211_create_tpt_led_trigger(struct ieee80211_hw *hw,
+				   unsigned int flags,
+				   const struct ieee80211_tpt_blink *blink_table,
+				   unsigned int blink_table_len)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
 	struct tpt_led_trigger *tpt_trig;
-- 
2.1.4

