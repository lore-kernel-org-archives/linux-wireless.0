Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f170.google.com ([209.85.217.170]:35697 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752710AbbCaLHt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Mar 2015 07:07:49 -0400
Received: by lbdc10 with SMTP id c10so9576623lbd.2
        for <linux-wireless@vger.kernel.org>; Tue, 31 Mar 2015 04:07:47 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 1/2] ath10k: fix hw roc expiration
Date: Tue, 31 Mar 2015 11:03:47 +0000
Message-Id: <1427799828-9539-1-git-send-email-michal.kazior@tieto.com> (sfid-20150331_130753_833921_BD9B7982)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It is not guaranteed firmware will switch to
foreign channel immediately after starting scan
sequence. To account for that don't use duration
parameter for scan time. Instead request insanely
long scan and use timeout worker to cancel it from
driver.

This should improve P2P reliability a bit.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 9206b109e1ce..cb5d253e87d9 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -5029,6 +5029,7 @@ static int ath10k_remain_on_channel(struct ieee80211_hw *hw,
 	struct ath10k_vif *arvif = ath10k_vif_to_arvif(vif);
 	struct wmi_start_scan_arg arg;
 	int ret = 0;
+	u32 scan_time_msec;
 
 	mutex_lock(&ar->conf_mutex);
 
@@ -5055,7 +5056,7 @@ static int ath10k_remain_on_channel(struct ieee80211_hw *hw,
 	if (ret)
 		goto exit;
 
-	duration = max(duration, WMI_SCAN_CHAN_MIN_TIME_MSEC);
+	scan_time_msec = ar->hw->wiphy->max_remain_on_channel_duration * 2;
 
 	memset(&arg, 0, sizeof(arg));
 	ath10k_wmi_start_scan_init(ar, &arg);
@@ -5063,9 +5064,9 @@ static int ath10k_remain_on_channel(struct ieee80211_hw *hw,
 	arg.scan_id = ATH10K_SCAN_ID;
 	arg.n_channels = 1;
 	arg.channels[0] = chan->center_freq;
-	arg.dwell_time_active = duration;
-	arg.dwell_time_passive = duration;
-	arg.max_scan_time = 2 * duration;
+	arg.dwell_time_active = scan_time_msec;
+	arg.dwell_time_passive = scan_time_msec;
+	arg.max_scan_time = scan_time_msec;
 	arg.scan_ctrl_flags |= WMI_SCAN_FLAG_PASSIVE;
 	arg.scan_ctrl_flags |= WMI_SCAN_FILTER_PROBE_REQ;
 
@@ -5090,6 +5091,9 @@ static int ath10k_remain_on_channel(struct ieee80211_hw *hw,
 		goto exit;
 	}
 
+	ieee80211_queue_delayed_work(ar->hw, &ar->scan.timeout,
+				     msecs_to_jiffies(duration));
+
 	ret = 0;
 exit:
 	mutex_unlock(&ar->conf_mutex);
-- 
2.1.4

