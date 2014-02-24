Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:35809 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720AbaBXFCC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Feb 2014 00:02:02 -0500
Received: by mail-wi0-f174.google.com with SMTP id f8so2604158wiw.7
        for <linux-wireless@vger.kernel.org>; Sun, 23 Feb 2014 21:02:00 -0800 (PST)
Message-ID: <530AD245.7090204@gmail.com> (sfid-20140224_060205_929080_2FA553FF)
Date: Mon, 24 Feb 2014 07:01:57 +0200
From: Emmanuel Grumbach <egrumbach@gmail.com>
MIME-Version: 1.0
To: Stephen Kent <smkent@smkent.net>
CC: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>
Subject: Re: [Ilw] RX laggy/choppy/stuck without TX on Intel Wireless 7260
 with iwlwifi
References: <CAC45b7kjErBZ=bZEnbsmdbXkEowQRtkkoN-obSxpn3cRLrCvwQ@mail.gmail.com>	<0BA3FCBA62E2DC44AF3030971E174FB303D6FFEB@HASMSX103.ger.corp.intel.com>	<CAC45b7ma=+QY1_woBPC44UkBeiWOG+iUNrScJ0gJ9qVfirNGsw@mail.gmail.com>	<0BA3FCBA62E2DC44AF3030971E174FB303D7004C@HASMSX103.ger.corp.intel.com>	<530A53E5.6000301@gmail.com>	<CAC45b7nRAhU=2aBAHKQmNdjCC4WZOBsQUa1XCyRZ+aFoTA0BAA@mail.gmail.com>	<530AC4E3.8030002@gmail.com> <CAC45b7mGq3ykRxXu2qAvJQ-PaWBzQpW5VhGg6hxCqiSS7umQrw@mail.gmail.com>
In-Reply-To: <CAC45b7mGq3ykRxXu2qAvJQ-PaWBzQpW5VhGg6hxCqiSS7umQrw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 02/24/2014 06:19 AM, Stephen Kent wrote:
> On Sun, Feb 23, 2014 at 8:04 PM, Emmanuel Grumbach <egrumbach@gmail.com> wrote:
>>
>>
>>>>>
>>>>
>>>> Could you please try to reproduce with power save disabled?
>>>>
>>>> options iwlmvm power_scheme=1
>>>>
>>>> Thanks.
>>>
>>>
>>> Huh, interesting. When I set that option the problem seems to go away.
>>> I flipped back and forth between power_scheme=1 and power_scheme=2 in
>>> iwlmvm (modinfo says 2 is the default), and the problem didn't
>>> reproduce when power_scheme=1. I assume my battery life will suffer if
>>> I permanently set power_scheme=1? :-)
>>>
>>> Should I take a new trace or gather any other information?
>>
>> Not needed
>>
>>>
>>> I won't be my computer all day but I'll be able to respond / collect
>>> any needed info intermittently.
>>>
>>
>> I guess the best would be to upgrade to 3.13.5 with new firmware... Or to stay with power_scheme=1 in the meantime.
>>
>>
>>> Thanks,
>>>
>>> Stephen
>>>
> 
> 
> OK. Was this a bug that was identified and fixed between 3.11 and
> 3.13.5? I looked briefly at the kernel git log messages at
> https://github.com/torvalds/linux/commits/master/drivers/net/wireless/iwlwifi/mvm
> but I am completely unfamiliar with this code.

No - I can't think about any patch that could fix your issue. But 3.13 supports a newer firmware in which the power save code has been rewritten.

> 
> Until I upgrade, I'll just set power_scheme=1.
> 
> Thanks again for your help!
> 
> Stephen
> 
