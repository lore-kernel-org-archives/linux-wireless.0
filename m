Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:59471 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751769AbXBMTU0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Feb 2007 14:20:26 -0500
Subject: Re: network manager vs. missing firmware
From: Dan Williams <dcbw@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1171392106.10344.100.camel@johannes.berg>
References: <1171392106.10344.100.camel@johannes.berg>
Content-Type: text/plain
Date: Tue, 13 Feb 2007 14:23:18 -0500
Message-Id: <1171394598.5329.31.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2007-02-13 at 19:41 +0100, Johannes Berg wrote:
> Hi,
> 
> Just remembered this issue from last year's summit and figured I'd bring
> it up again since we never made progress on it.
> 
> Is there any idea other than standardising on a new error code
> -ENOFIRMWARE that can be returned from device up or association or
> wherever makes sense for the driver. Or do we also mandate that it be
> returned on device up, and for example never on module load? I think
> it's mostly a question of documentation/driver acceptance policy/driver
> review as well as a question of whether we can get a new error code into
> the kernel or not.........

The simpler, the better I think; but it's complicated.  A sample of
current drivers and when they call request_firmware() from a 2.6.19
kernel:

on dev->open: atmel, prism54, bcm43xx (softmac)
on dev->init: ipw2100, ipw2200
on probe: zd1201, libertas, spectrum_cs

So this isn't really consistent.  I'm unclear as to why the ipw cards
need it on init rather than on dev open, but hey, why make things
easier?

With USB devices (and spectrum_cs I guess), most can't do _anything_
until you upload firmware to them, so the firmware upload really does
need to happen on probe, not device up.  I guess we have two main
use-cases to target here.  We all know what the case on dev up is
(-ENOFILE or whatever gets returned from request_firmware()) but I have
no idea how to detect the error on module load (ie, probe) because
that's _waaay_ before NM gets into the business.  The kernel should
normally be autoloading the modules for you, otherwise half the time NM
won't even know the device is there in the first place.

So for USB devices and the like, if the firmware isn't there, the module
will have already failed to load, and HAL won't know it's a wireless
interface because it's not in sysfs as a wireless interface, and
therefore NM won't know about it, and therefore there is no error to
catch.  I don't think NM should be in the business of searching through
USB devices to find ones that don't report themselves as wireless
devices.

So there are two questions:

1) What's the failure mode for request_firmware() error on probe?  How
does a userspace program notice that the hardware has no firmware?

2) What's the failure case for ipw* drivers that do it on dev->init, why
are they different, and how would a userspace program know that the
firmware load failed?

We need to make sure that this is fixed for d80211 drivers too; at least
try to specify when firmware should be loaded if we can.

Dan


