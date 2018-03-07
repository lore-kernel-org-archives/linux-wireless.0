Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:48930 "EHLO bues.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932801AbeCGRjJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 7 Mar 2018 12:39:09 -0500
Date: Wed, 7 Mar 2018 18:38:58 +0100
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: arvindY <arvind.yadav.cs@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ssb:: use put_device() if device_register fail
Message-ID: <20180307183858.63172de9@wiggum> (sfid-20180307_183915_531856_A2EA95C6)
In-Reply-To: <5AA01E5E.8070002@gmail.com>
References: <bdd20c00cba68044d82e387072b39f0176448e97.1520416785.git.arvind.yadav.cs@gmail.com>
 <20180307174700.013e20ae@wiggum>
 <5AA01E5E.8070002@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 boundary="Sig_/8QLP00ucAYYl=k.ayzL1Mj3"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/8QLP00ucAYYl=k.ayzL1Mj3
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 7 Mar 2018 22:46:14 +0530
arvindY <arvind.yadav.cs@gmail.com> wrote:
> >> diff --git a/drivers/ssb/main.c b/drivers/ssb/main.c
> >> index 65420a9..c4449e0 100644
> >> --- a/drivers/ssb/main.c
> >> +++ b/drivers/ssb/main.c
> >> @@ -521,6 +521,7 @@ static int ssb_devices_register(struct ssb_bus *bu=
s)
> >>   			ssb_err("Could not register %s\n", dev_name(dev));
> >>   			/* Set dev to NULL to not unregister
> >>   			 * dev on error unwinding. */
> >> +			put_device(dev);
> >>   			sdev->dev =3D NULL;
> >>   			kfree(devwrap);
> >>   			goto error; =20
> >
> > I don't think this is correct.
> > The dev structure is allocated as part of devwrap, which is freed here.
> >
> > Why do you think we need put_device here?
> > =20
> Yes this patch is not correct, We must not use kfree() after you called=20
> device_register() (even
> if it was not successful!) -- see the comment for device_register().
> I will delete kfree() and send updated patch.


Is device_put() going to call ssb_release_dev() to free the structure?

Can you please elaborate on why device_put() must be used? The comment
is not really of any use here.

--=20
Michael

--Sig_/8QLP00ucAYYl=k.ayzL1Mj3
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEihRzkKVZOnT2ipsS9TK+HZCNiw4FAlqgI7IACgkQ9TK+HZCN
iw68Rg//ZUagsjDMEb+Raec3BZ2Bec1NIM5qruLG6GrmRVkja6vGfKeUkv8Z59NO
zXjO2QMl0v4CvZjpG8G8kq0SuXOFgP9j33xcQ0wZ/MarTRhtg99YbMSiRswqDYsD
I6dZNgDv2x57FO92ns6d43pzds9JW4C5nESwdwHQ5r0xcvMdHqkdeO93QqEI7Oym
8/wM0/5bPV6T3j6JRiqfyF4XAGli2FPMv9FzanybiHPZKAGTQOgUCheObph3pDtX
FzqhnLfWRZFYQpt1K/3Lam068v+XmdMTikbwiFDKvNZ8wrhDP55zonK+WL0Jr2Jn
mhrTIa5Vy1sejnMUsUMUUmz5MR89Xnf3fY52gS3SX7FSrQBjeeB/u9pBvOdP2urr
HxwnFU57VixEGb9+dobpsf4WHGLkzVF9fWO00/meT4LCDFZH+5aYkVk8rvbfOKI9
62t1DA+rPLxe1Uyu6rfRlVgwX88zH8J2/MY2Jvgyb1pGqIZW6D0cfj+Zb6VmFeDF
pq33pj5K2krGDDHCCyQsDntGGJWubTtp0LLybo809Sp8XSq59E0PuKyBij1L8OCL
drIB1pEzJjr2GecpfvJrDzd7KGkq60seBOLJcEhGV6lbeknSnEjPb4LL58j2bx+Y
awtiyTEYufi6n+HPqy9KJjzDbs4q5ty1bTEpH46grPsMhx/HPAY=
=+HuV
-----END PGP SIGNATURE-----

--Sig_/8QLP00ucAYYl=k.ayzL1Mj3--
