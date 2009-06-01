Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:45039 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754741AbZFAMxj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Jun 2009 08:53:39 -0400
Subject: Re: [PATCH] rfkill: create useful userspace interface
From: Johannes Berg <johannes@sipsolutions.net>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
	Marcel Holtmann <marcel@holtmann.org>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20090601124931.GF11011@khazad-dum.debian.net>
References: <1243524688.10632.0.camel@johannes.local>
	 <9b2b86520905310213n7be56260lc0c2cf3c109fe065@mail.gmail.com>
	 <1243763887.19302.29.camel@johannes.local>
	 <1243796509.6570.35.camel@localhost.localdomain>
	 <1243841639.5299.8.camel@johannes.local> <4A238EA2.4040106@tuffmail.co.uk>
	 <20090601122839.GB11011@khazad-dum.debian.net>
	 <1243860230.5299.19.camel@johannes.local>
	 <20090601124931.GF11011@khazad-dum.debian.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-kXpMk90TuWQxODTgZHoo"
Date: Mon, 01 Jun 2009 14:53:33 +0200
Message-Id: <1243860813.5299.23.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-kXpMk90TuWQxODTgZHoo
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-06-01 at 09:49 -0300, Henrique de Moraes Holschuh wrote:
> On Mon, 01 Jun 2009, Johannes Berg wrote:
> > > Just don't expose a rfkill type until the first rfkill structure of t=
hat
> > > type gets registered.  THAT closes all holes in a sensible,
> > > principle-of-least-suprise way.  The current code (including the rewr=
ite)
> > > already deals with defaults and firmware-backed state storage just fi=
ne in
> > > that case.   All you need is a full interface that deals with global =
state
> > > hotplug (which ain't difficult, that's one or two more notifications =
only).
> >=20
> > Global state hotplug is just not really possible to support, and I don'=
t
>=20
> I used 'expose' for a reason.  You don't expose them to userspace until
> there is an user for that type.   You don't even have to hide it again af=
ter
> the last user gets unregistered...
>=20
> That's not hotplug as in 'create a new rfkill type for the kernel'.

I ... just don't understand what you're getting at. Are you talking
about /dev/rfkill with or without the add-on I just sent a while ago?

> > think even your original code supported that, since it cannot affect
> > previously registered rfkill instances. You definitely don't want to
> > hotplug a wireless device and turn off all others "due to that".
>=20
> You do recall how the 'override system default' machinery worked?  It wou=
ld
> return an error if a rfkill struct of that type had already been register=
ed,
> or if a call to set the default for that particular rfkill type had alrea=
dy
> happened.

Exactly. It never touched older devices, and ignored (well, it returned
an error, but that was quite pointless) future attempts to set the
default.

johannes

--=-kXpMk90TuWQxODTgZHoo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKI89EAAoJEODzc/N7+QmayKgQAJmZfb0PCHEdDKbNsL18FxfF
fc/irn33n+4s1QrSETNr3vkr1ETitiWbXfXpDOvtmGmwiRfhng+F+hO7e4KB+Mx4
30NXTvSC5sDMYCKIwhqBa5afCj+SZ4fOkFWGvAOJ6S6pbdPwjJQSBBLUX7qQ92uA
AL1S+iLODXOF0UJr6Y35ukqgM7py9iTc5fhh3gRlt/84gaYvTLv7dB/4LWmIZaA1
76/Z7Noy7asMraYgHsq+cagsHtJxDxCNU1E79F18NHV5pSmYmnK92tdhLs/xxRzU
PHVHxV+k0Je8WxggGheFx9VOcadmFTHSAl8PXQSH2BX8uht88IGnahj2H/wJ90ra
Dcn6uTxOW4SBwbxSLxjuK1AHtmhqKsTC8V3NkGcumHX1F4bfetQlVnM/Sv/pZ0jb
JZo9X6/jOdpe1hTQ2AWckEf6TnDtlHnqYpYMIVcjPTVaSVJ8sD5wSxIFZU67C45U
ev9whxUyeEyn4S3lPGNgRoAaMJnVdqlFSv5amLs4KtECxpILf2GoDneDipjdtETj
EpGAdVwCI4PctK3OTFN3WERtG8cOQB56zZ74zmkwFZxpmsOhDLxcF+xOG08kW4WH
90/wJnYevAY+f0GrY2PC3ixSE8mBOAoQJVgpR+C3nD/g18pL8A+Qc1eobDC9Zq4K
ZUmf+hzQkYPdYpkDGga3
=P5Gm
-----END PGP SIGNATURE-----

--=-kXpMk90TuWQxODTgZHoo--

