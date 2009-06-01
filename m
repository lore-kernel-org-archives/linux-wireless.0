Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:33304 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753993AbZFAMn4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Jun 2009 08:43:56 -0400
Subject: Re: [PATCH] rfkill: create useful userspace interface
From: Johannes Berg <johannes@sipsolutions.net>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
	Marcel Holtmann <marcel@holtmann.org>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20090601122839.GB11011@khazad-dum.debian.net>
References: <1243524688.10632.0.camel@johannes.local>
	 <9b2b86520905310213n7be56260lc0c2cf3c109fe065@mail.gmail.com>
	 <1243763887.19302.29.camel@johannes.local>
	 <1243796509.6570.35.camel@localhost.localdomain>
	 <1243841639.5299.8.camel@johannes.local> <4A238EA2.4040106@tuffmail.co.uk>
	 <20090601122839.GB11011@khazad-dum.debian.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-0I/LW4+d3zT0WUHKnY/u"
Date: Mon, 01 Jun 2009 14:43:50 +0200
Message-Id: <1243860230.5299.19.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-0I/LW4+d3zT0WUHKnY/u
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-06-01 at 09:28 -0300, Henrique de Moraes Holschuh wrote:

> It can have default values just fine.  And you can't wait for userspace o=
r
> platform drivers to register a default, it just doesn't work, you cannot
> expect that all relevant drivers are loaded before "rfkilld".
>=20
> Just don't expose a rfkill type until the first rfkill structure of that
> type gets registered.  THAT closes all holes in a sensible,
> principle-of-least-suprise way.  The current code (including the rewrite)
> already deals with defaults and firmware-backed state storage just fine i=
n
> that case.   All you need is a full interface that deals with global stat=
e
> hotplug (which ain't difficult, that's one or two more notifications only=
).

Global state hotplug is just not really possible to support, and I don't
think even your original code supported that, since it cannot affect
previously registered rfkill instances. You definitely don't want to
hotplug a wireless device and turn off all others "due to that".

johannes

--=-0I/LW4+d3zT0WUHKnY/u
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKI80CAAoJEODzc/N7+Qma/JYQALpXty3lWuiu5LXp5lS0oZcS
UmI5PhaEEg+RDoo09qQO9teJrRBMS2Lv/9QaTKz1y8Qj9lieF557mI1VeyduV1Sr
IRZ/QSwGNpaNIQeu/qFp1bC7rIlSnjqKxOx4rhL7UBaBxtLhB7EQZ0PaaHqi65rD
ceqfIEePC9Urt8CfK599Ktv3M5Xwi9W41aiJESQvNohD61hjJqXj4aavUs8LtxPr
EvmwPO9ZcSPm0dBKmFO/mNASnZwfKPbQvFIbdoUCdVG0EPpq4EhY6sr1qhyTZjSf
xZ2OUnzSpwi+tZtVeVdldxzCAumix0OJKNUS8mSaOic2mReIFWgkkVAwbtEoEtB9
idl+nwaHKjeG4aY+iuV3CTIlIR0HWzPG0mNjTCXIQtVmfdcwI/KJiTM75pSgrdBS
N/gbpVPe0IFStHrEX/7KT6ctBcyyUZkJMu9JIC/nbwxbVkzNSiUkG70orYS4E0lK
cNkWpbhUJ/wgGx2S44UMz1af2Q/uODhgm3XNbvSEEVgYWhq/77Girykh/N6l73aW
G2RqwQ8dlayLCEbUFtR84Pf3iRQw/Xe/aF23ZQ+PLnV48CfSXTkpcpmk/PXXTC9y
KASj9Fr1SFjLfuCTgdtWL+zVw1Xqtbpn+BNyGwTKix+E0lhF1Q0Zxn93xVwPJ6P/
YszEiZIk0Y9G85GmfNTN
=JTB6
-----END PGP SIGNATURE-----

--=-0I/LW4+d3zT0WUHKnY/u--

