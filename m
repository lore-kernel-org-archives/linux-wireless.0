Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.13]:62949 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892AbaH2HMm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Aug 2014 03:12:42 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	"linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Booting bcm47xx (bcma & stuff), sharing code with bcm53xx
Date: Fri, 29 Aug 2014 09:12:37 +0200
Message-ID: <2928362.8a0siS8rnK@wuerfel> (sfid-20140829_091245_613740_1C93BBA1)
In-Reply-To: <53FF9D9B.30106@hauke-m.de>
References: <CACna6rzRf7qf0YAFWqp4VgwR76-N8HO12eSz_H5NW9LpjBArdw@mail.gmail.com> <2859425.94ptgpItD3@wuerfel> <53FF9D9B.30106@hauke-m.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 28 August 2014 23:22:35 Hauke Mehrtens wrote:
> 
> I think we have to provide an own device tree for every board, like it
> is done for other arm boards. If we do so I do not see a problem to
> specify the nvram address space in device tree.  I do not think the arm
> guys do like some board files containing the gpio numbers of the leds
> and buttons found on the board.

Ok. The part I'm not sure about is how to best represent the nvram
in a way that matches the actual hardware.

If the two physical address ranges are just used for the purpose
of showing nvram, that would be fairly straightforward, and we
can jut put both of them in DT, mark them as 'status="disabled"'
by default and let the board specific file enable the one it needs.

However, if these registers really belong into the address range
that is owned by the flash controller device and that is behind
the bcma bus logic, things get a little tricky and we have to decide
whether we want to intentionally put a simplified (and incorrect)
description into the DT to make it easier to use, or to make
the description more correct at the expense of complicating the
code to detect it (thereby negating the intention of this hardware,
which is built to make it easier to boot).

> For the MIPS version of BCM47xx we are able to automatically detect
> mostly everything, just for the gpio configuration we try to guess the
> board name based on nvram content and then configure the gpios.

We could still do something like this with a boot wrapper that fills
the fields in the dtb from nvram data. We are pretty flexible in
the kernel when it comes to how that dtb is created, and there is no
requirement to have each board's dts file be part of the kernel sources
if there is some pre-kernel environment (firmware, boot loader,
wrapper, ...) that can generate it for us.

> The ARM BCM47xx contains a standard ARM with GIC and other standard arm
> things just the flash, Ethernet, PCIe, USB controller and their
> interconnection are Braodcom specific.

Ok.

> My plan was to provide a nvram and sprom driver which registers as a
> normal platform device and supports device tree, like the one I posted
> and it would also be possible to call the function with the address of
> the flash directly, this function would be used for MIPS, this way we
> can share the code and do not have to change the mips stuff so much.

Yes, and none of that should interfere with the cleanup plans for MIPS
that Rafał talked about, right?

> For ARM BCM47xx we do not need bcma at all to boot the device, so it
> should also work when bcma is build as a module, this is different to
> MIPS. The ARM BCM47xx code currently in mainline Linux boots for me into
> user space with an initramfs, it just misses many parts like Ethernet,
> flash PCIe, ...

Ah, good. So to confirm: all the essential devices including irqchip,
clocksource, uart and nvram can be accessed without using the bcma bus,
right?
Does that mean they are actually connected to another bus, or are they
actually bcma bus devices for which you provide an additional probe
method using dt/platform_device?

> The address of the console is already hard coded in device tree. It
> would also be possible to automatically detect their address based on
> some description in the AIX bus (bcma), but I think hard coding the
> address in device tree is easier.

Right. Importantly for the console, there are patches to allow a very
early output by having some minimal dt parsing done before start
accessing any other hardware. I think this is valuable even if it
means we compromise on the accurate DT description. We do the same
thing for consoles on other buses (ISAPnP, PCI, of_platform, ...)
and a lot of serial drivers have a way to retroactively connect that
early console setup to the actual device once it is probed normally.

	Arnd
