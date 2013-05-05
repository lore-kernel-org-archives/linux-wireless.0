Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:56707 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751296Ab3EEN4m (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 May 2013 09:56:42 -0400
Date: Sun, 5 May 2013 15:56:19 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: Thommy Jakobsson <thommyj@gmail.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
	piotras@gmail.com, Larry.Finger@lwfinger.net
Subject: Re: [PATCH] B43: Handle DMA RX descriptor underrun
Message-ID: <20130505155619.1f316a6b@milhouse> (sfid-20130505_155656_381655_041128EA)
In-Reply-To: <CACna6rxWPOqQPNUaASaj=v=O+Wjt0okjX4jNwE3tv-=etfATCg@mail.gmail.com>
References: <alpine.DEB.2.02.1304231851040.1513@kelly.ryd.net>
	<CACna6rxWPOqQPNUaASaj=v=O+Wjt0okjX4jNwE3tv-=etfATCg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/z6/NQOpPMHu/kVznsO3vy0S"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/z6/NQOpPMHu/kVznsO3vy0S
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sun, 5 May 2013 14:44:14 +0200
Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com> wrote:

> 2013/4/23 Thommy Jakobsson <thommyj@gmail.com>:
> > Add handling of rx descriptor underflow. This fixes a fault that could
> > happen on slow machines, where data is received faster than the CPU can
> > handle. In such a case the device will use up all rx descriptors and
> > refuse to send any more data before confirming that it is ok. This
> > patch enables necessary interrupt to discover such a situation and will
> > handle them by dropping everything in the ring buffer.
>=20
> Thommy: does it mean firmware actually ignores what we write to the
> B43_DMA64_RXINDEX (recently renamed to the B43_DMA64_RXSTOPINDEX)? Is
> our set_current_rxslot and op64_set_current_rxslot (same for 32bit
> version) useless in this situation?
>=20
> Could this be a off-by-one issue? Maybe we're writing a value too low
> by a one and firmware believes the whole ring is empty while it's
> full?

The ring looks the same if it's full or empty. We can only know that it is
full when this interrupt fires, which happens as the indexes collide.

--=20
Michael

--Sig_/z6/NQOpPMHu/kVznsO3vy0S
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRhmUDAAoJEPUyvh2QjYsOcRkP/jvbvHqTZrO8mnSGa8uiuNjY
33b+P/iTGhzWfSlpIyNtP9JVdyJTpgirUwK8qYnBt1kAxtzih6/Q+0BnrHCyuXwF
+NrLY4DjgT+2egw4dkHj1Ig7TR8adOs0B4acmx0UJSje6juOmRnGUNQCRXNz9NkP
o7crh6xpz6W3v2Oo0PEM8bV3PYfRYMRmczZ9YrzZzw8XEYGHixB3X6uUH47RpbM1
jf2yffHxOcmX23YOwVAX6jfFWke/l3h7rkswzeoQ0X/dUOZiN33RnXor9EL1W64H
3CX++pq0exR/WP61yUWAkljQiMxNVA1slk8iUxtL5FxRKTHyfe+Wse3OI4vdZnjb
auxo3/arCdEDITpMkz2z9c+N/3VCS8G92zDZRfGTL3SIHxitqZBe5wTuLXCHlHh3
MeP+1ptoJ/W7LJ7dOIwwvh4NcrR0bLQWATd6qT8heXIQX+Jl2c7ddeOFhG3UgyNz
48I4ZxMsuo0FTJunQMAn0+Dyym6GOoZP6+g0h4efn3qeIOux5TW4VPOpy3t6tKYC
FnXLAF+H5z+MkbAB6wHF9lduAwhDqhZQkkRK7bXG9lT3zjAAKSRehVN3ZsF9K9Vz
WPpK/SM9VIQPBrQxAwDJsoxij8ZVtnx42qR2zjpDlDUcvO9xydCmB7uab9EUHLY5
3J5AGMbOVauOF7tS0xgw
=l2pC
-----END PGP SIGNATURE-----

--Sig_/z6/NQOpPMHu/kVznsO3vy0S--
