Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:51299 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754541AbYDXSzp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Apr 2008 14:55:45 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 13/21] iwlwifi-5000: add run time calibrations for 5000
Date: Thu, 24 Apr 2008 11:55:30 -0700
Message-Id: <1209063338-6572-14-git-send-email-reinette.chatre@intel.com> (sfid-20080424_210548_868743_8091972C)
In-Reply-To: <1209063338-6572-13-git-send-email-reinette.chatre@intel.com>
References: <1209063338-6572-1-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-2-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-3-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-4-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-5-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-6-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-7-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-8-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-9-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-10-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-11-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-12-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-13-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This patch adds support for run time calibrations for the 5000 family HW.
Those calibrations are sensitivity calibration, and chain noise calibration.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/Kconfig             |    9 ++
 drivers/net/wireless/iwlwifi/iwl-4965-commands.h |   31 +++++++
 drivers/net/wireless/iwlwifi/iwl-5000.c          |  101 ++++++++++++++++++++++
 3 files changed, 141 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/Kconfig b/drivers/net/wireless/iwlwifi/Kconfig
index 4b829d3..7b9cfea 100644
--- a/drivers/net/wireless/iwlwifi/Kconfig
+++ b/drivers/net/wireless/iwlwifi/Kconfig
@@ -112,6 +112,15 @@ config IWL5000
 	  This option enables support for Intel Wireless WiFi Link 5000AGN Family
 	  Dependency on 4965 is temporary
 
+config IWL5000_RUN_TIME_CALIB
+	bool "Enable run time Calibration for 5000 NIC"
+	select IWLWIFI_RUN_TIME_CALIB
+	depends on IWL5000
+	default y
+	---help---
+	  This option will enable run time calibration for the iwl5000 driver.
+	  These calibrations are Sensitivity and Chain Noise. If unsure, say yes
+
 
 config IWLWIFI_DEBUGFS
         bool "Iwlwifi debugfs support"
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-commands.h b/drivers/net/wireless/iwlwifi/iwl-4965-commands.h
index d0e3f35..a5c33f3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-commands.h
@@ -2671,6 +2671,37 @@ struct iwl4965_calibration_cmd {
 	u8 reserved1;
 } __attribute__ ((packed));
 
+/* Phy calibration command for 5000 series */
+
+enum {
+	IWL5000_PHY_CALIBRATE_DC_CMD		= 8,
+	IWL5000_PHY_CALIBRATE_LO_CMD		= 9,
+	IWL5000_PHY_CALIBRATE_RX_BB_CMD		= 10,
+	IWL5000_PHY_CALIBRATE_TX_IQ_CMD		= 11,
+	IWL5000_PHY_CALIBRATE_RX_IQ_CMD		= 12,
+	IWL5000_PHY_CALIBRATION_NOISE_CMD	= 13,
+	IWL5000_PHY_CALIBRATE_AGC_TABLE_CMD	= 14,
+	IWL5000_PHY_CALIBRATE_CRYSTAL_FRQ_CMD	= 15,
+	IWL5000_PHY_CALIBRATE_BASE_BAND_CMD	= 16,
+	IWL5000_PHY_CALIBRATE_CHAIN_NOISE_RESET_CMD = 18,
+	IWL5000_PHY_CALIBRATE_CHAIN_NOISE_GAIN_CMD = 19,
+};
+
+struct iwl5000_calibration_chain_noise_reset_cmd {
+	u8 op_code;	/* IWL5000_PHY_CALIBRATE_CHAIN_NOISE_RESET_CMD */
+	u8 flags;	/* not used */
+	__le16 reserved;
+} __attribute__ ((packed));
+
+struct iwl5000_calibration_chain_noise_gain_cmd {
+	u8 op_code;	/* IWL5000_PHY_CALIBRATE_CHAIN_NOISE_GAIN_CMD */
+	u8 flags;	/* not used */
+	__le16 reserved;
+	u8 delta_gain_1;
+	u8 delta_gain_2;
+	__le16 reserved1;
+} __attribute__ ((packed));
+
 /******************************************************************************
  * (12)
  * Miscellaneous Commands:
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 7c42bbf..1a18ac1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -125,6 +125,100 @@ static u32 eeprom_indirect_address(const struct iwl_priv *priv, u32 address)
 	return (address & ADDRESS_MSK) + (offset << 1);
 }
 
+#ifdef CONFIG_IWL5000_RUN_TIME_CALIB
+
+static void iwl5000_gain_computation(struct iwl_priv *priv,
+		u32 average_noise[NUM_RX_CHAINS],
+		u16 min_average_noise_antenna_i,
+		u32 min_average_noise)
+{
+	int i;
+	s32 delta_g;
+	struct iwl_chain_noise_data *data = &priv->chain_noise_data;
+
+	/* Find Gain Code for the antennas B and C */
+	for (i = 1; i < NUM_RX_CHAINS; i++) {
+		if ((data->disconn_array[i])) {
+			data->delta_gain_code[i] = 0;
+			continue;
+		}
+		delta_g = (1000 * ((s32)average_noise[0] -
+			(s32)average_noise[i])) / 1500;
+		/* bound gain by 2 bits value max, 3rd bit is sign */
+		data->delta_gain_code[i] =
+			min(abs(delta_g), CHAIN_NOISE_MAX_DELTA_GAIN_CODE);
+
+		if (delta_g < 0)
+			/* set negative sign */
+			data->delta_gain_code[i] |= (1 << 2);
+	}
+
+	IWL_DEBUG_CALIB("Delta gains: ANT_B = %d  ANT_C = %d\n",
+			data->delta_gain_code[1], data->delta_gain_code[2]);
+
+	if (!data->radio_write) {
+		struct iwl5000_calibration_chain_noise_gain_cmd cmd;
+		memset(&cmd, 0, sizeof(cmd));
+
+		cmd.op_code = IWL5000_PHY_CALIBRATE_CHAIN_NOISE_GAIN_CMD;
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
+static void iwl5000_chain_noise_reset(struct iwl_priv *priv)
+{
+	struct iwl_chain_noise_data *data = &priv->chain_noise_data;
+
+	if ((data->state == IWL_CHAIN_NOISE_ALIVE) && iwl_is_associated(priv)) {
+		struct iwl5000_calibration_chain_noise_reset_cmd cmd;
+
+		memset(&cmd, 0, sizeof(cmd));
+		cmd.op_code = IWL5000_PHY_CALIBRATE_CHAIN_NOISE_RESET_CMD;
+		if (iwl_send_cmd_pdu(priv, REPLY_PHY_CALIBRATION_CMD,
+			sizeof(cmd), &cmd))
+			IWL_ERROR("Could not send REPLY_PHY_CALIBRATION_CMD\n");
+		data->state = IWL_CHAIN_NOISE_ACCUMULATE;
+		IWL_DEBUG_CALIB("Run chain_noise_calibrate\n");
+	}
+}
+
+static struct iwl_sensitivity_ranges iwl5000_sensitivity = {
+	.min_nrg_cck = 95,
+	.max_nrg_cck = 0,
+	.auto_corr_min_ofdm = 90,
+	.auto_corr_min_ofdm_mrc = 170,
+	.auto_corr_min_ofdm_x1 = 120,
+	.auto_corr_min_ofdm_mrc_x1 = 240,
+
+	.auto_corr_max_ofdm = 120,
+	.auto_corr_max_ofdm_mrc = 210,
+	.auto_corr_max_ofdm_x1 = 155,
+	.auto_corr_max_ofdm_mrc_x1 = 290,
+
+	.auto_corr_min_cck = 125,
+	.auto_corr_max_cck = 200,
+	.auto_corr_min_cck_mrc = 170,
+	.auto_corr_max_cck_mrc = 400,
+	.nrg_th_cck = 95,
+	.nrg_th_ofdm = 95,
+};
+
+#endif /* CONFIG_IWL5000_RUN_TIME_CALIB */
+
 static const u8 *iwl5000_eeprom_query_addr(const struct iwl_priv *priv,
 					   size_t offset)
 {
@@ -159,6 +253,9 @@ static int iwl5000_hw_set_hw_params(struct iwl_priv *priv)
 	priv->hw_params.max_bsm_size = BSM_SRAM_SIZE;
 	priv->hw_params.fat_channel =  BIT(IEEE80211_BAND_2GHZ) |
 					BIT(IEEE80211_BAND_5GHZ);
+#ifdef CONFIG_IWL5000_RUN_TIME_CALIB
+	priv->hw_params.sens = &iwl5000_sensitivity;
+#endif
 
 	switch (priv->hw_rev & CSR_HW_REV_TYPE_MSK) {
 	case CSR_HW_REV_TYPE_5100:
@@ -202,6 +299,10 @@ static struct iwl_hcmd_ops iwl5000_hcmd = {
 };
 
 static struct iwl_hcmd_utils_ops iwl5000_hcmd_utils = {
+#ifdef CONFIG_IWL5000_RUN_TIME_CALIB
+	.gain_computation = iwl5000_gain_computation,
+	.chain_noise_reset = iwl5000_chain_noise_reset,
+#endif
 };
 
 static struct iwl_lib_ops iwl5000_lib = {
-- 
1.5.3.4

