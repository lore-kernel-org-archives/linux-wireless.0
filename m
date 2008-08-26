Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:39168 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753638AbYHZCmv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Aug 2008 22:42:51 -0400
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18611.27970.733352.460238@localhost.localdomain> (sfid-20080826_044253_803762_BF8946FD)
Date: Tue, 26 Aug 2008 08:11:06 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 3/4] ath9k: Remove sc_lastrx as we don't use it anywhere
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/core.h |    1 -
 drivers/net/wireless/ath9k/xmit.c |    7 ++-----
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath9k/core.h b/drivers/net/wireless/ath9k/core.h
index b6b6868..1faa1ef 100644
--- a/drivers/net/wireless/ath9k/core.h
+++ b/drivers/net/wireless/ath9k/core.h
@@ -970,7 +970,6 @@ struct ath_softc {
 	struct ath_descdma sc_rxdma;
 	int sc_rxbufsize;	/* rx size based on mtu */
 	u32 *sc_rxlink;		/* link ptr in last RX desc */
-	u64 sc_lastrx;		/* tsf of last rx'd frame */
 
 	/* TX */
 	struct list_head sc_txbuf;
diff --git a/drivers/net/wireless/ath9k/xmit.c b/drivers/net/wireless/ath9k/xmit.c
index 87aebf1..3fc6641 100644
--- a/drivers/net/wireless/ath9k/xmit.c
+++ b/drivers/net/wireless/ath9k/xmit.c
@@ -2309,8 +2309,7 @@ int ath_tx_start(struct ath_softc *sc, struct sk_buff *skb)
 
 void ath_tx_tasklet(struct ath_softc *sc)
 {
-	u64 tsf = ath9k_hw_gettsf64(sc->sc_ah);
-	int i, nacked = 0;
+	int i;
 	u32 qcumask = ((1 << ATH9K_NUM_TX_QUEUES) - 1);
 
 	ath9k_hw_gettxintrtxqs(sc->sc_ah, &qcumask);
@@ -2320,10 +2319,8 @@ void ath_tx_tasklet(struct ath_softc *sc)
 	 */
 	for (i = 0; i < ATH9K_NUM_TX_QUEUES; i++) {
 		if (ATH_TXQ_SETUP(sc, i) && (qcumask & (1 << i)))
-			nacked += ath_tx_processq(sc, &sc->sc_txq[i]);
+			ath_tx_processq(sc, &sc->sc_txq[i]);
 	}
-	if (nacked)
-		sc->sc_lastrx = tsf;
 }
 
 void ath_tx_draintxq(struct ath_softc *sc,
-- 
1.6.0

