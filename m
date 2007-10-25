Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:44836 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754351AbXJYJWw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Oct 2007 05:22:52 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 17/30] iwlwifi-ht: move 4965 SCD registers to iwl-prph.h
Date: Thu, 25 Oct 2007 17:15:38 +0800
Message-Id: <11933037762104-git-send-email-yi.zhu@intel.com> (sfid-20071025_104104_725721_35991BF6)
In-Reply-To: <11933037743841-git-send-email-yi.zhu@intel.com>
References: <11933037512140-git-send-email-yi.zhu@intel.com>
 <11933037541699-git-send-email-yi.zhu@intel.com>
 <11933037553170-git-send-email-yi.zhu@intel.com>
 <119330375796-git-send-email-yi.zhu@intel.com>
 <11933037584069-git-send-email-yi.zhu@intel.com>
 <11933037601236-git-send-email-yi.zhu@intel.com>
 <11933037613709-git-send-email-yi.zhu@intel.com>
 <1193303762680-git-send-email-yi.zhu@intel.com>
 <11933037641168-git-send-email-yi.zhu@intel.com>
 <11933037663659-git-send-email-yi.zhu@intel.com>
 <11933037674045-git-send-email-yi.zhu@intel.com>
 <11933037692766-git-send-email-yi.zhu@intel.com>
 <1193303770550-git-send-email-yi.zhu@intel.com>
 <11933037721573-git-send-email-yi.zhu@intel.com>
 <1193303773185-git-send-email-yi.zhu@intel.com>
 <11933037743841-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This patch moves 4965 SCD registers to iwl-prph.h. These registers
are assigned from the periphery bus

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965-hw.h |   32 +---------------------------
 drivers/net/wireless/iwlwifi/iwl-4965.c    |   28 ++++++++++++------------
 drivers/net/wireless/iwlwifi/iwl-prph.h    |   29 +++++++++++++++++++++++++
 3 files changed, 44 insertions(+), 45 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-hw.h b/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
index 6a2df9d..5fc707b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
@@ -398,36 +398,6 @@ union iwl_tx_power_dual_stream {
 #define SCD_WIN_SIZE				64
 #define SCD_FRAME_LIMIT				64
 
-/* memory mapped registers */
-#define SCD_START_OFFSET		0xa02c00
-
-#define SCD_SRAM_BASE_ADDR           (SCD_START_OFFSET + 0x0)
-#define SCD_EMPTY_BITS               (SCD_START_OFFSET + 0x4)
-#define SCD_DRAM_BASE_ADDR           (SCD_START_OFFSET + 0x10)
-#define SCD_AIT                      (SCD_START_OFFSET + 0x18)
-#define SCD_TXFACT                   (SCD_START_OFFSET + 0x1c)
-#define SCD_QUEUE_WRPTR(x)           (SCD_START_OFFSET + 0x24 + (x) * 4)
-#define SCD_QUEUE_RDPTR(x)           (SCD_START_OFFSET + 0x64 + (x) * 4)
-#define SCD_SETQUEUENUM              (SCD_START_OFFSET + 0xa4)
-#define SCD_SET_TXSTAT_TXED          (SCD_START_OFFSET + 0xa8)
-#define SCD_SET_TXSTAT_DONE          (SCD_START_OFFSET + 0xac)
-#define SCD_SET_TXSTAT_NOT_SCHD      (SCD_START_OFFSET + 0xb0)
-#define SCD_DECREASE_CREDIT          (SCD_START_OFFSET + 0xb4)
-#define SCD_DECREASE_SCREDIT         (SCD_START_OFFSET + 0xb8)
-#define SCD_LOAD_CREDIT              (SCD_START_OFFSET + 0xbc)
-#define SCD_LOAD_SCREDIT             (SCD_START_OFFSET + 0xc0)
-#define SCD_BAR                      (SCD_START_OFFSET + 0xc4)
-#define SCD_BAR_DW0                  (SCD_START_OFFSET + 0xc8)
-#define SCD_BAR_DW1                  (SCD_START_OFFSET + 0xcc)
-#define SCD_QUEUECHAIN_SEL           (SCD_START_OFFSET + 0xd0)
-#define SCD_QUERY_REQ                (SCD_START_OFFSET + 0xd8)
-#define SCD_QUERY_RES                (SCD_START_OFFSET + 0xdc)
-#define SCD_PENDING_FRAMES           (SCD_START_OFFSET + 0xe0)
-#define SCD_INTERRUPT_MASK           (SCD_START_OFFSET + 0xe4)
-#define SCD_INTERRUPT_THRESHOLD      (SCD_START_OFFSET + 0xe8)
-#define SCD_QUERY_MIN_FRAME_SIZE     (SCD_START_OFFSET + 0x100)
-#define SCD_QUEUE_STATUS_BITS(x)     (SCD_START_OFFSET + 0x104 + (x) * 4)
-
 /* SRAM structures */
 #define SCD_CONTEXT_DATA_OFFSET			0x380
 #define SCD_TX_STTS_BITMAP_OFFSET		0x400
@@ -544,7 +514,7 @@ struct iwl4965_sched_queue_byte_cnt_tbl {
 		     sizeof(__le16)];
 } __attribute__ ((packed));
 
-/* Base physical address of iwl_shared is provided to SCD_DRAM_BASE_ADDR
+/* Base physical address of iwl_shared is provided to KDR_SCD_DRAM_BASE_ADDR
  * and &iwl_shared.val0 is provided to FH_RSCSR_CHNL0_STTS_WPTR_REG */
 struct iwl_shared {
 	struct iwl4965_sched_queue_byte_cnt_tbl
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index cf85195..674362d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -381,7 +381,7 @@ static int iwl4965_txq_ctx_reset(struct iwl_priv *priv)
 		goto error_reset;
 	}
 
-	iwl_write_prph(priv, SCD_TXFACT, 0);
+	iwl_write_prph(priv, KDR_SCD_TXFACT, 0);
 	iwl_release_nic_access(priv);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
@@ -1582,7 +1582,7 @@ static void iwl4965_set_wr_ptrs(struct iwl_priv *priv, int txq_id, u32 index)
 {
 	iwl_write_direct32(priv, HBUS_TARG_WRPTR,
 			     (index & 0xff) | (txq_id << 8));
-	iwl_write_prph(priv, SCD_QUEUE_RDPTR(txq_id), index);
+	iwl_write_prph(priv, KDR_SCD_QUEUE_RDPTR(txq_id), index);
 }
 
 /*
@@ -1595,7 +1595,7 @@ static void iwl4965_tx_queue_set_status(struct iwl_priv *priv,
 	int txq_id = txq->q.id;
 	int active = test_bit(txq_id, &priv->txq_ctx_active_msk)?1:0;
 
-	iwl_write_prph(priv, SCD_QUEUE_STATUS_BITS(txq_id),
+	iwl_write_prph(priv, KDR_SCD_QUEUE_STATUS_BITS(txq_id),
 				 (active << SCD_QUEUE_STTS_REG_POS_ACTIVE) |
 				 (tx_fifo_id << SCD_QUEUE_STTS_REG_POS_TXF) |
 				 (scd_retry << SCD_QUEUE_STTS_REG_POS_WSL) |
@@ -1653,7 +1653,7 @@ int iwl4965_alive_notify(struct iwl_priv *priv)
 		return rc;
 	}
 
-	priv->scd_base_addr = iwl_read_prph(priv, SCD_SRAM_BASE_ADDR);
+	priv->scd_base_addr = iwl_read_prph(priv, KDR_SCD_SRAM_BASE_ADDR);
 	a = priv->scd_base_addr + SCD_CONTEXT_DATA_OFFSET;
 	for (; a < priv->scd_base_addr + SCD_TX_STTS_BITMAP_OFFSET; a += 4)
 		iwl_write_targ_mem(priv, a, 0);
@@ -1662,14 +1662,14 @@ int iwl4965_alive_notify(struct iwl_priv *priv)
 	for (; a < sizeof(u16) * priv->hw_setting.max_txq_num; a += 4)
 		iwl_write_targ_mem(priv, a, 0);
 
-	iwl_write_prph(priv, SCD_DRAM_BASE_ADDR,
+	iwl_write_prph(priv, KDR_SCD_DRAM_BASE_ADDR,
 		(priv->hw_setting.shared_phys +
 		 offsetof(struct iwl_shared, queues_byte_cnt_tbls)) >> 10);
-	iwl_write_prph(priv, SCD_QUEUECHAIN_SEL, 0);
+	iwl_write_prph(priv, KDR_SCD_QUEUECHAIN_SEL, 0);
 
 	/* initiate the queues */
 	for (i = 0; i < priv->hw_setting.max_txq_num; i++) {
-		iwl_write_prph(priv, SCD_QUEUE_RDPTR(i), 0);
+		iwl_write_prph(priv, KDR_SCD_QUEUE_RDPTR(i), 0);
 		iwl_write_direct32(priv, HBUS_TARG_WRPTR, 0 | (i << 8));
 		iwl_write_targ_mem(priv, priv->scd_base_addr +
 					SCD_CONTEXT_QUEUE_OFFSET(i),
@@ -1684,10 +1684,10 @@ int iwl4965_alive_notify(struct iwl_priv *priv)
 					SCD_QUEUE_CTX_REG2_FRAME_LIMIT_MSK);
 
 	}
-	iwl_write_prph(priv, SCD_INTERRUPT_MASK,
+	iwl_write_prph(priv, KDR_SCD_INTERRUPT_MASK,
 				 (1 << priv->hw_setting.max_txq_num) - 1);
 
-	iwl_write_prph(priv, SCD_TXFACT,
+	iwl_write_prph(priv, KDR_SCD_TXFACT,
 				 SCD_TXFACT_REG_TXFIFO_MASK(0, 7));
 
 	iwl4965_set_wr_ptrs(priv, IWL_CMD_QUEUE_NUM, 0);
@@ -4129,7 +4129,7 @@ static void iwl4965_rx_reply_compressed_ba(struct iwl_priv *priv,
 static void iwl4965_tx_queue_stop_scheduler(struct iwl_priv *priv, u16 txq_id)
 {
 	iwl_write_prph(priv,
-		SCD_QUEUE_STATUS_BITS(txq_id),
+		KDR_SCD_QUEUE_STATUS_BITS(txq_id),
 		(0 << SCD_QUEUE_STTS_REG_POS_ACTIVE)|
 		(1 << SCD_QUEUE_STTS_REG_POS_SCD_ACT_EN));
 }
@@ -4189,7 +4189,7 @@ static int iwl4965_tx_queue_agg_enable(struct iwl_priv *priv, int txq_id,
 	iwl4965_tx_queue_set_q2ratid(priv, ra_tid, txq_id);
 
 
-	iwl_set_bits_prph(priv, SCD_QUEUECHAIN_SEL, (1<<txq_id));
+	iwl_set_bits_prph(priv, KDR_SCD_QUEUECHAIN_SEL, (1<<txq_id));
 
 	priv->txq[txq_id].q.read_ptr = (ssn_idx & 0xff);
 	priv->txq[txq_id].q.write_ptr = (ssn_idx & 0xff);
@@ -4207,7 +4207,7 @@ static int iwl4965_tx_queue_agg_enable(struct iwl_priv *priv, int txq_id,
 			(SCD_FRAME_LIMIT << SCD_QUEUE_CTX_REG2_FRAME_LIMIT_POS)
 			& SCD_QUEUE_CTX_REG2_FRAME_LIMIT_MSK);
 
-	iwl_set_bits_prph(priv, SCD_INTERRUPT_MASK, (1 << txq_id));
+	iwl_set_bits_prph(priv, KDR_SCD_INTERRUPT_MASK, (1 << txq_id));
 
 	iwl4965_tx_queue_set_status(priv, &priv->txq[txq_id], tx_fifo, 1);
 
@@ -4241,14 +4241,14 @@ static int iwl4965_tx_queue_agg_disable(struct iwl_priv *priv, u16 txq_id,
 
 	iwl4965_tx_queue_stop_scheduler(priv, txq_id);
 
-	iwl_clear_bits_prph(priv, SCD_QUEUECHAIN_SEL, (1 << txq_id));
+	iwl_clear_bits_prph(priv, KDR_SCD_QUEUECHAIN_SEL, (1 << txq_id));
 
 	priv->txq[txq_id].q.read_ptr = (ssn_idx & 0xff);
 	priv->txq[txq_id].q.write_ptr = (ssn_idx & 0xff);
 	/* supposes that ssn_idx is valid (!= 0xFFF) */
 	iwl4965_set_wr_ptrs(priv, txq_id, ssn_idx);
 
-	iwl_clear_bits_prph(priv, SCD_INTERRUPT_MASK, (1 << txq_id));
+	iwl_clear_bits_prph(priv, KDR_SCD_INTERRUPT_MASK, (1 << txq_id));
 	iwl4965_txq_ctx_deactivate(priv, txq_id);
 	iwl4965_tx_queue_set_status(priv, &priv->txq[txq_id], tx_fifo, 0);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-prph.h b/drivers/net/wireless/iwlwifi/iwl-prph.h
index b1b5233..9639832 100644
--- a/drivers/net/wireless/iwlwifi/iwl-prph.h
+++ b/drivers/net/wireless/iwlwifi/iwl-prph.h
@@ -225,5 +225,34 @@
 #define BSM_SRAM_LOWER_BOUND         (PRPH_BASE + 0x3800)
 #define BSM_SRAM_SIZE			(1024) /* bytes */
 
+/* 4965 SCD memory mapped registers */
+#define KDR_SCD_BASE		(PRPH_BASE + 0xa02c00)
+
+#define KDR_SCD_SRAM_BASE_ADDR         (KDR_SCD_BASE + 0x0)
+#define KDR_SCD_EMPTY_BITS             (KDR_SCD_BASE + 0x4)
+#define KDR_SCD_DRAM_BASE_ADDR         (KDR_SCD_BASE + 0x10)
+#define KDR_SCD_AIT                    (KDR_SCD_BASE + 0x18)
+#define KDR_SCD_TXFACT                 (KDR_SCD_BASE + 0x1c)
+#define KDR_SCD_QUEUE_WRPTR(x)         (KDR_SCD_BASE + 0x24 + (x) * 4)
+#define KDR_SCD_QUEUE_RDPTR(x)         (KDR_SCD_BASE + 0x64 + (x) * 4)
+#define KDR_SCD_SETQUEUENUM            (KDR_SCD_BASE + 0xa4)
+#define KDR_SCD_SET_TXSTAT_TXED        (KDR_SCD_BASE + 0xa8)
+#define KDR_SCD_SET_TXSTAT_DONE        (KDR_SCD_BASE + 0xac)
+#define KDR_SCD_SET_TXSTAT_NOT_SCHD    (KDR_SCD_BASE + 0xb0)
+#define KDR_SCD_DECREASE_CREDIT        (KDR_SCD_BASE + 0xb4)
+#define KDR_SCD_DECREASE_SCREDIT       (KDR_SCD_BASE + 0xb8)
+#define KDR_SCD_LOAD_CREDIT            (KDR_SCD_BASE + 0xbc)
+#define KDR_SCD_LOAD_SCREDIT           (KDR_SCD_BASE + 0xc0)
+#define KDR_SCD_BAR                    (KDR_SCD_BASE + 0xc4)
+#define KDR_SCD_BAR_DW0                (KDR_SCD_BASE + 0xc8)
+#define KDR_SCD_BAR_DW1                (KDR_SCD_BASE + 0xcc)
+#define KDR_SCD_QUEUECHAIN_SEL         (KDR_SCD_BASE + 0xd0)
+#define KDR_SCD_QUERY_REQ              (KDR_SCD_BASE + 0xd8)
+#define KDR_SCD_QUERY_RES              (KDR_SCD_BASE + 0xdc)
+#define KDR_SCD_PENDING_FRAMES         (KDR_SCD_BASE + 0xe0)
+#define KDR_SCD_INTERRUPT_MASK         (KDR_SCD_BASE + 0xe4)
+#define KDR_SCD_INTERRUPT_THRESHOLD    (KDR_SCD_BASE + 0xe8)
+#define KDR_SCD_QUERY_MIN_FRAME_SIZE   (KDR_SCD_BASE + 0x100)
+#define KDR_SCD_QUEUE_STATUS_BITS(x)   (KDR_SCD_BASE + 0x104 + (x) * 4)
 
 #endif				/* __iwl_prph_h__ */
-- 
1.5.2
