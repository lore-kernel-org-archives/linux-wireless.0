Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f45.google.com ([209.85.219.45]:53232 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795AbaCJJDi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Mar 2014 05:03:38 -0400
Received: by mail-oa0-f45.google.com with SMTP id o6so6725687oag.32
        for <linux-wireless@vger.kernel.org>; Mon, 10 Mar 2014 02:03:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAB3XZEe9Pun657T7GNn8Sx85ARi=K9JQr=G8Mi+Tdci2X2c8cQ@mail.gmail.com>
References: <1394376039-9644-1-git-send-email-luciano.coelho@intel.com>
	<1394376039-9644-4-git-send-email-luciano.coelho@intel.com>
	<CAB3XZEe+-sdGfMupP7x0fKHCfevCtZDY7UrF6rRyL3==pnZf5Q@mail.gmail.com>
	<1394437040.18265.1.camel@dubbel>
	<CAB3XZEe9Pun657T7GNn8Sx85ARi=K9JQr=G8Mi+Tdci2X2c8cQ@mail.gmail.com>
Date: Mon, 10 Mar 2014 10:03:37 +0100
Message-ID: <CA+BoTQmTd5JLJTn7QujSE-6QuVXfcGTLWAiW=LaiGKkGyoYttA@mail.gmail.com> (sfid-20140310_100341_704231_472BB702)
Subject: Re: [PATCH v6 3/3] mac80211: allow reservation of a running chanctx
From: Michal Kazior <michal.kazior@tieto.com>
To: Eliad Peller <eliad@wizery.com>
Cc: Luciano Coelho <luciano.coelho@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	sw@simonwunderlich.de,
	"Otcheretianski, Andrei" <andrei.otcheretianski@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10 March 2014 09:32, Eliad Peller <eliad@wizery.com> wrote:
> On Mon, Mar 10, 2014 at 9:37 AM, Luciano Coelho
> <luciano.coelho@intel.com> wrote:
>> On Sun, 2014-03-09 at 17:13 +0200, Eliad Peller wrote:
>>> On Sun, Mar 9, 2014 at 4:40 PM, Luciano Coelho <luciano.coelho@intel.com> wrote:
>>> > With single-channel drivers, we need to be able to change a running
>>> > chanctx if we want to use chanctx reservation.  Not all drivers may be
>>> > able to do this, so add a flag that indicates support for it.
>>> >
>>> > Changing a running chanctx can also be used as an optimization in
>>> > multi-channel drivers when the context needs to be reserved for future
>>> > usage.
>>> >
>>> > Introduce IEEE80211_CHANCTX_RESERVED chanctx mode to mark a channel as
>>> > reserved so nobody else can use it (since we know it's going to
>>> > change).  In the future, we may allow several vifs to use the same
>>> > reservation as long as they plan to use the chanctx on the same
>>> > future channel.
>>> >
>>> > Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
>>> > ---
>>> [...]
>>>
>>> > @@ -177,7 +198,12 @@ ieee80211_find_chanctx(struct ieee80211_local *local,
>>> >         list_for_each_entry(ctx, &local->chanctx_list, list) {
>>> >                 const struct cfg80211_chan_def *compat;
>>> >
>>> > -               if (ctx->mode == IEEE80211_CHANCTX_EXCLUSIVE)
>>> > +               /* We don't support chanctx reservation for multiple
>>> > +                * vifs yet, so don't allow reserved chanctxs to be
>>> > +                * reused.
>>> > +                */
>>> > +               if ((ctx->mode == IEEE80211_CHANCTX_EXCLUSIVE) ||
>>> > +                   ieee80211_chanctx_is_reserved(local, ctx))
>>> >                         continue;
>>> >
>>> i'm not sure that's correct.
>>> you might want to find a chanctx in order to use it, not only for
>>> reservation. any reason to reject it in this case?
>>
>> At the moment we don't support multi-vifs switching at the same time, so
>> we don't allow anyone else to use a chanctx while it's reserved.
>>
> i'm not talking about multi-vifs switching.
> consider the following scenario:
> sta connected on channel 40
> ap beaconing on channel 60
>
> now, you want (for whatever reason) to switch the ap to channel 40.
> you'll reserve the sta's chanctx, and increase its refcount (to 2).
>
> now a new sta vif is added, and tries to connect on channel 40.
> the check above will skip the existing channel context (because it's
> also reserved) although there is no reason it won't be used.

Good point. I have this case covered in my multi-vif csa patches. We
could transplant it into Luca's patch?


Michał
