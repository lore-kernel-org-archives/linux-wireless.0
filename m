Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f42.google.com ([74.125.83.42]:52336 "EHLO
	mail-gw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933512Ab0LUCqS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Dec 2010 21:46:18 -0500
Received: by gwb20 with SMTP id 20so2493842gwb.1
        for <linux-wireless@vger.kernel.org>; Mon, 20 Dec 2010 18:46:17 -0800 (PST)
From: Ismael Luceno <ismael.luceno@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Ivo Van Doorn <ivdoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Ismael Luceno <ismael.luceno@gmail.com>
Subject: [PATCH v2] rt2x00: Fix panic on frame padding for rt2800 usb devices
Date: Tue, 21 Dec 2010 00:41:51 -0200
Message-Id: <1292899311-20768-1-git-send-email-ismael.luceno@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

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
1.7.3.4

