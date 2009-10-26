Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50190 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754269AbZJZNDv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Oct 2009 09:03:51 -0400
Subject: Re: Questions about cfg80211's cfg80211_connect_params->crypto
 settings
From: Johannes Berg <johannes@sipsolutions.net>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200910261359.13658.hs4233@mail.mn-solutions.de>
References: <200910260947.48365.hs4233@mail.mn-solutions.de>
	 <200910261311.47164.hs4233@mail.mn-solutions.de>
	 <1256559734.28230.23.camel@johannes.local>
	 <200910261359.13658.hs4233@mail.mn-solutions.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-8EjVqt5A9rel3zlmntLW"
Date: Mon, 26 Oct 2009 14:03:53 +0100
Message-ID: <1256562233.12462.3.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-8EjVqt5A9rel3zlmntLW
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-10-26 at 13:59 +0100, Holger Schurig wrote:

> lbs_cfg_connect:
>     if (sme->bssid set)  {
>         # I need a full cfg80211_bss entry, because I can only
>         # associate to a specific bss via CMD_802_11_ASSOCIATE
> 	# and I need
> 	#   bss->capability
> 	#   bss->bssid
> 	#   bss->get_ie(WLAN_EID_SSID)
> 	#   bss->channel
> 	#   bss->rates
>         bss =3D cfg80211_get_bss()

You need sme->privacy here.

> However, this current setup makes "iw abc connect SSID"=20
> non-working with libertas. It would work with libertas if I=20
> would use the .auth/.assoc API, because then net/wireless/sme.c=20
> would scan for me. But in the .connect API case, it doesn't do=20
> this.
>=20
> But information I get in the .connect() call aren't sufficuent=20
> for the Libertas firmware interface, I need more data, which I=20
> can get from a cfg80211_bss entry.
>=20
> One possiblity is that net/wireless/sme.c get's more general and=20
> does scan in the .connect() case, too.
>=20
> Or I could substitute the "error_out" with a local scan, and then=20
> select the "best" AP from the bss list. I fear however that such=20
> a selection function might already be somewhere inside=20
> net/wireless/*.c, I'll need to search for that.

There isn't really. It _might_ be possible to further abstract this out,
but that means we need to _first_ be able to advertise device roaming
capabilities so that we _don't_ select a specific BSS for devices that
want to handle roaming like iwm.

johannes

--=-8EjVqt5A9rel3zlmntLW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK5Z41AAoJEODzc/N7+QmavvsP/AqEbFm2accQBL4su6hD0rDc
9dfqu7PoDnoZSLO/SyJ6BAP3iO/wtrWEEG3nhgAgOdZd0m6679Rh+U7ET/fHFsB/
t4GPLEe/b/f2qGoB6Oqmcv2ReLv1AwpgmYHIIdROsN+PGYLDUIQv0GUAKCcSaQkL
JCHWDMFt4L0z+HoUK/4Fa8lD4CNe84u6Rk+1bwJq2nzEaINEuWJU2ogbYQF+h2qe
vaedLEdmswSiOHB59UhYUt44NWMBnHuPCKUlz1qQDr/kWNp1bLsjS5PYmrxFPfIM
C2O5ZmMuuKizOxJhkzepFRl8QqZ4ii7rrOUxZ1ilvm8FmY8P9BRgifwnoEV51+Sj
TS+LpFrHs4vCrv9AeLtEsG2luB1EP4wwgJLBb+jkA8sdwhvxBvv2/Jpr86H4PtpW
Yp+yjxx1VwxmCWIBhyCA/0ebn7nYA8pC+CuOUVZ6ZoYxPpH8Q/pR0C9cqeVzLe9W
G4rkfRatqnljaJWCw76wDHKo/Gj8oB7OJuL5dVIEm88qi3pjGnJY3M+71w0ImKvb
iHCZqQgGdDDFmdaCPOE/ILZW+4b/FyyDt9tNBpiE11h5rKIS+75NpL1TufH3DMpp
lIf5P6uDhbbJznpJBe06t5OiDKiObgj0cL1WknVmlBIT+iPsJomV2Cfl5pMtpMJo
593rV2pI+zO15qaJWpcC
=Eh1O
-----END PGP SIGNATURE-----

--=-8EjVqt5A9rel3zlmntLW--

