Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.29]:18993 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756293AbYKEUKd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Nov 2008 15:10:33 -0500
Received: by yw-out-2324.google.com with SMTP id 9so109359ywe.1
        for <linux-wireless@vger.kernel.org>; Wed, 05 Nov 2008 12:10:32 -0800 (PST)
Message-ID: <43e72e890811051210v7ecab917u925b20f90d342e72@mail.gmail.com> (sfid-20081105_211040_968141_04437E30)
Date: Wed, 5 Nov 2008 12:10:31 -0800
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 7/7] cfg80211/mac80211: Add Country IE parsing/802.11d support
Cc: linville@tuxdriver.com,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Felix Fietkau" <nbd@openwrt.org>
In-Reply-To: <43e72e890811051210x499dab3bhd4195f592c2aeaf2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1225853406-16322-1-git-send-email-lrodriguez@atheros.com>
	 <1225853406-16322-6-git-send-email-lrodriguez@atheros.com>
	 <1225853406-16322-7-git-send-email-lrodriguez@atheros.com>
	 <1225853406-16322-8-git-send-email-lrodriguez@atheros.com>
	 <1225887783.3619.108.camel@johannes.berg>
	 <43e72e890811050857p7a6e371dq96880853dc310741@mail.gmail.com>
	 <1225908658.3619.135.camel@johannes.berg>
	 <43e72e890811051124g3931e244i3e29c413a05c08f3@mail.gmail.com>
	 <1225914733.3619.150.camel@johannes.berg>
	 <43e72e890811051210x499dab3bhd4195f592c2aeaf2@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 5, 2008 at 12:10 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> On Wed, Nov 5, 2008 at 11:52 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
>> On Wed, 2008-11-05 at 11:24 -0800, Luis R. Rodriguez wrote:
>>> On Wed, Nov 5, 2008 at 10:10 AM, Johannes Berg
>>> <johannes@sipsolutions.net> wrote:
>
>>> >> > When I suggested to use a checksum I was thinking of an easy way to
>>> >> > debounce. But a checksum is never perfect. Hence, the WARN_ON you added
>>> >> > might trigger despite the debounce checksum. Or we might fail to follow
>>> >> > changes.
>>> >>
>>> >> Let me know what you think about the alpha2 + BSSID thing above. I
>>> >> guess it should also consider the environment (I, O, ' ') in case the
>>> >> AP is reconfigured to be outdoor (without being moved). I don't think
>>> >> we should care about supporting these cases on the fly but we should
>>> >> ensure the change won't break things.
>>> >
>>> > Well I haven't checked in detail which things you care about in the IE
>>> > now, but shouldn't you check if those changed?
>>>
>>> We only care about the channel triplet and that has:
>>>
>>> a. Channel start
>>> b. Number of channels
>>> c. Power
>>>
>>> But I think that if the alpha2+environment is the same that's enough
>>> for the STA to assume the BSSID has not changed the IE. At least with
>>> openwrt I need to bring down the interface of the AP to change 11d.
>>> I'd guess most home APs act the same way as in that they require a
>>> reboot or something. On some APs I use I use iwpriv to change it but I
>>> haven't checked to see internally what that will do while its on.
>>>
>>> The checksum really only should be useful if a secondary device tries
>>> to associate to an AP and it gets a country IE. It needs a way to know
>>> if the IE is different than the one an already-present device is
>>> using. What I'm suggesting is that if these things are the same we can
>>> assume it doesn't change: BSSID+alpha2+environment.
>>
>> Ok, checksums are nice to avoid having to memcmp large things, but
>> afaict we're talking about maybe 12 bytes, right?
>
> Depends on the number of triplets, but since we only support 32 reg
> rules this means we only support 32 triplets and therefore we only
> support a max IE of size of 99 bytes (32 * 3 + 3). Realistically in JP
> I expect there to be around 3, 4, or 5 or maybe even 6 triplets which
> is 21 bytes.
>
>> If so, why don't we
>> just keep a copy of the country IE and compare it fully every time?
>
> Eh. I'm inclined to leave the checksum then. We'd then have to bother
> with freeing yet another thing later.
>
>> The way I see it, driver/mac80211 calls cfg80211's
>>        regulatory_11d(wiphy, ie, ie_length)
>> function and that sorts out whether to do anything at all, ignore it
>> because it already knows etc. So regardless of what we do we can just do
>> it all in here and not bother anything elsewhere with checksums,
>> debouncing etc, and will be free to change it easily.
>
> You have sold on this.

I meant you have *me* sold on this. :)

  Luis
