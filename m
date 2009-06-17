Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41958 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754461AbZFQWPa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Jun 2009 18:15:30 -0400
Subject: Re: [PATCH] wireless extensions: play with netns
From: Johannes Berg <johannes@sipsolutions.net>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: John Linville <linville@tuxdriver.com>,
	Netdev <netdev@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Eric W. Biederman" <ebiederm@aristanetworks.com>,
	Alexey Dobriyan <adobriyan@gmail.com>
In-Reply-To: <m1y6rqwpur.fsf@fess.ebiederm.org>
References: <1245263058.31588.38.camel@johannes.local>
	 <m1y6rqwpur.fsf@fess.ebiederm.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-u4KbMmBmHXOWUKtj1UXC"
Date: Thu, 18 Jun 2009 00:14:59 +0200
Message-Id: <1245276899.31588.57.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-u4KbMmBmHXOWUKtj1UXC
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-06-17 at 13:46 -0700, Eric W. Biederman wrote:
> Johannes Berg <johannes@sipsolutions.net> writes:
>=20
> > This makes wireless extensions netns aware.
> >
> > Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> > ---
> > Is this ok, or is this racy? I guess what I'm asking is -- will
> > for_each_net() stop iterating over a netns that is going away before th=
e
> > pernet exit op is called? If yes, this should be fine.
>=20
> for_each_net requires the rtnl_lock or the net_mutex to be safe.
> You aren't taking either so your code is racy.

So it looks like I can also use rcu_read_lock(), but there's no
for_each_net_rcu(), should there be?

johannes

--=-u4KbMmBmHXOWUKtj1UXC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKOWrgAAoJEODzc/N7+QmafsYP/2CLgeOFbLQhLLzOoVeF6je7
GN9/2w5Z20Dq8I8YsZY82r7qDrJd8fZyvjnw0ZqgmkZ0ebdYr2YSPqrNBnJr3CLm
1Abz5ddgVJ3T8P4EMqcZtfCjg/WoYDmbipjlAGCbWYFXGRcPf15qjrE71kkqPAKY
Rsy+0aSQ+27PJ7nPK/8GsSExpFmpSL/oiLELiZRwx7K1YAfE1IV3mkpwMaUXGoep
fo/srbkcwiaH+sESdOdRXkdXGj+08yFqn+BSBJSrYcFcryab0i1X47BJx1DUt51h
W7N0t5Jpb1lyVeOQtbMJ8OJ9YhMm0s40z08z2ie6R7nxmJeL2TGlQ+wYSCW5J+lk
vgPZ9fmW13xRjK0+Zm7quF4Lyb9ss4oAuDh/sVb1ro7WOb9mqmh0lrnJX9+P3pfQ
lpFrjt5d2s7nuE81u+sE131lwhROLBgsZ+XhZR3rrm/hr7dmMkTH9oD6czPoYI1r
6s2O2f8vT6qHf7ikvzbPVCrMQL+Z0N5JpllsOj/JSWNRD3jZO6p/HjJ5sIrGF6zz
cjx7up6Bkqe4z72hr3UHo8WKf6Zj7T3rrPvyp718W89q72IeGmTWw48BwgMsTf+q
Nm00//wwpnU/42ugdGHf6jAMOcBCGZAUZrfNdgHNQ54h7VCzqxd8yiE6l/S2des5
WvCfojdlyJmlqiR86M10
=HlDa
-----END PGP SIGNATURE-----

--=-u4KbMmBmHXOWUKtj1UXC--

