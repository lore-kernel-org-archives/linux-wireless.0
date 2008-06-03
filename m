Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.191]:2074 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753145AbYFCS0M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jun 2008 14:26:12 -0400
Received: by nf-out-0910.google.com with SMTP id d3so644244nfc.21
        for <linux-wireless@vger.kernel.org>; Tue, 03 Jun 2008 11:26:12 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 06/11] rt2x00: Removed unused descriptor read in txdone
Date: Tue, 3 Jun 2008 20:29:54 +0200
Cc: rt2400-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
References: <200806032024.52931.IvDoorn@gmail.com> <200806032027.06094.IvDoorn@gmail.com> <200806032027.27540.IvDoorn@gmail.com>
In-Reply-To: <200806032027.27540.IvDoorn@gmail.com>
MIME-Version: 1.0
Message-Id: <200806032029.54261.IvDoorn@gmail.com> (sfid-20080603_202622_752353_88A28482)
Content-Type: text/plain;
  charset="utf-8"
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From 5410c980823b6fd68d38f0230da51cdd70e0e7eb Mon Sep 17 00:00:00 2001
From: Ivo van Doorn <IvDoorn@gmail.com>
Date: Tue, 3 Jun 2008 18:49:49 +0200
Subject: [PATCH] rt2x00: Removed unused descriptor read in txdone

rt2x00usb doesn't need the TX descriptor in the TX done path.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00usb.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index 36a087a..86f1ab7 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -130,16 +130,12 @@ static void rt2x00usb_interrupt_txdone(struct urb *urb)
 	struct queue_entry *entry = (struct queue_entry *)urb->context;
 	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
 	struct txdone_entry_desc txdesc;
-	__le32 *txd = (__le32 *)entry->skb->data;
 	enum data_queue_qid qid = skb_get_queue_mapping(entry->skb);
-	u32 word;
 
 	if (!test_bit(DEVICE_ENABLED_RADIO, &rt2x00dev->flags) ||
 	    !__test_and_clear_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags))
 		return;
 
-	rt2x00_desc_read(txd, 0, &word);
-
 	/*
 	 * Remove the descriptor data from the buffer.
 	 */
-- 
1.5.5.3

