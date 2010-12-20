Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f180.google.com ([209.85.161.180]:63464 "EHLO
	mail-gx0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754165Ab0LTIgX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Dec 2010 03:36:23 -0500
Received: by gxk19 with SMTP id 19so1517628gxk.11
        for <linux-wireless@vger.kernel.org>; Mon, 20 Dec 2010 00:36:22 -0800 (PST)
From: Ismael Luceno <ismael.luceno@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Ivo Van Doorn <ivdoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Ismael Luceno <ismael.luceno@gmail.com>
Subject: [PATCH 1/2] rt2x00: Write the frame *after* padding (rt2800 usb devices)
Date: Mon, 20 Dec 2010 06:31:48 -0200
Message-Id: <1292833909-20138-1-git-send-email-ismael.luceno@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Ismael Luceno <ismael.luceno@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800usb.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 3e0205d..85185de 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -378,9 +378,10 @@ static void rt2800usb_write_tx_data(struct queue_entry *entry,
 	 * | TXINFO | TXWI | 802.11 header | L2 pad | payload | pad | USB end pad |
 	 *                 |<------------- tx_pkt_len ------------->|
 	 */
-        rt2800_write_tx_data(entry, txdesc);
-        padding_len = roundup(entry->skb->len + 4, 4) - entry->skb->len;
-        memset(skb_put(entry->skb, padding_len), 0, padding_len);
+	padding_len = roundup(entry->skb->len + 4, 4) - entry->skb->len;
+	memset(skb_put(entry->skb, padding_len), 0, padding_len);
+
+	rt2800_write_tx_data(entry, txdesc);
 }
 
 /*
-- 
1.7.3.4

