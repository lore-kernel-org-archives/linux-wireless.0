Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32802 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756930Ab1KRIXB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Nov 2011 03:23:01 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pAI8N0la022879
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-wireless@vger.kernel.org>; Fri, 18 Nov 2011 03:23:00 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 62/77] iwlegacy: use FH49_ prefix in 4965 code
Date: Fri, 18 Nov 2011 09:22:24 +0100
Message-Id: <1321604559-10707-62-git-send-email-sgruszka@redhat.com> (sfid-20111118_092310_559738_F2ACFF28)
In-Reply-To: <1321604559-10707-1-git-send-email-sgruszka@redhat.com>
References: <1321604559-10707-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/4965-mac.c |   96 +++++++-------
 drivers/net/wireless/iwlegacy/4965.c     |    2 +-
 drivers/net/wireless/iwlegacy/common.h   |    2 +-
 drivers/net/wireless/iwlegacy/iwl-fh.h   |  206 +++++++++++++++---------------
 4 files changed, 153 insertions(+), 153 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index 82b6a7b..9e3f74c 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -138,22 +138,22 @@ int il4965_rx_init(struct il_priv *il, struct il_rx_queue *rxq)
 	u32 rb_timeout = 0;
 
 	if (il->cfg->mod_params->amsdu_size_8K)
-		rb_size = FH_RCSR_RX_CONFIG_REG_VAL_RB_SIZE_8K;
+		rb_size = FH49_RCSR_RX_CONFIG_REG_VAL_RB_SIZE_8K;
 	else
-		rb_size = FH_RCSR_RX_CONFIG_REG_VAL_RB_SIZE_4K;
+		rb_size = FH49_RCSR_RX_CONFIG_REG_VAL_RB_SIZE_4K;
 
 	/* Stop Rx DMA */
-	il_wr(il, FH_MEM_RCSR_CHNL0_CONFIG_REG, 0);
+	il_wr(il, FH49_MEM_RCSR_CHNL0_CONFIG_REG, 0);
 
 	/* Reset driver's Rx queue write idx */
-	il_wr(il, FH_RSCSR_CHNL0_RBDCB_WPTR_REG, 0);
+	il_wr(il, FH49_RSCSR_CHNL0_RBDCB_WPTR_REG, 0);
 
 	/* Tell device where to find RBD circular buffer in DRAM */
-	il_wr(il, FH_RSCSR_CHNL0_RBDCB_BASE_REG,
+	il_wr(il, FH49_RSCSR_CHNL0_RBDCB_BASE_REG,
 			   (u32)(rxq->bd_dma >> 8));
 
 	/* Tell device where in DRAM to update its Rx status */
-	il_wr(il, FH_RSCSR_CHNL0_STTS_WPTR_REG,
+	il_wr(il, FH49_RSCSR_CHNL0_STTS_WPTR_REG,
 			   rxq->rb_stts_dma >> 4);
 
 	/* Enable Rx DMA
@@ -162,13 +162,13 @@ int il4965_rx_init(struct il_priv *il, struct il_rx_queue *rxq)
 	 * RB timeout 0x10
 	 * 256 RBDs
 	 */
-	il_wr(il, FH_MEM_RCSR_CHNL0_CONFIG_REG,
-			   FH_RCSR_RX_CONFIG_CHNL_EN_ENABLE_VAL |
-			   FH_RCSR_CHNL0_RX_CONFIG_IRQ_DEST_INT_HOST_VAL |
-			   FH_RCSR_CHNL0_RX_CONFIG_SINGLE_FRAME_MSK |
+	il_wr(il, FH49_MEM_RCSR_CHNL0_CONFIG_REG,
+			   FH49_RCSR_RX_CONFIG_CHNL_EN_ENABLE_VAL |
+			   FH49_RCSR_CHNL0_RX_CONFIG_IRQ_DEST_INT_HOST_VAL |
+			   FH49_RCSR_CHNL0_RX_CONFIG_SINGLE_FRAME_MSK |
 			   rb_size|
-			   (rb_timeout << FH_RCSR_RX_CONFIG_REG_IRQ_RBTH_POS)|
-			   (rfdnlog << FH_RCSR_RX_CONFIG_RBDCB_SIZE_POS));
+			   (rb_timeout << FH49_RCSR_RX_CONFIG_REG_IRQ_RBTH_POS)|
+			   (rfdnlog << FH49_RCSR_RX_CONFIG_RBDCB_SIZE_POS));
 
 	/* Set interrupt coalescing timer to default (2048 usecs) */
 	il_write8(il, CSR_INT_COALESCING, IL_HOST_INT_TIMEOUT_DEF);
@@ -443,9 +443,9 @@ int il4965_rxq_stop(struct il_priv *il)
 {
 
 	/* stop Rx DMA */
-	il_wr(il, FH_MEM_RCSR_CHNL0_CONFIG_REG, 0);
-	il_poll_bit(il, FH_MEM_RSSR_RX_STATUS_REG,
-			    FH_RSSR_CHNL0_RX_STATUS_CHNL_IDLE, 1000);
+	il_wr(il, FH49_MEM_RCSR_CHNL0_CONFIG_REG, 0);
+	il_poll_bit(il, FH49_MEM_RSSR_RX_STATUS_REG,
+			    FH49_RSSR_CHNL0_RX_STATUS_CHNL_IDLE, 1000);
 
 	return 0;
 }
@@ -1180,15 +1180,15 @@ u8 il4965_toggle_tx_ant(struct il_priv *il, u8 ant, u8 valid)
 static const char *il4965_get_fh_string(int cmd)
 {
 	switch (cmd) {
-	IL_CMD(FH_RSCSR_CHNL0_STTS_WPTR_REG);
-	IL_CMD(FH_RSCSR_CHNL0_RBDCB_BASE_REG);
-	IL_CMD(FH_RSCSR_CHNL0_WPTR);
-	IL_CMD(FH_MEM_RCSR_CHNL0_CONFIG_REG);
-	IL_CMD(FH_MEM_RSSR_SHARED_CTRL_REG);
-	IL_CMD(FH_MEM_RSSR_RX_STATUS_REG);
-	IL_CMD(FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV);
-	IL_CMD(FH_TSSR_TX_STATUS_REG);
-	IL_CMD(FH_TSSR_TX_ERROR_REG);
+	IL_CMD(FH49_RSCSR_CHNL0_STTS_WPTR_REG);
+	IL_CMD(FH49_RSCSR_CHNL0_RBDCB_BASE_REG);
+	IL_CMD(FH49_RSCSR_CHNL0_WPTR);
+	IL_CMD(FH49_MEM_RCSR_CHNL0_CONFIG_REG);
+	IL_CMD(FH49_MEM_RSSR_SHARED_CTRL_REG);
+	IL_CMD(FH49_MEM_RSSR_RX_STATUS_REG);
+	IL_CMD(FH49_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV);
+	IL_CMD(FH49_TSSR_TX_STATUS_REG);
+	IL_CMD(FH49_TSSR_TX_ERROR_REG);
 	default:
 		return "UNKNOWN";
 	}
@@ -1202,15 +1202,15 @@ int il4965_dump_fh(struct il_priv *il, char **buf, bool display)
 	size_t bufsz = 0;
 #endif
 	static const u32 fh_tbl[] = {
-		FH_RSCSR_CHNL0_STTS_WPTR_REG,
-		FH_RSCSR_CHNL0_RBDCB_BASE_REG,
-		FH_RSCSR_CHNL0_WPTR,
-		FH_MEM_RCSR_CHNL0_CONFIG_REG,
-		FH_MEM_RSSR_SHARED_CTRL_REG,
-		FH_MEM_RSSR_RX_STATUS_REG,
-		FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV,
-		FH_TSSR_TX_STATUS_REG,
-		FH_TSSR_TX_ERROR_REG
+		FH49_RSCSR_CHNL0_STTS_WPTR_REG,
+		FH49_RSCSR_CHNL0_RBDCB_BASE_REG,
+		FH49_RSCSR_CHNL0_WPTR,
+		FH49_MEM_RCSR_CHNL0_CONFIG_REG,
+		FH49_MEM_RSSR_SHARED_CTRL_REG,
+		FH49_MEM_RSSR_RX_STATUS_REG,
+		FH49_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV,
+		FH49_TSSR_TX_STATUS_REG,
+		FH49_TSSR_TX_ERROR_REG
 	};
 #ifdef CONFIG_IWLEGACY_DEBUG
 	if (display) {
@@ -2010,7 +2010,7 @@ int il4965_txq_ctx_alloc(struct il_priv *il)
 	il4965_txq_set_sched(il, 0);
 
 	/* Tell NIC where to find the "keep warm" buffer */
-	il_wr(il, FH_KW_MEM_ADDR_REG, il->kw.dma >> 4);
+	il_wr(il, FH49_KW_MEM_ADDR_REG, il->kw.dma >> 4);
 
 	spin_unlock_irqrestore(&il->lock, flags);
 
@@ -2049,7 +2049,7 @@ void il4965_txq_ctx_reset(struct il_priv *il)
 	il4965_txq_set_sched(il, 0);
 
 	/* Tell NIC where to find the "keep warm" buffer */
-	il_wr(il, FH_KW_MEM_ADDR_REG, il->kw.dma >> 4);
+	il_wr(il, FH49_KW_MEM_ADDR_REG, il->kw.dma >> 4);
 
 	spin_unlock_irqrestore(&il->lock, flags);
 
@@ -2078,14 +2078,14 @@ void il4965_txq_ctx_stop(struct il_priv *il)
 	/* Stop each Tx DMA channel, and wait for it to be idle */
 	for (ch = 0; ch < il->hw_params.dma_chnl_num; ch++) {
 		il_wr(il,
-				FH_TCSR_CHNL_TX_CONFIG_REG(ch), 0x0);
-		if (il_poll_bit(il, FH_TSSR_TX_STATUS_REG,
-				    FH_TSSR_TX_STATUS_REG_MSK_CHNL_IDLE(ch),
+				FH49_TCSR_CHNL_TX_CONFIG_REG(ch), 0x0);
+		if (il_poll_bit(il, FH49_TSSR_TX_STATUS_REG,
+				    FH49_TSSR_TX_STATUS_REG_MSK_CHNL_IDLE(ch),
 				    1000))
 			IL_ERR("Failing on timeout while stopping"
 			    " DMA channel %d [0x%08x]", ch,
 			    il_rd(il,
-					FH_TSSR_TX_STATUS_REG));
+					FH49_TSSR_TX_STATUS_REG));
 	}
 	spin_unlock_irqrestore(&il->lock, flags);
 
@@ -3743,7 +3743,7 @@ int il4965_hw_tx_queue_init(struct il_priv *il,
 	int txq_id = txq->q.id;
 
 	/* Circular buffer (TFD queue in DRAM) physical base address */
-	il_wr(il, FH_MEM_CBBC_QUEUE(txq_id),
+	il_wr(il, FH49_MEM_CBBC_QUEUE(txq_id),
 			     txq->q.dma_addr >> 8);
 
 	return 0;
@@ -4262,7 +4262,7 @@ static void il4965_irq_tasklet(struct il_priv *il)
 	if (inta & ~(il->inta_mask)) {
 		IL_WARN("Disabled INTA bits 0x%08x were pending\n",
 			 inta & ~il->inta_mask);
-		IL_WARN("   with FH_INT = 0x%08x\n", inta_fh);
+		IL_WARN("   with FH49_INT = 0x%08x\n", inta_fh);
 	}
 
 	/* Re-enable all interrupts */
@@ -4798,7 +4798,7 @@ static const char * const desc_lookup_text[] = {
 	"HW_ERROR_TEMPERATURE",
 	"ILLEGAL_CHAN_FREQ",
 	"VCC_NOT_STBL",
-	"FH_ERROR",
+	"FH49_ERROR",
 	"NMI_INTERRUPT_HOST",
 	"NMI_INTERRUPT_ACTION_PT",
 	"NMI_INTERRUPT_UNKNOWN",
@@ -4969,14 +4969,14 @@ static int il4965_alive_notify(struct il_priv *il)
 	/* Enable DMA channel */
 	for (chan = 0; chan < FH49_TCSR_CHNL_NUM ; chan++)
 		il_wr(il,
-				FH_TCSR_CHNL_TX_CONFIG_REG(chan),
-				FH_TCSR_TX_CONFIG_REG_VAL_DMA_CHNL_ENABLE |
-				FH_TCSR_TX_CONFIG_REG_VAL_DMA_CREDIT_ENABLE);
+				FH49_TCSR_CHNL_TX_CONFIG_REG(chan),
+				FH49_TCSR_TX_CONFIG_REG_VAL_DMA_CHNL_ENABLE |
+				FH49_TCSR_TX_CONFIG_REG_VAL_DMA_CREDIT_ENABLE);
 
 	/* Update FH chicken bits */
-	reg_val = il_rd(il, FH_TX_CHICKEN_BITS_REG);
-	il_wr(il, FH_TX_CHICKEN_BITS_REG,
-			   reg_val | FH_TX_CHICKEN_BITS_SCD_AUTO_RETRY_EN);
+	reg_val = il_rd(il, FH49_TX_CHICKEN_BITS_REG);
+	il_wr(il, FH49_TX_CHICKEN_BITS_REG,
+			   reg_val | FH49_TX_CHICKEN_BITS_SCD_AUTO_RETRY_EN);
 
 	/* Disable chain mode for all queues */
 	il_wr_prph(il, IL49_SCD_QUEUECHAIN_SEL, 0);
diff --git a/drivers/net/wireless/iwlegacy/4965.c b/drivers/net/wireless/iwlegacy/4965.c
index 4b97717..cbbb2c0 100644
--- a/drivers/net/wireless/iwlegacy/4965.c
+++ b/drivers/net/wireless/iwlegacy/4965.c
@@ -630,7 +630,7 @@ static int il4965_hw_set_hw_params(struct il_priv *il)
 	il->hw_params.max_bsm_size = BSM_SRAM_SIZE;
 	il->hw_params.ht40_channel = BIT(IEEE80211_BAND_5GHZ);
 
-	il->hw_params.rx_wrt_ptr_reg = FH_RSCSR_CHNL0_WPTR;
+	il->hw_params.rx_wrt_ptr_reg = FH49_RSCSR_CHNL0_WPTR;
 
 	il->hw_params.tx_chains_num = il4965_num_of_ant(il->cfg->valid_tx_ant);
 	il->hw_params.rx_chains_num = il4965_num_of_ant(il->cfg->valid_rx_ant);
diff --git a/drivers/net/wireless/iwlegacy/common.h b/drivers/net/wireless/iwlegacy/common.h
index 8ae4e3f..be057aa 100644
--- a/drivers/net/wireless/iwlegacy/common.h
+++ b/drivers/net/wireless/iwlegacy/common.h
@@ -2835,7 +2835,7 @@ struct il_tfd_tb {
  * contiguous 256 TFDs x 128 bytes-per-TFD = 32 KBytes
  *
  * Driver must indicate the physical address of the base of each
- * circular buffer via the FH_MEM_CBBC_QUEUE registers.
+ * circular buffer via the FH49_MEM_CBBC_QUEUE registers.
  *
  * Each TFD contains pointer/size information for up to 20 data buffers
  * in host DRAM.  These buffers collectively contain the (one) frame described
diff --git a/drivers/net/wireless/iwlegacy/iwl-fh.h b/drivers/net/wireless/iwlegacy/iwl-fh.h
index 7846bae..ac7c212 100644
--- a/drivers/net/wireless/iwlegacy/iwl-fh.h
+++ b/drivers/net/wireless/iwlegacy/iwl-fh.h
@@ -71,8 +71,8 @@
  * This I/O area is directly read/writable by driver (e.g. Linux uses writel())
  * Addresses are offsets from device's PCI hardware base address.
  */
-#define FH_MEM_LOWER_BOUND                   (0x1000)
-#define FH_MEM_UPPER_BOUND                   (0x2000)
+#define FH49_MEM_LOWER_BOUND                   (0x1000)
+#define FH49_MEM_UPPER_BOUND                   (0x2000)
 
 /**
  * Keep-Warm (KW) buffer base address.
@@ -83,7 +83,7 @@
  * from going into a power-savings mode that would cause higher DRAM latency,
  * and possible data over/under-runs, before all Tx/Rx is complete.
  *
- * Driver loads FH_KW_MEM_ADDR_REG with the physical address (bits 35:4)
+ * Driver loads FH49_KW_MEM_ADDR_REG with the physical address (bits 35:4)
  * of the buffer, which must be 4K aligned.  Once this is set up, the 4965
  * automatically invokes keep-warm accesses when normal accesses might not
  * be sufficient to maintain fast DRAM response.
@@ -91,7 +91,7 @@
  * Bit fields:
  *  31-0:  Keep-warm buffer physical base address [35:4], must be 4K aligned
  */
-#define FH_KW_MEM_ADDR_REG		     (FH_MEM_LOWER_BOUND + 0x97C)
+#define FH49_KW_MEM_ADDR_REG		     (FH49_MEM_LOWER_BOUND + 0x97C)
 
 
 /**
@@ -106,11 +106,11 @@
  * Bit fields in each pointer register:
  *  27-0: TFD CB physical base address [35:8], must be 256-byte aligned
  */
-#define FH_MEM_CBBC_LOWER_BOUND          (FH_MEM_LOWER_BOUND + 0x9D0)
-#define FH_MEM_CBBC_UPPER_BOUND          (FH_MEM_LOWER_BOUND + 0xA10)
+#define FH49_MEM_CBBC_LOWER_BOUND          (FH49_MEM_LOWER_BOUND + 0x9D0)
+#define FH49_MEM_CBBC_UPPER_BOUND          (FH49_MEM_LOWER_BOUND + 0xA10)
 
 /* Find TFD CB base pointer for given queue (range 0-15). */
-#define FH_MEM_CBBC_QUEUE(x)  (FH_MEM_CBBC_LOWER_BOUND + (x) * 0x4)
+#define FH49_MEM_CBBC_QUEUE(x)  (FH49_MEM_CBBC_LOWER_BOUND + (x) * 0x4)
 
 
 /**
@@ -132,18 +132,18 @@
  *     Each entry (1 dword) points to a receive buffer (RB) of consistent size
  *     (typically 4K, although 8K or 16K are also selectable by driver).
  *     Driver sets up RB size and number of RBDs in the CB via Rx config
- *     register FH_MEM_RCSR_CHNL0_CONFIG_REG.
+ *     register FH49_MEM_RCSR_CHNL0_CONFIG_REG.
  *
  *     Bit fields within one RBD:
  *     27-0:  Receive Buffer physical address bits [35:8], 256-byte aligned
  *
  *     Driver sets physical address [35:8] of base of RBD circular buffer
- *     into FH_RSCSR_CHNL0_RBDCB_BASE_REG [27:0].
+ *     into FH49_RSCSR_CHNL0_RBDCB_BASE_REG [27:0].
  *
  * 2)  Rx status buffer, 8 bytes, in which 4965 indicates which Rx Buffers
  *     (RBs) have been filled, via a "write pointer", actually the idx of
  *     the RB's corresponding RBD within the circular buffer.  Driver sets
- *     physical address [35:4] into FH_RSCSR_CHNL0_STTS_WPTR_REG [31:0].
+ *     physical address [35:4] into FH49_RSCSR_CHNL0_STTS_WPTR_REG [31:0].
  *
  *     Bit fields in lower dword of Rx status buffer (upper dword not used
  *     by driver; see struct il4965_shared, val0):
@@ -154,7 +154,7 @@
  * As the driver prepares Receive Buffers (RBs) for 4965 to fill, driver must
  * enter pointers to these RBs into contiguous RBD circular buffer entries,
  * and update the 4965's "write" idx register,
- * FH_RSCSR_CHNL0_RBDCB_WPTR_REG.
+ * FH49_RSCSR_CHNL0_RBDCB_WPTR_REG.
  *
  * This "write" idx corresponds to the *next* RBD that the driver will make
  * available, i.e. one RBD past the tail of the ready-to-fill RBDs within
@@ -182,23 +182,23 @@
  * and "read" idxes; that is, make sure that there are no more than 254
  * buffers waiting to be filled.
  */
-#define FH_MEM_RSCSR_LOWER_BOUND	(FH_MEM_LOWER_BOUND + 0xBC0)
-#define FH_MEM_RSCSR_UPPER_BOUND	(FH_MEM_LOWER_BOUND + 0xC00)
-#define FH_MEM_RSCSR_CHNL0		(FH_MEM_RSCSR_LOWER_BOUND)
+#define FH49_MEM_RSCSR_LOWER_BOUND	(FH49_MEM_LOWER_BOUND + 0xBC0)
+#define FH49_MEM_RSCSR_UPPER_BOUND	(FH49_MEM_LOWER_BOUND + 0xC00)
+#define FH49_MEM_RSCSR_CHNL0		(FH49_MEM_RSCSR_LOWER_BOUND)
 
 /**
  * Physical base address of 8-byte Rx Status buffer.
  * Bit fields:
  *  31-0: Rx status buffer physical base address [35:4], must 16-byte aligned.
  */
-#define FH_RSCSR_CHNL0_STTS_WPTR_REG	(FH_MEM_RSCSR_CHNL0)
+#define FH49_RSCSR_CHNL0_STTS_WPTR_REG	(FH49_MEM_RSCSR_CHNL0)
 
 /**
  * Physical base address of Rx Buffer Descriptor Circular Buffer.
  * Bit fields:
  *  27-0:  RBD CD physical base address [35:8], must be 256-byte aligned.
  */
-#define FH_RSCSR_CHNL0_RBDCB_BASE_REG	(FH_MEM_RSCSR_CHNL0 + 0x004)
+#define FH49_RSCSR_CHNL0_RBDCB_BASE_REG	(FH49_MEM_RSCSR_CHNL0 + 0x004)
 
 /**
  * Rx write pointer (idx, really!).
@@ -206,20 +206,20 @@
  *  11-0:  Index of driver's most recent prepared-to-be-filled RBD, + 1.
  *         NOTE:  For 256-entry circular buffer, use only bits [7:0].
  */
-#define FH_RSCSR_CHNL0_RBDCB_WPTR_REG	(FH_MEM_RSCSR_CHNL0 + 0x008)
-#define FH_RSCSR_CHNL0_WPTR        (FH_RSCSR_CHNL0_RBDCB_WPTR_REG)
+#define FH49_RSCSR_CHNL0_RBDCB_WPTR_REG	(FH49_MEM_RSCSR_CHNL0 + 0x008)
+#define FH49_RSCSR_CHNL0_WPTR        (FH49_RSCSR_CHNL0_RBDCB_WPTR_REG)
 
 
 /**
  * Rx Config/Status Registers (RCSR)
  * Rx Config Reg for channel 0 (only channel used)
  *
- * Driver must initialize FH_MEM_RCSR_CHNL0_CONFIG_REG as follows for
+ * Driver must initialize FH49_MEM_RCSR_CHNL0_CONFIG_REG as follows for
  * normal operation (see bit fields).
  *
- * Clearing FH_MEM_RCSR_CHNL0_CONFIG_REG to 0 turns off Rx DMA.
- * Driver should poll FH_MEM_RSSR_RX_STATUS_REG	for
- * FH_RSSR_CHNL0_RX_STATUS_CHNL_IDLE (bit 24) before continuing.
+ * Clearing FH49_MEM_RCSR_CHNL0_CONFIG_REG to 0 turns off Rx DMA.
+ * Driver should poll FH49_MEM_RSSR_RX_STATUS_REG	for
+ * FH49_RSSR_CHNL0_RX_STATUS_CHNL_IDLE (bit 24) before continuing.
  *
  * Bit fields:
  * 31-30: Rx DMA channel enable: '00' off/pause, '01' pause at end of frame,
@@ -236,67 +236,67 @@
  *        typical value 0x10 (about 1/2 msec)
  *  3- 0: reserved
  */
-#define FH_MEM_RCSR_LOWER_BOUND      (FH_MEM_LOWER_BOUND + 0xC00)
-#define FH_MEM_RCSR_UPPER_BOUND      (FH_MEM_LOWER_BOUND + 0xCC0)
-#define FH_MEM_RCSR_CHNL0            (FH_MEM_RCSR_LOWER_BOUND)
+#define FH49_MEM_RCSR_LOWER_BOUND      (FH49_MEM_LOWER_BOUND + 0xC00)
+#define FH49_MEM_RCSR_UPPER_BOUND      (FH49_MEM_LOWER_BOUND + 0xCC0)
+#define FH49_MEM_RCSR_CHNL0            (FH49_MEM_RCSR_LOWER_BOUND)
 
-#define FH_MEM_RCSR_CHNL0_CONFIG_REG	(FH_MEM_RCSR_CHNL0)
+#define FH49_MEM_RCSR_CHNL0_CONFIG_REG	(FH49_MEM_RCSR_CHNL0)
 
-#define FH_RCSR_CHNL0_RX_CONFIG_RB_TIMEOUT_MSK (0x00000FF0) /* bits 4-11 */
-#define FH_RCSR_CHNL0_RX_CONFIG_IRQ_DEST_MSK   (0x00001000) /* bits 12 */
-#define FH_RCSR_CHNL0_RX_CONFIG_SINGLE_FRAME_MSK (0x00008000) /* bit 15 */
-#define FH_RCSR_CHNL0_RX_CONFIG_RB_SIZE_MSK   (0x00030000) /* bits 16-17 */
-#define FH_RCSR_CHNL0_RX_CONFIG_RBDBC_SIZE_MSK (0x00F00000) /* bits 20-23 */
-#define FH_RCSR_CHNL0_RX_CONFIG_DMA_CHNL_EN_MSK (0xC0000000) /* bits 30-31*/
+#define FH49_RCSR_CHNL0_RX_CONFIG_RB_TIMEOUT_MSK (0x00000FF0) /* bits 4-11 */
+#define FH49_RCSR_CHNL0_RX_CONFIG_IRQ_DEST_MSK   (0x00001000) /* bits 12 */
+#define FH49_RCSR_CHNL0_RX_CONFIG_SINGLE_FRAME_MSK (0x00008000) /* bit 15 */
+#define FH49_RCSR_CHNL0_RX_CONFIG_RB_SIZE_MSK   (0x00030000) /* bits 16-17 */
+#define FH49_RCSR_CHNL0_RX_CONFIG_RBDBC_SIZE_MSK (0x00F00000) /* bits 20-23 */
+#define FH49_RCSR_CHNL0_RX_CONFIG_DMA_CHNL_EN_MSK (0xC0000000) /* bits 30-31*/
 
-#define FH_RCSR_RX_CONFIG_RBDCB_SIZE_POS	(20)
-#define FH_RCSR_RX_CONFIG_REG_IRQ_RBTH_POS	(4)
+#define FH49_RCSR_RX_CONFIG_RBDCB_SIZE_POS	(20)
+#define FH49_RCSR_RX_CONFIG_REG_IRQ_RBTH_POS	(4)
 #define RX_RB_TIMEOUT	(0x10)
 
-#define FH_RCSR_RX_CONFIG_CHNL_EN_PAUSE_VAL         (0x00000000)
-#define FH_RCSR_RX_CONFIG_CHNL_EN_PAUSE_EOF_VAL     (0x40000000)
-#define FH_RCSR_RX_CONFIG_CHNL_EN_ENABLE_VAL        (0x80000000)
+#define FH49_RCSR_RX_CONFIG_CHNL_EN_PAUSE_VAL         (0x00000000)
+#define FH49_RCSR_RX_CONFIG_CHNL_EN_PAUSE_EOF_VAL     (0x40000000)
+#define FH49_RCSR_RX_CONFIG_CHNL_EN_ENABLE_VAL        (0x80000000)
 
-#define FH_RCSR_RX_CONFIG_REG_VAL_RB_SIZE_4K    (0x00000000)
-#define FH_RCSR_RX_CONFIG_REG_VAL_RB_SIZE_8K    (0x00010000)
-#define FH_RCSR_RX_CONFIG_REG_VAL_RB_SIZE_12K   (0x00020000)
-#define FH_RCSR_RX_CONFIG_REG_VAL_RB_SIZE_16K   (0x00030000)
+#define FH49_RCSR_RX_CONFIG_REG_VAL_RB_SIZE_4K    (0x00000000)
+#define FH49_RCSR_RX_CONFIG_REG_VAL_RB_SIZE_8K    (0x00010000)
+#define FH49_RCSR_RX_CONFIG_REG_VAL_RB_SIZE_12K   (0x00020000)
+#define FH49_RCSR_RX_CONFIG_REG_VAL_RB_SIZE_16K   (0x00030000)
 
-#define FH_RCSR_CHNL0_RX_IGNORE_RXF_EMPTY              (0x00000004)
-#define FH_RCSR_CHNL0_RX_CONFIG_IRQ_DEST_NO_INT_VAL    (0x00000000)
-#define FH_RCSR_CHNL0_RX_CONFIG_IRQ_DEST_INT_HOST_VAL  (0x00001000)
+#define FH49_RCSR_CHNL0_RX_IGNORE_RXF_EMPTY              (0x00000004)
+#define FH49_RCSR_CHNL0_RX_CONFIG_IRQ_DEST_NO_INT_VAL    (0x00000000)
+#define FH49_RCSR_CHNL0_RX_CONFIG_IRQ_DEST_INT_HOST_VAL  (0x00001000)
 
 /**
  * Rx Shared Status Registers (RSSR)
  *
  * After stopping Rx DMA channel (writing 0 to
- * FH_MEM_RCSR_CHNL0_CONFIG_REG), driver must poll
- * FH_MEM_RSSR_RX_STATUS_REG until Rx channel is idle.
+ * FH49_MEM_RCSR_CHNL0_CONFIG_REG), driver must poll
+ * FH49_MEM_RSSR_RX_STATUS_REG until Rx channel is idle.
  *
  * Bit fields:
  *  24:  1 = Channel 0 is idle
  *
- * FH_MEM_RSSR_SHARED_CTRL_REG and FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV
+ * FH49_MEM_RSSR_SHARED_CTRL_REG and FH49_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV
  * contain default values that should not be altered by the driver.
  */
-#define FH_MEM_RSSR_LOWER_BOUND           (FH_MEM_LOWER_BOUND + 0xC40)
-#define FH_MEM_RSSR_UPPER_BOUND           (FH_MEM_LOWER_BOUND + 0xD00)
+#define FH49_MEM_RSSR_LOWER_BOUND           (FH49_MEM_LOWER_BOUND + 0xC40)
+#define FH49_MEM_RSSR_UPPER_BOUND           (FH49_MEM_LOWER_BOUND + 0xD00)
 
-#define FH_MEM_RSSR_SHARED_CTRL_REG       (FH_MEM_RSSR_LOWER_BOUND)
-#define FH_MEM_RSSR_RX_STATUS_REG	(FH_MEM_RSSR_LOWER_BOUND + 0x004)
-#define FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV\
-					(FH_MEM_RSSR_LOWER_BOUND + 0x008)
+#define FH49_MEM_RSSR_SHARED_CTRL_REG       (FH49_MEM_RSSR_LOWER_BOUND)
+#define FH49_MEM_RSSR_RX_STATUS_REG	(FH49_MEM_RSSR_LOWER_BOUND + 0x004)
+#define FH49_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV\
+					(FH49_MEM_RSSR_LOWER_BOUND + 0x008)
 
-#define FH_RSSR_CHNL0_RX_STATUS_CHNL_IDLE	(0x01000000)
+#define FH49_RSSR_CHNL0_RX_STATUS_CHNL_IDLE	(0x01000000)
 
-#define FH_MEM_TFDIB_REG1_ADDR_BITSHIFT	28
+#define FH49_MEM_TFDIB_REG1_ADDR_BITSHIFT	28
 
 /* TFDB  Area - TFDs buffer table */
-#define FH_MEM_TFDIB_DRAM_ADDR_LSB_MSK      (0xFFFFFFFF)
-#define FH_TFDIB_LOWER_BOUND       (FH_MEM_LOWER_BOUND + 0x900)
-#define FH_TFDIB_UPPER_BOUND       (FH_MEM_LOWER_BOUND + 0x958)
-#define FH_TFDIB_CTRL0_REG(_chnl)  (FH_TFDIB_LOWER_BOUND + 0x8 * (_chnl))
-#define FH_TFDIB_CTRL1_REG(_chnl)  (FH_TFDIB_LOWER_BOUND + 0x8 * (_chnl) + 0x4)
+#define FH49_MEM_TFDIB_DRAM_ADDR_LSB_MSK      (0xFFFFFFFF)
+#define FH49_TFDIB_LOWER_BOUND       (FH49_MEM_LOWER_BOUND + 0x900)
+#define FH49_TFDIB_UPPER_BOUND       (FH49_MEM_LOWER_BOUND + 0x958)
+#define FH49_TFDIB_CTRL0_REG(_chnl)  (FH49_TFDIB_LOWER_BOUND + 0x8 * (_chnl))
+#define FH49_TFDIB_CTRL1_REG(_chnl)  (FH49_TFDIB_LOWER_BOUND + 0x8 * (_chnl) + 0x4)
 
 /**
  * Transmit DMA Channel Control/Status Registers (TCSR)
@@ -306,10 +306,10 @@
  * which feed the DMA/FIFO channels); config regs are separated by 0x20 bytes.
  *
  * To use a Tx DMA channel, driver must initialize its
- * FH_TCSR_CHNL_TX_CONFIG_REG(chnl) with:
+ * FH49_TCSR_CHNL_TX_CONFIG_REG(chnl) with:
  *
- * FH_TCSR_TX_CONFIG_REG_VAL_DMA_CHNL_ENABLE |
- * FH_TCSR_TX_CONFIG_REG_VAL_DMA_CREDIT_ENABLE_VAL
+ * FH49_TCSR_TX_CONFIG_REG_VAL_DMA_CHNL_ENABLE |
+ * FH49_TCSR_TX_CONFIG_REG_VAL_DMA_CREDIT_ENABLE_VAL
  *
  * All other bits should be 0.
  *
@@ -320,62 +320,62 @@
  *     3: Enable internal DMA requests (1, normal operation), disable (0)
  *  2- 0: Reserved, set to "0"
  */
-#define FH_TCSR_LOWER_BOUND  (FH_MEM_LOWER_BOUND + 0xD00)
-#define FH_TCSR_UPPER_BOUND  (FH_MEM_LOWER_BOUND + 0xE60)
+#define FH49_TCSR_LOWER_BOUND  (FH49_MEM_LOWER_BOUND + 0xD00)
+#define FH49_TCSR_UPPER_BOUND  (FH49_MEM_LOWER_BOUND + 0xE60)
 
 /* Find Control/Status reg for given Tx DMA/FIFO channel */
 #define FH49_TCSR_CHNL_NUM                            (7)
 #define FH50_TCSR_CHNL_NUM                            (8)
 
 /* TCSR: tx_config register values */
-#define FH_TCSR_CHNL_TX_CONFIG_REG(_chnl)	\
-		(FH_TCSR_LOWER_BOUND + 0x20 * (_chnl))
-#define FH_TCSR_CHNL_TX_CREDIT_REG(_chnl)	\
-		(FH_TCSR_LOWER_BOUND + 0x20 * (_chnl) + 0x4)
-#define FH_TCSR_CHNL_TX_BUF_STS_REG(_chnl)	\
-		(FH_TCSR_LOWER_BOUND + 0x20 * (_chnl) + 0x8)
+#define FH49_TCSR_CHNL_TX_CONFIG_REG(_chnl)	\
+		(FH49_TCSR_LOWER_BOUND + 0x20 * (_chnl))
+#define FH49_TCSR_CHNL_TX_CREDIT_REG(_chnl)	\
+		(FH49_TCSR_LOWER_BOUND + 0x20 * (_chnl) + 0x4)
+#define FH49_TCSR_CHNL_TX_BUF_STS_REG(_chnl)	\
+		(FH49_TCSR_LOWER_BOUND + 0x20 * (_chnl) + 0x8)
 
-#define FH_TCSR_TX_CONFIG_REG_VAL_MSG_MODE_TXF		(0x00000000)
-#define FH_TCSR_TX_CONFIG_REG_VAL_MSG_MODE_DRV		(0x00000001)
+#define FH49_TCSR_TX_CONFIG_REG_VAL_MSG_MODE_TXF		(0x00000000)
+#define FH49_TCSR_TX_CONFIG_REG_VAL_MSG_MODE_DRV		(0x00000001)
 
-#define FH_TCSR_TX_CONFIG_REG_VAL_DMA_CREDIT_DISABLE	(0x00000000)
-#define FH_TCSR_TX_CONFIG_REG_VAL_DMA_CREDIT_ENABLE	(0x00000008)
+#define FH49_TCSR_TX_CONFIG_REG_VAL_DMA_CREDIT_DISABLE	(0x00000000)
+#define FH49_TCSR_TX_CONFIG_REG_VAL_DMA_CREDIT_ENABLE	(0x00000008)
 
-#define FH_TCSR_TX_CONFIG_REG_VAL_CIRQ_HOST_NOINT	(0x00000000)
-#define FH_TCSR_TX_CONFIG_REG_VAL_CIRQ_HOST_ENDTFD	(0x00100000)
-#define FH_TCSR_TX_CONFIG_REG_VAL_CIRQ_HOST_IFTFD	(0x00200000)
+#define FH49_TCSR_TX_CONFIG_REG_VAL_CIRQ_HOST_NOINT	(0x00000000)
+#define FH49_TCSR_TX_CONFIG_REG_VAL_CIRQ_HOST_ENDTFD	(0x00100000)
+#define FH49_TCSR_TX_CONFIG_REG_VAL_CIRQ_HOST_IFTFD	(0x00200000)
 
-#define FH_TCSR_TX_CONFIG_REG_VAL_CIRQ_RTC_NOINT	(0x00000000)
-#define FH_TCSR_TX_CONFIG_REG_VAL_CIRQ_RTC_ENDTFD	(0x00400000)
-#define FH_TCSR_TX_CONFIG_REG_VAL_CIRQ_RTC_IFTFD	(0x00800000)
+#define FH49_TCSR_TX_CONFIG_REG_VAL_CIRQ_RTC_NOINT	(0x00000000)
+#define FH49_TCSR_TX_CONFIG_REG_VAL_CIRQ_RTC_ENDTFD	(0x00400000)
+#define FH49_TCSR_TX_CONFIG_REG_VAL_CIRQ_RTC_IFTFD	(0x00800000)
 
-#define FH_TCSR_TX_CONFIG_REG_VAL_DMA_CHNL_PAUSE	(0x00000000)
-#define FH_TCSR_TX_CONFIG_REG_VAL_DMA_CHNL_PAUSE_EOF	(0x40000000)
-#define FH_TCSR_TX_CONFIG_REG_VAL_DMA_CHNL_ENABLE	(0x80000000)
+#define FH49_TCSR_TX_CONFIG_REG_VAL_DMA_CHNL_PAUSE	(0x00000000)
+#define FH49_TCSR_TX_CONFIG_REG_VAL_DMA_CHNL_PAUSE_EOF	(0x40000000)
+#define FH49_TCSR_TX_CONFIG_REG_VAL_DMA_CHNL_ENABLE	(0x80000000)
 
-#define FH_TCSR_CHNL_TX_BUF_STS_REG_VAL_TFDB_EMPTY	(0x00000000)
-#define FH_TCSR_CHNL_TX_BUF_STS_REG_VAL_TFDB_WAIT	(0x00002000)
-#define FH_TCSR_CHNL_TX_BUF_STS_REG_VAL_TFDB_VALID	(0x00000003)
+#define FH49_TCSR_CHNL_TX_BUF_STS_REG_VAL_TFDB_EMPTY	(0x00000000)
+#define FH49_TCSR_CHNL_TX_BUF_STS_REG_VAL_TFDB_WAIT	(0x00002000)
+#define FH49_TCSR_CHNL_TX_BUF_STS_REG_VAL_TFDB_VALID	(0x00000003)
 
-#define FH_TCSR_CHNL_TX_BUF_STS_REG_POS_TB_NUM		(20)
-#define FH_TCSR_CHNL_TX_BUF_STS_REG_POS_TB_IDX		(12)
+#define FH49_TCSR_CHNL_TX_BUF_STS_REG_POS_TB_NUM		(20)
+#define FH49_TCSR_CHNL_TX_BUF_STS_REG_POS_TB_IDX		(12)
 
 /**
  * Tx Shared Status Registers (TSSR)
  *
  * After stopping Tx DMA channel (writing 0 to
- * FH_TCSR_CHNL_TX_CONFIG_REG(chnl)), driver must poll
- * FH_TSSR_TX_STATUS_REG until selected Tx channel is idle
+ * FH49_TCSR_CHNL_TX_CONFIG_REG(chnl)), driver must poll
+ * FH49_TSSR_TX_STATUS_REG until selected Tx channel is idle
  * (channel's buffers empty | no pending requests).
  *
  * Bit fields:
  * 31-24:  1 = Channel buffers empty (channel 7:0)
  * 23-16:  1 = No pending requests (channel 7:0)
  */
-#define FH_TSSR_LOWER_BOUND		(FH_MEM_LOWER_BOUND + 0xEA0)
-#define FH_TSSR_UPPER_BOUND		(FH_MEM_LOWER_BOUND + 0xEC0)
+#define FH49_TSSR_LOWER_BOUND		(FH49_MEM_LOWER_BOUND + 0xEA0)
+#define FH49_TSSR_UPPER_BOUND		(FH49_MEM_LOWER_BOUND + 0xEC0)
 
-#define FH_TSSR_TX_STATUS_REG		(FH_TSSR_LOWER_BOUND + 0x010)
+#define FH49_TSSR_TX_STATUS_REG		(FH49_TSSR_LOWER_BOUND + 0x010)
 
 /**
  * Bit fields for TSSR(Tx Shared Status & Control) error status register:
@@ -394,22 +394,22 @@
  *	synchronized to the TxFIFO status
  *	uCode/driver must write "1" in order to clear this flag
  */
-#define FH_TSSR_TX_ERROR_REG		(FH_TSSR_LOWER_BOUND + 0x018)
+#define FH49_TSSR_TX_ERROR_REG		(FH49_TSSR_LOWER_BOUND + 0x018)
 
-#define FH_TSSR_TX_STATUS_REG_MSK_CHNL_IDLE(_chnl) ((1 << (_chnl)) << 16)
+#define FH49_TSSR_TX_STATUS_REG_MSK_CHNL_IDLE(_chnl) ((1 << (_chnl)) << 16)
 
 /* Tx service channels */
-#define FH_SRVC_CHNL		(9)
-#define FH_SRVC_LOWER_BOUND	(FH_MEM_LOWER_BOUND + 0x9C8)
-#define FH_SRVC_UPPER_BOUND	(FH_MEM_LOWER_BOUND + 0x9D0)
-#define FH_SRVC_CHNL_SRAM_ADDR_REG(_chnl) \
-		(FH_SRVC_LOWER_BOUND + ((_chnl) - 9) * 0x4)
+#define FH49_SRVC_CHNL		(9)
+#define FH49_SRVC_LOWER_BOUND	(FH49_MEM_LOWER_BOUND + 0x9C8)
+#define FH49_SRVC_UPPER_BOUND	(FH49_MEM_LOWER_BOUND + 0x9D0)
+#define FH49_SRVC_CHNL_SRAM_ADDR_REG(_chnl) \
+		(FH49_SRVC_LOWER_BOUND + ((_chnl) - 9) * 0x4)
 
-#define FH_TX_CHICKEN_BITS_REG	(FH_MEM_LOWER_BOUND + 0xE98)
+#define FH49_TX_CHICKEN_BITS_REG	(FH49_MEM_LOWER_BOUND + 0xE98)
 /* Instruct FH to increment the retry count of a packet when
  * it is brought from the memory to TX-FIFO
  */
-#define FH_TX_CHICKEN_BITS_SCD_AUTO_RETRY_EN	(0x00000002)
+#define FH49_TX_CHICKEN_BITS_SCD_AUTO_RETRY_EN	(0x00000002)
 
 /* Keep Warm Size */
 #define IL_KW_SIZE 0x1000	/* 4k */
-- 
1.7.1

