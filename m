Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44173 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753703AbZGOJnY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jul 2009 05:43:24 -0400
Subject: Re: [PATCH] cfg80211: treat ieee80211_regdom hints as user hints
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org
In-Reply-To: <1247617395-20617-1-git-send-email-lrodriguez@atheros.com>
References: <1247617395-20617-1-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-qOhWQ8fJ9hd94mWEkBOk"
Date: Wed, 15 Jul 2009 11:39:16 +0200
Message-Id: <1247650756.14973.1.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-qOhWQ8fJ9hd94mWEkBOk
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-07-14 at 20:23 -0400, Luis R. Rodriguez wrote:
> We were treating ieee80211_regdom module parameter hints
> as core hints, this means we were not letting the user help
> compliance further when using the module parameter. It also
> meant that users with a device with a custom regulatory
> domain set (wiphy->custom_regulatory) using this module
> parameter were being stuck to the original default core
> static regualtory domain. We fix this by using the static
> cfg80211_regdomain alpha2 as the core hint and treating the
> module parameter separately.
>=20
> All iwlwifi and ath5k/ath9k/ar9170 devices which world roam
> set the wiphy->custom_regulatory. This change allows users
> using this module parameter to have it trated as a a proper
> user hint and not have it ignored.
>=20
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> ---
>  net/wireless/reg.c |   25 +++++++++----------------
>  1 files changed, 9 insertions(+), 16 deletions(-)
>=20
> diff --git a/net/wireless/reg.c b/net/wireless/reg.c
> index 2b4a6c6..fb40428 100644
> --- a/net/wireless/reg.c
> +++ b/net/wireless/reg.c
> @@ -113,11 +113,7 @@ static const struct ieee80211_regdomain world_regdom=
 =3D {
>  static const struct ieee80211_regdomain *cfg80211_world_regdom =3D
>  	&world_regdom;
> =20
> -#ifdef CONFIG_WIRELESS_OLD_REGULATORY
> -static char *ieee80211_regdom =3D "US";
> -#else
>  static char *ieee80211_regdom =3D "00";
> -#endif
> =20
>  module_param(ieee80211_regdom, charp, 0444);
>  MODULE_PARM_DESC(ieee80211_regdom, "IEEE 802.11 regulatory domain code")=
;
> @@ -2287,22 +2283,12 @@ int regulatory_init(void)
> =20
>  	printk(KERN_INFO "cfg80211: Using static regulatory domain info\n");
>  	print_regdomain_info(cfg80211_regdomain);
> -	/*
> -	 * The old code still requests for a new regdomain and if
> -	 * you have CRDA you get it updated, otherwise you get
> -	 * stuck with the static values. Since "EU" is not a valid
> -	 * ISO / IEC 3166 alpha2 code we can't expect userpace to
> -	 * give us a regulatory domain for it. We need last_request
> -	 * iniitalized though so lets just send a request which we
> -	 * know will be ignored... this crap will be removed once
> -	 * OLD_REG dies.
> -	 */
> -	err =3D regulatory_hint_core(ieee80211_regdom);
>  #else
>  	cfg80211_regdomain =3D cfg80211_world_regdom;
> =20
> -	err =3D regulatory_hint_core(ieee80211_regdom);
>  #endif
> +	/* We always try to get an update for the static regdomain */
> +	err =3D regulatory_hint_core(cfg80211_regdomain->alpha2);
>  	if (err) {
>  		if (err =3D=3D -ENOMEM)
>  			return err;
> @@ -2321,6 +2307,13 @@ int regulatory_init(void)
>  #endif
>  	}
> =20
> +	/*
> +	 * Finally, if the user set the module parameter treat it
> +	 * as a user hint.
> +	 */
> +	if (!is_world_regdom(ieee80211_regdom))
> +		regulatory_hint_user(ieee80211_regdom);
> +
>  	return 0;
>  }
> =20

--=-qOhWQ8fJ9hd94mWEkBOk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKXaO/AAoJEODzc/N7+QmaEbQQAKMF+aK4RNHTfXWgNEzrAQdW
AvY5gLfGG2S+7rlLMZdSC7MYCmcRh6Tp/8lo+XhILcOzTMqgln2lS9x+B/m1ZIP5
mAqSHzC8PG6ZtGiyNh5DfOyi6LarDqP+7/c/38XWM6/vqFrxjWqFOExqYNCF2DMR
h1TSOtxP8FoieqpgPGYU07x5yiaJUqvsKp72Rm/ik80dm34JiNJMfx8qBI7RizIG
BFXGHpv7gKvRPZiPahCl4hxJDPoyPCJ1TbfvHdodII3r1uw5/M4OpCna250xOmqn
9KLL8bhrZJBh11WeFhFEh1nMj60OAMBVtHJMquaeH8Z/m5QrmtuVPNghOm28sGTf
bTL1WRN2SaWN9n7iBjL0RYi3Fze535T6tTkEAuZPLZRK9jDCrr9nAd2Jf2+hjSWJ
tP8cyu0tL7v7zdupyGu5Z2yiObVYsbKv5yHUmbTQVNeSy+pFiVh3qPOnetQmRw+O
si4yK5lgMlRRbitiuIEKkP6f6c3waHpGeR8sPBYBQ1ezkf2zt+T3UPsMb1eiQKE+
qIeUZEvuEf++LA5AS9rmZqvO5/mfmQiBcuDz0etmvO7UJvggHpvmYGMJVKMdg/aM
8X07Hn1AdoLXw82wvM8BvW0FTOdFqsYeUNz+rDgOayrAhVT/znGUnTcuLKXfIpZ2
tE2roTV6IvguwiCRs7yB
=X43X
-----END PGP SIGNATURE-----

--=-qOhWQ8fJ9hd94mWEkBOk--

