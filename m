Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f50.google.com ([209.85.219.50]:33575 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834Ab3CWR0w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Mar 2013 13:26:52 -0400
Received: by mail-oa0-f50.google.com with SMTP id n1so2413923oag.37
        for <linux-wireless@vger.kernel.org>; Sat, 23 Mar 2013 10:26:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130323155355.0a1752f5@laptop.homenet>
References: <514a07c7.ZQz6MhmMaq58WJlA%Larry.Finger@lwfinger.net>
	<CACna6rz75ecyy5CdaJfi=dRjrTh_Rg793Ub+-0QdVnCZNyV+Lg@mail.gmail.com>
	<20130323113517.01906b0b@milhouse>
	<20130323155355.0a1752f5@laptop.homenet>
Date: Sat, 23 Mar 2013 18:26:51 +0100
Message-ID: <CACna6rx+sCrg1fB-6XfYcSWczu6Mtuvz75FOHbbx3YdPe+U5sw@mail.gmail.com> (sfid-20130323_182657_203770_012DAC08)
Subject: Re: [PATCH] b43: A fix for DMA transmission sequence errors
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Chris Vine <chris@cvine.freeserve.co.uk>
Cc: =?UTF-8?Q?Michael_B=C3=BCsch?= <m@bues.ch>, isedev@gmail.com,
	linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
	Larry Finger <Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2013/3/23 Chris Vine <chris@cvine.freeserve.co.uk>:
> On Sat, 23 Mar 2013 11:35:17 +0100
> Michael Büsch <m@bues.ch> wrote:
>> On Sat, 23 Mar 2013 00:27:30 +0100
>> Rafał Miłecki <zajec5@gmail.com> wrote:
>>
>> > Today I've plugged my 14e4:4315 and (unfortunately?) it's working
>> > pretty well. I hoped to reproduce some problems but failed to do
>> > so. I was transmitting for an hour with average speed 11MiB/s and
>> > didn't notice any DMA issues.
>> >
>> > I was using iperf with interval of 60 seconds and only 3 results
>> > showed some problems (8.5MiB/s, 2.5MiB/s, 4.5MiB/s). No
>> > disconnections however and no DMA errors. I just got "Group
>> > rekeying completed..." in wpa_supplicant.
>> >
>> > So as I can't reproduce this, I can't find any other fix for this
>> > issue, and there's no reason to stop this workaround. I'll just
>> > apply it and test over weekend to check for any regressions, but
>> > they are highly unlikely.
>>
>> I don't really believe in this being a firmware bug.
>>
>> Some b43 DMA engines (all?) have some alignment and
>> page-boundary-crossing constraints. I would rather guess that on some
>> kernels with some options turned on, alignment and/or boundary
>> constraints are violated every now and then. (and thus the packet
>> never reaches the firmware).
>>
>> I don't remember the details, though. Too long since I worked on that.
>> But a few sanity checks could probably be added to the code to check
>> this hypothesis.
>>
>> Does the failing kernel/machine have any special things w.r.t. memory?
>> Like iommu, hugepages, whetever...
>
> For what it is worth, this happens to me on both home compiled and
> distributor kernels (ubuntu and slackware): in fact, any 32-bit kernel
> that I have tried it on.
>
> And it does not happen with the wl driver on the same kernels.  So if
> this is right, the wl driver must be doing something that the b43 driver
> does not with respect to alignment: and you might well be right about
> that.

Could you try changing
B43_DMA32_RINGMEMSIZE
from 4096 to 8192 in dma.h?

-- 
Rafał
