Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:60175 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750786Ab1B1FO0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Feb 2011 00:14:26 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sun, 27 Feb 2011 21:14:04 -0800
Date: Mon, 28 Feb 2011 10:44:39 +0530
From: Senthil Balasubramanian <senthilkumar@atheros.com>
To: Denis 'GNUtoo' Carikli <GNUtoo@no-log.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: ath9k stopped queue bug
Message-ID: <20110228051439.GB6441@ksenthil-lnx.users.atheros.com>
References: <1298390485.2575.6.camel@gnutoo-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1298390485.2575.6.camel@gnutoo-laptop>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 22, 2011 at 09:31:24PM +0530, Denis 'GNUtoo' Carikli wrote:
> Hi,
> 
> When I transfer large files at high speed(rsync to my x86 router,
> locally, not trough the Internet) I get:
> ping: sendmsg: No buffer space available
> 
> And I can't send anymore data.
> 
> /sys/kernel/debug/ieee80211/phy*/queues is 
> 00: 0x00000000/0
> 01: 0x00000000/0
> 02: 0x00000000/0
> 03: 0x00000000/0
> In normal conditions.
> 
> But when I can't send anymore data I've that:
> 00: 0x00000000/0
> 01: 0x00000000/0
> 02: 0x00000001/0
> 03: 0x00000000/0
> or that:
> 00: 0x00000000/0
> 01: 0x00000000/0
> 02: 0x00000001/333
> 03: 0x00000000/0
As Johannes has pointed out it is an issue with the driver and already addressed
in wireless-testing (commit 92460412367c00e97f99babdb898d0930ce604fc). I have
ported this commit to 2.6.37 kernel for your reference.. and I believe we
should push this patch down to stable kernel also as running with NM can cause
this issue.

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index da5c645..f6a2a19 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -292,6 +292,7 @@ int ath_set_channel(struct ath_softc *sc, struct ieee80211_hw *hw,
 	}
 
  ps_restore:
+	ieee80211_wake_queues(hw);
 	spin_unlock_bh(&sc->sc_pcu_lock);
 
 	ath9k_ps_restore(sc);
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 07b7804..3751e92 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1205,8 +1205,17 @@ bool ath_drain_all_txq(struct ath_softc *sc, bool retry_tx)
 		ath_err(common, "Failed to stop TX DMA!\n");
 
 	for (i = 0; i < ATH9K_NUM_TX_QUEUES; i++) {
-		if (ATH_TXQ_SETUP(sc, i))
-			ath_draintxq(sc, &sc->tx.txq[i], retry_tx);
+		if (!ATH_TXQ_SETUP(sc, i))
+			continue;
+
+		/*
+		 * The caller will resume queues with ieee80211_wake_queues.
+		 * Mark the queue as not stopped to prevent ath_tx_complete
+		 * from waking the queue too early.
+		 */
+		txq = &sc->tx.txq[i];
+		txq->stopped = false;
+		ath_draintxq(sc, txq, retry_tx);
 	}
 
 	return !npend;
@@ -1860,6 +1869,11 @@ static void ath_tx_complete(struct ath_softc *sc, struct sk_buff *skb,
 			spin_lock_bh(&txq->axq_lock);
 			if (WARN_ON(--txq->pending_frames < 0))
 				txq->pending_frames = 0;
+			if (txq->stopped &&
+					txq->pending_frames < ATH_MAX_QDEPTH) {
+				if (ath_mac80211_start_queue(sc, q))
+					txq->stopped = 0;
+			}
 			spin_unlock_bh(&txq->axq_lock);
 		}
 
@@ -1971,19 +1985,6 @@ static void ath_tx_rc_status(struct ath_buf *bf, struct ath_tx_status *ts,
 	tx_info->status.rates[tx_rateindex].count = ts->ts_longretry + 1;
 }
 
-static void ath_wake_mac80211_queue(struct ath_softc *sc, int qnum)
-{
-	struct ath_txq *txq;
-
-	txq = sc->tx.txq_map[qnum];
-	spin_lock_bh(&txq->axq_lock);
-	if (txq->stopped && txq->pending_frames < ATH_MAX_QDEPTH) {
-		if (ath_mac80211_start_queue(sc, qnum))
-			txq->stopped = 0;
-	}
-	spin_unlock_bh(&txq->axq_lock);
-}
-
 static void ath_tx_processq(struct ath_softc *sc, struct ath_txq *txq)
 {
 	struct ath_hw *ah = sc->sc_ah;
@@ -2081,9 +2082,6 @@ static void ath_tx_processq(struct ath_softc *sc, struct ath_txq *txq)
 		else
 			ath_tx_complete_buf(sc, bf, txq, &bf_head, &ts, txok, 0);
 
-		if (txq == sc->tx.txq_map[qnum])
-			ath_wake_mac80211_queue(sc, qnum);
-
 		spin_lock_bh(&txq->axq_lock);
 		if (sc->sc_flags & SC_OP_TXAGGR)
 			ath_txq_schedule(sc, txq);
@@ -2205,9 +2203,6 @@ void ath_tx_edma_tasklet(struct ath_softc *sc)
 			ath_tx_complete_buf(sc, bf, txq, &bf_head,
 					    &txs, txok, 0);
 
-		if (txq == sc->tx.txq_map[qnum])
-			ath_wake_mac80211_queue(sc, qnum);
-
 		spin_lock_bh(&txq->axq_lock);
 		if (!list_empty(&txq->txq_fifo_pending)) {
 			INIT_LIST_HEAD(&bf_head);

> 
> 
> Here's my irc conversation in #linux-wireless on Freeenode about that
> issue:
> 
> Feb 22 16:28:38 <GNUtoo|laptop>	hi,
> Feb 22 16:29:23 <GNUtoo|laptop>	when I rsync to my router at high speed
> over wifi, huge amount of data, I've that:
> Feb 22 16:29:24 <GNUtoo|laptop>	ping: sendmsg: No buffer space available
> Feb 22 16:29:27 <GNUtoo|laptop>	and wifi breaks
> Feb 22 16:29:30 <GNUtoo|laptop>	I've to reconnect
> Feb 22 16:29:40 <GNUtoo|laptop>	should I try setting a lower MTU?
> Feb 22 16:29:43 <GNUtoo|laptop>	what should I try?
> Feb 22 16:29:53 <GNUtoo|laptop>	and why isn't there any more buffer
> space?
> Feb 22 16:31:57 <johill>	sounds like a queue management bug
> Feb 22 16:32:06 <johill>	with packets stuck somewhere
> Feb 22 16:32:09 <johill>	what driver?
> Feb 22 16:34:04 *	an-t (~ant@srv1.gnpx.net) has joined #linux-wireless
> Feb 22 16:34:42 <GNUtoo|laptop>	ath9k
> Feb 22 16:34:51 <GNUtoo|laptop>	on 2.6.37-020637-generic
> Feb 22 16:34:57 <GNUtoo|laptop>	I think that's mainline
> Feb 22 16:35:01 <GNUtoo|laptop>	let me check
> Feb 22 16:35:02 <johill>	hm, dunno
> Feb 22 16:35:09 <johill>	there were some queue mgmt things there
> Feb 22 16:35:12 <johill>	don't really konw
> Feb 22 16:35:49 <Chainsaw>	GNUtoo|laptop: Probably useful to share your
> driver DDoS on linux-wireless; some idea of how many files & what size.
> Feb 22 16:36:10 <GNUtoo|laptop>	basically what I do is that:
> Feb 22 16:36:20 <GNUtoo|laptop>	I use openembedded to cross-compile
> files
> Feb 22 16:36:25 <GNUtoo|laptop>	and sync the result with my router
> Feb 22 16:36:26 *	Blues-Man
> (~bluesman@host137-190-dynamic.43-79-r.retail.telecomitalia.it) has
> joined #linux-wireless
> Feb 22 16:36:35 <GNUtoo|laptop>	that is an x86 computer with ath9k and
> hostapd
> Feb 22 16:36:52 <GNUtoo|laptop>
> cd /home/gnutoo/embedded/oe/oetmps/eee701/deploy/glibc
> Feb 22 16:36:56 <GNUtoo|laptop>	rsync -av -e "ssh -l gnutoo -p 222" *
> router:/var/www/gnutoo.homelinux.org/openembedded/eee701
> Feb 22 16:37:05 <GNUtoo|laptop>	is the script I use to sync it
> Feb 22 16:37:37 <johill>	I bet when this happens you never get a ping
> pcket through
> Feb 22 16:38:10 <johill>	and /sys/kernel/debug/ieee80211/phy*/queues is
> non-zero
> Feb 22 16:38:18 <johill>	the info from that file would be useful
> Feb 22 16:38:37 <GNUtoo|laptop>	ok I was pastebining the file sizes
> Feb 22 16:38:41 <GNUtoo|laptop>	as there are a lot of files....
> Feb 22 16:39:06 <GNUtoo|laptop>	ok I'll try to reproduce
> Feb 22 16:39:13 <GNUtoo|laptop>	tough that will disconnect me from irc
> Feb 22 16:40:54 <johill>	I bet it'll be 0x0001/n
> Feb 22 16:40:56 <johill>	n > 0
> Feb 22 16:42:16 <GNUtoo|laptop>	ping also increase during the huge
> transfer
> Feb 22 16:42:30 <johill>	that's "bufferbloat" but expected now
> Feb 22 16:42:35 <GNUtoo|laptop>	ok
> Feb 22 16:42:49 <GNUtoo|laptop>	I learned what bufferbloat was not so
> long ago
> Feb 22 16:44:27 *	Topic for #linux-wireless is: User-level discussions
> about wireless LANs on Linux | compat-wireless-2.6 only available for
> kernels >= 2.6.27, work is underway to enable older kernels now that we
> don't use multiqueue on mac80211
> Feb 22 16:44:27 *	Topic for #linux-wireless set by linville at Wed Jul
> 8 21:06:20 2009
> Feb 22 16:44:30 <GNUtoo|laptop>	it starts with
> Feb 22 16:44:32 <GNUtoo|laptop>	02: 0x00000001/0
> Feb 22 16:44:41 <GNUtoo|laptop>	and then increase to
> Feb 22 16:44:47 <GNUtoo|laptop>	02: 0x00000001/333
> Feb 22 16:44:50 <GNUtoo|laptop>	the reset is 0
> Feb 22 16:45:02 <johill>	yeah
> Feb 22 16:45:06 <johill>	as expected
> Feb 22 16:45:08 <GNUtoo|laptop>	ok
> Feb 22 16:45:12 <GNUtoo|laptop>	what's that exactly?
> Feb 22 16:45:19 <johill>	the reason why the queue is stopped
> Feb 22 16:45:23 <johill>	and the number of packets in the queue
> Feb 22 16:45:24 <GNUtoo|laptop>	oh nice
> Feb 22 16:45:32 <johill>	0x000 == not stopped
> Feb 22 16:45:35 <GNUtoo|laptop>	ok
> Feb 22 16:45:39 <GNUtoo|laptop>	and what's the reason?
> Feb 22 16:45:41 <johill>	 /0 = no packets
> Feb 22 16:45:54 <johill>	BIT(0) == driver asked for queue to be stopped
> Feb 22 16:46:03 <johill>	(IEEE80211_QUEUE_STOP_REASON_DRIVER)
> Feb 22 16:46:08 <GNUtoo|laptop>	ok
> Feb 22 16:46:11 <johill>	(net/mac80211/ieee80211_i.h)
> Feb 22 16:46:15 <johill>	so driver's fault
> Feb 22 16:46:28 <GNUtoo|laptop>	dmesg shows nothing tough
> Feb 22 16:46:37 <GNUtoo|laptop>	only normal stuff
> Feb 22 16:46:38 <johill>	yeah not surprising either
> Feb 22 16:46:45 <GNUtoo|laptop>	ah debugfs?
> Feb 22 16:46:47 <johill>	queue start/stop happens often enough, no
> logging for it
> Feb 22 16:46:50 <GNUtoo|laptop>	or something like that should be used
> Feb 22 16:46:50 <GNUtoo|laptop>	ok
> Feb 22 16:49:45 <GNUtoo|laptop>	what should I do now?
> Feb 22 16:50:10 <johill>	report a bug on ath9k
> 
> Denis.
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
