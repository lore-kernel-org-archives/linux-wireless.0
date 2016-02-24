Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:38304 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752947AbcBXNYH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Feb 2016 08:24:07 -0500
Message-ID: <56CDAEF6.1080606@candelatech.com> (sfid-20160224_142411_503349_E6E13FF3)
Date: Wed, 24 Feb 2016 05:24:06 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Arik Nemtsov <arik@wizery.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: Let VHT work on 2.4Ghz
References: <1456180974-21062-1-git-send-email-greearb@candelatech.com> <CA+XVXffpNDf0-5a6cPz0aUrrRfHgKQeu09zDt5eSe1K87m__pw@mail.gmail.com> <56CC62BC.308@candelatech.com> <CA+XVXffxWtZgfZS=EZGYng6vWMxqnhTdhgxagYXRbKq1iYj0Sg@mail.gmail.com>
In-Reply-To: <CA+XVXffxWtZgfZS=EZGYng6vWMxqnhTdhgxagYXRbKq1iYj0Sg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 02/24/2016 12:40 AM, Arik Nemtsov wrote:
> On Tue, Feb 23, 2016 at 3:46 PM, Ben Greear <greearb@candelatech.com> wrote:
>>
>>
>> On 02/23/2016 02:47 AM, Arik Nemtsov wrote:
>>>
>>> On Tue, Feb 23, 2016 at 12:42 AM, <greearb@candelatech.com> wrote:
>>>>
>>>>
>>>> From: Ben Greear <greearb@candelatech.com>
>>>>
>>>> ath10k supports VHT on 2.4Ghz band.
>>>> If supplicant and hostapd and radio think
>>>> VHT should be allowed, then kernel should let them
>>>> try.
>>>
>>>
>>> Removing the 80Mhz check entirely is not the right way to go IMO. The
>>> check is there because there are countries where VHT rates are not
>>> allowed, even on 20MHz channels. We use the fact these countries have
>>> no 80MHz-allowed ranges as a crude regulatory hint to disable VHT
>>> entirely. I'm not sure about the regulatory landscape in these
>>> countries regarding VHT in 2.4GHz, but please don't break compliance
>>> for the 5Ghz use-case.
>>
>>
>> Maybe someone can fix the regulatory logic then?
>>
>> Add a no-vht flag or whatever?
>
> This is more tricky that it looks at first - basically current
> regulatory "hooks" concern channel width and location, transmit power
> etc. Here regulatory compliance means never emitting the VHT IE in
> probe requests etc. So a "no vht" flag would be useless to the reg.c
> code - it currently never looks at IEs. Some cards even generate them
> at the FW level.
> All in all I think the current small bit of ugliness is justified for
> regulatory compliance.
>
> Also it's pretty easy to just leave the code there and condition the
> check on the 5GHz band. There's no need to remove it.

Ok, so I can enable VHT on any band as long as the 5Ghz band exists and
allows 80Mhz?

Thanks,
Ben

>
>>
>> Any idea which countries this applies to?
>
> I know Russia is one such country. Not sure about others.
>
> Arik
>

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
