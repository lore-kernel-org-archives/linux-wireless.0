Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f191.google.com ([209.85.216.191]:55318 "EHLO
	mail-px0-f191.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761693AbZEMXZh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 May 2009 19:25:37 -0400
Received: by pxi29 with SMTP id 29so397315pxi.33
        for <linux-wireless@vger.kernel.org>; Wed, 13 May 2009 16:25:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1242256426.10076.14.camel@johannes.local>
References: <1242206461-30793-1-git-send-email-lrodriguez@atheros.com>
	<1242206461-30793-3-git-send-email-lrodriguez@atheros.com>
	<1242208388.14227.46.camel@johannes.local> <43e72e890905131020y66111b1nb89a3f17596efca6@mail.gmail.com>
	<b6c5339f0905131100v5ea764cejf005734ce9289290@mail.gmail.com>
	<1242253626.10076.9.camel@johannes.local> <43e72e890905131608y4e6400c9x31e37459d7ec4b51@mail.gmail.com>
	<1242256426.10076.14.camel@johannes.local>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Wed, 13 May 2009 16:25:18 -0700
Message-ID: <43e72e890905131625m5a4245bbye61f3e22cb4baae5@mail.gmail.com>
Subject: Re: [RFC v2 2/5] mac80211: inform devices when we are suspending on
	the stop callback
To: Johannes Berg <johannes@sipsolutions.net>,
	Jouni Malinen <Jouni.Malinen@atheros.com>
Cc: Bob Copeland <bcopeland@gmail.com>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 13, 2009 at 4:13 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2009-05-13 at 16:08 -0700, Luis R. Rodriguez wrote:

>> > =C2=A0* maybe not remove all the sta info structs
>>
>> Which ones? In my tests I'm just not removing any.
>
> I'm talking about sta_notify() not code :)

Oh I wasn't talking about code either but about early exist stuff I
was doing upon __ieee80211_suspend().

>> > =C2=A0* and whatever else may be necessary -- that might even depe=
nd on the
>> > =C2=A0 wow mode
>>
>> So lets start with a basic goal -- magic packet. If you think about =
it
>> though if you disassociate you won't get this magic packet
>
> Actually I think you still can or something, it's very strange. Does
> anyone have a WoW documentation/spec?

Good question. I'll poke internally see what I can get.

>> so I guess
>> that's also why we have link-change trigger (or called disassoc
>> trigger on some other hardware?).
>
> That could make some sense, though do you want to wake up, reassociat=
e
> (if possible) and go to sleep again? That would take some
> synchronisation across layers...

I hope not, but anyway if that is done someone can use custom scripts
to go back to sleep, or do we even want to bother passing this up to
the supplicant as an event upon resume? Hmm -- yeah Jouni, would the
supplicant benefit from having WoW events sent back to it after
resume, or even before suspend?

>> =C2=A0Anyway out of these link change and
>> magic packet seem like a reasonable goal to get working first. For
>> that besides the above I'm not sure what else is required.
>>
>> I'm building this stuff now on a box with a card that is supposed to
>> have WoW working so I'll know for sure if we are missing something
>> soon.
>
> Cool.
>
> Anyway I think Bob is right, we may not need to have anything added t=
o
> ->stop() and instead do some wow config, or something. Too tired to
> think about it I think.

I added a WOW hw config, if we use that then we need a way for the
device to get the wow config stuff. I was thinking we'd use the
wiphy->wow for that but it seems you rather we just pass the settings
completely up once and let the driver worry how to stuff this in the
driver somewhere.

 Luis
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
