Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:55803 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755945Ab3AIPRF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jan 2013 10:17:05 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH v3 3.8 1/5] ath9k: do not link receive buffers during flush
Date: Wed,  9 Jan 2013 16:16:52 +0100
Message-Id: <1357744616-63257-1-git-send-email-nbd@openwrt.org> (sfid-20130109_161710_131753_FFF19B2D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On AR9300 the rx FIFO needs to be empty during reset to ensure that no
further DMA activity is generated, otherwise it might lead to memory
corruption issues.

Cc: stable@vger.kernel.org
Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/recv.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 3d236ae..8fb6d3b 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -735,6 +735,7 @@ static struct ath_buf *ath_get_next_rx_buf(struct ath_softc *sc,
 			return NULL;
 	}
 
+	list_del(&bf->list);
 	if (!bf->bf_mpdu)
 		return bf;
 
@@ -1245,14 +1246,15 @@ requeue_drop_frag:
 			sc->rx.frag = NULL;
 		}
 requeue:
+		list_add_tail(&bf->list, &sc->rx.rxbuf);
+		if (flush)
+			continue;
+
 		if (edma) {
-			list_add_tail(&bf->list, &sc->rx.rxbuf);
 			ath_rx_edma_buf_link(sc, qtype);
 		} else {
-			list_move_tail(&bf->list, &sc->rx.rxbuf);
 			ath_rx_buf_link(sc, bf);
-			if (!flush)
-				ath9k_hw_rxena(ah);
+			ath9k_hw_rxena(ah);
 		}
 	} while (1);
 
-- 
1.8.0.2

