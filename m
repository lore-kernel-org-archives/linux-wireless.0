Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:56161 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756744AbXK2DLJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2007 22:11:09 -0500
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Ben Cahill <ben.m.cahill@intel.com>, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 27/36] iwlwifi: document 4965 Tx scheduler
Date: Thu, 29 Nov 2007 11:10:07 +0800
Message-Id: <1196305816-23023-28-git-send-email-yi.zhu@intel.com> (sfid-20071129_033544_314207_EB046FD4)
In-Reply-To: <1196305816-23023-27-git-send-email-yi.zhu@intel.com>
References: <1196305816-23023-1-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-2-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-3-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-4-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-5-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-6-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-7-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-8-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-9-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-10-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-11-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-12-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-13-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-14-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-15-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-16-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-17-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-18-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-19-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-20-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-21-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-22-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-23-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-24-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-25-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-26-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-27-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Cahill <ben.m.cahill@intel.com>

Document 4965 Tx scheduler

Signed-off-by: Ben Cahill <ben.m.cahill@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965-hw.h  |  268 ++++++++++++++++++++++++++-
 drivers/net/wireless/iwlwifi/iwl-prph.h     |   14 +-
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    2 +
 3 files changed, 272 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-hw.h b/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
index ecfc6f5..9bad516 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
@@ -1554,33 +1554,285 @@ enum {
 	IWL_FH_TSSR_TX_STATUS_REG_BIT_NO_PEND_REQ(_chnl))
 
 
+/********************* START TX SCHEDULER *************************************/
+
+/**
+ * 4965 Tx Scheduler
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
+ * SCD_CONTEXT_QUEUE_OFFSET(x) values.
+ */
 #define SCD_WIN_SIZE				64
 #define SCD_FRAME_LIMIT				64
 
-/* SRAM structures */
-#define SCD_CONTEXT_DATA_OFFSET			0x380
-#define SCD_TX_STTS_BITMAP_OFFSET		0x400
-#define SCD_TRANSLATE_TBL_OFFSET		0x500
-#define SCD_CONTEXT_QUEUE_OFFSET(x)	(SCD_CONTEXT_DATA_OFFSET + ((x) * 8))
-#define SCD_TRANSLATE_TBL_OFFSET_QUEUE(x) \
-	((SCD_TRANSLATE_TBL_OFFSET + ((x) * 2)) & 0xfffffffc)
+/* SCD registers are internal, must be accessed via HBUS_TARG_PRPH regs */
+#define SCD_START_OFFSET		0xa02c00
+
+/*
+ * 4965 tells driver SRAM address for internal scheduler structs via this reg.
+ * Value is valid only after "Alive" response from uCode.
+ */
+#define SCD_SRAM_BASE_ADDR           (SCD_START_OFFSET + 0x0)
 
+/*
+ * Driver may need to update queue-empty bits after changing queue's
+ * write and read pointers (indexes) during (re-)initialization (i.e. when
+ * scheduler is not tracking what's happening).
+ * Bit fields:
+ * 31-16:  Write mask -- 1: update empty bit, 0: don't change empty bit
+ * 15-00:  Empty state, one for each queue -- 1: empty, 0: non-empty
+ * NOTE:  This register is not used by Linux driver.
+ */
+#define SCD_EMPTY_BITS               (SCD_START_OFFSET + 0x4)
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
+#define SCD_DRAM_BASE_ADDR           (SCD_START_OFFSET + 0x10)
+
+/*
+ * Enables any/all Tx DMA/FIFO channels.
+ * Scheduler generates requests for only the active channels.
+ * Set this to 0xff to enable all 8 channels (normal usage).
+ * Bit fields:
+ *  7- 0:  Enable (1), disable (0), one bit for each channel 0-7
+ */
+#define SCD_TXFACT                   (SCD_START_OFFSET + 0x1c)
+
+/* Mask to enable contiguous Tx DMA/FIFO channels between "lo" and "hi". */
 #define SCD_TXFACT_REG_TXFIFO_MASK(lo, hi) \
        ((1<<(hi))|((1<<(hi))-(1<<(lo))))
 
+/*
+ * Queue (x) Write Pointers (indexes, really!), one for each Tx queue.
+ * Initialized and updated by driver as new TFDs are added to queue.
+ * NOTE:  If using Block Ack, index must correspond to frame's
+ *        Start Sequence Number; index = (SSN & 0xff)
+ * NOTE:  Alternative to HBUS_TARG_WRPTR, which is what Linux driver uses?
+ */
+#define SCD_QUEUE_WRPTR(x)           (SCD_START_OFFSET + 0x24 + (x) * 4)
+
+/*
+ * Queue (x) Read Pointers (indexes, really!), one for each Tx queue.
+ * For FIFO mode, index indicates next frame to transmit.
+ * For Scheduler-ACK mode, index indicates first frame in Tx window.
+ * Initialized by driver, updated by scheduler.
+ */
+#define SCD_QUEUE_RDPTR(x)           (SCD_START_OFFSET + 0x64 + (x) * 4)
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
+#define SCD_QUEUECHAIN_SEL           (SCD_START_OFFSET + 0xd0)
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
+#define SCD_INTERRUPT_MASK           (SCD_START_OFFSET + 0xe4)
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
+#define SCD_QUEUE_STATUS_BITS(x)     (SCD_START_OFFSET + 0x104 + (x) * 4)
+
+/* Bit field positions */
 #define SCD_QUEUE_STTS_REG_POS_ACTIVE		(0)
 #define SCD_QUEUE_STTS_REG_POS_TXF		(1)
 #define SCD_QUEUE_STTS_REG_POS_WSL		(5)
 #define SCD_QUEUE_STTS_REG_POS_SCD_ACK		(8)
+
+/* Write masks */
 #define SCD_QUEUE_STTS_REG_POS_SCD_ACT_EN	(10)
 #define SCD_QUEUE_STTS_REG_MSK			(0x0007FC00)
 
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
+#define SCD_CONTEXT_DATA_OFFSET			0x380
+#define SCD_CONTEXT_QUEUE_OFFSET(x)	(SCD_CONTEXT_DATA_OFFSET + ((x) * 8))
+
 #define SCD_QUEUE_CTX_REG1_WIN_SIZE_POS		(0)
 #define SCD_QUEUE_CTX_REG1_WIN_SIZE_MSK		(0x0000007F)
-
 #define SCD_QUEUE_CTX_REG2_FRAME_LIMIT_POS	(16)
 #define SCD_QUEUE_CTX_REG2_FRAME_LIMIT_MSK	(0x007F0000)
 
+/*
+ * Tx Status Bitmap
+ *
+ * Driver should clear this entire area (size 0x100) to 0 after receiving
+ * "Alive" notification from uCode.  Area is used only by device itself;
+ * no other support (besides clearing) is required from driver.
+ */
+#define SCD_TX_STTS_BITMAP_OFFSET		0x400
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
+#define SCD_TRANSLATE_TBL_OFFSET		0x500
+
+/* Find translation table dword to read/write for given queue */
+#define SCD_TRANSLATE_TBL_OFFSET_QUEUE(x) \
+	((SCD_TRANSLATE_TBL_OFFSET + ((x) * 2)) & 0xfffffffc)
+
+#define SCD_TXFIFO_POS_TID			(0)
+#define SCD_TXFIFO_POS_RA			(4)
+#define SCD_QUEUE_RA_TID_MAP_RATID_MSK		(0x01FF)
+
+/*********************** END TX SCHEDULER *************************************/
+
 static inline u8 iwl4965_hw_get_rate(__le32 rate_n_flags)
 {
 	return le32_to_cpu(rate_n_flags) & 0xFF;
diff --git a/drivers/net/wireless/iwlwifi/iwl-prph.h b/drivers/net/wireless/iwlwifi/iwl-prph.h
index 137947d..4ba1216 100644
--- a/drivers/net/wireless/iwlwifi/iwl-prph.h
+++ b/drivers/net/wireless/iwlwifi/iwl-prph.h
@@ -63,7 +63,10 @@
 #ifndef	__iwl_prph_h__
 #define __iwl_prph_h__
 
-
+/*
+ * Registers in this file are internal, not PCI bus memory mapped.
+ * Driver accesses these via HBUS_TARG_PRPH_* registers.
+ */
 #define PRPH_BASE	(0x00000)
 #define PRPH_END	(0xFFFFF)
 
@@ -225,8 +228,8 @@
 #define BSM_SRAM_LOWER_BOUND         (PRPH_BASE + 0x3800)
 #define BSM_SRAM_SIZE			(1024) /* bytes */
 
-/* ALM SCD */
-/* SCD (Scheduler) */
+
+/* 3945 Tx scheduler registers */
 #define ALM_SCD_BASE                        (PRPH_BASE + 0x2E00)
 #define ALM_SCD_MODE_REG                    (ALM_SCD_BASE + 0x000)
 #define ALM_SCD_ARASTAT_REG                 (ALM_SCD_BASE + 0x004)
@@ -236,7 +239,10 @@
 #define ALM_SCD_SBYP_MODE_1_REG             (ALM_SCD_BASE + 0x02C)
 #define ALM_SCD_SBYP_MODE_2_REG             (ALM_SCD_BASE + 0x030)
 
-/* 4965 SCD memory mapped registers */
+/*
+ * 4965 Tx Scheduler registers.
+ * Details are documented in iwl-4965-hw.h
+ */
 #define KDR_SCD_BASE		(PRPH_BASE + 0xa02c00)
 
 #define KDR_SCD_SRAM_BASE_ADDR         (KDR_SCD_BASE + 0x0)
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index f813669..31601d7 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -201,6 +201,8 @@ static void iwl4965_print_hex_dump(int level, void *p, u32 len)
  * The 4965 operates with up to 17 queues:  One receive queue, one transmit
  * queue (#4) for sending commands to the device firmware, and 15 other
  * Tx queues that may be mapped to prioritized Tx DMA/FIFO channels.
+ *
+ * See more detailed info in iwl-4965-hw.h.
  ***************************************************/
 
 static int iwl4965_queue_space(const struct iwl4965_queue *q)
-- 
1.5.3.6
