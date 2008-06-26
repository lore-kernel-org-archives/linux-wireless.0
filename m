Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59722 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762096AbYFZNY5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jun 2008 09:24:57 -0400
Subject: Re: [PATCH 1/1] mac80211: fix an oops in several failure paths in
	key allocation
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
In-Reply-To: <1214471626-4231-1-git-send-email-tomas.winkler@intel.com>
References: <1214471626-4231-1-git-send-email-tomas.winkler@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-KGTaTvq1kCTbFoFbCKs3"
Date: Thu, 26 Jun 2008 15:24:26 +0200
Message-Id: <1214486666.20763.40.camel@johannes.berg> (sfid-20080626_152520_399547_6E95F342)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-KGTaTvq1kCTbFoFbCKs3
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-06-26 at 12:13 +0300, Tomas Winkler wrote:
> From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
>=20
> This patch fixes an oops in several failure paths in key allocation. This
> Oops occurs when freeing a key that has not been linked yet, so the
> key->sdata is not set.
>=20
> Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> ---
>  net/mac80211/key.c |    9 +++++++++
>  1 files changed, 9 insertions(+), 0 deletions(-)
>=20
> diff --git a/net/mac80211/key.c b/net/mac80211/key.c
> index d4893bd..6597c77 100644
> --- a/net/mac80211/key.c
> +++ b/net/mac80211/key.c
> @@ -387,6 +387,15 @@ void ieee80211_key_free(struct ieee80211_key *key)
>  	if (!key)
>  		return;
> =20
> +	if (!key->sdata) {
> +		/* The key has not been linked yet, simply free it
> +		 * and don't Oops */
> +		if (key->conf.alg =3D=3D ALG_CCMP)
> +			ieee80211_aes_key_free(key->u.ccmp.tfm);
> +		kfree(key);
> +		return;
> +	}
> +
>  	spin_lock_irqsave(&key->sdata->local->key_lock, flags);
>  	__ieee80211_key_free(key);
>  	spin_unlock_irqrestore(&key->sdata->local->key_lock, flags);

--=-KGTaTvq1kCTbFoFbCKs3
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIY5iGAAoJEKVg1VMiehFYfG8P/2+soLcBtRgXViICmacUN89G
9KqnVP3HoHRmuwDBIoNSAD873MWKga4ByUEvi+f3W0/go16kkF2LOfO6/SGBAEHn
40KtU8fIWMiY1yarcr30aBaLgxK1O6YVgaNRC5sKgi0kunYeKdqGesjH27TuJVxH
VTggsn0IClqpVWvADdnaGyqx2oj7cgJ8+H9uJgaw24nMTGsWVlQ3oMedM2Zt69l1
+kjYomPrtvQoKzkzSUWXrhBHU9v5pi1SgG+T7BuvQfg7goil7Twzl2xX4FLGHFCn
nh3SaDl+2jpZzJ/Ouw2ZcbCXaX9xrCHEcdbziDbV47S6NnM3vELYN92ZgCkrPSmk
CnE1sQZaF/Gt/aowAWVKqJVUMebpq8z/elfDKcv1zgBWEcGIzKODBZwIVqU7GxYS
Tj4vMqrLgwZIH3ePe5WtZuOByXcB4SYL1T4dwbjTZ0mJ4elMDIpZfQ9cHhous2C0
XPB1/AQJhMghrq5yhouzL4SPANcKs/b8WmX6Er9zV9qujt/mx14VGHhqB3bfdHE3
Z+bN9aP/wPBitvthSd6VCjGLFBtfRRef0IWjriHiPsGvJs1zfhtwi+kLKgIB5umz
L3Dpz8EhSJtqDCRhFuokpZnzmG6T1fpXiW1R+ZRwnrtd3XdJOxumJID0E68smhk6
ape9qbmu/NauTqJDik+C
=mhkR
-----END PGP SIGNATURE-----

--=-KGTaTvq1kCTbFoFbCKs3--

