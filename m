Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.28]:63298 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753125AbYKETcY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Nov 2008 14:32:24 -0500
Received: by yx-out-2324.google.com with SMTP id 8so98715yxm.1
        for <linux-wireless@vger.kernel.org>; Wed, 05 Nov 2008 11:32:22 -0800 (PST)
Message-ID: <43e72e890811051124g3931e244i3e29c413a05c08f3@mail.gmail.com> (sfid-20081105_203228_994604_4D2D0707)
Date: Wed, 5 Nov 2008 11:24:08 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 7/7] cfg80211/mac80211: Add Country IE parsing/802.11d support
Cc: linville@tuxdriver.com,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Felix Fietkau" <nbd@openwrt.org>
In-Reply-To: <1225908658.3619.135.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1225853406-16322-1-git-send-email-lrodriguez@atheros.com>
	 <1225853406-16322-3-git-send-email-lrodriguez@atheros.com>
	 <1225853406-16322-4-git-send-email-lrodriguez@atheros.com>
	 <1225853406-16322-5-git-send-email-lrodriguez@atheros.com>
	 <1225853406-16322-6-git-send-email-lrodriguez@atheros.com>
	 <1225853406-16322-7-git-send-email-lrodriguez@atheros.com>
	 <1225853406-16322-8-git-send-email-lrodriguez@atheros.com>
	 <1225887783.3619.108.camel@johannes.berg>
	 <43e72e890811050857p7a6e371dq96880853dc310741@mail.gmail.com>
	 <1225908658.3619.135.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 5, 2008 at 10:10 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2008-11-05 at 08:57 -0800, Luis R. Rodriguez wrote:
>
>> >> +/*
>> >> + * IEEE 802.11-2007 7.3.2.9 Country information element
>> >> + *
>> >> + * Minimum length is 8 octects, ie len must be evenly
>> >> + * divisible by 2
>> >> + */
>> >
>> > That seems odd, I thought there are triplets in there? That mean it
>> > should be 2+N*3, no?
>>
>> Forgot the environment 'I', 'O' or ' '.
>>
>> alpha+environment (3) + n * 3
>
> But then it should be evenly divisible by three, not two, right?

Nope, the end of the IE requires a pad to make it divisible by 2.

> And 8
> doesn't make sense as a minimum length either then.

Agreed :) but that's exactly why I put those comments there.

>> >> + */
>> >> +#define IEEE80211_COUNTRY_EXTENSION_ID 201
>> >
>> > Should that be something like EXTENSION_ID_OFFSET? Clearly they must
>> > mean to subtract this?
>>
>> Sure but just to determine if it is a new one as they seem to come in
>> increasing.
>
> Oh ok, I thought it was ok to have multiple in the same IE or something.

Well you can pass multiple triplets for extensions it seems but I
think this thing remains constant across them. The spec doesn't
elaborate much on this. Jouni mentioned the AP just increments this
when generating the IEs and its used, that's all.

>> > Ok this I don't understand. Why the checksum thing? Why pass the
>> > regdomain struct in? Can't cfg80211 do the work of parsing the IE and
>> > you just parse the IE in, possibly "debouncing" when it hasn't changed
>> > (or do the debouncing in cfg80211 too, for the overhead of an extra
>> > function call)
>>
>> It seems wrong to offload onto cfg80211 some IE parsing work even if
>> its related to regulatory. Are you sure you want that?
>
> Why not? My scanning patch for cfg80211 also offloaded all of the
> parsing to it.

OK fine, just wanted to double check :)

>> So we want two things:
>>
>> 1. A very quick and efficient way to determine if we can ignore the IE
>> processing in case the IE has already been processed
>> 2.  A quick way to determine if a new device can ignore IE processing
>>
>> The alpha2 on the registered interface solves the first
>> The checksum solves the second
>
> Ok, but why put anything of that outside cfg80211?

Alright, I'll respin.

>> If we leave the checksumming outside we need the helpers to check the
>> checksum exported. Otherwise then definitely we can stuff it into
>> cfg80211 but that means for a second device you'll pass the IE pointer
>> and len as part of the regulatory_hint_ie() and it *can* fail for
>> several reasons (-EALREADY, -EINVAL, -ENOMEM).
>
> Except nobody will care about the return value, so you might as well
> leave it off, no?

Sure.

>> Another thing we should consider here is the case of an Indoor AP and
>> an Outdoor AP. According to Felix this is very possible and he's dealt
>> with it. I doubt 11d is being used in those cases but regardless it
>> seems we should account for it and deal with it. In that case it seems
>> two different registered devices can be using one country but
>> different environments. I have kept this in mind but admit not
>> thoroughly. I think its good to see now what changes we'll need. Maybe
>> we can deal with this later on though.
>
> We may well need different indoor/outdoor settings at some point and a
> way to tell the kernel which device is out/indoors, but that seems to
> only affect TX power so I wouldn't worry about it too much for now.

Sure.

>> >>       case REGDOM_SET_BY_USER:
>> >>               if (last_request->initiator == REGDOM_SET_BY_COUNTRY_IE)
>> >>                       return REG_INTERSECT;
>> >> +             /* If the user knows better the user should set the regdom
>> >> +              * to their country before the IE is picked up */
>> >> +             if (last_request->initiator == REGDOM_SET_BY_USER &&
>> >> +                             last_request->intersect)
>> >> +                     return -EOPNOTSUPP;
>> >
>> > Can you use a more customary indentation of the second if line to just
>> > after the parenthesis?
>>
>> Like what
>>
>> if (foo ||
>> <TAB><SPACE><SPACE>bar)
>> <TAB><TAB>bar;
>>
>> ?
>
> at least that's what I do, yeah, sorry if this seems too trivial, if you
> wouldn't have to respin the patch anyway I wouldn't even mention it.

OK

>> > When I suggested to use a checksum I was thinking of an easy way to
>> > debounce. But a checksum is never perfect. Hence, the WARN_ON you added
>> > might trigger despite the debounce checksum. Or we might fail to follow
>> > changes.
>>
>> Let me know what you think about the alpha2 + BSSID thing above. I
>> guess it should also consider the environment (I, O, ' ') in case the
>> AP is reconfigured to be outdoor (without being moved). I don't think
>> we should care about supporting these cases on the fly but we should
>> ensure the change won't break things.
>
> Well I haven't checked in detail which things you care about in the IE
> now, but shouldn't you check if those changed?

We only care about the channel triplet and that has:

a. Channel start
b. Number of channels
c. Power

But I think that if the alpha2+environment is the same that's enough
for the STA to assume the BSSID has not changed the IE. At least with
openwrt I need to bring down the interface of the AP to change 11d.
I'd guess most home APs act the same way as in that they require a
reboot or something. On some APs I use I use iwpriv to change it but I
haven't checked to see internally what that will do while its on.

The checksum really only should be useful if a secondary device tries
to associate to an AP and it gets a country IE. It needs a way to know
if the IE is different than the one an already-present device is
using. What I'm suggesting is that if these things are the same we can
assume it doesn't change: BSSID+alpha2+environment.

  Luis
