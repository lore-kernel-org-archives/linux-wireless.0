Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from parez.praha12.net ([78.102.11.253]:41171 "EHLO
	parez.praha12.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752153AbZKZTO5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Nov 2009 14:14:57 -0500
From: =?utf-8?q?Luk=C3=A1=C5=A1_Turek?= <8an@praha12.net>
Reply-To: 8an@praha12.net
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC] API for setting ACK timeout
Date: Thu, 26 Nov 2009 20:14:57 +0100
Cc: linux-wireless@vger.kernel.org
References: <200911261826.08576.8an@praha12.net> <1259259493.24540.5.camel@johannes.local>
In-Reply-To: <1259259493.24540.5.camel@johannes.local>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2178116.P9MDOUYjod";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200911262015.03106.8an@praha12.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart2178116.P9MDOUYjod
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On 26.11.2009 19:18 Johannes Berg wrote:
> I discussed this with Alina a while back (in private, she didn't want to
> discuss in English) and we came to the conclusion that set_coverage()
> should be done like 802.11-2007 17.3.8.6 specifies for 5ghz, but could
> be done for 2.4ghz as well. Thoughts? It would also allow us to actually
> advertise that to compatible clients.

If I understand the standard correctly, it means the slottime should be
(9 + propagation_delay), which equals (9 + distance / 300). And that's=20
basically the same as the formula from Madwifi's athctrl I wanted to use:
int slottime =3D 9 + (distance / 300) + ((distance % 300) ? 1 : 0);

The main difference is that the coverage classes have an upper limit under=
=20
28km, but I don't see the point in artifically limiting maximum link distan=
ce=20
(30km link could be done with big enough antennas).

And I would prefer if the userspace API operated with distance rather than=
=20
coverage classes, because it allows the user to set it correctly without=20
reading a thousand page document. The coverage class could be then calculat=
ed=20
for use in beacons as you proposed. Of course, in this case we would be=20
constrained by the maximum coverage class in the standard.

Lukas Turek

--nextPart2178116.P9MDOUYjod
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iQIcBAABAgAGBQJLDtO3AAoJEEBjvk/UOfYwRbIP/3vHQBJtEMgPvYNNNwK1iLEw
lZ9iOp35pzzXJu74M7F/GnKZsZC36nJKaHsyjmMbrDK1cvU/GgUALrDEIH7pM9qz
3m1Iq60VF//HwrNynzP3i6f6yZ9tWxWTVdXibw/EZugqYhp3JZ+i3dzZDolj0OkL
E+JyvV350o/8jamknKTKFC9n93CCtp1mKHNtqO5lY1MSl5yjKdkcnwInyu39AeTc
9M9KsWCf6IKhRJ4H3ozU13lGLX/YxcJMjCKKalQSzfxEtYhoAGhOePQnPeo2K/6L
p1ZwpM3jXAKI18JkZ2e+GjVdZR08OxWQqk7ioxBITo7+FszviMVqtti+uZ9+vUtQ
aLLG06O39bz+MiFdbE6/48VAJv6hB4aWOizrTkzgCF4+NogVOTWGwqEveacPUtR+
3qSt0+MNrKwaqSTrCmYCeC/GL95umu+IZwgLUflIRIYbm9cryhz/2PqEbGPY0jzx
m5avpGcMzvIbXbWFAHBnkA2gziDfu8OTi2Ay0r2NpEUA0vYGEWeEY3GYLoq7RHP9
e2CGP1rwSt0xAS4TOX8WH1Ee7R99gWnnIFly3KhzEj9WnuDT4uK5tYO9kCKifB+B
GAdA6NdyAtp3AHE2cO8A2xLC4JUMdOqr0DlAs2X6dAce6n2aA/9sdGg20P7luKsG
ZCvuLo4LVPYOlp4PqkKY
=D1Oa
-----END PGP SIGNATURE-----

--nextPart2178116.P9MDOUYjod--
