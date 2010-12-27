Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:38767 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753842Ab0L0OIT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Dec 2010 09:08:19 -0500
Received: by mail-wy0-f174.google.com with SMTP id 28so8482816wyb.19
        for <linux-wireless@vger.kernel.org>; Mon, 27 Dec 2010 06:08:18 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 06/10] rt2x00: Fix panic on frame padding for rt2800 usb devices
Date: Mon, 27 Dec 2010 15:06:17 +0100
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201012271504.30848.IvDoorn@gmail.com> <201012271505.36104.IvDoorn@gmail.com> <201012271505.56572.IvDoorn@gmail.com>
In-Reply-To: <201012271505.56572.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201012271506.18101.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ismael Luceno <ismael.luceno@gmail.com>

Backtrace:
  rt2800usb_write_tx_data
  rt2x00queue_write_tx_frame
  rt2x00mac_tx
  invoke_tx_handlers
  __ieee80211_tx
  ieee80211_tx
  virt_to_head_page
  ieee80211_xmit
  ieee80211_tx_skb
  ieee80211_scan_work
  schedule
  ieee80211_scan_work
  process_one_work
  ...

It tried to expand the skb past it's end using skb_put. So I replaced it
with a call to skb_padto, which takes the issue into account.

Signed-off-by: Ismael Luceno <ismael.luceno@gmail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800usb.c |   16 ++++++++++++----
 1 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 3e0205d..b97a4a5 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -369,7 +369,10 @@ static void rt2800usb_write_tx_desc(struct queue_entry *entry,
 static void rt2800usb_write_tx_data(struct queue_entry *entry,
 					struct txentry_desc *txdesc)
 {
-	u8 padding_len;
+	unsigned int len;
+	int err;
+
+	rt2800_write_tx_data(entry, txdesc);
 
 	/*
 	 * pad(1~3 bytes) is added after each 802.11 payload.
@@ -378,9 +381,14 @@ static void rt2800usb_write_tx_data(struct queue_entry *entry,
 	 * | TXINFO | TXWI | 802.11 header | L2 pad | payload | pad | USB end pad |
 	 *                 |<------------- tx_pkt_len ------------->|
 	 */
-        rt2800_write_tx_data(entry, txdesc);
-        padding_len = roundup(entry->skb->len + 4, 4) - entry->skb->len;
-        memset(skb_put(entry->skb, padding_len), 0, padding_len);
+	len = roundup(entry->skb->len, 4) + 4;
+	err = skb_padto(entry->skb, len);
+	if (unlikely(err)) {
+		WARNING(entry->queue->rt2x00dev, "TX SKB padding error, out of memory\n");
+		return;
+	}
+
+	entry->skb->len = len;
 }
 
 /*
-- 
1.7.2.3

