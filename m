Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:1118 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752879Ab0EKVvw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 May 2010 17:51:52 -0400
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Ivo van Doorn <IvDoorn@gmail.com>,
	<linux-wireless@vger.kernel.org>, <users@rt2x00.serialmonkey.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: [PATCH 7/9] rt2x00: In debugfs frame dumping allow the TX descriptor to be part of the skb.
Date: Tue, 11 May 2010 23:51:43 +0200
Message-Id: <1273614705-25118-8-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1273614705-25118-1-git-send-email-gwingerde@gmail.com>
References: <1273614705-25118-1-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Preparation for futher cleanups in the area of properly maintaining the skb
data without fiddling with the skb->data pointer.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00debug.c |   14 ++++++++++----
 drivers/net/wireless/rt2x00/rt2x00queue.h |    3 +++
 2 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00debug.c b/drivers/net/wireless/rt2x00/rt2x00debug.c
index 85e9990..9dd8b7c 100644
--- a/drivers/net/wireless/rt2x00/rt2x00debug.c
+++ b/drivers/net/wireless/rt2x00/rt2x00debug.c
@@ -159,6 +159,7 @@ void rt2x00debug_dump_frame(struct rt2x00_dev *rt2x00dev,
 	struct sk_buff *skbcopy;
 	struct rt2x00dump_hdr *dump_hdr;
 	struct timeval timestamp;
+	u32 data_len;
 
 	do_gettimeofday(&timestamp);
 
@@ -170,7 +171,11 @@ void rt2x00debug_dump_frame(struct rt2x00_dev *rt2x00dev,
 		return;
 	}
 
-	skbcopy = alloc_skb(sizeof(*dump_hdr) + skbdesc->desc_len + skb->len,
+	data_len = skb->len;
+	if (skbdesc->flags & SKBDESC_DESC_IN_SKB)
+		data_len -= skbdesc->desc_len;
+
+	skbcopy = alloc_skb(sizeof(*dump_hdr) + skbdesc->desc_len + data_len,
 			    GFP_ATOMIC);
 	if (!skbcopy) {
 		DEBUG(rt2x00dev, "Failed to copy skb for dump.\n");
@@ -181,7 +186,7 @@ void rt2x00debug_dump_frame(struct rt2x00_dev *rt2x00dev,
 	dump_hdr->version = cpu_to_le32(DUMP_HEADER_VERSION);
 	dump_hdr->header_length = cpu_to_le32(sizeof(*dump_hdr));
 	dump_hdr->desc_length = cpu_to_le32(skbdesc->desc_len);
-	dump_hdr->data_length = cpu_to_le32(skb->len);
+	dump_hdr->data_length = cpu_to_le32(data_len);
 	dump_hdr->chip_rt = cpu_to_le16(rt2x00dev->chip.rt);
 	dump_hdr->chip_rf = cpu_to_le16(rt2x00dev->chip.rf);
 	dump_hdr->chip_rev = cpu_to_le16(rt2x00dev->chip.rev);
@@ -191,8 +196,9 @@ void rt2x00debug_dump_frame(struct rt2x00_dev *rt2x00dev,
 	dump_hdr->timestamp_sec = cpu_to_le32(timestamp.tv_sec);
 	dump_hdr->timestamp_usec = cpu_to_le32(timestamp.tv_usec);
 
-	memcpy(skb_put(skbcopy, skbdesc->desc_len), skbdesc->desc,
-	       skbdesc->desc_len);
+	if (!(skbdesc->flags & SKBDESC_DESC_IN_SKB))
+		memcpy(skb_put(skbcopy, skbdesc->desc_len), skbdesc->desc,
+		       skbdesc->desc_len);
 	memcpy(skb_put(skbcopy, skb->len), skb->data, skb->len);
 
 	skb_queue_tail(&intf->frame_dump_skbqueue, skbcopy);
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.h b/drivers/net/wireless/rt2x00/rt2x00queue.h
index 36a957a..f791708 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.h
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.h
@@ -94,12 +94,15 @@ enum data_queue_qid {
  *	mac80211 but was stripped for processing by the driver.
  * @SKBDESC_NOT_MAC80211: Frame didn't originate from mac80211,
  *	don't try to pass it back.
+ * @SKBDESC_DESC_IN_SKB: The descriptor is at the start of the
+ *	skb, instead of in the desc field.
  */
 enum skb_frame_desc_flags {
 	SKBDESC_DMA_MAPPED_RX = 1 << 0,
 	SKBDESC_DMA_MAPPED_TX = 1 << 1,
 	SKBDESC_IV_STRIPPED = 1 << 2,
 	SKBDESC_NOT_MAC80211 = 1 << 3,
+	SKBDESC_DESC_IN_SKB = 1 << 4,
 };
 
 /**
-- 
1.7.1

