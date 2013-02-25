Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:59381 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758486Ab3BYP34 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2013 10:29:56 -0500
Date: Mon, 25 Feb 2013 10:29:55 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
To: Christian Lamparter <chunkeey@googlemail.com>
cc: Seth Forshee <seth.forshee@canonical.com>,
	USB list <linux-usb@vger.kernel.org>,
	"Chen, Stephen" <scchen@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: Re: carl9170 A-MPDU transmit problem
In-Reply-To: <201302251604.14717.chunkeey@googlemail.com>
Message-ID: <Pine.LNX.4.44L0.1302251024200.1526-100000@iolanthe.rowland.org> (sfid-20130225_163004_294971_ACE52569)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 25 Feb 2013, Christian Lamparter wrote:

> > In fact this is both normal and required.  Packets to any particular 
> > endpoint must always be delivered in order.  Therefore the URBs have
> > to complete in the same order as they were submitted.
> Yes, I know that ;). I guess I should have said: "It's strange that
> after such a long silence the urb tx trigger at 1519981417 seemd to
> unfreeze the pending urb. It's almost as if a urb completion event
> was lost and the urb_complete just had to wait until another tx urb
> on the same ep went by to free it.   

That's quite possible.  The new URB may trigger something in the
xhci-hcd driver or in the xHCI hardware.  Sarah (CC'ed), the maintainer
for xhci-hcd, is the person who would know best.

> > > From the device side, taking the data shouldn't be a problem. The
> > > rx is handled by hardware dma. The data from the host is put into
> > > packages of 320 bytes (The carl9170 firmware has about 180 to 190
> > > of these 320 byte packages reserved for this purpose. So at no 
> > > point there should be any long delay because of lack of resources
> > > or whatever). Also, it doesn't look the was any unusually high 
> > > load on the link. And the hardware can handle sustained wifi traffic
> > > up to 160mbit/s (udp peaks at about 180mbit/s) without choking.
> > > 
> > >  Or can you think of any other "interesting"
> > > bits that could help to explain why the "Arrandale box [...] worked
> > > perfectly" whereas (all his) Ivy Bridge ones have problems.
> > > (Of course, I assume that it is always the same device, the
> > > same firmware and the same kernel drivers in all tests, right)?
> > 
> > No, not really.  Unless one is using USB-2 and the other USB-3 -- the 
> > device might have a bug in its USB-3 firmware.
> Don't worry, the device was designed about 5 years ago. Hence, we don't
> need to care about any USB 3.0 features.

Since the device firmware is therefore unlikely to be the cause of the 
problem, it now seems a lot more likely that the problem is in the xHCI 
hardware or driver.

> > What happens if xhci-hcd is unloaded before the test?
> Isn't xhci-hcd needed to drive the usb 3.0 ports? I know about the hub
> concept with uhci/ohci and ehci, but I thought they did away with that.

Yes.  Without xhci-hcd, nothing will happen when a device is plugged
into a USB-3 port.  (Although on some systems, ports are wired up as
both USB-2 and USB-3, so when xhci-hcd isn't loaded the ports are
managed by ehci-hcd.)

Never mind; when I wrote the question it wasn't clear that the failures 
occurred only when the device was attached to a USB-3 port.

Alan Stern

