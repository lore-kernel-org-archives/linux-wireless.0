Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56771 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005AbZDQT3i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Apr 2009 15:29:38 -0400
Subject: Re: [PATCH] nl80211: Add set/get for frag/rts threshold and retry
 limits
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20090417184629.GA9275@jm.kir.nu> (sfid-20090417_204656_419019_FC59D391)
References: <20090417184629.GA9275@jm.kir.nu>
	 (sfid-20090417_204656_419019_FC59D391)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-2kV5euV0RVzXt+NGaAHN"
Date: Fri, 17 Apr 2009 21:29:33 +0200
Message-Id: <1239996573.5110.12.camel@johannes.local> (sfid-20090417_212941_788016_55ABF147)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-2kV5euV0RVzXt+NGaAHN
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> +	if (changed & WIPHY_PARAM_RTS_THRESHOLD) {
> +		if (local->ops->set_rts_threshold)
> +			local->ops->set_rts_threshold(local_to_hw(local),
> +						      wiphy->rts_threshold);
> +	}

That could return an error. (so do the changes the other way around)


> +		if (changed & WIPHY_PARAM_RETRY_SHORT)
> +			rdev->wiphy.retry_short =3D retry_short;
> +		if (changed & WIPHY_PARAM_RETRY_LONG)
> +			rdev->wiphy.retry_long =3D retry_long;
> +		if (changed & WIPHY_PARAM_FRAG_THRESHOLD)
> +			rdev->wiphy.frag_threshold =3D frag_threshold;
> +		if (changed & WIPHY_PARAM_RTS_THRESHOLD)
> +			rdev->wiphy.rts_threshold =3D rts_threshold;
> +
> +		result =3D rdev->ops->set_wiphy_params(&rdev->wiphy, changed);
> +		if (result)
> +			goto bad_res;
> +	}

If that returns an error we need to roll back the values?

johannes

--=-2kV5euV0RVzXt+NGaAHN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ6NiaAAoJEKVg1VMiehFYxxMP/0Zb+Yqvn8nNr6lDhvd6r/yX
fZieSCHZqQyn8p/4b3NOmV/IdH0Ghziv0jk8ihY1e05uki9AowTrJss+n1KniXkv
JgU7nu5UH+CHFamzDOpFh2LyiOKkGk/5xQLmYH9mbAIzPDhx5J73F/3RN4qrw4cC
3A4K0iJqFzZiHYi6wc5RgBKTqRxyuqYtzC4SL6UPJFd5HZaSJHaK5U+2JankIf2M
g3p0mJ6GRYfheeyaZrAynfnbB0A6MN1MbdsKg7XDRChRtrRYd0fDE5owEecdKHBz
/0EYUXPaW2ppw1CSZeyTwhEMKerQPa6W/KkVgp7mHxHCyqMqyYG9i6K5yReSwGDh
cBSOiiN2d/pzMby9XHODoap5NkXBVHeCge/TGPQXW6S3ro5aV5rgDPBxNxMSiP0Y
jip4Ocmbae8fisyBsp4VbiM5zm31vMgy2R7RUXp3YE6QT/6FukV8X3BUVaGuawmw
GpezVntRKLIrFUpZyc/xAimZt1mE/X2EppmXj5Kibgz3AKCW1qP/pyb+kyN+Gxrl
LeBAT1vmd/e4Bb4LcPWMM93jaIflcmA4oS94ky/LSg0wuIS6VXhju+/98bPzMzPh
pxXF7E8zEVQPjvJjRiB3MnMZUopWcEHjcPSLi1CWtF0rpd3y68U0o9kXyCJQgY8k
z/z4fRTjC+Fcga9UwbWh
=uIEL
-----END PGP SIGNATURE-----

--=-2kV5euV0RVzXt+NGaAHN--

