Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:37637 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbXLLRZ3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Dec 2007 12:25:29 -0500
Subject: Re: [RFC/T][PATCH 1/3] rc80211-pid: introduce rate behaviour
	learning algorithm
From: Johannes Berg <johannes@sipsolutions.net>
To: Mattias Nissler <mattias.nissler@gmx.de>
Cc: Stefano Brivio <stefano.brivio@polimi.it>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <1197393788.7528.5.camel@localhost> (sfid-20071211_172341_980688_FC3BC8E2)
References: <20071209211547.2d7fca32@morte> <20071209211931.26ff42fa@morte>
	 <1197239150.7543.13.camel@localhost>  <20071210090853.79ea4645@morte>
	 <1197319867.7493.4.camel@localhost>
	 (sfid-20071210_205142_109612_504EEC93)  <1197384754.4037.23.camel@johannes.berg>
	 <1197393788.7528.5.camel@localhost> (sfid-20071211_172341_980688_FC3BC8E2)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ApYxH6ggmvoG+CY9deJD"
Date: Wed, 12 Dec 2007 18:13:14 +0100
Message-Id: <1197479594.6558.122.camel@johannes.berg> (sfid-20071212_172537_174949_191BBF7B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ApYxH6ggmvoG+CY9deJD
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> Just to sum up the issue for Johannes: Stefano's patch adds per-rate
> information to the PID algorithm state. This is fine, however we need to
> make sure the rate control algorithm gets reinitialized when the number
> of rates changes (i.e. due to a mode change, what about about regulatory
> domain changes?), as otherwise we might be indexing array entries we
> don't have allocated. Now this spawned the more general discussion about
> when the stack should allow changing modes etc.

Thanks.

> So let's go back to the original issue: Johannes, can we assume rate
> control always gets reinitialized when the number of rates or even the
> hardware mode is changed?

I have no idea. Doesn't it get initialised when the interface is brought
up, and as such it would because those changes can only be done when
it's down? If we want to be strict and allow changes while it's not
associated but up then I think the answer is a clear no.

johannes

--=-ApYxH6ggmvoG+CY9deJD
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR2AWqaVg1VMiehFYAQKkbBAAh6k0XABf97wTpNPVy0e6U7oYwdzR1RHm
n0PDq0Bv/yykZhurgNialQbVvlXqIiDQOXVL2Q6WjBpNPPQsyi3KvSrfJeflW9PH
NhUEdOgp0QR1swcv6E6e9tO670ViaRDqWWR70RgzquWMJhgzs1uaNB5lEB7n8Exw
c14J/6amlXLLwC/kGh5RY3MfaPDQvCp1MDyApJl4YvRhygARMObx3hQWPE25DJhn
dwYz6pUuY/oqLor7Epqhw8V1OHdZdFPEfWEz8Wizp47Z9HSymPm+QltK9RUXO2fq
wvHowtG6cEolpN5g4Hsb5N7aVcG2gkYmhU2HLjE9mBYgIsOUw+Cl6by5ICx3IDNF
+9Jbjr5/NvSRhuC7nGf496oQKi1c6TPK6bq9ktPohSbL8QWwwRwZOaeDIHKt4Rin
QUjQbD2y8JZ82gVa4JL1LbEornBmQi3pgnL+3hEEUkS1yo7Aa7JcKO9J7fD8XI8t
hnLvF6EGKoHnXdDaS4y0ynLeXp7nWsHKKELnmxuQZ78gD2BWbzN2fNvwgJZZBiKE
OIaXWFmPYPhqK5e1fhHDsi8WsxPlTy+qDEQhJDetS9FTVrT/s/Zb0urBswcJV3Kr
5kfmfTHJb9YHlOiyHSISga+Y4ujO0S/NqbTKii9ANuqLORmHr+LdsSFExo8Enz/P
cl+oVGI7YYM=
=8snC
-----END PGP SIGNATURE-----

--=-ApYxH6ggmvoG+CY9deJD--

