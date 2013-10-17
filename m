Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:48766 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751323Ab3JQHmq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Oct 2013 03:42:46 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 07/21] rt2x00: rt2800pci: move interrupt functions to the rt2800mmio module
Date: Thu, 17 Oct 2013 09:42:21 +0200
Message-Id: <1381995755-16471-8-git-send-email-juhosg@openwrt.org> (sfid-20131017_100808_010111_D8F03ED1)
In-Reply-To: <1381995755-16471-1-git-send-email-juhosg@openwrt.org>
References: <1381995755-16471-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move the functions into a separate module, in order
to make those usable from other modules.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/rt2x00/rt2800mmio.c |  396 ++++++++++++++++++++++++++++++
 drivers/net/wireless/rt2x00/rt2800mmio.h |    9 +
 drivers/net/wireless/rt2x00/rt2800pci.c  |  388 -----------------------------
 3 files changed, 405 insertions(+), 388 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800mmio.c b/drivers/net/wireless/rt2x00/rt2800mmio.c
index 32b8e50..bfae4f0 100644
--- a/drivers/net/wireless/rt2x00/rt2800mmio.c
+++ b/drivers/net/wireless/rt2x00/rt2800mmio.c
@@ -34,6 +34,7 @@
 
 #include "rt2x00.h"
 #include "rt2x00mmio.h"
+#include "rt2800.h"
 #include "rt2800lib.h"
 #include "rt2800mmio.h"
 
@@ -156,6 +157,401 @@ void rt2800mmio_fill_rxdone(struct queue_entry *entry,
 }
 EXPORT_SYMBOL_GPL(rt2800mmio_fill_rxdone);
 
+/*
+ * Interrupt functions.
+ */
+static void rt2800mmio_wakeup(struct rt2x00_dev *rt2x00dev)
+{
+	struct ieee80211_conf conf = { .flags = 0 };
+	struct rt2x00lib_conf libconf = { .conf = &conf };
+
+	rt2800_config(rt2x00dev, &libconf, IEEE80211_CONF_CHANGE_PS);
+}
+
+static bool rt2800mmio_txdone_entry_check(struct queue_entry *entry, u32 status)
+{
+	__le32 *txwi;
+	u32 word;
+	int wcid, tx_wcid;
+
+	wcid = rt2x00_get_field32(status, TX_STA_FIFO_WCID);
+
+	txwi = rt2800_drv_get_txwi(entry);
+	rt2x00_desc_read(txwi, 1, &word);
+	tx_wcid = rt2x00_get_field32(word, TXWI_W1_WIRELESS_CLI_ID);
+
+	return (tx_wcid == wcid);
+}
+
+static bool rt2800mmio_txdone_find_entry(struct queue_entry *entry, void *data)
+{
+	u32 status = *(u32 *)data;
+
+	/*
+	 * rt2800pci hardware might reorder frames when exchanging traffic
+	 * with multiple BA enabled STAs.
+	 *
+	 * For example, a tx queue
+	 *    [ STA1 | STA2 | STA1 | STA2 ]
+	 * can result in tx status reports
+	 *    [ STA1 | STA1 | STA2 | STA2 ]
+	 * when the hw decides to aggregate the frames for STA1 into one AMPDU.
+	 *
+	 * To mitigate this effect, associate the tx status to the first frame
+	 * in the tx queue with a matching wcid.
+	 */
+	if (rt2800mmio_txdone_entry_check(entry, status) &&
+	    !test_bit(ENTRY_DATA_STATUS_SET, &entry->flags)) {
+		/*
+		 * Got a matching frame, associate the tx status with
+		 * the frame
+		 */
+		entry->status = status;
+		set_bit(ENTRY_DATA_STATUS_SET, &entry->flags);
+		return true;
+	}
+
+	/* Check the next frame */
+	return false;
+}
+
+static bool rt2800mmio_txdone_match_first(struct queue_entry *entry, void *data)
+{
+	u32 status = *(u32 *)data;
+
+	/*
+	 * Find the first frame without tx status and assign this status to it
+	 * regardless if it matches or not.
+	 */
+	if (!test_bit(ENTRY_DATA_STATUS_SET, &entry->flags)) {
+		/*
+		 * Got a matching frame, associate the tx status with
+		 * the frame
+		 */
+		entry->status = status;
+		set_bit(ENTRY_DATA_STATUS_SET, &entry->flags);
+		return true;
+	}
+
+	/* Check the next frame */
+	return false;
+}
+static bool rt2800mmio_txdone_release_entries(struct queue_entry *entry,
+					      void *data)
+{
+	if (test_bit(ENTRY_DATA_STATUS_SET, &entry->flags)) {
+		rt2800_txdone_entry(entry, entry->status,
+				    rt2800mmio_get_txwi(entry));
+		return false;
+	}
+
+	/* No more frames to release */
+	return true;
+}
+
+static bool rt2800mmio_txdone(struct rt2x00_dev *rt2x00dev)
+{
+	struct data_queue *queue;
+	u32 status;
+	u8 qid;
+	int max_tx_done = 16;
+
+	while (kfifo_get(&rt2x00dev->txstatus_fifo, &status)) {
+		qid = rt2x00_get_field32(status, TX_STA_FIFO_PID_QUEUE);
+		if (unlikely(qid >= QID_RX)) {
+			/*
+			 * Unknown queue, this shouldn't happen. Just drop
+			 * this tx status.
+			 */
+			rt2x00_warn(rt2x00dev, "Got TX status report with unexpected pid %u, dropping\n",
+				    qid);
+			break;
+		}
+
+		queue = rt2x00queue_get_tx_queue(rt2x00dev, qid);
+		if (unlikely(queue == NULL)) {
+			/*
+			 * The queue is NULL, this shouldn't happen. Stop
+			 * processing here and drop the tx status
+			 */
+			rt2x00_warn(rt2x00dev, "Got TX status for an unavailable queue %u, dropping\n",
+				    qid);
+			break;
+		}
+
+		if (unlikely(rt2x00queue_empty(queue))) {
+			/*
+			 * The queue is empty. Stop processing here
+			 * and drop the tx status.
+			 */
+			rt2x00_warn(rt2x00dev, "Got TX status for an empty queue %u, dropping\n",
+				    qid);
+			break;
+		}
+
+		/*
+		 * Let's associate this tx status with the first
+		 * matching frame.
+		 */
+		if (!rt2x00queue_for_each_entry(queue, Q_INDEX_DONE,
+						Q_INDEX, &status,
+						rt2800mmio_txdone_find_entry)) {
+			/*
+			 * We cannot match the tx status to any frame, so just
+			 * use the first one.
+			 */
+			if (!rt2x00queue_for_each_entry(queue, Q_INDEX_DONE,
+							Q_INDEX, &status,
+							rt2800mmio_txdone_match_first)) {
+				rt2x00_warn(rt2x00dev, "No frame found for TX status on queue %u, dropping\n",
+					    qid);
+				break;
+			}
+		}
+
+		/*
+		 * Release all frames with a valid tx status.
+		 */
+		rt2x00queue_for_each_entry(queue, Q_INDEX_DONE,
+					   Q_INDEX, NULL,
+					   rt2800mmio_txdone_release_entries);
+
+		if (--max_tx_done == 0)
+			break;
+	}
+
+	return !max_tx_done;
+}
+
+static inline void rt2800mmio_enable_interrupt(struct rt2x00_dev *rt2x00dev,
+					       struct rt2x00_field32 irq_field)
+{
+	u32 reg;
+
+	/*
+	 * Enable a single interrupt. The interrupt mask register
+	 * access needs locking.
+	 */
+	spin_lock_irq(&rt2x00dev->irqmask_lock);
+	rt2x00mmio_register_read(rt2x00dev, INT_MASK_CSR, &reg);
+	rt2x00_set_field32(&reg, irq_field, 1);
+	rt2x00mmio_register_write(rt2x00dev, INT_MASK_CSR, reg);
+	spin_unlock_irq(&rt2x00dev->irqmask_lock);
+}
+
+void rt2800mmio_txstatus_tasklet(unsigned long data)
+{
+	struct rt2x00_dev *rt2x00dev = (struct rt2x00_dev *)data;
+	if (rt2800mmio_txdone(rt2x00dev))
+		tasklet_schedule(&rt2x00dev->txstatus_tasklet);
+
+	/*
+	 * No need to enable the tx status interrupt here as we always
+	 * leave it enabled to minimize the possibility of a tx status
+	 * register overflow. See comment in interrupt handler.
+	 */
+}
+EXPORT_SYMBOL_GPL(rt2800mmio_txstatus_tasklet);
+
+void rt2800mmio_pretbtt_tasklet(unsigned long data)
+{
+	struct rt2x00_dev *rt2x00dev = (struct rt2x00_dev *)data;
+	rt2x00lib_pretbtt(rt2x00dev);
+	if (test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags))
+		rt2800mmio_enable_interrupt(rt2x00dev, INT_MASK_CSR_PRE_TBTT);
+}
+EXPORT_SYMBOL_GPL(rt2800mmio_pretbtt_tasklet);
+
+void rt2800mmio_tbtt_tasklet(unsigned long data)
+{
+	struct rt2x00_dev *rt2x00dev = (struct rt2x00_dev *)data;
+	struct rt2800_drv_data *drv_data = rt2x00dev->drv_data;
+	u32 reg;
+
+	rt2x00lib_beacondone(rt2x00dev);
+
+	if (rt2x00dev->intf_ap_count) {
+		/*
+		 * The rt2800pci hardware tbtt timer is off by 1us per tbtt
+		 * causing beacon skew and as a result causing problems with
+		 * some powersaving clients over time. Shorten the beacon
+		 * interval every 64 beacons by 64us to mitigate this effect.
+		 */
+		if (drv_data->tbtt_tick == (BCN_TBTT_OFFSET - 2)) {
+			rt2x00mmio_register_read(rt2x00dev, BCN_TIME_CFG, &reg);
+			rt2x00_set_field32(&reg, BCN_TIME_CFG_BEACON_INTERVAL,
+					   (rt2x00dev->beacon_int * 16) - 1);
+			rt2x00mmio_register_write(rt2x00dev, BCN_TIME_CFG, reg);
+		} else if (drv_data->tbtt_tick == (BCN_TBTT_OFFSET - 1)) {
+			rt2x00mmio_register_read(rt2x00dev, BCN_TIME_CFG, &reg);
+			rt2x00_set_field32(&reg, BCN_TIME_CFG_BEACON_INTERVAL,
+					   (rt2x00dev->beacon_int * 16));
+			rt2x00mmio_register_write(rt2x00dev, BCN_TIME_CFG, reg);
+		}
+		drv_data->tbtt_tick++;
+		drv_data->tbtt_tick %= BCN_TBTT_OFFSET;
+	}
+
+	if (test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags))
+		rt2800mmio_enable_interrupt(rt2x00dev, INT_MASK_CSR_TBTT);
+}
+EXPORT_SYMBOL_GPL(rt2800mmio_tbtt_tasklet);
+
+void rt2800mmio_rxdone_tasklet(unsigned long data)
+{
+	struct rt2x00_dev *rt2x00dev = (struct rt2x00_dev *)data;
+	if (rt2x00mmio_rxdone(rt2x00dev))
+		tasklet_schedule(&rt2x00dev->rxdone_tasklet);
+	else if (test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags))
+		rt2800mmio_enable_interrupt(rt2x00dev, INT_MASK_CSR_RX_DONE);
+}
+EXPORT_SYMBOL_GPL(rt2800mmio_rxdone_tasklet);
+
+void rt2800mmio_autowake_tasklet(unsigned long data)
+{
+	struct rt2x00_dev *rt2x00dev = (struct rt2x00_dev *)data;
+	rt2800mmio_wakeup(rt2x00dev);
+	if (test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags))
+		rt2800mmio_enable_interrupt(rt2x00dev,
+					    INT_MASK_CSR_AUTO_WAKEUP);
+}
+EXPORT_SYMBOL_GPL(rt2800mmio_autowake_tasklet);
+
+static void rt2800mmio_txstatus_interrupt(struct rt2x00_dev *rt2x00dev)
+{
+	u32 status;
+	int i;
+
+	/*
+	 * The TX_FIFO_STATUS interrupt needs special care. We should
+	 * read TX_STA_FIFO but we should do it immediately as otherwise
+	 * the register can overflow and we would lose status reports.
+	 *
+	 * Hence, read the TX_STA_FIFO register and copy all tx status
+	 * reports into a kernel FIFO which is handled in the txstatus
+	 * tasklet. We use a tasklet to process the tx status reports
+	 * because we can schedule the tasklet multiple times (when the
+	 * interrupt fires again during tx status processing).
+	 *
+	 * Furthermore we don't disable the TX_FIFO_STATUS
+	 * interrupt here but leave it enabled so that the TX_STA_FIFO
+	 * can also be read while the tx status tasklet gets executed.
+	 *
+	 * Since we have only one producer and one consumer we don't
+	 * need to lock the kfifo.
+	 */
+	for (i = 0; i < rt2x00dev->tx->limit; i++) {
+		rt2x00mmio_register_read(rt2x00dev, TX_STA_FIFO, &status);
+
+		if (!rt2x00_get_field32(status, TX_STA_FIFO_VALID))
+			break;
+
+		if (!kfifo_put(&rt2x00dev->txstatus_fifo, &status)) {
+			rt2x00_warn(rt2x00dev, "TX status FIFO overrun, drop tx status report\n");
+			break;
+		}
+	}
+
+	/* Schedule the tasklet for processing the tx status. */
+	tasklet_schedule(&rt2x00dev->txstatus_tasklet);
+}
+
+irqreturn_t rt2800mmio_interrupt(int irq, void *dev_instance)
+{
+	struct rt2x00_dev *rt2x00dev = dev_instance;
+	u32 reg, mask;
+
+	/* Read status and ACK all interrupts */
+	rt2x00mmio_register_read(rt2x00dev, INT_SOURCE_CSR, &reg);
+	rt2x00mmio_register_write(rt2x00dev, INT_SOURCE_CSR, reg);
+
+	if (!reg)
+		return IRQ_NONE;
+
+	if (!test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags))
+		return IRQ_HANDLED;
+
+	/*
+	 * Since INT_MASK_CSR and INT_SOURCE_CSR use the same bits
+	 * for interrupts and interrupt masks we can just use the value of
+	 * INT_SOURCE_CSR to create the interrupt mask.
+	 */
+	mask = ~reg;
+
+	if (rt2x00_get_field32(reg, INT_SOURCE_CSR_TX_FIFO_STATUS)) {
+		rt2800mmio_txstatus_interrupt(rt2x00dev);
+		/*
+		 * Never disable the TX_FIFO_STATUS interrupt.
+		 */
+		rt2x00_set_field32(&mask, INT_MASK_CSR_TX_FIFO_STATUS, 1);
+	}
+
+	if (rt2x00_get_field32(reg, INT_SOURCE_CSR_PRE_TBTT))
+		tasklet_hi_schedule(&rt2x00dev->pretbtt_tasklet);
+
+	if (rt2x00_get_field32(reg, INT_SOURCE_CSR_TBTT))
+		tasklet_hi_schedule(&rt2x00dev->tbtt_tasklet);
+
+	if (rt2x00_get_field32(reg, INT_SOURCE_CSR_RX_DONE))
+		tasklet_schedule(&rt2x00dev->rxdone_tasklet);
+
+	if (rt2x00_get_field32(reg, INT_SOURCE_CSR_AUTO_WAKEUP))
+		tasklet_schedule(&rt2x00dev->autowake_tasklet);
+
+	/*
+	 * Disable all interrupts for which a tasklet was scheduled right now,
+	 * the tasklet will reenable the appropriate interrupts.
+	 */
+	spin_lock(&rt2x00dev->irqmask_lock);
+	rt2x00mmio_register_read(rt2x00dev, INT_MASK_CSR, &reg);
+	reg &= mask;
+	rt2x00mmio_register_write(rt2x00dev, INT_MASK_CSR, reg);
+	spin_unlock(&rt2x00dev->irqmask_lock);
+
+	return IRQ_HANDLED;
+}
+EXPORT_SYMBOL_GPL(rt2800mmio_interrupt);
+
+void rt2800mmio_toggle_irq(struct rt2x00_dev *rt2x00dev,
+			   enum dev_state state)
+{
+	u32 reg;
+	unsigned long flags;
+
+	/*
+	 * When interrupts are being enabled, the interrupt registers
+	 * should clear the register to assure a clean state.
+	 */
+	if (state == STATE_RADIO_IRQ_ON) {
+		rt2x00mmio_register_read(rt2x00dev, INT_SOURCE_CSR, &reg);
+		rt2x00mmio_register_write(rt2x00dev, INT_SOURCE_CSR, reg);
+	}
+
+	spin_lock_irqsave(&rt2x00dev->irqmask_lock, flags);
+	reg = 0;
+	if (state == STATE_RADIO_IRQ_ON) {
+		rt2x00_set_field32(&reg, INT_MASK_CSR_RX_DONE, 1);
+		rt2x00_set_field32(&reg, INT_MASK_CSR_TBTT, 1);
+		rt2x00_set_field32(&reg, INT_MASK_CSR_PRE_TBTT, 1);
+		rt2x00_set_field32(&reg, INT_MASK_CSR_TX_FIFO_STATUS, 1);
+		rt2x00_set_field32(&reg, INT_MASK_CSR_AUTO_WAKEUP, 1);
+	}
+	rt2x00mmio_register_write(rt2x00dev, INT_MASK_CSR, reg);
+	spin_unlock_irqrestore(&rt2x00dev->irqmask_lock, flags);
+
+	if (state == STATE_RADIO_IRQ_OFF) {
+		/*
+		 * Wait for possibly running tasklets to finish.
+		 */
+		tasklet_kill(&rt2x00dev->txstatus_tasklet);
+		tasklet_kill(&rt2x00dev->rxdone_tasklet);
+		tasklet_kill(&rt2x00dev->autowake_tasklet);
+		tasklet_kill(&rt2x00dev->tbtt_tasklet);
+		tasklet_kill(&rt2x00dev->pretbtt_tasklet);
+	}
+}
+EXPORT_SYMBOL_GPL(rt2800mmio_toggle_irq);
+
 MODULE_AUTHOR(DRV_PROJECT);
 MODULE_VERSION(DRV_VERSION);
 MODULE_DESCRIPTION("rt2800 MMIO library");
diff --git a/drivers/net/wireless/rt2x00/rt2800mmio.h b/drivers/net/wireless/rt2x00/rt2800mmio.h
index 71e3d22..30e66ab 100644
--- a/drivers/net/wireless/rt2x00/rt2800mmio.h
+++ b/drivers/net/wireless/rt2x00/rt2800mmio.h
@@ -128,5 +128,14 @@ void rt2800mmio_write_tx_desc(struct queue_entry *entry,
 void rt2800mmio_fill_rxdone(struct queue_entry *entry,
 			    struct rxdone_entry_desc *rxdesc);
 
+/* Interrupt functions */
+void rt2800mmio_txstatus_tasklet(unsigned long data);
+void rt2800mmio_pretbtt_tasklet(unsigned long data);
+void rt2800mmio_tbtt_tasklet(unsigned long data);
+void rt2800mmio_rxdone_tasklet(unsigned long data);
+void rt2800mmio_autowake_tasklet(unsigned long data);
+irqreturn_t rt2800mmio_interrupt(int irq, void *dev_instance);
+void rt2800mmio_toggle_irq(struct rt2x00_dev *rt2x00dev,
+			   enum dev_state state);
 
 #endif /* RT2800MMIO_H */
diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index a829ce5..12454b0 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -448,45 +448,6 @@ static int rt2800pci_init_queues(struct rt2x00_dev *rt2x00dev)
 /*
  * Device state switch handlers.
  */
-static void rt2800mmio_toggle_irq(struct rt2x00_dev *rt2x00dev,
-				  enum dev_state state)
-{
-	u32 reg;
-	unsigned long flags;
-
-	/*
-	 * When interrupts are being enabled, the interrupt registers
-	 * should clear the register to assure a clean state.
-	 */
-	if (state == STATE_RADIO_IRQ_ON) {
-		rt2x00mmio_register_read(rt2x00dev, INT_SOURCE_CSR, &reg);
-		rt2x00mmio_register_write(rt2x00dev, INT_SOURCE_CSR, reg);
-	}
-
-	spin_lock_irqsave(&rt2x00dev->irqmask_lock, flags);
-	reg = 0;
-	if (state == STATE_RADIO_IRQ_ON) {
-		rt2x00_set_field32(&reg, INT_MASK_CSR_RX_DONE, 1);
-		rt2x00_set_field32(&reg, INT_MASK_CSR_TBTT, 1);
-		rt2x00_set_field32(&reg, INT_MASK_CSR_PRE_TBTT, 1);
-		rt2x00_set_field32(&reg, INT_MASK_CSR_TX_FIFO_STATUS, 1);
-		rt2x00_set_field32(&reg, INT_MASK_CSR_AUTO_WAKEUP, 1);
-	}
-	rt2x00mmio_register_write(rt2x00dev, INT_MASK_CSR, reg);
-	spin_unlock_irqrestore(&rt2x00dev->irqmask_lock, flags);
-
-	if (state == STATE_RADIO_IRQ_OFF) {
-		/*
-		 * Wait for possibly running tasklets to finish.
-		 */
-		tasklet_kill(&rt2x00dev->txstatus_tasklet);
-		tasklet_kill(&rt2x00dev->rxdone_tasklet);
-		tasklet_kill(&rt2x00dev->autowake_tasklet);
-		tasklet_kill(&rt2x00dev->tbtt_tasklet);
-		tasklet_kill(&rt2x00dev->pretbtt_tasklet);
-	}
-}
-
 static int rt2800pci_init_registers(struct rt2x00_dev *rt2x00dev)
 {
 	u32 reg;
@@ -628,355 +589,6 @@ static int rt2800pci_set_device_state(struct rt2x00_dev *rt2x00dev,
 }
 
 /*
- * Interrupt functions.
- */
-static void rt2800mmio_wakeup(struct rt2x00_dev *rt2x00dev)
-{
-	struct ieee80211_conf conf = { .flags = 0 };
-	struct rt2x00lib_conf libconf = { .conf = &conf };
-
-	rt2800_config(rt2x00dev, &libconf, IEEE80211_CONF_CHANGE_PS);
-}
-
-static bool rt2800mmio_txdone_entry_check(struct queue_entry *entry, u32 status)
-{
-	__le32 *txwi;
-	u32 word;
-	int wcid, tx_wcid;
-
-	wcid = rt2x00_get_field32(status, TX_STA_FIFO_WCID);
-
-	txwi = rt2800_drv_get_txwi(entry);
-	rt2x00_desc_read(txwi, 1, &word);
-	tx_wcid = rt2x00_get_field32(word, TXWI_W1_WIRELESS_CLI_ID);
-
-	return (tx_wcid == wcid);
-}
-
-static bool rt2800mmio_txdone_find_entry(struct queue_entry *entry, void *data)
-{
-	u32 status = *(u32 *)data;
-
-	/*
-	 * rt2800pci hardware might reorder frames when exchanging traffic
-	 * with multiple BA enabled STAs.
-	 *
-	 * For example, a tx queue
-	 *    [ STA1 | STA2 | STA1 | STA2 ]
-	 * can result in tx status reports
-	 *    [ STA1 | STA1 | STA2 | STA2 ]
-	 * when the hw decides to aggregate the frames for STA1 into one AMPDU.
-	 *
-	 * To mitigate this effect, associate the tx status to the first frame
-	 * in the tx queue with a matching wcid.
-	 */
-	if (rt2800mmio_txdone_entry_check(entry, status) &&
-	    !test_bit(ENTRY_DATA_STATUS_SET, &entry->flags)) {
-		/*
-		 * Got a matching frame, associate the tx status with
-		 * the frame
-		 */
-		entry->status = status;
-		set_bit(ENTRY_DATA_STATUS_SET, &entry->flags);
-		return true;
-	}
-
-	/* Check the next frame */
-	return false;
-}
-
-static bool rt2800mmio_txdone_match_first(struct queue_entry *entry, void *data)
-{
-	u32 status = *(u32 *)data;
-
-	/*
-	 * Find the first frame without tx status and assign this status to it
-	 * regardless if it matches or not.
-	 */
-	if (!test_bit(ENTRY_DATA_STATUS_SET, &entry->flags)) {
-		/*
-		 * Got a matching frame, associate the tx status with
-		 * the frame
-		 */
-		entry->status = status;
-		set_bit(ENTRY_DATA_STATUS_SET, &entry->flags);
-		return true;
-	}
-
-	/* Check the next frame */
-	return false;
-}
-static bool rt2800mmio_txdone_release_entries(struct queue_entry *entry,
-					      void *data)
-{
-	if (test_bit(ENTRY_DATA_STATUS_SET, &entry->flags)) {
-		rt2800_txdone_entry(entry, entry->status,
-				    rt2800mmio_get_txwi(entry));
-		return false;
-	}
-
-	/* No more frames to release */
-	return true;
-}
-
-static bool rt2800mmio_txdone(struct rt2x00_dev *rt2x00dev)
-{
-	struct data_queue *queue;
-	u32 status;
-	u8 qid;
-	int max_tx_done = 16;
-
-	while (kfifo_get(&rt2x00dev->txstatus_fifo, &status)) {
-		qid = rt2x00_get_field32(status, TX_STA_FIFO_PID_QUEUE);
-		if (unlikely(qid >= QID_RX)) {
-			/*
-			 * Unknown queue, this shouldn't happen. Just drop
-			 * this tx status.
-			 */
-			rt2x00_warn(rt2x00dev, "Got TX status report with unexpected pid %u, dropping\n",
-				    qid);
-			break;
-		}
-
-		queue = rt2x00queue_get_tx_queue(rt2x00dev, qid);
-		if (unlikely(queue == NULL)) {
-			/*
-			 * The queue is NULL, this shouldn't happen. Stop
-			 * processing here and drop the tx status
-			 */
-			rt2x00_warn(rt2x00dev, "Got TX status for an unavailable queue %u, dropping\n",
-				    qid);
-			break;
-		}
-
-		if (unlikely(rt2x00queue_empty(queue))) {
-			/*
-			 * The queue is empty. Stop processing here
-			 * and drop the tx status.
-			 */
-			rt2x00_warn(rt2x00dev, "Got TX status for an empty queue %u, dropping\n",
-				    qid);
-			break;
-		}
-
-		/*
-		 * Let's associate this tx status with the first
-		 * matching frame.
-		 */
-		if (!rt2x00queue_for_each_entry(queue, Q_INDEX_DONE,
-						Q_INDEX, &status,
-						rt2800mmio_txdone_find_entry)) {
-			/*
-			 * We cannot match the tx status to any frame, so just
-			 * use the first one.
-			 */
-			if (!rt2x00queue_for_each_entry(queue, Q_INDEX_DONE,
-							Q_INDEX, &status,
-							rt2800mmio_txdone_match_first)) {
-				rt2x00_warn(rt2x00dev, "No frame found for TX status on queue %u, dropping\n",
-					    qid);
-				break;
-			}
-		}
-
-		/*
-		 * Release all frames with a valid tx status.
-		 */
-		rt2x00queue_for_each_entry(queue, Q_INDEX_DONE,
-					   Q_INDEX, NULL,
-					   rt2800mmio_txdone_release_entries);
-
-		if (--max_tx_done == 0)
-			break;
-	}
-
-	return !max_tx_done;
-}
-
-static inline void rt2800mmio_enable_interrupt(struct rt2x00_dev *rt2x00dev,
-					       struct rt2x00_field32 irq_field)
-{
-	u32 reg;
-
-	/*
-	 * Enable a single interrupt. The interrupt mask register
-	 * access needs locking.
-	 */
-	spin_lock_irq(&rt2x00dev->irqmask_lock);
-	rt2x00mmio_register_read(rt2x00dev, INT_MASK_CSR, &reg);
-	rt2x00_set_field32(&reg, irq_field, 1);
-	rt2x00mmio_register_write(rt2x00dev, INT_MASK_CSR, reg);
-	spin_unlock_irq(&rt2x00dev->irqmask_lock);
-}
-
-static void rt2800mmio_txstatus_tasklet(unsigned long data)
-{
-	struct rt2x00_dev *rt2x00dev = (struct rt2x00_dev *)data;
-	if (rt2800mmio_txdone(rt2x00dev))
-		tasklet_schedule(&rt2x00dev->txstatus_tasklet);
-
-	/*
-	 * No need to enable the tx status interrupt here as we always
-	 * leave it enabled to minimize the possibility of a tx status
-	 * register overflow. See comment in interrupt handler.
-	 */
-}
-
-static void rt2800mmio_pretbtt_tasklet(unsigned long data)
-{
-	struct rt2x00_dev *rt2x00dev = (struct rt2x00_dev *)data;
-	rt2x00lib_pretbtt(rt2x00dev);
-	if (test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags))
-		rt2800mmio_enable_interrupt(rt2x00dev, INT_MASK_CSR_PRE_TBTT);
-}
-
-static void rt2800mmio_tbtt_tasklet(unsigned long data)
-{
-	struct rt2x00_dev *rt2x00dev = (struct rt2x00_dev *)data;
-	struct rt2800_drv_data *drv_data = rt2x00dev->drv_data;
-	u32 reg;
-
-	rt2x00lib_beacondone(rt2x00dev);
-
-	if (rt2x00dev->intf_ap_count) {
-		/*
-		 * The rt2800pci hardware tbtt timer is off by 1us per tbtt
-		 * causing beacon skew and as a result causing problems with
-		 * some powersaving clients over time. Shorten the beacon
-		 * interval every 64 beacons by 64us to mitigate this effect.
-		 */
-		if (drv_data->tbtt_tick == (BCN_TBTT_OFFSET - 2)) {
-			rt2x00mmio_register_read(rt2x00dev, BCN_TIME_CFG, &reg);
-			rt2x00_set_field32(&reg, BCN_TIME_CFG_BEACON_INTERVAL,
-					   (rt2x00dev->beacon_int * 16) - 1);
-			rt2x00mmio_register_write(rt2x00dev, BCN_TIME_CFG, reg);
-		} else if (drv_data->tbtt_tick == (BCN_TBTT_OFFSET - 1)) {
-			rt2x00mmio_register_read(rt2x00dev, BCN_TIME_CFG, &reg);
-			rt2x00_set_field32(&reg, BCN_TIME_CFG_BEACON_INTERVAL,
-					   (rt2x00dev->beacon_int * 16));
-			rt2x00mmio_register_write(rt2x00dev, BCN_TIME_CFG, reg);
-		}
-		drv_data->tbtt_tick++;
-		drv_data->tbtt_tick %= BCN_TBTT_OFFSET;
-	}
-
-	if (test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags))
-		rt2800mmio_enable_interrupt(rt2x00dev, INT_MASK_CSR_TBTT);
-}
-
-static void rt2800mmio_rxdone_tasklet(unsigned long data)
-{
-	struct rt2x00_dev *rt2x00dev = (struct rt2x00_dev *)data;
-	if (rt2x00mmio_rxdone(rt2x00dev))
-		tasklet_schedule(&rt2x00dev->rxdone_tasklet);
-	else if (test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags))
-		rt2800mmio_enable_interrupt(rt2x00dev, INT_MASK_CSR_RX_DONE);
-}
-
-static void rt2800mmio_autowake_tasklet(unsigned long data)
-{
-	struct rt2x00_dev *rt2x00dev = (struct rt2x00_dev *)data;
-	rt2800mmio_wakeup(rt2x00dev);
-	if (test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags))
-		rt2800mmio_enable_interrupt(rt2x00dev,
-					    INT_MASK_CSR_AUTO_WAKEUP);
-}
-
-static void rt2800mmio_txstatus_interrupt(struct rt2x00_dev *rt2x00dev)
-{
-	u32 status;
-	int i;
-
-	/*
-	 * The TX_FIFO_STATUS interrupt needs special care. We should
-	 * read TX_STA_FIFO but we should do it immediately as otherwise
-	 * the register can overflow and we would lose status reports.
-	 *
-	 * Hence, read the TX_STA_FIFO register and copy all tx status
-	 * reports into a kernel FIFO which is handled in the txstatus
-	 * tasklet. We use a tasklet to process the tx status reports
-	 * because we can schedule the tasklet multiple times (when the
-	 * interrupt fires again during tx status processing).
-	 *
-	 * Furthermore we don't disable the TX_FIFO_STATUS
-	 * interrupt here but leave it enabled so that the TX_STA_FIFO
-	 * can also be read while the tx status tasklet gets executed.
-	 *
-	 * Since we have only one producer and one consumer we don't
-	 * need to lock the kfifo.
-	 */
-	for (i = 0; i < rt2x00dev->tx->limit; i++) {
-		rt2x00mmio_register_read(rt2x00dev, TX_STA_FIFO, &status);
-
-		if (!rt2x00_get_field32(status, TX_STA_FIFO_VALID))
-			break;
-
-		if (!kfifo_put(&rt2x00dev->txstatus_fifo, &status)) {
-			rt2x00_warn(rt2x00dev, "TX status FIFO overrun, drop tx status report\n");
-			break;
-		}
-	}
-
-	/* Schedule the tasklet for processing the tx status. */
-	tasklet_schedule(&rt2x00dev->txstatus_tasklet);
-}
-
-static irqreturn_t rt2800mmio_interrupt(int irq, void *dev_instance)
-{
-	struct rt2x00_dev *rt2x00dev = dev_instance;
-	u32 reg, mask;
-
-	/* Read status and ACK all interrupts */
-	rt2x00mmio_register_read(rt2x00dev, INT_SOURCE_CSR, &reg);
-	rt2x00mmio_register_write(rt2x00dev, INT_SOURCE_CSR, reg);
-
-	if (!reg)
-		return IRQ_NONE;
-
-	if (!test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags))
-		return IRQ_HANDLED;
-
-	/*
-	 * Since INT_MASK_CSR and INT_SOURCE_CSR use the same bits
-	 * for interrupts and interrupt masks we can just use the value of
-	 * INT_SOURCE_CSR to create the interrupt mask.
-	 */
-	mask = ~reg;
-
-	if (rt2x00_get_field32(reg, INT_SOURCE_CSR_TX_FIFO_STATUS)) {
-		rt2800mmio_txstatus_interrupt(rt2x00dev);
-		/*
-		 * Never disable the TX_FIFO_STATUS interrupt.
-		 */
-		rt2x00_set_field32(&mask, INT_MASK_CSR_TX_FIFO_STATUS, 1);
-	}
-
-	if (rt2x00_get_field32(reg, INT_SOURCE_CSR_PRE_TBTT))
-		tasklet_hi_schedule(&rt2x00dev->pretbtt_tasklet);
-
-	if (rt2x00_get_field32(reg, INT_SOURCE_CSR_TBTT))
-		tasklet_hi_schedule(&rt2x00dev->tbtt_tasklet);
-
-	if (rt2x00_get_field32(reg, INT_SOURCE_CSR_RX_DONE))
-		tasklet_schedule(&rt2x00dev->rxdone_tasklet);
-
-	if (rt2x00_get_field32(reg, INT_SOURCE_CSR_AUTO_WAKEUP))
-		tasklet_schedule(&rt2x00dev->autowake_tasklet);
-
-	/*
-	 * Disable all interrupts for which a tasklet was scheduled right now,
-	 * the tasklet will reenable the appropriate interrupts.
-	 */
-	spin_lock(&rt2x00dev->irqmask_lock);
-	rt2x00mmio_register_read(rt2x00dev, INT_MASK_CSR, &reg);
-	reg &= mask;
-	rt2x00mmio_register_write(rt2x00dev, INT_MASK_CSR, reg);
-	spin_unlock(&rt2x00dev->irqmask_lock);
-
-	return IRQ_HANDLED;
-}
-
-/*
  * Device probe functions.
  */
 static int rt2800pci_read_eeprom(struct rt2x00_dev *rt2x00dev)
-- 
1.7.10
