Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:13418 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759919AbXG3C7l (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Jul 2007 22:59:41 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 4/8] iwliwif: Eidianity fix for calibration host commands
Date: Mon, 30 Jul 2007 10:57:02 +0800
Message-Id: <11857642401149-git-send-email-yi.zhu@intel.com>
In-Reply-To: <1185764238442-git-send-email-yi.zhu@intel.com>
References: <11857642261522-git-send-email-yi.zhu@intel.com>
 <11857642343783-git-send-email-yi.zhu@intel.com>
 <11857642362891-git-send-email-yi.zhu@intel.com>
 <1185764238442-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch fixes endianity issues in calibration host commands.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwl-4965-hw.h |    8 ++--
 drivers/net/wireless/iwl-4965.c    |   78 ++++++++++++++++++++----------------
 drivers/net/wireless/iwl-4965.h    |    5 +-
 3 files changed, 50 insertions(+), 41 deletions(-)

diff --git a/drivers/net/wireless/iwl-4965-hw.h b/drivers/net/wireless/iwl-4965-hw.h
index 0c81337..5dec78b 100644
--- a/drivers/net/wireless/iwl-4965-hw.h
+++ b/drivers/net/wireless/iwl-4965-hw.h
@@ -738,10 +738,10 @@ struct iwl_link_quality_cmd {
 #define STATISTICS_FLG_CLEAR                      (0x1)
 #define STATISTICS_FLG_DISABLE_NOTIFICATION       (0x2)
 
-#define STATISTICS_REPLY_FLG_CLEAR                (0x1)
-#define STATISTICS_REPLY_FLG_BAND_24G_MSK         (0x2)
-#define STATISTICS_REPLY_FLG_TGJ_NARROW_BAND_MSK  (0x4)
-#define STATISTICS_REPLY_FLG_FAT_MODE_MSK         (0x8)
+#define STATISTICS_REPLY_FLG_CLEAR                __constant_cpu_to_le32(0x1)
+#define STATISTICS_REPLY_FLG_BAND_24G_MSK         __constant_cpu_to_le32(0x2)
+#define STATISTICS_REPLY_FLG_TGJ_NARROW_BAND_MSK  __constant_cpu_to_le32(0x4)
+#define STATISTICS_REPLY_FLG_FAT_MODE_MSK         __constant_cpu_to_le32(0x8)
 #define RX_PHY_FLAGS_ANTENNAE_OFFSET		(4)
 #define RX_PHY_FLAGS_ANTENNAE_MASK		(0x70)
 
diff --git a/drivers/net/wireless/iwl-4965.c b/drivers/net/wireless/iwl-4965.c
index da3e9a7..c791132 100644
--- a/drivers/net/wireless/iwl-4965.c
+++ b/drivers/net/wireless/iwl-4965.c
@@ -1049,25 +1049,30 @@ static int iwl4965_sensitivity_write(struct iwl_priv *priv, u8 flags)
 	memset(&cmd, 0, sizeof(cmd));
 
 	cmd.table[HD_AUTO_CORR32_X4_TH_ADD_MIN_INDEX] =
-					(u16)data->auto_corr_ofdm;
+				cpu_to_le16((u16)data->auto_corr_ofdm);
 	cmd.table[HD_AUTO_CORR32_X4_TH_ADD_MIN_MRC_INDEX] =
-					(u16)data->auto_corr_ofdm_mrc;
+				cpu_to_le16((u16)data->auto_corr_ofdm_mrc);
 	cmd.table[HD_AUTO_CORR32_X1_TH_ADD_MIN_INDEX] =
-					(u16)data->auto_corr_ofdm_x1;
+				cpu_to_le16((u16)data->auto_corr_ofdm_x1);
 	cmd.table[HD_AUTO_CORR32_X1_TH_ADD_MIN_MRC_INDEX] =
-					(u16)data->auto_corr_ofdm_mrc_x1;
+				cpu_to_le16((u16)data->auto_corr_ofdm_mrc_x1);
 
 	cmd.table[HD_AUTO_CORR40_X4_TH_ADD_MIN_INDEX] =
-					(u16)data->auto_corr_cck;
+				cpu_to_le16((u16)data->auto_corr_cck);
 	cmd.table[HD_AUTO_CORR40_X4_TH_ADD_MIN_MRC_INDEX] =
-					(u16)data->auto_corr_cck_mrc;
+				cpu_to_le16((u16)data->auto_corr_cck_mrc);
 
-	cmd.table[HD_MIN_ENERGY_CCK_DET_INDEX] = (u16)data->nrg_th_cck;
-	cmd.table[HD_MIN_ENERGY_OFDM_DET_INDEX] = (u16)data->nrg_th_ofdm;
+	cmd.table[HD_MIN_ENERGY_CCK_DET_INDEX] =
+				cpu_to_le16((u16)data->nrg_th_cck);
+	cmd.table[HD_MIN_ENERGY_OFDM_DET_INDEX] =
+				cpu_to_le16((u16)data->nrg_th_ofdm);
 
-	cmd.table[HD_BARKER_CORR_TH_ADD_MIN_INDEX] = 190;
-	cmd.table[HD_BARKER_CORR_TH_ADD_MIN_MRC_INDEX] = 390;
-	cmd.table[HD_OFDM_ENERGY_TH_IN_INDEX] = 62;
+	cmd.table[HD_BARKER_CORR_TH_ADD_MIN_INDEX] =
+				__constant_cpu_to_le16(190);
+	cmd.table[HD_BARKER_CORR_TH_ADD_MIN_MRC_INDEX] =
+				__constant_cpu_to_le16(390);
+	cmd.table[HD_OFDM_ENERGY_TH_IN_INDEX] =
+				__constant_cpu_to_le16(62);
 
 	IWL_DEBUG_CALIB("ofdm: ac %u mrc %u x1 %u mrc_x1 %u thresh %u\n",
 			data->auto_corr_ofdm, data->auto_corr_ofdm_mrc,
@@ -1226,18 +1231,18 @@ static void iwl4965_noise_calibration(struct iwl_priv *priv,
 	}
 
 	spin_lock_irqsave(&priv->lock, flags);
-	if (rx_info->interference_data_flag != 1) {
+	if (rx_info->interference_data_flag != INTERFERENCE_DATA_AVAILABLE) {
 		IWL_DEBUG_CALIB(" << Interference data unavailable\n");
 		spin_unlock_irqrestore(&priv->lock, flags);
 		return;
 	}
 
 	band = (priv->staging_rxon.flags & RXON_FLG_BAND_24G_MSK) ? 0 : 1;
-	chan_num = priv->staging_rxon.channel;
+	chan_num = le16_to_cpu(priv->staging_rxon.channel);
 
 	/* Make sure we accumulate data for just the associated channel
 	 *   (even if scanning). */
-	if ((chan_num != (stat_resp->flag >> 16)) ||
+	if ((chan_num != (le32_to_cpu(stat_resp->flag) >> 16)) ||
 	   ((STATISTICS_REPLY_FLG_BAND_24G_MSK ==
 	     (stat_resp->flag & STATISTICS_REPLY_FLG_BAND_24G_MSK)) &&
 	    band)) {
@@ -1248,13 +1253,16 @@ static void iwl4965_noise_calibration(struct iwl_priv *priv,
 	}
 
 	/* Accumulate beacon statistics values across 20 beacons */
-	chain_noise_a = (rx_info->beacon_silence_rssi_a & IN_BAND_FILTER);
-	chain_noise_b = (rx_info->beacon_silence_rssi_b & IN_BAND_FILTER);
-	chain_noise_c = (rx_info->beacon_silence_rssi_c & IN_BAND_FILTER);
+	chain_noise_a = le32_to_cpu(rx_info->beacon_silence_rssi_a) &
+				IN_BAND_FILTER;
+	chain_noise_b = le32_to_cpu(rx_info->beacon_silence_rssi_b) &
+				IN_BAND_FILTER;
+	chain_noise_c = le32_to_cpu(rx_info->beacon_silence_rssi_c) &
+				IN_BAND_FILTER;
 
-	chain_sig_a = (rx_info->beacon_rssi_a & IN_BAND_FILTER);
-	chain_sig_b = (rx_info->beacon_rssi_b & IN_BAND_FILTER);
-	chain_sig_c = (rx_info->beacon_rssi_c & IN_BAND_FILTER);
+	chain_sig_a = le32_to_cpu(rx_info->beacon_rssi_a) & IN_BAND_FILTER;
+	chain_sig_b = le32_to_cpu(rx_info->beacon_rssi_b) & IN_BAND_FILTER;
+	chain_sig_c = le32_to_cpu(rx_info->beacon_rssi_c) & IN_BAND_FILTER;
 
 	spin_unlock_irqrestore(&priv->lock, flags);
 
@@ -1312,18 +1320,18 @@ static void iwl4965_noise_calibration(struct iwl_priv *priv,
 		/* Compare signal strengths for all 3 receivers. */
 		for (i = 0; i < NUM_RX_CHAINS; i++) {
 			if (i != max_average_sig_antenna_i) {
-				s32 rssiDelta = (max_average_sig -
+				s32 rssi_delta = (max_average_sig -
 						 average_sig[i]);
 
 				/* If signal is very weak, compared with
 				 * strongest, mark it as disconnected. */
-				if (rssiDelta > MAXIMUM_ALLOWED_PATHLOSS)
+				if (rssi_delta > MAXIMUM_ALLOWED_PATHLOSS)
 					data->disconn_array[i] = 1;
 				else
 					active_chains |= (1 << i);
 			IWL_DEBUG_CALIB("i = %d  rssiDelta = %d  "
 				     "disconn_array[i] = %d\n",
-				     i, rssiDelta,
+				     i, rssi_delta,
 				     data->disconn_array[i]);
 			}
 		}
@@ -1451,31 +1459,31 @@ static void iwl4965_sensitivity_calibration(struct iwl_priv *priv,
 	}
 
 	spin_lock_irqsave(&priv->lock, flags);
-	if (rx_info->interference_data_flag != 1) {
+	if (rx_info->interference_data_flag != INTERFERENCE_DATA_AVAILABLE) {
 		IWL_DEBUG_CALIB("<< invalid data.\n");
 		spin_unlock_irqrestore(&priv->lock, flags);
 		return;
 	}
 
 	/* Extract Statistics: */
-	rx_enable_time = rx_info->channel_load;
-	fa_cck = statistics->cck.false_alarm_cnt;
-	fa_ofdm = statistics->ofdm.false_alarm_cnt;
-	bad_plcp_cck = statistics->cck.plcp_err;
-	bad_plcp_ofdm = statistics->ofdm.plcp_err;
+	rx_enable_time = le32_to_cpu(rx_info->channel_load);
+	fa_cck = le32_to_cpu(statistics->cck.false_alarm_cnt);
+	fa_ofdm = le32_to_cpu(statistics->ofdm.false_alarm_cnt);
+	bad_plcp_cck = le32_to_cpu(statistics->cck.plcp_err);
+	bad_plcp_ofdm = le32_to_cpu(statistics->ofdm.plcp_err);
 
 	statis.beacon_silence_rssi_a =
-			statistics->general.beacon_silence_rssi_a;
+			le32_to_cpu(statistics->general.beacon_silence_rssi_a);
 	statis.beacon_silence_rssi_b =
-			statistics->general.beacon_silence_rssi_b;
+			le32_to_cpu(statistics->general.beacon_silence_rssi_b);
 	statis.beacon_silence_rssi_c =
-			statistics->general.beacon_silence_rssi_c;
+			le32_to_cpu(statistics->general.beacon_silence_rssi_c);
 	statis.beacon_energy_a =
-			statistics->general.beacon_energy_a;
+			le32_to_cpu(statistics->general.beacon_energy_a);
 	statis.beacon_energy_b =
-			statistics->general.beacon_energy_b;
+			le32_to_cpu(statistics->general.beacon_energy_b);
 	statis.beacon_energy_c =
-			statistics->general.beacon_energy_c;
+			le32_to_cpu(statistics->general.beacon_energy_c);
 
 	spin_unlock_irqrestore(&priv->lock, flags);
 
diff --git a/drivers/net/wireless/iwl-4965.h b/drivers/net/wireless/iwl-4965.h
index 8665929..7fa17ee 100644
--- a/drivers/net/wireless/iwl-4965.h
+++ b/drivers/net/wireless/iwl-4965.h
@@ -201,6 +201,7 @@ struct iwl_lq_mngr {
 
 
 /* Sensitivity and chain noise calibration */
+#define INTERFERENCE_DATA_AVAILABLE	__constant_cpu_to_le32(1)
 #define INITIALIZATION_VALUE		0xFFFF
 #define CAL_NUM_OF_BEACONS		20
 #define MAXIMUM_ALLOWED_PATHLOSS	15
@@ -218,8 +219,8 @@ struct iwl_lq_mngr {
 #define HD_AUTO_CORR40_X4_TH_ADD_MIN_INDEX          (9)
 #define HD_OFDM_ENERGY_TH_IN_INDEX                  (10)
 
-#define SENSITIVITY_CMD_CONTROL_DEFAULT_TABLE       (0)
-#define SENSITIVITY_CMD_CONTROL_WORK_TABLE          (1)
+#define SENSITIVITY_CMD_CONTROL_DEFAULT_TABLE	__constant_cpu_to_le16(0)
+#define SENSITIVITY_CMD_CONTROL_WORK_TABLE	__constant_cpu_to_le16(1)
 
 #define CHAIN_NOISE_MAX_DELTA_GAIN_CODE 3
 
-- 
1.5.2
