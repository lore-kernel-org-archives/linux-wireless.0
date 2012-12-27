Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f48.google.com ([209.85.160.48]:46004 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492Ab2L0Voe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Dec 2012 16:44:34 -0500
Received: by mail-pb0-f48.google.com with SMTP id rq13so5559036pbb.35
        for <linux-wireless@vger.kernel.org>; Thu, 27 Dec 2012 13:44:33 -0800 (PST)
From: Thomas Pedersen <thomas@cozybit.com>
To: linville@tuxdriver.org
Cc: j@w1.fi, linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	Thomas Pedersen <thomas@cozybit.com>
Subject: [PATCH 3/4] mac80211_hwsim: fix beacon timing
Date: Thu, 27 Dec 2012 13:43:55 -0800
Message-Id: <1356644636-5309-3-git-send-email-thomas@cozybit.com> (sfid-20121227_224436_471702_32BDAC6A)
In-Reply-To: <1356644636-5309-1-git-send-email-thomas@cozybit.com>
References: <1356644636-5309-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A beacon period starts at TSF time 0. Spoof this by
rounding the starting beacon time to a multiple of the
beacon interval, and keep TBTT aligned on TSF adjustment.

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 drivers/net/wireless/mac80211_hwsim.c |   23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index f353d5e..d513c3e 100644
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
@@ -1001,6 +1005,11 @@ mac80211_hwsim_beacon(struct hrtimer *timer)
 		hw, IEEE80211_IFACE_ITER_NORMAL,
 		mac80211_hwsim_beacon_tx, data);
 
+	/* beacon at new TBTT + beacon interval */
+	if (data->bcn_delta) {
+		bcn_int -= data->bcn_delta;
+		data->bcn_delta = 0;
+	}
 
 	next_bcn = ktime_add(hrtimer_get_expires(timer),
 			     ns_to_ktime(bcn_int * 1000));
@@ -1046,8 +1055,12 @@ static int mac80211_hwsim_config(struct ieee80211_hw *hw, u32 changed)
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
 
@@ -1107,11 +1120,15 @@ static void mac80211_hwsim_bss_info_changed(struct ieee80211_hw *hw,
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

