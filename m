Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:43871 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751813AbaEWRVp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 May 2014 13:21:45 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Subject: [PATCH] ath9k: avoid passing buffers to the hardware during flush
Date: Fri, 23 May 2014 19:21:34 +0200
Message-Id: <1400865694-47992-1-git-send-email-nbd@openwrt.org> (sfid-20140523_192148_322858_3E3C97A1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The commit "ath9k: fix possible hang on flush" changed the receive code
to always link rx descriptors of processed frames, even when flushing.
In some cases, this leads to flushed rx buffers being passed to the
hardware while rx is already stopped.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/recv.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 43ae199..9105a92 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -34,7 +34,8 @@ static inline bool ath9k_check_auto_sleep(struct ath_softc *sc)
  * buffer (or rx fifo). This can incorrectly acknowledge packets
  * to a sender if last desc is self-linked.
  */
-static void ath_rx_buf_link(struct ath_softc *sc, struct ath_rxbuf *bf)
+static void ath_rx_buf_link(struct ath_softc *sc, struct ath_rxbuf *bf,
+			    bool flush)
 {
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(ah);
@@ -59,18 +60,19 @@ static void ath_rx_buf_link(struct ath_softc *sc, struct ath_rxbuf *bf)
 			     common->rx_bufsize,
 			     0);
 
-	if (sc->rx.rxlink == NULL)
-		ath9k_hw_putrxbuf(ah, bf->bf_daddr);
-	else
+	if (sc->rx.rxlink)
 		*sc->rx.rxlink = bf->bf_daddr;
+	else if (!flush)
+		ath9k_hw_putrxbuf(ah, bf->bf_daddr);
 
 	sc->rx.rxlink = &ds->ds_link;
 }
 
-static void ath_rx_buf_relink(struct ath_softc *sc, struct ath_rxbuf *bf)
+static void ath_rx_buf_relink(struct ath_softc *sc, struct ath_rxbuf *bf,
+			      bool flush)
 {
 	if (sc->rx.buf_hold)
-		ath_rx_buf_link(sc, sc->rx.buf_hold);
+		ath_rx_buf_link(sc, sc->rx.buf_hold, flush);
 
 	sc->rx.buf_hold = bf;
 }
@@ -442,7 +444,7 @@ int ath_startrecv(struct ath_softc *sc)
 	sc->rx.buf_hold = NULL;
 	sc->rx.rxlink = NULL;
 	list_for_each_entry_safe(bf, tbf, &sc->rx.rxbuf, list) {
-		ath_rx_buf_link(sc, bf);
+		ath_rx_buf_link(sc, bf, false);
 	}
 
 	/* We could have deleted elements so the list may be empty now */
@@ -1118,12 +1120,12 @@ requeue_drop_frag:
 requeue:
 		list_add_tail(&bf->list, &sc->rx.rxbuf);
 
-		if (edma) {
-			ath_rx_edma_buf_link(sc, qtype);
-		} else {
-			ath_rx_buf_relink(sc, bf);
+		if (!edma) {
+			ath_rx_buf_relink(sc, bf, flush);
 			if (!flush)
 				ath9k_hw_rxena(ah);
+		} else if (!flush) {
+			ath_rx_edma_buf_link(sc, qtype);
 		}
 
 		if (!budget--)
-- 
1.8.5.2 (Apple Git-48)

