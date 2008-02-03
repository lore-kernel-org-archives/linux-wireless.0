Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:59451 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752134AbYBCMmi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Feb 2008 07:42:38 -0500
Subject: Re: [PATCH] wireless: Fix WARN_ON() with ieee802.11b
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200802022353.10286.IvDoorn@gmail.com> (sfid-20080202_225341_324871_B982F579)
References: <200802022353.10286.IvDoorn@gmail.com>
	 (sfid-20080202_225341_324871_B982F579)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-9vWQEAxP67zKYF8bFMQK"
Date: Sun, 03 Feb 2008 13:42:33 +0100
Message-Id: <1202042553.4188.122.camel@johannes.berg> (sfid-20080203_124241_130239_5D1A1136)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-9vWQEAxP67zKYF8bFMQK
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Sat, 2008-02-02 at 23:53 +0100, Ivo van Doorn wrote:
> When the driver registers a IEEE80211_BAND_2GHZ band,
> it can either be 802.11b or 802.11g. But when 802.11b rates
> are registered "want" will be 3 (since 4 rates are being registered,
> and each of those 4 rates will decrease "want").
> Since this is a correct situation, there is no need to trigger
> a WARN_ON() for this.
>=20
> Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> ---
> diff --git a/net/wireless/util.c b/net/wireless/util.c
> index 0dcccbf..5304c62 100644
> --- a/net/wireless/util.c
> +++ b/net/wireless/util.c
> @@ -80,7 +80,7 @@ static void set_mandatory_flags_band(struct ieee80211_s=
upported_band *sband,
>  				sband->bitrates[i].flags |=3D
>  					IEEE80211_RATE_ERP_G;
>  		}
> -		WARN_ON(want !=3D 0 && want !=3D 6);
> +		WARN_ON(want !=3D 0 && want !=3D 3 && want !=3D 6);
>  		break;
>  	case IEEE80211_NUM_BANDS:
>  		WARN_ON(1);
>=20

--=-9vWQEAxP67zKYF8bFMQK
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR6W2uKVg1VMiehFYAQLO8A//e2an9Oj6Spy6KoMzsEcZZg2MyCTU8ic2
wXvXl+3IH47BOQGWIeAMbyvPsBVJbCf+Wu5ajip6UtiUBewGk4oobrra5yJ2kDkJ
Nv12MdDqezZlNoCGlS3ZG/y7CKbMCX1CUUZ0bILjN5gJEl4OYAxaUjXqPk/kh2Ti
hsD/HfDstMGHOw6KcEaGUqksN2YdgI2Q1+oDvzX9ips/SE9fef/3o0Y1mx0nAGpV
y4KFqQW41McAM8TqvPbilH3qIN3SXoBrFhqAPuhdnECifSixlCoWwH7NIwW9l7Ks
uqvOqkJF4i/KZnBJkYq2Q/509hpbAFZA5I4ePaKVqAnSRkYNk4BdRpHAJwVSiIaP
oqR4mkRixaBqYht9mvJZTM17VHJW+w9o+KPOn9p6O2skkCkkfshw0zqft2icndB2
qxQFLaCDt5o+3b58w9kFmz1g27eB5UN2lmAURzVCIxzPI14ncNxqXQg1ym17LTFr
s0Y3qwCaUxyOgbeqgU81hhsb9MKkIdol937ncS1AheF4w7dbUw3yzd/Odjl6KBvG
T5ccfpUg9oYyDZFFkCDS4XQmZEmeFyznko8Fy/kVRBFbAIz5Rts3VQBq0L+xVQy0
RwgtjEL54hBvWDpUEITtQNh+XVoIsglIrapHZSMWA7urguKkPktBT3XIij7wWoQv
GpkRaQSXN4o=
=LyLk
-----END PGP SIGNATURE-----

--=-9vWQEAxP67zKYF8bFMQK--

