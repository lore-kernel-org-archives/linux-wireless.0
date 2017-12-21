Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:54659 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753225AbdLUKnN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Dec 2017 05:43:13 -0500
From: Anna-Maria Gleixner <anna-maria@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, keescook@chromium.org,
        Christoph Hellwig <hch@lst.de>,
        John Stultz <john.stultz@linaro.org>,
        Anna-Maria Gleixner <anna-maria@linutronix.de>,
        linux-wireless@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH v4 31/36] mac80211_hwsim: Replace hrtimer tasklet with softirq hrtimer
Date: Thu, 21 Dec 2017 11:42:00 +0100
Message-Id: <20171221104205.7269-32-anna-maria@linutronix.de> (sfid-20171221_114704_542421_13316299)
In-Reply-To: <20171221104205.7269-1-anna-maria@linutronix.de>
References: <20171221104205.7269-1-anna-maria@linutronix.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Thomas Gleixner <tglx@linutronix.de>

Switch the timer to HRTIMER_MODE_SOFT, which executed the timer
callback in softirq context and remove the hrtimer_tasklet.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Anna-Maria Gleixner <anna-maria@linutronix.de>
Reviewed-by: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Kalle Valo <kvalo@codeaurora.org>
---
 drivers/net/wireless/mac80211_hwsim.c | 44 ++++++++++++++++-------------------
 1 file changed, 20 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 10b075a46b26..d3f1861398a7 100644
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
@@ -1418,7 +1418,7 @@ static void mac80211_hwsim_stop(struct ieee80211_hw *hw)
 {
 	struct mac80211_hwsim_data *data = hw->priv;
 	data->started = false;
-	tasklet_hrtimer_cancel(&data->beacon_timer);
+	hrtimer_cancel(&data->beacon_timer);
 	wiphy_dbg(hw->wiphy, "%s\n", __func__);
 }
 
@@ -1541,14 +1541,12 @@ static enum hrtimer_restart
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
@@ -1560,11 +1558,9 @@ mac80211_hwsim_beacon(struct hrtimer *timer)
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
@@ -1638,15 +1634,15 @@ static int mac80211_hwsim_config(struct ieee80211_hw *hw, u32 changed)
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
+			      HRTIMER_MODE_REL_SOFT);
 	}
 
 	return 0;
@@ -1709,7 +1705,7 @@ static void mac80211_hwsim_bss_info_changed(struct ieee80211_hw *hw,
 			  info->enable_beacon, info->beacon_int);
 		vp->bcn_en = info->enable_beacon;
 		if (data->started &&
-		    !hrtimer_is_queued(&data->beacon_timer.timer) &&
+		    !hrtimer_is_queued(&data->beacon_timer) &&
 		    info->enable_beacon) {
 			u64 tsf, until_tbtt;
 			u32 bcn_int;
@@ -1717,9 +1713,9 @@ static void mac80211_hwsim_bss_info_changed(struct ieee80211_hw *hw,
 			tsf = mac80211_hwsim_get_tsf(hw, vif);
 			bcn_int = data->beacon_int;
 			until_tbtt = bcn_int - do_div(tsf, bcn_int);
-			tasklet_hrtimer_start(&data->beacon_timer,
-					      ns_to_ktime(until_tbtt * 1000),
-					      HRTIMER_MODE_REL);
+			hrtimer_start(&data->beacon_timer,
+				      ns_to_ktime(until_tbtt * 1000),
+				      HRTIMER_MODE_REL_SOFT);
 		} else if (!info->enable_beacon) {
 			unsigned int count = 0;
 			ieee80211_iterate_active_interfaces_atomic(
@@ -1728,7 +1724,7 @@ static void mac80211_hwsim_bss_info_changed(struct ieee80211_hw *hw,
 			wiphy_dbg(hw->wiphy, "  beaconing vifs remaining: %u",
 				  count);
 			if (count == 0) {
-				tasklet_hrtimer_cancel(&data->beacon_timer);
+				hrtimer_cancel(&data->beacon_timer);
 				data->beacon_int = 0;
 			}
 		}
@@ -2720,9 +2716,9 @@ static int mac80211_hwsim_new_radio(struct genl_info *info,
 				    data->debugfs,
 				    data, &hwsim_simulate_radar);
 
-	tasklet_hrtimer_init(&data->beacon_timer,
-			     mac80211_hwsim_beacon,
-			     CLOCK_MONOTONIC, HRTIMER_MODE_ABS);
+	hrtimer_init(&data->beacon_timer, CLOCK_MONOTONIC,
+		     HRTIMER_MODE_REL_SOFT);
+	data->beacon_timer.function = mac80211_hwsim_beacon;
 
 	spin_lock_bh(&hwsim_radio_lock);
 	list_add_tail(&data->list, &hwsim_radios);
-- 
2.11.0
