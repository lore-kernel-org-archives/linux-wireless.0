Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:43728 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752914AbXJJIoP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Oct 2007 04:44:15 -0400
Subject: Re: [PATCH 5/6] ath5k: Add documenation for atheros bssid_mask
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>
In-Reply-To: <20071006012017.GE25022@pogo> (sfid-20071006_021900_330401_BFB6BA14)
References: <20071006010449.GA25022@pogo> <20071006011657.GA24862@pogo>
	 <20071006011837.GB25022@pogo> <20071006011923.GC25022@pogo>
	 <20071006011949.GD25022@pogo>  <20071006012017.GE25022@pogo>
	 (sfid-20071006_021900_330401_BFB6BA14)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-/pEdNlP7PQ36fZQ6qiPA"
Date: Tue, 09 Oct 2007 22:05:32 +0200
Message-Id: <1191960332.4013.56.camel@johannes.berg> (sfid-20071010_094419_257329_084F5742)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-/pEdNlP7PQ36fZQ6qiPA
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-10-05 at 21:20 -0400, Luis R. Rodriguez wrote:

> + * Note that this is a simple filter and *does* not filter out all
> + * relevant frames. Some non-relevant frames will get through, probabili=
ty
> + * jocks are welcomed to compute.

> + * IFRAME-05:  1101 --> allowed but its not for us!!!

This is why hostapd will always use a mask that ends with the bits you
want and basically requires that you reserve the full MAC address space
for all matching BSSIDs to that station. I.E. hostapd will set the mask
to 0x3 (or is it ~0x3? you know what I mean) if you have three or four
BSSIDs and if you only have three it is assumed that the fourth is
unused.

johannes

--=-/pEdNlP7PQ36fZQ6qiPA
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARwvfC6Vg1VMiehFYAQIOXhAAvICtBtgs9FKp7Jzi4kZvKw22Zb8pS8gD
Y2kq7RO96TGlVxB77PeP9z7dDQZiDaqxCfGCId/HS/hn0yVigyVsEMUHmOhJrFWD
avTrGyQn0z0pj6EdMkPU9IJCd00QXSxYNlkLpyJLFcuvft3IBpeWph4mt1VHFmRZ
RnkjYbJphOQ/BCxaYtXmYBKF9cH0H3uTrInqgZJtbTgsZc99WEjAWi1kLfAaOrd5
c+4Hlt7Fe13D6JqkYJ1H2/ZHwZYDs4LxsL0wOi3Rwc0P875CAMpYsYeC9epWexJ3
r9Xe8r4tkb/0kaYB2GrdlREDIPZ/AYqao59P772TqZG22Etvk8Mb2y3HgbnNnYWQ
XZCIQwTBWxxRPgVkF6m/Lzt6096x/wevE8n5gEQ/RVxKpsv4sp8R6/C9NQQXHfFm
3cP24kSx4vAVGIJ+KBrX0/lAAI8neigLDk0i2DuJfjhA/bqETiNuWDZ4iDOxzXIL
HCkwWFDPKylpcn6Qk2/EhPZsQj6cvTvG2dEIsNpdhGGrBGY1hEcekluIXnyKPOwr
Q8XaXWwWPKp+ERQyvlSMY0im6IgFm/blxmAx235tCpu1BwhBzT6C7MOjQVwt7eno
PbSrQ09YYmFzQQm4C4QNl+KnuIK0FMNpMrcW2/5wukjApVDJD+zzSN7THzLj+ta5
NW2IXcejEXw=
=xjS0
-----END PGP SIGNATURE-----

--=-/pEdNlP7PQ36fZQ6qiPA--

