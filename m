Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:54587 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754923Ab2CDUm6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Mar 2012 15:42:58 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 008/101] iwlwifi: introduce statistics lock
Date: Sun,  4 Mar 2012 11:28:22 -0800
Message-Id: <1330889395-533-9-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120304_214649_305192_472A0230)
In-Reply-To: <1330889395-533-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1330889395-533-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The statistics are currently only half-heartedly
locked against concurrent reading & modification
so introduce a lock to really protect them.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-calib.c |   16 +++++++---------
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c   |    2 ++
 drivers/net/wireless/iwlwifi/iwl-agn-rx.c    |    8 ++++++++
 drivers/net/wireless/iwlwifi/iwl-agn.c       |    1 +
 drivers/net/wireless/iwlwifi/iwl-debugfs.c   |   21 +++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-dev.h       |    1 +
 6 files changed, 40 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-calib.c b/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
index 988ee45..12acc81 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
@@ -655,7 +655,6 @@ void iwl_sensitivity_calibration(struct iwl_priv *priv)
 	struct iwl_sensitivity_data *data = NULL;
 	struct statistics_rx_non_phy *rx_info;
 	struct statistics_rx_phy *ofdm, *cck;
-	unsigned long flags;
 	struct statistics_general_data statis;
 
 	if (priv->disable_sens_cal)
@@ -668,13 +667,13 @@ void iwl_sensitivity_calibration(struct iwl_priv *priv)
 		return;
 	}
 
-	spin_lock_irqsave(&priv->shrd->lock, flags);
+	spin_lock_bh(&priv->statistics.lock);
 	rx_info = &priv->statistics.rx_non_phy;
 	ofdm = &priv->statistics.rx_ofdm;
 	cck = &priv->statistics.rx_cck;
 	if (rx_info->interference_data_flag != INTERFERENCE_DATA_AVAILABLE) {
 		IWL_DEBUG_CALIB(priv, "<< invalid data.\n");
-		spin_unlock_irqrestore(&priv->shrd->lock, flags);
+		spin_unlock_bh(&priv->statistics.lock);
 		return;
 	}
 
@@ -698,7 +697,7 @@ void iwl_sensitivity_calibration(struct iwl_priv *priv)
 	statis.beacon_energy_c =
 			le32_to_cpu(rx_info->beacon_energy_c);
 
-	spin_unlock_irqrestore(&priv->shrd->lock, flags);
+	spin_unlock_bh(&priv->statistics.lock);
 
 	IWL_DEBUG_CALIB(priv, "rx_enable_time = %u usecs\n", rx_enable_time);
 
@@ -958,7 +957,6 @@ void iwl_chain_noise_calibration(struct iwl_priv *priv)
 	u16 stat_chnum = INITIALIZATION_VALUE;
 	u8 rxon_band24;
 	u8 stat_band24;
-	unsigned long flags;
 	struct statistics_rx_non_phy *rx_info;
 
 	/*
@@ -983,13 +981,13 @@ void iwl_chain_noise_calibration(struct iwl_priv *priv)
 		return;
 	}
 
-	spin_lock_irqsave(&priv->shrd->lock, flags);
+	spin_lock_bh(&priv->statistics.lock);
 
 	rx_info = &priv->statistics.rx_non_phy;
 
 	if (rx_info->interference_data_flag != INTERFERENCE_DATA_AVAILABLE) {
 		IWL_DEBUG_CALIB(priv, " << Interference data unavailable\n");
-		spin_unlock_irqrestore(&priv->shrd->lock, flags);
+		spin_unlock_bh(&priv->statistics.lock);
 		return;
 	}
 
@@ -1004,7 +1002,7 @@ void iwl_chain_noise_calibration(struct iwl_priv *priv)
 	if ((rxon_chnum != stat_chnum) || (rxon_band24 != stat_band24)) {
 		IWL_DEBUG_CALIB(priv, "Stats not from chan=%d, band24=%d\n",
 				rxon_chnum, rxon_band24);
-		spin_unlock_irqrestore(&priv->shrd->lock, flags);
+		spin_unlock_bh(&priv->statistics.lock);
 		return;
 	}
 
@@ -1023,7 +1021,7 @@ void iwl_chain_noise_calibration(struct iwl_priv *priv)
 	chain_sig_b = le32_to_cpu(rx_info->beacon_rssi_b) & IN_BAND_FILTER;
 	chain_sig_c = le32_to_cpu(rx_info->beacon_rssi_c) & IN_BAND_FILTER;
 
-	spin_unlock_irqrestore(&priv->shrd->lock, flags);
+	spin_unlock_bh(&priv->statistics.lock);
 
 	data->beacon_count++;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 5be0d36..0f8dd0f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -88,6 +88,8 @@ int iwlagn_send_tx_power(struct iwl_priv *priv)
 
 void iwlagn_temperature(struct iwl_priv *priv)
 {
+	lockdep_assert_held(&priv->statistics.lock);
+
 	/* store temperature from correct statistics (in Celsius) */
 	priv->temperature = le32_to_cpu(priv->statistics.common.temperature);
 	iwl_tt_handler(priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rx.c b/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
index 30bb5bb..bc21586 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
@@ -266,6 +266,8 @@ static bool iwlagn_good_ack_health(struct iwl_priv *priv,
 	if (priv->agg_tids_count)
 		return true;
 
+	lockdep_assert_held(&priv->statistics.lock);
+
 	old = &priv->statistics.tx;
 
 	actual_delta = le32_to_cpu(cur->actual_ack_cnt) -
@@ -509,6 +511,8 @@ static int iwlagn_rx_statistics(struct iwl_priv *priv,
 	IWL_DEBUG_RX(priv, "Statistics notification received (%d bytes).\n",
 		     len);
 
+	spin_lock(&priv->statistics.lock);
+
 	if (len == sizeof(struct iwl_bt_notif_statistics)) {
 		struct iwl_bt_notif_statistics *stats;
 		stats = &pkt->u.stats_bt;
@@ -542,6 +546,7 @@ static int iwlagn_rx_statistics(struct iwl_priv *priv,
 		WARN_ONCE(1, "len %d doesn't match BT (%zu) or normal (%zu)\n",
 			  len, sizeof(struct iwl_bt_notif_statistics),
 			  sizeof(struct iwl_notif_statistics));
+		spin_unlock(&priv->statistics.lock);
 		return 0;
 	}
 
@@ -585,6 +590,9 @@ static int iwlagn_rx_statistics(struct iwl_priv *priv,
 	}
 	if (cfg(priv)->lib->temperature && change)
 		cfg(priv)->lib->temperature(priv);
+
+	spin_unlock(&priv->statistics.lock);
+
 	return 0;
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 0090fab..47c7886 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1233,6 +1233,7 @@ static struct iwl_op_mode *iwl_op_mode_dvm_start(struct iwl_trans *trans)
 	 */
 	spin_lock_init(&trans(priv)->reg_lock);
 	spin_lock_init(&priv->shrd->lock);
+	spin_lock_init(&priv->statistics.lock);
 
 	/***********************
 	 * 3. Read REV register
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index ad74138..628af56 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -920,6 +920,8 @@ static int iwl_statistics_flag(struct iwl_priv *priv, char *buf, int bufsz)
 	int p = 0;
 	u32 flag;
 
+	lockdep_assert_held(&priv->statistics.lock);
+
 	flag = le32_to_cpu(priv->statistics.flag);
 
 	p += scnprintf(buf + p, bufsz - p, "Statistics Flag(0x%X):\n", flag);
@@ -967,6 +969,7 @@ static ssize_t iwl_dbgfs_ucode_rx_stats_read(struct file *file,
 	 * the last statistics notification from uCode
 	 * might not reflect the current uCode activity
 	 */
+	spin_lock_bh(&priv->statistics.lock);
 	ofdm = &priv->statistics.rx_ofdm;
 	cck = &priv->statistics.rx_cck;
 	general = &priv->statistics.rx_non_phy;
@@ -1363,6 +1366,8 @@ static ssize_t iwl_dbgfs_ucode_rx_stats_read(struct file *file,
 			 accum_ht->unsupport_mcs,
 			 delta_ht->unsupport_mcs, max_ht->unsupport_mcs);
 
+	spin_unlock_bh(&priv->statistics.lock);
+
 	ret = simple_read_from_buffer(user_buf, count, ppos, buf, pos);
 	kfree(buf);
 	return ret;
@@ -1392,6 +1397,8 @@ static ssize_t iwl_dbgfs_ucode_tx_stats_read(struct file *file,
 	 * the last statistics notification from uCode
 	 * might not reflect the current uCode activity
 	 */
+	spin_lock_bh(&priv->statistics.lock);
+
 	tx = &priv->statistics.tx;
 	accum_tx = &priv->accum_stats.tx;
 	delta_tx = &priv->delta_stats.tx;
@@ -1554,6 +1561,9 @@ static ssize_t iwl_dbgfs_ucode_tx_stats_read(struct file *file,
 					fmt_hex, "antenna C:",
 					tx->tx_power.ant_c);
 	}
+
+	spin_unlock_bh(&priv->statistics.lock);
+
 	ret = simple_read_from_buffer(user_buf, count, ppos, buf, pos);
 	kfree(buf);
 	return ret;
@@ -1586,6 +1596,9 @@ static ssize_t iwl_dbgfs_ucode_general_stats_read(struct file *file,
 	 * the last statistics notification from uCode
 	 * might not reflect the current uCode activity
 	 */
+
+	spin_lock_bh(&priv->statistics.lock);
+
 	general = &priv->statistics.common;
 	dbg = &priv->statistics.common.dbg;
 	div = &priv->statistics.common.div;
@@ -1670,6 +1683,9 @@ static ssize_t iwl_dbgfs_ucode_general_stats_read(struct file *file,
 			 accum_general->num_of_sos_states,
 			 delta_general->num_of_sos_states,
 			 max_general->num_of_sos_states);
+
+	spin_unlock_bh(&priv->statistics.lock);
+
 	ret = simple_read_from_buffer(user_buf, count, ppos, buf, pos);
 	kfree(buf);
 	return ret;
@@ -1713,6 +1729,9 @@ static ssize_t iwl_dbgfs_ucode_bt_stats_read(struct file *file,
 	 * the last statistics notification from uCode
 	 * might not reflect the current uCode activity
 	 */
+
+	spin_lock_bh(&priv->statistics.lock);
+
 	bt = &priv->statistics.bt_activity;
 	accum_bt = &priv->accum_stats.bt_activity;
 
@@ -1758,6 +1777,8 @@ static ssize_t iwl_dbgfs_ucode_bt_stats_read(struct file *file,
 			 le32_to_cpu(priv->statistics.num_bt_kills),
 			 priv->statistics.accum_num_bt_kills);
 
+	spin_unlock_bh(&priv->statistics.lock);
+
 	ret = simple_read_from_buffer(user_buf, count, ppos, buf, pos);
 	kfree(buf);
 	return ret;
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index dc57522..daf2330 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -851,6 +851,7 @@ struct iwl_priv {
 		struct statistics_bt_activity bt_activity;
 		__le32 num_bt_kills, accum_num_bt_kills;
 #endif
+		spinlock_t lock;
 	} statistics;
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 	struct {
-- 
1.7.0.4

