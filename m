Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:60447 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752496AbZFIFUy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jun 2009 01:20:54 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 08 Jun 2009 22:20:57 -0700
Date: Tue, 9 Jun 2009 10:49:34 +0530
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>
Subject: Re: [PATCH 01/15] ath9k: fix oops by downgrading assert in rc.c
Message-ID: <20090609051933.GA22194@vasanth-laptop>
References: <1244180502-4323-1-git-send-email-lrodriguez@atheros.com> <1244180502-4323-2-git-send-email-lrodriguez@atheros.com> <20090605063059.GF17632@vasanth-laptop> <43e72e890906050047w71f8e691g479797a54f5fb9a0@mail.gmail.com> <20090605075252.GG17632@vasanth-laptop> <20090605182944.GD30211@tesla> <44EE5C37ADC36343B0625A05DD408C485068DEBF69@CHEXMB-01.global.atheros.com> <43e72e890906081726m764f891mc0a46a46b5bc3ac9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <43e72e890906081726m764f891mc0a46a46b5bc3ac9@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 09, 2009 at 05:56:41AM +0530, Luis R. Rodriguez wrote:
> On Fri, Jun 5, 2009 at 11:55 PM, Vasanth
> Thiagarajan<Vasanth.Thiagarajan@atheros.com> wrote:
> >
> > ________________________________________
> >
> >> > >> +       /*
> >> > >> +        * Fine tuning for when no decent rate was found, the
> >> > >> +        * lowest should *not* be used under normal circumstances.
> >> > >> +        */
> >> > >> +       if (rix == ath_rc_priv->valid_rate_index[0]) {
> >> > >> +               DPRINTF(sc, ATH_DBG_RATE, "lowest rate being used, "
> >> > >> +                       "disabling MRR\n");
> >> > >> +               rates[0].idx = rate_lowest_index(sband, sta);
> >> > >> +               /* Disable MRR when ath_rc_ratefind_ht() found rate 0 */
> >> > >> +               rates[1].idx = -1;
> >> > >> +       }
> >> > >
> >> > > I think we can still fill other rates (1..3) with the lowest rate
> >> > > index as we dont differentiate the situation where the lowest rate
> >> > > is chosen truely by the algorithm from this particular case.
> >> >
> >> > I thought about that as well, but does it really make sense for us to
> >> > use MRR with the same lowest rate? That's why I just used one segment.
> >> > Thoughts?
> >>
> >> or we can try for max_retry (4) times. In that case the rate indices of
> >> other rates (just not 1) should be made -1 or this segment should
> >> moved just below the rate find.
> >
> > and the next segment [1]
> > is set to -1. Please let me know if there is anything else you see needs
> > change.
> >
> > Setting rate index of the rate series[1] is not enough as you are still filling the others rate
> > segments(2 and 3) by ath_rc_rate_getidx() in the for..loop, so other segments are also be
> > set to -1, but it looks hacky, one clean way of doing this can be, moving you code segment to
> > just below ath_rc_ratefind_ht(), like the following diff.
> >
> >
> >        rate_table = sc->cur_rate_table;
> >        rix = ath_rc_ratefind_ht(sc, ath_rc_priv, rate_table, &is_probe);
> > +
> > +       if (rix == ath_rc_priv->valid_rate_index[0]) {
> > +               DPRINTF(sc, ATH_DBG_RATE, "lowest rate being used, "
> > +                               "disabling MRR\n");
> > +
> > +               ath_rc_rate_set_series(rate_table, &rates[0], txrc,
> > +                                      4, rix, 0);
> 
> The above sets the rate[0].idx to rix
> 
> > +               rates[0].idx = rate_lowest_index(sband, sta);
> 
> and then here we set it to rate_lowest_index(sband, sta) comes up
> with. They should be the same, but this just goes to show we need to
> clean this better.

yeah, set rix to lowest rate index before passing rix to
ath_rc_rate_set_series().
> 
> ath_rc_rate_set_series() is also doing some flag checks which I'm not
> so sure we need to do all the time so I'd like to avoid it.

We need preamble and RTS_CTS bits in rate flags.

> there's also that is_probe check and the flags that sets.

This should be ignored for lowest rate index as there is no way
that a new rate has been probed in this case.


Vasanth
