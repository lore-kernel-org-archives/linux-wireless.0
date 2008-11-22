Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:60509 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754307AbYKVBlg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Nov 2008 20:41:36 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 21 Nov 2008 17:41:35 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <linville@tuxdriver.com>,
	<zenczykowski@gmail.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH] ath9k: Handle -ENOMEM on RX gracefully
Date: Fri, 21 Nov 2008 17:41:33 -0800
Message-ID: <1227318093-14825-1-git-send-email-lrodriguez@atheros.com> (sfid-20081122_024138_754815_4429C95B)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We would get an oops on RX on -ENOMEM by passing
NULL to the hardware on ath_rx_buf_link(). The oops
would look something like this:

ath_rx_tasklet+0x515/0x53b
ath9k_tasklet+0x48
tasklet_action
__do_softirq
irq_exit
do_IRQ

RIP: ath_rx_buf_link+0x3a

We correct this by handling the requeue directly on
the ath_rx_tasklet() and trying to allocate an skb
*prior* to sending up the last hardware processed
skb. If we run out of memory this gauranteees we have
skbs to work with while it simply drops new received
frames.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath9k/recv.c |   57 +++++++++++++++++--------------------
 1 files changed, 26 insertions(+), 31 deletions(-)

diff --git a/drivers/net/wireless/ath9k/recv.c b/drivers/net/wireless/ath9k/recv.c
index 0cd2a91..01f37e8 100644
--- a/drivers/net/wireless/ath9k/recv.c
+++ b/drivers/net/wireless/ath9k/recv.c
@@ -90,29 +90,6 @@ static struct sk_buff *ath_rxbuf_alloc(struct ath_softc *sc, u32 len)
 	return skb;
 }
 
-static void ath_rx_requeue(struct ath_softc *sc, struct ath_buf *bf)
-{
-	struct sk_buff *skb;
-
-	ASSERT(bf != NULL);
-
-	if (bf->bf_mpdu == NULL) {
-		skb = ath_rxbuf_alloc(sc, sc->sc_rxbufsize);
-		if (skb != NULL) {
-			bf->bf_mpdu = skb;
-			bf->bf_buf_addr = pci_map_single(sc->pdev, skb->data,
-						 sc->sc_rxbufsize,
-						 PCI_DMA_FROMDEVICE);
-			bf->bf_dmacontext = bf->bf_buf_addr;
-
-		}
-	}
-
-	list_move_tail(&bf->list, &sc->sc_rxbuf);
-	ath_rx_buf_link(sc, bf);
-}
-
-
 static int ath_rate2idx(struct ath_softc *sc, int rate)
 {
 	int i = 0, cur_band, n_rates;
@@ -454,7 +431,7 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush)
 
 	struct ath_buf *bf;
 	struct ath_desc *ds;
-	struct sk_buff *skb = NULL;
+	struct sk_buff *skb = NULL, *requeue_skb;
 	struct ieee80211_rx_status rx_status;
 	struct ath_hal *ah = sc->sc_ah;
 	struct ieee80211_hdr *hdr;
@@ -531,17 +508,28 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush)
 		 * chain it back at the queue without processing it.
 		 */
 		if (flush)
-			goto rx_next;
+			goto requeue;
 
 		if (!ds->ds_rxstat.rs_datalen)
-			goto rx_next;
+			goto requeue;
 
 		/* The status portion of the descriptor could get corrupted. */
 		if (sc->sc_rxbufsize < ds->ds_rxstat.rs_datalen)
-			goto rx_next;
+			goto requeue;
 
 		if (!ath_rx_prepare(skb, ds, &rx_status, &decrypt_error, sc))
-			goto rx_next;
+			goto requeue;
+
+		/* Ensure we always have an skb to requeue once we are done
+		 * processing the current buffer's skb */
+		requeue_skb = ath_rxbuf_alloc(sc, sc->sc_rxbufsize);
+
+		/* If there is no memory we ignore the current RX'd frame,
+		 * tell hardware it can give us a new frame using the old
+		 * skb and put it at the tail of the sc->sc_rxbuf list for
+		 * processing. */
+		if (!requeue_skb)
+			goto requeue;
 
 		/* Sync and unmap the frame */
 		pci_dma_sync_single_for_cpu(sc->pdev, bf->bf_buf_addr,
@@ -578,7 +566,13 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush)
 
 		/* Send the frame to mac80211 */
 		__ieee80211_rx(sc->hw, skb, &rx_status);
-		bf->bf_mpdu = NULL;
+
+		/* We will now give hardware our shiny new allocated skb */
+		bf->bf_mpdu = requeue_skb;
+		bf->bf_buf_addr = pci_map_single(sc->pdev, requeue_skb->data,
+					 sc->sc_rxbufsize,
+					 PCI_DMA_FROMDEVICE);
+		bf->bf_dmacontext = bf->bf_buf_addr;
 
 		/*
 		 * change the default rx antenna if rx diversity chooses the
@@ -590,8 +584,9 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush)
 		} else {
 			sc->sc_rxotherant = 0;
 		}
-rx_next:
-		ath_rx_requeue(sc, bf);
+requeue:
+		list_move_tail(&bf->list, &sc->sc_rxbuf);
+		ath_rx_buf_link(sc, bf);
 	} while (1);
 
 	spin_unlock_bh(&sc->sc_rxbuflock);
-- 
1.5.6.rc2.15.g457bb.dirty

