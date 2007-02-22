Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:48913 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946015AbXBVOJy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Feb 2007 09:09:54 -0500
Subject: Re: [PATCH] d80211: Fix ieee80211_ptr check
From: Johannes Berg <johannes@sipsolutions.net>
To: Jiri Benc <jbenc@suse.cz>
Cc: Michael Wu <flamingice@sourmilk.net>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20070221190123.66606886@griffin.suse.cz>
References: <200702201813.58453.flamingice@sourmilk.net>
	 <20070221190123.66606886@griffin.suse.cz>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-AlGwjorAyDOFeCt/gtj+"
Date: Thu, 22 Feb 2007 15:06:18 +0100
Message-Id: <1172153178.5080.32.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-AlGwjorAyDOFeCt/gtj+
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-02-21 at 19:01 +0100, Jiri Benc wrote:
> On Tue, 20 Feb 2007 18:13:54 -0500, Michael Wu wrote:
> > dev->ieee80211_ptr can no longer be directly compared to check if a vir=
tual
> > interface belongs to a master device.
>=20
> Hm, apparently the regexp I tried when resolving conflicts with John's
> tree wasn't good enough to catch this :-(

No, that's an error I made.

> Let's hope there are no more such things left.

I doubt it. I should have remembered this special case but forgot about
it. The thing is that in earlier wiphy versions I had ieee80211_ptr
point to the wiphy directly so I *intentionally* kept the comparison
like that when reviewing all uses of ieee80211_ptr. When I realised that
we need per-netdev wireless state I put that behind ieee80211_ptr and
then forgot to update this spot.

johannes

--=-AlGwjorAyDOFeCt/gtj+
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF3aNa/ETPhpq3jKURAp3bAKCv/MYBd72cfQU66mf5zwKLbdJXFgCbBOW1
ZLX+5tG77r2IELB5lmBySUg=
=o+hp
-----END PGP SIGNATURE-----

--=-AlGwjorAyDOFeCt/gtj+--

