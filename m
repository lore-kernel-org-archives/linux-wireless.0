Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:48900 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758531AbYKVPyh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Nov 2008 10:54:37 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: BCM4312 Fails when xdm is started
Date: Sat, 22 Nov 2008 16:54:09 +0100
Cc: Yuval Hager <yuval@avramzon.net>, bcm43xx-dev@lists.berlios.de,
	LKML <linux-kernel@vger.kernel.org>,
	wireless <linux-wireless@vger.kernel.org>,
	Peter Stuge <peter@stuge.se>
References: <200811151801.02369.yuval@avramzon.net> <200811221613.00303.mb@bu3sch.de> <492825F8.6020606@lwfinger.net>
In-Reply-To: <492825F8.6020606@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200811221654.09399.mb@bu3sch.de> (sfid-20081122_165445_767839_4FF26B4A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 22 November 2008 16:32:08 Larry Finger wrote:
> Michael Buesch wrote:
> 
> > Somebody disabled MMIO and busmastering.
> > And somebody cleared the CACHE_LINE_SIZE register.
> 
> Are these all the read/write bits in the configuration area? Should I conclude
> that someone zeroed this area?

Yeah well. I'm not sure. It _looks_ like someone completely cut the physical
power line to the card and it reset its complete PCI config.
So well, X does poke with the PCI devices. But as you said it also happens if
X doesn't run, I'd rule that out.
But I would not rule out a fucked BIOS, yet.
Does the BIOS have any powersave options and/or spread-spectrum options for
the PCI-bus? Can you try to turn them all off?
I have a machine that has PCI-slot autodetect and turns of the PCI clock, if
it doesn't detect a card on that slot. Also turn that off, if you have it, too.

> In case the kernel memory diagnostics don't help, is there any way to trap
> writes to the configuration registers?

Well, if we have random memory corruption, that can hit memory and MMIO.
It doesn't hurt to turn on all debugging options. Often you get some hint
by doing so.

-- 
Greetings Michael.
