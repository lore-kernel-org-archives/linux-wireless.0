Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:42059 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932716Ab0EMVuW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 May 2010 17:50:22 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 02/17] iwlwifi: move _agn statistics related structure
Date: Thu, 13 May 2010 14:49:44 -0700
Message-Id: <1273787399-9280-3-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1273787399-9280-1-git-send-email-reinette.chatre@intel.com>
References: <1273787399-9280-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

agn and 3945 has different statistics_notif data structure; since 3945
has it statistics_notif data structure inside the _3945 portion of
iwl_priv, it make sense to move the agn statistics_notif into _agn portion.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c        |    4 +-
 drivers/net/wireless/iwlwifi/iwl-5000.c        |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c |   64 ++++++++++++------------
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c     |    3 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c         |   14 +++---
 drivers/net/wireless/iwlwifi/iwl-debugfs.c     |    9 ++--
 drivers/net/wireless/iwlwifi/iwl-dev.h         |   14 +++---
 drivers/net/wireless/iwlwifi/iwl-rx.c          |   57 +++++++++++----------
 8 files changed, 85 insertions(+), 82 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index d3afdda..03b066c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -1542,7 +1542,7 @@ static int iwl4965_hw_get_temperature(struct iwl_priv *priv)
 	u32 R4;
 
 	if (test_bit(STATUS_TEMPERATURE, &priv->status) &&
-		(priv->statistics.flag & STATISTICS_REPLY_FLG_HT40_MODE_MSK)) {
+		(priv->_agn.statistics.flag & STATISTICS_REPLY_FLG_HT40_MODE_MSK)) {
 		IWL_DEBUG_TEMP(priv, "Running HT40 temperature calibration\n");
 		R1 = (s32)le32_to_cpu(priv->card_alive_init.therm_r1[1]);
 		R2 = (s32)le32_to_cpu(priv->card_alive_init.therm_r2[1]);
@@ -1567,7 +1567,7 @@ static int iwl4965_hw_get_temperature(struct iwl_priv *priv)
 		vt = sign_extend(R4, 23);
 	else
 		vt = sign_extend(
-			le32_to_cpu(priv->statistics.general.temperature), 23);
+			le32_to_cpu(priv->_agn.statistics.general.temperature), 23);
 
 	IWL_DEBUG_TEMP(priv, "Calib values R[1-3]: %d %d %d R4: %d\n", R1, R2, R3, vt);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index a28af7e..447ec48 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -260,7 +260,7 @@ static void iwl5150_temperature(struct iwl_priv *priv)
 	u32 vt = 0;
 	s32 offset =  iwl_temp_calib_to_offset(priv);
 
-	vt = le32_to_cpu(priv->statistics.general.temperature);
+	vt = le32_to_cpu(priv->_agn.statistics.general.temperature);
 	vt = vt / IWL_5150_VOLTAGE_TO_TEMPERATURE_COEFF + offset;
 	/* now vt hold the temperature in Kelvin */
 	priv->temperature = KELVIN_TO_CELSIUS(vt);
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c
index 48c023b..90be033 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c
@@ -58,22 +58,22 @@ ssize_t iwl_ucode_rx_stats_read(struct file *file, char __user *user_buf,
 	 * the last statistics notification from uCode
 	 * might not reflect the current uCode activity
 	 */
-	ofdm = &priv->statistics.rx.ofdm;
-	cck = &priv->statistics.rx.cck;
-	general = &priv->statistics.rx.general;
-	ht = &priv->statistics.rx.ofdm_ht;
-	accum_ofdm = &priv->accum_statistics.rx.ofdm;
-	accum_cck = &priv->accum_statistics.rx.cck;
-	accum_general = &priv->accum_statistics.rx.general;
-	accum_ht = &priv->accum_statistics.rx.ofdm_ht;
-	delta_ofdm = &priv->delta_statistics.rx.ofdm;
-	delta_cck = &priv->delta_statistics.rx.cck;
-	delta_general = &priv->delta_statistics.rx.general;
-	delta_ht = &priv->delta_statistics.rx.ofdm_ht;
-	max_ofdm = &priv->max_delta.rx.ofdm;
-	max_cck = &priv->max_delta.rx.cck;
-	max_general = &priv->max_delta.rx.general;
-	max_ht = &priv->max_delta.rx.ofdm_ht;
+	ofdm = &priv->_agn.statistics.rx.ofdm;
+	cck = &priv->_agn.statistics.rx.cck;
+	general = &priv->_agn.statistics.rx.general;
+	ht = &priv->_agn.statistics.rx.ofdm_ht;
+	accum_ofdm = &priv->_agn.accum_statistics.rx.ofdm;
+	accum_cck = &priv->_agn.accum_statistics.rx.cck;
+	accum_general = &priv->_agn.accum_statistics.rx.general;
+	accum_ht = &priv->_agn.accum_statistics.rx.ofdm_ht;
+	delta_ofdm = &priv->_agn.delta_statistics.rx.ofdm;
+	delta_cck = &priv->_agn.delta_statistics.rx.cck;
+	delta_general = &priv->_agn.delta_statistics.rx.general;
+	delta_ht = &priv->_agn.delta_statistics.rx.ofdm_ht;
+	max_ofdm = &priv->_agn.max_delta.rx.ofdm;
+	max_cck = &priv->_agn.max_delta.rx.cck;
+	max_general = &priv->_agn.max_delta.rx.general;
+	max_ht = &priv->_agn.max_delta.rx.ofdm_ht;
 
 	pos += iwl_dbgfs_statistics_flag(priv, buf, bufsz);
 	pos += scnprintf(buf + pos, bufsz - pos, "%-32s     current"
@@ -539,10 +539,10 @@ ssize_t iwl_ucode_tx_stats_read(struct file *file,
 	  * the last statistics notification from uCode
 	  * might not reflect the current uCode activity
 	  */
-	tx = &priv->statistics.tx;
-	accum_tx = &priv->accum_statistics.tx;
-	delta_tx = &priv->delta_statistics.tx;
-	max_tx = &priv->max_delta.tx;
+	tx = &priv->_agn.statistics.tx;
+	accum_tx = &priv->_agn.accum_statistics.tx;
+	delta_tx = &priv->_agn.delta_statistics.tx;
+	max_tx = &priv->_agn.max_delta.tx;
 	pos += iwl_dbgfs_statistics_flag(priv, buf, bufsz);
 	pos += scnprintf(buf + pos, bufsz - pos,  "%-32s     current"
 			 "acumulative       delta         max\n",
@@ -756,18 +756,18 @@ ssize_t iwl_ucode_general_stats_read(struct file *file, char __user *user_buf,
 	  * the last statistics notification from uCode
 	  * might not reflect the current uCode activity
 	  */
-	general = &priv->statistics.general;
-	dbg = &priv->statistics.general.dbg;
-	div = &priv->statistics.general.div;
-	accum_general = &priv->accum_statistics.general;
-	delta_general = &priv->delta_statistics.general;
-	max_general = &priv->max_delta.general;
-	accum_dbg = &priv->accum_statistics.general.dbg;
-	delta_dbg = &priv->delta_statistics.general.dbg;
-	max_dbg = &priv->max_delta.general.dbg;
-	accum_div = &priv->accum_statistics.general.div;
-	delta_div = &priv->delta_statistics.general.div;
-	max_div = &priv->max_delta.general.div;
+	general = &priv->_agn.statistics.general;
+	dbg = &priv->_agn.statistics.general.dbg;
+	div = &priv->_agn.statistics.general.div;
+	accum_general = &priv->_agn.accum_statistics.general;
+	delta_general = &priv->_agn.delta_statistics.general;
+	max_general = &priv->_agn.max_delta.general;
+	accum_dbg = &priv->_agn.accum_statistics.general.dbg;
+	delta_dbg = &priv->_agn.delta_statistics.general.dbg;
+	max_dbg = &priv->_agn.max_delta.general.dbg;
+	accum_div = &priv->_agn.accum_statistics.general.div;
+	delta_div = &priv->_agn.delta_statistics.general.div;
+	max_div = &priv->_agn.max_delta.general.div;
 	pos += iwl_dbgfs_statistics_flag(priv, buf, bufsz);
 	pos += scnprintf(buf + pos, bufsz - pos, "%-32s     current"
 			 "acumulative       delta         max\n",
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 637d7b6..c7ce632 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -319,7 +319,8 @@ int iwlagn_send_tx_power(struct iwl_priv *priv)
 void iwlagn_temperature(struct iwl_priv *priv)
 {
 	/* store temperature from statistics (in Celsius) */
-	priv->temperature = le32_to_cpu(priv->statistics.general.temperature);
+	priv->temperature =
+		le32_to_cpu(priv->_agn.statistics.general.temperature);
 	iwl_tt_handler(priv);
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index d7a9aea..f62a345 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1449,13 +1449,13 @@ bool iwl_good_ack_health(struct iwl_priv *priv,
 
 	actual_ack_cnt_delta =
 		le32_to_cpu(pkt->u.stats.tx.actual_ack_cnt) -
-		le32_to_cpu(priv->statistics.tx.actual_ack_cnt);
+		le32_to_cpu(priv->_agn.statistics.tx.actual_ack_cnt);
 	expected_ack_cnt_delta =
 		le32_to_cpu(pkt->u.stats.tx.expected_ack_cnt) -
-		le32_to_cpu(priv->statistics.tx.expected_ack_cnt);
+		le32_to_cpu(priv->_agn.statistics.tx.expected_ack_cnt);
 	ba_timeout_delta =
 		le32_to_cpu(pkt->u.stats.tx.agg.ba_timeout) -
-		le32_to_cpu(priv->statistics.tx.agg.ba_timeout);
+		le32_to_cpu(priv->_agn.statistics.tx.agg.ba_timeout);
 	if ((priv->_agn.agg_tids_count > 0) &&
 	    (expected_ack_cnt_delta > 0) &&
 	    (((actual_ack_cnt_delta * 100) / expected_ack_cnt_delta)
@@ -1467,10 +1467,10 @@ bool iwl_good_ack_health(struct iwl_priv *priv,
 
 #ifdef CONFIG_IWLWIFI_DEBUG
 		IWL_DEBUG_RADIO(priv, "rx_detected_cnt delta = %d\n",
-				priv->delta_statistics.tx.rx_detected_cnt);
+				priv->_agn.delta_statistics.tx.rx_detected_cnt);
 		IWL_DEBUG_RADIO(priv,
 				"ack_or_ba_timeout_collision delta = %d\n",
-				priv->delta_statistics.tx.
+				priv->_agn.delta_statistics.tx.
 				ack_or_ba_timeout_collision);
 #endif
 		IWL_DEBUG_RADIO(priv, "agg ba_timeout delta = %d\n",
@@ -2685,9 +2685,9 @@ static void iwl_bg_run_time_calib_work(struct work_struct *work)
 	}
 
 	if (priv->start_calib) {
-		iwl_chain_noise_calibration(priv, &priv->statistics);
+		iwl_chain_noise_calibration(priv, &priv->_agn.statistics);
 
-		iwl_sensitivity_calibration(priv, &priv->statistics);
+		iwl_sensitivity_calibration(priv, &priv->_agn.statistics);
 	}
 
 	mutex_unlock(&priv->mutex);
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index 4d6de2d..c248373 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -105,16 +105,17 @@ int iwl_dbgfs_statistics_flag(struct iwl_priv *priv, char *buf, int bufsz)
 	int p = 0;
 
 	p += scnprintf(buf + p, bufsz - p, "Statistics Flag(0x%X):\n",
-		       le32_to_cpu(priv->statistics.flag));
-	if (le32_to_cpu(priv->statistics.flag) & UCODE_STATISTICS_CLEAR_MSK)
+		       le32_to_cpu(priv->_agn.statistics.flag));
+	if (le32_to_cpu(priv->_agn.statistics.flag) &
+			UCODE_STATISTICS_CLEAR_MSK)
 		p += scnprintf(buf + p, bufsz - p,
 			       "\tStatistics have been cleared\n");
 	p += scnprintf(buf + p, bufsz - p, "\tOperational Frequency: %s\n",
-		       (le32_to_cpu(priv->statistics.flag) &
+		       (le32_to_cpu(priv->_agn.statistics.flag) &
 			UCODE_STATISTICS_FREQUENCY_MSK)
 			? "2.4 GHz" : "5.2 GHz");
 	p += scnprintf(buf + p, bufsz - p, "\tTGj Narrow Band: %s\n",
-		       (le32_to_cpu(priv->statistics.flag) &
+		       (le32_to_cpu(priv->_agn.statistics.flag) &
 			UCODE_STATISTICS_NARROW_BAND_MSK)
 			? "enabled" : "disabled");
 	return p;
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index f3f3473..858a548 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1220,13 +1220,6 @@ struct iwl_priv {
 	struct iwl_power_mgr power_data;
 	struct iwl_tt_mgmt thermal_throttle;
 
-	struct iwl_notif_statistics statistics;
-#ifdef CONFIG_IWLWIFI_DEBUG
-	struct iwl_notif_statistics accum_statistics;
-	struct iwl_notif_statistics delta_statistics;
-	struct iwl_notif_statistics max_delta;
-#endif
-
 	/* context information */
 	u8 bssid[ETH_ALEN]; /* used only on 3945 but filled by core */
 	u8 mac_addr[ETH_ALEN];
@@ -1315,6 +1308,13 @@ struct iwl_priv {
 			bool last_phy_res_valid;
 
 			struct completion firmware_loading_complete;
+
+			struct iwl_notif_statistics statistics;
+#ifdef CONFIG_IWLWIFI_DEBUG
+			struct iwl_notif_statistics accum_statistics;
+			struct iwl_notif_statistics delta_statistics;
+			struct iwl_notif_statistics max_delta;
+#endif
 		} _agn;
 #endif
 	};
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index c7c8d8a..aea5cf4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -250,7 +250,7 @@ EXPORT_SYMBOL(iwl_rx_spectrum_measure_notif);
 static void iwl_rx_calc_noise(struct iwl_priv *priv)
 {
 	struct statistics_rx_non_phy *rx_info
-				= &(priv->statistics.rx.general);
+				= &(priv->_agn.statistics.rx.general);
 	int num_active_rx = 0;
 	int total_silence = 0;
 	int bcn_silence_a =
@@ -299,10 +299,10 @@ static void iwl_accumulative_statistics(struct iwl_priv *priv,
 	u32 *accum_stats;
 	u32 *delta, *max_delta;
 
-	prev_stats = (__le32 *)&priv->statistics;
-	accum_stats = (u32 *)&priv->accum_statistics;
-	delta = (u32 *)&priv->delta_statistics;
-	max_delta = (u32 *)&priv->max_delta;
+	prev_stats = (__le32 *)&priv->_agn.statistics;
+	accum_stats = (u32 *)&priv->_agn.accum_statistics;
+	delta = (u32 *)&priv->_agn.delta_statistics;
+	max_delta = (u32 *)&priv->_agn.max_delta;
 
 	for (i = sizeof(__le32); i < sizeof(struct iwl_notif_statistics);
 	     i += sizeof(__le32), stats++, prev_stats++, delta++,
@@ -317,18 +317,18 @@ static void iwl_accumulative_statistics(struct iwl_priv *priv,
 	}
 
 	/* reset accumulative statistics for "no-counter" type statistics */
-	priv->accum_statistics.general.temperature =
-		priv->statistics.general.temperature;
-	priv->accum_statistics.general.temperature_m =
-		priv->statistics.general.temperature_m;
-	priv->accum_statistics.general.ttl_timestamp =
-		priv->statistics.general.ttl_timestamp;
-	priv->accum_statistics.tx.tx_power.ant_a =
-		priv->statistics.tx.tx_power.ant_a;
-	priv->accum_statistics.tx.tx_power.ant_b =
-		priv->statistics.tx.tx_power.ant_b;
-	priv->accum_statistics.tx.tx_power.ant_c =
-		priv->statistics.tx.tx_power.ant_c;
+	priv->_agn.accum_statistics.general.temperature =
+		priv->_agn.statistics.general.temperature;
+	priv->_agn.accum_statistics.general.temperature_m =
+		priv->_agn.statistics.general.temperature_m;
+	priv->_agn.accum_statistics.general.ttl_timestamp =
+		priv->_agn.statistics.general.ttl_timestamp;
+	priv->_agn.accum_statistics.tx.tx_power.ant_a =
+		priv->_agn.statistics.tx.tx_power.ant_a;
+	priv->_agn.accum_statistics.tx.tx_power.ant_b =
+		priv->_agn.statistics.tx.tx_power.ant_b;
+	priv->_agn.accum_statistics.tx.tx_power.ant_c =
+		priv->_agn.statistics.tx.tx_power.ant_c;
 }
 #endif
 
@@ -363,9 +363,9 @@ bool iwl_good_plcp_health(struct iwl_priv *priv,
 	if (plcp_msec) {
 		combined_plcp_delta =
 			(le32_to_cpu(pkt->u.stats.rx.ofdm.plcp_err) -
-			le32_to_cpu(priv->statistics.rx.ofdm.plcp_err)) +
+			le32_to_cpu(priv->_agn.statistics.rx.ofdm.plcp_err)) +
 			(le32_to_cpu(pkt->u.stats.rx.ofdm_ht.plcp_err) -
-			le32_to_cpu(priv->statistics.rx.ofdm_ht.plcp_err));
+			le32_to_cpu(priv->_agn.statistics.rx.ofdm_ht.plcp_err));
 
 		if ((combined_plcp_delta > 0) &&
 		    ((combined_plcp_delta * 100) / plcp_msec) >
@@ -385,10 +385,10 @@ bool iwl_good_plcp_health(struct iwl_priv *priv,
 				"%u, %u, %u, %u, %d, %u mSecs\n",
 				priv->cfg->plcp_delta_threshold,
 				le32_to_cpu(pkt->u.stats.rx.ofdm.plcp_err),
-				le32_to_cpu(priv->statistics.rx.ofdm.plcp_err),
+				le32_to_cpu(priv->_agn.statistics.rx.ofdm.plcp_err),
 				le32_to_cpu(pkt->u.stats.rx.ofdm_ht.plcp_err),
 				le32_to_cpu(
-				  priv->statistics.rx.ofdm_ht.plcp_err),
+				  priv->_agn.statistics.rx.ofdm_ht.plcp_err),
 				combined_plcp_delta, plcp_msec);
 			rc = false;
 		}
@@ -438,12 +438,12 @@ void iwl_rx_statistics(struct iwl_priv *priv,
 
 
 	IWL_DEBUG_RX(priv, "Statistics notification received (%d vs %d).\n",
-		     (int)sizeof(priv->statistics),
+		     (int)sizeof(priv->_agn.statistics),
 		     le32_to_cpu(pkt->len_n_flags) & FH_RSCSR_FRAME_SIZE_MSK);
 
-	change = ((priv->statistics.general.temperature !=
+	change = ((priv->_agn.statistics.general.temperature !=
 		   pkt->u.stats.general.temperature) ||
-		  ((priv->statistics.flag &
+		  ((priv->_agn.statistics.flag &
 		    STATISTICS_REPLY_FLG_HT40_MODE_MSK) !=
 		   (pkt->u.stats.flag & STATISTICS_REPLY_FLG_HT40_MODE_MSK)));
 
@@ -452,7 +452,8 @@ void iwl_rx_statistics(struct iwl_priv *priv,
 #endif
 	iwl_recover_from_statistics(priv, pkt);
 
-	memcpy(&priv->statistics, &pkt->u.stats, sizeof(priv->statistics));
+	memcpy(&priv->_agn.statistics, &pkt->u.stats,
+		sizeof(priv->_agn.statistics));
 
 	set_bit(STATUS_STATISTICS, &priv->status);
 
@@ -480,11 +481,11 @@ void iwl_reply_statistics(struct iwl_priv *priv,
 
 	if (le32_to_cpu(pkt->u.stats.flag) & UCODE_STATISTICS_CLEAR_MSK) {
 #ifdef CONFIG_IWLWIFI_DEBUG
-		memset(&priv->accum_statistics, 0,
+		memset(&priv->_agn.accum_statistics, 0,
 			sizeof(struct iwl_notif_statistics));
-		memset(&priv->delta_statistics, 0,
+		memset(&priv->_agn.delta_statistics, 0,
 			sizeof(struct iwl_notif_statistics));
-		memset(&priv->max_delta, 0,
+		memset(&priv->_agn.max_delta, 0,
 			sizeof(struct iwl_notif_statistics));
 #endif
 		IWL_DEBUG_RX(priv, "Statistics have been cleared\n");
-- 
1.6.3.3

