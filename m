Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:24106 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753888Ab0JNXsz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Oct 2010 19:48:55 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 14 Oct 2010 16:48:46 -0700
Date: Thu, 14 Oct 2010 16:48:53 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Ben Greear <greearb@candelatech.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: memory clobber in rx path, maybe related to ath9k.
Message-ID: <20101014234853.GA10113@tux>
References: <AANLkTimp_GSwwX_RnQSyN9QNe55HQ+0HZJ1yd8Xp+dWG@mail.gmail.com>
 <AANLkTinyVqdgPqzpyihuaPtVVqDmzj-ZbXzQ-4qdA2yH@mail.gmail.com>
 <4CB77EA0.1000005@candelatech.com>
 <AANLkTimC0+6PiqWO+LmtBV7uKCVpZueAQs6m_6kAnbq9@mail.gmail.com>
 <AANLkTi=1oOCcdvBHo+8WAVHv-M8tE14ntmK4M_09SWh5@mail.gmail.com>
 <AANLkTi=pp2Ob06YCi6GsR9rtRaDWPP95n2M72qWLdbwM@mail.gmail.com>
 <20101014225150.GB15740@tux>
 <20101014231958.GA3242@tux>
 <4CB79299.7000005@candelatech.com>
 <AANLkTinQmE6wm1pXkRL6p_3rkMvNrppmirjj3-jagMp8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
In-Reply-To: <AANLkTinQmE6wm1pXkRL6p_3rkMvNrppmirjj3-jagMp8@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 14, 2010 at 04:39:45PM -0700, Luis R. Rodriguez wrote:
> On Thu, Oct 14, 2010 at 4:30 PM, Ben Greear <greearb@candelatech.com> wrote:
> > On 10/14/2010 04:19 PM, Luis R. Rodriguez wrote:
> >>
> >> Ok please try this patch, it cures it for me.
> >
> > Well, it got a lot further than normal, but it still
> > hit the poison check after a few minutes.
> >
> > Current test case is my app loading 130 or so stations, each running
> > wpa_supplicant.  All were created, and quite a few had associated
> > when the poison check hit.
> >
> > So, it definitely looks like a step in the right direction, but
> > not fully fixed yet.
> >
> > I'll do some more testing with this patch applied and using just my
> > perl script to make sure the problem is reproducible outside of my
> > application.
> 
> Ok, whatever userspace does it should not corrupt to kernel, unless
> its poking /dev/mem

Can also try this one instead, it will prevent any other instances
we would not have caught on stopping and starting RX here.

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index fe73fc5..db677c4 100644
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
@@ -482,13 +480,14 @@ int ath_startrecv(struct ath_softc *sc)
 {
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_buf *bf, *tbf;
+	unsigned long flags;
 
 	if (ah->caps.hw_caps & ATH9K_HW_CAP_EDMA) {
 		ath_edma_start_recv(sc);
 		return 0;
 	}
 
-	spin_lock_bh(&sc->rx.rxbuflock);
+	spin_lock_irqsave(&sc->rx.rxbuflock, flags);
 	if (list_empty(&sc->rx.rxbuf))
 		goto start_recv;
 
@@ -506,7 +505,7 @@ int ath_startrecv(struct ath_softc *sc)
 	ath9k_hw_rxena(ah);
 
 start_recv:
-	spin_unlock_bh(&sc->rx.rxbuflock);
+	spin_unlock_irqrestore(&sc->rx.rxbuflock, flags);
 	ath_opmode_init(sc);
 	ath9k_hw_startpcureceive(ah, (sc->sc_flags & SC_OP_OFFCHANNEL));
 
@@ -517,7 +516,9 @@ bool ath_stoprecv(struct ath_softc *sc)
 {
 	struct ath_hw *ah = sc->sc_ah;
 	bool stopped;
+	unsigned long flags;
 
+	spin_lock_irqsave(&sc->rx.rxbuflock, flags);
 	ath9k_hw_stoppcurecv(ah);
 	ath9k_hw_setrxfilter(ah, 0);
 	stopped = ath9k_hw_stopdmarecv(ah);
@@ -526,6 +527,7 @@ bool ath_stoprecv(struct ath_softc *sc)
 		ath_edma_stop_recv(sc);
 	else
 		sc->rx.rxlink = NULL;
+	spin_unlock_irqrestore(&sc->rx.rxbuflock, flags);
 
 	return stopped;
 }
