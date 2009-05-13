Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f191.google.com ([209.85.216.191]:39924 "EHLO
	mail-px0-f191.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756922AbZEMXQ0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 May 2009 19:16:26 -0400
Received: by pxi29 with SMTP id 29so395960pxi.33
        for <linux-wireless@vger.kernel.org>; Wed, 13 May 2009 16:16:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1242253626.10076.9.camel@johannes.local>
References: <1242206461-30793-1-git-send-email-lrodriguez@atheros.com>
	<1242206461-30793-3-git-send-email-lrodriguez@atheros.com>
	<1242208388.14227.46.camel@johannes.local> <43e72e890905131020y66111b1nb89a3f17596efca6@mail.gmail.com>
	<b6c5339f0905131100v5ea764cejf005734ce9289290@mail.gmail.com>
	<1242253626.10076.9.camel@johannes.local>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Wed, 13 May 2009 16:08:59 -0700
Message-ID: <43e72e890905131608y4e6400c9x31e37459d7ec4b51@mail.gmail.com>
Subject: Re: [RFC v2 2/5] mac80211: inform devices when we are suspending on
	the stop callback
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Bob Copeland <bcopeland@gmail.com>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 13, 2009 at 3:27 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2009-05-13 at 14:00 -0400, Bob Copeland wrote:
>> On Wed, May 13, 2009 at 1:20 PM, Luis R. Rodriguez
>> <lrodriguez@atheros.com> wrote:
>> > On Wed, May 13, 2009 at 2:53 AM, Johannes Berg
>> > <johannes@sipsolutions.net> wrote:
>> >> On Wed, 2009-05-13 at 05:20 -0400, Luis R. Rodriguez wrote:
>> >>> We inform the drivers so they can take appropriate actions durin=
g
>> >>> suspend for WoW support.
>> >>
>> >>> -static void ar9170_op_stop(struct ieee80211_hw *hw)
>> >>> +static void ar9170_op_stop(struct ieee80211_hw *hw, bool suspen=
d)
>>
>> Just curious, why can't the bus suspend method just turn the radio b=
ack on?
>> You have to set up the wow parameters later anyway.
>>
>> I think it'd be cleaner if the stack knew about WoW somehow rather t=
han
>> doing stuff behind its back in the driver. =C2=A0Then suspend/resume=
 could do
>> the right thing (e.g. ops->wow_enable() instead of stop) if the driv=
er was
>> WoW-capable.
>
> That's a good point. Somehow I thought this was intimately tied to
> suspend. And I think for cfg80211 that makes sense, since cfg80211
> doesn't do much for suspend. But for mac80211 you're right in that it
> would make sense to
> =C2=A0* keep the radio on

This is implicit by not calling stop, right?

> =C2=A0* not call stop

This makes sense for ath9k so far -- I was just exiting out.

> =C2=A0* maybe not remove all the sta info structs

Which ones? In my tests I'm just not removing any.

> =C2=A0* and whatever else may be necessary -- that might even depend =
on the
> =C2=A0 wow mode

So lets start with a basic goal -- magic packet. If you think about it
though if you disassociate you won't get this magic packet so I guess
that's also why we have link-change trigger (or called disassoc
trigger on some other hardware?). Anyway out of these link change and
magic packet seem like a reasonable goal to get working first. For
that besides the above I'm not sure what else is required.

I'm building this stuff now on a box with a card that is supposed to
have WoW working so I'll know for sure if we are missing something
soon.

  Luis
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
