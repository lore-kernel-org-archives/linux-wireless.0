Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:43227 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754006AbXLUVPb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Dec 2007 16:15:31 -0500
Subject: Re: [PATCH] mac80211: better rate control algorithm selection
From: Johannes Berg <johannes@sipsolutions.net>
To: Stefano Brivio <stefano.brivio@polimi.it>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	sam <sam@ravnborg.org>, Michael Wu <flamingice@sourmilk.net>,
	Michael Buesch <mb@bu3sch.de>
In-Reply-To: <20071221215758.4f962a39@morte> (sfid-20071221_210054_825614_75E999FE)
References: <1198253375.16241.76.camel@johannes.berg>
	 <20071221210017.36f34fe3@morte> <1198269816.16241.82.camel@johannes.berg>
	 <20071221215758.4f962a39@morte> (sfid-20071221_210054_825614_75E999FE)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-8gtDN8IUB8brCgv+MSI5"
Date: Fri, 21 Dec 2007 22:15:21 +0100
Message-Id: <1198271721.16241.85.camel@johannes.berg> (sfid-20071221_211536_306402_6D714457)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-8gtDN8IUB8brCgv+MSI5
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> I think that rc80211-simple is broken. A user may just want not to have a
> real rate control algorithm (i.e. no need for rates above the lowest one =
or
> certainty of perfect signal). Currently, that user would choose
> rc80211-simple, I guess, and well, this is almost fine, as he could
> manually set a rate. But let's say it's an embedded device, and small
> footprint is a must. Why would he need to use any RC algorithm (even othe=
r
> than rc80211-simple, as your Kconfig changes allow for this) then? mac802=
11
> currently fails if no RC algorithms are available. So, I'd say, let's fix
> mac80211, so that it can work without any RC algorithm. And the default i=
n
> this case could just be to set the lowest rate. That's what I called a
> dummy RC algorithm.

Well, even an embedded device needs a rate control algorithm. Me
allowing to build none into mac80211 is mainly for when you want to ship
your device with intel wireless hardware and that has an algorithm you
*know* will be used *anyway*.

johannes

--=-8gtDN8IUB8brCgv+MSI5
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR2ws6KVg1VMiehFYAQIw/w//bf8Ah53c2SrwVHoaUaTzcSJnvG221Sc9
X0TlitEnbsT1rNtntvxszb5D/LbRGqtCP61pgYPjmgwJwWkGDIs+d0rim6inQTVi
4oUcnB/TomB15j8xVlTAuTcy2E0MBIfiMK1mMMxBOlrdG7m3QiNsOh+UcQZ/4hA/
XlieYCI1tJnMpvWwmGP61oJjI1x1DGXeGHq3eKzLvVkZDcDjL8pF9MTSqrLPQjhT
hz+6lA3EZWiBsnzJ7SIvqIt10PmH+TwZMvvnHmouHu5VZ59aCPKHFHHrbhBqxZA2
aDIv6mmNo6kTiFPcKCrC6DvEu+u7HrFyrv4zG/WUsVFopSeWtBSe5c7EuugOvNqr
uHTtFaM/8SI67Q5F3Lrs/34MrU+k11McWnIu6G6UWX69TwY+0ZLaXiNb+4p+zDKG
gVHxt6yK1k/XEcQkGMBjmpBZIzgkF/Std7WAvkX2E+vJHq+eZAcCS74h6eFuP3Z1
djHJ9dUfOxG/M8QcjZBi9aUCU4X0Z00Hk/yfmTzzxAogYzfA0QZkmFvpAQzgGskb
YhLTglwHqWJPuarQcAtD21uNKOmy4rUzGZztQVQG3XjQmdR4mBoh4QjGw+QvOK8B
XcdTLTXs3N0uN+rJGDuztoiUy4lCG9mOr1YNfAxZl1fStpFZG6UM0DQbmft2/iwd
sT4m06UTFIk=
=i+kg
-----END PGP SIGNATURE-----

--=-8gtDN8IUB8brCgv+MSI5--

