Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:10366 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751828Ab0BSXYk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Feb 2010 18:24:40 -0500
Subject: [PATCH v2 3/3] iwlwifi: error checking for number of tfds in queue
From: reinette chatre <reinette.chatre@intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>,
	"stable@kernel.org" <stable@kernel.org>,
	"Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>
In-Reply-To: <1266613164.2551.2811.camel@rchatre-DESK>
References: <1266559301-19581-1-git-send-email-reinette.chatre@intel.com>
	 <1266559301-19581-4-git-send-email-reinette.chatre@intel.com>
	 <20100219203420.GO4950@tuxdriver.com>
	 <1266613164.2551.2811.camel@rchatre-DESK>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 19 Feb 2010 15:24:39 -0800
Message-ID: <1266621879.2551.2975.camel@rchatre-DESK>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

When receive reply_tx and ready to decrement the count for number of
tfds in queue, do error checking to prevent error condition and
tfds_in_queue become negative number.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
CC: stable@kernel.org
---
v2: ensure safe decrement is always done, one instance was missed in v1

 drivers/net/wireless/iwlwifi/iwl-4965.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-5000.c |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-core.h |    2 ++
 drivers/net/wireless/iwlwifi/iwl-tx.c   |   16 +++++++++++++++-
 4 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 9b4b8b5..3146281 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -2008,7 +2008,7 @@ static void iwl4965_rx_reply_tx(struct iwl_priv *priv,
 			IWL_DEBUG_TX_REPLY(priv, "Retry scheduler reclaim scd_ssn "
 					   "%d index %d\n", scd_ssn , index);
 			freed = iwl_tx_queue_reclaim(priv, txq_id, index);
-			priv->stations[sta_id].tid[tid].tfds_in_queue -= freed;
+			iwl_free_tfds_in_queue(priv, sta_id, tid, freed);
 
 			if (priv->mac80211_registered &&
 			    (iwl_queue_space(&txq->q) > txq->q.low_mark) &&
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index de45f30..f27c514 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -1125,7 +1125,7 @@ static void iwl5000_rx_reply_tx(struct iwl_priv *priv,
 					scd_ssn , index, txq_id, txq->swq_id);
 
 			freed = iwl_tx_queue_reclaim(priv, txq_id, index);
-			priv->stations[sta_id].tid[tid].tfds_in_queue -= freed;
+			iwl_free_tfds_in_queue(priv, sta_id, tid, freed);
 
 			if (priv->mac80211_registered &&
 			    (iwl_queue_space(&txq->q) > txq->q.low_mark) &&
@@ -1154,7 +1154,7 @@ static void iwl5000_rx_reply_tx(struct iwl_priv *priv,
 
 		freed = iwl_tx_queue_reclaim(priv, txq_id, index);
 		if (ieee80211_is_data_qos(tx_resp->frame_ctrl))
-			priv->stations[sta_id].tid[tid].tfds_in_queue -= freed;
+			iwl_free_tfds_in_queue(priv, sta_id, tid, freed);
 
 		if (priv->mac80211_registered &&
 		    (iwl_queue_space(&txq->q) > txq->q.low_mark))
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 675b7df..fe37d6a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -446,6 +446,8 @@ void iwl_hw_txq_ctx_free(struct iwl_priv *priv);
 int iwl_hw_tx_queue_init(struct iwl_priv *priv,
 			 struct iwl_tx_queue *txq);
 int iwl_txq_update_write_ptr(struct iwl_priv *priv, struct iwl_tx_queue *txq);
+void iwl_free_tfds_in_queue(struct iwl_priv *priv,
+			    int sta_id, int tid, int freed);
 int iwl_tx_queue_init(struct iwl_priv *priv, struct iwl_tx_queue *txq,
 		      int slots_num, u32 txq_id);
 void iwl_tx_queue_free(struct iwl_priv *priv, int txq_id);
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 87ce2bd..72136c8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -120,6 +120,20 @@ int iwl_txq_update_write_ptr(struct iwl_priv *priv, struct iwl_tx_queue *txq)
 EXPORT_SYMBOL(iwl_txq_update_write_ptr);
 
 
+void iwl_free_tfds_in_queue(struct iwl_priv *priv,
+			    int sta_id, int tid, int freed)
+{
+	if (priv->stations[sta_id].tid[tid].tfds_in_queue >= freed)
+		priv->stations[sta_id].tid[tid].tfds_in_queue -= freed;
+	else {
+		IWL_ERR(priv, "free more than tfds_in_queue (%u:%d)\n",
+			priv->stations[sta_id].tid[tid].tfds_in_queue,
+			freed);
+		priv->stations[sta_id].tid[tid].tfds_in_queue = 0;
+	}
+}
+EXPORT_SYMBOL(iwl_free_tfds_in_queue);
+
 /**
  * iwl_tx_queue_free - Deallocate DMA queue.
  * @txq: Transmit queue to deallocate.
@@ -1559,7 +1573,7 @@ void iwl_rx_reply_compressed_ba(struct iwl_priv *priv,
 	if (txq->q.read_ptr != (ba_resp_scd_ssn & 0xff)) {
 		/* calculate mac80211 ampdu sw queue to wake */
 		int freed = iwl_tx_queue_reclaim(priv, scd_flow, index);
-		priv->stations[sta_id].tid[tid].tfds_in_queue -= freed;
+		iwl_free_tfds_in_queue(priv, sta_id, tid, freed);
 
 		if ((iwl_queue_space(&txq->q) > txq->q.low_mark) &&
 		    priv->mac80211_registered &&
-- 
1.6.3.3



