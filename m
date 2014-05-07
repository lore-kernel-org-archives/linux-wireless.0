Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f173.google.com ([74.125.82.173]:55979 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754472AbaEGNDL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 May 2014 09:03:11 -0400
Received: by mail-we0-f173.google.com with SMTP id u57so946978wes.4
        for <linux-wireless@vger.kernel.org>; Wed, 07 May 2014 06:03:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1399467225.10517.35.camel@jlt4.sipsolutions.net>
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
Date: Wed, 7 May 2014 15:03:10 +0200
Message-ID: <CA+BoTQn0LR9SMzY3zQQXwuPOdkBUgMpADOrHucMKxjouRcap8Q@mail.gmail.com> (sfid-20140507_150315_073583_3F0C15CF)
Subject: Re: [PATCH v5] mac80211: implement multi-vif in-place reservations
From: Michal Kazior <michal.kazior@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Luca Coelho <luca@coelho.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Simon Wunderlich <sw@simonwunderlich.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 7 May 2014 14:53, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Wed, 2014-05-07 at 14:44 +0200, Michal Kazior wrote:
>
>> > Ultimately, what I'm trying to say is that instead of the proposed
>> > switch_vif_chanctx(), we need to have this:
>> >
>> > enum ieee80211_chanctx_switch_mode - as before
>> >
>> >         (*switch_vif_chanctx)(struct ieee80211_hw *hw,
>> >                               struct ieee80211_vif **vifs, int n_vifs,
>> >                               struct ieee80211_chanctx_conf *old_ctx,
>> >                               struct ieee80211_chanctx_conf *new_ctx,
>> >                               enum ieee80211_chanctx_switch_mode mode);
>>
>> Yeah. This is another way to do it. It does solve the edge case when
>> you're maxing out on different channels.
>
> I thought this was what you were proposing :)

I think Luca and I have something like this in mind:

  drv_chanctx_update(hw,
    { .type = CHANCTX_NEW_CHANCTX,
      .chanctx = ctx2,
    },
    {
      .type = CHANCTX_BIND,
      .vif = vif1,
      .chanctx_old = ctx1,
      .chanctx_new = ctx2,
    },
    { 0 });

The driver would be free to re-order this internally to fulfill the
entire update request.


>> It doesn't, however, (if you don't do transactions) prevent from
>> chanctx overcommit (i.e. you still can end up with more, albeit
>> "idle", chanctx allocations in driver).
>
> That I don't understand again - what do you mean by "chanctx
> allocations"?

Chanctx lifecycle is:

 drv_add_chanctx()
 drv_assign_vif_chanctx()
 // .. more assign/unassign .. possibly drv_change_chanctx()
 drv_unassign_vif_chanctx()
 drv_remove_chanctx()

What I meant by "chanctx allocations" is drv_add_chanctx.

In particular when I write "chanctx overcommit" I refer to
drv_add_chanctx() being called when in-driver chanctx count is already
at peak for given interface combinations.

Or should we just simply assume this isn't a problem and drivers
should *always* accept empty chanctx? Why bother with a return value
then?


Michał
