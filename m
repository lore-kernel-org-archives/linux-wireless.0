Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:38421 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755801Ab0F2TvD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jun 2010 15:51:03 -0400
Received: by mail-wy0-f174.google.com with SMTP id 38so2999627wyb.19
        for <linux-wireless@vger.kernel.org>; Tue, 29 Jun 2010 12:51:03 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 09/21] rt2x00: Split of TXWI writing to write_tx_data callback in rt2800usb.
Date: Tue, 29 Jun 2010 21:43:03 +0200
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
References: <201006292138.13509.IvDoorn@gmail.com> <201006292141.41708.IvDoorn@gmail.com> <201006292142.24144.IvDoorn@gmail.com>
In-Reply-To: <201006292142.24144.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201006292143.04173.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gertjan van Wingerde <gwingerde@gmail.com>

Align with the way PCI devices are handled, even though it is not
strictly necessary.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800pci.c |    4 +++-
 drivers/net/wireless/rt2x00/rt2800usb.c |   16 ++++++++++------
 2 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index 7bec15f..0af53bd 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -648,7 +648,9 @@ static int rt2800pci_set_device_state(struct rt2x00_dev *rt2x00dev,
 static void rt2800pci_write_tx_data(struct queue_entry* entry,
 				    struct txentry_desc *txdesc)
 {
-	rt2800_write_txwi((__le32 *) entry->skb->data, txdesc);
+	__le32 *txwi = (__le32 *) entry->skb->data;
+
+	rt2800_write_txwi(txwi, txdesc);
 }
 
 
diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 6d4de60..4f85f7b 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -430,21 +430,24 @@ static int rt2800usb_set_device_state(struct rt2x00_dev *rt2x00dev,
 /*
  * TX descriptor initialization
  */
+static void rt2800usb_write_tx_data(struct queue_entry* entry,
+				    struct txentry_desc *txdesc)
+{
+	__le32 *txwi = (__le32 *) (entry->skb->data + TXINFO_DESC_SIZE);
+
+	rt2800_write_txwi(txwi, txdesc);
+}
+
+
 static void rt2800usb_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 				    struct sk_buff *skb,
 				    struct txentry_desc *txdesc)
 {
 	struct skb_frame_desc *skbdesc = get_skb_frame_desc(skb);
 	__le32 *txi = (__le32 *) skb->data;
-	__le32 *txwi = (__le32 *) (skb->data + TXINFO_DESC_SIZE);
 	u32 word;
 
 	/*
-	 * Initialize TXWI descriptor
-	 */
-	rt2800_write_txwi(txwi, txdesc);
-
-	/*
 	 * Initialize TXINFO descriptor
 	 */
 	rt2x00_desc_read(txi, 0, &word);
@@ -652,6 +655,7 @@ static const struct rt2x00lib_ops rt2800usb_rt2x00_ops = {
 	.reset_tuner		= rt2800_reset_tuner,
 	.link_tuner		= rt2800_link_tuner,
 	.write_tx_desc		= rt2800usb_write_tx_desc,
+	.write_tx_data		= rt2800usb_write_tx_data,
 	.write_beacon		= rt2800_write_beacon,
 	.get_tx_data_len	= rt2800usb_get_tx_data_len,
 	.kick_tx_queue		= rt2x00usb_kick_tx_queue,
-- 
1.6.6.1

