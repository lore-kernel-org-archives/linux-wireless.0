Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:35214 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751325AbdBUKbW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Feb 2017 05:31:22 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC] mac80211_hwsim: report survey data for scanned channels
Date: Tue, 21 Feb 2017 11:31:18 +0100
Message-Id: <20170221103118.18441-1-johannes@sipsolutions.net> (sfid-20170221_113125_607810_4E656EED)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Currently, hwsim is reporting survey data (only a fake noise floor)
for the current channel. This breaks when the multi-channel support
is enabled since then there's no current channel.

Make the dummy implementation closer to a real one and only report
data while scanning, for all the scanned channels. At other times,
no survey data might be available (in real hardware) due to power-
save for example.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
Had this lying around - is it useful for anyone?
---
 drivers/net/wireless/mac80211_hwsim.c | 73 ++++++++++++++++++++++++++++-------
 1 file changed, 60 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 0150747c79ac..5a636b09320b 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -525,6 +525,11 @@ struct mac80211_hwsim_data {
 	struct ieee80211_vif *hw_scan_vif;
 	int scan_chan_idx;
 	u8 scan_addr[ETH_ALEN];
+	struct {
+		struct ieee80211_channel *channel;
+		unsigned long next_start, start, end;
+	} survey_data[ARRAY_SIZE(hwsim_channels_2ghz) +
+		      ARRAY_SIZE(hwsim_channels_5ghz)];
 
 	struct ieee80211_channel *channel;
 	u64 beacon_int	/* beacon interval in us */;
@@ -1576,6 +1581,7 @@ static int mac80211_hwsim_config(struct ieee80211_hw *hw, u32 changed)
 		[IEEE80211_SMPS_STATIC] = "static",
 		[IEEE80211_SMPS_DYNAMIC] = "dynamic",
 	};
+	int idx;
 
 	if (conf->chandef.chan)
 		wiphy_debug(hw->wiphy,
@@ -1598,9 +1604,33 @@ static int mac80211_hwsim_config(struct ieee80211_hw *hw, u32 changed)
 
 	data->idle = !!(conf->flags & IEEE80211_CONF_IDLE);
 
-	data->channel = conf->chandef.chan;
+	WARN_ON(conf->chandef.chan && data->use_chanctx);
+
+	mutex_lock(&data->mutex);
+	if (data->scanning && conf->chandef.chan) {
+		for (idx = 0; idx < ARRAY_SIZE(data->survey_data); idx++) {
+			if (data->survey_data[idx].channel == data->channel) {
+				data->survey_data[idx].start =
+					data->survey_data[idx].next_start;
+				data->survey_data[idx].end = jiffies;
+				break;
+			}
+		}
 
-	WARN_ON(data->channel && data->use_chanctx);
+		data->channel = conf->chandef.chan;
+
+		for (idx = 0; idx < ARRAY_SIZE(data->survey_data); idx++) {
+			if (data->survey_data[idx].channel &&
+			    data->survey_data[idx].channel != data->channel)
+				continue;
+			data->survey_data[idx].channel = data->channel;
+			data->survey_data[idx].next_start = jiffies;
+			break;
+		}
+	} else {
+		data->channel = conf->chandef.chan;
+	}
+	mutex_unlock(&data->mutex);
 
 	data->power_level = conf->power_level;
 	if (!data->started || !data->beacon_int)
@@ -1787,28 +1817,39 @@ static int mac80211_hwsim_conf_tx(
 	return 0;
 }
 
-static int mac80211_hwsim_get_survey(
-	struct ieee80211_hw *hw, int idx,
-	struct survey_info *survey)
+static int mac80211_hwsim_get_survey(struct ieee80211_hw *hw, int idx,
+				     struct survey_info *survey)
 {
-	struct ieee80211_conf *conf = &hw->conf;
+	struct mac80211_hwsim_data *hwsim = hw->priv;
 
 	wiphy_debug(hw->wiphy, "%s (idx=%d)\n", __func__, idx);
 
-	if (idx != 0)
+	if (idx < 0 || idx >= ARRAY_SIZE(hwsim->survey_data))
 		return -ENOENT;
 
-	/* Current channel */
-	survey->channel = conf->chandef.chan;
+	mutex_lock(&hwsim->mutex);
+	survey->channel = hwsim->survey_data[idx].channel;
+	if (!survey->channel) {
+		mutex_unlock(&hwsim->mutex);
+		return -ENOENT;
+	}
 
 	/*
-	 * Magically conjured noise level --- this is only ok for simulated hardware.
+	 * Magically conjured dummy values --- this is only ok for simulated hardware.
 	 *
-	 * A real driver which cannot determine the real channel noise MUST NOT
-	 * report any noise, especially not a magically conjured one :-)
+	 * A real driver which cannot determine real values noise MUST NOT
+	 * report any, especially not a magically conjured ones :-)
 	 */
-	survey->filled = SURVEY_INFO_NOISE_DBM;
+	survey->filled = SURVEY_INFO_NOISE_DBM |
+			 SURVEY_INFO_CHANNEL_TIME |
+			 SURVEY_INFO_CHANNEL_TIME_BUSY;
 	survey->noise = -92;
+	survey->channel_time =
+		jiffies_to_msecs(hwsim->survey_data[idx].end -
+				 hwsim->survey_data[idx].start);
+	/* report 12.5% of channel time is used */
+	survey->channel_time_busy = survey->channel_time/8;
+	mutex_unlock(&hwsim->mutex);
 
 	return 0;
 }
@@ -1986,6 +2027,10 @@ static void hw_scan_work(struct work_struct *work)
 	}
 	ieee80211_queue_delayed_work(hwsim->hw, &hwsim->hw_scan,
 				     msecs_to_jiffies(dwell));
+	hwsim->survey_data[hwsim->scan_chan_idx].channel = hwsim->tmp_chan;
+	hwsim->survey_data[hwsim->scan_chan_idx].start = jiffies;
+	hwsim->survey_data[hwsim->scan_chan_idx].end =
+		jiffies + msecs_to_jiffies(dwell);
 	hwsim->scan_chan_idx++;
 	mutex_unlock(&hwsim->mutex);
 }
@@ -2011,6 +2056,7 @@ static int mac80211_hwsim_hw_scan(struct ieee80211_hw *hw,
 				     hw_req->req.mac_addr_mask);
 	else
 		memcpy(hwsim->scan_addr, vif->addr, ETH_ALEN);
+	memset(hwsim->survey_data, 0, sizeof(hwsim->survey_data));
 	mutex_unlock(&hwsim->mutex);
 
 	wiphy_debug(hw->wiphy, "hwsim hw_scan request\n");
@@ -2057,6 +2103,7 @@ static void mac80211_hwsim_sw_scan(struct ieee80211_hw *hw,
 
 	memcpy(hwsim->scan_addr, mac_addr, ETH_ALEN);
 	hwsim->scanning = true;
+	memset(hwsim->survey_data, 0, sizeof(hwsim->survey_data));
 
 out:
 	mutex_unlock(&hwsim->mutex);
-- 
2.9.3
