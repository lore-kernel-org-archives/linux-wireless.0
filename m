Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:32114 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751787Ab0JOXVm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Oct 2010 19:21:42 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 15 Oct 2010 16:21:33 -0700
Date: Fri, 15 Oct 2010 16:21:40 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Luis Rodriguez <Luis.Rodriguez@Atheros.com>
CC: Ben Greear <greearb@candelatech.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: memory clobber in rx path, maybe related to ath9k.
Message-ID: <20101015232140.GA1796@tux>
References: <AANLkTi=pp2Ob06YCi6GsR9rtRaDWPP95n2M72qWLdbwM@mail.gmail.com>
 <20101014225150.GB15740@tux>
 <20101014231958.GA3242@tux>
 <4CB79299.7000005@candelatech.com>
 <AANLkTinQmE6wm1pXkRL6p_3rkMvNrppmirjj3-jagMp8@mail.gmail.com>
 <20101014234853.GA10113@tux>
 <4CB886AF.3070800@candelatech.com>
 <AANLkTinhFj_iYjVzyfSfpUVdytfk4O9kCBnN8=Bwv0N7@mail.gmail.com>
 <4CB8AD3F.50201@candelatech.com>
 <20101015210720.GA2007@tux>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20101015210720.GA2007@tux>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben, please give this patch a shot. I addresses three races on the PCU:

  * When we were stopping the CPU for non-EDMA cards we never locked against
    anything starting the PCU again

  * ath9k_hw_startpcureceive() was being called without locking

  * Although we lock on the rxbuf lock for contention against starting/stopping
    the PCU, we also need to lock on the driver in locations where we start/stop
    the PCU within the same location otherwise we end up in inconsistant states
    and the hardware may end up proessing an incorrect buffer for DMA. To
    protect against this we use a new PCU lock on the main part of the driver to
    ensure each start/stop/reset operation is done atomically.

And fixes one issue as a side effect:

  * No more packet loss on ping flood when you have one STA associated :)

The only issue I see with this is I eventually run out of memory and my box
becomes useless, unless I am mistaking that for some other issue.

Please give this a shot and if it cures your woes I'll split it up into
3 separate patches, or maybe just two, one for the first two and one for
the last issue.

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 0c917e5..efee63c 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -312,6 +312,7 @@ struct ath_rx {
 	unsigned int rxfilter;
 	spinlock_t rxflushlock;
 	spinlock_t rxbuflock;
+	spinlock_t pcu_lock;
 	struct list_head rxbuf;
 	struct ath_descdma rxdma;
 	struct ath_buf *rx_bufptr;
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 62294da..6fbfe28 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -251,6 +251,9 @@ int ath_set_channel(struct ath_softc *sc, struct ieee80211_hw *hw,
 	 */
 	ath9k_hw_set_interrupts(ah, 0);
 	ath_drain_all_txq(sc, false);
+
+	spin_lock_bh(&sc->rx.pcu_lock);
+
 	stopped = ath_stoprecv(sc);
 
 	/* XXX: do not flush receive queue here. We don't want
@@ -278,6 +281,7 @@ int ath_set_channel(struct ath_softc *sc, struct ieee80211_hw *hw,
 			  "reset status %d\n",
 			  channel->center_freq, r);
 		spin_unlock_bh(&sc->sc_resetlock);
+		spin_unlock_bh(&sc->rx.pcu_lock);
 		goto ps_restore;
 	}
 	spin_unlock_bh(&sc->sc_resetlock);
@@ -286,9 +290,12 @@ int ath_set_channel(struct ath_softc *sc, struct ieee80211_hw *hw,
 		ath_print(common, ATH_DBG_FATAL,
 			  "Unable to restart recv logic\n");
 		r = -EIO;
+		spin_unlock_bh(&sc->rx.pcu_lock);
 		goto ps_restore;
 	}
 
+	spin_unlock_bh(&sc->rx.pcu_lock);
+
 	ath_cache_conf_rate(sc, &hw->conf);
 	ath_update_txpow(sc);
 	ath9k_hw_set_interrupts(ah, ah->imask);
@@ -626,12 +633,16 @@ void ath9k_tasklet(unsigned long data)
 	if (status & rxmask) {
 		spin_lock_bh(&sc->rx.rxflushlock);
 
+		spin_lock_bh(&sc->rx.pcu_lock);
+
 		/* Check for high priority Rx first */
 		if ((ah->caps.hw_caps & ATH9K_HW_CAP_EDMA) &&
 		    (status & ATH9K_INT_RXHP))
 			ath_rx_tasklet(sc, 0, true);
 
 		ath_rx_tasklet(sc, 0, false);
+		spin_unlock_bh(&sc->rx.pcu_lock);
+
 		spin_unlock_bh(&sc->rx.rxflushlock);
 	}
 
@@ -887,6 +898,7 @@ void ath_radio_enable(struct ath_softc *sc, struct ieee80211_hw *hw)
 	if (!ah->curchan)
 		ah->curchan = ath_get_curchannel(sc, sc->hw);
 
+	spin_lock_bh(&sc->rx.pcu_lock);
 	spin_lock_bh(&sc->sc_resetlock);
 	r = ath9k_hw_reset(ah, ah->curchan, ah->caldata, false);
 	if (r) {
@@ -901,8 +913,10 @@ void ath_radio_enable(struct ath_softc *sc, struct ieee80211_hw *hw)
 	if (ath_startrecv(sc) != 0) {
 		ath_print(common, ATH_DBG_FATAL,
 			  "Unable to restart recv logic\n");
+		spin_unlock_bh(&sc->rx.pcu_lock);
 		return;
 	}
+	spin_unlock_bh(&sc->rx.pcu_lock);
 
 	if (sc->sc_flags & SC_OP_BEACONS)
 		ath_beacon_config(sc, NULL);	/* restart beacons */
@@ -941,6 +955,9 @@ void ath_radio_disable(struct ath_softc *sc, struct ieee80211_hw *hw)
 	ath9k_hw_set_interrupts(ah, 0);
 
 	ath_drain_all_txq(sc, false);	/* clear pending tx frames */
+
+	spin_lock_bh(&sc->rx.pcu_lock);
+
 	ath_stoprecv(sc);		/* turn off frame recv */
 	ath_flushrecv(sc);		/* flush recv queue */
 
@@ -958,6 +975,9 @@ void ath_radio_disable(struct ath_softc *sc, struct ieee80211_hw *hw)
 	spin_unlock_bh(&sc->sc_resetlock);
 
 	ath9k_hw_phy_disable(ah);
+
+	spin_unlock_bh(&sc->rx.pcu_lock);
+
 	ath9k_hw_configpcipowersave(ah, 1, 1);
 	ath9k_ps_restore(sc);
 	ath9k_setpower(sc, ATH9K_PM_FULL_SLEEP);
@@ -977,6 +997,9 @@ int ath_reset(struct ath_softc *sc, bool retry_tx)
 
 	ath9k_hw_set_interrupts(ah, 0);
 	ath_drain_all_txq(sc, retry_tx);
+
+	spin_lock_bh(&sc->rx.pcu_lock);
+
 	ath_stoprecv(sc);
 	ath_flushrecv(sc);
 
@@ -991,6 +1014,8 @@ int ath_reset(struct ath_softc *sc, bool retry_tx)
 		ath_print(common, ATH_DBG_FATAL,
 			  "Unable to start recv logic\n");
 
+	spin_unlock_bh(&sc->rx.pcu_lock);
+
 	/*
 	 * We may be doing a reset in response to a request
 	 * that changes the channel so update any state that
@@ -1155,6 +1180,7 @@ static int ath9k_start(struct ieee80211_hw *hw)
 	 * be followed by initialization of the appropriate bits
 	 * and then setup of the interrupt mask.
 	 */
+	spin_lock_bh(&sc->rx.pcu_lock);
 	spin_lock_bh(&sc->sc_resetlock);
 	r = ath9k_hw_reset(ah, init_channel, ah->caldata, false);
 	if (r) {
@@ -1163,6 +1189,7 @@ static int ath9k_start(struct ieee80211_hw *hw)
 			  "(freq %u MHz)\n", r,
 			  curchan->center_freq);
 		spin_unlock_bh(&sc->sc_resetlock);
+		spin_unlock_bh(&sc->rx.pcu_lock);
 		goto mutex_unlock;
 	}
 	spin_unlock_bh(&sc->sc_resetlock);
@@ -1184,8 +1211,10 @@ static int ath9k_start(struct ieee80211_hw *hw)
 		ath_print(common, ATH_DBG_FATAL,
 			  "Unable to start recv logic\n");
 		r = -EIO;
+		spin_unlock_bh(&sc->rx.pcu_lock);
 		goto mutex_unlock;
 	}
+	spin_unlock_bh(&sc->rx.pcu_lock);
 
 	/* Setup our intr mask. */
 	ah->imask = ATH9K_INT_TX | ATH9K_INT_RXEOL |
@@ -1386,12 +1415,14 @@ static void ath9k_stop(struct ieee80211_hw *hw)
 	 * before setting the invalid flag. */
 	ath9k_hw_set_interrupts(ah, 0);
 
+	spin_lock_bh(&sc->rx.pcu_lock);
 	if (!(sc->sc_flags & SC_OP_INVALID)) {
 		ath_drain_all_txq(sc, false);
 		ath_stoprecv(sc);
 		ath9k_hw_phy_disable(ah);
 	} else
 		sc->rx.rxlink = NULL;
+	spin_unlock_bh(&sc->rx.pcu_lock);
 
 	/* disable HAL and put h/w to sleep */
 	ath9k_hw_disable(ah);
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index fe73fc5..20025a5 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -297,19 +297,17 @@ static void ath_edma_start_recv(struct ath_softc *sc)
 	ath_rx_addbuffer_edma(sc, ATH9K_RX_QUEUE_LP,
 			      sc->rx.rx_edma[ATH9K_RX_QUEUE_LP].rx_fifo_hwsize);
 
-	spin_unlock_bh(&sc->rx.rxbuflock);
-
 	ath_opmode_init(sc);
 
 	ath9k_hw_startpcureceive(sc->sc_ah, (sc->sc_flags & SC_OP_OFFCHANNEL));
+
+	spin_unlock_bh(&sc->rx.rxbuflock);
 }
 
 static void ath_edma_stop_recv(struct ath_softc *sc)
 {
-	spin_lock_bh(&sc->rx.rxbuflock);
 	ath_rx_remove_buffer(sc, ATH9K_RX_QUEUE_HP);
 	ath_rx_remove_buffer(sc, ATH9K_RX_QUEUE_LP);
-	spin_unlock_bh(&sc->rx.rxbuflock);
 }
 
 int ath_rx_init(struct ath_softc *sc, int nbufs)
@@ -321,6 +319,7 @@ int ath_rx_init(struct ath_softc *sc, int nbufs)
 
 	spin_lock_init(&sc->rx.rxflushlock);
 	sc->sc_flags &= ~SC_OP_RXFLUSH;
+	spin_lock_init(&sc->rx.pcu_lock);
 	spin_lock_init(&sc->rx.rxbuflock);
 
 	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_EDMA) {
@@ -506,9 +505,9 @@ int ath_startrecv(struct ath_softc *sc)
 	ath9k_hw_rxena(ah);
 
 start_recv:
-	spin_unlock_bh(&sc->rx.rxbuflock);
 	ath_opmode_init(sc);
 	ath9k_hw_startpcureceive(ah, (sc->sc_flags & SC_OP_OFFCHANNEL));
+	spin_unlock_bh(&sc->rx.rxbuflock);
 
 	return 0;
 }
@@ -518,6 +517,7 @@ bool ath_stoprecv(struct ath_softc *sc)
 	struct ath_hw *ah = sc->sc_ah;
 	bool stopped;
 
+	spin_lock_bh(&sc->rx.rxbuflock);
 	ath9k_hw_stoppcurecv(ah);
 	ath9k_hw_setrxfilter(ah, 0);
 	stopped = ath9k_hw_stopdmarecv(ah);
@@ -526,7 +526,9 @@ bool ath_stoprecv(struct ath_softc *sc)
 		ath_edma_stop_recv(sc);
 	else
 		sc->rx.rxlink = NULL;
+	spin_unlock_bh(&sc->rx.rxbuflock);
 
+	WARN_ON(!stopped);
 	return stopped;
 }
 
@@ -663,6 +665,13 @@ static void ath_rx_send_to_mac80211(struct ieee80211_hw *hw,
 				    struct ieee80211_rx_status *rxs)
 {
 	struct ieee80211_hdr *hdr;
+	struct sk_buff *tmp_skb;
+	unsigned int j;
+
+	for (j=0; j < 5; j++) {
+		tmp_skb = skb_copy(skb, GFP_ATOMIC);
+		dev_kfree_skb_any(tmp_skb);
+	}
 
 	hdr = (struct ieee80211_hdr *)skb->data;
 
