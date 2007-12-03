Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:31715 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753375AbXLCLsy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Dec 2007 06:48:54 -0500
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, yi.zhu@intel.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Ben Cahill <ben.m.cahill@intel.com>
Subject: [PATCH 24/34] iwlwifi: document shared Tx structures
Date: Mon,  3 Dec 2007 13:43:36 +0200
Message-Id: <11966822323269-git-send-email-tomas.winkler@intel.com> (sfid-20071203_114859_709650_25537487)
In-Reply-To: <11966822312882-git-send-email-tomas.winkler@intel.com>
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
 <11966822312882-git-send-email-tomas.winkler@intel.com>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Cahill <ben.m.cahill@intel.com>

Document shared Tx structures

Signed-off-by: Ben Cahill <ben.m.cahill@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965-hw.h |  147 +++++++++++++++++++++++++---
 1 files changed, 135 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-hw.h b/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
index ab88c72..85724e1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
@@ -452,6 +452,13 @@ struct iwl4965_eeprom {
  */
 #define CSR_HW_REV_WA_REG	(CSR_BASE+0x22C)
 
+/* Hardware interface configuration bits */
+#define CSR_HW_IF_CONFIG_REG_BIT_KEDRON_R	(0x00000010)
+#define CSR_HW_IF_CONFIG_REG_MSK_BOARD_VER	(0x00000C00)
+#define CSR_HW_IF_CONFIG_REG_BIT_MAC_SI		(0x00000100)
+#define CSR_HW_IF_CONFIG_REG_BIT_RADIO_SI	(0x00000200)
+#define CSR_HW_IF_CONFIG_REG_BIT_EEPROM_OWN_SEM (0x00200000)
+
 /* interrupt flags in INTA, set by uCode or hardware (e.g. dma),
  * acknowledged (reset) by host writing "1" to flagged bits. */
 #define CSR_INT_BIT_FH_RX        (1<<31) /* Rx DMA, cmd responses, FH_INT[17:16] */
@@ -1575,12 +1582,6 @@ enum {
 #define SCD_QUEUE_CTX_REG2_FRAME_LIMIT_POS	(16)
 #define SCD_QUEUE_CTX_REG2_FRAME_LIMIT_MSK	(0x007F0000)
 
-#define CSR_HW_IF_CONFIG_REG_BIT_KEDRON_R	(0x00000010)
-#define CSR_HW_IF_CONFIG_REG_MSK_BOARD_VER	(0x00000C00)
-#define CSR_HW_IF_CONFIG_REG_BIT_MAC_SI		(0x00000100)
-#define CSR_HW_IF_CONFIG_REG_BIT_RADIO_SI	(0x00000200)
-#define CSR_HW_IF_CONFIG_REG_BIT_EEPROM_OWN_SEM (0x00200000)
-
 static inline u8 iwl4965_hw_get_rate(__le32 rate_n_flags)
 {
 	return le32_to_cpu(rate_n_flags) & 0xFF;
@@ -1594,6 +1595,53 @@ static inline __le32 iwl4965_hw_set_rate_n_flags(u8 rate, u16 flags)
 	return cpu_to_le32(flags|(u16)rate);
 }
 
+
+/**
+ * Tx/Rx Queues
+ *
+ * Most communication between driver and 4965 is via queues of data buffers.
+ * For example, all commands that the driver issues to device's embedded
+ * controller (uCode) are via the command queue (one of the Tx queues).  All
+ * uCode command responses/replies/notifications, including Rx frames, are
+ * conveyed from uCode to driver via the Rx queue.
+ *
+ * Most support for these queues, including handshake support, resides in
+ * structures in host DRAM, shared between the driver and the device.  When
+ * allocating this memory, the driver must make sure that data written by
+ * the host CPU updates DRAM immediately (and does not get "stuck" in CPU's
+ * cache memory), so DRAM and cache are consistent, and the device can
+ * immediately see changes made by the driver.
+ *
+ * 4965 supports up to 16 DRAM-based Tx queues, and services these queues via
+ * up to 7 DMA channels (FIFOs).  Each Tx queue is supported by a circular array
+ * in DRAM containing 256 Transmit Frame Descriptors (TFDs).
+ */
+#define IWL4965_MAX_WIN_SIZE              64
+#define IWL4965_QUEUE_SIZE               256
+#define IWL4965_NUM_FIFOS                  7
+#define IWL_MAX_NUM_QUEUES                16
+
+
+/**
+ * struct iwl4965_tfd_frame_data
+ *
+ * Describes up to 2 buffers containing (contiguous) portions of a Tx frame.
+ * Each buffer must be on dword boundary.
+ * Up to 10 iwl_tfd_frame_data structures, describing up to 20 buffers,
+ * may be filled within a TFD (iwl_tfd_frame).
+ *
+ * Bit fields in tb1_addr:
+ * 31- 0: Tx buffer 1 address bits [31:0]
+ *
+ * Bit fields in val1:
+ * 31-16: Tx buffer 2 address bits [15:0]
+ * 15- 4: Tx buffer 1 length (bytes)
+ *  3- 0: Tx buffer 1 address bits [32:32]
+ *
+ * Bit fields in val2:
+ * 31-20: Tx buffer 2 length (bytes)
+ * 19- 0: Tx buffer 2 address bits [35:16]
+ */
 struct iwl4965_tfd_frame_data {
 	__le32 tb1_addr;
 
@@ -1622,6 +1670,35 @@ struct iwl4965_tfd_frame_data {
 #define IWL_tb2_len_SYM val2
 } __attribute__ ((packed));
 
+
+/**
+ * struct iwl4965_tfd_frame
+ *
+ * Transmit Frame Descriptor (TFD)
+ *
+ * 4965 supports up to 16 Tx queues resident in host DRAM.
+ * Each Tx queue uses a circular buffer of 256 TFDs stored in host DRAM.
+ * Both driver and device share these circular buffers, each of which must be
+ * contiguous 256 TFDs x 128 bytes-per-TFD = 32 KBytes for 4965.
+ *
+ * Driver must indicate the physical address of the base of each
+ * circular buffer via the 4965's FH_MEM_CBBC_QUEUE registers.
+ *
+ * Each TFD contains pointer/size information for up to 20 data buffers
+ * in host DRAM.  These buffers collectively contain the (one) frame described
+ * by the TFD.  Each buffer must be a single contiguous block of memory within
+ * itself, but buffers may be scattered in host DRAM.  Each buffer has max size
+ * of (4K - 4).  The 4965 concatenates all of a TFD's buffers into a single
+ * Tx frame, up to 8 KBytes in size.
+ *
+ * Bit fields in the control dword (val0):
+ * 31-30: # dwords (0-3) of padding required at end of frame for 16-byte bound
+ *    29: reserved
+ * 28-24: # Transmit Buffer Descriptors in TFD
+ * 23- 0: reserved
+ *
+ * A maximum of 255 (not 256!) TFDs may be on a queue waiting for Tx.
+ */
 struct iwl4965_tfd_frame {
 	__le32 val0;
 	/* __le32 rsvd1:24; */
@@ -1635,11 +1712,16 @@ struct iwl4965_tfd_frame {
 	__le32 reserved;
 } __attribute__ ((packed));
 
-#define IWL4965_MAX_WIN_SIZE              64
-#define IWL4965_QUEUE_SIZE               256
-#define IWL4965_NUM_FIFOS                  7
-#define IWL_MAX_NUM_QUEUES                16
 
+/**
+ * struct iwl4965_queue_byte_cnt_entry
+ *
+ * Byte Count Table Entry
+ *
+ * Bit fields:
+ * 15-12: reserved
+ * 11- 0: total to-be-transmitted byte count of frame (does not include command)
+ */
 struct iwl4965_queue_byte_cnt_entry {
 	__le16 val;
 	/* __le16 byte_cnt:12; */
@@ -1649,6 +1731,25 @@ struct iwl4965_queue_byte_cnt_entry {
 	/* __le16 rsvd:4; */
 } __attribute__ ((packed));
 
+
+/**
+ * struct iwl4965_sched_queue_byte_cnt_tbl
+ *
+ * Byte Count table
+ *
+ * Each Tx queue uses a byte-count table containing 320 entries:
+ * one 16-bit entry for each of 256 TFDs, plus an additional 64 entries that
+ * duplicate the first 64 entries (to avoid wrap-around within a Tx window;
+ * max Tx window is 64 TFDs).
+ *
+ * When driver sets up a new TFD, it must also enter the total byte count
+ * of the frame to be transmitted into the corresponding entry in the byte
+ * count table for the chosen Tx queue.  If the TFD index is 0-63, the driver
+ * must duplicate the byte count entry in corresponding index 256-319.
+ *
+ * "dont_care" padding puts each byte count table on a 1024-byte boundary;
+ * 4965 assumes tables are separated by 1024 bytes.
+ */
 struct iwl4965_sched_queue_byte_cnt_tbl {
 	struct iwl4965_queue_byte_cnt_entry tfd_offset[IWL4965_QUEUE_SIZE +
 						       IWL4965_MAX_WIN_SIZE];
@@ -1657,8 +1758,30 @@ struct iwl4965_sched_queue_byte_cnt_tbl {
 		     sizeof(__le16)];
 } __attribute__ ((packed));
 
-/* Base physical address of iwl4965_shared is provided to KDR_SCD_DRAM_BASE_ADDR
- * and &iwl4965_shared.val0 is provided to FH_RSCSR_CHNL0_STTS_WPTR_REG */
+
+/**
+ * struct iwl4965_shared - handshake area for Tx and Rx
+ *
+ * For convenience in allocating memory, this structure combines 2 areas of
+ * DRAM which must be shared between driver and 4965.  These do not need to
+ * be combined, if better allocation would result from keeping them separate:
+ *
+ * 1)  The Tx byte count tables occupy 1024 bytes each (16 KBytes total for
+ *     16 queues).  Driver uses SCD_DRAM_BASE_ADDR to tell 4965 where to find
+ *     the first of these tables.  4965 assumes tables are 1024 bytes apart.
+ *
+ * 2)  The Rx status (val0 and val1) occupies only 8 bytes.  Driver uses
+ *     FH_RSCSR_CHNL0_STTS_WPTR_REG to tell 4965 where to find this area.
+ *     Driver reads val0 to determine the latest Receive Buffer Descriptor (RBD)
+ *     that has been filled by the 4965.
+ *
+ * Bit fields val0:
+ * 31-12:  Not used
+ * 11- 0:  Index of last filled Rx buffer descriptor (4965 writes, driver reads)
+ *
+ * Bit fields val1:
+ * 31- 0:  Not used
+ */
 struct iwl4965_shared {
 	struct iwl4965_sched_queue_byte_cnt_tbl
 	 queues_byte_cnt_tbls[IWL_MAX_NUM_QUEUES];
-- 
1.5.2.2
---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
