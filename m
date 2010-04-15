Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f225.google.com ([209.85.218.225]:54756 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926Ab0DOHNn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Apr 2010 03:13:43 -0400
Received: by mail-bw0-f225.google.com with SMTP id 25so1091871bwz.28
        for <linux-wireless@vger.kernel.org>; Thu, 15 Apr 2010 00:13:43 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
Subject: [PATCH 2/2] rt2x00: rt2800pci: fix tx path by not accessing the skb after it was DMA mapped
Date: Thu, 15 Apr 2010 09:13:35 +0200
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	linux-wireless@vger.kernel.org
Message-Id: <201004150913.35443.helmut.schaa@googlemail.com>
Content-Type: Text/Plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rt2800pci used the callback write_tx_desc to write the tx descriptor but
also to update the txwi which is part of the dma mapped skb. Since the
memory was already DMA mapped _before_ the call to write_tx_desc the
device didn't get the txwi data at all or only sporadically.

The call order is basically as follows (from rt2x00queue.c):
1) write_tx_data
2) rt2x00queue_map_txskb
3) write_tx_desc

Hence, we shouldn't touch the skb in write_tx_desc anymore.

To fix this issue create a new rt2800pci_write_tx_data callback and use it
for updating the txwi _before_ the memory gets DMA mapped.

The tx descriptor is still written (as before) in write_tx_desc.

This patch allows basic TX on an rt305x soc device but I'm pretty sure
that it will fix pci based cards as well. I can associate just fine with
an AP now but I wasn't able to get a wpa secured connection working yet.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800pci.c |   34 ++++++++++++++++++++++++------
 1 files changed, 27 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index 2131f8f..0e52f17 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -613,15 +613,23 @@ static int rt2800pci_set_device_state(struct rt2x00_dev *rt2x00dev,
 /*
  * TX descriptor initialization
  */
-static void rt2800pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
-				    struct sk_buff *skb,
-				    struct txentry_desc *txdesc)
+static int rt2800pci_write_tx_data(struct queue_entry* entry,
+				   struct txentry_desc *txdesc)
 {
-	struct skb_frame_desc *skbdesc = get_skb_frame_desc(skb);
-	__le32 *txd = skbdesc->desc;
-	__le32 *txwi = (__le32 *)(skb->data - rt2x00dev->ops->extra_tx_headroom);
+	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
+	struct sk_buff *skb = entry->skb;
+	struct skb_frame_desc *skbdesc;
+	int ret;
+	__le32 *txwi;
 	u32 word;
 
+	ret = rt2x00pci_write_tx_data(entry, txdesc);
+	if (ret)
+		return ret;
+
+	skbdesc = get_skb_frame_desc(skb);
+	txwi = (__le32 *)(skb->data - rt2x00dev->ops->extra_tx_headroom);
+
 	/*
 	 * Initialize TX Info descriptor
 	 */
@@ -670,6 +678,18 @@ static void rt2800pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 	_rt2x00_desc_write(txwi, 2, 0 /* skbdesc->iv[0] */);
 	_rt2x00_desc_write(txwi, 3, 0 /* skbdesc->iv[1] */);
 
+	return 0;
+}
+
+
+static void rt2800pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
+				    struct sk_buff *skb,
+				    struct txentry_desc *txdesc)
+{
+	struct skb_frame_desc *skbdesc = get_skb_frame_desc(skb);
+	__le32 *txd = skbdesc->desc;
+	u32 word;
+
 	/*
 	 * The buffers pointed by SD_PTR0/SD_LEN0 and SD_PTR1/SD_LEN1
 	 * must contains a TXWI structure + 802.11 header + padding + 802.11
@@ -1135,7 +1155,7 @@ static const struct rt2x00lib_ops rt2800pci_rt2x00_ops = {
 	.reset_tuner		= rt2800_reset_tuner,
 	.link_tuner		= rt2800_link_tuner,
 	.write_tx_desc		= rt2800pci_write_tx_desc,
-	.write_tx_data		= rt2x00pci_write_tx_data,
+	.write_tx_data		= rt2800pci_write_tx_data,
 	.write_beacon		= rt2800pci_write_beacon,
 	.kick_tx_queue		= rt2800pci_kick_tx_queue,
 	.kill_tx_queue		= rt2800pci_kill_tx_queue,
-- 
1.6.4.2

