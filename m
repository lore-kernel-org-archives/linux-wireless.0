Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.234]:11150 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752831AbYJ2JOq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2008 05:14:46 -0400
Received: by rv-out-0506.google.com with SMTP id k40so3199040rvb.1
        for <linux-wireless@vger.kernel.org>; Wed, 29 Oct 2008 02:14:45 -0700 (PDT)
Message-ID: <1ba2fa240810290214r57f097fcsed092776af077c7f@mail.gmail.com> (sfid-20081029_101451_476336_144DABCE)
Date: Wed, 29 Oct 2008 11:14:45 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: Sujith <Sujith.Manoharan@atheros.com>
Subject: Re: [PATCH 04/16] ath9k: Remove SM Power Save as it is not supported now
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Jouni.Malinen@atheros.com, Luis.Rodriguez@atheros.com
In-Reply-To: <18695.59972.967807.657751@gargle.gargle.HOWL>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <18695.59972.967807.657751@gargle.gargle.HOWL>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Is not supported by HW or by mac80211? It's not clear from the commit message?
Since I'm still trying to push this into mac80211 it was just delayed
by other tasks
Tomas


On Wed, Oct 29, 2008 at 6:44 AM, Sujith <Sujith.Manoharan@atheros.com> wrote:
> Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
> ---
>  drivers/net/wireless/ath9k/core.h |    7 -----
>  drivers/net/wireless/ath9k/xmit.c |   45 +++++--------------------------------
>  2 files changed, 6 insertions(+), 46 deletions(-)
>
> diff --git a/drivers/net/wireless/ath9k/core.h b/drivers/net/wireless/ath9k/core.h
> index 21b572b..27ed084 100644
> --- a/drivers/net/wireless/ath9k/core.h
> +++ b/drivers/net/wireless/ath9k/core.h
> @@ -415,12 +415,6 @@ int ath_rx_subframe(struct ath_node *an, struct sk_buff *skb,
>  #define WME_AC_VO               3 /* voice */
>  #define WME_NUM_AC              4
>
> -enum ATH_SM_PWRSAV{
> -       ATH_SM_ENABLE,
> -       ATH_SM_PWRSAV_STATIC,
> -       ATH_SM_PWRSAV_DYNAMIC,
> -};
> -
>  /*
>  * Data transmit queue state.  One of these exists for each
>  * hardware transmit queue.  Packets sent to us from above
> @@ -619,7 +613,6 @@ struct ath_node {
>        struct ath_softc *an_sc;
>        struct ath_chainmask_sel an_chainmask_sel;
>        struct ath_node_aggr an_aggr;
> -       u8 an_smmode; /* SM Power save mode */
>        u16 maxampdu;
>        u8 mpdudensity;
>  };
> diff --git a/drivers/net/wireless/ath9k/xmit.c b/drivers/net/wireless/ath9k/xmit.c
> index defd699..b3ba47d 100644
> --- a/drivers/net/wireless/ath9k/xmit.c
> +++ b/drivers/net/wireless/ath9k/xmit.c
> @@ -575,7 +575,7 @@ static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf)
>        struct ath_desc *ds = bf->bf_desc;
>        struct ath_desc *lastds = bf->bf_lastbf->bf_desc;
>        struct ath9k_11n_rate_series series[4];
> -       int i, flags, rtsctsena = 0, dynamic_mimops = 0;
> +       int i, flags, rtsctsena = 0;
>        u32 ctsduration = 0;
>        u8 rix = 0, cix, ctsrate = 0;
>        u32 aggr_limit_with_rts = ah->ah_caps.rts_aggr_limit;
> @@ -631,18 +631,6 @@ static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf)
>                 */
>                if (!rtsctsena)
>                        flags = ATH9K_TXDESC_RTSENA;
> -               /*
> -                * For dynamic MIMO PS, RTS needs to precede the first aggregate
> -                * and the second aggregate should have any protection at all.
> -                */
> -               if (an && an->an_smmode == ATH_SM_PWRSAV_DYNAMIC) {
> -                       if (!bf_isaggrburst(bf)) {
> -                               flags = ATH9K_TXDESC_RTSENA;
> -                               dynamic_mimops = 1;
> -                       } else {
> -                               flags = 0;
> -                       }
> -               }
>        }
>
>        /*
> @@ -707,33 +695,14 @@ static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf)
>                        (bf->bf_rcs[i].flags & ATH_RC_SGI_FLAG),
>                        bf_isshpreamble(bf));
>
> -               if (an && (an->an_smmode == ATH_SM_PWRSAV_STATIC) &&
> -                   (bf->bf_rcs[i].flags & ATH_RC_DS_FLAG) == 0) {
> -                       /*
> -                        * When sending to an HT node that has enabled static
> -                        * SM/MIMO power save, send at single stream rates but
> -                        * use maximum allowed transmit chains per user,
> -                        * hardware, regulatory, or country limits for
> -                        * better range.
> -                        */
> +               if (bf_isht(bf))
> +                       series[i].ChSel =
> +                               ath_chainmask_sel_logic(sc, an);
> +               else
>                        series[i].ChSel = sc->sc_tx_chainmask;
> -               } else {
> -                       if (bf_isht(bf))
> -                               series[i].ChSel =
> -                                       ath_chainmask_sel_logic(sc, an);
> -                       else
> -                               series[i].ChSel = sc->sc_tx_chainmask;
> -               }
>
>                if (rtsctsena)
>                        series[i].RateFlags |= ATH9K_RATESERIES_RTS_CTS;
> -
> -               /*
> -                * Set RTS for all rates if node is in dynamic powersave
> -                * mode and we are using dual stream rates.
> -                */
> -               if (dynamic_mimops && (bf->bf_rcs[i].flags & ATH_RC_DS_FLAG))
> -                       series[i].RateFlags |= ATH9K_RATESERIES_RTS_CTS;
>        }
>
>        /*
> @@ -2521,10 +2490,8 @@ void ath_txq_schedule(struct ath_softc *sc, struct ath_txq *txq)
>                if (tid->paused)    /* check next tid to keep h/w busy */
>                        continue;
>
> -               if (!(tid->an->an_smmode == ATH_SM_PWRSAV_DYNAMIC) ||
> -                   ((txq->axq_depth % 2) == 0)) {
> +               if ((txq->axq_depth % 2) == 0)
>                        ath_tx_sched_aggr(sc, txq, tid);
> -               }
>
>                /*
>                 * add tid to round-robin queue if more frames
> --
> 1.6.0.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
