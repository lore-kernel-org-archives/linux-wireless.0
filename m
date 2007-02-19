Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:60294 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932152AbXBSGda (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Feb 2007 01:33:30 -0500
Subject: Re: [PATCH] d80211: fix incorrect hw.priv setting in  ieee80211_alloc_hw()
From: Johannes Berg <johannes@sipsolutions.net>
To: Pavel Roskin <proski@gnu.org>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1171835685.2201.4.camel@dv>
References: <20070217074208.348.69546.stgit@dv.roinet.com>
	 <1171707397.3487.5.camel@johannes.berg>  <1171835685.2201.4.camel@dv>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-wFRrtwZeoRfZXCKP7yO3"
Date: Mon, 19 Feb 2007 07:33:19 +0100
Message-Id: <1171866799.3471.1.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-wFRrtwZeoRfZXCKP7yO3
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2007-02-18 at 16:54 -0500, Pavel Roskin wrote:
> On Sat, 2007-02-17 at 11:16 +0100, Johannes Berg wrote:
> > On Sat, 2007-02-17 at 02:42 -0500, Pavel Roskin wrote:
> > > hw.priv is set twice, and the second time it's set incorrectly to an
> > > area relative to the master device, which wasn't allocated for privat=
e
> > > data.
> >=20
> > Yeah, this is obviously correct. Guess I was drinking when I did these
> > patches. I really wonder why I never saw any of your problems though, I
> > do have bcm43xx running here. Not that the driver actually does anythin=
g
> > for me, it always refuses to associate...
>=20
> Oh, and by the way, wouldn't it be reasonable to have an inline function
> to calculate the pointer to the priv area instead of having an actual
> field for the pointer?

Yeah, I guess that isn't too hard to do. But if you think about what the
current code will compile to that's also just an addition based on the
struct size that is known at compile time.

> Also, it looks like we need a generic macro for aligning sizes.

I hated wrapping my head around it so I just made the padding explicit
in the struct ;)

johannes

--=-wFRrtwZeoRfZXCKP7yO3
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF2USv/ETPhpq3jKURAvAJAJ0e2UGn3WTU4awold0zUEMmo0wRMACgliOQ
Il6yNkp7PqFxz5Fu9iORi4g=
=+y41
-----END PGP SIGNATURE-----

--=-wFRrtwZeoRfZXCKP7yO3--

