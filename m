Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:47407 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759241Ab3BXEw3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Feb 2013 23:52:29 -0500
Date: Sat, 23 Feb 2013 22:52:23 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: Christian Lamparter <chunkeey@googlemail.com>,
	Alan Stern <stern@rowland.harvard.edu>
Cc: linux-usb@vger.kernel.org,
	"Chen, Stephen" <scchen@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org
Subject: Re: carl9170 A-MPDU transmit problem
Message-ID: <20130224045223.GA2285@thinkpad-t410> (sfid-20130224_055243_611662_BC6AE63E)
References: <20130222205044.GD1418@thinkpad-t410>
 <201302230048.52018.chunkeey@googlemail.com>
 <20130223064600.GA27187@thinkpad-t410>
 <201302231507.09051.chunkeey@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201302231507.09051.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Feb 23, 2013 at 03:07:08PM +0100, Christian Lamparter wrote:
> usb_submit_urb() is async, so unless the URB data structure is
> bogus, the device is in the middle of a reset/is removed or OOM
> it won't return with an -ENUMBER.
> 
> Since neither of us has probably access to an USB analyzer, the
> next best thing would be to enable ehci_hcd's debug facilities
> and check if the stuck frame produced any DataBufferErr, XactErr
> or something else.

I've found a couple of things here. First, I wasn't sure if I had tested
this on anything other than Ivy Bridge machines yet, so I tried it out
on an Arrandale box and it worked perfectly. lspci on the Ivy Bridge
boxes yields:

00:14.0 USB controller [0c03]: Intel Corporation 7 Series/C210 Series Chipset Family USB xHCI Host Controller [8086:1e31] (rev 04) (prog-if 30 [XHCI])
00:1a.0 USB controller [0c03]: Intel Corporation 7 Series/C210 Series Chipset Family USB Enhanced Host Controller #2 [8086:1e2d] (rev 04) (prog-if 20 [EHCI])
00:1d.0 USB controller [0c03]: Intel Corporation 7 Series/C210 Series Chipset Family USB Enhanced Host Controller #1 [8086:1e26] (rev 04) (prog-if 20 [EHCI])

And on the Arrandale box:

00:1a.0 USB controller [0c03]: Intel Corporation 5 Series/3400 Series Chipset USB2 Enhanced Host Controller [8086:3b3c] (rev 06) (prog-if 20 [EHCI])
00:1d.0 USB controller [0c03]: Intel Corporation 5 Series/3400 Series Chipset USB2 Enhanced Host Controller [8086:3b34] (rev 06) (prog-if 20 [EHCI])

Second, I collected the usbmon trace as suggested by Alan. I don't know
enough about USB to really read it, but normally the time between
submission and callback for a given urb is short. However, some are much
longer, e.g.:

ffff88012fe19500 1519981417 S Bo:3:003:1 -115 126 = 7e000000 190f0100 23232303 42b53600 82b11a00 01c02e00 6a00e846 c2ad3e00
...
ffff88012fe19500 1522200720 C Bo:3:003:1 0 126 >

I checked the urb addresses for a couple of the stalled frames and in
each case found a matching urb in the usbmon trace with a similarly long
duration between submission and callback. I've uploaded the full trace
to:

  http://people.canonical.com/~sforshee/carl9170-usbmon.log

> Also, we should check what the device is doing. The hardware has
> an (Faraday Tech) FUSB200 PHY. It's initialized and partially 
> controlled by the carl9170 firmware.
> (fw source is available at <https://github.com/chunkeey/carl9170fw>).

I probably won't get a chance to play with the firmware until Monday.

Thanks,
Seth

