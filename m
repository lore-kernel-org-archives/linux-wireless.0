Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1607 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757003Ab3DXTQb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Apr 2013 15:16:31 -0400
Message-ID: <51782F84.6070605@broadcom.com> (sfid-20130424_211636_624407_7BB0D744)
Date: Wed, 24 Apr 2013 21:16:20 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Kalle Valo" <kvalo@adurom.com>
cc: "Johannes Berg" <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC v2] cfg80211: Android P2P-Device workaround
References: <1366791988-11309-1-git-send-email-johannes@sipsolutions.net>
 <87mwso5jbx.fsf@purkki.adurom.net>
 <1366800294.11111.7.camel@jlt4.sipsolutions.net>
 <87ehe05hgc.fsf@purkki.adurom.net>
In-Reply-To: <87ehe05hgc.fsf@purkki.adurom.net>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/24/2013 12:52 PM, Kalle Valo wrote:
> Johannes Berg <johannes@sipsolutions.net> writes:
>
>> On Wed, 2013-04-24 at 13:11 +0300, Kalle Valo wrote:
>>> Johannes Berg <johannes@sipsolutions.net> writes:
>>>
>>>> +#ifndef CONFIG_CFG80211_ANDROID_P2P_HACK
>>>>   	if (WARN_ON(wdev->netdev))
>>>>   		return;
>>>> +#endif
>>>
>>> With my favorite kernel macro, config_enabled(), you could get rid of
>>> quite a lot of the ugly ifdefs.
>>
>> Yeah, but as long as this isn't going upstream I don't really want to
>> though since then it touches the code and is less obvious. Anyway we'll
>> see.
>
> Ah, makes send.
>
> FWIW, I think we should push this, and other wireless Android support,
> upstream. We should first get them to use upstream interfaces and then
> start fixing the problematic areas one by one.

I agree. Another big hurdle I see are the android driver private ioctls. 
Do you have a good knowledge about those? I think some of those already 
have a nl80211 equivalent.

Maybe it would be good to update twiki [1] on wireless.kernel.org with 
such information. It seems a bit outdated.

Regards,
Arend

[1] http://wireless.kernel.org/en/developers/Documentation/Android

