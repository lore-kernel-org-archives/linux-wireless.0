Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.169]:16049 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080AbYKSJPQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Nov 2008 04:15:16 -0500
Received: by wf-out-1314.google.com with SMTP id 27so3604594wfd.4
        for <linux-wireless@vger.kernel.org>; Wed, 19 Nov 2008 01:15:16 -0800 (PST)
Message-ID: <1ba2fa240811190115i6bad0c89wb1d9c8ee281be2f8@mail.gmail.com> (sfid-20081119_101532_080582_98F2737D)
Date: Wed, 19 Nov 2008 11:15:14 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH/RFT] iwlagn: fix RX skb alignment
Cc: "John Linville" <linville@tuxdriver.com>,
	"reinette chatre" <reinette.chatre@intel.com>,
	"Marcel Holtmann" <marcel@holtmann.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	"Matt Mackall" <mpm@selenic.com>,
	"Christophe Dumez" <dchris@gmail.com>, "Zhu Yi" <yi.zhu@intel.com>,
	"=?UTF-8?Q?Jan_V=C4=8Del=C3=A1k?=" <vcelak.jan@seznam.cz>,
	"Thomas Witt" <witt_th@gmx.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Andres Freund" <andres@anarazel.de>
In-Reply-To: <1227021904.4014.58.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1226969241.4014.24.camel@johannes.berg>
	 <1227001390.4014.43.camel@johannes.berg>
	 <1ba2fa240811180613g48c94199s67e4334e89282e76@mail.gmail.com>
	 <1227021904.4014.58.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 18, 2008 at 5:25 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2008-11-18 at 16:13 +0200, Tomas Winkler wrote:
>
>> >> So I dug deeper into the DMA problems I had with iwlagn and a kind soul
>> >> helped me in that he said something about pci-e alignment and mentioned
>> >> the iwl_rx_allocate function to check for crossing 4KB boundaries. Since
>> >> there's 8KB A-MPDU support, crossing 4k boundaries didn't seem like
>> >> something the device would fail with
>> >
>> > Come to think of it, maybe it does. One common failure case seems to be
>> > "this goes wrong with an 11n AP, but not on a regular one", so one
>> > explanation for that would be that the hardware designers expect the
>> > driver to split up the DMA into multiple DMA descriptors at 4K
>> > boundaries, but iwlagn uses only one and undefined behaviour results.
>> > That's something you'll need to ask the HW designers though or look up
>> > in the datasheet.
>>
>> You are off here. The constrain is just that address will fit in 32
>> bit register. I don't know why this constrain, but there is always a
>> reason.
>
> There's also the PCI-E constraint of having to split up DMA at 4k
> boundaries, which is what I was talking about above.

Have to check this but I'm not sure if this is anyhow related.

 After reading the
> code I'm fully aware of the 32-bit pointer (I wouldn't call it a
> register, it's also just DMA memory)

Just general wording.

>> We've assumed that allocations are on the page or cache boundaries I'm
>> not who already assured me that this is the case.
>
> He lied.

Not just that, it was never confirmed this is the issue it was the
first place we started to look.
This code is there from time zero of the driver something like kernel
2.6.18 and the problem popped only in kernel 2.6.27 so what else has
changed.

>
>> I  actually  haven't
>> encountered this problem on X86_64 I even have the correct check.
>
> Are you using swiotlb? That's the only case I can think of where the
> alignment would always be satisfied.
>
Yes I have CONFIG_SWIOTLB=y in my config spec for X86_64, nevertheless
you've mentioned that the allocation problem is due to headroom
allocation in skb?!


>> What
>> I know there is difference in memory mapping in PPC64 as it has IOMMU.
>
> The powerpc IOMMU design isn't very peculiar. It maps 4k pages of
> machine memory into device space. If the memory pointer you're mapping
> isn't aligned, then the device memory pointer will not be either. I
> suspect the same happens on any iommu design, other than machines
> without an iommu of course, using swiotlb.
>
> And since the skb data is simply assigned with kmalloc, it surely won't
> be aligned on a 256 byte boundary. 256 is _huge_.
>
>>  Hope this address the wrong command queue number bug but I'm not
>> sure.
>
> It certainly does for me.
>
>> There are other places with alignment requirement in the driver we
>> probably need to address as well.
>
> Haven't found any, but yeah, anything >16 byte alignment isn't
> guaranteed (I think, might be 8, might be 32, not exactly sure)
>
>
> Incidentally, where does the 36 bit limit come from? The RX has a 40 bit
> limit if you see that it uses 32 bit pointer that's shifted by 8 bits.

I'm checking with the HW guys
Tomas
