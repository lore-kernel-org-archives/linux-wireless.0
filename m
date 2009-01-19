Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35463 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735AbZASL33 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Jan 2009 06:29:29 -0500
Subject: Re: [PATCH 1/2] iwl3945: fix some warnings when compiled  without
	debug
From: Johannes Berg <johannes@sipsolutions.net>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <200901190955.04622.helmut.schaa@gmail.com> (sfid-20090119_100256_705388_7BA8EF01)
References: <200901190955.04622.helmut.schaa@gmail.com>
	 (sfid-20090119_100256_705388_7BA8EF01)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-z62jV6c73FJqmVGNA4jy"
Date: Mon, 19 Jan 2009 11:09:06 +0100
Message-Id: <1232359746.3758.0.camel@johannes> (sfid-20090119_122934_797194_6FA089BF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-z62jV6c73FJqmVGNA4jy
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-01-19 at 09:55 +0100, Helmut Schaa wrote:
> Fix the following warnings if compiled without CONFIG_IWLWIFI_DEBUG.
>=20
> drivers/net/wireless/iwlwifi/iwl3945-base.c: In function =E2=80=98iwl3945=
_rx_reply_add_sta=E2=80=99:
> drivers/net/wireless/iwlwifi/iwl3945-base.c:2748: warning: unused variabl=
e =E2=80=98pkt=E2=80=99
> drivers/net/wireless/iwlwifi/iwl3945-base.c: In function =E2=80=98iwl3945=
_rx_scan_results_notif=E2=80=99:
> drivers/net/wireless/iwlwifi/iwl3945-base.c:2903: warning: unused variabl=
e =E2=80=98notif=E2=80=99
> drivers/net/wireless/iwlwifi/iwl3945-base.c: In function =E2=80=98iwl3945=
_rx_scan_complete_notif=E2=80=99:
> drivers/net/wireless/iwlwifi/iwl3945-base.c:2928: warning: unused variabl=
e =E2=80=98scan_notif=E2=80=99
>=20
> Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
> ---
> diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wi=
reless/iwlwifi/iwl3945-base.c
> index b437cac..15d36d8 100644
> --- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
> +++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
> @@ -2744,7 +2744,9 @@ static void iwl3945_rx_reply_alive(struct iwl_priv =
*priv,
>  static void iwl3945_rx_reply_add_sta(struct iwl_priv *priv,
>  				 struct iwl_rx_mem_buffer *rxb)
>  {
> +	#ifdef CONFIG_IWLWIFI_DEBUG
>  	struct iwl_rx_packet *pkt =3D (void *)rxb->skb->data;
> +	#endif=20

I for one would definitely prefer you didn't indent preprocessor
statements, but I don't care all that much about iwl3945.

johannes

--=-z62jV6c73FJqmVGNA4jy
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJdFE/AAoJEKVg1VMiehFYqOAQAMLA+/aZbOQLa3ZQLfpeP0tF
/6h0NWlzaSxqrDIAvIyzd3lce4KRGGzuIhf1+PfikNLPFJgwAd8jH0a7VDeFQpLq
WG1M9IO2CtNAUNNjI/sUVmyXnuAGYKOGt1urOBzkhGkRYD2WZS21PDapM5/yUk3W
4bP9NHH8/MlENeILt1yrFZpzL5kkS+TCxh5bRM6f43Y+TdTPaHTjmmtKyHzg83AZ
KDDIOcso9j1A2qnibFxL7tN3jVOW1ZYbdPykWe2nzOWC6qCHMytKbblMcUapfcd+
ibL6v9NaSBWmmUxSVmXJFwd920yxLqdHZqr5i1ALaqaOmKBuf6J3Qq1uL7XRx4Z3
TUnQ6j5gNMyFmfqH2S/lfL75CooWPaFtjdDjNDwG3RFa+n+7BpKDMhRp82awhnok
iSQeF9XEHpSqacnEj/D5kwWTPkxiilPdtqwxWyqjdRpuRxv0SK4ppihWgRfUuX2s
hJy4a9gR6N5kPh1cmFxplVi/ye/6Yn5CMcPjbtxLHwLwn2VzZuN+oyo0Vr0O4biO
vU9eP/Z+IG+CmIaIdrP1/NkgY0wMtU5x7soHwVxSWQ4zth6gO8/OkJT0QIxXrH6P
eg5t2wZOHVqv9Xmd4xMjjKXteU9rp9PWVA+93tBYyXbPGVTo4cet+OcpsxQqca0q
/xcjLiAY+p6jHXMMgh/r
=zljb
-----END PGP SIGNATURE-----

--=-z62jV6c73FJqmVGNA4jy--

