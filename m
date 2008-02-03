Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.189]:42008 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763226AbYBCOvk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Feb 2008 09:51:40 -0500
Received: by fk-out-0910.google.com with SMTP id z23so1586229fkz.5
        for <linux-wireless@vger.kernel.org>; Sun, 03 Feb 2008 06:51:39 -0800 (PST)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 03/19] rt2x00: don't write past the end when writing short descriptors on rt61
Date: Sun, 3 Feb 2008 15:46:24 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200802031541.52167.IvDoorn@gmail.com>
In-Reply-To: <200802031541.52167.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200802031546.24492.IvDoorn@gmail.com> (sfid-20080203_145143_117255_E7A89778)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Adam Baker <linux@baker-net.org.uk>

The space allocated in the skb for a descriptor is only 24 bytes when
setting up beacons in rt61 so make sure we don't write to the descriptor
words beyond that and corrupt the beacon packet.

Signed-off-by: Adam Baker <linux@baker-net.org.uk>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt61pci.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index b543801..fc5acdf 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -1528,9 +1528,11 @@ static void rt61pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 	rt2x00_set_field32(&word, TXD_W5_WAITING_DMA_DONE_INT, 1);
 	rt2x00_desc_write(txd, 5, word);
 
-	rt2x00_desc_read(txd, 11, &word);
-	rt2x00_set_field32(&word, TXD_W11_BUFFER_LENGTH0, skbdesc->data_len);
-	rt2x00_desc_write(txd, 11, word);
+	if (skbdesc->desc_len > TXINFO_SIZE) {
+		rt2x00_desc_read(txd, 11, &word);
+		rt2x00_set_field32(&word, TXD_W11_BUFFER_LENGTH0, skbdesc->data_len);
+		rt2x00_desc_write(txd, 11, word);
+	}
 
 	rt2x00_desc_read(txd, 0, &word);
 	rt2x00_set_field32(&word, TXD_W0_OWNER_NIC, 1);
-- 
1.5.3.8

