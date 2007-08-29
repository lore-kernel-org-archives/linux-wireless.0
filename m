Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:56865 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752746AbXH2L3Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Aug 2007 07:29:24 -0400
Subject: Re: [PATCH] Fix breakage on WEP for cards that rely on software  decoding
From: Johannes Berg <johannes@sipsolutions.net>
To: Adam Baker <adam@baker-net.org.uk>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>,
	rt2400-devel@lists.sourceforge.net
In-Reply-To: <200708282345.53016.adam@baker-net.org.uk>
References: <200708282345.53016.adam@baker-net.org.uk>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-SSSylnAswnXQdiHZp74V"
Date: Wed, 29 Aug 2007 13:31:05 +0200
Message-Id: <1188387065.19891.10.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-SSSylnAswnXQdiHZp74V
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-08-28 at 23:45 +0100, Adam Baker wrote:

> When using rt2x00 with WEP we get continuous reports of "RX WEP frame, bu=
t
> no key set" without this patch. As the rt2x00 driver currently relies on
> mac80211 to perform the decryption I believe it would be incorrect for th=
e driver
> to set IEEE80211_HW_WEP_INCLUDE_IV. Also reading some of the code
> comments it appears that even for a card that does HW decryption there ar=
e
> circumstances where the SW decryption will get used and in those cases
> we need to set the key.
>=20
> The patch was generated against the rt2x00 git but looks like it applies =
to
> the current wireless-dev everything.

This seems correct but it looks like we need to fix a few more instances
of similar checks, especially those involving
"KEY_FLAG_UPLOADED_TO_HARDWARE". I'll take a look.

johannes

--=-SSSylnAswnXQdiHZp74V
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG1Vj5/ETPhpq3jKURAsM3AKCuKWfk5BMRL9mPKN0gqdyJzMN8PACeOoos
etw5NySBrtOd3xM1qMgRRow=
=rDWR
-----END PGP SIGNATURE-----

--=-SSSylnAswnXQdiHZp74V--

