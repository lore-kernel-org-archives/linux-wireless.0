Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:49315 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932599Ab0EMVuS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 May 2010 17:50:18 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 06/17] iwlwifi: move iwl_free_tfds_in_queue to iwlagn
Date: Thu, 13 May 2010 14:49:48 -0700
Message-Id: <1273787399-9280-7-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1273787399-9280-1-git-send-email-reinette.chatre@intel.com>
References: <1273787399-9280-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This function is only used by the agn drivers,
so doesn't have to be in core and exported.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c |   13 +++++++++++++
 drivers/net/wireless/iwlwifi/iwl-agn.h     |    2 ++
 drivers/net/wireless/iwlwifi/iwl-core.h    |    2 --
 drivers/net/wireless/iwlwifi/iwl-tx.c      |   15 ---------------
 4 files changed, 15 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index c7ce632..5f07bc2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -1529,3 +1529,16 @@ int iwlagn_manage_ibss_station(struct iwl_priv *priv,
 	return iwl_remove_station(priv, vif_priv->ibss_bssid_sta_id,
 				  vif->bss_conf.bssid);
 }
+
+void iwl_free_tfds_in_queue(struct iwl_priv *priv,
+			    int sta_id, int tid, int freed)
+{
+	if (priv->stations[sta_id].tid[tid].tfds_in_queue >= freed)
+		priv->stations[sta_id].tid[tid].tfds_in_queue -= freed;
+	else {
+		IWL_DEBUG_TX(priv, "free more than tfds_in_queue (%u:%d)\n",
+			priv->stations[sta_id].tid[tid].tfds_in_queue,
+			freed);
+		priv->stations[sta_id].tid[tid].tfds_in_queue = 0;
+	}
+}
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index 2d74805..fbbefe1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -93,6 +93,8 @@ int iwlagn_txq_agg_enable(struct iwl_priv *priv, int txq_id,
 int iwlagn_txq_agg_disable(struct iwl_priv *priv, u16 txq_id,
 			   u16 ssn_idx, u8 tx_fifo);
 void iwlagn_txq_set_sched(struct iwl_priv *priv, u32 mask);
+void iwl_free_tfds_in_queue(struct iwl_priv *priv,
+			    int sta_id, int tid, int freed);
 
 /* uCode */
 int iwlagn_load_ucode(struct iwl_priv *priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 7e5a5ba..63229dc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -472,8 +472,6 @@ int iwl_hw_txq_attach_buf_to_tfd(struct iwl_priv *priv,
 				 dma_addr_t addr, u16 len, u8 reset, u8 pad);
 int iwl_hw_tx_queue_init(struct iwl_priv *priv,
 			 struct iwl_tx_queue *txq);
-void iwl_free_tfds_in_queue(struct iwl_priv *priv,
-			    int sta_id, int tid, int freed);
 void iwl_txq_update_write_ptr(struct iwl_priv *priv, struct iwl_tx_queue *txq);
 int iwl_tx_queue_init(struct iwl_priv *priv, struct iwl_tx_queue *txq,
 		      int slots_num, u32 txq_id);
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index c3c6505..db83a0a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -76,21 +76,6 @@ void iwl_txq_update_write_ptr(struct iwl_priv *priv, struct iwl_tx_queue *txq)
 }
 EXPORT_SYMBOL(iwl_txq_update_write_ptr);
 
-
-void iwl_free_tfds_in_queue(struct iwl_priv *priv,
-			    int sta_id, int tid, int freed)
-{
-	if (priv->stations[sta_id].tid[tid].tfds_in_queue >= freed)
-		priv->stations[sta_id].tid[tid].tfds_in_queue -= freed;
-	else {
-		IWL_DEBUG_TX(priv, "free more than tfds_in_queue (%u:%d)\n",
-			priv->stations[sta_id].tid[tid].tfds_in_queue,
-			freed);
-		priv->stations[sta_id].tid[tid].tfds_in_queue = 0;
-	}
-}
-EXPORT_SYMBOL(iwl_free_tfds_in_queue);
-
 /**
  * iwl_tx_queue_free - Deallocate DMA queue.
  * @txq: Transmit queue to deallocate.
-- 
1.6.3.3

