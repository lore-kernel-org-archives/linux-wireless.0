Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51190 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751766AbZGSIxu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Jul 2009 04:53:50 -0400
Subject: Re: [PATCH] acer-wmi: fix rfkill conversion
From: Johannes Berg <johannes@sipsolutions.net>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Troy Moure <twmoure@szypr.net>, linux-wireless@vger.kernel.org
In-Reply-To: <4A62DDDC.5090100@tuffmail.co.uk>
References: <alpine.LFD.2.00.0906171135080.3376@troy-laptop>
	 <4A62DDDC.5090100@tuffmail.co.uk>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-yCo5wsN6+7R1xKIwui1S"
Date: Sun, 19 Jul 2009 10:53:38 +0200
Message-Id: <1247993618.4204.3.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-yCo5wsN6+7R1xKIwui1S
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2009-07-19 at 09:48 +0100, Alan Jenkins wrote:
> On 6/17/09, Troy Moure <twmoure@szypr.net> wrote:
> > Commit 19d337dff95cbf76ed ("rfkill: rewrite") incorrectly reversed
> > the meaning of 'state' in acer_rfkill_update() when it changed
> > rfkill_force_state() to rfkill_set_sw_state().  Fix it.
> >
> > Signed-off-by: Troy Moure <twmoure@szypr.net>
> > ---
> > This fixes the rfkill switch on my Acer laptop, which was behaving
> > backwards (the state reported in the logs was the opposite of the
> > state indicated by the LED).
>=20
> I think there's another reversal error that you didn't notice :-).  I
> found that acer-wmi disables the wireless when it is loaded.

Ahrg.

> The core tries to initialize the wireless to enabled, but the polarity
> is wrong in acer_rfkill_set().  It ends up disabling the wireless
> instead.
>=20
> Here's a patch for it.

I really should go back and audit it again, but every instance takes me
about 5 minutes to do the (not state !=3D unblocked) thing in my
head ... :/

Thanks!

johannes

> --->
> From 75953366b4958a77019729662a997f5d361a7529 Mon Sep 17 00:00:00 2001
> From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
> Date: Sun, 19 Jul 2009 09:29:21 +0100
> Subject: [PATCH] acer-wmi: fix rfkill conversion
>=20
> Fix another polarity error introduced by the rfkill rewrite,
> this time in acer_rfkill_set().
>=20
> Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
> ---
>  drivers/platform/x86/acer-wmi.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/platform/x86/acer-wmi.c b/drivers/platform/x86/acer-=
wmi.c
> index be2fd6f..fb45f5e 100644
> --- a/drivers/platform/x86/acer-wmi.c
> +++ b/drivers/platform/x86/acer-wmi.c
> @@ -973,7 +973,7 @@ static int acer_rfkill_set(void *data, bool blocked)
>  {
>  	acpi_status status;
>  	u32 cap =3D (unsigned long)data;
> -	status =3D set_u32(!!blocked, cap);
> +	status =3D set_u32(!blocked, cap);
>  	if (ACPI_FAILURE(status))
>  		return -ENODEV;
>  	return 0;

--=-yCo5wsN6+7R1xKIwui1S
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKYt8OAAoJEODzc/N7+QmaryEP/0dz47eYn28F3MfHamsxwfCS
fBsdh6s03b9j51IxPaI2X35n+kdUdeWF5lD7mTJFU1WrqFCzI8Q18bZT+7Q+fhgc
2WyQS0I/0Ko/T4zWmk+3sERCDAV4PggsgA/FbKPqnNcBoAPQ7DPThwdU7Wm5SjNC
mvi5WmPyYah4NGAo7ujVZnjCFYZ6WFD52yurzZ6RXzhoBIY7aDL3pks72mF4QaMY
JgybWOPmRijQfMtjfHzvQydaQqWURkWGFDLoIYl048Un4CENJaB/UiLU2Z0KiqN9
Fl8r+rl4EMFt7oyBw0l51kwunYxyAQ5EkylYEjwYSf9JhPWY/DBQQRCra0OBCgn9
iQjZqTvyc8MQFeiieZEU2QZFC4DAyFCvKmyeOnOyHyxwNZdy4XX1ZeHUmyWQGi45
npqP/nT4DMTsZJX3vYqTVEtNRz2W9NF6Qye3Xr2eK1O3aPW2/EwVcdky9tLF64dd
pkJlwIQA8ZXdKjiFXrzlT/5dJP5EcqHItAkgWOpoEbBl+3gT98c67/FqMqjgfVKl
nAEg8fPvV7CsEREOKyjpiRzpJfWN4r1hftKrYdMXsR5UNE8DhZeqp5/KNZxb5Q0Y
bdHnEELCsyqillRGyAXPL4XaBdeRB7lUx69GC1HouFJoC3hYFuuaI/Qwsjfr6ZUI
hE6TGE1BBjdW1mPX2x47
=8Yqp
-----END PGP SIGNATURE-----

--=-yCo5wsN6+7R1xKIwui1S--

