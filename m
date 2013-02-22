Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:55807 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753479Ab3BVCGx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Feb 2013 21:06:53 -0500
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@venema.h4ckr.net, Ben Greear <greearb@candelatech.com>
Subject: [RFC] ath9k:  Detect and work-around tx-queue hang.
Date: Thu, 21 Feb 2013 18:06:37 -0800
Message-Id: <1361498797-14361-1-git-send-email-greearb@candelatech.com> (sfid-20130222_030703_997605_22BE6ABD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

We see TX lockups on ar9380 NICs when running 32 stations
each with a 56kbps stream of MTU sized UDP packets.
We see lockups on the AP and also on the station, seems
random which hits first.

The test case further involves a programmable attenuator,
and the attenuation is taken from -30 to -85 signal level
in steps of 10db.  Each step runs for 1 minute before
increasing the attenuation.  The problem normally
shows up around signal level of -70 (noise is reported
as around -95).

When the lockup hits, it is typically on a single queue
(BE).  The symptom is that there is no obvious transmit
activity on that queue, the acq-depth and axq-ampdu-depth
are zero, the queue is stopped, and the pending-frames is
at or above the maximum allowed.  The VO queue continues
to function, and RX logic functions fine.

Just resetting the chip does not fix the problem:  The
pending-frames usually stays at max.  So, this patch also
adds hacks to force pending-frames to zero.  It also
quietens some warnings about pending-frame underruns
because sometimes, the tx status does appear many seconds
later.

Finally, the reset fixup code is logged at ath_err because
I think everyone should be aware of events like this.

We see the same problem with ath9k rate control and
minstrel-ht.  We have not tested other ath9k chipsets
in this manner.

Small numbers of high-speed stations do not hit this
problem, or at least not in our test cases.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    2 ++
 drivers/net/wireless/ath/ath9k/link.c  |   30 ++++++++++++++++++++++++++++--
 drivers/net/wireless/ath/ath9k/main.c  |    5 +++--
 drivers/net/wireless/ath/ath9k/xmit.c  |   15 ++++++++++++++-
 4 files changed, 47 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index d7897dcf..cc8d560 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -194,6 +194,7 @@ struct ath_txq {
 	u32 axq_ampdu_depth;
 	bool stopped;
 	bool axq_tx_inprogress;
+	bool clear_pending_frames_on_flush;
 	struct list_head axq_acq;
 	struct list_head txq_fifo[ATH_TXFIFO_DEPTH];
 	u8 txq_headidx;
@@ -684,6 +685,7 @@ struct ath_softc {
 	u16 curtxpow;
 	bool ps_enabled;
 	bool ps_idle;
+	bool reset_force_noretry;
 	short nbcnvifs;
 	short nvifs;
 	unsigned long ps_usecount;
diff --git a/drivers/net/wireless/ath/ath9k/link.c b/drivers/net/wireless/ath/ath9k/link.c
index 7b88b9c..b59565c 100644
--- a/drivers/net/wireless/ath/ath9k/link.c
+++ b/drivers/net/wireless/ath/ath9k/link.c
@@ -38,18 +38,44 @@ void ath_tx_complete_poll_work(struct work_struct *work)
 			if (txq->axq_depth) {
 				if (txq->axq_tx_inprogress) {
 					needreset = true;
+					ath_err(ath9k_hw_common(sc->sc_ah),
+						"tx hung, queue: %i axq-depth: %i, ampdu-depth: %i resetting the chip\n",
+						i, txq->axq_depth,
+						txq->axq_ampdu_depth);
 					ath_txq_unlock(sc, txq);
 					break;
 				} else {
 					txq->axq_tx_inprogress = true;
 				}
+			} else {
+				/* Check for software TX hang.  It seems
+				 * sometimes pending-frames is not properly
+				 * decremented, and the tx queue hangs.
+				 * Considered hung if:  axq-depth is zero,
+				 *  ampdu-depth is zero, queue-is-stopped,
+				 *  and we have pending frames.
+				 */
+				if (txq->stopped &&
+				    (txq->axq_ampdu_depth == 0) &&
+				    (txq->pending_frames > 0)) {
+					if (txq->axq_tx_inprogress) {
+						ath_err(ath9k_hw_common(sc->sc_ah),
+							"soft tx hang: queue: %i pending-frames: %i, resetting chip\n",
+							i, txq->pending_frames);
+						needreset = true;
+						txq->clear_pending_frames_on_flush = true;
+						sc->reset_force_noretry = true;
+						ath_txq_unlock(sc, txq);
+						break;
+					} else {
+						txq->axq_tx_inprogress = true;
+					}
+				}
 			}
 			ath_txq_unlock_complete(sc, txq);
 		}
 
 	if (needreset) {
-		ath_dbg(ath9k_hw_common(sc->sc_ah), RESET,
-			"tx hung, resetting the chip\n");
 		ath9k_queue_reset(sc, RESET_TYPE_TX_HANG);
 		return;
 	}
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 5c8758d..0de0e50 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -587,8 +587,9 @@ void ath9k_queue_reset(struct ath_softc *sc, enum ath_reset_type type)
 void ath_reset_work(struct work_struct *work)
 {
 	struct ath_softc *sc = container_of(work, struct ath_softc, hw_reset_work);
-
-	ath_reset(sc, true);
+	bool retry_tx = !sc->reset_force_noretry;
+	sc->reset_force_noretry = false;
+	ath_reset(sc, retry_tx);
 }
 
 /**********************/
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 741918a..093c77e 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1543,6 +1543,15 @@ void ath_draintxq(struct ath_softc *sc, struct ath_txq *txq, bool retry_tx)
 	if ((sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_HT) && !retry_tx)
 		ath_txq_drain_pending_buffers(sc, txq);
 
+	if (txq->clear_pending_frames_on_flush && (txq->pending_frames != 0)) {
+		ath_err(ath9k_hw_common(sc->sc_ah),
+			"Pending frames still exist on txq: %i after drain: %i  axq-depth: %i  ampdu-depth: %i\n",
+			txq->mac80211_qnum, txq->pending_frames, txq->axq_depth,
+			txq->axq_ampdu_depth);
+		txq->pending_frames = 0;
+	}
+	txq->clear_pending_frames_on_flush = false;
+
 	ath_txq_unlock_complete(sc, txq);
 }
 
@@ -2066,8 +2075,12 @@ static void ath_tx_complete(struct ath_softc *sc, struct sk_buff *skb,
 
 	q = skb_get_queue_mapping(skb);
 	if (txq == sc->tx.txq_map[q]) {
-		if (WARN_ON(--txq->pending_frames < 0))
+		if (--txq->pending_frames < 0) {
+			if (net_ratelimit())
+				ath_err(common, "txq: %p had negative pending_frames, q: %i\n",
+					txq, q);
 			txq->pending_frames = 0;
+		}
 
 		if (txq->stopped &&
 		    txq->pending_frames < sc->tx.txq_max_pending[q]) {
-- 
1.7.3.4

