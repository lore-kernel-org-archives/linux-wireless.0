Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:20549 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752111AbYFLBtg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2008 21:49:36 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 06/29] iwlwifi: add TX aggregation code for 5000 HW
Date: Thu, 12 Jun 2008 09:46:56 +0800
Message-Id: <1213235239-2954-7-git-send-email-yi.zhu@intel.com> (sfid-20080612_034942_446050_257F71B9)
In-Reply-To: <1213235239-2954-6-git-send-email-yi.zhu@intel.com>
References: <1213235239-2954-1-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-2-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-3-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-4-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-5-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-6-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch adds TX aggregation handler for 5000 HW.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-5000.c |  132 +++++++++++++++++++++++++++++++
 1 files changed, 132 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 0ae5421..d3c0e10 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -41,6 +41,7 @@
 #include "iwl-dev.h"
 #include "iwl-core.h"
 #include "iwl-io.h"
+#include "iwl-sta.h"
 #include "iwl-helpers.h"
 #include "iwl-5000-hw.h"
 
@@ -976,6 +977,135 @@ static void iwl5000_txq_inval_byte_cnt_tbl(struct iwl_priv *priv,
 	}
 }
 
+static int iwl5000_tx_queue_set_q2ratid(struct iwl_priv *priv, u16 ra_tid,
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
+static void iwl5000_tx_queue_stop_scheduler(struct iwl_priv *priv, u16 txq_id)
+{
+	/* Simply stop the queue, but don't change any configuration;
+	 * the SCD_ACT_EN bit is the write-enable mask for the ACTIVE bit. */
+	iwl_write_prph(priv,
+		IWL50_SCD_QUEUE_STATUS_BITS(txq_id),
+		(0 << IWL50_SCD_QUEUE_STTS_REG_POS_ACTIVE)|
+		(1 << IWL50_SCD_QUEUE_STTS_REG_POS_SCD_ACT_EN));
+}
+
+static int iwl5000_txq_agg_enable(struct iwl_priv *priv, int txq_id,
+				  int tx_fifo, int sta_id, int tid, u16 ssn_idx)
+{
+	unsigned long flags;
+	int ret;
+	u16 ra_tid;
+
+	if (IWL50_FIRST_AMPDU_QUEUE > txq_id)
+		IWL_WARNING("queue number too small: %d, must be > %d\n",
+			txq_id, IWL50_FIRST_AMPDU_QUEUE);
+
+	ra_tid = BUILD_RAxTID(sta_id, tid);
+
+	/* Modify device's station table to Tx this TID */
+	iwl_sta_modify_enable_tid_tx(priv, sta_id, tid);
+
+	spin_lock_irqsave(&priv->lock, flags);
+	ret = iwl_grab_nic_access(priv);
+	if (ret) {
+		spin_unlock_irqrestore(&priv->lock, flags);
+		return ret;
+	}
+
+	/* Stop this Tx queue before configuring it */
+	iwl5000_tx_queue_stop_scheduler(priv, txq_id);
+
+	/* Map receiver-address / traffic-ID to this queue */
+	iwl5000_tx_queue_set_q2ratid(priv, ra_tid, txq_id);
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
+	iwl5000_set_wr_ptrs(priv, txq_id, ssn_idx);
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
+	iwl5000_tx_queue_set_status(priv, &priv->txq[txq_id], tx_fifo, 1);
+
+	iwl_release_nic_access(priv);
+	spin_unlock_irqrestore(&priv->lock, flags);
+
+	return 0;
+}
+
+static int iwl5000_txq_agg_disable(struct iwl_priv *priv, u16 txq_id,
+				   u16 ssn_idx, u8 tx_fifo)
+{
+	int ret;
+
+	if (IWL50_FIRST_AMPDU_QUEUE > txq_id) {
+		IWL_WARNING("queue number too small: %d, must be > %d\n",
+				txq_id, IWL50_FIRST_AMPDU_QUEUE);
+		return -EINVAL;
+	}
+
+	ret = iwl_grab_nic_access(priv);
+	if (ret)
+		return ret;
+
+	iwl5000_tx_queue_stop_scheduler(priv, txq_id);
+
+	iwl_clear_bits_prph(priv, IWL50_SCD_AGGR_SEL, (1 << txq_id));
+
+	priv->txq[txq_id].q.read_ptr = (ssn_idx & 0xff);
+	priv->txq[txq_id].q.write_ptr = (ssn_idx & 0xff);
+	/* supposes that ssn_idx is valid (!= 0xFFF) */
+	iwl5000_set_wr_ptrs(priv, txq_id, ssn_idx);
+
+	iwl_clear_bits_prph(priv, IWL50_SCD_INTERRUPT_MASK, (1 << txq_id));
+	iwl_txq_ctx_deactivate(priv, txq_id);
+	iwl5000_tx_queue_set_status(priv, &priv->txq[txq_id], tx_fifo, 0);
+
+	iwl_release_nic_access(priv);
+
+	return 0;
+}
+
 static u16 iwl5000_build_addsta_hcmd(const struct iwl_addsta_cmd *cmd, u8 *data)
 {
 	u16 size = (u16)sizeof(struct iwl_addsta_cmd);
@@ -1319,6 +1449,8 @@ static struct iwl_lib_ops iwl5000_lib = {
 	.txq_update_byte_cnt_tbl = iwl5000_txq_update_byte_cnt_tbl,
 	.txq_inval_byte_cnt_tbl = iwl5000_txq_inval_byte_cnt_tbl,
 	.txq_set_sched = iwl5000_txq_set_sched,
+	.txq_agg_enable = iwl5000_txq_agg_enable,
+	.txq_agg_disable = iwl5000_txq_agg_disable,
 	.rx_handler_setup = iwl5000_rx_handler_setup,
 	.setup_deferred_work = iwl5000_setup_deferred_work,
 	.is_valid_rtc_data_addr = iwl5000_hw_valid_rtc_data_addr,
-- 
1.5.3.6

