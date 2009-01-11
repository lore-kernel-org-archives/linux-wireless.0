Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qmta02.emeryville.ca.mail.comcast.net ([76.96.30.24]:35545 "EHLO
	QMTA02.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751072AbZAKE5I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Jan 2009 23:57:08 -0500
Date: Sat, 10 Jan 2009 20:56:56 -0800
From: "Mark A. Haun" <haunma@keteu.org>
To: Christian Lamparter <chunkeey@web.de>
Cc: linux-wireless@vger.kernel.org
Subject: Re: p54 "device does not respond" with fullmac SMC 2802W PCI
Message-ID: <20090110205656.11feaf02@angwin.keteu.org> (sfid-20090111_055714_717175_2040546C)
In-Reply-To: <200901101321.50077.chunkeey@web.de>
References: <20090109182322.263db101@angwin.keteu.org>
	<200901101321.50077.chunkeey@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Christian,

On Sat, 10 Jan 2009 13:21:49 +0100
Christian Lamparter <chunkeey@web.de> wrote:
> > This is how the card identifies in lspci -v:
> > [...]
>
> what's lspci -nnv -s 0a:00.0 ? (I'm looking for the subsystem vendor
> & product id)

0a:00.0 Network controller [0280]: Intersil Corporation ISL3890
[Prism GT/Prism Duette]/ISL3886 [Prism Javelin/Prism Xbow] [1260:3890]
(rev 01)
        Subsystem: Standard Microsystems Corp [SMC] SMC2802W Wireless
                   PCI Adapter [10b8:2802]
        Flags: medium devsel, IRQ 16
        Memory at fd0fe000 (32-bit, non-prefetchable) [size=8K]
        Capabilities: [dc] Power Management version 1
        Kernel modules: p54pci

> > p54pci 0000:0a:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> > p54pci 0000:0a:00.0: setting latency timer to 64
> > p54pci 0000:0a:00.0: firmware: requesting isl3886
> > p54: LM86 firmware
> > p54: FW rev 2.13.1.0 - Softmac protocol 5.5
> > phy0: device does not respond!
> > p54pci 0000:0a:00.0: PCI INT A disabled
> > p54pci: probe of 0000:0a:00.0 failed with error -16
> > 
> > (I am running 'pristine' 2.6.28 SMP x86_64.  Is there a way to make
> > this more verbose?)
> did you compile the old prism54 code as well? If yes, can you please
> try if it works?

My laptop with wireless is at work now, but this was the kernel log
when I tried without the correct p54 firmware name:

p54pci 0000:09:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
p54pci 0000:09:00.0: setting latency timer to 64
p54pci 0000:09:00.0: firmware: requesting isl3886
0000:09:00.0 (p54pci): cannot find firmware (isl3886)
p54pci 0000:09:00.0: PCI INT A disabled
p54pci: probe of 0000:09:00.0 failed with error -2
Loaded prism54 driver, version 1.2
prism54 0000:09:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16

(I later got rid of prism54 for fear of a conflict.  I didn't
actually confirm that prism54 worked, but it didn't complain, and it
was working ok in the past.)

> You can give the wireless-testing git tree a try. (Although, I don't
> think it will work either...) (with this firmware
> http://daemonizer.de/prism54/prism54-fw/fw-softmac/2.13.12.0.arm .
> put it into /lib/firmware and link it to isl3886pci).

Thanks; if we get stuck here it will be worth a try.

Regards,

Mark
