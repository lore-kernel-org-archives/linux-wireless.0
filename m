Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:46275 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106AbXLYKjk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Dec 2007 05:39:40 -0500
Subject: Re: [PATCH 5/8 v2] mac80211: A-MPDU Rx handling aggregation
	reordering
From: Johannes Berg <johannes@sipsolutions.net>
To: Ron Rindjunsky <ron.rindjunsky@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com, yi.zhu@intel.com
In-Reply-To: <c85cb4470712250208y29318fb6w2d140d00c3e02933@mail.gmail.com> (sfid-20071225_100839_457657_600FEB9C)
References: <11981435524069-git-send-email-ron.rindjunsky@intel.com>
	 <11981435613464-git-send-email-ron.rindjunsky@intel.com>
	 <1198170867.16241.56.camel@johannes.berg>
	 <c85cb4470712250208y29318fb6w2d140d00c3e02933@mail.gmail.com>
	 (sfid-20071225_100839_457657_600FEB9C)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Ekby4XWaOBGUQ8lBjOjW"
Date: Tue, 25 Dec 2007 11:39:29 +0100
Message-Id: <1198579169.4103.51.camel@johannes.berg> (sfid-20071225_103948_565797_8EBE2064)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Ekby4XWaOBGUQ8lBjOjW
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> No, and it should be done.
> were would you recommend to put this tear down? i need a flow were i
> can be sta specific, and is called only once per ifdown.
> sta_info_release related flow, were i thought to put it, is risking me
> with endless loops of kref_put calls.

That's actually an interesting question. We should, like with keys,
remove all STA info from the driver when the corresponding interface is
down. I'd think it should happen at the same time. I guess you'll have
to add some sort of loop to tear down stations to the down code, I don't
really see any easy way right now.

johannes

--=-Ekby4XWaOBGUQ8lBjOjW
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR3Dd36Vg1VMiehFYAQJ05Q//QABxYX2VncHsEo+pEp7pIWHzacKYudqR
+H1cWvSalzWCzQBirrN4gSwD5gSleRarJut8aJUyzS+V3HOmK7dZKsF50pFjKV8Z
cYuJDiqb0NkN+Yrdj6HB6sUS4UYAENS67zGIYWmtXBvpeGARtRdI03QkOhpKbYG8
w8jUHPPgkE7qsgqxhj0OXiQByFhW5LQzyElm/IDwezTazs+U6avJIJgG2LjuoQQH
UBnVB8J9l0+Wst/0Y34MoUpYvxznZrPhqi46UPBchkDfcXpj8Y34qgej8Y2OSov4
1LWW4MwUlR3UKs1eBgeXzODe4OuIU0kTSQd2J03yWaw5+yYgN5egggyxugOqgq5C
bf6Xo0scfosI8toKKBdxR5dMllWk/P87tn52BmHd7X4s4pD1Uyoocgwdz2g1mkws
2pSpCzDrb/e4dC0GxZbqrdKYIQ+pk8pkUA7oJYj5mwgK0bYfocqPxHSQm5ZTbL9L
u4BoU7u/i8iFHM1gONL/rqtpEkgPT0fT8Kjng/DPQegmTF6OlTTq43JjOR3PUnPs
LYE+jtGDJzwM2MrJ/ymx9FMCMTtGiMhHlkgnt0ei7pzrjJUecqgGquGvMPT6oeay
8Gp/1hDkwterG0WkadlhEsqCOjbmigaGSHHgSQPGoELBc08PIMdD5LVpVWwUI9D6
HnFmpYn6J7M=
=ZZbM
-----END PGP SIGNATURE-----

--=-Ekby4XWaOBGUQ8lBjOjW--

