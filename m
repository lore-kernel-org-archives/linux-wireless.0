Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from foo.birdnet.se ([213.88.146.6]:59945 "HELO foo.birdnet.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754305AbZFRCQ5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Jun 2009 22:16:57 -0400
Message-ID: <20090618021017.19879.qmail@stuge.se>
Date: Thu, 18 Jun 2009 04:10:17 +0200
From: Peter Stuge <peter@stuge.se>
To: "Fabio A. Correa" <facorread@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	wireless <linux-wireless@vger.kernel.org>,
	bcm43xx-dev@lists.berlios.de
Subject: Re: 4311 not detected at all
References: <ec2083b20906120654j370e5bdo724a7c3b6d505a6c@mail.gmail.com> <4A326771.6030301@lwfinger.net> <ec2083b20906120759x4a8c247eh61d1f6bdb6f194f6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <ec2083b20906120759x4a8c247eh61d1f6bdb6f194f6@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fabio A. Correa wrote:
> > The bottom line is that a BIOS error is likely the problem with
> > BAR allocation on your machine. Have you checked to see if an
> > updated one is available?
> 
> Hey, I found an updated BIOS available in the HP site, obviously
> requiring Windows. I had deleted those partitions, so I will get a
> Windows hard disk/CD and try to flash it.

You may be able to use flashrom as developed by the coreboot project
to flash your BIOS. Maybe. If not, come on IRC or the mailing list
and we can try to help you get it to work on your laptop.

http://coreboot.org/Flashrom
http://coreboot.org/IRC
http://coreboot.org/Mailinglist


> By the way, what is BAR?

The boot firmware (usually BIOS) assigns PCI devices an address range
through which software can exchange data with the device. Each device
specifies the size for it's address ranges, the firmware calculates
how all ranges fit together, and then writes the start, or base,
address to the respective BAR in each device.

The addresses are the same as RAM addresses, which is why 32-bit
systems can not use full 4GB of RAM. The PCI device address ranges
will occupy the last part of memory space.

Better BAR allocation algorithms could allow more usable RAM, but it
also depends on chipset limitations.


//Peter
