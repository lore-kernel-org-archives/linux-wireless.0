Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:28714 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755776Ab1BIO4Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Feb 2011 09:56:24 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 09 Feb 2011 06:56:03 -0800
From: Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>
To: Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 9 Feb 2011 20:24:28 +0530
Subject: RE: [RFC] ath9k: Implement op_flush()
Message-ID: <44EE5C37ADC36343B0625A05DD408C4850DAA785D0@CHEXMB-01.global.atheros.com>
References: <1297259390-8973-1-git-send-email-vasanth@atheros.com>
In-Reply-To: <1297259390-8973-1-git-send-email-vasanth@atheros.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


________________________________________
From: linux-wireless-owner@vger.kernel.org [linux-wireless-owner@vger.kernel.org] On Behalf Of Vasanthakumar Thiagarajan [vasanth@atheros.com]
Sent: Wednesday, February 09, 2011 5:49 AM
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [RFC] ath9k: Implement op_flush()

When op_flush() is called with no drop (drop=false), the driver
tries to tx as many frames as possible in 100ms on every hw queue.
During this time period frames from sw queue are also scheduled on
to respective hw queue.

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    1 +
 drivers/net/wireless/ath/ath9k/main.c  |   72 ++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/xmit.c  |   27 +++++++-----
 3 files changed, 89 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 9272278..704521f 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -192,6 +192,7 @@ struct ath_txq {
        u32 axq_ampdu_depth;
        bool stopped;
        bool axq_tx_inprogress;
+       bool txq_flush_inprogress;
        struct list_head axq_acq;
        struct list_head txq_fifo[ATH_TXFIFO_DEPTH];
        struct list_head txq_fifo_pending;
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 4ed43b2..cd07779 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -53,6 +53,21 @@ static u8 parse_mpdudensity(u8 mpdudensity)
        }
 }

+static bool ath9k_is_pending_frames(struct ath_softc *sc, struct ath_txq *txq)
+{
+       bool pending = false;
+
+       spin_lock_bh(&txq->axq_lock);
+
+       if (txq->axq_depth || !list_empty(&txq->axq_acq))
+               pending = true;
+       else if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_EDMA)
+               pending = !list_empty(&txq->txq_fifo_pending);
+
+       spin_unlock_bh(&txq->axq_lock);
+       return pending;
+}
+
 bool ath9k_setpower(struct ath_softc *sc, enum ath9k_power_mode mode)
 {
        unsigned long flags;
@@ -2122,6 +2137,62 @@ static void ath9k_set_coverage_class(struct ieee80211_hw *hw, u8 coverage_class)
        mutex_unlock(&sc->mutex);
 }

+static void ath9k_flush(struct ieee80211_hw *hw, bool drop)
+{
+#define ATH_FLUSH_TIMEOUT      100 /* ms */
+       struct ath_softc *sc = hw->priv;
+       struct ath_txq *txq;
+       struct ath_hw *ah = sc->sc_ah;
+       struct ath_common *common = ath9k_hw_common(ah);
+       int i, j, npend = 0;
+
+       mutex_lock(&sc->mutex);
+
+       cancel_delayed_work_sync(&sc->tx_complete_work);
+
+       for (i = 0; i < ATH9K_NUM_TX_QUEUES; i++) {
+               if (!ATH_TXQ_SETUP(sc, i))
+                       continue;
+               txq = &sc->tx.txq[i];
+
+               if (!drop) {
+                       for (j = 0; j < ATH_FLUSH_TIMEOUT; i++) {

of course it is j++, fixed it locally but forgot to integrate.





