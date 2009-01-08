Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49523 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695AbZAHMZA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Jan 2009 07:25:00 -0500
Subject: Re: [PATCH 12/14] mac80211: 802.11w - Optional software CCMP for
	management frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Jouni Malinen <jouni.malinen@atheros.com>,
	Dan Williams <dcbw@redhat.com>
In-Reply-To: <20090108121839.GA20687@jm.kir.nu>
References: <20090107112346.369581673@atheros.com>
	 <200901081057.46495.helmut.schaa@gmail.com>
	 <20090108104822.GA12480@jm.kir.nu>
	 <200901081308.23046.helmut.schaa@gmail.com>
	 <20090108121839.GA20687@jm.kir.nu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-r1D/5sfklCpUA+GODp/J"
Date: Thu, 08 Jan 2009 13:25:55 +0100
Message-Id: <1231417555.4270.3.camel@johannes> (sfid-20090108_132505_905846_FC559105)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-r1D/5sfklCpUA+GODp/J
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-01-08 at 14:18 +0200, Jouni Malinen wrote:

> Agreed and it should be relatively small change in wpa_supplicant, so
> I'm not against doing this. However, at this point I would not yet
> recommend trying to use driver_nl80211 as the first option. Once we get
> nl80211 bit more complete and at least make sure it does not break
> something, adding the automatic driver selection would sound more
> reasonable. Though, this would also mean that we depend on drivers never
> implementing partial nl80211 support that could trigger wpa_supplicant
> into believing that they support nl80211 when they would actually work
> much better with wext.

That's not _much_ of a problem, considering that driver_nl80211 is using
wext, and cfg80211 will continue providing wext calls. Therefore, older
versions of wpa_supplicant will continue working on newer kernel
versions that have more stuff in nl80211 rather than wext, the only
problem could come up when using a "too new" wpa_supplicant on an older
kernel with older nl80211. That's easy to detect though by checking
which commands nl80211 supports, and refusing to work with it unless all
commands that driver_nl80211 needs are implemented.

johannes

--=-r1D/5sfklCpUA+GODp/J
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJZfDPAAoJEKVg1VMiehFYFbwP/imnhN6qrWEuozk2Dj965yH3
uc+fpl4aE/0f2SUE7hsVFHW67GHRvHLaGf4b7cETkYPvyg66OZemeaE8nNR1g8q4
gFB2OTVHv3/7FEhcnNJ5qTQWole9gzebGjZm3d9OpdD4tzIy3mbCNYkCWDmNcwgS
ukrUaA9lFEttyFWKe8tqYaLE6cYFyLgFNHYbH7+Ce9bDMtnDuFSyLRDjkLPGKvxR
6dPTXfbEdeleLIRHB2V6c9NbR0EjvV8niPzqPodtv5FAP3JFfpM/puAu3VL+UmGv
Wz3WoGrmSuIjTu0AUS54ACZ3yJ4Z0+c1bIh1ixJK3OF++Xo6vQkn41Ubqv38ETbB
mK8GuAM2D0EQH3uiGBnKT+7n0YjLGXUjj+R9UzZynmgCyxbXr8Fop9/NKNzT9HIa
7pVJWyLVs+cNuAhuYZnd+Xz/JWuCP28iriRGBVnOUAnRIBPEY8//BzbzTNgSChCL
lU+L5aYOL+iGpxp5KPw46II4EObD1HP6GJUB8KDrBBDk+2zaqty76JHVctMW+zsN
UnIA0IjoeBG+iVR6x61nklk4neVEYOsv0zptWTsO3KJk34yUzEi9WmH8c1EyQOAE
fpMD9jW8F7RQg3PmiWIXV6h8FRuDxZfWsqKnOkNlneuul9NKLILxyQl/nRJG/CwM
G1mzQE+PEfYo9gqMQRpA
=U9/t
-----END PGP SIGNATURE-----

--=-r1D/5sfklCpUA+GODp/J--

