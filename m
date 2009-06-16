Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:57057 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759661AbZFPSzt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jun 2009 14:55:49 -0400
Subject: Re: [PATCH] rt2x00: remove skb->do_not_encrypt usage
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: linville@tuxdriver.com,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <200906162046.45728.IvDoorn@gmail.com>
References: <200906162046.45728.IvDoorn@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-7HOOGrCVI5yLH5fLj+43"
Date: Tue, 16 Jun 2009 20:55:21 +0200
Message-Id: <1245178521.21287.43.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-7HOOGrCVI5yLH5fLj+43
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-06-16 at 20:46 +0200, Ivo van Doorn wrote:
> From: Johannes Berg <johannes@sipsolutions.net>
>=20
> Johannes is trying to get rid of the master netdev and in the process wil=
l
> remove skb->do_not_encrypt field. This removes the do_not_encrypt
> usage from rt2x00 to make the change easier.

So that worked, thanks!

johannes

> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
> ---
> diff --git a/drivers/net/wireless/rt2x00/rt2x00crypto.c b/drivers/net/wir=
eless/rt2x00/rt2x00crypto.c
> index 57ab42c..3ef26f5 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00crypto.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00crypto.c
> @@ -53,8 +53,7 @@ void rt2x00crypto_create_tx_descriptor(struct queue_ent=
ry *entry,
>  	struct ieee80211_tx_info *tx_info =3D IEEE80211_SKB_CB(entry->skb);
>  	struct ieee80211_key_conf *hw_key =3D tx_info->control.hw_key;
> =20
> -	if (!test_bit(CONFIG_SUPPORT_HW_CRYPTO, &rt2x00dev->flags) ||
> -	    !hw_key || entry->skb->do_not_encrypt)
> +	if (!test_bit(CONFIG_SUPPORT_HW_CRYPTO, &rt2x00dev->flags) || !hw_key)
>  		return;
> =20
>  	__set_bit(ENTRY_TXD_ENCRYPT, &txdesc->flags);
> @@ -82,8 +81,7 @@ unsigned int rt2x00crypto_tx_overhead(struct rt2x00_dev=
 *rt2x00dev,
>  	struct ieee80211_key_conf *key =3D tx_info->control.hw_key;
>  	unsigned int overhead =3D 0;
> =20
> -	if (!test_bit(CONFIG_SUPPORT_HW_CRYPTO, &rt2x00dev->flags) ||
> -	    !key || skb->do_not_encrypt)
> +	if (!test_bit(CONFIG_SUPPORT_HW_CRYPTO, &rt2x00dev->flags) || !key)
>  		return overhead;
> =20
>  	/*
> diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wirele=
ss/rt2x00/rt2x00mac.c
> index c4c06b4..475a3ed 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00mac.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
> @@ -73,7 +73,8 @@ static int rt2x00mac_tx_rts_cts(struct rt2x00_dev *rt2x=
00dev,
>  	else
>  		rts_info->flags &=3D ~IEEE80211_TX_CTL_NO_ACK;
> =20
> -	skb->do_not_encrypt =3D 1;
> +	/* Disable hardware encryption */
> +	rts_info->control.hw_key =3D NULL;
> =20
>  	/*
>  	 * RTS/CTS frame should use the length of the frame plus any
>=20

--=-7HOOGrCVI5yLH5fLj+43
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKN+qWAAoJEODzc/N7+QmaIVcP/0TUifhZVjKp01Rq06dydJgX
13P7iMLky8UEyBOXicW3Am550HH1D3LfdetLNg1iRn6/g4FsyMfzI2njbbrtNq+r
JQJxMZVPuV3Y26AonhvN5Ek+Gi+ZNku26srzOyEfAsDhsHw9ogd7YY38GHMceC1R
fE59jw0Y8MJ4V0rfNKzOqi9chn5o9orCfPWwc6gtA4LkxtQm0fe+2UcxtnMh/h2y
82j4W1pF6ziEi6ZUSUqdbUKonDM0tEjA3h+7vmeepPfg1TEyvIs+mTHk+MZO0Wex
q08DsG2pe68NbpH6oFZ4NuNl51ZBzYG8YsBTkfkTE2xMUt34KjBvmRbl8RtVE08V
uVnVUvkk6eoJYp3zLU0TlzQE9+OkEu6psA671XFLskeB3HLWXnNoPeiA3/jGJrQO
iMn83rW4CVXr5M0TQBDiTno/Oo9X31Zn+x4w986crDMARkpMxGHmqSYlFsv2K0vL
fqt3Sx4aksQ4A5Hr1NbndzyHTVbW3+wMqIbCQUGXZydOGVRHVh1E4xaw+rIWeB4w
FjzI0cfZbuE6SPm4nXd2Z6masESiBKoPStlgxzYU2dLssLE11b2dhnWQV5WxJO8Q
8nA+dfIzmolnzZb7xg4Ixg/8tV+L2vow5jKN5kS5sMjf5TKM4GAkvLUSCa1HRVqv
lYgmW/lQ6NSS6qbFygza
=vBpa
-----END PGP SIGNATURE-----

--=-7HOOGrCVI5yLH5fLj+43--

