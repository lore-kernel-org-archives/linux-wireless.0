Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:55809 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753183Ab0JNXai (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Oct 2010 19:30:38 -0400
Message-ID: <4CB79299.7000005@candelatech.com>
Date: Thu, 14 Oct 2010 16:30:33 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@Atheros.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: memory clobber in rx path, maybe related to ath9k.
References: <4CB4AA89.1070009@candelatech.com> <20101013053141.GA15798@vasanth-laptop> <4CB5E0A8.5020502@candelatech.com> <AANLkTimp_GSwwX_RnQSyN9QNe55HQ+0HZJ1yd8Xp+dWG@mail.gmail.com> <AANLkTinyVqdgPqzpyihuaPtVVqDmzj-ZbXzQ-4qdA2yH@mail.gmail.com> <4CB77EA0.1000005@candelatech.com> <AANLkTimC0+6PiqWO+LmtBV7uKCVpZueAQs6m_6kAnbq9@mail.gmail.com> <AANLkTi=1oOCcdvBHo+8WAVHv-M8tE14ntmK4M_09SWh5@mail.gmail.com> <AANLkTi=pp2Ob06YCi6GsR9rtRaDWPP95n2M72qWLdbwM@mail.gmail.com> <20101014225150.GB15740@tux> <20101014231958.GA3242@tux>
In-Reply-To: <20101014231958.GA3242@tux>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/14/2010 04:19 PM, Luis R. Rodriguez wrote:
> Ok please try this patch, it cures it for me.

Well, it got a lot further than normal, but it still
hit the poison check after a few minutes.

Current test case is my app loading 130 or so stations, each running
wpa_supplicant.  All were created, and quite a few had associated
when the poison check hit.

So, it definitely looks like a step in the right direction, but
not fully fixed yet.

I'll do some more testing with this patch applied and using just my
perl script to make sure the problem is reproducible outside of my
application.

Thanks,
Ben


>
>    Luis
>
> diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
> index fe73fc5..e581b1f 100644
> --- a/drivers/net/wireless/ath/ath9k/recv.c
> +++ b/drivers/net/wireless/ath/ath9k/recv.c
> @@ -306,10 +306,8 @@ static void ath_edma_start_recv(struct ath_softc *sc)
>
>   static void ath_edma_stop_recv(struct ath_softc *sc)
>   {
> -	spin_lock_bh(&sc->rx.rxbuflock);
>   	ath_rx_remove_buffer(sc, ATH9K_RX_QUEUE_HP);
>   	ath_rx_remove_buffer(sc, ATH9K_RX_QUEUE_LP);
> -	spin_unlock_bh(&sc->rx.rxbuflock);
>   }
>
>   int ath_rx_init(struct ath_softc *sc, int nbufs)
> @@ -518,6 +516,7 @@ bool ath_stoprecv(struct ath_softc *sc)
>   	struct ath_hw *ah = sc->sc_ah;
>   	bool stopped;
>
> +	spin_lock_bh(&sc->rx.rxbuflock);
>   	ath9k_hw_stoppcurecv(ah);
>   	ath9k_hw_setrxfilter(ah, 0);
>   	stopped = ath9k_hw_stopdmarecv(ah);
> @@ -526,6 +525,7 @@ bool ath_stoprecv(struct ath_softc *sc)
>   		ath_edma_stop_recv(sc);
>   	else
>   		sc->rx.rxlink = NULL;
> +	spin_unlock_bh(&sc->rx.rxbuflock);
>
>   	return stopped;
>   }


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

