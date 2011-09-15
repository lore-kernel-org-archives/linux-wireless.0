Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:18631 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934540Ab1IOTcJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Sep 2011 15:32:09 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 15/27] iwlagn: move PCI-E transport files
Date: Thu, 15 Sep 2011 11:46:42 -0700
Message-Id: <1316112414-6341-16-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110915_213245_334646_CFA1FA6A)
In-Reply-To: <1316112414-6341-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1316112414-6341-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Move all the PCI-E specific transport files to
be iwl-trans-pcie*; specifically iwl-trans.c
which is really iwl-trans-pcie.c.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/Makefile             |    2 +-
 drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h |  448 -----
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h |  448 +++++
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c  | 1424 +++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c  | 1166 ++++++++++++
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c     | 1996 ++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c  | 1424 ---------------
 drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c  | 1165 ------------
 drivers/net/wireless/iwlwifi/iwl-trans.c          | 1998 ---------------------
 9 files changed, 5035 insertions(+), 5036 deletions(-)
 delete mode 100644 drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
 delete mode 100644 drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c
 delete mode 100644 drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c
 delete mode 100644 drivers/net/wireless/iwlwifi/iwl-trans.c

diff --git a/drivers/net/wireless/iwlwifi/Makefile b/drivers/net/wireless/iwlwifi/Makefile
index ae1d816..6104f19 100644
--- a/drivers/net/wireless/iwlwifi/Makefile
+++ b/drivers/net/wireless/iwlwifi/Makefile
@@ -14,7 +14,7 @@ iwlagn-objs             += iwl-6000.o
 iwlagn-objs             += iwl-1000.o
 iwlagn-objs             += iwl-2000.o
 iwlagn-objs             += iwl-pci.o
-iwlagn-objs             += iwl-trans.o iwl-trans-rx-pcie.o iwl-trans-tx-pcie.o
+iwlagn-objs             += iwl-trans-pcie.o iwl-trans-pcie-rx.o iwl-trans-pcie-tx.o
 
 iwlagn-$(CONFIG_IWLWIFI_DEBUGFS) += iwl-debugfs.o
 iwlagn-$(CONFIG_IWLWIFI_DEVICE_TRACING) += iwl-devtrace.o
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h b/drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h
deleted file mode 100644
index 49cd5a7..0000000
--- a/drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h
+++ /dev/null
@@ -1,448 +0,0 @@
-/******************************************************************************
- *
- * Copyright(c) 2003 - 2011 Intel Corporation. All rights reserved.
- *
- * Portions of this file are derived from the ipw3945 project, as well
- * as portions of the ieee80211 subsystem header files.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of version 2 of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- * more details.
- *
- * You should have received a copy of the GNU General Public License along with
- * this program; if not, write to the Free Software Foundation, Inc.,
- * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
- *
- * The full GNU General Public License is included in this distribution in the
- * file called LICENSE.
- *
- * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
- * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
- *
- *****************************************************************************/
-#ifndef __iwl_trans_int_pcie_h__
-#define __iwl_trans_int_pcie_h__
-
-#include <linux/spinlock.h>
-#include <linux/interrupt.h>
-#include <linux/skbuff.h>
-#include <linux/pci.h>
-
-#include "iwl-fh.h"
-#include "iwl-csr.h"
-#include "iwl-shared.h"
-#include "iwl-trans.h"
-#include "iwl-debug.h"
-#include "iwl-io.h"
-
-struct iwl_tx_queue;
-struct iwl_queue;
-struct iwl_host_cmd;
-
-/*This file includes the declaration that are internal to the
- * trans_pcie layer */
-
-/**
- * struct isr_statistics - interrupt statistics
- *
- */
-struct isr_statistics {
-	u32 hw;
-	u32 sw;
-	u32 err_code;
-	u32 sch;
-	u32 alive;
-	u32 rfkill;
-	u32 ctkill;
-	u32 wakeup;
-	u32 rx;
-	u32 tx;
-	u32 unhandled;
-};
-
-/**
- * struct iwl_rx_queue - Rx queue
- * @bd: driver's pointer to buffer of receive buffer descriptors (rbd)
- * @bd_dma: bus address of buffer of receive buffer descriptors (rbd)
- * @pool:
- * @queue:
- * @read: Shared index to newest available Rx buffer
- * @write: Shared index to oldest written Rx packet
- * @free_count: Number of pre-allocated buffers in rx_free
- * @write_actual:
- * @rx_free: list of free SKBs for use
- * @rx_used: List of Rx buffers with no SKB
- * @need_update: flag to indicate we need to update read/write index
- * @rb_stts: driver's pointer to receive buffer status
- * @rb_stts_dma: bus address of receive buffer status
- * @lock:
- *
- * NOTE:  rx_free and rx_used are used as a FIFO for iwl_rx_mem_buffers
- */
-struct iwl_rx_queue {
-	__le32 *bd;
-	dma_addr_t bd_dma;
-	struct iwl_rx_mem_buffer pool[RX_QUEUE_SIZE + RX_FREE_BUFFERS];
-	struct iwl_rx_mem_buffer *queue[RX_QUEUE_SIZE];
-	u32 read;
-	u32 write;
-	u32 free_count;
-	u32 write_actual;
-	struct list_head rx_free;
-	struct list_head rx_used;
-	int need_update;
-	struct iwl_rb_status *rb_stts;
-	dma_addr_t rb_stts_dma;
-	spinlock_t lock;
-};
-
-struct iwl_dma_ptr {
-	dma_addr_t dma;
-	void *addr;
-	size_t size;
-};
-
-/*
- * This queue number is required for proper operation
- * because the ucode will stop/start the scheduler as
- * required.
- */
-#define IWL_IPAN_MCAST_QUEUE		8
-
-struct iwl_cmd_meta {
-	/* only for SYNC commands, iff the reply skb is wanted */
-	struct iwl_host_cmd *source;
-	/*
-	 * only for ASYNC commands
-	 * (which is somewhat stupid -- look at iwl-sta.c for instance
-	 * which duplicates a bunch of code because the callback isn't
-	 * invoked for SYNC commands, if it were and its result passed
-	 * through it would be simpler...)
-	 */
-	void (*callback)(struct iwl_shared *shrd,
-			 struct iwl_device_cmd *cmd,
-			 struct iwl_rx_packet *pkt);
-
-	u32 flags;
-
-	DEFINE_DMA_UNMAP_ADDR(mapping);
-	DEFINE_DMA_UNMAP_LEN(len);
-};
-
-/*
- * Generic queue structure
- *
- * Contains common data for Rx and Tx queues.
- *
- * Note the difference between n_bd and n_window: the hardware
- * always assumes 256 descriptors, so n_bd is always 256 (unless
- * there might be HW changes in the future). For the normal TX
- * queues, n_window, which is the size of the software queue data
- * is also 256; however, for the command queue, n_window is only
- * 32 since we don't need so many commands pending. Since the HW
- * still uses 256 BDs for DMA though, n_bd stays 256. As a result,
- * the software buffers (in the variables @meta, @txb in struct
- * iwl_tx_queue) only have 32 entries, while the HW buffers (@tfds
- * in the same struct) have 256.
- * This means that we end up with the following:
- *  HW entries: | 0 | ... | N * 32 | ... | N * 32 + 31 | ... | 255 |
- *  SW entries:           | 0      | ... | 31          |
- * where N is a number between 0 and 7. This means that the SW
- * data is a window overlayed over the HW queue.
- */
-struct iwl_queue {
-	int n_bd;              /* number of BDs in this queue */
-	int write_ptr;       /* 1-st empty entry (index) host_w*/
-	int read_ptr;         /* last used entry (index) host_r*/
-	/* use for monitoring and recovering the stuck queue */
-	dma_addr_t dma_addr;   /* physical addr for BD's */
-	int n_window;	       /* safe queue window */
-	u32 id;
-	int low_mark;	       /* low watermark, resume queue if free
-				* space more than this */
-	int high_mark;         /* high watermark, stop queue if free
-				* space less than this */
-};
-
-/**
- * struct iwl_tx_queue - Tx Queue for DMA
- * @q: generic Rx/Tx queue descriptor
- * @bd: base of circular buffer of TFDs
- * @cmd: array of command/TX buffer pointers
- * @meta: array of meta data for each command/tx buffer
- * @dma_addr_cmd: physical address of cmd/tx buffer array
- * @txb: array of per-TFD driver data
- * @time_stamp: time (in jiffies) of last read_ptr change
- * @need_update: indicates need to update read/write index
- * @sched_retry: indicates queue is high-throughput aggregation (HT AGG) enabled
- * @sta_id: valid if sched_retry is set
- * @tid: valid if sched_retry is set
- *
- * A Tx queue consists of circular buffer of BDs (a.k.a. TFDs, transmit frame
- * descriptors) and required locking structures.
- */
-#define TFD_TX_CMD_SLOTS 256
-#define TFD_CMD_SLOTS 32
-
-struct iwl_tx_queue {
-	struct iwl_queue q;
-	struct iwl_tfd *tfds;
-	struct iwl_device_cmd **cmd;
-	struct iwl_cmd_meta *meta;
-	struct sk_buff **skbs;
-	unsigned long time_stamp;
-	u8 need_update;
-	u8 sched_retry;
-	u8 active;
-	u8 swq_id;
-
-	u16 sta_id;
-	u16 tid;
-};
-
-/**
- * struct iwl_trans_pcie - PCIe transport specific data
- * @rxq: all the RX queue data
- * @rx_replenish: work that will be called when buffers need to be allocated
- * @trans: pointer to the generic transport area
- * @scd_base_addr: scheduler sram base address in SRAM
- * @scd_bc_tbls: pointer to the byte count table of the scheduler
- * @kw: keep warm address
- * @ac_to_fifo: to what fifo is a specifc AC mapped ?
- * @ac_to_queue: to what tx queue  is a specifc AC mapped ?
- * @mcast_queue:
- * @txq: Tx DMA processing queues
- * @txq_ctx_active_msk: what queue is active
- * queue_stopped: tracks what queue is stopped
- * queue_stop_count: tracks what SW queue is stopped
- */
-struct iwl_trans_pcie {
-	struct iwl_rx_queue rxq;
-	struct work_struct rx_replenish;
-	struct iwl_trans *trans;
-
-	/* INT ICT Table */
-	__le32 *ict_tbl;
-	void *ict_tbl_vir;
-	dma_addr_t ict_tbl_dma;
-	dma_addr_t aligned_ict_tbl_dma;
-	int ict_index;
-	u32 inta;
-	bool use_ict;
-	struct tasklet_struct irq_tasklet;
-	struct isr_statistics isr_stats;
-
-	u32 inta_mask;
-	u32 scd_base_addr;
-	struct iwl_dma_ptr scd_bc_tbls;
-	struct iwl_dma_ptr kw;
-
-	const u8 *ac_to_fifo[NUM_IWL_RXON_CTX];
-	const u8 *ac_to_queue[NUM_IWL_RXON_CTX];
-	u8 mcast_queue[NUM_IWL_RXON_CTX];
-
-	struct iwl_tx_queue *txq;
-	unsigned long txq_ctx_active_msk;
-#define IWL_MAX_HW_QUEUES	32
-	unsigned long queue_stopped[BITS_TO_LONGS(IWL_MAX_HW_QUEUES)];
-	atomic_t queue_stop_count[4];
-};
-
-#define IWL_TRANS_GET_PCIE_TRANS(_iwl_trans) \
-	((struct iwl_trans_pcie *) ((_iwl_trans)->trans_specific))
-
-/*****************************************************
-* RX
-******************************************************/
-void iwl_bg_rx_replenish(struct work_struct *data);
-void iwl_irq_tasklet(struct iwl_trans *trans);
-void iwlagn_rx_replenish(struct iwl_trans *trans);
-void iwl_rx_queue_update_write_ptr(struct iwl_trans *trans,
-			struct iwl_rx_queue *q);
-
-/*****************************************************
-* ICT
-******************************************************/
-int iwl_reset_ict(struct iwl_trans *trans);
-void iwl_disable_ict(struct iwl_trans *trans);
-int iwl_alloc_isr_ict(struct iwl_trans *trans);
-void iwl_free_isr_ict(struct iwl_trans *trans);
-irqreturn_t iwl_isr_ict(int irq, void *data);
-
-/*****************************************************
-* TX / HCMD
-******************************************************/
-void iwl_txq_update_write_ptr(struct iwl_trans *trans,
-			struct iwl_tx_queue *txq);
-int iwlagn_txq_attach_buf_to_tfd(struct iwl_trans *trans,
-				 struct iwl_tx_queue *txq,
-				 dma_addr_t addr, u16 len, u8 reset);
-int iwl_queue_init(struct iwl_queue *q, int count, int slots_num, u32 id);
-int iwl_trans_pcie_send_cmd(struct iwl_trans *trans, struct iwl_host_cmd *cmd);
-int __must_check iwl_trans_pcie_send_cmd_pdu(struct iwl_trans *trans, u8 id,
-			u32 flags, u16 len, const void *data);
-void iwl_tx_cmd_complete(struct iwl_trans *trans,
-			 struct iwl_rx_mem_buffer *rxb);
-void iwl_trans_txq_update_byte_cnt_tbl(struct iwl_trans *trans,
-					   struct iwl_tx_queue *txq,
-					   u16 byte_cnt);
-void iwl_trans_pcie_txq_agg_disable(struct iwl_trans *trans, int txq_id);
-int iwl_trans_pcie_tx_agg_disable(struct iwl_trans *trans,
-				  enum iwl_rxon_context_id ctx, int sta_id,
-				  int tid);
-void iwl_trans_set_wr_ptrs(struct iwl_trans *trans, int txq_id, u32 index);
-void iwl_trans_tx_queue_set_status(struct iwl_trans *trans,
-			     struct iwl_tx_queue *txq,
-			     int tx_fifo_id, int scd_retry);
-int iwl_trans_pcie_tx_agg_alloc(struct iwl_trans *trans,
-				enum iwl_rxon_context_id ctx, int sta_id,
-				int tid, u16 *ssn);
-void iwl_trans_pcie_tx_agg_setup(struct iwl_trans *trans,
-				 enum iwl_rxon_context_id ctx,
-				 int sta_id, int tid, int frame_limit);
-void iwlagn_txq_free_tfd(struct iwl_trans *trans, struct iwl_tx_queue *txq,
-	int index, enum dma_data_direction dma_dir);
-int iwl_tx_queue_reclaim(struct iwl_trans *trans, int txq_id, int index,
-			 struct sk_buff_head *skbs);
-int iwl_queue_space(const struct iwl_queue *q);
-
-/*****************************************************
-* Error handling
-******************************************************/
-int iwl_dump_nic_event_log(struct iwl_trans *trans, bool full_log,
-			    char **buf, bool display);
-int iwl_dump_fh(struct iwl_trans *trans, char **buf, bool display);
-void iwl_dump_csr(struct iwl_trans *trans);
-
-/*****************************************************
-* Helpers
-******************************************************/
-static inline void iwl_disable_interrupts(struct iwl_trans *trans)
-{
-	clear_bit(STATUS_INT_ENABLED, &trans->shrd->status);
-
-	/* disable interrupts from uCode/NIC to host */
-	iwl_write32(bus(trans), CSR_INT_MASK, 0x00000000);
-
-	/* acknowledge/clear/reset any interrupts still pending
-	 * from uCode or flow handler (Rx/Tx DMA) */
-	iwl_write32(bus(trans), CSR_INT, 0xffffffff);
-	iwl_write32(bus(trans), CSR_FH_INT_STATUS, 0xffffffff);
-	IWL_DEBUG_ISR(trans, "Disabled interrupts\n");
-}
-
-static inline void iwl_enable_interrupts(struct iwl_trans *trans)
-{
-	struct iwl_trans_pcie *trans_pcie =
-		IWL_TRANS_GET_PCIE_TRANS(trans);
-
-	IWL_DEBUG_ISR(trans, "Enabling interrupts\n");
-	set_bit(STATUS_INT_ENABLED, &trans->shrd->status);
-	iwl_write32(bus(trans), CSR_INT_MASK, trans_pcie->inta_mask);
-}
-
-/*
- * we have 8 bits used like this:
- *
- * 7 6 5 4 3 2 1 0
- * | | | | | | | |
- * | | | | | | +-+-------- AC queue (0-3)
- * | | | | | |
- * | +-+-+-+-+------------ HW queue ID
- * |
- * +---------------------- unused
- */
-static inline void iwl_set_swq_id(struct iwl_tx_queue *txq, u8 ac, u8 hwq)
-{
-	BUG_ON(ac > 3);   /* only have 2 bits */
-	BUG_ON(hwq > 31); /* only use 5 bits */
-
-	txq->swq_id = (hwq << 2) | ac;
-}
-
-static inline void iwl_wake_queue(struct iwl_trans *trans,
-				  struct iwl_tx_queue *txq)
-{
-	u8 queue = txq->swq_id;
-	u8 ac = queue & 3;
-	u8 hwq = (queue >> 2) & 0x1f;
-	struct iwl_trans_pcie *trans_pcie =
-		IWL_TRANS_GET_PCIE_TRANS(trans);
-
-	if (test_and_clear_bit(hwq, trans_pcie->queue_stopped))
-		if (atomic_dec_return(&trans_pcie->queue_stop_count[ac]) <= 0)
-			iwl_wake_sw_queue(priv(trans), ac);
-}
-
-static inline void iwl_stop_queue(struct iwl_trans *trans,
-				  struct iwl_tx_queue *txq)
-{
-	u8 queue = txq->swq_id;
-	u8 ac = queue & 3;
-	u8 hwq = (queue >> 2) & 0x1f;
-	struct iwl_trans_pcie *trans_pcie =
-		IWL_TRANS_GET_PCIE_TRANS(trans);
-
-	if (!test_and_set_bit(hwq, trans_pcie->queue_stopped))
-		if (atomic_inc_return(&trans_pcie->queue_stop_count[ac]) > 0)
-			iwl_stop_sw_queue(priv(trans), ac);
-}
-
-#ifdef ieee80211_stop_queue
-#undef ieee80211_stop_queue
-#endif
-
-#define ieee80211_stop_queue DO_NOT_USE_ieee80211_stop_queue
-
-#ifdef ieee80211_wake_queue
-#undef ieee80211_wake_queue
-#endif
-
-#define ieee80211_wake_queue DO_NOT_USE_ieee80211_wake_queue
-
-static inline void iwl_txq_ctx_activate(struct iwl_trans_pcie *trans_pcie,
-					int txq_id)
-{
-	set_bit(txq_id, &trans_pcie->txq_ctx_active_msk);
-}
-
-static inline void iwl_txq_ctx_deactivate(struct iwl_trans_pcie *trans_pcie,
-					  int txq_id)
-{
-	clear_bit(txq_id, &trans_pcie->txq_ctx_active_msk);
-}
-
-static inline int iwl_queue_used(const struct iwl_queue *q, int i)
-{
-	return q->write_ptr >= q->read_ptr ?
-		(i >= q->read_ptr && i < q->write_ptr) :
-		!(i < q->read_ptr && i >= q->write_ptr);
-}
-
-static inline u8 get_cmd_index(struct iwl_queue *q, u32 index)
-{
-	return index & (q->n_window - 1);
-}
-
-#define IWL_TX_FIFO_BK		0	/* shared */
-#define IWL_TX_FIFO_BE		1
-#define IWL_TX_FIFO_VI		2	/* shared */
-#define IWL_TX_FIFO_VO		3
-#define IWL_TX_FIFO_BK_IPAN	IWL_TX_FIFO_BK
-#define IWL_TX_FIFO_BE_IPAN	4
-#define IWL_TX_FIFO_VI_IPAN	IWL_TX_FIFO_VI
-#define IWL_TX_FIFO_VO_IPAN	5
-/* re-uses the VO FIFO, uCode will properly flush/schedule */
-#define IWL_TX_FIFO_AUX		5
-#define IWL_TX_FIFO_UNUSED	-1
-
-/* AUX (TX during scan dwell) queue */
-#define IWL_AUX_QUEUE		10
-
-#endif /* __iwl_trans_int_pcie_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
new file mode 100644
index 0000000..49cd5a7
--- /dev/null
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
@@ -0,0 +1,448 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2003 - 2011 Intel Corporation. All rights reserved.
+ *
+ * Portions of this file are derived from the ipw3945 project, as well
+ * as portions of the ieee80211 subsystem header files.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
+ *
+ * The full GNU General Public License is included in this distribution in the
+ * file called LICENSE.
+ *
+ * Contact Information:
+ *  Intel Linux Wireless <ilw@linux.intel.com>
+ * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
+ *
+ *****************************************************************************/
+#ifndef __iwl_trans_int_pcie_h__
+#define __iwl_trans_int_pcie_h__
+
+#include <linux/spinlock.h>
+#include <linux/interrupt.h>
+#include <linux/skbuff.h>
+#include <linux/pci.h>
+
+#include "iwl-fh.h"
+#include "iwl-csr.h"
+#include "iwl-shared.h"
+#include "iwl-trans.h"
+#include "iwl-debug.h"
+#include "iwl-io.h"
+
+struct iwl_tx_queue;
+struct iwl_queue;
+struct iwl_host_cmd;
+
+/*This file includes the declaration that are internal to the
+ * trans_pcie layer */
+
+/**
+ * struct isr_statistics - interrupt statistics
+ *
+ */
+struct isr_statistics {
+	u32 hw;
+	u32 sw;
+	u32 err_code;
+	u32 sch;
+	u32 alive;
+	u32 rfkill;
+	u32 ctkill;
+	u32 wakeup;
+	u32 rx;
+	u32 tx;
+	u32 unhandled;
+};
+
+/**
+ * struct iwl_rx_queue - Rx queue
+ * @bd: driver's pointer to buffer of receive buffer descriptors (rbd)
+ * @bd_dma: bus address of buffer of receive buffer descriptors (rbd)
+ * @pool:
+ * @queue:
+ * @read: Shared index to newest available Rx buffer
+ * @write: Shared index to oldest written Rx packet
+ * @free_count: Number of pre-allocated buffers in rx_free
+ * @write_actual:
+ * @rx_free: list of free SKBs for use
+ * @rx_used: List of Rx buffers with no SKB
+ * @need_update: flag to indicate we need to update read/write index
+ * @rb_stts: driver's pointer to receive buffer status
+ * @rb_stts_dma: bus address of receive buffer status
+ * @lock:
+ *
+ * NOTE:  rx_free and rx_used are used as a FIFO for iwl_rx_mem_buffers
+ */
+struct iwl_rx_queue {
+	__le32 *bd;
+	dma_addr_t bd_dma;
+	struct iwl_rx_mem_buffer pool[RX_QUEUE_SIZE + RX_FREE_BUFFERS];
+	struct iwl_rx_mem_buffer *queue[RX_QUEUE_SIZE];
+	u32 read;
+	u32 write;
+	u32 free_count;
+	u32 write_actual;
+	struct list_head rx_free;
+	struct list_head rx_used;
+	int need_update;
+	struct iwl_rb_status *rb_stts;
+	dma_addr_t rb_stts_dma;
+	spinlock_t lock;
+};
+
+struct iwl_dma_ptr {
+	dma_addr_t dma;
+	void *addr;
+	size_t size;
+};
+
+/*
+ * This queue number is required for proper operation
+ * because the ucode will stop/start the scheduler as
+ * required.
+ */
+#define IWL_IPAN_MCAST_QUEUE		8
+
+struct iwl_cmd_meta {
+	/* only for SYNC commands, iff the reply skb is wanted */
+	struct iwl_host_cmd *source;
+	/*
+	 * only for ASYNC commands
+	 * (which is somewhat stupid -- look at iwl-sta.c for instance
+	 * which duplicates a bunch of code because the callback isn't
+	 * invoked for SYNC commands, if it were and its result passed
+	 * through it would be simpler...)
+	 */
+	void (*callback)(struct iwl_shared *shrd,
+			 struct iwl_device_cmd *cmd,
+			 struct iwl_rx_packet *pkt);
+
+	u32 flags;
+
+	DEFINE_DMA_UNMAP_ADDR(mapping);
+	DEFINE_DMA_UNMAP_LEN(len);
+};
+
+/*
+ * Generic queue structure
+ *
+ * Contains common data for Rx and Tx queues.
+ *
+ * Note the difference between n_bd and n_window: the hardware
+ * always assumes 256 descriptors, so n_bd is always 256 (unless
+ * there might be HW changes in the future). For the normal TX
+ * queues, n_window, which is the size of the software queue data
+ * is also 256; however, for the command queue, n_window is only
+ * 32 since we don't need so many commands pending. Since the HW
+ * still uses 256 BDs for DMA though, n_bd stays 256. As a result,
+ * the software buffers (in the variables @meta, @txb in struct
+ * iwl_tx_queue) only have 32 entries, while the HW buffers (@tfds
+ * in the same struct) have 256.
+ * This means that we end up with the following:
+ *  HW entries: | 0 | ... | N * 32 | ... | N * 32 + 31 | ... | 255 |
+ *  SW entries:           | 0      | ... | 31          |
+ * where N is a number between 0 and 7. This means that the SW
+ * data is a window overlayed over the HW queue.
+ */
+struct iwl_queue {
+	int n_bd;              /* number of BDs in this queue */
+	int write_ptr;       /* 1-st empty entry (index) host_w*/
+	int read_ptr;         /* last used entry (index) host_r*/
+	/* use for monitoring and recovering the stuck queue */
+	dma_addr_t dma_addr;   /* physical addr for BD's */
+	int n_window;	       /* safe queue window */
+	u32 id;
+	int low_mark;	       /* low watermark, resume queue if free
+				* space more than this */
+	int high_mark;         /* high watermark, stop queue if free
+				* space less than this */
+};
+
+/**
+ * struct iwl_tx_queue - Tx Queue for DMA
+ * @q: generic Rx/Tx queue descriptor
+ * @bd: base of circular buffer of TFDs
+ * @cmd: array of command/TX buffer pointers
+ * @meta: array of meta data for each command/tx buffer
+ * @dma_addr_cmd: physical address of cmd/tx buffer array
+ * @txb: array of per-TFD driver data
+ * @time_stamp: time (in jiffies) of last read_ptr change
+ * @need_update: indicates need to update read/write index
+ * @sched_retry: indicates queue is high-throughput aggregation (HT AGG) enabled
+ * @sta_id: valid if sched_retry is set
+ * @tid: valid if sched_retry is set
+ *
+ * A Tx queue consists of circular buffer of BDs (a.k.a. TFDs, transmit frame
+ * descriptors) and required locking structures.
+ */
+#define TFD_TX_CMD_SLOTS 256
+#define TFD_CMD_SLOTS 32
+
+struct iwl_tx_queue {
+	struct iwl_queue q;
+	struct iwl_tfd *tfds;
+	struct iwl_device_cmd **cmd;
+	struct iwl_cmd_meta *meta;
+	struct sk_buff **skbs;
+	unsigned long time_stamp;
+	u8 need_update;
+	u8 sched_retry;
+	u8 active;
+	u8 swq_id;
+
+	u16 sta_id;
+	u16 tid;
+};
+
+/**
+ * struct iwl_trans_pcie - PCIe transport specific data
+ * @rxq: all the RX queue data
+ * @rx_replenish: work that will be called when buffers need to be allocated
+ * @trans: pointer to the generic transport area
+ * @scd_base_addr: scheduler sram base address in SRAM
+ * @scd_bc_tbls: pointer to the byte count table of the scheduler
+ * @kw: keep warm address
+ * @ac_to_fifo: to what fifo is a specifc AC mapped ?
+ * @ac_to_queue: to what tx queue  is a specifc AC mapped ?
+ * @mcast_queue:
+ * @txq: Tx DMA processing queues
+ * @txq_ctx_active_msk: what queue is active
+ * queue_stopped: tracks what queue is stopped
+ * queue_stop_count: tracks what SW queue is stopped
+ */
+struct iwl_trans_pcie {
+	struct iwl_rx_queue rxq;
+	struct work_struct rx_replenish;
+	struct iwl_trans *trans;
+
+	/* INT ICT Table */
+	__le32 *ict_tbl;
+	void *ict_tbl_vir;
+	dma_addr_t ict_tbl_dma;
+	dma_addr_t aligned_ict_tbl_dma;
+	int ict_index;
+	u32 inta;
+	bool use_ict;
+	struct tasklet_struct irq_tasklet;
+	struct isr_statistics isr_stats;
+
+	u32 inta_mask;
+	u32 scd_base_addr;
+	struct iwl_dma_ptr scd_bc_tbls;
+	struct iwl_dma_ptr kw;
+
+	const u8 *ac_to_fifo[NUM_IWL_RXON_CTX];
+	const u8 *ac_to_queue[NUM_IWL_RXON_CTX];
+	u8 mcast_queue[NUM_IWL_RXON_CTX];
+
+	struct iwl_tx_queue *txq;
+	unsigned long txq_ctx_active_msk;
+#define IWL_MAX_HW_QUEUES	32
+	unsigned long queue_stopped[BITS_TO_LONGS(IWL_MAX_HW_QUEUES)];
+	atomic_t queue_stop_count[4];
+};
+
+#define IWL_TRANS_GET_PCIE_TRANS(_iwl_trans) \
+	((struct iwl_trans_pcie *) ((_iwl_trans)->trans_specific))
+
+/*****************************************************
+* RX
+******************************************************/
+void iwl_bg_rx_replenish(struct work_struct *data);
+void iwl_irq_tasklet(struct iwl_trans *trans);
+void iwlagn_rx_replenish(struct iwl_trans *trans);
+void iwl_rx_queue_update_write_ptr(struct iwl_trans *trans,
+			struct iwl_rx_queue *q);
+
+/*****************************************************
+* ICT
+******************************************************/
+int iwl_reset_ict(struct iwl_trans *trans);
+void iwl_disable_ict(struct iwl_trans *trans);
+int iwl_alloc_isr_ict(struct iwl_trans *trans);
+void iwl_free_isr_ict(struct iwl_trans *trans);
+irqreturn_t iwl_isr_ict(int irq, void *data);
+
+/*****************************************************
+* TX / HCMD
+******************************************************/
+void iwl_txq_update_write_ptr(struct iwl_trans *trans,
+			struct iwl_tx_queue *txq);
+int iwlagn_txq_attach_buf_to_tfd(struct iwl_trans *trans,
+				 struct iwl_tx_queue *txq,
+				 dma_addr_t addr, u16 len, u8 reset);
+int iwl_queue_init(struct iwl_queue *q, int count, int slots_num, u32 id);
+int iwl_trans_pcie_send_cmd(struct iwl_trans *trans, struct iwl_host_cmd *cmd);
+int __must_check iwl_trans_pcie_send_cmd_pdu(struct iwl_trans *trans, u8 id,
+			u32 flags, u16 len, const void *data);
+void iwl_tx_cmd_complete(struct iwl_trans *trans,
+			 struct iwl_rx_mem_buffer *rxb);
+void iwl_trans_txq_update_byte_cnt_tbl(struct iwl_trans *trans,
+					   struct iwl_tx_queue *txq,
+					   u16 byte_cnt);
+void iwl_trans_pcie_txq_agg_disable(struct iwl_trans *trans, int txq_id);
+int iwl_trans_pcie_tx_agg_disable(struct iwl_trans *trans,
+				  enum iwl_rxon_context_id ctx, int sta_id,
+				  int tid);
+void iwl_trans_set_wr_ptrs(struct iwl_trans *trans, int txq_id, u32 index);
+void iwl_trans_tx_queue_set_status(struct iwl_trans *trans,
+			     struct iwl_tx_queue *txq,
+			     int tx_fifo_id, int scd_retry);
+int iwl_trans_pcie_tx_agg_alloc(struct iwl_trans *trans,
+				enum iwl_rxon_context_id ctx, int sta_id,
+				int tid, u16 *ssn);
+void iwl_trans_pcie_tx_agg_setup(struct iwl_trans *trans,
+				 enum iwl_rxon_context_id ctx,
+				 int sta_id, int tid, int frame_limit);
+void iwlagn_txq_free_tfd(struct iwl_trans *trans, struct iwl_tx_queue *txq,
+	int index, enum dma_data_direction dma_dir);
+int iwl_tx_queue_reclaim(struct iwl_trans *trans, int txq_id, int index,
+			 struct sk_buff_head *skbs);
+int iwl_queue_space(const struct iwl_queue *q);
+
+/*****************************************************
+* Error handling
+******************************************************/
+int iwl_dump_nic_event_log(struct iwl_trans *trans, bool full_log,
+			    char **buf, bool display);
+int iwl_dump_fh(struct iwl_trans *trans, char **buf, bool display);
+void iwl_dump_csr(struct iwl_trans *trans);
+
+/*****************************************************
+* Helpers
+******************************************************/
+static inline void iwl_disable_interrupts(struct iwl_trans *trans)
+{
+	clear_bit(STATUS_INT_ENABLED, &trans->shrd->status);
+
+	/* disable interrupts from uCode/NIC to host */
+	iwl_write32(bus(trans), CSR_INT_MASK, 0x00000000);
+
+	/* acknowledge/clear/reset any interrupts still pending
+	 * from uCode or flow handler (Rx/Tx DMA) */
+	iwl_write32(bus(trans), CSR_INT, 0xffffffff);
+	iwl_write32(bus(trans), CSR_FH_INT_STATUS, 0xffffffff);
+	IWL_DEBUG_ISR(trans, "Disabled interrupts\n");
+}
+
+static inline void iwl_enable_interrupts(struct iwl_trans *trans)
+{
+	struct iwl_trans_pcie *trans_pcie =
+		IWL_TRANS_GET_PCIE_TRANS(trans);
+
+	IWL_DEBUG_ISR(trans, "Enabling interrupts\n");
+	set_bit(STATUS_INT_ENABLED, &trans->shrd->status);
+	iwl_write32(bus(trans), CSR_INT_MASK, trans_pcie->inta_mask);
+}
+
+/*
+ * we have 8 bits used like this:
+ *
+ * 7 6 5 4 3 2 1 0
+ * | | | | | | | |
+ * | | | | | | +-+-------- AC queue (0-3)
+ * | | | | | |
+ * | +-+-+-+-+------------ HW queue ID
+ * |
+ * +---------------------- unused
+ */
+static inline void iwl_set_swq_id(struct iwl_tx_queue *txq, u8 ac, u8 hwq)
+{
+	BUG_ON(ac > 3);   /* only have 2 bits */
+	BUG_ON(hwq > 31); /* only use 5 bits */
+
+	txq->swq_id = (hwq << 2) | ac;
+}
+
+static inline void iwl_wake_queue(struct iwl_trans *trans,
+				  struct iwl_tx_queue *txq)
+{
+	u8 queue = txq->swq_id;
+	u8 ac = queue & 3;
+	u8 hwq = (queue >> 2) & 0x1f;
+	struct iwl_trans_pcie *trans_pcie =
+		IWL_TRANS_GET_PCIE_TRANS(trans);
+
+	if (test_and_clear_bit(hwq, trans_pcie->queue_stopped))
+		if (atomic_dec_return(&trans_pcie->queue_stop_count[ac]) <= 0)
+			iwl_wake_sw_queue(priv(trans), ac);
+}
+
+static inline void iwl_stop_queue(struct iwl_trans *trans,
+				  struct iwl_tx_queue *txq)
+{
+	u8 queue = txq->swq_id;
+	u8 ac = queue & 3;
+	u8 hwq = (queue >> 2) & 0x1f;
+	struct iwl_trans_pcie *trans_pcie =
+		IWL_TRANS_GET_PCIE_TRANS(trans);
+
+	if (!test_and_set_bit(hwq, trans_pcie->queue_stopped))
+		if (atomic_inc_return(&trans_pcie->queue_stop_count[ac]) > 0)
+			iwl_stop_sw_queue(priv(trans), ac);
+}
+
+#ifdef ieee80211_stop_queue
+#undef ieee80211_stop_queue
+#endif
+
+#define ieee80211_stop_queue DO_NOT_USE_ieee80211_stop_queue
+
+#ifdef ieee80211_wake_queue
+#undef ieee80211_wake_queue
+#endif
+
+#define ieee80211_wake_queue DO_NOT_USE_ieee80211_wake_queue
+
+static inline void iwl_txq_ctx_activate(struct iwl_trans_pcie *trans_pcie,
+					int txq_id)
+{
+	set_bit(txq_id, &trans_pcie->txq_ctx_active_msk);
+}
+
+static inline void iwl_txq_ctx_deactivate(struct iwl_trans_pcie *trans_pcie,
+					  int txq_id)
+{
+	clear_bit(txq_id, &trans_pcie->txq_ctx_active_msk);
+}
+
+static inline int iwl_queue_used(const struct iwl_queue *q, int i)
+{
+	return q->write_ptr >= q->read_ptr ?
+		(i >= q->read_ptr && i < q->write_ptr) :
+		!(i < q->read_ptr && i >= q->write_ptr);
+}
+
+static inline u8 get_cmd_index(struct iwl_queue *q, u32 index)
+{
+	return index & (q->n_window - 1);
+}
+
+#define IWL_TX_FIFO_BK		0	/* shared */
+#define IWL_TX_FIFO_BE		1
+#define IWL_TX_FIFO_VI		2	/* shared */
+#define IWL_TX_FIFO_VO		3
+#define IWL_TX_FIFO_BK_IPAN	IWL_TX_FIFO_BK
+#define IWL_TX_FIFO_BE_IPAN	4
+#define IWL_TX_FIFO_VI_IPAN	IWL_TX_FIFO_VI
+#define IWL_TX_FIFO_VO_IPAN	5
+/* re-uses the VO FIFO, uCode will properly flush/schedule */
+#define IWL_TX_FIFO_AUX		5
+#define IWL_TX_FIFO_UNUSED	-1
+
+/* AUX (TX during scan dwell) queue */
+#define IWL_AUX_QUEUE		10
+
+#endif /* __iwl_trans_int_pcie_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
new file mode 100644
index 0000000..458a6fb
--- /dev/null
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
@@ -0,0 +1,1424 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2003 - 2011 Intel Corporation. All rights reserved.
+ *
+ * Portions of this file are derived from the ipw3945 project, as well
+ * as portions of the ieee80211 subsystem header files.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
+ *
+ * The full GNU General Public License is included in this distribution in the
+ * file called LICENSE.
+ *
+ * Contact Information:
+ *  Intel Linux Wireless <ilw@linux.intel.com>
+ * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
+ *
+ *****************************************************************************/
+#include <linux/sched.h>
+#include <linux/wait.h>
+#include <linux/gfp.h>
+
+/*TODO: Remove include to iwl-core.h*/
+#include "iwl-core.h"
+#include "iwl-io.h"
+#include "iwl-helpers.h"
+#include "iwl-trans-pcie-int.h"
+
+/******************************************************************************
+ *
+ * RX path functions
+ *
+ ******************************************************************************/
+
+/*
+ * Rx theory of operation
+ *
+ * Driver allocates a circular buffer of Receive Buffer Descriptors (RBDs),
+ * each of which point to Receive Buffers to be filled by the NIC.  These get
+ * used not only for Rx frames, but for any command response or notification
+ * from the NIC.  The driver and NIC manage the Rx buffers by means
+ * of indexes into the circular buffer.
+ *
+ * Rx Queue Indexes
+ * The host/firmware share two index registers for managing the Rx buffers.
+ *
+ * The READ index maps to the first position that the firmware may be writing
+ * to -- the driver can read up to (but not including) this position and get
+ * good data.
+ * The READ index is managed by the firmware once the card is enabled.
+ *
+ * The WRITE index maps to the last position the driver has read from -- the
+ * position preceding WRITE is the last slot the firmware can place a packet.
+ *
+ * The queue is empty (no good data) if WRITE = READ - 1, and is full if
+ * WRITE = READ.
+ *
+ * During initialization, the host sets up the READ queue position to the first
+ * INDEX position, and WRITE to the last (READ - 1 wrapped)
+ *
+ * When the firmware places a packet in a buffer, it will advance the READ index
+ * and fire the RX interrupt.  The driver can then query the READ index and
+ * process as many packets as possible, moving the WRITE index forward as it
+ * resets the Rx queue buffers with new memory.
+ *
+ * The management in the driver is as follows:
+ * + A list of pre-allocated SKBs is stored in iwl->rxq->rx_free.  When
+ *   iwl->rxq->free_count drops to or below RX_LOW_WATERMARK, work is scheduled
+ *   to replenish the iwl->rxq->rx_free.
+ * + In iwl_rx_replenish (scheduled) if 'processed' != 'read' then the
+ *   iwl->rxq is replenished and the READ INDEX is updated (updating the
+ *   'processed' and 'read' driver indexes as well)
+ * + A received packet is processed and handed to the kernel network stack,
+ *   detached from the iwl->rxq.  The driver 'processed' index is updated.
+ * + The Host/Firmware iwl->rxq is replenished at tasklet time from the rx_free
+ *   list. If there are no allocated buffers in iwl->rxq->rx_free, the READ
+ *   INDEX is not incremented and iwl->status(RX_STALLED) is set.  If there
+ *   were enough free buffers and RX_STALLED is set it is cleared.
+ *
+ *
+ * Driver sequence:
+ *
+ * iwl_rx_queue_alloc()   Allocates rx_free
+ * iwl_rx_replenish()     Replenishes rx_free list from rx_used, and calls
+ *                            iwl_rx_queue_restock
+ * iwl_rx_queue_restock() Moves available buffers from rx_free into Rx
+ *                            queue, updates firmware pointers, and updates
+ *                            the WRITE index.  If insufficient rx_free buffers
+ *                            are available, schedules iwl_rx_replenish
+ *
+ * -- enable interrupts --
+ * ISR - iwl_rx()         Detach iwl_rx_mem_buffers from pool up to the
+ *                            READ INDEX, detaching the SKB from the pool.
+ *                            Moves the packet buffer from queue to rx_used.
+ *                            Calls iwl_rx_queue_restock to refill any empty
+ *                            slots.
+ * ...
+ *
+ */
+
+/**
+ * iwl_rx_queue_space - Return number of free slots available in queue.
+ */
+static int iwl_rx_queue_space(const struct iwl_rx_queue *q)
+{
+	int s = q->read - q->write;
+	if (s <= 0)
+		s += RX_QUEUE_SIZE;
+	/* keep some buffer to not confuse full and empty queue */
+	s -= 2;
+	if (s < 0)
+		s = 0;
+	return s;
+}
+
+/**
+ * iwl_rx_queue_update_write_ptr - Update the write pointer for the RX queue
+ */
+void iwl_rx_queue_update_write_ptr(struct iwl_trans *trans,
+			struct iwl_rx_queue *q)
+{
+	unsigned long flags;
+	u32 reg;
+
+	spin_lock_irqsave(&q->lock, flags);
+
+	if (q->need_update == 0)
+		goto exit_unlock;
+
+	if (hw_params(trans).shadow_reg_enable) {
+		/* shadow register enabled */
+		/* Device expects a multiple of 8 */
+		q->write_actual = (q->write & ~0x7);
+		iwl_write32(bus(trans), FH_RSCSR_CHNL0_WPTR, q->write_actual);
+	} else {
+		/* If power-saving is in use, make sure device is awake */
+		if (test_bit(STATUS_POWER_PMI, &trans->shrd->status)) {
+			reg = iwl_read32(bus(trans), CSR_UCODE_DRV_GP1);
+
+			if (reg & CSR_UCODE_DRV_GP1_BIT_MAC_SLEEP) {
+				IWL_DEBUG_INFO(trans,
+					"Rx queue requesting wakeup,"
+					" GP1 = 0x%x\n", reg);
+				iwl_set_bit(bus(trans), CSR_GP_CNTRL,
+					CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
+				goto exit_unlock;
+			}
+
+			q->write_actual = (q->write & ~0x7);
+			iwl_write_direct32(bus(trans), FH_RSCSR_CHNL0_WPTR,
+					q->write_actual);
+
+		/* Else device is assumed to be awake */
+		} else {
+			/* Device expects a multiple of 8 */
+			q->write_actual = (q->write & ~0x7);
+			iwl_write_direct32(bus(trans), FH_RSCSR_CHNL0_WPTR,
+				q->write_actual);
+		}
+	}
+	q->need_update = 0;
+
+ exit_unlock:
+	spin_unlock_irqrestore(&q->lock, flags);
+}
+
+/**
+ * iwlagn_dma_addr2rbd_ptr - convert a DMA address to a uCode read buffer ptr
+ */
+static inline __le32 iwlagn_dma_addr2rbd_ptr(dma_addr_t dma_addr)
+{
+	return cpu_to_le32((u32)(dma_addr >> 8));
+}
+
+/**
+ * iwlagn_rx_queue_restock - refill RX queue from pre-allocated pool
+ *
+ * If there are slots in the RX queue that need to be restocked,
+ * and we have free pre-allocated buffers, fill the ranks as much
+ * as we can, pulling from rx_free.
+ *
+ * This moves the 'write' index forward to catch up with 'processed', and
+ * also updates the memory address in the firmware to reference the new
+ * target buffer.
+ */
+static void iwlagn_rx_queue_restock(struct iwl_trans *trans)
+{
+	struct iwl_trans_pcie *trans_pcie =
+		IWL_TRANS_GET_PCIE_TRANS(trans);
+
+	struct iwl_rx_queue *rxq = &trans_pcie->rxq;
+	struct list_head *element;
+	struct iwl_rx_mem_buffer *rxb;
+	unsigned long flags;
+
+	spin_lock_irqsave(&rxq->lock, flags);
+	while ((iwl_rx_queue_space(rxq) > 0) && (rxq->free_count)) {
+		/* The overwritten rxb must be a used one */
+		rxb = rxq->queue[rxq->write];
+		BUG_ON(rxb && rxb->page);
+
+		/* Get next free Rx buffer, remove from free list */
+		element = rxq->rx_free.next;
+		rxb = list_entry(element, struct iwl_rx_mem_buffer, list);
+		list_del(element);
+
+		/* Point to Rx buffer via next RBD in circular buffer */
+		rxq->bd[rxq->write] = iwlagn_dma_addr2rbd_ptr(rxb->page_dma);
+		rxq->queue[rxq->write] = rxb;
+		rxq->write = (rxq->write + 1) & RX_QUEUE_MASK;
+		rxq->free_count--;
+	}
+	spin_unlock_irqrestore(&rxq->lock, flags);
+	/* If the pre-allocated buffer pool is dropping low, schedule to
+	 * refill it */
+	if (rxq->free_count <= RX_LOW_WATERMARK)
+		queue_work(trans->shrd->workqueue, &trans_pcie->rx_replenish);
+
+
+	/* If we've added more space for the firmware to place data, tell it.
+	 * Increment device's write pointer in multiples of 8. */
+	if (rxq->write_actual != (rxq->write & ~0x7)) {
+		spin_lock_irqsave(&rxq->lock, flags);
+		rxq->need_update = 1;
+		spin_unlock_irqrestore(&rxq->lock, flags);
+		iwl_rx_queue_update_write_ptr(trans, rxq);
+	}
+}
+
+/**
+ * iwlagn_rx_replenish - Move all used packet from rx_used to rx_free
+ *
+ * When moving to rx_free an SKB is allocated for the slot.
+ *
+ * Also restock the Rx queue via iwl_rx_queue_restock.
+ * This is called as a scheduled work item (except for during initialization)
+ */
+static void iwlagn_rx_allocate(struct iwl_trans *trans, gfp_t priority)
+{
+	struct iwl_trans_pcie *trans_pcie =
+		IWL_TRANS_GET_PCIE_TRANS(trans);
+
+	struct iwl_rx_queue *rxq = &trans_pcie->rxq;
+	struct list_head *element;
+	struct iwl_rx_mem_buffer *rxb;
+	struct page *page;
+	unsigned long flags;
+	gfp_t gfp_mask = priority;
+
+	while (1) {
+		spin_lock_irqsave(&rxq->lock, flags);
+		if (list_empty(&rxq->rx_used)) {
+			spin_unlock_irqrestore(&rxq->lock, flags);
+			return;
+		}
+		spin_unlock_irqrestore(&rxq->lock, flags);
+
+		if (rxq->free_count > RX_LOW_WATERMARK)
+			gfp_mask |= __GFP_NOWARN;
+
+		if (hw_params(trans).rx_page_order > 0)
+			gfp_mask |= __GFP_COMP;
+
+		/* Alloc a new receive buffer */
+		page = alloc_pages(gfp_mask,
+				  hw_params(trans).rx_page_order);
+		if (!page) {
+			if (net_ratelimit())
+				IWL_DEBUG_INFO(trans, "alloc_pages failed, "
+					   "order: %d\n",
+					   hw_params(trans).rx_page_order);
+
+			if ((rxq->free_count <= RX_LOW_WATERMARK) &&
+			    net_ratelimit())
+				IWL_CRIT(trans, "Failed to alloc_pages with %s."
+					 "Only %u free buffers remaining.\n",
+					 priority == GFP_ATOMIC ?
+					 "GFP_ATOMIC" : "GFP_KERNEL",
+					 rxq->free_count);
+			/* We don't reschedule replenish work here -- we will
+			 * call the restock method and if it still needs
+			 * more buffers it will schedule replenish */
+			return;
+		}
+
+		spin_lock_irqsave(&rxq->lock, flags);
+
+		if (list_empty(&rxq->rx_used)) {
+			spin_unlock_irqrestore(&rxq->lock, flags);
+			__free_pages(page, hw_params(trans).rx_page_order);
+			return;
+		}
+		element = rxq->rx_used.next;
+		rxb = list_entry(element, struct iwl_rx_mem_buffer, list);
+		list_del(element);
+
+		spin_unlock_irqrestore(&rxq->lock, flags);
+
+		BUG_ON(rxb->page);
+		rxb->page = page;
+		/* Get physical address of the RB */
+		rxb->page_dma = dma_map_page(bus(trans)->dev, page, 0,
+				PAGE_SIZE << hw_params(trans).rx_page_order,
+				DMA_FROM_DEVICE);
+		/* dma address must be no more than 36 bits */
+		BUG_ON(rxb->page_dma & ~DMA_BIT_MASK(36));
+		/* and also 256 byte aligned! */
+		BUG_ON(rxb->page_dma & DMA_BIT_MASK(8));
+
+		spin_lock_irqsave(&rxq->lock, flags);
+
+		list_add_tail(&rxb->list, &rxq->rx_free);
+		rxq->free_count++;
+
+		spin_unlock_irqrestore(&rxq->lock, flags);
+	}
+}
+
+void iwlagn_rx_replenish(struct iwl_trans *trans)
+{
+	unsigned long flags;
+
+	iwlagn_rx_allocate(trans, GFP_KERNEL);
+
+	spin_lock_irqsave(&trans->shrd->lock, flags);
+	iwlagn_rx_queue_restock(trans);
+	spin_unlock_irqrestore(&trans->shrd->lock, flags);
+}
+
+static void iwlagn_rx_replenish_now(struct iwl_trans *trans)
+{
+	iwlagn_rx_allocate(trans, GFP_ATOMIC);
+
+	iwlagn_rx_queue_restock(trans);
+}
+
+void iwl_bg_rx_replenish(struct work_struct *data)
+{
+	struct iwl_trans_pcie *trans_pcie =
+	    container_of(data, struct iwl_trans_pcie, rx_replenish);
+	struct iwl_trans *trans = trans_pcie->trans;
+
+	if (test_bit(STATUS_EXIT_PENDING, &trans->shrd->status))
+		return;
+
+	mutex_lock(&trans->shrd->mutex);
+	iwlagn_rx_replenish(trans);
+	mutex_unlock(&trans->shrd->mutex);
+}
+
+/**
+ * iwl_rx_handle - Main entry function for receiving responses from uCode
+ *
+ * Uses the priv->rx_handlers callback function array to invoke
+ * the appropriate handlers, including command responses,
+ * frame-received notifications, and other notifications.
+ */
+static void iwl_rx_handle(struct iwl_trans *trans)
+{
+	struct iwl_rx_mem_buffer *rxb;
+	struct iwl_rx_packet *pkt;
+	struct iwl_trans_pcie *trans_pcie =
+		IWL_TRANS_GET_PCIE_TRANS(trans);
+	struct iwl_rx_queue *rxq = &trans_pcie->rxq;
+	u32 r, i;
+	int reclaim;
+	unsigned long flags;
+	u8 fill_rx = 0;
+	u32 count = 8;
+	int total_empty;
+
+	/* uCode's read index (stored in shared DRAM) indicates the last Rx
+	 * buffer that the driver may process (last buffer filled by ucode). */
+	r = le16_to_cpu(rxq->rb_stts->closed_rb_num) &  0x0FFF;
+	i = rxq->read;
+
+	/* Rx interrupt, but nothing sent from uCode */
+	if (i == r)
+		IWL_DEBUG_RX(trans, "r = %d, i = %d\n", r, i);
+
+	/* calculate total frames need to be restock after handling RX */
+	total_empty = r - rxq->write_actual;
+	if (total_empty < 0)
+		total_empty += RX_QUEUE_SIZE;
+
+	if (total_empty > (RX_QUEUE_SIZE / 2))
+		fill_rx = 1;
+
+	while (i != r) {
+		int len;
+		u16 txq_id, sequence;
+
+		rxb = rxq->queue[i];
+
+		/* If an RXB doesn't have a Rx queue slot associated with it,
+		 * then a bug has been introduced in the queue refilling
+		 * routines -- catch it here */
+		if (WARN_ON(rxb == NULL)) {
+			i = (i + 1) & RX_QUEUE_MASK;
+			continue;
+		}
+
+		rxq->queue[i] = NULL;
+
+		dma_unmap_page(bus(trans)->dev, rxb->page_dma,
+			       PAGE_SIZE << hw_params(trans).rx_page_order,
+			       DMA_FROM_DEVICE);
+		pkt = rxb_addr(rxb);
+
+		IWL_DEBUG_RX(trans, "r = %d, i = %d, %s, 0x%02x\n", r,
+			i, get_cmd_string(pkt->hdr.cmd), pkt->hdr.cmd);
+
+		len = le32_to_cpu(pkt->len_n_flags) & FH_RSCSR_FRAME_SIZE_MSK;
+		len += sizeof(u32); /* account for status word */
+		trace_iwlwifi_dev_rx(priv(trans), pkt, len);
+
+		/* Reclaim a command buffer only if this packet is a response
+		 *   to a (driver-originated) command.
+		 * If the packet (e.g. Rx frame) originated from uCode,
+		 *   there is no command buffer to reclaim.
+		 * Ucode should set SEQ_RX_FRAME bit if ucode-originated,
+		 *   but apparently a few don't get set; catch them here. */
+		reclaim = !(pkt->hdr.sequence & SEQ_RX_FRAME) &&
+			(pkt->hdr.cmd != REPLY_RX_PHY_CMD) &&
+			(pkt->hdr.cmd != REPLY_RX) &&
+			(pkt->hdr.cmd != REPLY_RX_MPDU_CMD) &&
+			(pkt->hdr.cmd != REPLY_COMPRESSED_BA) &&
+			(pkt->hdr.cmd != STATISTICS_NOTIFICATION) &&
+			(pkt->hdr.cmd != REPLY_TX);
+
+		sequence = le16_to_cpu(pkt->hdr.sequence);
+		txq_id = SEQ_TO_QUEUE(le16_to_cpu(pkt->hdr.sequence));
+
+		/* warn if this is cmd response / notification and the uCode
+		 * didn't set the SEQ_RX_FRAME for a frame that is
+		 * uCode-originated*/
+		WARN(txq_id == trans->shrd->cmd_queue && reclaim == false &&
+		     (!(pkt->hdr.sequence & SEQ_RX_FRAME)),
+		     "reclaim is false, SEQ_RX_FRAME unset: %s\n",
+		     get_cmd_string(pkt->hdr.cmd));
+
+		iwl_rx_dispatch(priv(trans), rxb);
+
+		/*
+		 * XXX: After here, we should always check rxb->page
+		 * against NULL before touching it or its virtual
+		 * memory (pkt). Because some rx_handler might have
+		 * already taken or freed the pages.
+		 */
+
+		if (reclaim) {
+			/* Invoke any callbacks, transfer the buffer to caller,
+			 * and fire off the (possibly) blocking
+			 * iwl_trans_send_cmd()
+			 * as we reclaim the driver command queue */
+			if (rxb->page)
+				iwl_tx_cmd_complete(trans, rxb);
+			else
+				IWL_WARN(trans, "Claim null rxb?\n");
+		}
+
+		/* Reuse the page if possible. For notification packets and
+		 * SKBs that fail to Rx correctly, add them back into the
+		 * rx_free list for reuse later. */
+		spin_lock_irqsave(&rxq->lock, flags);
+		if (rxb->page != NULL) {
+			rxb->page_dma = dma_map_page(bus(trans)->dev, rxb->page,
+				0, PAGE_SIZE <<
+				    hw_params(trans).rx_page_order,
+				DMA_FROM_DEVICE);
+			list_add_tail(&rxb->list, &rxq->rx_free);
+			rxq->free_count++;
+		} else
+			list_add_tail(&rxb->list, &rxq->rx_used);
+
+		spin_unlock_irqrestore(&rxq->lock, flags);
+
+		i = (i + 1) & RX_QUEUE_MASK;
+		/* If there are a lot of unused frames,
+		 * restock the Rx queue so ucode wont assert. */
+		if (fill_rx) {
+			count++;
+			if (count >= 8) {
+				rxq->read = i;
+				iwlagn_rx_replenish_now(trans);
+				count = 0;
+			}
+		}
+	}
+
+	/* Backtrack one entry */
+	rxq->read = i;
+	if (fill_rx)
+		iwlagn_rx_replenish_now(trans);
+	else
+		iwlagn_rx_queue_restock(trans);
+}
+
+static const char * const desc_lookup_text[] = {
+	"OK",
+	"FAIL",
+	"BAD_PARAM",
+	"BAD_CHECKSUM",
+	"NMI_INTERRUPT_WDG",
+	"SYSASSERT",
+	"FATAL_ERROR",
+	"BAD_COMMAND",
+	"HW_ERROR_TUNE_LOCK",
+	"HW_ERROR_TEMPERATURE",
+	"ILLEGAL_CHAN_FREQ",
+	"VCC_NOT_STABLE",
+	"FH_ERROR",
+	"NMI_INTERRUPT_HOST",
+	"NMI_INTERRUPT_ACTION_PT",
+	"NMI_INTERRUPT_UNKNOWN",
+	"UCODE_VERSION_MISMATCH",
+	"HW_ERROR_ABS_LOCK",
+	"HW_ERROR_CAL_LOCK_FAIL",
+	"NMI_INTERRUPT_INST_ACTION_PT",
+	"NMI_INTERRUPT_DATA_ACTION_PT",
+	"NMI_TRM_HW_ER",
+	"NMI_INTERRUPT_TRM",
+	"NMI_INTERRUPT_BREAK_POINT",
+	"DEBUG_0",
+	"DEBUG_1",
+	"DEBUG_2",
+	"DEBUG_3",
+};
+
+static struct { char *name; u8 num; } advanced_lookup[] = {
+	{ "NMI_INTERRUPT_WDG", 0x34 },
+	{ "SYSASSERT", 0x35 },
+	{ "UCODE_VERSION_MISMATCH", 0x37 },
+	{ "BAD_COMMAND", 0x38 },
+	{ "NMI_INTERRUPT_DATA_ACTION_PT", 0x3C },
+	{ "FATAL_ERROR", 0x3D },
+	{ "NMI_TRM_HW_ERR", 0x46 },
+	{ "NMI_INTERRUPT_TRM", 0x4C },
+	{ "NMI_INTERRUPT_BREAK_POINT", 0x54 },
+	{ "NMI_INTERRUPT_WDG_RXF_FULL", 0x5C },
+	{ "NMI_INTERRUPT_WDG_NO_RBD_RXF_FULL", 0x64 },
+	{ "NMI_INTERRUPT_HOST", 0x66 },
+	{ "NMI_INTERRUPT_ACTION_PT", 0x7C },
+	{ "NMI_INTERRUPT_UNKNOWN", 0x84 },
+	{ "NMI_INTERRUPT_INST_ACTION_PT", 0x86 },
+	{ "ADVANCED_SYSASSERT", 0 },
+};
+
+static const char *desc_lookup(u32 num)
+{
+	int i;
+	int max = ARRAY_SIZE(desc_lookup_text);
+
+	if (num < max)
+		return desc_lookup_text[num];
+
+	max = ARRAY_SIZE(advanced_lookup) - 1;
+	for (i = 0; i < max; i++) {
+		if (advanced_lookup[i].num == num)
+			break;
+	}
+	return advanced_lookup[i].name;
+}
+
+#define ERROR_START_OFFSET  (1 * sizeof(u32))
+#define ERROR_ELEM_SIZE     (7 * sizeof(u32))
+
+static void iwl_dump_nic_error_log(struct iwl_trans *trans)
+{
+	u32 base;
+	struct iwl_error_event_table table;
+	struct iwl_priv *priv = priv(trans);
+	struct iwl_trans_pcie *trans_pcie =
+		IWL_TRANS_GET_PCIE_TRANS(trans);
+
+	base = priv->device_pointers.error_event_table;
+	if (priv->ucode_type == IWL_UCODE_INIT) {
+		if (!base)
+			base = priv->init_errlog_ptr;
+	} else {
+		if (!base)
+			base = priv->inst_errlog_ptr;
+	}
+
+	if (!iwlagn_hw_valid_rtc_data_addr(base)) {
+		IWL_ERR(trans,
+			"Not valid error log pointer 0x%08X for %s uCode\n",
+			base,
+			(priv->ucode_type == IWL_UCODE_INIT)
+					? "Init" : "RT");
+		return;
+	}
+
+	iwl_read_targ_mem_words(bus(priv), base, &table, sizeof(table));
+
+	if (ERROR_START_OFFSET <= table.valid * ERROR_ELEM_SIZE) {
+		IWL_ERR(trans, "Start IWL Error Log Dump:\n");
+		IWL_ERR(trans, "Status: 0x%08lX, count: %d\n",
+			trans->shrd->status, table.valid);
+	}
+
+	trans_pcie->isr_stats.err_code = table.error_id;
+
+	trace_iwlwifi_dev_ucode_error(priv, table.error_id, table.tsf_low,
+				      table.data1, table.data2, table.line,
+				      table.blink1, table.blink2, table.ilink1,
+				      table.ilink2, table.bcon_time, table.gp1,
+				      table.gp2, table.gp3, table.ucode_ver,
+				      table.hw_ver, table.brd_ver);
+	IWL_ERR(trans, "0x%08X | %-28s\n", table.error_id,
+		desc_lookup(table.error_id));
+	IWL_ERR(trans, "0x%08X | uPc\n", table.pc);
+	IWL_ERR(trans, "0x%08X | branchlink1\n", table.blink1);
+	IWL_ERR(trans, "0x%08X | branchlink2\n", table.blink2);
+	IWL_ERR(trans, "0x%08X | interruptlink1\n", table.ilink1);
+	IWL_ERR(trans, "0x%08X | interruptlink2\n", table.ilink2);
+	IWL_ERR(trans, "0x%08X | data1\n", table.data1);
+	IWL_ERR(trans, "0x%08X | data2\n", table.data2);
+	IWL_ERR(trans, "0x%08X | line\n", table.line);
+	IWL_ERR(trans, "0x%08X | beacon time\n", table.bcon_time);
+	IWL_ERR(trans, "0x%08X | tsf low\n", table.tsf_low);
+	IWL_ERR(trans, "0x%08X | tsf hi\n", table.tsf_hi);
+	IWL_ERR(trans, "0x%08X | time gp1\n", table.gp1);
+	IWL_ERR(trans, "0x%08X | time gp2\n", table.gp2);
+	IWL_ERR(trans, "0x%08X | time gp3\n", table.gp3);
+	IWL_ERR(trans, "0x%08X | uCode version\n", table.ucode_ver);
+	IWL_ERR(trans, "0x%08X | hw version\n", table.hw_ver);
+	IWL_ERR(trans, "0x%08X | board version\n", table.brd_ver);
+	IWL_ERR(trans, "0x%08X | hcmd\n", table.hcmd);
+}
+
+/**
+ * iwl_irq_handle_error - called for HW or SW error interrupt from card
+ */
+static void iwl_irq_handle_error(struct iwl_trans *trans)
+{
+	struct iwl_priv *priv = priv(trans);
+	/* W/A for WiFi/WiMAX coex and WiMAX own the RF */
+	if (priv->cfg->internal_wimax_coex &&
+	    (!(iwl_read_prph(bus(trans), APMG_CLK_CTRL_REG) &
+			APMS_CLK_VAL_MRB_FUNC_MODE) ||
+	     (iwl_read_prph(bus(trans), APMG_PS_CTRL_REG) &
+			APMG_PS_CTRL_VAL_RESET_REQ))) {
+		/*
+		 * Keep the restart process from trying to send host
+		 * commands by clearing the ready bit.
+		 */
+		clear_bit(STATUS_READY, &trans->shrd->status);
+		clear_bit(STATUS_HCMD_ACTIVE, &trans->shrd->status);
+		wake_up_interruptible(&priv->shrd->wait_command_queue);
+		IWL_ERR(trans, "RF is used by WiMAX\n");
+		return;
+	}
+
+	IWL_ERR(trans, "Loaded firmware version: %s\n",
+		priv->hw->wiphy->fw_version);
+
+	iwl_dump_nic_error_log(trans);
+	iwl_dump_csr(trans);
+	iwl_dump_fh(trans, NULL, false);
+	iwl_dump_nic_event_log(trans, false, NULL, false);
+#ifdef CONFIG_IWLWIFI_DEBUG
+	if (iwl_get_debug_level(trans->shrd) & IWL_DL_FW_ERRORS)
+		iwl_print_rx_config_cmd(priv(trans), IWL_RXON_CTX_BSS);
+#endif
+
+	iwlagn_fw_error(priv, false);
+}
+
+#define EVENT_START_OFFSET  (4 * sizeof(u32))
+
+/**
+ * iwl_print_event_log - Dump error event log to syslog
+ *
+ */
+static int iwl_print_event_log(struct iwl_trans *trans, u32 start_idx,
+			       u32 num_events, u32 mode,
+			       int pos, char **buf, size_t bufsz)
+{
+	u32 i;
+	u32 base;       /* SRAM byte address of event log header */
+	u32 event_size; /* 2 u32s, or 3 u32s if timestamp recorded */
+	u32 ptr;        /* SRAM byte address of log data */
+	u32 ev, time, data; /* event log data */
+	unsigned long reg_flags;
+	struct iwl_priv *priv = priv(trans);
+
+	if (num_events == 0)
+		return pos;
+
+	base = priv->device_pointers.log_event_table;
+	if (priv->ucode_type == IWL_UCODE_INIT) {
+		if (!base)
+			base = priv->init_evtlog_ptr;
+	} else {
+		if (!base)
+			base = priv->inst_evtlog_ptr;
+	}
+
+	if (mode == 0)
+		event_size = 2 * sizeof(u32);
+	else
+		event_size = 3 * sizeof(u32);
+
+	ptr = base + EVENT_START_OFFSET + (start_idx * event_size);
+
+	/* Make sure device is powered up for SRAM reads */
+	spin_lock_irqsave(&bus(trans)->reg_lock, reg_flags);
+	iwl_grab_nic_access(bus(trans));
+
+	/* Set starting address; reads will auto-increment */
+	iwl_write32(bus(trans), HBUS_TARG_MEM_RADDR, ptr);
+	rmb();
+
+	/* "time" is actually "data" for mode 0 (no timestamp).
+	* place event id # at far right for easier visual parsing. */
+	for (i = 0; i < num_events; i++) {
+		ev = iwl_read32(bus(trans), HBUS_TARG_MEM_RDAT);
+		time = iwl_read32(bus(trans), HBUS_TARG_MEM_RDAT);
+		if (mode == 0) {
+			/* data, ev */
+			if (bufsz) {
+				pos += scnprintf(*buf + pos, bufsz - pos,
+						"EVT_LOG:0x%08x:%04u\n",
+						time, ev);
+			} else {
+				trace_iwlwifi_dev_ucode_event(priv, 0,
+					time, ev);
+				IWL_ERR(trans, "EVT_LOG:0x%08x:%04u\n",
+					time, ev);
+			}
+		} else {
+			data = iwl_read32(bus(trans), HBUS_TARG_MEM_RDAT);
+			if (bufsz) {
+				pos += scnprintf(*buf + pos, bufsz - pos,
+						"EVT_LOGT:%010u:0x%08x:%04u\n",
+						 time, data, ev);
+			} else {
+				IWL_ERR(trans, "EVT_LOGT:%010u:0x%08x:%04u\n",
+					time, data, ev);
+				trace_iwlwifi_dev_ucode_event(priv, time,
+					data, ev);
+			}
+		}
+	}
+
+	/* Allow device to power down */
+	iwl_release_nic_access(bus(trans));
+	spin_unlock_irqrestore(&bus(trans)->reg_lock, reg_flags);
+	return pos;
+}
+
+/**
+ * iwl_print_last_event_logs - Dump the newest # of event log to syslog
+ */
+static int iwl_print_last_event_logs(struct iwl_trans *trans, u32 capacity,
+				    u32 num_wraps, u32 next_entry,
+				    u32 size, u32 mode,
+				    int pos, char **buf, size_t bufsz)
+{
+	/*
+	 * display the newest DEFAULT_LOG_ENTRIES entries
+	 * i.e the entries just before the next ont that uCode would fill.
+	 */
+	if (num_wraps) {
+		if (next_entry < size) {
+			pos = iwl_print_event_log(trans,
+						capacity - (size - next_entry),
+						size - next_entry, mode,
+						pos, buf, bufsz);
+			pos = iwl_print_event_log(trans, 0,
+						  next_entry, mode,
+						  pos, buf, bufsz);
+		} else
+			pos = iwl_print_event_log(trans, next_entry - size,
+						  size, mode, pos, buf, bufsz);
+	} else {
+		if (next_entry < size) {
+			pos = iwl_print_event_log(trans, 0, next_entry,
+						  mode, pos, buf, bufsz);
+		} else {
+			pos = iwl_print_event_log(trans, next_entry - size,
+						  size, mode, pos, buf, bufsz);
+		}
+	}
+	return pos;
+}
+
+#define DEFAULT_DUMP_EVENT_LOG_ENTRIES (20)
+
+int iwl_dump_nic_event_log(struct iwl_trans *trans, bool full_log,
+			    char **buf, bool display)
+{
+	u32 base;       /* SRAM byte address of event log header */
+	u32 capacity;   /* event log capacity in # entries */
+	u32 mode;       /* 0 - no timestamp, 1 - timestamp recorded */
+	u32 num_wraps;  /* # times uCode wrapped to top of log */
+	u32 next_entry; /* index of next entry to be written by uCode */
+	u32 size;       /* # entries that we'll print */
+	u32 logsize;
+	int pos = 0;
+	size_t bufsz = 0;
+	struct iwl_priv *priv = priv(trans);
+
+	base = priv->device_pointers.log_event_table;
+	if (priv->ucode_type == IWL_UCODE_INIT) {
+		logsize = priv->init_evtlog_size;
+		if (!base)
+			base = priv->init_evtlog_ptr;
+	} else {
+		logsize = priv->inst_evtlog_size;
+		if (!base)
+			base = priv->inst_evtlog_ptr;
+	}
+
+	if (!iwlagn_hw_valid_rtc_data_addr(base)) {
+		IWL_ERR(trans,
+			"Invalid event log pointer 0x%08X for %s uCode\n",
+			base,
+			(priv->ucode_type == IWL_UCODE_INIT)
+					? "Init" : "RT");
+		return -EINVAL;
+	}
+
+	/* event log header */
+	capacity = iwl_read_targ_mem(bus(trans), base);
+	mode = iwl_read_targ_mem(bus(trans), base + (1 * sizeof(u32)));
+	num_wraps = iwl_read_targ_mem(bus(trans), base + (2 * sizeof(u32)));
+	next_entry = iwl_read_targ_mem(bus(trans), base + (3 * sizeof(u32)));
+
+	if (capacity > logsize) {
+		IWL_ERR(trans, "Log capacity %d is bogus, limit to %d "
+			"entries\n", capacity, logsize);
+		capacity = logsize;
+	}
+
+	if (next_entry > logsize) {
+		IWL_ERR(trans, "Log write index %d is bogus, limit to %d\n",
+			next_entry, logsize);
+		next_entry = logsize;
+	}
+
+	size = num_wraps ? capacity : next_entry;
+
+	/* bail out if nothing in log */
+	if (size == 0) {
+		IWL_ERR(trans, "Start IWL Event Log Dump: nothing in log\n");
+		return pos;
+	}
+
+#ifdef CONFIG_IWLWIFI_DEBUG
+	if (!(iwl_get_debug_level(trans->shrd) & IWL_DL_FW_ERRORS) && !full_log)
+		size = (size > DEFAULT_DUMP_EVENT_LOG_ENTRIES)
+			? DEFAULT_DUMP_EVENT_LOG_ENTRIES : size;
+#else
+	size = (size > DEFAULT_DUMP_EVENT_LOG_ENTRIES)
+		? DEFAULT_DUMP_EVENT_LOG_ENTRIES : size;
+#endif
+	IWL_ERR(trans, "Start IWL Event Log Dump: display last %u entries\n",
+		size);
+
+#ifdef CONFIG_IWLWIFI_DEBUG
+	if (display) {
+		if (full_log)
+			bufsz = capacity * 48;
+		else
+			bufsz = size * 48;
+		*buf = kmalloc(bufsz, GFP_KERNEL);
+		if (!*buf)
+			return -ENOMEM;
+	}
+	if ((iwl_get_debug_level(trans->shrd) & IWL_DL_FW_ERRORS) || full_log) {
+		/*
+		 * if uCode has wrapped back to top of log,
+		 * start at the oldest entry,
+		 * i.e the next one that uCode would fill.
+		 */
+		if (num_wraps)
+			pos = iwl_print_event_log(trans, next_entry,
+						capacity - next_entry, mode,
+						pos, buf, bufsz);
+		/* (then/else) start at top of log */
+		pos = iwl_print_event_log(trans, 0,
+					  next_entry, mode, pos, buf, bufsz);
+	} else
+		pos = iwl_print_last_event_logs(trans, capacity, num_wraps,
+						next_entry, size, mode,
+						pos, buf, bufsz);
+#else
+	pos = iwl_print_last_event_logs(trans, capacity, num_wraps,
+					next_entry, size, mode,
+					pos, buf, bufsz);
+#endif
+	return pos;
+}
+
+/* tasklet for iwlagn interrupt */
+void iwl_irq_tasklet(struct iwl_trans *trans)
+{
+	u32 inta = 0;
+	u32 handled = 0;
+	unsigned long flags;
+	u32 i;
+#ifdef CONFIG_IWLWIFI_DEBUG
+	u32 inta_mask;
+#endif
+
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+	struct isr_statistics *isr_stats = &trans_pcie->isr_stats;
+
+
+	spin_lock_irqsave(&trans->shrd->lock, flags);
+
+	/* Ack/clear/reset pending uCode interrupts.
+	 * Note:  Some bits in CSR_INT are "OR" of bits in CSR_FH_INT_STATUS,
+	 */
+	/* There is a hardware bug in the interrupt mask function that some
+	 * interrupts (i.e. CSR_INT_BIT_SCD) can still be generated even if
+	 * they are disabled in the CSR_INT_MASK register. Furthermore the
+	 * ICT interrupt handling mechanism has another bug that might cause
+	 * these unmasked interrupts fail to be detected. We workaround the
+	 * hardware bugs here by ACKing all the possible interrupts so that
+	 * interrupt coalescing can still be achieved.
+	 */
+	iwl_write32(bus(trans), CSR_INT,
+		trans_pcie->inta | ~trans_pcie->inta_mask);
+
+	inta = trans_pcie->inta;
+
+#ifdef CONFIG_IWLWIFI_DEBUG
+	if (iwl_get_debug_level(trans->shrd) & IWL_DL_ISR) {
+		/* just for debug */
+		inta_mask = iwl_read32(bus(trans), CSR_INT_MASK);
+		IWL_DEBUG_ISR(trans, "inta 0x%08x, enabled 0x%08x\n ",
+				inta, inta_mask);
+	}
+#endif
+
+	spin_unlock_irqrestore(&trans->shrd->lock, flags);
+
+	/* saved interrupt in inta variable now we can reset trans_pcie->inta */
+	trans_pcie->inta = 0;
+
+	/* Now service all interrupt bits discovered above. */
+	if (inta & CSR_INT_BIT_HW_ERR) {
+		IWL_ERR(trans, "Hardware error detected.  Restarting.\n");
+
+		/* Tell the device to stop sending interrupts */
+		iwl_disable_interrupts(trans);
+
+		isr_stats->hw++;
+		iwl_irq_handle_error(trans);
+
+		handled |= CSR_INT_BIT_HW_ERR;
+
+		return;
+	}
+
+#ifdef CONFIG_IWLWIFI_DEBUG
+	if (iwl_get_debug_level(trans->shrd) & (IWL_DL_ISR)) {
+		/* NIC fires this, but we don't use it, redundant with WAKEUP */
+		if (inta & CSR_INT_BIT_SCD) {
+			IWL_DEBUG_ISR(trans, "Scheduler finished to transmit "
+				      "the frame/frames.\n");
+			isr_stats->sch++;
+		}
+
+		/* Alive notification via Rx interrupt will do the real work */
+		if (inta & CSR_INT_BIT_ALIVE) {
+			IWL_DEBUG_ISR(trans, "Alive interrupt\n");
+			isr_stats->alive++;
+		}
+	}
+#endif
+	/* Safely ignore these bits for debug checks below */
+	inta &= ~(CSR_INT_BIT_SCD | CSR_INT_BIT_ALIVE);
+
+	/* HW RF KILL switch toggled */
+	if (inta & CSR_INT_BIT_RF_KILL) {
+		int hw_rf_kill = 0;
+		if (!(iwl_read32(bus(trans), CSR_GP_CNTRL) &
+				CSR_GP_CNTRL_REG_FLAG_HW_RF_KILL_SW))
+			hw_rf_kill = 1;
+
+		IWL_WARN(trans, "RF_KILL bit toggled to %s.\n",
+				hw_rf_kill ? "disable radio" : "enable radio");
+
+		isr_stats->rfkill++;
+
+		/* driver only loads ucode once setting the interface up.
+		 * the driver allows loading the ucode even if the radio
+		 * is killed. Hence update the killswitch state here. The
+		 * rfkill handler will care about restarting if needed.
+		 */
+		if (!test_bit(STATUS_ALIVE, &trans->shrd->status)) {
+			if (hw_rf_kill)
+				set_bit(STATUS_RF_KILL_HW,
+					&trans->shrd->status);
+			else
+				clear_bit(STATUS_RF_KILL_HW,
+					  &trans->shrd->status);
+			iwl_set_hw_rfkill_state(priv(trans), hw_rf_kill);
+		}
+
+		handled |= CSR_INT_BIT_RF_KILL;
+	}
+
+	/* Chip got too hot and stopped itself */
+	if (inta & CSR_INT_BIT_CT_KILL) {
+		IWL_ERR(trans, "Microcode CT kill error detected.\n");
+		isr_stats->ctkill++;
+		handled |= CSR_INT_BIT_CT_KILL;
+	}
+
+	/* Error detected by uCode */
+	if (inta & CSR_INT_BIT_SW_ERR) {
+		IWL_ERR(trans, "Microcode SW error detected. "
+			" Restarting 0x%X.\n", inta);
+		isr_stats->sw++;
+		iwl_irq_handle_error(trans);
+		handled |= CSR_INT_BIT_SW_ERR;
+	}
+
+	/* uCode wakes up after power-down sleep */
+	if (inta & CSR_INT_BIT_WAKEUP) {
+		IWL_DEBUG_ISR(trans, "Wakeup interrupt\n");
+		iwl_rx_queue_update_write_ptr(trans, &trans_pcie->rxq);
+		for (i = 0; i < hw_params(trans).max_txq_num; i++)
+			iwl_txq_update_write_ptr(trans,
+						 &trans_pcie->txq[i]);
+
+		isr_stats->wakeup++;
+
+		handled |= CSR_INT_BIT_WAKEUP;
+	}
+
+	/* All uCode command responses, including Tx command responses,
+	 * Rx "responses" (frame-received notification), and other
+	 * notifications from uCode come through here*/
+	if (inta & (CSR_INT_BIT_FH_RX | CSR_INT_BIT_SW_RX |
+			CSR_INT_BIT_RX_PERIODIC)) {
+		IWL_DEBUG_ISR(trans, "Rx interrupt\n");
+		if (inta & (CSR_INT_BIT_FH_RX | CSR_INT_BIT_SW_RX)) {
+			handled |= (CSR_INT_BIT_FH_RX | CSR_INT_BIT_SW_RX);
+			iwl_write32(bus(trans), CSR_FH_INT_STATUS,
+					CSR_FH_INT_RX_MASK);
+		}
+		if (inta & CSR_INT_BIT_RX_PERIODIC) {
+			handled |= CSR_INT_BIT_RX_PERIODIC;
+			iwl_write32(bus(trans),
+				CSR_INT, CSR_INT_BIT_RX_PERIODIC);
+		}
+		/* Sending RX interrupt require many steps to be done in the
+		 * the device:
+		 * 1- write interrupt to current index in ICT table.
+		 * 2- dma RX frame.
+		 * 3- update RX shared data to indicate last write index.
+		 * 4- send interrupt.
+		 * This could lead to RX race, driver could receive RX interrupt
+		 * but the shared data changes does not reflect this;
+		 * periodic interrupt will detect any dangling Rx activity.
+		 */
+
+		/* Disable periodic interrupt; we use it as just a one-shot. */
+		iwl_write8(bus(trans), CSR_INT_PERIODIC_REG,
+			    CSR_INT_PERIODIC_DIS);
+		iwl_rx_handle(trans);
+
+		/*
+		 * Enable periodic interrupt in 8 msec only if we received
+		 * real RX interrupt (instead of just periodic int), to catch
+		 * any dangling Rx interrupt.  If it was just the periodic
+		 * interrupt, there was no dangling Rx activity, and no need
+		 * to extend the periodic interrupt; one-shot is enough.
+		 */
+		if (inta & (CSR_INT_BIT_FH_RX | CSR_INT_BIT_SW_RX))
+			iwl_write8(bus(trans), CSR_INT_PERIODIC_REG,
+				    CSR_INT_PERIODIC_ENA);
+
+		isr_stats->rx++;
+	}
+
+	/* This "Tx" DMA channel is used only for loading uCode */
+	if (inta & CSR_INT_BIT_FH_TX) {
+		iwl_write32(bus(trans), CSR_FH_INT_STATUS, CSR_FH_INT_TX_MASK);
+		IWL_DEBUG_ISR(trans, "uCode load interrupt\n");
+		isr_stats->tx++;
+		handled |= CSR_INT_BIT_FH_TX;
+		/* Wake up uCode load routine, now that load is complete */
+		priv(trans)->ucode_write_complete = 1;
+		wake_up_interruptible(&trans->shrd->wait_command_queue);
+	}
+
+	if (inta & ~handled) {
+		IWL_ERR(trans, "Unhandled INTA bits 0x%08x\n", inta & ~handled);
+		isr_stats->unhandled++;
+	}
+
+	if (inta & ~(trans_pcie->inta_mask)) {
+		IWL_WARN(trans, "Disabled INTA bits 0x%08x were pending\n",
+			 inta & ~trans_pcie->inta_mask);
+	}
+
+	/* Re-enable all interrupts */
+	/* only Re-enable if disabled by irq */
+	if (test_bit(STATUS_INT_ENABLED, &trans->shrd->status))
+		iwl_enable_interrupts(trans);
+	/* Re-enable RF_KILL if it occurred */
+	else if (handled & CSR_INT_BIT_RF_KILL)
+		iwl_enable_rfkill_int(priv(trans));
+}
+
+/******************************************************************************
+ *
+ * ICT functions
+ *
+ ******************************************************************************/
+#define ICT_COUNT (PAGE_SIZE/sizeof(u32))
+
+/* Free dram table */
+void iwl_free_isr_ict(struct iwl_trans *trans)
+{
+	struct iwl_trans_pcie *trans_pcie =
+		IWL_TRANS_GET_PCIE_TRANS(trans);
+
+	if (trans_pcie->ict_tbl_vir) {
+		dma_free_coherent(bus(trans)->dev,
+				  (sizeof(u32) * ICT_COUNT) + PAGE_SIZE,
+				  trans_pcie->ict_tbl_vir,
+				  trans_pcie->ict_tbl_dma);
+		trans_pcie->ict_tbl_vir = NULL;
+		memset(&trans_pcie->ict_tbl_dma, 0,
+			sizeof(trans_pcie->ict_tbl_dma));
+		memset(&trans_pcie->aligned_ict_tbl_dma, 0,
+			sizeof(trans_pcie->aligned_ict_tbl_dma));
+	}
+}
+
+
+/* allocate dram shared table it is a PAGE_SIZE aligned
+ * also reset all data related to ICT table interrupt.
+ */
+int iwl_alloc_isr_ict(struct iwl_trans *trans)
+{
+	struct iwl_trans_pcie *trans_pcie =
+		IWL_TRANS_GET_PCIE_TRANS(trans);
+
+	/* allocate shrared data table */
+	trans_pcie->ict_tbl_vir =
+		dma_alloc_coherent(bus(trans)->dev,
+				   (sizeof(u32) * ICT_COUNT) + PAGE_SIZE,
+				   &trans_pcie->ict_tbl_dma, GFP_KERNEL);
+	if (!trans_pcie->ict_tbl_vir)
+		return -ENOMEM;
+
+	/* align table to PAGE_SIZE boundary */
+	trans_pcie->aligned_ict_tbl_dma =
+		ALIGN(trans_pcie->ict_tbl_dma, PAGE_SIZE);
+
+	IWL_DEBUG_ISR(trans, "ict dma addr %Lx dma aligned %Lx diff %d\n",
+			   (unsigned long long)trans_pcie->ict_tbl_dma,
+			   (unsigned long long)trans_pcie->aligned_ict_tbl_dma,
+			   (int)(trans_pcie->aligned_ict_tbl_dma -
+			   trans_pcie->ict_tbl_dma));
+
+	trans_pcie->ict_tbl =  trans_pcie->ict_tbl_vir +
+			  (trans_pcie->aligned_ict_tbl_dma -
+			  trans_pcie->ict_tbl_dma);
+
+	IWL_DEBUG_ISR(trans, "ict vir addr %p vir aligned %p diff %d\n",
+			     trans_pcie->ict_tbl, trans_pcie->ict_tbl_vir,
+			(int)(trans_pcie->aligned_ict_tbl_dma -
+			    trans_pcie->ict_tbl_dma));
+
+	/* reset table and index to all 0 */
+	memset(trans_pcie->ict_tbl_vir, 0,
+		(sizeof(u32) * ICT_COUNT) + PAGE_SIZE);
+	trans_pcie->ict_index = 0;
+
+	/* add periodic RX interrupt */
+	trans_pcie->inta_mask |= CSR_INT_BIT_RX_PERIODIC;
+	return 0;
+}
+
+/* Device is going up inform it about using ICT interrupt table,
+ * also we need to tell the driver to start using ICT interrupt.
+ */
+int iwl_reset_ict(struct iwl_trans *trans)
+{
+	u32 val;
+	unsigned long flags;
+	struct iwl_trans_pcie *trans_pcie =
+		IWL_TRANS_GET_PCIE_TRANS(trans);
+
+	if (!trans_pcie->ict_tbl_vir)
+		return 0;
+
+	spin_lock_irqsave(&trans->shrd->lock, flags);
+	iwl_disable_interrupts(trans);
+
+	memset(&trans_pcie->ict_tbl[0], 0, sizeof(u32) * ICT_COUNT);
+
+	val = trans_pcie->aligned_ict_tbl_dma >> PAGE_SHIFT;
+
+	val |= CSR_DRAM_INT_TBL_ENABLE;
+	val |= CSR_DRAM_INIT_TBL_WRAP_CHECK;
+
+	IWL_DEBUG_ISR(trans, "CSR_DRAM_INT_TBL_REG =0x%X "
+			"aligned dma address %Lx\n",
+			val,
+			(unsigned long long)trans_pcie->aligned_ict_tbl_dma);
+
+	iwl_write32(bus(trans), CSR_DRAM_INT_TBL_REG, val);
+	trans_pcie->use_ict = true;
+	trans_pcie->ict_index = 0;
+	iwl_write32(bus(trans), CSR_INT, trans_pcie->inta_mask);
+	iwl_enable_interrupts(trans);
+	spin_unlock_irqrestore(&trans->shrd->lock, flags);
+
+	return 0;
+}
+
+/* Device is going down disable ict interrupt usage */
+void iwl_disable_ict(struct iwl_trans *trans)
+{
+	struct iwl_trans_pcie *trans_pcie =
+		IWL_TRANS_GET_PCIE_TRANS(trans);
+
+	unsigned long flags;
+
+	spin_lock_irqsave(&trans->shrd->lock, flags);
+	trans_pcie->use_ict = false;
+	spin_unlock_irqrestore(&trans->shrd->lock, flags);
+}
+
+static irqreturn_t iwl_isr(int irq, void *data)
+{
+	struct iwl_trans *trans = data;
+	struct iwl_trans_pcie *trans_pcie;
+	u32 inta, inta_mask;
+	unsigned long flags;
+#ifdef CONFIG_IWLWIFI_DEBUG
+	u32 inta_fh;
+#endif
+	if (!trans)
+		return IRQ_NONE;
+
+	trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+
+	spin_lock_irqsave(&trans->shrd->lock, flags);
+
+	/* Disable (but don't clear!) interrupts here to avoid
+	 *    back-to-back ISRs and sporadic interrupts from our NIC.
+	 * If we have something to service, the tasklet will re-enable ints.
+	 * If we *don't* have something, we'll re-enable before leaving here. */
+	inta_mask = iwl_read32(bus(trans), CSR_INT_MASK);  /* just for debug */
+	iwl_write32(bus(trans), CSR_INT_MASK, 0x00000000);
+
+	/* Discover which interrupts are active/pending */
+	inta = iwl_read32(bus(trans), CSR_INT);
+
+	/* Ignore interrupt if there's nothing in NIC to service.
+	 * This may be due to IRQ shared with another device,
+	 * or due to sporadic interrupts thrown from our NIC. */
+	if (!inta) {
+		IWL_DEBUG_ISR(trans, "Ignore interrupt, inta == 0\n");
+		goto none;
+	}
+
+	if ((inta == 0xFFFFFFFF) || ((inta & 0xFFFFFFF0) == 0xa5a5a5a0)) {
+		/* Hardware disappeared. It might have already raised
+		 * an interrupt */
+		IWL_WARN(trans, "HARDWARE GONE?? INTA == 0x%08x\n", inta);
+		goto unplugged;
+	}
+
+#ifdef CONFIG_IWLWIFI_DEBUG
+	if (iwl_get_debug_level(trans->shrd) & (IWL_DL_ISR)) {
+		inta_fh = iwl_read32(bus(trans), CSR_FH_INT_STATUS);
+		IWL_DEBUG_ISR(trans, "ISR inta 0x%08x, enabled 0x%08x, "
+			      "fh 0x%08x\n", inta, inta_mask, inta_fh);
+	}
+#endif
+
+	trans_pcie->inta |= inta;
+	/* iwl_irq_tasklet() will service interrupts and re-enable them */
+	if (likely(inta))
+		tasklet_schedule(&trans_pcie->irq_tasklet);
+	else if (test_bit(STATUS_INT_ENABLED, &trans->shrd->status) &&
+			!trans_pcie->inta)
+		iwl_enable_interrupts(trans);
+
+ unplugged:
+	spin_unlock_irqrestore(&trans->shrd->lock, flags);
+	return IRQ_HANDLED;
+
+ none:
+	/* re-enable interrupts here since we don't have anything to service. */
+	/* only Re-enable if disabled by irq  and no schedules tasklet. */
+	if (test_bit(STATUS_INT_ENABLED, &trans->shrd->status) &&
+		!trans_pcie->inta)
+		iwl_enable_interrupts(trans);
+
+	spin_unlock_irqrestore(&trans->shrd->lock, flags);
+	return IRQ_NONE;
+}
+
+/* interrupt handler using ict table, with this interrupt driver will
+ * stop using INTA register to get device's interrupt, reading this register
+ * is expensive, device will write interrupts in ICT dram table, increment
+ * index then will fire interrupt to driver, driver will OR all ICT table
+ * entries from current index up to table entry with 0 value. the result is
+ * the interrupt we need to service, driver will set the entries back to 0 and
+ * set index.
+ */
+irqreturn_t iwl_isr_ict(int irq, void *data)
+{
+	struct iwl_trans *trans = data;
+	struct iwl_trans_pcie *trans_pcie;
+	u32 inta, inta_mask;
+	u32 val = 0;
+	unsigned long flags;
+
+	if (!trans)
+		return IRQ_NONE;
+
+	trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+
+	/* dram interrupt table not set yet,
+	 * use legacy interrupt.
+	 */
+	if (!trans_pcie->use_ict)
+		return iwl_isr(irq, data);
+
+	spin_lock_irqsave(&trans->shrd->lock, flags);
+
+	/* Disable (but don't clear!) interrupts here to avoid
+	 * back-to-back ISRs and sporadic interrupts from our NIC.
+	 * If we have something to service, the tasklet will re-enable ints.
+	 * If we *don't* have something, we'll re-enable before leaving here.
+	 */
+	inta_mask = iwl_read32(bus(trans), CSR_INT_MASK);  /* just for debug */
+	iwl_write32(bus(trans), CSR_INT_MASK, 0x00000000);
+
+
+	/* Ignore interrupt if there's nothing in NIC to service.
+	 * This may be due to IRQ shared with another device,
+	 * or due to sporadic interrupts thrown from our NIC. */
+	if (!trans_pcie->ict_tbl[trans_pcie->ict_index]) {
+		IWL_DEBUG_ISR(trans, "Ignore interrupt, inta == 0\n");
+		goto none;
+	}
+
+	/* read all entries that not 0 start with ict_index */
+	while (trans_pcie->ict_tbl[trans_pcie->ict_index]) {
+
+		val |= le32_to_cpu(trans_pcie->ict_tbl[trans_pcie->ict_index]);
+		IWL_DEBUG_ISR(trans, "ICT index %d value 0x%08X\n",
+				trans_pcie->ict_index,
+				le32_to_cpu(
+				  trans_pcie->ict_tbl[trans_pcie->ict_index]));
+		trans_pcie->ict_tbl[trans_pcie->ict_index] = 0;
+		trans_pcie->ict_index =
+			iwl_queue_inc_wrap(trans_pcie->ict_index, ICT_COUNT);
+
+	}
+
+	/* We should not get this value, just ignore it. */
+	if (val == 0xffffffff)
+		val = 0;
+
+	/*
+	 * this is a w/a for a h/w bug. the h/w bug may cause the Rx bit
+	 * (bit 15 before shifting it to 31) to clear when using interrupt
+	 * coalescing. fortunately, bits 18 and 19 stay set when this happens
+	 * so we use them to decide on the real state of the Rx bit.
+	 * In order words, bit 15 is set if bit 18 or bit 19 are set.
+	 */
+	if (val & 0xC0000)
+		val |= 0x8000;
+
+	inta = (0xff & val) | ((0xff00 & val) << 16);
+	IWL_DEBUG_ISR(trans, "ISR inta 0x%08x, enabled 0x%08x ict 0x%08x\n",
+			inta, inta_mask, val);
+
+	inta &= trans_pcie->inta_mask;
+	trans_pcie->inta |= inta;
+
+	/* iwl_irq_tasklet() will service interrupts and re-enable them */
+	if (likely(inta))
+		tasklet_schedule(&trans_pcie->irq_tasklet);
+	else if (test_bit(STATUS_INT_ENABLED, &trans->shrd->status) &&
+			!trans_pcie->inta) {
+		/* Allow interrupt if was disabled by this handler and
+		 * no tasklet was schedules, We should not enable interrupt,
+		 * tasklet will enable it.
+		 */
+		iwl_enable_interrupts(trans);
+	}
+
+	spin_unlock_irqrestore(&trans->shrd->lock, flags);
+	return IRQ_HANDLED;
+
+ none:
+	/* re-enable interrupts here since we don't have anything to service.
+	 * only Re-enable if disabled by irq.
+	 */
+	if (test_bit(STATUS_INT_ENABLED, &trans->shrd->status) &&
+		!trans_pcie->inta)
+		iwl_enable_interrupts(trans);
+
+	spin_unlock_irqrestore(&trans->shrd->lock, flags);
+	return IRQ_NONE;
+}
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
new file mode 100644
index 0000000..305c072
--- /dev/null
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
@@ -0,0 +1,1166 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2003 - 2011 Intel Corporation. All rights reserved.
+ *
+ * Portions of this file are derived from the ipw3945 project, as well
+ * as portions of the ieee80211 subsystem header files.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
+ *
+ * The full GNU General Public License is included in this distribution in the
+ * file called LICENSE.
+ *
+ * Contact Information:
+ *  Intel Linux Wireless <ilw@linux.intel.com>
+ * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
+ *
+ *****************************************************************************/
+#include <linux/etherdevice.h>
+#include <linux/slab.h>
+#include <linux/sched.h>
+
+/* TODO: remove include to iwl-dev.h */
+#include "iwl-dev.h"
+#include "iwl-debug.h"
+#include "iwl-csr.h"
+#include "iwl-prph.h"
+#include "iwl-io.h"
+#include "iwl-agn-hw.h"
+#include "iwl-helpers.h"
+#include "iwl-trans-pcie-int.h"
+
+#define IWL_TX_CRC_SIZE 4
+#define IWL_TX_DELIMITER_SIZE 4
+
+/**
+ * iwl_trans_txq_update_byte_cnt_tbl - Set up entry in Tx byte-count array
+ */
+void iwl_trans_txq_update_byte_cnt_tbl(struct iwl_trans *trans,
+					   struct iwl_tx_queue *txq,
+					   u16 byte_cnt)
+{
+	struct iwlagn_scd_bc_tbl *scd_bc_tbl;
+	struct iwl_trans_pcie *trans_pcie =
+		IWL_TRANS_GET_PCIE_TRANS(trans);
+	int write_ptr = txq->q.write_ptr;
+	int txq_id = txq->q.id;
+	u8 sec_ctl = 0;
+	u8 sta_id = 0;
+	u16 len = byte_cnt + IWL_TX_CRC_SIZE + IWL_TX_DELIMITER_SIZE;
+	__le16 bc_ent;
+
+	scd_bc_tbl = trans_pcie->scd_bc_tbls.addr;
+
+	WARN_ON(len > 0xFFF || write_ptr >= TFD_QUEUE_SIZE_MAX);
+
+	sta_id = txq->cmd[txq->q.write_ptr]->cmd.tx.sta_id;
+	sec_ctl = txq->cmd[txq->q.write_ptr]->cmd.tx.sec_ctl;
+
+	switch (sec_ctl & TX_CMD_SEC_MSK) {
+	case TX_CMD_SEC_CCM:
+		len += CCMP_MIC_LEN;
+		break;
+	case TX_CMD_SEC_TKIP:
+		len += TKIP_ICV_LEN;
+		break;
+	case TX_CMD_SEC_WEP:
+		len += WEP_IV_LEN + WEP_ICV_LEN;
+		break;
+	}
+
+	bc_ent = cpu_to_le16((len & 0xFFF) | (sta_id << 12));
+
+	scd_bc_tbl[txq_id].tfd_offset[write_ptr] = bc_ent;
+
+	if (write_ptr < TFD_QUEUE_SIZE_BC_DUP)
+		scd_bc_tbl[txq_id].
+			tfd_offset[TFD_QUEUE_SIZE_MAX + write_ptr] = bc_ent;
+}
+
+/**
+ * iwl_txq_update_write_ptr - Send new write index to hardware
+ */
+void iwl_txq_update_write_ptr(struct iwl_trans *trans, struct iwl_tx_queue *txq)
+{
+	u32 reg = 0;
+	int txq_id = txq->q.id;
+
+	if (txq->need_update == 0)
+		return;
+
+	if (hw_params(trans).shadow_reg_enable) {
+		/* shadow register enabled */
+		iwl_write32(bus(trans), HBUS_TARG_WRPTR,
+			    txq->q.write_ptr | (txq_id << 8));
+	} else {
+		/* if we're trying to save power */
+		if (test_bit(STATUS_POWER_PMI, &trans->shrd->status)) {
+			/* wake up nic if it's powered down ...
+			 * uCode will wake up, and interrupt us again, so next
+			 * time we'll skip this part. */
+			reg = iwl_read32(bus(trans), CSR_UCODE_DRV_GP1);
+
+			if (reg & CSR_UCODE_DRV_GP1_BIT_MAC_SLEEP) {
+				IWL_DEBUG_INFO(trans,
+					"Tx queue %d requesting wakeup,"
+					" GP1 = 0x%x\n", txq_id, reg);
+				iwl_set_bit(bus(trans), CSR_GP_CNTRL,
+					CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
+				return;
+			}
+
+			iwl_write_direct32(bus(trans), HBUS_TARG_WRPTR,
+				     txq->q.write_ptr | (txq_id << 8));
+
+		/*
+		 * else not in power-save mode,
+		 * uCode will never sleep when we're
+		 * trying to tx (during RFKILL, we're not trying to tx).
+		 */
+		} else
+			iwl_write32(bus(trans), HBUS_TARG_WRPTR,
+				    txq->q.write_ptr | (txq_id << 8));
+	}
+	txq->need_update = 0;
+}
+
+static inline dma_addr_t iwl_tfd_tb_get_addr(struct iwl_tfd *tfd, u8 idx)
+{
+	struct iwl_tfd_tb *tb = &tfd->tbs[idx];
+
+	dma_addr_t addr = get_unaligned_le32(&tb->lo);
+	if (sizeof(dma_addr_t) > sizeof(u32))
+		addr |=
+		((dma_addr_t)(le16_to_cpu(tb->hi_n_len) & 0xF) << 16) << 16;
+
+	return addr;
+}
+
+static inline u16 iwl_tfd_tb_get_len(struct iwl_tfd *tfd, u8 idx)
+{
+	struct iwl_tfd_tb *tb = &tfd->tbs[idx];
+
+	return le16_to_cpu(tb->hi_n_len) >> 4;
+}
+
+static inline void iwl_tfd_set_tb(struct iwl_tfd *tfd, u8 idx,
+				  dma_addr_t addr, u16 len)
+{
+	struct iwl_tfd_tb *tb = &tfd->tbs[idx];
+	u16 hi_n_len = len << 4;
+
+	put_unaligned_le32(addr, &tb->lo);
+	if (sizeof(dma_addr_t) > sizeof(u32))
+		hi_n_len |= ((addr >> 16) >> 16) & 0xF;
+
+	tb->hi_n_len = cpu_to_le16(hi_n_len);
+
+	tfd->num_tbs = idx + 1;
+}
+
+static inline u8 iwl_tfd_get_num_tbs(struct iwl_tfd *tfd)
+{
+	return tfd->num_tbs & 0x1f;
+}
+
+static void iwlagn_unmap_tfd(struct iwl_trans *trans, struct iwl_cmd_meta *meta,
+		     struct iwl_tfd *tfd, enum dma_data_direction dma_dir)
+{
+	int i;
+	int num_tbs;
+
+	/* Sanity check on number of chunks */
+	num_tbs = iwl_tfd_get_num_tbs(tfd);
+
+	if (num_tbs >= IWL_NUM_OF_TBS) {
+		IWL_ERR(trans, "Too many chunks: %i\n", num_tbs);
+		/* @todo issue fatal error, it is quite serious situation */
+		return;
+	}
+
+	/* Unmap tx_cmd */
+	if (num_tbs)
+		dma_unmap_single(bus(trans)->dev,
+				dma_unmap_addr(meta, mapping),
+				dma_unmap_len(meta, len),
+				DMA_BIDIRECTIONAL);
+
+	/* Unmap chunks, if any. */
+	for (i = 1; i < num_tbs; i++)
+		dma_unmap_single(bus(trans)->dev, iwl_tfd_tb_get_addr(tfd, i),
+				iwl_tfd_tb_get_len(tfd, i), dma_dir);
+}
+
+/**
+ * iwlagn_txq_free_tfd - Free all chunks referenced by TFD [txq->q.read_ptr]
+ * @trans - transport private data
+ * @txq - tx queue
+ * @index - the index of the TFD to be freed
+ *@dma_dir - the direction of the DMA mapping
+ *
+ * Does NOT advance any TFD circular buffer read/write indexes
+ * Does NOT free the TFD itself (which is within circular buffer)
+ */
+void iwlagn_txq_free_tfd(struct iwl_trans *trans, struct iwl_tx_queue *txq,
+	int index, enum dma_data_direction dma_dir)
+{
+	struct iwl_tfd *tfd_tmp = txq->tfds;
+
+	iwlagn_unmap_tfd(trans, &txq->meta[index], &tfd_tmp[index], dma_dir);
+
+	/* free SKB */
+	if (txq->skbs) {
+		struct sk_buff *skb;
+
+		skb = txq->skbs[index];
+
+		/* Can be called from irqs-disabled context
+		 * If skb is not NULL, it means that the whole queue is being
+		 * freed and that the queue is not empty - free the skb
+		 */
+		if (skb) {
+			iwl_free_skb(priv(trans), skb);
+			txq->skbs[index] = NULL;
+		}
+	}
+}
+
+int iwlagn_txq_attach_buf_to_tfd(struct iwl_trans *trans,
+				 struct iwl_tx_queue *txq,
+				 dma_addr_t addr, u16 len,
+				 u8 reset)
+{
+	struct iwl_queue *q;
+	struct iwl_tfd *tfd, *tfd_tmp;
+	u32 num_tbs;
+
+	q = &txq->q;
+	tfd_tmp = txq->tfds;
+	tfd = &tfd_tmp[q->write_ptr];
+
+	if (reset)
+		memset(tfd, 0, sizeof(*tfd));
+
+	num_tbs = iwl_tfd_get_num_tbs(tfd);
+
+	/* Each TFD can point to a maximum 20 Tx buffers */
+	if (num_tbs >= IWL_NUM_OF_TBS) {
+		IWL_ERR(trans, "Error can not send more than %d chunks\n",
+			  IWL_NUM_OF_TBS);
+		return -EINVAL;
+	}
+
+	if (WARN_ON(addr & ~DMA_BIT_MASK(36)))
+		return -EINVAL;
+
+	if (unlikely(addr & ~IWL_TX_DMA_MASK))
+		IWL_ERR(trans, "Unaligned address = %llx\n",
+			  (unsigned long long)addr);
+
+	iwl_tfd_set_tb(tfd, num_tbs, addr, len);
+
+	return 0;
+}
+
+/*************** DMA-QUEUE-GENERAL-FUNCTIONS  *****
+ * DMA services
+ *
+ * Theory of operation
+ *
+ * A Tx or Rx queue resides in host DRAM, and is comprised of a circular buffer
+ * of buffer descriptors, each of which points to one or more data buffers for
+ * the device to read from or fill.  Driver and device exchange status of each
+ * queue via "read" and "write" pointers.  Driver keeps minimum of 2 empty
+ * entries in each circular buffer, to protect against confusing empty and full
+ * queue states.
+ *
+ * The device reads or writes the data in the queues via the device's several
+ * DMA/FIFO channels.  Each queue is mapped to a single DMA channel.
+ *
+ * For Tx queue, there are low mark and high mark limits. If, after queuing
+ * the packet for Tx, free space become < low mark, Tx queue stopped. When
+ * reclaiming packets (on 'tx done IRQ), if free space become > high mark,
+ * Tx queue resumed.
+ *
+ ***************************************************/
+
+int iwl_queue_space(const struct iwl_queue *q)
+{
+	int s = q->read_ptr - q->write_ptr;
+
+	if (q->read_ptr > q->write_ptr)
+		s -= q->n_bd;
+
+	if (s <= 0)
+		s += q->n_window;
+	/* keep some reserve to not confuse empty and full situations */
+	s -= 2;
+	if (s < 0)
+		s = 0;
+	return s;
+}
+
+/**
+ * iwl_queue_init - Initialize queue's high/low-water and read/write indexes
+ */
+int iwl_queue_init(struct iwl_queue *q, int count, int slots_num, u32 id)
+{
+	q->n_bd = count;
+	q->n_window = slots_num;
+	q->id = id;
+
+	/* count must be power-of-two size, otherwise iwl_queue_inc_wrap
+	 * and iwl_queue_dec_wrap are broken. */
+	if (WARN_ON(!is_power_of_2(count)))
+		return -EINVAL;
+
+	/* slots_num must be power-of-two size, otherwise
+	 * get_cmd_index is broken. */
+	if (WARN_ON(!is_power_of_2(slots_num)))
+		return -EINVAL;
+
+	q->low_mark = q->n_window / 4;
+	if (q->low_mark < 4)
+		q->low_mark = 4;
+
+	q->high_mark = q->n_window / 8;
+	if (q->high_mark < 2)
+		q->high_mark = 2;
+
+	q->write_ptr = q->read_ptr = 0;
+
+	return 0;
+}
+
+static void iwlagn_txq_inval_byte_cnt_tbl(struct iwl_trans *trans,
+					  struct iwl_tx_queue *txq)
+{
+	struct iwl_trans_pcie *trans_pcie =
+		IWL_TRANS_GET_PCIE_TRANS(trans);
+	struct iwlagn_scd_bc_tbl *scd_bc_tbl = trans_pcie->scd_bc_tbls.addr;
+	int txq_id = txq->q.id;
+	int read_ptr = txq->q.read_ptr;
+	u8 sta_id = 0;
+	__le16 bc_ent;
+
+	WARN_ON(read_ptr >= TFD_QUEUE_SIZE_MAX);
+
+	if (txq_id != trans->shrd->cmd_queue)
+		sta_id = txq->cmd[read_ptr]->cmd.tx.sta_id;
+
+	bc_ent = cpu_to_le16(1 | (sta_id << 12));
+	scd_bc_tbl[txq_id].tfd_offset[read_ptr] = bc_ent;
+
+	if (read_ptr < TFD_QUEUE_SIZE_BC_DUP)
+		scd_bc_tbl[txq_id].
+			tfd_offset[TFD_QUEUE_SIZE_MAX + read_ptr] = bc_ent;
+}
+
+static int iwlagn_tx_queue_set_q2ratid(struct iwl_trans *trans, u16 ra_tid,
+					u16 txq_id)
+{
+	u32 tbl_dw_addr;
+	u32 tbl_dw;
+	u16 scd_q2ratid;
+
+	struct iwl_trans_pcie *trans_pcie =
+		IWL_TRANS_GET_PCIE_TRANS(trans);
+
+	scd_q2ratid = ra_tid & SCD_QUEUE_RA_TID_MAP_RATID_MSK;
+
+	tbl_dw_addr = trans_pcie->scd_base_addr +
+			SCD_TRANS_TBL_OFFSET_QUEUE(txq_id);
+
+	tbl_dw = iwl_read_targ_mem(bus(trans), tbl_dw_addr);
+
+	if (txq_id & 0x1)
+		tbl_dw = (scd_q2ratid << 16) | (tbl_dw & 0x0000FFFF);
+	else
+		tbl_dw = scd_q2ratid | (tbl_dw & 0xFFFF0000);
+
+	iwl_write_targ_mem(bus(trans), tbl_dw_addr, tbl_dw);
+
+	return 0;
+}
+
+static void iwlagn_tx_queue_stop_scheduler(struct iwl_trans *trans, u16 txq_id)
+{
+	/* Simply stop the queue, but don't change any configuration;
+	 * the SCD_ACT_EN bit is the write-enable mask for the ACTIVE bit. */
+	iwl_write_prph(bus(trans),
+		SCD_QUEUE_STATUS_BITS(txq_id),
+		(0 << SCD_QUEUE_STTS_REG_POS_ACTIVE)|
+		(1 << SCD_QUEUE_STTS_REG_POS_SCD_ACT_EN));
+}
+
+void iwl_trans_set_wr_ptrs(struct iwl_trans *trans,
+				int txq_id, u32 index)
+{
+	iwl_write_direct32(bus(trans), HBUS_TARG_WRPTR,
+			(index & 0xff) | (txq_id << 8));
+	iwl_write_prph(bus(trans), SCD_QUEUE_RDPTR(txq_id), index);
+}
+
+void iwl_trans_tx_queue_set_status(struct iwl_trans *trans,
+					struct iwl_tx_queue *txq,
+					int tx_fifo_id, int scd_retry)
+{
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+	int txq_id = txq->q.id;
+	int active =
+		test_bit(txq_id, &trans_pcie->txq_ctx_active_msk) ? 1 : 0;
+
+	iwl_write_prph(bus(trans), SCD_QUEUE_STATUS_BITS(txq_id),
+			(active << SCD_QUEUE_STTS_REG_POS_ACTIVE) |
+			(tx_fifo_id << SCD_QUEUE_STTS_REG_POS_TXF) |
+			(1 << SCD_QUEUE_STTS_REG_POS_WSL) |
+			SCD_QUEUE_STTS_REG_MSK);
+
+	txq->sched_retry = scd_retry;
+
+	IWL_DEBUG_INFO(trans, "%s %s Queue %d on FIFO %d\n",
+		       active ? "Activate" : "Deactivate",
+		       scd_retry ? "BA" : "AC/CMD", txq_id, tx_fifo_id);
+}
+
+static inline int get_fifo_from_tid(struct iwl_trans_pcie *trans_pcie,
+				    u8 ctx, u16 tid)
+{
+	const u8 *ac_to_fifo = trans_pcie->ac_to_fifo[ctx];
+	if (likely(tid < ARRAY_SIZE(tid_to_ac)))
+		return ac_to_fifo[tid_to_ac[tid]];
+
+	/* no support for TIDs 8-15 yet */
+	return -EINVAL;
+}
+
+void iwl_trans_pcie_tx_agg_setup(struct iwl_trans *trans,
+				 enum iwl_rxon_context_id ctx, int sta_id,
+				 int tid, int frame_limit)
+{
+	int tx_fifo, txq_id, ssn_idx;
+	u16 ra_tid;
+	unsigned long flags;
+	struct iwl_tid_data *tid_data;
+
+	struct iwl_trans_pcie *trans_pcie =
+		IWL_TRANS_GET_PCIE_TRANS(trans);
+
+	if (WARN_ON(sta_id == IWL_INVALID_STATION))
+		return;
+	if (WARN_ON(tid >= IWL_MAX_TID_COUNT))
+		return;
+
+	tx_fifo = get_fifo_from_tid(trans_pcie, ctx, tid);
+	if (WARN_ON(tx_fifo < 0)) {
+		IWL_ERR(trans, "txq_agg_setup, bad fifo: %d\n", tx_fifo);
+		return;
+	}
+
+	spin_lock_irqsave(&trans->shrd->sta_lock, flags);
+	tid_data = &trans->shrd->tid_data[sta_id][tid];
+	ssn_idx = SEQ_TO_SN(tid_data->seq_number);
+	txq_id = tid_data->agg.txq_id;
+	spin_unlock_irqrestore(&trans->shrd->sta_lock, flags);
+
+	ra_tid = BUILD_RAxTID(sta_id, tid);
+
+	spin_lock_irqsave(&trans->shrd->lock, flags);
+
+	/* Stop this Tx queue before configuring it */
+	iwlagn_tx_queue_stop_scheduler(trans, txq_id);
+
+	/* Map receiver-address / traffic-ID to this queue */
+	iwlagn_tx_queue_set_q2ratid(trans, ra_tid, txq_id);
+
+	/* Set this queue as a chain-building queue */
+	iwl_set_bits_prph(bus(trans), SCD_QUEUECHAIN_SEL, (1<<txq_id));
+
+	/* enable aggregations for the queue */
+	iwl_set_bits_prph(bus(trans), SCD_AGGR_SEL, (1<<txq_id));
+
+	/* Place first TFD at index corresponding to start sequence number.
+	 * Assumes that ssn_idx is valid (!= 0xFFF) */
+	trans_pcie->txq[txq_id].q.read_ptr = (ssn_idx & 0xff);
+	trans_pcie->txq[txq_id].q.write_ptr = (ssn_idx & 0xff);
+	iwl_trans_set_wr_ptrs(trans, txq_id, ssn_idx);
+
+	/* Set up Tx window size and frame limit for this queue */
+	iwl_write_targ_mem(bus(trans), trans_pcie->scd_base_addr +
+			SCD_CONTEXT_QUEUE_OFFSET(txq_id) +
+			sizeof(u32),
+			((frame_limit <<
+			SCD_QUEUE_CTX_REG2_WIN_SIZE_POS) &
+			SCD_QUEUE_CTX_REG2_WIN_SIZE_MSK) |
+			((frame_limit <<
+			SCD_QUEUE_CTX_REG2_FRAME_LIMIT_POS) &
+			SCD_QUEUE_CTX_REG2_FRAME_LIMIT_MSK));
+
+	iwl_set_bits_prph(bus(trans), SCD_INTERRUPT_MASK, (1 << txq_id));
+
+	/* Set up Status area in SRAM, map to Tx DMA/FIFO, activate the queue */
+	iwl_trans_tx_queue_set_status(trans, &trans_pcie->txq[txq_id],
+					tx_fifo, 1);
+
+	trans_pcie->txq[txq_id].sta_id = sta_id;
+	trans_pcie->txq[txq_id].tid = tid;
+
+	spin_unlock_irqrestore(&trans->shrd->lock, flags);
+}
+
+/*
+ * Find first available (lowest unused) Tx Queue, mark it "active".
+ * Called only when finding queue for aggregation.
+ * Should never return anything < 7, because they should already
+ * be in use as EDCA AC (0-3), Command (4), reserved (5, 6)
+ */
+static int iwlagn_txq_ctx_activate_free(struct iwl_trans *trans)
+{
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+	int txq_id;
+
+	for (txq_id = 0; txq_id < hw_params(trans).max_txq_num; txq_id++)
+		if (!test_and_set_bit(txq_id,
+					&trans_pcie->txq_ctx_active_msk))
+			return txq_id;
+	return -1;
+}
+
+int iwl_trans_pcie_tx_agg_alloc(struct iwl_trans *trans,
+				enum iwl_rxon_context_id ctx, int sta_id,
+				int tid, u16 *ssn)
+{
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+	struct iwl_tid_data *tid_data;
+	unsigned long flags;
+	u16 txq_id;
+
+	txq_id = iwlagn_txq_ctx_activate_free(trans);
+	if (txq_id == -1) {
+		IWL_ERR(trans, "No free aggregation queue available\n");
+		return -ENXIO;
+	}
+
+	spin_lock_irqsave(&trans->shrd->sta_lock, flags);
+	tid_data = &trans->shrd->tid_data[sta_id][tid];
+	*ssn = SEQ_TO_SN(tid_data->seq_number);
+	tid_data->agg.txq_id = txq_id;
+	iwl_set_swq_id(&trans_pcie->txq[txq_id], get_ac_from_tid(tid), txq_id);
+
+	tid_data = &trans->shrd->tid_data[sta_id][tid];
+	if (tid_data->tfds_in_queue == 0) {
+		IWL_DEBUG_HT(trans, "HW queue is empty\n");
+		tid_data->agg.state = IWL_AGG_ON;
+		iwl_start_tx_ba_trans_ready(priv(trans), ctx, sta_id, tid);
+	} else {
+		IWL_DEBUG_HT(trans, "HW queue is NOT empty: %d packets in HW"
+			     "queue\n", tid_data->tfds_in_queue);
+		tid_data->agg.state = IWL_EMPTYING_HW_QUEUE_ADDBA;
+	}
+	spin_unlock_irqrestore(&trans->shrd->sta_lock, flags);
+
+	return 0;
+}
+
+void iwl_trans_pcie_txq_agg_disable(struct iwl_trans *trans, int txq_id)
+{
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+	iwlagn_tx_queue_stop_scheduler(trans, txq_id);
+
+	iwl_clear_bits_prph(bus(trans), SCD_AGGR_SEL, (1 << txq_id));
+
+	trans_pcie->txq[txq_id].q.read_ptr = 0;
+	trans_pcie->txq[txq_id].q.write_ptr = 0;
+	/* supposes that ssn_idx is valid (!= 0xFFF) */
+	iwl_trans_set_wr_ptrs(trans, txq_id, 0);
+
+	iwl_clear_bits_prph(bus(trans), SCD_INTERRUPT_MASK, (1 << txq_id));
+	iwl_txq_ctx_deactivate(trans_pcie, txq_id);
+	iwl_trans_tx_queue_set_status(trans, &trans_pcie->txq[txq_id], 0, 0);
+}
+
+int iwl_trans_pcie_tx_agg_disable(struct iwl_trans *trans,
+				  enum iwl_rxon_context_id ctx, int sta_id,
+				  int tid)
+{
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+	unsigned long flags;
+	int read_ptr, write_ptr;
+	struct iwl_tid_data *tid_data;
+	int txq_id;
+
+	spin_lock_irqsave(&trans->shrd->sta_lock, flags);
+
+	tid_data = &trans->shrd->tid_data[sta_id][tid];
+	txq_id = tid_data->agg.txq_id;
+
+	if ((IWLAGN_FIRST_AMPDU_QUEUE > txq_id) ||
+	    (IWLAGN_FIRST_AMPDU_QUEUE +
+		hw_params(trans).num_ampdu_queues <= txq_id)) {
+		IWL_ERR(trans,
+			"queue number out of range: %d, must be %d to %d\n",
+			txq_id, IWLAGN_FIRST_AMPDU_QUEUE,
+			IWLAGN_FIRST_AMPDU_QUEUE +
+			hw_params(trans).num_ampdu_queues - 1);
+		spin_unlock_irqrestore(&trans->shrd->sta_lock, flags);
+		return -EINVAL;
+	}
+
+	switch (trans->shrd->tid_data[sta_id][tid].agg.state) {
+	case IWL_EMPTYING_HW_QUEUE_ADDBA:
+		/*
+		* This can happen if the peer stops aggregation
+		* again before we've had a chance to drain the
+		* queue we selected previously, i.e. before the
+		* session was really started completely.
+		*/
+		IWL_DEBUG_HT(trans, "AGG stop before setup done\n");
+		goto turn_off;
+	case IWL_AGG_ON:
+		break;
+	default:
+		IWL_WARN(trans, "Stopping AGG while state not ON"
+				"or starting\n");
+	}
+
+	write_ptr = trans_pcie->txq[txq_id].q.write_ptr;
+	read_ptr = trans_pcie->txq[txq_id].q.read_ptr;
+
+	/* The queue is not empty */
+	if (write_ptr != read_ptr) {
+		IWL_DEBUG_HT(trans, "Stopping a non empty AGG HW QUEUE\n");
+		trans->shrd->tid_data[sta_id][tid].agg.state =
+			IWL_EMPTYING_HW_QUEUE_DELBA;
+		spin_unlock_irqrestore(&trans->shrd->sta_lock, flags);
+		return 0;
+	}
+
+	IWL_DEBUG_HT(trans, "HW queue is empty\n");
+turn_off:
+	trans->shrd->tid_data[sta_id][tid].agg.state = IWL_AGG_OFF;
+
+	/* do not restore/save irqs */
+	spin_unlock(&trans->shrd->sta_lock);
+	spin_lock(&trans->shrd->lock);
+
+	iwl_trans_pcie_txq_agg_disable(trans, txq_id);
+
+	spin_unlock_irqrestore(&trans->shrd->lock, flags);
+
+	iwl_stop_tx_ba_trans_ready(priv(trans), ctx, sta_id, tid);
+
+	return 0;
+}
+
+/*************** HOST COMMAND QUEUE FUNCTIONS   *****/
+
+/**
+ * iwl_enqueue_hcmd - enqueue a uCode command
+ * @priv: device private data point
+ * @cmd: a point to the ucode command structure
+ *
+ * The function returns < 0 values to indicate the operation is
+ * failed. On success, it turns the index (> 0) of command in the
+ * command queue.
+ */
+static int iwl_enqueue_hcmd(struct iwl_trans *trans, struct iwl_host_cmd *cmd)
+{
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+	struct iwl_tx_queue *txq = &trans_pcie->txq[trans->shrd->cmd_queue];
+	struct iwl_queue *q = &txq->q;
+	struct iwl_device_cmd *out_cmd;
+	struct iwl_cmd_meta *out_meta;
+	dma_addr_t phys_addr;
+	unsigned long flags;
+	u32 idx;
+	u16 copy_size, cmd_size;
+	bool is_ct_kill = false;
+	bool had_nocopy = false;
+	int i;
+	u8 *cmd_dest;
+#ifdef CONFIG_IWLWIFI_DEVICE_TRACING
+	const void *trace_bufs[IWL_MAX_CMD_TFDS + 1] = {};
+	int trace_lens[IWL_MAX_CMD_TFDS + 1] = {};
+	int trace_idx;
+#endif
+
+	if (test_bit(STATUS_FW_ERROR, &trans->shrd->status)) {
+		IWL_WARN(trans, "fw recovery, no hcmd send\n");
+		return -EIO;
+	}
+
+	if ((trans->shrd->ucode_owner == IWL_OWNERSHIP_TM) &&
+	    !(cmd->flags & CMD_ON_DEMAND)) {
+		IWL_DEBUG_HC(trans, "tm own the uCode, no regular hcmd send\n");
+		return -EIO;
+	}
+
+	copy_size = sizeof(out_cmd->hdr);
+	cmd_size = sizeof(out_cmd->hdr);
+
+	/* need one for the header if the first is NOCOPY */
+	BUILD_BUG_ON(IWL_MAX_CMD_TFDS > IWL_NUM_OF_TBS - 1);
+
+	for (i = 0; i < IWL_MAX_CMD_TFDS; i++) {
+		if (!cmd->len[i])
+			continue;
+		if (cmd->dataflags[i] & IWL_HCMD_DFL_NOCOPY) {
+			had_nocopy = true;
+		} else {
+			/* NOCOPY must not be followed by normal! */
+			if (WARN_ON(had_nocopy))
+				return -EINVAL;
+			copy_size += cmd->len[i];
+		}
+		cmd_size += cmd->len[i];
+	}
+
+	/*
+	 * If any of the command structures end up being larger than
+	 * the TFD_MAX_PAYLOAD_SIZE and they aren't dynamically
+	 * allocated into separate TFDs, then we will need to
+	 * increase the size of the buffers.
+	 */
+	if (WARN_ON(copy_size > TFD_MAX_PAYLOAD_SIZE))
+		return -EINVAL;
+
+	if (iwl_is_rfkill(trans->shrd) || iwl_is_ctkill(trans->shrd)) {
+		IWL_WARN(trans, "Not sending command - %s KILL\n",
+			 iwl_is_rfkill(trans->shrd) ? "RF" : "CT");
+		return -EIO;
+	}
+
+	spin_lock_irqsave(&trans->hcmd_lock, flags);
+
+	if (iwl_queue_space(q) < ((cmd->flags & CMD_ASYNC) ? 2 : 1)) {
+		spin_unlock_irqrestore(&trans->hcmd_lock, flags);
+
+		IWL_ERR(trans, "No space in command queue\n");
+		is_ct_kill = iwl_check_for_ct_kill(priv(trans));
+		if (!is_ct_kill) {
+			IWL_ERR(trans, "Restarting adapter queue is full\n");
+			iwlagn_fw_error(priv(trans), false);
+		}
+		return -ENOSPC;
+	}
+
+	idx = get_cmd_index(q, q->write_ptr);
+	out_cmd = txq->cmd[idx];
+	out_meta = &txq->meta[idx];
+
+	memset(out_meta, 0, sizeof(*out_meta));	/* re-initialize to NULL */
+	if (cmd->flags & CMD_WANT_SKB)
+		out_meta->source = cmd;
+	if (cmd->flags & CMD_ASYNC)
+		out_meta->callback = cmd->callback;
+
+	/* set up the header */
+
+	out_cmd->hdr.cmd = cmd->id;
+	out_cmd->hdr.flags = 0;
+	out_cmd->hdr.sequence =
+		cpu_to_le16(QUEUE_TO_SEQ(trans->shrd->cmd_queue) |
+					 INDEX_TO_SEQ(q->write_ptr));
+
+	/* and copy the data that needs to be copied */
+
+	cmd_dest = &out_cmd->cmd.payload[0];
+	for (i = 0; i < IWL_MAX_CMD_TFDS; i++) {
+		if (!cmd->len[i])
+			continue;
+		if (cmd->dataflags[i] & IWL_HCMD_DFL_NOCOPY)
+			break;
+		memcpy(cmd_dest, cmd->data[i], cmd->len[i]);
+		cmd_dest += cmd->len[i];
+	}
+
+	IWL_DEBUG_HC(trans, "Sending command %s (#%x), seq: 0x%04X, "
+			"%d bytes at %d[%d]:%d\n",
+			get_cmd_string(out_cmd->hdr.cmd),
+			out_cmd->hdr.cmd,
+			le16_to_cpu(out_cmd->hdr.sequence), cmd_size,
+			q->write_ptr, idx, trans->shrd->cmd_queue);
+
+	phys_addr = dma_map_single(bus(trans)->dev, &out_cmd->hdr, copy_size,
+				DMA_BIDIRECTIONAL);
+	if (unlikely(dma_mapping_error(bus(trans)->dev, phys_addr))) {
+		idx = -ENOMEM;
+		goto out;
+	}
+
+	dma_unmap_addr_set(out_meta, mapping, phys_addr);
+	dma_unmap_len_set(out_meta, len, copy_size);
+
+	iwlagn_txq_attach_buf_to_tfd(trans, txq,
+					phys_addr, copy_size, 1);
+#ifdef CONFIG_IWLWIFI_DEVICE_TRACING
+	trace_bufs[0] = &out_cmd->hdr;
+	trace_lens[0] = copy_size;
+	trace_idx = 1;
+#endif
+
+	for (i = 0; i < IWL_MAX_CMD_TFDS; i++) {
+		if (!cmd->len[i])
+			continue;
+		if (!(cmd->dataflags[i] & IWL_HCMD_DFL_NOCOPY))
+			continue;
+		phys_addr = dma_map_single(bus(trans)->dev,
+					   (void *)cmd->data[i],
+					   cmd->len[i], DMA_BIDIRECTIONAL);
+		if (dma_mapping_error(bus(trans)->dev, phys_addr)) {
+			iwlagn_unmap_tfd(trans, out_meta,
+					 &txq->tfds[q->write_ptr],
+					 DMA_BIDIRECTIONAL);
+			idx = -ENOMEM;
+			goto out;
+		}
+
+		iwlagn_txq_attach_buf_to_tfd(trans, txq, phys_addr,
+					     cmd->len[i], 0);
+#ifdef CONFIG_IWLWIFI_DEVICE_TRACING
+		trace_bufs[trace_idx] = cmd->data[i];
+		trace_lens[trace_idx] = cmd->len[i];
+		trace_idx++;
+#endif
+	}
+
+	out_meta->flags = cmd->flags;
+
+	txq->need_update = 1;
+
+	/* check that tracing gets all possible blocks */
+	BUILD_BUG_ON(IWL_MAX_CMD_TFDS + 1 != 3);
+#ifdef CONFIG_IWLWIFI_DEVICE_TRACING
+	trace_iwlwifi_dev_hcmd(priv(trans), cmd->flags,
+			       trace_bufs[0], trace_lens[0],
+			       trace_bufs[1], trace_lens[1],
+			       trace_bufs[2], trace_lens[2]);
+#endif
+
+	/* Increment and update queue's write index */
+	q->write_ptr = iwl_queue_inc_wrap(q->write_ptr, q->n_bd);
+	iwl_txq_update_write_ptr(trans, txq);
+
+ out:
+	spin_unlock_irqrestore(&trans->hcmd_lock, flags);
+	return idx;
+}
+
+/**
+ * iwl_hcmd_queue_reclaim - Reclaim TX command queue entries already Tx'd
+ *
+ * When FW advances 'R' index, all entries between old and new 'R' index
+ * need to be reclaimed. As result, some free space forms.  If there is
+ * enough free space (> low mark), wake the stack that feeds us.
+ */
+static void iwl_hcmd_queue_reclaim(struct iwl_trans *trans, int txq_id,
+				   int idx)
+{
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+	struct iwl_tx_queue *txq = &trans_pcie->txq[txq_id];
+	struct iwl_queue *q = &txq->q;
+	int nfreed = 0;
+
+	if ((idx >= q->n_bd) || (iwl_queue_used(q, idx) == 0)) {
+		IWL_ERR(trans, "%s: Read index for DMA queue txq id (%d), "
+			  "index %d is out of range [0-%d] %d %d.\n", __func__,
+			  txq_id, idx, q->n_bd, q->write_ptr, q->read_ptr);
+		return;
+	}
+
+	for (idx = iwl_queue_inc_wrap(idx, q->n_bd); q->read_ptr != idx;
+	     q->read_ptr = iwl_queue_inc_wrap(q->read_ptr, q->n_bd)) {
+
+		if (nfreed++ > 0) {
+			IWL_ERR(trans, "HCMD skipped: index (%d) %d %d\n", idx,
+					q->write_ptr, q->read_ptr);
+			iwlagn_fw_error(priv(trans), false);
+		}
+
+	}
+}
+
+/**
+ * iwl_tx_cmd_complete - Pull unused buffers off the queue and reclaim them
+ * @rxb: Rx buffer to reclaim
+ *
+ * If an Rx buffer has an async callback associated with it the callback
+ * will be executed.  The attached skb (if present) will only be freed
+ * if the callback returns 1
+ */
+void iwl_tx_cmd_complete(struct iwl_trans *trans, struct iwl_rx_mem_buffer *rxb)
+{
+	struct iwl_rx_packet *pkt = rxb_addr(rxb);
+	u16 sequence = le16_to_cpu(pkt->hdr.sequence);
+	int txq_id = SEQ_TO_QUEUE(sequence);
+	int index = SEQ_TO_INDEX(sequence);
+	int cmd_index;
+	struct iwl_device_cmd *cmd;
+	struct iwl_cmd_meta *meta;
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+	struct iwl_tx_queue *txq = &trans_pcie->txq[trans->shrd->cmd_queue];
+	unsigned long flags;
+
+	/* If a Tx command is being handled and it isn't in the actual
+	 * command queue then there a command routing bug has been introduced
+	 * in the queue management code. */
+	if (WARN(txq_id != trans->shrd->cmd_queue,
+		 "wrong command queue %d (should be %d), sequence 0x%X readp=%d writep=%d\n",
+		  txq_id, trans->shrd->cmd_queue, sequence,
+		  trans_pcie->txq[trans->shrd->cmd_queue].q.read_ptr,
+		  trans_pcie->txq[trans->shrd->cmd_queue].q.write_ptr)) {
+		iwl_print_hex_error(trans, pkt, 32);
+		return;
+	}
+
+	cmd_index = get_cmd_index(&txq->q, index);
+	cmd = txq->cmd[cmd_index];
+	meta = &txq->meta[cmd_index];
+
+	iwlagn_unmap_tfd(trans, meta, &txq->tfds[index],
+			 DMA_BIDIRECTIONAL);
+
+	/* Input error checking is done when commands are added to queue. */
+	if (meta->flags & CMD_WANT_SKB) {
+		meta->source->reply_page = (unsigned long)rxb_addr(rxb);
+		rxb->page = NULL;
+	} else if (meta->callback)
+		meta->callback(trans->shrd, cmd, pkt);
+
+	spin_lock_irqsave(&trans->hcmd_lock, flags);
+
+	iwl_hcmd_queue_reclaim(trans, txq_id, index);
+
+	if (!(meta->flags & CMD_ASYNC)) {
+		clear_bit(STATUS_HCMD_ACTIVE, &trans->shrd->status);
+		IWL_DEBUG_INFO(trans, "Clearing HCMD_ACTIVE for command %s\n",
+			       get_cmd_string(cmd->hdr.cmd));
+		wake_up_interruptible(&trans->shrd->wait_command_queue);
+	}
+
+	meta->flags = 0;
+
+	spin_unlock_irqrestore(&trans->hcmd_lock, flags);
+}
+
+#define HOST_COMPLETE_TIMEOUT (2 * HZ)
+
+static void iwl_generic_cmd_callback(struct iwl_shared *shrd,
+				     struct iwl_device_cmd *cmd,
+				     struct iwl_rx_packet *pkt)
+{
+	if (pkt->hdr.flags & IWL_CMD_FAILED_MSK) {
+		IWL_ERR(shrd->trans, "Bad return from %s (0x%08X)\n",
+			get_cmd_string(cmd->hdr.cmd), pkt->hdr.flags);
+		return;
+	}
+
+#ifdef CONFIG_IWLWIFI_DEBUG
+	switch (cmd->hdr.cmd) {
+	case REPLY_TX_LINK_QUALITY_CMD:
+	case SENSITIVITY_CMD:
+		IWL_DEBUG_HC_DUMP(shrd->trans, "back from %s (0x%08X)\n",
+				get_cmd_string(cmd->hdr.cmd), pkt->hdr.flags);
+		break;
+	default:
+		IWL_DEBUG_HC(shrd->trans, "back from %s (0x%08X)\n",
+				get_cmd_string(cmd->hdr.cmd), pkt->hdr.flags);
+	}
+#endif
+}
+
+static int iwl_send_cmd_async(struct iwl_trans *trans, struct iwl_host_cmd *cmd)
+{
+	int ret;
+
+	/* An asynchronous command can not expect an SKB to be set. */
+	if (WARN_ON(cmd->flags & CMD_WANT_SKB))
+		return -EINVAL;
+
+	/* Assign a generic callback if one is not provided */
+	if (!cmd->callback)
+		cmd->callback = iwl_generic_cmd_callback;
+
+	if (test_bit(STATUS_EXIT_PENDING, &trans->shrd->status))
+		return -EBUSY;
+
+	ret = iwl_enqueue_hcmd(trans, cmd);
+	if (ret < 0) {
+		IWL_ERR(trans, "Error sending %s: enqueue_hcmd failed: %d\n",
+			  get_cmd_string(cmd->id), ret);
+		return ret;
+	}
+	return 0;
+}
+
+static int iwl_send_cmd_sync(struct iwl_trans *trans, struct iwl_host_cmd *cmd)
+{
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+	int cmd_idx;
+	int ret;
+
+	lockdep_assert_held(&trans->shrd->mutex);
+
+	 /* A synchronous command can not have a callback set. */
+	if (WARN_ON(cmd->callback))
+		return -EINVAL;
+
+	IWL_DEBUG_INFO(trans, "Attempting to send sync command %s\n",
+			get_cmd_string(cmd->id));
+
+	set_bit(STATUS_HCMD_ACTIVE, &trans->shrd->status);
+	IWL_DEBUG_INFO(trans, "Setting HCMD_ACTIVE for command %s\n",
+			get_cmd_string(cmd->id));
+
+	cmd_idx = iwl_enqueue_hcmd(trans, cmd);
+	if (cmd_idx < 0) {
+		ret = cmd_idx;
+		clear_bit(STATUS_HCMD_ACTIVE, &trans->shrd->status);
+		IWL_ERR(trans, "Error sending %s: enqueue_hcmd failed: %d\n",
+			  get_cmd_string(cmd->id), ret);
+		return ret;
+	}
+
+	ret = wait_event_interruptible_timeout(trans->shrd->wait_command_queue,
+			!test_bit(STATUS_HCMD_ACTIVE, &trans->shrd->status),
+			HOST_COMPLETE_TIMEOUT);
+	if (!ret) {
+		if (test_bit(STATUS_HCMD_ACTIVE, &trans->shrd->status)) {
+			IWL_ERR(trans,
+				"Error sending %s: time out after %dms.\n",
+				get_cmd_string(cmd->id),
+				jiffies_to_msecs(HOST_COMPLETE_TIMEOUT));
+
+			clear_bit(STATUS_HCMD_ACTIVE, &trans->shrd->status);
+			IWL_DEBUG_INFO(trans, "Clearing HCMD_ACTIVE for command"
+				 "%s\n", get_cmd_string(cmd->id));
+			ret = -ETIMEDOUT;
+			goto cancel;
+		}
+	}
+
+	if (test_bit(STATUS_RF_KILL_HW, &trans->shrd->status)) {
+		IWL_ERR(trans, "Command %s aborted: RF KILL Switch\n",
+			       get_cmd_string(cmd->id));
+		ret = -ECANCELED;
+		goto fail;
+	}
+	if (test_bit(STATUS_FW_ERROR, &trans->shrd->status)) {
+		IWL_ERR(trans, "Command %s failed: FW Error\n",
+			       get_cmd_string(cmd->id));
+		ret = -EIO;
+		goto fail;
+	}
+	if ((cmd->flags & CMD_WANT_SKB) && !cmd->reply_page) {
+		IWL_ERR(trans, "Error: Response NULL in '%s'\n",
+			  get_cmd_string(cmd->id));
+		ret = -EIO;
+		goto cancel;
+	}
+
+	return 0;
+
+cancel:
+	if (cmd->flags & CMD_WANT_SKB) {
+		/*
+		 * Cancel the CMD_WANT_SKB flag for the cmd in the
+		 * TX cmd queue. Otherwise in case the cmd comes
+		 * in later, it will possibly set an invalid
+		 * address (cmd->meta.source).
+		 */
+		trans_pcie->txq[trans->shrd->cmd_queue].meta[cmd_idx].flags &=
+							~CMD_WANT_SKB;
+	}
+fail:
+	if (cmd->reply_page) {
+		iwl_free_pages(trans->shrd, cmd->reply_page);
+		cmd->reply_page = 0;
+	}
+
+	return ret;
+}
+
+int iwl_trans_pcie_send_cmd(struct iwl_trans *trans, struct iwl_host_cmd *cmd)
+{
+	if (cmd->flags & CMD_ASYNC)
+		return iwl_send_cmd_async(trans, cmd);
+
+	return iwl_send_cmd_sync(trans, cmd);
+}
+
+int iwl_trans_pcie_send_cmd_pdu(struct iwl_trans *trans, u8 id, u32 flags,
+		u16 len, const void *data)
+{
+	struct iwl_host_cmd cmd = {
+		.id = id,
+		.len = { len, },
+		.data = { data, },
+		.flags = flags,
+	};
+
+	return iwl_trans_pcie_send_cmd(trans, &cmd);
+}
+
+/* Frees buffers until index _not_ inclusive */
+int iwl_tx_queue_reclaim(struct iwl_trans *trans, int txq_id, int index,
+			 struct sk_buff_head *skbs)
+{
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+	struct iwl_tx_queue *txq = &trans_pcie->txq[txq_id];
+	struct iwl_queue *q = &txq->q;
+	int last_to_free;
+	int freed = 0;
+
+	/* This function is not meant to release cmd queue*/
+	if (WARN_ON(txq_id == trans->shrd->cmd_queue))
+		return 0;
+
+	/*Since we free until index _not_ inclusive, the one before index is
+	 * the last we will free. This one must be used */
+	last_to_free = iwl_queue_dec_wrap(index, q->n_bd);
+
+	if ((index >= q->n_bd) ||
+	   (iwl_queue_used(q, last_to_free) == 0)) {
+		IWL_ERR(trans, "%s: Read index for DMA queue txq id (%d), "
+			  "last_to_free %d is out of range [0-%d] %d %d.\n",
+			  __func__, txq_id, last_to_free, q->n_bd,
+			  q->write_ptr, q->read_ptr);
+		return 0;
+	}
+
+	IWL_DEBUG_TX_REPLY(trans, "reclaim: [%d, %d, %d]\n", txq_id,
+			   q->read_ptr, index);
+
+	if (WARN_ON(!skb_queue_empty(skbs)))
+		return 0;
+
+	for (;
+	     q->read_ptr != index;
+	     q->read_ptr = iwl_queue_inc_wrap(q->read_ptr, q->n_bd)) {
+
+		if (WARN_ON_ONCE(txq->skbs[txq->q.read_ptr] == NULL))
+			continue;
+
+		__skb_queue_tail(skbs, txq->skbs[txq->q.read_ptr]);
+
+		txq->skbs[txq->q.read_ptr] = NULL;
+
+		iwlagn_txq_inval_byte_cnt_tbl(trans, txq);
+
+		iwlagn_txq_free_tfd(trans, txq, txq->q.read_ptr, DMA_TO_DEVICE);
+		freed++;
+	}
+	return freed;
+}
+
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
new file mode 100644
index 0000000..1c931b7
--- /dev/null
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -0,0 +1,1996 @@
+/******************************************************************************
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2007 - 2011 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
+ * USA
+ *
+ * The full GNU General Public License is included in this distribution
+ * in the file called LICENSE.GPL.
+ *
+ * Contact Information:
+ *  Intel Linux Wireless <ilw@linux.intel.com>
+ * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
+ *
+ * BSD LICENSE
+ *
+ * Copyright(c) 2005 - 2011 Intel Corporation. All rights reserved.
+ * All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ *  * Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ *  * Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in
+ *    the documentation and/or other materials provided with the
+ *    distribution.
+ *  * Neither the name Intel Corporation nor the names of its
+ *    contributors may be used to endorse or promote products derived
+ *    from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ *****************************************************************************/
+#include <linux/interrupt.h>
+#include <linux/debugfs.h>
+#include <linux/bitops.h>
+#include <linux/gfp.h>
+
+#include "iwl-trans.h"
+#include "iwl-trans-pcie-int.h"
+#include "iwl-csr.h"
+#include "iwl-prph.h"
+#include "iwl-shared.h"
+#include "iwl-eeprom.h"
+#include "iwl-agn-hw.h"
+
+static int iwl_trans_rx_alloc(struct iwl_trans *trans)
+{
+	struct iwl_trans_pcie *trans_pcie =
+		IWL_TRANS_GET_PCIE_TRANS(trans);
+	struct iwl_rx_queue *rxq = &trans_pcie->rxq;
+	struct device *dev = bus(trans)->dev;
+
+	memset(&trans_pcie->rxq, 0, sizeof(trans_pcie->rxq));
+
+	spin_lock_init(&rxq->lock);
+	INIT_LIST_HEAD(&rxq->rx_free);
+	INIT_LIST_HEAD(&rxq->rx_used);
+
+	if (WARN_ON(rxq->bd || rxq->rb_stts))
+		return -EINVAL;
+
+	/* Allocate the circular buffer of Read Buffer Descriptors (RBDs) */
+	rxq->bd = dma_alloc_coherent(dev, sizeof(__le32) * RX_QUEUE_SIZE,
+				     &rxq->bd_dma, GFP_KERNEL);
+	if (!rxq->bd)
+		goto err_bd;
+	memset(rxq->bd, 0, sizeof(__le32) * RX_QUEUE_SIZE);
+
+	/*Allocate the driver's pointer to receive buffer status */
+	rxq->rb_stts = dma_alloc_coherent(dev, sizeof(*rxq->rb_stts),
+					  &rxq->rb_stts_dma, GFP_KERNEL);
+	if (!rxq->rb_stts)
+		goto err_rb_stts;
+	memset(rxq->rb_stts, 0, sizeof(*rxq->rb_stts));
+
+	return 0;
+
+err_rb_stts:
+	dma_free_coherent(dev, sizeof(__le32) * RX_QUEUE_SIZE,
+			rxq->bd, rxq->bd_dma);
+	memset(&rxq->bd_dma, 0, sizeof(rxq->bd_dma));
+	rxq->bd = NULL;
+err_bd:
+	return -ENOMEM;
+}
+
+static void iwl_trans_rxq_free_rx_bufs(struct iwl_trans *trans)
+{
+	struct iwl_trans_pcie *trans_pcie =
+		IWL_TRANS_GET_PCIE_TRANS(trans);
+	struct iwl_rx_queue *rxq = &trans_pcie->rxq;
+	int i;
+
+	/* Fill the rx_used queue with _all_ of the Rx buffers */
+	for (i = 0; i < RX_FREE_BUFFERS + RX_QUEUE_SIZE; i++) {
+		/* In the reset function, these buffers may have been allocated
+		 * to an SKB, so we need to unmap and free potential storage */
+		if (rxq->pool[i].page != NULL) {
+			dma_unmap_page(bus(trans)->dev, rxq->pool[i].page_dma,
+				PAGE_SIZE << hw_params(trans).rx_page_order,
+				DMA_FROM_DEVICE);
+			__free_pages(rxq->pool[i].page,
+				     hw_params(trans).rx_page_order);
+			rxq->pool[i].page = NULL;
+		}
+		list_add_tail(&rxq->pool[i].list, &rxq->rx_used);
+	}
+}
+
+static void iwl_trans_rx_hw_init(struct iwl_trans *trans,
+				 struct iwl_rx_queue *rxq)
+{
+	u32 rb_size;
+	const u32 rfdnlog = RX_QUEUE_SIZE_LOG; /* 256 RBDs */
+	u32 rb_timeout = RX_RB_TIMEOUT; /* FIXME: RX_RB_TIMEOUT for all devices? */
+
+	if (iwlagn_mod_params.amsdu_size_8K)
+		rb_size = FH_RCSR_RX_CONFIG_REG_VAL_RB_SIZE_8K;
+	else
+		rb_size = FH_RCSR_RX_CONFIG_REG_VAL_RB_SIZE_4K;
+
+	/* Stop Rx DMA */
+	iwl_write_direct32(bus(trans), FH_MEM_RCSR_CHNL0_CONFIG_REG, 0);
+
+	/* Reset driver's Rx queue write index */
+	iwl_write_direct32(bus(trans), FH_RSCSR_CHNL0_RBDCB_WPTR_REG, 0);
+
+	/* Tell device where to find RBD circular buffer in DRAM */
+	iwl_write_direct32(bus(trans), FH_RSCSR_CHNL0_RBDCB_BASE_REG,
+			   (u32)(rxq->bd_dma >> 8));
+
+	/* Tell device where in DRAM to update its Rx status */
+	iwl_write_direct32(bus(trans), FH_RSCSR_CHNL0_STTS_WPTR_REG,
+			   rxq->rb_stts_dma >> 4);
+
+	/* Enable Rx DMA
+	 * FH_RCSR_CHNL0_RX_IGNORE_RXF_EMPTY is set because of HW bug in
+	 *      the credit mechanism in 5000 HW RX FIFO
+	 * Direct rx interrupts to hosts
+	 * Rx buffer size 4 or 8k
+	 * RB timeout 0x10
+	 * 256 RBDs
+	 */
+	iwl_write_direct32(bus(trans), FH_MEM_RCSR_CHNL0_CONFIG_REG,
+			   FH_RCSR_RX_CONFIG_CHNL_EN_ENABLE_VAL |
+			   FH_RCSR_CHNL0_RX_IGNORE_RXF_EMPTY |
+			   FH_RCSR_CHNL0_RX_CONFIG_IRQ_DEST_INT_HOST_VAL |
+			   FH_RCSR_CHNL0_RX_CONFIG_SINGLE_FRAME_MSK |
+			   rb_size|
+			   (rb_timeout << FH_RCSR_RX_CONFIG_REG_IRQ_RBTH_POS)|
+			   (rfdnlog << FH_RCSR_RX_CONFIG_RBDCB_SIZE_POS));
+
+	/* Set interrupt coalescing timer to default (2048 usecs) */
+	iwl_write8(bus(trans), CSR_INT_COALESCING, IWL_HOST_INT_TIMEOUT_DEF);
+}
+
+static int iwl_rx_init(struct iwl_trans *trans)
+{
+	struct iwl_trans_pcie *trans_pcie =
+		IWL_TRANS_GET_PCIE_TRANS(trans);
+	struct iwl_rx_queue *rxq = &trans_pcie->rxq;
+
+	int i, err;
+	unsigned long flags;
+
+	if (!rxq->bd) {
+		err = iwl_trans_rx_alloc(trans);
+		if (err)
+			return err;
+	}
+
+	spin_lock_irqsave(&rxq->lock, flags);
+	INIT_LIST_HEAD(&rxq->rx_free);
+	INIT_LIST_HEAD(&rxq->rx_used);
+
+	iwl_trans_rxq_free_rx_bufs(trans);
+
+	for (i = 0; i < RX_QUEUE_SIZE; i++)
+		rxq->queue[i] = NULL;
+
+	/* Set us so that we have processed and used all buffers, but have
+	 * not restocked the Rx queue with fresh buffers */
+	rxq->read = rxq->write = 0;
+	rxq->write_actual = 0;
+	rxq->free_count = 0;
+	spin_unlock_irqrestore(&rxq->lock, flags);
+
+	iwlagn_rx_replenish(trans);
+
+	iwl_trans_rx_hw_init(trans, rxq);
+
+	spin_lock_irqsave(&trans->shrd->lock, flags);
+	rxq->need_update = 1;
+	iwl_rx_queue_update_write_ptr(trans, rxq);
+	spin_unlock_irqrestore(&trans->shrd->lock, flags);
+
+	return 0;
+}
+
+static void iwl_trans_pcie_rx_free(struct iwl_trans *trans)
+{
+	struct iwl_trans_pcie *trans_pcie =
+		IWL_TRANS_GET_PCIE_TRANS(trans);
+	struct iwl_rx_queue *rxq = &trans_pcie->rxq;
+
+	unsigned long flags;
+
+	/*if rxq->bd is NULL, it means that nothing has been allocated,
+	 * exit now */
+	if (!rxq->bd) {
+		IWL_DEBUG_INFO(trans, "Free NULL rx context\n");
+		return;
+	}
+
+	spin_lock_irqsave(&rxq->lock, flags);
+	iwl_trans_rxq_free_rx_bufs(trans);
+	spin_unlock_irqrestore(&rxq->lock, flags);
+
+	dma_free_coherent(bus(trans)->dev, sizeof(__le32) * RX_QUEUE_SIZE,
+			  rxq->bd, rxq->bd_dma);
+	memset(&rxq->bd_dma, 0, sizeof(rxq->bd_dma));
+	rxq->bd = NULL;
+
+	if (rxq->rb_stts)
+		dma_free_coherent(bus(trans)->dev,
+				  sizeof(struct iwl_rb_status),
+				  rxq->rb_stts, rxq->rb_stts_dma);
+	else
+		IWL_DEBUG_INFO(trans, "Free rxq->rb_stts which is NULL\n");
+	memset(&rxq->rb_stts_dma, 0, sizeof(rxq->rb_stts_dma));
+	rxq->rb_stts = NULL;
+}
+
+static int iwl_trans_rx_stop(struct iwl_trans *trans)
+{
+
+	/* stop Rx DMA */
+	iwl_write_direct32(bus(trans), FH_MEM_RCSR_CHNL0_CONFIG_REG, 0);
+	return iwl_poll_direct_bit(bus(trans), FH_MEM_RSSR_RX_STATUS_REG,
+			    FH_RSSR_CHNL0_RX_STATUS_CHNL_IDLE, 1000);
+}
+
+static inline int iwlagn_alloc_dma_ptr(struct iwl_trans *trans,
+				    struct iwl_dma_ptr *ptr, size_t size)
+{
+	if (WARN_ON(ptr->addr))
+		return -EINVAL;
+
+	ptr->addr = dma_alloc_coherent(bus(trans)->dev, size,
+				       &ptr->dma, GFP_KERNEL);
+	if (!ptr->addr)
+		return -ENOMEM;
+	ptr->size = size;
+	return 0;
+}
+
+static inline void iwlagn_free_dma_ptr(struct iwl_trans *trans,
+				    struct iwl_dma_ptr *ptr)
+{
+	if (unlikely(!ptr->addr))
+		return;
+
+	dma_free_coherent(bus(trans)->dev, ptr->size, ptr->addr, ptr->dma);
+	memset(ptr, 0, sizeof(*ptr));
+}
+
+static int iwl_trans_txq_alloc(struct iwl_trans *trans,
+				struct iwl_tx_queue *txq, int slots_num,
+				u32 txq_id)
+{
+	size_t tfd_sz = sizeof(struct iwl_tfd) * TFD_QUEUE_SIZE_MAX;
+	int i;
+
+	if (WARN_ON(txq->meta || txq->cmd || txq->skbs || txq->tfds))
+		return -EINVAL;
+
+	txq->q.n_window = slots_num;
+
+	txq->meta = kzalloc(sizeof(txq->meta[0]) * slots_num, GFP_KERNEL);
+	txq->cmd = kzalloc(sizeof(txq->cmd[0]) * slots_num, GFP_KERNEL);
+
+	if (!txq->meta || !txq->cmd)
+		goto error;
+
+	if (txq_id == trans->shrd->cmd_queue)
+		for (i = 0; i < slots_num; i++) {
+			txq->cmd[i] = kmalloc(sizeof(struct iwl_device_cmd),
+						GFP_KERNEL);
+			if (!txq->cmd[i])
+				goto error;
+		}
+
+	/* Alloc driver data array and TFD circular buffer */
+	/* Driver private data, only for Tx (not command) queues,
+	 * not shared with device. */
+	if (txq_id != trans->shrd->cmd_queue) {
+		txq->skbs = kzalloc(sizeof(txq->skbs[0]) *
+				   TFD_QUEUE_SIZE_MAX, GFP_KERNEL);
+		if (!txq->skbs) {
+			IWL_ERR(trans, "kmalloc for auxiliary BD "
+				  "structures failed\n");
+			goto error;
+		}
+	} else {
+		txq->skbs = NULL;
+	}
+
+	/* Circular buffer of transmit frame descriptors (TFDs),
+	 * shared with device */
+	txq->tfds = dma_alloc_coherent(bus(trans)->dev, tfd_sz,
+				       &txq->q.dma_addr, GFP_KERNEL);
+	if (!txq->tfds) {
+		IWL_ERR(trans, "dma_alloc_coherent(%zd) failed\n", tfd_sz);
+		goto error;
+	}
+	txq->q.id = txq_id;
+
+	return 0;
+error:
+	kfree(txq->skbs);
+	txq->skbs = NULL;
+	/* since txq->cmd has been zeroed,
+	 * all non allocated cmd[i] will be NULL */
+	if (txq->cmd && txq_id == trans->shrd->cmd_queue)
+		for (i = 0; i < slots_num; i++)
+			kfree(txq->cmd[i]);
+	kfree(txq->meta);
+	kfree(txq->cmd);
+	txq->meta = NULL;
+	txq->cmd = NULL;
+
+	return -ENOMEM;
+
+}
+
+static int iwl_trans_txq_init(struct iwl_trans *trans, struct iwl_tx_queue *txq,
+		      int slots_num, u32 txq_id)
+{
+	int ret;
+
+	txq->need_update = 0;
+	memset(txq->meta, 0, sizeof(txq->meta[0]) * slots_num);
+
+	/*
+	 * For the default queues 0-3, set up the swq_id
+	 * already -- all others need to get one later
+	 * (if they need one at all).
+	 */
+	if (txq_id < 4)
+		iwl_set_swq_id(txq, txq_id, txq_id);
+
+	/* TFD_QUEUE_SIZE_MAX must be power-of-two size, otherwise
+	 * iwl_queue_inc_wrap and iwl_queue_dec_wrap are broken. */
+	BUILD_BUG_ON(TFD_QUEUE_SIZE_MAX & (TFD_QUEUE_SIZE_MAX - 1));
+
+	/* Initialize queue's high/low-water marks, and head/tail indexes */
+	ret = iwl_queue_init(&txq->q, TFD_QUEUE_SIZE_MAX, slots_num,
+			txq_id);
+	if (ret)
+		return ret;
+
+	/*
+	 * Tell nic where to find circular buffer of Tx Frame Descriptors for
+	 * given Tx queue, and enable the DMA channel used for that queue.
+	 * Circular buffer (TFD queue in DRAM) physical base address */
+	iwl_write_direct32(bus(trans), FH_MEM_CBBC_QUEUE(txq_id),
+			     txq->q.dma_addr >> 8);
+
+	return 0;
+}
+
+/**
+ * iwl_tx_queue_unmap -  Unmap any remaining DMA mappings and free skb's
+ */
+static void iwl_tx_queue_unmap(struct iwl_trans *trans, int txq_id)
+{
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+	struct iwl_tx_queue *txq = &trans_pcie->txq[txq_id];
+	struct iwl_queue *q = &txq->q;
+	enum dma_data_direction dma_dir;
+
+	if (!q->n_bd)
+		return;
+
+	/* In the command queue, all the TBs are mapped as BIDI
+	 * so unmap them as such.
+	 */
+	if (txq_id == trans->shrd->cmd_queue)
+		dma_dir = DMA_BIDIRECTIONAL;
+	else
+		dma_dir = DMA_TO_DEVICE;
+
+	while (q->write_ptr != q->read_ptr) {
+		/* The read_ptr needs to bound by q->n_window */
+		iwlagn_txq_free_tfd(trans, txq, get_cmd_index(q, q->read_ptr),
+				    dma_dir);
+		q->read_ptr = iwl_queue_inc_wrap(q->read_ptr, q->n_bd);
+	}
+}
+
+/**
+ * iwl_tx_queue_free - Deallocate DMA queue.
+ * @txq: Transmit queue to deallocate.
+ *
+ * Empty queue by removing and destroying all BD's.
+ * Free all buffers.
+ * 0-fill, but do not free "txq" descriptor structure.
+ */
+static void iwl_tx_queue_free(struct iwl_trans *trans, int txq_id)
+{
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+	struct iwl_tx_queue *txq = &trans_pcie->txq[txq_id];
+	struct device *dev = bus(trans)->dev;
+	int i;
+	if (WARN_ON(!txq))
+		return;
+
+	iwl_tx_queue_unmap(trans, txq_id);
+
+	/* De-alloc array of command/tx buffers */
+
+	if (txq_id == trans->shrd->cmd_queue)
+		for (i = 0; i < txq->q.n_window; i++)
+			kfree(txq->cmd[i]);
+
+	/* De-alloc circular buffer of TFDs */
+	if (txq->q.n_bd) {
+		dma_free_coherent(dev, sizeof(struct iwl_tfd) *
+				  txq->q.n_bd, txq->tfds, txq->q.dma_addr);
+		memset(&txq->q.dma_addr, 0, sizeof(txq->q.dma_addr));
+	}
+
+	/* De-alloc array of per-TFD driver data */
+	kfree(txq->skbs);
+	txq->skbs = NULL;
+
+	/* deallocate arrays */
+	kfree(txq->cmd);
+	kfree(txq->meta);
+	txq->cmd = NULL;
+	txq->meta = NULL;
+
+	/* 0-fill queue descriptor structure */
+	memset(txq, 0, sizeof(*txq));
+}
+
+/**
+ * iwl_trans_tx_free - Free TXQ Context
+ *
+ * Destroy all TX DMA queues and structures
+ */
+static void iwl_trans_pcie_tx_free(struct iwl_trans *trans)
+{
+	int txq_id;
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+
+	/* Tx queues */
+	if (trans_pcie->txq) {
+		for (txq_id = 0;
+		     txq_id < hw_params(trans).max_txq_num; txq_id++)
+			iwl_tx_queue_free(trans, txq_id);
+	}
+
+	kfree(trans_pcie->txq);
+	trans_pcie->txq = NULL;
+
+	iwlagn_free_dma_ptr(trans, &trans_pcie->kw);
+
+	iwlagn_free_dma_ptr(trans, &trans_pcie->scd_bc_tbls);
+}
+
+/**
+ * iwl_trans_tx_alloc - allocate TX context
+ * Allocate all Tx DMA structures and initialize them
+ *
+ * @param priv
+ * @return error code
+ */
+static int iwl_trans_tx_alloc(struct iwl_trans *trans)
+{
+	int ret;
+	int txq_id, slots_num;
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+
+	u16 scd_bc_tbls_size = hw_params(trans).max_txq_num *
+			sizeof(struct iwlagn_scd_bc_tbl);
+
+	/*It is not allowed to alloc twice, so warn when this happens.
+	 * We cannot rely on the previous allocation, so free and fail */
+	if (WARN_ON(trans_pcie->txq)) {
+		ret = -EINVAL;
+		goto error;
+	}
+
+	ret = iwlagn_alloc_dma_ptr(trans, &trans_pcie->scd_bc_tbls,
+				   scd_bc_tbls_size);
+	if (ret) {
+		IWL_ERR(trans, "Scheduler BC Table allocation failed\n");
+		goto error;
+	}
+
+	/* Alloc keep-warm buffer */
+	ret = iwlagn_alloc_dma_ptr(trans, &trans_pcie->kw, IWL_KW_SIZE);
+	if (ret) {
+		IWL_ERR(trans, "Keep Warm allocation failed\n");
+		goto error;
+	}
+
+	trans_pcie->txq = kzalloc(sizeof(struct iwl_tx_queue) *
+			hw_params(trans).max_txq_num, GFP_KERNEL);
+	if (!trans_pcie->txq) {
+		IWL_ERR(trans, "Not enough memory for txq\n");
+		ret = ENOMEM;
+		goto error;
+	}
+
+	/* Alloc and init all Tx queues, including the command queue (#4/#9) */
+	for (txq_id = 0; txq_id < hw_params(trans).max_txq_num; txq_id++) {
+		slots_num = (txq_id == trans->shrd->cmd_queue) ?
+					TFD_CMD_SLOTS : TFD_TX_CMD_SLOTS;
+		ret = iwl_trans_txq_alloc(trans, &trans_pcie->txq[txq_id],
+					  slots_num, txq_id);
+		if (ret) {
+			IWL_ERR(trans, "Tx %d queue alloc failed\n", txq_id);
+			goto error;
+		}
+	}
+
+	return 0;
+
+error:
+	iwl_trans_pcie_tx_free(trans);
+
+	return ret;
+}
+static int iwl_tx_init(struct iwl_trans *trans)
+{
+	int ret;
+	int txq_id, slots_num;
+	unsigned long flags;
+	bool alloc = false;
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+
+	if (!trans_pcie->txq) {
+		ret = iwl_trans_tx_alloc(trans);
+		if (ret)
+			goto error;
+		alloc = true;
+	}
+
+	spin_lock_irqsave(&trans->shrd->lock, flags);
+
+	/* Turn off all Tx DMA fifos */
+	iwl_write_prph(bus(trans), SCD_TXFACT, 0);
+
+	/* Tell NIC where to find the "keep warm" buffer */
+	iwl_write_direct32(bus(trans), FH_KW_MEM_ADDR_REG,
+			   trans_pcie->kw.dma >> 4);
+
+	spin_unlock_irqrestore(&trans->shrd->lock, flags);
+
+	/* Alloc and init all Tx queues, including the command queue (#4/#9) */
+	for (txq_id = 0; txq_id < hw_params(trans).max_txq_num; txq_id++) {
+		slots_num = (txq_id == trans->shrd->cmd_queue) ?
+					TFD_CMD_SLOTS : TFD_TX_CMD_SLOTS;
+		ret = iwl_trans_txq_init(trans, &trans_pcie->txq[txq_id],
+					 slots_num, txq_id);
+		if (ret) {
+			IWL_ERR(trans, "Tx %d queue init failed\n", txq_id);
+			goto error;
+		}
+	}
+
+	return 0;
+error:
+	/*Upon error, free only if we allocated something */
+	if (alloc)
+		iwl_trans_pcie_tx_free(trans);
+	return ret;
+}
+
+static void iwl_set_pwr_vmain(struct iwl_trans *trans)
+{
+/*
+ * (for documentation purposes)
+ * to set power to V_AUX, do:
+
+		if (pci_pme_capable(priv->pci_dev, PCI_D3cold))
+			iwl_set_bits_mask_prph(bus(trans), APMG_PS_CTRL_REG,
+					       APMG_PS_CTRL_VAL_PWR_SRC_VAUX,
+					       ~APMG_PS_CTRL_MSK_PWR_SRC);
+ */
+
+	iwl_set_bits_mask_prph(bus(trans), APMG_PS_CTRL_REG,
+			       APMG_PS_CTRL_VAL_PWR_SRC_VMAIN,
+			       ~APMG_PS_CTRL_MSK_PWR_SRC);
+}
+
+static int iwl_nic_init(struct iwl_trans *trans)
+{
+	unsigned long flags;
+
+	/* nic_init */
+	spin_lock_irqsave(&trans->shrd->lock, flags);
+	iwl_apm_init(priv(trans));
+
+	/* Set interrupt coalescing calibration timer to default (512 usecs) */
+	iwl_write8(bus(trans), CSR_INT_COALESCING,
+		IWL_HOST_INT_CALIB_TIMEOUT_DEF);
+
+	spin_unlock_irqrestore(&trans->shrd->lock, flags);
+
+	iwl_set_pwr_vmain(trans);
+
+	iwl_nic_config(priv(trans));
+
+	/* Allocate the RX queue, or reset if it is already allocated */
+	iwl_rx_init(trans);
+
+	/* Allocate or reset and init all Tx and Command queues */
+	if (iwl_tx_init(trans))
+		return -ENOMEM;
+
+	if (hw_params(trans).shadow_reg_enable) {
+		/* enable shadow regs in HW */
+		iwl_set_bit(bus(trans), CSR_MAC_SHADOW_REG_CTRL,
+			0x800FFFFF);
+	}
+
+	set_bit(STATUS_INIT, &trans->shrd->status);
+
+	return 0;
+}
+
+#define HW_READY_TIMEOUT (50)
+
+/* Note: returns poll_bit return value, which is >= 0 if success */
+static int iwl_set_hw_ready(struct iwl_trans *trans)
+{
+	int ret;
+
+	iwl_set_bit(bus(trans), CSR_HW_IF_CONFIG_REG,
+		CSR_HW_IF_CONFIG_REG_BIT_NIC_READY);
+
+	/* See if we got it */
+	ret = iwl_poll_bit(bus(trans), CSR_HW_IF_CONFIG_REG,
+				CSR_HW_IF_CONFIG_REG_BIT_NIC_READY,
+				CSR_HW_IF_CONFIG_REG_BIT_NIC_READY,
+				HW_READY_TIMEOUT);
+
+	IWL_DEBUG_INFO(trans, "hardware%s ready\n", ret < 0 ? " not" : "");
+	return ret;
+}
+
+/* Note: returns standard 0/-ERROR code */
+static int iwl_trans_pcie_prepare_card_hw(struct iwl_trans *trans)
+{
+	int ret;
+
+	IWL_DEBUG_INFO(trans, "iwl_trans_prepare_card_hw enter\n");
+
+	ret = iwl_set_hw_ready(trans);
+	if (ret >= 0)
+		return 0;
+
+	/* If HW is not ready, prepare the conditions to check again */
+	iwl_set_bit(bus(trans), CSR_HW_IF_CONFIG_REG,
+			CSR_HW_IF_CONFIG_REG_PREPARE);
+
+	ret = iwl_poll_bit(bus(trans), CSR_HW_IF_CONFIG_REG,
+			~CSR_HW_IF_CONFIG_REG_BIT_NIC_PREPARE_DONE,
+			CSR_HW_IF_CONFIG_REG_BIT_NIC_PREPARE_DONE, 150000);
+
+	if (ret < 0)
+		return ret;
+
+	/* HW should be ready by now, check again. */
+	ret = iwl_set_hw_ready(trans);
+	if (ret >= 0)
+		return 0;
+	return ret;
+}
+
+#define IWL_AC_UNSET -1
+
+struct queue_to_fifo_ac {
+	s8 fifo, ac;
+};
+
+static const struct queue_to_fifo_ac iwlagn_default_queue_to_tx_fifo[] = {
+	{ IWL_TX_FIFO_VO, IEEE80211_AC_VO, },
+	{ IWL_TX_FIFO_VI, IEEE80211_AC_VI, },
+	{ IWL_TX_FIFO_BE, IEEE80211_AC_BE, },
+	{ IWL_TX_FIFO_BK, IEEE80211_AC_BK, },
+	{ IWLAGN_CMD_FIFO_NUM, IWL_AC_UNSET, },
+	{ IWL_TX_FIFO_UNUSED, IWL_AC_UNSET, },
+	{ IWL_TX_FIFO_UNUSED, IWL_AC_UNSET, },
+	{ IWL_TX_FIFO_UNUSED, IWL_AC_UNSET, },
+	{ IWL_TX_FIFO_UNUSED, IWL_AC_UNSET, },
+	{ IWL_TX_FIFO_UNUSED, IWL_AC_UNSET, },
+	{ IWL_TX_FIFO_UNUSED, IWL_AC_UNSET, },
+};
+
+static const struct queue_to_fifo_ac iwlagn_ipan_queue_to_tx_fifo[] = {
+	{ IWL_TX_FIFO_VO, IEEE80211_AC_VO, },
+	{ IWL_TX_FIFO_VI, IEEE80211_AC_VI, },
+	{ IWL_TX_FIFO_BE, IEEE80211_AC_BE, },
+	{ IWL_TX_FIFO_BK, IEEE80211_AC_BK, },
+	{ IWL_TX_FIFO_BK_IPAN, IEEE80211_AC_BK, },
+	{ IWL_TX_FIFO_BE_IPAN, IEEE80211_AC_BE, },
+	{ IWL_TX_FIFO_VI_IPAN, IEEE80211_AC_VI, },
+	{ IWL_TX_FIFO_VO_IPAN, IEEE80211_AC_VO, },
+	{ IWL_TX_FIFO_BE_IPAN, 2, },
+	{ IWLAGN_CMD_FIFO_NUM, IWL_AC_UNSET, },
+	{ IWL_TX_FIFO_AUX, IWL_AC_UNSET, },
+};
+
+static const u8 iwlagn_bss_ac_to_fifo[] = {
+	IWL_TX_FIFO_VO,
+	IWL_TX_FIFO_VI,
+	IWL_TX_FIFO_BE,
+	IWL_TX_FIFO_BK,
+};
+static const u8 iwlagn_bss_ac_to_queue[] = {
+	0, 1, 2, 3,
+};
+static const u8 iwlagn_pan_ac_to_fifo[] = {
+	IWL_TX_FIFO_VO_IPAN,
+	IWL_TX_FIFO_VI_IPAN,
+	IWL_TX_FIFO_BE_IPAN,
+	IWL_TX_FIFO_BK_IPAN,
+};
+static const u8 iwlagn_pan_ac_to_queue[] = {
+	7, 6, 5, 4,
+};
+
+static int iwl_trans_pcie_start_device(struct iwl_trans *trans)
+{
+	int ret;
+	struct iwl_trans_pcie *trans_pcie =
+		IWL_TRANS_GET_PCIE_TRANS(trans);
+
+	trans->shrd->ucode_owner = IWL_OWNERSHIP_DRIVER;
+	trans_pcie->ac_to_queue[IWL_RXON_CTX_BSS] = iwlagn_bss_ac_to_queue;
+	trans_pcie->ac_to_queue[IWL_RXON_CTX_PAN] = iwlagn_pan_ac_to_queue;
+
+	trans_pcie->ac_to_fifo[IWL_RXON_CTX_BSS] = iwlagn_bss_ac_to_fifo;
+	trans_pcie->ac_to_fifo[IWL_RXON_CTX_PAN] = iwlagn_pan_ac_to_fifo;
+
+	trans_pcie->mcast_queue[IWL_RXON_CTX_BSS] = 0;
+	trans_pcie->mcast_queue[IWL_RXON_CTX_PAN] = IWL_IPAN_MCAST_QUEUE;
+
+	if ((hw_params(trans).sku & EEPROM_SKU_CAP_AMT_ENABLE) &&
+	     iwl_trans_pcie_prepare_card_hw(trans)) {
+		IWL_WARN(trans, "Exit HW not ready\n");
+		return -EIO;
+	}
+
+	/* If platform's RF_KILL switch is NOT set to KILL */
+	if (iwl_read32(bus(trans), CSR_GP_CNTRL) &
+			CSR_GP_CNTRL_REG_FLAG_HW_RF_KILL_SW)
+		clear_bit(STATUS_RF_KILL_HW, &trans->shrd->status);
+	else
+		set_bit(STATUS_RF_KILL_HW, &trans->shrd->status);
+
+	if (iwl_is_rfkill(trans->shrd)) {
+		iwl_set_hw_rfkill_state(priv(trans), true);
+		iwl_enable_interrupts(trans);
+		return -ERFKILL;
+	}
+
+	iwl_write32(bus(trans), CSR_INT, 0xFFFFFFFF);
+
+	ret = iwl_nic_init(trans);
+	if (ret) {
+		IWL_ERR(trans, "Unable to init nic\n");
+		return ret;
+	}
+
+	/* make sure rfkill handshake bits are cleared */
+	iwl_write32(bus(trans), CSR_UCODE_DRV_GP1_CLR, CSR_UCODE_SW_BIT_RFKILL);
+	iwl_write32(bus(trans), CSR_UCODE_DRV_GP1_CLR,
+		    CSR_UCODE_DRV_GP1_BIT_CMD_BLOCKED);
+
+	/* clear (again), then enable host interrupts */
+	iwl_write32(bus(trans), CSR_INT, 0xFFFFFFFF);
+	iwl_enable_interrupts(trans);
+
+	/* really make sure rfkill handshake bits are cleared */
+	iwl_write32(bus(trans), CSR_UCODE_DRV_GP1_CLR, CSR_UCODE_SW_BIT_RFKILL);
+	iwl_write32(bus(trans), CSR_UCODE_DRV_GP1_CLR, CSR_UCODE_SW_BIT_RFKILL);
+
+	return 0;
+}
+
+/*
+ * Activate/Deactivate Tx DMA/FIFO channels according tx fifos mask
+ * must be called under priv->shrd->lock and mac access
+ */
+static void iwl_trans_txq_set_sched(struct iwl_trans *trans, u32 mask)
+{
+	iwl_write_prph(bus(trans), SCD_TXFACT, mask);
+}
+
+static void iwl_trans_pcie_tx_start(struct iwl_trans *trans)
+{
+	const struct queue_to_fifo_ac *queue_to_fifo;
+	struct iwl_trans_pcie *trans_pcie =
+		IWL_TRANS_GET_PCIE_TRANS(trans);
+	u32 a;
+	unsigned long flags;
+	int i, chan;
+	u32 reg_val;
+
+	spin_lock_irqsave(&trans->shrd->lock, flags);
+
+	trans_pcie->scd_base_addr =
+		iwl_read_prph(bus(trans), SCD_SRAM_BASE_ADDR);
+	a = trans_pcie->scd_base_addr + SCD_CONTEXT_MEM_LOWER_BOUND;
+	/* reset conext data memory */
+	for (; a < trans_pcie->scd_base_addr + SCD_CONTEXT_MEM_UPPER_BOUND;
+		a += 4)
+		iwl_write_targ_mem(bus(trans), a, 0);
+	/* reset tx status memory */
+	for (; a < trans_pcie->scd_base_addr + SCD_TX_STTS_MEM_UPPER_BOUND;
+		a += 4)
+		iwl_write_targ_mem(bus(trans), a, 0);
+	for (; a < trans_pcie->scd_base_addr +
+	       SCD_TRANS_TBL_OFFSET_QUEUE(hw_params(trans).max_txq_num);
+	       a += 4)
+		iwl_write_targ_mem(bus(trans), a, 0);
+
+	iwl_write_prph(bus(trans), SCD_DRAM_BASE_ADDR,
+		       trans_pcie->scd_bc_tbls.dma >> 10);
+
+	/* Enable DMA channel */
+	for (chan = 0; chan < FH_TCSR_CHNL_NUM ; chan++)
+		iwl_write_direct32(bus(trans), FH_TCSR_CHNL_TX_CONFIG_REG(chan),
+				FH_TCSR_TX_CONFIG_REG_VAL_DMA_CHNL_ENABLE |
+				FH_TCSR_TX_CONFIG_REG_VAL_DMA_CREDIT_ENABLE);
+
+	/* Update FH chicken bits */
+	reg_val = iwl_read_direct32(bus(trans), FH_TX_CHICKEN_BITS_REG);
+	iwl_write_direct32(bus(trans), FH_TX_CHICKEN_BITS_REG,
+			   reg_val | FH_TX_CHICKEN_BITS_SCD_AUTO_RETRY_EN);
+
+	iwl_write_prph(bus(trans), SCD_QUEUECHAIN_SEL,
+		SCD_QUEUECHAIN_SEL_ALL(trans));
+	iwl_write_prph(bus(trans), SCD_AGGR_SEL, 0);
+
+	/* initiate the queues */
+	for (i = 0; i < hw_params(trans).max_txq_num; i++) {
+		iwl_write_prph(bus(trans), SCD_QUEUE_RDPTR(i), 0);
+		iwl_write_direct32(bus(trans), HBUS_TARG_WRPTR, 0 | (i << 8));
+		iwl_write_targ_mem(bus(trans), trans_pcie->scd_base_addr +
+				SCD_CONTEXT_QUEUE_OFFSET(i), 0);
+		iwl_write_targ_mem(bus(trans), trans_pcie->scd_base_addr +
+				SCD_CONTEXT_QUEUE_OFFSET(i) +
+				sizeof(u32),
+				((SCD_WIN_SIZE <<
+				SCD_QUEUE_CTX_REG2_WIN_SIZE_POS) &
+				SCD_QUEUE_CTX_REG2_WIN_SIZE_MSK) |
+				((SCD_FRAME_LIMIT <<
+				SCD_QUEUE_CTX_REG2_FRAME_LIMIT_POS) &
+				SCD_QUEUE_CTX_REG2_FRAME_LIMIT_MSK));
+	}
+
+	iwl_write_prph(bus(trans), SCD_INTERRUPT_MASK,
+			IWL_MASK(0, hw_params(trans).max_txq_num));
+
+	/* Activate all Tx DMA/FIFO channels */
+	iwl_trans_txq_set_sched(trans, IWL_MASK(0, 7));
+
+	/* map queues to FIFOs */
+	if (trans->shrd->valid_contexts != BIT(IWL_RXON_CTX_BSS))
+		queue_to_fifo = iwlagn_ipan_queue_to_tx_fifo;
+	else
+		queue_to_fifo = iwlagn_default_queue_to_tx_fifo;
+
+	iwl_trans_set_wr_ptrs(trans, trans->shrd->cmd_queue, 0);
+
+	/* make sure all queue are not stopped */
+	memset(&trans_pcie->queue_stopped[0], 0,
+		sizeof(trans_pcie->queue_stopped));
+	for (i = 0; i < 4; i++)
+		atomic_set(&trans_pcie->queue_stop_count[i], 0);
+
+	/* reset to 0 to enable all the queue first */
+	trans_pcie->txq_ctx_active_msk = 0;
+
+	BUILD_BUG_ON(ARRAY_SIZE(iwlagn_default_queue_to_tx_fifo) <
+						IWLAGN_FIRST_AMPDU_QUEUE);
+	BUILD_BUG_ON(ARRAY_SIZE(iwlagn_ipan_queue_to_tx_fifo) <
+						IWLAGN_FIRST_AMPDU_QUEUE);
+
+	for (i = 0; i < IWLAGN_FIRST_AMPDU_QUEUE; i++) {
+		int fifo = queue_to_fifo[i].fifo;
+		int ac = queue_to_fifo[i].ac;
+
+		iwl_txq_ctx_activate(trans_pcie, i);
+
+		if (fifo == IWL_TX_FIFO_UNUSED)
+			continue;
+
+		if (ac != IWL_AC_UNSET)
+			iwl_set_swq_id(&trans_pcie->txq[i], ac, i);
+		iwl_trans_tx_queue_set_status(trans, &trans_pcie->txq[i],
+					      fifo, 0);
+	}
+
+	spin_unlock_irqrestore(&trans->shrd->lock, flags);
+
+	/* Enable L1-Active */
+	iwl_clear_bits_prph(bus(trans), APMG_PCIDEV_STT_REG,
+			  APMG_PCIDEV_STT_VAL_L1_ACT_DIS);
+}
+
+/**
+ * iwlagn_txq_ctx_stop - Stop all Tx DMA channels
+ */
+static int iwl_trans_tx_stop(struct iwl_trans *trans)
+{
+	int ch, txq_id;
+	unsigned long flags;
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+
+	/* Turn off all Tx DMA fifos */
+	spin_lock_irqsave(&trans->shrd->lock, flags);
+
+	iwl_trans_txq_set_sched(trans, 0);
+
+	/* Stop each Tx DMA channel, and wait for it to be idle */
+	for (ch = 0; ch < FH_TCSR_CHNL_NUM; ch++) {
+		iwl_write_direct32(bus(trans),
+				   FH_TCSR_CHNL_TX_CONFIG_REG(ch), 0x0);
+		if (iwl_poll_direct_bit(bus(trans), FH_TSSR_TX_STATUS_REG,
+				    FH_TSSR_TX_STATUS_REG_MSK_CHNL_IDLE(ch),
+				    1000))
+			IWL_ERR(trans, "Failing on timeout while stopping"
+			    " DMA channel %d [0x%08x]", ch,
+			    iwl_read_direct32(bus(trans),
+					      FH_TSSR_TX_STATUS_REG));
+	}
+	spin_unlock_irqrestore(&trans->shrd->lock, flags);
+
+	if (!trans_pcie->txq) {
+		IWL_WARN(trans, "Stopping tx queues that aren't allocated...");
+		return 0;
+	}
+
+	/* Unmap DMA from host system and free skb's */
+	for (txq_id = 0; txq_id < hw_params(trans).max_txq_num; txq_id++)
+		iwl_tx_queue_unmap(trans, txq_id);
+
+	return 0;
+}
+
+static void iwl_trans_pcie_disable_sync_irq(struct iwl_trans *trans)
+{
+	unsigned long flags;
+	struct iwl_trans_pcie *trans_pcie =
+		IWL_TRANS_GET_PCIE_TRANS(trans);
+
+	spin_lock_irqsave(&trans->shrd->lock, flags);
+	iwl_disable_interrupts(trans);
+	spin_unlock_irqrestore(&trans->shrd->lock, flags);
+
+	/* wait to make sure we flush pending tasklet*/
+	synchronize_irq(bus(trans)->irq);
+	tasklet_kill(&trans_pcie->irq_tasklet);
+}
+
+static void iwl_trans_pcie_stop_device(struct iwl_trans *trans)
+{
+	/* stop and reset the on-board processor */
+	iwl_write32(bus(trans), CSR_RESET, CSR_RESET_REG_FLAG_NEVO_RESET);
+
+	/* tell the device to stop sending interrupts */
+	iwl_trans_pcie_disable_sync_irq(trans);
+
+	/* device going down, Stop using ICT table */
+	iwl_disable_ict(trans);
+
+	/*
+	 * If a HW restart happens during firmware loading,
+	 * then the firmware loading might call this function
+	 * and later it might be called again due to the
+	 * restart. So don't process again if the device is
+	 * already dead.
+	 */
+	if (test_bit(STATUS_DEVICE_ENABLED, &trans->shrd->status)) {
+		iwl_trans_tx_stop(trans);
+		iwl_trans_rx_stop(trans);
+
+		/* Power-down device's busmaster DMA clocks */
+		iwl_write_prph(bus(trans), APMG_CLK_DIS_REG,
+			       APMG_CLK_VAL_DMA_CLK_RQT);
+		udelay(5);
+	}
+
+	/* Make sure (redundant) we've released our request to stay awake */
+	iwl_clear_bit(bus(trans), CSR_GP_CNTRL,
+			CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
+
+	/* Stop the device, and put it in low power state */
+	iwl_apm_stop(priv(trans));
+}
+
+static int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
+		struct iwl_device_cmd *dev_cmd, enum iwl_rxon_context_id ctx,
+		u8 sta_id)
+{
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct iwl_tx_cmd *tx_cmd = &dev_cmd->cmd.tx;
+	struct iwl_cmd_meta *out_meta;
+	struct iwl_tx_queue *txq;
+	struct iwl_queue *q;
+
+	dma_addr_t phys_addr = 0;
+	dma_addr_t txcmd_phys;
+	dma_addr_t scratch_phys;
+	u16 len, firstlen, secondlen;
+	u16 seq_number = 0;
+	u8 wait_write_ptr = 0;
+	u8 txq_id;
+	u8 tid = 0;
+	bool is_agg = false;
+	__le16 fc = hdr->frame_control;
+	u8 hdr_len = ieee80211_hdrlen(fc);
+
+	/*
+	 * Send this frame after DTIM -- there's a special queue
+	 * reserved for this for contexts that support AP mode.
+	 */
+	if (info->flags & IEEE80211_TX_CTL_SEND_AFTER_DTIM) {
+		txq_id = trans_pcie->mcast_queue[ctx];
+
+		/*
+		 * The microcode will clear the more data
+		 * bit in the last frame it transmits.
+		 */
+		hdr->frame_control |=
+			cpu_to_le16(IEEE80211_FCTL_MOREDATA);
+	} else if (info->flags & IEEE80211_TX_CTL_TX_OFFCHAN)
+		txq_id = IWL_AUX_QUEUE;
+	else
+		txq_id =
+		    trans_pcie->ac_to_queue[ctx][skb_get_queue_mapping(skb)];
+
+	if (ieee80211_is_data_qos(fc)) {
+		u8 *qc = NULL;
+		struct iwl_tid_data *tid_data;
+		qc = ieee80211_get_qos_ctl(hdr);
+		tid = qc[0] & IEEE80211_QOS_CTL_TID_MASK;
+		tid_data = &trans->shrd->tid_data[sta_id][tid];
+
+		if (WARN_ON_ONCE(tid >= IWL_MAX_TID_COUNT))
+			return -1;
+
+		seq_number = tid_data->seq_number;
+		seq_number &= IEEE80211_SCTL_SEQ;
+		hdr->seq_ctrl = hdr->seq_ctrl &
+				cpu_to_le16(IEEE80211_SCTL_FRAG);
+		hdr->seq_ctrl |= cpu_to_le16(seq_number);
+		seq_number += 0x10;
+		/* aggregation is on for this <sta,tid> */
+		if (info->flags & IEEE80211_TX_CTL_AMPDU &&
+		    tid_data->agg.state == IWL_AGG_ON) {
+			txq_id = tid_data->agg.txq_id;
+			is_agg = true;
+		}
+	}
+
+	txq = &trans_pcie->txq[txq_id];
+	q = &txq->q;
+
+	/* Set up driver data for this TFD */
+	txq->skbs[q->write_ptr] = skb;
+	txq->cmd[q->write_ptr] = dev_cmd;
+
+	dev_cmd->hdr.cmd = REPLY_TX;
+	dev_cmd->hdr.sequence = cpu_to_le16((u16)(QUEUE_TO_SEQ(txq_id) |
+				INDEX_TO_SEQ(q->write_ptr)));
+
+	/* Set up first empty entry in queue's array of Tx/cmd buffers */
+	out_meta = &txq->meta[q->write_ptr];
+
+	/*
+	 * Use the first empty entry in this queue's command buffer array
+	 * to contain the Tx command and MAC header concatenated together
+	 * (payload data will be in another buffer).
+	 * Size of this varies, due to varying MAC header length.
+	 * If end is not dword aligned, we'll have 2 extra bytes at the end
+	 * of the MAC header (device reads on dword boundaries).
+	 * We'll tell device about this padding later.
+	 */
+	len = sizeof(struct iwl_tx_cmd) +
+		sizeof(struct iwl_cmd_header) + hdr_len;
+	firstlen = (len + 3) & ~3;
+
+	/* Tell NIC about any 2-byte padding after MAC header */
+	if (firstlen != len)
+		tx_cmd->tx_flags |= TX_CMD_FLG_MH_PAD_MSK;
+
+	/* Physical address of this Tx command's header (not MAC header!),
+	 * within command buffer array. */
+	txcmd_phys = dma_map_single(bus(trans)->dev,
+				    &dev_cmd->hdr, firstlen,
+				    DMA_BIDIRECTIONAL);
+	if (unlikely(dma_mapping_error(bus(trans)->dev, txcmd_phys)))
+		return -1;
+	dma_unmap_addr_set(out_meta, mapping, txcmd_phys);
+	dma_unmap_len_set(out_meta, len, firstlen);
+
+	if (!ieee80211_has_morefrags(fc)) {
+		txq->need_update = 1;
+	} else {
+		wait_write_ptr = 1;
+		txq->need_update = 0;
+	}
+
+	/* Set up TFD's 2nd entry to point directly to remainder of skb,
+	 * if any (802.11 null frames have no payload). */
+	secondlen = skb->len - hdr_len;
+	if (secondlen > 0) {
+		phys_addr = dma_map_single(bus(trans)->dev, skb->data + hdr_len,
+					   secondlen, DMA_TO_DEVICE);
+		if (unlikely(dma_mapping_error(bus(trans)->dev, phys_addr))) {
+			dma_unmap_single(bus(trans)->dev,
+					 dma_unmap_addr(out_meta, mapping),
+					 dma_unmap_len(out_meta, len),
+					 DMA_BIDIRECTIONAL);
+			return -1;
+		}
+	}
+
+	/* Attach buffers to TFD */
+	iwlagn_txq_attach_buf_to_tfd(trans, txq, txcmd_phys, firstlen, 1);
+	if (secondlen > 0)
+		iwlagn_txq_attach_buf_to_tfd(trans, txq, phys_addr,
+					     secondlen, 0);
+
+	scratch_phys = txcmd_phys + sizeof(struct iwl_cmd_header) +
+				offsetof(struct iwl_tx_cmd, scratch);
+
+	/* take back ownership of DMA buffer to enable update */
+	dma_sync_single_for_cpu(bus(trans)->dev, txcmd_phys, firstlen,
+			DMA_BIDIRECTIONAL);
+	tx_cmd->dram_lsb_ptr = cpu_to_le32(scratch_phys);
+	tx_cmd->dram_msb_ptr = iwl_get_dma_hi_addr(scratch_phys);
+
+	IWL_DEBUG_TX(trans, "sequence nr = 0X%x\n",
+		     le16_to_cpu(dev_cmd->hdr.sequence));
+	IWL_DEBUG_TX(trans, "tx_flags = 0X%x\n", le32_to_cpu(tx_cmd->tx_flags));
+	iwl_print_hex_dump(trans, IWL_DL_TX, (u8 *)tx_cmd, sizeof(*tx_cmd));
+	iwl_print_hex_dump(trans, IWL_DL_TX, (u8 *)tx_cmd->hdr, hdr_len);
+
+	/* Set up entry for this TFD in Tx byte-count array */
+	if (is_agg)
+		iwl_trans_txq_update_byte_cnt_tbl(trans, txq,
+					       le16_to_cpu(tx_cmd->len));
+
+	dma_sync_single_for_device(bus(trans)->dev, txcmd_phys, firstlen,
+			DMA_BIDIRECTIONAL);
+
+	trace_iwlwifi_dev_tx(priv(trans),
+			     &((struct iwl_tfd *)txq->tfds)[txq->q.write_ptr],
+			     sizeof(struct iwl_tfd),
+			     &dev_cmd->hdr, firstlen,
+			     skb->data + hdr_len, secondlen);
+
+	/* Tell device the write index *just past* this latest filled TFD */
+	q->write_ptr = iwl_queue_inc_wrap(q->write_ptr, q->n_bd);
+	iwl_txq_update_write_ptr(trans, txq);
+
+	if (ieee80211_is_data_qos(fc)) {
+		trans->shrd->tid_data[sta_id][tid].tfds_in_queue++;
+		if (!ieee80211_has_morefrags(fc))
+			trans->shrd->tid_data[sta_id][tid].seq_number =
+				seq_number;
+	}
+
+	/*
+	 * At this point the frame is "transmitted" successfully
+	 * and we will get a TX status notification eventually,
+	 * regardless of the value of ret. "ret" only indicates
+	 * whether or not we should update the write pointer.
+	 */
+	if (iwl_queue_space(q) < q->high_mark) {
+		if (wait_write_ptr) {
+			txq->need_update = 1;
+			iwl_txq_update_write_ptr(trans, txq);
+		} else {
+			iwl_stop_queue(trans, txq);
+		}
+	}
+	return 0;
+}
+
+static void iwl_trans_pcie_kick_nic(struct iwl_trans *trans)
+{
+	/* Remove all resets to allow NIC to operate */
+	iwl_write32(bus(trans), CSR_RESET, 0);
+}
+
+static int iwl_trans_pcie_request_irq(struct iwl_trans *trans)
+{
+	struct iwl_trans_pcie *trans_pcie =
+		IWL_TRANS_GET_PCIE_TRANS(trans);
+	int err;
+
+	trans_pcie->inta_mask = CSR_INI_SET_MASK;
+
+	tasklet_init(&trans_pcie->irq_tasklet, (void (*)(unsigned long))
+		iwl_irq_tasklet, (unsigned long)trans);
+
+	iwl_alloc_isr_ict(trans);
+
+	err = request_irq(bus(trans)->irq, iwl_isr_ict, IRQF_SHARED,
+		DRV_NAME, trans);
+	if (err) {
+		IWL_ERR(trans, "Error allocating IRQ %d\n", bus(trans)->irq);
+		iwl_free_isr_ict(trans);
+		return err;
+	}
+
+	INIT_WORK(&trans_pcie->rx_replenish, iwl_bg_rx_replenish);
+	return 0;
+}
+
+static int iwlagn_txq_check_empty(struct iwl_trans *trans,
+			   int sta_id, u8 tid, int txq_id)
+{
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+	struct iwl_queue *q = &trans_pcie->txq[txq_id].q;
+	struct iwl_tid_data *tid_data = &trans->shrd->tid_data[sta_id][tid];
+
+	lockdep_assert_held(&trans->shrd->sta_lock);
+
+	switch (trans->shrd->tid_data[sta_id][tid].agg.state) {
+	case IWL_EMPTYING_HW_QUEUE_DELBA:
+		/* We are reclaiming the last packet of the */
+		/* aggregated HW queue */
+		if ((txq_id  == tid_data->agg.txq_id) &&
+		    (q->read_ptr == q->write_ptr)) {
+			IWL_DEBUG_HT(trans,
+				"HW queue empty: continue DELBA flow\n");
+			iwl_trans_pcie_txq_agg_disable(trans, txq_id);
+			tid_data->agg.state = IWL_AGG_OFF;
+			iwl_stop_tx_ba_trans_ready(priv(trans),
+						   NUM_IWL_RXON_CTX,
+						   sta_id, tid);
+			iwl_wake_queue(trans, &trans_pcie->txq[txq_id]);
+		}
+		break;
+	case IWL_EMPTYING_HW_QUEUE_ADDBA:
+		/* We are reclaiming the last packet of the queue */
+		if (tid_data->tfds_in_queue == 0) {
+			IWL_DEBUG_HT(trans,
+				"HW queue empty: continue ADDBA flow\n");
+			tid_data->agg.state = IWL_AGG_ON;
+			iwl_start_tx_ba_trans_ready(priv(trans),
+						    NUM_IWL_RXON_CTX,
+						    sta_id, tid);
+		}
+		break;
+	default:
+		break;
+	}
+
+	return 0;
+}
+
+static void iwl_free_tfds_in_queue(struct iwl_trans *trans,
+			    int sta_id, int tid, int freed)
+{
+	lockdep_assert_held(&trans->shrd->sta_lock);
+
+	if (trans->shrd->tid_data[sta_id][tid].tfds_in_queue >= freed)
+		trans->shrd->tid_data[sta_id][tid].tfds_in_queue -= freed;
+	else {
+		IWL_DEBUG_TX(trans, "free more than tfds_in_queue (%u:%d)\n",
+			trans->shrd->tid_data[sta_id][tid].tfds_in_queue,
+			freed);
+		trans->shrd->tid_data[sta_id][tid].tfds_in_queue = 0;
+	}
+}
+
+static void iwl_trans_pcie_reclaim(struct iwl_trans *trans, int sta_id, int tid,
+		      int txq_id, int ssn, u32 status,
+		      struct sk_buff_head *skbs)
+{
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+	struct iwl_tx_queue *txq = &trans_pcie->txq[txq_id];
+	enum iwl_agg_state agg_state;
+	/* n_bd is usually 256 => n_bd - 1 = 0xff */
+	int tfd_num = ssn & (txq->q.n_bd - 1);
+	int freed = 0;
+	bool cond;
+
+	txq->time_stamp = jiffies;
+
+	if (txq->sched_retry) {
+		agg_state =
+			trans->shrd->tid_data[txq->sta_id][txq->tid].agg.state;
+		cond = (agg_state != IWL_EMPTYING_HW_QUEUE_DELBA);
+	} else {
+		cond = (status != TX_STATUS_FAIL_PASSIVE_NO_RX);
+	}
+
+	if (txq->q.read_ptr != tfd_num) {
+		IWL_DEBUG_TX_REPLY(trans, "Retry scheduler reclaim "
+				"scd_ssn=%d idx=%d txq=%d swq=%d\n",
+				ssn , tfd_num, txq_id, txq->swq_id);
+		freed = iwl_tx_queue_reclaim(trans, txq_id, tfd_num, skbs);
+		if (iwl_queue_space(&txq->q) > txq->q.low_mark && cond)
+			iwl_wake_queue(trans, txq);
+	}
+
+	iwl_free_tfds_in_queue(trans, sta_id, tid, freed);
+	iwlagn_txq_check_empty(trans, sta_id, tid, txq_id);
+}
+
+static void iwl_trans_pcie_free(struct iwl_trans *trans)
+{
+	iwl_trans_pcie_tx_free(trans);
+	iwl_trans_pcie_rx_free(trans);
+	free_irq(bus(trans)->irq, trans);
+	iwl_free_isr_ict(trans);
+	trans->shrd->trans = NULL;
+	kfree(trans);
+}
+
+#ifdef CONFIG_PM
+
+static int iwl_trans_pcie_suspend(struct iwl_trans *trans)
+{
+	/*
+	 * This function is called when system goes into suspend state
+	 * mac80211 will call iwl_mac_stop() from the mac80211 suspend function
+	 * first but since iwl_mac_stop() has no knowledge of who the caller is,
+	 * it will not call apm_ops.stop() to stop the DMA operation.
+	 * Calling apm_ops.stop here to make sure we stop the DMA.
+	 *
+	 * But of course ... if we have configured WoWLAN then we did other
+	 * things already :-)
+	 */
+	if (!trans->shrd->wowlan)
+		iwl_apm_stop(priv(trans));
+
+	return 0;
+}
+
+static int iwl_trans_pcie_resume(struct iwl_trans *trans)
+{
+	bool hw_rfkill = false;
+
+	iwl_enable_interrupts(trans);
+
+	if (!(iwl_read32(bus(trans), CSR_GP_CNTRL) &
+				CSR_GP_CNTRL_REG_FLAG_HW_RF_KILL_SW))
+		hw_rfkill = true;
+
+	if (hw_rfkill)
+		set_bit(STATUS_RF_KILL_HW, &trans->shrd->status);
+	else
+		clear_bit(STATUS_RF_KILL_HW, &trans->shrd->status);
+
+	iwl_set_hw_rfkill_state(priv(trans), hw_rfkill);
+
+	return 0;
+}
+#else /* CONFIG_PM */
+static int iwl_trans_pcie_suspend(struct iwl_trans *trans)
+{ return 0; }
+
+static int iwl_trans_pcie_resume(struct iwl_trans *trans)
+{ return 0; }
+
+#endif /* CONFIG_PM */
+
+static void iwl_trans_pcie_wake_any_queue(struct iwl_trans *trans,
+					  enum iwl_rxon_context_id ctx)
+{
+	u8 ac, txq_id;
+	struct iwl_trans_pcie *trans_pcie =
+		IWL_TRANS_GET_PCIE_TRANS(trans);
+
+	for (ac = 0; ac < AC_NUM; ac++) {
+		txq_id = trans_pcie->ac_to_queue[ctx][ac];
+		IWL_DEBUG_INFO(trans, "Queue Status: Q[%d] %s\n",
+			ac,
+			(atomic_read(&trans_pcie->queue_stop_count[ac]) > 0)
+			      ? "stopped" : "awake");
+		iwl_wake_queue(trans, &trans_pcie->txq[txq_id]);
+	}
+}
+
+const struct iwl_trans_ops trans_ops_pcie;
+
+static struct iwl_trans *iwl_trans_pcie_alloc(struct iwl_shared *shrd)
+{
+	struct iwl_trans *iwl_trans = kzalloc(sizeof(struct iwl_trans) +
+					      sizeof(struct iwl_trans_pcie),
+					      GFP_KERNEL);
+	if (iwl_trans) {
+		struct iwl_trans_pcie *trans_pcie =
+			IWL_TRANS_GET_PCIE_TRANS(iwl_trans);
+		iwl_trans->ops = &trans_ops_pcie;
+		iwl_trans->shrd = shrd;
+		trans_pcie->trans = iwl_trans;
+		spin_lock_init(&iwl_trans->hcmd_lock);
+	}
+
+	return iwl_trans;
+}
+
+static void iwl_trans_pcie_stop_queue(struct iwl_trans *trans, int txq_id)
+{
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+
+	iwl_stop_queue(trans, &trans_pcie->txq[txq_id]);
+}
+
+#define IWL_FLUSH_WAIT_MS	2000
+
+static int iwl_trans_pcie_wait_tx_queue_empty(struct iwl_trans *trans)
+{
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+	struct iwl_tx_queue *txq;
+	struct iwl_queue *q;
+	int cnt;
+	unsigned long now = jiffies;
+	int ret = 0;
+
+	/* waiting for all the tx frames complete might take a while */
+	for (cnt = 0; cnt < hw_params(trans).max_txq_num; cnt++) {
+		if (cnt == trans->shrd->cmd_queue)
+			continue;
+		txq = &trans_pcie->txq[cnt];
+		q = &txq->q;
+		while (q->read_ptr != q->write_ptr && !time_after(jiffies,
+		       now + msecs_to_jiffies(IWL_FLUSH_WAIT_MS)))
+			msleep(1);
+
+		if (q->read_ptr != q->write_ptr) {
+			IWL_ERR(trans, "fail to flush all tx fifo queues\n");
+			ret = -ETIMEDOUT;
+			break;
+		}
+	}
+	return ret;
+}
+
+/*
+ * On every watchdog tick we check (latest) time stamp. If it does not
+ * change during timeout period and queue is not empty we reset firmware.
+ */
+static int iwl_trans_pcie_check_stuck_queue(struct iwl_trans *trans, int cnt)
+{
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+	struct iwl_tx_queue *txq = &trans_pcie->txq[cnt];
+	struct iwl_queue *q = &txq->q;
+	unsigned long timeout;
+
+	if (q->read_ptr == q->write_ptr) {
+		txq->time_stamp = jiffies;
+		return 0;
+	}
+
+	timeout = txq->time_stamp +
+		  msecs_to_jiffies(hw_params(trans).wd_timeout);
+
+	if (time_after(jiffies, timeout)) {
+		IWL_ERR(trans, "Queue %d stuck for %u ms.\n", q->id,
+			hw_params(trans).wd_timeout);
+		IWL_ERR(trans, "Current read_ptr %d write_ptr %d\n",
+			q->read_ptr, q->write_ptr);
+		return 1;
+	}
+
+	return 0;
+}
+
+static const char *get_fh_string(int cmd)
+{
+	switch (cmd) {
+	IWL_CMD(FH_RSCSR_CHNL0_STTS_WPTR_REG);
+	IWL_CMD(FH_RSCSR_CHNL0_RBDCB_BASE_REG);
+	IWL_CMD(FH_RSCSR_CHNL0_WPTR);
+	IWL_CMD(FH_MEM_RCSR_CHNL0_CONFIG_REG);
+	IWL_CMD(FH_MEM_RSSR_SHARED_CTRL_REG);
+	IWL_CMD(FH_MEM_RSSR_RX_STATUS_REG);
+	IWL_CMD(FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV);
+	IWL_CMD(FH_TSSR_TX_STATUS_REG);
+	IWL_CMD(FH_TSSR_TX_ERROR_REG);
+	default:
+		return "UNKNOWN";
+	}
+}
+
+int iwl_dump_fh(struct iwl_trans *trans, char **buf, bool display)
+{
+	int i;
+#ifdef CONFIG_IWLWIFI_DEBUG
+	int pos = 0;
+	size_t bufsz = 0;
+#endif
+	static const u32 fh_tbl[] = {
+		FH_RSCSR_CHNL0_STTS_WPTR_REG,
+		FH_RSCSR_CHNL0_RBDCB_BASE_REG,
+		FH_RSCSR_CHNL0_WPTR,
+		FH_MEM_RCSR_CHNL0_CONFIG_REG,
+		FH_MEM_RSSR_SHARED_CTRL_REG,
+		FH_MEM_RSSR_RX_STATUS_REG,
+		FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV,
+		FH_TSSR_TX_STATUS_REG,
+		FH_TSSR_TX_ERROR_REG
+	};
+#ifdef CONFIG_IWLWIFI_DEBUG
+	if (display) {
+		bufsz = ARRAY_SIZE(fh_tbl) * 48 + 40;
+		*buf = kmalloc(bufsz, GFP_KERNEL);
+		if (!*buf)
+			return -ENOMEM;
+		pos += scnprintf(*buf + pos, bufsz - pos,
+				"FH register values:\n");
+		for (i = 0; i < ARRAY_SIZE(fh_tbl); i++) {
+			pos += scnprintf(*buf + pos, bufsz - pos,
+				"  %34s: 0X%08x\n",
+				get_fh_string(fh_tbl[i]),
+				iwl_read_direct32(bus(trans), fh_tbl[i]));
+		}
+		return pos;
+	}
+#endif
+	IWL_ERR(trans, "FH register values:\n");
+	for (i = 0; i <  ARRAY_SIZE(fh_tbl); i++) {
+		IWL_ERR(trans, "  %34s: 0X%08x\n",
+			get_fh_string(fh_tbl[i]),
+			iwl_read_direct32(bus(trans), fh_tbl[i]));
+	}
+	return 0;
+}
+
+static const char *get_csr_string(int cmd)
+{
+	switch (cmd) {
+	IWL_CMD(CSR_HW_IF_CONFIG_REG);
+	IWL_CMD(CSR_INT_COALESCING);
+	IWL_CMD(CSR_INT);
+	IWL_CMD(CSR_INT_MASK);
+	IWL_CMD(CSR_FH_INT_STATUS);
+	IWL_CMD(CSR_GPIO_IN);
+	IWL_CMD(CSR_RESET);
+	IWL_CMD(CSR_GP_CNTRL);
+	IWL_CMD(CSR_HW_REV);
+	IWL_CMD(CSR_EEPROM_REG);
+	IWL_CMD(CSR_EEPROM_GP);
+	IWL_CMD(CSR_OTP_GP_REG);
+	IWL_CMD(CSR_GIO_REG);
+	IWL_CMD(CSR_GP_UCODE_REG);
+	IWL_CMD(CSR_GP_DRIVER_REG);
+	IWL_CMD(CSR_UCODE_DRV_GP1);
+	IWL_CMD(CSR_UCODE_DRV_GP2);
+	IWL_CMD(CSR_LED_REG);
+	IWL_CMD(CSR_DRAM_INT_TBL_REG);
+	IWL_CMD(CSR_GIO_CHICKEN_BITS);
+	IWL_CMD(CSR_ANA_PLL_CFG);
+	IWL_CMD(CSR_HW_REV_WA_REG);
+	IWL_CMD(CSR_DBG_HPET_MEM_REG);
+	default:
+		return "UNKNOWN";
+	}
+}
+
+void iwl_dump_csr(struct iwl_trans *trans)
+{
+	int i;
+	static const u32 csr_tbl[] = {
+		CSR_HW_IF_CONFIG_REG,
+		CSR_INT_COALESCING,
+		CSR_INT,
+		CSR_INT_MASK,
+		CSR_FH_INT_STATUS,
+		CSR_GPIO_IN,
+		CSR_RESET,
+		CSR_GP_CNTRL,
+		CSR_HW_REV,
+		CSR_EEPROM_REG,
+		CSR_EEPROM_GP,
+		CSR_OTP_GP_REG,
+		CSR_GIO_REG,
+		CSR_GP_UCODE_REG,
+		CSR_GP_DRIVER_REG,
+		CSR_UCODE_DRV_GP1,
+		CSR_UCODE_DRV_GP2,
+		CSR_LED_REG,
+		CSR_DRAM_INT_TBL_REG,
+		CSR_GIO_CHICKEN_BITS,
+		CSR_ANA_PLL_CFG,
+		CSR_HW_REV_WA_REG,
+		CSR_DBG_HPET_MEM_REG
+	};
+	IWL_ERR(trans, "CSR values:\n");
+	IWL_ERR(trans, "(2nd byte of CSR_INT_COALESCING is "
+		"CSR_INT_PERIODIC_REG)\n");
+	for (i = 0; i <  ARRAY_SIZE(csr_tbl); i++) {
+		IWL_ERR(trans, "  %25s: 0X%08x\n",
+			get_csr_string(csr_tbl[i]),
+			iwl_read32(bus(trans), csr_tbl[i]));
+	}
+}
+
+#ifdef CONFIG_IWLWIFI_DEBUGFS
+/* create and remove of files */
+#define DEBUGFS_ADD_FILE(name, parent, mode) do {			\
+	if (!debugfs_create_file(#name, mode, parent, trans,		\
+				 &iwl_dbgfs_##name##_ops))		\
+		return -ENOMEM;						\
+} while (0)
+
+/* file operation */
+#define DEBUGFS_READ_FUNC(name)                                         \
+static ssize_t iwl_dbgfs_##name##_read(struct file *file,               \
+					char __user *user_buf,          \
+					size_t count, loff_t *ppos);
+
+#define DEBUGFS_WRITE_FUNC(name)                                        \
+static ssize_t iwl_dbgfs_##name##_write(struct file *file,              \
+					const char __user *user_buf,    \
+					size_t count, loff_t *ppos);
+
+
+static int iwl_dbgfs_open_file_generic(struct inode *inode, struct file *file)
+{
+	file->private_data = inode->i_private;
+	return 0;
+}
+
+#define DEBUGFS_READ_FILE_OPS(name)					\
+	DEBUGFS_READ_FUNC(name);					\
+static const struct file_operations iwl_dbgfs_##name##_ops = {		\
+	.read = iwl_dbgfs_##name##_read,				\
+	.open = iwl_dbgfs_open_file_generic,				\
+	.llseek = generic_file_llseek,					\
+};
+
+#define DEBUGFS_WRITE_FILE_OPS(name)                                    \
+	DEBUGFS_WRITE_FUNC(name);                                       \
+static const struct file_operations iwl_dbgfs_##name##_ops = {          \
+	.write = iwl_dbgfs_##name##_write,                              \
+	.open = iwl_dbgfs_open_file_generic,				\
+	.llseek = generic_file_llseek,					\
+};
+
+#define DEBUGFS_READ_WRITE_FILE_OPS(name)				\
+	DEBUGFS_READ_FUNC(name);					\
+	DEBUGFS_WRITE_FUNC(name);					\
+static const struct file_operations iwl_dbgfs_##name##_ops = {		\
+	.write = iwl_dbgfs_##name##_write,				\
+	.read = iwl_dbgfs_##name##_read,				\
+	.open = iwl_dbgfs_open_file_generic,				\
+	.llseek = generic_file_llseek,					\
+};
+
+static ssize_t iwl_dbgfs_tx_queue_read(struct file *file,
+						char __user *user_buf,
+						size_t count, loff_t *ppos)
+{
+	struct iwl_trans *trans = file->private_data;
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+	struct iwl_tx_queue *txq;
+	struct iwl_queue *q;
+	char *buf;
+	int pos = 0;
+	int cnt;
+	int ret;
+	const size_t bufsz = sizeof(char) * 64 * hw_params(trans).max_txq_num;
+
+	if (!trans_pcie->txq) {
+		IWL_ERR(trans, "txq not ready\n");
+		return -EAGAIN;
+	}
+	buf = kzalloc(bufsz, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	for (cnt = 0; cnt < hw_params(trans).max_txq_num; cnt++) {
+		txq = &trans_pcie->txq[cnt];
+		q = &txq->q;
+		pos += scnprintf(buf + pos, bufsz - pos,
+				"hwq %.2d: read=%u write=%u stop=%d"
+				" swq_id=%#.2x (ac %d/hwq %d)\n",
+				cnt, q->read_ptr, q->write_ptr,
+				!!test_bit(cnt, trans_pcie->queue_stopped),
+				txq->swq_id, txq->swq_id & 3,
+				(txq->swq_id >> 2) & 0x1f);
+		if (cnt >= 4)
+			continue;
+		/* for the ACs, display the stop count too */
+		pos += scnprintf(buf + pos, bufsz - pos,
+			"        stop-count: %d\n",
+			atomic_read(&trans_pcie->queue_stop_count[cnt]));
+	}
+	ret = simple_read_from_buffer(user_buf, count, ppos, buf, pos);
+	kfree(buf);
+	return ret;
+}
+
+static ssize_t iwl_dbgfs_rx_queue_read(struct file *file,
+						char __user *user_buf,
+						size_t count, loff_t *ppos) {
+	struct iwl_trans *trans = file->private_data;
+	struct iwl_trans_pcie *trans_pcie =
+		IWL_TRANS_GET_PCIE_TRANS(trans);
+	struct iwl_rx_queue *rxq = &trans_pcie->rxq;
+	char buf[256];
+	int pos = 0;
+	const size_t bufsz = sizeof(buf);
+
+	pos += scnprintf(buf + pos, bufsz - pos, "read: %u\n",
+						rxq->read);
+	pos += scnprintf(buf + pos, bufsz - pos, "write: %u\n",
+						rxq->write);
+	pos += scnprintf(buf + pos, bufsz - pos, "free_count: %u\n",
+						rxq->free_count);
+	if (rxq->rb_stts) {
+		pos += scnprintf(buf + pos, bufsz - pos, "closed_rb_num: %u\n",
+			 le16_to_cpu(rxq->rb_stts->closed_rb_num) &  0x0FFF);
+	} else {
+		pos += scnprintf(buf + pos, bufsz - pos,
+					"closed_rb_num: Not Allocated\n");
+	}
+	return simple_read_from_buffer(user_buf, count, ppos, buf, pos);
+}
+
+static ssize_t iwl_dbgfs_log_event_read(struct file *file,
+					 char __user *user_buf,
+					 size_t count, loff_t *ppos)
+{
+	struct iwl_trans *trans = file->private_data;
+	char *buf;
+	int pos = 0;
+	ssize_t ret = -ENOMEM;
+
+	ret = pos = iwl_dump_nic_event_log(trans, true, &buf, true);
+	if (buf) {
+		ret = simple_read_from_buffer(user_buf, count, ppos, buf, pos);
+		kfree(buf);
+	}
+	return ret;
+}
+
+static ssize_t iwl_dbgfs_log_event_write(struct file *file,
+					const char __user *user_buf,
+					size_t count, loff_t *ppos)
+{
+	struct iwl_trans *trans = file->private_data;
+	u32 event_log_flag;
+	char buf[8];
+	int buf_size;
+
+	memset(buf, 0, sizeof(buf));
+	buf_size = min(count, sizeof(buf) -  1);
+	if (copy_from_user(buf, user_buf, buf_size))
+		return -EFAULT;
+	if (sscanf(buf, "%d", &event_log_flag) != 1)
+		return -EFAULT;
+	if (event_log_flag == 1)
+		iwl_dump_nic_event_log(trans, true, NULL, false);
+
+	return count;
+}
+
+static ssize_t iwl_dbgfs_interrupt_read(struct file *file,
+					char __user *user_buf,
+					size_t count, loff_t *ppos) {
+
+	struct iwl_trans *trans = file->private_data;
+	struct iwl_trans_pcie *trans_pcie =
+		IWL_TRANS_GET_PCIE_TRANS(trans);
+	struct isr_statistics *isr_stats = &trans_pcie->isr_stats;
+
+	int pos = 0;
+	char *buf;
+	int bufsz = 24 * 64; /* 24 items * 64 char per item */
+	ssize_t ret;
+
+	buf = kzalloc(bufsz, GFP_KERNEL);
+	if (!buf) {
+		IWL_ERR(trans, "Can not allocate Buffer\n");
+		return -ENOMEM;
+	}
+
+	pos += scnprintf(buf + pos, bufsz - pos,
+			"Interrupt Statistics Report:\n");
+
+	pos += scnprintf(buf + pos, bufsz - pos, "HW Error:\t\t\t %u\n",
+		isr_stats->hw);
+	pos += scnprintf(buf + pos, bufsz - pos, "SW Error:\t\t\t %u\n",
+		isr_stats->sw);
+	if (isr_stats->sw || isr_stats->hw) {
+		pos += scnprintf(buf + pos, bufsz - pos,
+			"\tLast Restarting Code:  0x%X\n",
+			isr_stats->err_code);
+	}
+#ifdef CONFIG_IWLWIFI_DEBUG
+	pos += scnprintf(buf + pos, bufsz - pos, "Frame transmitted:\t\t %u\n",
+		isr_stats->sch);
+	pos += scnprintf(buf + pos, bufsz - pos, "Alive interrupt:\t\t %u\n",
+		isr_stats->alive);
+#endif
+	pos += scnprintf(buf + pos, bufsz - pos,
+		"HW RF KILL switch toggled:\t %u\n", isr_stats->rfkill);
+
+	pos += scnprintf(buf + pos, bufsz - pos, "CT KILL:\t\t\t %u\n",
+		isr_stats->ctkill);
+
+	pos += scnprintf(buf + pos, bufsz - pos, "Wakeup Interrupt:\t\t %u\n",
+		isr_stats->wakeup);
+
+	pos += scnprintf(buf + pos, bufsz - pos,
+		"Rx command responses:\t\t %u\n", isr_stats->rx);
+
+	pos += scnprintf(buf + pos, bufsz - pos, "Tx/FH interrupt:\t\t %u\n",
+		isr_stats->tx);
+
+	pos += scnprintf(buf + pos, bufsz - pos, "Unexpected INTA:\t\t %u\n",
+		isr_stats->unhandled);
+
+	ret = simple_read_from_buffer(user_buf, count, ppos, buf, pos);
+	kfree(buf);
+	return ret;
+}
+
+static ssize_t iwl_dbgfs_interrupt_write(struct file *file,
+					 const char __user *user_buf,
+					 size_t count, loff_t *ppos)
+{
+	struct iwl_trans *trans = file->private_data;
+	struct iwl_trans_pcie *trans_pcie =
+		IWL_TRANS_GET_PCIE_TRANS(trans);
+	struct isr_statistics *isr_stats = &trans_pcie->isr_stats;
+
+	char buf[8];
+	int buf_size;
+	u32 reset_flag;
+
+	memset(buf, 0, sizeof(buf));
+	buf_size = min(count, sizeof(buf) -  1);
+	if (copy_from_user(buf, user_buf, buf_size))
+		return -EFAULT;
+	if (sscanf(buf, "%x", &reset_flag) != 1)
+		return -EFAULT;
+	if (reset_flag == 0)
+		memset(isr_stats, 0, sizeof(*isr_stats));
+
+	return count;
+}
+
+static ssize_t iwl_dbgfs_csr_write(struct file *file,
+					 const char __user *user_buf,
+					 size_t count, loff_t *ppos)
+{
+	struct iwl_trans *trans = file->private_data;
+	char buf[8];
+	int buf_size;
+	int csr;
+
+	memset(buf, 0, sizeof(buf));
+	buf_size = min(count, sizeof(buf) -  1);
+	if (copy_from_user(buf, user_buf, buf_size))
+		return -EFAULT;
+	if (sscanf(buf, "%d", &csr) != 1)
+		return -EFAULT;
+
+	iwl_dump_csr(trans);
+
+	return count;
+}
+
+static ssize_t iwl_dbgfs_fh_reg_read(struct file *file,
+					 char __user *user_buf,
+					 size_t count, loff_t *ppos)
+{
+	struct iwl_trans *trans = file->private_data;
+	char *buf;
+	int pos = 0;
+	ssize_t ret = -EFAULT;
+
+	ret = pos = iwl_dump_fh(trans, &buf, true);
+	if (buf) {
+		ret = simple_read_from_buffer(user_buf,
+					      count, ppos, buf, pos);
+		kfree(buf);
+	}
+
+	return ret;
+}
+
+DEBUGFS_READ_WRITE_FILE_OPS(log_event);
+DEBUGFS_READ_WRITE_FILE_OPS(interrupt);
+DEBUGFS_READ_FILE_OPS(fh_reg);
+DEBUGFS_READ_FILE_OPS(rx_queue);
+DEBUGFS_READ_FILE_OPS(tx_queue);
+DEBUGFS_WRITE_FILE_OPS(csr);
+
+/*
+ * Create the debugfs files and directories
+ *
+ */
+static int iwl_trans_pcie_dbgfs_register(struct iwl_trans *trans,
+					struct dentry *dir)
+{
+	DEBUGFS_ADD_FILE(rx_queue, dir, S_IRUSR);
+	DEBUGFS_ADD_FILE(tx_queue, dir, S_IRUSR);
+	DEBUGFS_ADD_FILE(log_event, dir, S_IWUSR | S_IRUSR);
+	DEBUGFS_ADD_FILE(interrupt, dir, S_IWUSR | S_IRUSR);
+	DEBUGFS_ADD_FILE(csr, dir, S_IWUSR);
+	DEBUGFS_ADD_FILE(fh_reg, dir, S_IRUSR);
+	return 0;
+}
+#else
+static int iwl_trans_pcie_dbgfs_register(struct iwl_trans *trans,
+					struct dentry *dir)
+{ return 0; }
+
+#endif /*CONFIG_IWLWIFI_DEBUGFS */
+
+const struct iwl_trans_ops trans_ops_pcie = {
+	.alloc = iwl_trans_pcie_alloc,
+	.request_irq = iwl_trans_pcie_request_irq,
+	.start_device = iwl_trans_pcie_start_device,
+	.prepare_card_hw = iwl_trans_pcie_prepare_card_hw,
+	.stop_device = iwl_trans_pcie_stop_device,
+
+	.tx_start = iwl_trans_pcie_tx_start,
+	.wake_any_queue = iwl_trans_pcie_wake_any_queue,
+
+	.send_cmd = iwl_trans_pcie_send_cmd,
+	.send_cmd_pdu = iwl_trans_pcie_send_cmd_pdu,
+
+	.tx = iwl_trans_pcie_tx,
+	.reclaim = iwl_trans_pcie_reclaim,
+
+	.tx_agg_disable = iwl_trans_pcie_tx_agg_disable,
+	.tx_agg_alloc = iwl_trans_pcie_tx_agg_alloc,
+	.tx_agg_setup = iwl_trans_pcie_tx_agg_setup,
+
+	.kick_nic = iwl_trans_pcie_kick_nic,
+
+	.free = iwl_trans_pcie_free,
+	.stop_queue = iwl_trans_pcie_stop_queue,
+
+	.dbgfs_register = iwl_trans_pcie_dbgfs_register,
+
+	.wait_tx_queue_empty = iwl_trans_pcie_wait_tx_queue_empty,
+	.check_stuck_queue = iwl_trans_pcie_check_stuck_queue,
+
+	.suspend = iwl_trans_pcie_suspend,
+	.resume = iwl_trans_pcie_resume,
+};
+
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c
deleted file mode 100644
index 2308177..0000000
--- a/drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c
+++ /dev/null
@@ -1,1424 +0,0 @@
-/******************************************************************************
- *
- * Copyright(c) 2003 - 2011 Intel Corporation. All rights reserved.
- *
- * Portions of this file are derived from the ipw3945 project, as well
- * as portions of the ieee80211 subsystem header files.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of version 2 of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- * more details.
- *
- * You should have received a copy of the GNU General Public License along with
- * this program; if not, write to the Free Software Foundation, Inc.,
- * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
- *
- * The full GNU General Public License is included in this distribution in the
- * file called LICENSE.
- *
- * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
- * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
- *
- *****************************************************************************/
-#include <linux/sched.h>
-#include <linux/wait.h>
-#include <linux/gfp.h>
-
-/*TODO: Remove include to iwl-core.h*/
-#include "iwl-core.h"
-#include "iwl-io.h"
-#include "iwl-helpers.h"
-#include "iwl-trans-int-pcie.h"
-
-/******************************************************************************
- *
- * RX path functions
- *
- ******************************************************************************/
-
-/*
- * Rx theory of operation
- *
- * Driver allocates a circular buffer of Receive Buffer Descriptors (RBDs),
- * each of which point to Receive Buffers to be filled by the NIC.  These get
- * used not only for Rx frames, but for any command response or notification
- * from the NIC.  The driver and NIC manage the Rx buffers by means
- * of indexes into the circular buffer.
- *
- * Rx Queue Indexes
- * The host/firmware share two index registers for managing the Rx buffers.
- *
- * The READ index maps to the first position that the firmware may be writing
- * to -- the driver can read up to (but not including) this position and get
- * good data.
- * The READ index is managed by the firmware once the card is enabled.
- *
- * The WRITE index maps to the last position the driver has read from -- the
- * position preceding WRITE is the last slot the firmware can place a packet.
- *
- * The queue is empty (no good data) if WRITE = READ - 1, and is full if
- * WRITE = READ.
- *
- * During initialization, the host sets up the READ queue position to the first
- * INDEX position, and WRITE to the last (READ - 1 wrapped)
- *
- * When the firmware places a packet in a buffer, it will advance the READ index
- * and fire the RX interrupt.  The driver can then query the READ index and
- * process as many packets as possible, moving the WRITE index forward as it
- * resets the Rx queue buffers with new memory.
- *
- * The management in the driver is as follows:
- * + A list of pre-allocated SKBs is stored in iwl->rxq->rx_free.  When
- *   iwl->rxq->free_count drops to or below RX_LOW_WATERMARK, work is scheduled
- *   to replenish the iwl->rxq->rx_free.
- * + In iwl_rx_replenish (scheduled) if 'processed' != 'read' then the
- *   iwl->rxq is replenished and the READ INDEX is updated (updating the
- *   'processed' and 'read' driver indexes as well)
- * + A received packet is processed and handed to the kernel network stack,
- *   detached from the iwl->rxq.  The driver 'processed' index is updated.
- * + The Host/Firmware iwl->rxq is replenished at tasklet time from the rx_free
- *   list. If there are no allocated buffers in iwl->rxq->rx_free, the READ
- *   INDEX is not incremented and iwl->status(RX_STALLED) is set.  If there
- *   were enough free buffers and RX_STALLED is set it is cleared.
- *
- *
- * Driver sequence:
- *
- * iwl_rx_queue_alloc()   Allocates rx_free
- * iwl_rx_replenish()     Replenishes rx_free list from rx_used, and calls
- *                            iwl_rx_queue_restock
- * iwl_rx_queue_restock() Moves available buffers from rx_free into Rx
- *                            queue, updates firmware pointers, and updates
- *                            the WRITE index.  If insufficient rx_free buffers
- *                            are available, schedules iwl_rx_replenish
- *
- * -- enable interrupts --
- * ISR - iwl_rx()         Detach iwl_rx_mem_buffers from pool up to the
- *                            READ INDEX, detaching the SKB from the pool.
- *                            Moves the packet buffer from queue to rx_used.
- *                            Calls iwl_rx_queue_restock to refill any empty
- *                            slots.
- * ...
- *
- */
-
-/**
- * iwl_rx_queue_space - Return number of free slots available in queue.
- */
-static int iwl_rx_queue_space(const struct iwl_rx_queue *q)
-{
-	int s = q->read - q->write;
-	if (s <= 0)
-		s += RX_QUEUE_SIZE;
-	/* keep some buffer to not confuse full and empty queue */
-	s -= 2;
-	if (s < 0)
-		s = 0;
-	return s;
-}
-
-/**
- * iwl_rx_queue_update_write_ptr - Update the write pointer for the RX queue
- */
-void iwl_rx_queue_update_write_ptr(struct iwl_trans *trans,
-			struct iwl_rx_queue *q)
-{
-	unsigned long flags;
-	u32 reg;
-
-	spin_lock_irqsave(&q->lock, flags);
-
-	if (q->need_update == 0)
-		goto exit_unlock;
-
-	if (hw_params(trans).shadow_reg_enable) {
-		/* shadow register enabled */
-		/* Device expects a multiple of 8 */
-		q->write_actual = (q->write & ~0x7);
-		iwl_write32(bus(trans), FH_RSCSR_CHNL0_WPTR, q->write_actual);
-	} else {
-		/* If power-saving is in use, make sure device is awake */
-		if (test_bit(STATUS_POWER_PMI, &trans->shrd->status)) {
-			reg = iwl_read32(bus(trans), CSR_UCODE_DRV_GP1);
-
-			if (reg & CSR_UCODE_DRV_GP1_BIT_MAC_SLEEP) {
-				IWL_DEBUG_INFO(trans,
-					"Rx queue requesting wakeup,"
-					" GP1 = 0x%x\n", reg);
-				iwl_set_bit(bus(trans), CSR_GP_CNTRL,
-					CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
-				goto exit_unlock;
-			}
-
-			q->write_actual = (q->write & ~0x7);
-			iwl_write_direct32(bus(trans), FH_RSCSR_CHNL0_WPTR,
-					q->write_actual);
-
-		/* Else device is assumed to be awake */
-		} else {
-			/* Device expects a multiple of 8 */
-			q->write_actual = (q->write & ~0x7);
-			iwl_write_direct32(bus(trans), FH_RSCSR_CHNL0_WPTR,
-				q->write_actual);
-		}
-	}
-	q->need_update = 0;
-
- exit_unlock:
-	spin_unlock_irqrestore(&q->lock, flags);
-}
-
-/**
- * iwlagn_dma_addr2rbd_ptr - convert a DMA address to a uCode read buffer ptr
- */
-static inline __le32 iwlagn_dma_addr2rbd_ptr(dma_addr_t dma_addr)
-{
-	return cpu_to_le32((u32)(dma_addr >> 8));
-}
-
-/**
- * iwlagn_rx_queue_restock - refill RX queue from pre-allocated pool
- *
- * If there are slots in the RX queue that need to be restocked,
- * and we have free pre-allocated buffers, fill the ranks as much
- * as we can, pulling from rx_free.
- *
- * This moves the 'write' index forward to catch up with 'processed', and
- * also updates the memory address in the firmware to reference the new
- * target buffer.
- */
-static void iwlagn_rx_queue_restock(struct iwl_trans *trans)
-{
-	struct iwl_trans_pcie *trans_pcie =
-		IWL_TRANS_GET_PCIE_TRANS(trans);
-
-	struct iwl_rx_queue *rxq = &trans_pcie->rxq;
-	struct list_head *element;
-	struct iwl_rx_mem_buffer *rxb;
-	unsigned long flags;
-
-	spin_lock_irqsave(&rxq->lock, flags);
-	while ((iwl_rx_queue_space(rxq) > 0) && (rxq->free_count)) {
-		/* The overwritten rxb must be a used one */
-		rxb = rxq->queue[rxq->write];
-		BUG_ON(rxb && rxb->page);
-
-		/* Get next free Rx buffer, remove from free list */
-		element = rxq->rx_free.next;
-		rxb = list_entry(element, struct iwl_rx_mem_buffer, list);
-		list_del(element);
-
-		/* Point to Rx buffer via next RBD in circular buffer */
-		rxq->bd[rxq->write] = iwlagn_dma_addr2rbd_ptr(rxb->page_dma);
-		rxq->queue[rxq->write] = rxb;
-		rxq->write = (rxq->write + 1) & RX_QUEUE_MASK;
-		rxq->free_count--;
-	}
-	spin_unlock_irqrestore(&rxq->lock, flags);
-	/* If the pre-allocated buffer pool is dropping low, schedule to
-	 * refill it */
-	if (rxq->free_count <= RX_LOW_WATERMARK)
-		queue_work(trans->shrd->workqueue, &trans_pcie->rx_replenish);
-
-
-	/* If we've added more space for the firmware to place data, tell it.
-	 * Increment device's write pointer in multiples of 8. */
-	if (rxq->write_actual != (rxq->write & ~0x7)) {
-		spin_lock_irqsave(&rxq->lock, flags);
-		rxq->need_update = 1;
-		spin_unlock_irqrestore(&rxq->lock, flags);
-		iwl_rx_queue_update_write_ptr(trans, rxq);
-	}
-}
-
-/**
- * iwlagn_rx_replenish - Move all used packet from rx_used to rx_free
- *
- * When moving to rx_free an SKB is allocated for the slot.
- *
- * Also restock the Rx queue via iwl_rx_queue_restock.
- * This is called as a scheduled work item (except for during initialization)
- */
-static void iwlagn_rx_allocate(struct iwl_trans *trans, gfp_t priority)
-{
-	struct iwl_trans_pcie *trans_pcie =
-		IWL_TRANS_GET_PCIE_TRANS(trans);
-
-	struct iwl_rx_queue *rxq = &trans_pcie->rxq;
-	struct list_head *element;
-	struct iwl_rx_mem_buffer *rxb;
-	struct page *page;
-	unsigned long flags;
-	gfp_t gfp_mask = priority;
-
-	while (1) {
-		spin_lock_irqsave(&rxq->lock, flags);
-		if (list_empty(&rxq->rx_used)) {
-			spin_unlock_irqrestore(&rxq->lock, flags);
-			return;
-		}
-		spin_unlock_irqrestore(&rxq->lock, flags);
-
-		if (rxq->free_count > RX_LOW_WATERMARK)
-			gfp_mask |= __GFP_NOWARN;
-
-		if (hw_params(trans).rx_page_order > 0)
-			gfp_mask |= __GFP_COMP;
-
-		/* Alloc a new receive buffer */
-		page = alloc_pages(gfp_mask,
-				  hw_params(trans).rx_page_order);
-		if (!page) {
-			if (net_ratelimit())
-				IWL_DEBUG_INFO(trans, "alloc_pages failed, "
-					   "order: %d\n",
-					   hw_params(trans).rx_page_order);
-
-			if ((rxq->free_count <= RX_LOW_WATERMARK) &&
-			    net_ratelimit())
-				IWL_CRIT(trans, "Failed to alloc_pages with %s."
-					 "Only %u free buffers remaining.\n",
-					 priority == GFP_ATOMIC ?
-					 "GFP_ATOMIC" : "GFP_KERNEL",
-					 rxq->free_count);
-			/* We don't reschedule replenish work here -- we will
-			 * call the restock method and if it still needs
-			 * more buffers it will schedule replenish */
-			return;
-		}
-
-		spin_lock_irqsave(&rxq->lock, flags);
-
-		if (list_empty(&rxq->rx_used)) {
-			spin_unlock_irqrestore(&rxq->lock, flags);
-			__free_pages(page, hw_params(trans).rx_page_order);
-			return;
-		}
-		element = rxq->rx_used.next;
-		rxb = list_entry(element, struct iwl_rx_mem_buffer, list);
-		list_del(element);
-
-		spin_unlock_irqrestore(&rxq->lock, flags);
-
-		BUG_ON(rxb->page);
-		rxb->page = page;
-		/* Get physical address of the RB */
-		rxb->page_dma = dma_map_page(bus(trans)->dev, page, 0,
-				PAGE_SIZE << hw_params(trans).rx_page_order,
-				DMA_FROM_DEVICE);
-		/* dma address must be no more than 36 bits */
-		BUG_ON(rxb->page_dma & ~DMA_BIT_MASK(36));
-		/* and also 256 byte aligned! */
-		BUG_ON(rxb->page_dma & DMA_BIT_MASK(8));
-
-		spin_lock_irqsave(&rxq->lock, flags);
-
-		list_add_tail(&rxb->list, &rxq->rx_free);
-		rxq->free_count++;
-
-		spin_unlock_irqrestore(&rxq->lock, flags);
-	}
-}
-
-void iwlagn_rx_replenish(struct iwl_trans *trans)
-{
-	unsigned long flags;
-
-	iwlagn_rx_allocate(trans, GFP_KERNEL);
-
-	spin_lock_irqsave(&trans->shrd->lock, flags);
-	iwlagn_rx_queue_restock(trans);
-	spin_unlock_irqrestore(&trans->shrd->lock, flags);
-}
-
-static void iwlagn_rx_replenish_now(struct iwl_trans *trans)
-{
-	iwlagn_rx_allocate(trans, GFP_ATOMIC);
-
-	iwlagn_rx_queue_restock(trans);
-}
-
-void iwl_bg_rx_replenish(struct work_struct *data)
-{
-	struct iwl_trans_pcie *trans_pcie =
-	    container_of(data, struct iwl_trans_pcie, rx_replenish);
-	struct iwl_trans *trans = trans_pcie->trans;
-
-	if (test_bit(STATUS_EXIT_PENDING, &trans->shrd->status))
-		return;
-
-	mutex_lock(&trans->shrd->mutex);
-	iwlagn_rx_replenish(trans);
-	mutex_unlock(&trans->shrd->mutex);
-}
-
-/**
- * iwl_rx_handle - Main entry function for receiving responses from uCode
- *
- * Uses the priv->rx_handlers callback function array to invoke
- * the appropriate handlers, including command responses,
- * frame-received notifications, and other notifications.
- */
-static void iwl_rx_handle(struct iwl_trans *trans)
-{
-	struct iwl_rx_mem_buffer *rxb;
-	struct iwl_rx_packet *pkt;
-	struct iwl_trans_pcie *trans_pcie =
-		IWL_TRANS_GET_PCIE_TRANS(trans);
-	struct iwl_rx_queue *rxq = &trans_pcie->rxq;
-	u32 r, i;
-	int reclaim;
-	unsigned long flags;
-	u8 fill_rx = 0;
-	u32 count = 8;
-	int total_empty;
-
-	/* uCode's read index (stored in shared DRAM) indicates the last Rx
-	 * buffer that the driver may process (last buffer filled by ucode). */
-	r = le16_to_cpu(rxq->rb_stts->closed_rb_num) &  0x0FFF;
-	i = rxq->read;
-
-	/* Rx interrupt, but nothing sent from uCode */
-	if (i == r)
-		IWL_DEBUG_RX(trans, "r = %d, i = %d\n", r, i);
-
-	/* calculate total frames need to be restock after handling RX */
-	total_empty = r - rxq->write_actual;
-	if (total_empty < 0)
-		total_empty += RX_QUEUE_SIZE;
-
-	if (total_empty > (RX_QUEUE_SIZE / 2))
-		fill_rx = 1;
-
-	while (i != r) {
-		int len;
-		u16 txq_id, sequence;
-
-		rxb = rxq->queue[i];
-
-		/* If an RXB doesn't have a Rx queue slot associated with it,
-		 * then a bug has been introduced in the queue refilling
-		 * routines -- catch it here */
-		if (WARN_ON(rxb == NULL)) {
-			i = (i + 1) & RX_QUEUE_MASK;
-			continue;
-		}
-
-		rxq->queue[i] = NULL;
-
-		dma_unmap_page(bus(trans)->dev, rxb->page_dma,
-			       PAGE_SIZE << hw_params(trans).rx_page_order,
-			       DMA_FROM_DEVICE);
-		pkt = rxb_addr(rxb);
-
-		IWL_DEBUG_RX(trans, "r = %d, i = %d, %s, 0x%02x\n", r,
-			i, get_cmd_string(pkt->hdr.cmd), pkt->hdr.cmd);
-
-		len = le32_to_cpu(pkt->len_n_flags) & FH_RSCSR_FRAME_SIZE_MSK;
-		len += sizeof(u32); /* account for status word */
-		trace_iwlwifi_dev_rx(priv(trans), pkt, len);
-
-		/* Reclaim a command buffer only if this packet is a response
-		 *   to a (driver-originated) command.
-		 * If the packet (e.g. Rx frame) originated from uCode,
-		 *   there is no command buffer to reclaim.
-		 * Ucode should set SEQ_RX_FRAME bit if ucode-originated,
-		 *   but apparently a few don't get set; catch them here. */
-		reclaim = !(pkt->hdr.sequence & SEQ_RX_FRAME) &&
-			(pkt->hdr.cmd != REPLY_RX_PHY_CMD) &&
-			(pkt->hdr.cmd != REPLY_RX) &&
-			(pkt->hdr.cmd != REPLY_RX_MPDU_CMD) &&
-			(pkt->hdr.cmd != REPLY_COMPRESSED_BA) &&
-			(pkt->hdr.cmd != STATISTICS_NOTIFICATION) &&
-			(pkt->hdr.cmd != REPLY_TX);
-
-		sequence = le16_to_cpu(pkt->hdr.sequence);
-		txq_id = SEQ_TO_QUEUE(le16_to_cpu(pkt->hdr.sequence));
-
-		/* warn if this is cmd response / notification and the uCode
-		 * didn't set the SEQ_RX_FRAME for a frame that is
-		 * uCode-originated*/
-		WARN(txq_id == trans->shrd->cmd_queue && reclaim == false &&
-		     (!(pkt->hdr.sequence & SEQ_RX_FRAME)),
-		     "reclaim is false, SEQ_RX_FRAME unset: %s\n",
-		     get_cmd_string(pkt->hdr.cmd));
-
-		iwl_rx_dispatch(priv(trans), rxb);
-
-		/*
-		 * XXX: After here, we should always check rxb->page
-		 * against NULL before touching it or its virtual
-		 * memory (pkt). Because some rx_handler might have
-		 * already taken or freed the pages.
-		 */
-
-		if (reclaim) {
-			/* Invoke any callbacks, transfer the buffer to caller,
-			 * and fire off the (possibly) blocking
-			 * iwl_trans_send_cmd()
-			 * as we reclaim the driver command queue */
-			if (rxb->page)
-				iwl_tx_cmd_complete(trans, rxb);
-			else
-				IWL_WARN(trans, "Claim null rxb?\n");
-		}
-
-		/* Reuse the page if possible. For notification packets and
-		 * SKBs that fail to Rx correctly, add them back into the
-		 * rx_free list for reuse later. */
-		spin_lock_irqsave(&rxq->lock, flags);
-		if (rxb->page != NULL) {
-			rxb->page_dma = dma_map_page(bus(trans)->dev, rxb->page,
-				0, PAGE_SIZE <<
-				    hw_params(trans).rx_page_order,
-				DMA_FROM_DEVICE);
-			list_add_tail(&rxb->list, &rxq->rx_free);
-			rxq->free_count++;
-		} else
-			list_add_tail(&rxb->list, &rxq->rx_used);
-
-		spin_unlock_irqrestore(&rxq->lock, flags);
-
-		i = (i + 1) & RX_QUEUE_MASK;
-		/* If there are a lot of unused frames,
-		 * restock the Rx queue so ucode wont assert. */
-		if (fill_rx) {
-			count++;
-			if (count >= 8) {
-				rxq->read = i;
-				iwlagn_rx_replenish_now(trans);
-				count = 0;
-			}
-		}
-	}
-
-	/* Backtrack one entry */
-	rxq->read = i;
-	if (fill_rx)
-		iwlagn_rx_replenish_now(trans);
-	else
-		iwlagn_rx_queue_restock(trans);
-}
-
-static const char * const desc_lookup_text[] = {
-	"OK",
-	"FAIL",
-	"BAD_PARAM",
-	"BAD_CHECKSUM",
-	"NMI_INTERRUPT_WDG",
-	"SYSASSERT",
-	"FATAL_ERROR",
-	"BAD_COMMAND",
-	"HW_ERROR_TUNE_LOCK",
-	"HW_ERROR_TEMPERATURE",
-	"ILLEGAL_CHAN_FREQ",
-	"VCC_NOT_STABLE",
-	"FH_ERROR",
-	"NMI_INTERRUPT_HOST",
-	"NMI_INTERRUPT_ACTION_PT",
-	"NMI_INTERRUPT_UNKNOWN",
-	"UCODE_VERSION_MISMATCH",
-	"HW_ERROR_ABS_LOCK",
-	"HW_ERROR_CAL_LOCK_FAIL",
-	"NMI_INTERRUPT_INST_ACTION_PT",
-	"NMI_INTERRUPT_DATA_ACTION_PT",
-	"NMI_TRM_HW_ER",
-	"NMI_INTERRUPT_TRM",
-	"NMI_INTERRUPT_BREAK_POINT",
-	"DEBUG_0",
-	"DEBUG_1",
-	"DEBUG_2",
-	"DEBUG_3",
-};
-
-static struct { char *name; u8 num; } advanced_lookup[] = {
-	{ "NMI_INTERRUPT_WDG", 0x34 },
-	{ "SYSASSERT", 0x35 },
-	{ "UCODE_VERSION_MISMATCH", 0x37 },
-	{ "BAD_COMMAND", 0x38 },
-	{ "NMI_INTERRUPT_DATA_ACTION_PT", 0x3C },
-	{ "FATAL_ERROR", 0x3D },
-	{ "NMI_TRM_HW_ERR", 0x46 },
-	{ "NMI_INTERRUPT_TRM", 0x4C },
-	{ "NMI_INTERRUPT_BREAK_POINT", 0x54 },
-	{ "NMI_INTERRUPT_WDG_RXF_FULL", 0x5C },
-	{ "NMI_INTERRUPT_WDG_NO_RBD_RXF_FULL", 0x64 },
-	{ "NMI_INTERRUPT_HOST", 0x66 },
-	{ "NMI_INTERRUPT_ACTION_PT", 0x7C },
-	{ "NMI_INTERRUPT_UNKNOWN", 0x84 },
-	{ "NMI_INTERRUPT_INST_ACTION_PT", 0x86 },
-	{ "ADVANCED_SYSASSERT", 0 },
-};
-
-static const char *desc_lookup(u32 num)
-{
-	int i;
-	int max = ARRAY_SIZE(desc_lookup_text);
-
-	if (num < max)
-		return desc_lookup_text[num];
-
-	max = ARRAY_SIZE(advanced_lookup) - 1;
-	for (i = 0; i < max; i++) {
-		if (advanced_lookup[i].num == num)
-			break;
-	}
-	return advanced_lookup[i].name;
-}
-
-#define ERROR_START_OFFSET  (1 * sizeof(u32))
-#define ERROR_ELEM_SIZE     (7 * sizeof(u32))
-
-static void iwl_dump_nic_error_log(struct iwl_trans *trans)
-{
-	u32 base;
-	struct iwl_error_event_table table;
-	struct iwl_priv *priv = priv(trans);
-	struct iwl_trans_pcie *trans_pcie =
-		IWL_TRANS_GET_PCIE_TRANS(trans);
-
-	base = priv->device_pointers.error_event_table;
-	if (priv->ucode_type == IWL_UCODE_INIT) {
-		if (!base)
-			base = priv->init_errlog_ptr;
-	} else {
-		if (!base)
-			base = priv->inst_errlog_ptr;
-	}
-
-	if (!iwlagn_hw_valid_rtc_data_addr(base)) {
-		IWL_ERR(trans,
-			"Not valid error log pointer 0x%08X for %s uCode\n",
-			base,
-			(priv->ucode_type == IWL_UCODE_INIT)
-					? "Init" : "RT");
-		return;
-	}
-
-	iwl_read_targ_mem_words(bus(priv), base, &table, sizeof(table));
-
-	if (ERROR_START_OFFSET <= table.valid * ERROR_ELEM_SIZE) {
-		IWL_ERR(trans, "Start IWL Error Log Dump:\n");
-		IWL_ERR(trans, "Status: 0x%08lX, count: %d\n",
-			trans->shrd->status, table.valid);
-	}
-
-	trans_pcie->isr_stats.err_code = table.error_id;
-
-	trace_iwlwifi_dev_ucode_error(priv, table.error_id, table.tsf_low,
-				      table.data1, table.data2, table.line,
-				      table.blink1, table.blink2, table.ilink1,
-				      table.ilink2, table.bcon_time, table.gp1,
-				      table.gp2, table.gp3, table.ucode_ver,
-				      table.hw_ver, table.brd_ver);
-	IWL_ERR(trans, "0x%08X | %-28s\n", table.error_id,
-		desc_lookup(table.error_id));
-	IWL_ERR(trans, "0x%08X | uPc\n", table.pc);
-	IWL_ERR(trans, "0x%08X | branchlink1\n", table.blink1);
-	IWL_ERR(trans, "0x%08X | branchlink2\n", table.blink2);
-	IWL_ERR(trans, "0x%08X | interruptlink1\n", table.ilink1);
-	IWL_ERR(trans, "0x%08X | interruptlink2\n", table.ilink2);
-	IWL_ERR(trans, "0x%08X | data1\n", table.data1);
-	IWL_ERR(trans, "0x%08X | data2\n", table.data2);
-	IWL_ERR(trans, "0x%08X | line\n", table.line);
-	IWL_ERR(trans, "0x%08X | beacon time\n", table.bcon_time);
-	IWL_ERR(trans, "0x%08X | tsf low\n", table.tsf_low);
-	IWL_ERR(trans, "0x%08X | tsf hi\n", table.tsf_hi);
-	IWL_ERR(trans, "0x%08X | time gp1\n", table.gp1);
-	IWL_ERR(trans, "0x%08X | time gp2\n", table.gp2);
-	IWL_ERR(trans, "0x%08X | time gp3\n", table.gp3);
-	IWL_ERR(trans, "0x%08X | uCode version\n", table.ucode_ver);
-	IWL_ERR(trans, "0x%08X | hw version\n", table.hw_ver);
-	IWL_ERR(trans, "0x%08X | board version\n", table.brd_ver);
-	IWL_ERR(trans, "0x%08X | hcmd\n", table.hcmd);
-}
-
-/**
- * iwl_irq_handle_error - called for HW or SW error interrupt from card
- */
-static void iwl_irq_handle_error(struct iwl_trans *trans)
-{
-	struct iwl_priv *priv = priv(trans);
-	/* W/A for WiFi/WiMAX coex and WiMAX own the RF */
-	if (priv->cfg->internal_wimax_coex &&
-	    (!(iwl_read_prph(bus(trans), APMG_CLK_CTRL_REG) &
-			APMS_CLK_VAL_MRB_FUNC_MODE) ||
-	     (iwl_read_prph(bus(trans), APMG_PS_CTRL_REG) &
-			APMG_PS_CTRL_VAL_RESET_REQ))) {
-		/*
-		 * Keep the restart process from trying to send host
-		 * commands by clearing the ready bit.
-		 */
-		clear_bit(STATUS_READY, &trans->shrd->status);
-		clear_bit(STATUS_HCMD_ACTIVE, &trans->shrd->status);
-		wake_up_interruptible(&priv->shrd->wait_command_queue);
-		IWL_ERR(trans, "RF is used by WiMAX\n");
-		return;
-	}
-
-	IWL_ERR(trans, "Loaded firmware version: %s\n",
-		priv->hw->wiphy->fw_version);
-
-	iwl_dump_nic_error_log(trans);
-	iwl_dump_csr(trans);
-	iwl_dump_fh(trans, NULL, false);
-	iwl_dump_nic_event_log(trans, false, NULL, false);
-#ifdef CONFIG_IWLWIFI_DEBUG
-	if (iwl_get_debug_level(trans->shrd) & IWL_DL_FW_ERRORS)
-		iwl_print_rx_config_cmd(priv(trans), IWL_RXON_CTX_BSS);
-#endif
-
-	iwlagn_fw_error(priv, false);
-}
-
-#define EVENT_START_OFFSET  (4 * sizeof(u32))
-
-/**
- * iwl_print_event_log - Dump error event log to syslog
- *
- */
-static int iwl_print_event_log(struct iwl_trans *trans, u32 start_idx,
-			       u32 num_events, u32 mode,
-			       int pos, char **buf, size_t bufsz)
-{
-	u32 i;
-	u32 base;       /* SRAM byte address of event log header */
-	u32 event_size; /* 2 u32s, or 3 u32s if timestamp recorded */
-	u32 ptr;        /* SRAM byte address of log data */
-	u32 ev, time, data; /* event log data */
-	unsigned long reg_flags;
-	struct iwl_priv *priv = priv(trans);
-
-	if (num_events == 0)
-		return pos;
-
-	base = priv->device_pointers.log_event_table;
-	if (priv->ucode_type == IWL_UCODE_INIT) {
-		if (!base)
-			base = priv->init_evtlog_ptr;
-	} else {
-		if (!base)
-			base = priv->inst_evtlog_ptr;
-	}
-
-	if (mode == 0)
-		event_size = 2 * sizeof(u32);
-	else
-		event_size = 3 * sizeof(u32);
-
-	ptr = base + EVENT_START_OFFSET + (start_idx * event_size);
-
-	/* Make sure device is powered up for SRAM reads */
-	spin_lock_irqsave(&bus(trans)->reg_lock, reg_flags);
-	iwl_grab_nic_access(bus(trans));
-
-	/* Set starting address; reads will auto-increment */
-	iwl_write32(bus(trans), HBUS_TARG_MEM_RADDR, ptr);
-	rmb();
-
-	/* "time" is actually "data" for mode 0 (no timestamp).
-	* place event id # at far right for easier visual parsing. */
-	for (i = 0; i < num_events; i++) {
-		ev = iwl_read32(bus(trans), HBUS_TARG_MEM_RDAT);
-		time = iwl_read32(bus(trans), HBUS_TARG_MEM_RDAT);
-		if (mode == 0) {
-			/* data, ev */
-			if (bufsz) {
-				pos += scnprintf(*buf + pos, bufsz - pos,
-						"EVT_LOG:0x%08x:%04u\n",
-						time, ev);
-			} else {
-				trace_iwlwifi_dev_ucode_event(priv, 0,
-					time, ev);
-				IWL_ERR(trans, "EVT_LOG:0x%08x:%04u\n",
-					time, ev);
-			}
-		} else {
-			data = iwl_read32(bus(trans), HBUS_TARG_MEM_RDAT);
-			if (bufsz) {
-				pos += scnprintf(*buf + pos, bufsz - pos,
-						"EVT_LOGT:%010u:0x%08x:%04u\n",
-						 time, data, ev);
-			} else {
-				IWL_ERR(trans, "EVT_LOGT:%010u:0x%08x:%04u\n",
-					time, data, ev);
-				trace_iwlwifi_dev_ucode_event(priv, time,
-					data, ev);
-			}
-		}
-	}
-
-	/* Allow device to power down */
-	iwl_release_nic_access(bus(trans));
-	spin_unlock_irqrestore(&bus(trans)->reg_lock, reg_flags);
-	return pos;
-}
-
-/**
- * iwl_print_last_event_logs - Dump the newest # of event log to syslog
- */
-static int iwl_print_last_event_logs(struct iwl_trans *trans, u32 capacity,
-				    u32 num_wraps, u32 next_entry,
-				    u32 size, u32 mode,
-				    int pos, char **buf, size_t bufsz)
-{
-	/*
-	 * display the newest DEFAULT_LOG_ENTRIES entries
-	 * i.e the entries just before the next ont that uCode would fill.
-	 */
-	if (num_wraps) {
-		if (next_entry < size) {
-			pos = iwl_print_event_log(trans,
-						capacity - (size - next_entry),
-						size - next_entry, mode,
-						pos, buf, bufsz);
-			pos = iwl_print_event_log(trans, 0,
-						  next_entry, mode,
-						  pos, buf, bufsz);
-		} else
-			pos = iwl_print_event_log(trans, next_entry - size,
-						  size, mode, pos, buf, bufsz);
-	} else {
-		if (next_entry < size) {
-			pos = iwl_print_event_log(trans, 0, next_entry,
-						  mode, pos, buf, bufsz);
-		} else {
-			pos = iwl_print_event_log(trans, next_entry - size,
-						  size, mode, pos, buf, bufsz);
-		}
-	}
-	return pos;
-}
-
-#define DEFAULT_DUMP_EVENT_LOG_ENTRIES (20)
-
-int iwl_dump_nic_event_log(struct iwl_trans *trans, bool full_log,
-			    char **buf, bool display)
-{
-	u32 base;       /* SRAM byte address of event log header */
-	u32 capacity;   /* event log capacity in # entries */
-	u32 mode;       /* 0 - no timestamp, 1 - timestamp recorded */
-	u32 num_wraps;  /* # times uCode wrapped to top of log */
-	u32 next_entry; /* index of next entry to be written by uCode */
-	u32 size;       /* # entries that we'll print */
-	u32 logsize;
-	int pos = 0;
-	size_t bufsz = 0;
-	struct iwl_priv *priv = priv(trans);
-
-	base = priv->device_pointers.log_event_table;
-	if (priv->ucode_type == IWL_UCODE_INIT) {
-		logsize = priv->init_evtlog_size;
-		if (!base)
-			base = priv->init_evtlog_ptr;
-	} else {
-		logsize = priv->inst_evtlog_size;
-		if (!base)
-			base = priv->inst_evtlog_ptr;
-	}
-
-	if (!iwlagn_hw_valid_rtc_data_addr(base)) {
-		IWL_ERR(trans,
-			"Invalid event log pointer 0x%08X for %s uCode\n",
-			base,
-			(priv->ucode_type == IWL_UCODE_INIT)
-					? "Init" : "RT");
-		return -EINVAL;
-	}
-
-	/* event log header */
-	capacity = iwl_read_targ_mem(bus(trans), base);
-	mode = iwl_read_targ_mem(bus(trans), base + (1 * sizeof(u32)));
-	num_wraps = iwl_read_targ_mem(bus(trans), base + (2 * sizeof(u32)));
-	next_entry = iwl_read_targ_mem(bus(trans), base + (3 * sizeof(u32)));
-
-	if (capacity > logsize) {
-		IWL_ERR(trans, "Log capacity %d is bogus, limit to %d "
-			"entries\n", capacity, logsize);
-		capacity = logsize;
-	}
-
-	if (next_entry > logsize) {
-		IWL_ERR(trans, "Log write index %d is bogus, limit to %d\n",
-			next_entry, logsize);
-		next_entry = logsize;
-	}
-
-	size = num_wraps ? capacity : next_entry;
-
-	/* bail out if nothing in log */
-	if (size == 0) {
-		IWL_ERR(trans, "Start IWL Event Log Dump: nothing in log\n");
-		return pos;
-	}
-
-#ifdef CONFIG_IWLWIFI_DEBUG
-	if (!(iwl_get_debug_level(trans->shrd) & IWL_DL_FW_ERRORS) && !full_log)
-		size = (size > DEFAULT_DUMP_EVENT_LOG_ENTRIES)
-			? DEFAULT_DUMP_EVENT_LOG_ENTRIES : size;
-#else
-	size = (size > DEFAULT_DUMP_EVENT_LOG_ENTRIES)
-		? DEFAULT_DUMP_EVENT_LOG_ENTRIES : size;
-#endif
-	IWL_ERR(trans, "Start IWL Event Log Dump: display last %u entries\n",
-		size);
-
-#ifdef CONFIG_IWLWIFI_DEBUG
-	if (display) {
-		if (full_log)
-			bufsz = capacity * 48;
-		else
-			bufsz = size * 48;
-		*buf = kmalloc(bufsz, GFP_KERNEL);
-		if (!*buf)
-			return -ENOMEM;
-	}
-	if ((iwl_get_debug_level(trans->shrd) & IWL_DL_FW_ERRORS) || full_log) {
-		/*
-		 * if uCode has wrapped back to top of log,
-		 * start at the oldest entry,
-		 * i.e the next one that uCode would fill.
-		 */
-		if (num_wraps)
-			pos = iwl_print_event_log(trans, next_entry,
-						capacity - next_entry, mode,
-						pos, buf, bufsz);
-		/* (then/else) start at top of log */
-		pos = iwl_print_event_log(trans, 0,
-					  next_entry, mode, pos, buf, bufsz);
-	} else
-		pos = iwl_print_last_event_logs(trans, capacity, num_wraps,
-						next_entry, size, mode,
-						pos, buf, bufsz);
-#else
-	pos = iwl_print_last_event_logs(trans, capacity, num_wraps,
-					next_entry, size, mode,
-					pos, buf, bufsz);
-#endif
-	return pos;
-}
-
-/* tasklet for iwlagn interrupt */
-void iwl_irq_tasklet(struct iwl_trans *trans)
-{
-	u32 inta = 0;
-	u32 handled = 0;
-	unsigned long flags;
-	u32 i;
-#ifdef CONFIG_IWLWIFI_DEBUG
-	u32 inta_mask;
-#endif
-
-	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-	struct isr_statistics *isr_stats = &trans_pcie->isr_stats;
-
-
-	spin_lock_irqsave(&trans->shrd->lock, flags);
-
-	/* Ack/clear/reset pending uCode interrupts.
-	 * Note:  Some bits in CSR_INT are "OR" of bits in CSR_FH_INT_STATUS,
-	 */
-	/* There is a hardware bug in the interrupt mask function that some
-	 * interrupts (i.e. CSR_INT_BIT_SCD) can still be generated even if
-	 * they are disabled in the CSR_INT_MASK register. Furthermore the
-	 * ICT interrupt handling mechanism has another bug that might cause
-	 * these unmasked interrupts fail to be detected. We workaround the
-	 * hardware bugs here by ACKing all the possible interrupts so that
-	 * interrupt coalescing can still be achieved.
-	 */
-	iwl_write32(bus(trans), CSR_INT,
-		trans_pcie->inta | ~trans_pcie->inta_mask);
-
-	inta = trans_pcie->inta;
-
-#ifdef CONFIG_IWLWIFI_DEBUG
-	if (iwl_get_debug_level(trans->shrd) & IWL_DL_ISR) {
-		/* just for debug */
-		inta_mask = iwl_read32(bus(trans), CSR_INT_MASK);
-		IWL_DEBUG_ISR(trans, "inta 0x%08x, enabled 0x%08x\n ",
-				inta, inta_mask);
-	}
-#endif
-
-	spin_unlock_irqrestore(&trans->shrd->lock, flags);
-
-	/* saved interrupt in inta variable now we can reset trans_pcie->inta */
-	trans_pcie->inta = 0;
-
-	/* Now service all interrupt bits discovered above. */
-	if (inta & CSR_INT_BIT_HW_ERR) {
-		IWL_ERR(trans, "Hardware error detected.  Restarting.\n");
-
-		/* Tell the device to stop sending interrupts */
-		iwl_disable_interrupts(trans);
-
-		isr_stats->hw++;
-		iwl_irq_handle_error(trans);
-
-		handled |= CSR_INT_BIT_HW_ERR;
-
-		return;
-	}
-
-#ifdef CONFIG_IWLWIFI_DEBUG
-	if (iwl_get_debug_level(trans->shrd) & (IWL_DL_ISR)) {
-		/* NIC fires this, but we don't use it, redundant with WAKEUP */
-		if (inta & CSR_INT_BIT_SCD) {
-			IWL_DEBUG_ISR(trans, "Scheduler finished to transmit "
-				      "the frame/frames.\n");
-			isr_stats->sch++;
-		}
-
-		/* Alive notification via Rx interrupt will do the real work */
-		if (inta & CSR_INT_BIT_ALIVE) {
-			IWL_DEBUG_ISR(trans, "Alive interrupt\n");
-			isr_stats->alive++;
-		}
-	}
-#endif
-	/* Safely ignore these bits for debug checks below */
-	inta &= ~(CSR_INT_BIT_SCD | CSR_INT_BIT_ALIVE);
-
-	/* HW RF KILL switch toggled */
-	if (inta & CSR_INT_BIT_RF_KILL) {
-		int hw_rf_kill = 0;
-		if (!(iwl_read32(bus(trans), CSR_GP_CNTRL) &
-				CSR_GP_CNTRL_REG_FLAG_HW_RF_KILL_SW))
-			hw_rf_kill = 1;
-
-		IWL_WARN(trans, "RF_KILL bit toggled to %s.\n",
-				hw_rf_kill ? "disable radio" : "enable radio");
-
-		isr_stats->rfkill++;
-
-		/* driver only loads ucode once setting the interface up.
-		 * the driver allows loading the ucode even if the radio
-		 * is killed. Hence update the killswitch state here. The
-		 * rfkill handler will care about restarting if needed.
-		 */
-		if (!test_bit(STATUS_ALIVE, &trans->shrd->status)) {
-			if (hw_rf_kill)
-				set_bit(STATUS_RF_KILL_HW,
-					&trans->shrd->status);
-			else
-				clear_bit(STATUS_RF_KILL_HW,
-					  &trans->shrd->status);
-			iwl_set_hw_rfkill_state(priv(trans), hw_rf_kill);
-		}
-
-		handled |= CSR_INT_BIT_RF_KILL;
-	}
-
-	/* Chip got too hot and stopped itself */
-	if (inta & CSR_INT_BIT_CT_KILL) {
-		IWL_ERR(trans, "Microcode CT kill error detected.\n");
-		isr_stats->ctkill++;
-		handled |= CSR_INT_BIT_CT_KILL;
-	}
-
-	/* Error detected by uCode */
-	if (inta & CSR_INT_BIT_SW_ERR) {
-		IWL_ERR(trans, "Microcode SW error detected. "
-			" Restarting 0x%X.\n", inta);
-		isr_stats->sw++;
-		iwl_irq_handle_error(trans);
-		handled |= CSR_INT_BIT_SW_ERR;
-	}
-
-	/* uCode wakes up after power-down sleep */
-	if (inta & CSR_INT_BIT_WAKEUP) {
-		IWL_DEBUG_ISR(trans, "Wakeup interrupt\n");
-		iwl_rx_queue_update_write_ptr(trans, &trans_pcie->rxq);
-		for (i = 0; i < hw_params(trans).max_txq_num; i++)
-			iwl_txq_update_write_ptr(trans,
-						 &trans_pcie->txq[i]);
-
-		isr_stats->wakeup++;
-
-		handled |= CSR_INT_BIT_WAKEUP;
-	}
-
-	/* All uCode command responses, including Tx command responses,
-	 * Rx "responses" (frame-received notification), and other
-	 * notifications from uCode come through here*/
-	if (inta & (CSR_INT_BIT_FH_RX | CSR_INT_BIT_SW_RX |
-			CSR_INT_BIT_RX_PERIODIC)) {
-		IWL_DEBUG_ISR(trans, "Rx interrupt\n");
-		if (inta & (CSR_INT_BIT_FH_RX | CSR_INT_BIT_SW_RX)) {
-			handled |= (CSR_INT_BIT_FH_RX | CSR_INT_BIT_SW_RX);
-			iwl_write32(bus(trans), CSR_FH_INT_STATUS,
-					CSR_FH_INT_RX_MASK);
-		}
-		if (inta & CSR_INT_BIT_RX_PERIODIC) {
-			handled |= CSR_INT_BIT_RX_PERIODIC;
-			iwl_write32(bus(trans),
-				CSR_INT, CSR_INT_BIT_RX_PERIODIC);
-		}
-		/* Sending RX interrupt require many steps to be done in the
-		 * the device:
-		 * 1- write interrupt to current index in ICT table.
-		 * 2- dma RX frame.
-		 * 3- update RX shared data to indicate last write index.
-		 * 4- send interrupt.
-		 * This could lead to RX race, driver could receive RX interrupt
-		 * but the shared data changes does not reflect this;
-		 * periodic interrupt will detect any dangling Rx activity.
-		 */
-
-		/* Disable periodic interrupt; we use it as just a one-shot. */
-		iwl_write8(bus(trans), CSR_INT_PERIODIC_REG,
-			    CSR_INT_PERIODIC_DIS);
-		iwl_rx_handle(trans);
-
-		/*
-		 * Enable periodic interrupt in 8 msec only if we received
-		 * real RX interrupt (instead of just periodic int), to catch
-		 * any dangling Rx interrupt.  If it was just the periodic
-		 * interrupt, there was no dangling Rx activity, and no need
-		 * to extend the periodic interrupt; one-shot is enough.
-		 */
-		if (inta & (CSR_INT_BIT_FH_RX | CSR_INT_BIT_SW_RX))
-			iwl_write8(bus(trans), CSR_INT_PERIODIC_REG,
-				    CSR_INT_PERIODIC_ENA);
-
-		isr_stats->rx++;
-	}
-
-	/* This "Tx" DMA channel is used only for loading uCode */
-	if (inta & CSR_INT_BIT_FH_TX) {
-		iwl_write32(bus(trans), CSR_FH_INT_STATUS, CSR_FH_INT_TX_MASK);
-		IWL_DEBUG_ISR(trans, "uCode load interrupt\n");
-		isr_stats->tx++;
-		handled |= CSR_INT_BIT_FH_TX;
-		/* Wake up uCode load routine, now that load is complete */
-		priv(trans)->ucode_write_complete = 1;
-		wake_up_interruptible(&trans->shrd->wait_command_queue);
-	}
-
-	if (inta & ~handled) {
-		IWL_ERR(trans, "Unhandled INTA bits 0x%08x\n", inta & ~handled);
-		isr_stats->unhandled++;
-	}
-
-	if (inta & ~(trans_pcie->inta_mask)) {
-		IWL_WARN(trans, "Disabled INTA bits 0x%08x were pending\n",
-			 inta & ~trans_pcie->inta_mask);
-	}
-
-	/* Re-enable all interrupts */
-	/* only Re-enable if disabled by irq */
-	if (test_bit(STATUS_INT_ENABLED, &trans->shrd->status))
-		iwl_enable_interrupts(trans);
-	/* Re-enable RF_KILL if it occurred */
-	else if (handled & CSR_INT_BIT_RF_KILL)
-		iwl_enable_rfkill_int(priv(trans));
-}
-
-/******************************************************************************
- *
- * ICT functions
- *
- ******************************************************************************/
-#define ICT_COUNT (PAGE_SIZE/sizeof(u32))
-
-/* Free dram table */
-void iwl_free_isr_ict(struct iwl_trans *trans)
-{
-	struct iwl_trans_pcie *trans_pcie =
-		IWL_TRANS_GET_PCIE_TRANS(trans);
-
-	if (trans_pcie->ict_tbl_vir) {
-		dma_free_coherent(bus(trans)->dev,
-				  (sizeof(u32) * ICT_COUNT) + PAGE_SIZE,
-				  trans_pcie->ict_tbl_vir,
-				  trans_pcie->ict_tbl_dma);
-		trans_pcie->ict_tbl_vir = NULL;
-		memset(&trans_pcie->ict_tbl_dma, 0,
-			sizeof(trans_pcie->ict_tbl_dma));
-		memset(&trans_pcie->aligned_ict_tbl_dma, 0,
-			sizeof(trans_pcie->aligned_ict_tbl_dma));
-	}
-}
-
-
-/* allocate dram shared table it is a PAGE_SIZE aligned
- * also reset all data related to ICT table interrupt.
- */
-int iwl_alloc_isr_ict(struct iwl_trans *trans)
-{
-	struct iwl_trans_pcie *trans_pcie =
-		IWL_TRANS_GET_PCIE_TRANS(trans);
-
-	/* allocate shrared data table */
-	trans_pcie->ict_tbl_vir =
-		dma_alloc_coherent(bus(trans)->dev,
-				   (sizeof(u32) * ICT_COUNT) + PAGE_SIZE,
-				   &trans_pcie->ict_tbl_dma, GFP_KERNEL);
-	if (!trans_pcie->ict_tbl_vir)
-		return -ENOMEM;
-
-	/* align table to PAGE_SIZE boundary */
-	trans_pcie->aligned_ict_tbl_dma =
-		ALIGN(trans_pcie->ict_tbl_dma, PAGE_SIZE);
-
-	IWL_DEBUG_ISR(trans, "ict dma addr %Lx dma aligned %Lx diff %d\n",
-			   (unsigned long long)trans_pcie->ict_tbl_dma,
-			   (unsigned long long)trans_pcie->aligned_ict_tbl_dma,
-			   (int)(trans_pcie->aligned_ict_tbl_dma -
-			   trans_pcie->ict_tbl_dma));
-
-	trans_pcie->ict_tbl =  trans_pcie->ict_tbl_vir +
-			  (trans_pcie->aligned_ict_tbl_dma -
-			  trans_pcie->ict_tbl_dma);
-
-	IWL_DEBUG_ISR(trans, "ict vir addr %p vir aligned %p diff %d\n",
-			     trans_pcie->ict_tbl, trans_pcie->ict_tbl_vir,
-			(int)(trans_pcie->aligned_ict_tbl_dma -
-			    trans_pcie->ict_tbl_dma));
-
-	/* reset table and index to all 0 */
-	memset(trans_pcie->ict_tbl_vir, 0,
-		(sizeof(u32) * ICT_COUNT) + PAGE_SIZE);
-	trans_pcie->ict_index = 0;
-
-	/* add periodic RX interrupt */
-	trans_pcie->inta_mask |= CSR_INT_BIT_RX_PERIODIC;
-	return 0;
-}
-
-/* Device is going up inform it about using ICT interrupt table,
- * also we need to tell the driver to start using ICT interrupt.
- */
-int iwl_reset_ict(struct iwl_trans *trans)
-{
-	u32 val;
-	unsigned long flags;
-	struct iwl_trans_pcie *trans_pcie =
-		IWL_TRANS_GET_PCIE_TRANS(trans);
-
-	if (!trans_pcie->ict_tbl_vir)
-		return 0;
-
-	spin_lock_irqsave(&trans->shrd->lock, flags);
-	iwl_disable_interrupts(trans);
-
-	memset(&trans_pcie->ict_tbl[0], 0, sizeof(u32) * ICT_COUNT);
-
-	val = trans_pcie->aligned_ict_tbl_dma >> PAGE_SHIFT;
-
-	val |= CSR_DRAM_INT_TBL_ENABLE;
-	val |= CSR_DRAM_INIT_TBL_WRAP_CHECK;
-
-	IWL_DEBUG_ISR(trans, "CSR_DRAM_INT_TBL_REG =0x%X "
-			"aligned dma address %Lx\n",
-			val,
-			(unsigned long long)trans_pcie->aligned_ict_tbl_dma);
-
-	iwl_write32(bus(trans), CSR_DRAM_INT_TBL_REG, val);
-	trans_pcie->use_ict = true;
-	trans_pcie->ict_index = 0;
-	iwl_write32(bus(trans), CSR_INT, trans_pcie->inta_mask);
-	iwl_enable_interrupts(trans);
-	spin_unlock_irqrestore(&trans->shrd->lock, flags);
-
-	return 0;
-}
-
-/* Device is going down disable ict interrupt usage */
-void iwl_disable_ict(struct iwl_trans *trans)
-{
-	struct iwl_trans_pcie *trans_pcie =
-		IWL_TRANS_GET_PCIE_TRANS(trans);
-
-	unsigned long flags;
-
-	spin_lock_irqsave(&trans->shrd->lock, flags);
-	trans_pcie->use_ict = false;
-	spin_unlock_irqrestore(&trans->shrd->lock, flags);
-}
-
-static irqreturn_t iwl_isr(int irq, void *data)
-{
-	struct iwl_trans *trans = data;
-	struct iwl_trans_pcie *trans_pcie;
-	u32 inta, inta_mask;
-	unsigned long flags;
-#ifdef CONFIG_IWLWIFI_DEBUG
-	u32 inta_fh;
-#endif
-	if (!trans)
-		return IRQ_NONE;
-
-	trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-
-	spin_lock_irqsave(&trans->shrd->lock, flags);
-
-	/* Disable (but don't clear!) interrupts here to avoid
-	 *    back-to-back ISRs and sporadic interrupts from our NIC.
-	 * If we have something to service, the tasklet will re-enable ints.
-	 * If we *don't* have something, we'll re-enable before leaving here. */
-	inta_mask = iwl_read32(bus(trans), CSR_INT_MASK);  /* just for debug */
-	iwl_write32(bus(trans), CSR_INT_MASK, 0x00000000);
-
-	/* Discover which interrupts are active/pending */
-	inta = iwl_read32(bus(trans), CSR_INT);
-
-	/* Ignore interrupt if there's nothing in NIC to service.
-	 * This may be due to IRQ shared with another device,
-	 * or due to sporadic interrupts thrown from our NIC. */
-	if (!inta) {
-		IWL_DEBUG_ISR(trans, "Ignore interrupt, inta == 0\n");
-		goto none;
-	}
-
-	if ((inta == 0xFFFFFFFF) || ((inta & 0xFFFFFFF0) == 0xa5a5a5a0)) {
-		/* Hardware disappeared. It might have already raised
-		 * an interrupt */
-		IWL_WARN(trans, "HARDWARE GONE?? INTA == 0x%08x\n", inta);
-		goto unplugged;
-	}
-
-#ifdef CONFIG_IWLWIFI_DEBUG
-	if (iwl_get_debug_level(trans->shrd) & (IWL_DL_ISR)) {
-		inta_fh = iwl_read32(bus(trans), CSR_FH_INT_STATUS);
-		IWL_DEBUG_ISR(trans, "ISR inta 0x%08x, enabled 0x%08x, "
-			      "fh 0x%08x\n", inta, inta_mask, inta_fh);
-	}
-#endif
-
-	trans_pcie->inta |= inta;
-	/* iwl_irq_tasklet() will service interrupts and re-enable them */
-	if (likely(inta))
-		tasklet_schedule(&trans_pcie->irq_tasklet);
-	else if (test_bit(STATUS_INT_ENABLED, &trans->shrd->status) &&
-			!trans_pcie->inta)
-		iwl_enable_interrupts(trans);
-
- unplugged:
-	spin_unlock_irqrestore(&trans->shrd->lock, flags);
-	return IRQ_HANDLED;
-
- none:
-	/* re-enable interrupts here since we don't have anything to service. */
-	/* only Re-enable if disabled by irq  and no schedules tasklet. */
-	if (test_bit(STATUS_INT_ENABLED, &trans->shrd->status) &&
-		!trans_pcie->inta)
-		iwl_enable_interrupts(trans);
-
-	spin_unlock_irqrestore(&trans->shrd->lock, flags);
-	return IRQ_NONE;
-}
-
-/* interrupt handler using ict table, with this interrupt driver will
- * stop using INTA register to get device's interrupt, reading this register
- * is expensive, device will write interrupts in ICT dram table, increment
- * index then will fire interrupt to driver, driver will OR all ICT table
- * entries from current index up to table entry with 0 value. the result is
- * the interrupt we need to service, driver will set the entries back to 0 and
- * set index.
- */
-irqreturn_t iwl_isr_ict(int irq, void *data)
-{
-	struct iwl_trans *trans = data;
-	struct iwl_trans_pcie *trans_pcie;
-	u32 inta, inta_mask;
-	u32 val = 0;
-	unsigned long flags;
-
-	if (!trans)
-		return IRQ_NONE;
-
-	trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-
-	/* dram interrupt table not set yet,
-	 * use legacy interrupt.
-	 */
-	if (!trans_pcie->use_ict)
-		return iwl_isr(irq, data);
-
-	spin_lock_irqsave(&trans->shrd->lock, flags);
-
-	/* Disable (but don't clear!) interrupts here to avoid
-	 * back-to-back ISRs and sporadic interrupts from our NIC.
-	 * If we have something to service, the tasklet will re-enable ints.
-	 * If we *don't* have something, we'll re-enable before leaving here.
-	 */
-	inta_mask = iwl_read32(bus(trans), CSR_INT_MASK);  /* just for debug */
-	iwl_write32(bus(trans), CSR_INT_MASK, 0x00000000);
-
-
-	/* Ignore interrupt if there's nothing in NIC to service.
-	 * This may be due to IRQ shared with another device,
-	 * or due to sporadic interrupts thrown from our NIC. */
-	if (!trans_pcie->ict_tbl[trans_pcie->ict_index]) {
-		IWL_DEBUG_ISR(trans, "Ignore interrupt, inta == 0\n");
-		goto none;
-	}
-
-	/* read all entries that not 0 start with ict_index */
-	while (trans_pcie->ict_tbl[trans_pcie->ict_index]) {
-
-		val |= le32_to_cpu(trans_pcie->ict_tbl[trans_pcie->ict_index]);
-		IWL_DEBUG_ISR(trans, "ICT index %d value 0x%08X\n",
-				trans_pcie->ict_index,
-				le32_to_cpu(
-				  trans_pcie->ict_tbl[trans_pcie->ict_index]));
-		trans_pcie->ict_tbl[trans_pcie->ict_index] = 0;
-		trans_pcie->ict_index =
-			iwl_queue_inc_wrap(trans_pcie->ict_index, ICT_COUNT);
-
-	}
-
-	/* We should not get this value, just ignore it. */
-	if (val == 0xffffffff)
-		val = 0;
-
-	/*
-	 * this is a w/a for a h/w bug. the h/w bug may cause the Rx bit
-	 * (bit 15 before shifting it to 31) to clear when using interrupt
-	 * coalescing. fortunately, bits 18 and 19 stay set when this happens
-	 * so we use them to decide on the real state of the Rx bit.
-	 * In order words, bit 15 is set if bit 18 or bit 19 are set.
-	 */
-	if (val & 0xC0000)
-		val |= 0x8000;
-
-	inta = (0xff & val) | ((0xff00 & val) << 16);
-	IWL_DEBUG_ISR(trans, "ISR inta 0x%08x, enabled 0x%08x ict 0x%08x\n",
-			inta, inta_mask, val);
-
-	inta &= trans_pcie->inta_mask;
-	trans_pcie->inta |= inta;
-
-	/* iwl_irq_tasklet() will service interrupts and re-enable them */
-	if (likely(inta))
-		tasklet_schedule(&trans_pcie->irq_tasklet);
-	else if (test_bit(STATUS_INT_ENABLED, &trans->shrd->status) &&
-			!trans_pcie->inta) {
-		/* Allow interrupt if was disabled by this handler and
-		 * no tasklet was schedules, We should not enable interrupt,
-		 * tasklet will enable it.
-		 */
-		iwl_enable_interrupts(trans);
-	}
-
-	spin_unlock_irqrestore(&trans->shrd->lock, flags);
-	return IRQ_HANDLED;
-
- none:
-	/* re-enable interrupts here since we don't have anything to service.
-	 * only Re-enable if disabled by irq.
-	 */
-	if (test_bit(STATUS_INT_ENABLED, &trans->shrd->status) &&
-		!trans_pcie->inta)
-		iwl_enable_interrupts(trans);
-
-	spin_unlock_irqrestore(&trans->shrd->lock, flags);
-	return IRQ_NONE;
-}
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c
deleted file mode 100644
index 15cb0ff..0000000
--- a/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c
+++ /dev/null
@@ -1,1165 +0,0 @@
-/******************************************************************************
- *
- * Copyright(c) 2003 - 2011 Intel Corporation. All rights reserved.
- *
- * Portions of this file are derived from the ipw3945 project, as well
- * as portions of the ieee80211 subsystem header files.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of version 2 of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- * more details.
- *
- * You should have received a copy of the GNU General Public License along with
- * this program; if not, write to the Free Software Foundation, Inc.,
- * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
- *
- * The full GNU General Public License is included in this distribution in the
- * file called LICENSE.
- *
- * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
- * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
- *
- *****************************************************************************/
-#include <linux/etherdevice.h>
-#include <linux/slab.h>
-#include <linux/sched.h>
-
-/* TODO: remove include to iwl-dev.h */
-#include "iwl-dev.h"
-#include "iwl-debug.h"
-#include "iwl-csr.h"
-#include "iwl-prph.h"
-#include "iwl-io.h"
-#include "iwl-agn-hw.h"
-#include "iwl-helpers.h"
-#include "iwl-trans-int-pcie.h"
-
-#define IWL_TX_CRC_SIZE 4
-#define IWL_TX_DELIMITER_SIZE 4
-
-/**
- * iwl_trans_txq_update_byte_cnt_tbl - Set up entry in Tx byte-count array
- */
-void iwl_trans_txq_update_byte_cnt_tbl(struct iwl_trans *trans,
-					   struct iwl_tx_queue *txq,
-					   u16 byte_cnt)
-{
-	struct iwlagn_scd_bc_tbl *scd_bc_tbl;
-	struct iwl_trans_pcie *trans_pcie =
-		IWL_TRANS_GET_PCIE_TRANS(trans);
-	int write_ptr = txq->q.write_ptr;
-	int txq_id = txq->q.id;
-	u8 sec_ctl = 0;
-	u8 sta_id = 0;
-	u16 len = byte_cnt + IWL_TX_CRC_SIZE + IWL_TX_DELIMITER_SIZE;
-	__le16 bc_ent;
-
-	scd_bc_tbl = trans_pcie->scd_bc_tbls.addr;
-
-	WARN_ON(len > 0xFFF || write_ptr >= TFD_QUEUE_SIZE_MAX);
-
-	sta_id = txq->cmd[txq->q.write_ptr]->cmd.tx.sta_id;
-	sec_ctl = txq->cmd[txq->q.write_ptr]->cmd.tx.sec_ctl;
-
-	switch (sec_ctl & TX_CMD_SEC_MSK) {
-	case TX_CMD_SEC_CCM:
-		len += CCMP_MIC_LEN;
-		break;
-	case TX_CMD_SEC_TKIP:
-		len += TKIP_ICV_LEN;
-		break;
-	case TX_CMD_SEC_WEP:
-		len += WEP_IV_LEN + WEP_ICV_LEN;
-		break;
-	}
-
-	bc_ent = cpu_to_le16((len & 0xFFF) | (sta_id << 12));
-
-	scd_bc_tbl[txq_id].tfd_offset[write_ptr] = bc_ent;
-
-	if (write_ptr < TFD_QUEUE_SIZE_BC_DUP)
-		scd_bc_tbl[txq_id].
-			tfd_offset[TFD_QUEUE_SIZE_MAX + write_ptr] = bc_ent;
-}
-
-/**
- * iwl_txq_update_write_ptr - Send new write index to hardware
- */
-void iwl_txq_update_write_ptr(struct iwl_trans *trans, struct iwl_tx_queue *txq)
-{
-	u32 reg = 0;
-	int txq_id = txq->q.id;
-
-	if (txq->need_update == 0)
-		return;
-
-	if (hw_params(trans).shadow_reg_enable) {
-		/* shadow register enabled */
-		iwl_write32(bus(trans), HBUS_TARG_WRPTR,
-			    txq->q.write_ptr | (txq_id << 8));
-	} else {
-		/* if we're trying to save power */
-		if (test_bit(STATUS_POWER_PMI, &trans->shrd->status)) {
-			/* wake up nic if it's powered down ...
-			 * uCode will wake up, and interrupt us again, so next
-			 * time we'll skip this part. */
-			reg = iwl_read32(bus(trans), CSR_UCODE_DRV_GP1);
-
-			if (reg & CSR_UCODE_DRV_GP1_BIT_MAC_SLEEP) {
-				IWL_DEBUG_INFO(trans,
-					"Tx queue %d requesting wakeup,"
-					" GP1 = 0x%x\n", txq_id, reg);
-				iwl_set_bit(bus(trans), CSR_GP_CNTRL,
-					CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
-				return;
-			}
-
-			iwl_write_direct32(bus(trans), HBUS_TARG_WRPTR,
-				     txq->q.write_ptr | (txq_id << 8));
-
-		/*
-		 * else not in power-save mode,
-		 * uCode will never sleep when we're
-		 * trying to tx (during RFKILL, we're not trying to tx).
-		 */
-		} else
-			iwl_write32(bus(trans), HBUS_TARG_WRPTR,
-				    txq->q.write_ptr | (txq_id << 8));
-	}
-	txq->need_update = 0;
-}
-
-static inline dma_addr_t iwl_tfd_tb_get_addr(struct iwl_tfd *tfd, u8 idx)
-{
-	struct iwl_tfd_tb *tb = &tfd->tbs[idx];
-
-	dma_addr_t addr = get_unaligned_le32(&tb->lo);
-	if (sizeof(dma_addr_t) > sizeof(u32))
-		addr |=
-		((dma_addr_t)(le16_to_cpu(tb->hi_n_len) & 0xF) << 16) << 16;
-
-	return addr;
-}
-
-static inline u16 iwl_tfd_tb_get_len(struct iwl_tfd *tfd, u8 idx)
-{
-	struct iwl_tfd_tb *tb = &tfd->tbs[idx];
-
-	return le16_to_cpu(tb->hi_n_len) >> 4;
-}
-
-static inline void iwl_tfd_set_tb(struct iwl_tfd *tfd, u8 idx,
-				  dma_addr_t addr, u16 len)
-{
-	struct iwl_tfd_tb *tb = &tfd->tbs[idx];
-	u16 hi_n_len = len << 4;
-
-	put_unaligned_le32(addr, &tb->lo);
-	if (sizeof(dma_addr_t) > sizeof(u32))
-		hi_n_len |= ((addr >> 16) >> 16) & 0xF;
-
-	tb->hi_n_len = cpu_to_le16(hi_n_len);
-
-	tfd->num_tbs = idx + 1;
-}
-
-static inline u8 iwl_tfd_get_num_tbs(struct iwl_tfd *tfd)
-{
-	return tfd->num_tbs & 0x1f;
-}
-
-static void iwlagn_unmap_tfd(struct iwl_trans *trans, struct iwl_cmd_meta *meta,
-		     struct iwl_tfd *tfd, enum dma_data_direction dma_dir)
-{
-	int i;
-	int num_tbs;
-
-	/* Sanity check on number of chunks */
-	num_tbs = iwl_tfd_get_num_tbs(tfd);
-
-	if (num_tbs >= IWL_NUM_OF_TBS) {
-		IWL_ERR(trans, "Too many chunks: %i\n", num_tbs);
-		/* @todo issue fatal error, it is quite serious situation */
-		return;
-	}
-
-	/* Unmap tx_cmd */
-	if (num_tbs)
-		dma_unmap_single(bus(trans)->dev,
-				dma_unmap_addr(meta, mapping),
-				dma_unmap_len(meta, len),
-				DMA_BIDIRECTIONAL);
-
-	/* Unmap chunks, if any. */
-	for (i = 1; i < num_tbs; i++)
-		dma_unmap_single(bus(trans)->dev, iwl_tfd_tb_get_addr(tfd, i),
-				iwl_tfd_tb_get_len(tfd, i), dma_dir);
-}
-
-/**
- * iwlagn_txq_free_tfd - Free all chunks referenced by TFD [txq->q.read_ptr]
- * @trans - transport private data
- * @txq - tx queue
- * @index - the index of the TFD to be freed
- *@dma_dir - the direction of the DMA mapping
- *
- * Does NOT advance any TFD circular buffer read/write indexes
- * Does NOT free the TFD itself (which is within circular buffer)
- */
-void iwlagn_txq_free_tfd(struct iwl_trans *trans, struct iwl_tx_queue *txq,
-	int index, enum dma_data_direction dma_dir)
-{
-	struct iwl_tfd *tfd_tmp = txq->tfds;
-
-	iwlagn_unmap_tfd(trans, &txq->meta[index], &tfd_tmp[index], dma_dir);
-
-	/* free SKB */
-	if (txq->skbs) {
-		struct sk_buff *skb;
-
-		skb = txq->skbs[index];
-
-		/* Can be called from irqs-disabled context
-		 * If skb is not NULL, it means that the whole queue is being
-		 * freed and that the queue is not empty - free the skb
-		 */
-		if (skb) {
-			iwl_free_skb(priv(trans), skb);
-			txq->skbs[index] = NULL;
-		}
-	}
-}
-
-int iwlagn_txq_attach_buf_to_tfd(struct iwl_trans *trans,
-				 struct iwl_tx_queue *txq,
-				 dma_addr_t addr, u16 len,
-				 u8 reset)
-{
-	struct iwl_queue *q;
-	struct iwl_tfd *tfd, *tfd_tmp;
-	u32 num_tbs;
-
-	q = &txq->q;
-	tfd_tmp = txq->tfds;
-	tfd = &tfd_tmp[q->write_ptr];
-
-	if (reset)
-		memset(tfd, 0, sizeof(*tfd));
-
-	num_tbs = iwl_tfd_get_num_tbs(tfd);
-
-	/* Each TFD can point to a maximum 20 Tx buffers */
-	if (num_tbs >= IWL_NUM_OF_TBS) {
-		IWL_ERR(trans, "Error can not send more than %d chunks\n",
-			  IWL_NUM_OF_TBS);
-		return -EINVAL;
-	}
-
-	if (WARN_ON(addr & ~DMA_BIT_MASK(36)))
-		return -EINVAL;
-
-	if (unlikely(addr & ~IWL_TX_DMA_MASK))
-		IWL_ERR(trans, "Unaligned address = %llx\n",
-			  (unsigned long long)addr);
-
-	iwl_tfd_set_tb(tfd, num_tbs, addr, len);
-
-	return 0;
-}
-
-/*************** DMA-QUEUE-GENERAL-FUNCTIONS  *****
- * DMA services
- *
- * Theory of operation
- *
- * A Tx or Rx queue resides in host DRAM, and is comprised of a circular buffer
- * of buffer descriptors, each of which points to one or more data buffers for
- * the device to read from or fill.  Driver and device exchange status of each
- * queue via "read" and "write" pointers.  Driver keeps minimum of 2 empty
- * entries in each circular buffer, to protect against confusing empty and full
- * queue states.
- *
- * The device reads or writes the data in the queues via the device's several
- * DMA/FIFO channels.  Each queue is mapped to a single DMA channel.
- *
- * For Tx queue, there are low mark and high mark limits. If, after queuing
- * the packet for Tx, free space become < low mark, Tx queue stopped. When
- * reclaiming packets (on 'tx done IRQ), if free space become > high mark,
- * Tx queue resumed.
- *
- ***************************************************/
-
-int iwl_queue_space(const struct iwl_queue *q)
-{
-	int s = q->read_ptr - q->write_ptr;
-
-	if (q->read_ptr > q->write_ptr)
-		s -= q->n_bd;
-
-	if (s <= 0)
-		s += q->n_window;
-	/* keep some reserve to not confuse empty and full situations */
-	s -= 2;
-	if (s < 0)
-		s = 0;
-	return s;
-}
-
-/**
- * iwl_queue_init - Initialize queue's high/low-water and read/write indexes
- */
-int iwl_queue_init(struct iwl_queue *q, int count, int slots_num, u32 id)
-{
-	q->n_bd = count;
-	q->n_window = slots_num;
-	q->id = id;
-
-	/* count must be power-of-two size, otherwise iwl_queue_inc_wrap
-	 * and iwl_queue_dec_wrap are broken. */
-	if (WARN_ON(!is_power_of_2(count)))
-		return -EINVAL;
-
-	/* slots_num must be power-of-two size, otherwise
-	 * get_cmd_index is broken. */
-	if (WARN_ON(!is_power_of_2(slots_num)))
-		return -EINVAL;
-
-	q->low_mark = q->n_window / 4;
-	if (q->low_mark < 4)
-		q->low_mark = 4;
-
-	q->high_mark = q->n_window / 8;
-	if (q->high_mark < 2)
-		q->high_mark = 2;
-
-	q->write_ptr = q->read_ptr = 0;
-
-	return 0;
-}
-
-static void iwlagn_txq_inval_byte_cnt_tbl(struct iwl_trans *trans,
-					  struct iwl_tx_queue *txq)
-{
-	struct iwl_trans_pcie *trans_pcie =
-		IWL_TRANS_GET_PCIE_TRANS(trans);
-	struct iwlagn_scd_bc_tbl *scd_bc_tbl = trans_pcie->scd_bc_tbls.addr;
-	int txq_id = txq->q.id;
-	int read_ptr = txq->q.read_ptr;
-	u8 sta_id = 0;
-	__le16 bc_ent;
-
-	WARN_ON(read_ptr >= TFD_QUEUE_SIZE_MAX);
-
-	if (txq_id != trans->shrd->cmd_queue)
-		sta_id = txq->cmd[read_ptr]->cmd.tx.sta_id;
-
-	bc_ent = cpu_to_le16(1 | (sta_id << 12));
-	scd_bc_tbl[txq_id].tfd_offset[read_ptr] = bc_ent;
-
-	if (read_ptr < TFD_QUEUE_SIZE_BC_DUP)
-		scd_bc_tbl[txq_id].
-			tfd_offset[TFD_QUEUE_SIZE_MAX + read_ptr] = bc_ent;
-}
-
-static int iwlagn_tx_queue_set_q2ratid(struct iwl_trans *trans, u16 ra_tid,
-					u16 txq_id)
-{
-	u32 tbl_dw_addr;
-	u32 tbl_dw;
-	u16 scd_q2ratid;
-
-	struct iwl_trans_pcie *trans_pcie =
-		IWL_TRANS_GET_PCIE_TRANS(trans);
-
-	scd_q2ratid = ra_tid & SCD_QUEUE_RA_TID_MAP_RATID_MSK;
-
-	tbl_dw_addr = trans_pcie->scd_base_addr +
-			SCD_TRANS_TBL_OFFSET_QUEUE(txq_id);
-
-	tbl_dw = iwl_read_targ_mem(bus(trans), tbl_dw_addr);
-
-	if (txq_id & 0x1)
-		tbl_dw = (scd_q2ratid << 16) | (tbl_dw & 0x0000FFFF);
-	else
-		tbl_dw = scd_q2ratid | (tbl_dw & 0xFFFF0000);
-
-	iwl_write_targ_mem(bus(trans), tbl_dw_addr, tbl_dw);
-
-	return 0;
-}
-
-static void iwlagn_tx_queue_stop_scheduler(struct iwl_trans *trans, u16 txq_id)
-{
-	/* Simply stop the queue, but don't change any configuration;
-	 * the SCD_ACT_EN bit is the write-enable mask for the ACTIVE bit. */
-	iwl_write_prph(bus(trans),
-		SCD_QUEUE_STATUS_BITS(txq_id),
-		(0 << SCD_QUEUE_STTS_REG_POS_ACTIVE)|
-		(1 << SCD_QUEUE_STTS_REG_POS_SCD_ACT_EN));
-}
-
-void iwl_trans_set_wr_ptrs(struct iwl_trans *trans,
-				int txq_id, u32 index)
-{
-	iwl_write_direct32(bus(trans), HBUS_TARG_WRPTR,
-			(index & 0xff) | (txq_id << 8));
-	iwl_write_prph(bus(trans), SCD_QUEUE_RDPTR(txq_id), index);
-}
-
-void iwl_trans_tx_queue_set_status(struct iwl_trans *trans,
-					struct iwl_tx_queue *txq,
-					int tx_fifo_id, int scd_retry)
-{
-	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-	int txq_id = txq->q.id;
-	int active =
-		test_bit(txq_id, &trans_pcie->txq_ctx_active_msk) ? 1 : 0;
-
-	iwl_write_prph(bus(trans), SCD_QUEUE_STATUS_BITS(txq_id),
-			(active << SCD_QUEUE_STTS_REG_POS_ACTIVE) |
-			(tx_fifo_id << SCD_QUEUE_STTS_REG_POS_TXF) |
-			(1 << SCD_QUEUE_STTS_REG_POS_WSL) |
-			SCD_QUEUE_STTS_REG_MSK);
-
-	txq->sched_retry = scd_retry;
-
-	IWL_DEBUG_INFO(trans, "%s %s Queue %d on FIFO %d\n",
-		       active ? "Activate" : "Deactivate",
-		       scd_retry ? "BA" : "AC/CMD", txq_id, tx_fifo_id);
-}
-
-static inline int get_fifo_from_tid(struct iwl_trans_pcie *trans_pcie,
-				    u8 ctx, u16 tid)
-{
-	const u8 *ac_to_fifo = trans_pcie->ac_to_fifo[ctx];
-	if (likely(tid < ARRAY_SIZE(tid_to_ac)))
-		return ac_to_fifo[tid_to_ac[tid]];
-
-	/* no support for TIDs 8-15 yet */
-	return -EINVAL;
-}
-
-void iwl_trans_pcie_tx_agg_setup(struct iwl_trans *trans,
-				 enum iwl_rxon_context_id ctx, int sta_id,
-				 int tid, int frame_limit)
-{
-	int tx_fifo, txq_id, ssn_idx;
-	u16 ra_tid;
-	unsigned long flags;
-	struct iwl_tid_data *tid_data;
-
-	struct iwl_trans_pcie *trans_pcie =
-		IWL_TRANS_GET_PCIE_TRANS(trans);
-
-	if (WARN_ON(sta_id == IWL_INVALID_STATION))
-		return;
-	if (WARN_ON(tid >= IWL_MAX_TID_COUNT))
-		return;
-
-	tx_fifo = get_fifo_from_tid(trans_pcie, ctx, tid);
-	if (WARN_ON(tx_fifo < 0)) {
-		IWL_ERR(trans, "txq_agg_setup, bad fifo: %d\n", tx_fifo);
-		return;
-	}
-
-	spin_lock_irqsave(&trans->shrd->sta_lock, flags);
-	tid_data = &trans->shrd->tid_data[sta_id][tid];
-	ssn_idx = SEQ_TO_SN(tid_data->seq_number);
-	txq_id = tid_data->agg.txq_id;
-	spin_unlock_irqrestore(&trans->shrd->sta_lock, flags);
-
-	ra_tid = BUILD_RAxTID(sta_id, tid);
-
-	spin_lock_irqsave(&trans->shrd->lock, flags);
-
-	/* Stop this Tx queue before configuring it */
-	iwlagn_tx_queue_stop_scheduler(trans, txq_id);
-
-	/* Map receiver-address / traffic-ID to this queue */
-	iwlagn_tx_queue_set_q2ratid(trans, ra_tid, txq_id);
-
-	/* Set this queue as a chain-building queue */
-	iwl_set_bits_prph(bus(trans), SCD_QUEUECHAIN_SEL, (1<<txq_id));
-
-	/* enable aggregations for the queue */
-	iwl_set_bits_prph(bus(trans), SCD_AGGR_SEL, (1<<txq_id));
-
-	/* Place first TFD at index corresponding to start sequence number.
-	 * Assumes that ssn_idx is valid (!= 0xFFF) */
-	trans_pcie->txq[txq_id].q.read_ptr = (ssn_idx & 0xff);
-	trans_pcie->txq[txq_id].q.write_ptr = (ssn_idx & 0xff);
-	iwl_trans_set_wr_ptrs(trans, txq_id, ssn_idx);
-
-	/* Set up Tx window size and frame limit for this queue */
-	iwl_write_targ_mem(bus(trans), trans_pcie->scd_base_addr +
-			SCD_CONTEXT_QUEUE_OFFSET(txq_id) +
-			sizeof(u32),
-			((frame_limit <<
-			SCD_QUEUE_CTX_REG2_WIN_SIZE_POS) &
-			SCD_QUEUE_CTX_REG2_WIN_SIZE_MSK) |
-			((frame_limit <<
-			SCD_QUEUE_CTX_REG2_FRAME_LIMIT_POS) &
-			SCD_QUEUE_CTX_REG2_FRAME_LIMIT_MSK));
-
-	iwl_set_bits_prph(bus(trans), SCD_INTERRUPT_MASK, (1 << txq_id));
-
-	/* Set up Status area in SRAM, map to Tx DMA/FIFO, activate the queue */
-	iwl_trans_tx_queue_set_status(trans, &trans_pcie->txq[txq_id],
-					tx_fifo, 1);
-
-	trans_pcie->txq[txq_id].sta_id = sta_id;
-	trans_pcie->txq[txq_id].tid = tid;
-
-	spin_unlock_irqrestore(&trans->shrd->lock, flags);
-}
-
-/*
- * Find first available (lowest unused) Tx Queue, mark it "active".
- * Called only when finding queue for aggregation.
- * Should never return anything < 7, because they should already
- * be in use as EDCA AC (0-3), Command (4), reserved (5, 6)
- */
-static int iwlagn_txq_ctx_activate_free(struct iwl_trans *trans)
-{
-	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-	int txq_id;
-
-	for (txq_id = 0; txq_id < hw_params(trans).max_txq_num; txq_id++)
-		if (!test_and_set_bit(txq_id,
-					&trans_pcie->txq_ctx_active_msk))
-			return txq_id;
-	return -1;
-}
-
-int iwl_trans_pcie_tx_agg_alloc(struct iwl_trans *trans,
-				enum iwl_rxon_context_id ctx, int sta_id,
-				int tid, u16 *ssn)
-{
-	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-	struct iwl_tid_data *tid_data;
-	unsigned long flags;
-	int txq_id;
-
-	txq_id = iwlagn_txq_ctx_activate_free(trans);
-	if (txq_id == -1) {
-		IWL_ERR(trans, "No free aggregation queue available\n");
-		return -ENXIO;
-	}
-
-	spin_lock_irqsave(&trans->shrd->sta_lock, flags);
-	tid_data = &trans->shrd->tid_data[sta_id][tid];
-	*ssn = SEQ_TO_SN(tid_data->seq_number);
-	tid_data->agg.txq_id = txq_id;
-	iwl_set_swq_id(&trans_pcie->txq[txq_id], get_ac_from_tid(tid), txq_id);
-
-	tid_data = &trans->shrd->tid_data[sta_id][tid];
-	if (tid_data->tfds_in_queue == 0) {
-		IWL_DEBUG_HT(trans, "HW queue is empty\n");
-		tid_data->agg.state = IWL_AGG_ON;
-		iwl_start_tx_ba_trans_ready(priv(trans), ctx, sta_id, tid);
-	} else {
-		IWL_DEBUG_HT(trans, "HW queue is NOT empty: %d packets in HW"
-			     "queue\n", tid_data->tfds_in_queue);
-		tid_data->agg.state = IWL_EMPTYING_HW_QUEUE_ADDBA;
-	}
-	spin_unlock_irqrestore(&trans->shrd->sta_lock, flags);
-
-	return 0;
-}
-
-void iwl_trans_pcie_txq_agg_disable(struct iwl_trans *trans, int txq_id)
-{
-	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-	iwlagn_tx_queue_stop_scheduler(trans, txq_id);
-
-	iwl_clear_bits_prph(bus(trans), SCD_AGGR_SEL, (1 << txq_id));
-
-	trans_pcie->txq[txq_id].q.read_ptr = 0;
-	trans_pcie->txq[txq_id].q.write_ptr = 0;
-	/* supposes that ssn_idx is valid (!= 0xFFF) */
-	iwl_trans_set_wr_ptrs(trans, txq_id, 0);
-
-	iwl_clear_bits_prph(bus(trans), SCD_INTERRUPT_MASK, (1 << txq_id));
-	iwl_txq_ctx_deactivate(trans_pcie, txq_id);
-	iwl_trans_tx_queue_set_status(trans, &trans_pcie->txq[txq_id], 0, 0);
-}
-
-int iwl_trans_pcie_tx_agg_disable(struct iwl_trans *trans,
-				  enum iwl_rxon_context_id ctx, int sta_id,
-				  int tid)
-{
-	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-	unsigned long flags;
-	int read_ptr, write_ptr;
-	struct iwl_tid_data *tid_data;
-	int txq_id;
-
-	spin_lock_irqsave(&trans->shrd->sta_lock, flags);
-
-	tid_data = &trans->shrd->tid_data[sta_id][tid];
-	txq_id = tid_data->agg.txq_id;
-
-	if ((IWLAGN_FIRST_AMPDU_QUEUE > txq_id) ||
-	    (IWLAGN_FIRST_AMPDU_QUEUE +
-		hw_params(trans).num_ampdu_queues <= txq_id)) {
-		IWL_ERR(trans,
-			"queue number out of range: %d, must be %d to %d\n",
-			txq_id, IWLAGN_FIRST_AMPDU_QUEUE,
-			IWLAGN_FIRST_AMPDU_QUEUE +
-			hw_params(trans).num_ampdu_queues - 1);
-		spin_unlock_irqrestore(&trans->shrd->sta_lock, flags);
-		return -EINVAL;
-	}
-
-	switch (trans->shrd->tid_data[sta_id][tid].agg.state) {
-	case IWL_EMPTYING_HW_QUEUE_ADDBA:
-		/*
-		* This can happen if the peer stops aggregation
-		* again before we've had a chance to drain the
-		* queue we selected previously, i.e. before the
-		* session was really started completely.
-		*/
-		IWL_DEBUG_HT(trans, "AGG stop before setup done\n");
-		goto turn_off;
-	case IWL_AGG_ON:
-		break;
-	default:
-		IWL_WARN(trans, "Stopping AGG while state not ON"
-				"or starting\n");
-	}
-
-	write_ptr = trans_pcie->txq[txq_id].q.write_ptr;
-	read_ptr = trans_pcie->txq[txq_id].q.read_ptr;
-
-	/* The queue is not empty */
-	if (write_ptr != read_ptr) {
-		IWL_DEBUG_HT(trans, "Stopping a non empty AGG HW QUEUE\n");
-		trans->shrd->tid_data[sta_id][tid].agg.state =
-			IWL_EMPTYING_HW_QUEUE_DELBA;
-		spin_unlock_irqrestore(&trans->shrd->sta_lock, flags);
-		return 0;
-	}
-
-	IWL_DEBUG_HT(trans, "HW queue is empty\n");
-turn_off:
-	trans->shrd->tid_data[sta_id][tid].agg.state = IWL_AGG_OFF;
-
-	/* do not restore/save irqs */
-	spin_unlock(&trans->shrd->sta_lock);
-	spin_lock(&trans->shrd->lock);
-
-	iwl_trans_pcie_txq_agg_disable(trans, txq_id);
-
-	spin_unlock_irqrestore(&trans->shrd->lock, flags);
-
-	iwl_stop_tx_ba_trans_ready(priv(trans), ctx, sta_id, tid);
-
-	return 0;
-}
-
-/*************** HOST COMMAND QUEUE FUNCTIONS   *****/
-
-/**
- * iwl_enqueue_hcmd - enqueue a uCode command
- * @priv: device private data point
- * @cmd: a point to the ucode command structure
- *
- * The function returns < 0 values to indicate the operation is
- * failed. On success, it turns the index (> 0) of command in the
- * command queue.
- */
-static int iwl_enqueue_hcmd(struct iwl_trans *trans, struct iwl_host_cmd *cmd)
-{
-	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-	struct iwl_tx_queue *txq = &trans_pcie->txq[trans->shrd->cmd_queue];
-	struct iwl_queue *q = &txq->q;
-	struct iwl_device_cmd *out_cmd;
-	struct iwl_cmd_meta *out_meta;
-	dma_addr_t phys_addr;
-	unsigned long flags;
-	u32 idx;
-	u16 copy_size, cmd_size;
-	bool is_ct_kill = false;
-	bool had_nocopy = false;
-	int i;
-	u8 *cmd_dest;
-#ifdef CONFIG_IWLWIFI_DEVICE_TRACING
-	const void *trace_bufs[IWL_MAX_CMD_TFDS + 1] = {};
-	int trace_lens[IWL_MAX_CMD_TFDS + 1] = {};
-	int trace_idx;
-#endif
-
-	if (test_bit(STATUS_FW_ERROR, &trans->shrd->status)) {
-		IWL_WARN(trans, "fw recovery, no hcmd send\n");
-		return -EIO;
-	}
-
-	if ((trans->shrd->ucode_owner == IWL_OWNERSHIP_TM) &&
-	    !(cmd->flags & CMD_ON_DEMAND)) {
-		IWL_DEBUG_HC(trans, "tm own the uCode, no regular hcmd send\n");
-		return -EIO;
-	}
-
-	copy_size = sizeof(out_cmd->hdr);
-	cmd_size = sizeof(out_cmd->hdr);
-
-	/* need one for the header if the first is NOCOPY */
-	BUILD_BUG_ON(IWL_MAX_CMD_TFDS > IWL_NUM_OF_TBS - 1);
-
-	for (i = 0; i < IWL_MAX_CMD_TFDS; i++) {
-		if (!cmd->len[i])
-			continue;
-		if (cmd->dataflags[i] & IWL_HCMD_DFL_NOCOPY) {
-			had_nocopy = true;
-		} else {
-			/* NOCOPY must not be followed by normal! */
-			if (WARN_ON(had_nocopy))
-				return -EINVAL;
-			copy_size += cmd->len[i];
-		}
-		cmd_size += cmd->len[i];
-	}
-
-	/*
-	 * If any of the command structures end up being larger than
-	 * the TFD_MAX_PAYLOAD_SIZE and they aren't dynamically
-	 * allocated into separate TFDs, then we will need to
-	 * increase the size of the buffers.
-	 */
-	if (WARN_ON(copy_size > TFD_MAX_PAYLOAD_SIZE))
-		return -EINVAL;
-
-	if (iwl_is_rfkill(trans->shrd) || iwl_is_ctkill(trans->shrd)) {
-		IWL_WARN(trans, "Not sending command - %s KILL\n",
-			 iwl_is_rfkill(trans->shrd) ? "RF" : "CT");
-		return -EIO;
-	}
-
-	spin_lock_irqsave(&trans->hcmd_lock, flags);
-
-	if (iwl_queue_space(q) < ((cmd->flags & CMD_ASYNC) ? 2 : 1)) {
-		spin_unlock_irqrestore(&trans->hcmd_lock, flags);
-
-		IWL_ERR(trans, "No space in command queue\n");
-		is_ct_kill = iwl_check_for_ct_kill(priv(trans));
-		if (!is_ct_kill) {
-			IWL_ERR(trans, "Restarting adapter queue is full\n");
-			iwlagn_fw_error(priv(trans), false);
-		}
-		return -ENOSPC;
-	}
-
-	idx = get_cmd_index(q, q->write_ptr);
-	out_cmd = txq->cmd[idx];
-	out_meta = &txq->meta[idx];
-
-	memset(out_meta, 0, sizeof(*out_meta));	/* re-initialize to NULL */
-	if (cmd->flags & CMD_WANT_SKB)
-		out_meta->source = cmd;
-	if (cmd->flags & CMD_ASYNC)
-		out_meta->callback = cmd->callback;
-
-	/* set up the header */
-
-	out_cmd->hdr.cmd = cmd->id;
-	out_cmd->hdr.flags = 0;
-	out_cmd->hdr.sequence =
-		cpu_to_le16(QUEUE_TO_SEQ(trans->shrd->cmd_queue) |
-					 INDEX_TO_SEQ(q->write_ptr));
-
-	/* and copy the data that needs to be copied */
-
-	cmd_dest = &out_cmd->cmd.payload[0];
-	for (i = 0; i < IWL_MAX_CMD_TFDS; i++) {
-		if (!cmd->len[i])
-			continue;
-		if (cmd->dataflags[i] & IWL_HCMD_DFL_NOCOPY)
-			break;
-		memcpy(cmd_dest, cmd->data[i], cmd->len[i]);
-		cmd_dest += cmd->len[i];
-	}
-
-	IWL_DEBUG_HC(trans, "Sending command %s (#%x), seq: 0x%04X, "
-			"%d bytes at %d[%d]:%d\n",
-			get_cmd_string(out_cmd->hdr.cmd),
-			out_cmd->hdr.cmd,
-			le16_to_cpu(out_cmd->hdr.sequence), cmd_size,
-			q->write_ptr, idx, trans->shrd->cmd_queue);
-
-	phys_addr = dma_map_single(bus(trans)->dev, &out_cmd->hdr, copy_size,
-				DMA_BIDIRECTIONAL);
-	if (unlikely(dma_mapping_error(bus(trans)->dev, phys_addr))) {
-		idx = -ENOMEM;
-		goto out;
-	}
-
-	dma_unmap_addr_set(out_meta, mapping, phys_addr);
-	dma_unmap_len_set(out_meta, len, copy_size);
-
-	iwlagn_txq_attach_buf_to_tfd(trans, txq,
-					phys_addr, copy_size, 1);
-#ifdef CONFIG_IWLWIFI_DEVICE_TRACING
-	trace_bufs[0] = &out_cmd->hdr;
-	trace_lens[0] = copy_size;
-	trace_idx = 1;
-#endif
-
-	for (i = 0; i < IWL_MAX_CMD_TFDS; i++) {
-		if (!cmd->len[i])
-			continue;
-		if (!(cmd->dataflags[i] & IWL_HCMD_DFL_NOCOPY))
-			continue;
-		phys_addr = dma_map_single(bus(trans)->dev,
-					   (void *)cmd->data[i],
-					   cmd->len[i], DMA_BIDIRECTIONAL);
-		if (dma_mapping_error(bus(trans)->dev, phys_addr)) {
-			iwlagn_unmap_tfd(trans, out_meta,
-					 &txq->tfds[q->write_ptr],
-					 DMA_BIDIRECTIONAL);
-			idx = -ENOMEM;
-			goto out;
-		}
-
-		iwlagn_txq_attach_buf_to_tfd(trans, txq, phys_addr,
-					     cmd->len[i], 0);
-#ifdef CONFIG_IWLWIFI_DEVICE_TRACING
-		trace_bufs[trace_idx] = cmd->data[i];
-		trace_lens[trace_idx] = cmd->len[i];
-		trace_idx++;
-#endif
-	}
-
-	out_meta->flags = cmd->flags;
-
-	txq->need_update = 1;
-
-	/* check that tracing gets all possible blocks */
-	BUILD_BUG_ON(IWL_MAX_CMD_TFDS + 1 != 3);
-#ifdef CONFIG_IWLWIFI_DEVICE_TRACING
-	trace_iwlwifi_dev_hcmd(priv(trans), cmd->flags,
-			       trace_bufs[0], trace_lens[0],
-			       trace_bufs[1], trace_lens[1],
-			       trace_bufs[2], trace_lens[2]);
-#endif
-
-	/* Increment and update queue's write index */
-	q->write_ptr = iwl_queue_inc_wrap(q->write_ptr, q->n_bd);
-	iwl_txq_update_write_ptr(trans, txq);
-
- out:
-	spin_unlock_irqrestore(&trans->hcmd_lock, flags);
-	return idx;
-}
-
-/**
- * iwl_hcmd_queue_reclaim - Reclaim TX command queue entries already Tx'd
- *
- * When FW advances 'R' index, all entries between old and new 'R' index
- * need to be reclaimed. As result, some free space forms.  If there is
- * enough free space (> low mark), wake the stack that feeds us.
- */
-static void iwl_hcmd_queue_reclaim(struct iwl_trans *trans, int txq_id,
-				   int idx)
-{
-	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-	struct iwl_tx_queue *txq = &trans_pcie->txq[txq_id];
-	struct iwl_queue *q = &txq->q;
-	int nfreed = 0;
-
-	if ((idx >= q->n_bd) || (iwl_queue_used(q, idx) == 0)) {
-		IWL_ERR(trans, "%s: Read index for DMA queue txq id (%d), "
-			  "index %d is out of range [0-%d] %d %d.\n", __func__,
-			  txq_id, idx, q->n_bd, q->write_ptr, q->read_ptr);
-		return;
-	}
-
-	for (idx = iwl_queue_inc_wrap(idx, q->n_bd); q->read_ptr != idx;
-	     q->read_ptr = iwl_queue_inc_wrap(q->read_ptr, q->n_bd)) {
-
-		if (nfreed++ > 0) {
-			IWL_ERR(trans, "HCMD skipped: index (%d) %d %d\n", idx,
-					q->write_ptr, q->read_ptr);
-			iwlagn_fw_error(priv(trans), false);
-		}
-
-	}
-}
-
-/**
- * iwl_tx_cmd_complete - Pull unused buffers off the queue and reclaim them
- * @rxb: Rx buffer to reclaim
- *
- * If an Rx buffer has an async callback associated with it the callback
- * will be executed.  The attached skb (if present) will only be freed
- * if the callback returns 1
- */
-void iwl_tx_cmd_complete(struct iwl_trans *trans, struct iwl_rx_mem_buffer *rxb)
-{
-	struct iwl_rx_packet *pkt = rxb_addr(rxb);
-	u16 sequence = le16_to_cpu(pkt->hdr.sequence);
-	int txq_id = SEQ_TO_QUEUE(sequence);
-	int index = SEQ_TO_INDEX(sequence);
-	int cmd_index;
-	struct iwl_device_cmd *cmd;
-	struct iwl_cmd_meta *meta;
-	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-	struct iwl_tx_queue *txq = &trans_pcie->txq[trans->shrd->cmd_queue];
-	unsigned long flags;
-
-	/* If a Tx command is being handled and it isn't in the actual
-	 * command queue then there a command routing bug has been introduced
-	 * in the queue management code. */
-	if (WARN(txq_id != trans->shrd->cmd_queue,
-		 "wrong command queue %d (should be %d), sequence 0x%X readp=%d writep=%d\n",
-		  txq_id, trans->shrd->cmd_queue, sequence,
-		  trans_pcie->txq[trans->shrd->cmd_queue].q.read_ptr,
-		  trans_pcie->txq[trans->shrd->cmd_queue].q.write_ptr)) {
-		iwl_print_hex_error(trans, pkt, 32);
-		return;
-	}
-
-	cmd_index = get_cmd_index(&txq->q, index);
-	cmd = txq->cmd[cmd_index];
-	meta = &txq->meta[cmd_index];
-
-	iwlagn_unmap_tfd(trans, meta, &txq->tfds[index],
-			 DMA_BIDIRECTIONAL);
-
-	/* Input error checking is done when commands are added to queue. */
-	if (meta->flags & CMD_WANT_SKB) {
-		meta->source->reply_page = (unsigned long)rxb_addr(rxb);
-		rxb->page = NULL;
-	} else if (meta->callback)
-		meta->callback(trans->shrd, cmd, pkt);
-
-	spin_lock_irqsave(&trans->hcmd_lock, flags);
-
-	iwl_hcmd_queue_reclaim(trans, txq_id, index);
-
-	if (!(meta->flags & CMD_ASYNC)) {
-		clear_bit(STATUS_HCMD_ACTIVE, &trans->shrd->status);
-		IWL_DEBUG_INFO(trans, "Clearing HCMD_ACTIVE for command %s\n",
-			       get_cmd_string(cmd->hdr.cmd));
-		wake_up_interruptible(&trans->shrd->wait_command_queue);
-	}
-
-	meta->flags = 0;
-
-	spin_unlock_irqrestore(&trans->hcmd_lock, flags);
-}
-
-#define HOST_COMPLETE_TIMEOUT (2 * HZ)
-
-static void iwl_generic_cmd_callback(struct iwl_shared *shrd,
-				     struct iwl_device_cmd *cmd,
-				     struct iwl_rx_packet *pkt)
-{
-	if (pkt->hdr.flags & IWL_CMD_FAILED_MSK) {
-		IWL_ERR(shrd->trans, "Bad return from %s (0x%08X)\n",
-			get_cmd_string(cmd->hdr.cmd), pkt->hdr.flags);
-		return;
-	}
-
-#ifdef CONFIG_IWLWIFI_DEBUG
-	switch (cmd->hdr.cmd) {
-	case REPLY_TX_LINK_QUALITY_CMD:
-	case SENSITIVITY_CMD:
-		IWL_DEBUG_HC_DUMP(shrd->trans, "back from %s (0x%08X)\n",
-				get_cmd_string(cmd->hdr.cmd), pkt->hdr.flags);
-		break;
-	default:
-		IWL_DEBUG_HC(shrd->trans, "back from %s (0x%08X)\n",
-				get_cmd_string(cmd->hdr.cmd), pkt->hdr.flags);
-	}
-#endif
-}
-
-static int iwl_send_cmd_async(struct iwl_trans *trans, struct iwl_host_cmd *cmd)
-{
-	int ret;
-
-	/* An asynchronous command can not expect an SKB to be set. */
-	if (WARN_ON(cmd->flags & CMD_WANT_SKB))
-		return -EINVAL;
-
-	/* Assign a generic callback if one is not provided */
-	if (!cmd->callback)
-		cmd->callback = iwl_generic_cmd_callback;
-
-	if (test_bit(STATUS_EXIT_PENDING, &trans->shrd->status))
-		return -EBUSY;
-
-	ret = iwl_enqueue_hcmd(trans, cmd);
-	if (ret < 0) {
-		IWL_ERR(trans, "Error sending %s: enqueue_hcmd failed: %d\n",
-			  get_cmd_string(cmd->id), ret);
-		return ret;
-	}
-	return 0;
-}
-
-static int iwl_send_cmd_sync(struct iwl_trans *trans, struct iwl_host_cmd *cmd)
-{
-	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-	int cmd_idx;
-	int ret;
-
-	lockdep_assert_held(&trans->shrd->mutex);
-
-	 /* A synchronous command can not have a callback set. */
-	if (WARN_ON(cmd->callback))
-		return -EINVAL;
-
-	IWL_DEBUG_INFO(trans, "Attempting to send sync command %s\n",
-			get_cmd_string(cmd->id));
-
-	set_bit(STATUS_HCMD_ACTIVE, &trans->shrd->status);
-	IWL_DEBUG_INFO(trans, "Setting HCMD_ACTIVE for command %s\n",
-			get_cmd_string(cmd->id));
-
-	cmd_idx = iwl_enqueue_hcmd(trans, cmd);
-	if (cmd_idx < 0) {
-		ret = cmd_idx;
-		clear_bit(STATUS_HCMD_ACTIVE, &trans->shrd->status);
-		IWL_ERR(trans, "Error sending %s: enqueue_hcmd failed: %d\n",
-			  get_cmd_string(cmd->id), ret);
-		return ret;
-	}
-
-	ret = wait_event_interruptible_timeout(trans->shrd->wait_command_queue,
-			!test_bit(STATUS_HCMD_ACTIVE, &trans->shrd->status),
-			HOST_COMPLETE_TIMEOUT);
-	if (!ret) {
-		if (test_bit(STATUS_HCMD_ACTIVE, &trans->shrd->status)) {
-			IWL_ERR(trans,
-				"Error sending %s: time out after %dms.\n",
-				get_cmd_string(cmd->id),
-				jiffies_to_msecs(HOST_COMPLETE_TIMEOUT));
-
-			clear_bit(STATUS_HCMD_ACTIVE, &trans->shrd->status);
-			IWL_DEBUG_INFO(trans, "Clearing HCMD_ACTIVE for command"
-				 "%s\n", get_cmd_string(cmd->id));
-			ret = -ETIMEDOUT;
-			goto cancel;
-		}
-	}
-
-	if (test_bit(STATUS_RF_KILL_HW, &trans->shrd->status)) {
-		IWL_ERR(trans, "Command %s aborted: RF KILL Switch\n",
-			       get_cmd_string(cmd->id));
-		ret = -ECANCELED;
-		goto fail;
-	}
-	if (test_bit(STATUS_FW_ERROR, &trans->shrd->status)) {
-		IWL_ERR(trans, "Command %s failed: FW Error\n",
-			       get_cmd_string(cmd->id));
-		ret = -EIO;
-		goto fail;
-	}
-	if ((cmd->flags & CMD_WANT_SKB) && !cmd->reply_page) {
-		IWL_ERR(trans, "Error: Response NULL in '%s'\n",
-			  get_cmd_string(cmd->id));
-		ret = -EIO;
-		goto cancel;
-	}
-
-	return 0;
-
-cancel:
-	if (cmd->flags & CMD_WANT_SKB) {
-		/*
-		 * Cancel the CMD_WANT_SKB flag for the cmd in the
-		 * TX cmd queue. Otherwise in case the cmd comes
-		 * in later, it will possibly set an invalid
-		 * address (cmd->meta.source).
-		 */
-		trans_pcie->txq[trans->shrd->cmd_queue].meta[cmd_idx].flags &=
-							~CMD_WANT_SKB;
-	}
-fail:
-	if (cmd->reply_page) {
-		iwl_free_pages(trans->shrd, cmd->reply_page);
-		cmd->reply_page = 0;
-	}
-
-	return ret;
-}
-
-int iwl_trans_pcie_send_cmd(struct iwl_trans *trans, struct iwl_host_cmd *cmd)
-{
-	if (cmd->flags & CMD_ASYNC)
-		return iwl_send_cmd_async(trans, cmd);
-
-	return iwl_send_cmd_sync(trans, cmd);
-}
-
-int iwl_trans_pcie_send_cmd_pdu(struct iwl_trans *trans, u8 id, u32 flags,
-		u16 len, const void *data)
-{
-	struct iwl_host_cmd cmd = {
-		.id = id,
-		.len = { len, },
-		.data = { data, },
-		.flags = flags,
-	};
-
-	return iwl_trans_pcie_send_cmd(trans, &cmd);
-}
-
-/* Frees buffers until index _not_ inclusive */
-int iwl_tx_queue_reclaim(struct iwl_trans *trans, int txq_id, int index,
-			 struct sk_buff_head *skbs)
-{
-	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-	struct iwl_tx_queue *txq = &trans_pcie->txq[txq_id];
-	struct iwl_queue *q = &txq->q;
-	int last_to_free;
-	int freed = 0;
-
-	/* This function is not meant to release cmd queue*/
-	if (WARN_ON(txq_id == trans->shrd->cmd_queue))
-		return 0;
-
-	/*Since we free until index _not_ inclusive, the one before index is
-	 * the last we will free. This one must be used */
-	last_to_free = iwl_queue_dec_wrap(index, q->n_bd);
-
-	if ((index >= q->n_bd) ||
-	   (iwl_queue_used(q, last_to_free) == 0)) {
-		IWL_ERR(trans, "%s: Read index for DMA queue txq id (%d), "
-			  "last_to_free %d is out of range [0-%d] %d %d.\n",
-			  __func__, txq_id, last_to_free, q->n_bd,
-			  q->write_ptr, q->read_ptr);
-		return 0;
-	}
-
-	IWL_DEBUG_TX_REPLY(trans, "reclaim: [%d, %d, %d]\n", txq_id,
-			   q->read_ptr, index);
-
-	if (WARN_ON(!skb_queue_empty(skbs)))
-		return 0;
-
-	for (;
-	     q->read_ptr != index;
-	     q->read_ptr = iwl_queue_inc_wrap(q->read_ptr, q->n_bd)) {
-
-		if (WARN_ON_ONCE(txq->skbs[txq->q.read_ptr] == NULL))
-			continue;
-
-		__skb_queue_tail(skbs, txq->skbs[txq->q.read_ptr]);
-
-		txq->skbs[txq->q.read_ptr] = NULL;
-
-		iwlagn_txq_inval_byte_cnt_tbl(trans, txq);
-
-		iwlagn_txq_free_tfd(trans, txq, txq->q.read_ptr, DMA_TO_DEVICE);
-		freed++;
-	}
-	return freed;
-}
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.c b/drivers/net/wireless/iwlwifi/iwl-trans.c
deleted file mode 100644
index 498e006..0000000
--- a/drivers/net/wireless/iwlwifi/iwl-trans.c
+++ /dev/null
@@ -1,1998 +0,0 @@
-/******************************************************************************
- *
- * This file is provided under a dual BSD/GPLv2 license.  When using or
- * redistributing this file, you may do so under either license.
- *
- * GPL LICENSE SUMMARY
- *
- * Copyright(c) 2007 - 2011 Intel Corporation. All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of version 2 of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
- * USA
- *
- * The full GNU General Public License is included in this distribution
- * in the file called LICENSE.GPL.
- *
- * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
- * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
- *
- * BSD LICENSE
- *
- * Copyright(c) 2005 - 2011 Intel Corporation. All rights reserved.
- * All rights reserved.
- *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that the following conditions
- * are met:
- *
- *  * Redistributions of source code must retain the above copyright
- *    notice, this list of conditions and the following disclaimer.
- *  * Redistributions in binary form must reproduce the above copyright
- *    notice, this list of conditions and the following disclaimer in
- *    the documentation and/or other materials provided with the
- *    distribution.
- *  * Neither the name Intel Corporation nor the names of its
- *    contributors may be used to endorse or promote products derived
- *    from this software without specific prior written permission.
- *
- * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
- * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
- * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
- * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
- * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
- * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
- * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
- * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
- * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
- * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
- * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
- *
- *****************************************************************************/
-#include <linux/interrupt.h>
-#include <linux/debugfs.h>
-#include <linux/bitops.h>
-#include <linux/gfp.h>
-
-#include "iwl-trans.h"
-#include "iwl-trans-int-pcie.h"
-#include "iwl-csr.h"
-#include "iwl-prph.h"
-#include "iwl-shared.h"
-#include "iwl-eeprom.h"
-#include "iwl-agn-hw.h"
-
-static int iwl_trans_rx_alloc(struct iwl_trans *trans)
-{
-	struct iwl_trans_pcie *trans_pcie =
-		IWL_TRANS_GET_PCIE_TRANS(trans);
-	struct iwl_rx_queue *rxq = &trans_pcie->rxq;
-	struct device *dev = bus(trans)->dev;
-
-	memset(&trans_pcie->rxq, 0, sizeof(trans_pcie->rxq));
-
-	spin_lock_init(&rxq->lock);
-	INIT_LIST_HEAD(&rxq->rx_free);
-	INIT_LIST_HEAD(&rxq->rx_used);
-
-	if (WARN_ON(rxq->bd || rxq->rb_stts))
-		return -EINVAL;
-
-	/* Allocate the circular buffer of Read Buffer Descriptors (RBDs) */
-	rxq->bd = dma_alloc_coherent(dev, sizeof(__le32) * RX_QUEUE_SIZE,
-				     &rxq->bd_dma, GFP_KERNEL);
-	if (!rxq->bd)
-		goto err_bd;
-	memset(rxq->bd, 0, sizeof(__le32) * RX_QUEUE_SIZE);
-
-	/*Allocate the driver's pointer to receive buffer status */
-	rxq->rb_stts = dma_alloc_coherent(dev, sizeof(*rxq->rb_stts),
-					  &rxq->rb_stts_dma, GFP_KERNEL);
-	if (!rxq->rb_stts)
-		goto err_rb_stts;
-	memset(rxq->rb_stts, 0, sizeof(*rxq->rb_stts));
-
-	return 0;
-
-err_rb_stts:
-	dma_free_coherent(dev, sizeof(__le32) * RX_QUEUE_SIZE,
-			rxq->bd, rxq->bd_dma);
-	memset(&rxq->bd_dma, 0, sizeof(rxq->bd_dma));
-	rxq->bd = NULL;
-err_bd:
-	return -ENOMEM;
-}
-
-static void iwl_trans_rxq_free_rx_bufs(struct iwl_trans *trans)
-{
-	struct iwl_trans_pcie *trans_pcie =
-		IWL_TRANS_GET_PCIE_TRANS(trans);
-	struct iwl_rx_queue *rxq = &trans_pcie->rxq;
-	int i;
-
-	/* Fill the rx_used queue with _all_ of the Rx buffers */
-	for (i = 0; i < RX_FREE_BUFFERS + RX_QUEUE_SIZE; i++) {
-		/* In the reset function, these buffers may have been allocated
-		 * to an SKB, so we need to unmap and free potential storage */
-		if (rxq->pool[i].page != NULL) {
-			dma_unmap_page(bus(trans)->dev, rxq->pool[i].page_dma,
-				PAGE_SIZE << hw_params(trans).rx_page_order,
-				DMA_FROM_DEVICE);
-			__free_pages(rxq->pool[i].page,
-				     hw_params(trans).rx_page_order);
-			rxq->pool[i].page = NULL;
-		}
-		list_add_tail(&rxq->pool[i].list, &rxq->rx_used);
-	}
-}
-
-static void iwl_trans_rx_hw_init(struct iwl_trans *trans,
-				 struct iwl_rx_queue *rxq)
-{
-	u32 rb_size;
-	const u32 rfdnlog = RX_QUEUE_SIZE_LOG; /* 256 RBDs */
-	u32 rb_timeout = 0; /* FIXME: RX_RB_TIMEOUT for all devices? */
-
-	rb_timeout = RX_RB_TIMEOUT;
-
-	if (iwlagn_mod_params.amsdu_size_8K)
-		rb_size = FH_RCSR_RX_CONFIG_REG_VAL_RB_SIZE_8K;
-	else
-		rb_size = FH_RCSR_RX_CONFIG_REG_VAL_RB_SIZE_4K;
-
-	/* Stop Rx DMA */
-	iwl_write_direct32(bus(trans), FH_MEM_RCSR_CHNL0_CONFIG_REG, 0);
-
-	/* Reset driver's Rx queue write index */
-	iwl_write_direct32(bus(trans), FH_RSCSR_CHNL0_RBDCB_WPTR_REG, 0);
-
-	/* Tell device where to find RBD circular buffer in DRAM */
-	iwl_write_direct32(bus(trans), FH_RSCSR_CHNL0_RBDCB_BASE_REG,
-			   (u32)(rxq->bd_dma >> 8));
-
-	/* Tell device where in DRAM to update its Rx status */
-	iwl_write_direct32(bus(trans), FH_RSCSR_CHNL0_STTS_WPTR_REG,
-			   rxq->rb_stts_dma >> 4);
-
-	/* Enable Rx DMA
-	 * FH_RCSR_CHNL0_RX_IGNORE_RXF_EMPTY is set because of HW bug in
-	 *      the credit mechanism in 5000 HW RX FIFO
-	 * Direct rx interrupts to hosts
-	 * Rx buffer size 4 or 8k
-	 * RB timeout 0x10
-	 * 256 RBDs
-	 */
-	iwl_write_direct32(bus(trans), FH_MEM_RCSR_CHNL0_CONFIG_REG,
-			   FH_RCSR_RX_CONFIG_CHNL_EN_ENABLE_VAL |
-			   FH_RCSR_CHNL0_RX_IGNORE_RXF_EMPTY |
-			   FH_RCSR_CHNL0_RX_CONFIG_IRQ_DEST_INT_HOST_VAL |
-			   FH_RCSR_CHNL0_RX_CONFIG_SINGLE_FRAME_MSK |
-			   rb_size|
-			   (rb_timeout << FH_RCSR_RX_CONFIG_REG_IRQ_RBTH_POS)|
-			   (rfdnlog << FH_RCSR_RX_CONFIG_RBDCB_SIZE_POS));
-
-	/* Set interrupt coalescing timer to default (2048 usecs) */
-	iwl_write8(bus(trans), CSR_INT_COALESCING, IWL_HOST_INT_TIMEOUT_DEF);
-}
-
-static int iwl_rx_init(struct iwl_trans *trans)
-{
-	struct iwl_trans_pcie *trans_pcie =
-		IWL_TRANS_GET_PCIE_TRANS(trans);
-	struct iwl_rx_queue *rxq = &trans_pcie->rxq;
-
-	int i, err;
-	unsigned long flags;
-
-	if (!rxq->bd) {
-		err = iwl_trans_rx_alloc(trans);
-		if (err)
-			return err;
-	}
-
-	spin_lock_irqsave(&rxq->lock, flags);
-	INIT_LIST_HEAD(&rxq->rx_free);
-	INIT_LIST_HEAD(&rxq->rx_used);
-
-	iwl_trans_rxq_free_rx_bufs(trans);
-
-	for (i = 0; i < RX_QUEUE_SIZE; i++)
-		rxq->queue[i] = NULL;
-
-	/* Set us so that we have processed and used all buffers, but have
-	 * not restocked the Rx queue with fresh buffers */
-	rxq->read = rxq->write = 0;
-	rxq->write_actual = 0;
-	rxq->free_count = 0;
-	spin_unlock_irqrestore(&rxq->lock, flags);
-
-	iwlagn_rx_replenish(trans);
-
-	iwl_trans_rx_hw_init(trans, rxq);
-
-	spin_lock_irqsave(&trans->shrd->lock, flags);
-	rxq->need_update = 1;
-	iwl_rx_queue_update_write_ptr(trans, rxq);
-	spin_unlock_irqrestore(&trans->shrd->lock, flags);
-
-	return 0;
-}
-
-static void iwl_trans_pcie_rx_free(struct iwl_trans *trans)
-{
-	struct iwl_trans_pcie *trans_pcie =
-		IWL_TRANS_GET_PCIE_TRANS(trans);
-	struct iwl_rx_queue *rxq = &trans_pcie->rxq;
-
-	unsigned long flags;
-
-	/*if rxq->bd is NULL, it means that nothing has been allocated,
-	 * exit now */
-	if (!rxq->bd) {
-		IWL_DEBUG_INFO(trans, "Free NULL rx context\n");
-		return;
-	}
-
-	spin_lock_irqsave(&rxq->lock, flags);
-	iwl_trans_rxq_free_rx_bufs(trans);
-	spin_unlock_irqrestore(&rxq->lock, flags);
-
-	dma_free_coherent(bus(trans)->dev, sizeof(__le32) * RX_QUEUE_SIZE,
-			  rxq->bd, rxq->bd_dma);
-	memset(&rxq->bd_dma, 0, sizeof(rxq->bd_dma));
-	rxq->bd = NULL;
-
-	if (rxq->rb_stts)
-		dma_free_coherent(bus(trans)->dev,
-				  sizeof(struct iwl_rb_status),
-				  rxq->rb_stts, rxq->rb_stts_dma);
-	else
-		IWL_DEBUG_INFO(trans, "Free rxq->rb_stts which is NULL\n");
-	memset(&rxq->rb_stts_dma, 0, sizeof(rxq->rb_stts_dma));
-	rxq->rb_stts = NULL;
-}
-
-static int iwl_trans_rx_stop(struct iwl_trans *trans)
-{
-
-	/* stop Rx DMA */
-	iwl_write_direct32(bus(trans), FH_MEM_RCSR_CHNL0_CONFIG_REG, 0);
-	return iwl_poll_direct_bit(bus(trans), FH_MEM_RSSR_RX_STATUS_REG,
-			    FH_RSSR_CHNL0_RX_STATUS_CHNL_IDLE, 1000);
-}
-
-static inline int iwlagn_alloc_dma_ptr(struct iwl_trans *trans,
-				    struct iwl_dma_ptr *ptr, size_t size)
-{
-	if (WARN_ON(ptr->addr))
-		return -EINVAL;
-
-	ptr->addr = dma_alloc_coherent(bus(trans)->dev, size,
-				       &ptr->dma, GFP_KERNEL);
-	if (!ptr->addr)
-		return -ENOMEM;
-	ptr->size = size;
-	return 0;
-}
-
-static inline void iwlagn_free_dma_ptr(struct iwl_trans *trans,
-				    struct iwl_dma_ptr *ptr)
-{
-	if (unlikely(!ptr->addr))
-		return;
-
-	dma_free_coherent(bus(trans)->dev, ptr->size, ptr->addr, ptr->dma);
-	memset(ptr, 0, sizeof(*ptr));
-}
-
-static int iwl_trans_txq_alloc(struct iwl_trans *trans,
-				struct iwl_tx_queue *txq, int slots_num,
-				u32 txq_id)
-{
-	size_t tfd_sz = sizeof(struct iwl_tfd) * TFD_QUEUE_SIZE_MAX;
-	int i;
-
-	if (WARN_ON(txq->meta || txq->cmd || txq->skbs || txq->tfds))
-		return -EINVAL;
-
-	txq->q.n_window = slots_num;
-
-	txq->meta = kzalloc(sizeof(txq->meta[0]) * slots_num, GFP_KERNEL);
-	txq->cmd = kzalloc(sizeof(txq->cmd[0]) * slots_num, GFP_KERNEL);
-
-	if (!txq->meta || !txq->cmd)
-		goto error;
-
-	if (txq_id == trans->shrd->cmd_queue)
-		for (i = 0; i < slots_num; i++) {
-			txq->cmd[i] = kmalloc(sizeof(struct iwl_device_cmd),
-						GFP_KERNEL);
-			if (!txq->cmd[i])
-				goto error;
-		}
-
-	/* Alloc driver data array and TFD circular buffer */
-	/* Driver private data, only for Tx (not command) queues,
-	 * not shared with device. */
-	if (txq_id != trans->shrd->cmd_queue) {
-		txq->skbs = kzalloc(sizeof(txq->skbs[0]) *
-				   TFD_QUEUE_SIZE_MAX, GFP_KERNEL);
-		if (!txq->skbs) {
-			IWL_ERR(trans, "kmalloc for auxiliary BD "
-				  "structures failed\n");
-			goto error;
-		}
-	} else {
-		txq->skbs = NULL;
-	}
-
-	/* Circular buffer of transmit frame descriptors (TFDs),
-	 * shared with device */
-	txq->tfds = dma_alloc_coherent(bus(trans)->dev, tfd_sz,
-				       &txq->q.dma_addr, GFP_KERNEL);
-	if (!txq->tfds) {
-		IWL_ERR(trans, "dma_alloc_coherent(%zd) failed\n", tfd_sz);
-		goto error;
-	}
-	txq->q.id = txq_id;
-
-	return 0;
-error:
-	kfree(txq->skbs);
-	txq->skbs = NULL;
-	/* since txq->cmd has been zeroed,
-	 * all non allocated cmd[i] will be NULL */
-	if (txq->cmd && txq_id == trans->shrd->cmd_queue)
-		for (i = 0; i < slots_num; i++)
-			kfree(txq->cmd[i]);
-	kfree(txq->meta);
-	kfree(txq->cmd);
-	txq->meta = NULL;
-	txq->cmd = NULL;
-
-	return -ENOMEM;
-
-}
-
-static int iwl_trans_txq_init(struct iwl_trans *trans, struct iwl_tx_queue *txq,
-		      int slots_num, u32 txq_id)
-{
-	int ret;
-
-	txq->need_update = 0;
-	memset(txq->meta, 0, sizeof(txq->meta[0]) * slots_num);
-
-	/*
-	 * For the default queues 0-3, set up the swq_id
-	 * already -- all others need to get one later
-	 * (if they need one at all).
-	 */
-	if (txq_id < 4)
-		iwl_set_swq_id(txq, txq_id, txq_id);
-
-	/* TFD_QUEUE_SIZE_MAX must be power-of-two size, otherwise
-	 * iwl_queue_inc_wrap and iwl_queue_dec_wrap are broken. */
-	BUILD_BUG_ON(TFD_QUEUE_SIZE_MAX & (TFD_QUEUE_SIZE_MAX - 1));
-
-	/* Initialize queue's high/low-water marks, and head/tail indexes */
-	ret = iwl_queue_init(&txq->q, TFD_QUEUE_SIZE_MAX, slots_num,
-			txq_id);
-	if (ret)
-		return ret;
-
-	/*
-	 * Tell nic where to find circular buffer of Tx Frame Descriptors for
-	 * given Tx queue, and enable the DMA channel used for that queue.
-	 * Circular buffer (TFD queue in DRAM) physical base address */
-	iwl_write_direct32(bus(trans), FH_MEM_CBBC_QUEUE(txq_id),
-			     txq->q.dma_addr >> 8);
-
-	return 0;
-}
-
-/**
- * iwl_tx_queue_unmap -  Unmap any remaining DMA mappings and free skb's
- */
-static void iwl_tx_queue_unmap(struct iwl_trans *trans, int txq_id)
-{
-	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-	struct iwl_tx_queue *txq = &trans_pcie->txq[txq_id];
-	struct iwl_queue *q = &txq->q;
-	enum dma_data_direction dma_dir;
-
-	if (!q->n_bd)
-		return;
-
-	/* In the command queue, all the TBs are mapped as BIDI
-	 * so unmap them as such.
-	 */
-	if (txq_id == trans->shrd->cmd_queue)
-		dma_dir = DMA_BIDIRECTIONAL;
-	else
-		dma_dir = DMA_TO_DEVICE;
-
-	while (q->write_ptr != q->read_ptr) {
-		/* The read_ptr needs to bound by q->n_window */
-		iwlagn_txq_free_tfd(trans, txq, get_cmd_index(q, q->read_ptr),
-				    dma_dir);
-		q->read_ptr = iwl_queue_inc_wrap(q->read_ptr, q->n_bd);
-	}
-}
-
-/**
- * iwl_tx_queue_free - Deallocate DMA queue.
- * @txq: Transmit queue to deallocate.
- *
- * Empty queue by removing and destroying all BD's.
- * Free all buffers.
- * 0-fill, but do not free "txq" descriptor structure.
- */
-static void iwl_tx_queue_free(struct iwl_trans *trans, int txq_id)
-{
-	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-	struct iwl_tx_queue *txq = &trans_pcie->txq[txq_id];
-	struct device *dev = bus(trans)->dev;
-	int i;
-	if (WARN_ON(!txq))
-		return;
-
-	iwl_tx_queue_unmap(trans, txq_id);
-
-	/* De-alloc array of command/tx buffers */
-
-	if (txq_id == trans->shrd->cmd_queue)
-		for (i = 0; i < txq->q.n_window; i++)
-			kfree(txq->cmd[i]);
-
-	/* De-alloc circular buffer of TFDs */
-	if (txq->q.n_bd) {
-		dma_free_coherent(dev, sizeof(struct iwl_tfd) *
-				  txq->q.n_bd, txq->tfds, txq->q.dma_addr);
-		memset(&txq->q.dma_addr, 0, sizeof(txq->q.dma_addr));
-	}
-
-	/* De-alloc array of per-TFD driver data */
-	kfree(txq->skbs);
-	txq->skbs = NULL;
-
-	/* deallocate arrays */
-	kfree(txq->cmd);
-	kfree(txq->meta);
-	txq->cmd = NULL;
-	txq->meta = NULL;
-
-	/* 0-fill queue descriptor structure */
-	memset(txq, 0, sizeof(*txq));
-}
-
-/**
- * iwl_trans_tx_free - Free TXQ Context
- *
- * Destroy all TX DMA queues and structures
- */
-static void iwl_trans_pcie_tx_free(struct iwl_trans *trans)
-{
-	int txq_id;
-	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-
-	/* Tx queues */
-	if (trans_pcie->txq) {
-		for (txq_id = 0;
-		     txq_id < hw_params(trans).max_txq_num; txq_id++)
-			iwl_tx_queue_free(trans, txq_id);
-	}
-
-	kfree(trans_pcie->txq);
-	trans_pcie->txq = NULL;
-
-	iwlagn_free_dma_ptr(trans, &trans_pcie->kw);
-
-	iwlagn_free_dma_ptr(trans, &trans_pcie->scd_bc_tbls);
-}
-
-/**
- * iwl_trans_tx_alloc - allocate TX context
- * Allocate all Tx DMA structures and initialize them
- *
- * @param priv
- * @return error code
- */
-static int iwl_trans_tx_alloc(struct iwl_trans *trans)
-{
-	int ret;
-	int txq_id, slots_num;
-	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-
-	u16 scd_bc_tbls_size = hw_params(trans).max_txq_num *
-			sizeof(struct iwlagn_scd_bc_tbl);
-
-	/*It is not allowed to alloc twice, so warn when this happens.
-	 * We cannot rely on the previous allocation, so free and fail */
-	if (WARN_ON(trans_pcie->txq)) {
-		ret = -EINVAL;
-		goto error;
-	}
-
-	ret = iwlagn_alloc_dma_ptr(trans, &trans_pcie->scd_bc_tbls,
-				   scd_bc_tbls_size);
-	if (ret) {
-		IWL_ERR(trans, "Scheduler BC Table allocation failed\n");
-		goto error;
-	}
-
-	/* Alloc keep-warm buffer */
-	ret = iwlagn_alloc_dma_ptr(trans, &trans_pcie->kw, IWL_KW_SIZE);
-	if (ret) {
-		IWL_ERR(trans, "Keep Warm allocation failed\n");
-		goto error;
-	}
-
-	trans_pcie->txq = kzalloc(sizeof(struct iwl_tx_queue) *
-			hw_params(trans).max_txq_num, GFP_KERNEL);
-	if (!trans_pcie->txq) {
-		IWL_ERR(trans, "Not enough memory for txq\n");
-		ret = ENOMEM;
-		goto error;
-	}
-
-	/* Alloc and init all Tx queues, including the command queue (#4/#9) */
-	for (txq_id = 0; txq_id < hw_params(trans).max_txq_num; txq_id++) {
-		slots_num = (txq_id == trans->shrd->cmd_queue) ?
-					TFD_CMD_SLOTS : TFD_TX_CMD_SLOTS;
-		ret = iwl_trans_txq_alloc(trans, &trans_pcie->txq[txq_id],
-					  slots_num, txq_id);
-		if (ret) {
-			IWL_ERR(trans, "Tx %d queue alloc failed\n", txq_id);
-			goto error;
-		}
-	}
-
-	return 0;
-
-error:
-	iwl_trans_pcie_tx_free(trans);
-
-	return ret;
-}
-static int iwl_tx_init(struct iwl_trans *trans)
-{
-	int ret;
-	int txq_id, slots_num;
-	unsigned long flags;
-	bool alloc = false;
-	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-
-	if (!trans_pcie->txq) {
-		ret = iwl_trans_tx_alloc(trans);
-		if (ret)
-			goto error;
-		alloc = true;
-	}
-
-	spin_lock_irqsave(&trans->shrd->lock, flags);
-
-	/* Turn off all Tx DMA fifos */
-	iwl_write_prph(bus(trans), SCD_TXFACT, 0);
-
-	/* Tell NIC where to find the "keep warm" buffer */
-	iwl_write_direct32(bus(trans), FH_KW_MEM_ADDR_REG,
-			   trans_pcie->kw.dma >> 4);
-
-	spin_unlock_irqrestore(&trans->shrd->lock, flags);
-
-	/* Alloc and init all Tx queues, including the command queue (#4/#9) */
-	for (txq_id = 0; txq_id < hw_params(trans).max_txq_num; txq_id++) {
-		slots_num = (txq_id == trans->shrd->cmd_queue) ?
-					TFD_CMD_SLOTS : TFD_TX_CMD_SLOTS;
-		ret = iwl_trans_txq_init(trans, &trans_pcie->txq[txq_id],
-					 slots_num, txq_id);
-		if (ret) {
-			IWL_ERR(trans, "Tx %d queue init failed\n", txq_id);
-			goto error;
-		}
-	}
-
-	return 0;
-error:
-	/*Upon error, free only if we allocated something */
-	if (alloc)
-		iwl_trans_pcie_tx_free(trans);
-	return ret;
-}
-
-static void iwl_set_pwr_vmain(struct iwl_trans *trans)
-{
-/*
- * (for documentation purposes)
- * to set power to V_AUX, do:
-
-		if (pci_pme_capable(priv->pci_dev, PCI_D3cold))
-			iwl_set_bits_mask_prph(bus(trans), APMG_PS_CTRL_REG,
-					       APMG_PS_CTRL_VAL_PWR_SRC_VAUX,
-					       ~APMG_PS_CTRL_MSK_PWR_SRC);
- */
-
-	iwl_set_bits_mask_prph(bus(trans), APMG_PS_CTRL_REG,
-			       APMG_PS_CTRL_VAL_PWR_SRC_VMAIN,
-			       ~APMG_PS_CTRL_MSK_PWR_SRC);
-}
-
-static int iwl_nic_init(struct iwl_trans *trans)
-{
-	unsigned long flags;
-
-	/* nic_init */
-	spin_lock_irqsave(&trans->shrd->lock, flags);
-	iwl_apm_init(priv(trans));
-
-	/* Set interrupt coalescing calibration timer to default (512 usecs) */
-	iwl_write8(bus(trans), CSR_INT_COALESCING,
-		IWL_HOST_INT_CALIB_TIMEOUT_DEF);
-
-	spin_unlock_irqrestore(&trans->shrd->lock, flags);
-
-	iwl_set_pwr_vmain(trans);
-
-	iwl_nic_config(priv(trans));
-
-	/* Allocate the RX queue, or reset if it is already allocated */
-	iwl_rx_init(trans);
-
-	/* Allocate or reset and init all Tx and Command queues */
-	if (iwl_tx_init(trans))
-		return -ENOMEM;
-
-	if (hw_params(trans).shadow_reg_enable) {
-		/* enable shadow regs in HW */
-		iwl_set_bit(bus(trans), CSR_MAC_SHADOW_REG_CTRL,
-			0x800FFFFF);
-	}
-
-	set_bit(STATUS_INIT, &trans->shrd->status);
-
-	return 0;
-}
-
-#define HW_READY_TIMEOUT (50)
-
-/* Note: returns poll_bit return value, which is >= 0 if success */
-static int iwl_set_hw_ready(struct iwl_trans *trans)
-{
-	int ret;
-
-	iwl_set_bit(bus(trans), CSR_HW_IF_CONFIG_REG,
-		CSR_HW_IF_CONFIG_REG_BIT_NIC_READY);
-
-	/* See if we got it */
-	ret = iwl_poll_bit(bus(trans), CSR_HW_IF_CONFIG_REG,
-				CSR_HW_IF_CONFIG_REG_BIT_NIC_READY,
-				CSR_HW_IF_CONFIG_REG_BIT_NIC_READY,
-				HW_READY_TIMEOUT);
-
-	IWL_DEBUG_INFO(trans, "hardware%s ready\n", ret < 0 ? " not" : "");
-	return ret;
-}
-
-/* Note: returns standard 0/-ERROR code */
-static int iwl_trans_pcie_prepare_card_hw(struct iwl_trans *trans)
-{
-	int ret;
-
-	IWL_DEBUG_INFO(trans, "iwl_trans_prepare_card_hw enter\n");
-
-	ret = iwl_set_hw_ready(trans);
-	if (ret >= 0)
-		return 0;
-
-	/* If HW is not ready, prepare the conditions to check again */
-	iwl_set_bit(bus(trans), CSR_HW_IF_CONFIG_REG,
-			CSR_HW_IF_CONFIG_REG_PREPARE);
-
-	ret = iwl_poll_bit(bus(trans), CSR_HW_IF_CONFIG_REG,
-			~CSR_HW_IF_CONFIG_REG_BIT_NIC_PREPARE_DONE,
-			CSR_HW_IF_CONFIG_REG_BIT_NIC_PREPARE_DONE, 150000);
-
-	if (ret < 0)
-		return ret;
-
-	/* HW should be ready by now, check again. */
-	ret = iwl_set_hw_ready(trans);
-	if (ret >= 0)
-		return 0;
-	return ret;
-}
-
-#define IWL_AC_UNSET -1
-
-struct queue_to_fifo_ac {
-	s8 fifo, ac;
-};
-
-static const struct queue_to_fifo_ac iwlagn_default_queue_to_tx_fifo[] = {
-	{ IWL_TX_FIFO_VO, IEEE80211_AC_VO, },
-	{ IWL_TX_FIFO_VI, IEEE80211_AC_VI, },
-	{ IWL_TX_FIFO_BE, IEEE80211_AC_BE, },
-	{ IWL_TX_FIFO_BK, IEEE80211_AC_BK, },
-	{ IWLAGN_CMD_FIFO_NUM, IWL_AC_UNSET, },
-	{ IWL_TX_FIFO_UNUSED, IWL_AC_UNSET, },
-	{ IWL_TX_FIFO_UNUSED, IWL_AC_UNSET, },
-	{ IWL_TX_FIFO_UNUSED, IWL_AC_UNSET, },
-	{ IWL_TX_FIFO_UNUSED, IWL_AC_UNSET, },
-	{ IWL_TX_FIFO_UNUSED, IWL_AC_UNSET, },
-	{ IWL_TX_FIFO_UNUSED, IWL_AC_UNSET, },
-};
-
-static const struct queue_to_fifo_ac iwlagn_ipan_queue_to_tx_fifo[] = {
-	{ IWL_TX_FIFO_VO, IEEE80211_AC_VO, },
-	{ IWL_TX_FIFO_VI, IEEE80211_AC_VI, },
-	{ IWL_TX_FIFO_BE, IEEE80211_AC_BE, },
-	{ IWL_TX_FIFO_BK, IEEE80211_AC_BK, },
-	{ IWL_TX_FIFO_BK_IPAN, IEEE80211_AC_BK, },
-	{ IWL_TX_FIFO_BE_IPAN, IEEE80211_AC_BE, },
-	{ IWL_TX_FIFO_VI_IPAN, IEEE80211_AC_VI, },
-	{ IWL_TX_FIFO_VO_IPAN, IEEE80211_AC_VO, },
-	{ IWL_TX_FIFO_BE_IPAN, 2, },
-	{ IWLAGN_CMD_FIFO_NUM, IWL_AC_UNSET, },
-	{ IWL_TX_FIFO_AUX, IWL_AC_UNSET, },
-};
-
-static const u8 iwlagn_bss_ac_to_fifo[] = {
-	IWL_TX_FIFO_VO,
-	IWL_TX_FIFO_VI,
-	IWL_TX_FIFO_BE,
-	IWL_TX_FIFO_BK,
-};
-static const u8 iwlagn_bss_ac_to_queue[] = {
-	0, 1, 2, 3,
-};
-static const u8 iwlagn_pan_ac_to_fifo[] = {
-	IWL_TX_FIFO_VO_IPAN,
-	IWL_TX_FIFO_VI_IPAN,
-	IWL_TX_FIFO_BE_IPAN,
-	IWL_TX_FIFO_BK_IPAN,
-};
-static const u8 iwlagn_pan_ac_to_queue[] = {
-	7, 6, 5, 4,
-};
-
-static int iwl_trans_pcie_start_device(struct iwl_trans *trans)
-{
-	int ret;
-	struct iwl_trans_pcie *trans_pcie =
-		IWL_TRANS_GET_PCIE_TRANS(trans);
-
-	trans->shrd->ucode_owner = IWL_OWNERSHIP_DRIVER;
-	trans_pcie->ac_to_queue[IWL_RXON_CTX_BSS] = iwlagn_bss_ac_to_queue;
-	trans_pcie->ac_to_queue[IWL_RXON_CTX_PAN] = iwlagn_pan_ac_to_queue;
-
-	trans_pcie->ac_to_fifo[IWL_RXON_CTX_BSS] = iwlagn_bss_ac_to_fifo;
-	trans_pcie->ac_to_fifo[IWL_RXON_CTX_PAN] = iwlagn_pan_ac_to_fifo;
-
-	trans_pcie->mcast_queue[IWL_RXON_CTX_BSS] = 0;
-	trans_pcie->mcast_queue[IWL_RXON_CTX_PAN] = IWL_IPAN_MCAST_QUEUE;
-
-	if ((hw_params(trans).sku & EEPROM_SKU_CAP_AMT_ENABLE) &&
-	     iwl_trans_pcie_prepare_card_hw(trans)) {
-		IWL_WARN(trans, "Exit HW not ready\n");
-		return -EIO;
-	}
-
-	/* If platform's RF_KILL switch is NOT set to KILL */
-	if (iwl_read32(bus(trans), CSR_GP_CNTRL) &
-			CSR_GP_CNTRL_REG_FLAG_HW_RF_KILL_SW)
-		clear_bit(STATUS_RF_KILL_HW, &trans->shrd->status);
-	else
-		set_bit(STATUS_RF_KILL_HW, &trans->shrd->status);
-
-	if (iwl_is_rfkill(trans->shrd)) {
-		iwl_set_hw_rfkill_state(priv(trans), true);
-		iwl_enable_interrupts(trans);
-		return -ERFKILL;
-	}
-
-	iwl_write32(bus(trans), CSR_INT, 0xFFFFFFFF);
-
-	ret = iwl_nic_init(trans);
-	if (ret) {
-		IWL_ERR(trans, "Unable to init nic\n");
-		return ret;
-	}
-
-	/* make sure rfkill handshake bits are cleared */
-	iwl_write32(bus(trans), CSR_UCODE_DRV_GP1_CLR, CSR_UCODE_SW_BIT_RFKILL);
-	iwl_write32(bus(trans), CSR_UCODE_DRV_GP1_CLR,
-		    CSR_UCODE_DRV_GP1_BIT_CMD_BLOCKED);
-
-	/* clear (again), then enable host interrupts */
-	iwl_write32(bus(trans), CSR_INT, 0xFFFFFFFF);
-	iwl_enable_interrupts(trans);
-
-	/* really make sure rfkill handshake bits are cleared */
-	iwl_write32(bus(trans), CSR_UCODE_DRV_GP1_CLR, CSR_UCODE_SW_BIT_RFKILL);
-	iwl_write32(bus(trans), CSR_UCODE_DRV_GP1_CLR, CSR_UCODE_SW_BIT_RFKILL);
-
-	return 0;
-}
-
-/*
- * Activate/Deactivate Tx DMA/FIFO channels according tx fifos mask
- * must be called under priv->shrd->lock and mac access
- */
-static void iwl_trans_txq_set_sched(struct iwl_trans *trans, u32 mask)
-{
-	iwl_write_prph(bus(trans), SCD_TXFACT, mask);
-}
-
-static void iwl_trans_pcie_tx_start(struct iwl_trans *trans)
-{
-	const struct queue_to_fifo_ac *queue_to_fifo;
-	struct iwl_trans_pcie *trans_pcie =
-		IWL_TRANS_GET_PCIE_TRANS(trans);
-	u32 a;
-	unsigned long flags;
-	int i, chan;
-	u32 reg_val;
-
-	spin_lock_irqsave(&trans->shrd->lock, flags);
-
-	trans_pcie->scd_base_addr =
-		iwl_read_prph(bus(trans), SCD_SRAM_BASE_ADDR);
-	a = trans_pcie->scd_base_addr + SCD_CONTEXT_MEM_LOWER_BOUND;
-	/* reset conext data memory */
-	for (; a < trans_pcie->scd_base_addr + SCD_CONTEXT_MEM_UPPER_BOUND;
-		a += 4)
-		iwl_write_targ_mem(bus(trans), a, 0);
-	/* reset tx status memory */
-	for (; a < trans_pcie->scd_base_addr + SCD_TX_STTS_MEM_UPPER_BOUND;
-		a += 4)
-		iwl_write_targ_mem(bus(trans), a, 0);
-	for (; a < trans_pcie->scd_base_addr +
-	       SCD_TRANS_TBL_OFFSET_QUEUE(hw_params(trans).max_txq_num);
-	       a += 4)
-		iwl_write_targ_mem(bus(trans), a, 0);
-
-	iwl_write_prph(bus(trans), SCD_DRAM_BASE_ADDR,
-		       trans_pcie->scd_bc_tbls.dma >> 10);
-
-	/* Enable DMA channel */
-	for (chan = 0; chan < FH_TCSR_CHNL_NUM ; chan++)
-		iwl_write_direct32(bus(trans), FH_TCSR_CHNL_TX_CONFIG_REG(chan),
-				FH_TCSR_TX_CONFIG_REG_VAL_DMA_CHNL_ENABLE |
-				FH_TCSR_TX_CONFIG_REG_VAL_DMA_CREDIT_ENABLE);
-
-	/* Update FH chicken bits */
-	reg_val = iwl_read_direct32(bus(trans), FH_TX_CHICKEN_BITS_REG);
-	iwl_write_direct32(bus(trans), FH_TX_CHICKEN_BITS_REG,
-			   reg_val | FH_TX_CHICKEN_BITS_SCD_AUTO_RETRY_EN);
-
-	iwl_write_prph(bus(trans), SCD_QUEUECHAIN_SEL,
-		SCD_QUEUECHAIN_SEL_ALL(trans));
-	iwl_write_prph(bus(trans), SCD_AGGR_SEL, 0);
-
-	/* initiate the queues */
-	for (i = 0; i < hw_params(trans).max_txq_num; i++) {
-		iwl_write_prph(bus(trans), SCD_QUEUE_RDPTR(i), 0);
-		iwl_write_direct32(bus(trans), HBUS_TARG_WRPTR, 0 | (i << 8));
-		iwl_write_targ_mem(bus(trans), trans_pcie->scd_base_addr +
-				SCD_CONTEXT_QUEUE_OFFSET(i), 0);
-		iwl_write_targ_mem(bus(trans), trans_pcie->scd_base_addr +
-				SCD_CONTEXT_QUEUE_OFFSET(i) +
-				sizeof(u32),
-				((SCD_WIN_SIZE <<
-				SCD_QUEUE_CTX_REG2_WIN_SIZE_POS) &
-				SCD_QUEUE_CTX_REG2_WIN_SIZE_MSK) |
-				((SCD_FRAME_LIMIT <<
-				SCD_QUEUE_CTX_REG2_FRAME_LIMIT_POS) &
-				SCD_QUEUE_CTX_REG2_FRAME_LIMIT_MSK));
-	}
-
-	iwl_write_prph(bus(trans), SCD_INTERRUPT_MASK,
-			IWL_MASK(0, hw_params(trans).max_txq_num));
-
-	/* Activate all Tx DMA/FIFO channels */
-	iwl_trans_txq_set_sched(trans, IWL_MASK(0, 7));
-
-	/* map queues to FIFOs */
-	if (trans->shrd->valid_contexts != BIT(IWL_RXON_CTX_BSS))
-		queue_to_fifo = iwlagn_ipan_queue_to_tx_fifo;
-	else
-		queue_to_fifo = iwlagn_default_queue_to_tx_fifo;
-
-	iwl_trans_set_wr_ptrs(trans, trans->shrd->cmd_queue, 0);
-
-	/* make sure all queue are not stopped */
-	memset(&trans_pcie->queue_stopped[0], 0,
-		sizeof(trans_pcie->queue_stopped));
-	for (i = 0; i < 4; i++)
-		atomic_set(&trans_pcie->queue_stop_count[i], 0);
-
-	/* reset to 0 to enable all the queue first */
-	trans_pcie->txq_ctx_active_msk = 0;
-
-	BUILD_BUG_ON(ARRAY_SIZE(iwlagn_default_queue_to_tx_fifo) <
-						IWLAGN_FIRST_AMPDU_QUEUE);
-	BUILD_BUG_ON(ARRAY_SIZE(iwlagn_ipan_queue_to_tx_fifo) <
-						IWLAGN_FIRST_AMPDU_QUEUE);
-
-	for (i = 0; i < IWLAGN_FIRST_AMPDU_QUEUE; i++) {
-		int fifo = queue_to_fifo[i].fifo;
-		int ac = queue_to_fifo[i].ac;
-
-		iwl_txq_ctx_activate(trans_pcie, i);
-
-		if (fifo == IWL_TX_FIFO_UNUSED)
-			continue;
-
-		if (ac != IWL_AC_UNSET)
-			iwl_set_swq_id(&trans_pcie->txq[i], ac, i);
-		iwl_trans_tx_queue_set_status(trans, &trans_pcie->txq[i],
-					      fifo, 0);
-	}
-
-	spin_unlock_irqrestore(&trans->shrd->lock, flags);
-
-	/* Enable L1-Active */
-	iwl_clear_bits_prph(bus(trans), APMG_PCIDEV_STT_REG,
-			  APMG_PCIDEV_STT_VAL_L1_ACT_DIS);
-}
-
-/**
- * iwlagn_txq_ctx_stop - Stop all Tx DMA channels
- */
-static int iwl_trans_tx_stop(struct iwl_trans *trans)
-{
-	int ch, txq_id;
-	unsigned long flags;
-	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-
-	/* Turn off all Tx DMA fifos */
-	spin_lock_irqsave(&trans->shrd->lock, flags);
-
-	iwl_trans_txq_set_sched(trans, 0);
-
-	/* Stop each Tx DMA channel, and wait for it to be idle */
-	for (ch = 0; ch < FH_TCSR_CHNL_NUM; ch++) {
-		iwl_write_direct32(bus(trans),
-				   FH_TCSR_CHNL_TX_CONFIG_REG(ch), 0x0);
-		if (iwl_poll_direct_bit(bus(trans), FH_TSSR_TX_STATUS_REG,
-				    FH_TSSR_TX_STATUS_REG_MSK_CHNL_IDLE(ch),
-				    1000))
-			IWL_ERR(trans, "Failing on timeout while stopping"
-			    " DMA channel %d [0x%08x]", ch,
-			    iwl_read_direct32(bus(trans),
-					      FH_TSSR_TX_STATUS_REG));
-	}
-	spin_unlock_irqrestore(&trans->shrd->lock, flags);
-
-	if (!trans_pcie->txq) {
-		IWL_WARN(trans, "Stopping tx queues that aren't allocated...");
-		return 0;
-	}
-
-	/* Unmap DMA from host system and free skb's */
-	for (txq_id = 0; txq_id < hw_params(trans).max_txq_num; txq_id++)
-		iwl_tx_queue_unmap(trans, txq_id);
-
-	return 0;
-}
-
-static void iwl_trans_pcie_disable_sync_irq(struct iwl_trans *trans)
-{
-	unsigned long flags;
-	struct iwl_trans_pcie *trans_pcie =
-		IWL_TRANS_GET_PCIE_TRANS(trans);
-
-	spin_lock_irqsave(&trans->shrd->lock, flags);
-	iwl_disable_interrupts(trans);
-	spin_unlock_irqrestore(&trans->shrd->lock, flags);
-
-	/* wait to make sure we flush pending tasklet*/
-	synchronize_irq(bus(trans)->irq);
-	tasklet_kill(&trans_pcie->irq_tasklet);
-}
-
-static void iwl_trans_pcie_stop_device(struct iwl_trans *trans)
-{
-	/* stop and reset the on-board processor */
-	iwl_write32(bus(trans), CSR_RESET, CSR_RESET_REG_FLAG_NEVO_RESET);
-
-	/* tell the device to stop sending interrupts */
-	iwl_trans_pcie_disable_sync_irq(trans);
-
-	/* device going down, Stop using ICT table */
-	iwl_disable_ict(trans);
-
-	/*
-	 * If a HW restart happens during firmware loading,
-	 * then the firmware loading might call this function
-	 * and later it might be called again due to the
-	 * restart. So don't process again if the device is
-	 * already dead.
-	 */
-	if (test_bit(STATUS_DEVICE_ENABLED, &trans->shrd->status)) {
-		iwl_trans_tx_stop(trans);
-		iwl_trans_rx_stop(trans);
-
-		/* Power-down device's busmaster DMA clocks */
-		iwl_write_prph(bus(trans), APMG_CLK_DIS_REG,
-			       APMG_CLK_VAL_DMA_CLK_RQT);
-		udelay(5);
-	}
-
-	/* Make sure (redundant) we've released our request to stay awake */
-	iwl_clear_bit(bus(trans), CSR_GP_CNTRL,
-			CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
-
-	/* Stop the device, and put it in low power state */
-	iwl_apm_stop(priv(trans));
-}
-
-static int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
-		struct iwl_device_cmd *dev_cmd, enum iwl_rxon_context_id ctx,
-		u8 sta_id)
-{
-	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
-	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-	struct iwl_tx_cmd *tx_cmd = &dev_cmd->cmd.tx;
-	struct iwl_cmd_meta *out_meta;
-	struct iwl_tx_queue *txq;
-	struct iwl_queue *q;
-
-	dma_addr_t phys_addr = 0;
-	dma_addr_t txcmd_phys;
-	dma_addr_t scratch_phys;
-	u16 len, firstlen, secondlen;
-	u16 seq_number = 0;
-	u8 wait_write_ptr = 0;
-	u8 txq_id;
-	u8 tid = 0;
-	bool is_agg = false;
-	__le16 fc = hdr->frame_control;
-	u8 hdr_len = ieee80211_hdrlen(fc);
-
-	/*
-	 * Send this frame after DTIM -- there's a special queue
-	 * reserved for this for contexts that support AP mode.
-	 */
-	if (info->flags & IEEE80211_TX_CTL_SEND_AFTER_DTIM) {
-		txq_id = trans_pcie->mcast_queue[ctx];
-
-		/*
-		 * The microcode will clear the more data
-		 * bit in the last frame it transmits.
-		 */
-		hdr->frame_control |=
-			cpu_to_le16(IEEE80211_FCTL_MOREDATA);
-	} else if (info->flags & IEEE80211_TX_CTL_TX_OFFCHAN)
-		txq_id = IWL_AUX_QUEUE;
-	else
-		txq_id =
-		    trans_pcie->ac_to_queue[ctx][skb_get_queue_mapping(skb)];
-
-	if (ieee80211_is_data_qos(fc)) {
-		u8 *qc = NULL;
-		struct iwl_tid_data *tid_data;
-		qc = ieee80211_get_qos_ctl(hdr);
-		tid = qc[0] & IEEE80211_QOS_CTL_TID_MASK;
-		tid_data = &trans->shrd->tid_data[sta_id][tid];
-
-		if (WARN_ON_ONCE(tid >= IWL_MAX_TID_COUNT))
-			return -1;
-
-		seq_number = tid_data->seq_number;
-		seq_number &= IEEE80211_SCTL_SEQ;
-		hdr->seq_ctrl = hdr->seq_ctrl &
-				cpu_to_le16(IEEE80211_SCTL_FRAG);
-		hdr->seq_ctrl |= cpu_to_le16(seq_number);
-		seq_number += 0x10;
-		/* aggregation is on for this <sta,tid> */
-		if (info->flags & IEEE80211_TX_CTL_AMPDU &&
-		    tid_data->agg.state == IWL_AGG_ON) {
-			txq_id = tid_data->agg.txq_id;
-			is_agg = true;
-		}
-	}
-
-	txq = &trans_pcie->txq[txq_id];
-	q = &txq->q;
-
-	/* Set up driver data for this TFD */
-	txq->skbs[q->write_ptr] = skb;
-	txq->cmd[q->write_ptr] = dev_cmd;
-
-	dev_cmd->hdr.cmd = REPLY_TX;
-	dev_cmd->hdr.sequence = cpu_to_le16((u16)(QUEUE_TO_SEQ(txq_id) |
-				INDEX_TO_SEQ(q->write_ptr)));
-
-	/* Set up first empty entry in queue's array of Tx/cmd buffers */
-	out_meta = &txq->meta[q->write_ptr];
-
-	/*
-	 * Use the first empty entry in this queue's command buffer array
-	 * to contain the Tx command and MAC header concatenated together
-	 * (payload data will be in another buffer).
-	 * Size of this varies, due to varying MAC header length.
-	 * If end is not dword aligned, we'll have 2 extra bytes at the end
-	 * of the MAC header (device reads on dword boundaries).
-	 * We'll tell device about this padding later.
-	 */
-	len = sizeof(struct iwl_tx_cmd) +
-		sizeof(struct iwl_cmd_header) + hdr_len;
-	firstlen = (len + 3) & ~3;
-
-	/* Tell NIC about any 2-byte padding after MAC header */
-	if (firstlen != len)
-		tx_cmd->tx_flags |= TX_CMD_FLG_MH_PAD_MSK;
-
-	/* Physical address of this Tx command's header (not MAC header!),
-	 * within command buffer array. */
-	txcmd_phys = dma_map_single(bus(trans)->dev,
-				    &dev_cmd->hdr, firstlen,
-				    DMA_BIDIRECTIONAL);
-	if (unlikely(dma_mapping_error(bus(trans)->dev, txcmd_phys)))
-		return -1;
-	dma_unmap_addr_set(out_meta, mapping, txcmd_phys);
-	dma_unmap_len_set(out_meta, len, firstlen);
-
-	if (!ieee80211_has_morefrags(fc)) {
-		txq->need_update = 1;
-	} else {
-		wait_write_ptr = 1;
-		txq->need_update = 0;
-	}
-
-	/* Set up TFD's 2nd entry to point directly to remainder of skb,
-	 * if any (802.11 null frames have no payload). */
-	secondlen = skb->len - hdr_len;
-	if (secondlen > 0) {
-		phys_addr = dma_map_single(bus(trans)->dev, skb->data + hdr_len,
-					   secondlen, DMA_TO_DEVICE);
-		if (unlikely(dma_mapping_error(bus(trans)->dev, phys_addr))) {
-			dma_unmap_single(bus(trans)->dev,
-					 dma_unmap_addr(out_meta, mapping),
-					 dma_unmap_len(out_meta, len),
-					 DMA_BIDIRECTIONAL);
-			return -1;
-		}
-	}
-
-	/* Attach buffers to TFD */
-	iwlagn_txq_attach_buf_to_tfd(trans, txq, txcmd_phys, firstlen, 1);
-	if (secondlen > 0)
-		iwlagn_txq_attach_buf_to_tfd(trans, txq, phys_addr,
-					     secondlen, 0);
-
-	scratch_phys = txcmd_phys + sizeof(struct iwl_cmd_header) +
-				offsetof(struct iwl_tx_cmd, scratch);
-
-	/* take back ownership of DMA buffer to enable update */
-	dma_sync_single_for_cpu(bus(trans)->dev, txcmd_phys, firstlen,
-			DMA_BIDIRECTIONAL);
-	tx_cmd->dram_lsb_ptr = cpu_to_le32(scratch_phys);
-	tx_cmd->dram_msb_ptr = iwl_get_dma_hi_addr(scratch_phys);
-
-	IWL_DEBUG_TX(trans, "sequence nr = 0X%x\n",
-		     le16_to_cpu(dev_cmd->hdr.sequence));
-	IWL_DEBUG_TX(trans, "tx_flags = 0X%x\n", le32_to_cpu(tx_cmd->tx_flags));
-	iwl_print_hex_dump(trans, IWL_DL_TX, (u8 *)tx_cmd, sizeof(*tx_cmd));
-	iwl_print_hex_dump(trans, IWL_DL_TX, (u8 *)tx_cmd->hdr, hdr_len);
-
-	/* Set up entry for this TFD in Tx byte-count array */
-	if (is_agg)
-		iwl_trans_txq_update_byte_cnt_tbl(trans, txq,
-					       le16_to_cpu(tx_cmd->len));
-
-	dma_sync_single_for_device(bus(trans)->dev, txcmd_phys, firstlen,
-			DMA_BIDIRECTIONAL);
-
-	trace_iwlwifi_dev_tx(priv(trans),
-			     &((struct iwl_tfd *)txq->tfds)[txq->q.write_ptr],
-			     sizeof(struct iwl_tfd),
-			     &dev_cmd->hdr, firstlen,
-			     skb->data + hdr_len, secondlen);
-
-	/* Tell device the write index *just past* this latest filled TFD */
-	q->write_ptr = iwl_queue_inc_wrap(q->write_ptr, q->n_bd);
-	iwl_txq_update_write_ptr(trans, txq);
-
-	if (ieee80211_is_data_qos(fc)) {
-		trans->shrd->tid_data[sta_id][tid].tfds_in_queue++;
-		if (!ieee80211_has_morefrags(fc))
-			trans->shrd->tid_data[sta_id][tid].seq_number =
-				seq_number;
-	}
-
-	/*
-	 * At this point the frame is "transmitted" successfully
-	 * and we will get a TX status notification eventually,
-	 * regardless of the value of ret. "ret" only indicates
-	 * whether or not we should update the write pointer.
-	 */
-	if (iwl_queue_space(q) < q->high_mark) {
-		if (wait_write_ptr) {
-			txq->need_update = 1;
-			iwl_txq_update_write_ptr(trans, txq);
-		} else {
-			iwl_stop_queue(trans, txq);
-		}
-	}
-	return 0;
-}
-
-static void iwl_trans_pcie_kick_nic(struct iwl_trans *trans)
-{
-	/* Remove all resets to allow NIC to operate */
-	iwl_write32(bus(trans), CSR_RESET, 0);
-}
-
-static int iwl_trans_pcie_request_irq(struct iwl_trans *trans)
-{
-	struct iwl_trans_pcie *trans_pcie =
-		IWL_TRANS_GET_PCIE_TRANS(trans);
-	int err;
-
-	trans_pcie->inta_mask = CSR_INI_SET_MASK;
-
-	tasklet_init(&trans_pcie->irq_tasklet, (void (*)(unsigned long))
-		iwl_irq_tasklet, (unsigned long)trans);
-
-	iwl_alloc_isr_ict(trans);
-
-	err = request_irq(bus(trans)->irq, iwl_isr_ict, IRQF_SHARED,
-		DRV_NAME, trans);
-	if (err) {
-		IWL_ERR(trans, "Error allocating IRQ %d\n", bus(trans)->irq);
-		iwl_free_isr_ict(trans);
-		return err;
-	}
-
-	INIT_WORK(&trans_pcie->rx_replenish, iwl_bg_rx_replenish);
-	return 0;
-}
-
-static int iwlagn_txq_check_empty(struct iwl_trans *trans,
-			   int sta_id, u8 tid, int txq_id)
-{
-	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-	struct iwl_queue *q = &trans_pcie->txq[txq_id].q;
-	struct iwl_tid_data *tid_data = &trans->shrd->tid_data[sta_id][tid];
-
-	lockdep_assert_held(&trans->shrd->sta_lock);
-
-	switch (trans->shrd->tid_data[sta_id][tid].agg.state) {
-	case IWL_EMPTYING_HW_QUEUE_DELBA:
-		/* We are reclaiming the last packet of the */
-		/* aggregated HW queue */
-		if ((txq_id  == tid_data->agg.txq_id) &&
-		    (q->read_ptr == q->write_ptr)) {
-			IWL_DEBUG_HT(trans,
-				"HW queue empty: continue DELBA flow\n");
-			iwl_trans_pcie_txq_agg_disable(trans, txq_id);
-			tid_data->agg.state = IWL_AGG_OFF;
-			iwl_stop_tx_ba_trans_ready(priv(trans),
-						   NUM_IWL_RXON_CTX,
-						   sta_id, tid);
-			iwl_wake_queue(trans, &trans_pcie->txq[txq_id]);
-		}
-		break;
-	case IWL_EMPTYING_HW_QUEUE_ADDBA:
-		/* We are reclaiming the last packet of the queue */
-		if (tid_data->tfds_in_queue == 0) {
-			IWL_DEBUG_HT(trans,
-				"HW queue empty: continue ADDBA flow\n");
-			tid_data->agg.state = IWL_AGG_ON;
-			iwl_start_tx_ba_trans_ready(priv(trans),
-						    NUM_IWL_RXON_CTX,
-						    sta_id, tid);
-		}
-		break;
-	default:
-		break;
-	}
-
-	return 0;
-}
-
-static void iwl_free_tfds_in_queue(struct iwl_trans *trans,
-			    int sta_id, int tid, int freed)
-{
-	lockdep_assert_held(&trans->shrd->sta_lock);
-
-	if (trans->shrd->tid_data[sta_id][tid].tfds_in_queue >= freed)
-		trans->shrd->tid_data[sta_id][tid].tfds_in_queue -= freed;
-	else {
-		IWL_DEBUG_TX(trans, "free more than tfds_in_queue (%u:%d)\n",
-			trans->shrd->tid_data[sta_id][tid].tfds_in_queue,
-			freed);
-		trans->shrd->tid_data[sta_id][tid].tfds_in_queue = 0;
-	}
-}
-
-static void iwl_trans_pcie_reclaim(struct iwl_trans *trans, int sta_id, int tid,
-		      int txq_id, int ssn, u32 status,
-		      struct sk_buff_head *skbs)
-{
-	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-	struct iwl_tx_queue *txq = &trans_pcie->txq[txq_id];
-	enum iwl_agg_state agg_state;
-	/* n_bd is usually 256 => n_bd - 1 = 0xff */
-	int tfd_num = ssn & (txq->q.n_bd - 1);
-	int freed = 0;
-	bool cond;
-
-	txq->time_stamp = jiffies;
-
-	if (txq->sched_retry) {
-		agg_state =
-			trans->shrd->tid_data[txq->sta_id][txq->tid].agg.state;
-		cond = (agg_state != IWL_EMPTYING_HW_QUEUE_DELBA);
-	} else {
-		cond = (status != TX_STATUS_FAIL_PASSIVE_NO_RX);
-	}
-
-	if (txq->q.read_ptr != tfd_num) {
-		IWL_DEBUG_TX_REPLY(trans, "Retry scheduler reclaim "
-				"scd_ssn=%d idx=%d txq=%d swq=%d\n",
-				ssn , tfd_num, txq_id, txq->swq_id);
-		freed = iwl_tx_queue_reclaim(trans, txq_id, tfd_num, skbs);
-		if (iwl_queue_space(&txq->q) > txq->q.low_mark && cond)
-			iwl_wake_queue(trans, txq);
-	}
-
-	iwl_free_tfds_in_queue(trans, sta_id, tid, freed);
-	iwlagn_txq_check_empty(trans, sta_id, tid, txq_id);
-}
-
-static void iwl_trans_pcie_free(struct iwl_trans *trans)
-{
-	iwl_trans_pcie_tx_free(trans);
-	iwl_trans_pcie_rx_free(trans);
-	free_irq(bus(trans)->irq, trans);
-	iwl_free_isr_ict(trans);
-	trans->shrd->trans = NULL;
-	kfree(trans);
-}
-
-#ifdef CONFIG_PM
-
-static int iwl_trans_pcie_suspend(struct iwl_trans *trans)
-{
-	/*
-	 * This function is called when system goes into suspend state
-	 * mac80211 will call iwl_mac_stop() from the mac80211 suspend function
-	 * first but since iwl_mac_stop() has no knowledge of who the caller is,
-	 * it will not call apm_ops.stop() to stop the DMA operation.
-	 * Calling apm_ops.stop here to make sure we stop the DMA.
-	 *
-	 * But of course ... if we have configured WoWLAN then we did other
-	 * things already :-)
-	 */
-	if (!trans->shrd->wowlan)
-		iwl_apm_stop(priv(trans));
-
-	return 0;
-}
-
-static int iwl_trans_pcie_resume(struct iwl_trans *trans)
-{
-	bool hw_rfkill = false;
-
-	iwl_enable_interrupts(trans);
-
-	if (!(iwl_read32(bus(trans), CSR_GP_CNTRL) &
-				CSR_GP_CNTRL_REG_FLAG_HW_RF_KILL_SW))
-		hw_rfkill = true;
-
-	if (hw_rfkill)
-		set_bit(STATUS_RF_KILL_HW, &trans->shrd->status);
-	else
-		clear_bit(STATUS_RF_KILL_HW, &trans->shrd->status);
-
-	iwl_set_hw_rfkill_state(priv(trans), hw_rfkill);
-
-	return 0;
-}
-#else /* CONFIG_PM */
-static int iwl_trans_pcie_suspend(struct iwl_trans *trans)
-{ return 0; }
-
-static int iwl_trans_pcie_resume(struct iwl_trans *trans)
-{ return 0; }
-
-#endif /* CONFIG_PM */
-
-static void iwl_trans_pcie_wake_any_queue(struct iwl_trans *trans,
-					  enum iwl_rxon_context_id ctx)
-{
-	u8 ac, txq_id;
-	struct iwl_trans_pcie *trans_pcie =
-		IWL_TRANS_GET_PCIE_TRANS(trans);
-
-	for (ac = 0; ac < AC_NUM; ac++) {
-		txq_id = trans_pcie->ac_to_queue[ctx][ac];
-		IWL_DEBUG_INFO(trans, "Queue Status: Q[%d] %s\n",
-			ac,
-			(atomic_read(&trans_pcie->queue_stop_count[ac]) > 0)
-			      ? "stopped" : "awake");
-		iwl_wake_queue(trans, &trans_pcie->txq[txq_id]);
-	}
-}
-
-const struct iwl_trans_ops trans_ops_pcie;
-
-static struct iwl_trans *iwl_trans_pcie_alloc(struct iwl_shared *shrd)
-{
-	struct iwl_trans *iwl_trans = kzalloc(sizeof(struct iwl_trans) +
-					      sizeof(struct iwl_trans_pcie),
-					      GFP_KERNEL);
-	if (iwl_trans) {
-		struct iwl_trans_pcie *trans_pcie =
-			IWL_TRANS_GET_PCIE_TRANS(iwl_trans);
-		iwl_trans->ops = &trans_ops_pcie;
-		iwl_trans->shrd = shrd;
-		trans_pcie->trans = iwl_trans;
-		spin_lock_init(&iwl_trans->hcmd_lock);
-	}
-
-	return iwl_trans;
-}
-
-static void iwl_trans_pcie_stop_queue(struct iwl_trans *trans, int txq_id)
-{
-	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-
-	iwl_stop_queue(trans, &trans_pcie->txq[txq_id]);
-}
-
-#define IWL_FLUSH_WAIT_MS	2000
-
-static int iwl_trans_pcie_wait_tx_queue_empty(struct iwl_trans *trans)
-{
-	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-	struct iwl_tx_queue *txq;
-	struct iwl_queue *q;
-	int cnt;
-	unsigned long now = jiffies;
-	int ret = 0;
-
-	/* waiting for all the tx frames complete might take a while */
-	for (cnt = 0; cnt < hw_params(trans).max_txq_num; cnt++) {
-		if (cnt == trans->shrd->cmd_queue)
-			continue;
-		txq = &trans_pcie->txq[cnt];
-		q = &txq->q;
-		while (q->read_ptr != q->write_ptr && !time_after(jiffies,
-		       now + msecs_to_jiffies(IWL_FLUSH_WAIT_MS)))
-			msleep(1);
-
-		if (q->read_ptr != q->write_ptr) {
-			IWL_ERR(trans, "fail to flush all tx fifo queues\n");
-			ret = -ETIMEDOUT;
-			break;
-		}
-	}
-	return ret;
-}
-
-/*
- * On every watchdog tick we check (latest) time stamp. If it does not
- * change during timeout period and queue is not empty we reset firmware.
- */
-static int iwl_trans_pcie_check_stuck_queue(struct iwl_trans *trans, int cnt)
-{
-	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-	struct iwl_tx_queue *txq = &trans_pcie->txq[cnt];
-	struct iwl_queue *q = &txq->q;
-	unsigned long timeout;
-
-	if (q->read_ptr == q->write_ptr) {
-		txq->time_stamp = jiffies;
-		return 0;
-	}
-
-	timeout = txq->time_stamp +
-		  msecs_to_jiffies(hw_params(trans).wd_timeout);
-
-	if (time_after(jiffies, timeout)) {
-		IWL_ERR(trans, "Queue %d stuck for %u ms.\n", q->id,
-			hw_params(trans).wd_timeout);
-		IWL_ERR(trans, "Current read_ptr %d write_ptr %d\n",
-			q->read_ptr, q->write_ptr);
-		return 1;
-	}
-
-	return 0;
-}
-
-static const char *get_fh_string(int cmd)
-{
-	switch (cmd) {
-	IWL_CMD(FH_RSCSR_CHNL0_STTS_WPTR_REG);
-	IWL_CMD(FH_RSCSR_CHNL0_RBDCB_BASE_REG);
-	IWL_CMD(FH_RSCSR_CHNL0_WPTR);
-	IWL_CMD(FH_MEM_RCSR_CHNL0_CONFIG_REG);
-	IWL_CMD(FH_MEM_RSSR_SHARED_CTRL_REG);
-	IWL_CMD(FH_MEM_RSSR_RX_STATUS_REG);
-	IWL_CMD(FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV);
-	IWL_CMD(FH_TSSR_TX_STATUS_REG);
-	IWL_CMD(FH_TSSR_TX_ERROR_REG);
-	default:
-		return "UNKNOWN";
-	}
-}
-
-int iwl_dump_fh(struct iwl_trans *trans, char **buf, bool display)
-{
-	int i;
-#ifdef CONFIG_IWLWIFI_DEBUG
-	int pos = 0;
-	size_t bufsz = 0;
-#endif
-	static const u32 fh_tbl[] = {
-		FH_RSCSR_CHNL0_STTS_WPTR_REG,
-		FH_RSCSR_CHNL0_RBDCB_BASE_REG,
-		FH_RSCSR_CHNL0_WPTR,
-		FH_MEM_RCSR_CHNL0_CONFIG_REG,
-		FH_MEM_RSSR_SHARED_CTRL_REG,
-		FH_MEM_RSSR_RX_STATUS_REG,
-		FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV,
-		FH_TSSR_TX_STATUS_REG,
-		FH_TSSR_TX_ERROR_REG
-	};
-#ifdef CONFIG_IWLWIFI_DEBUG
-	if (display) {
-		bufsz = ARRAY_SIZE(fh_tbl) * 48 + 40;
-		*buf = kmalloc(bufsz, GFP_KERNEL);
-		if (!*buf)
-			return -ENOMEM;
-		pos += scnprintf(*buf + pos, bufsz - pos,
-				"FH register values:\n");
-		for (i = 0; i < ARRAY_SIZE(fh_tbl); i++) {
-			pos += scnprintf(*buf + pos, bufsz - pos,
-				"  %34s: 0X%08x\n",
-				get_fh_string(fh_tbl[i]),
-				iwl_read_direct32(bus(trans), fh_tbl[i]));
-		}
-		return pos;
-	}
-#endif
-	IWL_ERR(trans, "FH register values:\n");
-	for (i = 0; i <  ARRAY_SIZE(fh_tbl); i++) {
-		IWL_ERR(trans, "  %34s: 0X%08x\n",
-			get_fh_string(fh_tbl[i]),
-			iwl_read_direct32(bus(trans), fh_tbl[i]));
-	}
-	return 0;
-}
-
-static const char *get_csr_string(int cmd)
-{
-	switch (cmd) {
-	IWL_CMD(CSR_HW_IF_CONFIG_REG);
-	IWL_CMD(CSR_INT_COALESCING);
-	IWL_CMD(CSR_INT);
-	IWL_CMD(CSR_INT_MASK);
-	IWL_CMD(CSR_FH_INT_STATUS);
-	IWL_CMD(CSR_GPIO_IN);
-	IWL_CMD(CSR_RESET);
-	IWL_CMD(CSR_GP_CNTRL);
-	IWL_CMD(CSR_HW_REV);
-	IWL_CMD(CSR_EEPROM_REG);
-	IWL_CMD(CSR_EEPROM_GP);
-	IWL_CMD(CSR_OTP_GP_REG);
-	IWL_CMD(CSR_GIO_REG);
-	IWL_CMD(CSR_GP_UCODE_REG);
-	IWL_CMD(CSR_GP_DRIVER_REG);
-	IWL_CMD(CSR_UCODE_DRV_GP1);
-	IWL_CMD(CSR_UCODE_DRV_GP2);
-	IWL_CMD(CSR_LED_REG);
-	IWL_CMD(CSR_DRAM_INT_TBL_REG);
-	IWL_CMD(CSR_GIO_CHICKEN_BITS);
-	IWL_CMD(CSR_ANA_PLL_CFG);
-	IWL_CMD(CSR_HW_REV_WA_REG);
-	IWL_CMD(CSR_DBG_HPET_MEM_REG);
-	default:
-		return "UNKNOWN";
-	}
-}
-
-void iwl_dump_csr(struct iwl_trans *trans)
-{
-	int i;
-	static const u32 csr_tbl[] = {
-		CSR_HW_IF_CONFIG_REG,
-		CSR_INT_COALESCING,
-		CSR_INT,
-		CSR_INT_MASK,
-		CSR_FH_INT_STATUS,
-		CSR_GPIO_IN,
-		CSR_RESET,
-		CSR_GP_CNTRL,
-		CSR_HW_REV,
-		CSR_EEPROM_REG,
-		CSR_EEPROM_GP,
-		CSR_OTP_GP_REG,
-		CSR_GIO_REG,
-		CSR_GP_UCODE_REG,
-		CSR_GP_DRIVER_REG,
-		CSR_UCODE_DRV_GP1,
-		CSR_UCODE_DRV_GP2,
-		CSR_LED_REG,
-		CSR_DRAM_INT_TBL_REG,
-		CSR_GIO_CHICKEN_BITS,
-		CSR_ANA_PLL_CFG,
-		CSR_HW_REV_WA_REG,
-		CSR_DBG_HPET_MEM_REG
-	};
-	IWL_ERR(trans, "CSR values:\n");
-	IWL_ERR(trans, "(2nd byte of CSR_INT_COALESCING is "
-		"CSR_INT_PERIODIC_REG)\n");
-	for (i = 0; i <  ARRAY_SIZE(csr_tbl); i++) {
-		IWL_ERR(trans, "  %25s: 0X%08x\n",
-			get_csr_string(csr_tbl[i]),
-			iwl_read32(bus(trans), csr_tbl[i]));
-	}
-}
-
-#ifdef CONFIG_IWLWIFI_DEBUGFS
-/* create and remove of files */
-#define DEBUGFS_ADD_FILE(name, parent, mode) do {			\
-	if (!debugfs_create_file(#name, mode, parent, trans,		\
-				 &iwl_dbgfs_##name##_ops))		\
-		return -ENOMEM;						\
-} while (0)
-
-/* file operation */
-#define DEBUGFS_READ_FUNC(name)                                         \
-static ssize_t iwl_dbgfs_##name##_read(struct file *file,               \
-					char __user *user_buf,          \
-					size_t count, loff_t *ppos);
-
-#define DEBUGFS_WRITE_FUNC(name)                                        \
-static ssize_t iwl_dbgfs_##name##_write(struct file *file,              \
-					const char __user *user_buf,    \
-					size_t count, loff_t *ppos);
-
-
-static int iwl_dbgfs_open_file_generic(struct inode *inode, struct file *file)
-{
-	file->private_data = inode->i_private;
-	return 0;
-}
-
-#define DEBUGFS_READ_FILE_OPS(name)					\
-	DEBUGFS_READ_FUNC(name);					\
-static const struct file_operations iwl_dbgfs_##name##_ops = {		\
-	.read = iwl_dbgfs_##name##_read,				\
-	.open = iwl_dbgfs_open_file_generic,				\
-	.llseek = generic_file_llseek,					\
-};
-
-#define DEBUGFS_WRITE_FILE_OPS(name)                                    \
-	DEBUGFS_WRITE_FUNC(name);                                       \
-static const struct file_operations iwl_dbgfs_##name##_ops = {          \
-	.write = iwl_dbgfs_##name##_write,                              \
-	.open = iwl_dbgfs_open_file_generic,				\
-	.llseek = generic_file_llseek,					\
-};
-
-#define DEBUGFS_READ_WRITE_FILE_OPS(name)				\
-	DEBUGFS_READ_FUNC(name);					\
-	DEBUGFS_WRITE_FUNC(name);					\
-static const struct file_operations iwl_dbgfs_##name##_ops = {		\
-	.write = iwl_dbgfs_##name##_write,				\
-	.read = iwl_dbgfs_##name##_read,				\
-	.open = iwl_dbgfs_open_file_generic,				\
-	.llseek = generic_file_llseek,					\
-};
-
-static ssize_t iwl_dbgfs_tx_queue_read(struct file *file,
-						char __user *user_buf,
-						size_t count, loff_t *ppos)
-{
-	struct iwl_trans *trans = file->private_data;
-	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-	struct iwl_tx_queue *txq;
-	struct iwl_queue *q;
-	char *buf;
-	int pos = 0;
-	int cnt;
-	int ret;
-	const size_t bufsz = sizeof(char) * 64 * hw_params(trans).max_txq_num;
-
-	if (!trans_pcie->txq) {
-		IWL_ERR(trans, "txq not ready\n");
-		return -EAGAIN;
-	}
-	buf = kzalloc(bufsz, GFP_KERNEL);
-	if (!buf)
-		return -ENOMEM;
-
-	for (cnt = 0; cnt < hw_params(trans).max_txq_num; cnt++) {
-		txq = &trans_pcie->txq[cnt];
-		q = &txq->q;
-		pos += scnprintf(buf + pos, bufsz - pos,
-				"hwq %.2d: read=%u write=%u stop=%d"
-				" swq_id=%#.2x (ac %d/hwq %d)\n",
-				cnt, q->read_ptr, q->write_ptr,
-				!!test_bit(cnt, trans_pcie->queue_stopped),
-				txq->swq_id, txq->swq_id & 3,
-				(txq->swq_id >> 2) & 0x1f);
-		if (cnt >= 4)
-			continue;
-		/* for the ACs, display the stop count too */
-		pos += scnprintf(buf + pos, bufsz - pos,
-			"        stop-count: %d\n",
-			atomic_read(&trans_pcie->queue_stop_count[cnt]));
-	}
-	ret = simple_read_from_buffer(user_buf, count, ppos, buf, pos);
-	kfree(buf);
-	return ret;
-}
-
-static ssize_t iwl_dbgfs_rx_queue_read(struct file *file,
-						char __user *user_buf,
-						size_t count, loff_t *ppos) {
-	struct iwl_trans *trans = file->private_data;
-	struct iwl_trans_pcie *trans_pcie =
-		IWL_TRANS_GET_PCIE_TRANS(trans);
-	struct iwl_rx_queue *rxq = &trans_pcie->rxq;
-	char buf[256];
-	int pos = 0;
-	const size_t bufsz = sizeof(buf);
-
-	pos += scnprintf(buf + pos, bufsz - pos, "read: %u\n",
-						rxq->read);
-	pos += scnprintf(buf + pos, bufsz - pos, "write: %u\n",
-						rxq->write);
-	pos += scnprintf(buf + pos, bufsz - pos, "free_count: %u\n",
-						rxq->free_count);
-	if (rxq->rb_stts) {
-		pos += scnprintf(buf + pos, bufsz - pos, "closed_rb_num: %u\n",
-			 le16_to_cpu(rxq->rb_stts->closed_rb_num) &  0x0FFF);
-	} else {
-		pos += scnprintf(buf + pos, bufsz - pos,
-					"closed_rb_num: Not Allocated\n");
-	}
-	return simple_read_from_buffer(user_buf, count, ppos, buf, pos);
-}
-
-static ssize_t iwl_dbgfs_log_event_read(struct file *file,
-					 char __user *user_buf,
-					 size_t count, loff_t *ppos)
-{
-	struct iwl_trans *trans = file->private_data;
-	char *buf;
-	int pos = 0;
-	ssize_t ret = -ENOMEM;
-
-	ret = pos = iwl_dump_nic_event_log(trans, true, &buf, true);
-	if (buf) {
-		ret = simple_read_from_buffer(user_buf, count, ppos, buf, pos);
-		kfree(buf);
-	}
-	return ret;
-}
-
-static ssize_t iwl_dbgfs_log_event_write(struct file *file,
-					const char __user *user_buf,
-					size_t count, loff_t *ppos)
-{
-	struct iwl_trans *trans = file->private_data;
-	u32 event_log_flag;
-	char buf[8];
-	int buf_size;
-
-	memset(buf, 0, sizeof(buf));
-	buf_size = min(count, sizeof(buf) -  1);
-	if (copy_from_user(buf, user_buf, buf_size))
-		return -EFAULT;
-	if (sscanf(buf, "%d", &event_log_flag) != 1)
-		return -EFAULT;
-	if (event_log_flag == 1)
-		iwl_dump_nic_event_log(trans, true, NULL, false);
-
-	return count;
-}
-
-static ssize_t iwl_dbgfs_interrupt_read(struct file *file,
-					char __user *user_buf,
-					size_t count, loff_t *ppos) {
-
-	struct iwl_trans *trans = file->private_data;
-	struct iwl_trans_pcie *trans_pcie =
-		IWL_TRANS_GET_PCIE_TRANS(trans);
-	struct isr_statistics *isr_stats = &trans_pcie->isr_stats;
-
-	int pos = 0;
-	char *buf;
-	int bufsz = 24 * 64; /* 24 items * 64 char per item */
-	ssize_t ret;
-
-	buf = kzalloc(bufsz, GFP_KERNEL);
-	if (!buf) {
-		IWL_ERR(trans, "Can not allocate Buffer\n");
-		return -ENOMEM;
-	}
-
-	pos += scnprintf(buf + pos, bufsz - pos,
-			"Interrupt Statistics Report:\n");
-
-	pos += scnprintf(buf + pos, bufsz - pos, "HW Error:\t\t\t %u\n",
-		isr_stats->hw);
-	pos += scnprintf(buf + pos, bufsz - pos, "SW Error:\t\t\t %u\n",
-		isr_stats->sw);
-	if (isr_stats->sw || isr_stats->hw) {
-		pos += scnprintf(buf + pos, bufsz - pos,
-			"\tLast Restarting Code:  0x%X\n",
-			isr_stats->err_code);
-	}
-#ifdef CONFIG_IWLWIFI_DEBUG
-	pos += scnprintf(buf + pos, bufsz - pos, "Frame transmitted:\t\t %u\n",
-		isr_stats->sch);
-	pos += scnprintf(buf + pos, bufsz - pos, "Alive interrupt:\t\t %u\n",
-		isr_stats->alive);
-#endif
-	pos += scnprintf(buf + pos, bufsz - pos,
-		"HW RF KILL switch toggled:\t %u\n", isr_stats->rfkill);
-
-	pos += scnprintf(buf + pos, bufsz - pos, "CT KILL:\t\t\t %u\n",
-		isr_stats->ctkill);
-
-	pos += scnprintf(buf + pos, bufsz - pos, "Wakeup Interrupt:\t\t %u\n",
-		isr_stats->wakeup);
-
-	pos += scnprintf(buf + pos, bufsz - pos,
-		"Rx command responses:\t\t %u\n", isr_stats->rx);
-
-	pos += scnprintf(buf + pos, bufsz - pos, "Tx/FH interrupt:\t\t %u\n",
-		isr_stats->tx);
-
-	pos += scnprintf(buf + pos, bufsz - pos, "Unexpected INTA:\t\t %u\n",
-		isr_stats->unhandled);
-
-	ret = simple_read_from_buffer(user_buf, count, ppos, buf, pos);
-	kfree(buf);
-	return ret;
-}
-
-static ssize_t iwl_dbgfs_interrupt_write(struct file *file,
-					 const char __user *user_buf,
-					 size_t count, loff_t *ppos)
-{
-	struct iwl_trans *trans = file->private_data;
-	struct iwl_trans_pcie *trans_pcie =
-		IWL_TRANS_GET_PCIE_TRANS(trans);
-	struct isr_statistics *isr_stats = &trans_pcie->isr_stats;
-
-	char buf[8];
-	int buf_size;
-	u32 reset_flag;
-
-	memset(buf, 0, sizeof(buf));
-	buf_size = min(count, sizeof(buf) -  1);
-	if (copy_from_user(buf, user_buf, buf_size))
-		return -EFAULT;
-	if (sscanf(buf, "%x", &reset_flag) != 1)
-		return -EFAULT;
-	if (reset_flag == 0)
-		memset(isr_stats, 0, sizeof(*isr_stats));
-
-	return count;
-}
-
-static ssize_t iwl_dbgfs_csr_write(struct file *file,
-					 const char __user *user_buf,
-					 size_t count, loff_t *ppos)
-{
-	struct iwl_trans *trans = file->private_data;
-	char buf[8];
-	int buf_size;
-	int csr;
-
-	memset(buf, 0, sizeof(buf));
-	buf_size = min(count, sizeof(buf) -  1);
-	if (copy_from_user(buf, user_buf, buf_size))
-		return -EFAULT;
-	if (sscanf(buf, "%d", &csr) != 1)
-		return -EFAULT;
-
-	iwl_dump_csr(trans);
-
-	return count;
-}
-
-static ssize_t iwl_dbgfs_fh_reg_read(struct file *file,
-					 char __user *user_buf,
-					 size_t count, loff_t *ppos)
-{
-	struct iwl_trans *trans = file->private_data;
-	char *buf;
-	int pos = 0;
-	ssize_t ret = -EFAULT;
-
-	ret = pos = iwl_dump_fh(trans, &buf, true);
-	if (buf) {
-		ret = simple_read_from_buffer(user_buf,
-					      count, ppos, buf, pos);
-		kfree(buf);
-	}
-
-	return ret;
-}
-
-DEBUGFS_READ_WRITE_FILE_OPS(log_event);
-DEBUGFS_READ_WRITE_FILE_OPS(interrupt);
-DEBUGFS_READ_FILE_OPS(fh_reg);
-DEBUGFS_READ_FILE_OPS(rx_queue);
-DEBUGFS_READ_FILE_OPS(tx_queue);
-DEBUGFS_WRITE_FILE_OPS(csr);
-
-/*
- * Create the debugfs files and directories
- *
- */
-static int iwl_trans_pcie_dbgfs_register(struct iwl_trans *trans,
-					struct dentry *dir)
-{
-	DEBUGFS_ADD_FILE(rx_queue, dir, S_IRUSR);
-	DEBUGFS_ADD_FILE(tx_queue, dir, S_IRUSR);
-	DEBUGFS_ADD_FILE(log_event, dir, S_IWUSR | S_IRUSR);
-	DEBUGFS_ADD_FILE(interrupt, dir, S_IWUSR | S_IRUSR);
-	DEBUGFS_ADD_FILE(csr, dir, S_IWUSR);
-	DEBUGFS_ADD_FILE(fh_reg, dir, S_IRUSR);
-	return 0;
-}
-#else
-static int iwl_trans_pcie_dbgfs_register(struct iwl_trans *trans,
-					struct dentry *dir)
-{ return 0; }
-
-#endif /*CONFIG_IWLWIFI_DEBUGFS */
-
-const struct iwl_trans_ops trans_ops_pcie = {
-	.alloc = iwl_trans_pcie_alloc,
-	.request_irq = iwl_trans_pcie_request_irq,
-	.start_device = iwl_trans_pcie_start_device,
-	.prepare_card_hw = iwl_trans_pcie_prepare_card_hw,
-	.stop_device = iwl_trans_pcie_stop_device,
-
-	.tx_start = iwl_trans_pcie_tx_start,
-	.wake_any_queue = iwl_trans_pcie_wake_any_queue,
-
-	.send_cmd = iwl_trans_pcie_send_cmd,
-	.send_cmd_pdu = iwl_trans_pcie_send_cmd_pdu,
-
-	.tx = iwl_trans_pcie_tx,
-	.reclaim = iwl_trans_pcie_reclaim,
-
-	.tx_agg_disable = iwl_trans_pcie_tx_agg_disable,
-	.tx_agg_alloc = iwl_trans_pcie_tx_agg_alloc,
-	.tx_agg_setup = iwl_trans_pcie_tx_agg_setup,
-
-	.kick_nic = iwl_trans_pcie_kick_nic,
-
-	.free = iwl_trans_pcie_free,
-	.stop_queue = iwl_trans_pcie_stop_queue,
-
-	.dbgfs_register = iwl_trans_pcie_dbgfs_register,
-
-	.wait_tx_queue_empty = iwl_trans_pcie_wait_tx_queue_empty,
-	.check_stuck_queue = iwl_trans_pcie_check_stuck_queue,
-
-	.suspend = iwl_trans_pcie_suspend,
-	.resume = iwl_trans_pcie_resume,
-};
-
-- 
1.7.0.4

