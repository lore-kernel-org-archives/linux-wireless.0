Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:47596 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251Ab0J0Q1O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Oct 2010 12:27:14 -0400
Received: by ywk9 with SMTP id 9so541054ywk.19
        for <linux-wireless@vger.kernel.org>; Wed, 27 Oct 2010 09:27:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4CC8509C.3040902@candelatech.com>
References: <1288082441-4882-1-git-send-email-lrodriguez@atheros.com>
 <4CC74F35.60009@candelatech.com> <AANLkTimDQXP-L-C9wos_7i272LFwr0aXAJ2GBjJzDDfV@mail.gmail.com>
 <4CC75229.8000109@candelatech.com> <AANLkTi=uNzTuaq9yrG6Z0DbxF9z=JzPe=155rkvLPkD9@mail.gmail.com>
 <4CC8509C.3040902@candelatech.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Wed, 27 Oct 2010 09:26:51 -0700
Message-ID: <AANLkTi=LAtDhi+eXQRV8ZmCa5Ctcp5jWt1Wrp1AUQD8P@mail.gmail.com>
Subject: Re: [RFT 0/3] ath9k: more PCU locking enhancements
To: Ben Greear <greearb@candelatech.com>, Greg KH <greg@kroah.com>
Cc: linux-wireless@vger.kernel.org, kyungwan.nam@atheros.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 27, 2010 at 9:17 AM, Ben Greear <greearb@candelatech.com> wrote:
> On 10/26/2010 03:17 PM, Luis R. Rodriguez wrote:
>>
>> On Tue, Oct 26, 2010 at 3:11 PM, Ben Greear<greearb@candelatech.com>
>>  wrote:
>>>
>>> On 10/26/2010 03:03 PM, Luis R. Rodriguez wrote:
>>>>
>>>> On Tue, Oct 26, 2010 at 2:59 PM, Ben Greear<greearb@candelatech.com>
>>>>  wrote:
>>>>>
>>>>> On 10/26/2010 01:40 AM, Luis R. Rodriguez wrote:
>>>>>>
>>>>>> Here is some more PCU locking enhancements I tested today
>>>>>> while trying to resolve the WARN() that happens when we
>>>>>> try to stop RX DMA and fail. While working on that I figured
>>>>>> I'd work on the TX DMA stuff too, here's a shot at it. I
>>>>>> can no longer get TX / RX DMA rants, please test and let
>>>>>> me know if you do. I only tried some basic testing like
>>>>>> rmmoding while scannign, which typicallly produced some
>>>>>> errors. Now I don't get squat.
>>>>>>
>>>>>> Ben if you can test wit your super proprietary application
>>>>>> that'd be great.
>>>>>>
>>>>>> This also simplifies locking considerably.
>>>>>>
>>>>>> This doesn't break suspend so I'm happy. It also depends
>>>>>> on the last RX DMA fixes I had posted earlier. If you'd
>>>>>> like to get an all-in-one patch of all my patches pending
>>>>>> you can wget this file and git am it:
>>>>>>
>>>>>>
>>>>>>
>>>>>>
>>>>>> http://www.kernel.org/pub/linux/kernel/people/mcgrof/patches/tmp/pending-mcgrof-2010-10-26-v1.patch
>>>>>> sha1sum: 874a3cc1a57f7e26ad191cd7b5045315f94c5823
>>>>>
>>>>> I have done some initial testing on the combined patch on top of
>>>>> today's
>>>>> wireless-testing tree.  I also have the memory-barrier patch applied to
>>>>> ath9k, as that is still not upstream.  I have no idea if it has any
>>>>> affect
>>>>> or not (I'm on x86..seems that wmb() stuff was mostly for other
>>>>> platforms?).
>>>>>
>>>>> So far, it is showing zero problems, certainly no memory poison issues.
>>>>>
>>>>> The wireless-testing tree has some lockdep warning related to a mouse
>>>>> driver
>>>>> that disables lockdep early, so it's possible there are lockdep issues
>>>>> waiting.
>>>>>
>>>>> I will let this test run for a while, but it already looks more stable
>>>>> than before, so:
>>>>>
>>>>> Tested-by:  Ben Greear<greearb@candelatech.com>
>>>>
>>>> Awesome! Thanks for testing. So how about the TX dma rants, do you
>>>> still get those?
>>>
>>> I've seen no rants at all.
>>
>> Fucking awesome!
>>
>>> I'm using my standard 130 STAs
>>
>> I love how now 130 STAs are "standard" for ath9k tests :)
>
> I dropped it down to 30 STAs so that all could associate and
> be stable with my AP.  I set up a tcp stream running as fast as it could
> between
> two virtual STAs.  It ran about 9Mbps bi-directional overnight
> with no obvious problems.

Thanks for the reports, great to hear it is working fine now.

> One way or another, I will probably end up backporting this to 2.6.36,
> so it wouldn't bother me at all to see these changes show up in stable.
>
> We'll keep testing various scenarios in the meantime...

I've submitted my patches for stable. My series of cfg80211 fixes
(also marked for stable) and ath9k PCU fixes have been backported for
2.6.36 here:

http://www.kernel.org/pub/linux/kernel/people/mcgrof/patches/ath9k/2010-10-26/pending-2.6.36-2010-10-26.patch

These can be merged once they hit Linus' tree.

  Luis
