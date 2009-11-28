Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpm-eml102.kpnxchange.com ([195.121.3.6]:51329 "EHLO
	CPSMTPM-EML102.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752120AbZK1Scf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Nov 2009 13:32:35 -0500
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	Alban Browaeys <prahal@yahoo.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: [PATCH] rt2x00: Further L2 padding fixes.
Date: Sat, 28 Nov 2009 19:32:34 +0100
Message-Id: <1259433154-2587-1-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix a couple of more bugs in the L2 padding code:
1. Compute the amount of L2 padding correctly (in 2 places).
2. Trim the skb correctly when the L2 padding has been applied.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00queue.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index b8f0954..562a344 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -181,7 +181,7 @@ void rt2x00queue_insert_l2pad(struct sk_buff *skb, unsigned int header_length)
 	unsigned int frame_length = skb->len;
 	unsigned int header_align = ALIGN_SIZE(skb, 0);
 	unsigned int payload_align = ALIGN_SIZE(skb, header_length);
-	unsigned int l2pad = 4 - (payload_align - header_align);
+	unsigned int l2pad = 4 - (header_length & 3);
 
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
@@ -346,7 +347,7 @@ static void rt2x00queue_create_tx_descriptor(struct queue_entry *entry,
 	 * Header and alignment information.
 	 */
 	txdesc->header_length = ieee80211_get_hdrlen_from_skb(entry->skb);
-	txdesc->l2pad = ALIGN_SIZE(entry->skb, txdesc->header_length);
+	txdesc->l2pad = 4 - (txdesc->header_length & 3);
 
 	/*
 	 * Check whether this frame is to be acked.
-- 
1.6.5.3

