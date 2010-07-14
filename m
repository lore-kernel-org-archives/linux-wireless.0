Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30s.wh2.ocn.ne.jp ([125.206.180.198]:38972 "HELO
	mail30s.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754121Ab0GNBwd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jul 2010 21:52:33 -0400
Received: from vs3004.wh2.ocn.ne.jp (125.206.180.167)
	by mail30s.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 2-0561072352
	for <linux-wireless@vger.kernel.org>; Wed, 14 Jul 2010 10:52:32 +0900 (JST)
Subject: [PATCH] ath5k: clean up rxlink handling
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Date: Wed, 14 Jul 2010 10:53:29 +0900
Message-ID: <20100714015329.10457.31186.stgit@tt-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There were a few places where the sc->rxlink pointer was set to NULL "just in
case". This helps nothing - quite to the contrary it is problematic since it
can create self-linked rx descriptors in the middle of the list of receive
buffers.

Here is an example how this could happen (thanks Bob!):

cpu 0:                                      cpu 1:

ath5k_rx_stop
                                            ath5k_tasklet_rx
sc->rxlink = NULL;   /* just in case */
                                              // following doesn't link used
                                              // buffer to prev.
                                              ath5k_rxbuf_setup()

In the case of ath5k_rx_stop() and ath5k_stop_locked() buffers/descriptors are
not changed so rxlink should not be changed as well.

In ath5k_intr() we seem to  try to work around a hardware bug, as the comment
(which is copied 1:1 from the HAL) suggests. I don't see how this could help.
Also the HAL does not set rxlink in this case (So where does this code come
from? It has been there since the first import of ath5k). Changed to just
increment a statistics counter.

After this patch rxlink is only set to NULL before we initialize rx descriptors
and updated when the descriptors are linked together.

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 drivers/net/wireless/ath/ath5k/base.c |    7 ++-----
 drivers/net/wireless/ath/ath5k/base.h |    1 +
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index b0e1ca9..0d5de25 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -1728,8 +1728,6 @@ ath5k_rx_stop(struct ath5k_softc *sc)
 	ath5k_hw_stop_rx_dma(ah);	/* disable DMA engine */
 
 	ath5k_debug_printrxbuffs(sc, ah);
-
-	sc->rxlink = NULL;		/* just in case */
 }
 
 static unsigned int
@@ -2633,8 +2631,7 @@ ath5k_stop_locked(struct ath5k_softc *sc)
 	if (!test_bit(ATH_STAT_INVALID, sc->status)) {
 		ath5k_rx_stop(sc);
 		ath5k_hw_phy_disable(ah);
-	} else
-		sc->rxlink = NULL;
+	}
 
 	return 0;
 }
@@ -2771,7 +2768,7 @@ ath5k_intr(int irq, void *dev_id)
 				*     RXE bit is written, but it doesn't work at
 				*     least on older hardware revs.
 				*/
-				sc->rxlink = NULL;
+				sc->stats.rxeol_intr++;
 			}
 			if (status & AR5K_INT_TXURN) {
 				/* bump tx trigger level */
diff --git a/drivers/net/wireless/ath/ath5k/base.h b/drivers/net/wireless/ath/ath5k/base.h
index 86c90f4..dc1241f 100644
--- a/drivers/net/wireless/ath/ath5k/base.h
+++ b/drivers/net/wireless/ath/ath5k/base.h
@@ -137,6 +137,7 @@ struct ath5k_statistics {
 
 	unsigned int mib_intr;
 	unsigned int rxorn_intr;
+	unsigned int rxeol_intr;
 };
 
 #if CHAN_DEBUG

