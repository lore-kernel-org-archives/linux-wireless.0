Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:20549 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752091AbYFLBte (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2008 21:49:34 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Ron Rindjunsky <ron.rindjunsky@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 05/29] iwlwifi: map sw and hw ampdu queues
Date: Thu, 12 Jun 2008 09:46:55 +0800
Message-Id: <1213235239-2954-6-git-send-email-yi.zhu@intel.com> (sfid-20080612_034941_411800_FAD9C413)
In-Reply-To: <1213235239-2954-5-git-send-email-yi.zhu@intel.com>
References: <1213235239-2954-1-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-2-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-3-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-4-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-5-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ron Rindjunsky <ron.rindjunsky@intel.com>

This patch maps sw and hw queues (for aggregations), so the right
mac80211 queue will be waken when ieee80211_wake_queue is invoked.

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965-hw.h |    2 +-
 drivers/net/wireless/iwlwifi/iwl-4965.c    |   17 +++++++++--------
 drivers/net/wireless/iwlwifi/iwl-5000-hw.h |    2 +-
 drivers/net/wireless/iwlwifi/iwl-5000.c    |    3 ++-
 drivers/net/wireless/iwlwifi/iwl-dev.h     |    2 ++
 5 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-hw.h b/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
index fc11833..721f505 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
@@ -82,7 +82,7 @@
  */
 #define IWL_CMD_QUEUE_NUM       4
 #define IWL_CMD_FIFO_NUM        4
-#define IWL_BACK_QUEUE_FIRST_ID 7
+#define IWL49_FIRST_AMPDU_QUEUE	7
 
 /* Tx rates */
 #define IWL_CCK_RATES 4
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 6d249bb..4d47dd7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -913,6 +913,7 @@ int iwl4965_hw_set_hw_params(struct iwl_priv *priv)
 	}
 
 	priv->hw_params.max_txq_num = priv->cfg->mod_params->num_of_queues;
+	priv->hw_params.first_ampdu_q = IWL49_FIRST_AMPDU_QUEUE;
 	priv->hw_params.sw_crypto = priv->cfg->mod_params->sw_crypto;
 	priv->hw_params.max_rxq_size = RX_QUEUE_SIZE;
 	priv->hw_params.max_rxq_log = RX_QUEUE_SIZE_LOG;
@@ -2893,7 +2894,7 @@ static void iwl4965_tx_queue_stop_scheduler(struct iwl_priv *priv,
 }
 
 /**
- * txq_id must be greater than IWL_BACK_QUEUE_FIRST_ID
+ * txq_id must be greater than IWL49_FIRST_AMPDU_QUEUE
  * priv->lock must be held by the caller
  */
 static int iwl4965_txq_agg_disable(struct iwl_priv *priv, u16 txq_id,
@@ -2901,9 +2902,9 @@ static int iwl4965_txq_agg_disable(struct iwl_priv *priv, u16 txq_id,
 {
 	int ret = 0;
 
-	if (IWL_BACK_QUEUE_FIRST_ID > txq_id) {
+	if (IWL49_FIRST_AMPDU_QUEUE > txq_id) {
 		IWL_WARNING("queue number too small: %d, must be > %d\n",
-				txq_id, IWL_BACK_QUEUE_FIRST_ID);
+				txq_id, IWL49_FIRST_AMPDU_QUEUE);
 		return -EINVAL;
 	}
 
@@ -2991,7 +2992,7 @@ static void iwl4965_rx_reply_compressed_ba(struct iwl_priv *priv,
 	if (txq->q.read_ptr != (ba_resp_scd_ssn & 0xff)) {
 		/* calculate mac80211 ampdu sw queue to wake */
 		int ampdu_q =
-		   scd_flow - IWL_BACK_QUEUE_FIRST_ID + priv->hw->queues;
+		   scd_flow - priv->hw_params.first_ampdu_q + priv->hw->queues;
 		int freed = iwl_tx_queue_reclaim(priv, scd_flow, index);
 		priv->stations[ba_resp->sta_id].
 			tid[ba_resp->tid].tfds_in_queue -= freed;
@@ -3036,7 +3037,7 @@ static int iwl4965_tx_queue_set_q2ratid(struct iwl_priv *priv, u16 ra_tid,
 /**
  * iwl4965_tx_queue_agg_enable - Set up & enable aggregation for selected queue
  *
- * NOTE:  txq_id must be greater than IWL_BACK_QUEUE_FIRST_ID,
+ * NOTE:  txq_id must be greater than IWL49_FIRST_AMPDU_QUEUE,
  *        i.e. it must be one of the higher queues used for aggregation
  */
 static int iwl4965_txq_agg_enable(struct iwl_priv *priv, int txq_id,
@@ -3046,9 +3047,9 @@ static int iwl4965_txq_agg_enable(struct iwl_priv *priv, int txq_id,
 	int ret;
 	u16 ra_tid;
 
-	if (IWL_BACK_QUEUE_FIRST_ID > txq_id)
+	if (IWL49_FIRST_AMPDU_QUEUE > txq_id)
 		IWL_WARNING("queue number too small: %d, must be > %d\n",
-			txq_id, IWL_BACK_QUEUE_FIRST_ID);
+			txq_id, IWL49_FIRST_AMPDU_QUEUE);
 
 	ra_tid = BUILD_RAxTID(sta_id, tid);
 
@@ -3398,7 +3399,7 @@ static void iwl4965_rx_reply_tx(struct iwl_priv *priv,
 			    txq_id >= 0 && priv->mac80211_registered &&
 			    agg->state != IWL_EMPTYING_HW_QUEUE_DELBA) {
 				/* calculate mac80211 ampdu sw queue to wake */
-				ampdu_q = txq_id - IWL_BACK_QUEUE_FIRST_ID +
+				ampdu_q = txq_id - IWL49_FIRST_AMPDU_QUEUE +
 					  priv->hw->queues;
 				if (agg->state == IWL_AGG_OFF)
 					ieee80211_wake_queue(priv->hw, txq_id);
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000-hw.h b/drivers/net/wireless/iwlwifi/iwl-5000-hw.h
index 9e557ce..4efe0c0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-5000-hw.h
@@ -81,7 +81,7 @@
 #define IWL50_QUEUE_SIZE                 256
 #define IWL50_CMD_FIFO_NUM                 7
 #define IWL50_NUM_QUEUES                  20
-#define IWL50_BACK_QUEUE_FIRST_ID         10
+#define IWL50_FIRST_AMPDU_QUEUE		  10
 
 #define IWL_sta_id_POS 12
 #define IWL_sta_id_LEN 4
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 31ea363..0ae5421 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -825,6 +825,7 @@ static int iwl5000_hw_set_hw_params(struct iwl_priv *priv)
 	}
 
 	priv->hw_params.max_txq_num = priv->cfg->mod_params->num_of_queues;
+	priv->hw_params.first_ampdu_q = IWL50_FIRST_AMPDU_QUEUE;
 	priv->hw_params.sw_crypto = priv->cfg->mod_params->sw_crypto;
 	priv->hw_params.max_rxq_size = RX_QUEUE_SIZE;
 	priv->hw_params.max_rxq_log = RX_QUEUE_SIZE_LOG;
@@ -1183,7 +1184,7 @@ static void iwl5000_rx_reply_tx(struct iwl_priv *priv,
 			    txq_id >= 0 && priv->mac80211_registered &&
 			    agg->state != IWL_EMPTYING_HW_QUEUE_DELBA) {
 				/* calculate mac80211 ampdu sw queue to wake */
-				ampdu_q = txq_id - IWL_BACK_QUEUE_FIRST_ID +
+				ampdu_q = txq_id - IWL50_FIRST_AMPDU_QUEUE +
 					  priv->hw->queues;
 				if (agg->state == IWL_AGG_OFF)
 					ieee80211_wake_queue(priv->hw, txq_id);
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index bf4b883..fa35193 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -583,6 +583,7 @@ struct iwl_sensitivity_ranges {
  * @max_xxx_size: for ucode uses
  * @ct_kill_threshold: temperature threshold
  * @struct iwl_sensitivity_ranges: range of sensitivity values
+ * @first_ampdu_q: first HW queue available for ampdu
  */
 struct iwl_hw_params {
 	u16 max_txq_num;
@@ -603,6 +604,7 @@ struct iwl_hw_params {
 	u32 max_bsm_size;
 	u32 ct_kill_threshold; /* value in hw-dependent units */
 	const struct iwl_sensitivity_ranges *sens;
+	u8 first_ampdu_q;
 };
 
 #define HT_SHORT_GI_20MHZ	(1 << 0)
-- 
1.5.3.6

