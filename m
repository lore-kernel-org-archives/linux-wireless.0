Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:19649 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753859Ab0IQVX3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Sep 2010 17:23:29 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 02/10] iwlagn: keep track fail tx reason counter
Date: Fri, 17 Sep 2010 14:24:26 -0700
Message-Id: <1284758674-25297-3-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1284758674-25297-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1284758674-25297-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

If uCode fail to transmit frame, it will send reply tx back
to driver with failure status; keep the counters of each failure
cases for debugging.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c |   79 ++++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-dev.h     |   29 ++++++++++
 2 files changed, 108 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 12170cf..68a2ab3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -46,6 +46,83 @@ static inline u32 iwlagn_get_scd_ssn(struct iwl5000_tx_resp *tx_resp)
 			    tx_resp->frame_count) & MAX_SN;
 }
 
+static void iwlagn_count_tx_err_status(struct iwl_priv *priv, u16 status)
+{
+	status &= TX_STATUS_MSK;
+
+	switch (status) {
+	case TX_STATUS_POSTPONE_DELAY:
+		priv->_agn.reply_tx_stats.pp_delay++;
+		break;
+	case TX_STATUS_POSTPONE_FEW_BYTES:
+		priv->_agn.reply_tx_stats.pp_few_bytes++;
+		break;
+	case TX_STATUS_POSTPONE_BT_PRIO:
+		priv->_agn.reply_tx_stats.pp_bt_prio++;
+		break;
+	case TX_STATUS_POSTPONE_QUIET_PERIOD:
+		priv->_agn.reply_tx_stats.pp_quiet_period++;
+		break;
+	case TX_STATUS_POSTPONE_CALC_TTAK:
+		priv->_agn.reply_tx_stats.pp_calc_ttak++;
+		break;
+	case TX_STATUS_FAIL_INTERNAL_CROSSED_RETRY:
+		priv->_agn.reply_tx_stats.int_crossed_retry++;
+		break;
+	case TX_STATUS_FAIL_SHORT_LIMIT:
+		priv->_agn.reply_tx_stats.short_limit++;
+		break;
+	case TX_STATUS_FAIL_LONG_LIMIT:
+		priv->_agn.reply_tx_stats.long_limit++;
+		break;
+	case TX_STATUS_FAIL_FIFO_UNDERRUN:
+		priv->_agn.reply_tx_stats.fifo_underrun++;
+		break;
+	case TX_STATUS_FAIL_DRAIN_FLOW:
+		priv->_agn.reply_tx_stats.drain_flow++;
+		break;
+	case TX_STATUS_FAIL_RFKILL_FLUSH:
+		priv->_agn.reply_tx_stats.rfkill_flush++;
+		break;
+	case TX_STATUS_FAIL_LIFE_EXPIRE:
+		priv->_agn.reply_tx_stats.life_expire++;
+		break;
+	case TX_STATUS_FAIL_DEST_PS:
+		priv->_agn.reply_tx_stats.dest_ps++;
+		break;
+	case TX_STATUS_FAIL_HOST_ABORTED:
+		priv->_agn.reply_tx_stats.host_abort++;
+		break;
+	case TX_STATUS_FAIL_BT_RETRY:
+		priv->_agn.reply_tx_stats.bt_retry++;
+		break;
+	case TX_STATUS_FAIL_STA_INVALID:
+		priv->_agn.reply_tx_stats.sta_invalid++;
+		break;
+	case TX_STATUS_FAIL_FRAG_DROPPED:
+		priv->_agn.reply_tx_stats.frag_drop++;
+		break;
+	case TX_STATUS_FAIL_TID_DISABLE:
+		priv->_agn.reply_tx_stats.tid_disable++;
+		break;
+	case TX_STATUS_FAIL_FIFO_FLUSHED:
+		priv->_agn.reply_tx_stats.fifo_flush++;
+		break;
+	case TX_STATUS_FAIL_INSUFFICIENT_CF_POLL:
+		priv->_agn.reply_tx_stats.insuff_cf_poll++;
+		break;
+	case TX_STATUS_FAIL_FW_DROP:
+		priv->_agn.reply_tx_stats.fail_hw_drop++;
+		break;
+	case TX_STATUS_FAIL_STA_COLOR_MISMATCH_DROP:
+		priv->_agn.reply_tx_stats.sta_color_mismatch++;
+		break;
+	default:
+		priv->_agn.reply_tx_stats.unknown++;
+		break;
+	}
+}
+
 static void iwlagn_set_tx_status(struct iwl_priv *priv,
 				 struct ieee80211_tx_info *info,
 				 struct iwl5000_tx_resp *tx_resp,
@@ -59,6 +136,8 @@ static void iwlagn_set_tx_status(struct iwl_priv *priv,
 	info->flags |= iwl_tx_status_to_mac80211(status);
 	iwlagn_hwrate_to_tx_control(priv, le32_to_cpu(tx_resp->rate_n_flags),
 				    info);
+	if (!iwl_is_tx_success(status))
+		iwlagn_count_tx_err_status(priv, status);
 
 	IWL_DEBUG_TX_REPLY(priv, "TXQ %d status %s (0x%08x) rate_n_flags "
 			   "0x%x retries %d\n",
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 4e3a692..bfa4864 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -957,6 +957,33 @@ struct isr_statistics {
 	u32 unhandled;
 };
 
+/* reply_tx_statistics (for _agn devices) */
+struct reply_tx_error_statistics {
+	u32 pp_delay;
+	u32 pp_few_bytes;
+	u32 pp_bt_prio;
+	u32 pp_quiet_period;
+	u32 pp_calc_ttak;
+	u32 int_crossed_retry;
+	u32 short_limit;
+	u32 long_limit;
+	u32 fifo_underrun;
+	u32 drain_flow;
+	u32 rfkill_flush;
+	u32 life_expire;
+	u32 dest_ps;
+	u32 host_abort;
+	u32 bt_retry;
+	u32 sta_invalid;
+	u32 frag_drop;
+	u32 tid_disable;
+	u32 fifo_flush;
+	u32 insuff_cf_poll;
+	u32 fail_hw_drop;
+	u32 sta_color_mismatch;
+	u32 unknown;
+};
+
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 /* management statistics */
 enum iwl_mgmt_stats {
@@ -1415,6 +1442,8 @@ struct iwl_priv {
 
 			struct iwl_notif_statistics statistics;
 			struct iwl_bt_notif_statistics statistics_bt;
+			/* counts reply_tx error */
+			struct reply_tx_error_statistics reply_tx_stats;
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 			struct iwl_notif_statistics accum_statistics;
 			struct iwl_notif_statistics delta_statistics;
-- 
1.7.0.4

