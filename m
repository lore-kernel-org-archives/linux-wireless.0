Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:39060 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755850Ab1IGSLs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Sep 2011 14:11:48 -0400
Received: by mail-ew0-f46.google.com with SMTP id 4so274569ewy.19
        for <linux-wireless@vger.kernel.org>; Wed, 07 Sep 2011 11:11:48 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 5/5] rt2x00: Avoid unnecessary uncached
Date: Wed, 7 Sep 2011 20:11:26 +0200
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
References: <201109072010.04023.IvDoorn@gmail.com> <201109072010.45905.IvDoorn@gmail.com> <201109072011.04627.IvDoorn@gmail.com>
In-Reply-To: <201109072011.04627.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201109072011.27532.IvDoorn@gmail.com> (sfid-20110907_201151_462080_8733E3D4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Helmut Schaa <helmut.schaa@googlemail.com>

Reading the TX desciptor words from coherent memory is always uncached
and potentially slow. Hence, don't read the TX descriptor prior to
writing it since we update all fields anyway.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---

 drivers/net/wireless/rt2x00/rt2800pci.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index 2633628..e0493fb 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -619,11 +619,11 @@ static void rt2800pci_write_tx_desc(struct queue_entry *entry,
 	/*
 	 * Initialize TX descriptor
 	 */
-	rt2x00_desc_read(txd, 0, &word);
+	word = 0;
 	rt2x00_set_field32(&word, TXD_W0_SD_PTR0, skbdesc->skb_dma);
 	rt2x00_desc_write(txd, 0, word);
 
-	rt2x00_desc_read(txd, 1, &word);
+	word = 0;
 	rt2x00_set_field32(&word, TXD_W1_SD_LEN1, entry->skb->len);
 	rt2x00_set_field32(&word, TXD_W1_LAST_SEC1,
 			   !test_bit(ENTRY_TXD_MORE_FRAG, &txdesc->flags));
@@ -634,12 +634,12 @@ static void rt2800pci_write_tx_desc(struct queue_entry *entry,
 	rt2x00_set_field32(&word, TXD_W1_DMA_DONE, 0);
 	rt2x00_desc_write(txd, 1, word);
 
-	rt2x00_desc_read(txd, 2, &word);
+	word = 0;
 	rt2x00_set_field32(&word, TXD_W2_SD_PTR1,
 			   skbdesc->skb_dma + TXWI_DESC_SIZE);
 	rt2x00_desc_write(txd, 2, word);
 
-	rt2x00_desc_read(txd, 3, &word);
+	word = 0;
 	rt2x00_set_field32(&word, TXD_W3_WIV,
 			   !test_bit(ENTRY_TXD_ENCRYPT_IV, &txdesc->flags));
 	rt2x00_set_field32(&word, TXD_W3_QSEL, 2);
-- 
1.7.3.4
