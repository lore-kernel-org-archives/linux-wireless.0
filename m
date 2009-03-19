Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40044 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755847AbZCSSpk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Mar 2009 14:45:40 -0400
Subject: Re: [PATCH 2/4] mac80211: Fix reassociation by not clearing
 previous BSSID
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <jouni.malinen@atheros.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20090319114800.533740586@atheros.com>
References: <20090319113918.555693846@atheros.com>
	 <20090319114800.533740586@atheros.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-BLmk39ROMsZ1DiaDEDZS"
Date: Thu, 19 Mar 2009 19:45:35 +0100
Message-Id: <1237488335.5100.102.camel@johannes.local> (sfid-20090319_194541_902945_6475F5A6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-BLmk39ROMsZ1DiaDEDZS
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-03-19 at 13:39 +0200, Jouni Malinen wrote:
> plain text document attachment (mac80211-reassoc-fix.patch)
> We must not clear the previous BSSID when roaming to another AP within
> the same ESS for reassociation to be used properly. It is fine to
> clear this when the SSID changes, so let's move the code into
> ieee80211_sta_set_ssid().
>=20
> Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> ---
>  net/mac80211/mlme.c |    6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>=20
> --- uml.orig/net/mac80211/mlme.c	2009-03-19 00:20:04.000000000 +0200
> +++ uml/net/mac80211/mlme.c	2009-03-19 00:20:52.000000000 +0200
> @@ -1888,8 +1888,6 @@ int ieee80211_sta_commit(struct ieee8021
>  {
>  	struct ieee80211_if_managed *ifmgd =3D &sdata->u.mgd;
> =20
> -	ifmgd->flags &=3D ~IEEE80211_STA_PREV_BSSID_SET;
> -
>  	if (ifmgd->ssid_len)
>  		ifmgd->flags |=3D IEEE80211_STA_SSID_SET;
>  	else
> @@ -1908,6 +1906,10 @@ int ieee80211_sta_set_ssid(struct ieee80
>  	ifmgd =3D &sdata->u.mgd;
> =20
>  	if (ifmgd->ssid_len !=3D len || memcmp(ifmgd->ssid, ssid, len) !=3D 0) =
{
> +		/*
> +		 * Do not use reassociation if SSID is changed (different ESS).
> +		 */
> +		ifmgd->flags &=3D ~IEEE80211_STA_PREV_BSSID_SET;
>  		memset(ifmgd->ssid, 0, sizeof(ifmgd->ssid));
>  		memcpy(ifmgd->ssid, ssid, len);
>  		ifmgd->ssid_len =3D len;
>=20
> --=20
>=20

--=-BLmk39ROMsZ1DiaDEDZS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJwpLMAAoJEKVg1VMiehFYVUQP/1vgf4yF3Z0Df1796uu+bOtw
mh8/dKBeFxz45XZXIrCNTDa5sBfWTQe8HK3WF7M8dggeFst1X/BXxbgpJU7olKAX
lDj6O0Z9okDZPDSIHBhl71OJgw0A4QXFPZdo9jQThX5XFSlVQ7zeKarg4X4eCKB3
SUIr2oJHUMEcjN61kQ3pS4PCWjK9pZ3Vt59er+MC+uuiqFmuuGIeAuSurXAOrpRW
D9J6grLo66zI4EGYfJJAqQ5NCSmvyxUWiiiZNRc0ot4hLuodaSCIe2beRN19Drnz
0ih/F9K2O210dtTCCNGSNk0SBFUOcl5BjEMT+EGlN+quHCeuI9JQjDhjqqwXkR5W
Ez1qypTSD2Qlo5rQC4o3RlYKS8Y3R2bZ2+slq9dkl76p9UXp5G5e5oBR6Qt0DPS5
Y9Gt6KTuEpnfMscIPWmcbwHHMzgSil5EV+Ys8WQFft1HkVmQ3EmlfmIgMnGN0wCX
NWuwTS2bgqXhxEenqSC7RUa3IyJp/QDi56ygYJK5x9wOxG26u8UnZszYwpb8igVm
bwbOv6CW7jzRN9hfTrBhV15AqVraSG5D/vEGyiNOg5BeW5SI3otM6MM+PeYs8CQ6
kOsMhTZdq55a9ESmrBJuLfmV7RZb7lnOxJvQxQMABj9/6vWLvO0ZgIBPPxNtNmdb
If+LdTqC1RsobBkf/Ak7
=Bmsw
-----END PGP SIGNATURE-----

--=-BLmk39ROMsZ1DiaDEDZS--

