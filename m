Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:47472 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758318Ab3FVOcD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Jun 2013 10:32:03 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 1/2] rt2x00: rt2800pci: don't use TXWI_DESC_SIZE directly
Date: Sat, 22 Jun 2013 16:31:58 +0200
Message-Id: <1371911519-13135-1-git-send-email-juhosg@openwrt.org> (sfid-20130622_163213_219619_A52B24D0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Different chipsets may use different TXWI descriptor
size. Instead of using a hardcoded value, use the
'queue->winfo_size' which holds the correct value for
a given device.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/rt2x00/rt2800pci.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index 7c74782..e664918 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -637,6 +637,7 @@ static void rt2800pci_write_tx_desc(struct queue_entry *entry,
 	struct queue_entry_priv_mmio *entry_priv = entry->priv_data;
 	__le32 *txd = entry_priv->desc;
 	u32 word;
+	const unsigned int txwi_size = entry->queue->winfo_size;
 
 	/*
 	 * The buffers pointed by SD_PTR0/SD_LEN0 and SD_PTR1/SD_LEN1
@@ -659,14 +660,14 @@ static void rt2800pci_write_tx_desc(struct queue_entry *entry,
 			   !test_bit(ENTRY_TXD_MORE_FRAG, &txdesc->flags));
 	rt2x00_set_field32(&word, TXD_W1_BURST,
 			   test_bit(ENTRY_TXD_BURST, &txdesc->flags));
-	rt2x00_set_field32(&word, TXD_W1_SD_LEN0, TXWI_DESC_SIZE);
+	rt2x00_set_field32(&word, TXD_W1_SD_LEN0, txwi_size);
 	rt2x00_set_field32(&word, TXD_W1_LAST_SEC0, 0);
 	rt2x00_set_field32(&word, TXD_W1_DMA_DONE, 0);
 	rt2x00_desc_write(txd, 1, word);
 
 	word = 0;
 	rt2x00_set_field32(&word, TXD_W2_SD_PTR1,
-			   skbdesc->skb_dma + TXWI_DESC_SIZE);
+			   skbdesc->skb_dma + txwi_size);
 	rt2x00_desc_write(txd, 2, word);
 
 	word = 0;
-- 
1.7.10

