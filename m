Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:11978 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752865AbYKTGOn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Nov 2008 01:14:43 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 19 Nov 2008 22:14:43 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <johannes@sipsolutions.net>,
	<linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<ath9k-devel@lists.ath9k.org>, <zenczykowski@gmail.com>,
	<Bennyam.Malavazi@atheros.com>,
	Maciej Zenczykowski <zenczykowski@gmail.com>
Subject: [RFC 1/2] ath9k: Fix SW-IOMMU bounce buffer starvation
Date: Wed, 19 Nov 2008 22:14:39 -0800
Message-ID: <1227161680-23229-2-git-send-email-lrodriguez@atheros.com> (sfid-20081120_071455_339869_1122BE6E)
In-Reply-To: <1227161680-23229-1-git-send-email-lrodriguez@atheros.com>
References: <1227161680-23229-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This should fix the SW-IOMMU bounce buffer starvation
seen ok kernel.org bugzilla 11811:

http://bugzilla.kernel.org/show_bug.cgi?id=11811

Users on MacBook Pro 3.1 would see something like:

DMA: Out of SW-IOMMU space for 4224 bytes at device 0000:0b:00.0

It is expected you will see a panic now, but that is
a separate issue, we are working on trying to resolve
that as well. Unfortunately its only easy to trigger on
MacBook Pro 3.1s so its difficult to debug (even with
swiotlb=force).

We were pci_unmap_single()'ing less bytes than what we called
for with pci_map_single() and as such we were starving
the swiotlb from its 64MB amount of bounce buffers. We remain
consistent and now always use sc->rxbufsize for RX. While at
it we update the beacon DMA maps as well to only use the data
portion of the skb.

Still not sure why this is so easily triggerable on
MacBook Pro 3.1, it may be the hardware configuration
tends to use more memory > 3GB mark for DMA.

An existing theory on the side effect of partition corruption
is an existing bug with the swiotlb when handing out the
emergency buffer therefore allowing devices to compete against
it. If this is true (needs more review) this should also affect
any other device causing SW-IOTLB bounce buffer starvation.
Check the bug report for details.

Signed-off-by: Maciej Zenczykowski <zenczykowski@gmail.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath9k/beacon.c |   10 +++++-----
 drivers/net/wireless/ath9k/recv.c   |    6 +++---
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath9k/beacon.c b/drivers/net/wireless/ath9k/beacon.c
index dcf2383..f5f80b6 100644
--- a/drivers/net/wireless/ath9k/beacon.c
+++ b/drivers/net/wireless/ath9k/beacon.c
@@ -172,7 +172,7 @@ static struct ath_buf *ath_beacon_generate(struct ath_softc *sc, int if_id)
 	skb = (struct sk_buff *)bf->bf_mpdu;
 	if (skb) {
 		pci_unmap_single(sc->pdev, bf->bf_dmacontext,
-				 skb_end_pointer(skb) - skb->head,
+				 skb_end_pointer(skb) - skb->data,
 				 PCI_DMA_TODEVICE);
 	}
 
@@ -195,7 +195,7 @@ static struct ath_buf *ath_beacon_generate(struct ath_softc *sc, int if_id)
 
 	bf->bf_buf_addr = bf->bf_dmacontext =
 		pci_map_single(sc->pdev, skb->data,
-			       skb_end_pointer(skb) - skb->head,
+			       skb_end_pointer(skb) - skb->data,
 			       PCI_DMA_TODEVICE);
 
 	skb = ieee80211_get_buffered_bc(sc->hw, vif);
@@ -360,7 +360,7 @@ int ath_beacon_alloc(struct ath_softc *sc, int if_id)
 	if (bf->bf_mpdu != NULL) {
 		skb = (struct sk_buff *)bf->bf_mpdu;
 		pci_unmap_single(sc->pdev, bf->bf_dmacontext,
-				 skb_end_pointer(skb) - skb->head,
+				 skb_end_pointer(skb) - skb->data,
 				 PCI_DMA_TODEVICE);
 		dev_kfree_skb_any(skb);
 		bf->bf_mpdu = NULL;
@@ -420,7 +420,7 @@ int ath_beacon_alloc(struct ath_softc *sc, int if_id)
 
 	bf->bf_buf_addr = bf->bf_dmacontext =
 		pci_map_single(sc->pdev, skb->data,
-			       skb_end_pointer(skb) - skb->head,
+			       skb_end_pointer(skb) - skb->data,
 			       PCI_DMA_TODEVICE);
 	bf->bf_mpdu = skb;
 
@@ -447,7 +447,7 @@ void ath_beacon_return(struct ath_softc *sc, struct ath_vap *avp)
 		if (bf->bf_mpdu != NULL) {
 			struct sk_buff *skb = (struct sk_buff *)bf->bf_mpdu;
 			pci_unmap_single(sc->pdev, bf->bf_dmacontext,
-					 skb_end_pointer(skb) - skb->head,
+					 skb_end_pointer(skb) - skb->data,
 					 PCI_DMA_TODEVICE);
 			dev_kfree_skb_any(skb);
 			bf->bf_mpdu = NULL;
diff --git a/drivers/net/wireless/ath9k/recv.c b/drivers/net/wireless/ath9k/recv.c
index 20f8377..4355c16 100644
--- a/drivers/net/wireless/ath9k/recv.c
+++ b/drivers/net/wireless/ath9k/recv.c
@@ -92,7 +92,7 @@ static void ath_rx_requeue(struct ath_softc *sc, struct ath_buf *bf)
 		if (skb != NULL) {
 			bf->bf_mpdu = skb;
 			bf->bf_buf_addr = pci_map_single(sc->pdev, skb->data,
-						 skb_end_pointer(skb) - skb->head,
+						 sc->sc_rxbufsize,
 						 PCI_DMA_FROMDEVICE);
 			bf->bf_dmacontext = bf->bf_buf_addr;
 
@@ -299,7 +299,7 @@ int ath_rx_init(struct ath_softc *sc, int nbufs)
 
 			bf->bf_mpdu = skb;
 			bf->bf_buf_addr = pci_map_single(sc->pdev, skb->data,
-					 skb_end_pointer(skb) - skb->head,
+					 sc->sc_rxbufsize,
 					 PCI_DMA_FROMDEVICE);
 			bf->bf_dmacontext = bf->bf_buf_addr;
 		}
@@ -536,7 +536,7 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush)
 
 		/* Sync and unmap the frame */
 		pci_dma_sync_single_for_cpu(sc->pdev, bf->bf_buf_addr,
-					    skb_tailroom(skb),
+					    sc->sc_rxbufsize,
 					    PCI_DMA_FROMDEVICE);
 		pci_unmap_single(sc->pdev, bf->bf_buf_addr,
 				 sc->sc_rxbufsize,
-- 
1.5.6.rc2.15.g457bb.dirty

