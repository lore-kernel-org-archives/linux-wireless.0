Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from parez.praha12.net ([78.108.102.1]:53831 "EHLO parez.praha12.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755758Ab0JKSU2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Oct 2010 14:20:28 -0400
From: =?utf-8?q?Luk=C3=A1=C5=A1_Turek?= <8an@praha12.net>
To: Bruno Randolf <br1@einfach.org>
Subject: Re: [ath5k-devel] Race condition in CRDA calls?
Date: Mon, 11 Oct 2010 20:13:03 +0200
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	"ath5k-devel@lists.ath5k.org" <ath5k-devel@lists.ath5k.org>,
	"linux-wireless" <linux-wireless@vger.kernel.org>
References: <201003251801.57951.8an@praha12.net> <AANLkTik7ckoex4pP1IkY0Vx1j-S4k0WVV62h7Sn4uGCx@mail.gmail.com> <201010081657.17326.br1@einfach.org>
In-Reply-To: <201010081657.17326.br1@einfach.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2184770.NuMoHc3vpn";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <201010112013.09521.8an@praha12.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart2184770.NuMoHc3vpn
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Friday 08 October 2010 09:57:17 you wrote:
> root@RMR1:~# 1284335259.046129: phy #1: regulatory domain change:
> intersection  used due to a request made by a driver on phy1
> 1284335263.403515: phy #1: regulatory domain change: intersection used due
> to  a request made by a driver on phy1
>=20
> interesting that phy #1 appears twice...

When I hit this bug my idea was that the problem lies in the CRDA API: the=
=20
wiphy identifier is not sent to CRDA, instead a global variable last_reques=
t=20
is used. However, if a new request is started before the previous one is=20
finished, the old last_request value is replaced, both replies use the same=
=20
last_request and strange think happen...

I hoped someone who knows the kernel-userspace interaction better will conf=
irm=20
or disprove it, so I didn't investigate it further, and then I just forgot=
=20
about it...

Lukas Turek

--nextPart2184770.NuMoHc3vpn
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iQIcBAABAgAGBQJMs1O1AAoJEEBjvk/UOfYwbNsQAKLciMcIoINyrmwMhWt/hnnQ
Kh3esxABDsSTunB2IYnyPOvmHqZXuRajnATbXI8Mxx3Zvj+se8He7JkmEjiY5C3Q
QHimNAsNWgfHdJXCTnOzt1urgv8VO9Y5jVHPtCUR66QuKE92ViuCjbtL/Xbj5Jvo
El6NDoUq0HgvpyviaZKNDPfYcbwlK5zEqqYLDafo/Y7o1DvlsgCLxPtqXQX6caDj
uTi6lqhjTYX9Y8OkneTPWw0+aiM8HoQGonf8eOMoHTGncqcGwnclxHqapoi2bebN
LJa0IuGDd17JSl8+g5boVJeQYfTbrzEi9kc0Fee7IFCXMerog89zgGFkpcVUxtZG
xhbgSS/lyj2CLIylGgwsj5erSwEoYt7opt9pXtO1gQo4NwmjO2NQA7XiWr2baf3Q
WtPEATYhcmgjpn+jybxRenxH1Mk2xVSbqqKWc48fI96TNk9fY0OGOCbwqXUQ+wvT
2d/4wkvm0vQFhmXJmeTIJgxYXAz0KWsY8TWDUcBKpAQmlVtA/nYyklm7rMG3iNyu
WfsEOP8ECcvTO3HSrVxVMzUg+jm9d44fMHJ9DpabYdjEGINrd+PBH4vLIFcNrtyU
4lac1GjhC8JJT44ZoV5crC5KdYYX4Eima99mB1EUxLZwISBe81wuNui4BlfCuVQ1
TKGc1qo8e3PXGdbjqcs5
=g+4S
-----END PGP SIGNATURE-----

--nextPart2184770.NuMoHc3vpn--
