Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:48762 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752120Ab3JQHmp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Oct 2013 03:42:45 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 06/21] rt2x00: rt2800pci: use rt2800mmio prefix for interrupt functions
Date: Thu, 17 Oct 2013 09:42:20 +0200
Message-Id: <1381995755-16471-7-git-send-email-juhosg@openwrt.org> (sfid-20131017_094249_698971_F76866BF)
In-Reply-To: <1381995755-16471-1-git-send-email-juhosg@openwrt.org>
References: <1381995755-16471-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The functions are used for devices with memory
mapped I/O and contain no PCI specific code at
all. Use rt2800mmio prefix instead of rt2800pci
in the function names to reflect that.

The patch contains no functional changes.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/rt2x00/rt2800pci.c |   73 ++++++++++++++++---------------
 1 file changed, 37 insertions(+), 36 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index 2cbaaac..a829ce5 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -448,8 +448,8 @@ static int rt2800pci_init_queues(struct rt2x00_dev *rt2x00dev)
 /*
  * Device state switch handlers.
  */
-static void rt2800pci_toggle_irq(struct rt2x00_dev *rt2x00dev,
-				 enum dev_state state)
+static void rt2800mmio_toggle_irq(struct rt2x00_dev *rt2x00dev,
+				  enum dev_state state)
 {
 	u32 reg;
 	unsigned long flags;
@@ -607,7 +607,7 @@ static int rt2800pci_set_device_state(struct rt2x00_dev *rt2x00dev,
 		break;
 	case STATE_RADIO_IRQ_ON:
 	case STATE_RADIO_IRQ_OFF:
-		rt2800pci_toggle_irq(rt2x00dev, state);
+		rt2800mmio_toggle_irq(rt2x00dev, state);
 		break;
 	case STATE_DEEP_SLEEP:
 	case STATE_SLEEP:
@@ -630,7 +630,7 @@ static int rt2800pci_set_device_state(struct rt2x00_dev *rt2x00dev,
 /*
  * Interrupt functions.
  */
-static void rt2800pci_wakeup(struct rt2x00_dev *rt2x00dev)
+static void rt2800mmio_wakeup(struct rt2x00_dev *rt2x00dev)
 {
 	struct ieee80211_conf conf = { .flags = 0 };
 	struct rt2x00lib_conf libconf = { .conf = &conf };
@@ -638,7 +638,7 @@ static void rt2800pci_wakeup(struct rt2x00_dev *rt2x00dev)
 	rt2800_config(rt2x00dev, &libconf, IEEE80211_CONF_CHANGE_PS);
 }
 
-static bool rt2800pci_txdone_entry_check(struct queue_entry *entry, u32 status)
+static bool rt2800mmio_txdone_entry_check(struct queue_entry *entry, u32 status)
 {
 	__le32 *txwi;
 	u32 word;
@@ -653,7 +653,7 @@ static bool rt2800pci_txdone_entry_check(struct queue_entry *entry, u32 status)
 	return (tx_wcid == wcid);
 }
 
-static bool rt2800pci_txdone_find_entry(struct queue_entry *entry, void *data)
+static bool rt2800mmio_txdone_find_entry(struct queue_entry *entry, void *data)
 {
 	u32 status = *(u32 *)data;
 
@@ -670,7 +670,7 @@ static bool rt2800pci_txdone_find_entry(struct queue_entry *entry, void *data)
 	 * To mitigate this effect, associate the tx status to the first frame
 	 * in the tx queue with a matching wcid.
 	 */
-	if (rt2800pci_txdone_entry_check(entry, status) &&
+	if (rt2800mmio_txdone_entry_check(entry, status) &&
 	    !test_bit(ENTRY_DATA_STATUS_SET, &entry->flags)) {
 		/*
 		 * Got a matching frame, associate the tx status with
@@ -685,7 +685,7 @@ static bool rt2800pci_txdone_find_entry(struct queue_entry *entry, void *data)
 	return false;
 }
 
-static bool rt2800pci_txdone_match_first(struct queue_entry *entry, void *data)
+static bool rt2800mmio_txdone_match_first(struct queue_entry *entry, void *data)
 {
 	u32 status = *(u32 *)data;
 
@@ -706,8 +706,8 @@ static bool rt2800pci_txdone_match_first(struct queue_entry *entry, void *data)
 	/* Check the next frame */
 	return false;
 }
-static bool rt2800pci_txdone_release_entries(struct queue_entry *entry,
-					     void *data)
+static bool rt2800mmio_txdone_release_entries(struct queue_entry *entry,
+					      void *data)
 {
 	if (test_bit(ENTRY_DATA_STATUS_SET, &entry->flags)) {
 		rt2800_txdone_entry(entry, entry->status,
@@ -719,7 +719,7 @@ static bool rt2800pci_txdone_release_entries(struct queue_entry *entry,
 	return true;
 }
 
-static bool rt2800pci_txdone(struct rt2x00_dev *rt2x00dev)
+static bool rt2800mmio_txdone(struct rt2x00_dev *rt2x00dev)
 {
 	struct data_queue *queue;
 	u32 status;
@@ -765,14 +765,14 @@ static bool rt2800pci_txdone(struct rt2x00_dev *rt2x00dev)
 		 */
 		if (!rt2x00queue_for_each_entry(queue, Q_INDEX_DONE,
 						Q_INDEX, &status,
-						rt2800pci_txdone_find_entry)) {
+						rt2800mmio_txdone_find_entry)) {
 			/*
 			 * We cannot match the tx status to any frame, so just
 			 * use the first one.
 			 */
 			if (!rt2x00queue_for_each_entry(queue, Q_INDEX_DONE,
 							Q_INDEX, &status,
-							rt2800pci_txdone_match_first)) {
+							rt2800mmio_txdone_match_first)) {
 				rt2x00_warn(rt2x00dev, "No frame found for TX status on queue %u, dropping\n",
 					    qid);
 				break;
@@ -784,7 +784,7 @@ static bool rt2800pci_txdone(struct rt2x00_dev *rt2x00dev)
 		 */
 		rt2x00queue_for_each_entry(queue, Q_INDEX_DONE,
 					   Q_INDEX, NULL,
-					   rt2800pci_txdone_release_entries);
+					   rt2800mmio_txdone_release_entries);
 
 		if (--max_tx_done == 0)
 			break;
@@ -793,8 +793,8 @@ static bool rt2800pci_txdone(struct rt2x00_dev *rt2x00dev)
 	return !max_tx_done;
 }
 
-static inline void rt2800pci_enable_interrupt(struct rt2x00_dev *rt2x00dev,
-					      struct rt2x00_field32 irq_field)
+static inline void rt2800mmio_enable_interrupt(struct rt2x00_dev *rt2x00dev,
+					       struct rt2x00_field32 irq_field)
 {
 	u32 reg;
 
@@ -809,10 +809,10 @@ static inline void rt2800pci_enable_interrupt(struct rt2x00_dev *rt2x00dev,
 	spin_unlock_irq(&rt2x00dev->irqmask_lock);
 }
 
-static void rt2800pci_txstatus_tasklet(unsigned long data)
+static void rt2800mmio_txstatus_tasklet(unsigned long data)
 {
 	struct rt2x00_dev *rt2x00dev = (struct rt2x00_dev *)data;
-	if (rt2800pci_txdone(rt2x00dev))
+	if (rt2800mmio_txdone(rt2x00dev))
 		tasklet_schedule(&rt2x00dev->txstatus_tasklet);
 
 	/*
@@ -822,15 +822,15 @@ static void rt2800pci_txstatus_tasklet(unsigned long data)
 	 */
 }
 
-static void rt2800pci_pretbtt_tasklet(unsigned long data)
+static void rt2800mmio_pretbtt_tasklet(unsigned long data)
 {
 	struct rt2x00_dev *rt2x00dev = (struct rt2x00_dev *)data;
 	rt2x00lib_pretbtt(rt2x00dev);
 	if (test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags))
-		rt2800pci_enable_interrupt(rt2x00dev, INT_MASK_CSR_PRE_TBTT);
+		rt2800mmio_enable_interrupt(rt2x00dev, INT_MASK_CSR_PRE_TBTT);
 }
 
-static void rt2800pci_tbtt_tasklet(unsigned long data)
+static void rt2800mmio_tbtt_tasklet(unsigned long data)
 {
 	struct rt2x00_dev *rt2x00dev = (struct rt2x00_dev *)data;
 	struct rt2800_drv_data *drv_data = rt2x00dev->drv_data;
@@ -861,27 +861,28 @@ static void rt2800pci_tbtt_tasklet(unsigned long data)
 	}
 
 	if (test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags))
-		rt2800pci_enable_interrupt(rt2x00dev, INT_MASK_CSR_TBTT);
+		rt2800mmio_enable_interrupt(rt2x00dev, INT_MASK_CSR_TBTT);
 }
 
-static void rt2800pci_rxdone_tasklet(unsigned long data)
+static void rt2800mmio_rxdone_tasklet(unsigned long data)
 {
 	struct rt2x00_dev *rt2x00dev = (struct rt2x00_dev *)data;
 	if (rt2x00mmio_rxdone(rt2x00dev))
 		tasklet_schedule(&rt2x00dev->rxdone_tasklet);
 	else if (test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags))
-		rt2800pci_enable_interrupt(rt2x00dev, INT_MASK_CSR_RX_DONE);
+		rt2800mmio_enable_interrupt(rt2x00dev, INT_MASK_CSR_RX_DONE);
 }
 
-static void rt2800pci_autowake_tasklet(unsigned long data)
+static void rt2800mmio_autowake_tasklet(unsigned long data)
 {
 	struct rt2x00_dev *rt2x00dev = (struct rt2x00_dev *)data;
-	rt2800pci_wakeup(rt2x00dev);
+	rt2800mmio_wakeup(rt2x00dev);
 	if (test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags))
-		rt2800pci_enable_interrupt(rt2x00dev, INT_MASK_CSR_AUTO_WAKEUP);
+		rt2800mmio_enable_interrupt(rt2x00dev,
+					    INT_MASK_CSR_AUTO_WAKEUP);
 }
 
-static void rt2800pci_txstatus_interrupt(struct rt2x00_dev *rt2x00dev)
+static void rt2800mmio_txstatus_interrupt(struct rt2x00_dev *rt2x00dev)
 {
 	u32 status;
 	int i;
@@ -920,7 +921,7 @@ static void rt2800pci_txstatus_interrupt(struct rt2x00_dev *rt2x00dev)
 	tasklet_schedule(&rt2x00dev->txstatus_tasklet);
 }
 
-static irqreturn_t rt2800pci_interrupt(int irq, void *dev_instance)
+static irqreturn_t rt2800mmio_interrupt(int irq, void *dev_instance)
 {
 	struct rt2x00_dev *rt2x00dev = dev_instance;
 	u32 reg, mask;
@@ -943,7 +944,7 @@ static irqreturn_t rt2800pci_interrupt(int irq, void *dev_instance)
 	mask = ~reg;
 
 	if (rt2x00_get_field32(reg, INT_SOURCE_CSR_TX_FIFO_STATUS)) {
-		rt2800pci_txstatus_interrupt(rt2x00dev);
+		rt2800mmio_txstatus_interrupt(rt2x00dev);
 		/*
 		 * Never disable the TX_FIFO_STATUS interrupt.
 		 */
@@ -1035,12 +1036,12 @@ static const struct rt2800_ops rt2800pci_rt2800_ops = {
 };
 
 static const struct rt2x00lib_ops rt2800pci_rt2x00_ops = {
-	.irq_handler		= rt2800pci_interrupt,
-	.txstatus_tasklet	= rt2800pci_txstatus_tasklet,
-	.pretbtt_tasklet	= rt2800pci_pretbtt_tasklet,
-	.tbtt_tasklet		= rt2800pci_tbtt_tasklet,
-	.rxdone_tasklet		= rt2800pci_rxdone_tasklet,
-	.autowake_tasklet	= rt2800pci_autowake_tasklet,
+	.irq_handler		= rt2800mmio_interrupt,
+	.txstatus_tasklet	= rt2800mmio_txstatus_tasklet,
+	.pretbtt_tasklet	= rt2800mmio_pretbtt_tasklet,
+	.tbtt_tasklet		= rt2800mmio_tbtt_tasklet,
+	.rxdone_tasklet		= rt2800mmio_rxdone_tasklet,
+	.autowake_tasklet	= rt2800mmio_autowake_tasklet,
 	.probe_hw		= rt2800_probe_hw,
 	.get_firmware_name	= rt2800pci_get_firmware_name,
 	.check_firmware		= rt2800_check_firmware,
-- 
1.7.10
