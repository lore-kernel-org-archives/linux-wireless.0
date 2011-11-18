Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62837 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756682Ab1KRIWV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Nov 2011 03:22:21 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pAI8MKLe032385
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-wireless@vger.kernel.org>; Fri, 18 Nov 2011 03:22:20 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 41/77] iwlegacy: s/STATUS_/S_/
Date: Fri, 18 Nov 2011 09:22:03 +0100
Message-Id: <1321604559-10707-41-git-send-email-sgruszka@redhat.com> (sfid-20111118_092229_270127_C8D2B452)
In-Reply-To: <1321604559-10707-1-git-send-email-sgruszka@redhat.com>
References: <1321604559-10707-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/3945-mac.c    |   98 ++++++++++----------
 drivers/net/wireless/iwlegacy/3945.c        |   10 +-
 drivers/net/wireless/iwlegacy/4965-mac.c    |  134 +++++++++++++-------------
 drivers/net/wireless/iwlegacy/4965.c        |   18 ++--
 drivers/net/wireless/iwlegacy/iwl-core.c    |   40 ++++----
 drivers/net/wireless/iwlegacy/iwl-core.h    |   50 +++++-----
 drivers/net/wireless/iwlegacy/iwl-debugfs.c |   66 +++++++-------
 drivers/net/wireless/iwlegacy/iwl-hcmd.c    |   14 ++--
 drivers/net/wireless/iwlegacy/iwl-helpers.h |    4 +-
 drivers/net/wireless/iwlegacy/iwl-led.c     |    2 +-
 drivers/net/wireless/iwlegacy/iwl-power.c   |    6 +-
 drivers/net/wireless/iwlegacy/iwl-rx.c      |    2 +-
 drivers/net/wireless/iwlegacy/iwl-scan.c    |   42 ++++----
 drivers/net/wireless/iwlegacy/iwl-tx.c      |    4 +-
 14 files changed, 245 insertions(+), 245 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/3945-mac.c b/drivers/net/wireless/iwlegacy/3945-mac.c
index 17edbdf..f69211e 100644
--- a/drivers/net/wireless/iwlegacy/3945-mac.c
+++ b/drivers/net/wireless/iwlegacy/3945-mac.c
@@ -827,17 +827,17 @@ static void il3945_rx_card_state_notif(struct il_priv *il,
 		    CSR_UCODE_DRV_GP1_BIT_CMD_BLOCKED);
 
 	if (flags & HW_CARD_DISABLED)
-		set_bit(STATUS_RF_KILL_HW, &il->status);
+		set_bit(S_RF_KILL_HW, &il->status);
 	else
-		clear_bit(STATUS_RF_KILL_HW, &il->status);
+		clear_bit(S_RF_KILL_HW, &il->status);
 
 
 	il_scan_cancel(il);
 
-	if ((test_bit(STATUS_RF_KILL_HW, &status) !=
-	     test_bit(STATUS_RF_KILL_HW, &il->status)))
+	if ((test_bit(S_RF_KILL_HW, &status) !=
+	     test_bit(S_RF_KILL_HW, &il->status)))
 		wiphy_rfkill_set_hw_state(il->hw->wiphy,
-				test_bit(STATUS_RF_KILL_HW, &il->status));
+				test_bit(S_RF_KILL_HW, &il->status));
 	else
 		wake_up(&il->wait_command_queue);
 }
@@ -1537,7 +1537,7 @@ static void il3945_irq_tasklet(struct il_priv *il)
 
 	/* Re-enable all interrupts */
 	/* only Re-enable if disabled by irq */
-	if (test_bit(STATUS_INT_ENABLED, &il->status))
+	if (test_bit(S_INT_ENABLED, &il->status))
 		il_enable_interrupts(il);
 
 #ifdef CONFIG_IWLEGACY_DEBUG
@@ -2213,7 +2213,7 @@ static void il3945_alive_start(struct il_priv *il)
 	D_INFO("RFKILL status: 0x%x\n", rfkill);
 
 	if (rfkill & 0x1) {
-		clear_bit(STATUS_RF_KILL_HW, &il->status);
+		clear_bit(S_RF_KILL_HW, &il->status);
 		/* if RFKILL is not on, then wait for thermal
 		 * sensor in adapter to kick in */
 		while (il3945_hw_get_temperature(il) == 0) {
@@ -2225,10 +2225,10 @@ static void il3945_alive_start(struct il_priv *il)
 			D_INFO("Thermal calibration took %dus\n",
 				       thermal_spin * 10);
 	} else
-		set_bit(STATUS_RF_KILL_HW, &il->status);
+		set_bit(S_RF_KILL_HW, &il->status);
 
 	/* After the ALIVE response, we can send commands to 3945 uCode */
-	set_bit(STATUS_ALIVE, &il->status);
+	set_bit(S_ALIVE, &il->status);
 
 	/* Enable watchdog to monitor the driver tx queues */
 	il_setup_watchdog(il);
@@ -2256,7 +2256,7 @@ static void il3945_alive_start(struct il_priv *il)
 	/* Configure Bluetooth device coexistence support */
 	il_send_bt_config(il);
 
-	set_bit(STATUS_READY, &il->status);
+	set_bit(S_READY, &il->status);
 
 	/* Configure the adapter for unassociated operation */
 	il3945_commit_rxon(il, ctx);
@@ -2283,9 +2283,9 @@ static void __il3945_down(struct il_priv *il)
 
 	il_scan_cancel_timeout(il, 200);
 
-	exit_pending = test_and_set_bit(STATUS_EXIT_PENDING, &il->status);
+	exit_pending = test_and_set_bit(S_EXIT_PENDING, &il->status);
 
-	/* Stop TX queues watchdog. We need to have STATUS_EXIT_PENDING bit set
+	/* Stop TX queues watchdog. We need to have S_EXIT_PENDING bit set
 	 * to prevent rearm timer */
 	del_timer_sync(&il->watchdog);
 
@@ -2300,7 +2300,7 @@ static void __il3945_down(struct il_priv *il)
 	/* Wipe out the EXIT_PENDING status bit if we are not actually
 	 * exiting the module */
 	if (!exit_pending)
-		clear_bit(STATUS_EXIT_PENDING, &il->status);
+		clear_bit(S_EXIT_PENDING, &il->status);
 
 	/* stop and reset the on-board processor */
 	_il_wr(il, CSR_RESET, CSR_RESET_REG_FLAG_NEVO_RESET);
@@ -2317,25 +2317,25 @@ static void __il3945_down(struct il_priv *il)
 	/* If we have not previously called il3945_init() then
 	 * clear all bits but the RF Kill bits and return */
 	if (!il_is_init(il)) {
-		il->status = test_bit(STATUS_RF_KILL_HW, &il->status) <<
-					STATUS_RF_KILL_HW |
-			       test_bit(STATUS_GEO_CONFIGURED, &il->status) <<
-					STATUS_GEO_CONFIGURED |
-				test_bit(STATUS_EXIT_PENDING, &il->status) <<
-					STATUS_EXIT_PENDING;
+		il->status = test_bit(S_RF_KILL_HW, &il->status) <<
+					S_RF_KILL_HW |
+			       test_bit(S_GEO_CONFIGURED, &il->status) <<
+					S_GEO_CONFIGURED |
+				test_bit(S_EXIT_PENDING, &il->status) <<
+					S_EXIT_PENDING;
 		goto exit;
 	}
 
 	/* ...otherwise clear out all the status bits but the RF Kill
 	 * bit and continue taking the NIC down. */
-	il->status &= test_bit(STATUS_RF_KILL_HW, &il->status) <<
-				STATUS_RF_KILL_HW |
-			test_bit(STATUS_GEO_CONFIGURED, &il->status) <<
-				STATUS_GEO_CONFIGURED |
-			test_bit(STATUS_FW_ERROR, &il->status) <<
-				STATUS_FW_ERROR |
-			test_bit(STATUS_EXIT_PENDING, &il->status) <<
-				STATUS_EXIT_PENDING;
+	il->status &= test_bit(S_RF_KILL_HW, &il->status) <<
+				S_RF_KILL_HW |
+			test_bit(S_GEO_CONFIGURED, &il->status) <<
+				S_GEO_CONFIGURED |
+			test_bit(S_FW_ERROR, &il->status) <<
+				S_FW_ERROR |
+			test_bit(S_EXIT_PENDING, &il->status) <<
+				S_EXIT_PENDING;
 
 	il3945_hw_txq_ctx_stop(il);
 	il3945_hw_rxq_stop(il);
@@ -2400,7 +2400,7 @@ static int __il3945_up(struct il_priv *il)
 	if (rc)
 		return rc;
 
-	if (test_bit(STATUS_EXIT_PENDING, &il->status)) {
+	if (test_bit(S_EXIT_PENDING, &il->status)) {
 		IL_WARN("Exit pending; will not bring the NIC up\n");
 		return -EIO;
 	}
@@ -2413,9 +2413,9 @@ static int __il3945_up(struct il_priv *il)
 	/* If platform's RF_KILL switch is NOT set to KILL */
 	if (_il_rd(il, CSR_GP_CNTRL) &
 				CSR_GP_CNTRL_REG_FLAG_HW_RF_KILL_SW)
-		clear_bit(STATUS_RF_KILL_HW, &il->status);
+		clear_bit(S_RF_KILL_HW, &il->status);
 	else {
-		set_bit(STATUS_RF_KILL_HW, &il->status);
+		set_bit(S_RF_KILL_HW, &il->status);
 		IL_WARN("Radio disabled by HW RF Kill switch\n");
 		return -ENODEV;
 	}
@@ -2448,7 +2448,7 @@ static int __il3945_up(struct il_priv *il)
 	       il->ucode_data.len);
 
 	/* We return success when we resume from suspend and rf_kill is on. */
-	if (test_bit(STATUS_RF_KILL_HW, &il->status))
+	if (test_bit(S_RF_KILL_HW, &il->status))
 		return 0;
 
 	for (i = 0; i < MAX_HW_RESTARTS; i++) {
@@ -2472,9 +2472,9 @@ static int __il3945_up(struct il_priv *il)
 		return 0;
 	}
 
-	set_bit(STATUS_EXIT_PENDING, &il->status);
+	set_bit(S_EXIT_PENDING, &il->status);
 	__il3945_down(il);
-	clear_bit(STATUS_EXIT_PENDING, &il->status);
+	clear_bit(S_EXIT_PENDING, &il->status);
 
 	/* tried to restart and config the device for as long as our
 	 * patience could withstand */
@@ -2495,7 +2495,7 @@ static void il3945_bg_init_alive_start(struct work_struct *data)
 	    container_of(data, struct il_priv, init_alive_start.work);
 
 	mutex_lock(&il->mutex);
-	if (test_bit(STATUS_EXIT_PENDING, &il->status))
+	if (test_bit(S_EXIT_PENDING, &il->status))
 		goto out;
 
 	il3945_init_alive_start(il);
@@ -2509,7 +2509,7 @@ static void il3945_bg_alive_start(struct work_struct *data)
 	    container_of(data, struct il_priv, alive_start.work);
 
 	mutex_lock(&il->mutex);
-	if (test_bit(STATUS_EXIT_PENDING, &il->status))
+	if (test_bit(S_EXIT_PENDING, &il->status))
 		goto out;
 
 	il3945_alive_start(il);
@@ -2527,15 +2527,15 @@ static void il3945_rfkill_poll(struct work_struct *data)
 {
 	struct il_priv *il =
 	    container_of(data, struct il_priv, _3945.rfkill_poll.work);
-	bool old_rfkill = test_bit(STATUS_RF_KILL_HW, &il->status);
+	bool old_rfkill = test_bit(S_RF_KILL_HW, &il->status);
 	bool new_rfkill = !(_il_rd(il, CSR_GP_CNTRL)
 			& CSR_GP_CNTRL_REG_FLAG_HW_RF_KILL_SW);
 
 	if (new_rfkill != old_rfkill) {
 		if (new_rfkill)
-			set_bit(STATUS_RF_KILL_HW, &il->status);
+			set_bit(S_RF_KILL_HW, &il->status);
 		else
-			clear_bit(STATUS_RF_KILL_HW, &il->status);
+			clear_bit(S_RF_KILL_HW, &il->status);
 
 		wiphy_rfkill_set_hw_state(il->hw->wiphy, new_rfkill);
 
@@ -2682,10 +2682,10 @@ int il3945_request_scan(struct il_priv *il, struct ieee80211_vif *vif)
 	cmd.data = scan;
 	scan->len = cpu_to_le16(cmd.len);
 
-	set_bit(STATUS_SCAN_HW, &il->status);
+	set_bit(S_SCAN_HW, &il->status);
 	ret = il_send_cmd_sync(il, &cmd);
 	if (ret)
-		clear_bit(STATUS_SCAN_HW, &il->status);
+		clear_bit(S_SCAN_HW, &il->status);
 	return ret;
 }
 
@@ -2705,10 +2705,10 @@ static void il3945_bg_restart(struct work_struct *data)
 {
 	struct il_priv *il = container_of(data, struct il_priv, restart);
 
-	if (test_bit(STATUS_EXIT_PENDING, &il->status))
+	if (test_bit(S_EXIT_PENDING, &il->status))
 		return;
 
-	if (test_and_clear_bit(STATUS_FW_ERROR, &il->status)) {
+	if (test_and_clear_bit(S_FW_ERROR, &il->status)) {
 		mutex_lock(&il->mutex);
 		il->ctx.vif = NULL;
 		il->is_open = 0;
@@ -2719,7 +2719,7 @@ static void il3945_bg_restart(struct work_struct *data)
 		il3945_down(il);
 
 		mutex_lock(&il->mutex);
-		if (test_bit(STATUS_EXIT_PENDING, &il->status)) {
+		if (test_bit(S_EXIT_PENDING, &il->status)) {
 			mutex_unlock(&il->mutex);
 			return;
 		}
@@ -2735,7 +2735,7 @@ static void il3945_bg_rx_replenish(struct work_struct *data)
 	    container_of(data, struct il_priv, rx_replenish);
 
 	mutex_lock(&il->mutex);
-	if (test_bit(STATUS_EXIT_PENDING, &il->status))
+	if (test_bit(S_EXIT_PENDING, &il->status))
 		goto out;
 
 	il3945_rx_replenish(il);
@@ -2755,7 +2755,7 @@ void il3945_post_associate(struct il_priv *il)
 	D_ASSOC("Associated as %d to: %pM\n",
 			ctx->vif->bss_conf.aid, ctx->active.bssid_addr);
 
-	if (test_bit(STATUS_EXIT_PENDING, &il->status))
+	if (test_bit(S_EXIT_PENDING, &il->status))
 		return;
 
 	il_scan_cancel_timeout(il, 200);
@@ -2847,10 +2847,10 @@ static int il3945_mac_start(struct ieee80211_hw *hw)
 	/* Wait for START_ALIVE from ucode. Otherwise callbacks from
 	 * mac80211 will not be run successfully. */
 	ret = wait_event_timeout(il->wait_command_queue,
-			test_bit(STATUS_READY, &il->status),
+			test_bit(S_READY, &il->status),
 			UCODE_READY_TIMEOUT);
 	if (!ret) {
-		if (!test_bit(STATUS_READY, &il->status)) {
+		if (!test_bit(S_READY, &il->status)) {
 			IL_ERR(
 				"Wait for START_ALIVE timeout after %dms.\n",
 				jiffies_to_msecs(UCODE_READY_TIMEOUT));
@@ -2918,7 +2918,7 @@ void il3945_config_ap(struct il_priv *il)
 	struct ieee80211_vif *vif = ctx->vif;
 	int rc = 0;
 
-	if (test_bit(STATUS_EXIT_PENDING, &il->status))
+	if (test_bit(S_EXIT_PENDING, &il->status))
 		return;
 
 	/* The following should be done only at AP bring up */
@@ -3870,7 +3870,7 @@ static void __devexit il3945_pci_remove(struct pci_dev *pdev)
 
 	il_dbgfs_unregister(il);
 
-	set_bit(STATUS_EXIT_PENDING, &il->status);
+	set_bit(S_EXIT_PENDING, &il->status);
 
 	il_leds_exit(il);
 
diff --git a/drivers/net/wireless/iwlegacy/3945.c b/drivers/net/wireless/iwlegacy/3945.c
index 17615c3..8ebd576 100644
--- a/drivers/net/wireless/iwlegacy/3945.c
+++ b/drivers/net/wireless/iwlegacy/3945.c
@@ -1008,7 +1008,7 @@ int il3945_hw_nic_init(struct il_priv *il)
 	if (rc)
 		return rc;
 
-	set_bit(STATUS_INIT, &il->status);
+	set_bit(S_INIT, &il->status);
 
 	return 0;
 }
@@ -1394,7 +1394,7 @@ static int il3945_send_tx_power(struct il_priv *il)
 	};
 	u16 chan;
 
-	if (WARN_ONCE(test_bit(STATUS_SCAN_HW, &il->status),
+	if (WARN_ONCE(test_bit(S_SCAN_HW, &il->status),
 		      "TX Power requested while scanning!\n"))
 		return -EAGAIN;
 
@@ -1571,7 +1571,7 @@ static int il3945_hw_reg_comp_txpower_temp(struct il_priv *il)
 	int temperature = il->temperature;
 
 	if (il->disable_tx_power_cal ||
-	    test_bit(STATUS_SCANNING, &il->status)) {
+	    test_bit(S_SCANNING, &il->status)) {
 		/* do not perform tx power calibration */
 		return 0;
 	}
@@ -1726,7 +1726,7 @@ int il3945_commit_rxon(struct il_priv *il, struct il_rxon_context *ctx)
 	int rc = 0;
 	bool new_assoc = !!(staging_rxon->filter_flags & RXON_FILTER_ASSOC_MSK);
 
-	if (test_bit(STATUS_EXIT_PENDING, &il->status))
+	if (test_bit(S_EXIT_PENDING, &il->status))
 		return -EINVAL;
 
 	if (!il_is_alive(il))
@@ -1885,7 +1885,7 @@ static void il3945_bg_reg_txpower_periodic(struct work_struct *work)
 	struct il_priv *il = container_of(work, struct il_priv,
 					     _3945.thermal_periodic.work);
 
-	if (test_bit(STATUS_EXIT_PENDING, &il->status))
+	if (test_bit(S_EXIT_PENDING, &il->status))
 		return;
 
 	mutex_lock(&il->mutex);
diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index ee084a8..c4198bd 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -90,7 +90,7 @@ void il4965_check_abort_status(struct il_priv *il,
 {
 	if (frame_count == 1 && status == TX_STATUS_FAIL_RFKILL_FLUSH) {
 		IL_ERR("Tx flush command to flush out all frames\n");
-		if (!test_bit(STATUS_EXIT_PENDING, &il->status))
+		if (!test_bit(S_EXIT_PENDING, &il->status))
 			queue_work(il->workqueue, &il->tx_flush);
 	}
 }
@@ -246,7 +246,7 @@ int il4965_hw_nic_init(struct il_priv *il)
 	} else
 		il4965_txq_ctx_reset(il);
 
-	set_bit(STATUS_INIT, &il->status);
+	set_bit(S_INIT, &il->status);
 
 	return 0;
 }
@@ -966,7 +966,7 @@ int il4965_request_scan(struct il_priv *il, struct ieee80211_vif *vif)
 	scan->tx_cmd.rate_n_flags = il4965_hw_set_rate_n_flags(rate, rate_flags);
 
 	/* In power save mode use one chain, otherwise use all chains */
-	if (test_bit(STATUS_POWER_PMI, &il->status)) {
+	if (test_bit(S_POWER_PMI, &il->status)) {
 		/* rx_ant has been set to all valid chains previously */
 		active_chains = rx_ant &
 				((u8)(il->chain_noise_data.active_chains));
@@ -1010,11 +1010,11 @@ int il4965_request_scan(struct il_priv *il, struct ieee80211_vif *vif)
 	cmd.data = scan;
 	scan->len = cpu_to_le16(cmd.len);
 
-	set_bit(STATUS_SCAN_HW, &il->status);
+	set_bit(S_SCAN_HW, &il->status);
 
 	ret = il_send_cmd_sync(il, &cmd);
 	if (ret)
-		clear_bit(STATUS_SCAN_HW, &il->status);
+		clear_bit(S_SCAN_HW, &il->status);
 
 	return ret;
 }
@@ -1120,7 +1120,7 @@ static u8 il4965_count_chain_bitmap(u32 chain_bitmap)
 void il4965_set_rxon_chain(struct il_priv *il, struct il_rxon_context *ctx)
 {
 	bool is_single = il4965_is_single_rx_stream(il);
-	bool is_cam = !test_bit(STATUS_POWER_PMI, &il->status);
+	bool is_cam = !test_bit(S_POWER_PMI, &il->status);
 	u8 idle_rx_cnt, active_rx_cnt, valid_rx_cnt;
 	u32 active_chains;
 	u16 rx_chain;
@@ -1258,7 +1258,7 @@ void il4965_rx_missed_beacon_notif(struct il_priv *il,
 		    le32_to_cpu(missed_beacon->total_missed_becons),
 		    le32_to_cpu(missed_beacon->num_recvd_beacons),
 		    le32_to_cpu(missed_beacon->num_expected_beacons));
-		if (!test_bit(STATUS_SCANNING, &il->status))
+		if (!test_bit(S_SCANNING, &il->status))
 			il4965_init_sensitivity(il);
 	}
 }
@@ -1378,7 +1378,7 @@ void il4965_rx_stats(struct il_priv *il,
 	memcpy(&il->_4965.stats, &pkt->u.stats,
 		sizeof(il->_4965.stats));
 
-	set_bit(STATUS_STATISTICS, &il->status);
+	set_bit(S_STATISTICS, &il->status);
 
 	/* Reschedule the stats timer to occur in
 	 * REG_RECALIB_PERIOD seconds to ensure we get a
@@ -1387,7 +1387,7 @@ void il4965_rx_stats(struct il_priv *il,
 	mod_timer(&il->stats_periodic, jiffies +
 		  msecs_to_jiffies(REG_RECALIB_PERIOD * 1000));
 
-	if (unlikely(!test_bit(STATUS_SCANNING, &il->status)) &&
+	if (unlikely(!test_bit(S_SCANNING, &il->status)) &&
 	    (pkt->hdr.cmd == STATISTICS_NOTIFICATION)) {
 		il4965_rx_calc_noise(il);
 		queue_work(il->workqueue, &il->run_time_calib_work);
@@ -3809,7 +3809,7 @@ static void il4965_bg_stats_periodic(unsigned long data)
 {
 	struct il_priv *il = (struct il_priv *)data;
 
-	if (test_bit(STATUS_EXIT_PENDING, &il->status))
+	if (test_bit(S_EXIT_PENDING, &il->status))
 		return;
 
 	/* dont send host command if rf-kill is on */
@@ -3895,17 +3895,17 @@ static void il4965_rx_card_state_notif(struct il_priv *il,
 		il4965_perform_ct_kill_task(il);
 
 	if (flags & HW_CARD_DISABLED)
-		set_bit(STATUS_RF_KILL_HW, &il->status);
+		set_bit(S_RF_KILL_HW, &il->status);
 	else
-		clear_bit(STATUS_RF_KILL_HW, &il->status);
+		clear_bit(S_RF_KILL_HW, &il->status);
 
 	if (!(flags & RXON_CARD_DISABLED))
 		il_scan_cancel(il);
 
-	if ((test_bit(STATUS_RF_KILL_HW, &status) !=
-	     test_bit(STATUS_RF_KILL_HW, &il->status)))
+	if ((test_bit(S_RF_KILL_HW, &status) !=
+	     test_bit(S_RF_KILL_HW, &il->status)))
 		wiphy_rfkill_set_hw_state(il->hw->wiphy,
-			test_bit(STATUS_RF_KILL_HW, &il->status));
+			test_bit(S_RF_KILL_HW, &il->status));
 	else
 		wake_up(&il->wait_command_queue);
 }
@@ -4199,11 +4199,11 @@ static void il4965_irq_tasklet(struct il_priv *il)
 		 * is killed. Hence update the killswitch state here. The
 		 * rfkill handler will care about restarting if needed.
 		 */
-		if (!test_bit(STATUS_ALIVE, &il->status)) {
+		if (!test_bit(S_ALIVE, &il->status)) {
 			if (hw_rf_kill)
-				set_bit(STATUS_RF_KILL_HW, &il->status);
+				set_bit(S_RF_KILL_HW, &il->status);
 			else
-				clear_bit(STATUS_RF_KILL_HW, &il->status);
+				clear_bit(S_RF_KILL_HW, &il->status);
 			wiphy_rfkill_set_hw_state(il->hw->wiphy, hw_rf_kill);
 		}
 
@@ -4272,7 +4272,7 @@ static void il4965_irq_tasklet(struct il_priv *il)
 
 	/* Re-enable all interrupts */
 	/* only Re-enable if disabled by irq */
-	if (test_bit(STATUS_INT_ENABLED, &il->status))
+	if (test_bit(S_INT_ENABLED, &il->status))
 		il_enable_interrupts(il);
 	/* Re-enable RF_KILL if it occurred */
 	else if (handled & CSR_INT_BIT_RF_KILL)
@@ -5079,7 +5079,7 @@ static void il4965_alive_start(struct il_priv *il)
 
 
 	/* After the ALIVE response, we can send host commands to the uCode */
-	set_bit(STATUS_ALIVE, &il->status);
+	set_bit(S_ALIVE, &il->status);
 
 	/* Enable watchdog to monitor the driver tx queues */
 	il_setup_watchdog(il);
@@ -5110,7 +5110,7 @@ static void il4965_alive_start(struct il_priv *il)
 
 	il4965_reset_run_time_calib(il);
 
-	set_bit(STATUS_READY, &il->status);
+	set_bit(S_READY, &il->status);
 
 	/* Configure the adapter for unassociated operation */
 	il_commit_rxon(il, ctx);
@@ -5141,9 +5141,9 @@ static void __il4965_down(struct il_priv *il)
 
 	il_scan_cancel_timeout(il, 200);
 
-	exit_pending = test_and_set_bit(STATUS_EXIT_PENDING, &il->status);
+	exit_pending = test_and_set_bit(S_EXIT_PENDING, &il->status);
 
-	/* Stop TX queues watchdog. We need to have STATUS_EXIT_PENDING bit set
+	/* Stop TX queues watchdog. We need to have S_EXIT_PENDING bit set
 	 * to prevent rearm timer */
 	del_timer_sync(&il->watchdog);
 
@@ -5157,7 +5157,7 @@ static void __il4965_down(struct il_priv *il)
 	/* Wipe out the EXIT_PENDING status bit if we are not actually
 	 * exiting the module */
 	if (!exit_pending)
-		clear_bit(STATUS_EXIT_PENDING, &il->status);
+		clear_bit(S_EXIT_PENDING, &il->status);
 
 	/* stop and reset the on-board processor */
 	_il_wr(il, CSR_RESET, CSR_RESET_REG_FLAG_NEVO_RESET);
@@ -5174,25 +5174,25 @@ static void __il4965_down(struct il_priv *il)
 	/* If we have not previously called il_init() then
 	 * clear all bits but the RF Kill bit and return */
 	if (!il_is_init(il)) {
-		il->status = test_bit(STATUS_RF_KILL_HW, &il->status) <<
-					STATUS_RF_KILL_HW |
-			       test_bit(STATUS_GEO_CONFIGURED, &il->status) <<
-					STATUS_GEO_CONFIGURED |
-			       test_bit(STATUS_EXIT_PENDING, &il->status) <<
-					STATUS_EXIT_PENDING;
+		il->status = test_bit(S_RF_KILL_HW, &il->status) <<
+					S_RF_KILL_HW |
+			       test_bit(S_GEO_CONFIGURED, &il->status) <<
+					S_GEO_CONFIGURED |
+			       test_bit(S_EXIT_PENDING, &il->status) <<
+					S_EXIT_PENDING;
 		goto exit;
 	}
 
 	/* ...otherwise clear out all the status bits but the RF Kill
 	 * bit and continue taking the NIC down. */
-	il->status &= test_bit(STATUS_RF_KILL_HW, &il->status) <<
-				STATUS_RF_KILL_HW |
-			test_bit(STATUS_GEO_CONFIGURED, &il->status) <<
-				STATUS_GEO_CONFIGURED |
-			test_bit(STATUS_FW_ERROR, &il->status) <<
-				STATUS_FW_ERROR |
-		       test_bit(STATUS_EXIT_PENDING, &il->status) <<
-				STATUS_EXIT_PENDING;
+	il->status &= test_bit(S_RF_KILL_HW, &il->status) <<
+				S_RF_KILL_HW |
+			test_bit(S_GEO_CONFIGURED, &il->status) <<
+				S_GEO_CONFIGURED |
+			test_bit(S_FW_ERROR, &il->status) <<
+				S_FW_ERROR |
+		       test_bit(S_EXIT_PENDING, &il->status) <<
+				S_EXIT_PENDING;
 
 	il4965_txq_ctx_stop(il);
 	il4965_rxq_stop(il);
@@ -5283,7 +5283,7 @@ static int __il4965_up(struct il_priv *il)
 	int i;
 	int ret;
 
-	if (test_bit(STATUS_EXIT_PENDING, &il->status)) {
+	if (test_bit(S_EXIT_PENDING, &il->status)) {
 		IL_WARN("Exit pending; will not bring the NIC up\n");
 		return -EIO;
 	}
@@ -5309,9 +5309,9 @@ static int __il4965_up(struct il_priv *il)
 	/* If platform's RF_KILL switch is NOT set to KILL */
 	if (_il_rd(il,
 		CSR_GP_CNTRL) & CSR_GP_CNTRL_REG_FLAG_HW_RF_KILL_SW)
-		clear_bit(STATUS_RF_KILL_HW, &il->status);
+		clear_bit(S_RF_KILL_HW, &il->status);
 	else
-		set_bit(STATUS_RF_KILL_HW, &il->status);
+		set_bit(S_RF_KILL_HW, &il->status);
 
 	if (il_is_rfkill(il)) {
 		wiphy_rfkill_set_hw_state(il->hw->wiphy, true);
@@ -5372,9 +5372,9 @@ static int __il4965_up(struct il_priv *il)
 		return 0;
 	}
 
-	set_bit(STATUS_EXIT_PENDING, &il->status);
+	set_bit(S_EXIT_PENDING, &il->status);
 	__il4965_down(il);
-	clear_bit(STATUS_EXIT_PENDING, &il->status);
+	clear_bit(S_EXIT_PENDING, &il->status);
 
 	/* tried to restart and config the device for as long as our
 	 * patience could withstand */
@@ -5395,7 +5395,7 @@ static void il4965_bg_init_alive_start(struct work_struct *data)
 	    container_of(data, struct il_priv, init_alive_start.work);
 
 	mutex_lock(&il->mutex);
-	if (test_bit(STATUS_EXIT_PENDING, &il->status))
+	if (test_bit(S_EXIT_PENDING, &il->status))
 		goto out;
 
 	il->cfg->ops->lib->init_alive_start(il);
@@ -5409,7 +5409,7 @@ static void il4965_bg_alive_start(struct work_struct *data)
 	    container_of(data, struct il_priv, alive_start.work);
 
 	mutex_lock(&il->mutex);
-	if (test_bit(STATUS_EXIT_PENDING, &il->status))
+	if (test_bit(S_EXIT_PENDING, &il->status))
 		goto out;
 
 	il4965_alive_start(il);
@@ -5424,8 +5424,8 @@ static void il4965_bg_run_time_calib_work(struct work_struct *work)
 
 	mutex_lock(&il->mutex);
 
-	if (test_bit(STATUS_EXIT_PENDING, &il->status) ||
-	    test_bit(STATUS_SCANNING, &il->status)) {
+	if (test_bit(S_EXIT_PENDING, &il->status) ||
+	    test_bit(S_SCANNING, &il->status)) {
 		mutex_unlock(&il->mutex);
 		return;
 	}
@@ -5444,10 +5444,10 @@ static void il4965_bg_restart(struct work_struct *data)
 {
 	struct il_priv *il = container_of(data, struct il_priv, restart);
 
-	if (test_bit(STATUS_EXIT_PENDING, &il->status))
+	if (test_bit(S_EXIT_PENDING, &il->status))
 		return;
 
-	if (test_and_clear_bit(STATUS_FW_ERROR, &il->status)) {
+	if (test_and_clear_bit(S_FW_ERROR, &il->status)) {
 		mutex_lock(&il->mutex);
 		il->ctx.vif = NULL;
 		il->is_open = 0;
@@ -5461,7 +5461,7 @@ static void il4965_bg_restart(struct work_struct *data)
 		il4965_down(il);
 
 		mutex_lock(&il->mutex);
-		if (test_bit(STATUS_EXIT_PENDING, &il->status)) {
+		if (test_bit(S_EXIT_PENDING, &il->status)) {
 			mutex_unlock(&il->mutex);
 			return;
 		}
@@ -5476,7 +5476,7 @@ static void il4965_bg_rx_replenish(struct work_struct *data)
 	struct il_priv *il =
 	    container_of(data, struct il_priv, rx_replenish);
 
-	if (test_bit(STATUS_EXIT_PENDING, &il->status))
+	if (test_bit(S_EXIT_PENDING, &il->status))
 		return;
 
 	mutex_lock(&il->mutex);
@@ -5582,10 +5582,10 @@ int il4965_mac_start(struct ieee80211_hw *hw)
 	/* Wait for START_ALIVE from Run Time ucode. Otherwise callbacks from
 	 * mac80211 will not be run successfully. */
 	ret = wait_event_timeout(il->wait_command_queue,
-			test_bit(STATUS_READY, &il->status),
+			test_bit(S_READY, &il->status),
 			UCODE_READY_TIMEOUT);
 	if (!ret) {
-		if (!test_bit(STATUS_READY, &il->status)) {
+		if (!test_bit(S_READY, &il->status)) {
 			IL_ERR("START_ALIVE timeout after %dms.\n",
 				jiffies_to_msecs(UCODE_READY_TIMEOUT));
 			return -ETIMEDOUT;
@@ -5751,7 +5751,7 @@ int il4965_mac_ampdu_action(struct ieee80211_hw *hw,
 	case IEEE80211_AMPDU_RX_STOP:
 		D_HT("stop Rx\n");
 		ret = il4965_sta_rx_agg_stop(il, sta, tid);
-		if (test_bit(STATUS_EXIT_PENDING, &il->status))
+		if (test_bit(S_EXIT_PENDING, &il->status))
 			ret = 0;
 		break;
 	case IEEE80211_AMPDU_TX_START:
@@ -5761,7 +5761,7 @@ int il4965_mac_ampdu_action(struct ieee80211_hw *hw,
 	case IEEE80211_AMPDU_TX_STOP:
 		D_HT("stop Tx\n");
 		ret = il4965_tx_agg_stop(il, vif, sta, tid);
-		if (test_bit(STATUS_EXIT_PENDING, &il->status))
+		if (test_bit(S_EXIT_PENDING, &il->status))
 			ret = 0;
 		break;
 	case IEEE80211_AMPDU_TX_OPERATIONAL:
@@ -5833,9 +5833,9 @@ void il4965_mac_channel_switch(struct ieee80211_hw *hw,
 	if (il_is_rfkill(il))
 		goto out;
 
-	if (test_bit(STATUS_EXIT_PENDING, &il->status) ||
-	    test_bit(STATUS_SCANNING, &il->status) ||
-	    test_bit(STATUS_CHANNEL_SWITCH_PENDING, &il->status))
+	if (test_bit(S_EXIT_PENDING, &il->status) ||
+	    test_bit(S_SCANNING, &il->status) ||
+	    test_bit(S_CHANNEL_SWITCH_PENDING, &il->status))
 		goto out;
 
 	if (!il_is_associated_ctx(ctx))
@@ -5891,10 +5891,10 @@ void il4965_mac_channel_switch(struct ieee80211_hw *hw,
 	 * at this point, staging_rxon has the
 	 * configuration for channel switch
 	 */
-	set_bit(STATUS_CHANNEL_SWITCH_PENDING, &il->status);
+	set_bit(S_CHANNEL_SWITCH_PENDING, &il->status);
 	il->switch_channel = cpu_to_le16(ch);
 	if (il->cfg->ops->lib->set_channel_switch(il, ch_switch)) {
-		clear_bit(STATUS_CHANNEL_SWITCH_PENDING, &il->status);
+		clear_bit(S_CHANNEL_SWITCH_PENDING, &il->status);
 		il->switch_channel = 0;
 		ieee80211_chswitch_done(ctx->vif, false);
 	}
@@ -5968,8 +5968,8 @@ static void il4965_bg_txpower_work(struct work_struct *work)
 	 * then just return; the stats notification will
 	 * kick off another scheduled work to compensate for
 	 * any temperature delta we missed here. */
-	if (test_bit(STATUS_EXIT_PENDING, &il->status) ||
-	    test_bit(STATUS_SCANNING, &il->status))
+	if (test_bit(S_EXIT_PENDING, &il->status) ||
+	    test_bit(S_SCANNING, &il->status))
 		goto out;
 
 	/* Regardless of if we are associated, we must reconfigure the
@@ -6376,12 +6376,12 @@ il4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	/* If platform's RF_KILL switch is NOT set to KILL */
 	if (_il_rd(il, CSR_GP_CNTRL) &
 		CSR_GP_CNTRL_REG_FLAG_HW_RF_KILL_SW)
-		clear_bit(STATUS_RF_KILL_HW, &il->status);
+		clear_bit(S_RF_KILL_HW, &il->status);
 	else
-		set_bit(STATUS_RF_KILL_HW, &il->status);
+		set_bit(S_RF_KILL_HW, &il->status);
 
 	wiphy_rfkill_set_hw_state(il->hw->wiphy,
-		test_bit(STATUS_RF_KILL_HW, &il->status));
+		test_bit(S_RF_KILL_HW, &il->status));
 
 	il_power_initialize(il);
 
@@ -6433,9 +6433,9 @@ static void __devexit il4965_pci_remove(struct pci_dev *pdev)
 
 	/* ieee80211_unregister_hw call wil cause il_mac_stop to
 	 * to be called and il4965_down since we are removing the device
-	 * we need to set STATUS_EXIT_PENDING bit.
+	 * we need to set S_EXIT_PENDING bit.
 	 */
-	set_bit(STATUS_EXIT_PENDING, &il->status);
+	set_bit(S_EXIT_PENDING, &il->status);
 
 	il_leds_exit(il);
 
diff --git a/drivers/net/wireless/iwlegacy/4965.c b/drivers/net/wireless/iwlegacy/4965.c
index 8199e63..1efe824 100644
--- a/drivers/net/wireless/iwlegacy/4965.c
+++ b/drivers/net/wireless/iwlegacy/4965.c
@@ -1349,7 +1349,7 @@ static int il4965_send_tx_power(struct il_priv *il)
 	u8 ctrl_chan_high = 0;
 	struct il_rxon_context *ctx = &il->ctx;
 
-	if (WARN_ONCE(test_bit(STATUS_SCAN_HW, &il->status),
+	if (WARN_ONCE(test_bit(S_SCAN_HW, &il->status),
 		      "TX Power requested while scanning!\n"))
 		return -EAGAIN;
 
@@ -1441,7 +1441,7 @@ static int il4965_commit_rxon(struct il_priv *il, struct il_rxon_context *ctx)
 	 * receive commit_rxon request
 	 * abort any previous channel switch if still in process
 	 */
-	if (test_bit(STATUS_CHANNEL_SWITCH_PENDING, &il->status) &&
+	if (test_bit(S_CHANNEL_SWITCH_PENDING, &il->status) &&
 	    il->switch_channel != ctx->staging.channel) {
 		D_11H("abort channel switch on %d\n",
 		      le16_to_cpu(il->switch_channel));
@@ -1673,7 +1673,7 @@ static int il4965_hw_get_temperature(struct il_priv *il)
 	s32 R1, R2, R3;
 	u32 R4;
 
-	if (test_bit(STATUS_TEMPERATURE, &il->status) &&
+	if (test_bit(S_TEMPERATURE, &il->status) &&
 	    (il->_4965.stats.flag &
 			STATISTICS_REPLY_FLG_HT40_MODE_MSK)) {
 		D_TEMP("Running HT40 temperature calibration\n");
@@ -1696,7 +1696,7 @@ static int il4965_hw_get_temperature(struct il_priv *il)
 	 * with an updated temperature, use R4 provided to us in the
 	 * "initialize" ALIVE response.
 	 */
-	if (!test_bit(STATUS_TEMPERATURE, &il->status))
+	if (!test_bit(S_TEMPERATURE, &il->status))
 		vt = sign_extend32(R4, 23);
 	else
 		vt = sign_extend32(le32_to_cpu(il->_4965.stats.
@@ -1737,7 +1737,7 @@ static int il4965_is_temp_calib_needed(struct il_priv *il)
 {
 	int temp_diff;
 
-	if (!test_bit(STATUS_STATISTICS, &il->status)) {
+	if (!test_bit(S_STATISTICS, &il->status)) {
 		D_TEMP("Temperature not updated -- no stats.\n");
 		return 0;
 	}
@@ -1784,10 +1784,10 @@ static void il4965_temperature_calib(struct il_priv *il)
 	}
 
 	il->temperature = temp;
-	set_bit(STATUS_TEMPERATURE, &il->status);
+	set_bit(S_TEMPERATURE, &il->status);
 
 	if (!il->disable_tx_power_cal &&
-	     unlikely(!test_bit(STATUS_SCANNING, &il->status)) &&
+	     unlikely(!test_bit(S_SCANNING, &il->status)) &&
 	     il4965_is_temp_calib_needed(il))
 		queue_work(il->workqueue, &il->txpower_work);
 }
@@ -2179,7 +2179,7 @@ static void il4965_post_associate(struct il_priv *il)
 	if (!vif || !il->is_open)
 		return;
 
-	if (test_bit(STATUS_EXIT_PENDING, &il->status))
+	if (test_bit(S_EXIT_PENDING, &il->status))
 		return;
 
 	il_scan_cancel_timeout(il, 200);
@@ -2254,7 +2254,7 @@ static void il4965_config_ap(struct il_priv *il)
 
 	lockdep_assert_held(&il->mutex);
 
-	if (test_bit(STATUS_EXIT_PENDING, &il->status))
+	if (test_bit(S_EXIT_PENDING, &il->status))
 		return;
 
 	/* The following should be done only at AP bring up */
diff --git a/drivers/net/wireless/iwlegacy/iwl-core.c b/drivers/net/wireless/iwlegacy/iwl-core.c
index bd222f5..ba7ee4b 100644
--- a/drivers/net/wireless/iwlegacy/iwl-core.c
+++ b/drivers/net/wireless/iwlegacy/iwl-core.c
@@ -165,7 +165,7 @@ int il_init_geos(struct il_priv *il)
 	if (il->bands[IEEE80211_BAND_2GHZ].n_bitrates ||
 	    il->bands[IEEE80211_BAND_5GHZ].n_bitrates) {
 		D_INFO("Geography modes already initialized.\n");
-		set_bit(STATUS_GEO_CONFIGURED, &il->status);
+		set_bit(S_GEO_CONFIGURED, &il->status);
 		return 0;
 	}
 
@@ -264,7 +264,7 @@ int il_init_geos(struct il_priv *il)
 		   il->bands[IEEE80211_BAND_2GHZ].n_channels,
 		   il->bands[IEEE80211_BAND_5GHZ].n_channels);
 
-	set_bit(STATUS_GEO_CONFIGURED, &il->status);
+	set_bit(S_GEO_CONFIGURED, &il->status);
 
 	return 0;
 }
@@ -277,7 +277,7 @@ void il_free_geos(struct il_priv *il)
 {
 	kfree(il->ieee_channels);
 	kfree(il->ieee_rates);
-	clear_bit(STATUS_GEO_CONFIGURED, &il->status);
+	clear_bit(S_GEO_CONFIGURED, &il->status);
 }
 EXPORT_SYMBOL(il_free_geos);
 
@@ -839,10 +839,10 @@ void il_chswitch_done(struct il_priv *il, bool is_success)
 {
 	struct il_rxon_context *ctx = &il->ctx;
 
-	if (test_bit(STATUS_EXIT_PENDING, &il->status))
+	if (test_bit(S_EXIT_PENDING, &il->status))
 		return;
 
-	if (test_and_clear_bit(STATUS_CHANNEL_SWITCH_PENDING, &il->status))
+	if (test_and_clear_bit(S_CHANNEL_SWITCH_PENDING, &il->status))
 		ieee80211_chswitch_done(ctx->vif, is_success);
 }
 EXPORT_SYMBOL(il_chswitch_done);
@@ -855,7 +855,7 @@ void il_rx_csa(struct il_priv *il, struct il_rx_buf *rxb)
 	struct il_rxon_context *ctx = &il->ctx;
 	struct il_rxon_cmd *rxon = (void *)&ctx->active;
 
-	if (!test_bit(STATUS_CHANNEL_SWITCH_PENDING, &il->status))
+	if (!test_bit(S_CHANNEL_SWITCH_PENDING, &il->status))
 		return;
 
 	if (!le32_to_cpu(csa->status) && csa->channel == il->switch_channel) {
@@ -903,10 +903,10 @@ EXPORT_SYMBOL(il_print_rx_config_cmd);
 void il_irq_handle_error(struct il_priv *il)
 {
 	/* Set the FW error flag -- cleared on il_down */
-	set_bit(STATUS_FW_ERROR, &il->status);
+	set_bit(S_FW_ERROR, &il->status);
 
 	/* Cancel currently queued command. */
-	clear_bit(STATUS_HCMD_ACTIVE, &il->status);
+	clear_bit(S_HCMD_ACTIVE, &il->status);
 
 	IL_ERR("Loaded firmware version: %s\n",
 		il->hw->wiphy->fw_version);
@@ -924,9 +924,9 @@ void il_irq_handle_error(struct il_priv *il)
 
 	/* Keep the restart process from trying to send host
 	 * commands by clearing the INIT status bit */
-	clear_bit(STATUS_READY, &il->status);
+	clear_bit(S_READY, &il->status);
 
-	if (!test_bit(STATUS_EXIT_PENDING, &il->status)) {
+	if (!test_bit(S_EXIT_PENDING, &il->status)) {
 		IL_DBG(IL_DL_FW_ERRORS,
 			  "Restarting adapter due to uCode error.\n");
 
@@ -1127,7 +1127,7 @@ int il_set_tx_power(struct il_priv *il, s8 tx_power, bool force)
 	il->tx_power_next = tx_power;
 
 	/* do not set tx power when scanning or channel changing */
-	defer = test_bit(STATUS_SCANNING, &il->status) ||
+	defer = test_bit(S_SCANNING, &il->status) ||
 		memcmp(&ctx->active, &ctx->staging, sizeof(ctx->staging));
 	if (defer && !force) {
 		D_INFO("Deferring tx power set\n");
@@ -1678,7 +1678,7 @@ int il_force_reset(struct il_priv *il, bool external)
 {
 	struct il_force_reset *force_reset;
 
-	if (test_bit(STATUS_EXIT_PENDING, &il->status))
+	if (test_bit(S_EXIT_PENDING, &il->status))
 		return -EINVAL;
 
 	force_reset = &il->force_reset;
@@ -1713,13 +1713,13 @@ int il_force_reset(struct il_priv *il, bool external)
 	IL_ERR("On demand firmware reload\n");
 
 	/* Set the FW error flag -- cleared on il_down */
-	set_bit(STATUS_FW_ERROR, &il->status);
+	set_bit(S_FW_ERROR, &il->status);
 	wake_up(&il->wait_command_queue);
 	/*
 	 * Keep the restart process from trying to send host
 	 * commands by clearing the INIT status bit
 	 */
-	clear_bit(STATUS_READY, &il->status);
+	clear_bit(S_READY, &il->status);
 	queue_work(il->workqueue, &il->restart);
 
 	return 0;
@@ -1826,7 +1826,7 @@ void il_bg_watchdog(unsigned long data)
 	int cnt;
 	unsigned long timeout;
 
-	if (test_bit(STATUS_EXIT_PENDING, &il->status))
+	if (test_bit(S_EXIT_PENDING, &il->status))
 		return;
 
 	timeout = il->cfg->base_params->wd_timeout;
@@ -1960,9 +1960,9 @@ int il_pci_resume(struct device *device)
 		hw_rfkill = true;
 
 	if (hw_rfkill)
-		set_bit(STATUS_RF_KILL_HW, &il->status);
+		set_bit(S_RF_KILL_HW, &il->status);
 	else
-		clear_bit(STATUS_RF_KILL_HW, &il->status);
+		clear_bit(S_RF_KILL_HW, &il->status);
 
 	wiphy_rfkill_set_hw_state(il->hw->wiphy, hw_rfkill);
 
@@ -1985,7 +1985,7 @@ EXPORT_SYMBOL(il_pm_ops);
 static void
 il_update_qos(struct il_priv *il, struct il_rxon_context *ctx)
 {
-	if (test_bit(STATUS_EXIT_PENDING, &il->status))
+	if (test_bit(S_EXIT_PENDING, &il->status))
 		return;
 
 	if (!ctx->is_active)
@@ -2034,7 +2034,7 @@ int il_mac_config(struct ieee80211_hw *hw, u32 changed)
 	D_MAC80211("enter to channel %d changed 0x%X\n",
 					channel->hw_value, changed);
 
-	if (unlikely(test_bit(STATUS_SCANNING, &il->status))) {
+	if (unlikely(test_bit(S_SCANNING, &il->status))) {
 		scan_active = 1;
 		D_MAC80211("scan active\n");
 	}
@@ -2566,7 +2566,7 @@ unplugged:
 none:
 	/* re-enable interrupts here since we don't have anything to service. */
 	/* only Re-enable if disabled by irq */
-	if (test_bit(STATUS_INT_ENABLED, &il->status))
+	if (test_bit(S_INT_ENABLED, &il->status))
 		il_enable_interrupts(il);
 	spin_unlock_irqrestore(&il->lock, flags);
 	return IRQ_NONE;
diff --git a/drivers/net/wireless/iwlegacy/iwl-core.h b/drivers/net/wireless/iwlegacy/iwl-core.h
index 8333761..5b2883f 100644
--- a/drivers/net/wireless/iwlegacy/iwl-core.h
+++ b/drivers/net/wireless/iwlegacy/iwl-core.h
@@ -533,47 +533,47 @@ void il_free_geos(struct il_priv *il);
 
 /*************** DRIVER STATUS FUNCTIONS   *****/
 
-#define STATUS_HCMD_ACTIVE	0	/* host command in progress */
-/* 1 is unused (used to be STATUS_HCMD_SYNC_ACTIVE) */
-#define STATUS_INT_ENABLED	2
-#define STATUS_RF_KILL_HW	3
-#define STATUS_CT_KILL		4
-#define STATUS_INIT		5
-#define STATUS_ALIVE		6
-#define STATUS_READY		7
-#define STATUS_TEMPERATURE	8
-#define STATUS_GEO_CONFIGURED	9
-#define STATUS_EXIT_PENDING	10
-#define STATUS_STATISTICS	12
-#define STATUS_SCANNING		13
-#define STATUS_SCAN_ABORTING	14
-#define STATUS_SCAN_HW		15
-#define STATUS_POWER_PMI	16
-#define STATUS_FW_ERROR		17
-#define STATUS_CHANNEL_SWITCH_PENDING 18
+#define S_HCMD_ACTIVE	0	/* host command in progress */
+/* 1 is unused (used to be S_HCMD_SYNC_ACTIVE) */
+#define S_INT_ENABLED	2
+#define S_RF_KILL_HW	3
+#define S_CT_KILL		4
+#define S_INIT		5
+#define S_ALIVE		6
+#define S_READY		7
+#define S_TEMPERATURE	8
+#define S_GEO_CONFIGURED	9
+#define S_EXIT_PENDING	10
+#define S_STATISTICS	12
+#define S_SCANNING		13
+#define S_SCAN_ABORTING	14
+#define S_SCAN_HW		15
+#define S_POWER_PMI	16
+#define S_FW_ERROR		17
+#define S_CHANNEL_SWITCH_PENDING 18
 
 static inline int il_is_ready(struct il_priv *il)
 {
 	/* The adapter is 'ready' if READY and GEO_CONFIGURED bits are
 	 * set but EXIT_PENDING is not */
-	return test_bit(STATUS_READY, &il->status) &&
-	       test_bit(STATUS_GEO_CONFIGURED, &il->status) &&
-	       !test_bit(STATUS_EXIT_PENDING, &il->status);
+	return test_bit(S_READY, &il->status) &&
+	       test_bit(S_GEO_CONFIGURED, &il->status) &&
+	       !test_bit(S_EXIT_PENDING, &il->status);
 }
 
 static inline int il_is_alive(struct il_priv *il)
 {
-	return test_bit(STATUS_ALIVE, &il->status);
+	return test_bit(S_ALIVE, &il->status);
 }
 
 static inline int il_is_init(struct il_priv *il)
 {
-	return test_bit(STATUS_INIT, &il->status);
+	return test_bit(S_INIT, &il->status);
 }
 
 static inline int il_is_rfkill_hw(struct il_priv *il)
 {
-	return test_bit(STATUS_RF_KILL_HW, &il->status);
+	return test_bit(S_RF_KILL_HW, &il->status);
 }
 
 static inline int il_is_rfkill(struct il_priv *il)
@@ -583,7 +583,7 @@ static inline int il_is_rfkill(struct il_priv *il)
 
 static inline int il_is_ctkill(struct il_priv *il)
 {
-	return test_bit(STATUS_CT_KILL, &il->status);
+	return test_bit(S_CT_KILL, &il->status);
 }
 
 static inline int il_is_ready_rf(struct il_priv *il)
diff --git a/drivers/net/wireless/iwlegacy/iwl-debugfs.c b/drivers/net/wireless/iwlegacy/iwl-debugfs.c
index 8448db7..114922b 100644
--- a/drivers/net/wireless/iwlegacy/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlegacy/iwl-debugfs.c
@@ -402,7 +402,7 @@ il_dbgfs_channels_read(struct file *file, char __user *user_buf,
 	char *buf;
 	ssize_t ret;
 
-	if (!test_bit(STATUS_GEO_CONFIGURED, &il->status))
+	if (!test_bit(S_GEO_CONFIGURED, &il->status))
 		return -EAGAIN;
 
 	buf = kzalloc(bufsz, GFP_KERNEL);
@@ -471,38 +471,38 @@ static ssize_t il_dbgfs_status_read(struct file *file,
 	int pos = 0;
 	const size_t bufsz = sizeof(buf);
 
-	pos += scnprintf(buf + pos, bufsz - pos, "STATUS_HCMD_ACTIVE:\t %d\n",
-		test_bit(STATUS_HCMD_ACTIVE, &il->status));
-	pos += scnprintf(buf + pos, bufsz - pos, "STATUS_INT_ENABLED:\t %d\n",
-		test_bit(STATUS_INT_ENABLED, &il->status));
-	pos += scnprintf(buf + pos, bufsz - pos, "STATUS_RF_KILL_HW:\t %d\n",
-		test_bit(STATUS_RF_KILL_HW, &il->status));
-	pos += scnprintf(buf + pos, bufsz - pos, "STATUS_CT_KILL:\t\t %d\n",
-		test_bit(STATUS_CT_KILL, &il->status));
-	pos += scnprintf(buf + pos, bufsz - pos, "STATUS_INIT:\t\t %d\n",
-		test_bit(STATUS_INIT, &il->status));
-	pos += scnprintf(buf + pos, bufsz - pos, "STATUS_ALIVE:\t\t %d\n",
-		test_bit(STATUS_ALIVE, &il->status));
-	pos += scnprintf(buf + pos, bufsz - pos, "STATUS_READY:\t\t %d\n",
-		test_bit(STATUS_READY, &il->status));
-	pos += scnprintf(buf + pos, bufsz - pos, "STATUS_TEMPERATURE:\t %d\n",
-		test_bit(STATUS_TEMPERATURE, &il->status));
-	pos += scnprintf(buf + pos, bufsz - pos, "STATUS_GEO_CONFIGURED:\t %d\n",
-		test_bit(STATUS_GEO_CONFIGURED, &il->status));
-	pos += scnprintf(buf + pos, bufsz - pos, "STATUS_EXIT_PENDING:\t %d\n",
-		test_bit(STATUS_EXIT_PENDING, &il->status));
-	pos += scnprintf(buf + pos, bufsz - pos, "STATUS_STATISTICS:\t %d\n",
-		test_bit(STATUS_STATISTICS, &il->status));
-	pos += scnprintf(buf + pos, bufsz - pos, "STATUS_SCANNING:\t %d\n",
-		test_bit(STATUS_SCANNING, &il->status));
-	pos += scnprintf(buf + pos, bufsz - pos, "STATUS_SCAN_ABORTING:\t %d\n",
-		test_bit(STATUS_SCAN_ABORTING, &il->status));
-	pos += scnprintf(buf + pos, bufsz - pos, "STATUS_SCAN_HW:\t\t %d\n",
-		test_bit(STATUS_SCAN_HW, &il->status));
-	pos += scnprintf(buf + pos, bufsz - pos, "STATUS_POWER_PMI:\t %d\n",
-		test_bit(STATUS_POWER_PMI, &il->status));
-	pos += scnprintf(buf + pos, bufsz - pos, "STATUS_FW_ERROR:\t %d\n",
-		test_bit(STATUS_FW_ERROR, &il->status));
+	pos += scnprintf(buf + pos, bufsz - pos, "S_HCMD_ACTIVE:\t %d\n",
+		test_bit(S_HCMD_ACTIVE, &il->status));
+	pos += scnprintf(buf + pos, bufsz - pos, "S_INT_ENABLED:\t %d\n",
+		test_bit(S_INT_ENABLED, &il->status));
+	pos += scnprintf(buf + pos, bufsz - pos, "S_RF_KILL_HW:\t %d\n",
+		test_bit(S_RF_KILL_HW, &il->status));
+	pos += scnprintf(buf + pos, bufsz - pos, "S_CT_KILL:\t\t %d\n",
+		test_bit(S_CT_KILL, &il->status));
+	pos += scnprintf(buf + pos, bufsz - pos, "S_INIT:\t\t %d\n",
+		test_bit(S_INIT, &il->status));
+	pos += scnprintf(buf + pos, bufsz - pos, "S_ALIVE:\t\t %d\n",
+		test_bit(S_ALIVE, &il->status));
+	pos += scnprintf(buf + pos, bufsz - pos, "S_READY:\t\t %d\n",
+		test_bit(S_READY, &il->status));
+	pos += scnprintf(buf + pos, bufsz - pos, "S_TEMPERATURE:\t %d\n",
+		test_bit(S_TEMPERATURE, &il->status));
+	pos += scnprintf(buf + pos, bufsz - pos, "S_GEO_CONFIGURED:\t %d\n",
+		test_bit(S_GEO_CONFIGURED, &il->status));
+	pos += scnprintf(buf + pos, bufsz - pos, "S_EXIT_PENDING:\t %d\n",
+		test_bit(S_EXIT_PENDING, &il->status));
+	pos += scnprintf(buf + pos, bufsz - pos, "S_STATISTICS:\t %d\n",
+		test_bit(S_STATISTICS, &il->status));
+	pos += scnprintf(buf + pos, bufsz - pos, "S_SCANNING:\t %d\n",
+		test_bit(S_SCANNING, &il->status));
+	pos += scnprintf(buf + pos, bufsz - pos, "S_SCAN_ABORTING:\t %d\n",
+		test_bit(S_SCAN_ABORTING, &il->status));
+	pos += scnprintf(buf + pos, bufsz - pos, "S_SCAN_HW:\t\t %d\n",
+		test_bit(S_SCAN_HW, &il->status));
+	pos += scnprintf(buf + pos, bufsz - pos, "S_POWER_PMI:\t %d\n",
+		test_bit(S_POWER_PMI, &il->status));
+	pos += scnprintf(buf + pos, bufsz - pos, "S_FW_ERROR:\t %d\n",
+		test_bit(S_FW_ERROR, &il->status));
 	return simple_read_from_buffer(user_buf, count, ppos, buf, pos);
 }
 
diff --git a/drivers/net/wireless/iwlegacy/iwl-hcmd.c b/drivers/net/wireless/iwlegacy/iwl-hcmd.c
index 0b11f2f..4762a0e 100644
--- a/drivers/net/wireless/iwlegacy/iwl-hcmd.c
+++ b/drivers/net/wireless/iwlegacy/iwl-hcmd.c
@@ -128,7 +128,7 @@ il_send_cmd_async(struct il_priv *il, struct il_host_cmd *cmd)
 	if (!cmd->callback)
 		cmd->callback = il_generic_cmd_callback;
 
-	if (test_bit(STATUS_EXIT_PENDING, &il->status))
+	if (test_bit(S_EXIT_PENDING, &il->status))
 		return -EBUSY;
 
 	ret = il_enqueue_hcmd(il, cmd);
@@ -155,7 +155,7 @@ int il_send_cmd_sync(struct il_priv *il, struct il_host_cmd *cmd)
 	D_INFO("Attempting to send sync command %s\n",
 			il_get_cmd_string(cmd->id));
 
-	set_bit(STATUS_HCMD_ACTIVE, &il->status);
+	set_bit(S_HCMD_ACTIVE, &il->status);
 	D_INFO("Setting HCMD_ACTIVE for command %s\n",
 			il_get_cmd_string(cmd->id));
 
@@ -168,16 +168,16 @@ int il_send_cmd_sync(struct il_priv *il, struct il_host_cmd *cmd)
 	}
 
 	ret = wait_event_timeout(il->wait_command_queue,
-			!test_bit(STATUS_HCMD_ACTIVE, &il->status),
+			!test_bit(S_HCMD_ACTIVE, &il->status),
 			HOST_COMPLETE_TIMEOUT);
 	if (!ret) {
-		if (test_bit(STATUS_HCMD_ACTIVE, &il->status)) {
+		if (test_bit(S_HCMD_ACTIVE, &il->status)) {
 			IL_ERR(
 				"Error sending %s: time out after %dms.\n",
 				il_get_cmd_string(cmd->id),
 				jiffies_to_msecs(HOST_COMPLETE_TIMEOUT));
 
-			clear_bit(STATUS_HCMD_ACTIVE, &il->status);
+			clear_bit(S_HCMD_ACTIVE, &il->status);
 			D_INFO(
 				"Clearing HCMD_ACTIVE for command %s\n",
 				       il_get_cmd_string(cmd->id));
@@ -186,13 +186,13 @@ int il_send_cmd_sync(struct il_priv *il, struct il_host_cmd *cmd)
 		}
 	}
 
-	if (test_bit(STATUS_RF_KILL_HW, &il->status)) {
+	if (test_bit(S_RF_KILL_HW, &il->status)) {
 		IL_ERR("Command %s aborted: RF KILL Switch\n",
 			       il_get_cmd_string(cmd->id));
 		ret = -ECANCELED;
 		goto fail;
 	}
-	if (test_bit(STATUS_FW_ERROR, &il->status)) {
+	if (test_bit(S_FW_ERROR, &il->status)) {
 		IL_ERR("Command %s failed: FW Error\n",
 			       il_get_cmd_string(cmd->id));
 		ret = -EIO;
diff --git a/drivers/net/wireless/iwlegacy/iwl-helpers.h b/drivers/net/wireless/iwlegacy/iwl-helpers.h
index 5fcb23e..0e64003 100644
--- a/drivers/net/wireless/iwlegacy/iwl-helpers.h
+++ b/drivers/net/wireless/iwlegacy/iwl-helpers.h
@@ -146,7 +146,7 @@ static inline void il_stop_queue(struct il_priv *il,
 
 static inline void il_disable_interrupts(struct il_priv *il)
 {
-	clear_bit(STATUS_INT_ENABLED, &il->status);
+	clear_bit(S_INT_ENABLED, &il->status);
 
 	/* disable interrupts from uCode/NIC to host */
 	_il_wr(il, CSR_INT_MASK, 0x00000000);
@@ -167,7 +167,7 @@ static inline void il_enable_rfkill_int(struct il_priv *il)
 static inline void il_enable_interrupts(struct il_priv *il)
 {
 	D_ISR("Enabling interrupts\n");
-	set_bit(STATUS_INT_ENABLED, &il->status);
+	set_bit(S_INT_ENABLED, &il->status);
 	_il_wr(il, CSR_INT_MASK, il->inta_mask);
 }
 
diff --git a/drivers/net/wireless/iwlegacy/iwl-led.c b/drivers/net/wireless/iwlegacy/iwl-led.c
index 3652cdc..a840c2e 100644
--- a/drivers/net/wireless/iwlegacy/iwl-led.c
+++ b/drivers/net/wireless/iwlegacy/iwl-led.c
@@ -107,7 +107,7 @@ static int il_led_cmd(struct il_priv *il,
 	};
 	int ret;
 
-	if (!test_bit(STATUS_READY, &il->status))
+	if (!test_bit(S_READY, &il->status))
 		return -EBUSY;
 
 	if (il->blink_on == on && il->blink_off == off)
diff --git a/drivers/net/wireless/iwlegacy/iwl-power.c b/drivers/net/wireless/iwlegacy/iwl-power.c
index 051623a..c66a0f7 100644
--- a/drivers/net/wireless/iwlegacy/iwl-power.c
+++ b/drivers/net/wireless/iwlegacy/iwl-power.c
@@ -113,18 +113,18 @@ il_power_set_mode(struct il_priv *il, struct il_powertable_cmd *cmd,
 
 	/* scan complete use sleep_power_next, need to be updated */
 	memcpy(&il->power_data.sleep_cmd_next, cmd, sizeof(*cmd));
-	if (test_bit(STATUS_SCANNING, &il->status) && !force) {
+	if (test_bit(S_SCANNING, &il->status) && !force) {
 		D_INFO("Defer power set mode while scanning\n");
 		return 0;
 	}
 
 	if (cmd->flags & IL_POWER_DRIVER_ALLOW_SLEEP_MSK)
-		set_bit(STATUS_POWER_PMI, &il->status);
+		set_bit(S_POWER_PMI, &il->status);
 
 	ret = il_set_power(il, cmd);
 	if (!ret) {
 		if (!(cmd->flags & IL_POWER_DRIVER_ALLOW_SLEEP_MSK))
-			clear_bit(STATUS_POWER_PMI, &il->status);
+			clear_bit(S_POWER_PMI, &il->status);
 
 		if (il->cfg->ops->lib->update_chain_flags && update_chains)
 			il->cfg->ops->lib->update_chain_flags(il);
diff --git a/drivers/net/wireless/iwlegacy/iwl-rx.c b/drivers/net/wireless/iwlegacy/iwl-rx.c
index 58d19c1..76f2361 100644
--- a/drivers/net/wireless/iwlegacy/iwl-rx.c
+++ b/drivers/net/wireless/iwlegacy/iwl-rx.c
@@ -137,7 +137,7 @@ il_rx_queue_update_write_ptr(struct il_priv *il,
 		goto exit_unlock;
 
 	/* If power-saving is in use, make sure device is awake */
-	if (test_bit(STATUS_POWER_PMI, &il->status)) {
+	if (test_bit(S_POWER_PMI, &il->status)) {
 		reg = _il_rd(il, CSR_UCODE_DRV_GP1);
 
 		if (reg & CSR_UCODE_DRV_GP1_BIT_MAC_SLEEP) {
diff --git a/drivers/net/wireless/iwlegacy/iwl-scan.c b/drivers/net/wireless/iwlegacy/iwl-scan.c
index 18226d1..6d20f2b 100644
--- a/drivers/net/wireless/iwlegacy/iwl-scan.c
+++ b/drivers/net/wireless/iwlegacy/iwl-scan.c
@@ -66,11 +66,11 @@ static int il_send_scan_abort(struct il_priv *il)
 	/* Exit instantly with error when device is not ready
 	 * to receive scan abort command or it does not perform
 	 * hardware scan currently */
-	if (!test_bit(STATUS_READY, &il->status) ||
-	    !test_bit(STATUS_GEO_CONFIGURED, &il->status) ||
-	    !test_bit(STATUS_SCAN_HW, &il->status) ||
-	    test_bit(STATUS_FW_ERROR, &il->status) ||
-	    test_bit(STATUS_EXIT_PENDING, &il->status))
+	if (!test_bit(S_READY, &il->status) ||
+	    !test_bit(S_GEO_CONFIGURED, &il->status) ||
+	    !test_bit(S_SCAN_HW, &il->status) ||
+	    test_bit(S_FW_ERROR, &il->status) ||
+	    test_bit(S_EXIT_PENDING, &il->status))
 		return -EIO;
 
 	ret = il_send_cmd_sync(il, &cmd);
@@ -109,15 +109,15 @@ void il_force_scan_end(struct il_priv *il)
 {
 	lockdep_assert_held(&il->mutex);
 
-	if (!test_bit(STATUS_SCANNING, &il->status)) {
+	if (!test_bit(S_SCANNING, &il->status)) {
 		D_SCAN("Forcing scan end while not scanning\n");
 		return;
 	}
 
 	D_SCAN("Forcing scan end\n");
-	clear_bit(STATUS_SCANNING, &il->status);
-	clear_bit(STATUS_SCAN_HW, &il->status);
-	clear_bit(STATUS_SCAN_ABORTING, &il->status);
+	clear_bit(S_SCANNING, &il->status);
+	clear_bit(S_SCAN_HW, &il->status);
+	clear_bit(S_SCAN_ABORTING, &il->status);
 	il_complete_scan(il, true);
 }
 
@@ -127,12 +127,12 @@ static void il_do_scan_abort(struct il_priv *il)
 
 	lockdep_assert_held(&il->mutex);
 
-	if (!test_bit(STATUS_SCANNING, &il->status)) {
+	if (!test_bit(S_SCANNING, &il->status)) {
 		D_SCAN("Not performing scan to abort\n");
 		return;
 	}
 
-	if (test_and_set_bit(STATUS_SCAN_ABORTING, &il->status)) {
+	if (test_and_set_bit(S_SCAN_ABORTING, &il->status)) {
 		D_SCAN("Scan abort in progress\n");
 		return;
 	}
@@ -172,12 +172,12 @@ int il_scan_cancel_timeout(struct il_priv *il, unsigned long ms)
 	il_do_scan_abort(il);
 
 	while (time_before_eq(jiffies, timeout)) {
-		if (!test_bit(STATUS_SCAN_HW, &il->status))
+		if (!test_bit(S_SCAN_HW, &il->status))
 			break;
 		msleep(20);
 	}
 
-	return test_bit(STATUS_SCAN_HW, &il->status);
+	return test_bit(S_SCAN_HW, &il->status);
 }
 EXPORT_SYMBOL(il_scan_cancel_timeout);
 
@@ -251,7 +251,7 @@ static void il_rx_scan_complete_notif(struct il_priv *il,
 		       scan_notif->tsf_high, scan_notif->status);
 
 	/* The HW is no longer scanning */
-	clear_bit(STATUS_SCAN_HW, &il->status);
+	clear_bit(S_SCAN_HW, &il->status);
 
 	D_SCAN("Scan on %sGHz took %dms\n",
 		       (il->scan_band == IEEE80211_BAND_2GHZ) ? "2.4" : "5.2",
@@ -341,25 +341,25 @@ static int il_scan_initiate(struct il_priv *il,
 		return -EIO;
 	}
 
-	if (test_bit(STATUS_SCAN_HW, &il->status)) {
+	if (test_bit(S_SCAN_HW, &il->status)) {
 		D_SCAN(
 			"Multiple concurrent scan requests in parallel.\n");
 		return -EBUSY;
 	}
 
-	if (test_bit(STATUS_SCAN_ABORTING, &il->status)) {
+	if (test_bit(S_SCAN_ABORTING, &il->status)) {
 		D_SCAN("Scan request while abort pending.\n");
 		return -EBUSY;
 	}
 
 	D_SCAN("Starting scan...\n");
 
-	set_bit(STATUS_SCANNING, &il->status);
+	set_bit(S_SCANNING, &il->status);
 	il->scan_start = jiffies;
 
 	ret = il->cfg->ops->utils->request_scan(il, vif);
 	if (ret) {
-		clear_bit(STATUS_SCANNING, &il->status);
+		clear_bit(S_SCANNING, &il->status);
 		return ret;
 	}
 
@@ -383,7 +383,7 @@ int il_mac_hw_scan(struct ieee80211_hw *hw,
 
 	mutex_lock(&il->mutex);
 
-	if (test_bit(STATUS_SCANNING, &il->status)) {
+	if (test_bit(S_SCANNING, &il->status)) {
 		D_SCAN("Scan already in progress.\n");
 		ret = -EAGAIN;
 		goto out_unlock;
@@ -494,11 +494,11 @@ static void il_bg_scan_completed(struct work_struct *work)
 
 	mutex_lock(&il->mutex);
 
-	aborted = test_and_clear_bit(STATUS_SCAN_ABORTING, &il->status);
+	aborted = test_and_clear_bit(S_SCAN_ABORTING, &il->status);
 	if (aborted)
 		D_SCAN("Aborted scan completed.\n");
 
-	if (!test_and_clear_bit(STATUS_SCANNING, &il->status)) {
+	if (!test_and_clear_bit(S_SCANNING, &il->status)) {
 		D_SCAN("Scan already completed.\n");
 		goto out_settings;
 	}
diff --git a/drivers/net/wireless/iwlegacy/iwl-tx.c b/drivers/net/wireless/iwlegacy/iwl-tx.c
index e46e588..3f97d09 100644
--- a/drivers/net/wireless/iwlegacy/iwl-tx.c
+++ b/drivers/net/wireless/iwlegacy/iwl-tx.c
@@ -51,7 +51,7 @@ il_txq_update_write_ptr(struct il_priv *il, struct il_tx_queue *txq)
 		return;
 
 	/* if we're trying to save power */
-	if (test_bit(STATUS_POWER_PMI, &il->status)) {
+	if (test_bit(S_POWER_PMI, &il->status)) {
 		/* wake up nic if it's powered down ...
 		 * uCode will wake up, and interrupt us again, so next
 		 * time we'll skip this part. */
@@ -641,7 +641,7 @@ il_tx_cmd_complete(struct il_priv *il, struct il_rx_buf *rxb)
 	il_hcmd_queue_reclaim(il, txq_id, idx, cmd_idx);
 
 	if (!(meta->flags & CMD_ASYNC)) {
-		clear_bit(STATUS_HCMD_ACTIVE, &il->status);
+		clear_bit(S_HCMD_ACTIVE, &il->status);
 		D_INFO("Clearing HCMD_ACTIVE for command %s\n",
 			       il_get_cmd_string(cmd->hdr.cmd));
 		wake_up(&il->wait_command_queue);
-- 
1.7.1

