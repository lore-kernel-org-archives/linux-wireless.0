Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f50.google.com ([74.125.83.50]:62987 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759121Ab3BYPEU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2013 10:04:20 -0500
From: Christian Lamparter <chunkeey@googlemail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: carl9170 A-MPDU transmit problem
Date: Mon, 25 Feb 2013 16:04:14 +0100
Cc: Seth Forshee <seth.forshee@canonical.com>,
	linux-usb@vger.kernel.org,
	"Chen, Stephen" <scchen@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org
References: <Pine.LNX.4.44L0.1302241833580.29714-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1302241833580.29714-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201302251604.14717.chunkeey@googlemail.com> (sfid-20130225_160429_597095_6526B31D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday, February 25, 2013 12:41:06 AM Alan Stern wrote:
> On Sun, 24 Feb 2013, Christian Lamparter wrote:
> 
> > > The usbmon trace indicates that the data gets delivered to the device
> > > as it should, but the device doesn't accept it for several seconds.
> > 
> > Looking at the logs, I find myself wondering how the "ffff88012fe19500"
> > urb-complete ninja'd right in between the ffff880146c8af00 xmit and
> > complete.
> > 
> > ffff88012fe19500 1519981417 S Bo:3:003:1 -115 126 = 7e000000 190f0100 23232303 42b53600 82b11a00 01c02e00 6a00e846 c2ad3e00
> > ...
> > ffff880146c8af00 1522200650 S Bo:3:003:1 -115 62 = 3e000000 01000500 03000000 00000000 00000000 00000000 22000$
> > ffff88012fe19500 1522200720 C Bo:3:003:1 0 126 > 
> > ffff880146c8af00 1522200756 C Bo:3:003:1 0 62 >
> 
> In fact this is both normal and required.  Packets to any particular 
> endpoint must always be delivered in order.  Therefore the URBs have
> to complete in the same order as they were submitted.
Yes, I know that ;). I guess I should have said: "It's strange that
after such a long silence the urb tx trigger at 1519981417 seemd to
unfreeze the pending urb. It's almost as if a urb completion event
was lost and the urb_complete just had to wait until another tx urb
on the same ep went by to free it.   
 
> > From the device side, taking the data shouldn't be a problem. The
> > rx is handled by hardware dma. The data from the host is put into
> > packages of 320 bytes (The carl9170 firmware has about 180 to 190
> > of these 320 byte packages reserved for this purpose. So at no 
> > point there should be any long delay because of lack of resources
> > or whatever). Also, it doesn't look the was any unusually high 
> > load on the link. And the hardware can handle sustained wifi traffic
> > up to 160mbit/s (udp peaks at about 180mbit/s) without choking.
> > 
> >  Or can you think of any other "interesting"
> > bits that could help to explain why the "Arrandale box [...] worked
> > perfectly" whereas (all his) Ivy Bridge ones have problems.
> > (Of course, I assume that it is always the same device, the
> > same firmware and the same kernel drivers in all tests, right)?
> 
> No, not really.  Unless one is using USB-2 and the other USB-3 -- the 
> device might have a bug in its USB-3 firmware.
Don't worry, the device was designed about 5 years ago. Hence, we don't
need to care about any USB 3.0 features.

> What happens if xhci-hcd is unloaded before the test?
Isn't xhci-hcd needed to drive the usb 3.0 ports? I know about the hub
concept with uhci/ohci and ehci, but I thought they did away with that.

Regards,
	Chr
