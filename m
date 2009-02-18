Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49019 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754099AbZBRRac (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Feb 2009 12:30:32 -0500
Subject: Re: [PATCH] cfg80211/mac80211: fill qual.qual value/adjust
	max_qual.qual
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
In-Reply-To: <1234978042.4023.32.camel@johannes.local> (sfid-20090218_182801_452013_E7F46FA4)
References: <1234896777.4678.7.camel@californication>
	 (sfid-20090217_195251_321967_5E2E0AB8)  <1234978042.4023.32.camel@johannes.local>
	 (sfid-20090218_182801_452013_E7F46FA4)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-OOFN0Of+Kaq092hk0VEG"
Date: Wed, 18 Feb 2009 18:29:57 +0100
Message-Id: <1234978197.4023.34.camel@johannes.local> (sfid-20090218_183037_439634_B9D4456A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-OOFN0Of+Kaq092hk0VEG
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-02-18 at 18:27 +0100, Johannes Berg wrote:
> Due to various bugs in the software stack we end up having
> to fill qual.qual; level should be used, but wpa_supplicant
> doesn't properly ignore qual.qual, NM should use qual.level
> regardless of that because qual.qual is 0 but doesn't handle
> IW_QUAL_DBM right now.
>=20
> So fill qual.qual with the qual.level value clamped to
> -110..-40 dBm or just the regular 'unspecified' signal level.
> This requires a mac80211 change to properly announce the
> max_qual.qual and avg_qual.qual values.

Forgot to mention .. with a little work we can move the entire iwrange
handling into cfg80211 -- happiness.

johannes

--=-OOFN0Of+Kaq092hk0VEG
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJnEWTAAoJEKVg1VMiehFYeLgQALH9rC8JAMbOcuF81+Yg0OXq
JPnPi1UqGZUWvFUu6Vpq7BIByowDlBYHlkETkgS713B/AYsfwPTqjG09CvHmXV8Z
Nz0iYE3ahWspU6+m6Yi7cM5UQdzBe9hONQ7v5GAQ3wcNYBx+vq/eyb3SJMP3CH0r
fzwdXC/g8+gBTk7mlyPQESmNW4uhozXfHz4Iyh3ElcCV2dMucaMcSFXJSNCx6K5Y
d/h8jnDH/K1TWnFYTqNkLo5JiyGw1sUSAafvTATbyMEWpF9tgqbuq/RKQ4qGa8SR
f2uvkN12iSu4Ld806xuwfpD67TNg6Xvx3JfacYA2t0MrPjBDmsMVJXCNCIaQEA0W
P02sFWCcKv50rBgGicFfeecmcdEz74M3Y6RiBdYMTndjrbH44UTS+K4auvEyD12+
NugBKS0pFlMBpWxNJ4GX1xAP4fSFVn4wZxv+Vn6Ip4dUJKkTbivJGfw2lBEGkkKo
phtxHZi7hr3o0W+DLvq3/AaQcrXYt1N7StyxD+bfSmk61FNFjQgCBFEF65gB/Lhq
ShuZz0cpHb7UWq4UXcZVJCPvl6rPj0qRFoy8sUQ9DYr2UFBYmitZ404aXj6h+x4b
IVuS3c1+vC5qqkTaNAPz/8q2erknlYO8UVfwONxHVZL4mRT2E1z3RWSvYP8vNggR
J4B6OpXl58rB3yxakjqM
=Wje0
-----END PGP SIGNATURE-----

--=-OOFN0Of+Kaq092hk0VEG--

