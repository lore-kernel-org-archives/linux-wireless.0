Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:47559 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753317AbaEHKG1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 May 2014 06:06:27 -0400
Message-ID: <1399543568.9163.5.camel@jlt4.sipsolutions.net> (sfid-20140508_120630_626601_0200BE6A)
Subject: Re: [PATCH v5] mac80211: implement multi-vif in-place reservations
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: Luca Coelho <luca@coelho.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Simon Wunderlich <sw@simonwunderlich.de>
Date: Thu, 08 May 2014 12:06:08 +0200
In-Reply-To: <CA+BoTQn0LR9SMzY3zQQXwuPOdkBUgMpADOrHucMKxjouRcap8Q@mail.gmail.com> (sfid-20140507_150310_863492_9BF461EB)
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
	 <1399465244.6800.13.camel@dubbel>
	 <1399466312.10517.34.camel@jlt4.sipsolutions.net>
	 <CA+BoTQmDF2NiWK_PbTYKxFecajiaH6nEPej0ENP7HBZ1ym83sw@mail.gmail.com>
	 <1399467225.10517.35.camel@jlt4.sipsolutions.net>
	 <CA+BoTQn0LR9SMzY3zQQXwuPOdkBUgMpADOrHucMKxjouRcap8Q@mail.gmail.com>
	 (sfid-20140507_150310_863492_9BF461EB)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-05-07 at 15:03 +0200, Michal Kazior wrote:

> I think Luca and I have something like this in mind:
> 
>   drv_chanctx_update(hw,
>     { .type = CHANCTX_NEW_CHANCTX,
>       .chanctx = ctx2,
>     },
>     {
>       .type = CHANCTX_BIND,
>       .vif = vif1,
>       .chanctx_old = ctx1,
>       .chanctx_new = ctx2,
>     },
>     { 0 });
> 
> The driver would be free to re-order this internally to fulfill the
> entire update request.

Yeah, that's just a little complex maybe? And we don't really allow
*arbitrary* transactions, so we'd have to impose limits on the
transactions etc.

In fact, I'd argue that you shouldn't even have the
create/destroy/bind/unbind stuff listed here since that makes it more
difficult for the driver - having this whole "swap()" thing should be
easier to implement.

> Chanctx lifecycle is:
> 
>  drv_add_chanctx()
>  drv_assign_vif_chanctx()
>  // .. more assign/unassign .. possibly drv_change_chanctx()
>  drv_unassign_vif_chanctx()
>  drv_remove_chanctx()
> 
> What I meant by "chanctx allocations" is drv_add_chanctx.
> 
> In particular when I write "chanctx overcommit" I refer to
> drv_add_chanctx() being called when in-driver chanctx count is already
> at peak for given interface combinations.
> 
> Or should we just simply assume this isn't a problem and drivers
> should *always* accept empty chanctx? Why bother with a return value
> then?

No, we shouldn't do that and assume that the driver would reject that.

johannes

