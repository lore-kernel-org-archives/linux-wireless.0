Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f45.google.com ([209.85.215.45]:47560 "EHLO
	mail-ew0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754255Ab0LMLkP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Dec 2010 06:40:15 -0500
Received: by mail-ew0-f45.google.com with SMTP id 10so3803451ewy.4
        for <linux-wireless@vger.kernel.org>; Mon, 13 Dec 2010 03:40:15 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 05/17] rt2x00: Ensure TX-ed frames are returned in the original state.
Date: Mon, 13 Dec 2010 12:33:12 +0100
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201012131231.28313.IvDoorn@gmail.com> <201012131232.23491.IvDoorn@gmail.com> <201012131232.50201.IvDoorn@gmail.com>
In-Reply-To: <201012131232.50201.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201012131233.13651.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gertjan van Wingerde <gwingerde@gmail.com>

Recent changes to the TX-done code of rt2x00 resulted in TX-ed frames not
being returned to mac80211 in the original state, and therefore with
insufficient headroom for re-transmissions.

Fix this by reverting the changes done and by ensuring we remove the inserted
L2pad by moving the header backwards instead of the data forwards.

At the same time also make sure that the rt2x00queue_remove_l2pad will not
move any memory when a frame has no data at all.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
Acked-by: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: Jay Hung <Jay_Hung@ralinktech.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00queue.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index a3d79c7..35133d8 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -199,15 +199,18 @@ void rt2x00queue_insert_l2pad(struct sk_buff *skb, unsigned int header_length)
 
 void rt2x00queue_remove_l2pad(struct sk_buff *skb, unsigned int header_length)
 {
-	unsigned int l2pad = L2PAD_SIZE(header_length);
+	/*
+	 * L2 padding is only present if the skb contains more than just the
+	 * IEEE 802.11 header.
+	 */
+	unsigned int l2pad = (skb->len > header_length) ?
+				L2PAD_SIZE(header_length) : 0;
 
 	if (!l2pad)
 		return;
 
-	memmove(skb->data + header_length, skb->data + header_length + l2pad,
-				skb->len - header_length - l2pad);
-
-	skb_trim(skb, skb->len - l2pad);
+	memmove(skb->data + l2pad, skb->data, header_length);
+	skb_pull(skb, l2pad);
 }
 
 static void rt2x00queue_create_tx_descriptor_seq(struct queue_entry *entry,
-- 
1.7.2.3

