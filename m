Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:24596 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753448AbcAGMwS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jan 2016 07:52:18 -0500
Message-ID: <568E5F7F.4050604@broadcom.com> (sfid-20160107_135223_193865_B617DA3D)
Date: Thu, 7 Jan 2016 13:52:15 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Paul Stewart <pstew@chromium.org>,
	Dan Williams <dcbw@redhat.com>
Subject: Re: [RFC 1/2] nl80211: add extended feature for BSS selection support
References: <1450959550-19655-1-git-send-email-arend@broadcom.com>			 <1450959550-19655-2-git-send-email-arend@broadcom.com>		 <1451985926.12357.16.camel@sipsolutions.net>		 <568B91D6.6080404@broadcom.com>	 <1452011509.12357.51.camel@sipsolutions.net>	 <568CE980.5050005@broadcom.com> <1452090998.2541.18.camel@sipsolutions.net>
In-Reply-To: <1452090998.2541.18.camel@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/06/2016 03:36 PM, Johannes Berg wrote:
> On Wed, 2016-01-06 at 11:16 +0100, Arend van Spriel wrote:
>
>> So do we want want a dedicated "bss selection capability" flag iso
>> extended feature in which the driver can indicate the supported
>> selection criteria to user-space? Guess so.
>
> Frankly, I'm not really quite sure.
>
> The alternative is to just treat all of this as advisory and not worry,
> so that userspace can specify all it wants and the driver will use all
> it can.
>
> That seems mostly reasonable as well.

Agree. However, ne of the reasons I added the ext_feature is because 
people gave feedback they wanted it for testing purposes so they know 
what to expect from the driver. That same argument could used for the 
supported selection criteria. I have no strong opinion though.

>> I played a trick in reusing ATTR_BSS_SELECT_BAND_PREF. When
>> ATTR_BSS_SELECT_RSSI_ADJUST is passed the ATTR_BSS_SELECT_BAND_PREF
>> is
>> used to determine in which band the rssi is adjusted. So "band" and
>> "rssi_adjust" are mutual exclusive.
>
> Yeah, OK, I think that might have confused me a bit :)
>
>>> But logically - does it even make sense? If you already prefer that
>>> band, why give it a boost still? Just disable RSSI? Hmm.
>>
>> I hope the use-cases mentioned clarify this.
>>
>
> Right. So realistically, writing this a bit more verbosely, you have
>
> 1) rssi_preference, band_preference(band)
> 2) rssi_adjust(band, delta), rssi_preference
>
> and perhaps
>
> 3) rssi_preference
>
> as the default?

Good point.

> As for 1), you said it was "band, rssi" but it seems you really meant
> the other way around since before you said "band" was a tie-breaker.

My bad. When using "band_preference()" the selected BSS is in specified 
band even though the BSS in other band would be stronger. If there is no 
proper BSS in the specified band the preference is obviously discarded.

> Perhaps then, the API should just expose the two "primitives"
>   * band_preference(band)
>   * rssi_adjust(band, delta)?

And for use-case number #3:

   * rssi_preference(void)

Gr. AvS
