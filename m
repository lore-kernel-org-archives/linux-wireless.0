Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:48844 "EHLO bues.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933937AbeCGQr1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 7 Mar 2018 11:47:27 -0500
Date: Wed, 7 Mar 2018 17:47:00 +0100
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Arvind Yadav <arvind.yadav.cs@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ssb:: use put_device() if device_register fail
Message-ID: <20180307174700.013e20ae@wiggum> (sfid-20180307_174732_830008_40A85F08)
In-Reply-To: <bdd20c00cba68044d82e387072b39f0176448e97.1520416785.git.arvind.yadav.cs@gmail.com>
References: <bdd20c00cba68044d82e387072b39f0176448e97.1520416785.git.arvind.yadav.cs@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 boundary="Sig_/e7s3cKLiB+CjWA0fZIySKos"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/e7s3cKLiB+CjWA0fZIySKos
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed,  7 Mar 2018 15:31:30 +0530
Arvind Yadav <arvind.yadav.cs@gmail.com> wrote:

> if device_register() returned an error! Always use put_device()
> to give up the reference initialized.
>=20
> Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
> ---
>  drivers/ssb/main.c | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/drivers/ssb/main.c b/drivers/ssb/main.c
> index 65420a9..c4449e0 100644
> --- a/drivers/ssb/main.c
> +++ b/drivers/ssb/main.c
> @@ -521,6 +521,7 @@ static int ssb_devices_register(struct ssb_bus *bus)
>  			ssb_err("Could not register %s\n", dev_name(dev));
>  			/* Set dev to NULL to not unregister
>  			 * dev on error unwinding. */
> +			put_device(dev);
>  			sdev->dev =3D NULL;
>  			kfree(devwrap);
>  			goto error;


I don't think this is correct.
The dev structure is allocated as part of devwrap, which is freed here.

Why do you think we need put_device here?

--=20
Michael

--Sig_/e7s3cKLiB+CjWA0fZIySKos
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEihRzkKVZOnT2ipsS9TK+HZCNiw4FAlqgF4QACgkQ9TK+HZCN
iw7wZA//XZn6QV6ecZwJmJhg11XAtrPXpucxihVmvFufvps54O14uEEqxAaX4vJb
+7OHM8PEyzXBfpdZeARR5SJDmpa+7aVbB/ZFw0yDPD6saMDwbmvd/lkvSbMGTmJZ
SqHsx1s/HU5P0a2lL6cpfe2TPgb/H9ipcI5/xf2w46gp4wmSx2Am2VQ17lrF7bqp
14vQTTWKPLChS8oqXVX36kyuNFw6GDnrdh/wh+2uW6l7LQ/LrShHipg9JsZHTPqZ
XL+hcAvUQEXtKRG5R30XpQlEEUllP9FTE3fJHfE3hUHqqwayg7h7ljCHUFw9r+2K
ndCYCZzO8Aj0XJ+RLF7Ib4GwImjEzPup/IF36sFljOjwG5UwaRNMdfJaQMBLAPY8
lXjI3ydcv8kd+kMgs/K7y9wXF22rtEPBJg1i6PqsBVUWewc1gOztP7ZvdUSmjedK
HiEPJqxj7lBxFggAfvEDwx21w1dPxA94BeQEoeUMtnmWq5opKdKiFp0X6aWQdhED
IveG5XOYBXdZNZ2O1ub+VlBeaMikJmD2+9dCSr/1jeAmd64TVxXlu9axZ/3oz+ah
z0Kij0+KNURcZi3u+S8WcraaCHw5I3Q5csDjndsb1CI8neOsieWxwRsvO4w11AP8
xgjPpM3P2xV9VeXux1Am1kn8DjWA/B+Ucdie5naqZKwGfdCEhe0=
=k5O2
-----END PGP SIGNATURE-----

--Sig_/e7s3cKLiB+CjWA0fZIySKos--
