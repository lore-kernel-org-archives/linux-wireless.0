Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.174]:30801 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756705AbYAFWm7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Jan 2008 17:42:59 -0500
Received: by ug-out-1314.google.com with SMTP id z38so3071365ugc.16
        for <linux-wireless@vger.kernel.org>; Sun, 06 Jan 2008 14:42:58 -0800 (PST)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 11/12] rt2x00: Correctly initialize data and desc pointer
Date: Sun, 6 Jan 2008 23:42:04 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200801062337.35904.IvDoorn@gmail.com>
In-Reply-To: <200801062337.35904.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200801062342.04530.IvDoorn@gmail.com> (sfid-20080106_224305_657914_DD301EB8)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rt2500usb and rt73usb store the descriptor in different
places. This means we should move the initialization of
the 2 pointers to the driver callback function fill_rxdone().

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2500usb.c |   12 ++++++++++++
 drivers/net/wireless/rt2x00/rt2x00usb.c |    2 --
 drivers/net/wireless/rt2x00/rt73usb.c   |    7 +++++++
 3 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 1b05b8a..2f166c8 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -1113,6 +1113,7 @@ static void rt2500usb_kick_tx_queue(struct rt2x00_dev *rt2x00dev,
 static void rt2500usb_fill_rxdone(struct data_entry *entry,
 				  struct rxdata_entry_desc *desc)
 {
+	struct skb_desc *skbdesc = get_skb_desc(entry->skb);
 	struct urb *urb = entry->priv;
 	__le32 *rxd = (__le32 *)(entry->skb->data +
 				 (urb->actual_length - entry->ring->desc_size));
@@ -1137,6 +1138,17 @@ static void rt2500usb_fill_rxdone(struct data_entry *entry,
 	desc->ofdm = rt2x00_get_field32(word0, RXD_W0_OFDM);
 	desc->size = rt2x00_get_field32(word0, RXD_W0_DATABYTE_COUNT);
 	desc->my_bss = !!rt2x00_get_field32(word0, RXD_W0_MY_BSS);
+
+	/*
+	 * Trim the skb to clear the descriptor area.
+	 */
+	skb_pull(entry->skb, entry->ring->desc_size);
+
+	/*
+	 * Set descriptor and data pointer.
+	 */
+	skbdesc->desc = entry->skb->data + skbdesc->data_len;
+	skbdesc->data = entry->skb->data;
 }
 
 /*
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index d15d469..8aab28d 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -296,8 +296,6 @@ static void rt2x00usb_interrupt_rxdone(struct urb *urb)
 	skbdesc = get_skb_desc(entry->skb);
 	skbdesc->desc_len = entry->ring->desc_size;
 	skbdesc->data_len = entry->skb->len;
-	skbdesc->desc = entry->skb->data - skbdesc->desc_len;
-	skbdesc->data = entry->skb->data;
 	skbdesc->ring = ring;
 	skbdesc->entry = entry;
 
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 78217dc..47ed307 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -1376,6 +1376,7 @@ static int rt73usb_agc_to_rssi(struct rt2x00_dev *rt2x00dev, int rxd_w1)
 static void rt73usb_fill_rxdone(struct data_entry *entry,
 			        struct rxdata_entry_desc *desc)
 {
+	struct skb_desc *skbdesc = get_skb_desc(entry->skb);
 	__le32 *rxd = (__le32 *)entry->skb->data;
 	u32 word0;
 	u32 word1;
@@ -1400,6 +1401,12 @@ static void rt73usb_fill_rxdone(struct data_entry *entry,
 	 * Pull the skb to clear the descriptor area.
 	 */
 	skb_pull(entry->skb, entry->ring->desc_size);
+
+	/*
+	 * Set descriptor and data pointer.
+	 */
+	skbdesc->desc = entry->skb->data - skbdesc->desc_len;
+	skbdesc->data = entry->skb->data;
 }
 
 /*
-- 
1.5.3.7

