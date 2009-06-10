Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:43286 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755488AbZFJQ0O (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jun 2009 12:26:14 -0400
Received: from mail.atheros.com ([10.10.20.104])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 10 Jun 2009 09:26:17 -0700
From: Senthil Balasubramanian <senthilkumar@atheros.com>
To: <linville@tuxdriver.com>
CC: <jouni.malinen@atheros.com>, <luis.rodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>,
	Senthil Balasubramanian <senthilkumar@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>
Subject: [PATCH 6/7] ath9k: Fix TX hang issue with Atheros chipsets
Date: Wed, 10 Jun 2009 21:55:31 +0530
Message-ID: <1244651133-6537-7-git-send-email-senthilkumar@atheros.com>
In-Reply-To: <1244651133-6537-6-git-send-email-senthilkumar@atheros.com>
References: <1244651133-6537-1-git-send-email-senthilkumar@atheros.com>
 <1244651133-6537-2-git-send-email-senthilkumar@atheros.com>
 <1244651133-6537-3-git-send-email-senthilkumar@atheros.com>
 <1244651133-6537-4-git-send-email-senthilkumar@atheros.com>
 <1244651133-6537-5-git-send-email-senthilkumar@atheros.com>
 <1244651133-6537-6-git-send-email-senthilkumar@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The hardware doesn't generate interrupts in some cases and so work
around that by monitoring the TX status periodically and reset the
chip of required. The STA seems to be pretty stable with this fix.

Signed-off-by: Senthil Balasubramanian <senthilkumar@atheros.com>
Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    4 +++
 drivers/net/wireless/ath/ath9k/main.c  |    2 +
 drivers/net/wireless/ath/ath9k/xmit.c  |   41 ++++++++++++++++++++++++++++++++
 3 files changed, 47 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 71d71c0..3939396 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -231,6 +231,8 @@ void ath_descdma_cleanup(struct ath_softc *sc, struct ath_descdma *dd,
 #define ATH_DS_TX_BA(_ds)          ((_ds)->ds_us.tx.ts_flags & ATH9K_TX_BA)
 #define ATH_AN_2_TID(_an, _tidno)  (&(_an)->tid[(_tidno)])
 
+#define ATH_TX_COMPLETE_POLL_INT	1000
+
 enum ATH_AGGR_STATUS {
 	ATH_AGGR_DONE,
 	ATH_AGGR_BAW_CLOSED,
@@ -246,6 +248,7 @@ struct ath_txq {
 	u8 axq_aggr_depth;
 	u32 axq_totalqueued;
 	bool stopped;
+	bool axq_tx_inprogress;
 	struct ath_buf *axq_linkbuf;
 
 	/* first desc of the last descriptor that contains CTS */
@@ -619,6 +622,7 @@ struct ath_softc {
 #endif
 	struct ath_bus_ops *bus_ops;
 	struct ath_beacon_config cur_beacon_conf;
+	struct delayed_work tx_complete_work;
 };
 
 struct ath_wiphy {
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 5ee9800..2ebd0ed 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1291,6 +1291,7 @@ void ath_detach(struct ath_softc *sc)
 	ath_deinit_leds(sc);
 	cancel_work_sync(&sc->chan_work);
 	cancel_delayed_work_sync(&sc->wiphy_work);
+	cancel_delayed_work_sync(&sc->tx_complete_work);
 
 	for (i = 0; i < sc->num_sec_wiphy; i++) {
 		struct ath_wiphy *aphy = sc->sec_wiphy[i];
@@ -2025,6 +2026,7 @@ static int ath9k_start(struct ieee80211_hw *hw)
 #if defined(CONFIG_RFKILL) || defined(CONFIG_RFKILL_MODULE)
 	r = ath_start_rfkill_poll(sc);
 #endif
+	queue_delayed_work(sc->hw->workqueue, &sc->tx_complete_work, 0);
 
 mutex_unlock:
 	mutex_unlock(&sc->mutex);
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index a8def4f..328391e 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -864,6 +864,7 @@ struct ath_txq *ath_txq_setup(struct ath_softc *sc, int qtype, int subtype)
 		txq->axq_aggr_depth = 0;
 		txq->axq_totalqueued = 0;
 		txq->axq_linkbuf = NULL;
+		txq->axq_tx_inprogress = false;
 		sc->tx.txqsetup |= 1<<qnum;
 	}
 	return &sc->tx.txq[qnum];
@@ -1028,6 +1029,8 @@ void ath_draintxq(struct ath_softc *sc, struct ath_txq *txq, bool retry_tx)
 			ath_tx_complete_aggr(sc, txq, bf, &bf_head, 0);
 		else
 			ath_tx_complete_buf(sc, bf, &bf_head, 0, 0);
+
+		txq->axq_tx_inprogress = false;
 	}
 
 	/* flush any pending frames if aggregation is enabled */
@@ -2027,6 +2030,8 @@ static void ath_tx_processq(struct ath_softc *sc, struct ath_txq *txq)
 		else
 			ath_tx_complete_buf(sc, bf, &bf_head, txok, 0);
 
+		txq->axq_tx_inprogress = false;
+
 		ath_wake_mac80211_queue(sc, txq);
 
 		spin_lock_bh(&txq->axq_lock);
@@ -2036,6 +2041,40 @@ static void ath_tx_processq(struct ath_softc *sc, struct ath_txq *txq)
 	}
 }
 
+void ath_tx_complete_poll_work(struct work_struct *work)
+{
+	struct ath_softc *sc = container_of(work, struct ath_softc,
+			tx_complete_work.work);
+	struct ath_txq *txq;
+	int i;
+	bool needreset = false;
+
+	for (i = 0; i < ATH9K_NUM_TX_QUEUES; i++)
+		if (ATH_TXQ_SETUP(sc, i)) {
+			txq = &sc->tx.txq[i];
+			spin_lock_bh(&txq->axq_lock);
+			if (txq->axq_depth) {
+				if (txq->axq_tx_inprogress) {
+					needreset = true;
+					spin_unlock_bh(&txq->axq_lock);
+					break;
+				} else {
+					txq->axq_tx_inprogress = true;
+				}
+			}
+			spin_unlock_bh(&txq->axq_lock);
+		}
+
+	if (needreset) {
+		DPRINTF(sc, ATH_DBG_RESET, "tx hung, resetting the chip\n");
+		ath_reset(sc, false);
+	}
+
+	queue_delayed_work(sc->hw->workqueue, &sc->tx_complete_work,
+			msecs_to_jiffies(ATH_TX_COMPLETE_POLL_INT));
+}
+
+
 
 void ath_tx_tasklet(struct ath_softc *sc)
 {
@@ -2076,6 +2115,8 @@ int ath_tx_init(struct ath_softc *sc, int nbufs)
 		goto err;
 	}
 
+	INIT_DELAYED_WORK(&sc->tx_complete_work, ath_tx_complete_poll_work);
+
 err:
 	if (error != 0)
 		ath_tx_cleanup(sc);
-- 
1.6.0.4

