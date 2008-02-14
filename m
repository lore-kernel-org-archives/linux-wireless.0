Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:49863 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722AbYBNOcH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Feb 2008 09:32:07 -0500
Subject: Re: kernel 2.6.25-rc1 and no /dev/rt73usb
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo Van Doorn <ivdoorn@gmail.com>
Cc: Adam Turk <bofh1234@hotmail.com>, Pavel Roskin <proski@gnu.org>,
	linux-wireless@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
In-Reply-To: <a32f33a40802140149w48a1ee51idf4a7fd0619879f3@mail.gmail.com> (sfid-20080214_094941_719681_DA7C3A70)
References: <BAY101-W101597BA2B1DDD58D6F497C8250@phx.gbl>
	 <1202952347.29519.5.camel@dv> <BAY101-W1421BB30E73369FE0A2E3DC8250@phx.gbl>
	 <a32f33a40802140149w48a1ee51idf4a7fd0619879f3@mail.gmail.com>
	 (sfid-20080214_094941_719681_DA7C3A70)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-DplZ0Rxx5xuMeLKTBMAc"
Date: Thu, 14 Feb 2008 15:31:51 +0100
Message-Id: <1202999511.8931.128.camel@johannes.berg> (sfid-20080214_143214_543915_76B69C6D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-DplZ0Rxx5xuMeLKTBMAc
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> Do any of the mac80211 people know when and why mac80211
> fails to load the wep module?

No.

> Is there some dependency missing for mac80211?

Not as far as I can tell.

Herbert, has anything recently changed in the crypto code that would
cause a

	crypto_alloc_blkcipher("ecb(arc4)", 0, CRYPTO_ALG_ASYNC)

call to fail? We're doing

        select CRYPTO
        select CRYPTO_ECB
        select CRYPTO_ARC4

which afaik should be fine.

johannes

--=-DplZ0Rxx5xuMeLKTBMAc
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR7RQ1qVg1VMiehFYAQK6YhAAm8QL7syofpa5dBdpqL7HmFl4J3k6r0PG
ya2ri9jb9zu93DFhFOf0zNa2CAaNZCJ+RBM6SG7gkNdudvAUoFcyUcz2xnPG+SAG
60OTCzFDCuYeThbg2H+pTo3dfDKTsElcoUS77oudBpzIO0IXK9YODIMxVMj8dF8e
LtYloHE/jjsLnP2r1B5x8MlusmX9w84LeQEN3XOb9jRWTpsxqDvTnpds9OjI7iF0
yKw+cJ3duWsJ/pCP8apguXWoAe7/BFwKmI42jtWM/Uk7uoj+C23vC1jYtapBlITb
7nvKNoeoEy65Fb+PaIey10aqsQazzdOJogX5uyxaxjRlVfCRGtLsJ2Du6ruVp4Lz
a68p+YMByCz4dax7L+joRyePDbRVBvFZhfWCUtktXxH2I2sUxbCuWO4MK+zFNC4B
j3HKu2dJbZfJbmZ9dOslI/Dk8+CSDxbxuZ0HRw7FKWUn85VGrPjFL041n485aDPz
TLOdqfv14xwvN8vPV7Rxf+VUNQsITzyaabsvNyOi5tONfy6FEQnBggcyA4IOd0OX
18nQeEk7SrvY44N5P7EkzQHEldPtevKcMknS9QmjfrMgbd+eOHC+spu3/I+3z4ma
vw42psWgmu8MJFGdjXUHCUcoBJ+fh0HQjd1c85lrMddQoZpTsazQ5Fu9E8x6M/93
d91BjeinqWU=
=CFUz
-----END PGP SIGNATURE-----

--=-DplZ0Rxx5xuMeLKTBMAc--

