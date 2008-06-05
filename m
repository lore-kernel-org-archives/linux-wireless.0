Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:33974 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753462AbYFENRH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jun 2008 09:17:07 -0400
Subject: Re: [PATCH] rt2x00: Rename tx_info to info to help compat-wireless
	revert MQ support for older kernels
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linville@tuxdriver.com, Ivo van Doorn <ivdoorn@gmail.com>,
	Ron Rindjunsky <ron.rindjunsky@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20080605130734.GD17936@ruslug.rutgers.edu>
References: <20080605130734.GD17936@ruslug.rutgers.edu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-9d/wsGPoRA0NhK0j5fRH"
Date: Thu, 05 Jun 2008 15:16:03 +0200
Message-Id: <1212671763.698.11.camel@johannes.berg> (sfid-20080605_151710_912283_4055640C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-9d/wsGPoRA0NhK0j5fRH
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-06-05 at 09:07 -0400, Luis R. Rodriguez wrote:
> Rename tx_info to info as used by other drivers. This will help
> with CONFIG_NETDEVICES_MULTIQUEUE requirement for HT support support
> in compat-wireless by allowing us to map skb_get_queue_mapping(skb)
> to the old info->queue.
>=20
> An alternative is to maintain a large compat.diff which replaces all
> skb_get_queue_mapping(skb) calls back to info->queue but since this
> is the only driver which requires name change it seems worth it
> to help with maintenance.
>=20
> Compat-wireless shouldn't be a reason to accept patches in but if
> the changes are just cosmetic it seems worth the benefit.
>=20
> Signed-off-by: Luis R. Rodriguez <mcgrof@gmail.com>

That's just asking for trouble. If you really _must_ do magic in
skb_get_queue_mapping, do it directly:

int q =3D IEEE80211_SKB_CB(skb)->queue;

johannes

--=-9d/wsGPoRA0NhK0j5fRH
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASEfnEqVg1VMiehFYAQKPUg//SE4Zma9COUgNkpjJ8whhBcYcCatJ/P7o
nUYEHYaNSeN4xYWrHOq7R4qQ/WTIvivCmUgLbBQ4wkryE0H+p2Dsho4ApuWaO08V
Wv1o2b1qYYk7X9iAW6OsnDAJKhkaBsWtxAkgiPd6VBFweXnFXP0Sr9WcyTUZOBb0
idQVcmw6ushXF6r55CaxK9/+GSyi8l6y0LWas0r+z+R39ZB3+mW1J9cTOoSKJouD
EcB7rX21wFi87dZ6WxMIgWHWgz2P993VIQUqFoczdWGgDQzS9TGglu0ipvIYtezF
AB0mUk2rjG+KBgP/IcnyyHthNUoAGV8SF6tXzkh72pS2oHKUjRrUbzhEGsMWvMjR
z+Ku5XYAH5Uy8/nm2BTi9HC2iOgUMXAIu+//f22l2vbfeuX2yg5c5Wg8MloTatrP
ecGG9D0H/7shaCpyG+WYzeqIJGoXlU5VYCe8X4vTbutuJU+IarCr+zxfR3Y6DF/R
fTnxcp9xPFHPEJN+uPrkvScmybgx/tQ9jTnH72xk+qcmAEkuEJspn78OYKefZcO5
yCS8uESOI1SPFO3PZKTK46LdaDf5ylU+cx8/dgb5dJeQf7IzTmboAYdyTc2rAwuB
IpEKzVrlQqpZlY7tOz0MTIX0oEJ42PyfEYQ+LhOdVm81jmhIDzXvNStetlVeY4bY
ahVha2sND4Y=
=2KNk
-----END PGP SIGNATURE-----

--=-9d/wsGPoRA0NhK0j5fRH--

