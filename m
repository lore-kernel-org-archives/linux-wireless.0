Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.189]:59572 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753224AbYCIVuz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Mar 2008 17:50:55 -0400
Received: by fk-out-0910.google.com with SMTP id z23so1362518fkz.5
        for <linux-wireless@vger.kernel.org>; Sun, 09 Mar 2008 14:50:39 -0700 (PDT)
To: "John W. Linville" <linville@redhat.com>
Subject: [PATCH 01/24] rt2x00: Align RX descriptor to 4 bytes
Date: Sun, 9 Mar 2008 22:38:18 +0100
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	rt2400-devel@lists.sourceforge.net
References: <200803092237.43451.IvDoorn@gmail.com>
In-Reply-To: <200803092237.43451.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200803092238.18302.IvDoorn@gmail.com> (sfid-20080309_215111_139123_F462CF1A)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some architectures give problems when reading
RX frame descriptor words when the descriptor
is not aligned on a 4 byte boundrary.

Due to optimalizations for the ieee80211 payload
4 byte alignment, it is no longer guarenteed
that the descriptor is placed on the 4 byte
boundrary (In fact, for rt73usb it is absolutely
never aligned to 4 bytes, for rt2500usb it depends
on the length of the payload).

This will copy the descriptor to a 4 byte aligned
location before it is read for the first time.
This will also move the payload data alignment
in rt2x00usb (instead of inside the driver) where
it has always belonged.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2500usb.c |   37 +++++++++++++----------------
 drivers/net/wireless/rt2x00/rt2x00usb.c |   17 ++++++++++++-
 drivers/net/wireless/rt2x00/rt73usb.c   |   39 +++++++++++++-----------------
 3 files changed, 49 insertions(+), 44 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 9f59db9..86cd9a5 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -1117,11 +1117,24 @@ static void rt2500usb_fill_rxdone(struct queue_entry *entry,
 	__le32 *rxd =
 	    (__le32 *)(entry->skb->data +
 		       (priv_rx->urb->actual_length - entry->queue->desc_size));
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)entry->skb->data;
-	int header_size = ieee80211_get_hdrlen(le16_to_cpu(hdr->frame_control));
+	unsigned int offset = entry->queue->desc_size + 2;
 	u32 word0;
 	u32 word1;
 
+	/*
+	 * Copy descriptor to the available headroom inside the skbuffer.
+	 * Remove the original copy by trimming the skbuffer.
+	 */
+	skb_push(entry->skb, offset);
+	memcpy(entry->skb->data, rxd, entry->queue->desc_size);
+	rxd = (__le32 *)entry->skb->data;
+	skb_pull(entry->skb, offset);
+	skb_trim(entry->skb, rxdesc->size);
+
+	/*
+	 * The descriptor is now aligned to 4 bytes and thus it is
+	 * now safe to read it on all architectures.
+	 */
 	rt2x00_desc_read(rxd, 0, &word0);
 	rt2x00_desc_read(rxd, 1, &word1);
 
@@ -1142,28 +1155,12 @@ static void rt2500usb_fill_rxdone(struct queue_entry *entry,
 	rxdesc->my_bss = !!rt2x00_get_field32(word0, RXD_W0_MY_BSS);
 
 	/*
-	 * The data behind the ieee80211 header must be
-	 * aligned on a 4 byte boundary.
-	 */
-	if (header_size % 4 == 0) {
-		skb_push(entry->skb, 2);
-		memmove(entry->skb->data, entry->skb->data + 2,
-			entry->skb->len - 2);
-	}
-
-	/*
-	 * Set descriptor pointer.
+	 * Set descriptor and data pointer.
 	 */
 	skbdesc->data = entry->skb->data;
 	skbdesc->data_len = rxdesc->size;
-	skbdesc->desc = entry->skb->data + rxdesc->size;
+	skbdesc->desc = entry->skb->data - offset;
 	skbdesc->desc_len = entry->queue->desc_size;
-
-	/*
-	 * Remove descriptor from skb buffer and trim the whole thing
-	 * down to only contain data.
-	 */
-	skb_trim(entry->skb, rxdesc->size);
 }
 
 /*
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index 063b167..512ff39 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -247,11 +247,11 @@ static struct sk_buff* rt2x00usb_alloc_rxskb(struct data_queue *queue)
 	 * advance.
 	 */
 	frame_size = queue->data_size + queue->desc_size;
-	skb = dev_alloc_skb(frame_size + 2);
+	skb = dev_alloc_skb(queue->desc_size + frame_size + 2);
 	if (!skb)
 		return NULL;
 
-	skb_reserve(skb, 2);
+	skb_reserve(skb, queue->desc_size + 2);
 	skb_put(skb, frame_size);
 
 	return skb;
@@ -264,6 +264,7 @@ static void rt2x00usb_interrupt_rxdone(struct urb *urb)
 	struct sk_buff *skb;
 	struct skb_frame_desc *skbdesc;
 	struct rxdone_entry_desc rxdesc;
+	int header_size;
 
 	if (!test_bit(DEVICE_ENABLED_RADIO, &rt2x00dev->flags) ||
 	    !test_and_clear_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags))
@@ -288,6 +289,18 @@ static void rt2x00usb_interrupt_rxdone(struct urb *urb)
 	rt2x00dev->ops->lib->fill_rxdone(entry, &rxdesc);
 
 	/*
+	 * The data behind the ieee80211 header must be
+	 * aligned on a 4 byte boundary.
+	 */
+	header_size = ieee80211_get_hdrlen_from_skb(entry->skb);
+	if (header_size % 4 == 0) {
+		skb_push(entry->skb, 2);
+		memmove(entry->skb->data, entry->skb->data + 2,
+			entry->skb->len - 2);
+		skbdesc->data = entry->skb->data;
+	}
+
+	/*
 	 * Allocate a new sk buffer to replace the current one.
 	 * If allocation fails, we should drop the current frame
 	 * so we can recycle the existing sk buffer for the new frame.
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 6546b0d..b4b7085 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -1370,12 +1370,24 @@ static void rt73usb_fill_rxdone(struct queue_entry *entry,
 {
 	struct skb_frame_desc *skbdesc = get_skb_frame_desc(entry->skb);
 	__le32 *rxd = (__le32 *)entry->skb->data;
-	struct ieee80211_hdr *hdr =
-	    (struct ieee80211_hdr *)entry->skb->data + entry->queue->desc_size;
-	int header_size = ieee80211_get_hdrlen(le16_to_cpu(hdr->frame_control));
+	unsigned int offset = entry->queue->desc_size + 2;
 	u32 word0;
 	u32 word1;
 
+	/*
+	 * Copy descriptor to the available headroom inside the skbuffer.
+	 * Remove the original copy by pulling the skbuffer.
+	 */
+	skb_push(entry->skb, offset);
+	memcpy(entry->skb->data, rxd, entry->queue->desc_size);
+	rxd = (__le32 *)entry->skb->data;
+	skb_pull(entry->skb, offset + skbdesc->desc_len);
+	skb_trim(entry->skb, rxdesc->size);
+
+	/*
+	 * The descriptor is now aligned to 4 bytes and thus it is
+	 * now safe to read it on all architectures.
+	 */
 	rt2x00_desc_read(rxd, 0, &word0);
 	rt2x00_desc_read(rxd, 1, &word1);
 
@@ -1393,29 +1405,12 @@ static void rt73usb_fill_rxdone(struct queue_entry *entry,
 	rxdesc->my_bss = !!rt2x00_get_field32(word0, RXD_W0_MY_BSS);
 
 	/*
-	 * The data behind the ieee80211 header must be
-	 * aligned on a 4 byte boundary.
-	 */
-	if (header_size % 4 == 0) {
-		skb_push(entry->skb, 2);
-		memmove(entry->skb->data, entry->skb->data + 2,
-			entry->skb->len - 2);
-	}
-
-	/*
 	 * Set descriptor and data pointer.
 	 */
-	skbdesc->data = entry->skb->data + entry->queue->desc_size;
+	skbdesc->data = entry->skb->data;
 	skbdesc->data_len = rxdesc->size;
-	skbdesc->desc = entry->skb->data;
+	skbdesc->desc = entry->skb->data - offset;
 	skbdesc->desc_len = entry->queue->desc_size;
-
-	/*
-	 * Remove descriptor from skb buffer and trim the whole thing
-	 * down to only contain data.
-	 */
-	skb_pull(entry->skb, skbdesc->desc_len);
-	skb_trim(entry->skb, rxdesc->size);
 }
 
 /*
-- 
1.5.4.3

