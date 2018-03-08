Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:49954 "EHLO bues.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965207AbeCHGMU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Mar 2018 01:12:20 -0500
Date: Thu, 8 Mar 2018 07:11:49 +0100
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Arvind Yadav <arvind.yadav.cs@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] ssb: use put_device() if device_register fail
Message-ID: <20180308071149.75f3c872@wiggum> (sfid-20180308_071238_713560_E8F037AC)
In-Reply-To: <1520485789-8550-1-git-send-email-arvind.yadav.cs@gmail.com>
References: <1520485789-8550-1-git-send-email-arvind.yadav.cs@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 boundary="Sig_/YpWQxs8wW6p/c029KPOf7O/"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/YpWQxs8wW6p/c029KPOf7O/
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu,  8 Mar 2018 10:39:49 +0530
Arvind Yadav <arvind.yadav.cs@gmail.com> wrote:

> Never directly free @dev after calling device_register(), even
> if it returned an error! Always use put_device() to give up the
> reference initialized.
>=20
> Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
> ---
> changes in v2:
>              Removed kfree() call for @dev.
>=20
>  drivers/ssb/main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/ssb/main.c b/drivers/ssb/main.c
> index 65420a9..a7a062b 100644
> --- a/drivers/ssb/main.c
> +++ b/drivers/ssb/main.c
> @@ -521,8 +521,8 @@ static int ssb_devices_register(struct ssb_bus *bus)
>  			ssb_err("Could not register %s\n", dev_name(dev));
>  			/* Set dev to NULL to not unregister
>  			 * dev on error unwinding. */
> +			put_device(dev);
>  			sdev->dev =3D NULL;
> -			kfree(devwrap);
>  			goto error;
>  		}
>  		dev_idx++;


Would you please put the put_device where the kfree was?
So that the comment still matches.
Thanks.


--=20
Michael

--Sig_/YpWQxs8wW6p/c029KPOf7O/
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEihRzkKVZOnT2ipsS9TK+HZCNiw4FAlqg1CUACgkQ9TK+HZCN
iw5sSBAAw3XKYDfxFMPby85iueyKrVC3BA8mW7ExSG8dmmzKQT+8GVBDeBVWQ/Pe
4fq8DLIxfSi1ONvW7ulSFCqkVlRaDKXWYy2a45q/zSq3HCgocsed2uxPioEKV9Yk
1KFb/5GhKlBRRkYy50wCXcC4oo5SNcfD2Mlbb9bo3ZE9HFZwgOmdNp1PWjmXuA1O
6NCKNlg8++gh6g7T8iVF/CyXBwjD0Y18qrr6anJ6J9LrjhndHGZRlcFw+gtVdyuX
BIgDumUb0TC7h4Z9UvCfvPM9CfGbY7ZEqq9FFdqiLXTwu5HRbwm6SurVsSU7fXB0
ssHTjGF93DFw4OfyrpZkQSoinZj6xOL3eABrHhdNTxGTVZk5C25XybWXAtFpxvkW
adNKMw555WQcuzLYLd4/8a9Ty+YOoBRhIrcKpcTXC8Nae58giHp0DlSg9g9t9ywx
AUhBYp/0bU7Nyn9wQ+8pTQaDHjFSrALrX8+SYM4O3USuyE91x6+7F6LrJJt5eHvj
hbb0X848zsOgUk9h84IcP1zbcx+CJh4jjjYKm9cBgfNtDfAfDIToX4CkY7+wdrGz
IXq0usbB11D7cAzuaHXG6SEi7WOO9UjZZdlW8efgRpjjjD8TbmU+VCkw+/USSuMN
vm6KFyo0Fh/eAvuaOzD8MmMc/XWCuQCyRQtlo2RJ63aGtG0ZYOk=
=Z4k3
-----END PGP SIGNATURE-----

--Sig_/YpWQxs8wW6p/c029KPOf7O/--
