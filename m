Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:50328 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757018AbYCQUCs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Mar 2008 16:02:48 -0400
Subject: Re: [ipw3945-devel] [PATCH 2/5] mac80211: allows driver to request
	a Phase 1 RX key
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Reinette Chatre <reinette.chatre@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
In-Reply-To: <1ba2fa240803171254j2709011ax7522bb05ded04aeb@mail.gmail.com> (sfid-20080317_195428_665856_58754025)
References: <1205366762-12828-1-git-send-email-reinette.chatre@intel.com>
	 <1205366762-12828-2-git-send-email-reinette.chatre@intel.com>
	 <1205366762-12828-3-git-send-email-reinette.chatre@intel.com>
	 <1205608293.15910.53.camel@johannes.berg>
	 <1ba2fa240803161704r36b5df43q33c953d698b88590@mail.gmail.com>
	 <1205753998.1614.34.camel@johannes.berg>
	 <1ba2fa240803170603g58cd5378n4e8e58b62c41c37c@mail.gmail.com>
	 <1205759599.1614.69.camel@johannes.berg>
	 <1ba2fa240803170745x4d70cc0esd4b49ebf85d68267@mail.gmail.com>
	 <1205766247.1614.111.camel@johannes.berg>
	 <1ba2fa240803171254j2709011ax7522bb05ded04aeb@mail.gmail.com>
	 (sfid-20080317_195428_665856_58754025)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-r4VbzCoy8KGmIs3Xu50F"
Date: Mon, 17 Mar 2008 21:02:29 +0100
Message-Id: <1205784149.16475.30.camel@johannes.berg> (sfid-20080317_202443_765756_7543FE29)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-r4VbzCoy8KGmIs3Xu50F
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> >  Right, in software we can keep a phase1 per AC but we don't need to in
> >  hardware since that's just the optimisation.
>=20
> Correct, I'm just not sure how it's done for bcom cards.

I'm not entirely sure right now either.

> Eventually you want to update RX phase1 key into HW so you get your
> CPU utilization where it have to be, right?

Yeah, you would :) But that's something we're addressing anyway since
iwlwifi needs it too.

> >  > Phase1 for TX and RX are not the same, again because of the simple
> >  > reasone that number of transmitted and received packet is not the
> >  > same.
> >
> >  Hm, right. But if we go for pull mode for TX, we only need to have pus=
h
> >  mode for the phase1 rx key when that changes, no?
>=20
> Emmanuel has prepared patches for TX pull mode  (phase2 only for now) .
> If this OK wiith I will resend the whole TKIP series with this change,
> leaving RX in pull mode.

You mean "RX in push mode" I think. Could you change that to a new
callback or so then as we discussed?

johannes

--=-r4VbzCoy8KGmIs3Xu50F
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR97OVKVg1VMiehFYAQL74g//ZZVTl4FwZDYLw5NEvDAq/o2ByqT3FtTP
AjyKCVj92Vv5mVerjzw/tP0DpZqAl2e+cBP6C0QvKW8yNU6Iz6Wlon4XdCd6eme0
fbYqEutQ54nnYIzFtckXIbQ+iS37X9EDLPcd6AVBqNo7QY/g0jVt8IT4Xjwte1yq
fY7YPfU428hdCA79x+qwKyUdTScPvWlhRK1/vaFfb3dN12wceMSu39+HnS3aksVM
/+Imy06WXsHuW7T9H8FpNZibHXk43ioztyMfG1guD4qx9KwWEv835cPKD55ujrEM
Si0V/tEauDyy91eP4rh8XT7aY21Q85xWH6OkFVxyjhEPOuerNBQi1UTzORiJQEOa
kszU6us0879bfqXCigcSaKlypV1XN5cmkq0zvHIfcei2UICBJV0albJIKWtgQbjp
lzCMnrhi8CMR8MS4J6I7Nh0YrBH5gobExvzsyc1piZ3AnwStqN3LsLF/Nyvm3v81
hXsN2SCJQwj7m+sZnAvDMwelj3aI6kPbtCFwhC0CISPj9C/59E2nZixto5kCj9ui
7s6aVpL+19FpjludNCHtZKaOx1nBLq+R2u2wuMptk69zPhwHPYH6yI0luf6qgNK2
FbLRZUoMOTidGlhwOlw6FO3IONPcX4kvjEcMYedzvGKjVCX9TOzgnA/uO7TrMTn3
DLT5DSCOet4=
=kIcl
-----END PGP SIGNATURE-----

--=-r4VbzCoy8KGmIs3Xu50F--

