Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.173]:45416 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756124AbYFHVhh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Jun 2008 17:37:37 -0400
Received: by ug-out-1314.google.com with SMTP id h2so1022998ugf.16
        for <linux-wireless@vger.kernel.org>; Sun, 08 Jun 2008 14:37:36 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 04/10] rt2x00: Cleanup struct skb_frame_desc.
Date: Sun, 8 Jun 2008 23:44:27 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200806082341.58616.IvDoorn@gmail.com> <200806082343.17344.IvDoorn@gmail.com> <200806082343.56928.IvDoorn@gmail.com>
In-Reply-To: <200806082343.56928.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200806082344.28110.IvDoorn@gmail.com> (sfid-20080608_233742_430394_768031A6)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gertjan van Wingerde <gwingerde@wingerd.gvw.nl>

The data and data_len fields aren't really necessary in struct skb_frame_desc,
as they can be deduced from the skb itself.

Signed-off-by: Gertjan van Wingerde <gwingerde@kpnplanet.nl>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2400pci.c   |    6 ++----
 drivers/net/wireless/rt2x00/rt2500pci.c   |    2 --
 drivers/net/wireless/rt2x00/rt2500usb.c   |    7 ++-----
 drivers/net/wireless/rt2x00/rt2x00debug.c |    6 +++---
 drivers/net/wireless/rt2x00/rt2x00pci.c   |    4 ----
 drivers/net/wireless/rt2x00/rt2x00queue.h |    5 +----
 drivers/net/wireless/rt2x00/rt2x00usb.c   |    3 ---
 drivers/net/wireless/rt2x00/rt61pci.c     |    8 +++-----
 drivers/net/wireless/rt2x00/rt73usb.c     |    7 ++-----
 9 files changed, 13 insertions(+), 35 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index b5b0ded..bb3d835 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -1016,8 +1016,8 @@ static void rt2400pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 	rt2x00_desc_write(entry_priv->desc, 1, word);
 
 	rt2x00_desc_read(txd, 2, &word);
-	rt2x00_set_field32(&word, TXD_W2_BUFFER_LENGTH, skbdesc->data_len);
-	rt2x00_set_field32(&word, TXD_W2_DATABYTE_COUNT, skbdesc->data_len);
+	rt2x00_set_field32(&word, TXD_W2_BUFFER_LENGTH, skb->len);
+	rt2x00_set_field32(&word, TXD_W2_DATABYTE_COUNT, skb->len);
 	rt2x00_desc_write(txd, 2, word);
 
 	rt2x00_desc_read(txd, 3, &word);
@@ -1507,8 +1507,6 @@ static int rt2400pci_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb)
 	 */
 	skbdesc = get_skb_frame_desc(skb);
 	memset(skbdesc, 0, sizeof(*skbdesc));
-	skbdesc->data = skb->data;
-	skbdesc->data_len = skb->len;
 	skbdesc->desc = entry_priv->desc;
 	skbdesc->desc_len = intf->beacon->queue->desc_size;
 	skbdesc->entry = intf->beacon;
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index 74b54c9..3c956b9 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -1823,8 +1823,6 @@ static int rt2500pci_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb)
 	 */
 	skbdesc = get_skb_frame_desc(skb);
 	memset(skbdesc, 0, sizeof(*skbdesc));
-	skbdesc->data = skb->data;
-	skbdesc->data_len = skb->len;
 	skbdesc->desc = entry_priv->desc;
 	skbdesc->desc_len = intf->beacon->queue->desc_size;
 	skbdesc->entry = intf->beacon;
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 0762214..1bfb68a 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -1088,7 +1088,8 @@ static void rt2500usb_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 	rt2x00_set_field32(&word, TXD_W0_NEW_SEQ,
 			   test_bit(ENTRY_TXD_FIRST_FRAGMENT, &txdesc->flags));
 	rt2x00_set_field32(&word, TXD_W0_IFS, txdesc->ifs);
-	rt2x00_set_field32(&word, TXD_W0_DATABYTE_COUNT, skbdesc->data_len);
+	rt2x00_set_field32(&word, TXD_W0_DATABYTE_COUNT,
+			   skb->len - skbdesc->desc_len);
 	rt2x00_set_field32(&word, TXD_W0_CIPHER, CIPHER_NONE);
 	rt2x00_desc_write(txd, 0, word);
 }
@@ -1196,8 +1197,6 @@ static void rt2500usb_fill_rxdone(struct queue_entry *entry,
 	 * Adjust the skb memory window to the frame boundaries.
 	 */
 	skb_trim(entry->skb, rxdesc->size);
-	skbdesc->data = entry->skb->data;
-	skbdesc->data_len = rxdesc->size;
 }
 
 /*
@@ -1711,8 +1710,6 @@ static int rt2500usb_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb)
 	 */
 	skbdesc = get_skb_frame_desc(skb);
 	memset(skbdesc, 0, sizeof(*skbdesc));
-	skbdesc->data = skb->data + intf->beacon->queue->desc_size;
-	skbdesc->data_len = skb->len - intf->beacon->queue->desc_size;
 	skbdesc->desc = skb->data;
 	skbdesc->desc_len = intf->beacon->queue->desc_size;
 	skbdesc->entry = intf->beacon;
diff --git a/drivers/net/wireless/rt2x00/rt2x00debug.c b/drivers/net/wireless/rt2x00/rt2x00debug.c
index bd92cb8..300cf06 100644
--- a/drivers/net/wireless/rt2x00/rt2x00debug.c
+++ b/drivers/net/wireless/rt2x00/rt2x00debug.c
@@ -133,7 +133,7 @@ void rt2x00debug_dump_frame(struct rt2x00_dev *rt2x00dev,
 		return;
 	}
 
-	skbcopy = alloc_skb(sizeof(*dump_hdr) + desc->desc_len + desc->data_len,
+	skbcopy = alloc_skb(sizeof(*dump_hdr) + desc->desc_len + skb->len,
 			    GFP_ATOMIC);
 	if (!skbcopy) {
 		DEBUG(rt2x00dev, "Failed to copy skb for dump.\n");
@@ -144,7 +144,7 @@ void rt2x00debug_dump_frame(struct rt2x00_dev *rt2x00dev,
 	dump_hdr->version = cpu_to_le32(DUMP_HEADER_VERSION);
 	dump_hdr->header_length = cpu_to_le32(sizeof(*dump_hdr));
 	dump_hdr->desc_length = cpu_to_le32(desc->desc_len);
-	dump_hdr->data_length = cpu_to_le32(desc->data_len);
+	dump_hdr->data_length = cpu_to_le32(skb->len);
 	dump_hdr->chip_rt = cpu_to_le16(rt2x00dev->chip.rt);
 	dump_hdr->chip_rf = cpu_to_le16(rt2x00dev->chip.rf);
 	dump_hdr->chip_rev = cpu_to_le32(rt2x00dev->chip.rev);
@@ -155,7 +155,7 @@ void rt2x00debug_dump_frame(struct rt2x00_dev *rt2x00dev,
 	dump_hdr->timestamp_usec = cpu_to_le32(timestamp.tv_usec);
 
 	memcpy(skb_put(skbcopy, desc->desc_len), desc->desc, desc->desc_len);
-	memcpy(skb_put(skbcopy, desc->data_len), desc->data, desc->data_len);
+	memcpy(skb_put(skbcopy, skb->len), skb->data, skb->len);
 
 	skb_queue_tail(&intf->frame_dump_skbqueue, skbcopy);
 	wake_up_interruptible(&intf->frame_dump_waitqueue);
diff --git a/drivers/net/wireless/rt2x00/rt2x00pci.c b/drivers/net/wireless/rt2x00/rt2x00pci.c
index 945ed71..8712238 100644
--- a/drivers/net/wireless/rt2x00/rt2x00pci.c
+++ b/drivers/net/wireless/rt2x00/rt2x00pci.c
@@ -61,8 +61,6 @@ int rt2x00pci_write_tx_data(struct queue_entry *entry)
 	 */
 	skbdesc = get_skb_frame_desc(entry->skb);
 	memset(skbdesc, 0, sizeof(*skbdesc));
-	skbdesc->data = entry->skb->data;
-	skbdesc->data_len = entry->skb->len;
 	skbdesc->desc = entry_priv->desc;
 	skbdesc->desc_len = entry->queue->desc_size;
 	skbdesc->entry = entry;
@@ -126,8 +124,6 @@ void rt2x00pci_rxdone(struct rt2x00_dev *rt2x00dev)
 		 */
 		skbdesc = get_skb_frame_desc(entry->skb);
 		memset(skbdesc, 0, sizeof(*skbdesc));
-		skbdesc->data = entry->skb->data;
-		skbdesc->data_len = entry->skb->len;
 		skbdesc->desc = entry_priv->desc;
 		skbdesc->desc_len = queue->desc_size;
 		skbdesc->entry = entry;
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.h b/drivers/net/wireless/rt2x00/rt2x00queue.h
index 623fc27..fcf5252 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.h
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.h
@@ -105,11 +105,8 @@ enum data_queue_qid {
 struct skb_frame_desc {
 	unsigned int flags;
 
-	unsigned short data_len;
-	unsigned short desc_len;
-
-	void *data;
 	void *desc;
+	unsigned int desc_len;
 
 	struct queue_entry *entry;
 };
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index bed595f..20c3ce8 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -192,8 +192,6 @@ int rt2x00usb_write_tx_data(struct queue_entry *entry)
 	 */
 	skbdesc = get_skb_frame_desc(entry->skb);
 	memset(skbdesc, 0, sizeof(*skbdesc));
-	skbdesc->data = entry->skb->data + entry->queue->desc_size;
-	skbdesc->data_len = entry->skb->len - entry->queue->desc_size;
 	skbdesc->desc = entry->skb->data;
 	skbdesc->desc_len = entry->queue->desc_size;
 	skbdesc->entry = entry;
@@ -352,7 +350,6 @@ static void rt2x00usb_interrupt_rxdone(struct urb *urb)
 	}
 
 	/* Update data pointers, trim buffer to correct size */
-	skbdesc->data = entry->skb->data;
 	skb_trim(entry->skb, rxdesc.size);
 
 	/*
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 746f87c..5b7267e 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -1562,7 +1562,7 @@ static void rt61pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 
 	if (skbdesc->desc_len > TXINFO_SIZE) {
 		rt2x00_desc_read(txd, 11, &word);
-		rt2x00_set_field32(&word, TXD_W11_BUFFER_LENGTH0, skbdesc->data_len);
+		rt2x00_set_field32(&word, TXD_W11_BUFFER_LENGTH0, skb->len);
 		rt2x00_desc_write(txd, 11, word);
 	}
 
@@ -1581,7 +1581,7 @@ static void rt61pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 	rt2x00_set_field32(&word, TXD_W0_RETRY_MODE,
 			   test_bit(ENTRY_TXD_RETRY_MODE, &txdesc->flags));
 	rt2x00_set_field32(&word, TXD_W0_TKIP_MIC, 0);
-	rt2x00_set_field32(&word, TXD_W0_DATABYTE_COUNT, skbdesc->data_len);
+	rt2x00_set_field32(&word, TXD_W0_DATABYTE_COUNT, skb->len);
 	rt2x00_set_field32(&word, TXD_W0_BURST,
 			   test_bit(ENTRY_TXD_BURST, &txdesc->flags));
 	rt2x00_set_field32(&word, TXD_W0_CIPHER_ALG, CIPHER_NONE);
@@ -2375,8 +2375,6 @@ static int rt61pci_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb)
 	 */
 	skbdesc = get_skb_frame_desc(skb);
 	memset(skbdesc, 0, sizeof(*skbdesc));
-	skbdesc->data = skb->data;
-	skbdesc->data_len = skb->len;
 	skbdesc->desc = entry_priv->desc;
 	skbdesc->desc_len = intf->beacon->queue->desc_size;
 	skbdesc->entry = intf->beacon;
@@ -2401,7 +2399,7 @@ static int rt61pci_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb)
 				      skbdesc->desc, skbdesc->desc_len);
 	rt2x00pci_register_multiwrite(rt2x00dev,
 				      beacon_base + skbdesc->desc_len,
-				      skbdesc->data, skbdesc->data_len);
+				      skb->data, skb->len);
 	rt61pci_kick_tx_queue(rt2x00dev, QID_BEACON);
 
 	return 0;
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index ae50f63..800a1e2 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -1320,7 +1320,8 @@ static void rt73usb_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 	rt2x00_set_field32(&word, TXD_W0_RETRY_MODE,
 			   test_bit(ENTRY_TXD_RETRY_MODE, &txdesc->flags));
 	rt2x00_set_field32(&word, TXD_W0_TKIP_MIC, 0);
-	rt2x00_set_field32(&word, TXD_W0_DATABYTE_COUNT, skbdesc->data_len);
+	rt2x00_set_field32(&word, TXD_W0_DATABYTE_COUNT,
+			   skb->len - skbdesc->desc_len);
 	rt2x00_set_field32(&word, TXD_W0_BURST2,
 			   test_bit(ENTRY_TXD_BURST, &txdesc->flags));
 	rt2x00_set_field32(&word, TXD_W0_CIPHER_ALG, CIPHER_NONE);
@@ -1466,8 +1467,6 @@ static void rt73usb_fill_rxdone(struct queue_entry *entry,
 	 */
 	skb_pull(entry->skb, entry->queue->desc_size);
 	skb_trim(entry->skb, rxdesc->size);
-	skbdesc->data = entry->skb->data;
-	skbdesc->data_len = rxdesc->size;
 }
 
 /*
@@ -1980,8 +1979,6 @@ static int rt73usb_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb)
 	 */
 	skbdesc = get_skb_frame_desc(skb);
 	memset(skbdesc, 0, sizeof(*skbdesc));
-	skbdesc->data = skb->data + intf->beacon->queue->desc_size;
-	skbdesc->data_len = skb->len - intf->beacon->queue->desc_size;
 	skbdesc->desc = skb->data;
 	skbdesc->desc_len = intf->beacon->queue->desc_size;
 	skbdesc->entry = intf->beacon;
-- 
1.5.5.3

