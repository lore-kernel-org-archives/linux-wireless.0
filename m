Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.188]:47546 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758487AbXKLNtB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Nov 2007 08:49:01 -0500
Received: by mu-out-0910.google.com with SMTP id i10so1450268mue
        for <linux-wireless@vger.kernel.org>; Mon, 12 Nov 2007 05:48:59 -0800 (PST)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 2/3] rt2x00: Move duplicate code into rt2x00pci_txdone()
Date: Mon, 12 Nov 2007 15:02:40 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200711121502.01953.IvDoorn@gmail.com>
In-Reply-To: <200711121502.01953.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200711121502.41050.IvDoorn@gmail.com> (sfid-20071112_134908_944521_BBF8C6C7)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rt2400pci, rt2500pci and rt61 require different
txdone handling, but the code that pushes the frame
upstream and cleans up the entry is identical to
all of them.
This will create the function rt2x00pci_txdone()
to remove the duplicate code.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2400pci.c |   20 +-----------------
 drivers/net/wireless/rt2x00/rt2500pci.c |   20 +-----------------
 drivers/net/wireless/rt2x00/rt2x00pci.c |   33 ++++++++++++++++++++++++++++++-
 drivers/net/wireless/rt2x00/rt2x00pci.h |    4 ++-
 drivers/net/wireless/rt2x00/rt61pci.c   |   19 +----------------
 5 files changed, 38 insertions(+), 58 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index d48b6ca..bdf3edc 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -1167,26 +1167,8 @@ static void rt2400pci_txdone(struct rt2x00_dev *rt2x00dev, const int queue)
 		tx_status = rt2x00_get_field32(word, TXD_W0_RESULT);
 		retry = rt2x00_get_field32(word, TXD_W0_RETRY_COUNT);
 
-		rt2x00lib_txdone(entry, tx_status, retry);
-
-		/*
-		 * Make this entry available for reuse.
-		 */
-		entry->flags = 0;
-		rt2x00_set_field32(&word, TXD_W0_VALID, 0);
-		rt2x00_desc_write(txd, 0, word);
-		rt2x00_ring_index_done_inc(ring);
+		rt2x00pci_txdone(rt2x00dev, entry, tx_status, retry);
 	}
-
-	/*
-	 * If the data ring was full before the txdone handler
-	 * we must make sure the packet queue in the mac80211 stack
-	 * is reenabled when the txdone handler has finished.
-	 */
-	entry = ring->entry;
-	if (!rt2x00_ring_full(ring))
-		ieee80211_wake_queue(rt2x00dev->hw,
-				     entry->tx_status.control.queue);
 }
 
 static irqreturn_t rt2400pci_interrupt(int irq, void *dev_instance)
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index e6a0c37..b6bb964 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -1298,26 +1298,8 @@ static void rt2500pci_txdone(struct rt2x00_dev *rt2x00dev, const int queue)
 		tx_status = rt2x00_get_field32(word, TXD_W0_RESULT);
 		retry = rt2x00_get_field32(word, TXD_W0_RETRY_COUNT);
 
-		rt2x00lib_txdone(entry, tx_status, retry);
-
-		/*
-		 * Make this entry available for reuse.
-		 */
-		entry->flags = 0;
-		rt2x00_set_field32(&word, TXD_W0_VALID, 0);
-		rt2x00_desc_write(txd, 0, word);
-		rt2x00_ring_index_done_inc(ring);
+		rt2x00pci_txdone(rt2x00dev, entry, tx_status, retry);
 	}
-
-	/*
-	 * If the data ring was full before the txdone handler
-	 * we must make sure the packet queue in the mac80211 stack
-	 * is reenabled when the txdone handler has finished.
-	 */
-	entry = ring->entry;
-	if (!rt2x00_ring_full(ring))
-		ieee80211_wake_queue(rt2x00dev->hw,
-				     entry->tx_status.control.queue);
 }
 
 static irqreturn_t rt2500pci_interrupt(int irq, void *dev_instance)
diff --git a/drivers/net/wireless/rt2x00/rt2x00pci.c b/drivers/net/wireless/rt2x00/rt2x00pci.c
index 045b954..30ef4f9 100644
--- a/drivers/net/wireless/rt2x00/rt2x00pci.c
+++ b/drivers/net/wireless/rt2x00/rt2x00pci.c
@@ -116,7 +116,7 @@ int rt2x00pci_write_tx_data(struct rt2x00_dev *rt2x00dev,
 EXPORT_SYMBOL_GPL(rt2x00pci_write_tx_data);
 
 /*
- * RX data handlers.
+ * TX/RX data handlers.
  */
 void rt2x00pci_rxdone(struct rt2x00_dev *rt2x00dev)
 {
@@ -165,6 +165,37 @@ void rt2x00pci_rxdone(struct rt2x00_dev *rt2x00dev)
 }
 EXPORT_SYMBOL_GPL(rt2x00pci_rxdone);
 
+void rt2x00pci_txdone(struct rt2x00_dev *rt2x00dev, struct data_entry *entry,
+		      const int tx_status, const int retry)
+{
+	u32 word;
+
+	rt2x00lib_txdone(entry, tx_status, retry);
+
+	/*
+	 * Make this entry available for reuse.
+	 */
+	entry->flags = 0;
+
+	rt2x00_desc_read(entry->priv, 0, &word);
+	rt2x00_set_field32(&word, TXD_ENTRY_OWNER_NIC, 0);
+	rt2x00_set_field32(&word, TXD_ENTRY_VALID, 0);
+	rt2x00_desc_write(entry->priv, 0, word);
+
+	rt2x00_ring_index_done_inc(entry->ring);
+
+	/*
+	 * If the data ring was full before the txdone handler
+	 * we must make sure the packet queue in the mac80211 stack
+	 * is reenabled when the txdone handler has finished.
+	 */
+	if (!rt2x00_ring_full(entry->ring))
+		ieee80211_wake_queue(rt2x00dev->hw,
+				     entry->tx_status.control.queue);
+
+}
+EXPORT_SYMBOL_GPL(rt2x00pci_txdone);
+
 /*
  * Device initialization handlers.
  */
diff --git a/drivers/net/wireless/rt2x00/rt2x00pci.h b/drivers/net/wireless/rt2x00/rt2x00pci.h
index 0357205..2d1eb81 100644
--- a/drivers/net/wireless/rt2x00/rt2x00pci.h
+++ b/drivers/net/wireless/rt2x00/rt2x00pci.h
@@ -101,9 +101,11 @@ int rt2x00pci_write_tx_data(struct rt2x00_dev *rt2x00dev,
 			    struct ieee80211_tx_control *control);
 
 /*
- * RX data handlers.
+ * RX/TX data handlers.
  */
 void rt2x00pci_rxdone(struct rt2x00_dev *rt2x00dev);
+void rt2x00pci_txdone(struct rt2x00_dev *rt2x00dev, struct data_entry *entry,
+		      const int tx_status, const int retry);
 
 /*
  * Device initialization handlers.
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 105dc86..a6d4e10 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -1767,24 +1767,7 @@ static void rt61pci_txdone(struct rt2x00_dev *rt2x00dev)
 		tx_status = rt2x00_get_field32(reg, STA_CSR4_TX_RESULT);
 		retry = rt2x00_get_field32(reg, STA_CSR4_RETRY_COUNT);
 
-		rt2x00lib_txdone(entry, tx_status, retry);
-
-		/*
-		 * Make this entry available for reuse.
-		 */
-		entry->flags = 0;
-		rt2x00_set_field32(&word, TXD_W0_VALID, 0);
-		rt2x00_desc_write(txd, 0, word);
-		rt2x00_ring_index_done_inc(entry->ring);
-
-		/*
-		 * If the data ring was full before the txdone handler
-		 * we must make sure the packet queue in the mac80211 stack
-		 * is reenabled when the txdone handler has finished.
-		 */
-		if (!rt2x00_ring_full(ring))
-			ieee80211_wake_queue(rt2x00dev->hw,
-					     entry->tx_status.control.queue);
+		rt2x00pci_txdone(rt2x00dev, entry, tx_status, retry);
 	}
 }
 
-- 
1.5.3.4

