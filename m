Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:52031 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752110Ab2JBTAf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Oct 2012 15:00:35 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Arend van Spriel <arend@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [RFC] brcmsmac: check return from dma_map_single
Date: Tue,  2 Oct 2012 14:46:25 -0400
Message-Id: <1349203585-16095-1-git-send-email-linville@tuxdriver.com> (sfid-20121002_210113_777189_02CCEFB2)
In-Reply-To: <y>
References: <y>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>

dma_map_single can fail, so it's return value needs to be checked and
handled accordingly.  Failure to do so is akin to failing to check the
return from a kmalloc.

http://linuxdriverproject.org/mediawiki/index.php/DMA_Mapping_Error_Analysis

Signed-off-by: John W. Linville <linville@tuxdriver.com>
Cc: Arend van Spriel <arend@broadcom.com>
---
I'm not too sure about the bail-out in dma_rxfill.  Perhaps the experts
can suggest something better?

 drivers/net/wireless/brcm80211/brcmsmac/dma.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/dma.c b/drivers/net/wireless/brcm80211/brcmsmac/dma.c
index 5e53305..fa24c58 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/dma.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/dma.c
@@ -1079,6 +1079,10 @@ bool dma_rxfill(struct dma_pub *pub)
 
 		pa = dma_map_single(di->dmadev, p->data, di->rxbufsize,
 				    DMA_FROM_DEVICE);
+		if (dma_mapping_error(di->dmadev, pa)) {
+			brcmu_pkt_buf_free_skb(p);
+			break;
+		}
 
 		/* save the free packet pointer */
 		di->rxp[rxout] = p;
@@ -1293,13 +1297,15 @@ int dma_txfast(struct dma_pub *pub, struct sk_buff *p, bool commit)
 	if (len == 0)
 		return 0;
 
+	/* get physical address of buffer start */
+	pa = dma_map_single(di->dmadev, data, len, DMA_TO_DEVICE);
+	if (dma_mapping_error(di->dmadev, pa))
+		return -1;
+
 	/* return nonzero if out of tx descriptors */
 	if (nexttxd(di, txout) == di->txin)
 		goto outoftxd;
 
-	/* get physical address of buffer start */
-	pa = dma_map_single(di->dmadev, data, len, DMA_TO_DEVICE);
-
 	/* With a DMA segment list, Descriptor table is filled
 	 * using the segment list instead of looping over
 	 * buffers in multi-chain DMA. Therefore, EOF for SGLIST
-- 
1.7.11.4

