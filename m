Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35715 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752540AbZAGJNL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Jan 2009 04:13:11 -0500
Subject: [PATCH] mac80211: clean up channel type config
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Sujith Manoharan <Sujith.Manoharan@atheros.com>
Content-Type: text/plain
Date: Wed, 07 Jan 2009 10:13:27 +0100
Message-Id: <1231319607.3545.10.camel@johannes> (sfid-20090107_101328_498723_DBEA668C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The channel_type really doesn't need to be the only member in
a new structure, so remove the struct. Additionally, remove
the _CONF_CHANGE_HT flag and use _CONF_CHANGE_CHANNEL when the
channel type changes, since that's enough of a change to require
reprogramming the hardware anyway.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/net/wireless/ath9k/main.c |    5 ++---
 include/net/mac80211.h            |   20 +++++++-------------
 net/mac80211/ht.c                 |    8 +++++---
 net/mac80211/main.c               |    4 ++--
 net/mac80211/mlme.c               |    2 +-
 5 files changed, 17 insertions(+), 22 deletions(-)

--- wireless-testing.orig/include/net/mac80211.h	2009-01-07 10:06:03.000000000 +0100
+++ wireless-testing/include/net/mac80211.h	2009-01-07 10:12:22.000000000 +0100
@@ -508,10 +508,6 @@ static inline int __deprecated __IEEE802
 }
 #define IEEE80211_CONF_SHORT_SLOT_TIME (__IEEE80211_CONF_SHORT_SLOT_TIME())
 
-struct ieee80211_ht_conf {
-	enum nl80211_channel_type channel_type;
-};
-
 /**
  * enum ieee80211_conf_changed - denotes which configuration changed
  *
@@ -522,9 +518,8 @@ struct ieee80211_ht_conf {
  * @IEEE80211_CONF_CHANGE_PS: the PS flag changed
  * @IEEE80211_CONF_CHANGE_DYNPS_TIMEOUT: the dynamic PS timeout changed
  * @IEEE80211_CONF_CHANGE_POWER: the TX power changed
- * @IEEE80211_CONF_CHANGE_CHANNEL: the channel changed
+ * @IEEE80211_CONF_CHANGE_CHANNEL: the channel/channel_type changed
  * @IEEE80211_CONF_CHANGE_RETRY_LIMITS: retry limits changed
- * @IEEE80211_CONF_CHANGE_HT: HT configuration changed
  */
 enum ieee80211_conf_changed {
 	IEEE80211_CONF_CHANGE_RADIO_ENABLED	= BIT(0),
@@ -536,7 +531,6 @@ enum ieee80211_conf_changed {
 	IEEE80211_CONF_CHANGE_POWER		= BIT(6),
 	IEEE80211_CONF_CHANGE_CHANNEL		= BIT(7),
 	IEEE80211_CONF_CHANGE_RETRY_LIMITS	= BIT(8),
-	IEEE80211_CONF_CHANGE_HT		= BIT(9),
 };
 
 /**
@@ -551,7 +545,7 @@ enum ieee80211_conf_changed {
  * @power_level: requested transmit power (in dBm)
  * @dynamic_ps_timeout: dynamic powersave timeout (in ms)
  * @channel: the channel to tune to
- * @ht: the HT configuration for the device
+ * @channel_type: the channel (HT) type
  * @long_frame_max_tx_count: Maximum number of transmissions for a "long" frame
  *    (a frame not RTS protected), called "dot11LongRetryLimit" in 802.11,
  *    but actually means the number of transmissions not the number of retries
@@ -570,7 +564,7 @@ struct ieee80211_conf {
 	u8 long_frame_max_tx_count, short_frame_max_tx_count;
 
 	struct ieee80211_channel *channel;
-	struct ieee80211_ht_conf ht;
+	enum nl80211_channel_type channel_type;
 };
 
 /**
@@ -2001,19 +1995,19 @@ void ieee80211_rate_control_unregister(s
 static inline bool
 conf_is_ht20(struct ieee80211_conf *conf)
 {
-	return conf->ht.channel_type == NL80211_CHAN_HT20;
+	return conf->channel_type == NL80211_CHAN_HT20;
 }
 
 static inline bool
 conf_is_ht40_minus(struct ieee80211_conf *conf)
 {
-	return conf->ht.channel_type == NL80211_CHAN_HT40MINUS;
+	return conf->channel_type == NL80211_CHAN_HT40MINUS;
 }
 
 static inline bool
 conf_is_ht40_plus(struct ieee80211_conf *conf)
 {
-	return conf->ht.channel_type == NL80211_CHAN_HT40PLUS;
+	return conf->channel_type == NL80211_CHAN_HT40PLUS;
 }
 
 static inline bool
@@ -2025,7 +2019,7 @@ conf_is_ht40(struct ieee80211_conf *conf
 static inline bool
 conf_is_ht(struct ieee80211_conf *conf)
 {
-	return conf->ht.channel_type != NL80211_CHAN_NO_HT;
+	return conf->channel_type != NL80211_CHAN_NO_HT;
 }
 
 #endif /* MAC80211_H */
--- wireless-testing.orig/net/mac80211/ht.c	2009-01-07 10:05:56.000000000 +0100
+++ wireless-testing/net/mac80211/ht.c	2009-01-07 10:07:29.000000000 +0100
@@ -131,12 +131,14 @@ u32 ieee80211_enable_ht(struct ieee80211
 	}
 
 	ht_changed = conf_is_ht(&local->hw.conf) != enable_ht ||
-		     channel_type != local->hw.conf.ht.channel_type;
+		     channel_type != local->hw.conf.channel_type;
 
 	local->oper_channel_type = channel_type;
 
-	if (ht_changed)
-		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_HT);
+	if (ht_changed) {
+                /* channel_type change automatically detected */
+		ieee80211_hw_config(local, 0);
+        }
 
 	/* disable HT */
 	if (!enable_ht)
--- wireless-testing.orig/net/mac80211/main.c	2009-01-07 10:06:40.000000000 +0100
+++ wireless-testing/net/mac80211/main.c	2009-01-07 10:06:49.000000000 +0100
@@ -208,9 +208,9 @@ int ieee80211_hw_config(struct ieee80211
 	}
 
 	if (chan != local->hw.conf.channel ||
-	    channel_type != local->hw.conf.ht.channel_type) {
+	    channel_type != local->hw.conf.channel_type) {
 		local->hw.conf.channel = chan;
-		local->hw.conf.ht.channel_type = channel_type;
+		local->hw.conf.channel_type = channel_type;
 		changed |= IEEE80211_CONF_CHANGE_CHANNEL;
 	}
 
--- wireless-testing.orig/net/mac80211/mlme.c	2009-01-07 10:07:36.000000000 +0100
+++ wireless-testing/net/mac80211/mlme.c	2009-01-07 10:08:05.000000000 +0100
@@ -908,8 +908,8 @@ static void ieee80211_set_disassoc(struc
 
 	rcu_read_unlock();
 
+	/* channel(_type) changes are handled by ieee80211_hw_config */
 	local->oper_channel_type = NL80211_CHAN_NO_HT;
-	config_changed |= IEEE80211_CONF_CHANGE_HT;
 
 	del_timer_sync(&local->dynamic_ps_timer);
 	cancel_work_sync(&local->dynamic_ps_enable_work);
--- wireless-testing.orig/drivers/net/wireless/ath9k/main.c	2009-01-07 10:08:52.000000000 +0100
+++ wireless-testing/drivers/net/wireless/ath9k/main.c	2009-01-07 10:09:11.000000000 +0100
@@ -2114,8 +2114,7 @@ static int ath9k_config(struct ieee80211
 	struct ieee80211_conf *conf = &hw->conf;
 
 	mutex_lock(&sc->mutex);
-	if (changed & (IEEE80211_CONF_CHANGE_CHANNEL |
-		       IEEE80211_CONF_CHANGE_HT)) {
+	if (changed & IEEE80211_CONF_CHANGE_CHANNEL) {
 		struct ieee80211_channel *curchan = hw->conf.channel;
 		int pos;
 
@@ -2141,7 +2140,7 @@ static int ath9k_config(struct ieee80211
 
 			sc->sc_ah->ah_channels[pos].chanmode =
 				ath_get_extchanmode(sc, curchan,
-						    conf->ht.channel_type);
+						    conf->channel_type);
 		}
 
 		if (ath_set_channel(sc, &sc->sc_ah->ah_channels[pos]) < 0) {


