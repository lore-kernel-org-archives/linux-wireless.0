Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:36426 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751332AbZKCPQI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Nov 2009 10:16:08 -0500
Date: Tue, 3 Nov 2009 10:16:12 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
To: Dan Williams <dcbw@redhat.com>
cc: Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
	Frank Schaefer <schaefer.frank@gmx.net>,
	<linux-wireless@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] ar9170usb: add mode-switching for AVM Fritz!WLAN USB N
 devices in cdrom mode
In-Reply-To: <1257198124.1027.63.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.44L0.0911031001470.10778-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2 Nov 2009, Dan Williams wrote:

> In userspace, usb_modeswitch is the place to put all this logic.  Then
> you tie it together with udev rules using some bubble-gum and duct-tape,
> and maybe it works.  Of course, there's massive duplication of data
> between usb_modeswitch and the kernel drivers, because the there's
> simply no communication between the two.

The only reason for this "massive" duplication is that nobody has
bothered to remove from the kernel the parts that usb_modeswitch can
handle.  Adding yet more switching code into the kernel, thereby
_increasing_ the amount of duplication, seems like a bad idea.

> The kernel drivers know which devices are supported and how to drive
> them.

No.  The kernel drivers (usb-storage is where most if not all of the
kernel-side mode-switching code has ended up) only know about the
particular devices _they_ support.  They don't know about the other
devices supported by usb_modeswitch.

>  But because the eject code isn't in kernelspace, all that device
> selection logic has to be duplicated in userspace with usb_modeswitch.
> Pretty dumb.

What are you talking about?  Of course usb-storage contains 
mode-switching code for the devices it switches.  And for the devices 
it doesn't switch, it does not contain device-selection logic.

> Maybe we can get the kernel drivers to expose the information we need
> (maybe even an 'eject' attribute in sysfs or something) and then we just
> have to write udev rules instead of having a whole bunch of libusb junk
> in userspace?  Would that preserve the policy-always-in-userspace
> requirement yet keep the code to drive the hardware in kernel space
> where it really belongs?

This sounds as if you are trying very hard to get the _worst_ of both
worlds!  You would force users to upgrade their kernels before they can
use new devices (because the kernel is where the mode-switch code will
be), and you also would force them to upgrade their userspace settings
(so that the new mode-switch code will be called).

I'm with Matt Dharm and Josua Dietze on this.  Jobs that can be handled 
in userspace _should_ be handled there.

Alan Stern

