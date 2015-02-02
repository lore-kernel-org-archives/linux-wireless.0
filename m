Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:53556 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752924AbbBBXFQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Feb 2015 18:05:16 -0500
Message-ID: <54D0028E.6000503@codeaurora.org> (sfid-20150203_000523_707672_5C987273)
Date: Mon, 02 Feb 2015 15:04:46 -0800
From: Peter Oh <poh@codeaurora.org>
MIME-Version: 1.0
To: Adrian Chadd <adrian@freebsd.org>,
	Sujith Manoharan <sujith@msujith.org>
CC: Bob Copeland <me@bobcopeland.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
	Peter Oh <poh@qca.qualcomm.com>
Subject: Re: [PATCH] ath10k: Replace ioread with wmb for data sync
References: <1422311118-11320-1-git-send-email-poh@qca.qualcomm.com>	<20150127213349.GA24933@localhost>	<54C824DC.5080804@qca.qualcomm.com>	<20150128043005.GB24933@localhost>	<54C875FD.3070101@qca.qualcomm.com>	<1422430643.1973.1.camel@sipsolutions.net>	<54CC0B71.9050301@codeaurora.org>	<21708.11481.380046.994311@gargle.gargle.HOWL>	<54CC3640.2090209@codeaurora.org>	<21708.14493.458370.65799@gargle.gargle.HOWL> <CAJ-Vmok9X7Zu67A3xnTKkBbLYPhrxqxRkv7EzKpPAnTOw6baVQ@mail.gmail.com>
In-Reply-To: <CAJ-Vmok9X7Zu67A3xnTKkBbLYPhrxqxRkv7EzKpPAnTOw6baVQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On 02/02/2015 02:26 PM, Adrian Chadd wrote:
> On 30 January 2015 at 18:06, Sujith Manoharan <sujith@msujith.org> wrote:
>> Peter Oh wrote:
>>> Please refer the email thread that I mentioned about other architectures.
>>> (dsb is for ARM and other platforms have the equivalent instruction such
>>> as sfence, sync, mf, and dcs).
>> Ok.
>>
>>> Also the patch is updated with 2nd patch set replacing wmb to mb.
>> Would be good to test this on a MIPS platform...
>>
> The Atheros mips74k stuff I have here does /not/ flush all the writes
> out to the device and guarantee the device has seen everything with a
> memory barrier. Just saying. Various drivers ended up needing
> ioread()s in my experiments; mips sync operations weren't enough.
>
> So I'd suggest abstracting it out like the linux dri i915 code has -
> they define a "posting read" macro which they use whenever they need
> to ensure it's definitely made it all the way out to the hardware and
> through internal FIFOs so internal hardware has seen the state change.
> Then you can redefine that to your hearts content based on platform.
Thank you Adrian to head up the concern and suggestion.
The other people also concerned about other architectures like mips, so 
I was going to analysis it.
But since you've already experienced the defects, let me hold the change 
back until I find better for all.
>
>
> -adrian
Regards,
Peter
