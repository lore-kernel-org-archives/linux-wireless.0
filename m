Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56310 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752969AbZC3V0x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2009 17:26:53 -0400
Subject: Re: [RFC] rfkill: rewrite
From: Johannes Berg <johannes@sipsolutions.net>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Inaky Perez-Gonzalez <inaky@linux.intel.com>,
	Dirk Opfer <Dirk@Opfer-Online.de>, toshiba_acpi@memebeam.org,
	Matthew Garrett <mjg@redhat.com>
In-Reply-To: <20090330211513.GF23749@khazad-dum.debian.net>
References: <1238349195.24972.5.camel@johannes.local>
	 <20090330211513.GF23749@khazad-dum.debian.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-A2us4ldByuGkQqiGXfUh"
Date: Mon, 30 Mar 2009 23:26:20 +0200
Message-Id: <1238448380.5970.49.camel@johannes.local> (sfid-20090330_232657_979751_7B89A022)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-A2us4ldByuGkQqiGXfUh
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-03-30 at 18:15 -0300, Henrique de Moraes Holschuh wrote:

> > +struct rfkill_ops {
> > +#if defined(CONFIG_RFKILL) || defined(CONFIG_RFKILL_MODULE)
> > +	bool (*poll_hw_block)(void *data);
> > +	bool (*query_state)(void *data);
> > +	void (*set_block)(void *data, bool blocked);
> >  #endif
>=20
> Missing error handling on set_block...  could you change that to:
>=20
> int (*set_block)(void *data, bool blocked)
>=20
> with the usual kernel error semathics (0 =3D no error,  < 0 =3D specific
> error)?   And of course, do the error handling on the core?
>=20
> I don't know about wireless network drivers, but platform drivers want
> to be able to return errors, they _do_ happen when you are doing ACPI
> dances:  EBUSY, EIO, ENOMEM...
>=20
> If something in userspace wants to block a transmitter, it better get
> an error back if the transmitter could not be blocked.  The opposite
> (unblock) is less critical in the safety sense, but no less critical
> in the usability sense, so it wants proper error feedback as well.

I was considering that, but the current users of the API have no chance
to act on the error. It _might_ make sense to put it back when we add
the userspace API back, but what should userspace do in that case?

OTOH if it does return an error the sw block bit probably shouldn't be
set, so I guess I'll change that.

> > +/**
> > + * rfkill_register - Register a rfkill structure.
> > + * @rfkill: rfkill structure to be registered
> > + *
> > + * This function should be called by the network driver when the rfkil=
l
>=20
> minor nit: s/network/rfkill controller/

something like that maybe.

> > -Important terms for the rfkill subsystem:
> > -
> > -In order to avoid confusion, we avoid the term "switch" in rfkill when=
 it is
> > -referring to an electronic control circuit that enables or disables a
> > -transmitter.  We reserve it for the physical device a human manipulate=
s
> > -(which is an input device, by the way):
> > -
> > -rfkill switch:
> > -
> > -	A physical device a human manipulates.  Its state can be perceived by
> > -	the kernel either directly (through a GPIO pin, ACPI GPE) or by its
> > -	effect on a rfkill line of a wireless device.
> > -
> > -rfkill controller:
> > -
> > -	A hardware circuit that controls the state of a rfkill line, which a
> > -	kernel driver can interact with *to modify* that state (i.e. it has
> > -	either write-only or read/write access).
> > -
> > -rfkill line:
> > -
> > -	An input channel (hardware or software) of a wireless device, which
> > -	causes a wireless transmitter to stop emitting energy (BLOCK) when it
> > -	is active.  Point of view is extremely important here: rfkill lines a=
re
> > -	always seen from the PoV of a wireless device (and its driver).
> > -
> > -soft rfkill line/software rfkill line:
> > -
> > -	A rfkill line the wireless device driver can directly change the stat=
e
> > -	of.  Related to rfkill_state RFKILL_STATE_SOFT_BLOCKED.
> > -
> > -hard rfkill line/hardware rfkill line:
> > -
> > -	A rfkill line that works fully in hardware or firmware, and that cann=
ot
> > -	be overridden by the kernel driver.  The hardware device or the
> > -	firmware just exports its status to the driver, but it is read-only.
> > -	Related to rfkill_state RFKILL_STATE_HARD_BLOCKED.
>=20
> Are you sure you want to do away with the above definitions?
>=20
> The use of 'rfkill switch' for fundamentally different things caused a
> lot of confusion in the past.  That's why I had to come up with
> 'rfkill controller', and 'rfkill line'.   Maybe you can do away with
> the 'rfkill line' now, but controller/switch is something that is
> helpful to avoid getting input devices and non input devices mixed up.

This isn't actually helpful since the terms aren't very clearly used...

I think describing it as a "transmitter driver" is much better anyway.
And we don't need any sort of terms whether it's an rfkill line, or
whatever, it just doesn't matter -- all we need to know it's
hardware-off.

johannes

--=-A2us4ldByuGkQqiGXfUh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ0Tj6AAoJEKVg1VMiehFYjVoP/3ZM1aur15Vn0oQFZnIvXCZ5
Y5GsydIol/qGgvN/uxCUoU91M6mK6g9WuuW6gkXwb1jlTeBf1tMQWtaFwxgVnKdm
09nq9UC2B7O3O8Kon8yKJ189kq56KekcrbDRubVR/NWsrDKb1TcZxTgUPKnt6Sz5
eBz8Au2o0hvpfqalb/N5JoWUHWU+ku843RVAlnDSy9e6KX7ZqQdgL1JWDyymB6CD
30K1pwRw4y6nHTBwuRlaaDyXCep1+o/Kjqj9GDvvkTnWkQcE9AflaqsTsNrFgh5v
D+i5XxhJISSksLi0D4P8+XYF7G5V4tPJFSLjFnIGyf1TAcN4cSgY5C/yqfD+Is9N
1q5pnZSKhCjipH+EKZY3j6pdpEE0JLGvEbFTEOd8fDbC+8t8cTUkE8cbPZiEXsmL
m/4PpgGFcXutmT/snz6WxSJKN1lOCYvO1XyT1sWmESYlOVzVt1KQABjXhHCUFs0U
CVE6W1k791W+38Pfcr5ww/mNLI7VHtBW9Qqy9/GWtfQWpcLIRL1v6U1r4407t4mN
SuSFrPR3ZjX48aQp8Bz4FOYznw2ZuuksVNIg+c0/RVn+8kNqjLhOVC/5USHjILtD
BsPW3SruqEjxAlq9i4J6LcnVedCA23liR3bLxbmUZ1XujDW9Fur1n4rrC0mPEt8i
LtomQcf6XhYYvI1RYlny
=oa/7
-----END PGP SIGNATURE-----

--=-A2us4ldByuGkQqiGXfUh--

