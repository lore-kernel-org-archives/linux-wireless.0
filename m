Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:44262 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755081Ab1DJQcY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Apr 2011 12:32:24 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, ath5k-devel@lists.ath5k.org
Subject: [PATCH 7/7] ath5k: reduce interrupt load caused by rx/tx interrupts
Date: Sun, 10 Apr 2011 18:32:19 +0200
Message-Id: <1302453139-11437-7-git-send-email-nbd@openwrt.org>
In-Reply-To: <1302453139-11437-6-git-send-email-nbd@openwrt.org>
References: <1302453139-11437-1-git-send-email-nbd@openwrt.org>
 <1302453139-11437-2-git-send-email-nbd@openwrt.org>
 <1302453139-11437-3-git-send-email-nbd@openwrt.org>
 <1302453139-11437-4-git-send-email-nbd@openwrt.org>
 <1302453139-11437-5-git-send-email-nbd@openwrt.org>
 <1302453139-11437-6-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

While the rx/tx tasklet is pending, new unnecessary interrupts may arrive.
Decrease the load by temporarily disabling the interrupts until the tasklet
has completed.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath5k/ath5k.h |   13 +++++++++
 drivers/net/wireless/ath/ath5k/base.c  |   45 +++++++++++++++++++++++++++++--
 drivers/net/wireless/ath/ath5k/base.h  |    4 +++
 3 files changed, 59 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
index fcaf4ed..e303db7 100644
--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -872,6 +872,19 @@ enum ath5k_int {
 	AR5K_INT_QTRIG	=	0x40000000, /* Non common */
 	AR5K_INT_GLOBAL =	0x80000000,
 
+	AR5K_INT_TX_ALL = AR5K_INT_TXOK
+		| AR5K_INT_TXDESC
+		| AR5K_INT_TXERR
+		| AR5K_INT_TXEOL
+		| AR5K_INT_TXURN,
+
+	AR5K_INT_RX_ALL = AR5K_INT_RXOK
+		| AR5K_INT_RXDESC
+		| AR5K_INT_RXERR
+		| AR5K_INT_RXNOFRM
+		| AR5K_INT_RXEOL
+		| AR5K_INT_RXORN,
+
 	AR5K_INT_COMMON  = AR5K_INT_RXOK
 		| AR5K_INT_RXDESC
 		| AR5K_INT_RXERR
diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index a799d04..c7da004 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -1444,6 +1444,21 @@ ath5k_receive_frame_ok(struct ath5k_softc *sc, struct ath5k_rx_status *rs)
 }
 
 static void
+ath5k_set_current_imask(struct ath5k_softc *sc)
+{
+	enum ath5k_int imask = sc->imask;
+	unsigned long flags;
+
+	spin_lock_irqsave(&sc->irqlock, flags);
+	if (sc->rx_pending)
+		imask &= ~AR5K_INT_RX_ALL;
+	if (sc->tx_pending)
+		imask &= ~AR5K_INT_TX_ALL;
+	ath5k_hw_set_imr(sc->ah, imask);
+	spin_unlock_irqrestore(&sc->irqlock, flags);
+}
+
+static void
 ath5k_tasklet_rx(unsigned long data)
 {
 	struct ath5k_rx_status rs = {};
@@ -1506,6 +1521,8 @@ next:
 	} while (ath5k_rxbuf_setup(sc, bf) == 0);
 unlock:
 	spin_unlock(&sc->rxbuflock);
+	sc->rx_pending = false;
+	ath5k_set_current_imask(sc);
 }
 
 
@@ -1693,6 +1710,9 @@ ath5k_tasklet_tx(unsigned long data)
 	for (i=0; i < AR5K_NUM_TX_QUEUES; i++)
 		if (sc->txqs[i].setup && (sc->ah->ah_txq_isr & BIT(i)))
 			ath5k_tx_processq(sc, &sc->txqs[i]);
+
+	sc->tx_pending = false;
+	ath5k_set_current_imask(sc);
 }
 
 
@@ -2122,6 +2142,20 @@ ath5k_intr_calibration_poll(struct ath5k_hw *ah)
 	 * AR5K_REG_ENABLE_BITS(ah, AR5K_CR, AR5K_CR_SWI); */
 }
 
+static void
+ath5k_schedule_rx(struct ath5k_softc *sc)
+{
+	sc->rx_pending = true;
+	tasklet_schedule(&sc->rxtq);
+}
+
+static void
+ath5k_schedule_tx(struct ath5k_softc *sc)
+{
+	sc->tx_pending = true;
+	tasklet_schedule(&sc->txtq);
+}
+
 irqreturn_t
 ath5k_intr(int irq, void *dev_id)
 {
@@ -2164,7 +2198,7 @@ ath5k_intr(int irq, void *dev_id)
 				ieee80211_queue_work(sc->hw, &sc->reset_work);
 			}
 			else
-				tasklet_schedule(&sc->rxtq);
+				ath5k_schedule_rx(sc);
 		} else {
 			if (status & AR5K_INT_SWBA) {
 				tasklet_hi_schedule(&sc->beacontq);
@@ -2182,10 +2216,10 @@ ath5k_intr(int irq, void *dev_id)
 				ath5k_hw_update_tx_triglevel(ah, true);
 			}
 			if (status & (AR5K_INT_RXOK | AR5K_INT_RXERR))
-				tasklet_schedule(&sc->rxtq);
+				ath5k_schedule_rx(sc);
 			if (status & (AR5K_INT_TXOK | AR5K_INT_TXDESC
 					| AR5K_INT_TXERR | AR5K_INT_TXEOL))
-				tasklet_schedule(&sc->txtq);
+				ath5k_schedule_tx(sc);
 			if (status & AR5K_INT_BMISS) {
 				/* TODO */
 			}
@@ -2204,6 +2238,9 @@ ath5k_intr(int irq, void *dev_id)
 
 	} while (ath5k_hw_is_intr_pending(ah) && --counter > 0);
 
+	if (sc->rx_pending || sc->tx_pending)
+		ath5k_set_current_imask(sc);
+
 	if (unlikely(!counter))
 		ATH5K_WARN(sc, "too many interrupts, giving up for now\n");
 
@@ -2575,6 +2612,8 @@ done:
 
 static void stop_tasklets(struct ath5k_softc *sc)
 {
+	sc->rx_pending = false;
+	sc->tx_pending = false;
 	tasklet_kill(&sc->rxtq);
 	tasklet_kill(&sc->txtq);
 	tasklet_kill(&sc->calib);
diff --git a/drivers/net/wireless/ath/ath5k/base.h b/drivers/net/wireless/ath/ath5k/base.h
index 978f1f4..4c4e360 100644
--- a/drivers/net/wireless/ath/ath5k/base.h
+++ b/drivers/net/wireless/ath/ath5k/base.h
@@ -207,6 +207,10 @@ struct ath5k_softc {
 
 	enum ath5k_int		imask;		/* interrupt mask copy */
 
+	spinlock_t		irqlock;
+	bool			rx_pending;	/* rx tasklet pending */
+	bool			tx_pending;	/* tx tasklet pending */
+
 	u8			lladdr[ETH_ALEN];
 	u8			bssidmask[ETH_ALEN];
 
-- 
1.7.3.2

