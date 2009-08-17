Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35041 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754049AbZHQOSI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2009 10:18:08 -0400
Subject: [PATCH] mac80211: remove deprecated API
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 17 Aug 2009 16:18:07 +0200
Message-Id: <1250518687.15103.9.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

All but two drivers have now stopped using the two
deprecated members radio_enabled and beacon_int,
so it's about time to remove them for good.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/net/wireless/at76c50x-usb.c |    5 ++---
 drivers/net/wireless/mwl8k.c        |    7 -------
 include/net/mac80211.h              |   15 ---------------
 net/mac80211/main.c                 |    4 ----
 4 files changed, 2 insertions(+), 29 deletions(-)

--- wireless-testing.orig/drivers/net/wireless/at76c50x-usb.c	2009-08-17 15:39:28.000000000 +0200
+++ wireless-testing/drivers/net/wireless/at76c50x-usb.c	2009-08-17 15:47:48.000000000 +0200
@@ -1950,9 +1950,8 @@ static int at76_config(struct ieee80211_
 {
 	struct at76_priv *priv = hw->priv;
 
-	at76_dbg(DBG_MAC80211, "%s(): channel %d radio %d",
-		 __func__, hw->conf.channel->hw_value,
-		 hw->conf.radio_enabled);
+	at76_dbg(DBG_MAC80211, "%s(): channel %d",
+		 __func__, hw->conf.channel->hw_value);
 	at76_dbg_dump(DBG_MAC80211, priv->bssid, ETH_ALEN, "bssid:");
 
 	mutex_lock(&priv->mtx);
--- wireless-testing.orig/drivers/net/wireless/mwl8k.c	2009-08-17 15:39:28.000000000 +0200
+++ wireless-testing/drivers/net/wireless/mwl8k.c	2009-08-17 15:47:48.000000000 +0200
@@ -3031,13 +3031,6 @@ static int mwl8k_config_wt(struct work_s
 	struct mwl8k_priv *priv = hw->priv;
 	int rc = 0;
 
-	if (!conf->radio_enabled) {
-		mwl8k_cmd_802_11_radio_control(hw, MWL8K_RADIO_DISABLE);
-		priv->current_channel = NULL;
-		rc = 0;
-		goto mwl8k_config_exit;
-	}
-
 	if (mwl8k_cmd_802_11_radio_control(hw, MWL8K_RADIO_ENABLE)) {
 		rc = -EINVAL;
 		goto mwl8k_config_exit;
--- wireless-testing.orig/include/net/mac80211.h	2009-08-17 15:39:28.000000000 +0200
+++ wireless-testing/include/net/mac80211.h	2009-08-17 15:47:48.000000000 +0200
@@ -583,7 +583,6 @@ enum ieee80211_conf_flags {
 /**
  * enum ieee80211_conf_changed - denotes which configuration changed
  *
- * @_IEEE80211_CONF_CHANGE_RADIO_ENABLED: DEPRECATED
  * @IEEE80211_CONF_CHANGE_LISTEN_INTERVAL: the listen interval changed
  * @IEEE80211_CONF_CHANGE_RADIOTAP: the radiotap flag changed
  * @IEEE80211_CONF_CHANGE_PS: the PS flag or dynamic PS timeout changed
@@ -593,7 +592,6 @@ enum ieee80211_conf_flags {
  * @IEEE80211_CONF_CHANGE_IDLE: Idle flag changed
  */
 enum ieee80211_conf_changed {
-	_IEEE80211_CONF_CHANGE_RADIO_ENABLED	= BIT(0),
 	IEEE80211_CONF_CHANGE_LISTEN_INTERVAL	= BIT(2),
 	IEEE80211_CONF_CHANGE_RADIOTAP		= BIT(3),
 	IEEE80211_CONF_CHANGE_PS		= BIT(4),
@@ -603,14 +601,6 @@ enum ieee80211_conf_changed {
 	IEEE80211_CONF_CHANGE_IDLE		= BIT(8),
 };
 
-static inline __deprecated enum ieee80211_conf_changed
-__IEEE80211_CONF_CHANGE_RADIO_ENABLED(void)
-{
-	return _IEEE80211_CONF_CHANGE_RADIO_ENABLED;
-}
-#define IEEE80211_CONF_CHANGE_RADIO_ENABLED \
-	__IEEE80211_CONF_CHANGE_RADIO_ENABLED()
-
 /**
  * struct ieee80211_conf - configuration of the device
  *
@@ -618,9 +608,6 @@ __IEEE80211_CONF_CHANGE_RADIO_ENABLED(vo
  *
  * @flags: configuration flags defined above
  *
- * @radio_enabled: when zero, driver is required to switch off the radio.
- * @beacon_int: DEPRECATED, DO NOT USE
- *
  * @listen_interval: listen interval in units of beacon interval
  * @max_sleep_period: the maximum number of beacon intervals to sleep for
  *	before checking the beacon for a TIM bit (managed mode only); this
@@ -644,13 +631,11 @@ __IEEE80211_CONF_CHANGE_RADIO_ENABLED(vo
  *    number of transmissions not the number of retries
  */
 struct ieee80211_conf {
-	int __deprecated beacon_int;
 	u32 flags;
 	int power_level, dynamic_ps_timeout;
 	int max_sleep_period;
 
 	u16 listen_interval;
-	bool __deprecated radio_enabled;
 
 	u8 long_frame_max_tx_count, short_frame_max_tx_count;
 
--- wireless-testing.orig/net/mac80211/main.c	2009-08-17 15:39:28.000000000 +0200
+++ wireless-testing/net/mac80211/main.c	2009-08-17 15:47:48.000000000 +0200
@@ -241,9 +241,6 @@ void ieee80211_bss_info_change_notify(st
 
 	drv_bss_info_changed(local, &sdata->vif,
 			     &sdata->vif.bss_conf, changed);
-
-	/* DEPRECATED */
-	local->hw.conf.beacon_int = sdata->vif.bss_conf.beacon_int;
 }
 
 u32 ieee80211_reset_erp_info(struct ieee80211_sub_if_data *sdata)
@@ -687,7 +684,6 @@ struct ieee80211_hw *ieee80211_alloc_hw(
 	local->hw.max_rates = 1;
 	local->hw.conf.long_frame_max_tx_count = wiphy->retry_long;
 	local->hw.conf.short_frame_max_tx_count = wiphy->retry_short;
-	local->hw.conf.radio_enabled = true;
 	local->user_power_level = -1;
 
 	INIT_LIST_HEAD(&local->interfaces);


