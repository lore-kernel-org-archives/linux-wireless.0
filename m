Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:3086 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752258AbZGDRAx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Jul 2009 13:00:53 -0400
From: Bob Copeland <me@bobcopeland.com>
To: linville@tuxdriver.com, jirislaby@gmail.com, mickflemm@gmail.com,
	lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 1/5] ath5k: send buffered frames after the beacon
Date: Sat,  4 Jul 2009 12:59:51 -0400
Message-Id: <1246726795-3934-2-git-send-email-me@bobcopeland.com>
In-Reply-To: <1246726795-3934-1-git-send-email-me@bobcopeland.com>
References: <1246726795-3934-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Enable the "Content" After Beacon queue and utilize it to send
any buffered frames for power-saving clients.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath/ath5k/base.c |   35 ++++++++++++++++++++++++++++----
 drivers/net/wireless/ath/ath5k/base.h |    9 +++----
 drivers/net/wireless/ath/ath5k/qcu.c  |    1 -
 3 files changed, 34 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index c6e7091..87ebc46 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -218,6 +218,8 @@ static struct pci_driver ath5k_pci_driver = {
  * Prototypes - MAC 802.11 stack related functions
  */
 static int ath5k_tx(struct ieee80211_hw *hw, struct sk_buff *skb);
+static int ath5k_tx_queue(struct ieee80211_hw *hw, struct sk_buff *skb,
+		struct ath5k_txq *txq);
 static int ath5k_reset(struct ath5k_softc *sc, struct ieee80211_channel *chan);
 static int ath5k_reset_wake(struct ath5k_softc *sc);
 static int ath5k_start(struct ieee80211_hw *hw);
@@ -301,7 +303,8 @@ static void	ath5k_desc_free(struct ath5k_softc *sc,
 static int 	ath5k_rxbuf_setup(struct ath5k_softc *sc,
 				struct ath5k_buf *bf);
 static int 	ath5k_txbuf_setup(struct ath5k_softc *sc,
-				struct ath5k_buf *bf);
+				struct ath5k_buf *bf,
+				struct ath5k_txq *txq);
 static inline void ath5k_txbuf_free(struct ath5k_softc *sc,
 				struct ath5k_buf *bf)
 {
@@ -516,6 +519,7 @@ ath5k_pci_probe(struct pci_dev *pdev,
 	/* Initialize driver private data */
 	SET_IEEE80211_DEV(hw, &pdev->dev);
 	hw->flags = IEEE80211_HW_RX_INCLUDES_FCS |
+		    IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
 		    IEEE80211_HW_SIGNAL_DBM |
 		    IEEE80211_HW_NOISE_DBM;
 
@@ -789,12 +793,18 @@ ath5k_attach(struct pci_dev *pdev, struct ieee80211_hw *hw)
 		goto err_desc;
 	}
 	sc->bhalq = ret;
+	sc->cabq = ath5k_txq_setup(sc, AR5K_TX_QUEUE_CAB, 0);
+	if (IS_ERR(sc->cabq)) {
+		ATH5K_ERR(sc, "can't setup cab queue\n");
+		ret = PTR_ERR(sc->cabq);
+		goto err_bhal;
+	}
 
 	sc->txq = ath5k_txq_setup(sc, AR5K_TX_QUEUE_DATA, AR5K_WME_AC_BK);
 	if (IS_ERR(sc->txq)) {
 		ATH5K_ERR(sc, "can't setup xmit queue\n");
 		ret = PTR_ERR(sc->txq);
-		goto err_bhal;
+		goto err_queues;
 	}
 
 	tasklet_init(&sc->rxtq, ath5k_tasklet_rx, (unsigned long)sc);
@@ -1232,10 +1242,10 @@ ath5k_rxbuf_setup(struct ath5k_softc *sc, struct ath5k_buf *bf)
 }
 
 static int
-ath5k_txbuf_setup(struct ath5k_softc *sc, struct ath5k_buf *bf)
+ath5k_txbuf_setup(struct ath5k_softc *sc, struct ath5k_buf *bf,
+		  struct ath5k_txq *txq)
 {
 	struct ath5k_hw *ah = sc->ah;
-	struct ath5k_txq *txq = sc->txq;
 	struct ath5k_desc *ds = bf->desc;
 	struct sk_buff *skb = bf->skb;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
@@ -2103,6 +2113,7 @@ ath5k_beacon_send(struct ath5k_softc *sc)
 {
 	struct ath5k_buf *bf = sc->bbuf;
 	struct ath5k_hw *ah = sc->ah;
+	struct sk_buff *skb;
 
 	ATH5K_DBG_UNLIMIT(sc, ATH5K_DEBUG_BEACON, "in beacon_send\n");
 
@@ -2156,6 +2167,12 @@ ath5k_beacon_send(struct ath5k_softc *sc)
 	ATH5K_DBG(sc, ATH5K_DEBUG_BEACON, "TXDP[%u] = %llx (%p)\n",
 		sc->bhalq, (unsigned long long)bf->daddr, bf->desc);
 
+	skb = ieee80211_get_buffered_bc(sc->hw, sc->vif);
+	while (skb) {
+		ath5k_tx_queue(sc->hw, skb, sc->cabq);
+		skb = ieee80211_get_buffered_bc(sc->hw, sc->vif);
+	}
+
 	sc->bsent++;
 }
 
@@ -2603,6 +2620,14 @@ static int
 ath5k_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 {
 	struct ath5k_softc *sc = hw->priv;
+
+	return ath5k_tx_queue(hw, skb, sc->txq);
+}
+
+static int ath5k_tx_queue(struct ieee80211_hw *hw, struct sk_buff *skb,
+			  struct ath5k_txq *txq)
+{
+	struct ath5k_softc *sc = hw->priv;
 	struct ath5k_buf *bf;
 	unsigned long flags;
 	int hdrlen;
@@ -2646,7 +2671,7 @@ ath5k_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 
 	bf->skb = skb;
 
-	if (ath5k_txbuf_setup(sc, bf)) {
+	if (ath5k_txbuf_setup(sc, bf, txq)) {
 		bf->skb = NULL;
 		spin_lock_irqsave(&sc->txbuflock, flags);
 		list_add_tail(&bf->list, &sc->txbuf);
diff --git a/drivers/net/wireless/ath/ath5k/base.h b/drivers/net/wireless/ath/ath5k/base.h
index f9b7f2f..65e75fb 100644
--- a/drivers/net/wireless/ath/ath5k/base.h
+++ b/drivers/net/wireless/ath/ath5k/base.h
@@ -114,8 +114,7 @@ struct ath5k_softc {
 	struct pci_dev		*pdev;		/* for dma mapping */
 	void __iomem		*iobase;	/* address of the device */
 	struct mutex		lock;		/* dev-level lock */
-	/* FIXME: how many does it really need? */
-	struct ieee80211_tx_queue_stats tx_stats[16];
+	struct ieee80211_tx_queue_stats tx_stats[AR5K_NUM_TX_QUEUES];
 	struct ieee80211_low_level_stats ll_stats;
 	struct ieee80211_hw	*hw;		/* IEEE 802.11 common */
 	struct ieee80211_supported_band sbands[IEEE80211_NUM_BANDS];
@@ -171,9 +170,8 @@ struct ath5k_softc {
 	struct list_head	txbuf;		/* transmit buffer */
 	spinlock_t		txbuflock;
 	unsigned int		txbuf_len;	/* buf count in txbuf list */
-	struct ath5k_txq	txqs[2];	/* beacon and tx */
-
-	struct ath5k_txq	*txq;		/* beacon and tx*/
+	struct ath5k_txq	txqs[AR5K_NUM_TX_QUEUES];	/* tx queues */
+	struct ath5k_txq	*txq;		/* main tx queue */
 	struct tasklet_struct	txtq;		/* tx intr tasklet */
 	struct ath5k_led	tx_led;		/* tx led */
 
@@ -187,6 +185,7 @@ struct ath5k_softc {
 				bintval,	/* beacon interval in TU */
 				bsent;
 	unsigned int		nexttbtt;	/* next beacon time in TU */
+	struct ath5k_txq	*cabq;		/* content after beacon */
 
 	struct timer_list	calib_tim;	/* calibration timer */
 	int 			power_level;	/* Requested tx power in dbm */
diff --git a/drivers/net/wireless/ath/ath5k/qcu.c b/drivers/net/wireless/ath/ath5k/qcu.c
index 73407b3..6d5aaf0 100644
--- a/drivers/net/wireless/ath/ath5k/qcu.c
+++ b/drivers/net/wireless/ath/ath5k/qcu.c
@@ -411,7 +411,6 @@ int ath5k_hw_reset_tx_queue(struct ath5k_hw *ah, unsigned int queue)
 			AR5K_REG_ENABLE_BITS(ah, AR5K_QUEUE_MISC(queue),
 				AR5K_QCU_MISC_FRSHED_BCN_SENT_GT |
 				AR5K_QCU_MISC_CBREXP_DIS |
-				AR5K_QCU_MISC_RDY_VEOL_POLICY |
 				AR5K_QCU_MISC_CBREXP_BCN_DIS);
 
 			ath5k_hw_reg_write(ah, ((AR5K_TUNE_BEACON_INTERVAL -
-- 
1.6.2.5


