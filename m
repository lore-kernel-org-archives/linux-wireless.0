Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:51280 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759817Ab0J0QRe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Oct 2010 12:17:34 -0400
Message-ID: <4CC8509C.3040902@candelatech.com>
Date: Wed, 27 Oct 2010 09:17:32 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
CC: linux-wireless@vger.kernel.org, kyungwan.nam@atheros.com
Subject: Re: [RFT 0/3] ath9k: more PCU locking enhancements
References: <1288082441-4882-1-git-send-email-lrodriguez@atheros.com> <4CC74F35.60009@candelatech.com> <AANLkTimDQXP-L-C9wos_7i272LFwr0aXAJ2GBjJzDDfV@mail.gmail.com> <4CC75229.8000109@candelatech.com> <AANLkTi=uNzTuaq9yrG6Z0DbxF9z=JzPe=155rkvLPkD9@mail.gmail.com>
In-Reply-To: <AANLkTi=uNzTuaq9yrG6Z0DbxF9z=JzPe=155rkvLPkD9@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/26/2010 03:17 PM, Luis R. Rodriguez wrote:
> On Tue, Oct 26, 2010 at 3:11 PM, Ben Greear<greearb@candelatech.com>  wrote:
>> On 10/26/2010 03:03 PM, Luis R. Rodriguez wrote:
>>>
>>> On Tue, Oct 26, 2010 at 2:59 PM, Ben Greear<greearb@candelatech.com>
>>>   wrote:
>>>>
>>>> On 10/26/2010 01:40 AM, Luis R. Rodriguez wrote:
>>>>>
>>>>> Here is some more PCU locking enhancements I tested today
>>>>> while trying to resolve the WARN() that happens when we
>>>>> try to stop RX DMA and fail. While working on that I figured
>>>>> I'd work on the TX DMA stuff too, here's a shot at it. I
>>>>> can no longer get TX / RX DMA rants, please test and let
>>>>> me know if you do. I only tried some basic testing like
>>>>> rmmoding while scannign, which typicallly produced some
>>>>> errors. Now I don't get squat.
>>>>>
>>>>> Ben if you can test wit your super proprietary application
>>>>> that'd be great.
>>>>>
>>>>> This also simplifies locking considerably.
>>>>>
>>>>> This doesn't break suspend so I'm happy. It also depends
>>>>> on the last RX DMA fixes I had posted earlier. If you'd
>>>>> like to get an all-in-one patch of all my patches pending
>>>>> you can wget this file and git am it:
>>>>>
>>>>>
>>>>>
>>>>> http://www.kernel.org/pub/linux/kernel/people/mcgrof/patches/tmp/pending-mcgrof-2010-10-26-v1.patch
>>>>> sha1sum: 874a3cc1a57f7e26ad191cd7b5045315f94c5823
>>>>
>>>> I have done some initial testing on the combined patch on top of today's
>>>> wireless-testing tree.  I also have the memory-barrier patch applied to
>>>> ath9k, as that is still not upstream.  I have no idea if it has any
>>>> affect
>>>> or not (I'm on x86..seems that wmb() stuff was mostly for other
>>>> platforms?).
>>>>
>>>> So far, it is showing zero problems, certainly no memory poison issues.
>>>>
>>>> The wireless-testing tree has some lockdep warning related to a mouse
>>>> driver
>>>> that disables lockdep early, so it's possible there are lockdep issues
>>>> waiting.
>>>>
>>>> I will let this test run for a while, but it already looks more stable
>>>> than before, so:
>>>>
>>>> Tested-by:  Ben Greear<greearb@candelatech.com>
>>>
>>> Awesome! Thanks for testing. So how about the TX dma rants, do you
>>> still get those?
>>
>> I've seen no rants at all.
>
> Fucking awesome!
>
>> I'm using my standard 130 STAs
>
> I love how now 130 STAs are "standard" for ath9k tests :)

I dropped it down to 30 STAs so that all could associate and
be stable with my AP.  I set up a tcp stream running as fast as it could between
two virtual STAs.  It ran about 9Mbps bi-directional overnight
with no obvious problems.

One way or another, I will probably end up backporting this to 2.6.36,
so it wouldn't bother me at all to see these changes show up in stable.

We'll keep testing various scenarios in the meantime...

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

