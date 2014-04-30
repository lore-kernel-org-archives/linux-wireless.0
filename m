Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:54900 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759103AbaD3PMI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Apr 2014 11:12:08 -0400
From: Ashish Patro <patro@cs.wisc.edu>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, linux@rempel-privat.de,
	Ashish Patro <patro@cs.wisc.edu>
Subject: [PATCH 3/3] Update spectral scan calls to support both ath9k and ath9k_htc. Adding spectral scan functionality to ath9k_htc driver. Tested using a AR9271 WiFi card.
Date: Wed, 30 Apr 2014 10:11:23 -0500
Message-Id: <1398870683-15701-4-git-send-email-patro@cs.wisc.edu> (sfid-20140430_171213_203906_2178AC8F)
In-Reply-To: <1398870683-15701-1-git-send-email-patro@cs.wisc.edu>
References: <1398870683-15701-1-git-send-email-patro@cs.wisc.edu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Ashish Patro <patro@cs.wisc.edu>
---
 drivers/net/wireless/ath/ath9k/Makefile           |    2 +-
 drivers/net/wireless/ath/ath9k/ar9002_phy.c       |   11 +-
 drivers/net/wireless/ath/ath9k/common-spectral.c  |   29 +-
 drivers/net/wireless/ath/ath9k/common-spectral.h  |   16 +-
 drivers/net/wireless/ath/ath9k/htc.h              |   13 +
 drivers/net/wireless/ath/ath9k/htc_drv_debug.c    |    3 +
 drivers/net/wireless/ath/ath9k/htc_drv_init.c     |    8 +
 drivers/net/wireless/ath/ath9k/htc_drv_main.c     |   75 +++++
 drivers/net/wireless/ath/ath9k/htc_drv_spectral.c |  353 +++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c     |   17 +
 drivers/net/wireless/ath/ath9k/recv.c             |    7 +-
 11 files changed, 507 insertions(+), 27 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath9k/htc_drv_spectral.c

diff --git a/drivers/net/wireless/ath/ath9k/Makefile b/drivers/net/wireless/ath/ath9k/Makefile
index 613bf30..aaa5a34 100644
--- a/drivers/net/wireless/ath/ath9k/Makefile
+++ b/drivers/net/wireless/ath/ath9k/Makefile
@@ -65,6 +65,6 @@ ath9k_htc-y +=	htc_hst.o \
 		htc_drv_init.o \
 		htc_drv_gpio.o
 
-ath9k_htc-$(CONFIG_ATH9K_HTC_DEBUGFS) += htc_drv_debug.o
+ath9k_htc-$(CONFIG_ATH9K_HTC_DEBUGFS) += htc_drv_debug.o htc_drv_spectral.o
 
 obj-$(CONFIG_ATH9K_HTC) += ath9k_htc.o
diff --git a/drivers/net/wireless/ath/ath9k/ar9002_phy.c b/drivers/net/wireless/ath/ath9k/ar9002_phy.c
index 9a2afa2..7a41759 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_phy.c
@@ -641,11 +641,16 @@ static void ar9002_hw_spectral_scan_config(struct ath_hw *ah,
 	/* on AR92xx, the highest bit of count will make the the chip send
 	 * spectral samples endlessly. Check if this really was intended,
 	 * and fix otherwise.
+	 *
+	 * For AR9271 chipsets, set count = 0 for endless samples.
 	 */
 	count = param->count;
-	if (param->endless)
-		count = 0x80;
-	else if (count & 0x80)
+	if (param->endless) {
+		if (AR_SREV_9271(ah))
+			count = 0;
+		else
+			count = 0x80;
+	} else if (count & 0x80)
 		count = 0x7f;
 
 	REG_RMW_FIELD(ah, AR_PHY_SPECTRAL_SCAN,
diff --git a/drivers/net/wireless/ath/ath9k/common-spectral.c b/drivers/net/wireless/ath/ath9k/common-spectral.c
index 8b14af8..3157cb3 100644
--- a/drivers/net/wireless/ath/ath9k/common-spectral.c
+++ b/drivers/net/wireless/ath/ath9k/common-spectral.c
@@ -14,8 +14,8 @@
  * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
-#include <linux/relay.h>
-#include "ath9k.h"
+#include "common.h"
+#include "common-spectral.h"
 
 static s8 fix_rssi_inv_only(u8 rssi_val)
 {
@@ -24,32 +24,39 @@ static s8 fix_rssi_inv_only(u8 rssi_val)
 	return (s8) rssi_val;
 }
 
-static void ath_debug_send_fft_sample(struct ath_softc *sc,
+static void ath_debug_send_fft_sample(struct rchan *rfs_chan_spec_scan,
 				      struct fft_sample_tlv *fft_sample_tlv)
 {
 	int length;
-	if (!sc->rfs_chan_spec_scan)
+	if (!rfs_chan_spec_scan)
 		return;
 
 	length = __be16_to_cpu(fft_sample_tlv->length) +
 		 sizeof(*fft_sample_tlv);
-	relay_write(sc->rfs_chan_spec_scan, fft_sample_tlv, length);
+	relay_write(rfs_chan_spec_scan, fft_sample_tlv, length);
 }
 
 /* returns 1 if this was a spectral frame, even if not handled. */
-int ath_process_fft(struct ath_softc *sc, struct ieee80211_hdr *hdr,
-		    struct ath_rx_status *rs, u64 tsf)
+int ath_process_fft(struct ath_hw *ah, struct ieee80211_hdr *hdr,
+		    struct ieee80211_hw *hw, struct rchan *rfs_chan_spec_scan,
+		    struct ath_rx_status *rs, u64 tsf, bool is_htc)
 {
-	struct ath_hw *ah = sc->sc_ah;
 	u8 num_bins, *bins, *vdata = (u8 *)hdr;
 	struct fft_sample_ht20 fft_sample_20;
 	struct fft_sample_ht20_40 fft_sample_40;
 	struct fft_sample_tlv *tlv;
 	struct ath_radar_info *radar_info;
-	int len = rs->rs_datalen;
 	int dc_pos;
 	u16 fft_len, length, freq = ah->curchan->chan->center_freq;
 	enum nl80211_channel_type chan_type;
+	int len = 0;
+
+	/* Getting the length from AR9271 chipsets.
+	 */
+	if (is_htc)
+		len = be16_to_cpu(rs->rs_datalen);
+	else
+		len = rs->rs_datalen;
 
 	/* AR9280 and before report via ATH9K_PHYERR_RADAR, AR93xx and newer
 	 * via ATH9K_PHYERR_SPECTRAL. Haven't seen ATH9K_PHYERR_FALSE_RADAR_EXT
@@ -67,7 +74,7 @@ int ath_process_fft(struct ath_softc *sc, struct ieee80211_hdr *hdr,
 	if (!(radar_info->pulse_bw_info & SPECTRAL_SCAN_BITMASK))
 		return 0;
 
-	chan_type = cfg80211_get_chandef_type(&sc->hw->conf.chandef);
+	chan_type = cfg80211_get_chandef_type(&hw->conf.chandef);
 	if ((chan_type == NL80211_CHAN_HT40MINUS) ||
 	    (chan_type == NL80211_CHAN_HT40PLUS)) {
 		fft_len = SPECTRAL_HT20_40_TOTAL_DATA_LEN;
@@ -199,7 +206,7 @@ int ath_process_fft(struct ath_softc *sc, struct ieee80211_hdr *hdr,
 		tlv = (struct fft_sample_tlv *)&fft_sample_20;
 	}
 
-	ath_debug_send_fft_sample(sc, tlv);
+	ath_debug_send_fft_sample(rfs_chan_spec_scan, tlv);
 
 	return 1;
 }
diff --git a/drivers/net/wireless/ath/ath9k/common-spectral.h b/drivers/net/wireless/ath/ath9k/common-spectral.h
index 61faea4..be84a15 100644
--- a/drivers/net/wireless/ath/ath9k/common-spectral.h
+++ b/drivers/net/wireless/ath/ath9k/common-spectral.h
@@ -17,6 +17,8 @@
 #ifndef SPECTRAL_H
 #define SPECTRAL_H
 
+#include <linux/relay.h>
+
 /* enum spectral_mode:
  *
  * @SPECTRAL_DISABLED: spectral mode is disabled
@@ -190,16 +192,8 @@ struct fft_sample_ht20_40 {
 	u8 data[SPECTRAL_HT20_40_NUM_BINS];
 } __packed;
 
-#ifdef CONFIG_ATH9K_DEBUGFS
-int ath_process_fft(struct ath_softc *sc, struct ieee80211_hdr *hdr,
-		    struct ath_rx_status *rs, u64 tsf);
-#else
-static inline int ath_process_fft(struct ath_softc *sc,
-				  struct ieee80211_hdr *hdr,
-				  struct ath_rx_status *rs, u64 tsf)
-{
-	return 0;
-}
-#endif /* CONFIG_ATH9K_DEBUGFS */
+int ath_process_fft(struct ath_hw *ah, struct ieee80211_hdr *hdr,
+		    struct ieee80211_hw *hw, struct rchan *rfs_chan_spec_scan,
+		    struct ath_rx_status *rs, u64 tsf, bool is_htc);
 
 #endif /* SPECTRAL_H */
diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index dab1f0c..ac88fc8 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -31,6 +31,7 @@
 #include "htc_hst.h"
 #include "hif_usb.h"
 #include "wmi.h"
+#include "common-spectral.h"
 
 #define ATH_STA_SHORT_CALINTERVAL 1000    /* 1 second */
 #define ATH_AP_SHORT_CALINTERVAL  100     /* 100 ms */
@@ -529,6 +530,11 @@ struct ath9k_htc_priv {
 	struct ath9k_debug debug;
 #endif
 	struct mutex mutex;
+
+	/* relay(fs) channel for spectral scan */
+	struct rchan *rfs_chan_spec_scan;
+	enum spectral_mode spectral_mode;
+	struct ath_spec_scan spec_config;
 };
 
 static inline void ath_read_cachesize(struct ath_common *common, int *csz)
@@ -636,4 +642,11 @@ int ath9k_htc_init_debug(struct ath_hw *ah);
 static inline int ath9k_htc_init_debug(struct ath_hw *ah) { return 0; };
 #endif /* CONFIG_ATH9K_HTC_DEBUGFS */
 
+void ath9k_htc_spectral_init_debug(struct ath9k_htc_priv *priv);
+void ath9k_htc_spectral_deinit_debug(struct ath9k_htc_priv *priv);
+
+void ath9k_htc_spectral_scan_trigger(struct ieee80211_hw *hw);
+int ath9k_htc_spectral_scan_config(struct ieee80211_hw *hw,
+				   enum spectral_mode spectral_mode);
+
 #endif /* HTC_H */
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_debug.c b/drivers/net/wireless/ath/ath9k/htc_drv_debug.c
index fb071ee..8dc83e8 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_debug.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_debug.c
@@ -993,6 +993,9 @@ int ath9k_htc_init_debug(struct ath_hw *ah)
 	if (!priv->debug.debugfs_phy)
 		return -ENOMEM;
 
+	/* Initialize the debugFS files for the spectral scans */
+	ath9k_htc_spectral_init_debug(priv);
+
 	debugfs_create_file("tgt_int_stats", S_IRUSR, priv->debug.debugfs_phy,
 			    priv, &fops_tgt_int_stats);
 	debugfs_create_file("tgt_tx_stats", S_IRUSR, priv->debug.debugfs_phy,
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index 8a3bd5f..0ccabb7 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -449,6 +449,14 @@ static void ath9k_init_misc(struct ath9k_htc_priv *priv)
 
 	common->last_rssi = ATH_RSSI_DUMMY_MARKER;
 	priv->ah->opmode = NL80211_IFTYPE_STATION;
+
+	priv->spec_config.enabled = 0;
+	/* Set false for AR9271. */
+	priv->spec_config.short_repeat = false;
+	priv->spec_config.count = 8;
+	priv->spec_config.endless = false;
+	priv->spec_config.period = 18;
+	priv->spec_config.fft_period = 0x02;
 }
 
 static int ath9k_init_priv(struct ath9k_htc_priv *priv,
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index f46cd02..3d88a8e 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -311,6 +311,11 @@ static int ath9k_htc_set_channel(struct ath9k_htc_priv *priv,
 	mod_timer(&priv->tx.cleanup_timer,
 		  jiffies + msecs_to_jiffies(ATH9K_HTC_TX_CLEANUP_INTERVAL));
 
+	/* perform spectral scan if requested. */
+	if (test_bit(ATH_OP_SCANNING, &priv->op_flags) &&
+	    priv->spectral_mode == SPECTRAL_CHANSCAN)
+		ath9k_htc_spectral_scan_trigger(hw);
+
 err:
 	ath9k_htc_ps_restore(priv);
 	return ret;
@@ -1158,6 +1163,76 @@ static void ath9k_htc_remove_interface(struct ieee80211_hw *hw,
 	mutex_unlock(&priv->mutex);
 }
 
+/* Start generating the spectral scans. */
+void ath9k_htc_spectral_scan_trigger(struct ieee80211_hw *hw)
+{
+	struct ath9k_htc_priv *priv = hw->priv;
+	struct ath_hw *ah = priv->ah;
+	struct ath_common *common = ath9k_hw_common(ah);
+	u32 rxfilter;
+
+	if (!ath9k_hw_ops(ah)->spectral_scan_trigger) {
+		ath_err(common, "spectrum analyzer not implemented on this hardware\n");
+		return;
+	}
+
+	ath9k_htc_ps_wakeup(priv);
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
+	ath9k_htc_spectral_scan_config(hw, priv->spectral_mode);
+	ath9k_hw_ops(ah)->spectral_scan_trigger(ah);
+	ath9k_htc_ps_restore(priv);
+}
+
+/* Configure the status of the spectral scan feature. */
+int ath9k_htc_spectral_scan_config(struct ieee80211_hw *hw,
+			       enum spectral_mode spectral_mode)
+{
+	struct ath9k_htc_priv *priv = hw->priv;
+	struct ath_hw *ah = priv->ah;
+	struct ath_common *common = ath9k_hw_common(ah);
+
+	if (!ath9k_hw_ops(ah)->spectral_scan_trigger) {
+		ath_err(common, "spectrum analyzer not implemented on this hardware\n");
+		return -1;
+	}
+
+	switch (spectral_mode) {
+	case SPECTRAL_DISABLED:
+		priv->spec_config.enabled = 0;
+		break;
+	case SPECTRAL_BACKGROUND:
+		/* send endless samples.
+		 */
+		priv->spec_config.endless = 1;
+		priv->spec_config.enabled = 1;
+		break;
+	case SPECTRAL_CHANSCAN:
+	case SPECTRAL_MANUAL:
+		priv->spec_config.endless = 0;
+		priv->spec_config.enabled = 1;
+		break;
+	default:
+		return -1;
+	}
+
+	ath9k_htc_ps_wakeup(priv);
+	ath9k_hw_ops(ah)->spectral_scan_config(ah, &priv->spec_config);
+	ath9k_htc_ps_restore(priv);
+
+	priv->spectral_mode = spectral_mode;
+
+	return 0;
+}
+
 static int ath9k_htc_config(struct ieee80211_hw *hw, u32 changed)
 {
 	struct ath9k_htc_priv *priv = hw->priv;
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_spectral.c b/drivers/net/wireless/ath/ath9k/htc_drv_spectral.c
new file mode 100644
index 0000000..2de7181
--- /dev/null
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_spectral.c
@@ -0,0 +1,353 @@
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
+#include "htc.h"
+
+/*********************/
+/* spectral_scan_ctl */
+/*********************/
+
+static ssize_t read_file_spec_scan_ctl(struct file *file, char __user *user_buf,
+				       size_t count, loff_t *ppos)
+{
+	struct ath9k_htc_priv *priv = file->private_data;
+	char *mode = "";
+	unsigned int len;
+
+	switch (priv->spectral_mode) {
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
+static ssize_t write_file_spec_scan_ctl(struct file *file,
+					const char __user *user_buf,
+					size_t count, loff_t *ppos)
+{
+	struct ath9k_htc_priv *priv = file->private_data;
+	struct ath_common *common = ath9k_hw_common(priv->ah);
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
+		ath9k_htc_spectral_scan_trigger(priv->hw);
+	} else if (strncmp("background", buf, 9) == 0) {
+		ath9k_htc_spectral_scan_config(priv->hw, SPECTRAL_BACKGROUND);
+		ath_dbg(common, CONFIG, "spectral scan: background mode enabled\n");
+	} else if (strncmp("chanscan", buf, 8) == 0) {
+		ath9k_htc_spectral_scan_config(priv->hw, SPECTRAL_CHANSCAN);
+		ath_dbg(common, CONFIG, "spectral scan: channel scan mode enabled\n");
+	} else if (strncmp("manual", buf, 6) == 0) {
+		ath9k_htc_spectral_scan_config(priv->hw, SPECTRAL_MANUAL);
+		ath_dbg(common, CONFIG, "spectral scan: manual mode enabled\n");
+	} else if (strncmp("disable", buf, 7) == 0) {
+		ath9k_htc_spectral_scan_config(priv->hw, SPECTRAL_DISABLED);
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
+	struct ath9k_htc_priv *priv = file->private_data;
+	char buf[32];
+	unsigned int len;
+
+	len = sprintf(buf, "%d\n", priv->spec_config.short_repeat);
+	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
+}
+
+static ssize_t write_file_spectral_short_repeat(struct file *file,
+						const char __user *user_buf,
+						size_t count, loff_t *ppos)
+{
+	struct ath9k_htc_priv *priv = file->private_data;
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
+	if (val < 0 || val > 1)
+		return -EINVAL;
+
+	priv->spec_config.short_repeat = val;
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
+	struct ath9k_htc_priv *priv = file->private_data;
+	char buf[32];
+	unsigned int len;
+
+	len = sprintf(buf, "%d\n", priv->spec_config.count);
+	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
+}
+
+static ssize_t write_file_spectral_count(struct file *file,
+					 const char __user *user_buf,
+					 size_t count, loff_t *ppos)
+{
+	struct ath9k_htc_priv *priv = file->private_data;
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
+	priv->spec_config.count = val;
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
+	struct ath9k_htc_priv *priv = file->private_data;
+	char buf[32];
+	unsigned int len;
+
+	len = sprintf(buf, "%d\n", priv->spec_config.period);
+	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
+}
+
+static ssize_t write_file_spectral_period(struct file *file,
+					  const char __user *user_buf,
+					  size_t count, loff_t *ppos)
+{
+	struct ath9k_htc_priv *priv = file->private_data;
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
+	priv->spec_config.period = val;
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
+	struct ath9k_htc_priv *priv = file->private_data;
+	char buf[32];
+	unsigned int len;
+
+	len = sprintf(buf, "%d\n", priv->spec_config.fft_period);
+	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
+}
+
+static ssize_t write_file_spectral_fft_period(struct file *file,
+					      const char __user *user_buf,
+					      size_t count, loff_t *ppos)
+{
+	struct ath9k_htc_priv *priv = file->private_data;
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
+	if (val < 0 || val > 15)
+		return -EINVAL;
+
+	priv->spec_config.fft_period = val;
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
+void ath9k_htc_spectral_deinit_debug(struct ath9k_htc_priv *priv)
+{
+	if (config_enabled(CONFIG_ATH9K_DEBUGFS) && priv->rfs_chan_spec_scan) {
+		relay_close(priv->rfs_chan_spec_scan);
+		priv->rfs_chan_spec_scan = NULL;
+	}
+}
+
+void ath9k_htc_spectral_init_debug(struct ath9k_htc_priv *priv)
+{
+	priv->rfs_chan_spec_scan = relay_open("spectral_scan",
+					    priv->debug.debugfs_phy,
+					    1024, 256, &rfs_spec_scan_cb,
+					    NULL);
+	debugfs_create_file("spectral_scan_ctl",
+			    S_IRUSR | S_IWUSR,
+			    priv->debug.debugfs_phy, priv,
+			    &fops_spec_scan_ctl);
+	debugfs_create_file("spectral_short_repeat",
+			    S_IRUSR | S_IWUSR,
+			    priv->debug.debugfs_phy, priv,
+			    &fops_spectral_short_repeat);
+	debugfs_create_file("spectral_count",
+			    S_IRUSR | S_IWUSR,
+			    priv->debug.debugfs_phy, priv,
+			    &fops_spectral_count);
+	debugfs_create_file("spectral_period",
+			    S_IRUSR | S_IWUSR,
+			    priv->debug.debugfs_phy, priv,
+			    &fops_spectral_period);
+	debugfs_create_file("spectral_fft_period",
+			    S_IRUSR | S_IWUSR,
+			    priv->debug.debugfs_phy, priv,
+			    &fops_spectral_fft_period);
+}
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index e8149e3..d3a6c09 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -1010,6 +1010,23 @@ static bool ath9k_rx_prepare(struct ath9k_htc_priv *priv,
 	 * separately to avoid doing two lookups for a rate for each frame.
 	 */
 	hdr = (struct ieee80211_hdr *)skb->data;
+
+	/* Process PHY errors and return so that the packet
+	 * can be dropped.
+	 */
+	#ifdef CONFIG_ATH9K_HTC_DEBUGFS
+	if (rx_stats.rs_status & ATH9K_RXERR_PHY) {
+		/* TODO: Not using DFS processing now. */
+		if (ath_process_fft(priv->ah, hdr, priv->hw,
+				    priv->rfs_chan_spec_scan,
+				    &rx_stats, rx_status->mactime, true)) {
+			/* TODO: Code to collect spectral scan statistics */
+		}
+
+		goto rx_next;
+	}
+	#endif
+
 	if (!ath9k_cmn_rx_accept(common, hdr, rx_status, &rx_stats,
 			&decrypt_error, priv->rxfilter))
 		goto rx_next;
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 6c9accd..bf30a52 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -847,8 +847,13 @@ static int ath9k_rx_skb_preprocess(struct ath_softc *sc,
 	 */
 	if (rx_stats->rs_status & ATH9K_RXERR_PHY) {
 		ath9k_dfs_process_phyerr(sc, hdr, rx_stats, rx_status->mactime);
-		if (ath_process_fft(sc, hdr, rx_stats, rx_status->mactime))
+
+		#ifdef CONFIG_ATH9K_DEBUGFS
+		if (ath_process_fft(sc->sc_ah, hdr, sc->hw,
+				    sc->rfs_chan_spec_scan, rx_stats,
+				    rx_status->mactime, false))
 			RX_STAT_INC(rx_spectral);
+		#endif
 
 		return -EINVAL;
 	}
-- 
1.7.5.4

