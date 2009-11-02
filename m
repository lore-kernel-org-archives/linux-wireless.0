Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26527 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756769AbZKBVmV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Nov 2009 16:42:21 -0500
Subject: Re: [PATCH] ar9170usb: add mode-switching for AVM Fritz!WLAN USB N
 devices in cdrom mode
From: Dan Williams <dcbw@redhat.com>
To: Matthew Dharm <mdharm-usb@one-eyed-alien.net>
Cc: Frank Schaefer <schaefer.frank@gmx.net>,
	linux-wireless@vger.kernel.org, linux-usb@vger.kernel.org
In-Reply-To: <20091102211123.GI24436@one-eyed-alien.net>
References: <200910171606.02961.oliver@neukum.org>
	 <Pine.LNX.4.44L0.0910171130550.25594-100000@netrider.rowland.org>
	 <20091017220313.GH24502@one-eyed-alien.net> <4ADC3657.6080906@gmx.net>
	 <4AEDCCA0.8050709@gmx.net> <4AEDD380.40408@draisberghof.de>
	 <4AEDEB85.5080105@gmx.net> <20091102005144.GE24436@one-eyed-alien.net>
	 <4AEF3CAD.10809@gmx.net> <1257193115.1027.24.camel@localhost.localdomain>
	 <20091102211123.GI24436@one-eyed-alien.net>
Content-Type: text/plain
Date: Mon, 02 Nov 2009 13:42:04 -0800
Message-Id: <1257198124.1027.63.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2009-11-02 at 13:11 -0800, Matthew Dharm wrote:
> On Mon, Nov 02, 2009 at 12:18:35PM -0800, Dan Williams wrote:
> > Devices with fake driver CDs and how they are handled currently:
> > 
> > Zydas WLAN   - kernel
> > Huawei 3G    - kernel  (unusual_devs entry)
> > Sierra 3G    - kernel  (drivers/usb/serial/sierra.c)
> > Option 3G    - udev rules, 'rezero', or usb_modeswitch
> > ZTE 3G       - udev rules, simple 'eject'
> 
> It's worth noting that for some of these which are handled in-kernel, it
> had to be done that way because their storage-emulation was so poor that
> the normal 'eject' WOULD NOT work properly.

Half of them don't use eject at all, because of course on Windows the
vendor driver owns the device and can do whatever it wants.  Huawei uses
a custom sequence, Option uses a custom sequence, and so does Sierra.
ZTE is the only one that I've seen that you can actually just "eject"
and make it work.

In userspace, usb_modeswitch is the place to put all this logic.  Then
you tie it together with udev rules using some bubble-gum and duct-tape,
and maybe it works.  Of course, there's massive duplication of data
between usb_modeswitch and the kernel drivers, because the there's
simply no communication between the two.

The kernel drivers know which devices are supported and how to drive
them.  But because the eject code isn't in kernelspace, all that device
selection logic has to be duplicated in userspace with usb_modeswitch.
Pretty dumb.

Maybe we can get the kernel drivers to expose the information we need
(maybe even an 'eject' attribute in sysfs or something) and then we just
have to write udev rules instead of having a whole bunch of libusb junk
in userspace?  Would that preserve the policy-always-in-userspace
requirement yet keep the code to drive the hardware in kernel space
where it really belongs?

Dan


