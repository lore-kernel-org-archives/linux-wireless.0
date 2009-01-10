Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qmta04.emeryville.ca.mail.comcast.net ([76.96.30.40]:49264 "EHLO
	QMTA04.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752381AbZAJCXc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Jan 2009 21:23:32 -0500
Date: Fri, 9 Jan 2009 18:23:22 -0800
From: "Mark A. Haun" <haunma@keteu.org>
To: linux-wireless@vger.kernel.org
Subject: p54 "device does not respond" with fullmac SMC 2802W PCI
Message-ID: <20090109182322.263db101@angwin.keteu.org> (sfid-20090110_032353_856040_330FB602)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Greetings,

I have an older "fullmac" SMC 2802W PCI card that I'd like to
get running with the new p54 driver.  A few years ago I had it working
with the old prism54 driver.  At the time, I had hoped to set up an AP
but there were persistent problems between prism54 and hostapd,
particularly involving WPA.  These seem to be resolved in the new
driver framework.

This is how the card identifies in lspci -v:

0a:00.0 Network controller: Intersil Corporation ISL3890 [Prism
GT/Prism Duette]/ISL3886
[Prism Javelin/Prism Xbow] (rev 01)
	Subsystem: Standard Microsystems Corp [SMC] SMC2802W Wireless
PCI Adapter
	Flags: medium devsel, IRQ 16 Memory at fd0fe000 (32-bit,
non-prefetchable) [size=8K]
	Capabilities: [dc] Power Management version 1
	Kernel modules: p54pci

Following the instructions for kernel 2.6.28 at

http://wireless.kernel.org/en/users/Drivers/p54,

I downloaded firmware 2.13.1.0.arm and renamed it "isl3886pci".  I
think these instructions are incorrect, because the driver then
complained that it could not find the firmware.  When I renamed it
"isl3886" the driver found the firmware file, with the following
result: 

p54pci 0000:0a:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
p54pci 0000:0a:00.0: setting latency timer to 64
p54pci 0000:0a:00.0: firmware: requesting isl3886
p54: LM86 firmware
p54: FW rev 2.13.1.0 - Softmac protocol 5.5
phy0: device does not respond!
p54pci 0000:0a:00.0: PCI INT A disabled
p54pci: probe of 0000:0a:00.0 failed with error -16

(I am running 'pristine' 2.6.28 SMP x86_64.  Is there a way to make
this more verbose?)

I'm still suspicious about the instructions.  I think my chip is a
3890---does it need its own firmware?

I'd be happy to test out driver patches, etc. if this has a non-trivial
solution (and assuming anyone still cares about this old hardware).

Thanks,

Mark
haunma@keteu.org
