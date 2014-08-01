Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from packetmixer.de ([79.140.42.25]:50646 "EHLO
	mail.mail.packetmixer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932151AbaHANRv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Aug 2014 09:17:51 -0400
From: Simon Wunderlich <sw@simonwunderlich.de>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com,
	sven@narfation.org, mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCHv5 2/2] ath10k: add spectral scan feature
Date: Fri,  1 Aug 2014 15:17:14 +0200
Message-Id: <1406899034-13473-3-git-send-email-sw@simonwunderlich.de> (sfid-20140801_151757_298534_FC300F23)
In-Reply-To: <1406899034-13473-1-git-send-email-sw@simonwunderlich.de>
References: <1406899034-13473-1-git-send-email-sw@simonwunderlich.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Adds the spectral scan feature for ath10k. The spectral scan is triggered by
configuring a mode through a debugfs control file. Samples can be gathered via
another relay debugfs file.

Essentially, to try it out:

ip link set dev wlan0 up
echo background > /sys/kernel/debug/ieee80211/phy0/ath10k/spectral_scan_ctl
echo trigger > /sys/kernel/debug/ieee80211/phy0/ath10k/spectral_scan_ctl
iw dev wlan0 scan
echo disable > /sys/kernel/debug/ieee80211/phy0/ath10k/spectral_scan_ctl
cat /sys/kernel/debug/ieee80211/phy0/ath10k/spectral_scan0 > samples

This feature is still experimental. Based on the original RFC patch of
Sven Eckelmann.

Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>

---
PATCHv4:
 siwu: move parameter initialization into spectral_start() to reset
       parameters after firmware crash

PATCHv3:
 kvalo: CPTCFG_ -> CONFIG_, rework how spectral.c is initialised
---
 drivers/net/wireless/ath/ath10k/Kconfig    |   1 +
 drivers/net/wireless/ath/ath10k/Makefile   |   1 +
 drivers/net/wireless/ath/ath10k/core.c     |  10 +
 drivers/net/wireless/ath/ath10k/core.h     |  11 +
 drivers/net/wireless/ath/ath10k/mac.c      |   8 +
 drivers/net/wireless/ath/ath10k/spectral.c | 561 +++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/spectral.h |  90 +++++
 drivers/net/wireless/ath/ath10k/wmi.c      | 105 +++++-
 drivers/net/wireless/ath/ath10k/wmi.h      |  97 +++++
 drivers/net/wireless/ath/spectral_common.h |  25 ++
 10 files changed, 908 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/wireless/ath/ath10k/spectral.c
 create mode 100644 drivers/net/wireless/ath/ath10k/spectral.h

diff --git a/drivers/net/wireless/ath/ath10k/Kconfig b/drivers/net/wireless/ath/ath10k/Kconfig
index a6f5285..1053bb5 100644
--- a/drivers/net/wireless/ath/ath10k/Kconfig
+++ b/drivers/net/wireless/ath/ath10k/Kconfig
@@ -25,6 +25,7 @@ config ATH10K_DEBUG
 config ATH10K_DEBUGFS
 	bool "Atheros ath10k debugfs support"
 	depends on ATH10K
+	select RELAY
 	---help---
 	  Enabled debugfs support
 
diff --git a/drivers/net/wireless/ath/ath10k/Makefile b/drivers/net/wireless/ath/ath10k/Makefile
index a4179f4..2cfb63c 100644
--- a/drivers/net/wireless/ath/ath10k/Makefile
+++ b/drivers/net/wireless/ath/ath10k/Makefile
@@ -10,6 +10,7 @@ ath10k_core-y += mac.o \
 		 wmi.o \
 		 bmi.o
 
+ath10k_core-$(CONFIG_ATH10K_DEBUGFS) += spectral.o
 ath10k_core-$(CONFIG_ATH10K_TRACING) += trace.o
 
 obj-$(CONFIG_ATH10K_PCI) += ath10k_pci.o
diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index bef797d..440c3ff 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -1000,9 +1000,17 @@ static void ath10k_core_register_work(struct work_struct *work)
 		goto err_unregister_mac;
 	}
 
+	status = ath10k_spectral_create(ar);
+	if (status) {
+		ath10k_err("failed to initialize spectral\n");
+		goto err_debug_destroy;
+	}
+
 	set_bit(ATH10K_FLAG_CORE_REGISTERED, &ar->dev_flags);
 	return;
 
+err_debug_destroy:
+	ath10k_debug_destroy(ar);
 err_unregister_mac:
 	ath10k_mac_unregister(ar);
 err_release_fw:
@@ -1046,6 +1054,8 @@ void ath10k_core_unregister(struct ath10k *ar)
 
 	ath10k_core_free_firmware_files(ar);
 
+	ath10k_spectral_destroy(ar);
+
 	ath10k_debug_destroy(ar);
 }
 EXPORT_SYMBOL(ath10k_core_unregister);
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index ded3af2..d5c95d4 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -31,6 +31,7 @@
 #include "../ath.h"
 #include "../regd.h"
 #include "../dfs_pattern_detector.h"
+#include "spectral.h"
 
 #define MS(_v, _f) (((_v) & _f##_MASK) >> _f##_LSB)
 #define SM(_v, _f) (((_v) << _f##_LSB) & _f##_MASK)
@@ -237,6 +238,7 @@ struct ath10k_vif {
 
 	bool is_started;
 	bool is_up;
+	bool spectral_enabled;
 	u32 aid;
 	u8 bssid[ETH_ALEN];
 
@@ -499,6 +501,15 @@ struct ath10k {
 #ifdef CONFIG_ATH10K_DEBUGFS
 	struct ath10k_debug debug;
 #endif
+
+	struct {
+		/* relay(fs) channel for spectral scan */
+		struct rchan *rfs_chan_spec_scan;
+
+		/* spectral_mode and spec_config are protected by conf_mutex */
+		enum ath10k_spectral_mode mode;
+		struct ath10k_spec_scan config;
+	} spectral;
 };
 
 struct ath10k *ath10k_core_create(void *hif_priv, struct device *dev,
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 9d61bb1..d14f142 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -2485,6 +2485,8 @@ static int ath10k_start(struct ieee80211_hw *hw)
 	ar->num_started_vdevs = 0;
 	ath10k_regd_update(ar);
 
+	ath10k_spectral_start(ar);
+
 	mutex_unlock(&ar->conf_mutex);
 	return 0;
 
@@ -2892,8 +2894,14 @@ static void ath10k_remove_interface(struct ieee80211_hw *hw,
 		dev_kfree_skb_any(arvif->beacon);
 		arvif->beacon = NULL;
 	}
+
 	spin_unlock_bh(&ar->data_lock);
 
+	ret = ath10k_spectral_vif_stop(arvif);
+	if (ret)
+		ath10k_warn("failed to stop spectral for vdev %i: %d\n",
+			    arvif->vdev_id, ret);
+
 	ar->free_vdev_map |= 1 << (arvif->vdev_id);
 	list_del(&arvif->list);
 
diff --git a/drivers/net/wireless/ath/ath10k/spectral.c b/drivers/net/wireless/ath/ath10k/spectral.c
new file mode 100644
index 0000000..a53afc2
--- /dev/null
+++ b/drivers/net/wireless/ath/ath10k/spectral.c
@@ -0,0 +1,561 @@
+/*
+ * Copyright (c) 2013 Qualcomm Atheros, Inc.
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#include <linux/relay.h>
+#include "core.h"
+#include "debug.h"
+
+static void send_fft_sample(struct ath10k *ar,
+			    const struct fft_sample_tlv *fft_sample_tlv)
+{
+	int length;
+
+	if (!ar->spectral.rfs_chan_spec_scan)
+		return;
+
+	length = __be16_to_cpu(fft_sample_tlv->length) +
+		 sizeof(*fft_sample_tlv);
+	relay_write(ar->spectral.rfs_chan_spec_scan, fft_sample_tlv, length);
+}
+
+static uint8_t get_max_exp(s8 max_index, u16 max_magnitude, size_t bin_len,
+			   u8 *data)
+{
+	int dc_pos;
+	u8 max_exp;
+
+	dc_pos = bin_len / 2;
+
+	/* peak index outside of bins */
+	if (dc_pos < max_index || -dc_pos >= max_index)
+		return 0;
+
+	for (max_exp = 0; max_exp < 8; max_exp++) {
+		if (data[dc_pos + max_index] == (max_magnitude >> max_exp))
+			break;
+	}
+
+	/* max_exp not found */
+	if (data[dc_pos + max_index] != (max_magnitude >> max_exp))
+		return 0;
+
+	return max_exp;
+}
+
+int ath10k_spectral_process_fft(struct ath10k *ar,
+				struct wmi_single_phyerr_rx_event *event,
+				struct phyerr_fft_report *fftr,
+				size_t bin_len, u64 tsf)
+{
+	struct fft_sample_ath10k *fft_sample;
+	u8 buf[sizeof(*fft_sample) + SPECTRAL_ATH10K_MAX_NUM_BINS];
+	u16 freq1, freq2, total_gain_db, base_pwr_db, length, peak_mag;
+	u32 reg0, reg1, nf_list1, nf_list2;
+	u8 chain_idx, *bins;
+	int dc_pos;
+
+	fft_sample = (struct fft_sample_ath10k *)&buf;
+
+	if (bin_len < 64 || bin_len > SPECTRAL_ATH10K_MAX_NUM_BINS)
+		return -EINVAL;
+
+	reg0 = __le32_to_cpu(fftr->reg0);
+	reg1 = __le32_to_cpu(fftr->reg1);
+
+	length = sizeof(*fft_sample) - sizeof(struct fft_sample_tlv) + bin_len;
+	fft_sample->tlv.type = ATH_FFT_SAMPLE_ATH10K;
+	fft_sample->tlv.length = __cpu_to_be16(length);
+
+	/* TODO: there might be a reason why the hardware reports 20/40/80 MHz,
+	 * but the results/plots suggest that its actually 22/44/88 MHz.
+	 */
+	switch (event->hdr.chan_width_mhz) {
+	case 20:
+		fft_sample->chan_width_mhz = 22;
+		break;
+	case 40:
+		fft_sample->chan_width_mhz = 44;
+		break;
+	case 80:
+		/* TODO: As experiments with an analogue sender and various
+		 * configuaritions (fft-sizes of 64/128/256 and 20/40/80 Mhz)
+		 * show, the particular configuration of 80 MHz/64 bins does
+		 * not match with the other smaples at all. Until the reason
+		 * for that is found, don't report these samples.
+		 */
+		if (bin_len == 64)
+			return -EINVAL;
+		fft_sample->chan_width_mhz = 88;
+		break;
+	default:
+		fft_sample->chan_width_mhz = event->hdr.chan_width_mhz;
+	}
+
+	fft_sample->relpwr_db = MS(reg1, SEARCH_FFT_REPORT_REG1_RELPWR_DB);
+	fft_sample->avgpwr_db = MS(reg1, SEARCH_FFT_REPORT_REG1_AVGPWR_DB);
+
+	peak_mag = MS(reg1, SEARCH_FFT_REPORT_REG1_PEAK_MAG);
+	fft_sample->max_magnitude = __cpu_to_be16(peak_mag);
+	fft_sample->max_index = MS(reg0, SEARCH_FFT_REPORT_REG0_PEAK_SIDX);
+	fft_sample->rssi = event->hdr.rssi_combined;
+
+	total_gain_db = MS(reg0, SEARCH_FFT_REPORT_REG0_TOTAL_GAIN_DB);
+	base_pwr_db = MS(reg0, SEARCH_FFT_REPORT_REG0_BASE_PWR_DB);
+	fft_sample->total_gain_db = __cpu_to_be16(total_gain_db);
+	fft_sample->base_pwr_db = __cpu_to_be16(base_pwr_db);
+
+	freq1 = __le16_to_cpu(event->hdr.freq1);
+	freq2 = __le16_to_cpu(event->hdr.freq2);
+	fft_sample->freq1 = __cpu_to_be16(freq1);
+	fft_sample->freq2 = __cpu_to_be16(freq2);
+
+	nf_list1 = __le32_to_cpu(event->hdr.nf_list_1);
+	nf_list2 = __le32_to_cpu(event->hdr.nf_list_2);
+	chain_idx = MS(reg0, SEARCH_FFT_REPORT_REG0_FFT_CHN_IDX);
+
+	switch (chain_idx) {
+	case 0:
+		fft_sample->noise = __cpu_to_be16(nf_list1 & 0xffffu);
+		break;
+	case 1:
+		fft_sample->noise = __cpu_to_be16((nf_list1 >> 16) & 0xffffu);
+		break;
+	case 2:
+		fft_sample->noise = __cpu_to_be16(nf_list2 & 0xffffu);
+		break;
+	case 3:
+		fft_sample->noise = __cpu_to_be16((nf_list2 >> 16) & 0xffffu);
+		break;
+	}
+
+	bins = (u8 *)fftr;
+	bins += sizeof(*fftr);
+
+	fft_sample->tsf = __cpu_to_be64(tsf);
+
+	/* max_exp has been directly reported by previous hardware (ath9k),
+	 * maybe its possible to get it by other means?
+	 */
+	fft_sample->max_exp = get_max_exp(fft_sample->max_index, peak_mag,
+					  bin_len, bins);
+
+	memcpy(fft_sample->data, bins, bin_len);
+
+	/* DC value (value in the middle) is the blind spot of the spectral
+	 * sample and invalid, interpolate it.
+	 */
+	dc_pos = bin_len / 2;
+	fft_sample->data[dc_pos] = (fft_sample->data[dc_pos + 1] +
+				    fft_sample->data[dc_pos - 1]) / 2;
+
+	send_fft_sample(ar, &fft_sample->tlv);
+
+	return 0;
+}
+
+static struct ath10k_vif *ath10k_get_spectral_vdev(struct ath10k *ar)
+{
+	struct ath10k_vif *arvif;
+
+	lockdep_assert_held(&ar->conf_mutex);
+
+	if (list_empty(&ar->arvifs))
+		return NULL;
+
+	/* if there already is a vif doing spectral, return that. */
+	list_for_each_entry(arvif, &ar->arvifs, list)
+		if (arvif->spectral_enabled)
+			return arvif;
+
+	/* otherwise, return the first vif. */
+	return list_first_entry(&ar->arvifs, typeof(*arvif), list);
+}
+
+static int ath10k_spectral_scan_trigger(struct ath10k *ar)
+{
+	struct ath10k_vif *arvif;
+	int res;
+	int vdev_id;
+
+	lockdep_assert_held(&ar->conf_mutex);
+
+	arvif = ath10k_get_spectral_vdev(ar);
+	if (!arvif)
+		return -ENODEV;
+	vdev_id = arvif->vdev_id;
+
+	if (ar->spectral.mode == SPECTRAL_DISABLED)
+		return 0;
+
+	res = ath10k_wmi_vdev_spectral_enable(ar, vdev_id,
+					      WMI_SPECTRAL_TRIGGER_CMD_CLEAR,
+					      WMI_SPECTRAL_ENABLE_CMD_ENABLE);
+	if (res < 0)
+		return res;
+
+	res = ath10k_wmi_vdev_spectral_enable(ar, vdev_id,
+					      WMI_SPECTRAL_TRIGGER_CMD_TRIGGER,
+					      WMI_SPECTRAL_ENABLE_CMD_ENABLE);
+	if (res < 0)
+		return res;
+
+	return 0;
+}
+
+static int ath10k_spectral_scan_config(struct ath10k *ar,
+				       enum ath10k_spectral_mode mode)
+{
+	struct wmi_vdev_spectral_conf_arg arg;
+	struct ath10k_vif *arvif;
+	int vdev_id, count, res = 0;
+
+	lockdep_assert_held(&ar->conf_mutex);
+
+	arvif = ath10k_get_spectral_vdev(ar);
+	if (!arvif)
+		return -ENODEV;
+
+	vdev_id = arvif->vdev_id;
+
+	arvif->spectral_enabled = (mode != SPECTRAL_DISABLED);
+	ar->spectral.mode = mode;
+
+	res = ath10k_wmi_vdev_spectral_enable(ar, vdev_id,
+					      WMI_SPECTRAL_TRIGGER_CMD_CLEAR,
+					      WMI_SPECTRAL_ENABLE_CMD_DISABLE);
+	if (res < 0) {
+		ath10k_warn("failed to enable spectral scan: %d\n", res);
+		return res;
+	}
+
+	if (mode == SPECTRAL_DISABLED)
+		return 0;
+
+	if (mode == SPECTRAL_BACKGROUND)
+		count = WMI_SPECTRAL_COUNT_DEFAULT;
+	else
+		count = max_t(u8, 1, ar->spectral.config.count);
+
+	arg.vdev_id = vdev_id;
+	arg.scan_count = count;
+	arg.scan_period = WMI_SPECTRAL_PERIOD_DEFAULT;
+	arg.scan_priority = WMI_SPECTRAL_PRIORITY_DEFAULT;
+	arg.scan_fft_size = ar->spectral.config.fft_size;
+	arg.scan_gc_ena = WMI_SPECTRAL_GC_ENA_DEFAULT;
+	arg.scan_restart_ena = WMI_SPECTRAL_RESTART_ENA_DEFAULT;
+	arg.scan_noise_floor_ref = WMI_SPECTRAL_NOISE_FLOOR_REF_DEFAULT;
+	arg.scan_init_delay = WMI_SPECTRAL_INIT_DELAY_DEFAULT;
+	arg.scan_nb_tone_thr = WMI_SPECTRAL_NB_TONE_THR_DEFAULT;
+	arg.scan_str_bin_thr = WMI_SPECTRAL_STR_BIN_THR_DEFAULT;
+	arg.scan_wb_rpt_mode = WMI_SPECTRAL_WB_RPT_MODE_DEFAULT;
+	arg.scan_rssi_rpt_mode = WMI_SPECTRAL_RSSI_RPT_MODE_DEFAULT;
+	arg.scan_rssi_thr = WMI_SPECTRAL_RSSI_THR_DEFAULT;
+	arg.scan_pwr_format = WMI_SPECTRAL_PWR_FORMAT_DEFAULT;
+	arg.scan_rpt_mode = WMI_SPECTRAL_RPT_MODE_DEFAULT;
+	arg.scan_bin_scale = WMI_SPECTRAL_BIN_SCALE_DEFAULT;
+	arg.scan_dbm_adj = WMI_SPECTRAL_DBM_ADJ_DEFAULT;
+	arg.scan_chn_mask = WMI_SPECTRAL_CHN_MASK_DEFAULT;
+
+	res = ath10k_wmi_vdev_spectral_conf(ar, &arg);
+	if (res < 0) {
+		ath10k_warn("failed to configure spectral scan: %d\n", res);
+		return res;
+	}
+
+	return 0;
+}
+
+static ssize_t read_file_spec_scan_ctl(struct file *file, char __user *user_buf,
+				       size_t count, loff_t *ppos)
+{
+	struct ath10k *ar = file->private_data;
+	char *mode = "";
+	unsigned int len;
+	enum ath10k_spectral_mode spectral_mode;
+
+	mutex_lock(&ar->conf_mutex);
+	spectral_mode = ar->spectral.mode;
+	mutex_unlock(&ar->conf_mutex);
+
+	switch (spectral_mode) {
+	case SPECTRAL_DISABLED:
+		mode = "disable";
+		break;
+	case SPECTRAL_BACKGROUND:
+		mode = "background";
+		break;
+	case SPECTRAL_MANUAL:
+		mode = "manual";
+		break;
+	}
+
+	len = strlen(mode);
+	return simple_read_from_buffer(user_buf, count, ppos, mode, len);
+}
+
+static ssize_t write_file_spec_scan_ctl(struct file *file,
+					const char __user *user_buf,
+					size_t count, loff_t *ppos)
+{
+	struct ath10k *ar = file->private_data;
+	char buf[32];
+	ssize_t len;
+	int res;
+
+	len = min(count, sizeof(buf) - 1);
+	if (copy_from_user(buf, user_buf, len))
+		return -EFAULT;
+
+	buf[len] = '\0';
+
+	mutex_lock(&ar->conf_mutex);
+
+	if (strncmp("trigger", buf, 7) == 0) {
+		if (ar->spectral.mode == SPECTRAL_MANUAL ||
+		    ar->spectral.mode == SPECTRAL_BACKGROUND) {
+			/* reset the configuration to adopt possibly changed
+			 * debugfs parameters
+			 */
+			res = ath10k_spectral_scan_config(ar,
+							  ar->spectral.mode);
+			if (res < 0) {
+				ath10k_warn("failed to reconfigure spectral scan: %d\n",
+					    res);
+			}
+			res = ath10k_spectral_scan_trigger(ar);
+			if (res < 0) {
+				ath10k_warn("failed to trigger spectral scan: %d\n",
+					    res);
+			}
+		} else {
+			res = -EINVAL;
+		}
+	} else if (strncmp("background", buf, 9) == 0) {
+		res = ath10k_spectral_scan_config(ar, SPECTRAL_BACKGROUND);
+	} else if (strncmp("manual", buf, 6) == 0) {
+		res = ath10k_spectral_scan_config(ar, SPECTRAL_MANUAL);
+	} else if (strncmp("disable", buf, 7) == 0) {
+		res = ath10k_spectral_scan_config(ar, SPECTRAL_DISABLED);
+	} else {
+		res = -EINVAL;
+	}
+
+	mutex_unlock(&ar->conf_mutex);
+
+	if (res < 0)
+		return res;
+
+	return count;
+}
+
+static const struct file_operations fops_spec_scan_ctl = {
+	.read = read_file_spec_scan_ctl,
+	.write = write_file_spec_scan_ctl,
+	.open = simple_open,
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,
+};
+
+static ssize_t read_file_spectral_count(struct file *file,
+					char __user *user_buf,
+					size_t count, loff_t *ppos)
+{
+	struct ath10k *ar = file->private_data;
+	char buf[32];
+	unsigned int len;
+	u8 spectral_count;
+
+	mutex_lock(&ar->conf_mutex);
+	spectral_count = ar->spectral.config.count;
+	mutex_unlock(&ar->conf_mutex);
+
+	len = sprintf(buf, "%d\n", spectral_count);
+	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
+}
+
+static ssize_t write_file_spectral_count(struct file *file,
+					 const char __user *user_buf,
+					 size_t count, loff_t *ppos)
+{
+	struct ath10k *ar = file->private_data;
+	unsigned long val;
+	char buf[32];
+	ssize_t len;
+
+	len = min(count, sizeof(buf) - 1);
+	if (copy_from_user(buf, user_buf, len))
+		return -EFAULT;
+
+	buf[len] = '\0';
+	if (kstrtoul(buf, 0, &val))
+		return -EINVAL;
+
+	if (val < 0 || val > 255)
+		return -EINVAL;
+
+	mutex_lock(&ar->conf_mutex);
+	ar->spectral.config.count = val;
+	mutex_unlock(&ar->conf_mutex);
+
+	return count;
+}
+
+static const struct file_operations fops_spectral_count = {
+	.read = read_file_spectral_count,
+	.write = write_file_spectral_count,
+	.open = simple_open,
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,
+};
+
+static ssize_t read_file_spectral_bins(struct file *file,
+				       char __user *user_buf,
+				       size_t count, loff_t *ppos)
+{
+	struct ath10k *ar = file->private_data;
+	char buf[32];
+	unsigned int len, bins, fft_size, bin_scale;
+
+	mutex_lock(&ar->conf_mutex);
+
+	fft_size = ar->spectral.config.fft_size;
+	bin_scale = WMI_SPECTRAL_BIN_SCALE_DEFAULT;
+	bins = 1 << (fft_size - bin_scale);
+
+	mutex_unlock(&ar->conf_mutex);
+
+	len = sprintf(buf, "%d\n", bins);
+	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
+}
+
+static ssize_t write_file_spectral_bins(struct file *file,
+					const char __user *user_buf,
+					size_t count, loff_t *ppos)
+{
+	struct ath10k *ar = file->private_data;
+	unsigned long val;
+	char buf[32];
+	ssize_t len;
+
+	len = min(count, sizeof(buf) - 1);
+	if (copy_from_user(buf, user_buf, len))
+		return -EFAULT;
+
+	buf[len] = '\0';
+	if (kstrtoul(buf, 0, &val))
+		return -EINVAL;
+
+	if (val < 64 || val > SPECTRAL_ATH10K_MAX_NUM_BINS)
+		return -EINVAL;
+
+	if (!is_power_of_2(val))
+		return -EINVAL;
+
+	mutex_lock(&ar->conf_mutex);
+	ar->spectral.config.fft_size = ilog2(val);
+	ar->spectral.config.fft_size += WMI_SPECTRAL_BIN_SCALE_DEFAULT;
+	mutex_unlock(&ar->conf_mutex);
+
+	return count;
+}
+
+static const struct file_operations fops_spectral_bins = {
+	.read = read_file_spectral_bins,
+	.write = write_file_spectral_bins,
+	.open = simple_open,
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,
+};
+
+static struct dentry *create_buf_file_handler(const char *filename,
+					      struct dentry *parent,
+					      umode_t mode,
+					      struct rchan_buf *buf,
+					      int *is_global)
+{
+	struct dentry *buf_file;
+
+	buf_file = debugfs_create_file(filename, mode, parent, buf,
+				       &relay_file_operations);
+	*is_global = 1;
+	return buf_file;
+}
+
+static int remove_buf_file_handler(struct dentry *dentry)
+{
+	debugfs_remove(dentry);
+
+	return 0;
+}
+
+static struct rchan_callbacks rfs_spec_scan_cb = {
+	.create_buf_file = create_buf_file_handler,
+	.remove_buf_file = remove_buf_file_handler,
+};
+
+int ath10k_spectral_start(struct ath10k *ar)
+{
+	struct ath10k_vif *arvif;
+
+	lockdep_assert_held(&ar->conf_mutex);
+
+	list_for_each_entry(arvif, &ar->arvifs, list)
+		arvif->spectral_enabled = 0;
+
+	ar->spectral.mode = SPECTRAL_DISABLED;
+	ar->spectral.config.count = WMI_SPECTRAL_COUNT_DEFAULT;
+	ar->spectral.config.fft_size = WMI_SPECTRAL_FFT_SIZE_DEFAULT;
+
+	return 0;
+}
+
+int ath10k_spectral_vif_stop(struct ath10k_vif *arvif)
+{
+	if (!arvif->spectral_enabled)
+		return 0;
+
+	return ath10k_spectral_scan_config(arvif->ar, SPECTRAL_DISABLED);
+}
+
+int ath10k_spectral_create(struct ath10k *ar)
+{
+	ar->spectral.rfs_chan_spec_scan = relay_open("spectral_scan",
+						     ar->debug.debugfs_phy,
+						     1024, 256,
+						     &rfs_spec_scan_cb, NULL);
+	debugfs_create_file("spectral_scan_ctl",
+			    S_IRUSR | S_IWUSR,
+			    ar->debug.debugfs_phy, ar,
+			    &fops_spec_scan_ctl);
+	debugfs_create_file("spectral_count",
+			    S_IRUSR | S_IWUSR,
+			    ar->debug.debugfs_phy, ar,
+			    &fops_spectral_count);
+	debugfs_create_file("spectral_bins",
+			    S_IRUSR | S_IWUSR,
+			    ar->debug.debugfs_phy, ar,
+			    &fops_spectral_bins);
+
+	return 0;
+}
+
+void ath10k_spectral_destroy(struct ath10k *ar)
+{
+	if (ar->spectral.rfs_chan_spec_scan) {
+		relay_close(ar->spectral.rfs_chan_spec_scan);
+		ar->spectral.rfs_chan_spec_scan = NULL;
+	}
+}
diff --git a/drivers/net/wireless/ath/ath10k/spectral.h b/drivers/net/wireless/ath/ath10k/spectral.h
new file mode 100644
index 0000000..ddc57c5
--- /dev/null
+++ b/drivers/net/wireless/ath/ath10k/spectral.h
@@ -0,0 +1,90 @@
+/*
+ * Copyright (c) 2013 Qualcomm Atheros, Inc.
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#ifndef SPECTRAL_H
+#define SPECTRAL_H
+
+#include "../spectral_common.h"
+
+/**
+ * struct ath10k_spec_scan - parameters for Atheros spectral scan
+ *
+ * @count: number of scan results requested for manual mode
+ * @fft_size: number of bins to be requested = 2^(fft_size - bin_scale)
+ */
+struct ath10k_spec_scan {
+	u8 count;
+	u8 fft_size;
+};
+
+/* enum ath10k_spectral_mode:
+ *
+ * @SPECTRAL_DISABLED: spectral mode is disabled
+ * @SPECTRAL_BACKGROUND: hardware sends samples when it is not busy with
+ *	something else.
+ * @SPECTRAL_MANUAL: spectral scan is enabled, triggering for samples
+ *	is performed manually.
+ */
+enum ath10k_spectral_mode {
+	SPECTRAL_DISABLED = 0,
+	SPECTRAL_BACKGROUND,
+	SPECTRAL_MANUAL,
+};
+
+#ifdef CONFIG_ATH10K_DEBUGFS
+
+int ath10k_spectral_process_fft(struct ath10k *ar,
+				struct wmi_single_phyerr_rx_event *event,
+				struct phyerr_fft_report *fftr,
+				size_t bin_len, u64 tsf);
+int ath10k_spectral_start(struct ath10k *ar);
+int ath10k_spectral_vif_stop(struct ath10k_vif *arvif);
+int ath10k_spectral_create(struct ath10k *ar);
+void ath10k_spectral_destroy(struct ath10k *ar);
+
+#else
+
+static inline int
+ath10k_spectral_process_fft(struct ath10k *ar,
+			    struct wmi_single_phyerr_rx_event *event,
+			    struct phyerr_fft_report *fftr,
+			    size_t bin_len, u64 tsf)
+{
+	return 0;
+}
+
+static inline int ath10k_spectral_start(struct ath10k *ar)
+{
+	return 0;
+}
+
+static inline int ath10k_spectral_vif_stop(struct ath10k_vif *arvif)
+{
+	return 0;
+}
+
+static inline int ath10k_spectral_create(struct ath10k *ar)
+{
+	return 0;
+}
+
+static inline void ath10k_spectral_destroy(struct ath10k *ar)
+{
+}
+
+#endif /* CONFIG_ATH10K_DEBUGFS */
+
+#endif /* SPECTRAL_H */
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index b09661d..fffb15b 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -1780,7 +1780,54 @@ static void ath10k_wmi_event_spectral_scan(struct ath10k *ar,
 				struct wmi_single_phyerr_rx_event *event,
 				u64 tsf)
 {
-	ath10k_dbg(ATH10K_DBG_WMI, "wmi event spectral scan\n");
+	int buf_len, tlv_len, res, i = 0;
+	struct phyerr_tlv *tlv;
+	u8 *tlv_buf;
+	struct phyerr_fft_report *fftr;
+	size_t fftr_len;
+
+	buf_len = __le32_to_cpu(event->hdr.buf_len);
+
+	while (i < buf_len) {
+		if (i + sizeof(*tlv) > buf_len) {
+			ath10k_warn("failed to parse phyerr tlv header at byte %d\n",
+				    i);
+			return;
+		}
+
+		tlv = (struct phyerr_tlv *)&event->bufp[i];
+		tlv_len = __le16_to_cpu(tlv->len);
+		tlv_buf = &event->bufp[i + sizeof(*tlv)];
+
+		if (i + sizeof(*tlv) + tlv_len > buf_len) {
+			ath10k_warn("failed to parse phyerr tlv payload at byte %d\n",
+				    i);
+			return;
+		}
+
+		switch (tlv->tag) {
+		case PHYERR_TLV_TAG_SEARCH_FFT_REPORT:
+			if (sizeof(*fftr) > tlv_len) {
+				ath10k_warn("failed to parse fft report at byte %d\n",
+					    i);
+				return;
+			}
+
+			fftr_len = tlv_len - sizeof(*fftr);
+			fftr = (struct phyerr_fft_report *)tlv_buf;
+			res = ath10k_spectral_process_fft(ar, event,
+							  fftr, fftr_len,
+							  tsf);
+			if (res < 0) {
+				ath10k_warn("failed to process fft report: %d\n",
+					    res);
+				return;
+			}
+			break;
+		}
+
+		i += sizeof(*tlv) + tlv_len;
+	}
 }
 
 static void ath10k_wmi_event_phyerr(struct ath10k *ar, struct sk_buff *skb)
@@ -3576,6 +3623,62 @@ int ath10k_wmi_vdev_install_key(struct ath10k *ar,
 				   ar->wmi.cmd->vdev_install_key_cmdid);
 }
 
+int ath10k_wmi_vdev_spectral_conf(struct ath10k *ar,
+				  const struct wmi_vdev_spectral_conf_arg *arg)
+{
+	struct wmi_vdev_spectral_conf_cmd *cmd;
+	struct sk_buff *skb;
+	u32 cmdid;
+
+	skb = ath10k_wmi_alloc_skb(sizeof(*cmd));
+	if (!skb)
+		return -ENOMEM;
+
+	cmd = (struct wmi_vdev_spectral_conf_cmd *)skb->data;
+	cmd->vdev_id = __cpu_to_le32(arg->vdev_id);
+	cmd->scan_count = __cpu_to_le32(arg->scan_count);
+	cmd->scan_period = __cpu_to_le32(arg->scan_period);
+	cmd->scan_priority = __cpu_to_le32(arg->scan_priority);
+	cmd->scan_fft_size = __cpu_to_le32(arg->scan_fft_size);
+	cmd->scan_gc_ena = __cpu_to_le32(arg->scan_gc_ena);
+	cmd->scan_restart_ena = __cpu_to_le32(arg->scan_restart_ena);
+	cmd->scan_noise_floor_ref = __cpu_to_le32(arg->scan_noise_floor_ref);
+	cmd->scan_init_delay = __cpu_to_le32(arg->scan_init_delay);
+	cmd->scan_nb_tone_thr = __cpu_to_le32(arg->scan_nb_tone_thr);
+	cmd->scan_str_bin_thr = __cpu_to_le32(arg->scan_str_bin_thr);
+	cmd->scan_wb_rpt_mode = __cpu_to_le32(arg->scan_wb_rpt_mode);
+	cmd->scan_rssi_rpt_mode = __cpu_to_le32(arg->scan_rssi_rpt_mode);
+	cmd->scan_rssi_thr = __cpu_to_le32(arg->scan_rssi_thr);
+	cmd->scan_pwr_format = __cpu_to_le32(arg->scan_pwr_format);
+	cmd->scan_rpt_mode = __cpu_to_le32(arg->scan_rpt_mode);
+	cmd->scan_bin_scale = __cpu_to_le32(arg->scan_bin_scale);
+	cmd->scan_dbm_adj = __cpu_to_le32(arg->scan_dbm_adj);
+	cmd->scan_chn_mask = __cpu_to_le32(arg->scan_chn_mask);
+
+	cmdid = ar->wmi.cmd->vdev_spectral_scan_configure_cmdid;
+	return ath10k_wmi_cmd_send(ar, skb, cmdid);
+}
+
+int ath10k_wmi_vdev_spectral_enable(struct ath10k *ar, u32 vdev_id, u32 trigger,
+				    u32 enable)
+{
+	struct wmi_vdev_spectral_enable_cmd *cmd;
+	struct sk_buff *skb;
+	u32 cmdid;
+
+	skb = ath10k_wmi_alloc_skb(sizeof(*cmd));
+	if (!skb)
+		return -ENOMEM;
+
+	cmd = (struct wmi_vdev_spectral_enable_cmd *)skb->data;
+	cmd->vdev_id = __cpu_to_le32(vdev_id);
+	cmd->trigger_cmd = __cpu_to_le32(trigger);
+	cmd->enable_cmd = __cpu_to_le32(enable);
+
+	cmdid = ar->wmi.cmd->vdev_spectral_scan_enable_cmdid;
+	return ath10k_wmi_cmd_send(ar, skb, cmdid);
+}
+
 int ath10k_wmi_peer_create(struct ath10k *ar, u32 vdev_id,
 			   const u8 peer_addr[ETH_ALEN])
 {
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index c9ac11c..1d8dda3 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -2247,6 +2247,7 @@ struct wmi_comb_phyerr_rx_event {
 #define PHYERR_TLV_SIG				0xBB
 #define PHYERR_TLV_TAG_SEARCH_FFT_REPORT	0xFB
 #define PHYERR_TLV_TAG_RADAR_PULSE_SUMMARY	0xF8
+#define PHYERR_TLV_TAG_SPECTRAL_SUMMARY_REPORT	0xF9
 
 struct phyerr_radar_report {
 	__le32 reg0; /* RADAR_REPORT_REG0_* */
@@ -3645,6 +3646,98 @@ struct wmi_vdev_simple_event {
 /* unsupported VDEV combination */
 #define WMI_INIFIED_VDEV_START_RESPONSE_NOT_SUPPORTED	0x2
 
+/* TODO: please add more comments if you have in-depth information */
+struct wmi_vdev_spectral_conf_cmd {
+	__le32 vdev_id;
+
+	/* number of fft samples to send (0 for infinite) */
+	__le32 scan_count;
+	__le32 scan_period;
+	__le32 scan_priority;
+
+	/* number of bins in the FFT: 2^(fft_size - bin_scale) */
+	__le32 scan_fft_size;
+	__le32 scan_gc_ena;
+	__le32 scan_restart_ena;
+	__le32 scan_noise_floor_ref;
+	__le32 scan_init_delay;
+	__le32 scan_nb_tone_thr;
+	__le32 scan_str_bin_thr;
+	__le32 scan_wb_rpt_mode;
+	__le32 scan_rssi_rpt_mode;
+	__le32 scan_rssi_thr;
+	__le32 scan_pwr_format;
+
+	/* rpt_mode: Format of FFT report to software for spectral scan
+	 * triggered FFTs:
+	 *	0: No FFT report (only spectral scan summary report)
+	 *	1: 2-dword summary of metrics for each completed FFT + spectral
+	 *	   scan	summary report
+	 *	2: 2-dword summary of metrics for each completed FFT +
+	 *	   1x- oversampled bins(in-band) per FFT + spectral scan summary
+	 *	   report
+	 *	3: 2-dword summary of metrics for each completed FFT +
+	 *	   2x- oversampled bins	(all) per FFT + spectral scan summary
+	 */
+	__le32 scan_rpt_mode;
+	__le32 scan_bin_scale;
+	__le32 scan_dbm_adj;
+	__le32 scan_chn_mask;
+} __packed;
+
+struct wmi_vdev_spectral_conf_arg {
+	u32 vdev_id;
+	u32 scan_count;
+	u32 scan_period;
+	u32 scan_priority;
+	u32 scan_fft_size;
+	u32 scan_gc_ena;
+	u32 scan_restart_ena;
+	u32 scan_noise_floor_ref;
+	u32 scan_init_delay;
+	u32 scan_nb_tone_thr;
+	u32 scan_str_bin_thr;
+	u32 scan_wb_rpt_mode;
+	u32 scan_rssi_rpt_mode;
+	u32 scan_rssi_thr;
+	u32 scan_pwr_format;
+	u32 scan_rpt_mode;
+	u32 scan_bin_scale;
+	u32 scan_dbm_adj;
+	u32 scan_chn_mask;
+};
+
+#define WMI_SPECTRAL_ENABLE_DEFAULT              0
+#define WMI_SPECTRAL_COUNT_DEFAULT               0
+#define WMI_SPECTRAL_PERIOD_DEFAULT             35
+#define WMI_SPECTRAL_PRIORITY_DEFAULT            1
+#define WMI_SPECTRAL_FFT_SIZE_DEFAULT            7
+#define WMI_SPECTRAL_GC_ENA_DEFAULT              1
+#define WMI_SPECTRAL_RESTART_ENA_DEFAULT         0
+#define WMI_SPECTRAL_NOISE_FLOOR_REF_DEFAULT   -96
+#define WMI_SPECTRAL_INIT_DELAY_DEFAULT         80
+#define WMI_SPECTRAL_NB_TONE_THR_DEFAULT        12
+#define WMI_SPECTRAL_STR_BIN_THR_DEFAULT         8
+#define WMI_SPECTRAL_WB_RPT_MODE_DEFAULT         0
+#define WMI_SPECTRAL_RSSI_RPT_MODE_DEFAULT       0
+#define WMI_SPECTRAL_RSSI_THR_DEFAULT         0xf0
+#define WMI_SPECTRAL_PWR_FORMAT_DEFAULT          0
+#define WMI_SPECTRAL_RPT_MODE_DEFAULT            2
+#define WMI_SPECTRAL_BIN_SCALE_DEFAULT           1
+#define WMI_SPECTRAL_DBM_ADJ_DEFAULT             1
+#define WMI_SPECTRAL_CHN_MASK_DEFAULT            1
+
+struct wmi_vdev_spectral_enable_cmd {
+	__le32 vdev_id;
+	__le32 trigger_cmd;
+	__le32 enable_cmd;
+} __packed;
+
+#define WMI_SPECTRAL_TRIGGER_CMD_TRIGGER  1
+#define WMI_SPECTRAL_TRIGGER_CMD_CLEAR    2
+#define WMI_SPECTRAL_ENABLE_CMD_ENABLE    1
+#define WMI_SPECTRAL_ENABLE_CMD_DISABLE   2
+
 /* Beacon processing related command and event structures */
 struct wmi_bcn_tx_hdr {
 	__le32 vdev_id;
@@ -4517,6 +4610,10 @@ int ath10k_wmi_vdev_set_param(struct ath10k *ar, u32 vdev_id,
 			      u32 param_id, u32 param_value);
 int ath10k_wmi_vdev_install_key(struct ath10k *ar,
 				const struct wmi_vdev_install_key_arg *arg);
+int ath10k_wmi_vdev_spectral_conf(struct ath10k *ar,
+				  const struct wmi_vdev_spectral_conf_arg *arg);
+int ath10k_wmi_vdev_spectral_enable(struct ath10k *ar, u32 vdev_id, u32 trigger,
+				    u32 enable);
 int ath10k_wmi_peer_create(struct ath10k *ar, u32 vdev_id,
 		    const u8 peer_addr[ETH_ALEN]);
 int ath10k_wmi_peer_delete(struct ath10k *ar, u32 vdev_id,
diff --git a/drivers/net/wireless/ath/spectral_common.h b/drivers/net/wireless/ath/spectral_common.h
index b9ab722..0d742ac 100644
--- a/drivers/net/wireless/ath/spectral_common.h
+++ b/drivers/net/wireless/ath/spectral_common.h
@@ -20,6 +20,11 @@
 #define SPECTRAL_HT20_NUM_BINS		56
 #define SPECTRAL_HT20_40_NUM_BINS		128
 
+/* TODO: could possibly be 512, but no samples this large
+ * could be acquired so far.
+ */
+#define SPECTRAL_ATH10K_MAX_NUM_BINS		256
+
 /* FFT sample format given to userspace via debugfs.
  *
  * Please keep the type/length at the front position and change
@@ -31,6 +36,7 @@
 enum ath_fft_sample_type {
 	ATH_FFT_SAMPLE_HT20 = 1,
 	ATH_FFT_SAMPLE_HT20_40,
+	ATH_FFT_SAMPLE_ATH10K,
 };
 
 struct fft_sample_tlv {
@@ -85,4 +91,23 @@ struct fft_sample_ht20_40 {
 	u8 data[SPECTRAL_HT20_40_NUM_BINS];
 } __packed;
 
+struct fft_sample_ath10k {
+	struct fft_sample_tlv tlv;
+	u8 chan_width_mhz;
+	__be16 freq1;
+	__be16 freq2;
+	__be16 noise;
+	__be16 max_magnitude;
+	__be16 total_gain_db;
+	__be16 base_pwr_db;
+	__be64 tsf;
+	s8 max_index;
+	u8 rssi;
+	u8 relpwr_db;
+	u8 avgpwr_db;
+	u8 max_exp;
+
+	u8 data[0];
+} __packed;
+
 #endif /* SPECTRAL_COMMON_H */
-- 
1.9.1

