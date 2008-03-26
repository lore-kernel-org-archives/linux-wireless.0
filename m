Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:41511 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754653AbYCZMuy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Mar 2008 08:50:54 -0400
Subject: Re: IBSS RTNL assertion
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <1ba2fa240803240921h44321705s923ecac89427196e@mail.gmail.com> (sfid-20080324_162156_026330_E1B802F6)
References: <1ba2fa240803240921h44321705s923ecac89427196e@mail.gmail.com>
	 (sfid-20080324_162156_026330_E1B802F6)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Csr4Z3iGttI+sKBe6AlF"
Date: Wed, 26 Mar 2008 13:06:19 +0100
Message-Id: <1206533179.16475.313.camel@johannes.berg> (sfid-20080326_125110_310515_D473A698)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Csr4Z3iGttI+sKBe6AlF
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable


On Mon, 2008-03-24 at 18:21 +0200, Tomas Winkler wrote:
> Has anybody experience the one bellow? Any insights?

> RTNL: assertion failed at net/mac80211/sta_info.c (140)

I think that can be fixed by making ieee80211_sta_join_ibss() lock the
rtnl around sta_info_flush(). Please try that.

> =EF=BB=BFLooks like there is a quite lock mess in wireless-testing.

That is a gross exaggeration.

johannes

--=-Csr4Z3iGttI+sKBe6AlF
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR+o8OqVg1VMiehFYAQLLsQ/+Ir0BxMwWKYMXss7Xi2JHiWux2yBTsltk
/mp5rv+BU1Wb/a1xERMTXKlgjgQ+MkzSWu3JqoT+Rt1ECPqMKLtMr/J1clcumhW9
mYM2DE8J9aKy2e7fsnFJ3H0MvBVfhw3Pce0rHOfFnp4XyLG+CYV61yGRqeB7pLPV
0saNCp0HcBqdw2vUjw4UniMvVkfSIsNLLqJfZv6FykYVv+b8WNQutZsj3n1hPI0K
K/AT7OOZxX9vzs1jv8aWuafQqeKj3ogHRi9rVQP/Pw6B9STvQUHvFMpXtzwiv6xy
naDeWIlZwxDtqPAwdWFKTOrJRUQP+9xSUHrHptUKrMclNMZFPa3c5KLfdK760Dfd
H6psWw0HUc1Vf/UdalHvVSO74PdgjGRyQxznSXp/d5ILaM+M+TK8WX/mqiPdmKwE
LYpx9pqLwNeYBfJ9A1NQtTeSuSNlDEpf9v3KVzB0nJeGV2P6+A8oeybYvhM07KCW
Ozo5+0MYIytcPxHQgWrUGu5fTJCf3zuU1MBeSsoyltIR8GcE0NcgDql4IClp7Io+
x800MUvTHZf0KQz9+N033WCIYBJIKiIIh+j+G8Qwe5TtIcPVP40ySThycEwXRvnA
B7qhif1XZ+7ISDdb8zIsSb3H/I2teKNKkbNEaRJVLz7Wdp6t/WY/XUH32WeCgwtq
Um/nvhmSHww=
=92Sy
-----END PGP SIGNATURE-----

--=-Csr4Z3iGttI+sKBe6AlF--

