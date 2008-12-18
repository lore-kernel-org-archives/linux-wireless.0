Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:32862 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853AbYLRPX5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2008 10:23:57 -0500
Subject: Re: [PATCH] mac80211: Print unknown packet type in tasklet_handler
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John W Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <49496093.ddL5Pgdq/zMZM8op%Larry.Finger@lwfinger.net>
References: <49496093.ddL5Pgdq/zMZM8op%Larry.Finger@lwfinger.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-dCmdY/q/v3eXi2qHYguD"
Date: Thu, 18 Dec 2008 16:23:55 +0100
Message-Id: <1229613835.3601.3.camel@johannes.berg> (sfid-20081218_162401_077245_A4E2F01E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-dCmdY/q/v3eXi2qHYguD
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-12-17 at 14:26 -0600, Larry Finger wrote:
> In stress testing p54usb, the WARN_ON() in ieee80211_tasklet_handler() wa=
s
> triggered; however, there is no logging of the received value for packet
> type. Adding that feature will improve the warning.
>=20
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> ---
>=20
> John.
>=20
> This is 2.6.29 material.
>=20
> Larry
> ---
>=20
> Index: wireless-testing/net/mac80211/main.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- wireless-testing.orig/net/mac80211/main.c
> +++ wireless-testing/net/mac80211/main.c
> @@ -341,7 +341,8 @@ static void ieee80211_tasklet_handler(un
>  			dev_kfree_skb(skb);
>  			break ;
>  		default:
> -			WARN_ON(1);
> +			WARN(1, "mac80211: Packet is of unknown type %d\n",
> +			     skb->pkt_type);
>  			dev_kfree_skb(skb);
>  			break;
>  		}
>=20

--=-dCmdY/q/v3eXi2qHYguD
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJSmsIAAoJEKVg1VMiehFYtHgP/A52VD/ECmzDezFfi00eyN4x
XaSvgGZLBpsjBKh+gV2tLx2KJljDl9Ap2ionfWFSbPXekcoeWNmQ8ld3eZMZqdha
S3tdNfJ/GlIqZvYI8uf8RqbTplUlsq1iz7TH7/j1yM2JRg1wiATygnFGzGcs91A3
29ao1Lv5+J4FFC7ZeY3xSmSQqbOZ2atMsmH+TAvfLqa2KDUSob0rcS1hbESXdnoU
2beGk/3cK7s3aUyfJlwrY0+fVnQFtds4B/leaVYNbAPSomRKmkiq8ZJwr9nhBe4V
Ir6ipw1n3RVSvt0WirBEEBsxcYML9y1KB6a8dRtnJ9vMFO9Flh+s79PkubEkddRP
P3IMZcM2aweAQpdYi/k2M5YnoZ+ZQUo/UKonoRgeZqhWKj5YJjLQo9oxFt/i+5uT
CjFWASbpn6g/PAVwtW5550Uy0J/L7EvPj0iX3BbaqW8ubnHaiTMLmE0bl0E/+FuD
13UhkZmw/0ICOS/ooH51DK7Ev5CZ7hTDT0QNiaIgiu6Ck0lAqTG9RVTBk2iqXgKy
rsJIFAKa8Jn45mLR0ElUMQ0bZ/EdnvpJ0gNWCygO1cLDcR8m1LvzlGln2d8/aImU
BeKk1fLbnYrFgEyQTS9TexPuZ1RPN7hO+So4/mzQoPDWQlJrD/5zMKu29/rgcIhj
HHPOrQTgTC6lOw2iVall
=9wyr
-----END PGP SIGNATURE-----

--=-dCmdY/q/v3eXi2qHYguD--

