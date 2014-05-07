Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:49636 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932628AbaEGLyW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 May 2014 07:54:22 -0400
Message-ID: <1399463646.10517.28.camel@jlt4.sipsolutions.net> (sfid-20140507_135425_948546_B1C41B60)
Subject: Re: [PATCH v5] mac80211: implement multi-vif in-place reservations
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: Luca Coelho <luca@coelho.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Simon Wunderlich <sw@simonwunderlich.de>
Date: Wed, 07 May 2014 13:54:06 +0200
In-Reply-To: <CA+BoTQnSJgaN=incAtW08tSqDgW2jRm1cdarMhupArGBAw7FRQ@mail.gmail.com> (sfid-20140507_131912_954267_EF512364)
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
	 (sfid-20140507_131912_954267_EF512364)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-05-07 at 13:19 +0200, Michal Kazior wrote:
> On 7 May 2014 13:09, Johannes Berg <johannes@sipsolutions.net> wrote:
> > On Wed, 2014-05-07 at 12:38 +0200, Michal Kazior wrote:
> >
> >> I was actually thinking of just providing the bare minimum to fulfill
> >> requirements for the CSA case: int foo(*hw, **vifs, n_vifs, *oldctx,
> >> *newctx, flags).
> >>
> >> Having an array of transactions passed through a single call seems
> >> more robust and cleaner. Naiive drivers might just iterate over each
> >> entry while more complex drivers might examine the whole request and
> >> detect chanctx swapping.
> >
> > Not sure what you mean by "detect chanctx swapping" - the flags would
> > indicate that anyway, no? In any case, I like this better than a more
> > general transaction API I think, it's easier for the driver
> > implementation and clearer as to what needs to be done/supported.
> 
> You could submit a transaction sequence:
>  - new chanctx2
>  - switch vif1 chanctx1->chanctx2
>  - switch vif2 chanctx1->chanctx2
>  - remove chanctx1

Well, you don't really have any other choice with the API you proposed,
and IMHO that's a good thing. The only possibilities that can be
expressed with that would seem to be:

 1) for_each_vif: switch vif from oldctx to newctx
 2) add newctx
    for_each_vif: switch vif from oldctx to newctx
    del oldctx

With the option between 1/2 being selected by the flags. I don't see
what the driver has to infer about it being a channel switch - it
necessarily is one, no?

johannes

