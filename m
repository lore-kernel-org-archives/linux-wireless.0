Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:1773 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754287Ab0EMJhE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 May 2010 05:37:04 -0400
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Ivo van Doorn <IvDoorn@gmail.com>,
	<linux-wireless@vger.kernel.org>, <users@rt2x00.serialmonkey.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: [PATCH v2 05/10] rt2x00: Fix beacon descriptor writing for rt61pci.
Date: Thu, 13 May 2010 11:36:53 +0200
Message-Id: <1273743418-28383-6-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1273743418-28383-1-git-send-email-gwingerde@gmail.com>
References: <1273743418-28383-1-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The buffer address descriptor word is not part of the TXINFO structure
needed for beacons. The current writing of that word for beacons is
therefore an out-of-bounds write.
Fix this by only writing the buffer address descriptor word for TX
queues.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt61pci.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 2436363..99c2981 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -1801,12 +1801,12 @@ static void rt61pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 	rt2x00_set_field32(&word, TXD_W5_WAITING_DMA_DONE_INT, 1);
 	rt2x00_desc_write(txd, 5, word);
 
-	rt2x00_desc_read(txd, 6, &word);
-	rt2x00_set_field32(&word, TXD_W6_BUFFER_PHYSICAL_ADDRESS,
-			   skbdesc->skb_dma);
-	rt2x00_desc_write(txd, 6, word);
+	if (txdesc->queue != QID_BEACON) {
+		rt2x00_desc_read(txd, 6, &word);
+		rt2x00_set_field32(&word, TXD_W6_BUFFER_PHYSICAL_ADDRESS,
+				   skbdesc->skb_dma);
+		rt2x00_desc_write(txd, 6, word);
 
-	if (skbdesc->desc_len > TXINFO_SIZE) {
 		rt2x00_desc_read(txd, 11, &word);
 		rt2x00_set_field32(&word, TXD_W11_BUFFER_LENGTH0,
 				   txdesc->length);
-- 
1.7.1

