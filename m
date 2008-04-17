Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:59631 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755124AbYDQQzM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Apr 2008 12:55:12 -0400
Subject: Re: [PATCH v2] mac80211: Replace ieee80211_tx_control->key_idx
	with ieee80211_key_conf
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
	Michael Buesch <mb@bu3sch.de>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Zhu Yi <yi.zhu@intel.com>
In-Reply-To: <200804171759.54830.IvDoorn@gmail.com> (sfid-20080417_165522_787079_BA83CC8B)
References: <200804171728.30188.IvDoorn@gmail.com>
	 <200804171759.54830.IvDoorn@gmail.com>
	 (sfid-20080417_165522_787079_BA83CC8B)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ZrdHkrg7MonMHX3aop/v"
Date: Thu, 17 Apr 2008 18:54:53 +0200
Message-Id: <1208451294.4066.23.camel@johannes.berg> (sfid-20080417_175531_969633_B3919879)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ZrdHkrg7MonMHX3aop/v
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

> =20
> +	/* Key used for hardware encryption
> +	 * undefined if IEEE80211_TXCTL_DO_NOT_ENCRYPT is set */
> +	struct ieee80211_key_conf *hw_key;

I would prefer "NULL if <flag> is set". And we could possibly do some
internal rework to get rid of the flag now (don't do that right now
unless you think it's easy, I'm not too sure off-hand). Can you also add
a comment about what I said wrt. accessing it inside ops->tx() only?
Sorry about the mail crossing.

johannes

--=-ZrdHkrg7MonMHX3aop/v
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASAeA3KVg1VMiehFYAQJwrw//e4Rd+JV0YC0DcX6RkH40tHw3Gyz/yfq4
fwEsXY5FYZuPkstEKhQiccNW9lkU+0Dm+P0OOpgIH/u2E/erWdKKo+jtq+mHGjSN
FT/+R5QLLuWYe7kzhaNhs6MxiQANbAgsw5WH1x9GsOrg+Mv5Mbsw85867WqP8PyJ
O/+l6VU3A2kdfXbMYim8xbSmYi664iC0WHREHjk51t/j2UfU6NgUbkSHSLhl+CmN
0NE24wIcDv3bnv5dWooD3RwnqOqxNII11YVnkm1Jb6IN6Gb8FdxwYBqMLTdqv247
aABNSj6m9ffc2GkvCVxz6L+dnwlQesL4u7dLwmy1XVIZEi70jKHKX3dyh5lHIxkl
isrgeB3pvEHyHQQ5o5LYkr5qJPJUaHzmfkOh4WzbwM63x9Kr7glpKxFKRwt8n29C
SI+/rOn0PaVbuTeIuNIdkSgIEuuU7OG/CxKZ5WvHwzH79TlnCkSHds1KJDZ4AsSn
JdydRwZQXyNcjDSWVXWYddeKUhcOXzXEALNRd+aO9KpwUM6WKPIinXdQbMSXTG/I
8BpDNeXZjB/NGFxJ2vGhwhgnWH8clJhokZjgfGlee1lB+b6F+55RiFKE0Wk//m8P
6o6K0ITZ3YVsyzcmYE/uWK09NOE/AOKIEwEWVrbgoQ6EBKaJgW4IYmCP23mBhkAU
/aV13V7Umoc=
=5mP2
-----END PGP SIGNATURE-----

--=-ZrdHkrg7MonMHX3aop/v--

