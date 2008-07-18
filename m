Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:13137 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752029AbYGRF4e (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jul 2008 01:56:34 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 10/13] iwlwifi: kill iwl4965_fill_rs_info
Date: Fri, 18 Jul 2008 13:53:06 +0800
Message-Id: <1216360389-5352-11-git-send-email-yi.zhu@intel.com> (sfid-20080718_075637_534456_0380BD0A)
In-Reply-To: <1216360389-5352-10-git-send-email-yi.zhu@intel.com>
References: <1216360389-5352-1-git-send-email-yi.zhu@intel.com>
 <1216360389-5352-2-git-send-email-yi.zhu@intel.com>
 <1216360389-5352-3-git-send-email-yi.zhu@intel.com>
 <1216360389-5352-4-git-send-email-yi.zhu@intel.com>
 <1216360389-5352-5-git-send-email-yi.zhu@intel.com>
 <1216360389-5352-6-git-send-email-yi.zhu@intel.com>
 <1216360389-5352-7-git-send-email-yi.zhu@intel.com>
 <1216360389-5352-8-git-send-email-yi.zhu@intel.com>
 <1216360389-5352-9-git-send-email-yi.zhu@intel.com>
 <1216360389-5352-10-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

iwl4965_fill_rs_info was used in sysfs. This info is already present
in iwl-agn-rs debugfs.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c   |   92 ---------------------------
 drivers/net/wireless/iwlwifi/iwl-agn-rs.h   |    9 ---
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   10 ---
 3 files changed, 0 insertions(+), 111 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index eee22c6..0e8100e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -2600,98 +2600,6 @@ static struct rate_control_ops rs_ops = {
 #endif
 };
 
-int iwl4965_fill_rs_info(struct ieee80211_hw *hw, char *buf, u8 sta_id)
-{
-	struct ieee80211_local *local = hw_to_local(hw);
-	struct iwl_priv *priv = hw->priv;
-	struct iwl_lq_sta *lq_sta;
-	struct sta_info *sta;
-	int cnt = 0, i;
-	u32 samples = 0, success = 0, good = 0;
-	unsigned long now = jiffies;
-	u32 max_time = 0;
-	u8 lq_type, antenna;
-
-	rcu_read_lock();
-
-	sta = sta_info_get(local, priv->stations[sta_id].sta.sta.addr);
-	if (!sta || !sta->rate_ctrl_priv) {
-		if (sta)
-			IWL_DEBUG_RATE("leave - no private rate data!\n");
-		else
-			IWL_DEBUG_RATE("leave - no station!\n");
-		rcu_read_unlock();
-		return sprintf(buf, "station %d not found\n", sta_id);
-	}
-
-	lq_sta = (void *)sta->rate_ctrl_priv;
-
-	lq_type = lq_sta->lq_info[lq_sta->active_tbl].lq_type;
-	antenna = lq_sta->lq_info[lq_sta->active_tbl].ant_type;
-
-	if (is_legacy(lq_type))
-		i = IWL_RATE_54M_INDEX;
-	else
-		i = IWL_RATE_60M_INDEX;
-	while (1) {
-		u64 mask;
-		int j;
-		int active = lq_sta->active_tbl;
-
-		cnt +=
-		    sprintf(&buf[cnt], " %2dMbs: ", iwl_rates[i].ieee / 2);
-
-		mask = (1ULL << (IWL_RATE_MAX_WINDOW - 1));
-		for (j = 0; j < IWL_RATE_MAX_WINDOW; j++, mask >>= 1)
-			buf[cnt++] =
-				(lq_sta->lq_info[active].win[i].data & mask)
-				? '1' : '0';
-
-		samples += lq_sta->lq_info[active].win[i].counter;
-		good += lq_sta->lq_info[active].win[i].success_counter;
-		success += lq_sta->lq_info[active].win[i].success_counter *
-			   iwl_rates[i].ieee;
-
-		if (lq_sta->lq_info[active].win[i].stamp) {
-			int delta =
-				   jiffies_to_msecs(now -
-				   lq_sta->lq_info[active].win[i].stamp);
-
-			if (delta > max_time)
-				max_time = delta;
-
-			cnt += sprintf(&buf[cnt], "%5dms\n", delta);
-		} else
-			buf[cnt++] = '\n';
-
-		j = iwl4965_get_prev_ieee_rate(i);
-		if (j == i)
-			break;
-		i = j;
-	}
-
-	/*
-	 * Display the average rate of all samples taken.
-	 * NOTE: We multiply # of samples by 2 since the IEEE measurement
-	 * added from iwl_rates is actually 2X the rate.
-	 */
-	if (samples)
-		cnt += sprintf(&buf[cnt],
-			 "\nAverage rate is %3d.%02dMbs over last %4dms\n"
-			 "%3d%% success (%d good packets over %d tries)\n",
-			 success / (2 * samples), (success * 5 / samples) % 10,
-			 max_time, good * 100 / samples, good, samples);
-	else
-		cnt += sprintf(&buf[cnt], "\nAverage rate: 0Mbs\n");
-
-	cnt += sprintf(&buf[cnt], "\nrate scale type %d antenna %d "
-			 "active_search %d rate index %d\n", lq_type, antenna,
-			 lq_sta->search_better_tbl, sta->last_txrate_idx);
-
-	rcu_read_unlock();
-	return cnt;
-}
-
 int iwlagn_rate_control_register(void)
 {
 	return ieee80211_rate_control_register(&rs_ops);
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.h b/drivers/net/wireless/iwlwifi/iwl-agn-rs.h
index 3b06c9d..84d4d1e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.h
@@ -287,15 +287,6 @@ static inline u8 iwl4965_get_prev_ieee_rate(u8 rate_index)
 }
 
 /**
- * iwl4965_fill_rs_info - Fill an output text buffer with the rate representation
- *
- * NOTE:  This is provided as a quick mechanism for a user to visualize
- * the performance of the rate control algorithm and is not meant to be
- * parsed software.
- */
-extern int iwl4965_fill_rs_info(struct ieee80211_hw *, char *buf, u8 sta_id);
-
-/**
  * iwl4965_rate_control_register - Register the rate control algorithm callbacks
  *
  * Since the rate control algorithm is hardware specific, there is no need
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 3c9c5f0..49cb58f 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -3688,15 +3688,6 @@ static ssize_t show_temperature(struct device *d,
 
 static DEVICE_ATTR(temperature, S_IRUGO, show_temperature, NULL);
 
-static ssize_t show_rs_window(struct device *d,
-			      struct device_attribute *attr,
-			      char *buf)
-{
-	struct iwl_priv *priv = d->driver_data;
-	return iwl4965_fill_rs_info(priv->hw, buf, IWL_AP_ID);
-}
-static DEVICE_ATTR(rs_window, S_IRUGO, show_rs_window, NULL);
-
 static ssize_t show_tx_power(struct device *d,
 			     struct device_attribute *attr, char *buf)
 {
@@ -4119,7 +4110,6 @@ static struct attribute *iwl4965_sysfs_entries[] = {
 #endif
 	&dev_attr_power_level.attr,
 	&dev_attr_retry_rate.attr,
-	&dev_attr_rs_window.attr,
 	&dev_attr_statistics.attr,
 	&dev_attr_status.attr,
 	&dev_attr_temperature.attr,
-- 
1.5.3.6

