Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:55191 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764094AbYEHOn6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 May 2008 10:43:58 -0400
Subject: Re: 015-mac80211-tx-info-skb-cb.patch
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200805081503.41025.IvDoorn@gmail.com> (sfid-20080508_145420_350472_4B678943)
References: <200805081503.41025.IvDoorn@gmail.com>
	 (sfid-20080508_145420_350472_4B678943)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-7FIRo2OYNGOx078HwGH2"
Date: Thu, 08 May 2008 16:43:40 +0200
Message-Id: <1210257820.3547.50.camel@johannes.berg> (sfid-20080508_164315_691722_CD635830)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-7FIRo2OYNGOx078HwGH2
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-05-08 at 15:03 +0200, Ivo van Doorn wrote:
> Hi Johannes,
>=20
> The following patch is intended to be ontop or integrated into your patch=
:
> http://johannes.sipsolutions.net/patches/kernel/all/LATEST/015-mac80211-t=
x-info-skb-cb.patch
> This fixes a compilation error when mac80211 debug output is disabled.
>=20
> Ivo
> ---
> diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
> index 3b3592f..50edc9d 100644
> --- a/net/mac80211/tx.c
> +++ b/net/mac80211/tx.c
> @@ -223,10 +223,9 @@ static ieee80211_tx_result
>  ieee80211_tx_h_check_assoc(struct ieee80211_tx_data *tx)
>  {
>  #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
> -	struct sk_buff *skb =3D tx->skb;
> -	struct ieee80211_hdr *hdr =3D (struct ieee80211_hdr *) skb->data;
> +	struct ieee80211_hdr *hdr =3D (struct ieee80211_hdr *) tx->skb->data;
>  #endif /* CONFIG_MAC80211_VERBOSE_DEBUG */
> -	struct ieee80211_tx_info *info =3D (void *)skb->cb;
> +	struct ieee80211_tx_info *info =3D (void *)tx->skb->cb;

Did you send me that before? I seem to have a similar fix already.

johannes

--=-7FIRo2OYNGOx078HwGH2
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASCMRm6Vg1VMiehFYAQJzHA//ehDMTFo9Yf+GQ0ZpNtlFKniWcWhxYDqt
c9a226wYBzDBN77s277x5YM6rSmWgEDnmj+yCHrpJEQElvEy8IHKgTs5uBXUJcYb
2ODN/8bNc20Or+3a0Ch1f1Yt3htxjUG7UhEevGeHhQ/JWWkHR3ajTLW7dQirTnbJ
7H6nARnzTlFB31LZGvAQX4iIZ8zchI1ev9rZizChafQO+jIMF9fPtBULuGobWwHr
Qtz0j3Q64acC0WPa5sZVW+dEvI4jYX6KeFwV5bNPxi6vzIXjiH+YBCDEwjjB0qB/
bSSZROksJtxKKgfY5fJnJJ2Ca0SWra8WPXBbciooiQAQnwWNBUmzZ225tjJyH0uS
HX0PExJSBRTvNyYPXsdtX/bcgAptOXCOJIensM8ZXlg9QbRUASTO8Fbl+YulPOiz
nsZzTnhOlYGSplEC/MdhPGtfEtBNu/y9KNkFkrBB0/FYbI4GeySaeRCK12SwAk1U
puSYVT+upk0Dg6IOkLOZZemVAXnKs99oLifY4XP65VIOFmYoaFgkDqn+Yh0Z99JY
A3su/HAVY6hxtPIS8dV8ypMe3KYnNsaBtpJ3uowT4msHIOMRGNIy206afPhSKkVJ
UbYTXHz3vBGgumD9ObbsEO+Viit4Ab9wKRKGmHkCpc+bx+slRmeIX8T00OQwpQdD
r781XrUjx7E=
=TlLU
-----END PGP SIGNATURE-----

--=-7FIRo2OYNGOx078HwGH2--

