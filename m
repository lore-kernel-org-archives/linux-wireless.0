Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:56681 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752948AbZHCRCo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Aug 2009 13:02:44 -0400
Subject: Re: [PATCH 1/1] rfkill: add the GPS radio type
From: Marcel Holtmann <marcel@holtmann.org>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <1ba2fa240908030953w3dd40803l1e135cb73ee1cff@mail.gmail.com>
References: <1249169809-11853-1-git-send-email-tomas.winkler@intel.com>
	 <1249171448.3491.32.camel@localhost.localdomain>
	 <1ba2fa240908012249s348a2412wca21de44f9b8cb71@mail.gmail.com>
	 <1249199143.2007.2.camel@johannes.local>
	 <1249230503.3491.43.camel@localhost.localdomain>
	 <1ba2fa240908030723g634f222dn6d1b02e4d683b4d5@mail.gmail.com>
	 <1249316678.3094.4.camel@localhost.localdomain>
	 <1ba2fa240908030953w3dd40803l1e135cb73ee1cff@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 03 Aug 2009 10:02:37 -0700
Message-Id: <1249318957.3094.11.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Tomas,

> >> >> > > we don't have a GPS subsystem, but even without it, I think this is a
> >> >> > > good thing to have.
> >> >> >
> >> >> > GPS devices are usually serial devices.
> >> >>
> >> >> Yeah, this is interesting -- do we want something like /dev/urfkill
> >> >> (cf. /dev/uinput), so that gpsd or whatever is controlling the GPS (same
> >> >> applies for 3G) can be controlled with rfkill?
> >> >
> >> > on one hand I think urfkill might be needed, on the other hand I think
> >> > we should not do it at all. Currently I would think it is better to
> >> > force the RFKILL integration in the kernel so that we have proper
> >> > subsystem integration, or platform RFKILL switches or in cases like GPS
> >> > and WWAN/3G it will be driver integration. For 3G we already have the
> >> > hso.ko driver which has a killswitch and we just need to fix the other
> >> > ones. I am actually looking into it, if this is possible without an AT
> >> > parser inside the kernel.
> >>
> >> >
> >> > So the GPS world is evolving right now and that everybody implements
> >> > them as kernel-tty-passthrough pseudo driver and then a binary only
> >> > daemon and then gpsd/gypsy on top of it will only survive for certain
> >> > amount of time. The binary component will not get wide acceptance. And
> >> > even if the binary only userspace component stays, we might still need a
> >> > proper GPS subsystem since using TTY as pure transport is holding us
> >> > back. Could be that AF_GPS would have been a way better choice. This
> >> > will sort itself out over time.
> >> >
> >>
> >> BT also fails to the same category. BT driver also just servers as HCI
> >> transport layer.
> >> Current implementation of closing device driver is not sufficient to
> >> really bring the device to rfkill mode. My point is from multi com
> >> devices. What vendor implements are proprietary HCI commands that
> >> brings device to rfkill mode, there is no standard. So in general you
> >> would need HCI parser similar to AT parser or NMEA GPS parser  The
> >> rfkill event is transferred inside the transport not visible to device
> >> driver.
> >> In other words RFKILL is happening between device and application w/o
> >> kernel intervention. This is a problem since usually user application
> >> and kernel has to be somehow notified.
> >
> > I have no idea what you are talking about here. The Bluetooth RFKILL
> > does exactly the right thing. The driver gets the down callback and is
> > responsible to bring the device down. It is expected that the radio will
> > be brought down at that point.
> 
> Let say you have USB device with 2 ports BT and Wifi  Closing prot
> just releases urbs but it doesn't tell to particular port to shut the
> radio it has no means for that., you have wifi running in parallel
> playing with the radio its BT/WIFI coexistent games it has no
> knowledge about rfkill event.   In SDIO things are little better since
> you call sdio_disable_func() but you only guessing that device will
> interpret it as rfkill  as well.

this is a problem of the firmware inside the device. And if it is USB,
it could just have proper vendor specific control URBs that allow you to
control the radio RFKILL capabilities. If you happen to have a device
that has no notion of RFKILL at all, then that is just bad luck.

In embedded systems you can also have platform RFKILL switches that
toggle directly the power state via a GPIO. This is what we call a hard
killswitch. The subsystem integrated switches are softkill switches.

> >> Frankly I still don't understand what flow of how /dev/uevent is
> >> helpful here. Who is notifying whom about rfkill event.
> >
> > Starting with 2.6.31 kernel we are using /dev/rfkill for notification
> > about RFKILL state changes. Previously it was done via uevents, but that
> > was more broken than helpful.
> 
> So how /dev/rfkill differs from /dev/urfkill ?

I did explain that in the other email. We only have /dev/rfkill right
now and it might stay this way. The /dev/urfkill would be a way to
implement an RFKILL switch from within userspace.

Regards

Marcel


