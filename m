Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:12459 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751786Ab1HMSSb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Aug 2011 14:18:31 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 09/60] iwlagn: workqueue moves to iwl_shared
Date: Sat, 13 Aug 2011 10:37:45 -0700
Message-Id: <1313257116-2697-10-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110813_201848_288107_879F3C70)
In-Reply-To: <1313257116-2697-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1313257116-2697-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Since it is used by all the layers, it needs to move to iwl_shared.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c       |    6 +++---
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c        |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-tt.c        |    6 +++---
 drivers/net/wireless/iwlwifi/iwl-agn.c           |   16 ++++++++--------
 drivers/net/wireless/iwlwifi/iwl-core.c          |    2 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h           |    2 --
 drivers/net/wireless/iwlwifi/iwl-rx.c            |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-scan.c          |   11 ++++++-----
 drivers/net/wireless/iwlwifi/iwl-shared.h        |    3 +++
 drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c |    2 +-
 10 files changed, 28 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 6db9085..355a81c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -388,7 +388,7 @@ void iwl_check_abort_status(struct iwl_priv *priv,
 	if (frame_count == 1 && status == TX_STATUS_FAIL_RFKILL_FLUSH) {
 		IWL_ERR(priv, "Tx flush command to flush out all frames\n");
 		if (!test_bit(STATUS_EXIT_PENDING, &priv->status))
-			queue_work(priv->workqueue, &priv->tx_flush);
+			queue_work(priv->shrd->workqueue, &priv->tx_flush);
 	}
 }
 
@@ -1620,7 +1620,7 @@ static void iwlagn_set_kill_msk(struct iwl_priv *priv,
 		priv->kill_cts_mask = bt_kill_cts_msg[kill_msk];
 
 		/* schedule to send runtime bt_config */
-		queue_work(priv->workqueue, &priv->bt_runtime_config);
+		queue_work(priv->shrd->workqueue, &priv->bt_runtime_config);
 	}
 }
 
@@ -1664,7 +1664,7 @@ void iwlagn_bt_coex_profile_notif(struct iwl_priv *priv,
 					IWL_BT_COEX_TRAFFIC_LOAD_NONE;
 			}
 			priv->bt_status = coex->bt_status;
-			queue_work(priv->workqueue,
+			queue_work(priv->shrd->workqueue,
 				   &priv->bt_traffic_change_work);
 		}
 	}
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index 84e43ed..f6eef89 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -894,7 +894,7 @@ static void rs_bt_update_lq(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
 		rs_fill_link_cmd(priv, lq_sta, tbl->current_rate);
 		iwl_send_lq_cmd(priv, ctx, &lq_sta->lq, CMD_ASYNC, false);
 
-		queue_work(priv->workqueue, &priv->bt_full_concurrency);
+		queue_work(priv->shrd->workqueue, &priv->bt_full_concurrency);
 	}
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tt.c b/drivers/net/wireless/iwlwifi/iwl-agn-tt.c
index f501d74..2c5558a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tt.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tt.c
@@ -569,7 +569,7 @@ void iwl_tt_enter_ct_kill(struct iwl_priv *priv)
 		return;
 
 	IWL_DEBUG_TEMP(priv, "Queueing critical temperature enter.\n");
-	queue_work(priv->workqueue, &priv->ct_enter);
+	queue_work(priv->shrd->workqueue, &priv->ct_enter);
 }
 
 void iwl_tt_exit_ct_kill(struct iwl_priv *priv)
@@ -578,7 +578,7 @@ void iwl_tt_exit_ct_kill(struct iwl_priv *priv)
 		return;
 
 	IWL_DEBUG_TEMP(priv, "Queueing critical temperature exit.\n");
-	queue_work(priv->workqueue, &priv->ct_exit);
+	queue_work(priv->shrd->workqueue, &priv->ct_exit);
 }
 
 static void iwl_bg_tt_work(struct work_struct *work)
@@ -604,7 +604,7 @@ void iwl_tt_handler(struct iwl_priv *priv)
 		return;
 
 	IWL_DEBUG_TEMP(priv, "Queueing thermal throttling work.\n");
-	queue_work(priv->workqueue, &priv->tt_work);
+	queue_work(priv->shrd->workqueue, &priv->tt_work);
 }
 
 /* Thermal throttling initialization
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 46958f2..3523364 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2287,7 +2287,7 @@ static void iwlagn_mac_stop(struct ieee80211_hw *hw)
 
 	iwl_down(priv);
 
-	flush_workqueue(priv->workqueue);
+	flush_workqueue(priv->shrd->workqueue);
 
 	/* User space software may expect getting rfkill changes
 	 * even if interface is down */
@@ -3403,7 +3403,7 @@ static void iwl_mac_finish_tx_sync(struct ieee80211_hw *hw,
 
 static void iwl_setup_deferred_work(struct iwl_priv *priv)
 {
-	priv->workqueue = create_singlethread_workqueue(DRV_NAME);
+	priv->shrd->workqueue = create_singlethread_workqueue(DRV_NAME);
 
 	init_waitqueue_head(&priv->wait_command_queue);
 
@@ -3809,8 +3809,8 @@ int iwl_probe(struct iwl_bus *bus, struct iwl_cfg *cfg)
 	return 0;
 
 out_destroy_workqueue:
-	destroy_workqueue(priv->workqueue);
-	priv->workqueue = NULL;
+	destroy_workqueue(priv->shrd->workqueue);
+	priv->shrd->workqueue = NULL;
 	iwl_uninit_drv(priv);
 out_free_eeprom:
 	iwl_eeprom_free(priv);
@@ -3871,13 +3871,13 @@ void __devexit iwl_remove(struct iwl_priv * priv)
 	iwl_eeprom_free(priv);
 
 	/*netif_stop_queue(dev); */
-	flush_workqueue(priv->workqueue);
+	flush_workqueue(priv->shrd->workqueue);
 
 	/* ieee80211_unregister_hw calls iwl_mac_stop, which flushes
-	 * priv->workqueue... so we can't take down the workqueue
+	 * priv->shrd->workqueue... so we can't take down the workqueue
 	 * until now... */
-	destroy_workqueue(priv->workqueue);
-	priv->workqueue = NULL;
+	destroy_workqueue(priv->shrd->workqueue);
+	priv->shrd->workqueue = NULL;
 	iwl_free_traffic_mem(priv);
 
 	trans_free(&priv->trans);
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 02b70dc..b62ccd7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -894,7 +894,7 @@ void iwlagn_fw_error(struct iwl_priv *priv, bool ondemand)
 		if (iwlagn_mod_params.restart_fw) {
 			IWL_DEBUG(priv, IWL_DL_FW_ERRORS,
 				  "Restarting adapter due to uCode error.\n");
-			queue_work(priv->workqueue, &priv->restart);
+			queue_work(priv->shrd->workqueue, &priv->restart);
 		} else
 			IWL_DEBUG(priv, IWL_DL_FW_ERRORS,
 				  "Detected FW error, but not restarting\n");
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 7394bb1..8aa4ef5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1433,8 +1433,6 @@ struct iwl_priv {
 
 	u32 inta_mask;
 
-	struct workqueue_struct *workqueue;
-
 	struct work_struct restart;
 	struct work_struct scan_completed;
 	struct work_struct rx_replenish;
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index 8b3a089..c8af454 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -150,7 +150,7 @@ static void iwl_rx_beacon_notif(struct iwl_priv *priv,
 	priv->ibss_manager = le32_to_cpu(beacon->ibss_mgr_status);
 
 	if (!test_bit(STATUS_EXIT_PENDING, &priv->status))
-		queue_work(priv->workqueue, &priv->beacon_update);
+		queue_work(priv->shrd->workqueue, &priv->beacon_update);
 }
 
 /* the threshold ratio of actual_ack_cnt to expected_ack_cnt in percent */
@@ -487,7 +487,7 @@ static void iwl_rx_statistics(struct iwl_priv *priv,
 	if (unlikely(!test_bit(STATUS_SCANNING, &priv->status)) &&
 	    (pkt->hdr.cmd == STATISTICS_NOTIFICATION)) {
 		iwl_rx_calc_noise(priv);
-		queue_work(priv->workqueue, &priv->run_time_calib_work);
+		queue_work(priv->shrd->workqueue, &priv->run_time_calib_work);
 	}
 	if (priv->cfg->lib->temperature && change)
 		priv->cfg->lib->temperature(priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index bddb2da..6610b1d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -160,7 +160,7 @@ static void iwl_do_scan_abort(struct iwl_priv *priv)
 int iwl_scan_cancel(struct iwl_priv *priv)
 {
 	IWL_DEBUG_SCAN(priv, "Queuing abort scan\n");
-	queue_work(priv->workqueue, &priv->abort_scan);
+	queue_work(priv->shrd->workqueue, &priv->abort_scan);
 	return 0;
 }
 
@@ -263,7 +263,7 @@ static void iwl_rx_scan_complete_notif(struct iwl_priv *priv,
 		       (priv->scan_band == IEEE80211_BAND_2GHZ) ? "2.4" : "5.2",
 		       jiffies_to_msecs(jiffies - priv->scan_start));
 
-	queue_work(priv->workqueue, &priv->scan_completed);
+	queue_work(priv->shrd->workqueue, &priv->scan_completed);
 
 	if (priv->iw_mode != NL80211_IFTYPE_ADHOC &&
 	    iwl_advanced_bt_coexist(priv) &&
@@ -283,7 +283,8 @@ static void iwl_rx_scan_complete_notif(struct iwl_priv *priv,
 				IWL_BT_COEX_TRAFFIC_LOAD_NONE;
 		}
 		priv->bt_status = scan_notif->bt_status;
-		queue_work(priv->workqueue, &priv->bt_traffic_change_work);
+		queue_work(priv->shrd->workqueue,
+			   &priv->bt_traffic_change_work);
 	}
 }
 
@@ -394,7 +395,7 @@ int __must_check iwl_scan_initiate(struct iwl_priv *priv,
 		return ret;
 	}
 
-	queue_delayed_work(priv->workqueue, &priv->scan_check,
+	queue_delayed_work(priv->shrd->workqueue, &priv->scan_check,
 			   IWL_SCAN_CHECK_WATCHDOG);
 
 	return 0;
@@ -450,7 +451,7 @@ out_unlock:
  */
 void iwl_internal_short_hw_scan(struct iwl_priv *priv)
 {
-	queue_work(priv->workqueue, &priv->start_internal_scan);
+	queue_work(priv->shrd->workqueue, &priv->start_internal_scan);
 }
 
 static void iwl_bg_start_internal_scan(struct work_struct *work)
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index 0562174..85d5a62 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -147,6 +147,7 @@ struct iwl_hw_params {
  * @bus: pointer to the bus layer data
  * @priv: pointer to the upper layer data
  * @hw_params: see struct iwl_hw_params
+ * @workqueue: the workqueue used by all the layers of the driver
  */
 struct iwl_shared {
 #ifdef CONFIG_IWLWIFI_DEBUG
@@ -158,6 +159,8 @@ struct iwl_shared {
 	struct iwl_bus *bus;
 	struct iwl_priv *priv;
 	struct iwl_hw_params hw_params;
+
+	struct workqueue_struct *workqueue;
 };
 
 /*Whatever _m is (iwl_trans, iwl_priv, iwl_bus, these macros will work */
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c
index 52edd6a..10627f8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c
@@ -224,7 +224,7 @@ static void iwlagn_rx_queue_restock(struct iwl_priv *priv)
 	/* If the pre-allocated buffer pool is dropping low, schedule to
 	 * refill it */
 	if (rxq->free_count <= RX_LOW_WATERMARK)
-		queue_work(priv->workqueue, &priv->rx_replenish);
+		queue_work(priv->shrd->workqueue, &priv->rx_replenish);
 
 
 	/* If we've added more space for the firmware to place data, tell it.
-- 
1.7.0.4

