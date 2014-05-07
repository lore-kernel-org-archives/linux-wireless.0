Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:49821 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190AbaEGMgf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 May 2014 08:36:35 -0400
Message-ID: <1399466185.10517.32.camel@jlt4.sipsolutions.net> (sfid-20140507_143638_356508_C1AA35B8)
Subject: Re: [PATCH v5] mac80211: implement multi-vif in-place reservations
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: Luca Coelho <luca@coelho.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Simon Wunderlich <sw@simonwunderlich.de>
Date: Wed, 07 May 2014 14:36:25 +0200
In-Reply-To: <CA+BoTQnKxBR=sWYU=xPojcd61KDd=nsGGqhzNRFiY9zuEp4hKQ@mail.gmail.com> (sfid-20140507_142757_891206_6C8C42DE)
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
	 <1399463646.10517.28.camel@jlt4.sipsolutions.net>
	 <1399464536.6800.11.camel@dubbel>
	 <1399464789.10517.29.camel@jlt4.sipsolutions.net>
	 <CA+BoTQnKxBR=sWYU=xPojcd61KDd=nsGGqhzNRFiY9zuEp4hKQ@mail.gmail.com>
	 (sfid-20140507_142757_891206_6C8C42DE)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-05-07 at 14:27 +0200, Michal Kazior wrote:
> On 7 May 2014 14:13, Johannes Berg <johannes@sipsolutions.net> wrote:
> > On Wed, 2014-05-07 at 15:08 +0300, Luca Coelho wrote:
> >
> >> I was thinking about the case where you you need to involve 3 contexts.
> >> Let's say you have 2 vifs in the same context and after the switch you
> >> need to split them into 2 new ones (for instance, if there is some
> >> incompatibility in the new chandefs).
> >>
> >> With the generic transactions you could do:
> >>  - new chanctx2
> >>  - new chanctx3
> >>  - switch vif1 chanctx1->chanctx2
> >>  - switch vif2 chanctx1->chanctx3
> >>  - del chanctx1
> >
> > This isn't an interesting case, because it means you have a spare, so
> > you might as well do
> >
> >  new chanctx3
> >  switch vif2 chanctx1->chanctx3
> >  switch_transaction(chanctx1, chanctx2, vif1)
> 
> Don't you mean switch_chandef(chanctx1, chandef)? Or do you assume
> chanctx2 was prepared earlier? Don't you need to remove chanctx1 then?
> Oh, and the chanctx overcommit.. :-)

I'm assuming "switch_transaction" is the API I proposed, except maybe
modified to have multiple vifs.

> I actually think Luca's example is a valid one as it shows the driver
> can freely handle things internally, no? Although I don't see when it
> would be required to make a transaction like that in real-world..

Yeah but do we want to make the API that complex? I don't see how Luca's
example doesn't degenerate to the simpler APIs + the new "switch
multiple vifs from one to another while possibly swapping those
chanctxs"

johannes

