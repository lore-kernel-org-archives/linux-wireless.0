Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:12459 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751751Ab1HMSSu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Aug 2011 14:18:50 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 29/60] iwlagn: move reclaim related functions
Date: Sat, 13 Aug 2011 10:38:05 -0700
Message-Id: <1313257116-2697-30-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110813_201931_428771_3E19725A)
In-Reply-To: <1313257116-2697-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1313257116-2697-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Now that the reclaim flow has been moved to the transport layer, a lot of
functions can be made static or don't need to be exported outside the transport
layer.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c        |  193 --------------------
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c         |  197 ++++++++++++++++++++-
 drivers/net/wireless/iwlwifi/iwl-agn.h            |   19 --
 drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h |    6 +-
 drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c  |    9 +-
 drivers/net/wireless/iwlwifi/iwl-trans.h          |    7 -
 6 files changed, 200 insertions(+), 231 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 52ddb49..bca5f99 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -42,184 +42,6 @@
 #include "iwl-trans.h"
 #include "iwl-shared.h"
 
-static void iwlagn_count_tx_err_status(struct iwl_priv *priv, u16 status)
-{
-	status &= TX_STATUS_MSK;
-
-	switch (status) {
-	case TX_STATUS_POSTPONE_DELAY:
-		priv->reply_tx_stats.pp_delay++;
-		break;
-	case TX_STATUS_POSTPONE_FEW_BYTES:
-		priv->reply_tx_stats.pp_few_bytes++;
-		break;
-	case TX_STATUS_POSTPONE_BT_PRIO:
-		priv->reply_tx_stats.pp_bt_prio++;
-		break;
-	case TX_STATUS_POSTPONE_QUIET_PERIOD:
-		priv->reply_tx_stats.pp_quiet_period++;
-		break;
-	case TX_STATUS_POSTPONE_CALC_TTAK:
-		priv->reply_tx_stats.pp_calc_ttak++;
-		break;
-	case TX_STATUS_FAIL_INTERNAL_CROSSED_RETRY:
-		priv->reply_tx_stats.int_crossed_retry++;
-		break;
-	case TX_STATUS_FAIL_SHORT_LIMIT:
-		priv->reply_tx_stats.short_limit++;
-		break;
-	case TX_STATUS_FAIL_LONG_LIMIT:
-		priv->reply_tx_stats.long_limit++;
-		break;
-	case TX_STATUS_FAIL_FIFO_UNDERRUN:
-		priv->reply_tx_stats.fifo_underrun++;
-		break;
-	case TX_STATUS_FAIL_DRAIN_FLOW:
-		priv->reply_tx_stats.drain_flow++;
-		break;
-	case TX_STATUS_FAIL_RFKILL_FLUSH:
-		priv->reply_tx_stats.rfkill_flush++;
-		break;
-	case TX_STATUS_FAIL_LIFE_EXPIRE:
-		priv->reply_tx_stats.life_expire++;
-		break;
-	case TX_STATUS_FAIL_DEST_PS:
-		priv->reply_tx_stats.dest_ps++;
-		break;
-	case TX_STATUS_FAIL_HOST_ABORTED:
-		priv->reply_tx_stats.host_abort++;
-		break;
-	case TX_STATUS_FAIL_BT_RETRY:
-		priv->reply_tx_stats.bt_retry++;
-		break;
-	case TX_STATUS_FAIL_STA_INVALID:
-		priv->reply_tx_stats.sta_invalid++;
-		break;
-	case TX_STATUS_FAIL_FRAG_DROPPED:
-		priv->reply_tx_stats.frag_drop++;
-		break;
-	case TX_STATUS_FAIL_TID_DISABLE:
-		priv->reply_tx_stats.tid_disable++;
-		break;
-	case TX_STATUS_FAIL_FIFO_FLUSHED:
-		priv->reply_tx_stats.fifo_flush++;
-		break;
-	case TX_STATUS_FAIL_INSUFFICIENT_CF_POLL:
-		priv->reply_tx_stats.insuff_cf_poll++;
-		break;
-	case TX_STATUS_FAIL_PASSIVE_NO_RX:
-		priv->reply_tx_stats.fail_hw_drop++;
-		break;
-	case TX_STATUS_FAIL_NO_BEACON_ON_RADAR:
-		priv->reply_tx_stats.sta_color_mismatch++;
-		break;
-	default:
-		priv->reply_tx_stats.unknown++;
-		break;
-	}
-}
-
-void iwlagn_count_agg_tx_err_status(struct iwl_priv *priv, u16 status)
-{
-	status &= AGG_TX_STATUS_MSK;
-
-	switch (status) {
-	case AGG_TX_STATE_UNDERRUN_MSK:
-		priv->reply_agg_tx_stats.underrun++;
-		break;
-	case AGG_TX_STATE_BT_PRIO_MSK:
-		priv->reply_agg_tx_stats.bt_prio++;
-		break;
-	case AGG_TX_STATE_FEW_BYTES_MSK:
-		priv->reply_agg_tx_stats.few_bytes++;
-		break;
-	case AGG_TX_STATE_ABORT_MSK:
-		priv->reply_agg_tx_stats.abort++;
-		break;
-	case AGG_TX_STATE_LAST_SENT_TTL_MSK:
-		priv->reply_agg_tx_stats.last_sent_ttl++;
-		break;
-	case AGG_TX_STATE_LAST_SENT_TRY_CNT_MSK:
-		priv->reply_agg_tx_stats.last_sent_try++;
-		break;
-	case AGG_TX_STATE_LAST_SENT_BT_KILL_MSK:
-		priv->reply_agg_tx_stats.last_sent_bt_kill++;
-		break;
-	case AGG_TX_STATE_SCD_QUERY_MSK:
-		priv->reply_agg_tx_stats.scd_query++;
-		break;
-	case AGG_TX_STATE_TEST_BAD_CRC32_MSK:
-		priv->reply_agg_tx_stats.bad_crc32++;
-		break;
-	case AGG_TX_STATE_RESPONSE_MSK:
-		priv->reply_agg_tx_stats.response++;
-		break;
-	case AGG_TX_STATE_DUMP_TX_MSK:
-		priv->reply_agg_tx_stats.dump_tx++;
-		break;
-	case AGG_TX_STATE_DELAY_TX_MSK:
-		priv->reply_agg_tx_stats.delay_tx++;
-		break;
-	default:
-		priv->reply_agg_tx_stats.unknown++;
-		break;
-	}
-}
-
-void iwlagn_set_tx_status(struct iwl_priv *priv,
-				 struct ieee80211_tx_info *info,
-				 struct iwlagn_tx_resp *tx_resp,
-				 bool is_agg)
-{
-	u16  status = le16_to_cpu(tx_resp->status.status);
-
-	info->status.rates[0].count = tx_resp->failure_frame + 1;
-	if (is_agg)
-		info->flags &= ~IEEE80211_TX_CTL_AMPDU;
-	info->flags |= iwl_tx_status_to_mac80211(status);
-	iwlagn_hwrate_to_tx_control(priv, le32_to_cpu(tx_resp->rate_n_flags),
-				    info);
-	if (!iwl_is_tx_success(status))
-		iwlagn_count_tx_err_status(priv, status);
-}
-
-#ifdef CONFIG_IWLWIFI_DEBUG
-#define AGG_TX_STATE_FAIL(x) case AGG_TX_STATE_ ## x: return #x
-
-const char *iwl_get_agg_tx_fail_reason(u16 status)
-{
-	status &= AGG_TX_STATUS_MSK;
-	switch (status) {
-	case AGG_TX_STATE_TRANSMITTED:
-		return "SUCCESS";
-		AGG_TX_STATE_FAIL(UNDERRUN_MSK);
-		AGG_TX_STATE_FAIL(BT_PRIO_MSK);
-		AGG_TX_STATE_FAIL(FEW_BYTES_MSK);
-		AGG_TX_STATE_FAIL(ABORT_MSK);
-		AGG_TX_STATE_FAIL(LAST_SENT_TTL_MSK);
-		AGG_TX_STATE_FAIL(LAST_SENT_TRY_CNT_MSK);
-		AGG_TX_STATE_FAIL(LAST_SENT_BT_KILL_MSK);
-		AGG_TX_STATE_FAIL(SCD_QUERY_MSK);
-		AGG_TX_STATE_FAIL(TEST_BAD_CRC32_MSK);
-		AGG_TX_STATE_FAIL(RESPONSE_MSK);
-		AGG_TX_STATE_FAIL(DUMP_TX_MSK);
-		AGG_TX_STATE_FAIL(DELAY_TX_MSK);
-	}
-
-	return "UNKNOWN";
-}
-#endif /* CONFIG_IWLWIFI_DEBUG */
-
-void iwl_check_abort_status(struct iwl_priv *priv,
-			    u8 frame_count, u32 status)
-{
-	if (frame_count == 1 && status == TX_STATUS_FAIL_RFKILL_FLUSH) {
-		IWL_ERR(priv, "Tx flush command to flush out all frames\n");
-		if (!test_bit(STATUS_EXIT_PENDING, &priv->shrd->status))
-			queue_work(priv->shrd->workqueue, &priv->tx_flush);
-	}
-}
-
 int iwlagn_hw_valid_rtc_data_addr(u32 addr)
 {
 	return (addr >= IWLAGN_RTC_DATA_LOWER_BOUND) &&
@@ -812,21 +634,6 @@ int iwlagn_manage_ibss_station(struct iwl_priv *priv,
 				  vif->bss_conf.bssid);
 }
 
-void iwl_free_tfds_in_queue(struct iwl_priv *priv,
-			    int sta_id, int tid, int freed)
-{
-	lockdep_assert_held(&priv->shrd->sta_lock);
-
-	if (priv->stations[sta_id].tid[tid].tfds_in_queue >= freed)
-		priv->stations[sta_id].tid[tid].tfds_in_queue -= freed;
-	else {
-		IWL_DEBUG_TX(priv, "free more than tfds_in_queue (%u:%d)\n",
-			priv->stations[sta_id].tid[tid].tfds_in_queue,
-			freed);
-		priv->stations[sta_id].tid[tid].tfds_in_queue = 0;
-	}
-}
-
 #define IWL_FLUSH_WAIT_MS	2000
 
 int iwlagn_wait_tx_queue_empty(struct iwl_priv *priv)
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index f2c11c4..bef3448 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -638,7 +638,7 @@ int iwlagn_tx_agg_stop(struct iwl_priv *priv, struct ieee80211_vif *vif,
 	return 0;
 }
 
-int iwlagn_txq_check_empty(struct iwl_priv *priv,
+static int iwlagn_txq_check_empty(struct iwl_priv *priv,
 			   int sta_id, u8 tid, int txq_id)
 {
 	struct iwl_queue *q = &priv->txq[txq_id].q;
@@ -700,7 +700,7 @@ static void iwlagn_non_agg_tx_status(struct iwl_priv *priv,
 /**
  * translate ucode response to mac80211 tx status control values
  */
-void iwlagn_hwrate_to_tx_control(struct iwl_priv *priv, u32 rate_n_flags,
+static void iwlagn_hwrate_to_tx_control(struct iwl_priv *priv, u32 rate_n_flags,
 				  struct ieee80211_tx_info *info)
 {
 	struct ieee80211_tx_rate *r = &info->control.rates[0];
@@ -760,6 +760,53 @@ const char *iwl_get_tx_fail_reason(u32 status)
 }
 #endif /* CONFIG_IWLWIFI_DEBUG */
 
+static void iwlagn_count_agg_tx_err_status(struct iwl_priv *priv, u16 status)
+{
+	status &= AGG_TX_STATUS_MSK;
+
+	switch (status) {
+	case AGG_TX_STATE_UNDERRUN_MSK:
+		priv->reply_agg_tx_stats.underrun++;
+		break;
+	case AGG_TX_STATE_BT_PRIO_MSK:
+		priv->reply_agg_tx_stats.bt_prio++;
+		break;
+	case AGG_TX_STATE_FEW_BYTES_MSK:
+		priv->reply_agg_tx_stats.few_bytes++;
+		break;
+	case AGG_TX_STATE_ABORT_MSK:
+		priv->reply_agg_tx_stats.abort++;
+		break;
+	case AGG_TX_STATE_LAST_SENT_TTL_MSK:
+		priv->reply_agg_tx_stats.last_sent_ttl++;
+		break;
+	case AGG_TX_STATE_LAST_SENT_TRY_CNT_MSK:
+		priv->reply_agg_tx_stats.last_sent_try++;
+		break;
+	case AGG_TX_STATE_LAST_SENT_BT_KILL_MSK:
+		priv->reply_agg_tx_stats.last_sent_bt_kill++;
+		break;
+	case AGG_TX_STATE_SCD_QUERY_MSK:
+		priv->reply_agg_tx_stats.scd_query++;
+		break;
+	case AGG_TX_STATE_TEST_BAD_CRC32_MSK:
+		priv->reply_agg_tx_stats.bad_crc32++;
+		break;
+	case AGG_TX_STATE_RESPONSE_MSK:
+		priv->reply_agg_tx_stats.response++;
+		break;
+	case AGG_TX_STATE_DUMP_TX_MSK:
+		priv->reply_agg_tx_stats.dump_tx++;
+		break;
+	case AGG_TX_STATE_DELAY_TX_MSK:
+		priv->reply_agg_tx_stats.delay_tx++;
+		break;
+	default:
+		priv->reply_agg_tx_stats.unknown++;
+		break;
+	}
+}
+
 static void iwl_rx_reply_tx_agg(struct iwl_priv *priv,
 				struct iwlagn_tx_resp *tx_resp)
 {
@@ -808,12 +855,158 @@ static void iwl_rx_reply_tx_agg(struct iwl_priv *priv,
 	}
 }
 
+#ifdef CONFIG_IWLWIFI_DEBUG
+#define AGG_TX_STATE_FAIL(x) case AGG_TX_STATE_ ## x: return #x
+
+const char *iwl_get_agg_tx_fail_reason(u16 status)
+{
+	status &= AGG_TX_STATUS_MSK;
+	switch (status) {
+	case AGG_TX_STATE_TRANSMITTED:
+		return "SUCCESS";
+		AGG_TX_STATE_FAIL(UNDERRUN_MSK);
+		AGG_TX_STATE_FAIL(BT_PRIO_MSK);
+		AGG_TX_STATE_FAIL(FEW_BYTES_MSK);
+		AGG_TX_STATE_FAIL(ABORT_MSK);
+		AGG_TX_STATE_FAIL(LAST_SENT_TTL_MSK);
+		AGG_TX_STATE_FAIL(LAST_SENT_TRY_CNT_MSK);
+		AGG_TX_STATE_FAIL(LAST_SENT_BT_KILL_MSK);
+		AGG_TX_STATE_FAIL(SCD_QUERY_MSK);
+		AGG_TX_STATE_FAIL(TEST_BAD_CRC32_MSK);
+		AGG_TX_STATE_FAIL(RESPONSE_MSK);
+		AGG_TX_STATE_FAIL(DUMP_TX_MSK);
+		AGG_TX_STATE_FAIL(DELAY_TX_MSK);
+	}
+
+	return "UNKNOWN";
+}
+#endif /* CONFIG_IWLWIFI_DEBUG */
+
 static inline u32 iwlagn_get_scd_ssn(struct iwlagn_tx_resp *tx_resp)
 {
 	return le32_to_cpup((__le32 *)&tx_resp->status +
 			    tx_resp->frame_count) & MAX_SN;
 }
 
+static void iwl_free_tfds_in_queue(struct iwl_priv *priv,
+			    int sta_id, int tid, int freed)
+{
+	lockdep_assert_held(&priv->shrd->sta_lock);
+
+	if (priv->stations[sta_id].tid[tid].tfds_in_queue >= freed)
+		priv->stations[sta_id].tid[tid].tfds_in_queue -= freed;
+	else {
+		IWL_DEBUG_TX(priv, "free more than tfds_in_queue (%u:%d)\n",
+			priv->stations[sta_id].tid[tid].tfds_in_queue,
+			freed);
+		priv->stations[sta_id].tid[tid].tfds_in_queue = 0;
+	}
+}
+
+static void iwlagn_count_tx_err_status(struct iwl_priv *priv, u16 status)
+{
+	status &= TX_STATUS_MSK;
+
+	switch (status) {
+	case TX_STATUS_POSTPONE_DELAY:
+		priv->reply_tx_stats.pp_delay++;
+		break;
+	case TX_STATUS_POSTPONE_FEW_BYTES:
+		priv->reply_tx_stats.pp_few_bytes++;
+		break;
+	case TX_STATUS_POSTPONE_BT_PRIO:
+		priv->reply_tx_stats.pp_bt_prio++;
+		break;
+	case TX_STATUS_POSTPONE_QUIET_PERIOD:
+		priv->reply_tx_stats.pp_quiet_period++;
+		break;
+	case TX_STATUS_POSTPONE_CALC_TTAK:
+		priv->reply_tx_stats.pp_calc_ttak++;
+		break;
+	case TX_STATUS_FAIL_INTERNAL_CROSSED_RETRY:
+		priv->reply_tx_stats.int_crossed_retry++;
+		break;
+	case TX_STATUS_FAIL_SHORT_LIMIT:
+		priv->reply_tx_stats.short_limit++;
+		break;
+	case TX_STATUS_FAIL_LONG_LIMIT:
+		priv->reply_tx_stats.long_limit++;
+		break;
+	case TX_STATUS_FAIL_FIFO_UNDERRUN:
+		priv->reply_tx_stats.fifo_underrun++;
+		break;
+	case TX_STATUS_FAIL_DRAIN_FLOW:
+		priv->reply_tx_stats.drain_flow++;
+		break;
+	case TX_STATUS_FAIL_RFKILL_FLUSH:
+		priv->reply_tx_stats.rfkill_flush++;
+		break;
+	case TX_STATUS_FAIL_LIFE_EXPIRE:
+		priv->reply_tx_stats.life_expire++;
+		break;
+	case TX_STATUS_FAIL_DEST_PS:
+		priv->reply_tx_stats.dest_ps++;
+		break;
+	case TX_STATUS_FAIL_HOST_ABORTED:
+		priv->reply_tx_stats.host_abort++;
+		break;
+	case TX_STATUS_FAIL_BT_RETRY:
+		priv->reply_tx_stats.bt_retry++;
+		break;
+	case TX_STATUS_FAIL_STA_INVALID:
+		priv->reply_tx_stats.sta_invalid++;
+		break;
+	case TX_STATUS_FAIL_FRAG_DROPPED:
+		priv->reply_tx_stats.frag_drop++;
+		break;
+	case TX_STATUS_FAIL_TID_DISABLE:
+		priv->reply_tx_stats.tid_disable++;
+		break;
+	case TX_STATUS_FAIL_FIFO_FLUSHED:
+		priv->reply_tx_stats.fifo_flush++;
+		break;
+	case TX_STATUS_FAIL_INSUFFICIENT_CF_POLL:
+		priv->reply_tx_stats.insuff_cf_poll++;
+		break;
+	case TX_STATUS_FAIL_PASSIVE_NO_RX:
+		priv->reply_tx_stats.fail_hw_drop++;
+		break;
+	case TX_STATUS_FAIL_NO_BEACON_ON_RADAR:
+		priv->reply_tx_stats.sta_color_mismatch++;
+		break;
+	default:
+		priv->reply_tx_stats.unknown++;
+		break;
+	}
+}
+
+static void iwlagn_set_tx_status(struct iwl_priv *priv,
+				 struct ieee80211_tx_info *info,
+				 struct iwlagn_tx_resp *tx_resp,
+				 bool is_agg)
+{
+	u16  status = le16_to_cpu(tx_resp->status.status);
+
+	info->status.rates[0].count = tx_resp->failure_frame + 1;
+	if (is_agg)
+		info->flags &= ~IEEE80211_TX_CTL_AMPDU;
+	info->flags |= iwl_tx_status_to_mac80211(status);
+	iwlagn_hwrate_to_tx_control(priv, le32_to_cpu(tx_resp->rate_n_flags),
+				    info);
+	if (!iwl_is_tx_success(status))
+		iwlagn_count_tx_err_status(priv, status);
+}
+
+static void iwl_check_abort_status(struct iwl_priv *priv,
+			    u8 frame_count, u32 status)
+{
+	if (frame_count == 1 && status == TX_STATUS_FAIL_RFKILL_FLUSH) {
+		IWL_ERR(priv, "Tx flush command to flush out all frames\n");
+		if (!test_bit(STATUS_EXIT_PENDING, &priv->shrd->status))
+			queue_work(priv->shrd->workqueue, &priv->tx_flush);
+	}
+}
+
 void iwlagn_rx_reply_tx(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index f345907..c30299d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -121,10 +121,6 @@ static inline void iwl_set_calib_hdr(struct iwl_calib_hdr *hdr, u8 cmd)
 	hdr->data_valid = 1;
 }
 
-/* tx queue */
-void iwl_free_tfds_in_queue(struct iwl_priv *priv,
-			    int sta_id, int tid, int freed);
-
 /* RXON */
 int iwlagn_set_pan_params(struct iwl_priv *priv);
 int iwlagn_commit_rxon(struct iwl_priv *priv, struct iwl_rxon_context *ctx);
@@ -146,13 +142,6 @@ int iwlagn_load_ucode_wait_alive(struct iwl_priv *priv,
 				 enum iwlagn_ucode_type ucode_type);
 
 /* lib */
-void iwlagn_set_tx_status(struct iwl_priv *priv,
-				 struct ieee80211_tx_info *info,
-				 struct iwlagn_tx_resp *tx_resp,
-				 bool is_agg);
-void iwlagn_count_agg_tx_err_status(struct iwl_priv *priv, u16 status);
-void iwl_check_abort_status(struct iwl_priv *priv,
-			    u8 frame_count, u32 status);
 int iwlagn_hw_valid_rtc_data_addr(u32 addr);
 int iwlagn_send_tx_power(struct iwl_priv *priv);
 void iwlagn_temperature(struct iwl_priv *priv);
@@ -169,22 +158,14 @@ void iwl_rx_dispatch(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb);
 
 
 /* tx */
-void iwlagn_txq_free_tfd(struct iwl_priv *priv, struct iwl_tx_queue *txq,
-				int index);
-void iwlagn_hwrate_to_tx_control(struct iwl_priv *priv, u32 rate_n_flags,
-			      struct ieee80211_tx_info *info);
 int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb);
 int iwlagn_tx_agg_start(struct iwl_priv *priv, struct ieee80211_vif *vif,
 			struct ieee80211_sta *sta, u16 tid, u16 *ssn);
 int iwlagn_tx_agg_stop(struct iwl_priv *priv, struct ieee80211_vif *vif,
 		       struct ieee80211_sta *sta, u16 tid);
-int iwlagn_txq_check_empty(struct iwl_priv *priv,
-			   int sta_id, u8 tid, int txq_id);
 void iwlagn_rx_reply_compressed_ba(struct iwl_priv *priv,
 				struct iwl_rx_mem_buffer *rxb);
 void iwlagn_rx_reply_tx(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb);
-void iwl_tx_queue_reclaim(struct iwl_trans *trans, int txq_id, int index,
-	struct sk_buff_head *skbs);
 
 static inline u32 iwl_tx_status_to_mac80211(u32 status)
 {
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h b/drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h
index f60b26f..717b6dc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h
@@ -136,8 +136,6 @@ irqreturn_t iwl_isr_ict(int irq, void *data);
 * TX / HCMD
 ******************************************************/
 void iwl_txq_update_write_ptr(struct iwl_priv *priv, struct iwl_tx_queue *txq);
-void iwlagn_txq_free_tfd(struct iwl_priv *priv, struct iwl_tx_queue *txq,
-				int index);
 int iwlagn_txq_attach_buf_to_tfd(struct iwl_priv *priv,
 				 struct iwl_tx_queue *txq,
 				 dma_addr_t addr, u16 len, u8 reset);
@@ -159,6 +157,10 @@ void iwl_trans_tx_queue_set_status(struct iwl_priv *priv,
 			     int tx_fifo_id, int scd_retry);
 void iwl_trans_pcie_txq_agg_setup(struct iwl_priv *priv, int sta_id, int tid,
 						int frame_limit);
+void iwlagn_txq_free_tfd(struct iwl_priv *priv, struct iwl_tx_queue *txq,
+	int index);
+void iwl_tx_queue_reclaim(struct iwl_trans *trans, int txq_id, int index,
+			  struct sk_buff_head *skbs);
 
 /*****************************************************
 * Error handling
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c
index 3247df4..2e54f15 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c
@@ -332,13 +332,7 @@ int iwl_queue_init(struct iwl_priv *priv, struct iwl_queue *q,
 	return 0;
 }
 
-/*TODO: this functions should NOT be exported from trans module - export it
- * until the reclaim flow will be brought to the transport module too.
- * Add a declaration to make sparse happy */
-void iwlagn_txq_inval_byte_cnt_tbl(struct iwl_priv *priv,
-					  struct iwl_tx_queue *txq);
-
-void iwlagn_txq_inval_byte_cnt_tbl(struct iwl_priv *priv,
+static void iwlagn_txq_inval_byte_cnt_tbl(struct iwl_priv *priv,
 					  struct iwl_tx_queue *txq)
 {
 	struct iwlagn_scd_bc_tbl *scd_bc_tbl = priv->scd_bc_tbls.addr;
@@ -1042,7 +1036,6 @@ int iwl_trans_pcie_send_cmd_pdu(struct iwl_priv *priv, u8 id, u32 flags,
 /* Frees buffers until index _not_ inclusive */
 void iwl_tx_queue_reclaim(struct iwl_trans *trans, int txq_id, int index,
 			    struct sk_buff_head *skbs)
-
 {
 	struct iwl_tx_queue *txq = &priv(trans)->txq[txq_id];
 	struct iwl_queue *q = &txq->q;
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 519ad91..7fd0296 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -272,11 +272,4 @@ static inline int iwl_trans_resume(struct iwl_trans *trans)
 ******************************************************/
 extern const struct iwl_trans_ops trans_ops_pcie;
 
-/*TODO: this functions should NOT be exported from trans module - export it
- * until the reclaim flow will be brought to the transport module too */
-
-struct iwl_tx_queue;
-void iwlagn_txq_inval_byte_cnt_tbl(struct iwl_priv *priv,
-					  struct iwl_tx_queue *txq);
-
 #endif /* __iwl_trans_h__ */
-- 
1.7.0.4

