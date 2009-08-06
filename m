Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:57014 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837AbZHFJGU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Aug 2009 05:06:20 -0400
Subject: Re: [PATCH] cfg80211: fix disassociation warning due to misuse of
 wdev->current_bss
From: Johannes Berg <johannes@sipsolutions.net>
To: Pavel Roskin <proski@gnu.org>
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
In-Reply-To: <20090806085242.23637.82992.stgit@ct.roinet.com>
References: <20090806085242.23637.82992.stgit@ct.roinet.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-8Bk4+4nB0nVPGxZY3sck"
Date: Thu, 06 Aug 2009 11:06:14 +0200
Message-Id: <1249549574.4852.17.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-8Bk4+4nB0nVPGxZY3sck
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-08-06 at 04:52 -0400, Pavel Roskin wrote:
> WARN_ON was triggered at mlme.c:213 when dissociating from an AP.
>=20
> wdev->current_bss->pub.bssid should be used in place of
> wdev->current_bss for BSSID comparison.

Oh wow, good catch, thanks.

Reviewed-by: Johannes Berg <johannes@sipsolutions.net>

> Signed-off-by: Pavel Roskin <proski@gnu.org>
> ---
>  net/wireless/mlme.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>=20
> diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
> index 525e8e2..b44b6c0 100644
> --- a/net/wireless/mlme.c
> +++ b/net/wireless/mlme.c
> @@ -198,7 +198,7 @@ static void __cfg80211_send_disassoc(struct net_devic=
e *dev,
>  		return;
> =20
>  	if (wdev->current_bss &&
> -	    memcmp(wdev->current_bss, bssid, ETH_ALEN) =3D=3D 0) {
> +	    memcmp(wdev->current_bss->pub.bssid, bssid, ETH_ALEN) =3D=3D 0) {
>  		for (i =3D 0; i < MAX_AUTH_BSSES; i++) {
>  			if (wdev->authtry_bsses[i] || wdev->auth_bsses[i])
>  				continue;
>=20


--=-8Bk4+4nB0nVPGxZY3sck
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKep0DAAoJEODzc/N7+QmaQvEP/0GIDg2uLE5nuz7Wwv7BH3Ho
EgL/2rg04h1jaCbOMMUtODvr0A/i/tZyjsYCQ39l5nIYf98PX9Mvc10RFcB9oeN9
IGlAHPbJeUc9dLcwjmbMwqwi3svSNyIOsGBUdo6jrHh6WCWb/gK/Iy6wTPk+PqN+
jujiVA+WGtfwYQcFGWlTrgFrQbKda/out0N6Hne2ibvVECVk8gjvUY8wKondudW2
HHJwaOLdEE63yoecoQf07oP8NFTVbzWHNRYoog2aaW1c28JnoOS23jds2nLzZHtk
10GmUhinWFtOLFQWCd96xqVM8op92LJhWMr6ME3aMds48GqBXGzGfDxTJcnlZr5z
xeehpengKwnYAQ/kigqxHWL3fRVuwCLepH+82DMsr0r98lgtCoekB5KQwpRYC+z9
/OxRv4siL1Q1T1zBn0so76eADl5KW+XcEVziJ+2HIXBPDB+gVCPfRklSoddOk6jM
NsREwUWwgTNhy14DWquVtr4LgQlmuKLBe/Vq1j22LTJJ8To4TVIh0hbQQeR9bOcF
QZRlhOVOyIVdlXtg6EDcrBwHNNuTWD4EEL/QVWSXHh4RHwAKHi8lvojw4XIdOhUM
YznnsD5A6m2DY8heULAloQMwyU9QAkRjyPXN2pDqZr0CTB9C4vEuIhzhMwy5rCyz
BAoLLL8xIEtrGlp7egLz
=3wKg
-----END PGP SIGNATURE-----

--=-8Bk4+4nB0nVPGxZY3sck--

