Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:42536 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755895AbaEGNKf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 May 2014 09:10:35 -0400
Message-ID: <1399468226.6800.25.camel@dubbel> (sfid-20140507_151037_626331_BCF1B56B)
From: Luca Coelho <luca@coelho.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Michal Kazior <michal.kazior@tieto.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Simon Wunderlich <sw@simonwunderlich.de>
Date: Wed, 07 May 2014 16:10:26 +0300
In-Reply-To: <1399467968.10517.39.camel@jlt4.sipsolutions.net>
References: <1397050174-26121-14-git-send-email-michal.kazior@tieto.com>
	 <1398849681-3606-1-git-send-email-michal.kazior@tieto.com>
	 <1399372915.4218.17.camel@jlt4.sipsolutions.net>
	 <CA+BoTQk1upg7yGK-QWoz8QhMeRzLBY60Lk=eUN=iQLaF2pUhQQ@mail.gmail.com>
	 <1399385141.4218.37.camel@jlt4.sipsolutions.net>
	 <CA+BoTQnGRtdOGfJ78EG43cmND2bD9m3WyvmSKx92uBFnKenPkw@mail.gmail.com>
	 <1399450061.5038.10.camel@jlt4.sipsolutions.net>
	 <1399455657.6800.4.camel@dubbel>
	 <CA+BoTQmXb=_jjE4-dL8U_-8=CxRMgo4qckUKF9LizfV2W0iC7A@mail.gmail.com>
	 <1399457760.6800.7.camel@dubbel>
	 <CA+BoTQnF3pVmGumqqHbfuphXbYhAybHUMosX4kJazfHWJDE+Fw@mail.gmail.com>
	 <1399460964.10517.12.camel@jlt4.sipsolutions.net>
	 <CA+BoTQnSJgaN=incAtW08tSqDgW2jRm1cdarMhupArGBAw7FRQ@mail.gmail.com>
	 (sfid-20140507_131912_954267_EF512364) <1399463646.10517.28.camel@jlt4.sipsolutions.net>
	 <1399464536.6800.11.camel@dubbel>
	 <1399464789.10517.29.camel@jlt4.sipsolutions.net>
	 <1399465244.6800.13.camel@dubbel>
	 <1399466312.10517.34.camel@jlt4.sipsolutions.net>
	 <1399467196.6800.22.camel@dubbel>
	 <1399467968.10517.39.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [PATCH v5] mac80211: implement multi-vif in-place reservations
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-05-07 at 15:06 +0200, Johannes Berg wrote:
> On Wed, 2014-05-07 at 15:53 +0300, Luca Coelho wrote:
> 
> > > > >  new chanctx3
> > > > >  switch vif2 chanctx1->chanctx3
> > > > >  switch_transaction(chanctx1, chanctx2, vif1)
> > > > 
> > > > Couldn't this potentially break the combinations temporarily again?
> > > 
> > > I don't see why? You had a spare channel context to start with,
> > > otherwise you'd never have accepted this situation. Therefore, you can
> > > use the spare one before actually doing the proposed
> > > switch_vif_chanctx().
> > 
> > It's not about the spare, it's about having this temporarily:
> > 
> > chanctx3-vif2
> > chanctx1-vif1
> > 
> > Can we be sure that chanctx1 with vif1 is compatible with chanctx3 with
> > vif2? We only check chanctx2 with vif1 and chanctx3 with vif2, which is
> > our final goal.
> > 
> > I'm not sure this is even possible, but it was something like this I had
> > in mind.
> 
> Oh, I get it, you're thinking that there might be a situation where
> those vif types are maybe not supported with different channels?
> 
> But in your example you're going from this situation:
> 
> chanctx1: vif1, vif2
> 
> to
> 
> chanctx2: vif1
> chanctx3: vif2
> 
> 
> The intermediate step that I proposed would give you
> 
> chanctx1: vif1
> chanctx3: vif2
> 
> Which isn't really any different?

It could be different if the channel in chanctx1 requires radar and
chanctx2 doesn't, couldn't it?


>  Maybe you could construct a more
> difficult via situation though where it actually does end up with a
> conflict - or can we prove that can't happen?

I can't come up with good examples, but yeah, proving it *can't* happen
would be good. :)

--
Luca.

