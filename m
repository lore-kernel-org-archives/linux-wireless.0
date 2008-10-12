Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:46303 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128AbYJLAGb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Oct 2008 20:06:31 -0400
Subject: Re: [RFT] p54: implement MRR
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Felix Fietkau <nbd@openwrt.org>, Chr <chunkeey@web.de>
In-Reply-To: <1223769491.3581.8.camel@johannes.berg> (sfid-20081012_015818_541064_B75F451C)
References: <1223682964.29811.13.camel@johannes.berg>
	 (sfid-20081011_015617_239108_FC7ED5DA)  <1223769359.3581.5.camel@johannes.berg>
	 (sfid-20081012_015633_680320_8FD05EB0)  <1223769491.3581.8.camel@johannes.berg>
	 (sfid-20081012_015818_541064_B75F451C)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-gepyinX+ubtoV2UYGFNt"
Date: Sun, 12 Oct 2008 02:06:27 +0200
Message-Id: <1223769987.3581.11.camel@johannes.berg> (sfid-20081012_020650_829692_1790DA59)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-gepyinX+ubtoV2UYGFNt
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2008-10-12 at 01:58 +0200, Johannes Berg wrote:

> +	/*
> +	 * We support at most 8 tries no matter which rate they're at,
> +	 * we cannot support max_rates * max_rate_tries as we set it
> +	 * here, but setting it correctly to 4/2 or so would limit us
> +	 * artificially if the RC algorithm wants just two rates, so
> +	 * let's say the max of rates and three tries each, and clip
> +	 * it to a total of 8.
> +	 */
> +	dev->max_rates =3D IEEE80211_TX_MAX_RATES;
> +	dev->max_rate_tries =3D 3;

Ideally, of course, we'd set max_rates to 8 and max_rate_tries to 1, but
we don't have enough space for that in the tx info (no 8 rates
possible). Hence, the next best thing that matches the HW well would be
4/2 and have the rate control algorithms program the same rate more than
once if it wants more than two tries. Same in mac80211. Thoughts? Is
that feasible?

johannes

--=-gepyinX+ubtoV2UYGFNt
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI8T9/AAoJEKVg1VMiehFYVisQAL8zDFUF6kbW74AWpUQxKjo1
smTdtPZMee8D7yq9bsjRgaEDxXtE03lBrSrVjp0fz8RKvVTuOFUIqXDExrHu/KER
Yv8H2RMKpYm0qCQEQPQVkWf4haaaCQTQLLr29DEuK1SyuLSg4/T2/+TGMtTKCmtR
PY1lsyvA0FcrZwi1w651QittDAkiyQRoXnNQogHEHD12q0VQY8/7/VxxnhA3rsvj
XuYntWCtp/NG1CLtm4qCp6GoqnUQSDK0kCWDkqWyC+v8xAz8gkB0GSpjMqXiK7+H
h54RhKXXqEKS2NMWDLRIizXmZMv+t/WuUMgTI2pg18qpNp4piW4MYZ7/PGg0+RCB
l6lyFzwkL8sMWR3d2jHWQt7/PzmTERbPpRfYo68keJ6iA68YbffEMZXx6Fh4Ao9c
Rv8rvpTKzl2cYQW3PwRaNe91OwF3YYJEzpwqyP/dxrIz1pmkYK1etv07IylRBKt+
oXNlMZg8MH5i2/7bSo7/F4ZHJsKoS3r6UA3vgrBNPeSf7DRXHBtyoY8j+2DIz8Qe
JF09KMrS1xF2zG/5WX6z484dui7LDLIXf1GEJiig2khBWuopKfbf+JQJeUkI3ZYZ
ljkzIeqvEL/IIrygc4D7AkfSjZ6h/dB9hcruwmPYkZgk2OeI6DerExlzPNv2BmS4
KeKpV76Xh+HrcQJhtXQF
=EyZD
-----END PGP SIGNATURE-----

--=-gepyinX+ubtoV2UYGFNt--

