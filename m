Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:58102 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762190AbXIKKQR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Sep 2007 06:16:17 -0400
Subject: Re: Kernel panic with rt2500pci built-in
From: Johannes Berg <johannes@sipsolutions.net>
To: Rob Hussey <robjhussey@gmail.com>
Cc: Ivo van Doorn <ivdoorn@gmail.com>, linux-wireless@vger.kernel.org
In-Reply-To: <6b8cef970709101425q42d8ceb3mc0e7a103aad45f66@mail.gmail.com>
References: <6b8cef970709052006q43d5602ewde0cea45500deede@mail.gmail.com>
	 <1189244217.4506.16.camel@johannes.berg>
	 <6b8cef970709080857s69c055f2s1bc1ce6bd0ad4dfd@mail.gmail.com>
	 <200709081816.10143.IvDoorn@gmail.com>
	 <6b8cef970709080939v42e88426n40b68a3aa85a951f@mail.gmail.com>
	 <1189420297.4506.26.camel@johannes.berg>
	 <1189422311.4506.52.camel@johannes.berg>
	 <6b8cef970709101340y77264f86s535384414b68c6f2@mail.gmail.com>
	 <6b8cef970709101425q42d8ceb3mc0e7a103aad45f66@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-nYicoW3lrhBxevV8rXM6"
Date: Tue, 11 Sep 2007 12:17:46 +0200
Message-Id: <1189505866.6161.2.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-nYicoW3lrhBxevV8rXM6
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-09-10 at 17:25 -0400, Rob Hussey wrote:
> On 9/10/07, Rob Hussey <robjhussey@gmail.com> wrote:
> > I had to change the module_init() to subsys_initcall() in ieee80211.c
> > and rc80211_simple.c, as well as the original change in
> > net/wireless/core.c.
>=20
> After more testing, it seems to also work just as well if ieee80211.c
> is left with the module_init() and both rc80211_simple.c and
> net/wireless/core.c are switched to subsys_initcall().

Yeah, but that might leave mac80211 in a bit of a messy state, we really
should make sure that it is initialised before devices are registered on
it.

johannes

--=-nYicoW3lrhBxevV8rXM6
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG5mtK/ETPhpq3jKURAniAAKC4p4fSFhay4X32HNN7Hf6FJjw8qwCgp4s7
46q56/NdUeMXOYH7Ef9Zi2Q=
=OngG
-----END PGP SIGNATURE-----

--=-nYicoW3lrhBxevV8rXM6--

