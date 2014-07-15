Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from packetmixer.de ([79.140.42.25]:41933 "EHLO
	mail.mail.packetmixer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753884AbaGOQjX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Jul 2014 12:39:23 -0400
From: Simon Wunderlich <sw@simonwunderlich.de>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com,
	sven@narfation.org, mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <sw@simonwunderlich.de>
Subject: [RFC 2/2] ath10k: add spectral scan feature
Date: Tue, 15 Jul 2014 18:32:46 +0200
Message-Id: <1405441966-32681-3-git-send-email-sw@simonwunderlich.de> (sfid-20140715_183933_172183_A6D2FAC9)
In-Reply-To: <1405441966-32681-1-git-send-email-sw@simonwunderlich.de>
References: <1405441966-32681-1-git-send-email-sw@simonwunderlich.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sven Eckelmann <sven@narfation.org>

Adds the spectral scan feature for ath10k. The spectral scan is triggered by
configuring a mode through a debugfs control file. Samples can be gathered via
another relay debugfs file.

Essentially, to try it out:

ip link dev wlan0 set up
echo background > /sys/kernel/debug/ieee80211/phy0/ath10k/spectral_scan_ctl
iw dev wlan0 scan
echo disable > /sys/kernel/debug/ieee80211/phy0/ath10k/spectral_scan_ctl
cat /sys/kernel/debug/ieee80211/phy0/ath10k/spectral_scan0 > samples

This feature is still experimental.

Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
---
 drivers/net/wireless/ath/ath10k/Kconfig    |   1 +
 drivers/net/wireless/ath/ath10k/Makefile   |   3 +-
 drivers/net/wireless/ath/ath10k/core.h     |   6 +
 drivers/net/wireless/ath/ath10k/debug.c    |   3 +
 drivers/net/wireless/ath/ath10k/spectral.c | 368 +++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/spectral.h |  66 ++++++
 drivers/net/wireless/ath/ath10k/wmi.c      |  98 +++++++-
 drivers/net/wireless/ath/ath10k/wmi.h      |  80 +++++++
 drivers/net/wireless/ath/spectral_common.h |  20 ++
 9 files changed, 643 insertions(+), 2 deletions(-)
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
index a4179f4..2a1e9a3 100644
--- a/drivers/net/wireless/ath/ath10k/Makefile
+++ b/drivers/net/wireless/ath/ath10k/Makefile
@@ -8,7 +8,8 @@ ath10k_core-y += mac.o \
 		 htt_tx.o \
 		 txrx.o \
 		 wmi.o \
-		 bmi.o
+		 bmi.o \
+		 spectral.o
 
 ath10k_core-$(CONFIG_ATH10K_TRACING) += trace.o
 
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 83a5fa9..4af7f59 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -31,6 +31,7 @@
 #include "../ath.h"
 #include "../regd.h"
 #include "../dfs_pattern_detector.h"
+#include "spectral.h"
 
 #define MS(_v, _f) (((_v) & _f##_MASK) >> _f##_LSB)
 #define SM(_v, _f) (((_v) << _f##_LSB) & _f##_MASK)
@@ -494,6 +495,11 @@ struct ath10k {
 #ifdef CONFIG_ATH10K_DEBUGFS
 	struct ath10k_debug debug;
 #endif
+
+	/* relay(fs) channel for spectral scan */
+	struct rchan *rfs_chan_spec_scan;
+	enum spectral_mode spectral_mode;
+	struct ath_spec_scan spec_config;
 };
 
 struct ath10k *ath10k_core_create(void *hif_priv, struct device *dev,
diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 3030158..42cb448 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -957,12 +957,15 @@ int ath10k_debug_create(struct ath10k *ar)
 				    &fops_dfs_stats);
 	}
 
+	ath10k_spectral_init_debug(ar);
+
 	return 0;
 }
 
 void ath10k_debug_destroy(struct ath10k *ar)
 {
 	cancel_delayed_work_sync(&ar->debug.htt_stats_dwork);
+	ath10k_spectral_deinit_debug(ar);
 }
 
 #endif /* CONFIG_ATH10K_DEBUGFS */
diff --git a/drivers/net/wireless/ath/ath10k/spectral.c b/drivers/net/wireless/ath/ath10k/spectral.c
new file mode 100644
index 0000000..20f7037
--- /dev/null
+++ b/drivers/net/wireless/ath/ath10k/spectral.c
@@ -0,0 +1,368 @@
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
+
+static void ath_debug_send_fft_sample(struct ath10k *ar,
+				      struct fft_sample_tlv *fft_sample_tlv)
+{
+	int length;
+
+	if (!ar->rfs_chan_spec_scan)
+		return;
+
+	length = __be16_to_cpu(fft_sample_tlv->length) +
+		 sizeof(*fft_sample_tlv);
+	relay_write(ar->rfs_chan_spec_scan, fft_sample_tlv, length);
+}
+
+int ath10k_process_fft(struct ath10k *ar,
+		       struct wmi_single_phyerr_rx_event *event,
+		       struct phyerr_fft_report *fftr, size_t bin_len, u64 tsf)
+{
+	struct fft_sample_ath10k_ht20 fft_sample;
+	u32 reg0, reg1;
+	u16 peak_mag;
+	u8 *bins;
+	u16 freq1;
+	u16 freq2;
+	u16 total_gain_db;
+	u16 base_pwr_db;
+	u8 chain_idx;
+	u32 nf_list1;
+	u32 nf_list2;
+	u16 length;
+
+	if (bin_len != SPECTRAL_ATH10K_HT20_NUM_BINS)
+		return 0;
+
+	reg0 = __le32_to_cpu(fftr->reg0);
+	reg1 = __le32_to_cpu(fftr->reg1);
+
+	length = sizeof(fft_sample) - sizeof(struct fft_sample_tlv);
+	fft_sample.tlv.type = ATH_FFT_SAMPLE_ATH10K_HT20;
+	fft_sample.tlv.length = __cpu_to_be16(length);
+
+	fft_sample.mhz = event->hdr.chan_width_mhz;
+	fft_sample.relpwr_db = MS(reg1, SEARCH_FFT_REPORT_REG1_RELPWR_DB);
+	fft_sample.avgpwr_db = MS(reg1, SEARCH_FFT_REPORT_REG1_AVGPWR_DB);
+
+	peak_mag = MS(reg1, SEARCH_FFT_REPORT_REG1_PEAK_MAG);
+	fft_sample.max_magnitude = __cpu_to_be16(peak_mag);
+	fft_sample.max_index = MS(reg0, SEARCH_FFT_REPORT_REG0_PEAK_SIDX);
+	fft_sample.rssi = event->hdr.rssi_combined;
+
+	total_gain_db = MS(reg0, SEARCH_FFT_REPORT_REG0_TOTAL_GAIN_DB);
+	base_pwr_db = MS(reg0, SEARCH_FFT_REPORT_REG0_BASE_PWR_DB);
+	fft_sample.total_gain_db = __cpu_to_be16(total_gain_db);
+	fft_sample.base_pwr_db = __cpu_to_be16(base_pwr_db);
+
+	freq1 = __le16_to_cpu(event->hdr.freq1);
+	freq2 = __le16_to_cpu(event->hdr.freq2);
+	fft_sample.freq1 = __cpu_to_be16(freq1);
+	fft_sample.freq2 = __cpu_to_be16(freq2);
+
+	nf_list1 = __le32_to_cpu(event->hdr.nf_list_1);
+	nf_list2 = __le32_to_cpu(event->hdr.nf_list_2);
+	chain_idx = MS(reg0, SEARCH_FFT_REPORT_REG0_FFT_CHN_IDX);
+	switch (chain_idx) {
+	case 0:
+		fft_sample.noise = __cpu_to_be16(nf_list1 & 0xffffu);
+		break;
+	case 1:
+		fft_sample.noise = __cpu_to_be16((nf_list1 >> 16) & 0xffffu);
+		break;
+	case 2:
+		fft_sample.noise = __cpu_to_be16(nf_list2 & 0xffffu);
+		break;
+	case 3:
+		fft_sample.noise = __cpu_to_be16((nf_list2 >> 16) & 0xffffu);
+		break;
+	}
+
+	fft_sample.tsf = __cpu_to_be64(tsf);
+
+	bins = (u8 *)fftr;
+	bins += sizeof(*fftr);
+	memcpy(fft_sample.data, bins, SPECTRAL_ATH10K_HT20_NUM_BINS);
+
+	ath_debug_send_fft_sample(ar, &fft_sample.tlv);
+
+	return 1;
+}
+
+static int ath_get_spectral_vdevid(struct ath10k *ar)
+{
+	struct ath10k_vif *arvif;
+
+	if (list_empty(&ar->arvifs))
+		return -ENODEV;
+
+	arvif = list_first_entry(&ar->arvifs, typeof(*arvif), list);
+	return arvif->vdev_id;
+}
+
+int ath10k_spectral_scan_trigger(struct ath10k *ar)
+{
+	int ret;
+	int vdev_id;
+
+	vdev_id = ath_get_spectral_vdevid(ar);
+	if (vdev_id < 0)
+		return vdev_id;
+
+	if (ar->spectral_mode == SPECTRAL_DISABLED)
+		return 0;
+
+	ret = ath10k_vdev_spectral_enable(ar, vdev_id,
+					  WMI_SPECTRAL_TRIGGER_CMD_CLEAR,
+					  WMI_SPECTRAL_ENABLE_CMD_ENABLE);
+	if (ret < 0)
+		return ret;
+
+	ret = ath10k_vdev_spectral_enable(ar, vdev_id,
+					  WMI_SPECTRAL_TRIGGER_CMD_TRIGGER,
+					  WMI_SPECTRAL_ENABLE_CMD_ENABLE);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+int ath10k_spectral_scan_config(struct ath10k *ar, enum spectral_mode mode)
+{
+	int count, ret;
+	struct wmi_vdev_spectral_configure_arg arg;
+	int vdev_id;
+
+	vdev_id = ath_get_spectral_vdevid(ar);
+	if (vdev_id < 0)
+		return vdev_id;
+
+	ar->spectral_mode = mode;
+
+	ath10k_vdev_spectral_enable(ar, vdev_id,
+				    WMI_SPECTRAL_TRIGGER_CMD_CLEAR,
+				    WMI_SPECTRAL_ENABLE_CMD_DISABLE);
+	if (mode == SPECTRAL_DISABLED)
+		return 0;
+
+	if (mode == SPECTRAL_BACKGROUND)
+		count = WMI_SPECTRAL_COUNT_DEFAULT;
+	else
+		count = max_t(u8, 1, ar->spec_config.count);
+
+	arg.vdev_id              = vdev_id;
+	arg.scan_count           = count;
+	arg.scan_period          = WMI_SPECTRAL_PERIOD_DEFAULT;
+	arg.scan_priority        = WMI_SPECTRAL_PRIORITY_DEFAULT;
+	arg.scan_fft_size        = WMI_SPECTRAL_FFT_SIZE_DEFAULT;
+	arg.scan_gc_ena          = WMI_SPECTRAL_GC_ENA_DEFAULT;
+	arg.scan_restart_ena     = WMI_SPECTRAL_RESTART_ENA_DEFAULT;
+	arg.scan_noise_floor_ref = WMI_SPECTRAL_NOISE_FLOOR_REF_DEFAULT;
+	arg.scan_init_delay      = WMI_SPECTRAL_INIT_DELAY_DEFAULT;
+	arg.scan_nb_tone_thr     = WMI_SPECTRAL_NB_TONE_THR_DEFAULT;
+	arg.scan_str_bin_thr     = WMI_SPECTRAL_STR_BIN_THR_DEFAULT;
+	arg.scan_wb_rpt_mode     = WMI_SPECTRAL_WB_RPT_MODE_DEFAULT;
+	arg.scan_rssi_rpt_mode   = WMI_SPECTRAL_RSSI_RPT_MODE_DEFAULT;
+	arg.scan_rssi_thr        = WMI_SPECTRAL_RSSI_THR_DEFAULT;
+	arg.scan_pwr_format      = WMI_SPECTRAL_PWR_FORMAT_DEFAULT;
+	arg.scan_rpt_mode        = WMI_SPECTRAL_RPT_MODE_DEFAULT;
+	arg.scan_bin_scale       = WMI_SPECTRAL_BIN_SCALE_DEFAULT;
+	arg.scan_dBm_adj         = WMI_SPECTRAL_DBM_ADJ_DEFAULT;
+	arg.scan_chn_mask        = WMI_SPECTRAL_CHN_MASK_DEFAULT;
+
+	ret = ath10k_vdev_spectral_configure(ar, &arg);
+	if (ret < 0)
+		return ret;
+
+	if (mode == SPECTRAL_BACKGROUND)
+		ath10k_spectral_scan_trigger(ar);
+
+	return 0;
+}
+
+/*********************/
+/* spectral_scan_ctl */
+/*********************/
+
+static ssize_t read_file_spec_scan_ctl(struct file *file, char __user *user_buf,
+				       size_t count, loff_t *ppos)
+{
+	struct ath10k *ar = file->private_data;
+	char *mode = "";
+	unsigned int len;
+
+	switch (ar->spectral_mode) {
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
+
+	len = min(count, sizeof(buf) - 1);
+	if (copy_from_user(buf, user_buf, len))
+		return -EFAULT;
+
+	buf[len] = '\0';
+
+	if (strncmp("trigger", buf, 7) == 0) {
+		if (ar->spectral_mode == SPECTRAL_MANUAL)
+			ath10k_spectral_scan_trigger(ar);
+	} else if (strncmp("background", buf, 9) == 0) {
+		ath10k_spectral_scan_config(ar, SPECTRAL_BACKGROUND);
+	} else if (strncmp("manual", buf, 6) == 0) {
+		ath10k_spectral_scan_config(ar, SPECTRAL_MANUAL);
+	} else if (strncmp("disable", buf, 7) == 0) {
+		ath10k_spectral_scan_config(ar, SPECTRAL_DISABLED);
+	} else {
+		return -EINVAL;
+	}
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
+/******************/
+/* spectral_count */
+/******************/
+
+static ssize_t read_file_spectral_count(struct file *file,
+					char __user *user_buf,
+					size_t count, loff_t *ppos)
+{
+	struct ath10k *ar = file->private_data;
+	char buf[32];
+	unsigned int len;
+
+	len = sprintf(buf, "%d\n", ar->spec_config.count);
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
+	ar->spec_config.count = val;
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
+/*******************/
+/* Relay interface */
+/*******************/
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
+/*********************/
+/* Debug Init/Deinit */
+/*********************/
+
+void ath10k_spectral_deinit_debug(struct ath10k *ar)
+{
+	if (config_enabled(CONFIG_ATH10K_DEBUGFS) && ar->rfs_chan_spec_scan) {
+		relay_close(ar->rfs_chan_spec_scan);
+		ar->rfs_chan_spec_scan = NULL;
+	}
+}
+
+void ath10k_spectral_init_debug(struct ath10k *ar)
+{
+	ar->rfs_chan_spec_scan = relay_open("spectral_scan",
+					    ar->debug.debugfs_phy,
+					    1024, 256, &rfs_spec_scan_cb,
+					    NULL);
+	debugfs_create_file("spectral_scan_ctl",
+			    S_IRUSR | S_IWUSR,
+			    ar->debug.debugfs_phy, ar,
+			    &fops_spec_scan_ctl);
+	debugfs_create_file("spectral_count",
+			    S_IRUSR | S_IWUSR,
+			    ar->debug.debugfs_phy, ar,
+			    &fops_spectral_count);
+}
diff --git a/drivers/net/wireless/ath/ath10k/spectral.h b/drivers/net/wireless/ath/ath10k/spectral.h
new file mode 100644
index 0000000..288672e
--- /dev/null
+++ b/drivers/net/wireless/ath/ath10k/spectral.h
@@ -0,0 +1,66 @@
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
+ * struct ath_spec_scan - parameters for Atheros spectral scan
+ *
+ * @count: number of scan results requested for manual mode
+ */
+struct ath_spec_scan {
+	u8 count;
+};
+
+/* enum spectral_mode:
+ *
+ * @SPECTRAL_DISABLED: spectral mode is disabled
+ * @SPECTRAL_BACKGROUND: hardware sends samples when it is not busy with
+ *	something else.
+ * @SPECTRAL_MANUAL: spectral scan is enabled, triggering for samples
+ *	is performed manually.
+ */
+enum spectral_mode {
+	SPECTRAL_DISABLED = 0,
+	SPECTRAL_BACKGROUND,
+	SPECTRAL_MANUAL,
+};
+
+void ath10k_spectral_init_debug(struct ath10k *ar);
+void ath10k_spectral_deinit_debug(struct ath10k *ar);
+
+int ath10k_spectral_scan_trigger(struct ath10k *ar);
+int ath10k_spectral_scan_config(struct ath10k *ar,
+				enum spectral_mode spectral_mode);
+
+#ifdef CONFIG_ATH10K_DEBUGFS
+int ath10k_process_fft(struct ath10k *ar,
+		       struct wmi_single_phyerr_rx_event *event,
+		       struct phyerr_fft_report *fftr, size_t bin_len, u64 tsf);
+#else
+static inline int
+ath10k_process_fft(struct ath10k *ar,
+		   struct wmi_single_phyerr_rx_event *event,
+		   struct phyerr_fft_report *fftr, size_t bin_len, u64 tsf)
+{
+	return 0;
+}
+#endif /* CONFIG_ATH10K_DEBUGFS */
+
+#endif /* SPECTRAL_H */
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 6f83cae..7ad9c71 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -1659,7 +1659,47 @@ static void ath10k_wmi_event_spectral_scan(struct ath10k *ar,
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
+			ath10k_warn("too short buf for tlv header (%d)\n", i);
+			return;
+		}
+
+		tlv = (struct phyerr_tlv *)&event->bufp[i];
+		tlv_len = __le16_to_cpu(tlv->len);
+		tlv_buf = &event->bufp[i + sizeof(*tlv)];
+
+		if (i + sizeof(*tlv) + tlv_len > buf_len) {
+			ath10k_warn("too short buf for tlv (%d)\n", i);
+			return;
+		}
+
+		switch (tlv->tag) {
+		case PHYERR_TLV_TAG_SEARCH_FFT_REPORT:
+			if (sizeof(*fftr) > tlv_len) {
+				ath10k_warn("too short fft report (%d)\n", i);
+				return;
+			}
+
+			fftr_len = tlv_len - sizeof(*fftr);
+			fftr = (struct phyerr_fft_report *)tlv_buf;
+			res = ath10k_process_fft(ar, event, fftr, fftr_len,
+						 tsf);
+			if (res)
+				return;
+			break;
+		}
+
+		i += sizeof(*tlv) + tlv_len;
+	}
 }
 
 static void ath10k_wmi_event_phyerr(struct ath10k *ar, struct sk_buff *skb)
@@ -3236,6 +3276,62 @@ int ath10k_wmi_vdev_install_key(struct ath10k *ar,
 				   ar->wmi.cmd->vdev_install_key_cmdid);
 }
 
+int ath10k_vdev_spectral_configure(struct ath10k *ar,
+			      const struct wmi_vdev_spectral_configure_arg *arg)
+{
+	struct wmi_vdev_spectral_configure_cmd *cmd;
+	struct sk_buff *skb;
+	__le32 cmdid;
+
+	skb = ath10k_wmi_alloc_skb(sizeof(*cmd));
+	if (!skb)
+		return -ENOMEM;
+
+	cmd = (struct wmi_vdev_spectral_configure_cmd *)skb->data;
+	cmd->vdev_id              = __cpu_to_le32(arg->vdev_id);
+	cmd->scan_count           = __cpu_to_le32(arg->scan_count);
+	cmd->scan_period          = __cpu_to_le32(arg->scan_period);
+	cmd->scan_priority        = __cpu_to_le32(arg->scan_priority);
+	cmd->scan_fft_size        = __cpu_to_le32(arg->scan_fft_size);
+	cmd->scan_gc_ena          = __cpu_to_le32(arg->scan_gc_ena);
+	cmd->scan_restart_ena     = __cpu_to_le32(arg->scan_restart_ena);
+	cmd->scan_noise_floor_ref = __cpu_to_le32(arg->scan_noise_floor_ref);
+	cmd->scan_init_delay      = __cpu_to_le32(arg->scan_init_delay);
+	cmd->scan_nb_tone_thr     = __cpu_to_le32(arg->scan_nb_tone_thr);
+	cmd->scan_str_bin_thr     = __cpu_to_le32(arg->scan_str_bin_thr);
+	cmd->scan_wb_rpt_mode     = __cpu_to_le32(arg->scan_wb_rpt_mode);
+	cmd->scan_rssi_rpt_mode   = __cpu_to_le32(arg->scan_rssi_rpt_mode);
+	cmd->scan_rssi_thr        = __cpu_to_le32(arg->scan_rssi_thr);
+	cmd->scan_pwr_format      = __cpu_to_le32(arg->scan_pwr_format);
+	cmd->scan_rpt_mode        = __cpu_to_le32(arg->scan_rpt_mode);
+	cmd->scan_bin_scale       = __cpu_to_le32(arg->scan_bin_scale);
+	cmd->scan_dBm_adj         = __cpu_to_le32(arg->scan_dBm_adj);
+	cmd->scan_chn_mask        = __cpu_to_le32(arg->scan_chn_mask);
+
+	cmdid = ar->wmi.cmd->vdev_spectral_scan_configure_cmdid;
+	return ath10k_wmi_cmd_send(ar, skb, cmdid);
+}
+
+int ath10k_vdev_spectral_enable(struct ath10k *ar, u32 vdev_id, u32 trigger,
+				u32 enable)
+{
+	struct wmi_vdev_spectral_enable_cmd *cmd;
+	struct sk_buff *skb;
+	__le32 cmdid;
+
+	skb = ath10k_wmi_alloc_skb(sizeof(*cmd));
+	if (!skb)
+		return -ENOMEM;
+
+	cmd = (struct wmi_vdev_spectral_enable_cmd *)skb->data;
+	cmd->vdev_id     = __cpu_to_le32(vdev_id);
+	cmd->trigger_cmd = __cpu_to_le32(trigger);
+	cmd->enable_cmd  = __cpu_to_le32(enable);
+
+	cmdid = ar->wmi.cmd->vdev_spectral_scan_enable_cmdid;
+	return ath10k_wmi_cmd_send(ar, skb, cmdid);
+}
+
 int ath10k_wmi_peer_create(struct ath10k *ar, u32 vdev_id,
 			   const u8 peer_addr[ETH_ALEN])
 {
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index e93df2c..1020851 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -2067,6 +2067,7 @@ struct wmi_comb_phyerr_rx_event {
 #define PHYERR_TLV_SIG				0xBB
 #define PHYERR_TLV_TAG_SEARCH_FFT_REPORT	0xFB
 #define PHYERR_TLV_TAG_RADAR_PULSE_SUMMARY	0xF8
+#define PHYERR_TLV_TAG_SPECTRAL_SUMMARY_REPORT	0xF9
 
 struct phyerr_radar_report {
 	__le32 reg0; /* RADAR_REPORT_REG0_* */
@@ -3444,6 +3445,81 @@ struct wmi_vdev_simple_event {
 /* unsupported VDEV combination */
 #define WMI_INIFIED_VDEV_START_RESPONSE_NOT_SUPPORTED	0x2
 
+struct wmi_vdev_spectral_configure_cmd {
+	__le32 vdev_id;
+	__le32 scan_count;
+	__le32 scan_period;
+	__le32 scan_priority;
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
+	__le32 scan_rpt_mode;
+	__le32 scan_bin_scale;
+	__le32 scan_dBm_adj;
+	__le32 scan_chn_mask;
+} __packed;
+
+struct wmi_vdev_spectral_configure_arg {
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
+	u32 scan_dBm_adj;
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
@@ -4290,6 +4366,10 @@ int ath10k_wmi_vdev_set_param(struct ath10k *ar, u32 vdev_id,
 			      u32 param_id, u32 param_value);
 int ath10k_wmi_vdev_install_key(struct ath10k *ar,
 				const struct wmi_vdev_install_key_arg *arg);
+int ath10k_vdev_spectral_configure(struct ath10k *ar,
+			     const struct wmi_vdev_spectral_configure_arg *arg);
+int ath10k_vdev_spectral_enable(struct ath10k *ar, u32 vdev_id, u32 trigger,
+				u32 enable);
 int ath10k_wmi_peer_create(struct ath10k *ar, u32 vdev_id,
 		    const u8 peer_addr[ETH_ALEN]);
 int ath10k_wmi_peer_delete(struct ath10k *ar, u32 vdev_id,
diff --git a/drivers/net/wireless/ath/spectral_common.h b/drivers/net/wireless/ath/spectral_common.h
index b9ab722..fa01b9f 100644
--- a/drivers/net/wireless/ath/spectral_common.h
+++ b/drivers/net/wireless/ath/spectral_common.h
@@ -19,6 +19,7 @@
 
 #define SPECTRAL_HT20_NUM_BINS		56
 #define SPECTRAL_HT20_40_NUM_BINS		128
+#define SPECTRAL_ATH10K_HT20_NUM_BINS		64
 
 /* FFT sample format given to userspace via debugfs.
  *
@@ -31,6 +32,7 @@
 enum ath_fft_sample_type {
 	ATH_FFT_SAMPLE_HT20 = 1,
 	ATH_FFT_SAMPLE_HT20_40,
+	ATH_FFT_SAMPLE_ATH10K_HT20,
 };
 
 struct fft_sample_tlv {
@@ -85,4 +87,22 @@ struct fft_sample_ht20_40 {
 	u8 data[SPECTRAL_HT20_40_NUM_BINS];
 } __packed;
 
+struct fft_sample_ath10k_ht20 {
+	struct fft_sample_tlv tlv;
+	u8 mhz;
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
+
+	u8 data[SPECTRAL_ATH10K_HT20_NUM_BINS];
+} __packed;
+
 #endif /* SPECTRAL_COMMON_H */
-- 
1.9.1

