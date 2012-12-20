Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-da0-f52.google.com ([209.85.210.52]:39983 "EHLO
	mail-da0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041Ab2LTS6U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Dec 2012 13:58:20 -0500
Received: by mail-da0-f52.google.com with SMTP id f10so1671841dak.39
        for <linux-wireless@vger.kernel.org>; Thu, 20 Dec 2012 10:58:20 -0800 (PST)
From: Thomas Pedersen <thomas@cozybit.com>
To: linville@tuxdriver.org
Cc: linux-wireless@vger.kernel.org, jlopex@gmail.com, j@wl.fi,
	Thomas Pedersen <thomas@cozybit.com>
Subject: [PATCH v2 1/3] mac80211_hwsim: use hrtimer for beacon timers
Date: Thu, 20 Dec 2012 10:57:49 -0800
Message-Id: <1356029871-17794-1-git-send-email-thomas@cozybit.com> (sfid-20121220_195824_731125_DAECB6B9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For testing various timing-sensitive protocols (power
save, etc.), a beacon accuracy of jiffies is not
sufficient.

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---

v2:
	Use tasklet_kill() on interface stop.

 drivers/net/wireless/mac80211_hwsim.c |   63 ++++++++++++++++++++-------------
 1 file changed, 39 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index ff90855..84dbfe8 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -333,11 +333,11 @@ struct mac80211_hwsim_data {
 	int scan_chan_idx;
 
 	struct ieee80211_channel *channel;
-	unsigned long beacon_int; /* in jiffies unit */
+	ktime_t beacon_int;
 	unsigned int rx_filter;
 	bool started, idle, scanning;
 	struct mutex mutex;
-	struct timer_list beacon_timer;
+	struct hrtimer beacon_timer;
 	enum ps_mode {
 		PS_DISABLED, PS_ENABLED, PS_AUTO_POLL, PS_MANUAL_POLL
 	} ps;
@@ -358,6 +358,7 @@ struct mac80211_hwsim_data {
 
 	/* difference between this hw's clock and the real clock, in usecs */
 	u64 tsf_offset;
+	struct tasklet_struct bcn_tasklet;
 };
 
 
@@ -896,7 +897,8 @@ static void mac80211_hwsim_stop(struct ieee80211_hw *hw)
 {
 	struct mac80211_hwsim_data *data = hw->priv;
 	data->started = false;
-	del_timer(&data->beacon_timer);
+	hrtimer_cancel(&data->beacon_timer);
+	tasklet_kill(&data->bcn_tasklet);
 	wiphy_debug(hw->wiphy, "%s\n", __func__);
 }
 
@@ -980,21 +982,30 @@ static void mac80211_hwsim_beacon_tx(void *arg, u8 *mac,
 				rcu_dereference(vif->chanctx_conf)->def.chan);
 }
 
-
-static void mac80211_hwsim_beacon(unsigned long arg)
+static void mac80211_hwsim_bcn_tasklet(unsigned long d)
 {
-	struct ieee80211_hw *hw = (struct ieee80211_hw *) arg;
-	struct mac80211_hwsim_data *data = hw->priv;
-
-	if (!data->started)
-		return;
+	struct mac80211_hwsim_data *data = (struct mac80211_hwsim_data *) d;
+	struct ieee80211_hw *hw = data->hw;
 
 	ieee80211_iterate_active_interfaces_atomic(
 		hw, IEEE80211_IFACE_ITER_NORMAL,
 		mac80211_hwsim_beacon_tx, hw);
+}
 
-	data->beacon_timer.expires = jiffies + data->beacon_int;
-	add_timer(&data->beacon_timer);
+static enum hrtimer_restart
+mac80211_hwsim_beacon(struct hrtimer *timer)
+{
+	struct mac80211_hwsim_data *data =
+		container_of(timer, struct mac80211_hwsim_data, beacon_timer);
+
+	if (!data->started)
+		return HRTIMER_NORESTART;
+
+	/* must defer here since hrtimers are run in hard-IRQ */
+	tasklet_schedule(&data->bcn_tasklet);
+
+	hrtimer_forward(timer, hrtimer_get_expires(timer), data->beacon_int);
+	return HRTIMER_RESTART;
 }
 
 static const char *hwsim_chantypes[] = {
@@ -1031,10 +1042,11 @@ static int mac80211_hwsim_config(struct ieee80211_hw *hw, u32 changed)
 	WARN_ON(data->channel && channels > 1);
 
 	data->power_level = conf->power_level;
-	if (!data->started || !data->beacon_int)
-		del_timer(&data->beacon_timer);
-	else
-		mod_timer(&data->beacon_timer, jiffies + data->beacon_int);
+	if (!data->started || !ktime_to_ns(data->beacon_int))
+		hrtimer_cancel(&data->beacon_timer);
+	else if (!hrtimer_is_queued(&data->beacon_timer))
+		hrtimer_start(&data->beacon_timer, data->beacon_int,
+			      HRTIMER_MODE_REL);
 
 	return 0;
 }
@@ -1084,12 +1096,12 @@ static void mac80211_hwsim_bss_info_changed(struct ieee80211_hw *hw,
 
 	if (changed & BSS_CHANGED_BEACON_INT) {
 		wiphy_debug(hw->wiphy, "  BCNINT: %d\n", info->beacon_int);
-		data->beacon_int = 1024 * info->beacon_int / 1000 * HZ / 1000;
-		if (WARN_ON(!data->beacon_int))
-			data->beacon_int = 1;
-		if (data->started)
-			mod_timer(&data->beacon_timer,
-				  jiffies + data->beacon_int);
+		data->beacon_int = ns_to_ktime(info->beacon_int * 1024 * 1000);
+		if (WARN_ON(!ktime_to_ns(data->beacon_int)))
+			data->beacon_int = ns_to_ktime(1000 * 1000);
+		if (data->started && !hrtimer_is_queued(&data->beacon_timer))
+			hrtimer_start(&data->beacon_timer,
+				      data->beacon_int, HRTIMER_MODE_REL);
 	}
 
 	if (changed & BSS_CHANGED_ERP_CTS_PROT) {
@@ -2370,8 +2382,11 @@ static int __init init_mac80211_hwsim(void)
 							data->debugfs, data,
 							&hwsim_fops_group);
 
-		setup_timer(&data->beacon_timer, mac80211_hwsim_beacon,
-			    (unsigned long) hw);
+		tasklet_init(&data->bcn_tasklet,
+			     mac80211_hwsim_bcn_tasklet, (unsigned long) data);
+		hrtimer_init(&data->beacon_timer,
+			     CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+		data->beacon_timer.function = mac80211_hwsim_beacon;
 
 		list_add_tail(&data->list, &hwsim_radios);
 	}
-- 
1.7.10.4

