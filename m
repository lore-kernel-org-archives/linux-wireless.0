Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56748 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754162AbYJKAyE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Oct 2008 20:54:04 -0400
Subject: Re: [PATCH] mac80211: Fix scan RX processing oops
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20081011004828.GB15802@jm.kir.nu>
References: <20081011002955.GA15802@jm.kir.nu>
	 <1223685486.29811.17.camel@johannes.berg>
	 <20081011004828.GB15802@jm.kir.nu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-C1x0IkHFyVQrb17XYltr"
Date: Sat, 11 Oct 2008 02:53:58 +0200
Message-Id: <1223686439.29811.27.camel@johannes.berg> (sfid-20081011_025408_896462_89BF6EBB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-C1x0IkHFyVQrb17XYltr
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2008-10-11 at 03:48 +0300, Jouni Malinen wrote:
> On Sat, Oct 11, 2008 at 02:38:06AM +0200, Johannes Berg wrote:
> > > -	ieee80211_rx_bss_put(sdata->local, bss);
> > > +	if (bss)
> > > +		ieee80211_rx_bss_put(sdata->local, bss);
> >=20
> > I keep falling into that trap, maybe the put function should just handl=
e
> > NULL instead...
>=20
> I though about that for half a second or so ;-) and ended up doing this
> instead after checking that other ieee80211_rx_bss_put() calls were only
> passing in non-NULL values. Anyway, I would be fine with _put() being
> able to handle NULL, too.

I looked at it before and for some reason decided against it too. Let's
stick to this patch, I'll re-evaluate making it handle NULL.

> PS.
>=20
> I don't know what exactly was triggering this oops (or well, what was
> triggering ieee80211_bss_info_update() to return NULL to be more exact),
> but it was happening very consistently in our office (but not anywhere
> else I've been this week).

Strange. You probably have a mesh network with bogus mesh config or mesh
ID IEs, I can't see the allocation fail consistently in your office ;)

> It was kind of funny to see that oops at the
> very moment when I was convincing people in a meeting that we can change
> mac80211 and should do so if it is the best location for something and
> makes it easier to implement something in a driver.. ;-)

Ouch, sorry :)

johannes

--=-C1x0IkHFyVQrb17XYltr
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI7/kjAAoJEKVg1VMiehFYCygP/0huZeepKQA1jG6o5V4Q0cRO
xQo5RAggnb3fkpa+ssGWpmwHFj0GLbVoXkuciq+Lnxqiuogfvxsk2cGr+iNP2LCY
T67em6LZlBKNX3tfaWkGxLZryw4oqcYbMbVon7+/OBUqy+gyC8j13V6xbGwWWvOh
qBqrlma6qhCu0biYTIskA8lwtuuJKcQ1BjaaAa/YeeHWQk+2G08aOvxfpv6sX6uH
K88xwWkbQht0xXvtq7mgZkGEIW6ypOBAwxlO+f8xJ7t2r5lmY6EszBCUNhcMKj61
Md+4xHQ6W7YkbzIzjOz2V8zYXGJ8AaVZ9qMGT8T2AWC96MkZteIrcyTEVrxPwpDX
a67+CMXmYKOibxlfI5+3/lULK2h0xjBMSLs8az2tziwqYCZ77Be4cvxWUySnltfh
ed+tJvI8wOaj0R8ITbsE2AOCFiR8SbGEYG/Rllr9alDKBymwEaUy8hW/k4Xo3+Vd
DZxjIRS/MB/gPwE8KQUr/IZCWqhusXpBDd0GPNjxOsk0YycS1r2Jxuujm098BC3d
3XQDO7A3tANjDZUNXgHXFPUAPFZsc/wTp0cXN0TG8U+kZh2fEr+T/RFt3BCbbc9n
yhR0sXhjrM2gDC+p+e0YwjOHxmWkdGRTM8mvADoCBNPMp/e3mZK12c/A696Nj/Zf
ZcmGeNq/Ku492FWq/ls8
=P9HO
-----END PGP SIGNATURE-----

--=-C1x0IkHFyVQrb17XYltr--

