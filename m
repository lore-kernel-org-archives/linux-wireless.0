Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60964 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752258AbYKCHY7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Nov 2008 02:24:59 -0500
Subject: Re: Alignment issue with 4965 and 2.6.28-rc3
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <DFAA4A8C-F8D5-4D08-9C6E-8BB65E3BCFC2@holtmann.org> (sfid-20081103_011401_708646_769D4445)
References: <DFAA4A8C-F8D5-4D08-9C6E-8BB65E3BCFC2@holtmann.org>
	 (sfid-20081103_011401_708646_769D4445)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-W3QWfvFM0t4eunBFSZ+r"
Date: Mon, 03 Nov 2008 08:25:00 +0100
Message-Id: <1225697100.3619.21.camel@johannes.berg> (sfid-20081103_082504_093330_83392DAE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-W3QWfvFM0t4eunBFSZ+r
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-11-03 at 01:13 +0100, Marcel Holtmann wrote:
> Hi guys,
>=20
> so I switched to a 2.6.28-rc3 kernel and after less then 10 minutes =20
> uptime my dmesg is full of warnings. I enabled a bunch of debugging =20
> options and the first warning that I see is the alignment warning from =20
> mac80211. I have kerneloops enabled and all warnings are posted there. =20
> For reference I attach my full dmesg and config.

You can ignore the alignment warning, it's been decided that Intel
driver/firmware/hw will not work properly on platforms that cannot do
unaligned loads efficiently. I've tried sending a patch to add
CONFIG_HAVE_EFFICIENT_ALIGNED_ACCESS or something like that so that we
can fix it up if that is unset or make the driver depend on it, but it
hasn't stuck so far, so for now, ignore the warning and don't try to use
Intel wireless hw on platforms that don't like unaligned loads.

johannes

--=-W3QWfvFM0t4eunBFSZ+r
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJDqdJAAoJEKVg1VMiehFYMZUQAIcPpIekA/pqFbC+9oaeq6uB
LIWzRm1BuozroPS+nIQov15HnSdXUGWjA/q0aNhjGGcgiIRznQo6qo3TdAf/JJtn
dXlqldT3XkwsxxVE/TdMBH+augyyd5I1rhNhWtmV3GpMwN+m7iaba/mFmL8Ny2tk
CPCxc/8rmmClHOk/BJfPUK8hvuPXALYKzE+KSmPyFndJPUK4pg9h/OlLxmKJjUAp
AhI9DRQ4Ysr3E/ZI88r9PpZJI00m2C0mXRMnxugAS5T/DpdoZObc9aquKawcOWpF
Spvz/5sM/hXgKJDm7n1Ej3AprfedASMr4XReKcGPvIr37KxFoV4/KmkRpSMDO4hM
6ipQnek+OMDUE76PIZbZrmeTPySjYs+JaHRnua4j5nlGrbGNwEBQCZRXlak3bMLj
1xe/vmfWTYpSTDyZ0ECGTXwtgtTnscFMlrB2T2hlfXCn3kY3LhpbD7D+95cqyKFD
HPw30RBLFCW7ZKm+YEy7iowpyXoYckH1HtL1/iEDWYmCA8b6mLVEtVQa6lcEj4Sj
vKr4Pj1f8i41nFaWLrjPszB0yWbeFz6R0T0f9WsSBQHcKwf3TI7LcCawefOed1qs
td+3HLtGYhr2JaYMKGrpDmS/hcFWY4Lg8ZPaC3YMkEBwRM4Mqo6IFJsyDCHtYMC+
J+27fLwDqsTHGvm7Mo1f
=lwAS
-----END PGP SIGNATURE-----

--=-W3QWfvFM0t4eunBFSZ+r--

