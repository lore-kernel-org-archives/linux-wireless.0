Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:64116 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635Ab3ABWz4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jan 2013 17:55:56 -0500
Received: by mail-pa0-f45.google.com with SMTP id bg2so8224131pad.4
        for <linux-wireless@vger.kernel.org>; Wed, 02 Jan 2013 14:55:56 -0800 (PST)
From: Thomas Pedersen <thomas@cozybit.com>
To: linville@tuxdriver.org
Cc: j@w1.fi, linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	devel@lists.open80211s.org, Thomas Pedersen <thomas@cozybit.com>
Subject: [PATCH v2 3/4] mac80211_hwsim: fix beacon timing
Date: Wed,  2 Jan 2013 14:55:18 -0800
Message-Id: <1357167319-13338-3-git-send-email-thomas@cozybit.com> (sfid-20130102_235600_359915_79F3E4F8)
In-Reply-To: <1357167319-13338-1-git-send-email-thomas@cozybit.com>
References: <1357167319-13338-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A beacon period starts at TSF time 0. Spoof this by
rounding the starting beacon time to a multiple of the
beacon interval, and keep TBTT aligned on TSF adjustment.

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 drivers/net/wireless/mac80211_hwsim.c |   24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index bccd17c..7b2acdd 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -358,6 +358,7 @@ struct mac80211_hwsim_data {
 
 	/* difference between this hw's clock and the real clock, in usecs */
 	s64 tsf_offset;
+	s64 bcn_delta;
 };
 
 
@@ -424,9 +425,12 @@ static void mac80211_hwsim_set_tsf(struct ieee80211_hw *hw,
 {
 	struct mac80211_hwsim_data *data = hw->priv;
 	u64 now = mac80211_hwsim_get_tsf(hw, vif);
+	u32 bcn_int = data->beacon_int;
 	s64 delta = tsf - now;
 
 	data->tsf_offset += delta;
+	/* adjust after beaconing with new timestamp at old TBTT */
+	data->bcn_delta = do_div(delta, bcn_int);
 }
 
 static void mac80211_hwsim_monitor_rx(struct ieee80211_hw *hw,
@@ -1001,6 +1005,12 @@ mac80211_hwsim_beacon(struct hrtimer *timer)
 		hw, IEEE80211_IFACE_ITER_NORMAL,
 		mac80211_hwsim_beacon_tx, hw);
 
+	/* beacon at new TBTT + beacon interval */
+	if (data->bcn_delta) {
+		bcn_int -= data->bcn_delta;
+		data->bcn_delta = 0;
+	}
+
 	next_bcn = ktime_add(hrtimer_get_expires(timer),
 			     ns_to_ktime(bcn_int * 1000));
 	tasklet_hrtimer_start(ttimer, next_bcn, HRTIMER_MODE_ABS);
@@ -1045,8 +1055,12 @@ static int mac80211_hwsim_config(struct ieee80211_hw *hw, u32 changed)
 	if (!data->started || !data->beacon_int)
 		tasklet_hrtimer_cancel(&data->beacon_timer);
 	else if (!hrtimer_is_queued(&data->beacon_timer.timer)) {
+		u64 tsf = mac80211_hwsim_get_tsf(hw, NULL);
+		u32 bcn_int = data->beacon_int;
+		u64 until_tbtt = bcn_int - do_div(tsf, bcn_int);
+
 		tasklet_hrtimer_start(&data->beacon_timer,
-				      ns_to_ktime(data->beacon_int * 1000),
+				      ns_to_ktime(until_tbtt * 1000),
 				      HRTIMER_MODE_REL);
 	}
 
@@ -1106,11 +1120,15 @@ static void mac80211_hwsim_bss_info_changed(struct ieee80211_hw *hw,
 		if (data->started &&
 		    !hrtimer_is_queued(&data->beacon_timer.timer) &&
 		    info->enable_beacon) {
+			u64 tsf, until_tbtt;
+			u32 bcn_int;
 			if (WARN_ON(!data->beacon_int))
 				data->beacon_int = 1000 * 1024;
+			tsf = mac80211_hwsim_get_tsf(hw, vif);
+			bcn_int = data->beacon_int;
+			until_tbtt = bcn_int - do_div(tsf, bcn_int);
 			tasklet_hrtimer_start(&data->beacon_timer,
-					      ns_to_ktime(data->beacon_int *
-							  1000),
+					      ns_to_ktime(until_tbtt * 1000),
 					      HRTIMER_MODE_REL);
 		} else if (!info->enable_beacon)
 			tasklet_hrtimer_cancel(&data->beacon_timer);
-- 
1.7.10.4

