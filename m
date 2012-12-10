Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42216 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633Ab2LJVs7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2012 16:48:59 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Eytan Lifshitz <eytan.lifshitz@intel.com>
Subject: [PATCH 04/10] iwlwifi: Change define and struct names in iwl-eeprom-parse.h
Date: Mon, 10 Dec 2012 22:49:12 +0100
Message-Id: <1355176158-24675-4-git-send-email-johannes@sipsolutions.net> (sfid-20121210_224909_971074_7F0B8110)
In-Reply-To: <1355176158-24675-1-git-send-email-johannes@sipsolutions.net>
References: <1355176087.8083.17.camel@jlt4.sipsolutions.net>
 <1355176158-24675-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eytan Lifshitz <eytan.lifshitz@intel.com>

Since we will have several forms of NVM (EEPROM, OTP, etc.)
and they will have different layouts, make the parsed data
more generic. This allows functional code to be independent
of a specific layout.

Also change some variables and function names from having
"eeprom" to "nvm" in their name.

Signed-off-by: Eytan Lifshitz <eytan.lifshitz@intel.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/calib.c        | 14 ++---
 drivers/net/wireless/iwlwifi/dvm/debugfs.c      | 12 ++--
 drivers/net/wireless/iwlwifi/dvm/dev.h          |  2 +-
 drivers/net/wireless/iwlwifi/dvm/devices.c      |  8 +--
 drivers/net/wireless/iwlwifi/dvm/lib.c          |  8 +--
 drivers/net/wireless/iwlwifi/dvm/mac80211.c     | 12 ++--
 drivers/net/wireless/iwlwifi/dvm/main.c         | 57 +++++++++--------
 drivers/net/wireless/iwlwifi/dvm/rs.c           | 44 ++++++-------
 drivers/net/wireless/iwlwifi/dvm/rxon.c         |  4 +-
 drivers/net/wireless/iwlwifi/dvm/scan.c         |  8 +--
 drivers/net/wireless/iwlwifi/dvm/sta.c          | 12 ++--
 drivers/net/wireless/iwlwifi/dvm/tx.c           |  6 +-
 drivers/net/wireless/iwlwifi/dvm/ucode.c        | 12 ++--
 drivers/net/wireless/iwlwifi/iwl-config.h       |  8 +--
 drivers/net/wireless/iwlwifi/iwl-eeprom-parse.c | 84 ++++++++++++++++---------
 drivers/net/wireless/iwlwifi/iwl-eeprom-parse.h | 45 ++++++-------
 drivers/net/wireless/iwlwifi/pcie/1000.c        |  8 +--
 drivers/net/wireless/iwlwifi/pcie/2000.c        | 16 ++---
 drivers/net/wireless/iwlwifi/pcie/5000.c        | 12 ++--
 drivers/net/wireless/iwlwifi/pcie/6000.c        | 28 ++++-----
 20 files changed, 214 insertions(+), 186 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/calib.c b/drivers/net/wireless/iwlwifi/dvm/calib.c
index f2dd671..de54713 100644
--- a/drivers/net/wireless/iwlwifi/dvm/calib.c
+++ b/drivers/net/wireless/iwlwifi/dvm/calib.c
@@ -833,14 +833,14 @@ static void iwl_find_disconn_antenna(struct iwl_priv *priv, u32* average_sig,
 	 * To be safe, simply mask out any chains that we know
 	 * are not on the device.
 	 */
-	active_chains &= priv->eeprom_data->valid_rx_ant;
+	active_chains &= priv->nvm_data->valid_rx_ant;
 
 	num_tx_chains = 0;
 	for (i = 0; i < NUM_RX_CHAINS; i++) {
 		/* loops on all the bits of
 		 * priv->hw_setting.valid_tx_ant */
 		u8 ant_msk = (1 << i);
-		if (!(priv->eeprom_data->valid_tx_ant & ant_msk))
+		if (!(priv->nvm_data->valid_tx_ant & ant_msk))
 			continue;
 
 		num_tx_chains++;
@@ -854,7 +854,7 @@ static void iwl_find_disconn_antenna(struct iwl_priv *priv, u32* average_sig,
 			 * connect the first valid tx chain
 			 */
 			first_chain =
-				find_first_chain(priv->eeprom_data->valid_tx_ant);
+				find_first_chain(priv->nvm_data->valid_tx_ant);
 			data->disconn_array[first_chain] = 0;
 			active_chains |= BIT(first_chain);
 			IWL_DEBUG_CALIB(priv,
@@ -864,13 +864,13 @@ static void iwl_find_disconn_antenna(struct iwl_priv *priv, u32* average_sig,
 		}
 	}
 
-	if (active_chains != priv->eeprom_data->valid_rx_ant &&
+	if (active_chains != priv->nvm_data->valid_rx_ant &&
 	    active_chains != priv->chain_noise_data.active_chains)
 		IWL_DEBUG_CALIB(priv,
 				"Detected that not all antennas are connected! "
 				"Connected: %#x, valid: %#x.\n",
 				active_chains,
-				priv->eeprom_data->valid_rx_ant);
+				priv->nvm_data->valid_rx_ant);
 
 	/* Save for use within RXON, TX, SCAN commands, etc. */
 	data->active_chains = active_chains;
@@ -1055,7 +1055,7 @@ void iwl_chain_noise_calibration(struct iwl_priv *priv)
 	    priv->cfg->bt_params->advanced_bt_coexist) {
 		/* Disable disconnected antenna algorithm for advanced
 		   bt coex, assuming valid antennas are connected */
-		data->active_chains = priv->eeprom_data->valid_rx_ant;
+		data->active_chains = priv->nvm_data->valid_rx_ant;
 		for (i = 0; i < NUM_RX_CHAINS; i++)
 			if (!(data->active_chains & (1<<i)))
 				data->disconn_array[i] = 1;
@@ -1086,7 +1086,7 @@ void iwl_chain_noise_calibration(struct iwl_priv *priv)
 
 	iwlagn_gain_computation(
 		priv, average_noise,
-		find_first_chain(priv->eeprom_data->valid_rx_ant));
+		find_first_chain(priv->nvm_data->valid_rx_ant));
 
 	/* Some power changes may have been made during the calibration.
 	 * Update and commit the RXON
diff --git a/drivers/net/wireless/iwlwifi/dvm/debugfs.c b/drivers/net/wireless/iwlwifi/dvm/debugfs.c
index 769a08b..5b9533e 100644
--- a/drivers/net/wireless/iwlwifi/dvm/debugfs.c
+++ b/drivers/net/wireless/iwlwifi/dvm/debugfs.c
@@ -305,7 +305,7 @@ static ssize_t iwl_dbgfs_nvm_read(struct file *file,
 	int pos = 0, ofs = 0, buf_size = 0;
 	const u8 *ptr;
 	char *buf;
-	u16 eeprom_ver;
+	u16 nvm_ver;
 	size_t eeprom_len = priv->eeprom_blob_size;
 	buf_size = 4 * eeprom_len + 256;
 
@@ -321,9 +321,9 @@ static ssize_t iwl_dbgfs_nvm_read(struct file *file,
 	if (!buf)
 		return -ENOMEM;
 
-	eeprom_ver = priv->eeprom_data->eeprom_version;
+	nvm_ver = priv->nvm_data->nvm_version;
 	pos += scnprintf(buf + pos, buf_size - pos,
-			 "NVM version: 0x%x\n", eeprom_ver);
+			 "NVM version: 0x%x\n", nvm_ver);
 	for (ofs = 0 ; ofs < eeprom_len ; ofs += 16) {
 		pos += scnprintf(buf + pos, buf_size - pos, "0x%.4x ", ofs);
 		hex_dump_to_buffer(ptr + ofs, 16 , 16, 2, buf + pos,
@@ -1333,17 +1333,17 @@ static ssize_t iwl_dbgfs_ucode_tx_stats_read(struct file *file,
 	if (tx->tx_power.ant_a || tx->tx_power.ant_b || tx->tx_power.ant_c) {
 		pos += scnprintf(buf + pos, bufsz - pos,
 			"tx power: (1/2 dB step)\n");
-		if ((priv->eeprom_data->valid_tx_ant & ANT_A) &&
+		if ((priv->nvm_data->valid_tx_ant & ANT_A) &&
 		    tx->tx_power.ant_a)
 			pos += scnprintf(buf + pos, bufsz - pos,
 					fmt_hex, "antenna A:",
 					tx->tx_power.ant_a);
-		if ((priv->eeprom_data->valid_tx_ant & ANT_B) &&
+		if ((priv->nvm_data->valid_tx_ant & ANT_B) &&
 		    tx->tx_power.ant_b)
 			pos += scnprintf(buf + pos, bufsz - pos,
 					fmt_hex, "antenna B:",
 					tx->tx_power.ant_b);
-		if ((priv->eeprom_data->valid_tx_ant & ANT_C) &&
+		if ((priv->nvm_data->valid_tx_ant & ANT_C) &&
 		    tx->tx_power.ant_c)
 			pos += scnprintf(buf + pos, bufsz - pos,
 					fmt_hex, "antenna C:",
diff --git a/drivers/net/wireless/iwlwifi/dvm/dev.h b/drivers/net/wireless/iwlwifi/dvm/dev.h
index 8141f91..fce0f43 100644
--- a/drivers/net/wireless/iwlwifi/dvm/dev.h
+++ b/drivers/net/wireless/iwlwifi/dvm/dev.h
@@ -844,7 +844,7 @@ struct iwl_priv {
 	void *wowlan_sram;
 #endif /* CONFIG_IWLWIFI_DEBUGFS */
 
-	struct iwl_eeprom_data *eeprom_data;
+	struct iwl_nvm_data *nvm_data;
 	/* eeprom blob for debugfs/testmode */
 	u8 *eeprom_blob;
 	size_t eeprom_blob_size;
diff --git a/drivers/net/wireless/iwlwifi/dvm/devices.c b/drivers/net/wireless/iwlwifi/dvm/devices.c
index 349c205d5..f837912 100644
--- a/drivers/net/wireless/iwlwifi/dvm/devices.c
+++ b/drivers/net/wireless/iwlwifi/dvm/devices.c
@@ -305,8 +305,8 @@ static s32 iwl_temp_calib_to_offset(struct iwl_priv *priv)
 {
 	u16 temperature, voltage;
 
-	temperature = le16_to_cpu(priv->eeprom_data->kelvin_temperature);
-	voltage = le16_to_cpu(priv->eeprom_data->kelvin_voltage);
+	temperature = le16_to_cpu(priv->nvm_data->kelvin_temperature);
+	voltage = le16_to_cpu(priv->nvm_data->kelvin_voltage);
 
 	/* offset = temp - volt / coeff */
 	return (s32)(temperature -
@@ -460,13 +460,13 @@ static void iwl6000_nic_config(struct iwl_priv *priv)
 		break;
 	case IWL_DEVICE_FAMILY_6050:
 		/* Indicate calibration version to uCode. */
-		if (priv->eeprom_data->calib_version >= 6)
+		if (priv->nvm_data->calib_version >= 6)
 			iwl_set_bit(priv->trans, CSR_GP_DRIVER_REG,
 					CSR_GP_DRIVER_REG_BIT_CALIB_VERSION6);
 		break;
 	case IWL_DEVICE_FAMILY_6150:
 		/* Indicate calibration version to uCode. */
-		if (priv->eeprom_data->calib_version >= 6)
+		if (priv->nvm_data->calib_version >= 6)
 			iwl_set_bit(priv->trans, CSR_GP_DRIVER_REG,
 					CSR_GP_DRIVER_REG_BIT_CALIB_VERSION6);
 		iwl_set_bit(priv->trans, CSR_GP_DRIVER_REG,
diff --git a/drivers/net/wireless/iwlwifi/dvm/lib.c b/drivers/net/wireless/iwlwifi/dvm/lib.c
index 7e59be4..6ff4660 100644
--- a/drivers/net/wireless/iwlwifi/dvm/lib.c
+++ b/drivers/net/wireless/iwlwifi/dvm/lib.c
@@ -59,7 +59,7 @@ int iwlagn_send_tx_power(struct iwl_priv *priv)
 	/* half dBm need to multiply */
 	tx_power_cmd.global_lmt = (s8)(2 * priv->tx_power_user_lmt);
 
-	if (tx_power_cmd.global_lmt > priv->eeprom_data->max_tx_pwr_half_dbm) {
+	if (tx_power_cmd.global_lmt > priv->nvm_data->max_tx_pwr_half_dbm) {
 		/*
 		 * For the newer devices which using enhanced/extend tx power
 		 * table in EEPROM, the format is in half dBm. driver need to
@@ -72,7 +72,7 @@ int iwlagn_send_tx_power(struct iwl_priv *priv)
 		 * half-dBm format), lower the tx power based on EEPROM
 		 */
 		tx_power_cmd.global_lmt =
-			priv->eeprom_data->max_tx_pwr_half_dbm;
+			priv->nvm_data->max_tx_pwr_half_dbm;
 	}
 	tx_power_cmd.flags = IWLAGN_TX_POWER_NO_CLOSED;
 	tx_power_cmd.srv_chan_lmt = IWLAGN_TX_POWER_AUTO;
@@ -159,7 +159,7 @@ int iwlagn_txfifo_flush(struct iwl_priv *priv)
 					   IWL_PAN_SCD_MGMT_MSK |
 					   IWL_PAN_SCD_MULTICAST_MSK;
 
-	if (priv->eeprom_data->sku & EEPROM_SKU_CAP_11N_ENABLE)
+	if (priv->nvm_data->sku_cap_11n_enable)
 		flush_cmd.queue_control |= IWL_AGG_TX_QUEUE_MSK;
 
 	IWL_DEBUG_INFO(priv, "queue control: 0x%x\n",
@@ -825,7 +825,7 @@ void iwlagn_set_rxon_chain(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 	if (priv->chain_noise_data.active_chains)
 		active_chains = priv->chain_noise_data.active_chains;
 	else
-		active_chains = priv->eeprom_data->valid_rx_ant;
+		active_chains = priv->nvm_data->valid_rx_ant;
 
 	if (priv->cfg->bt_params &&
 	    priv->cfg->bt_params->advanced_bt_coexist &&
diff --git a/drivers/net/wireless/iwlwifi/dvm/mac80211.c b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
index a275eb9..5b0877a 100644
--- a/drivers/net/wireless/iwlwifi/dvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
@@ -164,7 +164,7 @@ int iwlagn_mac_setup_register(struct iwl_priv *priv,
 	hw->max_tx_aggregation_subframes = LINK_QUAL_AGG_FRAME_LIMIT_DEF;
 	 */
 
-	if (priv->eeprom_data->sku & EEPROM_SKU_CAP_11N_ENABLE)
+	if (priv->nvm_data->sku_cap_11n_enable)
 		hw->flags |= IEEE80211_HW_SUPPORTS_DYNAMIC_SMPS |
 			     IEEE80211_HW_SUPPORTS_STATIC_SMPS;
 
@@ -242,12 +242,12 @@ int iwlagn_mac_setup_register(struct iwl_priv *priv,
 
 	hw->max_listen_interval = IWL_CONN_MAX_LISTEN_INTERVAL;
 
-	if (priv->eeprom_data->bands[IEEE80211_BAND_2GHZ].n_channels)
+	if (priv->nvm_data->bands[IEEE80211_BAND_2GHZ].n_channels)
 		priv->hw->wiphy->bands[IEEE80211_BAND_2GHZ] =
-			&priv->eeprom_data->bands[IEEE80211_BAND_2GHZ];
-	if (priv->eeprom_data->bands[IEEE80211_BAND_5GHZ].n_channels)
+			&priv->nvm_data->bands[IEEE80211_BAND_2GHZ];
+	if (priv->nvm_data->bands[IEEE80211_BAND_5GHZ].n_channels)
 		priv->hw->wiphy->bands[IEEE80211_BAND_5GHZ] =
-			&priv->eeprom_data->bands[IEEE80211_BAND_5GHZ];
+			&priv->nvm_data->bands[IEEE80211_BAND_5GHZ];
 
 	hw->wiphy->hw_version = priv->trans->hw_id;
 
@@ -654,7 +654,7 @@ static int iwlagn_mac_ampdu_action(struct ieee80211_hw *hw,
 	IWL_DEBUG_HT(priv, "A-MPDU action on addr %pM tid %d\n",
 		     sta->addr, tid);
 
-	if (!(priv->eeprom_data->sku & EEPROM_SKU_CAP_11N_ENABLE))
+	if (!(priv->nvm_data->sku_cap_11n_enable))
 		return -EACCES;
 
 	IWL_DEBUG_MAC80211(priv, "enter\n");
diff --git a/drivers/net/wireless/iwlwifi/dvm/main.c b/drivers/net/wireless/iwlwifi/dvm/main.c
index ac2681c..8f11198 100644
--- a/drivers/net/wireless/iwlwifi/dvm/main.c
+++ b/drivers/net/wireless/iwlwifi/dvm/main.c
@@ -185,7 +185,7 @@ int iwlagn_send_beacon_cmd(struct iwl_priv *priv)
 		rate = info->control.rates[0].idx;
 
 	priv->mgmt_tx_ant = iwl_toggle_tx_ant(priv, priv->mgmt_tx_ant,
-					      priv->eeprom_data->valid_tx_ant);
+					      priv->nvm_data->valid_tx_ant);
 	rate_flags = iwl_ant_idx_to_flags(priv->mgmt_tx_ant);
 
 	/* In mac80211, rates for 5 GHz start at 0 */
@@ -776,7 +776,7 @@ int iwl_alive_start(struct iwl_priv *priv)
 	ieee80211_wake_queues(priv->hw);
 
 	/* Configure Tx antenna selection based on H/W config */
-	iwlagn_send_tx_ant_config(priv, priv->eeprom_data->valid_tx_ant);
+	iwlagn_send_tx_ant_config(priv, priv->nvm_data->valid_tx_ant);
 
 	if (iwl_is_associated_ctx(ctx) && !priv->wowlan) {
 		struct iwl_rxon_cmd *active_rxon =
@@ -1191,30 +1191,38 @@ static void iwl_option_config(struct iwl_priv *priv)
 
 static int iwl_eeprom_init_hw_params(struct iwl_priv *priv)
 {
-	if (priv->eeprom_data->sku & EEPROM_SKU_CAP_11N_ENABLE &&
+	struct iwl_nvm_data *data = priv->nvm_data;
+	char *debug_msg;
+
+	if (data->sku_cap_11n_enable &&
 	    !priv->cfg->ht_params) {
 		IWL_ERR(priv, "Invalid 11n configuration\n");
 		return -EINVAL;
 	}
 
-	if (!priv->eeprom_data->sku) {
+	if (!data->sku_cap_11n_enable && !data->sku_cap_band_24GHz_enable &&
+	    !data->sku_cap_band_52GHz_enable) {
 		IWL_ERR(priv, "Invalid device sku\n");
 		return -EINVAL;
 	}
 
-	IWL_DEBUG_INFO(priv, "Device SKU: 0x%X\n", priv->eeprom_data->sku);
+	debug_msg = "Device SKU: 24GHz %s %s, 52GHz %s %s, 11.n %s %s\n";
+	IWL_DEBUG_INFO(priv, debug_msg,
+		       data->sku_cap_band_24GHz_enable ? "" : "NOT", "enabled",
+		       data->sku_cap_band_52GHz_enable ? "" : "NOT", "enabled",
+		       data->sku_cap_11n_enable ? "" : "NOT", "enabled");
 
 	priv->hw_params.tx_chains_num =
-		num_of_ant(priv->eeprom_data->valid_tx_ant);
+		num_of_ant(data->valid_tx_ant);
 	if (priv->cfg->rx_with_siso_diversity)
 		priv->hw_params.rx_chains_num = 1;
 	else
 		priv->hw_params.rx_chains_num =
-			num_of_ant(priv->eeprom_data->valid_rx_ant);
+			num_of_ant(data->valid_rx_ant);
 
 	IWL_DEBUG_INFO(priv, "Valid Tx ant: 0x%X, Valid Rx ant: 0x%X\n",
-		       priv->eeprom_data->valid_tx_ant,
-		       priv->eeprom_data->valid_rx_ant);
+		       data->valid_tx_ant,
+		       data->valid_rx_ant);
 
 	return 0;
 }
@@ -1374,24 +1382,24 @@ static struct iwl_op_mode *iwl_op_mode_dvm_start(struct iwl_trans *trans,
 	/* Reset chip to save power until we load uCode during "up". */
 	iwl_trans_stop_hw(priv->trans, false);
 
-	priv->eeprom_data = iwl_parse_eeprom_data(priv->trans->dev, priv->cfg,
+	priv->nvm_data = iwl_parse_eeprom_data(priv->trans->dev, priv->cfg,
 						  priv->eeprom_blob,
 						  priv->eeprom_blob_size);
-	if (!priv->eeprom_data)
+	if (!priv->nvm_data)
 		goto out_free_eeprom_blob;
 
-	if (iwl_eeprom_check_version(priv->eeprom_data, priv->trans))
+	if (iwl_nvm_check_version(priv->nvm_data, priv->trans))
 		goto out_free_eeprom;
 
 	if (iwl_eeprom_init_hw_params(priv))
 		goto out_free_eeprom;
 
 	/* extract MAC Address */
-	memcpy(priv->addresses[0].addr, priv->eeprom_data->hw_addr, ETH_ALEN);
+	memcpy(priv->addresses[0].addr, priv->nvm_data->hw_addr, ETH_ALEN);
 	IWL_DEBUG_INFO(priv, "MAC address: %pM\n", priv->addresses[0].addr);
 	priv->hw->wiphy->addresses = priv->addresses;
 	priv->hw->wiphy->n_addresses = 1;
-	num_mac = priv->eeprom_data->n_hw_addrs;
+	num_mac = priv->nvm_data->n_hw_addrs;
 	if (num_mac > 1) {
 		memcpy(priv->addresses[1].addr, priv->addresses[0].addr,
 		       ETH_ALEN);
@@ -1404,7 +1412,7 @@ static struct iwl_op_mode *iwl_op_mode_dvm_start(struct iwl_trans *trans,
 	 ************************/
 	iwl_set_hw_params(priv);
 
-	if (!(priv->eeprom_data->sku & EEPROM_SKU_CAP_IPAN_ENABLE)) {
+	if (!(priv->nvm_data->sku_cap_ipan_enable)) {
 		IWL_DEBUG_INFO(priv, "Your EEPROM disabled PAN");
 		ucode_flags &= ~IWL_UCODE_TLV_FLAGS_PAN;
 		/*
@@ -1486,7 +1494,7 @@ out_destroy_workqueue:
 out_free_eeprom_blob:
 	kfree(priv->eeprom_blob);
 out_free_eeprom:
-	iwl_free_eeprom_data(priv->eeprom_data);
+	iwl_free_nvm_data(priv->nvm_data);
 out_free_hw:
 	ieee80211_free_hw(priv->hw);
 out:
@@ -1506,7 +1514,7 @@ static void iwl_op_mode_dvm_stop(struct iwl_op_mode *op_mode)
 	iwl_tt_exit(priv);
 
 	kfree(priv->eeprom_blob);
-	iwl_free_eeprom_data(priv->eeprom_data);
+	iwl_free_nvm_data(priv->nvm_data);
 
 	/*netif_stop_queue(dev); */
 	flush_workqueue(priv->workqueue);
@@ -1980,7 +1988,6 @@ static void iwl_cmd_queue_full(struct iwl_op_mode *op_mode)
 static void iwl_nic_config(struct iwl_op_mode *op_mode)
 {
 	struct iwl_priv *priv = IWL_OP_MODE_GET_DVM(op_mode);
-	u16 radio_cfg = priv->eeprom_data->radio_cfg;
 
 	/* SKU Control */
 	iwl_set_bits_mask(priv->trans, CSR_HW_IF_CONFIG_REG,
@@ -1992,13 +1999,13 @@ static void iwl_nic_config(struct iwl_op_mode *op_mode)
 				CSR_HW_IF_CONFIG_REG_POS_MAC_DASH));
 
 	/* write radio config values to register */
-	if (EEPROM_RF_CFG_TYPE_MSK(radio_cfg) <= EEPROM_RF_CONFIG_TYPE_MAX) {
+	if (priv->nvm_data->radio_cfg_type <= EEPROM_RF_CONFIG_TYPE_MAX) {
 		u32 reg_val =
-			EEPROM_RF_CFG_TYPE_MSK(radio_cfg) <<
+			priv->nvm_data->radio_cfg_type <<
 				CSR_HW_IF_CONFIG_REG_POS_PHY_TYPE |
-			EEPROM_RF_CFG_STEP_MSK(radio_cfg) <<
+			priv->nvm_data->radio_cfg_step <<
 				CSR_HW_IF_CONFIG_REG_POS_PHY_STEP |
-			EEPROM_RF_CFG_DASH_MSK(radio_cfg) <<
+			priv->nvm_data->radio_cfg_dash <<
 				CSR_HW_IF_CONFIG_REG_POS_PHY_DASH;
 
 		iwl_set_bits_mask(priv->trans, CSR_HW_IF_CONFIG_REG,
@@ -2007,9 +2014,9 @@ static void iwl_nic_config(struct iwl_op_mode *op_mode)
 				  CSR_HW_IF_CONFIG_REG_MSK_PHY_DASH, reg_val);
 
 		IWL_INFO(priv, "Radio type=0x%x-0x%x-0x%x\n",
-			 EEPROM_RF_CFG_TYPE_MSK(radio_cfg),
-			 EEPROM_RF_CFG_STEP_MSK(radio_cfg),
-			 EEPROM_RF_CFG_DASH_MSK(radio_cfg));
+			 priv->nvm_data->radio_cfg_type,
+			 priv->nvm_data->radio_cfg_step,
+			 priv->nvm_data->radio_cfg_dash);
 	} else {
 		WARN_ON(1);
 	}
diff --git a/drivers/net/wireless/iwlwifi/dvm/rs.c b/drivers/net/wireless/iwlwifi/dvm/rs.c
index a82f46c..f3dd0da 100644
--- a/drivers/net/wireless/iwlwifi/dvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/dvm/rs.c
@@ -820,7 +820,7 @@ static u32 rs_get_lower_rate(struct iwl_lq_sta *lq_sta,
 
 		if (num_of_ant(tbl->ant_type) > 1)
 			tbl->ant_type =
-			    first_antenna(priv->eeprom_data->valid_tx_ant);
+			    first_antenna(priv->nvm_data->valid_tx_ant);
 
 		tbl->is_ht40 = 0;
 		tbl->is_SGI = 0;
@@ -1448,7 +1448,7 @@ static int rs_move_legacy_other(struct iwl_priv *priv,
 	u32 sz = (sizeof(struct iwl_scale_tbl_info) -
 		  (sizeof(struct iwl_rate_scale_data) * IWL_RATE_COUNT));
 	u8 start_action;
-	u8 valid_tx_ant = priv->eeprom_data->valid_tx_ant;
+	u8 valid_tx_ant = priv->nvm_data->valid_tx_ant;
 	u8 tx_chains_num = priv->hw_params.tx_chains_num;
 	int ret = 0;
 	u8 update_search_tbl_counter = 0;
@@ -1466,7 +1466,7 @@ static int rs_move_legacy_other(struct iwl_priv *priv,
 	case IWL_BT_COEX_TRAFFIC_LOAD_CONTINUOUS:
 		/* avoid antenna B and MIMO */
 		valid_tx_ant =
-			first_antenna(priv->eeprom_data->valid_tx_ant);
+			first_antenna(priv->nvm_data->valid_tx_ant);
 		if (tbl->action >= IWL_LEGACY_SWITCH_ANTENNA2 &&
 		    tbl->action != IWL_LEGACY_SWITCH_SISO)
 			tbl->action = IWL_LEGACY_SWITCH_SISO;
@@ -1490,7 +1490,7 @@ static int rs_move_legacy_other(struct iwl_priv *priv,
 		else if (tbl->action >= IWL_LEGACY_SWITCH_ANTENNA2)
 			tbl->action = IWL_LEGACY_SWITCH_SISO;
 		valid_tx_ant =
-			first_antenna(priv->eeprom_data->valid_tx_ant);
+			first_antenna(priv->nvm_data->valid_tx_ant);
 	}
 
 	start_action = tbl->action;
@@ -1624,7 +1624,7 @@ static int rs_move_siso_to_other(struct iwl_priv *priv,
 	u32 sz = (sizeof(struct iwl_scale_tbl_info) -
 		  (sizeof(struct iwl_rate_scale_data) * IWL_RATE_COUNT));
 	u8 start_action;
-	u8 valid_tx_ant = priv->eeprom_data->valid_tx_ant;
+	u8 valid_tx_ant = priv->nvm_data->valid_tx_ant;
 	u8 tx_chains_num = priv->hw_params.tx_chains_num;
 	u8 update_search_tbl_counter = 0;
 	int ret;
@@ -1642,7 +1642,7 @@ static int rs_move_siso_to_other(struct iwl_priv *priv,
 	case IWL_BT_COEX_TRAFFIC_LOAD_CONTINUOUS:
 		/* avoid antenna B and MIMO */
 		valid_tx_ant =
-			first_antenna(priv->eeprom_data->valid_tx_ant);
+			first_antenna(priv->nvm_data->valid_tx_ant);
 		if (tbl->action != IWL_SISO_SWITCH_ANTENNA1)
 			tbl->action = IWL_SISO_SWITCH_ANTENNA1;
 		break;
@@ -1660,7 +1660,7 @@ static int rs_move_siso_to_other(struct iwl_priv *priv,
 	/* configure as 1x1 if bt full concurrency */
 	if (priv->bt_full_concurrent) {
 		valid_tx_ant =
-			first_antenna(priv->eeprom_data->valid_tx_ant);
+			first_antenna(priv->nvm_data->valid_tx_ant);
 		if (tbl->action >= IWL_LEGACY_SWITCH_ANTENNA2)
 			tbl->action = IWL_SISO_SWITCH_ANTENNA1;
 	}
@@ -1796,7 +1796,7 @@ static int rs_move_mimo2_to_other(struct iwl_priv *priv,
 	u32 sz = (sizeof(struct iwl_scale_tbl_info) -
 		  (sizeof(struct iwl_rate_scale_data) * IWL_RATE_COUNT));
 	u8 start_action;
-	u8 valid_tx_ant = priv->eeprom_data->valid_tx_ant;
+	u8 valid_tx_ant = priv->nvm_data->valid_tx_ant;
 	u8 tx_chains_num = priv->hw_params.tx_chains_num;
 	u8 update_search_tbl_counter = 0;
 	int ret;
@@ -1966,7 +1966,7 @@ static int rs_move_mimo3_to_other(struct iwl_priv *priv,
 	u32 sz = (sizeof(struct iwl_scale_tbl_info) -
 		  (sizeof(struct iwl_rate_scale_data) * IWL_RATE_COUNT));
 	u8 start_action;
-	u8 valid_tx_ant = priv->eeprom_data->valid_tx_ant;
+	u8 valid_tx_ant = priv->nvm_data->valid_tx_ant;
 	u8 tx_chains_num = priv->hw_params.tx_chains_num;
 	int ret;
 	u8 update_search_tbl_counter = 0;
@@ -2700,7 +2700,7 @@ static void rs_initialize_lq(struct iwl_priv *priv,
 
 	i = lq_sta->last_txrate_idx;
 
-	valid_tx_ant = priv->eeprom_data->valid_tx_ant;
+	valid_tx_ant = priv->nvm_data->valid_tx_ant;
 
 	if (!lq_sta->search_better_tbl)
 		active_tbl = lq_sta->active_tbl;
@@ -2894,15 +2894,15 @@ void iwl_rs_rate_init(struct iwl_priv *priv, struct ieee80211_sta *sta, u8 sta_i
 
 	/* These values will be overridden later */
 	lq_sta->lq.general_params.single_stream_ant_msk =
-		first_antenna(priv->eeprom_data->valid_tx_ant);
+		first_antenna(priv->nvm_data->valid_tx_ant);
 	lq_sta->lq.general_params.dual_stream_ant_msk =
-		priv->eeprom_data->valid_tx_ant &
-		~first_antenna(priv->eeprom_data->valid_tx_ant);
+		priv->nvm_data->valid_tx_ant &
+		~first_antenna(priv->nvm_data->valid_tx_ant);
 	if (!lq_sta->lq.general_params.dual_stream_ant_msk) {
 		lq_sta->lq.general_params.dual_stream_ant_msk = ANT_AB;
-	} else if (num_of_ant(priv->eeprom_data->valid_tx_ant) == 2) {
+	} else if (num_of_ant(priv->nvm_data->valid_tx_ant) == 2) {
 		lq_sta->lq.general_params.dual_stream_ant_msk =
-			priv->eeprom_data->valid_tx_ant;
+			priv->nvm_data->valid_tx_ant;
 	}
 
 	/* as default allow aggregation for all tids */
@@ -2948,7 +2948,7 @@ static void rs_fill_link_cmd(struct iwl_priv *priv,
 	if (priv && priv->bt_full_concurrent) {
 		/* 1x1 only */
 		tbl_type.ant_type =
-			first_antenna(priv->eeprom_data->valid_tx_ant);
+			first_antenna(priv->nvm_data->valid_tx_ant);
 	}
 
 	/* How many times should we repeat the initial rate? */
@@ -2980,7 +2980,7 @@ static void rs_fill_link_cmd(struct iwl_priv *priv,
 		if (priv->bt_full_concurrent)
 			valid_tx_ant = ANT_A;
 		else
-			valid_tx_ant = priv->eeprom_data->valid_tx_ant;
+			valid_tx_ant = priv->nvm_data->valid_tx_ant;
 	}
 
 	/* Fill rest of rate table */
@@ -3014,7 +3014,7 @@ static void rs_fill_link_cmd(struct iwl_priv *priv,
 		if (priv && priv->bt_full_concurrent) {
 			/* 1x1 only */
 			tbl_type.ant_type =
-			    first_antenna(priv->eeprom_data->valid_tx_ant);
+			    first_antenna(priv->nvm_data->valid_tx_ant);
 		}
 
 		/* Indicate to uCode which entries might be MIMO.
@@ -3101,7 +3101,7 @@ static void rs_dbgfs_set_mcs(struct iwl_lq_sta *lq_sta,
 	u8 ant_sel_tx;
 
 	priv = lq_sta->drv;
-	valid_tx_ant = priv->eeprom_data->valid_tx_ant;
+	valid_tx_ant = priv->nvm_data->valid_tx_ant;
 	if (lq_sta->dbg_fixed_rate) {
 		ant_sel_tx =
 		  ((lq_sta->dbg_fixed_rate & RATE_MCS_ANT_ABC_MSK)
@@ -3172,9 +3172,9 @@ static ssize_t rs_sta_dbgfs_scale_table_read(struct file *file,
 	desc += sprintf(buff+desc, "fixed rate 0x%X\n",
 			lq_sta->dbg_fixed_rate);
 	desc += sprintf(buff+desc, "valid_tx_ant %s%s%s\n",
-	    (priv->eeprom_data->valid_tx_ant & ANT_A) ? "ANT_A," : "",
-	    (priv->eeprom_data->valid_tx_ant & ANT_B) ? "ANT_B," : "",
-	    (priv->eeprom_data->valid_tx_ant & ANT_C) ? "ANT_C" : "");
+	    (priv->nvm_data->valid_tx_ant & ANT_A) ? "ANT_A," : "",
+	    (priv->nvm_data->valid_tx_ant & ANT_B) ? "ANT_B," : "",
+	    (priv->nvm_data->valid_tx_ant & ANT_C) ? "ANT_C" : "");
 	desc += sprintf(buff+desc, "lq type %s\n",
 	   (is_legacy(tbl->lq_type)) ? "legacy" : "HT");
 	if (is_Ht(tbl->lq_type)) {
diff --git a/drivers/net/wireless/iwlwifi/dvm/rxon.c b/drivers/net/wireless/iwlwifi/dvm/rxon.c
index 1089639..b43370d 100644
--- a/drivers/net/wireless/iwlwifi/dvm/rxon.c
+++ b/drivers/net/wireless/iwlwifi/dvm/rxon.c
@@ -420,10 +420,10 @@ static int iwl_set_tx_power(struct iwl_priv *priv, s8 tx_power, bool force)
 		return -EINVAL;
 	}
 
-	if (tx_power > DIV_ROUND_UP(priv->eeprom_data->max_tx_pwr_half_dbm, 2)) {
+	if (tx_power > DIV_ROUND_UP(priv->nvm_data->max_tx_pwr_half_dbm, 2)) {
 		IWL_WARN(priv,
 			"Requested user TXPOWER %d above upper limit %d.\n",
-			 tx_power, priv->eeprom_data->max_tx_pwr_half_dbm);
+			 tx_power, priv->nvm_data->max_tx_pwr_half_dbm);
 		return -EINVAL;
 	}
 
diff --git a/drivers/net/wireless/iwlwifi/dvm/scan.c b/drivers/net/wireless/iwlwifi/dvm/scan.c
index bb9f625..aad5fa4 100644
--- a/drivers/net/wireless/iwlwifi/dvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/dvm/scan.c
@@ -660,12 +660,12 @@ static int iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 	u16 rx_chain = 0;
 	enum ieee80211_band band;
 	u8 n_probes = 0;
-	u8 rx_ant = priv->eeprom_data->valid_rx_ant;
+	u8 rx_ant = priv->nvm_data->valid_rx_ant;
 	u8 rate;
 	bool is_active = false;
 	int  chan_mod;
 	u8 active_chains;
-	u8 scan_tx_antennas = priv->eeprom_data->valid_tx_ant;
+	u8 scan_tx_antennas = priv->nvm_data->valid_tx_ant;
 	int ret;
 	int scan_cmd_size = sizeof(struct iwl_scan_cmd) +
 			    MAX_SCAN_CHANNEL * sizeof(struct iwl_scan_channel) +
@@ -881,7 +881,7 @@ static int iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 
 	/* MIMO is not used here, but value is required */
 	rx_chain |=
-		priv->eeprom_data->valid_rx_ant << RXON_RX_CHAIN_VALID_POS;
+		priv->nvm_data->valid_rx_ant << RXON_RX_CHAIN_VALID_POS;
 	rx_chain |= rx_ant << RXON_RX_CHAIN_FORCE_MIMO_SEL_POS;
 	rx_chain |= rx_ant << RXON_RX_CHAIN_FORCE_SEL_POS;
 	rx_chain |= 0x1 << RXON_RX_CHAIN_DRIVER_FORCE_POS;
@@ -998,7 +998,7 @@ static int iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 
 void iwl_init_scan_params(struct iwl_priv *priv)
 {
-	u8 ant_idx = fls(priv->eeprom_data->valid_tx_ant) - 1;
+	u8 ant_idx = fls(priv->nvm_data->valid_tx_ant) - 1;
 	if (!priv->scan_tx_ant[IEEE80211_BAND_5GHZ])
 		priv->scan_tx_ant[IEEE80211_BAND_5GHZ] = ant_idx;
 	if (!priv->scan_tx_ant[IEEE80211_BAND_2GHZ])
diff --git a/drivers/net/wireless/iwlwifi/dvm/sta.c b/drivers/net/wireless/iwlwifi/dvm/sta.c
index cd9b6de..bdba954 100644
--- a/drivers/net/wireless/iwlwifi/dvm/sta.c
+++ b/drivers/net/wireless/iwlwifi/dvm/sta.c
@@ -634,23 +634,23 @@ static void iwl_sta_fill_lq(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
 	if (r >= IWL_FIRST_CCK_RATE && r <= IWL_LAST_CCK_RATE)
 		rate_flags |= RATE_MCS_CCK_MSK;
 
-	rate_flags |= first_antenna(priv->eeprom_data->valid_tx_ant) <<
+	rate_flags |= first_antenna(priv->nvm_data->valid_tx_ant) <<
 				RATE_MCS_ANT_POS;
 	rate_n_flags = iwl_hw_set_rate_n_flags(iwl_rates[r].plcp, rate_flags);
 	for (i = 0; i < LINK_QUAL_MAX_RETRY_NUM; i++)
 		link_cmd->rs_table[i].rate_n_flags = rate_n_flags;
 
 	link_cmd->general_params.single_stream_ant_msk =
-			first_antenna(priv->eeprom_data->valid_tx_ant);
+			first_antenna(priv->nvm_data->valid_tx_ant);
 
 	link_cmd->general_params.dual_stream_ant_msk =
-		priv->eeprom_data->valid_tx_ant &
-		~first_antenna(priv->eeprom_data->valid_tx_ant);
+		priv->nvm_data->valid_tx_ant &
+		~first_antenna(priv->nvm_data->valid_tx_ant);
 	if (!link_cmd->general_params.dual_stream_ant_msk) {
 		link_cmd->general_params.dual_stream_ant_msk = ANT_AB;
-	} else if (num_of_ant(priv->eeprom_data->valid_tx_ant) == 2) {
+	} else if (num_of_ant(priv->nvm_data->valid_tx_ant) == 2) {
 		link_cmd->general_params.dual_stream_ant_msk =
-			priv->eeprom_data->valid_tx_ant;
+			priv->nvm_data->valid_tx_ant;
 	}
 
 	link_cmd->agg_params.agg_dis_start_th =
diff --git a/drivers/net/wireless/iwlwifi/dvm/tx.c b/drivers/net/wireless/iwlwifi/dvm/tx.c
index 4ae031f..7d6cc5d 100644
--- a/drivers/net/wireless/iwlwifi/dvm/tx.c
+++ b/drivers/net/wireless/iwlwifi/dvm/tx.c
@@ -188,7 +188,7 @@ static void iwlagn_tx_cmd_build_rate(struct iwl_priv *priv,
 	if (info->control.rates[0].flags & IEEE80211_TX_RC_MCS ||
 			(rate_idx < 0) || (rate_idx > IWL_RATE_COUNT_LEGACY))
 		rate_idx = rate_lowest_index(
-				&priv->eeprom_data->bands[info->band], sta);
+				&priv->nvm_data->bands[info->band], sta);
 	/* For 5 GHZ band, remap mac80211 rate indices into driver indices */
 	if (info->band == IEEE80211_BAND_5GHZ)
 		rate_idx += IWL_FIRST_OFDM_RATE;
@@ -207,11 +207,11 @@ static void iwlagn_tx_cmd_build_rate(struct iwl_priv *priv,
 	     priv->bt_full_concurrent) {
 		/* operated as 1x1 in full concurrency mode */
 		priv->mgmt_tx_ant = iwl_toggle_tx_ant(priv, priv->mgmt_tx_ant,
-				first_antenna(priv->eeprom_data->valid_tx_ant));
+				first_antenna(priv->nvm_data->valid_tx_ant));
 	} else
 		priv->mgmt_tx_ant = iwl_toggle_tx_ant(
 					priv, priv->mgmt_tx_ant,
-					priv->eeprom_data->valid_tx_ant);
+					priv->nvm_data->valid_tx_ant);
 	rate_flags |= iwl_ant_idx_to_flags(priv->mgmt_tx_ant);
 
 	/* Set the rate in the TX cmd */
diff --git a/drivers/net/wireless/iwlwifi/dvm/ucode.c b/drivers/net/wireless/iwlwifi/dvm/ucode.c
index 95e6d33..c6467e5 100644
--- a/drivers/net/wireless/iwlwifi/dvm/ucode.c
+++ b/drivers/net/wireless/iwlwifi/dvm/ucode.c
@@ -61,7 +61,7 @@ iwl_get_ucode_image(struct iwl_priv *priv, enum iwl_ucode_type ucode_type)
 static int iwl_set_Xtal_calib(struct iwl_priv *priv)
 {
 	struct iwl_calib_xtal_freq_cmd cmd;
-	__le16 *xtal_calib = priv->eeprom_data->xtal_calib;
+	__le16 *xtal_calib = priv->nvm_data->xtal_calib;
 
 	iwl_set_calib_hdr(&cmd.hdr, IWL_PHY_CALIBRATE_CRYSTAL_FRQ_CMD);
 	cmd.cap_pin1 = le16_to_cpu(xtal_calib[0]);
@@ -75,7 +75,7 @@ static int iwl_set_temperature_offset_calib(struct iwl_priv *priv)
 
 	memset(&cmd, 0, sizeof(cmd));
 	iwl_set_calib_hdr(&cmd.hdr, IWL_PHY_CALIBRATE_TEMP_OFFSET_CMD);
-	cmd.radio_sensor_offset = priv->eeprom_data->raw_temperature;
+	cmd.radio_sensor_offset = priv->nvm_data->raw_temperature;
 	if (!(cmd.radio_sensor_offset))
 		cmd.radio_sensor_offset = DEFAULT_RADIO_SENSOR_OFFSET;
 
@@ -90,14 +90,14 @@ static int iwl_set_temperature_offset_calib_v2(struct iwl_priv *priv)
 
 	memset(&cmd, 0, sizeof(cmd));
 	iwl_set_calib_hdr(&cmd.hdr, IWL_PHY_CALIBRATE_TEMP_OFFSET_CMD);
-	cmd.radio_sensor_offset_high = priv->eeprom_data->kelvin_temperature;
-	cmd.radio_sensor_offset_low = priv->eeprom_data->raw_temperature;
+	cmd.radio_sensor_offset_high = priv->nvm_data->kelvin_temperature;
+	cmd.radio_sensor_offset_low = priv->nvm_data->raw_temperature;
 	if (!cmd.radio_sensor_offset_low) {
 		IWL_DEBUG_CALIB(priv, "no info in EEPROM, use default\n");
 		cmd.radio_sensor_offset_low = DEFAULT_RADIO_SENSOR_OFFSET;
 		cmd.radio_sensor_offset_high = DEFAULT_RADIO_SENSOR_OFFSET;
 	}
-	cmd.burntVoltageRef = priv->eeprom_data->calib_voltage;
+	cmd.burntVoltageRef = priv->nvm_data->calib_voltage;
 
 	IWL_DEBUG_CALIB(priv, "Radio sensor offset high: %d\n",
 			le16_to_cpu(cmd.radio_sensor_offset_high));
@@ -257,7 +257,7 @@ static int iwl_alive_notify(struct iwl_priv *priv)
 	iwl_trans_fw_alive(priv->trans, 0);
 
 	if (priv->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_PAN &&
-	    priv->eeprom_data->sku & EEPROM_SKU_CAP_IPAN_ENABLE) {
+	    priv->nvm_data->sku_cap_ipan_enable) {
 		n_queues = ARRAY_SIZE(iwlagn_ipan_queue_to_tx_fifo);
 		queue_to_txf = iwlagn_ipan_queue_to_tx_fifo;
 	} else {
diff --git a/drivers/net/wireless/iwlwifi/iwl-config.h b/drivers/net/wireless/iwlwifi/iwl-config.h
index 196266a..864219d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/iwlwifi/iwl-config.h
@@ -226,8 +226,8 @@ struct iwl_eeprom_params {
  * @max_data_size: The maximal length of the fw data section
  * @valid_tx_ant: valid transmit antenna
  * @valid_rx_ant: valid receive antenna
- * @eeprom_ver: EEPROM version
- * @eeprom_calib_ver: EEPROM calibration version
+ * @nvm_ver: NVM version
+ * @nvm_calib_ver: NVM calibration version
  * @lib: pointer to the lib ops
  * @base_params: pointer to basic parameters
  * @ht_params: point to ht patameters
@@ -257,8 +257,8 @@ struct iwl_cfg {
 	const u32 max_inst_size;
 	u8   valid_tx_ant;
 	u8   valid_rx_ant;
-	u16  eeprom_ver;
-	u16  eeprom_calib_ver;
+	u16  nvm_ver;
+	u16  nvm_calib_ver;
 	/* params not likely to change within a device family */
 	const struct iwl_base_params *base_params;
 	/* params likely to change within a device family */
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom-parse.c b/drivers/net/wireless/iwlwifi/iwl-eeprom-parse.c
index 4a9dc96..4719866 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom-parse.c
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom-parse.c
@@ -116,6 +116,24 @@ struct iwl_eeprom_calib_hdr {
 #define EEPROM_KELVIN_TEMPERATURE	((2*0x12A) | EEPROM_CALIB_ALL)
 #define EEPROM_RAW_TEMPERATURE		((2*0x12B) | EEPROM_CALIB_ALL)
 
+/* SKU Capabilities (actual values from EEPROM definition) */
+enum eeprom_sku_bits {
+	EEPROM_SKU_CAP_BAND_24GHZ	= BIT(4),
+	EEPROM_SKU_CAP_BAND_52GHZ	= BIT(5),
+	EEPROM_SKU_CAP_11N_ENABLE	= BIT(6),
+	EEPROM_SKU_CAP_AMT_ENABLE	= BIT(7),
+	EEPROM_SKU_CAP_IPAN_ENABLE	= BIT(8)
+};
+
+/* radio config bits (actual values from EEPROM definition) */
+#define EEPROM_RF_CFG_TYPE_MSK(x)   (x & 0x3)         /* bits 0-1   */
+#define EEPROM_RF_CFG_STEP_MSK(x)   ((x >> 2)  & 0x3) /* bits 2-3   */
+#define EEPROM_RF_CFG_DASH_MSK(x)   ((x >> 4)  & 0x3) /* bits 4-5   */
+#define EEPROM_RF_CFG_PNUM_MSK(x)   ((x >> 6)  & 0x3) /* bits 6-7   */
+#define EEPROM_RF_CFG_TX_ANT_MSK(x) ((x >> 8)  & 0xF) /* bits 8-11  */
+#define EEPROM_RF_CFG_RX_ANT_MSK(x) ((x >> 12) & 0xF) /* bits 12-15 */
+
+
 /*
  * EEPROM bands
  * These are the channel numbers from each band in the order
@@ -251,7 +269,7 @@ static const u8 *iwl_eeprom_query_addr(const u8 *eeprom, size_t eeprom_size,
 }
 
 static int iwl_eeprom_read_calib(const u8 *eeprom, size_t eeprom_size,
-				 struct iwl_eeprom_data *data)
+				 struct iwl_nvm_data *data)
 {
 	struct iwl_eeprom_calib_hdr *hdr;
 
@@ -330,7 +348,7 @@ struct iwl_eeprom_enhanced_txpwr {
 	s8 mimo3_max;
 } __packed;
 
-static s8 iwl_get_max_txpwr_half_dbm(const struct iwl_eeprom_data *data,
+static s8 iwl_get_max_txpwr_half_dbm(const struct iwl_nvm_data *data,
 				     struct iwl_eeprom_enhanced_txpwr *txp)
 {
 	s8 result = 0; /* (.5 dBm) */
@@ -364,7 +382,7 @@ static s8 iwl_get_max_txpwr_half_dbm(const struct iwl_eeprom_data *data,
 	((txp->flags & IWL_EEPROM_ENH_TXP_FL_##x) ? # x " " : "")
 
 static void
-iwl_eeprom_enh_txp_read_element(struct iwl_eeprom_data *data,
+iwl_eeprom_enh_txp_read_element(struct iwl_nvm_data *data,
 				struct iwl_eeprom_enhanced_txpwr *txp,
 				int n_channels, s8 max_txpower_avg)
 {
@@ -392,7 +410,7 @@ iwl_eeprom_enh_txp_read_element(struct iwl_eeprom_data *data,
 }
 
 static void iwl_eeprom_enhanced_txpower(struct device *dev,
-					struct iwl_eeprom_data *data,
+					struct iwl_nvm_data *data,
 					const u8 *eeprom, size_t eeprom_size,
 					int n_channels)
 {
@@ -504,7 +522,7 @@ static void iwl_init_band_reference(const struct iwl_cfg *cfg,
 	((eeprom_ch->flags & EEPROM_CHANNEL_##x) ? # x " " : "")
 
 static void iwl_mod_ht40_chan_info(struct device *dev,
-				   struct iwl_eeprom_data *data, int n_channels,
+				   struct iwl_nvm_data *data, int n_channels,
 				   enum ieee80211_band band, u16 channel,
 				   const struct iwl_eeprom_channel *eeprom_ch,
 				   u8 clear_ht40_extension_channel)
@@ -547,7 +565,7 @@ static void iwl_mod_ht40_chan_info(struct device *dev,
 	((eeprom_ch_info[ch_idx].flags & EEPROM_CHANNEL_##x) ? # x " " : "")
 
 static int iwl_init_channel_map(struct device *dev, const struct iwl_cfg *cfg,
-				struct iwl_eeprom_data *data,
+				struct iwl_nvm_data *data,
 				const u8 *eeprom, size_t eeprom_size)
 {
 	int band, ch_idx;
@@ -685,7 +703,7 @@ static int iwl_init_channel_map(struct device *dev, const struct iwl_cfg *cfg,
 	return n_channels;
 }
 
-static int iwl_init_sband_channels(struct iwl_eeprom_data *data,
+static int iwl_init_sband_channels(struct iwl_nvm_data *data,
 				   struct ieee80211_supported_band *sband,
 				   int n_channels, enum ieee80211_band band)
 {
@@ -711,7 +729,7 @@ static int iwl_init_sband_channels(struct iwl_eeprom_data *data,
 #define MAX_BIT_RATE_20_MHZ	72 /* Mbps */
 
 static void iwl_init_ht_hw_capab(const struct iwl_cfg *cfg,
-				 struct iwl_eeprom_data *data,
+				 struct iwl_nvm_data *data,
 				 struct ieee80211_sta_ht_cap *ht_info,
 				 enum ieee80211_band band)
 {
@@ -725,7 +743,7 @@ static void iwl_init_ht_hw_capab(const struct iwl_cfg *cfg,
 	else
 		rx_chains = hweight8(data->valid_rx_ant);
 
-	if (!(data->sku & EEPROM_SKU_CAP_11N_ENABLE) || !cfg->ht_params) {
+	if (!(data->sku_cap_11n_enable) || !cfg->ht_params) {
 		ht_info->ht_supported = false;
 		return;
 	}
@@ -773,7 +791,7 @@ static void iwl_init_ht_hw_capab(const struct iwl_cfg *cfg,
 }
 
 static void iwl_init_sbands(struct device *dev, const struct iwl_cfg *cfg,
-			    struct iwl_eeprom_data *data,
+			    struct iwl_nvm_data *data,
 			    const u8 *eeprom, size_t eeprom_size)
 {
 	int n_channels = iwl_init_channel_map(dev, cfg, data,
@@ -804,12 +822,13 @@ static void iwl_init_sbands(struct device *dev, const struct iwl_cfg *cfg,
 
 /* EEPROM data functions */
 
-struct iwl_eeprom_data *
+struct iwl_nvm_data *
 iwl_parse_eeprom_data(struct device *dev, const struct iwl_cfg *cfg,
 		      const u8 *eeprom, size_t eeprom_size)
 {
-	struct iwl_eeprom_data *data;
+	struct iwl_nvm_data *data;
 	const void *tmp;
+	u16 radio_cfg, sku;
 
 	if (WARN_ON(!cfg || !cfg->eeprom_params))
 		return NULL;
@@ -849,18 +868,27 @@ iwl_parse_eeprom_data(struct device *dev, const struct iwl_cfg *cfg,
 	data->kelvin_temperature = *(__le16 *)tmp;
 	data->kelvin_voltage = *((__le16 *)tmp + 1);
 
-	data->radio_cfg = iwl_eeprom_query16(eeprom, eeprom_size,
+	radio_cfg = iwl_eeprom_query16(eeprom, eeprom_size,
 					     EEPROM_RADIO_CONFIG);
-	data->sku = iwl_eeprom_query16(eeprom, eeprom_size,
-				       EEPROM_SKU_CAP);
+	data->radio_cfg_dash = EEPROM_RF_CFG_DASH_MSK(radio_cfg);
+	data->radio_cfg_pnum = EEPROM_RF_CFG_PNUM_MSK(radio_cfg);
+	data->radio_cfg_step = EEPROM_RF_CFG_STEP_MSK(radio_cfg);
+	data->radio_cfg_type = EEPROM_RF_CFG_TYPE_MSK(radio_cfg);
+	data->valid_rx_ant = EEPROM_RF_CFG_RX_ANT_MSK(radio_cfg);
+	data->valid_tx_ant = EEPROM_RF_CFG_TX_ANT_MSK(radio_cfg);
+
+	sku = iwl_eeprom_query16(eeprom, eeprom_size,
+				 EEPROM_SKU_CAP);
+	data->sku_cap_11n_enable = sku & EEPROM_SKU_CAP_11N_ENABLE;
+	data->sku_cap_amt_enable = sku & EEPROM_SKU_CAP_AMT_ENABLE;
+	data->sku_cap_band_24GHz_enable = sku & EEPROM_SKU_CAP_BAND_24GHZ;
+	data->sku_cap_band_52GHz_enable = sku & EEPROM_SKU_CAP_BAND_52GHZ;
+	data->sku_cap_ipan_enable = sku & EEPROM_SKU_CAP_IPAN_ENABLE;
 	if (iwlwifi_mod_params.disable_11n & IWL_DISABLE_HT_ALL)
-		data->sku &= ~EEPROM_SKU_CAP_11N_ENABLE;
-
-	data->eeprom_version = iwl_eeprom_query16(eeprom, eeprom_size,
-						  EEPROM_VERSION);
+		data->sku_cap_11n_enable = false;
 
-	data->valid_tx_ant = EEPROM_RF_CFG_TX_ANT_MSK(data->radio_cfg);
-	data->valid_rx_ant = EEPROM_RF_CFG_RX_ANT_MSK(data->radio_cfg);
+	data->nvm_version = iwl_eeprom_query16(eeprom, eeprom_size,
+					       EEPROM_VERSION);
 
 	/* check overrides (some devices have wrong EEPROM) */
 	if (cfg->valid_tx_ant)
@@ -884,20 +912,20 @@ iwl_parse_eeprom_data(struct device *dev, const struct iwl_cfg *cfg,
 EXPORT_SYMBOL_GPL(iwl_parse_eeprom_data);
 
 /* helper functions */
-int iwl_eeprom_check_version(struct iwl_eeprom_data *data,
+int iwl_nvm_check_version(struct iwl_nvm_data *data,
 			     struct iwl_trans *trans)
 {
-	if (data->eeprom_version >= trans->cfg->eeprom_ver ||
-	    data->calib_version >= trans->cfg->eeprom_calib_ver) {
+	if (data->nvm_version >= trans->cfg->nvm_ver ||
+	    data->calib_version >= trans->cfg->nvm_calib_ver) {
 		IWL_DEBUG_INFO(trans, "device EEPROM VER=0x%x, CALIB=0x%x\n",
-			       data->eeprom_version, data->calib_version);
+			       data->nvm_version, data->calib_version);
 		return 0;
 	}
 
 	IWL_ERR(trans,
 		"Unsupported (too old) EEPROM VER=0x%x < 0x%x CALIB=0x%x < 0x%x\n",
-		data->eeprom_version, trans->cfg->eeprom_ver,
-		data->calib_version,  trans->cfg->eeprom_calib_ver);
+		data->nvm_version, trans->cfg->nvm_ver,
+		data->calib_version,  trans->cfg->nvm_calib_ver);
 	return -EINVAL;
 }
-EXPORT_SYMBOL_GPL(iwl_eeprom_check_version);
+EXPORT_SYMBOL_GPL(iwl_nvm_check_version);
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom-parse.h b/drivers/net/wireless/iwlwifi/iwl-eeprom-parse.h
index a5e4257..555f0eb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom-parse.h
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom-parse.h
@@ -66,22 +66,7 @@
 #include <linux/if_ether.h>
 #include "iwl-trans.h"
 
-/* SKU Capabilities (actual values from EEPROM definition) */
-#define EEPROM_SKU_CAP_BAND_24GHZ	(1 << 4)
-#define EEPROM_SKU_CAP_BAND_52GHZ	(1 << 5)
-#define EEPROM_SKU_CAP_11N_ENABLE	(1 << 6)
-#define EEPROM_SKU_CAP_AMT_ENABLE	(1 << 7)
-#define EEPROM_SKU_CAP_IPAN_ENABLE	(1 << 8)
-
-/* radio config bits (actual values from EEPROM definition) */
-#define EEPROM_RF_CFG_TYPE_MSK(x)   (x & 0x3)         /* bits 0-1   */
-#define EEPROM_RF_CFG_STEP_MSK(x)   ((x >> 2)  & 0x3) /* bits 2-3   */
-#define EEPROM_RF_CFG_DASH_MSK(x)   ((x >> 4)  & 0x3) /* bits 4-5   */
-#define EEPROM_RF_CFG_PNUM_MSK(x)   ((x >> 6)  & 0x3) /* bits 6-7   */
-#define EEPROM_RF_CFG_TX_ANT_MSK(x) ((x >> 8)  & 0xF) /* bits 8-11  */
-#define EEPROM_RF_CFG_RX_ANT_MSK(x) ((x >> 12) & 0xF) /* bits 12-15 */
-
-struct iwl_eeprom_data {
+struct iwl_nvm_data {
 	int n_hw_addrs;
 	u8 hw_addr[ETH_ALEN];
 
@@ -93,13 +78,21 @@ struct iwl_eeprom_data {
 	__le16 kelvin_voltage;
 	__le16 xtal_calib[2];
 
-	u16 sku;
-	u16 radio_cfg;
-	u16 eeprom_version;
-	s8 max_tx_pwr_half_dbm;
+	bool sku_cap_band_24GHz_enable;
+	bool sku_cap_band_52GHz_enable;
+	bool sku_cap_11n_enable;
+	bool sku_cap_amt_enable;
+	bool sku_cap_ipan_enable;
 
+	u8 radio_cfg_type;
+	u8 radio_cfg_step;
+	u8 radio_cfg_dash;
+	u8 radio_cfg_pnum;
 	u8 valid_tx_ant, valid_rx_ant;
 
+	u16 nvm_version;
+	s8 max_tx_pwr_half_dbm;
+
 	struct ieee80211_supported_band bands[IEEE80211_NUM_BANDS];
 	struct ieee80211_channel channels[];
 };
@@ -115,22 +108,22 @@ struct iwl_eeprom_data {
  * This function parses all EEPROM values we need and then
  * returns a (newly allocated) struct containing all the
  * relevant values for driver use. The struct must be freed
- * later with iwl_free_eeprom_data().
+ * later with iwl_free_nvm_data().
  */
-struct iwl_eeprom_data *
+struct iwl_nvm_data *
 iwl_parse_eeprom_data(struct device *dev, const struct iwl_cfg *cfg,
 		      const u8 *eeprom, size_t eeprom_size);
 
 /**
- * iwl_free_eeprom_data - free EEPROM data
+ * iwl_free_nvm_data - free NVM data
  * @data: the data to free
  */
-static inline void iwl_free_eeprom_data(struct iwl_eeprom_data *data)
+static inline void iwl_free_nvm_data(struct iwl_nvm_data *data)
 {
 	kfree(data);
 }
 
-int iwl_eeprom_check_version(struct iwl_eeprom_data *data,
-			     struct iwl_trans *trans);
+int iwl_nvm_check_version(struct iwl_nvm_data *data,
+			  struct iwl_trans *trans);
 
 #endif /* __iwl_eeprom_parse_h__ */
diff --git a/drivers/net/wireless/iwlwifi/pcie/1000.c b/drivers/net/wireless/iwlwifi/pcie/1000.c
index 81b83f4..f8620ec 100644
--- a/drivers/net/wireless/iwlwifi/pcie/1000.c
+++ b/drivers/net/wireless/iwlwifi/pcie/1000.c
@@ -94,8 +94,8 @@ static const struct iwl_eeprom_params iwl1000_eeprom_params = {
 	.device_family = IWL_DEVICE_FAMILY_1000,		\
 	.max_inst_size = IWLAGN_RTC_INST_SIZE,			\
 	.max_data_size = IWLAGN_RTC_DATA_SIZE,			\
-	.eeprom_ver = EEPROM_1000_EEPROM_VERSION,		\
-	.eeprom_calib_ver = EEPROM_1000_TX_POWER_VERSION,	\
+	.nvm_ver = EEPROM_1000_EEPROM_VERSION,		\
+	.nvm_calib_ver = EEPROM_1000_TX_POWER_VERSION,	\
 	.base_params = &iwl1000_base_params,			\
 	.eeprom_params = &iwl1000_eeprom_params,		\
 	.led_mode = IWL_LED_BLINK
@@ -119,8 +119,8 @@ const struct iwl_cfg iwl1000_bg_cfg = {
 	.device_family = IWL_DEVICE_FAMILY_100,			\
 	.max_inst_size = IWLAGN_RTC_INST_SIZE,			\
 	.max_data_size = IWLAGN_RTC_DATA_SIZE,			\
-	.eeprom_ver = EEPROM_1000_EEPROM_VERSION,		\
-	.eeprom_calib_ver = EEPROM_1000_TX_POWER_VERSION,	\
+	.nvm_ver = EEPROM_1000_EEPROM_VERSION,		\
+	.nvm_calib_ver = EEPROM_1000_TX_POWER_VERSION,	\
 	.base_params = &iwl1000_base_params,			\
 	.eeprom_params = &iwl1000_eeprom_params,		\
 	.led_mode = IWL_LED_RF_STATE,				\
diff --git a/drivers/net/wireless/iwlwifi/pcie/2000.c b/drivers/net/wireless/iwlwifi/pcie/2000.c
index 9fbde32..244019c 100644
--- a/drivers/net/wireless/iwlwifi/pcie/2000.c
+++ b/drivers/net/wireless/iwlwifi/pcie/2000.c
@@ -138,8 +138,8 @@ static const struct iwl_eeprom_params iwl20x0_eeprom_params = {
 	.device_family = IWL_DEVICE_FAMILY_2000,		\
 	.max_inst_size = IWL60_RTC_INST_SIZE,			\
 	.max_data_size = IWL60_RTC_DATA_SIZE,			\
-	.eeprom_ver = EEPROM_2000_EEPROM_VERSION,		\
-	.eeprom_calib_ver = EEPROM_2000_TX_POWER_VERSION,	\
+	.nvm_ver = EEPROM_2000_EEPROM_VERSION,		\
+	.nvm_calib_ver = EEPROM_2000_TX_POWER_VERSION,	\
 	.base_params = &iwl2000_base_params,			\
 	.eeprom_params = &iwl20x0_eeprom_params,		\
 	.need_temp_offset_calib = true,				\
@@ -166,8 +166,8 @@ const struct iwl_cfg iwl2000_2bgn_d_cfg = {
 	.device_family = IWL_DEVICE_FAMILY_2030,		\
 	.max_inst_size = IWL60_RTC_INST_SIZE,			\
 	.max_data_size = IWL60_RTC_DATA_SIZE,			\
-	.eeprom_ver = EEPROM_2000_EEPROM_VERSION,		\
-	.eeprom_calib_ver = EEPROM_2000_TX_POWER_VERSION,	\
+	.nvm_ver = EEPROM_2000_EEPROM_VERSION,		\
+	.nvm_calib_ver = EEPROM_2000_TX_POWER_VERSION,	\
 	.base_params = &iwl2030_base_params,			\
 	.bt_params = &iwl2030_bt_params,			\
 	.eeprom_params = &iwl20x0_eeprom_params,		\
@@ -190,8 +190,8 @@ const struct iwl_cfg iwl2030_2bgn_cfg = {
 	.device_family = IWL_DEVICE_FAMILY_105,			\
 	.max_inst_size = IWL60_RTC_INST_SIZE,			\
 	.max_data_size = IWL60_RTC_DATA_SIZE,			\
-	.eeprom_ver = EEPROM_2000_EEPROM_VERSION,		\
-	.eeprom_calib_ver = EEPROM_2000_TX_POWER_VERSION,	\
+	.nvm_ver = EEPROM_2000_EEPROM_VERSION,		\
+	.nvm_calib_ver = EEPROM_2000_TX_POWER_VERSION,	\
 	.base_params = &iwl2000_base_params,			\
 	.eeprom_params = &iwl20x0_eeprom_params,		\
 	.need_temp_offset_calib = true,				\
@@ -220,8 +220,8 @@ const struct iwl_cfg iwl105_bgn_d_cfg = {
 	.device_family = IWL_DEVICE_FAMILY_135,			\
 	.max_inst_size = IWL60_RTC_INST_SIZE,			\
 	.max_data_size = IWL60_RTC_DATA_SIZE,			\
-	.eeprom_ver = EEPROM_2000_EEPROM_VERSION,		\
-	.eeprom_calib_ver = EEPROM_2000_TX_POWER_VERSION,	\
+	.nvm_ver = EEPROM_2000_EEPROM_VERSION,		\
+	.nvm_calib_ver = EEPROM_2000_TX_POWER_VERSION,	\
 	.base_params = &iwl2030_base_params,			\
 	.bt_params = &iwl2030_bt_params,			\
 	.eeprom_params = &iwl20x0_eeprom_params,		\
diff --git a/drivers/net/wireless/iwlwifi/pcie/5000.c b/drivers/net/wireless/iwlwifi/pcie/5000.c
index d1665fa..83ca403 100644
--- a/drivers/net/wireless/iwlwifi/pcie/5000.c
+++ b/drivers/net/wireless/iwlwifi/pcie/5000.c
@@ -92,8 +92,8 @@ static const struct iwl_eeprom_params iwl5000_eeprom_params = {
 	.device_family = IWL_DEVICE_FAMILY_5000,		\
 	.max_inst_size = IWLAGN_RTC_INST_SIZE,			\
 	.max_data_size = IWLAGN_RTC_DATA_SIZE,			\
-	.eeprom_ver = EEPROM_5000_EEPROM_VERSION,		\
-	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,	\
+	.nvm_ver = EEPROM_5000_EEPROM_VERSION,		\
+	.nvm_calib_ver = EEPROM_5000_TX_POWER_VERSION,	\
 	.base_params = &iwl5000_base_params,			\
 	.eeprom_params = &iwl5000_eeprom_params,		\
 	.led_mode = IWL_LED_BLINK
@@ -139,8 +139,8 @@ const struct iwl_cfg iwl5350_agn_cfg = {
 	.device_family = IWL_DEVICE_FAMILY_5000,
 	.max_inst_size = IWLAGN_RTC_INST_SIZE,
 	.max_data_size = IWLAGN_RTC_DATA_SIZE,
-	.eeprom_ver = EEPROM_5050_EEPROM_VERSION,
-	.eeprom_calib_ver = EEPROM_5050_TX_POWER_VERSION,
+	.nvm_ver = EEPROM_5050_EEPROM_VERSION,
+	.nvm_calib_ver = EEPROM_5050_TX_POWER_VERSION,
 	.base_params = &iwl5000_base_params,
 	.eeprom_params = &iwl5000_eeprom_params,
 	.ht_params = &iwl5000_ht_params,
@@ -156,8 +156,8 @@ const struct iwl_cfg iwl5350_agn_cfg = {
 	.device_family = IWL_DEVICE_FAMILY_5150,		\
 	.max_inst_size = IWLAGN_RTC_INST_SIZE,			\
 	.max_data_size = IWLAGN_RTC_DATA_SIZE,			\
-	.eeprom_ver = EEPROM_5050_EEPROM_VERSION,		\
-	.eeprom_calib_ver = EEPROM_5050_TX_POWER_VERSION,	\
+	.nvm_ver = EEPROM_5050_EEPROM_VERSION,		\
+	.nvm_calib_ver = EEPROM_5050_TX_POWER_VERSION,	\
 	.base_params = &iwl5000_base_params,			\
 	.eeprom_params = &iwl5000_eeprom_params,		\
 	.no_xtal_calib = true,					\
diff --git a/drivers/net/wireless/iwlwifi/pcie/6000.c b/drivers/net/wireless/iwlwifi/pcie/6000.c
index 4a57624..d4df976 100644
--- a/drivers/net/wireless/iwlwifi/pcie/6000.c
+++ b/drivers/net/wireless/iwlwifi/pcie/6000.c
@@ -160,8 +160,8 @@ static const struct iwl_eeprom_params iwl6000_eeprom_params = {
 	.device_family = IWL_DEVICE_FAMILY_6005,		\
 	.max_inst_size = IWL60_RTC_INST_SIZE,			\
 	.max_data_size = IWL60_RTC_DATA_SIZE,			\
-	.eeprom_ver = EEPROM_6005_EEPROM_VERSION,		\
-	.eeprom_calib_ver = EEPROM_6005_TX_POWER_VERSION,	\
+	.nvm_ver = EEPROM_6005_EEPROM_VERSION,		\
+	.nvm_calib_ver = EEPROM_6005_TX_POWER_VERSION,	\
 	.base_params = &iwl6000_g2_base_params,			\
 	.eeprom_params = &iwl6000_eeprom_params,		\
 	.need_temp_offset_calib = true,				\
@@ -215,8 +215,8 @@ const struct iwl_cfg iwl6005_2agn_mow2_cfg = {
 	.device_family = IWL_DEVICE_FAMILY_6030,		\
 	.max_inst_size = IWL60_RTC_INST_SIZE,			\
 	.max_data_size = IWL60_RTC_DATA_SIZE,			\
-	.eeprom_ver = EEPROM_6030_EEPROM_VERSION,		\
-	.eeprom_calib_ver = EEPROM_6030_TX_POWER_VERSION,	\
+	.nvm_ver = EEPROM_6030_EEPROM_VERSION,		\
+	.nvm_calib_ver = EEPROM_6030_TX_POWER_VERSION,	\
 	.base_params = &iwl6000_g2_base_params,			\
 	.bt_params = &iwl6000_bt_params,			\
 	.eeprom_params = &iwl6000_eeprom_params,		\
@@ -254,8 +254,8 @@ const struct iwl_cfg iwl6030_2bg_cfg = {
 	.device_family = IWL_DEVICE_FAMILY_6030,		\
 	.max_inst_size = IWL60_RTC_INST_SIZE,			\
 	.max_data_size = IWL60_RTC_DATA_SIZE,			\
-	.eeprom_ver = EEPROM_6030_EEPROM_VERSION,		\
-	.eeprom_calib_ver = EEPROM_6030_TX_POWER_VERSION,	\
+	.nvm_ver = EEPROM_6030_EEPROM_VERSION,		\
+	.nvm_calib_ver = EEPROM_6030_TX_POWER_VERSION,	\
 	.base_params = &iwl6000_g2_base_params,			\
 	.bt_params = &iwl6000_bt_params,			\
 	.eeprom_params = &iwl6000_eeprom_params,		\
@@ -306,8 +306,8 @@ const struct iwl_cfg iwl130_bg_cfg = {
 	.max_data_size = IWL60_RTC_DATA_SIZE,			\
 	.valid_tx_ant = ANT_BC,		/* .cfg overwrite */	\
 	.valid_rx_ant = ANT_BC,		/* .cfg overwrite */	\
-	.eeprom_ver = EEPROM_6000_EEPROM_VERSION,		\
-	.eeprom_calib_ver = EEPROM_6000_TX_POWER_VERSION,	\
+	.nvm_ver = EEPROM_6000_EEPROM_VERSION,		\
+	.nvm_calib_ver = EEPROM_6000_TX_POWER_VERSION,	\
 	.base_params = &iwl6000_base_params,			\
 	.eeprom_params = &iwl6000_eeprom_params,		\
 	.led_mode = IWL_LED_BLINK
@@ -337,8 +337,8 @@ const struct iwl_cfg iwl6000i_2bg_cfg = {
 	.max_data_size = IWL60_RTC_DATA_SIZE,			\
 	.valid_tx_ant = ANT_AB,		/* .cfg overwrite */	\
 	.valid_rx_ant = ANT_AB,		/* .cfg overwrite */	\
-	.eeprom_ver = EEPROM_6050_EEPROM_VERSION,		\
-	.eeprom_calib_ver = EEPROM_6050_TX_POWER_VERSION,	\
+	.nvm_ver = EEPROM_6050_EEPROM_VERSION,		\
+	.nvm_calib_ver = EEPROM_6050_TX_POWER_VERSION,	\
 	.base_params = &iwl6050_base_params,			\
 	.eeprom_params = &iwl6000_eeprom_params,		\
 	.led_mode = IWL_LED_BLINK,				\
@@ -362,8 +362,8 @@ const struct iwl_cfg iwl6050_2abg_cfg = {
 	.device_family = IWL_DEVICE_FAMILY_6150,		\
 	.max_inst_size = IWL60_RTC_INST_SIZE,			\
 	.max_data_size = IWL60_RTC_DATA_SIZE,			\
-	.eeprom_ver = EEPROM_6150_EEPROM_VERSION,		\
-	.eeprom_calib_ver = EEPROM_6150_TX_POWER_VERSION,	\
+	.nvm_ver = EEPROM_6150_EEPROM_VERSION,		\
+	.nvm_calib_ver = EEPROM_6150_TX_POWER_VERSION,	\
 	.base_params = &iwl6050_base_params,			\
 	.eeprom_params = &iwl6000_eeprom_params,		\
 	.led_mode = IWL_LED_BLINK,				\
@@ -389,8 +389,8 @@ const struct iwl_cfg iwl6000_3agn_cfg = {
 	.device_family = IWL_DEVICE_FAMILY_6000,
 	.max_inst_size = IWL60_RTC_INST_SIZE,
 	.max_data_size = IWL60_RTC_DATA_SIZE,
-	.eeprom_ver = EEPROM_6000_EEPROM_VERSION,
-	.eeprom_calib_ver = EEPROM_6000_TX_POWER_VERSION,
+	.nvm_ver = EEPROM_6000_EEPROM_VERSION,
+	.nvm_calib_ver = EEPROM_6000_TX_POWER_VERSION,
 	.base_params = &iwl6000_base_params,
 	.eeprom_params = &iwl6000_eeprom_params,
 	.ht_params = &iwl6000_ht_params,
-- 
1.8.0

