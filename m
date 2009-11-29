Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpm-eml101.kpnxchange.com ([195.121.3.5]:63900 "EHLO
	CPSMTPM-EML101.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754080AbZK2Lr4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Nov 2009 06:47:56 -0500
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	Alban Browaeys <prahal@yahoo.com>,
	Benoit PAPILLAULT <benoit.papillault@free.fr>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: [PATCH v2] rt2x00: Further L2 padding fixes.
Date: Sun, 29 Nov 2009 12:47:58 +0100
Message-Id: <1259495278-2264-1-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix a couple of more bugs in the L2 padding code:
1. Compute the amount of L2 padding correctly (in 3 places).
2. Trim the skb correctly when the L2 padding has been applied.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
---

v2:
- Fix bug detect by Benoit Papillault.

---
 drivers/net/wireless/rt2x00/rt2x00queue.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index b8f0954..9082fad 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -181,7 +181,7 @@ void rt2x00queue_insert_l2pad(struct sk_buff *skb, unsigned int header_length)
 	unsigned int frame_length = skb->len;
 	unsigned int header_align = ALIGN_SIZE(skb, 0);
 	unsigned int payload_align = ALIGN_SIZE(skb, header_length);
-	unsigned int l2pad = 4 - (payload_align - header_align);
+	unsigned int l2pad = (4 - (header_length & 3)) & 3;
 
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
+	unsigned int l2pad = (4 - (header_length & 3)) & 3;
 
 	if (!l2pad || (skbdesc->flags & SKBDESC_L2_PADDED))
 		return;
@@ -346,7 +347,7 @@ static void rt2x00queue_create_tx_descriptor(struct queue_entry *entry,
 	 * Header and alignment information.
 	 */
 	txdesc->header_length = ieee80211_get_hdrlen_from_skb(entry->skb);
-	txdesc->l2pad = ALIGN_SIZE(entry->skb, txdesc->header_length);
+	txdesc->l2pad = (4 - (txdesc->header_length & 3)) & 3;
 
 	/*
 	 * Check whether this frame is to be acked.
-- 
1.6.5.3

