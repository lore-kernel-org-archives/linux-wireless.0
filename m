Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:31699 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753570AbXLCLsz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Dec 2007 06:48:55 -0500
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, yi.zhu@intel.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Ben Cahill <ben.m.cahill@intel.com>
Subject: [PATCH 23/34] iwlwifi: document Rx registers
Date: Mon,  3 Dec 2007 13:43:35 +0200
Message-Id: <11966822312882-git-send-email-tomas.winkler@intel.com> (sfid-20071203_114901_189335_F05DD45D)
In-Reply-To: <11966822311945-git-send-email-tomas.winkler@intel.com>
References: <11966822261109-git-send-email-tomas.winkler@intel.com>
 <11966822291406-git-send-email-tomas.winkler@intel.com>
 <1196682229843-git-send-email-tomas.winkler@intel.com>
 <11966822293932-git-send-email-tomas.winkler@intel.com>
 <11966822291956-git-send-email-tomas.winkler@intel.com>
 <119668222978-git-send-email-tomas.winkler@intel.com>
 <11966822293340-git-send-email-tomas.winkler@intel.com>
 <11966822291143-git-send-email-tomas.winkler@intel.com>
 <11966822301152-git-send-email-tomas.winkler@intel.com>
 <11966822302864-git-send-email-tomas.winkler@intel.com>
 <1196682230902-git-send-email-tomas.winkler@intel.com>
 <11966822302932-git-send-email-tomas.winkler@intel.com>
 <11966822302681-git-send-email-tomas.winkler@intel.com>
 <11966822301936-git-send-email-tomas.winkler@intel.com>
 <11966822302007-git-send-email-tomas.winkler@intel.com>
 <1196682230754-git-send-email-tomas.winkler@intel.com>
 <1196682231211-git-send-email-tomas.winkler@intel.com>
 <11966822313647-git-send-email-tomas.winkler@intel.com>
 <11966822312049-git-send-email-tomas.winkler@intel.com>
 <11966822311588-git-send-email-tomas.winkler@intel.com>
 <11966822314158-git-send-email-tomas.winkler@intel.com>
 <11966822311498-git-send-email-tomas.winkler@intel.com>
 <11966822311945-git-send-email-tomas.winkler@intel.com>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Cahill <ben.m.cahill@intel.com>

Document Rx registers

Document Tx circular buffer base registers

Signed-off-by: Ben Cahill <ben.m.cahill@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965-hw.h |  170 +++++++++++++++++++++++++++-
 1 files changed, 164 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-hw.h b/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
index cc348de..ab88c72 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
@@ -1286,7 +1286,7 @@ enum {
 /* Flow Handler Definitions */
 /****************************/
 
-/*
+/**
  * This I/O area is directly read/writable by driver (e.g. Linux uses writel())
  * Addresses are offsets from device's PCI hardware base address.
  */
@@ -1313,35 +1313,193 @@ enum {
 #define IWL_FH_KW_MEM_ADDR_REG		     (FH_MEM_LOWER_BOUND + 0x97C)
 
 
-/* CBBC Area - Circular buffers base address cache pointers table */
+/**
+ * TFD Circular Buffers Base (CBBC) addresses
+ *
+ * 4965 has 16 base pointer registers, one for each of 16 host-DRAM-resident
+ * circular buffers (CBs/queues) containing Transmit Frame Descriptors (TFDs)
+ * (see struct iwl_tfd_frame).  These 16 pointer registers are offset by 0x04
+ * bytes from one another.  Each TFD circular buffer in DRAM must be 256-byte
+ * aligned (address bits 0-7 must be 0).
+ *
+ * Bit fields in each pointer register:
+ *  27-0: TFD CB physical base address [35:8], must be 256-byte aligned
+ */
 #define FH_MEM_CBBC_LOWER_BOUND              (FH_MEM_LOWER_BOUND + 0x9D0)
 #define FH_MEM_CBBC_UPPER_BOUND              (FH_MEM_LOWER_BOUND + 0xA10)
-/* queues 0 - 15 */
+
+/* Find TFD CB base pointer for given queue (range 0-15). */
 #define FH_MEM_CBBC_QUEUE(x)  (FH_MEM_CBBC_LOWER_BOUND + (x) * 0x4)
 
-/* RSCSR Area */
+
+/**
+ * Rx SRAM Control and Status Registers (RSCSR)
+ *
+ * These registers provide handshake between driver and 4965 for the Rx queue
+ * (this queue handles *all* command responses, notifications, Rx data, etc.
+ * sent from 4965 uCode to host driver).  Unlike Tx, there is only one Rx
+ * queue, and only one Rx DMA/FIFO channel.  Also unlike Tx, which can
+ * concatenate up to 20 DRAM buffers to form a Tx frame, each Receive Buffer
+ * Descriptor (RBD) points to only one Rx Buffer (RB); there is a 1:1
+ * mapping between RBDs and RBs.
+ *
+ * Driver must allocate host DRAM memory for the following, and set the
+ * physical address of each into 4965 registers:
+ *
+ * 1)  Receive Buffer Descriptor (RBD) circular buffer (CB), typically with 256
+ *     entries (although any power of 2, up to 4096, is selectable by driver).
+ *     Each entry (1 dword) points to a receive buffer (RB) of consistent size
+ *     (typically 4K, although 8K or 16K are also selectable by driver).
+ *     Driver sets up RB size and number of RBDs in the CB via Rx config
+ *     register FH_MEM_RCSR_CHNL0_CONFIG_REG.
+ *
+ *     Bit fields within one RBD:
+ *     27-0:  Receive Buffer physical address bits [35:8], 256-byte aligned
+ *
+ *     Driver sets physical address [35:8] of base of RBD circular buffer
+ *     into FH_RSCSR_CHNL0_RBDCB_BASE_REG [27:0].
+ *
+ * 2)  Rx status buffer, 8 bytes, in which 4965 indicates which Rx Buffers
+ *     (RBs) have been filled, via a "write pointer", actually the index of
+ *     the RB's corresponding RBD within the circular buffer.  Driver sets
+ *     physical address [35:4] into FH_RSCSR_CHNL0_STTS_WPTR_REG [31:0].
+ *
+ *     Bit fields in lower dword of Rx status buffer (upper dword not used
+ *     by driver; see struct iwl4965_shared, val0):
+ *     31-12:  Not used by driver
+ *     11- 0:  Index of last filled Rx buffer descriptor
+ *             (4965 writes, driver reads this value)
+ *
+ * As the driver prepares Receive Buffers (RBs) for 4965 to fill, driver must
+ * enter pointers to these RBs into contiguous RBD circular buffer entries,
+ * and update the 4965's "write" index register, FH_RSCSR_CHNL0_RBDCB_WPTR_REG.
+ *
+ * This "write" index corresponds to the *next* RBD that the driver will make
+ * available, i.e. one RBD past the tail of the ready-to-fill RBDs within
+ * the circular buffer.  This value should initially be 0 (before preparing any
+ * RBs), should be 8 after preparing the first 8 RBs (for example), and must
+ * wrap back to 0 at the end of the circular buffer (but don't wrap before
+ * "read" index has advanced past 1!  See below).
+ * NOTE:  4965 EXPECTS THE WRITE INDEX TO BE INCREMENTED IN MULTIPLES OF 8.
+ *
+ * As the 4965 fills RBs (referenced from contiguous RBDs within the circular
+ * buffer), it updates the Rx status buffer in host DRAM, 2) described above,
+ * to tell the driver the index of the latest filled RBD.  The driver must
+ * read this "read" index from DRAM after receiving an Rx interrupt from 4965.
+ *
+ * The driver must also internally keep track of a third index, which is the
+ * next RBD to process.  When receiving an Rx interrupt, driver should process
+ * all filled but unprocessed RBs up to, but not including, the RB
+ * corresponding to the "read" index.  For example, if "read" index becomes "1",
+ * driver may process the RB pointed to by RBD 0.  Depending on volume of
+ * traffic, there may be many RBs to process.
+ *
+ * If read index == write index, 4965 thinks there is no room to put new data.
+ * Due to this, the maximum number of filled RBs is 255, instead of 256.  To
+ * be safe, make sure that there is a gap of at least 2 RBDs between "write"
+ * and "read" indexes; that is, make sure that there are no more than 254
+ * buffers waiting to be filled.
+ */
 #define FH_MEM_RSCSR_LOWER_BOUND	(FH_MEM_LOWER_BOUND + 0xBC0)
 #define FH_MEM_RSCSR_UPPER_BOUND	(FH_MEM_LOWER_BOUND + 0xC00)
 #define FH_MEM_RSCSR_CHNL0		(FH_MEM_RSCSR_LOWER_BOUND)
 
+/**
+ * Physical base address of 8-byte Rx Status buffer.
+ * Bit fields:
+ *  31-0: Rx status buffer physical base address [35:4], must 16-byte aligned.
+ */
 #define FH_RSCSR_CHNL0_STTS_WPTR_REG		(FH_MEM_RSCSR_CHNL0)
+
+/**
+ * Physical base address of Rx Buffer Descriptor Circular Buffer.
+ * Bit fields:
+ *  27-0:  RBD CD physical base address [35:8], must be 256-byte aligned.
+ */
 #define FH_RSCSR_CHNL0_RBDCB_BASE_REG		(FH_MEM_RSCSR_CHNL0 + 0x004)
+
+/**
+ * Rx write pointer (index, really!).
+ * Bit fields:
+ *  11-0:  Index of driver's most recent prepared-to-be-filled RBD, + 1.
+ *         NOTE:  For 256-entry circular buffer, use only bits [7:0].
+ */
 #define FH_RSCSR_CHNL0_RBDCB_WPTR_REG		(FH_MEM_RSCSR_CHNL0 + 0x008)
 
-/* RCSR Area - Registers address map */
+
+/**
+ * Rx Config/Status Registers (RCSR)
+ * Rx Config Reg for channel 0 (only channel used)
+ *
+ * Driver must initialize FH_MEM_RCSR_CHNL0_CONFIG_REG as follows for
+ * normal operation (see bit fields).
+ *
+ * Clearing FH_MEM_RCSR_CHNL0_CONFIG_REG to 0 turns off Rx DMA.
+ * Driver should poll FH_MEM_RSSR_RX_STATUS_REG	for
+ * FH_RSSR_CHNL0_RX_STATUS_CHNL_IDLE (bit 24) before continuing.
+ *
+ * Bit fields:
+ * 31-30: Rx DMA channel enable: '00' off/pause, '01' pause at end of frame,
+ *        '10' operate normally
+ * 29-24: reserved
+ * 23-20: # RBDs in circular buffer = 2^value; use "8" for 256 RBDs (normal),
+ *        min "5" for 32 RBDs, max "12" for 4096 RBDs.
+ * 19-18: reserved
+ * 17-16: size of each receive buffer; '00' 4K (normal), '01' 8K,
+ *        '10' 12K, '11' 16K.
+ * 15-14: reserved
+ * 13-12: IRQ destination; '00' none, '01' host driver (normal operation)
+ * 11- 4: timeout for closing Rx buffer and interrupting host (units 32 usec)
+ *        typical value 0x10 (about 1/2 msec)
+ *  3- 0: reserved
+ */
 #define FH_MEM_RCSR_LOWER_BOUND      (FH_MEM_LOWER_BOUND + 0xC00)
 #define FH_MEM_RCSR_UPPER_BOUND      (FH_MEM_LOWER_BOUND + 0xCC0)
 #define FH_MEM_RCSR_CHNL0            (FH_MEM_RCSR_LOWER_BOUND)
 
 #define FH_MEM_RCSR_CHNL0_CONFIG_REG	(FH_MEM_RCSR_CHNL0)
 
-/* RSSR Area - Rx shared ctrl & status registers */
+#define FH_RCSR_CHNL0_RX_CONFIG_RB_TIMEOUT_MASK   (0x00000FF0) /* bit 4-11 */
+#define FH_RCSR_CHNL0_RX_CONFIG_IRQ_DEST_MASK     (0x00001000) /* bit 12 */
+#define FH_RCSR_CHNL0_RX_CONFIG_SINGLE_FRAME_MASK (0x00008000) /* bit 15 */
+#define FH_RCSR_CHNL0_RX_CONFIG_RB_SIZE_MASK	  (0x00030000) /* bits 16-17 */
+#define FH_RCSR_CHNL0_RX_CONFIG_RBDBC_SIZE_MASK   (0x00F00000) /* bits 20-23 */
+#define FH_RCSR_CHNL0_RX_CONFIG_DMA_CHNL_EN_MASK  (0xC0000000) /* bits 30-31 */
+
+#define FH_RCSR_RX_CONFIG_RBDCB_SIZE_BITSHIFT	(20)
+#define FH_RCSR_RX_CONFIG_RB_SIZE_BITSHIFT	(16)
+
+#define FH_RCSR_RX_CONFIG_CHNL_EN_PAUSE_VAL         (0x00000000)
+#define FH_RCSR_RX_CONFIG_CHNL_EN_PAUSE_EOF_VAL     (0x40000000)
+#define FH_RCSR_RX_CONFIG_CHNL_EN_ENABLE_VAL        (0x80000000)
+
+#define IWL_FH_RCSR_RX_CONFIG_REG_VAL_RB_SIZE_4K    (0x00000000)
+
+#define FH_RCSR_CHNL0_RX_CONFIG_IRQ_DEST_NO_INT_VAL       (0x00000000)
+#define FH_RCSR_CHNL0_RX_CONFIG_IRQ_DEST_INT_HOST_VAL     (0x00001000)
+
+
+/**
+ * Rx Shared Status Registers (RSSR)
+ *
+ * After stopping Rx DMA channel (writing 0 to FH_MEM_RCSR_CHNL0_CONFIG_REG),
+ * driver must poll FH_MEM_RSSR_RX_STATUS_REG until Rx channel is idle.
+ *
+ * Bit fields:
+ *  24:  1 = Channel 0 is idle
+ *
+ * FH_MEM_RSSR_SHARED_CTRL_REG and FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV contain
+ * default values that should not be altered by the driver.
+ */
 #define FH_MEM_RSSR_LOWER_BOUND                	(FH_MEM_LOWER_BOUND + 0xC40)
 #define FH_MEM_RSSR_UPPER_BOUND               	(FH_MEM_LOWER_BOUND + 0xD00)
+
 #define FH_MEM_RSSR_SHARED_CTRL_REG           	(FH_MEM_RSSR_LOWER_BOUND)
 #define FH_MEM_RSSR_RX_STATUS_REG	(FH_MEM_RSSR_LOWER_BOUND + 0x004)
 #define FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV  (FH_MEM_RSSR_LOWER_BOUND + 0x008)
 
+#define FH_RSSR_CHNL0_RX_STATUS_CHNL_IDLE	(0x01000000)
+
 /* TCSR */
 #define IWL_FH_TCSR_LOWER_BOUND  (FH_MEM_LOWER_BOUND + 0xD00)
 #define IWL_FH_TCSR_UPPER_BOUND  (FH_MEM_LOWER_BOUND + 0xE60)
-- 
1.5.2.2
---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
