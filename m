Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44062 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932239AbZHDGiD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Aug 2009 02:38:03 -0400
Subject: Re: [PATCH 4/5] mwl8k: prevent crash in ->configure_filter() if no
 interface was added
From: Johannes Berg <johannes@sipsolutions.net>
To: Lennert Buytenhek <buytenh@wantstofly.org>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	nico@cam.org
In-Reply-To: <20090803234651.GN18639@mail.wantstofly.org>
References: <20090803195857.GK18639@mail.wantstofly.org>
	 <1249329790.4561.3.camel@johannes.local>
	 <20090803234651.GN18639@mail.wantstofly.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-oQz+W8mQR8gvXKyRxkX1"
Date: Tue, 04 Aug 2009 08:37:27 +0200
Message-Id: <1249367847.4561.6.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-oQz+W8mQR8gvXKyRxkX1
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-08-04 at 01:46 +0200, Lennert Buytenhek wrote:
> On Mon, Aug 03, 2009 at 10:03:10PM +0200, Johannes Berg wrote:
>=20
> > >  	if (changed_flags & FIF_BCN_PRBRESP_PROMISC) {
> > >  		if (*total_flags & FIF_BCN_PRBRESP_PROMISC)
> > >  			rc =3D mwl8k_cmd_set_pre_scan(hw);
> > >  		else {
> > > -			mv_vif =3D MWL8K_VIF(priv->vif);
> > > -			rc =3D mwl8k_cmd_set_post_scan(hw, mv_vif->bssid);
> >=20
> > Btw, there are pre- and post-scan hooks now.
>=20
> These hardware commands are slightly misnamed -- they are called
> PRE_SCAN/POST_SCAN, but what they do is program the receive filter.
> It seems appropriate to keep that in ->configure_filter() ?

I guess it depends how they configure the filter. :)
If they really do the beacon/probe response filter thing then yes. For
b43, for instance, they also disable CFP updates etc. so aren't just
that. And you can get FIF_BCN_PRBRESP_PROMISC even while _not_ scanning,
due to monitor interfaces, so it really depends what they do (no CFP
disabling wanted then).

johannes

--=-oQz+W8mQR8gvXKyRxkX1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKd9ciAAoJEODzc/N7+QmanrsP/1fUBwh10JaF/Uksf/H2sSMy
eVPJZ0JvHx/Vto7tJelm/T61uWvvVyqQhKPzzJK+oId9RFFEVt5+dlZrR1LqzpE9
gxQsGysKhFxHCnMD7DDNe9GGVQ1Q1CrSwskGjCytCsYdUZ0Barglumj8fQG4P3ZC
1hMLO00iIaEUM+9q1LaTRO0o2FkcSIIj7nyAc8lw42ey3ncscwXSNjnpdLeiY6JZ
x/a6wrsnABVflS3XprNxp2uRWO5cSDDy8hqCZSe5Hb6o6AsjhGj2mSF8pniothMG
WyQ7JWmWOZnGJ5Asc0DUiayXdHkD+OmcRB8XlknhGjtjYMtDwuNIz18lKIrFJ801
lUQzXSjt1BICGiSRMUW3ZulGXsjG8jbzTzmGTtfHFhphwVJnkHmjE4I1lBbBaeAk
o1+hUAxuT+v+R//2xxpBra7sIezVvy5bJkb15m4p4RyO311IOUiDd5UkZFLNXVK3
1kM+pKT4Nx5amqj+tjxb7zrvhvHn2mS5pQ+ajfYgM2ZI/RH6+WEfSXSgisGcF6ys
DYRzVDhO2U2pd5nQw8+E7PrcV5uRWKP+CfOV7VHPzip0h4ehpvBkcO9Luo1hPY8u
LI/KoqaPYfNZrpTSDFrnN4Jf1H8UPXjjhJ/ljb9hpvnKFj8NyTWcdyUfdIMsY67N
MhfdRMVHb59L0uGMTEth
=WpZ2
-----END PGP SIGNATURE-----

--=-oQz+W8mQR8gvXKyRxkX1--

