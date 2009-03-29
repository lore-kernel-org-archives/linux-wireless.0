Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qmta11.emeryville.ca.mail.comcast.net ([76.96.27.211]:44389
	"EHLO QMTA11.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751204AbZC2HsW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Mar 2009 03:48:22 -0400
Date: Sun, 29 Mar 2009 00:42:37 -0700
From: "Mark A. Haun" <haunma@keteu.org>
To: Christian Lamparter <chunkeey@web.de>
Cc: linux-wireless@vger.kernel.org
Subject: Re: p54 "device does not respond" with fullmac SMC 2802W PCI
Message-ID: <20090329004237.710775ea@angwin.keteu.org> (sfid-20090329_094826_986111_AFB73A84)
In-Reply-To: <200901101321.50077.chunkeey@web.de>
References: <20090109182322.263db101@angwin.keteu.org>
	<200901101321.50077.chunkeey@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Christian,

I just upgraded to kernel 2.6.29 so I could give this another try.
Unfortunately the error is still unchanged.  Here's the basic info
again:

On Sat, 10 Jan 2009 13:21:49 +0100
Christian Lamparter <chunkeey@web.de> wrote:
> what's lspci -nnv -s 0a:00.0 ? (I'm looking for the subsystem vendor
> & product id)

0a:00.0 Network controller [0280]: Intersil Corporation ISL3890 [Prism
GT/Prism Duette]/ISL3886 [Prism Javelin/Prism Xbow] [1260:3890] (rev 01)
Subsystem: Standard Microsystems Corp [SMC] SMC2802W Wireless PCI
    Adapter [10b8:2802]
Flags: bus master, medium devsel, latency 80, IRQ 16 
Memory at fd0fe000 (32-bit, non-prefetchable) [size=8K]
Capabilities: [dc] Power Management version 1

With the 2.13.12.0 firmware, here is the kernel output:

p54pci 0000:0a:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
p54pci 0000:0a:00.0: firmware: requesting isl3886pci
phy0: p54 detected a LM86 firmware
p54: rx_mtu reduced from 3240 to 2376
phy0: FW rev 2.13.12.0 - Softmac protocol 5.9
phy0: cryptographic accelerator WEP:YES, TKIP:YES, CCMP:YES
phy0: device does not respond!
p54pci 0000:0a:00.0: PCI INT A disabled 
p54pci: probe of 0000:0a:00.0 failed with error -16

This is essentially the same as before (kernel 2.6.28).

> did you compile the old prism54 code as well? If yes, can you please
> try if it works?

I tried this, but the driver is not loading correctly.  The last time
I used it was two or three years ago.  There could be a genuine problem
with my card, but I saw similar reports on the net which suggest to me
there might be a problem with the old prism54 in recent kernels.

What I need to do is see if this card is working in Windows, but, I
don't own a copy and in any case I'm not willing to go through the pain
of putting it on this machine.  It would be a big help to know if there
are any confirmed reports of p54 working with this particular PCI
card.  If someone else is having success I would suspect the problem is
my hardware.

Regards,

Mark
