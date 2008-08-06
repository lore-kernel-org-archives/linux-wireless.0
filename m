Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:38832 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349AbYHFVpl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Aug 2008 17:45:41 -0400
Subject: Re: iwlwifi aggregation info
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Friedrich.Beckmann@infineon.com, linux-wireless@vger.kernel.org,
	j@w1.fi
In-Reply-To: <1217595279.8621.38.camel@johannes.berg> (sfid-20080801_145449_897169_666FF62E)
References: <1217331138.10489.24.camel@johannes.berg>
	 <1217425854.10489.125.camel@johannes.berg>
	 <1ba2fa240807300659p4d743f31se265f550a2da0dd1@mail.gmail.com>
	 <1217431179.10489.134.camel@johannes.berg>
	 <1ba2fa240807300908x5489e3f8g54ff83e7e5912c0b@mail.gmail.com>
	 <1217509511.10489.140.camel@johannes.berg>
	 <1ba2fa240807311114t3e1b4fb3oe6643fbe28f2c2ac@mail.gmail.com>
	 <1217528597.10489.150.camel@johannes.berg>
	 <1ba2fa240807311216u1a45cf22j219046ab357b0910@mail.gmail.com>
	 <1217592554.8621.23.camel@johannes.berg>
	 <1ba2fa240808010540g660cdaa9p1158a27061e3fcd@mail.gmail.com>
	 (sfid-20080801_144007_421549_BFCC209F)  <1217595279.8621.38.camel@johannes.berg>
	 (sfid-20080801_145449_897169_666FF62E)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-88yVAQ3w9jvJluNibpmh"
Date: Wed, 06 Aug 2008 23:45:04 +0200
Message-Id: <1218059104.23048.81.camel@johannes.berg> (sfid-20080806_234549_961564_7EBB9794)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-88yVAQ3w9jvJluNibpmh
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> When that is not the case, however, we disagree. I think that because
> aggregation isn't a QoS mechanism, it should behave the same way as in
> the case where no stations have aggregation enabled, and stall the whole
> queue. On the other hand, you think it is a QoS mechanism, and let
> streams for the fast stations be interleaved with the slow station,
> leaving only frames for the slow station piling up.

I just found IEEE 802.11-2007 subclause 9.10 which actually explains all
the block-ack business without aggregation, but I assume that
aggregation now just means that instead of sending
	mpdu + sifs + (mpdu + sifs)* + blockackreq
you send simply
	a-mpdu

I see nothing in 9.10 that supports the view that aggregation/block-ack
should create a new traffic stream.

johannes

--=-88yVAQ3w9jvJluNibpmh
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJImhtdAAoJEKVg1VMiehFYeOMQAJWgx8qS5gLyPbWYbZKQ6XzI
oRY7HLkdYDnM04tdLU+fOpzcXfygMByqc0Oyefg8Wfagt5ltcrsYOvdsjx0uE7sZ
uA6yYuB2RU6KsYIwVCg4I5fVjd9hVoWCF3T8WCf5pu0OOjYnaTtDszh0L9ldVO1V
7drnJCsaeOtyeI/PrO08wk+SqvtC4ROypf32l51E7ea9+e9L/bxAhfoiwU7++Ayw
pGYc/yL/AnDA1lMan4TPyombc2tBP9EDbQrQgkl5gW0LtJt3xHozsJLxtICqhRf5
ZsNNGKb0qN7lgAlAPXyFkYqDb1B3kmocSqu86WmDyX1mA6yN2n8tN4qUX+nDpLtQ
nYYSqyUnBf7NW5axvICnN0wnmZ23f8hjLwH/7TphLxhmH/CeOs6TLq4Y8f5tD41f
vK9B+2nN4Y8hLzSpw71RVr1sWXKlnGQrmk9lAVZ06hR010OoSslp5FWfKdMLZ4L6
K2HouyTnMPyRdR1vM7E4AzA92y4PkMSpZu6z68eZYGJy7NYeNhJr/4Peu2OFPQRn
8nopVFxteBVTHHrsX9zcW6I26kjxfi8p8ZARriKnn3k4SphSK7LOc12NRLrQM+3l
2I0P3PtKzcBpMdJDFKSXJ/+3tMICdvpMQEJBPzQmBd7h2jdSyP8ml7UnUxNvKgCo
TRJ+Dgb+FftAXjGlHZZ1
=lhby
-----END PGP SIGNATURE-----

--=-88yVAQ3w9jvJluNibpmh--

