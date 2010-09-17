Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:42101 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752804Ab0IQVX3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Sep 2010 17:23:29 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 05/10] iwlagn: keep track of aggregated tx frames failure counter
Date: Fri, 17 Sep 2010 14:24:29 -0700
Message-Id: <1284758674-25297-6-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1284758674-25297-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1284758674-25297-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

When uCode completed the aggregated frames transmission attempt,
it will send tx command response with aggregated frame status.

Keep track of the failure counter which help indicate any transmission
error condition.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c |   50 ++++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-dev.h     |   18 ++++++++++
 2 files changed, 68 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index a8494d0..c42cb18 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -123,6 +123,53 @@ static void iwlagn_count_tx_err_status(struct iwl_priv *priv, u16 status)
 	}
 }
 
+static void iwlagn_count_agg_tx_err_status(struct iwl_priv *priv, u16 status)
+{
+	status &= AGG_TX_STATUS_MSK;
+
+	switch (status) {
+	case AGG_TX_STATE_UNDERRUN_MSK:
+		priv->_agn.reply_agg_tx_stats.underrun++;
+		break;
+	case AGG_TX_STATE_BT_PRIO_MSK:
+		priv->_agn.reply_agg_tx_stats.bt_prio++;
+		break;
+	case AGG_TX_STATE_FEW_BYTES_MSK:
+		priv->_agn.reply_agg_tx_stats.few_bytes++;
+		break;
+	case AGG_TX_STATE_ABORT_MSK:
+		priv->_agn.reply_agg_tx_stats.abort++;
+		break;
+	case AGG_TX_STATE_LAST_SENT_TTL_MSK:
+		priv->_agn.reply_agg_tx_stats.last_sent_ttl++;
+		break;
+	case AGG_TX_STATE_LAST_SENT_TRY_CNT_MSK:
+		priv->_agn.reply_agg_tx_stats.last_sent_try++;
+		break;
+	case AGG_TX_STATE_LAST_SENT_BT_KILL_MSK:
+		priv->_agn.reply_agg_tx_stats.last_sent_bt_kill++;
+		break;
+	case AGG_TX_STATE_SCD_QUERY_MSK:
+		priv->_agn.reply_agg_tx_stats.scd_query++;
+		break;
+	case AGG_TX_STATE_TEST_BAD_CRC32_MSK:
+		priv->_agn.reply_agg_tx_stats.bad_crc32++;
+		break;
+	case AGG_TX_STATE_RESPONSE_MSK:
+		priv->_agn.reply_agg_tx_stats.response++;
+		break;
+	case AGG_TX_STATE_DUMP_TX_MSK:
+		priv->_agn.reply_agg_tx_stats.dump_tx++;
+		break;
+	case AGG_TX_STATE_DELAY_TX_MSK:
+		priv->_agn.reply_agg_tx_stats.delay_tx++;
+		break;
+	default:
+		priv->_agn.reply_agg_tx_stats.unknown++;
+		break;
+	}
+}
+
 static void iwlagn_set_tx_status(struct iwl_priv *priv,
 				 struct ieee80211_tx_info *info,
 				 struct iwl5000_tx_resp *tx_resp,
@@ -224,6 +271,9 @@ static int iwlagn_tx_status_reply_tx(struct iwl_priv *priv,
 			idx = SEQ_TO_INDEX(seq);
 			txq_id = SEQ_TO_QUEUE(seq);
 
+			if (status & AGG_TX_STATUS_MSK)
+				iwlagn_count_agg_tx_err_status(priv, status);
+
 			if (status & (AGG_TX_STATE_FEW_BYTES_MSK |
 				      AGG_TX_STATE_ABORT_MSK))
 				continue;
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index bfa4864..74d25bc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -984,6 +984,23 @@ struct reply_tx_error_statistics {
 	u32 unknown;
 };
 
+/* reply_agg_tx_statistics (for _agn devices) */
+struct reply_agg_tx_error_statistics {
+	u32 underrun;
+	u32 bt_prio;
+	u32 few_bytes;
+	u32 abort;
+	u32 last_sent_ttl;
+	u32 last_sent_try;
+	u32 last_sent_bt_kill;
+	u32 scd_query;
+	u32 bad_crc32;
+	u32 response;
+	u32 dump_tx;
+	u32 delay_tx;
+	u32 unknown;
+};
+
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 /* management statistics */
 enum iwl_mgmt_stats {
@@ -1444,6 +1461,7 @@ struct iwl_priv {
 			struct iwl_bt_notif_statistics statistics_bt;
 			/* counts reply_tx error */
 			struct reply_tx_error_statistics reply_tx_stats;
+			struct reply_agg_tx_error_statistics reply_agg_tx_stats;
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 			struct iwl_notif_statistics accum_statistics;
 			struct iwl_notif_statistics delta_statistics;
-- 
1.7.0.4

