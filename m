Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:47425 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752285AbZFBUft (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Jun 2009 16:35:49 -0400
Subject: Re: [PATCH] mac80211: check for existance sta before adding it
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1243974603-15058-1-git-send-email-lrodriguez@atheros.com>
References: <1243974603-15058-1-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-j3ktzlBnNTo5Y7ouN1Hd"
Date: Tue, 02 Jun 2009 22:35:47 +0200
Message-Id: <1243974947.7176.9.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-j3ktzlBnNTo5Y7ouN1Hd
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-06-02 at 16:30 -0400, Luis R. Rodriguez wrote:
> Lets just check for the STA before its addition through
> sta_info_insert() and make this mandatory. It simpifies
> code.
>=20
> In our mac80211 cfg80211 callback for device addition we
> also can simplify the code by first checking for the STA
> before trying to add it and then checking for -EEXIST which
> we were not doing. If that actualy would happen we could
> end up potentially with a stale sta and the rate info was
> never updated. We should now be updating accordingly.
>=20
> Since we are making part of the API to check for the STA
> prior to addition lets warn in sta_info_insert() if the
> sta does already exist instead of passing an -EEXIST.
>=20
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> ---
>=20
> johill, this is what I meant. Still not the right approach?

This may sound flippy, but you do need to understand RCU first. This is
simply not correct, even with rcu_read_lock() the sta info might be
unlinked from the list, your pointer will just point to something no
longer on the list.

johannes

--=-j3ktzlBnNTo5Y7ouN1Hd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKJY0fAAoJEODzc/N7+QmaLK8QAK6eBxFNFu0vUBU/IrrKI6nO
D4pgYS51KDSDx39lfhiPOBPPxYB0CHruAkeI5U8r4ctA9JfKcBZjtXYcZbK1rZlv
uUDKau8VfhIivKfqLhLzQQf5CY1ug00n74K6QnGrMxwBbgeFmaO8JR+3JBky8eoo
IaML90Cy4VRKQE1E2IiHjvYWAj6a5FEWqtPpfeZNd0s1+TVEmqUjxCIPjF11/dAG
TEI+i5/yd0mycBUyRbPbu964wTY/6U6tWohBlN3iqvKMuFcPFelpvvK2tvY68ooO
4E8NbO2ctvw8Z56T6NR/vIOE9Bk9DCRoHgdDID+Qz800AHwYRrXxSVM59SwxV9NZ
UryTgE5GWwiCjCRu7AxKlGWnM8LsXlIArnLGxIs79ffDTsQeK3xSfitfcBX1VpQ7
Cmwuf3x6BT0qsVyTJkwVhgOKiDeMhUokqRie6Z3o1JSrF01n2m4rGXAnMs1IERNG
4T6FX4cIWQx7yuUy8+JtJxqql7+oker4cVkwSEFQINJn/E4MQQwDdHeNnRnepWan
YBibhIZxdj+EGOzswamlgxn8i03uv91XrMAb7UnXxK9+9n/XXgl6ZpRsxvxa1G+2
ePAfBr7F+B9CpLVAdhiuYUHSoOq7CZxaqH90T9+Ysbg4gvuOoUx0HlUHso8Ojy7d
btq4SyQ03AUZ9wvIqiAn
=9h1E
-----END PGP SIGNATURE-----

--=-j3ktzlBnNTo5Y7ouN1Hd--

