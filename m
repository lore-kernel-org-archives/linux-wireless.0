Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:37962 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752565AbaCRJY4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Mar 2014 05:24:56 -0400
Message-ID: <1395134667.15856.32.camel@dubbel> (sfid-20140318_102501_507391_1871F059)
From: Luca Coelho <luca@coelho.fi>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	"sw@simonwunderlich.de" <sw@simonwunderlich.de>,
	"Otcheretianski, Andrei" <andrei.otcheretianski@intel.com>,
	Eliad Peller <eliad@wizery.com>
Date: Tue, 18 Mar 2014 11:24:27 +0200
In-Reply-To: <CA+BoTQmLSxmNy+O9mj9MHxtLvE7SU6EfHrCGnZcBmrD3ktonjw@mail.gmail.com>
References: <1394547394-3910-1-git-send-email-luciano.coelho@intel.com>
	 <1394547394-3910-4-git-send-email-luciano.coelho@intel.com>
	 <CA+BoTQ=i2yDeVQaaF3aWfKG+dcHCn9Gg_AZ+rSNDsmaE88o7Rw@mail.gmail.com>
	 <1395130437.15856.13.camel@dubbel>
	 <CA+BoTQn5dB8-4U0X+_GX_J7rDctTpCWg8ydjSQbrEjMB28NKEA@mail.gmail.com>
	 <1395132248.15856.21.camel@dubbel>
	 <CA+BoTQmLSxmNy+O9mj9MHxtLvE7SU6EfHrCGnZcBmrD3ktonjw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [PATCH v10 3/5] cfg80211/mac80211: move interface counting for
 combination check to mac80211
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-03-18 at 09:58 +0100, Michal Kazior wrote:
> On 18 March 2014 09:44, Luca Coelho <luca@coelho.fi> wrote:
> > On Tue, 2014-03-18 at 09:36 +0100, Michal Kazior wrote:
> >> On 18 March 2014 09:13, Coelho, Luciano <luciano.coelho@intel.com> wrote:
> >> > On Fri, 2014-03-14 at 09:40 +0100, Michal Kazior wrote:
> >> >> On 11 March 2014 15:16, Luciano Coelho <luciano.coelho@intel.com> wrote:
> >>
> >> [...]
> >>
> >> >> > +       list_for_each_entry(ctx, &local->chanctx_list, list) {
> >> >> > +               if (ctx->conf.radar_enabled)
> >> >> > +                       radar_detect |= BIT(ctx->conf.def.width);
> >> >>
> >> >> Is this really correct?
> >> >
> >> > I'm not sure anymore. :)
> >> >
> >> >
> >> >> The original behaviour was to:
> >> >>
> >> >>  for each wdev:
> >> >>    get_chan_state(..., &radar_width)
> >> >>
> >> >> where get_chan_state() ORs BIT(width) accordingly to iftype, etc.
> >> >>
> >> >> For 2 APs with different operational widths (e.g. 20 and 40) this means:
> >> >>
> >> >> a) old code: width_detect = BIT(WIDTH_20) | BIT(WIDTH_40)
> >> >> b) new code: width_detect = BIT(chanctx->width) which is BIT(WIDTH_40)
> >> >>
> >> >> I think radar_detect should be computed:
> >> >>
> >> >>  radar_detect = 0 // **
> >> >>  for each vif:
> >> >>   if vif.ctx == ctx && vif.radar_required:
> >> >>    radar_detect = BIT(vif.bss.width)
> >> >>
> >> >> ** you could argue to initialize with BIT(ctx->width), but all things
> >> >> seem to use ieee80211_vif_use_channel() (including CAC/radar
> >> >> detection) so bss_conf.chandef.width should be set correctly and
> >> >> iteration alone should suffice.
> >> >
> >> > But does this really make sense? This was more or less the idea I had
> >> > when I changed the cfg80211_chandef_dfs_required() to return a bit mask
> >> > (which I later reverted).
> >> >
> >> > I think the current behavior may be wrong.  In the old
> >> > cfg80211_can_use_iftype_chan() we match *any* of the bits in
> >> > radar_detect with the bits supported in the interface combinations.  So,
> >> > in your example, we would accept the combination even if the driver did
> >> > not support WIDTH_40 (because it would match WIDTH_20).  If the context
> >> > is set to WIDTH_40, don't we have to make sure the driver can detect
> >> > radars on that width?
> >>
> >> Fair point, but current behaviour of cfg80211_can_use_iftype_chan()
> >> doesn't seem like a correct one to me. It shouldn't match any but
> >> *all* of the radar_detect bits, no?
> >
> > I don't really know.  I think that if we're using 40MHz, we need to be
> > able to detect on the entire 40MHz, and that includes the 20MHz part as
> > well.  So being able to detect on 20MHz in that same channel context is
> > irrelevant, isn't it?
> 
> True but take this hypothetical case:
> 
> You have a driver combination that supports radar_detect only at
> 40MHz. You start AP @ 40MHz with radar. You match the radar_detect.
> You start AP @ 20MHz with radar. You match again radar_detect (because
> there's the AP @ 40MHz running). You stop AP @ 40Mhz. You now have
> only an AP running at 20MHz which requires radar_detect for 20MHz but
> there's no combination to match that. Oops. We should've never allowed
> the AP @ 20MHz to start.

Yeah, this scenario is broken.  My patch series doesn't break it any
more than it already is. :) Actually it improves this a bit, because the
opposite scenario would work better:

A hardware that supports radar detect only at 20MHz.  You start AP at
20MHz, everything is fine.  Now you start another AP at 40MHz, the
current code would allow it (because it checks if *any* width matches).
Oops! With my patches we wouldn't allow it, because the new chanctx
would require 40MHz when you start the second AP and it wouldn't be
allowed.


> I doubt there's hardware that needs a combination like that but it
> just bothers me current structure and logic allows it.

Yeah, if you keep peeking into the DFS code you are probably going to
find even worse things. :(

I guess the only good way to fix the scenario you described would be to
recheck combinations whenever a vif gets removed from a chanctx as well.

But maybe a better thing to do would be to change the
radar_detect_widths bitmask into max_radar_detect_width or something.  I
don't think it really makes sense to be able to detect radars on, say,
40MHz but not on 20MHz.

Anyway, this is a separate issue and I don't think it should block my
series from going in.  Someone should fix DFS separately.  As Johannes
would probably say, "patches welcome". :)

--
Cheers,
Luca.

