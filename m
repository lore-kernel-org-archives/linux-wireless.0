Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:58303 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755474Ab1KRBA3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Nov 2011 20:00:29 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 2/5] iwlwifi: improve the prints in the reclaim path
Date: Thu, 17 Nov 2011 16:05:10 -0800
Message-Id: <1321574713-12076-3-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111118_020039_386810_A9D81B1F)
In-Reply-To: <1321574713-12076-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1321574713-12076-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Some information was redundation, other was missing.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c         |    1 +
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h |    5 +++++
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c  |    3 ---
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c     |    6 +++---
 4 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index e6a02e0..4ce64d7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -790,6 +790,7 @@ int iwlagn_rx_reply_tx(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb,
 		iwl_rx_reply_tx_agg(priv, tx_resp);
 
 	if (tx_resp->frame_count == 1) {
+		IWL_DEBUG_TX_REPLY(priv, "Q %d, ssn %d", txq_id, ssn);
 		__skb_queue_head_init(&skbs);
 		/*we can free until ssn % q.n_bd not inclusive */
 		iwl_trans_reclaim(trans(priv), sta_id, tid, txq_id,
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
index afaaa2a..5a384b3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
@@ -354,6 +354,11 @@ static inline void iwl_set_swq_id(struct iwl_tx_queue *txq, u8 ac, u8 hwq)
 	txq->swq_id = (hwq << 2) | ac;
 }
 
+static inline u8 iwl_get_queue_ac(struct iwl_tx_queue *txq)
+{
+	return txq->swq_id & 0x3;
+}
+
 static inline void iwl_wake_queue(struct iwl_trans *trans,
 				  struct iwl_tx_queue *txq, const char *msg)
 {
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
index 6dba151..b93acce 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
@@ -1121,9 +1121,6 @@ int iwl_tx_queue_reclaim(struct iwl_trans *trans, int txq_id, int index,
 		return 0;
 	}
 
-	IWL_DEBUG_TX_REPLY(trans, "reclaim: [%d, %d, %d]\n", txq_id,
-			   q->read_ptr, index);
-
 	if (WARN_ON(!skb_queue_empty(skbs)))
 		return 0;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
index 3f2ceb2..527e795 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -1350,9 +1350,9 @@ static void iwl_trans_pcie_reclaim(struct iwl_trans *trans, int sta_id, int tid,
 	}
 
 	if (txq->q.read_ptr != tfd_num) {
-		IWL_DEBUG_TX_REPLY(trans, "Retry scheduler reclaim "
-				"scd_ssn=%d idx=%d txq=%d swq=%d\n",
-				ssn , tfd_num, txq_id, txq->swq_id);
+		IWL_DEBUG_TX_REPLY(trans, "[Q %d | AC %d] %d -> %d (%d)\n",
+				txq_id, iwl_get_queue_ac(txq), txq->q.read_ptr,
+				tfd_num, ssn);
 		freed = iwl_tx_queue_reclaim(trans, txq_id, tfd_num, skbs);
 		if (iwl_queue_space(&txq->q) > txq->q.low_mark && cond)
 			iwl_wake_queue(trans, txq, "Packets reclaimed");
-- 
1.7.0.4

