Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59303 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760003AbYEETGH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 May 2008 15:06:07 -0400
Subject: Re: [RFC v2] mac80211: assign needed_headroom/tailroom for netdevs
From: Johannes Berg <johannes@sipsolutions.net>
To: David Miller <davem@davemloft.net>
Cc: tomasw@gmail.com, linville@tuxdriver.com, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org
In-Reply-To: <20080505.115855.137964071.davem@davemloft.net>
References: <1210000923.8245.26.camel@johannes.berg>
	 <1ba2fa240805051015t7dfd3bd2nf7bc2fc1ab9799ca@mail.gmail.com>
	 <1210010254.4181.4.camel@johannes.berg>
	 <20080505.115855.137964071.davem@davemloft.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Zxl5ijVc3VpdlsXeMeVo"
Date: Mon, 05 May 2008 21:05:15 +0200
Message-Id: <1210014316.4181.14.camel@johannes.berg> (sfid-20080505_210536_403991_8B87C93A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Zxl5ijVc3VpdlsXeMeVo
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-05-05 at 11:58 -0700, David Miller wrote:
> From: Johannes Berg <johannes@sipsolutions.net>
> Date: Mon, 05 May 2008 19:57:34 +0200
>=20
> > NETIF_F_FRAGLIST I haven't understood, but it seems to apply mostly for
> > IP fragmentation?
>=20
> That's right.  It's for cards that can do IP fragmentation in
> hardware.

What does "do IP fragmentation in hardware" mean?

ip_output.c says:

 *      This IP datagram is too large to be sent in one piece.  Break it up=
 into
 *      smaller pieces (each of size equal to IP header plus
 *      a block of the data of the original IP data part) that will yet fit=
 in a
 *      single device frame, and queue such a frame for sending.

and later

                        /* Prepare header of the next frame,
                         * before previous one went down. */

so that seems to indicate that if the hardware just sends it all out in
the right order it'll be fine.

So the point is that the hardware will have to split it up into ethernet
frames on the IP boundaries?

johannes

--=-Zxl5ijVc3VpdlsXeMeVo
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASB9aaqVg1VMiehFYAQK9Lw/8C0BsKLIAi9536avk69sYJADjF2oI1N0L
m6R1zFsn+hEQxyjeQrtWDPxjq5p8CcNS6col4S96nmLbwmLWw2R1KhzMhH9zzkBF
v6+bhAF7aYbBiv7kPSJPXB1hyrmwx1SRH0x7cFdZckgu5jJKJjSCxr3eXKhzK3+A
wy5QvA534lqGpVs1vWUGx9/nw+bA2ZiFede7tYC/iz8EtvR4GM0E4sZKEX1Fn/k+
zxegYGpbJ2BWeMJ+VXJkfwh2Bl6UyLJmPMrUT/RMrSttiE/AV3cMFXXRa4DMheDz
VsLiJIwjle3e+OLM640bFY91t3Uhw/2g3+p2WhX+rtWySFEl/BSAtgMo+35xCR56
BdGkIxSbm+o0vc9el7gHePgAPJjBvLHQWnl24vC0ZR+hMHDonN2uTZJMa2dD+ODI
UQrT95uolewHcvkoQr9tvx/g3YshBZT/pzjilYnQydDbtj6MAb2h7L/9gDHafSDy
Kevgnm24UwJr5HNuDakKqHW5G2IgizeCWa3/osIYeZWPCXJ7c0orl9BK4no74yL8
qsxARKFnSYwZ/KevSeh+qO73Do04Gjkhm7kNDu8eqyhKElPvkznBojwbzqIOwDe2
JyhJ7AdUcvzNYfARBjvk1zAAJcP2wqfekXLhBydqTZaNqEBqAEfB65SW8ykzsTKE
Ofr4m4xm0VQ=
=Mqqs
-----END PGP SIGNATURE-----

--=-Zxl5ijVc3VpdlsXeMeVo--

