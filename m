Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54666 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754432AbYJKA4w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Oct 2008 20:56:52 -0400
Subject: Re: [PATCH] mac80211: move bss_conf into vif
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1223686553.29811.30.camel@johannes.berg> (sfid-20081011_025559_406223_8B819614)
References: <1223682711.29811.7.camel@johannes.berg>
	 <1ba2fa240810101732y610b4cc8g1b914b2c8eb726e5@mail.gmail.com>
	 <1223685820.29811.23.camel@johannes.berg>
	 <1ba2fa240810101749k5d053451kdaef3194a954b442@mail.gmail.com>
	 (sfid-20081011_024943_373346_968487FF)  <1223686553.29811.30.camel@johannes.berg>
	 (sfid-20081011_025559_406223_8B819614)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-x/Z9uBpnWg5dufVvATI9"
Date: Sat, 11 Oct 2008 02:56:50 +0200
Message-Id: <1223686610.29811.33.camel@johannes.berg> (sfid-20081011_025654_954323_F510357D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-x/Z9uBpnWg5dufVvATI9
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2008-10-11 at 02:55 +0200, Johannes Berg wrote:

> > >> What protection should driver take to be sure it won't be changed un=
derneath ?
> > >> With prive copy you know this is changed only in bss_info changed is=
 called.
> > >
> > > Yeah, that's true, I guess you can only access those fields there tha=
t
> > > you can access atomically. That's actually most of the fields though.
> > >
> > > Also, we don't actually take care about locking this structure at all
> > > even in mac80211, something we might need to think about.
> >=20
> > When working on SM PS I have the  same dilemma I have with
> > ieee80211_conf do you think I need to take a private copy of it?
>=20
> Well, what do you use it for? If you absolutely rely on it having the
> same value, then you probably need to do that, but if you just use it
> then I don't see why you'd have to, unless it's some value that can't be
> read atomically.

Also, there's nothing really stopping it from changing while you're in
the ->config() call either.

johannes

--=-x/Z9uBpnWg5dufVvATI9
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI7/nOAAoJEKVg1VMiehFYwjIP/jEStkJJ1Yw22+S3lLkgD295
ZvGj0X+Uqs9PdcUggHMRZFGlIBQPTg7YlKOh562N5n/gUn/qj+TNdQDf/2ibB19t
T21KKwE3QLQ/Cg8yRrdNw+AAn3Wz5jTQgYDsnrNAEym5IxSVBjnLUaSdu2cdNS7I
6XdYQdqxyEaa55DPh4nfIDCGLI/HCgS1tsOmmuxxKDMfEiIzA65uNS5GqdTDtwDl
AkRh4+Q2yxMiwxvbaWU8NZwNmN187P+IPyI0w9FkdUWIAlOGGaLo2li8s4XiMkzN
BA+8qP0a+xa61552MLYTDwrVo1sBdWB6vKxXI89vChg+fCFfZrJhcBg7iL+vnaLF
ACCQ6npz8kY26ohyBO6+evKCybyO6ayw8IVgsycAlL9YNGYoiFelBT0afPl2VIQP
bxcBWtm2FjhyrJWzVLtOa40rQhr7Lax2tRxN5rmTTbgLXw3VZ1qPJgBmddbDdu1M
80hncSE1noQASLuT2OthJydxBwlGZ91K3rM+T9cfBM+YirNooNhsHN2+ZjOnNh0m
ldhh+6u9kwvbpmS7eWxi9HDgTBUVFb43aMl0yshUWxPhhTViGE8wNMCZb8jWwIqL
YjIwsETrCNrXsMsDL5iAdNpcg8AAFtBX6W+dPG2fD8xl7+DW92LN9tg5NXNka2tB
Ld84VaPZlCREit+ReE0o
=risC
-----END PGP SIGNATURE-----

--=-x/Z9uBpnWg5dufVvATI9--

