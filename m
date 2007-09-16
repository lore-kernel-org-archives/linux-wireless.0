Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.250]:52973 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589AbXIPMHw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Sep 2007 08:07:52 -0400
Received: by an-out-0708.google.com with SMTP id d31so189208and
        for <linux-wireless@vger.kernel.org>; Sun, 16 Sep 2007 05:07:52 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 3/24] rt2x00: Cleanup rxdone
Date: Sun, 16 Sep 2007 14:18:00 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200709161403.11332.IvDoorn@gmail.com>
In-Reply-To: <200709161403.11332.IvDoorn@gmail.com>
MIME-Version: 1.0
Message-Id: <200709161418.01590.IvDoorn@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove obscure skb allocation with rt2x00lib_rxdone,
and move the allocation into rt2x00pci and rt2x00usb.
Allocation handling is different between PCI and USB
devices and to make the differences more clear they
should be handled within the correct modules.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00.h    |    5 ++---
 drivers/net/wireless/rt2x00/rt2x00dev.c |   27 ++++-----------------------
 drivers/net/wireless/rt2x00/rt2x00pci.c |   18 +++++++++++++++---
 drivers/net/wireless/rt2x00/rt2x00usb.c |   26 +++++++++++++++++++++++---
 4 files changed, 44 insertions(+), 32 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 2105f44..a7527cd 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -742,9 +742,8 @@ struct data_ring *rt2x00lib_get_ring(struct rt2x00_dev *rt2x00dev,
 void rt2x00lib_beacondone(struct rt2x00_dev *rt2x00dev);
 void rt2x00lib_txdone(struct data_entry *entry,
 		      const int status, const int retry);
-void rt2x00lib_rxdone(struct data_entry *entry, char *data,
-		      const int size, const int signal,
-		      const int rssi, const int ofdm);
+void rt2x00lib_rxdone(struct data_entry *entry, struct sk_buff *skb,
+		      const int signal, const int rssi, const int ofdm);
 
 /*
  * TX descriptor initializer
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index c4086f0..f2adaf5 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -341,15 +341,13 @@ void rt2x00lib_txdone(struct data_entry *entry,
 }
 EXPORT_SYMBOL_GPL(rt2x00lib_txdone);
 
-void rt2x00lib_rxdone(struct data_entry *entry, char *data,
-		      const int size, const int signal,
-		      const int rssi, const int ofdm)
+void rt2x00lib_rxdone(struct data_entry *entry, struct sk_buff *skb,
+		      const int signal, const int rssi, const int ofdm)
 {
 	struct rt2x00_dev *rt2x00dev = entry->ring->rt2x00dev;
 	struct ieee80211_rx_status *rx_status = &rt2x00dev->rx_status;
 	struct ieee80211_hw_mode *mode;
 	struct ieee80211_rate *rate;
-	struct sk_buff *skb;
 	unsigned int i;
 	int val = 0;
 
@@ -383,26 +381,9 @@ void rt2x00lib_rxdone(struct data_entry *entry, char *data,
 	rx_status->ssi = rssi;
 
 	/*
-	 * Let's allocate a sk_buff where we can store the received data in,
-	 * note that if data is NULL, we still have to allocate a sk_buff
-	 * but that we should use that to replace the sk_buff which is already
-	 * inside the entry.
+	 * Send frame to mac80211
 	 */
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
+	ieee80211_rx_irqsafe(rt2x00dev->hw, skb, rx_status);
 }
 EXPORT_SYMBOL_GPL(rt2x00lib_rxdone);
 
diff --git a/drivers/net/wireless/rt2x00/rt2x00pci.c b/drivers/net/wireless/rt2x00/rt2x00pci.c
index c54b30f..66fce58 100644
--- a/drivers/net/wireless/rt2x00/rt2x00pci.c
+++ b/drivers/net/wireless/rt2x00/rt2x00pci.c
@@ -123,6 +123,7 @@ void rt2x00pci_rxdone(struct rt2x00_dev *rt2x00dev)
 	struct data_ring *ring = rt2x00dev->rx;
 	struct data_entry *entry;
 	struct data_desc *rxd;
+	struct sk_buff *skb;
 	u32 desc;
 	int retval;
 	int signal;
@@ -144,10 +145,21 @@ void rt2x00pci_rxdone(struct rt2x00_dev *rt2x00dev)
 			goto skip_entry;
 
 		/*
-		 * Send the packet to upper layer.
+		 * Allocate the sk_buffer, initialize it and copy
+		 * all data into it.
 		 */
-		rt2x00lib_rxdone(entry, entry->data_addr, size,
-				 signal, rssi, ofdm);
+		skb = dev_alloc_skb(size + NET_IP_ALIGN);
+		if (!skb)
+			return;
+
+		skb_reserve(skb, NET_IP_ALIGN);
+		skb_put(skb, size);
+		memcpy(skb->data, entry->data_addr, size);
+
+		/*
+		 * Send the frame to rt2x00lib for further processing.
+		 */
+		rt2x00lib_rxdone(entry, skb, signal, rssi, ofdm);
 
 skip_entry:
 		if (test_bit(DEVICE_ENABLED_RADIO, &ring->rt2x00dev->flags)) {
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index 03815b6..31ef87a 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -327,11 +327,13 @@ static void rt2x00usb_interrupt_rxdone(struct urb *urb)
 	struct data_entry *entry = (struct data_entry *)urb->context;
 	struct data_ring *ring = entry->ring;
 	struct rt2x00_dev *rt2x00dev = ring->rt2x00dev;
+	struct sk_buff *skb;
 	int retval;
 	int signal;
 	int rssi;
 	int ofdm;
 	int size;
+	int frame_size;
 
 	if (!test_bit(DEVICE_ENABLED_RADIO, &rt2x00dev->flags) ||
 	    !test_and_clear_bit(ENTRY_OWNER_NIC, &entry->flags))
@@ -351,16 +353,34 @@ static void rt2x00usb_interrupt_rxdone(struct urb *urb)
 		goto skip_entry;
 
 	/*
+	 * Allocate a new sk buffer to replace the current one.
+	 * If allocation fails, we should drop the current frame
+	 * so we can recycle the existing sk buffer for the new frame.
+	 */
+	frame_size = entry->ring->data_size + entry->ring->desc_size;
+	skb = dev_alloc_skb(frame_size + NET_IP_ALIGN);
+	if (!skb)
+		goto skip_entry;
+
+	skb_reserve(skb, NET_IP_ALIGN);
+	skb_put(skb, frame_size);
+
+	/*
 	 * Trim the skb_buffer to only contain the valid
 	 * frame data (so ignore the device's descriptor).
 	 */
 	skb_trim(entry->skb, size);
 
 	/*
-	 * Send the packet to upper layer, and update urb.
+	 * Send the frame to rt2x00lib for further processing.
 	 */
-	rt2x00lib_rxdone(entry, NULL, ring->data_size + ring->desc_size,
-			 signal, rssi, ofdm);
+	rt2x00lib_rxdone(entry, entry->skb, signal, rssi, ofdm);
+
+	/*
+	 * Replace current entry's skb with the newly allocated one,
+	 * and reinitialize the urb.
+	 */
+	entry->skb = skb;
 	urb->transfer_buffer = entry->skb->data;
 	urb->transfer_buffer_length = entry->skb->len;
 
-- 
1.5.3
