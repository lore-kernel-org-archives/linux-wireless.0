Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:49841 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755603AbaEGMiw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 May 2014 08:38:52 -0400
Message-ID: <1399466312.10517.34.camel@jlt4.sipsolutions.net> (sfid-20140507_143855_433410_F7C22C53)
Subject: Re: [PATCH v5] mac80211: implement multi-vif in-place reservations
From: Johannes Berg <johannes@sipsolutions.net>
To: Luca Coelho <luca@coelho.fi>
Cc: Michal Kazior <michal.kazior@tieto.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Simon Wunderlich <sw@simonwunderlich.de>
Date: Wed, 07 May 2014 14:38:32 +0200
In-Reply-To: <1399465244.6800.13.camel@dubbel>
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
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-05-07 at 15:20 +0300, Luca Coelho wrote:
> On Wed, 2014-05-07 at 14:13 +0200, Johannes Berg wrote:
> > On Wed, 2014-05-07 at 15:08 +0300, Luca Coelho wrote:
> > 
> > > I was thinking about the case where you you need to involve 3 contexts.
> > > Let's say you have 2 vifs in the same context and after the switch you
> > > need to split them into 2 new ones (for instance, if there is some
> > > incompatibility in the new chandefs).
> > > 
> > > With the generic transactions you could do:
> > >  - new chanctx2
> > >  - new chanctx3
> > >  - switch vif1 chanctx1->chanctx2
> > >  - switch vif2 chanctx1->chanctx3
> > >  - del chanctx1
> > 
> > This isn't an interesting case, because it means you have a spare, so
> > you might as well do
> > 
> >  new chanctx3
> >  switch vif2 chanctx1->chanctx3
> >  switch_transaction(chanctx1, chanctx2, vif1)
> 
> Couldn't this potentially break the combinations temporarily again?

I don't see why? You had a spare channel context to start with,
otherwise you'd never have accepted this situation. Therefore, you can
use the spare one before actually doing the proposed
switch_vif_chanctx().


Ultimately, what I'm trying to say is that instead of the proposed
switch_vif_chanctx(), we need to have this:

enum ieee80211_chanctx_switch_mode - as before

        (*switch_vif_chanctx)(struct ieee80211_hw *hw,
                              struct ieee80211_vif **vifs, int n_vifs,
                              struct ieee80211_chanctx_conf *old_ctx,
                              struct ieee80211_chanctx_conf *new_ctx,
                              enum ieee80211_chanctx_switch_mode mode);


johannes

