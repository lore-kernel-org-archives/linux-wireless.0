Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.168]:55730 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755264AbXGYUsd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jul 2007 16:48:33 -0400
Received: by ug-out-1314.google.com with SMTP id j3so420021ugf
        for <linux-wireless@vger.kernel.org>; Wed, 25 Jul 2007 13:48:31 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 03/11] rt2x00: Cleanup allocation/initialization
Date: Wed, 25 Jul 2007 22:50:06 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200707252250.06460.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From 6d5aaddbc146959eaaef7ada1760ca7fb6cd9a7d Mon Sep 17 00:00:00 2001
From: Ivo van Doorn <IvDoorn@gmail.com>
Date: Sat, 21 Jul 2007 14:36:47 +0200
Subject: [PATCH 03/11] rt2x00: Cleanup allocation/initialization

Allocation and initialization was not very transparent,
this patch will make it more transparent by making the
following changes:

 - Each module allocate and cleans up its own mess
 - eeprom array is allocated and freed by rt2x00pci/usb
 - Function names concerning ring & entries allocation should
   be changes to better reflect the actual work they do.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/mac80211/rt2x00/rt2400pci.c |   25 +-
 drivers/net/wireless/mac80211/rt2x00/rt2500pci.c |   25 +-
 drivers/net/wireless/mac80211/rt2x00/rt2500usb.c |   25 +-
 drivers/net/wireless/mac80211/rt2x00/rt2x00.h    |    1 +
 drivers/net/wireless/mac80211/rt2x00/rt2x00dev.c |  518 +++++++++++-----------
 drivers/net/wireless/mac80211/rt2x00/rt2x00pci.c |   58 ++-
 drivers/net/wireless/mac80211/rt2x00/rt2x00usb.c |   66 +++-
 drivers/net/wireless/mac80211/rt2x00/rt61pci.c   |   25 +-
 drivers/net/wireless/mac80211/rt2x00/rt73usb.c   |   25 +-
 9 files changed, 403 insertions(+), 365 deletions(-)

diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c b/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c
index df2221b..a6c7602 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c
@@ -1311,21 +1311,13 @@ static irqreturn_t rt2400pci_interrupt(int irq, void *dev_instance)
 /*
  * Device initialization functions.
  */
-static int rt2400pci_alloc_eeprom(struct rt2x00_dev *rt2x00dev)
+static int rt2400pci_validate_eeprom(struct rt2x00_dev *rt2x00dev)
 {
 	struct eeprom_93cx6 eeprom;
 	u32 reg;
 	u16 word;
 	u8 *mac;
 
-	/*
-	 * Allocate the eeprom memory, check the eeprom width
-	 * and copy the entire eeprom into this allocated memory.
-	 */
-	rt2x00dev->eeprom = kzalloc(EEPROM_SIZE, GFP_KERNEL);
-	if (!rt2x00dev->eeprom)
-		return -ENOMEM;
-
 	rt2x00pci_register_read(rt2x00dev, CSR21, &reg);
 
 	eeprom.data = rt2x00dev;
@@ -1482,7 +1474,7 @@ static int rt2400pci_init_hw(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Allocate eeprom data.
 	 */
-	retval = rt2400pci_alloc_eeprom(rt2x00dev);
+	retval = rt2400pci_validate_eeprom(rt2x00dev);
 	if (retval)
 		return retval;
 
@@ -1644,13 +1636,14 @@ static const struct rt2x00lib_ops rt2400pci_rt2x00_ops = {
 };
 
 static const struct rt2x00_ops rt2400pci_ops = {
-	.name	= DRV_NAME,
-	.rxd_size = RXD_DESC_SIZE,
-	.txd_size = TXD_DESC_SIZE,
-	.lib	= &rt2400pci_rt2x00_ops,
-	.hw	= &rt2400pci_mac80211_ops,
+	.name		= DRV_NAME,
+	.rxd_size	= RXD_DESC_SIZE,
+	.txd_size	= TXD_DESC_SIZE,
+	.eeprom_size	= EEPROM_SIZE,
+	.lib		= &rt2400pci_rt2x00_ops,
+	.hw		= &rt2400pci_mac80211_ops,
 #ifdef CONFIG_RT2X00_LIB_DEBUGFS
-	.debugfs = &rt2400pci_rt2x00debug,
+	.debugfs	= &rt2400pci_rt2x00debug,
 #endif /* CONFIG_RT2X00_LIB_DEBUGFS */
 };
 
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c b/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c
index 34c2e9f..088c717 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c
@@ -1458,21 +1458,13 @@ static irqreturn_t rt2500pci_interrupt(int irq, void *dev_instance)
 /*
  * Device initialization functions.
  */
-static int rt2500pci_alloc_eeprom(struct rt2x00_dev *rt2x00dev)
+static int rt2500pci_validate_eeprom(struct rt2x00_dev *rt2x00dev)
 {
 	struct eeprom_93cx6 eeprom;
 	u32 reg;
 	u16 word;
 	u8 *mac;
 
-	/*
-	 * Allocate the eeprom memory, check the eeprom width
-	 * and copy the entire eeprom into this allocated memory.
-	 */
-	rt2x00dev->eeprom = kzalloc(EEPROM_SIZE, GFP_KERNEL);
-	if (!rt2x00dev->eeprom)
-		return -ENOMEM;
-
 	rt2x00pci_register_read(rt2x00dev, CSR21, &reg);
 
 	eeprom.data = rt2x00dev;
@@ -1727,7 +1719,7 @@ static int rt2500pci_init_hw(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Allocate eeprom data.
 	 */
-	retval = rt2500pci_alloc_eeprom(rt2x00dev);
+	retval = rt2500pci_validate_eeprom(rt2x00dev);
 	if (retval)
 		return retval;
 
@@ -1865,13 +1857,14 @@ static const struct rt2x00lib_ops rt2500pci_rt2x00_ops = {
 };
 
 static const struct rt2x00_ops rt2500pci_ops = {
-	.name	= DRV_NAME,
-	.rxd_size = RXD_DESC_SIZE,
-	.txd_size = TXD_DESC_SIZE,
-	.lib	= &rt2500pci_rt2x00_ops,
-	.hw	= &rt2500pci_mac80211_ops,
+	.name		= DRV_NAME,
+	.rxd_size	= RXD_DESC_SIZE,
+	.txd_size	= TXD_DESC_SIZE,
+	.eeprom_size	= EEPROM_SIZE,
+	.lib		= &rt2500pci_rt2x00_ops,
+	.hw		= &rt2500pci_mac80211_ops,
 #ifdef CONFIG_RT2X00_LIB_DEBUGFS
-	.debugfs = &rt2500pci_rt2x00debug,
+	.debugfs	= &rt2500pci_rt2x00debug,
 #endif /* CONFIG_RT2X00_LIB_DEBUGFS */
 };
 
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c b/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c
index 0d31c6c..8967155 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c
@@ -1135,19 +1135,11 @@ static int rt2500usb_fill_rxdone(struct data_entry *entry,
 /*
  * Device initialization functions.
  */
-static int rt2500usb_alloc_eeprom(struct rt2x00_dev *rt2x00dev)
+static int rt2500usb_validate_eeprom(struct rt2x00_dev *rt2x00dev)
 {
 	u16 word;
 	u8 *mac;
 
-	/*
-	 * Allocate the eeprom memory, check the eeprom width
-	 * and copy the entire eeprom into this allocated memory.
-	 */
-	rt2x00dev->eeprom = kzalloc(EEPROM_SIZE, GFP_KERNEL);
-	if (!rt2x00dev->eeprom)
-		return -ENOMEM;
-
 	rt2x00usb_vendor_request(
 		rt2x00dev, USB_EEPROM_READ, USB_VENDOR_REQUEST_IN,
 		EEPROM_BASE, 0x00, rt2x00dev->eeprom, EEPROM_SIZE,
@@ -1436,7 +1428,7 @@ static int rt2500usb_init_hw(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Allocate eeprom data.
 	 */
-	retval = rt2500usb_alloc_eeprom(rt2x00dev);
+	retval = rt2500usb_validate_eeprom(rt2x00dev);
 	if (retval)
 		return retval;
 
@@ -1521,13 +1513,14 @@ static const struct rt2x00lib_ops rt2500usb_rt2x00_ops = {
 };
 
 static const struct rt2x00_ops rt2500usb_ops = {
-	.name	= DRV_NAME,
-	.rxd_size = RXD_DESC_SIZE,
-	.txd_size = TXD_DESC_SIZE,
-	.lib	= &rt2500usb_rt2x00_ops,
-	.hw	= &rt2500usb_mac80211_ops,
+	.name		= DRV_NAME,
+	.rxd_size	= RXD_DESC_SIZE,
+	.txd_size	= TXD_DESC_SIZE,
+	.eeprom_size	= EEPROM_SIZE,
+	.lib		= &rt2500usb_rt2x00_ops,
+	.hw		= &rt2500usb_mac80211_ops,
 #ifdef CONFIG_RT2X00_LIB_DEBUGFS
-	.debugfs = &rt2500usb_rt2x00debug,
+	.debugfs	= &rt2500usb_rt2x00debug,
 #endif /* CONFIG_RT2X00_LIB_DEBUGFS */
 };
 
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2x00.h b/drivers/net/wireless/mac80211/rt2x00/rt2x00.h
index e6f84ac..bc4557d 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2x00.h
@@ -720,6 +720,7 @@ struct rt2x00_ops {
 	const char *name;
 	const unsigned int rxd_size;
 	const unsigned int txd_size;
+	const unsigned int eeprom_size;
 	const struct rt2x00lib_ops *lib;
 	const struct ieee80211_ops *hw;
 #ifdef CONFIG_RT2X00_LIB_DEBUGFS
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2x00dev.c b/drivers/net/wireless/mac80211/rt2x00/rt2x00dev.c
index 375645a..f4fedeb 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2x00dev.c
@@ -223,6 +223,239 @@ void rt2x00lib_config_antenna(struct rt2x00_dev *rt2x00dev,
 }
 
 /*
+ * Interrupt context handlers.
+ */
+void rt2x00lib_txdone(struct data_entry *entry,
+	const int status, const int retry)
+{
+	struct rt2x00_dev *rt2x00dev = entry->ring->rt2x00dev;
+	struct ieee80211_tx_status *tx_status = &entry->tx_status;
+	struct ieee80211_low_level_stats *stats = &rt2x00dev->low_level_stats;
+
+	/*
+	 * Update TX statistics.
+	 */
+	tx_status->flags = 0;
+	tx_status->ack_signal = 0;
+	tx_status->excessive_retries = (status == TX_FAIL_RETRY);
+	tx_status->retry_count = retry;
+
+	if (!(tx_status->control.flags & IEEE80211_TXCTL_NO_ACK)) {
+		if (status == TX_SUCCESS || status == TX_SUCCESS_RETRY)
+			tx_status->flags |= IEEE80211_TX_STATUS_ACK;
+		else
+			stats->dot11ACKFailureCount++;
+	}
+
+	tx_status->queue_length = entry->ring->stats.limit;
+	tx_status->queue_number = tx_status->control.queue;
+
+	if (tx_status->control.flags & IEEE80211_TXCTL_USE_RTS_CTS) {
+		if (status == TX_SUCCESS || status == TX_SUCCESS_RETRY)
+			stats->dot11RTSSuccessCount++;
+		else
+			stats->dot11RTSFailureCount++;
+	}
+
+	/*
+	 * Send the tx_status to mac80211,
+	 * that method also cleans up the skb structure.
+	 */
+	ieee80211_tx_status_irqsafe(rt2x00dev->hw, entry->skb, tx_status);
+
+	entry->skb = NULL;
+}
+EXPORT_SYMBOL_GPL(rt2x00lib_txdone);
+
+void rt2x00lib_rxdone(struct data_entry *entry, char *data,
+	const int size, const int signal, const int rssi, const int ofdm)
+{
+	struct rt2x00_dev *rt2x00dev = entry->ring->rt2x00dev;
+	struct ieee80211_rx_status *rx_status = &rt2x00dev->rx_status;
+	struct ieee80211_hw_mode *mode;
+	struct ieee80211_rate *rate;
+	struct sk_buff *skb;
+	unsigned int i;
+	int val = 0;
+
+	/*
+	 * Update RX statistics.
+	 */
+	mode = &rt2x00dev->hwmodes[rt2x00dev->curr_hwmode];
+	for (i = 0; i < mode->num_rates; i++) {
+		rate = &mode->rates[i];
+
+		/*
+		 * When frame was received with an OFDM bitrate,
+		 * the signal is the PLCP value. If it was received with
+		 * a CCK bitrate the signal is the rate in 0.5kbit/s.
+		 */
+		if (!ofdm)
+			val = DEVICE_GET_RATE_FIELD(rate->val, RATE);
+		else
+			val = DEVICE_GET_RATE_FIELD(rate->val, PLCP);
+
+		if (val == signal) {
+			/*
+			 * Check for preamble bit.
+			 */
+			if (signal & 0x08)
+				val = rate->val2;
+			else
+				val = rate->val;
+			break;
+		}
+	}
+
+	rx_status->rate = val;
+	rx_status->ssi = rssi;
+	rt2x00_update_link_rssi(&rt2x00dev->link, rssi);
+
+	/*
+	 * Let's allocate a sk_buff where we can store the received data in,
+	 * note that if data is NULL, we still have to allocate a sk_buff
+	 * but that we should use that to replace the sk_buff which is already
+	 * inside the entry.
+	 */
+	skb = dev_alloc_skb(size + NET_IP_ALIGN);
+	if (!skb)
+		return;
+
+	skb_reserve(skb, NET_IP_ALIGN);
+	skb_put(skb, size);
+
+	if (data) {
+		memcpy(skb->data, data, size);
+		entry->skb = skb;
+		skb = NULL;
+	}
+
+	ieee80211_rx_irqsafe(rt2x00dev->hw, entry->skb, rx_status);
+	entry->skb = skb;
+}
+EXPORT_SYMBOL_GPL(rt2x00lib_rxdone);
+
+/*
+ * TX descriptor initializer
+ */
+void rt2x00lib_write_tx_desc(struct rt2x00_dev *rt2x00dev,
+	struct data_entry *entry, struct data_desc *txd,
+	struct ieee80211_hdr *ieee80211hdr, unsigned int length,
+	struct ieee80211_tx_control *control)
+{
+	struct data_entry_desc desc;
+	int tx_rate;
+	int bitrate;
+	int duration;
+	int residual;
+	u16 frame_control;
+	u16 seq_ctrl;
+
+	/*
+	 * Identify queue
+	 */
+	if (control->queue < rt2x00dev->hw->queues)
+		desc.queue = control->queue;
+	else
+		desc.queue = 15;
+
+	/*
+	 * Read required fields from ieee80211 header.
+	 */
+	frame_control = le16_to_cpu(ieee80211hdr->frame_control);
+	seq_ctrl = le16_to_cpu(ieee80211hdr->seq_ctrl);
+
+	tx_rate = control->tx_rate;
+
+	/*
+	 * Check if this is a RTS/CTS frame
+	 */
+	if (is_rts_frame(frame_control) || is_cts_frame(frame_control)) {
+		if (is_rts_frame(frame_control))
+			__set_bit(ENTRY_TXD_RTS_FRAME, &entry->flags);
+		if (control->rts_cts_rate)
+			tx_rate = control->rts_cts_rate;
+	}
+
+	/*
+	 * Check for OFDM
+	 */
+	if (DEVICE_GET_RATE_FIELD(tx_rate, RATEMASK) & DEV_OFDM_RATE)
+		__set_bit(ENTRY_TXD_OFDM_RATE, &entry->flags);
+
+	/*
+	 * Check if more fragments are pending
+	 */
+	if (ieee80211_get_morefrag(ieee80211hdr))
+		__set_bit(ENTRY_TXD_MORE_FRAG, &entry->flags);
+
+	/*
+	 * Beacons and probe responses require the tsf timestamp
+	 * to be inserted into the frame.
+	 */
+	if (control->queue == IEEE80211_TX_QUEUE_BEACON ||
+	    is_probe_resp(frame_control))
+		__set_bit(ENTRY_TXD_REQ_TIMESTAMP, &entry->flags);
+
+	/*
+	 * Check if ACK is required
+	 */
+	if (!(control->flags & IEEE80211_TXCTL_NO_ACK))
+		__set_bit(ENTRY_TXD_REQ_ACK, &entry->flags);
+
+	/*
+	 * Determine with what IFS priority this frame should be send.
+	 * Set ifs to IFS_SIFS when the this is not the first fragment,
+	 * or this fragment came after RTS/CTS.
+	 */
+	if ((seq_ctrl & IEEE80211_SCTL_FRAG) > 0 ||
+	    test_bit(ENTRY_TXD_RTS_FRAME, &entry->flags))
+		desc.ifs = IFS_SIFS;
+	else
+		desc.ifs = IFS_BACKOFF;
+
+	/*
+	 * How the length should be processed depends
+	 * on if we are working with OFDM rates or not.
+	 */
+	if (test_bit(ENTRY_TXD_OFDM_RATE, &entry->flags)) {
+		residual = 0;
+		desc.length_high = ((length + FCS_LEN) >> 6) & 0x3f;
+		desc.length_low = ((length + FCS_LEN) & 0x3f);
+
+	} else {
+		bitrate = DEVICE_GET_RATE_FIELD(tx_rate, RATE);
+
+		/*
+		 * Convert length to microseconds.
+		 */
+		residual = get_duration_res(length + FCS_LEN, bitrate);
+		duration = get_duration(length + FCS_LEN, bitrate);
+
+		if (residual != 0)
+			duration++;
+
+		desc.length_high = duration >> 8;
+		desc.length_low = duration & 0xff;
+	}
+
+	/*
+	 * Create the signal and service values.
+	 */
+	desc.signal = DEVICE_GET_RATE_FIELD(tx_rate, PLCP);
+	if (DEVICE_GET_RATE_FIELD(tx_rate, PREAMBLE))
+		desc.signal |= 0x08;
+
+	desc.service = 0x04;
+	if (residual <= (8 % 11))
+		desc.service |= 0x80;
+
+	rt2x00dev->ops->lib->write_tx_desc(rt2x00dev, entry, txd, &desc,
+		ieee80211hdr, length, control);
+}
+EXPORT_SYMBOL_GPL(rt2x00lib_write_tx_desc);
+
+/*
  * Driver initialization handlers.
  */
 static void rt2x00lib_channel(struct ieee80211_channel *entry,
@@ -438,7 +671,7 @@ static int rt2x00lib_init_hw(struct rt2x00_dev *rt2x00dev)
 /*
  * Initialization/uninitialization handlers.
  */
-static int rt2x00lib_alloc_ring(struct data_ring *ring,
+static int rt2x00lib_alloc_entries(struct data_ring *ring,
 	const u16 max_entries, const u16 data_size, const u16 desc_size)
 {
 	struct data_entry *entry;
@@ -466,14 +699,14 @@ static int rt2x00lib_alloc_ring(struct data_ring *ring,
 	return 0;
 }
 
-static int rt2x00lib_allocate_rings(struct rt2x00_dev *rt2x00dev)
+static int rt2x00lib_alloc_ring_entries(struct rt2x00_dev *rt2x00dev)
 {
 	struct data_ring *ring;
 
 	/*
 	 * Allocate the RX ring.
 	 */
-	if (rt2x00lib_alloc_ring(rt2x00dev->rx,
+	if (rt2x00lib_alloc_entries(rt2x00dev->rx,
 		RX_ENTRIES, DATA_FRAME_SIZE, rt2x00dev->ops->rxd_size))
 		return -ENOMEM;
 
@@ -481,7 +714,7 @@ static int rt2x00lib_allocate_rings(struct rt2x00_dev *rt2x00dev)
 	 * First allocate the TX rings.
 	 */
 	txring_for_each(rt2x00dev, ring) {
-		if (rt2x00lib_alloc_ring(ring,
+		if (rt2x00lib_alloc_entries(ring,
 			TX_ENTRIES, DATA_FRAME_SIZE, rt2x00dev->ops->txd_size))
 			return -ENOMEM;
 	}
@@ -489,23 +722,24 @@ static int rt2x00lib_allocate_rings(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Allocate the BEACON ring.
 	 */
-	if (rt2x00lib_alloc_ring(&rt2x00dev->bcn[0],
+	if (rt2x00lib_alloc_entries(&rt2x00dev->bcn[0],
 		BEACON_ENTRIES, MGMT_FRAME_SIZE, rt2x00dev->ops->txd_size))
 		return -ENOMEM;
 
 	/*
 	 * Allocate the Atim ring.
 	 */
-	if (test_bit(DEVICE_SUPPORT_ATIM, &rt2x00dev->flags)) {
-		if (rt2x00lib_alloc_ring(&rt2x00dev->bcn[1],
-			ATIM_ENTRIES, DATA_FRAME_SIZE, rt2x00dev->ops->txd_size))
-			return -ENOMEM;
-	}
+	if (!test_bit(DEVICE_SUPPORT_ATIM, &rt2x00dev->flags))
+		return 0;
+
+	if (rt2x00lib_alloc_entries(&rt2x00dev->bcn[1],
+		ATIM_ENTRIES, DATA_FRAME_SIZE, rt2x00dev->ops->txd_size))
+		return -ENOMEM;
 
 	return 0;
 }
 
-static void rt2x00lib_free_rings(struct rt2x00_dev *rt2x00dev)
+static void rt2x00lib_free_ring_entries(struct rt2x00_dev *rt2x00dev)
 {
 	struct data_ring *ring;
 
@@ -523,9 +757,9 @@ int rt2x00lib_initialize(struct rt2x00_dev *rt2x00dev)
 		return 0;
 
 	/*
-	 * Allocate all data rings.
+	 * Allocate all ring entries.
 	 */
-	status = rt2x00lib_allocate_rings(rt2x00dev);
+	status = rt2x00lib_alloc_ring_entries(rt2x00dev);
 	if (status) {
 		ERROR(rt2x00dev, "DMA allocation failed.\n");
 		return status;
@@ -553,7 +787,7 @@ exit_unitialize:
 	rt2x00lib_uninitialize(rt2x00dev);
 
 exit:
-	rt2x00lib_free_rings(rt2x00dev);
+	rt2x00lib_free_ring_entries(rt2x00dev);
 
 	return status;
 }
@@ -574,9 +808,9 @@ void rt2x00lib_uninitialize(struct rt2x00_dev *rt2x00dev)
 	rt2x00dev->ops->lib->uninitialize(rt2x00dev);
 
 	/*
-	 * Free allocated datarings.
+	 * Free allocated ring entries.
 	 */
-	rt2x00lib_free_rings(rt2x00dev);
+	rt2x00lib_free_ring_entries(rt2x00dev);
 }
 
 /*
@@ -625,6 +859,14 @@ static int rt2x00lib_alloc_rings(struct rt2x00_dev *rt2x00dev)
 	return 0;
 }
 
+static void rt2x00lib_free_rings(struct rt2x00_dev *rt2x00dev)
+{
+	kfree(rt2x00dev->rx);
+	rt2x00dev->rx = NULL;
+	rt2x00dev->tx = NULL;
+	rt2x00dev->bcn = NULL;
+}
+
 int rt2x00lib_probe_dev(struct rt2x00_dev *rt2x00dev)
 {
 	int retval = -ENOMEM;
@@ -715,16 +957,7 @@ void rt2x00lib_remove_dev(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Free ring structures.
 	 */
-	kfree(rt2x00dev->rx);
-	rt2x00dev->rx = NULL;
-	rt2x00dev->tx = NULL;
-	rt2x00dev->bcn = NULL;
-
-	/*
-	 * Free EEPROM memory.
-	 */
-	kfree(rt2x00dev->eeprom);
-	rt2x00dev->eeprom = NULL;
+	rt2x00lib_free_rings(rt2x00dev);
 }
 EXPORT_SYMBOL_GPL(rt2x00lib_remove_dev);
 
@@ -760,239 +993,6 @@ int rt2x00lib_resume(struct rt2x00_dev *rt2x00dev)
 EXPORT_SYMBOL_GPL(rt2x00lib_resume);
 
 /*
- * Interrupt context handlers.
- */
-void rt2x00lib_txdone(struct data_entry *entry,
-	const int status, const int retry)
-{
-	struct rt2x00_dev *rt2x00dev = entry->ring->rt2x00dev;
-	struct ieee80211_tx_status *tx_status = &entry->tx_status;
-	struct ieee80211_low_level_stats *stats = &rt2x00dev->low_level_stats;
-
-	/*
-	 * Update TX statistics.
-	 */
-	tx_status->flags = 0;
-	tx_status->ack_signal = 0;
-	tx_status->excessive_retries = (status == TX_FAIL_RETRY);
-	tx_status->retry_count = retry;
-
-	if (!(tx_status->control.flags & IEEE80211_TXCTL_NO_ACK)) {
-		if (status == TX_SUCCESS || status == TX_SUCCESS_RETRY)
-			tx_status->flags |= IEEE80211_TX_STATUS_ACK;
-		else
-			stats->dot11ACKFailureCount++;
-	}
-
-	tx_status->queue_length = entry->ring->stats.limit;
-	tx_status->queue_number = tx_status->control.queue;
-
-	if (tx_status->control.flags & IEEE80211_TXCTL_USE_RTS_CTS) {
-		if (status == TX_SUCCESS || status == TX_SUCCESS_RETRY)
-			stats->dot11RTSSuccessCount++;
-		else
-			stats->dot11RTSFailureCount++;
-	}
-
-	/*
-	 * Send the tx_status to mac80211,
-	 * that method also cleans up the skb structure.
-	 */
-	ieee80211_tx_status_irqsafe(rt2x00dev->hw, entry->skb, tx_status);
-
-	entry->skb = NULL;
-}
-EXPORT_SYMBOL_GPL(rt2x00lib_txdone);
-
-void rt2x00lib_rxdone(struct data_entry *entry, char *data,
-	const int size, const int signal, const int rssi, const int ofdm)
-{
-	struct rt2x00_dev *rt2x00dev = entry->ring->rt2x00dev;
-	struct ieee80211_rx_status *rx_status = &rt2x00dev->rx_status;
-	struct ieee80211_hw_mode *mode;
-	struct ieee80211_rate *rate;
-	struct sk_buff *skb;
-	unsigned int i;
-	int val = 0;
-
-	/*
-	 * Update RX statistics.
-	 */
-	mode = &rt2x00dev->hwmodes[rt2x00dev->curr_hwmode];
-	for (i = 0; i < mode->num_rates; i++) {
-		rate = &mode->rates[i];
-
-		/*
-		 * When frame was received with an OFDM bitrate,
-		 * the signal is the PLCP value. If it was received with
-		 * a CCK bitrate the signal is the rate in 0.5kbit/s.
-		 */
-		if (!ofdm)
-			val = DEVICE_GET_RATE_FIELD(rate->val, RATE);
-		else
-			val = DEVICE_GET_RATE_FIELD(rate->val, PLCP);
-
-		if (val == signal) {
-			/*
-			 * Check for preamble bit.
-			 */
-			if (signal & 0x08)
-				val = rate->val2;
-			else
-				val = rate->val;
-			break;
-		}
-	}
-
-	rx_status->rate = val;
-	rx_status->ssi = rssi;
-	rt2x00_update_link_rssi(&rt2x00dev->link, rssi);
-
-	/*
-	 * Let's allocate a sk_buff where we can store the received data in,
-	 * note that if data is NULL, we still have to allocate a sk_buff
-	 * but that we should use that to replace the sk_buff which is already
-	 * inside the entry.
-	 */
-	skb = dev_alloc_skb(size + NET_IP_ALIGN);
-	if (!skb)
-		return;
-
-	skb_reserve(skb, NET_IP_ALIGN);
-	skb_put(skb, size);
-
-	if (data) {
-		memcpy(skb->data, data, size);
-		entry->skb = skb;
-		skb = NULL;
-	}
-
-	ieee80211_rx_irqsafe(rt2x00dev->hw, entry->skb, rx_status);
-	entry->skb = skb;
-}
-EXPORT_SYMBOL_GPL(rt2x00lib_rxdone);
-
-/*
- * TX descriptor initializer
- */
-void rt2x00lib_write_tx_desc(struct rt2x00_dev *rt2x00dev,
-	struct data_entry *entry, struct data_desc *txd,
-	struct ieee80211_hdr *ieee80211hdr, unsigned int length,
-	struct ieee80211_tx_control *control)
-{
-	struct data_entry_desc desc;
-	int tx_rate;
-	int bitrate;
-	int duration;
-	int residual;
-	u16 frame_control;
-	u16 seq_ctrl;
-
-	/*
-	 * Identify queue
-	 */
-	if (control->queue < rt2x00dev->hw->queues)
-		desc.queue = control->queue;
-	else
-		desc.queue = 15;
-
-	/*
-	 * Read required fields from ieee80211 header.
-	 */
-	frame_control = le16_to_cpu(ieee80211hdr->frame_control);
-	seq_ctrl = le16_to_cpu(ieee80211hdr->seq_ctrl);
-
-	tx_rate = control->tx_rate;
-
-	/*
-	 * Check if this is a RTS/CTS frame
-	 */
-	if (is_rts_frame(frame_control) || is_cts_frame(frame_control)) {
-		if (is_rts_frame(frame_control))
-			__set_bit(ENTRY_TXD_RTS_FRAME, &entry->flags);
-		if (control->rts_cts_rate)
-			tx_rate = control->rts_cts_rate;
-	}
-
-	/*
-	 * Check for OFDM
-	 */
-	if (DEVICE_GET_RATE_FIELD(tx_rate, RATEMASK) & DEV_OFDM_RATE)
-		__set_bit(ENTRY_TXD_OFDM_RATE, &entry->flags);
-
-	/*
-	 * Check if more fragments are pending
-	 */
-	if (ieee80211_get_morefrag(ieee80211hdr))
-		__set_bit(ENTRY_TXD_MORE_FRAG, &entry->flags);
-
-	/*
-	 * Beacons and probe responses require the tsf timestamp
-	 * to be inserted into the frame.
-	 */
-	if (control->queue == IEEE80211_TX_QUEUE_BEACON ||
-	    is_probe_resp(frame_control))
-		__set_bit(ENTRY_TXD_REQ_TIMESTAMP, &entry->flags);
-
-	/*
-	 * Check if ACK is required
-	 */
-	if (!(control->flags & IEEE80211_TXCTL_NO_ACK))
-		__set_bit(ENTRY_TXD_REQ_ACK, &entry->flags);
-
-	/*
-	 * Determine with what IFS priority this frame should be send.
-	 * Set ifs to IFS_SIFS when the this is not the first fragment,
-	 * or this fragment came after RTS/CTS.
-	 */
-	if ((seq_ctrl & IEEE80211_SCTL_FRAG) > 0 ||
-	    test_bit(ENTRY_TXD_RTS_FRAME, &entry->flags))
-		desc.ifs = IFS_SIFS;
-	else
-		desc.ifs = IFS_BACKOFF;
-
-	/*
-	 * How the length should be processed depends
-	 * on if we are working with OFDM rates or not.
-	 */
-	if (test_bit(ENTRY_TXD_OFDM_RATE, &entry->flags)) {
-		residual = 0;
-		desc.length_high = ((length + FCS_LEN) >> 6) & 0x3f;
-		desc.length_low = ((length + FCS_LEN) & 0x3f);
-
-	} else {
-		bitrate = DEVICE_GET_RATE_FIELD(tx_rate, RATE);
-
-		/*
-		 * Convert length to microseconds.
-		 */
-		residual = get_duration_res(length + FCS_LEN, bitrate);
-		duration = get_duration(length + FCS_LEN, bitrate);
-
-		if (residual != 0)
-			duration++;
-
-		desc.length_high = duration >> 8;
-		desc.length_low = duration & 0xff;
-	}
-
-	/*
-	 * Create the signal and service values.
-	 */
-	desc.signal = DEVICE_GET_RATE_FIELD(tx_rate, PLCP);
-	if (DEVICE_GET_RATE_FIELD(tx_rate, PREAMBLE))
-		desc.signal |= 0x08;
-
-	desc.service = 0x04;
-	if (residual <= (8 % 11))
-		desc.service |= 0x80;
-
-	rt2x00dev->ops->lib->write_tx_desc(rt2x00dev, entry, txd, &desc,
-		ieee80211hdr, length, control);
-}
-EXPORT_SYMBOL_GPL(rt2x00lib_write_tx_desc);
-
-/*
  * rt2x00lib module information.
  */
 MODULE_AUTHOR(DRV_PROJECT);
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2x00pci.c b/drivers/net/wireless/mac80211/rt2x00/rt2x00pci.c
index 02b8744..8d7d9dc 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2x00pci.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2x00pci.c
@@ -200,7 +200,7 @@ EXPORT_SYMBOL_GPL(rt2x00pci_rxdone);
 		+ ((__i) * (__ring)->data_size);		\
 })
 
-static int rt2x00pci_alloc_ring(struct rt2x00_dev *rt2x00dev,
+static int rt2x00pci_alloc_dma(struct rt2x00_dev *rt2x00dev,
 	struct data_ring *ring)
 {
 	unsigned int i;
@@ -226,6 +226,16 @@ static int rt2x00pci_alloc_ring(struct rt2x00_dev *rt2x00dev,
 	return 0;
 }
 
+static void rt2x00pci_free_dma(struct rt2x00_dev *rt2x00dev,
+	struct data_ring *ring)
+{
+	if (ring->data_addr)
+		pci_free_consistent(rt2x00dev_pci(rt2x00dev),
+			rt2x00_get_ring_size(ring),
+			ring->data_addr, ring->data_dma);
+	ring->data_addr = NULL;
+}
+
 int rt2x00pci_initialize(struct rt2x00_dev *rt2x00dev)
 {
 	struct pci_dev *pci_dev = rt2x00dev_pci(rt2x00dev);
@@ -236,7 +246,7 @@ int rt2x00pci_initialize(struct rt2x00_dev *rt2x00dev)
 	 * Allocate DMA
 	 */
 	ring_for_each(rt2x00dev, ring) {
-		status = rt2x00pci_alloc_ring(rt2x00dev, ring);
+		status = rt2x00pci_alloc_dma(rt2x00dev, ring);
 		if (status)
 			goto exit;
 	}
@@ -245,7 +255,7 @@ int rt2x00pci_initialize(struct rt2x00_dev *rt2x00dev)
 	 * Register interrupt handler.
 	 */
 	status = request_irq(pci_dev->irq, rt2x00dev->ops->lib->irq_handler,
-		IRQF_SHARED, pci_dev->driver->name, rt2x00dev);
+		IRQF_SHARED, pci_name(pci_dev), rt2x00dev);
 	if (status) {
 		ERROR(rt2x00dev, "IRQ %d allocation failed (error %d).\n",
 			pci_dev->irq, status);
@@ -273,13 +283,8 @@ void rt2x00pci_uninitialize(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Free DMA
 	 */
-	ring_for_each(rt2x00dev, ring) {
-		if (ring->data_addr)
-			pci_free_consistent(rt2x00dev_pci(rt2x00dev),
-				rt2x00_get_ring_size(ring),
-				ring->data_addr, ring->data_dma);
-		ring->data_addr = NULL;
-	}
+	ring_for_each(rt2x00dev, ring)
+		rt2x00pci_free_dma(rt2x00dev, ring);
 }
 EXPORT_SYMBOL_GPL(rt2x00pci_uninitialize);
 
@@ -307,6 +312,21 @@ static void rt2x00pci_free_csr(struct rt2x00_dev *rt2x00dev)
 	}
 }
 
+static int rt2x00pci_alloc_eeprom(struct rt2x00_dev *rt2x00dev)
+{
+	rt2x00dev->eeprom = kzalloc(rt2x00dev->ops->eeprom_size, GFP_KERNEL);
+	if (!rt2x00dev->eeprom)
+		return -ENOMEM;
+
+	return 0;
+}
+
+static void rt2x00pci_free_eeprom(struct rt2x00_dev *rt2x00dev)
+{
+	kfree(rt2x00dev->eeprom);
+	rt2x00dev->eeprom = NULL;
+}
+
 int rt2x00pci_probe(struct pci_dev *pci_dev, const struct pci_device_id *id)
 {
 	struct rt2x00_ops *ops = (struct rt2x00_ops*)id->driver_data;
@@ -356,12 +376,19 @@ int rt2x00pci_probe(struct pci_dev *pci_dev, const struct pci_device_id *id)
 	if (retval)
 		goto exit_free_device;
 
-	retval = rt2x00lib_probe_dev(rt2x00dev);
+	retval = rt2x00pci_alloc_eeprom(rt2x00dev);
 	if (retval)
 		goto exit_free_csr;
 
+	retval = rt2x00lib_probe_dev(rt2x00dev);
+	if (retval)
+		goto exit_free_eeprom;
+
 	return 0;
 
+exit_free_eeprom:
+	rt2x00pci_free_eeprom(rt2x00dev);
+
 exit_free_csr:
 	rt2x00pci_free_csr(rt2x00dev);
 
@@ -390,6 +417,8 @@ void rt2x00pci_remove(struct pci_dev *pci_dev)
 	 * Free all allocated data.
 	 */
 	rt2x00lib_remove_dev(rt2x00dev);
+	rt2x00pci_free_eeprom(rt2x00dev);
+	rt2x00pci_free_csr(rt2x00dev);
 	ieee80211_free_hw(hw);
 
 	/*
@@ -412,6 +441,7 @@ int rt2x00pci_suspend(struct pci_dev *pci_dev, pm_message_t state)
 	if (retval)
 		return retval;
 
+	rt2x00pci_free_eeprom(rt2x00dev);
 	rt2x00pci_free_csr(rt2x00dev);
 
 	pci_save_state(pci_dev);
@@ -437,6 +467,12 @@ int rt2x00pci_resume(struct pci_dev *pci_dev)
 	if (retval)
 		return retval;
 
+	retval = rt2x00pci_alloc_eeprom(rt2x00dev);
+	if (retval) {
+		rt2x00pci_free_csr(rt2x00dev);
+		return retval;
+	}
+
 	return rt2x00lib_resume(rt2x00dev);
 }
 EXPORT_SYMBOL_GPL(rt2x00pci_resume);
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2x00usb.c b/drivers/net/wireless/mac80211/rt2x00/rt2x00usb.c
index 9eee567..02f8062 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2x00usb.c
@@ -410,7 +410,7 @@ EXPORT_SYMBOL_GPL(rt2x00usb_disable_radio);
 /*
  * Device initialization handlers.
  */
-static int rt2x00usb_alloc_ring(struct rt2x00_dev *rt2x00dev,
+static int rt2x00usb_alloc_urb(struct rt2x00_dev *rt2x00dev,
 	struct data_ring *ring)
 {
 	unsigned int i;
@@ -427,6 +427,22 @@ static int rt2x00usb_alloc_ring(struct rt2x00_dev *rt2x00dev,
 	return 0;
 }
 
+static void rt2x00usb_free_urb(struct rt2x00_dev *rt2x00dev,
+	struct data_ring *ring)
+{
+	unsigned int i;
+
+	if (!ring->entry)
+		return;
+
+	for (i = 0; i < ring->stats.limit; i++) {
+		usb_kill_urb(ring->entry[i].priv);
+		usb_free_urb(ring->entry[i].priv);
+		if (ring->entry[i].skb)
+			kfree_skb(ring->entry[i].skb);
+	}
+}
+
 int rt2x00usb_initialize(struct rt2x00_dev *rt2x00dev)
 {
 	struct data_ring *ring;
@@ -439,7 +455,7 @@ int rt2x00usb_initialize(struct rt2x00_dev *rt2x00dev)
 	 * Allocate DMA
 	 */
 	ring_for_each(rt2x00dev, ring) {
-		status = rt2x00usb_alloc_ring(rt2x00dev, ring);
+		status = rt2x00usb_alloc_urb(rt2x00dev, ring);
 		if (status)
 			goto exit;
 	}
@@ -471,25 +487,30 @@ EXPORT_SYMBOL_GPL(rt2x00usb_initialize);
 void rt2x00usb_uninitialize(struct rt2x00_dev *rt2x00dev)
 {
 	struct data_ring *ring;
-	unsigned int i;
-
-	ring_for_each(rt2x00dev, ring) {
-		if (!ring->entry)
-			continue;
 
-		for (i = 0; i < ring->stats.limit; i++) {
-			usb_kill_urb(ring->entry[i].priv);
-			usb_free_urb(ring->entry[i].priv);
-			if (ring->entry[i].skb)
-				kfree_skb(ring->entry[i].skb);
-		}
-	}
+	ring_for_each(rt2x00dev, ring)
+		rt2x00usb_free_urb(rt2x00dev, ring);
 }
 EXPORT_SYMBOL_GPL(rt2x00usb_uninitialize);
 
 /*
  * USB driver handlers.
  */
+static int rt2x00usb_alloc_eeprom(struct rt2x00_dev *rt2x00dev)
+{
+	rt2x00dev->eeprom = kzalloc(rt2x00dev->ops->eeprom_size, GFP_KERNEL);
+	if (!rt2x00dev->eeprom)
+		return -ENOMEM;
+
+	return 0;
+}
+
+static void rt2x00usb_free_eeprom(struct rt2x00_dev *rt2x00dev)
+{
+	kfree(rt2x00dev->eeprom);
+	rt2x00dev->eeprom = NULL;
+}
+
 int rt2x00usb_probe(struct usb_interface *usb_intf,
 	const struct usb_device_id *id)
 {
@@ -515,12 +536,19 @@ int rt2x00usb_probe(struct usb_interface *usb_intf,
 	rt2x00dev->ops = ops;
 	rt2x00dev->hw = hw;
 
-	retval = rt2x00lib_probe_dev(rt2x00dev);
+	retval = rt2x00usb_alloc_eeprom(rt2x00dev);
 	if (retval)
 		goto exit_free_device;
 
+	retval = rt2x00lib_probe_dev(rt2x00dev);
+	if (retval)
+		goto exit_free_eeprom;
+
 	return 0;
 
+exit_free_eeprom:
+	rt2x00usb_free_eeprom(rt2x00dev);
+
 exit_free_device:
 	ieee80211_free_hw(hw);
 
@@ -542,6 +570,7 @@ void rt2x00usb_disconnect(struct usb_interface *usb_intf)
 	 * Free all allocated data.
 	 */
 	rt2x00lib_remove_dev(rt2x00dev);
+	rt2x00usb_free_eeprom(rt2x00dev);
 	ieee80211_free_hw(hw);
 
 	/*
@@ -563,6 +592,8 @@ int rt2x00usb_suspend(struct usb_interface *usb_intf, pm_message_t state)
 	if (retval)
 		return retval;
 
+	rt2x00usb_free_eeprom(rt2x00dev);
+
 	/*
 	 * Decrease usbdev refcount.
 	 */
@@ -576,9 +607,14 @@ int rt2x00usb_resume(struct usb_interface *usb_intf)
 {
 	struct ieee80211_hw *hw = usb_get_intfdata(usb_intf);
 	struct rt2x00_dev *rt2x00dev = hw->priv;
+	int retval;
 
 	usb_get_dev(interface_to_usbdev(usb_intf));
 
+	retval = rt2x00usb_alloc_eeprom(rt2x00dev);
+	if (retval)
+		return retval;
+
 	return rt2x00lib_resume(rt2x00dev);
 }
 EXPORT_SYMBOL_GPL(rt2x00usb_resume);
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt61pci.c b/drivers/net/wireless/mac80211/rt2x00/rt61pci.c
index 7ef847d..c935a43 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt61pci.c
@@ -1905,7 +1905,7 @@ static irqreturn_t rt61pci_interrupt(int irq, void *dev_instance)
 /*
  * Device initialization functions.
  */
-static int rt61pci_alloc_eeprom(struct rt2x00_dev *rt2x00dev)
+static int rt61pci_validate_eeprom(struct rt2x00_dev *rt2x00dev)
 {
 	struct eeprom_93cx6 eeprom;
 	u32 reg;
@@ -1913,14 +1913,6 @@ static int rt61pci_alloc_eeprom(struct rt2x00_dev *rt2x00dev)
 	u8 *mac;
 	char value;
 
-	/*
-	 * Allocate the eeprom memory, check the eeprom width
-	 * and copy the entire eeprom into this allocated memory.
-	 */
-	rt2x00dev->eeprom = kzalloc(EEPROM_SIZE, GFP_KERNEL);
-	if (!rt2x00dev->eeprom)
-		return -ENOMEM;
-
 	rt2x00pci_register_read(rt2x00dev, E2PROM_CSR, &reg);
 
 	eeprom.data = rt2x00dev;
@@ -2230,7 +2222,7 @@ static int rt61pci_init_hw(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Allocate eeprom data.
 	 */
-	retval = rt61pci_alloc_eeprom(rt2x00dev);
+	retval = rt61pci_validate_eeprom(rt2x00dev);
 	if (retval)
 		return retval;
 
@@ -2360,13 +2352,14 @@ static const struct rt2x00lib_ops rt61pci_rt2x00_ops = {
 };
 
 static const struct rt2x00_ops rt61pci_ops = {
-	.name	= DRV_NAME,
-	.rxd_size = RXD_DESC_SIZE,
-	.txd_size = TXD_DESC_SIZE,
-	.lib	= &rt61pci_rt2x00_ops,
-	.hw	= &rt61pci_mac80211_ops,
+	.name		= DRV_NAME,
+	.rxd_size	= RXD_DESC_SIZE,
+	.txd_size	= TXD_DESC_SIZE,
+	.eeprom_size	= EEPROM_SIZE,
+	.lib		= &rt61pci_rt2x00_ops,
+	.hw		= &rt61pci_mac80211_ops,
 #ifdef CONFIG_RT2X00_LIB_DEBUGFS
-	.debugfs = &rt61pci_rt2x00debug,
+	.debugfs	= &rt61pci_rt2x00debug,
 #endif /* CONFIG_RT2X00_LIB_DEBUGFS */
 };
 
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt73usb.c b/drivers/net/wireless/mac80211/rt2x00/rt73usb.c
index 533067f..664cd38 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt73usb.c
@@ -1390,20 +1390,12 @@ static int rt73usb_fill_rxdone(struct data_entry *entry,
 /*
  * Device initialization functions.
  */
-static int rt73usb_alloc_eeprom(struct rt2x00_dev *rt2x00dev)
+static int rt73usb_validate_eeprom(struct rt2x00_dev *rt2x00dev)
 {
 	u16 word;
 	u8 *mac;
 	char value;
 
-	/*
-	 * Allocate the eeprom memory, check the eeprom width
-	 * and copy the entire eeprom into this allocated memory.
-	 */
-	rt2x00dev->eeprom = kzalloc(EEPROM_SIZE, GFP_KERNEL);
-	if (!rt2x00dev->eeprom)
-		return -ENOMEM;
-
 	rt2x00usb_vendor_request(
 		rt2x00dev, USB_EEPROM_READ, USB_VENDOR_REQUEST_IN,
 		EEPROM_BASE, 0x00, rt2x00dev->eeprom, EEPROM_SIZE,
@@ -1685,7 +1677,7 @@ static int rt73usb_init_hw(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Allocate eeprom data.
 	 */
-	retval = rt73usb_alloc_eeprom(rt2x00dev);
+	retval = rt73usb_validate_eeprom(rt2x00dev);
 	if (retval)
 		return retval;
 
@@ -1811,13 +1803,14 @@ static const struct rt2x00lib_ops rt73usb_rt2x00_ops = {
 };
 
 static const struct rt2x00_ops rt73usb_ops = {
-	.name	= DRV_NAME,
-	.rxd_size = RXD_DESC_SIZE,
-	.txd_size = TXD_DESC_SIZE,
-	.lib	= &rt73usb_rt2x00_ops,
-	.hw	= &rt73usb_mac80211_ops,
+	.name		= DRV_NAME,
+	.rxd_size	= RXD_DESC_SIZE,
+	.txd_size	= TXD_DESC_SIZE,
+	.eeprom_size	= EEPROM_SIZE,
+	.lib		= &rt73usb_rt2x00_ops,
+	.hw		= &rt73usb_mac80211_ops,
 #ifdef CONFIG_RT2X00_LIB_DEBUGFS
-	.debugfs = &rt73usb_rt2x00debug,
+	.debugfs	= &rt73usb_rt2x00debug,
 #endif /* CONFIG_RT2X00_LIB_DEBUGFS */
 };
 
-- 
1.5.2.2

