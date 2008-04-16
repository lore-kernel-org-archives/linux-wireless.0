Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:11497 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750833AbYDPXev (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Apr 2008 19:34:51 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 1/3] iwlwifi: HW dependent run time calibration
Date: Wed, 16 Apr 2008 16:34:47 -0700
Message-Id: <1208388889-32131-2-git-send-email-reinette.chatre@intel.com> (sfid-20080417_003458_486313_FF476C25)
In-Reply-To: <1208388889-32131-1-git-send-email-reinette.chatre@intel.com>
References: <1208388889-32131-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This patch does several things:

1) rename CONFIG_IWL4965_SENSITIVITY to IWL4965_RUN_TIME_CALIB which is
   better semantic
2) move all the run time calibration to a new file: iwl-calib.c
3) simplify the sensitivity calibration flow and make it HW dependent
4) make the chain noise calibration flow HW dependent

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>

---
 drivers/net/wireless/iwlwifi/Kconfig             |   19 +-
 drivers/net/wireless/iwlwifi/Makefile            |    1 +
 drivers/net/wireless/iwlwifi/iwl-4965-commands.h |    8 +-
 drivers/net/wireless/iwlwifi/iwl-4965.c          |  870 +++-------------------
 drivers/net/wireless/iwlwifi/iwl-4965.h          |   68 +-
 drivers/net/wireless/iwlwifi/iwl-calib.c         |  778 +++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-calib.h         |  104 +++
 drivers/net/wireless/iwlwifi/iwl-core.h          |    7 +
 drivers/net/wireless/iwlwifi/iwl4965-base.c      |   18 +-
 9 files changed, 1054 insertions(+), 819 deletions(-)
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-calib.c
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-calib.h

diff --git a/drivers/net/wireless/iwlwifi/Kconfig b/drivers/net/wireless/iwlwifi/Kconfig
index f844b73..7b43578 100644
--- a/drivers/net/wireless/iwlwifi/Kconfig
+++ b/drivers/net/wireless/iwlwifi/Kconfig
@@ -6,6 +6,15 @@ config IWLWIFI_LEDS
 	bool
 	default n
 
+config IWLWIFI_RUN_TIME_CALIB
+	bool
+	depends on IWLCORE
+	default n
+	---help---
+	  This option will enable run time calibration for the iwlwifi driver.
+	  These calibrations are Sensitivity and Chain Noise.
+
+
 config IWLWIFI_RFKILL
 	boolean "IWLWIFI RF kill support"
 	depends on IWLCORE
@@ -61,12 +70,14 @@ config IWL4965_SPECTRUM_MEASUREMENT
 	---help---
 	  This option will enable spectrum measurement for the iwl4965 driver.
 
-config IWL4965_SENSITIVITY
-	bool "Enable Sensitivity Calibration in iwl4965 driver"
+config IWL4965_RUN_TIME_CALIB
+	bool "Enable run time Calibration for 4965 NIC"
+	select IWLWIFI_RUN_TIME_CALIB
 	depends on IWL4965
+	default y
 	---help---
-	  This option will enable sensitivity calibration for the iwl4965
-	  driver.
+	  This option will enable run time calibration for the iwl4965 driver.
+	  These calibrations are Sensitivity and Chain Noise. If unsure, say yes
 
 config IWLWIFI_DEBUG
 	bool "Enable full debugging output in iwl4965 driver"
diff --git a/drivers/net/wireless/iwlwifi/Makefile b/drivers/net/wireless/iwlwifi/Makefile
index 4f3e88b..ff56805 100644
--- a/drivers/net/wireless/iwlwifi/Makefile
+++ b/drivers/net/wireless/iwlwifi/Makefile
@@ -3,6 +3,7 @@ iwlcore-objs 		:= iwl-core.o iwl-eeprom.o iwl-hcmd.o
 iwlcore-$(CONFIG_IWLWIFI_DEBUGFS) += iwl-debugfs.o
 iwlcore-$(CONFIG_IWLWIFI_LEDS) += iwl-led.o
 iwlcore-$(CONFIG_IWLWIFI_RFKILL) += iwl-rfkill.o
+iwlcore-$(CONFIG_IWLWIFI_RUN_TIME_CALIB) += iwl-calib.o
 
 obj-$(CONFIG_IWL3945)	+= iwl3945.o
 iwl3945-objs		:= iwl3945-base.o iwl-3945.o iwl-3945-rs.o
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-commands.h b/drivers/net/wireless/iwlwifi/iwl-4965-commands.h
index 3bcd107..c03c04f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-commands.h
@@ -2559,7 +2559,7 @@ struct iwl4965_missed_beacon_notif {
  */
 
 /*
- * Table entries in SENSITIVITY_CMD (struct iwl4965_sensitivity_cmd)
+ * Table entries in SENSITIVITY_CMD (struct iwl_sensitivity_cmd)
  */
 #define HD_TABLE_SIZE  (11)	/* number of entries */
 #define HD_MIN_ENERGY_CCK_DET_INDEX                 (0)	/* table indexes */
@@ -2574,18 +2574,18 @@ struct iwl4965_missed_beacon_notif {
 #define HD_AUTO_CORR40_X4_TH_ADD_MIN_INDEX          (9)
 #define HD_OFDM_ENERGY_TH_IN_INDEX                  (10)
 
-/* Control field in struct iwl4965_sensitivity_cmd */
+/* Control field in struct iwl_sensitivity_cmd */
 #define SENSITIVITY_CMD_CONTROL_DEFAULT_TABLE	__constant_cpu_to_le16(0)
 #define SENSITIVITY_CMD_CONTROL_WORK_TABLE	__constant_cpu_to_le16(1)
 
 /**
- * struct iwl4965_sensitivity_cmd
+ * struct iwl_sensitivity_cmd
  * @control:  (1) updates working table, (0) updates default table
  * @table:  energy threshold values, use HD_* as index into table
  *
  * Always use "1" in "control" to update uCode's working table and DSP.
  */
-struct iwl4965_sensitivity_cmd {
+struct iwl_sensitivity_cmd {
 	__le16 control;			/* always use "1" */
 	__le16 table[HD_TABLE_SIZE];	/* use HD_* as index */
 } __attribute__ ((packed));
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 17f629f..be4cc5f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -43,6 +43,7 @@
 #include "iwl-core.h"
 #include "iwl-io.h"
 #include "iwl-helpers.h"
+#include "iwl-calib.h"
 
 /* module parameters */
 static struct iwl_mod_params iwl4965_mod_params = {
@@ -1032,418 +1033,15 @@ void iwl4965_rf_kill_ct_config(struct iwl_priv *priv)
 		IWL_DEBUG_INFO("REPLY_CT_KILL_CONFIG_CMD succeeded\n");
 }
 
-#ifdef CONFIG_IWL4965_SENSITIVITY
-
-/* "false alarms" are signals that our DSP tries to lock onto,
- *   but then determines that they are either noise, or transmissions
- *   from a distant wireless network (also "noise", really) that get
- *   "stepped on" by stronger transmissions within our own network.
- * This algorithm attempts to set a sensitivity level that is high
- *   enough to receive all of our own network traffic, but not so
- *   high that our DSP gets too busy trying to lock onto non-network
- *   activity/noise. */
-static int iwl4965_sens_energy_cck(struct iwl_priv *priv,
-				   u32 norm_fa,
-				   u32 rx_enable_time,
-				   struct statistics_general_data *rx_info)
-{
-	u32 max_nrg_cck = 0;
-	int i = 0;
-	u8 max_silence_rssi = 0;
-	u32 silence_ref = 0;
-	u8 silence_rssi_a = 0;
-	u8 silence_rssi_b = 0;
-	u8 silence_rssi_c = 0;
-	u32 val;
-
-	/* "false_alarms" values below are cross-multiplications to assess the
-	 *   numbers of false alarms within the measured period of actual Rx
-	 *   (Rx is off when we're txing), vs the min/max expected false alarms
-	 *   (some should be expected if rx is sensitive enough) in a
-	 *   hypothetical listening period of 200 time units (TU), 204.8 msec:
-	 *
-	 * MIN_FA/fixed-time < false_alarms/actual-rx-time < MAX_FA/beacon-time
-	 *
-	 * */
-	u32 false_alarms = norm_fa * 200 * 1024;
-	u32 max_false_alarms = MAX_FA_CCK * rx_enable_time;
-	u32 min_false_alarms = MIN_FA_CCK * rx_enable_time;
-	struct iwl4965_sensitivity_data *data = NULL;
-
-	data = &(priv->sensitivity_data);
-
-	data->nrg_auto_corr_silence_diff = 0;
-
-	/* Find max silence rssi among all 3 receivers.
-	 * This is background noise, which may include transmissions from other
-	 *    networks, measured during silence before our network's beacon */
-	silence_rssi_a = (u8)((rx_info->beacon_silence_rssi_a &
-			    ALL_BAND_FILTER) >> 8);
-	silence_rssi_b = (u8)((rx_info->beacon_silence_rssi_b &
-			    ALL_BAND_FILTER) >> 8);
-	silence_rssi_c = (u8)((rx_info->beacon_silence_rssi_c &
-			    ALL_BAND_FILTER) >> 8);
-
-	val = max(silence_rssi_b, silence_rssi_c);
-	max_silence_rssi = max(silence_rssi_a, (u8) val);
-
-	/* Store silence rssi in 20-beacon history table */
-	data->nrg_silence_rssi[data->nrg_silence_idx] = max_silence_rssi;
-	data->nrg_silence_idx++;
-	if (data->nrg_silence_idx >= NRG_NUM_PREV_STAT_L)
-		data->nrg_silence_idx = 0;
-
-	/* Find max silence rssi across 20 beacon history */
-	for (i = 0; i < NRG_NUM_PREV_STAT_L; i++) {
-		val = data->nrg_silence_rssi[i];
-		silence_ref = max(silence_ref, val);
-	}
-	IWL_DEBUG_CALIB("silence a %u, b %u, c %u, 20-bcn max %u\n",
-			silence_rssi_a, silence_rssi_b, silence_rssi_c,
-			silence_ref);
-
-	/* Find max rx energy (min value!) among all 3 receivers,
-	 *   measured during beacon frame.
-	 * Save it in 10-beacon history table. */
-	i = data->nrg_energy_idx;
-	val = min(rx_info->beacon_energy_b, rx_info->beacon_energy_c);
-	data->nrg_value[i] = min(rx_info->beacon_energy_a, val);
-
-	data->nrg_energy_idx++;
-	if (data->nrg_energy_idx >= 10)
-		data->nrg_energy_idx = 0;
-
-	/* Find min rx energy (max value) across 10 beacon history.
-	 * This is the minimum signal level that we want to receive well.
-	 * Add backoff (margin so we don't miss slightly lower energy frames).
-	 * This establishes an upper bound (min value) for energy threshold. */
-	max_nrg_cck = data->nrg_value[0];
-	for (i = 1; i < 10; i++)
-		max_nrg_cck = (u32) max(max_nrg_cck, (data->nrg_value[i]));
-	max_nrg_cck += 6;
-
-	IWL_DEBUG_CALIB("rx energy a %u, b %u, c %u, 10-bcn max/min %u\n",
-			rx_info->beacon_energy_a, rx_info->beacon_energy_b,
-			rx_info->beacon_energy_c, max_nrg_cck - 6);
-
-	/* Count number of consecutive beacons with fewer-than-desired
-	 *   false alarms. */
-	if (false_alarms < min_false_alarms)
-		data->num_in_cck_no_fa++;
-	else
-		data->num_in_cck_no_fa = 0;
-	IWL_DEBUG_CALIB("consecutive bcns with few false alarms = %u\n",
-			data->num_in_cck_no_fa);
-
-	/* If we got too many false alarms this time, reduce sensitivity */
-	if (false_alarms > max_false_alarms) {
-		IWL_DEBUG_CALIB("norm FA %u > max FA %u\n",
-			     false_alarms, max_false_alarms);
-		IWL_DEBUG_CALIB("... reducing sensitivity\n");
-		data->nrg_curr_state = IWL_FA_TOO_MANY;
-
-		if (data->auto_corr_cck > AUTO_CORR_MAX_TH_CCK) {
-			/* Store for "fewer than desired" on later beacon */
-			data->nrg_silence_ref = silence_ref;
-
-			/* increase energy threshold (reduce nrg value)
-			 *   to decrease sensitivity */
-			if (data->nrg_th_cck > (NRG_MAX_CCK + NRG_STEP_CCK))
-				data->nrg_th_cck = data->nrg_th_cck
-							 - NRG_STEP_CCK;
-		}
-
-		/* increase auto_corr values to decrease sensitivity */
-		if (data->auto_corr_cck < AUTO_CORR_MAX_TH_CCK)
-			data->auto_corr_cck = AUTO_CORR_MAX_TH_CCK + 1;
-		else {
-			val = data->auto_corr_cck + AUTO_CORR_STEP_CCK;
-			data->auto_corr_cck = min((u32)AUTO_CORR_MAX_CCK, val);
-		}
-		val = data->auto_corr_cck_mrc + AUTO_CORR_STEP_CCK;
-		data->auto_corr_cck_mrc = min((u32)AUTO_CORR_MAX_CCK_MRC, val);
-
-	/* Else if we got fewer than desired, increase sensitivity */
-	} else if (false_alarms < min_false_alarms) {
-		data->nrg_curr_state = IWL_FA_TOO_FEW;
-
-		/* Compare silence level with silence level for most recent
-		 *   healthy number or too many false alarms */
-		data->nrg_auto_corr_silence_diff = (s32)data->nrg_silence_ref -
-						   (s32)silence_ref;
-
-		IWL_DEBUG_CALIB("norm FA %u < min FA %u, silence diff %d\n",
-			 false_alarms, min_false_alarms,
-			 data->nrg_auto_corr_silence_diff);
-
-		/* Increase value to increase sensitivity, but only if:
-		 * 1a) previous beacon did *not* have *too many* false alarms
-		 * 1b) AND there's a significant difference in Rx levels
-		 *      from a previous beacon with too many, or healthy # FAs
-		 * OR 2) We've seen a lot of beacons (100) with too few
-		 *       false alarms */
-		if ((data->nrg_prev_state != IWL_FA_TOO_MANY) &&
-			((data->nrg_auto_corr_silence_diff > NRG_DIFF) ||
-			(data->num_in_cck_no_fa > MAX_NUMBER_CCK_NO_FA))) {
-
-			IWL_DEBUG_CALIB("... increasing sensitivity\n");
-			/* Increase nrg value to increase sensitivity */
-			val = data->nrg_th_cck + NRG_STEP_CCK;
-			data->nrg_th_cck = min((u32)NRG_MIN_CCK, val);
-
-			/* Decrease auto_corr values to increase sensitivity */
-			val = data->auto_corr_cck - AUTO_CORR_STEP_CCK;
-			data->auto_corr_cck = max((u32)AUTO_CORR_MIN_CCK, val);
-
-			val = data->auto_corr_cck_mrc - AUTO_CORR_STEP_CCK;
-			data->auto_corr_cck_mrc =
-					 max((u32)AUTO_CORR_MIN_CCK_MRC, val);
-
-		} else
-			IWL_DEBUG_CALIB("... but not changing sensitivity\n");
-
-	/* Else we got a healthy number of false alarms, keep status quo */
-	} else {
-		IWL_DEBUG_CALIB(" FA in safe zone\n");
-		data->nrg_curr_state = IWL_FA_GOOD_RANGE;
-
-		/* Store for use in "fewer than desired" with later beacon */
-		data->nrg_silence_ref = silence_ref;
-
-		/* If previous beacon had too many false alarms,
-		 *   give it some extra margin by reducing sensitivity again
-		 *   (but don't go below measured energy of desired Rx) */
-		if (IWL_FA_TOO_MANY == data->nrg_prev_state) {
-			IWL_DEBUG_CALIB("... increasing margin\n");
-			data->nrg_th_cck -= NRG_MARGIN;
-		}
-	}
-
-	/* Make sure the energy threshold does not go above the measured
-	 * energy of the desired Rx signals (reduced by backoff margin),
-	 * or else we might start missing Rx frames.
-	 * Lower value is higher energy, so we use max()!
-	 */
-	data->nrg_th_cck = max(max_nrg_cck, data->nrg_th_cck);
-	IWL_DEBUG_CALIB("new nrg_th_cck %u\n", data->nrg_th_cck);
-
-	data->nrg_prev_state = data->nrg_curr_state;
-
-	return 0;
-}
-
-
-static int iwl4965_sens_auto_corr_ofdm(struct iwl_priv *priv,
-				       u32 norm_fa,
-				       u32 rx_enable_time)
-{
-	u32 val;
-	u32 false_alarms = norm_fa * 200 * 1024;
-	u32 max_false_alarms = MAX_FA_OFDM * rx_enable_time;
-	u32 min_false_alarms = MIN_FA_OFDM * rx_enable_time;
-	struct iwl4965_sensitivity_data *data = NULL;
-
-	data = &(priv->sensitivity_data);
-
-	/* If we got too many false alarms this time, reduce sensitivity */
-	if (false_alarms > max_false_alarms) {
-
-		IWL_DEBUG_CALIB("norm FA %u > max FA %u)\n",
-			     false_alarms, max_false_alarms);
-
-		val = data->auto_corr_ofdm + AUTO_CORR_STEP_OFDM;
-		data->auto_corr_ofdm =
-				min((u32)AUTO_CORR_MAX_OFDM, val);
-
-		val = data->auto_corr_ofdm_mrc + AUTO_CORR_STEP_OFDM;
-		data->auto_corr_ofdm_mrc =
-				min((u32)AUTO_CORR_MAX_OFDM_MRC, val);
-
-		val = data->auto_corr_ofdm_x1 + AUTO_CORR_STEP_OFDM;
-		data->auto_corr_ofdm_x1 =
-				min((u32)AUTO_CORR_MAX_OFDM_X1, val);
-
-		val = data->auto_corr_ofdm_mrc_x1 + AUTO_CORR_STEP_OFDM;
-		data->auto_corr_ofdm_mrc_x1 =
-				min((u32)AUTO_CORR_MAX_OFDM_MRC_X1, val);
-	}
-
-	/* Else if we got fewer than desired, increase sensitivity */
-	else if (false_alarms < min_false_alarms) {
-
-		IWL_DEBUG_CALIB("norm FA %u < min FA %u\n",
-			     false_alarms, min_false_alarms);
-
-		val = data->auto_corr_ofdm - AUTO_CORR_STEP_OFDM;
-		data->auto_corr_ofdm =
-				max((u32)AUTO_CORR_MIN_OFDM, val);
-
-		val = data->auto_corr_ofdm_mrc - AUTO_CORR_STEP_OFDM;
-		data->auto_corr_ofdm_mrc =
-				max((u32)AUTO_CORR_MIN_OFDM_MRC, val);
-
-		val = data->auto_corr_ofdm_x1 - AUTO_CORR_STEP_OFDM;
-		data->auto_corr_ofdm_x1 =
-				max((u32)AUTO_CORR_MIN_OFDM_X1, val);
-
-		val = data->auto_corr_ofdm_mrc_x1 - AUTO_CORR_STEP_OFDM;
-		data->auto_corr_ofdm_mrc_x1 =
-				max((u32)AUTO_CORR_MIN_OFDM_MRC_X1, val);
-	}
-
-	else
-		IWL_DEBUG_CALIB("min FA %u < norm FA %u < max FA %u OK\n",
-			 min_false_alarms, false_alarms, max_false_alarms);
-
-	return 0;
-}
-
-static int iwl4965_sensitivity_callback(struct iwl_priv *priv,
-				    struct iwl_cmd *cmd, struct sk_buff *skb)
-{
-	/* We didn't cache the SKB; let the caller free it */
-	return 1;
-}
-
-/* Prepare a SENSITIVITY_CMD, send to uCode if values have changed */
-static int iwl4965_sensitivity_write(struct iwl_priv *priv, u8 flags)
-{
-	struct iwl4965_sensitivity_cmd cmd ;
-	struct iwl4965_sensitivity_data *data = NULL;
-	struct iwl_host_cmd cmd_out = {
-		.id = SENSITIVITY_CMD,
-		.len = sizeof(struct iwl4965_sensitivity_cmd),
-		.meta.flags = flags,
-		.data = &cmd,
-	};
-	int ret;
-
-	data = &(priv->sensitivity_data);
-
-	memset(&cmd, 0, sizeof(cmd));
-
-	cmd.table[HD_AUTO_CORR32_X4_TH_ADD_MIN_INDEX] =
-				cpu_to_le16((u16)data->auto_corr_ofdm);
-	cmd.table[HD_AUTO_CORR32_X4_TH_ADD_MIN_MRC_INDEX] =
-				cpu_to_le16((u16)data->auto_corr_ofdm_mrc);
-	cmd.table[HD_AUTO_CORR32_X1_TH_ADD_MIN_INDEX] =
-				cpu_to_le16((u16)data->auto_corr_ofdm_x1);
-	cmd.table[HD_AUTO_CORR32_X1_TH_ADD_MIN_MRC_INDEX] =
-				cpu_to_le16((u16)data->auto_corr_ofdm_mrc_x1);
-
-	cmd.table[HD_AUTO_CORR40_X4_TH_ADD_MIN_INDEX] =
-				cpu_to_le16((u16)data->auto_corr_cck);
-	cmd.table[HD_AUTO_CORR40_X4_TH_ADD_MIN_MRC_INDEX] =
-				cpu_to_le16((u16)data->auto_corr_cck_mrc);
-
-	cmd.table[HD_MIN_ENERGY_CCK_DET_INDEX] =
-				cpu_to_le16((u16)data->nrg_th_cck);
-	cmd.table[HD_MIN_ENERGY_OFDM_DET_INDEX] =
-				cpu_to_le16((u16)data->nrg_th_ofdm);
-
-	cmd.table[HD_BARKER_CORR_TH_ADD_MIN_INDEX] =
-				__constant_cpu_to_le16(190);
-	cmd.table[HD_BARKER_CORR_TH_ADD_MIN_MRC_INDEX] =
-				__constant_cpu_to_le16(390);
-	cmd.table[HD_OFDM_ENERGY_TH_IN_INDEX] =
-				__constant_cpu_to_le16(62);
-
-	IWL_DEBUG_CALIB("ofdm: ac %u mrc %u x1 %u mrc_x1 %u thresh %u\n",
-			data->auto_corr_ofdm, data->auto_corr_ofdm_mrc,
-			data->auto_corr_ofdm_x1, data->auto_corr_ofdm_mrc_x1,
-			data->nrg_th_ofdm);
-
-	IWL_DEBUG_CALIB("cck: ac %u mrc %u thresh %u\n",
-			data->auto_corr_cck, data->auto_corr_cck_mrc,
-			data->nrg_th_cck);
-
-	/* Update uCode's "work" table, and copy it to DSP */
-	cmd.control = SENSITIVITY_CMD_CONTROL_WORK_TABLE;
-
-	if (flags & CMD_ASYNC)
-		cmd_out.meta.u.callback = iwl4965_sensitivity_callback;
-
-	/* Don't send command to uCode if nothing has changed */
-	if (!memcmp(&cmd.table[0], &(priv->sensitivity_tbl[0]),
-		    sizeof(u16)*HD_TABLE_SIZE)) {
-		IWL_DEBUG_CALIB("No change in SENSITIVITY_CMD\n");
-		return 0;
-	}
-
-	/* Copy table for comparison next time */
-	memcpy(&(priv->sensitivity_tbl[0]), &(cmd.table[0]),
-	       sizeof(u16)*HD_TABLE_SIZE);
-
-	ret = iwl_send_cmd(priv, &cmd_out);
-	if (ret)
-		IWL_ERROR("SENSITIVITY_CMD failed\n");
-
-	return ret;
-}
-
-void iwl4965_init_sensitivity(struct iwl_priv *priv, u8 flags, u8 force)
-{
-	struct iwl4965_sensitivity_data *data = NULL;
-	int i;
-	int ret  = 0;
-
-	IWL_DEBUG_CALIB("Start iwl4965_init_sensitivity\n");
-
-	if (force)
-		memset(&(priv->sensitivity_tbl[0]), 0,
-			sizeof(u16)*HD_TABLE_SIZE);
-
-	/* Clear driver's sensitivity algo data */
-	data = &(priv->sensitivity_data);
-	memset(data, 0, sizeof(struct iwl4965_sensitivity_data));
-
-	data->num_in_cck_no_fa = 0;
-	data->nrg_curr_state = IWL_FA_TOO_MANY;
-	data->nrg_prev_state = IWL_FA_TOO_MANY;
-	data->nrg_silence_ref = 0;
-	data->nrg_silence_idx = 0;
-	data->nrg_energy_idx = 0;
-
-	for (i = 0; i < 10; i++)
-		data->nrg_value[i] = 0;
-
-	for (i = 0; i < NRG_NUM_PREV_STAT_L; i++)
-		data->nrg_silence_rssi[i] = 0;
-
-	data->auto_corr_ofdm = 90;
-	data->auto_corr_ofdm_mrc = 170;
-	data->auto_corr_ofdm_x1  = 105;
-	data->auto_corr_ofdm_mrc_x1 = 220;
-	data->auto_corr_cck = AUTO_CORR_CCK_MIN_VAL_DEF;
-	data->auto_corr_cck_mrc = 200;
-	data->nrg_th_cck = 100;
-	data->nrg_th_ofdm = 100;
-
-	data->last_bad_plcp_cnt_ofdm = 0;
-	data->last_fa_cnt_ofdm = 0;
-	data->last_bad_plcp_cnt_cck = 0;
-	data->last_fa_cnt_cck = 0;
-
-	/* Clear prior Sensitivity command data to force send to uCode */
-	if (force)
-		memset(&(priv->sensitivity_tbl[0]), 0,
-		    sizeof(u16)*HD_TABLE_SIZE);
-
-	ret |= iwl4965_sensitivity_write(priv, flags);
-	IWL_DEBUG_CALIB("<<return 0x%X\n", ret);
-
-	return;
-}
-
+#ifdef CONFIG_IWL4965_RUN_TIME_CALIB
 
 /* Reset differential Rx gains in NIC to prepare for chain noise calibration.
  * Called after every association, but this runs only once!
  *  ... once chain noise is calibrated the first time, it's good forever.  */
-void iwl4965_chain_noise_reset(struct iwl_priv *priv)
+static void iwl4965_chain_noise_reset(struct iwl_priv *priv)
 {
-	struct iwl4965_chain_noise_data *data = NULL;
+	struct iwl_chain_noise_data *data = &(priv->chain_noise_data);
 
-	data = &(priv->chain_noise_data);
 	if ((data->state == IWL_CHAIN_NOISE_ALIVE) && iwl_is_associated(priv)) {
 		struct iwl4965_calibration_cmd cmd;
 
@@ -1452,357 +1050,76 @@ void iwl4965_chain_noise_reset(struct iwl_priv *priv)
 		cmd.diff_gain_a = 0;
 		cmd.diff_gain_b = 0;
 		cmd.diff_gain_c = 0;
-		iwl_send_cmd_pdu_async(priv, REPLY_PHY_CALIBRATION_CMD,
-				 sizeof(cmd), &cmd, NULL);
-		msleep(4);
+		if (iwl_send_cmd_pdu(priv, REPLY_PHY_CALIBRATION_CMD,
+				 sizeof(cmd), &cmd))
+			IWL_ERROR("Could not send REPLY_PHY_CALIBRATION_CMD\n");
 		data->state = IWL_CHAIN_NOISE_ACCUMULATE;
 		IWL_DEBUG_CALIB("Run chain_noise_calibrate\n");
 	}
-	return;
 }
 
-/*
- * Accumulate 20 beacons of signal and noise statistics for each of
- *   3 receivers/antennas/rx-chains, then figure out:
- * 1)  Which antennas are connected.
- * 2)  Differential rx gain settings to balance the 3 receivers.
- */
-static void iwl4965_noise_calibration(struct iwl_priv *priv,
-				      struct iwl4965_notif_statistics *stat_resp)
+static void iwl4965_gain_computation(struct iwl_priv *priv,
+		u32 *average_noise,
+		u16 min_average_noise_antenna_i,
+		u32 min_average_noise)
 {
-	struct iwl4965_chain_noise_data *data = NULL;
-	int ret = 0;
-
-	u32 chain_noise_a;
-	u32 chain_noise_b;
-	u32 chain_noise_c;
-	u32 chain_sig_a;
-	u32 chain_sig_b;
-	u32 chain_sig_c;
-	u32 average_sig[NUM_RX_CHAINS] = {INITIALIZATION_VALUE};
-	u32 average_noise[NUM_RX_CHAINS] = {INITIALIZATION_VALUE};
-	u32 max_average_sig;
-	u16 max_average_sig_antenna_i;
-	u32 min_average_noise = MIN_AVERAGE_NOISE_MAX_VALUE;
-	u16 min_average_noise_antenna_i = INITIALIZATION_VALUE;
-	u16 i = 0;
-	u16 chan_num = INITIALIZATION_VALUE;
-	u32 band = INITIALIZATION_VALUE;
-	u32 active_chains = 0;
-	unsigned long flags;
-	struct statistics_rx_non_phy *rx_info = &(stat_resp->rx.general);
-
-	data = &(priv->chain_noise_data);
+	int i, ret;
+	struct iwl_chain_noise_data *data = &priv->chain_noise_data;
 
-	/* Accumulate just the first 20 beacons after the first association,
-	 *   then we're done forever. */
-	if (data->state != IWL_CHAIN_NOISE_ACCUMULATE) {
-		if (data->state == IWL_CHAIN_NOISE_ALIVE)
-			IWL_DEBUG_CALIB("Wait for noise calib reset\n");
-		return;
-	}
-
-	spin_lock_irqsave(&priv->lock, flags);
-	if (rx_info->interference_data_flag != INTERFERENCE_DATA_AVAILABLE) {
-		IWL_DEBUG_CALIB(" << Interference data unavailable\n");
-		spin_unlock_irqrestore(&priv->lock, flags);
-		return;
-	}
-
-	band = (priv->staging_rxon.flags & RXON_FLG_BAND_24G_MSK) ? 0 : 1;
-	chan_num = le16_to_cpu(priv->staging_rxon.channel);
-
-	/* Make sure we accumulate data for just the associated channel
-	 *   (even if scanning). */
-	if ((chan_num != (le32_to_cpu(stat_resp->flag) >> 16)) ||
-	    ((STATISTICS_REPLY_FLG_BAND_24G_MSK ==
-	     (stat_resp->flag & STATISTICS_REPLY_FLG_BAND_24G_MSK)) && band)) {
-		IWL_DEBUG_CALIB("Stats not from chan=%d, band=%d\n",
-				chan_num, band);
-		spin_unlock_irqrestore(&priv->lock, flags);
-		return;
-	}
-
-	/* Accumulate beacon statistics values across 20 beacons */
-	chain_noise_a = le32_to_cpu(rx_info->beacon_silence_rssi_a) &
-				IN_BAND_FILTER;
-	chain_noise_b = le32_to_cpu(rx_info->beacon_silence_rssi_b) &
-				IN_BAND_FILTER;
-	chain_noise_c = le32_to_cpu(rx_info->beacon_silence_rssi_c) &
-				IN_BAND_FILTER;
-
-	chain_sig_a = le32_to_cpu(rx_info->beacon_rssi_a) & IN_BAND_FILTER;
-	chain_sig_b = le32_to_cpu(rx_info->beacon_rssi_b) & IN_BAND_FILTER;
-	chain_sig_c = le32_to_cpu(rx_info->beacon_rssi_c) & IN_BAND_FILTER;
+	data->delta_gain_code[min_average_noise_antenna_i] = 0;
 
-	spin_unlock_irqrestore(&priv->lock, flags);
+	for (i = 0; i < NUM_RX_CHAINS; i++) {
+		s32 delta_g = 0;
 
-	data->beacon_count++;
-
-	data->chain_noise_a = (chain_noise_a + data->chain_noise_a);
-	data->chain_noise_b = (chain_noise_b + data->chain_noise_b);
-	data->chain_noise_c = (chain_noise_c + data->chain_noise_c);
-
-	data->chain_signal_a = (chain_sig_a + data->chain_signal_a);
-	data->chain_signal_b = (chain_sig_b + data->chain_signal_b);
-	data->chain_signal_c = (chain_sig_c + data->chain_signal_c);
-
-	IWL_DEBUG_CALIB("chan=%d, band=%d, beacon=%d\n", chan_num, band,
-			data->beacon_count);
-	IWL_DEBUG_CALIB("chain_sig: a %d b %d c %d\n",
-			chain_sig_a, chain_sig_b, chain_sig_c);
-	IWL_DEBUG_CALIB("chain_noise: a %d b %d c %d\n",
-			chain_noise_a, chain_noise_b, chain_noise_c);
-
-	/* If this is the 20th beacon, determine:
-	 * 1)  Disconnected antennas (using signal strengths)
-	 * 2)  Differential gain (using silence noise) to balance receivers */
-	if (data->beacon_count == CAL_NUM_OF_BEACONS) {
-
-		/* Analyze signal for disconnected antenna */
-		average_sig[0] = (data->chain_signal_a) / CAL_NUM_OF_BEACONS;
-		average_sig[1] = (data->chain_signal_b) / CAL_NUM_OF_BEACONS;
-		average_sig[2] = (data->chain_signal_c) / CAL_NUM_OF_BEACONS;
-
-		if (average_sig[0] >= average_sig[1]) {
-			max_average_sig = average_sig[0];
-			max_average_sig_antenna_i = 0;
-			active_chains = (1 << max_average_sig_antenna_i);
-		} else {
-			max_average_sig = average_sig[1];
-			max_average_sig_antenna_i = 1;
-			active_chains = (1 << max_average_sig_antenna_i);
-		}
-
-		if (average_sig[2] >= max_average_sig) {
-			max_average_sig = average_sig[2];
-			max_average_sig_antenna_i = 2;
-			active_chains = (1 << max_average_sig_antenna_i);
-		}
-
-		IWL_DEBUG_CALIB("average_sig: a %d b %d c %d\n",
-			     average_sig[0], average_sig[1], average_sig[2]);
-		IWL_DEBUG_CALIB("max_average_sig = %d, antenna %d\n",
-			     max_average_sig, max_average_sig_antenna_i);
-
-		/* Compare signal strengths for all 3 receivers. */
-		for (i = 0; i < NUM_RX_CHAINS; i++) {
-			if (i != max_average_sig_antenna_i) {
-				s32 rssi_delta = (max_average_sig -
-						  average_sig[i]);
-
-				/* If signal is very weak, compared with
-				 * strongest, mark it as disconnected. */
-				if (rssi_delta > MAXIMUM_ALLOWED_PATHLOSS)
-					data->disconn_array[i] = 1;
-				else
-					active_chains |= (1 << i);
-			IWL_DEBUG_CALIB("i = %d  rssiDelta = %d  "
-				     "disconn_array[i] = %d\n",
-				     i, rssi_delta, data->disconn_array[i]);
-			}
-		}
-
-		/*If both chains A & B are disconnected -
-		 * connect B and leave A as is */
-		if (data->disconn_array[CHAIN_A] &&
-		    data->disconn_array[CHAIN_B]) {
-			data->disconn_array[CHAIN_B] = 0;
-			active_chains |= (1 << CHAIN_B);
-			IWL_DEBUG_CALIB("both A & B chains are disconnected! "
-				     "W/A - declare B as connected\n");
-		}
-
-		IWL_DEBUG_CALIB("active_chains (bitwise) = 0x%x\n",
-				active_chains);
-
-		/* Save for use within RXON, TX, SCAN commands, etc. */
-		priv->valid_antenna = active_chains;
-
-		/* Analyze noise for rx balance */
-		average_noise[0] = ((data->chain_noise_a)/CAL_NUM_OF_BEACONS);
-		average_noise[1] = ((data->chain_noise_b)/CAL_NUM_OF_BEACONS);
-		average_noise[2] = ((data->chain_noise_c)/CAL_NUM_OF_BEACONS);
-
-		for (i = 0; i < NUM_RX_CHAINS; i++) {
-			if (!(data->disconn_array[i]) &&
-			   (average_noise[i] <= min_average_noise)) {
-				/* This means that chain i is active and has
-				 * lower noise values so far: */
-				min_average_noise = average_noise[i];
-				min_average_noise_antenna_i = i;
-			}
-		}
-
-		data->delta_gain_code[min_average_noise_antenna_i] = 0;
-
-		IWL_DEBUG_CALIB("average_noise: a %d b %d c %d\n",
-				average_noise[0], average_noise[1],
-				average_noise[2]);
-
-		IWL_DEBUG_CALIB("min_average_noise = %d, antenna %d\n",
-				min_average_noise, min_average_noise_antenna_i);
-
-		for (i = 0; i < NUM_RX_CHAINS; i++) {
-			s32 delta_g = 0;
-
-			if (!(data->disconn_array[i]) &&
-			    (data->delta_gain_code[i] ==
+		if (!(data->disconn_array[i]) &&
+		    (data->delta_gain_code[i] ==
 			     CHAIN_NOISE_DELTA_GAIN_INIT_VAL)) {
-				delta_g = average_noise[i] - min_average_noise;
-				data->delta_gain_code[i] = (u8)((delta_g *
-								    10) / 15);
-				if (CHAIN_NOISE_MAX_DELTA_GAIN_CODE <
-				   data->delta_gain_code[i])
-					data->delta_gain_code[i] =
-					  CHAIN_NOISE_MAX_DELTA_GAIN_CODE;
-
-				data->delta_gain_code[i] =
-					(data->delta_gain_code[i] | (1 << 2));
-			} else
-				data->delta_gain_code[i] = 0;
-		}
-		IWL_DEBUG_CALIB("delta_gain_codes: a %d b %d c %d\n",
-			     data->delta_gain_code[0],
-			     data->delta_gain_code[1],
-			     data->delta_gain_code[2]);
-
-		/* Differential gain gets sent to uCode only once */
-		if (!data->radio_write) {
-			struct iwl4965_calibration_cmd cmd;
-			data->radio_write = 1;
-
-			memset(&cmd, 0, sizeof(cmd));
-			cmd.opCode = PHY_CALIBRATE_DIFF_GAIN_CMD;
-			cmd.diff_gain_a = data->delta_gain_code[0];
-			cmd.diff_gain_b = data->delta_gain_code[1];
-			cmd.diff_gain_c = data->delta_gain_code[2];
-			ret = iwl_send_cmd_pdu(priv, REPLY_PHY_CALIBRATION_CMD,
-					      sizeof(cmd), &cmd);
-			if (ret)
-				IWL_DEBUG_CALIB("fail sending cmd "
-					     "REPLY_PHY_CALIBRATION_CMD \n");
-
-			/* TODO we might want recalculate
-			 * rx_chain in rxon cmd */
-
-			/* Mark so we run this algo only once! */
-			data->state = IWL_CHAIN_NOISE_CALIBRATED;
+			delta_g = average_noise[i] - min_average_noise;
+			data->delta_gain_code[i] = (u8)((delta_g * 10) / 15);
+			data->delta_gain_code[i] =
+				min(data->delta_gain_code[i],
+				(u8) CHAIN_NOISE_MAX_DELTA_GAIN_CODE);
+
+			data->delta_gain_code[i] =
+				(data->delta_gain_code[i] | (1 << 2));
+		} else {
+			data->delta_gain_code[i] = 0;
 		}
-		data->chain_noise_a = 0;
-		data->chain_noise_b = 0;
-		data->chain_noise_c = 0;
-		data->chain_signal_a = 0;
-		data->chain_signal_b = 0;
-		data->chain_signal_c = 0;
-		data->beacon_count = 0;
-	}
-	return;
-}
-
-static void iwl4965_sensitivity_calibration(struct iwl_priv *priv,
-					    struct iwl4965_notif_statistics *resp)
-{
-	u32 rx_enable_time;
-	u32 fa_cck;
-	u32 fa_ofdm;
-	u32 bad_plcp_cck;
-	u32 bad_plcp_ofdm;
-	u32 norm_fa_ofdm;
-	u32 norm_fa_cck;
-	struct iwl4965_sensitivity_data *data = NULL;
-	struct statistics_rx_non_phy *rx_info = &(resp->rx.general);
-	struct statistics_rx *statistics = &(resp->rx);
-	unsigned long flags;
-	struct statistics_general_data statis;
-	int ret;
-
-	data = &(priv->sensitivity_data);
-
-	if (!iwl_is_associated(priv)) {
-		IWL_DEBUG_CALIB("<< - not associated\n");
-		return;
-	}
-
-	spin_lock_irqsave(&priv->lock, flags);
-	if (rx_info->interference_data_flag != INTERFERENCE_DATA_AVAILABLE) {
-		IWL_DEBUG_CALIB("<< invalid data.\n");
-		spin_unlock_irqrestore(&priv->lock, flags);
-		return;
-	}
-
-	/* Extract Statistics: */
-	rx_enable_time = le32_to_cpu(rx_info->channel_load);
-	fa_cck = le32_to_cpu(statistics->cck.false_alarm_cnt);
-	fa_ofdm = le32_to_cpu(statistics->ofdm.false_alarm_cnt);
-	bad_plcp_cck = le32_to_cpu(statistics->cck.plcp_err);
-	bad_plcp_ofdm = le32_to_cpu(statistics->ofdm.plcp_err);
-
-	statis.beacon_silence_rssi_a =
-			le32_to_cpu(statistics->general.beacon_silence_rssi_a);
-	statis.beacon_silence_rssi_b =
-			le32_to_cpu(statistics->general.beacon_silence_rssi_b);
-	statis.beacon_silence_rssi_c =
-			le32_to_cpu(statistics->general.beacon_silence_rssi_c);
-	statis.beacon_energy_a =
-			le32_to_cpu(statistics->general.beacon_energy_a);
-	statis.beacon_energy_b =
-			le32_to_cpu(statistics->general.beacon_energy_b);
-	statis.beacon_energy_c =
-			le32_to_cpu(statistics->general.beacon_energy_c);
-
-	spin_unlock_irqrestore(&priv->lock, flags);
-
-	IWL_DEBUG_CALIB("rx_enable_time = %u usecs\n", rx_enable_time);
-
-	if (!rx_enable_time) {
-		IWL_DEBUG_CALIB("<< RX Enable Time == 0! \n");
-		return;
-	}
-
-	/* These statistics increase monotonically, and do not reset
-	 *   at each beacon.  Calculate difference from last value, or just
-	 *   use the new statistics value if it has reset or wrapped around. */
-	if (data->last_bad_plcp_cnt_cck > bad_plcp_cck)
-		data->last_bad_plcp_cnt_cck = bad_plcp_cck;
-	else {
-		bad_plcp_cck -= data->last_bad_plcp_cnt_cck;
-		data->last_bad_plcp_cnt_cck += bad_plcp_cck;
-	}
-
-	if (data->last_bad_plcp_cnt_ofdm > bad_plcp_ofdm)
-		data->last_bad_plcp_cnt_ofdm = bad_plcp_ofdm;
-	else {
-		bad_plcp_ofdm -= data->last_bad_plcp_cnt_ofdm;
-		data->last_bad_plcp_cnt_ofdm += bad_plcp_ofdm;
 	}
+	IWL_DEBUG_CALIB("delta_gain_codes: a %d b %d c %d\n",
+		     data->delta_gain_code[0],
+		     data->delta_gain_code[1],
+		     data->delta_gain_code[2]);
 
-	if (data->last_fa_cnt_ofdm > fa_ofdm)
-		data->last_fa_cnt_ofdm = fa_ofdm;
-	else {
-		fa_ofdm -= data->last_fa_cnt_ofdm;
-		data->last_fa_cnt_ofdm += fa_ofdm;
-	}
+	/* Differential gain gets sent to uCode only once */
+	if (!data->radio_write) {
+		struct iwl4965_calibration_cmd cmd;
+		data->radio_write = 1;
 
-	if (data->last_fa_cnt_cck > fa_cck)
-		data->last_fa_cnt_cck = fa_cck;
-	else {
-		fa_cck -= data->last_fa_cnt_cck;
-		data->last_fa_cnt_cck += fa_cck;
+		memset(&cmd, 0, sizeof(cmd));
+		cmd.opCode = PHY_CALIBRATE_DIFF_GAIN_CMD;
+		cmd.diff_gain_a = data->delta_gain_code[0];
+		cmd.diff_gain_b = data->delta_gain_code[1];
+		cmd.diff_gain_c = data->delta_gain_code[2];
+		ret = iwl_send_cmd_pdu(priv, REPLY_PHY_CALIBRATION_CMD,
+				      sizeof(cmd), &cmd);
+		if (ret)
+			IWL_DEBUG_CALIB("fail sending cmd "
+				     "REPLY_PHY_CALIBRATION_CMD \n");
+
+		/* TODO we might want recalculate
+		 * rx_chain in rxon cmd */
+
+		/* Mark so we run this algo only once! */
+		data->state = IWL_CHAIN_NOISE_CALIBRATED;
 	}
-
-	/* Total aborted signal locks */
-	norm_fa_ofdm = fa_ofdm + bad_plcp_ofdm;
-	norm_fa_cck = fa_cck + bad_plcp_cck;
-
-	IWL_DEBUG_CALIB("cck: fa %u badp %u  ofdm: fa %u badp %u\n", fa_cck,
-			bad_plcp_cck, fa_ofdm, bad_plcp_ofdm);
-
-	iwl4965_sens_auto_corr_ofdm(priv, norm_fa_ofdm, rx_enable_time);
-	iwl4965_sens_energy_cck(priv, norm_fa_cck, rx_enable_time, &statis);
-	ret = iwl4965_sensitivity_write(priv, CMD_ASYNC);
-
-	return;
+	data->chain_noise_a = 0;
+	data->chain_noise_b = 0;
+	data->chain_noise_c = 0;
+	data->chain_signal_a = 0;
+	data->chain_signal_b = 0;
+	data->chain_signal_c = 0;
+	data->beacon_count = 0;
 }
 
 static void iwl4965_bg_sensitivity_work(struct work_struct *work)
@@ -1819,21 +1136,15 @@ static void iwl4965_bg_sensitivity_work(struct work_struct *work)
 	}
 
 	if (priv->start_calib) {
-		iwl4965_noise_calibration(priv, &priv->statistics);
-
-		if (priv->sensitivity_data.state ==
-					IWL_SENS_CALIB_NEED_REINIT) {
-			iwl4965_init_sensitivity(priv, CMD_ASYNC, 0);
-			priv->sensitivity_data.state = IWL_SENS_CALIB_ALLOWED;
-		} else
-			iwl4965_sensitivity_calibration(priv,
-					&priv->statistics);
+		iwl_chain_noise_calibration(priv, &priv->statistics);
+
+		iwl_sensitivity_calibration(priv, &priv->statistics);
 	}
 
 	mutex_unlock(&priv->mutex);
 	return;
 }
-#endif /*CONFIG_IWL4965_SENSITIVITY*/
+#endif /*CONFIG_IWL4965_RUN_TIME_CALIB*/
 
 static void iwl4965_bg_txpower_work(struct work_struct *work)
 {
@@ -1932,15 +1243,15 @@ int iwl4965_alive_notify(struct iwl_priv *priv)
 
 	spin_lock_irqsave(&priv->lock, flags);
 
-#ifdef CONFIG_IWL4965_SENSITIVITY
+#ifdef CONFIG_IWL4965_RUN_TIME_CALIB
 	memset(&(priv->sensitivity_data), 0,
-	       sizeof(struct iwl4965_sensitivity_data));
+	       sizeof(struct iwl_sensitivity_data));
 	memset(&(priv->chain_noise_data), 0,
-	       sizeof(struct iwl4965_chain_noise_data));
+	       sizeof(struct iwl_chain_noise_data));
 	for (i = 0; i < NUM_RX_CHAINS; i++)
 		priv->chain_noise_data.delta_gain_code[i] =
 				CHAIN_NOISE_DELTA_GAIN_INIT_VAL;
-#endif /* CONFIG_IWL4965_SENSITIVITY*/
+#endif /* CONFIG_IWL4965_RUN_TIME_CALIB*/
 	ret = iwl_grab_nic_access(priv);
 	if (ret) {
 		spin_unlock_irqrestore(&priv->lock, flags);
@@ -2013,6 +1324,31 @@ int iwl4965_alive_notify(struct iwl_priv *priv)
 	return ret;
 }
 
+#ifdef CONFIG_IWL4965_RUN_TIME_CALIB
+static struct iwl_sensitivity_ranges iwl4965_sensitivity = {
+	.min_nrg_cck = 97,
+	.max_nrg_cck = 0,
+
+	.auto_corr_min_ofdm = 85,
+	.auto_corr_min_ofdm_mrc = 170,
+	.auto_corr_min_ofdm_x1 = 105,
+	.auto_corr_min_ofdm_mrc_x1 = 220,
+
+	.auto_corr_max_ofdm = 120,
+	.auto_corr_max_ofdm_mrc = 210,
+	.auto_corr_max_ofdm_x1 = 140,
+	.auto_corr_max_ofdm_mrc_x1 = 270,
+
+	.auto_corr_min_cck = 125,
+	.auto_corr_max_cck = 200,
+	.auto_corr_min_cck_mrc = 200,
+	.auto_corr_max_cck_mrc = 400,
+
+	.nrg_th_cck = 100,
+	.nrg_th_ofdm = 100,
+};
+#endif
+
 /**
  * iwl4965_hw_set_hw_params
  *
@@ -2044,6 +1380,9 @@ int iwl4965_hw_set_hw_params(struct iwl_priv *priv)
 	priv->hw_params.rx_chains_num = 2;
 	priv->hw_params.valid_tx_ant = (IWL_ANTENNA_MAIN | IWL_ANTENNA_AUX);
 	priv->hw_params.valid_rx_ant = (IWL_ANTENNA_MAIN | IWL_ANTENNA_AUX);
+#ifdef CONFIG_IWL4965_RUN_TIME_CALIB
+	priv->hw_params.sens = &iwl4965_sensitivity;
+#endif
 
 	return 0;
 }
@@ -3202,7 +2541,7 @@ void iwl4965_set_rxon_chain(struct iwl_priv *priv)
 
 	/* Tell uCode which antennas are actually connected.
 	 * Before first association, we assume all antennas are connected.
-	 * Just after first association, iwl4965_noise_calibration()
+	 * Just after first association, iwl_chain_noise_calibration()
 	 *    checks which antennas actually *are* connected. */
 	priv->staging_rxon.rx_chain |=
 	    cpu_to_le16(priv->valid_antenna << RXON_RX_CHAIN_VALID_POS);
@@ -3412,7 +2751,7 @@ void iwl4965_hw_rx_statistics(struct iwl_priv *priv, struct iwl4965_rx_mem_buffe
 	if (unlikely(!test_bit(STATUS_SCANNING, &priv->status)) &&
 	    (pkt->hdr.cmd == STATISTICS_NOTIFICATION)) {
 		iwl4965_rx_calc_noise(priv);
-#ifdef CONFIG_IWL4965_SENSITIVITY
+#ifdef CONFIG_IWL4965_RUN_TIME_CALIB
 		queue_work(priv->workqueue, &priv->sensitivity_work);
 #endif
 	}
@@ -4139,7 +3478,7 @@ static void iwl4965_rx_missed_beacon_notif(struct iwl_priv *priv,
 					   struct iwl4965_rx_mem_buffer *rxb)
 
 {
-#ifdef CONFIG_IWL4965_SENSITIVITY
+#ifdef CONFIG_IWL4965_RUN_TIME_CALIB
 	struct iwl4965_rx_packet *pkt = (void *)rxb->skb->data;
 	struct iwl4965_missed_beacon_notif *missed_beacon;
 
@@ -4150,11 +3489,10 @@ static void iwl4965_rx_missed_beacon_notif(struct iwl_priv *priv,
 		    le32_to_cpu(missed_beacon->total_missed_becons),
 		    le32_to_cpu(missed_beacon->num_recvd_beacons),
 		    le32_to_cpu(missed_beacon->num_expected_beacons));
-		priv->sensitivity_data.state = IWL_SENS_CALIB_NEED_REINIT;
-		if (unlikely(!test_bit(STATUS_SCANNING, &priv->status)))
-			queue_work(priv->workqueue, &priv->sensitivity_work);
+		if (!test_bit(STATUS_SCANNING, &priv->status))
+			iwl_init_sensitivity(priv);
 	}
-#endif /*CONFIG_IWL4965_SENSITIVITY*/
+#endif /*CONFIG_IWL4965_RUN_TIME_CALIB*/
 }
 #ifdef CONFIG_IWL4965_HT
 
@@ -4930,7 +4268,7 @@ void iwl4965_hw_rx_handler_setup(struct iwl_priv *priv)
 void iwl4965_hw_setup_deferred_work(struct iwl_priv *priv)
 {
 	INIT_WORK(&priv->txpower_work, iwl4965_bg_txpower_work);
-#ifdef CONFIG_IWL4965_SENSITIVITY
+#ifdef CONFIG_IWL4965_RUN_TIME_CALIB
 	INIT_WORK(&priv->sensitivity_work, iwl4965_bg_sensitivity_work);
 #endif
 	init_timer(&priv->statistics_periodic);
@@ -4952,6 +4290,10 @@ static struct iwl_hcmd_ops iwl4965_hcmd = {
 
 static struct iwl_hcmd_utils_ops iwl4965_hcmd_utils = {
 	.enqueue_hcmd = iwl4965_enqueue_hcmd,
+#ifdef CONFIG_IWL4965_RUN_TIME_CALIB
+	.chain_noise_reset = iwl4965_chain_noise_reset,
+	.gain_computation = iwl4965_gain_computation,
+#endif
 };
 
 static struct iwl_lib_ops iwl4965_lib = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.h b/drivers/net/wireless/iwlwifi/iwl-4965.h
index 9ed13cb..9835aff 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.h
@@ -566,6 +566,29 @@ struct iwl4965_ibss_seq {
 	struct list_head list;
 };
 
+struct iwl_sensitivity_ranges {
+	u16 min_nrg_cck;
+	u16 max_nrg_cck;
+
+	u16 nrg_th_cck;
+	u16 nrg_th_ofdm;
+
+	u16 auto_corr_min_ofdm;
+	u16 auto_corr_min_ofdm_mrc;
+	u16 auto_corr_min_ofdm_x1;
+	u16 auto_corr_min_ofdm_mrc_x1;
+
+	u16 auto_corr_max_ofdm;
+	u16 auto_corr_max_ofdm_mrc;
+	u16 auto_corr_max_ofdm_x1;
+	u16 auto_corr_max_ofdm_mrc_x1;
+
+	u16 auto_corr_max_cck;
+	u16 auto_corr_max_cck_mrc;
+	u16 auto_corr_min_cck;
+	u16 auto_corr_min_cck_mrc;
+};
+
 /**
  * struct iwl_hw_params
  * @max_txq_num: Max # Tx queues supported
@@ -576,6 +599,7 @@ struct iwl4965_ibss_seq {
  * @max_rxq_log: Log-base-2 of max_rxq_size
  * @max_stations:
  * @bcast_sta_id:
+ * @struct iwl_sensitivity_ranges: range of sensitivity values
  */
 struct iwl_hw_params {
 	u16 max_txq_num;
@@ -590,6 +614,9 @@ struct iwl_hw_params {
 	u32 max_pkt_size;
 	u8  max_stations;
 	u8  bcast_sta_id;
+#ifdef CONFIG_IWLWIFI_RUN_TIME_CALIB
+	const struct iwl_sensitivity_ranges *sens;
+#endif
 };
 
 #define HT_SHORT_GI_20MHZ_ONLY          (1 << 0)
@@ -732,9 +759,6 @@ extern void iwl4965_add_station(struct iwl_priv *priv, const u8 *addr,
 extern void iwl4965_set_rxon_chain(struct iwl_priv *priv);
 extern int iwl4965_alive_notify(struct iwl_priv *priv);
 extern void iwl4965_update_rate_scaling(struct iwl_priv *priv, u8 mode);
-extern void iwl4965_chain_noise_reset(struct iwl_priv *priv);
-extern void iwl4965_init_sensitivity(struct iwl_priv *priv, u8 flags,
-				     u8 force);
 extern void iwl4965_rf_kill_ct_config(struct iwl_priv *priv);
 extern void iwl4965_hwrate_to_tx_control(struct iwl_priv *priv,
 					 u32 rate_n_flags,
@@ -818,23 +842,8 @@ struct iwl4965_lq_mngr {
 #define MAX_FA_CCK   50
 #define MIN_FA_CCK   5
 
-#define NRG_MIN_CCK  97
-#define NRG_MAX_CCK  0
-
-#define AUTO_CORR_MIN_OFDM        85
-#define AUTO_CORR_MIN_OFDM_MRC    170
-#define AUTO_CORR_MIN_OFDM_X1     105
-#define AUTO_CORR_MIN_OFDM_MRC_X1 220
-#define AUTO_CORR_MAX_OFDM        120
-#define AUTO_CORR_MAX_OFDM_MRC    210
-#define AUTO_CORR_MAX_OFDM_X1     140
-#define AUTO_CORR_MAX_OFDM_MRC_X1 270
 #define AUTO_CORR_STEP_OFDM       1
 
-#define AUTO_CORR_MIN_CCK      (125)
-#define AUTO_CORR_MAX_CCK      (200)
-#define AUTO_CORR_MIN_CCK_MRC  200
-#define AUTO_CORR_MAX_CCK_MRC  400
 #define AUTO_CORR_STEP_CCK     3
 #define AUTO_CORR_MAX_TH_CCK   160
 
@@ -865,11 +874,6 @@ enum iwl4965_chain_noise_state {
 	IWL_CHAIN_NOISE_CALIBRATED = 2,
 };
 
-enum iwl4965_sensitivity_state {
-	IWL_SENS_CALIB_ALLOWED = 0,
-	IWL_SENS_CALIB_NEED_REINIT = 1,
-};
-
 enum iwl4965_calib_enabled_state {
 	IWL_CALIB_DISABLED = 0,  /* must be 0 */
 	IWL_CALIB_ENABLED = 1,
@@ -884,8 +888,9 @@ struct statistics_general_data {
 	u32 beacon_energy_c;
 };
 
+#ifdef CONFIG_IWLWIFI_RUN_TIME_CALIB
 /* Sensitivity calib data */
-struct iwl4965_sensitivity_data {
+struct iwl_sensitivity_data {
 	u32 auto_corr_ofdm;
 	u32 auto_corr_ofdm_mrc;
 	u32 auto_corr_ofdm_x1;
@@ -909,12 +914,10 @@ struct iwl4965_sensitivity_data {
 	s32 nrg_auto_corr_silence_diff;
 	u32 num_in_cck_no_fa;
 	u32 nrg_th_ofdm;
-
-	u8 state;
 };
 
 /* Chain noise (differential Rx gain) calib data */
-struct iwl4965_chain_noise_data {
+struct iwl_chain_noise_data {
 	u8 state;
 	u16 beacon_count;
 	u32 chain_noise_a;
@@ -927,6 +930,7 @@ struct iwl4965_chain_noise_data {
 	u8 delta_gain_code[NUM_RX_CHAINS];
 	u8 radio_write;
 };
+#endif /* CONFIG_IWLWIFI_RUN_TIME_CALIB */
 
 #define	EEPROM_SEM_TIMEOUT 10		/* milliseconds */
 #define EEPROM_SEM_RETRY_LIMIT 1000	/* number of attempts (not time) */
@@ -1052,12 +1056,12 @@ struct iwl_priv {
 	u8 assoc_station_added;
 	u8 use_ant_b_for_management_frame;	/* Tx antenna selection */
 	u8 valid_antenna;	/* Bit mask of antennas actually connected */
-#ifdef CONFIG_IWL4965_SENSITIVITY
-	struct iwl4965_sensitivity_data sensitivity_data;
-	struct iwl4965_chain_noise_data chain_noise_data;
 	u8 start_calib;
+#ifdef CONFIG_IWLWIFI_RUN_TIME_CALIB
+	struct iwl_sensitivity_data sensitivity_data;
+	struct iwl_chain_noise_data chain_noise_data;
 	__le16 sensitivity_tbl[HD_TABLE_SIZE];
-#endif /*CONFIG_IWL4965_SENSITIVITY*/
+#endif /*CONFIG_IWLWIFI_RUN_TIME_CALIB*/
 
 #ifdef CONFIG_IWL4965_HT
 	struct iwl_ht_info current_ht_config;
@@ -1207,7 +1211,7 @@ struct iwl_priv {
 #endif /* CONFIG_IWLWIFI_DEBUG */
 
 	struct work_struct txpower_work;
-#ifdef CONFIG_IWL4965_SENSITIVITY
+#ifdef CONFIG_IWL4965_RUN_TIME_CALIB
 	struct work_struct sensitivity_work;
 #endif
 	struct timer_list statistics_periodic;
diff --git a/drivers/net/wireless/iwlwifi/iwl-calib.c b/drivers/net/wireless/iwlwifi/iwl-calib.c
new file mode 100644
index 0000000..16213b0
--- /dev/null
+++ b/drivers/net/wireless/iwlwifi/iwl-calib.c
@@ -0,0 +1,778 @@
+/******************************************************************************
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2008 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
+ * USA
+ *
+ * The full GNU General Public License is included in this distribution
+ * in the file called LICENSE.GPL.
+ *
+ * Contact Information:
+ * Tomas Winkler <tomas.winkler@intel.com>
+ * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
+ *
+ * BSD LICENSE
+ *
+ * Copyright(c) 2005 - 2008 Intel Corporation. All rights reserved.
+ * All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ *  * Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ *  * Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in
+ *    the documentation and/or other materials provided with the
+ *    distribution.
+ *  * Neither the name Intel Corporation nor the names of its
+ *    contributors may be used to endorse or promote products derived
+ *    from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *****************************************************************************/
+
+#include <linux/kernel.h>
+#include <net/mac80211.h>
+
+#include "iwl-4965.h"
+#include "iwl-core.h"
+#include "iwl-calib.h"
+#include "iwl-eeprom.h"
+
+/* "false alarms" are signals that our DSP tries to lock onto,
+ *   but then determines that they are either noise, or transmissions
+ *   from a distant wireless network (also "noise", really) that get
+ *   "stepped on" by stronger transmissions within our own network.
+ * This algorithm attempts to set a sensitivity level that is high
+ *   enough to receive all of our own network traffic, but not so
+ *   high that our DSP gets too busy trying to lock onto non-network
+ *   activity/noise. */
+static int iwl_sens_energy_cck(struct iwl_priv *priv,
+				   u32 norm_fa,
+				   u32 rx_enable_time,
+				   struct statistics_general_data *rx_info)
+{
+	u32 max_nrg_cck = 0;
+	int i = 0;
+	u8 max_silence_rssi = 0;
+	u32 silence_ref = 0;
+	u8 silence_rssi_a = 0;
+	u8 silence_rssi_b = 0;
+	u8 silence_rssi_c = 0;
+	u32 val;
+
+	/* "false_alarms" values below are cross-multiplications to assess the
+	 *   numbers of false alarms within the measured period of actual Rx
+	 *   (Rx is off when we're txing), vs the min/max expected false alarms
+	 *   (some should be expected if rx is sensitive enough) in a
+	 *   hypothetical listening period of 200 time units (TU), 204.8 msec:
+	 *
+	 * MIN_FA/fixed-time < false_alarms/actual-rx-time < MAX_FA/beacon-time
+	 *
+	 * */
+	u32 false_alarms = norm_fa * 200 * 1024;
+	u32 max_false_alarms = MAX_FA_CCK * rx_enable_time;
+	u32 min_false_alarms = MIN_FA_CCK * rx_enable_time;
+	struct iwl_sensitivity_data *data = NULL;
+	const struct iwl_sensitivity_ranges *ranges = priv->hw_params.sens;
+
+	data = &(priv->sensitivity_data);
+
+	data->nrg_auto_corr_silence_diff = 0;
+
+	/* Find max silence rssi among all 3 receivers.
+	 * This is background noise, which may include transmissions from other
+	 *    networks, measured during silence before our network's beacon */
+	silence_rssi_a = (u8)((rx_info->beacon_silence_rssi_a &
+			    ALL_BAND_FILTER) >> 8);
+	silence_rssi_b = (u8)((rx_info->beacon_silence_rssi_b &
+			    ALL_BAND_FILTER) >> 8);
+	silence_rssi_c = (u8)((rx_info->beacon_silence_rssi_c &
+			    ALL_BAND_FILTER) >> 8);
+
+	val = max(silence_rssi_b, silence_rssi_c);
+	max_silence_rssi = max(silence_rssi_a, (u8) val);
+
+	/* Store silence rssi in 20-beacon history table */
+	data->nrg_silence_rssi[data->nrg_silence_idx] = max_silence_rssi;
+	data->nrg_silence_idx++;
+	if (data->nrg_silence_idx >= NRG_NUM_PREV_STAT_L)
+		data->nrg_silence_idx = 0;
+
+	/* Find max silence rssi across 20 beacon history */
+	for (i = 0; i < NRG_NUM_PREV_STAT_L; i++) {
+		val = data->nrg_silence_rssi[i];
+		silence_ref = max(silence_ref, val);
+	}
+	IWL_DEBUG_CALIB("silence a %u, b %u, c %u, 20-bcn max %u\n",
+			silence_rssi_a, silence_rssi_b, silence_rssi_c,
+			silence_ref);
+
+	/* Find max rx energy (min value!) among all 3 receivers,
+	 *   measured during beacon frame.
+	 * Save it in 10-beacon history table. */
+	i = data->nrg_energy_idx;
+	val = min(rx_info->beacon_energy_b, rx_info->beacon_energy_c);
+	data->nrg_value[i] = min(rx_info->beacon_energy_a, val);
+
+	data->nrg_energy_idx++;
+	if (data->nrg_energy_idx >= 10)
+		data->nrg_energy_idx = 0;
+
+	/* Find min rx energy (max value) across 10 beacon history.
+	 * This is the minimum signal level that we want to receive well.
+	 * Add backoff (margin so we don't miss slightly lower energy frames).
+	 * This establishes an upper bound (min value) for energy threshold. */
+	max_nrg_cck = data->nrg_value[0];
+	for (i = 1; i < 10; i++)
+		max_nrg_cck = (u32) max(max_nrg_cck, (data->nrg_value[i]));
+	max_nrg_cck += 6;
+
+	IWL_DEBUG_CALIB("rx energy a %u, b %u, c %u, 10-bcn max/min %u\n",
+			rx_info->beacon_energy_a, rx_info->beacon_energy_b,
+			rx_info->beacon_energy_c, max_nrg_cck - 6);
+
+	/* Count number of consecutive beacons with fewer-than-desired
+	 *   false alarms. */
+	if (false_alarms < min_false_alarms)
+		data->num_in_cck_no_fa++;
+	else
+		data->num_in_cck_no_fa = 0;
+	IWL_DEBUG_CALIB("consecutive bcns with few false alarms = %u\n",
+			data->num_in_cck_no_fa);
+
+	/* If we got too many false alarms this time, reduce sensitivity */
+	if ((false_alarms > max_false_alarms) &&
+		(data->auto_corr_cck > AUTO_CORR_MAX_TH_CCK)) {
+		IWL_DEBUG_CALIB("norm FA %u > max FA %u\n",
+		     false_alarms, max_false_alarms);
+		IWL_DEBUG_CALIB("... reducing sensitivity\n");
+		data->nrg_curr_state = IWL_FA_TOO_MANY;
+		/* Store for "fewer than desired" on later beacon */
+		data->nrg_silence_ref = silence_ref;
+
+		/* increase energy threshold (reduce nrg value)
+		 *   to decrease sensitivity */
+		if (data->nrg_th_cck >
+			(ranges->max_nrg_cck + NRG_STEP_CCK))
+			data->nrg_th_cck = data->nrg_th_cck
+						 - NRG_STEP_CCK;
+		else
+			data->nrg_th_cck = ranges->max_nrg_cck;
+	/* Else if we got fewer than desired, increase sensitivity */
+	} else if (false_alarms < min_false_alarms) {
+		data->nrg_curr_state = IWL_FA_TOO_FEW;
+
+		/* Compare silence level with silence level for most recent
+		 *   healthy number or too many false alarms */
+		data->nrg_auto_corr_silence_diff = (s32)data->nrg_silence_ref -
+						   (s32)silence_ref;
+
+		IWL_DEBUG_CALIB("norm FA %u < min FA %u, silence diff %d\n",
+			 false_alarms, min_false_alarms,
+			 data->nrg_auto_corr_silence_diff);
+
+		/* Increase value to increase sensitivity, but only if:
+		 * 1a) previous beacon did *not* have *too many* false alarms
+		 * 1b) AND there's a significant difference in Rx levels
+		 *      from a previous beacon with too many, or healthy # FAs
+		 * OR 2) We've seen a lot of beacons (100) with too few
+		 *       false alarms */
+		if ((data->nrg_prev_state != IWL_FA_TOO_MANY) &&
+			((data->nrg_auto_corr_silence_diff > NRG_DIFF) ||
+			(data->num_in_cck_no_fa > MAX_NUMBER_CCK_NO_FA))) {
+
+			IWL_DEBUG_CALIB("... increasing sensitivity\n");
+			/* Increase nrg value to increase sensitivity */
+			val = data->nrg_th_cck + NRG_STEP_CCK;
+			data->nrg_th_cck = min((u32)ranges->min_nrg_cck, val);
+		} else {
+			IWL_DEBUG_CALIB("... but not changing sensitivity\n");
+		}
+
+	/* Else we got a healthy number of false alarms, keep status quo */
+	} else {
+		IWL_DEBUG_CALIB(" FA in safe zone\n");
+		data->nrg_curr_state = IWL_FA_GOOD_RANGE;
+
+		/* Store for use in "fewer than desired" with later beacon */
+		data->nrg_silence_ref = silence_ref;
+
+		/* If previous beacon had too many false alarms,
+		 *   give it some extra margin by reducing sensitivity again
+		 *   (but don't go below measured energy of desired Rx) */
+		if (IWL_FA_TOO_MANY == data->nrg_prev_state) {
+			IWL_DEBUG_CALIB("... increasing margin\n");
+			if (data->nrg_th_cck > (max_nrg_cck + NRG_MARGIN))
+				data->nrg_th_cck -= NRG_MARGIN;
+			else
+				data->nrg_th_cck = max_nrg_cck;
+		}
+	}
+
+	/* Make sure the energy threshold does not go above the measured
+	 * energy of the desired Rx signals (reduced by backoff margin),
+	 * or else we might start missing Rx frames.
+	 * Lower value is higher energy, so we use max()!
+	 */
+	data->nrg_th_cck = max(max_nrg_cck, data->nrg_th_cck);
+	IWL_DEBUG_CALIB("new nrg_th_cck %u\n", data->nrg_th_cck);
+
+	data->nrg_prev_state = data->nrg_curr_state;
+
+	/* Auto-correlation CCK algorithm */
+	if (false_alarms > min_false_alarms) {
+
+		/* increase auto_corr values to decrease sensitivity
+		 * so the DSP won't be disturbed by the noise
+		 */
+		if (data->auto_corr_cck < AUTO_CORR_MAX_TH_CCK)
+			data->auto_corr_cck = AUTO_CORR_MAX_TH_CCK + 1;
+		else {
+			val = data->auto_corr_cck + AUTO_CORR_STEP_CCK;
+			data->auto_corr_cck =
+				min((u32)ranges->auto_corr_max_cck, val);
+		}
+		val = data->auto_corr_cck_mrc + AUTO_CORR_STEP_CCK;
+		data->auto_corr_cck_mrc =
+			min((u32)ranges->auto_corr_max_cck_mrc, val);
+	} else if ((false_alarms < min_false_alarms) &&
+	   ((data->nrg_auto_corr_silence_diff > NRG_DIFF) ||
+	   (data->num_in_cck_no_fa > MAX_NUMBER_CCK_NO_FA))) {
+
+		/* Decrease auto_corr values to increase sensitivity */
+		val = data->auto_corr_cck - AUTO_CORR_STEP_CCK;
+		data->auto_corr_cck =
+			max((u32)ranges->auto_corr_min_cck, val);
+		val = data->auto_corr_cck_mrc - AUTO_CORR_STEP_CCK;
+		data->auto_corr_cck_mrc =
+			max((u32)ranges->auto_corr_min_cck_mrc, val);
+	}
+
+	return 0;
+}
+
+
+static int iwl_sens_auto_corr_ofdm(struct iwl_priv *priv,
+				       u32 norm_fa,
+				       u32 rx_enable_time)
+{
+	u32 val;
+	u32 false_alarms = norm_fa * 200 * 1024;
+	u32 max_false_alarms = MAX_FA_OFDM * rx_enable_time;
+	u32 min_false_alarms = MIN_FA_OFDM * rx_enable_time;
+	struct iwl_sensitivity_data *data = NULL;
+	const struct iwl_sensitivity_ranges *ranges = priv->hw_params.sens;
+
+	data = &(priv->sensitivity_data);
+
+	/* If we got too many false alarms this time, reduce sensitivity */
+	if (false_alarms > max_false_alarms) {
+
+		IWL_DEBUG_CALIB("norm FA %u > max FA %u)\n",
+			     false_alarms, max_false_alarms);
+
+		val = data->auto_corr_ofdm + AUTO_CORR_STEP_OFDM;
+		data->auto_corr_ofdm =
+			min((u32)ranges->auto_corr_max_ofdm, val);
+
+		val = data->auto_corr_ofdm_mrc + AUTO_CORR_STEP_OFDM;
+		data->auto_corr_ofdm_mrc =
+			min((u32)ranges->auto_corr_max_ofdm_mrc, val);
+
+		val = data->auto_corr_ofdm_x1 + AUTO_CORR_STEP_OFDM;
+		data->auto_corr_ofdm_x1 =
+			min((u32)ranges->auto_corr_max_ofdm_x1, val);
+
+		val = data->auto_corr_ofdm_mrc_x1 + AUTO_CORR_STEP_OFDM;
+		data->auto_corr_ofdm_mrc_x1 =
+			min((u32)ranges->auto_corr_max_ofdm_mrc_x1, val);
+	}
+
+	/* Else if we got fewer than desired, increase sensitivity */
+	else if (false_alarms < min_false_alarms) {
+
+		IWL_DEBUG_CALIB("norm FA %u < min FA %u\n",
+			     false_alarms, min_false_alarms);
+
+		val = data->auto_corr_ofdm - AUTO_CORR_STEP_OFDM;
+		data->auto_corr_ofdm =
+			max((u32)ranges->auto_corr_min_ofdm, val);
+
+		val = data->auto_corr_ofdm_mrc - AUTO_CORR_STEP_OFDM;
+		data->auto_corr_ofdm_mrc =
+			max((u32)ranges->auto_corr_min_ofdm_mrc, val);
+
+		val = data->auto_corr_ofdm_x1 - AUTO_CORR_STEP_OFDM;
+		data->auto_corr_ofdm_x1 =
+			max((u32)ranges->auto_corr_min_ofdm_x1, val);
+
+		val = data->auto_corr_ofdm_mrc_x1 - AUTO_CORR_STEP_OFDM;
+		data->auto_corr_ofdm_mrc_x1 =
+			max((u32)ranges->auto_corr_min_ofdm_mrc_x1, val);
+	} else {
+		IWL_DEBUG_CALIB("min FA %u < norm FA %u < max FA %u OK\n",
+			 min_false_alarms, false_alarms, max_false_alarms);
+	}
+	return 0;
+}
+
+/* Prepare a SENSITIVITY_CMD, send to uCode if values have changed */
+static int iwl_sensitivity_write(struct iwl_priv *priv)
+{
+	int ret = 0;
+	struct iwl_sensitivity_cmd cmd ;
+	struct iwl_sensitivity_data *data = NULL;
+	struct iwl_host_cmd cmd_out = {
+		.id = SENSITIVITY_CMD,
+		.len = sizeof(struct iwl_sensitivity_cmd),
+		.meta.flags = CMD_ASYNC,
+		.data = &cmd,
+	};
+
+	data = &(priv->sensitivity_data);
+
+	memset(&cmd, 0, sizeof(cmd));
+
+	cmd.table[HD_AUTO_CORR32_X4_TH_ADD_MIN_INDEX] =
+				cpu_to_le16((u16)data->auto_corr_ofdm);
+	cmd.table[HD_AUTO_CORR32_X4_TH_ADD_MIN_MRC_INDEX] =
+				cpu_to_le16((u16)data->auto_corr_ofdm_mrc);
+	cmd.table[HD_AUTO_CORR32_X1_TH_ADD_MIN_INDEX] =
+				cpu_to_le16((u16)data->auto_corr_ofdm_x1);
+	cmd.table[HD_AUTO_CORR32_X1_TH_ADD_MIN_MRC_INDEX] =
+				cpu_to_le16((u16)data->auto_corr_ofdm_mrc_x1);
+
+	cmd.table[HD_AUTO_CORR40_X4_TH_ADD_MIN_INDEX] =
+				cpu_to_le16((u16)data->auto_corr_cck);
+	cmd.table[HD_AUTO_CORR40_X4_TH_ADD_MIN_MRC_INDEX] =
+				cpu_to_le16((u16)data->auto_corr_cck_mrc);
+
+	cmd.table[HD_MIN_ENERGY_CCK_DET_INDEX] =
+				cpu_to_le16((u16)data->nrg_th_cck);
+	cmd.table[HD_MIN_ENERGY_OFDM_DET_INDEX] =
+				cpu_to_le16((u16)data->nrg_th_ofdm);
+
+	cmd.table[HD_BARKER_CORR_TH_ADD_MIN_INDEX] =
+				__constant_cpu_to_le16(190);
+	cmd.table[HD_BARKER_CORR_TH_ADD_MIN_MRC_INDEX] =
+				__constant_cpu_to_le16(390);
+	cmd.table[HD_OFDM_ENERGY_TH_IN_INDEX] =
+				__constant_cpu_to_le16(62);
+
+	IWL_DEBUG_CALIB("ofdm: ac %u mrc %u x1 %u mrc_x1 %u thresh %u\n",
+			data->auto_corr_ofdm, data->auto_corr_ofdm_mrc,
+			data->auto_corr_ofdm_x1, data->auto_corr_ofdm_mrc_x1,
+			data->nrg_th_ofdm);
+
+	IWL_DEBUG_CALIB("cck: ac %u mrc %u thresh %u\n",
+			data->auto_corr_cck, data->auto_corr_cck_mrc,
+			data->nrg_th_cck);
+
+	/* Update uCode's "work" table, and copy it to DSP */
+	cmd.control = SENSITIVITY_CMD_CONTROL_WORK_TABLE;
+
+	/* Don't send command to uCode if nothing has changed */
+	if (!memcmp(&cmd.table[0], &(priv->sensitivity_tbl[0]),
+		    sizeof(u16)*HD_TABLE_SIZE)) {
+		IWL_DEBUG_CALIB("No change in SENSITIVITY_CMD\n");
+		return 0;
+	}
+
+	/* Copy table for comparison next time */
+	memcpy(&(priv->sensitivity_tbl[0]), &(cmd.table[0]),
+	       sizeof(u16)*HD_TABLE_SIZE);
+
+	ret = iwl_send_cmd(priv, &cmd_out);
+	if (ret)
+		IWL_ERROR("SENSITIVITY_CMD failed\n");
+
+	return ret;
+}
+
+void iwl_init_sensitivity(struct iwl_priv *priv)
+{
+	int ret = 0;
+	int i;
+	struct iwl_sensitivity_data *data = NULL;
+	const struct iwl_sensitivity_ranges *ranges = priv->hw_params.sens;
+
+	IWL_DEBUG_CALIB("Start iwl_init_sensitivity\n");
+
+	/* Clear driver's sensitivity algo data */
+	data = &(priv->sensitivity_data);
+
+	if (ranges == NULL)
+		/* can happen if IWLWIFI_RUN_TIME_CALIB is selected
+		 * but no IWLXXXX_RUN_TIME_CALIB for specific is selected */
+		return;
+
+	memset(data, 0, sizeof(struct iwl_sensitivity_data));
+
+	data->num_in_cck_no_fa = 0;
+	data->nrg_curr_state = IWL_FA_TOO_MANY;
+	data->nrg_prev_state = IWL_FA_TOO_MANY;
+	data->nrg_silence_ref = 0;
+	data->nrg_silence_idx = 0;
+	data->nrg_energy_idx = 0;
+
+	for (i = 0; i < 10; i++)
+		data->nrg_value[i] = 0;
+
+	for (i = 0; i < NRG_NUM_PREV_STAT_L; i++)
+		data->nrg_silence_rssi[i] = 0;
+
+	data->auto_corr_ofdm = 90;
+	data->auto_corr_ofdm_mrc = ranges->auto_corr_min_ofdm_mrc;
+	data->auto_corr_ofdm_x1  = ranges->auto_corr_min_ofdm_x1;
+	data->auto_corr_ofdm_mrc_x1 = ranges->auto_corr_min_ofdm_mrc_x1;
+	data->auto_corr_cck = AUTO_CORR_CCK_MIN_VAL_DEF;
+	data->auto_corr_cck_mrc = ranges->auto_corr_min_cck_mrc;
+	data->nrg_th_cck = ranges->nrg_th_cck;
+	data->nrg_th_ofdm = ranges->nrg_th_ofdm;
+
+	data->last_bad_plcp_cnt_ofdm = 0;
+	data->last_fa_cnt_ofdm = 0;
+	data->last_bad_plcp_cnt_cck = 0;
+	data->last_fa_cnt_cck = 0;
+
+	ret |= iwl_sensitivity_write(priv);
+	IWL_DEBUG_CALIB("<<return 0x%X\n", ret);
+}
+EXPORT_SYMBOL(iwl_init_sensitivity);
+
+void iwl_sensitivity_calibration(struct iwl_priv *priv,
+				    struct iwl4965_notif_statistics *resp)
+{
+	u32 rx_enable_time;
+	u32 fa_cck;
+	u32 fa_ofdm;
+	u32 bad_plcp_cck;
+	u32 bad_plcp_ofdm;
+	u32 norm_fa_ofdm;
+	u32 norm_fa_cck;
+	struct iwl_sensitivity_data *data = NULL;
+	struct statistics_rx_non_phy *rx_info = &(resp->rx.general);
+	struct statistics_rx *statistics = &(resp->rx);
+	unsigned long flags;
+	struct statistics_general_data statis;
+
+	data = &(priv->sensitivity_data);
+
+	if (!iwl_is_associated(priv)) {
+		IWL_DEBUG_CALIB("<< - not associated\n");
+		return;
+	}
+
+	spin_lock_irqsave(&priv->lock, flags);
+	if (rx_info->interference_data_flag != INTERFERENCE_DATA_AVAILABLE) {
+		IWL_DEBUG_CALIB("<< invalid data.\n");
+		spin_unlock_irqrestore(&priv->lock, flags);
+		return;
+	}
+
+	/* Extract Statistics: */
+	rx_enable_time = le32_to_cpu(rx_info->channel_load);
+	fa_cck = le32_to_cpu(statistics->cck.false_alarm_cnt);
+	fa_ofdm = le32_to_cpu(statistics->ofdm.false_alarm_cnt);
+	bad_plcp_cck = le32_to_cpu(statistics->cck.plcp_err);
+	bad_plcp_ofdm = le32_to_cpu(statistics->ofdm.plcp_err);
+
+	statis.beacon_silence_rssi_a =
+			le32_to_cpu(statistics->general.beacon_silence_rssi_a);
+	statis.beacon_silence_rssi_b =
+			le32_to_cpu(statistics->general.beacon_silence_rssi_b);
+	statis.beacon_silence_rssi_c =
+			le32_to_cpu(statistics->general.beacon_silence_rssi_c);
+	statis.beacon_energy_a =
+			le32_to_cpu(statistics->general.beacon_energy_a);
+	statis.beacon_energy_b =
+			le32_to_cpu(statistics->general.beacon_energy_b);
+	statis.beacon_energy_c =
+			le32_to_cpu(statistics->general.beacon_energy_c);
+
+	spin_unlock_irqrestore(&priv->lock, flags);
+
+	IWL_DEBUG_CALIB("rx_enable_time = %u usecs\n", rx_enable_time);
+
+	if (!rx_enable_time) {
+		IWL_DEBUG_CALIB("<< RX Enable Time == 0! \n");
+		return;
+	}
+
+	/* These statistics increase monotonically, and do not reset
+	 *   at each beacon.  Calculate difference from last value, or just
+	 *   use the new statistics value if it has reset or wrapped around. */
+	if (data->last_bad_plcp_cnt_cck > bad_plcp_cck)
+		data->last_bad_plcp_cnt_cck = bad_plcp_cck;
+	else {
+		bad_plcp_cck -= data->last_bad_plcp_cnt_cck;
+		data->last_bad_plcp_cnt_cck += bad_plcp_cck;
+	}
+
+	if (data->last_bad_plcp_cnt_ofdm > bad_plcp_ofdm)
+		data->last_bad_plcp_cnt_ofdm = bad_plcp_ofdm;
+	else {
+		bad_plcp_ofdm -= data->last_bad_plcp_cnt_ofdm;
+		data->last_bad_plcp_cnt_ofdm += bad_plcp_ofdm;
+	}
+
+	if (data->last_fa_cnt_ofdm > fa_ofdm)
+		data->last_fa_cnt_ofdm = fa_ofdm;
+	else {
+		fa_ofdm -= data->last_fa_cnt_ofdm;
+		data->last_fa_cnt_ofdm += fa_ofdm;
+	}
+
+	if (data->last_fa_cnt_cck > fa_cck)
+		data->last_fa_cnt_cck = fa_cck;
+	else {
+		fa_cck -= data->last_fa_cnt_cck;
+		data->last_fa_cnt_cck += fa_cck;
+	}
+
+	/* Total aborted signal locks */
+	norm_fa_ofdm = fa_ofdm + bad_plcp_ofdm;
+	norm_fa_cck = fa_cck + bad_plcp_cck;
+
+	IWL_DEBUG_CALIB("cck: fa %u badp %u  ofdm: fa %u badp %u\n", fa_cck,
+			bad_plcp_cck, fa_ofdm, bad_plcp_ofdm);
+
+	iwl_sens_auto_corr_ofdm(priv, norm_fa_ofdm, rx_enable_time);
+	iwl_sens_energy_cck(priv, norm_fa_cck, rx_enable_time, &statis);
+	iwl_sensitivity_write(priv);
+
+	return;
+}
+EXPORT_SYMBOL(iwl_sensitivity_calibration);
+
+/*
+ * Accumulate 20 beacons of signal and noise statistics for each of
+ *   3 receivers/antennas/rx-chains, then figure out:
+ * 1)  Which antennas are connected.
+ * 2)  Differential rx gain settings to balance the 3 receivers.
+ */
+void iwl_chain_noise_calibration(struct iwl_priv *priv,
+			      struct iwl4965_notif_statistics *stat_resp)
+{
+	struct iwl_chain_noise_data *data = NULL;
+
+	u32 chain_noise_a;
+	u32 chain_noise_b;
+	u32 chain_noise_c;
+	u32 chain_sig_a;
+	u32 chain_sig_b;
+	u32 chain_sig_c;
+	u32 average_sig[NUM_RX_CHAINS] = {INITIALIZATION_VALUE};
+	u32 average_noise[NUM_RX_CHAINS] = {INITIALIZATION_VALUE};
+	u32 max_average_sig;
+	u16 max_average_sig_antenna_i;
+	u32 min_average_noise = MIN_AVERAGE_NOISE_MAX_VALUE;
+	u16 min_average_noise_antenna_i = INITIALIZATION_VALUE;
+	u16 i = 0;
+	u16 rxon_chnum = INITIALIZATION_VALUE;
+	u16 stat_chnum = INITIALIZATION_VALUE;
+	u8 rxon_band24;
+	u8 stat_band24;
+	u32 active_chains = 0;
+	u8 num_tx_chains;
+	unsigned long flags;
+	struct statistics_rx_non_phy *rx_info = &(stat_resp->rx.general);
+
+	data = &(priv->chain_noise_data);
+
+	/* Accumulate just the first 20 beacons after the first association,
+	 *   then we're done forever. */
+	if (data->state != IWL_CHAIN_NOISE_ACCUMULATE) {
+		if (data->state == IWL_CHAIN_NOISE_ALIVE)
+			IWL_DEBUG_CALIB("Wait for noise calib reset\n");
+		return;
+	}
+
+	spin_lock_irqsave(&priv->lock, flags);
+	if (rx_info->interference_data_flag != INTERFERENCE_DATA_AVAILABLE) {
+		IWL_DEBUG_CALIB(" << Interference data unavailable\n");
+		spin_unlock_irqrestore(&priv->lock, flags);
+		return;
+	}
+
+	rxon_band24 = !!(priv->staging_rxon.flags & RXON_FLG_BAND_24G_MSK);
+	rxon_chnum = le16_to_cpu(priv->staging_rxon.channel);
+	stat_band24 = !!(stat_resp->flag & STATISTICS_REPLY_FLG_BAND_24G_MSK);
+	stat_chnum = le32_to_cpu(stat_resp->flag) >> 16;
+
+	/* Make sure we accumulate data for just the associated channel
+	 *   (even if scanning). */
+	if ((rxon_chnum != stat_chnum) || (rxon_band24 != stat_band24)) {
+		IWL_DEBUG_CALIB("Stats not from chan=%d, band24=%d\n",
+				rxon_chnum, rxon_band24);
+		spin_unlock_irqrestore(&priv->lock, flags);
+		return;
+	}
+
+	/* Accumulate beacon statistics values across 20 beacons */
+	chain_noise_a = le32_to_cpu(rx_info->beacon_silence_rssi_a) &
+				IN_BAND_FILTER;
+	chain_noise_b = le32_to_cpu(rx_info->beacon_silence_rssi_b) &
+				IN_BAND_FILTER;
+	chain_noise_c = le32_to_cpu(rx_info->beacon_silence_rssi_c) &
+				IN_BAND_FILTER;
+
+	chain_sig_a = le32_to_cpu(rx_info->beacon_rssi_a) & IN_BAND_FILTER;
+	chain_sig_b = le32_to_cpu(rx_info->beacon_rssi_b) & IN_BAND_FILTER;
+	chain_sig_c = le32_to_cpu(rx_info->beacon_rssi_c) & IN_BAND_FILTER;
+
+	spin_unlock_irqrestore(&priv->lock, flags);
+
+	data->beacon_count++;
+
+	data->chain_noise_a = (chain_noise_a + data->chain_noise_a);
+	data->chain_noise_b = (chain_noise_b + data->chain_noise_b);
+	data->chain_noise_c = (chain_noise_c + data->chain_noise_c);
+
+	data->chain_signal_a = (chain_sig_a + data->chain_signal_a);
+	data->chain_signal_b = (chain_sig_b + data->chain_signal_b);
+	data->chain_signal_c = (chain_sig_c + data->chain_signal_c);
+
+	IWL_DEBUG_CALIB("chan=%d, band24=%d, beacon=%d\n",
+			rxon_chnum, rxon_band24, data->beacon_count);
+	IWL_DEBUG_CALIB("chain_sig: a %d b %d c %d\n",
+			chain_sig_a, chain_sig_b, chain_sig_c);
+	IWL_DEBUG_CALIB("chain_noise: a %d b %d c %d\n",
+			chain_noise_a, chain_noise_b, chain_noise_c);
+
+	/* If this is the 20th beacon, determine:
+	 * 1)  Disconnected antennas (using signal strengths)
+	 * 2)  Differential gain (using silence noise) to balance receivers */
+	if (data->beacon_count != CAL_NUM_OF_BEACONS)
+		return;
+
+	/* Analyze signal for disconnected antenna */
+	average_sig[0] = (data->chain_signal_a) / CAL_NUM_OF_BEACONS;
+	average_sig[1] = (data->chain_signal_b) / CAL_NUM_OF_BEACONS;
+	average_sig[2] = (data->chain_signal_c) / CAL_NUM_OF_BEACONS;
+
+	if (average_sig[0] >= average_sig[1]) {
+		max_average_sig = average_sig[0];
+		max_average_sig_antenna_i = 0;
+		active_chains = (1 << max_average_sig_antenna_i);
+	} else {
+		max_average_sig = average_sig[1];
+		max_average_sig_antenna_i = 1;
+		active_chains = (1 << max_average_sig_antenna_i);
+	}
+
+	if (average_sig[2] >= max_average_sig) {
+		max_average_sig = average_sig[2];
+		max_average_sig_antenna_i = 2;
+		active_chains = (1 << max_average_sig_antenna_i);
+	}
+
+	IWL_DEBUG_CALIB("average_sig: a %d b %d c %d\n",
+		     average_sig[0], average_sig[1], average_sig[2]);
+	IWL_DEBUG_CALIB("max_average_sig = %d, antenna %d\n",
+		     max_average_sig, max_average_sig_antenna_i);
+
+	/* Compare signal strengths for all 3 receivers. */
+	for (i = 0; i < NUM_RX_CHAINS; i++) {
+		if (i != max_average_sig_antenna_i) {
+			s32 rssi_delta = (max_average_sig - average_sig[i]);
+
+			/* If signal is very weak, compared with
+			 * strongest, mark it as disconnected. */
+			if (rssi_delta > MAXIMUM_ALLOWED_PATHLOSS)
+				data->disconn_array[i] = 1;
+			else
+				active_chains |= (1 << i);
+			IWL_DEBUG_CALIB("i = %d  rssiDelta = %d  "
+			     "disconn_array[i] = %d\n",
+			     i, rssi_delta, data->disconn_array[i]);
+		}
+	}
+
+	num_tx_chains = 0;
+	for (i = 0; i < NUM_RX_CHAINS; i++) {
+		/* loops on all the bits of
+		 * priv->hw_setting.valid_tx_ant */
+		u8 ant_msk = (1 << i);
+		if (!(priv->hw_params.valid_tx_ant & ant_msk))
+			continue;
+
+		num_tx_chains++;
+		if (data->disconn_array[i] == 0)
+			/* there is a Tx antenna connected */
+			break;
+		if (num_tx_chains == priv->hw_params.tx_chains_num &&
+		data->disconn_array[i]) {
+			/* This is the last TX antenna and is also
+			 * disconnected connect it anyway */
+			data->disconn_array[i] = 0;
+			active_chains |= ant_msk;
+			IWL_DEBUG_CALIB("All Tx chains are disconnected W/A - "
+				"declare %d as connected\n", i);
+			break;
+		}
+	}
+
+	IWL_DEBUG_CALIB("active_chains (bitwise) = 0x%x\n",
+			active_chains);
+
+	/* Save for use within RXON, TX, SCAN commands, etc. */
+	priv->valid_antenna = active_chains;
+
+	/* Analyze noise for rx balance */
+	average_noise[0] = ((data->chain_noise_a)/CAL_NUM_OF_BEACONS);
+	average_noise[1] = ((data->chain_noise_b)/CAL_NUM_OF_BEACONS);
+	average_noise[2] = ((data->chain_noise_c)/CAL_NUM_OF_BEACONS);
+
+	for (i = 0; i < NUM_RX_CHAINS; i++) {
+		if (!(data->disconn_array[i]) &&
+		   (average_noise[i] <= min_average_noise)) {
+			/* This means that chain i is active and has
+			 * lower noise values so far: */
+			min_average_noise = average_noise[i];
+			min_average_noise_antenna_i = i;
+		}
+	}
+
+	IWL_DEBUG_CALIB("average_noise: a %d b %d c %d\n",
+			average_noise[0], average_noise[1],
+			average_noise[2]);
+
+	IWL_DEBUG_CALIB("min_average_noise = %d, antenna %d\n",
+			min_average_noise, min_average_noise_antenna_i);
+
+	priv->cfg->ops->utils->gain_computation(priv, average_noise,
+		min_average_noise_antenna_i, min_average_noise);
+}
+EXPORT_SYMBOL(iwl_chain_noise_calibration);
+
diff --git a/drivers/net/wireless/iwlwifi/iwl-calib.h b/drivers/net/wireless/iwlwifi/iwl-calib.h
new file mode 100644
index 0000000..c3a3db3
--- /dev/null
+++ b/drivers/net/wireless/iwlwifi/iwl-calib.h
@@ -0,0 +1,104 @@
+/******************************************************************************
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2008 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
+ * USA
+ *
+ * The full GNU General Public License is included in this distribution
+ * in the file called LICENSE.GPL.
+ *
+ * Contact Information:
+ * Tomas Winkler <tomas.winkler@intel.com>
+ * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
+ *
+ * BSD LICENSE
+ *
+ * Copyright(c) 2005 - 2008 Intel Corporation. All rights reserved.
+ * All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ *  * Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ *  * Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in
+ *    the documentation and/or other materials provided with the
+ *    distribution.
+ *  * Neither the name Intel Corporation nor the names of its
+ *    contributors may be used to endorse or promote products derived
+ *    from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *****************************************************************************/
+#ifndef __iwl_calib_h__
+#define __iwl_calib_h__
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/version.h>
+
+#include <net/mac80211.h>
+#include "iwl-eeprom.h"
+#include "iwl-core.h"
+#include "iwl-4965.h"
+
+#ifdef CONFIG_IWLWIFI_RUN_TIME_CALIB
+void iwl_chain_noise_calibration(struct iwl_priv *priv,
+				struct iwl4965_notif_statistics *stat_resp);
+void iwl_sensitivity_calibration(struct iwl_priv *priv,
+				struct iwl4965_notif_statistics *resp);
+
+void iwl_init_sensitivity(struct iwl_priv *priv);
+
+static inline void iwl_chain_noise_reset(struct iwl_priv *priv)
+{
+	if (priv->cfg->ops->utils->chain_noise_reset)
+		priv->cfg->ops->utils->chain_noise_reset(priv);
+}
+#else
+static inline void iwl_chain_noise_calibration(struct iwl_priv *priv,
+				struct iwl4965_notif_statistics *stat_resp)
+{
+}
+static inline void iwl_sensitivity_calibration(struct iwl_priv *priv,
+				struct iwl4965_notif_statistics *resp)
+{
+}
+static inline void iwl_init_sensitivity(struct iwl_priv *priv)
+{
+}
+static inline void iwl_chain_noise_reset(struct iwl_priv *priv)
+{
+}
+#endif
+
+#endif /* __iwl_calib_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 7193d97..dcbd411 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -87,6 +87,13 @@ struct iwl_hcmd_ops {
 };
 struct iwl_hcmd_utils_ops {
 	int (*enqueue_hcmd)(struct iwl_priv *priv, struct iwl_host_cmd *cmd);
+#ifdef CONFIG_IWLWIFI_RUN_TIME_CALIB
+	void (*gain_computation)(struct iwl_priv *priv,
+			u32 *average_noise,
+			u16 min_average_noise_antennat_i,
+			u32 min_average_noise);
+	void (*chain_noise_reset)(struct iwl_priv *priv);
+#endif
 };
 
 struct iwl_lib_ops {
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index d7e2358..e177b6d 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -51,6 +51,7 @@
 #include "iwl-io.h"
 #include "iwl-helpers.h"
 #include "iwl-sta.h"
+#include "iwl-calib.h"
 
 static int iwl4965_tx_queue_update_write_ptr(struct iwl_priv *priv,
 				  struct iwl4965_tx_queue *txq);
@@ -795,14 +796,6 @@ static int iwl4965_commit_rxon(struct iwl_priv *priv)
 	/* station table will be cleared */
 	priv->assoc_station_added = 0;
 
-#ifdef CONFIG_IWL4965_SENSITIVITY
-	priv->sensitivity_data.state = IWL_SENS_CALIB_NEED_REINIT;
-	if (!priv->error_recovering)
-		priv->start_calib = 0;
-
-	iwl4965_init_sensitivity(priv, CMD_ASYNC, 1);
-#endif /* CONFIG_IWL4965_SENSITIVITY */
-
 	/* If we are currently associated and the new config requires
 	 * an RXON_ASSOC and the new config wants the associated mask enabled,
 	 * we must clear the associated from the active configuration
@@ -846,13 +839,10 @@ static int iwl4965_commit_rxon(struct iwl_priv *priv)
 
 	iwlcore_clear_stations_table(priv);
 
-#ifdef CONFIG_IWL4965_SENSITIVITY
 	if (!priv->error_recovering)
 		priv->start_calib = 0;
 
-	priv->sensitivity_data.state = IWL_SENS_CALIB_NEED_REINIT;
-	iwl4965_init_sensitivity(priv, CMD_ASYNC, 1);
-#endif /* CONFIG_IWL4965_SENSITIVITY */
+	iwl_init_sensitivity(priv);
 
 	memcpy(active_rxon, &priv->staging_rxon, sizeof(*active_rxon));
 
@@ -6052,11 +6042,9 @@ static void iwl4965_post_associate(struct iwl_priv *priv)
 
 	iwl4965_sequence_reset(priv);
 
-#ifdef CONFIG_IWL4965_SENSITIVITY
 	/* Enable Rx differential gain and sensitivity calibrations */
-	iwl4965_chain_noise_reset(priv);
+	iwl_chain_noise_reset(priv);
 	priv->start_calib = 1;
-#endif /* CONFIG_IWL4965_SENSITIVITY */
 
 	if (priv->iw_mode == IEEE80211_IF_TYPE_IBSS)
 		priv->assoc_station_added = 1;
-- 
1.5.3.4

