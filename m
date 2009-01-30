Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48796 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368AbZA3L1U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jan 2009 06:27:20 -0500
Subject: Re: [PATCH] mac80211: convert to net_device_ops
From: Johannes Berg <johannes@sipsolutions.net>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: linux-wireless@vger.kernel.org, Kalle Valo <kalle.valo@nokia.com>
In-Reply-To: <1233314257.30970.6.camel@johannes.local> (sfid-20090130_121747_128792_58F3B8C4)
References: <20090127052926.44d3fd5f@s6510>
	 <1233314257.30970.6.camel@johannes.local>
	 (sfid-20090130_121747_128792_58F3B8C4)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-FWBgDkt2DMP7CD7Uz42W"
Date: Fri, 30 Jan 2009 12:27:17 +0100
Message-Id: <1233314837.30970.8.camel@johannes.local> (sfid-20090130_122724_511882_CAD8D802)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-FWBgDkt2DMP7CD7Uz42W
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-01-30 at 12:17 +0100, Johannes Berg wrote:
> On Tue, 2009-01-27 at 05:29 +1100, Stephen Hemminger wrote:
> > Convert to new net_device_ops in 2.6.28 and later.
> >=20
> > Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
>=20
> John, please revert this commit for now, it's breaking monitor mode
> injection (and thus AP mode) because the xmit handler assignment in
> ieee80211_setup_sdata is not effective.

This also broke calling our uninit function so we have memory and
debugfs file leaks.

johannes

--=-FWBgDkt2DMP7CD7Uz42W
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJguQTAAoJEKVg1VMiehFYdawQALn21ySHBKUG6GOhPKBeJpXN
Ulu5M9+Lt4WQvTGgMhywgP4yBe66lnRv0a/6XNQwWc4uZ+izrlR1Eil43Gah1jjO
6hoVqvPHxx+sK1sEiPPY8MG+bxx9aqfgsWZp+fRzyayrjnXsojOgVUZRYjgrkgqN
1CFpys5uxfJoGDFy8OXskSjm+0CqlVTDrHgeC/L/z1+4SJxvO8yxa0KB3uo8Wh6G
P+VpKqHYmhJVacJRGsswXg2NJ79dGoeJt0ykL8F0rVszFLVkMALmzAwJap7YSCoA
nXDKw5Pp4VTEV8WkgYbTIqsuH+fZqUfM7wOo/K3WDXiuiseMAXjUi3mab4zaApwa
Us9qBQlIC1heN1ZEUTOVlkvqpsM48WxkWNS6jIhv4l2GWXV+rS2cwAAQRuBcOwGQ
QSmDxUE/ncXwxx94nrbLaS48bzOdhD+VxlhAJlDBgEwE0UqMdGSZ/JOTDA5F6B74
gCM+34WVqLUYL0OUjNFJ+vNjHa+kzWwUgDLftvuPErE4d5RmxqpFXCI8NIPHgq1b
W9IwFQJwWvlKC8roFbj60poXGEzn4dOZXwkG+rlNkFte1RpKbvKZ+cJaqs7ax+mF
kEpj7l2owQoba2GFGPbrMl2YIf5cxU4qhM+duMib/uNukMLRq1+TsHNkjLcA/g+c
0dHhD8KND+x9zzUnbkPY
=n6tB
-----END PGP SIGNATURE-----

--=-FWBgDkt2DMP7CD7Uz42W--

