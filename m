Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:39450 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752474AbYCGIYf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Mar 2008 03:24:35 -0500
Subject: Re: sending ARP triggers BUG
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhu Yi <yi.zhu@intel.com>
Cc: David Miller <davem@davemloft.net>, linux-wireless@vger.kernel.org
In-Reply-To: <1204873461.3087.187.camel@debian.sh.intel.com>
References: <D936D925018D154694D8A362EEB0892003ABCBD2@orsmsx416.amr.corp.intel.com>
	 <1203468968.10983.13.camel@johannes.berg>
	 <20080220.223622.148453409.davem@davemloft.net>
	 <1204873461.3087.187.camel@debian.sh.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-RrmeAwM5WyJV6SigQOVZ"
Date: Fri, 07 Mar 2008 09:24:06 +0100
Message-Id: <1204878246.25502.139.camel@johannes.berg> (sfid-20080307_082440_840971_98437620)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-RrmeAwM5WyJV6SigQOVZ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Fri, 2008-03-07 at 15:04 +0800, Zhu Yi wrote:
> On Wed, 2008-02-20 at 22:36 -0800, David Miller wrote:
> > From: Johannes Berg <johannes@sipsolutions.net>
> > Date: Wed, 20 Feb 2008 01:56:08 +0100
>=20
> > > Interestingly, I'm starting to see skb problems as well, in AP mode
> > > only however, namely I get lots of
> > >
> > > [ 4340.665679] SKB BUG: Invalid truesize (240) len=3D73, sizeof(sk_bu=
ff)=3D176
>=20
> OK. I started to see this also after I began to play with the AP mode.
>=20
> SKB BUG: Invalid truesize (272) len=3D71, sizeof(sk_buff)=3D208
>=20
> I get this for every ping packet from the AP to the client and only
> occasionally if I ping AP from client. According to the call trace, it's
> from the AP receive path.

You get this whenever you have monitor interfaces operating at the same
time. At least cooked monitor. Haven't had a chance to investigate, but
some change in the rest of the kernel seems to have caused this. Might
well be that we're doing something wrong with the SKBs in our monitor
functions though

johannes

--=-RrmeAwM5WyJV6SigQOVZ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR9D7pKVg1VMiehFYAQKF1A/+O+6GiM3st9Paiw0tf/W9aSjmFHqiE3Oa
J5ds5dNiKzpLrS38fbiR9EK3h0dRbMy3OYWxqWFLiwlxhEpdE8BT2SoWmjjKhpXe
I5lpLbvtnOXNtYMWVtkW2SArvpH3F/n5HG0+Qtk+jVyTvjd5ZSniN2dGMx/pYFFg
nfE/fbwWerf+4/VIBqtClgMYpY2kJ7e4Py7djvREghYouscUZSXvsLZOZb0S6Btv
1Yf/nD0DXcrYJhsgoimdy2wlFP2LmUdhVCObD21xn3KMgAsld8rzgNT2Pi+E5cKe
DgI0+TdqobLjupOCDntlQXPN8x9bBX0JvE5M5HuUr9rTMgw3ctTGGygUSFYDlzFC
Gs3hg1WsVsxfAgkuLTelmwn04XebTIkxmS9azLXpjrRYkllXbup4UcFmxifDEgK7
Yv2AibKDz+o72Om7YrvCt0Rc9ExHtOQz0QB+RS/7tzalnJP0+ofqSNNwLi/tSar4
iMYxfF8qD3tDJUZsp96zUGHBSEuNnJBtF31YkNKsAHGrXX3aWAer/vcTkRBYkLUm
nJkj/L43lSlsxqQaVNFG2c05GpqYZrD3MkvmSLmYj8rwjeZMKuCJvO5lgVJoIXgT
qeeDLX3CDOqY+Tx9KGhYXf3BGP4mBK2kgbCPz3L8Kyf9pQoq0iFx0Q2YB30kK0Ik
pvNfCELghus=
=FFIA
-----END PGP SIGNATURE-----

--=-RrmeAwM5WyJV6SigQOVZ--

