Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:53357 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755200AbXJOIqx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Oct 2007 04:46:53 -0400
Subject: Re: atheros hardware needs padding for QoS data
From: Johannes Berg <johannes@sipsolutions.net>
To: bruno randolf <bruno@thinktube.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200710151241.17651.bruno@thinktube.com>
References: <200710121946.30024.bruno@thinktube.com>
	 <1192190297.4770.48.camel@johannes.berg>
	 <1192194578.4770.55.camel@johannes.berg>
	 <200710151241.17651.bruno@thinktube.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-BtxuBGU23v1sXue04YjN"
Date: Mon, 15 Oct 2007 10:47:16 +0200
Message-Id: <1192438036.3349.16.camel@johannes.berg> (sfid-20071015_094657_680409_1FAA774B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-BtxuBGU23v1sXue04YjN
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-10-15 at 12:41 +0900, bruno randolf wrote:

> but isn't doing a memmove() quite inefficient? especially since we are de=
aling=20
> with QoS packets that might be important.

It's only ~20 bytes that are moved, should be within one cache line and
we touch the packet data anyway. I don't think it's a problem.

> another solution i thought of was signalling the mac80211 layer that we n=
eed=20
> padding which could then just adjust it's headerlen. but then different=20
> drivers might need different padding in different places (i don't know?).=
=20
> what do you think of this approach?

That could be worthwhile, though the headerlen calculation is called
very very often and adding another branch into it could very well impact
performance worse than doing the memmove.

johannes

--=-BtxuBGU23v1sXue04YjN
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARxMpE6Vg1VMiehFYAQLr0xAArAuErOvOBkxzlqpooKIxB3G8Ex8K3Agm
K5MGEx+Kh8lzKs3zuZ/WEu39zgOlquwcds0iT4nWcn+FWVWt3/6hXwdVvIMGuEi7
q7crJ9THYD9i+tOzO9XsrTPrqxijaDtr0rJ0EKaxa46v5WkeIp3kDVpG9MvfZOnF
ufro5aWTsQyvx5G1c1auB2rSqTQxGzVJTgb/TlMPZxjC2SB3SLM71zjwrgD02rBk
Eo89RYarT+k7G7hUC62uH1gtIYfK7rR3dyU9ZXMtz33wmxQVVIEraqnD0FvyZ2pb
6CLKTIVcaoL9gfvgrfzIWhXmhNV0jF09xPWepS5eKlRjqW5DajRl9NqO1ItudP8B
N1fwUX4c23kQ7kWXgPgkBMV8Fw4GX9yaTaQ6ErXr1TlG6Cq1ShKfRsfagnuSRYaU
m7yDxKRZq1Rh9hoXj4qx6d3LGGpdkB+GGLxIzCzEOdranNnXTxihIcXcnDDwF1YY
oUfd/Gq2+Cammu9bwwkBNmOM6+gAho3l6wNUTTKmh3JslXoMFoEDcjdvQ8zCzyWY
YoQdC5JUjNr+7Vh+W+HGq+PN6HVFoatxw3S0Z8ixctWAENyHCBKwJo08VT/tKkxM
MADfhnYoihczI9WJUXwCaAcKeaN7RKfykwiaAtGzy+Qy7Spjwyg+fiMZmuns1zeW
Mi/ZUV3kTbo=
=lujB
-----END PGP SIGNATURE-----

--=-BtxuBGU23v1sXue04YjN--

