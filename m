Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:33506 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760591AbXFEN5n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jun 2007 09:57:43 -0400
Subject: Re: nl80211 status? (implying cfg80211 status)
From: Johannes Berg <johannes@sipsolutions.net>
To: David Lamparter <lists@diac24.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1181040798.8274.10.camel@johannes.berg>
References: <20070604193034.GA16350@charon.n2.diac24.net>
	 <1181040798.8274.10.camel@johannes.berg>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-0qmkFoGrBrLxWLL0exkS"
Date: Tue, 05 Jun 2007 15:57:50 +0200
Message-Id: <1181051870.8274.17.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-0qmkFoGrBrLxWLL0exkS
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-06-05 at 12:53 +0200, Johannes Berg wrote:

> > As far as I understand, the first thing to tackle is converting
> > everything to cfg80211 and making wext call cfg80211 functions,
> > putting all the compatibility cruft into that layer while at it.
>=20
> I wouldn't necessarily start with that.

I should've elaborated here.

What I'd do if I had time now is add things to nl80211/cfg80211 and then
implement the calls in mac80211 (or a fullmac driver of your choice.)
Then write the appropriate userspace tool for testing and see if it
works, i.e. you can associate, do key operations etc. Use WEP for now,
and then maybe modify wpa_supplicant too for nl80211. Then, at some
point, you have wpa_supplicant working on mac80211 (or the driver). Then
in theory you don't need wext any more, and as an afterthought you can
still add wext compatibility so the deprecated wireless tools continue
to work.

johannes

--=-0qmkFoGrBrLxWLL0exkS
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGZWve/ETPhpq3jKURAlTaAKC3Pfs6OG8Ss+jC2NuVrdisca+ZdACgp5Kv
1PkxbnCX7wt+QbVyVZyQZ+0=
=GHvN
-----END PGP SIGNATURE-----

--=-0qmkFoGrBrLxWLL0exkS--

