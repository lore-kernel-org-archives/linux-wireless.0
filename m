Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:20333 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759736Ab2CGTGk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Mar 2012 14:06:40 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Don Fry <donald.h.fry@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH RESEND 28/35] iwlwifi: more status bit factoring
Date: Wed,  7 Mar 2012 09:52:37 -0800
Message-Id: <1331142764-5750-29-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120307_200708_362923_EF40746F)
In-Reply-To: <1331142764-5750-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1331142764-5750-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Don Fry <donald.h.fry@intel.com>

Continue splitting the status bits between transport and op_mode.
All but a few are separated.

Signed-off-by: Don Fry <donald.h.fry@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c        |    8 ++--
 drivers/net/wireless/iwlwifi/iwl-agn-rx.c         |   18 ++++----
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c       |   14 +++---
 drivers/net/wireless/iwlwifi/iwl-agn-sta.c        |    6 +-
 drivers/net/wireless/iwlwifi/iwl-agn-tt.c         |   20 ++++----
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c         |    4 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c            |   40 ++++++++--------
 drivers/net/wireless/iwlwifi/iwl-agn.h            |   31 +++++-------
 drivers/net/wireless/iwlwifi/iwl-core.c           |   31 ++++++-------
 drivers/net/wireless/iwlwifi/iwl-debugfs.c        |   38 +++++++--------
 drivers/net/wireless/iwlwifi/iwl-led.c            |    2 +-
 drivers/net/wireless/iwlwifi/iwl-mac80211.c       |   34 +++++++-------
 drivers/net/wireless/iwlwifi/iwl-power.c          |    4 +-
 drivers/net/wireless/iwlwifi/iwl-scan.c           |   50 ++++++++++----------
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h |    8 ++--
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c  |   10 ++--
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c     |    8 ++-
 17 files changed, 160 insertions(+), 166 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 3fed4bb..915183a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -51,7 +51,7 @@ int iwlagn_send_tx_power(struct iwl_priv *priv)
 	struct iwlagn_tx_power_dbm_cmd tx_power_cmd;
 	u8 tx_ant_cfg_cmd;
 
-	if (WARN_ONCE(test_bit(STATUS_SCAN_HW, &priv->shrd->status),
+	if (WARN_ONCE(test_bit(STATUS_SCAN_HW, &priv->status),
 		      "TX Power requested while scanning!\n"))
 		return -EAGAIN;
 
@@ -575,7 +575,7 @@ static void iwlagn_bt_traffic_change_work(struct work_struct *work)
 	 * STATUS_SCANNING to avoid race when queue_work two times from
 	 * different notifications, but quit and not perform any work at all.
 	 */
-	if (test_bit(STATUS_SCAN_HW, &priv->shrd->status))
+	if (test_bit(STATUS_SCAN_HW, &priv->status))
 		goto out;
 
 	iwl_update_chain_flags(priv);
@@ -1291,9 +1291,9 @@ int iwlagn_suspend(struct iwl_priv *priv, struct cfg80211_wowlan *wowlan)
 
 int iwl_dvm_send_cmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 {
-	if (iwl_is_rfkill(priv->shrd) || iwl_is_ctkill(priv)) {
+	if (iwl_is_rfkill(priv) || iwl_is_ctkill(priv)) {
 		IWL_WARN(priv, "Not sending command - %s KILL\n",
-			 iwl_is_rfkill(priv->shrd) ? "RF" : "CT");
+			 iwl_is_rfkill(priv) ? "RF" : "CT");
 		return -EIO;
 	}
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rx.c b/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
index 8e7cdfa..3ad4333 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
@@ -159,7 +159,7 @@ static int iwlagn_rx_csa(struct iwl_priv *priv, struct iwl_rx_cmd_buffer *rxb,
 	struct iwl_rxon_context *ctx = &priv->contexts[IWL_RXON_CTX_BSS];
 	struct iwl_rxon_cmd *rxon = (void *)&ctx->active;
 
-	if (!test_bit(STATUS_CHANNEL_SWITCH_PENDING, &priv->shrd->status))
+	if (!test_bit(STATUS_CHANNEL_SWITCH_PENDING, &priv->status))
 		return 0;
 
 	if (!le32_to_cpu(csa->status) && csa->channel == priv->switch_channel) {
@@ -355,7 +355,7 @@ static void iwlagn_recover_from_statistics(struct iwl_priv *priv,
 {
 	unsigned int msecs;
 
-	if (test_bit(STATUS_EXIT_PENDING, &priv->shrd->status))
+	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return;
 
 	msecs = jiffies_to_msecs(stamp - priv->rx_statistics_jiffies);
@@ -575,7 +575,7 @@ static int iwlagn_rx_statistics(struct iwl_priv *priv,
 
 	priv->rx_statistics_jiffies = stamp;
 
-	set_bit(STATUS_STATISTICS, &priv->shrd->status);
+	set_bit(STATUS_STATISTICS, &priv->status);
 
 	/* Reschedule the statistics timer to occur in
 	 * reg_recalib_period seconds to ensure we get a
@@ -584,7 +584,7 @@ static int iwlagn_rx_statistics(struct iwl_priv *priv,
 	mod_timer(&priv->statistics_periodic, jiffies +
 		  msecs_to_jiffies(reg_recalib_period * 1000));
 
-	if (unlikely(!test_bit(STATUS_SCANNING, &priv->shrd->status)) &&
+	if (unlikely(!test_bit(STATUS_SCANNING, &priv->status)) &&
 	    (pkt->hdr.cmd == STATISTICS_NOTIFICATION)) {
 		iwlagn_rx_calc_noise(priv);
 		queue_work(priv->workqueue, &priv->run_time_calib_work);
@@ -658,18 +658,18 @@ static int iwlagn_rx_card_state_notif(struct iwl_priv *priv,
 		iwl_tt_exit_ct_kill(priv);
 
 	if (flags & HW_CARD_DISABLED)
-		set_bit(STATUS_RF_KILL_HW, &priv->shrd->status);
+		set_bit(STATUS_RF_KILL_HW, &priv->status);
 	else
-		clear_bit(STATUS_RF_KILL_HW, &priv->shrd->status);
+		clear_bit(STATUS_RF_KILL_HW, &priv->status);
 
 
 	if (!(flags & RXON_CARD_DISABLED))
 		iwl_scan_cancel(priv);
 
 	if ((test_bit(STATUS_RF_KILL_HW, &status) !=
-	     test_bit(STATUS_RF_KILL_HW, &priv->shrd->status)))
+	     test_bit(STATUS_RF_KILL_HW, &priv->status)))
 		wiphy_rfkill_set_hw_state(priv->hw->wiphy,
-			test_bit(STATUS_RF_KILL_HW, &priv->shrd->status));
+			test_bit(STATUS_RF_KILL_HW, &priv->status));
 	else
 		wake_up(&priv->shrd->wait_command_queue);
 	return 0;
@@ -691,7 +691,7 @@ static int iwlagn_rx_missed_beacon_notif(struct iwl_priv *priv,
 		    le32_to_cpu(missed_beacon->total_missed_becons),
 		    le32_to_cpu(missed_beacon->num_recvd_beacons),
 		    le32_to_cpu(missed_beacon->num_expected_beacons));
-		if (!test_bit(STATUS_SCANNING, &priv->shrd->status))
+		if (!test_bit(STATUS_SCANNING, &priv->status))
 			iwl_init_sensitivity(priv);
 	}
 	return 0;
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
index 66e9a71..3690907 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
@@ -361,7 +361,7 @@ int iwlagn_set_pan_params(struct iwl_priv *priv)
 		slot0 = bcnint / 2;
 		slot1 = bcnint - slot0;
 
-		if (test_bit(STATUS_SCAN_HW, &priv->shrd->status) ||
+		if (test_bit(STATUS_SCAN_HW, &priv->status) ||
 		    (!ctx_bss->vif->bss_conf.idle &&
 		     !ctx_bss->vif->bss_conf.assoc)) {
 			slot0 = dtim * bcnint * 3 - IWL_MIN_SLOT_TIME;
@@ -377,7 +377,7 @@ int iwlagn_set_pan_params(struct iwl_priv *priv)
 					ctx_pan->beacon_int;
 		slot1 = max_t(int, DEFAULT_BEACON_INTERVAL, slot1);
 
-		if (test_bit(STATUS_SCAN_HW, &priv->shrd->status)) {
+		if (test_bit(STATUS_SCAN_HW, &priv->status)) {
 			slot0 = slot1 * 3 - IWL_MIN_SLOT_TIME;
 			slot1 = IWL_MIN_SLOT_TIME;
 		}
@@ -421,7 +421,7 @@ int iwlagn_commit_rxon(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 
 	lockdep_assert_held(&priv->mutex);
 
-	if (!iwl_is_alive(priv->shrd))
+	if (!iwl_is_alive(priv))
 		return -EBUSY;
 
 	/* This function hardcodes a bunch of dual-mode assumptions */
@@ -457,7 +457,7 @@ int iwlagn_commit_rxon(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 	 * receive commit_rxon request
 	 * abort any previous channel switch if still in process
 	 */
-	if (test_bit(STATUS_CHANNEL_SWITCH_PENDING, &priv->shrd->status) &&
+	if (test_bit(STATUS_CHANNEL_SWITCH_PENDING, &priv->status) &&
 	    (priv->switch_channel != ctx->staging.channel)) {
 		IWL_DEBUG_11H(priv, "abort channel switch on %d\n",
 			      le16_to_cpu(priv->switch_channel));
@@ -551,12 +551,12 @@ int iwlagn_mac_config(struct ieee80211_hw *hw, u32 changed)
 
 	mutex_lock(&priv->mutex);
 
-	if (unlikely(test_bit(STATUS_SCANNING, &priv->shrd->status))) {
+	if (unlikely(test_bit(STATUS_SCANNING, &priv->status))) {
 		IWL_DEBUG_MAC80211(priv, "leave - scanning\n");
 		goto out;
 	}
 
-	if (!iwl_is_ready(priv->shrd)) {
+	if (!iwl_is_ready(priv)) {
 		IWL_DEBUG_MAC80211(priv, "leave - not ready\n");
 		goto out;
 	}
@@ -794,7 +794,7 @@ void iwlagn_bss_info_changed(struct ieee80211_hw *hw,
 
 	mutex_lock(&priv->mutex);
 
-	if (unlikely(!iwl_is_ready(priv->shrd))) {
+	if (unlikely(!iwl_is_ready(priv))) {
 		IWL_DEBUG_MAC80211(priv, "leave - not ready\n");
 		mutex_unlock(&priv->mutex);
 		return;
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-sta.c b/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
index cf5cc10..23e9eab 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
@@ -490,7 +490,7 @@ int iwl_remove_station(struct iwl_priv *priv, const u8 sta_id,
 {
 	u8 tid;
 
-	if (!iwl_is_ready(priv->shrd)) {
+	if (!iwl_is_ready(priv)) {
 		IWL_DEBUG_INFO(priv,
 			"Unable to remove station %pM, device not ready.\n",
 			addr);
@@ -598,7 +598,7 @@ void iwl_restore_stations(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 	int ret;
 	bool send_lq;
 
-	if (!iwl_is_ready(priv->shrd)) {
+	if (!iwl_is_ready(priv)) {
 		IWL_DEBUG_INFO(priv,
 			       "Not ready yet, not restoring any stations.\n");
 		return;
@@ -997,7 +997,7 @@ int iwl_remove_default_wep_key(struct iwl_priv *priv,
 		      keyconf->keyidx);
 
 	memset(&ctx->wep_keys[keyconf->keyidx], 0, sizeof(ctx->wep_keys[0]));
-	if (iwl_is_rfkill(priv->shrd)) {
+	if (iwl_is_rfkill(priv)) {
 		IWL_DEBUG_WEP(priv,
 			"Not sending REPLY_WEPKEY command due to RFKILL.\n");
 		/* but keys in device are clear anyway so return success */
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tt.c b/drivers/net/wireless/iwlwifi/iwl-agn-tt.c
index fa94153..baaf5ba 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tt.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tt.c
@@ -174,7 +174,7 @@ static void iwl_tt_check_exit_ct_kill(unsigned long data)
 	struct iwl_tt_mgmt *tt = &priv->thermal_throttle;
 	unsigned long flags;
 
-	if (test_bit(STATUS_EXIT_PENDING, &priv->shrd->status))
+	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return;
 
 	if (tt->state == IWL_TI_CT_KILL) {
@@ -225,7 +225,7 @@ static void iwl_tt_ready_for_ct_kill(unsigned long data)
 	struct iwl_priv *priv = (struct iwl_priv *)data;
 	struct iwl_tt_mgmt *tt = &priv->thermal_throttle;
 
-	if (test_bit(STATUS_EXIT_PENDING, &priv->shrd->status))
+	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return;
 
 	/* temperature timer expired, ready to go into CT_KILL state */
@@ -504,10 +504,10 @@ static void iwl_bg_ct_enter(struct work_struct *work)
 	struct iwl_priv *priv = container_of(work, struct iwl_priv, ct_enter);
 	struct iwl_tt_mgmt *tt = &priv->thermal_throttle;
 
-	if (test_bit(STATUS_EXIT_PENDING, &priv->shrd->status))
+	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return;
 
-	if (!iwl_is_ready(priv->shrd))
+	if (!iwl_is_ready(priv))
 		return;
 
 	if (tt->state != IWL_TI_CT_KILL) {
@@ -533,10 +533,10 @@ static void iwl_bg_ct_exit(struct work_struct *work)
 	struct iwl_priv *priv = container_of(work, struct iwl_priv, ct_exit);
 	struct iwl_tt_mgmt *tt = &priv->thermal_throttle;
 
-	if (test_bit(STATUS_EXIT_PENDING, &priv->shrd->status))
+	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return;
 
-	if (!iwl_is_ready(priv->shrd))
+	if (!iwl_is_ready(priv))
 		return;
 
 	/* stop ct_kill_exit_tm timer */
@@ -563,7 +563,7 @@ static void iwl_bg_ct_exit(struct work_struct *work)
 
 void iwl_tt_enter_ct_kill(struct iwl_priv *priv)
 {
-	if (test_bit(STATUS_EXIT_PENDING, &priv->shrd->status))
+	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return;
 
 	IWL_DEBUG_TEMP(priv, "Queueing critical temperature enter.\n");
@@ -572,7 +572,7 @@ void iwl_tt_enter_ct_kill(struct iwl_priv *priv)
 
 void iwl_tt_exit_ct_kill(struct iwl_priv *priv)
 {
-	if (test_bit(STATUS_EXIT_PENDING, &priv->shrd->status))
+	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return;
 
 	IWL_DEBUG_TEMP(priv, "Queueing critical temperature exit.\n");
@@ -584,7 +584,7 @@ static void iwl_bg_tt_work(struct work_struct *work)
 	struct iwl_priv *priv = container_of(work, struct iwl_priv, tt_work);
 	s32 temp = priv->temperature; /* degrees CELSIUS except specified */
 
-	if (test_bit(STATUS_EXIT_PENDING, &priv->shrd->status))
+	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return;
 
 	if (!priv->thermal_throttle.advanced_tt)
@@ -595,7 +595,7 @@ static void iwl_bg_tt_work(struct work_struct *work)
 
 void iwl_tt_handler(struct iwl_priv *priv)
 {
-	if (test_bit(STATUS_EXIT_PENDING, &priv->shrd->status))
+	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return;
 
 	IWL_DEBUG_TEMP(priv, "Queueing thermal throttling work.\n");
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index 1cd4831..34adedc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -297,7 +297,7 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	if (info->control.vif)
 		ctx = iwl_rxon_ctx_from_vif(info->control.vif);
 
-	if (iwl_is_rfkill(priv->shrd)) {
+	if (iwl_is_rfkill(priv)) {
 		IWL_DEBUG_DROP(priv, "Dropping - RF KILL\n");
 		goto drop_unlock_priv;
 	}
@@ -1000,7 +1000,7 @@ static void iwl_check_abort_status(struct iwl_priv *priv,
 {
 	if (frame_count == 1 && status == TX_STATUS_FAIL_RFKILL_FLUSH) {
 		IWL_ERR(priv, "Tx flush command to flush out all frames\n");
-		if (!test_bit(STATUS_EXIT_PENDING, &priv->shrd->status))
+		if (!test_bit(STATUS_EXIT_PENDING, &priv->status))
 			queue_work(priv->workqueue, &priv->tx_flush);
 	}
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 3973424..d45def3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -244,11 +244,11 @@ static void iwl_bg_bt_runtime_config(struct work_struct *work)
 	struct iwl_priv *priv =
 		container_of(work, struct iwl_priv, bt_runtime_config);
 
-	if (test_bit(STATUS_EXIT_PENDING, &priv->shrd->status))
+	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return;
 
 	/* dont send host command if rf-kill is on */
-	if (!iwl_is_ready_rf(priv->shrd))
+	if (!iwl_is_ready_rf(priv))
 		return;
 	iwlagn_send_advance_bt_config(priv);
 }
@@ -261,11 +261,11 @@ static void iwl_bg_bt_full_concurrency(struct work_struct *work)
 
 	mutex_lock(&priv->mutex);
 
-	if (test_bit(STATUS_EXIT_PENDING, &priv->shrd->status))
+	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		goto out;
 
 	/* dont send host command if rf-kill is on */
-	if (!iwl_is_ready_rf(priv->shrd))
+	if (!iwl_is_ready_rf(priv))
 		goto out;
 
 	IWL_DEBUG_INFO(priv, "BT coex in %s mode\n",
@@ -300,11 +300,11 @@ static void iwl_bg_statistics_periodic(unsigned long data)
 {
 	struct iwl_priv *priv = (struct iwl_priv *)data;
 
-	if (test_bit(STATUS_EXIT_PENDING, &priv->shrd->status))
+	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return;
 
 	/* dont send host command if rf-kill is on */
-	if (!iwl_is_ready_rf(priv->shrd))
+	if (!iwl_is_ready_rf(priv))
 		return;
 
 	iwl_send_statistics_request(priv, CMD_ASYNC, false);
@@ -461,7 +461,7 @@ static void iwl_bg_ucode_trace(unsigned long data)
 {
 	struct iwl_priv *priv = (struct iwl_priv *)data;
 
-	if (test_bit(STATUS_EXIT_PENDING, &priv->shrd->status))
+	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return;
 
 	if (priv->event_log.ucode_trace) {
@@ -477,11 +477,11 @@ static void iwl_bg_tx_flush(struct work_struct *work)
 	struct iwl_priv *priv =
 		container_of(work, struct iwl_priv, tx_flush);
 
-	if (test_bit(STATUS_EXIT_PENDING, &priv->shrd->status))
+	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return;
 
 	/* do nothing if rf-kill is on */
-	if (!iwl_is_ready_rf(priv->shrd))
+	if (!iwl_is_ready_rf(priv))
 		return;
 
 	IWL_DEBUG_INFO(priv, "device request: flush all tx frames\n");
@@ -640,12 +640,12 @@ int iwl_alive_start(struct iwl_priv *priv)
 	IWL_DEBUG_INFO(priv, "Runtime Alive received.\n");
 
 	/* After the ALIVE response, we can send host commands to the uCode */
-	set_bit(STATUS_ALIVE, &priv->shrd->status);
+	set_bit(STATUS_ALIVE, &priv->status);
 
 	/* Enable watchdog to monitor the driver tx queues */
 	iwl_setup_watchdog(priv);
 
-	if (iwl_is_rfkill(priv->shrd))
+	if (iwl_is_rfkill(priv))
 		return -ERFKILL;
 
 	if (priv->event_log.ucode_trace) {
@@ -719,7 +719,7 @@ int iwl_alive_start(struct iwl_priv *priv)
 		iwl_reset_run_time_calib(priv);
 	}
 
-	set_bit(STATUS_READY, &priv->shrd->status);
+	set_bit(STATUS_READY, &priv->status);
 
 	/* Configure the adapter for unassociated operation */
 	ret = iwlagn_commit_rxon(priv, ctx);
@@ -786,7 +786,7 @@ void iwl_down(struct iwl_priv *priv)
 	ieee80211_remain_on_channel_expired(priv->hw);
 
 	exit_pending =
-		test_and_set_bit(STATUS_EXIT_PENDING, &priv->shrd->status);
+		test_and_set_bit(STATUS_EXIT_PENDING, &priv->status);
 
 	/* Stop TX queues watchdog. We need to have STATUS_EXIT_PENDING bit set
 	 * to prevent rearm timer */
@@ -811,7 +811,7 @@ void iwl_down(struct iwl_priv *priv)
 	/* Wipe out the EXIT_PENDING status bit if we are not actually
 	 * exiting the module */
 	if (!exit_pending)
-		clear_bit(STATUS_EXIT_PENDING, &priv->shrd->status);
+		clear_bit(STATUS_EXIT_PENDING, &priv->status);
 
 	if (priv->mac80211_registered)
 		ieee80211_stop_queues(priv->hw);
@@ -820,13 +820,13 @@ void iwl_down(struct iwl_priv *priv)
 
 	/* Clear out all status bits but a few that are stable across reset */
 	priv->shrd->status &=
-			test_bit(STATUS_RF_KILL_HW, &priv->shrd->status) <<
+			test_bit(STATUS_RF_KILL_HW, &priv->status) <<
 				STATUS_RF_KILL_HW |
-			test_bit(STATUS_GEO_CONFIGURED, &priv->shrd->status) <<
+			test_bit(STATUS_GEO_CONFIGURED, &priv->status) <<
 				STATUS_GEO_CONFIGURED |
 			test_bit(STATUS_FW_ERROR, &priv->shrd->status) <<
 				STATUS_FW_ERROR |
-			test_bit(STATUS_EXIT_PENDING, &priv->shrd->status) <<
+			test_bit(STATUS_EXIT_PENDING, &priv->status) <<
 				STATUS_EXIT_PENDING;
 
 	dev_kfree_skb(priv->beacon_skb);
@@ -846,8 +846,8 @@ static void iwl_bg_run_time_calib_work(struct work_struct *work)
 
 	mutex_lock(&priv->mutex);
 
-	if (test_bit(STATUS_EXIT_PENDING, &priv->shrd->status) ||
-	    test_bit(STATUS_SCANNING, &priv->shrd->status)) {
+	if (test_bit(STATUS_EXIT_PENDING, &priv->status) ||
+	    test_bit(STATUS_SCANNING, &priv->status)) {
 		mutex_unlock(&priv->mutex);
 		return;
 	}
@@ -903,7 +903,7 @@ static void iwl_bg_restart(struct work_struct *data)
 {
 	struct iwl_priv *priv = container_of(data, struct iwl_priv, restart);
 
-	if (test_bit(STATUS_EXIT_PENDING, &priv->shrd->status))
+	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return;
 
 	if (test_and_clear_bit(STATUS_FW_ERROR, &priv->shrd->status)) {
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index ede1852..eb96855 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -353,28 +353,23 @@ static inline void iwl_print_rx_config_cmd(struct iwl_priv *priv,
 
 /* status checks */
 
-static inline int iwl_is_ready(struct iwl_shared *shrd)
+static inline int iwl_is_ready(struct iwl_priv *priv)
 {
 	/* The adapter is 'ready' if READY and GEO_CONFIGURED bits are
 	 * set but EXIT_PENDING is not */
-	return test_bit(STATUS_READY, &shrd->status) &&
-	       test_bit(STATUS_GEO_CONFIGURED, &shrd->status) &&
-	       !test_bit(STATUS_EXIT_PENDING, &shrd->status);
+	return test_bit(STATUS_READY, &priv->status) &&
+	       test_bit(STATUS_GEO_CONFIGURED, &priv->status) &&
+	       !test_bit(STATUS_EXIT_PENDING, &priv->status);
 }
 
-static inline int iwl_is_alive(struct iwl_shared *shrd)
+static inline int iwl_is_alive(struct iwl_priv *priv)
 {
-	return test_bit(STATUS_ALIVE, &shrd->status);
+	return test_bit(STATUS_ALIVE, &priv->status);
 }
 
-static inline int iwl_is_rfkill_hw(struct iwl_shared *shrd)
+static inline int iwl_is_rfkill(struct iwl_priv *priv)
 {
-	return test_bit(STATUS_RF_KILL_HW, &shrd->status);
-}
-
-static inline int iwl_is_rfkill(struct iwl_shared *shrd)
-{
-	return iwl_is_rfkill_hw(shrd);
+	return test_bit(STATUS_RF_KILL_HW, &priv->status);
 }
 
 static inline int iwl_is_ctkill(struct iwl_priv *priv)
@@ -382,18 +377,18 @@ static inline int iwl_is_ctkill(struct iwl_priv *priv)
 	return test_bit(STATUS_CT_KILL, &priv->status);
 }
 
-static inline int iwl_is_ready_rf(struct iwl_shared *shrd)
+static inline int iwl_is_ready_rf(struct iwl_priv *priv)
 {
-	if (iwl_is_rfkill(shrd))
+	if (iwl_is_rfkill(priv))
 		return 0;
 
-	return iwl_is_ready(shrd);
+	return iwl_is_ready(priv);
 }
 
 #ifdef CONFIG_IWLWIFI_DEBUG
 #define IWL_DEBUG_QUIET_RFKILL(m, fmt, args...)	\
 do {									\
-	if (!iwl_is_rfkill((m)->shrd))					\
+	if (!iwl_is_rfkill((m)))					\
 		IWL_ERR(m, fmt, ##args);				\
 	else								\
 		__iwl_err(trans(m)->dev, true,				\
@@ -403,7 +398,7 @@ do {									\
 #else
 #define IWL_DEBUG_QUIET_RFKILL(m, fmt, args...)	\
 do {									\
-	if (!iwl_is_rfkill((m)->shrd))					\
+	if (!iwl_is_rfkill((m)))					\
 		IWL_ERR(m, fmt, ##args);				\
 	else								\
 		__iwl_err(trans(m)->dev, true, true, fmt, ##args);	\
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 6de2949..b94e23c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -113,7 +113,7 @@ int iwl_init_geos(struct iwl_priv *priv)
 	if (priv->bands[IEEE80211_BAND_2GHZ].n_bitrates ||
 	    priv->bands[IEEE80211_BAND_5GHZ].n_bitrates) {
 		IWL_DEBUG_INFO(priv, "Geography modes already initialized.\n");
-		set_bit(STATUS_GEO_CONFIGURED, &priv->shrd->status);
+		set_bit(STATUS_GEO_CONFIGURED, &priv->status);
 		return 0;
 	}
 
@@ -212,7 +212,7 @@ int iwl_init_geos(struct iwl_priv *priv)
 		   priv->bands[IEEE80211_BAND_2GHZ].n_channels,
 		   priv->bands[IEEE80211_BAND_5GHZ].n_channels);
 
-	set_bit(STATUS_GEO_CONFIGURED, &priv->shrd->status);
+	set_bit(STATUS_GEO_CONFIGURED, &priv->status);
 
 	return 0;
 }
@@ -224,7 +224,7 @@ void iwl_free_geos(struct iwl_priv *priv)
 {
 	kfree(priv->ieee_channels);
 	kfree(priv->ieee_rates);
-	clear_bit(STATUS_GEO_CONFIGURED, &priv->shrd->status);
+	clear_bit(STATUS_GEO_CONFIGURED, &priv->status);
 }
 
 static bool iwl_is_channel_extension(struct iwl_priv *priv,
@@ -798,11 +798,10 @@ void iwl_chswitch_done(struct iwl_priv *priv, bool is_success)
 	 */
 	struct iwl_rxon_context *ctx = &priv->contexts[IWL_RXON_CTX_BSS];
 
-	if (test_bit(STATUS_EXIT_PENDING, &priv->shrd->status))
+	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return;
 
-	if (test_and_clear_bit(STATUS_CHANNEL_SWITCH_PENDING,
-				&priv->shrd->status))
+	if (test_and_clear_bit(STATUS_CHANNEL_SWITCH_PENDING, &priv->status))
 		ieee80211_chswitch_done(ctx->vif, is_success);
 }
 
@@ -849,7 +848,7 @@ static void iwlagn_fw_error(struct iwl_priv *priv, bool ondemand)
 
 	/* Keep the restart process from trying to send host
 	 * commands by clearing the ready bit */
-	clear_bit(STATUS_READY, &priv->shrd->status);
+	clear_bit(STATUS_READY, &priv->status);
 
 	wake_up(&priv->shrd->wait_command_queue);
 
@@ -874,7 +873,7 @@ static void iwlagn_fw_error(struct iwl_priv *priv, bool ondemand)
 			priv->reload_count = 0;
 	}
 
-	if (!test_bit(STATUS_EXIT_PENDING, &priv->shrd->status)) {
+	if (!test_bit(STATUS_EXIT_PENDING, &priv->status)) {
 		if (iwlagn_mod_params.restart_fw) {
 			IWL_DEBUG_FW_ERRORS(priv,
 				  "Restarting adapter due to uCode error.\n");
@@ -912,7 +911,7 @@ int iwl_set_tx_power(struct iwl_priv *priv, s8 tx_power, bool force)
 		return -EINVAL;
 	}
 
-	if (!iwl_is_ready_rf(priv->shrd))
+	if (!iwl_is_ready_rf(priv))
 		return -EIO;
 
 	/* scan complete and commit_rxon use tx_power_next value,
@@ -920,7 +919,7 @@ int iwl_set_tx_power(struct iwl_priv *priv, s8 tx_power, bool force)
 	priv->tx_power_next = tx_power;
 
 	/* do not set tx power when scanning or channel changing */
-	defer = test_bit(STATUS_SCANNING, &priv->shrd->status) ||
+	defer = test_bit(STATUS_SCANNING, &priv->status) ||
 		memcmp(&ctx->active, &ctx->staging, sizeof(ctx->staging));
 	if (defer && !force) {
 		IWL_DEBUG_INFO(priv, "Deferring tx power set\n");
@@ -1219,7 +1218,7 @@ void iwl_update_stats(struct iwl_priv *priv, bool is_tx, __le16 fc, u16 len)
 
 static void iwl_force_rf_reset(struct iwl_priv *priv)
 {
-	if (test_bit(STATUS_EXIT_PENDING, &priv->shrd->status))
+	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return;
 
 	if (!iwl_is_any_associated(priv)) {
@@ -1244,7 +1243,7 @@ int iwl_force_reset(struct iwl_priv *priv, int mode, bool external)
 {
 	struct iwl_force_reset *force_reset;
 
-	if (test_bit(STATUS_EXIT_PENDING, &priv->shrd->status))
+	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return -EINVAL;
 
 	if (mode >= IWL_MAX_FORCE_RESET) {
@@ -1334,10 +1333,10 @@ void iwl_bg_watchdog(unsigned long data)
 	int cnt;
 	unsigned long timeout;
 
-	if (test_bit(STATUS_EXIT_PENDING, &priv->shrd->status))
+	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return;
 
-	if (iwl_is_rfkill(priv->shrd))
+	if (iwl_is_rfkill(priv))
 		return;
 
 	timeout = hw_params(priv).wd_timeout;
@@ -1472,9 +1471,9 @@ void iwl_set_hw_rfkill_state(struct iwl_op_mode *op_mode, bool state)
 	struct iwl_priv *priv = IWL_OP_MODE_GET_DVM(op_mode);
 
 	if (state)
-		set_bit(STATUS_RF_KILL_HW, &priv->shrd->status);
+		set_bit(STATUS_RF_KILL_HW, &priv->status);
 	else
-		clear_bit(STATUS_RF_KILL_HW, &priv->shrd->status);
+		clear_bit(STATUS_RF_KILL_HW, &priv->status);
 
 	wiphy_rfkill_set_hw_state(priv->hw->wiphy, state);
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index 71f8cc8..9b71c87 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -454,7 +454,7 @@ static ssize_t iwl_dbgfs_channels_read(struct file *file, char __user *user_buf,
 	char *buf;
 	ssize_t ret;
 
-	if (!test_bit(STATUS_GEO_CONFIGURED, &priv->shrd->status))
+	if (!test_bit(STATUS_GEO_CONFIGURED, &priv->status))
 		return -EAGAIN;
 
 	buf = kzalloc(bufsz, GFP_KERNEL);
@@ -525,28 +525,26 @@ static ssize_t iwl_dbgfs_status_read(struct file *file,
 
 	pos += scnprintf(buf + pos, bufsz - pos, "STATUS_HCMD_ACTIVE:\t %d\n",
 		test_bit(STATUS_HCMD_ACTIVE, &priv->shrd->status));
-	pos += scnprintf(buf + pos, bufsz - pos, "STATUS_INT_ENABLED:\t %d\n",
-		test_bit(STATUS_INT_ENABLED, &priv->shrd->status));
 	pos += scnprintf(buf + pos, bufsz - pos, "STATUS_RF_KILL_HW:\t %d\n",
-		test_bit(STATUS_RF_KILL_HW, &priv->shrd->status));
+		test_bit(STATUS_RF_KILL_HW, &priv->status));
 	pos += scnprintf(buf + pos, bufsz - pos, "STATUS_CT_KILL:\t\t %d\n",
 		test_bit(STATUS_CT_KILL, &priv->status));
 	pos += scnprintf(buf + pos, bufsz - pos, "STATUS_ALIVE:\t\t %d\n",
-		test_bit(STATUS_ALIVE, &priv->shrd->status));
+		test_bit(STATUS_ALIVE, &priv->status));
 	pos += scnprintf(buf + pos, bufsz - pos, "STATUS_READY:\t\t %d\n",
-		test_bit(STATUS_READY, &priv->shrd->status));
+		test_bit(STATUS_READY, &priv->status));
 	pos += scnprintf(buf + pos, bufsz - pos, "STATUS_GEO_CONFIGURED:\t %d\n",
-		test_bit(STATUS_GEO_CONFIGURED, &priv->shrd->status));
+		test_bit(STATUS_GEO_CONFIGURED, &priv->status));
 	pos += scnprintf(buf + pos, bufsz - pos, "STATUS_EXIT_PENDING:\t %d\n",
-		test_bit(STATUS_EXIT_PENDING, &priv->shrd->status));
+		test_bit(STATUS_EXIT_PENDING, &priv->status));
 	pos += scnprintf(buf + pos, bufsz - pos, "STATUS_STATISTICS:\t %d\n",
-		test_bit(STATUS_STATISTICS, &priv->shrd->status));
+		test_bit(STATUS_STATISTICS, &priv->status));
 	pos += scnprintf(buf + pos, bufsz - pos, "STATUS_SCANNING:\t %d\n",
-		test_bit(STATUS_SCANNING, &priv->shrd->status));
+		test_bit(STATUS_SCANNING, &priv->status));
 	pos += scnprintf(buf + pos, bufsz - pos, "STATUS_SCAN_ABORTING:\t %d\n",
-		test_bit(STATUS_SCAN_ABORTING, &priv->shrd->status));
+		test_bit(STATUS_SCAN_ABORTING, &priv->status));
 	pos += scnprintf(buf + pos, bufsz - pos, "STATUS_SCAN_HW:\t\t %d\n",
-		test_bit(STATUS_SCAN_HW, &priv->shrd->status));
+		test_bit(STATUS_SCAN_HW, &priv->status));
 	pos += scnprintf(buf + pos, bufsz - pos, "STATUS_POWER_PMI:\t %d\n",
 		test_bit(STATUS_POWER_PMI, &priv->shrd->status));
 	pos += scnprintf(buf + pos, bufsz - pos, "STATUS_FW_ERROR:\t %d\n",
@@ -752,7 +750,7 @@ static ssize_t iwl_dbgfs_sleep_level_override_write(struct file *file,
 	if (value != -1 && (value < 0 || value >= IWL_POWER_NUM))
 		return -EINVAL;
 
-	if (!iwl_is_ready_rf(priv->shrd))
+	if (!iwl_is_ready_rf(priv))
 		return -EAGAIN;
 
 	priv->power_data.debug_sleep_level_override = value;
@@ -947,7 +945,7 @@ static ssize_t iwl_dbgfs_ucode_rx_stats_read(struct file *file,
 	struct statistics_rx_non_phy *delta_general, *max_general;
 	struct statistics_rx_ht_phy *ht, *accum_ht, *delta_ht, *max_ht;
 
-	if (!iwl_is_alive(priv->shrd))
+	if (!iwl_is_alive(priv))
 		return -EAGAIN;
 
 	buf = kzalloc(bufsz, GFP_KERNEL);
@@ -1376,7 +1374,7 @@ static ssize_t iwl_dbgfs_ucode_tx_stats_read(struct file *file,
 	ssize_t ret;
 	struct statistics_tx *tx, *accum_tx, *delta_tx, *max_tx;
 
-	if (!iwl_is_alive(priv->shrd))
+	if (!iwl_is_alive(priv))
 		return -EAGAIN;
 
 	buf = kzalloc(bufsz, GFP_KERNEL);
@@ -1578,7 +1576,7 @@ static ssize_t iwl_dbgfs_ucode_general_stats_read(struct file *file,
 	struct statistics_dbg *dbg, *accum_dbg, *delta_dbg, *max_dbg;
 	struct statistics_div *div, *accum_div, *delta_div, *max_div;
 
-	if (!iwl_is_alive(priv->shrd))
+	if (!iwl_is_alive(priv))
 		return -EAGAIN;
 
 	buf = kzalloc(bufsz, GFP_KERNEL);
@@ -1697,7 +1695,7 @@ static ssize_t iwl_dbgfs_ucode_bt_stats_read(struct file *file,
 	ssize_t ret;
 	struct statistics_bt_activity *bt, *accum_bt;
 
-	if (!iwl_is_alive(priv->shrd))
+	if (!iwl_is_alive(priv))
 		return -EAGAIN;
 
 	if (!priv->bt_enable_flag)
@@ -1790,7 +1788,7 @@ static ssize_t iwl_dbgfs_reply_tx_error_read(struct file *file,
 		(sizeof(struct reply_agg_tx_error_statistics) * 24) + 200;
 	ssize_t ret;
 
-	if (!iwl_is_alive(priv->shrd))
+	if (!iwl_is_alive(priv))
 		return -EAGAIN;
 
 	buf = kzalloc(bufsz, GFP_KERNEL);
@@ -2148,7 +2146,7 @@ static ssize_t iwl_dbgfs_ucode_tracing_write(struct file *file,
 
 	if (trace) {
 		priv->event_log.ucode_trace = true;
-		if (iwl_is_alive(priv->shrd)) {
+		if (iwl_is_alive(priv)) {
 			/* start collecting data now */
 			mod_timer(&priv->ucode_trace, jiffies);
 		}
@@ -2338,7 +2336,7 @@ static ssize_t iwl_dbgfs_txfifo_flush_write(struct file *file,
 	if (sscanf(buf, "%d", &flush) != 1)
 		return -EINVAL;
 
-	if (iwl_is_rfkill(priv->shrd))
+	if (iwl_is_rfkill(priv))
 		return -EFAULT;
 
 	iwlagn_dev_txfifo_flush(priv, IWL_DROP_ALL);
diff --git a/drivers/net/wireless/iwlwifi/iwl-led.c b/drivers/net/wireless/iwlwifi/iwl-led.c
index f2f706f..1993a2b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-led.c
+++ b/drivers/net/wireless/iwlwifi/iwl-led.c
@@ -126,7 +126,7 @@ static int iwl_led_cmd(struct iwl_priv *priv,
 	};
 	int ret;
 
-	if (!test_bit(STATUS_READY, &priv->shrd->status))
+	if (!test_bit(STATUS_READY, &priv->status))
 		return -EBUSY;
 
 	if (priv->blink_on == on && priv->blink_off == off)
diff --git a/drivers/net/wireless/iwlwifi/iwl-mac80211.c b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
index dcf39f8..54d3709 100644
--- a/drivers/net/wireless/iwlwifi/iwl-mac80211.c
+++ b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
@@ -266,7 +266,7 @@ static int __iwl_up(struct iwl_priv *priv)
 
 	lockdep_assert_held(&priv->mutex);
 
-	if (test_bit(STATUS_EXIT_PENDING, &priv->shrd->status)) {
+	if (test_bit(STATUS_EXIT_PENDING, &priv->status)) {
 		IWL_WARN(priv, "Exit pending; will not bring the NIC up\n");
 		return -EIO;
 	}
@@ -297,9 +297,9 @@ static int __iwl_up(struct iwl_priv *priv)
 	return 0;
 
  error:
-	set_bit(STATUS_EXIT_PENDING, &priv->shrd->status);
+	set_bit(STATUS_EXIT_PENDING, &priv->status);
 	iwl_down(priv);
-	clear_bit(STATUS_EXIT_PENDING, &priv->shrd->status);
+	clear_bit(STATUS_EXIT_PENDING, &priv->status);
 
 	IWL_ERR(priv, "Unable to initialize device.\n");
 	return ret;
@@ -322,7 +322,7 @@ static int iwlagn_mac_start(struct ieee80211_hw *hw)
 	IWL_DEBUG_INFO(priv, "Start UP work done.\n");
 
 	/* Now we should be done, and the READY bit should be set. */
-	if (WARN_ON(!test_bit(STATUS_READY, &priv->shrd->status)))
+	if (WARN_ON(!test_bit(STATUS_READY, &priv->status)))
 		ret = -EIO;
 
 	iwlagn_led_enable(priv);
@@ -807,7 +807,7 @@ static int iwlagn_mac_sta_state(struct ieee80211_hw *hw,
 	 * mac80211 might WARN if we fail, but due the way we
 	 * (badly) handle hard rfkill, we might fail here
 	 */
-	if (iwl_is_rfkill(priv->shrd))
+	if (iwl_is_rfkill(priv))
 		ret = 0;
 
 	mutex_unlock(&priv->mutex);
@@ -839,12 +839,12 @@ static void iwlagn_mac_channel_switch(struct ieee80211_hw *hw,
 
 	mutex_lock(&priv->mutex);
 
-	if (iwl_is_rfkill(priv->shrd))
+	if (iwl_is_rfkill(priv))
 		goto out;
 
-	if (test_bit(STATUS_EXIT_PENDING, &priv->shrd->status) ||
-	    test_bit(STATUS_SCANNING, &priv->shrd->status) ||
-	    test_bit(STATUS_CHANNEL_SWITCH_PENDING, &priv->shrd->status))
+	if (test_bit(STATUS_EXIT_PENDING, &priv->status) ||
+	    test_bit(STATUS_SCANNING, &priv->status) ||
+	    test_bit(STATUS_CHANNEL_SWITCH_PENDING, &priv->status))
 		goto out;
 
 	if (!iwl_is_associated_ctx(ctx))
@@ -884,10 +884,10 @@ static void iwlagn_mac_channel_switch(struct ieee80211_hw *hw,
 	 * at this point, staging_rxon has the
 	 * configuration for channel switch
 	 */
-	set_bit(STATUS_CHANNEL_SWITCH_PENDING, &priv->shrd->status);
+	set_bit(STATUS_CHANNEL_SWITCH_PENDING, &priv->status);
 	priv->switch_channel = cpu_to_le16(ch);
 	if (cfg(priv)->lib->set_channel_switch(priv, ch_switch)) {
-		clear_bit(STATUS_CHANNEL_SWITCH_PENDING, &priv->shrd->status);
+		clear_bit(STATUS_CHANNEL_SWITCH_PENDING, &priv->status);
 		priv->switch_channel = 0;
 		ieee80211_chswitch_done(ctx->vif, false);
 	}
@@ -954,11 +954,11 @@ static void iwlagn_mac_flush(struct ieee80211_hw *hw, bool drop)
 	mutex_lock(&priv->mutex);
 	IWL_DEBUG_MAC80211(priv, "enter\n");
 
-	if (test_bit(STATUS_EXIT_PENDING, &priv->shrd->status)) {
+	if (test_bit(STATUS_EXIT_PENDING, &priv->status)) {
 		IWL_DEBUG_TX(priv, "Aborting flush due to device shutdown\n");
 		goto done;
 	}
-	if (iwl_is_rfkill(priv->shrd)) {
+	if (iwl_is_rfkill(priv)) {
 		IWL_DEBUG_TX(priv, "Aborting flush due to RF Kill\n");
 		goto done;
 	}
@@ -999,7 +999,7 @@ static int iwlagn_mac_remain_on_channel(struct ieee80211_hw *hw,
 	IWL_DEBUG_MAC80211(priv, "enter\n");
 	mutex_lock(&priv->mutex);
 
-	if (test_bit(STATUS_SCAN_HW, &priv->shrd->status)) {
+	if (test_bit(STATUS_SCAN_HW, &priv->status)) {
 		err = -EBUSY;
 		goto out;
 	}
@@ -1140,7 +1140,7 @@ static int iwlagn_mac_conf_tx(struct ieee80211_hw *hw,
 
 	IWL_DEBUG_MAC80211(priv, "enter\n");
 
-	if (!iwl_is_ready_rf(priv->shrd)) {
+	if (!iwl_is_ready_rf(priv)) {
 		IWL_DEBUG_MAC80211(priv, "leave - RF not ready\n");
 		return -EIO;
 	}
@@ -1241,7 +1241,7 @@ static int iwlagn_mac_add_interface(struct ieee80211_hw *hw,
 
 	iwlagn_disable_roc(priv);
 
-	if (!iwl_is_ready_rf(priv->shrd)) {
+	if (!iwl_is_ready_rf(priv)) {
 		IWL_WARN(priv, "Try to add interface when device not ready\n");
 		err = -EINVAL;
 		goto out;
@@ -1365,7 +1365,7 @@ static int iwlagn_mac_change_interface(struct ieee80211_hw *hw,
 
 	mutex_lock(&priv->mutex);
 
-	if (!ctx->vif || !iwl_is_ready_rf(priv->shrd)) {
+	if (!ctx->vif || !iwl_is_ready_rf(priv)) {
 		/*
 		 * Huh? But wait ... this can maybe happen when
 		 * we're in the middle of a firmware restart!
diff --git a/drivers/net/wireless/iwlwifi/iwl-power.c b/drivers/net/wireless/iwlwifi/iwl-power.c
index f79ff16..958d9d0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-power.c
+++ b/drivers/net/wireless/iwlwifi/iwl-power.c
@@ -392,12 +392,12 @@ int iwl_power_set_mode(struct iwl_priv *priv, struct iwl_powertable_cmd *cmd,
 	if (!memcmp(&priv->power_data.sleep_cmd, cmd, sizeof(*cmd)) && !force)
 		return 0;
 
-	if (!iwl_is_ready_rf(priv->shrd))
+	if (!iwl_is_ready_rf(priv))
 		return -EIO;
 
 	/* scan complete use sleep_power_next, need to be updated */
 	memcpy(&priv->power_data.sleep_cmd_next, cmd, sizeof(*cmd));
-	if (test_bit(STATUS_SCANNING, &priv->shrd->status) && !force) {
+	if (test_bit(STATUS_SCANNING, &priv->status) && !force) {
 		IWL_DEBUG_INFO(priv, "Defer power set mode while scanning\n");
 		return 0;
 	}
diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index 8c3fb32..902efe4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -66,9 +66,9 @@ static int iwl_send_scan_abort(struct iwl_priv *priv)
 	/* Exit instantly with error when device is not ready
 	 * to receive scan abort command or it does not perform
 	 * hardware scan currently */
-	if (!test_bit(STATUS_READY, &priv->shrd->status) ||
-	    !test_bit(STATUS_GEO_CONFIGURED, &priv->shrd->status) ||
-	    !test_bit(STATUS_SCAN_HW, &priv->shrd->status) ||
+	if (!test_bit(STATUS_READY, &priv->status) ||
+	    !test_bit(STATUS_GEO_CONFIGURED, &priv->status) ||
+	    !test_bit(STATUS_SCAN_HW, &priv->status) ||
 	    test_bit(STATUS_FW_ERROR, &priv->shrd->status))
 		return -EIO;
 
@@ -118,18 +118,18 @@ static void iwl_process_scan_complete(struct iwl_priv *priv)
 
 	lockdep_assert_held(&priv->mutex);
 
-	if (!test_and_clear_bit(STATUS_SCAN_COMPLETE, &priv->shrd->status))
+	if (!test_and_clear_bit(STATUS_SCAN_COMPLETE, &priv->status))
 		return;
 
 	IWL_DEBUG_SCAN(priv, "Completed scan.\n");
 
 	cancel_delayed_work(&priv->scan_check);
 
-	aborted = test_and_clear_bit(STATUS_SCAN_ABORTING, &priv->shrd->status);
+	aborted = test_and_clear_bit(STATUS_SCAN_ABORTING, &priv->status);
 	if (aborted)
 		IWL_DEBUG_SCAN(priv, "Aborted scan completed.\n");
 
-	if (!test_and_clear_bit(STATUS_SCANNING, &priv->shrd->status)) {
+	if (!test_and_clear_bit(STATUS_SCANNING, &priv->status)) {
 		IWL_DEBUG_SCAN(priv, "Scan already completed.\n");
 		goto out_settings;
 	}
@@ -165,7 +165,7 @@ out_complete:
 
 out_settings:
 	/* Can we still talk to firmware ? */
-	if (!iwl_is_ready_rf(priv->shrd))
+	if (!iwl_is_ready_rf(priv))
 		return;
 
 	iwlagn_post_scan(priv);
@@ -175,16 +175,16 @@ void iwl_force_scan_end(struct iwl_priv *priv)
 {
 	lockdep_assert_held(&priv->mutex);
 
-	if (!test_bit(STATUS_SCANNING, &priv->shrd->status)) {
+	if (!test_bit(STATUS_SCANNING, &priv->status)) {
 		IWL_DEBUG_SCAN(priv, "Forcing scan end while not scanning\n");
 		return;
 	}
 
 	IWL_DEBUG_SCAN(priv, "Forcing scan end\n");
-	clear_bit(STATUS_SCANNING, &priv->shrd->status);
-	clear_bit(STATUS_SCAN_HW, &priv->shrd->status);
-	clear_bit(STATUS_SCAN_ABORTING, &priv->shrd->status);
-	clear_bit(STATUS_SCAN_COMPLETE, &priv->shrd->status);
+	clear_bit(STATUS_SCANNING, &priv->status);
+	clear_bit(STATUS_SCAN_HW, &priv->status);
+	clear_bit(STATUS_SCAN_ABORTING, &priv->status);
+	clear_bit(STATUS_SCAN_COMPLETE, &priv->status);
 	iwl_complete_scan(priv, true);
 }
 
@@ -194,12 +194,12 @@ static void iwl_do_scan_abort(struct iwl_priv *priv)
 
 	lockdep_assert_held(&priv->mutex);
 
-	if (!test_bit(STATUS_SCANNING, &priv->shrd->status)) {
+	if (!test_bit(STATUS_SCANNING, &priv->status)) {
 		IWL_DEBUG_SCAN(priv, "Not performing scan to abort\n");
 		return;
 	}
 
-	if (test_and_set_bit(STATUS_SCAN_ABORTING, &priv->shrd->status)) {
+	if (test_and_set_bit(STATUS_SCAN_ABORTING, &priv->status)) {
 		IWL_DEBUG_SCAN(priv, "Scan abort in progress\n");
 		return;
 	}
@@ -238,7 +238,7 @@ void iwl_scan_cancel_timeout(struct iwl_priv *priv, unsigned long ms)
 	iwl_do_scan_abort(priv);
 
 	while (time_before_eq(jiffies, timeout)) {
-		if (!test_bit(STATUS_SCAN_HW, &priv->shrd->status))
+		if (!test_bit(STATUS_SCAN_HW, &priv->status))
 			goto finished;
 		msleep(20);
 	}
@@ -350,8 +350,8 @@ static int iwl_rx_scan_complete_notif(struct iwl_priv *priv,
 	 * to clear, we need to set SCAN_COMPLETE before clearing SCAN_HW
 	 * to avoid a race there.
 	 */
-	set_bit(STATUS_SCAN_COMPLETE, &priv->shrd->status);
-	clear_bit(STATUS_SCAN_HW, &priv->shrd->status);
+	set_bit(STATUS_SCAN_COMPLETE, &priv->status);
+	clear_bit(STATUS_SCAN_HW, &priv->status);
 	queue_work(priv->workqueue, &priv->scan_completed);
 
 	if (priv->iw_mode != NL80211_IFTYPE_ADHOC &&
@@ -927,7 +927,7 @@ static int iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 	scan->len = cpu_to_le16(cmd.len[0]);
 
 	/* set scan bit here for PAN params */
-	set_bit(STATUS_SCAN_HW, &priv->shrd->status);
+	set_bit(STATUS_SCAN_HW, &priv->status);
 
 	ret = iwlagn_set_pan_params(priv);
 	if (ret)
@@ -935,7 +935,7 @@ static int iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 
 	ret = iwl_dvm_send_cmd(priv, &cmd);
 	if (ret) {
-		clear_bit(STATUS_SCAN_HW, &priv->shrd->status);
+		clear_bit(STATUS_SCAN_HW, &priv->status);
 		iwlagn_set_pan_params(priv);
 	}
 
@@ -962,18 +962,18 @@ int __must_check iwl_scan_initiate(struct iwl_priv *priv,
 
 	cancel_delayed_work(&priv->scan_check);
 
-	if (!iwl_is_ready_rf(priv->shrd)) {
+	if (!iwl_is_ready_rf(priv)) {
 		IWL_WARN(priv, "Request scan called when driver not ready.\n");
 		return -EIO;
 	}
 
-	if (test_bit(STATUS_SCAN_HW, &priv->shrd->status)) {
+	if (test_bit(STATUS_SCAN_HW, &priv->status)) {
 		IWL_DEBUG_SCAN(priv,
 			"Multiple concurrent scan requests in parallel.\n");
 		return -EBUSY;
 	}
 
-	if (test_bit(STATUS_SCAN_ABORTING, &priv->shrd->status)) {
+	if (test_bit(STATUS_SCAN_ABORTING, &priv->status)) {
 		IWL_DEBUG_SCAN(priv, "Scan request while abort pending.\n");
 		return -EBUSY;
 	}
@@ -983,14 +983,14 @@ int __must_check iwl_scan_initiate(struct iwl_priv *priv,
 			scan_type == IWL_SCAN_ROC ? "remain-on-channel " :
 			"internal short ");
 
-	set_bit(STATUS_SCANNING, &priv->shrd->status);
+	set_bit(STATUS_SCANNING, &priv->status);
 	priv->scan_type = scan_type;
 	priv->scan_start = jiffies;
 	priv->scan_band = band;
 
 	ret = iwlagn_request_scan(priv, vif);
 	if (ret) {
-		clear_bit(STATUS_SCANNING, &priv->shrd->status);
+		clear_bit(STATUS_SCANNING, &priv->status);
 		priv->scan_type = IWL_SCAN_NORMAL;
 		return ret;
 	}
@@ -1025,7 +1025,7 @@ static void iwl_bg_start_internal_scan(struct work_struct *work)
 		goto unlock;
 	}
 
-	if (test_bit(STATUS_SCANNING, &priv->shrd->status)) {
+	if (test_bit(STATUS_SCANNING, &priv->status)) {
 		IWL_DEBUG_SCAN(priv, "Scan already in progress.\n");
 		goto unlock;
 	}
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
index 16a32ae..dd64e69 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
@@ -356,7 +356,8 @@ void iwl_dump_csr(struct iwl_trans *trans);
 ******************************************************/
 static inline void iwl_disable_interrupts(struct iwl_trans *trans)
 {
-	clear_bit(STATUS_INT_ENABLED, &trans->shrd->status);
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+	clear_bit(STATUS_INT_ENABLED, &trans_pcie->status);
 
 	/* disable interrupts from uCode/NIC to host */
 	iwl_write32(trans, CSR_INT_MASK, 0x00000000);
@@ -370,11 +371,10 @@ static inline void iwl_disable_interrupts(struct iwl_trans *trans)
 
 static inline void iwl_enable_interrupts(struct iwl_trans *trans)
 {
-	struct iwl_trans_pcie *trans_pcie =
-		IWL_TRANS_GET_PCIE_TRANS(trans);
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 
 	IWL_DEBUG_ISR(trans, "Enabling interrupts\n");
-	set_bit(STATUS_INT_ENABLED, &trans->shrd->status);
+	set_bit(STATUS_INT_ENABLED, &trans_pcie->status);
 	iwl_write32(trans, CSR_INT_MASK, trans_pcie->inta_mask);
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
index 3eb7bd1..17e1487 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
@@ -1131,7 +1131,7 @@ void iwl_irq_tasklet(struct iwl_trans *trans)
 
 	/* Re-enable all interrupts */
 	/* only Re-enable if disabled by irq */
-	if (test_bit(STATUS_INT_ENABLED, &trans->shrd->status))
+	if (test_bit(STATUS_INT_ENABLED, &trans_pcie->status))
 		iwl_enable_interrupts(trans);
 	/* Re-enable RF_KILL if it occurred */
 	else if (handled & CSR_INT_BIT_RF_KILL)
@@ -1303,7 +1303,7 @@ static irqreturn_t iwl_isr(int irq, void *data)
 	/* iwl_irq_tasklet() will service interrupts and re-enable them */
 	if (likely(inta))
 		tasklet_schedule(&trans_pcie->irq_tasklet);
-	else if (test_bit(STATUS_INT_ENABLED, &trans->shrd->status) &&
+	else if (test_bit(STATUS_INT_ENABLED, &trans_pcie->status) &&
 			!trans_pcie->inta)
 		iwl_enable_interrupts(trans);
 
@@ -1314,7 +1314,7 @@ static irqreturn_t iwl_isr(int irq, void *data)
  none:
 	/* re-enable interrupts here since we don't have anything to service. */
 	/* only Re-enable if disabled by irq  and no schedules tasklet. */
-	if (test_bit(STATUS_INT_ENABLED, &trans->shrd->status) &&
+	if (test_bit(STATUS_INT_ENABLED, &trans_pcie->status) &&
 		!trans_pcie->inta)
 		iwl_enable_interrupts(trans);
 
@@ -1414,7 +1414,7 @@ irqreturn_t iwl_isr_ict(int irq, void *data)
 	/* iwl_irq_tasklet() will service interrupts and re-enable them */
 	if (likely(inta))
 		tasklet_schedule(&trans_pcie->irq_tasklet);
-	else if (test_bit(STATUS_INT_ENABLED, &trans->shrd->status) &&
+	else if (test_bit(STATUS_INT_ENABLED, &trans_pcie->status) &&
 		 !trans_pcie->inta) {
 		/* Allow interrupt if was disabled by this handler and
 		 * no tasklet was schedules, We should not enable interrupt,
@@ -1430,7 +1430,7 @@ irqreturn_t iwl_isr_ict(int irq, void *data)
 	/* re-enable interrupts here since we don't have anything to service.
 	 * only Re-enable if disabled by irq.
 	 */
-	if (test_bit(STATUS_INT_ENABLED, &trans->shrd->status) &&
+	if (test_bit(STATUS_INT_ENABLED, &trans_pcie->status) &&
 	    !trans_pcie->inta)
 		iwl_enable_interrupts(trans);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
index 4e56c3b..b0d34f7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -691,6 +691,7 @@ static void iwl_apm_config(struct iwl_trans *trans)
  */
 static int iwl_apm_init(struct iwl_trans *trans)
 {
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	int ret = 0;
 	IWL_DEBUG_INFO(trans, "Init card's basic functions\n");
 
@@ -760,7 +761,7 @@ static int iwl_apm_init(struct iwl_trans *trans)
 	iwl_set_bits_prph(trans, APMG_PCIDEV_STT_REG,
 			  APMG_PCIDEV_STT_VAL_L1_ACT_DIS);
 
-	set_bit(STATUS_DEVICE_ENABLED, &trans->shrd->status);
+	set_bit(STATUS_DEVICE_ENABLED, &trans_pcie->status);
 
 out:
 	return ret;
@@ -786,9 +787,10 @@ static int iwl_apm_stop_master(struct iwl_trans *trans)
 
 static void iwl_apm_stop(struct iwl_trans *trans)
 {
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	IWL_DEBUG_INFO(trans, "Stop card, put in low power state\n");
 
-	clear_bit(STATUS_DEVICE_ENABLED, &trans->shrd->status);
+	clear_bit(STATUS_DEVICE_ENABLED, &trans_pcie->status);
 
 	/* Stop device's DMA activity */
 	iwl_apm_stop_master(trans);
@@ -1274,7 +1276,7 @@ static void iwl_trans_pcie_stop_device(struct iwl_trans *trans)
 	 * restart. So don't process again if the device is
 	 * already dead.
 	 */
-	if (test_bit(STATUS_DEVICE_ENABLED, &trans->shrd->status)) {
+	if (test_bit(STATUS_DEVICE_ENABLED, &trans_pcie->status)) {
 		iwl_trans_tx_stop(trans);
 #ifndef CONFIG_IWLWIFI_IDI
 		iwl_trans_rx_stop(trans);
-- 
1.7.0.4

