Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:49066 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750965AbXFKLXy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jun 2007 07:23:54 -0400
Subject: Re: [PATCH Try#8 4/4] mac80211: Monitor mode radiotap-based packet  injection
From: Johannes Berg <johannes@sipsolutions.net>
To: andy@warmcat.com
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20070611095846.604134786@warmcat.com>
References: <20070611095400.206844675@warmcat.com>
	 <20070611095846.604134786@warmcat.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-X3jC9LU9tqTQmAyP6xBi"
Date: Mon, 11 Jun 2007 13:24:25 +0200
Message-Id: <1181561065.29767.15.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-X3jC9LU9tqTQmAyP6xBi
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> +	/* for every radiotap entry that is present (returns -ve on end or
> +	 * on error)
> +	 */
> +
> +	while (ieee80211_radiotap_iterator_next(&iterator) >=3D 0) {

"returns -ve"? Also, this does >=3D 0 while the docs stated that -1 is
returned. Maybe the docs should be updated and the code should be
changed to actually return 0 or a negative error code for
iterator_next()? I don't see any value in the return code when it's
non-negative, but when it's negative there could be some value in
determining -EINVAL (invalid header) vs. -ENOENT (when it's the last
one) for example.

> +		/*
> +		 * fix up the pointers accounting for the radiotap
> +		 * header still being in there.  We are being given
> +		 * a precooked IEEE80211 header so no need for
> +		 * normal processing
> +		 */

Interesting thing I just thought about here. For hardware-based sequence
numbers we'll be updating the sequence number before sending it, and for
software-based sequence numbers we wouldn't be.

However, for a userspace MLME we really need to update the sequence
number, so we'll either want to have a radiotap flag determining whether
the sequence number should be updated or not when transmitting a frame
or we just update them all the time, even for software-sequence numbers.
bcm43xx for example allows to turn off hardware sequence numbers on a
per-frame basis, so it'd be able to do both, but I'm not sure we can
rely on such functionality hence we'll want to just update sequence
numbers all the time...

johannes

--=-X3jC9LU9tqTQmAyP6xBi
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGbTDp/ETPhpq3jKURAgQSAKC2Qh9UB2LAwV5vTNf/18QytoDU9QCgpUK3
0zEwzQqxquXfaP2GPwf70rA=
=ohSP
-----END PGP SIGNATURE-----

--=-X3jC9LU9tqTQmAyP6xBi--

