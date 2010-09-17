Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30t.wh2.ocn.ne.jp ([125.206.180.136]:3896 "HELO
	mail30t.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753285Ab0IQCgO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Sep 2010 22:36:14 -0400
Received: from vs3005.wh2.ocn.ne.jp (125.206.180.233)
	by mail30t.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 1-011936973
	for <linux-wireless@vger.kernel.org>; Fri, 17 Sep 2010 11:36:13 +0900 (JST)
Subject: [PATCH 03/11] ath5k: Use four hardware queues
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Date: Fri, 17 Sep 2010 11:36:35 +0900
Message-ID: <20100917023635.24997.50520.stgit@tt-desk>
In-Reply-To: <20100917023543.24997.48466.stgit@tt-desk>
References: <20100917023543.24997.48466.stgit@tt-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Prepare ath5k for WME by using four hardware queues.

The way we set up our queues matches the mac80211 queue priority 1:1, so we
don't have to do any mapping for queue numbers.

Every queue uses 50 of the total 200 available transmit buffers, so the DMA
memory usage does not increase with this patch, but it might be good to
fine-tune the number of buffers per queue later (depending on the CPU speed and
load, and the speed of the medium access, it might not be big enough).

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 drivers/net/wireless/ath/ath5k/base.c |   47 +++++++++++++++++++++++++++++----
 drivers/net/wireless/ath/ath5k/base.h |    5 +++-
 2 files changed, 45 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 9e4636f..c105dba 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -737,6 +737,7 @@ ath5k_txbuf_setup(struct ath5k_softc *sc, struct ath5k_buf *bf,
 
 	spin_lock_bh(&txq->lock);
 	list_add_tail(&bf->list, &txq->q);
+	txq->txq_len++;
 	if (txq->link == NULL) /* is this first packet? */
 		ath5k_hw_set_txdp(ah, txq->qnum, bf->daddr);
 	else /* no, so only link it */
@@ -893,6 +894,7 @@ ath5k_txq_setup(struct ath5k_softc *sc,
 		INIT_LIST_HEAD(&txq->q);
 		spin_lock_init(&txq->lock);
 		txq->setup = true;
+		txq->txq_len = 0;
 	}
 	return &sc->txqs[qnum];
 }
@@ -987,6 +989,7 @@ ath5k_txq_drainq(struct ath5k_softc *sc, struct ath5k_txq *txq)
 		spin_lock_bh(&sc->txbuflock);
 		list_move_tail(&bf->list, &sc->txbuf);
 		sc->txbuf_len++;
+		txq->txq_len--;
 		spin_unlock_bh(&sc->txbuflock);
 	}
 	txq->link = NULL;
@@ -1483,6 +1486,9 @@ static int ath5k_tx_queue(struct ieee80211_hw *hw, struct sk_buff *skb,
 		goto drop_packet;
 	}
 
+	if (txq->txq_len >= ATH5K_TXQ_LEN_MAX)
+		ieee80211_stop_queue(hw, txq->qnum);
+
 	spin_lock_irqsave(&sc->txbuflock, flags);
 	if (list_empty(&sc->txbuf)) {
 		ATH5K_ERR(sc, "no further txbuf available, dropping packet\n");
@@ -1605,13 +1611,14 @@ ath5k_tx_processq(struct ath5k_softc *sc, struct ath5k_txq *txq)
 		spin_lock(&sc->txbuflock);
 		list_move_tail(&bf->list, &sc->txbuf);
 		sc->txbuf_len++;
+		txq->txq_len--;
 		spin_unlock(&sc->txbuflock);
 	}
 	if (likely(list_empty(&txq->q)))
 		txq->link = NULL;
 	spin_unlock(&txq->lock);
-	if (sc->txbuf_len > ATH_TXBUF / 5)
-		ieee80211_wake_queues(sc->hw);
+	if (txq->txq_len < ATH5K_TXQ_LEN_LOW)
+		ieee80211_wake_queue(sc->hw, txq->qnum);
 }
 
 static void
@@ -2395,6 +2402,7 @@ ath5k_attach(struct pci_dev *pdev, struct ieee80211_hw *hw)
 	struct ath5k_softc *sc = hw->priv;
 	struct ath5k_hw *ah = sc->ah;
 	struct ath_regulatory *regulatory = ath5k_hw_regulatory(ah);
+	struct ath5k_txq *txq;
 	u8 mac[ETH_ALEN] = {};
 	int ret;
 
@@ -2460,12 +2468,33 @@ ath5k_attach(struct pci_dev *pdev, struct ieee80211_hw *hw)
 		goto err_bhal;
 	}
 
-	sc->txq = ath5k_txq_setup(sc, AR5K_TX_QUEUE_DATA, AR5K_WME_AC_BK);
-	if (IS_ERR(sc->txq)) {
+	/* This order matches mac80211's queue priority, so we can
+	 * directly use the mac80211 queue number without any mapping */
+	txq = ath5k_txq_setup(sc, AR5K_TX_QUEUE_DATA, AR5K_WME_AC_VO);
+	if (IS_ERR(txq)) {
+		ATH5K_ERR(sc, "can't setup xmit queue\n");
+		ret = PTR_ERR(txq);
+		goto err_queues;
+	}
+	txq = ath5k_txq_setup(sc, AR5K_TX_QUEUE_DATA, AR5K_WME_AC_VI);
+	if (IS_ERR(txq)) {
 		ATH5K_ERR(sc, "can't setup xmit queue\n");
-		ret = PTR_ERR(sc->txq);
+		ret = PTR_ERR(txq);
 		goto err_queues;
 	}
+	txq = ath5k_txq_setup(sc, AR5K_TX_QUEUE_DATA, AR5K_WME_AC_BE);
+	if (IS_ERR(txq)) {
+		ATH5K_ERR(sc, "can't setup xmit queue\n");
+		ret = PTR_ERR(txq);
+		goto err_queues;
+	}
+	txq = ath5k_txq_setup(sc, AR5K_TX_QUEUE_DATA, AR5K_WME_AC_BK);
+	if (IS_ERR(txq)) {
+		ATH5K_ERR(sc, "can't setup xmit queue\n");
+		ret = PTR_ERR(txq);
+		goto err_queues;
+	}
+	hw->queues = 4;
 
 	tasklet_init(&sc->rxtq, ath5k_tasklet_rx, (unsigned long)sc);
 	tasklet_init(&sc->txtq, ath5k_tasklet_tx, (unsigned long)sc);
@@ -2558,8 +2587,14 @@ static int
 ath5k_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 {
 	struct ath5k_softc *sc = hw->priv;
+	u16 qnum = skb_get_queue_mapping(skb);
+
+	if (WARN_ON(qnum >= sc->ah->ah_capabilities.cap_queues.q_tx_num)) {
+		dev_kfree_skb_any(skb);
+		return 0;
+	}
 
-	return ath5k_tx_queue(hw, skb, sc->txq);
+	return ath5k_tx_queue(hw, skb, &sc->txqs[qnum]);
 }
 
 static int ath5k_start(struct ieee80211_hw *hw)
diff --git a/drivers/net/wireless/ath/ath5k/base.h b/drivers/net/wireless/ath/ath5k/base.h
index dc1241f..5e2366d 100644
--- a/drivers/net/wireless/ath/ath5k/base.h
+++ b/drivers/net/wireless/ath/ath5k/base.h
@@ -60,6 +60,9 @@
 #define	ATH_TXBUF	200		/* number of TX buffers */
 #define ATH_BCBUF	1		/* number of beacon buffers */
 
+#define ATH5K_TXQ_LEN_MAX	(ATH_TXBUF / 4)		/* bufs per queue */
+#define ATH5K_TXQ_LEN_LOW	(ATH5K_TXQ_LEN_MAX / 2)	/* low mark */
+
 struct ath5k_buf {
 	struct list_head	list;
 	struct ath5k_desc	*desc;	/* virtual addr of desc */
@@ -83,6 +86,7 @@ struct ath5k_txq {
 	struct list_head	q;	/* transmit queue */
 	spinlock_t		lock;	/* lock on q and link */
 	bool			setup;
+	int			txq_len; /* number of queued buffers */
 };
 
 #define ATH5K_LED_MAX_NAME_LEN 31
@@ -204,7 +208,6 @@ struct ath5k_softc {
 	spinlock_t		txbuflock;
 	unsigned int		txbuf_len;	/* buf count in txbuf list */
 	struct ath5k_txq	txqs[AR5K_NUM_TX_QUEUES];	/* tx queues */
-	struct ath5k_txq	*txq;		/* main tx queue */
 	struct tasklet_struct	txtq;		/* tx intr tasklet */
 	struct ath5k_led	tx_led;		/* tx led */
 

