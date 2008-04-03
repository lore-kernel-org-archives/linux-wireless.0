Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:17408 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753509AbYDCXFs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Apr 2008 19:05:48 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Tomas Winkler <tomas.winkler@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 1/5] iwlwifi: hw names cleanup
Date: Thu,  3 Apr 2008 16:05:20 -0700
Message-Id: <1207263924-25385-2-git-send-email-reinette.chatre@intel.com> (sfid-20080404_000606_519679_3D071AF2)
In-Reply-To: <1207263924-25385-1-git-send-email-reinette.chatre@intel.com>
References: <1207263924-25385-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch make some cleanup in HW names

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965-hw.h |   16 +++---
 drivers/net/wireless/iwlwifi/iwl-4965.c    |   28 +++++-----
 drivers/net/wireless/iwlwifi/iwl-prph.h    |   74 +++++++++++++++-------------
 3 files changed, 62 insertions(+), 56 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-hw.h b/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
index 1898888..de7bac1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
@@ -126,16 +126,18 @@
 /* Sizes and addresses for instruction and data memory (SRAM) in
  * 4965's embedded processor.  Driver access is via HBUS_TARG_MEM_* regs. */
 #define RTC_INST_LOWER_BOUND			(0x000000)
-#define KDR_RTC_INST_UPPER_BOUND		(0x018000)
+#define IWL49_RTC_INST_UPPER_BOUND		(0x018000)
 
 #define RTC_DATA_LOWER_BOUND			(0x800000)
-#define KDR_RTC_DATA_UPPER_BOUND		(0x80A000)
+#define IWL49_RTC_DATA_UPPER_BOUND		(0x80A000)
 
-#define KDR_RTC_INST_SIZE    (KDR_RTC_INST_UPPER_BOUND - RTC_INST_LOWER_BOUND)
-#define KDR_RTC_DATA_SIZE    (KDR_RTC_DATA_UPPER_BOUND - RTC_DATA_LOWER_BOUND)
+#define IWL49_RTC_INST_SIZE	\
+			(IWL49_RTC_INST_UPPER_BOUND - RTC_INST_LOWER_BOUND)
+#define IWL49_RTC_DATA_SIZE	\
+			(IWL49_RTC_DATA_UPPER_BOUND - RTC_DATA_LOWER_BOUND)
 
-#define IWL_MAX_INST_SIZE KDR_RTC_INST_SIZE
-#define IWL_MAX_DATA_SIZE KDR_RTC_DATA_SIZE
+#define IWL_MAX_INST_SIZE IWL49_RTC_INST_SIZE
+#define IWL_MAX_DATA_SIZE IWL49_RTC_DATA_SIZE
 
 /* Size of uCode instruction memory in bootstrap state machine */
 #define IWL_MAX_BSM_SIZE BSM_SRAM_SIZE
@@ -143,7 +145,7 @@
 static inline int iwl4965_hw_valid_rtc_data_addr(u32 addr)
 {
 	return (addr >= RTC_DATA_LOWER_BOUND) &&
-	       (addr < KDR_RTC_DATA_UPPER_BOUND);
+	       (addr < IWL49_RTC_DATA_UPPER_BOUND);
 }
 
 /********************* START TEMPERATURE *************************************/
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 0171bb8..3c48952 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -532,7 +532,7 @@ static int iwl4965_txq_ctx_reset(struct iwl_priv *priv)
 	}
 
 	/* Turn off all Tx DMA channels */
-	iwl_write_prph(priv, KDR_SCD_TXFACT, 0);
+	iwl_write_prph(priv, IWL49_SCD_TXFACT, 0);
 	iwl_release_nic_access(priv);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
@@ -1731,7 +1731,7 @@ static void iwl4965_set_wr_ptrs(struct iwl_priv *priv, int txq_id, u32 index)
 {
 	iwl_write_direct32(priv, HBUS_TARG_WRPTR,
 			     (index & 0xff) | (txq_id << 8));
-	iwl_write_prph(priv, KDR_SCD_QUEUE_RDPTR(txq_id), index);
+	iwl_write_prph(priv, IWL49_SCD_QUEUE_RDPTR(txq_id), index);
 }
 
 /**
@@ -1751,7 +1751,7 @@ static void iwl4965_tx_queue_set_status(struct iwl_priv *priv,
 	int active = test_bit(txq_id, &priv->txq_ctx_active_msk)?1:0;
 
 	/* Set up and activate */
-	iwl_write_prph(priv, KDR_SCD_QUEUE_STATUS_BITS(txq_id),
+	iwl_write_prph(priv, IWL49_SCD_QUEUE_STATUS_BITS(txq_id),
 				 (active << SCD_QUEUE_STTS_REG_POS_ACTIVE) |
 				 (tx_fifo_id << SCD_QUEUE_STTS_REG_POS_TXF) |
 				 (scd_retry << SCD_QUEUE_STTS_REG_POS_WSL) |
@@ -1810,7 +1810,7 @@ int iwl4965_alive_notify(struct iwl_priv *priv)
 	}
 
 	/* Clear 4965's internal Tx Scheduler data base */
-	priv->scd_base_addr = iwl_read_prph(priv, KDR_SCD_SRAM_BASE_ADDR);
+	priv->scd_base_addr = iwl_read_prph(priv, IWL49_SCD_SRAM_BASE_ADDR);
 	a = priv->scd_base_addr + SCD_CONTEXT_DATA_OFFSET;
 	for (; a < priv->scd_base_addr + SCD_TX_STTS_BITMAP_OFFSET; a += 4)
 		iwl_write_targ_mem(priv, a, 0);
@@ -1820,18 +1820,18 @@ int iwl4965_alive_notify(struct iwl_priv *priv)
 		iwl_write_targ_mem(priv, a, 0);
 
 	/* Tel 4965 where to find Tx byte count tables */
-	iwl_write_prph(priv, KDR_SCD_DRAM_BASE_ADDR,
+	iwl_write_prph(priv, IWL49_SCD_DRAM_BASE_ADDR,
 		(priv->hw_setting.shared_phys +
 		 offsetof(struct iwl4965_shared, queues_byte_cnt_tbls)) >> 10);
 
 	/* Disable chain mode for all queues */
-	iwl_write_prph(priv, KDR_SCD_QUEUECHAIN_SEL, 0);
+	iwl_write_prph(priv, IWL49_SCD_QUEUECHAIN_SEL, 0);
 
 	/* Initialize each Tx queue (including the command queue) */
 	for (i = 0; i < priv->hw_setting.max_txq_num; i++) {
 
 		/* TFD circular buffer read/write indexes */
-		iwl_write_prph(priv, KDR_SCD_QUEUE_RDPTR(i), 0);
+		iwl_write_prph(priv, IWL49_SCD_QUEUE_RDPTR(i), 0);
 		iwl_write_direct32(priv, HBUS_TARG_WRPTR, 0 | (i << 8));
 
 		/* Max Tx Window size for Scheduler-ACK mode */
@@ -1850,11 +1850,11 @@ int iwl4965_alive_notify(struct iwl_priv *priv)
 					SCD_QUEUE_CTX_REG2_FRAME_LIMIT_MSK);
 
 	}
-	iwl_write_prph(priv, KDR_SCD_INTERRUPT_MASK,
+	iwl_write_prph(priv, IWL49_SCD_INTERRUPT_MASK,
 				 (1 << priv->hw_setting.max_txq_num) - 1);
 
 	/* Activate all Tx DMA/FIFO channels */
-	iwl_write_prph(priv, KDR_SCD_TXFACT,
+	iwl_write_prph(priv, IWL49_SCD_TXFACT,
 				 SCD_TXFACT_REG_TXFIFO_MASK(0, 7));
 
 	iwl4965_set_wr_ptrs(priv, IWL_CMD_QUEUE_NUM, 0);
@@ -4090,7 +4090,7 @@ static void iwl4965_tx_queue_stop_scheduler(struct iwl_priv *priv,
 	/* Simply stop the queue, but don't change any configuration;
 	 * the SCD_ACT_EN bit is the write-enable mask for the ACTIVE bit. */
 	iwl_write_prph(priv,
-		KDR_SCD_QUEUE_STATUS_BITS(txq_id),
+		IWL49_SCD_QUEUE_STATUS_BITS(txq_id),
 		(0 << SCD_QUEUE_STTS_REG_POS_ACTIVE)|
 		(1 << SCD_QUEUE_STTS_REG_POS_SCD_ACT_EN));
 }
@@ -4116,14 +4116,14 @@ static int iwl4965_tx_queue_agg_disable(struct iwl_priv *priv, u16 txq_id,
 
 	iwl4965_tx_queue_stop_scheduler(priv, txq_id);
 
-	iwl_clear_bits_prph(priv, KDR_SCD_QUEUECHAIN_SEL, (1 << txq_id));
+	iwl_clear_bits_prph(priv, IWL49_SCD_QUEUECHAIN_SEL, (1 << txq_id));
 
 	priv->txq[txq_id].q.read_ptr = (ssn_idx & 0xff);
 	priv->txq[txq_id].q.write_ptr = (ssn_idx & 0xff);
 	/* supposes that ssn_idx is valid (!= 0xFFF) */
 	iwl4965_set_wr_ptrs(priv, txq_id, ssn_idx);
 
-	iwl_clear_bits_prph(priv, KDR_SCD_INTERRUPT_MASK, (1 << txq_id));
+	iwl_clear_bits_prph(priv, IWL49_SCD_INTERRUPT_MASK, (1 << txq_id));
 	iwl4965_txq_ctx_deactivate(priv, txq_id);
 	iwl4965_tx_queue_set_status(priv, &priv->txq[txq_id], tx_fifo, 0);
 
@@ -4312,7 +4312,7 @@ static int iwl4965_tx_queue_agg_enable(struct iwl_priv *priv, int txq_id,
 	iwl4965_tx_queue_set_q2ratid(priv, ra_tid, txq_id);
 
 	/* Set this queue as a chain-building queue */
-	iwl_set_bits_prph(priv, KDR_SCD_QUEUECHAIN_SEL, (1 << txq_id));
+	iwl_set_bits_prph(priv, IWL49_SCD_QUEUECHAIN_SEL, (1 << txq_id));
 
 	/* Place first TFD at index corresponding to start sequence number.
 	 * Assumes that ssn_idx is valid (!= 0xFFF) */
@@ -4331,7 +4331,7 @@ static int iwl4965_tx_queue_agg_enable(struct iwl_priv *priv, int txq_id,
 			(SCD_FRAME_LIMIT << SCD_QUEUE_CTX_REG2_FRAME_LIMIT_POS)
 			& SCD_QUEUE_CTX_REG2_FRAME_LIMIT_MSK);
 
-	iwl_set_bits_prph(priv, KDR_SCD_INTERRUPT_MASK, (1 << txq_id));
+	iwl_set_bits_prph(priv, IWL49_SCD_INTERRUPT_MASK, (1 << txq_id));
 
 	/* Set up Status area in SRAM, map to Tx DMA/FIFO, activate the queue */
 	iwl4965_tx_queue_set_status(priv, &priv->txq[txq_id], tx_fifo, 1);
diff --git a/drivers/net/wireless/iwlwifi/iwl-prph.h b/drivers/net/wireless/iwlwifi/iwl-prph.h
index ecf651a..c9cf8ee 100644
--- a/drivers/net/wireless/iwlwifi/iwl-prph.h
+++ b/drivers/net/wireless/iwlwifi/iwl-prph.h
@@ -243,44 +243,48 @@
  * 4965 Tx Scheduler registers.
  * Details are documented in iwl-4965-hw.h
  */
-#define KDR_SCD_BASE		(PRPH_BASE + 0xa02c00)
+#define IWL49_SCD_BASE		(PRPH_BASE + 0xa02c00)
 
-#define KDR_SCD_SRAM_BASE_ADDR         (KDR_SCD_BASE + 0x0)
-#define KDR_SCD_EMPTY_BITS             (KDR_SCD_BASE + 0x4)
-#define KDR_SCD_DRAM_BASE_ADDR         (KDR_SCD_BASE + 0x10)
-#define KDR_SCD_AIT                    (KDR_SCD_BASE + 0x18)
-#define KDR_SCD_TXFACT                 (KDR_SCD_BASE + 0x1c)
-#define KDR_SCD_QUEUE_WRPTR(x)         (KDR_SCD_BASE + 0x24 + (x) * 4)
-#define KDR_SCD_QUEUE_RDPTR(x)         (KDR_SCD_BASE + 0x64 + (x) * 4)
-#define KDR_SCD_SETQUEUENUM            (KDR_SCD_BASE + 0xa4)
-#define KDR_SCD_SET_TXSTAT_TXED        (KDR_SCD_BASE + 0xa8)
-#define KDR_SCD_SET_TXSTAT_DONE        (KDR_SCD_BASE + 0xac)
-#define KDR_SCD_SET_TXSTAT_NOT_SCHD    (KDR_SCD_BASE + 0xb0)
-#define KDR_SCD_DECREASE_CREDIT        (KDR_SCD_BASE + 0xb4)
-#define KDR_SCD_DECREASE_SCREDIT       (KDR_SCD_BASE + 0xb8)
-#define KDR_SCD_LOAD_CREDIT            (KDR_SCD_BASE + 0xbc)
-#define KDR_SCD_LOAD_SCREDIT           (KDR_SCD_BASE + 0xc0)
-#define KDR_SCD_BAR                    (KDR_SCD_BASE + 0xc4)
-#define KDR_SCD_BAR_DW0                (KDR_SCD_BASE + 0xc8)
-#define KDR_SCD_BAR_DW1                (KDR_SCD_BASE + 0xcc)
-#define KDR_SCD_QUEUECHAIN_SEL         (KDR_SCD_BASE + 0xd0)
-#define KDR_SCD_QUERY_REQ              (KDR_SCD_BASE + 0xd8)
-#define KDR_SCD_QUERY_RES              (KDR_SCD_BASE + 0xdc)
-#define KDR_SCD_PENDING_FRAMES         (KDR_SCD_BASE + 0xe0)
-#define KDR_SCD_INTERRUPT_MASK         (KDR_SCD_BASE + 0xe4)
-#define KDR_SCD_INTERRUPT_THRESHOLD    (KDR_SCD_BASE + 0xe8)
-#define KDR_SCD_QUERY_MIN_FRAME_SIZE   (KDR_SCD_BASE + 0x100)
-#define KDR_SCD_QUEUE_STATUS_BITS(x)   (KDR_SCD_BASE + 0x104 + (x) * 4)
+#define IWL49_SCD_SRAM_BASE_ADDR         (IWL49_SCD_BASE + 0x0)
+#define IWL49_SCD_EMPTY_BITS             (IWL49_SCD_BASE + 0x4)
+#define IWL49_SCD_DRAM_BASE_ADDR         (IWL49_SCD_BASE + 0x10)
+#define IWL49_SCD_AIT                    (IWL49_SCD_BASE + 0x18)
+#define IWL49_SCD_TXFACT                 (IWL49_SCD_BASE + 0x1c)
+#define IWL49_SCD_QUEUE_WRPTR(x)         (IWL49_SCD_BASE + 0x24 + (x) * 4)
+#define IWL49_SCD_QUEUE_RDPTR(x)         (IWL49_SCD_BASE + 0x64 + (x) * 4)
+#define IWL49_SCD_SETQUEUENUM            (IWL49_SCD_BASE + 0xa4)
+#define IWL49_SCD_SET_TXSTAT_TXED        (IWL49_SCD_BASE + 0xa8)
+#define IWL49_SCD_SET_TXSTAT_DONE        (IWL49_SCD_BASE + 0xac)
+#define IWL49_SCD_SET_TXSTAT_NOT_SCHD    (IWL49_SCD_BASE + 0xb0)
+#define IWL49_SCD_DECREASE_CREDIT        (IWL49_SCD_BASE + 0xb4)
+#define IWL49_SCD_DECREASE_SCREDIT       (IWL49_SCD_BASE + 0xb8)
+#define IWL49_SCD_LOAD_CREDIT            (IWL49_SCD_BASE + 0xbc)
+#define IWL49_SCD_LOAD_SCREDIT           (IWL49_SCD_BASE + 0xc0)
+#define IWL49_SCD_BAR                    (IWL49_SCD_BASE + 0xc4)
+#define IWL49_SCD_BAR_DW0                (IWL49_SCD_BASE + 0xc8)
+#define IWL49_SCD_BAR_DW1                (IWL49_SCD_BASE + 0xcc)
+#define IWL49_SCD_QUEUECHAIN_SEL         (IWL49_SCD_BASE + 0xd0)
+#define IWL49_SCD_QUERY_REQ              (IWL49_SCD_BASE + 0xd8)
+#define IWL49_SCD_QUERY_RES              (IWL49_SCD_BASE + 0xdc)
+#define IWL49_SCD_PENDING_FRAMES         (IWL49_SCD_BASE + 0xe0)
+#define IWL49_SCD_INTERRUPT_MASK         (IWL49_SCD_BASE + 0xe4)
+#define IWL49_SCD_INTERRUPT_THRESHOLD    (IWL49_SCD_BASE + 0xe8)
+#define IWL49_SCD_QUERY_MIN_FRAME_SIZE   (IWL49_SCD_BASE + 0x100)
+#define IWL49_SCD_QUEUE_STATUS_BITS(x)   (IWL49_SCD_BASE + 0x104 + (x) * 4)
 
 /* SP SCD */
-#define SHL_SCD_BASE			(PRPH_BASE + 0xa02c00)
+#define IWL50_SCD_BASE			(PRPH_BASE + 0xa02c00)
 
-#define SHL_SCD_AIT                    (SHL_SCD_BASE + 0x0c)
-#define SHL_SCD_TXFACT                 (SHL_SCD_BASE + 0x10)
-#define SHL_SCD_QUEUE_WRPTR(x)         (SHL_SCD_BASE + 0x18 + (x) * 4)
-#define SHL_SCD_QUEUE_RDPTR(x)         (SHL_SCD_BASE + 0x68 + (x) * 4)
-#define SHL_SCD_QUEUECHAIN_SEL         (SHL_SCD_BASE + 0xe8)
-#define SHL_SCD_AGGR_SEL	       (SHL_SCD_BASE + 0x248)
-#define SHL_SCD_INTERRUPT_MASK         (SHL_SCD_BASE + 0x108)
+#define IWL50_SCD_SRAM_BASE_ADDR         (IWL50_SCD_BASE + 0x0)
+#define IWL50_SCD_DRAM_BASE_ADDR	 (IWL50_SCD_BASE + 0x8)
+#define IWL50_SCD_AIT                    (IWL50_SCD_BASE + 0x0c)
+#define IWL50_SCD_TXFACT                 (IWL50_SCD_BASE + 0x10)
+#define IWL50_SCD_ACTIVE		 (IWL50_SCD_BASE + 0x14)
+#define IWL50_SCD_QUEUE_WRPTR(x)         (IWL50_SCD_BASE + 0x18 + (x) * 4)
+#define IWL50_SCD_QUEUE_RDPTR(x)         (IWL50_SCD_BASE + 0x68 + (x) * 4)
+#define IWL50_SCD_QUEUECHAIN_SEL         (IWL50_SCD_BASE + 0xe8)
+#define IWL50_SCD_AGGR_SEL	     	 (IWL50_SCD_BASE + 0x248)
+#define IWL50_SCD_INTERRUPT_MASK         (IWL50_SCD_BASE + 0x108)
+#define IWL50_SCD_QUEUE_STATUS_BITS(x)   (IWL50_SCD_BASE + 0x10c + (x) * 4)
 
 #endif				/* __iwl_prph_h__ */
-- 
1.5.3.4

