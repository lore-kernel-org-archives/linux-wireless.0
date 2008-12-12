Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41862 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522AbYLLW4n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Dec 2008 17:56:43 -0500
Subject: Re: [RFC 2/3] mac80211: Make use of the new F_TX_NOACK and
	F_TX_NOSEQ Radiotap TX flags
From: Johannes Berg <johannes@sipsolutions.net>
To: Stefanik =?ISO-8859-1?Q?G=E1bor?= <netrolller.3d@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <69e28c910812121451u25713c82o229a56006089edd6@mail.gmail.com> (sfid-20081212_235104_744345_FF8EB7B3)
References: <69e28c910812121432n6e84de41s94a887110051a1dd@mail.gmail.com>
	 <1229121558.3565.6.camel@johannes.berg>
	 <69e28c910812121443h1fae52e6uc88749d7e9baf529@mail.gmail.com>
	 <1229121947.3565.13.camel@johannes.berg>
	 <69e28c910812121451u25713c82o229a56006089edd6@mail.gmail.com>
	 (sfid-20081212_235104_744345_FF8EB7B3)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-WzzlH8rJGsrLBtWuuUX8"
Date: Fri, 12 Dec 2008 23:56:38 +0100
Message-Id: <1229122598.3565.22.camel@johannes.berg> (sfid-20081212_235645_513973_F6FBD2B8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-WzzlH8rJGsrLBtWuuUX8
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-12-12 at 23:51 +0100, Stefanik G=C3=A1bor wrote:

> But if we redefine !ASSIGN_SEQ to mean "use the sequence number
> supplied by userspace", we will need a new flag to distinguish between
> driver-level vs. stack-level sequence number assignments, which is
> essentially the same as this patch. There is no way to switch between
> 3 states (control in driver, stack or userspace) using only one bit.

No, wait, that's not true. We just have to make the bit be set to 1 by
default, and let radiotap or the stack clear it. Then if it's clear
after radiotap, the stack won't assign a seqno, and if it's still set
then the stack checks and assigns seq and/or clears it.

Might be easier to use the other bit though instead.

johannes

--=-WzzlH8rJGsrLBtWuuUX8
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJQuwiAAoJEKVg1VMiehFYTT0QAJ1VCaDxY/s8PVqYlXlPSFbo
Yfu/oBxXX8xNC0jnF5toQEgQOvMMkPngX/+9e4efETC6vBQrhBMAKBFhsQ+ABDkR
rv9wC4fhDptNbTfwf0u1czKFzoNUBSZK0Ta/kAgYSifGevJ7owHHQ8o1T0WyljQJ
KB5CXfRLrdwGXcCOvV5DWkapCt6Bd0+0zdA+RPFVaxN9jpIZ7bRWQiljiVHMGw/P
2c0ndfIlhSMVr0U/8O3HyGBDJgOsXTKP7B9qECunA/7V0qklnbvJXy+MMA8LJVs5
r1PaOaSex2eJn6wxjO+urfQx0ACRk/HgMqVh7kHepmB5mWasM7E8GboCPf0ycKGe
0Ifc4cm4osM223kA440xHox6AoAxdAxhfSv5aKaUjMVHhG/MxwigxVOhK+jbfvCB
NuUI+wgontZJLJbwxEqkJogOCU6dlJsYFWe1B3qj5jGgGjUDYRyeBEh5AaAz8NJf
xN0VxQWfLPMrXKHHqWPx8go26lFNPxMNdgTo9YJlUlXPtcvHx4GMSXrquapUO+u6
bm/KAcuYwn2ESLXTYmKDDHMPKvxsVsHrLIt4r4gj0gVAeV/CVd5wrgmgyPo95+ig
WvPOdMRHTFDIN0726IrLFXoOYGqvxRjdo1MU3UEFJI2jEqrk1PkB2QM7RzuIsLXf
4hsBnJePHDIdz1ztiarK
=xqCH
-----END PGP SIGNATURE-----

--=-WzzlH8rJGsrLBtWuuUX8--

