Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:56702 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753233AbXGJM5b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jul 2007 08:57:31 -0400
Subject: Re: Permissions down /sys
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: Andy Green <andy@warmcat.com>, linux-wireless@vger.kernel.org
In-Reply-To: <200707092257.25909.mb@bu3sch.de>
References: <469297DF.4000806@warmcat.com> <200707092257.25909.mb@bu3sch.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-pbn+9t+w9WL+CeQTzY4C"
Date: Tue, 10 Jul 2007 14:57:49 +0200
Message-Id: <1184072269.15565.8.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-pbn+9t+w9WL+CeQTzY4C
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-07-09 at 22:57 +0200, Michael Buesch wrote:
> On Monday 09 July 2007 22:17:35 Andy Green wrote:
> > Hi folks -
> >=20
> > Is 222 permissions on /sys/class/ieee80211/phy*/add_iface and
> > remove_iface really okay, or should it perhaps be 220?
> >=20
> > --w--w--w- 1 root root    0 2007-07-09 21:11 add_iface
> > --w--w--w- 1 root root 4096 2007-07-09 21:12 remove_iface
>=20
> IMO the file-permissions are correct, _but_ the following should
> be added to _store_remove_iface() and _store_add_iface():
>=20
> 	if (!capable(CAP_NET_ADMIN))
> 		return -EPERM;

Uh huh, yes, of course. Do you have a patch?

johannes

--=-pbn+9t+w9WL+CeQTzY4C
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGk4JN/ETPhpq3jKURAnxRAJ9G79HFAAMpl8GdY8nLfGF3WqBfoQCffn0i
hlB1ty6tMK/uCwZ5EpenEOQ=
=Vgxv
-----END PGP SIGNATURE-----

--=-pbn+9t+w9WL+CeQTzY4C--

