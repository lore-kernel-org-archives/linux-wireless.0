Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:56247 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071AbXLDQb4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Dec 2007 11:31:56 -0500
Subject: Re: [RFC][PATCH] mac80211: Use PID controller for TX rate control
From: Johannes Berg <johannes@sipsolutions.net>
To: Mattias Nissler <mattias.nissler@gmx.de>
Cc: Tomas Winkler <tomasw@gmail.com>,
	Stefano Brivio <stefano.brivio@polimi.it>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <1196681514.7470.12.camel@localhost> (sfid-20071203_113229_452420_E8E9CC87)
References: <1196622331.7472.4.camel@localhost>
	 <20071203041608.3af3b462@morte> <1196679780.7470.9.camel@localhost>
	 <1ba2fa240712030321g58b8df39y24240c63facba2cd@mail.gmail.com>
	 <1196681514.7470.12.camel@localhost> (sfid-20071203_113229_452420_E8E9CC87)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-+SSJFivL1YkStXfvWqvY"
Date: Tue, 04 Dec 2007 14:40:23 +0100
Message-Id: <1196775624.6060.52.camel@johannes.berg> (sfid-20071204_163202_921437_25BC6445)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-+SSJFivL1YkStXfvWqvY
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> I already thought so. But the original "simple" algorithm is totally
> broken in most cases. Well, maybe except the cases perfect situation ->
> no tx failures -> full rate and bad situation -> lots of tx failures ->
> lowest rate. IMHO, we should just get rid of the old simple algorithm.

I tend to agree, but I guess we should rename it then and change the
default. Ultimately, we'll need to come up with some nl80211 API for
rate control algorithms that allows each algorithm to have different
parameters, similar to what tc(1) does for qdiscs.

If anybody's interested, here's what I'd do:

 (a) add new attributes "rate control algorithm" and "rate control
     algorithm attributes"
 (b) allow setting them with NL80211_CMD_SET_INTERFACE
 (c) the "rate control algorithm attributes" attribute is nested and
     contains per-algorithm information, the indexes in it are specific
     to each algorithm

This allows changing the algorithm as well as algorithm parameters.

johannes

--=-+SSJFivL1YkStXfvWqvY
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR1VYx6Vg1VMiehFYAQIqNBAAp4Ibuvu6QbZrM+lFICgFL3uT/lkchZcX
cn38Gcnrave2s/ScR3oKU0cFG7Qv/KzvCGmvYY34KdMm28nv3ZBW4wgQKQPD3cpw
rh5Z1RnVKRjj6p4LzbhjSOLGuCi403KYtCUzTPgMjmc8suhfOwu+NNksaXbPYZ2R
WRDvhvMWcizO4upojJfXUkO0WSWrRoFV52aFoRbckq2s+wDuA9qeA58emc+voRxP
yaArQ1EKgttw9PSeXNUHnraFAkWaTBWv9YrsLXyObOXjuKHP1HCtF5wtYbLMj0Gz
p8Ke581W2WVYp9I6khwhrHFBcyy0BxaM/E/FI19CB+i28cP6/GBX4961kfnoiHXy
5uCM0M/XHTLPfg0S9BeDrl8NzYL/frP1yOQR626zulrZKi3K2iDaj213tblV1SsJ
PN5I57nCp/ibbtDb4di9LDxNQaFcmqb4PMUKTLMW2NFVvik4/Zw+LKRGWLTgvTGL
0wusMIo+0cNG7i8iMZ6RnTfaRD996iEn1+iLEw1V60ZAMh2ETymZvOZE+dXfolvr
BHRjTwBpRKTznlYHbSGSEbKgHQ9lYoJWIc5gdpsZauy9mejPw4sOevDtgWHEw+iq
ewL8oDDYnaU1pyiojOVlsRxRaeOvHfGyOyXpNG0NDZxzo8FQ3WXNIqyvisdQi060
6VK8bgorVuw=
=8I1h
-----END PGP SIGNATURE-----

--=-+SSJFivL1YkStXfvWqvY--

