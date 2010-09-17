Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30t.wh2.ocn.ne.jp ([125.206.180.136]:23497 "HELO
	mail30t.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754700Ab0IQCgg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Sep 2010 22:36:36 -0400
Received: from vs3011.wh2.ocn.ne.jp (125.206.180.239)
	by mail30t.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 4-012131994
	for <linux-wireless@vger.kernel.org>; Fri, 17 Sep 2010 11:36:34 +0900 (JST)
Subject: [PATCH 07/11] ath5k: Add watchdog for stuck TX queues
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Date: Fri, 17 Sep 2010 11:36:56 +0900
Message-ID: <20100917023656.24997.24132.stgit@tt-desk>
In-Reply-To: <20100917023543.24997.48466.stgit@tt-desk>
References: <20100917023543.24997.48466.stgit@tt-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since we do not know any better solution to the problem that TX queues can get
stuck, this adds a timer-based watchdog, which will check for stuck queues and
reset the hardware if necessary.

Ported from ath9k commit 164ace38536849966ffa377b1b1132993a5a375d.

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 drivers/net/wireless/ath/ath5k/ath5k.h |    2 +
 drivers/net/wireless/ath/ath5k/base.c  |   51 ++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath5k/base.h  |    3 ++
 3 files changed, 56 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
index 50209ae..9475b21 100644
--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -206,6 +206,8 @@
 #define ATH5K_TUNE_CALIBRATION_INTERVAL_ANI	1000	/* 1 sec */
 #define ATH5K_TUNE_CALIBRATION_INTERVAL_NF	60000	/* 60 sec */
 
+#define ATH5K_TX_COMPLETE_POLL_INT		3000	/* 3 sec */
+
 #define AR5K_INIT_CARR_SENSE_EN			1
 
 /*Swap RX/TX Descriptor for big endian archs*/
diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index eba2e74..d13df7a 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -895,6 +895,7 @@ ath5k_txq_setup(struct ath5k_softc *sc,
 		spin_lock_init(&txq->lock);
 		txq->setup = true;
 		txq->txq_len = 0;
+		txq->txq_poll_mark = false;
 	}
 	return &sc->txqs[qnum];
 }
@@ -993,6 +994,7 @@ ath5k_txq_drainq(struct ath5k_softc *sc, struct ath5k_txq *txq)
 		spin_unlock_bh(&sc->txbuflock);
 	}
 	txq->link = NULL;
+	txq->txq_poll_mark = false;
 	spin_unlock_bh(&txq->lock);
 }
 
@@ -1620,6 +1622,8 @@ ath5k_tx_processq(struct ath5k_softc *sc, struct ath5k_txq *txq)
 		sc->txbuf_len++;
 		txq->txq_len--;
 		spin_unlock(&sc->txbuflock);
+
+		txq->txq_poll_mark = false;
 	}
 	if (likely(list_empty(&txq->q)))
 		txq->link = NULL;
@@ -2174,6 +2178,46 @@ ath5k_tasklet_ani(unsigned long data)
 }
 
 
+static void
+ath5k_tx_complete_poll_work(struct work_struct *work)
+{
+	struct ath5k_softc *sc = container_of(work, struct ath5k_softc,
+			tx_complete_work.work);
+	struct ath5k_txq *txq;
+	int i;
+	bool needreset = false;
+
+	for (i = 0; i < ARRAY_SIZE(sc->txqs); i++) {
+		if (sc->txqs[i].setup) {
+			txq = &sc->txqs[i];
+			spin_lock_bh(&txq->lock);
+			if (txq->txq_len > 0) {
+				if (txq->txq_poll_mark) {
+					ATH5K_DBG(sc, ATH5K_DEBUG_XMIT,
+						  "TX queue stuck %d\n",
+						  txq->qnum);
+					needreset = true;
+					spin_unlock_bh(&txq->lock);
+					break;
+				} else {
+					txq->txq_poll_mark = true;
+				}
+			}
+			spin_unlock_bh(&txq->lock);
+		}
+	}
+
+	if (needreset) {
+		ATH5K_DBG(sc, ATH5K_DEBUG_RESET,
+			  "TX queues stuck, resetting\n");
+		ath5k_reset(sc, sc->curchan);
+	}
+
+	ieee80211_queue_delayed_work(sc->hw, &sc->tx_complete_work,
+		msecs_to_jiffies(ATH5K_TX_COMPLETE_POLL_INT));
+}
+
+
 /*************************\
 * Initialization routines *
 \*************************/
@@ -2265,6 +2309,10 @@ ath5k_init(struct ath5k_softc *sc)
 done:
 	mmiowb();
 	mutex_unlock(&sc->lock);
+
+	ieee80211_queue_delayed_work(sc->hw, &sc->tx_complete_work,
+			msecs_to_jiffies(ATH5K_TX_COMPLETE_POLL_INT));
+
 	return ret;
 }
 
@@ -2323,6 +2371,8 @@ ath5k_stop_hw(struct ath5k_softc *sc)
 
 	stop_tasklets(sc);
 
+	cancel_delayed_work_sync(&sc->tx_complete_work);
+
 	ath5k_rfkill_hw_stop(sc->ah);
 
 	return ret;
@@ -2509,6 +2559,7 @@ ath5k_attach(struct pci_dev *pdev, struct ieee80211_hw *hw)
 	tasklet_init(&sc->ani_tasklet, ath5k_tasklet_ani, (unsigned long)sc);
 
 	INIT_WORK(&sc->reset_work, ath5k_reset_work);
+	INIT_DELAYED_WORK(&sc->tx_complete_work, ath5k_tx_complete_poll_work);
 
 	ret = ath5k_eeprom_read_mac(ah, mac);
 	if (ret) {
diff --git a/drivers/net/wireless/ath/ath5k/base.h b/drivers/net/wireless/ath/ath5k/base.h
index 5e2366d..d8e2674 100644
--- a/drivers/net/wireless/ath/ath5k/base.h
+++ b/drivers/net/wireless/ath/ath5k/base.h
@@ -87,6 +87,7 @@ struct ath5k_txq {
 	spinlock_t		lock;	/* lock on q and link */
 	bool			setup;
 	int			txq_len; /* number of queued buffers */
+	bool			txq_poll_mark;
 };
 
 #define ATH5K_LED_MAX_NAME_LEN 31
@@ -233,6 +234,8 @@ struct ath5k_softc {
 
 	struct ath5k_ani_state	ani_state;
 	struct tasklet_struct	ani_tasklet;	/* ANI calibration */
+
+	struct delayed_work	tx_complete_work;
 };
 
 #define ath5k_hw_hasbssidmask(_ah) \

