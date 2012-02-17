Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:46093 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752461Ab2BQUXu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Feb 2012 15:23:50 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 05/26] iwlwifi: move workqueue to priv
Date: Fri, 17 Feb 2012 11:13:33 -0800
Message-Id: <1329506034-1394-6-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120217_212447_234182_92D08B93)
In-Reply-To: <1329506034-1394-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1329506034-1394-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

In order to separate the different parts of the
driver better, we are reducing the shared data.
This moves the workqueue to "priv", and removes
it from the transport. To do this, simply use
schedule_work() in the transport.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c       |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c        |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rx.c        |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-tt.c        |    6 +++---
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c        |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c           |   14 +++++++-------
 drivers/net/wireless/iwlwifi/iwl-core.c          |    2 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h           |    2 ++
 drivers/net/wireless/iwlwifi/iwl-mac80211.c      |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-scan.c          |   10 +++++-----
 drivers/net/wireless/iwlwifi/iwl-shared.h        |    2 --
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c |   10 ++--------
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c    |    2 ++
 13 files changed, 29 insertions(+), 33 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index a8f7689..30b99b9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -700,7 +700,7 @@ static void iwlagn_set_kill_msk(struct iwl_priv *priv,
 		priv->kill_cts_mask = bt_kill_cts_msg[kill_msk];
 
 		/* schedule to send runtime bt_config */
-		queue_work(priv->shrd->workqueue, &priv->bt_runtime_config);
+		queue_work(priv->workqueue, &priv->bt_runtime_config);
 	}
 }
 
@@ -745,7 +745,7 @@ int iwlagn_bt_coex_profile_notif(struct iwl_priv *priv,
 					IWL_BT_COEX_TRAFFIC_LOAD_NONE;
 			}
 			priv->bt_status = coex->bt_status;
-			queue_work(priv->shrd->workqueue,
+			queue_work(priv->workqueue,
 				   &priv->bt_traffic_change_work);
 		}
 	}
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index b9ba404..f88e2e3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -892,7 +892,7 @@ static void rs_bt_update_lq(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
 		rs_fill_link_cmd(priv, lq_sta, tbl->current_rate);
 		iwl_send_lq_cmd(priv, ctx, &lq_sta->lq, CMD_ASYNC, false);
 
-		queue_work(priv->shrd->workqueue, &priv->bt_full_concurrency);
+		queue_work(priv->workqueue, &priv->bt_full_concurrency);
 	}
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rx.c b/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
index a14ddab..aee7d06 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
@@ -581,7 +581,7 @@ static int iwlagn_rx_statistics(struct iwl_priv *priv,
 	if (unlikely(!test_bit(STATUS_SCANNING, &priv->shrd->status)) &&
 	    (pkt->hdr.cmd == STATISTICS_NOTIFICATION)) {
 		iwlagn_rx_calc_noise(priv);
-		queue_work(priv->shrd->workqueue, &priv->run_time_calib_work);
+		queue_work(priv->workqueue, &priv->run_time_calib_work);
 	}
 	if (cfg(priv)->lib->temperature && change)
 		cfg(priv)->lib->temperature(priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tt.c b/drivers/net/wireless/iwlwifi/iwl-agn-tt.c
index c728ed7..56d7c0e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tt.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tt.c
@@ -568,7 +568,7 @@ void iwl_tt_enter_ct_kill(struct iwl_priv *priv)
 		return;
 
 	IWL_DEBUG_TEMP(priv, "Queueing critical temperature enter.\n");
-	queue_work(priv->shrd->workqueue, &priv->ct_enter);
+	queue_work(priv->workqueue, &priv->ct_enter);
 }
 
 void iwl_tt_exit_ct_kill(struct iwl_priv *priv)
@@ -577,7 +577,7 @@ void iwl_tt_exit_ct_kill(struct iwl_priv *priv)
 		return;
 
 	IWL_DEBUG_TEMP(priv, "Queueing critical temperature exit.\n");
-	queue_work(priv->shrd->workqueue, &priv->ct_exit);
+	queue_work(priv->workqueue, &priv->ct_exit);
 }
 
 static void iwl_bg_tt_work(struct work_struct *work)
@@ -600,7 +600,7 @@ void iwl_tt_handler(struct iwl_priv *priv)
 		return;
 
 	IWL_DEBUG_TEMP(priv, "Queueing thermal throttling work.\n");
-	queue_work(priv->shrd->workqueue, &priv->tt_work);
+	queue_work(priv->workqueue, &priv->tt_work);
 }
 
 /* Thermal throttling initialization
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index 64f8db6..da18a8f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -983,7 +983,7 @@ static void iwl_check_abort_status(struct iwl_priv *priv,
 	if (frame_count == 1 && status == TX_STATUS_FAIL_RFKILL_FLUSH) {
 		IWL_ERR(priv, "Tx flush command to flush out all frames\n");
 		if (!test_bit(STATUS_EXIT_PENDING, &priv->shrd->status))
-			queue_work(priv->shrd->workqueue, &priv->tx_flush);
+			queue_work(priv->workqueue, &priv->tx_flush);
 	}
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 8837171..1cf99a5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -939,7 +939,7 @@ static void iwlagn_disable_roc_work(struct work_struct *work)
 
 static void iwl_setup_deferred_work(struct iwl_priv *priv)
 {
-	priv->shrd->workqueue = create_singlethread_workqueue(DRV_NAME);
+	priv->workqueue = create_singlethread_workqueue(DRV_NAME);
 
 	init_waitqueue_head(&priv->shrd->wait_command_queue);
 
@@ -1282,8 +1282,8 @@ int iwl_probe(struct iwl_bus *bus, const struct iwl_trans_ops *trans_ops,
 	return 0;
 
 out_destroy_workqueue:
-	destroy_workqueue(priv->shrd->workqueue);
-	priv->shrd->workqueue = NULL;
+	destroy_workqueue(priv->workqueue);
+	priv->workqueue = NULL;
 	iwl_uninit_drv(priv);
 out_free_eeprom:
 	iwl_eeprom_free(priv->shrd);
@@ -1321,13 +1321,13 @@ void __devexit iwl_remove(struct iwl_priv * priv)
 	iwl_eeprom_free(priv->shrd);
 
 	/*netif_stop_queue(dev); */
-	flush_workqueue(priv->shrd->workqueue);
+	flush_workqueue(priv->workqueue);
 
 	/* ieee80211_unregister_hw calls iwlagn_mac_stop, which flushes
-	 * priv->shrd->workqueue... so we can't take down the workqueue
+	 * priv->workqueue... so we can't take down the workqueue
 	 * until now... */
-	destroy_workqueue(priv->shrd->workqueue);
-	priv->shrd->workqueue = NULL;
+	destroy_workqueue(priv->workqueue);
+	priv->workqueue = NULL;
 	iwl_free_traffic_mem(priv);
 
 	iwl_uninit_drv(priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 0677b3d..6dff9c4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -875,7 +875,7 @@ void iwlagn_fw_error(struct iwl_priv *priv, bool ondemand)
 		if (iwlagn_mod_params.restart_fw) {
 			IWL_DEBUG_FW_ERRORS(priv,
 				  "Restarting adapter due to uCode error.\n");
-			queue_work(priv->shrd->workqueue, &priv->restart);
+			queue_work(priv->workqueue, &priv->restart);
 		} else
 			IWL_DEBUG_FW_ERRORS(priv,
 				  "Detected FW error, but not restarting\n");
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 0e8f137..db37877 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -721,6 +721,8 @@ struct iwl_priv {
 	struct ieee80211_rate *ieee_rates;
 	struct kmem_cache *tx_cmd_pool;
 
+	struct workqueue_struct *workqueue;
+
 	enum ieee80211_band band;
 
 	void (*pre_rx_handler)(struct iwl_priv *priv,
diff --git a/drivers/net/wireless/iwlwifi/iwl-mac80211.c b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
index d8025fe..17358cf 100644
--- a/drivers/net/wireless/iwlwifi/iwl-mac80211.c
+++ b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
@@ -343,7 +343,7 @@ static void iwlagn_mac_stop(struct ieee80211_hw *hw)
 
 	iwl_down(priv);
 
-	flush_workqueue(priv->shrd->workqueue);
+	flush_workqueue(priv->workqueue);
 
 	/* User space software may expect getting rfkill changes
 	 * even if interface is down, trans->down will leave the RF
@@ -1117,7 +1117,7 @@ static int iwlagn_mac_set_tim(struct ieee80211_hw *hw,
 {
 	struct iwl_priv *priv = hw->priv;
 
-	queue_work(priv->shrd->workqueue, &priv->beacon_update);
+	queue_work(priv->workqueue, &priv->beacon_update);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index 7f2e3a1..42ee1c4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -218,7 +218,7 @@ static void iwl_do_scan_abort(struct iwl_priv *priv)
 int iwl_scan_cancel(struct iwl_priv *priv)
 {
 	IWL_DEBUG_SCAN(priv, "Queuing abort scan\n");
-	queue_work(priv->shrd->workqueue, &priv->abort_scan);
+	queue_work(priv->workqueue, &priv->abort_scan);
 	return 0;
 }
 
@@ -354,7 +354,7 @@ static int iwl_rx_scan_complete_notif(struct iwl_priv *priv,
 	 */
 	set_bit(STATUS_SCAN_COMPLETE, &priv->shrd->status);
 	clear_bit(STATUS_SCAN_HW, &priv->shrd->status);
-	queue_work(priv->shrd->workqueue, &priv->scan_completed);
+	queue_work(priv->workqueue, &priv->scan_completed);
 
 	if (priv->iw_mode != NL80211_IFTYPE_ADHOC &&
 	    iwl_advanced_bt_coexist(priv) &&
@@ -374,7 +374,7 @@ static int iwl_rx_scan_complete_notif(struct iwl_priv *priv,
 				IWL_BT_COEX_TRAFFIC_LOAD_NONE;
 		}
 		priv->bt_status = scan_notif->bt_status;
-		queue_work(priv->shrd->workqueue,
+		queue_work(priv->workqueue,
 			   &priv->bt_traffic_change_work);
 	}
 	return 0;
@@ -950,7 +950,7 @@ int __must_check iwl_scan_initiate(struct iwl_priv *priv,
 		return ret;
 	}
 
-	queue_delayed_work(priv->shrd->workqueue, &priv->scan_check,
+	queue_delayed_work(priv->workqueue, &priv->scan_check,
 			   IWL_SCAN_CHECK_WATCHDOG);
 
 	return 0;
@@ -963,7 +963,7 @@ int __must_check iwl_scan_initiate(struct iwl_priv *priv,
  */
 void iwl_internal_short_hw_scan(struct iwl_priv *priv)
 {
-	queue_work(priv->shrd->workqueue, &priv->start_internal_scan);
+	queue_work(priv->workqueue, &priv->start_internal_scan);
 }
 
 static void iwl_bg_start_internal_scan(struct work_struct *work)
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index 63d4a4f..42bf43b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -359,7 +359,6 @@ struct iwl_cfg {
  * @priv: pointer to the upper layer data
  * @trans: pointer to the transport layer data
  * @hw_params: see struct iwl_hw_params
- * @workqueue: the workqueue used by all the layers of the driver
  * @lock: protect general shared data
  * @sta_lock: protects the station table.
  *	If lock and sta_lock are needed, lock must be acquired first.
@@ -391,7 +390,6 @@ struct iwl_shared {
 	struct iwl_trans *trans;
 	struct iwl_hw_params hw_params;
 
-	struct workqueue_struct *workqueue;
 	spinlock_t lock;
 	spinlock_t sta_lock;
 	struct mutex mutex;
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
index 3826852..1b11cfe 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
@@ -227,7 +227,7 @@ static void iwlagn_rx_queue_restock(struct iwl_trans *trans)
 	/* If the pre-allocated buffer pool is dropping low, schedule to
 	 * refill it */
 	if (rxq->free_count <= RX_LOW_WATERMARK)
-		queue_work(trans->shrd->workqueue, &trans_pcie->rx_replenish);
+		schedule_work(&trans_pcie->rx_replenish);
 
 
 	/* If we've added more space for the firmware to place data, tell it.
@@ -351,14 +351,8 @@ void iwl_bg_rx_replenish(struct work_struct *data)
 {
 	struct iwl_trans_pcie *trans_pcie =
 	    container_of(data, struct iwl_trans_pcie, rx_replenish);
-	struct iwl_trans *trans = trans_pcie->trans;
 
-	if (test_bit(STATUS_EXIT_PENDING, &trans->shrd->status))
-		return;
-
-	mutex_lock(&trans->shrd->mutex);
-	iwlagn_rx_replenish(trans);
-	mutex_unlock(&trans->shrd->mutex);
+	iwlagn_rx_replenish(trans_pcie->trans);
 }
 
 /**
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
index f5cb5d3..e8d1dbf 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -1293,6 +1293,8 @@ static void iwl_trans_pcie_stop_device(struct iwl_trans *trans)
 	synchronize_irq(trans->irq);
 	tasklet_kill(&trans_pcie->irq_tasklet);
 
+	cancel_work_sync(&trans_pcie->rx_replenish);
+
 	/* stop and reset the on-board processor */
 	iwl_write32(trans, CSR_RESET, CSR_RESET_REG_FLAG_NEVO_RESET);
 }
-- 
1.7.0.4

