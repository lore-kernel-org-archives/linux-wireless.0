Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:33752 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752989AbZEUN4a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 May 2009 09:56:30 -0400
Subject: Re: [PATCH 1/2] wireless: move some utility functions from
 mac80211 to cfg80211
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Zhu Yi <yi.zhu@intel.com>, drago01 <drago01@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Ortiz, Samuel" <samuel.ortiz@intel.com>
In-Reply-To: <20090521133839.GA2744@tuxdriver.com>
References: <1242872340-27417-1-git-send-email-yi.zhu@intel.com>
	 <1242872340-27417-2-git-send-email-yi.zhu@intel.com>
	 <f6ca9fed0905210012t2b494db5w3169ef2e8db2b04b@mail.gmail.com>
	 <1242889781.24825.611.camel@debian>
	 <1242897719.5471.1.camel@johannes.local>
	 <20090521133839.GA2744@tuxdriver.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-BFVPT+sBM6jVJRc6YhAb"
Date: Thu, 21 May 2009 15:56:28 +0200
Message-Id: <1242914188.4212.7.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-BFVPT+sBM6jVJRc6YhAb
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-05-21 at 09:38 -0400, John W. Linville wrote:
> On Thu, May 21, 2009 at 11:21:59AM +0200, Johannes Berg wrote:
> > On Thu, 2009-05-21 at 15:09 +0800, Zhu Yi wrote:
> >=20
> > > > Isn't lib80211 a better place for those ?
> > > > Its purpose is sharing code between fullmac and softmac drivers.
> > >=20
> > > These functions are moved from mac80211 which currently doesn't link
> > > with lib80211. Johannes might have more to comment.
> >=20
> > Yeah, lib80211's stated purpose is to share code, but on the other hand
> > code that mac80211 and fullmac drivers may need seems better suited in
> > cfg80211 since lib80211 also ships a large code bit of crypto routines
> > etc. that are just useless for this and mac80211.
>=20
> The crypto stuff is mostly in separate modules.
>=20
> I would rather see these in lib80211, but I'll work that out myself.

Heh. And I asked them to put it here... Then again, lib80211_crypt_*
only exists for hostap and ipw2x00, so maybe we should separate that out
into a separate lib80211_crypt module? That would leave lib80211 only
with print_ssid, of course...

Basically I still think having lib80211 is pretty much pointless since
all future fullmac drivers and mac80211 all need to use cfg80211.

johannes


--=-BFVPT+sBM6jVJRc6YhAb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKFV2IAAoJEODzc/N7+Qma8+wP/RqrfsXkMDGtJh5xSpYJTWTm
vHb/+WfCgPbtrtxcLA1/t/chP0WiaQlAQ1TKqhlWPs6MiBHqBvtsVH9/jxSJZrMS
6uz7jk0IXNCUR7MWzWyWivc8ymEek2t4bDreOnQy5Q984QyswLGfo2Y6Hx4aBNIr
6cFyJlPS7jauB+fwUupIaoyaPNBPvaKgYfp+FMdhuSNgGvMfIALd+/H7ZS8PhKLZ
EgUpPPFdPvcp0xFCn6fu0zMVSwQUu/CGlfW8qim4laBfgkHk5DDGoS4/pQme+n3T
sEB0iAnE99Dp7PmUka948OV/IPOzVOdqRL010HYhiNhFDIfzM/mpESEebS+fuSU4
9TlxUAYT6qGd9j4z8Bv3d4jgDWdkX7T9Lsdnuv6lMA3Dryjvx9l9TKLq5QZeAlpt
A8K+MZEY1gLo7Uwquzn9e8ZuJOSVXaKqyyKS24MvxDXRwZxk5H66DalsBe71xGaA
qqsKDudyvqUaABZFponzTqDozjDO/3vnwrsnXclNuyCNIhET2izUvdZIibkV2yQ7
WnpC9ti+31keNJ0T78Jugj3IFBOgSk78qcFXZ7AhoAkGDMdT5ncCMoTENnPjqkzG
FGLS7etnQVxRZ1XMwSeGi8Tl+ZSZMaZPQ7u+KpEzipAqCGOHBuKP9GumzKKITvi/
+RgTkg1ECzbH1FJ0Jwbk
=bjB3
-----END PGP SIGNATURE-----

--=-BFVPT+sBM6jVJRc6YhAb--

