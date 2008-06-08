Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.173]:45416 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756206AbYFHVhm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Jun 2008 17:37:42 -0400
Received: by ug-out-1314.google.com with SMTP id h2so1022998ugf.16
        for <linux-wireless@vger.kernel.org>; Sun, 08 Jun 2008 14:37:41 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 06/10] rt2x00: Fix double usage of skb->cb in USB RX path.
Date: Sun, 8 Jun 2008 23:45:25 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200806082341.58616.IvDoorn@gmail.com> <200806082344.28110.IvDoorn@gmail.com> <200806082345.04002.IvDoorn@gmail.com>
In-Reply-To: <200806082345.04002.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200806082345.25904.IvDoorn@gmail.com> (sfid-20080608_233748_764868_EC170FE9)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gertjan van Wingerde <gwingerde@kpnplanet.nl>

It is not safe to use the skb->cb area for both the rxd and skb_frame_desc data at the
same time, while they occupy an overlapping piece of memory. This can lead to hard to
trace crashes as pointers within skb_frame_desc are pointing into nowhere, or the rxd
data is overwritten with non-sense.

Fix it by copying the rxd to a small buffer on the stack.

Signed-off-by: Gertjan van Wingerde <gwingerde@kpnplanet.nl>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2500usb.c |   10 +++-------
 drivers/net/wireless/rt2x00/rt2x00usb.c |    8 +++-----
 drivers/net/wireless/rt2x00/rt73usb.c   |   10 +++-------
 3 files changed, 9 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 1bfb68a..9851cef 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -1156,14 +1156,10 @@ static void rt2500usb_fill_rxdone(struct queue_entry *entry,
 	u32 word1;
 
 	/*
-	 * Copy descriptor to the skb->cb array, this has 2 benefits:
-	 * 1) Each descriptor word is 4 byte aligned.
-	 * 2) Descriptor is safe  from moving of frame data in rt2x00usb.
+	 * Copy descriptor to the skbdesc->desc buffer, making it safe from moving of
+	 * frame data in rt2x00usb.
 	 */
-	skbdesc->desc_len =
-	    min_t(u16, entry->queue->desc_size, sizeof(entry->skb->cb));
-	memcpy(entry->skb->cb, rxd, skbdesc->desc_len);
-	skbdesc->desc = entry->skb->cb;
+	memcpy(skbdesc->desc, rxd, skbdesc->desc_len);
 	rxd = (__le32 *)skbdesc->desc;
 
 	/*
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index 6e22036..3080969 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -267,6 +267,7 @@ static void rt2x00usb_interrupt_rxdone(struct urb *urb)
 	struct sk_buff *skb;
 	struct skb_frame_desc *skbdesc;
 	struct rxdone_entry_desc rxdesc;
+	u8 rxd[32];
 
 	if (!test_bit(DEVICE_ENABLED_RADIO, &rt2x00dev->flags) ||
 	    !test_and_clear_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags))
@@ -286,16 +287,13 @@ static void rt2x00usb_interrupt_rxdone(struct urb *urb)
 	skbdesc = get_skb_frame_desc(entry->skb);
 	memset(skbdesc, 0, sizeof(*skbdesc));
 	skbdesc->entry = entry;
+	skbdesc->desc = rxd;
+	skbdesc->desc_len = entry->queue->desc_size;
 
 	memset(&rxdesc, 0, sizeof(rxdesc));
 	rt2x00dev->ops->lib->fill_rxdone(entry, &rxdesc);
 
 	/*
-	 * Trim the skb to the correct size.
-	 */
-	skb_trim(entry->skb, rxdesc.size);
-
-	/*
 	 * Allocate a new sk buffer to replace the current one.
 	 * If allocation fails, we should drop the current frame
 	 * so we can recycle the existing sk buffer for the new frame.
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 800a1e2..505a9f5 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -1428,14 +1428,10 @@ static void rt73usb_fill_rxdone(struct queue_entry *entry,
 	u32 word1;
 
 	/*
-	 * Copy descriptor to the skb->cb array, this has 2 benefits:
-	 * 1) Each descriptor word is 4 byte aligned.
-	 * 2) Descriptor is safe  from moving of frame data in rt2x00usb.
+	 * Copy descriptor to the skbdesc->desc buffer, making it safe from moving of
+	 * frame data in rt2x00usb.
 	 */
-	skbdesc->desc_len =
-	    min_t(u16, entry->queue->desc_size, sizeof(entry->skb->cb));
-	memcpy(entry->skb->cb, rxd, skbdesc->desc_len);
-	skbdesc->desc = entry->skb->cb;
+	memcpy(skbdesc->desc, rxd, skbdesc->desc_len);
 	rxd = (__le32 *)skbdesc->desc;
 
 	/*
-- 
1.5.5.3

