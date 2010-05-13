Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:2645 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752446Ab0EMJhD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 May 2010 05:37:03 -0400
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Ivo van Doorn <IvDoorn@gmail.com>,
	<linux-wireless@vger.kernel.org>, <users@rt2x00.serialmonkey.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: [PATCH v2 01/10] rt2x00: Consistently name skb frame descriptor skbdesc.
Date: Thu, 13 May 2010 11:36:49 +0200
Message-Id: <1273743418-28383-2-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1273743418-28383-1-git-send-email-gwingerde@gmail.com>
References: <1273743418-28383-1-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The skb frame descriptor is called everywhere skbdesc, except in one
place in rt2x00debug_dump_frame. Change that occurence to have
consistent naming.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00debug.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00debug.c b/drivers/net/wireless/rt2x00/rt2x00debug.c
index 70c04c2..9e2eed5 100644
--- a/drivers/net/wireless/rt2x00/rt2x00debug.c
+++ b/drivers/net/wireless/rt2x00/rt2x00debug.c
@@ -155,7 +155,7 @@ void rt2x00debug_dump_frame(struct rt2x00_dev *rt2x00dev,
 			    enum rt2x00_dump_type type, struct sk_buff *skb)
 {
 	struct rt2x00debug_intf *intf = rt2x00dev->debugfs_intf;
-	struct skb_frame_desc *desc = get_skb_frame_desc(skb);
+	struct skb_frame_desc *skbdesc = get_skb_frame_desc(skb);
 	struct sk_buff *skbcopy;
 	struct rt2x00dump_hdr *dump_hdr;
 	struct timeval timestamp;
@@ -170,7 +170,7 @@ void rt2x00debug_dump_frame(struct rt2x00_dev *rt2x00dev,
 		return;
 	}
 
-	skbcopy = alloc_skb(sizeof(*dump_hdr) + desc->desc_len + skb->len,
+	skbcopy = alloc_skb(sizeof(*dump_hdr) + skbdesc->desc_len + skb->len,
 			    GFP_ATOMIC);
 	if (!skbcopy) {
 		DEBUG(rt2x00dev, "Failed to copy skb for dump.\n");
@@ -180,18 +180,19 @@ void rt2x00debug_dump_frame(struct rt2x00_dev *rt2x00dev,
 	dump_hdr = (struct rt2x00dump_hdr *)skb_put(skbcopy, sizeof(*dump_hdr));
 	dump_hdr->version = cpu_to_le32(DUMP_HEADER_VERSION);
 	dump_hdr->header_length = cpu_to_le32(sizeof(*dump_hdr));
-	dump_hdr->desc_length = cpu_to_le32(desc->desc_len);
+	dump_hdr->desc_length = cpu_to_le32(skbdesc->desc_len);
 	dump_hdr->data_length = cpu_to_le32(skb->len);
 	dump_hdr->chip_rt = cpu_to_le16(rt2x00dev->chip.rt);
 	dump_hdr->chip_rf = cpu_to_le16(rt2x00dev->chip.rf);
 	dump_hdr->chip_rev = cpu_to_le16(rt2x00dev->chip.rev);
 	dump_hdr->type = cpu_to_le16(type);
-	dump_hdr->queue_index = desc->entry->queue->qid;
-	dump_hdr->entry_index = desc->entry->entry_idx;
+	dump_hdr->queue_index = skbdesc->entry->queue->qid;
+	dump_hdr->entry_index = skbdesc->entry->entry_idx;
 	dump_hdr->timestamp_sec = cpu_to_le32(timestamp.tv_sec);
 	dump_hdr->timestamp_usec = cpu_to_le32(timestamp.tv_usec);
 
-	memcpy(skb_put(skbcopy, desc->desc_len), desc->desc, desc->desc_len);
+	memcpy(skb_put(skbcopy, skbdesc->desc_len), skbdesc->desc,
+	       skbdesc->desc_len);
 	memcpy(skb_put(skbcopy, skb->len), skb->data, skb->len);
 
 	skb_queue_tail(&intf->frame_dump_skbqueue, skbcopy);
-- 
1.7.1

