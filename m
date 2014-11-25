Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:1554 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983AbaKYPJ3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Nov 2014 10:09:29 -0500
Message-ID: <54749BA6.5010303@broadcom.com> (sfid-20141125_160933_261793_02C82F2B)
Date: Tue, 25 Nov 2014 16:09:26 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: YanBo <dreamfly281@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: check if channels allow 80 MHz for VHT probe
 requests
References: <1416911009-22405-1-git-send-email-johannes@sipsolutions.net>	 <CAFuUQkh-fX3rz9+FUBfF8GxbkxrZxP7-iJwmypo5EEANwODqzQ@mail.gmail.com>	 <1416913453.2045.4.camel@sipsolutions.net>	 <CAFuUQkhuUDVcfv-pxLkhNT7C2TOqOS4nh+3qDj0uFV3OpoAS5w@mail.gmail.com>	 <1416917279.2045.5.camel@sipsolutions.net>	 <CAFuUQkiXfYf1s4UJyvtFT9Jsh=Dd_1vYH6XiJ0B5iSfRxWA8dQ@mail.gmail.com>	 (sfid-20141125_151401_364139_C8F262C6) <1416925085.2045.7.camel@sipsolutions.net>
In-Reply-To: <1416925085.2045.7.camel@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/25/14 15:18, Johannes Berg wrote:
> On Tue, 2014-11-25 at 22:13 +0800, YanBo wrote:
>
>>> But is all of that really the right way? I'm not completely convinced.
>>
>> Except set the flag, the HW itself should support this feature, or
>> else it also doesn't work, I'd
>> send the patch in soon for public review.
>
> Yeah, but is it really the right way to advertise VHT? In the spec, VHT
> means you also have 80 MHz support - do you really think you can/will do
> 80 MHz on 2.4 GHz? Seems like all of this will cause more corner cases.

For brcmfmac, the 80 MHz requirement in the spec was exactly the reason 
to *not* advertise VHT in 2.4G.

>>>
>>> I guess we can make this check conditional for 5GHz when the VHT support
>>> lands and is discussed.
>>>
>> That is sounds good if it only check for 5GHz for what I know CMIIW.
>
> Even on 2.4 GHz it technically isn't enough though - there's enough
> spectrum in 2.4 GHz for a single 80 MHz channel; how long until somebody
> wants to do *that* for some reason? But the rest of us really doesn't
> think that's applicable ...

To get "friendly" with your neighbors :-p

Regards,
Arend

> Anyway, it probably needs mac80211 patches anyway since mlme.c already
> disables VHT if you can't do 80 MHz, so I think you should post those as
> part of a bigger discussion about how we want to support it and what it
> really means etc.
>
> johannes
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

