Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:54054 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932471Ab1EFS2p (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 May 2011 14:28:45 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 6/7] iwlagn: remove bytecount indirection
Date: Fri,  6 May 2011 11:04:39 -0700
Message-Id: <1304705080-29349-7-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110506_202859_908580_9DCFCE15)
In-Reply-To: <1304705080-29349-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1304705080-29349-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

All AGN devices need the bytecount table, so
remove the indirection and make the functions
static again.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c   |    2 --
 drivers/net/wireless/iwlwifi/iwl-2000.c   |    2 --
 drivers/net/wireless/iwlwifi/iwl-5000.c   |    4 ----
 drivers/net/wireless/iwlwifi/iwl-6000.c   |    4 ----
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c |   17 ++++++++---------
 drivers/net/wireless/iwlwifi/iwl-agn.h    |    5 -----
 drivers/net/wireless/iwlwifi/iwl-core.h   |    5 -----
 7 files changed, 8 insertions(+), 31 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index 3da8cf2..b4c8193 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -171,8 +171,6 @@ static int iwl1000_hw_set_hw_params(struct iwl_priv *priv)
 
 static struct iwl_lib_ops iwl1000_lib = {
 	.set_hw_params = iwl1000_hw_set_hw_params,
-	.txq_update_byte_cnt_tbl = iwlagn_txq_update_byte_cnt_tbl,
-	.txq_inval_byte_cnt_tbl = iwlagn_txq_inval_byte_cnt_tbl,
 	.txq_set_sched = iwlagn_txq_set_sched,
 	.txq_attach_buf_to_tfd = iwl_hw_txq_attach_buf_to_tfd,
 	.txq_free_tfd = iwl_hw_txq_free_tfd,
diff --git a/drivers/net/wireless/iwlwifi/iwl-2000.c b/drivers/net/wireless/iwlwifi/iwl-2000.c
index bca462c..89b8da7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-2000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-2000.c
@@ -252,8 +252,6 @@ static int iwl2030_hw_channel_switch(struct iwl_priv *priv,
 
 static struct iwl_lib_ops iwl2000_lib = {
 	.set_hw_params = iwl2000_hw_set_hw_params,
-	.txq_update_byte_cnt_tbl = iwlagn_txq_update_byte_cnt_tbl,
-	.txq_inval_byte_cnt_tbl = iwlagn_txq_inval_byte_cnt_tbl,
 	.txq_set_sched = iwlagn_txq_set_sched,
 	.txq_attach_buf_to_tfd = iwl_hw_txq_attach_buf_to_tfd,
 	.txq_free_tfd = iwl_hw_txq_free_tfd,
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 561f2cd..98f81df 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -339,8 +339,6 @@ static int iwl5000_hw_channel_switch(struct iwl_priv *priv,
 
 static struct iwl_lib_ops iwl5000_lib = {
 	.set_hw_params = iwl5000_hw_set_hw_params,
-	.txq_update_byte_cnt_tbl = iwlagn_txq_update_byte_cnt_tbl,
-	.txq_inval_byte_cnt_tbl = iwlagn_txq_inval_byte_cnt_tbl,
 	.txq_set_sched = iwlagn_txq_set_sched,
 	.txq_attach_buf_to_tfd = iwl_hw_txq_attach_buf_to_tfd,
 	.txq_free_tfd = iwl_hw_txq_free_tfd,
@@ -376,8 +374,6 @@ static struct iwl_lib_ops iwl5000_lib = {
 
 static struct iwl_lib_ops iwl5150_lib = {
 	.set_hw_params = iwl5150_hw_set_hw_params,
-	.txq_update_byte_cnt_tbl = iwlagn_txq_update_byte_cnt_tbl,
-	.txq_inval_byte_cnt_tbl = iwlagn_txq_inval_byte_cnt_tbl,
 	.txq_set_sched = iwlagn_txq_set_sched,
 	.txq_attach_buf_to_tfd = iwl_hw_txq_attach_buf_to_tfd,
 	.txq_free_tfd = iwl_hw_txq_free_tfd,
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 6045457..a7921f9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -278,8 +278,6 @@ static int iwl6000_hw_channel_switch(struct iwl_priv *priv,
 
 static struct iwl_lib_ops iwl6000_lib = {
 	.set_hw_params = iwl6000_hw_set_hw_params,
-	.txq_update_byte_cnt_tbl = iwlagn_txq_update_byte_cnt_tbl,
-	.txq_inval_byte_cnt_tbl = iwlagn_txq_inval_byte_cnt_tbl,
 	.txq_set_sched = iwlagn_txq_set_sched,
 	.txq_attach_buf_to_tfd = iwl_hw_txq_attach_buf_to_tfd,
 	.txq_free_tfd = iwl_hw_txq_free_tfd,
@@ -316,8 +314,6 @@ static struct iwl_lib_ops iwl6000_lib = {
 
 static struct iwl_lib_ops iwl6030_lib = {
 	.set_hw_params = iwl6000_hw_set_hw_params,
-	.txq_update_byte_cnt_tbl = iwlagn_txq_update_byte_cnt_tbl,
-	.txq_inval_byte_cnt_tbl = iwlagn_txq_inval_byte_cnt_tbl,
 	.txq_set_sched = iwlagn_txq_set_sched,
 	.txq_attach_buf_to_tfd = iwl_hw_txq_attach_buf_to_tfd,
 	.txq_free_tfd = iwl_hw_txq_free_tfd,
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index 5445fd6..26601b7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -98,9 +98,9 @@ static inline int get_fifo_from_tid(struct iwl_rxon_context *ctx, u16 tid)
 /**
  * iwlagn_txq_update_byte_cnt_tbl - Set up entry in Tx byte-count array
  */
-void iwlagn_txq_update_byte_cnt_tbl(struct iwl_priv *priv,
-					    struct iwl_tx_queue *txq,
-					    u16 byte_cnt)
+static void iwlagn_txq_update_byte_cnt_tbl(struct iwl_priv *priv,
+					   struct iwl_tx_queue *txq,
+					   u16 byte_cnt)
 {
 	struct iwlagn_scd_bc_tbl *scd_bc_tbl = priv->scd_bc_tbls.addr;
 	int write_ptr = txq->q.write_ptr;
@@ -136,8 +136,8 @@ void iwlagn_txq_update_byte_cnt_tbl(struct iwl_priv *priv,
 			tfd_offset[TFD_QUEUE_SIZE_MAX + write_ptr] = bc_ent;
 }
 
-void iwlagn_txq_inval_byte_cnt_tbl(struct iwl_priv *priv,
-					   struct iwl_tx_queue *txq)
+static void iwlagn_txq_inval_byte_cnt_tbl(struct iwl_priv *priv,
+					  struct iwl_tx_queue *txq)
 {
 	struct iwlagn_scd_bc_tbl *scd_bc_tbl = priv->scd_bc_tbls.addr;
 	int txq_id = txq->q.id;
@@ -766,8 +766,8 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 
 	/* Set up entry for this TFD in Tx byte-count array */
 	if (info->flags & IEEE80211_TX_CTL_AMPDU)
-		priv->cfg->ops->lib->txq_update_byte_cnt_tbl(priv, txq,
-						     le16_to_cpu(tx_cmd->len));
+		iwlagn_txq_update_byte_cnt_tbl(priv, txq,
+					       le16_to_cpu(tx_cmd->len));
 
 	pci_dma_sync_single_for_device(priv->pci_dev, txcmd_phys,
 				       firstlen, PCI_DMA_BIDIRECTIONAL);
@@ -1246,8 +1246,7 @@ int iwlagn_tx_queue_reclaim(struct iwl_priv *priv, int txq_id, int index)
 				 txq_id >= IWLAGN_FIRST_AMPDU_QUEUE);
 		tx_info->skb = NULL;
 
-		if (priv->cfg->ops->lib->txq_inval_byte_cnt_tbl)
-			priv->cfg->ops->lib->txq_inval_byte_cnt_tbl(priv, txq);
+		iwlagn_txq_inval_byte_cnt_tbl(priv, txq);
 
 		priv->cfg->ops->lib->txq_free_tfd(priv, txq);
 	}
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index aa398b6..fe33fe8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -139,11 +139,6 @@ void iwlagn_set_wr_ptrs(struct iwl_priv *priv,
 void iwlagn_tx_queue_set_status(struct iwl_priv *priv,
 			     struct iwl_tx_queue *txq,
 			     int tx_fifo_id, int scd_retry);
-void iwlagn_txq_update_byte_cnt_tbl(struct iwl_priv *priv,
-				    struct iwl_tx_queue *txq,
-				    u16 byte_cnt);
-void iwlagn_txq_inval_byte_cnt_tbl(struct iwl_priv *priv,
-				   struct iwl_tx_queue *txq);
 void iwlagn_txq_set_sched(struct iwl_priv *priv, u32 mask);
 void iwl_free_tfds_in_queue(struct iwl_priv *priv,
 			    int sta_id, int tid, int freed);
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 9d7e36d..5b5b0cc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -128,11 +128,6 @@ struct iwl_lib_ops {
 	/* set hw dependent parameters */
 	int (*set_hw_params)(struct iwl_priv *priv);
 	/* Handling TX */
-	void (*txq_update_byte_cnt_tbl)(struct iwl_priv *priv,
-					struct iwl_tx_queue *txq,
-					u16 byte_cnt);
-	void (*txq_inval_byte_cnt_tbl)(struct iwl_priv *priv,
-				       struct iwl_tx_queue *txq);
 	void (*txq_set_sched)(struct iwl_priv *priv, u32 mask);
 	int (*txq_attach_buf_to_tfd)(struct iwl_priv *priv,
 				     struct iwl_tx_queue *txq,
-- 
1.7.0.4

