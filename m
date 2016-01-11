Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:32947 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758907AbcAKQoc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jan 2016 11:44:32 -0500
Date: Mon, 11 Jan 2016 17:21:53 +0100
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Jia-Ju Bai <baijiaju1990@163.com>
Cc: kvalo@codeaurora.org, zajec5@gmail.com, joe@perches.com,
	davem@davemloft.net, johannes.berg@intel.com,
	linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] b43: Fix a memory leak in b43_bus_dev_ssb_init
Message-ID: <20160111172153.37a9613f@wiggum> (sfid-20160111_174452_262172_07B23441)
In-Reply-To: <1452483457-568-1-git-send-email-baijiaju1990@163.com>
References: <1452483457-568-1-git-send-email-baijiaju1990@163.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/GnvxRiYlWXY+V_2Fc2mecJy"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/GnvxRiYlWXY+V_2Fc2mecJy
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 11 Jan 2016 11:37:36 +0800
Jia-Ju Bai <baijiaju1990@163.com> wrote:

> The memory allocated by kzalloc in b43_bus_dev_ssb_init is not freed.
> This patch fixes the bug by adding kfree in b43_ssb_remove.
>=20
> Signed-off-by: Jia-Ju Bai <baijiaju1990@163.com>
> ---
>  drivers/net/wireless/b43/main.c |    1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/m=
ain.c
> index ec013fb..6d251a0 100644
> --- a/drivers/net/wireless/b43/main.c
> +++ b/drivers/net/wireless/b43/main.c
> @@ -5798,6 +5798,7 @@ static void b43_ssb_remove(struct ssb_device *sdev)
> =20
>  	b43_leds_unregister(wl);
>  	b43_wireless_exit(dev, wl);
> +	kfree(dev);
>  }
> =20
>  static struct ssb_driver b43_ssb_driver =3D {



Nice catch.
The kfree is also missing in b43_bcma_remove().
And also in the error paths of b43_bcma_probe().

Can you please extend the patch to cover these, too?

--=20
Michael

--Sig_/GnvxRiYlWXY+V_2Fc2mecJy
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWk9ahAAoJEPUyvh2QjYsOJy0QAKj6GI9KB8AXWUiZ3Ev6q97Y
JPmYZOmMcM0viRj6NEoJMLOn6P+fbodpASw+i2Zy1wnHlaWxBA6vJEQdRLWTzqyA
Z7Np67tp18ZwJatR47TuXOn3BGJTqkwNpZgjKviNIppqSZIL9u9xRYMSeMx2/Y7Z
Ghwmgc5RgzK5+CAUZUJSbwbihX0B/FDP6qyYAie0f6UJvqqWV6nC1pwKUgAFxMEz
R549brvd627OiwJ2qPaP6CylWVmsNgnMm0XyyQgNKRowpuualhhavBPVWCmuDKDq
yZbuUpIWwZ3ikXYbw++AhQ7nJBHiuwPSRI1yTKT0D3ayaT43RPVz0SC7IXryLUP6
6ic8YO2pg25lojmfR8GBhdzaugNzd+lSpTsLFrHA9PsFY7pnZ/fTQpvyTVyT+ZZM
UqeZBpeLZs6frsQNhZB1loQ6maIKQf7Cr4gDq1c7A/6vZuwZlXZStepBGl5B8kwU
0jIWyUPpLwnypcrc3LCriDfYNEl7rjTt9hP3E58/IqvzaxBd9ZZPka5Wk9q2JhGE
NTTQlzYooHqlOvdUYvuq04kZfikr3L7xB+go947h6gcsfKMr7RaLLUVVsJHn2lFU
nZdNpwpCS2Zq1oxsppVoCdHlBcpa+kOQoSHm3Xo5I64KoJ8oQr9RDxuN7SwPH7TE
JdwCjFjs9c7KhwsGa5vJ
=DMiL
-----END PGP SIGNATURE-----

--Sig_/GnvxRiYlWXY+V_2Fc2mecJy--
