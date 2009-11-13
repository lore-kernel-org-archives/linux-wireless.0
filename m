Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56781 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754633AbZKMHGg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Nov 2009 02:06:36 -0500
Subject: Re: [ath9k-devel] Possible memory leak in ath9k monitor mode
 injection
From: Johannes Berg <johannes@sipsolutions.net>
To: Matteo Croce <technoboy85@gmail.com>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <40101cc30911121504v7503fbf2wca99b2d6af4fb980@mail.gmail.com>
References: <f74418680911120331w1ea31a68y56440dc0fbd253bb@mail.gmail.com>
	 <40101cc30911120618m5d9acd34pf6aa9ec89c6c40b8@mail.gmail.com>
	 <20091112154440.GD19349@tux>
	 <43e72e890911120749n72360f0btfb058ab3a521eabb@mail.gmail.com>
	 <40101cc30911121118h17db32a1y61edac1a4c0aec24@mail.gmail.com>
	 <1258054304.3899.36.camel@johannes.local>
	 <43e72e890911121135v150e33cbwcaa284ba998d2656@mail.gmail.com>
	 <40101cc30911121416o333f32c1h3e26b4cc988c243f@mail.gmail.com>
	 <20091112222831.GC17000@tux>
	 <40101cc30911121504v7503fbf2wca99b2d6af4fb980@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-BY2tcqprQ1OhfecHf97/"
Date: Fri, 13 Nov 2009 08:06:37 +0100
Message-ID: <1258095997.3899.64.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-BY2tcqprQ1OhfecHf97/
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-11-13 at 00:04 +0100, Matteo Croce wrote:

> >> root@alix:/sys/kernel/debug# cat kmemleak
> >> unreferenced object 0xccd48e70 (size 64):
> >
> > What's 0xccd48e70 and friends? Can you enable debugging on your kernel?
> >
> >  Luis
> >
>=20
> I've built a monolithic kernel, no luck:
>=20
> (gdb) l *0xcee26a80
> No source file for address 0xcee26a80.

Not surprising at all since that's a kmalloc'ed object, not a .text
address ...

johannes

--=-BY2tcqprQ1OhfecHf97/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK/QV5AAoJEODzc/N7+QmavbIP/AidGUgfJk/m/43HUTIoSVmy
uY13vSIDw7pbkab2izMO/VvTm2DfJDL1dgj4pdCSOWnKZOVvvntlDtuhlyYeObdn
LRxuIuH1/P0/uVexq5x5LknxEY3BZhc8pLqWLgOCEQqxhJ3Q8UlYzD25T3u07asr
CJwb4PHEWDymFMkdw07p+LcD5tH89BvKdzY7l5f9uf5oPLS8Q47/cVLZOJAPIMsO
FueB6IhWVU2ClkaEUZv1gpPUc/7A5k9gQ/kdl0vcaQZpyP4Ycbsr0VokerGZpF0a
rE9LLbJJxhZZEsaFsneqalVyKTIV29YLRcAsY0iXTLav1htrk70YStEui6KVFTtA
uASqLuhPKos6dDkVniQHJwb2JclY/rZpvIQuBJ1TeEGsYooduknTgS7/1A8UN3bK
iDOXGBljaD+15ZNPuy0yD1++cfqTE44jUR0UeS9IgWI0BR2gXsEsb+89j1HaD7/6
TP6ApabUUwETYRCI8hV3LuHGuHcfmV0CBli+fVmLiiHuvVCRhcSCLtpy4kfrur71
vDHX7pnQKpARR5xJktNgjaEevFEEAti8WhRHGMqyMxSoDBlUWSvgxy0dyaswvZPa
opagOsrzTs1yVBtioUJSkhzEdVPaTnurNcbC2UD5mwBTVW08noAk06uxKBq4j8Af
+enzxoDNbfGXTLGStpwW
=e6sC
-----END PGP SIGNATURE-----

--=-BY2tcqprQ1OhfecHf97/--

