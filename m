Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from Cpsmtpm-eml109.kpnxchange.com ([195.121.3.13]:62417 "EHLO
	CPSMTPM-EML109.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752986AbZK3VJF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Nov 2009 16:09:05 -0500
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	Benoit Papillault <benoit.papillault@free.fr>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: [PATCH v3 1/4] rt2x00: Further L2 padding fixes.
Date: Mon, 30 Nov 2009 22:08:15 +0100
Message-Id: <1259615298-2305-2-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1259615298-2305-1-git-send-email-gwingerde@gmail.com>
References: <1259615298-2305-1-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix a couple of more bugs in the L2 padding code:
1. Compute the amount of L2 padding correctly (in 3 places).
2. Trim the skb correctly when the L2 padding has been applied.

Also introduce a central macro the compute the L2 padding size.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00.h      |    6 ++++++
 drivers/net/wireless/rt2x00/rt2x00queue.c |    8 +++++---
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index dcfc8c2..6594d2f 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -113,6 +113,12 @@
 	(  ((unsigned long)((__skb)->data + (__header))) & 3 )
 
 /*
+ * Determine the number of L2 padding bytes required between the header and
+ * the payload.
+ */
+#define L2PAD_SIZE(__hdrlen)	(-(__hdrlen) & 3)
+
+/*
  * Constants for extra TX headroom for alignment purposes.
  */
 #define RT2X00_ALIGN_SIZE	4 /* Only whole frame needs alignment */
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index b8f0954..21d5876 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -181,7 +181,7 @@ void rt2x00queue_insert_l2pad(struct sk_buff *skb, unsigned int header_length)
 	unsigned int frame_length = skb->len;
 	unsigned int header_align = ALIGN_SIZE(skb, 0);
 	unsigned int payload_align = ALIGN_SIZE(skb, header_length);
-	unsigned int l2pad = 4 - (payload_align - header_align);
+	unsigned int l2pad = L2PAD_SIZE(header_length);
 
 	if (header_align == payload_align) {
 		/*
@@ -216,6 +216,7 @@ void rt2x00queue_insert_l2pad(struct sk_buff *skb, unsigned int header_length)
 		memmove(skb->data + header_length + l2pad,
 			skb->data + header_length + l2pad + payload_align,
 			frame_length - header_length);
+		skb_trim(skb, frame_length + l2pad);
 		skbdesc->flags |= SKBDESC_L2_PADDED;
 	}
 }
@@ -223,7 +224,7 @@ void rt2x00queue_insert_l2pad(struct sk_buff *skb, unsigned int header_length)
 void rt2x00queue_remove_l2pad(struct sk_buff *skb, unsigned int header_length)
 {
 	struct skb_frame_desc *skbdesc = get_skb_frame_desc(skb);
-	unsigned int l2pad = 4 - (header_length & 3);
+	unsigned int l2pad = L2PAD_SIZE(header_length);
 
 	if (!l2pad || (skbdesc->flags & SKBDESC_L2_PADDED))
 		return;
@@ -346,7 +347,8 @@ static void rt2x00queue_create_tx_descriptor(struct queue_entry *entry,
 	 * Header and alignment information.
 	 */
 	txdesc->header_length = ieee80211_get_hdrlen_from_skb(entry->skb);
-	txdesc->l2pad = ALIGN_SIZE(entry->skb, txdesc->header_length);
+	if (test_bit(DRIVER_REQUIRE_L2PAD, &rt2x00dev->flags))
+		txdesc->l2pad = L2PAD_SIZE(txdesc->header_length);
 
 	/*
 	 * Check whether this frame is to be acked.
-- 
1.6.5.3

