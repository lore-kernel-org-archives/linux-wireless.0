Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:18558 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754981Ab0AVWXJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jan 2010 17:23:09 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Trieu 'Andrew' Nguyen <trieux.t.nguyen@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 05/17] iwlwifi: Tune radio to prevent unexpected behavior
Date: Fri, 22 Jan 2010 14:22:46 -0800
Message-Id: <1264198978-5915-6-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1264198978-5915-1-git-send-email-reinette.chatre@intel.com>
References: <1264198978-5915-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Trieu 'Andrew' Nguyen <trieux.t.nguyen@intel.com>

We have seen the throughput dropped due to external noisy environment
and the radio is out of tune.  There are lot of plcp errors indicating
this condition. Eventually the station can get de-authenticated by the
Access Point.  By resetting and tuning the radio, the plcp errors are
reduced or eliminated and the throughput starts to rise.

To prevent unexpected behavior such as drop in throughput or deauthentication,
- The change provides the driver feature to monitor and tune the radio base on
the statistics notification from the uCode.
- It also allows the setting of the plcp error rate threshold via
the plcp_delta under debugfs interface.

Signed-off-by: Trieu 'Andrew' Nguyen <trieux.t.nguyen@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c    |    2 +
 drivers/net/wireless/iwlwifi/iwl-3945.c    |    2 +
 drivers/net/wireless/iwlwifi/iwl-4965.c    |    1 +
 drivers/net/wireless/iwlwifi/iwl-5000.c    |    7 ++++
 drivers/net/wireless/iwlwifi/iwl-6000.c    |    6 +++
 drivers/net/wireless/iwlwifi/iwl-core.h    |    3 ++
 drivers/net/wireless/iwlwifi/iwl-debug.h   |    1 +
 drivers/net/wireless/iwlwifi/iwl-debugfs.c |   44 ++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-dev.h     |   12 ++++++
 drivers/net/wireless/iwlwifi/iwl-rx.c      |   54 ++++++++++++++++++++++++++++
 10 files changed, 132 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index d5c6edb..85162e2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -175,6 +175,7 @@ struct iwl_cfg iwl1000_bgn_cfg = {
 	.use_rts_for_ht = true, /* use rts/cts protection */
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
 	.support_ct_kill_exit = true,
+	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DEF,
 };
 
 struct iwl_cfg iwl1000_bg_cfg = {
@@ -201,6 +202,7 @@ struct iwl_cfg iwl1000_bg_cfg = {
 	.led_compensation = 51,
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
 	.support_ct_kill_exit = true,
+	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DEF,
 };
 
 MODULE_FIRMWARE(IWL1000_MODULE_FIRMWARE(IWL1000_UCODE_API_MAX));
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 6472910..764479f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -2830,6 +2830,7 @@ static struct iwl_cfg iwl3945_bg_cfg = {
 	.ht_greenfield_support = false,
 	.led_compensation = 64,
 	.broken_powersave = true,
+	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DEF,
 };
 
 static struct iwl_cfg iwl3945_abg_cfg = {
@@ -2847,6 +2848,7 @@ static struct iwl_cfg iwl3945_abg_cfg = {
 	.ht_greenfield_support = false,
 	.led_compensation = 64,
 	.broken_powersave = true,
+	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DEF,
 };
 
 struct pci_device_id iwl3945_hw_card_ids[] = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 8159a0f..c36fef9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -2239,6 +2239,7 @@ struct iwl_cfg iwl4965_agn_cfg = {
 	.broken_powersave = true,
 	.led_compensation = 61,
 	.chain_noise_num_beacons = IWL4965_CAL_NUM_BEACONS,
+	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DEF,
 };
 
 /* Module firmware */
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index aab6cf2..cbbc0e4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -1603,6 +1603,7 @@ struct iwl_cfg iwl5300_agn_cfg = {
 	.led_compensation = 51,
 	.use_rts_for_ht = true, /* use rts/cts protection */
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
+	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_LONG_THRESHOLD_DEF,
 };
 
 struct iwl_cfg iwl5100_bgn_cfg = {
@@ -1627,6 +1628,7 @@ struct iwl_cfg iwl5100_bgn_cfg = {
 	.led_compensation = 51,
 	.use_rts_for_ht = true, /* use rts/cts protection */
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
+	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_LONG_THRESHOLD_DEF,
 };
 
 struct iwl_cfg iwl5100_abg_cfg = {
@@ -1649,6 +1651,7 @@ struct iwl_cfg iwl5100_abg_cfg = {
 	.use_bsm = false,
 	.led_compensation = 51,
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
+	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_LONG_THRESHOLD_DEF,
 };
 
 struct iwl_cfg iwl5100_agn_cfg = {
@@ -1673,6 +1676,7 @@ struct iwl_cfg iwl5100_agn_cfg = {
 	.led_compensation = 51,
 	.use_rts_for_ht = true, /* use rts/cts protection */
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
+	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_LONG_THRESHOLD_DEF,
 };
 
 struct iwl_cfg iwl5350_agn_cfg = {
@@ -1697,6 +1701,7 @@ struct iwl_cfg iwl5350_agn_cfg = {
 	.led_compensation = 51,
 	.use_rts_for_ht = true, /* use rts/cts protection */
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
+	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_LONG_THRESHOLD_DEF,
 };
 
 struct iwl_cfg iwl5150_agn_cfg = {
@@ -1721,6 +1726,7 @@ struct iwl_cfg iwl5150_agn_cfg = {
 	.led_compensation = 51,
 	.use_rts_for_ht = true, /* use rts/cts protection */
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
+	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_LONG_THRESHOLD_DEF,
 };
 
 struct iwl_cfg iwl5150_abg_cfg = {
@@ -1743,6 +1749,7 @@ struct iwl_cfg iwl5150_abg_cfg = {
 	.use_bsm = false,
 	.led_compensation = 51,
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
+	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_LONG_THRESHOLD_DEF,
 };
 
 MODULE_FIRMWARE(IWL5000_MODULE_FIRMWARE(IWL5000_UCODE_API_MAX));
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 4dab7f1..b191c63 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -308,6 +308,7 @@ struct iwl_cfg iwl6000i_2agn_cfg = {
 	.supports_idle = true,
 	.adv_thermal_throttle = true,
 	.support_ct_kill_exit = true,
+	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DEF,
 };
 
 struct iwl_cfg iwl6000i_2abg_cfg = {
@@ -337,6 +338,7 @@ struct iwl_cfg iwl6000i_2abg_cfg = {
 	.supports_idle = true,
 	.adv_thermal_throttle = true,
 	.support_ct_kill_exit = true,
+	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DEF,
 };
 
 struct iwl_cfg iwl6000i_2bg_cfg = {
@@ -366,6 +368,7 @@ struct iwl_cfg iwl6000i_2bg_cfg = {
 	.supports_idle = true,
 	.adv_thermal_throttle = true,
 	.support_ct_kill_exit = true,
+	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DEF,
 };
 
 struct iwl_cfg iwl6050_2agn_cfg = {
@@ -396,6 +399,7 @@ struct iwl_cfg iwl6050_2agn_cfg = {
 	.supports_idle = true,
 	.adv_thermal_throttle = true,
 	.support_ct_kill_exit = true,
+	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DEF,
 };
 
 struct iwl_cfg iwl6050_2abg_cfg = {
@@ -425,6 +429,7 @@ struct iwl_cfg iwl6050_2abg_cfg = {
 	.supports_idle = true,
 	.adv_thermal_throttle = true,
 	.support_ct_kill_exit = true,
+	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DEF,
 };
 
 struct iwl_cfg iwl6000_3agn_cfg = {
@@ -455,6 +460,7 @@ struct iwl_cfg iwl6000_3agn_cfg = {
 	.supports_idle = true,
 	.adv_thermal_throttle = true,
 	.support_ct_kill_exit = true,
+	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DEF,
 };
 
 MODULE_FIRMWARE(IWL6000_MODULE_FIRMWARE(IWL6000_UCODE_API_MAX));
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 6de83d1..6619183 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -232,6 +232,8 @@ struct iwl_mod_params {
  * @adv_thermal_throttle: support advance thermal throttle
  * @support_ct_kill_exit: support ct kill exit condition
  * @support_wimax_coexist: support wimax/wifi co-exist
+ * @plcp_delta_threshold: plcp error rate threshold used to trigger
+ *	radio tuning when there is a high receiving plcp error rate
  *
  * We enable the driver to be backward compatible wrt API version. The
  * driver specifies which APIs it supports (with @ucode_api_max being the
@@ -288,6 +290,7 @@ struct iwl_cfg {
 	bool adv_thermal_throttle;
 	bool support_ct_kill_exit;
 	const bool support_wimax_coexist;
+	u8 plcp_delta_threshold;
 };
 
 /***************************
diff --git a/drivers/net/wireless/iwlwifi/iwl-debug.h b/drivers/net/wireless/iwlwifi/iwl-debug.h
index d81b4f3..aff1dc0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debug.h
+++ b/drivers/net/wireless/iwlwifi/iwl-debug.h
@@ -114,6 +114,7 @@ struct iwl_debugfs {
 		struct dentry *file_fh_reg;
 		struct dentry *file_missed_beacon;
 		struct dentry *file_internal_scan;
+		struct dentry *file_plcp_delta;
 	} dbgfs_debug_files;
 	u32 sram_offset;
 	u32 sram_len;
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index 4944fdb..3f9c039 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -2195,6 +2195,47 @@ static ssize_t iwl_dbgfs_internal_scan_write(struct file *file,
 	return count;
 }
 
+static ssize_t iwl_dbgfs_plcp_delta_read(struct file *file,
+					char __user *user_buf,
+					size_t count, loff_t *ppos) {
+
+	struct iwl_priv *priv = (struct iwl_priv *)file->private_data;
+	int pos = 0;
+	char buf[12];
+	const size_t bufsz = sizeof(buf);
+	ssize_t ret;
+
+	pos += scnprintf(buf + pos, bufsz - pos, "%u\n",
+			priv->cfg->plcp_delta_threshold);
+
+	ret = simple_read_from_buffer(user_buf, count, ppos, buf, pos);
+	return ret;
+}
+
+static ssize_t iwl_dbgfs_plcp_delta_write(struct file *file,
+					const char __user *user_buf,
+					size_t count, loff_t *ppos) {
+
+	struct iwl_priv *priv = file->private_data;
+	char buf[8];
+	int buf_size;
+	int plcp;
+
+	memset(buf, 0, sizeof(buf));
+	buf_size = min(count, sizeof(buf) -  1);
+	if (copy_from_user(buf, user_buf, buf_size))
+		return -EFAULT;
+	if (sscanf(buf, "%d", &plcp) != 1)
+		return -EINVAL;
+	if ((plcp <= IWL_MAX_PLCP_ERR_THRESHOLD_MIN) ||
+		(plcp > IWL_MAX_PLCP_ERR_THRESHOLD_MAX))
+		priv->cfg->plcp_delta_threshold =
+			IWL_MAX_PLCP_ERR_THRESHOLD_DEF;
+	else
+		priv->cfg->plcp_delta_threshold = plcp;
+	return count;
+}
+
 DEBUGFS_READ_FILE_OPS(rx_statistics);
 DEBUGFS_READ_FILE_OPS(tx_statistics);
 DEBUGFS_READ_WRITE_FILE_OPS(traffic_log);
@@ -2214,6 +2255,7 @@ DEBUGFS_READ_WRITE_FILE_OPS(ucode_tracing);
 DEBUGFS_READ_FILE_OPS(fh_reg);
 DEBUGFS_READ_WRITE_FILE_OPS(missed_beacon);
 DEBUGFS_WRITE_FILE_OPS(internal_scan);
+DEBUGFS_READ_WRITE_FILE_OPS(plcp_delta);
 
 /*
  * Create the debugfs files and directories
@@ -2268,6 +2310,7 @@ int iwl_dbgfs_register(struct iwl_priv *priv, const char *name)
 	DEBUGFS_ADD_FILE(fh_reg, debug, S_IRUSR);
 	DEBUGFS_ADD_FILE(missed_beacon, debug, S_IWUSR);
 	DEBUGFS_ADD_FILE(internal_scan, debug, S_IWUSR);
+	DEBUGFS_ADD_FILE(plcp_delta, debug, S_IWUSR | S_IRUSR);
 	if ((priv->hw_rev & CSR_HW_REV_TYPE_MSK) != CSR_HW_REV_TYPE_3945) {
 		DEBUGFS_ADD_FILE(ucode_rx_stats, debug, S_IRUSR);
 		DEBUGFS_ADD_FILE(ucode_tx_stats, debug, S_IRUSR);
@@ -2330,6 +2373,7 @@ void iwl_dbgfs_unregister(struct iwl_priv *priv)
 	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_debug_files.file_fh_reg);
 	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_debug_files.file_missed_beacon);
 	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_debug_files.file_internal_scan);
+	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_debug_files.file_plcp_delta);
 	if ((priv->hw_rev & CSR_HW_REV_TYPE_MSK) != CSR_HW_REV_TYPE_3945) {
 		DEBUGFS_REMOVE(priv->dbgfs->dbgfs_debug_files.
 			file_ucode_rx_stats);
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 86d38ae..a1f3ecb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1026,6 +1026,15 @@ struct iwl_event_log {
 #define IWL_HOST_INT_CALIB_TIMEOUT_DEF	(0x10)
 #define IWL_HOST_INT_CALIB_TIMEOUT_MIN	(0x0)
 
+/*
+ * This is the threshold value of plcp error rate per 100mSecs.  It is
+ * used to set and check for the validity of plcp_delta.
+ */
+#define IWL_MAX_PLCP_ERR_THRESHOLD_MIN	(0)
+#define IWL_MAX_PLCP_ERR_THRESHOLD_DEF	(50)
+#define IWL_MAX_PLCP_ERR_LONG_THRESHOLD_DEF	(100)
+#define IWL_MAX_PLCP_ERR_THRESHOLD_MAX	(255)
+
 struct iwl_priv {
 
 	/* ieee device used by generic ieee processing code */
@@ -1055,6 +1064,9 @@ struct iwl_priv {
 	u32 ucode_beacon_time;
 	int missed_beacon_threshold;
 
+	/* storing the jiffies when the plcp error rate is received */
+	unsigned long plcp_jiffies;
+
 	/* we allocate array of iwl4965_channel_info for NIC's valid channels.
 	 *    Access via channel # using indirect index array */
 	struct iwl_channel_info *channel_info;	/* channel info array */
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index dc06c7b..ea309f4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -602,11 +602,15 @@ static void iwl_accumulative_statistics(struct iwl_priv *priv,
 
 #define REG_RECALIB_PERIOD (60)
 
+#define PLCP_MSG "plcp_err exceeded %u, %u, %u, %u, %u, %d, %u mSecs\n"
 void iwl_rx_statistics(struct iwl_priv *priv,
 			      struct iwl_rx_mem_buffer *rxb)
 {
 	int change;
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
+	int combined_plcp_delta;
+	unsigned int plcp_msec;
+	unsigned long plcp_received_jiffies;
 
 	IWL_DEBUG_RX(priv, "Statistics notification received (%d vs %d).\n",
 		     (int)sizeof(priv->statistics),
@@ -621,6 +625,56 @@ void iwl_rx_statistics(struct iwl_priv *priv,
 #ifdef CONFIG_IWLWIFI_DEBUG
 	iwl_accumulative_statistics(priv, (__le32 *)&pkt->u.stats);
 #endif
+	/*
+	 * check for plcp_err and trigger radio reset if it exceeds
+	 * the plcp error threshold plcp_delta.
+	 */
+	plcp_received_jiffies = jiffies;
+	plcp_msec = jiffies_to_msecs((long) plcp_received_jiffies -
+					(long) priv->plcp_jiffies);
+	priv->plcp_jiffies = plcp_received_jiffies;
+	/*
+	 * check to make sure plcp_msec is not 0 to prevent division
+	 * by zero.
+	 */
+	if (plcp_msec) {
+		combined_plcp_delta =
+			(le32_to_cpu(pkt->u.stats.rx.ofdm.plcp_err) -
+			le32_to_cpu(priv->statistics.rx.ofdm.plcp_err)) +
+			(le32_to_cpu(pkt->u.stats.rx.ofdm_ht.plcp_err) -
+			le32_to_cpu(priv->statistics.rx.ofdm_ht.plcp_err));
+
+		if ((combined_plcp_delta > 0) &&
+			((combined_plcp_delta * 100) / plcp_msec) >
+			priv->cfg->plcp_delta_threshold) {
+			/*
+			 * if plcp_err exceed the threshold, the following
+			 * data is printed in csv format:
+			 *    Text: plcp_err exceeded %d,
+			 *    Received ofdm.plcp_err,
+			 *    Current ofdm.plcp_err,
+			 *    Received ofdm_ht.plcp_err,
+			 *    Current ofdm_ht.plcp_err,
+			 *    combined_plcp_delta,
+			 *    plcp_msec
+			 */
+			IWL_DEBUG_RADIO(priv, PLCP_MSG,
+				priv->cfg->plcp_delta_threshold,
+				le32_to_cpu(pkt->u.stats.rx.ofdm.plcp_err),
+				le32_to_cpu(priv->statistics.rx.ofdm.plcp_err),
+				le32_to_cpu(pkt->u.stats.rx.ofdm_ht.plcp_err),
+				le32_to_cpu(
+					priv->statistics.rx.ofdm_ht.plcp_err),
+				combined_plcp_delta, plcp_msec);
+
+			/*
+			 * Reset the RF radio due to the high plcp
+			 * error rate
+			 */
+			iwl_force_rf_reset(priv);
+		}
+	}
+
 	memcpy(&priv->statistics, &pkt->u.stats, sizeof(priv->statistics));
 
 	set_bit(STATUS_STATISTICS, &priv->status);
-- 
1.6.3.3

