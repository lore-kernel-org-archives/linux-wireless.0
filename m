Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11157 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755265Ab1KRIVS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Nov 2011 03:21:18 -0500
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pAI8LItb022568
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-wireless@vger.kernel.org>; Fri, 18 Nov 2011 03:21:18 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 14/77] iwlegacy: rename i/o direct methods
Date: Fri, 18 Nov 2011 09:21:36 +0100
Message-Id: <1321604559-10707-14-git-send-email-sgruszka@redhat.com> (sfid-20111118_092145_305295_F5430865)
In-Reply-To: <1321604559-10707-1-git-send-email-sgruszka@redhat.com>
References: <1321604559-10707-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/iwl-3945.c       |   30 ++++++++++++------------
 drivers/net/wireless/iwlegacy/iwl-4965-lib.c   |   18 +++++++-------
 drivers/net/wireless/iwlegacy/iwl-4965-tx.c    |   10 ++++----
 drivers/net/wireless/iwlegacy/iwl-4965-ucode.c |    4 +-
 drivers/net/wireless/iwlegacy/iwl-csr.h        |    4 +-
 drivers/net/wireless/iwlegacy/iwl-io.h         |   11 ++++----
 drivers/net/wireless/iwlegacy/iwl-rx.c         |    4 +-
 drivers/net/wireless/iwlegacy/iwl-tx.c         |    2 +-
 drivers/net/wireless/iwlegacy/iwl3945-base.c   |    6 ++--
 drivers/net/wireless/iwlegacy/iwl4965-base.c   |   16 ++++++------
 10 files changed, 52 insertions(+), 53 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/iwl-3945.c b/drivers/net/wireless/iwlegacy/iwl-3945.c
index 8c3ae39..fc8ddb6 100644
--- a/drivers/net/wireless/iwlegacy/iwl-3945.c
+++ b/drivers/net/wireless/iwlegacy/iwl-3945.c
@@ -773,11 +773,11 @@ static void il3945_set_pwr_vmain(struct il_priv *il)
 
 static int il3945_rx_init(struct il_priv *il, struct il_rx_queue *rxq)
 {
-	il_write_direct32(il, FH39_RCSR_RBD_BASE(0), rxq->bd_dma);
-	il_write_direct32(il, FH39_RCSR_RPTR_ADDR(0),
+	il_wr(il, FH39_RCSR_RBD_BASE(0), rxq->bd_dma);
+	il_wr(il, FH39_RCSR_RPTR_ADDR(0),
 					rxq->rb_stts_dma);
-	il_write_direct32(il, FH39_RCSR_WPTR(0), 0);
-	il_write_direct32(il, FH39_RCSR_CONFIG(0),
+	il_wr(il, FH39_RCSR_WPTR(0), 0);
+	il_wr(il, FH39_RCSR_CONFIG(0),
 		FH39_RCSR_RX_CONFIG_REG_VAL_DMA_CHNL_EN_ENABLE |
 		FH39_RCSR_RX_CONFIG_REG_VAL_RDRBD_EN_ENABLE |
 		FH39_RCSR_RX_CONFIG_REG_BIT_WR_STTS_EN |
@@ -788,7 +788,7 @@ static int il3945_rx_init(struct il_priv *il, struct il_rx_queue *rxq)
 		FH39_RCSR_RX_CONFIG_REG_VAL_MSG_MODE_FH);
 
 	/* fake read to flush all prev I/O */
-	il_read_direct32(il, FH39_RSSR_CTRL);
+	il_rd(il, FH39_RSSR_CTRL);
 
 	return 0;
 }
@@ -810,10 +810,10 @@ static int il3945_tx_reset(struct il_priv *il)
 	il_write_prph(il, ALM_SCD_TXF4MF_REG, 0x000004);
 	il_write_prph(il, ALM_SCD_TXF5MF_REG, 0x000005);
 
-	il_write_direct32(il, FH39_TSSR_CBB_BASE,
+	il_wr(il, FH39_TSSR_CBB_BASE,
 			     il->_3945.shared_phys);
 
-	il_write_direct32(il, FH39_TSSR_MSG_CONFIG,
+	il_wr(il, FH39_TSSR_MSG_CONFIG,
 		FH39_TSSR_TX_MSG_CONFIG_REG_VAL_SNOOP_RD_TXPD_ON |
 		FH39_TSSR_TX_MSG_CONFIG_REG_VAL_ORDER_RD_TXPD_ON |
 		FH39_TSSR_TX_MSG_CONFIG_REG_VAL_MAX_FRAG_SIZE_128B |
@@ -987,7 +987,7 @@ int il3945_hw_nic_init(struct il_priv *il)
 	il_rx_queue_update_write_ptr(il, rxq);
 	*/
 
-	il_write_direct32(il, FH39_RCSR_WPTR(0), rxq->write & ~7);
+	il_wr(il, FH39_RCSR_WPTR(0), rxq->write & ~7);
 
 	rc = il3945_txq_ctx_reset(il);
 	if (rc)
@@ -1030,8 +1030,8 @@ void il3945_hw_txq_ctx_stop(struct il_priv *il)
 
 	/* reset TFD queues */
 	for (txq_id = 0; txq_id < il->hw_params.max_txq_num; txq_id++) {
-		il_write_direct32(il, FH39_TCSR_CONFIG(txq_id), 0x0);
-		il_poll_direct_bit(il, FH39_TSSR_TX_STATUS,
+		il_wr(il, FH39_TCSR_CONFIG(txq_id), 0x0);
+		il_poll_bit(il, FH39_TSSR_TX_STATUS,
 				FH39_TSSR_TX_STATUS_REG_MSK_CHNL_IDLE(txq_id),
 				1000);
 	}
@@ -2183,8 +2183,8 @@ int il3945_hw_rxq_stop(struct il_priv *il)
 {
 	int rc;
 
-	il_write_direct32(il, FH39_RCSR_CONFIG(0), 0);
-	rc = il_poll_direct_bit(il, FH39_RSSR_STATUS,
+	il_wr(il, FH39_RCSR_CONFIG(0), 0);
+	rc = il_poll_bit(il, FH39_RSSR_STATUS,
 			FH39_RSSR_CHNL0_RX_STATUS_CHNL_IDLE, 1000);
 	if (rc < 0)
 		IL_ERR("Can't stop Rx DMA.\n");
@@ -2200,10 +2200,10 @@ int il3945_hw_tx_queue_init(struct il_priv *il, struct il_tx_queue *txq)
 
 	shared_data->tx_base_ptr[txq_id] = cpu_to_le32((u32)txq->q.dma_addr);
 
-	il_write_direct32(il, FH39_CBCC_CTRL(txq_id), 0);
-	il_write_direct32(il, FH39_CBCC_BASE(txq_id), 0);
+	il_wr(il, FH39_CBCC_CTRL(txq_id), 0);
+	il_wr(il, FH39_CBCC_BASE(txq_id), 0);
 
-	il_write_direct32(il, FH39_TCSR_CONFIG(txq_id),
+	il_wr(il, FH39_TCSR_CONFIG(txq_id),
 		FH39_TCSR_TX_CONFIG_REG_VAL_CIRQ_RTC_NOINT |
 		FH39_TCSR_TX_CONFIG_REG_VAL_MSG_MODE_TXF |
 		FH39_TCSR_TX_CONFIG_REG_VAL_CIRQ_HOST_IFTFD |
diff --git a/drivers/net/wireless/iwlegacy/iwl-4965-lib.c b/drivers/net/wireless/iwlegacy/iwl-4965-lib.c
index 6503b8f..8fafd20 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965-lib.c
+++ b/drivers/net/wireless/iwlegacy/iwl-4965-lib.c
@@ -103,17 +103,17 @@ int il4965_rx_init(struct il_priv *il, struct il_rx_queue *rxq)
 		rb_size = FH_RCSR_RX_CONFIG_REG_VAL_RB_SIZE_4K;
 
 	/* Stop Rx DMA */
-	il_write_direct32(il, FH_MEM_RCSR_CHNL0_CONFIG_REG, 0);
+	il_wr(il, FH_MEM_RCSR_CHNL0_CONFIG_REG, 0);
 
 	/* Reset driver's Rx queue write index */
-	il_write_direct32(il, FH_RSCSR_CHNL0_RBDCB_WPTR_REG, 0);
+	il_wr(il, FH_RSCSR_CHNL0_RBDCB_WPTR_REG, 0);
 
 	/* Tell device where to find RBD circular buffer in DRAM */
-	il_write_direct32(il, FH_RSCSR_CHNL0_RBDCB_BASE_REG,
+	il_wr(il, FH_RSCSR_CHNL0_RBDCB_BASE_REG,
 			   (u32)(rxq->bd_dma >> 8));
 
 	/* Tell device where in DRAM to update its Rx status */
-	il_write_direct32(il, FH_RSCSR_CHNL0_STTS_WPTR_REG,
+	il_wr(il, FH_RSCSR_CHNL0_STTS_WPTR_REG,
 			   rxq->rb_stts_dma >> 4);
 
 	/* Enable Rx DMA
@@ -122,7 +122,7 @@ int il4965_rx_init(struct il_priv *il, struct il_rx_queue *rxq)
 	 * RB timeout 0x10
 	 * 256 RBDs
 	 */
-	il_write_direct32(il, FH_MEM_RCSR_CHNL0_CONFIG_REG,
+	il_wr(il, FH_MEM_RCSR_CHNL0_CONFIG_REG,
 			   FH_RCSR_RX_CONFIG_CHNL_EN_ENABLE_VAL |
 			   FH_RCSR_CHNL0_RX_CONFIG_IRQ_DEST_INT_HOST_VAL |
 			   FH_RCSR_CHNL0_RX_CONFIG_SINGLE_FRAME_MSK |
@@ -403,8 +403,8 @@ int il4965_rxq_stop(struct il_priv *il)
 {
 
 	/* stop Rx DMA */
-	il_write_direct32(il, FH_MEM_RCSR_CHNL0_CONFIG_REG, 0);
-	il_poll_direct_bit(il, FH_MEM_RSSR_RX_STATUS_REG,
+	il_wr(il, FH_MEM_RCSR_CHNL0_CONFIG_REG, 0);
+	il_poll_bit(il, FH_MEM_RSSR_RX_STATUS_REG,
 			    FH_RSSR_CHNL0_RX_STATUS_CHNL_IDLE, 1000);
 
 	return 0;
@@ -1179,7 +1179,7 @@ int il4965_dump_fh(struct il_priv *il, char **buf, bool display)
 			pos += scnprintf(*buf + pos, bufsz - pos,
 				"  %34s: 0X%08x\n",
 				il4965_get_fh_string(fh_tbl[i]),
-				il_read_direct32(il, fh_tbl[i]));
+				il_rd(il, fh_tbl[i]));
 		}
 		return pos;
 	}
@@ -1188,7 +1188,7 @@ int il4965_dump_fh(struct il_priv *il, char **buf, bool display)
 	for (i = 0; i <  ARRAY_SIZE(fh_tbl); i++) {
 		IL_ERR("  %34s: 0X%08x\n",
 			il4965_get_fh_string(fh_tbl[i]),
-			il_read_direct32(il, fh_tbl[i]));
+			il_rd(il, fh_tbl[i]));
 	}
 	return 0;
 }
diff --git a/drivers/net/wireless/iwlegacy/iwl-4965-tx.c b/drivers/net/wireless/iwlegacy/iwl-4965-tx.c
index 66dd172..25c9b71 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965-tx.c
+++ b/drivers/net/wireless/iwlegacy/iwl-4965-tx.c
@@ -640,7 +640,7 @@ int il4965_txq_ctx_alloc(struct il_priv *il)
 	il4965_txq_set_sched(il, 0);
 
 	/* Tell NIC where to find the "keep warm" buffer */
-	il_write_direct32(il, FH_KW_MEM_ADDR_REG, il->kw.dma >> 4);
+	il_wr(il, FH_KW_MEM_ADDR_REG, il->kw.dma >> 4);
 
 	spin_unlock_irqrestore(&il->lock, flags);
 
@@ -679,7 +679,7 @@ void il4965_txq_ctx_reset(struct il_priv *il)
 	il4965_txq_set_sched(il, 0);
 
 	/* Tell NIC where to find the "keep warm" buffer */
-	il_write_direct32(il, FH_KW_MEM_ADDR_REG, il->kw.dma >> 4);
+	il_wr(il, FH_KW_MEM_ADDR_REG, il->kw.dma >> 4);
 
 	spin_unlock_irqrestore(&il->lock, flags);
 
@@ -707,14 +707,14 @@ void il4965_txq_ctx_stop(struct il_priv *il)
 
 	/* Stop each Tx DMA channel, and wait for it to be idle */
 	for (ch = 0; ch < il->hw_params.dma_chnl_num; ch++) {
-		il_write_direct32(il,
+		il_wr(il,
 				FH_TCSR_CHNL_TX_CONFIG_REG(ch), 0x0);
-		if (il_poll_direct_bit(il, FH_TSSR_TX_STATUS_REG,
+		if (il_poll_bit(il, FH_TSSR_TX_STATUS_REG,
 				    FH_TSSR_TX_STATUS_REG_MSK_CHNL_IDLE(ch),
 				    1000))
 			IL_ERR("Failing on timeout while stopping"
 			    " DMA channel %d [0x%08x]", ch,
-			    il_read_direct32(il,
+			    il_rd(il,
 					FH_TSSR_TX_STATUS_REG));
 	}
 	spin_unlock_irqrestore(&il->lock, flags);
diff --git a/drivers/net/wireless/iwlegacy/iwl-4965-ucode.c b/drivers/net/wireless/iwlegacy/iwl-4965-ucode.c
index 4f0e6fe..bb0b7f5 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965-ucode.c
+++ b/drivers/net/wireless/iwlegacy/iwl-4965-ucode.c
@@ -61,7 +61,7 @@ il4965_verify_inst_sparse(struct il_priv *il, __le32 *image, u32 len)
 		/* read data comes through single port, auto-incr addr */
 		/* NOTE: Use the debugless read so we don't flood kernel log
 		 * if IL_DL_IO is set */
-		il_write_direct32(il, HBUS_TARG_MEM_RADDR,
+		il_wr(il, HBUS_TARG_MEM_RADDR,
 			i + IWL4965_RTC_INST_LOWER_BOUND);
 		val = _il_rd(il, HBUS_TARG_MEM_RDAT);
 		if (val != le32_to_cpu(*image)) {
@@ -89,7 +89,7 @@ static int il4965_verify_inst_full(struct il_priv *il, __le32 *image,
 
 	D_INFO("ucode inst image size is %u\n", len);
 
-	il_write_direct32(il, HBUS_TARG_MEM_RADDR,
+	il_wr(il, HBUS_TARG_MEM_RADDR,
 			   IWL4965_RTC_INST_LOWER_BOUND);
 
 	errcnt = 0;
diff --git a/drivers/net/wireless/iwlegacy/iwl-csr.h b/drivers/net/wireless/iwlegacy/iwl-csr.h
index faffb8e..c00ec35 100644
--- a/drivers/net/wireless/iwlegacy/iwl-csr.h
+++ b/drivers/net/wireless/iwlegacy/iwl-csr.h
@@ -72,7 +72,7 @@
  *
  * Use _il_wr() and _il_rd() family to access these registers;
  * these provide simple PCI bus access, without waking up the MAC.
- * Do not use il_write_direct32() family for these registers;
+ * Do not use il_wr() family for these registers;
  * no need to "grab nic access" via CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ.
  * The MAC (uCode processor, etc.) does not need to be powered up for accessing
  * the CSR registers.
@@ -368,7 +368,7 @@
  * to indirectly access device's internal memory or registers that
  * may be powered-down.
  *
- * Use il_write_direct32()/il_read_direct32() family
+ * Use il_wr()/il_rd() family
  * for these registers;
  * host must "grab nic access" via CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ
  * to make sure the MAC (uCode processor, etc.) is powered up for accessing
diff --git a/drivers/net/wireless/iwlegacy/iwl-io.h b/drivers/net/wireless/iwlegacy/iwl-io.h
index ecf799d..f435942 100644
--- a/drivers/net/wireless/iwlegacy/iwl-io.h
+++ b/drivers/net/wireless/iwlegacy/iwl-io.h
@@ -144,7 +144,7 @@ static inline void _il_release_nic_access(struct il_priv *il)
 			CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
 }
 
-static inline u32 il_read_direct32(struct il_priv *il, u32 reg)
+static inline u32 il_rd(struct il_priv *il, u32 reg)
 {
 	u32 value;
 	unsigned long reg_flags;
@@ -159,7 +159,7 @@ static inline u32 il_read_direct32(struct il_priv *il, u32 reg)
 }
 
 static inline void
-il_write_direct32(struct il_priv *il, u32 reg, u32 value)
+il_wr(struct il_priv *il, u32 reg, u32 value)
 {
 	unsigned long reg_flags;
 
@@ -178,17 +178,17 @@ static inline void il_write_reg_buf(struct il_priv *il,
 
 	if ((il != NULL) && (values != NULL)) {
 		for (; 0 < len; len -= count, reg += count, values++)
-			il_write_direct32(il, reg, *values);
+			il_wr(il, reg, *values);
 	}
 }
 
-static inline int _il_poll_direct_bit(struct il_priv *il, u32 addr,
+static inline int il_poll_bit(struct il_priv *il, u32 addr,
 				       u32 mask, int timeout)
 {
 	int t = 0;
 
 	do {
-		if ((il_read_direct32(il, addr) & mask) == mask)
+		if ((il_rd(il, addr) & mask) == mask)
 			return t;
 		udelay(IL_POLL_INTERVAL);
 		t += IL_POLL_INTERVAL;
@@ -196,7 +196,6 @@ static inline int _il_poll_direct_bit(struct il_priv *il, u32 addr,
 
 	return -ETIMEDOUT;
 }
-#define il_poll_direct_bit _il_poll_direct_bit
 
 static inline u32 _il_read_prph(struct il_priv *il, u32 reg)
 {
diff --git a/drivers/net/wireless/iwlegacy/iwl-rx.c b/drivers/net/wireless/iwlegacy/iwl-rx.c
index e481ca8..b2ec2a2 100644
--- a/drivers/net/wireless/iwlegacy/iwl-rx.c
+++ b/drivers/net/wireless/iwlegacy/iwl-rx.c
@@ -150,14 +150,14 @@ il_rx_queue_update_write_ptr(struct il_priv *il,
 		}
 
 		q->write_actual = (q->write & ~0x7);
-		il_write_direct32(il, rx_wrt_ptr_reg,
+		il_wr(il, rx_wrt_ptr_reg,
 				q->write_actual);
 
 	/* Else device is assumed to be awake */
 	} else {
 		/* Device expects a multiple of 8 */
 		q->write_actual = (q->write & ~0x7);
-		il_write_direct32(il, rx_wrt_ptr_reg,
+		il_wr(il, rx_wrt_ptr_reg,
 			q->write_actual);
 	}
 
diff --git a/drivers/net/wireless/iwlegacy/iwl-tx.c b/drivers/net/wireless/iwlegacy/iwl-tx.c
index 6b5e652..fa23c98 100644
--- a/drivers/net/wireless/iwlegacy/iwl-tx.c
+++ b/drivers/net/wireless/iwlegacy/iwl-tx.c
@@ -66,7 +66,7 @@ il_txq_update_write_ptr(struct il_priv *il, struct il_tx_queue *txq)
 			return;
 		}
 
-		il_write_direct32(il, HBUS_TARG_WRPTR,
+		il_wr(il, HBUS_TARG_WRPTR,
 				txq->q.write_ptr | (txq_id << 8));
 
 		/*
diff --git a/drivers/net/wireless/iwlegacy/iwl3945-base.c b/drivers/net/wireless/iwlegacy/iwl3945-base.c
index d45e9f5..a0b5a74 100644
--- a/drivers/net/wireless/iwlegacy/iwl3945-base.c
+++ b/drivers/net/wireless/iwlegacy/iwl3945-base.c
@@ -1520,7 +1520,7 @@ static void il3945_irq_tasklet(struct il_priv *il)
 		il->isr_stats.tx++;
 
 		_il_wr(il, CSR_FH_INT_STATUS, (1 << 6));
-		il_write_direct32(il, FH39_TCSR_CREDIT
+		il_wr(il, FH39_TCSR_CREDIT
 					(FH39_SRVC_CHNL), 0x0);
 		handled |= CSR_INT_BIT_FH_TX;
 	}
@@ -1698,7 +1698,7 @@ static int il3945_verify_inst_full(struct il_priv *il, __le32 *image, u32 len)
 
 	D_INFO("ucode inst image size is %u\n", len);
 
-	il_write_direct32(il, HBUS_TARG_MEM_RADDR,
+	il_wr(il, HBUS_TARG_MEM_RADDR,
 			       IWL39_RTC_INST_LOWER_BOUND);
 
 	errcnt = 0;
@@ -1745,7 +1745,7 @@ static int il3945_verify_inst_sparse(struct il_priv *il, __le32 *image, u32 len)
 		/* read data comes through single port, auto-incr addr */
 		/* NOTE: Use the debugless read so we don't flood kernel log
 		 * if IL_DL_IO is set */
-		il_write_direct32(il, HBUS_TARG_MEM_RADDR,
+		il_wr(il, HBUS_TARG_MEM_RADDR,
 			i + IWL39_RTC_INST_LOWER_BOUND);
 		val = _il_rd(il, HBUS_TARG_MEM_RDAT);
 		if (val != le32_to_cpu(*image)) {
diff --git a/drivers/net/wireless/iwlegacy/iwl4965-base.c b/drivers/net/wireless/iwlegacy/iwl4965-base.c
index f4eb037..b0668ea 100644
--- a/drivers/net/wireless/iwlegacy/iwl4965-base.c
+++ b/drivers/net/wireless/iwlegacy/iwl4965-base.c
@@ -416,7 +416,7 @@ int il4965_hw_tx_queue_init(struct il_priv *il,
 	int txq_id = txq->q.id;
 
 	/* Circular buffer (TFD queue in DRAM) physical base address */
-	il_write_direct32(il, FH_MEM_CBBC_QUEUE(txq_id),
+	il_wr(il, FH_MEM_CBBC_QUEUE(txq_id),
 			     txq->q.dma_addr >> 8);
 
 	return 0;
@@ -548,13 +548,13 @@ static void il4965_rx_card_state_notif(struct il_priv *il,
 		_il_wr(il, CSR_UCODE_DRV_GP1_SET,
 			    CSR_UCODE_DRV_GP1_BIT_CMD_BLOCKED);
 
-		il_write_direct32(il, HBUS_TARG_MBX_C,
+		il_wr(il, HBUS_TARG_MBX_C,
 					HBUS_TARG_MBX_C_REG_BIT_CMD_BLOCKED);
 
 		if (!(flags & RXON_CARD_DISABLED)) {
 			_il_wr(il, CSR_UCODE_DRV_GP1_CLR,
 				    CSR_UCODE_DRV_GP1_BIT_CMD_BLOCKED);
-			il_write_direct32(il, HBUS_TARG_MBX_C,
+			il_wr(il, HBUS_TARG_MBX_C,
 					HBUS_TARG_MBX_C_REG_BIT_CMD_BLOCKED);
 		}
 	}
@@ -1639,14 +1639,14 @@ static int il4965_alive_notify(struct il_priv *il)
 
 	/* Enable DMA channel */
 	for (chan = 0; chan < FH49_TCSR_CHNL_NUM ; chan++)
-		il_write_direct32(il,
+		il_wr(il,
 				FH_TCSR_CHNL_TX_CONFIG_REG(chan),
 				FH_TCSR_TX_CONFIG_REG_VAL_DMA_CHNL_ENABLE |
 				FH_TCSR_TX_CONFIG_REG_VAL_DMA_CREDIT_ENABLE);
 
 	/* Update FH chicken bits */
-	reg_val = il_read_direct32(il, FH_TX_CHICKEN_BITS_REG);
-	il_write_direct32(il, FH_TX_CHICKEN_BITS_REG,
+	reg_val = il_rd(il, FH_TX_CHICKEN_BITS_REG);
+	il_wr(il, FH_TX_CHICKEN_BITS_REG,
 			   reg_val | FH_TX_CHICKEN_BITS_SCD_AUTO_RETRY_EN);
 
 	/* Disable chain mode for all queues */
@@ -1657,7 +1657,7 @@ static int il4965_alive_notify(struct il_priv *il)
 
 		/* TFD circular buffer read/write indexes */
 		il_write_prph(il, IWL49_SCD_QUEUE_RDPTR(i), 0);
-		il_write_direct32(il, HBUS_TARG_WRPTR, 0 | (i << 8));
+		il_wr(il, HBUS_TARG_WRPTR, 0 | (i << 8));
 
 		/* Max Tx Window size for Scheduler-ACK mode */
 		il_write_targ_mem(il, il->scd_base_addr +
@@ -2731,7 +2731,7 @@ static void il4965_init_hw_rates(struct il_priv *il,
  */
 void il4965_set_wr_ptrs(struct il_priv *il, int txq_id, u32 index)
 {
-	il_write_direct32(il, HBUS_TARG_WRPTR,
+	il_wr(il, HBUS_TARG_WRPTR,
 			     (index & 0xff) | (txq_id << 8));
 	il_write_prph(il, IWL49_SCD_QUEUE_RDPTR(txq_id), index);
 }
-- 
1.7.1

