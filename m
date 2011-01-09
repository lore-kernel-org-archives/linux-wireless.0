Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:58602 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764Ab1AIHqJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Jan 2011 02:46:09 -0500
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@venema.h4ckr.net, Ben Greear <greearb@candelatech.com>
Subject: [PATCH] ath9k:  Restart xmit logic in xmit watchdog.
Date: Sat,  8 Jan 2011 23:46:00 -0800
Message-Id: <1294559160-29298-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

The system can get into a state where the xmit queue
is stopped, but there are no packets pending, so
the queue will not be restarted.

Add logic to the xmit watchdog to attempt to restart
the xmit logic if this situation is detected.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---

NOTE:  This is basically the same as a patch I posted
a day or two ago.  It doesn't address the concern of the
reviewer who NACK'd it, but my system will not properly
transmit packets without this patch applied.  I realize
this is a bit of a hack, but until we find and fix all
of the other bugs, I think this patch or something similar
should be applied.

Still, this patch should not be applied unless given positive
ACK by the ath9k developers.

:100644 100644 93209d6... ca9d0d3... M	drivers/net/wireless/ath/ath9k/ath9k.h
:100644 100644 9e009cc... b0cb792... M	drivers/net/wireless/ath/ath9k/debug.c
:100644 100644 d9a4144... 1b3a62c... M	drivers/net/wireless/ath/ath9k/xmit.c
 drivers/net/wireless/ath/ath9k/ath9k.h |    1 +
 drivers/net/wireless/ath/ath9k/debug.c |    4 ++-
 drivers/net/wireless/ath/ath9k/xmit.c  |   57 +++++++++++++++++++++++++++-----
 3 files changed, 52 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 93209d6..ca9d0d3 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -630,6 +630,7 @@ struct ath_softc {
 	struct ath9k_debug debug;
 	spinlock_t nodes_lock;
 	struct list_head nodes; /* basically, stations */
+	unsigned int tx_complete_poll_work_seen;
 #endif
 	struct ath_beacon_config cur_beacon_conf;
 	struct delayed_work tx_complete_work;
diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 9e009cc..b0cb792 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -629,9 +629,11 @@ static ssize_t read_file_xmit(struct file *file, char __user *user_buf,
 	if (buf == NULL)
 		return -ENOMEM;
 
-	len += sprintf(buf, "Num-Tx-Queues: %i  tx-queues-setup: 0x%x\n"
+	len += sprintf(buf, "Num-Tx-Queues: %i  tx-queues-setup: 0x%x"
+		       " poll-work-seen: %u\n"
 		       "%30s %10s%10s%10s\n\n",
 		       ATH9K_NUM_TX_QUEUES, sc->tx.txqsetup,
+		       sc->tx_complete_poll_work_seen,
 		       "BE", "BK", "VI", "VO");
 
 	PR("MPDUs Queued:    ", queued);
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index d9a4144..1b3a62c 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1988,19 +1988,30 @@ static void ath_tx_rc_status(struct ath_buf *bf, struct ath_tx_status *ts,
 	tx_info->status.rates[tx_rateindex].count = ts->ts_longretry + 1;
 }
 
-static void ath_wake_mac80211_queue(struct ath_softc *sc, int qnum)
+/* Has no locking. */
+static void __ath_wake_mac80211_queue(struct ath_softc *sc, struct ath_txq *txq)
 {
-	struct ath_txq *txq;
-
-	txq = sc->tx.txq_map[qnum];
-	spin_lock_bh(&txq->axq_lock);
 	if (txq->stopped && txq->pending_frames < ATH_MAX_QDEPTH) {
-		if (ath_mac80211_start_queue(sc, qnum))
+		if (ath_mac80211_start_queue(sc, txq->axq_qnum))
 			txq->stopped = 0;
 	}
+}
+
+/* Has internal locking. */
+static void _ath_wake_mac80211_queue(struct ath_softc *sc, struct ath_txq *txq)
+{
+	spin_lock_bh(&txq->axq_lock);
+	__ath_wake_mac80211_queue(sc, txq);
 	spin_unlock_bh(&txq->axq_lock);
 }
 
+/* Has internal locking. */
+static void ath_wake_mac80211_queue(struct ath_softc *sc, int qnum)
+{
+	_ath_wake_mac80211_queue(sc, sc->tx.txq_map[qnum]);
+}
+
+
 static void ath_tx_processq(struct ath_softc *sc, struct ath_txq *txq)
 {
 	struct ath_hw *ah = sc->sc_ah;
@@ -2101,10 +2112,9 @@ static void ath_tx_processq(struct ath_softc *sc, struct ath_txq *txq)
 		else
 			ath_tx_complete_buf(sc, bf, txq, &bf_head, &ts, txok, 0);
 
-		if (txq == sc->tx.txq_map[qnum])
-			ath_wake_mac80211_queue(sc, qnum);
-
 		spin_lock_bh(&txq->axq_lock);
+		__ath_wake_mac80211_queue(sc, txq);
+
 		if (sc->sc_flags & SC_OP_TXAGGR)
 			ath_txq_schedule(sc, txq);
 		spin_unlock_bh(&txq->axq_lock);
@@ -2119,6 +2129,9 @@ static void ath_tx_complete_poll_work(struct work_struct *work)
 	int i;
 	bool needreset = false;
 	unsigned long timeout = msecs_to_jiffies(ATH_TX_COMPLETE_POLL_INT);
+#ifdef CONFIG_ATH9K_DEBUGFS
+	sc->tx_complete_poll_work_seen++;
+#endif
 
 	for (i = 0; i < ATH9K_NUM_TX_QUEUES; i++)
 		if (ATH_TXQ_SETUP(sc, i)) {
@@ -2137,6 +2150,32 @@ static void ath_tx_complete_poll_work(struct work_struct *work)
 					txq->axq_tx_inprogress = true;
 					txq->start_tx_timer = jiffies;
 				}
+			} else {
+				/* If the queue has pending buffers, then it
+				 * should be doing tx work (and have axq_depth).
+				 * Shouldn't get to this state I think..but
+				 * we do.
+				 */
+				if (!(sc->sc_flags & (SC_OP_OFFCHANNEL)) &&
+				    (txq->pending_frames > 0 ||
+				     !list_empty(&txq->axq_acq) ||
+				     txq->stopped)) {
+					ath_err(ath9k_hw_common(sc->sc_ah),
+						"txq: %p axq_qnum: %i,"
+						" axq_link: %p"
+						" pending frames: %i"
+						" axq_acq empty: %i"
+						" stopped: %i"
+						" axq_depth: 0  Attempting to"
+						" Restarting tx logic.\n",
+						txq, txq->axq_qnum,
+						txq->axq_link,
+						txq->pending_frames,
+						list_empty(&txq->axq_acq),
+						txq->stopped);
+					__ath_wake_mac80211_queue(sc, txq);
+					ath_txq_schedule(sc, txq);
+				}
 			}
 			spin_unlock_bh(&txq->axq_lock);
 		}
-- 
1.7.2.3

