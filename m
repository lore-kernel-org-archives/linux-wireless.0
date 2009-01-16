Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39184 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757117AbZAPJWU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jan 2009 04:22:20 -0500
Subject: Re: [PATCH 05/13] cfg80211: Fix sanity check on 5 GHz when
	processing country IE
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1232064746-17134-6-git-send-email-lrodriguez@atheros.com>
References: <1232064746-17134-1-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-2-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-3-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-4-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-5-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-6-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-gWT59e2YTMI6vE1U3MJN"
Date: Fri, 16 Jan 2009 10:21:48 +0100
Message-Id: <1232097708.3854.21.camel@johannes> (sfid-20090116_102224_629552_EEE1F6AF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-gWT59e2YTMI6vE1U3MJN
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-01-15 at 16:12 -0800, Luis R. Rodriguez wrote:
> This fixes two issues with the sanity check loop when processing
> the country IE:
>=20
> 1. Do not use frequency for the current subband channel check,
>    this was a big fat typo.
> 2. Apply the 5 GHz 4-channel steps when considering max channel
>    on each subband as was done with a recent patch.

I'll just believe you here :)

> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> ---
>  net/wireless/reg.c |   30 +++++++++++++++++++-----------
>  1 files changed, 19 insertions(+), 11 deletions(-)
>=20
> diff --git a/net/wireless/reg.c b/net/wireless/reg.c
> index 77e45c7..0cc19e7 100644
> --- a/net/wireless/reg.c
> +++ b/net/wireless/reg.c
> @@ -498,6 +498,7 @@ static struct ieee80211_regdomain *country_ie_2_rd(
>  	 * calculate the number of reg rules we will need. We will need one
>  	 * for each channel subband */
>  	while (country_ie_len >=3D 3) {
> +		int end_channel =3D 0;
>  		struct ieee80211_country_ie_triplet *triplet =3D
>  			(struct ieee80211_country_ie_triplet *) country_ie;
>  		int cur_sub_max_channel =3D 0, cur_channel =3D 0;
> @@ -509,9 +510,25 @@ static struct ieee80211_regdomain *country_ie_2_rd(
>  			continue;
>  		}
> =20
> +		/* 2 GHz */
> +		if (triplet->chans.first_channel <=3D 14)
> +			end_channel =3D triplet->chans.first_channel +
> +				triplet->chans.num_channels;
> +		else
> +			/*
> +			 * 5 GHz -- For example in country IEs if the first
> +			 * channel given is 36 and the number of channels is 4
> +			 * then the individual channel numbers defined for the
> +			 * 5 GHz PHY by these parameters are: 36, 40, 44, and 48
> +			 * and not 36, 37, 38, 39.
> +			 *
> +			 * See: http://tinyurl.com/11d-clarification
> +			 */
> +			end_channel =3D  triplet->chans.first_channel +
> +				(4 * (triplet->chans.num_channels - 1));
> +
>  		cur_channel =3D triplet->chans.first_channel;
> -		cur_sub_max_channel =3D ieee80211_channel_to_frequency(
> -			cur_channel + triplet->chans.num_channels);
> +		cur_sub_max_channel =3D end_channel;
> =20
>  		/* Basic sanity check */
>  		if (cur_sub_max_channel < cur_channel)
> @@ -590,15 +607,6 @@ static struct ieee80211_regdomain *country_ie_2_rd(
>  			end_channel =3D triplet->chans.first_channel +
>  				triplet->chans.num_channels;
>  		else
> -			/*
> -			 * 5 GHz -- For example in country IEs if the first
> -			 * channel given is 36 and the number of channels is 4
> -			 * then the individual channel numbers defined for the
> -			 * 5 GHz PHY by these parameters are: 36, 40, 44, and 48
> -			 * and not 36, 37, 38, 39.
> -			 *
> -			 * See: http://tinyurl.com/11d-clarification
> -			 */
>  			end_channel =3D  triplet->chans.first_channel +
>  				(4 * (triplet->chans.num_channels - 1));
> =20

--=-gWT59e2YTMI6vE1U3MJN
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJcFGqAAoJEKVg1VMiehFYSl8P/2vfb7JNT+13doLIovGGUl0q
PwKZPiwsEjqLBoxvQqF3/2oblfFNymoG8ApKwSHSr8Sv/ynR2g9BldYxrNUu8CL9
aXMyFq72fhuku3JUAz0viQ7EVwLvHHsS/rjVIG1XRlRxdDCmofzEPMIap0wq9I1W
y4aMZOhADONdlD4vMSMgXYx4eh7F3L2Ajy8WxpgPTaibfTqWlqp34Bscv91ponyU
zfhNR+eLJwBheh/MMxDMHD6SqOx+FiAaDtiMLWEU10sncuTPV2kwmQj0r/AGTfQj
h+WNe5A/r2DfPmlSWskPp3MdnMV/E09CjX90WiYzsjOktbq85wOQnDT5N2+fSYpJ
zeBbyFcGMFIQ+B5TFTtMtlXQZtnkUhmO0H4xjzU8YD2Oi1+ji/mN16G1tvsK6Yj5
0jTSMfvtvd3LQ/CgFKu4+bFl7x98kKvI6xdaGU5jzoFhdjgZi1GRIIO1qcCkDo5i
2dOL/EpDge6wm2IswWM6mARvX9CwLnMrsbr7d0UhM1UHgZ18rnM/E/ni0QePV4Nx
Ez3v2ugIjS7Bkr48iWCNdaFyJva9EN6AXiEvBhySbyEBtErMGjpNgBI9pOmkhGTH
j77f1uQ5EH3KmZG9Wy6qmdKlVX0v+GBKB4ap2d1fb8Dkgb3bEGtkZ8powleSKamM
hMmj6xmAslXF+bUeZrUp
=oPEt
-----END PGP SIGNATURE-----

--=-gWT59e2YTMI6vE1U3MJN--

