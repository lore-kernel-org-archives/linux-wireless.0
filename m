Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:39297 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752883AbXJHJeU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Oct 2007 05:34:20 -0400
Subject: Re: [PATCH] mac80211: Defer setting of RX_FLAG_DECRYPTED.
From: Johannes Berg <johannes@sipsolutions.net>
To: Mattias Nissler <mattias.nissler@gmx.de>
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
In-Reply-To: <1191767731.8135.5.camel@localhost> (sfid-20071007_153600_904601_06ED94FD)
References: <1191767731.8135.5.camel@localhost>
	 (sfid-20071007_153600_904601_06ED94FD)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-YXTctA+P8JPmczBOTXmw"
Date: Mon, 08 Oct 2007 11:34:54 +0200
Message-Id: <1191836094.4063.9.camel@johannes.berg> (sfid-20071008_103427_297564_F26C48FE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-YXTctA+P8JPmczBOTXmw
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2007-10-07 at 16:35 +0200, Mattias Nissler wrote:
> The decryption handlers will skip the frame if the RX_FLAG_DECRYPTED
> flag is set, so the early flag setting introduced by Johannes breaks
> decryption. To work around this, call the handlers first and then set
> the flag.

Huh. Sorry about that. I had a patch like this initially but then wanted
to not clutter the code. I think we should instead remove the checks
from the actual decryption functions though. Mind making a patch for
that?

johannes

--=-YXTctA+P8JPmczBOTXmw
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARwn5vaVg1VMiehFYAQKdLw//TxKatUu6PncLsn/WXrnWfPpFtuxj1mBg
RbXU8wn+W5/LUuYvebrSFq6qs5fSIGKlsZp4lyC2/PoXXzb2sS9NGVxWNfxJ+fqz
AG3dAINNU6qk/LQzh6EJbM8H1Zz4GsD9h3kgMnmzAWqbZ5NoGCNWf+UBXbssokAt
o44NOmnLpuJSNPGp4c7seDiMBKbobtRDQD+ocZJDTdcriqkch5y9zlDCAt7VU47S
t1pwvKhQ0/TW+ZwdE3/qgrBv9xMQIkfy/6ZwU8fUSCJP0sqhrnk/8TcA+XuRtJYE
GWIVUFinnTH9UQS1N85XktuT9Xuucxe6oAzv/nnv6eGIJRiU4KWKmGyKlRsBxU/4
X7i6f9GXu3LGTrTQ9xG6kSIVWaX+pqHLKsccAeJWMAxJNwE3MVf+Pcu/sG53TxrH
MktmG9mlXEZUT/BF+2rDImDPOQCznYJc5ovDr/G4gmreX9oEXBtA31yTcP4rTu3u
plDbkDAoLmlTeKzWlLN2abJgGWYAPX9Rt8Wgi3M6aSqfXYUqB11GxvAbjUzrHdbn
mHNrRkCZrcX2i/FZJBvE/ucUgyQcyWGaNQzz0pRePLTRqsaqCGm5K6LjcrqLaJI4
MuhhL22BZS2wNba530O4g5GaSAvdg389Rx/A1cuI7TgGWQfbVqFUlnNdMFxMmw8L
SbEt6WgyouE=
=2qGd
-----END PGP SIGNATURE-----

--=-YXTctA+P8JPmczBOTXmw--

