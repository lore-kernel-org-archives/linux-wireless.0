Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:37379 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754691AbbHDU7B (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Aug 2015 16:59:01 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 10/37] iwlwifi: dvm: remove command/return value from RX handlers
Date: Tue,  4 Aug 2015 23:43:00 +0300
Message-Id: <1438721007-23283-10-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150804_225913_165594_28F043B3)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E7E11FA@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E7E11FA@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

After the previous patches, the command that's passed in nor the
return value are used any more, so can be removed.

While at it, make some functions static.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/agn.h  |  14 ++---
 drivers/net/wireless/iwlwifi/dvm/dev.h  |   5 +-
 drivers/net/wireless/iwlwifi/dvm/lib.c  |   8 +--
 drivers/net/wireless/iwlwifi/dvm/rx.c   | 103 ++++++++++++--------------------
 drivers/net/wireless/iwlwifi/dvm/scan.c |  25 +++-----
 drivers/net/wireless/iwlwifi/dvm/sta.c  |  16 ++---
 drivers/net/wireless/iwlwifi/dvm/tx.c   |  18 ++----
 7 files changed, 65 insertions(+), 124 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/agn.h b/drivers/net/wireless/iwlwifi/dvm/agn.h
index c160dad..f549dc3 100644
--- a/drivers/net/wireless/iwlwifi/dvm/agn.h
+++ b/drivers/net/wireless/iwlwifi/dvm/agn.h
@@ -216,11 +216,9 @@ int iwlagn_tx_agg_stop(struct iwl_priv *priv, struct ieee80211_vif *vif,
 		       struct ieee80211_sta *sta, u16 tid);
 int iwlagn_tx_agg_flush(struct iwl_priv *priv, struct ieee80211_vif *vif,
 			struct ieee80211_sta *sta, u16 tid);
-int iwlagn_rx_reply_compressed_ba(struct iwl_priv *priv,
-				   struct iwl_rx_cmd_buffer *rxb,
-				   struct iwl_device_cmd *cmd);
-int iwlagn_rx_reply_tx(struct iwl_priv *priv, struct iwl_rx_cmd_buffer *rxb,
-			       struct iwl_device_cmd *cmd);
+void iwlagn_rx_reply_compressed_ba(struct iwl_priv *priv,
+				   struct iwl_rx_cmd_buffer *rxb);
+void iwlagn_rx_reply_tx(struct iwl_priv *priv, struct iwl_rx_cmd_buffer *rxb);
 
 static inline u32 iwl_tx_status_to_mac80211(u32 status)
 {
@@ -277,9 +275,6 @@ int __must_check iwl_scan_initiate(struct iwl_priv *priv,
 
 /* bt coex */
 void iwlagn_send_advance_bt_config(struct iwl_priv *priv);
-int iwlagn_bt_coex_profile_notif(struct iwl_priv *priv,
-				  struct iwl_rx_cmd_buffer *rxb,
-				  struct iwl_device_cmd *cmd);
 void iwlagn_bt_rx_handler_setup(struct iwl_priv *priv);
 void iwlagn_bt_setup_deferred_work(struct iwl_priv *priv);
 void iwlagn_bt_cancel_deferred_work(struct iwl_priv *priv);
@@ -332,8 +327,7 @@ u8 iwl_prep_station(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
 
 int iwl_send_lq_cmd(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
 		    struct iwl_link_quality_cmd *lq, u8 flags, bool init);
-int iwl_add_sta_callback(struct iwl_priv *priv, struct iwl_rx_cmd_buffer *rxb,
-			       struct iwl_device_cmd *cmd);
+void iwl_add_sta_callback(struct iwl_priv *priv, struct iwl_rx_cmd_buffer *rxb);
 int iwl_sta_update_ht(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
 		      struct ieee80211_sta *sta);
 
diff --git a/drivers/net/wireless/iwlwifi/dvm/dev.h b/drivers/net/wireless/iwlwifi/dvm/dev.h
index 3811878..1f51757 100644
--- a/drivers/net/wireless/iwlwifi/dvm/dev.h
+++ b/drivers/net/wireless/iwlwifi/dvm/dev.h
@@ -678,9 +678,8 @@ struct iwl_priv {
 	enum ieee80211_band band;
 	u8 valid_contexts;
 
-	int (*rx_handlers[REPLY_MAX])(struct iwl_priv *priv,
-				       struct iwl_rx_cmd_buffer *rxb,
-				       struct iwl_device_cmd *cmd);
+	void (*rx_handlers[REPLY_MAX])(struct iwl_priv *priv,
+				       struct iwl_rx_cmd_buffer *rxb);
 
 	struct iwl_notif_wait_data notif_wait;
 
diff --git a/drivers/net/wireless/iwlwifi/dvm/lib.c b/drivers/net/wireless/iwlwifi/dvm/lib.c
index 1d2223d..ab45819 100644
--- a/drivers/net/wireless/iwlwifi/dvm/lib.c
+++ b/drivers/net/wireless/iwlwifi/dvm/lib.c
@@ -659,9 +659,8 @@ static bool iwlagn_fill_txpower_mode(struct iwl_priv *priv,
 	return need_update;
 }
 
-int iwlagn_bt_coex_profile_notif(struct iwl_priv *priv,
-				  struct iwl_rx_cmd_buffer *rxb,
-				  struct iwl_device_cmd *cmd)
+static void iwlagn_bt_coex_profile_notif(struct iwl_priv *priv,
+					 struct iwl_rx_cmd_buffer *rxb)
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	struct iwl_bt_coex_profile_notif *coex = (void *)pkt->data;
@@ -669,7 +668,7 @@ int iwlagn_bt_coex_profile_notif(struct iwl_priv *priv,
 
 	if (priv->bt_enable_flag == IWLAGN_BT_FLAG_COEX_MODE_DISABLED) {
 		/* bt coex disabled */
-		return 0;
+		return;
 	}
 
 	IWL_DEBUG_COEX(priv, "BT Coex notification:\n");
@@ -714,7 +713,6 @@ int iwlagn_bt_coex_profile_notif(struct iwl_priv *priv,
 	/* FIXME: based on notification, adjust the prio_boost */
 
 	priv->bt_ci_compliance = coex->bt_ci_compliance;
-	return 0;
 }
 
 void iwlagn_bt_rx_handler_setup(struct iwl_priv *priv)
diff --git a/drivers/net/wireless/iwlwifi/dvm/rx.c b/drivers/net/wireless/iwlwifi/dvm/rx.c
index debec96..ca270a6 100644
--- a/drivers/net/wireless/iwlwifi/dvm/rx.c
+++ b/drivers/net/wireless/iwlwifi/dvm/rx.c
@@ -123,9 +123,8 @@ const char *const iwl_dvm_cmd_strings[REPLY_MAX] = {
  *
  ******************************************************************************/
 
-static int iwlagn_rx_reply_error(struct iwl_priv *priv,
-			       struct iwl_rx_cmd_buffer *rxb,
-			       struct iwl_device_cmd *cmd)
+static void iwlagn_rx_reply_error(struct iwl_priv *priv,
+				  struct iwl_rx_cmd_buffer *rxb)
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	struct iwl_error_resp *err_resp = (void *)pkt->data;
@@ -136,11 +135,9 @@ static int iwlagn_rx_reply_error(struct iwl_priv *priv,
 		err_resp->cmd_id,
 		le16_to_cpu(err_resp->bad_cmd_seq_num),
 		le32_to_cpu(err_resp->error_info));
-	return 0;
 }
 
-static int iwlagn_rx_csa(struct iwl_priv *priv, struct iwl_rx_cmd_buffer *rxb,
-			       struct iwl_device_cmd *cmd)
+static void iwlagn_rx_csa(struct iwl_priv *priv, struct iwl_rx_cmd_buffer *rxb)
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	struct iwl_csa_notification *csa = (void *)pkt->data;
@@ -152,7 +149,7 @@ static int iwlagn_rx_csa(struct iwl_priv *priv, struct iwl_rx_cmd_buffer *rxb,
 	struct iwl_rxon_cmd *rxon = (void *)&ctx->active;
 
 	if (!test_bit(STATUS_CHANNEL_SWITCH_PENDING, &priv->status))
-		return 0;
+		return;
 
 	if (!le32_to_cpu(csa->status) && csa->channel == priv->switch_channel) {
 		rxon->channel = csa->channel;
@@ -165,13 +162,11 @@ static int iwlagn_rx_csa(struct iwl_priv *priv, struct iwl_rx_cmd_buffer *rxb,
 			le16_to_cpu(csa->channel));
 		iwl_chswitch_done(priv, false);
 	}
-	return 0;
 }
 
 
-static int iwlagn_rx_spectrum_measure_notif(struct iwl_priv *priv,
-					  struct iwl_rx_cmd_buffer *rxb,
-					  struct iwl_device_cmd *cmd)
+static void iwlagn_rx_spectrum_measure_notif(struct iwl_priv *priv,
+					     struct iwl_rx_cmd_buffer *rxb)
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	struct iwl_spectrum_notification *report = (void *)pkt->data;
@@ -179,17 +174,15 @@ static int iwlagn_rx_spectrum_measure_notif(struct iwl_priv *priv,
 	if (!report->state) {
 		IWL_DEBUG_11H(priv,
 			"Spectrum Measure Notification: Start\n");
-		return 0;
+		return;
 	}
 
 	memcpy(&priv->measure_report, report, sizeof(*report));
 	priv->measurement_status |= MEASUREMENT_READY;
-	return 0;
 }
 
-static int iwlagn_rx_pm_sleep_notif(struct iwl_priv *priv,
-				  struct iwl_rx_cmd_buffer *rxb,
-				  struct iwl_device_cmd *cmd)
+static void iwlagn_rx_pm_sleep_notif(struct iwl_priv *priv,
+				     struct iwl_rx_cmd_buffer *rxb)
 {
 #ifdef CONFIG_IWLWIFI_DEBUG
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
@@ -197,24 +190,20 @@ static int iwlagn_rx_pm_sleep_notif(struct iwl_priv *priv,
 	IWL_DEBUG_RX(priv, "sleep mode: %d, src: %d\n",
 		     sleep->pm_sleep_mode, sleep->pm_wakeup_src);
 #endif
-	return 0;
 }
 
-static int iwlagn_rx_pm_debug_statistics_notif(struct iwl_priv *priv,
-					     struct iwl_rx_cmd_buffer *rxb,
-					     struct iwl_device_cmd *cmd)
+static void iwlagn_rx_pm_debug_statistics_notif(struct iwl_priv *priv,
+						struct iwl_rx_cmd_buffer *rxb)
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	u32 __maybe_unused len = iwl_rx_packet_len(pkt);
 	IWL_DEBUG_RADIO(priv, "Dumping %d bytes of unhandled "
 			"notification for PM_DEBUG_STATISTIC_NOTIFIC:\n", len);
 	iwl_print_hex_dump(priv, IWL_DL_RADIO, pkt->data, len);
-	return 0;
 }
 
-static int iwlagn_rx_beacon_notif(struct iwl_priv *priv,
-				struct iwl_rx_cmd_buffer *rxb,
-				struct iwl_device_cmd *cmd)
+static void iwlagn_rx_beacon_notif(struct iwl_priv *priv,
+				   struct iwl_rx_cmd_buffer *rxb)
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	struct iwlagn_beacon_notif *beacon = (void *)pkt->data;
@@ -232,8 +221,6 @@ static int iwlagn_rx_beacon_notif(struct iwl_priv *priv,
 #endif
 
 	priv->ibss_manager = le32_to_cpu(beacon->ibss_mgr_status);
-
-	return 0;
 }
 
 /**
@@ -448,9 +435,8 @@ iwlagn_accumulative_statistics(struct iwl_priv *priv,
 }
 #endif
 
-static int iwlagn_rx_statistics(struct iwl_priv *priv,
-			      struct iwl_rx_cmd_buffer *rxb,
-			      struct iwl_device_cmd *cmd)
+static void iwlagn_rx_statistics(struct iwl_priv *priv,
+				 struct iwl_rx_cmd_buffer *rxb)
 {
 	unsigned long stamp = jiffies;
 	const int reg_recalib_period = 60;
@@ -505,7 +491,7 @@ static int iwlagn_rx_statistics(struct iwl_priv *priv,
 			  len, sizeof(struct iwl_bt_notif_statistics),
 			  sizeof(struct iwl_notif_statistics));
 		spin_unlock(&priv->statistics.lock);
-		return 0;
+		return;
 	}
 
 	change = common->temperature != priv->statistics.common.temperature ||
@@ -550,13 +536,10 @@ static int iwlagn_rx_statistics(struct iwl_priv *priv,
 		priv->lib->temperature(priv);
 
 	spin_unlock(&priv->statistics.lock);
-
-	return 0;
 }
 
-static int iwlagn_rx_reply_statistics(struct iwl_priv *priv,
-				    struct iwl_rx_cmd_buffer *rxb,
-				    struct iwl_device_cmd *cmd)
+static void iwlagn_rx_reply_statistics(struct iwl_priv *priv,
+				       struct iwl_rx_cmd_buffer *rxb)
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	struct iwl_notif_statistics *stats = (void *)pkt->data;
@@ -572,15 +555,14 @@ static int iwlagn_rx_reply_statistics(struct iwl_priv *priv,
 #endif
 		IWL_DEBUG_RX(priv, "Statistics have been cleared\n");
 	}
-	iwlagn_rx_statistics(priv, rxb, cmd);
-	return 0;
+
+	iwlagn_rx_statistics(priv, rxb);
 }
 
 /* Handle notification from uCode that card's power state is changing
  * due to software, hardware, or critical temperature RFKILL */
-static int iwlagn_rx_card_state_notif(struct iwl_priv *priv,
-				    struct iwl_rx_cmd_buffer *rxb,
-				    struct iwl_device_cmd *cmd)
+static void iwlagn_rx_card_state_notif(struct iwl_priv *priv,
+				       struct iwl_rx_cmd_buffer *rxb)
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	struct iwl_card_state_notif *card_state_notif = (void *)pkt->data;
@@ -627,12 +609,10 @@ static int iwlagn_rx_card_state_notif(struct iwl_priv *priv,
 	     test_bit(STATUS_RF_KILL_HW, &priv->status)))
 		wiphy_rfkill_set_hw_state(priv->hw->wiphy,
 			test_bit(STATUS_RF_KILL_HW, &priv->status));
-	return 0;
 }
 
-static int iwlagn_rx_missed_beacon_notif(struct iwl_priv *priv,
-				       struct iwl_rx_cmd_buffer *rxb,
-				       struct iwl_device_cmd *cmd)
+static void iwlagn_rx_missed_beacon_notif(struct iwl_priv *priv,
+					  struct iwl_rx_cmd_buffer *rxb)
 
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
@@ -649,14 +629,12 @@ static int iwlagn_rx_missed_beacon_notif(struct iwl_priv *priv,
 		if (!test_bit(STATUS_SCANNING, &priv->status))
 			iwl_init_sensitivity(priv);
 	}
-	return 0;
 }
 
 /* Cache phy data (Rx signal strength, etc) for HT frame (REPLY_RX_PHY_CMD).
  * This will be used later in iwl_rx_reply_rx() for REPLY_RX_MPDU_CMD. */
-static int iwlagn_rx_reply_rx_phy(struct iwl_priv *priv,
-				struct iwl_rx_cmd_buffer *rxb,
-				struct iwl_device_cmd *cmd)
+static void iwlagn_rx_reply_rx_phy(struct iwl_priv *priv,
+				   struct iwl_rx_cmd_buffer *rxb)
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 
@@ -664,7 +642,6 @@ static int iwlagn_rx_reply_rx_phy(struct iwl_priv *priv,
 	priv->ampdu_ref++;
 	memcpy(&priv->last_phy_res, pkt->data,
 	       sizeof(struct iwl_rx_phy_res));
-	return 0;
 }
 
 /*
@@ -890,9 +867,8 @@ static int iwlagn_calc_rssi(struct iwl_priv *priv,
 }
 
 /* Called for REPLY_RX_MPDU_CMD */
-static int iwlagn_rx_reply_rx(struct iwl_priv *priv,
-			    struct iwl_rx_cmd_buffer *rxb,
-			    struct iwl_device_cmd *cmd)
+static void iwlagn_rx_reply_rx(struct iwl_priv *priv,
+			       struct iwl_rx_cmd_buffer *rxb)
 {
 	struct ieee80211_hdr *header;
 	struct ieee80211_rx_status rx_status = {};
@@ -906,7 +882,7 @@ static int iwlagn_rx_reply_rx(struct iwl_priv *priv,
 
 	if (!priv->last_phy_res_valid) {
 		IWL_ERR(priv, "MPDU frame without cached PHY data\n");
-		return 0;
+		return;
 	}
 	phy_res = &priv->last_phy_res;
 	amsdu = (struct iwl_rx_mpdu_res_start *)pkt->data;
@@ -919,14 +895,14 @@ static int iwlagn_rx_reply_rx(struct iwl_priv *priv,
 	if ((unlikely(phy_res->cfg_phy_cnt > 20))) {
 		IWL_DEBUG_DROP(priv, "dsp size out of range [0,20]: %d\n",
 				phy_res->cfg_phy_cnt);
-		return 0;
+		return;
 	}
 
 	if (!(rx_pkt_status & RX_RES_STATUS_NO_CRC32_ERROR) ||
 	    !(rx_pkt_status & RX_RES_STATUS_NO_RXE_OVERFLOW)) {
 		IWL_DEBUG_RX(priv, "Bad CRC or FIFO: 0x%08X.\n",
 				le32_to_cpu(rx_pkt_status));
-		return 0;
+		return;
 	}
 
 	/* This will be used in several places later */
@@ -998,12 +974,10 @@ static int iwlagn_rx_reply_rx(struct iwl_priv *priv,
 
 	iwlagn_pass_packet_to_mac80211(priv, header, len, ampdu_status,
 				    rxb, &rx_status);
-	return 0;
 }
 
-static int iwlagn_rx_noa_notification(struct iwl_priv *priv,
-				      struct iwl_rx_cmd_buffer *rxb,
-				      struct iwl_device_cmd *cmd)
+static void iwlagn_rx_noa_notification(struct iwl_priv *priv,
+				       struct iwl_rx_cmd_buffer *rxb)
 {
 	struct iwl_wipan_noa_data *new_data, *old_data;
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
@@ -1041,8 +1015,6 @@ static int iwlagn_rx_noa_notification(struct iwl_priv *priv,
 
 	if (old_data)
 		kfree_rcu(old_data, rcu_head);
-
-	return 0;
 }
 
 /**
@@ -1053,8 +1025,7 @@ static int iwlagn_rx_noa_notification(struct iwl_priv *priv,
  */
 void iwl_setup_rx_handlers(struct iwl_priv *priv)
 {
-	int (**handlers)(struct iwl_priv *priv, struct iwl_rx_cmd_buffer *rxb,
-			       struct iwl_device_cmd *cmd);
+	void (**handlers)(struct iwl_priv *priv, struct iwl_rx_cmd_buffer *rxb);
 
 	handlers = priv->rx_handlers;
 
@@ -1107,7 +1078,6 @@ int iwl_rx_dispatch(struct iwl_op_mode *op_mode, struct iwl_rx_cmd_buffer *rxb,
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	struct iwl_priv *priv = IWL_OP_MODE_GET_DVM(op_mode);
-	int err = 0;
 
 	/*
 	 * Do the notification wait before RX handlers so
@@ -1121,12 +1091,13 @@ int iwl_rx_dispatch(struct iwl_op_mode *op_mode, struct iwl_rx_cmd_buffer *rxb,
 	 *   rx_handlers table.  See iwl_setup_rx_handlers() */
 	if (priv->rx_handlers[pkt->hdr.cmd]) {
 		priv->rx_handlers_stats[pkt->hdr.cmd]++;
-		err = priv->rx_handlers[pkt->hdr.cmd] (priv, rxb, cmd);
+		priv->rx_handlers[pkt->hdr.cmd](priv, rxb);
 	} else {
 		/* No handling needed */
 		IWL_DEBUG_RX(priv, "No handler needed for %s, 0x%02x\n",
 			     iwl_dvm_get_cmd_string(pkt->hdr.cmd),
 			     pkt->hdr.cmd);
 	}
-	return err;
+
+	return 0;
 }
diff --git a/drivers/net/wireless/iwlwifi/dvm/scan.c b/drivers/net/wireless/iwlwifi/dvm/scan.c
index 43bef90..6481594 100644
--- a/drivers/net/wireless/iwlwifi/dvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/dvm/scan.c
@@ -247,9 +247,8 @@ void iwl_scan_cancel_timeout(struct iwl_priv *priv, unsigned long ms)
 }
 
 /* Service response to REPLY_SCAN_CMD (0x80) */
-static int iwl_rx_reply_scan(struct iwl_priv *priv,
-			      struct iwl_rx_cmd_buffer *rxb,
-			      struct iwl_device_cmd *cmd)
+static void iwl_rx_reply_scan(struct iwl_priv *priv,
+			      struct iwl_rx_cmd_buffer *rxb)
 {
 #ifdef CONFIG_IWLWIFI_DEBUG
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
@@ -257,13 +256,11 @@ static int iwl_rx_reply_scan(struct iwl_priv *priv,
 
 	IWL_DEBUG_SCAN(priv, "Scan request status = 0x%x\n", notif->status);
 #endif
-	return 0;
 }
 
 /* Service SCAN_START_NOTIFICATION (0x82) */
-static int iwl_rx_scan_start_notif(struct iwl_priv *priv,
-				    struct iwl_rx_cmd_buffer *rxb,
-				    struct iwl_device_cmd *cmd)
+static void iwl_rx_scan_start_notif(struct iwl_priv *priv,
+				    struct iwl_rx_cmd_buffer *rxb)
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	struct iwl_scanstart_notification *notif = (void *)pkt->data;
@@ -277,14 +274,11 @@ static int iwl_rx_scan_start_notif(struct iwl_priv *priv,
 		       le32_to_cpu(notif->tsf_high),
 		       le32_to_cpu(notif->tsf_low),
 		       notif->status, notif->beacon_timer);
-
-	return 0;
 }
 
 /* Service SCAN_RESULTS_NOTIFICATION (0x83) */
-static int iwl_rx_scan_results_notif(struct iwl_priv *priv,
-				      struct iwl_rx_cmd_buffer *rxb,
-				      struct iwl_device_cmd *cmd)
+static void iwl_rx_scan_results_notif(struct iwl_priv *priv,
+				      struct iwl_rx_cmd_buffer *rxb)
 {
 #ifdef CONFIG_IWLWIFI_DEBUG
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
@@ -303,13 +297,11 @@ static int iwl_rx_scan_results_notif(struct iwl_priv *priv,
 		       le32_to_cpu(notif->statistics[0]),
 		       le32_to_cpu(notif->tsf_low) - priv->scan_start_tsf);
 #endif
-	return 0;
 }
 
 /* Service SCAN_COMPLETE_NOTIFICATION (0x84) */
-static int iwl_rx_scan_complete_notif(struct iwl_priv *priv,
-				       struct iwl_rx_cmd_buffer *rxb,
-				       struct iwl_device_cmd *cmd)
+static void iwl_rx_scan_complete_notif(struct iwl_priv *priv,
+				       struct iwl_rx_cmd_buffer *rxb)
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	struct iwl_scancomplete_notification *scan_notif = (void *)pkt->data;
@@ -356,7 +348,6 @@ static int iwl_rx_scan_complete_notif(struct iwl_priv *priv,
 		queue_work(priv->workqueue,
 			   &priv->bt_traffic_change_work);
 	}
-	return 0;
 }
 
 void iwl_setup_rx_scan_handlers(struct iwl_priv *priv)
diff --git a/drivers/net/wireless/iwlwifi/dvm/sta.c b/drivers/net/wireless/iwlwifi/dvm/sta.c
index 6e1e23e..c18aa3e 100644
--- a/drivers/net/wireless/iwlwifi/dvm/sta.c
+++ b/drivers/net/wireless/iwlwifi/dvm/sta.c
@@ -60,15 +60,15 @@ static int iwl_sta_ucode_activate(struct iwl_priv *priv, u8 sta_id)
 	return 0;
 }
 
-static int iwl_process_add_sta_resp(struct iwl_priv *priv,
-				    struct iwl_rx_packet *pkt)
+static void iwl_process_add_sta_resp(struct iwl_priv *priv,
+				     struct iwl_rx_packet *pkt)
 {
 	struct iwl_add_sta_resp *add_sta_resp = (void *)pkt->data;
 
 	if (pkt->hdr.flags & IWL_CMD_FAILED_MSK) {
 		IWL_ERR(priv, "Bad return from REPLY_ADD_STA (0x%08X)\n",
 			pkt->hdr.flags);
-		return 0;
+		return;
 	}
 
 	IWL_DEBUG_INFO(priv, "Processing response for adding station\n");
@@ -96,19 +96,13 @@ static int iwl_process_add_sta_resp(struct iwl_priv *priv,
 	}
 
 	spin_unlock_bh(&priv->sta_lock);
-
-	return 0;
 }
 
-int iwl_add_sta_callback(struct iwl_priv *priv, struct iwl_rx_cmd_buffer *rxb,
-			       struct iwl_device_cmd *cmd)
+void iwl_add_sta_callback(struct iwl_priv *priv, struct iwl_rx_cmd_buffer *rxb)
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 
-	if (!cmd)
-		return 0;
-
-	return iwl_process_add_sta_resp(priv, pkt);
+	iwl_process_add_sta_resp(priv, pkt);
 }
 
 int iwl_send_add_sta(struct iwl_priv *priv,
diff --git a/drivers/net/wireless/iwlwifi/dvm/tx.c b/drivers/net/wireless/iwlwifi/dvm/tx.c
index 275df12..bddd197 100644
--- a/drivers/net/wireless/iwlwifi/dvm/tx.c
+++ b/drivers/net/wireless/iwlwifi/dvm/tx.c
@@ -1128,8 +1128,7 @@ static void iwl_check_abort_status(struct iwl_priv *priv,
 	}
 }
 
-int iwlagn_rx_reply_tx(struct iwl_priv *priv, struct iwl_rx_cmd_buffer *rxb,
-			       struct iwl_device_cmd *cmd)
+void iwlagn_rx_reply_tx(struct iwl_priv *priv, struct iwl_rx_cmd_buffer *rxb)
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	u16 sequence = le16_to_cpu(pkt->hdr.sequence);
@@ -1273,8 +1272,6 @@ int iwlagn_rx_reply_tx(struct iwl_priv *priv, struct iwl_rx_cmd_buffer *rxb,
 		skb = __skb_dequeue(&skbs);
 		ieee80211_tx_status(priv->hw, skb);
 	}
-
-	return 0;
 }
 
 /**
@@ -1283,9 +1280,8 @@ int iwlagn_rx_reply_tx(struct iwl_priv *priv, struct iwl_rx_cmd_buffer *rxb,
  * Handles block-acknowledge notification from device, which reports success
  * of frames sent via aggregation.
  */
-int iwlagn_rx_reply_compressed_ba(struct iwl_priv *priv,
-				   struct iwl_rx_cmd_buffer *rxb,
-				   struct iwl_device_cmd *cmd)
+void iwlagn_rx_reply_compressed_ba(struct iwl_priv *priv,
+				   struct iwl_rx_cmd_buffer *rxb)
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	struct iwl_compressed_ba_resp *ba_resp = (void *)pkt->data;
@@ -1306,7 +1302,7 @@ int iwlagn_rx_reply_compressed_ba(struct iwl_priv *priv,
 	if (scd_flow >= priv->cfg->base_params->num_of_queues) {
 		IWL_ERR(priv,
 			"BUG_ON scd_flow is bigger than number of queues\n");
-		return 0;
+		return;
 	}
 
 	sta_id = ba_resp->sta_id;
@@ -1319,7 +1315,7 @@ int iwlagn_rx_reply_compressed_ba(struct iwl_priv *priv,
 		if (unlikely(ba_resp->bitmap))
 			IWL_ERR(priv, "Received BA when not expected\n");
 		spin_unlock_bh(&priv->sta_lock);
-		return 0;
+		return;
 	}
 
 	if (unlikely(scd_flow != agg->txq_id)) {
@@ -1333,7 +1329,7 @@ int iwlagn_rx_reply_compressed_ba(struct iwl_priv *priv,
 				    "Bad queue mapping txq_id=%d, agg_txq[sta:%d,tid:%d]=%d\n",
 				    scd_flow, sta_id, tid, agg->txq_id);
 		spin_unlock_bh(&priv->sta_lock);
-		return 0;
+		return;
 	}
 
 	__skb_queue_head_init(&reclaimed_skbs);
@@ -1413,6 +1409,4 @@ int iwlagn_rx_reply_compressed_ba(struct iwl_priv *priv,
 		skb = __skb_dequeue(&reclaimed_skbs);
 		ieee80211_tx_status(priv->hw, skb);
 	}
-
-	return 0;
 }
-- 
2.1.4

