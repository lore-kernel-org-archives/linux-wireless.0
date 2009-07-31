Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35260 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300AbZGaRwf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2009 13:52:35 -0400
Subject: Re: [PATCH] cfg80211: fix regression on beacon world roaming
 feature
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Jouni Malinen <jouni.malinen@atheros.com>
In-Reply-To: <1249001028-15110-1-git-send-email-lrodriguez@atheros.com>
References: <1249001028-15110-1-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-i4LOliFA/MYn4hjKrBRV"
Date: Fri, 31 Jul 2009 19:52:31 +0200
Message-Id: <1249062751.14242.2.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-i4LOliFA/MYn4hjKrBRV
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-07-30 at 17:43 -0700, Luis R. Rodriguez wrote:
> A regression was added through patch a4ed90d6:
>=20
> "cfg80211: respect API on orig_flags on channel for beacon hint"
>=20
> We did indeed respect _orig flags but the intention was not clearly
> stated in the commit log. This patch fixes firmware issues picked
> up by iwlwifi when we lift passive scan of beaconing restrictions
> on channels its EEPROM has been configured to always enable.
>=20
> By doing so though we also disallowed beacon hints on devices
> registering their wiphy with custom world regulatory domains
> enabled, this happens to be currently ath5k, ath9k and ar9170.
> The passive scan and beacon restrictions on those devices would
> never be lifted even if we did find a beacon and the hardware did
> support such enhancements when world roaming.
>=20
> Since Johannes indicates iwlwifi firmware cannot be changed to
> allow beacon hinting we set up a flag now to specifically allow
> drivers to disable beacon hints for devices which cannot use them.
>=20
> We enable the flag on iwlwifi to disable beacon hints and by default
> enable it for all other drivers. It should be noted beacon hints lift
> passive scan flags and beacon restrictions when we receive a beacon from
> an AP on any 5 GHz non-DFS channels, and channels 12-14 on the 2.4 GHz
> band. We don't bother with channels 1-11 as those channels are allowed
> world wide.
>=20
> This should fix world roaming for ath5k, ath9k and ar9170, thereby
> improving scan time when we receive the first beacon from any AP,
> and also enabling beaconing operation (AP/IBSS/Mesh) on cards which
> would otherwise not be allowed to do so. Drivers not using custom
> regulatory stuff (wiphy_apply_custom_regulatory()) were not affected
> by this as the orig_flags for the channels would have been cleared
> upon wiphy registration.

Ok, so after all the discussion this seems like the best option after
all.

Reviewed-by: Johannes Berg <johannes@sipsolutions.net>

except I'm not sure about this bit:

>         chan->beacon_found =3D true;
> =20
> +       if (wiphy->disable_beacon_hints)
> +               return;

seems like the if might need to be before beacon_found=3Dtrue?

johannes

--=-i4LOliFA/MYn4hjKrBRV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKcy9bAAoJEODzc/N7+Qma2RYP/0vX5/PEJa4FcflMwaTIJxdG
MhGzZRGzGM2dnFkzUyJiibjBeH1YtgSk7v2ba/MOyZAjm4c87UjhYTiPWZf+tBtB
/OAPw4EJJIFyYEMwLNdsqbxG7/StQAfcj4ygMIPupt53RhFNFApnH7voerlnOShG
du9XoI40KitvtGrf51OQs/llaUV6vXYgH34OIstJO4x+iXJqhqbqSCwvT46hIg4L
aogf85/amEIlAnUphNwNAtRi0MViqHnen3169wTjX076ycU/6Y1BWBw0PJdIdha0
78i6GTgx+267s4wA6cb9p5eMIZKSk5mMYwgcLLExFhIS6yVRaXTR/WW57KgaA6+V
S/maoRkf6vvHPN9Swo2b56J+nym5j8gfDFeKZWR+sy2vhW8zu/QwnfQvJlxY6pXY
7hh1LZUSbJS5rBgCNks+SfY4fx8aeeEtX4om4/LkMXSU1i6JwichqhcG0d0ZKLsn
W+IDYbUGsgiWhScdvRWLYzT8083ELTL6pH/D0xzmbdLcTQx8o/mOqGhktvsCNqG7
FJqElRuoSQ0arltXTPVo3MHLhjWyFkXCYt0eiNdnfI7WNvuoDQViV4yYsVnV5pl9
q0UIaK6er7vtPdBHKYSX8lSBQdYtxzSS8uqGdPUG+6c+OrkdWWFWR72ZDSTISTiq
0AJAQknxK4t+A+X44IVP
=tURk
-----END PGP SIGNATURE-----

--=-i4LOliFA/MYn4hjKrBRV--

