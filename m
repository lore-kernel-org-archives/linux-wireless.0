Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.169]:22582 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754137AbXHSSaa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Aug 2007 14:30:30 -0400
Received: by ug-out-1314.google.com with SMTP id j3so446922ugf
        for <linux-wireless@vger.kernel.org>; Sun, 19 Aug 2007 11:30:29 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 05/30] rt2x00: Don't increase rx_failed for individual frames
Date: Sun, 19 Aug 2007 20:22:41 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200708192018.30624.IvDoorn@gmail.com>
In-Reply-To: <200708192018.30624.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200708192022.41221.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From 53237308ec1ca8f3b3679c7e04cfe467bfeef077 Mon Sep 17 00:00:00 2001
From: Ivo van Doorn <IvDoorn@gmail.com>
Date: Sat, 18 Aug 2007 12:55:29 +0200
Subject: [PATCH 05/30] rt2x00: Don't increase rx_failed for individual frames

Add the size argument to fill_rxdone.
This will make the return value of rxdone more meaningfull
(valid frame or invalid frame) and don't increase the
rx_failed counter when a invalid frame is encountered.
This will prevent the signal value to be very low
when monitor mode is enabled and invalid frames are passed
to the device.
Note that dropping of these frames will disappear in the
future when mac80211 receives the correct patches that
will allow us to send corrupt packages to it.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2400pci.c |    9 ++++-----
 drivers/net/wireless/rt2500pci.c |    9 ++++-----
 drivers/net/wireless/rt2500usb.c |    9 ++++-----
 drivers/net/wireless/rt2x00.h    |    2 +-
 drivers/net/wireless/rt2x00pci.c |    7 ++++---
 drivers/net/wireless/rt2x00usb.c |    6 ++++--
 drivers/net/wireless/rt61pci.c   |    9 ++++-----
 drivers/net/wireless/rt73usb.c   |    9 ++++-----
 8 files changed, 29 insertions(+), 31 deletions(-)

diff --git a/drivers/net/wireless/rt2400pci.c b/drivers/net/wireless/rt2400pci.c
index d97fa31..1506666 100644
--- a/drivers/net/wireless/rt2400pci.c
+++ b/drivers/net/wireless/rt2400pci.c
@@ -1203,7 +1203,7 @@ static void rt2400pci_kick_tx_queue(struct rt2x00_dev *rt2x00dev, int queue)
  * RX control handlers
  */
 static int rt2400pci_fill_rxdone(struct data_entry *entry,
-				 int *signal, int *rssi, int *ofdm)
+				 int *signal, int *rssi, int *ofdm, int *size)
 {
 	struct data_desc *rxd = entry->priv;
 	u32 word0;
@@ -1213,10 +1213,8 @@ static int rt2400pci_fill_rxdone(struct data_entry *entry,
 	rt2x00_desc_read(rxd, 2, &word2);
 
 	if (rt2x00_get_field32(word0, RXD_W0_CRC_ERROR) ||
-	    rt2x00_get_field32(word0, RXD_W0_PHYSICAL_ERROR)) {
-		entry->ring->rt2x00dev->link.rx_failed++;
+	    rt2x00_get_field32(word0, RXD_W0_PHYSICAL_ERROR))
 		return -EINVAL;
-	}
 
 	/*
 	 * Obtain the status about this packet.
@@ -1225,8 +1223,9 @@ static int rt2400pci_fill_rxdone(struct data_entry *entry,
 	*rssi = rt2x00_get_field32(word2, RXD_W2_RSSI) -
 	    entry->ring->rt2x00dev->rssi_offset;
 	*ofdm = 0;
+	*size = rt2x00_get_field32(word0, RXD_W0_DATABYTE_COUNT);
 
-	return rt2x00_get_field32(word0, RXD_W0_DATABYTE_COUNT);
+	return 0;
 }
 
 /*
diff --git a/drivers/net/wireless/rt2500pci.c b/drivers/net/wireless/rt2500pci.c
index 0a0fa22..445ec3e 100644
--- a/drivers/net/wireless/rt2500pci.c
+++ b/drivers/net/wireless/rt2500pci.c
@@ -1381,7 +1381,7 @@ static void rt2500pci_kick_tx_queue(struct rt2x00_dev *rt2x00dev, int queue)
  * RX control handlers
  */
 static int rt2500pci_fill_rxdone(struct data_entry *entry,
-				 int *signal, int *rssi, int *ofdm)
+				 int *signal, int *rssi, int *ofdm, int *size)
 {
 	struct data_desc *rxd = entry->priv;
 	u32 word0;
@@ -1392,17 +1392,16 @@ static int rt2500pci_fill_rxdone(struct data_entry *entry,
 
 	if (rt2x00_get_field32(word0, RXD_W0_CRC_ERROR) ||
 	    rt2x00_get_field32(word0, RXD_W0_PHYSICAL_ERROR) ||
-	    rt2x00_get_field32(word0, RXD_W0_ICV_ERROR)) {
-		entry->ring->rt2x00dev->link.rx_failed++;
+	    rt2x00_get_field32(word0, RXD_W0_ICV_ERROR))
 		return -EINVAL;
-	}
 
 	*signal = rt2x00_get_field32(word2, RXD_W2_SIGNAL);
 	*rssi = rt2x00_get_field32(word2, RXD_W2_RSSI) -
 	    entry->ring->rt2x00dev->rssi_offset;
 	*ofdm = rt2x00_get_field32(word0, RXD_W0_OFDM);
+	*size = rt2x00_get_field32(word0, RXD_W0_DATABYTE_COUNT);
 
-	return rt2x00_get_field32(word0, RXD_W0_DATABYTE_COUNT);
+	return 0;
 }
 
 /*
diff --git a/drivers/net/wireless/rt2500usb.c b/drivers/net/wireless/rt2500usb.c
index ad400dd..29b675c 100644
--- a/drivers/net/wireless/rt2500usb.c
+++ b/drivers/net/wireless/rt2500usb.c
@@ -1178,7 +1178,7 @@ static void rt2500usb_kick_tx_queue(struct rt2x00_dev *rt2x00dev, int queue)
  * RX control handlers
  */
 static int rt2500usb_fill_rxdone(struct data_entry *entry,
-				 int *signal, int *rssi, int *ofdm)
+				 int *signal, int *rssi, int *ofdm, int *size)
 {
 	struct urb *urb = entry->priv;
 	struct data_desc *rxd = (struct data_desc *)(entry->skb->data +
@@ -1192,10 +1192,8 @@ static int rt2500usb_fill_rxdone(struct data_entry *entry,
 
 	if (rt2x00_get_field32(word0, RXD_W0_CRC_ERROR) ||
 	    rt2x00_get_field32(word0, RXD_W0_PHYSICAL_ERROR) ||
-	    rt2x00_get_field32(word0, RXD_W0_CIPHER_ERROR)) {
-		entry->ring->rt2x00dev->link.rx_failed++;
+	    rt2x00_get_field32(word0, RXD_W0_CIPHER_ERROR))
 		return -EINVAL;
-	}
 
 	/*
 	 * Obtain the status about this packet.
@@ -1204,8 +1202,9 @@ static int rt2500usb_fill_rxdone(struct data_entry *entry,
 	*rssi = rt2x00_get_field32(word1, RXD_W1_RSSI) -
 	    entry->ring->rt2x00dev->rssi_offset;
 	*ofdm = rt2x00_get_field32(word0, RXD_W0_OFDM);
+	*size = rt2x00_get_field32(word0, RXD_W0_DATABYTE_COUNT);
 
-	return rt2x00_get_field32(word0, RXD_W0_DATABYTE_COUNT);
+	return;
 }
 
 /*
diff --git a/drivers/net/wireless/rt2x00.h b/drivers/net/wireless/rt2x00.h
index b06cda6..4b8906e 100644
--- a/drivers/net/wireless/rt2x00.h
+++ b/drivers/net/wireless/rt2x00.h
@@ -402,7 +402,7 @@ struct rt2x00lib_ops {
 	 * RX control handlers
 	 */
 	int (*fill_rxdone) (struct data_entry *entry,
-			    int *signal, int *rssi, int *ofdm);
+			    int *signal, int *rssi, int *ofdm, int *size);
 
 	/*
 	 * Configuration handlers.
diff --git a/drivers/net/wireless/rt2x00pci.c b/drivers/net/wireless/rt2x00pci.c
index bf62dd0..c54b30f 100644
--- a/drivers/net/wireless/rt2x00pci.c
+++ b/drivers/net/wireless/rt2x00pci.c
@@ -124,6 +124,7 @@ void rt2x00pci_rxdone(struct rt2x00_dev *rt2x00dev)
 	struct data_entry *entry;
 	struct data_desc *rxd;
 	u32 desc;
+	int retval;
 	int signal;
 	int rssi;
 	int ofdm;
@@ -137,9 +138,9 @@ void rt2x00pci_rxdone(struct rt2x00_dev *rt2x00dev)
 		if (rt2x00_get_field32(desc, RXD_ENTRY_OWNER_NIC))
 			break;
 
-		size = rt2x00dev->ops->lib->fill_rxdone(entry, &signal,
-							&rssi, &ofdm);
-		if (size < 0)
+		retval = rt2x00dev->ops->lib->fill_rxdone(entry, &signal,
+							  &rssi, &ofdm, &size);
+		if (retval)
 			goto skip_entry;
 
 		/*
diff --git a/drivers/net/wireless/rt2x00usb.c b/drivers/net/wireless/rt2x00usb.c
index 05ae870..6dd0801 100644
--- a/drivers/net/wireless/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00usb.c
@@ -295,6 +295,7 @@ static void rt2x00usb_interrupt_rxdone(struct urb *urb)
 	struct data_entry *entry = (struct data_entry *)urb->context;
 	struct data_ring *ring = entry->ring;
 	struct rt2x00_dev *rt2x00dev = ring->rt2x00dev;
+	int retval;
 	int signal;
 	int rssi;
 	int ofdm;
@@ -312,8 +313,9 @@ static void rt2x00usb_interrupt_rxdone(struct urb *urb)
 	if (urb->actual_length < entry->ring->desc_size || urb->status)
 		goto skip_entry;
 
-	size = rt2x00dev->ops->lib->fill_rxdone(entry, &signal, &rssi, &ofdm);
-	if (size < 0)
+	retval = rt2x00dev->ops->lib->fill_rxdone(entry, &signal, &rssi,
+						  &ofdm, &size);
+	if (retval)
 		goto skip_entry;
 
 	/*
diff --git a/drivers/net/wireless/rt61pci.c b/drivers/net/wireless/rt61pci.c
index 7f3a00b..e292572 100644
--- a/drivers/net/wireless/rt61pci.c
+++ b/drivers/net/wireless/rt61pci.c
@@ -1797,7 +1797,7 @@ static int rt61pci_agc_to_rssi(struct rt2x00_dev *rt2x00dev, int rxd_w1)
 }
 
 static int rt61pci_fill_rxdone(struct data_entry *entry,
-			       int *signal, int *rssi, int *ofdm)
+			       int *signal, int *rssi, int *ofdm, int *size)
 {
 	struct data_desc *rxd = entry->priv;
 	u32 word0;
@@ -1807,10 +1807,8 @@ static int rt61pci_fill_rxdone(struct data_entry *entry,
 	rt2x00_desc_read(rxd, 1, &word1);
 
 	if (rt2x00_get_field32(word0, RXD_W0_CRC_ERROR) ||
-	    rt2x00_get_field32(word0, RXD_W0_CIPHER_ERROR)) {
-		entry->ring->rt2x00dev->link.rx_failed++;
+	    rt2x00_get_field32(word0, RXD_W0_CIPHER_ERROR))
 		return -EINVAL;
-	}
 
 	/*
 	 * Obtain the status about this packet.
@@ -1818,8 +1816,9 @@ static int rt61pci_fill_rxdone(struct data_entry *entry,
 	*signal = rt2x00_get_field32(word1, RXD_W1_SIGNAL);
 	*rssi = rt61pci_agc_to_rssi(entry->ring->rt2x00dev, word1);
 	*ofdm = rt2x00_get_field32(word0, RXD_W0_OFDM);
+	*size = rt2x00_get_field32(word0, RXD_W0_DATABYTE_COUNT);
 
-	return rt2x00_get_field32(word0, RXD_W0_DATABYTE_COUNT);
+	return 0;
 }
 
 /*
diff --git a/drivers/net/wireless/rt73usb.c b/drivers/net/wireless/rt73usb.c
index 90e2b29..149f5ee 100644
--- a/drivers/net/wireless/rt73usb.c
+++ b/drivers/net/wireless/rt73usb.c
@@ -1432,7 +1432,7 @@ static int rt73usb_agc_to_rssi(struct rt2x00_dev *rt2x00dev, int rxd_w1)
 }
 
 static int rt73usb_fill_rxdone(struct data_entry *entry,
-			       int *signal, int *rssi, int *ofdm)
+			       int *signal, int *rssi, int *ofdm, int *size)
 {
 	struct data_desc *rxd = (struct data_desc *)entry->skb->data;
 	u32 word0;
@@ -1442,10 +1442,8 @@ static int rt73usb_fill_rxdone(struct data_entry *entry,
 	rt2x00_desc_read(rxd, 1, &word1);
 
 	if (rt2x00_get_field32(word0, RXD_W0_CRC_ERROR) ||
-	    rt2x00_get_field32(word0, RXD_W0_CIPHER_ERROR)) {
-		entry->ring->rt2x00dev->link.rx_failed++;
+	    rt2x00_get_field32(word0, RXD_W0_CIPHER_ERROR))
 		return -EINVAL;
-	}
 
 	/*
 	 * Obtain the status about this packet.
@@ -1453,13 +1451,14 @@ static int rt73usb_fill_rxdone(struct data_entry *entry,
 	*signal = rt2x00_get_field32(word1, RXD_W1_SIGNAL);
 	*rssi = rt73usb_agc_to_rssi(entry->ring->rt2x00dev, word1);
 	*ofdm = rt2x00_get_field32(word0, RXD_W0_OFDM);
+	*size = rt2x00_get_field32(word0, RXD_W0_DATABYTE_COUNT);
 
 	/*
 	 * Pull the skb to clear the descriptor area.
 	 */
 	skb_pull(entry->skb, entry->ring->desc_size);
 
-	return rt2x00_get_field32(word0, RXD_W0_DATABYTE_COUNT);
+	return 0;
 }
 
 /*
-- 
1.5.3.rc5

