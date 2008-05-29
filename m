Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:31371 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751135AbYE2Iho (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 May 2008 04:37:44 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 28/43] iwlwifi: implement txq invalidate byte count table
Date: Thu, 29 May 2008 16:35:13 +0800
Message-Id: <1212050128-17132-29-git-send-email-yi.zhu@intel.com> (sfid-20080529_110547_813683_EBB07868)
In-Reply-To: <1212050128-17132-28-git-send-email-yi.zhu@intel.com>
References: <1212050128-17132-1-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-2-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-3-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-4-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-5-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-6-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-7-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-8-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-9-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-10-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-11-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-12-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-13-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-14-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-15-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-16-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-17-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-18-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-19-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-20-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-21-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-22-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-23-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-24-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-25-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-26-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-27-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-28-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This is required to overcome a bug in 5000 HW byte count table.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-5000.c |   21 +++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-core.h |    4 +++-
 drivers/net/wireless/iwlwifi/iwl-tx.c   |    5 ++++-
 3 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index dc9f3b6..6a10526 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -955,6 +955,26 @@ static void iwl5000_txq_update_byte_cnt_tbl(struct iwl_priv *priv,
 	}
 }
 
+static void iwl5000_txq_inval_byte_cnt_tbl(struct iwl_priv *priv,
+					   struct iwl_tx_queue *txq)
+{
+	int txq_id = txq->q.id;
+	struct iwl5000_shared *shared_data = priv->shared_virt;
+	u8 sta = 0;
+
+	if (txq_id != IWL_CMD_QUEUE_NUM)
+		sta = txq->cmd[txq->q.read_ptr].cmd.tx.sta_id;
+
+	shared_data->queues_byte_cnt_tbls[txq_id].tfd_offset[txq->q.read_ptr].
+					val = cpu_to_le16(1 | (sta << 12));
+
+	if (txq->q.write_ptr < IWL50_MAX_WIN_SIZE) {
+		shared_data->queues_byte_cnt_tbls[txq_id].
+			tfd_offset[IWL50_QUEUE_SIZE + txq->q.read_ptr].
+				val = cpu_to_le16(1 | (sta << 12));
+	}
+}
+
 static u16 iwl5000_build_addsta_hcmd(const struct iwl_addsta_cmd *cmd, u8 *data)
 {
 	u16 size = (u16)sizeof(struct iwl_addsta_cmd);
@@ -1248,6 +1268,7 @@ static struct iwl_lib_ops iwl5000_lib = {
 	.free_shared_mem = iwl5000_free_shared_mem,
 	.shared_mem_rx_idx = iwl5000_shared_mem_rx_idx,
 	.txq_update_byte_cnt_tbl = iwl5000_txq_update_byte_cnt_tbl,
+	.txq_inval_byte_cnt_tbl = iwl5000_txq_inval_byte_cnt_tbl,
 	.txq_set_sched = iwl5000_txq_set_sched,
 	.rx_handler_setup = iwl5000_rx_handler_setup,
 	.is_valid_rtc_data_addr = iwl5000_hw_valid_rtc_data_addr,
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 8264b4e..1941a91 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -107,10 +107,12 @@ struct iwl_lib_ops {
 	void (*txq_update_byte_cnt_tbl)(struct iwl_priv *priv,
 					struct iwl_tx_queue *txq,
 					u16 byte_cnt);
+	void (*txq_inval_byte_cnt_tbl)(struct iwl_priv *priv,
+				       struct iwl_tx_queue *txq);
+	void (*txq_set_sched)(struct iwl_priv *priv, u32 mask);
 	/* setup Rx handler */
 	void (*rx_handler_setup)(struct iwl_priv *priv);
 	/* nic Tx fifo handling */
-	void (*txq_set_sched)(struct iwl_priv *priv, u32 mask);
 	/* alive notification after init uCode load */
 	void (*init_alive_start)(struct iwl_priv *priv);
 	/* alive notification */
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index b2b2ed2..224bcec 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -1080,8 +1080,11 @@ int iwl_tx_queue_reclaim(struct iwl_priv *priv, int txq_id, int index)
 		tx_info = &txq->txb[txq->q.read_ptr];
 		ieee80211_tx_status_irqsafe(priv->hw, tx_info->skb[0]);
 		tx_info->skb[0] = NULL;
-		iwl_hw_txq_free_tfd(priv, txq);
 
+		if (priv->cfg->ops->lib->txq_inval_byte_cnt_tbl)
+			priv->cfg->ops->lib->txq_inval_byte_cnt_tbl(priv, txq);
+
+		iwl_hw_txq_free_tfd(priv, txq);
 		nfreed++;
 	}
 	return nfreed;
-- 
1.5.3.6

