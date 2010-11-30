Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57424 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754117Ab0K3H7Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Nov 2010 02:59:25 -0500
Subject: [PATCH] mac80211: selective throughput LED trigger active
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 30 Nov 2010 08:59:23 +0100
Message-ID: <1291103963.3624.2.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The throughput LED trigger was always active when
the radio was enabled. In most cases that's likely
the desired behaviour, but iwlwifi requires it to
be only active when one of the virtual interfaces
is actually "connected" in some way.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h     |   20 +++++++++++++++++---
 net/mac80211/ieee80211_i.h |    3 ++-
 net/mac80211/iface.c       |   16 +++++++++++++++-
 net/mac80211/led.c         |   39 ++++++++++++++++++++++++++++++++++-----
 net/mac80211/led.h         |   11 +++++------
 net/mac80211/util.c        |    5 +++--
 6 files changed, 76 insertions(+), 18 deletions(-)

--- wireless-testing.orig/include/net/mac80211.h	2010-11-30 08:56:36.000000000 +0100
+++ wireless-testing/include/net/mac80211.h	2010-11-30 08:56:54.000000000 +0100
@@ -1863,13 +1863,26 @@ struct ieee80211_tpt_blink {
 	int blink_time;
 };
 
+/**
+ * enum ieee80211_tpt_led_trigger_flags - throughput trigger flags
+ * @IEEE80211_TPT_LEDTRIG_FL_RADIO: enable blinking with radio
+ * @IEEE80211_TPT_LEDTRIG_FL_WORK: enable blinking when working
+ * @IEEE80211_TPT_LEDTRIG_FL_CONNECTED: enable blinking when at least one
+ *	interface is connected in some way, including being an AP
+ */
+enum ieee80211_tpt_led_trigger_flags {
+	IEEE80211_TPT_LEDTRIG_FL_RADIO		= BIT(0),
+	IEEE80211_TPT_LEDTRIG_FL_WORK		= BIT(1),
+	IEEE80211_TPT_LEDTRIG_FL_CONNECTED	= BIT(2),
+};
+
 #ifdef CONFIG_MAC80211_LEDS
 extern char *__ieee80211_get_tx_led_name(struct ieee80211_hw *hw);
 extern char *__ieee80211_get_rx_led_name(struct ieee80211_hw *hw);
 extern char *__ieee80211_get_assoc_led_name(struct ieee80211_hw *hw);
 extern char *__ieee80211_get_radio_led_name(struct ieee80211_hw *hw);
 extern char *__ieee80211_create_tpt_led_trigger(
-				struct ieee80211_hw *hw,
+				struct ieee80211_hw *hw, unsigned int flags,
 				const struct ieee80211_tpt_blink *blink_table,
 				unsigned int blink_table_len);
 #endif
@@ -1952,6 +1965,7 @@ static inline char *ieee80211_get_radio_
 /**
  * ieee80211_create_tpt_led_trigger - create throughput LED trigger
  * @hw: the hardware to create the trigger for
+ * @flags: trigger flags, see &enum ieee80211_tpt_led_trigger_flags
  * @blink_table: the blink table -- needs to be ordered by throughput
  * @blink_table_len: size of the blink table
  *
@@ -1960,12 +1974,12 @@ static inline char *ieee80211_get_radio_
  * This function must be called before ieee80211_register_hw().
  */
 static inline char *
-ieee80211_create_tpt_led_trigger(struct ieee80211_hw *hw,
+ieee80211_create_tpt_led_trigger(struct ieee80211_hw *hw, unsigned int flags,
 				 const struct ieee80211_tpt_blink *blink_table,
 				 unsigned int blink_table_len)
 {
 #ifdef CONFIG_MAC80211_LEDS
-	return __ieee80211_create_tpt_led_trigger(hw, blink_table,
+	return __ieee80211_create_tpt_led_trigger(hw, flags, blink_table,
 						  blink_table_len);
 #else
 	return NULL;
--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2010-11-30 08:56:36.000000000 +0100
+++ wireless-testing/net/mac80211/ieee80211_i.h	2010-11-30 08:56:54.000000000 +0100
@@ -648,9 +648,10 @@ struct tpt_led_trigger {
 	const struct ieee80211_tpt_blink *blink_table;
 	unsigned int blink_table_len;
 	struct timer_list timer;
-	bool running;
 	unsigned long prev_traffic;
 	unsigned long tx_bytes, rx_bytes;
+	unsigned int active, want;
+	bool running;
 };
 
 /**
--- wireless-testing.orig/net/mac80211/led.c	2010-11-30 08:56:52.000000000 +0100
+++ wireless-testing/net/mac80211/led.c	2010-11-30 08:56:54.000000000 +0100
@@ -216,7 +216,7 @@ static void tpt_trig_timer(unsigned long
 }
 
 extern char *__ieee80211_create_tpt_led_trigger(
-				struct ieee80211_hw *hw,
+				struct ieee80211_hw *hw, unsigned int flags,
 				const struct ieee80211_tpt_blink *blink_table,
 				unsigned int blink_table_len)
 {
@@ -237,6 +237,7 @@ extern char *__ieee80211_create_tpt_led_
 
 	tpt_trig->blink_table = blink_table;
 	tpt_trig->blink_table_len = blink_table_len;
+	tpt_trig->want = flags;
 
 	setup_timer(&tpt_trig->timer, tpt_trig_timer, (unsigned long)local);
 
@@ -246,11 +247,11 @@ extern char *__ieee80211_create_tpt_led_
 }
 EXPORT_SYMBOL(__ieee80211_create_tpt_led_trigger);
 
-void ieee80211_start_tpt_led_trig(struct ieee80211_local *local)
+static void ieee80211_start_tpt_led_trig(struct ieee80211_local *local)
 {
 	struct tpt_led_trigger *tpt_trig = local->tpt_led_trigger;
 
-	if (!tpt_trig)
+	if (tpt_trig->running)
 		return;
 
 	/* reset traffic */
@@ -261,12 +262,12 @@ void ieee80211_start_tpt_led_trig(struct
 	mod_timer(&tpt_trig->timer, round_jiffies(jiffies + HZ));
 }
 
-void ieee80211_stop_tpt_led_trig(struct ieee80211_local *local)
+static void ieee80211_stop_tpt_led_trig(struct ieee80211_local *local)
 {
 	struct tpt_led_trigger *tpt_trig = local->tpt_led_trigger;
 	struct led_classdev *led_cdev;
 
-	if (!tpt_trig)
+	if (!tpt_trig->running)
 		return;
 
 	tpt_trig->running = false;
@@ -277,3 +278,31 @@ void ieee80211_stop_tpt_led_trig(struct
 		led_brightness_set(led_cdev, LED_OFF);
 	read_unlock(&tpt_trig->trig.leddev_list_lock);
 }
+
+void ieee80211_mod_tpt_led_trig(struct ieee80211_local *local,
+				unsigned int types_on, unsigned int types_off)
+{
+	struct tpt_led_trigger *tpt_trig = local->tpt_led_trigger;
+	bool allowed;
+
+	WARN_ON(types_on & types_off);
+
+	if (!tpt_trig)
+		return;
+
+	tpt_trig->active &= ~types_off;
+	tpt_trig->active |= types_on;
+
+	/*
+	 * Regardless of wanted state, we shouldn't blink when
+	 * the radio is disabled -- this can happen due to some
+	 * code ordering issues with __ieee80211_recalc_idle()
+	 * being called before the radio is started.
+	 */
+	allowed = tpt_trig->active & IEEE80211_TPT_LEDTRIG_FL_RADIO;
+
+	if (!allowed || !(tpt_trig->active & tpt_trig->want))
+		ieee80211_stop_tpt_led_trig(local);
+	else
+		ieee80211_start_tpt_led_trig(local);
+}
--- wireless-testing.orig/net/mac80211/led.h	2010-11-30 08:56:36.000000000 +0100
+++ wireless-testing/net/mac80211/led.h	2010-11-30 08:56:54.000000000 +0100
@@ -21,8 +21,8 @@ void ieee80211_led_radio(struct ieee8021
 void ieee80211_led_names(struct ieee80211_local *local);
 void ieee80211_led_init(struct ieee80211_local *local);
 void ieee80211_led_exit(struct ieee80211_local *local);
-void ieee80211_start_tpt_led_trig(struct ieee80211_local *local);
-void ieee80211_stop_tpt_led_trig(struct ieee80211_local *local);
+void ieee80211_mod_tpt_led_trig(struct ieee80211_local *local,
+				unsigned int types_on, unsigned int types_off);
 #else
 static inline void ieee80211_led_rx(struct ieee80211_local *local)
 {
@@ -47,10 +47,9 @@ static inline void ieee80211_led_init(st
 static inline void ieee80211_led_exit(struct ieee80211_local *local)
 {
 }
-static inline void ieee80211_start_tpt_led_trig(struct ieee80211_local *local)
-{
-}
-static inline void ieee80211_stop_tpt_led_trig(struct ieee80211_local *local)
+static inline void ieee80211_mod_tpt_led_trig(struct ieee80211_local *local,
+					      unsigned int types_on,
+					      unsigned int types_off)
 {
 }
 #endif
--- wireless-testing.orig/net/mac80211/iface.c	2010-11-30 08:56:36.000000000 +0100
+++ wireless-testing/net/mac80211/iface.c	2010-11-30 08:56:54.000000000 +0100
@@ -225,7 +225,8 @@ static int ieee80211_do_open(struct net_
 		/* we're brought up, everything changes */
 		hw_reconf_flags = ~0;
 		ieee80211_led_radio(local, true);
-		ieee80211_start_tpt_led_trig(local);
+		ieee80211_mod_tpt_led_trig(local,
+					   IEEE80211_TPT_LEDTRIG_FL_RADIO, 0);
 	}
 
 	/*
@@ -1293,6 +1294,7 @@ u32 __ieee80211_recalc_idle(struct ieee8
 	int count = 0;
 	bool working = false, scanning = false;
 	struct ieee80211_work *wk;
+	unsigned int led_trig_start = 0, led_trig_stop = 0;
 
 #ifdef CONFIG_PROVE_LOCKING
 	WARN_ON(debug_locks && !lockdep_rtnl_is_held() &&
@@ -1342,6 +1344,18 @@ u32 __ieee80211_recalc_idle(struct ieee8
 		ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_IDLE);
 	}
 
+	if (working || scanning)
+		led_trig_start |= IEEE80211_TPT_LEDTRIG_FL_WORK;
+	else
+		led_trig_stop |= IEEE80211_TPT_LEDTRIG_FL_WORK;
+
+	if (count)
+		led_trig_start |= IEEE80211_TPT_LEDTRIG_FL_CONNECTED;
+	else
+		led_trig_stop |= IEEE80211_TPT_LEDTRIG_FL_CONNECTED;
+
+	ieee80211_mod_tpt_led_trig(local, led_trig_start, led_trig_stop);
+
 	if (working)
 		return ieee80211_idle_off(local, "working");
 	if (scanning)
--- wireless-testing.orig/net/mac80211/util.c	2010-11-30 08:56:36.000000000 +0100
+++ wireless-testing/net/mac80211/util.c	2010-11-30 08:56:54.000000000 +0100
@@ -1116,7 +1116,7 @@ u32 ieee80211_sta_get_rates(struct ieee8
 void ieee80211_stop_device(struct ieee80211_local *local)
 {
 	ieee80211_led_radio(local, false);
-	ieee80211_stop_tpt_led_trig(local);
+	ieee80211_mod_tpt_led_trig(local, 0, IEEE80211_TPT_LEDTRIG_FL_RADIO);
 
 	cancel_work_sync(&local->reconfig_filter);
 
@@ -1151,7 +1151,8 @@ int ieee80211_reconfig(struct ieee80211_
 		}
 
 		ieee80211_led_radio(local, true);
-		ieee80211_start_tpt_led_trig(local);
+		ieee80211_mod_tpt_led_trig(local,
+					   IEEE80211_TPT_LEDTRIG_FL_RADIO, 0);
 	}
 
 	/* add interfaces */


