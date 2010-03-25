Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:22725 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752558Ab0CYUoy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Mar 2010 16:44:54 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 05/22] iwlwifi: move hcmd related code to separate file
Date: Thu, 25 Mar 2010 13:44:33 -0700
Message-Id: <1269549890-19195-6-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1269549890-19195-1-git-send-email-reinette.chatre@intel.com>
References: <1269549890-19195-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Multiple iwlagn based devices shared the same hcmd related functions.
Move from iwl-5000.c to iwl-agn-hcmd.c file.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/Makefile       |    2 +-
 drivers/net/wireless/iwlwifi/iwl-1000.c     |    4 +-
 drivers/net/wireless/iwlwifi/iwl-5000.c     |  244 +-----------------------
 drivers/net/wireless/iwlwifi/iwl-6000.c     |    8 +-
 drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c |  274 +++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-agn.h      |    2 +
 6 files changed, 287 insertions(+), 247 deletions(-)
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c

diff --git a/drivers/net/wireless/iwlwifi/Makefile b/drivers/net/wireless/iwlwifi/Makefile
index cc4fe20..46fad2d 100644
--- a/drivers/net/wireless/iwlwifi/Makefile
+++ b/drivers/net/wireless/iwlwifi/Makefile
@@ -10,7 +10,7 @@ CFLAGS_iwl-devtrace.o := -I$(src)
 # AGN
 obj-$(CONFIG_IWLAGN)	+= iwlagn.o
 iwlagn-objs		:= iwl-agn.o iwl-agn-rs.o iwl-agn-led.o iwl-agn-ict.o
-iwlagn-objs		+= iwl-agn-ucode.o
+iwlagn-objs		+= iwl-agn-ucode.o iwl-agn-hcmd.o
 
 iwlagn-$(CONFIG_IWL4965) += iwl-4965.o
 iwlagn-$(CONFIG_IWL5000) += iwl-5000.o
diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index 283c4ed..67d8513 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -220,8 +220,8 @@ static struct iwl_lib_ops iwl1000_lib = {
 static const struct iwl_ops iwl1000_ops = {
 	.ucode = &iwlagn_ucode,
 	.lib = &iwl1000_lib,
-	.hcmd = &iwl5000_hcmd,
-	.utils = &iwl5000_hcmd_utils,
+	.hcmd = &iwlagn_hcmd,
+	.utils = &iwlagn_hcmd_utils,
 	.led = &iwlagn_led_ops,
 };
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index bea2f46..8aa382e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -165,108 +165,6 @@ u16 iwl5000_eeprom_calib_version(struct iwl_priv *priv)
 
 }
 
-static void iwl5000_gain_computation(struct iwl_priv *priv,
-		u32 average_noise[NUM_RX_CHAINS],
-		u16 min_average_noise_antenna_i,
-		u32 min_average_noise,
-		u8 default_chain)
-{
-	int i;
-	s32 delta_g;
-	struct iwl_chain_noise_data *data = &priv->chain_noise_data;
-
-	/*
-	 * Find Gain Code for the chains based on "default chain"
-	 */
-	for (i = default_chain + 1; i < NUM_RX_CHAINS; i++) {
-		if ((data->disconn_array[i])) {
-			data->delta_gain_code[i] = 0;
-			continue;
-		}
-
-		delta_g = (priv->cfg->chain_noise_scale *
-			((s32)average_noise[default_chain] -
-			(s32)average_noise[i])) / 1500;
-
-		/* bound gain by 2 bits value max, 3rd bit is sign */
-		data->delta_gain_code[i] =
-			min(abs(delta_g), (long) CHAIN_NOISE_MAX_DELTA_GAIN_CODE);
-
-		if (delta_g < 0)
-			/*
-			 * set negative sign ...
-			 * note to Intel developers:  This is uCode API format,
-			 *   not the format of any internal device registers.
-			 *   Do not change this format for e.g. 6050 or similar
-			 *   devices.  Change format only if more resolution
-			 *   (i.e. more than 2 bits magnitude) is needed.
-			 */
-			data->delta_gain_code[i] |= (1 << 2);
-	}
-
-	IWL_DEBUG_CALIB(priv, "Delta gains: ANT_B = %d  ANT_C = %d\n",
-			data->delta_gain_code[1], data->delta_gain_code[2]);
-
-	if (!data->radio_write) {
-		struct iwl_calib_chain_noise_gain_cmd cmd;
-
-		memset(&cmd, 0, sizeof(cmd));
-
-		cmd.hdr.op_code = IWL_PHY_CALIBRATE_CHAIN_NOISE_GAIN_CMD;
-		cmd.hdr.first_group = 0;
-		cmd.hdr.groups_num = 1;
-		cmd.hdr.data_valid = 1;
-		cmd.delta_gain_1 = data->delta_gain_code[1];
-		cmd.delta_gain_2 = data->delta_gain_code[2];
-		iwl_send_cmd_pdu_async(priv, REPLY_PHY_CALIBRATION_CMD,
-			sizeof(cmd), &cmd, NULL);
-
-		data->radio_write = 1;
-		data->state = IWL_CHAIN_NOISE_CALIBRATED;
-	}
-
-	data->chain_noise_a = 0;
-	data->chain_noise_b = 0;
-	data->chain_noise_c = 0;
-	data->chain_signal_a = 0;
-	data->chain_signal_b = 0;
-	data->chain_signal_c = 0;
-	data->beacon_count = 0;
-}
-
-static void iwl5000_chain_noise_reset(struct iwl_priv *priv)
-{
-	struct iwl_chain_noise_data *data = &priv->chain_noise_data;
-	int ret;
-
-	if ((data->state == IWL_CHAIN_NOISE_ALIVE) && iwl_is_associated(priv)) {
-		struct iwl_calib_chain_noise_reset_cmd cmd;
-		memset(&cmd, 0, sizeof(cmd));
-
-		cmd.hdr.op_code = IWL_PHY_CALIBRATE_CHAIN_NOISE_RESET_CMD;
-		cmd.hdr.first_group = 0;
-		cmd.hdr.groups_num = 1;
-		cmd.hdr.data_valid = 1;
-		ret = iwl_send_cmd_pdu(priv, REPLY_PHY_CALIBRATION_CMD,
-					sizeof(cmd), &cmd);
-		if (ret)
-			IWL_ERR(priv,
-				"Could not send REPLY_PHY_CALIBRATION_CMD\n");
-		data->state = IWL_CHAIN_NOISE_ACCUMULATE;
-		IWL_DEBUG_CALIB(priv, "Run chain_noise_calibrate\n");
-	}
-}
-
-void iwl5000_rts_tx_cmd_flag(struct ieee80211_tx_info *info,
-			__le32 *tx_flags)
-{
-	if ((info->control.rates[0].flags & IEEE80211_TX_RC_USE_RTS_CTS) ||
-	    (info->control.rates[0].flags & IEEE80211_TX_RC_USE_CTS_PROTECT))
-		*tx_flags |= TX_CMD_FLG_RTS_CTS_MSK;
-	else
-		*tx_flags &= ~TX_CMD_FLG_RTS_CTS_MSK;
-}
-
 static struct iwl_sensitivity_ranges iwl5000_sensitivity = {
 	.min_nrg_cck = 95,
 	.max_nrg_cck = 0, /* not used, set to 0 */
@@ -832,17 +730,6 @@ int iwl5000_txq_agg_disable(struct iwl_priv *priv, u16 txq_id,
 	return 0;
 }
 
-u16 iwl5000_build_addsta_hcmd(const struct iwl_addsta_cmd *cmd, u8 *data)
-{
-	u16 size = (u16)sizeof(struct iwl_addsta_cmd);
-	struct iwl_addsta_cmd *addsta = (struct iwl_addsta_cmd *)data;
-	memcpy(addsta, cmd, size);
-	/* resrved in 5000 */
-	addsta->rate_n_flags = cpu_to_le16(0);
-	return size;
-}
-
-
 /*
  * Activate/Deactivate Tx DMA/FIFO channels according tx fifos mask
  * must be called under priv->lock and mac access
@@ -1064,12 +951,6 @@ static void iwl5000_rx_reply_tx(struct iwl_priv *priv,
 		IWL_ERR(priv, "TODO:  Implement Tx ABORT REQUIRED!!!\n");
 }
 
-/* Currently 5000 is the superset of everything */
-u16 iwl5000_get_hcmd_size(u8 cmd_id, u16 len)
-{
-	return len;
-}
-
 void iwl5000_setup_deferred_work(struct iwl_priv *priv)
 {
 	/* in 5000 the tx power calibration is done in uCode */
@@ -1093,52 +974,6 @@ int iwl5000_hw_valid_rtc_data_addr(u32 addr)
 		(addr < IWL50_RTC_DATA_UPPER_BOUND);
 }
 
-static int iwl5000_send_rxon_assoc(struct iwl_priv *priv)
-{
-	int ret = 0;
-	struct iwl5000_rxon_assoc_cmd rxon_assoc;
-	const struct iwl_rxon_cmd *rxon1 = &priv->staging_rxon;
-	const struct iwl_rxon_cmd *rxon2 = &priv->active_rxon;
-
-	if ((rxon1->flags == rxon2->flags) &&
-	    (rxon1->filter_flags == rxon2->filter_flags) &&
-	    (rxon1->cck_basic_rates == rxon2->cck_basic_rates) &&
-	    (rxon1->ofdm_ht_single_stream_basic_rates ==
-	     rxon2->ofdm_ht_single_stream_basic_rates) &&
-	    (rxon1->ofdm_ht_dual_stream_basic_rates ==
-	     rxon2->ofdm_ht_dual_stream_basic_rates) &&
-	    (rxon1->ofdm_ht_triple_stream_basic_rates ==
-	     rxon2->ofdm_ht_triple_stream_basic_rates) &&
-	    (rxon1->acquisition_data == rxon2->acquisition_data) &&
-	    (rxon1->rx_chain == rxon2->rx_chain) &&
-	    (rxon1->ofdm_basic_rates == rxon2->ofdm_basic_rates)) {
-		IWL_DEBUG_INFO(priv, "Using current RXON_ASSOC.  Not resending.\n");
-		return 0;
-	}
-
-	rxon_assoc.flags = priv->staging_rxon.flags;
-	rxon_assoc.filter_flags = priv->staging_rxon.filter_flags;
-	rxon_assoc.ofdm_basic_rates = priv->staging_rxon.ofdm_basic_rates;
-	rxon_assoc.cck_basic_rates = priv->staging_rxon.cck_basic_rates;
-	rxon_assoc.reserved1 = 0;
-	rxon_assoc.reserved2 = 0;
-	rxon_assoc.reserved3 = 0;
-	rxon_assoc.ofdm_ht_single_stream_basic_rates =
-	    priv->staging_rxon.ofdm_ht_single_stream_basic_rates;
-	rxon_assoc.ofdm_ht_dual_stream_basic_rates =
-	    priv->staging_rxon.ofdm_ht_dual_stream_basic_rates;
-	rxon_assoc.rx_chain_select_flags = priv->staging_rxon.rx_chain;
-	rxon_assoc.ofdm_ht_triple_stream_basic_rates =
-		 priv->staging_rxon.ofdm_ht_triple_stream_basic_rates;
-	rxon_assoc.acquisition_data = priv->staging_rxon.acquisition_data;
-
-	ret = iwl_send_cmd_pdu_async(priv, REPLY_RXON_ASSOC,
-				     sizeof(rxon_assoc), &rxon_assoc, NULL);
-	if (ret)
-		return ret;
-
-	return ret;
-}
 int  iwl5000_send_tx_power(struct iwl_priv *priv)
 {
 	struct iwl5000_tx_power_dbm_cmd tx_power_cmd;
@@ -1194,61 +1029,6 @@ static void iwl5150_temperature(struct iwl_priv *priv)
 	iwl_tt_handler(priv);
 }
 
-/* Calc max signal level (dBm) among 3 possible receivers */
-int iwl5000_calc_rssi(struct iwl_priv *priv,
-			     struct iwl_rx_phy_res *rx_resp)
-{
-	/* data from PHY/DSP regarding signal strength, etc.,
-	 *   contents are always there, not configurable by host
-	 */
-	struct iwl5000_non_cfg_phy *ncphy =
-		(struct iwl5000_non_cfg_phy *)rx_resp->non_cfg_phy_buf;
-	u32 val, rssi_a, rssi_b, rssi_c, max_rssi;
-	u8 agc;
-
-	val  = le32_to_cpu(ncphy->non_cfg_phy[IWL50_RX_RES_AGC_IDX]);
-	agc = (val & IWL50_OFDM_AGC_MSK) >> IWL50_OFDM_AGC_BIT_POS;
-
-	/* Find max rssi among 3 possible receivers.
-	 * These values are measured by the digital signal processor (DSP).
-	 * They should stay fairly constant even as the signal strength varies,
-	 *   if the radio's automatic gain control (AGC) is working right.
-	 * AGC value (see below) will provide the "interesting" info.
-	 */
-	val = le32_to_cpu(ncphy->non_cfg_phy[IWL50_RX_RES_RSSI_AB_IDX]);
-	rssi_a = (val & IWL50_OFDM_RSSI_A_MSK) >> IWL50_OFDM_RSSI_A_BIT_POS;
-	rssi_b = (val & IWL50_OFDM_RSSI_B_MSK) >> IWL50_OFDM_RSSI_B_BIT_POS;
-	val = le32_to_cpu(ncphy->non_cfg_phy[IWL50_RX_RES_RSSI_C_IDX]);
-	rssi_c = (val & IWL50_OFDM_RSSI_C_MSK) >> IWL50_OFDM_RSSI_C_BIT_POS;
-
-	max_rssi = max_t(u32, rssi_a, rssi_b);
-	max_rssi = max_t(u32, max_rssi, rssi_c);
-
-	IWL_DEBUG_STATS(priv, "Rssi In A %d B %d C %d Max %d AGC dB %d\n",
-		rssi_a, rssi_b, rssi_c, max_rssi, agc);
-
-	/* dBm = max_rssi dB - agc dB - constant.
-	 * Higher AGC (higher radio gain) means lower signal. */
-	return max_rssi - agc - IWL49_RSSI_OFFSET;
-}
-
-static int iwl5000_send_tx_ant_config(struct iwl_priv *priv, u8 valid_tx_ant)
-{
-	struct iwl_tx_ant_config_cmd tx_ant_cmd = {
-	  .valid = cpu_to_le32(valid_tx_ant),
-	};
-
-	if (IWL_UCODE_API(priv->ucode_ver) > 1) {
-		IWL_DEBUG_HC(priv, "select valid tx ant: %u\n", valid_tx_ant);
-		return iwl_send_cmd_pdu(priv, TX_ANT_CONFIGURATION_CMD,
-					sizeof(struct iwl_tx_ant_config_cmd),
-					&tx_ant_cmd);
-	} else {
-		IWL_DEBUG_HC(priv, "TX_ANT_CONFIGURATION_CMD not supported\n");
-		return -EOPNOTSUPP;
-	}
-}
-
 static int iwl5000_hw_channel_switch(struct iwl_priv *priv, u16 channel)
 {
 	struct iwl5000_channel_switch_cmd cmd;
@@ -1281,22 +1061,6 @@ static int iwl5000_hw_channel_switch(struct iwl_priv *priv, u16 channel)
 	return iwl_send_cmd_sync(priv, &hcmd);
 }
 
-struct iwl_hcmd_ops iwl5000_hcmd = {
-	.rxon_assoc = iwl5000_send_rxon_assoc,
-	.commit_rxon = iwl_commit_rxon,
-	.set_rxon_chain = iwl_set_rxon_chain,
-	.set_tx_ant = iwl5000_send_tx_ant_config,
-};
-
-struct iwl_hcmd_utils_ops iwl5000_hcmd_utils = {
-	.get_hcmd_size = iwl5000_get_hcmd_size,
-	.build_addsta_hcmd = iwl5000_build_addsta_hcmd,
-	.gain_computation = iwl5000_gain_computation,
-	.chain_noise_reset = iwl5000_chain_noise_reset,
-	.rts_tx_cmd_flag = iwl5000_rts_tx_cmd_flag,
-	.calc_rssi = iwl5000_calc_rssi,
-};
-
 struct iwl_lib_ops iwl5000_lib = {
 	.set_hw_params = iwl5000_hw_set_hw_params,
 	.txq_update_byte_cnt_tbl = iwl5000_txq_update_byte_cnt_tbl,
@@ -1415,16 +1179,16 @@ static struct iwl_lib_ops iwl5150_lib = {
 static const struct iwl_ops iwl5000_ops = {
 	.ucode = &iwlagn_ucode,
 	.lib = &iwl5000_lib,
-	.hcmd = &iwl5000_hcmd,
-	.utils = &iwl5000_hcmd_utils,
+	.hcmd = &iwlagn_hcmd,
+	.utils = &iwlagn_hcmd_utils,
 	.led = &iwlagn_led_ops,
 };
 
 static const struct iwl_ops iwl5150_ops = {
 	.ucode = &iwlagn_ucode,
 	.lib = &iwl5150_lib,
-	.hcmd = &iwl5000_hcmd,
-	.utils = &iwl5000_hcmd_utils,
+	.hcmd = &iwlagn_hcmd,
+	.utils = &iwlagn_hcmd_utils,
 	.led = &iwlagn_led_ops,
 };
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index b729717..aff46b0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -286,8 +286,8 @@ static struct iwl_lib_ops iwl6000_lib = {
 static const struct iwl_ops iwl6000_ops = {
 	.ucode = &iwlagn_ucode,
 	.lib = &iwl6000_lib,
-	.hcmd = &iwl5000_hcmd,
-	.utils = &iwl5000_hcmd_utils,
+	.hcmd = &iwlagn_hcmd,
+	.utils = &iwlagn_hcmd_utils,
 	.led = &iwlagn_led_ops,
 };
 
@@ -354,8 +354,8 @@ static struct iwl_lib_ops iwl6050_lib = {
 static const struct iwl_ops iwl6050_ops = {
 	.ucode = &iwlagn_ucode,
 	.lib = &iwl6050_lib,
-	.hcmd = &iwl5000_hcmd,
-	.utils = &iwl5000_hcmd_utils,
+	.hcmd = &iwlagn_hcmd,
+	.utils = &iwlagn_hcmd_utils,
 	.led = &iwlagn_led_ops,
 };
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c b/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c
new file mode 100644
index 0000000..3ac010b
--- /dev/null
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c
@@ -0,0 +1,274 @@
+/******************************************************************************
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2008 - 2010 Intel Corporation. All rights reserved.
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
+ *  Intel Linux Wireless <ilw@linux.intel.com>
+ * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
+ *
+ *****************************************************************************/
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/sched.h>
+
+#include "iwl-dev.h"
+#include "iwl-core.h"
+#include "iwl-io.h"
+#include "iwl-5000-hw.h"
+
+static int iwlagn_send_rxon_assoc(struct iwl_priv *priv)
+{
+	int ret = 0;
+	struct iwl5000_rxon_assoc_cmd rxon_assoc;
+	const struct iwl_rxon_cmd *rxon1 = &priv->staging_rxon;
+	const struct iwl_rxon_cmd *rxon2 = &priv->active_rxon;
+
+	if ((rxon1->flags == rxon2->flags) &&
+	    (rxon1->filter_flags == rxon2->filter_flags) &&
+	    (rxon1->cck_basic_rates == rxon2->cck_basic_rates) &&
+	    (rxon1->ofdm_ht_single_stream_basic_rates ==
+	     rxon2->ofdm_ht_single_stream_basic_rates) &&
+	    (rxon1->ofdm_ht_dual_stream_basic_rates ==
+	     rxon2->ofdm_ht_dual_stream_basic_rates) &&
+	    (rxon1->ofdm_ht_triple_stream_basic_rates ==
+	     rxon2->ofdm_ht_triple_stream_basic_rates) &&
+	    (rxon1->acquisition_data == rxon2->acquisition_data) &&
+	    (rxon1->rx_chain == rxon2->rx_chain) &&
+	    (rxon1->ofdm_basic_rates == rxon2->ofdm_basic_rates)) {
+		IWL_DEBUG_INFO(priv, "Using current RXON_ASSOC.  Not resending.\n");
+		return 0;
+	}
+
+	rxon_assoc.flags = priv->staging_rxon.flags;
+	rxon_assoc.filter_flags = priv->staging_rxon.filter_flags;
+	rxon_assoc.ofdm_basic_rates = priv->staging_rxon.ofdm_basic_rates;
+	rxon_assoc.cck_basic_rates = priv->staging_rxon.cck_basic_rates;
+	rxon_assoc.reserved1 = 0;
+	rxon_assoc.reserved2 = 0;
+	rxon_assoc.reserved3 = 0;
+	rxon_assoc.ofdm_ht_single_stream_basic_rates =
+	    priv->staging_rxon.ofdm_ht_single_stream_basic_rates;
+	rxon_assoc.ofdm_ht_dual_stream_basic_rates =
+	    priv->staging_rxon.ofdm_ht_dual_stream_basic_rates;
+	rxon_assoc.rx_chain_select_flags = priv->staging_rxon.rx_chain;
+	rxon_assoc.ofdm_ht_triple_stream_basic_rates =
+		 priv->staging_rxon.ofdm_ht_triple_stream_basic_rates;
+	rxon_assoc.acquisition_data = priv->staging_rxon.acquisition_data;
+
+	ret = iwl_send_cmd_pdu_async(priv, REPLY_RXON_ASSOC,
+				     sizeof(rxon_assoc), &rxon_assoc, NULL);
+	if (ret)
+		return ret;
+
+	return ret;
+}
+
+static int iwlagn_send_tx_ant_config(struct iwl_priv *priv, u8 valid_tx_ant)
+{
+	struct iwl_tx_ant_config_cmd tx_ant_cmd = {
+	  .valid = cpu_to_le32(valid_tx_ant),
+	};
+
+	if (IWL_UCODE_API(priv->ucode_ver) > 1) {
+		IWL_DEBUG_HC(priv, "select valid tx ant: %u\n", valid_tx_ant);
+		return iwl_send_cmd_pdu(priv, TX_ANT_CONFIGURATION_CMD,
+					sizeof(struct iwl_tx_ant_config_cmd),
+					&tx_ant_cmd);
+	} else {
+		IWL_DEBUG_HC(priv, "TX_ANT_CONFIGURATION_CMD not supported\n");
+		return -EOPNOTSUPP;
+	}
+}
+
+/* Currently this is the superset of everything */
+static u16 iwlagn_get_hcmd_size(u8 cmd_id, u16 len)
+{
+	return len;
+}
+
+static u16 iwlagn_build_addsta_hcmd(const struct iwl_addsta_cmd *cmd, u8 *data)
+{
+	u16 size = (u16)sizeof(struct iwl_addsta_cmd);
+	struct iwl_addsta_cmd *addsta = (struct iwl_addsta_cmd *)data;
+	memcpy(addsta, cmd, size);
+	/* resrved in 5000 */
+	addsta->rate_n_flags = cpu_to_le16(0);
+	return size;
+}
+
+static void iwlagn_gain_computation(struct iwl_priv *priv,
+		u32 average_noise[NUM_RX_CHAINS],
+		u16 min_average_noise_antenna_i,
+		u32 min_average_noise,
+		u8 default_chain)
+{
+	int i;
+	s32 delta_g;
+	struct iwl_chain_noise_data *data = &priv->chain_noise_data;
+
+	/*
+	 * Find Gain Code for the chains based on "default chain"
+	 */
+	for (i = default_chain + 1; i < NUM_RX_CHAINS; i++) {
+		if ((data->disconn_array[i])) {
+			data->delta_gain_code[i] = 0;
+			continue;
+		}
+
+		delta_g = (priv->cfg->chain_noise_scale *
+			((s32)average_noise[default_chain] -
+			(s32)average_noise[i])) / 1500;
+
+		/* bound gain by 2 bits value max, 3rd bit is sign */
+		data->delta_gain_code[i] =
+			min(abs(delta_g), (long) CHAIN_NOISE_MAX_DELTA_GAIN_CODE);
+
+		if (delta_g < 0)
+			/*
+			 * set negative sign ...
+			 * note to Intel developers:  This is uCode API format,
+			 *   not the format of any internal device registers.
+			 *   Do not change this format for e.g. 6050 or similar
+			 *   devices.  Change format only if more resolution
+			 *   (i.e. more than 2 bits magnitude) is needed.
+			 */
+			data->delta_gain_code[i] |= (1 << 2);
+	}
+
+	IWL_DEBUG_CALIB(priv, "Delta gains: ANT_B = %d  ANT_C = %d\n",
+			data->delta_gain_code[1], data->delta_gain_code[2]);
+
+	if (!data->radio_write) {
+		struct iwl_calib_chain_noise_gain_cmd cmd;
+
+		memset(&cmd, 0, sizeof(cmd));
+
+		cmd.hdr.op_code = IWL_PHY_CALIBRATE_CHAIN_NOISE_GAIN_CMD;
+		cmd.hdr.first_group = 0;
+		cmd.hdr.groups_num = 1;
+		cmd.hdr.data_valid = 1;
+		cmd.delta_gain_1 = data->delta_gain_code[1];
+		cmd.delta_gain_2 = data->delta_gain_code[2];
+		iwl_send_cmd_pdu_async(priv, REPLY_PHY_CALIBRATION_CMD,
+			sizeof(cmd), &cmd, NULL);
+
+		data->radio_write = 1;
+		data->state = IWL_CHAIN_NOISE_CALIBRATED;
+	}
+
+	data->chain_noise_a = 0;
+	data->chain_noise_b = 0;
+	data->chain_noise_c = 0;
+	data->chain_signal_a = 0;
+	data->chain_signal_b = 0;
+	data->chain_signal_c = 0;
+	data->beacon_count = 0;
+}
+
+static void iwlagn_chain_noise_reset(struct iwl_priv *priv)
+{
+	struct iwl_chain_noise_data *data = &priv->chain_noise_data;
+	int ret;
+
+	if ((data->state == IWL_CHAIN_NOISE_ALIVE) && iwl_is_associated(priv)) {
+		struct iwl_calib_chain_noise_reset_cmd cmd;
+		memset(&cmd, 0, sizeof(cmd));
+
+		cmd.hdr.op_code = IWL_PHY_CALIBRATE_CHAIN_NOISE_RESET_CMD;
+		cmd.hdr.first_group = 0;
+		cmd.hdr.groups_num = 1;
+		cmd.hdr.data_valid = 1;
+		ret = iwl_send_cmd_pdu(priv, REPLY_PHY_CALIBRATION_CMD,
+					sizeof(cmd), &cmd);
+		if (ret)
+			IWL_ERR(priv,
+				"Could not send REPLY_PHY_CALIBRATION_CMD\n");
+		data->state = IWL_CHAIN_NOISE_ACCUMULATE;
+		IWL_DEBUG_CALIB(priv, "Run chain_noise_calibrate\n");
+	}
+}
+
+static void iwlagn_rts_tx_cmd_flag(struct ieee80211_tx_info *info,
+			__le32 *tx_flags)
+{
+	if ((info->control.rates[0].flags & IEEE80211_TX_RC_USE_RTS_CTS) ||
+	    (info->control.rates[0].flags & IEEE80211_TX_RC_USE_CTS_PROTECT))
+		*tx_flags |= TX_CMD_FLG_RTS_CTS_MSK;
+	else
+		*tx_flags &= ~TX_CMD_FLG_RTS_CTS_MSK;
+}
+
+/* Calc max signal level (dBm) among 3 possible receivers */
+static int iwlagn_calc_rssi(struct iwl_priv *priv,
+			     struct iwl_rx_phy_res *rx_resp)
+{
+	/* data from PHY/DSP regarding signal strength, etc.,
+	 *   contents are always there, not configurable by host
+	 */
+	struct iwl5000_non_cfg_phy *ncphy =
+		(struct iwl5000_non_cfg_phy *)rx_resp->non_cfg_phy_buf;
+	u32 val, rssi_a, rssi_b, rssi_c, max_rssi;
+	u8 agc;
+
+	val  = le32_to_cpu(ncphy->non_cfg_phy[IWL50_RX_RES_AGC_IDX]);
+	agc = (val & IWL50_OFDM_AGC_MSK) >> IWL50_OFDM_AGC_BIT_POS;
+
+	/* Find max rssi among 3 possible receivers.
+	 * These values are measured by the digital signal processor (DSP).
+	 * They should stay fairly constant even as the signal strength varies,
+	 *   if the radio's automatic gain control (AGC) is working right.
+	 * AGC value (see below) will provide the "interesting" info.
+	 */
+	val = le32_to_cpu(ncphy->non_cfg_phy[IWL50_RX_RES_RSSI_AB_IDX]);
+	rssi_a = (val & IWL50_OFDM_RSSI_A_MSK) >> IWL50_OFDM_RSSI_A_BIT_POS;
+	rssi_b = (val & IWL50_OFDM_RSSI_B_MSK) >> IWL50_OFDM_RSSI_B_BIT_POS;
+	val = le32_to_cpu(ncphy->non_cfg_phy[IWL50_RX_RES_RSSI_C_IDX]);
+	rssi_c = (val & IWL50_OFDM_RSSI_C_MSK) >> IWL50_OFDM_RSSI_C_BIT_POS;
+
+	max_rssi = max_t(u32, rssi_a, rssi_b);
+	max_rssi = max_t(u32, max_rssi, rssi_c);
+
+	IWL_DEBUG_STATS(priv, "Rssi In A %d B %d C %d Max %d AGC dB %d\n",
+		rssi_a, rssi_b, rssi_c, max_rssi, agc);
+
+	/* dBm = max_rssi dB - agc dB - constant.
+	 * Higher AGC (higher radio gain) means lower signal. */
+	return max_rssi - agc - IWL49_RSSI_OFFSET;
+}
+
+struct iwl_hcmd_ops iwlagn_hcmd = {
+	.rxon_assoc = iwlagn_send_rxon_assoc,
+	.commit_rxon = iwl_commit_rxon,
+	.set_rxon_chain = iwl_set_rxon_chain,
+	.set_tx_ant = iwlagn_send_tx_ant_config,
+};
+
+struct iwl_hcmd_utils_ops iwlagn_hcmd_utils = {
+	.get_hcmd_size = iwlagn_get_hcmd_size,
+	.build_addsta_hcmd = iwlagn_build_addsta_hcmd,
+	.gain_computation = iwlagn_gain_computation,
+	.chain_noise_reset = iwlagn_chain_noise_reset,
+	.rts_tx_cmd_flag = iwlagn_rts_tx_cmd_flag,
+	.calc_rssi = iwlagn_calc_rssi,
+};
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index 5af528d..51e49df 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -66,6 +66,8 @@
 #include "iwl-dev.h"
 
 extern struct iwl_ucode_ops iwlagn_ucode;
+extern struct iwl_hcmd_ops iwlagn_hcmd;
+extern struct iwl_hcmd_utils_ops iwlagn_hcmd_utils;
 
 int iwl_reset_ict(struct iwl_priv *priv);
 void iwl_disable_ict(struct iwl_priv *priv);
-- 
1.6.3.3

