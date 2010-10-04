Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39435 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756207Ab0JDUzM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Oct 2010 16:55:12 -0400
Received: by bwz11 with SMTP id 11so3997069bwz.19
        for <linux-wireless@vger.kernel.org>; Mon, 04 Oct 2010 13:55:11 -0700 (PDT)
Date: Mon, 4 Oct 2010 22:55:08 +0200 (CEST)
From: "=?ISO-8859-15?Q?Bj=F6rn_Smedman?=" <bjorn.smedman@venatech.se>
To: linux-wireless <linux-wireless@vger.kernel.org>,
	ath9k-devel@lists.ath9k.org
Subject: [RFC] ath9k: Insert wmb before linking dma descriptors
Message-ID: <alpine.DEB.2.00.1010042059130.29449@vtdt3>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-547367930-1286225710=:29449"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-547367930-1286225710=:29449
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT

Hi all,

I've been looking at how ath9k does DMA and comparing with the
recommendations in the Linux kernel documentation for the DMA API[1]. To
me it looks like we risk setting up incorrect DMA descriptors on
platforms that can reorder writes because all data in the descriptor may
not be written to memory before the descriptor is linked into the DMA
chain.

The patch below attempts to remove this risk by inserting a write memory
barrier between where we set up a descriptor and where we add it to the 
DMA chain. My hope is that this may solve some of the harder chip lockups 
on MIPS but more testing is required to determine if it has this effect.

Any thoughts?

/Björn

1. http://www.mjmwired.net/kernel/Documentation/DMA-API.txt

---
diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index 081192e..8e43443 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -450,6 +450,8 @@ void ath_beacon_tasklet(unsigned long data)
 				"beacon queue %u did not stop?\n", sc->beacon.beaconq);
 		}
 
+		wmb();
+
 		/* NB: cabq traffic should already be queued and primed */
 		ath9k_hw_puttxbuf(ah, sc->beacon.beaconq, bfaddr);
 		ath9k_hw_txstart(ah, sc->beacon.beaconq);
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 9c166f3..2cc0271 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -90,6 +90,8 @@ static void ath_rx_buf_link(struct ath_softc *sc, struct ath_buf *bf)
 			     common->rx_bufsize,
 			     0);
 
+	wmb();
+
 	if (sc->rx.rxlink == NULL)
 		ath9k_hw_putrxbuf(ah, bf->bf_daddr);
 	else
@@ -500,6 +502,9 @@ int ath_startrecv(struct ath_softc *sc)
 		goto start_recv;
 
 	bf = list_first_entry(&sc->rx.rxbuf, struct ath_buf, list);
+
+	wmb();
+
 	ath9k_hw_putrxbuf(ah, bf->bf_daddr);
 	ath9k_hw_rxena(ah);
 
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index f7da6b2..4b8c428 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1250,6 +1250,8 @@ static void ath_tx_txqaddbuf(struct ath_softc *sc, struct ath_txq *txq,
 	ath_print(common, ATH_DBG_QUEUE,
 		  "qnum: %d, txq depth: %d\n", txq->axq_qnum, txq->axq_depth);
 
+	wmb();
+
 	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_EDMA) {
 		if (txq->axq_depth >= ATH_TXFIFO_DEPTH) {
 			list_splice_tail_init(head, &txq->txq_fifo_pending);
--8323329-547367930-1286225710=:29449--
