Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:52946 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751999AbaKFHzQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Nov 2014 02:55:16 -0500
From: Oleksij Rempel <linux@rempel-privat.de>
To: ath9k-devel@qca.qualcomm.com, sujith@msujith.org, nbd@openwrt.org,
	patro@cs.wisc.edu, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH 13/21] ath9k: move spectral.* to common-spectral.*
Date: Thu,  6 Nov 2014 08:53:30 +0100
Message-Id: <1415260418-14321-14-git-send-email-linux@rempel-privat.de> (sfid-20141106_085529_389683_6A55E349)
In-Reply-To: <1415260418-14321-1-git-send-email-linux@rempel-privat.de>
References: <1415260418-14321-1-git-send-email-linux@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

and rename exports from ath9k_spectral_* to ath9k_cmn_spectral_*

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
---
 drivers/net/wireless/ath/ath9k/Makefile          |   6 +-
 drivers/net/wireless/ath/ath9k/ath9k.h           |   1 -
 drivers/net/wireless/ath/ath9k/channel.c         |   2 +-
 drivers/net/wireless/ath/ath9k/common-spectral.c | 620 +++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/common-spectral.h | 154 ++++++
 drivers/net/wireless/ath/ath9k/common.h          |   1 +
 drivers/net/wireless/ath/ath9k/debug.c           |   4 +-
 drivers/net/wireless/ath/ath9k/recv.c            |   2 +-
 drivers/net/wireless/ath/ath9k/spectral.c        | 614 ----------------------
 drivers/net/wireless/ath/ath9k/spectral.h        | 154 ------
 10 files changed, 782 insertions(+), 776 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath9k/common-spectral.c
 create mode 100644 drivers/net/wireless/ath/ath9k/common-spectral.h
 delete mode 100644 drivers/net/wireless/ath/ath9k/spectral.c
 delete mode 100644 drivers/net/wireless/ath/ath9k/spectral.h

diff --git a/drivers/net/wireless/ath/ath9k/Makefile b/drivers/net/wireless/ath/ath9k/Makefile
index 22b934b..4739722 100644
--- a/drivers/net/wireless/ath/ath9k/Makefile
+++ b/drivers/net/wireless/ath/ath9k/Makefile
@@ -16,8 +16,7 @@ ath9k-$(CONFIG_ATH9K_DFS_CERTIFIED) += dfs.o
 ath9k-$(CONFIG_ATH9K_TX99) += tx99.o
 ath9k-$(CONFIG_ATH9K_WOW) += wow.o
 
-ath9k-$(CONFIG_ATH9K_DEBUGFS) += debug.o \
-				 spectral.o
+ath9k-$(CONFIG_ATH9K_DEBUGFS) += debug.o
 
 ath9k-$(CONFIG_ATH9K_STATION_STATISTICS) += debug_sta.o
 
@@ -59,7 +58,8 @@ obj-$(CONFIG_ATH9K_COMMON) += ath9k_common.o
 ath9k_common-y:=	common.o \
 			common-init.o \
 			common-beacon.o \
-			common-debug.o
+			common-debug.o \
+			common-spectral.o
 
 ath9k_htc-y +=	htc_hst.o \
 		hif_usb.o \
diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index a0fa3e6..0844980 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -28,7 +28,6 @@
 #include "debug.h"
 #include "mci.h"
 #include "dfs.h"
-#include "spectral.h"
 
 struct ath_node;
 struct ath_vif;
diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index 32ce931..1dadf6d 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -93,7 +93,7 @@ static int ath_set_channel(struct ath_softc *sc)
 		/* perform spectral scan if requested. */
 		if (test_bit(ATH_OP_SCANNING, &common->op_flags) &&
 			sc->spec_priv.spectral_mode == SPECTRAL_CHANSCAN)
-			ath9k_spectral_scan_trigger(common, &sc->spec_priv);
+			ath9k_cmn_spectral_scan_trigger(common, &sc->spec_priv);
 	}
 
 	return 0;
diff --git a/drivers/net/wireless/ath/ath9k/common-spectral.c b/drivers/net/wireless/ath/ath9k/common-spectral.c
new file mode 100644
index 0000000..ec93ddf
--- /dev/null
+++ b/drivers/net/wireless/ath/ath9k/common-spectral.c
@@ -0,0 +1,620 @@
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
+#include "ath9k.h"
+
+static s8 fix_rssi_inv_only(u8 rssi_val)
+{
+	if (rssi_val == 128)
+		rssi_val = 0;
+	return (s8) rssi_val;
+}
+
+static void ath_debug_send_fft_sample(struct ath_spec_scan_priv *spec_priv,
+				      struct fft_sample_tlv *fft_sample_tlv)
+{
+	int length;
+	if (!spec_priv->rfs_chan_spec_scan)
+		return;
+
+	length = __be16_to_cpu(fft_sample_tlv->length) +
+		 sizeof(*fft_sample_tlv);
+	relay_write(spec_priv->rfs_chan_spec_scan, fft_sample_tlv, length);
+}
+
+/* returns 1 if this was a spectral frame, even if not handled. */
+int ath_cmn_process_fft(struct ath_spec_scan_priv *spec_priv, struct ieee80211_hdr *hdr,
+		    struct ath_rx_status *rs, u64 tsf)
+{
+	struct ath_hw *ah = spec_priv->ah;
+	struct ath_common *common = ath9k_hw_common(spec_priv->ah);
+	u8 num_bins, *bins, *vdata = (u8 *)hdr;
+	struct fft_sample_ht20 fft_sample_20;
+	struct fft_sample_ht20_40 fft_sample_40;
+	struct fft_sample_tlv *tlv;
+	struct ath_radar_info *radar_info;
+	int len = rs->rs_datalen;
+	int dc_pos;
+	u16 fft_len, length, freq = ah->curchan->chan->center_freq;
+	enum nl80211_channel_type chan_type;
+
+	/* AR9280 and before report via ATH9K_PHYERR_RADAR, AR93xx and newer
+	 * via ATH9K_PHYERR_SPECTRAL. Haven't seen ATH9K_PHYERR_FALSE_RADAR_EXT
+	 * yet, but this is supposed to be possible as well.
+	 */
+	if (rs->rs_phyerr != ATH9K_PHYERR_RADAR &&
+	    rs->rs_phyerr != ATH9K_PHYERR_FALSE_RADAR_EXT &&
+	    rs->rs_phyerr != ATH9K_PHYERR_SPECTRAL)
+		return 0;
+
+	/* check if spectral scan bit is set. This does not have to be checked
+	 * if received through a SPECTRAL phy error, but shouldn't hurt.
+	 */
+	radar_info = ((struct ath_radar_info *)&vdata[len]) - 1;
+	if (!(radar_info->pulse_bw_info & SPECTRAL_SCAN_BITMASK))
+		return 0;
+
+	chan_type = cfg80211_get_chandef_type(&common->hw->conf.chandef);
+	if ((chan_type == NL80211_CHAN_HT40MINUS) ||
+	    (chan_type == NL80211_CHAN_HT40PLUS)) {
+		fft_len = SPECTRAL_HT20_40_TOTAL_DATA_LEN;
+		num_bins = SPECTRAL_HT20_40_NUM_BINS;
+		bins = (u8 *)fft_sample_40.data;
+	} else {
+		fft_len = SPECTRAL_HT20_TOTAL_DATA_LEN;
+		num_bins = SPECTRAL_HT20_NUM_BINS;
+		bins = (u8 *)fft_sample_20.data;
+	}
+
+	/* Variation in the data length is possible and will be fixed later */
+	if ((len > fft_len + 2) || (len < fft_len - 1))
+		return 1;
+
+	switch (len - fft_len) {
+	case 0:
+		/* length correct, nothing to do. */
+		memcpy(bins, vdata, num_bins);
+		break;
+	case -1:
+		/* first byte missing, duplicate it. */
+		memcpy(&bins[1], vdata, num_bins - 1);
+		bins[0] = vdata[0];
+		break;
+	case 2:
+		/* MAC added 2 extra bytes at bin 30 and 32, remove them. */
+		memcpy(bins, vdata, 30);
+		bins[30] = vdata[31];
+		memcpy(&bins[31], &vdata[33], num_bins - 31);
+		break;
+	case 1:
+		/* MAC added 2 extra bytes AND first byte is missing. */
+		bins[0] = vdata[0];
+		memcpy(&bins[1], vdata, 30);
+		bins[31] = vdata[31];
+		memcpy(&bins[32], &vdata[33], num_bins - 32);
+		break;
+	default:
+		return 1;
+	}
+
+	/* DC value (value in the middle) is the blind spot of the spectral
+	 * sample and invalid, interpolate it.
+	 */
+	dc_pos = num_bins / 2;
+	bins[dc_pos] = (bins[dc_pos + 1] + bins[dc_pos - 1]) / 2;
+
+	if ((chan_type == NL80211_CHAN_HT40MINUS) ||
+	    (chan_type == NL80211_CHAN_HT40PLUS)) {
+		s8 lower_rssi, upper_rssi;
+		s16 ext_nf;
+		u8 lower_max_index, upper_max_index;
+		u8 lower_bitmap_w, upper_bitmap_w;
+		u16 lower_mag, upper_mag;
+		struct ath9k_hw_cal_data *caldata = ah->caldata;
+		struct ath_ht20_40_mag_info *mag_info;
+
+		if (caldata)
+			ext_nf = ath9k_hw_getchan_noise(ah, ah->curchan,
+					caldata->nfCalHist[3].privNF);
+		else
+			ext_nf = ATH_DEFAULT_NOISE_FLOOR;
+
+		length = sizeof(fft_sample_40) - sizeof(struct fft_sample_tlv);
+		fft_sample_40.tlv.type = ATH_FFT_SAMPLE_HT20_40;
+		fft_sample_40.tlv.length = __cpu_to_be16(length);
+		fft_sample_40.freq = __cpu_to_be16(freq);
+		fft_sample_40.channel_type = chan_type;
+
+		if (chan_type == NL80211_CHAN_HT40PLUS) {
+			lower_rssi = fix_rssi_inv_only(rs->rs_rssi_ctl[0]);
+			upper_rssi = fix_rssi_inv_only(rs->rs_rssi_ext[0]);
+
+			fft_sample_40.lower_noise = ah->noise;
+			fft_sample_40.upper_noise = ext_nf;
+		} else {
+			lower_rssi = fix_rssi_inv_only(rs->rs_rssi_ext[0]);
+			upper_rssi = fix_rssi_inv_only(rs->rs_rssi_ctl[0]);
+
+			fft_sample_40.lower_noise = ext_nf;
+			fft_sample_40.upper_noise = ah->noise;
+		}
+		fft_sample_40.lower_rssi = lower_rssi;
+		fft_sample_40.upper_rssi = upper_rssi;
+
+		mag_info = ((struct ath_ht20_40_mag_info *)radar_info) - 1;
+		lower_mag = spectral_max_magnitude(mag_info->lower_bins);
+		upper_mag = spectral_max_magnitude(mag_info->upper_bins);
+		fft_sample_40.lower_max_magnitude = __cpu_to_be16(lower_mag);
+		fft_sample_40.upper_max_magnitude = __cpu_to_be16(upper_mag);
+		lower_max_index = spectral_max_index(mag_info->lower_bins);
+		upper_max_index = spectral_max_index(mag_info->upper_bins);
+		fft_sample_40.lower_max_index = lower_max_index;
+		fft_sample_40.upper_max_index = upper_max_index;
+		lower_bitmap_w = spectral_bitmap_weight(mag_info->lower_bins);
+		upper_bitmap_w = spectral_bitmap_weight(mag_info->upper_bins);
+		fft_sample_40.lower_bitmap_weight = lower_bitmap_w;
+		fft_sample_40.upper_bitmap_weight = upper_bitmap_w;
+		fft_sample_40.max_exp = mag_info->max_exp & 0xf;
+
+		fft_sample_40.tsf = __cpu_to_be64(tsf);
+
+		tlv = (struct fft_sample_tlv *)&fft_sample_40;
+	} else {
+		u8 max_index, bitmap_w;
+		u16 magnitude;
+		struct ath_ht20_mag_info *mag_info;
+
+		length = sizeof(fft_sample_20) - sizeof(struct fft_sample_tlv);
+		fft_sample_20.tlv.type = ATH_FFT_SAMPLE_HT20;
+		fft_sample_20.tlv.length = __cpu_to_be16(length);
+		fft_sample_20.freq = __cpu_to_be16(freq);
+
+		fft_sample_20.rssi = fix_rssi_inv_only(rs->rs_rssi_ctl[0]);
+		fft_sample_20.noise = ah->noise;
+
+		mag_info = ((struct ath_ht20_mag_info *)radar_info) - 1;
+		magnitude = spectral_max_magnitude(mag_info->all_bins);
+		fft_sample_20.max_magnitude = __cpu_to_be16(magnitude);
+		max_index = spectral_max_index(mag_info->all_bins);
+		fft_sample_20.max_index = max_index;
+		bitmap_w = spectral_bitmap_weight(mag_info->all_bins);
+		fft_sample_20.bitmap_weight = bitmap_w;
+		fft_sample_20.max_exp = mag_info->max_exp & 0xf;
+
+		fft_sample_20.tsf = __cpu_to_be64(tsf);
+
+		tlv = (struct fft_sample_tlv *)&fft_sample_20;
+	}
+
+	ath_debug_send_fft_sample(spec_priv, tlv);
+
+	return 1;
+}
+EXPORT_SYMBOL(ath_cmn_process_fft);
+
+/*********************/
+/* spectral_scan_ctl */
+/*********************/
+
+static ssize_t read_file_spec_scan_ctl(struct file *file, char __user *user_buf,
+				       size_t count, loff_t *ppos)
+{
+	struct ath_spec_scan_priv *spec_priv = file->private_data;
+	char *mode = "";
+	unsigned int len;
+
+	switch (spec_priv->spectral_mode) {
+	case SPECTRAL_DISABLED:
+		mode = "disable";
+		break;
+	case SPECTRAL_BACKGROUND:
+		mode = "background";
+		break;
+	case SPECTRAL_CHANSCAN:
+		mode = "chanscan";
+		break;
+	case SPECTRAL_MANUAL:
+		mode = "manual";
+		break;
+	}
+	len = strlen(mode);
+	return simple_read_from_buffer(user_buf, count, ppos, mode, len);
+}
+
+void ath9k_cmn_spectral_scan_trigger(struct ath_common *common,
+				 struct ath_spec_scan_priv *spec_priv)
+{
+	struct ath_hw *ah = spec_priv->ah;
+	u32 rxfilter;
+
+	if (config_enabled(CONFIG_ATH9K_TX99))
+		return;
+
+	if (!ath9k_hw_ops(ah)->spectral_scan_trigger) {
+		ath_err(common, "spectrum analyzer not implemented on this hardware\n");
+		return;
+	}
+
+	ath_ps_ops(common)->wakeup(common);
+	rxfilter = ath9k_hw_getrxfilter(ah);
+	ath9k_hw_setrxfilter(ah, rxfilter |
+				 ATH9K_RX_FILTER_PHYRADAR |
+				 ATH9K_RX_FILTER_PHYERR);
+
+	/* TODO: usually this should not be neccesary, but for some reason
+	 * (or in some mode?) the trigger must be called after the
+	 * configuration, otherwise the register will have its values reset
+	 * (on my ar9220 to value 0x01002310)
+	 */
+	ath9k_cmn_spectral_scan_config(common, spec_priv, spec_priv->spectral_mode);
+	ath9k_hw_ops(ah)->spectral_scan_trigger(ah);
+	ath_ps_ops(common)->restore(common);
+}
+EXPORT_SYMBOL(ath9k_cmn_spectral_scan_trigger);
+
+int ath9k_cmn_spectral_scan_config(struct ath_common *common,
+			       struct ath_spec_scan_priv *spec_priv,
+			       enum spectral_mode spectral_mode)
+{
+	struct ath_hw *ah = spec_priv->ah;
+
+	if (!ath9k_hw_ops(ah)->spectral_scan_trigger) {
+		ath_err(common, "spectrum analyzer not implemented on this hardware\n");
+		return -1;
+	}
+
+	switch (spectral_mode) {
+	case SPECTRAL_DISABLED:
+		spec_priv->spec_config.enabled = 0;
+		break;
+	case SPECTRAL_BACKGROUND:
+		/* send endless samples.
+		 * TODO: is this really useful for "background"?
+		 */
+		spec_priv->spec_config.endless = 1;
+		spec_priv->spec_config.enabled = 1;
+		break;
+	case SPECTRAL_CHANSCAN:
+	case SPECTRAL_MANUAL:
+		spec_priv->spec_config.endless = 0;
+		spec_priv->spec_config.enabled = 1;
+		break;
+	default:
+		return -1;
+	}
+
+	ath_ps_ops(common)->wakeup(common);
+	ath9k_hw_ops(ah)->spectral_scan_config(ah, &spec_priv->spec_config);
+	ath_ps_ops(common)->restore(common);
+
+	spec_priv->spectral_mode = spectral_mode;
+
+	return 0;
+}
+EXPORT_SYMBOL(ath9k_cmn_spectral_scan_config);
+
+static ssize_t write_file_spec_scan_ctl(struct file *file,
+					const char __user *user_buf,
+					size_t count, loff_t *ppos)
+{
+	struct ath_spec_scan_priv *spec_priv = file->private_data;
+	struct ath_common *common = ath9k_hw_common(spec_priv->ah);
+	char buf[32];
+	ssize_t len;
+
+	if (config_enabled(CONFIG_ATH9K_TX99))
+		return -EOPNOTSUPP;
+
+	len = min(count, sizeof(buf) - 1);
+	if (copy_from_user(buf, user_buf, len))
+		return -EFAULT;
+
+	buf[len] = '\0';
+
+	if (strncmp("trigger", buf, 7) == 0) {
+		ath9k_cmn_spectral_scan_trigger(common, spec_priv);
+	} else if (strncmp("background", buf, 10) == 0) {
+		ath9k_cmn_spectral_scan_config(common, spec_priv, SPECTRAL_BACKGROUND);
+		ath_dbg(common, CONFIG, "spectral scan: background mode enabled\n");
+	} else if (strncmp("chanscan", buf, 8) == 0) {
+		ath9k_cmn_spectral_scan_config(common, spec_priv, SPECTRAL_CHANSCAN);
+		ath_dbg(common, CONFIG, "spectral scan: channel scan mode enabled\n");
+	} else if (strncmp("manual", buf, 6) == 0) {
+		ath9k_cmn_spectral_scan_config(common, spec_priv, SPECTRAL_MANUAL);
+		ath_dbg(common, CONFIG, "spectral scan: manual mode enabled\n");
+	} else if (strncmp("disable", buf, 7) == 0) {
+		ath9k_cmn_spectral_scan_config(common, spec_priv, SPECTRAL_DISABLED);
+		ath_dbg(common, CONFIG, "spectral scan: disabled\n");
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
+/*************************/
+/* spectral_short_repeat */
+/*************************/
+
+static ssize_t read_file_spectral_short_repeat(struct file *file,
+					       char __user *user_buf,
+					       size_t count, loff_t *ppos)
+{
+	struct ath_spec_scan_priv *spec_priv = file->private_data;
+	char buf[32];
+	unsigned int len;
+
+	len = sprintf(buf, "%d\n", spec_priv->spec_config.short_repeat);
+	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
+}
+
+static ssize_t write_file_spectral_short_repeat(struct file *file,
+						const char __user *user_buf,
+						size_t count, loff_t *ppos)
+{
+	struct ath_spec_scan_priv *spec_priv = file->private_data;
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
+	if (val > 1)
+		return -EINVAL;
+
+	spec_priv->spec_config.short_repeat = val;
+	return count;
+}
+
+static const struct file_operations fops_spectral_short_repeat = {
+	.read = read_file_spectral_short_repeat,
+	.write = write_file_spectral_short_repeat,
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
+	struct ath_spec_scan_priv *spec_priv = file->private_data;
+	char buf[32];
+	unsigned int len;
+
+	len = sprintf(buf, "%d\n", spec_priv->spec_config.count);
+	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
+}
+
+static ssize_t write_file_spectral_count(struct file *file,
+					 const char __user *user_buf,
+					 size_t count, loff_t *ppos)
+{
+	struct ath_spec_scan_priv *spec_priv = file->private_data;
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
+	if (val > 255)
+		return -EINVAL;
+
+	spec_priv->spec_config.count = val;
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
+/* spectral_period */
+/*******************/
+
+static ssize_t read_file_spectral_period(struct file *file,
+					 char __user *user_buf,
+					 size_t count, loff_t *ppos)
+{
+	struct ath_spec_scan_priv *spec_priv = file->private_data;
+	char buf[32];
+	unsigned int len;
+
+	len = sprintf(buf, "%d\n", spec_priv->spec_config.period);
+	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
+}
+
+static ssize_t write_file_spectral_period(struct file *file,
+					  const char __user *user_buf,
+					  size_t count, loff_t *ppos)
+{
+	struct ath_spec_scan_priv *spec_priv = file->private_data;
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
+	if (val > 255)
+		return -EINVAL;
+
+	spec_priv->spec_config.period = val;
+	return count;
+}
+
+static const struct file_operations fops_spectral_period = {
+	.read = read_file_spectral_period,
+	.write = write_file_spectral_period,
+	.open = simple_open,
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,
+};
+
+/***********************/
+/* spectral_fft_period */
+/***********************/
+
+static ssize_t read_file_spectral_fft_period(struct file *file,
+					     char __user *user_buf,
+					     size_t count, loff_t *ppos)
+{
+	struct ath_spec_scan_priv *spec_priv = file->private_data;
+	char buf[32];
+	unsigned int len;
+
+	len = sprintf(buf, "%d\n", spec_priv->spec_config.fft_period);
+	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
+}
+
+static ssize_t write_file_spectral_fft_period(struct file *file,
+					      const char __user *user_buf,
+					      size_t count, loff_t *ppos)
+{
+	struct ath_spec_scan_priv *spec_priv = file->private_data;
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
+	if (val > 15)
+		return -EINVAL;
+
+	spec_priv->spec_config.fft_period = val;
+	return count;
+}
+
+static const struct file_operations fops_spectral_fft_period = {
+	.read = read_file_spectral_fft_period,
+	.write = write_file_spectral_fft_period,
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
+void ath9k_cmn_spectral_deinit_debug(struct ath_spec_scan_priv *spec_priv)
+{
+	if (config_enabled(CONFIG_ATH9K_DEBUGFS) && spec_priv->rfs_chan_spec_scan) {
+		relay_close(spec_priv->rfs_chan_spec_scan);
+		spec_priv->rfs_chan_spec_scan = NULL;
+	}
+}
+EXPORT_SYMBOL(ath9k_cmn_spectral_deinit_debug);
+
+void ath9k_cmn_spectral_init_debug(struct ath_spec_scan_priv *spec_priv,
+				   struct dentry *debugfs_phy)
+{
+	spec_priv->rfs_chan_spec_scan = relay_open("spectral_scan",
+					    debugfs_phy,
+					    1024, 256, &rfs_spec_scan_cb,
+					    NULL);
+	debugfs_create_file("spectral_scan_ctl",
+			    S_IRUSR | S_IWUSR,
+			    debugfs_phy, spec_priv,
+			    &fops_spec_scan_ctl);
+	debugfs_create_file("spectral_short_repeat",
+			    S_IRUSR | S_IWUSR,
+			    debugfs_phy, spec_priv,
+			    &fops_spectral_short_repeat);
+	debugfs_create_file("spectral_count",
+			    S_IRUSR | S_IWUSR,
+			    debugfs_phy, spec_priv,
+			    &fops_spectral_count);
+	debugfs_create_file("spectral_period",
+			    S_IRUSR | S_IWUSR,
+			    debugfs_phy, spec_priv,
+			    &fops_spectral_period);
+	debugfs_create_file("spectral_fft_period",
+			    S_IRUSR | S_IWUSR,
+			    debugfs_phy, spec_priv,
+			    &fops_spectral_fft_period);
+}
+EXPORT_SYMBOL(ath9k_cmn_spectral_init_debug);
diff --git a/drivers/net/wireless/ath/ath9k/common-spectral.h b/drivers/net/wireless/ath/ath9k/common-spectral.h
new file mode 100644
index 0000000..214c3ba
--- /dev/null
+++ b/drivers/net/wireless/ath/ath9k/common-spectral.h
@@ -0,0 +1,154 @@
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
+/* enum spectral_mode:
+ *
+ * @SPECTRAL_DISABLED: spectral mode is disabled
+ * @SPECTRAL_BACKGROUND: hardware sends samples when it is not busy with
+ *	something else.
+ * @SPECTRAL_MANUAL: spectral scan is enabled, triggering for samples
+ *	is performed manually.
+ * @SPECTRAL_CHANSCAN: Like manual, but also triggered when changing channels
+ *	during a channel scan.
+ */
+enum spectral_mode {
+	SPECTRAL_DISABLED = 0,
+	SPECTRAL_BACKGROUND,
+	SPECTRAL_MANUAL,
+	SPECTRAL_CHANSCAN,
+};
+
+#define SPECTRAL_SCAN_BITMASK		0x10
+/* Radar info packet format, used for DFS and spectral formats. */
+struct ath_radar_info {
+	u8 pulse_length_pri;
+	u8 pulse_length_ext;
+	u8 pulse_bw_info;
+} __packed;
+
+/* The HT20 spectral data has 4 bytes of additional information at it's end.
+ *
+ * [7:0]: all bins {max_magnitude[1:0], bitmap_weight[5:0]}
+ * [7:0]: all bins  max_magnitude[9:2]
+ * [7:0]: all bins {max_index[5:0], max_magnitude[11:10]}
+ * [3:0]: max_exp (shift amount to size max bin to 8-bit unsigned)
+ */
+struct ath_ht20_mag_info {
+	u8 all_bins[3];
+	u8 max_exp;
+} __packed;
+
+/* WARNING: don't actually use this struct! MAC may vary the amount of
+ * data by -1/+2. This struct is for reference only.
+ */
+struct ath_ht20_fft_packet {
+	u8 data[SPECTRAL_HT20_NUM_BINS];
+	struct ath_ht20_mag_info mag_info;
+	struct ath_radar_info radar_info;
+} __packed;
+
+#define SPECTRAL_HT20_TOTAL_DATA_LEN	(sizeof(struct ath_ht20_fft_packet))
+
+/* Dynamic 20/40 mode:
+ *
+ * [7:0]: lower bins {max_magnitude[1:0], bitmap_weight[5:0]}
+ * [7:0]: lower bins  max_magnitude[9:2]
+ * [7:0]: lower bins {max_index[5:0], max_magnitude[11:10]}
+ * [7:0]: upper bins {max_magnitude[1:0], bitmap_weight[5:0]}
+ * [7:0]: upper bins  max_magnitude[9:2]
+ * [7:0]: upper bins {max_index[5:0], max_magnitude[11:10]}
+ * [3:0]: max_exp (shift amount to size max bin to 8-bit unsigned)
+ */
+struct ath_ht20_40_mag_info {
+	u8 lower_bins[3];
+	u8 upper_bins[3];
+	u8 max_exp;
+} __packed;
+
+/* WARNING: don't actually use this struct! MAC may vary the amount of
+ * data. This struct is for reference only.
+ */
+struct ath_ht20_40_fft_packet {
+	u8 data[SPECTRAL_HT20_40_NUM_BINS];
+	struct ath_ht20_40_mag_info mag_info;
+	struct ath_radar_info radar_info;
+} __packed;
+
+struct ath_spec_scan_priv {
+	struct ath_hw *ah;
+	/* relay(fs) channel for spectral scan */
+	struct rchan *rfs_chan_spec_scan;
+	enum spectral_mode spectral_mode;
+	struct ath_spec_scan spec_config;
+};
+
+#define SPECTRAL_HT20_40_TOTAL_DATA_LEN	(sizeof(struct ath_ht20_40_fft_packet))
+
+/* grabs the max magnitude from the all/upper/lower bins */
+static inline u16 spectral_max_magnitude(u8 *bins)
+{
+	return (bins[0] & 0xc0) >> 6 |
+	       (bins[1] & 0xff) << 2 |
+	       (bins[2] & 0x03) << 10;
+}
+
+/* return the max magnitude from the all/upper/lower bins */
+static inline u8 spectral_max_index(u8 *bins)
+{
+	s8 m = (bins[2] & 0xfc) >> 2;
+
+	/* TODO: this still doesn't always report the right values ... */
+	if (m > 32)
+		m |= 0xe0;
+	else
+		m &= ~0xe0;
+
+	return m + 29;
+}
+
+/* return the bitmap weight from the all/upper/lower bins */
+static inline u8 spectral_bitmap_weight(u8 *bins)
+{
+	return bins[0] & 0x3f;
+}
+
+void ath9k_cmn_spectral_init_debug(struct ath_spec_scan_priv *spec_priv, struct dentry *debugfs_phy);
+void ath9k_cmn_spectral_deinit_debug(struct ath_spec_scan_priv *spec_priv);
+
+void ath9k_cmn_spectral_scan_trigger(struct ath_common *common,
+				 struct ath_spec_scan_priv *spec_priv);
+int ath9k_cmn_spectral_scan_config(struct ath_common *common,
+			       struct ath_spec_scan_priv *spec_priv,
+			       enum spectral_mode spectral_mode);
+
+#ifdef CONFIG_ATH9K_DEBUGFS
+int ath_cmn_process_fft(struct ath_spec_scan_priv *spec_priv, struct ieee80211_hdr *hdr,
+		    struct ath_rx_status *rs, u64 tsf);
+#else
+static inline int ath_cmn_process_fft(struct ath_spec_scan_priv *spec_priv,
+				  struct ieee80211_hdr *hdr,
+				  struct ath_rx_status *rs, u64 tsf)
+{
+	return 0;
+}
+#endif /* CONFIG_ATH9K_DEBUGFS */
+
+#endif /* SPECTRAL_H */
diff --git a/drivers/net/wireless/ath/ath9k/common.h b/drivers/net/wireless/ath/ath9k/common.h
index ffc454b..2b79a56 100644
--- a/drivers/net/wireless/ath/ath9k/common.h
+++ b/drivers/net/wireless/ath/ath9k/common.h
@@ -24,6 +24,7 @@
 #include "common-init.h"
 #include "common-beacon.h"
 #include "common-debug.h"
+#include "common-spectral.h"
 
 /* Common header for Atheros 802.11n base driver cores */
 
diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 6492619..db38840 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -1310,7 +1310,7 @@ void ath9k_get_et_stats(struct ieee80211_hw *hw,
 
 void ath9k_deinit_debug(struct ath_softc *sc)
 {
-	ath9k_spectral_deinit_debug(&sc->spec_priv);
+	ath9k_cmn_spectral_deinit_debug(&sc->spec_priv);
 }
 
 int ath9k_init_debug(struct ath_hw *ah)
@@ -1330,7 +1330,7 @@ int ath9k_init_debug(struct ath_hw *ah)
 
 	ath9k_dfs_init_debug(sc);
 	ath9k_tx99_init_debug(sc);
-	ath9k_spectral_init_debug(&sc->spec_priv, sc->debug.debugfs_phy);
+	ath9k_cmn_spectral_init_debug(&sc->spec_priv, sc->debug.debugfs_phy);
 
 	debugfs_create_file("dma", S_IRUSR, sc->debug.debugfs_phy, sc,
 			    &fops_dma);
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index e97c693..7395afb 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -870,7 +870,7 @@ static int ath9k_rx_skb_preprocess(struct ath_softc *sc,
 	 */
 	if (rx_stats->rs_status & ATH9K_RXERR_PHY) {
 		ath9k_dfs_process_phyerr(sc, hdr, rx_stats, rx_status->mactime);
-		if (ath_process_fft(&sc->spec_priv, hdr, rx_stats, rx_status->mactime))
+		if (ath_cmn_process_fft(&sc->spec_priv, hdr, rx_stats, rx_status->mactime))
 			RX_STAT_INC(rx_spectral);
 
 		return -EINVAL;
diff --git a/drivers/net/wireless/ath/ath9k/spectral.c b/drivers/net/wireless/ath/ath9k/spectral.c
deleted file mode 100644
index bf85740..0000000
--- a/drivers/net/wireless/ath/ath9k/spectral.c
+++ /dev/null
@@ -1,614 +0,0 @@
-/*
- * Copyright (c) 2013 Qualcomm Atheros, Inc.
- *
- * Permission to use, copy, modify, and/or distribute this software for any
- * purpose with or without fee is hereby granted, provided that the above
- * copyright notice and this permission notice appear in all copies.
- *
- * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
- * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
- * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
- * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
- * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
- * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
- * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
- */
-
-#include <linux/relay.h>
-#include "ath9k.h"
-
-static s8 fix_rssi_inv_only(u8 rssi_val)
-{
-	if (rssi_val == 128)
-		rssi_val = 0;
-	return (s8) rssi_val;
-}
-
-static void ath_debug_send_fft_sample(struct ath_spec_scan_priv *spec_priv,
-				      struct fft_sample_tlv *fft_sample_tlv)
-{
-	int length;
-	if (!spec_priv->rfs_chan_spec_scan)
-		return;
-
-	length = __be16_to_cpu(fft_sample_tlv->length) +
-		 sizeof(*fft_sample_tlv);
-	relay_write(spec_priv->rfs_chan_spec_scan, fft_sample_tlv, length);
-}
-
-/* returns 1 if this was a spectral frame, even if not handled. */
-int ath_process_fft(struct ath_spec_scan_priv *spec_priv, struct ieee80211_hdr *hdr,
-		    struct ath_rx_status *rs, u64 tsf)
-{
-	struct ath_hw *ah = spec_priv->ah;
-	struct ath_common *common = ath9k_hw_common(spec_priv->ah);
-	u8 num_bins, *bins, *vdata = (u8 *)hdr;
-	struct fft_sample_ht20 fft_sample_20;
-	struct fft_sample_ht20_40 fft_sample_40;
-	struct fft_sample_tlv *tlv;
-	struct ath_radar_info *radar_info;
-	int len = rs->rs_datalen;
-	int dc_pos;
-	u16 fft_len, length, freq = ah->curchan->chan->center_freq;
-	enum nl80211_channel_type chan_type;
-
-	/* AR9280 and before report via ATH9K_PHYERR_RADAR, AR93xx and newer
-	 * via ATH9K_PHYERR_SPECTRAL. Haven't seen ATH9K_PHYERR_FALSE_RADAR_EXT
-	 * yet, but this is supposed to be possible as well.
-	 */
-	if (rs->rs_phyerr != ATH9K_PHYERR_RADAR &&
-	    rs->rs_phyerr != ATH9K_PHYERR_FALSE_RADAR_EXT &&
-	    rs->rs_phyerr != ATH9K_PHYERR_SPECTRAL)
-		return 0;
-
-	/* check if spectral scan bit is set. This does not have to be checked
-	 * if received through a SPECTRAL phy error, but shouldn't hurt.
-	 */
-	radar_info = ((struct ath_radar_info *)&vdata[len]) - 1;
-	if (!(radar_info->pulse_bw_info & SPECTRAL_SCAN_BITMASK))
-		return 0;
-
-	chan_type = cfg80211_get_chandef_type(&common->hw->conf.chandef);
-	if ((chan_type == NL80211_CHAN_HT40MINUS) ||
-	    (chan_type == NL80211_CHAN_HT40PLUS)) {
-		fft_len = SPECTRAL_HT20_40_TOTAL_DATA_LEN;
-		num_bins = SPECTRAL_HT20_40_NUM_BINS;
-		bins = (u8 *)fft_sample_40.data;
-	} else {
-		fft_len = SPECTRAL_HT20_TOTAL_DATA_LEN;
-		num_bins = SPECTRAL_HT20_NUM_BINS;
-		bins = (u8 *)fft_sample_20.data;
-	}
-
-	/* Variation in the data length is possible and will be fixed later */
-	if ((len > fft_len + 2) || (len < fft_len - 1))
-		return 1;
-
-	switch (len - fft_len) {
-	case 0:
-		/* length correct, nothing to do. */
-		memcpy(bins, vdata, num_bins);
-		break;
-	case -1:
-		/* first byte missing, duplicate it. */
-		memcpy(&bins[1], vdata, num_bins - 1);
-		bins[0] = vdata[0];
-		break;
-	case 2:
-		/* MAC added 2 extra bytes at bin 30 and 32, remove them. */
-		memcpy(bins, vdata, 30);
-		bins[30] = vdata[31];
-		memcpy(&bins[31], &vdata[33], num_bins - 31);
-		break;
-	case 1:
-		/* MAC added 2 extra bytes AND first byte is missing. */
-		bins[0] = vdata[0];
-		memcpy(&bins[1], vdata, 30);
-		bins[31] = vdata[31];
-		memcpy(&bins[32], &vdata[33], num_bins - 32);
-		break;
-	default:
-		return 1;
-	}
-
-	/* DC value (value in the middle) is the blind spot of the spectral
-	 * sample and invalid, interpolate it.
-	 */
-	dc_pos = num_bins / 2;
-	bins[dc_pos] = (bins[dc_pos + 1] + bins[dc_pos - 1]) / 2;
-
-	if ((chan_type == NL80211_CHAN_HT40MINUS) ||
-	    (chan_type == NL80211_CHAN_HT40PLUS)) {
-		s8 lower_rssi, upper_rssi;
-		s16 ext_nf;
-		u8 lower_max_index, upper_max_index;
-		u8 lower_bitmap_w, upper_bitmap_w;
-		u16 lower_mag, upper_mag;
-		struct ath9k_hw_cal_data *caldata = ah->caldata;
-		struct ath_ht20_40_mag_info *mag_info;
-
-		if (caldata)
-			ext_nf = ath9k_hw_getchan_noise(ah, ah->curchan,
-					caldata->nfCalHist[3].privNF);
-		else
-			ext_nf = ATH_DEFAULT_NOISE_FLOOR;
-
-		length = sizeof(fft_sample_40) - sizeof(struct fft_sample_tlv);
-		fft_sample_40.tlv.type = ATH_FFT_SAMPLE_HT20_40;
-		fft_sample_40.tlv.length = __cpu_to_be16(length);
-		fft_sample_40.freq = __cpu_to_be16(freq);
-		fft_sample_40.channel_type = chan_type;
-
-		if (chan_type == NL80211_CHAN_HT40PLUS) {
-			lower_rssi = fix_rssi_inv_only(rs->rs_rssi_ctl[0]);
-			upper_rssi = fix_rssi_inv_only(rs->rs_rssi_ext[0]);
-
-			fft_sample_40.lower_noise = ah->noise;
-			fft_sample_40.upper_noise = ext_nf;
-		} else {
-			lower_rssi = fix_rssi_inv_only(rs->rs_rssi_ext[0]);
-			upper_rssi = fix_rssi_inv_only(rs->rs_rssi_ctl[0]);
-
-			fft_sample_40.lower_noise = ext_nf;
-			fft_sample_40.upper_noise = ah->noise;
-		}
-		fft_sample_40.lower_rssi = lower_rssi;
-		fft_sample_40.upper_rssi = upper_rssi;
-
-		mag_info = ((struct ath_ht20_40_mag_info *)radar_info) - 1;
-		lower_mag = spectral_max_magnitude(mag_info->lower_bins);
-		upper_mag = spectral_max_magnitude(mag_info->upper_bins);
-		fft_sample_40.lower_max_magnitude = __cpu_to_be16(lower_mag);
-		fft_sample_40.upper_max_magnitude = __cpu_to_be16(upper_mag);
-		lower_max_index = spectral_max_index(mag_info->lower_bins);
-		upper_max_index = spectral_max_index(mag_info->upper_bins);
-		fft_sample_40.lower_max_index = lower_max_index;
-		fft_sample_40.upper_max_index = upper_max_index;
-		lower_bitmap_w = spectral_bitmap_weight(mag_info->lower_bins);
-		upper_bitmap_w = spectral_bitmap_weight(mag_info->upper_bins);
-		fft_sample_40.lower_bitmap_weight = lower_bitmap_w;
-		fft_sample_40.upper_bitmap_weight = upper_bitmap_w;
-		fft_sample_40.max_exp = mag_info->max_exp & 0xf;
-
-		fft_sample_40.tsf = __cpu_to_be64(tsf);
-
-		tlv = (struct fft_sample_tlv *)&fft_sample_40;
-	} else {
-		u8 max_index, bitmap_w;
-		u16 magnitude;
-		struct ath_ht20_mag_info *mag_info;
-
-		length = sizeof(fft_sample_20) - sizeof(struct fft_sample_tlv);
-		fft_sample_20.tlv.type = ATH_FFT_SAMPLE_HT20;
-		fft_sample_20.tlv.length = __cpu_to_be16(length);
-		fft_sample_20.freq = __cpu_to_be16(freq);
-
-		fft_sample_20.rssi = fix_rssi_inv_only(rs->rs_rssi_ctl[0]);
-		fft_sample_20.noise = ah->noise;
-
-		mag_info = ((struct ath_ht20_mag_info *)radar_info) - 1;
-		magnitude = spectral_max_magnitude(mag_info->all_bins);
-		fft_sample_20.max_magnitude = __cpu_to_be16(magnitude);
-		max_index = spectral_max_index(mag_info->all_bins);
-		fft_sample_20.max_index = max_index;
-		bitmap_w = spectral_bitmap_weight(mag_info->all_bins);
-		fft_sample_20.bitmap_weight = bitmap_w;
-		fft_sample_20.max_exp = mag_info->max_exp & 0xf;
-
-		fft_sample_20.tsf = __cpu_to_be64(tsf);
-
-		tlv = (struct fft_sample_tlv *)&fft_sample_20;
-	}
-
-	ath_debug_send_fft_sample(spec_priv, tlv);
-
-	return 1;
-}
-
-/*********************/
-/* spectral_scan_ctl */
-/*********************/
-
-static ssize_t read_file_spec_scan_ctl(struct file *file, char __user *user_buf,
-				       size_t count, loff_t *ppos)
-{
-	struct ath_spec_scan_priv *spec_priv = file->private_data;
-	char *mode = "";
-	unsigned int len;
-
-	switch (spec_priv->spectral_mode) {
-	case SPECTRAL_DISABLED:
-		mode = "disable";
-		break;
-	case SPECTRAL_BACKGROUND:
-		mode = "background";
-		break;
-	case SPECTRAL_CHANSCAN:
-		mode = "chanscan";
-		break;
-	case SPECTRAL_MANUAL:
-		mode = "manual";
-		break;
-	}
-	len = strlen(mode);
-	return simple_read_from_buffer(user_buf, count, ppos, mode, len);
-}
-
-void ath9k_spectral_scan_trigger(struct ath_common *common,
-				 struct ath_spec_scan_priv *spec_priv)
-{
-	struct ath_hw *ah = spec_priv->ah;
-	u32 rxfilter;
-
-	if (config_enabled(CONFIG_ATH9K_TX99))
-		return;
-
-	if (!ath9k_hw_ops(ah)->spectral_scan_trigger) {
-		ath_err(common, "spectrum analyzer not implemented on this hardware\n");
-		return;
-	}
-
-	ath_ps_ops(common)->wakeup(common);
-	rxfilter = ath9k_hw_getrxfilter(ah);
-	ath9k_hw_setrxfilter(ah, rxfilter |
-				 ATH9K_RX_FILTER_PHYRADAR |
-				 ATH9K_RX_FILTER_PHYERR);
-
-	/* TODO: usually this should not be neccesary, but for some reason
-	 * (or in some mode?) the trigger must be called after the
-	 * configuration, otherwise the register will have its values reset
-	 * (on my ar9220 to value 0x01002310)
-	 */
-	ath9k_spectral_scan_config(common, spec_priv, spec_priv->spectral_mode);
-	ath9k_hw_ops(ah)->spectral_scan_trigger(ah);
-	ath_ps_ops(common)->restore(common);
-}
-
-int ath9k_spectral_scan_config(struct ath_common *common,
-			       struct ath_spec_scan_priv *spec_priv,
-			       enum spectral_mode spectral_mode)
-{
-	struct ath_hw *ah = spec_priv->ah;
-
-	if (!ath9k_hw_ops(ah)->spectral_scan_trigger) {
-		ath_err(common, "spectrum analyzer not implemented on this hardware\n");
-		return -1;
-	}
-
-	switch (spectral_mode) {
-	case SPECTRAL_DISABLED:
-		spec_priv->spec_config.enabled = 0;
-		break;
-	case SPECTRAL_BACKGROUND:
-		/* send endless samples.
-		 * TODO: is this really useful for "background"?
-		 */
-		spec_priv->spec_config.endless = 1;
-		spec_priv->spec_config.enabled = 1;
-		break;
-	case SPECTRAL_CHANSCAN:
-	case SPECTRAL_MANUAL:
-		spec_priv->spec_config.endless = 0;
-		spec_priv->spec_config.enabled = 1;
-		break;
-	default:
-		return -1;
-	}
-
-	ath_ps_ops(common)->wakeup(common);
-	ath9k_hw_ops(ah)->spectral_scan_config(ah, &spec_priv->spec_config);
-	ath_ps_ops(common)->restore(common);
-
-	spec_priv->spectral_mode = spectral_mode;
-
-	return 0;
-}
-
-static ssize_t write_file_spec_scan_ctl(struct file *file,
-					const char __user *user_buf,
-					size_t count, loff_t *ppos)
-{
-	struct ath_spec_scan_priv *spec_priv = file->private_data;
-	struct ath_common *common = ath9k_hw_common(spec_priv->ah);
-	char buf[32];
-	ssize_t len;
-
-	if (config_enabled(CONFIG_ATH9K_TX99))
-		return -EOPNOTSUPP;
-
-	len = min(count, sizeof(buf) - 1);
-	if (copy_from_user(buf, user_buf, len))
-		return -EFAULT;
-
-	buf[len] = '\0';
-
-	if (strncmp("trigger", buf, 7) == 0) {
-		ath9k_spectral_scan_trigger(common, spec_priv);
-	} else if (strncmp("background", buf, 10) == 0) {
-		ath9k_spectral_scan_config(common, spec_priv, SPECTRAL_BACKGROUND);
-		ath_dbg(common, CONFIG, "spectral scan: background mode enabled\n");
-	} else if (strncmp("chanscan", buf, 8) == 0) {
-		ath9k_spectral_scan_config(common, spec_priv, SPECTRAL_CHANSCAN);
-		ath_dbg(common, CONFIG, "spectral scan: channel scan mode enabled\n");
-	} else if (strncmp("manual", buf, 6) == 0) {
-		ath9k_spectral_scan_config(common, spec_priv, SPECTRAL_MANUAL);
-		ath_dbg(common, CONFIG, "spectral scan: manual mode enabled\n");
-	} else if (strncmp("disable", buf, 7) == 0) {
-		ath9k_spectral_scan_config(common, spec_priv, SPECTRAL_DISABLED);
-		ath_dbg(common, CONFIG, "spectral scan: disabled\n");
-	} else {
-		return -EINVAL;
-	}
-
-	return count;
-}
-
-static const struct file_operations fops_spec_scan_ctl = {
-	.read = read_file_spec_scan_ctl,
-	.write = write_file_spec_scan_ctl,
-	.open = simple_open,
-	.owner = THIS_MODULE,
-	.llseek = default_llseek,
-};
-
-/*************************/
-/* spectral_short_repeat */
-/*************************/
-
-static ssize_t read_file_spectral_short_repeat(struct file *file,
-					       char __user *user_buf,
-					       size_t count, loff_t *ppos)
-{
-	struct ath_spec_scan_priv *spec_priv = file->private_data;
-	char buf[32];
-	unsigned int len;
-
-	len = sprintf(buf, "%d\n", spec_priv->spec_config.short_repeat);
-	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
-}
-
-static ssize_t write_file_spectral_short_repeat(struct file *file,
-						const char __user *user_buf,
-						size_t count, loff_t *ppos)
-{
-	struct ath_spec_scan_priv *spec_priv = file->private_data;
-	unsigned long val;
-	char buf[32];
-	ssize_t len;
-
-	len = min(count, sizeof(buf) - 1);
-	if (copy_from_user(buf, user_buf, len))
-		return -EFAULT;
-
-	buf[len] = '\0';
-	if (kstrtoul(buf, 0, &val))
-		return -EINVAL;
-
-	if (val > 1)
-		return -EINVAL;
-
-	spec_priv->spec_config.short_repeat = val;
-	return count;
-}
-
-static const struct file_operations fops_spectral_short_repeat = {
-	.read = read_file_spectral_short_repeat,
-	.write = write_file_spectral_short_repeat,
-	.open = simple_open,
-	.owner = THIS_MODULE,
-	.llseek = default_llseek,
-};
-
-/******************/
-/* spectral_count */
-/******************/
-
-static ssize_t read_file_spectral_count(struct file *file,
-					char __user *user_buf,
-					size_t count, loff_t *ppos)
-{
-	struct ath_spec_scan_priv *spec_priv = file->private_data;
-	char buf[32];
-	unsigned int len;
-
-	len = sprintf(buf, "%d\n", spec_priv->spec_config.count);
-	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
-}
-
-static ssize_t write_file_spectral_count(struct file *file,
-					 const char __user *user_buf,
-					 size_t count, loff_t *ppos)
-{
-	struct ath_spec_scan_priv *spec_priv = file->private_data;
-	unsigned long val;
-	char buf[32];
-	ssize_t len;
-
-	len = min(count, sizeof(buf) - 1);
-	if (copy_from_user(buf, user_buf, len))
-		return -EFAULT;
-
-	buf[len] = '\0';
-	if (kstrtoul(buf, 0, &val))
-		return -EINVAL;
-
-	if (val > 255)
-		return -EINVAL;
-
-	spec_priv->spec_config.count = val;
-	return count;
-}
-
-static const struct file_operations fops_spectral_count = {
-	.read = read_file_spectral_count,
-	.write = write_file_spectral_count,
-	.open = simple_open,
-	.owner = THIS_MODULE,
-	.llseek = default_llseek,
-};
-
-/*******************/
-/* spectral_period */
-/*******************/
-
-static ssize_t read_file_spectral_period(struct file *file,
-					 char __user *user_buf,
-					 size_t count, loff_t *ppos)
-{
-	struct ath_spec_scan_priv *spec_priv = file->private_data;
-	char buf[32];
-	unsigned int len;
-
-	len = sprintf(buf, "%d\n", spec_priv->spec_config.period);
-	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
-}
-
-static ssize_t write_file_spectral_period(struct file *file,
-					  const char __user *user_buf,
-					  size_t count, loff_t *ppos)
-{
-	struct ath_spec_scan_priv *spec_priv = file->private_data;
-	unsigned long val;
-	char buf[32];
-	ssize_t len;
-
-	len = min(count, sizeof(buf) - 1);
-	if (copy_from_user(buf, user_buf, len))
-		return -EFAULT;
-
-	buf[len] = '\0';
-	if (kstrtoul(buf, 0, &val))
-		return -EINVAL;
-
-	if (val > 255)
-		return -EINVAL;
-
-	spec_priv->spec_config.period = val;
-	return count;
-}
-
-static const struct file_operations fops_spectral_period = {
-	.read = read_file_spectral_period,
-	.write = write_file_spectral_period,
-	.open = simple_open,
-	.owner = THIS_MODULE,
-	.llseek = default_llseek,
-};
-
-/***********************/
-/* spectral_fft_period */
-/***********************/
-
-static ssize_t read_file_spectral_fft_period(struct file *file,
-					     char __user *user_buf,
-					     size_t count, loff_t *ppos)
-{
-	struct ath_spec_scan_priv *spec_priv = file->private_data;
-	char buf[32];
-	unsigned int len;
-
-	len = sprintf(buf, "%d\n", spec_priv->spec_config.fft_period);
-	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
-}
-
-static ssize_t write_file_spectral_fft_period(struct file *file,
-					      const char __user *user_buf,
-					      size_t count, loff_t *ppos)
-{
-	struct ath_spec_scan_priv *spec_priv = file->private_data;
-	unsigned long val;
-	char buf[32];
-	ssize_t len;
-
-	len = min(count, sizeof(buf) - 1);
-	if (copy_from_user(buf, user_buf, len))
-		return -EFAULT;
-
-	buf[len] = '\0';
-	if (kstrtoul(buf, 0, &val))
-		return -EINVAL;
-
-	if (val > 15)
-		return -EINVAL;
-
-	spec_priv->spec_config.fft_period = val;
-	return count;
-}
-
-static const struct file_operations fops_spectral_fft_period = {
-	.read = read_file_spectral_fft_period,
-	.write = write_file_spectral_fft_period,
-	.open = simple_open,
-	.owner = THIS_MODULE,
-	.llseek = default_llseek,
-};
-
-/*******************/
-/* Relay interface */
-/*******************/
-
-static struct dentry *create_buf_file_handler(const char *filename,
-					      struct dentry *parent,
-					      umode_t mode,
-					      struct rchan_buf *buf,
-					      int *is_global)
-{
-	struct dentry *buf_file;
-
-	buf_file = debugfs_create_file(filename, mode, parent, buf,
-				       &relay_file_operations);
-	*is_global = 1;
-	return buf_file;
-}
-
-static int remove_buf_file_handler(struct dentry *dentry)
-{
-	debugfs_remove(dentry);
-
-	return 0;
-}
-
-static struct rchan_callbacks rfs_spec_scan_cb = {
-	.create_buf_file = create_buf_file_handler,
-	.remove_buf_file = remove_buf_file_handler,
-};
-
-/*********************/
-/* Debug Init/Deinit */
-/*********************/
-
-void ath9k_spectral_deinit_debug(struct ath_spec_scan_priv *spec_priv)
-{
-	if (config_enabled(CONFIG_ATH9K_DEBUGFS) && spec_priv->rfs_chan_spec_scan) {
-		relay_close(spec_priv->rfs_chan_spec_scan);
-		spec_priv->rfs_chan_spec_scan = NULL;
-	}
-}
-
-void ath9k_spectral_init_debug(struct ath_spec_scan_priv *spec_priv, struct dentry *debugfs_phy)
-{
-	spec_priv->rfs_chan_spec_scan = relay_open("spectral_scan",
-					    debugfs_phy,
-					    1024, 256, &rfs_spec_scan_cb,
-					    NULL);
-	debugfs_create_file("spectral_scan_ctl",
-			    S_IRUSR | S_IWUSR,
-			    debugfs_phy, spec_priv,
-			    &fops_spec_scan_ctl);
-	debugfs_create_file("spectral_short_repeat",
-			    S_IRUSR | S_IWUSR,
-			    debugfs_phy, spec_priv,
-			    &fops_spectral_short_repeat);
-	debugfs_create_file("spectral_count",
-			    S_IRUSR | S_IWUSR,
-			    debugfs_phy, spec_priv,
-			    &fops_spectral_count);
-	debugfs_create_file("spectral_period",
-			    S_IRUSR | S_IWUSR,
-			    debugfs_phy, spec_priv,
-			    &fops_spectral_period);
-	debugfs_create_file("spectral_fft_period",
-			    S_IRUSR | S_IWUSR,
-			    debugfs_phy, spec_priv,
-			    &fops_spectral_fft_period);
-}
diff --git a/drivers/net/wireless/ath/ath9k/spectral.h b/drivers/net/wireless/ath/ath9k/spectral.h
deleted file mode 100644
index 77582cf..0000000
--- a/drivers/net/wireless/ath/ath9k/spectral.h
+++ /dev/null
@@ -1,154 +0,0 @@
-/*
- * Copyright (c) 2013 Qualcomm Atheros, Inc.
- *
- * Permission to use, copy, modify, and/or distribute this software for any
- * purpose with or without fee is hereby granted, provided that the above
- * copyright notice and this permission notice appear in all copies.
- *
- * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
- * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
- * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
- * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
- * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
- * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
- * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
- */
-
-#ifndef SPECTRAL_H
-#define SPECTRAL_H
-
-#include "../spectral_common.h"
-
-/* enum spectral_mode:
- *
- * @SPECTRAL_DISABLED: spectral mode is disabled
- * @SPECTRAL_BACKGROUND: hardware sends samples when it is not busy with
- *	something else.
- * @SPECTRAL_MANUAL: spectral scan is enabled, triggering for samples
- *	is performed manually.
- * @SPECTRAL_CHANSCAN: Like manual, but also triggered when changing channels
- *	during a channel scan.
- */
-enum spectral_mode {
-	SPECTRAL_DISABLED = 0,
-	SPECTRAL_BACKGROUND,
-	SPECTRAL_MANUAL,
-	SPECTRAL_CHANSCAN,
-};
-
-#define SPECTRAL_SCAN_BITMASK		0x10
-/* Radar info packet format, used for DFS and spectral formats. */
-struct ath_radar_info {
-	u8 pulse_length_pri;
-	u8 pulse_length_ext;
-	u8 pulse_bw_info;
-} __packed;
-
-/* The HT20 spectral data has 4 bytes of additional information at it's end.
- *
- * [7:0]: all bins {max_magnitude[1:0], bitmap_weight[5:0]}
- * [7:0]: all bins  max_magnitude[9:2]
- * [7:0]: all bins {max_index[5:0], max_magnitude[11:10]}
- * [3:0]: max_exp (shift amount to size max bin to 8-bit unsigned)
- */
-struct ath_ht20_mag_info {
-	u8 all_bins[3];
-	u8 max_exp;
-} __packed;
-
-/* WARNING: don't actually use this struct! MAC may vary the amount of
- * data by -1/+2. This struct is for reference only.
- */
-struct ath_ht20_fft_packet {
-	u8 data[SPECTRAL_HT20_NUM_BINS];
-	struct ath_ht20_mag_info mag_info;
-	struct ath_radar_info radar_info;
-} __packed;
-
-#define SPECTRAL_HT20_TOTAL_DATA_LEN	(sizeof(struct ath_ht20_fft_packet))
-
-/* Dynamic 20/40 mode:
- *
- * [7:0]: lower bins {max_magnitude[1:0], bitmap_weight[5:0]}
- * [7:0]: lower bins  max_magnitude[9:2]
- * [7:0]: lower bins {max_index[5:0], max_magnitude[11:10]}
- * [7:0]: upper bins {max_magnitude[1:0], bitmap_weight[5:0]}
- * [7:0]: upper bins  max_magnitude[9:2]
- * [7:0]: upper bins {max_index[5:0], max_magnitude[11:10]}
- * [3:0]: max_exp (shift amount to size max bin to 8-bit unsigned)
- */
-struct ath_ht20_40_mag_info {
-	u8 lower_bins[3];
-	u8 upper_bins[3];
-	u8 max_exp;
-} __packed;
-
-/* WARNING: don't actually use this struct! MAC may vary the amount of
- * data. This struct is for reference only.
- */
-struct ath_ht20_40_fft_packet {
-	u8 data[SPECTRAL_HT20_40_NUM_BINS];
-	struct ath_ht20_40_mag_info mag_info;
-	struct ath_radar_info radar_info;
-} __packed;
-
-struct ath_spec_scan_priv {
-	struct ath_hw *ah;
-	/* relay(fs) channel for spectral scan */
-	struct rchan *rfs_chan_spec_scan;
-	enum spectral_mode spectral_mode;
-	struct ath_spec_scan spec_config;
-};
-
-#define SPECTRAL_HT20_40_TOTAL_DATA_LEN	(sizeof(struct ath_ht20_40_fft_packet))
-
-/* grabs the max magnitude from the all/upper/lower bins */
-static inline u16 spectral_max_magnitude(u8 *bins)
-{
-	return (bins[0] & 0xc0) >> 6 |
-	       (bins[1] & 0xff) << 2 |
-	       (bins[2] & 0x03) << 10;
-}
-
-/* return the max magnitude from the all/upper/lower bins */
-static inline u8 spectral_max_index(u8 *bins)
-{
-	s8 m = (bins[2] & 0xfc) >> 2;
-
-	/* TODO: this still doesn't always report the right values ... */
-	if (m > 32)
-		m |= 0xe0;
-	else
-		m &= ~0xe0;
-
-	return m + 29;
-}
-
-/* return the bitmap weight from the all/upper/lower bins */
-static inline u8 spectral_bitmap_weight(u8 *bins)
-{
-	return bins[0] & 0x3f;
-}
-
-void ath9k_spectral_init_debug(struct ath_spec_scan_priv *spec_priv, struct dentry *debugfs_phy);
-void ath9k_spectral_deinit_debug(struct ath_spec_scan_priv *spec_priv);
-
-void ath9k_spectral_scan_trigger(struct ath_common *common,
-				 struct ath_spec_scan_priv *spec_priv);
-int ath9k_spectral_scan_config(struct ath_common *common,
-			       struct ath_spec_scan_priv *spec_priv,
-			       enum spectral_mode spectral_mode);
-
-#ifdef CONFIG_ATH9K_DEBUGFS
-int ath_process_fft(struct ath_spec_scan_priv *spec_priv, struct ieee80211_hdr *hdr,
-		    struct ath_rx_status *rs, u64 tsf);
-#else
-static inline int ath_process_fft(struct ath_spec_scan_priv *spec_priv,
-				  struct ieee80211_hdr *hdr,
-				  struct ath_rx_status *rs, u64 tsf)
-{
-	return 0;
-}
-#endif /* CONFIG_ATH9K_DEBUGFS */
-
-#endif /* SPECTRAL_H */
-- 
1.9.1

