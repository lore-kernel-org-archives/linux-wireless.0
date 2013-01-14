Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:45666 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755676Ab3ANJu0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jan 2013 04:50:26 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com,
	c_manoha@qca.qualcomm.com
Subject: [PATCH 3.8] ath9k: remove sc->rx.rxbuflock to fix a deadlock
Date: Mon, 14 Jan 2013 10:50:15 +0100
Message-Id: <1358157015-22982-1-git-send-email-nbd@openwrt.org> (sfid-20130114_105030_790434_C07CB199)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The commit "ath9k: fix rx flush handling" added a deadlock that happens
because ath_rx_tasklet is called in a section that has already taken the
rx buffer lock.

It seems that the only purpose of the rxbuflock was a band-aid fix to the
reset vs rx tasklet race, which has been properly fixed in the commit
"ath9k: add a better fix for the rx tasklet vs rx flush race".

Now that the fix is in, we can safely remove the lock to avoid such issues.

Cc: stable@vger.kernel.org
Reported-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |  1 -
 drivers/net/wireless/ath/ath9k/recv.c  | 13 -------------
 2 files changed, 14 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index feab50e..8250330 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -314,7 +314,6 @@ struct ath_rx {
 	u32 *rxlink;
 	u32 num_pkts;
 	unsigned int rxfilter;
-	spinlock_t rxbuflock;
 	struct list_head rxbuf;
 	struct ath_descdma rxdma;
 	struct ath_rx_edma rx_edma[ATH9K_RX_QUEUE_MAX];
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index ada9d87..d7c129b 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -249,8 +249,6 @@ rx_init_fail:
 
 static void ath_edma_start_recv(struct ath_softc *sc)
 {
-	spin_lock_bh(&sc->rx.rxbuflock);
-
 	ath9k_hw_rxena(sc->sc_ah);
 
 	ath_rx_addbuffer_edma(sc, ATH9K_RX_QUEUE_HP,
@@ -262,8 +260,6 @@ static void ath_edma_start_recv(struct ath_softc *sc)
 	ath_opmode_init(sc);
 
 	ath9k_hw_startpcureceive(sc->sc_ah, !!(sc->hw->conf.flags & IEEE80211_CONF_OFFCHANNEL));
-
-	spin_unlock_bh(&sc->rx.rxbuflock);
 }
 
 static void ath_edma_stop_recv(struct ath_softc *sc)
@@ -280,7 +276,6 @@ int ath_rx_init(struct ath_softc *sc, int nbufs)
 	int error = 0;
 
 	spin_lock_init(&sc->sc_pcu_lock);
-	spin_lock_init(&sc->rx.rxbuflock);
 
 	common->rx_bufsize = IEEE80211_MAX_MPDU_LEN / 2 +
 			     sc->sc_ah->caps.rx_status_len;
@@ -438,7 +433,6 @@ int ath_startrecv(struct ath_softc *sc)
 		return 0;
 	}
 
-	spin_lock_bh(&sc->rx.rxbuflock);
 	if (list_empty(&sc->rx.rxbuf))
 		goto start_recv;
 
@@ -459,8 +453,6 @@ start_recv:
 	ath_opmode_init(sc);
 	ath9k_hw_startpcureceive(ah, !!(sc->hw->conf.flags & IEEE80211_CONF_OFFCHANNEL));
 
-	spin_unlock_bh(&sc->rx.rxbuflock);
-
 	return 0;
 }
 
@@ -476,7 +468,6 @@ bool ath_stoprecv(struct ath_softc *sc)
 	struct ath_hw *ah = sc->sc_ah;
 	bool stopped, reset = false;
 
-	spin_lock_bh(&sc->rx.rxbuflock);
 	ath9k_hw_abortpcurecv(ah);
 	ath9k_hw_setrxfilter(ah, 0);
 	stopped = ath9k_hw_stopdmarecv(ah, &reset);
@@ -487,7 +478,6 @@ bool ath_stoprecv(struct ath_softc *sc)
 		ath_edma_stop_recv(sc);
 	else
 		sc->rx.rxlink = NULL;
-	spin_unlock_bh(&sc->rx.rxbuflock);
 
 	if (!(ah->ah_flags & AH_UNPLUGGED) &&
 	    unlikely(!stopped)) {
@@ -1153,7 +1143,6 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 		dma_type = DMA_FROM_DEVICE;
 
 	qtype = hp ? ATH9K_RX_QUEUE_HP : ATH9K_RX_QUEUE_LP;
-	spin_lock_bh(&sc->rx.rxbuflock);
 
 	tsf = ath9k_hw_gettsf64(ah);
 	tsf_lower = tsf & 0xffffffff;
@@ -1351,8 +1340,6 @@ requeue:
 		}
 	} while (1);
 
-	spin_unlock_bh(&sc->rx.rxbuflock);
-
 	if (!(ah->imask & ATH9K_INT_RXEOL)) {
 		ah->imask |= (ATH9K_INT_RXEOL | ATH9K_INT_RXORN);
 		ath9k_hw_set_interrupts(ah);
-- 
1.8.0.2

