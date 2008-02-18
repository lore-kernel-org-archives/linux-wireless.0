Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:59834 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759324AbYBRLQ0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Feb 2008 06:16:26 -0500
Subject: Re: [PATCH] mac80211: enable IBSS merging
From: Johannes Berg <johannes@sipsolutions.net>
To: bruno randolf <bruno@thinktube.com>
Cc: ath5k-devel@lists.ath5k.org, mcgrof@gmail.com, jirislaby@gmail.com,
	mickflemm@gmail.com, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, flamingice@sourmilk.net, jbenc@suse.cz
In-Reply-To: <200802181103.47670.bruno@thinktube.com>
References: <1203088151.8931.197.camel@johannes.berg>
	 <20080216022918.18775.59888.stgit@one>
	 <1203239503.12783.22.camel@johannes.berg>
	 <200802181103.47670.bruno@thinktube.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-7u0AmgHdIia6aeZoshfW"
Date: Mon, 18 Feb 2008 12:16:18 +0100
Message-Id: <1203333378.12783.35.camel@johannes.berg> (sfid-20080218_111652_356488_0B491467)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-7u0AmgHdIia6aeZoshfW
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > This is assuming that we don't manage to process the frame within 192
> > usecs. I guess that will be true since we defer it to a tasklet, but do
> > we want to bet on it in the future or should we simply widen the window
> > where the merge *won't* happen because the driver doesn't provide enoug=
h
> > info and also add the 24 bytes offset here?
>=20
> sorry, i was to fast in agreeing ;)
> on a second thought i realized that we don't need to worry about that:
>=20
> since we get to handle the frame after it was received *completely*, we c=
an be=20
> sure that the current time returned by get_tsf() is later than the time w=
hen=20
> byte 24 was received. so no need for adding the offset.

Hah, good point.

johannes

--=-7u0AmgHdIia6aeZoshfW
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR7lpAaVg1VMiehFYAQIhRg/7B1Vu1y31o5wIkXKNi3pOYFWeZoCRo6En
SiK18IBnffPMrgxV8+k1hzW9RpN/BYkECeYRJcrQC40BN1paeSwz3Do+QTUkDquJ
nBHCWF+vTLkxDthcBDUkWd5BQkOzROTOiZYQaJTDDhJfFThPF/oLe0kk01d08Dtn
2JpZfOEX8+QEV0+8M1BveGw13dUl33NA8f4pD37DB4UmN6SWFzI4Y22/qzydqqQb
HwZwhWEIOTkX+zI9u3Y/l01q1mBvGy1jEX1IqLkEMeVAI+pJ/vv+mgQqiE7RNMpK
gIw06g2NTJaCZlBAnPf6UFV/JOL5bvy0jLJfwRVe301jhPEWfPXAMiKgyMxPT8En
apYWtTjekag1XvnETmHEnaya5TGsHhJAUVqThbkBYoGjX/9DcHxOeKAn2Y/bXHk4
x1Suz1VRRNJla2rjOkM+RFmk8Br0sLHlRGBdOsHY4IxMsIqsHhpAh5ToWHH/BZ8e
9izRxGoXOu+qnD3A6dUL2gN7AIzATWaRYDUCGN4y5Du2nd7zEUdZuR1iki7bo2fY
5yVAXVyca9PrjNax0OAmpr10cV0eeAWC3Zj9zfqgVzZKA6aBF8RC3YGPY2tLKdDQ
SYi1t3hDlflppiJvWfpqODOoZwdr6rmZYAy522F48FfNdCFzvW+t7huG5gZRcfz2
8JkZQOxluAg=
=9Ns9
-----END PGP SIGNATURE-----

--=-7u0AmgHdIia6aeZoshfW--

