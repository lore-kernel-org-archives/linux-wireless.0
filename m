Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.180]:44448 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754170AbXLJOSq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2007 09:18:46 -0500
Received: by wa-out-1112.google.com with SMTP id v27so3375359wah
        for <linux-wireless@vger.kernel.org>; Mon, 10 Dec 2007 06:18:46 -0800 (PST)
Message-ID: <1ba2fa240712100618g35a8e13ve143f8687f1b531a@mail.gmail.com> (sfid-20071210_141919_710401_8896360E)
Date: Mon, 10 Dec 2007 16:18:46 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: coding style lesson: iwlwifi vs. endianness
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Dan Williams" <dcbw@redhat.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Zhu Yi" <yi.zhu@intel.com>,
	"Reinette Chatre" <reinette.chatre@intel.com>
In-Reply-To: <1197286949.6035.49.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1196189059.6058.95.camel@johannes.berg>
	 <1ba2fa240711281020n6052980cl610f6c790788d2da@mail.gmail.com>
	 <1196286192.4967.29.camel@localhost.localdomain>
	 <20071129005810.GA6161@tuxdriver.com>
	 <1ba2fa240711291502k65cefd5au60f2c22d6f436c82@mail.gmail.com>
	 <1197286949.6035.49.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> It's interesting that you say this, single bits don't need any
> endianness conversion at all if you simply define the container types as
> u8. Of course, that isn't always how the hardware is documented and not
> always the right thing to do, but it is possible.
>

You are right it will be much more damange for us not to be not
aligned with the HW/Firmware  documentation. It is still pretty much
alive. It's hard to talk to HW people if you don't use the same
language.  Sometimes the bit can move across the u8 boundaries and it
becomes nasty.

> However, with much of the code it it would actually make sense:

We may consider this as it get more stable.

> I never said you should keep native layout structures. I merely said
> that it leads to better code if the data is converted to CPU endianness
> at the system boundary. While the actual system boundary is obviously
> the PCI(-E) bus, the logical system boundary may well be at the point
> where you load a certain value from the DMA memory into the CPU to
> operate with it (whether it's then pushed back out to memory on the
> stack is uninteresting).

I'm not buying this logical boundary definition if you don't do clean
cut you still have to be endian aware across the whole code so what's
a difference.

Yes, doing that can lead to larger C files, but
> the compile result won't suffer; given a sufficiently smart compiler
> it'll even be *completely* equivalent on little-endian platforms
> (because nothing is declared volatile so the extra variables containing
> the CPU byte order fields can be completely removed by the compiler by
> going back to the memory the data came from if not enough registers are
> available).

 b = le_to_cpu(a)
 b != FLAG
 a = cpu_to_le(b)
 is probably longer then
 a |= FL:AG_LE;
 n matter what.

I didn't follow latest compiler optimizations but that way I don't
relay on them. I will try to look at the assembly what's difference..

> > Also number swap operation is much lower then the other approach.
>
> As I will show, this is not true. At least not if you go away from
> "shadow" structures.
>

I appreciate your effort but for sake of your time  don't bother to do
any dramatic changes we are adding new HW and it this course will
clean  up the code, naturaly  mostly  in host commands

> > We rather think of all constants for host commands as liitle endian.
> > As we stick consistently to this paradigma it becomes natural.
> > I'm not sure if this was a good decision for a long run as we are
> > adding more hardware and we are need more abstraction, at that point
> > it looked correct.
>
> Maybe it's "natural" to Intel people to think in little endian, but I'd
> guess most other people don't want to be bothered thinking about
> endianness in every single line of code

I still argue that you will have more swap operation in the code
meaning that you also will have to be aware of endianity at least with
your definition of logical boundaries.

> Here's my argument for why this is inefficient not only in terms of
> comprehensibility but also in terms of runtime penalty.
>
> Let's consider STA flags. I don't know whether they're written or read
> more but it hardly matters.
>
> The field is defined as follows:
> | bits | 0-7 | 8       | 9-16 | 19-20 | 21  | 22          | 23-25        | ...
> | means|  -  | pwrsave |  -   | aggsz | fat | mimodisable | mpdu density | -
>
> In order to set all information in this field, you need code like this:
>
> --- >% ---
> __le32 staflags = 0;
>
> if (sta power save)
>         staflags |= STA_FLG_PWR_SAVE_MSK;
>
> staflags |= cpu_to_le32(ampdu_factor << STA_FLG_MAX_AGG_SIZE_POS);
> staflags |= cpu_to_le32(ampdu_density << STA_FLG_AGG_MPDU_DENSITY_POS);
>
> [...]
>
> memstruct->sta_flags = staflags;
> --- %< ---
>
> (similar code is present in iwl4965_set_ht_add_station)
>

This I will fix. This just another of exemption of our approach.

> [1] And you could even use the little-endian load macros (like
> le32_to_cpup, beware of alignment though) that powerpc for example
> optimises into a single "lwbrx" statement, sparc64 does a similar thing.
> For little endian processors it doesn't make a difference at all.

Hmm I wasn't aware. I will look at it.

Thanks
Tomas
