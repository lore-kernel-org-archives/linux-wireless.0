Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:34995 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757052Ab0KMSOV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Nov 2010 13:14:21 -0500
Received: by mail-ew0-f46.google.com with SMTP id 8so221945ewy.19
        for <linux-wireless@vger.kernel.org>; Sat, 13 Nov 2010 10:14:20 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 7/9] rt2x00: Fix rt2800 USB TX Path DMA issue
Date: Sat, 13 Nov 2010 19:11:46 +0100
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201011131908.15595.IvDoorn@gmail.com> <201011131910.55175.IvDoorn@gmail.com> <201011131911.22874.IvDoorn@gmail.com>
In-Reply-To: <201011131911.22874.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201011131911.47346.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: RA-Jay Hung <Jay_Hung@ralinktech.com>

rt2800usb chips need to add 1~3 bytes zero padding after each 802.11 header & payload,
and at the end need to add 4 bytes zero padding whether doing TX bulk aggregation or not,

TXINFO_W0_USB_DMA_TX_PKT_LEN in TXINFO must include 1-3 bytes padding after 802.11 header & payload
but do not include 4 bytes end zero padding.

In rt2800usb_get_tx_data_len do not consider multiple of the USB packet size case, sometimes this will
cause USB DMA problem.

Signed-off-by: RA-Jay Hung <jay_hung@ralinktech.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800usb.c |   39 ++++++++++++++++++++----------
 1 files changed, 26 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 2933bf1..935b76d 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -307,8 +307,14 @@ static void rt2800usb_write_tx_desc(struct queue_entry *entry,
 	 * Initialize TXINFO descriptor
 	 */
 	rt2x00_desc_read(txi, 0, &word);
+
+	/*
+	 * The size of TXINFO_W0_USB_DMA_TX_PKT_LEN is
+	 * TXWI + 802.11 header + L2 pad + payload + pad,
+	 * so need to decrease size of TXINFO and USB end pad.
+	 */
 	rt2x00_set_field32(&word, TXINFO_W0_USB_DMA_TX_PKT_LEN,
-			   entry->skb->len - TXINFO_DESC_SIZE);
+			   entry->skb->len - TXINFO_DESC_SIZE - 4);
 	rt2x00_set_field32(&word, TXINFO_W0_WIV,
 			   !test_bit(ENTRY_TXD_ENCRYPT_IV, &txdesc->flags));
 	rt2x00_set_field32(&word, TXINFO_W0_QSEL, 2);
@@ -326,22 +332,29 @@ static void rt2800usb_write_tx_desc(struct queue_entry *entry,
 	skbdesc->desc_len = TXINFO_DESC_SIZE + TXWI_DESC_SIZE;
 }
 
-/*
- * TX data initialization
- */
-static int rt2800usb_get_tx_data_len(struct queue_entry *entry)
+static void rt2800usb_write_tx_data(struct queue_entry *entry,
+					struct txentry_desc *txdesc)
 {
-	int length;
+	u8 padding_len;
 
 	/*
-	 * The length _must_ include 4 bytes padding,
-	 * it should always be multiple of 4,
-	 * but it must _not_ be a multiple of the USB packet size.
+	 * pad(1~3 bytes) is added after each 802.11 payload.
+	 * USB end pad(4 bytes) is added at each USB bulk out packet end.
+	 * TX frame format is :
+	 * | TXINFO | TXWI | 802.11 header | L2 pad | payload | pad | USB end pad |
+	 *                 |<------------- tx_pkt_len ------------->|
 	 */
-	length = roundup(entry->skb->len + 4, 4);
-	length += (4 * !(length % entry->queue->usb_maxpacket));
+        rt2800_write_tx_data(entry, txdesc);
+        padding_len = roundup(entry->skb->len + 4, 4) - entry->skb->len;
+        memset(skb_put(entry->skb, padding_len), 0, padding_len);
+}
 
-	return length;
+/*
+ * TX data initialization
+ */
+static int rt2800usb_get_tx_data_len(struct queue_entry *entry)
+{
+	return entry->skb->len;
 }
 
 /*
@@ -579,7 +592,7 @@ static const struct rt2x00lib_ops rt2800usb_rt2x00_ops = {
 	.link_tuner		= rt2800_link_tuner,
 	.watchdog		= rt2800usb_watchdog,
 	.write_tx_desc		= rt2800usb_write_tx_desc,
-	.write_tx_data		= rt2800_write_tx_data,
+	.write_tx_data		= rt2800usb_write_tx_data,
 	.write_beacon		= rt2800_write_beacon,
 	.get_tx_data_len	= rt2800usb_get_tx_data_len,
 	.kick_tx_queue		= rt2x00usb_kick_tx_queue,
-- 
1.7.2.3

