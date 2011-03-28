Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:58041 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753169Ab1C1LhB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Mar 2011 07:37:01 -0400
Received: by mail-ww0-f44.google.com with SMTP id 36so3686803wwa.1
        for <linux-wireless@vger.kernel.org>; Mon, 28 Mar 2011 04:37:01 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 08/13] rt2x00: Remove obsolete rt2x00queue_align_payload
Date: Mon, 28 Mar 2011 13:33:04 +0200
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201103281329.45470.IvDoorn@gmail.com> <201103281332.01948.IvDoorn@gmail.com> <201103281332.34565.IvDoorn@gmail.com>
In-Reply-To: <201103281332.34565.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201103281333.05671.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Helmut Schaa <helmut.schaa@googlemail.com>

Since commit d1c3a37ceeb1a5ea02991a0476355f1a1d3b3e83 ("mac80211:
clarify alignment docs, fix up alignment") removed the requirement
for a 4-byte aligned payload rt2x00queue_align_payload is obsolete
as mac80211 will align the payload when it passes the frame to the
net stack.

As a result we can remove the call to rt2x00queue_align_payload in the
rx path and since that's the last user we can remove
rt2x00queue_align_payload altogether.

One advantage is that we save some alignment operations for frames
that don't need to be aligned (for example beause they are not passed
to the net stack).

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00dev.c   |    2 --
 drivers/net/wireless/rt2x00/rt2x00lib.h   |   10 ----------
 drivers/net/wireless/rt2x00/rt2x00queue.c |   13 -------------
 3 files changed, 0 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index d63b582..55c1d03 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -512,8 +512,6 @@ void rt2x00lib_rxdone(struct queue_entry *entry)
 		 (rxdesc.size > header_length) &&
 		 (rxdesc.dev_flags & RXDONE_L2PAD))
 		rt2x00queue_remove_l2pad(entry->skb, header_length);
-	else
-		rt2x00queue_align_payload(entry->skb, header_length);
 
 	/* Trim buffer to correct size */
 	skb_trim(entry->skb, rxdesc.size);
diff --git a/drivers/net/wireless/rt2x00/rt2x00lib.h b/drivers/net/wireless/rt2x00/rt2x00lib.h
index 2d94cba..63c40d4 100644
--- a/drivers/net/wireless/rt2x00/rt2x00lib.h
+++ b/drivers/net/wireless/rt2x00/rt2x00lib.h
@@ -119,16 +119,6 @@ void rt2x00queue_free_skb(struct queue_entry *entry);
 void rt2x00queue_align_frame(struct sk_buff *skb);
 
 /**
- * rt2x00queue_align_payload - Align 802.11 payload to 4-byte boundary
- * @skb: The skb to align
- * @header_length: Length of 802.11 header
- *
- * Align the 802.11 payload to a 4-byte boundary, this could
- * mean the header is not aligned properly though.
- */
-void rt2x00queue_align_payload(struct sk_buff *skb, unsigned int header_length);
-
-/**
  * rt2x00queue_insert_l2pad - Align 802.11 header & payload to 4-byte boundary
  * @skb: The skb to align
  * @header_length: Length of 802.11 header
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index 4b3c70e..5d89259 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -148,19 +148,6 @@ void rt2x00queue_align_frame(struct sk_buff *skb)
 	skb_trim(skb, frame_length);
 }
 
-void rt2x00queue_align_payload(struct sk_buff *skb, unsigned int header_length)
-{
-	unsigned int frame_length = skb->len;
-	unsigned int align = ALIGN_SIZE(skb, header_length);
-
-	if (!align)
-		return;
-
-	skb_push(skb, align);
-	memmove(skb->data, skb->data + align, frame_length);
-	skb_trim(skb, frame_length);
-}
-
 void rt2x00queue_insert_l2pad(struct sk_buff *skb, unsigned int header_length)
 {
 	unsigned int payload_length = skb->len - header_length;
-- 
1.7.2.3

