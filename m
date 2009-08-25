Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:50669 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754792AbZHYJ56 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Aug 2009 05:57:58 -0400
Subject: [PATCH] PRISM54: fix compilation warning
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 25 Aug 2009 15:28:45 +0530
Message-Id: <1251194335.2399.19.camel@Fedora32.jaswinder>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


 CC [M]  drivers/net/wireless/prism54/islpci_eth.o
drivers/net/wireless/prism54/islpci_eth.c: In function ‘islpci_eth_cleanup_transmit’:
drivers/net/wireless/prism54/islpci_eth.c:53: warning: cast from pointer to integer of different size
drivers/net/wireless/prism54/islpci_eth.c: In function ‘islpci_eth_receive’:
drivers/net/wireless/prism54/islpci_eth.c:453: warning: cast from pointer to integer of different size

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 drivers/net/wireless/prism54/islpci_eth.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/prism54/islpci_eth.c b/drivers/net/wireless/prism54/islpci_eth.c
index 8f62109..80a9a9c 100644
--- a/drivers/net/wireless/prism54/islpci_eth.c
+++ b/drivers/net/wireless/prism54/islpci_eth.c
@@ -50,7 +50,7 @@ islpci_eth_cleanup_transmit(islpci_private *priv,
 
 		/* check for holes in the arrays caused by multi fragment frames
 		 * searching for the last fragment of a frame */
-		if (priv->pci_map_tx_address[index] != (dma_addr_t) NULL) {
+		if (priv->pci_map_tx_address[index]) {
 			/* entry is the last fragment of a frame
 			 * free the skb structure and unmap pci memory */
 			skb = priv->data_low_tx[index];
@@ -450,7 +450,7 @@ islpci_eth_receive(islpci_private *priv)
 		    pci_map_single(priv->pdev, (void *) skb->data,
 				   MAX_FRAGMENT_SIZE_RX + 2,
 				   PCI_DMA_FROMDEVICE);
-		if (unlikely(priv->pci_map_rx_address[index] == (dma_addr_t) NULL)) {
+		if (unlikely(!priv->pci_map_rx_address[index])) {
 			/* error mapping the buffer to device accessable memory address */
 			DEBUG(SHOW_ERROR_MESSAGES,
 			      "Error mapping DMA address\n");
-- 
1.6.2.5



