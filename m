Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:33637 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752137AbYDRMJh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Apr 2008 08:09:37 -0400
Subject: Re: [PATCH] mac80211: Add IEEE80211_KEY_FLAG_PAIRWISE
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200804172111.18641.IvDoorn@gmail.com> (sfid-20080417_200646_194906_ADC8A975)
References: <200804172111.18641.IvDoorn@gmail.com>
	 (sfid-20080417_200646_194906_ADC8A975)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-NYHY/2jzDo9lLWdh01Q2"
Date: Fri, 18 Apr 2008 14:09:28 +0200
Message-Id: <1208520568.4848.11.camel@johannes.berg> (sfid-20080418_130943_695674_B731B36F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-NYHY/2jzDo9lLWdh01Q2
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-04-17 at 21:11 +0200, Ivo van Doorn wrote:
> This adds a new flag to the ieee80211_key_conf structure.
> This flag will inform the driver the key is pairwise rather then
> a shared key.
>=20
> This is important for drivers who support both types of keys,
> and need to be informed which type of key this is. Alternative
> would be drivers checking the address argument of set_key(),
> but it will be safer when mac80211 is more explicit.

Looks fine to me.

> Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
> ---
> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> index 27ef9f7..740c11c 100644
> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -621,11 +621,14 @@ enum ieee80211_key_alg {
>   * @IEEE80211_KEY_FLAG_GENERATE_MMIC: This flag should be set by
>   *	the driver for a TKIP key if it requires Michael MIC
>   *	generation in software.
> + * @IEEE80211_KEY_FLAG_PAIRWISE: Set by mac80211, this flag indicates
> + *	that the key is pairwise rather then a shared key.
>   */
>  enum ieee80211_key_flags {
>  	IEEE80211_KEY_FLAG_WMM_STA	=3D 1<<0,
>  	IEEE80211_KEY_FLAG_GENERATE_IV	=3D 1<<1,
>  	IEEE80211_KEY_FLAG_GENERATE_MMIC=3D 1<<2,
> +	IEEE80211_KEY_FLAG_PAIRWISE	=3D 1<<3,
>  };
> =20
>  /**
> diff --git a/net/mac80211/key.c b/net/mac80211/key.c
> index 150d66d..88b211a 100644
> --- a/net/mac80211/key.c
> +++ b/net/mac80211/key.c
> @@ -323,6 +323,13 @@ void ieee80211_key_link(struct ieee80211_key *key,
>  		 */
>  		if (sta->flags & WLAN_STA_WME)
>  			key->conf.flags |=3D IEEE80211_KEY_FLAG_WMM_STA;
> +
> +		/*
> +		 * This key is for a specific sta interface,
> +		 * inform the driver that it should try to store
> +		 * this key as pairwise key.
> +		 */
> +		key->conf.flags |=3D IEEE80211_KEY_FLAG_PAIRWISE;
>  	} else {
>  		if (sdata->vif.type =3D=3D IEEE80211_IF_TYPE_STA) {
>  			struct sta_info *ap;
>=20

--=-NYHY/2jzDo9lLWdh01Q2
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASAiPd6Vg1VMiehFYAQJo+Q/+KX9PW9WtUTy7/7qyZMNRbffATN09LLuY
iyPQo7fY+CMuSIBzBXhm+vneV9IGvZzYQ7F14yCnECGe5aaoR1dYwF3ZsQ/a3rQ6
A+xOS1IR1l6xAVQipYTnjGU+JVLE1iaF459TdQWummdQZG6yQ9i087OTpkwx4RKk
7Tq3Gwz+N0c+8c/MSI8qbWC5Ca3TJjUcDr21ntG2TrdBIa/gNPJGeNCzo/nexrP3
ojEK5/noGRi861HFwwNlICmt+T7464t/mc0mqaJ7Wi2wTGXmIIL6dNNBrLzf8OuH
rDthCCnqBgxeXFOT+j1bczqgJ6s7RR3UNICf8a6DV0XPWywN0dxWzp5Ft7iyOwpE
f80OSlOdyBANRxUJP/iGQAgA897pFGgxVY1pe+hpht7imUW8+iZZgqjfYIcAnkFb
UFjGF83P1G1wKPv+IhS2w3SAUWmLosCoRCpJJSh9Y506vc3ShDRQW3AYCjJESNl/
k1GL2ZYW9q0c9H5E772ZCy6BdkYaQmspwqdXMNlIbyJyixmj9MHQiPhKr9oiXOoq
qEh2ZOedbdK9i9/8hyUBAtH0VzgHCY+pJ9dlP2futMpP2h6YMaDZ8Hk1rZd3joup
fPmMCLNYUAP9e2/4lOvp4PD1PvHIaE7q1dUf+8r9Dos7oZ6B23XX+Q/pzPXoOB5U
a9VSztrKftY=
=2Pld
-----END PGP SIGNATURE-----

--=-NYHY/2jzDo9lLWdh01Q2--

