Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:38606 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753498Ab0G3FhB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jul 2010 01:37:01 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 29 Jul 2010 22:37:01 -0700
Date: Fri, 30 Jul 2010 11:06:54 +0530
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 3/3] ath9k: Implement an algorithm for Antenna
	diversity and combining
Message-ID: <20100730053653.GA10419@vasanth-laptop>
References: <1280408219-5293-1-git-send-email-vasanth@atheros.com> <1280408219-5293-3-git-send-email-vasanth@atheros.com> <AANLkTimiQZj7Gh5g+W0pcuWYFejt4EGQVCEQQ1aNvsk5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
In-Reply-To: <AANLkTimiQZj7Gh5g+W0pcuWYFejt4EGQVCEQQ1aNvsk5@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 29, 2010 at 08:09:35PM +0530, Luis R. Rodriguez wrote:
> On Thu, Jul 29, 2010 at 5:56 AM, Vasanthakumar Thiagarajan
> <vasanth@atheros.com> wrote:
> > This algorithm chooses the best main and alt lna out of
> > LNA1, LNA2, LNA1+LNA2 and LNA1-LNA2 to improve rx for single
> > chain chips(AR9285). This would greatly improve rx when there
> > is only one antenna is connected with AR9285.
> >
> > Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
> 
> > diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
> > index 243c177..8b4e4a6 100644
> > --- a/drivers/net/wireless/ath/ath9k/init.c
> > +++ b/drivers/net/wireless/ath/ath9k/init.c
> > @@ -531,6 +531,11 @@ static void ath9k_init_misc(struct ath_softc *sc)
> >                sc->beacon.bslot[i] = NULL;
> >                sc->beacon.bslot_aphy[i] = NULL;
> >        }
> > +
> > +       if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_ANT_DIV_COMB) {
> > +               memset(&sc->ant_comb, 0, sizeof(struct ath_ant_comb));
> 
> I do not believe this memset is required since we kzalloc()'d the ah struct.

that,s true. thanks.

> 
> Wow this routine is pretty large. Could you split this up into a few
> helpers which describe what they do ?

right, this one is pretty large, let me see if I can split things
up.

> Also notice how this ended up calling ath9k_hw_antdiv_comb_conf_get()
> and ath9k_hw_antdiv_comb_conf_set(), the only callers of those
> routines, and this itself is done when:
> 
> > +
> >  int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
> >  {
> >        struct ath_buf *bf;
> > @@ -1210,6 +1738,9 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
> >                                              PS_WAIT_FOR_PSPOLL_DATA))))
> >                        ath_rx_ps(sc, skb);
> >
> > +               if (ah->caps.hw_caps & ATH9K_HW_CAP_ANT_DIV_COMB)
> > +                       ath_ant_comb_scan(sc, &rs);
> > +
> >                ath_rx_send_to_mac80211(hw, sc, skb, rxs);
> >
> >  requeue:
> 
> So the call currently really does not require to be abstracted away
> unless we expect another 1x1 device where it will have its own set of
> calls, eventually.

hm, i actually planned not to abstract, not sure how I ended up
doing this one. I'll send the next version of this series. thanks.

Vasanth
