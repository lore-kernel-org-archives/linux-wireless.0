Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:60539 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831AbXBMThm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Feb 2007 14:37:42 -0500
Subject: Re: network manager vs. missing firmware
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1171394598.5329.31.camel@localhost.localdomain>
References: <1171392106.10344.100.camel@johannes.berg>
	 <1171394598.5329.31.camel@localhost.localdomain>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-xtubkB2j1o7LsEQmipNs"
Date: Tue, 13 Feb 2007 20:37:38 +0100
Message-Id: <1171395459.10344.123.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-xtubkB2j1o7LsEQmipNs
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-02-13 at 14:23 -0500, Dan Williams wrote:

> The simpler, the better I think; but it's complicated.  A sample of
> current drivers and when they call request_firmware() from a 2.6.19
> kernel:
>=20
> on dev->open: atmel, prism54, bcm43xx (softmac)
> on dev->init: ipw2100, ipw2200
> on probe: zd1201, libertas, spectrum_cs

ouch.

> So this isn't really consistent.  I'm unclear as to why the ipw cards
> need it on init rather than on dev open, but hey, why make things
> easier?

When is ->init() called anyway? Isn't it when you register the netdev so
it would be on probe?

> With USB devices (and spectrum_cs I guess), most can't do _anything_
> until you upload firmware to them, so the firmware upload really does
> need to happen on probe, not device up.  I guess we have two main
> use-cases to target here.  We all know what the case on dev up is
> (-ENOFILE or whatever gets returned from request_firmware())

-ENOENT :)
But then we need to specify that returning -ENOENT from dev up is not
valid in any other case I guess.

> but I have
> no idea how to detect the error on module load (ie, probe) because
> that's _waaay_ before NM gets into the business.  The kernel should
> normally be autoloading the modules for you, otherwise half the time NM
> won't even know the device is there in the first place.

Well, the kernel will just show in sysfs what the system can support and
udev will autoload modules based on that.

But actually, I don't think you fail module load. The thing is that when
->probe() fails the module will usually (unless you write code) be
loaded but not bound to any device.

> So for USB devices and the like, if the firmware isn't there, the module
> will have already failed to load, and HAL won't know it's a wireless
> interface because it's not in sysfs as a wireless interface, and
> therefore NM won't know about it, and therefore there is no error to
> catch.  I don't think NM should be in the business of searching through
> USB devices to find ones that don't report themselves as wireless
> devices.

Yeah, that's a good point.

> So there are two questions:
>=20
> 1) What's the failure mode for request_firmware() error on probe?  How
> does a userspace program notice that the hardware has no firmware?

As I said above, the driver will be loaded but no device will be bound
to it. That could actually be taken as a sign... If you look into
/sys/module/*/drivers you can find those values for * that are known
wireless modules and have no devices associated. ;)

Of course, DON'T ACTUALLY DO THIS! This breaks for various reasons:
 * drivers that are built-in
 * computers with multiple wireless devices that have a single driver
   but need different firmware (can happen with bcm43xx)
(and that's just those that I can think of right now)

This is a really tough case to recognise for a program.

But then again, even usb drivers don't need to load firmware to know
that there's a device and to register a netdev. They might not be able
to assign a mac address but that shouldn't hurt (though we have to make
sure d80211 can cope with this), so we can mandate deferring it at least
to netdev registration, and then I don't see why ipw* needs it right
away there as opposed to open().

johannes

--=-xtubkB2j1o7LsEQmipNs
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF0hOC/ETPhpq3jKURAm70AJsGMdPG1RyZzCXLrlSCEHq4oLn9XQCgkILz
ZKp2Qxy9QdK9aHl6RJgdm/w=
=HNUG
-----END PGP SIGNATURE-----

--=-xtubkB2j1o7LsEQmipNs--

