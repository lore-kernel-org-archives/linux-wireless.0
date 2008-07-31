Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:17612 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751223AbYGaBlD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jul 2008 21:41:03 -0400
Subject: Re: [PATCH 06/16] ath9k: Fix missing brace in branch on
	ath_chainmask_sel_logic()
From: Pavel Roskin <proski@gnu.org>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	Jouni Malinen <Jouni.Malinen@Atheros.com>,
	Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>
In-Reply-To: <20080731012128.GI7625@tesla>
References: <4800d552efce6350888c68b859f66767196d720b.1217309551.git.lrodriguez@atheros.com>
	 <40a067eab54b9b366002257d5be8e4577b067408.1217309551.git.lrodriguez@atheros.com>
	 <1217466707.3616.5.camel@dv>  <20080731012128.GI7625@tesla>
Content-Type: text/plain
Date: Wed, 30 Jul 2008 21:41:01 -0400
Message-Id: <1217468461.17029.2.camel@dv> (sfid-20080731_034133_395373_E223AC9C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-07-30 at 18:21 -0700, Luis R. Rodriguez wrote:
> On Wed, Jul 30, 2008 at 06:11:47PM -0700, Pavel Roskin wrote:
> > On Mon, 2008-07-28 at 22:47 -0700, lrodriguez@atheros.com wrote:
> > > From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
> > >
> > > diff --git a/drivers/net/wireless/ath9k/core.c b/drivers/net/wireless/ath9k/core.c
> > > index 47d4891..d9c7561 100644
> > > --- a/drivers/net/wireless/ath9k/core.c
> > > +++ b/drivers/net/wireless/ath9k/core.c
> > > @@ -508,9 +508,10 @@ int ath_chainmask_sel_logic(struct ath_softc *sc, struct ath_node *an)
> > >        * enabled/disabled setting
> > >        */
> > >       if ((sc->sc_no_tx_3_chains == AH_FALSE) ||
> > > -         (sc->sc_config.chainmask_sel == AH_FALSE))
> > > +         (sc->sc_config.chainmask_sel == AH_FALSE)) {
> > >               cm->cur_tx_mask = sc->sc_tx_chainmask;
> > >               return cm->cur_tx_mask;
> > > +     }
> > 
> > I would prefer that all compile fixes are amended in the patches that
> > introduced them.  We should try to pass only correct patches upstream.
> > Bisection works best if one doesn't hit code that doesn't compile.
> 
> The patch that caused this was not *one* patch but the introduction
> patch. This is why I put this in a separate patch. If we want to start
> out fresh that's another thing and I can just submit a shiny new driver
> introduction patch. But I don't think that is required at this point
> since this driver hasn't been merged yet. At this point users are
> using this from ath9k.git and from patches posted on the lists. At
> this point though I would like to keep the patches separated as we
> did receive a good number of contributions from the community. It also
> shows the changes we've made so far since our initial release.

I was wrong to assume that the original code would not compile.
Actually, it would, just not the way it was intended, i.e. it would
return unconditionally.  Never mind, sorry.

-- 
Regards,
Pavel Roskin
