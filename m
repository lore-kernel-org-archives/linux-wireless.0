Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:43059 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752486Ab1CRPRz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Mar 2011 11:17:55 -0400
Received: by qyg14 with SMTP id 14so3472258qyg.19
        for <linux-wireless@vger.kernel.org>; Fri, 18 Mar 2011 08:17:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1300460342.13499.60.camel@dev.znau.edu.ua>
References: <1300449773-11255-1-git-send-email-zajec5@gmail.com>
	<1300453433.13499.18.camel@dev.znau.edu.ua>
	<AANLkTimG8G_BsqoAUYWfRETfU1ndu_i87WjkXx+v_sNE@mail.gmail.com>
	<1300460342.13499.60.camel@dev.znau.edu.ua>
Date: Fri, 18 Mar 2011 16:17:35 +0100
Message-ID: <AANLkTi=2qBhKfJZ8a2GEgx_4aJL_85FKODUX31BddmN1@mail.gmail.com>
Subject: Re: [RFC][PATCH] ssb: separate common scanning functions
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: George Kashperko <george@znau.edu.ua>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	=?UTF-8?Q?Michael_B=C3=BCsch?= <mb@bu3sch.de>,
	b43-dev@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/3/18 George Kashperko <george@znau.edu.ua>:
>> 2011/3/18 George Kashperko <george@znau.edu.ua>:
>> > Current ssb code ideology isn't really good place to start with support
>> > for ai backplanes. Its really great to see you willing to get ai
>> > supported in mainline but I'm sure this should be done apart from the
>> > ssb code and not even with one as the design decisions origin. Several
>> > concepts the ssb is based on are not designed to support anything else
>> > than ocp/sb and will require workarounds to suport ai.
>> > Thanks to Michael I had a time to think over the possibly code
>> > abstraction for shared sb and ai support. And while I'm still sure the
>> > patchwork for ai over ssb support is of good use as some intermediate
>> > decision to support ai-based hardware in sertain distributions but now I
>> > support Michael in that such (hopefully) a temporary buildups should not
>> > be in mainline.
>>
>> Please, give some concrete arguments, which part of design does not match AI.
> SSB design is core-centric, where all the bus activities are made in
> regard to the cores. This mostly is correct as most of the time
> bus/drivers code work with cores.

So finally, is there anything wrong about that?


> At the same time ssb model completely
> ignores the fact that each sb backplane core is a composite device
> consisting of the core itself and the core agent. In sb the agent
> registers space is referenced by manuals available and the Broadcom SDK
> code as one starting at 0x0F00 offset from the main core registers space
> beginning (actually I beleive this is true for sb revisions prior to 2.3
> and this range is actually 0x0C00-0x0FFF at least for sb rev. 2.3 and
> above). This is neglible for embedded backplanes as the whole backplane
> physical address space is accessed simultaneously, completely ignored by
> the ssb code for pci-hosted sb backplanes as only sliding bar0 window #1
> is utilised for backplane access, workarounded with
> select_core_and_segment in pcmcia host code.
> With axi introduced we have agents registers' spaces in completely
> different physical backplane pages, apart from the main core registers
> space. This is still have no impact for embeddables, will require bar0
> window #2 adjustment with each core switch (and here you will be
> required to have backplane specific processing in pci host code) and I
> don't really know how this could be workarounded for other hosts without
> them to know which exactly backplane they run and how should it be
> treaten.
> The clean solution I see here is to have host code apart from
> backplane-specific processing. The way to accomplish this is obvious as
> actual host device responsibility is not to switch cores but rather
> provide mappings into physical address space of the backplane regardless
> of the target request being made to core, sprom/otp, agent or whatever.
> This makes much cleaner model than that provided by ssb.

Yes, I noticed this already. Sill, after analyzing pci.c it seems we
will duplicate ssb_pci_xtal, ssb_pci_switch_coreidx and all SPROM
functions. We will just have different ssb_pci_switch_core and we will
drop old SPROMs layouts support.

My idea: separate functions we can share (ssb_pci_xtal,
ssb_pci_switch_coreidx, most of the SPROM functions) and create
separated PCI host drivers.


>> My patch has shown we need to duplicate 40% of SSB's scanning code.
>> What for example about pci.c? Which functions from that file won't be
>> duplicated in totally separated?
>>
> Going further in extending ssb to support ai will either require the
> host to be confident of the backplane type and layout (see
> drivers/staging/brcm80211/utils for the good example of messup it will
> lead to) or will reguire the backplane-specific code to break into the
> host code (brcm80211/utils again).

I don't want to extend ssb, I said that with my patch message. I
wanted separated drivers sharing some functions, please take a look at
my comment included in patch. I think we could also create *separated*
host drivers sharing most of the code.


> Current ssb code is two-layer - in two words its about cores on host.
> This makes sertain hosts to know everyting about cores, but at the same
> time it let the cores to be abstract from the hosts. Building ai support
> over this model will make hosts to know even more about cores, but if
> done right it will still keep the cores autonomous.
> At the same time host-backplane-core model provide better code
> separation, little-to-nothing code duplication and let host, backplane
> and core code writers avoid workarounds required for current ssb model.

-- 
Rafał
