Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:56766 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753349AbYDXAPP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Apr 2008 20:15:15 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 12/16] iwlwifi: clean up register names and defines
Date: Wed, 23 Apr 2008 17:15:04 -0700
Message-Id: <1208996108-15326-13-git-send-email-reinette.chatre@intel.com> (sfid-20080424_023546_332731_1B1DF494)
In-Reply-To: <1208996108-15326-12-git-send-email-reinette.chatre@intel.com>
References: <1208996108-15326-1-git-send-email-reinette.chatre@intel.com>
 <1208996108-15326-2-git-send-email-reinette.chatre@intel.com>
 <1208996108-15326-3-git-send-email-reinette.chatre@intel.com>
 <1208996108-15326-4-git-send-email-reinette.chatre@intel.com>
 <1208996108-15326-5-git-send-email-reinette.chatre@intel.com>
 <1208996108-15326-6-git-send-email-reinette.chatre@intel.com>
 <1208996108-15326-7-git-send-email-reinette.chatre@intel.com>
 <1208996108-15326-8-git-send-email-reinette.chatre@intel.com>
 <1208996108-15326-9-git-send-email-reinette.chatre@intel.com>
 <1208996108-15326-10-git-send-email-reinette.chatre@intel.com>
 <1208996108-15326-11-git-send-email-reinette.chatre@intel.com>
 <1208996108-15326-12-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This patch cleans up and renames some of the SCD registers.
 It move SCD definitions into iwl-prhp.h file

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965-hw.h |  298 +--------------------------
 drivers/net/wireless/iwlwifi/iwl-4965.c    |   66 +++---
 drivers/net/wireless/iwlwifi/iwl-prph.h    |  310 +++++++++++++++++++++++++---
 3 files changed, 320 insertions(+), 354 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-hw.h b/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
index 4f45093..3862704 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
@@ -1072,286 +1072,6 @@ enum {
 	(IWL_FH_TSSR_TX_STATUS_REG_BIT_BUFS_EMPTY(_chnl) | \
 	IWL_FH_TSSR_TX_STATUS_REG_BIT_NO_PEND_REQ(_chnl))
 
-
-/********************* START TX SCHEDULER *************************************/
-
-/**
- * 4965 Tx Scheduler
- *
- * The Tx Scheduler selects the next frame to be transmitted, chosing TFDs
- * (Transmit Frame Descriptors) from up to 16 circular Tx queues resident in
- * host DRAM.  It steers each frame's Tx command (which contains the frame
- * data) into one of up to 7 prioritized Tx DMA FIFO channels within the
- * device.  A queue maps to only one (selectable by driver) Tx DMA channel,
- * but one DMA channel may take input from several queues.
- *
- * Tx DMA channels have dedicated purposes.  For 4965, they are used as follows:
- *
- * 0 -- EDCA BK (background) frames, lowest priority
- * 1 -- EDCA BE (best effort) frames, normal priority
- * 2 -- EDCA VI (video) frames, higher priority
- * 3 -- EDCA VO (voice) and management frames, highest priority
- * 4 -- Commands (e.g. RXON, etc.)
- * 5 -- HCCA short frames
- * 6 -- HCCA long frames
- * 7 -- not used by driver (device-internal only)
- *
- * Driver should normally map queues 0-6 to Tx DMA/FIFO channels 0-6.
- * In addition, driver can map queues 7-15 to Tx DMA/FIFO channels 0-3 to
- * support 11n aggregation via EDCA DMA channels.
- *
- * The driver sets up each queue to work in one of two modes:
- *
- * 1)  Scheduler-Ack, in which the scheduler automatically supports a
- *     block-ack (BA) window of up to 64 TFDs.  In this mode, each queue
- *     contains TFDs for a unique combination of Recipient Address (RA)
- *     and Traffic Identifier (TID), that is, traffic of a given
- *     Quality-Of-Service (QOS) priority, destined for a single station.
- *
- *     In scheduler-ack mode, the scheduler keeps track of the Tx status of
- *     each frame within the BA window, including whether it's been transmitted,
- *     and whether it's been acknowledged by the receiving station.  The device
- *     automatically processes block-acks received from the receiving STA,
- *     and reschedules un-acked frames to be retransmitted (successful
- *     Tx completion may end up being out-of-order).
- *
- *     The driver must maintain the queue's Byte Count table in host DRAM
- *     (struct iwl4965_sched_queue_byte_cnt_tbl) for this mode.
- *     This mode does not support fragmentation.
- *
- * 2)  FIFO (a.k.a. non-Scheduler-ACK), in which each TFD is processed in order.
- *     The device may automatically retry Tx, but will retry only one frame
- *     at a time, until receiving ACK from receiving station, or reaching
- *     retry limit and giving up.
- *
- *     The command queue (#4) must use this mode!
- *     This mode does not require use of the Byte Count table in host DRAM.
- *
- * Driver controls scheduler operation via 3 means:
- * 1)  Scheduler registers
- * 2)  Shared scheduler data base in internal 4956 SRAM
- * 3)  Shared data in host DRAM
- *
- * Initialization:
- *
- * When loading, driver should allocate memory for:
- * 1)  16 TFD circular buffers, each with space for (typically) 256 TFDs.
- * 2)  16 Byte Count circular buffers in 16 KBytes contiguous memory
- *     (1024 bytes for each queue).
- *
- * After receiving "Alive" response from uCode, driver must initialize
- * the scheduler (especially for queue #4, the command queue, otherwise
- * the driver can't issue commands!):
- */
-
-/**
- * Max Tx window size is the max number of contiguous TFDs that the scheduler
- * can keep track of at one time when creating block-ack chains of frames.
- * Note that "64" matches the number of ack bits in a block-ack packet.
- * Driver should use SCD_WIN_SIZE and SCD_FRAME_LIMIT values to initialize
- * SCD_CONTEXT_QUEUE_OFFSET(x) values.
- */
-#define SCD_WIN_SIZE				64
-#define SCD_FRAME_LIMIT				64
-
-/* SCD registers are internal, must be accessed via HBUS_TARG_PRPH regs */
-#define SCD_START_OFFSET		0xa02c00
-
-/*
- * 4965 tells driver SRAM address for internal scheduler structs via this reg.
- * Value is valid only after "Alive" response from uCode.
- */
-#define SCD_SRAM_BASE_ADDR           (SCD_START_OFFSET + 0x0)
-
-/*
- * Driver may need to update queue-empty bits after changing queue's
- * write and read pointers (indexes) during (re-)initialization (i.e. when
- * scheduler is not tracking what's happening).
- * Bit fields:
- * 31-16:  Write mask -- 1: update empty bit, 0: don't change empty bit
- * 15-00:  Empty state, one for each queue -- 1: empty, 0: non-empty
- * NOTE:  This register is not used by Linux driver.
- */
-#define SCD_EMPTY_BITS               (SCD_START_OFFSET + 0x4)
-
-/*
- * Physical base address of array of byte count (BC) circular buffers (CBs).
- * Each Tx queue has a BC CB in host DRAM to support Scheduler-ACK mode.
- * This register points to BC CB for queue 0, must be on 1024-byte boundary.
- * Others are spaced by 1024 bytes.
- * Each BC CB is 2 bytes * (256 + 64) = 740 bytes, followed by 384 bytes pad.
- * (Index into a queue's BC CB) = (index into queue's TFD CB) = (SSN & 0xff).
- * Bit fields:
- * 25-00:  Byte Count CB physical address [35:10], must be 1024-byte aligned.
- */
-#define SCD_DRAM_BASE_ADDR           (SCD_START_OFFSET + 0x10)
-
-/*
- * Enables any/all Tx DMA/FIFO channels.
- * Scheduler generates requests for only the active channels.
- * Set this to 0xff to enable all 8 channels (normal usage).
- * Bit fields:
- *  7- 0:  Enable (1), disable (0), one bit for each channel 0-7
- */
-#define SCD_TXFACT                   (SCD_START_OFFSET + 0x1c)
-
-/* Mask to enable contiguous Tx DMA/FIFO channels between "lo" and "hi". */
-#define SCD_TXFACT_REG_TXFIFO_MASK(lo, hi) \
-       ((1 << (hi)) | ((1 << (hi)) - (1 << (lo))))
-
-/*
- * Queue (x) Write Pointers (indexes, really!), one for each Tx queue.
- * Initialized and updated by driver as new TFDs are added to queue.
- * NOTE:  If using Block Ack, index must correspond to frame's
- *        Start Sequence Number; index = (SSN & 0xff)
- * NOTE:  Alternative to HBUS_TARG_WRPTR, which is what Linux driver uses?
- */
-#define SCD_QUEUE_WRPTR(x)           (SCD_START_OFFSET + 0x24 + (x) * 4)
-
-/*
- * Queue (x) Read Pointers (indexes, really!), one for each Tx queue.
- * For FIFO mode, index indicates next frame to transmit.
- * For Scheduler-ACK mode, index indicates first frame in Tx window.
- * Initialized by driver, updated by scheduler.
- */
-#define SCD_QUEUE_RDPTR(x)           (SCD_START_OFFSET + 0x64 + (x) * 4)
-
-/*
- * Select which queues work in chain mode (1) vs. not (0).
- * Use chain mode to build chains of aggregated frames.
- * Bit fields:
- * 31-16:  Reserved
- * 15-00:  Mode, one bit for each queue -- 1: Chain mode, 0: one-at-a-time
- * NOTE:  If driver sets up queue for chain mode, it should be also set up
- *        Scheduler-ACK mode as well, via SCD_QUEUE_STATUS_BITS(x).
- */
-#define SCD_QUEUECHAIN_SEL           (SCD_START_OFFSET + 0xd0)
-
-/*
- * Select which queues interrupt driver when scheduler increments
- * a queue's read pointer (index).
- * Bit fields:
- * 31-16:  Reserved
- * 15-00:  Interrupt enable, one bit for each queue -- 1: enabled, 0: disabled
- * NOTE:  This functionality is apparently a no-op; driver relies on interrupts
- *        from Rx queue to read Tx command responses and update Tx queues.
- */
-#define SCD_INTERRUPT_MASK           (SCD_START_OFFSET + 0xe4)
-
-/*
- * Queue search status registers.  One for each queue.
- * Sets up queue mode and assigns queue to Tx DMA channel.
- * Bit fields:
- * 19-10: Write mask/enable bits for bits 0-9
- *     9: Driver should init to "0"
- *     8: Scheduler-ACK mode (1), non-Scheduler-ACK (i.e. FIFO) mode (0).
- *        Driver should init to "1" for aggregation mode, or "0" otherwise.
- *   7-6: Driver should init to "0"
- *     5: Window Size Left; indicates whether scheduler can request
- *        another TFD, based on window size, etc.  Driver should init
- *        this bit to "1" for aggregation mode, or "0" for non-agg.
- *   4-1: Tx FIFO to use (range 0-7).
- *     0: Queue is active (1), not active (0).
- * Other bits should be written as "0"
- *
- * NOTE:  If enabling Scheduler-ACK mode, chain mode should also be enabled
- *        via SCD_QUEUECHAIN_SEL.
- */
-#define SCD_QUEUE_STATUS_BITS(x)     (SCD_START_OFFSET + 0x104 + (x) * 4)
-
-/* Bit field positions */
-#define SCD_QUEUE_STTS_REG_POS_ACTIVE		(0)
-#define SCD_QUEUE_STTS_REG_POS_TXF		(1)
-#define SCD_QUEUE_STTS_REG_POS_WSL		(5)
-#define SCD_QUEUE_STTS_REG_POS_SCD_ACK		(8)
-
-/* Write masks */
-#define SCD_QUEUE_STTS_REG_POS_SCD_ACT_EN	(10)
-#define SCD_QUEUE_STTS_REG_MSK			(0x0007FC00)
-
-/**
- * 4965 internal SRAM structures for scheduler, shared with driver ...
- *
- * Driver should clear and initialize the following areas after receiving
- * "Alive" response from 4965 uCode, i.e. after initial
- * uCode load, or after a uCode load done for error recovery:
- *
- * SCD_CONTEXT_DATA_OFFSET (size 128 bytes)
- * SCD_TX_STTS_BITMAP_OFFSET (size 256 bytes)
- * SCD_TRANSLATE_TBL_OFFSET (size 32 bytes)
- *
- * Driver accesses SRAM via HBUS_TARG_MEM_* registers.
- * Driver reads base address of this scheduler area from SCD_SRAM_BASE_ADDR.
- * All OFFSET values must be added to this base address.
- */
-
-/*
- * Queue context.  One 8-byte entry for each of 16 queues.
- *
- * Driver should clear this entire area (size 0x80) to 0 after receiving
- * "Alive" notification from uCode.  Additionally, driver should init
- * each queue's entry as follows:
- *
- * LS Dword bit fields:
- *  0-06:  Max Tx window size for Scheduler-ACK.  Driver should init to 64.
- *
- * MS Dword bit fields:
- * 16-22:  Frame limit.  Driver should init to 10 (0xa).
- *
- * Driver should init all other bits to 0.
- *
- * Init must be done after driver receives "Alive" response from 4965 uCode,
- * and when setting up queue for aggregation.
- */
-#define SCD_CONTEXT_DATA_OFFSET			0x380
-#define SCD_CONTEXT_QUEUE_OFFSET(x)	(SCD_CONTEXT_DATA_OFFSET + ((x) * 8))
-
-#define SCD_QUEUE_CTX_REG1_WIN_SIZE_POS		(0)
-#define SCD_QUEUE_CTX_REG1_WIN_SIZE_MSK		(0x0000007F)
-#define SCD_QUEUE_CTX_REG2_FRAME_LIMIT_POS	(16)
-#define SCD_QUEUE_CTX_REG2_FRAME_LIMIT_MSK	(0x007F0000)
-
-/*
- * Tx Status Bitmap
- *
- * Driver should clear this entire area (size 0x100) to 0 after receiving
- * "Alive" notification from uCode.  Area is used only by device itself;
- * no other support (besides clearing) is required from driver.
- */
-#define SCD_TX_STTS_BITMAP_OFFSET		0x400
-
-/*
- * RAxTID to queue translation mapping.
- *
- * When queue is in Scheduler-ACK mode, frames placed in a that queue must be
- * for only one combination of receiver address (RA) and traffic ID (TID), i.e.
- * one QOS priority level destined for one station (for this wireless link,
- * not final destination).  The SCD_TRANSLATE_TABLE area provides 16 16-bit
- * mappings, one for each of the 16 queues.  If queue is not in Scheduler-ACK
- * mode, the device ignores the mapping value.
- *
- * Bit fields, for each 16-bit map:
- * 15-9:  Reserved, set to 0
- *  8-4:  Index into device's station table for recipient station
- *  3-0:  Traffic ID (tid), range 0-15
- *
- * Driver should clear this entire area (size 32 bytes) to 0 after receiving
- * "Alive" notification from uCode.  To update a 16-bit map value, driver
- * must read a dword-aligned value from device SRAM, replace the 16-bit map
- * value of interest, and write the dword value back into device SRAM.
- */
-#define SCD_TRANSLATE_TBL_OFFSET		0x500
-
-/* Find translation table dword to read/write for given queue */
-#define SCD_TRANSLATE_TBL_OFFSET_QUEUE(x) \
-	((SCD_TRANSLATE_TBL_OFFSET + ((x) * 2)) & 0xfffffffc)
-
-#define SCD_TXFIFO_POS_TID			(0)
-#define SCD_TXFIFO_POS_RA			(4)
-#define SCD_QUEUE_RA_TID_MAP_RATID_MSK		(0x01FF)
-
-/*********************** END TX SCHEDULER *************************************/
-
 static inline u8 iwl4965_hw_get_rate(__le32 rate_n_flags)
 {
 	return le32_to_cpu(rate_n_flags) & 0xFF;
@@ -1386,11 +1106,11 @@ static inline __le32 iwl4965_hw_set_rate_n_flags(u8 rate, u16 flags)
  * up to 7 DMA channels (FIFOs).  Each Tx queue is supported by a circular array
  * in DRAM containing 256 Transmit Frame Descriptors (TFDs).
  */
-#define IWL4965_MAX_WIN_SIZE	64
-#define IWL4965_QUEUE_SIZE	256
-#define IWL4965_NUM_FIFOS	7
-#define IWL4965_MAX_NUM_QUEUES	16
-
+#define IWL49_MAX_WIN_SIZE	64
+#define IWL49_QUEUE_SIZE	256
+#define IWL49_NUM_FIFOS 	7
+#define IWL49_CMD_FIFO_NUM	4
+#define IWL49_NUM_QUEUES	16
 
 /**
  * struct iwl4965_tfd_frame_data
@@ -1521,10 +1241,10 @@ struct iwl4965_queue_byte_cnt_entry {
  * 4965 assumes tables are separated by 1024 bytes.
  */
 struct iwl4965_sched_queue_byte_cnt_tbl {
-	struct iwl4965_queue_byte_cnt_entry tfd_offset[IWL4965_QUEUE_SIZE +
-						       IWL4965_MAX_WIN_SIZE];
+	struct iwl4965_queue_byte_cnt_entry tfd_offset[IWL49_QUEUE_SIZE +
+						       IWL49_MAX_WIN_SIZE];
 	u8 dont_care[1024 -
-		     (IWL4965_QUEUE_SIZE + IWL4965_MAX_WIN_SIZE) *
+		     (IWL49_QUEUE_SIZE + IWL49_MAX_WIN_SIZE) *
 		     sizeof(__le16)];
 } __attribute__ ((packed));
 
@@ -1554,7 +1274,7 @@ struct iwl4965_sched_queue_byte_cnt_tbl {
  */
 struct iwl4965_shared {
 	struct iwl4965_sched_queue_byte_cnt_tbl
-	 queues_byte_cnt_tbls[IWL4965_MAX_NUM_QUEUES];
+	 queues_byte_cnt_tbls[IWL49_NUM_QUEUES];
 	__le32 rb_closed;
 
 	/* __le32 rb_closed_stts_rb_num:12; */
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index f5796b7..2b21edb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -47,7 +47,7 @@
 
 /* module parameters */
 static struct iwl_mod_params iwl4965_mod_params = {
-	.num_of_queues = IWL4965_MAX_NUM_QUEUES,
+	.num_of_queues = IWL49_NUM_QUEUES,
 	.enable_qos = 1,
 	.amsdu_size_8K = 1,
 	/* the rest are 0 by default */
@@ -1164,11 +1164,11 @@ static void iwl4965_tx_queue_set_status(struct iwl_priv *priv,
 
 	/* Set up and activate */
 	iwl_write_prph(priv, IWL49_SCD_QUEUE_STATUS_BITS(txq_id),
-				 (active << SCD_QUEUE_STTS_REG_POS_ACTIVE) |
-				 (tx_fifo_id << SCD_QUEUE_STTS_REG_POS_TXF) |
-				 (scd_retry << SCD_QUEUE_STTS_REG_POS_WSL) |
-				 (scd_retry << SCD_QUEUE_STTS_REG_POS_SCD_ACK) |
-				 SCD_QUEUE_STTS_REG_MSK);
+			 (active << IWL49_SCD_QUEUE_STTS_REG_POS_ACTIVE) |
+			 (tx_fifo_id << IWL49_SCD_QUEUE_STTS_REG_POS_TXF) |
+			 (scd_retry << IWL49_SCD_QUEUE_STTS_REG_POS_WSL) |
+			 (scd_retry << IWL49_SCD_QUEUE_STTS_REG_POS_SCD_ACK) |
+			 IWL49_SCD_QUEUE_STTS_REG_MSK);
 
 	txq->sched_retry = scd_retry;
 
@@ -1182,7 +1182,7 @@ static const u16 default_queue_to_tx_fifo[] = {
 	IWL_TX_FIFO_AC2,
 	IWL_TX_FIFO_AC1,
 	IWL_TX_FIFO_AC0,
-	IWL_CMD_FIFO_NUM,
+	IWL49_CMD_FIFO_NUM,
 	IWL_TX_FIFO_HCCA_1,
 	IWL_TX_FIFO_HCCA_2
 };
@@ -1223,10 +1223,10 @@ int iwl4965_alive_notify(struct iwl_priv *priv)
 
 	/* Clear 4965's internal Tx Scheduler data base */
 	priv->scd_base_addr = iwl_read_prph(priv, IWL49_SCD_SRAM_BASE_ADDR);
-	a = priv->scd_base_addr + SCD_CONTEXT_DATA_OFFSET;
-	for (; a < priv->scd_base_addr + SCD_TX_STTS_BITMAP_OFFSET; a += 4)
+	a = priv->scd_base_addr + IWL49_SCD_CONTEXT_DATA_OFFSET;
+	for (; a < priv->scd_base_addr + IWL49_SCD_TX_STTS_BITMAP_OFFSET; a += 4)
 		iwl_write_targ_mem(priv, a, 0);
-	for (; a < priv->scd_base_addr + SCD_TRANSLATE_TBL_OFFSET; a += 4)
+	for (; a < priv->scd_base_addr + IWL49_SCD_TRANSLATE_TBL_OFFSET; a += 4)
 		iwl_write_targ_mem(priv, a, 0);
 	for (; a < sizeof(u16) * priv->hw_params.max_txq_num; a += 4)
 		iwl_write_targ_mem(priv, a, 0);
@@ -1248,18 +1248,18 @@ int iwl4965_alive_notify(struct iwl_priv *priv)
 
 		/* Max Tx Window size for Scheduler-ACK mode */
 		iwl_write_targ_mem(priv, priv->scd_base_addr +
-					SCD_CONTEXT_QUEUE_OFFSET(i),
-					(SCD_WIN_SIZE <<
-					SCD_QUEUE_CTX_REG1_WIN_SIZE_POS) &
-					SCD_QUEUE_CTX_REG1_WIN_SIZE_MSK);
+				IWL49_SCD_CONTEXT_QUEUE_OFFSET(i),
+				(SCD_WIN_SIZE <<
+				IWL49_SCD_QUEUE_CTX_REG1_WIN_SIZE_POS) &
+				IWL49_SCD_QUEUE_CTX_REG1_WIN_SIZE_MSK);
 
 		/* Frame limit */
 		iwl_write_targ_mem(priv, priv->scd_base_addr +
-					SCD_CONTEXT_QUEUE_OFFSET(i) +
-					sizeof(u32),
-					(SCD_FRAME_LIMIT <<
-					SCD_QUEUE_CTX_REG2_FRAME_LIMIT_POS) &
-					SCD_QUEUE_CTX_REG2_FRAME_LIMIT_MSK);
+				IWL49_SCD_CONTEXT_QUEUE_OFFSET(i) +
+				sizeof(u32),
+				(SCD_FRAME_LIMIT <<
+				IWL49_SCD_QUEUE_CTX_REG2_FRAME_LIMIT_POS) &
+				IWL49_SCD_QUEUE_CTX_REG2_FRAME_LIMIT_MSK);
 
 	}
 	iwl_write_prph(priv, IWL49_SCD_INTERRUPT_MASK,
@@ -1320,10 +1320,10 @@ static struct iwl_sensitivity_ranges iwl4965_sensitivity = {
 int iwl4965_hw_set_hw_params(struct iwl_priv *priv)
 {
 
-	if ((priv->cfg->mod_params->num_of_queues > IWL4965_MAX_NUM_QUEUES) ||
+	if ((priv->cfg->mod_params->num_of_queues > IWL49_NUM_QUEUES) ||
 	    (priv->cfg->mod_params->num_of_queues < IWL_MIN_NUM_QUEUES)) {
 		IWL_ERROR("invalid queues_num, should be between %d and %d\n",
-			  IWL_MIN_NUM_QUEUES, IWL4965_MAX_NUM_QUEUES);
+			  IWL_MIN_NUM_QUEUES, IWL49_NUM_QUEUES);
 		return -EINVAL;
 	}
 
@@ -2520,9 +2520,9 @@ static void iwl4965_txq_update_byte_cnt_tbl(struct iwl_priv *priv,
 		       tfd_offset[txq->q.write_ptr], byte_cnt, len);
 
 	/* If within first 64 entries, duplicate at end */
-	if (txq->q.write_ptr < IWL4965_MAX_WIN_SIZE)
+	if (txq->q.write_ptr < IWL49_MAX_WIN_SIZE)
 		IWL_SET_BITS16(shared_data->queues_byte_cnt_tbls[txq_id].
-			tfd_offset[IWL4965_QUEUE_SIZE + txq->q.write_ptr],
+			tfd_offset[IWL49_QUEUE_SIZE + txq->q.write_ptr],
 			byte_cnt, len);
 }
 
@@ -3646,8 +3646,8 @@ static void iwl4965_tx_queue_stop_scheduler(struct iwl_priv *priv,
 	 * the SCD_ACT_EN bit is the write-enable mask for the ACTIVE bit. */
 	iwl_write_prph(priv,
 		IWL49_SCD_QUEUE_STATUS_BITS(txq_id),
-		(0 << SCD_QUEUE_STTS_REG_POS_ACTIVE)|
-		(1 << SCD_QUEUE_STTS_REG_POS_SCD_ACT_EN));
+		(0 << IWL49_SCD_QUEUE_STTS_REG_POS_ACTIVE)|
+		(1 << IWL49_SCD_QUEUE_STTS_REG_POS_SCD_ACT_EN));
 }
 
 /**
@@ -3812,10 +3812,10 @@ static int iwl4965_tx_queue_set_q2ratid(struct iwl_priv *priv, u16 ra_tid,
 	u32 tbl_dw;
 	u16 scd_q2ratid;
 
-	scd_q2ratid = ra_tid & SCD_QUEUE_RA_TID_MAP_RATID_MSK;
+	scd_q2ratid = ra_tid & IWL49_SCD_QUEUE_RA_TID_MAP_RATID_MSK;
 
 	tbl_dw_addr = priv->scd_base_addr +
-			SCD_TRANSLATE_TBL_OFFSET_QUEUE(txq_id);
+			IWL49_SCD_TRANSLATE_TBL_OFFSET_QUEUE(txq_id);
 
 	tbl_dw = iwl_read_targ_mem(priv, tbl_dw_addr);
 
@@ -3877,14 +3877,14 @@ static int iwl4965_tx_queue_agg_enable(struct iwl_priv *priv, int txq_id,
 
 	/* Set up Tx window size and frame limit for this queue */
 	iwl_write_targ_mem(priv,
-			priv->scd_base_addr + SCD_CONTEXT_QUEUE_OFFSET(txq_id),
-			(SCD_WIN_SIZE << SCD_QUEUE_CTX_REG1_WIN_SIZE_POS) &
-			SCD_QUEUE_CTX_REG1_WIN_SIZE_MSK);
+		priv->scd_base_addr + IWL49_SCD_CONTEXT_QUEUE_OFFSET(txq_id),
+		(SCD_WIN_SIZE << IWL49_SCD_QUEUE_CTX_REG1_WIN_SIZE_POS) &
+		IWL49_SCD_QUEUE_CTX_REG1_WIN_SIZE_MSK);
 
 	iwl_write_targ_mem(priv, priv->scd_base_addr +
-			SCD_CONTEXT_QUEUE_OFFSET(txq_id) + sizeof(u32),
-			(SCD_FRAME_LIMIT << SCD_QUEUE_CTX_REG2_FRAME_LIMIT_POS)
-			& SCD_QUEUE_CTX_REG2_FRAME_LIMIT_MSK);
+		IWL49_SCD_CONTEXT_QUEUE_OFFSET(txq_id) + sizeof(u32),
+		(SCD_FRAME_LIMIT << IWL49_SCD_QUEUE_CTX_REG2_FRAME_LIMIT_POS)
+		& IWL49_SCD_QUEUE_CTX_REG2_FRAME_LIMIT_MSK);
 
 	iwl_set_bits_prph(priv, IWL49_SCD_INTERRUPT_MASK, (1 << txq_id));
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-prph.h b/drivers/net/wireless/iwlwifi/iwl-prph.h
index c9cf8ee..acac629 100644
--- a/drivers/net/wireless/iwlwifi/iwl-prph.h
+++ b/drivers/net/wireless/iwlwifi/iwl-prph.h
@@ -239,40 +239,284 @@
 #define ALM_SCD_SBYP_MODE_1_REG             (ALM_SCD_BASE + 0x02C)
 #define ALM_SCD_SBYP_MODE_2_REG             (ALM_SCD_BASE + 0x030)
 
+/**
+ * Tx Scheduler
+ *
+ * The Tx Scheduler selects the next frame to be transmitted, chosing TFDs
+ * (Transmit Frame Descriptors) from up to 16 circular Tx queues resident in
+ * host DRAM.  It steers each frame's Tx command (which contains the frame
+ * data) into one of up to 7 prioritized Tx DMA FIFO channels within the
+ * device.  A queue maps to only one (selectable by driver) Tx DMA channel,
+ * but one DMA channel may take input from several queues.
+ *
+ * Tx DMA channels have dedicated purposes.  For 4965, they are used as follows:
+ *
+ * 0 -- EDCA BK (background) frames, lowest priority
+ * 1 -- EDCA BE (best effort) frames, normal priority
+ * 2 -- EDCA VI (video) frames, higher priority
+ * 3 -- EDCA VO (voice) and management frames, highest priority
+ * 4 -- Commands (e.g. RXON, etc.)
+ * 5 -- HCCA short frames
+ * 6 -- HCCA long frames
+ * 7 -- not used by driver (device-internal only)
+ *
+ * Driver should normally map queues 0-6 to Tx DMA/FIFO channels 0-6.
+ * In addition, driver can map queues 7-15 to Tx DMA/FIFO channels 0-3 to
+ * support 11n aggregation via EDCA DMA channels.
+ *
+ * The driver sets up each queue to work in one of two modes:
+ *
+ * 1)  Scheduler-Ack, in which the scheduler automatically supports a
+ *     block-ack (BA) window of up to 64 TFDs.  In this mode, each queue
+ *     contains TFDs for a unique combination of Recipient Address (RA)
+ *     and Traffic Identifier (TID), that is, traffic of a given
+ *     Quality-Of-Service (QOS) priority, destined for a single station.
+ *
+ *     In scheduler-ack mode, the scheduler keeps track of the Tx status of
+ *     each frame within the BA window, including whether it's been transmitted,
+ *     and whether it's been acknowledged by the receiving station.  The device
+ *     automatically processes block-acks received from the receiving STA,
+ *     and reschedules un-acked frames to be retransmitted (successful
+ *     Tx completion may end up being out-of-order).
+ *
+ *     The driver must maintain the queue's Byte Count table in host DRAM
+ *     (struct iwl4965_sched_queue_byte_cnt_tbl) for this mode.
+ *     This mode does not support fragmentation.
+ *
+ * 2)  FIFO (a.k.a. non-Scheduler-ACK), in which each TFD is processed in order.
+ *     The device may automatically retry Tx, but will retry only one frame
+ *     at a time, until receiving ACK from receiving station, or reaching
+ *     retry limit and giving up.
+ *
+ *     The command queue (#4) must use this mode!
+ *     This mode does not require use of the Byte Count table in host DRAM.
+ *
+ * Driver controls scheduler operation via 3 means:
+ * 1)  Scheduler registers
+ * 2)  Shared scheduler data base in internal 4956 SRAM
+ * 3)  Shared data in host DRAM
+ *
+ * Initialization:
+ *
+ * When loading, driver should allocate memory for:
+ * 1)  16 TFD circular buffers, each with space for (typically) 256 TFDs.
+ * 2)  16 Byte Count circular buffers in 16 KBytes contiguous memory
+ *     (1024 bytes for each queue).
+ *
+ * After receiving "Alive" response from uCode, driver must initialize
+ * the scheduler (especially for queue #4, the command queue, otherwise
+ * the driver can't issue commands!):
+ */
+
+/**
+ * Max Tx window size is the max number of contiguous TFDs that the scheduler
+ * can keep track of at one time when creating block-ack chains of frames.
+ * Note that "64" matches the number of ack bits in a block-ack packet.
+ * Driver should use SCD_WIN_SIZE and SCD_FRAME_LIMIT values to initialize
+ * IWL49_SCD_CONTEXT_QUEUE_OFFSET(x) values.
+ */
+#define SCD_WIN_SIZE				64
+#define SCD_FRAME_LIMIT				64
+
+/* SCD registers are internal, must be accessed via HBUS_TARG_PRPH regs */
+#define IWL49_SCD_START_OFFSET		0xa02c00
+
+/*
+ * 4965 tells driver SRAM address for internal scheduler structs via this reg.
+ * Value is valid only after "Alive" response from uCode.
+ */
+#define IWL49_SCD_SRAM_BASE_ADDR           (IWL49_SCD_START_OFFSET + 0x0)
+
+/*
+ * Driver may need to update queue-empty bits after changing queue's
+ * write and read pointers (indexes) during (re-)initialization (i.e. when
+ * scheduler is not tracking what's happening).
+ * Bit fields:
+ * 31-16:  Write mask -- 1: update empty bit, 0: don't change empty bit
+ * 15-00:  Empty state, one for each queue -- 1: empty, 0: non-empty
+ * NOTE:  This register is not used by Linux driver.
+ */
+#define IWL49_SCD_EMPTY_BITS               (IWL49_SCD_START_OFFSET + 0x4)
+
+/*
+ * Physical base address of array of byte count (BC) circular buffers (CBs).
+ * Each Tx queue has a BC CB in host DRAM to support Scheduler-ACK mode.
+ * This register points to BC CB for queue 0, must be on 1024-byte boundary.
+ * Others are spaced by 1024 bytes.
+ * Each BC CB is 2 bytes * (256 + 64) = 740 bytes, followed by 384 bytes pad.
+ * (Index into a queue's BC CB) = (index into queue's TFD CB) = (SSN & 0xff).
+ * Bit fields:
+ * 25-00:  Byte Count CB physical address [35:10], must be 1024-byte aligned.
+ */
+#define IWL49_SCD_DRAM_BASE_ADDR           (IWL49_SCD_START_OFFSET + 0x10)
+
+/*
+ * Enables any/all Tx DMA/FIFO channels.
+ * Scheduler generates requests for only the active channels.
+ * Set this to 0xff to enable all 8 channels (normal usage).
+ * Bit fields:
+ *  7- 0:  Enable (1), disable (0), one bit for each channel 0-7
+ */
+#define IWL49_SCD_TXFACT                   (IWL49_SCD_START_OFFSET + 0x1c)
+
+/* Mask to enable contiguous Tx DMA/FIFO channels between "lo" and "hi". */
+#define SCD_TXFACT_REG_TXFIFO_MASK(lo, hi) \
+       ((1 << (hi)) | ((1 << (hi)) - (1 << (lo))))
+
+/*
+ * Queue (x) Write Pointers (indexes, really!), one for each Tx queue.
+ * Initialized and updated by driver as new TFDs are added to queue.
+ * NOTE:  If using Block Ack, index must correspond to frame's
+ *        Start Sequence Number; index = (SSN & 0xff)
+ * NOTE:  Alternative to HBUS_TARG_WRPTR, which is what Linux driver uses?
+ */
+#define IWL49_SCD_QUEUE_WRPTR(x)  (IWL49_SCD_START_OFFSET + 0x24 + (x) * 4)
+
+/*
+ * Queue (x) Read Pointers (indexes, really!), one for each Tx queue.
+ * For FIFO mode, index indicates next frame to transmit.
+ * For Scheduler-ACK mode, index indicates first frame in Tx window.
+ * Initialized by driver, updated by scheduler.
+ */
+#define IWL49_SCD_QUEUE_RDPTR(x)  (IWL49_SCD_START_OFFSET + 0x64 + (x) * 4)
+
+/*
+ * Select which queues work in chain mode (1) vs. not (0).
+ * Use chain mode to build chains of aggregated frames.
+ * Bit fields:
+ * 31-16:  Reserved
+ * 15-00:  Mode, one bit for each queue -- 1: Chain mode, 0: one-at-a-time
+ * NOTE:  If driver sets up queue for chain mode, it should be also set up
+ *        Scheduler-ACK mode as well, via SCD_QUEUE_STATUS_BITS(x).
+ */
+#define IWL49_SCD_QUEUECHAIN_SEL  (IWL49_SCD_START_OFFSET + 0xd0)
+
+/*
+ * Select which queues interrupt driver when scheduler increments
+ * a queue's read pointer (index).
+ * Bit fields:
+ * 31-16:  Reserved
+ * 15-00:  Interrupt enable, one bit for each queue -- 1: enabled, 0: disabled
+ * NOTE:  This functionality is apparently a no-op; driver relies on interrupts
+ *        from Rx queue to read Tx command responses and update Tx queues.
+ */
+#define IWL49_SCD_INTERRUPT_MASK  (IWL49_SCD_START_OFFSET + 0xe4)
+
+/*
+ * Queue search status registers.  One for each queue.
+ * Sets up queue mode and assigns queue to Tx DMA channel.
+ * Bit fields:
+ * 19-10: Write mask/enable bits for bits 0-9
+ *     9: Driver should init to "0"
+ *     8: Scheduler-ACK mode (1), non-Scheduler-ACK (i.e. FIFO) mode (0).
+ *        Driver should init to "1" for aggregation mode, or "0" otherwise.
+ *   7-6: Driver should init to "0"
+ *     5: Window Size Left; indicates whether scheduler can request
+ *        another TFD, based on window size, etc.  Driver should init
+ *        this bit to "1" for aggregation mode, or "0" for non-agg.
+ *   4-1: Tx FIFO to use (range 0-7).
+ *     0: Queue is active (1), not active (0).
+ * Other bits should be written as "0"
+ *
+ * NOTE:  If enabling Scheduler-ACK mode, chain mode should also be enabled
+ *        via SCD_QUEUECHAIN_SEL.
+ */
+#define IWL49_SCD_QUEUE_STATUS_BITS(x)\
+	(IWL49_SCD_START_OFFSET + 0x104 + (x) * 4)
+
+/* Bit field positions */
+#define IWL49_SCD_QUEUE_STTS_REG_POS_ACTIVE	(0)
+#define IWL49_SCD_QUEUE_STTS_REG_POS_TXF	(1)
+#define IWL49_SCD_QUEUE_STTS_REG_POS_WSL	(5)
+#define IWL49_SCD_QUEUE_STTS_REG_POS_SCD_ACK	(8)
+
+/* Write masks */
+#define IWL49_SCD_QUEUE_STTS_REG_POS_SCD_ACT_EN	(10)
+#define IWL49_SCD_QUEUE_STTS_REG_MSK		(0x0007FC00)
+
+/**
+ * 4965 internal SRAM structures for scheduler, shared with driver ...
+ *
+ * Driver should clear and initialize the following areas after receiving
+ * "Alive" response from 4965 uCode, i.e. after initial
+ * uCode load, or after a uCode load done for error recovery:
+ *
+ * SCD_CONTEXT_DATA_OFFSET (size 128 bytes)
+ * SCD_TX_STTS_BITMAP_OFFSET (size 256 bytes)
+ * SCD_TRANSLATE_TBL_OFFSET (size 32 bytes)
+ *
+ * Driver accesses SRAM via HBUS_TARG_MEM_* registers.
+ * Driver reads base address of this scheduler area from SCD_SRAM_BASE_ADDR.
+ * All OFFSET values must be added to this base address.
+ */
+
+/*
+ * Queue context.  One 8-byte entry for each of 16 queues.
+ *
+ * Driver should clear this entire area (size 0x80) to 0 after receiving
+ * "Alive" notification from uCode.  Additionally, driver should init
+ * each queue's entry as follows:
+ *
+ * LS Dword bit fields:
+ *  0-06:  Max Tx window size for Scheduler-ACK.  Driver should init to 64.
+ *
+ * MS Dword bit fields:
+ * 16-22:  Frame limit.  Driver should init to 10 (0xa).
+ *
+ * Driver should init all other bits to 0.
+ *
+ * Init must be done after driver receives "Alive" response from 4965 uCode,
+ * and when setting up queue for aggregation.
+ */
+#define IWL49_SCD_CONTEXT_DATA_OFFSET			0x380
+#define IWL49_SCD_CONTEXT_QUEUE_OFFSET(x) \
+			(IWL49_SCD_CONTEXT_DATA_OFFSET + ((x) * 8))
+
+#define IWL49_SCD_QUEUE_CTX_REG1_WIN_SIZE_POS		(0)
+#define IWL49_SCD_QUEUE_CTX_REG1_WIN_SIZE_MSK		(0x0000007F)
+#define IWL49_SCD_QUEUE_CTX_REG2_FRAME_LIMIT_POS	(16)
+#define IWL49_SCD_QUEUE_CTX_REG2_FRAME_LIMIT_MSK	(0x007F0000)
+
 /*
- * 4965 Tx Scheduler registers.
- * Details are documented in iwl-4965-hw.h
+ * Tx Status Bitmap
+ *
+ * Driver should clear this entire area (size 0x100) to 0 after receiving
+ * "Alive" notification from uCode.  Area is used only by device itself;
+ * no other support (besides clearing) is required from driver.
  */
-#define IWL49_SCD_BASE		(PRPH_BASE + 0xa02c00)
-
-#define IWL49_SCD_SRAM_BASE_ADDR         (IWL49_SCD_BASE + 0x0)
-#define IWL49_SCD_EMPTY_BITS             (IWL49_SCD_BASE + 0x4)
-#define IWL49_SCD_DRAM_BASE_ADDR         (IWL49_SCD_BASE + 0x10)
-#define IWL49_SCD_AIT                    (IWL49_SCD_BASE + 0x18)
-#define IWL49_SCD_TXFACT                 (IWL49_SCD_BASE + 0x1c)
-#define IWL49_SCD_QUEUE_WRPTR(x)         (IWL49_SCD_BASE + 0x24 + (x) * 4)
-#define IWL49_SCD_QUEUE_RDPTR(x)         (IWL49_SCD_BASE + 0x64 + (x) * 4)
-#define IWL49_SCD_SETQUEUENUM            (IWL49_SCD_BASE + 0xa4)
-#define IWL49_SCD_SET_TXSTAT_TXED        (IWL49_SCD_BASE + 0xa8)
-#define IWL49_SCD_SET_TXSTAT_DONE        (IWL49_SCD_BASE + 0xac)
-#define IWL49_SCD_SET_TXSTAT_NOT_SCHD    (IWL49_SCD_BASE + 0xb0)
-#define IWL49_SCD_DECREASE_CREDIT        (IWL49_SCD_BASE + 0xb4)
-#define IWL49_SCD_DECREASE_SCREDIT       (IWL49_SCD_BASE + 0xb8)
-#define IWL49_SCD_LOAD_CREDIT            (IWL49_SCD_BASE + 0xbc)
-#define IWL49_SCD_LOAD_SCREDIT           (IWL49_SCD_BASE + 0xc0)
-#define IWL49_SCD_BAR                    (IWL49_SCD_BASE + 0xc4)
-#define IWL49_SCD_BAR_DW0                (IWL49_SCD_BASE + 0xc8)
-#define IWL49_SCD_BAR_DW1                (IWL49_SCD_BASE + 0xcc)
-#define IWL49_SCD_QUEUECHAIN_SEL         (IWL49_SCD_BASE + 0xd0)
-#define IWL49_SCD_QUERY_REQ              (IWL49_SCD_BASE + 0xd8)
-#define IWL49_SCD_QUERY_RES              (IWL49_SCD_BASE + 0xdc)
-#define IWL49_SCD_PENDING_FRAMES         (IWL49_SCD_BASE + 0xe0)
-#define IWL49_SCD_INTERRUPT_MASK         (IWL49_SCD_BASE + 0xe4)
-#define IWL49_SCD_INTERRUPT_THRESHOLD    (IWL49_SCD_BASE + 0xe8)
-#define IWL49_SCD_QUERY_MIN_FRAME_SIZE   (IWL49_SCD_BASE + 0x100)
-#define IWL49_SCD_QUEUE_STATUS_BITS(x)   (IWL49_SCD_BASE + 0x104 + (x) * 4)
-
-/* SP SCD */
+#define IWL49_SCD_TX_STTS_BITMAP_OFFSET		0x400
+
+/*
+ * RAxTID to queue translation mapping.
+ *
+ * When queue is in Scheduler-ACK mode, frames placed in a that queue must be
+ * for only one combination of receiver address (RA) and traffic ID (TID), i.e.
+ * one QOS priority level destined for one station (for this wireless link,
+ * not final destination).  The SCD_TRANSLATE_TABLE area provides 16 16-bit
+ * mappings, one for each of the 16 queues.  If queue is not in Scheduler-ACK
+ * mode, the device ignores the mapping value.
+ *
+ * Bit fields, for each 16-bit map:
+ * 15-9:  Reserved, set to 0
+ *  8-4:  Index into device's station table for recipient station
+ *  3-0:  Traffic ID (tid), range 0-15
+ *
+ * Driver should clear this entire area (size 32 bytes) to 0 after receiving
+ * "Alive" notification from uCode.  To update a 16-bit map value, driver
+ * must read a dword-aligned value from device SRAM, replace the 16-bit map
+ * value of interest, and write the dword value back into device SRAM.
+ */
+#define IWL49_SCD_TRANSLATE_TBL_OFFSET		0x500
+
+/* Find translation table dword to read/write for given queue */
+#define IWL49_SCD_TRANSLATE_TBL_OFFSET_QUEUE(x) \
+	((IWL49_SCD_TRANSLATE_TBL_OFFSET + ((x) * 2)) & 0xfffffffc)
+
+#define IWL49_SCD_TXFIFO_POS_TID		(0)
+#define IWL49_SCD_TXFIFO_POS_RA			(4)
+#define IWL49_SCD_QUEUE_RA_TID_MAP_RATID_MSK	(0x01FF)
+
+/* 5000 SCD */
 #define IWL50_SCD_BASE			(PRPH_BASE + 0xa02c00)
 
 #define IWL50_SCD_SRAM_BASE_ADDR         (IWL50_SCD_BASE + 0x0)
@@ -287,4 +531,6 @@
 #define IWL50_SCD_INTERRUPT_MASK         (IWL50_SCD_BASE + 0x108)
 #define IWL50_SCD_QUEUE_STATUS_BITS(x)   (IWL50_SCD_BASE + 0x10c + (x) * 4)
 
+/*********************** END TX SCHEDULER *************************************/
+
 #endif				/* __iwl_prph_h__ */
-- 
1.5.3.4

