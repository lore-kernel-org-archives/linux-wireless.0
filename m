Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:34997 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbZIURTj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Sep 2009 13:19:39 -0400
Subject: Re: [PATCH] mac80211: Fix [re]association power saving issue on AP
 side
From: Johannes Berg <johannes@sipsolutions.net>
To: Igor Perminov <igor.perminov@inbox.ru>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Jouni Malinen <j@w1.fi>, linux-wireless@vger.kernel.org
In-Reply-To: <1253200137.26765.338.camel@sunlight>
References: <1253200137.26765.338.camel@sunlight>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-8Bqk3kKXIaz2hYTcZyln"
Date: Mon, 21 Sep 2009 10:19:33 -0700
Message-Id: <1253553573.4458.9.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-8Bqk3kKXIaz2hYTcZyln
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

Jouni and I just discussed this and noticed that there are even more
things broken that your patch doesn't fix either, so we will need just
the last hunk of your patch (quoted below), and a one-line fix in
hostapd.

And then we can also remove the workaround from net/mac80211/cfg.c (the
entire EEXIST branch).

Thanks,
johannes

> --- a/net/mac80211/tx.c
> +++ b/net/mac80211/tx.c
> @@ -367,7 +367,10 @@ ieee80211_tx_h_unicast_ps_buf(struct ieee80211_tx_da=
ta *tx)
>         struct ieee80211_hdr *hdr =3D (struct ieee80211_hdr *)tx->skb->da=
ta;
>         u32 staflags;
> =20
> -       if (unlikely(!sta || ieee80211_is_probe_resp(hdr->frame_control))=
)
> +       if (unlikely(!sta || ieee80211_is_probe_resp(hdr->frame_control)
> +                       || ieee80211_is_auth(hdr->frame_control)
> +                       || ieee80211_is_assoc_resp(hdr->frame_control)
> +                       || ieee80211_is_reassoc_resp(hdr->frame_control))=
)
>                 return TX_CONTINUE;
> =20
>         staflags =3D get_sta_flags(sta);
>=20
>=20
>=20


--=-8Bqk3kKXIaz2hYTcZyln
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKt7WiAAoJEODzc/N7+QmaB9cP/Rksz50HWKEcEcrv/L3YTWid
7MdTgcXCsiSzEjSUOEpzr/E11nJ4h9swYoF2IBCZz70UpsWYORa+j+UeUVUExbQC
d7tv+9rHPdhSWg/+ePRuk9kzzzIE74zXU7E2Er294nWzYUMOMHubG3WcYqpG0P1F
ct5shVVZ6L6zoLXwRi7/by/QykYxLtl1qUks5miA5ULxbsW1UQ/NAGCZoOdnMBWZ
bIHpoyxS+OWnTTfoKzA+CVHmpOo1Otj3414xKNYv87ACH5tPZc/DccRDZXjwECNI
8gxiOhWY1UjryntC6Ss5j4EJW/ue2APJrCmqTYE+v/BaAs7sqH27Ys4DXK+hOQcu
ewwFs/ySxZjP3qFtfILljNlBjlxtieKSksF+vwgTled8knCPs93SHNaP/9IIOqS3
Q0mEsf88n3khnMyd/CIA0FMaCpftnpQTBrJfr25X6JnyexqCwsI21UqOQbJFQRN/
g61firn/DpwL/mlOoHN3QM9sAa5rlGlT3hSsJ9JlmWfwjxCLl4iE5JQ5WRsdQoC9
IOX/zKhHNlmcpQW16vUfdNtfNjZB+WBIJMvXrlr/s55A0n6hTSqeoYF0xKSrWff2
nmuA/IM95+LxrdNbTWrWg2Q9mFEoqutii3SZ/cOslzoPc3opB5h+uzwRBQvIrg/v
9mJ/xKg1XgKBz31r5kk6
=fsbT
-----END PGP SIGNATURE-----

--=-8Bqk3kKXIaz2hYTcZyln--

