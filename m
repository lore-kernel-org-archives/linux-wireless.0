Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-da0-f42.google.com ([209.85.210.42]:52982 "EHLO
	mail-da0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753999Ab2LSCBf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Dec 2012 21:01:35 -0500
Received: by mail-da0-f42.google.com with SMTP id z17so641800dal.15
        for <linux-wireless@vger.kernel.org>; Tue, 18 Dec 2012 18:01:35 -0800 (PST)
From: Thomas Pedersen <thomas@cozybit.com>
To: linville@tuxdriver.com
Cc: j@wl.fi, jlopex@cozybit.com, linux-wireless@vger.kernel.org,
	Thomas Pedersen <thomas@cozybit.com>
Subject: [PATCH 2/3] mac80211_hwsim: beacon at beacon interval
Date: Tue, 18 Dec 2012 17:37:00 -0800
Message-Id: <1355881021-7071-2-git-send-email-thomas@cozybit.com> (sfid-20121219_030138_517034_D741F4B7)
In-Reply-To: <1355881021-7071-1-git-send-email-thomas@cozybit.com>
References: <1355881021-7071-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A beacon period starts at TSF time 0. Spoof this by
rounding the starting beacon time to a multiple of the
beacon interval.

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 drivers/net/wireless/mac80211_hwsim.c |   21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 0a8f37e..764a358 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -1044,9 +1044,14 @@ static int mac80211_hwsim_config(struct ieee80211_hw *hw, u32 changed)
 	data->power_level = conf->power_level;
 	if (!data->started || !ktime_to_ns(data->beacon_int))
 		hrtimer_cancel(&data->beacon_timer);
-	else if (!hrtimer_is_queued(&data->beacon_timer))
-		hrtimer_start(&data->beacon_timer, data->beacon_int,
-			      HRTIMER_MODE_REL);
+	else if (!hrtimer_is_queued(&data->beacon_timer)) {
+		u64 tsf = le64_to_cpu(__mac80211_hwsim_get_tsf(data));
+		u64 bcn_int = ktime_to_ns(data->beacon_int) / 1000;
+		u64 next_tbtt = bcn_int - do_div(tsf, bcn_int);
+
+		hrtimer_start(&data->beacon_timer,
+			      ns_to_ktime(next_tbtt * 1000), HRTIMER_MODE_REL);
+	}
 
 	return 0;
 }
@@ -1099,9 +1104,15 @@ static void mac80211_hwsim_bss_info_changed(struct ieee80211_hw *hw,
 		data->beacon_int = ns_to_ktime(info->beacon_int * 1024 * 1000);
 		if (WARN_ON(!ktime_to_ns(data->beacon_int)))
 			data->beacon_int = ns_to_ktime(1000 * 1000);
-		if (data->started && !hrtimer_is_queued(&data->beacon_timer))
+		if (data->started && !hrtimer_is_queued(&data->beacon_timer)) {
+			u64 tsf = le64_to_cpu(__mac80211_hwsim_get_tsf(data));
+			u64 bcn_int = ktime_to_ns(data->beacon_int) / 1000;
+			u64 next_tbtt = bcn_int - do_div(tsf, bcn_int);
+
 			hrtimer_start(&data->beacon_timer,
-				      data->beacon_int, HRTIMER_MODE_REL);
+				      ns_to_ktime(next_tbtt * 1000),
+				      HRTIMER_MODE_REL);
+		}
 	}
 
 	if (changed & BSS_CHANGED_ERP_CTS_PROT) {
-- 
1.7.10.4

