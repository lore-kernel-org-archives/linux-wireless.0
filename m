Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.neomailbox.net ([178.209.62.157]:8714 "EHLO
	s3.neomailbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480AbaAORBC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jan 2014 12:01:02 -0500
Message-ID: <52D6B2F5.4070404@meshcoding.com> (sfid-20140115_180106_235602_A97404E5)
Date: Wed, 15 Jan 2014 17:10:29 +0100
From: Antonio Quartulli <antonio@meshcoding.com>
MIME-Version: 1.0
To: Oleksij Rempel <linux@rempel-privat.de>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	ath5k-devel@lists.ath5k.org
Subject: Re: [PATCH 1/5] ath: add common function ath_is_mybeacon
References: <1389802038-6688-1-git-send-email-linux@rempel-privat.de> <1389802038-6688-2-git-send-email-linux@rempel-privat.de>
In-Reply-To: <1389802038-6688-2-git-send-email-linux@rempel-privat.de>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="se0RmsVd9Tn36ohtCD4L6IATPGLkL35tL"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--se0RmsVd9Tn36ohtCD4L6IATPGLkL35tL
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 15/01/14 17:07, Oleksij Rempel wrote:
> this function is used by most ath driver, so it can be moved here.
>=20
> Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
> ---
>  drivers/net/wireless/ath/ath.h  |  2 ++
>  drivers/net/wireless/ath/main.c | 11 +++++++++++
>  2 files changed, 13 insertions(+)
>=20
> diff --git a/drivers/net/wireless/ath/ath.h b/drivers/net/wireless/ath/=
ath.h
> index e0ba7cd..b59cfbe 100644
> --- a/drivers/net/wireless/ath/ath.h
> +++ b/drivers/net/wireless/ath/ath.h
> @@ -17,6 +17,7 @@
>  #ifndef ATH_H
>  #define ATH_H
> =20
> +#include <linux/etherdevice.h>
>  #include <linux/skbuff.h>
>  #include <linux/if_ether.h>
>  #include <linux/spinlock.h>
> @@ -165,6 +166,7 @@ struct ath_common {
>  struct sk_buff *ath_rxbuf_alloc(struct ath_common *common,
>  				u32 len,
>  				gfp_t gfp_mask);
> +bool ath_is_mybeacon(struct ath_common *common, struct ieee80211_hdr *=
hdr);
> =20
>  void ath_hw_setbssidmask(struct ath_common *common);
>  void ath_key_delete(struct ath_common *common, struct ieee80211_key_co=
nf *key);
> diff --git a/drivers/net/wireless/ath/main.c b/drivers/net/wireless/ath=
/main.c
> index 8e99540..9cb15d9 100644
> --- a/drivers/net/wireless/ath/main.c
> +++ b/drivers/net/wireless/ath/main.c
> @@ -59,6 +59,17 @@ struct sk_buff *ath_rxbuf_alloc(struct ath_common *c=
ommon,
>  }
>  EXPORT_SYMBOL(ath_rxbuf_alloc);
> =20
> +bool ath_is_mybeacon(struct ath_common *common, struct ieee80211_hdr *=
hdr)
> +{
> +	if (ieee80211_is_beacon(hdr->frame_control) &&
> +			!is_zero_ether_addr(common->curbssid) &&
> +			ether_addr_equal_64bits(hdr->addr3, common->curbssid))
> +		return true;
> +

Apart from the fact that the expression in the if guard is badly
indented, couldn't you just return the value of that expression and
remove the if at all?

Cheers,

> +	return false;
> +}
> +EXPORT_SYMBOL(ath_is_mybeacon);
> +
>  void ath_printk(const char *level, const struct ath_common* common,
>  		const char *fmt, ...)
>  {
>=20


--=20
Antonio Quartulli


--se0RmsVd9Tn36ohtCD4L6IATPGLkL35tL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJS1rL5AAoJEEKTMo6mOh1VTgcP/A/DCeq+EGiHWVrqgerUGK5v
sw/AWEZm/ucirzA/aI8ffrw6u6XPUnZNlKJmvm/xymxoS8CZLEmYWsoG+3FUk8d6
lfRXmCy8sIF2YOOx+pFchkW/YJii5gTL7u5nVOwjzTddVEb9J/IOZUtbWDb9mngc
grtLKRfR66H7ASSnJWpvWrwTHWgT+N/igorlNxyElzjB9FYHZbHb6pjtfJyuIB3N
Mm1E7YohwjmMXUqNCEot+2aq4R1MU9fSRieaeLrO+9fxDjnXxKA+gfDEX2q/rLYc
lJ2WXNlFySfgjZrdxNtpaws0t+stuvOFJw+WdgY8eYu0+vpoVgiH/Z/nerkwlxqX
y7wvqghJzbWb2fDjhOWmo1Eo7vvDOh40c9oCiaIR2ApjUkybQF7P6DMNBwszG0aw
z9pMHfZNUYldFuBCZkONQVe524bNWvywGBJiy+eXDQLUczQjsQLFtkvP/J1ol2vZ
KqQCnfqH+JZegc9UIYt9JKjHc3HVakOVM6m+W2RVCjViAWnLd4blvHq7EFxTMRBW
Ke0BWDeQLlQ6W7bq6rdcekrQi8dqU74XdPwIXAsO8ryKdp5k7b3PzTWs2VwF3NXl
jSzpDd62AnaRWVMDgSwt2k+gaY24/hdVV1skg9GNDXHLts5g1ivhL6EhMcpLTEq5
7wjVUyag6f795HurvqIh
=g/F+
-----END PGP SIGNATURE-----

--se0RmsVd9Tn36ohtCD4L6IATPGLkL35tL--
