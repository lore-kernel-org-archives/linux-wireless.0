Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:46173 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753703AbYEMMyX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 May 2008 08:54:23 -0400
Subject: Re: [PATCH v2] mac80211: Set IEEE80211_TXPD_REQ_TX_STATUS for all
	TX frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <200805131503.03653.IvDoorn@gmail.com> (sfid-20080513_145147_307870_AD6F9935)
References: <200805111434.19071.IvDoorn@gmail.com>
	 <200805131503.03653.IvDoorn@gmail.com>
	 (sfid-20080513_145147_307870_AD6F9935)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-tTI4hHpcXUgbXeEdS7vp"
Date: Tue, 13 May 2008 14:54:00 +0200
Message-Id: <1210683240.3791.0.camel@johannes.berg> (sfid-20080513_145430_001647_322CA3CF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-tTI4hHpcXUgbXeEdS7vp
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-05-13 at 15:03 +0200, Ivo van Doorn wrote:
> All interfaces should set the IEEE80211_TXPD_REQ_TX_STATUS flag for all T=
X frames
> which will force the master interface to set the IEEE80211_TX_CTL_REQ_TX_=
STATUS
> flag. This in turn will allow drivers to check for that flag before repor=
ting
> the TX status to mac80211.
>=20
> This is very usefull when frames (like beacons, RTS and CTS-to-self) shou=
ld not
> be reported back to mac80211. Later we could add more extensive checks to
> exclude more frames from being reported, or let mac80211 decide if it wan=
ts
> the frame for status reporting or not.
>=20
> v2: Monitor interfaces should also set IEEE80211_TXPD_REQ_TX_STATUS
>=20
> Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>

Looks good, thanks.

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> ---
> diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
> index f35eaea..472dab0 100644
> --- a/net/mac80211/tx.c
> +++ b/net/mac80211/tx.c
> @@ -1336,6 +1336,8 @@ int ieee80211_monitor_start_xmit(struct sk_buff *sk=
b,
>  	pkt_data->ifindex =3D dev->ifindex;
> =20
>  	pkt_data->flags |=3D IEEE80211_TXPD_DO_NOT_ENCRYPT;
> +	/* Interfaces should always request a status report */
> +	pkt_data->flags |=3D IEEE80211_TXPD_REQ_TX_STATUS;
> =20
>  	/*
>  	 * fix up the pointers accounting for the radiotap
> @@ -1617,6 +1619,9 @@ int ieee80211_subif_start_xmit(struct sk_buff *skb,
>  	if (ethertype =3D=3D ETH_P_PAE)
>  		pkt_data->flags |=3D IEEE80211_TXPD_EAPOL_FRAME;
> =20
> +	/* Interfaces should always request a status report */
> +	pkt_data->flags |=3D IEEE80211_TXPD_REQ_TX_STATUS;
> +
>  	skb->dev =3D local->mdev;
>  	dev->stats.tx_packets++;
>  	dev->stats.tx_bytes +=3D skb->len;
>=20

--=-tTI4hHpcXUgbXeEdS7vp
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASCmPZ6Vg1VMiehFYAQI0JA//bEF/muXI4ktOzEltquSmJU6Ie4uO+6Fn
uUkIjpZZxP9RCAz4j3NZC6M0/IBc6h1BXf9DrT+iRIGODwwiZu/XgS54o1Q+W81l
IvnnxOCXJkyrg3BFU6qzQoFSUezjKfEGqGwJO52dU49i2jkjO/PGmOLcVvmUqhj0
dEAm3+pBaG0yYBmxRkAvSERvULGg2CHm37lKfWO9AfOmpLb5RO0VFn1yX72F8tPA
5/i75f8B2/+yrYWJttlH5wec5eOSwMzYsusQS69vyRwdazskKFK+71TGDQ6TWTv0
KaTqd5K86blVmYIxCln39IivtzOHxttaLLM2H2/TBKfSfdry1JkH3frSLBQvlDnv
WC+WRvEiRhn7td4d3ls0bd/PAMiMrKFpBVrC/vZNH7sDzTcEzoEhQuzT1mueFpDu
m5mHI2rd7pRiwDVLxCmcJ2B9jPZS8/g3OAnhm6QsFVcS1y8Km1AaXHxyQC/3lK/S
G8TYicQ/u+7zG99IHmMGCYMYSb41GVGgssyhKEDNm2/X2nMwkNTVWhYARGuqbFNG
kLBK0Su+D8F+KZhJncCiK45Szeq+ZG/I+R4W8do3yYXcW8rWjOJOTj0qFD/7kEmm
zTJlpRKUACwKkRwyEdp+wV9kJ9pfJpvz9CZipjFNTRjP//sKZbIlCju5hIzMaEY0
4y+fPuRVkH4=
=VjqJ
-----END PGP SIGNATURE-----

--=-tTI4hHpcXUgbXeEdS7vp--

