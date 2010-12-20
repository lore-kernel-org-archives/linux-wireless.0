Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f42.google.com ([74.125.83.42]:58609 "EHLO
	mail-gw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754165Ab0LTIgc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Dec 2010 03:36:32 -0500
Received: by gwb20 with SMTP id 20so1892148gwb.1
        for <linux-wireless@vger.kernel.org>; Mon, 20 Dec 2010 00:36:31 -0800 (PST)
From: Ismael Luceno <ismael.luceno@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Ivo Van Doorn <ivdoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Ismael Luceno <ismael.luceno@gmail.com>
Subject: [PATCH 2/2] rt2x00: Fix panic on frame padding for rt2800 usb devices (due to not enough skb tailroom)
Date: Mon, 20 Dec 2010 06:31:49 -0200
Message-Id: <1292833909-20138-2-git-send-email-ismael.luceno@gmail.com>
In-Reply-To: <1292833909-20138-1-git-send-email-ismael.luceno@gmail.com>
References: <1292833909-20138-1-git-send-email-ismael.luceno@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Ismael Luceno <ismael.luceno@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800usb.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 85185de..d284e1e 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -369,7 +369,8 @@ static void rt2800usb_write_tx_desc(struct queue_entry *entry,
 static void rt2800usb_write_tx_data(struct queue_entry *entry,
 					struct txentry_desc *txdesc)
 {
-	u8 padding_len;
+	unsigned int padding_len;
+	int err;
 
 	/*
 	 * pad(1~3 bytes) is added after each 802.11 payload.
@@ -379,8 +380,14 @@ static void rt2800usb_write_tx_data(struct queue_entry *entry,
 	 *                 |<------------- tx_pkt_len ------------->|
 	 */
 	padding_len = roundup(entry->skb->len + 4, 4) - entry->skb->len;
-	memset(skb_put(entry->skb, padding_len), 0, padding_len);
 
+	err = skb_pad(entry->skb, padding_len);
+	if (unlikely(err)) {
+		WARNING(entry->queue->rt2x00dev, "TX SKB padding error, out of memory\n");
+		return;
+	}
+
+	entry->skb->len += padding_len;
 	rt2800_write_tx_data(entry, txdesc);
 }
 
-- 
1.7.3.4

