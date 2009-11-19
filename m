Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54179 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753589AbZKSW3a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Nov 2009 17:29:30 -0500
Subject: Re: mesh endian bugs
From: Johannes Berg <johannes@sipsolutions.net>
To: Rui Paulo <rpaulo@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <7CA4D235-AFC1-4B4A-9025-3A426997706C@gmail.com>
References: <1258638691.7094.16.camel@johannes.local>
	 <7CA4D235-AFC1-4B4A-9025-3A426997706C@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-ZhV3Q7bTmIOyagjrWP1p"
Date: Thu, 19 Nov 2009 23:29:34 +0100
Message-ID: <1258669774.7094.27.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ZhV3Q7bTmIOyagjrWP1p
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-11-19 at 15:50 +0000, Rui Paulo wrote:
> Hi,
>=20
> On 19 Nov 2009, at 13:51, Johannes Berg wrote:
>=20
> >  CHECK   /home/johannes/sys/wireless-testing/net/mac80211/mesh_pathtbl.=
c
> > /home/johannes/sys/wireless-testing/net/mac80211/mesh_pathtbl.c:471:41:=
 warning: incorrect type in argument 4 (different base types)
> > /home/johannes/sys/wireless-testing/net/mac80211/mesh_pathtbl.c:471:41:=
    expected restricted __le16 [usertype] target_rcode
> > /home/johannes/sys/wireless-testing/net/mac80211/mesh_pathtbl.c:471:41:=
    got int
> > /home/johannes/sys/wireless-testing/net/mac80211/mesh_pathtbl.c:617:36:=
 warning: incorrect type in argument 4 (different base types)
> > /home/johannes/sys/wireless-testing/net/mac80211/mesh_pathtbl.c:617:36:=
    expected restricted __le16 [usertype] target_rcode
> > /home/johannes/sys/wireless-testing/net/mac80211/mesh_pathtbl.c:617:36:=
    got int
>=20
> Thanks Johannes. How does one perform this check?

make M=3Dnet/mac80211 C=3D1

However, due to a stupid kmemcheck thing it's broken, runs into an error
in skbuff.h and you need to fix that first by removing the :16 on that
line.

johannes

--=-ZhV3Q7bTmIOyagjrWP1p
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLBcbIAAoJEODzc/N7+QmayU8QAIjLwYXfgeMzznu9sBrLQjc0
ux4vNDId5R1/cejy4hzZpKgH1k3C6/mDWdz+7Eg9gHH8xwQMUOYB4qf8u4W/g2ZS
1bUnuYesIXosujLgcTeJyajcC13M6cnbY+H80l8w0L2sXVPXgoxuVvcbKUgIft8O
NCV2n2cv5w/oceMMui3DphKwsYuDTe/g0nOJ1JZhnMbdxKAbl0v26MlfvhXqTsRu
f0+4steGGwBew0it25HfbDNxiYkTAa9n0JLLN/WhCLiTxsGevNVG4Nkx0sLLfycb
huPR6FmoboLb+e0h5zkzM/GSeTTRf1UTFukk7Foi7WUtCMd7ywG5zIoqeBrNKl/O
n1wALUp4Y7lMCxkFx8+JmDJPN6YlnrebEO2vtKXShqo9T4m0sbabRzwrTSPV6k/E
YoI+a4enG+gwAXYSwi4VDm1/8fyutBKNuT+NNhE92ZSBsP6lcz5IRXcYu1a0Dwb2
N/wbSW2rbk53kN9/xjaIt8mghujB/qQDH7/33c6NruAmZg7CYscqCMMlEWAsd39W
r7DA6Dh80FYRlnLkYnOs/ZSAryRsljPzLTxvd08oILF8JI9AUkrC4v8jSBHF2YY6
M87pt2kq2DCe9xyI+zBdyfSEhgsvi4bq0YctsANpGG5edkkoDAxUw+kTXNJhKtWt
rhNVpo6LENq+DS1epq/Y
=i+PI
-----END PGP SIGNATURE-----

--=-ZhV3Q7bTmIOyagjrWP1p--

