Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:33128 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752480AbXIAJyY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Sep 2007 05:54:24 -0400
Subject: Re: radiotap injection bugs & extending it
From: Johannes Berg <johannes@sipsolutions.net>
To: Andy Green <andy@warmcat.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>
In-Reply-To: <46D9353C.2080509@warmcat.com>
References: <1188609135.7585.105.camel@johannes.berg>
	 <46D92A1C.4050308@warmcat.com> <1188637615.7585.118.camel@johannes.berg>
	 <46D92EFC.2060007@warmcat.com> <1188639380.7585.130.camel@johannes.berg>
	 <46D9353C.2080509@warmcat.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-PHG4lOplwXwhYKAfshvT"
Date: Sat, 01 Sep 2007 11:55:43 +0200
Message-Id: <1188640543.7585.133.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-PHG4lOplwXwhYKAfshvT
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2007-09-01 at 10:47 +0100, Andy Green wrote:

> > Well, for one, the PS code is only relevant if we're ourselves operatin=
g
> > in IBSS or AP mode. If we're operating in AP/IBSS mode we'll also
> > automatically buffer your injected multicast frames for after the DTIM
> > beacon. I think we should just buffer injected unicast frames as well,
> > it won't hurt your use case (multicast destination) and makes things
> > more consistent.
>=20
> Fine by me.

Good. I'll look at it later or next week.

> There are other problems hiding somewhere, perhaps iwl3945, as well.
> Having a secondary network interface like mon0 in Monitor mode is still
> not quite the same as having the primary network interface in Monitor mod=
e.

Definitely iwlwifi. Might be caused by going into power management mode
though, not much you can do about it then. But that reminds me of
something I need to check.

johannes

--=-PHG4lOplwXwhYKAfshvT
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG2Tcf/ETPhpq3jKURAgGfAJ9zm44hlP80vXoj1SNL1v6uR1DsmQCgjiG3
GzFxNiJE6ojxi0gTuUg+WM8=
=qren
-----END PGP SIGNATURE-----

--=-PHG4lOplwXwhYKAfshvT--

