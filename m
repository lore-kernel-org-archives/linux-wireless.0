Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:55513 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282AbZEWJSr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 May 2009 05:18:47 -0400
Subject: [PATCH v2] mac80211: deprecate conf.beacon_int properly
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Ivo van Doorn <ivdoorn@gmail.com>,
	Bob Copeland <bcopeland@gmail.com>
In-Reply-To: <1243070012.4606.58.camel@johannes.local>
References: <1243070012.4606.58.camel@johannes.local>
Content-Type: text/plain
Date: Sat, 23 May 2009 11:18:45 +0200
Message-Id: <1243070325.4606.59.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ivo has updated the driver to no longer use the change flag,
so we can remove that, but rt2x00 and ath5k still use the
actual value so let's mark it as deprecated too.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/net/mac80211.h |   14 ++------------
 net/mac80211/main.c    |   12 ++----------
 2 files changed, 4 insertions(+), 22 deletions(-)

--- wireless-testing.orig/include/net/mac80211.h	2009-05-23 11:00:21.000000000 +0200
+++ wireless-testing/include/net/mac80211.h	2009-05-23 11:16:18.000000000 +0200
@@ -530,7 +530,6 @@ enum ieee80211_conf_flags {
  * enum ieee80211_conf_changed - denotes which configuration changed
  *
  * @IEEE80211_CONF_CHANGE_RADIO_ENABLED: the value of radio_enabled changed
- * @_IEEE80211_CONF_CHANGE_BEACON_INTERVAL: DEPRECATED
  * @IEEE80211_CONF_CHANGE_LISTEN_INTERVAL: the listen interval changed
  * @IEEE80211_CONF_CHANGE_RADIOTAP: the radiotap flag changed
  * @IEEE80211_CONF_CHANGE_PS: the PS flag or dynamic PS timeout changed
@@ -541,7 +540,6 @@ enum ieee80211_conf_flags {
  */
 enum ieee80211_conf_changed {
 	IEEE80211_CONF_CHANGE_RADIO_ENABLED	= BIT(0),
-	_IEEE80211_CONF_CHANGE_BEACON_INTERVAL	= BIT(1),
 	IEEE80211_CONF_CHANGE_LISTEN_INTERVAL	= BIT(2),
 	IEEE80211_CONF_CHANGE_RADIOTAP		= BIT(3),
 	IEEE80211_CONF_CHANGE_PS		= BIT(4),
@@ -551,14 +549,6 @@ enum ieee80211_conf_changed {
 	IEEE80211_CONF_CHANGE_IDLE		= BIT(8),
 };
 
-static inline __deprecated enum ieee80211_conf_changed
-__IEEE80211_CONF_CHANGE_BEACON_INTERVAL(void)
-{
-	return _IEEE80211_CONF_CHANGE_BEACON_INTERVAL;
-}
-#define IEEE80211_CONF_CHANGE_BEACON_INTERVAL \
-	__IEEE80211_CONF_CHANGE_BEACON_INTERVAL()
-
 /**
  * struct ieee80211_conf - configuration of the device
  *
@@ -567,7 +557,7 @@ __IEEE80211_CONF_CHANGE_BEACON_INTERVAL(
  * @flags: configuration flags defined above
  *
  * @radio_enabled: when zero, driver is required to switch off the radio.
- * @beacon_int: beacon interval (TODO make interface config)
+ * @beacon_int: DEPRECATED, DO NOT USE
  *
  * @listen_interval: listen interval in units of beacon interval
  * @max_sleep_period: the maximum number of beacon intervals to sleep for
@@ -592,7 +582,7 @@ __IEEE80211_CONF_CHANGE_BEACON_INTERVAL(
  *    number of transmissions not the number of retries
  */
 struct ieee80211_conf {
-	int beacon_int;
+	int __deprecated beacon_int;
 	u32 flags;
 	int power_level, dynamic_ps_timeout;
 	int max_sleep_period;
--- wireless-testing.orig/net/mac80211/main.c	2009-05-23 11:06:11.000000000 +0200
+++ wireless-testing/net/mac80211/main.c	2009-05-23 11:16:26.000000000 +0200
@@ -289,16 +289,8 @@ void ieee80211_bss_info_change_notify(st
 	drv_bss_info_changed(local, &sdata->vif,
 			     &sdata->vif.bss_conf, changed);
 
-	/*
-	 * DEPRECATED
-	 *
-	 * ~changed is just there to not do this at resume time
-	 */
-	if (changed & BSS_CHANGED_BEACON_INT && ~changed) {
-		local->hw.conf.beacon_int = sdata->vif.bss_conf.beacon_int;
-		ieee80211_hw_config(local,
-				    _IEEE80211_CONF_CHANGE_BEACON_INTERVAL);
-	}
+	/* DEPRECATED */
+	local->hw.conf.beacon_int = sdata->vif.bss_conf.beacon_int;
 }
 
 u32 ieee80211_reset_erp_info(struct ieee80211_sub_if_data *sdata)


