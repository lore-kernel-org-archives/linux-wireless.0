Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:48720 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757409Ab1DHPuO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Apr 2011 11:50:14 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 11/16] iwlagn: more cleanup to remove unused reference
Date: Fri,  8 Apr 2011 08:30:31 -0700
Message-Id: <1302276636-12802-12-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1302276636-12802-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1302276636-12802-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

More cleanup code, no functional changes

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-fh.h   |   35 +++++++++++++++----------------
 drivers/net/wireless/iwlwifi/iwl-prph.h |   16 ++-----------
 drivers/net/wireless/iwlwifi/iwl-tx.c   |    1 -
 3 files changed, 20 insertions(+), 32 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-fh.h b/drivers/net/wireless/iwlwifi/iwl-fh.h
index 0f1052f..b90924e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fh.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fh.h
@@ -77,14 +77,14 @@
 /**
  * Keep-Warm (KW) buffer base address.
  *
- * Driver must allocate a 4KByte buffer that is used by 4965 for keeping the
+ * Driver must allocate a 4KByte buffer that is for keeping the
  * host DRAM powered on (via dummy accesses to DRAM) to maintain low-latency
- * DRAM access when 4965 is Txing or Rxing.  The dummy accesses prevent host
+ * DRAM access when doing Txing or Rxing.  The dummy accesses prevent host
  * from going into a power-savings mode that would cause higher DRAM latency,
  * and possible data over/under-runs, before all Tx/Rx is complete.
  *
  * Driver loads FH_KW_MEM_ADDR_REG with the physical address (bits 35:4)
- * of the buffer, which must be 4K aligned.  Once this is set up, the 4965
+ * of the buffer, which must be 4K aligned.  Once this is set up, the device
  * automatically invokes keep-warm accesses when normal accesses might not
  * be sufficient to maintain fast DRAM response.
  *
@@ -97,7 +97,7 @@
 /**
  * TFD Circular Buffers Base (CBBC) addresses
  *
- * 4965 has 16 base pointer registers, one for each of 16 host-DRAM-resident
+ * Device has 16 base pointer registers, one for each of 16 host-DRAM-resident
  * circular buffers (CBs/queues) containing Transmit Frame Descriptors (TFDs)
  * (see struct iwl_tfd_frame).  These 16 pointer registers are offset by 0x04
  * bytes from one another.  Each TFD circular buffer in DRAM must be 256-byte
@@ -116,16 +116,16 @@
 /**
  * Rx SRAM Control and Status Registers (RSCSR)
  *
- * These registers provide handshake between driver and 4965 for the Rx queue
+ * These registers provide handshake between driver and device for the Rx queue
  * (this queue handles *all* command responses, notifications, Rx data, etc.
- * sent from 4965 uCode to host driver).  Unlike Tx, there is only one Rx
+ * sent from uCode to host driver).  Unlike Tx, there is only one Rx
  * queue, and only one Rx DMA/FIFO channel.  Also unlike Tx, which can
  * concatenate up to 20 DRAM buffers to form a Tx frame, each Receive Buffer
  * Descriptor (RBD) points to only one Rx Buffer (RB); there is a 1:1
  * mapping between RBDs and RBs.
  *
  * Driver must allocate host DRAM memory for the following, and set the
- * physical address of each into 4965 registers:
+ * physical address of each into device registers:
  *
  * 1)  Receive Buffer Descriptor (RBD) circular buffer (CB), typically with 256
  *     entries (although any power of 2, up to 4096, is selectable by driver).
@@ -140,20 +140,20 @@
  *     Driver sets physical address [35:8] of base of RBD circular buffer
  *     into FH_RSCSR_CHNL0_RBDCB_BASE_REG [27:0].
  *
- * 2)  Rx status buffer, 8 bytes, in which 4965 indicates which Rx Buffers
+ * 2)  Rx status buffer, 8 bytes, in which uCode indicates which Rx Buffers
  *     (RBs) have been filled, via a "write pointer", actually the index of
  *     the RB's corresponding RBD within the circular buffer.  Driver sets
  *     physical address [35:4] into FH_RSCSR_CHNL0_STTS_WPTR_REG [31:0].
  *
  *     Bit fields in lower dword of Rx status buffer (upper dword not used
- *     by driver; see struct iwl4965_shared, val0):
+ *     by driver:
  *     31-12:  Not used by driver
  *     11- 0:  Index of last filled Rx buffer descriptor
- *             (4965 writes, driver reads this value)
+ *             (device writes, driver reads this value)
  *
- * As the driver prepares Receive Buffers (RBs) for 4965 to fill, driver must
+ * As the driver prepares Receive Buffers (RBs) for device to fill, driver must
  * enter pointers to these RBs into contiguous RBD circular buffer entries,
- * and update the 4965's "write" index register,
+ * and update the device's "write" index register,
  * FH_RSCSR_CHNL0_RBDCB_WPTR_REG.
  *
  * This "write" index corresponds to the *next* RBD that the driver will make
@@ -162,12 +162,12 @@
  * RBs), should be 8 after preparing the first 8 RBs (for example), and must
  * wrap back to 0 at the end of the circular buffer (but don't wrap before
  * "read" index has advanced past 1!  See below).
- * NOTE:  4965 EXPECTS THE WRITE INDEX TO BE INCREMENTED IN MULTIPLES OF 8.
+ * NOTE:  DEVICE EXPECTS THE WRITE INDEX TO BE INCREMENTED IN MULTIPLES OF 8.
  *
- * As the 4965 fills RBs (referenced from contiguous RBDs within the circular
+ * As the device fills RBs (referenced from contiguous RBDs within the circular
  * buffer), it updates the Rx status buffer in host DRAM, 2) described above,
  * to tell the driver the index of the latest filled RBD.  The driver must
- * read this "read" index from DRAM after receiving an Rx interrupt from 4965.
+ * read this "read" index from DRAM after receiving an Rx interrupt from device
  *
  * The driver must also internally keep track of a third index, which is the
  * next RBD to process.  When receiving an Rx interrupt, driver should process
@@ -176,7 +176,7 @@
  * driver may process the RB pointed to by RBD 0.  Depending on volume of
  * traffic, there may be many RBs to process.
  *
- * If read index == write index, 4965 thinks there is no room to put new data.
+ * If read index == write index, device thinks there is no room to put new data.
  * Due to this, the maximum number of filled RBs is 255, instead of 256.  To
  * be safe, make sure that there is a gap of at least 2 RBDs between "write"
  * and "read" indexes; that is, make sure that there are no more than 254
@@ -303,7 +303,7 @@
 /**
  * Transmit DMA Channel Control/Status Registers (TCSR)
  *
- * 4965 has one configuration register for each of 8 Tx DMA/FIFO channels
+ * Device has one configuration register for each of 8 Tx DMA/FIFO channels
  * supported in hardware (don't confuse these with the 16 Tx queues in DRAM,
  * which feed the DMA/FIFO channels); config regs are separated by 0x20 bytes.
  *
@@ -326,7 +326,6 @@
 #define FH_TCSR_UPPER_BOUND  (FH_MEM_LOWER_BOUND + 0xE60)
 
 /* Find Control/Status reg for given Tx DMA/FIFO channel */
-#define FH49_TCSR_CHNL_NUM                            (7)
 #define FH50_TCSR_CHNL_NUM                            (8)
 
 /* TCSR: tx_config register values */
diff --git a/drivers/net/wireless/iwlwifi/iwl-prph.h b/drivers/net/wireless/iwlwifi/iwl-prph.h
index c960195..f00d188 100644
--- a/drivers/net/wireless/iwlwifi/iwl-prph.h
+++ b/drivers/net/wireless/iwlwifi/iwl-prph.h
@@ -107,17 +107,7 @@
  * device.  A queue maps to only one (selectable by driver) Tx DMA channel,
  * but one DMA channel may take input from several queues.
  *
- * Tx DMA FIFOs have dedicated purposes.  For 4965, they are used as follows
- * (cf. default_queue_to_tx_fifo in iwl-4965.c):
- *
- * 0 -- EDCA BK (background) frames, lowest priority
- * 1 -- EDCA BE (best effort) frames, normal priority
- * 2 -- EDCA VI (video) frames, higher priority
- * 3 -- EDCA VO (voice) and management frames, highest priority
- * 4 -- Commands (e.g. RXON, etc.)
- * 5 -- unused (HCCA)
- * 6 -- unused (HCCA)
- * 7 -- not used by driver (device-internal only)
+ * Tx DMA FIFOs have dedicated purposes.
  *
  * For 5000 series and up, they are used differently
  * (cf. iwl5000_default_queue_to_tx_fifo in iwl-5000.c):
@@ -151,7 +141,7 @@
  *     Tx completion may end up being out-of-order).
  *
  *     The driver must maintain the queue's Byte Count table in host DRAM
- *     (struct iwl4965_sched_queue_byte_cnt_tbl) for this mode.
+ *     for this mode.
  *     This mode does not support fragmentation.
  *
  * 2)  FIFO (a.k.a. non-Scheduler-ACK), in which each TFD is processed in order.
@@ -164,7 +154,7 @@
  *
  * Driver controls scheduler operation via 3 means:
  * 1)  Scheduler registers
- * 2)  Shared scheduler data base in internal 4956 SRAM
+ * 2)  Shared scheduler data base in internal SRAM
  * 3)  Shared data in host DRAM
  *
  * Initialization:
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 565980f..3732380 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -232,7 +232,6 @@ void iwl_cmd_queue_free(struct iwl_priv *priv)
  * reclaiming packets (on 'tx done IRQ), if free space become > high mark,
  * Tx queue resumed.
  *
- * See more detailed info in iwl-4965-hw.h.
  ***************************************************/
 
 int iwl_queue_space(const struct iwl_queue *q)
-- 
1.7.0.4

