Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.179]:27388 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753528AbYFLSDr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jun 2008 14:03:47 -0400
Received: by py-out-1112.google.com with SMTP id p76so1714610pyb.10
        for <linux-wireless@vger.kernel.org>; Thu, 12 Jun 2008 11:03:46 -0700 (PDT)
Message-ID: <1ba2fa240806121103m60a8ffa4ie11850fedc69d13c@mail.gmail.com> (sfid-20080612_200349_502341_0E44E138)
Date: Thu, 12 Jun 2008 21:03:46 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: Problem: Out of memory after 2days with 2GB RAM
Cc: "Rik van Riel" <riel@redhat.com>,
	"Zdenek Kabelac" <zdenek.kabelac@gmail.com>,
	"Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
	yi.zhu@intel.com, reinette.chatre@intel.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <1213292812.3730.21.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <c4e36d110806120307n20cce692s9c136f11596f5ab0@mail.gmail.com>
	 <20080612093833.0fb9cdd6@bree.surriel.com>
	 <1213278884.3936.15.camel@johannes.berg>
	 <1ba2fa240806120843s268b2ff4mb45a11adf11afc7f@mail.gmail.com>
	 <1ba2fa240806120935r54a080eci7fa6fafc718eed17@mail.gmail.com>
	 <1213290335.3730.4.camel@johannes.berg>
	 <1ba2fa240806121039o376b0a8sdfaacf3a1f4a9e57@mail.gmail.com>
	 <1213292812.3730.21.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 12, 2008 at 8:46 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>
>> > Well, I disagree, and I'll push my patch as soon as somebody confirms
>> > that it doesn't break anything.
>>
>> Remember you are not a maintainer of this driver and second we are
>> open to all suggestions you don't have to use this kind of
>> statements...
>
> Yeah, you're right, I can't really do that. But I can submit the patch
> to akpm, and I'm sure he'll take it after you provide your counter
> argument about hope never dying again ;)

Here you go again

> Frankly, I don't see why you're so opposed to this patch even if it
> doesn't solve anything it probably leads to better code generation and
> using a lot less memory.

I'm not against it. You;v decided that I'm fighting you because I gave
another solution.
Frankly we probably don't need this allocation at all. maybe one skb
is just enough
even with my never dying hope all fragments are in skb fragment list.
This still probably won't save pci memory allocation problem

Tomas


> Also, I know you cannot actually need those descriptors since mac80211
> will never ever pass such frames, and _that_ is an area I do have at
> least some influence over, so I'll surely notice when that changes.
>
>> >> > There was already discussion on LKML about memory allocation problems
>> >> > on X86_64, which might explain this regression. This didn't happen
>> >> > before.
>> >>
>> >> This is  the thread title if you are interested.
>> >> 'x86/kernel/pci_dma.c: gfp |= __GFP_NORETRY'
>> >
>> > Like I said, it doesn't matter, there's no need to _waste_
>> > 18*256*sizeof(void *) bytes memory.
>>
>> It does matter this is not pci allocation we are saving in your patch.
>
> Well, thing is, my patch saves 18 KiB memory on 32-bit and 36 on 64-bit,
> so I think we should merge it regardless. Yes, the pci allocation is
> icky, and yes, it would be good to just do it once instead of over and
> over again, but even if you change it to do _all_ those allocations just
> once we should not be wasting those 18/36 KiB memory for nothing.
>
> johannes
>
