Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:53446 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758628AbXHPNUH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Aug 2007 09:20:07 -0400
Subject: Re: [PATCH 4/4] hostapd: remove PRISM2_PARAM_NEXT_MODE
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20070816013803.GR1415@jm.kir.nu>
References: <20070814093254.021041000@sipsolutions.net>
	 <20070814093410.322846000@sipsolutions.net>
	 <20070815024135.GF1415@jm.kir.nu> <1187174682.3998.6.camel@johannes.berg>
	 <20070816013803.GR1415@jm.kir.nu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Jy1Xp5mX2xq9W2jz3Qb4"
Date: Thu, 16 Aug 2007 15:22:50 +0200
Message-Id: <1187270570.5141.46.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Jy1Xp5mX2xq9W2jz3Qb4
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-08-15 at 18:38 -0700, Jouni Malinen wrote:

> I don't linke next_mode either, so if this is combined to a single
> atomic operation, it would be quite a bit better way to do this.

Yeah, we'll have that if somebody gets around to it.

> I would assume that the quick workaround for this would have been to
> change the configuration file to use 802.11g instead of the default
> i802.11b..=20

Oh, it was :) But it wasn't obvious.

> Anyway, the design used here does indeed assume that the
> driver exports all supported mode/channel pairs and in case the hardware
> card supports 802.11g, the driver would most likely claim support for
> both 802.11b and 802.11g channels.
>=20
> Adding code for reverting back to 802.11g version would, in theory, be
> fine for most cases, but it does have some issues.. If I remember
> correctly, channel 14 may only be used with 802.11b mode in Japan, so
> the list of 802.11b and 802.11g channels is not the same. In this
> particular case, though, the workaround of using 802.11g list would not
> cause a problem (the other direction would potentially have).

Hmm. That seems like something to be integrated with the regulatory code
rather than the driver.

johannes

--=-Jy1Xp5mX2xq9W2jz3Qb4
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGxE+q/ETPhpq3jKURAlH/AJ471M/4sej64fSOYlbYd22rtQWkFwCdGGDW
eHFM+LUgl2DI8y64EUKNqZI=
=5JjJ
-----END PGP SIGNATURE-----

--=-Jy1Xp5mX2xq9W2jz3Qb4--

