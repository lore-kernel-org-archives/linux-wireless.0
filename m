Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:50397 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756514Ab1DGRaf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Apr 2011 13:30:35 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH] ath9k: fix too early enabling of rx during ath_startrecv()
Date: Thu,  7 Apr 2011 19:30:32 +0200
Message-Id: <1302197432-35452-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rx should only be enabled after enough rx buffers have been given to the
hardware, however ath_rx_buf_link was calling ath9k_hw_rxena after every
single added buffer.
Fix this by calling ath9k_hw_rxena directly from the rx tasklet after
completion instead.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/recv.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index cdcf60d..dfe2253 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -75,7 +75,6 @@ static void ath_rx_buf_link(struct ath_softc *sc, struct ath_buf *bf)
 		*sc->rx.rxlink = bf->bf_daddr;
 
 	sc->rx.rxlink = &ds->ds_link;
-	ath9k_hw_rxena(ah);
 }
 
 static void ath_setdefantenna(struct ath_softc *sc, u32 antenna)
@@ -1774,6 +1773,7 @@ requeue:
 		} else {
 			list_move_tail(&bf->list, &sc->rx.rxbuf);
 			ath_rx_buf_link(sc, bf);
+			ath9k_hw_rxena(ah);
 		}
 	} while (1);
 
-- 
1.7.3.2

