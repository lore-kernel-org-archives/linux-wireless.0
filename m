Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:18558 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754962Ab0AVWXH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jan 2010 17:23:07 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 01/17] iwlwifi: configure missed beacon threshold
Date: Fri, 22 Jan 2010 14:22:42 -0800
Message-Id: <1264198978-5915-2-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1264198978-5915-1-git-send-email-reinette.chatre@intel.com>
References: <1264198978-5915-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Add support to configure missed beacon threshold, by default, if receive
"missed beacon" notification from uCode and has more than 5 consecutive
beacon missed, then perform sensitivity calibration; with this change,
allow user to adjust the missed beacon threshold from debugfs in case
more sensitivity calibration required for better performance in noisy
environment

The default value (=5) should be good enough for the normal condition,
but for very noisy environment, more sensitivity calibration could help
improve the throughput, so by setting the missed beacon threshold to
lower number, user might experience better performance result.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    1 +
 drivers/net/wireless/iwlwifi/iwl-commands.h |   25 ++++++++++++--
 drivers/net/wireless/iwlwifi/iwl-debug.h    |    1 +
 drivers/net/wireless/iwlwifi/iwl-debugfs.c  |   46 +++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    1 +
 drivers/net/wireless/iwlwifi/iwl-rx.c       |    5 ++-
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    1 +
 7 files changed, 74 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 8db8623..a1c560f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3368,6 +3368,7 @@ static int iwl_init_drv(struct iwl_priv *priv)
 
 	priv->iw_mode = NL80211_IFTYPE_STATION;
 	priv->current_ht_config.smps = IEEE80211_SMPS_STATIC;
+	priv->missed_beacon_threshold = IWL_MISSED_BEACON_THRESHOLD_DEF;
 
 	/* Choose which receivers/antennas to use */
 	if (priv->cfg->ops->hcmd->set_rxon_chain)
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index cee5fb2..8823d18 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -3165,13 +3165,30 @@ struct iwl_notif_statistics {
 
 /*
  * MISSED_BEACONS_NOTIFICATION = 0xa2 (notification only, not a command)
+ *
+ * uCode send MISSED_BEACONS_NOTIFICATION to driver when detect beacon missed
+ * in regardless of how many missed beacons, which mean when driver receive the
+ * notification, inside the command, it can find all the beacons information
+ * which include number of total missed beacons, number of consecutive missed
+ * beacons, number of beacons received and number of beacons expected to
+ * receive.
+ *
+ * If uCode detected consecutive_missed_beacons > 5, it will reset the radio
+ * in order to bring the radio/PHY back to working state; which has no relation
+ * to when driver will perform sensitivity calibration.
+ *
+ * Driver should set it own missed_beacon_threshold to decide when to perform
+ * sensitivity calibration based on number of consecutive missed beacons in
+ * order to improve overall performance, especially in noisy environment.
+ *
  */
-/* if ucode missed CONSECUTIVE_MISSED_BCONS_TH beacons in a row,
- * then this notification will be sent. */
-#define CONSECUTIVE_MISSED_BCONS_TH 20
+
+#define IWL_MISSED_BEACON_THRESHOLD_MIN	(1)
+#define IWL_MISSED_BEACON_THRESHOLD_DEF	(5)
+#define IWL_MISSED_BEACON_THRESHOLD_MAX	IWL_MISSED_BEACON_THRESHOLD_DEF
 
 struct iwl_missed_beacon_notif {
-	__le32 consequtive_missed_beacons;
+	__le32 consecutive_missed_beacons;
 	__le32 total_missed_becons;
 	__le32 num_expected_beacons;
 	__le32 num_recvd_beacons;
diff --git a/drivers/net/wireless/iwlwifi/iwl-debug.h b/drivers/net/wireless/iwlwifi/iwl-debug.h
index 0facaca..36b558f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debug.h
+++ b/drivers/net/wireless/iwlwifi/iwl-debug.h
@@ -112,6 +112,7 @@ struct iwl_debugfs {
 		struct dentry *file_csr;
 		struct dentry *file_ucode_tracing;
 		struct dentry *file_fh_reg;
+		struct dentry *file_missed_beacon;
 	} dbgfs_debug_files;
 	u32 sram_offset;
 	u32 sram_len;
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index af00ad2..02f80bc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -2131,6 +2131,49 @@ static ssize_t iwl_dbgfs_fh_reg_read(struct file *file,
 	return ret;
 }
 
+static ssize_t iwl_dbgfs_missed_beacon_read(struct file *file,
+					char __user *user_buf,
+					size_t count, loff_t *ppos) {
+
+	struct iwl_priv *priv = file->private_data;
+	int pos = 0;
+	char buf[12];
+	const size_t bufsz = sizeof(buf);
+	ssize_t ret;
+
+	pos += scnprintf(buf + pos, bufsz - pos, "%d\n",
+			priv->missed_beacon_threshold);
+
+	ret = simple_read_from_buffer(user_buf, count, ppos, buf, pos);
+	return ret;
+}
+
+static ssize_t iwl_dbgfs_missed_beacon_write(struct file *file,
+					 const char __user *user_buf,
+					 size_t count, loff_t *ppos)
+{
+	struct iwl_priv *priv = file->private_data;
+	char buf[8];
+	int buf_size;
+	int missed;
+
+	memset(buf, 0, sizeof(buf));
+	buf_size = min(count, sizeof(buf) -  1);
+	if (copy_from_user(buf, user_buf, buf_size))
+		return -EFAULT;
+	if (sscanf(buf, "%d", &missed) != 1)
+		return -EINVAL;
+
+	if (missed < IWL_MISSED_BEACON_THRESHOLD_MIN ||
+	    missed > IWL_MISSED_BEACON_THRESHOLD_MAX)
+		priv->missed_beacon_threshold =
+			IWL_MISSED_BEACON_THRESHOLD_DEF;
+	else
+		priv->missed_beacon_threshold = missed;
+
+	return count;
+}
+
 DEBUGFS_READ_FILE_OPS(rx_statistics);
 DEBUGFS_READ_FILE_OPS(tx_statistics);
 DEBUGFS_READ_WRITE_FILE_OPS(traffic_log);
@@ -2148,6 +2191,7 @@ DEBUGFS_WRITE_FILE_OPS(clear_traffic_statistics);
 DEBUGFS_WRITE_FILE_OPS(csr);
 DEBUGFS_READ_WRITE_FILE_OPS(ucode_tracing);
 DEBUGFS_READ_FILE_OPS(fh_reg);
+DEBUGFS_READ_WRITE_FILE_OPS(missed_beacon);
 
 /*
  * Create the debugfs files and directories
@@ -2200,6 +2244,7 @@ int iwl_dbgfs_register(struct iwl_priv *priv, const char *name)
 	DEBUGFS_ADD_FILE(clear_traffic_statistics, debug, S_IWUSR);
 	DEBUGFS_ADD_FILE(csr, debug, S_IWUSR);
 	DEBUGFS_ADD_FILE(fh_reg, debug, S_IRUSR);
+	DEBUGFS_ADD_FILE(missed_beacon, debug, S_IWUSR);
 	if ((priv->hw_rev & CSR_HW_REV_TYPE_MSK) != CSR_HW_REV_TYPE_3945) {
 		DEBUGFS_ADD_FILE(ucode_rx_stats, debug, S_IRUSR);
 		DEBUGFS_ADD_FILE(ucode_tx_stats, debug, S_IRUSR);
@@ -2260,6 +2305,7 @@ void iwl_dbgfs_unregister(struct iwl_priv *priv)
 			file_clear_traffic_statistics);
 	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_debug_files.file_csr);
 	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_debug_files.file_fh_reg);
+	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_debug_files.file_missed_beacon);
 	if ((priv->hw_rev & CSR_HW_REV_TYPE_MSK) != CSR_HW_REV_TYPE_3945) {
 		DEBUGFS_REMOVE(priv->dbgfs->dbgfs_debug_files.
 			file_ucode_rx_stats);
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index c6310b0..5e06e66 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1053,6 +1053,7 @@ struct iwl_priv {
 #endif
 	/* ucode beacon time */
 	u32 ucode_beacon_time;
+	int missed_beacon_threshold;
 
 	/* we allocate array of iwl4965_channel_info for NIC's valid channels.
 	 *    Access via channel # using indirect index array */
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index eb45f8b..dc06c7b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -499,9 +499,10 @@ void iwl_rx_missed_beacon_notif(struct iwl_priv *priv,
 	struct iwl_missed_beacon_notif *missed_beacon;
 
 	missed_beacon = &pkt->u.missed_beacon;
-	if (le32_to_cpu(missed_beacon->consequtive_missed_beacons) > 5) {
+	if (le32_to_cpu(missed_beacon->consecutive_missed_beacons) >
+	    priv->missed_beacon_threshold) {
 		IWL_DEBUG_CALIB(priv, "missed bcn cnsq %d totl %d rcd %d expctd %d\n",
-		    le32_to_cpu(missed_beacon->consequtive_missed_beacons),
+		    le32_to_cpu(missed_beacon->consecutive_missed_beacons),
 		    le32_to_cpu(missed_beacon->total_missed_becons),
 		    le32_to_cpu(missed_beacon->num_recvd_beacons),
 		    le32_to_cpu(missed_beacon->num_expected_beacons));
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index c46f988..9c0b6eb 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -3881,6 +3881,7 @@ static int iwl3945_init_drv(struct iwl_priv *priv)
 	priv->band = IEEE80211_BAND_2GHZ;
 
 	priv->iw_mode = NL80211_IFTYPE_STATION;
+	priv->missed_beacon_threshold = IWL_MISSED_BEACON_THRESHOLD_DEF;
 
 	iwl_reset_qos(priv);
 
-- 
1.6.3.3

