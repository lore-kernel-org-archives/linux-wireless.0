Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60059 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753095AbYFBMcZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jun 2008 08:32:25 -0400
Subject: Re: [BISECTED][NEXT] Wifi downloads capped at 105Kbytes/s
From: Johannes Berg <johannes@sipsolutions.net>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: Ivo van Doorn <IvDoorn@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <g1uicv$se6$1@ger.gmane.org>
References: <g1uicv$se6$1@ger.gmane.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-K1z6o2OExWFZf7/vNkTK"
Date: Mon, 02 Jun 2008 09:34:44 +0200
Message-Id: <1212392084.4148.2.camel@johannes.berg> (sfid-20080602_143255_828267_A130FB1A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-K1z6o2OExWFZf7/vNkTK
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

On Sun, 2008-06-01 at 17:22 +0100, Sitsofe Wheeler wrote:
> Download speeds are never more than 105Kbytes/s even though the bit rate =
is
> 54Mb/s in at least linux-net kernels from next-20080523 onwards. I have
> bisected it down to commit [2e92e6f2c50b4baf85cca968f0e6f1b5c0df7d39]:

[...]

> Reverting this seemed to allow speeds up to 1.3Mbytes/s (which is expecte=
d
> on this network). I believe I see this behaviour with both iwl3945 and
> rt2x00 drivers. Here is the bisection log:

[...]

> Perhaps a change was made but drivers have yet to be updated?

Thanks for your report. It looks like I forgot to initialise some
variables that now had a special 'unassigned' meaning with the value -1
while previously that was the value NULL (hence implicitly initialised
with a memset()). Patch in a minute, please test.

johannes


--=-K1z6o2OExWFZf7/vNkTK
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASEOik6Vg1VMiehFYAQLlsxAAtGUHuFWemR/0LNfi6hstPUAWk6UQqXt9
9wKq3HaWWSXEAqkWwS/JeeWj2Kbi/553CAQQ+xNTxdE7zHyXSzl3qw+UCvUu1G1P
jaX0aKw2ClhSeCffFpn0fi29GdBS2GAxUUUJMMekiOzB1r/04Y47rLh+IOXwLMm2
1RdhXHEfHdKSWDsBWZiiFAPUxpwiWVe2viQCMaXxmTlBKj0EwiFm0P1Wt/zLKntG
dmE+vAZ7jSXCH/pn1keZHs5IGRlrJSijA9fSAx4jHd/jKswjqlXjm66p3aYLuUnt
5ri6H12mM7VDyYa2JkSs2QAC3uu8SxXY2s7URpd2zgXVlrQE1Y5dUPpEE3qIjHMv
7o79CRJ0oR0oAEmfGKCEkQin1+wlnbhDzj2CsUR3qc4vsf12qIGEf1rBJuJpup9y
G70Fp7qvi/vtuwnWXw1tKL9Rx/NIXv/grumv4sNliDG5cOxV7kCCH1h8pOnWFvRI
Vmr+6C0qTQZeVd41J5Vz/ouB05JdEUzo+ccODU2fZ28ImJ2zQaaJXxNW+RO8YReV
PL7KgmzTELIZRw1SgQMIt0njrF4uDAfvFbyD450dICY7+wyjYjs0adbzvnSiNzpO
KXJlNAYJlRflR3wnDYCSS9YNSHnB0CeUtYmWGZcLlftQRaYsbacWrT3gjQt0CXyR
5UmyVabLmv0=
=Sdun
-----END PGP SIGNATURE-----

--=-K1z6o2OExWFZf7/vNkTK--

