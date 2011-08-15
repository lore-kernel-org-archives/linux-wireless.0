Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40095 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753343Ab1HSVKf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Aug 2011 17:10:35 -0400
Received: by fxh19 with SMTP id 19so2180789fxh.19
        for <linux-wireless@vger.kernel.org>; Fri, 19 Aug 2011 14:10:34 -0700 (PDT)
Message-Id: <dcc36e33e308c55be6bd980d09735a0a1f9759f3.1313434481.git.chunkeey@googlemail.com> (sfid-20110819_231042_437640_A7DF0C05)
In-Reply-To: <75dddcb57243e0a2a1a2676444f19746b9c19072.1313434481.git.chunkeey@googlemail.com>
References: <2de58131999ccc3a6d8f048c5ccbbeaec8f8eec9.1313434481.git.chunkeey@googlemail.com>
	<75dddcb57243e0a2a1a2676444f19746b9c19072.1313434481.git.chunkeey@googlemail.com>
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Mon, 15 Aug 2011 19:50:48 +0200
Subject: [PATCH 3/4] carl9170: improve site survey
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The firmware keeps track of channel usage. This data can
be used by the automatic channel selection to find the
*best* channel.

Survey data from wlan22
	frequency:                      2412 MHz [in use]
	noise:                          -86 dBm
	channel active time:            3339608 ms
	channel busy time:              270982 ms
	channel transmit time:          121515 ms
Survey data from wlan22
	frequency:                      2417 MHz
	noise:                          -86 dBm
	channel active time:            70 ms
	channel busy time:              2 ms
	channel transmit time:          1 ms

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
 drivers/net/wireless/ath/carl9170/carl9170.h |   11 +++
 drivers/net/wireless/ath/carl9170/cmd.c      |   31 +++++++
 drivers/net/wireless/ath/carl9170/cmd.h      |    1 +
 drivers/net/wireless/ath/carl9170/main.c     |  118 +++++++++++++++++++++++---
 drivers/net/wireless/ath/carl9170/phy.c      |    7 +-
 5 files changed, 153 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/ath/carl9170/carl9170.h b/drivers/net/wireless/ath/carl9170/carl9170.h
index f7dbdaa..74350d6 100644
--- a/drivers/net/wireless/ath/carl9170/carl9170.h
+++ b/drivers/net/wireless/ath/carl9170/carl9170.h
@@ -151,6 +151,7 @@ struct carl9170_sta_tid {
 #define CARL9170_TX_TIMEOUT		2500
 #define CARL9170_JANITOR_DELAY		128
 #define CARL9170_QUEUE_STUCK_TIMEOUT	5500
+#define CARL9170_STAT_WORK		30000
 
 #define CARL9170_NUM_TX_AGG_MAX		30
 
@@ -332,11 +333,21 @@ struct ar9170 {
 
 	/* PHY */
 	struct ieee80211_channel *channel;
+	unsigned int num_channels;
 	int noise[4];
 	unsigned int chan_fail;
 	unsigned int total_chan_fail;
 	u8 heavy_clip;
 	u8 ht_settings;
+	struct {
+		u64 active;	/* usec */
+		u64 cca;	/* usec */
+		u64 tx_time;	/* usec */
+		u64 rx_total;
+		u64 rx_overrun;
+	} tally;
+	struct delayed_work stat_work;
+	struct survey_info *survey;
 
 	/* power calibration data */
 	u8 power_5G_leg[4];
diff --git a/drivers/net/wireless/ath/carl9170/cmd.c b/drivers/net/wireless/ath/carl9170/cmd.c
index cdfc94c..9970bf8 100644
--- a/drivers/net/wireless/ath/carl9170/cmd.c
+++ b/drivers/net/wireless/ath/carl9170/cmd.c
@@ -165,6 +165,37 @@ int carl9170_bcn_ctrl(struct ar9170 *ar, const unsigned int vif_id,
 	return __carl9170_exec_cmd(ar, cmd, true);
 }
 
+int carl9170_collect_tally(struct ar9170 *ar)
+{
+	struct carl9170_tally_rsp tally;
+	struct survey_info *info;
+	unsigned int tick;
+	int err;
+
+	err = carl9170_exec_cmd(ar, CARL9170_CMD_TALLY, 0, NULL,
+				sizeof(tally), (u8 *)&tally);
+	if (err)
+		return err;
+
+	tick = le32_to_cpu(tally.tick);
+	if (tick) {
+		ar->tally.active += le32_to_cpu(tally.active) / tick;
+		ar->tally.cca += le32_to_cpu(tally.cca) / tick;
+		ar->tally.tx_time += le32_to_cpu(tally.tx_time) / tick;
+		ar->tally.rx_total += le32_to_cpu(tally.rx_total);
+		ar->tally.rx_overrun += le32_to_cpu(tally.rx_overrun);
+
+		if (ar->channel) {
+			info = &ar->survey[ar->channel->hw_value];
+
+			info->channel_time = ar->tally.active / 1000;
+			info->channel_time_busy = ar->tally.cca / 1000;
+			info->channel_time_tx = ar->tally.tx_time / 1000;
+		}
+	}
+	return 0;
+}
+
 int carl9170_powersave(struct ar9170 *ar, const bool ps)
 {
 	struct carl9170_cmd *cmd;
diff --git a/drivers/net/wireless/ath/carl9170/cmd.h b/drivers/net/wireless/ath/carl9170/cmd.h
index d5f95bd..885c427 100644
--- a/drivers/net/wireless/ath/carl9170/cmd.h
+++ b/drivers/net/wireless/ath/carl9170/cmd.h
@@ -50,6 +50,7 @@ int carl9170_echo_test(struct ar9170 *ar, u32 v);
 int carl9170_reboot(struct ar9170 *ar);
 int carl9170_mac_reset(struct ar9170 *ar);
 int carl9170_powersave(struct ar9170 *ar, const bool power_on);
+int carl9170_collect_tally(struct ar9170 *ar);
 int carl9170_bcn_ctrl(struct ar9170 *ar, const unsigned int vif_id,
 		       const u32 mode, const u32 addr, const u32 len);
 
diff --git a/drivers/net/wireless/ath/carl9170/main.c b/drivers/net/wireless/ath/carl9170/main.c
index 0122930..85cb1bd 100644
--- a/drivers/net/wireless/ath/carl9170/main.c
+++ b/drivers/net/wireless/ath/carl9170/main.c
@@ -413,6 +413,9 @@ static int carl9170_op_start(struct ieee80211_hw *hw)
 
 	carl9170_set_state_when(ar, CARL9170_IDLE, CARL9170_STARTED);
 
+	ieee80211_queue_delayed_work(ar->hw, &ar->stat_work,
+		round_jiffies(msecs_to_jiffies(CARL9170_STAT_WORK)));
+
 	ieee80211_wake_queues(ar->hw);
 	err = 0;
 
@@ -423,6 +426,7 @@ out:
 
 static void carl9170_cancel_worker(struct ar9170 *ar)
 {
+	cancel_delayed_work_sync(&ar->stat_work);
 	cancel_delayed_work_sync(&ar->tx_janitor);
 #ifdef CONFIG_CARL9170_LEDS
 	cancel_delayed_work_sync(&ar->led_work);
@@ -794,6 +798,43 @@ static void carl9170_ps_work(struct work_struct *work)
 	mutex_unlock(&ar->mutex);
 }
 
+static int carl9170_update_survey(struct ar9170 *ar, bool flush, bool noise)
+{
+	int err;
+
+	if (noise) {
+		err = carl9170_get_noisefloor(ar);
+		if (err)
+			return err;
+	}
+
+	if (ar->fw.hw_counters) {
+		err = carl9170_collect_tally(ar);
+		if (err)
+			return err;
+	}
+
+	if (flush)
+		memset(&ar->tally, 0, sizeof(ar->tally));
+
+	return 0;
+}
+
+static void carl9170_stat_work(struct work_struct *work)
+{
+	struct ar9170 *ar = container_of(work, struct ar9170, stat_work.work);
+	int err;
+
+	mutex_lock(&ar->mutex);
+	err = carl9170_update_survey(ar, false, true);
+	mutex_unlock(&ar->mutex);
+
+	if (err)
+		return;
+
+	ieee80211_queue_delayed_work(ar->hw, &ar->stat_work,
+		round_jiffies(msecs_to_jiffies(CARL9170_STAT_WORK)));
+}
 
 static int carl9170_op_config(struct ieee80211_hw *hw, u32 changed)
 {
@@ -828,11 +869,19 @@ static int carl9170_op_config(struct ieee80211_hw *hw, u32 changed)
 		if (err)
 			goto out;
 
+		err = carl9170_update_survey(ar, true, false);
+		if (err)
+			goto out;
+
 		err = carl9170_set_channel(ar, hw->conf.channel,
 			hw->conf.channel_type, CARL9170_RFI_NONE);
 		if (err)
 			goto out;
 
+		err = carl9170_update_survey(ar, false, true);
+		if (err)
+			goto out;
+
 		err = carl9170_set_dyn_sifs_ack(ar);
 		if (err)
 			goto out;
@@ -1423,20 +1472,52 @@ static int carl9170_op_get_survey(struct ieee80211_hw *hw, int idx,
 				struct survey_info *survey)
 {
 	struct ar9170 *ar = hw->priv;
-	int err;
+	struct ieee80211_channel *chan;
+	struct ieee80211_supported_band *band;
+	int err, b, i;
 
-	if (idx != 0)
-		return -ENOENT;
+	chan = ar->channel;
+	if (!chan)
+		return -ENODEV;
 
-	mutex_lock(&ar->mutex);
-	err = carl9170_get_noisefloor(ar);
-	mutex_unlock(&ar->mutex);
-	if (err)
-		return err;
+	if (idx == chan->hw_value) {
+		mutex_lock(&ar->mutex);
+		err = carl9170_update_survey(ar, false, true);
+		mutex_unlock(&ar->mutex);
+		if (err)
+			return err;
+	}
 
-	survey->channel = ar->channel;
+	for (b = 0; b < IEEE80211_NUM_BANDS; b++) {
+		band = ar->hw->wiphy->bands[b];
+
+		if (!band)
+			continue;
+
+		for (i = 0; i < band->n_channels; i++) {
+			if (band->channels[i].hw_value == idx) {
+				chan = &band->channels[i];
+				goto found;
+			}
+		}
+	}
+	return -ENOENT;
+
+found:
+	memcpy(survey, &ar->survey[idx], sizeof(*survey));
+
+	survey->channel = chan;
 	survey->filled = SURVEY_INFO_NOISE_DBM;
-	survey->noise = ar->noise[0];
+
+	if (ar->channel == chan)
+		survey->filled |= SURVEY_INFO_IN_USE;
+
+	if (ar->fw.hw_counters) {
+		survey->filled |= SURVEY_INFO_CHANNEL_TIME |
+				  SURVEY_INFO_CHANNEL_TIME_BUSY |
+				  SURVEY_INFO_CHANNEL_TIME_TX;
+	}
+
 	return 0;
 }
 
@@ -1569,6 +1650,7 @@ void *carl9170_alloc(size_t priv_size)
 	INIT_WORK(&ar->ping_work, carl9170_ping_work);
 	INIT_WORK(&ar->restart_work, carl9170_restart_work);
 	INIT_WORK(&ar->ampdu_work, carl9170_ampdu_work);
+	INIT_DELAYED_WORK(&ar->stat_work, carl9170_stat_work);
 	INIT_DELAYED_WORK(&ar->tx_janitor, carl9170_tx_janitor);
 	INIT_LIST_HEAD(&ar->tx_ampdu_list);
 	rcu_assign_pointer(ar->tx_ampdu_iter,
@@ -1652,6 +1734,7 @@ static int carl9170_parse_eeprom(struct ar9170 *ar)
 	struct ath_regulatory *regulatory = &ar->common.regulatory;
 	unsigned int rx_streams, tx_streams, tx_params = 0;
 	int bands = 0;
+	int chans = 0;
 
 	if (ar->eeprom.length == cpu_to_le16(0xffff))
 		return -ENODATA;
@@ -1675,14 +1758,24 @@ static int carl9170_parse_eeprom(struct ar9170 *ar)
 	if (ar->eeprom.operating_flags & AR9170_OPFLAG_2GHZ) {
 		ar->hw->wiphy->bands[IEEE80211_BAND_2GHZ] =
 			&carl9170_band_2GHz;
+		chans += carl9170_band_2GHz.n_channels;
 		bands++;
 	}
 	if (ar->eeprom.operating_flags & AR9170_OPFLAG_5GHZ) {
 		ar->hw->wiphy->bands[IEEE80211_BAND_5GHZ] =
 			&carl9170_band_5GHz;
+		chans += carl9170_band_5GHz.n_channels;
 		bands++;
 	}
 
+	if (!bands)
+		return -EINVAL;
+
+	ar->survey = kzalloc(sizeof(struct survey_info) * chans, GFP_KERNEL);
+	if (!ar->survey)
+		return -ENOMEM;
+	ar->num_channels = chans;
+
 	/*
 	 * I measured this, a bandswitch takes roughly
 	 * 135 ms and a frequency switch about 80.
@@ -1701,7 +1794,7 @@ static int carl9170_parse_eeprom(struct ar9170 *ar)
 	/* second part of wiphy init */
 	SET_IEEE80211_PERM_ADDR(ar->hw, ar->eeprom.mac_address);
 
-	return bands ? 0 : -EINVAL;
+	return 0;
 }
 
 static int carl9170_reg_notifier(struct wiphy *wiphy,
@@ -1834,6 +1927,9 @@ void carl9170_free(struct ar9170 *ar)
 	kfree(ar->mem_bitmap);
 	ar->mem_bitmap = NULL;
 
+	kfree(ar->survey);
+	ar->survey = NULL;
+
 	mutex_destroy(&ar->mutex);
 
 	ieee80211_free_hw(ar->hw);
diff --git a/drivers/net/wireless/ath/carl9170/phy.c b/drivers/net/wireless/ath/carl9170/phy.c
index 8635c5c..472efc7 100644
--- a/drivers/net/wireless/ath/carl9170/phy.c
+++ b/drivers/net/wireless/ath/carl9170/phy.c
@@ -1573,6 +1573,9 @@ int carl9170_get_noisefloor(struct ar9170 *ar)
 			AR9170_PHY_EXT_CCA_MIN_PWR, phy_res[i + 2]), 8);
 	}
 
+	if (ar->channel)
+		ar->survey[ar->channel->hw_value].noise = ar->noise[0];
+
 	return 0;
 }
 
@@ -1765,10 +1768,6 @@ int carl9170_set_channel(struct ar9170 *ar, struct ieee80211_channel *channel,
 		ar->chan_fail = 0;
 	}
 
-	err = carl9170_get_noisefloor(ar);
-	if (err)
-		return err;
-
 	if (ar->heavy_clip) {
 		err = carl9170_write_reg(ar, AR9170_PHY_REG_HEAVY_CLIP_ENABLE,
 					 0x200 | ar->heavy_clip);
-- 
1.7.5.4

