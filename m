Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36824 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628AbYLUKei (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Dec 2008 05:34:38 -0500
Subject: Re: [PATCH 05/16] wireless: allow for private channel area
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org, kalle.valo@nokia.com
In-Reply-To: <1229752522-1917-6-git-send-email-lrodriguez@atheros.com> (sfid-20081220_065605_625660_6912E235)
References: <1229752522-1917-1-git-send-email-lrodriguez@atheros.com>
	 <1229752522-1917-2-git-send-email-lrodriguez@atheros.com>
	 <1229752522-1917-3-git-send-email-lrodriguez@atheros.com>
	 <1229752522-1917-4-git-send-email-lrodriguez@atheros.com>
	 <1229752522-1917-5-git-send-email-lrodriguez@atheros.com>
	 <1229752522-1917-6-git-send-email-lrodriguez@atheros.com>
	 (sfid-20081220_065605_625660_6912E235)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-1MC/TFe1pOcpzaPEKyvd"
Date: Sun, 21 Dec 2008 11:34:35 +0100
Message-Id: <1229855675.4953.6.camel@johannes> (sfid-20081221_113448_629971_A2902FB7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-1MC/TFe1pOcpzaPEKyvd
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-12-19 at 21:55 -0800, Luis R. Rodriguez wrote:
> Wireless drivers tend to require calibration or noise floor
> checks. Some of these operations are channel specific. Instead
> of forcing each driver to keep a separate map for these values
> per channel allow for a private area on the ieee80211_channel to
> reduce code overhead and size.
>=20
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>

I don't like this much. This is prone to abuse, it'll only be right when
you have allocated channel arrays statically.

Can't you do something like I do in ar9170 and put the other information
into a table that is indexed by hw_key_idx? That even reduces the memory
usage :)

johannes

--=-1MC/TFe1pOcpzaPEKyvd
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJThu5AAoJEKVg1VMiehFYaicP/RdMEFHKCcwYI9ghpcy5ZdTB
hoOYAAAQl36FDn6cE5rUaAfKUe2oBGiTN1K2PuIHv+6oWATkaKR2Iivd1rtpvAya
krUh/DEzdJ2A0hjLiROYZ0tRH+OhXmlIQeFEyf/+8nOA1rxyYfOBR+lOEjhlSxZ5
v0hEN1UXhw8DiZM2DQoucuiqHyS3ZlZpl5NaneNUlVzbDBULhgMGgnpC4SZuNf2k
xtlfHFfSLAuniEF2u2EmmQL8oUr6StsNsgh15DCWtLMWmUZIXZNfx6iwtlOdNI8o
UXaqztMGsv6p0KApgc6urJJxvRViGRe9V07V64tAKcJhwghz9Jt3a0fq3Prd2i+U
dFYwB51wF5smW+Iwnb07B2/7NbgC3UKiUXqucsv66k5K9OfYM2RLZ4c6eVPIBJZR
99HhQ2wbnFM/LweY5WUFlqr9fRgD6XN2XaALmvjv7fSMtubvYMFk1AYbSnDCw1p2
L0dPW5MyFcJiS5oq8VE96iYz5uRzfr+oihkTR7pYSyG2llMG29H9twf/mhAXmzcR
M7wHpFGm7BJx2MXltr5Mvw3AUQ6oY9+s6uR24kXXKqMcjMXMzjOZeRTWImg6O9vy
zY/saYHF2ZsL6enWsw5o5HH/SwlOhkdGC6+gkwc90cVG+e4YyTC0jmesaqSPqmca
aiZCKQxwKRaeEirsmDgd
=NFv0
-----END PGP SIGNATURE-----

--=-1MC/TFe1pOcpzaPEKyvd--

