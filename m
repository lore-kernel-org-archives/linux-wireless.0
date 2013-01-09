Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:55805 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757922Ab3AIPRF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jan 2013 10:17:05 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH v3 3.8 4/5] ath9k: add a better fix for the rx tasklet vs rx flush race
Date: Wed,  9 Jan 2013 16:16:55 +0100
Message-Id: <1357744616-63257-4-git-send-email-nbd@openwrt.org> (sfid-20130109_161713_737353_CFA7F5E0)
In-Reply-To: <1357744616-63257-3-git-send-email-nbd@openwrt.org>
References: <1357744616-63257-1-git-send-email-nbd@openwrt.org>
 <1357744616-63257-2-git-send-email-nbd@openwrt.org>
 <1357744616-63257-3-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ensure that the rx tasklet is no longer running when entering the reset path.
Also remove the distinction between flush and no-flush frame processing.
If a frame has been received and ACKed by the hardware, the stack needs to see
it, so that the BA receive window does not go out of sync.

Cc: stable@vger.kernel.org
Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |  1 -
 drivers/net/wireless/ath/ath9k/debug.c |  1 -
 drivers/net/wireless/ath/ath9k/debug.h |  2 --
 drivers/net/wireless/ath/ath9k/main.c  |  4 ++++
 drivers/net/wireless/ath/ath9k/recv.c  | 15 ---------------
 5 files changed, 4 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 7250107..f505b19 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -641,7 +641,6 @@ void ath_ant_comb_update(struct ath_softc *sc);
 enum sc_op_flags {
 	SC_OP_INVALID,
 	SC_OP_BEACONS,
-	SC_OP_RXFLUSH,
 	SC_OP_ANI_RUN,
 	SC_OP_PRIM_STA_VIF,
 	SC_OP_HW_RESET,
diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 13ff9ed..e585fc8 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -861,7 +861,6 @@ static ssize_t read_file_recv(struct file *file, char __user *user_buf,
 	RXS_ERR("RX-LENGTH-ERR", rx_len_err);
 	RXS_ERR("RX-OOM-ERR", rx_oom_err);
 	RXS_ERR("RX-RATE-ERR", rx_rate_err);
-	RXS_ERR("RX-DROP-RXFLUSH", rx_drop_rxflush);
 	RXS_ERR("RX-TOO-MANY-FRAGS", rx_too_many_frags_err);
 
 	PHY_ERR("UNDERRUN ERR", ATH9K_PHYERR_UNDERRUN);
diff --git a/drivers/net/wireless/ath/ath9k/debug.h b/drivers/net/wireless/ath/ath9k/debug.h
index 375c3b4..6df2ab6 100644
--- a/drivers/net/wireless/ath/ath9k/debug.h
+++ b/drivers/net/wireless/ath/ath9k/debug.h
@@ -216,7 +216,6 @@ struct ath_tx_stats {
  * @rx_oom_err:  No. of frames dropped due to OOM issues.
  * @rx_rate_err:  No. of frames dropped due to rate errors.
  * @rx_too_many_frags_err:  Frames dropped due to too-many-frags received.
- * @rx_drop_rxflush: No. of frames dropped due to RX-FLUSH.
  * @rx_beacons:  No. of beacons received.
  * @rx_frags:  No. of rx-fragements received.
  */
@@ -235,7 +234,6 @@ struct ath_rx_stats {
 	u32 rx_oom_err;
 	u32 rx_rate_err;
 	u32 rx_too_many_frags_err;
-	u32 rx_drop_rxflush;
 	u32 rx_beacons;
 	u32 rx_frags;
 };
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index e1fa705..6d04654 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -196,6 +196,8 @@ static bool ath_prepare_reset(struct ath_softc *sc, bool retry_tx, bool flush)
 	ath9k_debug_samp_bb_mac(sc);
 	ath9k_hw_disable_interrupts(ah);
 
+	tasklet_disable(&sc->intr_tq);
+
 	if (!ath_stoprecv(sc))
 		ret = false;
 
@@ -210,6 +212,8 @@ static bool ath_prepare_reset(struct ath_softc *sc, bool retry_tx, bool flush)
 		ath_flushrecv(sc);
 	}
 
+	tasklet_enable(&sc->intr_tq);
+
 	return ret;
 }
 
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 8fb6d3b..8ce83f2 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -280,7 +280,6 @@ int ath_rx_init(struct ath_softc *sc, int nbufs)
 
 	spin_lock_init(&sc->sc_pcu_lock);
 	spin_lock_init(&sc->rx.rxbuflock);
-	clear_bit(SC_OP_RXFLUSH, &sc->sc_flags);
 
 	common->rx_bufsize = IEEE80211_MAX_MPDU_LEN / 2 +
 			     sc->sc_ah->caps.rx_status_len;
@@ -492,11 +491,9 @@ bool ath_stoprecv(struct ath_softc *sc)
 
 void ath_flushrecv(struct ath_softc *sc)
 {
-	set_bit(SC_OP_RXFLUSH, &sc->sc_flags);
 	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_EDMA)
 		ath_rx_tasklet(sc, 1, true);
 	ath_rx_tasklet(sc, 1, false);
-	clear_bit(SC_OP_RXFLUSH, &sc->sc_flags);
 }
 
 static bool ath_beacon_dtim_pending_cab(struct sk_buff *skb)
@@ -1058,9 +1055,6 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 
 	do {
 		bool decrypt_error = false;
-		/* If handling rx interrupt and flush is in progress => exit */
-		if (test_bit(SC_OP_RXFLUSH, &sc->sc_flags) && (flush == 0))
-			break;
 
 		memset(&rs, 0, sizeof(rs));
 		if (edma)
@@ -1103,15 +1097,6 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 
 		ath_debug_stat_rx(sc, &rs);
 
-		/*
-		 * If we're asked to flush receive queue, directly
-		 * chain it back at the queue without processing it.
-		 */
-		if (test_bit(SC_OP_RXFLUSH, &sc->sc_flags)) {
-			RX_STAT_INC(rx_drop_rxflush);
-			goto requeue_drop_frag;
-		}
-
 		memset(rxs, 0, sizeof(struct ieee80211_rx_status));
 
 		rxs->mactime = (tsf & ~0xffffffffULL) | rs.rs_tstamp;
-- 
1.8.0.2

