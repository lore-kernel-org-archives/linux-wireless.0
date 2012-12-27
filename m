Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:34368 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492Ab2L0Vob (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Dec 2012 16:44:31 -0500
Received: by mail-pa0-f53.google.com with SMTP id hz1so5662804pad.26
        for <linux-wireless@vger.kernel.org>; Thu, 27 Dec 2012 13:44:31 -0800 (PST)
From: Thomas Pedersen <thomas@cozybit.com>
To: linville@tuxdriver.org
Cc: j@w1.fi, linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	Thomas Pedersen <thomas@cozybit.com>
Subject: [PATCH 2/4] mac80211_hwsim: hrtimer beacon
Date: Thu, 27 Dec 2012 13:43:54 -0800
Message-Id: <1356644636-5309-2-git-send-email-thomas@cozybit.com> (sfid-20121227_224434_395344_20A3F86C)
In-Reply-To: <1356644636-5309-1-git-send-email-thomas@cozybit.com>
References: <1356644636-5309-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For testing various timing-sensitive protocols (power
save, MBCA, etc.), a beacon accuracy of jiffies is not
sufficient. A tasklet_hrtimer is used for the beacon since
it runs the callback in soft-IRQ context with hrtimer
resolution.

Also handle BSS_CHANGED_BEACON_ENABLED for hwsim.

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 drivers/net/wireless/mac80211_hwsim.c |   69 ++++++++++++++++++++++-----------
 1 file changed, 47 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 59761fb..f353d5e 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -333,11 +333,11 @@ struct mac80211_hwsim_data {
 	int scan_chan_idx;
 
 	struct ieee80211_channel *channel;
-	unsigned long beacon_int; /* in jiffies unit */
+	u64 beacon_int	/* beacon interval in us */;
 	unsigned int rx_filter;
 	bool started, idle, scanning;
 	struct mutex mutex;
-	struct timer_list beacon_timer;
+	struct tasklet_hrtimer beacon_timer;
 	enum ps_mode {
 		PS_DISABLED, PS_ENABLED, PS_AUTO_POLL, PS_MANUAL_POLL
 	} ps;
@@ -897,7 +897,7 @@ static void mac80211_hwsim_stop(struct ieee80211_hw *hw)
 {
 	struct mac80211_hwsim_data *data = hw->priv;
 	data->started = false;
-	del_timer(&data->beacon_timer);
+	tasklet_hrtimer_cancel(&data->beacon_timer);
 	wiphy_debug(hw->wiphy, "%s\n", __func__);
 }
 
@@ -981,21 +981,32 @@ static void mac80211_hwsim_beacon_tx(void *arg, u8 *mac,
 				rcu_dereference(vif->chanctx_conf)->def.chan);
 }
 
-
-static void mac80211_hwsim_beacon(unsigned long arg)
+static enum hrtimer_restart
+mac80211_hwsim_beacon(struct hrtimer *timer)
 {
-	struct ieee80211_hw *hw = (struct ieee80211_hw *) arg;
-	struct mac80211_hwsim_data *data = hw->priv;
+	struct tasklet_hrtimer *ttimer = container_of(timer,
+						      struct tasklet_hrtimer,
+						      timer);
+	struct mac80211_hwsim_data *data = container_of(ttimer,
+						struct mac80211_hwsim_data,
+						beacon_timer);
+	struct ieee80211_hw *hw = data->hw;
+	u64 bcn_int = data->beacon_int;
+	ktime_t next_bcn;
 
 	if (!data->started)
-		return;
+		goto out;
 
 	ieee80211_iterate_active_interfaces_atomic(
 		hw, IEEE80211_IFACE_ITER_NORMAL,
-		mac80211_hwsim_beacon_tx, hw);
+		mac80211_hwsim_beacon_tx, data);
+
 
-	data->beacon_timer.expires = jiffies + data->beacon_int;
-	add_timer(&data->beacon_timer);
+	next_bcn = ktime_add(hrtimer_get_expires(timer),
+			     ns_to_ktime(bcn_int * 1000));
+	tasklet_hrtimer_start(ttimer, next_bcn, HRTIMER_MODE_ABS);
+out:
+	return HRTIMER_NORESTART;
 }
 
 static const char *hwsim_chantypes[] = {
@@ -1033,9 +1044,12 @@ static int mac80211_hwsim_config(struct ieee80211_hw *hw, u32 changed)
 
 	data->power_level = conf->power_level;
 	if (!data->started || !data->beacon_int)
-		del_timer(&data->beacon_timer);
-	else
-		mod_timer(&data->beacon_timer, jiffies + data->beacon_int);
+		tasklet_hrtimer_cancel(&data->beacon_timer);
+	else if (!hrtimer_is_queued(&data->beacon_timer.timer)) {
+		tasklet_hrtimer_start(&data->beacon_timer,
+				      ns_to_ktime(data->beacon_int * 1000),
+				      HRTIMER_MODE_REL);
+	}
 
 	return 0;
 }
@@ -1085,12 +1099,22 @@ static void mac80211_hwsim_bss_info_changed(struct ieee80211_hw *hw,
 
 	if (changed & BSS_CHANGED_BEACON_INT) {
 		wiphy_debug(hw->wiphy, "  BCNINT: %d\n", info->beacon_int);
-		data->beacon_int = 1024 * info->beacon_int / 1000 * HZ / 1000;
-		if (WARN_ON(!data->beacon_int))
-			data->beacon_int = 1;
-		if (data->started)
-			mod_timer(&data->beacon_timer,
-				  jiffies + data->beacon_int);
+		data->beacon_int = info->beacon_int * 1024;
+	}
+
+	if (changed & BSS_CHANGED_BEACON_ENABLED) {
+		wiphy_debug(hw->wiphy, "  BCN EN: %d\n", info->enable_beacon);
+		if (data->started &&
+		    !hrtimer_is_queued(&data->beacon_timer.timer) &&
+		    info->enable_beacon) {
+			if (WARN_ON(!data->beacon_int))
+				data->beacon_int = 1000 * 1024;
+			tasklet_hrtimer_start(&data->beacon_timer,
+					      ns_to_ktime(data->beacon_int *
+							  1000),
+					      HRTIMER_MODE_REL);
+		} else if (!info->enable_beacon)
+			tasklet_hrtimer_cancel(&data->beacon_timer);
 	}
 
 	if (changed & BSS_CHANGED_ERP_CTS_PROT) {
@@ -2371,8 +2395,9 @@ static int __init init_mac80211_hwsim(void)
 							data->debugfs, data,
 							&hwsim_fops_group);
 
-		setup_timer(&data->beacon_timer, mac80211_hwsim_beacon,
-			    (unsigned long) hw);
+		tasklet_hrtimer_init(&data->beacon_timer,
+				     mac80211_hwsim_beacon,
+				     CLOCK_REALTIME, HRTIMER_MODE_ABS);
 
 		list_add_tail(&data->list, &hwsim_radios);
 	}
-- 
1.7.10.4

