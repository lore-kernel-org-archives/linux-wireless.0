Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44924 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763659AbZAPJ1F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jan 2009 04:27:05 -0500
Subject: Re: [PATCH 10/13] cfg80211: remove check for last_request on
	ignore_reg_update()
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1232064746-17134-11-git-send-email-lrodriguez@atheros.com>
References: <1232064746-17134-1-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-2-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-3-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-4-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-5-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-6-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-7-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-8-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-9-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-10-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-11-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Q+AC/91f3yC5btSnPgb5"
Date: Fri, 16 Jan 2009 10:26:30 +0100
Message-Id: <1232097990.3854.31.camel@johannes> (sfid-20090116_102710_558140_0A2DD40F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Q+AC/91f3yC5btSnPgb5
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-01-15 at 16:12 -0800, Luis R. Rodriguez wrote:
> There is no need to check for last_request as the callers of
> update_all_wiphy_regulatory() ensure its present.

Are you sure? I had all this blow up all around me.

> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> ---
>  net/wireless/reg.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
>=20
> diff --git a/net/wireless/reg.c b/net/wireless/reg.c
> index 8bf999d..6c45832 100644
> --- a/net/wireless/reg.c
> +++ b/net/wireless/reg.c
> @@ -1006,8 +1006,6 @@ static void handle_band_custom(struct wiphy *wiphy,=
 enum ieee80211_band band,
> =20
>  static bool ignore_reg_update(struct wiphy *wiphy, enum reg_set_by setby=
)
>  {
> -	if (!last_request)
> -		return true;
>  	if (setby =3D=3D REGDOM_SET_BY_CORE &&
>  		  wiphy->custom_regulatory)
>  		return true;

--=-Q+AC/91f3yC5btSnPgb5
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJcFLDAAoJEKVg1VMiehFYm0EP/ifnZu2FN7svH4zh/OJu1QZv
79wY7C7dfHdI+aDHH85XjIpWLZ69eTnPnez3bBrVXgc5YYS4Nnmdlv0ZR5mIFXFQ
FFCV3kOQcD/B0wX8t+7oEM9UQJTvgJZK2E+T86dMou8hUL1ExgM/yzq2LPWI6PTV
wXAP7n8iPWamcNK+h6MOqVPRtdqWNCBXzH67k4SDg8g/XRIp/smWIE6SBEGsnYj0
+2wo2yLDFIhGriL4U23FClw0Dnd9mF7xfIQFhKuI+lKwTrJZYnmuJekdNzjBWFIb
zRXAcGVUGPYmuEZLU4+ug4bmzfdhRv5fAAh5LcTzjne3PnQRhIL4wpCe7q7cG51t
Ksk8aG0njUMNEk15FvclGQFslK09EpyudmiGkucj+Su5OowCcbGrCidCcX2nPg5v
wSrRsfdDfMYnJGQI1/SrCLl21fqplUGRqFX8Fn3lWYFDVVYGVr9n4hinrLL6wKQT
nkPX0ojQhGMNlJgniWcwFMcIWenAoVNsYXIRYIguX4sJS2rnTJe9fQ1u98YBZ4b/
j4FTKD9DnCDxYDoTDkrU62ubctTakBaOFdpIUtvEUvjZlFOnq8sHE/3kO8dzc1SW
GDBuyYFm2SMHtnCBRyic9XYgxQB7DkTnYsolHxoUTIEVs3lnpqq5g2QO6dU6iQlf
uSe+1oamMlFYjSC/a+yu
=mIk+
-----END PGP SIGNATURE-----

--=-Q+AC/91f3yC5btSnPgb5--

