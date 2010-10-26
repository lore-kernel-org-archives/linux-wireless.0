Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:39518 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758504Ab0JZWLy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Oct 2010 18:11:54 -0400
Message-ID: <4CC75229.8000109@candelatech.com>
Date: Tue, 26 Oct 2010 15:11:53 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
CC: linux-wireless@vger.kernel.org, kyungwan.nam@atheros.com
Subject: Re: [RFT 0/3] ath9k: more PCU locking enhancements
References: <1288082441-4882-1-git-send-email-lrodriguez@atheros.com> <4CC74F35.60009@candelatech.com> <AANLkTimDQXP-L-C9wos_7i272LFwr0aXAJ2GBjJzDDfV@mail.gmail.com>
In-Reply-To: <AANLkTimDQXP-L-C9wos_7i272LFwr0aXAJ2GBjJzDDfV@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/26/2010 03:03 PM, Luis R. Rodriguez wrote:
> On Tue, Oct 26, 2010 at 2:59 PM, Ben Greear<greearb@candelatech.com>  wrote:
>> On 10/26/2010 01:40 AM, Luis R. Rodriguez wrote:
>>>
>>> Here is some more PCU locking enhancements I tested today
>>> while trying to resolve the WARN() that happens when we
>>> try to stop RX DMA and fail. While working on that I figured
>>> I'd work on the TX DMA stuff too, here's a shot at it. I
>>> can no longer get TX / RX DMA rants, please test and let
>>> me know if you do. I only tried some basic testing like
>>> rmmoding while scannign, which typicallly produced some
>>> errors. Now I don't get squat.
>>>
>>> Ben if you can test wit your super proprietary application
>>> that'd be great.
>>>
>>> This also simplifies locking considerably.
>>>
>>> This doesn't break suspend so I'm happy. It also depends
>>> on the last RX DMA fixes I had posted earlier. If you'd
>>> like to get an all-in-one patch of all my patches pending
>>> you can wget this file and git am it:
>>>
>>>
>>> http://www.kernel.org/pub/linux/kernel/people/mcgrof/patches/tmp/pending-mcgrof-2010-10-26-v1.patch
>>> sha1sum: 874a3cc1a57f7e26ad191cd7b5045315f94c5823
>>
>> I have done some initial testing on the combined patch on top of today's
>> wireless-testing tree.  I also have the memory-barrier patch applied to
>> ath9k, as that is still not upstream.  I have no idea if it has any affect
>> or not (I'm on x86..seems that wmb() stuff was mostly for other platforms?).
>>
>> So far, it is showing zero problems, certainly no memory poison issues.
>>
>> The wireless-testing tree has some lockdep warning related to a mouse driver
>> that disables lockdep early, so it's possible there are lockdep issues
>> waiting.
>>
>> I will let this test run for a while, but it already looks more stable
>> than before, so:
>>
>> Tested-by:  Ben Greear<greearb@candelatech.com>
>
> Awesome! Thanks for testing. So how about the TX dma rants, do you
> still get those?

I've seen no rants at all.

I'm using my standard 130 STAs trying to associate with an AP that will only
take around 30 associations at a time..leads to 100 or so supplications constantly
trying to scan and associate, and I've never seen this test run more than about
10 minutes without poison warnings and/or lockups.  I used to be happy when it got that far :)

We'll do some more interesting tests with APs + STAs, as well as throughput tests, etc
as soon as we get time.  (Basically, hoping for same support that we pushed into ath5k
recently).

If you are aware of any existing/expected issues with multiple APs + STAs,
please let me know.

Thanks,
Ben

>
>    Luis


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

