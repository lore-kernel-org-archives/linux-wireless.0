Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:41857 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756396Ab3BXPy1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Feb 2013 10:54:27 -0500
Date: Sun, 24 Feb 2013 10:54:26 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
To: Seth Forshee <seth.forshee@canonical.com>
cc: Christian Lamparter <chunkeey@googlemail.com>,
	<linux-usb@vger.kernel.org>,
	"Chen, Stephen" <scchen@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>
Subject: Re: carl9170 A-MPDU transmit problem
In-Reply-To: <20130224045223.GA2285@thinkpad-t410>
Message-ID: <Pine.LNX.4.44L0.1302241048230.22522-100000@netrider.rowland.org> (sfid-20130224_165433_468634_593061F8)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 23 Feb 2013, Seth Forshee wrote:

> On Sat, Feb 23, 2013 at 03:07:08PM +0100, Christian Lamparter wrote:
> > usb_submit_urb() is async, so unless the URB data structure is
> > bogus, the device is in the middle of a reset/is removed or OOM
> > it won't return with an -ENUMBER.
> > 
> > Since neither of us has probably access to an USB analyzer, the
> > next best thing would be to enable ehci_hcd's debug facilities
> > and check if the stuck frame produced any DataBufferErr, XactErr
> > or something else.

There aren't any occurrences of such errors in the usbmon trace.

> I've found a couple of things here. First, I wasn't sure if I had tested
> this on anything other than Ivy Bridge machines yet, so I tried it out
> on an Arrandale box and it worked perfectly. lspci on the Ivy Bridge
> boxes yields:
> 
> 00:14.0 USB controller [0c03]: Intel Corporation 7 Series/C210 Series Chipset Family USB xHCI Host Controller [8086:1e31] (rev 04) (prog-if 30 [XHCI])
> 00:1a.0 USB controller [0c03]: Intel Corporation 7 Series/C210 Series Chipset Family USB Enhanced Host Controller #2 [8086:1e2d] (rev 04) (prog-if 20 [EHCI])
> 00:1d.0 USB controller [0c03]: Intel Corporation 7 Series/C210 Series Chipset Family USB Enhanced Host Controller #1 [8086:1e26] (rev 04) (prog-if 20 [EHCI])
> 
> And on the Arrandale box:
> 
> 00:1a.0 USB controller [0c03]: Intel Corporation 5 Series/3400 Series Chipset USB2 Enhanced Host Controller [8086:3b3c] (rev 06) (prog-if 20 [EHCI])
> 00:1d.0 USB controller [0c03]: Intel Corporation 5 Series/3400 Series Chipset USB2 Enhanced Host Controller [8086:3b34] (rev 06) (prog-if 20 [EHCI])
> 
> Second, I collected the usbmon trace as suggested by Alan. I don't know
> enough about USB to really read it, but normally the time between
> submission and callback for a given urb is short. However, some are much
> longer, e.g.:
> 
> ffff88012fe19500 1519981417 S Bo:3:003:1 -115 126 = 7e000000 190f0100 23232303 42b53600 82b11a00 01c02e00 6a00e846 c2ad3e00
> ...
> ffff88012fe19500 1522200720 C Bo:3:003:1 0 126 >
> 
> I checked the urb addresses for a couple of the stalled frames and in
> each case found a matching urb in the usbmon trace with a similarly long
> duration between submission and callback. I've uploaded the full trace
> to:
> 
>   http://people.canonical.com/~sforshee/carl9170-usbmon.log

The usbmon trace indicates that the data gets delivered to the device
as it should, but the device doesn't accept it for several seconds.

Alan Stern

