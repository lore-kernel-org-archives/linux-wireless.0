Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f11.google.com ([209.85.217.11]:39359 "EHLO
	mail-gx0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752497AbYKSMW6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Nov 2008 07:22:58 -0500
Received: by gxk4 with SMTP id 4so2366075gxk.13
        for <linux-wireless@vger.kernel.org>; Wed, 19 Nov 2008 04:22:56 -0800 (PST)
Message-ID: <1ba2fa240811190422o4eebb26ai17ea12825ae8e708@mail.gmail.com> (sfid-20081119_132305_500028_0AC232AC)
Date: Wed, 19 Nov 2008 14:22:55 +0200
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
In-Reply-To: <1227094594.26243.6.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1226969241.4014.24.camel@johannes.berg>
	 <1227001390.4014.43.camel@johannes.berg>
	 <1ba2fa240811180613g48c94199s67e4334e89282e76@mail.gmail.com>
	 <1227021904.4014.58.camel@johannes.berg>
	 <1ba2fa240811190115i6bad0c89wb1d9c8ee281be2f8@mail.gmail.com>
	 <1227094594.26243.6.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 19, 2008 at 1:36 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2008-11-19 at 11:15 +0200, Tomas Winkler wrote:
>
>> >> You are off here. The constrain is just that address will fit in 32
>> >> bit register. I don't know why this constrain, but there is always a
>> >> reason.
>> >
>> > There's also the PCI-E constraint of having to split up DMA at 4k
>> > boundaries, which is what I was talking about above.
>>
>> Have to check this but I'm not sure if this is anyhow related.
>
> It's not. I misunderstood how RX DMA works, but given that you actually
> have to allocate the buffers that large the HW has to support splitting.
>
>> Not just that, it was never confirmed this is the issue it was the
>> first place we started to look.
>> This code is there from time zero of the driver something like kernel
>> 2.6.18 and the problem popped only in kernel 2.6.27 so what else has
>> changed.
>
> Yeah, it's weird, and it doesn't even seem to solve it for everyone. So
> there must be another thing too.

It seems that your wrong command queue problem is no the same root
cause  we see on x86 platforms they have just same phenomena, because
there is 0xff data on the RX buffer.

>
>
>> Yes I have CONFIG_SWIOTLB=y in my config spec for X86_64, nevertheless
>> you've mentioned that the allocation problem is due to headroom
>> allocation in skb?!
>
> Well, the skb "head" is _all_ of the skb data that is not part of an
> extra buffer. So skb->data is the "head" while the skb fraglist is
> referred to as the data. That can be a bit confusing. Anyway skb->data
> is just allocated with kmalloc and on my machine that has 128 byte
> alignment. The IOMMU maps pages, so doesn't change the alignment. If you
> are using swiotlb (just having it in the config isn't enough, check the
> kernel messages) then much DMA will be done with bounce buffer.
>

Thanks will look at it.

>> > Incidentally, where does the 36 bit limit come from? The RX has a 40 bit
>> > limit if you see that it uses 32 bit pointer that's shifted by 8 bits.
>>
>> I'm checking with the HW guys
>
> Seems that isn't necessary, there are some things like the rbb stats
> that are only shifted down by 4 bits, so they need a 36 bit mask. Bit
> unfortunate that this single allocations forces all into the mask, but I
> don't right now see how to just get that single one into 36 and the rest
> into 40.

I've checked and the 256 alignment is really just to support larger
memory range in further NICs
The penalty for this on window is just 256 not so big because there is
no memory ownership handling
Thanks
Tomas
