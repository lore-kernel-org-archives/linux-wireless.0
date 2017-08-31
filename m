Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:60734 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751835AbdHaMYT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 Aug 2017 08:24:19 -0400
Message-Id: <20170831105827.172599262@linutronix.de> (sfid-20170831_142511_540124_2433AF91)
Date: Thu, 31 Aug 2017 12:23:43 -0000
From: Anna-Maria Gleixner <anna-maria@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Christoph Hellwig <hch@lst.org>, keescook@chromium.org,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Johannes Berg <johannes@sipsolutions.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org
Subject: [PATCH 20/25] mac80211_hwsim: Replace hrtimer tasklet with softirq
 hrtimer
References: <20170831105725.809317030@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Thomas Gleixner <tglx@linutronix.de>

Switch the timer to CLOCK_MONOTONIC_SOFT, which executed the timer
callback in softirq context and remove the hrtimer_tasklet.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Anna-Maria Gleixner <anna-maria@linutronix.de>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org

---
 drivers/net/wireless/mac80211_hwsim.c |   44 +++++++++++++++-------------------
 1 file changed, 20 insertions(+), 24 deletions(-)

--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -537,7 +537,7 @@ struct mac80211_hwsim_data {
 	unsigned int rx_filter;
 	bool started, idle, scanning;
 	struct mutex mutex;
-	struct tasklet_hrtimer beacon_timer;
+	struct hrtimer beacon_timer;
 	enum ps_mode {
 		PS_DISABLED, PS_ENABLED, PS_AUTO_POLL, PS_MANUAL_POLL
 	} ps;
@@ -1420,7 +1420,7 @@ static void mac80211_hwsim_stop(struct i
 {
 	struct mac80211_hwsim_data *data = hw->priv;
 	data->started = false;
-	tasklet_hrtimer_cancel(&data->beacon_timer);
+	hrtimer_cancel(&data->beacon_timer);
 	wiphy_debug(hw->wiphy, "%s\n", __func__);
 }
 
@@ -1543,14 +1543,12 @@ static enum hrtimer_restart
 mac80211_hwsim_beacon(struct hrtimer *timer)
 {
 	struct mac80211_hwsim_data *data =
-		container_of(timer, struct mac80211_hwsim_data,
-			     beacon_timer.timer);
+		container_of(timer, struct mac80211_hwsim_data, beacon_timer);
 	struct ieee80211_hw *hw = data->hw;
 	u64 bcn_int = data->beacon_int;
-	ktime_t next_bcn;
 
 	if (!data->started)
-		goto out;
+		return HRTIMER_NORESTART;
 
 	ieee80211_iterate_active_interfaces_atomic(
 		hw, IEEE80211_IFACE_ITER_NORMAL,
@@ -1562,11 +1560,9 @@ mac80211_hwsim_beacon(struct hrtimer *ti
 		data->bcn_delta = 0;
 	}
 
-	next_bcn = ktime_add(hrtimer_get_expires(timer),
-			     ns_to_ktime(bcn_int * 1000));
-	tasklet_hrtimer_start(&data->beacon_timer, next_bcn, HRTIMER_MODE_ABS);
-out:
-	return HRTIMER_NORESTART;
+	hrtimer_forward(&data->beacon_timer, hrtimer_get_expires(timer),
+			ns_to_ktime(bcn_int * NSEC_PER_USEC));
+	return HRTIMER_RESTART;
 }
 
 static const char * const hwsim_chanwidths[] = {
@@ -1640,15 +1636,15 @@ static int mac80211_hwsim_config(struct
 	mutex_unlock(&data->mutex);
 
 	if (!data->started || !data->beacon_int)
-		tasklet_hrtimer_cancel(&data->beacon_timer);
-	else if (!hrtimer_is_queued(&data->beacon_timer.timer)) {
+		hrtimer_cancel(&data->beacon_timer);
+	else if (!hrtimer_is_queued(&data->beacon_timer)) {
 		u64 tsf = mac80211_hwsim_get_tsf(hw, NULL);
 		u32 bcn_int = data->beacon_int;
 		u64 until_tbtt = bcn_int - do_div(tsf, bcn_int);
 
-		tasklet_hrtimer_start(&data->beacon_timer,
-				      ns_to_ktime(until_tbtt * 1000),
-				      HRTIMER_MODE_REL);
+		hrtimer_start(&data->beacon_timer,
+			      ns_to_ktime(until_tbtt * 1000),
+			      HRTIMER_MODE_REL);
 	}
 
 	return 0;
@@ -1711,7 +1707,7 @@ static void mac80211_hwsim_bss_info_chan
 			    info->enable_beacon, info->beacon_int);
 		vp->bcn_en = info->enable_beacon;
 		if (data->started &&
-		    !hrtimer_is_queued(&data->beacon_timer.timer) &&
+		    !hrtimer_is_queued(&data->beacon_timer) &&
 		    info->enable_beacon) {
 			u64 tsf, until_tbtt;
 			u32 bcn_int;
@@ -1719,9 +1715,9 @@ static void mac80211_hwsim_bss_info_chan
 			tsf = mac80211_hwsim_get_tsf(hw, vif);
 			bcn_int = data->beacon_int;
 			until_tbtt = bcn_int - do_div(tsf, bcn_int);
-			tasklet_hrtimer_start(&data->beacon_timer,
-					      ns_to_ktime(until_tbtt * 1000),
-					      HRTIMER_MODE_REL);
+			hrtimer_start(&data->beacon_timer,
+				      ns_to_ktime(until_tbtt * 1000),
+				      HRTIMER_MODE_REL);
 		} else if (!info->enable_beacon) {
 			unsigned int count = 0;
 			ieee80211_iterate_active_interfaces_atomic(
@@ -1730,7 +1726,7 @@ static void mac80211_hwsim_bss_info_chan
 			wiphy_debug(hw->wiphy, "  beaconing vifs remaining: %u",
 				    count);
 			if (count == 0) {
-				tasklet_hrtimer_cancel(&data->beacon_timer);
+				hrtimer_cancel(&data->beacon_timer);
 				data->beacon_int = 0;
 			}
 		}
@@ -2722,9 +2718,9 @@ static int mac80211_hwsim_new_radio(stru
 				    data->debugfs,
 				    data, &hwsim_simulate_radar);
 
-	tasklet_hrtimer_init(&data->beacon_timer,
-			     mac80211_hwsim_beacon,
-			     CLOCK_MONOTONIC, HRTIMER_MODE_ABS);
+	hrtimer_init(&data->beacon_timer, CLOCK_MONOTONIC_SOFT,
+		     HRTIMER_MODE_ABS);
+	data->beacon_timer.function = mac80211_hwsim_beacon;
 
 	spin_lock_bh(&hwsim_radio_lock);
 	list_add_tail(&data->list, &hwsim_radios);
