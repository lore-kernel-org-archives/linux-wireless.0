Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.184]:20731 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753297AbYEJMKL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 May 2008 08:10:11 -0400
Received: by nf-out-0910.google.com with SMTP id d3so883151nfc.21
        for <linux-wireless@vger.kernel.org>; Sat, 10 May 2008 05:10:10 -0700 (PDT)
To: linville@tuxdriver.com
Subject: [PATCH 10/16] rt2x00: Preserve descriptor information after memmove()
Date: Sat, 10 May 2008 13:43:38 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200805101337.14536.IvDoorn@gmail.com>
In-Reply-To: <200805101337.14536.IvDoorn@gmail.com>
MIME-Version: 1.0
Message-Id: <200805101343.39127.IvDoorn@gmail.com> (sfid-20080510_141526_823499_50AD2628)
Content-Type: text/plain;
  charset="utf-8"
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Due to usage of memmove() in rt2x00usb the descriptor can become
corrupted because it is being overwritten by the data part.
Overall having the descriptor in front of the frame is a bad idea,
we can however use the skb->cb array for this task, since that
contains more then enough room to hold the entire descriptor and
preserve the information long enough.

After this we can also cleanup the alignment code a bit to make it
work a bit more flexible to allow for all kinds of odd header lengths.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2500usb.c |   23 ++++-------
 drivers/net/wireless/rt2x00/rt2x00usb.c |   62 +++++++++++++++++++++---------
 drivers/net/wireless/rt2x00/rt73usb.c   |   26 +++++-------
 3 files changed, 63 insertions(+), 48 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 2fa3840..0a0727a 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -1129,20 +1129,22 @@ static void rt2500usb_fill_rxdone(struct queue_entry *entry,
 	__le32 *rxd =
 	    (__le32 *)(entry->skb->data +
 		       (priv_rx->urb->actual_length - entry->queue->desc_size));
-	unsigned int offset = entry->queue->desc_size + 2;
 	u32 word0;
 	u32 word1;
 
 	/*
-	 * Copy descriptor to the available headroom inside the skbuffer.
+	 * Copy descriptor to the skb->cb array, this has 2 benefits:
+	 * 1) Each descriptor word is 4 byte aligned.
+	 * 2) Descriptor is safe  from moving of frame data in rt2x00usb.
 	 */
-	skb_push(entry->skb, offset);
-	memcpy(entry->skb->data, rxd, entry->queue->desc_size);
-	rxd = (__le32 *)entry->skb->data;
+	skbdesc->desc_len =
+	    min_t(u16, entry->queue->desc_size, sizeof(entry->skb->cb));
+	memcpy(entry->skb->cb, rxd, skbdesc->desc_len);
+	skbdesc->desc = entry->skb->cb;
+	rxd = (__le32 *)skbdesc->desc;
 
 	/*
-	 * The descriptor is now aligned to 4 bytes and thus it is
-	 * now safe to read it on all architectures.
+	 * It is now safe to read the descriptor on all architectures.
 	 */
 	rt2x00_desc_read(rxd, 0, &word0);
 	rt2x00_desc_read(rxd, 1, &word1);
@@ -1173,16 +1175,9 @@ static void rt2500usb_fill_rxdone(struct queue_entry *entry,
 	/*
 	 * Adjust the skb memory window to the frame boundaries.
 	 */
-	skb_pull(entry->skb, offset);
 	skb_trim(entry->skb, rxdesc->size);
-
-	/*
-	 * Set descriptor and data pointer.
-	 */
 	skbdesc->data = entry->skb->data;
 	skbdesc->data_len = rxdesc->size;
-	skbdesc->desc = rxd;
-	skbdesc->desc_len = entry->queue->desc_size;
 }
 
 /*
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index caee65e..955f7d9 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -246,22 +246,35 @@ static struct sk_buff* rt2x00usb_alloc_rxskb(struct data_queue *queue)
 {
 	struct sk_buff *skb;
 	unsigned int frame_size;
+	unsigned int reserved_size;
 
 	/*
-	 * As alignment we use 2 and not NET_IP_ALIGN because we need
-	 * to be sure we have 2 bytes room in the head. (NET_IP_ALIGN
-	 * can be 0 on some hardware). We use these 2 bytes for frame
-	 * alignment later, we assume that the chance that
-	 * header_size % 4 == 2 is bigger then header_size % 2 == 0
-	 * and thus optimize alignment by reserving the 2 bytes in
-	 * advance.
+	 * The frame size includes descriptor size, because the
+	 * hardware directly receive the frame into the skbuffer.
 	 */
 	frame_size = queue->data_size + queue->desc_size;
-	skb = dev_alloc_skb(queue->desc_size + frame_size + 2);
+
+	/*
+	 * For the allocation we should keep a few things in mind:
+	 * 1) 4byte alignment of 802.11 payload
+	 *
+	 * For (1) we need at most 4 bytes to guarentee the correct
+	 * alignment. We are going to optimize the fact that the chance
+	 * that the 802.11 header_size % 4 == 2 is much bigger then
+	 * anything else. However since we need to move the frame up
+	 * to 3 bytes to the front, which means we need to preallocate
+	 * 6 bytes.
+	 */
+	reserved_size = 6;
+
+	/*
+	 * Allocate skbuffer.
+	 */
+	skb = dev_alloc_skb(frame_size + reserved_size);
 	if (!skb)
 		return NULL;
 
-	skb_reserve(skb, queue->desc_size + 2);
+	skb_reserve(skb, reserved_size);
 	skb_put(skb, frame_size);
 
 	return skb;
@@ -274,7 +287,8 @@ static void rt2x00usb_interrupt_rxdone(struct urb *urb)
 	struct sk_buff *skb;
 	struct skb_frame_desc *skbdesc;
 	struct rxdone_entry_desc rxdesc;
-	int header_size;
+	unsigned int header_size;
+	unsigned int align;
 
 	if (!test_bit(DEVICE_ENABLED_RADIO, &rt2x00dev->flags) ||
 	    !test_and_clear_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags))
@@ -298,19 +312,29 @@ static void rt2x00usb_interrupt_rxdone(struct urb *urb)
 	memset(&rxdesc, 0, sizeof(rxdesc));
 	rt2x00dev->ops->lib->fill_rxdone(entry, &rxdesc);
 
+	header_size = ieee80211_get_hdrlen_from_skb(entry->skb);
+
 	/*
 	 * The data behind the ieee80211 header must be
-	 * aligned on a 4 byte boundary.
-	 */
-	header_size = ieee80211_get_hdrlen_from_skb(entry->skb);
-	if (header_size % 4 == 0) {
-		skb_push(entry->skb, 2);
-		memmove(entry->skb->data, entry->skb->data + 2,
-			entry->skb->len - 2);
-		skbdesc->data = entry->skb->data;
-		skb_trim(entry->skb,entry->skb->len - 2);
+	 * aligned on a 4 byte boundary. We already reserved
+	 * 2 bytes for header_size % 4 == 2 optimization.
+	 * To determine the number of bytes which the data
+	 * should be moved to the left, we must add these
+	 * 2 bytes to the header_size.
+ 	 */
+	align = (header_size + 2) % 4;
+
+	if (align) {
+		skb_push(entry->skb, align);
+		/* Move entire frame in 1 command */
+		memmove(entry->skb->data, entry->skb->data + align,
+			rxdesc.size);
 	}
 
+	/* Update data pointers, trim buffer to correct size */
+	skbdesc->data = entry->skb->data;
+	skb_trim(entry->skb, rxdesc.size);
+
 	/*
 	 * Allocate a new sk buffer to replace the current one.
 	 * If allocation fails, we should drop the current frame
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 288d80a..6857d14 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -1403,20 +1403,22 @@ static void rt73usb_fill_rxdone(struct queue_entry *entry,
 {
 	struct skb_frame_desc *skbdesc = get_skb_frame_desc(entry->skb);
 	__le32 *rxd = (__le32 *)entry->skb->data;
-	unsigned int offset = entry->queue->desc_size + 2;
 	u32 word0;
 	u32 word1;
 
 	/*
-	 * Copy descriptor to the available headroom inside the skbuffer.
+	 * Copy descriptor to the skb->cb array, this has 2 benefits:
+	 * 1) Each descriptor word is 4 byte aligned.
+	 * 2) Descriptor is safe  from moving of frame data in rt2x00usb.
 	 */
-	skb_push(entry->skb, offset);
-	memcpy(entry->skb->data, rxd, entry->queue->desc_size);
-	rxd = (__le32 *)entry->skb->data;
+	skbdesc->desc_len =
+	    min_t(u16, entry->queue->desc_size, sizeof(entry->skb->cb));
+	memcpy(entry->skb->cb, rxd, skbdesc->desc_len);
+	skbdesc->desc = entry->skb->cb;
+	rxd = (__le32 *)skbdesc->desc;
 
 	/*
-	 * The descriptor is now aligned to 4 bytes and thus it is
-	 * now safe to read it on all architectures.
+	 * It is now safe to read the descriptor on all architectures.
 	 */
 	rt2x00_desc_read(rxd, 0, &word0);
 	rt2x00_desc_read(rxd, 1, &word1);
@@ -1442,18 +1444,12 @@ static void rt73usb_fill_rxdone(struct queue_entry *entry,
 		rxdesc->dev_flags |= RXDONE_MY_BSS;
 
 	/*
-	 * Adjust the skb memory window to the frame boundaries.
+	 * Set skb pointers, and update frame information.
 	 */
-	skb_pull(entry->skb, offset + entry->queue->desc_size);
+	skb_pull(entry->skb, entry->queue->desc_size);
 	skb_trim(entry->skb, rxdesc->size);
-
-	/*
-	 * Set descriptor and data pointer.
-	 */
 	skbdesc->data = entry->skb->data;
 	skbdesc->data_len = rxdesc->size;
-	skbdesc->desc = rxd;
-	skbdesc->desc_len = entry->queue->desc_size;
 }
 
 /*
-- 
1.5.5.1

