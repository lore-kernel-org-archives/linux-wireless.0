Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:64309 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753378AbaEHKlv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 May 2014 06:41:51 -0400
Received: by mail-wi0-f170.google.com with SMTP id bs8so782678wib.1
        for <linux-wireless@vger.kernel.org>; Thu, 08 May 2014 03:41:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1399543568.9163.5.camel@jlt4.sipsolutions.net>
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
	<1399543568.9163.5.camel@jlt4.sipsolutions.net>
Date: Thu, 8 May 2014 12:41:50 +0200
Message-ID: <CA+BoTQk_hm-dgNftTK_WdPQFNgD9WyRG01sPQ0vcO=cw7+BNrg@mail.gmail.com> (sfid-20140508_125201_163499_553133B8)
Subject: Re: [PATCH v5] mac80211: implement multi-vif in-place reservations
From: Michal Kazior <michal.kazior@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Luca Coelho <luca@coelho.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Simon Wunderlich <sw@simonwunderlich.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 8 May 2014 12:06, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Wed, 2014-05-07 at 15:03 +0200, Michal Kazior wrote:
>
>> I think Luca and I have something like this in mind:
>>
>>   drv_chanctx_update(hw,
>>     { .type = CHANCTX_NEW_CHANCTX,
>>       .chanctx = ctx2,
>>     },
>>     {
>>       .type = CHANCTX_BIND,
>>       .vif = vif1,
>>       .chanctx_old = ctx1,
>>       .chanctx_new = ctx2,
>>     },
>>     { 0 });
>>
>> The driver would be free to re-order this internally to fulfill the
>> entire update request.
>
> Yeah, that's just a little complex maybe? And we don't really allow
> *arbitrary* transactions, so we'd have to impose limits on the
> transactions etc.

Yeah. I also get the feeling it's overly complex.


>> Chanctx lifecycle is:
>>
>>  drv_add_chanctx()
>>  drv_assign_vif_chanctx()
>>  // .. more assign/unassign .. possibly drv_change_chanctx()
>>  drv_unassign_vif_chanctx()
>>  drv_remove_chanctx()
>>
>> What I meant by "chanctx allocations" is drv_add_chanctx.
>>
>> In particular when I write "chanctx overcommit" I refer to
>> drv_add_chanctx() being called when in-driver chanctx count is already
>> at peak for given interface combinations.
>>
>> Or should we just simply assume this isn't a problem and drivers
>> should *always* accept empty chanctx? Why bother with a return value
>> then?
>
> No, we shouldn't do that and assume that the driver would reject that.

Then, if you want to avoid the chanctx overcommit problem, you need to
make switch_vif_chanctx() to act as drv_add_chanctx(old_ctx) and
drv_remove_chanctx(new_ctx) implicitly, i.e.

 drv_switch_vif_chanctx(hw, vifs, n_vifs, old_ctx, new_ctx, SWAP);

instead of:

 drv_add_chanctx(new_ctx);
 drv_switch_vif_chanctx(hw, vifs, n_vifs, old_ctx, new_ctx, SWAP);
 drv_remove_chanctx(old_ctx);


Michał
