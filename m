Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:56744 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754352AbXLRNR3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Dec 2007 08:17:29 -0500
Subject: Re: [patch 1/9] mac80211: Clean up rate selection code
From: Johannes Berg <johannes@sipsolutions.net>
To: Mattias Nissler <mattias.nissler@gmx.de>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Stefano Brivio <stefano.brivio@polimi.it>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1197925653.7505.13.camel@localhost> (sfid-20071217_210805_440164_CFCDBD2D)
References: <20071217012517.882216322@gmx.de> >
	 <20071217012549.932807027@gmx.de> >
	 (sfid-20071217_012727_837272_3B5270C7)  <1197892019.4885.16.camel@johannes.berg>
	 <1197925653.7505.13.camel@localhost> (sfid-20071217_210805_440164_CFCDBD2D)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-W43V8x9kID5q0lQwFKet"
Date: Tue, 18 Dec 2007 14:17:24 +0100
Message-Id: <1197983844.4885.128.camel@johannes.berg> (sfid-20071218_131731_339074_F7033C60)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-W43V8x9kID5q0lQwFKet
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > > +	/* If a forced rate is in effect, select it. */
> > > +	sdata =3D IEEE80211_DEV_TO_SUB_IF(dev);
> > > +	if (sdata->bss && sdata->bss->force_unicast_rateidx > -1)
> > > +		sel->rate =3D &mode->rates[sdata->bss->force_unicast_rateidx];
> > > +
> > > +	/* If we haven't found the rate yet, ask the rate control algo. */
> > > +	if (!sel->rate)
> > > +		ref->ops->get_rate(ref->priv, dev, mode, skb, sel);
> >=20
> > Maybe after this we should insert
> >=20
> > 	if (unlikely(!sel->rate)) {
> > 		WARN_ON(1);
> > 		sel->rate =3D rate_lowest(...);
> > 	}
> >=20
> > Not sure though.
>=20
> I don't think we need this. Rate control is supposed to select a rate,
> if it doesn't know it can assign a fallback rate itself.

Obviously. I just thought we could protect against buggy rate control
algorithm code that way. Not really necessary though.

johannes

--=-W43V8x9kID5q0lQwFKet
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR2fIY6Vg1VMiehFYAQIr3Q/6Agd1aciwTqHF7Bw4v0DP8gyBHXjNWgrM
9ASJPxXtYqDcj0SvsbUgFXcBPv+Zv1FOcazqI0dioDEhPQ8M3LWctJunKDvtRzis
PxtC6S8QbraU4n4b9ZBwxW2NqiSV+rEsA8qYHDNn6zqzCsC0oe9qnosRgHRuATXH
KIyg4mTDkvhjTM8ZtOu9CUT/YoOVG2wQEe6qEPYgh9ddM0iI8TpiLFMWyjN2gW1k
ZL2Ib4jQWsHSYdZuKXkBS14ap90DBjDgANxHDzQBRskBLBAxIiAp/dCK7qAvnZRM
0uwRERHYbHpqWW9dNB4nLajNs2J3dx9PjV4kICSruXQWWk1JpWLW7uGxzt8+QA7d
iOcOaIo8DJgyYMHWlSsjzPEqt35ROQd5s+RAfpUs0Ws7ztmsmAJ/mCCMwrSu83gk
W8monR/WAt9L8inK2dVW4+sdAw3JB6Gv4m8xaIbg9vI1k231kju9fiokScfptzBq
f0ZmZ+euTXVch2m88VmOhwrABKh73gYJFyerjr8vN0jc6uFCCUqKgO6NNeUBX2/o
bw4Li4SNpELwkrPJdFyWdWKRAwG28DNie6Nnx8JaMWpe3YiXW22FwUaGXsW8oRLh
fPMe82A6JdnbN2wCf+bnhPlgG+me9wl7UuQ1hNb4o+vyP9OQa/P11yCUHg97FK2m
FvzFldvK6ug=
=2F7v
-----END PGP SIGNATURE-----

--=-W43V8x9kID5q0lQwFKet--

