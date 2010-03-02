Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.polymtl.ca ([132.207.4.11]:44893 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751001Ab0CBWqT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Mar 2010 17:46:19 -0500
Message-ID: <4B8D906C.9020102@polymtl.ca>
Date: Tue, 02 Mar 2010 17:25:48 -0500
From: William Bourque <william.bourque@polymtl.ca>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
Subject: Re: LP-PHY Fatal DMA error 0x00000800 on non-ULV Core 2 Duo?!?!!??!
References: <69e28c911002260708g45d3c0f7u6abf13b1babe549f@mail.gmail.com>	<a221c0101002281538p717a3b5v16b14d251cdcc1dc@mail.gmail.com>	<201003010122.51341.mb@bu3sch.de> <201003022257.51878.mb@bu3sch.de>
In-Reply-To: <201003022257.51878.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Michael Buesch wrote:
> On Monday 01 March 2010 01:22:50 Michael Buesch wrote:
>> Well, you are confusing address spaces here.
>>
>> On a PCI based SSB device all host-side MMIO transfers go into
>> the PCI device's address space first. The core-switching moves the window of
>> the SSB address space that is mapped into 0-0xFFF of the PCI address space.
>> So if you write to anything above 0xFFF on the PCI device, the write will
>> not (directly) map to the SSB bus or any device on it.
>> On the PCI device there is more stuff mapped on top of the SSB sliding
>> window. For example the SPROM is mapped right on top of it.
>>
>> So it might be the case that on a PCI-E device the PCI-E-core's registers
>> are permanently mapped into 0x2000 of the PCI address apace. This is to
>> avoid sliding the SSB address space window when accessing the PCI-E core.
>> This can have several reasons: For one speed (unlikely) and for another
>> to avoid concurrency and ugly races when we need to access the PCI-E core
>> while the wireless core is already running and generating interrupts.
>> Note that this is a GUESS, but it would make sense to me.
>> It would be cool if somebody could compare more registers of the PCI-E
>> core using the sliding window and the 0x2000 + reg method to check my theory.
>>
> 
> So what's the status on this? I think the fact that the testing patch showed some
> improvement is a clear indicator that something in the PCI-E core init is wrong.
> It's also not surprising that something is going wrong there. The whole PCI-E core
> code basically is undebugged. I wrote most of it long time ago, but I still
> don't have a device that tests it (and probably won't get one anytime soon).
> So I'm really not surprised that there are bugs. There also are missing parts.
> 
> A bug in the PCI-E core code is able to show such behavior, because all memory
> transfers (MMIO and DMA) from the PCI device to the wireless core are translated
> by the PCI-E core.
> I think the whole PCI-E core code has to be audited (also the specs, probably).
> 

So if I get this right, this code is responsible of handling the b43
devices, as well as several other PCI-E devices, correct?

Because now that you mention this, the wired network card (Marvel Yukon,
with sky2 drivers) on this netbook also have a tons of issue (doesn't
show in lspci on a clean boot, oops the kernel if network cable is
unplugged while in use, fails to load if the module is ever unloaded, ... )
I thought it was unrelated but from your comment, I feel like this could
be linked to the same PCI-E bugs as well.

- William
