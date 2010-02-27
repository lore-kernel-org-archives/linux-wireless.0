Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34294 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030474Ab0B0ScE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Feb 2010 13:32:04 -0500
Date: Sat, 27 Feb 2010 10:31:11 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Michael Buesch <mb@bu3sch.de>
cc: Larry Finger <Larry.Finger@lwfinger.net>,
	=?ISO-8859-15?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"David S. Miller" <davem@davemloft.net>,
	wireless <linux-wireless@vger.kernel.org>,
	Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: Make b43 driver fall back gracefully to PIO mode after fatal
 DMA  errors
In-Reply-To: <201002271559.20531.mb@bu3sch.de>
Message-ID: <alpine.LFD.2.00.1002271016330.4513@localhost.localdomain>
References: <alpine.LFD.2.00.1002261034140.4513@localhost.localdomain> <alpine.LFD.2.00.1002261337460.4513@localhost.localdomain> <alpine.LFD.2.00.1002261345300.4513@localhost.localdomain> <201002271559.20531.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On Sat, 27 Feb 2010, Michael Buesch wrote:
> 
> However, did you add the udelay to b43_write()? Please try to add it
> further down in the callchain into the lowlevel SSB read and write functions.
> drivers/ssb/pci.c

Well, I don't know what that would help from a timing standpoint, since 
the delay gets done either way, but looking at it, I do note that the 
locking for the writes is very very wrong.

For example, look at

	static u32 ssb_pci_read32(struct ssb_device *dev, u16 offset)
	{
	        struct ssb_bus *bus = dev->bus;

	        if (unlikely(ssb_pci_assert_buspower(bus)))
	                return 0xFFFFFFFF;
	        if (unlikely(bus->mapped_device != dev)) {
**** race 1 ****
	                if (unlikely(ssb_pci_switch_core(bus, dev)))
	                        return 0xFFFFFFFF;
	        }
**** race 2 ****
	        return ioread32(bus->mmio + offset);
	}

and notice how it's doing that 'mapped_device' read with no locks held. 
The actual ssb_pci_switch_core() function will take a lock, but it's too 
late by then: if you have these things happening in an interrupt, you 
might have another access happening either before or after the 
mapped_device has been read or written. So the mmio access could easily go 
to the wrong core.

That said, I assume that 'mapped_device' almost never actually changes in 
practice, so the race presumably doesn't really matter. I don't know how 
these "devices" even work - is there a separate "device" for different SSB 
functions (ie power management vs DMA vs wireless radio), or is there 
multiple devices only if you actually have multiple radio's?

So for all I know, it's possible that in my case there is always just one 
device, and the race really fundamentally cannot ever happen. Or maybe 
there are multiple ones, but in practice you never have concurrent 
accesses (perhaps due to locking at a higher level) so again the locking 
bug is hidden.

Anyway, quite frankly, from a design standpoint it looks like any user of 
ssb_pci_switch_core() is fundamentally buggered. The lock should be taken 
by the caller, ie the locking _should_ have been around the whole 
mapped_device test _and_ the actual ioread32() too, something like

	u32 retval = 0xffffffff;

	spin_lock_irqsave(&dev->core_lock, flags);
	if (bus->mapped_device == dev || !ssb_pci_switch_core(bus, dev))
		retval = ioread32(bus->mmio + offset);
	spin_lock_irqrestore(&dev->core_lock, flags);

	return retval;

and that assert_buspower thing should probably be done inside the core 
switching (set "mapped_device" to NULL when powering it down, and either 
refuse to switch cores or power it up dynamically).

I can write a patch and test whether it matters, but I'd like to know if 
my chip even _has_ multiple cores behind the ssb bridge. If people tell me 
that there is only one core on that chip, and that the race can never 
happen, then I won't bother.

			Linus
