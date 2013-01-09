Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:55806 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757938Ab3AIPRF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jan 2013 10:17:05 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH v3 3.8 5/5] ath9k: fix rx flush handling
Date: Wed,  9 Jan 2013 16:16:56 +0100
Message-Id: <1357744616-63257-5-git-send-email-nbd@openwrt.org> (sfid-20130109_161711_306150_9191AA97)
In-Reply-To: <1357744616-63257-4-git-send-email-nbd@openwrt.org>
References: <1357744616-63257-1-git-send-email-nbd@openwrt.org>
 <1357744616-63257-2-git-send-email-nbd@openwrt.org>
 <1357744616-63257-3-git-send-email-nbd@openwrt.org>
 <1357744616-63257-4-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Right now the rx flush is not doing anything useful on AR9003+, as it only
works if the buffers in the rx FIFO have not been purged yet, as is done
by ath_stoprecv.

To fix this, always call ath_flushrecv from within ath_stoprecv before
the FIFO is emptied, but still after the hw receive path has been stopped.

This ensures that frames received (and ACKed by the hardware) shortly before
a reset will be seen by the software, which should improve A-MPDU session
stability.

Cc: stable@vger.kernel.org
Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |  1 -
 drivers/net/wireless/ath/ath9k/main.c  | 16 +++-------------
 drivers/net/wireless/ath/ath9k/recv.c  | 16 +++++++++-------
 3 files changed, 12 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index f505b19..49923fb 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -324,7 +324,6 @@ struct ath_rx {
 
 int ath_startrecv(struct ath_softc *sc);
 bool ath_stoprecv(struct ath_softc *sc);
-void ath_flushrecv(struct ath_softc *sc);
 u32 ath_calcrxfilter(struct ath_softc *sc);
 int ath_rx_init(struct ath_softc *sc, int nbufs);
 void ath_rx_cleanup(struct ath_softc *sc);
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 6d04654..eced021 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -182,7 +182,7 @@ static void ath_restart_work(struct ath_softc *sc)
 	ath_start_ani(sc);
 }
 
-static bool ath_prepare_reset(struct ath_softc *sc, bool retry_tx, bool flush)
+static bool ath_prepare_reset(struct ath_softc *sc, bool retry_tx)
 {
 	struct ath_hw *ah = sc->sc_ah;
 	bool ret = true;
@@ -204,14 +204,6 @@ static bool ath_prepare_reset(struct ath_softc *sc, bool retry_tx, bool flush)
 	if (!ath_drain_all_txq(sc, retry_tx))
 		ret = false;
 
-	if (!flush) {
-		if (ah->caps.hw_caps & ATH9K_HW_CAP_EDMA)
-			ath_rx_tasklet(sc, 1, true);
-		ath_rx_tasklet(sc, 1, false);
-	} else {
-		ath_flushrecv(sc);
-	}
-
 	tasklet_enable(&sc->intr_tq);
 
 	return ret;
@@ -266,7 +258,6 @@ static int ath_reset_internal(struct ath_softc *sc, struct ath9k_channel *hchan,
 	struct ath_common *common = ath9k_hw_common(ah);
 	struct ath9k_hw_cal_data *caldata = NULL;
 	bool fastcc = true;
-	bool flush = false;
 	int r;
 
 	__ath_cancel_work(sc);
@@ -280,11 +271,10 @@ static int ath_reset_internal(struct ath_softc *sc, struct ath9k_channel *hchan,
 
 	if (!hchan) {
 		fastcc = false;
-		flush = true;
 		hchan = ah->curchan;
 	}
 
-	if (!ath_prepare_reset(sc, retry_tx, flush))
+	if (!ath_prepare_reset(sc, retry_tx))
 		fastcc = false;
 
 	ath_dbg(common, CONFIG, "Reset to %u MHz, HT40: %d fastcc: %d\n",
@@ -808,7 +798,7 @@ static void ath9k_stop(struct ieee80211_hw *hw)
 		ath9k_hw_cfg_gpio_input(ah, ah->led_pin);
 	}
 
-	ath_prepare_reset(sc, false, true);
+	ath_prepare_reset(sc, false);
 
 	if (sc->rx.frag) {
 		dev_kfree_skb_any(sc->rx.frag);
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 8ce83f2..235bdc0 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -463,6 +463,13 @@ start_recv:
 	return 0;
 }
 
+static void ath_flushrecv(struct ath_softc *sc)
+{
+	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_EDMA)
+		ath_rx_tasklet(sc, 1, true);
+	ath_rx_tasklet(sc, 1, false);
+}
+
 bool ath_stoprecv(struct ath_softc *sc)
 {
 	struct ath_hw *ah = sc->sc_ah;
@@ -473,6 +480,8 @@ bool ath_stoprecv(struct ath_softc *sc)
 	ath9k_hw_setrxfilter(ah, 0);
 	stopped = ath9k_hw_stopdmarecv(ah, &reset);
 
+	ath_flushrecv(sc);
+
 	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_EDMA)
 		ath_edma_stop_recv(sc);
 	else
@@ -489,13 +498,6 @@ bool ath_stoprecv(struct ath_softc *sc)
 	return stopped && !reset;
 }
 
-void ath_flushrecv(struct ath_softc *sc)
-{
-	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_EDMA)
-		ath_rx_tasklet(sc, 1, true);
-	ath_rx_tasklet(sc, 1, false);
-}
-
 static bool ath_beacon_dtim_pending_cab(struct sk_buff *skb)
 {
 	/* Check whether the Beacon frame has DTIM indicating buffered bc/mc */
-- 
1.8.0.2

