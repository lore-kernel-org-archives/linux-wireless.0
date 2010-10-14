Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:21263 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755581Ab0JNXUC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Oct 2010 19:20:02 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 14 Oct 2010 16:19:52 -0700
Date: Thu, 14 Oct 2010 16:19:58 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Luis Rodriguez <Luis.Rodriguez@Atheros.com>
CC: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	Ben Greear <greearb@candelatech.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: memory clobber in rx path, maybe related to ath9k.
Message-ID: <20101014231958.GA3242@tux>
References: <4CB4AA89.1070009@candelatech.com>
 <20101013053141.GA15798@vasanth-laptop>
 <4CB5E0A8.5020502@candelatech.com>
 <AANLkTimp_GSwwX_RnQSyN9QNe55HQ+0HZJ1yd8Xp+dWG@mail.gmail.com>
 <AANLkTinyVqdgPqzpyihuaPtVVqDmzj-ZbXzQ-4qdA2yH@mail.gmail.com>
 <4CB77EA0.1000005@candelatech.com>
 <AANLkTimC0+6PiqWO+LmtBV7uKCVpZueAQs6m_6kAnbq9@mail.gmail.com>
 <AANLkTi=1oOCcdvBHo+8WAVHv-M8tE14ntmK4M_09SWh5@mail.gmail.com>
 <AANLkTi=pp2Ob06YCi6GsR9rtRaDWPP95n2M72qWLdbwM@mail.gmail.com>
 <20101014225150.GB15740@tux>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20101014225150.GB15740@tux>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ok please try this patch, it cures it for me.

  Luis

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index fe73fc5..e581b1f 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -306,10 +306,8 @@ static void ath_edma_start_recv(struct ath_softc *sc)
 
 static void ath_edma_stop_recv(struct ath_softc *sc)
 {
-	spin_lock_bh(&sc->rx.rxbuflock);
 	ath_rx_remove_buffer(sc, ATH9K_RX_QUEUE_HP);
 	ath_rx_remove_buffer(sc, ATH9K_RX_QUEUE_LP);
-	spin_unlock_bh(&sc->rx.rxbuflock);
 }
 
 int ath_rx_init(struct ath_softc *sc, int nbufs)
@@ -518,6 +516,7 @@ bool ath_stoprecv(struct ath_softc *sc)
 	struct ath_hw *ah = sc->sc_ah;
 	bool stopped;
 
+	spin_lock_bh(&sc->rx.rxbuflock);
 	ath9k_hw_stoppcurecv(ah);
 	ath9k_hw_setrxfilter(ah, 0);
 	stopped = ath9k_hw_stopdmarecv(ah);
@@ -526,6 +525,7 @@ bool ath_stoprecv(struct ath_softc *sc)
 		ath_edma_stop_recv(sc);
 	else
 		sc->rx.rxlink = NULL;
+	spin_unlock_bh(&sc->rx.rxbuflock);
 
 	return stopped;
 }
