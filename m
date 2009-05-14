Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.172]:23676 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753805AbZENWCB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 May 2009 18:02:01 -0400
Received: by wf-out-1314.google.com with SMTP id 26so944423wfd.4
        for <linux-wireless@vger.kernel.org>; Thu, 14 May 2009 15:02:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <43e72e890905131625m5a4245bbye61f3e22cb4baae5@mail.gmail.com>
References: <1242206461-30793-1-git-send-email-lrodriguez@atheros.com>
	<1242206461-30793-3-git-send-email-lrodriguez@atheros.com>
	<1242208388.14227.46.camel@johannes.local> <43e72e890905131020y66111b1nb89a3f17596efca6@mail.gmail.com>
	<b6c5339f0905131100v5ea764cejf005734ce9289290@mail.gmail.com>
	<1242253626.10076.9.camel@johannes.local> <43e72e890905131608y4e6400c9x31e37459d7ec4b51@mail.gmail.com>
	<1242256426.10076.14.camel@johannes.local> <43e72e890905131625m5a4245bbye61f3e22cb4baae5@mail.gmail.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Thu, 14 May 2009 15:01:42 -0700
Message-ID: <43e72e890905141501v10e85ea9o73c0ecea75a7317d@mail.gmail.com>
Subject: Re: [RFC v2 2/5] mac80211: inform devices when we are suspending on
	the stop callback
To: Johannes Berg <johannes@sipsolutions.net>,
	Jouni Malinen <Jouni.Malinen@atheros.com>
Cc: Bob Copeland <bcopeland@gmail.com>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 13, 2009 at 4:25 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> On Wed, May 13, 2009 at 4:13 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
>> On Wed, 2009-05-13 at 16:08 -0700, Luis R. Rodriguez wrote:
>
>>> >  * maybe not remove all the sta info structs
>>>
>>> Which ones? In my tests I'm just not removing any.
>>
>> I'm talking about sta_notify() not code :)
>
> Oh I wasn't talking about code either but about early exist stuff I
> was doing upon __ieee80211_suspend().
>
>>> >  * and whatever else may be necessary -- that might even depend on the
>>> >   wow mode
>>>
>>> So lets start with a basic goal -- magic packet. If you think about it
>>> though if you disassociate you won't get this magic packet
>>
>> Actually I think you still can or something, it's very strange. Does
>> anyone have a WoW documentation/spec?
>
> Good question. I'll poke internally see what I can get.

I've documented everything generic I learned about WoW here:

http://wireless.kernel.org/en/users/Documentation/WoW

At least for Atheros devices it seems we must not disassociate the
device as we just have hardware and we need to keep it in that state.

>>> so I guess
>>> that's also why we have link-change trigger (or called disassoc
>>> trigger on some other hardware?).
>>
>> That could make some sense, though do you want to wake up, reassociate
>> (if possible) and go to sleep again? That would take some
>> synchronisation across layers...
>
> I hope not, but anyway if that is done someone can use custom scripts
> to go back to sleep, or do we even want to bother passing this up to
> the supplicant as an event upon resume? Hmm -- yeah Jouni, would the
> supplicant benefit from having WoW events sent back to it after
> resume, or even before suspend?
>
>>>  Anyway out of these link change and
>>> magic packet seem like a reasonable goal to get working first. For
>>> that besides the above I'm not sure what else is required.
>>>
>>> I'm building this stuff now on a box with a card that is supposed to
>>> have WoW working so I'll know for sure if we are missing something
>>> soon.
>>
>> Cool.
>>
>> Anyway I think Bob is right, we may not need to have anything added to
>> ->stop() and instead do some wow config, or something. Too tired to
>> think about it I think.
>
> I added a WOW hw config, if we use that then we need a way for the
> device to get the wow config stuff. I was thinking we'd use the
> wiphy->wow for that but it seems you rather we just pass the settings
> completely up once and let the driver worry how to stuff this in the
> driver somewhere.

As for mac80211 it seems we should not call drv stop and also not
disassociate when wow is enabled. We could take care of this by adding
a wow_enable cfg callback as Bob had suggested and let mac80211 update
the ieee80211_hw.wow_enabled triggers passed. We'll need these enabled
triggers in mac80211 to be able to decide things we should do while
WoW is enabled (during suspend && wow_enabled).

If we stuff wow_enabled_triggers into into ieee80211_hw we don't
really need a mac80211 hw config change notice to drivers. At least
ath9k doesn't need it. If we want to hide this from drivers and want
them to keep track of this internally we could stuff the
wow_triggers_enabled into the local and then use the config to let
drivers store it internally themselves as well. But that just seems
more code and not sure what the advantage is.

During its driver's suspend callback drivers can do what it thinks is
best. This means we don't have to bother with the mac80211 stop
callback changes at all and just let mac80211 handle the upper layer
stuff and the driver just handle the suspend / wow stuff.

Sound OK?

  Luis
