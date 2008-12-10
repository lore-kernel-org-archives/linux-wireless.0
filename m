Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53584 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217AbYLJSHM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Dec 2008 13:07:12 -0500
Subject: Re: [RFC] b43: rework rfkill code
From: Johannes Berg <johannes@sipsolutions.net>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Michael Buesch <mb@bu3sch.de>,
	Marcel Holtmann <marcel@holtmann.org>,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de,
	hmh@hmh.eng.br
In-Reply-To: <20081210175102.GA14282@srcf.ucam.org>
References: <20081210150935.GA10927@srcf.ucam.org>
	 <1228929529.15837.34.camel@johannes.berg>
	 <1228929820.15837.40.camel@johannes.berg> <200812101831.13526.mb@bu3sch.de>
	 <1228930643.15837.48.camel@johannes.berg>
	 <20081210175102.GA14282@srcf.ucam.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-949V/FGIJiswv9As3okm"
Date: Wed, 10 Dec 2008 19:05:43 +0100
Message-Id: <1228932343.15837.57.camel@johannes.berg> (sfid-20081210_190717_172229_456779F7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-949V/FGIJiswv9As3okm
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-12-10 at 17:51 +0000, Matthew Garrett wrote:

> They may not be physical buttons, but we can often control this anyway.=20
> For instance, my HP has a button that will perform a hardware disable of=20
> the wifi card. However, I can control that button's state through=20
> software with the hp-wmi driver.=20

That's indeed a complication I wasn't aware of.

> The way we currently handle that (and,=20
> I think, the only way we *can* handle that) is to provide two separate=20
> rfkill interfaces - one tied to the wireless device, one tied to the=20
> platform device.

Yes, but how do we currently do this?

Does the wireless driver get the notification about this from the
hardware, like it would if this was a real physical switch? Then it's
probably pretty simple: provide a rfkill struct from the driver that
updates hard-kill and provide a second rfkill struct for the platform
device that doesn't get hard-killed, but also provide a soft-kill input
form the platform device. That way, you can toggle that button, but you
can also software-enable the platform rfkill device and that in turn
re-enables the wifi-rfkill "hw" switch device.

If we need to tie them together in software it gets more complicated
though.

johannes

--=-949V/FGIJiswv9As3okm
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJQATzAAoJEKVg1VMiehFYYQkQALXMhZeJQ3oU8HGuyqBpO3ZG
lB4aP6TSKDYWkEGZnhI1/diuoQcrAoPqpAMzOTub9OsIhMDI8+8t3tV9RpZ7bgcl
pFZLBHfmwfc8g31SW5vLdpIfG2Pa9T76JQNokGurstM9ZO3znxa/QWyL/0PwDMTD
qZO2FGG7nyOSpoUqd6Ms1WzvBDnUmoNklHFIYCiZXlQNgORt97TlzPL3cyFxb6c4
4cYZl2fSS99TW05XUWjsIYEd+GDDun2X7w5U1PBbpjm43dPrVr2obGVCVH/xGvEf
64PWSTUjnO41D9dNTlGTAn2MHcARhk0qOgd9E3KEhOhSuMGpaqKTUWuXxWUsSuT0
Fxp1IsZjXOzsXhR0d6/ZYaYFUEmcJT+XFHIJDPLycnksoe+OLQzaBtEUxcmTIDmo
UswcAf8vSwXHHimQwT4JxlFFEYtzTuZX6Z+JJ81JR5ZT3EssbjqNmz/8TStQ8ckN
bZvEo/0F3RzYsgSPeZjAFvw4UpFf2u4RP6GDoz2go0FNNboynK9nbY3BBU42J7rX
MmD4UmvLaYBARE5VFFej1PWkFRZxvUHDh0jaZR559Iq4HUUhMuBQa5rKA2QTCCd/
0zulhaEIftbhDER6K+E1WEmjuMFMrBiSn+dCodcfNE+zmBaXFPrGWnje/iVakJ0X
ZZJebQTCZLWMOW/lGsq5
=nWYU
-----END PGP SIGNATURE-----

--=-949V/FGIJiswv9As3okm--

