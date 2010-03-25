Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:22727 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752766Ab0CYUoz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Mar 2010 16:44:55 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 06/22] iwlwifi: move tx queue related code to separate file
Date: Thu, 25 Mar 2010 13:44:34 -0700
Message-Id: <1269549890-19195-7-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1269549890-19195-1-git-send-email-reinette.chatre@intel.com>
References: <1269549890-19195-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Multiple iwlagn based devices shared the same tansmit queue functions.
Move tx queue related code from iwl-5000.c to iwl-agn-tx.c file.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/Makefile     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-1000.c   |   10 +-
 drivers/net/wireless/iwlwifi/iwl-5000.c   |  253 ++--------------------------
 drivers/net/wireless/iwlwifi/iwl-6000.c   |   20 +-
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c |  268 +++++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-agn.h    |   17 ++
 6 files changed, 313 insertions(+), 257 deletions(-)
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-agn-tx.c

diff --git a/drivers/net/wireless/iwlwifi/Makefile b/drivers/net/wireless/iwlwifi/Makefile
index 46fad2d..fec44cf 100644
--- a/drivers/net/wireless/iwlwifi/Makefile
+++ b/drivers/net/wireless/iwlwifi/Makefile
@@ -10,7 +10,7 @@ CFLAGS_iwl-devtrace.o := -I$(src)
 # AGN
 obj-$(CONFIG_IWLAGN)	+= iwlagn.o
 iwlagn-objs		:= iwl-agn.o iwl-agn-rs.o iwl-agn-led.o iwl-agn-ict.o
-iwlagn-objs		+= iwl-agn-ucode.o iwl-agn-hcmd.o
+iwlagn-objs		+= iwl-agn-ucode.o iwl-agn-hcmd.o iwl-agn-tx.o
 
 iwlagn-$(CONFIG_IWL4965) += iwl-4965.o
 iwlagn-$(CONFIG_IWL5000) += iwl-5000.o
diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index 67d8513..6bdbe2d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -162,11 +162,11 @@ static int iwl1000_hw_set_hw_params(struct iwl_priv *priv)
 
 static struct iwl_lib_ops iwl1000_lib = {
 	.set_hw_params = iwl1000_hw_set_hw_params,
-	.txq_update_byte_cnt_tbl = iwl5000_txq_update_byte_cnt_tbl,
-	.txq_inval_byte_cnt_tbl = iwl5000_txq_inval_byte_cnt_tbl,
-	.txq_set_sched = iwl5000_txq_set_sched,
-	.txq_agg_enable = iwl5000_txq_agg_enable,
-	.txq_agg_disable = iwl5000_txq_agg_disable,
+	.txq_update_byte_cnt_tbl = iwlagn_txq_update_byte_cnt_tbl,
+	.txq_inval_byte_cnt_tbl = iwlagn_txq_inval_byte_cnt_tbl,
+	.txq_set_sched = iwlagn_txq_set_sched,
+	.txq_agg_enable = iwlagn_txq_agg_enable,
+	.txq_agg_disable = iwlagn_txq_agg_disable,
 	.txq_attach_buf_to_tfd = iwl_hw_txq_attach_buf_to_tfd,
 	.txq_free_tfd = iwl_hw_txq_free_tfd,
 	.txq_init = iwl_hw_tx_queue_init,
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 8aa382e..7e27895 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -358,34 +358,6 @@ restart:
 	queue_work(priv->workqueue, &priv->restart);
 }
 
-static void iwl5000_set_wr_ptrs(struct iwl_priv *priv,
-				int txq_id, u32 index)
-{
-	iwl_write_direct32(priv, HBUS_TARG_WRPTR,
-			(index & 0xff) | (txq_id << 8));
-	iwl_write_prph(priv, IWL50_SCD_QUEUE_RDPTR(txq_id), index);
-}
-
-static void iwl5000_tx_queue_set_status(struct iwl_priv *priv,
-					struct iwl_tx_queue *txq,
-					int tx_fifo_id, int scd_retry)
-{
-	int txq_id = txq->q.id;
-	int active = test_bit(txq_id, &priv->txq_ctx_active_msk) ? 1 : 0;
-
-	iwl_write_prph(priv, IWL50_SCD_QUEUE_STATUS_BITS(txq_id),
-			(active << IWL50_SCD_QUEUE_STTS_REG_POS_ACTIVE) |
-			(tx_fifo_id << IWL50_SCD_QUEUE_STTS_REG_POS_TXF) |
-			(1 << IWL50_SCD_QUEUE_STTS_REG_POS_WSL) |
-			IWL50_SCD_QUEUE_STTS_REG_MSK);
-
-	txq->sched_retry = scd_retry;
-
-	IWL_DEBUG_INFO(priv, "%s %s Queue %d on FIFO %d\n",
-		       active ? "Activate" : "Deactivate",
-		       scd_retry ? "BA" : "AC/CMD", txq_id, tx_fifo_id);
-}
-
 int iwl5000_alive_notify(struct iwl_priv *priv)
 {
 	u32 a;
@@ -448,7 +420,7 @@ int iwl5000_alive_notify(struct iwl_priv *priv)
 	/* Activate all Tx DMA/FIFO channels */
 	priv->cfg->ops->lib->txq_set_sched(priv, IWL_MASK(0, 7));
 
-	iwl5000_set_wr_ptrs(priv, IWL_CMD_QUEUE_NUM, 0);
+	iwlagn_set_wr_ptrs(priv, IWL_CMD_QUEUE_NUM, 0);
 
 	/* make sure all queue are not stopped */
 	memset(&priv->queue_stopped[0], 0, sizeof(priv->queue_stopped));
@@ -468,7 +440,7 @@ int iwl5000_alive_notify(struct iwl_priv *priv)
 		if (ac == IWL_TX_FIFO_UNUSED)
 			continue;
 
-		iwl5000_tx_queue_set_status(priv, &priv->txq[i], ac, 0);
+		iwlagn_tx_queue_set_status(priv, &priv->txq[i], ac, 0);
 	}
 
 	spin_unlock_irqrestore(&priv->lock, flags);
@@ -539,207 +511,6 @@ int iwl5000_hw_set_hw_params(struct iwl_priv *priv)
 	return 0;
 }
 
-/**
- * iwl5000_txq_update_byte_cnt_tbl - Set up entry in Tx byte-count array
- */
-void iwl5000_txq_update_byte_cnt_tbl(struct iwl_priv *priv,
-					    struct iwl_tx_queue *txq,
-					    u16 byte_cnt)
-{
-	struct iwl5000_scd_bc_tbl *scd_bc_tbl = priv->scd_bc_tbls.addr;
-	int write_ptr = txq->q.write_ptr;
-	int txq_id = txq->q.id;
-	u8 sec_ctl = 0;
-	u8 sta_id = 0;
-	u16 len = byte_cnt + IWL_TX_CRC_SIZE + IWL_TX_DELIMITER_SIZE;
-	__le16 bc_ent;
-
-	WARN_ON(len > 0xFFF || write_ptr >= TFD_QUEUE_SIZE_MAX);
-
-	if (txq_id != IWL_CMD_QUEUE_NUM) {
-		sta_id = txq->cmd[txq->q.write_ptr]->cmd.tx.sta_id;
-		sec_ctl = txq->cmd[txq->q.write_ptr]->cmd.tx.sec_ctl;
-
-		switch (sec_ctl & TX_CMD_SEC_MSK) {
-		case TX_CMD_SEC_CCM:
-			len += CCMP_MIC_LEN;
-			break;
-		case TX_CMD_SEC_TKIP:
-			len += TKIP_ICV_LEN;
-			break;
-		case TX_CMD_SEC_WEP:
-			len += WEP_IV_LEN + WEP_ICV_LEN;
-			break;
-		}
-	}
-
-	bc_ent = cpu_to_le16((len & 0xFFF) | (sta_id << 12));
-
-	scd_bc_tbl[txq_id].tfd_offset[write_ptr] = bc_ent;
-
-	if (write_ptr < TFD_QUEUE_SIZE_BC_DUP)
-		scd_bc_tbl[txq_id].
-			tfd_offset[TFD_QUEUE_SIZE_MAX + write_ptr] = bc_ent;
-}
-
-void iwl5000_txq_inval_byte_cnt_tbl(struct iwl_priv *priv,
-					   struct iwl_tx_queue *txq)
-{
-	struct iwl5000_scd_bc_tbl *scd_bc_tbl = priv->scd_bc_tbls.addr;
-	int txq_id = txq->q.id;
-	int read_ptr = txq->q.read_ptr;
-	u8 sta_id = 0;
-	__le16 bc_ent;
-
-	WARN_ON(read_ptr >= TFD_QUEUE_SIZE_MAX);
-
-	if (txq_id != IWL_CMD_QUEUE_NUM)
-		sta_id = txq->cmd[read_ptr]->cmd.tx.sta_id;
-
-	bc_ent = cpu_to_le16(1 | (sta_id << 12));
-	scd_bc_tbl[txq_id].tfd_offset[read_ptr] = bc_ent;
-
-	if (read_ptr < TFD_QUEUE_SIZE_BC_DUP)
-		scd_bc_tbl[txq_id].
-			tfd_offset[TFD_QUEUE_SIZE_MAX + read_ptr] = bc_ent;
-}
-
-static int iwl5000_tx_queue_set_q2ratid(struct iwl_priv *priv, u16 ra_tid,
-					u16 txq_id)
-{
-	u32 tbl_dw_addr;
-	u32 tbl_dw;
-	u16 scd_q2ratid;
-
-	scd_q2ratid = ra_tid & IWL_SCD_QUEUE_RA_TID_MAP_RATID_MSK;
-
-	tbl_dw_addr = priv->scd_base_addr +
-			IWL50_SCD_TRANSLATE_TBL_OFFSET_QUEUE(txq_id);
-
-	tbl_dw = iwl_read_targ_mem(priv, tbl_dw_addr);
-
-	if (txq_id & 0x1)
-		tbl_dw = (scd_q2ratid << 16) | (tbl_dw & 0x0000FFFF);
-	else
-		tbl_dw = scd_q2ratid | (tbl_dw & 0xFFFF0000);
-
-	iwl_write_targ_mem(priv, tbl_dw_addr, tbl_dw);
-
-	return 0;
-}
-static void iwl5000_tx_queue_stop_scheduler(struct iwl_priv *priv, u16 txq_id)
-{
-	/* Simply stop the queue, but don't change any configuration;
-	 * the SCD_ACT_EN bit is the write-enable mask for the ACTIVE bit. */
-	iwl_write_prph(priv,
-		IWL50_SCD_QUEUE_STATUS_BITS(txq_id),
-		(0 << IWL50_SCD_QUEUE_STTS_REG_POS_ACTIVE)|
-		(1 << IWL50_SCD_QUEUE_STTS_REG_POS_SCD_ACT_EN));
-}
-
-int iwl5000_txq_agg_enable(struct iwl_priv *priv, int txq_id,
-				  int tx_fifo, int sta_id, int tid, u16 ssn_idx)
-{
-	unsigned long flags;
-	u16 ra_tid;
-
-	if ((IWL50_FIRST_AMPDU_QUEUE > txq_id) ||
-	    (IWL50_FIRST_AMPDU_QUEUE + priv->cfg->num_of_ampdu_queues
-	     <= txq_id)) {
-		IWL_WARN(priv,
-			"queue number out of range: %d, must be %d to %d\n",
-			txq_id, IWL50_FIRST_AMPDU_QUEUE,
-			IWL50_FIRST_AMPDU_QUEUE +
-			priv->cfg->num_of_ampdu_queues - 1);
-		return -EINVAL;
-	}
-
-	ra_tid = BUILD_RAxTID(sta_id, tid);
-
-	/* Modify device's station table to Tx this TID */
-	iwl_sta_tx_modify_enable_tid(priv, sta_id, tid);
-
-	spin_lock_irqsave(&priv->lock, flags);
-
-	/* Stop this Tx queue before configuring it */
-	iwl5000_tx_queue_stop_scheduler(priv, txq_id);
-
-	/* Map receiver-address / traffic-ID to this queue */
-	iwl5000_tx_queue_set_q2ratid(priv, ra_tid, txq_id);
-
-	/* Set this queue as a chain-building queue */
-	iwl_set_bits_prph(priv, IWL50_SCD_QUEUECHAIN_SEL, (1<<txq_id));
-
-	/* enable aggregations for the queue */
-	iwl_set_bits_prph(priv, IWL50_SCD_AGGR_SEL, (1<<txq_id));
-
-	/* Place first TFD at index corresponding to start sequence number.
-	 * Assumes that ssn_idx is valid (!= 0xFFF) */
-	priv->txq[txq_id].q.read_ptr = (ssn_idx & 0xff);
-	priv->txq[txq_id].q.write_ptr = (ssn_idx & 0xff);
-	iwl5000_set_wr_ptrs(priv, txq_id, ssn_idx);
-
-	/* Set up Tx window size and frame limit for this queue */
-	iwl_write_targ_mem(priv, priv->scd_base_addr +
-			IWL50_SCD_CONTEXT_QUEUE_OFFSET(txq_id) +
-			sizeof(u32),
-			((SCD_WIN_SIZE <<
-			IWL50_SCD_QUEUE_CTX_REG2_WIN_SIZE_POS) &
-			IWL50_SCD_QUEUE_CTX_REG2_WIN_SIZE_MSK) |
-			((SCD_FRAME_LIMIT <<
-			IWL50_SCD_QUEUE_CTX_REG2_FRAME_LIMIT_POS) &
-			IWL50_SCD_QUEUE_CTX_REG2_FRAME_LIMIT_MSK));
-
-	iwl_set_bits_prph(priv, IWL50_SCD_INTERRUPT_MASK, (1 << txq_id));
-
-	/* Set up Status area in SRAM, map to Tx DMA/FIFO, activate the queue */
-	iwl5000_tx_queue_set_status(priv, &priv->txq[txq_id], tx_fifo, 1);
-
-	spin_unlock_irqrestore(&priv->lock, flags);
-
-	return 0;
-}
-
-int iwl5000_txq_agg_disable(struct iwl_priv *priv, u16 txq_id,
-				   u16 ssn_idx, u8 tx_fifo)
-{
-	if ((IWL50_FIRST_AMPDU_QUEUE > txq_id) ||
-	    (IWL50_FIRST_AMPDU_QUEUE + priv->cfg->num_of_ampdu_queues
-	     <= txq_id)) {
-		IWL_ERR(priv,
-			"queue number out of range: %d, must be %d to %d\n",
-			txq_id, IWL50_FIRST_AMPDU_QUEUE,
-			IWL50_FIRST_AMPDU_QUEUE +
-			priv->cfg->num_of_ampdu_queues - 1);
-		return -EINVAL;
-	}
-
-	iwl5000_tx_queue_stop_scheduler(priv, txq_id);
-
-	iwl_clear_bits_prph(priv, IWL50_SCD_AGGR_SEL, (1 << txq_id));
-
-	priv->txq[txq_id].q.read_ptr = (ssn_idx & 0xff);
-	priv->txq[txq_id].q.write_ptr = (ssn_idx & 0xff);
-	/* supposes that ssn_idx is valid (!= 0xFFF) */
-	iwl5000_set_wr_ptrs(priv, txq_id, ssn_idx);
-
-	iwl_clear_bits_prph(priv, IWL50_SCD_INTERRUPT_MASK, (1 << txq_id));
-	iwl_txq_ctx_deactivate(priv, txq_id);
-	iwl5000_tx_queue_set_status(priv, &priv->txq[txq_id], tx_fifo, 0);
-
-	return 0;
-}
-
-/*
- * Activate/Deactivate Tx DMA/FIFO channels according tx fifos mask
- * must be called under priv->lock and mac access
- */
-void iwl5000_txq_set_sched(struct iwl_priv *priv, u32 mask)
-{
-	iwl_write_prph(priv, IWL50_SCD_TXFACT, mask);
-}
-
-
 static inline u32 iwl5000_get_scd_ssn(struct iwl5000_tx_resp *tx_resp)
 {
 	return le32_to_cpup((__le32 *)&tx_resp->status +
@@ -1063,11 +834,11 @@ static int iwl5000_hw_channel_switch(struct iwl_priv *priv, u16 channel)
 
 struct iwl_lib_ops iwl5000_lib = {
 	.set_hw_params = iwl5000_hw_set_hw_params,
-	.txq_update_byte_cnt_tbl = iwl5000_txq_update_byte_cnt_tbl,
-	.txq_inval_byte_cnt_tbl = iwl5000_txq_inval_byte_cnt_tbl,
-	.txq_set_sched = iwl5000_txq_set_sched,
-	.txq_agg_enable = iwl5000_txq_agg_enable,
-	.txq_agg_disable = iwl5000_txq_agg_disable,
+	.txq_update_byte_cnt_tbl = iwlagn_txq_update_byte_cnt_tbl,
+	.txq_inval_byte_cnt_tbl = iwlagn_txq_inval_byte_cnt_tbl,
+	.txq_set_sched = iwlagn_txq_set_sched,
+	.txq_agg_enable = iwlagn_txq_agg_enable,
+	.txq_agg_disable = iwlagn_txq_agg_disable,
 	.txq_attach_buf_to_tfd = iwl_hw_txq_attach_buf_to_tfd,
 	.txq_free_tfd = iwl_hw_txq_free_tfd,
 	.txq_init = iwl_hw_tx_queue_init,
@@ -1121,11 +892,11 @@ struct iwl_lib_ops iwl5000_lib = {
 
 static struct iwl_lib_ops iwl5150_lib = {
 	.set_hw_params = iwl5000_hw_set_hw_params,
-	.txq_update_byte_cnt_tbl = iwl5000_txq_update_byte_cnt_tbl,
-	.txq_inval_byte_cnt_tbl = iwl5000_txq_inval_byte_cnt_tbl,
-	.txq_set_sched = iwl5000_txq_set_sched,
-	.txq_agg_enable = iwl5000_txq_agg_enable,
-	.txq_agg_disable = iwl5000_txq_agg_disable,
+	.txq_update_byte_cnt_tbl = iwlagn_txq_update_byte_cnt_tbl,
+	.txq_inval_byte_cnt_tbl = iwlagn_txq_inval_byte_cnt_tbl,
+	.txq_set_sched = iwlagn_txq_set_sched,
+	.txq_agg_enable = iwlagn_txq_agg_enable,
+	.txq_agg_disable = iwlagn_txq_agg_disable,
 	.txq_attach_buf_to_tfd = iwl_hw_txq_attach_buf_to_tfd,
 	.txq_free_tfd = iwl_hw_txq_free_tfd,
 	.txq_init = iwl_hw_tx_queue_init,
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index aff46b0..f376390 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -226,11 +226,11 @@ static int iwl6000_hw_channel_switch(struct iwl_priv *priv, u16 channel)
 
 static struct iwl_lib_ops iwl6000_lib = {
 	.set_hw_params = iwl6000_hw_set_hw_params,
-	.txq_update_byte_cnt_tbl = iwl5000_txq_update_byte_cnt_tbl,
-	.txq_inval_byte_cnt_tbl = iwl5000_txq_inval_byte_cnt_tbl,
-	.txq_set_sched = iwl5000_txq_set_sched,
-	.txq_agg_enable = iwl5000_txq_agg_enable,
-	.txq_agg_disable = iwl5000_txq_agg_disable,
+	.txq_update_byte_cnt_tbl = iwlagn_txq_update_byte_cnt_tbl,
+	.txq_inval_byte_cnt_tbl = iwlagn_txq_inval_byte_cnt_tbl,
+	.txq_set_sched = iwlagn_txq_set_sched,
+	.txq_agg_enable = iwlagn_txq_agg_enable,
+	.txq_agg_disable = iwlagn_txq_agg_disable,
 	.txq_attach_buf_to_tfd = iwl_hw_txq_attach_buf_to_tfd,
 	.txq_free_tfd = iwl_hw_txq_free_tfd,
 	.txq_init = iwl_hw_tx_queue_init,
@@ -293,11 +293,11 @@ static const struct iwl_ops iwl6000_ops = {
 
 static struct iwl_lib_ops iwl6050_lib = {
 	.set_hw_params = iwl6000_hw_set_hw_params,
-	.txq_update_byte_cnt_tbl = iwl5000_txq_update_byte_cnt_tbl,
-	.txq_inval_byte_cnt_tbl = iwl5000_txq_inval_byte_cnt_tbl,
-	.txq_set_sched = iwl5000_txq_set_sched,
-	.txq_agg_enable = iwl5000_txq_agg_enable,
-	.txq_agg_disable = iwl5000_txq_agg_disable,
+	.txq_update_byte_cnt_tbl = iwlagn_txq_update_byte_cnt_tbl,
+	.txq_inval_byte_cnt_tbl = iwlagn_txq_inval_byte_cnt_tbl,
+	.txq_set_sched = iwlagn_txq_set_sched,
+	.txq_agg_enable = iwlagn_txq_agg_enable,
+	.txq_agg_disable = iwlagn_txq_agg_disable,
 	.txq_attach_buf_to_tfd = iwl_hw_txq_attach_buf_to_tfd,
 	.txq_free_tfd = iwl_hw_txq_free_tfd,
 	.txq_init = iwl_hw_tx_queue_init,
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
new file mode 100644
index 0000000..44b3d53
--- /dev/null
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -0,0 +1,268 @@
+/******************************************************************************
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2008 - 2010 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
+ * USA
+ *
+ * The full GNU General Public License is included in this distribution
+ * in the file called LICENSE.GPL.
+ *
+ * Contact Information:
+ *  Intel Linux Wireless <ilw@linux.intel.com>
+ * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
+ *
+ *****************************************************************************/
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/sched.h>
+
+#include "iwl-dev.h"
+#include "iwl-core.h"
+#include "iwl-sta.h"
+#include "iwl-io.h"
+#include "iwl-5000-hw.h"
+
+/**
+ * iwlagn_txq_update_byte_cnt_tbl - Set up entry in Tx byte-count array
+ */
+void iwlagn_txq_update_byte_cnt_tbl(struct iwl_priv *priv,
+					    struct iwl_tx_queue *txq,
+					    u16 byte_cnt)
+{
+	struct iwl5000_scd_bc_tbl *scd_bc_tbl = priv->scd_bc_tbls.addr;
+	int write_ptr = txq->q.write_ptr;
+	int txq_id = txq->q.id;
+	u8 sec_ctl = 0;
+	u8 sta_id = 0;
+	u16 len = byte_cnt + IWL_TX_CRC_SIZE + IWL_TX_DELIMITER_SIZE;
+	__le16 bc_ent;
+
+	WARN_ON(len > 0xFFF || write_ptr >= TFD_QUEUE_SIZE_MAX);
+
+	if (txq_id != IWL_CMD_QUEUE_NUM) {
+		sta_id = txq->cmd[txq->q.write_ptr]->cmd.tx.sta_id;
+		sec_ctl = txq->cmd[txq->q.write_ptr]->cmd.tx.sec_ctl;
+
+		switch (sec_ctl & TX_CMD_SEC_MSK) {
+		case TX_CMD_SEC_CCM:
+			len += CCMP_MIC_LEN;
+			break;
+		case TX_CMD_SEC_TKIP:
+			len += TKIP_ICV_LEN;
+			break;
+		case TX_CMD_SEC_WEP:
+			len += WEP_IV_LEN + WEP_ICV_LEN;
+			break;
+		}
+	}
+
+	bc_ent = cpu_to_le16((len & 0xFFF) | (sta_id << 12));
+
+	scd_bc_tbl[txq_id].tfd_offset[write_ptr] = bc_ent;
+
+	if (write_ptr < TFD_QUEUE_SIZE_BC_DUP)
+		scd_bc_tbl[txq_id].
+			tfd_offset[TFD_QUEUE_SIZE_MAX + write_ptr] = bc_ent;
+}
+
+void iwlagn_txq_inval_byte_cnt_tbl(struct iwl_priv *priv,
+					   struct iwl_tx_queue *txq)
+{
+	struct iwl5000_scd_bc_tbl *scd_bc_tbl = priv->scd_bc_tbls.addr;
+	int txq_id = txq->q.id;
+	int read_ptr = txq->q.read_ptr;
+	u8 sta_id = 0;
+	__le16 bc_ent;
+
+	WARN_ON(read_ptr >= TFD_QUEUE_SIZE_MAX);
+
+	if (txq_id != IWL_CMD_QUEUE_NUM)
+		sta_id = txq->cmd[read_ptr]->cmd.tx.sta_id;
+
+	bc_ent = cpu_to_le16(1 | (sta_id << 12));
+	scd_bc_tbl[txq_id].tfd_offset[read_ptr] = bc_ent;
+
+	if (read_ptr < TFD_QUEUE_SIZE_BC_DUP)
+		scd_bc_tbl[txq_id].
+			tfd_offset[TFD_QUEUE_SIZE_MAX + read_ptr] = bc_ent;
+}
+
+static int iwlagn_tx_queue_set_q2ratid(struct iwl_priv *priv, u16 ra_tid,
+					u16 txq_id)
+{
+	u32 tbl_dw_addr;
+	u32 tbl_dw;
+	u16 scd_q2ratid;
+
+	scd_q2ratid = ra_tid & IWL_SCD_QUEUE_RA_TID_MAP_RATID_MSK;
+
+	tbl_dw_addr = priv->scd_base_addr +
+			IWL50_SCD_TRANSLATE_TBL_OFFSET_QUEUE(txq_id);
+
+	tbl_dw = iwl_read_targ_mem(priv, tbl_dw_addr);
+
+	if (txq_id & 0x1)
+		tbl_dw = (scd_q2ratid << 16) | (tbl_dw & 0x0000FFFF);
+	else
+		tbl_dw = scd_q2ratid | (tbl_dw & 0xFFFF0000);
+
+	iwl_write_targ_mem(priv, tbl_dw_addr, tbl_dw);
+
+	return 0;
+}
+
+static void iwlagn_tx_queue_stop_scheduler(struct iwl_priv *priv, u16 txq_id)
+{
+	/* Simply stop the queue, but don't change any configuration;
+	 * the SCD_ACT_EN bit is the write-enable mask for the ACTIVE bit. */
+	iwl_write_prph(priv,
+		IWL50_SCD_QUEUE_STATUS_BITS(txq_id),
+		(0 << IWL50_SCD_QUEUE_STTS_REG_POS_ACTIVE)|
+		(1 << IWL50_SCD_QUEUE_STTS_REG_POS_SCD_ACT_EN));
+}
+
+void iwlagn_set_wr_ptrs(struct iwl_priv *priv,
+				int txq_id, u32 index)
+{
+	iwl_write_direct32(priv, HBUS_TARG_WRPTR,
+			(index & 0xff) | (txq_id << 8));
+	iwl_write_prph(priv, IWL50_SCD_QUEUE_RDPTR(txq_id), index);
+}
+
+void iwlagn_tx_queue_set_status(struct iwl_priv *priv,
+					struct iwl_tx_queue *txq,
+					int tx_fifo_id, int scd_retry)
+{
+	int txq_id = txq->q.id;
+	int active = test_bit(txq_id, &priv->txq_ctx_active_msk) ? 1 : 0;
+
+	iwl_write_prph(priv, IWL50_SCD_QUEUE_STATUS_BITS(txq_id),
+			(active << IWL50_SCD_QUEUE_STTS_REG_POS_ACTIVE) |
+			(tx_fifo_id << IWL50_SCD_QUEUE_STTS_REG_POS_TXF) |
+			(1 << IWL50_SCD_QUEUE_STTS_REG_POS_WSL) |
+			IWL50_SCD_QUEUE_STTS_REG_MSK);
+
+	txq->sched_retry = scd_retry;
+
+	IWL_DEBUG_INFO(priv, "%s %s Queue %d on FIFO %d\n",
+		       active ? "Activate" : "Deactivate",
+		       scd_retry ? "BA" : "AC/CMD", txq_id, tx_fifo_id);
+}
+
+int iwlagn_txq_agg_enable(struct iwl_priv *priv, int txq_id,
+			  int tx_fifo, int sta_id, int tid, u16 ssn_idx)
+{
+	unsigned long flags;
+	u16 ra_tid;
+
+	if ((IWL50_FIRST_AMPDU_QUEUE > txq_id) ||
+	    (IWL50_FIRST_AMPDU_QUEUE + priv->cfg->num_of_ampdu_queues
+	     <= txq_id)) {
+		IWL_WARN(priv,
+			"queue number out of range: %d, must be %d to %d\n",
+			txq_id, IWL50_FIRST_AMPDU_QUEUE,
+			IWL50_FIRST_AMPDU_QUEUE +
+			priv->cfg->num_of_ampdu_queues - 1);
+		return -EINVAL;
+	}
+
+	ra_tid = BUILD_RAxTID(sta_id, tid);
+
+	/* Modify device's station table to Tx this TID */
+	iwl_sta_tx_modify_enable_tid(priv, sta_id, tid);
+
+	spin_lock_irqsave(&priv->lock, flags);
+
+	/* Stop this Tx queue before configuring it */
+	iwlagn_tx_queue_stop_scheduler(priv, txq_id);
+
+	/* Map receiver-address / traffic-ID to this queue */
+	iwlagn_tx_queue_set_q2ratid(priv, ra_tid, txq_id);
+
+	/* Set this queue as a chain-building queue */
+	iwl_set_bits_prph(priv, IWL50_SCD_QUEUECHAIN_SEL, (1<<txq_id));
+
+	/* enable aggregations for the queue */
+	iwl_set_bits_prph(priv, IWL50_SCD_AGGR_SEL, (1<<txq_id));
+
+	/* Place first TFD at index corresponding to start sequence number.
+	 * Assumes that ssn_idx is valid (!= 0xFFF) */
+	priv->txq[txq_id].q.read_ptr = (ssn_idx & 0xff);
+	priv->txq[txq_id].q.write_ptr = (ssn_idx & 0xff);
+	iwlagn_set_wr_ptrs(priv, txq_id, ssn_idx);
+
+	/* Set up Tx window size and frame limit for this queue */
+	iwl_write_targ_mem(priv, priv->scd_base_addr +
+			IWL50_SCD_CONTEXT_QUEUE_OFFSET(txq_id) +
+			sizeof(u32),
+			((SCD_WIN_SIZE <<
+			IWL50_SCD_QUEUE_CTX_REG2_WIN_SIZE_POS) &
+			IWL50_SCD_QUEUE_CTX_REG2_WIN_SIZE_MSK) |
+			((SCD_FRAME_LIMIT <<
+			IWL50_SCD_QUEUE_CTX_REG2_FRAME_LIMIT_POS) &
+			IWL50_SCD_QUEUE_CTX_REG2_FRAME_LIMIT_MSK));
+
+	iwl_set_bits_prph(priv, IWL50_SCD_INTERRUPT_MASK, (1 << txq_id));
+
+	/* Set up Status area in SRAM, map to Tx DMA/FIFO, activate the queue */
+	iwlagn_tx_queue_set_status(priv, &priv->txq[txq_id], tx_fifo, 1);
+
+	spin_unlock_irqrestore(&priv->lock, flags);
+
+	return 0;
+}
+
+int iwlagn_txq_agg_disable(struct iwl_priv *priv, u16 txq_id,
+			   u16 ssn_idx, u8 tx_fifo)
+{
+	if ((IWL50_FIRST_AMPDU_QUEUE > txq_id) ||
+	    (IWL50_FIRST_AMPDU_QUEUE + priv->cfg->num_of_ampdu_queues
+	     <= txq_id)) {
+		IWL_ERR(priv,
+			"queue number out of range: %d, must be %d to %d\n",
+			txq_id, IWL50_FIRST_AMPDU_QUEUE,
+			IWL50_FIRST_AMPDU_QUEUE +
+			priv->cfg->num_of_ampdu_queues - 1);
+		return -EINVAL;
+	}
+
+	iwlagn_tx_queue_stop_scheduler(priv, txq_id);
+
+	iwl_clear_bits_prph(priv, IWL50_SCD_AGGR_SEL, (1 << txq_id));
+
+	priv->txq[txq_id].q.read_ptr = (ssn_idx & 0xff);
+	priv->txq[txq_id].q.write_ptr = (ssn_idx & 0xff);
+	/* supposes that ssn_idx is valid (!= 0xFFF) */
+	iwlagn_set_wr_ptrs(priv, txq_id, ssn_idx);
+
+	iwl_clear_bits_prph(priv, IWL50_SCD_INTERRUPT_MASK, (1 << txq_id));
+	iwl_txq_ctx_deactivate(priv, txq_id);
+	iwlagn_tx_queue_set_status(priv, &priv->txq[txq_id], tx_fifo, 0);
+
+	return 0;
+}
+
+/*
+ * Activate/Deactivate Tx DMA/FIFO channels according tx fifos mask
+ * must be called under priv->lock and mac access
+ */
+void iwlagn_txq_set_sched(struct iwl_priv *priv, u32 mask)
+{
+	iwl_write_prph(priv, IWL50_SCD_TXFACT, mask);
+}
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index 51e49df..2ff7b8f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -80,4 +80,21 @@ bool iwl_good_ack_health(struct iwl_priv *priv,
 /* uCode */
 int iwlagn_load_ucode(struct iwl_priv *priv);
 
+/* tx queue */
+void iwlagn_set_wr_ptrs(struct iwl_priv *priv,
+		     int txq_id, u32 index);
+void iwlagn_tx_queue_set_status(struct iwl_priv *priv,
+			     struct iwl_tx_queue *txq,
+			     int tx_fifo_id, int scd_retry);
+void iwlagn_txq_update_byte_cnt_tbl(struct iwl_priv *priv,
+				    struct iwl_tx_queue *txq,
+				    u16 byte_cnt);
+void iwlagn_txq_inval_byte_cnt_tbl(struct iwl_priv *priv,
+				   struct iwl_tx_queue *txq);
+int iwlagn_txq_agg_enable(struct iwl_priv *priv, int txq_id,
+			  int tx_fifo, int sta_id, int tid, u16 ssn_idx);
+int iwlagn_txq_agg_disable(struct iwl_priv *priv, u16 txq_id,
+			   u16 ssn_idx, u8 tx_fifo);
+void iwlagn_txq_set_sched(struct iwl_priv *priv, u32 mask);
+
 #endif /* __iwl_agn_h__ */
-- 
1.6.3.3

