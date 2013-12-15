Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f178.google.com ([209.85.192.178]:39986 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751914Ab3LOVPT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Dec 2013 16:15:19 -0500
Received: by mail-pd0-f178.google.com with SMTP id y10so4497364pdj.37
        for <linux-wireless@vger.kernel.org>; Sun, 15 Dec 2013 13:15:18 -0800 (PST)
From: Thomas Pedersen <twpedersen@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: open80211s <devel@lists.open80211s.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Thomas Pedersen <thomas@cozybit.com>
Subject: [PATCH 1/3] mac80211_hwsim: fix duplicate beacons on TSF adjust
Date: Sun, 15 Dec 2013 13:14:14 -0800
Message-Id: <1387142056-21850-1-git-send-email-twpedersen@gmail.com> (sfid-20131215_221522_491356_6C4223F3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Thomas Pedersen <thomas@cozybit.com>

There was some bug when rescheduling the next beacon from
the beacon tasklet after adjusting TSF which would cause
the beacon timer to trigger twice. Beaconing at "old" TBT
(previously scheduled interface TBTT) with new timestamp
was incorrect anyway.

Instead, reschedule the beacon straight away when
adjusting TSF.

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 drivers/net/wireless/mac80211_hwsim.c |   56 +++++++++++++++------------------
 1 file changed, 25 insertions(+), 31 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index ab87556..cd27851 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -434,17 +434,35 @@ static u64 mac80211_hwsim_get_tsf(struct ieee80211_hw *hw,
 	return le64_to_cpu(__mac80211_hwsim_get_tsf(data));
 }
 
+static void mac80211_hwsim_beacon_sched(struct ieee80211_hw *hw)
+{
+	struct mac80211_hwsim_data *data = hw->priv;
+	u64 tsf = mac80211_hwsim_get_tsf(hw, NULL);
+	u32 bcn_int = data->beacon_int;
+	u64 until_tbtt;
+
+	if (!bcn_int)
+		return;
+
+	until_tbtt = bcn_int - do_div(tsf, bcn_int);
+	if (hrtimer_is_queued(&data->beacon_timer.timer))
+		tasklet_hrtimer_cancel(&data->beacon_timer);
+	tasklet_hrtimer_start(&data->beacon_timer,
+			      ns_to_ktime(until_tbtt * 1000),
+			      HRTIMER_MODE_REL);
+}
+
 static void mac80211_hwsim_set_tsf(struct ieee80211_hw *hw,
 		struct ieee80211_vif *vif, u64 tsf)
 {
 	struct mac80211_hwsim_data *data = hw->priv;
 	u64 now = mac80211_hwsim_get_tsf(hw, vif);
-	u32 bcn_int = data->beacon_int;
 	s64 delta = tsf - now;
 
 	data->tsf_offset += delta;
-	/* adjust after beaconing with new timestamp at old TBTT */
-	data->bcn_delta = do_div(delta, bcn_int);
+
+	/* reschedule next beacon to happen at new TBTT */
+	mac80211_hwsim_beacon_sched(hw);
 }
 
 static void mac80211_hwsim_monitor_rx(struct ieee80211_hw *hw,
@@ -1067,8 +1085,6 @@ mac80211_hwsim_beacon(struct hrtimer *timer)
 		container_of(timer, struct mac80211_hwsim_data,
 			     beacon_timer.timer);
 	struct ieee80211_hw *hw = data->hw;
-	u64 bcn_int = data->beacon_int;
-	ktime_t next_bcn;
 
 	if (!data->started)
 		goto out;
@@ -1077,15 +1093,7 @@ mac80211_hwsim_beacon(struct hrtimer *timer)
 		hw, IEEE80211_IFACE_ITER_NORMAL,
 		mac80211_hwsim_beacon_tx, data);
 
-	/* beacon at new TBTT + beacon interval */
-	if (data->bcn_delta) {
-		bcn_int -= data->bcn_delta;
-		data->bcn_delta = 0;
-	}
-
-	next_bcn = ktime_add(hrtimer_get_expires(timer),
-			     ns_to_ktime(bcn_int * 1000));
-	tasklet_hrtimer_start(&data->beacon_timer, next_bcn, HRTIMER_MODE_ABS);
+	mac80211_hwsim_beacon_sched(hw);
 out:
 	return HRTIMER_NORESTART;
 }
@@ -1138,15 +1146,8 @@ static int mac80211_hwsim_config(struct ieee80211_hw *hw, u32 changed)
 	data->power_level = conf->power_level;
 	if (!data->started || !data->beacon_int)
 		tasklet_hrtimer_cancel(&data->beacon_timer);
-	else if (!hrtimer_is_queued(&data->beacon_timer.timer)) {
-		u64 tsf = mac80211_hwsim_get_tsf(hw, NULL);
-		u32 bcn_int = data->beacon_int;
-		u64 until_tbtt = bcn_int - do_div(tsf, bcn_int);
-
-		tasklet_hrtimer_start(&data->beacon_timer,
-				      ns_to_ktime(until_tbtt * 1000),
-				      HRTIMER_MODE_REL);
-	}
+	else if (!hrtimer_is_queued(&data->beacon_timer.timer))
+		mac80211_hwsim_beacon_sched(hw);
 
 	return 0;
 }
@@ -1216,16 +1217,9 @@ static void mac80211_hwsim_bss_info_changed(struct ieee80211_hw *hw,
 		if (data->started &&
 		    !hrtimer_is_queued(&data->beacon_timer.timer) &&
 		    info->enable_beacon) {
-			u64 tsf, until_tbtt;
-			u32 bcn_int;
 			if (WARN_ON(!data->beacon_int))
 				data->beacon_int = 1000 * 1024;
-			tsf = mac80211_hwsim_get_tsf(hw, vif);
-			bcn_int = data->beacon_int;
-			until_tbtt = bcn_int - do_div(tsf, bcn_int);
-			tasklet_hrtimer_start(&data->beacon_timer,
-					      ns_to_ktime(until_tbtt * 1000),
-					      HRTIMER_MODE_REL);
+			mac80211_hwsim_beacon_sched(hw);
 		} else if (!info->enable_beacon) {
 			unsigned int count = 0;
 			ieee80211_iterate_active_interfaces(
-- 
1.7.10.4

