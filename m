Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:2117 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754009Ab0EHVke (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 May 2010 17:40:34 -0400
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Ivo van Doorn <IvDoorn@gmail.com>,
	<linux-wireless@vger.kernel.org>, <users@rt2x00.serialmonkey.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: [PATCH 9/9] rt2x00: Fix beaconing on rt2800.
Date: Sat,  8 May 2010 23:40:26 +0200
Message-Id: <1273354826-4335-10-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1273354826-4335-1-git-send-email-gwingerde@gmail.com>
References: <1273354826-4335-1-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

According to the Ralink vendor driver for rt2800 we don't need a full
TXD for a beacon but just a TXWI in front of the actual beacon.
Fix the rt2800pci and rt2800usb beaconing code accordingly.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800pci.c |   17 +++++++++--------
 drivers/net/wireless/rt2x00/rt2800usb.c |   14 ++++++--------
 2 files changed, 15 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index 80c6768..7d4778d 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -682,7 +682,6 @@ static void rt2800pci_write_beacon(struct queue_entry *entry,
 				   struct txentry_desc *txdesc)
 {
 	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
-	struct skb_frame_desc *skbdesc = get_skb_frame_desc(entry->skb);
 	unsigned int beacon_base;
 	u32 reg;
 
@@ -695,15 +694,17 @@ static void rt2800pci_write_beacon(struct queue_entry *entry,
 	rt2800_register_write(rt2x00dev, BCN_TIME_CFG, reg);
 
 	/*
-	 * Write entire beacon with descriptor to register.
+	 * Add the TXWI for the beacon to the skb.
+	 */
+	rt2800_write_txwi(entry->skb, txdesc);
+	skb_push(entry->skb, TXWI_DESC_SIZE);
+
+	/*
+	 * Write entire beacon with TXWI to register.
 	 */
 	beacon_base = HW_BEACON_OFFSET(entry->entry_idx);
-	rt2800_register_multiwrite(rt2x00dev,
-				      beacon_base,
-				      skbdesc->desc, skbdesc->desc_len);
-	rt2800_register_multiwrite(rt2x00dev,
-				      beacon_base + skbdesc->desc_len,
-				      entry->skb->data, entry->skb->len);
+	rt2800_register_multiwrite(rt2x00dev, beacon_base,
+				   entry->skb->data, entry->skb->len);
 
 	/*
 	 * Enable beaconing again.
diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index d992a93..00e7906 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -431,18 +431,10 @@ static void rt2800usb_write_beacon(struct queue_entry *entry,
 				   struct txentry_desc *txdesc)
 {
 	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
-	struct skb_frame_desc *skbdesc = get_skb_frame_desc(entry->skb);
 	unsigned int beacon_base;
 	u32 reg;
 
 	/*
-	 * Add the descriptor in front of the skb.
-	 */
-	skb_push(entry->skb, entry->queue->desc_size);
-	memcpy(entry->skb->data, skbdesc->desc, skbdesc->desc_len);
-	skbdesc->desc = entry->skb->data;
-
-	/*
 	 * Disable beaconing while we are reloading the beacon data,
 	 * otherwise we might be sending out invalid data.
 	 */
@@ -451,6 +443,12 @@ static void rt2800usb_write_beacon(struct queue_entry *entry,
 	rt2800_register_write(rt2x00dev, BCN_TIME_CFG, reg);
 
 	/*
+	 * Add the TXWI for the beacon to the skb.
+	 */
+	rt2800_write_txwi(entry->skb, txdesc);
+	skb_push(entry->skb, TXWI_DESC_SIZE);
+
+	/*
 	 * Write entire beacon with descriptor to register.
 	 */
 	beacon_base = HW_BEACON_OFFSET(entry->entry_idx);
-- 
1.7.1

