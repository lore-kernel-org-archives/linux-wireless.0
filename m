Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:49708 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895AbbKZMP6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Nov 2015 07:15:58 -0500
Date: Thu, 26 Nov 2015 12:15:51 +0000
From: Mark Brown <broonie@kernel.org>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: kernel-build-reports@lists.linaro.org,
	linaro-kernel@lists.linaro.org, linux-next@vger.kernel.org,
	ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Message-ID: <20151126121551.GE1929@sirena.org.uk> (sfid-20151126_131715_207572_5602D4FC)
References: <E1a1sVV-00079q-My@optimist>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="m4E4Spob7u7JiHeu"
In-Reply-To: <E1a1sVV-00079q-My@optimist>
Subject: Re: next-20151126 build: 3 failures 15 warnings (next-20151126)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--m4E4Spob7u7JiHeu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Nov 26, 2015 at 09:06:25AM +0000, Build bot for Mark Brown wrote:

Today's -next fails to build an arm64 allmodconfig due to:

> 	arm64-allmodconfig
> ../drivers/net/wireless/ath/ath10k/thermal.c:119:6: error: redefinition of 'ath10k_thermal_event_temperature'
> ../drivers/net/wireless/ath/ath10k/thermal.c:136:6: error: redefinition of 'ath10k_thermal_set_throttling'
> ../drivers/net/wireless/ath/ath10k/thermal.c:162:5: error: redefinition of 'ath10k_thermal_register'
> ../drivers/net/wireless/ath/ath10k/thermal.c:216:6: error: redefinition of 'ath10k_thermal_unregister'

This is happening because there are stub functions provided in the
driver's thermal.h for !THERMAL cases but these are guarded by an #ifdef
not an #if and so fails to do the right thing if the thermal code is
built as a module.  It looks like this was somehow triggered as part of
the reorganisation of the WiFi directory structure.

--m4E4Spob7u7JiHeu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJWVvf2AAoJECTWi3JdVIfQuiYH/23woji0tzwwjNpKGq5bC2ey
9rl97Fivok7v2kwAx0FvEOgMySjQRhD9YwkYQNeYx/o4C5Tgh94R3kIyDjZD/Aec
I7iYgjtmbp8zuGA1BQO9nAss+6GInScz08YW3Al6eUOM2dT4/3TeEK/BAiX+MqVZ
Fnt3d9OMpDJppjgI3cZRF0Px3WYwtVhwRVKm+YpNAgbYodR5S2uRq/6IjQzeuPZI
0l8X3jhN1KpYth3Yr4aGKQuEbHqkoBYQbMN5iO5AYRcS2QbRGVtTMjxmpBDQAt+D
lKJavV6kA/1kCf/ba8A3Aduvz45+Ka/H1T3kim/F7rBwQb4t8aSu1J1J6eYKBmQ=
=bf0c
-----END PGP SIGNATURE-----

--m4E4Spob7u7JiHeu--
