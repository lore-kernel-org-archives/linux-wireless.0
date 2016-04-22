Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:55422 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753314AbcDVFr3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Apr 2016 01:47:29 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>, <rmanohar@codeaurora.org>,
	"Rajkumar Manoharan" <rmanohar@qti.qualcomm.com>
Subject: [PATCH 4/4] ath10k: update bss channel survey information
Date: Fri, 22 Apr 2016 11:16:32 +0530
Message-ID: <1461303992-9913-4-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20160422_074731_878666_EFD5E1AC)
In-Reply-To: <1461303992-9913-1-git-send-email-rmanohar@qti.qualcomm.com>
References: <1461303992-9913-1-git-send-email-rmanohar@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

During hw scan, firmware sends two channel information events (pre-
complete, complete) to host for each channel change. The snap shot of cycle
counters (rx_clear and total) between these two events are given for
survey dump. In order to get latest survey statistics of all channels, a
scan request has to be issued. In general, an AP DUT is brought up, it
won't leave BSS channel except few cases like overlapping bss or radar
detection. So survey statistics of bss channel is always referring to
older data that are collected before starting AP (either ACS/OBSS scan).

To collect latest survey information from target, firmware provides WMI
interface to read cycle counters from hardware. For each survey dump
request, BSS channel cycle counters are read and cleared in hardware.
This makes sure that behavior is in align with ath9k survey report.
So survey dump always gives snap shot of cycle counters b/w two survey
requests.

Signed-off-by: Yanbo Li <yanbol@qca.qualcomm.com>
Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.c |  5 +++++
 drivers/net/wireless/ath/ath10k/core.h |  1 +
 drivers/net/wireless/ath/ath10k/mac.c  | 35 ++++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi.c  | 29 ++++++++++++++++++++++++++++
 4 files changed, 70 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 1c4106b84a35..5f846bd4054c 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -1460,6 +1460,7 @@ static void ath10k_core_restart(struct work_struct *work)
 	complete_all(&ar->install_key_done);
 	complete_all(&ar->vdev_setup_done);
 	complete_all(&ar->thermal.wmi_sync);
+	complete_all(&ar->bss_survey_done);
 	wake_up(&ar->htt.empty_tx_wq);
 	wake_up(&ar->wmi.tx_credits_wq);
 	wake_up(&ar->peer_mapping_wq);
@@ -1787,6 +1788,9 @@ int ath10k_core_start(struct ath10k *ar, enum ath10k_firmware_mode mode)
 		if (ath10k_peer_stats_enabled(ar))
 			val = WMI_10_4_PEER_STATS;
 
+		if (test_bit(WMI_SERVICE_BSS_CHANNEL_INFO_64, ar->wmi.svc_map))
+			val |= WMI_10_4_BSS_CHANNEL_INFO_64;
+
 		status = ath10k_mac_ext_resource_config(ar, val);
 		if (status) {
 			ath10k_err(ar,
@@ -2142,6 +2146,7 @@ struct ath10k *ath10k_core_create(size_t priv_size, struct device *dev,
 	init_completion(&ar->install_key_done);
 	init_completion(&ar->vdev_setup_done);
 	init_completion(&ar->thermal.wmi_sync);
+	init_completion(&ar->bss_survey_done);
 
 	INIT_DELAYED_WORK(&ar->scan.timeout, ath10k_scan_timeout_work);
 
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index ccc3d639b077..16c979b1bf2d 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -859,6 +859,7 @@ struct ath10k {
 	 * avoid reporting garbage data.
 	 */
 	bool ch_info_can_report_survey;
+	struct completion bss_survey_done;
 
 	struct dfs_pattern_detector *dfs_detector;
 
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index bcf025f51310..8e5fb931d816 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -6404,6 +6404,39 @@ static void ath10k_reconfig_complete(struct ieee80211_hw *hw,
 	mutex_unlock(&ar->conf_mutex);
 }
 
+static void
+ath10k_mac_update_bss_chan_survey(struct ath10k *ar,
+				  struct ieee80211_channel *channel)
+{
+	int ret;
+	enum wmi_bss_survey_req_type type = WMI_BSS_SURVEY_REQ_TYPE_READ_CLEAR;
+
+	lockdep_assert_held(&ar->conf_mutex);
+
+	if (!test_bit(WMI_SERVICE_BSS_CHANNEL_INFO_64, ar->wmi.svc_map) ||
+	    (ar->rx_channel != channel))
+		return;
+
+	if (ar->scan.state != ATH10K_SCAN_IDLE) {
+		ath10k_dbg(ar, ATH10K_DBG_MAC, "ignoring bss chan info request while scanning..\n");
+		return;
+	}
+
+	reinit_completion(&ar->bss_survey_done);
+
+	ret = ath10k_wmi_pdev_bss_chan_info_request(ar, type);
+	if (ret) {
+		ath10k_warn(ar, "failed to send pdev bss chan info request\n");
+		return;
+	}
+
+	ret = wait_for_completion_timeout(&ar->bss_survey_done, 3 * HZ);
+	if (!ret) {
+		ath10k_warn(ar, "bss channel survey timed out\n");
+		return;
+	}
+}
+
 static int ath10k_get_survey(struct ieee80211_hw *hw, int idx,
 			     struct survey_info *survey)
 {
@@ -6428,6 +6461,8 @@ static int ath10k_get_survey(struct ieee80211_hw *hw, int idx,
 		goto exit;
 	}
 
+	ath10k_mac_update_bss_chan_survey(ar, survey->channel);
+
 	spin_lock_bh(&ar->data_lock);
 	memcpy(survey, ar_survey, sizeof(*survey));
 	spin_unlock_bh(&ar->data_lock);
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 0f6b8c73a562..bf25ae255708 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -4800,8 +4800,11 @@ static int ath10k_wmi_event_pdev_bss_chan_info(struct ath10k *ar,
 					       struct sk_buff *skb)
 {
 	struct wmi_pdev_bss_chan_info_event *ev;
+	struct survey_info *survey;
 	u64 busy, total, tx, rx, rx_bss;
 	u32 freq, noise_floor;
+	u32 cc_freq_hz = ar->hw_params.channel_counters_freq_hz;
+	int idx;
 
 	ev = (struct wmi_pdev_bss_chan_info_event *)skb->data;
 	if (WARN_ON(skb->len < sizeof(*ev)))
@@ -4819,6 +4822,29 @@ static int ath10k_wmi_event_pdev_bss_chan_info(struct ath10k *ar,
 		   "wmi event pdev bss chan info:\n freq: %d noise: %d cycle: busy %llu total %llu tx %llu rx %llu rx_bss %llu\n",
 		   freq, noise_floor, busy, total, tx, rx, rx_bss);
 
+	spin_lock_bh(&ar->data_lock);
+	idx = freq_to_idx(ar, ev->freq);
+	if (idx >= ARRAY_SIZE(ar->survey)) {
+		ath10k_warn(ar, "bss chan info: invalid frequency %d (idx %d out of bounds)\n",
+			    ev->freq, idx);
+		goto exit;
+	}
+
+	survey = &ar->survey[idx];
+
+	survey->noise     = ev->noise_floor;
+	survey->time      = div_u64(total, cc_freq_hz);
+	survey->time_busy = div_u64(busy, cc_freq_hz);
+	survey->time_rx   = div_u64(rx_bss, cc_freq_hz);
+	survey->time_tx   = div_u64(tx, cc_freq_hz);
+	survey->filled   |= (SURVEY_INFO_NOISE_DBM |
+			     SURVEY_INFO_TIME |
+			     SURVEY_INFO_TIME_BUSY |
+			     SURVEY_INFO_TIME_RX |
+			     SURVEY_INFO_TIME_TX);
+exit:
+	spin_unlock_bh(&ar->data_lock);
+	complete(&ar->bss_survey_done);
 	return 0;
 }
 
@@ -5642,6 +5668,9 @@ static struct sk_buff *ath10k_wmi_10_2_op_gen_init(struct ath10k *ar)
 	if (ath10k_peer_stats_enabled(ar))
 		features |= WMI_10_2_PEER_STATS;
 
+	if (test_bit(WMI_SERVICE_BSS_CHANNEL_INFO_64, ar->wmi.svc_map))
+		features |= WMI_10_2_BSS_CHAN_INFO;
+
 	cmd->resource_config.feature_mask = __cpu_to_le32(features);
 
 	memcpy(&cmd->resource_config.common, &config, sizeof(config));
-- 
2.8.0

