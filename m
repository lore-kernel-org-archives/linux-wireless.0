Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:46325 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206AbZAJMVw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Jan 2009 07:21:52 -0500
From: Christian Lamparter <chunkeey@web.de>
To: "Mark A. Haun" <haunma@keteu.org>
Subject: Re: p54 "device does not respond" with fullmac SMC 2802W PCI
Date: Sat, 10 Jan 2009 13:21:49 +0100
Cc: linux-wireless@vger.kernel.org
References: <20090109182322.263db101@angwin.keteu.org>
In-Reply-To: <20090109182322.263db101@angwin.keteu.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200901101321.50077.chunkeey@web.de> (sfid-20090110_132157_792590_2C54B80E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

> I have an older "fullmac" SMC 2802W PCI card that I'd like to
> get running with the new p54 driver.  A few years ago I had it working
> with the old prism54 driver.  At the time, I had hoped to set up an AP
> but there were persistent problems between prism54 and hostapd,
> particularly involving WPA.  These seem to be resolved in the new
> driver framework.

AP-Support for mac80211 is still on the todo-list.
http://wireless.kernel.org/en/developers/todo-list#APsupport
 
> This is how the card identifies in lspci -v:
> 
> 0a:00.0 Network controller: Intersil Corporation ISL3890 [Prism
> GT/Prism Duette]/ISL3886
> [Prism Javelin/Prism Xbow] (rev 01)
> 	Subsystem: Standard Microsystems Corp [SMC] SMC2802W Wireless
> PCI Adapter
> 	Flags: medium devsel, IRQ 16 Memory at fd0fe000 (32-bit,
> non-prefetchable) [size=8K]
> 	Capabilities: [dc] Power Management version 1
> 	Kernel modules: p54pci
what's lspci -nnv -s 0a:00.0 ? (I'm looking for the subsystem vendor & product id)

> Following the instructions for kernel 2.6.28 at
> 
> http://wireless.kernel.org/en/users/Drivers/p54,
> 
> I downloaded firmware 2.13.1.0.arm and renamed it "isl3886pci".  I
> think these instructions are incorrect, because the driver then
> complained that it could not find the firmware.  When I renamed it
> "isl3886" the driver found the firmware file, with the following
> result: 
Thanks, fixed the wiki.
 
> p54pci 0000:0a:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> p54pci 0000:0a:00.0: setting latency timer to 64
> p54pci 0000:0a:00.0: firmware: requesting isl3886
> p54: LM86 firmware
> p54: FW rev 2.13.1.0 - Softmac protocol 5.5
> phy0: device does not respond!
> p54pci 0000:0a:00.0: PCI INT A disabled
> p54pci: probe of 0000:0a:00.0 failed with error -16
> 
> (I am running 'pristine' 2.6.28 SMP x86_64.  Is there a way to make
> this more verbose?)
did you compile the old prism54 code as well? If yes, can you please try if it works?

> I'm still suspicious about the instructions.  I think my chip is a
> 3890---does it need its own firmware?
Intersil used the same PCIIDs on several different designs. But so far I haven't seen anyone with a real "3890",
most likely because the 3880 chip was a lot cheaper.

Don't worry the softmac firmware works on previous fullmac designs as well => no special firmwares required.
The reason why we call id isl3886(pci) is because we don't want to conflict with prism54's firmware files.  

> I'd be happy to test out driver patches, etc. if this has a non-trivial
> solution (and assuming anyone still cares about this old hardware).
You can give the wireless-testing git tree a try. (Although, I don't think it will work either...)
(with this firmware http://daemonizer.de/prism54/prism54-fw/fw-softmac/2.13.12.0.arm . 
put it into /lib/firmware and link it to isl3886pci).

Regards,
	Chr
