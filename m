Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f172.google.com ([209.85.215.172]:47683 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752197Ab3J2MGu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Oct 2013 08:06:50 -0400
Received: by mail-ea0-f172.google.com with SMTP id r16so2919792ead.3
        for <linux-wireless@vger.kernel.org>; Tue, 29 Oct 2013 05:06:49 -0700 (PDT)
From: Marek Puzyniak <marek.puzyniak@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH 1/3] ath10k: add phyerr/dfs handling
Date: Tue, 29 Oct 2013 13:06:32 +0100
Message-Id: <1383048394-15256-1-git-send-email-marek.puzyniak@tieto.com> (sfid-20131029_130655_545475_95102378)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Janusz Dziedzic <janusz.dziedzic@tieto.com>

Handle phyerr, dfs event, radar_report and fft_report.
Add also debugfs dfs_simulate_radar and dfs_stats files.
Use ath dfs pattern detector.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.h  |  13 ++
 drivers/net/wireless/ath/ath10k/debug.c |  87 ++++++++++++
 drivers/net/wireless/ath/ath10k/debug.h |   3 +
 drivers/net/wireless/ath/ath10k/mac.c   |  24 ++++
 drivers/net/wireless/ath/ath10k/wmi.c   | 244 +++++++++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath10k/wmi.h   |  85 +++++++++++
 6 files changed, 455 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 0934f76..671dbe3 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -30,6 +30,7 @@
 #include "wmi.h"
 #include "../ath.h"
 #include "../regd.h"
+#include "../dfs_pattern_detector.h"
 
 #define MS(_v, _f) (((_v) & _f##_MASK) >> _f##_LSB)
 #define SM(_v, _f) (((_v) << _f##_LSB) & _f##_MASK)
@@ -192,6 +193,14 @@ struct ath10k_target_stats {
 
 };
 
+struct ath10k_dfs_stats {
+	u32 phy_errors;
+	u32 pulses_total;
+	u32 pulses_detected;
+	u32 pulses_discarded;
+	u32 radar_detected;
+};
+
 #define ATH10K_MAX_NUM_PEER_IDS (1 << 11) /* htt rx_desc limit */
 
 struct ath10k_peer {
@@ -261,6 +270,8 @@ struct ath10k_debug {
 
 	unsigned long htt_stats_mask;
 	struct delayed_work htt_stats_dwork;
+	struct ath10k_dfs_stats dfs_stats;
+	struct ath_dfs_pool_stats dfs_pool_stats;
 };
 
 enum ath10k_state {
@@ -428,6 +439,8 @@ struct ath10k {
 	u32 survey_last_cycle_count;
 	struct survey_info survey[ATH10K_NUM_CHANS];
 
+	struct dfs_pattern_detector *dfs_detector;
+
 #ifdef CONFIG_ATH10K_DEBUGFS
 	struct ath10k_debug debug;
 #endif
diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 760ff22..d4d0cdd 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -21,6 +21,14 @@
 #include "core.h"
 #include "debug.h"
 
+#define ATH10K_DFS_STAT(s, p) (\
+	len += scnprintf(buf + len, size - len, "%28s : %10u\n", s, \
+			 ar->debug.dfs_stats.p))
+
+#define ATH10K_DFS_POOL_STAT(s, p) (\
+	len += scnprintf(buf + len, size - len, "%28s : %10u\n", s, \
+			 ar->debug.dfs_pool_stats.p))
+
 /* ms */
 #define ATH10K_DEBUG_HTT_STATS_INTERVAL 1000
 
@@ -639,6 +647,75 @@ void ath10k_debug_stop(struct ath10k *ar)
 		cancel_delayed_work(&ar->debug.htt_stats_dwork);
 }
 
+static ssize_t ath10k_write_simulate_radar(struct file *file,
+					   const char __user *user_buf,
+					   size_t count, loff_t *ppos)
+{
+	struct ath10k *ar = file->private_data;
+
+	ieee80211_radar_detected(ar->hw);
+
+	return count;
+}
+
+static const struct file_operations fops_simulate_radar = {
+	.write = ath10k_write_simulate_radar,
+	.open = simple_open,
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,
+};
+
+static ssize_t ath10k_read_file_dfs(struct file *file, char __user *user_buf,
+				    size_t count, loff_t *ppos)
+{
+	int retval = 0, size = 8000, len = 0;
+	struct ath10k *ar = file->private_data;
+	char *buf;
+
+	buf = kzalloc(size, GFP_KERNEL);
+	if (buf == NULL)
+		return -ENOMEM;
+
+	if (!ar->dfs_detector) {
+		len += scnprintf(buf + len, size - len, "DFS not enabled\n");
+		goto exit;
+	}
+
+	ar->debug.dfs_pool_stats = ar->dfs_detector->get_stats(ar->dfs_detector);
+
+	len += scnprintf(buf + len, size - len, "Pulse detector statistics:\n");
+	ATH10K_DFS_STAT("reported phy errors     ", phy_errors);
+	ATH10K_DFS_STAT("pulse events reported   ", pulses_total);
+	ATH10K_DFS_STAT("DFS pulses detected     ", pulses_detected);
+	ATH10K_DFS_STAT("DFS pulses discarded    ", pulses_discarded);
+	ATH10K_DFS_STAT("Radars detected         ", radar_detected);
+
+	len += scnprintf(buf + len, size - len, "Global Pool statistics:\n");
+	ATH10K_DFS_POOL_STAT("Pool references         ", pool_reference);
+	ATH10K_DFS_POOL_STAT("Pulses allocated        ", pulse_allocated);
+	ATH10K_DFS_POOL_STAT("Pulses alloc error      ", pulse_alloc_error);
+	ATH10K_DFS_POOL_STAT("Pulses in use           ", pulse_used);
+	ATH10K_DFS_POOL_STAT("Seqs. allocated         ", pseq_allocated);
+	ATH10K_DFS_POOL_STAT("Seqs. alloc error       ", pseq_alloc_error);
+	ATH10K_DFS_POOL_STAT("Seqs. in use            ", pseq_used);
+
+exit:
+	if (len > size)
+		len = size;
+
+	retval = simple_read_from_buffer(user_buf, count, ppos, buf, len);
+	kfree(buf);
+
+	return retval;
+}
+
+static const struct file_operations fops_dfs_stats = {
+	.read = ath10k_read_file_dfs,
+	.open = simple_open,
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,
+};
+
 int ath10k_debug_create(struct ath10k *ar)
 {
 	ar->debug.debugfs_phy = debugfs_create_dir("ath10k",
@@ -667,6 +744,16 @@ int ath10k_debug_create(struct ath10k *ar)
 	debugfs_create_file("htt_stats_mask", S_IRUSR, ar->debug.debugfs_phy,
 			    ar, &fops_htt_stats_mask);
 
+	if (config_enabled(CONFIG_ATH10K_DFS_CERTIFIED)) {
+		debugfs_create_file("dfs_simulate_radar", S_IWUSR,
+				    ar->debug.debugfs_phy, ar,
+				    &fops_simulate_radar);
+
+		debugfs_create_file("dfs_stats", S_IRUSR,
+				    ar->debug.debugfs_phy, ar,
+				    &fops_dfs_stats);
+	}
+
 	return 0;
 }
 
diff --git a/drivers/net/wireless/ath/ath10k/debug.h b/drivers/net/wireless/ath/ath10k/debug.h
index 46e640a..cde53d6 100644
--- a/drivers/net/wireless/ath/ath10k/debug.h
+++ b/drivers/net/wireless/ath/ath10k/debug.h
@@ -33,6 +33,7 @@ enum ath10k_debug_mask {
 	ATH10K_DBG_MGMT		= 0x00000100,
 	ATH10K_DBG_DATA		= 0x00000200,
 	ATH10K_DBG_BMI		= 0x00000400,
+	ATH10K_DBG_REGULATORY	= 0x00000800,
 	ATH10K_DBG_ANY		= 0xffffffff,
 };
 
@@ -53,6 +54,7 @@ void ath10k_debug_read_service_map(struct ath10k *ar,
 void ath10k_debug_read_target_stats(struct ath10k *ar,
 				    struct wmi_stats_event *ev);
 
+#define ATH10K_DFS_STAT_INC(ar, c) (ar->debug.dfs_stats.c++)
 #else
 static inline int ath10k_debug_start(struct ath10k *ar)
 {
@@ -82,6 +84,7 @@ static inline void ath10k_debug_read_target_stats(struct ath10k *ar,
 						  struct wmi_stats_event *ev)
 {
 }
+#define ATH10K_DFS_STAT_INC(ar, c) do { } while (0)
 #endif /* CONFIG_ATH10K_DEBUGFS */
 
 #ifdef CONFIG_ATH10K_DEBUG
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index bbb0efa..79f8bfd 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -1438,9 +1438,20 @@ static void ath10k_reg_notifier(struct wiphy *wiphy,
 {
 	struct ieee80211_hw *hw = wiphy_to_ieee80211_hw(wiphy);
 	struct ath10k *ar = hw->priv;
+	bool result;
 
 	ath_reg_notifier_apply(wiphy, request, &ar->ath_common.regulatory);
 
+	if (config_enabled(CONFIG_ATH10K_DFS_CERTIFIED) && ar->dfs_detector) {
+		ath10k_dbg(ATH10K_DBG_REGULATORY, "dfs region 0x%X\n",
+			   request->dfs_region);
+		result = ar->dfs_detector->set_dfs_domain(ar->dfs_detector,
+							  request->dfs_region);
+		if (!result)
+			ath10k_warn("dfs region 0x%X not supported, will trigger radar for every pulse\n",
+				    request->dfs_region);
+	}
+
 	mutex_lock(&ar->conf_mutex);
 	if (ar->state == ATH10K_STATE_ON)
 		ath10k_regd_update(ar);
@@ -3525,6 +3536,16 @@ int ath10k_mac_register(struct ath10k *ar)
 
 	ar->hw->netdev_features = NETIF_F_HW_CSUM;
 
+	if (config_enabled(CONFIG_ATH10K_DFS_CERTIFIED)) {
+		/* Init ath dfs pattern detector */
+		ar->ath_common.debug_mask = ATH_DBG_DFS;
+		ar->dfs_detector = dfs_pattern_detector_init(&ar->ath_common,
+							     NL80211_DFS_UNSET);
+
+		if (!ar->dfs_detector)
+			ath10k_warn("dfs pattern detector init failed\n");
+	}
+
 	ret = ath_regd_init(&ar->ath_common.regulatory, ar->hw->wiphy,
 			    ath10k_reg_notifier);
 	if (ret) {
@@ -3560,6 +3581,9 @@ void ath10k_mac_unregister(struct ath10k *ar)
 {
 	ieee80211_unregister_hw(ar->hw);
 
+	if (config_enabled(CONFIG_ATH10K_DFS_CERTIFIED) && ar->dfs_detector)
+		ar->dfs_detector->exit(ar->dfs_detector);
+
 	kfree(ar->mac.sbands[IEEE80211_BAND_2GHZ].channels);
 	kfree(ar->mac.sbands[IEEE80211_BAND_5GHZ].channels);
 
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index a796d0b..b7dcdce 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -1383,9 +1383,251 @@ static void ath10k_wmi_event_tbttoffset_update(struct ath10k *ar,
 	ath10k_dbg(ATH10K_DBG_WMI, "WMI_TBTTOFFSET_UPDATE_EVENTID\n");
 }
 
+static void ath10k_dfs_radar_report(struct ath10k *ar,
+				    struct wmi_single_phyerr_rx_event *event,
+				    struct phyerr_radar_report *rr,
+				    u64 tsf)
+{
+	u32 reg0, reg1, tsf32l;
+	struct pulse_event pe;
+	u64 tsf64;
+	u8 rssi, width;
+
+	reg0 = __le32_to_cpu(rr->reg0);
+	reg1 = __le32_to_cpu(rr->reg1);
+
+	ath10k_dbg(ATH10K_DBG_REGULATORY,
+		   "wmi phyerr radar report chirp %d max_width %d agc_total_gain %d pulse_delta_diff %d\n",
+		   MS(reg0, RADAR_REPORT_REG0_PULSE_IS_CHIRP),
+		   MS(reg0, RADAR_REPORT_REG0_PULSE_IS_MAX_WIDTH),
+		   MS(reg0, RADAR_REPORT_REG0_AGC_TOTAL_GAIN),
+		   MS(reg0, RADAR_REPORT_REG0_PULSE_DELTA_DIFF));
+	ath10k_dbg(ATH10K_DBG_REGULATORY,
+		   "wmi phyerr radar report pulse_delta_pean %d pulse_sidx %d fft_valid %d agc_mb_gain %d subchan_mask %d\n",
+		   MS(reg0, RADAR_REPORT_REG0_PULSE_DELTA_PEAK),
+		   MS(reg0, RADAR_REPORT_REG0_PULSE_SIDX),
+		   MS(reg1, RADAR_REPORT_REG1_PULSE_SRCH_FFT_VALID),
+		   MS(reg1, RADAR_REPORT_REG1_PULSE_AGC_MB_GAIN),
+		   MS(reg1, RADAR_REPORT_REG1_PULSE_SUBCHAN_MASK));
+	ath10k_dbg(ATH10K_DBG_REGULATORY,
+		   "wmi phyerr radar report pulse_tsf_offset 0x%X pulse_dur: %d\n",
+		   MS(reg1, RADAR_REPORT_REG1_PULSE_TSF_OFFSET),
+		   MS(reg1, RADAR_REPORT_REG1_PULSE_DUR));
+
+	if (!ar->dfs_detector)
+		return;
+
+	/* report event to DFS pattern detector */
+	tsf32l = __le32_to_cpu(event->hdr.tsf_timestamp);
+	tsf64 = tsf & (~0xFFFFFFFFULL);
+	tsf64 |= tsf32l;
+
+	width = MS(reg1, RADAR_REPORT_REG1_PULSE_DUR);
+	rssi = event->hdr.rssi_combined;
+
+	/*
+	 * hardware store this as 8 bit signed value,
+	 * set to zero if negative number
+	 */
+	if (rssi & 0x80)
+		rssi = 0;
+
+	pe.ts = tsf64;
+	pe.freq = ar->hw->conf.chandef.chan->center_freq;
+	pe.width = width;
+	pe.rssi = rssi;
+
+	ath10k_dbg(ATH10K_DBG_REGULATORY,
+		   "dfs add pulse freq: %d, width: %d, rssi %d, tsf: %llX\n",
+		   pe.freq, pe.width, pe.rssi, pe.ts);
+
+	ATH10K_DFS_STAT_INC(ar, pulses_detected);
+
+	if (!ar->dfs_detector->add_pulse(ar->dfs_detector, &pe)) {
+		ath10k_dbg(ATH10K_DBG_REGULATORY,
+			   "dfs no pulse pattern detected, yet\n");
+		return;
+	}
+
+	ath10k_dbg(ATH10K_DBG_REGULATORY, "dfs radar detected\n");
+	ATH10K_DFS_STAT_INC(ar, radar_detected);
+	ieee80211_radar_detected(ar->hw);
+}
+
+static int ath10k_dfs_fft_report(struct ath10k *ar,
+				 struct wmi_single_phyerr_rx_event *event,
+				 struct phyerr_fft_report *fftr,
+				 u64 tsf)
+{
+	u32 reg0, reg1;
+	u8 rssi, peak_mag;
+
+	reg0 = __le32_to_cpu(fftr->reg0);
+	reg1 = __le32_to_cpu(fftr->reg1);
+	rssi = event->hdr.rssi_combined;
+
+	ath10k_dbg(ATH10K_DBG_REGULATORY,
+		   "wmi phyerr fft report total_gain_db %d base_pwr_db %d fft_chn_idx %d peak_sidx %d\n",
+		   MS(reg0, SEARCH_FFT_REPORT_REG0_TOTAL_GAIN_DB),
+		   MS(reg0, SEARCH_FFT_REPORT_REG0_BASE_PWR_DB),
+		   MS(reg0, SEARCH_FFT_REPORT_REG0_FFT_CHN_IDX),
+		   MS(reg0, SEARCH_FFT_REPORT_REG0_PEAK_SIDX));
+	ath10k_dbg(ATH10K_DBG_REGULATORY,
+		   "wmi phyerr fft report rel_pwr_db %d avgpwr_db %d peak_mag %d num_store_bin %d\n",
+		   MS(reg1, SEARCH_FFT_REPORT_REG1_RELPWR_DB),
+		   MS(reg1, SEARCH_FFT_REPORT_REG1_AVGPWR_DB),
+		   MS(reg1, SEARCH_FFT_REPORT_REG1_PEAK_MAG),
+		   MS(reg1, SEARCH_FFT_REPORT_REG1_NUM_STR_BINS_IB));
+
+	peak_mag = MS(reg1, SEARCH_FFT_REPORT_REG1_PEAK_MAG);
+
+	/* false event detection */
+	if (rssi == DFS_RSSI_POSSIBLY_FALSE &&
+	    peak_mag < 2 * DFS_PEAK_MAG_THOLD_POSSIBLY_FALSE) {
+		ath10k_dbg(ATH10K_DBG_REGULATORY, "dfs false pulse detected\n");
+		ATH10K_DFS_STAT_INC(ar, pulses_discarded);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static void ath10k_wmi_event_dfs(struct ath10k *ar,
+				 struct wmi_single_phyerr_rx_event *event,
+				 u64 tsf)
+{
+	int buf_len, tlv_len, res, i = 0;
+	struct phyerr_tlv *tlv;
+	struct phyerr_radar_report *rr;
+	struct phyerr_fft_report *fftr;
+	u8 *tlv_buf;
+
+	buf_len = __le32_to_cpu(event->hdr.buf_len);
+	ath10k_dbg(ATH10K_DBG_REGULATORY,
+		   "wmi event dfs err_code %d rssi %d tsfl 0x%X tsf64 0x%llX len %d\n",
+		   event->hdr.phy_err_code, event->hdr.rssi_combined,
+		   __le32_to_cpu(event->hdr.tsf_timestamp), tsf, buf_len);
+
+	/* Skip event if DFS disabled */
+	if (!config_enabled(CONFIG_ATH10K_DFS_CERTIFIED))
+		return;
+
+	ATH10K_DFS_STAT_INC(ar, pulses_total);
+
+	while (i < buf_len) {
+		if (i + sizeof(*tlv) > buf_len) {
+			ath10k_warn("too short buf for tlv header (%d)\n", i);
+			return;
+		}
+
+		tlv = (struct phyerr_tlv *)&event->bufp[i];
+		tlv_len = __le16_to_cpu(tlv->len);
+		tlv_buf = &event->bufp[i + sizeof(*tlv)];
+		ath10k_dbg(ATH10K_DBG_REGULATORY,
+			   "wmi event dfs tlv_len %d tlv_tag 0x%02X tlv_sig 0x%02X\n",
+			   tlv_len, tlv->tag, tlv->sig);
+
+		switch (tlv->tag) {
+		case PHYERR_TLV_TAG_RADAR_PULSE_SUMMARY:
+			if (i + sizeof(*tlv) + sizeof(*rr) > buf_len) {
+				ath10k_warn("too short radar pulse summary (%d)\n", i);
+				return;
+			}
+
+			rr = (struct phyerr_radar_report *)tlv_buf;
+			ath10k_dfs_radar_report(ar, event, rr, tsf);
+			break;
+		case PHYERR_TLV_TAG_SEARCH_FFT_REPORT:
+			if (i + sizeof(*tlv) + sizeof(*fftr) > buf_len) {
+				ath10k_warn("too short fft report (%d)\n", i);
+				return;
+			}
+
+			fftr = (struct phyerr_fft_report *)tlv_buf;
+			res = ath10k_dfs_fft_report(ar, event, fftr, tsf);
+			if (res)
+				return;
+			break;
+		}
+
+		i += sizeof(*tlv) + tlv_len;
+	}
+}
+
+static void ath10k_wmi_event_spectral_scan(struct ath10k *ar,
+				struct wmi_single_phyerr_rx_event *event,
+				u64 tsf)
+{
+	ath10k_dbg(ATH10K_DBG_WMI, "wmi event spectral scan\n");
+}
+
 static void ath10k_wmi_event_phyerr(struct ath10k *ar, struct sk_buff *skb)
 {
-	ath10k_dbg(ATH10K_DBG_WMI, "WMI_PHYERR_EVENTID\n");
+	struct wmi_comb_phyerr_rx_event *comb_event;
+	struct wmi_single_phyerr_rx_event *event;
+	u32 count, i, buf_len, phy_err_code;
+	u64 tsf;
+	int left_len = skb->len;
+
+	ATH10K_DFS_STAT_INC(ar, phy_errors);
+
+	/* Check if combined event available */
+	if (left_len < sizeof(*comb_event)) {
+		ath10k_warn("wmi phyerr combined event wrong len\n");
+		return;
+	}
+
+	left_len -= sizeof(*comb_event);
+
+	/* Check number of included events */
+	comb_event = (struct wmi_comb_phyerr_rx_event *)skb->data;
+	count = __le32_to_cpu(comb_event->hdr.num_phyerr_events);
+
+	tsf = __le32_to_cpu(comb_event->hdr.tsf_u32);
+	tsf <<= 32;
+	tsf |= __le32_to_cpu(comb_event->hdr.tsf_l32);
+
+	ath10k_dbg(ATH10K_DBG_WMI,
+		   "wmi event phyerr count %d tsf64 0x%llX\n",
+		   count, tsf);
+
+	event = (struct wmi_single_phyerr_rx_event *)comb_event->bufp;
+	for (i = 0; i < count; i++) {
+		/* Check if we can read event header */
+		if (left_len < sizeof(*event)) {
+			ath10k_warn("single event (%d) wrong head len\n", i);
+			return;
+		}
+
+		left_len -= sizeof(*event);
+
+		buf_len = __le32_to_cpu(event->hdr.buf_len);
+		phy_err_code = event->hdr.phy_err_code;
+
+		if (left_len < buf_len) {
+			ath10k_warn("single event (%d) wrong buf len\n", i);
+			return;
+		}
+
+		left_len -= buf_len;
+
+		switch (phy_err_code) {
+		case PHY_ERROR_RADAR:
+			ath10k_wmi_event_dfs(ar, event, tsf);
+			break;
+		case PHY_ERROR_SPECTRAL_SCAN:
+			ath10k_wmi_event_spectral_scan(ar, event, tsf);
+			break;
+		case PHY_ERROR_FALSE_RADAR_EXT:
+			ath10k_wmi_event_dfs(ar, event, tsf);
+			ath10k_wmi_event_spectral_scan(ar, event, tsf);
+			break;
+		default:
+			break;
+		}
+
+		event += sizeof(*event) + buf_len;
+	}
 }
 
 static void ath10k_wmi_event_roam(struct ath10k *ar, struct sk_buff *skb)
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 81e33a7..ad53333 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -1978,6 +1978,10 @@ struct wmi_mgmt_rx_event_v2 {
 #define WMI_RX_STATUS_ERR_MIC			0x10
 #define WMI_RX_STATUS_ERR_KEY_CACHE_MISS	0x20
 
+#define PHY_ERROR_SPECTRAL_SCAN		0x26
+#define PHY_ERROR_FALSE_RADAR_EXT		0x24
+#define PHY_ERROR_RADAR				0x05
+
 struct wmi_single_phyerr_rx_hdr {
 	/* TSF timestamp */
 	__le32 tsf_timestamp;
@@ -2069,6 +2073,87 @@ struct wmi_comb_phyerr_rx_event {
 	u8 bufp[0];
 } __packed;
 
+#define PHYERR_TLV_SIG				0xBB
+#define PHYERR_TLV_TAG_SEARCH_FFT_REPORT	0xFB
+#define PHYERR_TLV_TAG_RADAR_PULSE_SUMMARY	0xF8
+
+struct phyerr_radar_report {
+	__le32 reg0; /* RADAR_REPORT_REG0_* */
+	__le32 reg1; /* REDAR_REPORT_REG1_* */
+} __packed;
+
+#define RADAR_REPORT_REG0_PULSE_IS_CHIRP_MASK		0x80000000
+#define RADAR_REPORT_REG0_PULSE_IS_CHIRP_LSB		31
+
+#define RADAR_REPORT_REG0_PULSE_IS_MAX_WIDTH_MASK	0x40000000
+#define RADAR_REPORT_REG0_PULSE_IS_MAX_WIDTH_LSB	30
+
+#define RADAR_REPORT_REG0_AGC_TOTAL_GAIN_MASK		0x3FF00000
+#define RADAR_REPORT_REG0_AGC_TOTAL_GAIN_LSB		20
+
+#define RADAR_REPORT_REG0_PULSE_DELTA_DIFF_MASK		0x000F0000
+#define RADAR_REPORT_REG0_PULSE_DELTA_DIFF_LSB		16
+
+#define RADAR_REPORT_REG0_PULSE_DELTA_PEAK_MASK		0x0000FC00
+#define RADAR_REPORT_REG0_PULSE_DELTA_PEAK_LSB		10
+
+#define RADAR_REPORT_REG0_PULSE_SIDX_MASK		0x000003FF
+#define RADAR_REPORT_REG0_PULSE_SIDX_LSB		0
+
+#define RADAR_REPORT_REG1_PULSE_SRCH_FFT_VALID_MASK	0x80000000
+#define RADAR_REPORT_REG1_PULSE_SRCH_FFT_VALID_LSB	31
+
+#define RADAR_REPORT_REG1_PULSE_AGC_MB_GAIN_MASK	0x7F000000
+#define RADAR_REPORT_REG1_PULSE_AGC_MB_GAIN_LSB		24
+
+#define RADAR_REPORT_REG1_PULSE_SUBCHAN_MASK_MASK	0x00FF0000
+#define RADAR_REPORT_REG1_PULSE_SUBCHAN_MASK_LSB	16
+
+#define RADAR_REPORT_REG1_PULSE_TSF_OFFSET_MASK		0x0000FF00
+#define RADAR_REPORT_REG1_PULSE_TSF_OFFSET_LSB		8
+
+#define RADAR_REPORT_REG1_PULSE_DUR_MASK		0x000000FF
+#define RADAR_REPORT_REG1_PULSE_DUR_LSB			0
+
+struct phyerr_fft_report {
+	__le32 reg0; /* SEARCH_FFT_REPORT_REG0_ * */
+	__le32 reg1; /* SEARCH_FFT_REPORT_REG1_ * */
+} __packed;
+
+#define SEARCH_FFT_REPORT_REG0_TOTAL_GAIN_DB_MASK	0xFF800000
+#define SEARCH_FFT_REPORT_REG0_TOTAL_GAIN_DB_LSB	23
+
+#define SEARCH_FFT_REPORT_REG0_BASE_PWR_DB_MASK		0x007FC000
+#define SEARCH_FFT_REPORT_REG0_BASE_PWR_DB_LSB		14
+
+#define SEARCH_FFT_REPORT_REG0_FFT_CHN_IDX_MASK		0x00003000
+#define SEARCH_FFT_REPORT_REG0_FFT_CHN_IDX_LSB		12
+
+#define SEARCH_FFT_REPORT_REG0_PEAK_SIDX_MASK		0x00000FFF
+#define SEARCH_FFT_REPORT_REG0_PEAK_SIDX_LSB		0
+
+#define SEARCH_FFT_REPORT_REG1_RELPWR_DB_MASK		0xFC000000
+#define SEARCH_FFT_REPORT_REG1_RELPWR_DB_LSB		26
+
+#define SEARCH_FFT_REPORT_REG1_AVGPWR_DB_MASK		0x03FC0000
+#define SEARCH_FFT_REPORT_REG1_AVGPWR_DB_LSB		18
+
+#define SEARCH_FFT_REPORT_REG1_PEAK_MAG_MASK		0x0003FF00
+#define SEARCH_FFT_REPORT_REG1_PEAK_MAG_LSB		8
+
+#define SEARCH_FFT_REPORT_REG1_NUM_STR_BINS_IB_MASK	0x000000FF
+#define SEARCH_FFT_REPORT_REG1_NUM_STR_BINS_IB_LSB	0
+
+
+struct phyerr_tlv {
+	__le16 len;
+	u8 tag;
+	u8 sig;
+} __packed;
+
+#define DFS_RSSI_POSSIBLY_FALSE			50
+#define DFS_PEAK_MAG_THOLD_POSSIBLY_FALSE	40
+
 struct wmi_mgmt_tx_hdr {
 	__le32 vdev_id;
 	struct wmi_mac_addr peer_macaddr;
-- 
1.8.1.2

