Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:46606 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563AbYBCKV2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Feb 2008 05:21:28 -0500
Subject: Re: [PATCH] wireless: Fix WARN_ON() with ieee802.11b
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200802022353.10286.IvDoorn@gmail.com> (sfid-20080202_225341_324871_B982F579)
References: <200802022353.10286.IvDoorn@gmail.com>
	 (sfid-20080202_225341_324871_B982F579)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-clFC+NHCwAxHS1BAO80S"
Date: Sun, 03 Feb 2008 11:21:22 +0100
Message-Id: <1202034082.4188.116.camel@johannes.berg> (sfid-20080203_102132_566035_32C131ED)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-clFC+NHCwAxHS1BAO80S
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> When the driver registers a IEEE80211_BAND_2GHZ band,
> it can either be 802.11b or 802.11g. But when 802.11b rates
> are registered "want" will be 3 (since 4 rates are being registered,
> and each of those 4 rates will decrease "want").

Huh, yeah, you're right, this is a thinko.

> -		WARN_ON(want !=3D 0 && want !=3D 6);
> +		WARN_ON(want !=3D 0 && want !=3D 3 && want !=3D 6);

However, I think it should just be

		WARN_ON(want !=3D 0 && want !=3D 3);

6 just doesn't make sense, does it?

johannes

--=-clFC+NHCwAxHS1BAO80S
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR6WVoKVg1VMiehFYAQJQrBAAiblK/2YXbpfo6IY9NtW0QUaIrKuaoge8
ZmisWkuyFYxny6FTn5RGG+Oh0rKA5+YhrjYcGS1FTgpolJhysNy0EUbl/JWSVt6/
gvYK5A49pBU7Vt2BuF9qoHGxMC0iG688gUpPtAfMXMJAOfh+qhktKGKyyQYRQNvN
9gFqgqz4NpSSQYVxXO/vjiF7VqIA2YzClD4rWLaCm9jwQ0OQ6Dl5TPbZFq4eUWHw
fETQ9CUpM/Fl6UL4JfVHS75uVcLE0Ai26gNARYSGq8MhzD3tHFFBUsyqkubvIYlR
10aRDp1jXjJkyrazkJJ2XhvO9veunzuyHItvXGBk0MmU3zpXFJXl1IWb/9SeD69w
Wwdr0uBx3MoviI0aWGcWbE+ncWMrNegYm+3bsnRfCUxKht2RgTYdxS+tCZPgps/2
8T8eoQc9g0IokHGMlfC3DhHwI1MKPcy1qFRa/H5EZPTAapqZLLJ0txi5uuS3WNTR
2n2FaUFyYd0pq3tMY1br8ybRyMCLSCy7Zy8mXSz2xuPD8yC1Zpow2c/BLEW9FLSM
rBG3VO0aG8/BIXTjQoF8RWQAhaq2Y46o1hr8PiIctxl1ndfPgRhvnilJjyxingpF
xqUgQmXhg3rER8nT6S+yjhffEwYS0HmBYfA0bsx+/PNg54WXyJySnzjOmr8lAs+y
dZ0s2B6jRdk=
=+ZAX
-----END PGP SIGNATURE-----

--=-clFC+NHCwAxHS1BAO80S--

