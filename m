Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.184]:12089 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752347AbYGDLgY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Jul 2008 07:36:24 -0400
Received: by nf-out-0910.google.com with SMTP id d3so359293nfc.21
        for <linux-wireless@vger.kernel.org>; Fri, 04 Jul 2008 04:36:23 -0700 (PDT)
To: linville@tuxdriver.com
Subject: [PATCH 2/4] rt2x00: Decrease alignment headroom
Date: Fri, 4 Jul 2008 13:41:29 +0200
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	rt2400-devel@lists.sourceforge.net
References: <200807041340.28103.IvDoorn@gmail.com>
In-Reply-To: <200807041340.28103.IvDoorn@gmail.com>
MIME-Version: 1.0
Message-Id: <200807041341.29802.IvDoorn@gmail.com> (sfid-20080704_133626_697683_7BBC75B6)
Content-Type: text/plain;
  charset="utf-8"
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We only need 4 bytes of headroom for alignment
purposes in the RX frame. It was previously higher
for optimization purposes which are no longer
possible due to DMA mappings.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index 8e86611..3ddce53 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net
/wireless/rt2x00/rt2x00queue.c
@@ -45,10 +45,11 @@ struct sk_buff *rt2x00queue_alloc_rxskb(struct rt2x00_dev *rt2x00dev,
 	frame_size = entry->queue->data_size + entry->queue->desc_size;
 
 	/*
-	 * Reserve a few bytes extra headroom to allow drivers some moving
-	 * space (e.g. for alignment), while keeping the skb aligned.
+	 * The payload should be aligned to a 4-byte boundary,
+	 * this means we need at least 3 bytes for moving the frame
+	 * into the correct offset.
 	 */
-	reserved_size = 8;
+	reserved_size = 4;
 
 	/*
 	 * Allocate skbuffer.
