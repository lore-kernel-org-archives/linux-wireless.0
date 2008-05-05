Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:39343 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753717AbYEECYF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 May 2008 22:24:05 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 01/25] iwlwifi: move RX code to iwl-rx.c
Date: Mon,  5 May 2008 10:22:28 +0800
Message-Id: <1209954172-3092-2-git-send-email-yi.zhu@intel.com> (sfid-20080505_042332_991009_408E7997)
In-Reply-To: <1209954172-3092-1-git-send-email-yi.zhu@intel.com>
References: <1209954172-3092-1-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch moves partialy rx code into iwl-rx.c as part of iwlcore.
The second part of the code can be merged only with moving of tx
code as well.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/Makefile       |    3 +-
 drivers/net/wireless/iwlwifi/iwl-4965.c     |   25 +-
 drivers/net/wireless/iwlwifi/iwl-core.h     |   16 +
 drivers/net/wireless/iwlwifi/iwl-dev.h      |   26 +-
 drivers/net/wireless/iwlwifi/iwl-rx.c       |  371 ++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl4965-base.c |  545 ++++++---------------------
 6 files changed, 518 insertions(+), 468 deletions(-)
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-rx.c

diff --git a/drivers/net/wireless/iwlwifi/Makefile b/drivers/net/wireless/iwlwifi/Makefile
index f733673..8bed908 100644
--- a/drivers/net/wireless/iwlwifi/Makefile
+++ b/drivers/net/wireless/iwlwifi/Makefile
@@ -1,5 +1,6 @@
 obj-$(CONFIG_IWLCORE)	:= iwlcore.o
-iwlcore-objs 		:= iwl-core.o iwl-eeprom.o iwl-hcmd.o iwl-power.o
+iwlcore-objs 		= iwl-core.o iwl-eeprom.o iwl-hcmd.o iwl-power.o
+iwlcore-objs 		+= iwl-rx.o
 iwlcore-$(CONFIG_IWLWIFI_DEBUGFS) += iwl-debugfs.o
 iwlcore-$(CONFIG_IWLWIFI_LEDS) += iwl-led.o
 iwlcore-$(CONFIG_IWLWIFI_RFKILL) += iwl-rfkill.o
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 9546582..20c5deb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -372,7 +372,7 @@ int iwl4965_set_pwr_src(struct iwl_priv *priv, enum iwl_pwr_src src)
 	return ret;
 }
 
-static int iwl4965_rx_init(struct iwl_priv *priv, struct iwl4965_rx_queue *rxq)
+static int iwl4965_rx_init(struct iwl_priv *priv, struct iwl_rx_queue *rxq)
 {
 	int ret;
 	unsigned long flags;
@@ -625,7 +625,7 @@ static void iwl4965_nic_config(struct iwl_priv *priv)
 int iwl4965_hw_nic_init(struct iwl_priv *priv)
 {
 	unsigned long flags;
-	struct iwl4965_rx_queue *rxq = &priv->rxq;
+	struct iwl_rx_queue *rxq = &priv->rxq;
 	int ret;
 
 	/* nic_init */
@@ -645,22 +645,22 @@ int iwl4965_hw_nic_init(struct iwl_priv *priv)
 
 	/* Allocate the RX queue, or reset if it is already allocated */
 	if (!rxq->bd) {
-		ret = iwl4965_rx_queue_alloc(priv);
+		ret = iwl_rx_queue_alloc(priv);
 		if (ret) {
 			IWL_ERROR("Unable to initialize Rx queue\n");
 			return -ENOMEM;
 		}
 	} else
-		iwl4965_rx_queue_reset(priv, rxq);
+		iwl_rx_queue_reset(priv, rxq);
 
-	iwl4965_rx_replenish(priv);
+	iwl_rx_replenish(priv);
 
 	iwl4965_rx_init(priv, rxq);
 
 	spin_lock_irqsave(&priv->lock, flags);
 
 	rxq->need_update = 1;
-	iwl4965_rx_queue_update_write_ptr(priv, rxq);
+	iwl_rx_queue_update_write_ptr(priv, rxq);
 
 	spin_unlock_irqrestore(&priv->lock, flags);
 
@@ -2516,7 +2516,8 @@ static void iwl4965_rx_calc_noise(struct iwl_priv *priv)
 			priv->last_rx_noise);
 }
 
-void iwl4965_hw_rx_statistics(struct iwl_priv *priv, struct iwl4965_rx_mem_buffer *rxb)
+void iwl4965_hw_rx_statistics(struct iwl_priv *priv,
+			      struct iwl_rx_mem_buffer *rxb)
 {
 	struct iwl4965_rx_packet *pkt = (void *)rxb->skb->data;
 	int change;
@@ -2803,7 +2804,7 @@ static u32 iwl4965_translate_rx_status(u32 decrypt_in)
 
 static void iwl4965_handle_data_packet(struct iwl_priv *priv, int is_data,
 				       int include_phy,
-				       struct iwl4965_rx_mem_buffer *rxb,
+				       struct iwl_rx_mem_buffer *rxb,
 				       struct ieee80211_rx_status *stats)
 {
 	struct iwl4965_rx_packet *pkt = (struct iwl4965_rx_packet *)rxb->skb->data;
@@ -3109,7 +3110,7 @@ static inline void iwl4965_dbg_report_frame(struct iwl_priv *priv,
 /* Called for REPLY_RX (legacy ABG frames), or
  * REPLY_RX_MPDU_CMD (HT high-throughput N frames). */
 static void iwl4965_rx_reply_rx(struct iwl_priv *priv,
-				struct iwl4965_rx_mem_buffer *rxb)
+				struct iwl_rx_mem_buffer *rxb)
 {
 	struct ieee80211_hdr *header;
 	struct ieee80211_rx_status rx_status;
@@ -3278,7 +3279,7 @@ static void iwl4965_rx_reply_rx(struct iwl_priv *priv,
 /* Cache phy data (Rx signal strength, etc) for HT frame (REPLY_RX_PHY_CMD).
  * This will be used later in iwl4965_rx_reply_rx() for REPLY_RX_MPDU_CMD. */
 static void iwl4965_rx_reply_rx_phy(struct iwl_priv *priv,
-				    struct iwl4965_rx_mem_buffer *rxb)
+				    struct iwl_rx_mem_buffer *rxb)
 {
 	struct iwl4965_rx_packet *pkt = (void *)rxb->skb->data;
 	priv->last_phy_res[0] = 1;
@@ -3286,7 +3287,7 @@ static void iwl4965_rx_reply_rx_phy(struct iwl_priv *priv,
 	       sizeof(struct iwl4965_rx_phy_res));
 }
 static void iwl4965_rx_missed_beacon_notif(struct iwl_priv *priv,
-					   struct iwl4965_rx_mem_buffer *rxb)
+					   struct iwl_rx_mem_buffer *rxb)
 
 {
 #ifdef CONFIG_IWL4965_RUN_TIME_CALIB
@@ -3495,7 +3496,7 @@ static inline int iwl4965_queue_dec_wrap(int index, int n_bd)
  * of frames sent via aggregation.
  */
 static void iwl4965_rx_reply_compressed_ba(struct iwl_priv *priv,
-					   struct iwl4965_rx_mem_buffer *rxb)
+					   struct iwl_rx_mem_buffer *rxb)
 {
 	struct iwl4965_rx_packet *pkt = (void *)rxb->skb->data;
 	struct iwl4965_compressed_ba_resp *ba_resp = &pkt->u.compressed_ba;
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 369f182..2356cad 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -174,6 +174,21 @@ void iwlcore_free_geos(struct iwl_priv *priv);
 int iwl_setup(struct iwl_priv *priv);
 
 /*****************************************************
+* RX
+******************************************************/
+void iwl_rx_queue_free(struct iwl_priv *priv, struct iwl_rx_queue *rxq);
+int iwl_rx_queue_alloc(struct iwl_priv *priv);
+void iwl_rx_handle(struct iwl_priv *priv);
+int iwl_rx_queue_update_write_ptr(struct iwl_priv *priv,
+				  struct iwl_rx_queue *q);
+void iwl_rx_queue_reset(struct iwl_priv *priv, struct iwl_rx_queue *rxq);
+void iwl_rx_replenish(struct iwl_priv *priv);
+/* FIXME: remove when TX is moved to iwl core */
+int iwl_rx_queue_restock(struct iwl_priv *priv);
+int iwl_rx_queue_space(const struct iwl_rx_queue *q);
+void iwl_rx_allocate(struct iwl_priv *priv);
+
+/*****************************************************
  *   S e n d i n g     H o s t     C o m m a n d s   *
  *****************************************************/
 
@@ -265,4 +280,5 @@ static inline int iwl_send_rxon_assoc(struct iwl_priv *priv)
 	return priv->cfg->ops->hcmd->rxon_assoc(priv);
 }
 
+
 #endif /* __iwl_core_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 78aba21..1d80ad7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -91,7 +91,7 @@ extern struct iwl_cfg iwl5350_agn_cfg;
 #define	DEFAULT_SHORT_RETRY_LIMIT 7U
 #define	DEFAULT_LONG_RETRY_LIMIT  4U
 
-struct iwl4965_rx_mem_buffer {
+struct iwl_rx_mem_buffer {
 	dma_addr_t dma_addr;
 	struct sk_buff *skb;
 	struct list_head list;
@@ -358,7 +358,7 @@ struct iwl_host_cmd {
 #define SUP_RATE_11G_MAX_NUM_CHANNELS  12
 
 /**
- * struct iwl4965_rx_queue - Rx queue
+ * struct iwl_rx_queue - Rx queue
  * @processed: Internal index to last handled Rx packet
  * @read: Shared index to newest available Rx buffer
  * @write: Shared index to oldest written Rx packet
@@ -367,13 +367,13 @@ struct iwl_host_cmd {
  * @rx_used: List of Rx buffers with no SKB
  * @need_update: flag to indicate we need to update read/write index
  *
- * NOTE:  rx_free and rx_used are used as a FIFO for iwl4965_rx_mem_buffers
+ * NOTE:  rx_free and rx_used are used as a FIFO for iwl_rx_mem_buffers
  */
-struct iwl4965_rx_queue {
+struct iwl_rx_queue {
 	__le32 *bd;
 	dma_addr_t dma_addr;
-	struct iwl4965_rx_mem_buffer pool[RX_QUEUE_SIZE + RX_FREE_BUFFERS];
-	struct iwl4965_rx_mem_buffer *queue[RX_QUEUE_SIZE];
+	struct iwl_rx_mem_buffer pool[RX_QUEUE_SIZE + RX_FREE_BUFFERS];
+	struct iwl_rx_mem_buffer *queue[RX_QUEUE_SIZE];
 	u32 processed;
 	u32 read;
 	u32 write;
@@ -643,26 +643,20 @@ extern int iwl4965_is_network_packet(struct iwl_priv *priv,
 				 struct ieee80211_hdr *header);
 extern int iwl4965_power_init_handle(struct iwl_priv *priv);
 extern void iwl4965_handle_data_packet_monitor(struct iwl_priv *priv,
-					   struct iwl4965_rx_mem_buffer *rxb,
+					   struct iwl_rx_mem_buffer *rxb,
 					   void *data, short len,
 					   struct ieee80211_rx_status *stats,
 					   u16 phy_flags);
 extern int iwl4965_is_duplicate_packet(struct iwl_priv *priv,
 				       struct ieee80211_hdr *header);
-extern int iwl4965_rx_queue_alloc(struct iwl_priv *priv);
-extern void iwl4965_rx_queue_reset(struct iwl_priv *priv,
-			       struct iwl4965_rx_queue *rxq);
 extern int iwl4965_calc_db_from_ratio(int sig_ratio);
 extern int iwl4965_calc_sig_qual(int rssi_dbm, int noise_dbm);
 extern int iwl4965_tx_queue_init(struct iwl_priv *priv,
 			     struct iwl4965_tx_queue *txq, int count, u32 id);
-extern void iwl4965_rx_replenish(void *data);
 extern void iwl4965_tx_queue_free(struct iwl_priv *priv, struct iwl4965_tx_queue *txq);
 extern unsigned int iwl4965_fill_beacon_frame(struct iwl_priv *priv,
 					struct ieee80211_hdr *hdr,
 					const u8 *dest, int left);
-extern int iwl4965_rx_queue_update_write_ptr(struct iwl_priv *priv,
-					 struct iwl4965_rx_queue *q);
 extern __le16 *ieee80211_get_qos_ctrl(struct ieee80211_hdr *hdr);
 extern void iwl4965_update_chain_flags(struct iwl_priv *priv);
 int iwl4965_set_pwr_src(struct iwl_priv *priv, enum iwl_pwr_src src);
@@ -722,7 +716,7 @@ extern void iwl4965_hw_build_tx_cmd_rate(struct iwl_priv *priv,
 extern int iwl4965_hw_reg_send_txpower(struct iwl_priv *priv);
 extern int iwl4965_hw_reg_set_txpower(struct iwl_priv *priv, s8 power);
 extern void iwl4965_hw_rx_statistics(struct iwl_priv *priv,
-				 struct iwl4965_rx_mem_buffer *rxb);
+				 struct iwl_rx_mem_buffer *rxb);
 extern void iwl4965_disable_events(struct iwl_priv *priv);
 extern int iwl4965_get_temperature(const struct iwl_priv *priv);
 
@@ -960,7 +954,7 @@ struct iwl_priv {
 	bool add_radiotap;
 
 	void (*rx_handlers[REPLY_MAX])(struct iwl_priv *priv,
-				       struct iwl4965_rx_mem_buffer *rxb);
+				       struct iwl_rx_mem_buffer *rxb);
 
 	struct ieee80211_supported_band bands[IEEE80211_NUM_BANDS];
 
@@ -1077,7 +1071,7 @@ struct iwl_priv {
 	int activity_timer_active;
 
 	/* Rx and Tx DMA processing queues */
-	struct iwl4965_rx_queue rxq;
+	struct iwl_rx_queue rxq;
 	struct iwl4965_tx_queue txq[IWL_MAX_NUM_QUEUES];
 	unsigned long txq_ctx_active_msk;
 	struct iwl4965_kw kw;	/* keep warm address */
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
new file mode 100644
index 0000000..667b592
--- /dev/null
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -0,0 +1,371 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2003 - 2008 Intel Corporation. All rights reserved.
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
+ * James P. Ketrenos <ipw2100-admin@linux.intel.com>
+ * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
+ *
+ *****************************************************************************/
+
+#include <net/mac80211.h>
+#include "iwl-eeprom.h"
+#include "iwl-dev.h"
+#include "iwl-core.h"
+#include "iwl-sta.h"
+#include "iwl-io.h"
+#include "iwl-helpers.h"
+/************************** RX-FUNCTIONS ****************************/
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
+int iwl_rx_queue_space(const struct iwl_rx_queue *q)
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
+EXPORT_SYMBOL(iwl_rx_queue_space);
+
+/**
+ * iwl_rx_queue_update_write_ptr - Update the write pointer for the RX queue
+ */
+int iwl_rx_queue_update_write_ptr(struct iwl_priv *priv, struct iwl_rx_queue *q)
+{
+	u32 reg = 0;
+	int ret = 0;
+	unsigned long flags;
+
+	spin_lock_irqsave(&q->lock, flags);
+
+	if (q->need_update == 0)
+		goto exit_unlock;
+
+	/* If power-saving is in use, make sure device is awake */
+	if (test_bit(STATUS_POWER_PMI, &priv->status)) {
+		reg = iwl_read32(priv, CSR_UCODE_DRV_GP1);
+
+		if (reg & CSR_UCODE_DRV_GP1_BIT_MAC_SLEEP) {
+			iwl_set_bit(priv, CSR_GP_CNTRL,
+				    CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
+			goto exit_unlock;
+		}
+
+		ret = iwl_grab_nic_access(priv);
+		if (ret)
+			goto exit_unlock;
+
+		/* Device expects a multiple of 8 */
+		iwl_write_direct32(priv, FH_RSCSR_CHNL0_WPTR,
+				     q->write & ~0x7);
+		iwl_release_nic_access(priv);
+
+	/* Else device is assumed to be awake */
+	} else
+		/* Device expects a multiple of 8 */
+		iwl_write32(priv, FH_RSCSR_CHNL0_WPTR, q->write & ~0x7);
+
+
+	q->need_update = 0;
+
+ exit_unlock:
+	spin_unlock_irqrestore(&q->lock, flags);
+	return ret;
+}
+EXPORT_SYMBOL(iwl_rx_queue_update_write_ptr);
+/**
+ * iwl_dma_addr2rbd_ptr - convert a DMA address to a uCode read buffer ptr
+ */
+static inline __le32 iwl_dma_addr2rbd_ptr(struct iwl_priv *priv,
+					  dma_addr_t dma_addr)
+{
+	return cpu_to_le32((u32)(dma_addr >> 8));
+}
+
+/**
+ * iwl_rx_queue_restock - refill RX queue from pre-allocated pool
+ *
+ * If there are slots in the RX queue that need to be restocked,
+ * and we have free pre-allocated buffers, fill the ranks as much
+ * as we can, pulling from rx_free.
+ *
+ * This moves the 'write' index forward to catch up with 'processed', and
+ * also updates the memory address in the firmware to reference the new
+ * target buffer.
+ */
+int iwl_rx_queue_restock(struct iwl_priv *priv)
+{
+	struct iwl_rx_queue *rxq = &priv->rxq;
+	struct list_head *element;
+	struct iwl_rx_mem_buffer *rxb;
+	unsigned long flags;
+	int write;
+	int ret = 0;
+
+	spin_lock_irqsave(&rxq->lock, flags);
+	write = rxq->write & ~0x7;
+	while ((iwl_rx_queue_space(rxq) > 0) && (rxq->free_count)) {
+		/* Get next free Rx buffer, remove from free list */
+		element = rxq->rx_free.next;
+		rxb = list_entry(element, struct iwl_rx_mem_buffer, list);
+		list_del(element);
+
+		/* Point to Rx buffer via next RBD in circular buffer */
+		rxq->bd[rxq->write] = iwl_dma_addr2rbd_ptr(priv, rxb->dma_addr);
+		rxq->queue[rxq->write] = rxb;
+		rxq->write = (rxq->write + 1) & RX_QUEUE_MASK;
+		rxq->free_count--;
+	}
+	spin_unlock_irqrestore(&rxq->lock, flags);
+	/* If the pre-allocated buffer pool is dropping low, schedule to
+	 * refill it */
+	if (rxq->free_count <= RX_LOW_WATERMARK)
+		queue_work(priv->workqueue, &priv->rx_replenish);
+
+
+	/* If we've added more space for the firmware to place data, tell it.
+	 * Increment device's write pointer in multiples of 8. */
+	if ((write != (rxq->write & ~0x7))
+	    || (abs(rxq->write - rxq->read) > 7)) {
+		spin_lock_irqsave(&rxq->lock, flags);
+		rxq->need_update = 1;
+		spin_unlock_irqrestore(&rxq->lock, flags);
+		ret = iwl_rx_queue_update_write_ptr(priv, rxq);
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL(iwl_rx_queue_restock);
+
+
+/**
+ * iwl_rx_replenish - Move all used packet from rx_used to rx_free
+ *
+ * When moving to rx_free an SKB is allocated for the slot.
+ *
+ * Also restock the Rx queue via iwl_rx_queue_restock.
+ * This is called as a scheduled work item (except for during initialization)
+ */
+void iwl_rx_allocate(struct iwl_priv *priv)
+{
+	struct iwl_rx_queue *rxq = &priv->rxq;
+	struct list_head *element;
+	struct iwl_rx_mem_buffer *rxb;
+	unsigned long flags;
+	spin_lock_irqsave(&rxq->lock, flags);
+	while (!list_empty(&rxq->rx_used)) {
+		element = rxq->rx_used.next;
+		rxb = list_entry(element, struct iwl_rx_mem_buffer, list);
+
+		/* Alloc a new receive buffer */
+		rxb->skb = alloc_skb(priv->hw_params.rx_buf_size,
+				__GFP_NOWARN | GFP_ATOMIC);
+		if (!rxb->skb) {
+			if (net_ratelimit())
+				printk(KERN_CRIT DRV_NAME
+				       ": Can not allocate SKB buffers\n");
+			/* We don't reschedule replenish work here -- we will
+			 * call the restock method and if it still needs
+			 * more buffers it will schedule replenish */
+			break;
+		}
+		priv->alloc_rxb_skb++;
+		list_del(element);
+
+		/* Get physical address of RB/SKB */
+		rxb->dma_addr =
+		    pci_map_single(priv->pci_dev, rxb->skb->data,
+			   priv->hw_params.rx_buf_size, PCI_DMA_FROMDEVICE);
+		list_add_tail(&rxb->list, &rxq->rx_free);
+		rxq->free_count++;
+	}
+	spin_unlock_irqrestore(&rxq->lock, flags);
+}
+EXPORT_SYMBOL(iwl_rx_allocate);
+
+void iwl_rx_replenish(struct iwl_priv *priv)
+{
+	unsigned long flags;
+
+	iwl_rx_allocate(priv);
+
+	spin_lock_irqsave(&priv->lock, flags);
+	iwl_rx_queue_restock(priv);
+	spin_unlock_irqrestore(&priv->lock, flags);
+}
+EXPORT_SYMBOL(iwl_rx_replenish);
+
+
+/* Assumes that the skb field of the buffers in 'pool' is kept accurate.
+ * If an SKB has been detached, the POOL needs to have its SKB set to NULL
+ * This free routine walks the list of POOL entries and if SKB is set to
+ * non NULL it is unmapped and freed
+ */
+void iwl_rx_queue_free(struct iwl_priv *priv, struct iwl_rx_queue *rxq)
+{
+	int i;
+	for (i = 0; i < RX_QUEUE_SIZE + RX_FREE_BUFFERS; i++) {
+		if (rxq->pool[i].skb != NULL) {
+			pci_unmap_single(priv->pci_dev,
+					 rxq->pool[i].dma_addr,
+					 priv->hw_params.rx_buf_size,
+					 PCI_DMA_FROMDEVICE);
+			dev_kfree_skb(rxq->pool[i].skb);
+		}
+	}
+
+	pci_free_consistent(priv->pci_dev, 4 * RX_QUEUE_SIZE, rxq->bd,
+			    rxq->dma_addr);
+	rxq->bd = NULL;
+}
+EXPORT_SYMBOL(iwl_rx_queue_free);
+
+int iwl_rx_queue_alloc(struct iwl_priv *priv)
+{
+	struct iwl_rx_queue *rxq = &priv->rxq;
+	struct pci_dev *dev = priv->pci_dev;
+	int i;
+
+	spin_lock_init(&rxq->lock);
+	INIT_LIST_HEAD(&rxq->rx_free);
+	INIT_LIST_HEAD(&rxq->rx_used);
+
+	/* Alloc the circular buffer of Read Buffer Descriptors (RBDs) */
+	rxq->bd = pci_alloc_consistent(dev, 4 * RX_QUEUE_SIZE, &rxq->dma_addr);
+	if (!rxq->bd)
+		return -ENOMEM;
+
+	/* Fill the rx_used queue with _all_ of the Rx buffers */
+	for (i = 0; i < RX_FREE_BUFFERS + RX_QUEUE_SIZE; i++)
+		list_add_tail(&rxq->pool[i].list, &rxq->rx_used);
+
+	/* Set us so that we have processed and used all buffers, but have
+	 * not restocked the Rx queue with fresh buffers */
+	rxq->read = rxq->write = 0;
+	rxq->free_count = 0;
+	rxq->need_update = 0;
+	return 0;
+}
+EXPORT_SYMBOL(iwl_rx_queue_alloc);
+
+void iwl_rx_queue_reset(struct iwl_priv *priv, struct iwl_rx_queue *rxq)
+{
+	unsigned long flags;
+	int i;
+	spin_lock_irqsave(&rxq->lock, flags);
+	INIT_LIST_HEAD(&rxq->rx_free);
+	INIT_LIST_HEAD(&rxq->rx_used);
+	/* Fill the rx_used queue with _all_ of the Rx buffers */
+	for (i = 0; i < RX_FREE_BUFFERS + RX_QUEUE_SIZE; i++) {
+		/* In the reset function, these buffers may have been allocated
+		 * to an SKB, so we need to unmap and free potential storage */
+		if (rxq->pool[i].skb != NULL) {
+			pci_unmap_single(priv->pci_dev,
+					 rxq->pool[i].dma_addr,
+					 priv->hw_params.rx_buf_size,
+					 PCI_DMA_FROMDEVICE);
+			priv->alloc_rxb_skb--;
+			dev_kfree_skb(rxq->pool[i].skb);
+			rxq->pool[i].skb = NULL;
+		}
+		list_add_tail(&rxq->pool[i].list, &rxq->rx_used);
+	}
+
+	/* Set us so that we have processed and used all buffers, but have
+	 * not restocked the Rx queue with fresh buffers */
+	rxq->read = rxq->write = 0;
+	rxq->free_count = 0;
+	spin_unlock_irqrestore(&rxq->lock, flags);
+}
+EXPORT_SYMBOL(iwl_rx_queue_reset);
+
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 4406fc7..ccbe09e 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -2742,7 +2742,7 @@ static int iwl4965_tx_status_reply_tx(struct iwl_priv *priv,
  * iwl4965_rx_reply_tx - Handle standard (non-aggregation) Tx response
  */
 static void iwl4965_rx_reply_tx(struct iwl_priv *priv,
-			    struct iwl4965_rx_mem_buffer *rxb)
+				struct iwl_rx_mem_buffer *rxb)
 {
 	struct iwl4965_rx_packet *pkt = (void *)rxb->skb->data;
 	u16 sequence = le16_to_cpu(pkt->hdr.sequence);
@@ -2850,7 +2850,7 @@ static void iwl4965_rx_reply_tx(struct iwl_priv *priv,
 
 
 static void iwl4965_rx_reply_alive(struct iwl_priv *priv,
-			       struct iwl4965_rx_mem_buffer *rxb)
+				   struct iwl_rx_mem_buffer *rxb)
 {
 	struct iwl4965_rx_packet *pkt = (void *)rxb->skb->data;
 	struct iwl4965_alive_resp *palive;
@@ -2886,7 +2886,7 @@ static void iwl4965_rx_reply_alive(struct iwl_priv *priv,
 }
 
 static void iwl4965_rx_reply_add_sta(struct iwl_priv *priv,
-				 struct iwl4965_rx_mem_buffer *rxb)
+				     struct iwl_rx_mem_buffer *rxb)
 {
 	struct iwl4965_rx_packet *pkt = (void *)rxb->skb->data;
 
@@ -2895,7 +2895,7 @@ static void iwl4965_rx_reply_add_sta(struct iwl_priv *priv,
 }
 
 static void iwl4965_rx_reply_error(struct iwl_priv *priv,
-			       struct iwl4965_rx_mem_buffer *rxb)
+				   struct iwl_rx_mem_buffer *rxb)
 {
 	struct iwl4965_rx_packet *pkt = (void *)rxb->skb->data;
 
@@ -2910,7 +2910,7 @@ static void iwl4965_rx_reply_error(struct iwl_priv *priv,
 
 #define TX_STATUS_ENTRY(x) case TX_STATUS_FAIL_ ## x: return #x
 
-static void iwl4965_rx_csa(struct iwl_priv *priv, struct iwl4965_rx_mem_buffer *rxb)
+static void iwl4965_rx_csa(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
 {
 	struct iwl4965_rx_packet *pkt = (void *)rxb->skb->data;
 	struct iwl4965_rxon_cmd *rxon = (void *)&priv->active_rxon;
@@ -2922,7 +2922,7 @@ static void iwl4965_rx_csa(struct iwl_priv *priv, struct iwl4965_rx_mem_buffer *
 }
 
 static void iwl4965_rx_spectrum_measure_notif(struct iwl_priv *priv,
-					  struct iwl4965_rx_mem_buffer *rxb)
+					  struct iwl_rx_mem_buffer *rxb)
 {
 #ifdef CONFIG_IWL4965_SPECTRUM_MEASUREMENT
 	struct iwl4965_rx_packet *pkt = (void *)rxb->skb->data;
@@ -2940,7 +2940,7 @@ static void iwl4965_rx_spectrum_measure_notif(struct iwl_priv *priv,
 }
 
 static void iwl4965_rx_pm_sleep_notif(struct iwl_priv *priv,
-				  struct iwl4965_rx_mem_buffer *rxb)
+				      struct iwl_rx_mem_buffer *rxb)
 {
 #ifdef CONFIG_IWLWIFI_DEBUG
 	struct iwl4965_rx_packet *pkt = (void *)rxb->skb->data;
@@ -2951,7 +2951,7 @@ static void iwl4965_rx_pm_sleep_notif(struct iwl_priv *priv,
 }
 
 static void iwl4965_rx_pm_debug_statistics_notif(struct iwl_priv *priv,
-					     struct iwl4965_rx_mem_buffer *rxb)
+					     struct iwl_rx_mem_buffer *rxb)
 {
 	struct iwl4965_rx_packet *pkt = (void *)rxb->skb->data;
 	IWL_DEBUG_RADIO("Dumping %d bytes of unhandled "
@@ -2986,7 +2986,7 @@ static void iwl4965_bg_beacon_update(struct work_struct *work)
 }
 
 static void iwl4965_rx_beacon_notif(struct iwl_priv *priv,
-				struct iwl4965_rx_mem_buffer *rxb)
+				struct iwl_rx_mem_buffer *rxb)
 {
 #ifdef CONFIG_IWLWIFI_DEBUG
 	struct iwl4965_rx_packet *pkt = (void *)rxb->skb->data;
@@ -3009,7 +3009,7 @@ static void iwl4965_rx_beacon_notif(struct iwl_priv *priv,
 
 /* Service response to REPLY_SCAN_CMD (0x80) */
 static void iwl4965_rx_reply_scan(struct iwl_priv *priv,
-			      struct iwl4965_rx_mem_buffer *rxb)
+			      struct iwl_rx_mem_buffer *rxb)
 {
 #ifdef CONFIG_IWLWIFI_DEBUG
 	struct iwl4965_rx_packet *pkt = (void *)rxb->skb->data;
@@ -3022,7 +3022,7 @@ static void iwl4965_rx_reply_scan(struct iwl_priv *priv,
 
 /* Service SCAN_START_NOTIFICATION (0x82) */
 static void iwl4965_rx_scan_start_notif(struct iwl_priv *priv,
-				    struct iwl4965_rx_mem_buffer *rxb)
+				    struct iwl_rx_mem_buffer *rxb)
 {
 	struct iwl4965_rx_packet *pkt = (void *)rxb->skb->data;
 	struct iwl4965_scanstart_notification *notif =
@@ -3039,7 +3039,7 @@ static void iwl4965_rx_scan_start_notif(struct iwl_priv *priv,
 
 /* Service SCAN_RESULTS_NOTIFICATION (0x83) */
 static void iwl4965_rx_scan_results_notif(struct iwl_priv *priv,
-				      struct iwl4965_rx_mem_buffer *rxb)
+				      struct iwl_rx_mem_buffer *rxb)
 {
 	struct iwl4965_rx_packet *pkt = (void *)rxb->skb->data;
 	struct iwl4965_scanresults_notification *notif =
@@ -3064,7 +3064,7 @@ static void iwl4965_rx_scan_results_notif(struct iwl_priv *priv,
 
 /* Service SCAN_COMPLETE_NOTIFICATION (0x84) */
 static void iwl4965_rx_scan_complete_notif(struct iwl_priv *priv,
-				       struct iwl4965_rx_mem_buffer *rxb)
+				       struct iwl_rx_mem_buffer *rxb)
 {
 	struct iwl4965_rx_packet *pkt = (void *)rxb->skb->data;
 	struct iwl4965_scancomplete_notification *scan_notif = (void *)pkt->u.raw;
@@ -3122,7 +3122,7 @@ reschedule:
 /* Handle notification from uCode that card's power state is changing
  * due to software, hardware, or critical temperature RFKILL */
 static void iwl4965_rx_card_state_notif(struct iwl_priv *priv,
-				    struct iwl4965_rx_mem_buffer *rxb)
+				    struct iwl_rx_mem_buffer *rxb)
 {
 	struct iwl4965_rx_packet *pkt = (void *)rxb->skb->data;
 	u32 flags = le32_to_cpu(pkt->u.card_state_notif.flags);
@@ -3242,7 +3242,7 @@ static void iwl4965_setup_rx_handlers(struct iwl_priv *priv)
  * if the callback returns 1
  */
 static void iwl4965_tx_cmd_complete(struct iwl_priv *priv,
-				struct iwl4965_rx_mem_buffer *rxb)
+				    struct iwl_rx_mem_buffer *rxb)
 {
 	struct iwl4965_rx_packet *pkt = (struct iwl4965_rx_packet *)rxb->skb->data;
 	u16 sequence = le16_to_cpu(pkt->hdr.sequence);
@@ -3279,438 +3279,28 @@ static void iwl4965_tx_cmd_complete(struct iwl_priv *priv,
 	}
 }
 
-/************************** RX-FUNCTIONS ****************************/
-/*
- * Rx theory of operation
- *
- * Driver allocates a circular buffer of Receive Buffer Descriptors (RBDs),
- * each of which point to Receive Buffers to be filled by 4965.  These get
- * used not only for Rx frames, but for any command response or notification
- * from the 4965.  The driver and 4965 manage the Rx buffers by means
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
- * + In iwl4965_rx_replenish (scheduled) if 'processed' != 'read' then the
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
- * iwl4965_rx_queue_alloc()   Allocates rx_free
- * iwl4965_rx_replenish()     Replenishes rx_free list from rx_used, and calls
- *                            iwl4965_rx_queue_restock
- * iwl4965_rx_queue_restock() Moves available buffers from rx_free into Rx
- *                            queue, updates firmware pointers, and updates
- *                            the WRITE index.  If insufficient rx_free buffers
- *                            are available, schedules iwl4965_rx_replenish
- *
- * -- enable interrupts --
- * ISR - iwl4965_rx()         Detach iwl4965_rx_mem_buffers from pool up to the
- *                            READ INDEX, detaching the SKB from the pool.
- *                            Moves the packet buffer from queue to rx_used.
- *                            Calls iwl4965_rx_queue_restock to refill any empty
- *                            slots.
- * ...
- *
- */
-
-/**
- * iwl4965_rx_queue_space - Return number of free slots available in queue.
- */
-static int iwl4965_rx_queue_space(const struct iwl4965_rx_queue *q)
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
- * iwl4965_rx_queue_update_write_ptr - Update the write pointer for the RX queue
- */
-int iwl4965_rx_queue_update_write_ptr(struct iwl_priv *priv, struct iwl4965_rx_queue *q)
-{
-	u32 reg = 0;
-	int rc = 0;
-	unsigned long flags;
-
-	spin_lock_irqsave(&q->lock, flags);
-
-	if (q->need_update == 0)
-		goto exit_unlock;
-
-	/* If power-saving is in use, make sure device is awake */
-	if (test_bit(STATUS_POWER_PMI, &priv->status)) {
-		reg = iwl_read32(priv, CSR_UCODE_DRV_GP1);
-
-		if (reg & CSR_UCODE_DRV_GP1_BIT_MAC_SLEEP) {
-			iwl_set_bit(priv, CSR_GP_CNTRL,
-				    CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
-			goto exit_unlock;
-		}
-
-		rc = iwl_grab_nic_access(priv);
-		if (rc)
-			goto exit_unlock;
-
-		/* Device expects a multiple of 8 */
-		iwl_write_direct32(priv, FH_RSCSR_CHNL0_WPTR,
-				     q->write & ~0x7);
-		iwl_release_nic_access(priv);
-
-	/* Else device is assumed to be awake */
-	} else
-		/* Device expects a multiple of 8 */
-		iwl_write32(priv, FH_RSCSR_CHNL0_WPTR, q->write & ~0x7);
-
-
-	q->need_update = 0;
-
- exit_unlock:
-	spin_unlock_irqrestore(&q->lock, flags);
-	return rc;
-}
-
-/**
- * iwl4965_dma_addr2rbd_ptr - convert a DMA address to a uCode read buffer ptr
- */
-static inline __le32 iwl4965_dma_addr2rbd_ptr(struct iwl_priv *priv,
-					  dma_addr_t dma_addr)
-{
-	return cpu_to_le32((u32)(dma_addr >> 8));
-}
-
-
-/**
- * iwl4965_rx_queue_restock - refill RX queue from pre-allocated pool
- *
- * If there are slots in the RX queue that need to be restocked,
- * and we have free pre-allocated buffers, fill the ranks as much
- * as we can, pulling from rx_free.
- *
- * This moves the 'write' index forward to catch up with 'processed', and
- * also updates the memory address in the firmware to reference the new
- * target buffer.
- */
-static int iwl4965_rx_queue_restock(struct iwl_priv *priv)
-{
-	struct iwl4965_rx_queue *rxq = &priv->rxq;
-	struct list_head *element;
-	struct iwl4965_rx_mem_buffer *rxb;
-	unsigned long flags;
-	int write, rc;
-
-	spin_lock_irqsave(&rxq->lock, flags);
-	write = rxq->write & ~0x7;
-	while ((iwl4965_rx_queue_space(rxq) > 0) && (rxq->free_count)) {
-		/* Get next free Rx buffer, remove from free list */
-		element = rxq->rx_free.next;
-		rxb = list_entry(element, struct iwl4965_rx_mem_buffer, list);
-		list_del(element);
-
-		/* Point to Rx buffer via next RBD in circular buffer */
-		rxq->bd[rxq->write] = iwl4965_dma_addr2rbd_ptr(priv, rxb->dma_addr);
-		rxq->queue[rxq->write] = rxb;
-		rxq->write = (rxq->write + 1) & RX_QUEUE_MASK;
-		rxq->free_count--;
-	}
-	spin_unlock_irqrestore(&rxq->lock, flags);
-	/* If the pre-allocated buffer pool is dropping low, schedule to
-	 * refill it */
-	if (rxq->free_count <= RX_LOW_WATERMARK)
-		queue_work(priv->workqueue, &priv->rx_replenish);
-
-
-	/* If we've added more space for the firmware to place data, tell it.
-	 * Increment device's write pointer in multiples of 8. */
-	if ((write != (rxq->write & ~0x7))
-	    || (abs(rxq->write - rxq->read) > 7)) {
-		spin_lock_irqsave(&rxq->lock, flags);
-		rxq->need_update = 1;
-		spin_unlock_irqrestore(&rxq->lock, flags);
-		rc = iwl4965_rx_queue_update_write_ptr(priv, rxq);
-		if (rc)
-			return rc;
-	}
-
-	return 0;
-}
-
-/**
- * iwl4965_rx_replenish - Move all used packet from rx_used to rx_free
- *
- * When moving to rx_free an SKB is allocated for the slot.
- *
- * Also restock the Rx queue via iwl4965_rx_queue_restock.
- * This is called as a scheduled work item (except for during initialization)
- */
-static void iwl4965_rx_allocate(struct iwl_priv *priv)
-{
-	struct iwl4965_rx_queue *rxq = &priv->rxq;
-	struct list_head *element;
-	struct iwl4965_rx_mem_buffer *rxb;
-	unsigned long flags;
-	spin_lock_irqsave(&rxq->lock, flags);
-	while (!list_empty(&rxq->rx_used)) {
-		element = rxq->rx_used.next;
-		rxb = list_entry(element, struct iwl4965_rx_mem_buffer, list);
-
-		/* Alloc a new receive buffer */
-		rxb->skb =
-		    alloc_skb(priv->hw_params.rx_buf_size,
-				__GFP_NOWARN | GFP_ATOMIC);
-		if (!rxb->skb) {
-			if (net_ratelimit())
-				printk(KERN_CRIT DRV_NAME
-				       ": Can not allocate SKB buffers\n");
-			/* We don't reschedule replenish work here -- we will
-			 * call the restock method and if it still needs
-			 * more buffers it will schedule replenish */
-			break;
-		}
-		priv->alloc_rxb_skb++;
-		list_del(element);
-
-		/* Get physical address of RB/SKB */
-		rxb->dma_addr =
-		    pci_map_single(priv->pci_dev, rxb->skb->data,
-			   priv->hw_params.rx_buf_size, PCI_DMA_FROMDEVICE);
-		list_add_tail(&rxb->list, &rxq->rx_free);
-		rxq->free_count++;
-	}
-	spin_unlock_irqrestore(&rxq->lock, flags);
-}
-
 /*
  * this should be called while priv->lock is locked
 */
-static void __iwl4965_rx_replenish(void *data)
-{
-	struct iwl_priv *priv = data;
-
-	iwl4965_rx_allocate(priv);
-	iwl4965_rx_queue_restock(priv);
-}
-
-
-void iwl4965_rx_replenish(void *data)
-{
-	struct iwl_priv *priv = data;
-	unsigned long flags;
-
-	iwl4965_rx_allocate(priv);
-
-	spin_lock_irqsave(&priv->lock, flags);
-	iwl4965_rx_queue_restock(priv);
-	spin_unlock_irqrestore(&priv->lock, flags);
-}
-
-/* Assumes that the skb field of the buffers in 'pool' is kept accurate.
- * If an SKB has been detached, the POOL needs to have its SKB set to NULL
- * This free routine walks the list of POOL entries and if SKB is set to
- * non NULL it is unmapped and freed
- */
-static void iwl4965_rx_queue_free(struct iwl_priv *priv, struct iwl4965_rx_queue *rxq)
-{
-	int i;
-	for (i = 0; i < RX_QUEUE_SIZE + RX_FREE_BUFFERS; i++) {
-		if (rxq->pool[i].skb != NULL) {
-			pci_unmap_single(priv->pci_dev,
-					 rxq->pool[i].dma_addr,
-					 priv->hw_params.rx_buf_size,
-					 PCI_DMA_FROMDEVICE);
-			dev_kfree_skb(rxq->pool[i].skb);
-		}
-	}
-
-	pci_free_consistent(priv->pci_dev, 4 * RX_QUEUE_SIZE, rxq->bd,
-			    rxq->dma_addr);
-	rxq->bd = NULL;
-}
-
-int iwl4965_rx_queue_alloc(struct iwl_priv *priv)
-{
-	struct iwl4965_rx_queue *rxq = &priv->rxq;
-	struct pci_dev *dev = priv->pci_dev;
-	int i;
-
-	spin_lock_init(&rxq->lock);
-	INIT_LIST_HEAD(&rxq->rx_free);
-	INIT_LIST_HEAD(&rxq->rx_used);
-
-	/* Alloc the circular buffer of Read Buffer Descriptors (RBDs) */
-	rxq->bd = pci_alloc_consistent(dev, 4 * RX_QUEUE_SIZE, &rxq->dma_addr);
-	if (!rxq->bd)
-		return -ENOMEM;
-
-	/* Fill the rx_used queue with _all_ of the Rx buffers */
-	for (i = 0; i < RX_FREE_BUFFERS + RX_QUEUE_SIZE; i++)
-		list_add_tail(&rxq->pool[i].list, &rxq->rx_used);
-
-	/* Set us so that we have processed and used all buffers, but have
-	 * not restocked the Rx queue with fresh buffers */
-	rxq->read = rxq->write = 0;
-	rxq->free_count = 0;
-	rxq->need_update = 0;
-	return 0;
-}
-
-void iwl4965_rx_queue_reset(struct iwl_priv *priv, struct iwl4965_rx_queue *rxq)
-{
-	unsigned long flags;
-	int i;
-	spin_lock_irqsave(&rxq->lock, flags);
-	INIT_LIST_HEAD(&rxq->rx_free);
-	INIT_LIST_HEAD(&rxq->rx_used);
-	/* Fill the rx_used queue with _all_ of the Rx buffers */
-	for (i = 0; i < RX_FREE_BUFFERS + RX_QUEUE_SIZE; i++) {
-		/* In the reset function, these buffers may have been allocated
-		 * to an SKB, so we need to unmap and free potential storage */
-		if (rxq->pool[i].skb != NULL) {
-			pci_unmap_single(priv->pci_dev,
-					 rxq->pool[i].dma_addr,
-					 priv->hw_params.rx_buf_size,
-					 PCI_DMA_FROMDEVICE);
-			priv->alloc_rxb_skb--;
-			dev_kfree_skb(rxq->pool[i].skb);
-			rxq->pool[i].skb = NULL;
-		}
-		list_add_tail(&rxq->pool[i].list, &rxq->rx_used);
-	}
-
-	/* Set us so that we have processed and used all buffers, but have
-	 * not restocked the Rx queue with fresh buffers */
-	rxq->read = rxq->write = 0;
-	rxq->free_count = 0;
-	spin_unlock_irqrestore(&rxq->lock, flags);
-}
-
-/* Convert linear signal-to-noise ratio into dB */
-static u8 ratio2dB[100] = {
-/*	 0   1   2   3   4   5   6   7   8   9 */
-	 0,  0,  6, 10, 12, 14, 16, 17, 18, 19, /* 00 - 09 */
-	20, 21, 22, 22, 23, 23, 24, 25, 26, 26, /* 10 - 19 */
-	26, 26, 26, 27, 27, 28, 28, 28, 29, 29, /* 20 - 29 */
-	29, 30, 30, 30, 31, 31, 31, 31, 32, 32, /* 30 - 39 */
-	32, 32, 32, 33, 33, 33, 33, 33, 34, 34, /* 40 - 49 */
-	34, 34, 34, 34, 35, 35, 35, 35, 35, 35, /* 50 - 59 */
-	36, 36, 36, 36, 36, 36, 36, 37, 37, 37, /* 60 - 69 */
-	37, 37, 37, 37, 37, 38, 38, 38, 38, 38, /* 70 - 79 */
-	38, 38, 38, 38, 38, 39, 39, 39, 39, 39, /* 80 - 89 */
-	39, 39, 39, 39, 39, 40, 40, 40, 40, 40  /* 90 - 99 */
-};
-
-/* Calculates a relative dB value from a ratio of linear
- *   (i.e. not dB) signal levels.
- * Conversion assumes that levels are voltages (20*log), not powers (10*log). */
-int iwl4965_calc_db_from_ratio(int sig_ratio)
+static void __iwl_rx_replenish(struct iwl_priv *priv)
 {
-	/* 1000:1 or higher just report as 60 dB */
-	if (sig_ratio >= 1000)
-		return 60;
-
-	/* 100:1 or higher, divide by 10 and use table,
-	 *   add 20 dB to make up for divide by 10 */
-	if (sig_ratio >= 100)
-		return (20 + (int)ratio2dB[sig_ratio/10]);
-
-	/* We shouldn't see this */
-	if (sig_ratio < 1)
-		return 0;
-
-	/* Use table for ratios 1:1 - 99:1 */
-	return (int)ratio2dB[sig_ratio];
+	iwl_rx_allocate(priv);
+	iwl_rx_queue_restock(priv);
 }
 
-#define PERFECT_RSSI (-20) /* dBm */
-#define WORST_RSSI (-95)   /* dBm */
-#define RSSI_RANGE (PERFECT_RSSI - WORST_RSSI)
-
-/* Calculate an indication of rx signal quality (a percentage, not dBm!).
- * See http://www.ces.clemson.edu/linux/signal_quality.shtml for info
- *   about formulas used below. */
-int iwl4965_calc_sig_qual(int rssi_dbm, int noise_dbm)
-{
-	int sig_qual;
-	int degradation = PERFECT_RSSI - rssi_dbm;
-
-	/* If we get a noise measurement, use signal-to-noise ratio (SNR)
-	 * as indicator; formula is (signal dbm - noise dbm).
-	 * SNR at or above 40 is a great signal (100%).
-	 * Below that, scale to fit SNR of 0 - 40 dB within 0 - 100% indicator.
-	 * Weakest usable signal is usually 10 - 15 dB SNR. */
-	if (noise_dbm) {
-		if (rssi_dbm - noise_dbm >= 40)
-			return 100;
-		else if (rssi_dbm < noise_dbm)
-			return 0;
-		sig_qual = ((rssi_dbm - noise_dbm) * 5) / 2;
-
-	/* Else use just the signal level.
-	 * This formula is a least squares fit of data points collected and
-	 *   compared with a reference system that had a percentage (%) display
-	 *   for signal quality. */
-	} else
-		sig_qual = (100 * (RSSI_RANGE * RSSI_RANGE) - degradation *
-			    (15 * RSSI_RANGE + 62 * degradation)) /
-			   (RSSI_RANGE * RSSI_RANGE);
-
-	if (sig_qual > 100)
-		sig_qual = 100;
-	else if (sig_qual < 1)
-		sig_qual = 0;
-
-	return sig_qual;
-}
 
 /**
- * iwl4965_rx_handle - Main entry function for receiving responses from uCode
+ * iwl_rx_handle - Main entry function for receiving responses from uCode
  *
  * Uses the priv->rx_handlers callback function array to invoke
  * the appropriate handlers, including command responses,
  * frame-received notifications, and other notifications.
  */
-static void iwl4965_rx_handle(struct iwl_priv *priv)
+void iwl_rx_handle(struct iwl_priv *priv)
 {
-	struct iwl4965_rx_mem_buffer *rxb;
+	struct iwl_rx_mem_buffer *rxb;
 	struct iwl4965_rx_packet *pkt;
-	struct iwl4965_rx_queue *rxq = &priv->rxq;
+	struct iwl_rx_queue *rxq = &priv->rxq;
 	u32 r, i;
 	int reclaim;
 	unsigned long flags;
@@ -3726,7 +3316,7 @@ static void iwl4965_rx_handle(struct iwl_priv *priv)
 	if (i == r)
 		IWL_DEBUG(IWL_DL_RX | IWL_DL_ISR, "r = %d, i = %d\n", r, i);
 
-	if (iwl4965_rx_queue_space(rxq) > (RX_QUEUE_SIZE / 2))
+	if (iwl_rx_queue_space(rxq) > (RX_QUEUE_SIZE / 2))
 		fill_rx = 1;
 
 	while (i != r) {
@@ -3805,7 +3395,7 @@ static void iwl4965_rx_handle(struct iwl_priv *priv)
 			count++;
 			if (count >= 8) {
 				priv->rxq.read = i;
-				__iwl4965_rx_replenish(priv);
+				__iwl_rx_replenish(priv);
 				count = 0;
 			}
 		}
@@ -3813,7 +3403,84 @@ static void iwl4965_rx_handle(struct iwl_priv *priv)
 
 	/* Backtrack one entry */
 	priv->rxq.read = i;
-	iwl4965_rx_queue_restock(priv);
+	iwl_rx_queue_restock(priv);
+}
+/* Convert linear signal-to-noise ratio into dB */
+static u8 ratio2dB[100] = {
+/*	 0   1   2   3   4   5   6   7   8   9 */
+	 0,  0,  6, 10, 12, 14, 16, 17, 18, 19, /* 00 - 09 */
+	20, 21, 22, 22, 23, 23, 24, 25, 26, 26, /* 10 - 19 */
+	26, 26, 26, 27, 27, 28, 28, 28, 29, 29, /* 20 - 29 */
+	29, 30, 30, 30, 31, 31, 31, 31, 32, 32, /* 30 - 39 */
+	32, 32, 32, 33, 33, 33, 33, 33, 34, 34, /* 40 - 49 */
+	34, 34, 34, 34, 35, 35, 35, 35, 35, 35, /* 50 - 59 */
+	36, 36, 36, 36, 36, 36, 36, 37, 37, 37, /* 60 - 69 */
+	37, 37, 37, 37, 37, 38, 38, 38, 38, 38, /* 70 - 79 */
+	38, 38, 38, 38, 38, 39, 39, 39, 39, 39, /* 80 - 89 */
+	39, 39, 39, 39, 39, 40, 40, 40, 40, 40  /* 90 - 99 */
+};
+
+/* Calculates a relative dB value from a ratio of linear
+ *   (i.e. not dB) signal levels.
+ * Conversion assumes that levels are voltages (20*log), not powers (10*log). */
+int iwl4965_calc_db_from_ratio(int sig_ratio)
+{
+	/* 1000:1 or higher just report as 60 dB */
+	if (sig_ratio >= 1000)
+		return 60;
+
+	/* 100:1 or higher, divide by 10 and use table,
+	 *   add 20 dB to make up for divide by 10 */
+	if (sig_ratio >= 100)
+		return (20 + (int)ratio2dB[sig_ratio/10]);
+
+	/* We shouldn't see this */
+	if (sig_ratio < 1)
+		return 0;
+
+	/* Use table for ratios 1:1 - 99:1 */
+	return (int)ratio2dB[sig_ratio];
+}
+
+#define PERFECT_RSSI (-20) /* dBm */
+#define WORST_RSSI (-95)   /* dBm */
+#define RSSI_RANGE (PERFECT_RSSI - WORST_RSSI)
+
+/* Calculate an indication of rx signal quality (a percentage, not dBm!).
+ * See http://www.ces.clemson.edu/linux/signal_quality.shtml for info
+ *   about formulas used below. */
+int iwl4965_calc_sig_qual(int rssi_dbm, int noise_dbm)
+{
+	int sig_qual;
+	int degradation = PERFECT_RSSI - rssi_dbm;
+
+	/* If we get a noise measurement, use signal-to-noise ratio (SNR)
+	 * as indicator; formula is (signal dbm - noise dbm).
+	 * SNR at or above 40 is a great signal (100%).
+	 * Below that, scale to fit SNR of 0 - 40 dB within 0 - 100% indicator.
+	 * Weakest usable signal is usually 10 - 15 dB SNR. */
+	if (noise_dbm) {
+		if (rssi_dbm - noise_dbm >= 40)
+			return 100;
+		else if (rssi_dbm < noise_dbm)
+			return 0;
+		sig_qual = ((rssi_dbm - noise_dbm) * 5) / 2;
+
+	/* Else use just the signal level.
+	 * This formula is a least squares fit of data points collected and
+	 *   compared with a reference system that had a percentage (%) display
+	 *   for signal quality. */
+	} else
+		sig_qual = (100 * (RSSI_RANGE * RSSI_RANGE) - degradation *
+			    (15 * RSSI_RANGE + 62 * degradation)) /
+			   (RSSI_RANGE * RSSI_RANGE);
+
+	if (sig_qual > 100)
+		sig_qual = 100;
+	else if (sig_qual < 1)
+		sig_qual = 0;
+
+	return sig_qual;
 }
 
 /**
@@ -4249,7 +3916,7 @@ static void iwl4965_irq_tasklet(struct iwl_priv *priv)
 	/* uCode wakes up after power-down sleep */
 	if (inta & CSR_INT_BIT_WAKEUP) {
 		IWL_DEBUG_ISR("Wakeup interrupt\n");
-		iwl4965_rx_queue_update_write_ptr(priv, &priv->rxq);
+		iwl_rx_queue_update_write_ptr(priv, &priv->rxq);
 		iwl4965_tx_queue_update_write_ptr(priv, &priv->txq[0]);
 		iwl4965_tx_queue_update_write_ptr(priv, &priv->txq[1]);
 		iwl4965_tx_queue_update_write_ptr(priv, &priv->txq[2]);
@@ -4264,7 +3931,7 @@ static void iwl4965_irq_tasklet(struct iwl_priv *priv)
 	 * Rx "responses" (frame-received notification), and other
 	 * notifications from uCode come through here*/
 	if (inta & (CSR_INT_BIT_FH_RX | CSR_INT_BIT_SW_RX)) {
-		iwl4965_rx_handle(priv);
+		iwl_rx_handle(priv);
 		handled |= (CSR_INT_BIT_FH_RX | CSR_INT_BIT_SW_RX);
 	}
 
@@ -5453,7 +5120,7 @@ static void iwl4965_bg_rx_replenish(struct work_struct *data)
 		return;
 
 	mutex_lock(&priv->mutex);
-	iwl4965_rx_replenish(priv);
+	iwl_rx_replenish(priv);
 	mutex_unlock(&priv->mutex);
 }
 
@@ -7310,7 +6977,7 @@ static void __devexit iwl4965_pci_remove(struct pci_dev *pdev)
 	iwl4965_dealloc_ucode_pci(priv);
 
 	if (priv->rxq.bd)
-		iwl4965_rx_queue_free(priv, &priv->rxq);
+		iwl_rx_queue_free(priv, &priv->rxq);
 	iwl4965_hw_txq_ctx_free(priv);
 
 	iwlcore_clear_stations_table(priv);
-- 
1.5.3.6

