Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:36353 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751920AbbKZK5z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Nov 2015 05:57:55 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 7/8] mac80211_hwsim: delay hardware remain-on-channel start
Date: Thu, 26 Nov 2015 11:57:47 +0100
Message-Id: <1448535468-12237-7-git-send-email-johannes@sipsolutions.net> (sfid-20151126_115835_593066_93312CDA)
In-Reply-To: <1448535468-12237-1-git-send-email-johannes@sipsolutions.net>
References: <1448535468-12237-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Typically drivers that implement hardware remain-on-channel will
have to wait for scheduling constraints, so make hwsim also wait
a little bit (only 20ms) before actually starting the operation.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 30 +++++++++++++++++++++++++-----
 1 file changed, 25 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index ee46f4647fbc..227c9c85d3ce 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -495,6 +495,9 @@ struct mac80211_hwsim_data {
 	const struct ieee80211_regdomain *regd;
 
 	struct ieee80211_channel *tmp_chan;
+	struct ieee80211_channel *roc_chan;
+	u32 roc_duration;
+	struct delayed_work roc_start;
 	struct delayed_work roc_done;
 	struct delayed_work hw_scan;
 	struct cfg80211_scan_request *hw_scan_request;
@@ -1987,6 +1990,23 @@ static void mac80211_hwsim_sw_scan_complete(struct ieee80211_hw *hw,
 	mutex_unlock(&hwsim->mutex);
 }
 
+static void hw_roc_start(struct work_struct *work)
+{
+	struct mac80211_hwsim_data *hwsim =
+		container_of(work, struct mac80211_hwsim_data, roc_start.work);
+
+	mutex_lock(&hwsim->mutex);
+
+	wiphy_debug(hwsim->hw->wiphy, "hwsim ROC begins\n");
+	hwsim->tmp_chan = hwsim->roc_chan;
+	ieee80211_ready_on_channel(hwsim->hw);
+
+	ieee80211_queue_delayed_work(hwsim->hw, &hwsim->roc_done,
+				     msecs_to_jiffies(hwsim->roc_duration));
+
+	mutex_unlock(&hwsim->mutex);
+}
+
 static void hw_roc_done(struct work_struct *work)
 {
 	struct mac80211_hwsim_data *hwsim =
@@ -2014,16 +2034,14 @@ static int mac80211_hwsim_roc(struct ieee80211_hw *hw,
 		return -EBUSY;
 	}
 
-	hwsim->tmp_chan = chan;
+	hwsim->roc_chan = chan;
+	hwsim->roc_duration = duration;
 	mutex_unlock(&hwsim->mutex);
 
 	wiphy_debug(hw->wiphy, "hwsim ROC (%d MHz, %d ms)\n",
 		    chan->center_freq, duration);
+	ieee80211_queue_delayed_work(hw, &hwsim->roc_start, HZ/50);
 
-	ieee80211_ready_on_channel(hw);
-
-	ieee80211_queue_delayed_work(hw, &hwsim->roc_done,
-				     msecs_to_jiffies(duration));
 	return 0;
 }
 
@@ -2031,6 +2049,7 @@ static int mac80211_hwsim_croc(struct ieee80211_hw *hw)
 {
 	struct mac80211_hwsim_data *hwsim = hw->priv;
 
+	cancel_delayed_work_sync(&hwsim->roc_start);
 	cancel_delayed_work_sync(&hwsim->roc_done);
 
 	mutex_lock(&hwsim->mutex);
@@ -2375,6 +2394,7 @@ static int mac80211_hwsim_new_radio(struct genl_info *info,
 		hw->wiphy->n_iface_combinations = ARRAY_SIZE(hwsim_if_comb);
 	}
 
+	INIT_DELAYED_WORK(&data->roc_start, hw_roc_start);
 	INIT_DELAYED_WORK(&data->roc_done, hw_roc_done);
 	INIT_DELAYED_WORK(&data->hw_scan, hw_scan_work);
 
-- 
2.6.2

