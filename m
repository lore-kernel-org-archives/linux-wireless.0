Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:28569 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751061AbYKRDng (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Nov 2008 22:43:36 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 17 Nov 2008 19:43:36 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18722.14650.25185.366812@gargle.gargle.HOWL> (sfid-20081118_044338_479284_6595EEC1)
Date: Tue, 18 Nov 2008 09:10:42 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 18/18] ath9k: Use straightforward PCI routines to setup the TX buffer.
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/xmit.c |   23 +++++++----------------
 1 files changed, 7 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/ath9k/xmit.c b/drivers/net/wireless/ath9k/xmit.c
index 4c9a03e..50d4105 100644
--- a/drivers/net/wireless/ath9k/xmit.c
+++ b/drivers/net/wireless/ath9k/xmit.c
@@ -1646,7 +1646,7 @@ static void ath_txq_drain_pending_buffers(struct ath_softc *sc,
 }
 
 static void ath_tx_setup_buffer(struct ath_softc *sc, struct ath_buf *bf,
-				struct sk_buff *skb, struct scatterlist *sg,
+				struct sk_buff *skb,
 				struct ath_tx_control *txctl)
 {
 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
@@ -1711,7 +1711,6 @@ static void ath_tx_setup_buffer(struct ath_softc *sc, struct ath_buf *bf,
 
 /* FIXME: tx power */
 static void ath_tx_start_dma(struct ath_softc *sc, struct ath_buf *bf,
-			     struct scatterlist *sg, u32 n_sg,
 			     struct ath_tx_control *txctl)
 {
 	struct sk_buff *skb = (struct sk_buff *)bf->bf_mpdu;
@@ -1740,10 +1739,10 @@ static void ath_tx_start_dma(struct ath_softc *sc, struct ath_buf *bf,
 			       bf->bf_keyix, bf->bf_keytype, bf->bf_flags);
 
 	ath9k_hw_filltxdesc(ah, ds,
-			    sg_dma_len(sg),		/* segment length */
-			    true,			/* first segment */
-			    (n_sg == 1) ? true : false,	/* last segment */
-			    ds);			/* first descriptor */
+			    skb->len,	/* segment length */
+			    true,	/* first segment */
+			    true,	/* last segment */
+			    ds);	/* first descriptor */
 
 	bf->bf_lastfrm = bf;
 
@@ -1783,7 +1782,6 @@ int ath_tx_start(struct ath_softc *sc, struct sk_buff *skb,
 		 struct ath_tx_control *txctl)
 {
 	struct ath_buf *bf;
-	struct scatterlist sg;
 
 	/* Check if a tx buffer is available */
 
@@ -1794,15 +1792,8 @@ int ath_tx_start(struct ath_softc *sc, struct sk_buff *skb,
 		return -1;
 	}
 
-	ath_tx_setup_buffer(sc, bf, skb, &sg, txctl);
-
-	/* Setup S/G */
-
-	memset(&sg, 0, sizeof(struct scatterlist));
-	sg_dma_address(&sg) = bf->bf_dmacontext;
-	sg_dma_len(&sg) = skb->len;
-
-	ath_tx_start_dma(sc, bf, &sg, 1, txctl);
+	ath_tx_setup_buffer(sc, bf, skb, txctl);
+	ath_tx_start_dma(sc, bf, txctl);
 
 	return 0;
 }
-- 
1.6.0.3

