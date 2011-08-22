Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:50484 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497Ab1HVMmV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Aug 2011 08:42:21 -0400
Date: Mon, 22 Aug 2011 18:12:29 +0530
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: Adrian Chadd <adrian@freebsd.org>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/2] ath9k: Change rate control to use legacy rate as
 last MRR
Message-ID: <20110822124228.GA1781@vmraj-lnx.users.atheros.com> (sfid-20110822_144224_761334_0884E30E)
References: <1313841130-7787-1-git-send-email-rmanohar@qca.qualcomm.com>
 <1313841130-7787-2-git-send-email-rmanohar@qca.qualcomm.com>
 <CAJ-VmokGvnb3NA1bRYQjQuA12ojbVKUHPHWrvvnQ_SU987O0xQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
In-Reply-To: <CAJ-VmokGvnb3NA1bRYQjQuA12ojbVKUHPHWrvvnQ_SU987O0xQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Aug 20, 2011 at 10:30:56PM +0800, Adrian Chadd wrote:
> Is this going to interfere with aggregation, which assumes (iirc) all
> rates in the aggregate rate choice are HT?
>
The aggregation is only formed if the first frame from tid is not legacy rated.
And I send another patch "ath9k: Send legacy rated frames as unaggregated" that
does not include legacy frames in aggr.

--
Rajkumar
> 
> On 20 August 2011 19:52, Rajkumar Manoharan <rmanohar@qca.qualcomm.com> wrote:
> > In congested network, having all rate reties at MCS rates
> > is failing to transmit the frame offenly. By the time reaching
> > the success rate set, the application gets timed out. One such
> > scenario is that authentication time out during 4-Way handshake.
> > This patch uses a legacy rate as last retry sequnce for
> > unaggregated frames or if the first selected rate's PER is ~80%
> > of max limit. And also observed from the tx status that the frame
> > was trasmitted successfully by using legacy rates.
> >
> > Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
> > ---
> >  drivers/net/wireless/ath/ath9k/rc.c |   34 +++++++++++++++++++++++++++-------
> >  1 files changed, 27 insertions(+), 7 deletions(-)
> >
> > diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
> > index 9e3649a..4f13018 100644
> > --- a/drivers/net/wireless/ath/ath9k/rc.c
> > +++ b/drivers/net/wireless/ath/ath9k/rc.c
> > @@ -603,7 +603,8 @@ static u8 ath_rc_setvalid_htrates(struct ath_rate_priv *ath_rc_priv,
> >  static u8 ath_rc_get_highest_rix(struct ath_softc *sc,
> >                                 struct ath_rate_priv *ath_rc_priv,
> >                                 const struct ath_rate_table *rate_table,
> > -                                int *is_probing)
> > +                                int *is_probing,
> > +                                bool legacy)
> >  {
> >        u32 best_thruput, this_thruput, now_msec;
> >        u8 rate, next_rate, best_rate, maxindex, minindex;
> > @@ -624,6 +625,8 @@ static u8 ath_rc_get_highest_rix(struct ath_softc *sc,
> >                u8 per_thres;
> >
> >                rate = ath_rc_priv->valid_rate_index[index];
> > +               if (legacy && !(rate_table->info[rate].rate_flags & RC_LEGACY))
> > +                       continue;
> >                if (rate > ath_rc_priv->rate_max_phy)
> >                        continue;
> >
> > @@ -767,7 +770,7 @@ static void ath_get_rate(void *priv, struct ieee80211_sta *sta, void *priv_sta,
> >        struct ieee80211_tx_rate *rates = tx_info->control.rates;
> >        struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
> >        __le16 fc = hdr->frame_control;
> > -       u8 try_per_rate, i = 0, rix;
> > +       u8 try_per_rate, i = 0, rix, high_rix;
> >        int is_probe = 0;
> >
> >        if (rate_control_send_low(sta, priv_sta, txrc))
> > @@ -786,7 +789,9 @@ static void ath_get_rate(void *priv, struct ieee80211_sta *sta, void *priv_sta,
> >        try_per_rate = 4;
> >
> >        rate_table = ath_rc_priv->rate_table;
> > -       rix = ath_rc_get_highest_rix(sc, ath_rc_priv, rate_table, &is_probe);
> > +       rix = ath_rc_get_highest_rix(sc, ath_rc_priv, rate_table,
> > +                                    &is_probe, false);
> > +       high_rix = rix;
> >
> >        /*
> >         * If we're in HT mode and both us and our peer supports LDPC.
> > @@ -822,10 +827,7 @@ static void ath_get_rate(void *priv, struct ieee80211_sta *sta, void *priv_sta,
> >        }
> >
> >        /* Fill in the other rates for multirate retry */
> > -       for ( ; i < 4; i++) {
> > -               /* Use twice the number of tries for the last MRR segment. */
> > -               if (i + 1 == 4)
> > -                       try_per_rate = 8;
> > +       for ( ; i < 3; i++) {
> >
> >                ath_rc_get_lower_rix(rate_table, ath_rc_priv, rix, &rix);
> >                /* All other rates in the series have RTS enabled */
> > @@ -833,6 +835,24 @@ static void ath_get_rate(void *priv, struct ieee80211_sta *sta, void *priv_sta,
> >                                       try_per_rate, rix, 1);
> >        }
> >
> > +       /* Use twice the number of tries for the last MRR segment. */
> > +       try_per_rate = 8;
> > +
> > +       /*
> > +        * Use a legacy rate as last retry to ensure that the frame
> > +        * is tried in both MCS and legacy rates.
> > +        */
> > +       if ((rates[2].flags & IEEE80211_TX_RC_MCS) &&
> > +           (!(tx_info->flags & IEEE80211_TX_CTL_AMPDU) ||
> > +           (ath_rc_priv->per[high_rix] > 45)))
> > +               rix = ath_rc_get_highest_rix(sc, ath_rc_priv, rate_table,
> > +                               &is_probe, true);
> > +       else
> > +               ath_rc_get_lower_rix(rate_table, ath_rc_priv, rix, &rix);
> > +
> > +       /* All other rates in the series have RTS enabled */
> > +       ath_rc_rate_set_series(rate_table, &rates[i], txrc,
> > +                              try_per_rate, rix, 1);
> >        /*
> >         * NB:Change rate series to enable aggregation when operating
> >         * at lower MCS rates. When first rate in series is MCS2
> > --
> > 1.7.6
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
