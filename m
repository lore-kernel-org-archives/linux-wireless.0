Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:47937 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751627Ab2ACJkO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jan 2012 04:40:14 -0500
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1Ri0qq-0005qj-9g
	for linux-wireless@vger.kernel.org; Tue, 03 Jan 2012 10:40:12 +0100
Received: from 188.16.200.234 ([188.16.200.234])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 03 Jan 2012 10:40:12 +0100
Received: from patrakov by 188.16.200.234 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 03 Jan 2012 10:40:12 +0100
To: linux-wireless@vger.kernel.org
From: "Alexander E. Patrakov" <patrakov@gmail.com>
Subject: Re: loading firmware while usermodehelper disabled.
Date: Tue, 3 Jan 2012 15:16:37 +0600
Message-ID: <20120103151637.1388e204@home> (sfid-20120103_104019_322635_4664B59C)
References: <Pine.LNX.4.44L0.1201021041550.10702-100000@netrider.rowland.org>
	<4F02165C.1060400@fastmail.fm>
	<CA+55aFwf06vRraVqtz8_2qWjxH0V=Yj5m7mEy3XVbA7+qj5k5A@mail.gmail.com>
	<20120102211904.GA15316@srcf.ucam.org>
	<CA+55aFwJuuvqcsgHnZ4-VhUhbVvL6beKogo1adgYyZt_ZM=H7A@mail.gmail.com>
	<20120102215028.GA15701@srcf.ucam.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
In-Reply-To: <20120102215028.GA15701@srcf.ucam.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Matthew Garrett <mjg@redhat.com> wrote:

> On Mon, Jan 02, 2012 at 01:27:03PM -0800, Linus Torvalds wrote:
> 
> > If we didn't load the firmware before the suspend, then the resume
> > function of a device sure as hell had better not load it at resume
> > time either.
> 
> If the hardware has lost its state then refusing to load the firmware
> at resume time isn't going to leave you with a working device.
> 
> > And for chrissake, don't bother making it more complicated than it
> > is, just for some theoretical hardware or situation that nobody
> > cares about.
> 
> It's not theoretical hardware. This appears to be the current
> behaviour of the isight devices. If you reboot they retain their
> firmware. If you suspend, they don't. So if we have a flow like this:
> 
> 1) user boots from cold. Device comes up with generic USB ID.
> 2) isight_firmware loads and binds. Firmware is loaded. Device 
> disconnects and reconnects with an ID that's bound by the UVC driver.
> 3) user reboots. Device comes up with UVC ID. isight_firmware doesn't 
> bind.
> 4) user suspends.
> 5) user resumes. isight_firmware binds and attempts to load firmware.
> 
> then just caching the firmware is inadequate - we had never
> previously seen the device on this boot, so we've never loaded it in
> order to cache it. isight_firmware could unconditionally load the
> firmware on module load just in case a device is plugged in, but that
> seems even less elegant than caching it.

What a heated discussion due to, essentially, a non-technical, legal
issue! Remember that the whole "userspace firmware loader" saga
together with the asynchronous firmware interface started when Debian
started complaining over the non-freeness of the firmware being bundled
as a part of the kernel module as an array of bytes. That design,
however, never had such dependency issues. So maybe revert to it, with
the following changes, and solve the legal issue seen by Debian by
hiring a lawyer?

1. Make firmware a special case of a data-only non-GPL kernel module.
Change the tainter so that it doesn't taint the kernel for data-only
modules.
2. Make the actual driver depend on the relevant firmware modules for
all devices supported by it, even if the devices don't always need the
said firmware.
3. Disallow building drivers that need firmware as non-modules.
4. Do something (e.g. split the driver into a core and a shim, or make
a fake firmware module) to allow the user to install without firmware
if he knows that it works with his hardware.
5. Profit!

This way, as long as the driver is loaded, the necessary firmware is
also there, as a dependency.

-- 
Alexander E. Patrakov

