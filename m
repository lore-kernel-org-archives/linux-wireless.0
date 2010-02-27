Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:33650 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030474Ab0B0SxT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Feb 2010 13:53:19 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Make b43 driver fall back gracefully to PIO mode after fatal DMA  errors
Date: Sat, 27 Feb 2010 19:51:59 +0100
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	=?iso-8859-1?q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"David S. Miller" <davem@davemloft.net>,
	wireless <linux-wireless@vger.kernel.org>,
	Greg Kroah-Hartman <gregkh@suse.de>
References: <alpine.LFD.2.00.1002261034140.4513@localhost.localdomain> <201002271559.20531.mb@bu3sch.de> <alpine.LFD.2.00.1002271016330.4513@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1002271016330.4513@localhost.localdomain>
MIME-Version: 1.0
Message-Id: <201002271952.00144.mb@bu3sch.de>
Content-Type: text/plain;
  charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 27 February 2010 19:31:11 Linus Torvalds wrote:
> 
> On Sat, 27 Feb 2010, Michael Buesch wrote:
> > 
> > However, did you add the udelay to b43_write()? Please try to add it
> > further down in the callchain into the lowlevel SSB read and write functions.
> > drivers/ssb/pci.c
> 
> Well, I don't know what that would help from a timing standpoint, since 
> the delay gets done either way,

Well, but not for SSB-only accesses that access registers on the bus or other
devices on the bus.

> but looking at it, I do note that the  
> locking for the writes is very very wrong.

Yeah that is known very well. But we don't care, as it is implicitely protected
by b43's mutex.

This is nontrivial to fix, so for now I don't care. We could simply
remove the lowlevel SSB lock, if it bothers you much.

> That said, I assume that 'mapped_device' almost never actually changes in 
> practice, so the race presumably doesn't really matter.

Yes, that's the case.
There are no races in practice. Even if you remove the lock completely.
I was going to fix this at some point, but it's really nontrivial.

> I don't know how  
> these "devices" even work - is there a separate "device" for different SSB 
> functions (ie power management vs DMA vs wireless radio), or is there 
> multiple devices only if you actually have multiple radio's?

Depends on the actual device.
The SSB is a bus like PCI. You can attach basically anything you want to it.

> So for all I know, it's possible that in my case there is always just one 
> device, and the race really fundamentally cannot ever happen.

That's basically the case for a PCI device, yes.

> I can write a patch and test whether it matters, but I'd like to know if 
> my chip even _has_ multiple cores behind the ssb bridge. If people tell me 
> that there is only one core on that chip, and that the race can never 
> happen, then I won't bother.

Nah, you really don't want to touch that lowlevel code. It is not broken as-is.
Simply remove the lock, if you really care that much.
I tried to fix this properly a few weeks ago, but I didn't really see a sane way
to do it so I finally gave up, because it wouldn't fix a real-life problem anyway.
The problem is that this code may basically run in any context. And (if that were not
enough), it must work on all host-busses that SSB supports. That being plain SSB, PCI,
PCMCIA and SDIO. Where SDIO is special in that it requires sleeping.

I assure you that this is not part of the DMA problem. 100% guaranteed. ;)

-- 
Greetings, Michael.
