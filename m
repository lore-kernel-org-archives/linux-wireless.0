Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:27344 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753935Ab0HWOxd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Aug 2010 10:53:33 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 13/26] iwlwifi: add bt full concurrency support
Date: Mon, 23 Aug 2010 07:57:04 -0700
Message-Id: <1282575437-23270-14-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1282575437-23270-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1282575437-23270-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Adding the bluetooth full concurrency support for WiFi/BT combo devices.

Driver should configure uCode to operate in "full concurrency" mode (via
LUT) if both conditions are met:
 - Antenna Coupling is more than 35dB
 - WiFi Channel Inhibition Request is hornored by BT Core

Currently, there is no antenna coupling information provided by uCode;
use module parameter to specified the antenna coupling in dB.

When in "full concurrency" mode, driver need to download different LUT
to uCode while sending bt configuration command; also, driver need to
configure the device operate in 1x1 while in full concurrency mode.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-6000.c      |   34 +++++++++++--
 drivers/net/wireless/iwlwifi/iwl-agn-calib.c |    6 ++-
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c   |   11 ++++
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c    |   70 ++++++++++++++++++++++++-
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c    |    7 ++-
 drivers/net/wireless/iwlwifi/iwl-agn.c       |   49 ++++++++++++++++++-
 drivers/net/wireless/iwlwifi/iwl-core.c      |   11 ++++-
 drivers/net/wireless/iwlwifi/iwl-core.h      |    1 +
 drivers/net/wireless/iwlwifi/iwl-dev.h       |    7 +++
 9 files changed, 185 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 9d43098..a4601b5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -201,6 +201,21 @@ static const __le32 iwl6000g2b_def_3w_lookup[12] = {
 	cpu_to_le32(0xf0004000),
 };
 
+static const __le32 iwl6000g2b_concurrent_lookup[12] = {
+	cpu_to_le32(0xaaaaaaaa),
+	cpu_to_le32(0xaaaaaaaa),
+	cpu_to_le32(0xaaaaaaaa),
+	cpu_to_le32(0xaaaaaaaa),
+	cpu_to_le32(0xaaaaaaaa),
+	cpu_to_le32(0xaaaaaaaa),
+	cpu_to_le32(0xaaaaaaaa),
+	cpu_to_le32(0xaaaaaaaa),
+	cpu_to_le32(0x00000000),
+	cpu_to_le32(0x00000000),
+	cpu_to_le32(0x00000000),
+	cpu_to_le32(0x00000000),
+};
+
 static void iwl6000g2b_send_bt_config(struct iwl_priv *priv)
 {
 	struct iwl6000g2b_bt_cmd bt_cmd = {
@@ -233,11 +248,17 @@ static void iwl6000g2b_send_bt_config(struct iwl_priv *priv)
 		bt_cmd.valid |= IWL6000G2B_BT_ALL_VALID_MSK;
 	}
 
-	memcpy(bt_cmd.bt3_lookup_table, iwl6000g2b_def_3w_lookup,
-		sizeof(iwl6000g2b_def_3w_lookup));
+	if (priv->bt_full_concurrent)
+		memcpy(bt_cmd.bt3_lookup_table, iwl6000g2b_concurrent_lookup,
+			sizeof(iwl6000g2b_concurrent_lookup));
+	else
+		memcpy(bt_cmd.bt3_lookup_table, iwl6000g2b_def_3w_lookup,
+			sizeof(iwl6000g2b_def_3w_lookup));
 
-	IWL_DEBUG_INFO(priv, "BT coex %s\n",
-		       bt_cmd.flags ? "active" : "disabled");
+	IWL_DEBUG_INFO(priv, "BT coex %s in %s mode\n",
+		       bt_cmd.flags ? "active" : "disabled",
+		       priv->bt_full_concurrent ?
+		       "full concurrency" : "3-wire");
 
 	if (iwl_send_cmd_pdu(priv, REPLY_BT_CONFIG, sizeof(bt_cmd), &bt_cmd))
 		IWL_ERR(priv, "failed to send BT Coex Config\n");
@@ -435,6 +456,7 @@ static void iwl6000g2b_bt_traffic_change_work(struct work_struct *work)
 static void iwl6000g2b_bt_coex_profile_notif(struct iwl_priv *priv,
 					     struct iwl_rx_mem_buffer *rxb)
 {
+	unsigned long flags;
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	struct iwl_bt_coex_profile_notif *coex = &pkt->u.bt_coex_profile_notif;
 	struct iwl6000g2b_bt_sco_cmd sco_cmd = { .flags = 0 };
@@ -466,6 +488,10 @@ static void iwl6000g2b_bt_coex_profile_notif(struct iwl_priv *priv,
 		iwl_send_cmd_pdu_async(priv, REPLY_BT_COEX_SCO,
 				       sizeof(sco_cmd), &sco_cmd, NULL);
 	}
+
+	spin_lock_irqsave(&priv->lock, flags);
+	priv->bt_ci_compliance = coex->bt_ci_compliance;
+	spin_unlock_irqrestore(&priv->lock, flags);
 }
 
 void iwl6000g2b_rx_handler_setup(struct iwl_priv *priv)
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-calib.c b/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
index c4c5691..156b125 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
@@ -914,7 +914,11 @@ void iwl_chain_noise_calibration(struct iwl_priv *priv, void *stat_resp)
 	 * To be safe, simply mask out any chains that we know
 	 * are not on the device.
 	 */
-	active_chains &= priv->hw_params.valid_rx_ant;
+	if (priv->cfg->advanced_bt_coexist && priv->bt_full_concurrent) {
+		/* operated as 1x1 in full concurrency mode */
+		active_chains &= first_antenna(priv->hw_params.valid_rx_ant);
+	} else
+		active_chains &= priv->hw_params.valid_rx_ant;
 
 	num_tx_chains = 0;
 	for (i = 0; i < NUM_RX_CHAINS; i++) {
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index e1b5250..e0ec6c0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -1333,6 +1333,12 @@ void iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 	if (priv->cfg->scan_tx_antennas[band])
 		scan_tx_antennas = priv->cfg->scan_tx_antennas[band];
 
+	if (priv->cfg->advanced_bt_coexist && priv->bt_full_concurrent) {
+		/* operated as 1x1 in full concurrency mode */
+		scan_tx_antennas =
+			first_antenna(priv->cfg->scan_tx_antennas[band]);
+	}
+
 	priv->scan_tx_ant[band] = iwl_toggle_tx_ant(priv, priv->scan_tx_ant[band],
 						    scan_tx_antennas);
 	rate_flags |= iwl_ant_idx_to_flags(priv->scan_tx_ant[band]);
@@ -1351,6 +1357,11 @@ void iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 
 		rx_ant = first_antenna(active_chains);
 	}
+	if (priv->cfg->advanced_bt_coexist && priv->bt_full_concurrent) {
+		/* operated as 1x1 in full concurrency mode */
+		rx_ant = first_antenna(rx_ant);
+	}
+
 	/* MIMO is not used here, but value is required */
 	rx_chain |= priv->hw_params.valid_rx_ant << RXON_RX_CHAIN_VALID_POS;
 	rx_chain |= rx_ant << RXON_RX_CHAIN_FORCE_MIMO_SEL_POS;
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index f8eed92..687b534 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -758,6 +758,32 @@ static bool table_type_matches(struct iwl_scale_tbl_info *a,
 		(a->is_SGI == b->is_SGI);
 }
 
+static void rs_bt_update_lq(struct iwl_priv *priv,
+			       struct iwl_lq_sta *lq_sta)
+{
+	struct iwl_scale_tbl_info *tbl;
+	bool full_concurrent;
+	unsigned long flags;
+
+	spin_lock_irqsave(&priv->lock, flags);
+	if (priv->bt_ci_compliance && priv->bt_ant_couple_ok)
+		full_concurrent = true;
+	else
+		full_concurrent = false;
+	spin_unlock_irqrestore(&priv->lock, flags);
+
+	if (priv->bt_full_concurrent != full_concurrent) {
+		priv->bt_full_concurrent = full_concurrent;
+
+		/* Update uCode's rate table. */
+		tbl = &(lq_sta->lq_info[lq_sta->active_tbl]);
+		rs_fill_link_cmd(priv, lq_sta, tbl->current_rate);
+		iwl_send_lq_cmd(priv, &lq_sta->lq, CMD_ASYNC, false);
+
+		queue_work(priv->workqueue, &priv->bt_full_concurrency);
+	}
+}
+
 /*
  * mac80211 sends us Tx status
  */
@@ -940,6 +966,10 @@ done:
 	/* See if there's a better rate or modulation mode to try. */
 	if (sta && sta->supp_rates[sband->band])
 		rs_rate_scale_perform(priv, skb, sta, lq_sta);
+
+	/* Is there a need to switch between full concurrency and 3-wire? */
+	if (priv->bt_ant_couple_ok)
+		rs_bt_update_lq(priv, lq_sta);
 }
 
 /*
@@ -1325,6 +1355,15 @@ static int rs_move_legacy_other(struct iwl_priv *priv,
 	else if (iwl_tx_ant_restriction(priv) == IWL_ANT_OK_SINGLE &&
 		   tbl->action > IWL_LEGACY_SWITCH_SISO)
 		tbl->action = IWL_LEGACY_SWITCH_SISO;
+
+	/* configure as 1x1 if bt full concurrency */
+	if (priv->bt_full_concurrent) {
+		if (!iwl_ht_enabled(priv))
+			tbl->action = IWL_LEGACY_SWITCH_ANTENNA1;
+		else if (tbl->action >= IWL_LEGACY_SWITCH_ANTENNA2)
+			tbl->action = IWL_LEGACY_SWITCH_SISO;
+	}
+
 	start_action = tbl->action;
 	for (; ;) {
 		lq_sta->action_counter++;
@@ -1484,6 +1523,12 @@ static int rs_move_siso_to_other(struct iwl_priv *priv,
 		/* stay in SISO */
 		tbl->action = IWL_SISO_SWITCH_ANTENNA1;
 	}
+
+	/* configure as 1x1 if bt full concurrency */
+	if (priv->bt_full_concurrent &&
+	    tbl->action >= IWL_LEGACY_SWITCH_ANTENNA2)
+		tbl->action = IWL_SISO_SWITCH_ANTENNA1;
+
 	start_action = tbl->action;
 	for (;;) {
 		lq_sta->action_counter++;
@@ -1645,6 +1690,13 @@ static int rs_move_mimo2_to_other(struct iwl_priv *priv,
 		/* switch in SISO */
 		tbl->action = IWL_MIMO2_SWITCH_SISO_A;
 	}
+
+	/* configure as 1x1 if bt full concurrency */
+	if (priv->bt_full_concurrent &&
+	    (tbl->action < IWL_MIMO2_SWITCH_SISO_A ||
+	     tbl->action > IWL_MIMO2_SWITCH_SISO_C))
+		tbl->action = IWL_MIMO2_SWITCH_SISO_A;
+
 	start_action = tbl->action;
 	for (;;) {
 		lq_sta->action_counter++;
@@ -1810,6 +1862,13 @@ static int rs_move_mimo3_to_other(struct iwl_priv *priv,
 		/* switch in SISO */
 		tbl->action = IWL_MIMO3_SWITCH_SISO_A;
 	}
+
+	/* configure as 1x1 if bt full concurrency */
+	if (priv->bt_full_concurrent &&
+	    (tbl->action < IWL_MIMO3_SWITCH_SISO_A ||
+	     tbl->action > IWL_MIMO3_SWITCH_SISO_C))
+		tbl->action = IWL_MIMO3_SWITCH_SISO_A;
+
 	start_action = tbl->action;
 	for (;;) {
 		lq_sta->action_counter++;
@@ -2741,7 +2800,8 @@ static void rs_fill_link_cmd(struct iwl_priv *priv,
 	/* Fill 1st table entry (index 0) */
 	lq_cmd->rs_table[index].rate_n_flags = cpu_to_le32(new_rate);
 
-	if (num_of_ant(tbl_type.ant_type) == 1) {
+	if (num_of_ant(tbl_type.ant_type) == 1 ||
+	    (priv && priv->bt_full_concurrent)) {
 		lq_cmd->general_params.single_stream_ant_msk =
 						tbl_type.ant_type;
 	} else if (num_of_ant(tbl_type.ant_type) == 2) {
@@ -2752,8 +2812,12 @@ static void rs_fill_link_cmd(struct iwl_priv *priv,
 	index++;
 	repeat_rate--;
 
-	if (priv)
-		valid_tx_ant = priv->hw_params.valid_tx_ant;
+	if (priv) {
+		if (priv->bt_full_concurrent)
+			valid_tx_ant = ANT_A;
+		else
+			valid_tx_ant = priv->hw_params.valid_tx_ant;
+	}
 
 	/* Fill rest of rate table */
 	while (index < LINK_QUAL_MAX_RETRY_NUM) {
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index 8d2ffff..e2497e7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -461,7 +461,12 @@ static void iwlagn_tx_cmd_build_rate(struct iwl_priv *priv,
 		rate_flags |= RATE_MCS_CCK_MSK;
 
 	/* Set up antennas */
-	priv->mgmt_tx_ant = iwl_toggle_tx_ant(priv, priv->mgmt_tx_ant,
+	 if (priv->cfg->advanced_bt_coexist && priv->bt_full_concurrent) {
+		/* operated as 1x1 in full concurrency mode */
+		priv->mgmt_tx_ant = iwl_toggle_tx_ant(priv, priv->mgmt_tx_ant,
+				first_antenna(priv->hw_params.valid_tx_ant));
+	} else
+		priv->mgmt_tx_ant = iwl_toggle_tx_ant(priv, priv->mgmt_tx_ant,
 					      priv->hw_params.valid_tx_ant);
 	rate_flags |= iwl_ant_idx_to_flags(priv->mgmt_tx_ant);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 9442e77..087f6c6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -87,6 +87,8 @@ MODULE_AUTHOR(DRV_COPYRIGHT " " DRV_AUTHOR);
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("iwl4965");
 
+static int iwlagn_ant_coupling;
+
 /**
  * iwl_commit_rxon - commit staging_rxon to hardware
  *
@@ -612,6 +614,33 @@ static void iwl_bg_beacon_update(struct work_struct *work)
 	iwl_send_beacon_cmd(priv);
 }
 
+static void iwl_bg_bt_full_concurrency(struct work_struct *work)
+{
+	struct iwl_priv *priv =
+		container_of(work, struct iwl_priv, bt_full_concurrency);
+
+	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
+		return;
+
+	/* dont send host command if rf-kill is on */
+	if (!iwl_is_ready_rf(priv))
+		return;
+
+	IWL_DEBUG_INFO(priv, "BT coex in %s mode\n",
+		       priv->bt_full_concurrent ?
+		       "full concurrency" : "3-wire");
+
+	/*
+	 * LQ & RXON updated cmds must be sent before BT Config cmd
+	 * to avoid 3-wire collisions
+	 */
+	if (priv->cfg->ops->hcmd->set_rxon_chain)
+		priv->cfg->ops->hcmd->set_rxon_chain(priv);
+	iwlcore_commit_rxon(priv);
+
+	priv->cfg->ops->hcmd->send_bt_config(priv);
+}
+
 /**
  * iwl_bg_statistics_periodic - Timer callback to queue statistics
  *
@@ -2771,6 +2800,8 @@ static void __iwl_down(struct iwl_priv *priv)
 	/* reset BT coex data */
 	priv->bt_traffic_load = 0;
 	priv->bt_sco_active = false;
+	priv->bt_full_concurrent = false;
+	priv->bt_ci_compliance = 0;
 
 	/* Unblock any waiting calls */
 	wake_up_interruptible_all(&priv->wait_command_queue);
@@ -3074,7 +3105,8 @@ static void iwl_bg_restart(struct work_struct *data)
 		return;
 
 	if (test_and_clear_bit(STATUS_FW_ERROR, &priv->status)) {
-		bool bt_sco;
+		bool bt_sco, bt_full_concurrent;
+		u8 bt_ci_compliance;
 		u8 bt_load;
 
 		mutex_lock(&priv->mutex);
@@ -3091,11 +3123,15 @@ static void iwl_bg_restart(struct work_struct *data)
 		 * command.
 		 */
 		bt_sco = priv->bt_sco_active;
+		bt_full_concurrent = priv->bt_full_concurrent;
+		bt_ci_compliance = priv->bt_ci_compliance;
 		bt_load = priv->bt_traffic_load;
 
 		__iwl_down(priv);
 
 		priv->bt_sco_active = bt_sco;
+		priv->bt_full_concurrent = bt_full_concurrent;
+		priv->bt_ci_compliance = bt_ci_compliance;
 		priv->bt_traffic_load = bt_load;
 
 		mutex_unlock(&priv->mutex);
@@ -3851,6 +3887,7 @@ static void iwl_setup_deferred_work(struct iwl_priv *priv)
 	INIT_WORK(&priv->beacon_update, iwl_bg_beacon_update);
 	INIT_WORK(&priv->run_time_calib_work, iwl_bg_run_time_calib_work);
 	INIT_WORK(&priv->tx_flush, iwl_bg_tx_flush);
+	INIT_WORK(&priv->bt_full_concurrency, iwl_bg_bt_full_concurrency);
 	INIT_DELAYED_WORK(&priv->init_alive_start, iwl_bg_init_alive_start);
 	INIT_DELAYED_WORK(&priv->alive_start, iwl_bg_alive_start);
 
@@ -3893,6 +3930,7 @@ static void iwl_cancel_deferred_work(struct iwl_priv *priv)
 	cancel_delayed_work(&priv->alive_start);
 	cancel_work_sync(&priv->run_time_calib_work);
 	cancel_work_sync(&priv->beacon_update);
+	cancel_work_sync(&priv->bt_full_concurrency);
 	del_timer_sync(&priv->statistics_periodic);
 	del_timer_sync(&priv->ucode_trace);
 	if (priv->cfg->ops->lib->recover_from_tx_stall)
@@ -4075,6 +4113,11 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	priv->pci_dev = pdev;
 	priv->inta_mask = CSR_INI_SET_MASK;
 
+	/* is antenna coupling more than 35dB ? */
+	priv->bt_ant_couple_ok =
+		(iwlagn_ant_coupling > IWL_BT_ANTENNA_COUPLING_THRESHOLD) ?
+		true : false;
+
 	if (iwl_alloc_traffic_mem(priv))
 		IWL_ERR(priv, "Not enough memory to generate traffic log\n");
 
@@ -4608,3 +4651,7 @@ module_param_named(ucode_alternative, iwlagn_wanted_ucode_alternative, int,
 		   S_IRUGO);
 MODULE_PARM_DESC(ucode_alternative,
 		 "specify ucode alternative to use from ucode file");
+
+module_param_named(antenna_coupling, iwlagn_ant_coupling, int, S_IRUGO);
+MODULE_PARM_DESC(antenna_coupling,
+		 "specify antenna coupling in dB (defualt: 0 dB)");
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 5e8fc72..13d2dce 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -780,6 +780,10 @@ EXPORT_SYMBOL(iwl_set_rxon_ht);
  */
 static int iwl_get_active_rx_chain_count(struct iwl_priv *priv)
 {
+	if (priv->cfg->advanced_bt_coexist && priv->bt_full_concurrent) {
+		/* operated as 1x1 in full concurrency mode */
+		return IWL_NUM_RX_CHAINS_SINGLE;
+	}
 	/* # of Rx chains to use when expecting MIMO. */
 	if (is_single_rx_stream(priv))
 		return IWL_NUM_RX_CHAINS_SINGLE;
@@ -836,11 +840,16 @@ void iwl_set_rxon_chain(struct iwl_priv *priv)
 	 * Before first association, we assume all antennas are connected.
 	 * Just after first association, iwl_chain_noise_calibration()
 	 *    checks which antennas actually *are* connected. */
-	 if (priv->chain_noise_data.active_chains)
+	if (priv->chain_noise_data.active_chains)
 		active_chains = priv->chain_noise_data.active_chains;
 	else
 		active_chains = priv->hw_params.valid_rx_ant;
 
+	if (priv->cfg->advanced_bt_coexist && priv->bt_full_concurrent) {
+		/* operated as 1x1 in full concurrency mode */
+		active_chains = first_antenna(active_chains);
+	}
+
 	rx_chain = active_chains << RXON_RX_CHAIN_VALID_POS;
 
 	/* How many receivers should we use? */
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index d773379..146d0d5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -736,5 +736,6 @@ static inline const struct ieee80211_supported_band *iwl_get_hw_mode(
 }
 
 extern bool bt_coex_active;
+extern bool bt_siso_mode;
 
 #endif /* __iwl_core_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 815ba0a..7a96d9d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1065,6 +1065,9 @@ struct iwl_event_log {
 #define IWL_LONG_MONITORING_PERIOD	(5000)
 #define IWL_ONE_HUNDRED_MSECS   (100)
 
+/* BT Antenna Coupling Threshold (dB) */
+#define IWL_BT_ANTENNA_COUPLING_THRESHOLD	(35)
+
 enum iwl_reset {
 	IWL_RF_RESET = 0,
 	IWL_FW_RESET,
@@ -1364,6 +1367,9 @@ struct iwl_priv {
 
 	u8 bt_traffic_load, notif_bt_traffic_load;
 	bool bt_sco_active;
+	bool bt_full_concurrent;
+	bool bt_ant_couple_ok;
+	u8 bt_ci_compliance;
 	struct work_struct bt_traffic_change_work;
 
 	struct iwl_hw_params hw_params;
@@ -1384,6 +1390,7 @@ struct iwl_priv {
 	struct work_struct ct_exit;
 	struct work_struct start_internal_scan;
 	struct work_struct tx_flush;
+	struct work_struct bt_full_concurrency;
 
 	struct tasklet_struct irq_tasklet;
 
-- 
1.7.0.4

