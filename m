Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:58681 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757430Ab1INTXS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Sep 2011 15:23:18 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH 3/3] ath9k: ensure that rx is not enabled during a reset
Date: Wed, 14 Sep 2011 21:23:03 +0200
Message-Id: <1316028183-33734-3-git-send-email-nbd@openwrt.org> (sfid-20110914_212322_291749_56CAA5C5)
In-Reply-To: <1316028183-33734-2-git-send-email-nbd@openwrt.org>
References: <1316028183-33734-1-git-send-email-nbd@openwrt.org>
 <1316028183-33734-2-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

During a reset, rx buffers are flushed after rx has been disabled. To avoid
race conditions, rx needs to stay disabled during the reset, so avoid any
calls to ath9k_hw_rxena in that case.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/main.c |    4 ++--
 drivers/net/wireless/ath/ath9k/recv.c |    5 +++--
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index a3c3316..a75810a 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -247,8 +247,8 @@ static bool ath_prepare_reset(struct ath_softc *sc, bool retry_tx, bool flush)
 
 	if (!flush) {
 		if (ah->caps.hw_caps & ATH9K_HW_CAP_EDMA)
-			ath_rx_tasklet(sc, 0, true);
-		ath_rx_tasklet(sc, 0, false);
+			ath_rx_tasklet(sc, 1, true);
+		ath_rx_tasklet(sc, 1, false);
 	} else {
 		ath_flushrecv(sc);
 	}
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 8d3e19d..bcc0b22 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -1839,7 +1839,7 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 		 * If we're asked to flush receive queue, directly
 		 * chain it back at the queue without processing it.
 		 */
-		if (flush)
+		if (sc->sc_flags & SC_OP_RXFLUSH)
 			goto requeue_drop_frag;
 
 		retval = ath9k_rx_skb_preprocess(common, hw, hdr, &rs,
@@ -1967,7 +1967,8 @@ requeue:
 		} else {
 			list_move_tail(&bf->list, &sc->rx.rxbuf);
 			ath_rx_buf_link(sc, bf);
-			ath9k_hw_rxena(ah);
+			if (!flush)
+				ath9k_hw_rxena(ah);
 		}
 	} while (1);
 
-- 
1.7.3.2

