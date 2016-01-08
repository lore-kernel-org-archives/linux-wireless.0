Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:53234 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754526AbcAHJSu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jan 2016 04:18:50 -0500
Message-ID: <568F7EF7.2070907@broadcom.com> (sfid-20160108_101855_894116_F928F1F2)
Date: Fri, 8 Jan 2016 10:18:47 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Paul Stewart <pstew@chromium.org>,
	Dan Williams <dcbw@redhat.com>
Subject: Re: [RFC 1/2] nl80211: add extended feature for BSS selection support
References: <1450959550-19655-1-git-send-email-arend@broadcom.com>				 <1450959550-19655-2-git-send-email-arend@broadcom.com>			 <1451985926.12357.16.camel@sipsolutions.net>			 <568B91D6.6080404@broadcom.com>		 <1452011509.12357.51.camel@sipsolutions.net>		 <568CE980.5050005@broadcom.com>	 <1452090998.2541.18.camel@sipsolutions.net> <568E5F7F.4050604@broadcom.com> <1452177663.3141.9.camel@sipsolutions.net>
In-Reply-To: <1452177663.3141.9.camel@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/07/2016 03:41 PM, Johannes Berg wrote:
> On Thu, 2016-01-07 at 13:52 +0100, Arend van Spriel wrote:
>>
>> Agree. However, one of the reasons I added the ext_feature is because
>> people gave feedback they wanted it for testing purposes so they know
>> what to expect from the driver. That same argument could used for the
>> supported selection criteria. I have no strong opinion though.
>
> Yeah, that's true - if we play the "advisory" card then we don't really
> need to add it at all... Not sure what to do really. I'd love to
> specify it very clearly if we need to at all.

Yes. If we add something like this it should be a specific as possible.

> Perhaps for features we can add NL80211_ATTR_BSS_SELECT to the wiphy
> information, and within that add each of the supported
> ATTR_BSS_SELECT_* as an NLA_FLAG? That way at least we don't need to
> define all kinds of new flags in the API.

That sounds like a plan.

>>> Right. So realistically, writing this a bit more verbosely, you
>>> have
>>>
>>> 1) rssi_preference, band_preference(band)
>>> 2) rssi_adjust(band, delta), rssi_preference
>>>
>>> and perhaps
>>>
>>> 3) rssi_preference
>>>
>>> as the default?
>>
>> Good point.
>>
>>> As for 1), you said it was "band, rssi" but it seems you really
>>> meant
>>> the other way around since before you said "band" was a tie-
>>> breaker.
>>
>> My bad. When using "band_preference()" the selected BSS is in specified
>> band even though the BSS in other band would be stronger. If there is no
>> proper BSS in the specified band the preference is obviously
>> discarded.
>
> So 1) really becomes just
>   1) band_preference(band)
>
> without any RSSI at all? Ah, I get it. You have to kind of reword that
> in terms of the logic used:
>
>   1) select_highest_rssi_in_band(band), select_highest_rssi()
>   2) adjust_rssi_if_in_band(band, delta), select_highest_rssi()
>   3) select_highest_rssi()
>
> But if you look at that, then "select_highest_rssi_in_band(band)" is
> really the same as "adjust_rssi_if_in_band(band, 1000)" since you can't
> have real RSSI that high, which leaves us with just a single primitive
> and perhaps a standard value for that "1000"?

True. Although I may have a firmware issue with that as RSSI is probably 
typed as s8 there. At least the adjustment is so can do up to 127 there, 
which would probably be enough as well. I think I prefer an explicit 
primitive though.

>>> Perhaps then, the API should just expose the two "primitives"
>>>    * band_preference(band)
>>>    * rssi_adjust(band, delta)?
>
> I guess it makes even more sense as I just worded it.
>
>>> And for use-case number #3:
>>
>>     * rssi_preference(void)
>
> Yeah although you'd assume that's the default anyway?

That kinda depends on the driver I guess. Currently our driver defaults 
to rssi_adjust(5g, 8) and we restore to that when no BSS_SELECT 
attribute is provided in the .connect() callback.

Regards,
Arend
