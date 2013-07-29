Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:61071 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755665Ab3G2HIj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Jul 2013 03:08:39 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2] ath10k: implement get_survey()
Date: Mon, 29 Jul 2013 09:08:32 +0200
Message-ID: <1375081712-9697-1-git-send-email-michal.kazior@tieto.com> (sfid-20130729_090852_048606_34BF3C3B)
In-Reply-To: <1374750412-5513-1-git-send-email-michal.kazior@tieto.com>
References: <1374750412-5513-1-git-send-email-michal.kazior@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This implements a limited subset of what can be
reported in the survey dump.

This can be used for assessing approximate channel
load, e.g. for automatic channel selection.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---

v2: Do not sum up channel time. Each time a
    channel is visited stats for that channel are
    overwritten. This makes the behaviour
    more consistent with ath9k.

 drivers/net/wireless/ath/ath10k/core.h |    6 +++
 drivers/net/wireless/ath/ath10k/mac.c  |   36 +++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi.c  |   68 +++++++++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath10k/wmi.h  |    3 ++
 4 files changed, 112 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 9f21ecb..e1cd1e7 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -38,6 +38,7 @@
 #define ATH10K_SCAN_ID 0
 #define WMI_READY_TIMEOUT (5 * HZ)
 #define ATH10K_FLUSH_TIMEOUT_HZ (5*HZ)
+#define ATH10K_NUM_CHANS 38
 
 /* Antenna noise floor */
 #define ATH10K_DEFAULT_NOISE_FLOOR -95
@@ -374,6 +375,11 @@ struct ath10k {
 
 	struct work_struct restart_work;
 
+	/* cycle count is reported twice for each visited channel during scan */
+	u32 survey_last_rx_clear_count;
+	u32 survey_last_cycle_count;
+	struct survey_info survey[ATH10K_NUM_CHANS];
+
 #ifdef CONFIG_ATH10K_DEBUGFS
 	struct ath10k_debug debug;
 #endif
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index d0a7761..5d4ce96 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -2934,6 +2934,41 @@ static void ath10k_restart_complete(struct ieee80211_hw *hw)
 	mutex_unlock(&ar->conf_mutex);
 }
 
+static int ath10k_get_survey(struct ieee80211_hw *hw, int idx,
+			     struct survey_info *survey)
+{
+	struct ath10k *ar = hw->priv;
+	struct ieee80211_supported_band *sband;
+	struct survey_info *ar_survey = &ar->survey[idx];
+	int ret = 0;
+
+	mutex_lock(&ar->conf_mutex);
+
+	sband = hw->wiphy->bands[IEEE80211_BAND_2GHZ];
+	if (sband && idx >= sband->n_channels) {
+		idx -= sband->n_channels;
+		sband = NULL;
+	}
+
+	if (!sband)
+		sband = hw->wiphy->bands[IEEE80211_BAND_5GHZ];
+
+	if (!sband || idx >= sband->n_channels) {
+		ret = -ENOENT;
+		goto exit;
+	}
+
+	spin_lock_bh(&ar->data_lock);
+	memcpy(survey, ar_survey, sizeof(*survey));
+	spin_unlock_bh(&ar->data_lock);
+
+	survey->channel = &sband->channels[idx];
+
+exit:
+	mutex_unlock(&ar->conf_mutex);
+	return ret;
+}
+
 static const struct ieee80211_ops ath10k_ops = {
 	.tx				= ath10k_tx,
 	.start				= ath10k_start,
@@ -2955,6 +2990,7 @@ static const struct ieee80211_ops ath10k_ops = {
 	.flush				= ath10k_flush,
 	.tx_last_beacon			= ath10k_tx_last_beacon,
 	.restart_complete		= ath10k_restart_complete,
+	.get_survey			= ath10k_get_survey,
 #ifdef CONFIG_PM
 	.suspend			= ath10k_suspend,
 	.resume				= ath10k_resume,
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 5e42460..2150dc84 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -390,9 +390,75 @@ static int ath10k_wmi_event_mgmt_rx(struct ath10k *ar, struct sk_buff *skb)
 	return 0;
 }
 
+static int freq_to_idx(struct ath10k *ar, int freq)
+{
+	struct ieee80211_supported_band *sband;
+	int band, ch, idx = 0;
+
+	for (band = IEEE80211_BAND_2GHZ; band < IEEE80211_NUM_BANDS; band++) {
+		sband = ar->hw->wiphy->bands[band];
+		if (!sband)
+			continue;
+
+		for (ch = 0; ch < sband->n_channels; ch++, idx++)
+			if (sband->channels[ch].center_freq == freq)
+				goto exit;
+	}
+
+exit:
+	return idx;
+}
+
 static void ath10k_wmi_event_chan_info(struct ath10k *ar, struct sk_buff *skb)
 {
-	ath10k_dbg(ATH10K_DBG_WMI, "WMI_CHAN_INFO_EVENTID\n");
+	struct wmi_chan_info_event *ev;
+	int idx;
+
+	spin_lock_bh(&ar->data_lock);
+
+	ev = (struct wmi_chan_info_event *)skb->data;
+	ath10k_dbg(ATH10K_DBG_WMI,
+		   "chan info: err_code:%d freq:%d cmd_flags:%d noise_floor:%d rx_clear_count:%d cycle_count:%d\n",
+		   __le32_to_cpu(ev->err_code),
+		   __le32_to_cpu(ev->freq),
+		   __le32_to_cpu(ev->cmd_flags),
+		   __le32_to_cpu(ev->noise_floor),
+		   __le32_to_cpu(ev->rx_clear_count),
+		   __le32_to_cpu(ev->cycle_count));
+
+	if (!ar->scan.in_progress) {
+		ath10k_warn("chan info event without a scan request?\n");
+		goto exit;
+	}
+
+	if (__le32_to_cpu(ev->cmd_flags) & WMI_CHAN_INFO_FLAG_COMPLETE) {
+		idx = freq_to_idx(ar, __le32_to_cpu(ev->freq));
+		if (idx >= ARRAY_SIZE(ar->survey)) {
+			ath10k_warn("chan info: invalid frequency %d (idx %d out of bounds)\n",
+				    __le32_to_cpu(ev->freq), idx);
+		} else {
+			/* During scanning chan info is reported twice for each
+			 * visited channel. The reported cycle count is global
+			 * and per-channel cycle count must be calculated */
+
+			ar->survey[idx].channel_time = WMI_CHAN_INFO_MSEC(
+					__le32_to_cpu(ev->cycle_count) -
+					ar->survey_last_cycle_count);
+			ar->survey[idx].channel_time_rx = WMI_CHAN_INFO_MSEC(
+					__le32_to_cpu(ev->rx_clear_count) -
+					ar->survey_last_rx_clear_count);
+			ar->survey[idx].noise = __le32_to_cpu(ev->noise_floor);
+			ar->survey[idx].filled = SURVEY_INFO_CHANNEL_TIME |
+						 SURVEY_INFO_CHANNEL_TIME_RX |
+						 SURVEY_INFO_NOISE_DBM;
+		}
+	}
+
+	ar->survey_last_rx_clear_count = __le32_to_cpu(ev->rx_clear_count);
+	ar->survey_last_cycle_count = __le32_to_cpu(ev->cycle_count);
+
+exit:
+	spin_unlock_bh(&ar->data_lock);
 }
 
 static void ath10k_wmi_event_echo(struct ath10k *ar, struct sk_buff *skb)
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index da3b2bc..4acff47 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -2931,6 +2931,9 @@ struct wmi_chan_info_event {
 	__le32 cycle_count;
 } __packed;
 
+#define WMI_CHAN_INFO_FLAG_COMPLETE BIT(0)
+#define WMI_CHAN_INFO_MSEC(x) ((x) / 76595) /* XXX: empirically extrapolated */
+
 /* Beacon filter wmi command info */
 #define BCN_FLT_MAX_SUPPORTED_IES	256
 #define BCN_FLT_MAX_ELEMS_IE_LIST	(BCN_FLT_MAX_SUPPORTED_IES / 32)
-- 
1.7.9.5

