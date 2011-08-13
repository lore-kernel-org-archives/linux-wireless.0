Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:16165 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751832Ab1HMSSd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Aug 2011 14:18:33 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 10/60] iwlagn: priv->status moves to iwl_shared
Date: Sat, 13 Aug 2011 10:37:46 -0700
Message-Id: <1313257116-2697-11-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110813_201851_086223_307659E3)
In-Reply-To: <1313257116-2697-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1313257116-2697-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Since it is used by all the layers, it needs to move to iwl_shared.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c       |   14 ++--
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c      |   10 ++--
 drivers/net/wireless/iwlwifi/iwl-agn-tt.c        |   32 +++++----
 drivers/net/wireless/iwlwifi/iwl-agn.c           |   75 +++++++++++----------
 drivers/net/wireless/iwlwifi/iwl-core.c          |   39 ++++++------
 drivers/net/wireless/iwlwifi/iwl-core.h          |   14 ++--
 drivers/net/wireless/iwlwifi/iwl-debugfs.c       |   34 +++++-----
 drivers/net/wireless/iwlwifi/iwl-dev.h           |    2 -
 drivers/net/wireless/iwlwifi/iwl-helpers.h       |    4 +-
 drivers/net/wireless/iwlwifi/iwl-led.c           |    2 +-
 drivers/net/wireless/iwlwifi/iwl-power.c         |    6 +-
 drivers/net/wireless/iwlwifi/iwl-rx.c            |   22 +++---
 drivers/net/wireless/iwlwifi/iwl-scan.c          |   44 ++++++------
 drivers/net/wireless/iwlwifi/iwl-shared.h        |    2 +
 drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c |   21 +++---
 drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c |   22 +++---
 drivers/net/wireless/iwlwifi/iwl-trans.c         |    8 +-
 17 files changed, 179 insertions(+), 172 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 355a81c..7c3e3ea 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -387,7 +387,7 @@ void iwl_check_abort_status(struct iwl_priv *priv,
 {
 	if (frame_count == 1 && status == TX_STATUS_FAIL_RFKILL_FLUSH) {
 		IWL_ERR(priv, "Tx flush command to flush out all frames\n");
-		if (!test_bit(STATUS_EXIT_PENDING, &priv->status))
+		if (!test_bit(STATUS_EXIT_PENDING, &priv->shrd->status))
 			queue_work(priv->shrd->workqueue, &priv->tx_flush);
 	}
 }
@@ -496,7 +496,7 @@ int iwlagn_send_tx_power(struct iwl_priv *priv)
 	struct iwlagn_tx_power_dbm_cmd tx_power_cmd;
 	u8 tx_ant_cfg_cmd;
 
-	if (WARN_ONCE(test_bit(STATUS_SCAN_HW, &priv->status),
+	if (WARN_ONCE(test_bit(STATUS_SCAN_HW, &priv->shrd->status),
 		      "TX Power requested while scanning!\n"))
 		return -EAGAIN;
 
@@ -945,7 +945,7 @@ int iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 	scan->tx_cmd.rate_n_flags = iwl_hw_set_rate_n_flags(rate, rate_flags);
 
 	/* In power save mode use one chain, otherwise use all chains */
-	if (test_bit(STATUS_POWER_PMI, &priv->status)) {
+	if (test_bit(STATUS_POWER_PMI, &priv->shrd->status)) {
 		/* rx_ant has been set to all valid chains previously */
 		active_chains = rx_ant &
 				((u8)(priv->chain_noise_data.active_chains));
@@ -1048,7 +1048,7 @@ int iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 	scan->len = cpu_to_le16(cmd.len[0]);
 
 	/* set scan bit here for PAN params */
-	set_bit(STATUS_SCAN_HW, &priv->status);
+	set_bit(STATUS_SCAN_HW, &priv->shrd->status);
 
 	ret = iwlagn_set_pan_params(priv);
 	if (ret)
@@ -1056,7 +1056,7 @@ int iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 
 	ret = trans_send_cmd(&priv->trans, &cmd);
 	if (ret) {
-		clear_bit(STATUS_SCAN_HW, &priv->status);
+		clear_bit(STATUS_SCAN_HW, &priv->shrd->status);
 		iwlagn_set_pan_params(priv);
 	}
 
@@ -1494,7 +1494,7 @@ static void iwlagn_bt_traffic_change_work(struct work_struct *work)
 	 * STATUS_SCANNING to avoid race when queue_work two times from
 	 * different notifications, but quit and not perform any work at all.
 	 */
-	if (test_bit(STATUS_SCAN_HW, &priv->status))
+	if (test_bit(STATUS_SCAN_HW, &priv->shrd->status))
 		goto out;
 
 	iwl_update_chain_flags(priv);
@@ -1775,7 +1775,7 @@ static u8 iwl_count_chain_bitmap(u32 chain_bitmap)
 void iwlagn_set_rxon_chain(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 {
 	bool is_single = is_single_rx_stream(priv);
-	bool is_cam = !test_bit(STATUS_POWER_PMI, &priv->status);
+	bool is_cam = !test_bit(STATUS_POWER_PMI, &priv->shrd->status);
 	u8 idle_rx_cnt, active_rx_cnt, valid_rx_cnt;
 	u32 active_chains;
 	u16 rx_chain;
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
index ea13489..1a6e6ac 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
@@ -363,7 +363,7 @@ int iwlagn_set_pan_params(struct iwl_priv *priv)
 		slot0 = bcnint / 2;
 		slot1 = bcnint - slot0;
 
-		if (test_bit(STATUS_SCAN_HW, &priv->status) ||
+		if (test_bit(STATUS_SCAN_HW, &priv->shrd->status) ||
 		    (!ctx_bss->vif->bss_conf.idle &&
 		     !ctx_bss->vif->bss_conf.assoc)) {
 			slot0 = dtim * bcnint * 3 - IWL_MIN_SLOT_TIME;
@@ -379,7 +379,7 @@ int iwlagn_set_pan_params(struct iwl_priv *priv)
 					ctx_pan->beacon_int;
 		slot1 = max_t(int, DEFAULT_BEACON_INTERVAL, slot1);
 
-		if (test_bit(STATUS_SCAN_HW, &priv->status)) {
+		if (test_bit(STATUS_SCAN_HW, &priv->shrd->status)) {
 			slot0 = slot1 * 3 - IWL_MIN_SLOT_TIME;
 			slot1 = IWL_MIN_SLOT_TIME;
 		}
@@ -423,7 +423,7 @@ int iwlagn_commit_rxon(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 
 	lockdep_assert_held(&priv->mutex);
 
-	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
+	if (test_bit(STATUS_EXIT_PENDING, &priv->shrd->status))
 		return -EINVAL;
 
 	if (!iwl_is_alive(priv))
@@ -467,7 +467,7 @@ int iwlagn_commit_rxon(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 	 * receive commit_rxon request
 	 * abort any previous channel switch if still in process
 	 */
-	if (test_bit(STATUS_CHANNEL_SWITCH_PENDING, &priv->status) &&
+	if (test_bit(STATUS_CHANNEL_SWITCH_PENDING, &priv->shrd->status) &&
 	    (priv->switch_channel != ctx->staging.channel)) {
 		IWL_DEBUG_11H(priv, "abort channel switch on %d\n",
 			      le16_to_cpu(priv->switch_channel));
@@ -543,7 +543,7 @@ int iwlagn_mac_config(struct ieee80211_hw *hw, u32 changed)
 
 	mutex_lock(&priv->mutex);
 
-	if (unlikely(test_bit(STATUS_SCANNING, &priv->status))) {
+	if (unlikely(test_bit(STATUS_SCANNING, &priv->shrd->status))) {
 		IWL_DEBUG_MAC80211(priv, "leave - scanning\n");
 		goto out;
 	}
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tt.c b/drivers/net/wireless/iwlwifi/iwl-agn-tt.c
index 2c5558a..44fff5b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tt.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tt.c
@@ -176,7 +176,7 @@ static void iwl_tt_check_exit_ct_kill(unsigned long data)
 	struct iwl_tt_mgmt *tt = &priv->thermal_throttle;
 	unsigned long flags;
 
-	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
+	if (test_bit(STATUS_EXIT_PENDING, &priv->shrd->status))
 		return;
 
 	if (tt->state == IWL_TI_CT_KILL) {
@@ -227,7 +227,7 @@ static void iwl_tt_ready_for_ct_kill(unsigned long data)
 	struct iwl_priv *priv = (struct iwl_priv *)data;
 	struct iwl_tt_mgmt *tt = &priv->thermal_throttle;
 
-	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
+	if (test_bit(STATUS_EXIT_PENDING, &priv->shrd->status))
 		return;
 
 	/* temperature timer expired, ready to go into CT_KILL state */
@@ -235,7 +235,7 @@ static void iwl_tt_ready_for_ct_kill(unsigned long data)
 		IWL_DEBUG_TEMP(priv, "entering CT_KILL state when "
 				"temperature timer expired\n");
 		tt->state = IWL_TI_CT_KILL;
-		set_bit(STATUS_CT_KILL, &priv->status);
+		set_bit(STATUS_CT_KILL, &priv->shrd->status);
 		iwl_perform_ct_kill_task(priv, true);
 	}
 }
@@ -315,21 +315,22 @@ static void iwl_legacy_tt_handler(struct iwl_priv *priv, s32 temp, bool force)
 		}
 		mutex_lock(&priv->mutex);
 		if (old_state == IWL_TI_CT_KILL)
-			clear_bit(STATUS_CT_KILL, &priv->status);
+			clear_bit(STATUS_CT_KILL, &priv->shrd->status);
 		if (tt->state != IWL_TI_CT_KILL &&
 		    iwl_power_update_mode(priv, true)) {
 			/* TT state not updated
 			 * try again during next temperature read
 			 */
 			if (old_state == IWL_TI_CT_KILL)
-				set_bit(STATUS_CT_KILL, &priv->status);
+				set_bit(STATUS_CT_KILL, &priv->shrd->status);
 			tt->state = old_state;
 			IWL_ERR(priv, "Cannot update power mode, "
 					"TT state not updated\n");
 		} else {
 			if (tt->state == IWL_TI_CT_KILL) {
 				if (force) {
-					set_bit(STATUS_CT_KILL, &priv->status);
+					set_bit(STATUS_CT_KILL,
+						&priv->shrd->status);
 					iwl_perform_ct_kill_task(priv, true);
 				} else {
 					iwl_prepare_ct_kill_task(priv);
@@ -455,7 +456,7 @@ static void iwl_advance_tt_handler(struct iwl_priv *priv, s32 temp, bool force)
 		}
 		mutex_lock(&priv->mutex);
 		if (old_state == IWL_TI_CT_KILL)
-			clear_bit(STATUS_CT_KILL, &priv->status);
+			clear_bit(STATUS_CT_KILL, &priv->shrd->status);
 		if (tt->state != IWL_TI_CT_KILL &&
 		    iwl_power_update_mode(priv, true)) {
 			/* TT state not updated
@@ -464,7 +465,7 @@ static void iwl_advance_tt_handler(struct iwl_priv *priv, s32 temp, bool force)
 			IWL_ERR(priv, "Cannot update power mode, "
 					"TT state not updated\n");
 			if (old_state == IWL_TI_CT_KILL)
-				set_bit(STATUS_CT_KILL, &priv->status);
+				set_bit(STATUS_CT_KILL, &priv->shrd->status);
 			tt->state = old_state;
 		} else {
 			IWL_DEBUG_TEMP(priv,
@@ -475,7 +476,8 @@ static void iwl_advance_tt_handler(struct iwl_priv *priv, s32 temp, bool force)
 				if (force) {
 					IWL_DEBUG_TEMP(priv,
 						"Enter IWL_TI_CT_KILL\n");
-					set_bit(STATUS_CT_KILL, &priv->status);
+					set_bit(STATUS_CT_KILL,
+						&priv->shrd->status);
 					iwl_perform_ct_kill_task(priv, true);
 				} else {
 					iwl_prepare_ct_kill_task(priv);
@@ -506,7 +508,7 @@ static void iwl_bg_ct_enter(struct work_struct *work)
 	struct iwl_priv *priv = container_of(work, struct iwl_priv, ct_enter);
 	struct iwl_tt_mgmt *tt = &priv->thermal_throttle;
 
-	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
+	if (test_bit(STATUS_EXIT_PENDING, &priv->shrd->status))
 		return;
 
 	if (!iwl_is_ready(priv))
@@ -535,7 +537,7 @@ static void iwl_bg_ct_exit(struct work_struct *work)
 	struct iwl_priv *priv = container_of(work, struct iwl_priv, ct_exit);
 	struct iwl_tt_mgmt *tt = &priv->thermal_throttle;
 
-	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
+	if (test_bit(STATUS_EXIT_PENDING, &priv->shrd->status))
 		return;
 
 	if (!iwl_is_ready(priv))
@@ -565,7 +567,7 @@ static void iwl_bg_ct_exit(struct work_struct *work)
 
 void iwl_tt_enter_ct_kill(struct iwl_priv *priv)
 {
-	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
+	if (test_bit(STATUS_EXIT_PENDING, &priv->shrd->status))
 		return;
 
 	IWL_DEBUG_TEMP(priv, "Queueing critical temperature enter.\n");
@@ -574,7 +576,7 @@ void iwl_tt_enter_ct_kill(struct iwl_priv *priv)
 
 void iwl_tt_exit_ct_kill(struct iwl_priv *priv)
 {
-	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
+	if (test_bit(STATUS_EXIT_PENDING, &priv->shrd->status))
 		return;
 
 	IWL_DEBUG_TEMP(priv, "Queueing critical temperature exit.\n");
@@ -586,7 +588,7 @@ static void iwl_bg_tt_work(struct work_struct *work)
 	struct iwl_priv *priv = container_of(work, struct iwl_priv, tt_work);
 	s32 temp = priv->temperature; /* degrees CELSIUS except specified */
 
-	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
+	if (test_bit(STATUS_EXIT_PENDING, &priv->shrd->status))
 		return;
 
 	if (priv->cfg->base_params->temperature_kelvin)
@@ -600,7 +602,7 @@ static void iwl_bg_tt_work(struct work_struct *work)
 
 void iwl_tt_handler(struct iwl_priv *priv)
 {
-	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
+	if (test_bit(STATUS_EXIT_PENDING, &priv->shrd->status))
 		return;
 
 	IWL_DEBUG_TEMP(priv, "Queueing thermal throttling work.\n");
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 3523364..a0c04f7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -248,7 +248,7 @@ static void iwl_bg_bt_runtime_config(struct work_struct *work)
 	struct iwl_priv *priv =
 		container_of(work, struct iwl_priv, bt_runtime_config);
 
-	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
+	if (test_bit(STATUS_EXIT_PENDING, &priv->shrd->status))
 		return;
 
 	/* dont send host command if rf-kill is on */
@@ -265,7 +265,7 @@ static void iwl_bg_bt_full_concurrency(struct work_struct *work)
 
 	mutex_lock(&priv->mutex);
 
-	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
+	if (test_bit(STATUS_EXIT_PENDING, &priv->shrd->status))
 		goto out;
 
 	/* dont send host command if rf-kill is on */
@@ -304,7 +304,7 @@ static void iwl_bg_statistics_periodic(unsigned long data)
 {
 	struct iwl_priv *priv = (struct iwl_priv *)data;
 
-	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
+	if (test_bit(STATUS_EXIT_PENDING, &priv->shrd->status))
 		return;
 
 	/* dont send host command if rf-kill is on */
@@ -425,7 +425,7 @@ static void iwl_bg_ucode_trace(unsigned long data)
 {
 	struct iwl_priv *priv = (struct iwl_priv *)data;
 
-	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
+	if (test_bit(STATUS_EXIT_PENDING, &priv->shrd->status))
 		return;
 
 	if (priv->event_log.ucode_trace) {
@@ -441,7 +441,7 @@ static void iwl_bg_tx_flush(struct work_struct *work)
 	struct iwl_priv *priv =
 		container_of(work, struct iwl_priv, tx_flush);
 
-	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
+	if (test_bit(STATUS_EXIT_PENDING, &priv->shrd->status))
 		return;
 
 	/* do nothing if rf-kill is on */
@@ -1406,7 +1406,7 @@ void iwl_dump_nic_error_log(struct iwl_priv *priv)
 	if (ERROR_START_OFFSET <= table.valid * ERROR_ELEM_SIZE) {
 		IWL_ERR(priv, "Start IWL Error Log Dump:\n");
 		IWL_ERR(priv, "Status: 0x%08lX, count: %d\n",
-			priv->status, table.valid);
+			priv->shrd->status, table.valid);
 	}
 
 	priv->isr_stats.err_code = table.error_id;
@@ -1766,7 +1766,7 @@ int iwl_alive_start(struct iwl_priv *priv)
 	IWL_DEBUG_INFO(priv, "Runtime Alive received.\n");
 
 	/* After the ALIVE response, we can send host commands to the uCode */
-	set_bit(STATUS_ALIVE, &priv->status);
+	set_bit(STATUS_ALIVE, &priv->shrd->status);
 
 	/* Enable watchdog to monitor the driver tx queues */
 	iwl_setup_watchdog(priv);
@@ -1839,7 +1839,7 @@ int iwl_alive_start(struct iwl_priv *priv)
 		iwl_reset_run_time_calib(priv);
 	}
 
-	set_bit(STATUS_READY, &priv->status);
+	set_bit(STATUS_READY, &priv->shrd->status);
 
 	/* Configure the adapter for unassociated operation */
 	ret = iwlagn_commit_rxon(priv, ctx);
@@ -1871,7 +1871,8 @@ static void __iwl_down(struct iwl_priv *priv)
 	 */
 	ieee80211_remain_on_channel_expired(priv->hw);
 
-	exit_pending = test_and_set_bit(STATUS_EXIT_PENDING, &priv->status);
+	exit_pending =
+		test_and_set_bit(STATUS_EXIT_PENDING, &priv->shrd->status);
 
 	/* Stop TX queues watchdog. We need to have STATUS_EXIT_PENDING bit set
 	 * to prevent rearm timer */
@@ -1896,19 +1897,20 @@ static void __iwl_down(struct iwl_priv *priv)
 	/* Wipe out the EXIT_PENDING status bit if we are not actually
 	 * exiting the module */
 	if (!exit_pending)
-		clear_bit(STATUS_EXIT_PENDING, &priv->status);
+		clear_bit(STATUS_EXIT_PENDING, &priv->shrd->status);
 
 	if (priv->mac80211_registered)
 		ieee80211_stop_queues(priv->hw);
 
 	/* Clear out all status bits but a few that are stable across reset */
-	priv->status &= test_bit(STATUS_RF_KILL_HW, &priv->status) <<
+	priv->shrd->status &=
+			test_bit(STATUS_RF_KILL_HW, &priv->shrd->status) <<
 				STATUS_RF_KILL_HW |
-			test_bit(STATUS_GEO_CONFIGURED, &priv->status) <<
+			test_bit(STATUS_GEO_CONFIGURED, &priv->shrd->status) <<
 				STATUS_GEO_CONFIGURED |
-			test_bit(STATUS_FW_ERROR, &priv->status) <<
+			test_bit(STATUS_FW_ERROR, &priv->shrd->status) <<
 				STATUS_FW_ERROR |
-		       test_bit(STATUS_EXIT_PENDING, &priv->status) <<
+			test_bit(STATUS_EXIT_PENDING, &priv->shrd->status) <<
 				STATUS_EXIT_PENDING;
 
 	trans_stop_device(&priv->trans);
@@ -1935,7 +1937,7 @@ static int __iwl_up(struct iwl_priv *priv)
 
 	lockdep_assert_held(&priv->mutex);
 
-	if (test_bit(STATUS_EXIT_PENDING, &priv->status)) {
+	if (test_bit(STATUS_EXIT_PENDING, &priv->shrd->status)) {
 		IWL_WARN(priv, "Exit pending; will not bring the NIC up\n");
 		return -EIO;
 	}
@@ -1968,9 +1970,9 @@ static int __iwl_up(struct iwl_priv *priv)
 	return 0;
 
  error:
-	set_bit(STATUS_EXIT_PENDING, &priv->status);
+	set_bit(STATUS_EXIT_PENDING, &priv->shrd->status);
 	__iwl_down(priv);
-	clear_bit(STATUS_EXIT_PENDING, &priv->status);
+	clear_bit(STATUS_EXIT_PENDING, &priv->shrd->status);
 
 	IWL_ERR(priv, "Unable to initialize device.\n");
 	return ret;
@@ -1990,8 +1992,8 @@ static void iwl_bg_run_time_calib_work(struct work_struct *work)
 
 	mutex_lock(&priv->mutex);
 
-	if (test_bit(STATUS_EXIT_PENDING, &priv->status) ||
-	    test_bit(STATUS_SCANNING, &priv->status)) {
+	if (test_bit(STATUS_EXIT_PENDING, &priv->shrd->status) ||
+	    test_bit(STATUS_SCANNING, &priv->shrd->status)) {
 		mutex_unlock(&priv->mutex);
 		return;
 	}
@@ -2047,10 +2049,10 @@ static void iwl_bg_restart(struct work_struct *data)
 {
 	struct iwl_priv *priv = container_of(data, struct iwl_priv, restart);
 
-	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
+	if (test_bit(STATUS_EXIT_PENDING, &priv->shrd->status))
 		return;
 
-	if (test_and_clear_bit(STATUS_FW_ERROR, &priv->status)) {
+	if (test_and_clear_bit(STATUS_FW_ERROR, &priv->shrd->status)) {
 		mutex_lock(&priv->mutex);
 		iwlagn_prepare_restart(priv);
 		mutex_unlock(&priv->mutex);
@@ -2264,7 +2266,7 @@ static int iwlagn_mac_start(struct ieee80211_hw *hw)
 	IWL_DEBUG_INFO(priv, "Start UP work done.\n");
 
 	/* Now we should be done, and the READY bit should be set. */
-	if (WARN_ON(!test_bit(STATUS_READY, &priv->status)))
+	if (WARN_ON(!test_bit(STATUS_READY, &priv->shrd->status)))
 		ret = -EIO;
 
 	iwlagn_led_enable(priv);
@@ -2902,7 +2904,7 @@ static int iwlagn_mac_ampdu_action(struct ieee80211_hw *hw,
 	case IEEE80211_AMPDU_RX_STOP:
 		IWL_DEBUG_HT(priv, "stop Rx\n");
 		ret = iwl_sta_rx_agg_stop(priv, sta, tid);
-		if (test_bit(STATUS_EXIT_PENDING, &priv->status))
+		if (test_bit(STATUS_EXIT_PENDING, &priv->shrd->status))
 			ret = 0;
 		break;
 	case IEEE80211_AMPDU_TX_START:
@@ -2922,7 +2924,7 @@ static int iwlagn_mac_ampdu_action(struct ieee80211_hw *hw,
 			IWL_DEBUG_HT(priv, "priv->agg_tids_count = %u\n",
 				     priv->agg_tids_count);
 		}
-		if (test_bit(STATUS_EXIT_PENDING, &priv->status))
+		if (test_bit(STATUS_EXIT_PENDING, &priv->shrd->status))
 			ret = 0;
 		if (priv->cfg->ht_params &&
 		    priv->cfg->ht_params->use_rts_for_aggregation) {
@@ -3057,9 +3059,9 @@ static void iwlagn_mac_channel_switch(struct ieee80211_hw *hw,
 	if (iwl_is_rfkill(priv))
 		goto out;
 
-	if (test_bit(STATUS_EXIT_PENDING, &priv->status) ||
-	    test_bit(STATUS_SCANNING, &priv->status) ||
-	    test_bit(STATUS_CHANNEL_SWITCH_PENDING, &priv->status))
+	if (test_bit(STATUS_EXIT_PENDING, &priv->shrd->status) ||
+	    test_bit(STATUS_SCANNING, &priv->shrd->status) ||
+	    test_bit(STATUS_CHANNEL_SWITCH_PENDING, &priv->shrd->status))
 		goto out;
 
 	if (!iwl_is_associated_ctx(ctx))
@@ -3115,10 +3117,10 @@ static void iwlagn_mac_channel_switch(struct ieee80211_hw *hw,
 	 * at this point, staging_rxon has the
 	 * configuration for channel switch
 	 */
-	set_bit(STATUS_CHANNEL_SWITCH_PENDING, &priv->status);
+	set_bit(STATUS_CHANNEL_SWITCH_PENDING, &priv->shrd->status);
 	priv->switch_channel = cpu_to_le16(ch);
 	if (priv->cfg->lib->set_channel_switch(priv, ch_switch)) {
-		clear_bit(STATUS_CHANNEL_SWITCH_PENDING, &priv->status);
+		clear_bit(STATUS_CHANNEL_SWITCH_PENDING, &priv->shrd->status);
 		priv->switch_channel = 0;
 		ieee80211_chswitch_done(ctx->vif, false);
 	}
@@ -3185,7 +3187,7 @@ static void iwlagn_mac_flush(struct ieee80211_hw *hw, bool drop)
 	mutex_lock(&priv->mutex);
 	IWL_DEBUG_MAC80211(priv, "enter\n");
 
-	if (test_bit(STATUS_EXIT_PENDING, &priv->status)) {
+	if (test_bit(STATUS_EXIT_PENDING, &priv->shrd->status)) {
 		IWL_DEBUG_TX(priv, "Aborting flush due to device shutdown\n");
 		goto done;
 	}
@@ -3270,7 +3272,7 @@ static int iwl_mac_remain_on_channel(struct ieee80211_hw *hw,
 	if (iwl_is_associated(priv, IWL_RXON_CTX_BSS) && duration > 80)
 		duration = 80;
 
-	if (test_bit(STATUS_SCAN_HW, &priv->status)) {
+	if (test_bit(STATUS_SCAN_HW, &priv->shrd->status)) {
 		err = -EBUSY;
 		goto out;
 	}
@@ -3345,7 +3347,8 @@ static int iwl_mac_tx_sync(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		goto out;
 	}
 
-	if (ctx->preauth_bssid || test_bit(STATUS_SCAN_HW, &priv->shrd->status)) {
+	if (ctx->preauth_bssid ||
+	    test_bit(STATUS_SCAN_HW, &priv->shrd->status)) {
 		ret = -EBUSY;
 		goto out;
 	}
@@ -3790,12 +3793,12 @@ int iwl_probe(struct iwl_bus *bus, struct iwl_cfg *cfg)
 
 	/* If platform's RF_KILL switch is NOT set to KILL */
 	if (iwl_read32(priv, CSR_GP_CNTRL) & CSR_GP_CNTRL_REG_FLAG_HW_RF_KILL_SW)
-		clear_bit(STATUS_RF_KILL_HW, &priv->status);
+		clear_bit(STATUS_RF_KILL_HW, &priv->shrd->status);
 	else
-		set_bit(STATUS_RF_KILL_HW, &priv->status);
+		set_bit(STATUS_RF_KILL_HW, &priv->shrd->status);
 
 	wiphy_rfkill_set_hw_state(priv->hw->wiphy,
-		test_bit(STATUS_RF_KILL_HW, &priv->status));
+		test_bit(STATUS_RF_KILL_HW, &priv->shrd->status));
 
 	iwl_power_initialize(priv);
 	iwl_tt_initialize(priv);
@@ -3839,7 +3842,7 @@ void __devexit iwl_remove(struct iwl_priv * priv)
 	 * to be called and iwl_down since we are removing the device
 	 * we need to set STATUS_EXIT_PENDING bit.
 	 */
-	set_bit(STATUS_EXIT_PENDING, &priv->status);
+	set_bit(STATUS_EXIT_PENDING, &priv->shrd->status);
 
 	iwl_testmode_cleanup(priv);
 	iwl_leds_exit(priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index b62ccd7..a5a694d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -121,7 +121,7 @@ int iwl_init_geos(struct iwl_priv *priv)
 	if (priv->bands[IEEE80211_BAND_2GHZ].n_bitrates ||
 	    priv->bands[IEEE80211_BAND_5GHZ].n_bitrates) {
 		IWL_DEBUG_INFO(priv, "Geography modes already initialized.\n");
-		set_bit(STATUS_GEO_CONFIGURED, &priv->status);
+		set_bit(STATUS_GEO_CONFIGURED, &priv->shrd->status);
 		return 0;
 	}
 
@@ -221,7 +221,7 @@ int iwl_init_geos(struct iwl_priv *priv)
 		   priv->bands[IEEE80211_BAND_2GHZ].n_channels,
 		   priv->bands[IEEE80211_BAND_5GHZ].n_channels);
 
-	set_bit(STATUS_GEO_CONFIGURED, &priv->status);
+	set_bit(STATUS_GEO_CONFIGURED, &priv->shrd->status);
 
 	return 0;
 }
@@ -233,7 +233,7 @@ void iwl_free_geos(struct iwl_priv *priv)
 {
 	kfree(priv->ieee_channels);
 	kfree(priv->ieee_rates);
-	clear_bit(STATUS_GEO_CONFIGURED, &priv->status);
+	clear_bit(STATUS_GEO_CONFIGURED, &priv->shrd->status);
 }
 
 static bool iwl_is_channel_extension(struct iwl_priv *priv,
@@ -808,10 +808,11 @@ void iwl_chswitch_done(struct iwl_priv *priv, bool is_success)
 	 */
 	struct iwl_rxon_context *ctx = &priv->contexts[IWL_RXON_CTX_BSS];
 
-	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
+	if (test_bit(STATUS_EXIT_PENDING, &priv->shrd->status))
 		return;
 
-	if (test_and_clear_bit(STATUS_CHANNEL_SWITCH_PENDING, &priv->status))
+	if (test_and_clear_bit(STATUS_CHANNEL_SWITCH_PENDING,
+				&priv->shrd->status))
 		ieee80211_chswitch_done(ctx->vif, is_success);
 }
 
@@ -856,16 +857,16 @@ void iwlagn_fw_error(struct iwl_priv *priv, bool ondemand)
 	unsigned long reload_jiffies;
 
 	/* Set the FW error flag -- cleared on iwl_down */
-	set_bit(STATUS_FW_ERROR, &priv->status);
+	set_bit(STATUS_FW_ERROR, &priv->shrd->status);
 
 	/* Cancel currently queued command. */
-	clear_bit(STATUS_HCMD_ACTIVE, &priv->status);
+	clear_bit(STATUS_HCMD_ACTIVE, &priv->shrd->status);
 
 	iwlagn_abort_notification_waits(priv);
 
 	/* Keep the restart process from trying to send host
 	 * commands by clearing the ready bit */
-	clear_bit(STATUS_READY, &priv->status);
+	clear_bit(STATUS_READY, &priv->shrd->status);
 
 	wake_up_interruptible(&priv->wait_command_queue);
 
@@ -890,7 +891,7 @@ void iwlagn_fw_error(struct iwl_priv *priv, bool ondemand)
 			priv->reload_count = 0;
 	}
 
-	if (!test_bit(STATUS_EXIT_PENDING, &priv->status)) {
+	if (!test_bit(STATUS_EXIT_PENDING, &priv->shrd->status)) {
 		if (iwlagn_mod_params.restart_fw) {
 			IWL_DEBUG(priv, IWL_DL_FW_ERRORS,
 				  "Restarting adapter due to uCode error.\n");
@@ -916,8 +917,8 @@ void iwl_irq_handle_error(struct iwl_priv *priv)
 		 * Keep the restart process from trying to send host
 		 * commands by clearing the ready bit.
 		 */
-		clear_bit(STATUS_READY, &priv->status);
-		clear_bit(STATUS_HCMD_ACTIVE, &priv->status);
+		clear_bit(STATUS_READY, &priv->shrd->status);
+		clear_bit(STATUS_HCMD_ACTIVE, &priv->shrd->status);
 		wake_up_interruptible(&priv->wait_command_queue);
 		IWL_ERR(priv, "RF is used by WiMAX\n");
 		return;
@@ -960,7 +961,7 @@ void iwl_apm_stop(struct iwl_priv *priv)
 {
 	IWL_DEBUG_INFO(priv, "Stop card, put in low power state\n");
 
-	clear_bit(STATUS_DEVICE_ENABLED, &priv->status);
+	clear_bit(STATUS_DEVICE_ENABLED, &priv->shrd->status);
 
 	/* Stop device's DMA activity */
 	iwl_apm_stop_master(priv);
@@ -1054,7 +1055,7 @@ int iwl_apm_init(struct iwl_priv *priv)
 	iwl_set_bits_prph(priv, APMG_PCIDEV_STT_REG,
 			  APMG_PCIDEV_STT_VAL_L1_ACT_DIS);
 
-	set_bit(STATUS_DEVICE_ENABLED, &priv->status);
+	set_bit(STATUS_DEVICE_ENABLED, &priv->shrd->status);
 
 out:
 	return ret;
@@ -1096,7 +1097,7 @@ int iwl_set_tx_power(struct iwl_priv *priv, s8 tx_power, bool force)
 	priv->tx_power_next = tx_power;
 
 	/* do not set tx power when scanning or channel changing */
-	defer = test_bit(STATUS_SCANNING, &priv->status) ||
+	defer = test_bit(STATUS_SCANNING, &priv->shrd->status) ||
 		memcmp(&ctx->active, &ctx->staging, sizeof(ctx->staging));
 	if (defer && !force) {
 		IWL_DEBUG_INFO(priv, "Deferring tx power set\n");
@@ -1613,7 +1614,7 @@ void iwl_update_stats(struct iwl_priv *priv, bool is_tx, __le16 fc, u16 len)
 
 static void iwl_force_rf_reset(struct iwl_priv *priv)
 {
-	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
+	if (test_bit(STATUS_EXIT_PENDING, &priv->shrd->status))
 		return;
 
 	if (!iwl_is_any_associated(priv)) {
@@ -1638,7 +1639,7 @@ int iwl_force_reset(struct iwl_priv *priv, int mode, bool external)
 {
 	struct iwl_force_reset *force_reset;
 
-	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
+	if (test_bit(STATUS_EXIT_PENDING, &priv->shrd->status))
 		return -EINVAL;
 
 	if (mode >= IWL_MAX_FORCE_RESET) {
@@ -1810,7 +1811,7 @@ void iwl_bg_watchdog(unsigned long data)
 	int cnt;
 	unsigned long timeout;
 
-	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
+	if (test_bit(STATUS_EXIT_PENDING, &priv->shrd->status))
 		return;
 
 	timeout = priv->cfg->base_params->wd_timeout;
@@ -1930,9 +1931,9 @@ int iwl_resume(struct iwl_priv *priv)
 		hw_rfkill = true;
 
 	if (hw_rfkill)
-		set_bit(STATUS_RF_KILL_HW, &priv->status);
+		set_bit(STATUS_RF_KILL_HW, &priv->shrd->status);
 	else
-		clear_bit(STATUS_RF_KILL_HW, &priv->status);
+		clear_bit(STATUS_RF_KILL_HW, &priv->shrd->status);
 
 	wiphy_rfkill_set_hw_state(priv->hw->wiphy, hw_rfkill);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index e63de03..c2e02a4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -424,24 +424,24 @@ static inline int iwl_is_ready(struct iwl_priv *priv)
 {
 	/* The adapter is 'ready' if READY and GEO_CONFIGURED bits are
 	 * set but EXIT_PENDING is not */
-	return test_bit(STATUS_READY, &priv->status) &&
-	       test_bit(STATUS_GEO_CONFIGURED, &priv->status) &&
-	       !test_bit(STATUS_EXIT_PENDING, &priv->status);
+	return test_bit(STATUS_READY, &priv->shrd->status) &&
+	       test_bit(STATUS_GEO_CONFIGURED, &priv->shrd->status) &&
+	       !test_bit(STATUS_EXIT_PENDING, &priv->shrd->status);
 }
 
 static inline int iwl_is_alive(struct iwl_priv *priv)
 {
-	return test_bit(STATUS_ALIVE, &priv->status);
+	return test_bit(STATUS_ALIVE, &priv->shrd->status);
 }
 
 static inline int iwl_is_init(struct iwl_priv *priv)
 {
-	return test_bit(STATUS_INIT, &priv->status);
+	return test_bit(STATUS_INIT, &priv->shrd->status);
 }
 
 static inline int iwl_is_rfkill_hw(struct iwl_priv *priv)
 {
-	return test_bit(STATUS_RF_KILL_HW, &priv->status);
+	return test_bit(STATUS_RF_KILL_HW, &priv->shrd->status);
 }
 
 static inline int iwl_is_rfkill(struct iwl_priv *priv)
@@ -451,7 +451,7 @@ static inline int iwl_is_rfkill(struct iwl_priv *priv)
 
 static inline int iwl_is_ctkill(struct iwl_priv *priv)
 {
-	return test_bit(STATUS_CT_KILL, &priv->status);
+	return test_bit(STATUS_CT_KILL, &priv->shrd->status);
 }
 
 static inline int iwl_is_ready_rf(struct iwl_priv *priv)
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index 43543e5..8bd8177 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -492,7 +492,7 @@ static ssize_t iwl_dbgfs_channels_read(struct file *file, char __user *user_buf,
 	char *buf;
 	ssize_t ret;
 
-	if (!test_bit(STATUS_GEO_CONFIGURED, &priv->status))
+	if (!test_bit(STATUS_GEO_CONFIGURED, &priv->shrd->status))
 		return -EAGAIN;
 
 	buf = kzalloc(bufsz, GFP_KERNEL);
@@ -562,37 +562,37 @@ static ssize_t iwl_dbgfs_status_read(struct file *file,
 	const size_t bufsz = sizeof(buf);
 
 	pos += scnprintf(buf + pos, bufsz - pos, "STATUS_HCMD_ACTIVE:\t %d\n",
-		test_bit(STATUS_HCMD_ACTIVE, &priv->status));
+		test_bit(STATUS_HCMD_ACTIVE, &priv->shrd->status));
 	pos += scnprintf(buf + pos, bufsz - pos, "STATUS_INT_ENABLED:\t %d\n",
-		test_bit(STATUS_INT_ENABLED, &priv->status));
+		test_bit(STATUS_INT_ENABLED, &priv->shrd->status));
 	pos += scnprintf(buf + pos, bufsz - pos, "STATUS_RF_KILL_HW:\t %d\n",
-		test_bit(STATUS_RF_KILL_HW, &priv->status));
+		test_bit(STATUS_RF_KILL_HW, &priv->shrd->status));
 	pos += scnprintf(buf + pos, bufsz - pos, "STATUS_CT_KILL:\t\t %d\n",
-		test_bit(STATUS_CT_KILL, &priv->status));
+		test_bit(STATUS_CT_KILL, &priv->shrd->status));
 	pos += scnprintf(buf + pos, bufsz - pos, "STATUS_INIT:\t\t %d\n",
-		test_bit(STATUS_INIT, &priv->status));
+		test_bit(STATUS_INIT, &priv->shrd->status));
 	pos += scnprintf(buf + pos, bufsz - pos, "STATUS_ALIVE:\t\t %d\n",
-		test_bit(STATUS_ALIVE, &priv->status));
+		test_bit(STATUS_ALIVE, &priv->shrd->status));
 	pos += scnprintf(buf + pos, bufsz - pos, "STATUS_READY:\t\t %d\n",
-		test_bit(STATUS_READY, &priv->status));
+		test_bit(STATUS_READY, &priv->shrd->status));
 	pos += scnprintf(buf + pos, bufsz - pos, "STATUS_TEMPERATURE:\t %d\n",
-		test_bit(STATUS_TEMPERATURE, &priv->status));
+		test_bit(STATUS_TEMPERATURE, &priv->shrd->status));
 	pos += scnprintf(buf + pos, bufsz - pos, "STATUS_GEO_CONFIGURED:\t %d\n",
-		test_bit(STATUS_GEO_CONFIGURED, &priv->status));
+		test_bit(STATUS_GEO_CONFIGURED, &priv->shrd->status));
 	pos += scnprintf(buf + pos, bufsz - pos, "STATUS_EXIT_PENDING:\t %d\n",
-		test_bit(STATUS_EXIT_PENDING, &priv->status));
+		test_bit(STATUS_EXIT_PENDING, &priv->shrd->status));
 	pos += scnprintf(buf + pos, bufsz - pos, "STATUS_STATISTICS:\t %d\n",
-		test_bit(STATUS_STATISTICS, &priv->status));
+		test_bit(STATUS_STATISTICS, &priv->shrd->status));
 	pos += scnprintf(buf + pos, bufsz - pos, "STATUS_SCANNING:\t %d\n",
-		test_bit(STATUS_SCANNING, &priv->status));
+		test_bit(STATUS_SCANNING, &priv->shrd->status));
 	pos += scnprintf(buf + pos, bufsz - pos, "STATUS_SCAN_ABORTING:\t %d\n",
-		test_bit(STATUS_SCAN_ABORTING, &priv->status));
+		test_bit(STATUS_SCAN_ABORTING, &priv->shrd->status));
 	pos += scnprintf(buf + pos, bufsz - pos, "STATUS_SCAN_HW:\t\t %d\n",
-		test_bit(STATUS_SCAN_HW, &priv->status));
+		test_bit(STATUS_SCAN_HW, &priv->shrd->status));
 	pos += scnprintf(buf + pos, bufsz - pos, "STATUS_POWER_PMI:\t %d\n",
-		test_bit(STATUS_POWER_PMI, &priv->status));
+		test_bit(STATUS_POWER_PMI, &priv->shrd->status));
 	pos += scnprintf(buf + pos, bufsz - pos, "STATUS_FW_ERROR:\t %d\n",
-		test_bit(STATUS_FW_ERROR, &priv->status));
+		test_bit(STATUS_FW_ERROR, &priv->shrd->status));
 	return simple_read_from_buffer(user_buf, count, ppos, buf, pos);
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 8aa4ef5..8ce8f22 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1299,8 +1299,6 @@ struct iwl_priv {
 
 	u32 scd_base_addr;	/* scheduler sram base address */
 
-	unsigned long status;
-
 	/* counts mgmt, ctl, and data packets */
 	struct traffic_stats tx_stats;
 	struct traffic_stats rx_stats;
diff --git a/drivers/net/wireless/iwlwifi/iwl-helpers.h b/drivers/net/wireless/iwlwifi/iwl-helpers.h
index 9d91552..d053ed7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-helpers.h
+++ b/drivers/net/wireless/iwlwifi/iwl-helpers.h
@@ -134,7 +134,7 @@ static inline void iwl_wake_any_queue(struct iwl_priv *priv,
 
 static inline void iwl_disable_interrupts(struct iwl_priv *priv)
 {
-	clear_bit(STATUS_INT_ENABLED, &priv->status);
+	clear_bit(STATUS_INT_ENABLED, &priv->shrd->status);
 
 	/* disable interrupts from uCode/NIC to host */
 	iwl_write32(priv, CSR_INT_MASK, 0x00000000);
@@ -155,7 +155,7 @@ static inline void iwl_enable_rfkill_int(struct iwl_priv *priv)
 static inline void iwl_enable_interrupts(struct iwl_priv *priv)
 {
 	IWL_DEBUG_ISR(priv, "Enabling interrupts\n");
-	set_bit(STATUS_INT_ENABLED, &priv->status);
+	set_bit(STATUS_INT_ENABLED, &priv->shrd->status);
 	iwl_write32(priv, CSR_INT_MASK, priv->inta_mask);
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-led.c b/drivers/net/wireless/iwlwifi/iwl-led.c
index 8623c98..2261fff 100644
--- a/drivers/net/wireless/iwlwifi/iwl-led.c
+++ b/drivers/net/wireless/iwlwifi/iwl-led.c
@@ -127,7 +127,7 @@ static int iwl_led_cmd(struct iwl_priv *priv,
 	};
 	int ret;
 
-	if (!test_bit(STATUS_READY, &priv->status))
+	if (!test_bit(STATUS_READY, &priv->shrd->status))
 		return -EBUSY;
 
 	if (priv->blink_on == on && priv->blink_off == off)
diff --git a/drivers/net/wireless/iwlwifi/iwl-power.c b/drivers/net/wireless/iwlwifi/iwl-power.c
index 40958e1..b041439 100644
--- a/drivers/net/wireless/iwlwifi/iwl-power.c
+++ b/drivers/net/wireless/iwlwifi/iwl-power.c
@@ -396,18 +396,18 @@ int iwl_power_set_mode(struct iwl_priv *priv, struct iwl_powertable_cmd *cmd,
 
 	/* scan complete use sleep_power_next, need to be updated */
 	memcpy(&priv->power_data.sleep_cmd_next, cmd, sizeof(*cmd));
-	if (test_bit(STATUS_SCANNING, &priv->status) && !force) {
+	if (test_bit(STATUS_SCANNING, &priv->shrd->status) && !force) {
 		IWL_DEBUG_INFO(priv, "Defer power set mode while scanning\n");
 		return 0;
 	}
 
 	if (cmd->flags & IWL_POWER_DRIVER_ALLOW_SLEEP_MSK)
-		set_bit(STATUS_POWER_PMI, &priv->status);
+		set_bit(STATUS_POWER_PMI, &priv->shrd->status);
 
 	ret = iwl_set_power(priv, cmd);
 	if (!ret) {
 		if (!(cmd->flags & IWL_POWER_DRIVER_ALLOW_SLEEP_MSK))
-			clear_bit(STATUS_POWER_PMI, &priv->status);
+			clear_bit(STATUS_POWER_PMI, &priv->shrd->status);
 
 		if (update_chains)
 			iwl_update_chain_flags(priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index c8af454..37bc017 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -74,7 +74,7 @@ static void iwl_rx_csa(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
 	struct iwl_rxon_context *ctx = &priv->contexts[IWL_RXON_CTX_BSS];
 	struct iwl_rxon_cmd *rxon = (void *)&ctx->active;
 
-	if (!test_bit(STATUS_CHANNEL_SWITCH_PENDING, &priv->status))
+	if (!test_bit(STATUS_CHANNEL_SWITCH_PENDING, &priv->shrd->status))
 		return;
 
 	if (!le32_to_cpu(csa->status) && csa->channel == priv->switch_channel) {
@@ -149,7 +149,7 @@ static void iwl_rx_beacon_notif(struct iwl_priv *priv,
 
 	priv->ibss_manager = le32_to_cpu(beacon->ibss_mgr_status);
 
-	if (!test_bit(STATUS_EXIT_PENDING, &priv->status))
+	if (!test_bit(STATUS_EXIT_PENDING, &priv->shrd->status))
 		queue_work(priv->shrd->workqueue, &priv->beacon_update);
 }
 
@@ -259,7 +259,7 @@ static void iwl_recover_from_statistics(struct iwl_priv *priv,
 {
 	unsigned int msecs;
 
-	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
+	if (test_bit(STATUS_EXIT_PENDING, &priv->shrd->status))
 		return;
 
 	msecs = jiffies_to_msecs(stamp - priv->rx_statistics_jiffies);
@@ -475,7 +475,7 @@ static void iwl_rx_statistics(struct iwl_priv *priv,
 
 	priv->rx_statistics_jiffies = stamp;
 
-	set_bit(STATUS_STATISTICS, &priv->status);
+	set_bit(STATUS_STATISTICS, &priv->shrd->status);
 
 	/* Reschedule the statistics timer to occur in
 	 * reg_recalib_period seconds to ensure we get a
@@ -484,7 +484,7 @@ static void iwl_rx_statistics(struct iwl_priv *priv,
 	mod_timer(&priv->statistics_periodic, jiffies +
 		  msecs_to_jiffies(reg_recalib_period * 1000));
 
-	if (unlikely(!test_bit(STATUS_SCANNING, &priv->status)) &&
+	if (unlikely(!test_bit(STATUS_SCANNING, &priv->shrd->status)) &&
 	    (pkt->hdr.cmd == STATISTICS_NOTIFICATION)) {
 		iwl_rx_calc_noise(priv);
 		queue_work(priv->shrd->workqueue, &priv->run_time_calib_work);
@@ -519,7 +519,7 @@ static void iwl_rx_card_state_notif(struct iwl_priv *priv,
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	u32 flags = le32_to_cpu(pkt->u.card_state_notif.flags);
-	unsigned long status = priv->status;
+	unsigned long status = priv->shrd->status;
 
 	IWL_DEBUG_RF_KILL(priv, "Card state received: HW:%s SW:%s CT:%s\n",
 			  (flags & HW_CARD_DISABLED) ? "Kill" : "On",
@@ -549,18 +549,18 @@ static void iwl_rx_card_state_notif(struct iwl_priv *priv,
 		iwl_tt_exit_ct_kill(priv);
 
 	if (flags & HW_CARD_DISABLED)
-		set_bit(STATUS_RF_KILL_HW, &priv->status);
+		set_bit(STATUS_RF_KILL_HW, &priv->shrd->status);
 	else
-		clear_bit(STATUS_RF_KILL_HW, &priv->status);
+		clear_bit(STATUS_RF_KILL_HW, &priv->shrd->status);
 
 
 	if (!(flags & RXON_CARD_DISABLED))
 		iwl_scan_cancel(priv);
 
 	if ((test_bit(STATUS_RF_KILL_HW, &status) !=
-	     test_bit(STATUS_RF_KILL_HW, &priv->status)))
+	     test_bit(STATUS_RF_KILL_HW, &priv->shrd->status)))
 		wiphy_rfkill_set_hw_state(priv->hw->wiphy,
-			test_bit(STATUS_RF_KILL_HW, &priv->status));
+			test_bit(STATUS_RF_KILL_HW, &priv->shrd->status));
 	else
 		wake_up_interruptible(&priv->wait_command_queue);
 }
@@ -581,7 +581,7 @@ static void iwl_rx_missed_beacon_notif(struct iwl_priv *priv,
 		    le32_to_cpu(missed_beacon->total_missed_becons),
 		    le32_to_cpu(missed_beacon->num_recvd_beacons),
 		    le32_to_cpu(missed_beacon->num_expected_beacons));
-		if (!test_bit(STATUS_SCANNING, &priv->status))
+		if (!test_bit(STATUS_SCANNING, &priv->shrd->status))
 			iwl_init_sensitivity(priv);
 	}
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index 6610b1d..bc8cb1d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -68,11 +68,11 @@ static int iwl_send_scan_abort(struct iwl_priv *priv)
 	/* Exit instantly with error when device is not ready
 	 * to receive scan abort command or it does not perform
 	 * hardware scan currently */
-	if (!test_bit(STATUS_READY, &priv->status) ||
-	    !test_bit(STATUS_GEO_CONFIGURED, &priv->status) ||
-	    !test_bit(STATUS_SCAN_HW, &priv->status) ||
-	    test_bit(STATUS_FW_ERROR, &priv->status) ||
-	    test_bit(STATUS_EXIT_PENDING, &priv->status))
+	if (!test_bit(STATUS_READY, &priv->shrd->status) ||
+	    !test_bit(STATUS_GEO_CONFIGURED, &priv->shrd->status) ||
+	    !test_bit(STATUS_SCAN_HW, &priv->shrd->status) ||
+	    test_bit(STATUS_FW_ERROR, &priv->shrd->status) ||
+	    test_bit(STATUS_EXIT_PENDING, &priv->shrd->status))
 		return -EIO;
 
 	ret = trans_send_cmd(&priv->trans, &cmd);
@@ -118,15 +118,15 @@ void iwl_force_scan_end(struct iwl_priv *priv)
 {
 	lockdep_assert_held(&priv->mutex);
 
-	if (!test_bit(STATUS_SCANNING, &priv->status)) {
+	if (!test_bit(STATUS_SCANNING, &priv->shrd->status)) {
 		IWL_DEBUG_SCAN(priv, "Forcing scan end while not scanning\n");
 		return;
 	}
 
 	IWL_DEBUG_SCAN(priv, "Forcing scan end\n");
-	clear_bit(STATUS_SCANNING, &priv->status);
-	clear_bit(STATUS_SCAN_HW, &priv->status);
-	clear_bit(STATUS_SCAN_ABORTING, &priv->status);
+	clear_bit(STATUS_SCANNING, &priv->shrd->status);
+	clear_bit(STATUS_SCAN_HW, &priv->shrd->status);
+	clear_bit(STATUS_SCAN_ABORTING, &priv->shrd->status);
 	iwl_complete_scan(priv, true);
 }
 
@@ -136,12 +136,12 @@ static void iwl_do_scan_abort(struct iwl_priv *priv)
 
 	lockdep_assert_held(&priv->mutex);
 
-	if (!test_bit(STATUS_SCANNING, &priv->status)) {
+	if (!test_bit(STATUS_SCANNING, &priv->shrd->status)) {
 		IWL_DEBUG_SCAN(priv, "Not performing scan to abort\n");
 		return;
 	}
 
-	if (test_and_set_bit(STATUS_SCAN_ABORTING, &priv->status)) {
+	if (test_and_set_bit(STATUS_SCAN_ABORTING, &priv->shrd->status)) {
 		IWL_DEBUG_SCAN(priv, "Scan abort in progress\n");
 		return;
 	}
@@ -180,12 +180,12 @@ int iwl_scan_cancel_timeout(struct iwl_priv *priv, unsigned long ms)
 	iwl_do_scan_abort(priv);
 
 	while (time_before_eq(jiffies, timeout)) {
-		if (!test_bit(STATUS_SCAN_HW, &priv->status))
+		if (!test_bit(STATUS_SCAN_HW, &priv->shrd->status))
 			break;
 		msleep(20);
 	}
 
-	return test_bit(STATUS_SCAN_HW, &priv->status);
+	return test_bit(STATUS_SCAN_HW, &priv->shrd->status);
 }
 
 /* Service response to REPLY_SCAN_CMD (0x80) */
@@ -257,7 +257,7 @@ static void iwl_rx_scan_complete_notif(struct iwl_priv *priv,
 		       scan_notif->tsf_high, scan_notif->status);
 
 	/* The HW is no longer scanning */
-	clear_bit(STATUS_SCAN_HW, &priv->status);
+	clear_bit(STATUS_SCAN_HW, &priv->shrd->status);
 
 	IWL_DEBUG_SCAN(priv, "Scan on %sGHz took %dms\n",
 		       (priv->scan_band == IEEE80211_BAND_2GHZ) ? "2.4" : "5.2",
@@ -367,13 +367,13 @@ int __must_check iwl_scan_initiate(struct iwl_priv *priv,
 		return -EIO;
 	}
 
-	if (test_bit(STATUS_SCAN_HW, &priv->status)) {
+	if (test_bit(STATUS_SCAN_HW, &priv->shrd->status)) {
 		IWL_DEBUG_SCAN(priv,
 			"Multiple concurrent scan requests in parallel.\n");
 		return -EBUSY;
 	}
 
-	if (test_bit(STATUS_SCAN_ABORTING, &priv->status)) {
+	if (test_bit(STATUS_SCAN_ABORTING, &priv->shrd->status)) {
 		IWL_DEBUG_SCAN(priv, "Scan request while abort pending.\n");
 		return -EBUSY;
 	}
@@ -383,14 +383,14 @@ int __must_check iwl_scan_initiate(struct iwl_priv *priv,
 			scan_type == IWL_SCAN_ROC ? "remain-on-channel " :
 			"internal short ");
 
-	set_bit(STATUS_SCANNING, &priv->status);
+	set_bit(STATUS_SCANNING, &priv->shrd->status);
 	priv->scan_type = scan_type;
 	priv->scan_start = jiffies;
 	priv->scan_band = band;
 
 	ret = iwlagn_request_scan(priv, vif);
 	if (ret) {
-		clear_bit(STATUS_SCANNING, &priv->status);
+		clear_bit(STATUS_SCANNING, &priv->shrd->status);
 		priv->scan_type = IWL_SCAN_NORMAL;
 		return ret;
 	}
@@ -415,7 +415,7 @@ int iwl_mac_hw_scan(struct ieee80211_hw *hw,
 
 	mutex_lock(&priv->mutex);
 
-	if (test_bit(STATUS_SCANNING, &priv->status) &&
+	if (test_bit(STATUS_SCANNING, &priv->shrd->status) &&
 	    priv->scan_type != IWL_SCAN_NORMAL) {
 		IWL_DEBUG_SCAN(priv, "Scan already in progress.\n");
 		ret = -EAGAIN;
@@ -468,7 +468,7 @@ static void iwl_bg_start_internal_scan(struct work_struct *work)
 		goto unlock;
 	}
 
-	if (test_bit(STATUS_SCANNING, &priv->status)) {
+	if (test_bit(STATUS_SCANNING, &priv->shrd->status)) {
 		IWL_DEBUG_SCAN(priv, "Scan already in progress.\n");
 		goto unlock;
 	}
@@ -566,11 +566,11 @@ static void iwl_bg_scan_completed(struct work_struct *work)
 
 	mutex_lock(&priv->mutex);
 
-	aborted = test_and_clear_bit(STATUS_SCAN_ABORTING, &priv->status);
+	aborted = test_and_clear_bit(STATUS_SCAN_ABORTING, &priv->shrd->status);
 	if (aborted)
 		IWL_DEBUG_SCAN(priv, "Aborted scan completed.\n");
 
-	if (!test_and_clear_bit(STATUS_SCANNING, &priv->status)) {
+	if (!test_and_clear_bit(STATUS_SCANNING, &priv->shrd->status)) {
 		IWL_DEBUG_SCAN(priv, "Scan already completed.\n");
 		goto out_settings;
 	}
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index 85d5a62..74ff711 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -144,6 +144,7 @@ struct iwl_hw_params {
  * @dbg_level_dev: dbg level set per device. Prevails on
  *	iwlagn_mod_params.debug_level if set (!= 0)
  * @cmd_queue: command queue number
+ * @status: STATUS_*
  * @bus: pointer to the bus layer data
  * @priv: pointer to the upper layer data
  * @hw_params: see struct iwl_hw_params
@@ -155,6 +156,7 @@ struct iwl_shared {
 #endif /* CONFIG_IWLWIFI_DEBUG */
 
 	u8 cmd_queue;
+	unsigned long status;
 
 	struct iwl_bus *bus;
 	struct iwl_priv *priv;
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c
index 10627f8..0b79815 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c
@@ -145,7 +145,7 @@ void iwl_rx_queue_update_write_ptr(struct iwl_priv *priv,
 		iwl_write32(priv, FH_RSCSR_CHNL0_WPTR, q->write_actual);
 	} else {
 		/* If power-saving is in use, make sure device is awake */
-		if (test_bit(STATUS_POWER_PMI, &priv->status)) {
+		if (test_bit(STATUS_POWER_PMI, &priv->shrd->status)) {
 			reg = iwl_read32(priv, CSR_UCODE_DRV_GP1);
 
 			if (reg & CSR_UCODE_DRV_GP1_BIT_MAC_SLEEP) {
@@ -346,7 +346,7 @@ void iwl_bg_rx_replenish(struct work_struct *data)
 	struct iwl_priv *priv =
 	    container_of(data, struct iwl_priv, rx_replenish);
 
-	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
+	if (test_bit(STATUS_EXIT_PENDING, &priv->shrd->status))
 		return;
 
 	mutex_lock(&priv->mutex);
@@ -581,11 +581,12 @@ void iwl_irq_tasklet(struct iwl_priv *priv)
 		 * is killed. Hence update the killswitch state here. The
 		 * rfkill handler will care about restarting if needed.
 		 */
-		if (!test_bit(STATUS_ALIVE, &priv->status)) {
+		if (!test_bit(STATUS_ALIVE, &priv->shrd->status)) {
 			if (hw_rf_kill)
-				set_bit(STATUS_RF_KILL_HW, &priv->status);
+				set_bit(STATUS_RF_KILL_HW, &priv->shrd->status);
 			else
-				clear_bit(STATUS_RF_KILL_HW, &priv->status);
+				clear_bit(STATUS_RF_KILL_HW,
+					  &priv->shrd->status);
 			wiphy_rfkill_set_hw_state(priv->hw->wiphy, hw_rf_kill);
 		}
 
@@ -688,7 +689,7 @@ void iwl_irq_tasklet(struct iwl_priv *priv)
 
 	/* Re-enable all interrupts */
 	/* only Re-enable if disabled by irq */
-	if (test_bit(STATUS_INT_ENABLED, &priv->status))
+	if (test_bit(STATUS_INT_ENABLED, &priv->shrd->status))
 		iwl_enable_interrupts(priv);
 	/* Re-enable RF_KILL if it occurred */
 	else if (handled & CSR_INT_BIT_RF_KILL)
@@ -858,7 +859,7 @@ static irqreturn_t iwl_isr(int irq, void *data)
 	/* iwl_irq_tasklet() will service interrupts and re-enable them */
 	if (likely(inta))
 		tasklet_schedule(&priv->irq_tasklet);
-	else if (test_bit(STATUS_INT_ENABLED, &priv->status) &&
+	else if (test_bit(STATUS_INT_ENABLED, &priv->shrd->status) &&
 			!priv->inta)
 		iwl_enable_interrupts(priv);
 
@@ -869,7 +870,7 @@ static irqreturn_t iwl_isr(int irq, void *data)
  none:
 	/* re-enable interrupts here since we don't have anything to service. */
 	/* only Re-enable if disabled by irq  and no schedules tasklet. */
-	if (test_bit(STATUS_INT_ENABLED, &priv->status) && !priv->inta)
+	if (test_bit(STATUS_INT_ENABLED, &priv->shrd->status) && !priv->inta)
 		iwl_enable_interrupts(priv);
 
 	spin_unlock_irqrestore(&priv->lock, flags);
@@ -957,7 +958,7 @@ irqreturn_t iwl_isr_ict(int irq, void *data)
 	/* iwl_irq_tasklet() will service interrupts and re-enable them */
 	if (likely(inta))
 		tasklet_schedule(&priv->irq_tasklet);
-	else if (test_bit(STATUS_INT_ENABLED, &priv->status) &&
+	else if (test_bit(STATUS_INT_ENABLED, &priv->shrd->status) &&
 			!priv->inta) {
 		/* Allow interrupt if was disabled by this handler and
 		 * no tasklet was schedules, We should not enable interrupt,
@@ -973,7 +974,7 @@ irqreturn_t iwl_isr_ict(int irq, void *data)
 	/* re-enable interrupts here since we don't have anything to service.
 	 * only Re-enable if disabled by irq.
 	 */
-	if (test_bit(STATUS_INT_ENABLED, &priv->status) && !priv->inta)
+	if (test_bit(STATUS_INT_ENABLED, &priv->shrd->status) && !priv->inta)
 		iwl_enable_interrupts(priv);
 
 	spin_unlock_irqrestore(&priv->lock, flags);
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c
index b751f52..ab42152 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c
@@ -96,7 +96,7 @@ void iwl_txq_update_write_ptr(struct iwl_priv *priv, struct iwl_tx_queue *txq)
 			    txq->q.write_ptr | (txq_id << 8));
 	} else {
 		/* if we're trying to save power */
-		if (test_bit(STATUS_POWER_PMI, &priv->status)) {
+		if (test_bit(STATUS_POWER_PMI, &priv->shrd->status)) {
 			/* wake up nic if it's powered down ...
 			 * uCode will wake up, and interrupt us again, so next
 			 * time we'll skip this part. */
@@ -544,7 +544,7 @@ static int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 	int trace_idx;
 #endif
 
-	if (test_bit(STATUS_FW_ERROR, &priv->status)) {
+	if (test_bit(STATUS_FW_ERROR, &priv->shrd->status)) {
 		IWL_WARN(priv, "fw recovery, no hcmd send\n");
 		return -EIO;
 	}
@@ -786,7 +786,7 @@ void iwl_tx_cmd_complete(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
 	iwl_hcmd_queue_reclaim(priv, txq_id, index);
 
 	if (!(meta->flags & CMD_ASYNC)) {
-		clear_bit(STATUS_HCMD_ACTIVE, &priv->status);
+		clear_bit(STATUS_HCMD_ACTIVE, &priv->shrd->status);
 		IWL_DEBUG_INFO(priv, "Clearing HCMD_ACTIVE for command %s\n",
 			       get_cmd_string(cmd->hdr.cmd));
 		wake_up_interruptible(&priv->wait_command_queue);
@@ -917,7 +917,7 @@ static int iwl_send_cmd_async(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 	if (!cmd->callback)
 		cmd->callback = iwl_generic_cmd_callback;
 
-	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
+	if (test_bit(STATUS_EXIT_PENDING, &priv->shrd->status))
 		return -EBUSY;
 
 	ret = iwl_enqueue_hcmd(priv, cmd);
@@ -943,30 +943,30 @@ static int iwl_send_cmd_sync(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 	IWL_DEBUG_INFO(priv, "Attempting to send sync command %s\n",
 			get_cmd_string(cmd->id));
 
-	set_bit(STATUS_HCMD_ACTIVE, &priv->status);
+	set_bit(STATUS_HCMD_ACTIVE, &priv->shrd->status);
 	IWL_DEBUG_INFO(priv, "Setting HCMD_ACTIVE for command %s\n",
 			get_cmd_string(cmd->id));
 
 	cmd_idx = iwl_enqueue_hcmd(priv, cmd);
 	if (cmd_idx < 0) {
 		ret = cmd_idx;
-		clear_bit(STATUS_HCMD_ACTIVE, &priv->status);
+		clear_bit(STATUS_HCMD_ACTIVE, &priv->shrd->status);
 		IWL_ERR(priv, "Error sending %s: enqueue_hcmd failed: %d\n",
 			  get_cmd_string(cmd->id), ret);
 		return ret;
 	}
 
 	ret = wait_event_interruptible_timeout(priv->wait_command_queue,
-			!test_bit(STATUS_HCMD_ACTIVE, &priv->status),
+			!test_bit(STATUS_HCMD_ACTIVE, &priv->shrd->status),
 			HOST_COMPLETE_TIMEOUT);
 	if (!ret) {
-		if (test_bit(STATUS_HCMD_ACTIVE, &priv->status)) {
+		if (test_bit(STATUS_HCMD_ACTIVE, &priv->shrd->status)) {
 			IWL_ERR(priv,
 				"Error sending %s: time out after %dms.\n",
 				get_cmd_string(cmd->id),
 				jiffies_to_msecs(HOST_COMPLETE_TIMEOUT));
 
-			clear_bit(STATUS_HCMD_ACTIVE, &priv->status);
+			clear_bit(STATUS_HCMD_ACTIVE, &priv->shrd->status);
 			IWL_DEBUG_INFO(priv, "Clearing HCMD_ACTIVE for command"
 				 "%s\n", get_cmd_string(cmd->id));
 			ret = -ETIMEDOUT;
@@ -974,13 +974,13 @@ static int iwl_send_cmd_sync(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 		}
 	}
 
-	if (test_bit(STATUS_RF_KILL_HW, &priv->status)) {
+	if (test_bit(STATUS_RF_KILL_HW, &priv->shrd->status)) {
 		IWL_ERR(priv, "Command %s aborted: RF KILL Switch\n",
 			       get_cmd_string(cmd->id));
 		ret = -ECANCELED;
 		goto fail;
 	}
-	if (test_bit(STATUS_FW_ERROR, &priv->status)) {
+	if (test_bit(STATUS_FW_ERROR, &priv->shrd->status)) {
 		IWL_ERR(priv, "Command %s failed: FW Error\n",
 			       get_cmd_string(cmd->id));
 		ret = -EIO;
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.c b/drivers/net/wireless/iwlwifi/iwl-trans.c
index 7a689df..a3e1bd0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.c
@@ -623,7 +623,7 @@ static int iwl_nic_init(struct iwl_priv *priv)
 			0x800FFFFF);
 	}
 
-	set_bit(STATUS_INIT, &priv->status);
+	set_bit(STATUS_INIT, &priv->shrd->status);
 
 	return 0;
 }
@@ -692,9 +692,9 @@ static int iwl_trans_start_device(struct iwl_priv *priv)
 	/* If platform's RF_KILL switch is NOT set to KILL */
 	if (iwl_read32(priv, CSR_GP_CNTRL) &
 			CSR_GP_CNTRL_REG_FLAG_HW_RF_KILL_SW)
-		clear_bit(STATUS_RF_KILL_HW, &priv->status);
+		clear_bit(STATUS_RF_KILL_HW, &priv->shrd->status);
 	else
-		set_bit(STATUS_RF_KILL_HW, &priv->status);
+		set_bit(STATUS_RF_KILL_HW, &priv->shrd->status);
 
 	if (iwl_is_rfkill(priv)) {
 		wiphy_rfkill_set_hw_state(priv->hw->wiphy, true);
@@ -939,7 +939,7 @@ static void iwl_trans_stop_device(struct iwl_priv *priv)
 	 * restart. So don't process again if the device is
 	 * already dead.
 	 */
-	if (test_bit(STATUS_DEVICE_ENABLED, &priv->status)) {
+	if (test_bit(STATUS_DEVICE_ENABLED, &priv->shrd->status)) {
 		iwl_trans_tx_stop(priv);
 		iwl_trans_rx_stop(priv);
 
-- 
1.7.0.4

