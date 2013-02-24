Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:36193 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015Ab3BXWbB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Feb 2013 17:31:01 -0500
From: Christian Lamparter <chunkeey@googlemail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: carl9170 A-MPDU transmit problem
Date: Sun, 24 Feb 2013 23:30:56 +0100
Cc: Seth Forshee <seth.forshee@canonical.com>,
	linux-usb@vger.kernel.org,
	"Chen, Stephen" <scchen@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org
References: <Pine.LNX.4.44L0.1302241048230.22522-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1302241048230.22522-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain; charset=US-ASCII
Message-Id: <201302242330.56346.chunkeey@googlemail.com> (sfid-20130224_233109_491653_C810B2FD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday, February 24, 2013 04:54:26 PM Alan Stern wrote:
> On Sat, 23 Feb 2013, Seth Forshee wrote:
> > On Sat, Feb 23, 2013 at 03:07:08PM +0100, Christian Lamparter wrote:
> > > usb_submit_urb() is async, so unless the URB data structure is
> > > bogus, the device is in the middle of a reset/is removed or OOM
> > > it won't return with an -ENUMBER.
> > > 
> > > Since neither of us has probably access to an USB analyzer, the
> > > next best thing would be to enable ehci_hcd's debug facilities
> > > and check if the stuck frame produced any DataBufferErr, XactErr
> > > or something else.
> There aren't any occurrences of such errors in the usbmon trace.

Yes, I see no -EPROTO, -EPIPE (no stalled endpoints), -ECOMM, -EIMPORTANT...
either. Just the -EINPROGRESS, however this is perfectly OK!
 
> > I've found a couple of things here. First, I wasn't sure if I had tested
> > this on anything other than Ivy Bridge machines yet, so I tried it out
> > on an Arrandale box and it worked perfectly. lspci on the Ivy Bridge
> > boxes yields:
> > 
> > 00:14.0 USB controller [0c03]: Intel Corporation 7 Series/C210 Series Chipset Family USB xHCI Host Controller [8086:1e31] (rev 04) (prog-if 30 [XHCI])
> > 00:1a.0 USB controller [0c03]: Intel Corporation 7 Series/C210 Series Chipset Family USB Enhanced Host Controller #2 [8086:1e2d] (rev 04) (prog-if 20 [EHCI])
> > 00:1d.0 USB controller [0c03]: Intel Corporation 7 Series/C210 Series Chipset Family USB Enhanced Host Controller #1 [8086:1e26] (rev 04) (prog-if 20 [EHCI])
> > 
> > And on the Arrandale box:
> > 
> > 00:1a.0 USB controller [0c03]: Intel Corporation 5 Series/3400 Series Chipset USB2 Enhanced Host Controller [8086:3b3c] (rev 06) (prog-if 20 [EHCI])
> > 00:1d.0 USB controller [0c03]: Intel Corporation 5 Series/3400 Series Chipset USB2 Enhanced Host Controller [8086:3b34] (rev 06) (prog-if 20 [EHCI])
> > 
> > Second, I collected the usbmon trace as suggested by Alan. I don't know
> > enough about USB to really read it, but normally the time between
> > submission and callback for a given urb is short. However, some are much
> > longer, e.g.:
> > 
> > ffff88012fe19500 1519981417 S Bo:3:003:1 -115 126 = 7e000000 190f0100 23232303 42b53600 82b11a00 01c02e00 6a00e846 c2ad3e00
> > ...
> > ffff88012fe19500 1522200720 C Bo:3:003:1 0 126 >
> > 
> > I checked the urb addresses for a couple of the stalled frames and in
> > each case found a matching urb in the usbmon trace with a similarly long
> > duration between submission and callback. I've uploaded the full trace
> > to:
> > 
> >   http://people.canonical.com/~sforshee/carl9170-usbmon.log

Seth,

Did you plug the DWA-160 device into a USB 3.0 port on your ivy bridge
system or does it react in the same way on the 'legacy' USB 2.0 ports as
well [so we are not comparing xhci (Ivy Bridge) to ehci (Arrandale)]?

> The usbmon trace indicates that the data gets delivered to the device
> as it should, but the device doesn't accept it for several seconds.

Looking at the logs, I find myself wondering how the "ffff88012fe19500"
urb-complete ninja'd right in between the ffff880146c8af00 xmit and
complete.

ffff88012fe19500 1519981417 S Bo:3:003:1 -115 126 = 7e000000 190f0100 23232303 42b53600 82b11a00 01c02e00 6a00e846 c2ad3e00
...
ffff880146c8af00 1522200650 S Bo:3:003:1 -115 62 = 3e000000 01000500 03000000 00000000 00000000 00000000 22000$
ffff88012fe19500 1522200720 C Bo:3:003:1 0 126 > 
ffff880146c8af00 1522200756 C Bo:3:003:1 0 62 >

>From the device side, taking the data shouldn't be a problem. The
rx is handled by hardware dma. The data from the host is put into
packages of 320 bytes (The carl9170 firmware has about 180 to 190
of these 320 byte packages reserved for this purpose. So at no 
point there should be any long delay because of lack of resources
or whatever). Also, it doesn't look the was any unusually high 
load on the link. And the hardware can handle sustained wifi traffic
up to 160mbit/s (udp peaks at about 180mbit/s) without choking.

Alan,

Do you know if there a way to monitor whenever individual attempts
from the ehci/xhci hcd? Or can you think of any other "interesting"
bits that could help to explain why the "Arrandale box [...] worked
perfectly" whereas (all his) Ivy Bridge ones have problems.
(Of course, I assume that it is always the same device, the
same firmware and the same kernel drivers in all tests, right)?

BTW: My sandy-bridge laptop has the following usb controllers:
00:1a.0 USB controller [0c03]: Intel Corporation 6 Series/C200 Series Chipset Family USB Enhanced Host Controller #2 [8086:1c2d] (rev 04)
00:1d.0 USB controller [0c03]: Intel Corporation 6 Series/C200 Series Chipset Family USB Enhanced Host Controller #1 [8086:1c26] (rev 04)
19:00.0 USB controller [0c03]: NEC Corporation uPD720200 USB 3.0 Host Controller [1033:0194] (rev 04)
And so far I haven't come across the described "gap-of-silence".
[my kernel: 3.8.0-wl+. Tested devices: WNDA3100v1 and TL-WN821Nv2].

Regards,
	Christian
