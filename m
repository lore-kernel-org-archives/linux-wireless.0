Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:59917 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752645Ab0BSGBo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Feb 2010 01:01:44 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net, stable@kernel.org,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 3/3] iwlwifi: error checking for number of tfds in queue
Date: Thu, 18 Feb 2010 22:01:41 -0800
Message-Id: <1266559301-19581-4-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1266559301-19581-1-git-send-email-reinette.chatre@intel.com>
References: <1266559301-19581-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

When receive reply_tx and ready to decrement the count for number of
tfds in queue, do error checking to prevent error condition and
tfds_in_queue become negative number.

This fix starts to address
http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2160 by preventing
the bad situation from propagation when it does occur. This is needed while
the cause of the decrement error is still traced.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
CC: stable@kernel.org
---
 drivers/net/wireless/iwlwifi/iwl-4965.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-5000.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-core.h |    2 ++
 drivers/net/wireless/iwlwifi/iwl-tx.c   |   16 +++++++++++++++-
 4 files changed, 19 insertions(+), 3 deletions(-)

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
index de45f30..845a348 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -1125,7 +1125,7 @@ static void iwl5000_rx_reply_tx(struct iwl_priv *priv,
 					scd_ssn , index, txq_id, txq->swq_id);
 
 			freed = iwl_tx_queue_reclaim(priv, txq_id, index);
-			priv->stations[sta_id].tid[tid].tfds_in_queue -= freed;
+			iwl_free_tfds_in_queue(priv, sta_id, tid, freed);
 
 			if (priv->mac80211_registered &&
 			    (iwl_queue_space(&txq->q) > txq->q.low_mark) &&
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
index 9196d3f..036e662 100644
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
+		IWL_ERR(priv, "free more than tfds_in_queue (%d:%d)\n",
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
@@ -1566,7 +1580,7 @@ void iwl_rx_reply_compressed_ba(struct iwl_priv *priv,
 	if (txq->q.read_ptr != (ba_resp_scd_ssn & 0xff)) {
 		/* calculate mac80211 ampdu sw queue to wake */
 		int freed = iwl_tx_queue_reclaim(priv, scd_flow, index);
-		priv->stations[sta_id].tid[tid].tfds_in_queue -= freed;
+		iwl_free_tfds_in_queue(priv, sta_id, tid, freed);
 
 		if ((iwl_queue_space(&txq->q) > txq->q.low_mark) &&
 		    priv->mac80211_registered &&
-- 
1.6.3.3

