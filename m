Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54364 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755400AbYKEL46 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Nov 2008 06:56:58 -0500
Subject: Re: [PATCH 2/7] cfg80211: remove switch from __regulatory_hint()
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1225853406-16322-3-git-send-email-lrodriguez@atheros.com>
References: <1225853406-16322-1-git-send-email-lrodriguez@atheros.com>
	 <1225853406-16322-2-git-send-email-lrodriguez@atheros.com>
	 <1225853406-16322-3-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-T0vjArGM6fq5TRsSvaqP"
Date: Wed, 05 Nov 2008 12:57:00 +0100
Message-Id: <1225886220.3619.78.camel@johannes.berg> (sfid-20081105_125701_423759_2E0AB96B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-T0vjArGM6fq5TRsSvaqP
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-11-04 at 18:50 -0800, Luis R. Rodriguez wrote:
> We have complete control over REGDOM_SET_BY_* enum passed
> down to __regulatory_hint() as such there is no need to
> account for unexpected REGDOM_SET_BY_*'s, lets just remove
> the switch statement as this code does not change and
> won't change even when we add 802.11d support.
>=20
> This patch has no functional changes.
>=20
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> ---
>  net/wireless/reg.c |   43 +++++++++++++++++--------------------------
>  1 files changed, 17 insertions(+), 26 deletions(-)
>=20
> diff --git a/net/wireless/reg.c b/net/wireless/reg.c
> index 7a2ce27..e44f005 100644
> --- a/net/wireless/reg.c
> +++ b/net/wireless/reg.c
> @@ -698,34 +698,25 @@ int __regulatory_hint(struct wiphy *wiphy, enum reg=
_set_by set_by,
>  	else if (r)
>  		return r;
> =20
> -	switch (set_by) {
> -	case REGDOM_SET_BY_CORE:
> -	case REGDOM_SET_BY_COUNTRY_IE:
> -	case REGDOM_SET_BY_DRIVER:
> -	case REGDOM_SET_BY_USER:
> -		request =3D kzalloc(sizeof(struct regulatory_request),
> -				  GFP_KERNEL);
> -		if (!request)
> -			return -ENOMEM;
> -
> -		request->alpha2[0] =3D alpha2[0];
> -		request->alpha2[1] =3D alpha2[1];
> -		request->initiator =3D set_by;
> -		request->wiphy =3D wiphy;
> -		request->intersect =3D intersect;
> -
> -		kfree(last_request);
> -		last_request =3D request;
> -		r =3D call_crda(alpha2);
> +	request =3D kzalloc(sizeof(struct regulatory_request),
> +			  GFP_KERNEL);
> +	if (!request)
> +		return -ENOMEM;
> +
> +	request->alpha2[0] =3D alpha2[0];
> +	request->alpha2[1] =3D alpha2[1];
> +	request->initiator =3D set_by;
> +	request->wiphy =3D wiphy;
> +	request->intersect =3D intersect;
> +
> +	kfree(last_request);
> +	last_request =3D request;
> +	r =3D call_crda(alpha2);
> +
>  #ifndef CONFIG_WIRELESS_OLD_REGULATORY
> -		if (r)
> -			printk(KERN_ERR "cfg80211: Failed calling CRDA\n");
> +	if (r)
> +		printk(KERN_ERR "cfg80211: Failed calling CRDA\n");
>  #endif
> -		break;
> -	default:
> -		r =3D -ENOTSUPP;
> -		break;
> -	}
> =20
>  	return r;
>  }

--=-T0vjArGM6fq5TRsSvaqP
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJEYoIAAoJEKVg1VMiehFYg0cP/jTa+UqksEKldbJH7prYerYq
wMuHMYoKYwoXo5Cr1rVZSXc62ajjcMdGvg5Jd6gLp0Zbg5b0Ho302buTQq/Rtyi+
OtSixn/d1M13uI6ADg0OmKIoOVoc9DkiBQMAQMUxR4yvMzwh1hl//2duH7yI9uYx
vKrSxH8VbI9PiNrmj3JE8K5Ggu89JwuKLr1DQAtXCnEomWePAD7PMx6a9VdLHr7R
ho6XqbLHmpp+bFgCSmmNTdQ9DPJCc4s0AsQrJMLqGrOv5fCx1ukpEdzkkuy0vk73
1nAZiZqKwWaEJHy+02wKTfNkEI7XmrjhM82ksRb9Q8KPEvuoovoUl5DRFas0tWqB
f+s1H3dfCPOPAtMq0BAty00d7YgQaODDAJWn2puQOs5/qm7V2oHURil0d/ltSwFY
1QDHAKZnuGJEgplm4N92jxdxHXtPA/pahAj+gZy3zeKp8REyy4eULDUmYb9ywFZZ
sZQbWp/2jzSKRyIZTdDICPCfoNSV9E2RZvu8y4rKrQ++u80i0EucxIIw8NQ6/G6m
rvxnvhLaITrDQXfy2aj2OegFKOSEP7qlA4KdFtfTF3G6fFnld9/Ldv7WUV8vUlS8
ghsEpAV2oM2A5fJvCojwlC6zVkXNMyAEmVHfnv8XHB4R1UYocBvSuN76Z1211+5M
sBmDjQ3jVeaTAhDPpSnS
=q8tU
-----END PGP SIGNATURE-----

--=-T0vjArGM6fq5TRsSvaqP--

