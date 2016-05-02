Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vpn.innerrange.com.au ([203.122.143.146]:58489 "EHLO
	remote.innerrange.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751771AbcEBCXi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 May 2016 22:23:38 -0400
From: Craig McQueen <craig.mcqueen@innerrange.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Mon, 2 May 2016 12:23:28 +1000
Subject: RE: rt2800 and BeagleBone Black soft lockup when unplugging from
 USB hub
Message-ID: <5500469A22567C4BAF673A6E86AFA3A4022D20C81874@IR-CENTRAL.corp.innerrange.com> (sfid-20160502_042430_587832_D9DD3A6B)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I previously wrote:
> I previously wrote:
> >
> > I have a D-Link DWA-140 USB Wi-Fi device which is rt2800 based (5392
> > chipset). I've been testing it on a BeagleBone Black running an Ubuntu
> > 16.04 image (4.4.6 kernel), with a USB hub.
> >
> > When I unplug the Wi-Fi device from the USB hub, and it's connected to
> > an access point, and then I unplug it, the OS appears to lock up. I
> > get messages about a soft lockup on the serial console:
> >
> > [ 9736.136702] NMI watchdog: BUG: soft lockup - CPU#0 stuck for 22s!
> > [kworker/u2:0:1129] [ 9764.136701] NMI watchdog: BUG: soft lockup -
> > CPU#0 stuck for 22s! [kworker/u2:0:1129] [ 9792.136701] NMI watchdog:
> > BUG: soft lockup - CPU#0 stuck for 22s! [kworker/u2:0:1129] [
> > 9820.136699] NMI
> > watchdog: BUG: soft lockup - CPU#0 stuck for 22s! [kworker/u2:0:1129]
> > [ 9848.136696] NMI watchdog: BUG: soft lockup - CPU#0 stuck for 22s!
> > [kworker/u2:0:1129]
> >
> > This will repeat indefinitely, until I unplug the hub, which resolves
> > the soft lockup and then the system seems to function normally.
> >
> > I've attached a dmesg log of the soft lockup stack traces. They seem
> > to indicate a lockup in workqueue rt2x00usb_work_rxdone()
> > (specifically in
> > usb_hcd_submit_urb() called from rt2x00usb_kick_rx_entry() called from
> > rt2x00usb_clear_entry()).
> >
> > I originally found this bug on a 3.14.x kernel built with Yocto for a
> > BeagleBone Black-based product. So it seems this is a bug that has
> > been around for some time.
> 
> I should also note that on the 3.14.x Yocto-built kernel on BeagleBone Black,
> this bug does not occur if the rt2800 device is unplugged directly from the
> BBB's USB port. It only occurs if unplugged from a hub.
> 
> I have tested this on an i586 based eBox-3310A mini-PC running Debian 8.4,
> which has a 3.16.0 kernel, with the same hub and same rt2800 device. But I
> was not able to reproduce this issue.

There is a patch for the AM335x musb driver that seems to fix this:

http://marc.info/?l=linux-usb&m=146173995117456&w=2

So it seems that this issue's root cause is in the AM335x USB interrupt handling, and not the Wi-Fi rt2800 driver.

-- 
Craig McQueen

