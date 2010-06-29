Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:38421 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755873Ab0F2TvQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jun 2010 15:51:16 -0400
Received: by mail-wy0-f174.google.com with SMTP id 38so2999627wyb.19
        for <linux-wireless@vger.kernel.org>; Tue, 29 Jun 2010 12:51:16 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 07/21] rt2x00: Move common txdone handling to rt2x00lib_txdone.
Date: Tue, 29 Jun 2010 21:41:40 +0200
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
References: <201006292138.13509.IvDoorn@gmail.com> <201006292140.35163.IvDoorn@gmail.com> <201006292141.07070.IvDoorn@gmail.com>
In-Reply-To: <201006292141.07070.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201006292141.41708.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gertjan van Wingerde <gwingerde@gmail.com>

Now that the write_tx_data functions are merged, also merge the relevant
parts of the txdone handling into common code, rather than {usb,pci}
specific code.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2400pci.c |    2 +-
 drivers/net/wireless/rt2x00/rt2500pci.c |    2 +-
 drivers/net/wireless/rt2x00/rt2800pci.c |    2 +-
 drivers/net/wireless/rt2x00/rt2x00dev.c |   15 +++++++++++++++
 drivers/net/wireless/rt2x00/rt2x00pci.c |   31 -------------------------------
 drivers/net/wireless/rt2x00/rt2x00pci.h |    8 --------
 drivers/net/wireless/rt2x00/rt2x00usb.c |   11 -----------
 drivers/net/wireless/rt2x00/rt61pci.c   |    4 ++--
 8 files changed, 20 insertions(+), 55 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index 1ad3596..3bedf56 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -1229,7 +1229,7 @@ static void rt2400pci_txdone(struct rt2x00_dev *rt2x00dev,
 		}
 		txdesc.retry = rt2x00_get_field32(word, TXD_W0_RETRY_COUNT);
 
-		rt2x00pci_txdone(entry, &txdesc);
+		rt2x00lib_txdone(entry, &txdesc);
 	}
 }
 
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index 2771ae7..69d231d 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -1365,7 +1365,7 @@ static void rt2500pci_txdone(struct rt2x00_dev *rt2x00dev,
 		}
 		txdesc.retry = rt2x00_get_field32(word, TXD_W0_RETRY_COUNT);
 
-		rt2x00pci_txdone(entry, &txdesc);
+		rt2x00lib_txdone(entry, &txdesc);
 	}
 }
 
diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index 615a865..894a43a 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -905,7 +905,7 @@ static void rt2800pci_txdone(struct rt2x00_dev *rt2x00dev)
 		if (txdesc.retry)
 			__set_bit(TXDONE_FALLBACK, &txdesc.flags);
 
-		rt2x00pci_txdone(entry, &txdesc);
+		rt2x00lib_txdone(entry, &txdesc);
 	}
 }
 
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index a914855..12ee7bd 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -211,6 +211,21 @@ void rt2x00lib_txdone(struct queue_entry *entry,
 	bool success;
 
 	/*
+	 * Unmap the skb.
+	 */
+	rt2x00queue_unmap_skb(rt2x00dev, entry->skb);
+
+	/*
+	 * Remove the extra tx headroom from the skb.
+	 */
+	skb_pull(entry->skb, rt2x00dev->ops->extra_tx_headroom);
+
+	/*
+	 * Signal that the TX descriptor is no longer in the skb.
+	 */
+	skbdesc->flags &= ~SKBDESC_DESC_IN_SKB;
+
+	/*
 	 * Remove L2 padding which was added during
 	 */
 	if (test_bit(DRIVER_REQUIRE_L2PAD, &rt2x00dev->flags))
diff --git a/drivers/net/wireless/rt2x00/rt2x00pci.c b/drivers/net/wireless/rt2x00/rt2x00pci.c
index 1c9ccc3..fc9da83 100644
--- a/drivers/net/wireless/rt2x00/rt2x00pci.c
+++ b/drivers/net/wireless/rt2x00/rt2x00pci.c
@@ -60,37 +60,6 @@ int rt2x00pci_regbusy_read(struct rt2x00_dev *rt2x00dev,
 }
 EXPORT_SYMBOL_GPL(rt2x00pci_regbusy_read);
 
-/*
- * TX/RX data handlers.
- */
-void rt2x00pci_txdone(struct queue_entry *entry,
-		      struct txdone_entry_desc *txdesc)
-{
-	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
-	struct skb_frame_desc *skbdesc = get_skb_frame_desc(entry->skb);
-
-	/*
-	 * Unmap the skb.
-	 */
-	rt2x00queue_unmap_skb(rt2x00dev, entry->skb);
-
-	/*
-	 * Remove the extra tx headroom from the skb.
-	 */
-	skb_pull(entry->skb, rt2x00dev->ops->extra_tx_headroom);
-
-	/*
-	 * Signal that the TX descriptor is no longer in the skb.
-	 */
-	skbdesc->flags &= ~SKBDESC_DESC_IN_SKB;
-
-	/*
-	 * Pass on to rt2x00lib.
-	 */
-	rt2x00lib_txdone(entry, txdesc);
-}
-EXPORT_SYMBOL_GPL(rt2x00pci_txdone);
-
 void rt2x00pci_rxdone(struct rt2x00_dev *rt2x00dev)
 {
 	struct data_queue *queue = rt2x00dev->rx;
diff --git a/drivers/net/wireless/rt2x00/rt2x00pci.h b/drivers/net/wireless/rt2x00/rt2x00pci.h
index 2dca185..b854d62 100644
--- a/drivers/net/wireless/rt2x00/rt2x00pci.h
+++ b/drivers/net/wireless/rt2x00/rt2x00pci.h
@@ -99,14 +99,6 @@ struct queue_entry_priv_pci {
 };
 
 /**
- * rt2x00pci_txdone - Handle TX done events.
- * @entry: The queue entry for which a TX done event was received.
- * @txdesc: The TX done descriptor for the entry.
- */
-void rt2x00pci_txdone(struct queue_entry *entry,
-		      struct txdone_entry_desc *txdesc);
-
-/**
  * rt2x00pci_rxdone - Handle RX done events
  * @rt2x00dev: Device pointer, see &struct rt2x00_dev.
  */
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index f78ebb4..a22837c 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -171,7 +171,6 @@ static void rt2x00usb_interrupt_txdone(struct urb *urb)
 {
 	struct queue_entry *entry = (struct queue_entry *)urb->context;
 	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
-	struct skb_frame_desc *skbdesc = get_skb_frame_desc(entry->skb);
 	struct txdone_entry_desc txdesc;
 
 	if (!test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags) ||
@@ -179,16 +178,6 @@ static void rt2x00usb_interrupt_txdone(struct urb *urb)
 		return;
 
 	/*
-	 * Remove the descriptor from the front of the skb.
-	 */
-	skb_pull(entry->skb, entry->queue->desc_size);
-
-	/*
-	 * Signal that the TX descriptor is no longer in the skb.
-	 */
-	skbdesc->flags &= ~SKBDESC_DESC_IN_SKB;
-
-	/*
 	 * Obtain the status about this packet.
 	 * Note that when the status is 0 it does not mean the
 	 * frame was send out correctly. It only means the frame
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index cb6e20a..1e74f8c 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -2108,7 +2108,7 @@ static void rt61pci_txdone(struct rt2x00_dev *rt2x00dev)
 			__set_bit(TXDONE_UNKNOWN, &txdesc.flags);
 			txdesc.retry = 0;
 
-			rt2x00pci_txdone(entry_done, &txdesc);
+			rt2x00lib_txdone(entry_done, &txdesc);
 			entry_done = rt2x00queue_get_entry(queue, Q_INDEX_DONE);
 		}
 
@@ -2135,7 +2135,7 @@ static void rt61pci_txdone(struct rt2x00_dev *rt2x00dev)
 		if (txdesc.retry)
 			__set_bit(TXDONE_FALLBACK, &txdesc.flags);
 
-		rt2x00pci_txdone(entry, &txdesc);
+		rt2x00lib_txdone(entry, &txdesc);
 	}
 }
 
-- 
1.6.6.1

