Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:1174 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985AbcAFKQe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jan 2016 05:16:34 -0500
Message-ID: <568CE980.5050005@broadcom.com> (sfid-20160106_111639_667044_3F2CC4C2)
Date: Wed, 6 Jan 2016 11:16:32 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RFC 1/2] nl80211: add extended feature for BSS selection support
References: <1450959550-19655-1-git-send-email-arend@broadcom.com>		 <1450959550-19655-2-git-send-email-arend@broadcom.com>	 <1451985926.12357.16.camel@sipsolutions.net>	 <568B91D6.6080404@broadcom.com> <1452011509.12357.51.camel@sipsolutions.net>
In-Reply-To: <1452011509.12357.51.camel@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/05/2016 05:31 PM, Johannes Berg wrote:
> On Tue, 2016-01-05 at 10:50 +0100, Arend van Spriel wrote:
>
>>>> +struct cfg80211_bss_selection {
>>>> +> 	> bool present;
>>>> +> 	> enum nl80211_band pref_band;
>>>> +> 	> u8 rssi_adjust;
>>>> +> 	> bool ignore_rssi;
>>>> +};
>>>
>>> Hm. Isn't it possible to specify *some* parameters of these? Or at
>>> least, in the future (if we extend this), it would be?
>>>
>>> Seems that 'present' might want to be a bitmap or so? Or perhaps be
>>> done by using invalid values by default (e.g. NUM_BANDS for no band
>>> preference, etc.)?
>>
>> Ok. I was not sure how to go about this. Our firmware uses an ordered
>> list of selection "keys" with the first being the primary selection
>> key and so on. So there are three "key" types: band, rssi, and
>> rssi_adjust.
>> The latter is not really a selection key, but will do rssi adjustment
>> for BSSes in the specified band.
>
> Ok.
>
>> One of the questions I have is whether the order of a nested list
>> attribute is retained.
>
> It is if you parse it right, but it's not typically something that we
> rely on and take advantage of, so I wouldn't want to do it that way.
> Also, I'm not really sure it'd really be what we wanted to do anyway?

ok

> It seems though that we might need to allow for other drivers having
> other selection criteria, and having a validity flag for each? That
> could go some of the way.

So do we want want a dedicated "bss selection capability" flag iso 
extended feature in which the driver can indicate the supported 
selection criteria to user-space? Guess so.

> To really fully replicate your firmware's capabilities seems difficult,
> though I also don't really see much point, or are you saying you could
> put "rssi" first? But the way you described it in nl80211, with "band"
> being a "tie breaker", it sounds like really "rssi" comes first,
> usually, followed by rssi_adjust and band?

The firmware api is pretty flexible, but I did not want to introduce 
that in nl80211. So I limited it to the two use-cases I know of 1) 
"band, rssi", and 2) "rssi_adjust, rssi". In terms of netlink attributes 
I played a trick in reusing ATTR_BSS_SELECT_BAND_PREF. When 
ATTR_BSS_SELECT_RSSI_ADJUST is passed the ATTR_BSS_SELECT_BAND_PREF is 
used to determine in which band the rssi is adjusted. So "band" and 
"rssi_adjust" are mutual exclusive.

> The other way - band first - could also be done with a huge rssi_adjust
> though (as I said before), so I don't really see much value in having
> all this complexity to start with?
>
>> Ok. Will elaborate. In follow-up email I raise question whether this
>> could/should be a signed value. Any opinion on this?
>
> I didn't see that, but yeah - good question. Would it be supported by
> firmware?

To be honest I had to check, but yes it does.

> But logically - does it even make sense? If you already prefer that
> band, why give it a boost still? Just disable RSSI? Hmm.

I hope the use-cases mentioned clarify this.

Regards,
Arend

