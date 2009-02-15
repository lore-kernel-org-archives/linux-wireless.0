Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:46931 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176AbZBOK75 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Feb 2009 05:59:57 -0500
Subject: Re: [PATCH 05/10] cfg80211: add regulatory_hint_core() to separate
	the core reg hint
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1234589627-16977-6-git-send-email-lrodriguez@atheros.com>
References: <1234589627-16977-1-git-send-email-lrodriguez@atheros.com>
	 <1234589627-16977-6-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-AYCVi992uGJjoCrlWGeB"
Date: Sun, 15 Feb 2009 11:59:53 +0100
Message-Id: <1234695593.4219.47.camel@johannes.local> (sfid-20090215_120001_377442_95EC3772)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-AYCVi992uGJjoCrlWGeB
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-02-13 at 21:33 -0800, Luis R. Rodriguez wrote:
> This will allow us to clean up and make distinctions of who
> needs locking or not.
>=20
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> ---
>  net/wireless/reg.c |   36 +++++++++++++++++++++++++++---------
>  1 files changed, 27 insertions(+), 9 deletions(-)
>=20
> diff --git a/net/wireless/reg.c b/net/wireless/reg.c
> index ba82312..679fded 100644
> --- a/net/wireless/reg.c
> +++ b/net/wireless/reg.c
> @@ -1050,11 +1050,7 @@ static int ignore_request(struct wiphy *wiphy, enu=
m reg_set_by set_by,
>  	case REGDOM_SET_BY_INIT:
>  		return -EINVAL;
>  	case REGDOM_SET_BY_CORE:
> -		/*
> -		 * Always respect new wireless core hints, should only happen
> -		 * when updating the world regulatory domain at init.
> -		 */
> -		return 0;
> +		return -EINVAL;
>  	case REGDOM_SET_BY_COUNTRY_IE:
>  		if (unlikely(!is_an_alpha2(alpha2)))
>  			return -EINVAL;
> @@ -1183,6 +1179,26 @@ new_request:
>  	return call_crda(alpha2);
>  }
> =20
> +static int regulatory_hint_core(const char *alpha2)
> +{
> +	struct regulatory_request *request;
> +
> +	BUG_ON(last_request);
> +
> +	request =3D kzalloc(sizeof(struct regulatory_request),
> +			  GFP_KERNEL);
> +	if (!request)
> +		return -ENOMEM;
> +
> +	request->alpha2[0] =3D alpha2[0];
> +	request->alpha2[1] =3D alpha2[1];
> +	request->initiator =3D REGDOM_SET_BY_CORE;
> +
> +	last_request =3D request;

So before you documented that cfg80211_mutex is used to protect this
variable, but it's not used here.

johannes

--=-AYCVi992uGJjoCrlWGeB
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJl/WlAAoJEKVg1VMiehFYMkgP/i3x73RhFzqf+6MrJXie2KXK
i26U24fkDEbPeyHv53rSDArjZwcUy6wNwlD8tG+x7OozeudZev1E7KltygbByCUJ
ZBI3RlloSpF/+/7jMvj8we6dG8yneYFLGlDLIdiMecu1m9CzAOTVYMGYsghIp5tk
vuiN8vcjyrL5LgoRTd+ie5D539ofxTLzI4lEthSoavfCFy/pLq2AZLC1ue6Dx/8N
VmubmBPoc2v4f3uej3TETgFDBcqJ7y96MDBbTWGLI6lUZrFcD5rKGAiAdpODU74T
9AiXmtlkeNMsTnsF2PMgFs4lqyCPDK54vwBQ6GRfhydEX9ZVDJn2xNqQP67KWSq0
FXlNhEUira7+klmTMmqrMZe/FEIuJq7Q3X2GKNAFL0ceZfYUHsRm2xJu5SpWoZOZ
pFa/PHqizelrd+8FWM5wgLPo5zCzyQKwjA8XRawH/KBVzL/jKd+/EPkAiNqOyiDM
W/TM5sccWnwDNeylWf1OXlhHDruyrmQGzMkCAKQjhHUaDHtt3RbvWS3WJDDJJHHS
Psq9wLkjISeziy0DsjR0on+LwtB5YABHFFF85sPZrwvEVA/eBJ/i+gGO4NOe39Dg
cklyeH9QZeiilJzy8nXRXf2pmRhbVKi8F5lEsu9RUaoh+Y64Y1PManD0UzXktNUG
3oNYNJF2a7U7d4Bp82Yp
=i9O5
-----END PGP SIGNATURE-----

--=-AYCVi992uGJjoCrlWGeB--

