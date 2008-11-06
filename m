Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:45216 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311AbYKFOpN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Nov 2008 09:45:13 -0500
Subject: Re: [PATCH/RFT] iwlagn: remove pointless TX frame check
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1ba2fa240811060641xe70c29cgf4e8dbf36b29636@mail.gmail.com> (sfid-20081106_154200_146024_47246AE8)
References: <1223547733.22490.43.camel@johannes.berg>
	 <1ba2fa240810091308r167b9147p46f74421329a55c1@mail.gmail.com>
	 <1223630089.3930.71.camel@johannes.berg>
	 <1224794532.6002.73.camel@johannes.berg>
	 <1225974603.3619.219.camel@johannes.berg>
	 <1ba2fa240811060641xe70c29cgf4e8dbf36b29636@mail.gmail.com>
	 (sfid-20081106_154200_146024_47246AE8)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-B6tNgUAqtkuXwrWrKFv5"
Date: Thu, 06 Nov 2008 15:45:11 +0100
Message-Id: <1225982711.3619.240.camel@johannes.berg> (sfid-20081106_154519_313658_CAD9E637)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-B6tNgUAqtkuXwrWrKFv5
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-11-06 at 16:41 +0200, Tomas Winkler wrote:

> I'm working on it right now. Practically instead of association check
> what will  remain is check if everything is station is properly
> configured. Meaning stations is configured in the set in the firmware
> and rate scale is also set.

That makes sense, though I think for frames we can't find the station we
use the broadcast station anyway (to make injection possible), so
shouldn't the station _always_ exist?

> This will cover all modes. Need to implement sta_notify handler and
> move some code from rate scaling to the driver.

Alright.

> There will be never full synchronization between mac80211 and the
> driver about internal station state but the check might be very
> simplified.

Good, thanks.

johannes

--=-B6tNgUAqtkuXwrWrKFv5
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJEwL0AAoJEKVg1VMiehFYUsYQALFpvubr2iOu1UgAoKLQnYx4
nMUg+s+aMtxIA6dXiFSlKJ4YhJBn3DIzQx2qfF2G2N5iiTSvAHEoBb5Ppxe0DqGp
+mHb+YjrNqKLNyTXGX3Opf+aoJPDiBAbTbBSzLEsriCQqoouqFiNFwo6Q+gUqLF0
iwBvPd8rsKJrcgjzqxGrQIeLl26erZpLwAvcigHkFuJOgND9C/ACA2kiKNeuefNc
Ym/ttVxLNTTJz0TaPmMVqQh468GdMm8U8WTT2D6I8QLW+Ggf1njeoV6ywvneleot
7as4VqXFVgiSf5EfdYCxTQPSQ7lWA0u9FnGsV0HQc04Rt2e/bp6KqmCUh7v+Z45t
hIVSm9wOgaKW5Ga29gExZnWdmIa63J0CXpSvbaVHIDypUbYZE5ImTLbf/7244zwi
vRXO3AnYghQ5xGolBLgc2WICMfUksBTGBiMNr/571cuMrxC+5Yzt6dbc7mgMNbxf
5XDxa3+IcnjDPoJm65QbFkIUz4rVKPjD5UEwxY2uALrnW8jkfHPARhXeESkNFRhi
0aQWpN9zeLaV02Nds70yllyQBtWlrxKpzmvrcXEIFYwsHZVE9A2B9zXBgoSuNIqh
Wq0002uo0zV3KMGzgHnFbS8pbok9GXr0YQmUsnm2i3slL2LrbsG5WP8y4G7CtA/A
dY7mQrvbmSjUPBNHvXn9
=s4Ft
-----END PGP SIGNATURE-----

--=-B6tNgUAqtkuXwrWrKFv5--

