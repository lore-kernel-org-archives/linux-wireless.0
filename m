Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from parez.praha12.net ([78.108.102.1]:40972 "EHLO parez.praha12.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752138AbZLUMkw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Dec 2009 07:40:52 -0500
From: =?utf-8?q?Luk=C3=A1=C5=A1_Turek?= <8an@praha12.net>
Reply-To: 8an@praha12.net
To: =?utf-8?q?=E6=B5=B7=E8=97=BB=E6=95=AC=E4=B9=8B?=
	<tkaiso@thinktube.com>
Subject: Re: [ath5k-devel] [PATCH 4/5] ath5k: Reimplement clock rate to usec conversion
Date: Mon, 21 Dec 2009 13:40:51 +0100
Cc: johannes@sipsolutions.net, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com
References: <1260899813-17585-1-git-send-email-8an@praha12.net> <4B2F4D3A.4050009@thinktube.com> <4B2F50DD.60701@thinktube.com>
In-Reply-To: <4B2F50DD.60701@thinktube.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1784697.ZiIMJaiOzK";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200912211340.51229.8an@praha12.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1784697.ZiIMJaiOzK
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On 21.12.2009 11:41 =E6=B5=B7=E8=97=BB=E6=95=AC=E4=B9=8B wrote:
> =C2=A0In ath5k_hw_write_ofdm_timings(), =C2=A0comment says
> =C2=A0 =C2=A0 =C2=A0 "ALGO: coef =3D (5 * clock * carrier_freq) / 2) ",
> =C2=A0but current code is
> =C2=A0 =C2=A0 =C2=A0 "coef_scaled =3D ((5 * (clock << 24)) / 2) / channel=
=2D>center_freq;"
>
> =C2=A0Did they match each other ?
> =C2=A0I am wondering the the comment is wrong, but I am not sure that eit=
her
> is wrong.
Good point, it seems the comment is wrong. The calculation would overflow=20
32-bit integer if there was a multiplication instead of a division.

Lukas Turek

--nextPart1784697.ZiIMJaiOzK
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iQIcBAABAgAGBQJLL2zTAAoJEEBjvk/UOfYwpMwP/1Bc7AZy9Vl+DFRySpIgVozj
xhMrXlJGn4R0aCiHpsys9Eo/3c2zuS5X8X6qLMz7q7EMs6xWRhKGt4i7uKRWtntE
oAHD6nfPqUIL6foiqwsHCZBew1+Iap+kcZW6axgWMFZpkSReU4/ca7xzOujorK8y
nn2+QmR2u6UO6k+lEnN3z6GQ+W1y+it2uCKSApL1MQsJAJ0wltT8QJPQlQR8JhUz
vkAaUSg6pAx0aBBXAwPrk8oe4ZeFmyAY4ShMS6HaWKc86dRcZiZXSJHcx4Q/kRJN
PQ86FUgp8qObDmfQEEJKELcRKxgkbZE4CPpnnmUVWFun5S0YuTbZuFNhtYJHfaOw
84uuYNbBw1jg8XIUAC5iG/igMDNbpovS7QPheT25S9/eM8KV3anwknpkug0PcuZ5
DItXSmiGkfaskfmt3NHxGZZ3Qf2nVtg2+wnU1Qwm+07MCHpJacBw+oUlICOGXxbJ
m/37sctbqYqRR4JOiaePd/gf+H4VFG+TOH5oCvQS6PtWTgIl/6BzUBfOUHyI1l3O
WPSno4Td7rGRFMTgSYgWkDGOOf2Abm430RXd7HeTOq7SlSPpeaqFFJsbKqEhtoh8
l5x+rOeIGhVexNV2b6lG3Mk8o+yUHpjhVuOlw5LN5j7tO8RvJR1qBgOA1Nfq6Nj0
pdyvDDM2mDOPsNcjTVBj
=m4Ee
-----END PGP SIGNATURE-----

--nextPart1784697.ZiIMJaiOzK--
