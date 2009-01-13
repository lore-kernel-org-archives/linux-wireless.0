Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44168 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756850AbZAMN4S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jan 2009 08:56:18 -0500
Subject: Re: [PATCH] nl80211: New command for adding extra IE(s) into
	management frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20090113134948.GA16694@jm.kir.nu>
References: <20090113115128.GA11245@jm.kir.nu>
	 <1231853937.3671.28.camel@johannes>  <20090113134948.GA16694@jm.kir.nu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-LEzv+0g3KTW/I07y/atd"
Date: Tue, 13 Jan 2009 14:55:47 +0100
Message-Id: <1231854947.3671.33.camel@johannes> (sfid-20090113_145624_771377_8DB4528B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-LEzv+0g3KTW/I07y/atd
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-01-13 at 15:49 +0200, Jouni Malinen wrote:
> On Tue, Jan 13, 2009 at 02:38:57PM +0100, Johannes Berg wrote:
>=20
> > kmemdup? Might also make sense to not try the allocation if we're going
> > to refuse it anyway, but that might be complicated to do and probably
> > doesn't matter.
>=20
> I did not know there is such a thing as kmemdup (apparently not that
> many other people, either, taken into account it is not used anywhere in
> the generic wireless code). Anyway, yes, it would work here.

Heh. Yeah, I think it's a fairly recent addition to the API, maybe two
years old or so.

> Moving the allocation to be done for each subtype separately would add
> quite a bit of extra code and error paths. Doing it once resulted in
> simpler implementation. The array version was much simpler on this area,
> but with separate variables for each subtype, I think it is better to
> just allocate (and deal with NULL) once even if we will immediately
> after this need to free the buffer in the case the request is going to
> be refused.

Good point. The only other solution I could come up with was having
set_mgmt_extra_ie_sta return a u8 ** and size_t * that are assigned, but
that seems too ugly.

johannes

--=-LEzv+0g3KTW/I07y/atd
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJbJ1gAAoJEKVg1VMiehFYiNEQALfNosZII9+NO28QZlhXaupa
ePLMowp7seO9sKy2sBvwRrJzF2AEtMVspMr8rTNOtWAadxrx3sSa0xG699pFa17S
pCEyT99hsgj8fpakY6KCTJvaBmBiMnxDMkK36gwpzYrF6cSfI8c1eCkWKjSNGUpv
5TscVf72eR1edsqGLXA+7CR8Pu5TBNYf0/wgw/3IyaCXjzYVoDxqSXVgsBCsbCLp
U6h1VZVOLb9bHDjXEfrboidWWSmYAfFIs5QQFjefxhPo1OryNJxBylq6s+n/W7NK
xQWh8XJzB7qropGsP2vAYo8APussLgjI09doJ0BiN2WEW8BjU7lNvNS8mgvL3Up6
8oMa7qzQKO+EuGAzafKpH8HW6lU+pg6aDBAyXcrSTMc5G9VDLHVkne5hc62HMhUY
ul1wVhfWNpEEi6w2OBYeZq7eMt8OyP4eapu9/601TqXZmJEaIhunO04ZBpt8Zl+6
+QSuIR2kyvDyIh7OfDMOJ4vxMLu7uW58fHQKBLxgYVKynOGswl/dfZJe+JbIHs/H
zwgzBZfuUz5tx51t5jxsp/2K2yqhujEpcsYpWdle95sMMUWD7WSOnWWBbDLfjMLt
oQgtaekhpchtUILkKwhj6U0JDuwY4gg6qeLAFqM1/RHHH0FPvFG4ER0up78S8iZ6
QxlupcR+4qRBJlYx4TvW
=jj9E
-----END PGP SIGNATURE-----

--=-LEzv+0g3KTW/I07y/atd--

