Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:46904 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752026AbZHLQ6K (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Aug 2009 12:58:10 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 12 Aug 2009 09:58:12 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>,
	<ath5k-devel@lists.ath5k.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Jiri Slaby <jirislaby@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	Bob Copeland <me@bobcopeland.com>
Subject: [PATCH] ath5k: fix requested allocated RX skb size for DMA
Date: Wed, 12 Aug 2009 09:58:10 -0700
Message-ID: <1250096290-11058-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When we dev_alloc_skb() our RX buffers we were asking
for them to be of size:

sc->rxbufsize + sc->common.cachelsz - 1

but when mapping processor virtual memeory for access by the
hardware we were only giving it the sc->rxbufsize, therefore
always preventing the device from accessing the fully allocated
skb.

This patch fixes the disparity. It is unclear to me if there are
other consequences to having this mismatch other than perhaps never
allowing the device to use the full capacity of the allocated skb.

Cc: Jiri Slaby <jirislaby@gmail.com>
Cc: Nick Kossifidis <mickflemm@gmail.com>
Cc: Bob Copeland <me@bobcopeland.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath5k/base.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 2b3cf39..75843f2 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -1157,17 +1157,18 @@ struct sk_buff *ath5k_rx_skb_alloc(struct ath5k_softc *sc, dma_addr_t *skb_addr)
 	 * fake physical layer header at the start.
 	 */
 	skb = ath_rxbuf_alloc(&sc->common,
-			      sc->rxbufsize + sc->common.cachelsz - 1,
+			      sc->rxbufsize,
 			      GFP_ATOMIC);
 
 	if (!skb) {
 		ATH5K_ERR(sc, "can't alloc skbuff of size %u\n",
-				sc->rxbufsize + sc->common.cachelsz - 1);
+				sc->rxbufsize);
 		return NULL;
 	}
 
 	*skb_addr = pci_map_single(sc->pdev,
 		skb->data, sc->rxbufsize, PCI_DMA_FROMDEVICE);
+
 	if (unlikely(pci_dma_mapping_error(sc->pdev, *skb_addr))) {
 		ATH5K_ERR(sc, "%s: DMA mapping failed\n", __func__);
 		dev_kfree_skb(skb);
@@ -1607,9 +1608,10 @@ ath5k_rx_start(struct ath5k_softc *sc)
 	int ret;
 
 	sc->rxbufsize = roundup(IEEE80211_MAX_LEN, sc->common.cachelsz);
+	sc->rxbufsize += sc->common.cachelsz - 1;
 
 	ATH5K_DBG(sc, ATH5K_DEBUG_RESET, "cachelsz %u rxbufsize %u\n",
-		sc->common.cachelsz, sc->rxbufsize);
+		  sc->common.cachelsz, sc->rxbufsize);
 
 	spin_lock_bh(&sc->rxbuflock);
 	sc->rxlink = NULL;
-- 
1.6.3.3

